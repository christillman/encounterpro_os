$PBExportHeader$server.sra
forward
global type server from application
end type
global u_sqlca_server sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
///////////////////////////////////////////////////////////
// !!!! Change these values for every compile !!!!
long minimum_modification_level = 143
string build = "1"
date compile_date = date("5/24/2010")
///////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////
integer major_release = 6
string database_version = "1"
////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////
// DB Version this client is compatible with
string my_sql_version = "4.05"
////////////////////////////////////////////////////////////

boolean shutting_down = false

string registry_key
string ini_file
string program_directory
string cpr_mode = "NA"
string eml
string computername
string servicename
long computer_id
string windows_logon_id
string month_str[12] = {"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"}
w_window_base main_window
w_image_objects object_window
boolean just_logged_on
//integer password_length = 3
//boolean variable_password_length = false
string system_user_id = "#SYSTEM"
string logon_id = "jmjtech"
date immunization_date_of_birth = date("1/1/1980")
string office_id
string office_description
long default_group_id
boolean config_mode
boolean rtf_debug_mode
boolean trace_mode
string decimal_character = "."
string default_rtf_font_name = "Times New Roman"

boolean enable_contraindication_checking = false
string contraindication_external_source = "Contraindication"

str_font_settings abnormal_result_font_settings

str_event_log_entry last_error

long temp_file_count

integer default_attachment_picture_width = 92
integer main_height = 1921
integer main_width = 2926

// Re-activation period
integer reactdays = 7

// Current unit preference (ENGLISH, METRIC)
string unit_preference = "METRIC"
string original_unit_preference = "METRIC"

// Current service
u_component_service current_service

// Current Patient
u_patient current_patient_hold
u_patient current_patient

// Currently displayed encounter
u_str_encounter current_display_encounter

// Current user object - user performing service
u_user current_user

// Current user object - user actually charting
u_user current_scribe

// If this computer is in a room, this is the room object
u_room current_room

// If the user is viewing a room, this is the room object
u_room viewed_room

string CNST_TREATMENT_CLOSED = "CLOSED"
string CNST_WEIGHT_OBSERVATION = "WGT"

long COLOR_LIGHT_BLUE = rgb(164, 200, 240)
long COLOR_BLUE = rgb(0,64,128)
long COLOR_DARK_BLUE = rgb(0, 0, 128)
long COLOR_BUTTON = rgb(214, 211, 206)
long COLOR_LIGHT_GREY = rgb(192, 192, 192)
long COLOR_DARK_GREY = rgb(128, 128, 128)
long COLOR_LIGHT_YELLOW = rgb(255, 255, 128)
long COLOR_BLACK = rgb(0,0,0)
long COLOR_RED = rgb(255,0,0)
long COLOR_GREEN = rgb(0, 128, 128)
long COLOR_WHITE = rgb(255,255,255)
long COLOR_BEIGE = rgb(239,230,222)
long COLOR_BROWN = rgb(196,164,134)
long COLOR_EPRO_BLUE = rgb(192,192,255)

///////////////////////////////////////////////////
// Preferences

integer logon_timeout
integer refresh_timer
integer db_reconnect_retries=10

boolean auto_patient_select = false
boolean auto_room_select = false
boolean computer_secure
boolean rx_use_signature_stamp = false
boolean bill_test_collection

string date_format_string = "[shortdate]"
string time_format_string = "[time]"
string followup_specialty = "FOLLOWUP"
string default_encounter_type = "WELL"
string temp_path = "C:\TEMP"
string debug_path = "C:\TEMP\EproDebug"
string temp_image = "tmpimg.tif"
string rx_gravityprompt
string vaccine_gravityprompt
string encounter_gravityprompt

long COLOR_BACKGROUND = rgb(192,192,255)
long COLOR_TEXT_NORMAL
long COLOR_TEXT_WARNING
long COLOR_TEXT_ERROR
long COLOR_OBJECT
long COLOR_OBJECT_SELECTED

long color_service_ordered

string object_file_server
string object_file_path

// End of preferences
//////////////////////////////////////////////
// data list controller
u_list_data datalist

// Drug database interface
u_component_drug drugdb

// Patient list
//u_patient_list patient_list

// Parent object for development history
//u_stage_list stage_list

// Parent object for vaccines and immunizations
u_vaccine_list vaccine_list

// Log Controller Object
u_event_log log
//u_log_controller log

// Component Service Manager
u_component_manager component_manager

// User List
u_component_security user_list

// Room List
u_room_list room_list

// Service List
u_service_list service_list

// Unit List
u_unit_list unit_list

// Location Domain List
//u_location_domain_list location_domain_list

// Generic datastore for loading data
u_ds_data temp_datastore

