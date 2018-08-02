$PBExportHeader$u_dw_config_object_list.sru
forward
global type u_dw_config_object_list from u_dw_pick_list
end type
end forward

global type u_dw_config_object_list from u_dw_pick_list
integer width = 1883
string dataobject = "dw_jmj_config_object_top_20"
boolean border = false
boolean select_computed = false
event config_objects_loaded ( string ps_description )
event item_selected ( long pl_row )
end type
global u_dw_config_object_list u_dw_config_object_list

type variables
// Search Criteria
string config_object_type
string context_object
string status = "OK"
string description
string config_object_category
string top_20_user_id
boolean auto_install

string configuration_service

// Behavior States
string mode = "EDIT"
boolean allow_editing

// Other states
string current_search = "TOP20"
// Values = TOP20, <config_object_type>

string search_description

// Temp variable to hold the record currently being worked on
long top_20_sequence

window myparentwindow

//string script_type = "RTF"

boolean show_beta = true

long owner_filter

end variables

forward prototypes
public function string pick_top_20_code ()
public function integer remove_top_20 (long pl_row)
public function integer retrieve_short_list (string ps_top_20_user_id)
public function integer search ()
public function integer search_top_20 ()
public function integer search_description (string ps_description)
public function integer sort_rows ()
public function integer search_description ()
public function integer search_top_20 (boolean pb_personal_list)
public function integer move_row (long pl_row)
public function integer delete_config_object (long pl_row)
public subroutine config_object_menu (long pl_row)
public function integer search_category ()
public subroutine export_config_object (string ps_config_object_id)
public function integer retrieve_config_objects (string ps_description, string ps_config_object_category)
public function integer initialize (string ps_config_object_type)
public function integer manage_config_object (string ps_config_object_id)
public function integer search_library ()
public function integer search_library (string ps_description)
public function string pick_top_20_code (string ps_context_object)
public subroutine set_filter ()
end prototypes

public function string pick_top_20_code ();return pick_top_20_code(context_object)

end function

public function integer remove_top_20 (long pl_row);integer li_sts

if current_search <> "TOP20" then return 0

deleterow(pl_row)
li_sts = update()

return li_sts

end function

public function integer retrieve_short_list (string ps_top_20_user_id);string ls_temp
long ll_count
string ls_min_release_status

if lower(sqlca.database_mode) = "testing" and show_beta then
	ls_min_release_status = "Testing"
elseif show_beta then
	ls_min_release_status = "Beta"
else
	ls_min_release_status = "Production"
end if

dataobject = "dw_jmj_config_object_top_20"
settransobject(sqlca)

set_filter()

ll_count = retrieve(config_object_type, ps_top_20_user_id, pick_top_20_code(), status, ls_min_release_status)

last_page = 0
set_page(1, ls_temp)

this.event POST config_objects_loaded(search_description)

return ll_count

end function

public function integer search ();integer li_sts
string ls_null

setnull(ls_null)


CHOOSE CASE upper(current_search)
	CASE "TOP20"
		li_sts = retrieve_short_list(top_20_user_id)
	CASE ELSE
		li_sts = retrieve_config_objects(description, config_object_category)
END CHOOSE


return li_sts

end function

public function integer search_top_20 ();str_popup popup
str_popup_return popup_return
string ls_null
integer li_sts

setnull(ls_null)

current_search = "TOP20"

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

public function integer search_description (string ps_description);integer li_sts

setnull(config_object_category)

if isnull(ps_description) or ps_description = "" then
	description = "%"
	search_description = "<All>"
else
	description = "%" + ps_description + "%"
	search_description = 'Contains "' + ps_description + '"'
end if

current_search = "DESCRIPTION"

li_sts = retrieve_config_objects(description, config_object_category)
if li_sts < 0 then return -1

return li_sts


end function

public function integer sort_rows ();integer li_sts
integer i

if current_search <> "TOP20" then return 0

clear_selected()

setsort("description a")
sort()

for i = 1 to rowcount()
	object.sort_sequence[i] = i
next

li_sts = update()

setsort("sort_sequence a")

return 1

end function

public function integer search_description ();long ll_count
str_popup_return popup_return
integer li_sts

setnull(config_object_category)

