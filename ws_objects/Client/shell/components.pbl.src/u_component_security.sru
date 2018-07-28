$PBExportHeader$u_component_security.sru
forward
global type u_component_security from u_component_base_class
end type
end forward

global type u_component_security from u_component_base_class
end type
global u_component_security u_component_security

type variables
u_ds_data users
u_ds_data user_search
u_ds_data roles
u_ds_data user_roles
u_ds_data user_privileges
u_ds_data user_services
u_ds_data c_Privilege
u_ds_data o_users

datetime users_refresh
datetime roles_refresh
datetime user_roles_refresh
datetime user_privileges_refresh
datetime user_services_refresh
datetime c_Privilege_refresh
datetime o_users_refresh

long user_refresh_interval

string admin_user_id


end variables

forward prototypes
public function string user_short_name (string ps_user_id)
public function u_user find_provider (long pl_billing_code)
public function u_user find_billing_provider (string ps_billing_id)
public function string user_full_name (string ps_user_id)
public function long user_color (string ps_user_id)
public function boolean is_user (string ps_user_id)
public function boolean is_role (string ps_role_id)
public function boolean is_user_role (string ps_user_id, string ps_role_id)
private function long find_user_row (string ps_user_id)
private function long find_role_row (string ps_role_id)
public function string user_initial (string ps_user_id)
public function string role_description (string ps_role_id)
public function string role_name (string ps_role_id)
public function string gen_unique_key (u_user puo_user)
public function u_user pick_user ()
public function long role_color (string ps_role_id)
public function integer all_users (ref str_user pstra_users[])
public function u_user find_user (string ps_user_id)
public function integer inactivate_user (string ps_user_id)
public function boolean is_superuser (string ps_user_id)
public function boolean is_user_privileged (string ps_user_id, string ps_privilege_id)
public function integer activate_user (string ps_user_id)
public function string user_email_address (string ps_user_id)
public function string supervisor_user_id (string ps_user_id)
public function integer roles_assigned_to_user (string ps_user_id, ref str_role pstra_roles[])
public function integer get_user (string ps_user_id, ref str_user pstr_user)
public function u_user pick_user (string ps_role_id, boolean pb_allow_roles)
public function u_user pick_user (string ps_role_id)
public function integer pick_users (boolean pb_allow_roles, ref str_users pstr_users)
public function integer pick_users (ref str_pick_users pstr_pick_users)
public function integer pick_users (ref str_users pstr_users)
public function u_user pick_user (boolean pb_allow_roles, boolean pb_allow_system_users, boolean pb_allow_special_users)
public function integer pick_users (boolean pb_allow_roles, boolean pb_allow_system_users, boolean pb_allow_special_users, ref str_users pstr_users)
public function integer load_users ()
public function boolean is_user_service (string ps_user_id, string ps_service)
protected function integer xx_change_access_code (string ps_user_id)
protected function str_attempt_logon xx_attempt_logon ()
public function integer change_access_code (string ps_user_id)
public function u_user attempt_logon ()
public function u_user user_logon (str_attempt_logon pstr_user)
public function integer users_in_role (string ps_role_id, ref str_user pstra_users[])
public function any user_property (string ps_user_id, string ps_property)
public function string user_signature_stamp (string ps_user_id)
public function boolean is_active_user (string ps_user_id)
public function boolean check_access (string ps_user_id, str_access_control_list pstr_access_control_list)
public subroutine clear_cache ()
public function string user_username (string ps_user_id)
private function string find_username (string ps_username)
public function string establishcredentials (string ps_user_id)
public function integer resetpassword (string ps_reset_user_id)
public function integer initialize ()
public function string encrypt_challenge (string ps_challenge)
public function boolean is_user_authorized (string ps_user_id, string ps_service, string ps_context_object)
public function string new_user (string ps_actor_class)
public function boolean user_certified (string ps_user_id)
public function boolean user_clinical_access_flag (string ps_user_id)
public function string authenticate ()
public function integer close_session ()
public function integer configure_security ()
public function integer check_username (string ps_username)
protected function integer x_check_username (string ps_username)
protected function string x_authenticate ()
protected function string x_challenge (string ps_challenge)
protected function integer x_changepassword (string ps_username)
protected function integer x_configure_security ()
protected function string x_establishcredentials (string ps_userid)
protected function integer x_reauthenticate (string ps_username)
protected function integer x_resetpassword (string ps_adminusername, string ps_resetusername)
public subroutine refresh_user (string ps_user_id)
public function integer set_user_progress (string ps_user_id, string ps_progress_type, string ps_progress_key, string ps_progress)
public function string is_user_service_grant (string ps_user_id, string ps_service)
public function u_user set_admin_user (string ps_admin_user_id)
public function boolean is_actor_class (string ps_user_id, string ps_actor_class)
public function integer update_user_old (u_user puo_user)
public function boolean user_may_take_over_encounter (string ps_user_id, string ps_encounter_owner_user_id)
public function boolean is_user_privileged (string ps_user_id, string ps_privilege_id, boolean pb_include_superusers)
public function integer set_scribe_context (string ps_user_id)
end prototypes

public function string user_short_name (string ps_user_id);long ll_user_row

if is_user(ps_user_id) then
	ll_user_row = find_user_row(ps_user_id)
	if isnull(ll_user_row) then return ""
	
	return users.object.user_short_name[ll_user_row]
elseif is_role(ps_user_id) then
	return role_description(ps_user_id)
else
	return ""
end if



end function

public function u_user find_provider (long pl_billing_code);u_user luo_user
string ls_find
long ll_row
string ls_user_id

setnull(luo_user)

SELECT min(user_id)
INTO :ls_user_id
FROM c_User
WHERE billing_code = :pl_billing_code;
if not tf_check() then return luo_user

if len(ls_user_id) > 0 then
	return find_user(ls_user_id)
end if

return luo_user


end function

public function u_user find_billing_provider (string ps_billing_id);u_user luo_user
string ls_find
long ll_row
string ls_user_id

setnull(luo_user)

SELECT min(user_id)
INTO :ls_user_id
FROM c_User
WHERE billing_id = :ps_billing_id;
if not tf_check() then return luo_user

if len(ls_user_id) > 0 then
	return find_user(ls_user_id)
end if

return luo_user

end function

public function string user_full_name (string ps_user_id);long ll_user_row

if is_user(ps_user_id) then
	ll_user_row = find_user_row(ps_user_id)
	if isnull(ll_user_row) then return ""
	
	return users.object.user_full_name[ll_user_row]
elseif is_role(ps_user_id) then
	return role_description(ps_user_id)
else
	return ""
end if



end function

public function long user_color (string ps_user_id);long ll_user_row

if is_user(ps_user_id) then
	ll_user_row = find_user_row(ps_user_id)
	if isnull(ll_user_row) then return color_light_grey
	
	return users.object.color[ll_user_row]
elseif is_role(ps_user_id) then
	return role_color(ps_user_id)
else
	return color_object
end if



end function

public function boolean is_user (string ps_user_id);long ll_row

//ll_row = find_user_row(ps_user_id)
//if ll_row > 0 then return true

if left(ps_user_id, 1) <> "!" then return true

return false


end function

public function boolean is_role (string ps_role_id);long ll_row
string ls_find

//ls_find = "role_id='" + ps_role_id + "'"
//ll_row = roles.find(ls_find, 1, roles.rowcount())
//if ll_row > 0 then return true

if left(ps_role_id, 1) = "!" then return true

return false

end function

public function boolean is_user_role (string ps_user_id, string ps_role_id);long ll_row
string ls_find

ls_find = "lower(user_id)='" + lower(ps_user_id) + "' and lower(role_id)='" + lower(ps_role_id) + "'"
ll_row = user_roles.find(ls_find, 1, user_roles.rowcount())
if ll_row > 0 then return true

return false

end function

private function long find_user_row (string ps_user_id);long ll_row
string ls_find
long ll_count
integer li_sts

if isnull(ps_user_id) or ps_user_id = "" then
	setnull(ll_row)
else
	ls_find = "lower(user_id)='" + lower(ps_user_id) + "'"
	ll_row = users.find(ls_find, 1, users.rowcount())
	if ll_row <= 0 then
		ll_count = user_search.retrieve(ps_user_id)
		if ll_count <= 0 then
			setnull(ll_row)
		else
			ll_row = users.rowcount() + 1
			li_sts = user_search.RowsCopy (1, 1, primary!, users, ll_row, primary!)
			if li_sts <= 0 then
				setnull(ll_row)
			end if
		end if
	end if
end if

return ll_row

end function

private function long find_role_row (string ps_role_id);long ll_row
string ls_find

ls_find = "lower(role_id)='" + lower(ps_role_id) + "'"
ll_row = roles.find(ls_find, 1, roles.rowcount())
if ll_row <= 0 then
	clear_cache()
	load_users()
	ll_row = roles.find(ls_find, 1, roles.rowcount())
	if ll_row <= 0 then
		setnull(ll_row)
	end if