///////////////////////////////////////////
// global datawindow controls
//u_ds_data dw_data
//u_ds_data dw_data_development
//u_ds_data dw_data_dev_stages
//u_ds_data dw_data_dev_items
//u_ds_data dw_data_report_queue

///////////////////////////////////////////
// Global Other Controls

u_pb_picture_control pb_picture_control

/////////////////////////////////////////
// Holding list values
string holding_list_cpr_id = "JMJCPR00"
long holding_list_attachment_id = 1

/////////////////////////////////////////
// System Preferences
integer system_preference_count
str_preference system_preferences[]

//////////////////////////////////////////
// Billing System Variables
//u_billing_system billing_system
//string billing_system_id


//////////////////////////////////////////
// Shared object for communicating between
// the server application and server shared objects
//u_epparms epparms

//u_file_compression file_compression
//u_mmserver mmserver
u_common_thread common_thread

// Service control manager
//u_service_control_manager scm

u_msscript msscript

// Trace settings
boolean trc_ActESql = true
boolean trc_ActRoutine = true
boolean trc_ActUser = true
boolean trc_ActError = true
boolean trc_ActLine = true
boolean trc_ActObjectCreate = true
boolean trc_ActObjectDestroy = true
boolean trc_ActGarbageCollect = true
TimerKind trc_Timerkind = Clock!

// WAPI interface object
u_windows_api windows_api


end variables

global type server from application
string appname = "server"
end type
global server server

type prototypes
// Cursor Functions
SUBROUTINE GetCursorPos( ref str_point lppt ) LIBRARY "USER32.DLL" alias for "GetCursorPos;Ansi"
FUNCTION long SetWindowPos(long hwnd, long hWndInsertAfter, long x, long y, long cx, long cy, long wFlags) LIBRARY "USER32.DLL"
FUNCTION boolean GetWindowRect( long hwnd, ref str_rect rect) LIBRARY "USER32.DLL" alias for "GetWindowRect;Ansi"
Function ulong GetModuleFileNameA( ulong hInst, REF string lpszPath, ulong cchPath ) LIBRARY "kernel32.dll" alias for "GetModuleFileNameA;Ansi"

// Window Functions
Function boolean UpdateWindow(long hWnd)  library "USER32.DLL"
Function boolean EnableWindow(long hWnd, boolean bEnable)  library "USER32.DLL"
Function boolean IsWindowEnabled(long hWnd)  library "USER32.DLL"
Function ulong SetCursor(ulong hCursor) library "user32.dll"
FUNCTION long GetForegroundWindow() library "user32.dll"
FUNCTION long GetActiveWindow() library "user32.dll"


end prototypes

type variables
boolean test_mode = false
boolean test_loop_forever = false

end variables

forward prototypes
public function integer do_schedule_item (long pl_service_sequence)
public function integer do_workplan_item (long pl_patient_workplan_item_id)
public function integer do_document_send (long pl_patient_workplan_item_id)
public function integer do_incoming (long pl_patient_workplan_item_id)
public function integer do_receiver (long pl_patient_workplan_item_id)
public function integer do_server_item (string ls_mode, long pl_argument)
public function integer do_all_server_items ()
public function boolean check_started_count (long pl_patient_workplan_item_id)
public function integer do_document_create (long pl_patient_workplan_item_id)
end prototypes

public function integer do_schedule_item (long pl_service_sequence);string ls_status,ls_logon
long ll_count
long i
u_ds_data luo_service_attributes
integer li_sts
str_attributes lstr_attributes
string ls_service
long ll_attribute_count
datetime ldt_last_successful_date
datetime ldt_last_service_date
datetime ldt_service_date

luo_service_attributes = CREATE u_ds_data
luo_service_attributes.set_dataobject("dw_o_Service_Schedule_Attribute")

	
SELECT service,
		last_service_date,
		last_successful_date,
		getdate()
INTO :ls_service,
		:ldt_last_service_date,
		:ldt_last_successful_date,
		:ldt_service_date
FROM o_Service_Schedule
WHERE user_id = :current_user.user_id
AND service_sequence = :pl_service_sequence;
if not tf_check() then return -1


// Get the attributes
ll_attribute_count = luo_service_attributes.retrieve(current_user.user_id, pl_service_sequence)
if ll_attribute_count < 0 then
	log.log(this,"do_scheduled_service()","error getting service attributes (" + current_user.user_id + ", " + string(pl_service_sequence) + ")",4)
	return -1
end if
lstr_attributes.attribute_count = 0
f_attribute_ds_to_str(luo_service_attributes, lstr_attributes)

// Add the service date and the last successful date to the attributes
f_attribute_add_attribute(lstr_attributes, "service_date", string(ldt_service_date))
f_attribute_add_attribute(lstr_attributes, "last_successful_service_date", string(ldt_last_successful_date))

