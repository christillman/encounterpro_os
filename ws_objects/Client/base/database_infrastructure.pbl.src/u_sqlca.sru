$PBExportHeader$u_sqlca.sru
forward
global type u_sqlca from transaction
end type
type str_sql_syntax from structure within u_sqlca
end type
type str_scripts from structure within u_sqlca
end type
type str_script from structure within u_sqlca
end type
end forward

type str_sql_syntax from structure
	string		sql_string
	string		dw_syntax
end type

type str_scripts from structure
	long		script_count
	str_script		script[]
end type

type str_script from structure
	string		script_type
	string		script
end type

global type u_sqlca from transaction
end type
global u_sqlca u_sqlca

type prototypes
SUBROUTINE PatientVisitInsert (datetime ldt_dateofentry,long ll_appointmentsid,long ll_patientprofileid,long ll_FinancialClassMId,long ll_DoctorId,long facilityid,long companyid,datetime ldt_encounter_date,string ls_description,long ll_BillStatus,long ll_CurrentCarrier,string ls_TicketNumber,long ll_PrimaryPICarrierId,long ll_PrimaryInsuranceCarriersId,long ll_CurrentPICarrierId,long ll_CurrentInsuranceCarriersId,long ll_FilingMethodMLC,integer li_AcceptAssignment,long ll_refdoctorid,long ll_siteid,REF long ll_patientvisitid,string ls_exists ) RPCFUNC ALIAS FOR "dbo.cprPatientVisitInsert"
SUBROUTINE PostProcedure (long ProceduresId,long PatientVisitId,long PatientVisitDiagsId1,long PatientVisitDiagsId2,long PatientVisitDiagsId3,long PatientVisitDiagsId4,long PatientVisitDiagsId5,long PatientVisitDiagsId6,long PatientVisitDiagsId7,long PatientVisitDiagsId8,long PatientVisitDiagsId9,long Units,REF long PatientVisitProcsId) RPCFUNC ALIAS FOR "dbo.cprPostProcedure"
SUBROUTINE PatientDateService (long ll_patientvisitid,REF long ll_patientprofileid,REF datetime ldt_dateofservice) RPCFUNC ALIAS FOR "dbo.cprPatientDateService"
SUBROUTINE PatientVisitInsert41 (datetime ldt_dateofentry,long ll_appointmentsid,long ll_patientprofileid,long ll_FinancialClassMId,long ll_DoctorId,long facilityid,long companyid,datetime ldt_encounter_date,string ls_description,long ll_BillStatus,long ll_CurrentCarrier,string ls_TicketNumber,long ll_PrimaryPICarrierId,long ll_PrimaryInsuranceCarriersId,long ll_CurrentPICarrierId,long ll_CurrentInsuranceCarriersId,long ll_FilingMethodMID,integer li_FilingType,integer li_AcceptAssignment,long ll_refdoctorid,long ll_siteid,REF long ll_patientvisitid,string ls_exists,long ll_supervisor ) RPCFUNC ALIAS FOR "dbo.cprPatientVisitInsert41"
SUBROUTINE DeleteWorkplan (long ll_workplan_id,REF string ls_referenced_table) RPCFUNC ALIAS FOR "dbo.sp_delete_workplan"

function Ulong dbcancel(Ulong dbhandle) LIBRARY "Ntwdblib.dll"
function Ulong dbcanquery(Ulong dbhandle) LIBRARY "Ntwdblib.dll"



FUNCTION long	 config_cancel_checkout(string ps_config_object_id,string ps_checked_out_by) RPCFUNC ALIAS FOR "dbo.config_cancel_checkout"
FUNCTION long	 config_checkin(string ps_config_object_id, string ps_version_description, blob pbl_objectdata, string ps_checked_out_by) RPCFUNC ALIAS FOR "dbo.config_checkin"
FUNCTION long	 config_checkout(string ps_config_object_id, string ps_version_description, string ps_checked_out_by) RPCFUNC ALIAS FOR "dbo.config_checkout"
FUNCTION long      config_copy_object(string ps_copy_from_config_object_id, long pl_copy_from_version, string ps_new_description,string ps_created_by,ref string ps_new_config_object_id) RPCFUNC ALIAS FOR "dbo.config_copy_object"
FUNCTION long	 config_create_object(string ps_config_object_id, string ps_config_object_type, string ps_description, string ps_long_description, string ps_config_object_category, blob pbl_objectdata, string ps_created_by) RPCFUNC ALIAS FOR "dbo.config_create_object"
FUNCTION long	 config_create_object_version(string ps_config_object_id, string ps_config_object_type, string ps_context_object, long pl_owner_id, string ps_description, string ps_long_description, string ps_config_object_category, long pl_version, blob pbl_objectdata, string ps_created_by, string ps_status, string ps_version_description, string ps_copyright_status, string ps_copyable, string ps_object_encoding_method) RPCFUNC ALIAS FOR "dbo.config_create_object_version"
FUNCTION long	 config_delete_interface(long pl_interfaceServiceId) RPCFUNC ALIAS FOR "dbo.config_delete_interface"
FUNCTION long	 config_download_library_object(string ps_config_object_id, long pl_version, string ps_created_by) RPCFUNC ALIAS FOR "dbo.config_download_library_object"
FUNCTION long	 config_import_object(string px_objectdata) RPCFUNC ALIAS FOR "dbo.config_import_object"
FUNCTION long	 config_install_object(string ps_config_object_id, long pl_version) RPCFUNC ALIAS FOR "dbo.config_install_object"
FUNCTION long	 config_new_config_object(string ps_config_object_id, string ps_config_object_type, string ps_context_object, string ps_description, string ps_long_description, string ps_config_object_category, long pl_owner_id, string ps_created_by) RPCFUNC ALIAS FOR "dbo.config_new_config_object"
FUNCTION long	 config_new_config_object_version(string ps_config_object_id, long pl_version, blob pbl_objectdata, long ps_created_from_version, string ps_created_by, string ps_status, datetime pdt_status_date_time, string ps_version_description, string ps_release_status, datetime pdt_release_status_date_time) RPCFUNC ALIAS FOR "dbo.config_new_config_object_version"
FUNCTION long	 config_rename_object(string ps_config_object_id, string ps_new_description) RPCFUNC ALIAS FOR "dbo.config_rename_object"
FUNCTION long	 config_sync_library() RPCFUNC ALIAS FOR "dbo.config_sync_library"

FUNCTION long	 jmj_component_log(string ps_component_id , long pl_version, string ps_operation, datetime pdt_operation_date_time , long pl_computer_id , string ps_operation_as_user , string ps_completion_status , string ps_error_message , string ps_created_by  ) RPCFUNC ALIAS FOR "dbo.jmj_component_log"
FUNCTION long jmj_copy_assessment_treatment_list(string ps_From_assessment_id,string ps_From_user_id,string ps_To_assessment_id,string ps_To_user_id,string ps_Action) RPCFUNC ALIAS FOR "dbo.jmj_copy_assessment_treatment_list"
FUNCTION long	 jmj_create_local_vaccine_schedule(ref string ps_config_object_id) RPCFUNC ALIAS FOR "dbo.jmj_create_local_vaccine_schedule"
FUNCTION long	 jmj_document_order_workplan(string ps_cpr_id, string ps_context_object, long pl_object_key, string ps_purpose, string ps_new_object, string ps_ordered_by, string ps_created_by, string ps_workplan_description) RPCFUNC ALIAS FOR "dbo.jmj_document_order_workplan"
FUNCTION long	 jmj_document_set_recipient(long pl_patient_workplan_item_id, string ps_ordered_for, string ps_dispatch_method, string ps_address_attribute, string ps_address_value, string ps_user_id, string ps_created_by) RPCFUNC ALIAS FOR "dbo.jmj_document_set_recipient"
FUNCTION long	 jmj_log_database_maintenance(string ps_action, string ps_completion_status, string ps_action_argument, string ps_build, string ps_comment) RPCFUNC ALIAS FOR "dbo.jmj_log_database_maintenance"
FUNCTION long	 jmj_new_attachment(string ps_description, string ps_attachment_file, string ps_extension, long pl_owner_id, long pl_box_id, long pl_item_id, long pl_interfaceserviceid, long pl_transportsequence, long pl_patient_workplan_item_id, string ps_attached_by, string ps_created_by) RPCFUNC ALIAS FOR "dbo.jmj_new_attachment"
FUNCTION long	 jmj_new_attachment2(string ps_description, string ps_attachment_file, string ps_extension, long pl_owner_id, long pl_box_id, long pl_item_id, long pl_interfaceserviceid, long pl_transportsequence, long pl_patient_workplan_item_id, string ps_attached_by, string ps_created_by, string ps_id) RPCFUNC ALIAS FOR "dbo.jmj_new_attachment2"
FUNCTION long	 jmj_new_datafile(string ps_description, string ps_context_object , string ps_component_id , string ps_created_by , string ps_status , string ps_long_description , REF string ps_report_id) RPCFUNC ALIAS FOR "dbo.jmj_new_datafile"
FUNCTION long	 jmj_new_document_config_object(string ps_config_object_type, string ps_description, string ps_context_object , string ps_component_id , string ps_created_by , string ps_status , string ps_long_description , REF string ps_report_id) RPCFUNC ALIAS FOR "dbo.jmj_new_document_config_object"
FUNCTION long	 jmj_new_maintenance_schedule(string ps_user_id, string ps_service , string ps_schedule_type ,  string ps_schedule_interval , string ps_created_by) RPCFUNC ALIAS FOR "dbo.jmj_new_maintenance_schedule"
FUNCTION long	 jmj_new_room(string ps_room_type, string ps_room_name, string ps_office_id, ref string ps_room_id) RPCFUNC ALIAS FOR "dbo.jmj_new_room"
FUNCTION long	 jmj_run_scheduled_service(long pl_service_sequence, string ps_ordered_by, string ps_created_by) RPCFUNC ALIAS FOR "dbo.jmj_run_scheduled_service"
FUNCTION long	 jmj_set_incoming_attachment_ready(long pl_attachment_id, long pl_interfaceserviceid, long pl_transportsequence, string ps_user_id, string ps_created_by) RPCFUNC ALIAS FOR "dbo.jmj_set_incoming_attachment_ready"
FUNCTION long	 jmj_set_treatment_observation_billing(string ps_cpr_id, long pl_encounter_id, long pl_treatment_id, string ps_created_by) RPCFUNC ALIAS FOR "dbo.jmj_set_treatment_observation_billing"

FUNCTION long	 jmj_set_office_actor(string ps_unmapped_office_user_id, string ps_mapped_to_office_id, string ps_created_by, ref string ps_mapped_office_user_id) RPCFUNC ALIAS FOR "dbo.jmj_set_office_actor"

FUNCTION long	 jmj_set_maintenance_service_attribute(long pl_service_sequence, string ps_attribute, string ps_value) RPCFUNC ALIAS FOR "dbo.jmj_set_maintenance_service_attribute"

	
FUNCTION long	 jmj_Set_Patient_IDValue(string ps_cpr_id, long pl_owner_id, string ps_IDDomain, string ps_IDValue, string ps_created_by) RPCFUNC ALIAS FOR "dbo.jmj_Set_Patient_IDValue"
FUNCTION long	 jmj_Set_User_IDValue(string ps_user_id, long pl_owner_id, string ps_IDDomain, string ps_IDValue, string ps_created_by) RPCFUNC ALIAS FOR "dbo.jmj_Set_User_IDValue"

FUNCTION long	 jmj_treatment_type_set_default_mode(string ps_office_id, string ps_treatment_type, string ps_treatment_mode, string ps_created_by) RPCFUNC ALIAS FOR "dbo.jmj_treatment_type_set_default_mode"

FUNCTION long	 jmj_upload_config_object(string ps_config_object_id, long pl_version, string ps_user_id) RPCFUNC ALIAS FOR "dbo.jmj_upload_config_object"

FUNCTION long	 jmj_upload_params(string ps_id) RPCFUNC ALIAS FOR "dbo.jmj_upload_params"

function long jmjsys_daily_sync() RPCFUNC ALIAS FOR "dbo.jmjsys_daily_sync"
function long jmjsys_upgrade_mod_level(long pl_modification_level) RPCFUNC ALIAS FOR "dbo.jmjsys_upgrade_mod_level"

FUNCTION long sp_new_display_script_command(long pl_display_script_id, string ps_context_object, string ps_display_command, long pl_sort_sequence, string ps_status) RPCFUNC ALIAS FOR "dbo.sp_new_display_script_command"

// Find patient cpr_id from 3rd party ID
FUNCTION string fn_lookup_patient2(long pl_ID_owner_id, string ps_IDDomain, string ps_IDValue) RPCFUNC ALIAS FOR "dbo.fn_lookup_patient2"

// Lookup 3rd party ID for patient
FUNCTION string fn_lookup_patient_ID(string ps_cp_id, long pl_ID_owner_id, string ps_IDDomain) RPCFUNC ALIAS FOR "dbo.fn_lookup_patient_ID"

FUNCTION string fn_lookup_user_ID(string ps_user_id, long pl_owner_id, string ps_IDDomain) RPCFUNC ALIAS FOR "dbo.fn_lookup_user_ID"
FUNCTION string fn_lookup_user_IDValue(long pl_owner_id, string ps_IDDomain, string ps_IDValue) RPCFUNC ALIAS FOR "dbo.fn_lookup_user_IDValue"
FUNCTION string fn_user_property(string ps_user_id, string ps_progress_type, string ps_progress_key) RPCFUNC ALIAS FOR "dbo.fn_user_property"

// System procedures
FUNCTION long sp_setapprole (string ls_rolename, string ls_password, string ls_encrypt) RPCFUNC ALIAS FOR "dbo.sp_setapprole"
FUNCTION long sp_approlepassword (string ls_rolename, string ls_newpwd) RPCFUNC ALIAS FOR "dbo.sp_approlepassword"
FUNCTION long sp_addapprole (string ls_rolename, string ls_password) RPCFUNC ALIAS FOR "dbo.sp_addapprole"

FUNCTION long sp_droprolemember (string ls_rolename, string ls_membername) RPCFUNC ALIAS FOR "dbo.sp_droprolemember"
FUNCTION long sp_addrolemember (string ls_rolename, string ls_membername) RPCFUNC ALIAS FOR "dbo.sp_addrolemember"
FUNCTION long sp_addlogin (string ls_loginame, string ls_passwd) RPCFUNC ALIAS FOR "dbo.sp_addlogin"
FUNCTION long sp_grantdbaccess (string ls_loginame) RPCFUNC ALIAS FOR "dbo.sp_grantdbaccess"
FUNCTION long sp_dropuser (string ls_name_in_db) RPCFUNC ALIAS FOR "dbo.sp_dropuser"
FUNCTION long sp_password (string ls_old, string ls_new, string ls_loginame) RPCFUNC ALIAS FOR "dbo.sp_password"
FUNCTION long sp_addlinkedserver (string ps_server, string ps_srvproduct, string ps_provider, string ps_datasrc, string ps_location, string ps_provstr, string ps_catalog) RPCFUNC ALIAS FOR "dbo.sp_addlinkedserver"
FUNCTION long sp_addlinkedsrvlogin (string ps_rmtsrvname, string ps_useself, string ps_locallogin, string ps_rmtuser, string ps_rmtpassword) RPCFUNC ALIAS FOR "dbo.sp_addlinkedsrvlogin"
FUNCTION long sp_dropserver (string ps_server, string ps_droplogins) RPCFUNC ALIAS FOR "dbo.sp_dropserver"
FUNCTION long sp_serveroption (string ps_server, string ps_optname, string ps_optvalue) RPCFUNC ALIAS FOR "dbo.sp_serveroption"

// User Defined Functions

FUNCTION long	 fn_config_object_owner(string ps_config_object, string ps_config_object_id) RPCFUNC ALIAS FOR "dbo.fn_config_object_owner"
FUNCTION long	 fn_count_attachments(string ps_cpr_id, string ps_context_object, long pl_object_key) RPCFUNC ALIAS FOR "dbo.fn_count_attachments"
FUNCTION long	 fn_count_my_issues(string ps_user_id, string ps_system_id) RPCFUNC ALIAS FOR "dbo.fn_count_my_issues"
FUNCTION long	 fn_count_progress_for_object(string ps_cpr_id, string ps_context_object, long pl_object_key, string ps_progress_type) RPCFUNC ALIAS FOR "dbo.fn_count_progress_for_object"
FUNCTION long	 fn_count_progress_in_encounter(string ps_cpr_id, long pl_encounter_id, string ps_context_object, long pl_object_key, string ps_progress_type) RPCFUNC ALIAS FOR "dbo.fn_count_progress_in_encounter"
FUNCTION long	 fn_document_interfaceserviceid(long pl_document_patient_workplan_item_id) RPCFUNC ALIAS FOR "dbo.fn_document_interfaceserviceid"
FUNCTION string fn_document_mapping_status(long pl_document_patient_workplan_item_id) RPCFUNC ALIAS FOR "dbo.fn_document_mapping_status"
FUNCTION long	 fn_get_current_treatment(string ps_cpr_id, long pl_treatment_id) RPCFUNC ALIAS FOR "dbo.fn_get_current_treatment"
FUNCTION long	 fn_last_treatment_for_patient(string ps_cpr_id, long pl_treatment_id) RPCFUNC ALIAS FOR "dbo.fn_last_treatment_for_patient"
FUNCTION long	 fn_latest_system_version(string ps_system_id, long pl_major_release, string ps_database_version, long pl_db_modification_level) RPCFUNC ALIAS FOR "dbo.fn_latest_system_version"
FUNCTION long	 fn_lookup_assessment(string ps_cpr_id,string ps_id_domain, string ps_id) RPCFUNC ALIAS FOR "dbo.fn_lookup_assessment"
FUNCTION long	 fn_lookup_encounter(string ps_cpr_id,string ps_id_domain, string ps_id) RPCFUNC ALIAS FOR "dbo.fn_lookup_encounter"
FUNCTION long	 fn_lookup_treatment(string ps_cpr_id,string ps_id_domain, string ps_id) RPCFUNC ALIAS FOR "dbo.fn_lookup_treatment"
FUNCTION string fn_office_user_id(string ps_office_id) RPCFUNC ALIAS FOR "dbo.fn_office_user_id"
FUNCTION string fn_owner_description(long pl_owner_id) RPCFUNC ALIAS FOR "dbo.fn_owner_description"
FUNCTION long	 fn_reference_material_id(string ps_cpr_id, string ps_context_object, long pl_object_key, string ps_which_material) RPCFUNC ALIAS FOR "dbo.fn_reference_material_id"
FUNCTION string fn_treatment_last_observed_by(string ps_cpr_id, long pl_treatment_id) RPCFUNC ALIAS FOR "dbo.fn_treatment_last_observed_by"


FUNCTION string fn_lookup_code(string ps_epro_domain, string ps_epro_id, string ps_code_domain, long pl_owner_id) RPCFUNC ALIAS FOR "dbo.fn_lookup_code"
FUNCTION string fn_patient_object_progress_value(string ps_cpr_id, string ps_context_object, string ps_progress_type, long pl_object_key, string ps_progress_key) RPCFUNC ALIAS FOR "dbo.fn_patient_object_progress_value"

// String functions actually implemented as methods because the OLEDB driver isn't properly calling the function with a string return value
//FUNCTION string fn_attribute_description(string ps_attribute, string ps_value) RPCFUNC ALIAS FOR "dbo.fn_attribute_description"
//FUNCTION string fn_check_encounter_owner_billable(string ps_cpr_id, long pl_encounter_id) RPCFUNC ALIAS FOR "dbo.fn_check_encounter_owner_billable"
//FUNCTION string fn_context_object_type(string ps_context_object, string ps_cpr_id, long pl_object_key) RPCFUNC ALIAS FOR "dbo.fn_context_object_type"
//FUNCTION string fn_get_preference(string ps_preference_type, string ps_preference_id, string ps_user_id, long pl_computer_id) RPCFUNC ALIAS FOR "dbo.fn_get_preference"
//FUNCTION string fn_get_specific_preference(string ps_preference_type, string ps_preference_level, string ps_preference_key, string ps_preference_id) RPCFUNC ALIAS FOR "dbo.fn_get_specific_preference"
//FUNCTION string fn_lookup_epro_id(long pl_owner_id, string ps_code_domain, string ps_code_value, string ps_jmj_domain) RPCFUNC ALIAS FOR "dbo.fn_lookup_epro_id"
//FUNCTION string fn_lookup_patient(string ps_id_domain, string ps_id) RPCFUNC ALIAS FOR "dbo.fn_lookup_patient"
//FUNCTION string fn_lookup_patient_billingid(string ps_id_domain, string ps_id) RPCFUNC ALIAS FOR "dbo.fn_lookup_patient_billingid"
//FUNCTION string fn_lookup_user(string ps_office_id, string ps_id) RPCFUNC ALIAS FOR "dbo.fn_lookup_user"
//FUNCTION string fn_lookup_user_billingid(string ps_office_id, string ps_id) RPCFUNC ALIAS FOR "dbo.fn_lookup_user_billingid"
//FUNCTION string fn_object_description(string ps_object, string ps_key) RPCFUNC ALIAS FOR "dbo.fn_object_description"
//FUNCTION string fn_object_equivalence_group(string ps_object_id) RPCFUNC ALIAS FOR "dbo.fn_object_equivalence_group"
//FUNCTION string fn_object_id_from_key(string ps_object_type, string ps_object_key) RPCFUNC ALIAS FOR "dbo.fn_object_id_from_key"
//FUNCTION string fn_patient_full_name(string ps_cpr_id) RPCFUNC ALIAS FOR "dbo.fn_patient_full_name"
//FUNCTION string fn_patient_object_last_result(string ps_cpr_id, string ps_context_object, long pl_object_key, string ps_observation_id, integer pi_result_sequence) RPCFUNC ALIAS FOR "dbo.fn_patient_object_last_result"
//FUNCTION string fn_patient_object_property(string ps_cpr_id, string ps_context_object, long pl_object_key, string ps_progress_key) RPCFUNC ALIAS FOR "dbo.fn_patient_object_property"
//FUNCTION string fn_patient_object_description(string ps_cpr_id, string ps_context_object, long pl_object_key) RPCFUNC ALIAS FOR "dbo.fn_patient_object_description"
//FUNCTION string fn_string_to_identifier(string ps_string) RPCFUNC ALIAS FOR "dbo.fn_string_to_identifier"


// EncounterPRO database procedure declarations (This must be the last section)
FUNCTION long jmj_add_patient_relation(string ps_cpr_id, string ps_relation_cpr_id, string ps_relationship, string ps_created_by) RPCFUNC ALIAS FOR "dbo.jmj_add_patient_relation"

FUNCTION long jmj_change_references(string ps_module_type, string ps_object_id, string ps_new_object_id, string ps_user_id) RPCFUNC ALIAS FOR "dbo.jmj_change_references"
FUNCTION long jmj_check_allergen(string ps_cpr_id, string ps_drug_id) RPCFUNC ALIAS FOR "dbo.jmj_check_allergen"
FUNCTION long jmj_copy_config_object(string ps_copy_from_config_object_id,string ps_new_description,string ps_created_by,ref string ps_new_config_object_id) RPCFUNC ALIAS FOR "dbo.jmj_copy_config_object"
FUNCTION long jmj_copy_object_params(string pui_from_id, long pl_from_param_sequence, string pui_to_id, string ps_param_mode, string ps_created_by) RPCFUNC ALIAS FOR "dbo.jmj_copy_object_params"
FUNCTION long jmj_delete_equivalence_item(long pl_equivalence_group_id, string ps_object_id, string ps_object_key, string ps_created_by) RPCFUNC ALIAS FOR "dbo.jmj_delete_equivalence_item"
FUNCTION long jmj_encounter_charge_move(string ps_cpr_id, long pl_encounter_id, long pl_encounter_charge_id, long pl_problem_id, string ps_direction) RPCFUNC ALIAS FOR "dbo.jmj_encounter_charge_move"

FUNCTION long jmj_forward_task(long pl_patient_workplan_item_id, string ps_to_user_id, string ps_new_description, string ps_new_message, string ps_created_by, string ps_user_id) RPCFUNC ALIAS FOR "dbo.jmj_forward_task"

FUNCTION long	 jmj_hm_new_rule(long pl_filter_from_maintenance_rule_id, long pl_copy_from_maintenance_rule_id, string ps_description, string ps_maintenance_rule_type, string status, string ps_created_by) RPCFUNC ALIAS FOR "dbo.jmj_hm_new_rule"
FUNCTION long jmj_HM_Reset_Patient_List(long pl_maintenance_rule_id) RPCFUNC ALIAS FOR "dbo.jmj_HM_Reset_Patient_List"
FUNCTION long jmj_hm_set_class_metric(long pl_maintenance_rule_id, string ps_observation_id, integer pi_result_sequence, string ps_title, string ps_description, long pl_interval, string ps_interval_unit, string ps_created_by) RPCFUNC ALIAS FOR "dbo.jmj_hm_set_class_metric"

FUNCTION long jmj_log_performance(long pl_computer_id, long pl_patient_workplan_item_id, string ps_user_id, string ps_metric, decimal pd_value) RPCFUNC ALIAS FOR "dbo.jmj_log_performance"

FUNCTION long jmj_new_disease(string ps_description) RPCFUNC ALIAS FOR "dbo.jmj_new_disease"
FUNCTION long jmj_new_equivalence_item(long pl_equivalence_group_id, string ps_object_id, string ps_object_key, string ps_created_by) RPCFUNC ALIAS FOR "dbo.jmj_new_equivalence_item"
FUNCTION long jmj_new_material(string ps_title, long pl_category, string ps_status, string ps_extension, string ps_id, string ps_url, string ps_created_by, string ps_filename, long pl_from_material_id, string pui_parent_config_object_id) RPCFUNC ALIAS FOR "dbo.jmj_new_material"

FUNCTION long jmj_new_menu_selection(long pl_menu_id, string ps_office_id, string ps_menu_context, string ps_menu_key, string ps_user_id) RPCFUNC ALIAS FOR "dbo.jmj_new_menu_selection"

FUNCTION long jmj_order_document2(string ps_cpr_id, long pl_encounter_id, string ps_context_object, long pl_object_key, string ps_report_id, string ps_purpose, string ps_dispatch_method, string ps_ordered_for, long pl_patient_workplan_id, string ps_description, string ps_ordered_by, string ps_created_by, long pl_material_id, string ps_create_from, string ps_send_from) RPCFUNC ALIAS FOR "dbo.jmj_order_document2"

FUNCTION long jmj_order_document_from_material(string ps_cpr_id, long pl_encounter_id, string ps_context_object, long pl_object_key, string ps_report_id, string ps_purpose, string ps_dispatch_method, string ps_ordered_for, long pl_patient_workplan_id, string ps_description, string ps_ordered_by, string ps_created_by, long pl_material_id) RPCFUNC ALIAS FOR "dbo.jmj_order_document2"

