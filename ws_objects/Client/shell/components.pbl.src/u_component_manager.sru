$PBExportHeader$u_component_manager.sru
forward
global type u_component_manager from nonvisualobject
end type
type str_component from structure within u_component_manager
end type
end forward

type str_component from structure
	long		service_id
	string		component_id
	u_component_base_class		service_object
end type

global type u_component_manager from nonvisualobject
event timer ( )
end type
global u_component_manager u_component_manager

type variables
private str_component server_service
private boolean component_trial_mode
private boolean just_in_time_installing
private boolean is_environment_installable

datetime status_last_refreshed

string mod
long mod_count = 1000

boolean license_server


end variables

forward prototypes
public function integer destroy_component (ref u_component_base_class puo_component)
public function string server_mod (string ps_image)
public function u_component_base_class get_uninitialized_component (string ps_component_id)
public function integer initialize ()
public function u_component_base_class get_component (string ps_component_id)
public function u_component_base_class get_component (string ps_component_id, integer pi_attribute_count, string psa_attribute[], string psa_value[])
private function integer get_component (str_component pstr_service)
public function u_component_base_class get_component (string ps_component_id, str_attributes pstr_attributes)
public function integer start_service (long pl_service_id)
public function str_component_version get_component_version (str_component_definition pstr_component_definition)
public function u_component_base_class create_component (str_component_definition pstr_component_definition, str_component_version pstr_component_version)
public function boolean is_version_installed (str_component_definition pstr_component_definition, str_component_version pstr_component_version)
public function integer install_component_version (str_component_definition pstr_component_definition, str_component_version pstr_component_version)
public function boolean is_component_installed (str_component_definition pstr_component_definition)
public function integer install_component_version (string ps_component_id, string ps_version_name)
public function boolean is_environment_installable ()
public subroutine refresh_status ()
public function integer prompt_for_credentials (ref string ps_username, ref string ps_password)
public function boolean is_version_installed (string ps_component_id, string ps_version_name)
public subroutine clear_cache ()
public function integer set_component_attribute (string ps_component_id, string ps_attribute, string ps_value)
public function integer set_component_debug_mode (string ps_component_id, boolean pb_debug_mode)
end prototypes

public function integer destroy_component (ref u_component_base_class puo_component);
if not isvalid(puo_component) or isnull(puo_component) then
	setnull(puo_component)
	return 0
end if

puo_component.shutdown()
DESTROY puo_component
setnull(puo_component)

return 1

end function

public function string server_mod (string ps_image);integer li_sts

if ps_image = mod then
	return mod
else
	return "FALSE"
end if

end function

public function u_component_base_class get_uninitialized_component (string ps_component_id);integer li_sts
string ls_base_class
string ls_component_class
string ls_id
u_component_base_class luo_component
str_component_definition lstr_component_definition
str_component_version lstr_component_version

setnull(luo_component)

if isnull(ps_component_id) then
	log.log(this, "u_component_manager.get_uninitialized_component:0012", "component_id is null", 4)
	return luo_component
end if

lstr_component_definition = f_get_component_definition(ps_component_id)
if isnull(lstr_component_definition.component_id) then return luo_component

lstr_component_version = get_component_version(lstr_component_definition)

//luo_component = create_component(lstr_component_definition, lstr_component_version)

li_sts = luo_component.connect_component()
if li_sts <= 0 then
	DESTROY luo_component
	setnull(luo_component)
	return luo_component
end if

return luo_component

end function

public function integer initialize ();
// force a refresh
setnull(status_last_refreshed)

refresh_status()


return 1

end function

public function u_component_base_class get_component (string ps_component_id);integer li_attribute_count
string lsa_attributes[]
string lsa_values[]

return get_component(ps_component_id, li_attribute_count, lsa_attributes, lsa_values)

end function

public function u_component_base_class get_component (string ps_component_id, integer pi_attribute_count, string psa_attribute[], string psa_value[]);str_attributes lstr_attributes

lstr_attributes = f_attribute_arrays_to_str(pi_attribute_count, psa_attribute, psa_value)

return get_component(ps_component_id, lstr_attributes)

end function

