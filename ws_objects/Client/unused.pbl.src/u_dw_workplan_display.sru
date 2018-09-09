$PBExportHeader$u_dw_workplan_display.sru
forward
global type u_dw_workplan_display from u_dw_pick_list
end type
end forward

global type u_dw_workplan_display from u_dw_pick_list
integer width = 2482
integer height = 1220
string dataobject = "dw_patient_workplan_display"
boolean vscrollbar = true
end type
global u_dw_workplan_display u_dw_workplan_display

type variables
u_ds_data workplans
u_ds_data workplan_items

long patient_workplan_id
str_context context
//string context_object
//long object_key

end variables

forward prototypes
public function integer display_workplans (long pl_patient_workplan_id)
public function integer refresh ()
public subroutine set_workplan (long pl_patient_workplan_id)
public subroutine set_manual_services (str_context pstr_context)
end prototypes

public function integer display_workplans (long pl_patient_workplan_id);patient_workplan_id = pl_patient_workplan_id

return refresh()

end function

public function integer refresh ();integer li_item_count
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
string ls_user_id
string ls_user_short_name
long ll_user_color
long i
string ls_filter
long j
long ll_row
long ll_patient_workplan_item_id

// step status = Complete, Dispatched, Pending
// item status = Complete, Dispatched, Pending, Cancelled

setredraw(false)
reset()

if isnull(patient_workplan_id) then
	li_workplan_count = workplans.retrieve(context.context_object, context.object_key)
	if li_workplan_count < 0 then return -1
else
	li_workplan_count = workplans.retrieve(patient_workplan_id)
	if li_workplan_count < 0 then return -1
end if

li_item_count = workplan_items.retrieve(patient_workplan_id)
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
				li_step_number = 9999
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
			ll_patient_workplan_item_id = workplan_items.object.patient_workplan_item_id[j]
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
				
			ls_user_id = workplan_items.object.owned_by[j]
			if isnull(ls_user_id) then ls_user_id = workplan_items.object.ordered_for[j]
			if isnull(ls_user_id) then
				ll_user_color = color_object
				ls_user_short_name = ""
			else
				ll_user_color = user_list.user_color(ls_user_id)
				ls_user_short_name = user_list.user_short_name(ls_user_id)
				if ls_item_status = "Dispatched" then
					ll_user_color = user_list.user_color(ls_user_id)
				else
					ll_user_color = color_object
				end if
			end if
			
			ll_row = insertrow(0)
			object.patient_workplan_id[ll_row] = ll_patient_workplan_id
			object.patient_workplan_item_id[ll_row] = ll_patient_workplan_item_id
			object.workplan_description[ll_row] = ls_workplan_description
			object.workplan_icon[ll_row] = ls_workplan_icon
			object.step_number[ll_row] = li_step_number
			object.step_description[ll_row] = ls_step_description
			object.step_status[ll_row] = ls_step_status
			object.item_icon[ll_row] = ls_item_icon
			object.item_description[ll_row] = ls_item_description
			object.item_status[ll_row] = ls_item_status
			object.user_short_name[ll_row] = ls_user_short_name
			object.user_color[ll_row] = ll_user_color			
		next
	end if
next

sort()
groupcalc()

setredraw(true)

return 1

end function

public subroutine set_workplan (long pl_patient_workplan_id);
patient_workplan_id = pl_patient_workplan_id

setnull(context.cpr_id)
setnull(context.context_object)
setnull(context.object_key)

dataobject = "dw_patient_workplan_display"
settransobject(sqlca)

end subroutine

public subroutine set_manual_services (str_context pstr_context);
setnull(patient_workplan_id)
context = pstr_context

dataobject = "dw_sp_patient_object_manual_services"
settransobject(sqlca)


end subroutine

on u_dw_workplan_display.create
call super::create
end on

on u_dw_workplan_display.destroy
call super::destroy
end on

event constructor;call super::constructor;workplans = CREATE u_ds_data
workplans.set_dataobject("dw_patient_workplan_list")

workplan_items = CREATE u_ds_data
workplan_items.set_dataobject("dw_p_patient_wp_item")

end event

event destructor;call super::destructor;DESTROY workplans
DESTROY workplan_items

end event

event selected;call super::selected;long ll_patient_workplan_item_id

ll_patient_workplan_item_id = object.patient_workplan_item_id[selected_row]

if ll_patient_workplan_item_id > 0 then
	f_display_service_menu(ll_patient_workplan_item_id)
	refresh()
end if


end event

