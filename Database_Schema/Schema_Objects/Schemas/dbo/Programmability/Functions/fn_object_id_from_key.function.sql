CREATE FUNCTION fn_object_id_from_key (
	@ps_object_type varchar(24),
	@ps_object_key varchar(64))

RETURNS uniqueidentifier

AS
BEGIN

DECLARE @lu_object_id uniqueidentifier,
		@ls_observation_id varchar(24),
		@li_result_sequence smallint

SET @lu_object_id = NULL

IF @ps_object_type = 'Assessment'
	BEGIN
	SELECT @lu_object_id = id
	FROM c_Assessment_Definition
	WHERE assessment_id = @ps_object_key
	END

IF @ps_object_type = 'Drug'
	BEGIN
	SELECT @lu_object_id = id
	FROM c_Drug_Definition
	WHERE drug_id = @ps_object_key
	END

IF @ps_object_type = 'Procedure'
	BEGIN
	SELECT @lu_object_id = id
	FROM c_Procedure
	WHERE procedure_id = @ps_object_key
	END

IF @ps_object_type = 'Material'
	BEGIN
	IF ISNUMERIC(@ps_object_key) = 1
		SELECT @lu_object_id = id
		FROM c_Patient_Material
		WHERE material_id = CAST(@ps_object_key AS int)
	END

IF @ps_object_type = 'Observation'
	BEGIN
	SELECT @lu_object_id = id
	FROM c_Observation
	WHERE observation_id = @ps_object_key
	END

IF @ps_object_type = 'Result'
	BEGIN
	SELECT @ls_observation_id = CAST(item AS varchar(24))
	FROM dbo.fn_parse_string(@ps_object_key, '|')
	WHERE item_number = 1

	SELECT @li_result_sequence = CAST(item AS smallint)
	FROM dbo.fn_parse_string(@ps_object_key, '|')
	WHERE item_number = 2

	SELECT @lu_object_id = id
	FROM c_Observation_Result
	WHERE observation_id = @ls_observation_id
	AND result_sequence = @li_result_sequence
	END



RETURN @lu_object_id
END

