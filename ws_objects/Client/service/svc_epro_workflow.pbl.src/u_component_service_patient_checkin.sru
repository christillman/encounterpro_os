$PBExportHeader$u_component_service_patient_checkin.sru
forward
global type u_component_service_patient_checkin from u_component_service
end type
end forward

global type u_component_service_patient_checkin from u_component_service
end type
global u_component_service_patient_checkin u_component_service_patient_checkin

type variables

end variables

forward prototypes
public function integer xx_do_service ()
public function long checkin_patient ()
end prototypes

public function integer xx_do_service ();///////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description:Check in a patient
//
// Returns: 1 - Complete the Service 
//          2 - Cancel the Service
//          0 - No operation[Continue]
//         <0 - Failure
//
// Created By:Sumathi Chinnasamy										Creation dt: 08/07/01
//
// Modified By:															Modified On:
///////////////////////////////////////////////////////////////////////////////////////////////////////

str_stamp lstr_stamp
str_popup popup
str_popup_return popup_return
integer li_sts
long ll_encounter_id
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
string ls_in_office_flag
string ls_encounter_status
string ls_attending_doctor

setnull(ls_null)
setnull(ll_null)

ls_in_office_flag = "Y"

lstr_stamp = f_get_stamp()
if not lstr_stamp.create_encounters then
	f_message(15)
	return 2
end if