end if

return ll_row

end function

public function string user_initial (string ps_user_id);long ll_user_row

ll_user_row = find_user_row(ps_user_id)
if isnull(ll_user_row) then return ""

return users.object.user_initial[ll_user_row]


end function

public function string role_description (string ps_role_id);long ll_role_row

ll_role_row = find_role_row(ps_role_id)
if isnull(ll_role_row) then return ""

return roles.object.description[ll_role_row]


end function

public function string role_name (string ps_role_id);long ll_role_row

ll_role_row = find_role_row(ps_role_id)
if isnull(ll_role_row) then return ""

return roles.object.role_name[ll_role_row]


end function

public function string gen_unique_key (u_user puo_user);string ls_user_id
integer i
integer li_count
string ls_null

setnull(ls_null)

ls_user_id = office_id + f_gen_key_string(puo_user.user_full_name, 16)

if isnull(ls_user_id) then ls_user_id = office_id

for i = 1 to 9999
	SELECT count(*)
	INTO :li_count
	FROM c_User
	WHERE user_id = :ls_user_id;
	if not tf_check() then return ls_null
	
	if li_count = 0 then return ls_user_id

	ls_user_id = left(ls_user_id, 20) + string(i)
next

return ls_null
	

end function

public function u_user pick_user ();string ls_null

setnull(ls_null)

return pick_user(ls_null, false)

end function

public function long role_color (string ps_role_id);long ll_role_row

ll_role_row = find_role_row(ps_role_id)
if isnull(ll_role_row) then return color_object

return roles.object.color[ll_role_row]


end function

public function integer all_users (ref str_user pstra_users[]);long i
long li_user_count

li_user_count = 0

for i = 1 to users.rowcount()
	if users.object.user_status[i] <> "OK" then continue
	li_user_count += 1
	pstra_users[li_user_count].user_id = users.object.user_id[i]
	pstra_users[li_user_count].user_full_name = users.object.user_full_name[i]
	pstra_users[li_user_count].user_short_name = users.object.user_short_name[i]
	pstra_users[li_user_count].color = users.object.color[i]
next

return li_user_count

end function

public function u_user find_user (string ps_user_id);/////////////////////////////////////////////////////////////////////////////////
//
//	Function: add_user
//
// Arguments: 
//
//	Return: Integer
//
//	Description: adds each user into u_user[].
//
// Created On:																Created On:
//
// Modified By:Sumathi Chinnasamy									Modified On:08/24/99
/////////////////////////////////////////////////////////////////////////////////
u_user luo_user
u_user luo_null_user
string ls_find
long ll_row
long ll_user_index
string ls_user_status
string ls_status

setnull(luo_null_user)

if isnull(ps_user_id) then return luo_null_user

load_users()

if left(ps_user_id, 1) = "!" then
	ll_row = find_role_row(ps_user_id)
	if ll_row <= 0 or isnull(ll_row) then return luo_null_user
	
	luo_user = CREATE u_user
	
	luo_user.user_id = roles.object.role_id[ll_row]
	luo_user.clinical_access_flag = false
	setnull(luo_user.specialty_id)
	luo_user.user_status = "ROLE"
	luo_user.actor_class = "Role"
//	luo_user.user_full_name = roles.object.description[ll_row]
	luo_user.user_full_name = "Any " + roles.object.role_name[ll_row]
	luo_user.user_short_name = roles.object.role_name[ll_row]
	luo_user.color = roles.object.color[ll_row]
	setnull(luo_user.primary_office_id)
	setnull(luo_user.user_initial)
	setnull(luo_user.first_name)
	setnull(luo_user.middle_name)
	setnull(luo_user.last_name)
	setnull(luo_user.degree)
	setnull(luo_user.name_prefix)
	setnull(luo_user.name_suffix)
	setnull(luo_user.dea_number)
	setnull(luo_user.license_number)
	setnull(luo_user.supervisor_user_id)
	setnull(luo_user.certified)
	setnull(luo_user.billing_id)
	setnull(luo_user.billing_code)
	setnull(luo_user.activate_date)
	setnull(luo_user.modified)
	setnull(luo_user.modified_by)
	setnull(luo_user.created)
	setnull(luo_user.created_by)
	setnull(luo_user.license_flag)
	setnull(luo_user.email_address)
	setnull(luo_user.username)

	setnull(luo_user.organization_contact)
	setnull(luo_user.organization_director)
	setnull(luo_user.title)

	setnull(luo_user.information_system_type)
	setnull(luo_user.information_system_version)


	setnull(luo_user.supervisor)
	
	setnull(luo_user.sticky_logon)
else
	ll_row = find_user_row(ps_user_id)
	if ll_row <= 0 or isnull(ll_row) then return luo_null_user
	
	luo_user = CREATE u_user
	
	luo_user.user_id = users.object.user_id[ll_row]
	luo_user.specialty_id = users.object.specialty_id[ll_row]
	luo_user.user_full_name = users.object.user_full_name[ll_row]
	luo_user.user_short_name = users.object.user_short_name[ll_row]
	luo_user.color = users.object.color[ll_row]
	luo_user.primary_office_id = users.object.office_id[ll_row]
	luo_user.user_initial = users.object.user_initial[ll_row]
	luo_user.first_name = users.object.first_name[ll_row]
	luo_user.middle_name = users.object.middle_name[ll_row]
	luo_user.last_name = users.object.last_name[ll_row]
	luo_user.degree = users.object.degree[ll_row]
	luo_user.name_prefix = users.object.name_prefix[ll_row]
	luo_user.name_suffix = users.object.name_suffix[ll_row]
	luo_user.dea_number = users.object.dea_number[ll_row]
	luo_user.license_number = users.object.license_number[ll_row]
	luo_user.supervisor_user_id = users.object.supervisor_user_id[ll_row]
	luo_user.certified = users.object.certified[ll_row]
	luo_user.billing_id = users.object.billing_id[ll_row]
	luo_user.billing_code = users.object.billing_code[ll_row]
	luo_user.activate_date = users.object.activate_date[ll_row]
	luo_user.modified = users.object.modified[ll_row]
	luo_user.modified_by = users.object.modified_by[ll_row]
	luo_user.created = users.object.created[ll_row]
	luo_user.created_by = users.object.created_by[ll_row]
	luo_user.license_flag = users.object.license_flag[ll_row]
	luo_user.email_address = users.object.email_address[ll_row]
	luo_user.username = users.object.username[ll_row]
	luo_user.upin = users.object.upin[ll_row]
	luo_user.certification_number = users.object.certification_number[ll_row]
	luo_user.npi = users.object.npi[ll_row]
	luo_user.actor_class = users.object.actor_class[ll_row]
	luo_user.actor_type = users.object.actor_type[ll_row]
	luo_user.actor_id = users.object.actor_id[ll_row]
	luo_user.clinical_access_flag = f_string_to_boolean(string(users.object.clinical_access_flag[ll_row]))

	
	luo_user.organization_contact = users.object.organization_contact[ll_row]
	luo_user.organization_director = users.object.organization_director[ll_row]
	luo_user.title = users.object.title[ll_row]

	luo_user.information_system_type = users.object.information_system_type[ll_row]
	luo_user.information_system_version = users.object.information_system_version[ll_row]

	luo_user.supervisor = user_list.find_user(luo_user.supervisor_user_id)

	ls_user_status = users.object.user_status[ll_row]
	ls_status = users.object.status[ll_row]
	if lower(luo_user.actor_class) = "user" then
		luo_user.user_status = ls_user_status
	else
		luo_user.user_status = ls_status
	end if
	
	luo_user.sticky_logon = FALSE
end if

RETURN luo_user


end function

public function integer inactivate_user (string ps_user_id);u_user luo_user

luo_user = find_user(ps_user_id)
if isnull(luo_user) then
	log.log(this, "inactivate_user()", "Invalid user_id (" + ps_user_id + ")", 4)
	return -1
end if

if lower(luo_user.actor_class) = "user" then
	set_user_progress(ps_user_id, "Modify", "user_status", "NA")
	set_user_progress(ps_user_id, "Modify", "status", "NA")
elseif lower(luo_user.actor_class) <> "role" then
	set_user_progress(ps_user_id, "Modify", "status", "NA")
end if

set_user_progress(ps_user_id, "Modify", "activate_date", string(datetime(today(), now())))

return 1


end function

public function boolean is_superuser (string ps_user_id);long ll_row
string ls_find
string ls_access_flag

// See if user is a superuser
ls_find = "user_id='" + ps_user_id + "' and upper(privilege_id)='SUPER USER'"
ll_row = user_privileges.find(ls_find, 1, user_privileges.rowcount())
if ll_row > 0 then
	ls_access_flag = user_privileges.object.access_flag[ll_row]
	if ls_access_flag = "G" then return true
end if

return false

end function

public function boolean is_user_privileged (string ps_user_id, string ps_privilege_id);return is_user_privileged(ps_user_id, ps_privilege_id, true)

end function

