

-- This seems to have been a transposition
UPDATE o_Service_Attribute
SET value = 'w_svc_assessment_close'
WHERE value = 'w_svc_close_assessment'

-- These objects, referenced in the DB, are not available in EncounterPro-OS
UPDATE [c_Component_Registry]
SET status = 'NA'
WHERE component_class IN (
'u_component_billing_medicat',
'u_component_billing_paradigm',
'u_component_billing_paradigm3',
'u_component_billing_raintree',
'u_component_chartpage',
'u_component_e_prescribing',
'u_component_event_message',
'u_component_event_server',
'u_component_message_creator_labs',
'u_component_message_handler_hl7',
'u_component_observation_brentwood_spirometer',
'u_component_report_encounter',
'u_component_report_letter_to_referrer',
'u_component_report_patient_summary',
'u_component_report_prescription2',
'u_component_report_referral_prescription',
'u_component_report_xml',
'u_component_schedule_paradigm',
'u_component_schedule_paradigm3',
'u_component_schedule_raintree',
'u_component_serverservice_autoimport',
'u_component_serverservice_email',
'u_component_service_create_document',
'u_component_service_epro_todo',
'u_component_service_order_document',
'u_component_service_post_attachment',
'u_component_service_transcription'
)


DELETE FROM [c_Database_Column]
WHERE tablename = 'c_Assessment_Category' and columnname = 'is_default'

INSERT INTO [c_Database_Column]
           ([tablename]
           ,[columnname]
           ,[column_sequence]
           ,[column_datatype]
           ,[column_length]
           ,[column_identity]
           ,[column_nullable]
           ,[column_definition]
           ,[default_constraint]
           ,[default_constraint_name]
           ,[default_constraint_text]
           ,[modification_level]
           ,[last_updated])
     VALUES
           ('c_Assessment_Category'
           ,'is_default'
           ,7
           ,'char'
           ,1
           ,0
           ,1
           ,'[char](1)'
           ,0
           ,null
           ,null
           ,204
           ,getdate()
		   )

DELETE FROM [c_Database_Column]
WHERE tablename = 'c_Assessment_Coding' and columnname = 'icd_9_code'

INSERT INTO [c_Database_Column]
           ([tablename]
           ,[columnname]
           ,[column_sequence]
           ,[column_datatype]
           ,[column_length]
           ,[column_identity]
           ,[column_nullable]
           ,[column_definition]
           ,[default_constraint]
           ,[default_constraint_name]
           ,[default_constraint_text]
           ,[modification_level]
           ,[last_updated])
     VALUES
           ('c_Assessment_Coding'
           ,'icd_9_code'
           ,3
           ,'varchar'
           ,12
           ,0
           ,1
           ,'[varchar](12)'
           ,0
           ,null
           ,null
           ,204
           ,getdate()
		   )

UPDATE [c_Database_Column] 
SET [column_sequence] = 4, [column_length] = 10, [last_updated] = getdate(), [modification_level] = 204
WHERE tablename = 'c_Assessment_Coding' and columnname = 'icd10_code' 

UPDATE [c_Database_Column] 
SET [default_constraint] = 0, 
	[default_constraint_name] = NULL,
	[default_constraint_text] = NULL,
	[column_nullable] = 1, [last_updated] = getdate(), [modification_level] = 204
WHERE tablename = 'c_Assessment_Definition' and columnname = 'acuteness' 


DELETE FROM [c_Database_Column]
WHERE tablename = 'c_Assessment_Definition' and columnname = 'icd_9_code'

INSERT INTO [c_Database_Column]
           ([tablename]
           ,[columnname]
           ,[column_sequence]
           ,[column_datatype]
           ,[column_length]
           ,[column_identity]
           ,[column_nullable]
           ,[column_definition]
           ,[default_constraint]
           ,[default_constraint_name]
           ,[default_constraint_text]
           ,[modification_level]
           ,[last_updated])
     VALUES
           ('c_Assessment_Definition'
           ,'icd_9_code'
           ,7
           ,'varchar'
           ,12
           ,0
           ,1
           ,'[varchar](12)'
           ,0
           ,null
           ,null
           ,204
           ,getdate()
		   )


UPDATE [c_Database_Column] 
SET [column_nullable] = 1, [column_sequence] = 26, [last_updated] = getdate(), [modification_level] = 204
WHERE tablename = 'c_Assessment_Definition' and columnname = 'icd10_code' 

UPDATE [c_Database_Column] 
SET [column_datatype] = 'varchar', [column_length] = 500, [column_definition] = '[varchar](500)'
, [last_updated] = getdate(), [modification_level] = 204
WHERE tablename = 'c_Assessment_Definition' and columnname = 'long_description' 

DELETE FROM [c_Database_Column]
WHERE tablename = 'c_Assessment_Definition' and columnname = 'source'

INSERT INTO [c_Database_Column]
           ([tablename]
           ,[columnname]
           ,[column_sequence]
           ,[column_datatype]
           ,[column_length]
           ,[column_identity]
           ,[column_nullable]
           ,[column_definition]
           ,[default_constraint]
           ,[default_constraint_name]
           ,[default_constraint_text]
           ,[modification_level]
           ,[last_updated])
     VALUES
           ('c_Assessment_Definition'
           ,'source'
           ,27
           ,'varchar'
           ,10
           ,0
           ,1
           ,'[varchar](10)'
           ,0
           ,null
           ,null
           ,204
           ,getdate()
		   )

DELETE FROM [c_Database_Column]
WHERE tablename = 'c_Assessment_Definition' and columnname = 'icd10_who_code'

