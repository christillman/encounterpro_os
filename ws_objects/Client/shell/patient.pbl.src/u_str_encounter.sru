$PBExportHeader$u_str_encounter.sru
forward
global type u_str_encounter from nonvisualobject
end type
end forward

global type u_str_encounter from nonvisualobject
end type
global u_str_encounter u_str_encounter

type variables
long encounter_id
string encounter_type
long patient_workplan_id
string new_flag
string encounter_status
datetime encounter_date
string encounter_description
string patient_class
string patient_location
string next_patient_location
string admission_type
string attending_doctor
string referring_doctor
string supervising_doctor
string ambulatory_status
string vip_indicator
string charge_price_ind
string courtesy_code
string discharge_disp
datetime discharge_date
string admit_reason
string indirect_flag
u_attachment_list attachment_list
string billing_note
long encounter_billing_id
string bill_flag
string billing_hold_flag
boolean billing_posted
string encounter_office_id
string created_by

boolean exists
boolean updated
boolean deleted

u_patient parent_patient


end variables

forward prototypes
public subroutine edit_objective ()
public function u_user provider ()
public function boolean any_new_rx ()
public function boolean any_new_user_rx (string ps_user_id)
public function boolean check_rx_signature ()
public function integer get_billing (ref str_encounter_assessment pstra_assessment[], ref integer pi_assessment_count)
public function boolean any_encounter_procs ()
public function boolean is_posted ()
public function integer retry_posting ()
public function integer set_billing_procedure ()
public function integer get_billing_treatments (long pl_problem_id, ref str_encounter_charge pstra_charge[], ref integer pi_charge_count)
public function long find_service (string ps_service)
public function integer get_numeric_objective_result (long pl_treatment_id, string ps_observation_id, string ps_location, integer pi_result_sequence, ref real pr_result_amount, ref string ps_result_unit)
public function integer get_assessments (ref str_encounter_assessment pstra_assessment[], ref integer pi_assessment_count)
public function integer set_numeric_objective_result (long pl_treatment_id, string ps_observation_id, integer pi_result_sequence, string ps_location, real pr_result_amount)
public function integer save_attachment ()
public function integer set_billing_procedure (boolean pb_replace)
public function integer cancel_treatment (long pl_treatment_id)
public function integer do_treatment (long pl_treatment_id)
public function integer print (string ps_report_id)
public subroutine pick_observations (string ps_observation_type, string ps_observation_category_id, integer pi_objective_set)
public function integer pick_results (long pl_treatment_id, string ps_observation_id)
public function integer do_service (string ps_service)
public function integer do_service (string ps_service, integer pi_attribute_count, string psa_attributes[], string psa_values[])
public function long order_service (string ps_service, string ps_description, string ps_ordered_for)
public function long order_service (string ps_service, string ps_description, string ps_ordered_for, integer pi_attribute_count, string psa_attributes[], string psa_values[])
public function long order_service (string ps_service)
public subroutine do_options ()
public function integer change_room (string ps_room_id)
public function integer add_finding (string ps_finding_list, string ps_finding)
public function string room_menu ()
public function integer order_encounter_workplan ()
public function integer close_old ()
public function boolean any_unfinished_services_old ()
end prototypes

public subroutine edit_objective ();str_popup popup
string buttons[]
integer button_pressed

popup.button_count = 0

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button01.bmp"
	popup.button_helps[popup.button_count] = "Physical Exams"
	popup.button_titles[popup.button_count] = "Exam"
	buttons[popup.button_count] = "EXAMS"
end if

if encounter_status = "OPEN" and not current_patient.display_only then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button02.bmp"
	popup.button_helps[popup.button_count] = "Labs and Other Diagnostic Tests"
	popup.button_titles[popup.button_count] = "Tests"
	buttons[popup.button_count] = "LABS"
end if

if encounter_status = "OPEN" and not current_patient.display_only then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button25.bmp"
	popup.button_helps[popup.button_count] = "Vital Signs"
	popup.button_titles[popup.button_count] = "Vitals"
	buttons[popup.button_count] = "VITALS"
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
	openwithparm(w_pop_buttons, popup)
	button_pressed = message.doubleparm
	if button_pressed < 1 then return
elseif popup.button_count = 1 then
	button_pressed = 1
else
	return
end if

//CHOOSE CASE buttons[button_pressed]
//	CASE "EXAMS"
//		this.pick_exams()
//	CASE "LABS"
//		this.pick_labs()
//	CASE "VITALS"
//		popup.data_row_count = 1
//		setnull(popup.items[1])
//		openwithparm(w_do_vitals, popup)
////		if isvalid(w_cpr_main) then
////			w_cpr_main.uo_vital_display.set_values()
////			w_cpr_main.st_chief_complaint.text = current_patient.open_encounter.chief_complaint
////			current_display_encounter.chief_complaint = current_patient.open_encounter.chief_complaint
////		end if
//	CASE "CANCEL"
//		return
//	CASE ELSE
//END CHOOSE



