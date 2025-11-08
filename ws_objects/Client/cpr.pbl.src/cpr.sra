$PBExportHeader$cpr.sra
forward
global type cpr from application
end type
global u_sqlca sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables

cpr gnv_app

string month_str[12] = {"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"}
w_main main_window
boolean just_logged_on
//integer password_length = 3
//boolean variable_password_length = false
string system_user_id = "#SYSTEM"
string logon_id = "jmjtech"
date immunization_date_of_birth = date("1/1/1980")
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
long posted_encounter_id

// Current user object - user performing service
u_user current_user

// Current user object - user actually charting
u_user current_scribe

// If this computer is in a room, this is the room object
u_room current_room

// If the user is viewing a room, this is the room object
u_room viewed_room

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

string date_format_string = "[shortdate]"
string time_format_string = "[time]"
// Necessary to avoid errors if the regional settings are d/m/y
// because SQL server is always m/d/y
string db_datetime_format = "yyyy-mm-dd hh:mm:ss"
string db_date_format = "yyyy-mm-dd"
string default_encounter_type = "WELL"
string temp_path = "C:\Temp\Epro"
string debug_path = "C:\Temp\EproDebug"
// rgb(192,192,255) classic purple (EPRO_BLUE)
// You need to change background color using global-replace in the
// text source files, and then Refresh at the root of the app.
// PB rewrites user object properties with the hard coded value
// whenever you open an object and save.
// long COLOR_BACKGROUND = rgb(165,188,109) // 7191717
long COLOR_TEXT_NORMAL
long COLOR_TEXT_WARNING
long COLOR_TEXT_ERROR
long COLOR_OBJECT
long COLOR_OBJECT_SELECTED

string object_file_server
string object_file_path

// End of preferences
//////////////////////////////////////////////
// data list controller
u_list_data datalist

// Drug database interface
u_component_drug drugdb

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

u_common_thread common_thread

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

// In functions, "this" often causes a null refrence exception in PB17. 
// Replace with po_null.
powerobject po_null

// Set using Ctrl-D on a display script in the treeview. Then when debugging with Powerbuilder,
// it will break at that display script. 
long debug_display_script_id
long debug_display_command_id

end variables

global type cpr from application
string appname = "cpr"
string themepath = "C:\Program Files (x86)\Appeon\PowerBuilder 19.0\IDE\theme"
string themename = "Do Not Use Themes"
boolean nativepdfvalid = false
boolean nativepdfincludecustomfont = false
string nativepdfappname = ""
long richtextedittype = 5
long richtexteditx64type = 5
long richtexteditversion = 3
string richtexteditkey = ""
string appicon = "green-olive-avi-02.ico"
string appruntimeversion = "22.2.0.3441"
boolean manualsession = false
boolean unsupportedapierror = false
boolean ultrafast = false
boolean bignoreservercertificate = false
uint ignoreservercertificate = 0
long webview2distribution = 0
boolean webview2checkx86 = false
boolean webview2checkx64 = false
string webview2url = "https://developer.microsoft.com/en-us/microsoft-edge/webview2/"
event keydown pbm_keydown
end type
global cpr cpr

type prototypes
Function ulong GetModuleFileNameA( ulong hInst, REF string lpszPath, ulong cchPath ) LIBRARY "kernel32.dll" alias for "GetModuleFileNameA;Ansi"

// Window Functions
Function boolean EnableWindow(ulong hWnd, boolean bEnable)  library "USER32.DLL"
Function boolean IsWindowEnabled(ulong hWnd)  library "USER32.DLL"

end prototypes

type variables


string product_name = 'GreenOlive EHR'
string client_link_start
boolean is_demo_version

///////////////////////////////////////////////////////////
// !!!! Change these values for every compile !!!!

long target_modification_level = 233

date compile_date = date("2025-04-25")

integer major_release = 7
string database_version = "3" // this is really minor release
string build = "0.0"
// Resulting in 7.3.0.0

/// !!! Remember to also change this in markbuild project entry spots
//  7   3  0  0

// Using Powerbuilder Runtime 22.2.0.3441

////////////////////////////////////////////////////////////

string copyright = "Copyright 1994-2025 The EncounterPRO Foundation, Inc."
string source_url = "https://github.com/christillman/encounterpro_os"

////////////////////////////////////////////////////////////
// DB Version this client is compatible with.
string my_sql_version = "4.05"
////////////////////////////////////////////////////////////

string registry_key
string ini_file
string program_directory
string program_filename
string cpr_mode = "NA"
string computername
string servicename
long computer_id
string office_id
string windows_logon_id

// Don't get your hopes up; only a couple of locales are supported
// so far, and only in a limited way!
// en-US: as originally built
// en-RW, en-UG, en-KE: starting support for African countries
string locale
end variables

event keydown;//f_fkey_handler(key, keyflags)


end event

event open;
integer li_sts
string ls_parm, ls_arg, ls_disk_check, ls_msg
string ls_regKey = "HKEY_CURRENT_USER\Control Panel\International"
blob lbl_script

// Have seen failure of SQLCA creation in create event.
// Re-create here.
sqlca = create u_sqlca

cpr_mode = "CLIENT"