INSERT INTO [c_Database_Column]
           ([tablename]
           ,[columnname]
           ,[column_sequence]
           ,[column_datatype]
           ,[column_length]
           ,[column_identity]
           ,[column_nullable]
           ,[column_definition]
           ,[default_constraint]
           ,[default_constraint_name]
           ,[default_constraint_text]
           ,[modification_level]
           ,[last_updated])
     VALUES
           ('c_Assessment_Definition'
           ,'icd10_who_code'
           ,28
           ,'varchar'
           ,10
           ,0
           ,1
           ,'[varchar](10)'
           ,0
           ,null
           ,null
           ,204
           ,getdate()
		   )

	


DELETE FROM [c_Database_Column]
WHERE tablename = 'c_Authority_Formulary' and columnname = 'icd_9_code'

INSERT INTO [c_Database_Column]
           ([tablename]
           ,[columnname]
           ,[column_sequence]
           ,[column_datatype]
           ,[column_length]
           ,[column_identity]
           ,[column_nullable]
           ,[column_definition]
           ,[default_constraint]
           ,[default_constraint_name]
           ,[default_constraint_text]
           ,[modification_level]
           ,[last_updated])
     VALUES
           ('c_Authority_Formulary'
           ,'icd_9_code'
           ,4
           ,'varchar'
           ,12
           ,0
           ,1
           ,'[varchar](12)'
           ,0
           ,null
           ,null
           ,204
           ,getdate()
		   )

UPDATE [c_Database_Column] 
SET [column_length] = 10, [column_sequence] = 8, [last_updated] = getdate(), [modification_level] = 204
WHERE tablename = 'c_Authority_Formulary' and columnname = 'icd10_code' 


DELETE FROM [c_Database_Column]
WHERE tablename = 'c_Component_Type' and columnname = 'plugin_type'

DELETE FROM [c_Database_Column]
WHERE tablename = 'c_Config_Object' and columnname = 'installed_local_key'

UPDATE [c_Database_Column] 
SET [column_length] = 80, [last_updated] = getdate(), [modification_level] = 204
WHERE tablename = 'c_Drug_Definition' and columnname = 'common_name' 

UPDATE [c_Database_Column] 
SET [column_length] = 500, [last_updated] = getdate(), [modification_level] = 204
WHERE tablename = 'c_Drug_Definition' and columnname = 'generic_name' 


DELETE FROM [c_Database_Column]
WHERE tablename = 'c_Maintenance_Assessment' and columnname = 'icd_9_code'

INSERT INTO [c_Database_Column]
           ([tablename]
           ,[columnname]
           ,[column_sequence]
           ,[column_datatype]
           ,[column_length]
           ,[column_identity]
           ,[column_nullable]
           ,[column_definition]
           ,[default_constraint]
           ,[default_constraint_name]
           ,[default_constraint_text]
           ,[modification_level]
           ,[last_updated])
     VALUES
           ('c_Maintenance_Assessment'
           ,'icd_9_code'
           ,5
           ,'varchar'
           ,12
           ,0
           ,1
           ,'[varchar](12)'
           ,0
           ,null
           ,null
           ,204
           ,getdate()
		   )


UPDATE [c_Database_Column] 
SET [column_length] = 10, [column_sequence] = 6, [last_updated] = getdate(), [modification_level] = 204
WHERE tablename = 'c_Maintenance_Assessment' and columnname = 'icd10_code' 


DELETE FROM [c_Database_Column]
WHERE tablename = 'c_Reccomended_Observation'

UPDATE [c_Database_Column] 
SET default_constraint = 1, [last_updated] = getdate(), [modification_level] = 204
WHERE tablename = 'o_Service' and columnname = 'id' 

UPDATE [c_Database_Column] 
SET column_length = 24, [last_updated] = getdate(), [modification_level] = 204
WHERE tablename = 'p_Assessment' and columnname = 'acuteness' 



DELETE FROM [c_Database_Column]
WHERE tablename = 'p_Encounter_Assessment' and columnname = 'icd_9_code'

INSERT INTO [c_Database_Column]
           ([tablename]
           ,[columnname]
           ,[column_sequence]
           ,[column_datatype]
           ,[column_length]
           ,[column_identity]
           ,[column_nullable]
           ,[column_definition]
           ,[default_constraint]
           ,[default_constraint_name]
           ,[default_constraint_text]
           ,[modification_level]
           ,[last_updated])
     VALUES
           ('p_Encounter_Assessment'
           ,'icd_9_code'
           ,5
           ,'varchar'
           ,12
           ,0
           ,1
           ,'[varchar](12)'
           ,0
           ,null
           ,null
           ,204
           ,getdate()
		   )


UPDATE [c_Database_Column] 
SET [column_length] = 10, [column_sequence] = 14, [last_updated] = getdate(), [modification_level] = 204
WHERE tablename = 'p_Encounter_Assessment' and columnname = 'icd10_code' 

UPDATE [c_Database_Column] 
SET [column_length] = 80, [last_updated] = getdate(), [modification_level] = 204
WHERE tablename = 'p_Patient' and columnname = 'address_line_1' 


DELETE FROM [c_Database_Column]
WHERE tablename = 'p_Patient_Progress' and columnname = 'id'

UPDATE c_Chart_Page_Definition
SET status = 'NA'
WHERE page_class in (
'u_cpr_history_tabs','
u_cpr_page_history',
'u_develop',
'u_develop_combo',
'u_problem_list' )


UPDATE c_Database_Status   set modification_level = 204, last_scripts_update = getdate() 
where 1 = 1

  -- select * from [fn_database_schemacheck_columns]()