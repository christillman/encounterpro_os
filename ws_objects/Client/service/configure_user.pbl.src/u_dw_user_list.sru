$PBExportHeader$u_dw_user_list.sru
forward
global type u_dw_user_list from u_dw_pick_list
end type
end forward

global type u_dw_user_list from u_dw_pick_list
integer width = 1883
string dataobject = "dw_sp_user_search"
boolean border = false
event users_loaded ( string ps_description )
end type
global u_dw_user_list u_dw_user_list

type variables
// Search Criteria
string last_search_role_id
string last_search_zipcode
string last_search_name
string user_status = "OK"

// Filter set by container window
string specialty_id

string cpr_id

string top_20_user_id

// Role prefix modifies the role name
string role_prefix

// Behavior States
string mode = "EDIT"
boolean allow_editing

// Other states
string current_search = "SHORT LIST"
// Values = SHORT LIST, NAME, BYROLE, SPECIALTY, ROLE, CARETEAM, CON_SHORT LIST, CON_NAME, CON_SPECIALTY

string actor_class = "User"

// The actual top-20 code used will be different for each actor class
// for backward compatibility, the "User" actor class
// will use the top_20_code_base without any suffix
string top_20_code_base

string search_description

// Temp variable to hold the record currently being worked on
long top_20_sequence

str_pick_users pick_users

// Distance filter state
boolean use_distance_filter
long distance_filter_amount
string distance_filter_unit

u_ds_data care_team
long care_team_count

boolean disable_zipcode_filter = false

end variables

forward prototypes
public function integer remove_top_20 (long pl_row)
public function integer move_row (long pl_row)
public function integer sort_rows ()
public function integer search_name ()
public function integer retrieve_short_list (string ps_top_20_user_id)
public function integer search_by_role ()
public function integer search ()
public function integer search_by_role (string ps_role_id)
public subroutine user_menu (long pl_row)
public function integer initialize (str_pick_users pstr_pick_users)
public function integer retrieve_care_team ()
public function integer search_care_team ()
public subroutine set_actor_class (string ps_actor_class)
public function integer retrieve_by_name (string ps_name)
public function integer retrieve_by_role (string ps_role_id)
public function integer search_name (string ps_name)
public function integer search_short_list ()
public function integer search_short_list (boolean pb_personal_list)
public function string top_20_code ()
public subroutine load_care_team ()
public function integer retrieve_by_zip (string ps_zipcode)
public function integer search_by_zip ()
public function integer search_by_zip (string ps_zipcode)
end prototypes

public function integer remove_top_20 (long pl_row);integer li_sts

if current_search <> "SHORT LIST" then return 0

deleterow(pl_row)
li_sts = update()

return li_sts

end function

public function integer move_row (long pl_row);str_popup popup
string ls_user_id
long i
string ls_procedure_id
string ls_description
string ls_null
long ll_null
long ll_row
integer li_sts

setnull(ls_null)
setnull(ll_null)

if pl_row <= 0 then return 0

if current_search <> "SHORT LIST" then return 0

ll_row = get_selected_row()
if ll_row <= 0 then
	object.selected_flag[pl_row] = 1
end if

popup.objectparm = this

openwithparm(w_pick_list_sort, popup)

li_sts = update()

if ll_row <= 0 then
	clear_selected()
end if

return 1
end function

public function integer sort_rows ();integer li_sts
integer i

if current_search <> "SHORT LIST" then return 0

clear_selected()

setsort("user_full_name a")
sort()

for i = 1 to rowcount()
	object.sort_sequence[i] = i
next

li_sts = update()

setsort("sort_sequence a")

return 1

end function

public function integer search_name ();string ls_null
long ll_count
str_popup_return popup_return
integer li_sts

setnull(ls_null)

open(w_pop_get_string_abc)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

last_search_name = popup_return.items[1]
search_description = popup_return.descriptions[1]
	
current_search = "BY NAME"

