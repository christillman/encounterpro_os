$PBExportHeader$w_workplan_definition.srw
forward
global type w_workplan_definition from w_window_base
end type
type st_treatment_type from statictext within w_workplan_definition
end type
type st_treatment_type_title from statictext within w_workplan_definition
end type
type st_in_office_flag_title from statictext within w_workplan_definition
end type
type st_in_office_flag from statictext within w_workplan_definition
end type
type pb_cancel from u_picture_button within w_workplan_definition
end type
type sle_description from singlelineedit within w_workplan_definition
end type
type st_title from statictext within w_workplan_definition
end type
type st_type from statictext within w_workplan_definition
end type
type st_title_type from statictext within w_workplan_definition
end type
type pb_done from u_picture_button within w_workplan_definition
end type
type st_results from statictext within w_workplan_definition
end type
type dw_steps from u_dw_pick_list within w_workplan_definition
end type
type st_step_desc_title from statictext within w_workplan_definition
end type
type st_step_room_title from statictext within w_workplan_definition
end type
type cb_add_step from commandbutton within w_workplan_definition
end type
type cb_change_description from commandbutton within w_workplan_definition
end type
type st_step_delay_title from statictext within w_workplan_definition
end type
type cb_add_final_step from commandbutton within w_workplan_definition
end type
type pb_1 from u_pb_help_button within w_workplan_definition
end type
type pb_up from u_picture_button within w_workplan_definition
end type
type st_page from statictext within w_workplan_definition
end type
type pb_down from u_picture_button within w_workplan_definition
end type
type st_in_office_title from statictext within w_workplan_definition
end type
type st_1 from statictext within w_workplan_definition
end type
type st_specialty_title from statictext within w_workplan_definition
end type
type st_specialty from statictext within w_workplan_definition
end type
end forward

global type w_workplan_definition from w_window_base
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_treatment_type st_treatment_type
st_treatment_type_title st_treatment_type_title
st_in_office_flag_title st_in_office_flag_title
st_in_office_flag st_in_office_flag
pb_cancel pb_cancel
sle_description sle_description
st_title st_title
st_type st_type
st_title_type st_title_type
pb_done pb_done
st_results st_results
dw_steps dw_steps
st_step_desc_title st_step_desc_title
st_step_room_title st_step_room_title
cb_add_step cb_add_step
cb_change_description cb_change_description
st_step_delay_title st_step_delay_title
cb_add_final_step cb_add_final_step
pb_1 pb_1
pb_up pb_up
st_page st_page
pb_down pb_down
st_in_office_title st_in_office_title
st_1 st_1
st_specialty_title st_specialty_title
st_specialty st_specialty
end type
global w_workplan_definition w_workplan_definition

type variables
long workplan_id
boolean description_changed = false

u_ds_data step_rooms
u_ds_data items
u_ds_data item_attributes

string workplan_in_office_flag
string specialty_id

end variables

forward prototypes
public subroutine select_rooms (long pl_row)
public subroutine display_delay (long pl_row)
public function integer save_changes ()
public subroutine move_step_up (long pl_row)
public subroutine move_step_down (long pl_row)
public function integer load_workplan ()
public subroutine step_menu (long pl_row)
public subroutine set_in_office_flag ()
public subroutine delete_step (long pl_row)
end prototypes

public subroutine select_rooms (long pl_row);str_popup popup
str_popup_return popup_return
string ls_find
long ll_rowcount
integer i


popup.objectparm = step_rooms
popup.items[1] = string(workplan_id)
popup.items[2] = string(dw_steps.object.step_number[pl_row])
popup.items[3] = string(dw_steps.object.room_type[pl_row])
popup.data_row_count = 3

