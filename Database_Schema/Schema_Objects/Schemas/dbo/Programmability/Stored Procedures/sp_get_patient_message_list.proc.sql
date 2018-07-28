CREATE PROCEDURE sp_get_patient_message_list (
	@ps_cpr_id varchar(12) )
AS

SELECT distinct patient_workplan_item_id
INTO #tmp_patient_msgs
FROM p_Patient_WP_Item WITH (NOLOCK)
WHERE ordered_service = 'MESSAGE'
AND cpr_id = @ps_cpr_id

SELECT i.ordered_for,
	i.patient_workplan_item_id,
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
	f.user_short_name as from_user,
	f.color as from_user_color,
	t.user_short_name as to_user,
	t.color as to_user_color,
	selected_flag=0
FROM 	p_Patient_WP_Item i WITH (NOLOCK)
	, o_Service s WITH (NOLOCK)
	, c_User f WITH (NOLOCK)
	, c_User t WITH (NOLOCK)
	, #tmp_patient_msgs
WHERE i.patient_workplan_item_id = #tmp_patient_msgs.patient_workplan_item_id
AND s.service = 'MESSAGE'
AND i.ordered_for = t.user_id
AND i.ordered_by = f.user_id

DROP TABLE #tmp_patient_msgs