li_sts = retrieve_by_name(last_search_name)
if li_sts < 0 then return -1

return li_sts


end function

public function integer retrieve_short_list (string ps_top_20_user_id);string ls_temp
long ll_count

setredraw(false)
if dataobject <> "dw_sp_user_top_20_search" then
	dataobject = "dw_sp_user_top_20_search"
	settransobject(sqlca)
	object.user_full_name.width = width - 260
end if

ll_count = retrieve(ps_top_20_user_id, top_20_code(), role_prefix)

last_page = 0
set_page(1, ls_temp)

setredraw(true)

this.event POST users_loaded(search_description)

return ll_count

end function

public function integer search_by_role ();str_popup popup
str_popup_return popup_return
integer li_sts
string ls_null

setnull(ls_null)

popup.dataobject = "dw_role_select_list"
popup.datacolumn = 1
popup.displaycolumn = 2
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

return search_by_role(popup_return.items[1])

end function

public function integer search ();integer li_sts
string ls_null

setnull(ls_null)


CHOOSE CASE current_search
	CASE "SHORT LIST"
		li_sts = retrieve_short_list(top_20_user_id)
	CASE "BY NAME"
		li_sts = retrieve_by_name(last_search_name)
	CASE "BY ROLE"
		li_sts = retrieve_by_role(last_search_role_id)
	CASE "BY ZIP"
		li_sts = retrieve_by_zip(last_search_zipcode)
	CASE "CARE TEAM"
		li_sts = retrieve_care_team()
END CHOOSE


return li_sts

end function

public function integer search_by_role (string ps_role_id);integer li_sts
string ls_null

setnull(ls_null)

last_search_role_id = ps_role_id
search_description = user_list.role_name(last_search_role_id) + " Role"

current_search = "BY ROLE"

li_sts = retrieve_by_role(last_search_role_id)
if li_sts < 0 then return -1

return 1


end function

public subroutine user_menu (long pl_row);str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons
string ls_user_id
integer li_update_flag
string ls_temp
string ls_description
string ls_null
long ll_null
string ls_user_status
boolean lb_active
integer li_count
string ls_license_flag
long ll_picked_computer_id
datetime ldt_null
boolean lb_care_team
boolean lb_primary
string ls_find
long ll_care_team_row
boolean lb_edit_common_short_list

setnull(ldt_null)
setnull(ls_null)
setnull(ll_null)

lb_active = false  // User is logged in at a different computer
lb_primary = false
lb_edit_common_short_list = current_user.check_privilege("Edit Common Short Lists") 

ls_description = object.user_full_name[pl_row]
ls_user_status = object.user_status[pl_row]

if dataobject = "dw_sp_user_top_20_search" then
	ls_user_id = object.search_user_id[pl_row]
else
	ls_user_id = object.user_id[pl_row]
end if

if allow_editing and left(ls_user_id, 1) <> "!" then
	SELECT count(*)
	INTO :li_count
	FROM o_Users
	WHERE user_id = :ls_user_id
	AND computer_id <> :gnv_app.computer_id;
	if not tf_check() then return
	if sqlca.sqlcode = 0 and li_count > 0 then
		lb_active = true
	end if
end if

lb_care_team = false
if len(cpr_id) > 0 then
	if care_team_count > 0 then
		ls_find = "user_id='" + ls_user_id + "'"
		ll_care_team_row = care_team.find(ls_find, 1, care_team_count)
		if ll_care_team_row > 0 then
			lb_care_team = true
			lb_primary = f_string_to_boolean(care_team.object.primary_actor_flag[ll_care_team_row])
		end if
	end if
end if

