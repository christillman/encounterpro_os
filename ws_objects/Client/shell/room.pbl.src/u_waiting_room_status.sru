$PBExportHeader$u_waiting_room_status.sru
forward
global type u_waiting_room_status from datawindow
end type
end forward

global type u_waiting_room_status from datawindow
integer width = 2414
integer height = 1704
integer taborder = 1
string dataobject = "dw_sp_open_encounters_in_room_type"
boolean vscrollbar = true
boolean livescroll = true
event post_click pbm_custom01
end type
global u_waiting_room_status u_waiting_room_status

type variables
integer lastrow
integer lastcolumn

string room_id = "$WAITING"

boolean include_age

end variables

forward prototypes
public function integer refresh ()
public subroutine initialize ()
public function integer patient_menu (long pl_row)
end prototypes

event post_click;integer li_sts

if lastrow <= 0 then return

li_sts = patient_menu(lastrow)

if li_sts > 0 then refresh()

end event

public function integer refresh ();long ll_rowcount
string ls_sort
string ls_pref

ls_sort = "room_sequence A, patient_location A"

ls_pref = sqlca.fn_get_specific_preference( "SYSTEM", "Room", room_id, "sort")

// See if we have an alternate sort specified for this room
CHOOSE CASE lower(ls_pref)
	CASE "patient"
		ls_sort += ", patient_name A"
	CASE "encounter ascending"
		ls_sort += ", minutes A, patient_name A"
	CASE ELSE
		// Default is "encounter descending"
		ls_sort += ", minutes D, patient_name A"
END CHOOSE

setsort(ls_sort)

ll_rowcount = retrieve(gnv_app.office_id, room_id)
if ll_rowcount < 0 then return -1

return 1

end function

public subroutine initialize ();string ls_temp

settransobject(sqlca)


ls_temp = datalist.get_preference("PREFERENCES", "include_age_office")
if isnull(ls_temp) then
	include_age = true
else
	include_age = f_string_to_boolean(ls_temp)
end if

end subroutine

public function integer patient_menu (long pl_row);integer li_sts
string ls_room_id
string ls_room_type
string ls_cpr_id
long ll_encounter_id

f_user_logon()
If isnull(current_user) Then Return -1

ls_room_id = object.patient_location[pl_row]
ls_room_type = room_list.room_type(ls_room_id)
ls_cpr_id = object.cpr_id[pl_row]
ll_encounter_id = object.encounter_id[pl_row]

// Set the patient context
li_sts = f_set_patient(ls_cpr_id)
if li_sts < 0 then return -1

li_sts = f_set_current_encounter(ll_encounter_id)
if li_sts <= 0 then
	log.log(this, "u_waiting_room_status.patient_menu:0021", "Error setting encounter", 4)
	f_clear_patient()
	return -1
end if

// If no room-specific menu was found, then try displaying the menu for the room_type
li_sts = f_display_context_menu2("Room",ls_room_id,ls_room_type)

// Clear the patient context
f_clear_patient()

return 1


end function

event clicked;
// If we register a click on the waiting_room_status screen, we can be certain that
// there isn't any user or service context, so clear it.
f_clear_context()

lastrow = row
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

log.log(this, "u_waiting_room_status:dber", ls_message, 3)

return 1

end event

on u_waiting_room_status.create
end on

on u_waiting_room_status.destroy
end on