// Mark the service as started so it doesn't get selected again
UPDATE o_Service_Schedule
SET last_service_date = :ldt_service_date,
	last_service_status = 'Started'
WHERE user_id = :current_user.user_id
AND service_sequence = :pl_service_sequence;
if not tf_check() then return -1

// Execute the service
li_sts = service_list.do_service(ls_service, lstr_attributes)
if li_sts < 0 then
	ls_status = "ERROR"
	UPDATE o_Service_Schedule
	SET last_service_status = :ls_status
	WHERE user_id = :current_user.user_id
	AND service_sequence = :pl_service_sequence;
	if not tf_check() then return -1
else
	ls_status = "COMPLETED"
	UPDATE o_Service_Schedule
	SET last_service_status = :ls_status,
		last_successful_date = :ldt_service_date
	WHERE user_id = :current_user.user_id
	AND service_sequence = :pl_service_sequence;
	if not tf_check() then return -1
end if


DESTROY luo_service_attributes


return 1

end function

public function integer do_workplan_item (long pl_patient_workplan_item_id);integer li_sts
string ls_active_service_flag

// Make sure this service is still active before we execute it
SELECT active_service_flag
INTO :ls_active_service_flag
FROM p_Patient_WP_Item
WHERE patient_workplan_item_id = :pl_patient_workplan_item_id;
if not tf_check() then return -1

if upper(ls_active_service_flag) = "Y" then
	if check_started_count(pl_patient_workplan_item_id) then
		// too many retries
		return 1
	end if
	
	TRY
		li_sts = service_list.do_service(pl_patient_workplan_item_id)
	CATCH (throwable lt_error)
		log.log(this, "do_incoming()", "Error calling do_service (" + string(pl_patient_workplan_item_id) + ", " + lt_error.text + ")", 4)
		li_sts = -1
		// If it throws an error then we definately want to make sure we log an error, even at the risk of double logging
		sqlca.jmj_set_service_error(pl_patient_workplan_item_id, &
											current_user.user_id, &
											current_scribe.user_id, &
											"N", &
											computer_id)
		tf_check()		
	END TRY
	if li_sts < 0 then
		log.log(this, "initialize()", "Error performing service (" + string(pl_patient_workplan_item_id) + ")", 4)
	elseif li_sts = 0 then
		log.log(this, "initialize()", "service reported ~"not performed~" (" + string(pl_patient_workplan_item_id) + ")", 4)
	end if
else
	// Workplan item is not ready.  This means that some other thread processed it in between the jmj_ready_services call and this execution
	return 1
end if

return 1

end function

public function integer do_document_send (long pl_patient_workplan_item_id);integer li_sts
string ls_status
u_component_wp_item_document luo_document

// Make sure this service is still active before we execute it
SELECT status
INTO :ls_status
FROM p_Patient_WP_Item
WHERE patient_workplan_item_id = :pl_patient_workplan_item_id;
if not tf_check() then return -1

if upper(ls_status) = "READY" then
	if check_started_count(pl_patient_workplan_item_id) then
		// too many retries
		return 1
	end if
	
	TRY
		luo_document = CREATE u_component_wp_item_document
		luo_document.initialize(pl_patient_workplan_item_id)
		li_sts = luo_document.document_send()
	CATCH (throwable lt_error)
		log.log(this, "do_document_send()", "Error calling document_send (" + string(pl_patient_workplan_item_id) + ", " + lt_error.text + ")", 4)
		li_sts = -1
		// If we catch an exception then make sure we log an error, even risking a double error logging
		sqlca.jmj_set_document_error(pl_patient_workplan_item_id, &
											"Send", &
											current_user.user_id, &
											computer_id)
		tf_check()
	END TRY
	
	if li_sts <= 0 then
		log.log(this, "do_document_send()", "Error sending document (" + string(pl_patient_workplan_item_id) + ")", 4)
	end if
	
	DESTROY luo_document
	
	if li_sts <= 0 then
		return -1
	end if
else
	// Workplan item is not ready.  This means that some other thread processed it in between the jmj_ready_services call and this execution
	return 1
end if

return 1

end function

public function integer do_incoming (long pl_patient_workplan_item_id);string ls_null
integer li_sts
string ls_status
u_component_wp_item_document luo_document
long ll_attachment_id
str_external_observation_attachment lstr_attachment
string ls_xml
u_xml_document lo_xml_document
str_complete_context lstr_context
str_complete_context lstr_document_context
boolean lb_posted

setnull(ls_null)

lb_posted = false

// Make sure this service is still active before we execute it
SELECT status, attachment_id
INTO :ls_status, :ll_attachment_id
FROM p_Patient_WP_Item
WHERE patient_workplan_item_id = :pl_patient_workplan_item_id;
if not tf_check() then return -1

