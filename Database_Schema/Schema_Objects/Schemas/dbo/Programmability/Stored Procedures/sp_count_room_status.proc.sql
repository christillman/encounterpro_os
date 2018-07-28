CREATE PROCEDURE sp_count_room_status (
	@ps_room_id varchar(12),
	@pl_patient_count int OUTPUT )
AS
SELECT @pl_patient_count = count(distinct e.cpr_id)
FROM
	p_Patient_WP w (NOLOCK),
	p_Patient_WP_Item i (NOLOCK),
	p_Patient_Encounter e (NOLOCK)
WHERE i.active_service_flag = 'Y'
AND	i.item_type = 'Service'
AND	i.patient_workplan_id = w.patient_workplan_id
AND	w.status = 'Current'
AND	w.in_office_flag = 'Y'
AND	i.in_office_flag = 'Y'
AND	i.cpr_id = e.cpr_id
AND	i.encounter_id = e.encounter_id
AND	e.encounter_status = 'OPEN'
AND	e.patient_location = @ps_room_id

