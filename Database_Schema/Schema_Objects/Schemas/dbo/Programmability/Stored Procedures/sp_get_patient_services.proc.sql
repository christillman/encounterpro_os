CREATE PROCEDURE sp_get_patient_services (
	@ps_cpr_id varchar(12),
	@ps_user_id varchar(24) = NULL)
AS
SELECT i.ordered_service,
	i.description,
	i.owned_by,
	i.patient_workplan_item_id,
	s.button,
	s.description as service_description
FROM	p_Patient_WP_Item i (NOLOCK),
	o_Service s (NOLOCK)
WHERE i.cpr_id = @ps_cpr_id
AND	i.active_service_flag = 'Y'
AND	i.item_type = 'Service'
AND	i.in_office_flag = 'Y'
AND	i.ordered_service = s.service
AND	(i.owned_by = @ps_user_id
	OR i.owned_by IN (
				SELECT role_id
				FROM c_User_Role
				WHERE user_id = @ps_user_id) )
AND NOT EXISTS (
		SELECT patient_workplan_item_id
		FROM o_User_Service_Lock l
		WHERE l.patient_workplan_item_id = i.patient_workplan_item_id)

