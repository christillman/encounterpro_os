DROP PROCEDURE [jmjsys_add_actor]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [jmjsys_add_actor] (
	@puid_actor_id uniqueidentifier OUTPUT,
	@pl_owner_id INTEGER,
	@ps_actor_class VARCHAR(12),
	@ps_actor_name VARCHAR(64),
	@ps_status VARCHAR(12),
	@ps_user_id VARCHAR(24) = NULL,
	@ps_user_full_name VARCHAR(64) = NULL,
	@ps_specialty_id varchar(24) = NULL,
	@ps_first_name varchar(20) = NULL,
	@ps_middle_name varchar(20) = NULL,
	@ps_last_name varchar(20) = NULL,
	@ps_dea_number varchar(18) = NULL,
	@ps_license_number varchar(40) = NULL,
	@ps_upin varchar(24) = NULL,
	@ps_npi varchar(40) = NULL
	)	
AS

SET NOCOUNT ON

DECLARE @luid_actor_id uniqueidentifier,
	@ls_database_mode varchar(12),
	@ll_existing_owner_id INTEGER,
	@ls_existing_user_id VARCHAR(24),
	@ls_exists char(1),
	@ll_count int,
	@ll_error int

SET @ps_npi = CASE WHEN RTRIM(@ps_npi) = '' THEN NULL ELSE RTRIM(@ps_npi) END

IF @pl_owner_id IS NULL
	BEGIN
	RAISERROR ('@pl_owner_id must not be null',16,-1)
	RETURN -1
	END

-- Get the database mode to decide whether to insert them into testing or production
SELECT @ls_database_mode = max(database_mode)
FROM c_Database_Status

SET @luid_actor_id = NULL
SET @ls_exists = 'N'

IF @ls_database_mode IS NULL OR @ls_database_mode = 'Testing'
	BEGIN
	IF @puid_actor_id IS NULL
		BEGIN
		IF @ps_user_id IS NOT NULL
			BEGIN
			SELECT @luid_actor_id = id
			FROM jmjtech.EproUpdates_Testing.dbo.c_Actor
			WHERE owner_id = @pl_owner_id
			AND [user_id] = @ps_user_id

			SELECT @ll_count = @@ROWCOUNT,
					@ll_error = @@ERROR

			IF @ll_error <> 0
				RETURN -1

			IF @ll_count > 0
				SET @ls_exists = 'Y'
			END
		END
	ELSE
		BEGIN
		SET @luid_actor_id = @puid_actor_id

		-- Check to see if this actor already exists
		SELECT @ll_existing_owner_id = owner_id,
				@ls_existing_user_id = [user_id]
		FROM jmjtech.EproUpdates_Testing.dbo.c_Actor
		WHERE id = @puid_actor_id

		SELECT @ll_count = @@ROWCOUNT,
				@ll_error = @@ERROR

		IF @ll_error <> 0
			RETURN -1

		IF @ll_count = 0
			BEGIN
			-- Check to see if this actor already exists
			SELECT @luid_actor_id = id
			FROM jmjtech.EproUpdates_Testing.dbo.c_Actor
			WHERE owner_id = @pl_owner_id
			AND [user_id] = @ps_user_id

			SELECT @ll_count = @@ROWCOUNT,
					@ll_error = @@ERROR

			IF @ll_error <> 0
				RETURN -1

			IF @ll_count > 0
				BEGIN
				-- This is an error condition.  The eproupdates actor table already has a record for this owner_id/user_id,
				-- but the existing record has the wrong ID
				RAISERROR ('ERROR:  The eproupdates actor table already has a record for this owner_id/user_id (%d, %s)',16,-1, @pl_owner_id, @ps_user_id)
				RETURN -1
				END
			END
		ELSE
			SET @ls_exists = 'Y'
		END


	IF @ls_exists = 'Y'
		BEGIN
		UPDATE a
		SET actor_name = @ps_actor_name,
			status = @ps_status,
			user_full_name=@ps_user_full_name,
			specialty_id=@ps_specialty_id,
			first_name=@ps_first_name,
			middle_name=@ps_middle_name,
			last_name=@ps_last_name,
			dea_number=@ps_dea_number,
			license_number=@ps_license_number,
			upin=@ps_upin,
			npi=@ps_npi
		FROM jmjtech.EproUpdates_Testing.dbo.c_Actor a
		WHERE a.id=@luid_actor_id

		SELECT @ll_count = @@ROWCOUNT,
				@ll_error = @@ERROR

		IF @ll_error <> 0
			RETURN -1
		END
	ELSE
		BEGIN
		IF @luid_actor_id IS NULL
			SET @luid_actor_id = newid()

		INSERT INTO jmjtech.EproUpdates_Testing.dbo.c_Actor( 
			id,
			owner_id,
			actor_class,
			actor_name,
			specialty_id,
			first_name,
			middle_name,
			last_name,
			dea_number,
			license_number,
			upin,
			npi,
			user_id,
			user_full_name,
			status
			) 
		VALUES (
			@luid_actor_id,
			@pl_owner_id,
			@ps_actor_class,
			@ps_actor_name,
			@ps_specialty_id,
			@ps_first_name,
			@ps_middle_name,
			@ps_last_name,
			@ps_dea_number,
			@ps_license_number,
			@ps_upin,
			@ps_npi,
			@ps_user_id,
			@ps_user_full_name,
			@ps_status
			)

		SELECT @ll_count = @@ROWCOUNT,
				@ll_error = @@ERROR

		IF @ll_error <> 0
			RETURN -1
		END
	END