public function integer activate_user (string ps_user_id);integer li_count
datetime ldt_reactdays
string ls_temp
string ls_left
string ls_right
u_user luo_user
str_stamp lstr_stamp

luo_user = find_user(ps_user_id)
if isnull(luo_user) then
	log.log(this, "activate_user()", "Invalid user_id (" + ps_user_id + ")", 4)
	return -1
end if

ldt_reactdays = datetime(relativedate(today(), -reactdays), now())

if luo_user.license_flag = "P" or luo_user.license_flag = "E" then
	// Count how many there are now
	SELECT count(*)
	INTO :li_count
	FROM c_User
	WHERE license_flag = :luo_user.license_flag
	AND user_status = 'OK';
	if not tf_check() then return -1
	
	// Now see how many are allowed
	lstr_stamp = f_get_stamp()
	
	// If activating this user would be too many, then don't do it
	if luo_user.license_flag = "P" and li_count >= lstr_stamp.providers then
		f_message(8)
		return -1
	elseif luo_user.license_flag = "E" and li_count >= lstr_stamp.extenders then
		f_message(8)
		return -1
	end if
end if

if ldt_reactdays < luo_user.activate_date then
	f_message(7)
	return -1
end if


luo_user.user_status = 'OK'

if lower(luo_user.actor_class) = "user" then
	set_user_progress(ps_user_id, "Modify", "user_status", "OK")
	set_user_progress(ps_user_id, "Modify", "status", "OK")
elseif lower(luo_user.actor_class) <> "role" then
	set_user_progress(ps_user_id, "Modify", "status", "OK")
end if

set_user_progress(ps_user_id, "Modify", "activate_date", string(datetime(today(), now())))

return 1


end function

public function string user_email_address (string ps_user_id);long ll_user_row

ll_user_row = find_user_row(ps_user_id)
if isnull(ll_user_row) then return ""

return users.object.email_address[ll_user_row]


end function

public function string supervisor_user_id (string ps_user_id);long ll_user_row
string ls_null

setnull(ls_null)

ll_user_row = find_user_row(ps_user_id)
if isnull(ll_user_row) then return ls_null

return users.object.supervisor_user_id[ll_user_row]


end function

public function integer roles_assigned_to_user (string ps_user_id, ref str_role pstra_roles[]);string ls_find_role
string ls_find_user
long ll_role_row
long ll_user_row
long ll_user_roles
string ls_role_id
integer li_role_count

li_role_count = 0
ll_user_roles = user_roles.rowcount()

if isnull(ps_user_id) then return 0

ls_find_user = "user_id='" + ps_user_id + "'"

ll_user_row = user_roles.find(ls_find_user, 1, ll_user_roles)
DO WHILE ll_user_row > 0 and ll_user_row <= ll_user_roles
	ls_role_id = user_roles.object.role_id[ll_user_row]
	ll_role_row = find_role_row(ls_role_id)
	if ll_role_row > 0 then
		li_role_count += 1
		pstra_roles[li_role_count].role_id = ls_role_id
		pstra_roles[li_role_count].role_name = roles.object.role_name[ll_role_row]
		pstra_roles[li_role_count].description = roles.object.description[ll_role_row]
		pstra_roles[li_role_count].color = roles.object.color[ll_role_row]
	end if

	ll_user_row = user_roles.find(ls_find_user, ll_user_row + 1, ll_user_roles + 1)
LOOP

return li_role_count

end function

public function integer get_user (string ps_user_id, ref str_user pstr_user);str_user lstr_user
u_user luo_user
long ll_row

luo_user = find_user(ps_user_id)
if isnull(luo_user) then return 0

pstr_user.user_id = luo_user.user_id
pstr_user.user_full_name = luo_user.user_full_name
pstr_user.user_short_name = luo_user.user_short_name
pstr_user.color = luo_user.color
	
return 1

end function

public function u_user pick_user (string ps_role_id, boolean pb_allow_roles);u_user luo_user
str_pick_users lstr_pick_users
string ls_null
integer li_sts

setnull(ls_null)
setnull(luo_user)

if ps_role_id = "ALL" or isnull(ps_role_id) or trim(ps_role_id) = "" then
	setnull(ps_role_id)
end if

lstr_pick_users.role_id = ps_role_id
lstr_pick_users.allow_roles = pb_allow_roles
lstr_pick_users.allow_system_users = false
lstr_pick_users.allow_special_users = false
lstr_pick_users.allow_multiple = false

li_sts = pick_users(lstr_pick_users)
if li_sts <= 0 then return luo_user

return find_user(lstr_pick_users.selected_users.user[1].user_id)


end function

public function u_user pick_user (string ps_role_id);return pick_user(ps_role_id, false)
end function

public function integer pick_users (boolean pb_allow_roles, ref str_users pstr_users);str_pick_users lstr_pick_users
integer li_sts

lstr_pick_users.allow_roles = pb_allow_roles
lstr_pick_users.allow_system_users = false
lstr_pick_users.allow_special_users = false
lstr_pick_users.allow_multiple = true
lstr_pick_users.selected_users = pstr_users

li_sts = pick_users(lstr_pick_users)

pstr_users = lstr_pick_users.selected_users

return li_sts

end function

public function integer pick_users (ref str_pick_users pstr_pick_users);w_pick_user lw_pick_user

openwithparm(lw_pick_user, pstr_pick_users, "w_pick_user")
pstr_pick_users.selected_users = message.powerobjectparm

return pstr_pick_users.selected_users.user_count


end function

public function integer pick_users (ref str_users pstr_users);str_pick_users lstr_pick_users
integer li_sts

lstr_pick_users.allow_roles = false
lstr_pick_users.allow_system_users = false
lstr_pick_users.allow_special_users = false
lstr_pick_users.allow_multiple = true
lstr_pick_users.selected_users = pstr_users

li_sts = pick_users(lstr_pick_users)

pstr_users = lstr_pick_users.selected_users

return li_sts

end function

public function u_user pick_user (boolean pb_allow_roles, boolean pb_allow_system_users, boolean pb_allow_special_users);str_pick_users lstr_pick_users
u_user luo_user
integer li_sts

lstr_pick_users.allow_roles = pb_allow_roles
lstr_pick_users.allow_system_users = pb_allow_system_users
lstr_pick_users.allow_special_users = pb_allow_special_users
lstr_pick_users.allow_multiple = false

li_sts = pick_users(lstr_pick_users)
if li_sts <= 0 then
	setnull(luo_user)
else
	luo_user = find_user(lstr_pick_users.selected_users.user[1].user_id)
end if

return luo_user


end function

public function integer pick_users (boolean pb_allow_roles, boolean pb_allow_system_users, boolean pb_allow_special_users, ref str_users pstr_users);str_pick_users lstr_pick_users
integer li_sts

lstr_pick_users.allow_roles = pb_allow_roles
lstr_pick_users.allow_system_users = pb_allow_system_users
lstr_pick_users.allow_special_users = pb_allow_special_users
lstr_pick_users.allow_multiple = true
lstr_pick_users.selected_users = pstr_users

li_sts = pick_users(lstr_pick_users)

pstr_users = lstr_pick_users.selected_users

return li_sts

end function

public function integer load_users ();/////////////////////////////////////////////////////////////////////////////////
//
//	Function: load_users
//
// Arguments:
//
//	Return: Integer
//
//	Description: retrieve all users list from database and load them
//             into u_user[].
//
// Created On:																Created On:
//
// Modified By:Sumathi Chinnasamy									Modified On:08/24/99
/////////////////////////////////////////////////////////////////////////////////
integer li_sts
long i
datetime ldt_last_update

ldt_last_update = datalist.last_table_update("c_user")
if isnull(users_refresh) or ldt_last_update > users_refresh then
	users_refresh = ldt_last_update
	users.set_dataobject("dw_data_user_list")
//	li_sts = users.retrieve()
//	if li_sts < 0 then
//		log.log(this, "load_users()", "Error loading users table", 4)
//		return -1
//	end if
end if
	
ldt_last_update = datalist.last_table_update("c_role")
if isnull(roles_refresh) or ldt_last_update > roles_refresh then
	roles_refresh = ldt_last_update
	roles.set_dataobject("dw_data_role_list")
	li_sts = roles.retrieve()
	if li_sts < 0 then
		log.log(this, "load_users()", "Error loading roles table", 4)
		return -1
	end if
end if
	
ldt_last_update = datalist.last_table_update("c_user_role")
if isnull(user_roles_refresh) or ldt_last_update > user_roles_refresh then
	user_roles_refresh = ldt_last_update
	user_roles.set_dataobject("dw_data_user_role_list")
	li_sts = user_roles.retrieve()
	if li_sts < 0 then
		log.log(this, "load_users()", "Error loading user_roles table", 4)
		return -1
	end if
end if
	
