$PBExportHeader$u_office_status.sru
forward
global type u_office_status from datawindow
end type
end forward

shared variables

end variables

global type u_office_status from datawindow
integer width = 1120
integer height = 1476
integer taborder = 1
string dataobject = "dw_office_status"
boolean border = false
boolean livescroll = true
event post_click pbm_custom01
end type
global u_office_status u_office_status

type variables
long group_id

long lastrow
long lastcolumn

long patient_count
long my_patient_count
long my_role_patient_count

integer max_priority

boolean include_age

end variables

forward prototypes
public function integer initialize (long pl_group_id)
public function integer load_room (str_room pstr_room)
public function integer refresh (datawindow puo_2nd_dw)
end prototypes

public function integer initialize (long pl_group_id);string ls_temp

group_id = pl_group_id

ls_temp = datalist.get_preference("PREFERENCES", "include_age_office")
if isnull(ls_temp) then
	include_age = true
else
	include_age = f_string_to_boolean(ls_temp)
end if


return 1

end function

public function integer load_room (str_room pstr_room);///////////////////////////////////////////////////////////////////////////////////////////
//
//	Function: refresh
//
// Arguments: datawindow
//
//	Return: Integer
//
//	Description: Show all services related to office status. If a user has started
//					a service his/her initial is displayed before the service
//             description.  '*' means service is active.
//
// Created By:																Creation dt:
//
// Modified By:Sumathi Chinnasamy									Modified On:08/26/99
//					Mark Copenhaver														8/3/2002
////////////////////////////////////////////////////////////////////////////////////////////
long			ll_row
String		ls_temp
string		ls_description
string		ls_owned_by
Long			ll_patient_color
long			ll_service_color
string ls_pretty_name
string ls_user_id
boolean lb_my_service
boolean lb_my_role_service
long ll_patient_sort
string ls_alert_bitmap
string ls_age
long i
long j
long ll_days
long ll_minutes
string ls_result
string ls_user_short_name
integer li_display_priority

str_encounter_list lstr_encounters
str_wp_item_list lstr_services

ls_user_short_name = user_list.user_short_name(pstr_room.in_room_user_id)