end subroutine

public function u_user provider ();return user_list.find_user(attending_doctor)

end function

public function boolean any_new_rx ();integer li_rx_count

 DECLARE lsp_check_new_rx PROCEDURE FOR dbo.sp_check_new_rx  
         @ps_cpr_id = :current_patient.cpr_id,   
         @pl_encounter_id = :encounter_id,   
         @pi_new_rx_count = :li_rx_count OUT ;

EXECUTE lsp_check_new_rx;
if not tf_check() then return false
	
FETCH lsp_check_new_rx INTO :li_rx_count;
if not tf_check() then return false
	
CLOSE lsp_check_new_rx;
	
if li_rx_count > 0 then return true

return false


end function

public function boolean any_new_user_rx (string ps_user_id);integer li_rx_count

 DECLARE lsp_check_new_user_rx PROCEDURE FOR dbo.sp_check_new_user_rx  
         @ps_cpr_id = :current_patient.cpr_id,   
         @pl_encounter_id = :encounter_id, 
			@ps_user_id = :ps_user_id,
         @pi_new_user_rx_count = :li_rx_count OUT ;

EXECUTE lsp_check_new_user_rx;
if not tf_check() then return false
	
FETCH lsp_check_new_user_rx INTO :li_rx_count;
if not tf_check() then return false
	
CLOSE lsp_check_new_user_rx;
	
if li_rx_count > 0 then return true

return false


end function

public function boolean check_rx_signature ();boolean lb_rx_signature
integer li_log_index
u_user luo_user
string ls_signing_user
long ll_log_id

lb_rx_signature = false

if any_new_rx() then
	li_log_index = find_service("RX_SIGNATURE")
				
	// If there are new prescriptions, check to see if user can sign for prescriptions
	if current_user.certified = "Y" then
					
		// If user can sign then present signature screen unless user is not attending physician and
		// user did not order prescriptions and signature service has already been ordered.
		if current_user.user_id = attending_doctor &
		 or any_new_user_rx(current_user.user_id) &
		 or li_log_index = 0 then
		 	lb_rx_signature = true
		end if
					
	// If user can't sign for prescriptions and a signature service has not been ordered, then order one.
	elseif li_log_index = 0 then
		// First, determine the signing user
		luo_user = user_list.find_user(attending_doctor)
		if not isnull(luo_user) then
			if luo_user.certified = "Y" then
				ls_signing_user = luo_user.user_id
			elseif not isnull(luo_user.supervisor) then
				ls_signing_user = luo_user.supervisor.user_id
			elseif not isnull(current_user.supervisor) then
				ls_signing_user = current_user.supervisor.user_id
			else
				setnull(ls_signing_user)
			end if
		elseif not isnull(current_user.supervisor) then
			ls_signing_user = current_user.supervisor.user_id
		else
			setnull(ls_signing_user)
		end if

		// Then, if a signing user was found, order the signature service
		if not isnull(ls_signing_user) then
			ll_log_id = order_service("RX_SIGNATURE", "Rx Signature", ls_signing_user)
		end if
	end if
end if


return lb_rx_signature

end function

public function integer get_billing (ref str_encounter_assessment pstra_assessment[], ref integer pi_assessment_count);integer li_treatment_count
integer i
integer li_sts
string ls_insurance_id
string ls_icd_9_code


//CWW, BEGIN
u_ds_data luo_sp_get_assessment_icd9
integer li_spdw_count
// DECLARE lsp_get_assessment_icd9 PROCEDURE FOR dbo.sp_get_assessment_icd9  
//         @ps_cpr_id = :current_patient.cpr_id,   
//			@ps_assessment_id = :pstra_assessment[i].assessment_id,
//			@ps_insurance_id = :ls_insurance_id OUT,
//			@ps_icd_9_code = :ls_icd_9_code OUT;
//CWW, END

li_sts = get_assessments(pstra_assessment, pi_assessment_count)
if li_sts <= 0 then return li_sts

for i = 1 to pi_assessment_count
	//CWW, BEGIN
//	EXECUTE lsp_get_assessment_icd9;
//	if not tf_check() then return -1
//	FETCH lsp_get_assessment_icd9 INTO :ls_insurance_id, :ls_icd_9_code;
//	if not tf_check() then return -1
//	CLOSE lsp_get_assessment_icd9;
	