setnull(current_user)
setnull(current_scribe)
setnull(current_patient)
setnull(current_service)
setnull(servicename)
setnull(po_null)
gnv_app = this

ls_parm = trim(upper(commandline))
if ls_parm = "" or left(ls_parm, 1) = "/" then setnull(ls_parm)

// Initialize the windows API
windows_api = CREATE u_windows_api
RegistryGet(ls_regKey, "LocaleName", RegString!, locale)

// ls_disk_check = "mkdir ck123 && diskusage ck123 | findstr /C:""disk in use"" && rmdir ck123 > C:\Temp\diskusage.txt"
// needs to execute with admin priivilege

// Create the log object
log = CREATE u_event_log

// Initialize the utility com objects
common_thread = CREATE u_common_thread
li_sts = common_thread.initialize()
if li_sts <= 0 then HALT CLOSE

this.client_link_start  = "https://github.com/christillman/encounterpro_os/releases/download/v" + string(target_modification_level) + "/" + f_string_substitute(gnv_app.product_name," ","_") + "_Install_"
// Moved application path so we can set the INI file into common_thread.initialize()
// Moved Initialize the logging system into common_thread.initialize()

// log.log(this, "cpr.open", "Starting up", 1)

// If no command-line param is supplied, then check the registry
if isnull(ls_parm) or trim(ls_parm) = "" then
	ls_parm = "ASK"
end if

f_split_string(ls_parm, "=", ls_parm, ls_arg)

ls_parm = upper(trim(ls_parm))

if gnv_app.is_demo_version then
 	common_thread.default_database = "<Default>"
else
	CHOOSE CASE ls_parm
		CASE "CLIENT"
			if len(ls_arg) > 0 then
				common_thread.default_database = trim(ls_arg)
			else
				common_thread.default_database = "<Default>"
			end if		
		CASE "SERVER", "NTSERVER"
			messagebox("CPR Open", "Server Mode is no longer supported from EncounterPRO.exe")
			event close()
		CASE "DBMAINT"
			messagebox("CPR Open", "DB Maintenance Mode is no longer supported from EncounterPRO.exe.  Please use EproDBMaint.exe.")
			event close()
		CASE "ASK"
			open(w_pop_which_database)
			common_thread.default_database = message.stringparm
			// If the user didn't pick a database then exit
			if common_thread.default_database = "" then
				event close()
			end if
		CASE ELSE
			// Assume the parameter is a database
			common_thread.default_database = ls_parm
	END CHOOSE
end if

open(w_splash)
li_sts = f_initialize_common("EncounterPRO")
if li_sts < 0 then
	if NOT IsNull(log) AND IsValid(log) then
		log.log(this, "cpr:open", "Error initializing EncounterPRO", 5)
	end if
	HALT CLOSE
end if

// Enable the display of log events
log.display_enabled = true

f_cpr_set_msg("Database Connected")

// Check SELECTBLOB works
SELECTBLOB object
INTO :lbl_script
FROM c_Patient_Material
WHERE material_id = 1
USING SQLCA;
tf_check()

if isnull(lbl_script) or len(lbl_script) <= 0 then
	log.log(this, "cpr.open: 159", "Blob doesn't work", 4)
end if

// Check the versions
if f_check_version() < 0 then
	// After an upgrade, we don't want an error message but rather a nice quiet exit
	HALT CLOSE
end if

li_sts = f_crash_clean_up()
if li_sts < 0 then
	log.log(po_null, "cpr.open:114","crash clean up failed for computer_id " + string(gnv_app.computer_id), 4)
end if
close(w_splash)

li_sts = f_logon()
if li_sts < 0 then
	// user clicked X
	return
end if
if li_sts = 0 then
	// user clicked minimize
	// If we allow it to continue, 
	// invalid main window will be shown.
	return
end if

li_sts = f_initialize_objects()
if li_sts < 0 then
	if NOT IsNull(log) AND IsValid(log) then
		log.log(this, "cpr.open:169", "Error initializing objects", 5)
	end if
	return
end if
//if li_sts <= 0 then
//	close(this)
//	return
//end if

open(main_window, "w_main")

end event

event close;
if trace_mode then f_stop_tracing()

If not isnull(current_user) Then
	current_user.logoff(true)
End If

if isvalid(log) and not isnull(log) then
	log.shutdown()
end if

if not isnull(common_thread) and isvalid(common_thread) then
	common_thread.shutdown()
end if

if IsValid(main_window) and not IsNull(main_window) then
	close(main_window)
end if

SetNull(datalist)
SetNull(windows_api)
if not isnull(sqlca) and isvalid(sqlca) then
	sqlca.dbdisconnect()
	SetNull(sqlca)
end if


end event

on systemerror;f_system_error()

end on

on cpr.create
appname="cpr"
message=create message
sqlca=create u_sqlca
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on cpr.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event idle;window lw_active_window
string ls_window_class

lw_active_window = f_active_window()
ls_window_class = lw_active_window.classname()

if isnull(current_service) and not isnull(current_scribe) and lower(ls_window_class) = "w_main" then
	current_scribe.logoff(false)
elseif lower(ls_window_class) = "w_logon" then
	return
elseif lower(ls_window_class) = "w_lock_terminal" then
	return
elseif not isnull(current_scribe) then
	open(w_lock_terminal)
end if

end event

