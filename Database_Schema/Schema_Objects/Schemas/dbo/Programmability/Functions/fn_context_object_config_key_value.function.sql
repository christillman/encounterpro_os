CREATE FUNCTION fn_context_object_config_key_value (
	@ps_cpr_id varchar(12),
	@ps_context_object varchar(24),
	@pl_object_key int )

RETURNS varchar(64)

AS
BEGIN

DECLARE @ls_config_object_key_name varchar(64),
		@ls_context_object_type varchar(24),
		@ls_config_object_key_value varchar(64)

SET @ls_context_object_type = dbo.fn_context_object_type(@ps_context_object, @ps_cpr_id, @pl_object_key)

IF @ps_context_object = 'General'
	SET @ls_config_object_key_value = NULL

IF @ps_context_object = 'Patient'
	SET @ls_config_object_key_value = NULL

IF @ps_context_object = 'Encounter'
	SELECT @ls_config_object_key_value = encounter_type
	FROM p_Patient_Encounter
	WHERE cpr_id = @ps_cpr_id
	AND encounter_id = @pl_object_key

IF @ps_context_object = 'Assessment'
	SELECT @ls_config_object_key_value = assessment_id
	FROM p_Assessment
	WHERE cpr_id = @ps_cpr_id
	AND problem_id = @pl_object_key

IF @ps_context_object = 'Treatment'
	SET @ls_config_object_key_value = dbo.fn_treatment_key(@ps_cpr_id, @pl_object_key)

IF @ps_context_object = 'Observation'
	SELECT @ls_config_object_key_value = observation_id
	FROM p_Observation
	WHERE cpr_id = @ps_cpr_id
	AND observation_sequence = @pl_object_key

IF @ps_context_object = 'Attachment'
	SET @ls_config_object_key_value = NULL


RETURN @ls_config_object_key_value 

END