if upper(ls_status) = "READY" then
	if check_started_count(pl_patient_workplan_item_id) then
		// too many retries
		return 1
	end if
	
	li_sts = f_get_attachment(ll_attachment_id, lstr_attachment)
	if li_sts < 0 then GOTO Done
	
	if lower(lstr_attachment.extension) = "xml" then
		TRY
			ls_xml = string(lstr_attachment.attachment)
			li_sts = f_get_xml_document(ls_xml, lo_xml_document)
			if li_sts < 0 then
				log.log(this, "do_incoming()", "Error reading document as XML (" + string(pl_patient_workplan_item_id) + ")", 4)
			else
				lstr_context = f_empty_context()
				lstr_context.attachment_id = ll_attachment_id
				li_sts = lo_xml_document.interpret(lstr_context, lstr_document_context)
			end if
		CATCH (throwable lt_error )
			log.log(this, "do_incoming()", "Error interpreting document (" + string(pl_patient_workplan_item_id) + ", " + lt_error.text + ")", 4)
			li_sts = -1
		END TRY
		if li_sts > 0 then
			// If we get here then we may have context information that has not been updated to the p_Attachment table yet
			UPDATE p_Attachment
			SET cpr_id = :lstr_document_context.cpr_id,
				encounter_id = :lstr_document_context.encounter_id,
				problem_id = :lstr_document_context.problem_id,
				treatment_id = :lstr_document_context.treatment_id,
				observation_sequence = :lstr_document_context.observation_sequence,
				context_object = :lstr_document_context.context_object,
				object_key = CASE :lstr_document_context.context_object 
											WHEN 'Pateint' THEN NULL 
											WHEN 'Encounter' THEN :lstr_document_context.encounter_id 
											WHEN 'Assessment' THEN :lstr_document_context.problem_id 
											WHEN 'Treatment' THEN :lstr_document_context.treatment_id 
											WHEN 'Observation' THEN :lstr_document_context.observation_sequence 
									ELSE NULL END
			WHERE attachment_id = :ll_attachment_id
			AND (cpr_id = :lstr_document_context.cpr_id OR cpr_id IS NULL);
			if not tf_check() then return -1
			
			lb_posted = true
			sqlca.sp_set_workplan_item_progress(pl_patient_workplan_item_id, current_user.user_id, "Completed", datetime(today(), now()), current_user.user_id, computer_id)
			if not tf_check() then GOTO Done
		else
			sqlca.sp_set_workplan_item_progress(pl_patient_workplan_item_id, current_user.user_id, "Error", datetime(today(), now()), current_user.user_id, computer_id)
			if not tf_check() then GOTO Done
		end if
	else
		// Not xml so no interpretation
		sqlca.sp_set_workplan_item_progress(pl_patient_workplan_item_id, current_user.user_id, "Completed", datetime(today(), now()), current_user.user_id, computer_id)
		if not tf_check() then GOTO Done
	end if
else
	// Workplan item is not ready.  This means that some other thread processed it in between the jmj_ready_services call and this execution
	return 1
end if

Done:

if lb_posted then
	SQLCA.sp_set_attachment_progress( ls_null, &
													ll_attachment_id, &
													pl_patient_workplan_item_id, &
													current_user.user_id, &
													datetime(today(), now()), &
													"Posted", &
													ls_null, &
													current_user.user_id)
	if not tf_check() then return -1
else
	SQLCA.sp_set_attachment_progress( ls_null, &
													ll_attachment_id, &
													pl_patient_workplan_item_id, &
													current_user.user_id, &
													datetime(today(), now()), &
													"ToBePosted", &
													ls_null, &
													current_user.user_id)
	if not tf_check() then return -1
end if

return 1

end function

public function integer do_receiver (long pl_patient_workplan_item_id);integer li_sts
string ls_status
long ll_interfaceserviceid
long ll_transportsequence
string ls_component_id
u_component_document_receiver luo_receiver
u_ds_data luo_data
long ll_count
long i
long ll_incoming_patient_workplan_item_id

// Make sure this service is still active before we execute it
SELECT i.status, r.commcomponent
INTO :ls_status, :ls_component_id
FROM p_Patient_WP_Item i
	INNER JOIN c_Component_Interface_Route r
	ON i.workplan_id = r.interfaceserviceid
	AND i.item_number = r.transportsequence
WHERE i.patient_workplan_item_id = :pl_patient_workplan_item_id;
if not tf_check() then return -1
if sqlca.sqlnrows < 1 then
	log.log(this, "do_receiver()", "Receiver Route not found (" + string(pl_patient_workplan_item_id) + ")", 4)
	sqlca.sp_set_workplan_item_progress(pl_patient_workplan_item_id, current_user.user_id, "Cancelled", datetime(today(), now()), current_user.user_id, computer_id)
	if not tf_check() then return -1
