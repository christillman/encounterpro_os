$PBExportHeader$u_room_status.sru
forward
global type u_room_status from u_dw_pick_list
end type
end forward

global type u_room_status from u_dw_pick_list
integer width = 2414
integer height = 1704
string dataobject = "dw_room_status"
boolean vscrollbar = true
boolean select_computed = false
end type
global u_room_status u_room_status

type variables
string room_id
string room_type

long patient_count

boolean include_age

end variables

forward prototypes
public function integer patient_menu (long pl_row)
public function integer refresh ()
public function integer initialize (string ps_room_id)
end prototypes

public function integer patient_menu (long pl_row);integer li_sts
string ls_cpr_id
long ll_encounter_id

ls_cpr_id = object.cpr_id[pl_row]
ll_encounter_id = object.encounter_id[pl_row]

// Set the patient context
li_sts = f_set_patient(ls_cpr_id)
if li_sts < 0 then return -1

li_sts = f_set_current_encounter(ll_encounter_id)
if li_sts <= 0 then
	log.log(this, "u_room_status.patient_menu.0014", "Error setting encounter", 4)
	f_clear_patient()
	return -1
end if

// Display the room-specific menu
li_sts = f_display_context_menu("Room", room_id)

// If no room-specific menu was found, then try displaying the menu for the room_type
if li_sts = 0 then li_sts = f_display_context_menu("Room Type", room_type)

// Clear the patient context
f_clear_patient()

return 1


end function

public function integer refresh ();long			ll_row
String		ls_temp
string		ls_description
string		ls_owned_by
Long			ll_patient_color
long			ll_service_color
string ls_user_id
string ls_pretty_name
long i
long j
long ll_days
long ll_minutes
long ll_first_row_on_page
long ll_last_row_on_page
long ll_new_first_row_on_page
long ll_last
string ls_result
string ls_age
integer li_display_priority

str_encounter_list lstr_encounters
str_wp_item_list lstr_services
str_room lstr_room

// remember the first row on page
ll_first_row_on_page = long(object.DataWindow.FirstRowOnPage)

setredraw(false)
reset()

// Get the latest room_status
lstr_room = datalist.office_room(room_id)