open(w_pop_get_string_abc, myparentwindow)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

description = popup_return.items[1]
search_description = popup_return.descriptions[1]
	
current_search = "DESCRIPTION"

li_sts = retrieve_config_objects(description, config_object_category)
if li_sts < 0 then return -1

return li_sts


end function

public function integer search_top_20 (boolean pb_personal_list);str_popup popup
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

current_search = "TOP20"

li_sts = retrieve_short_list(top_20_user_id)
if li_sts < 0 then return -1

if li_sts = 0 and pb_personal_list then
	openwithparm(w_pop_yes_no, "Your personal list is empty.  Do you wish to start with a copy of the common list?", myparentwindow)
	popup_return = message.powerobjectparm
	if popup_return.item = "YES" then
		f_copy_top_20_common_list(current_user.user_id, current_user.specialty_id, pick_top_20_code( ) )
		li_sts = retrieve_short_list(top_20_user_id)
		if li_sts < 0 then return -1
	end if
end if


return li_sts


end function

public function integer move_row (long pl_row);str_popup popup
string ls_user_id
long i
string ls_drug_id
string ls_description
string ls_null
long ll_null
long ll_row
integer li_sts

setnull(ls_null)
setnull(ll_null)

if pl_row <= 0 then return 0

if current_search <> "TOP20" then return 0

ll_row = get_selected_row()
if ll_row <= 0 then
	object.selected_flag[pl_row] = 1
end if

popup.objectparm = this

openwithparm(w_pick_list_sort, popup, myparentwindow)

li_sts = update()

if ll_row <= 0 then
	clear_selected()
end if

return 1
end function

public function integer delete_config_object (long pl_row);long ll_config_object_id


ll_config_object_id = object.config_object_id[pl_row]

UPDATE c_config_object
SET status = 'NA'
WHERE config_object_id = :ll_config_object_id;
if not tf_check() then return -1

return 1

end function

public subroutine config_object_menu (long pl_row);String		buttons[]
String 		ls_drug_id,ls_temp
String 		ls_description
string		ls_null
String		ls_top_20_code
Integer		button_pressed, li_sts, li_service_count
string		ls_config_object_id
string ls_new_config_object_id
long ll_null
str_config_object_info lstr_config_object_info
window 				lw_pop_buttons
//w_config_object_edit lw_edit_window
w_window_base lw_edit_window
str_popup 			popup
str_popup_return 	popup_return
//w_config_object_display		lw_config_object_display
w_window_base		lw_config_object_display
long ll_installed_version
boolean lb_locally_owned
long ll_production_version
long ll_beta_version
long ll_testing_version
boolean lb_library_object
boolean lb_local_object
long ll_version

Setnull(ls_null)
Setnull(ll_null)

ll_installed_version = object.installed_version[pl_row]
ll_production_version = object.production_version[pl_row]
ll_beta_version = object.beta_version[pl_row]
ll_testing_version = object.testing_version[pl_row]
if long(object.library_object[pl_row]) = 0 then
	lb_library_object = false
else
	lb_library_object = true
end if
if long(object.local_object[pl_row]) = 0 then
	lb_local_object = false
else
	lb_local_object = true
end if

ls_config_object_id = object.config_object_id[pl_row]
ls_description = object.description[pl_row]

li_sts = f_get_config_object_info(ls_config_object_id, lstr_config_object_info)
if li_sts <= 0 then
	log.log(this, "u_dw_config_object_list.config_object_menu.0050", "error getting config object info (" + ls_config_object_id + ")", 4)
	openwithparm(w_pop_message, "Object not found")
	return
end if

if sqlca.customer_id = lstr_config_object_info.owner_id then
	lb_locally_owned = true
else
	lb_locally_owned = false
end if

if lb_local_object and current_search <> "TOP20" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Add drug to personal Short List List"
	popup.button_titles[popup.button_count] = "Personal Short List"
	buttons[popup.button_count] = "TOP20PERSONAL"
end if

if lb_local_object and current_search <> "TOP20" and current_user.check_privilege("Edit Common Short Lists") then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Add drug to common Short List List"
	popup.button_titles[popup.button_count] = "Common Short List"
	buttons[popup.button_count] = "TOP20COMMON"
end if

