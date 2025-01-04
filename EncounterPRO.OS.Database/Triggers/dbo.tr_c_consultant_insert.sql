
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Trigger [dbo].[tr_c_consultant_insert]
Print 'Drop Trigger [dbo].[tr_c_consultant_insert]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_c_consultant_insert]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_c_consultant_insert]
GO

-- Create Trigger [dbo].[tr_c_consultant_insert]
Print 'Create Trigger [dbo].[tr_c_consultant_insert]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER tr_c_consultant_insert ON dbo.c_Consultant
FOR INSERT
AS

IF @@ROWCOUNT = 0
	RETURN


--
-- Copy the consultants to c_User
--
DECLARE @ls_consultant_id varchar(24),
		@ls_description varchar(80),
		@ll_actor_id int,
		@ls_address_line_1 varchar(40) ,
		@ls_address_line_2 varchar(40) ,
		@ls_city varchar(40) ,
		@ls_state varchar(2) ,
		@ls_zip varchar(10) ,
		@ls_phone varchar(32) ,
		@ls_phone2 varchar(32) ,
		@ls_fax varchar(32) ,
		@ls_email varchar(64) ,
		@ls_user_status varchar(8),
		@ls_actor_class varchar(12),
		@ls_user_full_name varchar(64),
		@ll_rows int,
		@ls_user_short_name varchar(12),
		@ls_new_user_short_name varchar(12),
		@ll_count int,
		@ls_count varchar(6),
		@ls_first_name varchar(20),
		@ls_last_name varchar(40)

DECLARE lc_cons CURSOR LOCAL STATIC FOR
	SELECT consultant_id,
			description ,
			address1 ,
			address2 ,
			city ,
			state ,
			zip ,
			phone ,
			phone2 ,
			fax ,
			email 
	FROM inserted i

OPEN lc_cons

FETCH lc_cons INTO @ls_consultant_id,
					@ls_description ,
					@ls_address_line_1 ,
					@ls_address_line_2 ,
					@ls_city ,
					@ls_state ,
					@ls_zip ,
					@ls_phone ,
					@ls_phone2 ,
					@ls_fax ,
					@ls_email 