luo_sp_get_assessment_icd9 = CREATE u_ds_data
luo_sp_get_assessment_icd9.set_dataobject("dw_sp_get_assessment_icd9")
li_spdw_count = luo_sp_get_assessment_icd9.retrieve(current_patient.cpr_id, pstra_assessment[i].assessment_id)
if li_spdw_count <= 0 then
	setnull(ls_insurance_id)
	setnull(ls_icd_9_code)
else
	ls_insurance_id = luo_sp_get_assessment_icd9.object.insurance_id[1]
	ls_icd_9_code = luo_sp_get_assessment_icd9.object.icd_9_code[1]
end if
destroy luo_sp_get_assessment_icd9
//CWW, END	
	
	
	pstra_assessment[i].insurance_id = ls_insurance_id
	pstra_assessment[i].icd_9_code = ls_icd_9_code
	
	get_billing_treatments(pstra_assessment[i].problem_id, pstra_assessment[i].charge, pstra_assessment[i].charge_count)
next

return 1


end function

public function boolean any_encounter_procs ();integer li_count

SELECT count(*)
INTO :li_count
FROM p_Encounter_Charge
WHERE cpr_id = :current_patient.cpr_id
AND encounter_id = :encounter_id
AND procedure_type = 'PRIMARY';
if not tf_check() then return false

if li_count < 1 then return false

return true

end function

public function boolean is_posted ();string ls_billing_posted

SELECT billing_posted
INTO :ls_billing_posted
FROM p_Patient_Encounter
WHERE cpr_id = :current_patient.cpr_id
AND encounter_id = :encounter_id;
if not tf_check() then return true

if ls_billing_posted = "Y" then return true

return false

end function

public function integer retry_posting ();

UPDATE p_Patient_Encounter
SET billing_posted = "R"
WHERE cpr_id = :current_patient.cpr_id
AND encounter_id = :encounter_id
AND billing_posted = "E";
if not tf_check() then return -1
if sqlca.sqlcode = 100 then return 0

return 1

end function

public function integer set_billing_procedure ();return set_billing_procedure(false)

end function

public function integer get_billing_treatments (long pl_problem_id, ref str_encounter_charge pstra_charge[], ref integer pi_charge_count);decimal ldc_charge
string ls_cpt_code
str_encounter_charge lstr_charge
u_str_assessment luo_assessment
integer i,j,k
string ls_description
string ls_modifier
string ls_other_modifiers
real lr_units
long ll_units
string ls_authority_id
u_ds_data luo_data
integer li_spdw_count


luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_sp_get_encounter_charges")
pi_charge_count = luo_data.retrieve(current_patient.cpr_id, encounter_id, pl_problem_id)

for i = 1 to pi_charge_count
	pstra_charge[i].cpr_id = current_patient.cpr_id
	pstra_charge[i].encounter_id = encounter_id
	pstra_charge[i].encounter_charge_id = luo_data.object.encounter_charge_id[i]
	pstra_charge[i].problem_id = pl_problem_id
	pstra_charge[i].procedure_type = luo_data.object.procedure_type[i]
	pstra_charge[i].treatment_id = luo_data.object.treatment_id[i]
	pstra_charge[i].treatment_billing_id = luo_data.object.treatment_billing_id[i]
	pstra_charge[i].procedure_id = luo_data.object.procedure_id[i]
	pstra_charge[i].charge = luo_data.object.charge[i]
	pstra_charge[i].assessment_charge_bill_flag = luo_data.object.assessment_charge_bill_flag[i]
	pstra_charge[i].charge_bill_flag = luo_data.object.charge_bill_flag[i]
	pstra_charge[i].description = luo_data.object.description[i]
	pstra_charge[i].cpt_code = luo_data.object.cpt_code[i]
	pstra_charge[i].units = luo_data.object.units[i]
	pstra_charge[i].modifier = luo_data.object.modifier[i]
	pstra_charge[i].other_modifiers = luo_data.object.other_modifiers[i]
	pstra_charge[i].last_updated = luo_data.object.last_updated[i]
	pstra_charge[i].last_updated_by = luo_data.object.last_updated_by[i]
	pstra_charge[i].posted = luo_data.object.posted[i]
	pstra_charge[i].billing_sequence = luo_data.object.billing_sequence[i]
next


// Now sort the visit codes to the top
k = 1

for i = 1 to pi_charge_count
	if i > 1 then
		if pstra_charge[i].procedure_type = 'PRIMARY' then
			lstr_charge = pstra_charge[i]
			for j = i - 1 to k step -1
				pstra_charge[j + 1] = pstra_charge[j]
			next
			pstra_charge[k] = lstr_charge
			k++
		end if
	end if
