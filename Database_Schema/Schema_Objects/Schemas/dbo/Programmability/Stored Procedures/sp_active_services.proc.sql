CREATE PROCEDURE sp_active_services (
	@ps_in_office_flag char(1) = 'Y' )
AS

SELECT i.patient_workplan_id,   
	i.patient_workplan_item_id,   
	i.cpr_id,   
	i.encounter_id,   
	i.ordered_service,   
	i.followup_workplan_id,   
	i.description,   
	i.ordered_by,   
	i.ordered_for,   
	i.priority,   
	i.dispatch_date,   
	i.owned_by,   
	i.begin_date,   
	i.status,
	i.room_id,
	DATEDIFF(minute, i.dispatch_date, getdate()) as minutes,
	l.user_id,
	l.computer_id
FROM p_Patient_WP_Item i WITH (NOLOCK, INDEX (idx_active_services) )
	LEFT OUTER JOIN o_User_Service_Lock l WITH (NOLOCK)
	ON i.patient_workplan_item_id = l.patient_workplan_item_id
WHERE i.active_service_flag = 'Y'
AND i.in_office_flag = @ps_in_office_flag


