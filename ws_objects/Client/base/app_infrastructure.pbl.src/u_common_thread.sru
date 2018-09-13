$PBExportHeader$u_common_thread.sru
forward
global type u_common_thread from nonvisualobject
end type
end forward

global type u_common_thread from nonvisualobject
end type
global u_common_thread u_common_thread

type prototypes
Function boolean sndPlaySoundA(string SoundName, uint Flags ) Library "WINMM.DLL"
Function uint waveOutGetNumDevs() Library "WINMM.DLL"


end prototypes

type variables
SoapConnection conn // Define SoapConnection
EpieGateway_service EpIE_Gateway // Declare proxy
epiegateway_credentialsheader credentials
boolean epie_initialized = false

string practice_user_id

integer perflog_sample_rate = 10

integer osversion // 0 =  Not Windows, 4 = 2000 or less, 5 = XP or 2003, 6 = Vista or 2008

long contraindication_count
str_config_object_info contraindication_alerts[]

oleobject mm
oleobject eprolibnet4
string default_database
string epro_service = "EncounterPRO"
string default_display_style
string manage_documents_service = "Manage Documents"
string order_report_service = "Report"
string change_scribe_context_service = "Change Scribe Context"

string epcompinfo

string common_dir

string name_format_full  // full name for standalone situations - First Middle Last
string name_format_list  // Name format in list of names - last, first MI

integer max_priority
boolean priority_beeps

long idle_timeout = 0

boolean show_hm = false

w_pop_please_wait2 please_wait


u_adodb_connection adodb

private str_printers printers
private str_printer default_printer
private str_printer current_printer
private boolean default_printer_set = false

// WIA Constants
long WIA_Item_Prop_FORMAT = 4106

long WIAImageBias_MinimizeSize = 65536
long WIAImageBias_MaximizeQuality = 131072

long WIAImageIntent_UnspecifiedIntent = 0
long WIAImageIntent_ColorIntent = 1
long WIAImageIntent_GrayScaleIntent = 2
long WIAImageIntent_TextIntent = 4

long WIADeviceType_UnspecifiedDeviceType = 0
long WIADeviceType_ScannerDeviceType = 1
long WIADeviceType_CameraDeviceType = 2
long WIADeviceType_VideoDeviceType = 4

string WIAFormat_Unspecified = "{00000000-0000-0000-0000-000000000000}"
string WIAFormat_wiaFormatBMP = "{B96B3CAB-0728-11D3-9D7B-0000F81EF32E}"
string WIAFormat_wiaFormatPNG = "{B96B3CAF-0728-11D3-9D7B-0000F81EF32E}"
string WIAFormat_wiaFormatGIF = "{B96B3CB0-0728-11D3-9D7B-0000F81EF32E}"
string WIAFormat_wiaFormatJPEG = "{B96B3CAE-0728-11D3-9D7B-0000F81EF32E}"
string WIAFormat_wiaFormatTIFF = "{B96B3CB1-0728-11D3-9D7B-0000F81EF32E}"

string WIACommand_wiaCommandSynchronize = "{9B26B7B2-ACAD-11D2-A093-00C04F72DC3C}"
//CommandID for Synchronize. Causes the device driver to synchronize cached items with the hardware device.

string WIACommand_wiaCommandTakePicture = "{AF933CAC-ACAD-11D2-A093-00C04F72DC3C}"
//CommandID for Take Picture. Causes a Microsoft Windows Image Acquisition (WIA) device to acquire an image.

string WIACommand_wiaCommandDeleteAllItems = "{E208C170-ACAD-11D2-A093-00C04F72DC3C}"
//CommandID for Delete All Items. Notifies the device to delete all items that can be deleted from the device.

string WIACommand_wiaCommandChangeDocument = "{04E725B0-ACAE-11D2-A093-00C04F72DC3C}"
//CommandID for Change Document. Causes the document scanner to load the next page in its document handler. Does not apply to other device types.

string WIACommand_wiaCommandUnloadDocument = "{1F3B3D8E-ACAE-11D2-A093-00C04F72DC3C}"
//CommandID for Unload Document. Notifies the document scanner to unload all remaining pages in its document handler. Does not apply to other device types.

//string WIACommand_wiaCommandBuildDeviceTree = "{9CBA5CE0-DBEA-11D2-8416-00C04FA36145}"
string WIACommand_wiaCommandBuildDeviceTree = "Build device tree"
//CommandID for Build Device Tree


boolean WIA_Use_Common_UI = true
boolean WIA_AlwaysSelectDevice = false
boolean WIA_CancelError = false

//
// WIA_DPS_DOCUMENT_HANDLING_CAPABILITIES flags
//

integer WIA_DocHandlingCap_FEED                       = 1  // X'01'
integer WIA_DocHandlingCap_FLAT                       = 2  // X'02'
integer WIA_DocHandlingCap_DUP                        = 3  // X'04'
integer WIA_DocHandlingCap_DETECT_FLAT                = 4  // X'08'
integer WIA_DocHandlingCap_DETECT_SCAN                = 5  // X'10'
integer WIA_DocHandlingCap_DETECT_FEED                = 6  // X'20'
integer WIA_DocHandlingCap_DETECT_DUP                 = 7  // X'40'
integer WIA_DocHandlingCap_DETECT_FEED_AVAIL          = 8  // X'80'
integer WIA_DocHandlingCap_DETECT_DUP_AVAIL           = 9  // X'100'

//
// WIA_DPS_DOCUMENT_HANDLING_STATUS flags
//

integer WIA_DocHandlingStatus_FEED_READY                 = 1  // X'01'
integer WIA_DocHandlingStatus_FLAT_READY                 = 2  // X'02'
integer WIA_DocHandlingStatus_DUP_READY                  = 3  // X'04'
integer WIA_DocHandlingStatus_FLAT_COVER_UP              = 4  // X'08'
integer WIA_DocHandlingStatus_PATH_COVER_UP              = 5  // X'10'
integer WIA_DocHandlingStatus_PAPER_JAM                  = 6  // X'20'

//
// WIA_DPS_DOCUMENT_HANDLING_SELECT flags
//

integer WIA_DocHandlingSelect_FEEDER                     = 1  // X'001'
integer WIA_DocHandlingSelect_FLATBED                    = 2  // X'002'
integer WIA_DocHandlingSelect_DUPLEX                     = 3  // X'004'
integer WIA_DocHandlingSelect_FRONT_FIRST                = 4  // X'008'
integer WIA_DocHandlingSelect_BACK_FIRST                 = 5  // X'010'
integer WIA_DocHandlingSelect_FRONT_ONLY                 = 6  // X'020'
integer WIA_DocHandlingSelect_BACK_ONLY                  = 7  // X'040'
integer WIA_DocHandlingSelect_NEXT_PAGE                  = 8  // X'080'
integer WIA_DocHandlingSelect_PREFEED                    = 9  // X'100'
integer WIA_DocHandlingSelect_AUTO_ADVANCE               = 10  // X'200'



