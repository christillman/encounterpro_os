CREATE PROCEDURE sp_Get_Next_Encounter_Service
	@ps_cpr_id varchar(12),
	@pl_encounter_id int,
	@ps_user_id varchar(24) = NULL,
	@ps_auto_perform_flag char(1) = '%',
	@pl_patient_workplan_item_id int OUTPUT
AS

EXECUTE sp_Get_Next_Encounter_Service_2
	@ps_cpr_id = @ps_cpr_id,
	@pl_encounter_id = @pl_encounter_id,
	@ps_user_id = @ps_user_id,
	@ps_auto_perform_flag = @ps_auto_perform_flag,
	@ps_in_office_flag = '%',
	@pl_patient_workplan_item_id = @pl_patient_workplan_item_id OUTPUT