// See if there are any patients in this room
lstr_encounters = datalist.office_room_encounters(pstr_room.room_id)
if lstr_encounters.encounter_count > 0 then
	// Loop through the open encounters
	for i = 1 to lstr_encounters.encounter_count
		// We found a patient encounter so increment the count
		patient_count += 1
		lb_my_service = false
		lb_my_role_service = false
		
		// get the color of the attending doctor
		ll_patient_color = user_list.user_color(lstr_encounters.encounter[i].attending_doctor)
		if isnull(ll_patient_color) or ll_patient_color = 0 then ll_patient_color = color_object
		
		lstr_services = datalist.office_encounter_services(lstr_encounters.encounter[i].cpr_id, lstr_encounters.encounter[i].encounter_id)
		if lstr_services.wp_item_count > 0 then
			// Loop through the active services and put in a row for each one
			for j = 1 to lstr_services.wp_item_count
				ll_row = insertrow(0)
				object.room_id[ll_row] = pstr_room.room_id
				object.room_name[ll_row] = pstr_room.room_name
				object.user_short_name[ll_row] = ls_user_short_name
				object.room_sequence[ll_row] = pstr_room.room_sequence
				object.cpr_id[ll_row] = lstr_encounters.encounter[i].cpr_id
				object.encounter_id[ll_row] = lstr_encounters.encounter[i].encounter_id
				if j = 1 then
					object.document_status[ll_row] = lstr_encounters.encounter[i].document_status
				end if
				

				// Calculate the name display
				ls_pretty_name = lstr_encounters.encounter[i].patient_name
				
				if include_age then
					ls_age = f_pretty_age_short(lstr_encounters.encounter[i].date_of_birth, today())
					if len(ls_age) > 0 then
						ls_pretty_name += " - " + ls_age
					end if
				end if				
				
				
				// Set the sorting
				ll_patient_sort = secondsafter(time(lstr_encounters.encounter[i].encounter_date), now())
				
				if date(lstr_encounters.encounter[i].encounter_date) = today() then
					ll_minutes = ll_patient_sort / 60
					if ll_minutes >= 0 then
						ls_pretty_name += " (" + string(ll_minutes) + ")"
					end if
				else
					ll_days = daysafter(date(lstr_encounters.encounter[i].encounter_date), today())
					ls_pretty_name += " (" + string(ll_days) + " days)"
					ll_patient_sort += ll_days * 86400
				end if
				
				object.pretty_name[ll_row] = ls_pretty_name

				CHOOSE CASE lower(pstr_room.sort)
					CASE "encounter ascending"
						object.patient_sort[ll_row] = -ll_patient_sort
					CASE "encounter descending"
						object.patient_sort[ll_row] = ll_patient_sort
					CASE ELSE
						object.patient_sort[ll_row] = 1
				END CHOOSE
				
				setnull(ls_alert_bitmap)
				if isnull(lstr_services.wp_item[j].priority) then
					li_display_priority = 2
				else
					li_display_priority = lstr_services.wp_item[j].priority
				end if
				if lstr_services.wp_item[j].escalation_date < datetime(today(), now()) and li_display_priority < 4 then
					li_display_priority++
				end if
				if li_display_priority > 2 then
					ls_alert_bitmap = datalist.domain_item_bitmap( "Workplan Item Priority", string(li_display_priority))
				end if
				// Check for max priority
				if li_display_priority > max_priority then
					max_priority = li_display_priority
				end if
				
				ls_owned_by = lstr_services.wp_item[j].owned_by
				ls_description = lstr_services.wp_item[j].description
				
				ll_service_color = user_list.user_color(ls_owned_by)
				if isnull(ll_service_color) or ll_service_color = 0 then ll_service_color = color_object

				object.patient_color[ll_row] = ll_patient_color
				object.service_color[ll_row] = ll_service_color
				
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
						
						if isnull(ls_alert_bitmap) then
							ls_alert_bitmap = datalist.domain_item_bitmap( "RESULTSEVERITY", string(lstr_services.wp_item[j].severity))
						end if
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
				object.alert_bitmap[ll_row] = ls_alert_bitmap

				// Check for my service
				if not isnull(current_user) then
					if current_user.user_id = ls_owned_by then
						lb_my_service = true
					end if
					if left(ls_owned_by, 1) = "!" then
						if user_list.is_user_role(current_user.user_id, ls_owned_by) then
							lb_my_role_service = true
						end if
					end if
				end if
			next
		else
			// This patient had no services so give them a "No Services" bar
			ll_row = insertrow(0)
			object.room_id[ll_row] = pstr_room.room_id
			object.room_name[ll_row] = pstr_room.room_name
			object.user_short_name[ll_row] = ls_user_short_name
			object.room_sequence[ll_row] = pstr_room.room_sequence
			object.cpr_id[ll_row] = lstr_encounters.encounter[i].cpr_id
			object.encounter_id[ll_row] = lstr_encounters.encounter[i].encounter_id
			object.document_status[ll_row] = lstr_encounters.encounter[i].document_status
			object.pretty_name[ll_row] = lstr_encounters.encounter[i].patient_name
			object.description[ll_row] = "No Services"
			object.patient_color[ll_row] = ll_patient_color
			object.service_color[ll_row] = color_object
		end if
		
		if lb_my_service then my_patient_count += 1
		if lb_my_role_service then my_role_patient_count += 1
	next
elseif not isnull(pstr_room.room_id) then
	// If the room is empty then put in an empty-room row
	ll_row = Insertrow(0)
	object.room_id[ll_row] = pstr_room.room_id
	object.room_name[ll_row] = pstr_room.room_name
	object.user_short_name[ll_row] = ls_user_short_name
	object.room_sequence[ll_row] = pstr_room.room_sequence
	IF pstr_room.room_status = "OK" THEN
		object.pretty_name[ll_row] = "Empty"
	ELSEIF pstr_room.room_status = "DIRTY" THEN
		object.pretty_name[ll_row] = "DIRTY"
	ELSE
		object.pretty_name[ll_row] = pstr_room.room_status
	END IF
	object.description[ll_row] = ""
	object.patient_color[ll_row] = color_background
	object.service_color[ll_row] = color_background
end if
	
RETURN 1


end function

