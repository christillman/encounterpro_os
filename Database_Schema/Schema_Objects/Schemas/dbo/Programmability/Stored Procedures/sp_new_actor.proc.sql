CREATE PROCEDURE sp_new_actor (
	@ps_actor_class varchar(12),
	@ps_name varchar(64) = NULL,
	@ps_last_name varchar(40) = NULL,
	@ps_first_name varchar(40) = NULL,
	@ps_middle_name varchar(40) = NULL,
	@ps_name_prefix varchar(12) = NULL,
	@ps_name_suffix varchar(12) = NULL,
	@ps_degree varchar(24) = NULL,
	@ps_title varchar(64) = NULL,
	@ps_information_system_type varchar(24) = NULL ,
	@ps_information_system_version varchar(24) = NULL ,
	@ps_organization_contact varchar(64) = NULL,
	@ps_organization_director varchar(64) = NULL )
AS

DECLARE @ll_owner_id int,
		@ll_key_value int,
		@ll_actor_id int,
		@ls_user_id varchar(24)

SELECT @ll_owner_id = customer_id
FROM c_Database_Status

-- The caller must specify an actor class
IF @ps_actor_class IS NULL
	BEGIN
	RAISERROR ('No actor_class specified',16,-1)
	ROLLBACK TRANSACTION
	RETURN
	END

-- We don't allow 'User' classes through this procedure
IF @ps_actor_class = 'User'
	BEGIN
	RAISERROR ('actor_class User not allowed through this procedure',16,-1)
	ROLLBACK TRANSACTION
	RETURN
	END

-- Generate the name if we need to for a person
IF @ps_actor_class = 'Person' AND @ps_name IS NULL
	BEGIN
	SET @ps_name = dbo.fn_pretty_name ( @ps_last_name ,
										@ps_first_name ,
										@ps_middle_name ,
										@ps_name_suffix ,
										@ps_name_prefix ,
										@ps_degree )
	END

-- Check to see if we have enough information
IF @ps_name IS NULL OR @ps_name = ''
	BEGIN
	RAISERROR ('No Name Specified',16,-1)
	ROLLBACK TRANSACTION
	RETURN
	END

SELECT @ls_user_id = user_id,
		@ll_actor_id = actor_id
FROM c_User
WHERE actor_class = @ps_actor_class
AND user_full_name = @ps_name

IF @@ROWCOUNT <= 0
	BEGIN
	EXECUTE sp_get_next_key
		@ps_cpr_id = '!CPR',
		@ps_key_id = 'USER_ID',
		@pl_key_value = @ll_key_value OUTPUT

	SET @ls_user_id = CAST(@ll_owner_id AS varchar(12)) + '^' + ltrim(rtrim(convert(varchar(12),@ll_key_value)))

	WHILE exists(select 1 from c_User where user_id = @ls_user_id)
		BEGIN
		EXECUTE sp_get_next_key
			@ps_cpr_id = '!CPR',
			@ps_key_id = 'USER_ID',
			@pl_key_value = @ll_key_value OUTPUT
		SET @ls_user_id = CAST(@ll_owner_id AS varchar(12)) + '^' + ltrim(rtrim(convert(varchar(12),@ll_key_value)))
		END
	
	INSERT INTO c_User (
			user_id,
			user_status,
			actor_class,
			user_full_name ,
			last_name ,
			first_name ,
			middle_name ,
			name_prefix ,
			name_suffix ,
			degree ,
			title ,
			information_system_type ,
			information_system_version ,
			organization_contact ,
			organization_director )
	VALUES (@ls_user_id,
			'Actor',
			@ps_actor_class,
			@ps_name ,
			@ps_last_name ,
			@ps_first_name ,
			@ps_middle_name ,
			@ps_name_prefix ,
			@ps_name_suffix ,
			@ps_degree ,
			@ps_title ,
			@ps_information_system_type ,
			@ps_information_system_version ,
			@ps_organization_contact ,
			@ps_organization_director )
	
	SET @ll_actor_id = SCOPE_IDENTITY()
	END
ELSE
	UPDATE c_User
	SET 	last_name = @ps_last_name,
			first_name = @ps_first_name,
			middle_name = @ps_middle_name,
			name_prefix = @ps_name_prefix,
			name_suffix = @ps_name_suffix,
			degree = @ps_degree,
			title = @ps_title,
			information_system_type = @ps_information_system_type,
			information_system_version = @ps_information_system_version,
			organization_contact = @ps_organization_contact,
			organization_director = @ps_organization_director
	WHERE user_id = @ls_user_id

RETURN @ll_actor_id

