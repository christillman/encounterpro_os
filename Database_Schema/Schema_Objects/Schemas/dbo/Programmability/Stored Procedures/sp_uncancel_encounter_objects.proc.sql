CREATE PROCEDURE sp_uncancel_encounter_objects
	(
	@ps_cpr_id varchar(12),
	@pl_encounter_id int,
	@ps_ordered_by varchar(24),
	@ps_created_by varchar(24)
	)

AS

DECLARE @ll_treatment_id int,
	@ll_problem_id int,
	@ll_patient_workplan_id int

-- UNCancel the treatments ordered during the encounter
DECLARE lc_trts CURSOR LOCAL FAST_FORWARD FOR
	SELECT treatment_id
	FROM p_Treatment_Progress
	WHERE cpr_id = @ps_cpr_id
	AND encounter_id = @pl_encounter_id
	AND progress_type = 'Cancelled'
	AND progress_value = 'Encounter Cancelled'

OPEN lc_trts

FETCH lc_trts INTO @ll_treatment_id
WHILE @@FETCH_STATUS = 0
	BEGIN
	EXECUTE sp_set_treatment_progress
		@ps_cpr_id = @ps_cpr_id,
		@pl_treatment_id = @ll_treatment_id,
		@pl_encounter_id = @pl_encounter_id,
		@ps_progress_type = 'UNCancelled',
		@ps_progress_key = NULL,
		@ps_progress = 'Encounter UNCancelled',
		@pdt_progress_date_time = NULL,
		@pl_patient_workplan_item_id = NULL,
		@pl_risk_level = NULL,
		@pl_attachment_id = NULL,
		@ps_user_id = @ps_ordered_by,
		@ps_created_by = @ps_created_by

	FETCH lc_trts INTO @ll_treatment_id
	END

CLOSE lc_trts
DEALLOCATE lc_trts

-- Cancel the assessments ordered during the encounter
-- UNCancel the treatments ordered during the encounter
DECLARE lc_assm CURSOR LOCAL FAST_FORWARD FOR
	SELECT treatment_id
	FROM p_Treatment_Progress
	WHERE cpr_id = @ps_cpr_id
	AND encounter_id = @pl_encounter_id
	AND progress_type = 'Cancelled'
	AND progress_value = 'Encounter Cancelled'

OPEN lc_assm

FETCH lc_assm INTO @ll_problem_id
WHILE @@FETCH_STATUS = 0
	BEGIN
	EXECUTE sp_set_assessment_progress
		@ps_cpr_id = @ps_cpr_id,
		@pl_problem_id = @ll_problem_id,
		@pl_encounter_id = @pl_encounter_id,
		@pdt_progress_date_time = NULL,
		@pi_diagnosis_sequence = NULL,
		@ps_progress_type = 'UNCancelled',
		@ps_progress_key = NULL,
		@ps_progress = 'Encounter UNCancelled',
		@ps_severity = NULL,
		@pl_attachment_id = NULL,
		@pl_patient_workplan_item_id = NULL,
		@pl_risk_level = NULL,
		@ps_user_id = @ps_ordered_by,
		@ps_created_by = @ps_created_by
		
	FETCH lc_assm INTO @ll_problem_id
	END

CLOSE lc_assm
DEALLOCATE lc_assm