// Make sure we have a patient context
lb_my_patient = false
if isnull(current_patient) then
	openwithparm(w_patient_select, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return 2 // cancel
	
	ls_cpr_id = popup_return.items[1]
	
	li_sts = f_set_patient(ls_cpr_id)
	if li_sts < 0 then return 2
	lb_my_patient = true
end if


if gnv_app.cpr_mode = "CLIENT" then
	if isnull(current_patient.date_of_birth) then
		ls_message = "The correct workplan may not be selected because this patient does not have a date-of-birth.  "
		ls_message += "Are you sure you want to create a new encounter without a date-of-birth?"
		openwithparm(w_pop_yes_no, ls_message)
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then	return 2
	end if
	
	openwithparm(service_window, this, "w_checkin_followup_pick")
	window_return = message.powerobjectparm
	if window_return.return_status <= 0 then return window_return.return_status
	if window_return.return_status = 2 then return 2  // Cancel the service
	
	ll_followup_treatment_id = window_return.return_value
else
	// If we're not in client mode then we can't pick a followup
	setnull(ll_followup_treatment_id)
end if


// If the user picked a followup visit then apply some attributes to the service
if not isnull(ll_followup_treatment_id) then
	add_attribute("followup_treatment_id", string(ll_followup_treatment_id))
	
	ls_encounter_type = current_patient.treatments.get_property_value(ll_followup_treatment_id, "encounter_type")
	if len(ls_encounter_type) > 0 then add_attribute("encounter_type", ls_encounter_type)

	ls_ordered_for = current_patient.treatments.get_property_value(ll_followup_treatment_id, "ordered_for")
	if len(ls_ordered_for) > 0 then add_attribute("attending_doctor", ls_ordered_for)
	
//	ls_treatment_description = current_patient.treatments.get_property_value(ll_followup_treatment_id, "treatment_description")
//	if len(ls_treatment_description) > 0 then add_attribute("encounter_description", ls_ordered_for)
end if


// Now perform the patient check-in
ll_encounter_id = checkin_patient()
if ll_encounter_id = -2 then
	return 2 // Cancel service
elseif ll_encounter_id = 0 then
	return 0 // I'll Be Back
elseif ll_encounter_id < 0 then
	return -1  // All other negative returns are treated as an error
end if

// If we get here then we have a valid encounter_id

// If a followup was selected earlier,then log it now
if isnull(ll_followup_treatment_id) then
	// There was no followup selected, so suppress the 
else
	// Log the treatment_id as a property of the encounter
	current_patient.encounters.set_encounter_progress(ll_encounter_id, &
																	"Property", &
																	"followup_treatment_id", &
																	string(ll_followup_treatment_id))
	
	// Log the encounter_id as a property of the followup treatment
	current_patient.treatments.set_treatment_progress(ll_followup_treatment_id, &
																	"Property", &
																	"followup_encounter_id", &
																	string(ll_encounter_id))
	
	// Dispatch the followup workplan
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
			AND e.encounter_id = :ll_encounter_id
		WHERE w.patient_workplan_id = :ll_followup_patient_workplan_id
		AND w.owned_by IS NULL;
		if not tf_check() then return -1
		
		// Then dispatch the first step of the followup workplan
		sqlca.sp_dispatch_workplan_step(cpr_id, &
												ll_followup_patient_workplan_id, &
												1, &
												current_user.user_id, &
												ll_encounter_id, &
												current_scribe.user_id)
		tf_check()
	end if
	
	// Close the followup treatment
	sqlca.sp_set_treatment_progress( cpr_id, & 
												ll_followup_treatment_id, & 
												ll_encounter_id, & 
												"Closed", & 
												ls_null, & 
												ls_null, & 
												datetime(today(), now()), & 
												patient_workplan_item_id, & 
												ll_null, & 
												ll_null, & 
												current_user.user_id, & 
												current_scribe.user_id )
	tf_check()
	
end if

// If we're in CLIENT mode then the user has already been offered the followups.  If there's a Dispatch Followup service out there now then cancel it
if gnv_app.cpr_mode = "CLIENT" then
	ls_followup_check_service = datalist.get_preference("WORKFLOW", "followup_check_service")
	if len(ls_followup_check_service) > 0 then
		SELECT max(patient_workplan_item_id)
		INTO :ll_followup_check_wp_item_id
		FROM p_Patient_WP_Item
		WHERE cpr_id = :cpr_id
		AND encounter_id = :ll_encounter_id
		AND item_type = 'Service'
		AND ordered_service = :ls_followup_check_service
		AND active_service_flag = 'Y';
		
		if ll_followup_check_wp_item_id > 0 then
			sqlca.sp_set_workplan_item_progress(ll_followup_check_wp_item_id, &
															current_user.user_id, &
															"Cancelled", &
															datetime(today(), now()), &
															current_scribe.user_id, &
															gnv_app.computer_id )
			if not tf_check() then return -1
		end if
	end if
end if

// If we want to go ahead and perform the next auto-perform service, do that now
get_attribute("do_autoperform", lb_do_autoperform, true)
if lb_do_autoperform then
	ls_auto_perform_flag = "Y"
	SELECT encounter_status
	INTO :ls_encounter_status
	FROM p_Patient_Encounter
	WHERE cpr_id = :current_patient.cpr_id
	AND encounter_id = :ll_encounter_id;
	if not tf_check() then return -1

	if upper(ls_encounter_status) = "OPEN" then
		ls_in_office_flag = "Y"
	else
		ls_in_office_flag = "N"
	end if
	
	sqlca.sp_get_next_encounter_service_2( &
			current_patient.cpr_id, &
			ll_encounter_id, &
			current_user.user_id, &
			ls_auto_perform_flag, &
			ls_in_office_flag, &
			ll_patient_workplan_item_id)
	if not tf_check() then return 1
	
	if not isnull(ll_patient_workplan_item_id) then
		service_list.do_service(ll_patient_workplan_item_id)
	end if
end if

if lb_my_patient then f_clear_patient()

// Completed
Return 1


end function

public function long checkin_patient ();///////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description:  Prompt user (if needed) and perform the actual checking
//
// Returns: encounter_id for new encounter if successful
//			0 if user selected "I'll Be Back"
//			-1 if error
//			-2 if user cancelled
///////////////////////////////////////////////////////////////////////////////////////////////////////

str_encounter_description lstr_encounter
str_popup popup
str_popup_return popup_return
datetime ldt_one_hour_ago
boolean lb_open_encounter
integer li_sts
long ll_encounter_id
string ls_temp
u_user luo_user
boolean lb_show_screen


ldt_one_hour_ago = datetime(today(), relativetime(now(), -3600))

// Set the defaults for the new encounter
ls_temp = get_attribute("encounter_date")
if isnull(ls_temp) then
	lstr_encounter.encounter_date = datetime(today(), now())
else
	lstr_encounter.encounter_date = datetime(ls_temp)
end if

lstr_encounter.encounter_type = get_attribute("encounter_type")
if isnull(lstr_encounter.encounter_type) then
	lstr_encounter.encounter_type = default_encounter_type
end if

lstr_encounter.indirect_flag = get_attribute("indirect_flag")
if isnull(lstr_encounter.indirect_flag) then
	lstr_encounter.indirect_flag = datalist.encounter_type_default_indirect_flag(lstr_encounter.encounter_type)
end if

lstr_encounter.description = get_attribute("encounter_description")
if isnull(lstr_encounter.description) then
	lstr_encounter.description = datalist.encounter_type_description(lstr_encounter.encounter_type)
end if

lstr_encounter.attending_doctor = get_attribute("attending_doctor")
if isnull(lstr_encounter.attending_doctor) then
	luo_user = user_list.find_user(current_patient.primary_provider_id)
	if not isnull(luo_user) then
		lstr_encounter.attending_doctor = luo_user.user_id
	end if
end if

lstr_encounter.new_flag = get_attribute("new_flag")
if isnull(lstr_encounter.new_flag) then
	lstr_encounter.new_flag = "N"
end if

lstr_encounter.supervising_doctor = user_list.supervisor_user_id(lstr_encounter.attending_doctor)

lstr_encounter.referring_doctor = current_patient.referring_provider_id

lstr_encounter.office_id = gnv_app.office_id
setnull(lstr_encounter.bill_flag)

get_attribute("Show Screen", lb_show_screen, true)
if lb_show_screen then
	Openwithparm(service_window, lstr_encounter, "w_svc_patient_checkin")
	popup_return = Message.powerobjectparm
	if popup_return.item_count <> 1 then return 0

	if (popup_return.items[1] = "COMPLETE") or (popup_return.items[1] = "OK") then
		lstr_encounter = popup_return.returnobject
	elseif popup_return.items[1] = "CANCEL" then
		return 2
	elseif popup_return.items[1] = "DOLATER" then
		return 3
	elseif popup_return.items[1] = "REVERT" then
		return 4
	elseif popup_return.items[1] = "ERROR" then
		return -1
	else
		return 0
	end if

end if

	
lb_open_encounter = true

if lstr_encounter.encounter_date < ldt_one_hour_ago then
	popup.title = "This encounter happened in the past.  Do you wish to:"
	popup.data_row_count = 2
	popup.items[1] = "Chart a Past Encounter"
	popup.items[2] = "Check the patient into the office"
	openwithparm(w_pop_choices_2, popup)
	li_sts = message.doubleparm
	if li_sts = 1 then lb_open_encounter = false
end if

// Create the new encounter
ll_encounter_id = current_patient.new_encounter(lstr_encounter, &
										current_scribe.user_id, &
										lb_open_encounter)
if ll_encounter_id <= 0 then
	log.log(this, "u_component_service_patient_checkin.checkin_patient:0108", "Could not create a new encounter", 4)
	return -1
end if

return ll_encounter_id


end function

on u_component_service_patient_checkin.create
call super::create
end on

on u_component_service_patient_checkin.destroy
call super::destroy
end on

