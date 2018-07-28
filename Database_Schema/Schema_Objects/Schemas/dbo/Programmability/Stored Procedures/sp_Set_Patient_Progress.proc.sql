CREATE PROCEDURE sp_Set_Patient_Progress (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer = NULL,
	@pl_attachment_id int = NULL,
	@ps_progress_type varchar(24),
	@ps_progress_key varchar(40) = NULL,
	@ps_progress text = NULL ,
	@pdt_progress_date_time datetime = NULL,
	@pl_patient_workplan_item_id integer = NULL,
	@pl_risk_level int = NULL,
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
		FROM p_Patient_Progress
		WHERE cpr_id = @ps_cpr_id
		AND progress_type = @ps_progress_type
		AND progress_key = @ps_progress_key
		END
	
	-- If it's still NULL then use the current date/time
	IF @pdt_progress_date_time IS NULL
		SELECT @pdt_progress_date_time = getdate()

	END

SELECT @ll_length = LEN(CONVERT(varchar(50), @ps_progress))

-- Add the progress record
IF @ll_length <= 40
	BEGIN

	SELECT @ls_progress_value = CONVERT(varchar(40), @ps_progress)

	INSERT INTO p_Patient_Progress (
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
	INSERT INTO p_Patient_Progress (
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


