$PBExportHeader$u_component_service_dispatch_followup.sru
forward
global type u_component_service_dispatch_followup from u_component_service
end type
end forward

global type u_component_service_dispatch_followup from u_component_service
end type
global u_component_service_dispatch_followup u_component_service_dispatch_followup

forward prototypes
public function integer xx_do_service ()
end prototypes

public function integer xx_do_service ();str_popup_return popup_return
integer li_sts
str_stamp lstr_stamp
str_popup popup
string ls_auto_perform_flag
long ll_patient_workplan_item_id
string ls_message
str_window_return window_return
long ll_followup_treatment_id
string ls_encounter_type
string ls_ordered_for
long ll_followup_patient_workplan_id
boolean lb_my_patient
string ls_cpr_id
boolean lb_do_autoperform
long ll_followup_check_wp_item_id
string ls_followup_check_service
string ls_null
long ll_null

setnull(ls_null)
setnull(ll_null)

openwithparm(service_window, this, "w_checkin_followup_pick")
window_return = message.powerobjectparm
if window_return.return_status <= 0 then return window_return.return_status
if window_return.return_status = 2 then return 2  // User pressed Cancel

if window_return.return_status = 1 and isnull(window_return.return_value) then
	openwithparm(w_pop_message, "There are no outstanding followup treatments")
	return 1
end if

ll_followup_treatment_id = window_return.return_value
if isnull(ll_followup_treatment_id) or ll_followup_treatment_id <= 0 then return 0

add_attribute("followup_treatment_id", string(ll_followup_treatment_id))

ls_encounter_type = current_patient.treatments.get_property_value(ll_followup_treatment_id, "encounter_type")
if len(ls_encounter_type) > 0 then add_attribute("encounter_type", ls_encounter_type)

ls_ordered_for = current_patient.treatments.get_property_value(ll_followup_treatment_id, "ordered_for")
if len(ls_ordered_for) > 0 then add_attribute("attending_doctor", ls_ordered_for)

//	ls_treatment_description = current_patient.treatments.get_property_value(ll_followup_treatment_id, "treatment_description")
//	if len(ls_treatment_description) > 0 then add_attribute("encounter_description", ls_ordered_for)

// Log the treatment_id as a property of the encounter
current_patient.encounters.set_encounter_progress(encounter_id, &
																"Property", &
																"followup_treatment_id", &
																string(ll_followup_treatment_id))
if not tf_check() then return -1

// Log the encounter_id as a property of the followup treatment
current_patient.treatments.set_treatment_progress(ll_followup_treatment_id, &
																"Property", &
																"followup_encounter_id", &
																string(encounter_id))
if not tf_check() then return -1
	
// Find the followup workplan associated with the followup treatment
SELECT max(patient_workplan_id)
INTO :ll_followup_patient_workplan_id
FROM p_Patient_WP
WHERE cpr_id = :cpr_id
AND workplan_type = 'Followup'
AND treatment_id = :ll_followup_treatment_id
AND status = 'Pending';
if not tf_check() then return -1


if ll_followup_patient_workplan_id > 0 then
	// First update the owner of the followup workplan to be the owner of the encounter
	UPDATE w
	SET owned_by = e.attending_doctor
	FROM p_Patient_WP w
		INNER JOIN p_Patient_Encounter e
		ON w.cpr_id = e.cpr_id
		AND e.encounter_id = :encounter_id
	WHERE w.patient_workplan_id = :ll_followup_patient_workplan_id
	AND w.owned_by IS NULL;
	if not tf_check() then return -1
		
	// Then dispatch the first step of the followup workplan
	sqlca.sp_dispatch_workplan_step(cpr_id, &
											ll_followup_patient_workplan_id, &
											1, &
											current_user.user_id, &
											encounter_id, &
											current_scribe.user_id)
	if not tf_check() then return -1
end if

// Close the followup treatment
sqlca.sp_set_treatment_progress( cpr_id, & 
											ll_followup_treatment_id, & 
											encounter_id, & 
											"Closed", & 
											ls_null, & 
											ls_null, & 
											datetime(today(), now()), & 
											patient_workplan_item_id, & 
											ll_null, & 
											ll_null, & 
											current_user.user_id, & 
											current_scribe.user_id )

// Completed
Return 1





end function

on u_component_service_dispatch_followup.create
call super::create
end on

on u_component_service_dispatch_followup.destroy
call super::destroy
end on

