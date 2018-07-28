CREATE FUNCTION fn_get_universal_preference (
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

SELECT @ll_customer_id = customer_id
FROM c_Database_Status

SELECT @ls_preference_value = preference_value
FROM jmjtech.EproUpdates.dbo.Epro_Preference
WHERE preference_id = @ps_preference_id
AND owner_id = @ll_customer_id
AND current_flag = 'Y'

SELECT @ll_rowcount = @@ROWCOUNT,
		@ll_error = @@ERROR
		
IF @ll_error <> 0
	RETURN @ls_preference_value

IF @ll_rowcount = 0
	BEGIN
	SELECT @ls_preference_value = preference_value
	FROM jmjtech.EproUpdates.dbo.Epro_Preference
	WHERE preference_id = @ps_preference_id
	AND owner_id = 0
	AND current_flag = 'Y'

	SELECT @ll_rowcount = @@ROWCOUNT,
			@ll_error = @@ERROR
			
	IF @ll_error <> 0
		RETURN @ls_preference_value
	END

RETURN @ls_preference_value

END


