$PBExportHeader$u_component_service_order_assessment.sru
forward
global type u_component_service_order_assessment from u_component_service
end type
end forward

global type u_component_service_order_assessment from u_component_service
end type
global u_component_service_order_assessment u_component_service_order_assessment

forward prototypes
public function integer xx_do_service ()
public function integer pick_new_treatments (str_assessment_description pstr_assessment)
private function integer order_assessment (str_picked_assessment pstr_assessment)
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
string ls_assessment_type
string ls_assessment_id
string ls_list_id
integer li_sts
str_popup popup
str_popup_return popup_return
str_picked_assessments lstr_assessments
str_picked_assessment lstr_assessment
long ll_problem_id
long i
long ll_attachment_id
u_str_assessment luo_assessment

setnull(ll_attachment_id)

ls_assessment_type = get_attribute("assessment_type")
ls_assessment_id = get_attribute("assessment_id")
ls_list_id = get_attribute("list_id")

// If we don't have an assessment_id but we have an assessment_type and a list_id then
// Calculate the appropriate assessment_id for this patient
if isnull(ls_assessment_id) and not isnull(ls_list_id) then
	popup.dataobject = "dw_assessments_by_age_range_list_id"
	popup.argument_count = 2
	popup.argument[1] = current_patient.cpr_id
	popup.argument[2] = ls_list_id
	popup.datacolumn = 1
	popup.displaycolumn = 2
	popup.auto_singleton = true
	
	openwithparm(w_pop_pick, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return 2
	
	ls_assessment_id = popup_return.items[1]
end if

// Then, if we have an assessment_id, then just order it
if not isnull(ls_assessment_id) then
	lstr_assessment.assessment_type = datalist.assessment_assessment_type(ls_assessment_id)
	lstr_assessment.assessment_id = ls_assessment_id
	lstr_assessment.description = datalist.assessment_description(ls_assessment_id)
	setnull(lstr_assessment.begin_date)
	setnull(lstr_assessment.end_date)
	lstr_assessment.leave_open = true
	
	li_sts = order_assessment(lstr_assessment)
	if li_sts < 0 then return -1
	
	return 1
end if

// Otherwise, just let the user pick the assessment(s)
popup.data_row_count = 2
popup.items[1] = ls_assessment_type
popup.items[2] = string(encounter_id)

openwithparm(service_window, popup, "w_pick_assessments")
lstr_assessments = message.powerobjectparm
if lstr_assessments.assessment_count = 0 then
	if not manual_service then
		popup.data_row_count = 2
		popup.items[1] = "I'll Be Back"
		popup.items[2] = "I'm Finished"
		openwithparm(w_pop_pick, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then
			return 0
		else
			if popup_return.item_indexes[1] = 1 then
				return 0
			else
				return 1
			end if
		end if
	end if
end if

for i = 1 to lstr_assessments.assessment_count
	li_sts = order_assessment(lstr_assessments.assessments[i])
	if li_sts < 0 then return -1
next

return 1


end function

public function integer pick_new_treatments (str_assessment_description pstr_assessment);str_popup popup
str_popup_return popup_return
string ls_message
str_attributes lstr_attributes
integer li_sts
string ls_new_treatment_service
string ls_null
date ld_onset
date ld_duration

setnull(ls_null)

ld_onset = date(pstr_assessment.begin_date)
ld_duration = date(pstr_assessment.end_date)

ls_new_treatment_service = get_attribute("new_treatment_service")
if isnull(ls_new_treatment_service) then ls_new_treatment_service = "ORDERTREATMENT"

lstr_attributes.attribute_count = 2
lstr_attributes.attribute[1].attribute = "problem_id"
lstr_attributes.attribute[1].value = string(pstr_assessment.problem_id)
lstr_attributes.attribute[2].attribute = "mode"
if is_encounter_open() then
	lstr_attributes.attribute[2].value = "NEW"
else
	lstr_attributes.attribute[2].value = "PAST"
end if

if not isnull(ld_onset) then
	lstr_attributes.attribute_count += 1
	lstr_attributes.attribute[lstr_attributes.attribute_count].attribute = "onset"
	lstr_attributes.attribute[lstr_attributes.attribute_count].value = string(ld_onset, date_format_string)
end if

if not isnull(ld_duration) then
	lstr_attributes.attribute_count += 1
	lstr_attributes.attribute[lstr_attributes.attribute_count].attribute = "duration"
	lstr_attributes.attribute[lstr_attributes.attribute_count].value = string(ld_duration, date_format_string)
end if

li_sts = service_list.do_service(current_patient.cpr_id, &
											current_patient.open_encounter_id, &
											ls_new_treatment_service, &
											lstr_attributes)

// If service was cancelled then see if the user wants to cancel the assessment too
if li_sts = 2 then
	ls_message = "Do you wish to cancel the '" + pstr_assessment.assessment + "' assessment?"
	openwithparm(w_pop_yes_no, ls_message)
	popup_return = message.powerobjectparm
	if popup_return.item = "YES" then
		current_patient.assessments.set_progress(pstr_assessment.problem_id, &
																pstr_assessment.diagnosis_sequence, &
																"CANCELLED", &
																ls_null, &
																ls_null, &
																pstr_assessment.begin_date)
		return 2 // assessment cancelled
	end if
end if

return 1


end function

private function integer order_assessment (str_picked_assessment pstr_assessment);integer li_sts
long ll_problem_id
long ll_attachment_id
//u_str_assessment luo_assessment
long ll_menu_id
str_attributes lstr_attributes
str_assessment_description lstr_assessment
string ls_null
u_ds_data luo_encounter_charges
long ll_charges
long ll_row
string ls_find
long ll_encounter_charge_id

setnull(ls_null)
setnull(ll_attachment_id)

ll_problem_id = current_patient.assessments.add_assessment( &
																				current_patient.open_encounter_id, &
																				pstr_assessment.assessment_type, &
																				pstr_assessment.assessment_id, &
																				pstr_assessment.description, &
																				ll_attachment_id, &
																				datetime(pstr_assessment.begin_date, now()), &
																				current_user.user_id, &
																				pstr_assessment.location, &
																				current_scribe.user_id &
																				)

li_sts = current_patient.assessments.assessment(lstr_assessment, ll_problem_id)
if li_sts <= 0 then
	log.log(this, "order_assessment()", "New assessment not found (" + string(ll_problem_id) + ")", 4)
	return -1
end if

// If the current encounter is open then see if there are any billed treatments
// which need connecting to an assessemnt
if not isnull(current_patient.open_encounter) then
	if upper(current_patient.open_encounter.encounter_status) = "OPEN" then
		luo_encounter_charges = CREATE u_ds_data
		luo_encounter_charges.set_dataobject("dw_encounter_charges")
		ll_charges = luo_encounter_charges.retrieve(current_patient.cpr_id, current_patient.open_encounter.encounter_id)
		ls_find = "isnull(problem_id) and upper(bill_flag) = 'Y'"
		ll_row = luo_encounter_charges.find(ls_find, 1, ll_charges)
		DO WHILE ll_row > 0 and ll_row <= ll_charges
			// We found a billable treatment that is not associated with a charge.  Now
			// associate it with this assessment
			ll_encounter_charge_id = luo_encounter_charges.object.encounter_charge_id[ll_row]
			
			INSERT INTO p_Encounter_Assessment_Charge (
					cpr_id,
					encounter_id,
					problem_id,
					encounter_charge_id,
					bill_flag,
					created_by)
			VALUES (
					:current_patient.cpr_id,
					:current_patient.open_encounter.encounter_id,
					:ll_problem_id,
					:ll_encounter_charge_id,
					'Y',
					:current_scribe.user_id);
			if not tf_check() then return -1
			
			ll_row = luo_encounter_charges.find(ls_find, ll_row + 1, ll_charges + 1)
		LOOP
		
		DESTROY luo_encounter_charges
	end if
end if

get_attribute("menu_id", ll_menu_id)
if isnull(ll_menu_id) then ll_menu_id = f_get_context_menu("Order Assmnt", pstr_assessment.assessment_type)
if isnull(ll_menu_id) then
	pick_new_treatments(lstr_assessment)
else
	lstr_attributes.attribute_count = 1
	lstr_attributes.attribute[1].attribute = "problem_id"
	lstr_attributes.attribute[1].value = string(ll_problem_id)
	f_display_menu_with_attributes(ll_menu_id, true, lstr_attributes)
end if

// Get the latest state of the open assessment
li_sts = current_patient.assessments.assessment(lstr_assessment, ll_problem_id)
if li_sts > 0 and isnull(lstr_assessment.assessment_status) then
	// If the assessment is still open check to see if we should close it
	if not isnull(pstr_assessment.end_date) or not pstr_assessment.leave_open then
		// If the assessment has an end date or if the leave_open flag is false then close the assessment
		if isnull(pstr_assessment.end_date) then pstr_assessment.end_date = pstr_assessment.begin_date
		current_patient.assessments.set_progress(ll_problem_id, &
																lstr_assessment.diagnosis_sequence, &
																"CLOSED", &
																ls_null, &
																ls_null, &
																datetime(pstr_assessment.end_date, time("")))
	end if
end if

return 1


end function

on u_component_service_order_assessment.create
call super::create
end on

on u_component_service_order_assessment.destroy
call super::destroy
end on