private function integer get_component (str_component pstr_service);integer li_attribute_count
string lsa_attributes[]
string lsa_values[]

li_attribute_count = 1
lsa_attributes[1] = "service_id"
lsa_values[1] = string(pstr_service.service_id)

pstr_service.service_object = get_component(pstr_service.component_id, li_attribute_count, lsa_attributes, lsa_values)

if isnull(pstr_service.service_object) then return -1

return 1

end function

public function u_component_base_class get_component (string ps_component_id, str_attributes pstr_attributes);integer li_sts
integer i
u_component_base_class luo_component
string lsa_attributes[]
string lsa_values[]
str_component_definition lstr_component_definition
str_component_version lstr_component_version
string ls_message
boolean lb_try_create
string ls_username
string ls_password
str_popup_return popup_return

setnull(luo_component)
lb_try_create = false

lstr_component_definition = f_get_component_definition(ps_component_id)

if isnull(lstr_component_definition.component_id) then
	return luo_component
end if

refresh_status()

// Get which version should be installed
lstr_component_version = get_component_version(lstr_component_definition)

f_attribute_str_to_arrays(pstr_attributes, lsa_attributes, lsa_values)

// See if the desired version is installed
li_sts = 0
if not just_in_time_installing or not is_environment_installable or not lstr_component_version.independently_installable then
	lb_try_create = true
elseif is_version_installed(lstr_component_definition, lstr_component_version) then
	// Checking for installation takes more resources so only check if the other try-it-first conditions are not met
	lb_try_create = true
end if

if lb_try_create then
	TRY
		luo_component = create_component(lstr_component_definition, lstr_component_version)
	CATCH (exception le_error)
		ls_message = "Error instantiating component (" + lstr_component_definition.component_id
		if len(lstr_component_version.version_name) > 0 then
			ls_message += ", " + lstr_component_version.version_name
		end if
		ls_message += ")~r~n" + le_error.text
		log.log(this, "u_component_manager.get_component:0048", ls_message, 4)
		setnull(luo_component)
	END TRY
	
	// If we have a component then initialize it
	if not isnull(luo_component) and isvalid(luo_component) then
		li_sts = luo_component.initialize(sqlca, log, ps_component_id, pstr_attributes.attribute_count, lsa_attributes, lsa_values)
		
		if li_sts <= 0 then
			ls_message = "Component instantiated successfully but initialization failed (" + lstr_component_definition.component_id
			if len(lstr_component_version.version_name) > 0 then
				ls_message += ", " + lstr_component_version.version_name
			end if
			ls_message += ")"
			log.log(this, "u_component_manager.get_component:0062", ls_message, 4)
			luo_component.shutdown()
			DESTROY luo_component
			setnull(luo_component)
		end if
	end if
end if

// If we have a component then we're done
if not isnull(luo_component) then return luo_component

if lb_try_create then
	// If we tried to create the component and failed then we may want to try to install/reinstall the component now.  First
	// check to see if there is any reason we can't reinstall now.
	
	if not lstr_component_version.independently_installable then
		// Component is not independentely installable so we're done.  The error message already logged will suffice
		return luo_component
	end if
	
	if not just_in_time_installing then
		// just-in-time installing is turned off so we're done.  The error message already logged will suffice
		return luo_component
	end if
end if
	

li_sts = install_component_version(lstr_component_definition, lstr_component_version)
if li_sts > 0 then
	// Reinstall was successful so try instantiating the component again
	TRY
		luo_component = create_component(lstr_component_definition, lstr_component_version)
	CATCH (exception le_error2)
		ls_message = "Error instantiating component after reinstall (" + lstr_component_definition.component_id
		if len(lstr_component_version.version_name) > 0 then
			ls_message += ", " + lstr_component_version.version_name
		end if
		ls_message += ")~r~n" + le_error2.text
		log.log(this, "u_component_manager.get_component:0100", ls_message, 4)
		setnull(luo_component)
	END TRY
	
	// If we have a component then initialize it
	if not isnull(luo_component) and isvalid(luo_component) then
		li_sts = luo_component.initialize(sqlca, log, ps_component_id, pstr_attributes.attribute_count, lsa_attributes, lsa_values)
		
		if li_sts <= 0 then
			ls_message = "Component instantiated successfully but initialization failed (" + lstr_component_definition.component_id
			if len(lstr_component_version.version_name) > 0 then
				ls_message += ", " + lstr_component_version.version_name
			end if
			ls_message += ")"
			log.log(this, "u_component_manager.get_component:0114", ls_message, 4)
			luo_component.shutdown()
			DESTROY luo_component
			setnull(luo_component)
		end if
	end if
