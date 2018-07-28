HA$PBExportHeader$u_component_config_object_report.sru
forward
global type u_component_config_object_report from u_component_config_object
end type
end forward

global type u_component_config_object_report from u_component_config_object
end type
global u_component_config_object_report u_component_config_object_report

forward prototypes
public function integer encapsulate (str_config_object_info pstr_config_object, ref blob pbl_config_object_data)
public function integer install (string ps_config_object_id, long pl_version)
end prototypes

public function integer encapsulate (str_config_object_info pstr_config_object, ref blob pbl_config_object_data);long ll_sts
u_config_object_manager lo_config_object_manager
string ls_config_object_data

lo_config_object_manager = CREATE u_config_object_manager

ll_sts = lo_config_object_manager.initialize_com()
if ll_sts <= 0 then
	log.log(this, "f_check_in_config_object()", "Error initializing COM object", 4)
	return -1
end if

TRY
	ls_config_object_data = lo_config_object_manager.GetConfigObjectXml(pstr_config_object.config_object_type, pstr_config_object.config_object_id)
CATCH (oleruntimeerror lt_error)
	log.log(this, "f_check_in_config_object_silent()", "Error calling GetConfigObjectXml ~r~n" + lt_error.text + "~r~n" + lt_error.description, 4)
	UPDATE c_Config_Object_Version
	SET status = 'CheckedOut'
	WHERE config_object_id = :pstr_config_object.config_object_id
	AND version = :pstr_config_object.installed_version;
	if not tf_check() then return -1
	return -1
END TRY

lo_config_object_manager.disconnectobject()
DESTROY lo_config_object_manager

if isnull(ls_config_object_data) or len(ls_config_object_data) = 0 then
	setnull(pbl_config_object_data)
else
	pbl_config_object_data = f_string_to_blob(ls_config_object_data, "UTF-8")
end if

return 1


end function

public function integer install (string ps_config_object_id, long pl_version);long ll_sts
u_config_object_manager lo_config_object_manager
string ls_config_object_id
str_config_object_info lstr_config_object_info
integer li_sts
blob lbl_objectdata
string ls_object_xml
string ls_description

if isnull(ps_config_object_id) then
	log.log(this, "f_config_object_install_comobjmgr()", "config_object_id is null", 4)
	return -1
end if

if isnull(pl_version) then
	log.log(this, "f_config_object_install_comobjmgr()", "Version is null", 4)
	return -1
end if

SELECT description
INTO :ls_description
FROM c_Config_Object
WHERE config_object_id = :ps_config_object_id;
if not tf_check() then return -1
if sqlca.sqlnrows <> 1 then
	log.log(this, "f_config_object_install_comobjmgr()", "Config Object record not found (" + ps_config_object_id + ")", 4)
	return -1
end if

// Get the object data
SELECTBLOB objectdata
INTO :lbl_objectdata
FROM c_Config_Object_Version
WHERE config_object_id = :ps_config_object_id
AND version = :pl_version;
if not tf_check() then return -1
if sqlca.sqlnrows <> 1 then
	log.log(this, "f_config_object_install_comobjmgr()", "Version record not found (" + ps_config_object_id + ", " + string(pl_version) + ")", 4)
	return -1
end if
if isnull(lbl_objectdata) then
	log.log(this, "f_config_object_install_comobjmgr()", "Null object data (" + ps_config_object_id + ", " + string(pl_version) + ")", 4)
	return -1
end if

ls_object_xml = f_blob_to_string(lbl_objectdata)

// Post the object data
lo_config_object_manager = CREATE u_config_object_manager

ll_sts = lo_config_object_manager.initialize_com()
if ll_sts <= 0 then
	log.log(this, "f_config_object_install_comobjmgr()", "Error initializing COM object", 4)
	return -1
end if

TRY
	ls_config_object_id = lo_config_object_manager.ImportConfigObject2(ls_object_xml, ps_config_object_id, pl_version)
CATCH (oleruntimeerror lt_error)
	log.log(this, "f_config_object_install_comobjmgr()", "Error calling ImportConfigObject ~r~n" + lt_error.text + "~r~n" + lt_error.description, 4)
	return -1
END TRY

lo_config_object_manager.disconnectobject()
DESTROY lo_config_object_manager

if isnull(ls_config_object_id) or len(ls_config_object_id) = 0 then
	log.log(this, "f_config_object_install_comobjmgr()", "No Config Object ID returned from ImportConfigObject()", 4)
	return -1
end if

// Finally, the config object manager will overwrite the new name with the old name in the case of copied objects, so issue a rename just to be sure the names are all correct
sqlca.config_rename_object(ps_config_object_id,ls_description)
if not tf_check() then return -1

return 1

end function

on u_component_config_object_report.create
call super::create
end on

on u_component_config_object_report.destroy
call super::destroy
end on