FUNCTION long jmj_order_message_recipient(long pl_dispatched_patient_workplan_item_id, string ps_ordered_for, string ps_created_by, ref long pl_patient_workplan_item_id, string ps_dispatch_method) RPCFUNC ALIAS FOR "dbo.jmj_order_message_recipient"
FUNCTION long jmj_owner_lookup(string ps_owner, string ps_description, string ps_owner_type, string ps_created_by) RPCFUNC ALIAS FOR "dbo.jmj_owner_lookup"
FUNCTION long jmj_patient_search2(string ps_user_id, string ps_billing_id, string ps_last_name, string ps_first_name, string ps_ssn, datetime pdt_date_of_birth, string ps_phone_number, string ps_employer, string ps_employeeid, string ps_patient_status, string ps_id_document, string ps_country, string ps_document_number, long pl_count_only) RPCFUNC ALIAS FOR "dbo.jmj_patient_search2"
FUNCTION long sp_Set_Attachment_Progress(string ps_cpr_id, long pl_attachment_id, long pl_patient_workplan_item_id, string ps_user_id, datetime pdt_progress_date_time, string ps_progress_type, string ps_progress, string ps_created_by) RPCFUNC ALIAS FOR "dbo.sp_Set_Attachment_Progress"
FUNCTION long jmj_reset_active_services() RPCFUNC ALIAS FOR "dbo.jmj_reset_active_services"
FUNCTION long jmj_set_constraints() RPCFUNC ALIAS FOR "dbo.jmj_set_constraints"
FUNCTION long jmj_set_document_error(long pl_patient_workplan_item_id,string ps_operation, string ps_user_id, long pl_computer_id) RPCFUNC ALIAS FOR "dbo.jmj_set_document_error"
FUNCTION long jmj_set_menu_selection(string ps_menu_context, string ps_menu_key, string ps_office_id, string ps_user_id, long pl_menu_id) RPCFUNC ALIAS FOR "dbo.jmj_set_menu_selection"
FUNCTION long jmj_set_property_exception_value(long pl_spid, string ps_datatype, string ps_select) RPCFUNC ALIAS FOR "dbo.jmj_set_property_exception_value"
FUNCTION long jmj_set_server_printers(long pl_computer_id) RPCFUNC ALIAS FOR "dbo.jmj_set_server_printers"
FUNCTION long jmj_set_service_error(long pl_patient_workplan_item_id, string ps_user_id, string ps_created_by, string ps_manual_service_flag, long pl_computer_id) RPCFUNC ALIAS FOR "dbo.jmj_set_service_error"
FUNCTION long jmj_set_username(string ps_user_id, string ps_new_username) RPCFUNC ALIAS FOR "dbo.jmj_set_username"
FUNCTION long jmj_startup_check() RPCFUNC ALIAS FOR "dbo.jmj_startup_check"
FUNCTION long jmj_treatment_list_set_attribute(long pl_definition_id, string ps_attribute, string ps_value) RPCFUNC ALIAS FOR "dbo.jmj_treatment_list_set_attribute"
FUNCTION long jmj_upload_module(string ps_module_type ,	string ps_object_id ,	string ps_module_data ,	string ps_user_id ) RPCFUNC ALIAS FOR "dbo.jmj_upload_module"
FUNCTION long sp_active_services(string ps_in_office_flag) RPCFUNC ALIAS FOR "dbo.sp_active_services"
FUNCTION long sp_active_services_30(string ps_in_office_flag) RPCFUNC ALIAS FOR "dbo.sp_active_services_30"
FUNCTION long sp_add_charge(string ps_cpr_id, long pl_encounter_id, string ps_procedure_id, long problem_id, long pl_treatment_id, string ps_created_by) RPCFUNC ALIAS FOR "dbo.sp_add_charge"
FUNCTION long sp_add_default_collect_result(string ps_observation_id, ref integer pi_result_sequence) RPCFUNC ALIAS FOR "dbo.sp_add_default_collect_result"
FUNCTION long sp_add_encounter_charge(string ps_cpr_id, long pl_encounter_id, string ps_procedure_id, long pl_treatment_id, string ps_created_by, string ps_replace_flag) RPCFUNC ALIAS FOR "dbo.sp_add_encounter_charge"
FUNCTION long sp_add_patient_observation(string ps_cpr_id, string ps_observation_id, long pl_parent_observation_sequence, long pl_treatment_id, long pl_encounter_id, string ps_observed_by, string ps_created_by, ref long pl_observation_sequence) RPCFUNC ALIAS FOR "dbo.sp_add_patient_observation"
FUNCTION long sp_add_patient_observation_result(string ps_cpr_id, long pl_observation_sequence, long pl_treatment_id, long pl_encounter_id, string ps_location, integer pi_result_sequence, datetime pdt_result_date_time, string ps_result_value, string ps_result_unit, string ps_observed_by, string ps_created_by, ref long pl_location_result_sequence) RPCFUNC ALIAS FOR "dbo.sp_add_patient_observation_result"
FUNCTION long sp_add_property_results_to_treatment_type(string ps_treatment_type, string ps_result) RPCFUNC ALIAS FOR "dbo.sp_add_property_results_to_treatment_type"
FUNCTION long sp_add_treatment_charges(string ps_cpr_id, long pl_encounter_id, long pl_treatment_id, string ps_created_by) RPCFUNC ALIAS FOR "dbo.sp_add_treatment_charges"
FUNCTION long sp_add_workplan_item_attribute(string ps_cpr_id, long pl_patient_workplan_id, long pl_patient_workplan_item_id, string ps_attribute, string ps_value, string ps_created_by, string ps_user_id) RPCFUNC ALIAS FOR "dbo.sp_add_workplan_item_attribute"
FUNCTION long sp_Apply_Standard_Exam(string ps_cpr_id, long pl_treatment_id, long pl_encounter_id, long pl_observation_sequence, long pl_branch_id, long pl_exam_sequence, string ps_user_id, string ps_created_by) RPCFUNC ALIAS FOR "dbo.sp_Apply_Standard_Exam"
FUNCTION long sp_assessment_auto_close(string ps_user_id, string ps_created_by) RPCFUNC ALIAS FOR "dbo.sp_assessment_auto_close"
FUNCTION long sp_assessment_progress_status(string ps_cpr_id, long pl_encounter_id, long pl_problem_id, ref long pl_total_count, ref long pl_this_encounter_count) RPCFUNC ALIAS FOR "dbo.sp_assessment_progress_status"
FUNCTION long sp_assessment_search(string ps_assessment_type, string ps_assessment_category_id, string ps_description, string ps_icd_code, string ps_specialty_id, string ps_status) RPCFUNC ALIAS FOR "dbo.sp_assessment_search"
FUNCTION long sp_assessment_treatment_formulary(string ps_cpr_id, string ps_assessment_id) RPCFUNC ALIAS FOR "dbo.sp_assessment_treatment_formulary"
FUNCTION long sp_authority_consultant(string ps_cpr_id, string ps_specialty_id) RPCFUNC ALIAS FOR "dbo.sp_authority_consultant"
FUNCTION long sp_authority_treatment_formulary(string ps_cpr_id, long pl_treatment_id, string ps_authority_id) RPCFUNC ALIAS FOR "dbo.sp_authority_treatment_formulary"
FUNCTION long sp_auto_close_assessments() RPCFUNC ALIAS FOR "dbo.sp_auto_close_assessments"
FUNCTION long sp_blocker_pss70(long fast) RPCFUNC ALIAS FOR "dbo.sp_blocker_pss70"
FUNCTION long sp_c_display_cmd_att_insert(long pl_display_script_id, long pl_display_command_id, ref long pl_attribute_sequence, string ps_attribute, string ps_value) RPCFUNC ALIAS FOR "dbo.sp_c_display_cmd_att_insert"
FUNCTION long sp_c_display_cmd_att_update(long pl_display_script_id, long pl_display_command_id, long pl_attribute_sequence, string ps_attribute, string ps_value) RPCFUNC ALIAS FOR "dbo.sp_c_display_cmd_att_update"
FUNCTION long sp_cancel_encounter_objects(string ps_cpr_id, long pl_encounter_id, string ps_ordered_by, string ps_created_by) RPCFUNC ALIAS FOR "dbo.sp_cancel_encounter_objects"
FUNCTION long sp_cancel_in_office_services(string ps_cpr_id, long pl_encounter_id, string ps_ordered_by, string ps_created_by) RPCFUNC ALIAS FOR "dbo.sp_cancel_in_office_services"
FUNCTION long sp_cancel_treatment(string ps_cpr_id, long pl_treatment_id, long pl_encounter_id, string ps_user_id, string ps_created_by) RPCFUNC ALIAS FOR "dbo.sp_cancel_treatment"
FUNCTION long sp_change_access_id(string ps_user_id, string ps_access_id, ref integer pi_success) RPCFUNC ALIAS FOR "dbo.sp_change_access_id"
FUNCTION long sp_change_encounter_owner(string ps_cpr_id, long pl_encounter_id, string ps_attending_doctor) RPCFUNC ALIAS FOR "dbo.sp_change_encounter_owner"
FUNCTION long sp_change_room(string ps_cpr_id, long pl_encounter_id, string ps_room_id) RPCFUNC ALIAS FOR "dbo.sp_change_room"
FUNCTION long sp_check_new_rx(string ps_cpr_id, long pl_encounter_id, ref integer pi_new_rx_count) RPCFUNC ALIAS FOR "dbo.sp_check_new_rx"
FUNCTION long sp_check_new_user_rx(string ps_cpr_id, long pl_encounter_id, string ps_user_id, ref integer pi_new_user_rx_count) RPCFUNC ALIAS FOR "dbo.sp_check_new_user_rx"
FUNCTION long sp_check_workplan_status(long pl_patient_workplan_id, string ps_user_id, string ps_created_by) RPCFUNC ALIAS FOR "dbo.sp_check_workplan_status"
FUNCTION long sp_clear_exam_defaults(string ps_user_id, long pl_exam_sequence, long pl_branch_id) RPCFUNC ALIAS FOR "dbo.sp_clear_exam_defaults"
FUNCTION long sp_close_auto_close(string ps_cpr_id, long pl_encounter_id, string ps_user_id, string ps_created_by) RPCFUNC ALIAS FOR "dbo.sp_close_auto_close"
FUNCTION long sp_close_box(long pl_box_id) RPCFUNC ALIAS FOR "dbo.sp_close_box"
FUNCTION long sp_close_encounter(string ps_cpr_id, long pl_encounter_id, string ps_user_id, string ps_created_by) RPCFUNC ALIAS FOR "dbo.sp_close_encounter"
FUNCTION long sp_close_past_encounters(string ps_flag, long pi_days, string ps_user_id, string ps_created_by) RPCFUNC ALIAS FOR "dbo.sp_close_past_encounters"
FUNCTION long sp_close_treatment(string ps_cpr_id, long pl_treatment_id, long pl_encounter_id, string ps_user_id, string ps_created_by) RPCFUNC ALIAS FOR "dbo.sp_close_treatment"
FUNCTION long sp_compatible_admin_units(string ps_drug_id) RPCFUNC ALIAS FOR "dbo.sp_compatible_admin_units"
FUNCTION long sp_compatible_services(string ps_context_object) RPCFUNC ALIAS FOR "dbo.sp_compatible_services"
FUNCTION long sp_complete_workplan_item(long pl_patient_workplan_item_id, string ps_completed_by, string ps_progress_type, datetime pdt_progress_date_time, string ps_created_by) RPCFUNC ALIAS FOR "dbo.sp_complete_workplan_item"
FUNCTION long sp_copy_treatment_to_personal(string ps_user_id, long pl_definition_id, long pl_parent_definition_id, ref long pl_new_definition_id) RPCFUNC ALIAS FOR "dbo.sp_copy_treatment_to_personal"
FUNCTION long sp_count_messages(string ps_user_id, ref integer pi_message_count, ref integer pi_todo_count) RPCFUNC ALIAS FOR "dbo.sp_count_messages"
FUNCTION long sp_count_office_status(long pl_group_id, ref long pl_patient_count) RPCFUNC ALIAS FOR "dbo.sp_count_office_status"
FUNCTION long sp_count_patient_messages(string ps_cpr_id, ref integer pi_message_count, ref integer pi_todo_count) RPCFUNC ALIAS FOR "dbo.sp_count_patient_messages"
FUNCTION long sp_count_ready_todo_items(string ps_user_id, string ps_in_office_flag) RPCFUNC ALIAS FOR "dbo.sp_count_ready_todo_items"
FUNCTION long sp_count_room_status(string ps_room_id, ref long pl_patient_count) RPCFUNC ALIAS FOR "dbo.sp_count_room_status"
FUNCTION long sp_count_waiting_room_status(string ps_office_id, ref integer pi_waiting_count) RPCFUNC ALIAS FOR "dbo.sp_count_waiting_room_status"
FUNCTION long sp_count_who_came_office(string ps_office_id, datetime pdt_date, ref integer pi_count) RPCFUNC ALIAS FOR "dbo.sp_count_who_came_office"
FUNCTION long sp_count_who_came_today(datetime pdt_date, ref integer pi_count) RPCFUNC ALIAS FOR "dbo.sp_count_who_came_today"
FUNCTION long sp_create_allergy_injection(string ps_cpr_id, long pl_encounter_id, long pl_parent_treatment_id, string ps_ordered_by, string ps_created_by, string ps_description, ref long pl_treatment_id) RPCFUNC ALIAS FOR "dbo.sp_create_allergy_injection"
FUNCTION long sp_create_exam(string ps_user_id, string ps_description, ref integer pi_exam_sequence) RPCFUNC ALIAS FOR "dbo.sp_create_exam"
FUNCTION long sp_create_text_document(string ps_title, long pl_category, string ps_document, ref long pl_material_id) RPCFUNC ALIAS FOR "dbo.sp_create_text_document"
FUNCTION long sp_create_vial_instance(string ps_cpr_id, long pl_encounter_id, long pl_parent_treatment_id, string ps_vial_type, string ps_ordered_by, string ps_created_by, string ps_dilute_from_vial_type, real pr_vial_amount, string ps_vial_unit) RPCFUNC ALIAS FOR "dbo.sp_create_vial_instance"
FUNCTION long sp_Default_Default_Results(long pl_branch_id, string ps_observation_id, integer pi_result_sequence, string ps_location) RPCFUNC ALIAS FOR "dbo.sp_Default_Default_Results"
FUNCTION long sp_default_exam_selection(string ps_root_observation_id, string ps_cpr_id, string ps_treatment_type, string ps_user_id) RPCFUNC ALIAS FOR "dbo.sp_default_exam_selection"
FUNCTION long sp_Default_Results(long pl_branch_id, long pl_exam_sequence, string ps_user_id) RPCFUNC ALIAS FOR "dbo.sp_Default_Results"
FUNCTION long sp_delete_assessment_definition(string ps_assessment_id) RPCFUNC ALIAS FOR "dbo.sp_delete_assessment_definition"
FUNCTION long sp_delete_assmnt_definition(string ps_assessment_id) RPCFUNC ALIAS FOR "dbo.sp_delete_assmnt_definition"
FUNCTION long sp_delete_drug_administration(string ps_drug_id, integer pi_administration_sequence) RPCFUNC ALIAS FOR "dbo.sp_delete_drug_administration"
FUNCTION long sp_delete_drug_definition(string ps_drug_id) RPCFUNC ALIAS FOR "dbo.sp_delete_drug_definition"
FUNCTION long sp_delete_drug_drug_category(string ps_drug_id, string ps_drug_category_id) RPCFUNC ALIAS FOR "dbo.sp_delete_drug_drug_category"
FUNCTION long sp_delete_drug_hcpcs(string ps_drug_id, long pl_hcpcs_sequence) RPCFUNC ALIAS FOR "dbo.sp_delete_drug_hcpcs"
FUNCTION long sp_delete_drug_package(string ps_drug_id, string ps_package_id) RPCFUNC ALIAS FOR "dbo.sp_delete_drug_package"
FUNCTION long sp_delete_encounter(string ps_cpr_id, long pl_encounter_id) RPCFUNC ALIAS FOR "dbo.sp_delete_encounter"
FUNCTION long sp_delete_exam(string ps_user_id, integer pi_exam_sequence) RPCFUNC ALIAS FOR "dbo.sp_delete_exam"
FUNCTION long sp_delete_letter(string ps_cpr_id, long pl_letter_id) RPCFUNC ALIAS FOR "dbo.sp_delete_letter"
FUNCTION long sp_delete_location(string ps_location) RPCFUNC ALIAS FOR "dbo.sp_delete_location"
FUNCTION long sp_delete_obs_definition(string ps_observation_id) RPCFUNC ALIAS FOR "dbo.sp_delete_obs_definition"
FUNCTION long sp_delete_observation_definition(string ps_observation_id) RPCFUNC ALIAS FOR "dbo.sp_delete_observation_definition"
FUNCTION long sp_delete_patient_material(long pl_material_id) RPCFUNC ALIAS FOR "dbo.sp_delete_patient_material"
FUNCTION long sp_delete_procedure_definition(string ps_procedure_id) RPCFUNC ALIAS FOR "dbo.sp_delete_procedure_definition"
FUNCTION long sp_delete_test_treatment_items(string ps_cpr_id, long pl_encounter_id) RPCFUNC ALIAS FOR "dbo.sp_delete_test_treatment_items"
FUNCTION long sp_delete_workplan(long pl_workplan_id) RPCFUNC ALIAS FOR "dbo.sp_delete_workplan"
FUNCTION long sp_Dispatch_Workplan_Step(string ps_cpr_id, long pl_patient_workplan_id, integer pi_step_number, string ps_dispatched_by, long pl_encounter_id, string ps_created_by) RPCFUNC ALIAS FOR "dbo.sp_Dispatch_Workplan_Step"
FUNCTION long sp_display_script_search(string ps_context_object, string ps_display_script, string ps_status) RPCFUNC ALIAS FOR "dbo.sp_display_script_search"
FUNCTION long sp_dont_bill_treatment(string ps_cpr_id, long pl_encounter_id, long pl_encounter_charge_id) RPCFUNC ALIAS FOR "dbo.sp_dont_bill_treatment"
FUNCTION long sp_drop_constraints(string ps_table, integer pi_keep_triggers) RPCFUNC ALIAS FOR "dbo.sp_drop_constraints"
FUNCTION long sp_drug_efficacy() RPCFUNC ALIAS FOR "dbo.sp_drug_efficacy"
FUNCTION long sp_drug_prescription_flag(string ps_drug_id, string ps_package_id, ref string ps_prescription_flag) RPCFUNC ALIAS FOR "dbo.sp_drug_prescription_flag"
FUNCTION long sp_drug_search(string ps_drug_category_id, string ps_description, string ps_generic_name, string ps_specialty_id, string ps_status) RPCFUNC ALIAS FOR "dbo.sp_drug_search"
FUNCTION long sp_duplicate_observation(string ps_observation_id, string ps_new_description, string ps_user_id, ref string ps_new_observation_id) RPCFUNC ALIAS FOR "dbo.sp_duplicate_observation"
FUNCTION long sp_Encounter_Auto_Perform_Services(string ps_cpr_id, long pl_encounter_id, string ps_in_office_flag, string ps_user_id) RPCFUNC ALIAS FOR "dbo.sp_Encounter_Auto_Perform_Services"
FUNCTION long sp_encounter_level(string ps_cpr_id, long pl_encounter_id, string ps_em_documentation_guide, ref integer pi_history_level, ref integer pi_exam_level, ref integer pi_decision_level) RPCFUNC ALIAS FOR "dbo.sp_encounter_level"
FUNCTION long sp_Find_Encounter_Service(string ps_cpr_id, long pl_encounter_id, string ps_service, ref long pl_patient_workplan_item_id) RPCFUNC ALIAS FOR "dbo.sp_Find_Encounter_Service"
FUNCTION long sp_Find_Observation(string ps_observation_id) RPCFUNC ALIAS FOR "dbo.sp_Find_Observation"
FUNCTION long sp_finished_services(string ps_cpr_id, long pl_encounter_id, ref integer pi_count) RPCFUNC ALIAS FOR "dbo.sp_finished_services"
FUNCTION long sp_folder_selection(string ps_context_object, string ps_context_object_type, string ps_attachment_type, string ps_extension) RPCFUNC ALIAS FOR "dbo.sp_folder_selection"
FUNCTION long sp_folder_workplan(string ps_folder) RPCFUNC ALIAS FOR "dbo.sp_folder_workplan"
FUNCTION long sp_forward_todo_service(long pl_patient_workplan_item_id, string ps_from_user_id, string ps_to_user_id, string ps_description, string ps_service, string ps_created_by, string ps_new_message) RPCFUNC ALIAS FOR "dbo.sp_forward_todo_service"
FUNCTION long sp_generate_billing_id(string ps_cpr_id, string ps_user_id, string ps_created_by) RPCFUNC ALIAS FOR "dbo.sp_generate_billing_id"
FUNCTION long sp_get_age_date(datetime pdt_from_date, long pl_add_number, string ps_add_unit, ref datetime pdt_date) RPCFUNC ALIAS FOR "dbo.sp_get_age_date"
FUNCTION long sp_get_all_encounter_procs() RPCFUNC ALIAS FOR "dbo.sp_get_all_encounter_procs"
FUNCTION long sp_get_appointment_type(string ps_appointment_type, ref string ps_encounter_type, ref string ps_new_flag) RPCFUNC ALIAS FOR "dbo.sp_get_appointment_type"
FUNCTION long sp_get_appointment_type_list() RPCFUNC ALIAS FOR "dbo.sp_get_appointment_type_list"
FUNCTION long sp_get_assessment_icd10(string ps_cpr_id, string ps_assessment_id) RPCFUNC ALIAS FOR "dbo.sp_get_assessment_icd10"
FUNCTION long sp_get_assessment_status(string ps_cpr_id, long pl_problem_id, long pl_encounter_id, ref string ps_status) RPCFUNC ALIAS FOR "dbo.sp_get_assessment_status"
FUNCTION long sp_get_assessment_top_20(string ps_user_id, string ps_assessment_type, string ps_top_20_code) RPCFUNC ALIAS FOR "dbo.sp_get_assessment_top_20"
FUNCTION long sp_get_assessments(string ps_cpr_id) RPCFUNC ALIAS FOR "dbo.sp_get_assessments"
FUNCTION long sp_get_assessments_to_post(string ps_cpr_id, long pl_encounter_id) RPCFUNC ALIAS FOR "dbo.sp_get_assessments_to_post"
FUNCTION long sp_get_assessments_treatments(string ps_cpr_id) RPCFUNC ALIAS FOR "dbo.sp_get_assessments_treatments"
FUNCTION long sp_get_attachments(string ps_cpr_id, string ps_context_object, long pl_object_key) RPCFUNC ALIAS FOR "dbo.sp_get_attachments"
FUNCTION long sp_get_available_preferences(string ps_level, string ps_preference_type) RPCFUNC ALIAS FOR "dbo.sp_get_available_preferences"
FUNCTION long sp_get_billable_provider(string ps_attending_doctor, string ps_supervising_doctor, string ps_primary_provider_id, ref string ps_billable_provider) RPCFUNC ALIAS FOR "dbo.sp_get_billable_provider"
FUNCTION long sp_get_chart_selection(string ps_user_id, long pl_workplan_id, ref long pl_chart_id) RPCFUNC ALIAS FOR "dbo.sp_get_chart_selection"
FUNCTION long sp_get_chief_complaints(string ps_user_id) RPCFUNC ALIAS FOR "dbo.sp_get_chief_complaints"
FUNCTION long sp_Get_Child_Auto_Perform_Service(long pl_patient_workplan_item_id, string ps_user_id, ref long pl_next_patient_workplan_item_id) RPCFUNC ALIAS FOR "dbo.sp_Get_Child_Auto_Perform_Service"
FUNCTION long sp_get_child_observations(string ps_observation_id) RPCFUNC ALIAS FOR "dbo.sp_get_child_observations"
FUNCTION long sp_get_child_treatments(long pl_treatment_id) RPCFUNC ALIAS FOR "dbo.sp_get_child_treatments"
FUNCTION long sp_get_coding_component(string ps_cpr_id) RPCFUNC ALIAS FOR "dbo.sp_get_coding_component"
FUNCTION long sp_get_coding_componentx(string ps_cpr_id) RPCFUNC ALIAS FOR "dbo.sp_get_coding_componentx"
FUNCTION long sp_get_component_attributes(string ps_component_id, string ps_office_id, long pl_computer_id) RPCFUNC ALIAS FOR "dbo.sp_get_component_attributes"
FUNCTION long sp_Get_Component_Class(string ps_component_id) RPCFUNC ALIAS FOR "dbo.sp_Get_Component_Class"
FUNCTION long sp_get_convertable_units(string ps_unit_id) RPCFUNC ALIAS FOR "dbo.sp_get_convertable_units"
FUNCTION long sp_get_default_encounter_proc(string ps_encounter_type, string ps_new_flag, long pl_visit_level) RPCFUNC ALIAS FOR "dbo.sp_get_default_encounter_proc"
FUNCTION long sp_get_diseases() RPCFUNC ALIAS FOR "dbo.sp_get_diseases"
FUNCTION long sp_get_domain_items(string ps_domain_id) RPCFUNC ALIAS FOR "dbo.sp_get_domain_items"
FUNCTION long sp_get_dosage_forms(string ps_drug_id, string ps_administer_unit) RPCFUNC ALIAS FOR "dbo.sp_get_dosage_forms"
FUNCTION long sp_get_drug_admins(string ps_drug_id) RPCFUNC ALIAS FOR "dbo.sp_get_drug_admins"
FUNCTION long sp_get_drug_attributes(string ps_drug_id) RPCFUNC ALIAS FOR "dbo.sp_get_drug_attributes"
FUNCTION long sp_get_drug_categories(string ps_drug_id) RPCFUNC ALIAS FOR "dbo.sp_get_drug_categories"
FUNCTION long sp_get_drug_category_list(string ps_drug_id) RPCFUNC ALIAS FOR "dbo.sp_get_drug_category_list"
FUNCTION long sp_get_drug_packages(string ps_drug_id) RPCFUNC ALIAS FOR "dbo.sp_get_drug_packages"
FUNCTION long sp_get_encounter_assessments(string ps_cpr_id, long pl_encounter_id) RPCFUNC ALIAS FOR "dbo.sp_get_encounter_assessments"
FUNCTION long sp_get_encounter_list(string ps_cpr_id, string ps_encounter_type, string ps_indirect_flag, string ps_encounter_status) RPCFUNC ALIAS FOR "dbo.sp_get_encounter_list"
FUNCTION long sp_get_encounter_observations(string ps_cpr_id, long pl_encounter_id, string ps_observation_id) RPCFUNC ALIAS FOR "dbo.sp_get_encounter_observations"
FUNCTION long sp_get_encounter_procedures(string ps_encounter_type, string ps_new_flag) RPCFUNC ALIAS FOR "dbo.sp_get_encounter_procedures"
FUNCTION long sp_Get_Encounter_Property(string ps_cpr_id, long pl_encounter_id, string ps_progress_type, string ps_progress_key) RPCFUNC ALIAS FOR "dbo.sp_Get_Encounter_Property"
FUNCTION long sp_get_encounter_services(string ps_encounter_type, string ps_in_office_flag) RPCFUNC ALIAS FOR "dbo.sp_get_encounter_services"
FUNCTION long sp_get_encounterpro_message(string ps_user_id, long pl_patient_workplan_item_id, string ps_ordered_service) RPCFUNC ALIAS FOR "dbo.sp_get_encounterpro_message"
FUNCTION long sp_get_encounters(string ps_cpr_id) RPCFUNC ALIAS FOR "dbo.sp_get_encounters"
FUNCTION long sp_get_encounters_to_post() RPCFUNC ALIAS FOR "dbo.sp_get_encounters_to_post"
FUNCTION long sp_get_equivalence_group(string ps_object_id, string ps_object_type, string ps_description, string ps_created_by) RPCFUNC ALIAS FOR "dbo.sp_get_equivalence_group"
FUNCTION long sp_get_family_history(string ps_cpr_id) RPCFUNC ALIAS FOR "dbo.sp_get_family_history"
FUNCTION long sp_get_folder_list(string ps_context_object, string ps_cpr_id, string ps_status) RPCFUNC ALIAS FOR "dbo.sp_get_folder_list"
FUNCTION long sp_get_folder_message_list(string ps_user_id, string ps_folder) RPCFUNC ALIAS FOR "dbo.sp_get_folder_message_list"
FUNCTION long sp_get_followup_workplan(string ps_workplan_type, ref long pl_followup_workplan_id) RPCFUNC ALIAS FOR "dbo.sp_get_followup_workplan"
FUNCTION long sp_get_group_rooms(long pl_group_id) RPCFUNC ALIAS FOR "dbo.sp_get_group_rooms"
FUNCTION long sp_get_groups(string ps_office_id) RPCFUNC ALIAS FOR "dbo.sp_get_groups"
FUNCTION long sp_get_growth_data(string ps_cpr_id, string ps_obs_id, datetime pdt_birth_date, long pd_age_start, long pd_age_end, string ps_visit) RPCFUNC ALIAS FOR "dbo.sp_get_growth_data"
FUNCTION long sp_get_growth_data_htwt(string ps_cpr_id, datetime pdt_birth_date, long pd_age_start, long pd_age_end, string ps_visit) RPCFUNC ALIAS FOR "dbo.sp_get_growth_data_htwt"
FUNCTION long sp_get_growth_data_htwthc(string ps_cpr_id, datetime pdt_birth_date, long pd_age_start, long pd_age_end, string ps_visit) RPCFUNC ALIAS FOR "dbo.sp_get_growth_data_htwthc"
FUNCTION long sp_get_hcpcs(string ps_drug_id) RPCFUNC ALIAS FOR "dbo.sp_get_hcpcs"
FUNCTION long sp_get_holding_attachments() RPCFUNC ALIAS FOR "dbo.sp_get_holding_attachments"
FUNCTION long sp_get_inbox_message_list(string ps_user_id) RPCFUNC ALIAS FOR "dbo.sp_get_inbox_message_list"
FUNCTION long sp_get_labsendout(string ps_cpr_id, long pi_encounter_id) RPCFUNC ALIAS FOR "dbo.sp_get_labsendout"
FUNCTION long sp_get_last_result(string ps_cpr_id, string ps_observation_id) RPCFUNC ALIAS FOR "dbo.sp_get_last_result"
FUNCTION long sp_get_letter_count(string ps_cpr_id) RPCFUNC ALIAS FOR "dbo.sp_get_letter_count"
FUNCTION long sp_get_medication_procs(string ps_drug_id, string ps_dosage_form) RPCFUNC ALIAS FOR "dbo.sp_get_medication_procs"
FUNCTION long sp_get_menu_items(long pl_menu_id) RPCFUNC ALIAS FOR "dbo.sp_get_menu_items"
FUNCTION long sp_Get_Next_Auto_Perform_Service(long pl_patient_workplan_item_id, string ps_user_id, ref long pl_next_patient_workplan_item_id) RPCFUNC ALIAS FOR "dbo.sp_Get_Next_Auto_Perform_Service"
FUNCTION long sp_get_next_box_item(long pl_box_id, ref long pl_next_box_item) RPCFUNC ALIAS FOR "dbo.sp_get_next_box_item"
FUNCTION long sp_get_next_component_counter(string ps_component_id, string ps_attribute, ref long pl_next_counter) RPCFUNC ALIAS FOR "dbo.sp_get_next_component_counter"
FUNCTION long sp_Get_Next_Encounter_Service_2(string ps_cpr_id, long pl_encounter_id, string ps_user_id, string ps_auto_perform_flag, string ps_in_office_flag, ref long pl_patient_workplan_item_id) RPCFUNC ALIAS FOR "dbo.sp_Get_Next_Encounter_Service_2"
FUNCTION long sp_get_next_key(string ps_cpr_id, string ps_key_id, ref long pl_key_value) RPCFUNC ALIAS FOR "dbo.sp_get_next_key"
FUNCTION long sp_get_next_key2(string ps_cpr_id, string ps_key_id) RPCFUNC ALIAS FOR "dbo.sp_get_next_key"
FUNCTION long sp_Get_Next_Workplan_Autoperform_Service(string ps_cpr_id, long pl_patient_workplan_id, string ps_user_id, ref long pl_patient_workplan_item_id) RPCFUNC ALIAS FOR "dbo.sp_Get_Next_Workplan_Autoperform_Service"
FUNCTION long sp_Get_Next_Workplan_Service(string ps_cpr_id, long pl_patient_workplan_id, string ps_user_id, ref long pl_patient_workplan_item_id) RPCFUNC ALIAS FOR "dbo.sp_Get_Next_Workplan_Service"
FUNCTION long sp_get_obj_list_results(string ps_cpr_id, string ps_obj_list_id, datetime pdt_from_date) RPCFUNC ALIAS FOR "dbo.sp_get_obj_list_results"
FUNCTION long sp_get_obj_list_selection(string ps_user_id, string ps_root_category, ref string ps_observation_id) RPCFUNC ALIAS FOR "dbo.sp_get_obj_list_selection"
FUNCTION long sp_get_object_progress_types() RPCFUNC ALIAS FOR "dbo.sp_get_object_progress_types"
FUNCTION long sp_get_objective_treatments(string ps_cpr_id, long pl_encounter_id, string ps_treatment_type) RPCFUNC ALIAS FOR "dbo.sp_get_objective_treatments"
FUNCTION long sp_get_objects(string ps_cpr_id, datetime pdt_begin_date, datetime pdt_end_date) RPCFUNC ALIAS FOR "dbo.sp_get_objects"
FUNCTION long sp_get_objects_during_encounter(string ps_cpr_id, long pl_encounter_id) RPCFUNC ALIAS FOR "dbo.sp_get_objects_during_encounter"
FUNCTION long sp_get_objects_since_last_encounter(string ps_cpr_id, long pl_encounter_id) RPCFUNC ALIAS FOR "dbo.sp_get_objects_since_last_encounter"
FUNCTION long sp_get_observation_sources(long pl_computer_id, string ps_observation_id) RPCFUNC ALIAS FOR "dbo.sp_get_observation_sources"
FUNCTION long sp_get_office_status(long pl_group_id) RPCFUNC ALIAS FOR "dbo.sp_get_office_status"
FUNCTION long sp_get_open_assessments_treatments(string ps_cpr_id) RPCFUNC ALIAS FOR "dbo.sp_get_open_assessments_treatments"
FUNCTION long sp_get_other_offices(string ps_office_id) RPCFUNC ALIAS FOR "dbo.sp_get_other_offices"
FUNCTION long sp_get_outstanding_tests(string ps_observation_type) RPCFUNC ALIAS FOR "dbo.sp_get_outstanding_tests"
FUNCTION long sp_get_package_id(string ps_description, string ps_administer_method, string ps_administer_unit, string ps_dose_unit, real pr_administer_per_dose, real pr_dose_amount, string ps_dosage_form, long pl_owner_id, ref string ps_package_id) RPCFUNC ALIAS FOR "dbo.sp_get_package_id"
FUNCTION long sp_Get_Patient_Age_Range(string ps_cpr_id, string ps_age_range_category, ref long pl_age_range_id) RPCFUNC ALIAS FOR "dbo.sp_Get_Patient_Age_Range"
FUNCTION long sp_get_patient_material(long pi_material_id) RPCFUNC ALIAS FOR "dbo.sp_get_patient_material"
FUNCTION long sp_get_patient_message_list(string ps_cpr_id) RPCFUNC ALIAS FOR "dbo.sp_get_patient_message_list"
FUNCTION long sp_get_patient_name(string ps_cpr_id, ref string ps_patient_name) RPCFUNC ALIAS FOR "dbo.sp_get_patient_name"
FUNCTION long sp_Get_Patient_Progress_Value(string ps_cpr_id, long pl_encounter_id, string ps_progress_type, ref string ps_progress_value) RPCFUNC ALIAS FOR "dbo.sp_Get_Patient_Progress_Value"
FUNCTION long sp_Get_Patient_Property(string ps_cpr_id, string ps_progress_type, string ps_progress_key) RPCFUNC ALIAS FOR "dbo.sp_Get_Patient_Property"
FUNCTION long sp_Get_Patient_Service_List(string ps_office_id, string ps_workplan_type, string ps_service) RPCFUNC ALIAS FOR "dbo.sp_Get_Patient_Service_List"
FUNCTION long sp_get_patient_services(string ps_cpr_id, string ps_user_id) RPCFUNC ALIAS FOR "dbo.sp_get_patient_services"
FUNCTION long sp_get_patient_todo_list(string ps_cpr_id, string ps_service, string pc_finished_items) RPCFUNC ALIAS FOR "dbo.sp_get_patient_todo_list"
FUNCTION long sp_get_performed_history(string ps_cpr_id) RPCFUNC ALIAS FOR "dbo.sp_get_performed_history"
FUNCTION long sp_get_planned_referrals(string ps_cpr_id) RPCFUNC ALIAS FOR "dbo.sp_get_planned_referrals"
FUNCTION long sp_get_pm_attributes(string ps_billing_system) RPCFUNC ALIAS FOR "dbo.sp_get_pm_attributes"
FUNCTION long sp_get_post_attachments(string ps_cpr_id, string ps_treatment_list_id) RPCFUNC ALIAS FOR "dbo.sp_get_post_attachments"
FUNCTION long sp_get_posting_failure_reasons(string ps_cpr_id, long pl_encounter_id) RPCFUNC ALIAS FOR "dbo.sp_get_posting_failure_reasons"
FUNCTION long sp_get_preference_list(string ps_preference_type) RPCFUNC ALIAS FOR "dbo.sp_get_preference_list"
FUNCTION long sp_get_preferred_provider(string ps_cpr_id, string ps_specialty_id, string ps_authority_id) RPCFUNC ALIAS FOR "dbo.sp_get_preferred_provider"
FUNCTION long sp_get_procedure_count(string ps_cpr_id, long pl_encounter_id, ref integer pi_procedure_count) RPCFUNC ALIAS FOR "dbo.sp_get_procedure_count"
FUNCTION long sp_get_procedure_cpt(string ps_cpr_id, string ps_procedure_id) RPCFUNC ALIAS FOR "dbo.sp_get_procedure_cpt"
FUNCTION long sp_get_procedure_service_list() RPCFUNC ALIAS FOR "dbo.sp_get_procedure_service_list"
FUNCTION long sp_get_progress(string ps_cpr_id, string ps_context_object, long pl_object_key, string ps_progress_type, string ps_progress_key, string ps_attachments_only_flag) RPCFUNC ALIAS FOR "dbo.sp_get_progress"
FUNCTION long sp_get_progress_types(string ps_cpr_id, string ps_context_object, long pl_object_key) RPCFUNC ALIAS FOR "dbo.sp_get_progress_types"
FUNCTION long sp_get_read_message_list(string ps_user_id) RPCFUNC ALIAS FOR "dbo.sp_get_read_message_list"
FUNCTION long sp_get_referral_attachment_id(string ps_cpr_id, long pl_problem_id, integer pi_treatment_sequence, ref long pl_attachment_id) RPCFUNC ALIAS FOR "dbo.sp_get_referral_attachment_id"
FUNCTION long sp_get_report_printer(string ps_report_id, string ps_office_id, long pl_computer_id, string ps_room_id) RPCFUNC ALIAS FOR "dbo.sp_get_report_printer"
FUNCTION long sp_get_resource(string ps_resource, ref string ps_encounter_type, ref string ps_new_flag, ref string ps_user_id) RPCFUNC ALIAS FOR "dbo.sp_get_resource"
FUNCTION long sp_get_room_status(string ps_room_id) RPCFUNC ALIAS FOR "dbo.sp_get_room_status"
FUNCTION long sp_get_rooms_in_type(string ps_room_type) RPCFUNC ALIAS FOR "dbo.sp_get_rooms_in_type"
FUNCTION long sp_get_secondary_proc_list() RPCFUNC ALIAS FOR "dbo.sp_get_secondary_proc_list"
FUNCTION long sp_get_send_out_tests(string ps_cpr_id) RPCFUNC ALIAS FOR "dbo.sp_get_send_out_tests"
FUNCTION long sp_get_sent_message_list(string ps_user_id) RPCFUNC ALIAS FOR "dbo.sp_get_sent_message_list"
FUNCTION long sp_get_service_attributes(string ps_service, string ps_user_id) RPCFUNC ALIAS FOR "dbo.sp_get_service_attributes"
FUNCTION long sp_Get_Sibling_Auto_Perform_Service(long pl_patient_workplan_item_id, string ps_user_id, ref long pl_next_patient_workplan_item_id) RPCFUNC ALIAS FOR "dbo.sp_Get_Sibling_Auto_Perform_Service"
FUNCTION long sp_get_todo_list(string ps_user_id, string ps_service, string pc_in_office_flag, string pc_active_service_flag) RPCFUNC ALIAS FOR "dbo.sp_get_todo_list"
FUNCTION long sp_get_todo_list_30(string ps_user_id, string ps_office_id, string pc_active_service_flag) RPCFUNC ALIAS FOR "dbo.sp_get_todo_list_30"
FUNCTION long sp_get_top_20(string ps_user_id, string ps_top_20_code, string ps_icon_bitmap) RPCFUNC ALIAS FOR "dbo.sp_get_top_20"
FUNCTION long sp_get_top_20_for_edit(string ps_user_id, string ps_top_20_code) RPCFUNC ALIAS FOR "dbo.sp_get_top_20_for_edit"
FUNCTION long sp_get_treatment_assessments(string ps_cpr_id, long pl_encounter_id, long pl_encounter_charge_id) RPCFUNC ALIAS FOR "dbo.sp_get_treatment_assessments"
FUNCTION long sp_get_treatment_attachment_id(string ps_cpr_id, long pl_treatment_id, ref long pl_attachment_id) RPCFUNC ALIAS FOR "dbo.sp_get_treatment_attachment_id"
FUNCTION long sp_get_treatment_billing(string ps_cpr_id, long pl_encounter_id, long pl_problem_id) RPCFUNC ALIAS FOR "dbo.sp_get_treatment_billing"
FUNCTION long sp_get_treatment_followup_workplan(string ps_cpr_id, long pl_treatment_id, long pl_encounter_id, string ps_ordered_by, string ps_created_by, string ps_workplan_type, ref long pl_patient_workplan_id) RPCFUNC ALIAS FOR "dbo.sp_get_treatment_followup_workplan"
FUNCTION long sp_get_treatment_followup_workplan_items(string ps_cpr_id, long pl_treatment_id, string ps_workplan_type) RPCFUNC ALIAS FOR "dbo.sp_get_treatment_followup_workplan_items"
FUNCTION long sp_get_treatment_list(string ps_cpr_id, string ps_assessment_id, string ps_user_id, long pl_parent_definition_id) RPCFUNC ALIAS FOR "dbo.sp_get_treatment_list"
FUNCTION long sp_get_treatment_observed_by(string ps_cpr_id, long pl_treatment_id, long pl_encounter_id, string ps_user_id) RPCFUNC ALIAS FOR "dbo.sp_get_treatment_observed_by"
FUNCTION long sp_get_treatment_results(string ps_cpr_id, long pl_treatment_id) RPCFUNC ALIAS FOR "dbo.sp_get_treatment_results"
FUNCTION long sp_get_treatment_results_description(string ps_cpr_id, long pl_treatment_id, ref string ps_description) RPCFUNC ALIAS FOR "dbo.sp_get_treatment_results_description"
FUNCTION long sp_get_treatment_service_attributes(string ps_treatment_type, long pl_service_sequence) RPCFUNC ALIAS FOR "dbo.sp_get_treatment_service_attributes"
FUNCTION long sp_get_treatment_status(string ps_cpr_id, long pl_treatment_id, long pl_encounter_id, ref string ps_status) RPCFUNC ALIAS FOR "dbo.sp_get_treatment_status"
FUNCTION long sp_get_treatments_to_post(string ps_cpr_id, long pl_encounter_id) RPCFUNC ALIAS FOR "dbo.sp_get_treatments_to_post"
FUNCTION long sp_get_user_inbox(string ps_user_id) RPCFUNC ALIAS FOR "dbo.sp_get_user_inbox"
FUNCTION long sp_get_user_previliges(string ps_user_id, string ps_office_id) RPCFUNC ALIAS FOR "dbo.sp_get_user_previliges"
FUNCTION long sp_get_user_workplan_items(string ps_user_id, string ps_in_office_flag, datetime pdt_not_started_since) RPCFUNC ALIAS FOR "dbo.sp_get_user_workplan_items"
FUNCTION long sp_get_waiting_room_status(string ps_office_id) RPCFUNC ALIAS FOR "dbo.sp_get_waiting_room_status"
FUNCTION long sp_get_who_came_office(string ps_office_id, string ps_user_id, datetime pdt_date, string ps_indirect_flag, string ps_encounter_type) RPCFUNC ALIAS FOR "dbo.sp_get_who_came_office"
FUNCTION long sp_get_who_came_today(datetime pdt_date) RPCFUNC ALIAS FOR "dbo.sp_get_who_came_today"
FUNCTION long sp_Get_Workplan_Auto_Perform_Service(long pl_patient_workplan_id, string ps_user_id) RPCFUNC ALIAS FOR "dbo.sp_Get_Workplan_Auto_Perform_Service"
FUNCTION long sp_get_workplan_step_details(long pi_workplan_id, long pi_step_number) RPCFUNC ALIAS FOR "dbo.sp_get_workplan_step_details"
FUNCTION long sp_growth_percentile(string ps_measurement, string ps_sex, integer pi_age_months, real pr_value, ref real pr_percentile) RPCFUNC ALIAS FOR "dbo.sp_growth_percentile"
FUNCTION long sp_has_alert(string ps_cpr_id, string ps_alert_category_id, ref integer pi_alert_count) RPCFUNC ALIAS FOR "dbo.sp_has_alert"
FUNCTION long sp_init_user_therapies(string ps_user_id, string ps_assessment_id, string ps_common_list_id, long pl_old_parent_definition_id, long pl_new_parent_definition_id) RPCFUNC ALIAS FOR "dbo.sp_init_user_therapies"
FUNCTION long sp_insert_assessment_treat_def(string ps_assessment, string ps_treatment_type, string ps_treatment_desc, string ps_user_id, long pi_sort_sequence, string ps_instructions, long pl_parent_definition_id, string pc_child_flag, long pl_followup_workplan_id, ref long pl_definition_id) RPCFUNC ALIAS FOR "dbo.sp_insert_assessment_treat_def"
FUNCTION long sp_insert_patient_material(string ps_title, long pi_category_id, ref long pi_material_id) RPCFUNC ALIAS FOR "dbo.sp_insert_patient_material"
FUNCTION long sp_is_valid_age_range(string ps_age_range_category, long pl_age_from, string ps_unit_from, long pl_age_to, string ps_unit_to, ref string ps_message) RPCFUNC ALIAS FOR "dbo.sp_is_valid_age_range"
FUNCTION long sp_local_copy_display_script(long pl_display_script_id, string ps_new_id, string ps_new_description, string ps_parent_config_object_id) RPCFUNC ALIAS FOR "dbo.sp_local_copy_display_script"
FUNCTION long sp_local_copy_menu(long pl_menu_id, string ps_new_id, string ps_new_description) RPCFUNC ALIAS FOR "dbo.sp_local_copy_menu"
FUNCTION long sp_local_copy_workplan(long pl_workplan_id, string ps_new_id, string ps_new_description) RPCFUNC ALIAS FOR "dbo.sp_local_copy_workplan"
FUNCTION long sp_lock_patient(string ps_cpr_id, string ps_user_id, ref string ps_locked_by) RPCFUNC ALIAS FOR "dbo.sp_lock_patient"
FUNCTION long sp_lock_service(long pl_patient_workplan_item_id, string ps_user_id, long pl_computer_id) RPCFUNC ALIAS FOR "dbo.sp_lock_service"
FUNCTION long sp_log_message(long pl_subscription_id, string ps_message_type, long pl_message_size, string ps_status, string ps_direction, ref long pl_message_id) RPCFUNC ALIAS FOR "dbo.sp_log_message"
FUNCTION long sp_maint_primary_assessment(long pl_maintenance_rule_id, ref string ps_assessment_id, ref string ps_assessment_description) RPCFUNC ALIAS FOR "dbo.sp_maint_primary_assessment"
FUNCTION long sp_maint_primary_procedure(long pl_maintenance_rule_id, ref string ps_procedure_id, ref string ps_procedure_description) RPCFUNC ALIAS FOR "dbo.sp_maint_primary_procedure"
FUNCTION long sp_maintenance_frequent(integer pi_encounter_started_days, integer pi_encounter_not_started_days, string ps_user_id, string ps_created_by) RPCFUNC ALIAS FOR "dbo.sp_maintenance_frequent"
FUNCTION long sp_maintenance_infrequent() RPCFUNC ALIAS FOR "dbo.sp_maintenance_infrequent"
FUNCTION long sp_maintenance_rule_display() RPCFUNC ALIAS FOR "dbo.sp_maintenance_rule_display"
FUNCTION long sp_material_search(string ps_material_category_id, string ps_description, string ps_specialty_id, string ps_status) RPCFUNC ALIAS FOR "dbo.sp_material_search"
FUNCTION long sp_menu_search(string ps_menu_category, string ps_description, string ps_context_object, string ps_specialty_id, string ps_status) RPCFUNC ALIAS FOR "dbo.sp_menu_search"
FUNCTION long sp_new_actor(string ps_actor_class, string ps_name, string ps_last_name, string ps_first_name, string ps_middle_name, string ps_name_prefix, string ps_name_suffix, string ps_degree, string ps_title, string ps_information_system_type, string ps_information_system_version, string ps_organization_contact, string ps_organization_director) RPCFUNC ALIAS FOR "dbo.sp_new_actor"
FUNCTION long sp_new_actor_address(long pl_actor_id, string ps_description, string ps_address_line_1, string ps_address_line_2, string ps_city, string ps_state, string ps_zip, string ps_country, string ps_created_by) RPCFUNC ALIAS FOR "dbo.sp_new_actor_address"
FUNCTION long sp_new_actor_communication(long pl_actor_id, string ps_communication_type, string ps_communication_value, string ps_note, string ps_created_by, string ps_communication_name) RPCFUNC ALIAS FOR "dbo.sp_new_actor_communication"
FUNCTION long sp_new_assessment(string ps_assessment_type, string ps_icd10_code, string ps_assessment_category_id, string ps_description, string ps_location_domain, string ps_auto_close, integer pi_auto_close_interval_amount, string ps_auto_close_interval_unit, long pl_risk_level, long pl_complexity, string ps_long_description, long pl_owner_id, string ps_status, ref string ps_assessment_id, string ps_allow_dup_icd10_code) RPCFUNC ALIAS FOR "dbo.sp_new_assessment"
FUNCTION long sp_new_assessment_definition(string ps_assessment_type, string ps_icd10_code, string ps_assessment_category_id, string ps_description, string ps_location_domain, string ps_auto_close, integer pi_auto_close_interval_amount, string ps_auto_close_interval_unit, long pl_risk_level, long pl_complexity, string ps_long_description) RPCFUNC ALIAS FOR "dbo.sp_new_assessment_definition"
FUNCTION long sp_new_box(string ps_box_type, string ps_description, ref long pl_box_id) RPCFUNC ALIAS FOR "dbo.sp_new_box"
FUNCTION long sp_new_display_script(string ps_context_object, string ps_display_script, string ps_description, string ps_created_by, string ps_script_type, string ps_parent_config_object_id) RPCFUNC ALIAS FOR "dbo.sp_new_display_script"
FUNCTION long sp_new_drug(string ps_drug_id, string ps_drug_type, string ps_common_name, string ps_generic_name, string ps_controlled_substance_flag, real pr_default_duration_amount, string ps_default_duration_unit, string ps_default_duration_prn, real pr_max_dose_per_day, string ps_max_dose_unit) RPCFUNC ALIAS FOR "dbo.sp_new_drug"
FUNCTION long sp_new_drug_administration(string ps_drug_id, integer pi_administration_sequence, string ps_administer_frequency, real pr_administer_amount, string ps_administer_unit, string ps_mult_by_what, string ps_calc_per, string ps_description, string ps_form_rxcui) RPCFUNC ALIAS FOR "dbo.sp_new_drug_administration"
FUNCTION long sp_new_drug_definition(string ps_drug_type, string ps_common_name, string ps_generic_name, string ps_status, string ps_controlled_substance_flag, real pr_default_duration_amount, string ps_default_duration_unit, string ps_default_duration_prn, real pr_max_dose_per_day, string ps_max_dose_unit, long pl_owner_id, ref string ps_drug_id) RPCFUNC ALIAS FOR "dbo.sp_new_drug_definition"
FUNCTION long sp_new_drug_drug_category(string ps_drug_id, string ps_drug_category_id) RPCFUNC ALIAS FOR "dbo.sp_new_drug_drug_category"
FUNCTION long sp_new_drug_hcpcs(string ps_drug_id, real pr_administer_amount, string ps_administer_unit, string ps_hcpcs_procedure_id) RPCFUNC ALIAS FOR "dbo.sp_new_drug_hcpcs"
FUNCTION long sp_new_drug_package(string ps_drug_id, string ps_package_id, string ps_prescription_flag, real pr_default_dispense_amount, string ps_default_dispense_unit, string ps_take_as_directed, integer pi_sort_order) RPCFUNC ALIAS FOR "dbo.sp_new_drug_package"
FUNCTION long sp_new_family_history(string ps_cpr_id, long pl_encounter_id, string ps_name, string ps_relation, integer pi_birth_year, integer pi_age_at_death, string ps_cause_of_death) RPCFUNC ALIAS FOR "dbo.sp_new_family_history"
FUNCTION long sp_new_family_illness(string ps_cpr_id, long pl_encounter_id, long pl_family_history_sequence, string ps_assessment_id, integer pi_age) RPCFUNC ALIAS FOR "dbo.sp_new_family_illness"
FUNCTION long sp_new_letter(string ps_cpr_id, string ps_letter_type, string ps_description, long pl_attachment_id, string ps_created_by, long pl_encounter_id) RPCFUNC ALIAS FOR "dbo.sp_new_letter"
FUNCTION long sp_new_location(ref string ps_location, string ps_location_domain, string ps_description, integer pi_sort_sequence, string ps_diffuse_flag) RPCFUNC ALIAS FOR "dbo.sp_new_location"
FUNCTION long sp_new_location_domain(ref string ps_location_domain, string ps_description) RPCFUNC ALIAS FOR "dbo.sp_new_location_domain"
FUNCTION long sp_new_maintenance_rule(string ps_assessment_flag, string ps_sex, string ps_race, long pl_age_range_id, string ps_description, long pl_interval, string ps_interval_unit, long pl_warning_days, ref long pl_maintenance_rule_id) RPCFUNC ALIAS FOR "dbo.sp_new_maintenance_rule"
FUNCTION long sp_new_menu(string ps_description, string ps_specialty_id, string ps_context_object, string ps_menu_category) RPCFUNC ALIAS FOR "dbo.sp_new_menu"
FUNCTION long sp_new_menu_item(long pl_menu_id, string ps_menu_item_type, string ps_menu_item, string ps_button_title, string ps_button_help, string ps_button, integer pi_sort_sequence) RPCFUNC ALIAS FOR "dbo.sp_new_menu_item"
FUNCTION long sp_new_observation(string ps_collection_location_domain, string ps_perform_location_domain, string ps_collection_procedure_id, string ps_perform_procedure_id, string ps_description, string ps_composite_flag, string ps_exclusive_flag, string ps_in_context_flag, string ps_location_pick_flag, string ps_location_bill_flag, string ps_observation_type, string ps_default_view, string ps_display_style) RPCFUNC ALIAS FOR "dbo.sp_new_observation"
FUNCTION long sp_new_observation_branch(long pl_parent_node_id, integer pi_parent_severity, long pl_child_node_id, ref long pl_branch_id) RPCFUNC ALIAS FOR "dbo.sp_new_observation_branch"
FUNCTION long sp_new_observation_category(string ps_treatment_type, string ps_observation_category_id, string ps_description, integer pi_sort_sequence, string ps_observation_id) RPCFUNC ALIAS FOR "dbo.sp_new_observation_category"
FUNCTION long sp_new_observation_result(string ps_observation_id, string ps_result_type, string ps_result_unit, string ps_result, string ps_result_amount_flag, string ps_print_result_flag, string ps_specimen_type, string ps_abnormal_flag, integer pi_severity, string ps_external_source, long pl_property_id, string ps_service, string ps_unit_preference, string ps_status, ref integer pi_result_sequence) RPCFUNC ALIAS FOR "dbo.sp_new_observation_result"
FUNCTION long sp_new_patient_address(string ps_cpr_id, string ps_description, string ps_address_line_1, string ps_address_line_2, string ps_city, string ps_state, string ps_zip, string ps_country, string ps_created_by) RPCFUNC ALIAS FOR "dbo.sp_new_patient_address"
FUNCTION long sp_new_patient_communication(string ps_cpr_id, string ps_communication_type, string ps_communication_value, string ps_note, string ps_created_by, string ps_communication_name) RPCFUNC ALIAS FOR "dbo.sp_new_patient_communication"
FUNCTION long sp_new_procedure(string ps_procedure_type, string ps_cpt_code, decimal pdc_charge, string ps_procedure_category_id, string ps_description, string ps_service, string ps_vaccine_id, real pr_units, string ps_modifier, string ps_other_modifiers, string ps_billing_id, string ps_location_domain, long pi_risk_level, string ps_default_bill_flag) RPCFUNC ALIAS FOR "dbo.sp_new_procedure"
FUNCTION long sp_new_treatment_def(ref long pl_definition_id, string ps_assessment_id, string ps_treatment_type, string ps_treatment_description, long pl_followup_workplan_id, string ps_user_id, integer pi_sort_sequence, string ps_instructions, long pl_parent_definition_id, string ps_child_flag, string ps_treatment_mode) RPCFUNC ALIAS FOR "dbo.sp_new_treatment_def"
FUNCTION long sp_new_workplan(string ps_workplan_type, string ps_treatment_type, string ps_in_office_flag, string ps_description, ref long pl_workplan_id) RPCFUNC ALIAS FOR "dbo.sp_new_workplan"
FUNCTION long sp_observation_loop_check(string ps_parent_observation_id, string ps_new_observation_id, ref integer pi_loop) RPCFUNC ALIAS FOR "dbo.sp_observation_loop_check"
FUNCTION long sp_observation_search(string ps_treatment_type, string ps_observation_category_id, string ps_top_20_user_id, string ps_description, string ps_procedure_id, string ps_collect_cpt_code, string ps_perform_cpt_code, string ps_in_context_flag, string ps_specialty_id, string ps_composite_flag, string ps_status, string ps_top_20_code) RPCFUNC ALIAS FOR "dbo.sp_observation_search"
FUNCTION long sp_obstree_encounter(string ps_cpr_id, long pl_encounter_id, string ps_treatment_type, string ps_observation_type) RPCFUNC ALIAS FOR "dbo.sp_obstree_encounter"
FUNCTION long sp_obstree_observation(string ps_cpr_id, long pl_observation_sequence) RPCFUNC ALIAS FOR "dbo.sp_obstree_observation"
FUNCTION long sp_obstree_patient(string ps_cpr_id, string ps_observation_id) RPCFUNC ALIAS FOR "dbo.sp_obstree_patient"
FUNCTION long sp_obstree_patient_dates(string ps_cpr_id, string ps_observation_id, datetime pdt_begin_date, datetime pdt_end_date) RPCFUNC ALIAS FOR "dbo.sp_obstree_patient_dates"
FUNCTION long sp_obstree_treatment(string ps_cpr_id, long pl_treatment_id, string ps_root_observation_id, string ps_root_observation_tag, string ps_child_observation_id, string ps_child_observation_tag, string ps_exclude_observation_tag) RPCFUNC ALIAS FOR "dbo.sp_obstree_treatment"
FUNCTION long sp_open_encounters(string ps_office_id) RPCFUNC ALIAS FOR "dbo.sp_open_encounters"
FUNCTION long sp_open_encounters_in_room_type(string ps_office_id, string ps_room_type) RPCFUNC ALIAS FOR "dbo.sp_open_encounters_in_room_type"
FUNCTION long sp_order_assessment(string ps_cpr_id, long pl_encounter_id, string ps_assessment_id, datetime pdt_begin_date, string ps_diagnosed_by, string ps_created_by, ref long pl_problem_id) RPCFUNC ALIAS FOR "dbo.sp_order_assessment"
FUNCTION long sp_Order_Encounter_Workplan(string ps_cpr_id, long pl_encounter_id, string ps_ordered_by, string ps_created_by, ref long pl_patient_workplan_id) RPCFUNC ALIAS FOR "dbo.sp_Order_Encounter_Workplan"
FUNCTION long sp_order_past_treatment_services(long pl_patient_workplan_id, long pl_treatment_id, string ps_ordered_by, string ps_ordered_for, string ps_created_by) RPCFUNC ALIAS FOR "dbo.sp_order_past_treatment_services"
FUNCTION long sp_order_service_workplan(string ps_cpr_id, long pl_encounter_id, long pl_treatment_id, string ps_in_office_flag, string ps_ordered_by, string ps_owned_by, string ps_created_by, ref long pl_patient_workplan_id) RPCFUNC ALIAS FOR "dbo.sp_order_service_workplan"
FUNCTION long sp_order_service_workplan_item(string ps_cpr_id, long pl_encounter_id, long pl_patient_workplan_id, string ps_ordered_service, string ps_in_office_flag, string ps_auto_perform_flag, string ps_observation_tag, string ps_description, string ps_ordered_by, string ps_ordered_for, integer pi_step_number, string ps_created_by, ref long pl_patient_workplan_item_id) RPCFUNC ALIAS FOR "dbo.sp_order_service_workplan_item"
FUNCTION long sp_Order_Treatment_Workplans(string ps_cpr_id, long pl_treatment_id, string ps_treatment_type, string ps_treatment_mode, long pl_ordered_workplan_id, long pl_followup_workplan_id, long pl_encounter_id, string ps_description, string ps_ordered_by, string ps_ordered_for, long pl_parent_patient_workplan_item_id, string ps_in_office_flag, string ps_created_by, ref long pl_ordered_patient_workplan_id, ref long pl_followup_patient_workplan_id) RPCFUNC ALIAS FOR "dbo.sp_Order_Treatment_Workplans"
FUNCTION long sp_Order_Workplan(string ps_cpr_id, long pl_workplan_id, long pl_encounter_id, long pl_problem_id, long pl_treatment_id, long pl_observation_sequence, long pl_attachment_id, string ps_description, string ps_ordered_by, string ps_ordered_for, string ps_in_office_flag, string ps_mode, long pl_parent_patient_workplan_item_id, string ps_created_by, string ps_dispatch_flag, ref long pl_patient_workplan_id) RPCFUNC ALIAS FOR "dbo.sp_Order_Workplan"
FUNCTION long sp_order_workplan_item(string ps_cpr_id, long pl_encounter_id, long pl_patient_workplan_id, string ps_ordered_service, string ps_in_office_flag, string ps_auto_perform_flag, string ps_observation_tag, string ps_description, string ps_ordered_by, string ps_ordered_for, integer pi_step_number, integer pi_priority, string ps_created_by) RPCFUNC ALIAS FOR "dbo.sp_order_workplan_item"
FUNCTION long sp_Order_Workplan_Treatment(string ps_cpr_id, long pl_patient_workplan_id, long pl_patient_workplan_item_id, string ps_treatment_type, long pl_encounter_id, string ps_description, string ps_ordered_by, string ps_ordered_for, string ps_created_by, ref long pl_treatment_id) RPCFUNC ALIAS FOR "dbo.sp_Order_Workplan_Treatment"
FUNCTION long sp_patient_any_results (string ps_cpr_id, long pl_observation_sequence, string ps_result_type, string ps_abnormal_flag) RPCFUNC ALIAS FOR "dbo.sp_patient_any_results"
FUNCTION long sp_patient_encounter_merge(string cpr_id, long encounter_id_keep, long encounter_id_merge) RPCFUNC ALIAS FOR "dbo.sp_patient_encounter_merge"
FUNCTION long sp_patient_maintenance(string ps_cpr_id) RPCFUNC ALIAS FOR "dbo.sp_patient_maintenance"
FUNCTION long sp_patient_merge(string cpr_id_keep, string cpr_id_merge) RPCFUNC ALIAS FOR "dbo.sp_patient_merge"
FUNCTION long sp_patient_search(string ps_billing_id, string ps_last_name, string ps_first_name, string ps_employer, string ps_employeeid, string ps_ssn, string ps_patient_status) RPCFUNC ALIAS FOR "dbo.sp_patient_search"
FUNCTION long sp_pick_service(string ps_context_object) RPCFUNC ALIAS FOR "dbo.sp_pick_service"
FUNCTION long sp_post_encounter_note(string ps_cpr_id, long pl_patient_workplan_id, long pl_encounter_id, string ps_encounter_note, string ps_ordered_by, string ps_ordered_for, string ps_created_by) RPCFUNC ALIAS FOR "dbo.sp_post_encounter_note"
FUNCTION long sp_procedure_search(string ps_procedure_type, string ps_procedure_category_id, string ps_description, string ps_cpt_code, string ps_specialty_id, string ps_status) RPCFUNC ALIAS FOR "dbo.sp_procedure_search"
FUNCTION long sp_purge_messages(datetime pdt_date) RPCFUNC ALIAS FOR "dbo.sp_purge_messages"
FUNCTION long sp_queue_event(string ps_event, datetime pdt_start_date, ref long pl_event_id) RPCFUNC ALIAS FOR "dbo.sp_queue_event"
FUNCTION long sp_queue_event_set_attribute(long pl_event_id, string ps_attribute, string ps_value) RPCFUNC ALIAS FOR "dbo.sp_queue_event_set_attribute"
FUNCTION long sp_queue_event_set_ready(long pl_event_id) RPCFUNC ALIAS FOR "dbo.sp_queue_event_set_ready"
FUNCTION long sp_register_computer(string ps_office_id, string ps_logon_id, string ps_computername, ref long pl_computer_id) RPCFUNC ALIAS FOR "dbo.sp_register_computer"
FUNCTION long sp_remove_attachment(string ps_cpr_id, long pl_attachment_id, string ps_user_id, string ps_created_by, string ps_context_object, long pl_object_key) RPCFUNC ALIAS FOR "dbo.sp_remove_attachment"
FUNCTION long sp_remove_results(string ps_cpr_id, long pl_observation_sequence, string ps_location, integer pi_result_sequence, long pl_encounter_id, string ps_user_id, string ps_created_by) RPCFUNC ALIAS FOR "dbo.sp_remove_results"
FUNCTION long sp_replicate_encounters() RPCFUNC ALIAS FOR "dbo.sp_replicate_encounters"
FUNCTION long sp_report_list(string ps_report_type) RPCFUNC ALIAS FOR "dbo.sp_report_list"
FUNCTION long sp_sales_demo_prep() RPCFUNC ALIAS FOR "dbo.sp_sales_demo_prep"
FUNCTION long sp_set_assessment_billing(string ps_cpr_id, long pl_encounter_id, long pl_problem_id, string ps_bill_flag, string ps_created_by) RPCFUNC ALIAS FOR "dbo.sp_set_assessment_billing"
FUNCTION long sp_set_assessment_progress(string ps_cpr_id, long pl_problem_id, long pl_encounter_id, datetime pdt_progress_date_time, integer pi_diagnosis_sequence, string ps_progress_type, string ps_progress_key, string ps_progress, string ps_severity, long pl_attachment_id, long pl_patient_workplan_item_id, long pl_risk_level, string ps_user_id, string ps_created_by) RPCFUNC ALIAS FOR "dbo.sp_set_assessment_progress"
FUNCTION long sp_set_assessment_specialty(string ps_assessment_id, string ps_specialty_id, string ps_flag) RPCFUNC ALIAS FOR "dbo.sp_set_assessment_specialty"
FUNCTION long sp_set_assessment_treatment(string ps_cpr_id, long pl_problem_id, long pl_treatment_id, long pl_encounter_id, string ps_created_by) RPCFUNC ALIAS FOR "dbo.sp_set_assessment_treatment"
FUNCTION long sp_set_assmnt_charge_billing(string ps_cpr_id, long pl_encounter_id, long pl_problem_id, long pl_encounter_charge_id, string ps_bill_flag, string ps_created_by) RPCFUNC ALIAS FOR "dbo.sp_set_assmnt_charge_billing"
FUNCTION long sp_set_cat_defaults(integer pi_exam_sequence, string ps_observation_type, string ps_observation_category_id, string ps_cpr_id, long pl_encounter_id, long pl_treatment_id, string ps_observed_by) RPCFUNC ALIAS FOR "dbo.sp_set_cat_defaults"
FUNCTION long sp_set_charge_billing(string ps_cpr_id, long pl_encounter_id, long pl_encounter_charge_id, string ps_bill_flag, string ps_created_by) RPCFUNC ALIAS FOR "dbo.sp_set_charge_billing"
FUNCTION long sp_set_default_locations(string ps_cpr_id, long pl_encounter_id, long pl_treatment_id, string ps_observation_id, integer pi_result_sequence, datetime pdt_result_date_time, string ps_observed_by, string ps_created_by) RPCFUNC ALIAS FOR "dbo.sp_set_default_locations"
FUNCTION long sp_set_default_results_by_loc(string ps_cpr_id, long pl_treatment_id, string ps_observation_id, string ps_location, long pl_encounter_id, datetime pdt_result_date_time, string ps_observed_by, string ps_created_by) RPCFUNC ALIAS FOR "dbo.sp_set_default_results_by_loc"
FUNCTION long sp_set_encounter_posted(string ps_cpr_id, long pl_encounter_id) RPCFUNC ALIAS FOR "dbo.sp_set_encounter_posted"
FUNCTION long sp_Set_Encounter_Progress(string ps_cpr_id, long pl_encounter_id, long pl_attachment_id, string ps_progress_type, string ps_progress_key, string ps_progress, datetime pdt_progress_date_time, long pl_patient_workplan_item_id, long pl_risk_level, string ps_user_id, string ps_created_by) RPCFUNC ALIAS FOR "dbo.sp_Set_Encounter_Progress"
FUNCTION long sp_set_encounter_type_specialty(string ps_encounter_type, string ps_specialty_id, string ps_flag) RPCFUNC ALIAS FOR "dbo.sp_set_encounter_type_specialty"
FUNCTION long sp_set_exam_default_results(integer pi_exam_sequence, string ps_cpr_id, long pl_encounter_id, long pl_treatment_id, string ps_observed_by, string ps_created_by) RPCFUNC ALIAS FOR "dbo.sp_set_exam_default_results"
FUNCTION long sp_set_exam_defaults_from_actuals(string ps_user_id, long pl_exam_sequence, string ps_cpr_id, long pl_observation_sequence, long pl_branch_id) RPCFUNC ALIAS FOR "dbo.sp_set_exam_defaults_from_actuals"
FUNCTION long sp_set_loc_as_default(string ps_cpr_id, long pl_encounter_id, long pl_treatment_id, string ps_observation_id, string ps_location, string ps_user_id) RPCFUNC ALIAS FOR "dbo.sp_set_loc_as_default"
FUNCTION long sp_set_menu(long pl_menu_id, string ps_description, string ps_specialty_id, string ps_context_object, ref long pl_rtn_menu_id) RPCFUNC ALIAS FOR "dbo.sp_set_menu"
FUNCTION long sp_set_menu_item(long pl_menu_id, long pl_menu_item_id, string ps_menu_item_type, string ps_menu_item, string ps_button_title, string ps_button_help, string ps_button, long pl_sort_sequence, ref long pl_rtn_menu_item_id) RPCFUNC ALIAS FOR "dbo.sp_set_menu_item"
FUNCTION long sp_set_observation_comment(string ps_cpr_id, long pl_observation_sequence, string ps_observation_id, string ps_comment_type, string ps_comment_title, datetime pdt_comment_date_time, string ps_comment, string ps_abnormal_flag, integer pi_severity, long pl_treatment_id, long pl_encounter_id, long pl_attachment_id, string ps_user_id, string ps_created_by) RPCFUNC ALIAS FOR "dbo.sp_set_observation_comment"
FUNCTION long sp_set_observation_result_progress(string ps_cpr_id, long pl_observation_sequence, long pl_location_result_sequence, long pl_encounter_id, string ps_progress_type, string ps_progress_key, string ps_progress, datetime pdt_progress_date_time, string ps_user_id, string ps_created_by) RPCFUNC ALIAS FOR "dbo.sp_set_observation_result_progress"
FUNCTION long sp_set_patient_folder_selection() RPCFUNC ALIAS FOR "dbo.sp_set_patient_folder_selection"
FUNCTION long sp_Set_Patient_Authority(string ps_cpr_id, datetime pdt_start_date, datetime pdt_end_date, long pl_authority_sequence, string ps_authority_id, string ps_user_id, string ps_created_by) RPCFUNC ALIAS FOR "dbo.sp_Set_Patient_Authority"
FUNCTION long sp_Set_Patient_Progress(string ps_cpr_id, long pl_encounter_id, long pl_attachment_id, string ps_progress_type, string ps_progress_key, string ps_progress, datetime pdt_progress_date_time, long pl_patient_workplan_item_id, long pl_risk_level, string ps_user_id, string ps_created_by) RPCFUNC ALIAS FOR "dbo.sp_Set_Patient_Progress"
FUNCTION long sp_set_preference(string ps_preference_type, string ps_preference_level, string ps_preference_key, string ps_preference_id, string ps_preference_value) RPCFUNC ALIAS FOR "dbo.sp_set_preference"
FUNCTION long sp_set_referral_attachment_id(string ps_cpr_id, long pl_problem_id, integer pi_treatment_sequence, long pl_attachment_id) RPCFUNC ALIAS FOR "dbo.sp_set_referral_attachment_id"
FUNCTION long sp_set_report_attribute(string ps_report_id, string ps_attribute, string ps_value, string ps_component_id) RPCFUNC ALIAS FOR "dbo.sp_set_report_attribute"
FUNCTION long sp_set_result_na(string ps_observation_id, integer pi_result_sequence) RPCFUNC ALIAS FOR "dbo.sp_set_result_na"
FUNCTION long sp_set_treatment_attachment_id(string ps_cpr_id, long pl_treatment_id, long pl_attachment_id) RPCFUNC ALIAS FOR "dbo.sp_set_treatment_attachment_id"
FUNCTION long sp_set_treatment_billing(string ps_cpr_id, long pl_encounter_id, long pl_problem_id, long pl_treatment_id, string ps_procedure_type, string ps_bill_flag, string ps_created_by) RPCFUNC ALIAS FOR "dbo.sp_set_treatment_billing"
FUNCTION long sp_set_treatment_followup_workplan_item(string ps_cpr_id, long pl_encounter_id, long pl_patient_workplan_id, string ps_ordered_treatment_type, string ps_description, string ps_ordered_by, string ps_created_by, datetime pdt_created, ref long pl_patient_workplan_item_id) RPCFUNC ALIAS FOR "dbo.sp_set_treatment_followup_workplan_item"
FUNCTION long sp_set_treatment_progress(string ps_cpr_id, long pl_treatment_id, long pl_encounter_id, string ps_progress_type, string ps_progress_key, string ps_progress, datetime pdt_progress_date_time, long pl_patient_workplan_item_id, long pl_risk_level, long pl_attachment_id, string ps_user_id, string ps_created_by) RPCFUNC ALIAS FOR "dbo.sp_set_treatment_progress"
FUNCTION long sp_set_treatment_signature(long pl_treatment_id, long pl_attachment_id) RPCFUNC ALIAS FOR "dbo.sp_set_treatment_signature"
FUNCTION long sp_Set_User_Progress(string ps_user_id, string ps_progress_user_id, datetime pdt_progress_date_time, string ps_progress_type, string ps_progress_key, string ps_progress, string ps_created_by) RPCFUNC ALIAS FOR "dbo.sp_Set_User_Progress"
FUNCTION long sp_set_workplan_item_progress(long pl_patient_workplan_item_id, string ps_user_id, string ps_progress_type, datetime pdt_progress_date_time, string ps_created_by, long pl_computer_id) RPCFUNC ALIAS FOR "dbo.sp_set_workplan_item_progress"
FUNCTION long sp_set_workplan_status(string ps_cpr_id, long pl_encounter_id, long pl_treatment_id, long pl_patient_workplan_id, string ps_progress_type, datetime pdt_progress_date_time, string ps_completed_by, string ps_owned_by, string ps_created_by) RPCFUNC ALIAS FOR "dbo.sp_set_workplan_status"
FUNCTION long sp_setup_integration(string ps_billing_system, string ps_office_id) RPCFUNC ALIAS FOR "dbo.sp_setup_integration"
FUNCTION long sp_setup_practicemanagement(string ps_billing_system, string ps_office_id) RPCFUNC ALIAS FOR "dbo.sp_setup_practicemanagement"
FUNCTION long sp_stone_and_replicate(string ps_cpr_id, long pl_encounter_id) RPCFUNC ALIAS FOR "dbo.sp_stone_and_replicate"
FUNCTION long sp_table_update(string ps_table_name, string ps_updated_by) RPCFUNC ALIAS FOR "dbo.sp_table_update"
FUNCTION long sp_top_20_delete(string ps_top_20_user_id, string ps_top_20_code, long pl_top_20_sequence) RPCFUNC ALIAS FOR "dbo.sp_top_20_delete"
FUNCTION long sp_top_20_sort_update(string ps_top_20_user_id, string ps_top_20_code, long pl_top_20_sequence, long pl_new_sort_sequence) RPCFUNC ALIAS FOR "dbo.sp_top_20_sort_update"
FUNCTION long sp_treatment_any_results (string ps_cpr_id, long pl_treatment_id, string ps_result_type) RPCFUNC ALIAS FOR "dbo.sp_treatment_any_results"
FUNCTION long sp_treatment_auto_perform_services(string ps_cpr_id, long pl_treatment_id, string ps_user_id) RPCFUNC ALIAS FOR "dbo.sp_treatment_auto_perform_services"
FUNCTION long sp_treatment_key_field(string ps_treatment_type, ref string ps_treatment_key) RPCFUNC ALIAS FOR "dbo.sp_treatment_key_field"
FUNCTION long sp_treatment_progress_status(string ps_cpr_id, long pl_encounter_id, long pl_treatment_id, ref long pl_total_count, ref long pl_this_encounter_count) RPCFUNC ALIAS FOR "dbo.sp_treatment_progress_status"
FUNCTION long sp_unlock_patient(string ps_cpr_id, string ps_user_id, ref string ps_locked_by) RPCFUNC ALIAS FOR "dbo.sp_unlock_patient"
FUNCTION long sp_upd_charge_from_treatment(string ps_cpr_id, long pl_problem_id, integer pi_treatment_sequence, decimal psm_charge) RPCFUNC ALIAS FOR "dbo.sp_upd_charge_from_treatment"
FUNCTION long sp_update_assessment_def(string ps_assessment_id, string ps_icd10_code, string ps_assessment_category_id, string ps_description, string ps_location_domain, string ps_auto_close, integer pi_auto_close_interval_amount, string ps_auto_close_interval_unit, long pl_risk_level, long pl_complexity, string ps_long_description) RPCFUNC ALIAS FOR "dbo.sp_update_assessment_def"