long adStateClosed = 0 //Indicates that the object is closed. 
long adStateOpen = 1 //Indicates that the object is open. 
long adStateConnecting = 2 //Indicates that the object is connecting. 
long adStateExecuting = 4 //Indicates that the object is executing a command. 
long adStateFetching = 8 //Indicates that the rows of the object are being retrieved. 

end variables

forward prototypes
public subroutine shutdown ()
public function integer get_adodb (ref u_adodb_connection puo_adodb)
public function integer initialize ()
public function str_printer get_printer (string ps_printername)
public subroutine set_default_printer ()
public subroutine set_printer (string ps_printername)
public function str_printer get_default_printer ()
public subroutine add_printer (str_printer pstr_printer)
public function string current_printer ()
public function str_external_sources get_external_sources (string ps_external_source_type)
public function integer get_external_source (string ps_external_source, ref str_external_source pstr_external_source)
public function any get_property (oleobject po_properties, string ps_property_name)
public function string wia_external_source_type (long pl_device_type)
public function str_external_observation_attachment_list get_wia_attachments (string ps_device_id, boolean pb_allow_multiple)
public function string key ()
public function integer set_property (oleobject po_properties, string ps_property_name, any pa_property_value)
public function integer wia_device_execute_command (oleobject po_device, string ps_command)
public subroutine set_max_priority (integer pi_priority)
public subroutine priority_alert ()
public function integer play_sound (string ps_sound_file)
public subroutine load_preferences ()
public subroutine log_perflog (string ps_metric, decimal pd_value, boolean pb_sample)
public function string select_printer ()
public function string select_printer_client ()
public function string select_printer_server ()
public function string select_fax_server ()
public function boolean is_printer_available_on_client (string ps_printer)
public function string select_fax_client ()
public function str_printers get_printers ()
public function integer initialize_epie_gateway ()
public function str_users practice_users (string ps_user_property)
public function integer practice_users_remove_user (string ps_user_property, string ps_user_id)
public function integer practice_users_add_users (string ps_user_property, str_users pstr_users)
public function integer practice_users_add_user (string ps_user_property, string ps_user_id)
public subroutine load_contraindication_alerts ()
public function str_config_object_info vaccine_schedule ()
public function string chart_alert_component ()
public function integer set_chart_alert_component (string ps_component_id)
public function string drugdb_component ()
public function integer sendtoepie (string ps_message, boolean pb_test_message, ref string ps_response)
end prototypes

public subroutine shutdown ();if default_printer_set and lower(current_printer.printername) <> lower(default_printer.printername) then
	set_default_printer()
end if

eprolibnet4.disconnectobject()
DESTROY eprolibnet4
setnull(eprolibnet4)

if not isnull(adodb) and isvalid(adodb) then
	adodb.close()
	adodb.disconnectobject()
	DESTROY adodb
	setnull(adodb)
end if

end subroutine

public function integer get_adodb (ref u_adodb_connection puo_adodb);integer li_sts
string ls_query
long ll_cmdoptions
long ll_records
long ll_state

if isnull(adodb) then
	adodb = CREATE u_adodb_connection
	li_sts = adodb.connecttonewobject("adodb.connection")
	if li_sts < 0 then
		DESTROY adodb
		setnull(adodb)
		log.log(this, "u_common_thread.get_adodb:0013", "Error creating connection object", 4)
		return -1
	end if
	
	ll_state = adStateClosed
	
	TRY
		adodb.open(sqlca.adodb_connectstring)
		ll_state = adodb.state
	CATCH (throwable lo_error1)
		log.log(this, "u_common_thread.get_adodb:0023", "Error opening ADODB Connection (" + lo_error1.text + ")", 3)
		li_sts = -1
	END TRY
	
	if li_sts < 0 or ll_state = adStateClosed then
		log.log(this, "u_common_thread.get_adodb:0028", "Unable to open ADODB Connection", 3)
		adodb.disconnectobject()
		DESTROY adodb
		setnull(adodb)
		return -1
	end if
	
	if sqlca.is_approle_set then
		ls_query = sqlca.approle_command()
		ll_cmdoptions = 129 // adCmdText | adExecuteNoRecords
		TRY
			adodb.execute(ls_query, ll_records, ll_cmdoptions)
		CATCH (throwable lo_error2)
			log.log(this, "u_common_thread.get_adodb:0041", "Error setting app role (" + lo_error2.text + ")", 3)
			return -1
		END TRY
	end if

end if

puo_adodb = adodb

return 1

end function

public function integer initialize ();integer li_sts
string ls_temp
long ll_count
string ls_description
environment lo_env
string ls_common_files
unsignedlong ll_ppidl
boolean lb_sts


li_sts = windows_api.shell32.shgetspecialfolderlocation( handle(main_window), &
																windows_api.shell32.CSIDL_COMMONFILES , &
																ll_ppidl)
if li_sts = 0 then
	ls_common_files = space(500)
	lb_sts = windows_api.shell32.shgetpathfromidlist(ll_ppidl, ls_common_files)
	if lb_sts then
		ls_common_files = trim(ls_common_files)
		if right(ls_common_files, 1) <> "\" then ls_common_files += "\"
		common_dir = ls_common_files + "EncounterPRO-OS"
		epcompinfo = common_dir + "\EPCompInfo.ini"
	else
		openwithparm(w_pop_message, "An error occured getting windows environment information (shgetpathfromidlist).")
		return -1
	end if
	windows_api.shell32.CoTaskMemFree(ll_ppidl)
else
	openwithparm(w_pop_message, "An error occured getting windows environment information (shgetspecialfolderlocation - " + string(li_sts) + ").")
	return -1
end if

default_database = "<Default>"
setnull(adodb)

//// Initialize utility com objects
//mm = CREATE oleobject
//li_sts = mm.connecttonewobject("EPROLIB4.Utilities")
//if li_sts < 0 then
//	openwithparm(w_pop_message, "EPROLIB4 is not available (" + string(li_sts) + ").  Please contact your system administrator or JMJ customer support for assistance.")
//	return -1
//end if

eprolibnet4 = CREATE oleobject
li_sts = eprolibnet4.connecttonewobject("EncounterPRO.OS.Utilities")
if li_sts < 0 then
	openwithparm(w_pop_message, "EncounterPRO.OS.Utilities is not available (" + string(li_sts) + ").  Please reinstall EncounterPRO-OS or contact your system administrator for assistance.")
	return -1
else
	eprolibnet4.EPVersion = f_app_version()
end if

mm = eprolibnet4

