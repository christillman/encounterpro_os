$PBExportHeader$u_component_service_order_workplan.sru
forward
global type u_component_service_order_workplan from u_component_service
end type
end forward

global type u_component_service_order_workplan from u_component_service
end type
global u_component_service_order_workplan u_component_service_order_workplan

forward prototypes
public function integer xx_do_service ()
public function long pick_workplan ()
end prototypes

public function integer xx_do_service ();///////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description: Closes current open encounter
//
// Returns: 1 - Complete the Service 
//          2 - Cancel the Service
//          0 - No operation[Continue]
//
// Created By:Sumathi Chinnasamy										Creation dt: 11/30/2000
//
// Modified By:															Modified On:
///////////////////////////////////////////////////////////////////////////////////////////////////////

u_component_treatment luo_treatment
integer li_sts
long i
long ll_null
datetime ldt_null
long ll_workplan_id
long ll_patient_workplan_id
long ll_problem_id
long ll_treatment_id
long ll_observation_sequence
long ll_attachment_id
string ls_mode
string ls_ordered_for
string ls_dispatch_flag
long ll_parent_patient_workplan_item_id
string ls_description
string ls_in_office_flag
string ls_encounter_status
string ls_prompt
str_popup_return popup_return
long ll_patient_workplan_item_id


setnull(ls_description)
setnull(ll_null)
setnull(ldt_null)

get_attribute("workplan_id", ll_workplan_id)
if isnull(ll_workplan_id) then
	ll_workplan_id = pick_workplan()
	if isnull(ll_workplan_id) then
		mylog.log(this, "xx_do_service()", "No workplan_id", 4)
		return 2  // Cancel service
	end if
end if

SELECT in_office_flag
INTO :ls_in_office_flag
FROM c_Workplan
WHERE workplan_id = :ll_workplan_id;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then
	mylog.log(this, "xx_do_service()", "workplan_id not found (" + string(ll_workplan_id) + ")", 4)
	return 2
end if

if upper(ls_in_office_flag) = "Y" then
	if isnull(encounter_id) then
		mylog.log(this, "xx_do_service()", "An in-office workplan cannot be ordered without an encounter context", 4)
		return 2
	end if
	ls_encounter_status = current_patient.encounters.encounter_status(encounter_id)
	if upper(ls_encounter_status) = "CLOSED" then
		if cpr_mode = "CLIENT" then
			ls_prompt = "You are attempting to order an in-office workplan when the associated encounter is already closed."
			ls_prompt += "  Do you wish to re-open the encounter?"
			openwithparm(w_pop_yes_no, ls_prompt)
			popup_return = message.powerobjectparm
			if popup_return.item <> "YES" then
				return 2
			end if
		else
			mylog.log(this, "xx_do_service()", "An in-office workplan cannot be ordered when the encounter is closed", 4)
			return 2
		end if
	end if
end if

if isnull(treatment) then
	setnull(ll_treatment_id)
else
	ll_treatment_id = treatment.treatment_id
end if

get_attribute("ordered_for", ls_ordered_for)
if isnull(ls_ordered_for) then ls_ordered_for = current_user.user_id

get_attribute("problem_id", ll_problem_id)
get_attribute("observation_sequence", ll_observation_sequence)
get_attribute("attachment_id", ll_attachment_id)
get_attribute("mode", ls_mode)
get_attribute("dispatch_flag", ls_dispatch_flag)
if isnull(ls_dispatch_flag) then ls_dispatch_flag = "Y"

cprdb.sp_order_workplan( &
		current_patient.cpr_id, &
		ll_workplan_id, &
		encounter_id, &
		ll_problem_id, &
		ll_treatment_id, &
		ll_observation_sequence, &
		ll_attachment_id, &
		ls_description, &
		current_user.user_id, &
		ls_ordered_for, &
		ls_in_office_flag, &
		ls_mode, &
		patient_workplan_item_id, &
		current_scribe.user_id, &
		ls_dispatch_flag, &
		ll_patient_workplan_id)
if not cprdb.check() then return -1

if ll_patient_workplan_id > 0 then
	sqlca.sp_Get_Next_Workplan_Autoperform_Service(current_patient.cpr_id, ll_patient_workplan_id, current_user.user_id, ll_patient_workplan_item_id)
	if ll_patient_workplan_item_id > 0 then
		service_list.do_service(ll_patient_workplan_item_id)
	end if
end if

return 1


end function

public function long pick_workplan ();w_pick_workplan lw_window
str_c_workplan lstr_workplan
str_workplan_context lstr_workplan_context

lstr_workplan_context.context_object = get_attribute("workplan_context_object")
if isnull(lstr_workplan_context.context_object) then
	lstr_workplan_context.context_object = context_object
end if

lstr_workplan_context.in_office_flag = get_attribute("workplan_in_office_flag")
if isnull(lstr_workplan_context.in_office_flag) then
	lstr_workplan_context.in_office_flag = in_office_flag
end if

lstr_workplan_context.top_20_prefix = get_attribute("top_20_prefix")

openwithparm(lw_window, lstr_workplan_context, "w_pick_workplan")
lstr_workplan = message.powerobjectparm

return lstr_workplan.workplan_id

end function

on u_component_service_order_workplan.create
call super::create
end on

on u_component_service_order_workplan.destroy
call super::destroy
end on

