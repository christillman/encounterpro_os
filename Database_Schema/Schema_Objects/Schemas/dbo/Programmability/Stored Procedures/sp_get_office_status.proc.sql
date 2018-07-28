CREATE PROCEDURE sp_get_office_status (
	@pl_group_id integer )
AS

SELECT p.cpr_id,
	e.encounter_id,
	e.patient_location,
	p.date_of_birth,
	p.sex,
	p.first_name,
	p.last_name,
	p.degree,
	p.name_prefix,
	p.middle_name,
	p.name_suffix,
	p.locked_by,
	minutes=DATEDIFF(minute, i.dispatch_date, getdate()),
	r.room_name,
	r.room_sequence,
	age='',
	pretty_name='',
	status=1,
	i.ordered_service,
	i.description,
	i.owned_by,
	i.completed_by,
	i.patient_workplan_item_id,
	service_color=0,
	e.attending_doctor,
	patient_color=0,
	l.user_id,
	user_short_name = '',
	in_use = ''
FROM p_Patient_WP_Item i (NOLOCK)
	INNER JOIN p_Patient_WP w (NOLOCK)
	ON i.patient_workplan_id = w.patient_workplan_id
	INNER JOIN p_Patient p (NOLOCK)
	ON i.cpr_id = p.cpr_id
	INNER JOIN p_Patient_Encounter e (NOLOCK)
	ON i.cpr_id = e.cpr_id
	AND	i.encounter_id = e.encounter_id
	INNER JOIN o_Rooms r (NOLOCK)
	ON e.patient_location = r.room_id
	INNER JOIN o_Group_Rooms g (NOLOCK)
	ON r.room_id = g.room_id
	LEFT OUTER JOIN o_Users l (NOLOCK)
	ON r.computer_id = l.computer_id
WHERE i.active_service_flag = 'Y'
AND	i.item_type = 'Service'
AND	w.status = 'Current'
AND	w.in_office_flag = 'Y'
AND	i.in_office_flag = 'Y'
AND	e.encounter_status = 'OPEN'
AND	g.group_id = @pl_group_id