FUNCTION long sp_update_charge(string ps_cpr_id, long pl_encounter_id, long pl_encounter_charge_id, string ps_procedure_id, decimal pm_charge) RPCFUNC ALIAS FOR "dbo.sp_update_charge"
FUNCTION long sp_update_drug(string ps_drug_id, string ps_drug_type, string ps_controlled_substance_flag, real pr_default_duration_amount, string ps_default_duration_unit, string ps_default_duration_prn, real pr_max_dose_per_day, string ps_max_dose_unit, string ps_drug_common_name) RPCFUNC ALIAS FOR "dbo.sp_update_drug"
FUNCTION long sp_update_drug_package(string ps_drug_id, string ps_package_id, string ps_prescription_flag, real pr_default_dispense_amount, string ps_default_dispense_unit, string ps_take_as_directed, integer pi_sort_order) RPCFUNC ALIAS FOR "dbo.sp_update_drug_package"
FUNCTION long sp_update_family_history(string ps_cpr_id, long pl_family_history_sequence, string ps_name, string ps_relation, integer pi_birth_year, integer pi_age_at_death, string ps_cause_of_death) RPCFUNC ALIAS FOR "dbo.sp_update_family_history"
FUNCTION long sp_update_family_illness(string ps_cpr_id, long pl_family_history_sequence, long pl_family_illness_sequence, string ps_assessment_id, integer pi_age) RPCFUNC ALIAS FOR "dbo.sp_update_family_illness"
FUNCTION long sp_update_location(string ps_location, integer pi_sort_sequence, string ps_diffuse_flag) RPCFUNC ALIAS FOR "dbo.sp_update_location"
FUNCTION long sp_update_observation(string ps_observation_id, string ps_collection_location_domain, string ps_perform_location_domain, string ps_collection_procedure_id, string ps_perform_procedure_id, string ps_description, string ps_composite_flag, string ps_exclusive_flag, string ps_in_context_flag, string ps_location_pick_flag, string ps_location_bill_flag, string ps_observation_type, string ps_default_view, string ps_display_style, string ps_status) RPCFUNC ALIAS FOR "dbo.sp_update_observation"
FUNCTION long sp_update_observation_result(string ps_observation_id, integer pi_result_sequence, string ps_result_unit, string ps_result_amount_flag, string ps_print_result_flag, string ps_specimen_type, string ps_abnormal_flag, integer pi_severity, string ps_external_source, long pl_property_id, string ps_service, string ps_unit_preference, string ps_status) RPCFUNC ALIAS FOR "dbo.sp_update_observation_result"
FUNCTION long sp_update_package(string ps_package_id, string ps_administer_method, string ps_description, string ps_administer_unit, string ps_dose_unit, real pr_administer_per_dose, string ps_dosage_form, real pr_dose_amount) RPCFUNC ALIAS FOR "dbo.sp_update_package"
FUNCTION long sp_update_procedure(string ps_procedure_id, string ps_procedure_type, string ps_cpt_code, decimal psm_charge, string ps_procedure_category_id, string ps_description, string ps_vaccine_id, real pr_units, string ps_modifier, string ps_other_modifiers, string ps_billing_id, string ps_location_domain, long pi_risk_level, string ps_default_bill_flag) RPCFUNC ALIAS FOR "dbo.sp_update_procedure"
FUNCTION long sp_user_logoff(string ps_user_id, long pl_computer_id) RPCFUNC ALIAS FOR "dbo.sp_user_logoff"
FUNCTION long sp_user_search(string ps_role_id, string ps_specialty_id, string ps_name, string ps_user_status) RPCFUNC ALIAS FOR "dbo.sp_user_search"
FUNCTION long sp_user_top_20_search(string ps_top_20_code, string ps_top_20_user_id, string ps_role_prefix) RPCFUNC ALIAS FOR "dbo.sp_user_top_20_search"
FUNCTION long sp_workplan_search(string ps_workplan_type, string ps_workplan_category_id, string ps_in_office_flag, string ps_treatment_type, string ps_description, string ps_specialty_id, string ps_status) RPCFUNC ALIAS FOR "dbo.sp_workplan_search"
FUNCTION long sp_xml_add_observation(string ps_cpr_id, string ps_description, long pl_treatment_id, long pl_encounter_id, datetime pdt_result_expected_date, long pl_parent_observation_sequence, long pl_owner_id, string ps_event_id,string ps_observed_by, string ps_created_by, string ps_observation_id, string ps_observation_tag) RPCFUNC ALIAS FOR "dbo.sp_xml_add_observation"
FUNCTION long sp_xml_add_observation_result(long pl_observation_sequence, string location, string ps_result, string ps_result_value, string ps_print_result_flag, string ps_result_unit, string ps_abnormal_flag, string ps_abnormal_nature, integer pi_severity, string ps_observed_by, string ps_created_by, datetime pdt_result_date_time, integer pl_encounter_id, integer pl_attachment_id,string ps_reference_range) RPCFUNC ALIAS FOR "dbo.sp_xml_add_observation_result"
FUNCTION long xml_add_mapping(long pl_owner_id, string ps_code_domain, string ps_code_version, string ps_code, string ps_code_description, string ps_epro_domain, string ps_epro_id, string ps_epro_description, long pl_epro_owner_id, string ps_created_by) RPCFUNC ALIAS FOR "dbo.xml_add_mapping"
FUNCTION long xml_lookup_epro_id(long pl_owner_id, string ps_code_domain, string ps_code_version, string ps_code, string ps_code_description, string ps_epro_domain, string ps_created_by, ref string ps_epro_id) RPCFUNC ALIAS FOR "dbo.xml_lookup_epro_id"
FUNCTION long xml_remove_mapping(long pl_owner_id, string ps_code_domain, string ps_code_version, string ps_code, string ps_epro_domain, string ps_epro_id, string ps_user_id, int pi_remove_all) RPCFUNC ALIAS FOR "dbo.xml_remove_mapping"
FUNCTION long xml_set_default_mapping(long pl_owner_id, string ps_code_domain, string ps_code_version, string ps_code, string ps_epro_domain, string ps_epro_id) RPCFUNC ALIAS FOR "dbo.xml_set_default_mapping"