ldt_last_update = datalist.last_table_update("o_user_service")
if isnull(user_services_refresh) or ldt_last_update > user_services_refresh then
	user_services_refresh = ldt_last_update
	user_services.set_dataobject("dw_data_user_service_list")
	li_sts = user_services.retrieve(office_id)
	if li_sts < 0 then
		log.log(this, "load_users()", "Error loading user_services table", 4)
		return -1
	end if
end if
	
ldt_last_update = datalist.last_table_update("o_user_privilege")
if isnull(user_privileges_refresh) or ldt_last_update > user_privileges_refresh then
	user_privileges_refresh = ldt_last_update
	user_privileges.set_dataobject("dw_data_user_privilege_list")
	li_sts = user_privileges.retrieve(office_id)
	if li_sts < 0 then
		log.log(this, "load_users()", "Error loading user_privileges table", 4)
		return -1
	end if
end if


ldt_last_update = datalist.last_table_update("c_privilege")
if isnull(c_privilege_refresh) or ldt_last_update > c_privilege_refresh then
	c_privilege_refresh = ldt_last_update
	c_privilege.set_dataobject("dw_c_privilege")
	li_sts = c_privilege.retrieve()
	if li_sts < 0 then
		log.log(this, "load_users()", "Error loading c_privilege table", 4)
		return -1
	end if
end if


Return 1


end function

public function boolean is_user_service (string ps_user_id, string ps_service);long ll_row
string ls_find
string ls_access_flag
string ls_secure_flag
str_role lstra_roles[]
integer li_role_count
integer i
long ll_rowcount
string ls_grant
string ls_user_status

// If the user is an admin user then return true
if lower(ps_user_id) = lower(admin_user_id) then return true

// See if user is a superuser
if is_superuser(ps_user_id) then return true

// See if there is a specific Grant record for this user
ls_grant = is_user_service_grant(ps_user_id, ps_service)
if ls_grant = "G" then return true
if ls_grant = "R" then return false

// If we get here then we didn't find a specific grant or revoke record, so 
// check the default grant for the service
ls_secure_flag = datalist.service_secure_flag(ps_service)
if isnull(ls_secure_flag) or ls_secure_flag = "Y" then
	// This service is secure so only allow user access if they had a "Grant" record
	return false
else
	// This service is not secure so give the user access since they did not have a "Revoke" record
	return true
end if


end function

protected function integer xx_change_access_code (string ps_user_id);integer li_success
string ls_access_id
str_popup popup
str_popup_return popup_return

 DECLARE lsp_change_access_id PROCEDURE FOR dbo.sp_change_access_id  
         @ps_user_id = :ps_user_id,   
         @ps_access_id = :ls_access_id,   
         @pi_success = :li_success OUT ;

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

EXECUTE lsp_change_access_id;
if not tf_check() then
	openwithparm(w_pop_message, "Error Updating Access Code.  Access Code Not Changed")
	return 0
end if

FETCH lsp_change_access_id INTO :li_success;
if not tf_check() then
	openwithparm(w_pop_message, "Error Updating Access Code.  Access Code Not Changed")
	return 0
end if

CLOSE lsp_change_access_id;

tf_commit()

if li_success = 0 then
	openwithparm(w_pop_message, "Access Code Already In Use.  Access Code Not Changed")
	return 0
end if

openwithparm(w_pop_message, "Access Code Changed")

return 1

end function

protected function str_attempt_logon xx_attempt_logon ();str_popup popup
str_popup_return popup_return
str_attempt_logon lstr_attempt_logon
string ls_user_id


popup.item = "LOGON"
popup.title = "Enter Access Code"
openwithparm(w_security_access_code, popup)
popup_return = message.powerobjectparm
if popup_return.item_count < 2 then
	setnull(lstr_attempt_logon.user_id)
else
	SELECT	user_id
	INTO	:ls_user_id
	FROM c_User (nolock)
	WHERE access_id = :popup_return.items[1];
	if not tf_check() then setnull(ls_user_id)
	if sqlca.sqlcode = 100 then setnull(ls_user_id)
	
	
	lstr_attempt_logon.user_id = ls_user_id
	lstr_attempt_logon.sticky_logon = f_string_to_boolean(popup_return.items[2])
end if

return lstr_attempt_logon


end function

public function integer change_access_code (string ps_user_id);integer li_sts
string ls_username
string ls_null

setnull(ls_null)

// li_sts = xx_change_access_code(ps_user_id)

ls_username = user_username(ps_user_id)
li_sts = x_changepassword(ls_username)

if li_sts > 0 then
	f_log_security_event("Change Password", "Success", ls_null)
else
	f_log_security_event("Change Password", "Failure", ls_null)
end if

return li_sts

end function

public function u_user attempt_logon ();str_attempt_logon lstr_attempt_logon
u_user luo_null
setnull(luo_null)
string ls_username

//lstr_attempt_logon = xx_attempt_logon()
//if isnull(lstr_attempt_logon.user_id) then return luo_null

ls_username = x_Authenticate()
if len(ls_username) > 0 then
	lstr_attempt_logon.user_id = find_username(ls_username)
	lstr_attempt_logon.sticky_logon = false
	return user_logon(lstr_attempt_logon)
else
	return luo_null
end if

return user_logon(lstr_attempt_logon)

end function

public function u_user user_logon (str_attempt_logon pstr_user);string ls_null
long ll_computer_id
boolean lb_found
u_user luo_user, luo_null
str_popup_return popup_return
integer li_rows
string ls_temp
string ls_other_computer
u_ds_data luo_data
long ll_row
integer li_sts
string ls_find
long i
string ls_user_status
long ll_count
boolean lb_disable_backup_check
date ld_yesterday
datetime ldt_backup_date
boolean lb_allow_multiple_logons
str_security_alert lstr_security_alert
string ls_override

ld_yesterday = relativedate(today(), -1)

setnull(ls_null)
setnull(ll_computer_id)
setnull(luo_user)
setnull(luo_null)
lb_found = false

// Refresh
load_users()

if isnull(pstr_user.user_id) then
	log.log(this, "user_logon()", "Null user_id", 3)
end if

luo_user = find_user(pstr_user.user_id)

if isnull(luo_user) then
	log.log(this, "user_logon()", "Invalid user_id (" + pstr_user.user_id + ")", 3)
	return luo_user
end if

SELECT user_status
INTO :ls_user_status
FROM c_User
WHERE user_id = :pstr_user.user_id;
if not tf_check() then return luo_null

if ls_user_status = "OK" then
	log.log(this, "user_logon()", "User logging on (" + luo_user.user_full_name + ")", 2)
elseif ls_user_status = "NA" then
	log.log(this, "user_logon()", "Inactive user attempting to log in (" + luo_user.user_full_name + ")", 3)
	return luo_null
elseif ls_user_status = "SYSTEM" then
	log.log(this, "user_logon()", "System User logging on (" + luo_user.user_full_name + ")", 2)
else
	log.log(this, "user_logon()", "User attempting to log in with improper status (" + luo_user.user_full_name + ", " + ls_user_status + ")", 3)
	return luo_null
end if

// Set the sticky_logon
luo_user.sticky_logon = pstr_user.sticky_logon

ll_count = o_users.retrieve(luo_user.user_id)
if ll_count < 0 then return luo_null

// If this user isn't logged in yet then add them and we're done
if ll_count > 0 then
	// See if this user is logged in at this computer already.  If so then we're done
	ls_find = "computer_id=" + string(computer_id)
	ll_row = o_users.find(ls_find, 1, ll_count)
	if ll_row > 0 then return luo_user
	
	// If we get here then this user is logged in somewhere but not at this computer
	// If it's not a system user, then see if it's OK to log the user in here as well
	if (left(luo_user.user_id, 1) <> "!") and (left(luo_user.user_id, 1) <> "#") then
		// Get the first other computer that the user is logged in at
		ll_computer_id = o_users.object.computer_id[1]
		
		ls_other_computer = f_computer_description(ll_computer_id)
		
		log.log(this, "user_logon()", luo_user.user_full_name + " is already logged in at " &
							+ ls_other_computer, 2)

		if cpr_mode = "CLIENT" then
			lb_allow_multiple_logons = datalist.get_preference_boolean("SECURITY", "Allow Multiple Logons", true)
		
			if lb_allow_multiple_logons then
				// If multiple logons are allowed, then just warn the user and continue the logon
				lstr_security_alert.alert_title = "Security Warning"
				lstr_security_alert.alert_message = luo_user.user_full_name + " is already logged in at " + ls_other_computer
				lstr_security_alert.allow_override = false
				openwithparm(w_security_alert, lstr_security_alert)
			else
				// If multiple logons are not allowed, then first determine of other logon is actively in a chart
				ls_find = "in_service='Y'"
				ll_row = o_users.find(ls_find, 1, ll_count)
				if ll_row > 0 then
					ll_computer_id = o_users.object.computer_id[1]
					ls_other_computer = f_computer_description(ll_computer_id)
					lstr_security_alert.alert_title = "Security Alert"
					lstr_security_alert.alert_message = luo_user.user_full_name + " is already logged in at " + ls_other_computer + " and is currently in a patient chart or other active service.  User must log out of that session before logging in elsewhere."
					lstr_security_alert.allow_override = false
					openwithparm(w_security_alert, lstr_security_alert)
					return luo_null
				else
					lstr_security_alert.alert_title = "Security Alert"
					lstr_security_alert.alert_message = luo_user.user_full_name + " is already logged in at " + ls_other_computer + " and is currently in a patient chart or other active service.  User should log out of that session before logging in elsewhere.  Click ~"Override~" to continue logging on here."
					lstr_security_alert.allow_override = true
					openwithparm(w_security_alert, lstr_security_alert)
					ls_override = message.stringparm
					if upper(ls_override) <> "OVERRIDE" then
						return luo_null
					end if
					// Log out other sessions
					for i = 1 to o_users.rowcount()
						ll_computer_id = o_users.object.computer_id[i]
						sqlca.sp_user_logoff(luo_user.user_id, ll_computer_id)
						if not tf_check() then return luo_null
					next
				end if
			end if
		end if
	end if
