CREATE FUNCTION fn_count_progress_for_object (
	@ps_cpr_id varchar(12),
	@ps_context_object varchar(12),
	@pl_object_key int,
	@ps_progress_type varchar(24) )

RETURNS int

AS
BEGIN

-- This function counts the number of attachments for the specified context object

DECLARE @ll_count int

SET @ll_count = 0


IF @ps_context_object = 'Patient'
	BEGIN
	SELECT @ll_count = count(*)
	FROM p_Patient_Progress
	WHERE cpr_id = @ps_cpr_id
	AND progress_type = @ps_progress_type
	AND current_flag = 'Y'
	END


IF @ps_context_object = 'Encounter'
	BEGIN
	SELECT @ll_count = count(*)
	FROM p_Patient_Encounter_Progress
	WHERE cpr_id = @ps_cpr_id
	AND progress_type = @ps_progress_type
	AND current_flag = 'Y'
	END


IF @ps_context_object = 'Assessment'
	BEGIN
	SELECT @ll_count = count(*)
	FROM p_Assessment_Progress
	WHERE cpr_id = @ps_cpr_id
	AND problem_id = @pl_object_key
	AND progress_type = @ps_progress_type
	AND current_flag = 'Y'
	END


IF @ps_context_object = 'Treatment'
	BEGIN
	-- Specifically exclude signatures from this count
	SELECT @ll_count = count(*)
	FROM p_Treatment_Progress
	WHERE cpr_id = @ps_cpr_id
	AND treatment_id = @pl_object_key
	AND progress_type = @ps_progress_type
	AND current_flag = 'Y'
	AND NOT (progress_type = 'Attachment' and progress_key = 'Signature')
	END


RETURN @ll_count 

END

