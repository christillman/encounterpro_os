$PBExportHeader$u_sqlca_dbmaint.sru
forward
global type u_sqlca_dbmaint from u_sqlca
end type
end forward

global type u_sqlca_dbmaint from u_sqlca
end type
global u_sqlca_dbmaint u_sqlca_dbmaint

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
public function integer dbmaint_connect_sql (string ps_server, string ps_username, string ps_password)
public function integer dbmaint_connect_windows (string ps_server)
public function integer create_database (str_new_database pstr_new_database)
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

public function integer dbmaint_connect_sql (string ps_server, string ps_username, string ps_password);integer li_sts
string ls_sql
string ls_current_user
string ls_dbparm
string ls_dbms
string ls_message

if isnull(mylog) or not isvalid(mylog) then mylog = log

if isnull(servername) then set_server(ps_server)

// Set sqlcode = 1 before connection to database is made
sqlcode = 1

if isnull(ps_server) or trim(ps_server) = "" then
	openwithparm(w_pop_message, "Please enter a server name or address")
	return -1
end if

dbms = "SNC"
servername = ps_server
database = "master"
logid = ps_username
logpass = ps_password
appname = "EproDBMaint"

dbparm = ""

dbparm += "Database='" + database + "'"
dbparm += ",AppName='" + appname + "'"
dbparm += ",Identity='SCOPE_IDENTITY()'"

// Save the dbparm at this point
ls_dbparm = dbparm
connected = false

CONNECT USING this; 
if SQLCode = 0 then
	autocommit = true
	connected = true
	connected_using = "SQL"
	return 1
end if

openwithparm(w_pop_message, sqlerrtext)
return -1

end function

public function integer dbmaint_connect_windows (string ps_server);integer li_sts
string ls_sql
string ls_current_user
string ls_dbparm
string ls_dbms
string ls_message

if isnull(mylog) or not isvalid(mylog) then mylog = log

if isnull(servername) then set_server(ps_server)

// Set sqlcode = 1 before connection to database is made
sqlcode = 1

if isnull(ps_server) or trim(ps_server) = "" then
	openwithparm(w_pop_message, "Please enter a server name or address")
	return -1
end if

dbms = "SNC"
servername = ps_server
database = "master"
appname = "EproDBMaint"

dbparm = ""

dbparm += "Database='" + database + "'"
dbparm += ",AppName='" + appname + "'"
dbparm += ",Identity='SCOPE_IDENTITY()'"
dbparm += ",TrustedConnection=1"

// Save the dbparm at this point
ls_dbparm = dbparm
connected = false

CONNECT USING this; 
if SQLCode = 0 then
	autocommit = true
	connected = true
	connected_using = "Windows"
	return 1
end if

openwithparm(w_pop_message, sqlerrtext)
return -1

end function

public function integer create_database (str_new_database pstr_new_database);integer li_sts
string ls_sql
str_sql_script_status lstr_status
long ll_count
string ls_default_masterpath
str_filepath lstr_filepath
string ls_default_path

 pstr_new_database.database_name =  trim(pstr_new_database.database_name)

if isnull(pstr_new_database.database_name) or pstr_new_database.database_name = "" then
	openwithparm(w_pop_message, "No database name provided")
	return -1
end if

SELECT count(*)
INTO :ll_count
FROM master..sysdatabases
WHERE name = :pstr_new_database.database_name;
if sqlca.sqlcode <> 0 then
	openwithparm(w_pop_message, "An error occured checking for the existince of this database")
	return -1
end if
if ll_count > 0 then
	openwithparm(w_pop_message, "The database ~"" + pstr_new_database.database_name + "~" already exists on this server.")
	return -1
end if

select top 1 filename
INTO :ls_default_masterpath
from master..sysfiles f
	inner join master..sysfilegroups g
	on f.groupid = g.groupid
where g.groupname = 'primary';
if sqlca.sqlcode <> 0 or isnull(ls_default_masterpath) or trim(ls_default_masterpath) = "" then
	openwithparm(w_pop_message, "An error occured checking for the default filepath")
	return -1
end if

lstr_filepath = f_parse_filepath2(ls_default_masterpath)

ls_default_path = lstr_filepath.drive + "\" + lstr_filepath.directory

if isnull(pstr_new_database.primary_path) or trim(pstr_new_database.primary_path) = "" then pstr_new_database.primary_path = ls_default_path
if isnull(pstr_new_database.attachments_path) or trim(pstr_new_database.attachments_path) = "" then pstr_new_database.attachments_path = ls_default_path
if isnull(pstr_new_database.workflow_path) or trim(pstr_new_database.workflow_path) = "" then pstr_new_database.workflow_path = ls_default_path
if isnull(pstr_new_database.log_path) or trim(pstr_new_database.log_path) = "" then pstr_new_database.log_path = ls_default_path

if isnull(pstr_new_database.initial_data_size) or pstr_new_database.initial_data_size <= 0 then pstr_new_database.initial_data_size = 100
if isnull(pstr_new_database.initial_attachments_size) or pstr_new_database.initial_attachments_size <= 0 then pstr_new_database.initial_attachments_size = 100
if isnull(pstr_new_database.initial_workflow_size) or pstr_new_database.initial_workflow_size <= 0 then pstr_new_database.initial_workflow_size = 100
if isnull(pstr_new_database.initial_log_size) or pstr_new_database.initial_log_size <= 0 then pstr_new_database.initial_log_size = 100

// Construct the CREATE statement
ls_sql = 'CREATE DATABASE ' + pstr_new_database.database_name
ls_sql += ' ON PRIMARY ( '
ls_sql += ' 	NAME = cpr_data, '
ls_sql += ' 	FILENAME = ~''+ pstr_new_database.primary_path + '\' + pstr_new_database.database_name + '_data.mdf, '
ls_sql += ' 	SIZE = ' + string(pstr_new_database.initial_data_size) + 'MB, '
ls_sql += ' 	FILEGROWTH = 15% ), '
ls_sql += ' FILEGROUP ATTACHMENTS ( '
ls_sql += ' 	NAME = cpr_attachments, '
ls_sql += ' 	FILENAME = ~''+ pstr_new_database.attachments_path + '\' + pstr_new_database.database_name + '_atch.ndf, '
ls_sql += ' 	SIZE = ' + string(pstr_new_database.initial_attachments_size) + 'MB, '
ls_sql += ' 	FILEGROWTH = 15% ), '
ls_sql += ' FILEGROUP Workflow ( '
ls_sql += ' 	NAME = cpr_workflow, '
ls_sql += ' 	FILENAME = ~''+ pstr_new_database.workflow_path + '\' + pstr_new_database.database_name + '_wf.ndf, '
ls_sql += ' 	SIZE = ' + string(pstr_new_database.initial_workflow_size) + 'MB, '
ls_sql += ' 	FILEGROWTH = 15% ) '
ls_sql += ' LOG ON ( '
ls_sql += ' 	NAME = cpr_log, '
ls_sql += ' 	FILENAME = ~''+ pstr_new_database.log_path + '\' + pstr_new_database.database_name + '_log.ldf, '
ls_sql += ' 	SIZE = ' + string(pstr_new_database.initial_log_size) + 'MB, '
ls_sql += ' 	FILEGROWTH = 15% ) '

li_sts = execute_string(ls_sql)
if li_sts <= 0 then return -1


return 1

end function

on u_sqlca_dbmaint.create
call super::create
end on

on u_sqlca_dbmaint.destroy
call super::destroy
end on

