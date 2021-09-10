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
string temp_path = "C:\TEMP"
string debug_path = "C:\TEMP\EproDebug"

long COLOR_BACKGROUND = rgb(192,192,255)
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

end variables

global type cpr from application
string appname = "cpr"
string themepath = "C:\Program Files (x86)\Appeon\PowerBuilder 19.0\IDE\theme"
string themename = "Do Not Use Themes"
boolean nativepdfvalid = false
boolean nativepdfincludecustomfont = false
string nativepdfappname = ""
long richtextedittype = 0
long richtexteditx64type = 3
long richtexteditversion = 0
string richtexteditkey = ""
string appicon = "L:\Common\icons\epro40.ico"
string appruntimeversion = "19.2.0.2703"
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


///////////////////////////////////////////////////////////
// !!!! Change these values for every compile !!!!

long minimum_modification_level = 212

date compile_date = date("2021-10-09")

integer major_release = 7
string database_version = "0" // this is really minor release
string build = "3.8"
// Resulting in 7.0.3.8

////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////
// DB Version this client is compatible with.
string my_sql_version = "4.05"
////////////////////////////////////////////////////////////

string registry_key
string ini_file
string program_directory
string cpr_mode = "NA"
string computername
string servicename
long computer_id
string office_id
string windows_logon_id

// Don't get your hopes up; only a couple of locales are supported
// so far, and only in a limited way!
// en_us: as originally built
// en_af: starting support for African countries
string locale
end variables
event keydown;//f_fkey_handler(key, keyflags)


end event

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
ContextKeyword lcxk_base
string ls_Appdata
string ls_values[]

cpr_mode = "CLIENT"

rtn = GetEnvironment(env)

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
string ls_regKey = "HKEY_CURRENT_USER\Control Panel\International"
RegistryGet(ls_regKey, "LocaleName", RegString!, locale)

// Create the log object
log = CREATE u_event_log

// Initialize the utility com objects
common_thread = CREATE u_common_thread
li_sts = common_thread.initialize()
if li_sts <= 0 then halt

//// Get the value of %APPDATA%
//this.GetContextService("Keyword", lcxk_base)
//lcxk_base.GetContextKeywords("APPDATA", ls_values)
//IF Upperbound(ls_values) > 0 THEN
//   ls_Appdata = ls_values[1]
//ELSE
//   ls_Appdata = "* APPDATA UNDEFINED *"
//END IF
//
//ini_file = ls_Appdata + "\EncounterPro_OS\EncounterPro.ini"
//
//// If the INI directory doesn't exist, then create it
//if not fileexists(ls_Appdata + "\EncounterPro_OS") then
//	li_sts = CreateDirectory(ls_Appdata + "\EncounterPro_OS")
//end if
//

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

// If the INI file doesn't exist, then create an empty one
if not fileexists(ini_file) then
	lbl_file = blob("")
	log.file_write(lbl_file, ini_file)
end if

// Initialize the logging system; the log system uses the ini file

// Logging system must be initialized after common thread,
// so it can reference EncounterPro.OS.Utilities for event logging
log.initialize("EncounterPro-OS")
if li_sts <= 0 then
	openwithparm(w_pop_message, "Unable to initialize logging system")
	halt
end if

// log.log(this, "cpr.open", "Starting up", 1)

// If no command-line param is supplied, then check the registry
if isnull(ls_parm) or trim(ls_parm) = "" then
	ls_parm = "ASK"
end if

f_split_string(ls_parm, "=", ls_parm, ls_arg)

ls_parm = upper(trim(ls_parm))

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

open(w_main)

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

if isvalid(w_main) and not isnull(w_main) then
	close(w_main)
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