// Set osversion
// 0 =  Not Windows, 4 = 2000 or less, 5 = XP or 2003, 6 = Vista or 2008
li_sts = getenvironment(lo_env)
if li_sts > 0 then
	if lo_env.ostype <> WindowsNT! then
		log.log(this, "u_common_thread.initialize:0059", "EncounterPRO is only support on the Windows Operation System", 3)
		osversion = 0
	else
		osversion = lo_env.OSMajorRevision
		if lo_env.OSMajorRevision = 5 and lo_env.OSMinorRevision = 0 then
			// Set Windows 2000 back to 4 to group it with the other OS versions that we don't support
			log.log(this, "u_common_thread.initialize:0065", "EncounterPRO version 5 is only supported on Windows XP or later", 3)
			osversion = 4
		end if
	end if
else
	log.log(this, "u_common_thread.initialize:0070", "Error getting environment information", 3)
	osversion = 0
end if


// We don't have access to the database yet, so set the beeps to null.  The priority_alert
// method will query the beeps setting when it first runs
setnull(priority_beeps)

randomize(0)


return 1

end function

public function str_printer get_printer (string ps_printername);integer i
str_printer lstr_printer

for i = 1 to printers.printer_count
	if lower(printers.printers[i].printername) = lower(ps_printername) then return printers.printers[i]
next

// If we get here then we didn't find the specified printer so return the default printer
lstr_printer = get_default_printer()

return lstr_printer

end function

public subroutine set_default_printer ();str_printer lstr_printer

lstr_printer = get_default_printer()

set_printer(lstr_printer.printername)

end subroutine

public subroutine set_printer (string ps_printername);integer li_sts
string ls_device
str_printer lstr_printer

// Make sure the default is set so we can change the printer back later
if not default_printer_set then
	default_printer = get_default_printer()
end if

// Get the printer structure for the specified printer
lstr_printer = get_printer(ps_printername)

// If we couldn't find the specified printer then log a warning
if isnull(lstr_printer.printername) or trim(lstr_printer.printername) = "" then
	if isnull(ps_printername) then ps_printername = "<Null>"
	log.log(this, "u_common_thread.set_printer:0016", "Printer not found (" + ps_printername + ")", 3)
	return
end if

// If the current printer is already the specified printer then we're done
if lower(current_printer.printername) = lower(lstr_printer.printername) then return

current_printer = lstr_printer

if osversion <= 4 then
	// If we get here then we need to set the specified printer as the default printer for this user/computer
	// To do that we'll first set the registry key which specifies the default printer
	li_sts = RegistrySet("HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Windows", "Device", current_printer.nt_device)
	if li_sts <= 0 then
		log.log(this, "u_common_thread.set_printer:0030", "Error setting default printer in registry (" + current_printer.printername + ")", 4)
	end if
else
	TRY
		eprolibnet4.SetDefaultPrinter(current_printer.printername)
	CATCH (oleruntimeerror lt_error)
		log.log(this, "u_common_thread.set_printer:0036", "Error calling SetDefaultPrinter ~r~n" + lt_error.text + "~r~n" + lt_error.description, 4)
	END TRY
end if

// Then we'll set the default printer with the powerbuilder system command.  This will affect the PowerBuild "Print" functions
li_sts = PrintSetPrinter(current_printer.printerstring)
if li_sts < 0 then
	log.log(this, "u_common_thread.set_printer:0043", "Error setting printer (" + current_printer.printername + ")", 4)
end if

end subroutine

public function str_printer get_default_printer ();integer li_sts
string ls_default_printer
string ls_printer
string ls_temp

// We put this code here because we don't want it to execute until it's actually needed


if not default_printer_set then
	default_printer_set = true  // prevents a loop with get_printer()
	if printers.printer_count > 0 then
		if osversion <= 4 then
			// If there is more than one printer then see if we can figure out the default from the registry.
			// we're doing it this way because the PrintGetPrinter() system function appears to have
			// problems if there aren't any printers or if we're running as a service
			li_sts = RegistryGet("HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Windows", "Device", RegString!, ls_default_printer)
			if li_sts > 0 then
				f_split_string(ls_default_printer, ",", ls_printer, ls_temp)
			end if
		else
			TRY
				ls_printer = eprolibnet4.GetDefaultPrinter()
			CATCH (oleruntimeerror lt_error)
				log.log(this, "u_common_thread.get_default_printer:0024", "Error calling GetDefaultPrinter ~r~n" + lt_error.text + "~r~n" + lt_error.description, 4)
			END TRY
		end if
		
		if len(ls_printer) > 0 then
			default_printer = get_printer(ls_printer)
		else
			setnull(default_printer.printername)
		end if
		
		if isnull(common_thread.default_printer.printername) or trim(common_thread.default_printer.printername) = "" then
			// If we still don't have a default printer then log a warning
			log.log(this, "u_common_thread.get_default_printer:0036", "Unable to determine default printer", 3)
		else
			// If we found a default printer then set the current_printer to the default
			current_printer = default_printer
		end if
	end if
end if

return default_printer

end function

public subroutine add_printer (str_printer pstr_printer);integer i

for i = 1 to printers.printer_count
	if lower(printers.printers[i].printername) = lower(pstr_printer.printername) then return
next

// If we get here then this is a new printer
printers.printer_count += 1
printers.printers[printers.printer_count] = pstr_printer


end subroutine

public function string current_printer ();if isnull(current_printer.printername) or trim(current_printer.printername) = "" then
	current_printer = get_default_printer()
	if isnull(current_printer.printername) or trim(current_printer.printername) = "" then
		return "<None>"
	end if
end if

return current_printer.printername

end function

public function str_external_sources get_external_sources (string ps_external_source_type);str_external_sources lstr_sources
str_external_source lstr_source
u_ds_data luo_types
u_ds_data luo_sources
long ll_source_type_count
long ll_source_count
long i, j, k
str_wia_sources lstr_wia_sources
string ls_external_source_type
integer li_sts
long ll_device_count
oleobject lo_deviceinfo
string ls_name
string ls_device_id
integer li_wia_source_count
str_external_source lstr_wia_source[]
oleobject lo_wia_devicemanager
environment env
string ls_filter
integer li_bit

lstr_sources.external_source_count = 0
li_wia_source_count = 0

luo_types = CREATE u_ds_data
luo_types.set_dataobject("dw_external_source_type_pick")
ll_source_type_count = luo_types.retrieve()
if ll_source_type_count <= 0 then return lstr_sources

luo_sources = CREATE u_ds_data
if cpr_mode = "SERVER" then
	// If we're running in server mode then we can use any external source
	luo_sources.set_dataobject("dw_c_external_source")
	ll_source_count = luo_sources.retrieve()
else
	// Otherwise, only show sources available on this computer
	luo_sources.set_dataobject("dw_jmj_get_available_sources")
	ll_source_count = luo_sources.retrieve(computer_id)
