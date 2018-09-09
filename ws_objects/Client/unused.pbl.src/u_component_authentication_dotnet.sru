$PBExportHeader$u_component_authentication_dotnet.sru
forward
global type u_component_authentication_dotnet from u_component_security
end type
end forward

global type u_component_authentication_dotnet from u_component_security
end type
global u_component_authentication_dotnet u_component_authentication_dotnet

forward prototypes
protected function integer xx_initialize ()
protected function integer xx_shutdown ()
public function string x_authenticate ()
public function integer x_changepassword (string ps_username)
public function string x_establishcredentials (string ps_userid)
public function integer x_reauthenticate (string ps_username)
public function integer x_resetpassword (string ps_adminusername, string ps_resetusername)
public function string x_challenge (string ps_challenge)
protected function integer x_check_username (string ps_username)
protected function integer x_configure_security ()
end prototypes

protected function integer xx_initialize ();integer li_sts
str_attributes lstr_attributes

component_id = "AUTH_JMJ"

if debug_mode then
	log.log(this, "u_component_authentication_dotnet.xx_initialize:0007", "Debug Mode", 2)
end if

// Get the XML document for the component attributes
lstr_attributes = get_attributes()

li_sts = initialize_dotnet_wrapper(lstr_attributes)

return li_sts



end function

protected function integer xx_shutdown ();
TRY
	com_wrapper.disconnectobject( )
CATCH (throwable lt_error)
	log.log(this, "u_component_authentication_dotnet.xx_shutdown:0005", "Error disconnecting ConnectClass (" + lt_error.text + ")", 4)
	return -1
END TRY


DESTROY com_wrapper


return 1


end function

public function string x_authenticate ();string ls_username
string ls_null

setnull(ls_null)

TRY
	ls_username = com_wrapper.Authenticate()
CATCH (throwable lt_error)
	log.log(this, "u_component_authentication_dotnet.x_authenticate:0009", "Error Calling Authenticate (" + lt_error.text + ")", 4)
	return ls_null
END TRY

return ls_username



end function

public function integer x_changepassword (string ps_username);integer li_sts
string ls_null

setnull(ls_null)

TRY
	li_sts = com_wrapper.ChangePassword(ps_username)
CATCH (throwable lt_error)
	log.log(this, "u_component_authentication_dotnet.x_changepassword:0009", "Error Calling ChangePassword (" + lt_error.text + ")", 4)
	return -1
END TRY

return li_sts




end function

public function string x_establishcredentials (string ps_userid);string ls_username
string ls_null

setnull(ls_null)

TRY
	ls_username = com_wrapper.EstablishCredentials(ps_userid)
CATCH (throwable lt_error)
	log.log(this, "u_component_authentication_dotnet.x_establishcredentials:0009", "Error Calling EstablishCredentials (" + lt_error.text + ")", 4)
	return ls_null
END TRY

return ls_username



end function

public function integer x_reauthenticate (string ps_username);integer li_sts
string ls_null

setnull(ls_null)

TRY
	li_sts = com_wrapper.Reauthenticate(ps_username)
CATCH (throwable lt_error)
	log.log(this, "u_component_authentication_dotnet.x_reauthenticate:0009", "Error Calling Reauthenticate (" + lt_error.text + ")", 4)
	return -1
END TRY

return li_sts




end function

public function integer x_resetpassword (string ps_adminusername, string ps_resetusername);integer li_sts
string ls_null

setnull(ls_null)

TRY
	li_sts = com_wrapper.ResetPassword(ps_adminusername, ps_resetusername)
CATCH (throwable lt_error)
	log.log(this, "u_component_authentication_dotnet.x_resetpassword:0009", "Error Calling ResetPassword (" + lt_error.text + ")", 4)
	return -1
END TRY

return li_sts




end function

public function string x_challenge (string ps_challenge);string ls_response
string ls_null

setnull(ls_null)

TRY
	ls_response = com_wrapper.Challenge(ps_challenge)
CATCH (throwable lt_error)
	log.log(this, "u_component_authentication_dotnet.x_challenge:0009", "Error Calling Initialize (" + lt_error.text + ")", 4)
	return ls_null
END TRY

return ls_response



end function

protected function integer x_check_username (string ps_username);integer li_sts
string ls_null

setnull(ls_null)

TRY
	li_sts = com_wrapper.CheckUsername(ps_username)
CATCH (throwable lt_error)
	log.log(this, "u_component_authentication_dotnet.x_check_username:0009", "Error Calling CheckUsername (" + lt_error.text + ")", 4)
	return -1
END TRY

return li_sts




end function

protected function integer x_configure_security ();integer li_sts
string ls_null

setnull(ls_null)

//TRY
//	li_sts = com_wrapper.ConfigureSecurity()
//CATCH (throwable lt_error)
//	log.log(this, "u_component_authentication_dotnet.x_configure_security:0009", "Error Calling ConfigureSecurity (" + lt_error.text + ")", 4)
//	return -1
//END TRY

f_open_browser("https://www.jmjtech.com/Mgmt/UserMgmt/Administration/SecuritySettings.aspx")

return li_sts




end function

on u_component_authentication_dotnet.create
call super::create
end on

on u_component_authentication_dotnet.destroy
call super::destroy
end on