end if

// If we get here then we need to add the user at this computer
ll_row = o_users.insertrow(0)
o_users.object.user_id[ll_row] = luo_user.user_id
o_users.object.computer_id[ll_row] = computer_id
o_users.object.office_id[ll_row] = office_id
o_users.object.in_service[ll_row] = "N"

li_sts = o_users.update()
if li_sts < 0 then return luo_null

// Issue a backup warning
lb_disable_backup_check = f_string_to_boolean(datalist.get_preference("SYSTEM","disable_backup_check"))
if not lb_disable_backup_check and (sqlca.is_dbmode("Production") OR sqlca.is_dbmode("Beta")) then
	SELECT max(backup_finish_date)
	INTO :ldt_backup_date
	FROM msdb..backupset
	WHERE database_name = :sqlca.database;
	if (not tf_check()) or isnull(ldt_backup_date) or (date(ldt_backup_date) < ld_yesterday) then
		openwithparm(w_pop_message, "A recent EncounterPRO database backup could not be found.  Please contact your System Administrator to get this resolved as soon as possible!")
	end if
end if


return luo_user


end function

public function integer users_in_role (string ps_role_id, ref str_user pstra_users[]);string ls_find_role
string ls_find_user
long ll_role_row
long ll_user_row
long ll_user_roles
string ls_user_id
integer li_user_count
integer li_sts
str_user lstr_user

li_user_count = 0
ll_user_roles = user_roles.rowcount()

if isnull(ps_role_id) then
	ls_find_role = "1=1"
else
	ls_find_role = "role_id='" + ps_role_id + "'"
end if
ll_role_row = user_roles.find(ls_find_role, 1, ll_user_roles)
DO WHILE ll_role_row > 0 and ll_role_row <= ll_user_roles
	ls_user_id = user_roles.object.user_id[ll_role_row]
	if is_active_user(ls_user_id) then
		li_sts = get_user(ls_user_id, lstr_user)
		if li_sts > 0 then
			li_user_count += 1
			pstra_users[li_user_count] = lstr_user
		end if
	end if

	ll_role_row = user_roles.find(ls_find_role, ll_role_row + 1, ll_user_roles + 1)
LOOP

return li_user_count

end function

public function any user_property (string ps_user_id, string ps_property);string ls_null
long ll_row
any la_property
integer li_column_id
string ls_first_name
string ls_last_name
string ls_middle_name
string ls_name_suffix
string ls_name_prefix
string ls_degree
blob lbl_signature_stamp
u_user luo_user

setnull(ls_null)

la_property = ls_null

ll_row = find_user_row(ps_user_id)
if ll_row <= 0 or isnull(ll_row) then
	// see if we can find a user object
	luo_user = find_user(ps_user_id)
	if isnull(luo_user) then
		la_property = ls_null
	else
		CHOOSE CASE lower(trim(ps_property))
			CASE "user_id"
				la_property = luo_user.user_id
			CASE "user_status"
				la_property = luo_user.user_status
			CASE "user_full_name"
				la_property = luo_user.user_full_name
			CASE "user_short_name"
				la_property = luo_user.user_short_name
			CASE "color"
				la_property = string(luo_user.color)
			CASE "actor_class"
				la_property = luo_user.actor_class
		END CHOOSE
	end if
else
	CHOOSE CASE lower(trim(ps_property))
		CASE "access_id"
			la_property = ls_null
		CASE "pretty_name"
			ls_first_name = users.object.first_name[ll_row]
			ls_last_name = users.object.last_name[ll_row]
			ls_middle_name = users.object.middle_name[ll_row]
			ls_name_suffix = users.object.name_suffix[ll_row]
			ls_name_prefix = users.object.name_prefix[ll_row]
			ls_degree = users.object.degree[ll_row]
			la_property = f_pretty_name(ls_last_name, ls_first_name, ls_middle_name, ls_name_suffix, ls_name_prefix, ls_degree)
		CASE "pretty_name_fml"
			ls_first_name = users.object.first_name[ll_row]
			ls_last_name = users.object.last_name[ll_row]
			ls_middle_name = users.object.middle_name[ll_row]
			ls_name_suffix = users.object.name_suffix[ll_row]
			ls_name_prefix = users.object.name_prefix[ll_row]
			ls_degree = users.object.degree[ll_row]
			la_property = f_pretty_name_fml(ls_last_name, ls_first_name, ls_middle_name, ls_name_suffix, ls_name_prefix, ls_degree)
		CASE "supervisor"
			la_property = users.object.supervisor_user_id[ll_row]
		CASE "signature_stamp"
			SELECTBLOB signature_stamp
			INTO :lbl_signature_stamp
			FROM c_User
			WHERE user_id = :ps_user_id;
			if not tf_check() then
				setnull(lbl_signature_stamp)
			elseif sqlca.sqlcode = 100 then
				setnull(lbl_signature_stamp)
			end if
			la_property = lbl_signature_stamp
		CASE ELSE
			li_column_id = users.column_id(ps_property)
			
			if li_column_id > 0 then
				la_property = users.object.data[ll_row, li_column_id]
			end if
	END CHOOSE
end if

return la_property

end function

public function string user_signature_stamp (string ps_user_id);string ls_null
long ll_row
string ls_file
blob lbl_signature_stamp
integer li_sts

setnull(ls_null)

ll_row = find_user_row(ps_user_id)
if ll_row <= 0 then return ls_null

SELECTBLOB signature_stamp
INTO :lbl_signature_stamp
FROM c_User
WHERE user_id = :ps_user_id;
if not tf_check() then return ls_null
if sqlca.sqlcode = 100 then return ls_null
if isnull(lbl_signature_stamp) then return ls_null

// Assume signature_stamp is a bitmap
ls_file = f_temp_file("bmp")
li_sts = log.file_write(lbl_signature_stamp, ls_file)
if li_sts <= 0 then return ls_null

return ls_file

end function

public function boolean is_active_user (string ps_user_id);long ll_user_row
string ls_user_status

ll_user_row = find_user_row(ps_user_id)
if isnull(ll_user_row) then return false

ls_user_status = users.object.user_status[ll_user_row]

if upper(ls_user_status) = "OK" then return true

return false


end function

public function boolean check_access (string ps_user_id, str_access_control_list pstr_access_control_list);long ll_row
string ls_find
string ls_access_flag
string ls_secure_flag
str_role lstra_roles[]
integer li_role_count
integer i, r
long ll_rowcount
boolean lb_grant


// See if user is a superuser
if is_superuser(ps_user_id) then return true

// Reload the user data if anything's changed
load_users()

// First, scan the list for a user-specific record
for i = 1 to pstr_access_control_list.access_count
	if lower(ps_user_id) = lower(pstr_access_control_list.access_list[i].user_id) then
		return pstr_access_control_list.access_list[i].grant_access
	end if
next

// If we didn't find a user-specific record, then search for role records
li_role_count = roles_assigned_to_user(ps_user_id, lstra_roles)

// Then look for a role record for each role this user is in
lb_grant = false
for r = 1 to li_role_count
	for i = 1 to pstr_access_control_list.access_count
		if lower(lstra_roles[r].role_id) = lower(pstr_access_control_list.access_list[i].user_id) then
			lb_grant = pstr_access_control_list.access_list[i].grant_access
			// A revoke record trumps a grant, so if we find a revoke then just return
			if not lb_grant then return false
		end if
	next
next

if lb_grant then return true

return pstr_access_control_list.default_grant


end function

public subroutine clear_cache ();
setnull(users_refresh)
setnull(roles_refresh)
setnull(user_roles_refresh)
setnull(user_privileges_refresh)
setnull(user_services_refresh)
setnull(c_Privilege_refresh)
setnull(o_users_refresh)

end subroutine

public function string user_username (string ps_user_id);long ll_user_row
string ls_null

setnull(ls_null)

ll_user_row = find_user_row(ps_user_id)
if isnull(ll_user_row) then return ls_null

return users.object.username[ll_user_row]


end function