end if
if ll_source_count < 0 then return lstr_sources


// See if we're running Windows XP
GetEnvironment(env)
if env.OSType = WindowsNT! and env.osmajorrevision = 5 and env.osminorrevision = 1 then
	// If we're running Windows XP, get the WIA Device Manager
	lo_wia_devicemanager = CREATE oleobject
	li_sts = lo_wia_devicemanager.connecttonewobject("wia.devicemanager")
	if li_sts < 0 then
		log.log(this, "u_common_thread.get_external_sources:0050", "Error connecting to wia.devicemanager object (" + string(li_sts) + ")", 3)
	else
		// Get the WIA devices on this computer
		ll_device_count = lo_wia_devicemanager.deviceinfos.count
		
		for i = 1 to ll_device_count
			// Find the desired device_id
			lo_deviceinfo = lo_wia_devicemanager.deviceinfos.item[i]
			li_wia_source_count += 1
			lstr_wia_source[li_wia_source_count].external_source_type = wia_external_source_type(lo_deviceinfo.type)
			lstr_wia_source[li_wia_source_count].external_source = lo_deviceinfo.deviceid
			lstr_wia_source[li_wia_source_count].description = string(get_property(lo_deviceinfo.properties, "Name"))
			setnull(lstr_wia_source[li_wia_source_count].in_office_workplan_id)
			setnull(lstr_wia_source[li_wia_source_count].workplan_id)
			lstr_wia_source[li_wia_source_count].component_id = "EXT_WIA"
			setnull(lstr_wia_source[li_wia_source_count].button)
			lstr_wia_source[li_wia_source_count].wia_source = true
			lstr_wia_source[li_wia_source_count].always_available = false
			lstr_wia_source[li_wia_source_count].on_computer = true
		next
		
		// We're done with this object
		lo_wia_devicemanager.disconnectobject()
		DESTROY lo_wia_devicemanager
	end if
end if

// Now go through the external source types in their proper order and add the
// WIA and non-WIA devices
for i = 1 to ll_source_type_count
	ls_external_source_type = luo_types.object.external_source_type[i]
	
	if not isnull(ps_external_source_type) and lower(ps_external_source_type) <> lower(ls_external_source_type) then continue
	
	// Add the wia sources
	for j = 1 to li_wia_source_count
		if lower(ls_external_source_type) = lower(lstr_wia_source[li_wia_source_count].external_source_type) then
			lstr_wia_source[li_wia_source_count].button = luo_types.object.button[i]
			lstr_sources.external_source_count += 1
			lstr_sources.external_source[lstr_sources.external_source_count] = lstr_wia_source[li_wia_source_count]
		end if
	next
	
	// Now add the config sources
	ls_filter = "external_source_type='" + ls_external_source_type + "'"
	luo_sources.setfilter(ls_filter)
	luo_sources.filter()
	ll_source_count = luo_sources.rowcount()
	for j = 1 to ll_source_count
		lstr_source.external_source = luo_sources.object.external_source[j]
		lstr_source.external_source_type = luo_sources.object.external_source_type[j]
		lstr_source.description = luo_sources.object.description[j]
		lstr_source.in_office_workplan_id = luo_sources.object.in_office_workplan_id[j]
		lstr_source.workplan_id = luo_sources.object.workplan_id[j]
		lstr_source.component_id = luo_sources.object.component_id[j]
		lstr_source.button = luo_sources.object.button[j]
		lstr_source.wia_source = false
		li_bit = luo_sources.object.always_available[j]
		if li_bit = 0 then
			lstr_source.always_available = false
		else
			lstr_source.always_available = true
		end if
		if cpr_mode = "SERVER" then
			// For server mode, assume we have the external source available
			lstr_source.on_computer = true
		else
			li_bit = luo_sources.object.on_computer[j]
			if li_bit = 0 then
				lstr_source.on_computer = false
			else
				lstr_source.on_computer = true
			end if
		end if
		
		lstr_sources.external_source_count += 1
		lstr_sources.external_source[lstr_sources.external_source_count] = lstr_source
	next
	
next

return lstr_sources


end function

public function integer get_external_source (string ps_external_source, ref str_external_source pstr_external_source);long i
str_external_source lstr_source
str_external_sources lstr_sources
string ls_null
str_popup popup
str_popup_return popup_return
long ll_index
str_external_source lstr_source_from_type[]
integer li_always_available
long ll_count
long ll_on_computer_count
long ll_on_computer_index

setnull(ls_null)

// Hard code the EpIE source
if lower(ps_external_source) = "epie" then
	pstr_external_source.external_source = "EpIE"
	pstr_external_source.external_source_type = "EpIE"
	pstr_external_source.description = "EpIE Download Gateway"
	setnull(pstr_external_source.in_office_workplan_id)
	setnull(pstr_external_source.workplan_id)
	pstr_external_source.component_id = "EproEpieGateway"
	setnull(pstr_external_source.button)
	return 1
end if


// See if we have this source
lstr_source.wia_source = false
SELECT external_source,
		external_source_type,
		description,
		in_office_workplan_id,
		workplan_id,
		component_id,
		button,
		always_available
INTO :lstr_source.external_source,
		:lstr_source.external_source_type,
		:lstr_source.description,
		:lstr_source.in_office_workplan_id,
		:lstr_source.workplan_id,
		:lstr_source.component_id,
		:lstr_source.button,
		:li_always_available
FROM c_External_Source
WHERE external_source = :ps_external_source;
if not tf_check() then return -1
if sqlca.sqlcode = 0 then
	if li_always_available = 0 then
		// See if this source is on this computer
		SELECT count(*)
		INTO :ll_count
		FROM o_Computer_External_Source
		WHERE computer_id = :computer_id
		AND external_source = :ps_external_source;
		if not tf_check() then return -1
		if ll_count > 0 then
			pstr_external_source = lstr_source
			return 1
		end if
	else
		pstr_external_source = lstr_source
		return 1
	end if
end if

// We didn't find the source in the table but that could be because
// the caller passed in an external_source_type instead of an external_source
// or because the external_source passed in is a dynamic source such as a WIA device

// Get a list of all external sources available on the
lstr_sources = common_thread.get_external_sources(ls_null)

// See if any match the external source id
for i = 1 to lstr_sources.external_source_count
	if lower(lstr_sources.external_source[i].external_source) = lower(ps_external_source) then
		pstr_external_source = lstr_sources.external_source[i]
		return 1
	end if
next


