CREATE PROCEDURE sp_post_encounter_note (
	@ps_cpr_id varchar(12),
	@pl_patient_workplan_id int = NULL,
	@pl_encounter_id int = NULL,
	@ps_encounter_note varchar(255),
	@ps_ordered_by varchar(24),
	@ps_ordered_for varchar(24) = NULL,
	@ps_created_by varchar(24) )
AS

DECLARE @ls_ordered_service varchar(24),
	@ll_patient_workplan_item_id int,
	@ls_description varchar(80)

INSERT INTO p_Chart_Alert (
	cpr_id,
	open_encounter_id,
	patient_workplan_id,
	ordered_by,
	ordered_for,
	begin_date,
	alert_category_id,
	alert_text,
	created,
	created_by)
VALUES (
	@ps_cpr_id,
	@pl_encounter_id,
	@pl_patient_workplan_id,
	@ps_ordered_by,
	@ps_ordered_for,
	getdate(),
	'NOTE',
	@ps_encounter_note,
	getdate(),
	@ps_created_by)

SELECT @ls_description = CONVERT(varchar(80), @ps_encounter_note),
	@ls_ordered_service = 'ENCOUNTERNOTE'

IF @ps_ordered_for IS NOT NULL
	EXECUTE sp_order_service_workplan_item
		@ps_cpr_id = @ps_cpr_id,
		@pl_patient_workplan_id = @pl_patient_workplan_id,
		@ps_ordered_service = @ls_ordered_service,
		@ps_in_office_flag = 'Y',
		@ps_description = @ls_description,
		@ps_ordered_by = @ps_ordered_by,
		@ps_ordered_for = @ps_ordered_for,
		@ps_created_by = @ps_created_by,
		@pl_patient_workplan_item_id = @ll_patient_workplan_item_id