if current_search = "TOP20" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Remove item from Short List"
	popup.button_titles[popup.button_count] = "Remove Short List"
	buttons[popup.button_count] = "REMOVE"
end if

if current_search = "TOP20" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonmove.bmp"
	popup.button_helps[popup.button_count] = "Move record up or down"
	popup.button_titles[popup.button_count] = "Move"
	buttons[popup.button_count] = "MOVE"
end if

if current_search = "TOP20" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonx3.bmp"
	popup.button_helps[popup.button_count] = "Sort Items Aphabetically"
	popup.button_titles[popup.button_count] = "Sort"
	buttons[popup.button_count] = "SORT"
end if

//if allow_editing then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button17.bmp"
//	popup.button_helps[popup.button_count] = "Edit config_object"
//	popup.button_titles[popup.button_count] = "Edit"
//	buttons[popup.button_count] = "EDIT"
//else
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button17.bmp"
//	popup.button_helps[popup.button_count] = "Review config_object"
//	popup.button_titles[popup.button_count] = "Review"
//	buttons[popup.button_count] = "EDIT"
//end if
//
//if allow_editing then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button13.bmp"
//	popup.button_helps[popup.button_count] = "Delete Procedure"
//	popup.button_titles[popup.button_count] = "Delete"
//	buttons[popup.button_count] = "DELETE"
//end if

//if allow_editing then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button17.bmp"
//	popup.button_helps[popup.button_count] = "Manage " + config_object_type
//	popup.button_titles[popup.button_count] = "Manage"
//	buttons[popup.button_count] = "MANAGE"
//end if


