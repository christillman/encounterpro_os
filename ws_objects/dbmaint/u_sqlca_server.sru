HA$PBExportHeader$u_sqlca_server.sru
forward
global type u_sqlca_server from u_sqlca
end type
end forward

global type u_sqlca_server from u_sqlca
end type
global u_sqlca_server u_sqlca_server

type prototypes


FUNCTION long	 config_cancel_checkout(string ps_config_object_id,string ps_checked_out_by) RPCFUNC ALIAS FOR "config_cancel_checkout"
FUNCTION long	 config_checkin(string ps_config_object_id, string ps_version_description, blob pbl_objectdata, string ps_checked_out_by) RPCFUNC ALIAS FOR "config_checkin"
FUNCTION long	 config_checkout(string ps_config_object_id, string ps_version_description, string ps_checked_out_by) RPCFUNC ALIAS FOR "config_checkout"
FUNCTION long	 config_create_object(string ps_config_object_id, string ps_config_object_type, string ps_description, string ps_long_description, string ps_config_object_category, blob pbl_objectdata, string ps_created_by) RPCFUNC ALIAS FOR "config_create_object"
FUNCTION long	 config_create_object_version(string ps_config_object_id, string ps_config_object_type, string ps_context_object, long pl_owner_id, string ps_description, string ps_long_description, string ps_config_object_category, long pl_version, blob pbl_objectdata, string ps_created_by, string ps_status, string ps_version_description) RPCFUNC ALIAS FOR "config_create_object_version"
FUNCTION long	 config_download_library_object(string ps_config_object_id, long pl_version, string ps_created_by) RPCFUNC ALIAS FOR "config_download_library_object"
FUNCTION long	 config_sync_library() RPCFUNC ALIAS FOR "config_sync_library"

FUNCTION long	 jmj_document_order_workplan(string ps_cpr_id, string ps_context_object, long pl_object_key, string ps_purpose, string ps_new_object, string ps_ordered_by, string ps_created_by, string ps_workplan_description) RPCFUNC ALIAS FOR "jmj_document_order_workplan"

FUNCTION long	 jmj_new_datafile(string ps_description, string ps_context_object , string ps_component_id , string ps_created_by , string ps_status , string ps_long_description , REF string ps_report_id) RPCFUNC ALIAS FOR "jmj_new_datafile"

FUNCTION long jmj_order_document_from_material(string ps_cpr_id, long pl_encounter_id, string ps_context_object, long pl_object_key, string ps_report_id, string ps_dispatch_method, string ps_ordered_for, long pl_patient_workplan_id, string ps_description, string ps_ordered_by, string ps_created_by, long pl_material_id) RPCFUNC ALIAS FOR "jmj_order_document"

FUNCTION long	 jmj_set_treatment_observation_billing(string ps_cpr_id, long pl_encounter_id, long pl_treatment_id, string ps_created_by) RPCFUNC ALIAS FOR "jmj_set_treatment_observation_billing"

FUNCTION long	 jmj_treatment_type_set_default_mode(string ps_office_id, string ps_treatment_type, string ps_treatment_mode, string ps_created_by) RPCFUNC ALIAS FOR "jmj_treatment_type_set_default_mode"

FUNCTION long	 jmj_upload_config_object(string ps_config_object_id, long pl_version, string ps_user_id) RPCFUNC ALIAS FOR "jmj_upload_config_object"

FUNCTION long	 jmj_upload_params(string ps_id) RPCFUNC ALIAS FOR "jmj_upload_params"

FUNCTION long sp_new_display_script_command(long pl_display_script_id, string ps_context_object, string ps_display_command, long pl_sort_sequence, string ps_status) RPCFUNC ALIAS FOR "sp_new_display_script_command"

FUNCTION string fn_lookup_user_IDValue(long pl_owner_id, string ps_IDDomain, string ps_IDValue) RPCFUNC ALIAS FOR "fn_lookup_user_IDValue"
FUNCTION string fn_user_property(string ps_user_id, string ps_progress_type, string ps_progress_key) RPCFUNC ALIAS FOR "fn_user_property"

end prototypes

forward prototypes
public function string fn_user_in_room (string ps_room_id)
end prototypes

public function string fn_user_in_room (string ps_room_id);
//FUNCTION string fn_patient_full_name (string ps_cpr_id) RPCFUNC ALIAS FOR "fn_patient_full_name"
string ls_return
string ls_null

setnull(ls_null)

SELECT dbo.fn_user_in_room(:ps_room_id)
INTO :ls_return
FROM c_1_record;
if not check() then return ls_null


return ls_return



end function

on u_sqlca_server.create
call super::create
end on

on u_sqlca_server.destroy
call super::destroy
end on