next

destroy luo_data

return 1


end function

public function long find_service (string ps_service);long ll_patient_workplan_item_id


 DECLARE lsp_Find_Encounter_Service PROCEDURE FOR dbo.sp_Find_Encounter_Service  
         @ps_cpr_id = :current_patient.cpr_id,   
         @pl_encounter_id = :encounter_id,   
         @ps_service = :ps_service,   
         @pl_patient_workplan_item_id = :ll_patient_workplan_item_id OUT;


EXECUTE lsp_Find_Encounter_Service;
if not tf_check() then return -1

FETCH lsp_Find_Encounter_Service INTO :ll_patient_workplan_item_id;
if not tf_check() then return -1

CLOSE lsp_Find_Encounter_Service;


return ll_patient_workplan_item_id


end function

public function integer get_numeric_objective_result (long pl_treatment_id, string ps_observation_id, string ps_location, integer pi_result_sequence, ref real pr_result_amount, ref string ps_result_unit);

 DECLARE lsp_get_result_loc PROCEDURE FOR dbo.sp_get_result_loc
         @ps_cpr_id = :current_patient.cpr_id,   
         @pl_treatment_id = :pl_treatment_id,   
         @ps_observation_id = :ps_observation_id,
         @ps_location = :ps_location,
         @pi_result_sequence = :pi_result_sequence,
         @pr_result_amount = :pr_result_amount OUT,   
         @ps_result_unit = :ps_result_unit OUT ;


EXECUTE lsp_get_result_loc;
if not tf_check() then return -1

FETCH lsp_get_result_loc INTO :pr_result_amount, :ps_result_unit;
if not tf_check() then return -1

CLOSE lsp_get_result_loc;

return 1

end function

public function integer get_assessments (ref str_encounter_assessment pstra_assessment[], ref integer pi_assessment_count);long ll_problem_id
long ll_assessment_billing_id
boolean lb_loop
string ls_assessment_id
string ls_bill_flag
string ls_auto_close
string ls_description
integer li_treatment_count
integer li_assessment_sequence

 DECLARE lsp_get_encounter_assessments PROCEDURE FOR dbo.sp_get_encounter_assessments  
         @ps_cpr_id = :current_patient.cpr_id,   
         @pl_encounter_id = :encounter_id  ;


pi_assessment_count = 0
lb_loop = true

EXECUTE lsp_get_encounter_assessments;
if not tf_check() then return -1

DO
	FETCH lsp_get_encounter_assessments INTO
		:ll_problem_id,
		:ls_assessment_id,
		:li_assessment_sequence,
		:ls_description,
		:ll_assessment_billing_id,
		:ls_bill_flag,
		:ls_auto_close;
	if not tf_check() then return -1

	if sqlca.sqlcode = 0 then
		pi_assessment_count++
		pstra_assessment[pi_assessment_count].problem_id = ll_problem_id
		pstra_assessment[pi_assessment_count].assessment_id = ls_assessment_id
		pstra_assessment[pi_assessment_count].assessment_sequence = li_assessment_sequence
		pstra_assessment[pi_assessment_count].description = ls_description
		pstra_assessment[pi_assessment_count].assessment_billing_id = ll_assessment_billing_id
		pstra_assessment[pi_assessment_count].bill_flag = ls_bill_flag
		pstra_assessment[pi_assessment_count].auto_close = ls_auto_close
	else
		lb_loop = false
	end if
LOOP WHILE lb_loop

CLOSE lsp_get_encounter_assessments;

return 1


end function

public function integer set_numeric_objective_result (long pl_treatment_id, string ps_observation_id, integer pi_result_sequence, string ps_location, real pr_result_amount);datetime ldt_result_date_time

setnull(ldt_result_date_time)

sqlca.sp_set_result_amount( &
		current_patient.cpr_id, &
		pl_treatment_id, &
		ps_observation_id, &
		pi_result_sequence, &
		ps_location, &
		encounter_id, &
		pr_result_amount, &
		ldt_result_date_time, &
		current_user.user_id, &
		current_scribe.user_id)

if not tf_check() then return -1

return 1

end function

public function integer save_attachment ();integer li_sts
long ll_attachment_id

if isnull(encounter_id) then
	log.log(this, "save()", "ERROR! Cannot save attachment when encounter_id=null", 4)
	return -1
end if

if isnull(attachment_list) then
	setnull(ll_attachment_id)
elseif attachment_list.attachment_count <= 0 then
	setnull(ll_attachment_id)
else
	ll_attachment_id = attachment_list.attachment_id
end if