else
	ls_message = "Error installing component (" + lstr_component_definition.component_id
	if len(lstr_component_version.version_name) > 0 then
		ls_message += ", " + lstr_component_version.version_name
	end if
	ls_message += ")"
	log.log(this, "u_component_manager.get_component:0126", ls_message, 4)
end if


return luo_component

end function

public function integer start_service (long pl_service_id);integer i
string ls_system_user_id
str_attempt_logon lstr_logon
string ls_service_name
integer li_service_count
boolean lb_found
long ll_service_id
string ls_temp
integer li_sts
long ll_other_service_id
string ls_message

setnull(ls_system_user_id)
server_service.service_id = pl_service_id

SELECT component_id,
		service_name,
		system_user_id
INTO :server_service.component_id,
		:ls_service_name,
		:ls_system_user_id
FROM o_Server_Component
WHERE service_id = :pl_service_id;
if not tf_check() then return -1

if isnull(ls_system_user_id) then ls_system_user_id = system_user_id

// First log on as the system_user_id found
current_scribe = user_list.set_admin_user(ls_system_user_id)
if isnull(current_scribe) then
	log.log(this, "u_component_manager.start_service:0031", "Error setting admin user (" + ls_system_user_id + ")", 4)
	return -1
end if

setnull(current_scribe.sticky_logon)

current_user = current_scribe

log.initialize(ls_service_name)

if lower(server_service.component_id) = "epie" then
	log.log(this, "u_component_manager.start_service:0042", "EpIE Download Service is no longer available", 3)
	UPDATE o_Server_Component
	SET status = 'NA'
	WHERE component_id = 'EPIE';
	if not tf_check() then return -1
	return 1
else
	// Now instantiate the service
	li_sts = get_component(server_service)
end if

return li_sts


end function

public function str_component_version get_component_version (str_component_definition pstr_component_definition);string ls_version_name
str_component_version lstr_component_version

if component_trial_mode and len(pstr_component_definition.testing_version_name) > 0 then
	ls_version_name = pstr_component_definition.testing_version_name
else
	ls_version_name = pstr_component_definition.normal_version_name
end if

lstr_component_version = f_get_component_version(pstr_component_definition.component_id, ls_version_name, false)

return lstr_component_version

end function

public function u_component_base_class create_component (str_component_definition pstr_component_definition, str_component_version pstr_component_version);integer li_sts
string ls_class
errorreturn le_sts	
boolean lb_ole_class
string ls_share
u_component_base_class luo_component

// First determine which class to actually instantiate
if pos(pstr_component_version.component_class, ".") > 0 then
	ls_class = pstr_component_definition.component_base_class
	lb_ole_class = true
else
	ls_class = pstr_component_version.component_class
	lb_ole_class = false
end if

log.log(this,"u_component_manager.create_component:0017", "Creating component: " + ls_class , 1)

luo_component = CREATE USING ls_class
if not isvalid(luo_component) or isnull(luo_component) then
	setnull(luo_component)
	return luo_component
end if

// Set the component and version
luo_component.component_definition = pstr_component_definition
luo_component.component_version = pstr_component_version

// For older code
luo_component.component_id = pstr_component_definition.component_id
luo_component.ole_class = lb_ole_class
luo_component.my_component_manager = this
luo_component.component_class = pstr_component_version.component_class
luo_component.id = pstr_component_definition.id

return luo_component

end function

public function boolean is_version_installed (str_component_definition pstr_component_definition, str_component_version pstr_component_version);string ls_last_version_installed
string ls_install_date

