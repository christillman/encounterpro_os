CREATE FUNCTION fn_context_object_config_key_name (
	@ps_cpr_id varchar(12),
	@ps_context_object varchar(24),
	@pl_object_key int )

RETURNS varchar(64)

AS
BEGIN

DECLARE @ls_config_object_key_name varchar(64),
		@ls_context_object_type varchar(24)

SET @ls_context_object_type = dbo.fn_context_object_type(@ps_context_object, @ps_cpr_id, @pl_object_key)

IF @ps_context_object = 'General'
	SET @ls_config_object_key_name = NULL

IF @ps_context_object = 'Patient'
	SET @ls_config_object_key_name = NULL

IF @ps_context_object = 'Encounter'
	SET @ls_config_object_key_name = 'encounter_type'

IF @ps_context_object = 'Assessment'
	SET @ls_config_object_key_name = 'assessment_id'

IF @ps_context_object = 'Treatment'
	SET @ls_config_object_key_name = dbo.fn_treatment_type_treatment_key(@ls_context_object_type) 

IF @ps_context_object = 'Observation'
	SET @ls_config_object_key_name = 'observation_id'

IF @ps_context_object = 'Attachment'
	SET @ls_config_object_key_name = NULL


RETURN @ls_config_object_key_name 

END