if allow_editing then
	if isnull(ll_installed_version) then
		if true then
			popup.button_count = popup.button_count + 1
			popup.button_icons[popup.button_count] = "button_install.bmp"
			popup.button_helps[popup.button_count] = "Install " + config_object_type
			popup.button_titles[popup.button_count] = "Install"
			buttons[popup.button_count] = "INSTALL"
		end if
	else
		if true then
			popup.button_count = popup.button_count + 1
			popup.button_icons[popup.button_count] = "button_wrench.bmp"
			popup.button_helps[popup.button_count] = "Configure " + config_object_type
			popup.button_titles[popup.button_count] = "Configure"
			buttons[popup.button_count] = "CONFIGURE"
		end if
		
		if ll_installed_version > lstr_config_object_info.earliest_version OR ll_installed_version > 1 then
			popup.button_count = popup.button_count + 1
			popup.button_icons[popup.button_count] = "button_workflow.bmp"
			popup.button_helps[popup.button_count] = "Revert to earlier version"
			popup.button_titles[popup.button_count] = "Revert"
			buttons[popup.button_count] = "REVERT"
		end if
		
		if ll_installed_version < ll_production_version OR ll_installed_version < ll_beta_version OR ll_installed_version < ll_testing_version then
			popup.button_count = popup.button_count + 1
			popup.button_icons[popup.button_count] = "button_workflow.bmp"
			popup.button_helps[popup.button_count] = "Upgrade to later version"
			popup.button_titles[popup.button_count] = "Upgrade"
			buttons[popup.button_count] = "UPGRADE"
		end if
		
		if lower(lstr_config_object_info.installed_version_status) = "checkedout" and lb_locally_owned then
			popup.button_count = popup.button_count + 1
			popup.button_icons[popup.button_count] = "button_workflow.bmp"
			popup.button_helps[popup.button_count] = "Check " + lower(config_object_type) + " back in"
			popup.button_titles[popup.button_count] = "Checkin"
			buttons[popup.button_count] = "CHECKIN"
		end if
		
		if lower(lstr_config_object_info.installed_version_status) = "checkedin" and lb_locally_owned then
			popup.button_count = popup.button_count + 1
			popup.button_icons[popup.button_count] = "button_workflow.bmp"
			popup.button_helps[popup.button_count] ="Check " + lower(config_object_type) + " out and create a new version for editing"
			popup.button_titles[popup.button_count] = "Checkout"
			buttons[popup.button_count] = "CHECKOUT"
		end if
		
		if lower(lstr_config_object_info.installed_version_status) = "checkedout" and lb_locally_owned then
			popup.button_count = popup.button_count + 1
			popup.button_icons[popup.button_count] = "buttonworkflow.bmp"
			popup.button_helps[popup.button_count] = "Cancel checkout and revert to previous version"
			popup.button_titles[popup.button_count] = "Cancel Checkout"
			buttons[popup.button_count] = "CANCELCHECKOUT"
		end if
		
		if lower(lstr_config_object_info.installed_version_status) = "checkedin" then
			popup.button_count = popup.button_count + 1
			popup.button_icons[popup.button_count] = "button_install.bmp"
			popup.button_helps[popup.button_count] = "Reinstall " + config_object_type
			popup.button_titles[popup.button_count] = "Reinstall"
			buttons[popup.button_count] = "REINSTALL"
		end if
	end if
	
	if lb_local_object and (lstr_config_object_info.copyable or lb_locally_owned) then
		popup.button_count = popup.button_count + 1
		popup.button_icons[popup.button_count] = "buttonclone.bmp"
		popup.button_helps[popup.button_count] = "Copy config_object"
		popup.button_titles[popup.button_count] = "Copy"
		buttons[popup.button_count] = "COPY"
	end if
	
	if lb_local_object and lb_locally_owned then
		popup.button_count = popup.button_count + 1
		popup.button_icons[popup.button_count] = "button_export.bmp"
		popup.button_helps[popup.button_count] = "Export config_object"
		popup.button_titles[popup.button_count] = "Export"
		buttons[popup.button_count] = "EXPORT"
	end if
		
	if lb_local_object then
		if lstr_config_object_info.status = "OK" then
			popup.button_count = popup.button_count + 1
			popup.button_icons[popup.button_count] = "button13.bmp"
			popup.button_helps[popup.button_count] = "Make Inactive"
			popup.button_titles[popup.button_count] = "Make Inactive"
			buttons[popup.button_count] = "INACTIVE"
		else
			popup.button_count = popup.button_count + 1
			popup.button_icons[popup.button_count] = "button13.bmp"
			popup.button_helps[popup.button_count] = "Make Active"
			popup.button_titles[popup.button_count] = "Make Active"
			buttons[popup.button_count] = "ACTIVE"
		end if
	end if
	
	if lb_local_object and lower(lstr_config_object_info.config_object_type) = "report" then
		popup.button_count = popup.button_count + 1
		popup.button_icons[popup.button_count] = "button_print.bmp"
		popup.button_helps[popup.button_count] = "Configure Printers for this report"
		popup.button_titles[popup.button_count] = "Set Printers"
		buttons[popup.button_count] = "PRINTERS"
	end if
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
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons", myparentwindow)
	button_pressed = message.doubleparm
	if button_pressed < 1 or button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	button_pressed = 1
else
	return
end if

