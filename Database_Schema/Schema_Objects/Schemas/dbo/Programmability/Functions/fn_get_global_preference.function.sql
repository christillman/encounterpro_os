CREATE FUNCTION fn_get_global_preference (
	@ps_preference_type varchar(24),
	@ps_preference_id varchar(40)
	)

RETURNS varchar(255)

AS

BEGIN

DECLARE @ls_preference_value varchar(255),
		@ls_universal_flag char(1),
		@ll_customer_id int,
		@ll_error int,
		@ll_rowcount int

SELECT @ls_preference_value = NULL

SELECT @ls_universal_flag = universal_flag
FROM c_Preference
WHERE preference_id = @ps_preference_id

SELECT @ll_rowcount = @@ROWCOUNT,
		@ll_error = @@ERROR
		
IF @ll_error <> 0
	RETURN @ls_preference_value

IF @ll_rowcount = 0
	SET @ls_universal_flag = 'N'

SELECT @ll_customer_id = customer_id
FROM c_Database_Status

SELECT @ll_rowcount = @@ROWCOUNT,
		@ll_error = @@ERROR
		
IF @ll_error <> 0
	RETURN @ls_preference_value

IF @ll_rowcount = 0
	RETURN @ls_preference_value


IF @ls_universal_flag = 'N'
	BEGIN
	SELECT @ls_preference_value = preference_value
	FROM o_preferences
	WHERE preference_type = @ps_preference_type
	AND preference_level = 'Global'
	AND preference_key = 'Global'
	AND preference_id = @ps_preference_id

	SELECT @ll_rowcount = @@ROWCOUNT,
			@ll_error = @@ERROR
			
	IF @ll_error <> 0
		RETURN @ls_preference_value
	END

IF @ls_universal_flag = 'C'
	BEGIN
	SELECT @ls_preference_value = preference_value
	FROM o_preferences
	WHERE preference_type = @ps_preference_type
	AND preference_level = 'Global'
	AND preference_key = 'Global'
	AND preference_id = @ps_preference_id

	SELECT @ll_rowcount = @@ROWCOUNT,
			@ll_error = @@ERROR
			
	IF @ll_error <> 0
		RETURN @ls_preference_value
	END

IF @ls_universal_flag = 'Y' OR (@ls_universal_flag = 'C' AND @ls_preference_value IS NULL)
	BEGIN
	SET @ls_preference_value = dbo.fn_get_universal_preference(@ps_preference_id)

	IF @ls_universal_flag = 'C' AND @ls_preference_value IS NOT NULL
		BEGIN
		-- We got a value from the Epro Server so cache it locally
		EXECUTE sp_set_preference
			@ps_preference_type = @ps_preference_type,
			@ps_preference_level = 'Global',
			@ps_preference_key = 'Global',
			@ps_preference_id = @ps_preference_id,
			@ps_preference_value = @ls_preference_value
		
		END
	END

RETURN @ls_preference_value

END


