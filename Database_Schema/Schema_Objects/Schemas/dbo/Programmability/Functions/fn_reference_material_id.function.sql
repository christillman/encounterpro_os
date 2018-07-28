CREATE FUNCTION fn_reference_material_id (
	@ps_cpr_id varchar(12),
	@ps_context_object varchar(24),
	@pl_object_key int,
	@ps_which_material varchar(24) )

RETURNS int

AS
BEGIN
DECLARE @ls_config_key_name varchar(64),
		@ls_config_key_value varchar(64),
		@ll_material_id int


SET @ls_config_key_name = dbo.fn_context_object_config_key_name(@ps_cpr_id, @ps_context_object, @pl_object_key)
SET @ls_config_key_value = dbo.fn_context_object_config_key_value(@ps_cpr_id, @ps_context_object, @pl_object_key)

IF @ls_config_key_name = 'drug_id'
	SELECT @ll_material_id = CASE @ps_which_material WHEN 'provider reference' THEN provider_reference_material_id
													WHEN 'patient reference' THEN patient_reference_material_id END
	FROM c_Drug_Definition
	WHERE drug_id = @ls_config_key_value

IF @ls_config_key_name = 'assessment_id'
	SELECT @ll_material_id = CASE @ps_which_material WHEN 'provider reference' THEN provider_reference_material_id
													WHEN 'patient reference' THEN patient_reference_material_id END
	FROM c_Assessment_Definition
	WHERE assessment_id = @ls_config_key_value


RETURN @ll_material_id 

END

