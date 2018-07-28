CREATE PROCEDURE sp_remove_attachment (
	@ps_cpr_id varchar(12),
	@pl_attachment_id int,
	@ps_user_id varchar(24),
	@ps_created_by varchar(24),
	@ps_context_object varchar(24) = NULL,
	@pl_object_key int = NULL)
AS

-- If a patient attachment exists, remove it
IF @ps_context_object = 'Patient' 
	OR EXISTS(	SELECT 1
				FROM p_Patient_Progress p
				WHERE cpr_id = @ps_cpr_id
				AND attachment_id = @pl_attachment_id )
	INSERT INTO p_Patient_Progress (
		cpr_id,
		encounter_id,
		user_id,
		progress_date_time,
		progress_type,
		progress_key,
		patient_workplan_item_id,
		risk_level,
		created,
		created_by)
	SELECT cpr_id,
		encounter_id,
		@ps_user_id,
		progress_date_time,
		progress_type,
		progress_key,
		patient_workplan_item_id,
		risk_level,
		getdate(),
		@ps_created_by
	FROM p_Patient_Progress
	WHERE cpr_id = @ps_cpr_id
	AND attachment_id = @pl_attachment_id
	AND current_flag = 'Y'
	
-- If an encounter attachment exists, remove it
IF @ps_context_object = 'Encounter'
	OR EXISTS(	SELECT 1
				FROM p_Patient_Encounter_Progress p
				WHERE cpr_id = @ps_cpr_id
				AND attachment_id = @pl_attachment_id )
	INSERT INTO p_Patient_Encounter_Progress (
		cpr_id,
		encounter_id,
		user_id,
		progress_date_time,
		progress_type,
		progress_key,
		patient_workplan_item_id,
		risk_level,
		created,
		created_by)
	SELECT cpr_id,
		encounter_id,
		@ps_user_id,
		progress_date_time,
		progress_type,
		progress_key,
		patient_workplan_item_id,
		risk_level,
		getdate(),
		@ps_created_by
	FROM p_Patient_Encounter_Progress
	WHERE cpr_id = @ps_cpr_id
	AND attachment_id = @pl_attachment_id
	AND current_flag = 'Y'
	AND (@pl_object_key IS NULL OR encounter_id = @pl_object_key)
	
-- If a patient attachment exists, remove it
IF @ps_context_object = 'Assessment' 
	OR EXISTS(	SELECT 1
				FROM p_Assessment_Progress p
				WHERE cpr_id = @ps_cpr_id
				AND attachment_id = @pl_attachment_id )
	INSERT INTO p_Assessment_Progress (
		cpr_id,
		problem_id,
		encounter_id,
		user_id,
		progress_date_time,
		progress_type,
		progress_key,
		patient_workplan_item_id,
		risk_level,
		created,
		created_by)
	SELECT cpr_id,
		problem_id,
		encounter_id,
		@ps_user_id,
		progress_date_time,
		progress_type,
		progress_key,
		patient_workplan_item_id,
		risk_level,
		getdate(),
		@ps_created_by
	FROM p_Assessment_Progress
	WHERE cpr_id = @ps_cpr_id
	AND attachment_id = @pl_attachment_id
	AND current_flag = 'Y'
	AND (@pl_object_key IS NULL OR encounter_id = @pl_object_key)
	
-- If a patient attachment exists, remove it
IF @ps_context_object = 'Treatment' 
	OR EXISTS(	SELECT 1
				FROM p_Treatment_Progress p
				WHERE cpr_id = @ps_cpr_id
				AND attachment_id = @pl_attachment_id )
	INSERT INTO p_Treatment_Progress (
		cpr_id,
		treatment_id,
		encounter_id,
		user_id,
		progress_date_time,
		progress_type,
		progress_key,
		patient_workplan_item_id,
		risk_level,
		created,
		created_by)
	SELECT cpr_id,
		treatment_id,
		encounter_id,
		@ps_user_id,
		progress_date_time,
		progress_type,
		progress_key,
		patient_workplan_item_id,
		risk_level,
		getdate(),
		@ps_created_by
	FROM p_Treatment_Progress
	WHERE cpr_id = @ps_cpr_id
	AND attachment_id = @pl_attachment_id
	AND current_flag = 'Y'
	AND (@pl_object_key IS NULL OR encounter_id = @pl_object_key)
	
-- If a patient attachment exists, remove it
IF @ps_context_object = 'Observation' 
	OR EXISTS(	SELECT 1
				FROM p_Observation_Comment p
				WHERE cpr_id = @ps_cpr_id
				AND attachment_id = @pl_attachment_id )
	INSERT INTO p_Observation_Comment (
		cpr_id,
		observation_sequence,
		encounter_id,
		observation_id,
		user_id,
		comment_date_time,
		comment_type,
		comment_title,
		created,
		created_by)
	SELECT cpr_id,
		observation_sequence,
		encounter_id,
		observation_id,
		@ps_user_id,
		comment_date_time,
		comment_type,
		comment_title,
		getdate(),
		@ps_created_by
	FROM p_Observation_Comment
	WHERE cpr_id = @ps_cpr_id
	AND attachment_id = @pl_attachment_id
	AND current_flag = 'Y'
	AND (@pl_object_key IS NULL OR encounter_id = @pl_object_key)
		