end prototypes

type variables
boolean transaction_open
integer transaction_level
powerobject caller_object[]
string caller_text[]
string sql_error[]

long customer_id
string actual_database_mode
string database_mode
string database_status
string database_id
datetime master_configuration_date
long modification_level
string client_link
boolean beta_flag
long sql_version // 8 = SQL2000, 9 = SQL2005, 10 = SQL2008
string sql_server_productversion
boolean connect_approle = true
str_filepath default_filepath

// SQL versions for database scripts
long db_script_major_release
string db_script_database_version

string appname
boolean deadlock
boolean connected

u_event_log mylog

private str_sql_syntax syntax_cache[]
private long syntax_cache_count = 0
private long syntax_cache_last = 0
private long syntax_cache_max = 500
private long syntax_cache_hits = 0
private long syntax_cache_misses = 0

boolean windows_authentication = true
boolean sql_authentication = true
string connected_using

boolean is_masterdb
boolean is_dbo_user
boolean is_dbo
boolean is_eprodb

boolean is_approle_set
boolean is_login_set

string application_role = "cprsystem"

string adodb_connectstring

string remote_server = "greenolive"

string remote_database = "epro_40_synch"

long spid

u_ds_data database_columns

long temp_proc_number = 0

end variables

forward prototypes
public subroutine checkpoint (string ps_text)
public subroutine rollback_transaction ()
public subroutine force_commit ()
public function integer dbreconnect ()
public function integer dbconnect (string ps_server, string ps_dbname, string ps_dbms, string ps_logid, string ps_logpass)
public function integer dbconnect (string ps_server, string ps_dbname, string ps_dbms)
public subroutine dbdisconnect ()
public function string sys ()
public function integer dbconnect (string ps_server, string ps_dbname, string ps_dbms, string ps_appname, string ps_logid, string ps_logpass)
public function integer dbconnect (string ps_server, string ps_dbname, string ps_dbms, string ps_appname)
public function integer dbconnect (string ps_appname)
public function string error_message ()
public function integer execute_string (string ps_string)
public function integer get_dw_syntax (string ps_sql, ref string ps_syntax)
public function integer dbconnect (string ps_server, string ps_dbname, string ps_dbms, string ps_appname, string ps_logid, string ps_logpass, string ps_dbparm, string ps_connectstring)
public subroutine commit_transaction ()
public subroutine begin_transaction (powerobject po_caller_object, string ps_caller_text)
public function boolean check ()
public function string sys (string ps_user)
public subroutine set_server (string ps_servername)
public function integer check_database ()
public function str_scripts parse_script (string ps_script)
public function integer execute_script (long pl_script_id)
public function string approle_command ()
public function integer sync_table (string ps_tablename)
public function boolean my_transaction (powerobject po_caller_object, string ps_caller_text)
public function boolean is_dbmode (string ps_database_mode)
public function integer set_database_mode (string ps_database_mode)
public function integer set_remote_server ()
public function boolean check_remote_server ()
public function integer upgrade_database (long pl_modification_level)
public function integer bootstrap_database_scripts ()
public function integer execute_script (long pl_script_id, str_attributes pstr_substitute)
public function integer execute_script (string ps_script_type, string ps_script_name)
public function string available_version (string ps_system_id)
public function integer upgrade_content (string ps_system_id)
public function integer parse_version (string ps_version, ref long pl_major_release, ref string ps_database_version, ref long pl_modification_level, ref long pl_compile)
public function integer set_beta_status (boolean pb_beta_flag)
public subroutine add_credentials (string ps_access_level, ref str_attributes pstr_attributes)
public function string fn_get_preference (string ps_preference_type, string ps_preference_id, string ps_user_id, long pl_computer_id)
public function string fn_attribute_description (string ps_attribute, string ps_value)
public function string fn_check_encounter_owner_billable (string ps_cpr_id, long pl_encounter_id)
public function string fn_context_object_type (string ps_context_object, string ps_cpr_id, long pl_object_key)
public function string fn_get_specific_preference (string ps_preference_type, string ps_preference_level, string ps_preference_key, string ps_preference_id)
public function string fn_lookup_epro_id (long pl_owner_id, string ps_code_domain, string ps_code_value, string ps_jmj_domain)
public function string fn_lookup_patient (string ps_id_domain, string ps_id)
public function string fn_lookup_patient_billingid (string ps_id_domain, string ps_id)
public function string fn_lookup_user (string ps_office_id, string ps_id)
public function string fn_lookup_user_billingid (string ps_office_id, string ps_id)
public function string fn_object_description (string ps_object, string ps_key)
public function string fn_object_equivalence_group (string ps_object_id)
public function string fn_object_id_from_key (string ps_object_type, string ps_object_key)
public function string fn_patient_full_name (string ps_cpr_id)
public function string fn_patient_object_last_result (string ps_cpr_id, string ps_context_object, long pl_object_key, string ps_observation_id, integer pi_result_sequence)
public function string fn_patient_object_property (string ps_cpr_id, string ps_context_object, long pl_object_key, string ps_progress_key)
public function string fn_patient_object_description (string ps_cpr_id, string ps_context_object, long pl_object_key)
public function string fn_string_to_identifier (string ps_string)
public function string fn_config_object_description (string ps_parent_id)
public function string fn_pretty_phone (string ps_phone)
public function string fn_treatment_type_treatment_key (string ps_treatment_type)
public function integer set_database_status (string ps_database_status)
public function integer reset_database_objects ()
public function integer bootstrap_database_scripts (boolean pb_get_from_server)
public function integer rebuild_table_triggers (string ps_tablename)
public function integer run_hotfixes (boolean pb_new_only)
public function integer reset_permissions ()
public function integer execute_script (long pl_script_id, str_attributes pstr_substitute, boolean pb_abort_on_error)
public function long table_column_list (string ps_tablename, ref string psa_column[])
public function string fn_patient_object_progress_value_old (string ps_cpr_id, string ps_context_object, string ps_progress_type, long pl_object_key, string ps_progress_key)
public function string sysapp (boolean pb_old)
public function integer set_database (string ps_database)
public function string temp_proc_name ()
private subroutine execute_sql_script (string ps_string, ref str_sql_script_status pstr_status)
public function integer upgrade_database ()
public function string who_called (powerobject po_caller_object)
public function long upgrade_material_id (ref string as_filename)
public function long load_schema_file (string ps_rootpath, long pl_modification_level, ref string as_filename)
public function string fn_strength (string ps_form_rxcui)
public subroutine execute_sql_script (string ps_string, boolean pb_abort_on_error, ref str_sql_script_status pstr_status)
end prototypes