public function integer refresh (datawindow puo_2nd_dw);///////////////////////////////////////////////////////////////////////////////////////////
//
//	Function: refresh
//
// Arguments: datawindow
//
//	Return: Integer
//
//	Description: Show all services related to office status. If a user has started
//					a service his/her initial is displayed before the service
//             description.  '*' means service is active.
//
// Created By:																Creation dt:
//
// Modified By:Sumathi Chinnasamy									Modified On:08/26/99
//					Mark Copenhaver														8/3/2002
////////////////////////////////////////////////////////////////////////////////////////////
long			ll_row
String		ls_temp
string 		ls_room_id
string ls_room_name
long ll_room_sequence
string ls_room_status
long ll_rowcount

long ll_room_count
long ll_encounter_count
long ll_service_count

string ls_room_find

string ls_first_room_on_page
long ll_last_row_on_page
long ll_move_row
long i
long ll_minutes

string ls_encounter_find
long ll_encounter_row

str_room_list lstr_rooms
str_room lstr_nowhere_room

patient_count = 0
my_patient_count = 0
my_role_patient_count = 0
max_priority = 0

Setredraw(FALSE)
puo_2nd_dw.Setredraw(FALSE)
reset()


lstr_rooms = datalist.office_group_rooms(group_id)
// Loop through the rooms which should appear on this tab
for i = 1 to lstr_rooms.room_count
	// Load the patients in this room
	load_room(lstr_rooms.room[i])
next

// Now add the patients who aren't in a room
setnull(lstr_nowhere_room.room_id)
lstr_nowhere_room.room_name = "Nowhere"
lstr_nowhere_room.room_sequence = 9999
lstr_nowhere_room.room_status = "OK"
load_room(lstr_nowhere_room)


/* resort & recalculate the group */
Sort()
Groupcalc()
Scrolltorow(0)

ll_rowcount = rowcount()

ll_last_row_on_page = Integer(Describe("DataWindow.LastRowOnPage"))
IF ll_last_row_on_page <= 0 and ll_rowcount > 0 THEN
	log.log(this, "u_office_status.refresh.0078", "Invalid lastrowonpage", 3)
	ll_last_row_on_page = ll_rowcount
END IF

// Now move the rooms which are partially or fully off the screen to the right side
puo_2nd_dw.Reset()


IF ll_last_row_on_page < ll_rowcount THEN
	// Get the first room on the page
	ls_first_room_on_page = object.room_id[1]
	
	// Start by assuming that the last visible row is actually the
	// last row for it's respective room
	ll_move_row = ll_last_row_on_page + 1

	// Check to see if the first row not visible is for another room
	ls_room_id = object.room_id[ll_last_row_on_page]
	ls_temp = object.room_id[ll_move_row]
	IF ls_temp = ls_room_id THEN
		// If the last room on the page extends past the page,
		// then check to see if its the same room as the
		// first room on the page
		if ls_first_room_on_page <> ls_room_id then
			// If the last room on the page is different
			// from the first room, and it extends past the
			// end of the page, the back up to find the first record
			FOR i = ll_move_row - 1 To 1 Step -1
				ls_temp = object.room_id[i]
				IF ls_temp = ls_room_id THEN
					ll_move_row = i
				ELSE
					EXIT
				END IF
			NEXT
		end if
		RowsMove(ll_move_row, ll_rowcount, Primary!, puo_2nd_dw, 1, Primary!)
	ELSE
		RowsMove(ll_move_row, ll_rowcount, Primary!, puo_2nd_dw, 1, Primary!)
	END IF
END IF

puo_2nd_dw.Groupcalc()
puo_2nd_dw.Setredraw(TRUE)
Setredraw(TRUE)
RETURN 1


end function

event clicked;string ls_temp
long ll_pos

lastrow = row

if dwo.type = "column" then
	lastcolumn = integer(dwo.id)
else
	lastcolumn = 0
end if

if lastrow <= 0 then
	ls_temp = GetBandAtPointer()
	ll_pos = pos(ls_temp,"~t")
	lastrow = long(mid(ls_temp,ll_pos, 4))
	if lastrow <= 0 then return
end if


postevent("post_click")

end event

event dberror;string ls_message

ls_message = "DATAWINDOW SQL ERROR = (" + string(sqldbcode) + ") " + sqlerrtext

log.log(this, "u_office_status.dberror.0005", ls_message, 3)

return 1

end event

event sqlpreview;log.log(this, "u_office_status.sqlpreview.0001", sqlsyntax, 1)

end event

on u_office_status.create
end on

on u_office_status.destroy
end on

