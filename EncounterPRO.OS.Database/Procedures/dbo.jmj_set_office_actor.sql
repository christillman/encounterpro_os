
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
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE jmj_set_office_actor (
	@ps_unmapped_office_user_id varchar(24),
	@ps_mapped_to_office_id varchar(4),
	@ps_created_by varchar(24),
	@ps_mapped_office_user_id varchar(24) OUTPUT)
AS

DECLARE @ls_office_user_id varchar(24)

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

	IF @@ERROR <> 0
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
	dbo.get_client_datetime() ,
	[progress_type] ,
	[progress_key] ,
	[progress_value] ,
	dbo.get_client_datetime() ,
	@ps_created_by
FROM c_User_Progress
WHERE [user_id] = @ps_unmapped_office_user_id
AND progress_type = 'ID'
AND current_flag = 'Y'

IF @@ERROR <> 0
	RETURN -1

EXECUTE sp_Set_User_Progress @ps_user_id = @ps_unmapped_office_user_id,
								@ps_progress_user_id = @ps_created_by,
								@ps_progress_type = 'Modify',
								@ps_progress_key = 'status',
								@ps_progress = 'NA',
								@ps_created_by = @ps_created_by

IF @@ERROR <> 0
	RETURN -1

SET @ps_mapped_office_user_id = @ls_office_user_id

RETURN 1

GO
GRANT EXECUTE
	ON [dbo].[jmj_set_office_actor]
	TO [cprsystem]
GO

