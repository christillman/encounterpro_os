

CREATE FUNCTION fn_treatment_type_key_description (
	@ps_treatment_type varchar(24),
	@ps_treatment_key varchar(64) )

RETURNS varchar(80)

AS
BEGIN
DECLARE @ps_treatment_key_description varchar(80),
		@ps_treatment_key_field varchar(64)


SET @ps_treatment_key_field = dbo.fn_treatment_type_treatment_key(@ps_treatment_type)

IF @ps_treatment_key_field = 'procedure_id'
	BEGIN
	SELECT @ps_treatment_key_description = description
	FROM c_Procedure
	WHERE procedure_id = @ps_treatment_key
	END

IF @ps_treatment_key_field = 'material_id'
	BEGIN
	IF ISNUMERIC(@ps_treatment_key) = 1
		SELECT @ps_treatment_key_description = title
		FROM c_Patient_Material
		WHERE material_id = CAST(@ps_treatment_key AS int)
	END

IF @ps_treatment_key_field = 'drug_id'
	BEGIN
	SELECT @ps_treatment_key_description = common_name
	FROM c_Drug_Definition
	WHERE drug_id = @ps_treatment_key
	END

IF @ps_treatment_key_field = 'observation_id'
	BEGIN
	SELECT @ps_treatment_key_description = description
	FROM c_Observation
	WHERE observation_id = @ps_treatment_key
	END

IF @ps_treatment_key_field = 'treatment_description'
	BEGIN
	SET @ps_treatment_key_description = @ps_treatment_key
	END

IF @ps_treatment_key_field = 'treatment_type'
	BEGIN
	SET @ps_treatment_key_description = @ps_treatment_key
	END

RETURN @ps_treatment_key_description 

END

