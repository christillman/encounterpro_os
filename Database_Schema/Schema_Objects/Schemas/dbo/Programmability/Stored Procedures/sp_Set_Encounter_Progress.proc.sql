CREATE PROCEDURE sp_Set_Encounter_Progress (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer = NULL,
	@pl_attachment_id int = NULL,
	@ps_progress_type varchar(24),
	@ps_progress_key varchar(40) = NULL,
	@ps_progress text = NULL ,
	@pdt_progress_date_time datetime = NULL,
	@pl_patient_workplan_item_id integer = NULL,
	@pl_risk_level int = NULL ,
	@ps_user_id varchar(24),
	@ps_created_by varchar(24) )
AS

DECLARE @ll_encounter_log_id integer,
	@li_encounter_count smallint,
	@ls_status varchar(12),
	@ll_patient_workplan_id int,
	@ll_length int,
	@ls_progress_value varchar(40)


IF @pdt_progress_date_time IS NULL
	BEGIN
	IF @ps_progress_type = 'Property'
		BEGIN
		-- If the progress_date_time is null and the progress_type is 'Property' then we want to
		-- assume the previous property progress_date_time for the same key
		SELECT @pdt_progress_date_time = max(progress_date_time)
		FROM p_Patient_Encounter_Progress
		WHERE cpr_id = @ps_cpr_id
		AND encounter_id = @pl_encounter_id
		AND progress_type = @ps_progress_type
		AND progress_key = @ps_progress_key
		END
	
	-- If it's still null, then if it's a realtime encounter, then use the current datetime.
	-- Otherwise, use the encounter date
	IF @pdt_progress_date_time IS NULL
		SET @pdt_progress_date_time = getdate()
	END

SELECT @ll_length = LEN(CONVERT(varchar(50), @ps_progress))

-- Add the progress record
IF @ll_length <= 40
	BEGIN

	SELECT @ls_progress_value = CONVERT(varchar(40), @ps_progress)

	INSERT INTO p_Patient_Encounter_Progress (
		cpr_id,
		encounter_id,
		user_id,
		progress_date_time,
		progress_type,
		progress_key,
		progress_value,
		patient_workplan_item_id,
		risk_level,
		attachment_id,
		created,
		created_by)
	VALUES (@ps_cpr_id,
		@pl_encounter_id,
		@ps_user_id,
		@pdt_progress_date_time,
		@ps_progress_type,
		@ps_progress_key,
		@ls_progress_value,
		@pl_patient_workplan_item_id,
		@pl_risk_level,
		@pl_attachment_id,
		getdate(),
		@ps_created_by )
	END
ELSE
	INSERT INTO p_Patient_Encounter_Progress (
		cpr_id,
		encounter_id,
		user_id,
		progress_date_time,
		progress_type,
		progress_key,
		progress,
		patient_workplan_item_id,
		risk_level,
		attachment_id,
		created,
		created_by)
	VALUES (@ps_cpr_id,
		@pl_encounter_id,
		@ps_user_id,
		@pdt_progress_date_time,
		@ps_progress_type,
		@ps_progress_key,
		@ps_progress,
		@pl_patient_workplan_item_id,
		@pl_risk_level,
		@pl_attachment_id,
		getdate(),
		@ps_created_by )


-- Now check to see if this is an attachment, and, if so, what folder it should go in	
DECLARE	@ls_folder varchar(40),
		@ps_context_object_type varchar(40)

IF @pl_attachment_id IS NOT NULL
	BEGIN
	SELECT @ps_context_object_type = encounter_type
	FROM p_Patient_Encounter
	WHERE cpr_id = @ps_cpr_id
	AND encounter_id = @pl_encounter_id
	
	SELECT @ls_folder = min(folder)
	FROM c_Folder
	WHERE context_object = 'Encounter'
	AND context_object_type = @ps_context_object_type

	IF @ls_folder IS NOT NULL
		UPDATE p_Attachment
		SET attachment_folder = @ls_folder
		WHERE attachment_id = @pl_attachment_id
		AND attachment_folder IS NULL

	END	