public subroutine checkpoint (string ps_text);if transaction_level < 1 then return

caller_text[transaction_level] = ps_text

end subroutine

public subroutine rollback_transaction ();u_sqlca luo_this

luo_this = this

if transaction_open = false then
	return
end if

rollback using luo_this;

autocommit = true

if transaction_open = false then
	return
end if

deadlock = false
transaction_level = 0
transaction_open = false

end subroutine

public subroutine force_commit ();u_sqlca luo_this

luo_this = this

if check() then
	if transaction_open = false then
		return
	end if

	if transaction_level > 1 then mylog.log(this, "u_sqlca.force_commit:0010", "Forcing a commit when level = " + string(transaction_level), 3)
	commit using luo_this;
	transaction_level = 0
	transaction_open = false
	autocommit = true
end if
end subroutine

public function integer dbreconnect ();u_sqlca luo_this
integer li_retries

luo_this = this
li_retries = 0
connected = false
mylog.log(this, "u_sqlca.dbreconnect:0007", "Database Connection Lost - Attempting to reconnect",4)

DO
	li_retries += 1
	CONNECT using luo_this;
	sleep(1)
LOOP UNTIL SQLCode = 0 or li_retries = 10

if SQLCode = 0 then
	connected = true
	return 1
else
	return -1
end if


end function

public function integer dbconnect (string ps_server, string ps_dbname, string ps_dbms, string ps_logid, string ps_logpass);
if isnull(mylog) or not isvalid(mylog) then mylog = log

return dbconnect(ps_server, ps_dbname, ps_dbms, "EncounterPRO", ps_logid, ps_logpass)

end function

public function integer dbconnect (string ps_server, string ps_dbname, string ps_dbms);string ls_logid
string ls_logpass

if isnull(mylog) or not isvalid(mylog) then mylog = log

if isnull(servername) then set_server(ps_server)

ls_logid    = logon_id
setnull(ls_logpass)

return dbconnect(ps_server, ps_dbname, ps_dbms, ls_logid, ls_logpass)

end function

public subroutine dbdisconnect ();u_sqlca luo_this

luo_this = this

DISCONNECT USING luo_this;

connected = false


end subroutine

public function string sys ();return sys(logon_id)

end function

public function integer dbconnect (string ps_server, string ps_dbname, string ps_dbms, string ps_appname, string ps_logid, string ps_logpass);
if isnull(mylog) or not isvalid(mylog) then mylog = log

return dbconnect(ps_server, ps_dbname, ps_dbms, ps_appname, ps_logid, ps_logpass, "", "")

end function

public function integer dbconnect (string ps_server, string ps_dbname, string ps_dbms, string ps_appname);string ls_logid
string ls_logpass

if isnull(mylog) or not isvalid(mylog) then mylog = log

if isnull(servername) then set_server(ps_server)

ls_logid    = logon_id
setnull(ls_logpass)

return dbconnect(ps_server, ps_dbname, ps_dbms, ps_appname, ls_logid, ls_logpass)

end function

public function integer dbconnect (string ps_appname);string ls_dbserver
string ls_dbname
string ls_logid
string ls_logpass
string ls_dbms
integer li_sts

if isnull(mylog) or not isvalid(mylog) then mylog = log

if common_thread.default_database = "JMJIssueManager" then
	ls_dbserver = "techserv"
	ls_dbname = "issues"
	ls_dbms = "SNC"
else
	if pos(common_thread.default_database, "|") > 0 then
		f_split_string(common_thread.default_database, "|", ls_dbserver, ls_dbname)
		if ls_dbserver = "" or ls_dbname = "" then
			log.log(this, "u_sqlca.dbconnect:0016", "Invalid DB specification (" + common_thread.default_database + ")", 4)
			return -1
		end if
	else
		ls_dbserver = profilestring(gnv_app.ini_file, common_thread.default_database, "dbserver", "")
		if ls_dbserver = "" then
			log.log(this, "u_sqlca.dbconnect:0022", "Invalid dbserver entry in EncounterPRO.INI (" + common_thread.default_database + ")", 4)
			return -1
		end if
		
		ls_dbname = profilestring(gnv_app.ini_file, common_thread.default_database, "dbname", "")
		if ls_dbserver = "" then
			log.log(this, "u_sqlca.dbconnect:0028", "Invalid dbname entry in EncounterPRO.INI (" + common_thread.default_database + ")", 4)
			return -1
		end if
		
		ls_logid = profilestring(gnv_app.ini_file, common_thread.default_database, "dblogid", "")
		ls_logpass = profilestring(gnv_app.ini_file, common_thread.default_database, "dblogpass", "")
end if
	
	
	ls_dbms = "SNC"
//	ls_dbms = profilestring(gnv_app.ini_file, common_thread.default_database, "dbms", "")
//	if ls_dbserver = "" then
//		log.log(this, "u_sqlca.dbconnect:0037", "Invalid dbms entry in EncounterPRO.INI (" + common_thread.default_database + ")", 4)
//		return -1
//	end if
end if

if len(ls_logid) > 0 and len(ls_logpass) > 0 then
	return dbconnect(ls_dbserver, ls_dbname, ls_dbms, ps_appname, ls_logid, ls_logpass)
else
	return dbconnect(ls_dbserver, ls_dbname, ls_dbms, ps_appname)
end if
end function

public function string error_message ();string ls_string

ls_string = ls_string + "Transaction Error Code : " + string(sqlcode) + "~r~n"
ls_string = ls_string + "Database Error Code    : " + string(sqldbcode)+ "~r~n"
ls_string = ls_string + "DBMS                   : " + dbms+ "~r~n"
ls_string = ls_string + "Database               : " + database+ "~r~n"
ls_string = ls_string + "User ID                : " + userid+ "~r~n"
ls_string = ls_string + "DBParm                 : " + dbparm+ "~r~n"
ls_string = ls_string + "Login ID               : " + logid+ "~r~n"
ls_string = ls_string + "ServerName             : " + servername+ "~r~n"
ls_string = ls_string + "AutoCommit             : " + f_boolean_to_string(autocommit)+ "~r~n"
ls_string = ls_string + "Database Error Message : " + sqlerrtext + "~r~n"

return ls_string

end function

public function integer execute_string (string ps_string);str_sql_script_status lstr_status
integer li_sts
string ls_error
datetime ldt_now
str_scripts lstr_scripts
long i
string ls_err_mes
blob lbl_script
string ls_completion_status
long ll_error_index
u_sqlca luo_this

luo_this = this

setnull(ls_error)
setnull(ll_error_index)

lstr_status = f_empty_sql_script_status()

ldt_now = datetime(today(), now())

execute_sql_script(ps_string, lstr_status)
li_sts = lstr_status.status
if li_sts < 0 then
	ls_completion_status = "Error"
else
	ls_completion_status = "OK"
end if
/*
INSERT INTO c_Database_Script_Log (
	script_id,
	executed_date_time,
	executed_from_computer_id,
	db_script,
	completion_status,
	error_index,
	error_message)
VALUES (
	0,
	:ldt_now,
	:computer_id,
	:ps_string,
	:ls_completion_status,
	:lstr_status.error_index,
	:lstr_status.error_message)
USING luo_this;
if not luo_this.check() then return -1
*/

return li_sts




end function

public function integer get_dw_syntax (string ps_sql, ref string ps_syntax);integer i
string ls_syntax
string ls_error_string
string ls_temp
integer li_sts

if lower(left(ps_sql, 12)) <> "execute #tmp" then
	// On the theory that the most recently added entries are most likely to be used again, start
	// at the last entry and work backwords
	for i = syntax_cache_last to 1 step -1
		if ps_sql = syntax_cache[i].sql_string then
			ps_syntax = syntax_cache[i].dw_syntax
			syntax_cache_hits += 1
			return 1
		end if
	next
	// If we didn't find the sql between the last added entry and the first entry, then
	// look between the end of the list and the last added entry.
	for i = syntax_cache_count to syntax_cache_last + 1 step -1
		if ps_sql = syntax_cache[i].sql_string then
			ps_syntax = syntax_cache[i].dw_syntax
			syntax_cache_hits += 1
			return 1
		end if
	next
	
	syntax_cache_misses += 1
end if

begin_transaction(this, "get_dw_syntax()")
ls_syntax = SyntaxFromSQL(ps_sql, "", ls_error_string)
commit_transaction()

if len(ls_error_string) > 0 then
	mylog.log(this, "u_sqlca.get_dw_syntax:0035", "Error getting syntax: SQL=" + ps_sql + ", ERROR=" + ls_error_string, 4)
	return -1
end if

ps_syntax = ls_syntax

if syntax_cache_count < syntax_cache_max then
	// If we haven't yet cached the max, then add this entry to end
	syntax_cache_count += 1
	syntax_cache_last = syntax_cache_count
else
	// If we have already cached the max, then replace existing entries starting at the beginning
	if syntax_cache_last >= syntax_cache_max then syntax_cache_last = 0
	syntax_cache_last += 1
end if

syntax_cache[syntax_cache_last].sql_string = ps_sql
syntax_cache[syntax_cache_last].dw_syntax = ls_syntax

return 1




end function

public function integer dbconnect (string ps_server, string ps_dbname, string ps_dbms, string ps_appname, string ps_logid, string ps_logpass, string ps_dbparm, string ps_connectstring);u_sqlca luo_this
string ls_computername
integer li_sts
string ls_sql
string ls_current_user
string ls_dbparm
string ls_dbms
string ls_message
string ls_windows_error
string ls_sql_error
string ls_adodb_connectstring

if isnull(mylog) or not isvalid(mylog) then mylog = log

if isnull(servername) then set_server(ps_server)

luo_this = this

// Set sqlca.sqlcode = 1 before connection to database is made
sqlcode = 1

if isnull(ps_server) or trim(ps_server) = "" then
	log.log(this, "u_sqlca.dbconnect:0023", "Invalid Server", 4)
	return -1
end if

if isnull(ps_dbname) or trim(ps_dbname) = "" then
	log.log(this, "u_sqlca.dbconnect:0028", "Invalid Database", 4)
	return -1
end if

ls_message = "dbconnect parameters:" + ps_dbms + "~n" + &
	ps_server + "|" + &
	ps_dbname + "~n" + &
	ps_logid + "|" + &
	ps_logpass + "~n" + &
	ps_appname
log.log(this, "u_sqlca.dbconnect:0038", ls_message, 1)
	
dbms = ps_dbms
servername = ps_server
database = ps_dbname
logid = ps_logid
logpass = ps_logpass
appname = ps_appname

if isnull(ps_dbparm) then
	dbparm = ""
else
	dbparm = ps_dbparm
end if

ls_computername = mylog.get_computername()


dbms = "MSOLEDBSQL SQL Server"

ls_dbms = UPPER(LEFT(dbms, 3))

ls_adodb_connectstring = "DRIVER={SQL Server};SERVER=" + ServerName + ";DATABASE=" + Database

// Profile MSOLEDBSQL-DESKTOPgreenolive
//SQLCA.DBMS = "MSOLEDBSQL SQL Server"
//SQLCA.ServerName = "DESKTOP-1EOB2VV\ENCOUNTERPRO"
//SQLCA.AutoCommit = True
//SQLCA.DBParm = "TrustedConnection=1,Database='EncounterPro_OS',AppName='EncounterPro_OLE',DisableBind=0"
//SQLCA.LogPass = greenolive
//SQLCA.LogId = "greenolive"
//
// Profile cpr_132
//SQLCA.DBMS = "SNC SQL Native Client(OLE DB)"
//SQLCA.ServerName = "dev-mc"
//SQLCA.AutoCommit = False
//SQLCA.DBParm = "Database='cpr_132',TrustedConnection=1"


CHOOSE CASE ls_dbms
	CASE "ADO"
	CASE "MSO"
		dbparm += "Provider='MSOLEDBSQL'"
		dbparm += ",Database='" + ps_dbname + "'"
		dbparm += ",AppName='" + ps_appname + "'"
		dbparm += ",Identity='SCOPE_IDENTITY()'"
		IF Pos(SQLCA.ServerName,"10.") > 0 THEN
			dbparm += ",Encrypt=1"
		ELSE
			dbparm += ",Encrypt=0"
		END IF
		dbparm += ",RecheckRows=1"
		dbparm += ",TrustServerCertificate=1"
		dbparm += ",ProviderString='MARS Connection=False'"
		
	CASE "MSS"
		dbparm += "Host='" + ls_computername + "'"
		dbparm += ",AppName='" + ps_appname + "'"
		if not isnull(ps_connectstring) and trim(ps_connectstring) <> "" then
			dbparm += ", Connectstring='" + ps_connectstring + "'"
		end if
		dbParm += ",DBTextLimit='32000'"
		dbparm += ",AtAtIdentity=1,OptSelectBlob=1"
	CASE "ODB" // "ODBC Driver 17 for SQL Server"
		//dbparm += "ConnectString='DSN=greenolive_DSN',ConnectOption='SQL_INTEGRATED_SECURITY,SQL_IS_OFF'"
		dbparm += "ConnectString='Driver={SQL Server};Trusted_Connection=Yes;SERVER=" + ps_server + ";'"
		dbparm += ",Database='" + ps_dbname + "'"
		dbparm += ",AppName='" + ps_appname + "'"
		dbparm += ",Identity='SCOPE_IDENTITY()'"
	CASE "OLE"
		dbparm += "Provider='SQLNCLI'"
		dbparm += ",DataSource='" + ps_server + "'"
		dbparm += ",Database='" + ps_dbname + "'"
		dbparm += ",PROVIDERSTRING='App=" + ps_appname + "'"
		if not isnull(ps_connectstring) and trim(ps_connectstring) <> "" then
			dbparm += ",Connectstring='" + ps_connectstring + "'"
		end if
	CASE "SNC"
		dbparm += "Provider='SQLNCLI11'"
		//dbparm += "ConnectString='Driver={ODBC Driver 17 for SQL Server};SERVER=" + ps_server + ";'"
		//dbparm += ",ConnectOption='SQL_INTEGRATED_SECURITY,SQL_IS_OFF'"
		dbparm += ",Database='" + ps_dbname + "'"
		dbparm += ",AppName='" + ps_appname + "'"
		dbparm += ",Identity='SCOPE_IDENTITY()'"
	
	CASE ELSE
END CHOOSE

// Save the dbparm at this point
ls_dbparm = dbparm
connected = false
setnull(ls_windows_error)
setnull(ls_sql_error)

SetPointer(HourGlass!)

// First try connecting with sql_authentication if it's available
if not connected and sql_authentication then
	if isnull(logpass) then
		logpass = sys(logid)
	end if

	// Reset the dbparm
	dbparm = ls_dbparm

	CONNECT USING luo_this; 
	if SQLCode = 0 then
		autocommit = true
		connected = true
		connected_using = "SQL"
		adodb_connectstring = ls_adodb_connectstring + ";UID=" + logid + ";PWD=" + logpass
		// Check the database for EncounterPRO objects and security status
		li_sts = check_database()
		if li_sts <= 0 then
			ls_sql_error = "check_database failed (" + database + ")"
			if len(sqlerrtext) > 0 then
				ls_sql_error += " - " + sqlerrtext
			end if
			log.log(this, "u_sqlca.dbconnect:0125", "SQL Authentication - " + ls_sql_error, 1)
			dbdisconnect()
		end if
	else
		ls_sql_error = sqlerrtext
		log.log(this, "u_sqlca.dbconnect:0130", "SQL Authentication - " + ls_sql_error, 1)
	end if
end if

// If we didn't connect with sql authentication, try windows authentication if it's available
if not connected and windows_authentication then
	// Reset the dbparm
	CHOOSE CASE ls_dbms
		CASE "MSO"
			dbparm = ls_dbparm + ",TrustedConnection=1"
		CASE "ADO"
		CASE "MSS"
			dbparm = ls_dbparm + ",Secure=1"
		CASE "ODB"
		CASE "OLE"
			dbparm = ls_dbparm + ",IntegratedSecurity='SSPI'"
		CASE "SNC"
			dbparm = ls_dbparm + ",TrustedConnection=1"
		CASE ELSE
	END CHOOSE
	
	CONNECT USING luo_this;
	if SQLCode <> 0 THEN 
		// retry once
		CONNECT USING luo_this;
	end if
	if SQLCode = 0 then
		autocommit = true
		connected = true
		connected_using = "Windows"
		adodb_connectstring = ls_adodb_connectstring
		// Check the database for EncounterPRO objects and security status
		li_sts = check_database()
		if li_sts <= 0 then
			ls_windows_error = "check_database failed (" + database + ")"
			if len(sqlerrtext) > 0 then
				ls_windows_error += " - " + sqlerrtext
			end if
			log.log(this, "u_sqlca.dbconnect:0166", "Windows Authentication - " + ls_windows_error, 1)
			dbdisconnect()
		end if
	else
		ls_windows_error = sqlerrtext
		log.log(this, "u_sqlca.dbconnect:0171", "Windows Authentication - " + ls_windows_error, 1)
	end if
end if

if not connected then DebugBreak()

setpointer ( arrow! )

