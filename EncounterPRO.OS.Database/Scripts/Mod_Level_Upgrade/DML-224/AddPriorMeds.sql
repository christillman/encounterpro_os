
  insert into [o_Service] (
   [service]
      ,[description]
      ,[button]
      ,[icon]
      ,[general_flag]
      ,[patient_flag]
      ,[encounter_flag]
      ,[assessment_flag]
      ,[treatment_flag]
      ,[observation_flag]
      ,[attachment_flag]
      ,[close_flag]
      ,[signature_flag]
      ,[owner_flag]
      ,[visible_flag]
      ,[secure_flag]
      ,[component_id]
      ,[order_url]
      ,[perform_url]
      ,[mf_order_url]
      ,[mf_perform_url]
      ,[status]
      ,[owner_id]
      ,[last_updated]
      ,[definition]
      ,[default_expiration_time]
      ,[default_expiration_unit_id]
      ,[default_context_object]
	  )
  SELECT 
   'PRIORMEDS'
      ,'Prior Meds'
      ,'Manage Meds.bmp'
      ,[icon]
      ,[general_flag]
      ,[patient_flag]
      ,[encounter_flag]
      ,[assessment_flag]
      ,[treatment_flag]
      ,[observation_flag]
      ,[attachment_flag]
      ,[close_flag]
      ,[signature_flag]
      ,[owner_flag]
      ,[visible_flag]
      ,[secure_flag]
      ,[component_id]
      ,[order_url]
      ,[perform_url]
      ,[mf_order_url]
      ,[mf_perform_url]
      ,[status]
      ,[owner_id]
      ,[last_updated]
      ,[definition]
      ,[default_expiration_time]
      ,[default_expiration_unit_id]
      ,[default_context_object]
FROM o_Service 
WHERE description = 'Current Meds'
	AND NOT EXISTS (select 1 
		FROM o_Service
		WHERE [service] = 'PRIORMEDS'
		)

insert into o_Service_Attribute (
[service]
      ,[attribute]
      ,[value]
	  )
SELECT 'PRIORMEDS','window_class','w_svc_prior_meds'
FROM o_Service_Attribute
WHERE NOT EXISTS (select 1 
	FROM o_Service_Attribute
	WHERE [service] = 'PRIORMEDS'
	AND value = 'w_svc_prior_meds'
		)

GO



insert into o_Service_Attribute (
[service]
      ,[user_id]
      ,[attribute]
      ,[value]
	  )
SELECT 'PRIORMEDS'
      ,[user_id]
      ,[attribute]
      ,[value]
FROM [o_Service_Attribute]
WHERE service = 'CURRENTMEDS'
AND [attribute] = 'menu_id'
AND NOT EXISTS (select 1 
	FROM o_Service_Attribute
	WHERE [service] = 'PRIORMEDS'
	AND [attribute] = 'menu_id'
		)

UPDATE [c_Menu_Item]
SET sort_sequence = sort_sequence * 10
where menu_id = 1000196

INSERT INTO [c_Menu_Item]
    ([menu_id]
    ,[menu_item_type]
    ,[menu_item]
    ,[button_title]
    ,[button_help]
    ,[button]
    ,[sort_sequence]
    ,[auto_close_flag]
    ,[authorized_user_id]
    ,[context_object])
SELECT 
	[menu_id]
    ,[menu_item_type]
    ,'PRIORMEDS'
    ,'Prior Meds'
    ,'Prior Meds'
    ,'Manage Meds.bmp'
    ,25
    ,[auto_close_flag]
    ,[authorized_user_id]
    ,[context_object] -- select menu_id
from [c_Menu_Item]
where  menu_item_id = 1001247
AND NOT EXISTS (
	SELECT 1 
	FROM [c_Menu_Item]
	where [menu_item] = 'PRIORMEDS'
	)

INSERT INTO [c_Treatment_Type] (
	[treatment_type]
      ,[component_id]
      ,[description]
      ,[in_office_flag]
      ,[define_title]
      ,[button]
      ,[icon]
      ,[sort_sequence]
      ,[followup_flag]
      ,[observation_type]
      ,[soap_display_rule]
      ,[composite_flag]
      ,[workplan_close_flag]
      ,[workplan_cancel_flag]
      ,[referral_specialty_id]
      ,[attachment_folder]
      ,[display_format]
      ,[risk_level]
      ,[complexity]
      ,[status]
      ,[display_script_id]
      ,[update_flag]
      ,[owner_id]
      ,[open_menu_id]
      ,[closed_menu_id]
      ,[past_treatment_menu_id]
      ,[bill_procedure]
      ,[bill_observation_collect]
      ,[bill_observation_perform]
      ,[bill_children_collect]
      ,[bill_children_perform]
      ,[default_duplicate_check_days]
      ,[epro_object]
	  )
SELECT 'PRIORMEDICATION'
      ,'TREAT_PRIORMED'
      ,'Prior Medication'
      ,'N'
      ,'Prior Medications'
      ,'Manage Meds.bmp'
      ,'ManageMedsIcon.bmp'
      ,20
      ,'N'
      ,'Drug'
      ,'No Results'
      ,[composite_flag]
      ,[workplan_close_flag]
      ,[workplan_cancel_flag]
      ,[referral_specialty_id]
      ,[attachment_folder]
      ,[display_format]
      ,[risk_level]
      ,[complexity]
      ,[status]
      ,[display_script_id]
      ,[update_flag]
      ,[owner_id]
      ,[open_menu_id]
      ,[closed_menu_id]
      ,[past_treatment_menu_id]
      ,0
      ,0
      ,0
      ,0
      ,0
      ,[default_duplicate_check_days]
      ,'TreatmentPriorMed'
  FROM [c_Treatment_Type]
WHERE treatment_type = 'OFFICEMED'
AND NOT EXISTS (
	SELECT 1 
	FROM [c_Treatment_Type]
	where treatment_type = 'PRIORMEDICATION'
	)

GO

INSERT INTO [c_Component_Registry] (
	[component_id]
      ,[component_type]
      ,[component]
      ,[description]
      ,[component_class]
      ,[component_location]
      ,[component_data]
      ,[component_install]
      ,[min_build]
      ,[owner_id]
      ,[status]
      ,[last_version_installed]
      ,[license_data]
      ,[license_status]
      ,[license_expiration_date]
	)
SELECT 'TREAT_PRIORMED'
      ,[component_type]
      ,[component]
      ,'Prior medication'
      ,[component_class]
      ,[component_location]
      ,[component_data]
      ,[component_install]
      ,[min_build]
      ,[owner_id]
      ,[status]
      ,[last_version_installed]
      ,[license_data]
      ,[license_status]
      ,[license_expiration_date]
  FROM [c_Component_Registry]
WHERE component_id = 'TREAT_MEDICATION'
AND NOT EXISTS (
	SELECT 1 
	FROM [c_Component_Registry]
	where component_id = 'TREAT_PRIORMED'
	)
