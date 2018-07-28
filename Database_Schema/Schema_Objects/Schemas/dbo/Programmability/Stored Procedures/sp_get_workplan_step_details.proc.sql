CREATE PROCEDURE sp_get_workplan_step_details (
	@pi_workplan_id int,
	@pi_step_number int )
AS

  SELECT c_Workplan_Item.workplan_id,   
         c_Workplan_Item.item_number,   
         c_Workplan_Item.step_number,   
         c_Workplan_Item.item_type,   
         c_Workplan_Item.ordered_service,   
         c_Workplan_Item.ordered_treatment_type,   
         c_Workplan_Item.ordered_workplan_id,   
         c_Workplan_Item.ordered_for,   
         c_Workplan_Item.description,   
         c_Workplan_Item.button_title,   
         c_Workplan_Item.button_help,   
         c_Workplan_Item.age_range_id,   
         c_Workplan_Item.sex,   
         c_Workplan_Item.new_flag,   
         selected_flag=0,   
         temp_item_number=0,   
         c_Workplan_Item.modes,   
         c_User.user_short_name,   
         c_User.color as user_color,   
         c_Role.color as role_color,   
         c_Role.role_name,   
         c_Domain.domain_item_description as special_description,   
         c_Workplan_Item.escalation_time,   
         c_Workplan_Item.escalation_unit_id,   
         c_Workplan_Item.expiration_time,   
         c_Workplan_Item.expiration_unit_id,   
         c_Workplan_Item.in_office_flag,   
         c_Treatment_Type.description as treatment_type_description,   
         o_Service.description as service_description,   
         c_Workplan_Item.priority,   
         c_Workplan_Item.sort_sequence,   
         c_Workplan_Item.step_flag,   
         c_Workplan_Item.auto_perform_flag,   
         c_Treatment_Type.followup_flag,   
         c_Workplan_Item.followup_workplan_id,   
         c_Workplan_Item.cancel_workplan_flag,   
         c_Workplan_Item.consolidate_flag,   
         c_Workplan_Item.owner_flag,   
         c_Workplan_Item.runtime_configured_flag,   
         c_Workplan_Item.abnormal_flag,   
         c_Workplan_Item.severity,   
         c_Workplan_Item.observation_tag  
    FROM c_Workplan_Item LEFT OUTER JOIN c_User ON c_Workplan_Item.ordered_for = c_User.user_id LEFT OUTER JOIN c_Role ON c_Workplan_Item.ordered_for = c_Role.role_id LEFT OUTER JOIN c_Treatment_Type ON c_Workplan_Item.ordered_treatment_type = c_Treatment_Type.treatment_type LEFT OUTER JOIN o_Service ON c_Workplan_Item.ordered_service = o_Service.service LEFT OUTER JOIN c_Domain ON ( c_Workplan_Item.ordered_for = c_Domain.domain_item  AND c_Domain.domain_id = 'ORDERED_FOR_SPECIAL' ) 
   WHERE ( c_Workplan_Item.workplan_id = @pi_workplan_id ) AND  
         ( c_Workplan_Item.step_number = @pi_step_number )   


