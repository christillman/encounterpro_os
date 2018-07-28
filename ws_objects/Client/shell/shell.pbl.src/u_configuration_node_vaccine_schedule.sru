$PBExportHeader$u_configuration_node_vaccine_schedule.sru
forward
global type u_configuration_node_vaccine_schedule from u_configuration_node_base
end type
end forward

global type u_configuration_node_vaccine_schedule from u_configuration_node_base
end type
global u_configuration_node_vaccine_schedule u_configuration_node_vaccine_schedule

type variables
boolean show_beta = true

end variables

forward prototypes
public function boolean has_children ()
public function integer activate ()
public function integer change_vaccine_schedule ()
public subroutine refresh_label ()
end prototypes

public function boolean has_children ();return false
end function

public function integer activate ();String		buttons[]
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
boolean lb_allow_editing
boolean lb_installed
string ls_message
str_pick_config_object lstr_pick_config_object
w_pick_config_object lw_pick
integer li_return_status

Setnull(ls_null)
Setnull(ll_null)
li_return_status = 1

lb_allow_editing = user_list.is_user_privileged( current_scribe.user_id, "Practice Configuration")

lstr_config_object_info = common_thread.vaccine_schedule()
ls_config_object_id = lstr_config_object_info.config_object_id
ll_installed_version = lstr_config_object_info.installed_version
if isnull(ll_installed_version) or isnull(ls_config_object_id) then 
	// If there is no vaccine schedule component installed and the user wants to edit the config then
	// fabricate a locally owned vaccine schedule from the current configuration
	sqlca.jmj_create_local_vaccine_schedule(ls_config_object_id)
	if not tf_check() then return 1
	if len(ls_config_object_id) > 0 then
		li_sts = f_get_config_object_info(ls_config_object_id, lstr_config_object_info)
		if li_sts <= 0 then return 1
		
		li_return_status = 2
	else
		openwithparm(w_pop_message, "There is no installed vaccine schedule and the attempt to create one failed")
		return 1
	end if
end if

ls_description = lstr_config_object_info.description
ll_production_version = lstr_config_object_info.production_version
ll_beta_version = lstr_config_object_info.beta_version
ll_testing_version = lstr_config_object_info.testing_version

if sqlca.customer_id = lstr_config_object_info.owner_id then
	lb_locally_owned = true
else
	lb_locally_owned = false
end if

if len(ls_config_object_id) > 0 then
	lb_installed = true
else
	lb_installed = false
end if

if lb_allow_editing then
	if true then
		popup.button_count = popup.button_count + 1
		popup.button_icons[popup.button_count] = "button_vaccine_schedule.bmp"
		popup.button_helps[popup.button_count] = "Select a different vaccine schedule for this installation"
		popup.button_titles[popup.button_count] = "Select Schedule"
		buttons[popup.button_count] = "CHANGE"
	end if
	
	if lb_allow_editing then
		popup.button_count = popup.button_count + 1
		popup.button_icons[popup.button_count] = "button_wrench.bmp"
		popup.button_helps[popup.button_count] = "Configure " + lstr_config_object_info.config_object_type
		popup.button_titles[popup.button_count] = "Configure"
		buttons[popup.button_count] = "CONFIGURE"
	end if
	
	if lb_installed and lstr_config_object_info.installed_version > lstr_config_object_info.earliest_version then
		popup.button_count = popup.button_count + 1
		popup.button_icons[popup.button_count] = "button_workflow.bmp"
		popup.button_helps[popup.button_count] = "Revert to earlier version"
		popup.button_titles[popup.button_count] = "Revert"
		buttons[popup.button_count] = "REVERT"
	end if
	
	if lb_installed and lower(lstr_config_object_info.installed_version_status) = "checkedin" and (ll_installed_version < ll_production_version OR ll_installed_version < ll_beta_version OR ll_installed_version < ll_testing_version) then
		popup.button_count = popup.button_count + 1
		popup.button_icons[popup.button_count] = "button_workflow.bmp"
		popup.button_helps[popup.button_count] = "Upgrade to later version"
		popup.button_titles[popup.button_count] = "Upgrade"
		buttons[popup.button_count] = "UPGRADE"
	end if
	
	if lb_installed and lower(lstr_config_object_info.installed_version_status) = "checkedout" and lb_locally_owned then
		popup.button_count = popup.button_count + 1
		popup.button_icons[popup.button_count] = "button_workflow.bmp"
		popup.button_helps[popup.button_count] = "Check " + lower(lstr_config_object_info.config_object_type) + " back in"
		popup.button_titles[popup.button_count] = "Checkin"
		buttons[popup.button_count] = "CHECKIN"
	end if
	
	if lb_installed and lower(lstr_config_object_info.installed_version_status) = "checkedin" and lb_locally_owned then
		popup.button_count = popup.button_count + 1
		popup.button_icons[popup.button_count] = "button_workflow.bmp"
		popup.button_helps[popup.button_count] ="Check " + lower(lstr_config_object_info.config_object_type) + " out and create a new version for editing"
		popup.button_titles[popup.button_count] = "Checkout"
		buttons[popup.button_count] = "CHECKOUT"
	end if
	
	if lb_installed and lower(lstr_config_object_info.installed_version_status) = "checkedout" and lb_locally_owned then
		popup.button_count = popup.button_count + 1
		popup.button_icons[popup.button_count] = "buttonworkflow.bmp"
		popup.button_helps[popup.button_count] = "Undo checkout and revert to previous version"
		popup.button_titles[popup.button_count] = "Undo Checkout"
		buttons[popup.button_count] = "CANCELCHECKOUT"
	end if
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_vaccine_schedule.bmp"
	popup.button_helps[popup.button_count] = "Manage vaccine schedules"
	popup.button_titles[popup.button_count] = "Manage Schedules"
	buttons[popup.button_count] = "MANAGE"
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
	if button_pressed < 1 or button_pressed > popup.button_count then return 1
