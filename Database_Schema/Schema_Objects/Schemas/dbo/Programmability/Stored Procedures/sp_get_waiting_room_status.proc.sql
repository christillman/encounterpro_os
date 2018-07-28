CREATE PROCEDURE sp_get_waiting_room_status
	@ps_office_id varchar(4)
AS
SELECT
	p_Patient_Encounter.patient_location,
	o_Rooms.room_name,
	p_Patient.cpr_id,
	p_Patient_Encounter.encounter_id,
	p_Patient_Encounter.attending_doctor,
	p_Patient.date_of_birth,
	p_Patient.sex,
	p_Patient.first_name,
	p_Patient.last_name,
	p_Patient.degree,
	p_Patient.name_prefix,
	p_Patient.middle_name,
	p_Patient.name_suffix,
	p_Patient.locked_by,
	o_Service.description,
	minutes=DATEDIFF(minute, p_Patient_WP_Item.dispatch_date, getdate()),
	pretty_name='',
	status=0,
	p_Patient_WP_Item.ordered_service,
	p_Patient_WP_Item.description,
	p_Patient_WP_Item.ordered_for,
	p_Patient_WP_Item.patient_workplan_item_id,
	p_Patient_Encounter.attending_doctor,
	encounter_description = COALESCE(p_Patient_Encounter.encounter_description, c_Encounter_Type.description),
	c_User.color,
	service_color=0,
	alert_count=0
FROM p_Patient_WP_Item WITH (NOLOCK)
	INNER JOIN p_Patient_WP WITH (NOLOCK)
	ON p_Patient_WP.patient_workplan_id = p_Patient_WP_Item.patient_workplan_id
	INNER JOIN p_Patient WITH (NOLOCK)
	ON p_Patient_WP_Item.cpr_id = p_Patient.cpr_id
	INNER JOIN p_Patient_Encounter WITH (NOLOCK)
	ON p_Patient_WP_Item.cpr_id = p_Patient_Encounter.cpr_id
	AND p_Patient_WP_Item.encounter_id = p_Patient_Encounter.encounter_id
	INNER JOIN c_Encounter_Type WITH (NOLOCK)
	ON p_Patient_Encounter.encounter_type = c_Encounter_Type.encounter_type
	INNER JOIN o_Service WITH (NOLOCK)
	ON p_Patient_WP_Item.ordered_service = o_Service.service
	LEFT OUTER JOIN c_User WITH (NOLOCK)
	ON p_Patient_Encounter.attending_doctor = c_User.user_id
	LEFT OUTER JOIN o_Rooms WITH (NOLOCK)
	ON p_Patient_Encounter.patient_location = o_Rooms.room_id
WHERE p_Patient_WP_Item.ordered_service = 'GET_PATIENT'
AND p_Patient_WP_Item.item_type = 'Service'
AND p_Patient_WP_Item.active_service_flag = 'Y'
AND p_Patient_WP.in_office_flag = 'Y'
AND p_Patient_Encounter.office_id = @ps_office_id
AND p_Patient_Encounter.encounter_status = 'OPEN'

