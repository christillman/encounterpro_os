$PBExportHeader$w_workplan_step_definition.srw
forward
global type w_workplan_step_definition from w_window_base
end type
type st_flags_title from statictext within w_workplan_step_definition
end type
type st_in_office_flag from statictext within w_workplan_step_definition
end type
type st_in_office_flag_title from statictext within w_workplan_step_definition
end type
type st_workplan_title from statictext within w_workplan_step_definition
end type
type st_title_type from statictext within w_workplan_step_definition
end type
type st_results from statictext within w_workplan_step_definition
end type
type dw_workplan_items from u_dw_pick_list within w_workplan_step_definition
end type
type st_step_desc_title from statictext within w_workplan_step_definition
end type
type cb_add_service from commandbutton within w_workplan_step_definition
end type
type st_step_title from statictext within w_workplan_step_definition
end type
type st_type from statictext within w_workplan_step_definition
end type
type st_workplan from statictext within w_workplan_step_definition
end type
type st_step from statictext within w_workplan_step_definition
end type
type cb_add_treatment from commandbutton within w_workplan_step_definition
end type
type cb_add_workplan from commandbutton within w_workplan_step_definition
end type
type st_ordered_for_title from statictext within w_workplan_step_definition
end type
type st_criteria_title from statictext within w_workplan_step_definition
end type
type st_step_description_title from statictext within w_workplan_step_definition
end type
type st_step_description from statictext within w_workplan_step_definition
end type
type pb_up from u_picture_button within w_workplan_step_definition
end type
type pb_down from u_picture_button within w_workplan_step_definition
end type
type st_page from statictext within w_workplan_step_definition
end type
type st_title from statictext within w_workplan_step_definition
end type
type st_step_in_office_title from statictext within w_workplan_step_definition
end type
type st_step_in_office_flag from statictext within w_workplan_step_definition
end type
type cb_ok from commandbutton within w_workplan_step_definition
end type
type cb_cancel from commandbutton within w_workplan_step_definition
end type
end forward

global type w_workplan_step_definition from w_window_base
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_flags_title st_flags_title
st_in_office_flag st_in_office_flag
st_in_office_flag_title st_in_office_flag_title
st_workplan_title st_workplan_title
st_title_type st_title_type
st_results st_results
dw_workplan_items dw_workplan_items
st_step_desc_title st_step_desc_title
cb_add_service cb_add_service
st_step_title st_step_title
st_type st_type
st_workplan st_workplan
st_step st_step
cb_add_treatment cb_add_treatment
cb_add_workplan cb_add_workplan
st_ordered_for_title st_ordered_for_title
st_criteria_title st_criteria_title
st_step_description_title st_step_description_title
st_step_description st_step_description
pb_up pb_up
pb_down pb_down
st_page st_page
st_title st_title
st_step_in_office_title st_step_in_office_title
st_step_in_office_flag st_step_in_office_flag
cb_ok cb_ok
cb_cancel cb_cancel
end type
global w_workplan_step_definition w_workplan_step_definition

type variables
long workplan_id
string workplan_type
string workplan_in_office_flag
string step_in_office_flag

u_ds_data item_attributes

integer step_number

end variables

forward prototypes
public function integer save_changes ()
public function integer configure_service (long pl_row)
public function integer load_workplan_items ()
public function string step_in_office_flag (long pl_exclude_row)
public subroutine set_in_office_flag ()
public subroutine item_menu (long pl_row)
end prototypes

public function integer save_changes ();integer li_sts
long ll_rowcount
long ll_row
string ls_find
long ll_rowcount2
long ll_row2
string ls_find2
long i
long ll_item_number
long ll_deletedcount

// First, count the records in both datawindows
ll_rowcount = dw_workplan_items.rowcount()
ll_rowcount2 = item_attributes.rowcount()

// Update the workplan items
li_sts = dw_workplan_items.update()
if li_sts < 0 then return -1

// Before we update the attributes datastore, update the new item_number values

// Find the first workplan item with a negative temp_item_number
ls_find = "temp_item_number<0"
ll_row = dw_workplan_items.find(ls_find, 1, ll_rowcount)
DO WHILE ll_row > 0 and ll_row <= ll_rowcount
	// Construct a find string to find the item attributes with the found temp_item_number
	ls_find2 = "item_number=" + string(dw_workplan_items.object.temp_item_number[ll_row])
	
	// Find the first such attribute
	ll_row2 = item_attributes.find(ls_find2, 1, ll_rowcount2)
	DO WHILE ll_row2 > 0 and ll_row2 <= ll_rowcount2
		// Update the attribute with the newly assigned item_number
		item_attributes.object.item_number[ll_row2] = dw_workplan_items.object.item_number[ll_row]
		
		// Find the next attribute
		ll_row2 = item_attributes.find(ls_find2, ll_row2 + 1, ll_rowcount2 + 1)
	LOOP
	
	// Find the next workplan item with a negative temp_item_number
	ll_row = dw_workplan_items.find(ls_find, ll_row + 1, ll_rowcount + 1)
LOOP