if current_search = "SHORT LIST" then
	if top_20_user_id = current_user.user_id OR lb_edit_common_short_list then
		if true then
			popup.button_count = popup.button_count + 1
			popup.button_icons[popup.button_count] = "button13.bmp"
			popup.button_helps[popup.button_count] = "Remove item from Short List"
			popup.button_titles[popup.button_count] = "Remove Short List"
			buttons[popup.button_count] = "REMOVE"
		end if
		
		if true then
			popup.button_count = popup.button_count + 1
			popup.button_icons[popup.button_count] = "buttonmove.bmp"
			popup.button_helps[popup.button_count] = "Move record up or down"
			popup.button_titles[popup.button_count] = "Move"
			buttons[popup.button_count] = "MOVE"
		end if
		
		if true then
			popup.button_count = popup.button_count + 1
			popup.button_icons[popup.button_count] = "buttonx3.bmp"
			popup.button_helps[popup.button_count] = "Sort Items Aphabetically"
			popup.button_titles[popup.button_count] = "Sort"
			buttons[popup.button_count] = "SORT"
		end if
	end if
else
	if true then
		popup.button_count = popup.button_count + 1
		popup.button_icons[popup.button_count] = "button17.bmp"
		popup.button_helps[popup.button_count] = "Add User to personal Short List"
		popup.button_titles[popup.button_count] = "Personal Short List"
		buttons[popup.button_count] = "SHORT LISTPERSONAL"
	end if
	
	if lb_edit_common_short_list then
		popup.button_count = popup.button_count + 1
		popup.button_icons[popup.button_count] = "button17.bmp"
		popup.button_helps[popup.button_count] = "Add User to common Short List"
		popup.button_titles[popup.button_count] = "Common Short List"
		buttons[popup.button_count] = "SHORT LISTCOMMON"
	end if
end if

if len(cpr_id) > 0 and not lb_care_team and lower(actor_class) <> "role" and lower(actor_class) <> "system" and lower(actor_class) <> "special" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_add_careteam.bmp"
	popup.button_helps[popup.button_count] = "Add this " + lower(actor_class) + " to the patient's care team"
	popup.button_titles[popup.button_count] = "Put On Care Team"
	buttons[popup.button_count] = "ADDCARETEAM"
end if

if len(cpr_id) > 0 and lb_care_team then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_remove_careteam.bmp"
	popup.button_helps[popup.button_count] = "Remove this " + lower(actor_class) + " from the patient's care team"
	popup.button_titles[popup.button_count] = "Take Off Care Team"
	buttons[popup.button_count] = "REMOVECARETEAM"
end if

if len(cpr_id) > 0 and not lb_primary then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_make_primary.bmp"
	popup.button_helps[popup.button_count] = "Make this " + lower(actor_class) + " a Primary care team actor"
	popup.button_titles[popup.button_count] = "Make Primary"
	buttons[popup.button_count] = "MAKEPRIMARY"
end if

if allow_editing and left(ls_user_id, 1) = "!" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_edit2.bmp"
	popup.button_helps[popup.button_count] = "Edit this role"
	popup.button_titles[popup.button_count] = "Edit Role"
	buttons[popup.button_count] = "EDITROLE"
end if

if allow_editing and left(ls_user_id, 1) <> "!" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_edit2.bmp"
	popup.button_helps[popup.button_count] = "Edit this user"
	popup.button_titles[popup.button_count] = "Edit User"
	buttons[popup.button_count] = "EDITUSER"
end if

if allow_editing and ls_user_status = "OK" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "b_push26.bmp"
	popup.button_helps[popup.button_count] = "Set this user to be inactive"
	popup.button_titles[popup.button_count] = "Set Inactive"
	buttons[popup.button_count] = "INACTIVE"
end if

if allow_editing and ls_user_status = "NA" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button26.bmp"
	popup.button_helps[popup.button_count] = "Set this user to be active"
	popup.button_titles[popup.button_count] = "Set Active"
	buttons[popup.button_count] = "ACTIVE"
end if

if allow_editing and lb_active then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button06.bmp"
	popup.button_helps[popup.button_count] = "Reset this user"
	popup.button_titles[popup.button_count] = "Reset"
	buttons[popup.button_count] = "RESET"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	button_pressed = message.doubleparm
	if button_pressed < 1 or button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	button_pressed = 1
