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