// Delete the attributes which still don't have item_numbers
ls_find = "item_number<0"
ll_row = item_attributes.find(ls_find, 1, ll_rowcount2)
DO WHILE ll_row > 0 and ll_row <= ll_rowcount2
	item_attributes.deleterow(ll_row)
	ll_rowcount2 -= 1
	ll_row = item_attributes.find(ls_find, ll_row, ll_rowcount2 + 1)
LOOP

li_sts = item_attributes.update()
if li_sts < 0 then return -1

return 1


end function

public function integer configure_service (long pl_row);string ls_ordered_service
string ls_question
long ll_item_number
u_component_service luo_service
integer li_sts
string ls_filter
long i
long ll_rows
long ll_workplan_id
boolean lb_any_params
str_attributes lstr_attributes
str_popup_return popup_return

// Get the item number
ll_item_number = dw_workplan_items.object.item_number[pl_row]
if isnull(ll_item_number) then
	ll_item_number = dw_workplan_items.object.temp_item_number[pl_row]
	if isnull(ll_item_number) then
		log.log(this, "w_workplan_step_definition.configure_service.0019", "Item number is null", 4)
		item_attributes.setfilter("")
		item_attributes.filter()
		return -1
	end if
end if

//// Filter the attributes for the current item
ls_filter = "item_number=" + string(ll_item_number)
item_attributes.setfilter(ls_filter)
item_attributes.filter()

// Get the service component object
ls_ordered_service = dw_workplan_items.object.ordered_service[pl_row]
if isnull(ls_ordered_service) then
	log.log(this, "w_workplan_step_definition.configure_service.0019", "Null service", 4)
	item_attributes.setfilter("")
	item_attributes.filter()
	return -1
end if
luo_service = service_list.get_service_component(ls_ordered_service)
if isnull(luo_service) then
	log.log(this, "w_workplan_step_definition.configure_service.0019", "Error getting service component (" + ls_ordered_service + ")", 4)
	item_attributes.setfilter("")
	item_attributes.filter()
	return -1
end if


// Get the config params from the user
f_attribute_ds_to_str(item_attributes, lstr_attributes)
li_sts = luo_service.configure_service("Order", lstr_attributes)
if li_sts < 0 then
	item_attributes.setfilter("")
	item_attributes.filter()
	component_manager.destroy_component(luo_service)
	return li_sts
end if

// Copy the new config attributes to the attributes datastore
f_attribute_str_to_ds(lstr_attributes, item_attributes)

//// Check to see if this service has runtime parameters
//lb_any_params = luo_service.any_params("Runtime")
//
//if lb_any_params then
//	// Ask the user if they want to set the runtime attributes now.
//	ls_question = "This service has run-time parameters."
//	ls_question += "  If you do not specify the run-time parameters now then the user"
//	ls_question += " will be prompted for them when the service is performed."
//	ls_question += "  Do you wish to set the run-time parameters now?"
//	openwithparm(w_pop_yes_no, ls_question)
//	popup_return = message.powerobjectparm
//	if popup_return.item = "YES" then
//		// Get the config params from the user
//		li_sts = luo_service.configure_service("Runtime", lstr_attributes)
//		if li_sts <= 0 then
//			item_attributes.setfilter("")
//			item_attributes.filter()
//			component_manager.destroy_component(luo_service)
//			return li_sts
//		end if
//		
//		// Copy the new config attributes to the attributes datastore
//		f_attribute_str_to_ds(lstr_attributes, item_attributes)
//		dw_workplan_items.object.runtime_configured_flag[pl_row] = "Y"
//	end if
//end if

// Update the new description
dw_workplan_items.object.description[pl_row] = luo_service.description

// Add the keys to any new records
ll_rows = item_attributes.rowcount()
for i = 1 to ll_rows
	ll_workplan_id = item_attributes.object.workplan_id[i]
	if isnull(ll_workplan_id) then
		item_attributes.object.workplan_id[i] = workplan_id
		item_attributes.object.item_number[i] = ll_item_number
	end if
next

// Clear the filter
item_attributes.setfilter("")
item_attributes.filter()
component_manager.destroy_component(luo_service)

return 1

end function

public function integer load_workplan_items ();long ll_count
long i
string ls_room_name
string ls_room_id

SELECT workplan_type, description, in_office_flag
INTO :workplan_type, :st_workplan.text, :workplan_in_office_flag
FROM c_Workplan
WHERE workplan_id = :workplan_id;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then
	log.log(this, "w_workplan_step_definition.load_workplan_items.0012", "Workplan not found (" + string(workplan_id) + ")", 4)
	return -1
end if

if workplan_in_office_flag = "Y" then
	st_in_office_flag.text = "In Office"
else
	st_in_office_flag.text = "Out Of Office"
end if

st_type.text = workplan_type
st_step.text = string(step_number)

SELECT description
INTO :st_step_description.text
FROM c_Workplan_Step
WHERE workplan_id = :workplan_id
AND step_number = :step_number;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then
	log.log(this, "w_workplan_step_definition.load_workplan_items.0012", "Workplan step not found (" + string(workplan_id) + ", " + string(step_number) + ")", 4)
	return -1
