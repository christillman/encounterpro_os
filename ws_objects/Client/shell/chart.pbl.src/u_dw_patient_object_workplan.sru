$PBExportHeader$u_dw_patient_object_workplan.sru
forward
global type u_dw_patient_object_workplan from u_dw_pick_list
end type
end forward

global type u_dw_patient_object_workplan from u_dw_pick_list
integer width = 1266
integer height = 1220
string dataobject = "dw_patient_object_workplan"
boolean vscrollbar = true
end type
global u_dw_patient_object_workplan u_dw_patient_object_workplan

type variables
u_ds_data workplan
long patient_workplan_id

end variables

forward prototypes
public function integer display_workplan (long pl_patient_workplan_id)
public function integer display_workplan_level (long pl_row)
public function integer display_workplan ()
end prototypes

public function integer display_workplan (long pl_patient_workplan_id);
patient_workplan_id = pl_patient_workplan_id

return display_workplan()

end function

public function integer display_workplan_level (long pl_row);long ll_count
long ll_patient_workplan_item_id
string ls_description
long ll_level
integer li_step_number
long ll_row
long ll_patient_workplan_id
long ll_child_patient_workplan_id
string ls_find
string ls_owned_by
string ls_item_status
long ll_row2
long ll_my_level
long ll_my_patient_workplan_id
long ll_new_row
integer li_sts
long ll_null
boolean lb_single_child
long ll_display_row
long ll_color
string ls_user_initials
long ll_minutes

setnull(ll_null)

ll_count = workplan.rowcount()

// The currently displayed row is always the last row when we enter this method
ll_display_row = rowcount()

if pl_row <= 0 or pl_row > ll_count then return -1

// If there are no more rows then we're done
if pl_row = ll_count then return 1

// Get my level and workplan
ll_my_level = workplan.object.level[pl_row]
ll_my_patient_workplan_id = workplan.object.child_patient_workplan_id[pl_row]
ls_find = "level=" + string(ll_my_level + 1)
ls_find += " and patient_workplan_id=" + string(ll_my_patient_workplan_id)

// If we don't have a child_patient_workplan_id then we're done
if isnull(ll_my_patient_workplan_id) or ll_my_patient_workplan_id <= 0 then return 0

// Now we're going to find out if this parent has a single child.  If so, then
// we're going to merge the child into the parent

// If there isn't another row matching our find string, then we're done
ll_row = workplan.find(ls_find, pl_row + 1, ll_count + 1)
if ll_row <= 0 or ll_row > ll_count then return 1

if ll_display_row > 0 then
	// Now see if there is a second matching record
	ll_row2 = workplan.find(ls_find, ll_row + 1, ll_count + 1)
	if ll_row2 <= 0 or ll_row2 > ll_count then
		// There wasn't a second record so we know we have only one child
		ll_patient_workplan_item_id = workplan.object.patient_workplan_item_id[ll_row]
		ll_child_patient_workplan_id = workplan.object.child_patient_workplan_id[ll_row]
		ls_description = workplan.object.description[ll_row]
		ls_owned_by = workplan.object.owned_by[ll_row]
		ls_item_status = workplan.object.item_status[ll_row]
		ll_minutes = workplan.object.minutes[ll_row]
		
		object.patient_workplan_item_id[ll_display_row] = ll_patient_workplan_item_id
		object.description[ll_display_row] = ls_description
		object.status[ll_display_row] = ls_item_status
		object.child_patient_workplan_id[ll_display_row] = ll_child_patient_workplan_id
		ll_color = user_list.user_color(ls_owned_by)
		object.owner_color[ll_display_row] = ll_color
		ls_user_initials = user_list.user_initial(ls_owned_by)
		object.owner_initials[ll_display_row] = ls_user_initials
		object.minutes[ll_display_row] = ll_minutes
	
		// If this child has children, then recursively call ourselves to display them
		if ll_child_patient_workplan_id > 0 then
			li_sts = display_workplan_level(ll_row)
		end if
		return 1
	end if
end if

DO WHILE ll_row > 0 and ll_row <= ll_count
	// Get the info for this row
	ll_level = workplan.object.level[ll_row]
	ll_patient_workplan_id = workplan.object.patient_workplan_id[ll_row]
	ll_child_patient_workplan_id = workplan.object.child_patient_workplan_id[ll_row]
	ll_patient_workplan_item_id = workplan.object.patient_workplan_item_id[ll_row]
	li_step_number = workplan.object.step_number[ll_row]
	ls_description = workplan.object.description[ll_row]
	ls_owned_by = workplan.object.owned_by[ll_row]
	ls_item_status = workplan.object.item_status[ll_row]
	ll_minutes = workplan.object.minutes[ll_row]
	
	// Make the new display row
	ll_new_row = insertrow(0)
	object.level[ll_new_row] = ll_level
	object.patient_workplan_item_id[ll_new_row] = ll_patient_workplan_item_id
	object.step_number[ll_new_row] = li_step_number
	object.description[ll_new_row] = ls_description
	object.status[ll_new_row] = ls_item_status
	object.child_patient_workplan_id[ll_new_row] = ll_child_patient_workplan_id
	object.owner_color[ll_new_row] = user_list.user_color(ls_owned_by)
	object.owner_initials[ll_new_row] = user_list.user_initial(ls_owned_by)
	object.minutes[ll_new_row] = ll_minutes
	
	// If this record has children, then recursively call ourselves to display them
	if ll_child_patient_workplan_id > 0 then
		li_sts = display_workplan_level(ll_row)
	end if
		
	ll_row = workplan.find(ls_find, ll_row + 1, ll_count + 1)
LOOP

return 1

end function

public function integer display_workplan ();long ll_count
string ls_description
long ll_level
integer li_sts

if isnull(workplan) or not isvalid(workplan) then
	workplan = CREATE u_ds_data
end if

workplan.set_dataobject("dw_jmj_workplan_item_status")
ll_count = workplan.retrieve(patient_workplan_id)

setredraw(false)
reset()

object.compute_status.x = width - 820

if ll_count > 0 then
	ll_level = workplan.object.level[1]
	if ll_level = 0 then
		ls_description = workplan.object.description[1]
		object.t_title.text = ls_description
		li_sts = display_workplan_level(1)
	else
		log.log(this, "display_workplan()", "First record isn't root", 4)
		li_sts = -1
	end if
elseif ll_count < 0 then
	li_sts = -1
else
	li_sts = 0
end if	

setredraw(true)

return li_sts


end function

on u_dw_patient_object_workplan.create
call super::create
end on

on u_dw_patient_object_workplan.destroy
call super::destroy
end on

event constructor;call super::constructor;workplan = CREATE u_ds_data
end event

event selected;call super::selected;long ll_patient_workplan_item_id

ll_patient_workplan_item_id = object.patient_workplan_item_id[selected_row]

if ll_patient_workplan_item_id > 0 then
	f_display_service_menu(ll_patient_workplan_item_id)
	display_workplan()
end if


end event