elseif popup.button_count = 1 then
	button_pressed = 1
else
	return 1
end if

CHOOSE CASE buttons[button_pressed]
	CASE "CHANGE"
		if lower(lstr_config_object_info.installed_version_status) = "checkedout" then
			ls_message = "The installed vaccine schedule is currently checked out.  Before changing the vaccine schedule you must either check the vaccine schedule back in or undo the checkout."
			openwithparm(w_pop_message, ls_message)
			return li_return_status
		end if
		li_sts = change_vaccine_schedule()
		if li_sts > li_return_status then li_return_status = li_sts
		return li_return_status
	CASE "CONFIGURE"
		if lb_installed and not lb_locally_owned then
			openwithparm(w_pop_message, "The currently installed vaccine schedule is not locally owned and is not editable.  Please install a locally owned schedule or make a copy of a schedule for local editing.")
			return li_return_status
		end if
		if lower(lstr_config_object_info.installed_version_status) = "checkedin" then
			openwithparm(w_pop_yes_no, "The Vaccine Schedule is not currently checked out for editing.  Do you wish to check it out now?")
			popup_return = message.powerobjectparm
			if popup_return.item <> "YES" then return li_return_status
			
			li_sts = f_check_out_config_object(lstr_config_object_info)
		end if

		f_configure_config_object(ls_config_object_id)
		return 2
	CASE "REVERT"
		li_sts = f_config_object_revert_version(ls_config_object_id, show_beta)
		return 2
	CASE "UPGRADE"
		li_sts = f_config_object_upgrade_version(ls_config_object_id, show_beta)
		return 2
	CASE "CHECKIN"
		li_sts = f_check_in_config_object(lstr_config_object_info)
		return 2
	CASE "CHECKOUT"
		li_sts = f_check_out_config_object(lstr_config_object_info)
		return 2
	CASE "CANCELCHECKOUT"
		li_sts = f_config_object_cancel_checkout(lstr_config_object_info.config_object_id)
		return 2
	CASE "MANAGE"
		lstr_pick_config_object.config_object_type = "Vaccine Schedule"
		lstr_pick_config_object.context_object = "General"
		lstr_pick_config_object.mode = "EDIT"
		
		openwithparm(lw_pick, lstr_pick_config_object, "w_pick_config_object")
	CASE "CANCEL"
		return li_return_status
	CASE ELSE
END CHOOSE

return li_return_status


end function

public function integer change_vaccine_schedule ();str_popup_return	popup_return
w_window_base lw_pick
str_pick_config_object lstr_pick_config_object
str_config_object_info lstr_config_object_info
long ll_domain_sequence
integer li_sts
string ls_config_object_id
long ll_version
string ls_message

lstr_pick_config_object.config_object_type = "Vaccine Schedule"
lstr_pick_config_object.context_object = "General"

openwithparm(lw_pick, lstr_pick_config_object, "w_pick_config_object")
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

ls_config_object_id = popup_return.items[1]

li_sts = f_get_config_object_info(ls_config_object_id, lstr_config_object_info)
if li_sts <= 0 then
	openwithparm(w_pop_message, "An error occured getting the config object info")
	return 1
end if

ls_message = "This operation will install the ~"" + lstr_config_object_info.description + "~" " + lower(lstr_config_object_info.config_object_type) + "."
ls_message += "  Do you wish to install the latest version of this " + lower(lstr_config_object_info.config_object_type) + "?"
openwithparm(w_pop_yes_no, ls_message)
popup_return = message.powerobjectparm
if popup_return.item = "YES" then
	ll_version = lstr_config_object_info.latest_version
else
	ll_version = f_config_object_pick_version(ls_config_object_id, true, "All")
	if isnull(ll_version) then return 1
	if ll_version < 0 then return 1
end if

openwithparm(w_pop_yes_no, "Are you sure you want to install version # " + string(ll_version) + " of the selected " + lstr_config_object_info.config_object_type + "?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return 1

li_sts = f_config_object_install(ls_config_object_id, ll_version)
if li_sts <= 0 then return 1

openwithparm(w_pop_message, "Changing the Vaccine Schedule has succeeded.")

return 2

end function

public subroutine refresh_label ();str_config_object_info lstr_vaccine_schedule

lstr_vaccine_schedule = common_thread.vaccine_schedule()

node.label = "Vaccine Schedule"
if lstr_vaccine_schedule.installed_version >= 0 then
	node.label += " - " + lstr_vaccine_schedule.description + ", v." + string(lstr_vaccine_schedule.installed_version)
end if

end subroutine

on u_configuration_node_vaccine_schedule.create
call super::create
end on

on u_configuration_node_vaccine_schedule.destroy
call super::destroy
end on