else
	return
end if

CHOOSE CASE buttons[button_pressed]
	CASE "ADDCARETEAM"
		li_sts = f_set_progress(cpr_id, &
							"Patient", &
							ll_null, &
							"Care Team", &
							ls_user_id, &
							"True", &
							ldt_null, &
							ll_null, &
							ll_null, &
							ll_null)
	load_care_team( )
	CASE "REMOVECARETEAM"
		li_sts = f_set_progress(cpr_id, &
							"Patient", &
							ll_null, &
							"Care Team", &
							ls_user_id, &
							"False", &
							ldt_null, &
							ll_null, &
							ll_null, &
							ll_null)
	load_care_team( )
	if current_search = "CARE TEAM" then
		search()
	end if
	CASE "MAKEPRIMARY"
		li_sts = f_set_progress(cpr_id, &
							"Patient", &
							ll_null, &
							"Care Team", &
							ls_user_id, &
							"Primary", &
							ldt_null, &
							ll_null, &
							ll_null, &
							ll_null)
	load_care_team( )
	if current_search = "CARE TEAM" then
		search()
	end if
	CASE "SHORT LISTPERSONAL"
		li_sts = tf_add_personal_top_20(top_20_code(), ls_description, ls_user_id, ls_null, ll_null)
	CASE "SHORT LISTCOMMON"
		li_sts = tf_add_common_top_20(top_20_code(), ls_description, ls_user_id, ls_null, ll_null)
	CASE "REMOVE"
		li_sts = remove_top_20(pl_row)
		if li_sts > 0 then
			recalc_page(ls_temp)
		end if
	CASE "MOVE"
		li_sts = move_row(pl_row)
	CASE "SORT"
		// Clear the temp variable so the row isn't re-selected
		setnull(top_20_sequence)
		li_sts = sort_rows()
		search()
	CASE "EDITUSER"
		popup.data_row_count = 1
		popup.items[1] = ls_user_id
		openwithparm(w_user_definition, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		object.user_full_name[pl_row] = popup_return.descriptions[1]
	CASE "EDITROLE"
		popup.item = ls_user_id
		openwithparm(w_role_definition, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		if dataobject = "dw_sp_user_top_20_search" then
			object.user_full_name[pl_row] = popup_return.descriptions[1]
		else
			object.role_name[pl_row] = popup_return.descriptions[1]
		end if
	CASE "INACTIVE"
		ls_license_flag = user_list.user_property(ls_user_id, "license_flag")
		if ls_license_flag = "P" or ls_license_flag = "E" then
			openwithparm(w_pop_yes_no, "You are about to make inactive a licensed user.  You will not be able to re-activate this user for " + string(reactdays) + " days.  Are you sure you want to do this?")
			popup_return = message.powerobjectparm
			if popup_return.item <> "YES" then return
		end if
		user_list.inactivate_user(ls_user_id)
	CASE "ACTIVE"
		user_list.activate_user(ls_user_id)
	CASE "RESET"
		popup.dataobject = "dw_user_active_computer_list"
		popup.datacolumn = 2
		popup.displaycolumn = 3
		popup.argument_count = 2
		popup.argument[1] = ls_user_id
		popup.argument[2] = string(gnv_app.computer_id)
		popup.auto_singleton = true
		openwithparm(w_pop_pick, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		
		ll_picked_computer_id = long(popup_return.items[1])
		DELETE o_User_Service_Lock
		WHERE user_id = :ls_user_id
		AND computer_id = :ll_picked_computer_id;
		if not tf_check() then return
		DELETE o_Users
		WHERE user_id = :ls_user_id
		AND computer_id = :ll_picked_computer_id;
		if not tf_check() then return
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return

end subroutine

public function integer initialize (str_pick_users pstr_pick_users);
pick_users = pstr_pick_users

care_team = CREATE u_ds_data
care_team.set_dataobject("dw_jmj_patient_care_team_list")

if len(pick_users.cpr_id) > 0 then
	cpr_id = pick_users.cpr_id
	load_care_team()
else
	setnull(cpr_id)
end if

top_20_code_base = "USERPICKLIST"

// If an actor_class was specified, then assume the user wants to start with it
if pstr_pick_users.hide_users then
	if len(pstr_pick_users.actor_class) > 0 then
		set_actor_class(pstr_pick_users.actor_class)
	elseif pstr_pick_users.allow_roles then
		set_actor_class("Role")
	elseif pstr_pick_users.allow_system_users then
		set_actor_class("System")
	elseif pstr_pick_users.allow_special_users then
		set_actor_class("Special")
	end if
else
	set_actor_class("User")
end if

if len(pick_users.search_option) > 0 then
	current_search = upper(pick_users.search_option)
else
	current_search = "SHORT LIST"
end if

specialty_id = pick_users.specialty_id

settransobject(sqlca)

return 1

end function

public function integer retrieve_care_team ();string ls_temp
long ll_count
string ls_show_users_flag
string ls_other_actor_class

setredraw(false)
if dataobject <> "dw_jmj_patient_care_team_list" then
	dataobject = "dw_jmj_patient_care_team_list"
	settransobject(sqlca)
	object.user_full_name.width = width - 260
end if

// Show the Users on the care team if the users are allowed in this search AND the user actor class is chosen
if pick_users.hide_users then
	ls_show_users_flag = "N"
elseif isnull(actor_class) or lower(actor_class) = "user" then
	ls_show_users_flag = "Y"
else
	ls_show_users_flag = "N"
end if

// Always show the other actor class if it's included in this search
if lower(pick_users.actor_class) <> "user" then
	ls_other_actor_class = pick_users.actor_class
else
	setnull(ls_other_actor_class)
end if

ll_count = retrieve(cpr_id, ls_show_users_flag, ls_other_actor_class)
setredraw(true)

last_page = 0
set_page(1, ls_temp)

setredraw(true)

this.event POST users_loaded(search_description)

return ll_count

end function

public function integer search_care_team ();integer li_sts
string ls_patient_name

SELECT dbo.fn_patient_full_name(:cpr_id)
INTO :ls_patient_name
FROM c_1_record;
if not tf_check() then return -1

search_description = "Care Team for " + ls_patient_name

current_search = "CARE TEAM"

li_sts = retrieve_care_team()
if li_sts < 0 then return -1

return 1


end function

public subroutine set_actor_class (string ps_actor_class);
actor_class = ps_actor_class



CHOOSE CASE lower(actor_class)
	CASE "user"
		use_distance_filter = false
		if user_list.is_user_privileged(current_user.user_id, "Edit Users") then
			allow_editing = true
		else
			allow_editing = false
		end if
	CASE "role"
		use_distance_filter = false
		if user_list.is_user_privileged(current_user.user_id, "Edit Roles") then
			allow_editing = true
		else
			allow_editing = false
		end if
	CASE "system"
		use_distance_filter = false
		allow_editing = false
	CASE "special"
		use_distance_filter = false
		allow_editing = false
	CASE ELSE
		use_distance_filter = true
		if user_list.is_user_privileged(current_user.user_id, "Edit Actors") then
			allow_editing = true
		else
			allow_editing = false
		end if
END CHOOSE


end subroutine

public function integer retrieve_by_name (string ps_name);string ls_temp
long ll_count
string ls_role_id
string ls_zipcode

if lower(actor_class) = "role" then
	setredraw(false)
	if dataobject <> "dw_pick_role_with_prefix" then
		dataobject = "dw_pick_role_with_prefix"
		settransobject(sqlca)
		object.user_full_name.width = width - 260
	end if
	
	ll_count = retrieve(ps_name, role_prefix, user_status)
	
	last_page = 0
	set_page(1, ls_temp)

	setredraw(true)

	this.event POST users_loaded(search_description)
	
	return ll_count
end if

setredraw(false)
if dataobject <> "dw_sp_user_search" then
	dataobject = "dw_sp_user_search"
	settransobject(sqlca)
	object.user_full_name.width = width - 260
end if

setnull(ls_role_id)
if disable_zipcode_filter then
	ls_zipcode = "No"
else
	setnull(ls_zipcode)
end if

ll_count = retrieve( &
						ls_role_id, &
						specialty_id, &
						ps_name, &
						user_status, &
						actor_class, &
						cpr_id, &
						distance_filter_amount, &
						distance_filter_unit, &
						gnv_app.office_id, &
						ls_zipcode)

last_page = 0
set_page(1, ls_temp)

setredraw(true)

this.event POST users_loaded(search_description)

return ll_count

end function

public function integer retrieve_by_role (string ps_role_id);string ls_temp
long ll_count
string ls_name
string ls_zipcode

setredraw(false)
if dataobject <> "dw_sp_user_search" then
	dataobject = "dw_sp_user_search"
	settransobject(sqlca)
	object.user_full_name.width = width - 260
end if

setnull(ls_name)
setnull(ls_zipcode)

ll_count = retrieve( &
						ps_role_id, &
						specialty_id, &
						ls_name, &
						user_status, &
						actor_class, &
						cpr_id, &
						distance_filter_amount, &
						distance_filter_unit, &
						gnv_app.office_id, &
						ls_zipcode)


last_page = 0
set_page(1, ls_temp)

setredraw(true)

this.event POST users_loaded(search_description)

return ll_count

end function

public function integer search_name (string ps_name);string ls_null
integer li_sts
string ls_search

setnull(ls_null)

ls_search = f_string_substitute(ps_name, "%", "")

if isnull(ps_name) or ps_name = "" or ps_name = "%" then
	// Search is for ALL
	last_search_name = "%"
	search_description = "<All>"
else
	if left(ps_name, 1) <> "%" then
		// Search is "Begins With"
		last_search_name = ls_search + "%"
		search_description = 'Begins With "' + ls_search + '"'
	else
		// Search is "Contains"
		last_search_name = "%" + ls_search + "%"
		search_description = 'Contains "' + ls_search + '"'
	end if
end if

current_search = "BY NAME"

li_sts = retrieve_by_name(last_search_name)
if li_sts < 0 then return -1

return li_sts


end function

public function integer search_short_list ();str_popup popup
str_popup_return popup_return
string ls_null
integer li_sts

setnull(ls_null)

current_search = "SHORT LIST"

top_20_user_id = current_user.user_id
search_description = "Personal List"

li_sts = retrieve_short_list(top_20_user_id)
if li_sts < 0 then return -1
if li_sts = 0 then
	top_20_user_id = current_user.common_list_id()
	search_description = "Common List"
	li_sts = retrieve_short_list(top_20_user_id)
	if li_sts < 0 then return -1
end if

return li_sts

end function

public function integer search_short_list (boolean pb_personal_list);str_popup popup
str_popup_return popup_return
string ls_null
integer li_sts

setnull(ls_null)

if pb_personal_list then
	top_20_user_id = current_user.user_id
	search_description = "Personal List"
else
	top_20_user_id = current_user.common_list_id()
	search_description = "Common List"
end if

current_search = "SHORT LIST"

li_sts = retrieve_short_list(top_20_user_id)
if li_sts < 0 then return -1

if li_sts = 0 and pb_personal_list then
	openwithparm(w_pop_yes_no, "Your personal list is empty.  Do you wish to start with a copy of the common list?")
	popup_return = message.powerobjectparm
	if popup_return.item = "YES" then
		f_copy_top_20_common_list(current_user.user_id, current_user.specialty_id, top_20_code())
		li_sts = retrieve_short_list(top_20_user_id)
		if li_sts < 0 then return -1
	end if
end if


return li_sts


end function

public function string top_20_code ();string ls_top_20_code

if lower(actor_class) = "user" then
	ls_top_20_code = top_20_code_base
else
	ls_top_20_code = top_20_code_base + "^" + actor_class
	if lower(actor_class) = "consultant" and len(specialty_id) > 0 then
		ls_top_20_code += "^" + specialty_id
	end if
end if


return ls_top_20_code

end function

public subroutine load_care_team ();

care_team_count = care_team.retrieve(cpr_id, "Y", "%")

return

end subroutine

public function integer retrieve_by_zip (string ps_zipcode);string ls_temp
long ll_count
string ls_name
string ls_role_id


setredraw(false)
if dataobject <> "dw_sp_user_search" then
	dataobject = "dw_sp_user_search"
	settransobject(sqlca)
	object.user_full_name.width = width - 260
end if

setnull(ls_name)
setnull(ls_role_id)

ll_count = retrieve( &
						ls_role_id, &
						specialty_id, &
						ls_name, &
						user_status, &
						actor_class, &
						cpr_id, &
						distance_filter_amount, &
						distance_filter_unit, &
						gnv_app.office_id, &
						ps_zipcode)

last_page = 0
set_page(1, ls_temp)

setredraw(true)

this.event POST users_loaded(search_description)

return ll_count

end function

public function integer search_by_zip ();str_popup popup
str_popup_return popup_return
integer li_sts
string ls_null

setnull(ls_null)

popup.title = "Enter a single 5-digit zip code"
popup.item = last_search_zipcode
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

if len(popup_return.items[1]) <> 5 then
	openwithparm(w_pop_message, "Invalid Zipcode")
	return 0
end if

return search_by_zip(popup_return.items[1])

end function

public function integer search_by_zip (string ps_zipcode);integer li_sts
string ls_null

setnull(ls_null)

last_search_zipcode = ps_zipcode
search_description = "Zipcode = " + last_search_zipcode

current_search = "BY ZIP"

li_sts = retrieve_by_zip(last_search_zipcode)
if li_sts < 0 then return -1

return 1


end function

on u_dw_user_list.create
call super::create
end on

on u_dw_user_list.destroy
call super::destroy
end on

event computed_clicked;integer li_selected_flag
long ll_row

setnull(top_20_sequence)

if current_search = "SHORT LIST" then
	top_20_sequence = object.top_20_sequence[clicked_row]
end if

li_selected_flag = object.selected_flag[clicked_row]

object.selected_flag[clicked_row] = 1
user_menu(clicked_row)

clear_selected()

if li_selected_flag > 0 and mode = "PICK" then
	if current_search = "SHORT LIST" then
		if isnull(top_20_sequence) then
			ll_row = 0
		else
			ll_row = find("top_20_sequence=" + string(top_20_sequence), 1, rowcount())
		end if
	else
		ll_row = clicked_row
	end if
	
	if ll_row > 0 then object.selected_flag[ll_row] = li_selected_flag
else
	clear_selected()
end if


end event

event retrieveend;call super::retrieveend;string ls_filter

ls_filter = ""

// Filter out users who aren't allowed to be picked in this search
if not pick_users.allow_roles then
	if len(ls_filter) > 0 then ls_filter += " and "
	ls_filter += "upper(user_status)<>'ROLE'"
end if

if not pick_users.allow_special_users then
	if len(ls_filter) > 0 then ls_filter += " and "
	ls_filter += "upper(user_status)<>'SPECIAL'"
end if

if not pick_users.allow_system_users then
	if len(ls_filter) > 0 then ls_filter += " and "
	ls_filter += "upper(user_status)<>'SYSTEM'"
end if

setfilter(ls_filter)
filter()


end event

event destructor;call super::destructor;if not isnull(care_team) and isvalid(care_team) then
	DESTROY care_team
end if

end event

