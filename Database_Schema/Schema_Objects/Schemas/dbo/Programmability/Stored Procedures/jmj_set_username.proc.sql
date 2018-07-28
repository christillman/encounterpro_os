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

