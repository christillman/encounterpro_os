CREATE FUNCTION fn_attribute_value_substitute (
	@ps_value varchar(255),
	@ps_user_id varchar(24) )

RETURNS varchar(255)

AS
BEGIN
DECLARE @ls_new_value varchar(255),
		@ls_token varchar(40),
		@ll_charindex int,
		@ls_context_object varchar(24),
		@ls_temp varchar(255)

IF LEFT(@ps_value, 1) = '%' AND RIGHT(@ps_value, 1) = '%' AND LEN(@ps_value) > 2
	BEGIN
	SET @ls_temp = SUBSTRING(@ps_value, 2, LEN(@ps_value) - 2)
	SET @ll_charindex = CHARINDEX(' ', @ls_temp)
	IF @ll_charindex > 0
		BEGIN
		SET @ls_context_object = LEFT(@ls_temp, @ll_charindex - 1)
		IF @ls_context_object IN ('General', 'Patient', 'Encounter', 'Assessment', 'Treatment', 'Observation', 'Attachment')
			SET @ls_token = RIGHT(@ls_temp, len(@ls_temp) - @ll_charindex)
		ELSE
			SET @ls_token = LEFT(@ls_temp, 40)
			SET @ls_context_object = 'General'
		END
	ELSE
		BEGIN
		SET @ls_token = LEFT(@ls_temp, 40)
		SET @ls_context_object = 'General'
		END
	
	IF @ls_context_object = 'General'
		SET @ls_new_value = dbo.fn_get_preference('PROPERTY', @ls_token, @ps_user_id, DEFAULT)
	END
ELSE
	SET @ls_new_value = @ps_value


RETURN @ls_new_value 

END
