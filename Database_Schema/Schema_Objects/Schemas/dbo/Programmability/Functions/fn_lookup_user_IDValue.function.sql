CREATE FUNCTION fn_lookup_user_IDValue (
	@pl_owner_id int,
	@ps_IDDomain varchar(40),
	@ps_IDValue varchar(255) )

RETURNS varchar(24)

AS
BEGIN

DECLARE @ll_length int,
	@ls_progress_value varchar(40),
	@ls_progress_key varchar(40),
	@ll_customer_id int,
	@ls_user_id varchar(24)

SET @ls_user_id = NULL

SELECT @ll_customer_id = customer_id
FROM c_Database_Status

IF @ll_customer_id = @pl_owner_id
	SET @ls_progress_key = @ps_IDDomain
ELSE
	SET @ls_progress_key = CAST(@pl_owner_id AS varchar(9)) + '^' + @ps_IDDomain

-- If the progress_key is 'ID' then first look for the user in the c_User table
IF @ls_progress_key = 'ID'
	SELECT @ls_user_id = user_id
	FROM c_User
	WHERE ID = @ls_progress_key

IF @ls_user_id IS NULL
	BEGIN
	SELECT @ll_length = LEN(@ps_IDValue)

	IF @ll_length <= 40
		BEGIN

		SELECT @ls_progress_value = CONVERT(varchar(40), @ps_IDValue)

		SELECT TOP 1 @ls_user_id = user_id
		FROM c_User_Progress
		WHERE progress_type = 'ID'
		AND progress_key = @ls_progress_key
		AND progress_value = @ls_progress_value
		AND current_flag = 'Y'
		END
	ELSE
		SELECT TOP 1 @ls_user_id = user_id
		FROM c_User_Progress
		WHERE progress_type = 'ID'
		AND progress_key = @ls_progress_key
		AND CAST(progress AS varchar(255)) = @ps_IDValue
		AND current_flag = 'Y'
	END


RETURN @ls_user_id

END