end if

ll_count = dw_workplan_items.retrieve(workplan_id, step_number)
ll_count = item_attributes.retrieve(workplan_id)

dw_workplan_items.set_page(1, pb_up, pb_down, st_page)

set_in_office_flag()

return 1

end function

public function string step_in_office_flag (long pl_exclude_row);long ll_i_count
string ls_in_office_flag
string ls_step_flag
string ls_error
boolean lb_in_office_found
boolean lb_out_of_office_found
long i
string ls_step_in_office_flag

ll_i_count = dw_workplan_items.rowcount()

for i = 1 to ll_i_count
	if i = pl_exclude_row then continue
	ls_in_office_flag = dw_workplan_items.object.in_office_flag[i]
	ls_step_flag = dw_workplan_items.object.step_flag[i]

	if ls_in_office_flag = "W" then ls_in_office_flag = workplan_in_office_flag

	if ls_in_office_flag = "Y" then
		lb_in_office_found = true
	elseif ls_step_flag = "Y" then
		lb_out_of_office_found = true
	end if
next

if lb_out_of_office_found then
	ls_step_in_office_flag = "N"
	st_step_in_office_flag.text = "Out Of Office"
elseif lb_in_office_found then
	ls_step_in_office_flag = "Y"
	st_step_in_office_flag.text = "In Office"
elseif workplan_in_office_flag = "Y" then
	ls_step_in_office_flag = "X"
	st_step_in_office_flag.text = "Unknown"
else
	ls_step_in_office_flag = "N"
	st_step_in_office_flag.text = "Out Of Office"
end if

if workplan_in_office_flag = "N" and lb_in_office_found then
	ls_error = "This is an out-of-office workplan and this step contains in-office items."
	ls_error += "  That is not allowed.  Please edit or remove items so that this step"
	ls_error += " contains only out-of-office items."
	openwithparm(w_pop_message, ls_error)
elseif lb_in_office_found and lb_out_of_office_found then
	ls_error = "This workplan step contains out-of-office items which are configured to be part of the step"
	ls_error += " completion.  By definition, that makes this step an out-of-office step and in-office items"
	ls_error += " are not allowed on this or subsequent steps.  Please edit the items to remove the conflict."
	openwithparm(w_pop_message, ls_error)
end if

return ls_step_in_office_flag

end function

public subroutine set_in_office_flag ();long ll_exclude_row

setnull(ll_exclude_row)

step_in_office_flag = step_in_office_flag(ll_exclude_row)

//if step_in_office_flag = "N" then
//	st_step_in_office_flag.text = "Out Of Office"
//elseif step_in_office_flag = "Y" then
//	st_step_in_office_flag.text = "In Office"
//elseif step_in_office_flag = "X" then
//	st_step_in_office_flag.text = "Unknown"
//end if
//
//
end subroutine

public subroutine item_menu (long pl_row);u_component_service luo_service
str_popup popup
str_popup_return popup_return
string lsa_buttons[]
integer li_button_pressed, li_sts, li_service_count
window lw_pop_buttons
string ls_user_id
integer li_update_flag
string ls_temp
string ls_null
string ls_description
string ls_ordered_service
string ls_ordered_treatment_type
string ls_item_type
string ls_followup_flag
u_user luo_user
str_workplan_item_criteria lstr_criteria

setnull(ls_null)

ls_item_type = dw_workplan_items.object.item_type[pl_row]
ls_followup_flag = dw_workplan_items.object.followup_flag[pl_row]

if ls_item_type = 'Service' or ls_item_type = 'Treatment' then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit Description"
	popup.button_titles[popup.button_count] = "Edit Description"
	lsa_buttons[popup.button_count] = "DESCRIPTION"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button10.bmp"
	popup.button_helps[popup.button_count] = "Edit Ordered For"
	popup.button_titles[popup.button_count] = "Ordered For"
	lsa_buttons[popup.button_count] = "FOR"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit Item Criteria"
	popup.button_titles[popup.button_count] = "Edit Criteria"
	lsa_buttons[popup.button_count] = "EDIT"
end if

if ls_followup_flag = "Y" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button14.bmp"
	popup.button_helps[popup.button_count] = "Edit Followup Workplan"
	popup.button_titles[popup.button_count] = "Followup Workplan"
	lsa_buttons[popup.button_count] = "FOLLOWUP"
end if

if ls_item_type = 'Service' then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Configure Service"
	popup.button_titles[popup.button_count] = "Configure Service"
	lsa_buttons[popup.button_count] = "CONFIG"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit Item Flags"
	popup.button_titles[popup.button_count] = "Edit Flags"
	lsa_buttons[popup.button_count] = "FLAGS"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit Timeout Criteria"
	popup.button_titles[popup.button_count] = "Timeout"
	lsa_buttons[popup.button_count] = "TIMEOUT"
end if

if pl_row > 1 then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonup.bmp"
	popup.button_helps[popup.button_count] = "Move Item Up"
	popup.button_titles[popup.button_count] = "Move Up"
	lsa_buttons[popup.button_count] = "UP"
end if

