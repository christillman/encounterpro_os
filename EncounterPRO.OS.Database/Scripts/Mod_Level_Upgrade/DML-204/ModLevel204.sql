

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

UPDATE c_Chart_Page_Definition
SET status = 'NA'
WHERE page_class in (
'u_cpr_history_tabs','
u_cpr_page_history',
'u_develop',
'u_develop_combo',
'u_problem_list' )


UPDATE c_Database_Status   set modification_level = 204, last_scripts_update = getdate() where 1 = 1

  -- select * from [fn_database_schemacheck_columns]()