private function string find_username (string ps_username);u_user luo_user
string ls_find
long ll_row
string ls_user_id

setnull(ls_user_id)

SELECT min(user_id)
INTO :ls_user_id
FROM c_User
WHERE username = :ps_username;
if not tf_check() then return ls_user_id

return ls_user_id

end function

public function string establishcredentials (string ps_user_id);string ls_new_username

ls_new_username = x_establishcredentials(ps_user_id)
if len(ls_new_username) > 0 then
	f_log_security_event("Establish Credentials", "Success", ps_user_id)
else
	f_log_security_event("Establish Credentials", "Failure", ps_user_id)
end if

refresh_user(ps_user_id)

return ls_new_username


end function

public function integer resetpassword (string ps_reset_user_id);string ls_reset_username
integer li_sts

ls_reset_username = user_username(ps_reset_user_id)
if isnull(ls_reset_username) or ls_reset_username = "" then
	if cpr_mode = "CLIENT" then
		openwithparm(w_pop_message, "You must establish a username before you can reset the password")
	end if
	return 0
end if

li_sts = x_resetpassword(current_user.username, ls_reset_username)

if li_sts > 0 then
	f_log_security_event("Reset Password", "Success", ps_reset_user_id)
else
	f_log_security_event("Reset Password", "Failure", ps_reset_user_id)
end if

refresh_user(ps_reset_user_id)

return li_sts

end function

public function integer initialize ();integer li_sts
string ls_challenge
string ls_response
string ls_challenge_enc

li_sts = xx_initialize()
if li_sts < 0 then return li_sts

// Construct a challenge string
ls_challenge = string(datetime(today(), now()))

ls_challenge_enc = encrypt_challenge(ls_challenge)
ls_response = x_challenge(ls_challenge_enc)

// *******************************************************************
// When we activate the challenge-response system, delete the next line
ls_response = ls_challenge

// If the security system successfully decrypted the challenge string,
// then it must really be the security system
if ls_response = ls_challenge then return 1

log.log(this, "initialize()", "Security System failed to provide a valid challenge response", 4)

return -1

end function

public function string encrypt_challenge (string ps_challenge);

return ps_challenge

end function

public function boolean is_user_authorized (string ps_user_id, string ps_service, string ps_context_object);// This method checks to see if the user is authorized to perform
// the specified service.

boolean lb_user_clinical_access_flag
string ls_find
long ll_row
long ll_rowcount
integer li_role_count
long i
str_role lstra_roles[]

// If the user is the admin user then return true
if lower(ps_user_id) = lower(admin_user_id) then return true

// If the user isn't authorized for the service, then don't bother checking
// for clinical access
if not is_user_service(ps_user_id, ps_service) then return false

// If the service is in the general context, then we don't need to check for
// clinical access
if lower(ps_context_object) = "general" then return true

lb_user_clinical_access_flag = user_clinical_access_flag(ps_user_id)
if lb_user_clinical_access_flag then return true


// If the user_clinical_access_flag is turned off then the user still
// has one chance to be granted access to this service, and that is if
// there is a specific Grant record for them or their role
ll_rowcount = user_services.rowcount()

// Then check for specific service access
ls_find = "lower(user_id)='" + lower(ps_user_id) + "' and lower(service)='" + lower(ps_service) + "'"
ls_find += " and access_flag='G'"
ll_row = user_services.find(ls_find, 1, ll_rowcount)
if ll_row > 0 then return true

// If we didn't find a user-specific record, then search for role records
li_role_count = roles_assigned_to_user(ps_user_id, lstra_roles)

// Then look for a Grant record
for i = 1 to li_role_count
	ls_find = "lower(user_id)='" + lower(lstra_roles[i].role_id) + "'"
	ls_find += " and lower(service)='" + lower(ps_service) + "'"
	ls_find += " and access_flag='G'"
	ll_row = user_services.find(ls_find, 1, ll_rowcount)
	if ll_row > 0 then return true
next

return false



end function

public function string new_user (string ps_actor_class);string ls_user_id
string ls_same_name_user_id
string ls_same_name_user_name
str_actor_name lstr_actor_name
string ls_null
long ll_iterations
long ll_nextkey
long ll_count
string ls_user_status
string ls_full_name
string ls_short_name
datetime ldt_created
str_popup popup
str_popup_return popup_return 
string ls_actor_type
string ls_i
string ls_office_id

setnull(ls_null)
setnull(lstr_actor_name.last_name)
setnull(lstr_actor_name.first_name)
setnull(lstr_actor_name.middle_name)
setnull(lstr_actor_name.name_prefix)
setnull(lstr_actor_name.name_suffix)
setnull(lstr_actor_name.degree)

if isnull(ps_actor_class) or trim(ps_actor_class) = "" then
	ps_actor_class = "User"
end if