CHOOSE CASE buttons[button_pressed]
	CASE "TOP20PERSONAL"
		ls_top_20_code = pick_top_20_code()
		if not isnull(ls_top_20_code) then
			ls_config_object_id = object.config_object_id[pl_row]
			li_sts = tf_add_personal_top_20(ls_top_20_code, ls_description, ls_config_object_id, ls_null, ll_null)
		end if
	CASE "TOP20COMMON"
		ls_top_20_code = pick_top_20_code()
		if not isnull(ls_top_20_code) then
			ls_config_object_id = object.config_object_id[pl_row]
			li_sts = tf_add_common_top_20(ls_top_20_code, ls_description, ls_config_object_id, ls_null, ll_null)
		end if
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
//	CASE "EDIT"
//		openwithparm(lw_edit_window, ls_config_object_id, "w_config_object_edit", myparentwindow)
//	CASE "DISPLAY"
//		SELECT CAST(id AS varchar(38))
//		INTO :popup.items[1]
//		FROM c_config_object
//		WHERE config_object_id = :ls_config_object_id;
//		if not tf_check() then return
//		popup.items[2] = f_boolean_to_string(allow_editing)
//		popup.data_row_count = 2
//		openwithparm(lw_config_object_display, popup, "w_config_object_display", myparentwindow)
//	CASE "MANAGE"
//		manage_config_object(ls_config_object_id)
	CASE "INSTALL"
		ll_version = f_config_object_pick_version(ls_config_object_id, show_beta, "All")
		if isnull(ll_version) then return
		if ll_version < 0 then return
		
		openwithparm(w_pop_yes_no, "Are you sure you want to install version # " + string(ll_version) + " of the selected " + lstr_config_object_info.config_object_type + "?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return
		
		li_sts = f_config_object_install(ls_config_object_id, ll_version)
		if li_sts <= 0 then
			log.log(this, "u_dw_config_object_list.config_object_menu.0309", "Error installing config object version (" + ls_config_object_id + ", " + string(ll_version) + ")", 4)
			return
		end if
	CASE "REINSTALL"
		ll_version = ll_installed_version
		if isnull(ll_version) then return
		if ll_version < 0 then return
		
		openwithparm(w_pop_yes_no, "Are you sure you want to reinstall version # " + string(ll_version) + " of the selected " + lstr_config_object_info.config_object_type + "?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return
		
		li_sts = f_config_object_install(ls_config_object_id, ll_version)
		if li_sts <= 0 then
			log.log(this, "u_dw_config_object_list.config_object_menu.0309", "Error installing config object version (" + ls_config_object_id + ", " + string(ll_version) + ")", 4)
			return
		end if
	CASE "CONFIGURE"
		f_configure_config_object(ls_config_object_id)
	CASE "COPY"
		string ls_message
		// Make sure the object is checked in
		if lower(lstr_config_object_info.installed_version_status) = "checkedout" then
			if lower(lstr_config_object_info.checked_out_by) = lower(current_user.user_id) then
				ls_message = "This " + lower(lstr_config_object_info.config_object_type) + " is checked out by you"
			else
				ls_message = "This " + lower(lstr_config_object_info.config_object_type) + " is checked out by " + user_list.user_full_name(lstr_config_object_info.checked_out_by)
			end if
			ls_message += " and must be checked in to copy.  Do you wish to check the " + lower(lstr_config_object_info.config_object_type) + " back in now?"
			openwithparm(w_pop_yes_no, ls_message)
			popup_return = message.powerobjectparm
			if popup_return.item <> "YES" then return
			
			li_sts = f_check_in_config_object(lstr_config_object_info)
			if li_sts <= 0 then return
		end if

		openwithparm(w_pop_yes_no, "This will create a new " + lower(config_object_type) + "  which is a copy of the ~"" + ls_description + "~" config_object.  Are you sure you wish to do this?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return
		
		ls_new_config_object_id = f_copy_config_object(ls_config_object_id)
		if len(ls_new_config_object_id) > 0 then
			f_configure_config_object(ls_new_config_object_id)
		end if
	CASE "EXPORT"
		export_config_object(ls_config_object_id)
	CASE "INACTIVE"
		openwithparm(w_pop_yes_no, "Are you sure you want to make this " + lower(config_object_type) + " inactive?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return
		
		UPDATE c_config_object
		SET status = 'NA'
		WHERE config_object_id =:ls_config_object_id;
		if not tf_check() then return

		openwithparm(w_pop_yes_no, "Do you want to remove this " + lower(config_object_type) + " from all short-lists?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return
		
		DELETE FROM u_top_20
		WHERE top_20_code LIKE 'config_object%'
		AND item_id = :ls_config_object_id;
		if not tf_check() then return
	CASE "ACTIVE"
		openwithparm(w_pop_yes_no, "Are you sure you want to make this " + lower(config_object_type) + " active?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return
		
		UPDATE c_config_object
		SET status = 'OK'
		WHERE config_object_id =:ls_config_object_id;
		if not tf_check() then return
	CASE "PRINTERS"
		openwithparm(w_report_printer, ls_config_object_id)
	CASE "REVERT"
		li_sts = f_config_object_revert_version(ls_config_object_id, show_beta)
	CASE "UPGRADE"
		li_sts = f_config_object_upgrade_version(ls_config_object_id, show_beta)
	CASE "CHECKIN"
		li_sts = f_check_in_config_object(lstr_config_object_info)
	CASE "CHECKOUT"
		li_sts = f_check_out_config_object(lstr_config_object_info)
	CASE "CANCELCHECKOUT"
		li_sts = f_config_object_cancel_checkout(lstr_config_object_info.config_object_id)
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

search()

end subroutine

public function integer search_category ();str_popup popup
str_popup_return popup_return
string ls_null
integer li_sts

setnull(ls_null)

popup.dataobject = "dw_c_config_object_category"
popup.datacolumn = 3
popup.displaycolumn = 3
popup.argument_count = 2
popup.argument[1] = config_object_type
popup.argument[2] = context_object
openwithparm(w_pop_pick, popup, myparentwindow)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then
	if popup_return.choices_count <= 0 then
		openwithparm(w_pop_message, "No Categories have been defined for " + lower(config_object_type) + "s.")
	end if
	return 0
end if

config_object_category = popup_return.items[1]
search_description = popup_return.descriptions[1]

current_search = "CATEGORY"

li_sts = retrieve_config_objects(description, config_object_category)
if li_sts < 0 then return -1

return li_sts


end function

public subroutine export_config_object (string ps_config_object_id);str_popup_return popup_return
str_service_info lstr_service
string ls_message
string ls_new_config_object_id
str_config_object_info lstr_config_object_info
integer li_sts

// Get the config object info
li_sts = f_get_config_object_info(ps_config_object_id, lstr_config_object_info)
if li_sts <= 0 then return

// Make sure the user owns this config object
if sqlca.customer_id = lstr_config_object_info.owner_id then
	// Make sure the object is checked in
	if lower(lstr_config_object_info.installed_version_status) = "checkedout" then
		if lower(lstr_config_object_info.checked_out_by) = lower(current_user.user_id) then
			ls_message = "This " + lower(lstr_config_object_info.config_object_type) + " is checked out by you"
		else
			ls_message = "This " + lower(lstr_config_object_info.config_object_type) + " is checked out by " + user_list.user_full_name(lstr_config_object_info.checked_out_by)
		end if
		ls_message += " and must be checked in to copy.  Do you wish to check the " + lower(lstr_config_object_info.config_object_type) + " back in now?"
		openwithparm(w_pop_yes_no, ls_message)
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return
		
		li_sts = f_check_in_config_object(lstr_config_object_info)
		if li_sts <= 0 then return
	end if
else
	if lstr_config_object_info.copyable then
		ls_message = "You must be the owner of a "
		ls_message += lower(config_object_type)
		ls_message +=  " to export it.  You may make a copy of the "
		ls_message += lower(config_object_type)
		ls_message += " and export the copy.  Do you wish to make a copy of this "
		ls_message += lower(config_object_type)
		ls_message += " now?"
		openwithparm(w_pop_yes_no, ls_message)
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return
		
		
		ls_new_config_object_id = f_copy_config_object(ps_config_object_id)
		if len(ls_new_config_object_id) > 0 then
			ps_config_object_id = ls_new_config_object_id
		else
			openwithparm(w_pop_message, "An error occured copying the config_object.  See the error log for more information.")
			return
		end if
	else
		ls_message = "You must be the owner of a "
		ls_message += lower(config_object_type)
		ls_message +=  " to export it.  This "
		ls_message += lower(config_object_type)
		ls_message += " is not copyable."
		openwithparm(w_pop_message, ls_message)
		return
	end if
end if

f_attribute_add_attribute(lstr_service.attributes, "config_object_type", config_object_type)
f_attribute_add_attribute(lstr_service.attributes, "config_object_id", ps_config_object_id)
lstr_service.service = "Export Config"

service_list.do_service(lstr_service)


end subroutine

public function integer retrieve_config_objects (string ps_description, string ps_config_object_category);string ls_temp
long ll_count
string ls_local_or_library
string ls_min_release_status

if current_search = "LIBRARY" then
	ls_local_or_library = "Library"
else
	ls_local_or_library = "Local"
end if

if lower(sqlca.database_mode) = "testing" and show_beta then
	ls_min_release_status = "Testing"
elseif show_beta then
	ls_min_release_status = "Beta"
else
	ls_min_release_status = "Production"
end if

dataobject = "dw_jmj_config_object_search"
settransobject(sqlca)

set_filter()

ll_count = retrieve(config_object_type, &
						context_object, &
						ps_description, &
						ps_config_object_category, &
						status, &
						ls_local_or_library, &
						ls_min_release_status)


last_page = 0
set_page(1, ls_temp)

this.event POST config_objects_loaded(search_description)

return ll_count

end function

public function integer initialize (string ps_config_object_type);powerobject lo_object
integer li_iterations
integer li_auto_install_flag

config_object_type = wordcap(ps_config_object_type)

SELECT configuration_service, auto_install_flag
INTO :configuration_service, :li_auto_install_flag
FROM c_Config_Object_Type
WHERE config_object_type = :config_object_type;
if not tf_check() then return -1

if li_auto_install_flag = 0 then
	auto_install = false
else
	auto_install = true
end if

if user_list.is_user_service(current_user.user_id, configuration_service) then
	allow_editing = true
else
	allow_editing = false
end if

settransobject(sqlca)

// A bug in PowerBuilder is causing the parent window of the w_pop_time_interval popup
// to sometimes be incorrect, which causes encounterpro to freeze when the popup closes.
// This sections attempts to identify the current active window and uses it as the
// parent of the popup
li_iterations = 0
lo_object = this
DO WHILE isvalid(lo_object) and li_iterations < 20
	if left(lo_object.classname(), 2) = "w_" then
		myparentwindow = lo_object
		exit
	end if
	li_iterations += 1
	lo_object = lo_object.getparent()
LOOP

owner_filter = -99 // All owners

return 1

end function

public function integer manage_config_object (string ps_config_object_id);str_service_info lstr_service

lstr_service.service = "SVCConfigObjectManager"
f_attribute_add_attribute(lstr_service.attributes, "config_object_type", config_object_type)
f_attribute_add_attribute(lstr_service.attributes, "config_object_id", ps_config_object_id)

service_list.do_service(lstr_service)


return 1

end function

public function integer search_library ();long ll_count
str_popup_return popup_return
integer li_sts

setnull(config_object_category)

open(w_pop_get_string_abc, myparentwindow)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

description = popup_return.items[1]
search_description = popup_return.descriptions[1]
	
current_search = "LIBRARY"

li_sts = retrieve_config_objects(description, config_object_category)
if li_sts < 0 then return -1

return li_sts


end function

public function integer search_library (string ps_description);integer li_sts

setnull(config_object_category)

if isnull(ps_description) or ps_description = "" then
	description = "%"
	search_description = "<All>"
else
	description = "%" + ps_description + "%"
	search_description = 'Contains "' + ps_description + '"'
end if

current_search = "LIBRARY"

li_sts = retrieve_config_objects(description, config_object_category)
if li_sts < 0 then return -1

return li_sts


end function

public function string pick_top_20_code (string ps_context_object);string ls_top_20_code


ls_top_20_code = config_object_type + "|" + ps_context_object


return ls_top_20_code

end function

public subroutine set_filter ();
if owner_filter = -1 then
	// shareware
	setfilter("owner_id>=1000 and owner_id <= 9999")
elseif owner_filter >= 0 then
	setfilter("owner_id=" + string(owner_filter))
else
	// No filter
	setfilter("")
end if

return

end subroutine

on u_dw_config_object_list.create
call super::create
end on

on u_dw_config_object_list.destroy
call super::destroy
end on

event computed_clicked;integer li_selected_flag
long ll_row
string ls_config_object_id

setnull(top_20_sequence)

if current_search = "TOP20" then
	top_20_sequence = object.top_20_sequence[clicked_row]
end if

li_selected_flag = object.selected_flag[clicked_row]

object.selected_flag[clicked_row] = 1
config_object_menu(clicked_row)

clear_selected()

if li_selected_flag > 0 and mode = "PICK" then
	if current_search = "TOP20" then
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

event retrieveend;call super::retrieveend;
object.t_background.width = width - 251

end event

event selected;call super::selected;integer li_selected_flag
long ll_row
string ls_config_object_id

setnull(top_20_sequence)

if mode = "PICK" then
	this.event post item_selected(selected_row)
elseif mode = "EDIT" and allow_editing then
	if current_search = "TOP20" then
		top_20_sequence = object.top_20_sequence[selected_row]
	end if
	
	li_selected_flag = object.selected_flag[selected_row]
	
	object.selected_flag[selected_row] = 1
	config_object_menu(selected_row)
	
	clear_selected()
end if

end event

