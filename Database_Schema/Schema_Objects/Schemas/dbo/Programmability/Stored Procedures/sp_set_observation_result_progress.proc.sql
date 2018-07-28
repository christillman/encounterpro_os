CREATE PROCEDURE sp_set_observation_result_progress (
	@ps_cpr_id varchar(12),
	@pl_observation_sequence int ,
	@pl_location_result_sequence int ,
	@pl_encounter_id int,
	@ps_progress_type varchar(24),
	@ps_progress_key varchar(40) = NULL,
	@ps_progress text = NULL,
	@pdt_progress_date_time datetime = NULL,
	@ps_user_id varchar(24),
	@ps_created_by varchar(24) )
AS


DECLARE @ll_encounter_log_id integer,
	@li_encounter_count smallint,
	@ls_status varchar(12),
	@ll_patient_workplan_id int,
	@ls_progress_value varchar(40),
	@ll_length int

IF @pdt_progress_date_time IS NULL
	SET @pdt_progress_date_time = getdate()


-- First add the progress record.  If the length of @ps_progress is <= 40 then
-- store the value in [progress_value].  Otherwise store it in [progress].
SET @ll_length = LEN(CONVERT(varchar(50), @ps_progress))

IF @ll_length <= 40
	BEGIN
	SET @ls_progress_value = CONVERT(varchar(40), @ps_progress)

	INSERT INTO p_observation_result_Progress (
		cpr_id,
		observation_sequence,
		location_result_sequence,
		encounter_id,
		user_id,
		progress_date_time,
		progress_type,
		progress_key,
		progress_value,
		created,
		created_by)
	VALUES (@ps_cpr_id,
		@pl_observation_sequence,
		@pl_location_result_sequence,
		@pl_encounter_id,
		@ps_user_id,
		@pdt_progress_date_time,
		@ps_progress_type,
		@ps_progress_key,
		@ls_progress_value,
		getdate(),
		@ps_created_by )
	END
ELSE
	INSERT INTO p_observation_result_Progress (
		cpr_id,
		observation_sequence,
		location_result_sequence,
		encounter_id,
		user_id,
		progress_date_time,
		progress_type,
		progress_key,
		progress,
		created,
		created_by)
	VALUES (@ps_cpr_id,
		@pl_observation_sequence,
		@pl_location_result_sequence,
		@pl_encounter_id,
		@ps_user_id,
		@pdt_progress_date_time,
		@ps_progress_type,
		@ps_progress_key,
		@ps_progress,
		getdate(),
		@ps_created_by )


