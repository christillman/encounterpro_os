$PBExportHeader$u_component_service_exit.sru
forward
global type u_component_service_exit from u_component_service
end type
end forward

global type u_component_service_exit from u_component_service
end type
global u_component_service_exit u_component_service_exit

forward prototypes
public function integer xx_do_service ()
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
string ls_encounter_status
string ls_progress
string ls_null
long ll_patient_workplan_item_id
char lc_auto_perform_flag
str_popup popup
str_popup_return popup_return

setnull(ls_null)
setnull(ls_progress)

if isnull(current_patient) then return 1

if isnull(encounter_id) then return 1

// Get the desired encounter status
ls_encounter_status = get_attribute("encounter_status")
if isnull(ls_encounter_status) then
	ls_encounter_status = "CLOSED"
elseif ls_encounter_status = "CANCELLED" then
	// The encounter status canceled only has one "l"
	ls_encounter_status = "CANCELED"
end if

// If the encounter is being closed or cancelled, prompt the user for a reason
if upper(ls_encounter_status) = "CLOSED" or upper(ls_encounter_status) = "CANCELED" then
	if upper(ls_encounter_status) = "CLOSED" then
		popup.title = "Enter reason for closing encounter"
	else
		popup.title = "Enter reason for cancelling encounter"
	end if
	popup.argument_count = 2
	popup.argument[1] = "ENCOUNTER_" + upper(ls_encounter_status)
	popup.argument[2] = ""
	openwithparm(w_pop_prompt_string, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return 1
	
	ls_progress = popup_return.items[1]
end if

// One final warning for deleting an encounter
if upper(ls_encounter_status) = "CANCELED" then
	openwithparm(w_pop_yes_no, "You are about to delete this entire encounter for the patient including all of the chart information recorded during this encounter.  Are you sure that you want to do this?")
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return 1
end if

// See if there are any outstanding services for this encounter
lc_auto_perform_flag = '%'

sqlca.sp_get_next_encounter_service_2( &
		current_patient.cpr_id, &
		encounter_id, &
		ls_null, &
		lc_auto_perform_flag, &
		"Y", &
		ll_patient_workplan_item_id)
if not tf_check() then return 1

if not isnull(ll_patient_workplan_item_id) then
	openwithparm(w_pop_yes_no, "There are unfinished in-office services.  Are you sure you want to continue?")
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return 1
end if

// Set the encounter status
current_patient.encounters.set_encounter_progress(encounter_id, ls_encounter_status, ls_progress)

return 1


end function

on u_component_service_exit.create
call super::create
end on

on u_component_service_exit.destroy
call super::destroy
end on