UPDATE p_Patient_Encounter
SET	attachment_id = :ll_attachment_id
WHERE cpr_id = :current_patient.cpr_id
AND	encounter_id = :encounter_id; 
if not tf_check() then return -1
if sqlca.sqlcode = 100 then
	log.log(this, "save_attachment()", "Encounter not found", 4)
	return -1
end if

return 1

end function

public function integer set_billing_procedure (boolean pb_replace);string ls_component_id
string lsa_procedure_id[]
string ls_procedure_id
string ls_null
long ll_null
long ll_count
integer i
u_component_coding luo_coding
string ls_replace_flag

//CWW, BEGIN
u_ds_data luo_sp_get_coding_component
integer li_spdw_count
// DECLARE lsp_get_coding_component PROCEDURE FOR dbo.sp_get_coding_component  
//         @ps_cpr_id = :current_patient.cpr_id,   
//         @ps_component_id = :ls_component_id OUT ;
//CWW, END

setnull(ls_null)
setnull(ll_null)

if any_encounter_procs() and not pb_replace then return 0

//CWW, BEGIN
//EXECUTE lsp_get_coding_component;
//if not tf_check() then return -1
//FETCH lsp_get_coding_component INTO :ls_component_id;
//if not tf_check() then return -1
//CLOSE lsp_get_coding_component;
luo_sp_get_coding_component = CREATE u_ds_data
luo_sp_get_coding_component.set_dataobject("dw_sp_get_coding_component")
li_spdw_count = luo_sp_get_coding_component.retrieve(current_patient.cpr_id)
if li_spdw_count <= 0 then
	setnull(ls_component_id)
else
	ls_component_id = luo_sp_get_coding_component.object.component_id[1]
end if
destroy luo_sp_get_coding_component

//CWW, END

luo_coding = component_manager.get_component(ls_component_id)
if isnull(luo_coding) then return -1

ll_count = luo_coding.encounter_procedure(current_patient.cpr_id, encounter_id, lsa_procedure_id)
if ll_count < 0 then return -1

ls_replace_flag = "Y"
for i = 1 to ll_count
	ls_procedure_id = lsa_procedure_id[i]
	
	sqlca.sp_add_encounter_charge(current_patient.cpr_id, &
							encounter_id, &
							ls_procedure_id, &
							ll_null, &
							current_scribe.user_id, &
							ls_replace_flag)

	if not tf_check() then return -1

	// Don't replace for 2nd and subsequent charges
	ls_replace_flag = "N"
next

component_manager.destroy_component(luo_coding)

return 1

end function

public function integer cancel_treatment (long pl_treatment_id); DECLARE lsp_cancel_treatment PROCEDURE FOR dbo.sp_cancel_treatment
         @ps_cpr_id = :current_patient.cpr_id,
			@pl_treatment_id = :pl_treatment_id,
			@pl_encounter_id = :encounter_id,
         @ps_user_id = :current_user.user_id,
			@ps_created_by = :current_scribe.user_id;


EXECUTE lsp_cancel_treatment;
if not tf_check() then return -1

current_patient.load_treatments()

return 1

end function

public function integer do_treatment (long pl_treatment_id);u_component_treatment luo_treatment
string ls_treatment_type
string ls_component_id
integer li_sts

SELECT treatment_type
INTO :ls_treatment_type
FROM p_Treatment_Item
WHERE cpr_id = :current_patient.cpr_id
AND treatment_id = :pl_treatment_id;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then
	log.log(this, "do_treatment()", "Treatment not found (" + string(pl_treatment_id) + ")", 4)
	return -1
end if

ls_component_id = datalist.treatment_type_component(ls_treatment_type)
if isnull(ls_component_id) then
	log.log(this, "do_treatment()", "Null component_id (" + string(ls_treatment_type) + ")", 4)
	return -1
end if

luo_treatment = component_manager.get_component(ls_component_id)
if isnull(luo_treatment) then
	log.log(this, "do_treatment()", "Error getting component (" + string(ls_component_id) + ")", 4)
	return -1
end if

li_sts = luo_treatment.do_treatment()

component_manager.destroy_component(luo_treatment)

return li_sts




end function

public function integer print (string ps_report_id);///////////////////////////////////////////////////////////////////////////////////////////
//
//	Return: Integer [ -1 - Failure , 1 - success ]
//
//	Description:Add the required attribute and values and call runreport() of report
// component to add more runtime/other attributes.
//
// Created By:Sumathi Chinnasamy										Creation dt: 10/21/99
//
// Modified By:															Modified On:
////////////////////////////////////////////////////////////////////////////////////////////
string					lsa_attributes[]
string					lsa_values[]

lsa_attributes[1] = "REPORT_ID"
lsa_values[1] = ps_report_id

