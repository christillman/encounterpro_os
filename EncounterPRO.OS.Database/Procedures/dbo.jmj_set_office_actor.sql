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

-- Drop Procedure [dbo].[jmj_set_office_actor]
Print 'Drop Procedure [dbo].[jmj_set_office_actor]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_set_office_actor]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_set_office_actor]
GO

-- Create Procedure [dbo].[jmj_set_office_actor]
Print 'Create Procedure [dbo].[jmj_set_office_actor]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_set_office_actor (
	@ps_unmapped_office_user_id varchar(24),
	@ps_mapped_to_office_id varchar(4),
	@ps_created_by varchar(24),
	@ps_mapped_office_user_id varchar(24) OUTPUT)
AS

DECLARE @ls_office_user_id varchar(24),
		@ll_rowcount int,
		@ll_error int

IF @ps_unmapped_office_user_id IS NULL
	BEGIN
	RAISERROR ('Null user_id',16,-1)
	RETURN -1
	END

IF @ps_mapped_to_office_id IS NULL
	BEGIN
	RAISERROR ('Null office_id',16,-1)
	RETURN -1
	END

-- See if there is already an office actor for this office
SELECT @ls_office_user_id = max(user_id)
FROM c_User
WHERE actor_class = 'Office'
AND status = 'OK'
AND office_id = @ps_mapped_to_office_id

-- If there is no such office actor, then map the new actor to the office
IF @ls_office_user_id IS NULL
	BEGIN
	EXECUTE sp_Set_User_Progress @ps_user_id = @ps_unmapped_office_user_id,
									@ps_progress_user_id = @ps_created_by,
									@ps_progress_type = 'Modify',
									@ps_progress_key = 'office_id',
									@ps_progress = @ps_mapped_to_office_id,
									@ps_created_by = @ps_created_by

	SELECT @ll_rowcount = @@ROWCOUNT,
			@ll_error = @@ERROR

	IF @ll_error <> 0
		RETURN -1

	SET @ps_mapped_office_user_id = @ps_unmapped_office_user_id
	RETURN 1
	END

-- If it's already mapped, we're done
IF @ls_office_user_id = @ps_unmapped_office_user_id
	BEGIN
	RETURN 1
	SET @ps_mapped_office_user_id = @ls_office_user_id
	END

-- If a mapped office already exists, then disable the new actor and move any ID mappings
-- from the new actor to the existing actor

INSERT INTO c_User_Progress (
	[user_id] ,
	[progress_user_id] ,
	[progress_date_time] ,
	[progress_type] ,
	[progress_key] ,
	[progress_value] ,
	[created] ,
	[created_by] )
SELECT @ls_office_user_id ,
	@ps_created_by ,
	getdate() ,
	[progress_type] ,
	[progress_key] ,
	[progress_value] ,
	getdate() ,
	@ps_created_by
FROM c_User_Progress
WHERE user_id = @ps_unmapped_office_user_id
AND progress_type = 'ID'
AND current_flag = 'Y'

SELECT @ll_rowcount = @@ROWCOUNT,
		@ll_error = @@ERROR

IF @ll_error <> 0
	RETURN -1

EXECUTE sp_Set_User_Progress @ps_user_id = @ps_unmapped_office_user_id,
								@ps_progress_user_id = @ps_created_by,
								@ps_progress_type = 'Modify',
								@ps_progress_key = 'status',
								@ps_progress = 'NA',
								@ps_created_by = @ps_created_by

SELECT @ll_rowcount = @@ROWCOUNT,
		@ll_error = @@ERROR

IF @ll_error <> 0
	RETURN -1

SET @ps_mapped_office_user_id = @ls_office_user_id

RETURN 1

GO
GRANT EXECUTE
	ON [dbo].[jmj_set_office_actor]
	TO [cprsystem]
GO

