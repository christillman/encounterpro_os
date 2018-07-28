CREATE PROCEDURE jmj_treatment_list_set_attribute (
	@pl_definition_id int,
	@ps_attribute varchar(80),
	@ps_value text)
AS

DECLARE @ls_value varchar(255),
		@ll_len_value int


SET @ll_len_value = LEN(CAST(@ps_value AS varchar(300)))

IF @ll_len_value > 255
	BEGIN
	UPDATE u_Assessment_Treat_Def_Attrib
	SET long_value = @ps_value
	WHERE definition_id = @pl_definition_id
	AND attribute = @ps_attribute
	
	IF @@ROWCOUNT = 0
		INSERT INTO u_Assessment_Treat_Def_Attrib (
			definition_id,
			attribute,
			long_value )
		VALUES (
			@pl_definition_id,
			@ps_attribute,
			@ps_value)
		
	END
ELSE
	BEGIN
	SET @ls_value = CAST(@ps_value AS varchar(255))
	
	UPDATE u_Assessment_Treat_Def_Attrib
	SET long_value = @ls_value
	WHERE definition_id = @pl_definition_id
	AND attribute = @ps_attribute
	
	IF @@ROWCOUNT = 0
		INSERT INTO u_Assessment_Treat_Def_Attrib (
			definition_id,
			attribute,
			value )
		VALUES (
			@pl_definition_id,
			@ps_attribute,
			@ls_value)
	END

IF @ps_attribute = 'treatment_description'
	BEGIN
	IF @ll_len_value > 255
		SET @ls_value = CAST(@ps_value AS varchar(252)) + '...'
	ELSE
		SET @ls_value = CAST(@ps_value AS varchar(255))
	
	UPDATE u_Assessment_Treat_definition
	SET treatment_description = @ls_value
	WHERE definition_id = @pl_definition_id
	END