//return service_list.do_service(current_patient.cpr_id, encounter_id, "REPORT", 1, lsa_attributes, lsa_values)
return 1


end function

public subroutine pick_observations (string ps_observation_type, string ps_observation_category_id, integer pi_objective_set);str_popup popup

popup.item = "OBSERVATION"
popup.items[1] = ps_observation_type
popup.items[2] = ps_observation_category_id
popup.items[3] = string(pi_objective_set)

//openwithparm(w_objective, popup)
end subroutine

public function integer pick_results (long pl_treatment_id, string ps_observation_id);str_popup popup

popup.item = "RESULT"
popup.items[1] = string(pl_treatment_id)
popup.items[2] = ps_observation_id

//openwithparm(w_objective, popup)

return 1

end function

public function integer do_service (string ps_service);string lsa_attributes[]
string lsa_values[]
integer li_count

li_count = 0

return do_service(ps_service, li_count, lsa_attributes, lsa_values)

end function

public function integer do_service (string ps_service, integer pi_attribute_count, string psa_attributes[], string psa_values[]);u_component_service luo_service
long ll_patient_workplan_item_id
integer li_sts
string ls_description

setnull(ls_description)

ll_patient_workplan_item_id = order_service(ps_service, ls_description, current_user.user_id, pi_attribute_count, psa_attributes, psa_values)
if ll_patient_workplan_item_id <= 0 then return -1

luo_service = service_list.get_service_component(ps_service)
if isnull(luo_service) then
	log.log(this, "do_service()", "Error getting service (" + ps_service + ")", 4)
	return -1
end if

li_sts = luo_service.do_service(ll_patient_workplan_item_id)

component_manager.destroy_component(luo_service)

return li_sts

end function

public function long order_service (string ps_service, string ps_description, string ps_ordered_for);long ll_patient_workplan_item_id
long ll_encounter_id
string ls_in_office_flag
string ls_auto_perform_flag
string ls_observation_tag
integer li_step_number

setnull(ll_encounter_id)
setnull(ls_in_office_flag)
setnull(ls_auto_perform_flag)
setnull(ls_observation_tag)
setnull(li_step_number)

sqlca.sp_order_service_workplan_item( &
		current_patient.cpr_id, &
		ll_encounter_id, &
		patient_workplan_id, &
		ps_service, &
		ls_in_office_flag, &
		ls_auto_perform_flag, &
		ls_observation_tag, &
		ps_description,  &
		current_user.user_id, &
		ps_ordered_for,  &
		li_step_number, &
		current_scribe.user_id,  &
		ll_patient_workplan_item_id)
if not tf_check() then return -1

return ll_patient_workplan_item_id

end function

public function long order_service (string ps_service, string ps_description, string ps_ordered_for, integer pi_attribute_count, string psa_attributes[], string psa_values[]);long ll_patient_workplan_item_id
long ll_patient_workplan_id
integer i

tf_begin_transaction(this, "order_service()")

ll_patient_workplan_item_id = order_service(ps_service, ps_description, ps_ordered_for)
if ll_patient_workplan_item_id <= 0 then return -1

 DECLARE lsp_add_workplan_item_attribute PROCEDURE FOR dbo.sp_add_workplan_item_attribute  
         @ps_cpr_id = :current_patient.cpr_id,   
         @pl_patient_workplan_id = :ll_patient_workplan_id,   
         @pl_patient_workplan_item_id = :ll_patient_workplan_item_id,   
         @ps_attribute = :psa_attributes[i],   
         @ps_value = :psa_values[i],   
         @ps_created_by = :current_scribe.user_id  ;

for i = 1 to pi_attribute_count
	sqlca.sp_add_workplan_item_attribute( &
        current_patient.cpr_id,   &
        ll_patient_workplan_id,   &
        ll_patient_workplan_item_id,   &
        psa_attributes[i],   &
        psa_values[i],   &
        current_scribe.user_id , &
        current_user.user_id  )
next

tf_commit()

return ll_patient_workplan_item_id

end function

public function long order_service (string ps_service);str_popup popup
long ll_patient_workplan_item_id
str_popup_return popup_return

popup.data_row_count = 2
popup.items[1] = ps_service
popup.items[2] = datalist.service_description(ps_service)

