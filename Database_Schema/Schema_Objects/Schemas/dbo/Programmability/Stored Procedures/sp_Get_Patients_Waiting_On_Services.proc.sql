CREATE PROCEDURE sp_Get_Patients_Waiting_On_Services (
	@ps_office_id varchar(4),
	@ps_service varchar(24) )
AS

DECLARE @ls_sort_sequence varchar(255)

SET @ls_sort_sequence = dbo.fn_get_specific_preference('SYSTEM', 'Room', '$Waiting', 'sort')
IF @ls_sort_sequence IS NULL
	SET @ls_sort_sequence = 'Encounter Descending'


SELECT DISTINCT
	i.patient_workplan_item_id,
	i.description as item_description,
	p.cpr_id,   
	e.encounter_id,   
	e.attending_doctor,
	e.patient_location,
	encounter_description = COALESCE(e.encounter_description, et.description),  
	minutes=DATEDIFF(minute, i.dispatch_date, getdate()),   
	p.first_name,
	p.middle_name,
	p.last_name,
	p.sex,
	p.date_of_birth,
	p.billing_id,
	item_color = COALESCE(u.color, r.color),
	room_name = rr.room_name,
	selected_flag=0
FROM	p_Patient_WP_Item i WITH (NOLOCK)
	INNER JOIN p_Patient_WP w WITH (NOLOCK)
	ON i.cpr_id = w.cpr_id
	AND i.patient_workplan_id = w.patient_workplan_id
	INNER JOIN p_Patient p WITH (NOLOCK)
	ON w.cpr_id = p.cpr_id
	INNER JOIN p_Patient_Encounter e WITH (NOLOCK)
	ON w.cpr_id = e.cpr_id
	AND w.encounter_id = e.encounter_id
	INNER JOIN c_Encounter_Type et WITH (NOLOCK)
	ON e.encounter_type = et.encounter_type
	LEFT OUTER JOIN c_User u WITH (NOLOCK)
	ON e.attending_doctor = u.user_id
	LEFT OUTER JOIN c_Role r WITH (NOLOCK)
	ON e.attending_doctor = r.role_id
	LEFT OUTER JOIN o_Rooms rr WITH (NOLOCK)
	ON e.patient_location = rr.room_id
WHERE i.ordered_service = @ps_service
AND i.item_type = 'Service'
AND i.active_service_flag = 'Y'
AND e.office_id = @ps_office_id
ORDER BY minutes desc

