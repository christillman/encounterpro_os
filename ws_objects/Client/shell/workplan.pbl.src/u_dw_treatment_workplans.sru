$PBExportHeader$u_dw_treatment_workplans.sru
forward
global type u_dw_treatment_workplans from u_dw_pick_list
end type
end forward

global type u_dw_treatment_workplans from u_dw_pick_list
integer width = 2482
integer height = 1220
string dataobject = "dw_patient_workplan_display"
end type
global u_dw_treatment_workplans u_dw_treatment_workplans

type variables
u_ds_data workplans
u_ds_data workplan_items

long treatment_id


end variables

forward prototypes
public function integer display_workplans (long pl_treatment_id)
public function integer display_workplans (long pl_treatment_id, string ps_workplan_type)
end prototypes

public function integer display_workplans (long pl_treatment_id);string ls_workplan_type

setnull(ls_workplan_type)

return display_workplans(pl_treatment_id, ls_workplan_type)


end function

public function integer display_workplans (long pl_treatment_id, string ps_workplan_type);integer li_item_count
integer li_workplan_count
long ll_patient_workplan_id
string ls_workplan_icon
string ls_workplan_description
integer li_last_step_dispatched
integer li_step_number
string ls_step_description
string ls_step_status
string ls_item_icon
string ls_item_description
string ls_status
string ls_item_status
long i
string ls_filter
long j
long ll_row

// step status = Complete, Dispatched, Pending
// item status = Complete, Dispatched, Pending, Cancelled

treatment_id = pl_treatment_id

setredraw(false)
reset()

li_workplan_count = workplans.retrieve(current_patient.cpr_id, treatment_id)
if li_workplan_count < 0 then return -1

// Now filter for the selected workplan type
if isnull(ps_workplan_type) then
	ls_filter = ""
else
	ls_filter = "workplan_type='" + ps_workplan_type + "'"
end if

workplans.setfilter(ls_filter)
workplans.filter()
li_workplan_count = workplans.rowcount()
if li_workplan_count = 0 then
	ll_row = insertrow(0)
	object.workplan_description[ll_row] = "No " + ps_workplan_type + " Workplans"
	setredraw(true)
	return 0
end if

li_item_count = workplan_items.retrieve(current_patient.cpr_id, treatment_id)
if li_item_count < 0 then return -1

for i = 1 to li_workplan_count
	ll_patient_workplan_id = workplans.object.patient_workplan_id[i]
	ls_workplan_description = workplans.object.description[i]
	li_last_step_dispatched = workplans.object.last_step_dispatched[i]
//	ls_workplan_icon = 
	ls_filter = "patient_workplan_id=" + string(ll_patient_workplan_id)
	workplan_items.setfilter(ls_filter)
	workplan_items.filter()
	li_item_count = workplan_items.rowcount()
	if li_item_count = 0 then
		ll_row = insertrow(0)
		object.patient_workplan_id[ll_row] = ll_patient_workplan_id
		object.workplan_description[ll_row] = ls_workplan_description
		object.workplan_icon[ll_row] = ls_workplan_icon
		object.item_icon[ll_row] = ls_item_icon
		object.item_description[ll_row] = "No Workplan Items"
	else
		for j = 1 to li_item_count
			li_step_number = workplan_items.object.step_number[j]

			if li_step_number <= 0 or isnull(li_step_number) then
				setnull(li_step_number)
				ls_step_description = "Unordered Workplan Items"
			else
				ls_step_description = "Step # " + string(li_step_number)
			end if
			
			if isnull(li_step_number) then
				setnull(ls_step_status)
			elseif li_step_number < li_last_step_dispatched then
				ls_step_status = "Complete"
			elseif li_step_number = li_last_step_dispatched then
				ls_step_status = "Dispatched"
			else
				ls_step_status = "Pending"
			end if
			
//			ls_item_icon = 
			ls_item_description = workplan_items.object.description[j]
			ls_status = workplan_items.object.status[j]
			if upper(ls_status) = "COMPLETED" then
				ls_item_status = "Complete"
			elseif ls_status = "CANCELLED" then
				ls_item_status = "Cancelled"
			elseif isnull(ls_status) then
				ls_item_status = "Pending"
			else
				ls_item_status = "Dispatched"
			end if
				
				
			ll_row = insertrow(0)
			object.patient_workplan_id[ll_row] = ll_patient_workplan_id
			object.workplan_description[ll_row] = ls_workplan_description
			object.workplan_icon[ll_row] = ls_workplan_icon
			object.step_number[ll_row] = li_step_number
			object.step_description[ll_row] = ls_step_description
			object.step_status[ll_row] = ls_step_status
			object.item_icon[ll_row] = ls_item_icon
			object.item_description[ll_row] = ls_item_description
			object.item_status[ll_row] = ls_item_status
			
		next
	end if
next

sort()
groupcalc()

setredraw(true)

return 1

end function

on u_dw_treatment_workplans.create
end on

on u_dw_treatment_workplans.destroy
end on

event constructor;call super::constructor;workplans = CREATE u_ds_data
workplans.set_dataobject("dw_treatment_workplans")

workplan_items = CREATE u_ds_data
workplan_items.set_dataobject("dw_treatment_workplan_items")

end event

event destructor;call super::destructor;DESTROY workplans
DESTROY workplan_items

end event