WHILE @@FETCH_STATUS = 0
	BEGIN
	-- Set the user_full_name and user_short_name
	SET @ls_user_full_name = CAST(@ls_description AS varchar(64))

	-----------------------------------------------------------------------------------
	-- Set the user_short_name
	SET @ls_user_short_name = CAST(CASE WHEN @ls_first_name IS NULL THEN '' ELSE LEFT(@ls_first_name, 1) + '. ' END + @ls_last_name AS varchar(12))
	IF @ls_user_short_name IS NULL OR LEN(@ls_user_short_name) = 0
		SET @ls_user_short_name = CAST(@ls_user_full_name AS varchar(12))

	SET @ls_new_user_short_name = @ls_user_short_name
	SET @ll_count = 0
	
	-- Find a user_short_name that is unique
	WHILE EXISTS(SELECT 1 FROM c_User WHERE user_short_name = @ls_new_user_short_name AND [user_id] <> @ls_consultant_id)
		BEGIN
		SET @ll_count = @ll_count + 1
		SET @ls_count = CAST(@ll_count AS varchar(6))
		SET @ls_new_user_short_name = LEFT(@ls_user_short_name, 12 - LEN(@ls_count)) + @ls_count
		END
	SET @ls_user_short_name = @ls_new_user_short_name
	-----------------------------------------------------------------------------------

	-- See if the c_User record already exists
	SELECT @ls_user_status = user_status,
			@ls_actor_class = actor_class,
			@ll_actor_id = actor_id
	FROM c_User
	WHERE [user_id] = @ls_consultant_id

	IF @ll_actor_id IS NULL
		BEGIN
		INSERT INTO c_User (
				user_id,
				specialty_id,
				user_status,
				user_full_name,
				user_short_name,
				actor_class,
				first_name,
				middle_name,
				last_name,
				degree,
				name_prefix,
				name_suffix,
				organization_contact,
				status,
				created,
				created_by,
				id )
		SELECT consultant_id,
				specialty_id,
				'Actor',
				@ls_user_full_name,
				@ls_user_short_name,
				'Consultant',
				first_name,
				middle_name,
				last_name,
				degree,
				name_prefix,
				name_suffix,
				CAST(contact AS varchar(64)),
				'OK',
				dbo.get_client_datetime(),
				'#SYSTEM',
				id
		FROM c_Consultant
		WHERE consultant_id = @ls_consultant_id

		SELECT @ll_actor_id = SCOPE_IDENTITY(),
				@ll_rows = @@ROWCOUNT

		IF @ll_rows = 0
			BEGIN
			RAISERROR ('No user record created', 16, -1)
			ROLLBACK TRANSACTION
			RETURN
			END					

		IF @ll_actor_id IS NULL
			BEGIN
			RAISERROR ('No Actor_ID generated', 16, -1)
			ROLLBACK TRANSACTION
			RETURN
			END					

		END
	ELSE
		BEGIN
		IF @ls_user_status <> 'Actor' OR @ls_actor_class <> 'Consultant'
			BEGIN
			RAISERROR ('Consultant_id already exists in c_User table and does not match the consultant record', 16, -1)
			ROLLBACK TRANSACTION
			RETURN
			END					

		UPDATE u
		SET specialty_id = c.specialty_id
		FROM c_User u
			INNER JOIN c_Consultant c
			ON u.user_id = c.consultant_id
		WHERE [user_id] = @ls_consultant_id
		AND ISNULL(u.specialty_id, '!NULL') <> ISNULL(c.specialty_id, '!NULL')

		UPDATE u
		SET user_full_name = @ls_user_full_name
		FROM c_User u
			INNER JOIN c_Consultant c
			ON u.user_id = c.consultant_id
		WHERE [user_id] = @ls_consultant_id
		AND ISNULL(u.user_full_name, '!NULL') <> ISNULL(@ls_user_full_name, '!NULL')

		UPDATE u
		SET user_short_name = @ls_user_short_name
		FROM c_User u
			INNER JOIN c_Consultant c
			ON u.user_id = c.consultant_id
		WHERE [user_id] = @ls_consultant_id
		AND ISNULL(u.user_short_name, '!NULL') <> ISNULL(@ls_user_short_name, '!NULL')

		UPDATE u
		SET first_name = c.first_name
		FROM c_User u
			INNER JOIN c_Consultant c
			ON u.user_id = c.consultant_id
		WHERE [user_id] = @ls_consultant_id
		AND ISNULL(u.first_name, '!NULL') <> ISNULL(c.first_name, '!NULL')

		UPDATE u
		SET middle_name = c.middle_name
		FROM c_User u
			INNER JOIN c_Consultant c
			ON u.user_id = c.consultant_id
		WHERE [user_id] = @ls_consultant_id
		AND ISNULL(u.middle_name, '!NULL') <> ISNULL(c.middle_name, '!NULL')

		UPDATE u
		SET last_name = c.last_name
		FROM c_User u
			INNER JOIN c_Consultant c
			ON u.user_id = c.consultant_id
		WHERE [user_id] = @ls_consultant_id
		AND ISNULL(u.last_name, '!NULL') <> ISNULL(c.last_name, '!NULL')

		UPDATE u
		SET degree = c.degree
		FROM c_User u
			INNER JOIN c_Consultant c
			ON u.user_id = c.consultant_id
		WHERE [user_id] = @ls_consultant_id
		AND ISNULL(u.degree, '!NULL') <> ISNULL(c.degree, '!NULL')

		UPDATE u
		SET name_prefix = c.name_prefix
		FROM c_User u
			INNER JOIN c_Consultant c
			ON u.user_id = c.consultant_id
		WHERE [user_id] = @ls_consultant_id
		AND ISNULL(u.name_prefix, '!NULL') <> ISNULL(c.name_prefix, '!NULL')

		UPDATE u
		SET name_suffix = c.name_suffix
		FROM c_User u
			INNER JOIN c_Consultant c
			ON u.user_id = c.consultant_id
		WHERE [user_id] = @ls_consultant_id
		AND ISNULL(u.name_suffix, '!NULL') <> ISNULL(c.name_suffix, '!NULL')

		UPDATE u
		SET organization_contact = CAST(c.contact AS varchar(64))
		FROM c_User u
			INNER JOIN c_Consultant c
			ON u.user_id = c.consultant_id
		WHERE [user_id] = @ls_consultant_id
		AND ISNULL(u.organization_contact, '!NULL') <> ISNULL(CAST(c.contact AS varchar(64)), '!NULL')

		UPDATE u
		SET status = 'OK'
		FROM c_User u
			INNER JOIN c_Consultant c
			ON u.user_id = c.consultant_id
		WHERE [user_id] = @ls_consultant_id
		AND ISNULL(u.status, '!NULL') <> 'OK'


		END

	IF LEN(@ls_address_line_1) > 0
		OR LEN(@ls_address_line_2) > 0
		OR LEN(@ls_city) > 0
		OR LEN(@ls_state) > 0
		OR LEN(@ls_zip) > 0
		EXECUTE sp_new_actor_address
			@pl_actor_id = @ll_actor_id,
			@ps_description = 'Address',
			@ps_address_line_1 = @ls_address_line_1,
			@ps_address_line_2 = @ls_address_line_2,
			@ps_city = @ls_city,
			@ps_state = @ls_state,
			@ps_zip = @ls_zip,
			@ps_created_by = '#SYSTEM'
	
	IF LEN(@ls_phone) > 0
		EXECUTE sp_new_actor_communication 
			@pl_actor_id = @ll_actor_id,
			@ps_communication_type = 'Phone',
			@ps_communication_value = @ls_phone,
			@ps_created_by = '#SYSTEM',
			@ps_communication_name = 'Phone'

	IF LEN(@ls_phone2) > 0
		EXECUTE sp_new_actor_communication 
			@pl_actor_id = @ll_actor_id,
			@ps_communication_type = 'Phone',
			@ps_communication_value = @ls_phone2,
			@ps_created_by = '#SYSTEM',
			@ps_communication_name = 'Phone2'

	IF LEN(@ls_fax) > 0
		EXECUTE sp_new_actor_communication 
			@pl_actor_id = @ll_actor_id,
			@ps_communication_type = 'Fax',
			@ps_communication_value = @ls_fax,
			@ps_created_by = '#SYSTEM',
			@ps_communication_name = 'Fax'

	IF LEN(@ls_email) > 0
		EXECUTE sp_new_actor_communication 
			@pl_actor_id = @ll_actor_id,
			@ps_communication_type = 'Email',
			@ps_communication_value = @ls_email,
			@ps_created_by = '#SYSTEM',
			@ps_communication_name = 'Email'
	
	FETCH lc_cons INTO @ls_consultant_id,
						@ls_description ,
						@ls_address_line_1 ,
						@ls_address_line_2 ,
						@ls_city ,
						@ls_state ,
						@ls_zip ,
						@ls_phone ,
						@ls_phone2 ,
						@ls_fax ,
						@ls_email 
	END

CLOSE lc_cons
DEALLOCATE lc_cons


GO

