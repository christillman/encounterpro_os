
update c_Assessment_Definition 
set description = long_description
where assessment_id in (
'DEMO6674',
'DEMO6674Q',
'DEMO1409',
'DEMO1409A',
'DEMO4831',
'DEMO4831A',
'DEMO6525Q',
'DEMO6528Q',
'DEMO6637Q',
'DEMO6638Q',
'DEMO6639Q',
'DEMO6641Q',
'DEMO6636Q',
'DEMO11416aQ',
'DEMO11416bQ',
'DEMO11416cQ',
'DEMO11416dQ',
'DEMO11416eQ',
'DEMO11416fQ',
'DEMO11416gQ',
'DEMO11416hQ',
'DEMO9444',
'DEMO9445',
'DEMO9434',
'DEMO6523',
'DEMO4063',
'0^238.76^0',
'DEMO6517',
'DEMO9615',
'DEMO309',
'DEMO9632',
'DEMO4281',
'DEMO4778'
)


DELETE FROM c_Assessment_Definition
WHERE assessment_id in (
'DEMO9067',
'DEMO6724',
'DEMO6503Q'
)
DELETE FROM c_Assessment_Definition
WHERE assessment_id IN ('0001101x', '000188x') -- duplicates


update c_Assessment_Definition set acuteness='Chronic' where assessment_id = 'DEMO7325'
update c_Assessment_Definition set description ='Cenesthopathic schizophrenia' where assessment_id = 'DEMO9625'
update c_Assessment_Definition set assessment_category_id ='NOEAR' where assessment_id = '0^V72.19^0'
update c_Assessment_Definition set assessment_category_id ='YMMM' where assessment_id = '981^V58.32^0'


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

