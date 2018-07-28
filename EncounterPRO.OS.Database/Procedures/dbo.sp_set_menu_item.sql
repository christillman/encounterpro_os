--EncounterPRO Open Source Project
--
--Copyright 2010-2011 The EncounterPRO Foundation, Inc.
--
--This program is free software: you can redistribute it and/or modify it under the terms of 
--the GNU Affero General Public License as published by the Free Software Foundation, either 
--version 3 of the License, or (at your option) any later version.
--
--This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
--without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
--See the GNU Affero General Public License for more details.
--
--You should have received a copy of the GNU Affero General Public License along with this 
--program. If not, see http://www.gnu.org/licenses.
--
--EncounterPRO Open Source Project (“The Project”) is distributed under the GNU Affero 
--General Public License version 3, or any later version. As such, linking the Project 
--statically or dynamically with other components is making a combined work based on the 
--Project. Thus, the terms and conditions of the GNU Affero General Public License version 3, 
--or any later version, cover the whole combination.
--
--However, as an additional permission, the copyright holders of EncounterPRO Open Source 
--Project give you permission to link the Project with independent components, regardless of 
--the license terms of these independent components, provided that all of the following are true:
--
--1. All access from the independent component to persisted data which resides
--   inside any EncounterPRO Open Source data store (e.g. SQL Server database) 
--   be made through a publically available database driver (e.g. ODBC, SQL 
--   Native Client, etc) or through a service which itself is part of The Project.
--2. The independent component does not create or rely on any code or data 
--   structures within the EncounterPRO Open Source data store unless such 
--   code or data structures, and all code and data structures referred to 
--   by such code or data structures, are themselves part of The Project.
--3. The independent component either a) runs locally on the user's computer,
--   or b) is linked to at runtime by The Project’s Component Manager object 
--   which in turn is called by code which itself is part of The Project.
--
--An independent component is a component which is not derived from or based on the Project.
--If you modify the Project, you may extend this additional permission to your version of 
--the Project, but you are not obligated to do so. If you do not wish to do so, delete this 
--additional permission statement from your version.
--
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_set_menu_item]
Print 'Drop Procedure [dbo].[sp_set_menu_item]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_set_menu_item]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_set_menu_item]
GO

-- Create Procedure [dbo].[sp_set_menu_item]
Print 'Create Procedure [dbo].[sp_set_menu_item]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_set_menu_item
	(
	@pl_menu_id integer,
	@pl_menu_item_id int = NULL,
	@ps_menu_item_type varchar(24),
	@ps_menu_item varchar(24),
	@ps_button_title varchar(40),
	@ps_button_help varchar(255),
	@ps_button varchar(128),
	@pl_sort_sequence int,
	@pl_rtn_menu_item_id int OUTPUT
	)
AS

DECLARE @ll_menu_item_id int

-- If the record doesn't exist then create it
IF @pl_menu_item_id IS NULL
	BEGIN
	INSERT INTO c_Menu_Item (
		menu_id,
		menu_item_type,
		menu_item,
		button_title,
		button_help,
		button,
		sort_sequence)
	VALUES (
		@pl_menu_id,
		@ps_menu_item_type,
		@ps_menu_item,
		@ps_button_title,
		@ps_button_help,
		@ps_button,
		@pl_sort_sequence)
	
	SELECT @ll_menu_item_id = @@IDENTITY
	END
ELSE
	BEGIN
	UPDATE c_Menu_Item
	SET button_title = @ps_button_title,
	button_help = @ps_button_help,
	button = @ps_button,
	sort_sequence = @pl_sort_sequence
	WHERE menu_id = @pl_menu_id
	AND menu_item_id = @pl_menu_item_id

	SELECT @ll_menu_item_id = @pl_menu_item_id
	END

SELECT @pl_rtn_menu_item_id = @ll_menu_item_id

GO
GRANT EXECUTE
	ON [dbo].[sp_set_menu_item]
	TO [cprsystem]
GO

