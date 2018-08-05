$PBExportHeader$u_component_service_export_config.sru
forward
global type u_component_service_export_config from u_component_service
end type
end forward

global type u_component_service_export_config from u_component_service
end type
global u_component_service_export_config u_component_service_export_config

type variables
str_config_object_info config_object_info

end variables

forward prototypes
public function integer xx_do_service ()
end prototypes

public function integer xx_do_service ();///////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description:opens the respective utility window
//
// Returns: 1 - Complete the Service 
//          2 - Cancel the Service
//          0 - No operation[Continue]
//
// Created By:Sumathi Chinnasamy										Creation dt: 08/14/2001
//
// Modified By:															Modified On:
///////////////////////////////////////////////////////////////////////////////////////////////////////


integer li_sts
str_popup popup
str_popup_return popup_return
string ls_save_to
string ls_path
string ls_file
string ls_filter
string ls_choices
//str_c_xml_class lstr_xml_class
string ls_message
oleobject lo_config_object_manager
string ls_SqlUser
string ls_SqlPassword
string ls_SqlAppRole
string ls_SqlAppRolePassword
boolean lb_TrustedConnection
string ls_comid
string ls_config_object_id
string ls_export_xml
blob lbl_export_xml
long ll_export_version
string ls_export_version_status
long ll_count
long ll_max_version

setnull(ls_config_object_id)

// See if the key is specified by its actual key name
ls_config_object_id = get_attribute("config_object_id")
if isnull(ls_config_object_id) then
	log.log(this, "u_component_service_export_config.xx_do_service:0045", "No config_object_id specified", 4)
	return -1
end if

// Get the config object info
li_sts = f_get_config_object_info(ls_config_object_id, config_object_info)
if li_sts <= 0 then
	log.log(this, "u_component_service_export_config.xx_do_service:0052", "Error getting object information (" + ls_config_object_id + ")", 4)
	return -1
end if

// Make sure we own this config object
if sqlca.customer_id <> config_object_info.owner_id then
	ls_message = "You must be the owner of a "
	ls_message += lower(config_object_info.config_object_type) + " to export it.  Make a copy of the "
	ls_message += lower(config_object_info.config_object_type) + " and export the copy."
	log.log(this, "u_component_service_export_config.xx_do_service:0061", ls_message, 4)
	openwithparm(w_pop_message, ls_message)
	return 1
end if

// Make sure there is a version record
li_sts = f_config_object_check_version(config_object_info)
if li_sts <= 0 then return -1

SELECT count(*), max(version)
INTO :ll_count, :ll_max_version
FROM c_Config_Object_Version
WHERE config_object_id = :config_object_info.config_object_id
AND status = 'CheckedIn';
if not tf_check() then return -1

if ll_count > 1 then
	// See which version the user wants
	ls_message = "This operation will export the selected " + lower(config_object_info.config_object_type) + " to a file or to the library."
	if config_object_info.installed_version >= 0 then
		ls_message += "  Do you wish to export the currently installed version of this " + lower(config_object_info.config_object_type) + "?"
	else
		ls_message += "  Do you wish to export the latest version of this " + lower(config_object_info.config_object_type) + "?"
	end if
	openwithparm(w_pop_yes_no, ls_message)
	popup_return = message.powerobjectparm
	if popup_return.item = "YES" then
		if config_object_info.installed_version >= 0 then
			ll_export_version = config_object_info.installed_version
		else
			ll_export_version = ll_max_version
		end if
	else
		ll_export_version = f_config_object_pick_version(config_object_info.config_object_id, true, "All")
		if isnull(ll_export_version) then return 1
		if ll_export_version < 0 then return -1
	end if
elseif ll_count = 1 then
	SELECT version
	INTO :ll_export_version
	FROM c_Config_Object_Version
	WHERE config_object_id = :config_object_info.config_object_id;
	if not tf_check() then return -1
else
	log.log(this, "u_component_service_export_config.xx_do_service:0105", "Config object has no version records (" + config_object_info.config_object_id + ")", 4)
	return -1
end if

SELECT status
INTO :ls_export_version_status
FROM c_Config_Object_Version
WHERE config_object_id = :config_object_info.config_object_id
AND version = :ll_export_version;
if not tf_check() then return -1



// Make sure the object is checked in
if lower(ls_export_version_status) = "checkedout" then
	if lower(config_object_info.checked_out_by) = lower(current_user.user_id) then
		ls_message = "This " + lower(config_object_info.config_object_type) + " is checked out by you"
	else
		ls_message = "This " + lower(config_object_info.config_object_type) + " is checked out by " + user_list.user_full_name(config_object_info.checked_out_by)
	end if
	ls_message += " and must be checked in to export.  Do you wish to check the " + lower(config_object_info.config_object_type) + " back in now?"
	openwithparm(w_pop_yes_no, ls_message)
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return 1
	
	li_sts = f_check_in_config_object(config_object_info)
	if li_sts <= 0 then return -1
end if




ls_save_to = get_attribute("save_to")
if isnull(ls_save_to) then
	popup.title = "Save To..."
	popup.data_row_count = 2
	popup.items[1] = "Save To File"
	popup.items[2] = "Upload to Library"
	openwithparm(w_pop_pick, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return 2 // return "cancel"

	if popup_return.item_indexes[1] = 1 then
		ls_save_to = "FILE"
	else
		ls_save_to = "UPLOAD"
	end if
end if

if upper(ls_save_to) = "FILE" then
	ls_path = get_attribute("save_to_path")
	if isnull(ls_path) then
		// The called didn't specify a path so prompt the user for one
		ls_path = f_string_to_filename(config_object_info.description) + "-" + string(ll_export_version) + ".jmjcfg"
		ls_filter = "JMJ Config File (*.jmjcfg), *.jmjcfg, All Files (*.*), *.*"
		li_sts = GetFileSaveName("Select File", ls_path, ls_file, "jmjcfg", ls_filter)
		if li_sts <= 0 then return 2
	end if
end if


if ls_save_to = "UPLOAD" then
	sqlca.jmj_upload_config_object( config_object_info.config_object_id, &
									ll_export_version, &
									current_scribe.user_id)
	if not tf_check() then return -1
	
	openwithparm(w_pop_message, wordcap(config_object_info.config_object_type) + " has been successfully uploaded to the library")
else
	if fileexists(ls_path) then
		openwithparm(w_pop_yes_no, "The selected filename already exists.  Do you wish to overwrite it?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return 1
		
		if not filedelete(ls_path) then
			openwithparm(w_pop_message, "Deleting the existing file failed")
			return 1
		end if
	end if
	
	SELECTBLOB objectdata
	INTO :lbl_export_xml
	FROM c_Config_Object_Version
	WHERE config_object_id = :config_object_info.config_object_id
	AND version = :ll_export_version;
	if not tf_check() then return -1
	if sqlca.sqlnrows <> 1 then
		log.log(this, "u_component_service_export_config.xx_do_service:0192", "Config object version record not found", 4)
		return -1
	end if
	
	li_sts = log.file_write(lbl_export_xml, ls_path)
	if li_sts <= 0 then
		log.log(this, "u_component_service_export_config.xx_do_service:0198", "Saving export document (" + config_object_info.config_object_type + ") failed", 4)
		return -1
	end if
	
	openwithparm(w_pop_message, wordcap(config_object_info.config_object_type) + " has been successfully saved to " + ls_path)
end if

// Always return "I'm Finished"
return 1

end function

on u_component_service_export_config.create
call super::create
end on

on u_component_service_export_config.destroy
call super::destroy
end on

