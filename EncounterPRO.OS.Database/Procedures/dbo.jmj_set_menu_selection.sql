﻿--EncounterPRO Open Source Project
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

-- Drop Procedure [dbo].[jmj_set_menu_selection]
Print 'Drop Procedure [dbo].[jmj_set_menu_selection]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_set_menu_selection]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_set_menu_selection]
GO

-- Create Procedure [dbo].[jmj_set_menu_selection]
Print 'Create Procedure [dbo].[jmj_set_menu_selection]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_set_menu_selection (
	@ps_menu_context varchar(12),
	@ps_menu_key varchar(64),
	@ps_office_id varchar(4) = NULL,
	@ps_user_id varchar(24) = NULL,
	@pl_menu_id int)
AS

DECLARE @ll_rowcount int,
		@ll_error int

IF @pl_menu_id IS NULL
	BEGIN
	DELETE o_Menu_Selection
	WHERE menu_context = @ps_menu_context
	AND menu_key = @ps_menu_key
	AND ISNULL(office_id, '!NUL') = ISNULL(@ps_office_id, '!NUL')
	AND ISNULL(user_id, '!NULL') = ISNULL(@ps_user_id, '!NULL')

	SELECT @ll_rowcount = @@ROWCOUNT,
			@ll_error = @@ERROR

	RETURN
	END
ELSE
	BEGIN
	UPDATE o_Menu_Selection
	SET menu_id = @pl_menu_id
	WHERE menu_context = @ps_menu_context
	AND menu_key = @ps_menu_key
	AND ISNULL(office_id, '!NUL') = ISNULL(@ps_office_id, '!NUL')
	AND ISNULL(user_id, '!NULL') = ISNULL(@ps_user_id, '!NULL')

	SELECT @ll_rowcount = @@ROWCOUNT,
			@ll_error = @@ERROR
	END


IF @ll_error <> 0
	RETURN

IF @ll_rowcount > 0
	RETURN

INSERT INTO o_Menu_Selection (
	menu_context,
	menu_key,
	office_id,
	user_id,
	menu_id)
VALUES (
	@ps_menu_context,
	@ps_menu_key,
	@ps_office_id,
	@ps_user_id,
	@pl_menu_id)

GO
GRANT EXECUTE
	ON [dbo].[jmj_set_menu_selection]
	TO [cprsystem]
GO