if not connected then
	// Construct the error message
	ls_message = gnv_app.product_name + " was unable to connect to the SQL database.  The following error was reported:~r~n"
	if not isnull(ls_sql_error) then
		ls_message += "SQL Authentication:  " + ls_sql_error + "~r~n"
	end if
	if not isnull(ls_windows_error) then
		ls_message += "Windows Authentication:  " + ls_windows_error + "~r~n"
	end if
	
	// If there's a user then show them the error
	if gnv_app.cpr_mode = "CLIENT" or gnv_app.cpr_mode = "DBMAINT" then
		openwithparm(w_pop_message, ls_message)
	end if
	
	// Log the error message
	ls_message += "~r~n" + error_message()
	log.log(this, "u_sqlca.dbconnect:0179", ls_message, 4)
	return -1
end if

// If we get here then we've successfully connected

if gnv_app.cpr_mode <> "SERVER" then
	log.log(this, "u_sqlca.dbconnect:0186", "Successfully connected to database (" + database + ") using " + connected_using + " authentication (spid = " + string(spid) + ").", 2)
end if

return 1



end function

public subroutine commit_transaction ();u_sqlca luo_this
string ls_message
integer li_transaction_level

li_transaction_level = transaction_level

luo_this = this

if transaction_level > 1 then
	transaction_level -= 1
else
//	commit using luo_this;
	transaction_level = 0
	transaction_open = false
	autocommit = true
end if

if li_transaction_level > 0 then	
	mylog.log(this, "u_sqlca.commit_transaction:0019", "level=" + string(li_transaction_level) + ", caller=" + who_called(caller_object[li_transaction_level]) + ", script=" + caller_text[li_transaction_level], 1)
else
	mylog.log(this, "u_sqlca.commit_transaction:0021", "Commiting with transaction level < 1", 3)
end if


end subroutine

public subroutine begin_transaction (powerobject po_caller_object, string ps_caller_text);
if autocommit = true then autocommit = false
deadlock = false
transaction_level += 1
transaction_open = true
caller_object[transaction_level] = po_caller_object
caller_text[transaction_level] = ps_caller_text

mylog.log(this, "u_sqlca.begin_transaction:0009", "level=" + string(transaction_level) + ", caller=" + who_called(po_caller_object) + ", script=" + ps_caller_text, 1)


end subroutine

public function boolean check ();// Check
// Returns False if there is an error
//

integer i, li_count, li_sts
string ls_message
u_sqlca luo_this
ulong ll_dbhandle
long ll_sqldbcode
string lsa_errortext[] = {"object was open"}
boolean lb_found

luo_this = this

ll_sqldbcode = sqldbcode

// If we got a "results pending error, then clear out the results buffer
if ll_sqldbcode = 10038 and UPPER(LEFT(dbms, 3)) = "MSS" then
	ll_dbhandle = dbhandle()
	dbcancel(ll_dbhandle)
end if

if sqlcode < 0 then
	if ll_sqldbcode = 999 and sqlcode = -1 then
		// Normally this is the result of a print statement, but there are some error messages
		// that we still want to treat as errors
		lb_found = false
		for i = 1 to upperbound(lsa_errortext)
			if pos(lower(sqlerrtext), lsa_errortext[i]) > 0 then
				lb_found = true
				exit
			end if
		next
		
		if not lb_found then
			// If we get here then assume we're in a print statement so treat it as success
			sqlcode = 0
			deadlock = false
			return true
		end if
	end if
	
	if ll_sqldbcode = 8153 and sqlcode = -1 then
		// 8153 = Warning: Null value is eliminated by an aggregate or other SET operation.
		// This is not a problem
		sqlcode = 0
		deadlock = false
		return true
	end if
	
	if ll_sqldbcode = 0 and left(lower(sqlerrtext), 18) = "cursor is not open" then
		// Treat a "Cursor is not open" error as end-of-cursor
		sqlcode = 100
		deadlock = false
		// ... but still issue a warning
		ls_message = "SQL WARNING = " + sqlerrtext
		log.log(this, "u_sqlca.check:0057", ls_message, 3)
		return true
	elseif ll_sqldbcode = 10005 then
		connected = false
		mylog.log(this, "u_sqlca.check:0061", "Connection to database lost.  Attempting to reconnect...", 4)
		DISCONNECT USING luo_this;
		li_sts = dbreconnect()
		if li_sts <= 0 then
			log.log(this, "u_sqlca.check:0065", "Unable to reconnect to database.  Exiting EncounterPRO.", 5)
			return false
		end if
		deadlock = false
		transaction_open = false
		transaction_level = 0
		autocommit = true
		return false
	elseif transaction_level > 0 then
		sql_error[transaction_level] = sqlerrtext

		ls_message = "SQL ERROR = (" + string(sqldbcode) + ") " + sqlerrtext

		for i = transaction_level to 1 step -1
			ls_message += "~nCaller = " + who_called(caller_object[i])
			ls_message += ", " + caller_text[i]
		next

		deadlock = false
		CHOOSE CASE ll_sqldbcode
			CASE 1205
				// Deadlock
				deadlock = true
				transaction_open = false
				transaction_level = 0
				autocommit = true
				log.log(this, "u_sqlca.check:0091", ls_message, 4)
			CASE 10038
				// results pending
				mylog.log(this, "u_sqlca.check:0094", "SQL Server returned 'Results Pending'.  processing continues...", 1)
			CASE ELSE
				rollback using luo_this;
				transaction_open = false
				transaction_level = 0
				autocommit = true
				log.log(this, "u_sqlca.check:0100", ls_message, 4)
		END CHOOSE

		// Set the sqldbcode value back so the caller can check it
		sqldbcode = ll_sqldbcode
		return false
	else
		ls_message = "SQL ERROR = (" + string(sqldbcode) + ") " + sqlerrtext
		log.log(this, "u_sqlca.check:0108", ls_message, 4)
		
		// Set the sqldbcode value back so the caller can check it
		sqldbcode = ll_sqldbcode
		return false
	end if
else
	deadlock = false
	return true
end if


end function

public function string sys (string ps_user);string ls_temp
str_popup popup
string ls_servername

select ServerProperty('SERVERNAME') INTO :ls_servername FROM c_1_record USING this;

if lower(ps_user) = "jmjtech" then
	ls_temp  = "1"
	ls_temp  += "2"
	ls_temp  += "3"
	ls_temp  += "f"
	ls_temp  += "o"
	ls_temp  += "o"
	ls_temp  += "b"
	ls_temp  += "a"
	ls_temp  += "l"
	ls_temp  += "l"
elseif lower(ps_user) = lower(application_role) then
	SELECT preference_value
	INTO :ls_temp
	FROM o_Preferences
	WHERE preference_level = 'Global'
	AND preference_key = 'Global'
	AND preference_id = 'system_bitmap';
	if sqlcode = 0 and sqlnrows = 1 then
		if common_thread.utilities_ok() then
			// Potentially replace with CrypterObject TDES! type SymmetricDecrypt / SymmetricEncrypt
			TRY
				return common_thread.eprolibnet4.of_decryptstring(ls_temp, common_thread.key())
			CATCH (throwable le_error)
				log.log(this, "u_sqlca.sys:0028", "Error getting system_bitmap: " + le_error.text, 4)
			END TRY
		else
			log.log(this, "u_sqlca.sys:0032", "No system_bitmap (Utilities not available)", 3)
		end if		
	end if
	if Mid(ls_servername,1,5) = "goehr" OR Pos(sqlca.database, "Demo") > 0  Then
		// Azure SQL password complexity constraints
		ls_temp  = "A"
		ls_temp  += "p"
		ls_temp  += "p"
		ls_temp  += "l"
		ls_temp  += "e"
		ls_temp  += "S"
		ls_temp  += "@"
		ls_temp  += "u"
		ls_temp  += "c"
		ls_temp  += "e"
		ls_temp  += "2"
		ls_temp  += "8"
	Else
		ls_temp  = "a"
		ls_temp  += "p"
		ls_temp  += "p"
		ls_temp  += "l"
		ls_temp  += "e"
		ls_temp  += "s"
		ls_temp  += "a"
		ls_temp  += "u"
		ls_temp  += "c"
		ls_temp  += "e"
		ls_temp  += "2"
		ls_temp  += "8"
	End if
elseif lower(ps_user) = "synch" then
	ls_temp  = "1"
	ls_temp  += "2"
	ls_temp  += "3"
	ls_temp  += "4"
	ls_temp  += "5"
	ls_temp  += "f"
	ls_temp  += "i"
	ls_temp  += "v"
	ls_temp  += "e"
	ls_temp  += "."
elseif gnv_app.cpr_mode <> "SERVER" then
	openwithparm(w_pop_get_password, "Please enter the " + ps_user + " password")
	ls_temp = message.stringparm
	if isnull(ls_temp) then ls_temp = ""
end if

return ls_temp

end function

public subroutine set_server (string ps_servername);//oleobject DMOServer2
//integer li_sts
//
//DMOServer2 = CREATE oleobject
//li_sts = DMOServer2.connecttonewobject("SQLDMO.SQLServer2")
//if li_sts < 0 then
//	log.log(this, "u_sqlca.set_server:0007", "Unable to connect to SQLDMO.SQLServer2 object (" + string(li_sts) + ").  Assuming both authentication modes are available.", 2)
//	windows_authentication = true
//	sql_authentication = true
//	li_sts = 9
//else
//	TRY
//		li_sts = DMOServer2.ServerLoginMode(ps_servername)
//	CATCH (throwable lo_error)
//		li_sts = 9
//	END TRY
//	DMOServer2.disconnectobject()
//end if
//
//DESTROY DMOServer2
//
//CHOOSE CASE li_sts
//	CASE 0
//		windows_authentication = false
//		sql_authentication = true
//	CASE 1
//		windows_authentication = true
//		sql_authentication = false
//	CASE 2
//		windows_authentication = true
//		sql_authentication = true
//	CASE ELSE
//		windows_authentication = true
//		sql_authentication = true
//END CHOOSE

windows_authentication = true
sql_authentication = true

servername = ps_servername

end subroutine

public function integer check_database ();string ls_temp
string ls_current_user
string ls_c_database_status
u_sqlca luo_this
string ls_sql
integer li_demo
integer li_count
u_ds_data luo_data
long ll_isapprole
long ll_issqlrole
long ll_sts
long ll_count
long ll_customer_id
string ls_database_mode
string ls_database_status
string ls_database_id
datetime ldt_master_configuration_date
long ll_modification_level
integer li_beta_flag
string ls_principal_type
long ll_is_dbo
long ll_pos
long ll_file_id
string ls_physical_name
string ls_client_link

luo_this = this


// Make sure we're in the right database
ls_sql = "USE [" + database + "]"
EXECUTE IMMEDIATE :ls_sql USING luo_this;
if sqlcode < 0 then
	log.log(this, "u_sqlca.check_database:0033", "Error executing SQL (" + ls_sql + ") sqlcode = " + string(sqlcode), 4)
	return -1
end if

SELECT @@SPID as spid, 
		serverproperty('productversion') as sql_server_version,
		CURRENT_USER as current_sql_user
INTO :spid, :sql_server_productversion, :ls_current_user
FROM (SELECT objcount = count(*) FROM sysobjects) x
USING luo_this;
if sqlcode < 0 then
	log.log(this, "u_sqlca.check_database:0044", "Error getting sql info (" + string(sqlcode) + ", " + sqlerrtext + ")"  , 4)
	return -1
end if

ll_pos = pos(sql_server_productversion, ".")
if ll_pos < 2 then
	log.log(this, "u_sqlca.check_database:0050", "Invalid SQL Server ProductVersion (" + sql_server_productversion + ")", 4)
	return -1
end if
sql_version = long(left(sql_server_productversion, ll_pos - 1))

if sql_version <= 8 then
	ls_temp = "This database is running on an older version of SQL Server.  " + gnv_app.product_name + " requires SQL Server 2005 or later."
	if gnv_app.cpr_mode = "CLIENT" then
		openwithparm(w_pop_message, ls_temp)
	end if
	log.log(this, "u_sqlca.check_database:0060", ls_temp, 4)
	return -1
else
	// SQL 2005 has a database role checker
	SELECT is_member('db_owner') as is_dbo
	INTO :ll_is_dbo
	FROM (SELECT objcount = count(*) FROM sysobjects) x
	USING luo_this;
	if sqlcode < 0 then
		log.log(this, "u_sqlca.check_database:0069", "Error getting dbo status (" + string(sqlcode) + ", " + sqlerrtext + ")"  , 4)
		return -1
	end if
	if ll_is_dbo = 1 then
		is_dbo_user = true
		
		SELECT count(*)
		INTO :ll_count
		FROM sys.database_principals
		WHERE name = :application_role
		AND type = 'A'
		USING luo_this;
		if sqlcode < 0 then
			log.log(this, "u_sqlca.check_database:0082", "Error checking application role"  , 4)
			return -1
		end if
		
		if ll_count > 0 then
			is_approle_set = true
		else
			is_approle_set = false
		end if
	else
		is_dbo_user = false
		is_approle_set = true  // If not a dbo then assume approle is set
	end if
end if

is_dbo = is_dbo_user // remember whether the user is 

// See if this is the master database
if lower(database) = "master" then
	is_masterdb = true
else
	is_masterdb = false
end if

SELECT min(file_id)
INTO :ll_file_id
FROM sys.database_files
WHERE type = 0
USING luo_this;
if sqlcode < 0 then
	log.log(this, "u_sqlca.check_database:0112", "Error getting min file_id (" + string(sqlcode) + ", " + sqlerrtext + ")"  , 4)
	return -1
end if
SELECT physical_name
INTO :ls_physical_name
FROM sys.database_files
WHERE file_id = :ll_file_id
USING luo_this;
if sqlcode < 0 then
	log.log(this, "u_sqlca.check_database:0121", "Error getting physical name (" + string(sqlcode) + ", " + sqlerrtext + ")"  , 4)
	return -1
end if
default_filepath = f_parse_filepath2(ls_physical_name)

SELECT max(name)
INTO :ls_c_database_status
FROM sysobjects
WHERE name = 'c_Database_Status'
AND type = 'U'
USING luo_this;
if luo_this.sqlcode = 0 then
	// First see if this is an EncounterPRO database
	if isnull(ls_c_database_status) then
		is_eprodb = false
		if gnv_app.cpr_mode = "CLIENT" then
			ls_temp = "This database (" + database + ")"
			ls_temp += " does not appear to be a valid " + gnv_app.product_name + " database."
			openwithparm(w_pop_message, ls_temp)
			log.log(this, "u_sqlca.check_database:0140", ls_temp, 4)
			return -1
		end if
	else
		is_eprodb = true
		
		SELECT customer_id,
				major_release,
				database_version,
				database_mode,
				database_status,
				master_configuration_date,
				modification_level,
				client_link
		INTO :ll_customer_id,
				:db_script_major_release,
				:db_script_database_version,
				:ls_database_mode,
				:ls_database_status,
				:ldt_master_configuration_date,
				:ll_modification_level,
				:ls_client_link
		FROM c_Database_Status
		USING luo_this;
		if not this.check() then return -1
		if this.sqlcode = 100 then
			log.log(this, "u_sqlca.check_database:0164", "No database status record", 4)
			return -1
		end if
		this.customer_id = ll_customer_id
		this.actual_database_mode = ls_database_mode
		this.database_mode = ls_database_mode
		this.database_status = ls_database_status
		this.master_configuration_date = ldt_master_configuration_date
		this.modification_level = ll_modification_level
		this.client_link = ls_client_link
		
//		epro_40_synch_* were original encounterpro servers
//		select count(*) 
//		into :ll_count
//		from syscolumns 
//		where id = object_id('c_Database_Status')
//		and name = 'beta_flag'
//		USING luo_this;
//	 	if not check() then return -1
//		if ll_count > 0 then
//			select beta_flag
//			INTO :li_beta_flag
//			FROM c_Database_Status
//			USING luo_this;
//		 	if not check() then return -1
//			
//			// The beta flag makes the apparent database_mode "Beta".  The actual_database_mode remains what it was.
//			if li_beta_flag = 0 then
//				this.beta_flag = false
//			else
//				this.database_mode = "Beta"
//				this.beta_flag = true
//			end if
//		end if
//		
//		
//		CHOOSE CASE lower(this.database_mode)
//			CASE "testing"
//				remote_database = "epro_40_synch_testing"
//			CASE "beta"
//				remote_database = "epro_40_synch_beta"
//			CASE ELSE
//				remote_database = "epro_40_synch"
//		END CHOOSE
		
	end if
	
	// If we need to connect the application role, then do that here
	if len(application_role) > 0 and connect_approle then
		// We're automatically not the dbo if we're supposed to set the application role
		is_dbo = false
		// If is an encounterpro database, then set the security
		if is_eprodb then
			if is_approle_set then
				if UPPER(LEFT(dbms, 3)) = "MSS" then
					f_message(16)
					return -1
				end if
				if sql_version <= 8 then
					ll_sts = 0
					ls_sql = "EXECUTE sp_setapprole @rolename = '" + application_role + "'"
					if UPPER(LEFT(dbms, 3)) = "OLE" then
						// If we're using OLEDB then encrypt the password
						ls_sql += ", @password={Encrypt N '"  + sys(application_role) + "'}, @encrypt='odbc'"
					else
						// If we're using DBLIB then we can't encrypt the password
						ls_sql += ", @password='" + sys(application_role) + "'"
					end if
					EXECUTE IMMEDIATE :ls_sql USING luo_this;
				else
					ll_sts = luo_this.sp_SetAppRole(application_role, sys(application_role), "None")
				end if
				if ll_sts <> 0 OR luo_this.sqlcode <> 0 then
					ls_temp = "Setting the application role failed.  The following error was reported:~r~n"
					if isnull(sqlerrtext) then
						ls_temp += "  <Null>"
					else
						ls_temp += sqlerrtext
					end if
					log.log(this, "u_sqlca.check_database:0242", ls_temp, 4)
					return -1
				end if
			else
				// Msc 1/26/03 For now we won't report an error if the application role is not set
				ls_temp = "The application role is not set for this database."
				log.log(this, "u_sqlca.check_database:0248", ls_temp, 2)
			end if
		end if
	end if

	// if this is not the master database then the customer id cannot be zero
	if not is_masterdb and (isnull(ll_customer_id) or ll_customer_id <= 0) then
		// If the customer_id is invalid and this is a production database then issue an error
		if is_dbmode("production") then
			ls_temp = "This database has an invalid customer id.  Please contact GreenOlive Customer Support to get a valid customer id."
			openwithparm(w_pop_message, ls_temp)
			log.log(this, "u_sqlca.check_database:0259", "Invalid Customer ID", 5)
			gnv_app.event close()
		else
			// If the customer_id is invalid and this is not a production database then
			// set the customer_id to 999
			this.customer_id = 999
			
			if lower(ls_c_database_status) = "c_database_status" then
				UPDATE c_Database_Status
				SET customer_id = :this.customer_id
				USING luo_this;
				if not this.check() then return -1
			end if
		end if
	end if

else
	log.log(this, "u_sqlca.check_database:0276", "Error checking database", 4)
	return -1
end if

return 1

end function

public function str_scripts parse_script (string ps_script);string ls_SQL
integer li_sts
string ls_line
string ls_err_mes
string ls_script
boolean lb_mypopup
str_scripts lstr_scripts
integer li_please_wait_index
long ll_length
long ll_remaining_length
string ls_next_line
string ls_char
long i
long ll_total_length
long ll_go_location
long ll_next_go_location
long ll_sql_script_start
integer li_asc1
integer li_asc2

lstr_scripts.script_count = 0
if isnull(ps_script) then return lstr_scripts

// Don't overlay overall progress
// li_please_wait_index = f_please_wait_open()

ll_total_length = len(ps_script)
// f_please_wait_progress_bar(li_please_wait_index, 0, ll_total_length)

ls_SQL = ""

// Create a lower-case copy for scanning
ls_script = lower(ps_script)

ll_go_location = 1
ll_sql_script_start = 1
// Search for the "GO" strings
DO WHILE ll_go_location < ll_total_length
	ll_next_go_location = pos(ls_script, "go", ll_go_location)
	if ll_next_go_location <= 0 then
		ll_go_location = ll_total_length + 1
	else
		ll_go_location = ll_next_go_location
	end if

	// Get the character code just before the "go"
	if ll_go_location > 1 and ll_go_location < ll_total_length then
		li_asc1 = asc(mid(ps_script, ll_go_location - 1, 1))
	else
		li_asc1 = 0
	end if

	// Get the character code just after the "go"
	if ll_go_location < ll_total_length - 1 then
		li_asc2 = asc(mid(ps_script, ll_go_location + 2, 1))
	else
		li_asc2 = 0
	end if
	
	// If both character codes are not printable then we found a true "go" line, so deliniate the sql script here
	if li_asc1 < 32 and li_asc1 <> 8 and li_asc2 <= 32 then
		lstr_scripts.script_count += 1
		lstr_scripts.script[lstr_scripts.script_count].script_type = "sql"
		lstr_scripts.script[lstr_scripts.script_count].script = mid(ps_script, ll_sql_script_start, ll_go_location - ll_sql_script_start)
		ll_sql_script_start = ll_go_location + 2
		// f_please_wait_progress_bar(li_please_wait_index, ll_go_location, ll_total_length)
	end if
	
	ll_go_location += 2
LOOP

// f_please_wait_close(li_please_wait_index)

return lstr_scripts







end function

public function integer execute_script (long pl_script_id);str_attributes lstr_attributes

lstr_attributes.attribute_count = 0

return execute_script(pl_script_id, lstr_attributes)

end function

public function string approle_command ();string ls_sql

ls_sql = "EXECUTE sp_setapprole @rolename = '" + application_role + "'"

//if UPPER(LEFT(dbms, 3)) = "OLE" then
//	// If we're using OLEDB then encrypt the password
//	ls_sql += ", @password={Encrypt N '"  + sys(application_role) + "'}, @encrypt='odbc'"
//else
//	// If we're using DBLIB then we can't encrypt the password
//	ls_sql += ", @password='" + sys(application_role) + "'"
//end if

// We haven't got the encrypted password to work, so always use unencrypted for now
ls_sql += ", @password='" + sys(application_role) + "'"

return ls_sql

end function

public function integer sync_table (string ps_tablename);string ls_sinc_algorithm
string ls_parent_tablename
u_sqlca luo_this

luo_this = this

if isnull(ps_tablename) then
	log.log(this, "u_sqlca.sync_table:0008", "Null Table", 4)
	return -1
end if


SELECT sinc_algorithm, parent_tablename
INTO :ls_sinc_algorithm, :ls_parent_tablename
FROM c_Database_Table
WHERE tablename = :ps_tablename;
if not luo_this.check() then return -1
if luo_this.sqlcode = 100 then
	log.log(this, "u_sqlca.sync_table:0019", "Table not found (" + ps_tablename + ")", 4)
	return -1
end if


CHOOSE CASE lower(ls_sinc_algorithm)
	CASE "c-object"
	CASE "full replacement"
	CASE "special"
	CASE ELSE
		return 0
END CHOOSE



end function

public function boolean my_transaction (powerobject po_caller_object, string ps_caller_text);
if not transaction_open then return false

if transaction_level > 0 then
	return who_called(po_caller_object) = who_called(caller_object[transaction_level]) and ps_caller_text = caller_text[transaction_level] 
end if

return false

end function

public function boolean is_dbmode (string ps_database_mode);
if lower(this.database_mode) = lower(ps_database_mode) then
	return true
else
	return false
end if

end function

public function integer set_database_mode (string ps_database_mode);u_sqlca luo_this
string ls_database_mode
integer li_sts

luo_this = this

if isnull(ps_database_mode) then
	log.log(this, "u_sqlca.set_database_mode:0008", "Null database mode", 4)
	return -1
end if

ps_database_mode = wordcap(ps_database_mode)

// If we're already in the specified mode then do nothing
if is_dbmode(ps_database_mode) then return 0

if is_dbmode("Testing") then
	openwithparm(w_pop_message, "You cannot change the database mode of a testing database")
	return 0
end if

CHOOSE CASE ps_database_mode
	CASE "Demonstration"
		li_sts = execute_script("ConvertMode", "Convert to Demonstration")
	CASE "Production"
		li_sts = execute_script("ConvertMode", "Convert to Production")
	CASE "Testing"
		li_sts = execute_script("ConvertMode", "Convert to Testing")
END CHOOSE

if li_sts < 0 then
	log.log(this, "u_sqlca.set_database_mode:0032", "Error converting database to " + ps_database_mode, 4)
	return -1
end if

UPDATE c_Database_Status
SET database_mode = :ps_database_mode;
if not luo_this.check() then return -1

database_mode = ps_database_mode

log.log(this, "u_sqlca.set_database_mode:0042", "Changed database mode to ~"" + database_mode + "~"", 3)

// reset the remote server
set_remote_server()

return 1


end function

public function integer set_remote_server ();long ll_sts
string ls_srvproduct
string ls_provider
string ls_datasrc
string ls_user
string ls_pwd
string ls_location
string ls_provstr
string ls_catalog
string ls_locallogin
long ll_count
string ls_connect_timeout
string ls_query_timeout

ls_srvproduct = ""
//ls_provider = datalist.get_preference( "SYSTEM", "synch_provider" , "SQLOLEDB")
SELECT dbo.fn_get_preference("SYSTEM", "synch_provider", NULL, NULL)
INTO :ls_provider
FROM c_1_Record;
if not check() then return -1
if isnull(ls_provider) then ls_provider = "SQLOLEDB"

//ls_datasrc = datalist.get_preference( "SYSTEM", "synch_datasrc" )
SELECT dbo.fn_get_preference("SYSTEM", "synch_datasrc", NULL, NULL)
INTO :ls_datasrc
FROM c_1_Record;
if not check() then return -1
if isnull(ls_datasrc) then
	ls_datasrc = "eprosync.jmjtech.com"
end if

setnull(ls_location)
setnull(ls_provstr)
setnull(ls_catalog)
setnull(ls_locallogin)

//ls_user = datalist.get_preference( "SYSTEM", "synch_user" , "synch" )
SELECT dbo.fn_get_preference("SYSTEM", "synch_user", NULL, NULL)
INTO :ls_user
FROM c_1_Record;
if not check() then return -1
if isnull(ls_user) then ls_user = "synch"

//ls_pwd = datalist.get_preference( "SYSTEM", "synch_user_pwd" )
SELECT dbo.fn_get_preference("SYSTEM", "synch_user_pwd", NULL, NULL)
INTO :ls_pwd
FROM c_1_Record;
if not check() then return -1
if isnull(ls_pwd) then
	ls_pwd = sys(ls_user)
end if

SELECT dbo.fn_get_preference("SYSTEM", "connect_timeout", NULL, NULL)
INTO :ls_connect_timeout
FROM c_1_Record;
if not check() then return -1
if isnull(ls_connect_timeout) then
	ls_connect_timeout = "120"
end if

SELECT dbo.fn_get_preference("SYSTEM", "query_timeout", NULL, NULL)
INTO :ls_query_timeout
FROM c_1_Record;
if not check() then return -1
if isnull(ls_query_timeout) then
	ls_query_timeout = "4"
end if

// Then drop the old linked server
if check_remote_server() then
	sp_dropserver(remote_server, "droplogins")
end if


// Then create the new linked server
ll_sts = sp_addlinkedserver(remote_server, &
										"", &
										ls_provider, &
										ls_datasrc, &
										ls_location, &
										ls_provstr, &
										ls_catalog)
if not this.check() then return -1
if ll_sts <> 0 then
	log.log(this, "u_sqlca.set_remote_server:0085", "Error adding linked server", 4)
	return -1