ELSE 
-- Insert them into production
	BEGIN
	IF @puid_actor_id IS NULL
		BEGIN
		IF @ps_user_id IS NOT NULL
			BEGIN
			SELECT @luid_actor_id = id
			FROM jmjtech.EproUpdates.dbo.c_Actor
			WHERE owner_id = @pl_owner_id
			AND [user_id] = @ps_user_id

			SELECT @ll_count = @@ROWCOUNT,
					@ll_error = @@ERROR

			IF @ll_error <> 0
				RETURN -1

			IF @ll_count > 0
				SET @ls_exists = 'Y'
			END
		END
	ELSE
		BEGIN
		SET @luid_actor_id = @puid_actor_id

		-- Check to see if this actor already exists
		SELECT @ll_existing_owner_id = owner_id,
				@ls_existing_user_id = [user_id]
		FROM jmjtech.EproUpdates.dbo.c_Actor
		WHERE id = @puid_actor_id

		SELECT @ll_count = @@ROWCOUNT,
				@ll_error = @@ERROR

		IF @ll_error <> 0
			RETURN -1

		IF @ll_count = 0
			BEGIN
			-- Check to see if this actor already exists
			SELECT @luid_actor_id = id
			FROM jmjtech.EproUpdates.dbo.c_Actor
			WHERE owner_id = @pl_owner_id
			AND [user_id] = @ps_user_id

			SELECT @ll_count = @@ROWCOUNT,
					@ll_error = @@ERROR

			IF @ll_error <> 0
				RETURN -1

			IF @ll_count > 0
				BEGIN
				-- This is an error condition.  The eproupdates actor table already has a record for this owner_id/user_id,
				-- but the existing record has the wrong ID
				RAISERROR ('ERROR:  The eproupdates actor table already has a record for this owner_id/user_id (%d, %s)',16,-1, @pl_owner_id, @ps_user_id)
				RETURN -1
				END
			END
		ELSE
			SET @ls_exists = 'Y'
		END


	IF @ls_exists = 'Y'
		BEGIN
		UPDATE a
		SET actor_name = @ps_actor_name,
			status = @ps_status,
			user_full_name=@ps_user_full_name,
			specialty_id=@ps_specialty_id,
			first_name=@ps_first_name,
			middle_name=@ps_middle_name,
			last_name=@ps_last_name,
			dea_number=@ps_dea_number,
			license_number=@ps_license_number,
			upin=@ps_upin,
			npi=@ps_npi
		FROM jmjtech.EproUpdates.dbo.c_Actor a
		WHERE a.id=@luid_actor_id

		SELECT @ll_count = @@ROWCOUNT,
				@ll_error = @@ERROR

		IF @ll_error <> 0
			RETURN -1
		END
	ELSE
		BEGIN
		IF @luid_actor_id IS NULL
			SET @luid_actor_id = newid()

		INSERT INTO jmjtech.EproUpdates.dbo.c_Actor( 
			id,
			owner_id,
			actor_class,
			actor_name,
			specialty_id,
			first_name,
			middle_name,
			last_name,
			dea_number,
			license_number,
			upin,
			npi,
			user_id,
			user_full_name,
			status
			) 
		VALUES (
			@luid_actor_id,
			@pl_owner_id,
			@ps_actor_class,
			@ps_actor_name,
			@ps_specialty_id,
			@ps_first_name,
			@ps_middle_name,
			@ps_last_name,
			@ps_dea_number,
			@ps_license_number,
			@ps_upin,
			@ps_npi,
			@ps_user_id,
			@ps_user_full_name,
			@ps_status
			)

		SELECT @ll_count = @@ROWCOUNT,
				@ll_error = @@ERROR

		IF @ll_error <> 0
			RETURN -1
		END
	END

SET @puid_actor_id = @luid_actor_id
GO
GRANT EXECUTE ON [jmjsys_add_actor] TO [cprsystem] AS [dbo]
GO