// If nothing matched the external source id, see if any match the external_source_type
// Give preference to the one that is assigned to this computer as opposed to "always_available"
ll_on_computer_count = 0
for i = 1 to lstr_sources.external_source_count
	if lower(lstr_sources.external_source[i].external_source_type) = lower(ps_external_source) then
		popup.data_row_count += 1
		popup.items[popup.data_row_count] = lstr_sources.external_source[i].description
		lstr_source_from_type[popup.data_row_count] = lstr_sources.external_source[i]
		if lstr_sources.external_source[i].on_computer then
			ll_on_computer_count += 1
			ll_on_computer_index = popup.data_row_count
		end if
	end if
next

if popup.data_row_count = 1 then
	// If only one was found that pick it
	ll_index = 1
elseif popup.data_row_count > 1 then
	// More than one source was found...
	
	// If only one was configured to be on this computer then pick it
	if ll_on_computer_count = 1 then
		ll_index = ll_on_computer_index
	else
		if cpr_mode = "SERVER" then
			ll_index = 1
		else
			openwithparm(w_pop_pick, popup)
			popup_return = message.powerobjectparm
			if popup_return.item_count <> 1 then return 0
			ll_index = popup_return.item_indexes[1]
		end if
	end if
else
	ll_index = 0
end if

if ll_index > 0 then
	pstr_external_source = lstr_source_from_type[ll_index]
	return 1
end if

return 0


end function

public function any get_property (oleobject po_properties, string ps_property_name);any la_value
long i

for i = 1 to po_properties.count
	if lower(ps_property_name) = lower(po_properties.item[i].name) then
		la_value = po_properties.item[i].value
		return la_value
	end if
next

setnull(la_value)

return la_value

end function

public function string wia_external_source_type (long pl_device_type);string ls_external_source_type

CHOOSE CASE pl_device_type
	CASE WIADeviceType_CameraDeviceType
		ls_external_source_type = "Digital Camera"
	CASE WIADeviceType_ScannerDeviceType
		ls_external_source_type = "Scanner"
	CASE WIADeviceType_VideoDeviceType
		ls_external_source_type = "Video"
	CASE WIADeviceType_UnspecifiedDeviceType
		ls_external_source_type = "File Import"
	CASE ELSE
		ls_external_source_type = "File Import"
END CHOOSE

return ls_external_source_type


end function

public function str_external_observation_attachment_list get_wia_attachments (string ps_device_id, boolean pb_allow_multiple);str_external_observation_attachment_list lstr_attachments
integer li_sts
oleobject lo_items
long i
long ll_item_count
oleobject lo_item
oleobject lo_deviceinfo
oleobject lo_device
oleobject lo_imagefile
str_external_observation_attachment lstr_item
long ll_device_count
boolean lb_found
string ls_name
oleobject lo_wia_devicemanager
oleobject lo_wia_commondialog
w_pop_please_wait lw_wait
boolean lb_SingleSelect
string ls_text
long ll_dps_pages
ulong lul_flags
boolean lb_is_document_feeder
boolean lb_feed_ready

lstr_attachments.attachment_count = 0
if pb_allow_multiple then
	lb_SingleSelect = false
	ll_dps_pages = 0 // Get as many as there are
else
	lb_SingleSelect = true
	ll_dps_pages = 1
end if

// Get the WIA Device Manager
lo_wia_devicemanager = CREATE oleobject
li_sts = lo_wia_devicemanager.connecttonewobject("wia.devicemanager")
if li_sts < 0 then
	log.log(this, "u_common_thread.get_wia_attachments:0037", "Error connecting to wia.devicemanager object (" + string(li_sts) + ")", 4)
	return lstr_attachments
end if

// Get the WIA Common Dialogs
lo_wia_commondialog = CREATE oleobject
li_sts = lo_wia_commondialog.connecttonewobject("wia.commondialog")
if li_sts < 0 then
	log.log(this, "u_common_thread.get_wia_attachments:0045", "Error connecting to wia.commondialog object (" + string(li_sts) + ")", 4)
	return lstr_attachments
end if

ll_device_count = lo_wia_devicemanager.deviceinfos.count

lb_found = false
for i = 1 to ll_device_count
	// Find the desired device_id
	lo_deviceinfo = lo_wia_devicemanager.deviceinfos.item[i]
	ls_name = string(get_property(lo_deviceinfo.properties, "Name"))
	if lo_deviceinfo.deviceid = ps_device_id then
		// We found it so connect to it
		open(lw_wait, "w_pop_please_wait")
		TRY
			lo_device = lo_deviceinfo.connect()
		CATCH (throwable lt_error)
			ls_text = "EncounterPRO was unable to connect to the specified device.  The following error message was returned:  "
			ls_text += lt_error.text
			openwithparm(w_pop_message, ls_text)
		FINALLY
			close(lw_wait)
		END TRY
		if isnull(lo_device) or not isvalid(lo_device) then
			lb_found = false
		else
			lb_found = true
		end if
		exit
	end if
next
if not lb_found then
	log.log(this, "u_common_thread.get_wia_attachments:0077", "Device not found (" + ps_device_id + ")", 4)
	return lstr_attachments
end if

// Set the pages property on the device
//set_property(lo_device.properties, "WIA_DPS_PAGES", ll_dps_pages)