CHOOSE CASE lower(pstr_component_version.independence)
	CASE "single"
		// For single, the desired version doesn't needs to be the last version installed
		ls_last_version_installed = lower(trim(profilestring(common_thread.epcompinfo, pstr_component_definition.component_id, "ProductVersion", "")))
		
		if ls_last_version_installed = lower(trim(pstr_component_version.version_name)) then
			return true
		end if
	CASE "multi"
		// For multi, the desired version doesn't need to be the last one, so check the specific version
		ls_install_date = lower(trim(profilestring(common_thread.epcompinfo, pstr_component_definition.component_id, pstr_component_version.version_name, "")))
		if len(ls_install_date) > 0 then
			return true
		end if
	CASE ELSE
		// integrated is always considered installed
		return true
END CHOOSE


return false

end function

public function integer install_component_version (str_component_definition pstr_component_definition, str_component_version pstr_component_version);string ls_install_user
string ls_install_pw
string ls_setup_exe
string ls_arguments
blob lbl_setup
integer li_sts
string ls_message
boolean lb_is_admin = false
str_component_version lstr_component_version
str_popup_return popup_return

setnull(ls_install_user)
setnull(ls_install_pw)

if common_thread.utilities_ok() then
	lb_is_admin = common_thread.eprolibnet4.IsUserAdmin() 
end if

if not lb_is_admin then
	ls_install_user = datalist.get_preference("SYSTEM", "Install Username")
	ls_install_pw = datalist.get_preference("SYSTEM", "Install Password")
	
	if isnull(ls_install_user) or isnull(ls_install_pw) then
		ls_message = "The ~"" + pstr_component_definition.description + "~" component has failed to initialize and needs to be reinstalled."
		ls_message += "  This workstation does not have administrator priviliges and no installation credentials have been set in Preferences/Computer Preferences.  Do you with to provide administrator credentials now to install this component?"
		openwithparm(w_pop_yes_no, ls_message)
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return 0
		
		li_sts = prompt_for_credentials(ls_install_user, ls_install_pw)
		if li_sts <= 0 then return li_sts
	end if
end if

// Get the version structure with the installer
lstr_component_version = f_get_component_version(pstr_component_definition.component_id, pstr_component_version.version_name, true)
if isnull(lstr_component_version.objectdata) then
	ls_message = "Component version has no objectdata (" + pstr_component_definition.component_id + ", " + lstr_component_version.version_name + ")"
	log.log(this, "u_component_manager.install_component_version:0035", ls_message, 4)
	sqlca.jmj_component_log(pstr_component_definition.component_id , &
							lstr_component_version.version,  &
							"Install", & 
							datetime(today(), now()) ,  &
							gnv_app.computer_id ,  &
							ls_install_user ,  &
							"ERROR" ,  &
							ls_message ,  &
							current_scribe.user_id  ) 
	if not tf_check() then return -1
	return -1
end if