if lower(ps_actor_class) = "role" then
	setnull(popup.item)
	openwithparm(w_role_definition, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return ls_null
	ls_user_id = popup_return.items[1]
	return ls_user_id
end if

popup.dataobject = "dw_actor_type_pick"
popup.auto_singleton = true
popup.argument_count = 1
popup.argument[1] = ps_actor_class
popup.datacolumn = 1
popup.displaycolumn = 1
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return ls_null

ls_actor_type = popup_return.items[1]

CHOOSE CASE lower(ls_actor_type)
	CASE "organization", "information system"
// title					Screen title/user instructions
// item					Default string value
//	data_row_count		Number of items in the canned selections list
// items[]				list of canned selections
// argument_count		Number of top_20 arguments supplied
// argument[]			List of top_20 arguments
//							argument[1] = specific top_20_code
//							argument[2] = generic top_20_code
// multiselect			True = Allow empty string
//							False = Don't allow empty string
// displaycolumn		Max Length
		popup.title = "New " + wordcap(ps_actor_class) + " Name"
		popup.displaycolumn = 64
		popup.multiselect = false
		popup.argument_count = 0
		openwithparm(w_pop_prompt_string, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return ls_null
		ls_full_name = popup_return.items[1]
		setnull(ls_short_name)
	CASE ELSE
		// Assume person
		lstr_actor_name.actor_class = ps_actor_class
		lstr_actor_name.edit_screen_title = "New " + wordcap(ps_actor_class) + " Name"
		openwithparm(w_user_name_edit, lstr_actor_name)
		lstr_actor_name = message.powerobjectparm
		
		if not lstr_actor_name.changed then return ls_null
		
		if isnull(lstr_actor_name.last_name) or len(lstr_actor_name.last_name) = 0 then
			openwithparm(w_pop_message, "You must supply a surname for a new user")
			return ls_null
		end if

		SELECT max(user_id)
		INTO :ls_same_name_user_id
		FROM c_User
		WHERE last_name = :lstr_actor_name.last_name
		AND first_name = :lstr_actor_name.first_name
		AND ISNULL(middle_name, '!NULL') = ISNULL(:lstr_actor_name.middle_name, '!NULL');
		if not tf_check() then return ls_null
		if sqlca.sqlnrows = 1 and len(ls_same_name_user_id) > 0 then
			ls_same_name_user_name = user_list.user_full_name(ls_same_name_user_id)
			openwithparm(w_pop_yes_no, "A user with than name already exists (" + ls_same_name_user_name + ").  Are you sure you want to create this user?")
			popup_return = message.powerobjectparm
			if popup_return.item <> "YES" then return ls_null
		end if			

		ls_full_name = f_pretty_name_fml(lstr_actor_name.last_name, &
													lstr_actor_name.first_name, &
													lstr_actor_name.middle_name, &
													lstr_actor_name.name_suffix, &
													lstr_actor_name.name_prefix, &
													lstr_actor_name.degree)
		if len(lstr_actor_name.name_prefix) > 0 then
			ls_short_name = lstr_actor_name.name_prefix + " " + lstr_actor_name.last_name
		elseif len(lstr_actor_name.first_name) > 0 then
			ls_short_name = left(lstr_actor_name.first_name, 1) + " " + lstr_actor_name.last_name
		else
			ls_short_name = lstr_actor_name.last_name
		end if

END CHOOSE

// Generate a unique user_id
ll_iterations = 0
DO WHILE true
	ll_iterations += 1
	if ll_iterations = 1000 then return ls_null
	
	sqlca.sp_get_next_key("!CPR", "USER_ID", ll_nextkey)
	if not tf_check() then return ls_null

	ls_user_id = string(sqlca.customer_id) + "^" + string(ll_nextkey)
	
	SELECT count(*)
	INTO :ll_count
	FROM c_User
	WHERE user_id = :ls_user_id;
	if not tf_check() then return ls_null
	
	IF ll_count = 0 then exit
LOOP

// Generate a unique user_short_name
ll_iterations = 1
DO WHILE true
	ll_iterations += 1
	if ll_iterations = 1000 then return ls_null
	
	SELECT count(*)
	INTO :ll_count
	FROM c_User
	WHERE user_short_name = :ls_short_name;
	if not tf_check() then return ls_null
	
	IF ll_count = 0 then exit

	ls_i = string(ll_iterations)
	ls_short_name = left(lstr_actor_name.first_name, 1) + " " + lstr_actor_name.last_name
	ls_short_name = trim(left(ls_short_name, 12 - len(ls_i))) + ls_i
LOOP

// If this is an office then generate a unique office_id
if lower(ps_actor_class) = "office" then
	ll_iterations = 0
	DO WHILE true
		ll_iterations += 1
		if ll_iterations = 1000 then return ls_null

		ls_office_id = right("000" + string(ll_iterations), 4)

		SELECT count(*)
		INTO :ll_count
		FROM c_User
		WHERE office_id = :ls_office_id
		AND actor_class = 'Office';
		if not tf_check() then return ls_null
		
		IF ll_count = 0 then exit
	
		ls_i = string(ll_iterations)
		ls_short_name = left(lstr_actor_name.first_name, 1) + " " + lstr_actor_name.last_name
		ls_short_name = trim(left(ls_short_name, 12 - len(ls_i))) + ls_i
	LOOP
else
	setnull(ls_office_id)
end if

if lower(ps_actor_class) = "user" then
	ls_user_status = "OK"
else
	ls_user_status = "Actor"
end if

ls_full_name = left(ls_full_name, 64)
if len(ls_short_name) > 12 then
	ls_short_name = left(ls_short_name, 12)
end if
ldt_created = datetime(today(), now())

INSERT INTO c_User (
	user_id,
	user_status,
	actor_class,
	actor_type,
	status,
	office_id,
	user_full_name,
	user_short_name,
	last_name,
	first_name,
	middle_name,
	name_prefix,
	name_suffix,
	degree,
	created,
	created_by)
VALUES (
	:ls_user_id,
	:ls_user_status,
	:ps_actor_class,
	:ls_actor_type,
	'OK',
	:ls_office_id,
	:ls_full_name,
	:ls_short_name,
	:lstr_actor_name.last_name,
	:lstr_actor_name.first_name,
	:lstr_actor_name.middle_name,
	:lstr_actor_name.name_prefix,
	:lstr_actor_name.name_suffix,
	:lstr_actor_name.degree,
	:ldt_created,
	:current_scribe.user_id);
if not tf_check() then return ls_null

popup.data_row_count = 1
popup.items[1] = ls_user_id
openwithparm(w_user_definition, popup)

return ls_user_id

end function

public function boolean user_certified (string ps_user_id);long ll_user_row
string ls_certified

ls_certified = "N"

if is_user(ps_user_id) then
	ll_user_row = find_user_row(ps_user_id)
	if isnull(ll_user_row) then return false
	
	ls_certified = users.object.certified[ll_user_row]
end if

return f_string_to_boolean(ls_certified)


end function

public function boolean user_clinical_access_flag (string ps_user_id);long ll_user_row

ll_user_row = find_user_row(ps_user_id)
if isnull(ll_user_row) then return false

return f_string_to_boolean(string(users.object.clinical_access_flag[ll_user_row]))


end function

public function string authenticate ();string ls_username
string ls_user_id
string ls_null

setnull(ls_null)

ls_username = x_Authenticate()
if isnull(ls_username) then
	return ls_null
end if

ls_user_id = find_username(ls_username)
if isnull(ls_user_id) then
	return ls_null
end if

return ls_user_id

end function

public function integer close_session ();


return 0


end function

public function integer configure_security ();integer li_sts
string ls_null

setnull(ls_null)

li_sts = x_configure_security()

if li_sts > 0 then
	f_log_security_event("Configure Security", "Success", ls_null)
else
	f_log_security_event("Configure Security", "Failure", ls_null)
end if

return li_sts

end function

public function integer check_username (string ps_username);return x_check_username(ps_username)

end function

protected function integer x_check_username (string ps_username);return 0

end function

protected function string x_authenticate ();return ""

end function

protected function string x_challenge (string ps_challenge);

return ""

end function

protected function integer x_changepassword (string ps_username);return 0

end function

protected function integer x_configure_security ();return 1

end function

protected function string x_establishcredentials (string ps_userid);return ""

end function

protected function integer x_reauthenticate (string ps_username);
return 0

end function

protected function integer x_resetpassword (string ps_adminusername, string ps_resetusername);return 0

end function

public subroutine refresh_user (string ps_user_id);long ll_user_row

if is_user(ps_user_id) then
	ll_user_row = find_user_row(ps_user_id)
	if isnull(ll_user_row) then return
	
	users.reselectrow(ll_user_row)
end if

return



end subroutine

public function integer set_user_progress (string ps_user_id, string ps_progress_type, string ps_progress_key, string ps_progress);datetime ldt_now

ldt_now = datetime(today(), now())

sqlca.sp_set_user_progress( ps_user_id, &
									current_user.user_id, &
									ldt_now, &
									ps_progress_type, &
									ps_progress_key, &
									ps_progress, &
									current_scribe.user_id)
if not tf_check() then return -1

refresh_user(ps_user_id)

return 1

end function

public function string is_user_service_grant (string ps_user_id, string ps_service);long ll_row
string ls_find
string ls_access_flag
string ls_secure_flag
str_role lstra_roles[]
integer li_role_count
integer i
long ll_rowcount

// This routine determines whether the user has a specific grant record for themselves or for a role they are in

// Reload the user data if anything's changed
load_users()

ll_rowcount = user_services.rowcount()

// Then check for specific service access
ls_find = "lower(user_id)='" + lower(ps_user_id) + "' and lower(service)='" + lower(ps_service) + "'"
ll_row = user_services.find(ls_find, 1, ll_rowcount)
if ll_row > 0 then
	// If we found a user specific record, then that's what governs this user
	ls_access_flag = user_services.object.access_flag[ll_row]
	if ls_access_flag = "G" then
		return "G"
	else
		return "R"
	end if
else
	// If we didn't find a user-specific record, then search for role records
	li_role_count = roles_assigned_to_user(ps_user_id, lstra_roles)
	
	// First look for a Revoke record
	for i = 1 to li_role_count
		ls_find = "lower(user_id)='" + lower(lstra_roles[i].role_id) + "'"
		ls_find += " and lower(service)='" + lower(ps_service) + "'"
		ls_find += " and access_flag='R'"
		ll_row = user_services.find(ls_find, 1, ll_rowcount)
		if ll_row > 0 then return "R"
	next

	// Then look for a Grant record
	for i = 1 to li_role_count
		ls_find = "lower(user_id)='" + lower(lstra_roles[i].role_id) + "'"
		ls_find += " and lower(service)='" + lower(ps_service) + "'"
		ls_find += " and access_flag='G'"
		ll_row = user_services.find(ls_find, 1, ll_rowcount)
		if ll_row > 0 then return "G"
	next
end if

// If we get here then we didn't find a grant or a revoke
return "NA"


end function

public function u_user set_admin_user (string ps_admin_user_id);long ll_count
u_user luo_user


// This method will populate a u_user object without being dependent on any new fields
// in the c_User table

luo_user = CREATE u_user

SELECT count(*)
INTO :ll_count
FROM sysobjects
WHERE name = 'c_User'
AND type = 'U';
if ll_count = 1 then
	SELECT	user_id ,
				specialty_id ,
				user_status ,
				actor_class ,
				user_full_name ,
				user_short_name ,
				color ,
				user_initial ,
				first_name ,
				middle_name ,
				last_name ,
				degree ,
				name_prefix ,
				name_suffix ,
				activate_date ,
				modified ,
				modified_by ,
				created ,
				created_by ,
				license_flag ,
				email_address 
	INTO		:luo_user.user_id ,
				:luo_user.specialty_id ,
				:luo_user.user_status ,
				:luo_user.actor_class ,
				:luo_user.user_full_name ,
				:luo_user.user_short_name ,
				:luo_user.color ,
				:luo_user.user_initial ,
				:luo_user.first_name ,
				:luo_user.middle_name ,
				:luo_user.last_name ,
				:luo_user.degree ,
				:luo_user.name_prefix ,
				:luo_user.name_suffix ,
				:luo_user.activate_date ,
				:luo_user.modified ,
				:luo_user.modified_by ,
				:luo_user.created ,
				:luo_user.created_by ,
				:luo_user.license_flag ,
				:luo_user.email_address 
	FROM c_User
	WHERE user_id = :ps_admin_user_id;
	if not tf_check() then
		setnull(luo_user)
		return luo_user
	end if
else
	luo_user.user_id = ps_admin_user_id
	luo_user.specialty_id = "$"
	luo_user.user_status = "OK"
	luo_user.user_full_name = ps_admin_user_id
	luo_user.user_short_name = left(ps_admin_user_id, 12)
	luo_user.color = rgb(192,192,192)
end if

setnull(luo_user.primary_office_id)
setnull(luo_user.dea_number)
setnull(luo_user.license_number)
setnull(luo_user.npi)
setnull(luo_user.supervisor_user_id)
setnull(luo_user.certified)
setnull(luo_user.billing_id)
setnull(luo_user.billing_code)
setnull(luo_user.activate_date)
setnull(luo_user.supervisor)

luo_user.sticky_logon = true

// If this is a system user then remember the admin_user_id so we don't have to look it up later
if lower(luo_user.actor_class) = "system" then
	admin_user_id = ps_admin_user_id
else
	setnull(admin_user_id)
end if

return luo_user

end function

public function boolean is_actor_class (string ps_user_id, string ps_actor_class);long ll_user_row
string ls_actor_class

ll_user_row = find_user_row(ps_user_id)
if isnull(ll_user_row) then return false

ls_actor_class = users.object.actor_class[ll_user_row]

if upper(ls_actor_class) = upper(ps_actor_class) then return true

return false


end function

public function integer update_user_old (u_user puo_user);/////////////////////////////////////////////////////////////////////////////////
//
//	Function: add_user
//
// Arguments: 
//
//	Return: Integer
//
//	Description: adds each user into u_user[].
//
// Created On:																Created On:
//
// Modified By:Sumathi Chinnasamy									Modified On:08/24/99
/////////////////////////////////////////////////////////////////////////////////
//long ll_row
//integer li_sts
//long i
//
//if isnull(puo_user) then return 0
//
//if isnull(puo_user.user_id) then
//	// If the user_id is null then assume a new user
//	puo_user.user_id = gen_unique_key(puo_user)
//	ll_row = users.insertrow(0)
//	users.object.user_id[ll_row] = puo_user.user_id
//else
//	ll_row = find_user_row(puo_user.user_id)
//	if ll_row <= 0 then
//		log.log(this, "update_user()", "User not found (" + puo_user.user_id + ")", 4)
//		return -1
//	end if
//end if
//
//
//users.object.office_id[ll_row] = puo_user.primary_office_id
//users.object.first_name[ll_row] = puo_user.first_name
//users.object.middle_name[ll_row] = puo_user.middle_name
//users.object.last_name[ll_row] = puo_user.last_name
//users.object.degree[ll_row] = puo_user.degree
//users.object.name_prefix[ll_row] = puo_user.name_prefix
//users.object.name_suffix[ll_row] = puo_user.name_suffix
//users.object.dea_number[ll_row] = puo_user.dea_number
//users.object.license_number[ll_row] = puo_user.license_number
//users.object.certification_number[ll_row] = puo_user.certification_number
//users.object.certified[ll_row] = puo_user.certified
//users.object.npi[ll_row] = puo_user.npi
//users.object.upin[ll_row] = puo_user.upin
//// clinical_access_flag
//
//
//users.object.specialty_id[ll_row] = puo_user.specialty_id
//users.object.user_full_name[ll_row] = puo_user.user_full_name
//users.object.user_short_name[ll_row] = puo_user.user_short_name
//users.object.color[ll_row] = puo_user.color
//users.object.user_initial[ll_row] = puo_user.user_initial
//users.object.supervisor_user_id[ll_row] = puo_user.supervisor_user_id
//users.object.billing_id[ll_row] = puo_user.billing_id
//users.object.billing_code[ll_row] = puo_user.billing_code
//users.object.activate_date[ll_row] = puo_user.activate_date
//users.object.modified[ll_row] = puo_user.modified
//users.object.modified_by[ll_row] = puo_user.modified_by
//users.object.created[ll_row] = puo_user.created
//users.object.created_by[ll_row] = puo_user.created_by
//users.object.license_flag[ll_row] = puo_user.license_flag
//users.object.email_address[ll_row] = puo_user.email_address
//users.object.actor_class[ll_row] = puo_user.actor_class
//users.object.actor_type[ll_row] = puo_user.actor_type
//users.object.organization_contact[ll_row] = puo_user.organization_contact
//users.object.organization_director[ll_row] = puo_user.organization_director
//users.object.title[ll_row] = puo_user.title
//users.object.information_system_type[ll_row] = puo_user.information_system_type
//users.object.information_system_version[ll_row] = puo_user.information_system_version
//
//
//
//li_sts = users.update()
//if li_sts < 0 then return -1
//
//for i = 1 to puo_user.address_count
//	if puo_user.address[i].updated then
//		sqlca.sp_new_actor_address( puo_user.address[i].actor_id, & 
//											puo_user.address[i].description, & 
//											puo_user.address[i].address_line_1, & 
//											puo_user.address[i].address_line_2, & 
//											puo_user.address[i].city, & 
//											puo_user.address[i].state, & 
//											puo_user.address[i].zip, & 
//											puo_user.address[i].country, & 
//											current_scribe.user_id)
//		if not tf_check() then return -1
//		puo_user.address[i].updated = false
//	end if
//next
//
//for i = 1 to puo_user.communication_count
//	if puo_user.communication[i].updated then
//		sqlca.sp_new_actor_communication( puo_user.communication[i].actor_id, & 
//													puo_user.communication[i].communication_type, & 
//													puo_user.communication[i].communication_value, & 
//													puo_user.communication[i].note, & 
//													current_scribe.user_id, & 
//													puo_user.communication[i].communication_name)
//		if not tf_check() then return -1
//		puo_user.communication[i].updated = false
//	end if
//next
//
RETURN 1

end function

public function boolean user_may_take_over_encounter (string ps_user_id, string ps_encounter_owner_user_id);string ls_user_license_flag
string ls_encounter_owner_license_flag


// If th encounter is owned by a role then the user may take it over
if is_role(ps_encounter_owner_user_id) then return true

// If the user has the right privilege they may take over the encounter
if is_user_privileged(ps_user_id, "Take Over Encounter") then return true

ls_user_license_flag = user_property(ps_user_id, "license_flag")
ls_encounter_owner_license_flag = user_property(ps_encounter_owner_user_id, "license_flag")

CHOOSE CASE upper(ls_user_license_flag)
	CASE "P"
		CHOOSE CASE upper(ls_encounter_owner_license_flag)
			CASE "P"
				return true
			CASE "E"
				return true
			CASE ELSE
				return true
		END CHOOSE
	CASE "E"
		CHOOSE CASE upper(ls_encounter_owner_license_flag)
			CASE "P"
				return false
			CASE "E"
				return true
			CASE ELSE
				return true
		END CHOOSE
	CASE ELSE
		CHOOSE CASE upper(ls_encounter_owner_license_flag)
			CASE "P"
				return false
			CASE "E"
				return false
			CASE ELSE
				return true
		END CHOOSE
END CHOOSE


return false

end function

public function boolean is_user_privileged (string ps_user_id, string ps_privilege_id, boolean pb_include_superusers);long ll_row
string ls_find
string ls_access_flag
string ls_secure_flag


// Superusers have all privileges except "Clinical Data Access"
if lower(ps_privilege_id) <> "clinical data access" and is_superuser(ps_user_id) and pb_include_superusers then return true

ls_find = "user_id='" + ps_user_id + "' and privilege_id='" + ps_privilege_id + "'"
ll_row = user_privileges.find(ls_find, 1, user_privileges.rowcount())
if ll_row > 0 then
	ls_access_flag = user_privileges.object.access_flag[ll_row]
	if ls_access_flag = "G" then
		return true
	else
		return false
	end if
else
	ls_find = "privilege_id='" + ps_privilege_id + "'"
	ll_row = c_privilege.find(ls_find, 1, c_privilege.rowcount())
	if ll_row > 0 then
		ls_secure_flag = c_privilege.object.secure_flag[ll_row]
		if ls_secure_flag = "Y" then
			// This service is secure so only allow user access if they had a "Grant" record
			return false
		else
			// This service is not secure so give the user access since they did not have a "Revoke" record
			return true
		end if
	else
		// Privilege record not found
		// This shouldn't happen but if it does return false
		return false
	end if
end if


return false

end function

public function integer set_scribe_context (string ps_user_id);u_user luo_user

luo_user = find_user(ps_user_id)
if isnull(luo_user) then
	log.log(this, "set_scribe_context()", "user not found (" + ps_user_id + ")", 4)
	return -1
end if

luo_user.sticky_logon = current_user.sticky_logon
luo_user.sticky_logon_prompt = current_user.sticky_logon_prompt

current_user = luo_user

return 1

end function

on u_component_security.create
call super::create
end on

on u_component_security.destroy
call super::destroy
end on

event constructor;call super::constructor;setnull(users_refresh)
setnull(roles_refresh)
setnull(user_roles_refresh)
setnull(user_privileges_refresh)
setnull(user_services_refresh)
setnull(c_Privilege_refresh)
setnull(o_users_refresh)
setnull(admin_user_id)

users = CREATE u_ds_data
user_search = CREATE u_ds_data
roles = CREATE u_ds_data
user_roles = CREATE u_ds_data
user_privileges = CREATE u_ds_data
user_services = CREATE u_ds_data
c_privilege = CREATE u_ds_data
o_users = CREATE u_ds_data

o_users.set_dataobject("dw_o_users")

user_search.set_dataobject("dw_data_user_list")

end event

