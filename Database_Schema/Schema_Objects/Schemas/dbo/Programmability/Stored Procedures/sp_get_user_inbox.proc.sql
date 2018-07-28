CREATE PROCEDURE sp_get_user_inbox (
	@ps_user_id varchar(24) )
AS

SELECT i.cpr_id,
	i.patient_workplan_id,
	i.patient_workplan_item_id,
	w.workplan_type,
	i.in_office_flag,
	i.description,
	i.ordered_service,
	i.ordered_for,
	i.dispatch_date,
	0 as selected_flag
FROM p_Patient_WP w WITH (NOLOCK),
	p_Patient_WP_item i WITH (NOLOCK)
WHERE w.patient_workplan_id = i.patient_workplan_id
AND i.ordered_for = @ps_user_id
AND i.item_type = 'Service'
AND i.active_service_flag = 'Y'

UNION

SELECT i.cpr_id,
	i.patient_workplan_id,
	i.patient_workplan_item_id,
	w.workplan_type,
	i.in_office_flag,
	i.description,
	i.ordered_service,
	i.ordered_for,
	i.dispatch_date,
	0 as selected_flag
FROM p_Patient_WP w WITH (NOLOCK),
	p_Patient_WP_item i WITH (NOLOCK),
	c_User_Role r WITH (NOLOCK)
WHERE w.patient_workplan_id = i.patient_workplan_id
AND i.ordered_for = r.role_id
AND r.user_id = @ps_user_id
AND i.item_type = 'Service'
AND i.active_service_flag = 'Y'