CHOOSE CASE lower(lstr_component_version.installer)
	CASE "setup.exe"
		ls_setup_exe = f_temp_file("exe")
		li_sts = log.file_write(lstr_component_version.objectdata , ls_setup_exe)
		if li_sts <= 0 then
			ls_message = "Error saving setup.exe to file (" + pstr_component_definition.component_id + ", " + lstr_component_version.version_name + ", " + ls_setup_exe + ")"
			log.log(this, "u_component_manager.install_component_version:0055", ls_message, 4)
			sqlca.jmj_component_log(pstr_component_definition.component_id , &
									lstr_component_version.version,  &
									"Install", & 
									datetime(today(), now()) ,  &
									gnv_app.computer_id ,  &
									ls_install_user ,  &
									"ERROR" ,  &
									ls_message ,  &
									current_scribe.user_id  ) 
			if not tf_check() then return -1
			return -1
		end if
		
		ls_arguments = "/S EncounterPROFolder=" + gnv_app.program_directory + ";"

		if common_thread.utilities_ok() then
			TRY
				if isnull(ls_install_user) or isnull(ls_install_pw) then
					setnull(ls_install_user)
					common_thread.eprolibnet4.ExecuteProgram(ls_setup_exe, ls_arguments)
				else
					common_thread.eprolibnet4.ExecuteProgramAs(ls_setup_exe, ls_arguments, ls_install_user, ls_install_pw)
				end if
			CATCH (oleruntimeerror lt_error)
				ls_message = "Error Installing Component ~r~n"
				ls_message += pstr_component_definition.component_id + ", " + lstr_component_version.version_name + "~r~n" + ls_setup_exe + "~r~n"
				ls_message += lt_error.text + "~r~n" + lt_error.description
				log.log(this, "u_component_manager.install_component_version:0082", ls_message, 4)
				sqlca.jmj_component_log(pstr_component_definition.component_id , &
										lstr_component_version.version,  &
										"Install", & 
										datetime(today(), now()) ,  &
										gnv_app.computer_id ,  &
										ls_install_user ,  &
										"ERROR" ,  &
										ls_message ,  &
										current_scribe.user_id  ) 
				if not tf_check() then return -1
				return -1
			END TRY
		else
			log.log(this, "u_component_manager.install_component_version:0101", "Component not installed (Utilities not available)", 3)
			return -1
		end if
	CASE ELSE
		ls_message = "Unknown installer (" + lstr_component_version.installer + ")"
		log.log(this, "u_component_manager.install_component_version:0106", ls_message, 4)
		sqlca.jmj_component_log(pstr_component_definition.component_id , &
								lstr_component_version.version,  &
								"Install", & 
								datetime(today(), now()) ,  &
								gnv_app.computer_id ,  &
								ls_install_user ,  &
								"ERROR" ,  &
								ls_message ,  &
								current_scribe.user_id  ) 
		if not tf_check() then return -1
		return -1
END CHOOSE

setnull(ls_message)
sqlca.jmj_component_log(pstr_component_definition.component_id , &
						lstr_component_version.version,  &
						"Install", & 
						datetime(today(), now()) ,  &
						gnv_app.computer_id ,  &
						ls_install_user ,  &
						"OK" ,  &
						ls_message ,  &
						current_scribe.user_id  ) 
if not tf_check() then return -1

// If we get here then the installation succeeded so log the version in EPCompInfo
setprofilestring(common_thread.epcompinfo, pstr_component_definition.component_id, "ProductVersion", lstr_component_version.version_name)
setprofilestring(common_thread.epcompinfo, pstr_component_definition.component_id, lstr_component_version.version_name, string(datetime(today(), now())))

return 1

end function

public function boolean is_component_installed (str_component_definition pstr_component_definition);


return true
end function

public function integer install_component_version (string ps_component_id, string ps_version_name);integer li_sts
integer i
u_component_base_class luo_component
string lsa_attributes[]
string lsa_values[]
str_component_definition lstr_component_definition
str_component_version lstr_component_version
string ls_message

setnull(luo_component)

// Get the component structure
lstr_component_definition = f_get_component_definition(ps_component_id)
if isnull(lstr_component_definition.component_id) then
	openwithparm(w_pop_message, "Component not found (" + ps_component_id + ")")
	return -1
end if

// Get the version structure
lstr_component_version = f_get_component_version(lstr_component_definition.component_id, ps_version_name, false)
if isnull(lstr_component_version.component_id) then
	openwithparm(w_pop_message, "Component version not found (" + ps_component_id + ", " + ps_version_name + ")")
	return -1
end if


li_sts = install_component_version(lstr_component_definition, lstr_component_version)
if li_sts <= 0 then
	ls_message = "Error installing component (" + lstr_component_definition.component_id
	if len(lstr_component_version.version_name) > 0 then
		ls_message += ", " + lstr_component_version.version_name
	end if
	ls_message += ")"
	log.log(this, "u_component_manager.install_component_version:0034", ls_message, 4)
	openwithparm(w_pop_message, ls_message)
	return -1
end if


return 1


end function

public function boolean is_environment_installable ();string ls_install_user
string ls_install_pw
boolean lb_is_admin = false

if common_thread.utilities_ok() then
	lb_is_admin = common_thread.eprolibnet4.IsUserAdmin()
end if
if lb_is_admin then return true

ls_install_user = datalist.get_preference("SYSTEM", "Install Username")
ls_install_pw = datalist.get_preference("SYSTEM", "Install Password")