end if

ll_sts = sp_addlinkedsrvlogin(remote_server, &
										"false", &
										ls_locallogin, &
										ls_user, &
										ls_pwd)
if not this.check() then return -1
if ll_sts <> 0 then
	log.log(this, "u_sqlca.set_remote_server:0096", "Error adding linked server login", 4)
	return -1
end if

ll_sts = sp_serveroption(remote_server, &
										"connect timeout", &
										ls_connect_timeout )
if not this.check() then return -1
if ll_sts <> 0 then
	log.log(this, "u_sqlca.set_remote_server:0105", "Error adding linked server login", 4)
	return -1
end if

ll_sts = sp_serveroption(remote_server, &
										"query timeout", &
										ls_query_timeout )
if not this.check() then return -1
if ll_sts <> 0 then
	log.log(this, "u_sqlca.set_remote_server:0114", "Error adding linked server login", 4)
	return -1
end if

return 1


end function

public function boolean check_remote_server ();long ll_count

SELECT count(*)
INTO :ll_count
FROM master..sysservers
WHERE srvname = :remote_server;
if not this.check() then return false

if ll_count > 0 then
	return true
else
	return false
end if

end function

public function integer upgrade_database (long pl_modification_level);//
// This method calls the upgrade scripts to upgrade the database from its current modification level
// to the next modification level.
//
//

u_ds_data luo_scripts
long ll_script_count
long li_count
long ll_script_id
string ls_script
integer li_sts
string ls_completion_status
long ll_error_index
str_sql_script_status lstr_status
integer li_please_wait_index
long ll_current_modification_level
string ls_modlevel_from, ls_modlevel_to, ls_client_link

lstr_status = f_empty_sql_script_status()

SELECT modification_level
INTO :ll_current_modification_level
FROM c_Database_Status;
if not check() then return -1

ls_modlevel_from = string(ll_current_modification_level)

if pl_modification_level > ll_current_modification_level + 1 then
	// Upgrades cannot skip mod levels
	log.log(this, "u_sqlca.upgrade_database:0028", "Attempting to upgrade mod level " + string(ll_current_modification_level) + " to mod level " + string(pl_modification_level) + ".  Mod levels may not be skipped.", 4)
end if

if pl_modification_level > ll_current_modification_level then
	li_sts = jmjsys_upgrade_mod_level(pl_modification_level)	
	if not check() then return -1
end if

li_please_wait_index = f_please_wait_open()

// First do a sync
jmjsys_daily_sync()
if not check() then return -1

// Then get the upgrade scripts
luo_scripts = CREATE u_ds_data
luo_scripts.set_dataobject("dw_c_database_script")
ll_script_count = luo_scripts.retrieve("Database", db_script_major_release, db_script_database_version, pl_modification_level)
if ll_script_count < 0 then return -1
if ll_script_count = 0 then return 0

f_please_wait_progress_bar(li_please_wait_index, 0, ll_script_count)

li_sts = 1

for li_count = 1 to ll_script_count
	ll_script_id = luo_scripts.object.script_id[li_count]
	
	li_sts = execute_script(ll_script_id)
	if li_sts < 0 then
		log.log(this, "u_sqlca.upgrade_database:0058", "Error executing upgrade script #" + string(ll_script_id), 4)
		exit
	end if
	
	f_please_wait_progress_bump(li_please_wait_index)
next

if li_sts >= 0 and pl_modification_level > modification_level then
	this.modification_level = pl_modification_level
end if
	
UPDATE c_Database_Status
SET modification_level = :this.modification_level;
if not check() then li_sts = -1

ls_modlevel_to = string(pl_modification_level)

select count(*) into :li_count from sys.columns where name = 'client_link';
if li_count > 0 then
	
	UPDATE c_Database_Status
	SET client_link = REPLACE(client_link, :ls_modlevel_from, :ls_modlevel_to);
	
	if not check() then li_sts = -1
end if

f_please_wait_close(li_please_wait_index)

// Then run all the hotfixes for the new release
if li_sts >= 0 then
	li_sts = run_hotfixes(false)
end if

return li_sts

end function

public function integer bootstrap_database_scripts ();return bootstrap_database_scripts(false)

end function

public function integer execute_script (long pl_script_id, str_attributes pstr_substitute);return execute_script(pl_script_id, pstr_substitute, true)

end function

public function integer execute_script (string ps_script_type, string ps_script_name);long ll_script_id
long ll_modification_level
u_ds_data luo_scripts
u_sqlca luo_this
long ll_rowcount
long ll_null
string ls_find
long ll_row
integer li_sts

setnull(ll_null)
luo_this = this

// Then run all the scripts where the script_type matches the system_id
luo_scripts = CREATE u_ds_data
luo_scripts.set_dataobject("dw_jmj_latest_scripts", luo_this)
ll_rowcount = luo_scripts.retrieve(ps_script_type, gnv_app.major_release, gnv_app.database_version, modification_level)
if ll_rowcount < 0 then return -1
if ll_rowcount = 0 then return 0

ls_find = "lower(script_name)='" + lower(ps_script_name) + "'"
ll_row = luo_scripts.find(ls_find, 1, ll_rowcount)
if ll_row > 0 then
	ll_script_id = luo_scripts.object.script_id[ll_row]
else
	ll_script_id = 0
end if

DESTROY luo_scripts

if ll_script_id > 0 then
	li_sts = execute_script(ll_script_id)
else
	li_sts = 0
end if

return li_sts

end function

public function string available_version (string ps_system_id);string ls_available_version
string ls_null

setnull(ls_null)

//		epro_40_synch_* were original encounterpro servers

//CHOOSE CASE lower(database_mode)
//	CASE "testing"
//		SELECT current_version
//		INTO :ls_available_version
//		FROM epro_40_synch_testing.dbo.c_Database_System
//		WHERE system_id = :ps_system_id
//		USING this;
//	CASE "beta"
//		SELECT current_version
//		INTO :ls_available_version
//		FROM epro_40_synch_beta.dbo.c_Database_System
//		WHERE system_id = :ps_system_id
//		USING this;
//	CASE ELSE
//		SELECT current_version
//		INTO :ls_available_version
//		FROM epro_40_synch.dbo.c_Database_System
//		WHERE system_id = :ps_system_id
//		USING this;
//END CHOOSE
//if not check() then return ls_null
//
if len(ls_available_version) > 0 then
	return ls_available_version
else
	log.log(this, "u_sqlca.available_version:0031", "Unable to determine available version for " + ps_system_id, 4)
	return ls_null
end if

end function

public function integer upgrade_content (string ps_system_id);//
// This method calls the upgrade scripts to upgrade the database from its current modification level
// to the next modification level.
//
//

u_ds_data luo_scripts
long ll_rows
long i
long ll_script_id
string ls_script
integer li_sts
u_sqlca luo_this
integer li_please_wait_index
string lsa_version[]
integer li_count
string ls_available_version
long ll_major_release
string ls_database_version
long ll_modification_level
long ll_compile

luo_this = this

ls_available_version = available_version(ps_system_id)
if isnull(ls_available_version) then return -1

setnull(ll_modification_level)

li_sts = parse_version(ls_available_version, ll_major_release, ls_database_version, ll_modification_level, ll_compile)
if isnull(ll_modification_level) then
	log.log(this, "u_sqlca.upgrade_content:0032", "Unable to determine target modification level (" + ps_system_id + ")", 4)
	return -1
end if

li_please_wait_index = f_please_wait_open()


// Then run all the scripts where the script_type matches the system_id
luo_scripts = CREATE u_ds_data
luo_scripts.set_dataobject("dw_jmj_latest_scripts", luo_this)
ll_rows = luo_scripts.retrieve(ps_system_id, ll_major_release, ls_database_version, ll_modification_level)
if ll_rows < 0 then
	f_please_wait_close(li_please_wait_index)
	return -1
end if
if ll_rows = 0 then
	f_please_wait_close(li_please_wait_index)
	return 0
end if

f_please_wait_progress_bar(li_please_wait_index, 0, ll_rows)

for i = 1 to ll_rows
	ll_script_id = luo_scripts.object.script_id[i]
	
	li_sts = execute_script(ll_script_id)
	if li_sts < 0 then
		log.log(this, "u_sqlca.upgrade_content:0059", "Error executing upgrade script #" + string(ll_script_id), 4)
		f_please_wait_close(li_please_wait_index)
		return -1
	end if

	f_please_wait_progress_bump(li_please_wait_index)
next

UPDATE c_Database_System
SET current_version = :ls_available_version
WHERE system_id = :ps_system_id
USING luo_this;
if not luo_this.check() then
	f_please_wait_close(li_please_wait_index)
	return -1
end if

f_please_wait_close(li_please_wait_index)

return 1

end function

public function integer parse_version (string ps_version, ref long pl_major_release, ref string ps_database_version, ref long pl_modification_level, ref long pl_compile);integer li_sts
string lsa_version[]
integer li_count

li_sts = 0

setnull(pl_major_release)
setnull(ps_database_version)
setnull(pl_modification_level)
setnull(pl_compile)

li_count = f_parse_string(ps_version, ".", lsa_version)

if li_count >= 1 then
	if isnumber(lsa_version[1]) then
		pl_major_release = long(lsa_version[1])
	end if
end if

if li_count >= 2 then
	ps_database_version = lsa_version[2]
end if

if li_count >= 3 then
	if isnumber(lsa_version[3]) then
		pl_modification_level = long(lsa_version[3])
	end if
end if

if li_count >= 4 then
	if isnumber(lsa_version[4]) then
		pl_compile = long(lsa_version[4])
	end if
end if

if isnull(pl_major_release) or isnull(ps_database_version) then return -1

return 1

end function

public function integer set_beta_status (boolean pb_beta_flag);long ll_count
integer li_beta_flag
str_sql_script_status lstr_status
integer li_sts


// Part of the original encounterpro release logic
return -1

lstr_status = f_empty_sql_script_status()

if isnull(pb_beta_flag) then
	log.log(this, "u_sqlca.set_beta_status:0009", "beta flag cannot be null", 4)
	return -1
end if

select count(*) 
into :ll_count
from syscolumns 
where id = object_id('c_Database_Status')
and name = 'beta_flag'
USING this;
if not check() then return -1
if ll_count = 0 then
	execute_sql_script("ALTER TABLE c_Database_Status ADD [beta_flag] [bit] NOT NULL DEFAULT (0)", lstr_status)
	if lstr_status.status < 0 then
		log.log(this, "u_sqlca.set_beta_status:0023", "Error creatiung beta_flag column (" + lstr_status.error_message + ")" , 4)
		return -1
	end if
end if


UPDATE c_Database_Status
SET beta_flag = :pb_beta_flag
USING this;
if not check() then return -1

beta_flag = pb_beta_flag
if beta_flag then
	database_mode = "Beta"
else
	database_mode = actual_database_mode
end if

li_sts = check_database()
if li_sts <= 0 then
	log.log(this, "u_sqlca.set_beta_status:0043", "check_database_failed.  " + gnv_app.product_name + " must close.", 5)
	return -1
end if

li_sts = bootstrap_database_scripts()
if li_sts <= 0 then
	log.log(this, "u_sqlca.set_beta_status:0049", "Check Now failed.  " + gnv_app.product_name + " must close.", 5)
	return -1
end if

return 1






end function

public subroutine add_credentials (string ps_access_level, ref str_attributes pstr_attributes);string ls_approle
string ls_temp
string ls_approle_temp


f_attribute_add_attribute(pstr_attributes, "database", database)
f_attribute_add_attribute(pstr_attributes, "servername", servername)

if isnull(ps_access_level) then ps_access_level = "Report"

//ls_approle = datalist.get_preference_d("SYSTEM", "approle_" + ps_access_level)
ls_approle_temp = "approle_" + ps_access_level
SELECT dbo.fn_get_preference("SYSTEM", :ls_approle_temp, NULL, NULL)
INTO :ls_approle
FROM c_1_Record;
if not check() then return
if isnull(ls_approle) then ls_approle = application_role
f_attribute_add_attribute(pstr_attributes, "approle", ls_approle)

//ls_temp = datalist.get_preference_d("SYSTEM", "approlepwd_" + ps_access_level)
ls_approle_temp = "approlepwd_" + ps_access_level
SELECT dbo.fn_get_preference("SYSTEM", :ls_approle_temp, NULL, NULL)
INTO :ls_temp
FROM c_1_Record;
if not check() then return
if isnull(ls_temp) then ls_temp = sys(ls_approle)
f_attribute_add_attribute(pstr_attributes, "approlepwd", ls_temp)

//ls_temp = datalist.get_preference("SYSTEM", "epie_user")
SELECT dbo.fn_get_preference("SYSTEM", "epie_user", NULL, NULL)
INTO :ls_temp
FROM c_1_Record;
if not check() then return
if len(ls_temp) > 0 then
	f_attribute_add_attribute(pstr_attributes, "epie_user", ls_temp)
end if

//ls_temp = datalist.get_preference("SYSTEM", "epie_pwd")
SELECT dbo.fn_get_preference("SYSTEM", "epie_pwd", NULL, NULL)
INTO :ls_temp
FROM c_1_Record;
if not check() then return
if len(ls_temp) > 0 then
	f_attribute_add_attribute(pstr_attributes, "epie_pwd", ls_temp)
end if

end subroutine

public function string fn_get_preference (string ps_preference_type, string ps_preference_id, string ps_user_id, long pl_computer_id);
//FUNCTION string fn_get_preference (string ps_preference_type, string ps_preference_id, string ps_user_id, long pl_computer_id) RPCFUNC ALIAS FOR "fn_get_preference"
string ls_return
string ls_null

setnull(ls_null)

IF gnv_app.cpr_mode = "DBMAINT" then
	SELECT preference_value
	INTO :ls_return
	FROM o_Preferences
	WHERE preference_level = 'Global'
	AND preference_key = 'Global'
	AND preference_id = :ps_preference_id;
	if not check() then return ls_null
else
	SELECT dbo.fn_get_preference(:ps_preference_type, :ps_preference_id, :ps_user_id, :pl_computer_id)
	INTO :ls_return
	FROM c_1_record;
	if not check() then return ls_null
end if

return ls_return



end function

public function string fn_attribute_description (string ps_attribute, string ps_value);
//FUNCTION string fn_attribute_description (string ps_attribute, string ps_value) RPCFUNC ALIAS FOR "fn_attribute_description"
string ls_return
string ls_null

setnull(ls_null)

SELECT dbo.fn_attribute_description(:ps_attribute, :ps_value) 
INTO :ls_return
FROM c_1_record;
if not check() then return ls_null


return ls_return



end function

public function string fn_check_encounter_owner_billable (string ps_cpr_id, long pl_encounter_id);
//FUNCTION string fn_check_encounter_owner_billable (string ps_cpr_id, long pl_encounter_id) RPCFUNC ALIAS FOR "fn_check_encounter_owner_billable"
string ls_return
string ls_null

setnull(ls_null)

SELECT dbo.fn_check_encounter_owner_billable(:ps_cpr_id, :pl_encounter_id) 
INTO :ls_return
FROM c_1_record;
if not check() then return ls_null


return ls_return



end function

public function string fn_context_object_type (string ps_context_object, string ps_cpr_id, long pl_object_key);
//FUNCTION string fn_context_object_type (string ps_context_object, string ps_cpr_id, long pl_object_key) RPCFUNC ALIAS FOR "fn_context_object_type"
string ls_return
string ls_null

setnull(ls_null)

SELECT dbo.fn_context_object_type(:ps_context_object, :ps_cpr_id, :pl_object_key)
INTO :ls_return
FROM c_1_record;
if not check() then return ls_null


return ls_return



end function

public function string fn_get_specific_preference (string ps_preference_type, string ps_preference_level, string ps_preference_key, string ps_preference_id);
//FUNCTION string fn_get_specific_preference (string ps_preference_type, string ps_preference_level, string ps_preference_key, string ps_preference_id) RPCFUNC ALIAS FOR "fn_get_specific_preference"
string ls_return
string ls_null

setnull(ls_null)

SELECT dbo.fn_get_specific_preference(:ps_preference_type, :ps_preference_level, :ps_preference_key, :ps_preference_id)
INTO :ls_return
FROM c_1_record;
if not check() then return ls_null


return ls_return



end function

public function string fn_lookup_epro_id (long pl_owner_id, string ps_code_domain, string ps_code_value, string ps_jmj_domain);
//FUNCTION string fn_lookup_epro_id (long pl_owner_id, string ps_code_domain, string ps_code_value, string ps_jmj_domain) RPCFUNC ALIAS FOR "fn_lookup_epro_id"
string ls_return
string ls_null

setnull(ls_null)

SELECT dbo.fn_lookup_epro_id(:pl_owner_id, :ps_code_domain, :ps_code_value, :ps_jmj_domain)
INTO :ls_return
FROM c_1_record;
if not check() then return ls_null


return ls_return



end function

public function string fn_lookup_patient (string ps_id_domain, string ps_id);
//FUNCTION string fn_lookup_patient (string ps_id_domain, string ps_id) RPCFUNC ALIAS FOR "fn_lookup_patient"
string ls_return
string ls_null

setnull(ls_null)

SELECT dbo.fn_lookup_patient(:ps_id_domain, :ps_id)
INTO :ls_return
FROM c_1_record;
if not check() then return ls_null


return ls_return



end function

public function string fn_lookup_patient_billingid (string ps_id_domain, string ps_id);
//FUNCTION string fn_lookup_patient_billingid (string ps_id_domain, string ps_id) RPCFUNC ALIAS FOR "fn_lookup_patient_billingid"
string ls_return
string ls_null

setnull(ls_null)

SELECT dbo.fn_lookup_patient_billingid(:ps_id_domain, :ps_id)
INTO :ls_return
FROM c_1_record;
if not check() then return ls_null


return ls_return



end function

public function string fn_lookup_user (string ps_office_id, string ps_id);
//FUNCTION string fn_lookup_user (string ps_office_id, string ps_id) RPCFUNC ALIAS FOR "fn_lookup_user"
string ls_return
string ls_null

setnull(ls_null)

SELECT dbo.fn_lookup_user(:ps_office_id, :ps_id)
INTO :ls_return
FROM c_1_record;
if not check() then return ls_null


return ls_return



end function

public function string fn_lookup_user_billingid (string ps_office_id, string ps_id);
//FUNCTION string fn_lookup_user_billingid (string ps_office_id, string ps_id) RPCFUNC ALIAS FOR "fn_lookup_user_billingid"
string ls_return
string ls_null

setnull(ls_null)

SELECT dbo.fn_lookup_user_billingid(:ps_office_id, :ps_id)
INTO :ls_return
FROM c_1_record;
if not check() then return ls_null


return ls_return



end function

public function string fn_object_description (string ps_object, string ps_key);
//FUNCTION string fn_object_description (string ps_object, string ps_key) RPCFUNC ALIAS FOR "fn_object_description"
string ls_return
string ls_null

setnull(ls_null)

SELECT dbo.fn_object_description(:ps_object, :ps_key)
INTO :ls_return
FROM c_1_record;
if not check() then return ls_null


return ls_return



end function

public function string fn_object_equivalence_group (string ps_object_id);
//FUNCTION string fn_object_equivalence_group (string ps_object_id) RPCFUNC ALIAS FOR "fn_object_equivalence_group"
string ls_return
string ls_null

setnull(ls_null)

SELECT dbo.fn_object_equivalence_group(:ps_object_id)
INTO :ls_return
FROM c_1_record;
if not check() then return ls_null


return ls_return



end function

public function string fn_object_id_from_key (string ps_object_type, string ps_object_key);
//FUNCTION string fn_object_id_from_key (string ps_object_type, string ps_object_key) RPCFUNC ALIAS FOR "fn_object_id_from_key"
string ls_return
string ls_null

setnull(ls_null)

SELECT dbo.fn_object_id_from_key(:ps_object_type, :ps_object_key)
INTO :ls_return
FROM c_1_record;
if not check() then return ls_null


return ls_return



end function

public function string fn_patient_full_name (string ps_cpr_id);
//FUNCTION string fn_patient_full_name (string ps_cpr_id) RPCFUNC ALIAS FOR "fn_patient_full_name"
string ls_return
string ls_null

setnull(ls_null)

SELECT dbo.fn_patient_full_name(:ps_cpr_id)
INTO :ls_return
FROM c_1_record;
if not check() then return ls_null


return ls_return



end function

public function string fn_patient_object_last_result (string ps_cpr_id, string ps_context_object, long pl_object_key, string ps_observation_id, integer pi_result_sequence);
//FUNCTION string fn_patient_object_last_result (string ps_cpr_id, string ps_context_object, long pl_object_key, string ps_observation_id, integer pi_result_sequence) RPCFUNC ALIAS FOR "fn_patient_object_last_result"
string ls_return
string ls_null

setnull(ls_null)

SELECT dbo.fn_patient_object_last_result(:ps_cpr_id, :ps_context_object, :pl_object_key, :ps_observation_id, :pi_result_sequence)
INTO :ls_return
FROM c_1_record;
if not check() then return ls_null


return ls_return



end function

public function string fn_patient_object_property (string ps_cpr_id, string ps_context_object, long pl_object_key, string ps_progress_key);
//FUNCTION string fn_patient_object_property (string ps_cpr_id, string ps_context_object, long pl_object_key, string ps_progress_key) RPCFUNC ALIAS FOR "fn_patient_object_property"
string ls_return
string ls_null

setnull(ls_null)

SELECT dbo.fn_patient_object_property(:ps_cpr_id, :ps_context_object, :pl_object_key, :ps_progress_key)
INTO :ls_return
FROM c_1_record;
if not check() then return ls_null


return ls_return



end function

public function string fn_patient_object_description (string ps_cpr_id, string ps_context_object, long pl_object_key);
//FUNCTION string fn_patient_object_description (string ps_cpr_id, string ps_context_object, long pl_object_key) RPCFUNC ALIAS FOR "fn_patient_object_description"
string ls_return
string ls_null

setnull(ls_null)

SELECT dbo.fn_patient_object_description(:ps_cpr_id, :ps_context_object, :pl_object_key)
INTO :ls_return
FROM c_1_record;
if not check() then return ls_null


return ls_return



end function

public function string fn_string_to_identifier (string ps_string);
//FUNCTION string fn_string_to_identifier (string ps_string) RPCFUNC ALIAS FOR "fn_string_to_identifier"
string ls_return
string ls_null

setnull(ls_null)

SELECT dbo.fn_string_to_identifier(:ps_string)
INTO :ls_return
FROM c_1_record;
if not check() then return ls_null


return ls_return



end function

public function string fn_config_object_description (string ps_parent_id);string ls_return
string ls_null

setnull(ls_null)

SELECT dbo.fn_config_object_description(CAST(:ps_parent_id AS uniqueidentifier) )
INTO :ls_return
FROM c_1_record;
if not check() then return ls_null


return ls_return



end function

public function string fn_pretty_phone (string ps_phone);
string ls_return
string ls_null

ls_return = ps_phone
// Avoid automatic American phone formatting 
if NOT IsNull(gnv_app.locale) AND gnv_app.locale = "en-US" then
	setnull(ls_null)
	
	SELECT dbo.fn_pretty_phone(:ps_phone)
	INTO :ls_return
	FROM c_1_record;
	if not check() then return ls_null
end if

return ls_return



end function

public function string fn_treatment_type_treatment_key (string ps_treatment_type);string ls_return
string ls_null

setnull(ls_null)

SELECT dbo.fn_treatment_type_treatment_key(:ps_treatment_type)
INTO :ls_return
FROM c_1_record;
if not check() then return ls_null


return ls_return



end function

public function integer set_database_status (string ps_database_status);u_sqlca luo_this
string ls_database_status
integer li_sts

luo_this = this

if isnull(ps_database_status) then
	log.log(this, "u_sqlca.set_database_status:0008", "Null database mode", 4)
	return -1
end if

ps_database_status = upper(ps_database_status)

// If we're already in the specified mode then do nothing
if ps_database_status = database_status then return 0

UPDATE c_Database_Status
SET database_status = :ps_database_status;
if not luo_this.check() then return -1

database_status = ps_database_status

log.log(this, "u_sqlca.set_database_status:0023", "Changed database status to ~"" + database_status + "~"", 3)

return 1


end function

public function integer reset_database_objects ();integer li_sts
integer li_please_wait_index
u_ds_data luo_triggers
u_ds_data luo_scripts
u_sqlca luo_this
long ll_trigger_rows
long ll_script_rows
long i
long ll_script_id
string ls_tablename

// Part of the original encounterpro release logic
return -1

luo_this = this

log.log(this, "u_sqlca.reset_database_objects:0014", "Reset Database Objects starting...", 2)

li_please_wait_index = f_please_wait_open()

// First make sure the c_Database_Scripts table is current
li_sts = bootstrap_database_scripts()
if li_sts <= 0 then
	log.log(this, "u_sqlca.reset_database_objects:0021", "Error updating database scripts", 4)
	f_please_wait_close(li_please_wait_index)
	return -1
end if


// Make sure the trigger scripts are current in c_Database_Table
li_sts = execute_string("jmj_set_database_triggers")
if li_sts <= 0 then
	log.log(this, "u_sqlca.reset_database_objects:0030", "Error setting triggers", 4)
	f_please_wait_close(li_please_wait_index)
	return -1
end if

// Get the number of tables
luo_triggers = CREATE u_ds_data
luo_triggers.set_dataobject( "dw_c_database_table")
ll_trigger_rows = luo_triggers.retrieve()
if ll_trigger_rows < 0 then
	f_please_wait_close(li_please_wait_index)
	return -1
end if

// Then run all the scripts from the reset scripts stored procedure
luo_scripts = CREATE u_ds_data
luo_scripts.set_dataobject("dw_jmj_get_database_reset_scripts", luo_this)
ll_script_rows = luo_scripts.retrieve(db_script_major_release, db_script_database_version, this.modification_level)
if ll_script_rows < 0 then
	f_please_wait_close(li_please_wait_index)
	return -1
end if

f_please_wait_progress_bar(li_please_wait_index, 0, ll_script_rows + ll_trigger_rows)


// Then run all the scripts from the reset scripts stored procedure
for i = 1 to ll_script_rows
	ll_script_id = luo_scripts.object.script_id[i]
	
	li_sts = execute_script(ll_script_id)
	if li_sts < 0 then
		log.log(this, "u_sqlca.reset_database_objects:0062", "Error executing upgrade script #" + string(ll_script_id), 4)
		f_please_wait_close(li_please_wait_index)
		return -1
	end if

	f_please_wait_progress_bump(li_please_wait_index)
next

// msc commented out because the trigger hotfixes aren't publishing the trigger scripts correctly yet and the reset-scripts still include the triggers for now
//// Rebuild the triggers for each table
//for i = 1 to ll_trigger_rows
//	ls_tablename = luo_triggers.object.tablename[i]
//	li_sts = rebuild_table_triggers(ls_tablename)
//	if li_sts <= 0 then
//		log.log(this, "u_sqlca.reset_database_objects:0076", "Error rebuilding triggers for table (" + ls_tablename + ")", 4)
//		f_please_wait_close(li_please_wait_index)
//		return -1
//	end if
//
//	f_please_wait_progress_bump(li_please_wait_index)
//next

