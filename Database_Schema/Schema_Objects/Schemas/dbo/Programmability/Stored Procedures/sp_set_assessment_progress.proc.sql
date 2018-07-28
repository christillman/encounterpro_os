CREATE PROCEDURE sp_set_assessment_progress (
	@ps_cpr_id varchar(12),
	@pl_problem_id integer,
	@pl_encounter_id integer,
	@pdt_progress_date_time datetime = NULL,
	@pi_diagnosis_sequence smallint = NULL,
	@ps_progress_type varchar(24),
	@ps_progress_key varchar(40) = NULL,
	@ps_progress text = NULL,
	@ps_severity varchar(12) = NULL,
	@pl_attachment_id integer = NULL,
	@pl_patient_workplan_item_id integer = NULL,
	@pl_risk_level integer = NULL,
	@ps_user_id varchar(24),
	@ps_created_by varchar(24) )
AS

DECLARE @ls_progress_value varchar(40)

IF @pdt_progress_date_time IS NULL
	BEGIN
	IF @ps_progress_type = 'Property'
		BEGIN
		-- If the progress_date_time is null and the progress_type is 'Property' then we want to
		-- assume the previous property progress_date_time for the same key
		SELECT @pdt_progress_date_time = max(progress_date_time)
		FROM p_Assessment_Progress
		WHERE cpr_id = @ps_cpr_id
		AND problem_id = @pl_problem_id
		AND progress_type = @ps_progress_type
		AND progress_key = @ps_progress_key
		END
	
	-- If it's still null, then if it's a realtime encounter, then use the current datetime.
	-- Otherwise, use the encounter date
	IF @pdt_progress_date_time IS NULL
		SET @pdt_progress_date_time = getdate()
	END


IF @pi_diagnosis_sequence IS NULL
	SELECT @pi_diagnosis_sequence = max(diagnosis_sequence)
	FROM p_Assessment
	WHERE cpr_id = @ps_cpr_id
	AND problem_id = @pl_problem_id

IF LEN(CONVERT(varchar(50), @ps_progress)) <= 40
	BEGIN
	SELECT @ls_progress_value = CONVERT(varchar(40), @ps_progress)

	INSERT INTO p_Assessment_Progress(
		cpr_id,
		problem_id,
		encounter_id,
		user_id,
		progress_date_time,
		diagnosis_sequence,
		progress_type,
		progress_key,
		progress_value,
		severity,
		attachment_id,
		patient_workplan_item_id,
		risk_level,
		created,
		created_by)
	VALUES (
		@ps_cpr_id,
		@pl_problem_id,
		@pl_encounter_id,
		@ps_user_id,
		@pdt_progress_date_time,
		@pi_diagnosis_sequence,
		@ps_progress_type,
		@ps_progress_key,
		@ls_progress_value,
		@ps_severity,
		@pl_attachment_id,
		@pl_patient_workplan_item_id,
		@pl_risk_level,
		getdate(),
		@ps_created_by )
	END
ELSE
	BEGIN
	INSERT INTO p_Assessment_Progress(
		cpr_id,
		problem_id,
		encounter_id,
		user_id,
		progress_date_time,
		diagnosis_sequence,
		progress_type,
		progress_key,
		progress,
		severity,
		attachment_id,
		patient_workplan_item_id,
		risk_level,
		created,
		created_by)
	VALUES (
		@ps_cpr_id,
		@pl_problem_id,
		@pl_encounter_id,
		@ps_user_id,
		@pdt_progress_date_time,
		@pi_diagnosis_sequence,
		@ps_progress_type,
		@ps_progress_key,
		@ps_progress,
		@ps_severity,
		@pl_attachment_id,
		@pl_patient_workplan_item_id,
		@pl_risk_level,
		getdate(),
		@ps_created_by )
	END


-- Now check to see if this is an attachment, and, if so, what folder it should go in	
DECLARE	@ls_folder varchar(40),
		@ps_context_object_type varchar(40)

IF @pl_attachment_id IS NOT NULL
	BEGIN
	SELECT @ps_context_object_type = assessment_type
	FROM p_Assessment
	WHERE cpr_id = @ps_cpr_id
	AND problem_id = @pl_problem_id
	AND diagnosis_sequence = @pi_diagnosis_sequence
	
	SELECT @ls_folder = min(folder)
	FROM c_Folder
	WHERE context_object = 'Assessment'
	AND context_object_type = @ps_context_object_type

	IF @ls_folder IS NOT NULL
		UPDATE p_Attachment
		SET attachment_folder = @ls_folder
		WHERE attachment_id = @pl_attachment_id
		AND attachment_folder IS NULL

	END	

