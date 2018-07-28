CREATE PROCEDURE sp_order_past_treatment_services
	(
	@pl_patient_workplan_id int,
	@pl_treatment_id int,
	@ps_ordered_by varchar(24),
	@ps_ordered_for varchar(24) = NULL,
	@ps_created_by varchar(24)
	)
AS

DECLARE @ls_treatment_type varchar(24),
	@ls_service varchar(24),
	@ls_observation_tag varchar(12),
	@ls_description varchar(80),
	@ls_cpr_id varchar(12),
	@ll_encounter_id int,
	@ls_in_office_flag char(1),
	@ll_patient_workplan_item_id int

SELECT @ls_cpr_id = cpr_id,
	@ll_encounter_id = encounter_id,
	@ls_in_office_flag = in_office_flag
FROM p_Patient_WP
WHERE patient_workplan_id = @pl_patient_workplan_id

SELECT @ls_treatment_type = treatment_type
FROM p_Treatment_Item
WHERE treatment_id = @pl_treatment_id

IF @@ROWCOUNT <> 1
	BEGIN
	RAISERROR ('Workplan not found (%d)',16,-1, @pl_patient_workplan_id)
	ROLLBACK TRANSACTION
	RETURN
	END

DECLARE lc_wp_item CURSOR LOCAL FAST_FORWARD TYPE_WARNING FOR
	SELECT t.service,
		t.observation_tag,
		COALESCE(t.button_title, s.description)
	FROM c_Treatment_Type_Service t, o_Service s
	WHERE t.service = s.service
	AND t.treatment_type = @ls_treatment_type
	AND t.auto_perform_flag = 'Y'
	ORDER BY t.sort_sequence, t.service_sequence

OPEN lc_wp_item

FETCH NEXT FROM lc_wp_item INTO
	@ls_service,
	@ls_observation_tag,
	@ls_description

WHILE (@@fetch_status<>-1)
	BEGIN
	EXECUTE sp_order_service_workplan_item
		@ps_cpr_id = @ls_cpr_id,
		@pl_encounter_id = @ll_encounter_id,
		@pl_patient_workplan_id = @pl_patient_workplan_id,
		@ps_ordered_service = @ls_service,
		@ps_in_office_flag = @ls_in_office_flag,
		@ps_auto_perform_flag = 'Y',
		@ps_observation_tag = @ls_observation_tag,
		@ps_description = @ls_description,
		@ps_ordered_by = @ps_ordered_by,
		@ps_ordered_for = @ps_ordered_for,
		@ps_created_by = @ps_created_by,
		@pl_patient_workplan_item_id = @ll_patient_workplan_item_id OUTPUT

	FETCH NEXT FROM lc_wp_item INTO
		@ls_service,
		@ls_observation_tag,
		@ls_description

	END

DEALLOCATE lc_wp_item