CHOOSE CASE int(lo_device.type)
	CASE WIADeviceType_ScannerDeviceType 
		lo_items = lo_wia_commondialog.showselectitems(lo_device, &
																WIAImageIntent_TextIntent, &
																WIAImageBias_MaximizeQuality, &
																lb_SingleSelect, &
																WIA_use_common_ui, &
																WIA_CancelError)
		
		if isnull(lo_items) or not isvalid(lo_items) then return lstr_attachments
		
		lul_flags = get_property(lo_device.properties, "Document Handling Select")
		lb_is_document_feeder = f_check_bit(lul_flags, WIA_DocHandlingSelect_FEEDER)

		lstr_item.attachment_type = "IMAGE"
		
		ll_item_count = lo_items.count
		for i = 1 to ll_item_count
			// Get the item object
			lo_item = lo_items.item[i]
			lo_imagefile = lo_wia_commondialog.showtransfer(lo_item)
			
			// Get the image file
			lstr_item.extension = lo_imagefile.fileextension
			lstr_item.attachment = lo_imagefile.filedata.binarydata
			
			// Add the image file to the attachments list
			lstr_attachments.attachment_count += 1
			lstr_attachments.attachments[lstr_attachments.attachment_count] = lstr_item
		next
		
		lul_flags = get_property(lo_device.properties, "Document Handling Status")
		lb_feed_ready = f_check_bit(lul_flags, WIA_DocHandlingStatus_FEED_READY)

		if lb_is_document_feeder or lb_feed_ready then
			// Since we're using a sheet feeder, get the rest of the documents in the feeder
			DO WHILE true
				lul_flags = get_property(lo_device.properties, "Document Handling Status")
				lb_feed_ready = f_check_bit(lul_flags, WIA_DocHandlingStatus_FEED_READY)
				if not lb_feed_ready then exit
				
				TRY
					lo_imagefile = lo_wia_commondialog.showtransfer(lo_item)
				CATCH (throwable lt_xfererror)
					ls_text = "Error transferring image.  The following error message was returned:  "
					ls_text += lt_xfererror.text
	//				openwithparm(w_pop_message, ls_text)
					exit
				END TRY
				
				if isvalid(lo_imagefile) and not isnull(lo_imagefile) then
					// Get the image file
					lstr_item.extension = lo_imagefile.fileextension
					lstr_item.attachment = lo_imagefile.filedata.binarydata
					
					// Add the image file to the attachments list
					lstr_attachments.attachment_count += 1
					lstr_attachments.attachments[lstr_attachments.attachment_count] = lstr_item
				else
					exit
				end if
			LOOP

		end if
	CASE ELSE
		lo_items = lo_wia_commondialog.showselectitems(lo_device, &
																WIAImageIntent_TextIntent, &
																WIAImageBias_MaximizeQuality, &
																lb_SingleSelect, &
																WIA_use_common_ui, &
																WIA_CancelError)
		
		if isnull(lo_items) or not isvalid(lo_items) then return lstr_attachments
		
		lstr_item.attachment_type = "IMAGE"
		
		ll_item_count = lo_items.count
		for i = 1 to ll_item_count
			// Get the item object
			lo_item = lo_items.item[i]
			lo_imagefile = lo_wia_commondialog.showtransfer(lo_item)
			
			// Get the image file
			lstr_item.extension = lo_imagefile.fileextension
			lstr_item.attachment = lo_imagefile.filedata.binarydata
			
			// Add the image file to the attachments list
			lstr_attachments.attachment_count += 1
			lstr_attachments.attachments[lstr_attachments.attachment_count] = lstr_item
		next
END CHOOSE



// We're done with these objects
lo_wia_devicemanager.disconnectobject()
DESTROY lo_wia_devicemanager
lo_wia_commondialog.disconnectobject()
DESTROY lo_wia_commondialog

return lstr_attachments


end function

public function string key ();string ls_temp

ls_temp  = "!"
ls_temp  += "$"
ls_temp  += "%"
ls_temp  += "#"
ls_temp  += "4"
ls_temp  += "2"
ls_temp  += "7"
ls_temp  += "4"
ls_temp  += "8"
ls_temp  += "j"
ls_temp  += "s"
ls_temp  += "T"
ls_temp  += "T"
ls_temp  += "L"
ls_temp  += "z"
ls_temp  += "Q"

return ls_temp

end function

public function integer set_property (oleobject po_properties, string ps_property_name, any pa_property_value);long i
string ls_name

string ls_existing_props

for i = 1 to po_properties.count
	ls_name = po_properties.item[i].name
	ls_existing_props += ", " + ls_name + ":" + string(po_properties.item[i].propertyid)
	if lower(ps_property_name) = lower(ls_name) then
		po_properties.item[i].value = pa_property_value
		return 1
	end if
next

messagebox("properties", ls_existing_props)

return 0

end function

public function integer wia_device_execute_command (oleobject po_device, string ps_command);string ls_command
long i
string ls_text

for i = 1 to po_device.commands.count
	ls_command = string(po_device.commands.item[i].name)
	if lower(ls_command) = lower(ps_command) then
		TRY
			po_device.ExecuteCommand(po_device.commands.item[i].commandid)
		CATCH (throwable lt_error)
			ls_text = "Error executing WIA Device Command (" + ps_command + ").  The following error message was returned:  "
			ls_text += lt_error.text
			openwithparm(w_pop_message, ls_text)
		END TRY
		return 1
	end if
next


return 0


end function

public subroutine set_max_priority (integer pi_priority);
if pi_priority > max_priority then max_priority = pi_priority


end subroutine

public subroutine priority_alert ();string ls_temp
integer li_beeps
string ls_sound_file

// Initialize priorities
if isnull(priority_beeps) then
	// Get the preference for turning on/off the beeps
	ls_temp = datalist.get_preference("SYSTEM", "Audio Priority Sound")
	if isnull(ls_temp) then
		priority_beeps = true
	else
		priority_beeps = false
	end if
end if

if priority_beeps then
	ls_sound_file = datalist.priority_sound_file(max_priority)
	play_sound(ls_sound_file)
end if

max_priority = 0

end subroutine

public function integer play_sound (string ps_sound_file);uint lui_NumDevs
uint lui_flags
integer li_sts
boolean lb_sts
string ls_beeps
string ls_temp



//0 - play synchronously
//1 - play asynchronously
//2 - don't use default sound if u can't find file
//3 - 1&2
//8 - loop the sound until next sndPlaysound
//10- don't stop any correctly playing sound
lui_flags = 3


if fileexists(ps_sound_file) then
	lui_NumDevs = WaveOutGetNumDevs()
	IF lui_NumDevs > 0 THEN
		 lb_sts = sndPlaySoundA(ps_sound_file, lui_flags)
	END IF
	
	if lb_sts then return 1
else
	if match(lower(ps_sound_file), "^[0-9]+ beep") then
		f_split_string(ps_sound_file, " ", ls_beeps, ls_temp)
		if isnumber(ls_beeps) then
			beep(integer(ls_beeps))
		end if
	end if
end if

return 0


end function

public subroutine load_preferences ();string ls_temp
str_config_object_info lstr_config_object
integer li_sts
u_ds_data luo_data
long ll_count
long i

manage_documents_service = f_get_system_preference("PREFERENCES", "manage_documents_service")
if isnull(manage_documents_service) then manage_documents_service = "Manage Documents"

show_hm = datalist.get_preference_boolean("SECURITY", "Show Health Maintenance Tab", false)

ls_temp = datalist.get_preference("PREFERENCES", "Perflog Sample Rate")
if isnumber(ls_temp) then
	perflog_sample_rate = long(ls_temp)
	if perflog_sample_rate <= 0 OR perflog_sample_rate > 100 then perflog_sample_rate = 10
end if

name_format_full = datalist.get_preference("PREFERENCES", "Patient Name Format Full", "{First}{ M.}{ (Nickname)}{ Last}{ Suffix}")
name_format_list = datalist.get_preference("PREFERENCES", "Patient Name Format List", "{Last},{ First}{ M.}{ (Nickname)}{, Suffix}")

load_contraindication_alerts()


end subroutine

public subroutine log_perflog (string ps_metric, decimal pd_value, boolean pb_sample);string ls_user_id
long ll_patient_workplan_item_id

if pb_sample then
	if rand(100) > perflog_sample_rate then return
end if

if isnull(current_scribe) then
	setnull(ls_user_id)
else
	ls_user_id = current_scribe.user_id
end if

if isnull(current_service) then
	setnull(ll_patient_workplan_item_id)
