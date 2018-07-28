CREATE PROCEDURE sp_count_waiting_room_status (
	@ps_office_id varchar(4),
	@pi_waiting_count smallint OUTPUT )
AS
SELECT @pi_waiting_count = count(p_Patient_Encounter.encounter_id)
FROM	p_Patient_WP WITH (NOLOCK),
		p_Patient_WP_Item WITH (NOLOCK) ,
		p_Patient_Encounter WITH (NOLOCK)
WHERE p_Patient_WP_Item.ordered_service = 'GET_PATIENT'
AND p_Patient_WP_Item.item_type = 'Service'
AND p_Patient_WP_Item.active_service_flag = 'Y'
AND p_Patient_WP.cpr_id = p_Patient_WP_Item.cpr_id
AND p_Patient_WP.patient_workplan_id = p_Patient_WP_Item.patient_workplan_id
AND p_Patient_WP.workplan_type = 'Patient'
AND p_Patient_WP.in_office_flag = 'Y'
AND p_Patient_WP.status = 'Current'
AND p_Patient_WP.cpr_id = p_Patient_Encounter.cpr_id
AND p_Patient_WP.encounter_id = p_Patient_Encounter.encounter_id
AND p_Patient_Encounter.office_id = @ps_office_id
AND p_Patient_Encounter.encounter_status = 'OPEN'

