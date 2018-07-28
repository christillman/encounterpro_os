CREATE PROCEDURE jmj_set_active_service (
	@pl_patient_workplan_item_id integer )
AS


DECLARE @ll_patient_workplan_id int ,
		@ls_user_id varchar(24) ,
		@ll_computer_id int ,
		@ls_cpr_id varchar(12) ,
		@ll_encounter_id int ,
		@ls_patient_location varchar(12) ,
		@ls_office_id varchar(4),
		@ll_treatment_id int,
		@ls_observation_id varchar(24),
		@li_result_sequence smallint ,
		@ls_active_service_flag char(1)

SELECT @ls_active_service_flag = CASE WHEN item_type = 'Service' AND status IN ('DISPATCHED', 'STARTED') THEN 'Y' ELSE 'N' END,
		@ll_patient_workplan_id = patient_workplan_id,
		@ls_cpr_id = cpr_id,
		@ll_encounter_id = encounter_id,
		@ll_treatment_id = treatment_id
FROM p_Patient_WP_Item
WHERE patient_workplan_item_id = @pl_patient_workplan_item_id

IF @ll_treatment_id IS NULL
	SET @ll_treatment_id = CAST(dbo.fn_get_attribute(@pl_patient_workplan_item_id, 'treatment_id') AS int)

IF @ll_treatment_id IS NULL
	SELECT @ll_treatment_id = treatment_id
	FROM p_Patient_WP
	WHERE patient_workplan_id = @ll_patient_workplan_id


UPDATE p_Patient_WP_Item
SET active_service_flag = @ls_active_service_flag,
	treatment_id = @ll_treatment_id
WHERE patient_workplan_item_id = @pl_patient_workplan_item_id

IF @ls_active_service_flag = 'N'
	BEGIN
	DELETE o
	FROM o_Active_Services o
	WHERE o.patient_workplan_item_id = @pl_patient_workplan_item_id
	
	RETURN 0
	END
ELSE
	BEGIN
	SET @ls_user_id = NULL
	SET @ll_computer_id = NULL
	SET @ls_patient_location = NULL
	SET @ls_office_id = NULL
	
	SELECT @ls_user_id = user_id,
			@ll_computer_id = computer_id
	FROM o_User_Service_Lock
	WHERE patient_workplan_item_id = @pl_patient_workplan_item_id
	
	SELECT @ls_patient_location = patient_location,
			@ls_office_id = office_id
	FROM p_Patient_Encounter
	WHERE cpr_id = @ls_cpr_id
	AND encounter_id = @ll_encounter_id

	IF @ll_treatment_id IS NULL
		BEGIN
		SET @ls_observation_id = NULL
		SET @li_result_sequence = NULL
		END
	ELSE
		BEGIN
		SET @ls_observation_id = CAST(dbo.fn_get_attribute(@pl_patient_workplan_item_id, 'observation_id') AS varchar(24))
		IF @ls_observation_id IS NULL
			SELECT @ls_observation_id = observation_id
			FROM p_Treatment_Item
			WHERE cpr_id = @ls_cpr_id
			AND treatment_id = @ll_treatment_id
		
		IF @ls_observation_id IS NULL
			SET @li_result_sequence = NULL
		ELSE
			BEGIN
			SET @li_result_sequence = CAST(dbo.fn_get_attribute(@pl_patient_workplan_item_id, 'result_sequence') AS smallint)
			
			IF @li_result_sequence IS NULL
				SET @li_result_sequence = CAST(dbo.fn_patient_object_property(@ls_cpr_id, 'Treatment', @ll_treatment_id, 'result_sequence') AS smallint)
			END
		END



	IF EXISTS(SELECT 1 FROM o_Active_Services WHERE patient_workplan_item_id = @pl_patient_workplan_item_id)
		BEGIN
		UPDATE o
		SET patient_workplan_id = i.patient_workplan_id,
			patient_workplan_item_id = i.patient_workplan_item_id,
			in_office_flag = i.in_office_flag,
			cpr_id = i.cpr_id,
			encounter_id = i.encounter_id,
			ordered_service = i.ordered_service,
			followup_workplan_id = i.followup_workplan_id,
			description = i.description,
			ordered_by = i.ordered_by,
			ordered_for = i.ordered_for,
			priority = i.priority,
			dispatch_date = i.dispatch_date,
			owned_by = i.owned_by,
			begin_date = i.begin_date,
			status = i.status,
			room_id = i.room_id,
			escalation_date = i.escalation_date,
			expiration_date = i.expiration_date,
			user_id = @ls_user_id,
			computer_id	= @ll_computer_id,
			patient_location = @ls_patient_location,
			office_id = @ls_office_id,
			treatment_id = @ll_treatment_id,
			observation_id = @ls_observation_id,
			result_sequence = @li_result_sequence
		FROM o_Active_Services o
			INNER JOIN p_Patient_WP_Item i
			ON o.patient_workplan_item_id = i.patient_workplan_item_id
		WHERE i.patient_workplan_item_id = @pl_patient_workplan_item_id
		END
	ELSE
		BEGIN
		INSERT INTO o_Active_Services (
			patient_workplan_id ,
			patient_workplan_item_id ,
			in_office_flag ,
			cpr_id ,
			encounter_id ,
			ordered_service ,
			followup_workplan_id ,
			description ,
			ordered_by ,
			ordered_for ,
			priority ,
			dispatch_date ,
			owned_by ,
			begin_date ,
			status ,
			room_id ,
			escalation_date ,
			expiration_date ,
			user_id ,
			computer_id ,
			patient_location ,
			office_id ,
			treatment_id ,
			observation_id ,
			result_sequence )
		SELECT i.patient_workplan_id ,
			i.patient_workplan_item_id ,
			i.in_office_flag ,
			i.cpr_id ,
			i.encounter_id ,
			i.ordered_service ,
			i.followup_workplan_id ,
			i.description ,
			i.ordered_by ,
			i.ordered_for ,
			i.priority ,
			i.dispatch_date ,
			i.owned_by ,
			i.begin_date ,
			i.status ,
			i.room_id ,
			i.escalation_date ,
			i.expiration_date ,
			@ls_user_id ,
			@ll_computer_id	,
			@ls_patient_location ,
			@ls_office_id ,
			@ll_treatment_id ,
			@ls_observation_id ,
			@li_result_sequence
		FROM p_Patient_WP_Item i
		WHERE i.patient_workplan_item_id = @pl_patient_workplan_item_id
		END
	END


