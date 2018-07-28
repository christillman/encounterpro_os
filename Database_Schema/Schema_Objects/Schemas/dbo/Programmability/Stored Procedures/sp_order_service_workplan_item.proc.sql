CREATE PROCEDURE sp_order_service_workplan_item
	(
	@ps_cpr_id varchar(12),
	@pl_encounter_id int = NULL,
	@pl_patient_workplan_id int,
	@ps_ordered_service varchar(24),
	@ps_in_office_flag char(1) = NULL,
	@ps_auto_perform_flag char(1) = NULL,
	@ps_observation_tag varchar(12) = NULL,
	@ps_description varchar(80) = NULL,
	@ps_ordered_by varchar(24),
	@ps_ordered_for varchar(24) = NULL,
	@pi_step_number smallint = NULL,
	@ps_created_by varchar(24),
	@pl_patient_workplan_item_id int OUTPUT
	)
AS

DECLARE @ll_workplan_id int,
	@li_count smallint,
	@ls_status varchar(12),
	@ll_encounter_id int,
	@li_last_step_dispatched smallint

SELECT @ll_workplan_id = workplan_id,
	@ll_encounter_id = COALESCE(@pl_encounter_id, encounter_id),
	@li_last_step_dispatched = last_step_dispatched
FROM p_Patient_WP
WHERE patient_workplan_id = @pl_patient_workplan_id

-- If the in_office_flag is not supplied, then inherit from workplan
IF @ps_in_office_flag IS NULL
	SELECT @ps_in_office_flag = in_office_flag
	FROM p_Patient_WP
	WHERE patient_workplan_id = @pl_patient_workplan_id

-- If the ordered_for is not supplied, then inherit from workplan
IF @ps_ordered_for IS NULL
	SELECT @ps_ordered_for = owned_by
	FROM p_Patient_WP
	WHERE patient_workplan_id = @pl_patient_workplan_id

IF @ps_description IS NULL
	SELECT @ps_description = description
	FROM o_Service
	WHERE service = @ps_ordered_service

-- If the workplan is already past the desired step, then set the step number
-- to null so it will get dispatched immediately
IF @li_last_step_dispatched > @pi_step_number
	SET @pi_step_number = NULL

INSERT INTO p_Patient_WP_Item
	(
	cpr_id,
	patient_workplan_id,
	encounter_id,
	workplan_id,
	item_type,
	ordered_service,
	in_office_flag,
	auto_perform_flag,
	observation_tag,
	description,
	ordered_by,
	ordered_for,
	step_number,
	created_by)
VALUES	(
	@ps_cpr_id,
	@pl_patient_workplan_id,
	@ll_encounter_id,
	@ll_workplan_id,
	'Service',
	@ps_ordered_service,
	@ps_in_office_flag,
	@ps_auto_perform_flag,
	@ps_observation_tag,
	@ps_description,
	@ps_ordered_by,
	@ps_ordered_for,
	@pi_step_number,
	@ps_created_by )
IF @@rowcount <> 1
	BEGIN
	RAISERROR ('Could not insert record into p_Patient_WP_Item',16,-1)
	ROLLBACK TRANSACTION
	RETURN
	END

SELECT @pl_patient_workplan_item_id = @@identity

IF (@pi_step_number IS NULL) OR (@li_last_step_dispatched IS NULL) OR (@pi_step_number <= @li_last_step_dispatched)
	-- Dispatch workplan item
	INSERT INTO p_Patient_WP_Item_Progress (
		cpr_id,
		patient_workplan_id,
		patient_workplan_item_id,
		encounter_id,
		user_id,
		progress_date_time,
		progress_type,
		created_by)
	VALUES (
		@ps_cpr_id,
		@pl_patient_workplan_id,
		@pl_patient_workplan_item_id,
		@ll_encounter_id,
		@ps_ordered_by,
		getdate(),
		'DISPATCHED',
		@ps_created_by)


