CREATE PROCEDURE sp_close_treatments_for_closed_assessments
	(
	@ps_cpr_id varchar(12) = NULL)
AS

DECLARE @ls_cpr_id varchar(12) ,
		@ll_problem_id int ,
		@ll_treatment_id int ,
		@ls_progress_type varchar(24),
		@ll_encounter_id int,
		@ls_user_id varchar(24),
		@ls_created_by varchar(24)
	
DECLARE @close_treatments TABLE (
	cpr_id varchar(12) NOT NULL,
	problem_id int NOT NULL,
	treatment_id int NOT NULL,
	progress_type varchar(24) NOT NULL ,
	encounter_id int NULL,
	user_id varchar(24) NOT NULL,
	created_by varchar(24) NOT NULL )

-- Get a list of the treatments still open for closed assessments
INSERT INTO @close_treatments (
	cpr_id ,
	problem_id ,
	treatment_id,
	progress_type,
	encounter_id,
	user_id,
	created_by )
SELECT a.cpr_id,
	a.problem_id,
	a.treatment_id,
	p.assessment_status,
	p.close_encounter_id,
	'#SYSTEM',
	'#SYSTEM'
FROM p_Assessment p
	INNER JOIN p_Assessment_Treatment a
	ON p.cpr_id = a.cpr_id
	AND p.problem_id = a.problem_id
	INNER JOIN p_Treatment_Item t
	ON a.cpr_id = t.cpr_id
	AND a.treatment_id = t.treatment_id
WHERE p.assessment_status IN ('Closed', 'Cancelled')
AND p.current_flag = 'Y'
AND ISNULL(t.treatment_status, 'Open') = 'Open'
AND (@ps_cpr_id IS NULL OR p.cpr_id = @ps_cpr_id)

-- Delete the treatments which are associated with another open assessment
DELETE t
FROM @close_treatments t
	INNER JOIN p_Assessment_Treatment a
	ON t.cpr_id = a.cpr_id
	AND t.treatment_id = a.treatment_id
	INNER JOIN p_Assessment p
	ON a.cpr_id = p.cpr_id
	AND a.problem_id = p.problem_id
WHERE a.problem_id <> t.problem_id
AND p.current_flag = 'Y'
AND ISNULL(p.assessment_status, 'Open') = 'Open'

DECLARE lc_treatments CURSOR LOCAL FAST_FORWARD FOR
	SELECT cpr_id ,
			problem_id ,
			treatment_id,
			encounter_id,
			user_id,
			created_by
	FROM @close_treatments

OPEN lc_treatments

FETCH lc_treatments INTO @ls_cpr_id, @ll_problem_id, @ll_treatment_id, @ll_encounter_id, @ls_user_id, @ls_created_by

WHILE @@FETCH_STATUS = 0
	BEGIN
	-- Close the treatment
	EXECUTE sp_set_treatment_progress
				@ps_cpr_id = @ls_cpr_id,
				@pl_treatment_id = @ll_treatment_id,
				@pl_encounter_id = @ll_encounter_id,
				@ps_progress_type = 'Closed',
				@ps_user_id = @ls_user_id,
				@ps_created_by = @ls_created_by
	
	FETCH lc_treatments INTO @ls_cpr_id, @ll_problem_id, @ll_treatment_id, @ll_encounter_id, @ls_user_id, @ls_created_by
	END

CLOSE lc_treatments
DEALLOCATE lc_treatments

