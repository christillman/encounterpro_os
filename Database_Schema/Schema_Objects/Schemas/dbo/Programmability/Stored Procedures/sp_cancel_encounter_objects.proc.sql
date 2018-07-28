CREATE PROCEDURE sp_cancel_encounter_objects
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

-- Cancel the treatments ordered during the encounter
WHILE 1=1
	BEGIN
	SELECT @ll_treatment_id = min(treatment_id)
	FROM p_Treatment_Item
	WHERE cpr_id = @ps_cpr_id
	AND open_encounter_id = @pl_encounter_id
	AND ISNULL(treatment_status, 'OPEN') <> 'CANCELLED'
	
	IF @ll_treatment_id IS NULL
		BREAK
	
	EXECUTE sp_set_treatment_progress
		@ps_cpr_id = @ps_cpr_id,
		@pl_treatment_id = @ll_treatment_id,
		@pl_encounter_id = @pl_encounter_id,
		@ps_progress_type = 'Cancelled',
		@ps_progress_key = NULL,
		@ps_progress = 'Encounter Cancelled',
		@pdt_progress_date_time = NULL,
		@pl_patient_workplan_item_id = NULL,
		@pl_risk_level = NULL,
		@pl_attachment_id = NULL,
		@ps_user_id = @ps_ordered_by,
		@ps_created_by = @ps_created_by
	END

-- Cancel the assessments ordered during the encounter
WHILE 1=1
	BEGIN
	SELECT @ll_problem_id = min(problem_id)
	FROM p_Assessment
	WHERE cpr_id = @ps_cpr_id
	AND open_encounter_id = @pl_encounter_id
	AND current_flag = 'Y'
	AND ISNULL(assessment_status, 'OPEN') <> 'CANCELLED'
	
	IF @ll_problem_id IS NULL
		BREAK
	
	EXECUTE sp_set_assessment_progress
		@ps_cpr_id = @ps_cpr_id,
		@pl_problem_id = @ll_problem_id,
		@pl_encounter_id = @pl_encounter_id,
		@pdt_progress_date_time = NULL,
		@pi_diagnosis_sequence = NULL,
		@ps_progress_type = 'Cancelled',
		@ps_progress_key = NULL,
		@ps_progress = 'Encounter Cancelled',
		@ps_severity = NULL,
		@pl_attachment_id = NULL,
		@pl_patient_workplan_item_id = NULL,
		@pl_risk_level = NULL,
		@ps_user_id = @ps_ordered_by,
		@ps_created_by = @ps_created_by
	END


-- Cancel the workplans ordered during the encounter
WHILE 1=1
	BEGIN
	SELECT @ll_patient_workplan_id = min(patient_workplan_id)
	FROM p_Patient_WP
	WHERE cpr_id = @ps_cpr_id
	AND encounter_id = @pl_encounter_id
	AND status <> 'CANCELLED'
	
	IF @ll_patient_workplan_id IS NULL
		BREAK
		
	EXECUTE sp_set_workplan_status
		@ps_cpr_id = @ps_cpr_id,
		@pl_encounter_id = @pl_encounter_id,
		@pl_patient_workplan_id = @ll_patient_workplan_id,
		@ps_progress_type = 'Cancelled',
		@ps_completed_by = @ps_ordered_by,
		@ps_created_by = @ps_created_by		
	END