// See if there are any patients in this room
lstr_encounters = datalist.office_room_encounters(room_id)
// Loop through the open encounters
for i = 1 to lstr_encounters.encounter_count
	// We found a patient encounter so increment the count
	patient_count += 1
	
	// get the color of the attending doctor
	ll_patient_color = user_list.user_color(lstr_encounters.encounter[i].attending_doctor)
	if isnull(ll_patient_color) or ll_patient_color = 0 then ll_patient_color = color_object
	
	lstr_services = datalist.office_encounter_services(lstr_encounters.encounter[i].cpr_id, lstr_encounters.encounter[i].encounter_id)
	if lstr_services.wp_item_count > 0 then
		// Loop through the active services and put in a row for each one
		for j = 1 to lstr_services.wp_item_count
			ll_row = insertrow(0)
			object.cpr_id[ll_row] = lstr_encounters.encounter[i].cpr_id
			object.encounter_id[ll_row] = lstr_encounters.encounter[i].encounter_id
			if j = 1 then
				object.document_status[ll_row] = lstr_encounters.encounter[i].document_status
			end if
			
			ls_pretty_name = lstr_encounters.encounter[i].patient_name
			
			if include_age then
				ls_age = f_pretty_age_short(lstr_encounters.encounter[i].date_of_birth, today())
				if len(ls_age) > 0 then
					ls_pretty_name += " - " + ls_age
				end if
			end if				

			if date(lstr_encounters.encounter[i].encounter_date) = today() then
				ll_minutes = secondsafter(time(lstr_encounters.encounter[i].encounter_date), now()) / 60
				if ll_minutes >= 0 then
					ls_pretty_name += " (" + string(ll_minutes) + ")"
				end if
			else
				ll_days = daysafter(date(lstr_encounters.encounter[i].encounter_date), today())
				ls_pretty_name += " (" + string(ll_days) + " days)"
			end if
			object.pretty_name[ll_row] = ls_pretty_name
			
			object.patient_workplan_item_id[ll_row] = lstr_services.wp_item[j].patient_workplan_item_id

			ls_owned_by = lstr_services.wp_item[j].owned_by
			object.owned_by[ll_row] = ls_owned_by
			
			ls_description = lstr_services.wp_item[j].description
			
			ls_user_id = lstr_services.wp_item[j].user_id
			if not isnull(ls_user_id) then
				object.alert_color[ll_row] = color_text_normal
			end if

			if lstr_services.wp_item[j].escalation_date < datetime(today(), now()) then
				object.alert_color[ll_row] = color_text_error
			end if

			if len(lstr_services.wp_item[j].observation_id) > 0 and not isnull(lstr_services.wp_item[j].result_sequence) then
				ls_description += ":  "
				
				ls_result = f_pretty_result( lstr_services.wp_item[j].result, &
														lstr_services.wp_item[j].location, &
														lstr_services.wp_item[j].location_description, &
														lstr_services.wp_item[j].result_value, &
														lstr_services.wp_item[j].result_unit, &
														lstr_services.wp_item[j].result_amount_flag, &
														lstr_services.wp_item[j].print_result_flag, &
														lstr_services.wp_item[j].print_result_separator, &
														lstr_services.wp_item[j].abnormal_flag, &
														lstr_services.wp_item[j].unit_preference, &
														lstr_services.wp_item[j].display_mask, &
														false, &
														false, &
														true )
				
				if len(ls_result) > 0 then
					ls_description += ls_result
				else
					ls_description += "No Results"
				end if
				
				if upper(lstr_services.wp_item[j].abnormal_flag) = "Y" then
					object.alert_color[ll_row] = color_text_error
				end if
			else
				if user_list.is_user(ls_owned_by) then
					ls_temp = user_list.user_initial(ls_owned_by)
					if ls_temp <> "" then
						ls_description += " <" + ls_temp + ">"
					end if
				end if
			
				ll_minutes = lstr_services.wp_item[j].minutes
				object.minutes[ll_row] = ll_minutes
				if ll_minutes >= 0 then
					ls_description += "  (" + String(ll_minutes) + ")"
				end if
			end if

			object.description[ll_row] = ls_description
			
			ll_service_color = user_list.user_color(ls_owned_by)
			if isnull(ll_service_color) or ll_service_color = 0 then ll_service_color = color_object

			object.patient_color[ll_row] = ll_patient_color
			object.service_color[ll_row] = ll_service_color
			
			// Test the bitmap display
			//lstr_services.wp_item[j].priority = mod(ll_row, 5)
			if isnull(lstr_services.wp_item[j].priority) then
				li_display_priority = 2
			else
				li_display_priority = lstr_services.wp_item[j].priority
			end if
			if lstr_services.wp_item[j].escalation_date < datetime(today(), now()) and li_display_priority < 4 then
				li_display_priority++
			end if
			if li_display_priority > 2 then
				object.alert_bitmap[ll_row] = datalist.domain_item_bitmap( "Workplan Item Priority", string(li_display_priority))
			end if
		next
	else
		// This patient had no services so give them a "No Services" bar
		ll_row = insertrow(0)
		object.cpr_id[ll_row] = lstr_encounters.encounter[i].cpr_id
		object.encounter_id[ll_row] = lstr_encounters.encounter[i].encounter_id
		object.pretty_name[ll_row] = lstr_encounters.encounter[i].patient_name
		object.document_status[ll_row] = lstr_encounters.encounter[i].document_status
		object.description[ll_row] = "No Services"
		object.patient_color[ll_row] = ll_patient_color
		object.service_color[ll_row] = color_object
	end if
next

sort()


// Now attempt to scroll back down to where we were scrolled to before
ll_last_row_on_page = long(object.DataWindow.LastRowOnPage)
if ll_last_row_on_page < ll_first_row_on_page then
	i = ll_last_row_on_page
else
	i = 1
end if
DO WHILE true
	i += 1
	ll_new_first_row_on_page = long(object.DataWindow.FirstRowOnPage)
	if ll_new_first_row_on_page >= ll_first_row_on_page or ll_new_first_row_on_page <= 0 then exit
	if i > 50 and ll_new_first_row_on_page = ll_last then exit
	scrolltorow(i)
	ll_last = ll_new_first_row_on_page
