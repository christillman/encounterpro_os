CREATE FUNCTION fn_patient_object_progress_value (
	@ps_cpr_id varchar(12),
	@ps_context_object varchar(50),
	@ps_progress_type varchar(24),
	@pl_object_key int,
	@ps_progress_key varchar(40) )

RETURNS varchar(255)

AS
BEGIN
DECLARE @ls_property varchar(255),
		@ll_progress_sequence int

SET @ls_property = NULL

IF @ps_context_object = 'Patient'
	BEGIN
	SELECT @ll_progress_sequence = max(patient_progress_sequence)
	FROM p_Patient_Progress
	WHERE cpr_id = @ps_cpr_id
	AND progress_type = @ps_progress_type
	AND progress_key = @ps_progress_key
	AND current_flag = 'Y'

	SELECT @ls_property = COALESCE(progress_value, CAST(progress as varchar(255)))
	FROM p_Patient_Progress
	WHERE cpr_id = @ps_cpr_id
	AND patient_progress_sequence = @ll_progress_sequence
	END

IF @ps_context_object = 'Encounter'
	BEGIN
	SELECT @ll_progress_sequence = max(encounter_progress_sequence)
	FROM p_Patient_Encounter_Progress
	WHERE cpr_id = @ps_cpr_id
	AND encounter_id = @pl_object_key
	AND progress_type = @ps_progress_type
	AND progress_key = @ps_progress_key
	AND current_flag = 'Y'

	SELECT @ls_property = COALESCE(progress_value, CAST(progress as varchar(255)))
	FROM p_Patient_Encounter_Progress
	WHERE cpr_id = @ps_cpr_id
	AND encounter_id = @pl_object_key
	AND encounter_progress_sequence = @ll_progress_sequence
	END

IF @ps_context_object = 'Assessment'
	BEGIN
	SELECT @ll_progress_sequence = max(assessment_progress_sequence)
	FROM p_Assessment_Progress
	WHERE cpr_id = @ps_cpr_id
	AND problem_id = @pl_object_key
	AND progress_type = @ps_progress_type
	AND progress_key = @ps_progress_key
	AND current_flag = 'Y'

	SELECT @ls_property = COALESCE(progress_value, CAST(progress as varchar(255)))
	FROM p_Assessment_Progress
	WHERE cpr_id = @ps_cpr_id
	AND problem_id = @pl_object_key
	AND assessment_progress_sequence = @ll_progress_sequence
	END

IF @ps_context_object = 'Treatment'
	BEGIN
	SELECT @ll_progress_sequence = max(treatment_progress_sequence)
	FROM p_Treatment_Progress
	WHERE cpr_id = @ps_cpr_id
	AND treatment_id = @pl_object_key
	AND progress_type = @ps_progress_type
	AND progress_key = @ps_progress_key
	AND current_flag = 'Y'

	SELECT @ls_property = COALESCE(progress_value, CAST(progress as varchar(255)))
	FROM p_Treatment_Progress
	WHERE cpr_id = @ps_cpr_id
	AND treatment_id = @pl_object_key
	AND treatment_progress_sequence = @ll_progress_sequence
	END

RETURN @ls_property 

END
