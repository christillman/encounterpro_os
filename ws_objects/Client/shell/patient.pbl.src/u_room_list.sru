$PBExportHeader$u_room_list.sru
forward
global type u_room_list from nonvisualobject
end type
end forward

global type u_room_list from nonvisualobject
end type
global u_room_list u_room_list

type variables
integer room_count
u_room room[]

end variables

forward prototypes
public function string room_menu (string ps_room_type)
public function string find_first_room_type (string ps_room_type)
public function u_room find_room_computer (long pl_computer_id)
public function integer load_rooms ()
public subroutine refresh_room_status ()
public function string bitmap (string ps_room_type, string ps_room_status)
public function string find_room_type (string ps_room_type)
public function string room_type (string ps_room_id)
public function string room_name (string ps_room_id)
public function integer add_room (string ps_room_id, string ps_room_name, integer pi_room_sequence, string ps_room_type, string ps_room_status, long pl_computer_id, string ps_default_encounter_type, string ps_status)
public function integer get_rooms_of_type (string ps_room_type, ref string psa_rooms[])
public function u_room find_room (string ps_room_id)
public function string room_sort (string ps_room_id)
end prototypes

public function string room_menu (string ps_room_type);str_popup popup
string buttons[]
integer button_pressed, i
string ls_null
u_ds_data luo_data
long ll_rows
string lsa_room_id[]

string ls_room_type
string ls_room_name
string ls_room_status
string ls_room_id

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_room_list_this_office")
ll_rows = luo_data.retrieve(office_id)

setnull(ls_null)

popup.button_count = 0

for i = 1 to ll_rows
	ls_room_type = luo_data.object.room_type[i]
	ls_room_name = luo_data.object.room_name[i]
	ls_room_status = luo_data.object.room_status[i]
	// By Sumathi Chinnasamy On 11/18/99
	// request #559: don't show waiting rooms in toolbar
	If ls_room_type = "WAITING" Then Continue
	
	if ((ls_room_type = ps_room_type or ps_room_type = "!ALL") &
	    and (ls_room_status = "OK" or ls_room_status = "DIRTY")) &
		OR (ps_room_type = "!ALL" and ls_room_type = "REMOTE") then
		popup.button_count += 1
		lsa_room_id[popup.button_count] = luo_data.object.room_id[i]
		popup.button_icons[popup.button_count] = bitmap(ls_room_type, ls_room_status)
		popup.button_helps[popup.button_count] = ls_room_name
		popup.button_titles[popup.button_count] = ls_room_name
		buttons[popup.button_count] = string(i)
	end if
next

// If no rooms matched on the room type, then check to see if any
// rooms match on the room_id.
if popup.button_count = 0 then
	for i = 1 to ll_rows
		ls_room_id = luo_data.object.room_id[i]
		if ls_room_id = ps_room_type then return ls_room_id
	next
	return ls_null
end if

DESTROY luo_data

if popup.button_count > 1 then
	popup.button_count += 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	buttons[popup.button_count] = "0"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(w_pop_buttons, popup, f_active_window())
	button_pressed = message.doubleparm
	if button_pressed <= 0 or button_pressed >= popup.button_count then return ls_null
elseif popup.button_count = 1 then
	button_pressed = 1
else
	return ls_null
end if

return lsa_room_id[button_pressed]

return ls_null


end function

public function string find_first_room_type (string ps_room_type);integer i
string ls_room

for i = 1 to room_count
	if room[i].room_id = ps_room_type then return room[i].room_id
next

for i = 1 to room_count
	if room[i].room_type = ps_room_type then return room[i].room_id
next

setnull(ls_room)
return ls_room


end function

public function u_room find_room_computer (long pl_computer_id);integer i
u_room luo_room
string ls_room_id

// Check the preference
ls_room_id = datalist.get_preference("SYSTEM", "preferred_room_id")
if not isnull(ls_room_id) then
	return find_room(ls_room_id)
end if

setnull(luo_room)
return luo_room


end function

public function integer load_rooms ();string ls_room_id
string ls_room_name
string ls_room_type
string ls_room_status
long ll_computer_id
string ls_status
integer li_room_sequence
long ll_count
long i
string ls_default_encounter_type

temp_datastore.set_dataobject("dw_o_rooms")
ll_count = temp_datastore.retrieve()