openwithparm(w_workplan_select_room, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

dw_steps.object.room_type[pl_row] = popup_return.items[1]



end subroutine

public subroutine display_delay (long pl_row);u_unit luo_unit
long i
real lr_amount
string ls_unit
string ls_delay

ls_delay = "<No Delay>"

lr_amount = real(dw_steps.object.step_delay[pl_row])
if lr_amount > 0 then
	ls_unit = dw_steps.object.step_delay_unit[pl_row]
	luo_unit = unit_list.find_unit(ls_unit)
	if not isnull(luo_unit) then
		ls_delay = luo_unit.pretty_amount_unit(lr_amount)
		ls_delay += " " + dw_steps.object.delay_from_flag[pl_row]
	end if
end if

dw_steps.object.delay_text[pl_row] = ls_delay




end subroutine

public function integer save_changes ();integer li_sts
string li_step_number

if description_changed then
	UPDATE c_Workplan
	SET description = :sle_description.text,
		specialty_id = :specialty_id
	WHERE workplan_id = :workplan_id;
	if not tf_check() then return -1
end if

li_sts = dw_steps.update()
if li_sts <= 0 then return -1

li_sts = step_rooms.update()
if li_sts <= 0 then return -1

li_sts = items.update()
if li_sts <= 0 then return -1

li_sts = item_attributes.update()
if li_sts <= 0 then return -1

return 1


end function

public subroutine move_step_up (long pl_row);integer li_step_number
string ls_temp
long i
integer li_temp
long ll_lastrow
long ll_i_rows
string ls_find
long ll_row
long lla_item_rows[]
long ll_items

li_step_number = dw_steps.object.step_number[pl_row]
ll_lastrow = dw_steps.rowcount()
ll_i_rows = items.rowcount()

// Make sure we can do this

// We can't move the final step
if li_step_number = 999 then return

// We can't move the step up if it's already step 1
if pl_row <= 1 or li_step_number <= 1 then return

// Now swap the step numbers of the items

// First record the row numbers of all the items in the moving step
ll_items = 0
ls_find = "step_number=" + string(li_step_number)
ll_row = items.find(ls_find, 1, ll_i_rows)
DO WHILE ll_row > 0 and ll_row <= ll_i_rows
	ll_items += 1
	lla_item_rows[ll_items] = ll_row
	
	ll_row = items.find(ls_find, ll_row + 1, ll_i_rows + 1)
LOOP

// Next, change the step number for the items in the above step
ls_find = "step_number=" + string(li_step_number - 1)
ll_row = items.find(ls_find, 1, ll_i_rows)
DO WHILE ll_row > 0 and ll_row <= ll_i_rows
	items.object.step_number[ll_row] = li_step_number
	ll_row = items.find(ls_find, ll_row + 1, ll_i_rows + 1)
LOOP

// Then change the step number for the recorded items
for i = 1 to ll_items
	items.object.step_number[lla_item_rows[i]] = li_step_number - 1
next


// Finally, swap the step numbers of the moving step and the step above
dw_steps.object.step_number[pl_row - 1] = li_step_number
dw_steps.object.step_number[pl_row] = li_step_number - 1

dw_steps.sort()

end subroutine

public subroutine move_step_down (long pl_row);integer li_step_number
string ls_temp
long i
integer li_temp
long ll_lastrow
long ll_i_rows
string ls_find
long ll_row
long lla_item_rows[]
long ll_items

li_step_number = dw_steps.object.step_number[pl_row]
ll_lastrow = dw_steps.rowcount()
ll_i_rows = items.rowcount()

// Make sure we can do this

// We can't move the final step
if li_step_number = 999 then return

// We can't move the step down if it's already the last step
if integer(dw_steps.object.step_number[ll_lastrow]) = 999 then ll_lastrow -= 1
if pl_row = ll_lastrow then return

// Now swap the step numbers of the items

// First record the row numbers of all the items in the moving step
ll_items = 0
ls_find = "step_number=" + string(li_step_number)
ll_row = items.find(ls_find, 1, ll_i_rows)
DO WHILE ll_row > 0 and ll_row <= ll_i_rows
	ll_items += 1
	lla_item_rows[ll_items] = ll_row
	
	ll_row = items.find(ls_find, ll_row + 1, ll_i_rows + 1)
LOOP

// Next, change the step number for the items in the below step
ls_find = "step_number=" + string(li_step_number + 1)
ll_row = items.find(ls_find, 1, ll_i_rows)
DO WHILE ll_row > 0 and ll_row <= ll_i_rows
	items.object.step_number[ll_row] = li_step_number
	ll_row = items.find(ls_find, ll_row + 1, ll_i_rows + 1)
LOOP

// Then change the step number for the recorded items
for i = 1 to ll_items
	items.object.step_number[lla_item_rows[i]] = li_step_number + 1
next


// Finally, swap the step numbers of the moving step and the step above
dw_steps.object.step_number[pl_row + 1] = li_step_number
dw_steps.object.step_number[pl_row] = li_step_number + 1

dw_steps.sort()

end subroutine

public function integer load_workplan ();long ll_count
long i
string ls_room_name
string ls_room_id
string ls_treatment_type

SELECT workplan_type, description, in_office_flag, treatment_type, specialty_id
INTO :st_type.text, 
		:sle_description.text, 
		:workplan_in_office_flag, 
		:ls_treatment_type,
		:specialty_id
FROM c_Workplan
WHERE workplan_id = :workplan_id;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then
	log.log(this, "w_workplan_definition.load_workplan.0017", "Workplan not found (" + string(workplan_id) + ")", 4)
	return -1
end if

if workplan_in_office_flag = "Y" then
	st_in_office_flag.text = "In Office"
else
	workplan_in_office_flag = "N"
	st_in_office_flag.text = "Out Of Office"
end if

if isnull(ls_treatment_type) then
	st_treatment_type_title.visible = false
	st_treatment_type.visible = false
else
	st_treatment_type_title.visible = false
	st_treatment_type.visible = false
	st_treatment_type.text = datalist.treatment_type_description(ls_treatment_type)
end if

ll_count = dw_steps.retrieve(workplan_id)
if ll_count < 0 then return -1
dw_steps.set_page(1, pb_up, pb_down, st_page)

ll_count = step_rooms.retrieve(workplan_id)
if ll_count < 0 then return -1

ll_count = items.retrieve(workplan_id)
if ll_count < 0 then return -1

ll_count = item_attributes.retrieve(workplan_id)
if ll_count < 0 then return -1

if isnull(specialty_id) then
	st_specialty.text = "<None>"
else
	st_specialty.text = datalist.specialty_description(specialty_id)
end if

cb_add_final_step.enabled = true

for i = 1 to dw_steps.rowcount()
	if dw_steps.object.step_number[i] = 999 then
		cb_add_final_step.enabled = false
	else
		display_delay(i)
	end if
next

set_in_office_flag()

return 1

end function

public subroutine step_menu (long pl_row);str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons
string ls_user_id
integer li_update_flag
integer li_step_number
string ls_temp
long i
integer li_temp
long ll_lastrow

li_step_number = dw_steps.object.step_number[pl_row]

ll_lastrow = dw_steps.rowcount()
if dw_steps.object.step_number[ll_lastrow] = 999 then ll_lastrow -= 1


if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit Workplan Step Items"
	popup.button_titles[popup.button_count] = "Edit Step"
	buttons[popup.button_count] = "EDIT"
end if

if li_step_number < 999  then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttontime.bmp"
	popup.button_helps[popup.button_count] = "Edit Step Delay"
	popup.button_titles[popup.button_count] = "Delay Step"
	buttons[popup.button_count] = "DELAY"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit Room Assignments"
	popup.button_titles[popup.button_count] = "Room Assignment"
	buttons[popup.button_count] = "ROOM"
end if

if pl_row > 1 and li_step_number < 999 then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonup.bmp"
	popup.button_helps[popup.button_count] = "Move Step Up"
	popup.button_titles[popup.button_count] = "Move Up"
	buttons[popup.button_count] = "UP"
end if

if pl_row < ll_lastrow then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttondn.bmp"
	popup.button_helps[popup.button_count] = "Move Step Down"
	popup.button_titles[popup.button_count] = "Move Down"
	buttons[popup.button_count] = "DOWN"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Delete Workplan Step"
	popup.button_titles[popup.button_count] = "Delete Step"
	buttons[popup.button_count] = "DELETE"
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
	CASE "EDIT"
		// First save the changes
		li_sts = save_changes()
		if li_sts < 0 then return
		
		// Let the user edit the step items
		popup.items[1] = string(workplan_id)
		popup.items[2] = string(li_step_number)
		popup.data_row_count = 2
		openwithparm(w_Workplan_step_definition, popup)
		
		// Finally, refresh item datastores
		items.retrieve(workplan_id)
		item_attributes.retrieve(workplan_id)
		set_in_office_flag()
	CASE "DELAY"
		popup.title = "Delay For " + dw_steps.object.description[pl_row]
		popup.items[1] = string(dw_steps.object.step_delay[pl_row])
		popup.items[2] = dw_steps.object.step_delay_unit[pl_row]
		popup.items[3] = dw_steps.object.delay_from_flag[pl_row]
		popup.data_row_count = 3
		openwithparm(w_Workplan_step_delay, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 3 then return
		dw_steps.object.step_delay[pl_row] = long(popup_return.items[1])
		dw_steps.object.step_delay_unit[pl_row] = popup_return.items[2]
		dw_steps.object.delay_from_flag[pl_row] = popup_return.items[3]
		display_delay(pl_row)
	CASE "ROOM"
		select_rooms(pl_row)
	CASE "UP"
		move_step_up(pl_row)
	CASE "DOWN"
		move_step_down(pl_row)
	CASE "DELETE"
		ls_temp = "Are you sure you wish to delete the workplan step '" + dw_steps.object.description[pl_row] + "'?"
		openwithparm(w_pop_yes_no, ls_temp)
		popup_return = message.powerobjectparm
		if popup_return.item = "YES" then
			delete_step(pl_row)
		end if
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return


end subroutine

public subroutine set_in_office_flag ();boolean lb_error
long ll_row
long i
long ll_rowcount
integer li_step_number
long ll_i_count
string ls_in_office_flag
string ls_step_in_office_flag
string ls_find
string ls_error

ll_rowcount = dw_steps.rowcount()
ll_i_count = items.rowcount()

ls_step_in_office_flag = workplan_in_office_flag
lb_error = false

for i = 1 to ll_rowcount
	li_step_number = dw_steps.object.step_number[i]
	ls_find = "step_number=" + string(li_step_number)
	ls_find += " and step_flag='Y'"
	ll_row = items.find(ls_find, 1, ll_i_count)
	DO WHILE ll_row > 0 and ll_row <= ll_i_count
		ls_in_office_flag = items.object.in_office_flag[ll_row]
		if ls_in_office_flag = "N" and ls_step_in_office_flag = "Y" then
			ls_step_in_office_flag = "N"
		elseif ls_in_office_flag = "Y" and ls_step_in_office_flag = "N" then
			ls_step_in_office_flag = "Y"
			lb_error = true
		end if
		
		ll_row = items.find(ls_find, ll_row + 1, ll_i_count + 1)
	LOOP
	
	dw_steps.object.in_office_flag[i] = ls_step_in_office_flag
next

if lb_error then
	ls_error = "This workplan contains in-office step(s) following out-of-office step(s)."
	ls_error += "  That is not allowed.  Please edit the steps so that all in-office steps"
	ls_error += " precede all out-of-office steps."
	openwithparm(w_pop_message, ls_error)
end if


end subroutine

public subroutine delete_step (long pl_row);Integer	li_step_number
String 	ls_temp,ls_attr_find
Long		i
Integer 	li_temp
Long		ll_lastrow,ll_i_rows
String	ls_find
Long		ll_row,ll_attr_rows,ll_attr_row,ll_item_number

ll_lastrow = dw_steps.rowcount()
ll_i_rows = items.rowcount()

// Remove all items in the deleted items in the step
li_step_number = dw_steps.object.step_number[pl_row]
ls_find = "step_number=" + String(li_step_number)
ll_row = items.find(ls_find, 1, ll_i_rows)
Do While ll_row > 0 and ll_row <= ll_i_rows
	ll_item_number = items.object.item_number[ll_row]
	items.deleterow(ll_row)
	ll_row = items.find(ls_find, ll_row, ll_i_rows + 1)
	// delete workplan item attributes
	ls_attr_find = "item_number="+String(ll_item_number)
	ll_attr_rows = item_attributes.rowcount()
	ll_attr_row = item_attributes.Find(ls_attr_find,1,ll_attr_rows)
	Do While ll_attr_row > 0 and ll_attr_row <= ll_attr_rows
		item_attributes.deleterow(ll_attr_row)
		ll_attr_row = items.find(ls_find, ll_attr_row, ll_attr_rows + 1)
	Loop
Loop

// Delete the step
dw_steps.deleterow(pl_row)
ll_lastrow -= 1

If ll_lastrow <= 0 Then Return // Check for valid row number

// Don't renumber the "Final" step
if dw_steps.object.step_number[ll_lastrow] = 999 then ll_lastrow -= 1

// Renumber all the steps after the deleted one
for i = pl_row to ll_lastrow
	li_step_number = dw_steps.object.step_number[i]
	dw_steps.object.step_number[i] = i
	
	// Change the step number for all items in the renumbered step
	ls_find = "step_number=" + string(li_step_number)
	ll_row = items.find(ls_find, 1, ll_i_rows)
	DO WHILE ll_row > 0 and ll_row <= ll_i_rows
		items.object.step_number[ll_row] = i
		ll_row = items.find(ls_find, ll_row + 1, ll_i_rows + 1)
	LOOP
next

// if user deleted final step, then enable "Add Final Step" button.
if li_step_number = 999 then cb_add_final_step.enabled = true

dw_steps.recalc_page(pb_up, pb_down, st_page)

end subroutine

event open;call super::open;str_popup popup
integer li_sts

popup = message.powerobjectparm

dw_steps.settransobject(sqlca)

step_rooms = CREATE u_ds_data
step_rooms.set_dataobject("dw_workplan_step_room_data")

items = CREATE u_ds_data
items.set_dataobject("dw_c_workplan_item")

item_attributes = CREATE u_ds_data
item_attributes.set_dataobject("dw_workplan_item_attribute_data")

if popup.data_row_count <> 1 then
	log.log(this, "w_workplan_definition.open.0018", "Invalid parameters", 4)
	close(this)
	return
end if

workplan_id = long(popup.items[1])

if isnull(workplan_id) then
	log.log(this, "w_workplan_definition.open.0018", "Null workplan_id", 4)
	close(this)
	return
end if

postevent("post_open")

end event

on w_workplan_definition.create
int iCurrent
call super::create
this.st_treatment_type=create st_treatment_type
this.st_treatment_type_title=create st_treatment_type_title
this.st_in_office_flag_title=create st_in_office_flag_title
this.st_in_office_flag=create st_in_office_flag
this.pb_cancel=create pb_cancel
this.sle_description=create sle_description
this.st_title=create st_title
this.st_type=create st_type
this.st_title_type=create st_title_type
this.pb_done=create pb_done
this.st_results=create st_results
this.dw_steps=create dw_steps
this.st_step_desc_title=create st_step_desc_title
this.st_step_room_title=create st_step_room_title
this.cb_add_step=create cb_add_step
this.cb_change_description=create cb_change_description
this.st_step_delay_title=create st_step_delay_title
this.cb_add_final_step=create cb_add_final_step
this.pb_1=create pb_1
this.pb_up=create pb_up
this.st_page=create st_page
this.pb_down=create pb_down
this.st_in_office_title=create st_in_office_title
this.st_1=create st_1
this.st_specialty_title=create st_specialty_title
this.st_specialty=create st_specialty
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_treatment_type
this.Control[iCurrent+2]=this.st_treatment_type_title
this.Control[iCurrent+3]=this.st_in_office_flag_title
this.Control[iCurrent+4]=this.st_in_office_flag
this.Control[iCurrent+5]=this.pb_cancel
this.Control[iCurrent+6]=this.sle_description
this.Control[iCurrent+7]=this.st_title
this.Control[iCurrent+8]=this.st_type
this.Control[iCurrent+9]=this.st_title_type
this.Control[iCurrent+10]=this.pb_done
this.Control[iCurrent+11]=this.st_results
this.Control[iCurrent+12]=this.dw_steps
this.Control[iCurrent+13]=this.st_step_desc_title
this.Control[iCurrent+14]=this.st_step_room_title
this.Control[iCurrent+15]=this.cb_add_step
this.Control[iCurrent+16]=this.cb_change_description
this.Control[iCurrent+17]=this.st_step_delay_title
this.Control[iCurrent+18]=this.cb_add_final_step
this.Control[iCurrent+19]=this.pb_1
this.Control[iCurrent+20]=this.pb_up
this.Control[iCurrent+21]=this.st_page
this.Control[iCurrent+22]=this.pb_down
this.Control[iCurrent+23]=this.st_in_office_title
this.Control[iCurrent+24]=this.st_1
this.Control[iCurrent+25]=this.st_specialty_title
this.Control[iCurrent+26]=this.st_specialty
end on

on w_workplan_definition.destroy
call super::destroy
destroy(this.st_treatment_type)
destroy(this.st_treatment_type_title)
destroy(this.st_in_office_flag_title)
destroy(this.st_in_office_flag)
destroy(this.pb_cancel)
destroy(this.sle_description)
destroy(this.st_title)
destroy(this.st_type)
destroy(this.st_title_type)
destroy(this.pb_done)
destroy(this.st_results)
destroy(this.dw_steps)
destroy(this.st_step_desc_title)
destroy(this.st_step_room_title)
destroy(this.cb_add_step)
destroy(this.cb_change_description)
destroy(this.st_step_delay_title)
destroy(this.cb_add_final_step)
destroy(this.pb_1)
destroy(this.pb_up)
destroy(this.st_page)
destroy(this.pb_down)
destroy(this.st_in_office_title)
destroy(this.st_1)
destroy(this.st_specialty_title)
destroy(this.st_specialty)
end on

event close;call super::close;if isvalid(item_attributes) and not isnull(item_attributes) then DESTROY item_attributes
if isvalid(items) and not isnull(items) then DESTROY items
if isvalid(step_rooms) and not isnull(step_rooms) then DESTROY step_rooms

end event

event post_open;call super::post_open;integer li_sts

li_sts = load_workplan()
if li_sts <= 0 then
	log.log(this, "w_workplan_definition.open.0018", "Error loading workplan (" + string(workplan_id) + ")", 4)
	close(this)
	return
end if


end event

type pb_epro_help from w_window_base`pb_epro_help within w_workplan_definition
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_workplan_definition
end type

type st_treatment_type from statictext within w_workplan_definition
integer x = 777
integer y = 312
integer width = 608
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_treatment_type_title from statictext within w_workplan_definition
integer x = 389
integer y = 320
integer width = 379
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Treatment Type:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_in_office_flag_title from statictext within w_workplan_definition
integer x = 1413
integer y = 196
integer width = 521
integer height = 76
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Patient Location:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_in_office_flag from statictext within w_workplan_definition
integer x = 1957
integer y = 180
integer width = 608
integer height = 104
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

type pb_cancel from u_picture_button within w_workplan_definition
integer x = 119
integer y = 1532
integer taborder = 0
boolean bringtotop = true
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

setnull(popup_return.item)
popup_return.item_count = 0
closewithreturn(parent, popup_return)


end event

type sle_description from singlelineedit within w_workplan_definition
integer x = 151
integer y = 444
integer width = 2368
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean displayonly = true
end type

type st_title from statictext within w_workplan_definition
integer width = 2926
integer height = 144
boolean bringtotop = true
integer textsize = -24
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Workplan Definition"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_type from statictext within w_workplan_definition
event clicked pbm_bnclicked
integer x = 439
integer y = 180
integer width = 946
integer height = 104
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

type st_title_type from statictext within w_workplan_definition
integer x = 197
integer y = 196
integer width = 210
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Type:"
alignment alignment = right!
boolean focusrectangle = false
end type

type pb_done from u_picture_button within w_workplan_definition
event clicked pbm_bnclicked
integer x = 2555
integer y = 1532
integer taborder = 40
boolean default = true
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;str_popup_return popup_return
integer li_sts

li_sts = save_changes()
if li_sts <= 0 then return

popup_return.item_count = 1
popup_return.items[1] = string(workplan_id)
popup_return.descriptions[1] = sle_description.text

closewithreturn(parent, popup_return)


end event

type st_results from statictext within w_workplan_definition
integer x = 146
integer y = 564
integer width = 169
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
string text = "Step #"
boolean focusrectangle = false
end type

type dw_steps from u_dw_pick_list within w_workplan_definition
integer x = 142
integer y = 632
integer width = 2565
integer height = 820
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_workplan_step_list"
boolean livescroll = false
end type

event selected;call super::selected;step_menu(selected_row)
clear_selected()


end event

type st_step_desc_title from statictext within w_workplan_definition
integer x = 325
integer y = 564
integer width = 297
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
boolean focusrectangle = false
end type

type st_step_room_title from statictext within w_workplan_definition
integer x = 2199
integer y = 564
integer width = 507
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
string text = "Default Room Type"
boolean focusrectangle = false
end type

type cb_add_step from commandbutton within w_workplan_definition
integer x = 983
integer y = 1588
integer width = 329
integer height = 108
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add Step"
end type

event clicked;str_popup popup
str_popup_return popup_return
long ll_row


popup.title = "Enter new step description"
popup.item = sle_description.text

openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ll_row = dw_steps.insertrow(0)
dw_steps.object.workplan_id[ll_row] = workplan_id
dw_steps.object.step_number[ll_row] = ll_row
dw_steps.object.description[ll_row] = popup_return.items[1]

end event

type cb_change_description from commandbutton within w_workplan_definition
integer x = 2546
integer y = 448
integer width = 256
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Change"
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.title = "Enter new workplan description"
popup.item = sle_description.text

openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

sle_description.text = popup_return.items[1]
description_changed = true

end event

type st_step_delay_title from statictext within w_workplan_definition
integer x = 1627
integer y = 564
integer width = 197
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
string text = "Delay"
boolean focusrectangle = false
end type

type cb_add_final_step from commandbutton within w_workplan_definition
integer x = 1527
integer y = 1588
integer width = 402
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add Final Step"
end type

event clicked;long ll_row

ll_row = dw_steps.insertrow(0)
dw_steps.object.workplan_id[ll_row] = workplan_id
dw_steps.object.step_number[ll_row] = 999
dw_steps.object.description[ll_row] = "Final Step"

enabled = false

end event

type pb_1 from u_pb_help_button within w_workplan_definition
integer x = 2267
integer y = 1644
integer width = 247
integer height = 120
integer taborder = 20
boolean bringtotop = true
end type

type pb_up from u_picture_button within w_workplan_definition
integer x = 2729
integer y = 628
integer width = 137
integer height = 116
integer taborder = 30
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_steps.current_page

dw_steps.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type st_page from statictext within w_workplan_definition
integer x = 2711
integer y = 892
integer width = 174
integer height = 132
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Page 99/99"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_down from u_picture_button within w_workplan_definition
integer x = 2729
integer y = 764
integer width = 137
integer height = 116
integer taborder = 40
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_steps.current_page
li_last_page = dw_steps.last_page

dw_steps.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true


end event

type st_in_office_title from statictext within w_workplan_definition
integer x = 1938
integer y = 564
integer width = 215
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
string text = "In Office"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_workplan_definition
integer x = 151
integer y = 376
integer width = 361
integer height = 72
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Description:"
boolean focusrectangle = false
end type

type st_specialty_title from statictext within w_workplan_definition
integer x = 1413
integer y = 312
integer width = 302
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Specialty:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_specialty from statictext within w_workplan_definition
event clicked pbm_bnclicked
integer x = 1742
integer y = 296
integer width = 1056
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string ls_specialty_id

ls_specialty_id = f_pick_specialty("<None>")
if isnull(ls_specialty_id) then return

if ls_specialty_id = "<None>" then
	text = "<None>"
	setnull(specialty_id)
else
	text = datalist.specialty_description(ls_specialty_id)
	specialty_id = ls_specialty_id
end if

description_changed = true

end event