openwithparm(w_order_recheck, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0


ll_patient_workplan_item_id = long(popup_return.items[1])

return ll_patient_workplan_item_id


end function

public subroutine do_options ();str_popup popup
string buttons[]
integer button_pressed
u_ds_data luo_services
string ls_in_office_flag
long ll_count
long i
integer li_sts

luo_services = CREATE u_ds_data
luo_services.set_dataobject( "dw_encounter_service_list")

if isnull(patient_location) then
	ls_in_office_flag = "N"
else
	ls_in_office_flag = "Y"
end if

popup.button_count = 0

ll_count = luo_services.retrieve(encounter_type, ls_in_office_flag)

for i = 1 to ll_count
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = luo_services.object.button[i]
	popup.button_helps[popup.button_count] = luo_services.object.description[i]
	popup.button_titles[popup.button_count] = luo_services.object.description[i]
	buttons[popup.button_count] = luo_services.object.service[i]
next

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(w_pop_buttons, popup)
	button_pressed = message.doubleparm
	if button_pressed < 1 then return
elseif popup.button_count = 1 then
	button_pressed = 1
else
	return
end if


if button_pressed <= ll_count then
	order_service(luo_services.object.service[button_pressed])
end if

DESTROY luo_services

end subroutine

public function integer change_room (string ps_room_id);integer li_sts
string ls_null

setnull(ls_null)

li_sts = current_patient.encounters.set_encounter_progress(encounter_id, "Modify", "patient_location", ps_room_id)
if li_sts <= 0 then return li_sts

if not isnull(next_patient_location) then
	li_sts = current_patient.encounters.set_encounter_progress(encounter_id, "Modify", "next_patient_location", ls_null)
end if

return li_sts


end function

public function integer add_finding (string ps_finding_list, string ps_finding);

INSERT INTO p_Finding (
	cpr_id,
	encounter_id,
	finding_list,
	comments,
	user_id,
	created_by)
VALUES (
	:current_patient.cpr_id,
	:encounter_id,
	:ps_finding_list,
	:ps_finding,
	:current_user.user_id,
	:current_scribe.user_id);
if not tf_check() then return -1

return 1

end function

public function string room_menu ();str_popup popup
integer button_pressed, i
string ls_null
u_ds_data luo_data
long ll_rooms
string ls_room_name
string ls_room_type
string ls_room_status
string ls_room_id
string ls_find
long ll_row
string ls_filter
integer li_sts

setnull(ls_null)
setnull(ls_room_id)

// If the next room is null or equals the current room then we're done
if isnull(next_patient_location) or patient_location = next_patient_location then
	ls_room_id = ls_null
	goto DONE
end if

// Get a list of the rooms in this office
luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_room_list_all")
ll_rooms = luo_data.retrieve()

// See if the next room corresponds to a specific room
ls_find = "room_id='" + next_patient_location + "'"
ll_row = luo_data.find(ls_find, 1, ll_rooms)
if ll_row > 0 then
	ls_room_id = next_patient_location
	goto DONE
end if

// See if the next room corresponds to a room_type
ls_filter = "room_type='" + next_patient_location + "'"
ls_filter += " and office_id='" + encounter_office_id + "'"
luo_data.setfilter(ls_filter)
li_sts = luo_data.filter()
if li_sts <= 0 then
	log.log(this, "room_menu()", "Error applying room filter (" + ls_filter + ")", 4)
	ls_room_id = ls_null
	goto DONE
end if

ll_rooms = luo_data.rowcount()
if ll_rooms <= 0 then
	ls_room_id = ls_null
	goto DONE


end if

// See if the patient is already in one of these rooms
ls_find = "room_id='" + patient_location + "'"
ll_row = luo_data.find(ls_find, 1, ll_rooms)
// If we're already in a room of the correct type, we're done
if ll_row > 0 then
	ls_room_id = patient_location
	goto DONE
end if

// See if the user is looking at one of these rooms
if isvalid(viewed_room) and not isnull(viewed_room) then
	ls_find = "room_id='" + viewed_room.room_id + "'"
	ll_row = luo_data.find(ls_find, 1, ll_rooms)
	// If we're looking at a room of the correct type, use it
	if ll_row > 0 then
		ls_room_id = viewed_room.room_id
		goto DONE
	end if
end if

// See if the user is logged in at one of these rooms
if not isnull(current_room) then
	ls_find = "room_id='" + current_room.room_id + "'"
	ll_row = luo_data.find(ls_find, 1, ll_rooms)
	// If we're logged in a room of the correct type, use it
	if ll_row > 0 then
		ls_room_id = current_room.room_id
		goto DONE
	end if
end if

// If the CPR mode is SERVER, then we can't present a user window
if cpr_mode = "SERVER" then
	// If there are rooms to pick from then pick the first
	if ll_rooms > 0 then
		ls_room_id = luo_data.object.room_id[1]
	else
		// Otherwise just return null
		setnull(ls_room_id)
	end if
	goto DONE
end if

// Since we have rooms but we don't know which one to put the patient in,
// present the options to the user
popup.button_count = 0

for i = 1 to ll_rooms
	ls_room_type = luo_data.object.room_type[i]
	ls_room_id = luo_data.object.room_id[i]
	ls_room_name = luo_data.object.room_name[i]
	ls_room_status = luo_data.object.room_status[i]
	if ls_room_status = "NA" then continue
	
	popup.button_count += 1
	popup.button_icons[popup.button_count] = room_list.bitmap(ls_room_type, ls_room_status)
	popup.button_helps[popup.button_count] = ls_room_name
	popup.button_titles[popup.button_count] = ls_room_name
next

if popup.button_count > 1 then
	popup.button_count += 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	// If there is more than one room in the list, let the user pick one
	openwithparm(w_pop_buttons, popup)
	button_pressed = message.doubleparm
	// If the user pressed cancel, then return no room
	if button_pressed = popup.button_count then
		ls_room_id = ls_null
		goto DONE
	end if
elseif popup.button_count = 1 then
	button_pressed = 1
else
	button_pressed = 0
end if

if button_pressed > 0 then
	ls_room_id = luo_data.object.room_id[button_pressed]
else
	ls_room_id = ls_null
end if

DONE:

DESTROY luo_data

return ls_room_id


end function

public function integer order_encounter_workplan ();string ls_status
integer li_sts
string ls_first_room_id
u_str_encounter luo_this
long ll_treatment_id
datetime ldt_progress_date_time
string ls_completed_by
string ls_owned_by

setnull(ll_treatment_id)
setnull(ldt_progress_date_time)
setnull(ls_completed_by)
setnull(ls_owned_by)

 DECLARE lsp_Order_Encounter_Workplan PROCEDURE FOR dbo.sp_Order_Encounter_Workplan  
         @ps_cpr_id = :current_patient.cpr_id,   
         @pl_encounter_id = :encounter_id,   
         @ps_ordered_by = :current_user.user_id,   
         @ps_created_by = :current_scribe.user_id,
			@pl_patient_workplan_id = :patient_workplan_id OUT;


ls_status = "CANCELLED"

// First cancel the current workplan if there is one
if patient_workplan_id > 0 then
	sqlca.sp_set_workplan_status( &
			current_patient.cpr_id, &
			encounter_id, &
			ll_treatment_id, &
			patient_workplan_id, &
			ls_status, &
			ldt_progress_date_time, &
			ls_completed_by, &
			ls_owned_by, &
			current_scribe.user_id)

	if not tf_check() then return -1
end if

// The order the new workplan
EXECUTE lsp_Order_Encounter_Workplan;
if not tf_check() then return -1

FETCH lsp_Order_Encounter_Workplan INTO :patient_workplan_id;
if not tf_check() then return -1

CLOSE lsp_Order_Encounter_Workplan;

// Refresh the encounter object because ordering the workplan might have changed things
luo_this = this
li_sts = current_patient.encounters.refresh_encounter(luo_this)

// If the encounter is open, then set the first room
if encounter_status = "OPEN" then
	ls_first_room_id = room_menu()
	if not isnull(ls_first_room_id) then
		li_sts = change_room(ls_first_room_id)
		if li_sts < 0 then
			log.log(this, "new_encounter()", "Error changeing room (" + ls_first_room_id + ")", 4)
		end if
	end if
end if

return 1

end function

public function integer close_old ();integer i
u_str_encounter luo_this

 DECLARE lsp_close_encounter PROCEDURE FOR dbo.sp_close_encounter  
         @ps_cpr_id = :current_patient.cpr_id,   
         @pl_encounter_id = :encounter_id,
			@ps_user_id = :current_user.user_id,
			@ps_created_by = :current_scribe.user_id;

current_patient.assessments.close_auto_close()

EXECUTE lsp_close_encounter;
if not tf_check() then return -1

luo_this = this

current_patient.encounters.refresh_encounter(luo_this)

return 1

end function

public function boolean any_unfinished_services_old ();string ls_null
long ll_patient_workplan_item_id
char lc_auto_perform_flag

//lc_auto_perform_flag = '%'
//
//setnull(ls_null)
//
//sqlca.sp_get_next_encounter_service( &
//		current_patient.cpr_id, &
//		encounter_id, &
//		ls_null, &
//		lc_auto_perform_flag, &
//		ll_patient_workplan_item_id)
//		
//if not tf_check() then return false

if isnull(ll_patient_workplan_item_id) then
	return false
else
	return true
end if



end function

on u_str_encounter.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_str_encounter.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;attachment_list = CREATE u_attachment_list

end event

event destructor;DESTROY attachment_list

end event

