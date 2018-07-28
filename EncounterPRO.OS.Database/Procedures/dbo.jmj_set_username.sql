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

-- Drop Procedure [dbo].[jmj_set_username]
Print 'Drop Procedure [dbo].[jmj_set_username]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_set_username]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_set_username]
GO

-- Create Procedure [dbo].[jmj_set_username]
Print 'Create Procedure [dbo].[jmj_set_username]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_set_username (
	@ps_user_id varchar(24),
	@ps_new_username varchar(40) )
AS

DECLARE @ls_username varchar(40),
		@ll_count int,
		@ll_sts int,
		@ls_progress varchar(255)

IF @ps_user_id IS NULL
	BEGIN
	RAISERROR ('Null User_id',16,-1)
	RETURN -1
	END

IF @ps_new_username IS NULL
	BEGIN
	RAISERROR ('Null username',16,-1)
	RETURN -1
	END

BEGIN TRANSACTION

-- Get the current username and hold a table lock
SELECT @ls_username = username
FROM c_User WITH (TABLOCKX)
WHERE user_id = @ps_user_id

IF @@ROWCOUNT <> 1
	BEGIN
	RAISERROR ('User_id not found (%s)',16,-1, @ps_user_id)
	ROLLBACK TRANSACTION
	RETURN -1
	END

-- If it's the same username then we're done
IF @ls_username = @ps_new_username
	BEGIN
	COMMIT TRANSACTION
	RETURN 1
	END

SELECT @ll_count = count(*)
FROM c_User
WHERE username = @ps_new_username

IF @ll_count = 0
	BEGIN
	UPDATE c_User
	SET username = @ps_new_username
	WHERE user_id = @ps_user_id
	
	IF @@ERROR <> 0
		BEGIN
		RAISERROR ('New username (%s) is not unique',16,-1, @ps_new_username)
		ROLLBACK TRANSACTION
		RETURN -1
		END
	END
ELSE
	BEGIN
	RAISERROR ('New username (%s) is not unique',16,-1, @ps_new_username)
	ROLLBACK TRANSACTION
	RETURN 0
	END

COMMIT TRANSACTION

SET @ls_progress = 'From ' + ISNULL(@ls_username, 'NULL') + ' to ' + @ps_new_username 

EXECUTE sp_Set_User_Progress
	@ps_user_id = @ps_user_id,
	@ps_progress_user_id = '#SYSTEM',
	@ps_progress_type = 'Modify',
	@ps_progress_key = 'username',
	@ps_progress = @ls_progress,
	@ps_created_by = '#SYSTEM'

RETURN 1

GO
GRANT EXECUTE
	ON [dbo].[jmj_set_username]
	TO [cprsystem]
GO