end if

if upper(ls_status) = "DISPATCHED" or upper(ls_status) = "STARTED" then
	if check_started_count(pl_patient_workplan_item_id) then
		// too many retries
		return 1
	end if
	
	luo_receiver = component_manager.get_component(ls_component_id)
	if isnull(luo_receiver) then
		li_sts = -1
	else
		TRY
			li_sts = luo_receiver.get_documents(pl_patient_workplan_item_id)
		CATCH (throwable lt_error)
			log.log(this, "do_receiver()", "Error calling get_documents (" + string(pl_patient_workplan_item_id) + ", " + lt_error.text + ")", 4)
			li_sts = -1
		END TRY
	end if
	
	if li_sts <= 0 then
		sqlca.jmj_set_service_error(pl_patient_workplan_item_id, current_user.user_id, current_user.user_id, "N", computer_id)
		if not tf_check() then return -1
		log.log(this, "do_receiver()", "Error receiving document (" + string(pl_patient_workplan_item_id) + ")", 4)
	end if
		
	component_manager.destroy_component(luo_receiver)
else
	// Workplan item is not ready.  This means that some other thread processed it in between the jmj_ready_services call and this execution
	return 1
end if

// If we actually received some files, let's not wait a whole other polling cycle to process them.  Let's process them now
luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_incoming_documents_for_receiver")
ll_count = luo_data.retrieve(pl_patient_workplan_item_id)

for i = 1 to ll_count
	ll_incoming_patient_workplan_item_id = luo_data.object.patient_workplan_item_id[i]
	
	TRY
		li_sts = do_incoming(ll_incoming_patient_workplan_item_id)
	CATCH (throwable lt_error2)
		log.log(this, "do_receiver()", "Error calling do_incoming (" + string(pl_patient_workplan_item_id) + ", " + lt_error2.text + ")", 4)
		li_sts = -1
	END TRY
next

DESTROY luo_data

UPDATE r
SET lastrun = getdate()
FROM c_Component_Interface_Route r
	INNER JOIN p_Patient_WP_Item i
	ON i.workplan_id = r.interfaceserviceid
	AND i.item_number = r.transportsequence
WHERE i.patient_workplan_item_id = :pl_patient_workplan_item_id;
if not tf_check() then return -1


return 1

end function

public function integer do_server_item (string ls_mode, long pl_argument);integer li_sts


CHOOSE CASE upper(ls_mode)
	CASE "INCOMING"
		// Process a document that has already been received
		li_sts = do_incoming(pl_argument)
		if li_sts < 0 then
			log.log_db(this, "open", "Error processing document (" + string(pl_argument) + ")", 4)
		else
			log.log_db(this, "open", "Successfully processed document (" + string(pl_argument) + ")", 1)
		end if
	CASE "RECEIVER"
		li_sts = do_receiver(pl_argument)
		if li_sts < 0 then
			log.log_db(this, "open", "Error receiving documents (" + string(pl_argument) + ")", 4)
		elseif li_sts = 0 then
			log.log_db(this, "open", "No documents to receive (" + string(pl_argument) + ")", 1)
		else
			log.log_db(this, "open", "Successfully received documents (" + string(pl_argument) + ")", 1)
		end if
	CASE "CREATEDOC"
		li_sts = do_document_create(pl_argument)
		if li_sts < 0 then
			log.log_db(this, "open", "Error creating document (" + string(pl_argument) + ")", 4)
		elseif li_sts = 0 then
			log.log_db(this, "open", "No Document.  Document will be cancelled (" + string(pl_argument) + ")", 1)
		else
			log.log_db(this, "open", "Successfully created document (" + string(pl_argument) + ")", 1)
		end if
	CASE "DOCUMENT"
		li_sts = do_document_send(pl_argument)
		if li_sts < 0 then
			log.log_db(this, "open", "Error sending document (" + string(pl_argument) + ")", 4)
		elseif li_sts = 0 then
			log.log_db(this, "open", "Document not sent (" + string(pl_argument) + ")", 4)
		else
			log.log_db(this, "open", "Successfully sent document (" + string(pl_argument) + ")", 1)
		end if
	CASE "WPITEM"
		li_sts = do_workplan_item(pl_argument)
		if li_sts < 0 then
			log.log_db(this, "open", "Error processing workplan item (" + string(pl_argument) + ")", 4)
		elseif li_sts = 0 then
			log.log_db(this, "open", "Workplan item not processed (" + string(pl_argument) + ")", 4)
		else
			log.log_db(this, "open", "Successfully processed workplan item (" + string(pl_argument) + ")", 1)
		end if
	CASE "SCHEDULE"
		li_sts = do_schedule_item(pl_argument)
		if li_sts < 0 then
			log.log_db(this, "open", "Error processing schedule item (" + string(pl_argument) + ")", 4)
		elseif li_sts = 0 then
			log.log_db(this, "open", "Schedule item not processed (" + string(pl_argument) + ")", 4)
		else
			log.log_db(this, "open", "Successfully processed schedule item (" + string(pl_argument) + ")", 1)
		end if
	CASE "SERVICE", "SERVER"
		li_sts = component_manager.start_service(pl_argument)
		if li_sts < 0 then
			log.log_db(this, "open", "Error processing service item (" + string(pl_argument) + ")", 4)
			return -1
		elseif li_sts = 0 then
			log.log_db(this, "open", "Service item not processed (" + string(pl_argument) + ")", 4)
			return -1
		else
			log.log_db(this, "open", "Successfully processed service item (" + string(pl_argument) + ")", 1)
			return 2 // tell the caller to not halt the program
		end if
	CASE ELSE
		if isnull(ls_mode) then ls_mode = "<NULL>"
		log.log(this, "open", "Invalid Mode (" + ls_mode + ")", 4)