if len(ls_install_user) > 0 and len(ls_install_pw) > 0 then return true

return false

end function

public subroutine refresh_status ();string ls_temp
string ls_install_user
string ls_install_pw
boolean lb_is_admin = false

// check the last refresh, only refresh every minute
if date(status_last_refreshed) = today() then
	if secondsafter(time(status_last_refreshed), now()) < 60 then return
end if

component_trial_mode = datalist.get_preference_boolean("SYSTEM", "Component Trial Mode", false)

just_in_time_installing = datalist.get_preference_boolean("SYSTEM", "Just In Time Installation", false)

if common_thread.utilities_ok() then
	lb_is_admin = common_thread.eprolibnet4.IsUserAdmin()
end if
if lb_is_admin then
	is_environment_installable = true
else
	ls_install_user = datalist.get_preference("SYSTEM", "Install Username")
	ls_install_pw = datalist.get_preference("SYSTEM", "Install Password")
	
	if len(ls_install_user) > 0 and len(ls_install_pw) > 0 then
		is_environment_installable = true
	else
		is_environment_installable = true
	end if
end if

status_last_refreshed = datetime(today(), now())

return

end subroutine

public function integer prompt_for_credentials (ref string ps_username, ref string ps_password);str_param_setting lstr_param
str_param_wizard_return lstr_return
string ls_preference_value
string ls_flag
string ls_encrypted
string ls_preference_enc
w_param_setting lw_param_window


lstr_param.param.param_class = "u_param_credentials"
lstr_param.param.param_title = "Component Installation (Administrator) Credentials"
lstr_param.param.token1 = "username"
lstr_param.param.token2 = "password"
lstr_param.param.helptext = "Enter credentials which have the authority to install components on this computer."
lstr_param.param.query = ""
lstr_param.param.required_flag = "Y"

openwithparm(lw_param_window, lstr_param, "w_param_setting")
lstr_return = message.powerobjectparm
if lstr_return.return_status <= 0 then
	return 0
end if

ps_username = f_attribute_find_attribute(lstr_return.attributes, lstr_param.param.token1)
ps_password = f_attribute_find_attribute(lstr_return.attributes, lstr_param.param.token2)

return 1

end function

public function boolean is_version_installed (string ps_component_id, string ps_version_name);integer li_sts
integer i
u_component_base_class luo_component
string lsa_attributes[]
string lsa_values[]
str_component_definition lstr_component_definition
str_component_version lstr_component_version
string ls_message

setnull(luo_component)

// Get the component structure
lstr_component_definition = f_get_component_definition(ps_component_id)
if isnull(lstr_component_definition.component_id) then
	openwithparm(w_pop_message, "Component not found (" + ps_component_id + ")")
	return false
end if

// Get the version structure
lstr_component_version = f_get_component_version(lstr_component_definition.component_id, ps_version_name, false)
if isnull(lstr_component_version.component_id) then
	openwithparm(w_pop_message, "Component version not found (" + ps_component_id + ", " + ps_version_name + ")")
	return false
end if


return is_version_installed(lstr_component_definition, lstr_component_version)

end function

public subroutine clear_cache ();
status_last_refreshed = datetime(date("1/1/1900"), time("00:00:00"))


end subroutine

public function integer set_component_attribute (string ps_component_id, string ps_attribute, string ps_value);

UPDATE c_component_attribute
SET value = :ps_value
WHERE component_id = :ps_component_id
AND attribute = :ps_attribute;
if not tf_check() then return -1
if sqlca.sqlnrows = 0 then
	INSERT INTO c_component_attribute (
		component_id,
		attribute,
		value)
	VALUES (
		:ps_component_id,
		:ps_attribute,
		:ps_value);
	if not tf_check() then return -1
end if

return 1

end function

public function integer set_component_debug_mode (string ps_component_id, boolean pb_debug_mode);string ls_attribute
string ls_value

ls_attribute = 'debug_mode'
if pb_debug_mode then
	ls_value = 'True'
else
	ls_value = 'False'
end if

return set_component_attribute(ps_component_id, ls_attribute, ls_value)

end function

on u_component_manager.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_component_manager.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

