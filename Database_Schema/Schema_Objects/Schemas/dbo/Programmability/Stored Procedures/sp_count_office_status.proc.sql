CREATE PROCEDURE sp_count_office_status (
	@pl_group_id integer,
	@pl_patient_count int OUTPUT )
AS

SELECT @pl_patient_count = count(distinct e.cpr_id)
FROM
	p_Patient_WP w (NOLOCK),
	p_Patient_WP_Item i (NOLOCK),
	o_Rooms r (NOLOCK),
	p_Patient_Encounter e (NOLOCK),
	o_Group_Rooms g (NOLOCK)
WHERE i.active_service_flag = 'Y'
AND	i.item_type = 'Service'
AND	i.patient_workplan_id = w.patient_workplan_id
AND	w.status = 'Current'
AND	w.in_office_flag = 'Y'
AND	i.in_office_flag = 'Y'
AND	i.cpr_id = e.cpr_id
AND	i.encounter_id = e.encounter_id
AND	e.encounter_status = 'OPEN'
AND	g.group_id = @pl_group_id
AND	r.room_id = g.room_id
AND	e.patient_location = r.room_id