if pl_row < dw_workplan_items.rowcount() then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttondn.bmp"
	popup.button_helps[popup.button_count] = "Move Item Down"
	popup.button_titles[popup.button_count] = "Move Down"
	lsa_buttons[popup.button_count] = "DOWN"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Delete Workplan Item"
	popup.button_titles[popup.button_count] = "Delete Item"
	lsa_buttons[popup.button_count] = "DELETE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	lsa_buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	li_button_pressed = message.doubleparm
	if li_button_pressed < 1 or li_button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	li_button_pressed = 1
else
	return
end if

CHOOSE CASE lsa_buttons[li_button_pressed]
	CASE "DESCRIPTION"
		if ls_item_type = 'Service' then
			ls_ordered_service = dw_workplan_items.object.ordered_service[pl_row]
			ls_description = datalist.service_description(ls_ordered_service)
			popup.title = "Enter description for '" + ls_description + "' service"
		elseif ls_item_type = 'Treatment' then
			ls_ordered_treatment_type = dw_workplan_items.object.ordered_treatment_type[pl_row]
			ls_description = datalist.treatment_type_description(ls_ordered_treatment_type)
			popup.title = "Enter description for '" + ls_description + "' treatment"
		else
			return
		end if
		popup.item = dw_workplan_items.object.description[pl_row]
		openwithparm(w_pop_prompt_string, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		dw_workplan_items.object.description[pl_row] = popup_return.items[1]
	CASE "EDIT"
		lstr_criteria.criteria_title = dw_workplan_items.object.description[pl_row]
		lstr_criteria.new_flag = dw_workplan_items.object.new_flag[pl_row]
		lstr_criteria.sex = dw_workplan_items.object.sex[pl_row]
		lstr_criteria.age_range_id = dw_workplan_items.object.age_range_id[pl_row]
		lstr_criteria.modes = dw_workplan_items.object.modes[pl_row]
		lstr_criteria.workplan_owner = dw_workplan_items.object.workplan_owner[pl_row]
		lstr_criteria.abnormal_flag = dw_workplan_items.object.abnormal_flag[pl_row]
		lstr_criteria.severity = dw_workplan_items.object.severity[pl_row]
		openwithparm(w_workplan_criteria, lstr_criteria)
		lstr_criteria = message.powerobjectparm
		dw_workplan_items.object.new_flag[pl_row] = lstr_criteria.new_flag
		dw_workplan_items.object.sex[pl_row] = lstr_criteria.sex
		dw_workplan_items.object.age_range_id[pl_row] = lstr_criteria.age_range_id
		dw_workplan_items.object.modes[pl_row] = lstr_criteria.modes
		dw_workplan_items.object.workplan_owner[pl_row] = lstr_criteria.workplan_owner
		dw_workplan_items.object.abnormal_flag[pl_row] = lstr_criteria.abnormal_flag
		dw_workplan_items.object.severity[pl_row] = lstr_criteria.severity
	CASE "CONFIG"
		configure_service(pl_row)
	CASE "FLAGS"
		popup.data_row_count = 9
		popup.title = dw_workplan_items.object.description[pl_row]
		popup.item = workplan_in_office_flag
		popup.items[1] = dw_workplan_items.object.in_office_flag[pl_row]
		popup.items[2] = string(dw_workplan_items.object.priority[pl_row])
		popup.items[3] = dw_workplan_items.object.step_flag[pl_row]
		popup.items[4] = dw_workplan_items.object.auto_perform_flag[pl_row]
		popup.items[5] = dw_workplan_items.object.cancel_workplan_flag[pl_row]
		popup.items[6] = dw_workplan_items.object.consolidate_flag[pl_row]
		popup.items[7] = dw_workplan_items.object.owner_flag[pl_row]
		popup.items[8] = dw_workplan_items.object.observation_tag[pl_row]
		popup.items[9] = step_in_office_flag(pl_row)
		openwithparm(w_workplan_item_flags, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 8 then return
		dw_workplan_items.object.in_office_flag[pl_row] = popup_return.items[1]
		dw_workplan_items.object.priority[pl_row] = integer(popup_return.items[2])
		dw_workplan_items.object.step_flag[pl_row] = popup_return.items[3]
		dw_workplan_items.object.auto_perform_flag[pl_row] = popup_return.items[4]
		dw_workplan_items.object.cancel_workplan_flag[pl_row] = popup_return.items[5]
		dw_workplan_items.object.consolidate_flag[pl_row] = popup_return.items[6]
		dw_workplan_items.object.owner_flag[pl_row] = popup_return.items[7]
		dw_workplan_items.object.observation_tag[pl_row] = popup_return.items[8]
		set_in_office_flag()
	CASE "TIMEOUT"
		popup.data_row_count = 4
		popup.title = dw_workplan_items.object.description[pl_row]
		popup.items[1] = string(dw_workplan_items.object.escalation_time[pl_row])
		popup.items[2] = dw_workplan_items.object.escalation_unit_id[pl_row]
		popup.items[3] = string(dw_workplan_items.object.expiration_time[pl_row])
		popup.items[4] = dw_workplan_items.object.expiration_unit_id[pl_row]
		openwithparm(w_workplan_item_timeout, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 4 then return
		dw_workplan_items.object.escalation_time[pl_row] = long(popup_return.items[1])
		dw_workplan_items.object.escalation_unit_id[pl_row] = popup_return.items[2]
		dw_workplan_items.object.expiration_time[pl_row] = long(popup_return.items[3])
		dw_workplan_items.object.expiration_unit_id[pl_row] = popup_return.items[4]
	CASE "FOR"
		luo_user = user_list.pick_user(true, true, true)
		if isnull(luo_user) then return
		dw_workplan_items.object.ordered_for[pl_row] = luo_user.user_id
		// If it's a role then fill in the role name
		if left(luo_user.user_id, 1) = "!" then
			dw_workplan_items.object.role_name[pl_row] = luo_user.user_full_name
			dw_workplan_items.object.role_color[pl_row] = luo_user.color
			dw_workplan_items.object.user_short_name[pl_row] = ls_null
		else
			// Otherwise fill in the user name
			if len(luo_user.user_short_name) > 0 then
				dw_workplan_items.object.user_short_name[pl_row] = luo_user.user_short_name
			else
				dw_workplan_items.object.user_short_name[pl_row] = left(luo_user.user_full_name, 12)
			end if
			dw_workplan_items.object.user_color[pl_row] = luo_user.color
			dw_workplan_items.object.role_name[pl_row] = ls_null
		end if
	CASE "FOLLOWUP"
	CASE "UP"
		dw_workplan_items.object.sort_sequence[pl_row] = pl_row - 1
		dw_workplan_items.object.sort_sequence[pl_row - 1] = pl_row
		dw_workplan_items.sort()
	CASE "DOWN"
		dw_workplan_items.object.sort_sequence[pl_row] = pl_row + 1
		dw_workplan_items.object.sort_sequence[pl_row + 1] = pl_row
		dw_workplan_items.sort()
	CASE "DELETE"
		ls_temp = "Are you sure you wish to delete the workplan item '" + dw_workplan_items.object.description[pl_row] + "'?"
		openwithparm(w_pop_yes_no, ls_temp)
		popup_return = message.powerobjectparm
		if popup_return.item = "YES" then
			dw_workplan_items.deleterow(pl_row)
			set_in_office_flag()
		end if
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return


end subroutine

event open;call super::open;str_popup popup
integer li_sts

popup = message.powerobjectparm

dw_workplan_items.settransobject(sqlca)

item_attributes = CREATE u_ds_data
item_attributes.set_dataobject("dw_workplan_item_attribute_data")

if popup.data_row_count <> 2 then
	log.log(this, "w_workplan_step_definition.open.0012", "Invalid parameters", 4)
	close(this)
	return
end if

workplan_id = long(popup.items[1])

if isnull(workplan_id) then
	log.log(this, "w_workplan_step_definition.open.0012", "Null workplan_id", 4)
	close(this)
	return
end if

step_number = long(popup.items[2])

if isnull(workplan_id) then
	log.log(this, "w_workplan_step_definition.open.0012", "Null step_number", 4)
	close(this)
	return
end if

postevent("post_open")

end event

on w_workplan_step_definition.create
int iCurrent
call super::create
this.st_flags_title=create st_flags_title
this.st_in_office_flag=create st_in_office_flag
this.st_in_office_flag_title=create st_in_office_flag_title
this.st_workplan_title=create st_workplan_title
this.st_title_type=create st_title_type
this.st_results=create st_results
this.dw_workplan_items=create dw_workplan_items
this.st_step_desc_title=create st_step_desc_title
this.cb_add_service=create cb_add_service
this.st_step_title=create st_step_title
this.st_type=create st_type
this.st_workplan=create st_workplan
this.st_step=create st_step
this.cb_add_treatment=create cb_add_treatment
this.cb_add_workplan=create cb_add_workplan
this.st_ordered_for_title=create st_ordered_for_title
this.st_criteria_title=create st_criteria_title
this.st_step_description_title=create st_step_description_title
this.st_step_description=create st_step_description
this.pb_up=create pb_up
this.pb_down=create pb_down
this.st_page=create st_page
this.st_title=create st_title
this.st_step_in_office_title=create st_step_in_office_title
this.st_step_in_office_flag=create st_step_in_office_flag
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_flags_title
this.Control[iCurrent+2]=this.st_in_office_flag
this.Control[iCurrent+3]=this.st_in_office_flag_title
this.Control[iCurrent+4]=this.st_workplan_title
this.Control[iCurrent+5]=this.st_title_type
this.Control[iCurrent+6]=this.st_results
this.Control[iCurrent+7]=this.dw_workplan_items
this.Control[iCurrent+8]=this.st_step_desc_title
this.Control[iCurrent+9]=this.cb_add_service
this.Control[iCurrent+10]=this.st_step_title
this.Control[iCurrent+11]=this.st_type
this.Control[iCurrent+12]=this.st_workplan
this.Control[iCurrent+13]=this.st_step
this.Control[iCurrent+14]=this.cb_add_treatment
this.Control[iCurrent+15]=this.cb_add_workplan
this.Control[iCurrent+16]=this.st_ordered_for_title
this.Control[iCurrent+17]=this.st_criteria_title
this.Control[iCurrent+18]=this.st_step_description_title
this.Control[iCurrent+19]=this.st_step_description
this.Control[iCurrent+20]=this.pb_up
this.Control[iCurrent+21]=this.pb_down
this.Control[iCurrent+22]=this.st_page
this.Control[iCurrent+23]=this.st_title
this.Control[iCurrent+24]=this.st_step_in_office_title
this.Control[iCurrent+25]=this.st_step_in_office_flag
this.Control[iCurrent+26]=this.cb_ok
this.Control[iCurrent+27]=this.cb_cancel
end on

on w_workplan_step_definition.destroy
call super::destroy
destroy(this.st_flags_title)
destroy(this.st_in_office_flag)
destroy(this.st_in_office_flag_title)
destroy(this.st_workplan_title)
destroy(this.st_title_type)
destroy(this.st_results)
destroy(this.dw_workplan_items)
destroy(this.st_step_desc_title)
destroy(this.cb_add_service)
destroy(this.st_step_title)
destroy(this.st_type)
destroy(this.st_workplan)
destroy(this.st_step)
destroy(this.cb_add_treatment)
destroy(this.cb_add_workplan)
destroy(this.st_ordered_for_title)
destroy(this.st_criteria_title)
destroy(this.st_step_description_title)
destroy(this.st_step_description)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.st_page)
destroy(this.st_title)
destroy(this.st_step_in_office_title)
destroy(this.st_step_in_office_flag)
destroy(this.cb_ok)
destroy(this.cb_cancel)
end on

event post_open;call super::post_open;integer li_sts

li_sts = load_workplan_items()
if li_sts <= 0 then
	log.log(this, "w_workplan_step_definition.open.0012", "Error loading workplan items (" + string(workplan_id) + ", " + string(step_number) + ")", 4)
	close(this)
	return
end if


end event

type pb_epro_help from w_window_base`pb_epro_help within w_workplan_step_definition
boolean visible = true
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_workplan_step_definition
end type

type st_flags_title from statictext within w_workplan_step_definition
integer x = 2409
integer y = 620
integer width = 206
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Flags"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_in_office_flag from statictext within w_workplan_step_definition
integer x = 2048
integer y = 180
integer width = 608
integer height = 96
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Out Of Office"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_in_office_flag_title from statictext within w_workplan_step_definition
integer x = 1472
integer y = 188
integer width = 567
integer height = 76
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Workplan Where:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_workplan_title from statictext within w_workplan_step_definition
integer x = 105
integer y = 300
integer width = 398
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Workplan:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_title_type from statictext within w_workplan_step_definition
integer x = 32
integer y = 188
integer width = 471
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Workplan Type:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_results from statictext within w_workplan_step_definition
integer x = 78
integer y = 572
integer width = 174
integer height = 116
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Item Type"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_workplan_items from u_dw_pick_list within w_workplan_step_definition
integer x = 78
integer y = 688
integer width = 2638
integer height = 820
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_workplan_item_list"
boolean livescroll = false
end type

event selected;call super::selected;item_menu(selected_row)
clear_selected()


end event

type st_step_desc_title from statictext within w_workplan_step_definition
integer x = 251
integer y = 620
integer width = 974
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Description"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_add_service from commandbutton within w_workplan_step_definition
integer x = 608
integer y = 1588
integer width = 498
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add Service"
end type

event clicked;str_popup popup
str_popup_return popup_return
long ll_row
integer li_sts
long ll_item_number
long ll_lowest_item_number
long i
string ls_service
string ls_description
string ls_context_object

CHOOSE CASE workplan_type
	CASE "Followup"
		ls_context_object = "Encounter"
		popup.dataobject = "dw_service_for_followup_workplan"
	CASE "Referral"
		ls_context_object = "Encounter"
		popup.dataobject = "dw_service_for_referral_workplan"
	CASE ELSE
		ls_context_object = wordcap(workplan_type)
END CHOOSE

openwithparm(w_pick_service, ls_context_object)
ls_service = message.stringparm
if isnull(ls_service) then return

ls_description = datalist.service_description(ls_service)
if isnull(ls_description) then
	log.log(this, "w_workplan_step_definition.cb_add_service.clicked.0029", "Invalid service (" + ls_service + ")", 4)
	return
end if

// First, find the lowest temporary item number
ll_lowest_item_number = 0
for i = 1 to dw_workplan_items.rowcount()
	ll_item_number = dw_workplan_items.object.temp_item_number[i]
	if ll_item_number < ll_lowest_item_number then
		ll_lowest_item_number = ll_item_number
	end if
next

// Decrement the lowest item_number to make sure it's unique
ll_lowest_item_number -= 1


dw_workplan_items.setredraw(false)

// Add the new service
ll_row = dw_workplan_items.insertrow(0)
dw_workplan_items.object.workplan_id[ll_row] = workplan_id
dw_workplan_items.object.temp_item_number[ll_row] = ll_lowest_item_number
dw_workplan_items.object.step_number[ll_row] = step_number
dw_workplan_items.object.item_type[ll_row] = 'Service'
dw_workplan_items.object.ordered_service[ll_row] = ls_service
dw_workplan_items.object.description[ll_row] = ls_description
dw_workplan_items.object.service_description[ll_row] = ls_description
if step_in_office_flag = "X" then
	dw_workplan_items.object.in_office_flag[ll_row] = workplan_in_office_flag
else
	dw_workplan_items.object.in_office_flag[ll_row] = step_in_office_flag
end if
dw_workplan_items.object.step_flag[ll_row] = 'Y'
dw_workplan_items.object.owner_flag[ll_row] = datalist.service_owner_flag(ls_service)
dw_workplan_items.object.auto_perform_flag[ll_row] = 'N'
dw_workplan_items.object.sort_sequence[ll_row] = ll_row

li_sts = configure_service(ll_row)
if li_sts <= 0 then dw_workplan_items.deleterow(ll_row)
dw_workplan_items.set_page(1, pb_up, pb_down, st_page)

dw_workplan_items.setredraw(true)

set_in_office_flag()

end event

type st_step_title from statictext within w_workplan_step_definition
integer x = 96
integer y = 408
integer width = 407
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Step number:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_type from statictext within w_workplan_step_definition
event clicked pbm_bnclicked
integer x = 512
integer y = 180
integer width = 946
integer height = 96
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_workplan from statictext within w_workplan_step_definition
event clicked pbm_bnclicked
integer x = 512
integer y = 288
integer width = 2144
integer height = 96
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_step from statictext within w_workplan_step_definition
event clicked pbm_bnclicked
integer x = 512
integer y = 396
integer width = 187
integer height = 96
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type cb_add_treatment from commandbutton within w_workplan_step_definition
integer x = 1193
integer y = 1588
integer width = 498
integer height = 108
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add Treatment"
end type

event clicked;str_popup popup
str_popup_return popup_return
long ll_row
u_component_treatment luo_treatment_component
integer li_sts
long ll_item_number
long ll_lowest_item_number
long i
long j
long ll_row2
string ls_treatment_type

if step_in_office_flag = "N" then
	popup.dataobject = "dw_not_in_office_treatment_type_pick"
else
	popup.dataobject = "dw_treatment_type_edit_list"
end if
popup.datacolumn = 2
popup.displaycolumn = 4
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_treatment_type = popup_return.items[1]
if isnull(ls_treatment_type) then return 0

luo_treatment_component = f_get_treatment_component(ls_treatment_type)
if isnull(luo_treatment_component) then
	log.log(this, "w_workplan_step_definition.cb_add_service.clicked.0029", "Unable to get treatment object (" + ls_treatment_type + ")", 4)
	return
end if

li_sts = luo_treatment_component.define_treatment()
if li_sts <= 0 then
	component_manager.destroy_component(luo_treatment_component)
	return
end if

// First, find the lowest temporary item number
ll_lowest_item_number = 0
for i = 1 to dw_workplan_items.rowcount()
	ll_item_number = dw_workplan_items.object.temp_item_number[i]
	if ll_item_number < ll_lowest_item_number then
		ll_lowest_item_number = ll_item_number
	end if
next

for i = 1 to luo_treatment_component.treatment_count
	// Decrement the lowest item_number to make sure it's unique
	ll_lowest_item_number -= 1
	ll_row = dw_workplan_items.insertrow(0)
	dw_workplan_items.object.workplan_id[ll_row] = workplan_id
	dw_workplan_items.object.temp_item_number[ll_row] = ll_lowest_item_number
	dw_workplan_items.object.step_number[ll_row] = step_number
	dw_workplan_items.object.item_type[ll_row] = 'Treatment'
	dw_workplan_items.object.ordered_treatment_type[ll_row] = ls_treatment_type
	dw_workplan_items.object.description[ll_row] = luo_treatment_component.treatment_definition[i].item_description
	dw_workplan_items.object.treatment_type_description[ll_row] = datalist.treatment_type_description(ls_treatment_type)
	if step_in_office_flag = "X" then
		dw_workplan_items.object.in_office_flag[ll_row] = workplan_in_office_flag
	else
		dw_workplan_items.object.in_office_flag[ll_row] = step_in_office_flag
	end if
	dw_workplan_items.object.sort_sequence[ll_row] = ll_row
	for j = 1 to luo_treatment_component.treatment_definition[i].attribute_count
		ll_row2 = item_attributes.insertrow(0)
		item_attributes.object.workplan_id[ll_row2] = workplan_id
		item_attributes.object.item_number[ll_row2] = ll_lowest_item_number
		item_attributes.object.attribute[ll_row2] = luo_treatment_component.treatment_definition[i].attribute[j]
		item_attributes.object.value[ll_row2] = luo_treatment_component.treatment_definition[i].value[j]
	next
next
dw_workplan_items.set_page(1, pb_up, pb_down, st_page)

component_manager.destroy_component(luo_treatment_component)

set_in_office_flag()

end event

type cb_add_workplan from commandbutton within w_workplan_step_definition
integer x = 1778
integer y = 1588
integer width = 498
integer height = 108
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add Workplan"
end type

event clicked;str_popup popup
str_popup_return popup_return
long ll_row
integer li_sts
long ll_item_number
long ll_lowest_item_number
long i
string ls_new_workplan_type
long ll_new_workplan_id
string ls_description
string ls_in_office_flag

// Select a workplan type
popup.dataobject = "dw_compatible_workplan_list"
popup.datacolumn = 1
popup.displaycolumn = 1
popup.argument_count = 1
popup.argument[1] = workplan_type
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_new_workplan_type = popup_return.items[1]

// Then select a workplan
popup.dataobject = "dw_workplan_of_type_pick_list"
popup.title = "Select Treatment Component"
popup.datacolumn = 1
popup.displaycolumn = 3
popup.argument_count = 1
popup.argument[1] = ls_new_workplan_type

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ll_new_workplan_id = long(popup_return.items[1])
ls_description = popup_return.descriptions[1]

SELECT in_office_flag
INTO :ls_in_office_flag
FROM c_Workplan
WHERE workplan_id = :ll_new_workplan_id;
if not tf_check() then return

if isnull(ls_in_office_flag) then ls_in_office_flag = "N"

if step_in_office_flag = "N" and ls_in_office_flag = "Y" then
	// We can't put an in-office treatment into a not-in-office workplan
	openwithparm(w_pop_message, "You may not add an 'In-Office' workplan to an 'Out-Of-Office' workplan step")
	return
end if

// First, find the lowest temporary item number
ll_lowest_item_number = 0
for i = 1 to dw_workplan_items.rowcount()
	ll_item_number = dw_workplan_items.object.temp_item_number[i]
	if ll_item_number < ll_lowest_item_number then
		ll_lowest_item_number = ll_item_number
	end if
next

// Decrement the lowest item_number to make sure it's unique
ll_lowest_item_number -= 1
ll_row = dw_workplan_items.insertrow(0)
dw_workplan_items.object.workplan_id[ll_row] = workplan_id
dw_workplan_items.object.temp_item_number[ll_row] = ll_lowest_item_number
dw_workplan_items.object.step_number[ll_row] = step_number
dw_workplan_items.object.item_type[ll_row] = 'Workplan'
dw_workplan_items.object.ordered_workplan_id[ll_row] = ll_new_workplan_id
dw_workplan_items.object.description[ll_row] = ls_description
dw_workplan_items.object.in_office_flag[ll_row] = ls_in_office_flag
dw_workplan_items.object.sort_sequence[ll_row] = ll_row

dw_workplan_items.set_page(1, pb_up, pb_down, st_page)

set_in_office_flag()

end event

type st_ordered_for_title from statictext within w_workplan_step_definition
integer x = 1262
integer y = 620
integer width = 315
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Ordered For"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_criteria_title from statictext within w_workplan_step_definition
integer x = 1851
integer y = 620
integer width = 315
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Criteria"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_step_description_title from statictext within w_workplan_step_definition
integer x = 727
integer y = 408
integer width = 398
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Description:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_step_description from statictext within w_workplan_step_definition
event clicked pbm_bnclicked
integer x = 1134
integer y = 396
integer width = 1522
integer height = 96
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type pb_up from u_picture_button within w_workplan_step_definition
integer x = 2729
integer y = 688
integer width = 137
integer height = 116
integer taborder = 30
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;integer li_page

li_page = dw_workplan_items.current_page

dw_workplan_items.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from u_picture_button within w_workplan_step_definition
integer x = 2729
integer y = 820
integer width = 137
integer height = 116
integer taborder = 30
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;integer li_page
integer li_last_page

li_page = dw_workplan_items.current_page
li_last_page = dw_workplan_items.last_page

dw_workplan_items.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type st_page from statictext within w_workplan_step_definition
integer x = 2587
integer y = 620
integer width = 288
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Page 99/99"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_title from statictext within w_workplan_step_definition
integer width = 2926
integer height = 144
integer textsize = -24
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Workplan Step Definition"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_step_in_office_title from statictext within w_workplan_step_definition
integer x = 1614
integer y = 516
integer width = 425
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Step Where:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_step_in_office_flag from statictext within w_workplan_step_definition
event clicked pbm_bnclicked
integer x = 2048
integer y = 504
integer width = 608
integer height = 96
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type cb_ok from commandbutton within w_workplan_step_definition
integer x = 2464
integer y = 1676
integer width = 402
integer height = 112
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;str_popup_return popup_return
integer li_sts


li_sts = save_changes()
if li_sts <= 0 then return

// Return a count of the number of items
popup_return.item_count = 1
popup_return.items[1] = string(dw_workplan_items.rowcount())

closewithreturn(parent, popup_return)


end event

type cb_cancel from commandbutton within w_workplan_step_definition
integer x = 46
integer y = 1676
integer width = 402
integer height = 112
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;str_popup_return popup_return

setnull(popup_return.item)
popup_return.item_count = 0
closewithreturn(parent, popup_return)


end event