else
	ll_patient_workplan_item_id = current_service.patient_workplan_item_id
end if

sqlca.jmj_log_performance(computer_id, &
									ll_patient_workplan_item_id, &
									ls_user_id, &
									ps_metric, &
									pd_value)


end subroutine

public function string select_printer ();return select_printer_client()

end function

public function string select_printer_client ();integer i
str_popup popup
str_popup_return popup_return
string ls_null
integer li_sts
string ls_printer

setnull(ls_null)

for i = 1 to printers.printer_count
	popup.items[i] = printers.printers[i].printername
next
popup.data_row_count = printers.printer_count

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return ls_null

return popup_return.items[1]

end function

public function string select_printer_server ();integer i
str_popup popup
str_popup_return popup_return
string ls_null

setnull(ls_null)

popup.dataobject = "dw_server_printers_for_office"
popup.datacolumn = 1
popup.displaycolumn = 4
popup.argument_count = 2
popup.argument[1] = office_id
popup.argument[2] = "N"
if config_mode then
	popup.add_blank_row = true
	popup.blank_at_bottom = true
	popup.blank_text = "<Configure Printers>"
end if
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return ls_null

if popup_return.items[1] = "" then
	open(w_configure_printers)
	return ls_null
end if

return popup_return.items[1]


end function

public function string select_fax_server ();integer i
str_popup popup
str_popup_return popup_return
string ls_null

setnull(ls_null)

popup.dataobject = "dw_server_printers_for_office"
popup.datacolumn = 1
popup.displaycolumn = 4
popup.argument_count = 2
popup.argument[1] = office_id
popup.argument[2] = "Y"
if config_mode then
	popup.add_blank_row = true
	popup.blank_at_bottom = true
	popup.blank_text = "<Configure Printers>"
end if
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return ls_null

if popup_return.items[1] = "" then
	open(w_configure_printers)
	return ls_null
end if

return popup_return.items[1]


end function

public function boolean is_printer_available_on_client (string ps_printer);integer i

for i = 1 to printers.printer_count
	if lower(printers.printers[i].printername) = lower(ps_printer) then return true
next

return false

end function

public function string select_fax_client ();integer i, j
str_popup popup
str_popup_return popup_return
string ls_null
u_ds_data luo_data
long ll_count
long ll_fax_count
string lsa_fax[]
string ls_printer

setnull(ls_null)

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_server_printers_for_office")
ll_count = luo_data.retrieve(office_id, "Y")
if ll_count < 0 then return ls_null

