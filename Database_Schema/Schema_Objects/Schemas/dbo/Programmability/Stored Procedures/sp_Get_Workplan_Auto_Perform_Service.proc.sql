CREATE PROCEDURE sp_Get_Workplan_Auto_Perform_Service
	@pl_patient_workplan_id int,
	@ps_user_id varchar(24)
AS

DECLARE @ll_patient_workplan_item_id int

SELECT @ll_patient_workplan_item_id = min(i.patient_workplan_item_id)
FROM p_Patient_WP_Item i
LEFT OUTER JOIN c_user_role r WITH (NOLOCK)
	ON 	i.owned_by = r.role_id
WHERE i.patient_workplan_id = @pl_patient_workplan_id
AND i.active_service_flag = 'Y'
AND i.auto_perform_flag = 'Y'
AND (   i.owned_by IS NULL
		OR i.owned_by = @ps_user_id
		OR r.user_id = @ps_user_id
	)

IF @ll_patient_workplan_item_id IS NULL
	SET @ll_patient_workplan_item_id = 0

RETURN @ll_patient_workplan_item_id

