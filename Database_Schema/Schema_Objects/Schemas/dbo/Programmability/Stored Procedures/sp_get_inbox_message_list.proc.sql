CREATE PROCEDURE sp_get_inbox_message_list (
	@ps_user_id varchar(24) )
AS
SELECT i.patient_workplan_item_id,
	i.ordered_service,
	s.description as service_description,
	s.button as service_button,
	s.icon as service_icon,
	i.ordered_by,
	i.description,
	i.dispatch_date,
	i.begin_date,
	i.end_date,
	i.status,
	i.folder,
	u.user_short_name as from_user,
	u.color as from_user_color,
	a.message,
	i.cpr_id,
	COALESCE(p.first_name + ' ', '') + COALESCE(p.last_name, '') as patient_name,
	selected_flag=0
FROM p_Patient_WP_Item i WITH (NOLOCK)
	INNER JOIN o_Service s WITH (NOLOCK)
	ON i.ordered_service = s.service
	INNER JOIN c_User u WITH (NOLOCK)
	ON i.ordered_by = u.user_id
	LEFT OUTER JOIN p_Patient_WP_Item_Attribute a WITH (NOLOCK)
	ON i.patient_workplan_item_id = a.patient_workplan_item_id
	LEFT OUTER JOIN p_Patient p WITH (NOLOCK)
	ON i.cpr_id = p.cpr_id
WHERE i.ordered_for = @ps_user_id
AND i.active_service_flag = 'Y'
AND i.ordered_service = 'MESSAGE'
AND a.attribute = 'MESSAGE'

