CREATE PROCEDURE sp_Get_Patient_Service_List (
	@ps_office_id varchar(4),
	@ps_workplan_type varchar(12),
	@ps_service varchar(24) )
AS

SELECT DISTINCT
	p_Patient_WP_Item.patient_workplan_item_id,
	p_Patient.cpr_id,   
	p_Patient_Encounter.encounter_id,   
	p_Patient_Encounter.attending_doctor,   
	encounter_description = COALESCE(p_Patient_Encounter.encounter_description, c_Encounter_Type.description),  
	minutes=DATEDIFF(minute, p_Patient_WP_Item.dispatch_date, getdate()),   
	p_Patient.last_name,
	p_Patient.first_name,
	fullname = p_Patient.first_name + ' '+ p_Patient.last_name,
	selected_flag=0
FROM	p_Patient WITH (NOLOCK),
	p_Patient_Encounter WITH (NOLOCK), 
	p_Patient_WP WITH (NOLOCK),
	p_Patient_WP_Item WITH (NOLOCK),
	c_Encounter_Type WITH (NOLOCK)
WHERE p_Patient_WP_Item.ordered_service = @ps_service
AND p_Patient_WP_Item.item_type = 'Service'
AND p_Patient_WP_Item.active_service_flag = 'Y'
AND p_Patient_WP.cpr_id = p_Patient_WP_Item.cpr_id
AND p_Patient_WP.patient_workplan_id = p_Patient_WP_Item.patient_workplan_id
--AND p_Patient_WP.workplan_type = @ps_workplan_type
AND p_Patient_WP.cpr_id = p_Patient.cpr_id
AND p_Patient_WP.cpr_id = p_Patient_Encounter.cpr_id
AND p_Patient_WP.encounter_id = p_Patient_Encounter.encounter_id
AND p_Patient_Encounter.office_id = @ps_office_id
AND p_Patient_Encounter.encounter_type = c_Encounter_Type.encounter_type