END CHOOSE


return 1


end function

public function integer do_all_server_items ();u_ds_data luo_data
long ll_count
long i
string ls_item_type
long ll_patient_workplan_item_id
string ls_mode
integer li_sts
integer li_index
boolean lb_error


luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_jmjsys_ready_services")

DO
	ll_count = luo_data.retrieve(system_user_id)
	
	li_index = f_please_wait_open()
	
	lb_error = false
	
	for i = 1 to ll_count
		ls_item_type = luo_data.object.item_type[i]
		ll_patient_workplan_item_id = luo_data.object.patient_workplan_item_id[i]
		
		if upper(ls_item_type) = "SERVICE" then
			ls_mode = "WPITEM"
		else
			ls_mode = ls_item_type
		end if
		
		li_sts = do_server_item(ls_mode, ll_patient_workplan_item_id)
		if li_sts < 0 then
			lb_error = true
		end if
		
		f_please_wait_progress_bar(li_index, i, ll_count)
	next
	
	f_please_wait_close(li_index)
	
	if lb_error then return -1
	
LOOP WHILE test_loop_forever

return 1


end function

public function boolean check_started_count (long pl_patient_workplan_item_id);// Returns:
//
// True = Too Many Retries
// False = Retries OK

string ls_item_type
long ll_count
long ll_restart_count_max = 5

// Get the item_type
SELECT item_type
INTO :ls_item_type
FROM p_Patient_WP_Item
WHERE patient_workplan_item_id = :pl_patient_workplan_item_id;
if not tf_check() then return true

// Get the started count
SELECT count(*)
INTO :ll_count
FROM p_Patient_WP_Item_Progress
WHERE patient_workplan_item_id = :pl_patient_workplan_item_id
AND progress_type = 'Starting';
if not sqlca.check() then return true

if ll_count > ll_restart_count_max then
	log.log(this, "check_started_count()", "Too many times starting.  Cancelling item (" + string(pl_patient_workplan_item_id) + ")", 4)
	sqlca.sp_set_workplan_item_progress(pl_patient_workplan_item_id, &
													system_user_id, &
													"Cancelled", &
													datetime(today(), now()), &
													system_user_id, &
													computer_id )
	return true
end if

if lower(ls_item_type) <> "service" then
	// The do_service will issue it's own "started" progress record
	sqlca.sp_set_workplan_item_progress(pl_patient_workplan_item_id, &
													system_user_id, &
													"Starting", &
													datetime(today(), now()), &
													system_user_id, &
													computer_id )
end if


return false // Retries OK



end function

public function integer do_document_create (long pl_patient_workplan_item_id);integer li_sts
string ls_status
u_component_wp_item_document luo_document

// Make sure this service is still active before we execute it
SELECT status
INTO :ls_status
FROM p_Patient_WP_Item
WHERE patient_workplan_item_id = :pl_patient_workplan_item_id;
if not tf_check() then return -1

if upper(ls_status) = "READY" then
	if check_started_count(pl_patient_workplan_item_id) then
		// too many retries
		return 1
	end if
	
	TRY
		luo_document = CREATE u_component_wp_item_document
		luo_document.initialize(pl_patient_workplan_item_id)
		li_sts = luo_document.document_create()
	CATCH (throwable lt_error)
		log.log(this, "do_document_send()", "Error calling document_send (" + string(pl_patient_workplan_item_id) + ", " + lt_error.text + ")", 4)
		li_sts = -1
		// If we catch an exception then make sure we log an error, even risking a double error logging
		sqlca.jmj_set_document_error(pl_patient_workplan_item_id, &
											"Create", &
											current_user.user_id, &
											computer_id)
		tf_check()
	END TRY
	
	if not luo_document.document_created then
		li_sts = luo_document.set_progress("Cancelled")
	end if
	
	DESTROY luo_document
	
	if li_sts <= 0 then
		return -1
	end if
