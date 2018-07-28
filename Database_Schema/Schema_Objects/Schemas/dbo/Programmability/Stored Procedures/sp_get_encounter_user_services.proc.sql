CREATE    PROCEDURE sp_get_encounter_user_services
	@ps_cpr_id varchar(12),
	@pl_encounter_id int ,
	@ps_user_id varchar(24)
AS

SELECT w.patient_workplan_id,   
         w.cpr_id,   
         w.workplan_type,   
         w.in_office_flag,   
         w.encounter_id,   
         w.problem_id,   
         w.treatment_id,   
         w.observation_sequence,   
         w.attachment_id,   
         w.description,   
         w.status,   
         i.patient_workplan_item_id,   
         i.description,   
         i.ordered_for  
FROM p_Patient_WP w
	INNER JOIN p_Patient_WP_Item i
	ON w.patient_workplan_id = i.patient_workplan_id
	LEFT OUTER JOIN c_user_role r WITH (NOLOCK)
	ON 	i.owned_by = r.role_id
	LEFT OUTER JOIN o_User_Service_Lock l WITH (NOLOCK)
	ON 	i.patient_workplan_item_id = l.patient_workplan_item_id 
WHERE w.cpr_id = @ps_cpr_id
AND w.encounter_id = @pl_encounter_id
AND i.active_service_flag = 'Y'
AND l.patient_workplan_item_id IS NULL
AND
(	   i.owned_by IS NULL
	OR i.owned_by = @ps_user_id
	OR r.user_id = @ps_user_id
)