if ll_count = 0 and not config_mode then
	if user_list.is_user_privileged(current_user.user_id, "Configuration Mode") then
		openwithparm(w_pop_yes_no, "This installation does not have a Fax printer-driver installed on the server.  Do you want to configure the server printers?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return ls_null
		
		open(w_configure_printers)
		return ls_null
	else
		openwithparm(w_pop_message, "This installation does not have a Fax printer-driver installed on the server.  Please contact your system administrator.")
		return ls_null
	end if
end if

// Loop through the server faxes and see which ones are defined on the client
ll_fax_count = 0
for i = 1 to ll_count
	ls_printer = luo_data.object.printer[i]
	for j = 1 to printers.printer_count
		if lower(ls_printer) = lower(printers.printers[j].printername) then
			ll_fax_count += 1
			lsa_fax[ll_fax_count] = ls_printer
			popup.items[ll_fax_count] = luo_data.object.display_name[i]
		end if
	next
next
popup.data_row_count = ll_fax_count

if config_mode then
	popup.data_row_count += 1
	popup.items[popup.data_row_count] = "<Configure Printers/Fax>"
elseif ll_fax_count = 0 then
	openwithparm(w_pop_message, "There is a Fax printer-driver on the server, but it is not available on this client computer.  Please contact your system administrator.")
	return ls_null
elseif ll_fax_count = 1 then
	return lsa_fax[1]
end if

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return ls_null

// Did they pick "Configure"?
if popup_return.item_indexes[1] > ll_fax_count then
	open(w_configure_printers)
	return ls_null
end if

return lsa_fax[popup_return.item_indexes[1]]


end function

public function str_printers get_printers ();
return printers


end function

public function integer initialize_epie_gateway ();string ls_templog
long ll_sts
long rval

//////////////////////////////////////////////////////////////////////////////////
// Create EpIE Gateway Connection
//////////////////////////////////////////////////////////////////////////////////
conn = create SoapConnection

if datalist.get_preference_boolean("SYSTEM", "epie_log_soap_calls", false) then
	ls_templog = f_temp_file2("log", "EpIELogs")
else
	ls_templog = ""
end if
ll_sts = conn.SetSoapLogFile(ls_templog) 

rVal = Conn.CreateInstance(EpIE_Gateway, "EpieGateway_service")
if rVal <> 0 then
	log.log(this, "u_common_thread.initialize_epie_gateway:0019", "Creating SOAP proxy failed (" + string(rVal) + ")", 4)
	destroy conn
	return -1
end if

credentials = CREATE epiegateway_credentialsheader
credentials.user = datalist.get_preference( "SYSTEM", "epie_user")
credentials.password = datalist.get_preference( "SYSTEM", "epie_pwd")
setnull(credentials.actor)
setnull(credentials.encodedmustunderstand)
setnull(credentials.encodedmustunderstand12)
setnull(credentials.encodedrelay)
setnull(credentials.role)

EpIE_Gateway.setcredentialsheadervalue(credentials)

return 1

end function

public function str_users practice_users (string ps_user_property);string ls_progress
long ll_count
string lsa_users[]
str_users lstr_users
str_user lstr_user
long i
integer li_sts

ls_progress = sqlca.fn_user_property(common_thread.practice_user_id, "Property", ps_user_property)
if not tf_check() then return lstr_users

if len(ls_progress) > 0 then
	ll_count = f_parse_string(ls_progress, ",", lsa_users)
end if

for i = 1 to ll_count
	li_sts = user_list.get_user(lsa_users[i], lstr_user)
	if li_sts > 0 then
		lstr_users.user_count += 1
		lstr_users.user[lstr_users.user_count] = lstr_user
	end if
next

return lstr_users


end function

public function integer practice_users_remove_user (string ps_user_property, string ps_user_id);long i, j
str_users lstr_current_users
string ls_property_value
boolean lb_found
integer li_sts

lstr_current_users = practice_users(ps_user_property)

lb_found = false
for i = 1 to lstr_current_users.user_count
	if lstr_current_users.user[i].user_id = ps_user_id then
		for j = i to lstr_current_users.user_count - 1
			lstr_current_users.user[j] = lstr_current_users.user[j + 1]
		next
		lstr_current_users.user_count -= 1
		exit
	end if
next
	
for i = 1 to lstr_current_users.user_count
	if i > 1 then ls_property_value += ","
	ls_property_value += lstr_current_users.user[i].user_id
next

li_sts = user_list.set_user_progress(practice_user_id, "Property", ps_user_property, ls_property_value)

return li_sts

end function

public function integer practice_users_add_users (string ps_user_property, str_users pstr_users);long i, j
str_users lstr_current_users
string ls_property_value
boolean lb_found
integer li_sts

lstr_current_users = practice_users(ps_user_property)

for i = 1 to pstr_users.user_count
	lb_found = false
	for j = 1 to lstr_current_users.user_count
		if lstr_current_users.user[j].user_id = pstr_users.user[i].user_id then
			lb_found = true
			exit
		end if
	next
		
	if not lb_found then
		lstr_current_users.user_count += 1
		lstr_current_users.user[lstr_current_users.user_count] = pstr_users.user[i]
	end if
next

for i = 1 to lstr_current_users.user_count
	if i > 1 then ls_property_value += ","
	ls_property_value += lstr_current_users.user[i].user_id
next

li_sts = user_list.set_user_progress(practice_user_id, "Property", ps_user_property, ls_property_value)

return li_sts

end function

public function integer practice_users_add_user (string ps_user_property, string ps_user_id);long i, j
str_users lstr_current_users
string ls_property_value
boolean lb_found
integer li_sts

lstr_current_users = practice_users(ps_user_property)

lb_found = false
for j = 1 to lstr_current_users.user_count
	if lstr_current_users.user[j].user_id = ps_user_id then
		lb_found = true
		exit
	end if
next

ls_property_value = ""
for i = 1 to lstr_current_users.user_count
	if i > 1 then ls_property_value += ","
	ls_property_value += lstr_current_users.user[i].user_id
next

if not lb_found then
	if len(ls_property_value) > 0 then ls_property_value += ","
	ls_property_value += ps_user_id
end if

li_sts = user_list.set_user_progress(practice_user_id, "Property", ps_user_property, ls_property_value)

return li_sts

end function

public subroutine load_contraindication_alerts ();string ls_temp
str_config_object_info lstr_config_object
integer li_sts
u_ds_data luo_data
long ll_count
long i


contraindication_count = 0
luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_domain_notranslate_list")
ll_count = luo_data.retrieve("Config Contraindication Alerts")
for i = 1 to ll_count
	ls_temp = luo_data.object.domain_item[i]
	li_sts = f_get_config_object_info(ls_temp, lstr_config_object)
	if li_sts > 0 then
		contraindication_count += 1
		contraindication_alerts[contraindication_count] = lstr_config_object
	end if
next

DESTROY luo_data

end subroutine

public function str_config_object_info vaccine_schedule ();string ls_temp
str_config_object_info lstr_config_object
integer li_sts
u_ds_data luo_data
long ll_count
long i

lstr_config_object = f_empty_config_object_info()

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_domain_notranslate_list")
ll_count = luo_data.retrieve("Config Vaccine Schedule")
if ll_count > 1 then
	log.log(this, "u_common_thread.vaccine_schedule:0014", "Multiple vaccine schedule config records found.  Only the first will be used.", 3)
end if
if ll_count > 0 then
	ls_temp = luo_data.object.domain_item[1]
	li_sts = f_get_config_object_info(ls_temp, lstr_config_object)
	if li_sts < 0 then
		log.log(this, "u_common_thread.vaccine_schedule:0020", "Error:  Vaccine Schedule load failed (" + ls_temp + ")", 4)
	end if
end if


DESTROY luo_data

return lstr_config_object

end function

public function string chart_alert_component ();string ls_component_id
string ls_default_alert_component_id = 	"ALERT_STD"


SELECT min(domain_item)
INTO :ls_component_id
FROM c_Domain d
	INNER JOIN c_Component_Definition c
	ON d.domain_item = c.component_id
WHERE domain_id = 'Config Chart Alerts'
AND c.component_type = 'ALERT';
if not tf_check() then
	ls_component_id = ls_default_alert_component_id
end if

if isnull(ls_component_id) or trim(ls_component_id) = "" then
	ls_component_id = ls_default_alert_component_id
end if

return ls_component_id


end function

public function integer set_chart_alert_component (string ps_component_id);long ll_domain_sequence

DELETE
FROM c_Domain
WHERE domain_id = 'Config Chart Alerts';
if not tf_check() then return -1

ll_domain_sequence = 1

INSERT INTO c_Domain (
	domain_id,
	domain_sequence,
	domain_item)
VALUES (
	'Config Chart Alerts',
	:ll_domain_sequence,
	:ps_component_id);
if not tf_check() then return -1

return 1

end function

public function string drugdb_component ();string ls_component_id
string ls_default_drug_component_id = 	"DRUG_STD"


SELECT min(domain_item)
INTO :ls_component_id
FROM c_Domain d
	INNER JOIN c_Component_Definition c
	ON d.domain_item = c.component_id
WHERE domain_id = 'Config Drug DB'
AND c.component_type = 'DRUG';
if not tf_check() then
	ls_component_id = ls_default_drug_component_id
end if

if isnull(ls_component_id) or trim(ls_component_id) = "" then
	ls_component_id = ls_default_drug_component_id
end if

return ls_component_id


end function

public function integer sendtoepie (string ps_message, boolean pb_test_message, ref string ps_response);any la_rtn
integer li_sts
string ls_TestMessageFlag

if epie_initialized then
	// Reset the credentials
	credentials.user = datalist.get_preference( "SYSTEM", "epie_user")
	credentials.password = datalist.get_preference( "SYSTEM", "epie_pwd")
	setnull(credentials.actor)
	setnull(credentials.encodedmustunderstand)
	setnull(credentials.encodedmustunderstand12)
	setnull(credentials.encodedrelay)
	setnull(credentials.role)
	
	EpIE_Gateway.setcredentialsheadervalue(credentials)
else
	li_sts = initialize_epie_gateway()
	if li_sts < 0 then
		log.log(this, "u_common_thread.sendtoepie:0019", "Error initializing EpIE Gateway", 4)
		return -1
	end if
end if

if pb_test_message then
	ls_TestMessageFlag = "Y"
else
	ls_TestMessageFlag = "N"
end if

// Get Message Bag
TRY
	la_rtn = EpIE_Gateway.putmessage(ps_message)
	if classname(la_rtn) = "string" then
		ps_response = string(la_rtn)
	else
		ps_response = ""
	end if
CATCH ( SoapException lt_error )
	log.log(this, "u_common_thread.sendtoepie:0039", "Error calling EpIE upload gateway (" + lt_error.text + ")", 4)
	return -1
END TRY

if len(ps_response) > 0 then
	return 1
end if

return 0


end function

on u_common_thread.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_common_thread.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