else
	// Workplan item is not ready.  This means that some other thread processed it in between the jmj_ready_services call and this execution
	return 1
end if

return 1

end function

event open;integer li_sts
string ls_parm
environment env
integer rtn
string lsa_subkeys[]
integer li_subkeys
integer i
string ls_apppath
string ls_drive
string ls_dir
string ls_filename
string ls_extension
ulong lul_hinst, lul_maxpath, lul_rc
blob lbl_file
string ls_msg
string ls_arg
long ll_parm_count
string lsa_parm[]
string ls_user
string ls_mode
long ll_argument
long ll_sts
string ls_message
string ls_service_name
string ls_system_user_id
//str_attempt_logon lstr_logon
string ls_attribute
string ls_value
str_service_info lstr_service
long ll_button
string ls_subdirectory

rtn = GetEnvironment(env)

setnull(current_user)
setnull(current_scribe)
setnull(current_patient)
setnull(current_service)
setnull(servicename)

cpr_mode = "SERVER"

ls_parm = trim(upper(commandline))

if ls_parm = "" or left(ls_parm, 1) = "/" then setnull(ls_parm)

if left(ls_parm, 1) = "~""  AND right(ls_parm, 1) = "~"" then
	ls_parm = mid(ls_parm, 2, len(ls_parm) - 2)
end if

ll_parm_count = f_parse_string(ls_parm, ",", lsa_parm)

// Get our application path so we can set the INI file
lul_hinst = Handle( GetApplication() )
lul_maxpath = 260
ls_apppath = Space( lul_maxpath )    // pre-allocate memory
lul_rc = GetModuleFilenameA( lul_hinst, ls_apppath, lul_maxpath )
IF lul_rc > 0 THEN
	f_parse_filepath(ls_apppath, ls_drive, ls_dir, ls_filename, ls_extension)
	program_directory = ls_drive + ls_dir
	ini_file = program_directory + "\EncounterPRO.ini"
else
	program_directory = ""
	ini_file = "EncounterPRO.ini"
END IF

// If no command-line param is supplied, then see where we are to determine the mode
if ll_parm_count < 1 then
	if fileexists(program_directory + "\pb.ini") then
		// If pb.ini exists in the program directory then assume we're in a development environment
		// and ask the user if they want to run in TEST mode.
		ll_button = messagebox("EproServer", "Test Mode?", Question!, YesNo!)
		if ll_button = 1 then
			ls_mode = "TEST"
			test_mode = true
			ll_button = messagebox("EproServer", "Loop Forever?", Question!, YesNo!)
			if ll_button = 1 then
				test_loop_forever = true
			end if
		else
			// If the user doesn't want TEST mode then start DBMAINT mode
			ls_mode = "DBMAINT"
		end if
	else
		// If we're not in a development environment then assume DBMAINT if no params were supplied
		ls_mode = "DBMAINT"
	end if
else
	f_split_string(upper(trim(lsa_parm[1])), "=", ls_mode, ls_arg)
	if isnumber(ls_arg) then
		ll_argument = long(ls_arg)
	elseif lower(ls_mode) <> "epie" then
		log.log(this, "open", "Invalid service argument", 4)
		HALT close
	end if
end if

ls_service_name = "EPRO" + wordcap(ls_mode)

// Initialize the windows API
windows_api = CREATE u_windows_api

// Initialize the utility com objects
common_thread = CREATE u_common_thread
li_sts = common_thread.initialize()
if li_sts <= 0 then halt

// Initialize the logging system
log = CREATE u_event_log
li_sts = log.initialize(ls_service_name)
if li_sts <= 0 then
	halt close
end if

// Get the computername
computername = upper(log.get_computername())

// Get the windows logon_id
windows_logon_id = upper(log.get_userid())

if ll_parm_count < 2 then
	common_thread.default_database = "<Default>"
elseif upper(trim(lsa_parm[2])) = "DEFAULT" then
	common_thread.default_database = "<Default>"
else
	common_thread.default_database = trim(lsa_parm[2])
end if

// If the user was not specified, then assume #JMJ
if ll_parm_count < 3 then
	system_user_id = "#JMJ"
elseif upper(trim(lsa_parm[3])) = "DEFAULT" then
	system_user_id = "#JMJ"
else
	system_user_id = trim(lsa_parm[3])
end if

open(w_image_objects)

if not fileexists(ini_file) then
	lbl_file = blob("")
	log.file_write(lbl_file, ini_file)
end if

