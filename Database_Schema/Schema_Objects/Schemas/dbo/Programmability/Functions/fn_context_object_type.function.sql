CREATE FUNCTION fn_context_object_type (
	@ps_context_object varchar(12),
	@ps_cpr_id varchar(12),
	@pl_object_key int )

RETURNS varchar(24)

AS
BEGIN
DECLARE @ls_context_object_type varchar(24)

SET @ls_context_object_type = NULL

IF @ps_context_object = 'General'
	SET @ls_context_object_type = 'General'

IF @ps_context_object = 'Patient'
	SET @ls_context_object_type = 'Patient'

IF @ps_context_object = 'Encounter'
	SELECT @ls_context_object_type = encounter_type
	FROM p_Patient_Encounter
	WHERE cpr_id = @ps_cpr_id
	AND encounter_id = @pl_object_key

IF @ps_context_object = 'Assessment'
	SELECT @ls_context_object_type = assessment_type
	FROM p_Assessment
	WHERE cpr_id = @ps_cpr_id
	AND problem_id = @pl_object_key

IF @ps_context_object = 'Treatment'
	SELECT @ls_context_object_type = treatment_type
	FROM p_Treatment_Item
	WHERE cpr_id = @ps_cpr_id
	AND treatment_id = @pl_object_key

IF @ps_context_object = 'Observation'
	SET @ls_context_object_type = 'Observation'

IF @ps_context_object = 'Attachment'
	SELECT @ls_context_object_type = attachment_type
	FROM p_Attachment
	WHERE cpr_id = @ps_cpr_id
	AND attachment_id = @pl_object_key


RETURN @ls_context_object_type 

END

