$PBExportHeader$u_component_security_pin.sru
forward
global type u_component_security_pin from u_component_security
end type
end forward

global type u_component_security_pin from u_component_security
end type
global u_component_security_pin u_component_security_pin

forward prototypes
public function string x_authenticate ()
public function integer x_reauthenticate (string ps_username)
public function integer x_changepassword (string ps_username)
public function integer x_resetpassword (string ps_adminusername, string ps_resetusername)
public function string x_establishcredentials (string ps_userid)
protected function integer xx_initialize ()
end prototypes

public function string x_authenticate ();str_popup popup
str_popup_return popup_return
string ls_user_id
string ls_username


popup.item = "NOLOGON"
popup.title = "Enter Access Code"
openwithparm(w_security_access_code, popup)
popup_return = message.powerobjectparm
if popup_return.item_count < 2 then
	setnull(ls_user_id)
else
	SELECT	user_id, username
	INTO	:ls_user_id, :ls_username
	FROM c_User (nolock)
	WHERE access_id = :popup_return.items[1];
	if not tf_check() then setnull(ls_username)
	if sqlca.sqlcode = 100 then setnull(ls_username)
	
	
//	lstr_attempt_logon.user_id = ls_user_id
//	lstr_attempt_logon.sticky_logon = f_string_to_boolean(popup_return.items[2])
end if

return ls_username


end function

public function integer x_reauthenticate (string ps_username);str_popup popup
str_popup_return popup_return
long ll_count

popup.item = "NOLOGON"
popup.title = "Please Re-Enter Access Code"
openwithparm(w_security_access_code, popup)
popup_return = message.powerobjectparm
if popup_return.item_count < 2 then
	return 0
else
	SELECT count(*)
	INTO	:ll_count
	FROM c_User (nolock)
	WHERE access_id = :popup_return.items[1]
	AND username = :ps_username;
	if not tf_check() then return 0
	
	if ll_count = 1 then return 1
end if

return 0


end function

public function integer x_changepassword (string ps_username);integer li_success
string ls_access_id
str_popup popup
str_popup_return popup_return
string ls_user_id

// DECLARE lsp_change_access_id PROCEDURE FOR dbo.sp_change_access_id  
//         @ps_user_id = :ls_user_id,   
//         @ps_access_id = :ls_access_id,   
//         @pi_success = :li_success OUT ;


SELECT user_id
INTO :ls_user_id
FROM c_User
WHERE username = :ps_username;
if not tf_check() then
	openwithparm(w_pop_message, "Error:  Access Code Not Changed")
	return 0
end if

popup.item = "NOLOGON"
popup.title = "Enter New Access Code"
openwithparm(w_security_access_code, popup)
popup_return = message.powerobjectparm
if popup_return.item_count < 1 then
	openwithparm(w_pop_message, "Access Code Not Changed")
	return 0
end if

ls_access_id = popup_return.items[1]

popup.item = "NOLOGON"
popup.title = "Confirm New Access Code"
openwithparm(w_security_access_code, popup)
popup_return = message.powerobjectparm
if popup_return.item_count < 1 then
	openwithparm(w_pop_message, "Access Code Not Changed")
	return 0
end if

if ls_access_id <> popup_return.items[1] then
	openwithparm(w_pop_message, "Confirmed Code Did Not Match.  Access Code Not Changed")
	return 0
end if

tf_begin_transaction(this, "change_access_id()")
SQLCA.sp_change_access_id   ( &
         ls_user_id,    &
         ls_access_id,    &
         ref li_success );
//EXECUTE lsp_change_access_id;
if not tf_check() then
	openwithparm(w_pop_message, "Error Updating Access Code.  Access Code Not Changed")
	return 0
end if

//FETCH lsp_change_access_id INTO :li_success;
//if not tf_check() then
//	openwithparm(w_pop_message, "Error Updating Access Code.  Access Code Not Changed")
//	return 0
//end if

//CLOSE lsp_change_access_id;

tf_commit()

if li_success = 0 then
	openwithparm(w_pop_message, "Access Code Already In Use.  Access Code Not Changed")
	return 0
end if

openwithparm(w_pop_message, "Access Code Changed")

return 1

end function

public function integer x_resetpassword (string ps_adminusername, string ps_resetusername);integer li_success
string ls_access_id
str_popup popup
str_popup_return popup_return
string ls_user_id

// DECLARE lsp_change_access_id PROCEDURE FOR dbo.sp_change_access_id  
//         @ps_user_id = :ls_user_id,   
//         @ps_access_id = :ls_access_id,   
//         @pi_success = :li_success OUT ;
//

SELECT user_id
INTO :ls_user_id
FROM c_User
WHERE username = :ps_resetusername;
if not tf_check() then
	openwithparm(w_pop_message, "Error:  Access Code Not Changed")
	return 0
end if

popup.item = "NOLOGON"
popup.title = "Enter New Access Code"
openwithparm(w_security_access_code, popup)
popup_return = message.powerobjectparm
if popup_return.item_count < 1 then
	openwithparm(w_pop_message, "Access Code Not Changed")
	return 0
end if

ls_access_id = popup_return.items[1]

popup.item = "NOLOGON"
popup.title = "Confirm New Access Code"
openwithparm(w_security_access_code, popup)
popup_return = message.powerobjectparm
if popup_return.item_count < 1 then
	openwithparm(w_pop_message, "Access Code Not Changed")
	return 0
end if

if ls_access_id <> popup_return.items[1] then
	openwithparm(w_pop_message, "Confirmed Code Did Not Match.  Access Code Not Changed")
	return 0
end if

tf_begin_transaction(this, "change_access_id()")
SQLCA.sp_change_access_id   ( &
         ls_user_id,    &
         ls_access_id,    &
         ref li_success );
//EXECUTE lsp_change_access_id;
if not tf_check() then
	openwithparm(w_pop_message, "Error Updating Access Code.  Access Code Not Changed")
	return 0
end if

//FETCH lsp_change_access_id INTO :li_success;
//if not tf_check() then
//	openwithparm(w_pop_message, "Error Updating Access Code.  Access Code Not Changed")
//	return 0
//end if

//CLOSE lsp_change_access_id;

tf_commit()

if li_success = 0 then
	openwithparm(w_pop_message, "Access Code Already In Use.  Access Code Not Changed")
	return 0
end if

openwithparm(w_pop_message, "Access Code Changed")

return 1

end function

public function string x_establishcredentials (string ps_userid);long ll_sts
string ls_new_username
str_popup popup
str_popup_return popup_return
string ls_null

setnull(ls_null)

popup.title = "Enter New Username"
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return ls_null

ls_new_username = popup_return.items[1]

ll_sts = sqlca.jmj_set_username(ps_userid, ls_new_username)
if ll_sts < 0 then
	openwithparm(w_pop_message, "An error occured while trying to set the new username.  Please try again.  If problem persists, contact your administrator.")
	return ls_null
elseif ll_sts = 0 then
	openwithparm(w_pop_message, "The username you selected is already in use by another user.  The username has NOT been changed.")
	return ls_null
else
	openwithparm(w_pop_message, "The username was successfully changed to " + ls_new_username + ".")
end if

return ls_new_username


end function

protected function integer xx_initialize ();return 1

end function

on u_component_security_pin.create
call super::create
end on

on u_component_security_pin.destroy
call super::destroy
end on