// Finally, reset the active services
jmj_reset_active_services()
if not check() then return -1

f_please_wait_close(li_please_wait_index)

log.log(this, "u_sqlca.reset_database_objects:0090", "Reset Database Objects Succeeded", 2)

return 1



end function

public function integer bootstrap_database_scripts (boolean pb_get_from_server);integer li_sts
str_popup_return popup_return
blob lbl_script
string ls_script_name
string ls_script
string ls_id
long ll_local_script_id
integer li_please_wait_index
string ls_query
u_ds_data luo_data
long ll_rows
long i
string ls_null

setnull(ls_null)

// epro_40_synch and epro_40_synch_testing were original encounterpro servers

//li_please_wait_index = f_please_wait_open()
//
//luo_data = CREATE u_ds_data
//luo_data.set_dataobject("dw_bootstrap_scripts", this)
//ls_query = "select script_name, id from epro_40_synch"
//CHOOSE CASE lower(database_mode)
//	CASE "testing"
//		ls_query += "_testing"
//	CASE "beta"
//		ls_query += "_beta"
//END CHOOSE
//ls_query += ".dbo.v_bootstrap_scripts_2 where major_release = :major_release and database_version = :database_version and modification_level = :modification_level"
//
//luo_data.modify("datawindow.table.select''" + ls_query + "'")
//ll_rows = luo_data.retrieve(db_script_major_release, db_script_database_version, modification_level)
//
//for i = 1 to ll_rows
//	ls_script_name = luo_data.object.script_name[i]
//	ls_id = luo_data.object.id[i]
//	setnull(lbl_script)
//
//	// If pb_get_from_server is true then don't even try to get the script locally
//	if not pb_get_from_server then
//		// See if this script is already local
//		SELECTBLOB db_script
//		INTO :lbl_script
//		FROM c_Database_Script
//		WHERE CAST(id AS varchar(38)) = :ls_id
//		USING this;
//		if not check() then
//			f_please_wait_close(li_please_wait_index)
//			jmj_log_database_maintenance("Sync Database Scripts", "Error", ls_null, f_module_version_number(), ls_null)
//			return -1
//		end if
//	end if
	
	if isnull(lbl_script) or len(lbl_script) <= 0 then
		// If the script isn't local yet the get it from the server
//		CHOOSE CASE lower(database_mode)
//			CASE "testing"
//				SELECTBLOB db_script
//				INTO :lbl_script
//				FROM epro_40_synch_testing.dbo.c_Database_Script
//				WHERE CAST(id AS varchar(38)) = :ls_id
//				USING this;
//			CASE "beta"
//				SELECTBLOB db_script
//				INTO :lbl_script
//				FROM epro_40_synch_beta.dbo.c_Database_Script
//				WHERE CAST(id AS varchar(38)) = :ls_id
//				USING this;
//			CASE ELSE
//				SELECTBLOB db_script
//				INTO :lbl_script
//				FROM epro_40_synch.dbo.c_Database_Script
//				WHERE CAST(id AS varchar(38)) = :ls_id
//				USING this;
//		END CHOOSE
//		if not check() then
//			log.log(this, "u_sqlca.bootstrap_database_scripts:0076", "Error getting script from " + database_mode + " sync database (" + ls_script_name + ", " + ls_id + ")", 4)
//			f_please_wait_close(li_please_wait_index)
//			jmj_log_database_maintenance("Sync Database Scripts", "Error", ls_null, f_module_version_number(), ls_null)
//			return -1
//		end if
//		if sqlcode = 100 or sqlnrows <> 1 then
//			log.log(this, "u_sqlca.bootstrap_database_scripts:0082", "Script not found in " + database_mode + " sync database (" + ls_script_name + ", " + ls_id + ")", 4)
//			f_please_wait_close(li_please_wait_index)
//			jmj_log_database_maintenance("Sync Database Scripts", "Error", ls_null, f_module_version_number(), ls_null)
//			return -1
//		end if
	end if
	
//	ls_script = f_blob_to_string(lbl_script)
//	
//	li_sts = execute_string(ls_script)
//	if li_sts <= 0 then
//		log.log(this, "u_sqlca.bootstrap_database_scripts:0093", "Error executing remote scripts update", 4)
//		f_please_wait_close(li_please_wait_index)
//		jmj_log_database_maintenance("Sync Database Scripts", "Error", ls_null, f_module_version_number(), ls_null)
//		return -1
//	end if
//next
//
//jmj_log_database_maintenance("Sync Database Scripts", "OK", ls_null, f_module_version_number(), ls_null)
//
//f_please_wait_close(li_please_wait_index)
//
return 1



end function

public function integer rebuild_table_triggers (string ps_tablename);string ls_trigger_script
blob lbl_trigger_script
integer li_sts

if isnull(ps_tablename) or trim(ps_tablename) = "" then
	log.log(this, "u_sqlca.rebuild_table_triggers:0006", "No Table name", 4)
	return -1
end if

SELECTBLOB trigger_script
INTO :lbl_trigger_script
FROM c_Database_Table
WHERE tablename = :ps_tablename
USING this;
if not check() then return -1
if sqlcode = 100 then
	log.log(this, "u_sqlca.rebuild_table_triggers:0017", "Table not found (" + ps_tablename + ")", 4)
	return -1
end if

// Even if we don't have a script, go ahead and remove the existing triggers
li_sts = execute_string("sp_drop_triggers '" + ps_tablename + "'")
if li_sts < 0 then
	log.log(this, "u_sqlca.rebuild_table_triggers:0024", "Error dropping triggers (" + ps_tablename + ")", 4)
	return -1
end if

// Now run the trigger script
ls_trigger_script = f_blob_to_string(lbl_trigger_script)
if len(ls_trigger_script) > 0 then
	li_sts = execute_string(ls_trigger_script)
	if li_sts < 0 then
		log.log(this, "u_sqlca.rebuild_table_triggers:0033", "Error creating triggers (" + ps_tablename + ")", 4)
		return -1
	end if
end if

return 1

end function

public function integer run_hotfixes (boolean pb_new_only);// This method runs all the hotfixes for the current mod level
// if the pb_new_only param is set to true, then only run hotfixes which
// have not yet been successfully run 
str_popup_return popup_return
integer li_sts
string ls_message
datetime ldt_last_executed
long ll_script_id
long i
integer li_allow_users
u_ds_data luo_data
long ll_count
long ll_null
integer li_please_wait_index
string ls_last_completion_status
boolean lb_already_run
string ls_null
string ls_script_name

setnull(ls_null)
setnull(ll_null)

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_jmj_latest_scripts", this)

ll_count = luo_data.retrieve("Hotfix", db_script_major_release, db_script_database_version, ll_null)
if ll_count < 0 then return -1

li_please_wait_index = f_please_wait_open()

f_please_wait_progress_bar(li_please_wait_index, 0, ll_count)

// Execute all the scripts which have not been executed
for i = 1 to ll_count
	ldt_last_executed = luo_data.object.last_executed[i]
	ls_last_completion_status = luo_data.object.last_completion_status[i]
	ls_script_name = luo_data.object.script_name[i]
	ll_script_id = luo_data.object.script_id[i]
	
	if not isnull(ldt_last_executed) and upper(ls_last_completion_status) = "OK" then
		lb_already_run = true
	else
		lb_already_run = false
	end if
	
	if not pb_new_only or not lb_already_run then
		li_sts = execute_script(ll_script_id)
		if li_sts <= 0 then
			openwithparm(w_pop_message, "Executing Script Failed")
			DESTROY luo_data
			jmj_log_database_maintenance("Run New Hotfixes", "Error", string(ll_script_id), f_module_version_number(), ls_script_name)
			return -1
		end if
	end if
	
	f_please_wait_progress_bump(li_please_wait_index)
next

DESTROY luo_data

jmj_log_database_maintenance("Run New Hotfixes", "OK", ls_null, f_module_version_number(), ls_null)
		
f_please_wait_close(li_please_wait_index)

return 1

end function

public function integer reset_permissions ();long ll_script_id
long ll_modification_level
u_ds_data luo_scripts
u_sqlca luo_this
long ll_script_count
long ll_null
string ls_find
long ll_row
integer li_sts
long i
str_attributes lstr_attributes

setnull(ll_null)
luo_this = this

// Then run all the scripts where the script_type matches the system_id
luo_scripts = CREATE u_ds_data
luo_scripts.set_dataobject("dw_jmj_latest_scripts", luo_this)
ll_script_count = luo_scripts.retrieve("Security", db_script_major_release, db_script_database_version, modification_level)
if ll_script_count < 0 then return -1
if ll_script_count = 0 then
	log.log(this, "u_sqlca.reset_permissions:0022", "No Security Scripts Found", 4)
	return -1
end if

for i = 1 to ll_script_count
	ll_script_id = luo_scripts.object.script_id[i]
	
	// Execute the script but don't abort on any error so that as many of the permissions as possible will get set
	li_sts = execute_script(ll_script_id, lstr_attributes, false)
	// Don't do anything if an error occured, just keep processing
next

DESTROY luo_scripts

return 1

end function

public function integer execute_script (long pl_script_id, str_attributes pstr_substitute, boolean pb_abort_on_error);string ls_script
integer li_sts
string ls_error
datetime ldt_now
str_scripts lstr_scripts
long i
string ls_err_mes
blob lbl_script
string ls_completion_status
long ll_error_index
str_sql_script_status lstr_status

setnull(ls_error)
setnull(ll_error_index)

lstr_status = f_empty_sql_script_status()

ldt_now = datetime(today(), now())

SELECTBLOB db_script
INTO :lbl_script
FROM c_Database_Script
WHERE script_id = :pl_script_id
USING this;
if not check() then return -1
if sqlcode = 100 then
	log.log(this, "u_sqlca.execute_script:0027", "Script_id not found (" + string(pl_script_id) + ")", 4)
	return -1
end if

ls_script = f_blob_to_string(lbl_script)

ls_script = f_string_substitute_attributes(ls_script, pstr_substitute)

execute_sql_script(ls_script, pb_abort_on_error, lstr_status)
if lstr_status.status < 0 then
	ls_completion_status = "Error"
else
	ls_completion_status = "OK"
end if

INSERT INTO c_Database_Script_Log (
	script_id,
	executed_date_time,
	executed_from_computer_id,
	db_script,
	completion_status,
	error_index,
	error_message)
VALUES (
	:pl_script_id,
	:ldt_now,
	:gnv_app.computer_id,
	:ls_script,
	:ls_completion_status,
	:lstr_status.error_index,
	:lstr_status.error_message)
USING this;
if not check() then return -1

return lstr_status.status



end function

public function long table_column_list (string ps_tablename, ref string psa_column[]);string ls_find
long ll_row
long ll_rowcount
integer li_sts
long ll_column_count

if not isvalid(database_columns) or isnull(database_columns) then
	database_columns = CREATE u_ds_data
	database_columns.set_dataobject("dw_c_database_column")
end if

ll_rowcount = database_columns.rowcount()
if ll_rowcount <= 0 then
	ll_rowcount = database_columns.retrieve()
	if ll_rowcount <= 0 then return -1
end if

ll_column_count = 0

ls_find = "lower(tablename)='" + lower(ps_tablename) + "'"
ll_row = database_columns.find(ls_find, 1, ll_rowcount)
DO WHILE ll_row > 0 and ll_row <= ll_rowcount
	ll_column_count++
	psa_column[ll_column_count] = database_columns.object.columnname[ll_row]
	
	ll_row = database_columns.find(ls_find, ll_row + 1, ll_rowcount + 1)
LOOP

return ll_column_count
end function

public function string fn_patient_object_progress_value_old (string ps_cpr_id, string ps_context_object, string ps_progress_type, long pl_object_key, string ps_progress_key);
//FUNCTION string fn_patient_object_progress_value (string ps_cpr_id, string ps_context_object, string ps_progress_type, long pl_object_key, string ps_progress_key) RPCFUNC ALIAS FOR "fn_patient_object_progress_value"
string ls_return
string ls_null

setnull(ls_null)

SELECT dbo.fn_patient_object_progress_value(:ps_cpr_id, :ps_context_object, :ps_progress_type, :pl_object_key, :ps_progress_key)
INTO :ls_return
FROM c_1_record;
if not check() then return ls_null


return ls_return



end function

public function string sysapp (boolean pb_old);string ls_temp
str_popup popup

if not pb_old then
	SELECT preference_value
	INTO :ls_temp
	FROM o_Preferences
	WHERE preference_level = 'Global'
	AND preference_key = 'Global'
	AND preference_id = 'system_bitmap'
	USING this;
	if sqlcode = 0 and sqlnrows = 1 then
		if common_thread.utilities_ok() then
			// Potentially replace with CrypterObject TDES! type SymmetricDecrypt / SymmetricEncrypt
			TRY
				return common_thread.eprolibnet4.of_decryptstring(ls_temp, common_thread.key())
			CATCH (throwable le_error)
				log.log(this, "u_sqlca.sysapp:0018", "Error getting system_bitmap: " + le_error.text, 4)
			END TRY
		else
			log.log(this, "u_sqlca.sysapp:0022", "No system_bitmap (Utilities not available)", 3)
		end if		
	end if
end if

//return common_thread.eprolibnet4.of_decryptstring("876587658765876876587658765876587", common_thread.key())

ls_temp  = "a"
ls_temp  += "p"
ls_temp  += "p"
ls_temp  += "l"
ls_temp  += "e"
ls_temp  += "s"
ls_temp  += "a"
ls_temp  += "u"
ls_temp  += "c"
ls_temp  += "e"
ls_temp  += "2"
ls_temp  += "8"


return ls_temp

end function

public function integer set_database (string ps_database);database = ps_database

return check_database()


end function

public function string temp_proc_name ();string ls_procname
string ls_null

setnull(ls_null)

SELECT CAST(newid() AS varchar(38))
INTO :ls_procname
FROM c_1_Record;
if not check() then return ls_null

ls_procname = f_string_substitute(ls_procname, "-", "_")

if left(ls_procname, 1) = "{" then
	ls_procname = mid(ls_procname, 2)
end if

if right(ls_procname, 1) = "}" then
	ls_procname = left(ls_procname, len(ls_procname) - 1)
end if

ls_procname = "cprsystem.tmpjmj_doc_proc_" + ls_procname

return ls_procname

end function

private subroutine execute_sql_script (string ps_string, ref str_sql_script_status pstr_status);execute_sql_script(ps_string, true, pstr_status)



end subroutine

public function integer upgrade_database ();long ll_modification_level
long ll_material_id
blob lbl_script
string ls_xml
integer li_sts
pbdom_builder pbdombuilder_new
pbdom_element lo_root
pbdom_element pbdom_element_array[]
pbdom_document lo_doc
string ls_new_xml
blob lbl_new_xml
string ls_script
integer li_please_wait_index
integer li_script, li_count
integer li_num_scripts
string ls_element
string ls_modlevel_from, ls_modlevel_to
str_sql_script_status lstr_sql_script_status

ll_modification_level = this.modification_level + 1
ls_modlevel_from = string(this.modification_level)

ll_material_id = upgrade_material_id(ls_script)
if ll_material_id < 0 then
	// Messages already logged
	return -1
end if

SELECTBLOB object
INTO :lbl_script
FROM c_Patient_Material
WHERE material_id = :ll_material_id;
if not tf_check() then return -1

if isnull(lbl_script) or len(lbl_script) <= 0 then
	log.log(this, "u_sqlca.upgrade_database:0034", "Empty upgrade script was found for mod level (" + string(ll_modification_level) + ")", 4)
	return -1
end if

ls_xml = f_blob_to_string(lbl_script)

// Do not keep the material, want to load again next time
DELETE FROM c_patient_material
WHERE material_id = :ll_material_id
USING this;

// Now create the DOM version from the string version
pbdombuilder_new = Create pbdom_builder

// Make sure this looks like XML
TRY
	lo_doc = pbdombuilder_new.BuildFromString(ls_xml)
	lo_root = lo_doc.getrootelement()
	if lo_root.GetName() <> "EproDBSchema" then
		log.log(this, "u_sqlca.upgrade_database:0049", "XML schema incorrect", 4)
		return -1
	end if		
CATCH (throwable lo_error)
	log.log(this, "u_sqlca.upgrade_database:0053", "Error reading XML schema data (" + lo_error.text + ")", 4)
	return -1
END TRY

begin_transaction(this, "Upgrade Mod Level")

lo_root.GetChildElements(ref pbdom_element_array)
li_num_scripts = UpperBound(pbdom_element_array)

li_please_wait_index = f_please_wait_open()
f_please_wait_progress_bar(li_please_wait_index, 0, li_num_scripts)

for li_script = 1 to li_num_scripts
	ls_element = pbdom_element_array[li_script].getname()
	ls_script = pbdom_element_array[li_script].gettext()
	
	log.log_db(this, "u_sqlca.upgrade_database:0076", "Executing " + ls_element, 2)
	execute_sql_script(ls_script, true, lstr_sql_script_status)
	if lstr_sql_script_status.status < 0 then
		check()
		rollback_transaction()
		f_please_wait_close(li_please_wait_index)
		log.log(this, "u_sqlca.upgrade_database:0082", "Failed executing " + ls_script, 5)
		DESTROY pbdombuilder_new
		return -1
	end if
	f_please_wait_progress_bar(li_please_wait_index, li_script, li_num_scripts)
next
f_please_wait_close(li_please_wait_index)

commit_transaction()

select count(*) into :li_count from sys.columns where name = 'client_link';
if li_count > 0 then
	
	ls_modlevel_to = string(ll_modification_level)		
	UPDATE c_Database_Status
	SET modification_level = :ll_modification_level,
		client_link = REPLACE(client_link, :ls_modlevel_from, :ls_modlevel_to)
	USING this;
else		
	UPDATE c_Database_Status
	SET modification_level = :ll_modification_level
	USING this;

end if
if not check() then
	return -1
end if

DESTROY pbdombuilder_new

this.modification_level = ll_modification_level

return 1


end function

public function string who_called (powerobject po_caller_object);string ls_who

if not isvalid(po_caller_object) then
	ls_who = "UNKNOWN CALLER"
elseif isnull(po_caller_object) then
	ls_who = "NULL CALLER"
else
	ls_who = po_caller_object.classname()
end if

return ls_who
end function

public function long upgrade_material_id (ref string as_filename);long ll_modification_level
long ll_material_id
integer li_sts
string ls_filepath

ll_modification_level = modification_level + 1

// Do not search for existing record, always load from mdlvl file
//SELECT MAX(material_id)
//INTO :ll_material_id
//FROM dbo.c_Patient_material
//WHERE status = 'ML'
//AND version = :ll_modification_level;
//if not tf_check() then return -1
//
// If no material was found try loading the schema for this mod level
//if ll_material_id = 0 or isnull(ll_material_id) then
	//log.log(this, "u_sqlca.upgrade_material_id:0015", "No upgrade material found for mod level (" + string(ll_modification_level) + ")", 4)
	ll_material_id = load_schema_file(gnv_app.program_directory, ll_modification_level, as_filename)
	if ll_material_id <= 0 then
		ll_material_id = load_schema_file(f_default_attachment_path(), ll_modification_level, as_filename)
	end if
	if ll_material_id <= 0 then
		ll_material_id = load_schema_file("\\localhost\attachments", ll_modification_level, as_filename)
	end if
	if ll_material_id <= 0 then
		MessageBox("File not found", "The ModLevel-" + string(ll_modification_level) + ".mdlvl schema file for mod level " + string(ll_modification_level) + " was not found in either the program directory or attachments folder.")

		li_sts = GetFileOpenName ("Select DB Schema File", ls_filepath, as_filename ,"mdlvl", "DB Mod Level (*.mdlvl),*.mdlvl")
		If li_sts <= 0 Then return -1
		
		ll_material_id = load_schema_file(ls_filepath, ll_modification_level, as_filename)
		if ll_material_id <= 0 then
			openwithparm(w_pop_message, "Error loading schema file")
			return -1
		end if
	end if
//end if

return ll_material_id
end function

public function long load_schema_file (string ps_rootpath, long pl_modification_level, ref string as_filename);string ls_left
string ls_right
string ls_id
string ls_url
long ll_from_material_id
string ls_parent_config_object_id
long ll_count
long ll_file_count
long i
long ll_subdir_index
string lsa_files[]
string lsa_paths[]
str_filepath lstr_rootpath
str_filepath lstr_filepath
string ls_sql_files
integer li_sts
str_file_attributes lstr_file_attributes
long ll_filebytes
blob lbl_file
string ls_file_script
string ls_owner
string ls_object
string ls_objecttype
long ll_category
string ls_title
long ll_material_id
integer li_success_count
string ls_user_id


if lower(right(ps_rootpath, 6)) = ".mdlvl" then
	ls_sql_files = ps_rootpath
	lstr_rootpath = f_parse_filepath2(ps_rootpath)
else
	// assume no file is specified and add one so it will parse correctly
	lstr_rootpath = f_parse_filepath2(ps_rootpath + "\dummy.sql")
	ls_sql_files = lstr_rootpath.drive + lstr_rootpath.filepath + "\*-" + string(pl_modification_level) + ".mdlvl"
end if

ll_file_count = log.get_all_files(ls_sql_files, lsa_files)
for i = 1 to ll_file_count
	lsa_paths[i] = lstr_rootpath.drive + lstr_rootpath.filepath + "\" + lsa_files[i]
next

li_success_count = 0

for i = 1 to ll_file_count
	// Skip the shorthand directories
	if lsa_files[i] = "." or lsa_files[i] = ".." then continue
	
	// Skip the file if we can't get its properties
	li_sts = log.file_attributes(lsa_paths[i], lstr_file_attributes)
	if li_sts <= 0 then continue
	
	// Skip the directories
	if lstr_file_attributes.subdirectory then continue
	
	
	lstr_filepath = f_parse_filepath2(lsa_paths[i])
	
	// Read the file
	li_sts = log.file_read(lsa_paths[i], lbl_file)
	if li_sts <= 0 then
		log.log(this, "u_sqlca.load_schema_file:0064", "Error reading file (" + lsa_paths[i] + ")", 4)
		return -1
	end if
	
	ls_id = f_new_guid()
	setnull(ls_url)
	setnull(ll_from_material_id)
	setnull(ll_category)
	setnull(ls_parent_config_object_id)
	
	if isnull(current_scribe) then
		ls_user_id = "SYSTEM"
	else
		ls_user_id = current_scribe.user_id
	end if

	ls_title = gnv_app.product_name + " Schema - Mod Level " + string(pl_modification_level)
	
	// Remove any previous mdlvl records for this version
	DELETE FROM c_Patient_Material
	WHERE version = :pl_modification_level
	USING this;
	if not check() then 
		log.log(this,"u_sqlca.load_schema_file:0087","Previous material not deleted for version " + string(pl_modification_level),4)
		return -1
	end if
	
	INSERT INTO c_Patient_Material (
		title ,
		category ,
		status ,
		extension ,
		created_by ,
		id,
		version,
		url,
		owner_id,
		filename,
		document_id
		)
	VALUES (
		:ls_title,
		:ll_category,
		'ML',
		:lstr_filepath.extension,
		:ls_user_id,
		:ls_id,
		:pl_modification_level,
		:ls_url,
		0,
		:lstr_filepath.filename,
		:ls_id
		)
	USING this;
	if not check() then 
		log.log(this,"u_sqlca.load_schema_file:0119","Insert to c_Patient_Material failed",4)
		return -1
	end if

//	ll_material_id = sqlca.jmj_new_material(ls_title, ll_category, "ML", lstr_filepath.extension, ls_id, ls_url, ls_user_id, lstr_filepath.filename, ll_from_material_id, ls_parent_config_object_id)

	SELECT SCOPE_IDENTITY()
	INTO :ll_material_id
	FROM c_1_record
	USING this;
	
	if not check() OR isnull(ll_material_id) OR ll_material_id <= 0 then
		log.log(this,"u_sqlca.load_schema_file:0131","Error finding new material",4)
		return -1
	end if
	
	// Update the blob column
	UpdateBlob c_patient_material
	Set object = :lbl_file 
	Where material_id = :ll_material_id
	USING this;
	if not check() then 
		log.log(this,"u_sqlca.load_schema_file:0141","Blob update failed, driver is " + sqlca.DBMS,4)
		return -1
	end if
	
	as_filename = lstr_filepath.filename
	return ll_material_id
next
	
return 0


end function

public function string fn_strength (string ps_form_rxcui);

string ls_return
string ls_null

setnull(ls_null)

SELECT dbo.fn_strength(:ps_form_rxcui)
INTO :ls_return
FROM c_1_record;
if not check() then return ls_null


return ls_return

end function

public subroutine execute_sql_script (string ps_string, boolean pb_abort_on_error, ref str_sql_script_status pstr_status);integer li_sts
string ls_error
datetime ldt_now
str_scripts lstr_scripts
long i
string ls_err_mes
blob lbl_script
string ls_completion_status
long ll_error_index
integer li_please_wait_index

setnull(ls_error)
setnull(ll_error_index)

pstr_status = f_empty_sql_script_status()

ls_completion_status = "OK"

ldt_now = datetime(today(), now())

////////////////////////////////////////////
// Perform "always available" substitutions
////////////////////////////////////////////

// If the script contains a reference to "jmjtech.epro_40_synch.", then
// substitute the actual remote server and database names
ps_string = f_string_substitute(ps_string, "jmjtech.epro_40_synch.", remote_server + "." + remote_database + ".")



///////////////////////////////////////////////
// Parse the script and execute each GO-Block 
//////////////////////////////////////////////

lstr_scripts = parse_script(ps_string)

for i = 1 to lstr_scripts.script_count
	CHOOSE CASE lower(lstr_scripts.script[i].script_type)
		CASE "sql"
			if pos(lstr_scripts.script[i].script, "tr_Patient_WP_Item_Update") > 0 then
				ls_error = lstr_scripts.script[i].script
				ls_error = lstr_scripts.script[i].script
			end if
			
			EXECUTE IMMEDIATE :lstr_scripts.script[i].script USING this ;
			if sqlcode < 0 then
				// sqldbcode = 999 and sqlcode = -1 means that a "Print" statement was executed
				if sqldbcode = 999 and sqlcode = -1 then
					deadlock = false
				else
					ls_error = sqlerrtext
					ls_completion_status = "Error"
					ll_error_index = i
					ls_err_mes = "Error Executing SQL Statement:~r~n"
					ls_err_mes += lstr_scripts.script[i].script + "~r~n" 
					ls_err_mes += "SQL ERROR = (" + string(sqldbcode) + ") " + sqlerrtext
					if pb_abort_on_error then
						exit
					else
						// Log a warning but continue
						log.log(this, "u_sqlca.execute_sql_script:0061", ls_err_mes, 3)
					end if
				end if
			else
				deadlock = false
			end if
		CASE ELSE
			log.log(this, "u_sqlca.execute_sql_script:0068", "Invalid script_type (" + lstr_scripts.script[i].script_type + ")", 3)
	END CHOOSE
next

if isnull(ll_error_index) then
	pstr_status.status = 1
else
	pstr_status.status = -1
	pstr_status.error_index = ll_error_index
	pstr_status.error_message = ls_error
end if

return


end subroutine

event constructor;
deadlock = false
transaction_open = false
transaction_level = 0
autocommit = true
connected = false

setnull(servername)


end event

on u_sqlca.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_sqlca.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