LOOP

setredraw(true)

RETURN 1


end function

public function integer initialize (string ps_room_id);u_room luo_room
string ls_sort
string ls_temp

if isnull(ps_room_id) or ps_room_id = "!!NOWHERE" then
	setnull(room_id)
	room_type = "REMOTE"
else
	luo_room = room_list.find_room(ps_room_id)
	if isnull(luo_room) then
		log.log(this, "u_room_status.initialize.0011", "Invalid room_id (" + ps_room_id + ")", 4)
		return -1
	end if
	
	room_id = ps_room_id
	room_type = luo_room.room_type
end if

// See if we have an alternate sort specified for this room
CHOOSE CASE lower(room_list.room_sort(room_id))
	CASE "encounter ascending"
		ls_sort = "encounter_date A, encounter_id A, minutes D, description A"
	CASE "encounter descending"
		ls_sort = "encounter_date D, encounter_id D, minutes D, description A"
	CASE ELSE
		ls_sort = "pretty_name A, encounter_date A, encounter_id A, minutes D, description A"
END CHOOSE

setsort(ls_sort)


ls_temp = datalist.get_preference("PREFERENCES", "include_age_room")
if isnull(ls_temp) then
	include_age = true
else
	include_age = f_string_to_boolean(ls_temp)
end if


return 1

end function

event clicked;string ls_dwoname

// Set the 'last' values
lasttype = dwo.type
lastrow = row 
lastheader = false
lastcomputed = false
lastcolumnname = dwo.name

// If we register a click on the room_status screen, we can be certain that
// there isn't any user or service context, so clear it.
f_clear_context()

if lastrow <= 0 then return

if dwo.type = "column" then
	lastcolumn = integer(dwo.id)
else
	lastcolumn = 0
end if

postevent("post_click")

end event

event dberror;string ls_message

ls_message = "DATAWINDOW SQL ERROR = (" + string(sqldbcode) + ") " + sqlerrtext

log.log(this, "u_room_status.dberror.0005", ls_message, 3)

return 1

end event

on u_room_status.create
call super::create
end on

on u_room_status.destroy
call super::destroy
end on

event post_click;call super::post_click;///////////////////////////////////////////////////////////////////////////////////////////
//
//	Description:Start tasks depends on user request either patient details/services.
//
// Modified By:Sumathi Chinnasamy									Modified On:09/01/99
////////////////////////////////////////////////////////////////////////////////////////////

str_popup_return	popup_return
Long					ll_log_id, ll_encounter_id
Integer				li_sts
String				ls_cpr_id
string				ls_temp
long ll_patient_workplan_item_id
string ls_owned_by

ls_cpr_id = object.cpr_id[lastrow]
If isnull(ls_cpr_id) Then Return

ll_encounter_id = object.encounter_id[lastrow]
If Isnull(ll_encounter_id) Then Return

f_user_logon()
If isnull(current_user) Then Return

if lastcolumnname = "compute_alert_bitmap" then
elseif lastcolumnname = "compute_document_status" then
	if ll_encounter_id > 0 then
		f_manage_documents("Encounter", ls_cpr_id, ll_encounter_id)
	end if
end if


CHOOSE CASE lastcolumn
	CASE 12
		// pretty_name
		li_sts = patient_menu(lastrow)
		if li_sts > 0 then refresh()
	CASE 15
		// description
		Setitem(lastrow, "status", 2)
		ll_patient_workplan_item_id = object.patient_workplan_item_id[lastrow]
		if isnull(ll_patient_workplan_item_id) or ll_patient_workplan_item_id <= 0 then return
		
		li_sts = service_list.do_service(ll_patient_workplan_item_id)
		refresh()
	CASE 27
		ll_patient_workplan_item_id = object.patient_workplan_item_id[lastrow]
		if isnull(ll_patient_workplan_item_id) or ll_patient_workplan_item_id <= 0 then return

		f_display_service_menu(ll_patient_workplan_item_id)
		datalist.clear_cache("office_status")
		refresh()
	CASE ELSE
		Return
END CHOOSE


end event

