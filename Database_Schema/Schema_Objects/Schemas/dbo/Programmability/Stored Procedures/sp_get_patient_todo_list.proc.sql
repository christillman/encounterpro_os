CREATE PROCEDURE sp_get_patient_todo_list (
	@ps_cpr_id varchar(24),
	@ps_service varchar(24) = '%',
	@pc_finished_items char(1) = 'N' )
AS
IF @ps_service IS NULL
	SELECT @ps_service = '%'

IF @pc_finished_items = 'N'
BEGIN
SELECT i.ordered_for,
	i.patient_workplan_item_id,
	i.ordered_service,
	s.description as service_description,
	s.icon as service_icon,
	i.ordered_by,
	i.description,
	i.dispatch_date,
	i.begin_date,
	i.end_date,
	i.status,
	u.user_short_name,
	u.color,
	selected_flag=0
FROM 	p_Patient_WP_Item i WITH (NOLOCK)
	, o_Service s WITH (NOLOCK)
	, c_User u WITH (NOLOCK)
WHERE i.cpr_id= @ps_cpr_id
AND i.active_service_flag = 'Y'
AND i.ordered_service like @ps_service
AND i.ordered_service <> 'MESSAGE'
AND i.ordered_service = s.service
AND i.ordered_for = u.user_id
AND NOT EXISTS (
	SELECT patient_workplan_item_id
	FROM o_User_Service_Lock WITH (NOLOCK)
	WHERE patient_workplan_item_id = i.patient_workplan_item_id
	)
END

ELSE
BEGIN
SELECT i.ordered_for,
	i.patient_workplan_item_id,
	i.ordered_service,
	s.description as service_description,
	s.icon as service_icon,
	i.ordered_by,
	i.description,
	i.dispatch_date,
	i.begin_date,
	i.end_date,
	i.status,
	u.user_short_name,
	u.color,
	selected_flag=0
FROM 	p_Patient_WP_Item i WITH (NOLOCK)
	, o_Service s WITH (NOLOCK)
	, c_User u WITH (NOLOCK)
WHERE i.cpr_id= @ps_cpr_id
AND i.status = 'COMPLETED'
AND i.ordered_service like @ps_service
AND i.ordered_service <> 'MESSAGE'
AND i.ordered_service = s.service
AND i.ordered_for = u.user_id
END

