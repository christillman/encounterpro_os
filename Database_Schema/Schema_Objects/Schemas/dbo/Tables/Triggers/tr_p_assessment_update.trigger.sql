CREATE TRIGGER tr_p_assessment_update ON dbo.p_Assessment
FOR UPDATE
AS

IF @@ROWCOUNT = 0
	RETURN

DECLARE @ls_cpr_id varchar(12),
		@ll_problem_id int,
		@ll_treatment_id int,
		@ll_encounter_id int,
		@ls_user_id varchar(24),
		@ls_created_by varchar(24),
		@ll_count int

-- Get every treatment that is still open and linked to an assessment that is closing
DECLARE lc_treatments CURSOR LOCAL FAST_FORWARD FOR
	SELECT i.cpr_id, i.problem_id, t.treatment_id, i.close_encounter_id
	FROM inserted i
		INNER JOIN deleted d
		ON i.cpr_id = d.cpr_id
		AND i.problem_id = d.problem_id
		AND i.diagnosis_sequence = d.diagnosis_sequence
		INNER JOIN p_Assessment_Treatment pat
		ON i.cpr_id = pat.cpr_id
		AND i.problem_id = pat.problem_id
		INNER JOIN p_Treatment_Item t
		ON pat.cpr_id = t.cpr_id
		AND pat.treatment_id = t.treatment_id
	WHERE ISNULL(d.assessment_status, 'OPEN') = 'OPEN'
	AND ISNULL(i.assessment_status, 'OPEN') = 'CLOSED'
	AND ISNULL(t.treatment_status, 'OPEN') = 'OPEN'

OPEN lc_treatments

FETCH lc_treatments INTO @ls_cpr_id, @ll_problem_id, @ll_treatment_id, @ll_encounter_id
WHILE @@FETCH_STATUS = 0
	BEGIN
	-- Get who closed the assessment
	SELECT @ls_user_id = user_id,
			@ls_created_by = ISNULL(created_by, '#SYSTEM')
	FROM p_Assessment_Progress
	WHERE cpr_id = @ls_cpr_id
	AND problem_id = @ll_problem_id
	AND assessment_progress_sequence = (SELECT MAX(assessment_progress_sequence) 
										FROM p_Assessment_Progress 
										WHERE cpr_id = @ls_cpr_id 
										AND problem_id = @ll_problem_id
										AND progress_type = 'Closed')

	IF @@ROWCOUNT <> 1
		BEGIN
		SET @ls_user_id = '#SYSTEM'
		SET @ls_created_by = '#SYSTEM'
		END

	-- Make sure the treatment isn't associated with an other open assessments
	SELECT @ll_count = count(*)
	FROM p_Assessment_Treatment pat
		INNER JOIN p_Assessment a
		ON pat.cpr_id = a.cpr_id
		AND pat.problem_id = a.problem_id
	WHERE pat.cpr_id = @ls_cpr_id
	AND pat.treatment_id = @ll_treatment_id
	AND pat.problem_id <> @ll_problem_id
	AND a.current_flag = 'Y'
	AND ISNULL(a.assessment_status, 'OPEN') = 'OPEN'

	IF @ll_count = 0
		BEGIN
		-- Close the treatment
		EXECUTE sp_set_treatment_progress
					@ps_cpr_id = @ls_cpr_id,
					@pl_treatment_id = @ll_treatment_id,
					@pl_encounter_id = @ll_encounter_id,
					@ps_progress_type = 'Closed',
					@ps_user_id = @ls_user_id,
					@ps_created_by = @ls_created_by
		END

	FETCH lc_treatments INTO @ls_cpr_id, @ll_problem_id, @ll_treatment_id, @ll_encounter_id
	END

CLOSE lc_treatments
DEALLOCATE lc_treatments


