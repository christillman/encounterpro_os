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

-- Drop Procedure [dbo].[jmj_new_menu_selection]
Print 'Drop Procedure [dbo].[jmj_new_menu_selection]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_new_menu_selection]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_new_menu_selection]
GO

-- Create Procedure [dbo].[jmj_new_menu_selection]
Print 'Create Procedure [dbo].[jmj_new_menu_selection]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_new_menu_selection
	(
	@pl_menu_id int,
	@ps_office_id varchar(4) = NULL,
	@ps_menu_context varchar(12),
	@ps_menu_key varchar(64) = NULL,
	@ps_user_id varchar(24) = NULL
	)
AS

DECLARE @ll_owner_id int,
		@ll_count int,
		@ll_error int,
		@ll_room_menu_selection_id int

IF @pl_menu_id IS NULL
	BEGIN
	RAISERROR ('menu_id cannot be null',16,-1)
	RETURN -1
	END

IF @ps_menu_context IS NULL
	BEGIN
	RAISERROR ('menu_context cannot be null',16,-1)
	RETURN -1
	END

SELECT @ll_owner_id = customer_id
FROM dbo.c_database_status

SELECT @ll_room_menu_selection_id = min(room_menu_selection_id)
FROM dbo.o_menu_selection
WHERE menu_context = @ps_menu_context
AND ISNULL(office_id, '!NULL') = @ps_office_id
AND ISNULL(menu_key, '!NULL') = @ps_menu_key
AND ISNULL(user_id, '!NULL') = @ps_user_id
AND status = 'OK'

SELECT @ll_error = @@ERROR,
		@ll_count = @@ROWCOUNT

IF @ll_error <> 0
	RETURN

IF @ll_room_menu_selection_id > 0
	UPDATE dbo.o_menu_selection
	SET menu_id = @pl_menu_id
	WHERE room_menu_selection_id = @ll_room_menu_selection_id
ELSE
	BEGIN
	INSERT INTO dbo.o_menu_selection
		(office_id
		,menu_context
		,menu_key
		,user_id
		,menu_id
		,sort_sequence
		,owner_id
		,status)
	VALUES (
		@ps_office_id,
		@ps_menu_context,
		@ps_menu_key,
		@ps_user_id,
		@pl_menu_id,
		1,
		@ll_owner_id,
		'OK')

	SET @ll_room_menu_selection_id = SCOPE_IDENTITY()
	END

RETURN @ll_room_menu_selection_id

GO
GRANT EXECUTE
	ON [dbo].[jmj_new_menu_selection]
	TO [cprsystem]
GO