for i = 1 to ll_count
	ls_room_id = temp_datastore.object.room_id[i]
	ls_room_name = temp_datastore.object.room_name[i]
	li_room_sequence = temp_datastore.object.room_sequence[i]
	ls_room_type = temp_datastore.object.room_type[i]
	ls_room_status = temp_datastore.object.room_status[i]
	ll_computer_id = temp_datastore.object.computer_id[i]
	ls_default_encounter_type = temp_datastore.object.default_encounter_type[i]
	ls_status = temp_datastore.object.status[i]
	
	add_room(ls_room_id, &
				ls_room_name, &
				li_room_sequence, &
				ls_room_type, &
				ls_room_status, &
				ll_computer_id, &
				ls_default_encounter_type, &
				ls_status)
next

setnull(ll_computer_id)
setnull(ls_default_encounter_type)

add_room("!!NOWHERE", &
			"Nowhere", &
			9999, &
			"REMOTE", &
			"OK", &
			ll_computer_id, &
			ls_default_encounter_type, &
			"NA")


return ll_count

end function

public subroutine refresh_room_status ();integer i

for i = 1 to room_count
	room[i].refresh_room_status()
next


end subroutine

public function string bitmap (string ps_room_type, string ps_room_status);
//if room_status <> "OK" and room_status <> "DIRTY" then return "buttonxh.bmp"

CHOOSE CASE ps_room_type
	CASE "$CHECKOUT"
		if ps_room_status = "OK" then
			return "button12.bmp"
		else
			return "b_push12.bmp"
		end if
	CASE "$EXAMINATION"
		if ps_room_status = "OK" then
			return "button10.bmp"
		else
			return "b_push10.bmp"
		end if
	CASE "$TRIAGE"
		if ps_room_status = "OK" then
			return "button25.bmp"
		else
			return "b_push25.bmp"
		end if
	CASE "$WAITING"
		if ps_room_status = "OK" then
			return "button23.bmp"
		else
			return "b_push23.bmp"
		end if
	CASE "$TELEPHONE"
		if ps_room_status = "OK" then
			return "button24.bmp"
		else
			return "b_push24.bmp"
		end if
	CASE "$EXIT"
		if ps_room_status = "OK" then
			return "button16.bmp"
		else
			return "b_push16.bmp"
		end if
	CASE "$REMOTE"
		return "buttonxq.bmp"
END CHOOSE

log.log(this, "bitmap()", "Unknown room type (" + ps_room_type + ")", 3)
return "button09.bmp"


end function

public function string find_room_type (string ps_room_type);integer i
string ls_room

for i = 1 to room_count
	if room[i].room_type = ps_room_type then return room[i].room_id
next

setnull(ls_room)
return ls_room


end function

public function string room_type (string ps_room_id);u_room luo_room
string ls_room_type

luo_room = find_room(ps_room_id)
if isnull(luo_room) then
	setnull(ls_room_type)
else
	ls_room_type = luo_room.room_type
end if

return ls_room_type

end function

public function string room_name (string ps_room_id);integer i
string ls_room_name

for i = 1 to room_count
	if room[i].room_id = ps_room_id then return room[i].room_name
next

return ""
end function

public function integer add_room (string ps_room_id, string ps_room_name, integer pi_room_sequence, string ps_room_type, string ps_room_status, long pl_computer_id, string ps_default_encounter_type, string ps_status);string ls_sort

room_count += 1
room[room_count] = CREATE u_room

room[room_count].room_id = ps_room_id
room[room_count].room_name = ps_room_name
room[room_count].room_sequence = pi_room_sequence
room[room_count].room_type = ps_room_type
room[room_count].room_status = ps_room_status
room[room_count].computer_id = pl_computer_id
room[room_count].default_encounter_type = ps_default_encounter_type
room[room_count].status = ps_status

ls_sort = sqlca.fn_get_specific_preference('SYSTEM', 'Room', ps_room_id, 'sort')
if isnull(ls_sort) then
	ls_sort = "patient"
end if

room[room_count].sort = ls_sort

return room_count

end function

public function integer get_rooms_of_type (string ps_room_type, ref string psa_rooms[]);integer i
integer li_count

li_count = 0

for i = 1 to room_count
	if room[i].room_type = ps_room_type then
		li_count += 1
		psa_rooms[li_count] = room[i].room_id
	end if
next

return li_count


end function

public function u_room find_room (string ps_room_id);integer i
u_room luo_room

if isnull(ps_room_id) then ps_room_id = "!!NOWHERE"

for i = 1 to room_count
	if room[i].room_id = ps_room_id then return room[i]
next

setnull(luo_room)
return luo_room


end function

public function string room_sort (string ps_room_id);integer i
string ls_room_name

for i = 1 to room_count
	if room[i].room_id = ps_room_id then return room[i].sort
next

return ""

end function

on u_room_list.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_room_list.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