// If we're running DB Maintenance do this...
if upper(ls_mode) = "DBMAINT" then
	cpr_mode = "DBMAINT"
	
	// If the caller didn't specify a database, then ask the user
	if ll_parm_count < 2 then
		open(w_pop_which_database)
		common_thread.default_database = message.stringparm
		// If the user didn't pick a database then exit
		if common_thread.default_database = "" then
			halt close
		end if
	end if
	
	// Set the login_id to sa to make sure we log in as a privileged user
	logon_id = "epro_dbo"
	sqlca.connect_approle = false
	
	ll_sts = f_initialize_common(ls_service_name)
	if ll_sts < 0 then
		log.log(this, "open", "Error initializing common", 5)
		halt CLOSE
	end if
	
	if not sqlca.is_dbo then
		ls_message = "You are not logged in as a DBO in the EncounterPRO database."
		ls_message += "  Only a DBO may use the Database Maintenance utilities."
		openwithparm(w_pop_message, ls_message)
		halt CLOSE
	end if
elseif upper(ls_mode) = "TEST" then
	// If the caller didn't specify a database, then ask the user
	if ll_parm_count < 2 then
		open(w_pop_which_database)
		common_thread.default_database = message.stringparm
		// If the user didn't pick a database then exit
		if common_thread.default_database = "" then
			halt close
		end if
	end if
	
	// Set the login_id to sa to make sure we log in as a privileged user
	logon_id = "jmjtech"
	
	ll_sts = f_initialize_common(ls_service_name)
	if ll_sts < 0 then
		log.log(this, "open", "Error initializing common", 5)
		halt CLOSE
	end if
else
	li_sts = f_initialize_common(ls_service_name)
	if li_sts < 0 then
		log.log(this, "open", "Error initializing objects", 4)
		HALT CLOSE
	end if
end if

if upper(ls_mode) = "SERVICE" then
	if ll_argument > 0 then
		// If we're doing a server component, then get the system_user_id from the table
		SELECT service_name,
				system_user_id
		INTO :ls_service_name,
				:ls_system_user_id
		FROM o_Server_Component
		WHERE service_id = :ll_argument;
		if not tf_check() then
			HALT CLOSE
		end if
		if sqlca.sqlcode = 100 then
			// We didn't find the record
			log.log(this, "open", "service_id not found (" + string(ll_argument) + ")", 4)
			HALT CLOSE
		end if
		
		// We found the service so set the user and log system
		li_sts = log.initialize(ls_service_name)
		if len(ls_system_user_id) > 0 then
			system_user_id = ls_system_user_id
		end if
	else
		// We didn't find the record
		log.log(this, "open", "SERVICE mode requires a valid service_id", 4)
		HALT CLOSE
	end if
end if

// Initialize the current_user
//lstr_logon.user_id = system_user_id
//lstr_logon.sticky_logon = true
current_scribe = user_list.set_admin_user(system_user_id)
if isnull(current_scribe) then
	log.log(this, "open", "Error setting admin user (" + system_user_id + ")", 4)
	HALT CLOSE
end if

setnull(current_scribe.sticky_logon)

current_user = current_scribe

if upper(ls_mode) = "DBMAINT" then
	openwithparm(w_pop_message, "The server executable no longer supports DBMaint mode.  Use the EproDBMaint.exe dedicated executable.")
	HALT CLOSE
end if

// Initialize the system objects
li_sts = f_initialize_objects()
if li_sts < 0 then
	HALT close
end if

ls_subdirectory = ls_mode
if ll_argument > 0 then
	ls_subdirectory += "-" + string(ll_argument)
end if
f_set_temp_directory(ls_subdirectory)

cpr_mode = "SERVER"

open(main_window, "w_server_main")

if upper(ls_mode) = "TEST" then
	li_sts = do_all_server_items()
else
	TRY
		li_sts = do_server_item(ls_mode, ll_argument)
	CATCH (throwable lt_error)
		li_sts = -1
	END TRY
end if

if li_sts = 2 then
	// a timer loop has been started, do not halt the program
	return
elseif li_sts >= 0 then
	// Remove the temp directory
	log.delete_files(temp_path + "\*.*")
	removedirectory(temp_path)
	HALT close
else
	HALT close
end if




end event

event close;
if trace_mode then f_stop_tracing()

if isvalid(w_image_objects) then
	close(w_image_objects)
end if

if isvalid(component_manager) and not isnull(component_manager) then
	DESTROY component_manager
end if

if isvalid(log) and not isnull(log) then
	log.shutdown()
	DESTROY log
end if

if not isnull(common_thread) and isvalid(common_thread) then
	common_thread.shutdown()
	DESTROY common_thread
end if


end event

on systemerror;f_system_error()

end on

on server.create
appname="server"
message=create message
sqlca=create u_sqlca_server
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on server.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

