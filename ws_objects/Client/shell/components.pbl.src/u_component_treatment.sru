$PBExportHeader$u_component_treatment.sru
forward
global type u_component_treatment from u_component_base_class
end type
end forward

global type u_component_treatment from u_component_base_class
end type
global u_component_treatment u_component_treatment

type variables

long original_treatment_id
long parent_treatment_id
long close_encounter_id
long treatment_id
long open_encounter_id
long material_id
long problem_ids[]
long ordered_workplan_id
long followup_workplan_id
long treatment_count

integer problem_count
integer administration_sequence
integer refills
integer encounter_log_index = 0

string treatment_key

string treatment_type,package_id
string specialty_id,procedure_id
string drug_id
string dose_unit
string administer_frequency
string duration_unit
string duration_prn
string dispense_unit
string brand_name_required
string treatment_description
string treatment_goal
string location
string maker_id
string lot_number
string treatment_office_id
string send_out_flag
string attach_flag
string referral_question
string referral_question_assmnt_id
string ordered_by
string created_by
string pharmacist_instructions
string patient_instructions
string treatment_status
String observation_id
String dosage_form
String treatment_mode
string specimen_id
string ordered_by_supervisor
datetime appointment_date_time
string ordered_for

String called_from
public String indent = "..."

datetime begin_date
datetime created
datetime end_date
datetime expiration_date
real dose_amount
real duration_amount
real dispense_amount
real office_dispense_amount

boolean exists
boolean deleted = false
boolean updated = false
boolean description_loaded = false
boolean past_treatment = false

str_item_definition treatment_definition[]


u_ds_data p_observation
u_ds_data p_observation_result
u_ds_data p_observation_result_qualifier
u_ds_data p_observation_location

u_ds_observation_results results

// Need a place to store new progress items before the p_treatment_item
// record actually exists.
str_progress_list new_progress

str_assessment_description assessment
u_attachment_list attachment_list
//u_attachment_signature signature
u_patient parent_patient

string comment_service = "OBSERVATION_COMMENT"
string attachment_service = "EXTERNAL_SOURCE"

end variables
forward prototypes
public function string description ()
public subroutine get_descriptions ()
public subroutine display_properties ()
public function integer get_charges (string ps_procedure_type, ref str_encounter_charge pstra_charges[])
public function long problem_id ()
public function boolean in_problem (long pl_problem_id)
public function integer review_treatment ()
public function string bitmap ()
public function integer show_followup_treatments ()
public function boolean any_child_treatments ()
public subroutine refresh ()
public function integer add_progress (string ps_progress_type, datetime pdt_progress_date_time)
public function integer close (string ps_treatment_status)
public function long find_observations (string ps_find, ref str_treatment_observation pstr_treatment_observation[])
public function long add_comment (string ps_comment)
public function integer define_treatment ()
public function long remove_results (long pl_observation_sequence, string ps_location)
public function integer get_result (long pl_observation_sequence, integer pi_result_sequence, string ps_location, ref datetime pdt_result_date_time, ref string ps_result_value, ref string ps_result_unit, ref string ps_abnormal_flag, ref string ps_abnormal_nature)
public function boolean observation_is_any_locations (long pl_observation_sequence, integer pi_result_sequence)
public function integer observation_severity (long pl_observation_sequence)
public function string execute_script (long pl_script_id)
public function integer populate_defaults_from_actuals (ref str_observation_tree pstr_tree, long pl_parent_observation_sequence)
public function integer populate_defaults_from_actuals (long pl_observation_sequence, ref str_exam_default_result pstra_results[])
public function integer set_exam_defaults (long pl_exam_sequence, long pl_branch_id, long pl_observation_sequence)
public function integer add_progress (string ps_progress_type, string ps_progress)
public subroutine treatment_group (ref string ps_treatment_group, ref integer pi_treatment_sort)
public function boolean observation_is_any_results (long pl_observation_sequence, string ps_location)
public function boolean is_child ()
public function integer get_location_description (long pl_observation_sequence, integer pi_result_sequence, string ps_location, ref string ps_description)
public function long remove_result (long pl_observation_sequence, integer pi_result_sequence, string ps_location)
public function long remove_results (long pl_observation_sequence, integer pi_result_sequence)
public function integer do_autoperform_services ()
public function str_p_observation_result observation_result (long pl_observation_sequence, integer pi_result_sequence, string ps_location)
public function long find_observation (long pl_parent_observation_sequence, string ps_observation_id, integer pi_child_ordinal, string ps_observation_tag, long pl_stage)
public function integer get_child_observations (long pl_parent_observation_sequence, ref str_p_observation pstra_observations[])
public function long add_result (long pl_observation_sequence, integer pi_result_sequence, string ps_location, datetime pdt_result_date_time)
public function long add_comment (long pl_observation_sequence, string ps_comment)
public function long add_comment (long pl_observation_sequence, string ps_comment_title, string ps_abnormal_flag, integer pi_severity, string ps_comment)
public function long add_comment (long pl_observation_sequence, string ps_comment_title, string ps_abnormal_flag, integer pi_severity, long pl_attachment_id, string ps_comment)
public function string get_observation_id (long pl_observation_sequence)
private function integer set_exam_defaults (long pl_observation_sequence, integer pi_default_result_count, str_exam_default_result pstra_default_results[])
public function integer add_collection_result (long pl_observation_sequence, string ps_location)
public function long remove_comment (long pl_observation_sequence, long pl_observation_comment_id)
public function string get_observation_description (long pl_observation_sequence)
public function integer unset_progress_key (string ps_progress_type, string ps_progress_key)
public function integer set_progress_key (string ps_progress_type, string ps_progress_key, string ps_progress_value)
public function integer xx_define_treatment ()
public function integer do_treatment ()
public function integer associate_assessment (long pl_problem_id, boolean pb_associated)
public function string assessment_description (boolean pb_all_assessments)
public function integer get_comment (long pl_observation_sequence, string ps_comment_title, ref str_observation_comment pstr_comment)
public function integer set_progress (string ps_progress_type, string ps_progress)
public function long add_attachment (long pl_observation_sequence, string ps_comment_title, long pl_attachment_id)
public function integer load_observations ()
public function integer close (string ps_treatment_status, datetime pdt_end_date)
public function long add_observation (long pl_parent_observation_sequence, string ps_observation_id, integer pi_child_ordinal, string ps_observation_tag, long pl_stage, boolean pb_find_existing)
private function integer set_exam_defaults (long pl_parent_observation_sequence, str_observation_tree pstr_tree)
private function long find_root_observation (string ps_observation_id, string ps_observation_tag)
public function string get_observation_service (long pl_observation_sequence)
public function long add_observation (long pl_parent_observation_sequence, string ps_observation_id, integer pi_child_ordinal, string ps_observation_tag, long pl_stage, ref string ps_service, boolean pb_find_existing)
public function long add_root_observation (string ps_observation_id, string ps_observation_tag, ref string ps_service)
public function long add_root_observation (string ps_observation_id, string ps_observation_tag, ref string ps_service, boolean pb_find_existing)
public subroutine map_attr_to_data_columns (str_attributes pstr_attributes)
public function integer set_exam_defaults_old (long pl_exam_sequence, long pl_branch_id, long pl_observation_sequence, integer pi_result_sequence, string ps_location)
private function str_p_observation get_observation_structure (long pl_row)
public function long set_result (long pl_observation_sequence, integer pi_result_sequence, string ps_location)
public function long add_result (long pl_observation_sequence, integer pi_result_sequence, string ps_location)
public function long add_result (long pl_observation_sequence, integer pi_result_sequence, string ps_location, datetime pdt_result_date_time, string ps_result_value, string ps_result_unit, string ps_abnormal_flag, string ps_abnormal_nature)
public subroutine reset ()
public function integer delete_item_old ()
public function integer update (str_attributes pstr_attributes)
private function integer set_exam_defaults_add_observations (long pl_exam_sequence, long pl_branch_id, long pl_observation_sequence, integer pi_result_sequence, string ps_location, u_ds_data puo_data)
public function string observation_id (long pl_observation_sequence)
public function integer set_exam_defaults (long pl_exam_sequence, long pl_branch_id, long pl_observation_sequence, integer pi_result_sequence, string ps_location)
public function integer get_stage_observations (long pl_parent_observation_sequence, ref str_p_observation_stages pstr_observation_stages)
public function boolean any_results ()
public function long add_observation_stage (long pl_parent_observation_sequence, string ps_observation_id, integer pi_child_ordinal, string ps_observation_tag, long pl_stage, string ps_stage_description, boolean pb_find_existing)
public function long add_observation (long pl_parent_observation_sequence, string ps_observation_id, integer pi_child_ordinal, string ps_observation_tag, long pl_stage, string ps_stage_description, ref string ps_service, boolean pb_find_existing)
public function long add_observation (long pl_parent_observation_sequence, string ps_observation_id, integer pi_child_ordinal, string ps_observation_tag, boolean pb_find_existing)
public function integer add_followup_treatments (string ps_treatment_type, string ps_description, str_attributes pstr_attributes)
public function boolean any_results (long pl_root_observation_sequence, string ps_result_type)
public function integer remove_collection_results (long pl_observation_sequence)
public function boolean is_authorized ()
public function long remove_results (long pl_observation_sequence, string ps_location, integer pi_result_sequence)
public function long remove_results (long pl_observation_sequence)
public function str_p_observation get_observation (long pl_observation_sequence)
public function str_observation_comment_list get_comments (long pl_observation_sequence, string ps_comment_title)
public function long get_observation_results (long pl_observation_sequence, ref str_p_observation_result pstra_result[])
public function integer get_result (long pl_observation_sequence, integer pi_result_sequence, string ps_location, ref string ps_result)
public function integer order_treatment_old (string ps_cpr_id, long pl_encounter_id, string ps_treatment_type, string ps_treatment_desc, long pl_problem_id, boolean pb_past_treatment, string ps_user_id, datetime pdt_begin_dt, datetime pdt_end_dt, long pl_parent_treatment_id, integer pi_attribute_count, ref string ps_attributes[], ref string ps_values[])
public function str_treatment_description treatment_description ()
private function long add_result_record (long pl_observation_sequence, integer pi_result_sequence, string ps_location, datetime pdt_result_date_time, string ps_result_value, string ps_result_unit, string ps_abnormal_flag, string ps_abnormal_nature, string ps_normal_range)
public function long add_result (long pl_observation_sequence, integer pi_result_sequence, string ps_location, datetime pdt_result_date_time, string ps_result_value, string ps_result_unit, string ps_abnormal_flag, string ps_abnormal_nature, string ps_normal_range)
public function integer define_treatment (str_assessment_description pstr_assessment)
public function integer define_treatment (str_assessment_description pstr_assessment, boolean pb_grant_access)
public function integer define_treatment (u_component_service puo_service)
end prototypes

public function string description ();//if not description_loaded then get_descriptions()

return treatment_description

end function

public subroutine get_descriptions ();// This function will load the class-specific description variables

description_loaded = true


end subroutine

public subroutine display_properties ();str_popup popup

popup.objectparm = this
openwithparm(w_treatment_properties, popup)

end subroutine

public function integer get_charges (string ps_procedure_type, ref str_encounter_charge pstra_charges[]);integer li_count
boolean lb_loop
long ll_encounter_charge_id
string ls_procedure_type
long ll_treatment_id
long ll_treatment_billing_id
string ls_procedure_id
string ls_description
string ls_cpt_code
decimal ldc_charge
string ls_charge_bill_flag
string ls_created_by

 DECLARE lc_encounter_charge CURSOR FOR  
  SELECT p_Encounter_Charge.encounter_charge_id,   
         p_Encounter_Charge.procedure_type,   
         p_Encounter_Charge.treatment_id,   
         p_Encounter_Charge.treatment_billing_id,   
         p_Encounter_Charge.procedure_id,   
			c_Procedure.description,
			c_Procedure.cpt_code,
         p_Encounter_Charge.charge,   
         p_Encounter_Charge.bill_flag,   
         p_Encounter_Charge.created_by  
    FROM p_Encounter_Charge, c_Procedure
   WHERE ( p_Encounter_Charge.cpr_id = :current_patient.cpr_id ) AND  
         ( p_Encounter_Charge.encounter_id = :open_encounter_id ) AND
			( p_Encounter_Charge.procedure_type = :ps_procedure_type ) AND
			( p_Encounter_Charge.treatment_id = :treatment_id ) AND
			( p_Encounter_Charge.procedure_id = c_Procedure.procedure_id);


OPEN lc_encounter_charge;
if not tf_check() then return -1

lb_loop = true
li_count = 0

DO
	FETCH lc_encounter_charge INTO
		:ll_encounter_charge_id,
		:ls_procedure_type,
		:ll_treatment_id,
		:ll_treatment_billing_id,
		:ls_procedure_id,
		:ls_description,
		:ls_cpt_code,
		:ldc_charge,
		:ls_charge_bill_flag,
		:ls_created_by;
	if not tf_check() then return -1

	if sqlca.sqlcode = 0 then
		li_count ++
		pstra_charges[li_count].encounter_charge_id = ll_encounter_charge_id
		pstra_charges[li_count].procedure_type = ls_procedure_type
		pstra_charges[li_count].treatment_id = ll_treatment_id
		pstra_charges[li_count].treatment_billing_id = ll_treatment_billing_id
		pstra_charges[li_count].procedure_id = ls_procedure_id
		pstra_charges[li_count].description = ls_description
		pstra_charges[li_count].cpt_code = ls_cpt_code
		pstra_charges[li_count].charge = ldc_charge
		pstra_charges[li_count].charge_bill_flag = ls_charge_bill_flag
		pstra_charges[li_count].created_by = ls_created_by
	else
		lb_loop = false
	end if
LOOP WHILE lb_loop

CLOSE lc_encounter_charge;

return li_count




end function

public function long problem_id ();integer ll_problem_id

if problem_count <= 0 then
	setnull(ll_problem_id)
else
	ll_problem_id = problem_ids[1]
end if

return ll_problem_id

end function

public function boolean in_problem (long pl_problem_id);integer i

for i = 1 to problem_count
	if problem_ids[i] = pl_problem_id then return true
next

return false

end function

public function integer review_treatment ();return 0
end function

public function string bitmap ();return datalist.treatment_type_icon(treatment_type)
end function

public function integer show_followup_treatments ();long ll_patient_workplan_id

 DECLARE lsp_get_treatment_followup_workplan PROCEDURE FOR dbo.sp_get_treatment_followup_workplan
			@ps_cpr_id = :current_patient.cpr_id,
			@pl_treatment_id = :treatment_id,
			@pl_patient_workplan_id = :ll_patient_workplan_id OUT;

//Setredraw(false)
//Reset()

EXECUTE lsp_get_treatment_followup_workplan;
If Not tf_check() then Return -1

FETCH lsp_get_treatment_followup_workplan INTO :ll_patient_workplan_id;
If Not tf_check() then Return -1

CLOSE lsp_get_treatment_followup_workplan;

If Not isnull(ll_patient_workplan_id) Then
//	retrieve(current_patient.cpr_id,ll_patient_workplan_id)
	If not tf_check() then 
	//	Setredraw(true)
		return -1
	End If
End If
//Setredraw(true)
Return 1

end function

public function boolean any_child_treatments ();string ls_find
str_treatment_description lstra_treatments[]
integer li_count


ls_find = "parent_treatment_id=" + string(treatment_id)
li_count = current_patient.treatments.get_treatments(ls_find, lstra_treatments)

if li_count <= 0 then return false

return true

end function

public subroutine refresh ();///////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description: Refresh the treatment status
//
//
// Created By:Sumathi Chinnasamy										Creation dt: 04/03/2001
//
// Modified By:															Modified On:
///////////////////////////////////////////////////////////////////////////////////////////////////////
String 	ls_treatment_status
Datetime ldt_end_dt
Long		ll_close_encounter_id

current_patient.treatments.refresh_status(treatment_id,ls_treatment_status,ldt_end_dt,ll_close_encounter_id)
treatment_status = ls_treatment_status
end_date = ldt_end_dt
close_encounter_id = ll_close_encounter_id

end subroutine

public function integer add_progress (string ps_progress_type, datetime pdt_progress_date_time);Integer		li_rtn

li_rtn = current_patient.treatments.set_treatment_progress(treatment_id, ps_progress_type, pdt_progress_date_time)
//If li_rtn > 0 Then current_patient.treatments.refresh_status(treatment_id)

Return li_rtn
end function

public function integer close (string ps_treatment_status);return close(ps_treatment_status, datetime(today(), now()) )

end function

public function long find_observations (string ps_find, ref str_treatment_observation pstr_treatment_observation[]);long ll_row
long ll_p_rows
long ll_found_count

ll_p_rows = p_observation.rowcount()

ll_found_count = 0
ll_row = p_observation.find(ps_find, 1, ll_p_rows)
DO WHILE ll_row > 0 and ll_row <= ll_p_rows
	ll_found_count += 1

	pstr_treatment_observation[ll_found_count].observation_sequence = p_observation.object.observation_sequence[ll_row]
	pstr_treatment_observation[ll_found_count].observation_id = p_observation.object.observation_id[ll_row]
	pstr_treatment_observation[ll_found_count].composite_flag = p_observation.object.composite_flag[ll_row]
	pstr_treatment_observation[ll_found_count].observation_description = datalist.observation_description(pstr_treatment_observation[ll_found_count].observation_id)
	pstr_treatment_observation[ll_found_count].parent_observation_sequence = p_observation.object.parent_observation_sequence[ll_row]
	pstr_treatment_observation[ll_found_count].service = p_observation.object.service[ll_row]
	pstr_treatment_observation[ll_found_count].created = p_observation.object.created[ll_row]
	pstr_treatment_observation[ll_found_count].created_by = p_observation.object.created_by[ll_row]
	pstr_treatment_observation[ll_found_count].observed_by = p_observation.object.observed_by[ll_row]
	
	ll_row = p_observation.find(ps_find, ll_row + 1, ll_p_rows + 1)
LOOP

return ll_found_count



end function

public function long add_comment (string ps_comment);long ll_observation_sequence

setnull(ll_observation_sequence)

return add_comment(ll_observation_sequence, ps_comment)

end function

public function integer define_treatment ();/////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description: Call the respective treatment component to define a treatment
//
// Returns: 1 - Success 
//          0 - No Operation
//         -1 - Failure
//
// Created By:Sumathi Chinnasamy										Creation dt: 04/27/2000
//
// Modified By:															Modified On:
///////////////////////////////////////////////////////////////////////////////////////////////////////

assessment = f_empty_assessment()

Return define_treatment(assessment)

end function

public function long remove_results (long pl_observation_sequence, string ps_location);integer li_result_sequence

setnull(li_result_sequence)

return remove_results(pl_observation_sequence, ps_location, li_result_sequence)


end function

public function integer get_result (long pl_observation_sequence, integer pi_result_sequence, string ps_location, ref datetime pdt_result_date_time, ref string ps_result_value, ref string ps_result_unit, ref string ps_abnormal_flag, ref string ps_abnormal_nature);long ll_row
integer li_sts
string ls_find
long ll_p_rows


ll_p_rows = p_observation_result.rowcount()

// We must have have an observation sequence
if isnull(pl_observation_sequence) then
	log.log(this, "get_result()", "Null observation sequence", 4)
	return -1
end if

// Find the result record
ls_find = "observation_sequence=" + string(pl_observation_sequence)
ls_find += " and result_sequence=" + string(pi_result_sequence)
ls_find += " and location='" + ps_location + "'"
ll_row = p_observation_result.find(ls_find, 1, ll_p_rows)
if ll_row > 0 then
	pdt_result_date_time = p_observation_result.object.result_date_time[ll_row]
	ps_result_value = p_observation_result.object.result_value[ll_row]
	ps_result_unit = p_observation_result.object.result_unit[ll_row]
	ps_abnormal_flag = p_observation_result.object.abnormal_flag[ll_row]
	ps_abnormal_nature = p_observation_result.object.abnormal_nature[ll_row]
	li_sts = 1
else
	li_sts = 0
end if


return li_sts



end function

public function boolean observation_is_any_locations (long pl_observation_sequence, integer pi_result_sequence);long ll_row
string ls_find
string ls_location
datetime ldt_result_date_time
long ll_r_count

ll_r_count = p_observation_result.rowcount()

ls_find = "observation_sequence=" + string(pl_observation_sequence)
ls_find += " and result_sequence=" + string(pi_result_sequence)
ll_row = p_observation_result.find(ls_find, 1, ll_r_count)

DO WHILE ll_row > 0 and ll_row <= ll_r_count
	ldt_result_date_time = p_observation_result.object.result_date_time[ll_row]
	ls_location = p_observation_result.object.location[ll_row]
	
	// If the result_date_time is not null then we found one
	if not isnull(ldt_result_date_time) then return true
		
	// If the result_date_time is null then this location has been
	// deleted so skip to the next location
	ll_row = p_observation_result.find(ls_find, ll_row + 1, ll_r_count + 1)
	DO WHILE true
		if ll_row <= 0 then exit
		if ll_row > ll_r_count then exit
		if ls_location <> p_observation_result.object.location[ll_row] then exit
		ll_row = p_observation_result.find(ls_find, ll_row + 1, ll_r_count + 1)
	LOOP
LOOP


return false

end function

public function integer observation_severity (long pl_observation_sequence);long ll_row
string ls_find
string ls_location
integer li_result_sequence
datetime ldt_result_date_time
long ll_r_count
integer li_severity
integer li_max_severity

setnull(li_max_severity)

ll_r_count = p_observation_result.rowcount()

ls_find = "observation_sequence=" + string(pl_observation_sequence)
ll_row = p_observation_result.find(ls_find, 1, ll_r_count)

DO WHILE ll_row > 0 and ll_row <= ll_r_count
	ldt_result_date_time = p_observation_result.object.result_date_time[ll_row]
	li_result_sequence = p_observation_result.object.result_sequence[ll_row]
	ls_location = p_observation_result.object.location[ll_row]
	
	// If the result_date_time is not null then we found one so check its severity
	if not isnull(ldt_result_date_time) then
		li_severity = p_observation_result.object.severity[ll_row]
		if isnull(li_max_severity) then
			li_max_severity = li_severity
		elseif li_severity > li_max_severity then
			li_max_severity = li_severity
		end if
	end if
	
	// Skip to the next distinct result/location pair
	ll_row = p_observation_result.find(ls_find, ll_row + 1, ll_r_count + 1)
	DO WHILE true
		if ll_row <= 0 then exit
		if ll_row > ll_r_count then exit
		if li_result_sequence <> p_observation_result.object.result_sequence[ll_row] then exit
		if ls_location <> p_observation_result.object.location[ll_row] then exit
		ll_row = p_observation_result.find(ls_find, ll_row + 1, ll_r_count + 1)
	LOOP
LOOP


return li_max_severity

end function

public function string execute_script (long pl_script_id);
//str_script_params lstr_params
//str_script_returns lstr_returns
//u_component_script luo_script
string ls_null
//long i

setnull(ls_null)


//luo_script = f_get_script_component(pl_script_id)
//if isnull(luo_script) then return ls_null

//lstr_params.param_count = 2
//lstr_params.param_name[1] = "CPR_ID"
//lstr_params.param_value[1] = parent_patient.cpr_id
//lstr_params.param_name[2] = "TREATMENT_ID"
//lstr_params.param_value[2] = string(treatment_id)

//lstr_returns = luo_script.execute_script(pl_script_id, lstr_params)

//component_manager.destroy_component(luo_script)

//for i = 1 to lstr_returns.return_count
//	if lstr_returns.return_name[i] = "RETURN" then return lstr_returns.return_value[i]
//next

return ls_null




end function

public function integer populate_defaults_from_actuals (ref str_observation_tree pstr_tree, long pl_parent_observation_sequence);integer i
long ll_child_observation_sequence
string ls_composite_flag
integer li_sts
integer li_count
long ll_stage

setnull(ll_stage)
li_sts = 0

// Loop through the branches of this tree and get the defaults for each child observation
for i = 1 to pstr_tree.branch_count
	// First get the observation_sequence (if any) for the child observation
	ll_child_observation_sequence = find_observation( &
													pl_parent_observation_sequence, &
													pstr_tree.branch[i].child_observation_id, &
													pstr_tree.branch[i].child_ordinal, &
													pstr_tree.branch[i].observation_tag, &
													ll_stage)
													
	// If there is no child observation_sequence then we may assume that there are no results for this child
	if isnull(ll_child_observation_sequence) then continue

	// Get the composite_flag for the child observation
	ls_composite_flag = datalist.observation_composite_flag(pstr_tree.branch[i].child_observation_id)
	
	if ls_composite_flag = "Y" then
		// If the child is composite, then recursively call this method to get the results of its children
		li_count = populate_defaults_from_actuals(pstr_tree.branch[i].child_observation_tree, ll_child_observation_sequence)
	else
		// If the child is simple, then put it's results into the child branch structure
		pstr_tree.branch[i].default_result_count = populate_defaults_from_actuals(ll_child_observation_sequence, pstr_tree.branch[i].default_result)
	end if
	
	if li_count > 0 then li_sts = 1
next

return li_sts


end function

public function integer populate_defaults_from_actuals (long pl_observation_sequence, ref str_exam_default_result pstra_results[]);u_unit luo_unit
string ls_temp
long ll_row
string ls_find

datetime ldt_result_date_time
integer li_result_sequence
string ls_location

long ll_r_count
integer li_found_count
integer i
integer lia_result_sequence[]
string lsa_location[]
string lsa_user_id[]
string lsa_result_value[]
string lsa_result_unit[]
datetime ldta_result_date_time[]
string ls_results
integer li_out_count

li_found_count = 0

ll_r_count = p_observation_result.rowcount()

ls_find = "observation_sequence=" + string(pl_observation_sequence)
ll_row = p_observation_result.find(ls_find, 1, ll_r_count)

DO WHILE ll_row > 0 and ll_row <= ll_r_count
	li_result_sequence = p_observation_result.object.result_sequence[ll_row]
	ls_location = p_observation_result.object.location[ll_row]
	
	// If this is the same result sequence and location then skip it
	if li_found_count > 0 then
		if lia_result_sequence[li_found_count] = li_result_sequence &
		 and lsa_location[li_found_count] = ls_location then
			ll_row = p_observation_result.find(ls_find, ll_row + 1, ll_r_count + 1)
			continue
		end if
	end if

	// We found a unique result_sequence / location pair, so record it
	li_found_count += 1

	lia_result_sequence[li_found_count] = li_result_sequence
	lsa_location[li_found_count] = ls_location
	lsa_user_id[li_found_count] = p_observation_result.object.observed_by[ll_row]
	lsa_result_value[li_found_count] = p_observation_result.object.result_value[ll_row]
	lsa_result_unit[li_found_count] = p_observation_result.object.result_unit[ll_row]
	ldta_result_date_time[li_found_count] = p_observation_result.object.result_date_time[ll_row]

	ll_row = p_observation_result.find(ls_find, ll_row + 1, ll_r_count + 1)
LOOP

li_out_count = 0

// Now populate the branch defaults with the selected results
// Ignore the results with a null result_date_time
for i = 1 to li_found_count
	if isnull(ldta_result_date_time[i]) then continue

	li_out_count += 1
	pstra_results[li_out_count].result_sequence = lia_result_sequence[i]
	pstra_results[li_out_count].location = lsa_location[i]
	pstra_results[li_out_count].user_id = lsa_user_id[i]
	pstra_results[li_out_count].result_value = lsa_result_value[i]
	pstra_results[li_out_count].result_unit = lsa_result_unit[i]
next

return li_out_count

end function

public function integer set_exam_defaults (long pl_exam_sequence, long pl_branch_id, long pl_observation_sequence);integer li_result_sequence
string ls_location

setnull(li_result_sequence)
setnull(ls_location)

return set_exam_defaults(pl_exam_sequence, pl_branch_id, pl_observation_sequence, li_result_sequence, ls_location)

end function

public function integer add_progress (string ps_progress_type, string ps_progress);return current_patient.treatments.set_treatment_progress(treatment_id, ps_progress_type, ps_progress)

end function

public subroutine treatment_group (ref string ps_treatment_group, ref integer pi_treatment_sort);CHOOSE CASE treatment_type
	CASE	"FOLLOWUPMED"
		ps_treatment_group = "Medication"
		pi_treatment_sort = 10
	CASE	"FOLLOWUPPROC"
		ps_treatment_group = "Procedure"
		pi_treatment_sort = 11
	CASE	"FOLLOWUPTEST"
		ps_treatment_group = "Test"
		pi_treatment_sort =12
	CASE	"REFERRALMED"
		ps_treatment_group = "Medication"
		pi_treatment_sort = 6
	CASE	"REFERRALPROC"
		ps_treatment_group = "Procedure"
		pi_treatment_sort = 7
	CASE	"REFERRALTEST"
		ps_treatment_group = "Test"
		pi_treatment_sort = 8
	CASE "ACTIVITY"
		ps_treatment_group = "Activity"
		pi_treatment_sort = 4
	CASE "REFERRAL"
		ps_treatment_group = "Referral"
		pi_treatment_sort = 5
	CASE "FOLLOWUP"
		ps_treatment_group = "Follow Up"
		pi_treatment_sort = 9
	CASE "MEDICATION"
		ps_treatment_group = "Medication"
		pi_treatment_sort = 2
	CASE "PROCEDURE"
		ps_treatment_group = "Procedure"
		pi_treatment_sort = 3
	CASE "OFFICEMED"
		ps_treatment_group = "Medication"
		pi_treatment_sort = 1
	CASE ELSE
		ps_treatment_group = ""
		pi_treatment_sort = 0
END CHOOSE



end subroutine

public function boolean observation_is_any_results (long pl_observation_sequence, string ps_location);long ll_row
string ls_find
integer li_result_sequence
datetime ldt_result_date_time
long ll_r_count

ll_r_count = p_observation_result.rowcount()

ls_find = "observation_sequence=" + string(pl_observation_sequence)
ls_find += " and location='" + ps_location + "'"
ll_row = p_observation_result.find(ls_find, 1, ll_r_count)

DO WHILE ll_row > 0 and ll_row <= ll_r_count
	ldt_result_date_time = p_observation_result.object.result_date_time[ll_row]
	li_result_sequence = p_observation_result.object.result_sequence[ll_row]
	
	// If the result_date_time is not null then we found one
	if not isnull(ldt_result_date_time) then return true
		
	// If the result_date_time is null then this location has been
	// deleted so skip to the next location
	ll_row = p_observation_result.find(ls_find, ll_row + 1, ll_r_count + 1)
	DO WHILE true
		if ll_row <= 0 then exit
		if ll_row > ll_r_count then exit
		if li_result_sequence <> p_observation_result.object.result_sequence[ll_row] then exit
		ll_row = p_observation_result.find(ls_find, ll_row + 1, ll_r_count + 1)
	LOOP
LOOP


return false

end function

public function boolean is_child ();CHOOSE CASE treatment_type
	CASE	"FOLLOWUPMED"
		return true
	CASE	"FOLLOWUPPROC"
		return true
	CASE	"FOLLOWUPTEST"
		return true
	CASE	"REFERRALMED"
		return true
	CASE	"REFERRALPROC"
		return true
	CASE	"REFERRALTEST"
		return true
	CASE ELSE
		return false
END CHOOSE
end function

public function integer get_location_description (long pl_observation_sequence, integer pi_result_sequence, string ps_location, ref string ps_description);string ls_temp
u_unit luo_unit
str_p_observation_result lstr_p_result
str_c_observation_result lstr_c_result
string ls_observation_id

ls_observation_id = get_observation_id(pl_observation_sequence)
if isnull(ls_observation_id) then
	log.log(this, "get_location_description()", "Error getting observation_id", 4)
	return -1
end if

lstr_c_result = datalist.observation_result(ls_observation_id, pi_result_sequence)
if isnull(lstr_c_result.result_sequence) then
	log.log(this, "get_location_description()", "Error getting result (" + ls_observation_id + ", " + string(pi_result_sequence) + ")", 4)
	return -1
end if
	
lstr_p_result = observation_result(pl_observation_sequence, pi_result_sequence, ps_location)

ps_description = datalist.location_description(ps_location)
if lstr_c_result.result_amount_flag = "Y" then ps_description += "="

if not isnull(lstr_p_result.result_date_time) then
	if lstr_c_result.result_amount_flag = "Y" then
		if not isnull(lstr_p_result.result_value) and trim(lstr_p_result.result_value) <> "" then
			luo_unit = unit_list.find_unit(lstr_p_result.result_unit)
			if isnull(luo_unit) then
				ls_temp = ""
			else
				ls_temp = luo_unit.pretty_amount_unit(lstr_p_result.result_value, lstr_c_result.unit_preference, lstr_c_result.display_mask)
			end if	
	
			ps_description += ls_temp
		end if
	end if
	
	return 1
else
	return 0
end if





end function

public function long remove_result (long pl_observation_sequence, integer pi_result_sequence, string ps_location);return remove_results(pl_observation_sequence, ps_location, pi_result_sequence)


end function

public function long remove_results (long pl_observation_sequence, integer pi_result_sequence);string ls_location

setnull(ls_location)

return remove_results(pl_observation_sequence, ls_location, pi_result_sequence)


end function

public function integer do_autoperform_services ();///////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description:Get the first auto perform service(if any) and perform.
//
// Returns: 1 - Success 
//         -1 - Failure
//
// Created By:Sumathi Chinnasamy										Creation dt: 11/16/2000
//
// Modified By:															Modified On:
///////////////////////////////////////////////////////////////////////////////////////////////////////

Long		ll_workplan_item_id

DECLARE lsp_treatment_auto_perform_services PROCEDURE FOR dbo.sp_treatment_auto_perform_services
         @ps_cpr_id = :current_patient.cpr_id,   
         @pl_treatment_id = :treatment_id,
			@ps_user_id = :current_user.user_id;

Setnull(ll_workplan_item_id)
Execute lsp_treatment_auto_perform_services;
If not tf_check() Then Return -1

Fetch lsp_treatment_auto_perform_services into :ll_workplan_item_id;
If not tf_check() Then Return -1
Close lsp_treatment_auto_perform_services;
If not tf_check() Then Return -1
If Not isnull(ll_workplan_item_id) Then 
	service_list.do_service(ll_workplan_item_id,this)
//	service_list.do_service(ll_workplan_item_id)
End If

Return 1

end function

public function str_p_observation_result observation_result (long pl_observation_sequence, integer pi_result_sequence, string ps_location);string ls_find
long ll_row
str_p_observation_result lstr_result
str_c_observation_result lstr_c_result

// This method returns a structure holding the data elements for a single result.

ls_find = "observation_sequence=" + string(pl_observation_sequence)
ls_find += " and result_sequence=" + string(pi_result_sequence)
ls_find += " and location='" + ps_location + "'"
ll_row = p_observation_result.find(ls_find, 1, p_observation_result.rowcount())
if ll_row > 0 then
	lstr_result.cpr_id = p_observation_result.object.cpr_id[ll_row]
	lstr_result.treatment_id = p_observation_result.object.treatment_id[ll_row]
	lstr_result.observation_sequence = p_observation_result.object.observation_sequence[ll_row]
	lstr_result.location_result_sequence = p_observation_result.object.location_result_sequence[ll_row]
	lstr_result.location = p_observation_result.object.location[ll_row]
	lstr_result.observation_id = p_observation_result.object.observation_id[ll_row]
	lstr_result.result_sequence = p_observation_result.object.result_sequence[ll_row]
	lstr_result.encounter_id = p_observation_result.object.encounter_id[ll_row]
	lstr_result.result_date_time = p_observation_result.object.result_date_time[ll_row]
	lstr_result.attachment_id = p_observation_result.object.attachment_id[ll_row]
	lstr_result.result_value = p_observation_result.object.result_value[ll_row]
	lstr_result.result_unit = p_observation_result.object.result_unit[ll_row]
	lstr_result.abnormal_flag = p_observation_result.object.abnormal_flag[ll_row]
	lstr_result.abnormal_nature = p_observation_result.object.abnormal_nature[ll_row]
	lstr_result.observed_by = p_observation_result.object.observed_by[ll_row]
	lstr_result.created = p_observation_result.object.created[ll_row]
	lstr_result.created_by = p_observation_result.object.created_by[ll_row]
	
	// Check for a null result_unit
	if isnull(lstr_result.result_unit) then
		// replace with result_unit from c_table
		lstr_c_result = datalist.observation_result(p_observation_result.object.observation_id[ll_row], pi_result_sequence)
		lstr_result.result_unit = lstr_c_result.result_unit
	end if
else
	setnull(lstr_result.cpr_id)
	setnull(lstr_result.treatment_id)
	setnull(lstr_result.observation_sequence)
	setnull(lstr_result.location_result_sequence)
	setnull(lstr_result.location)
	setnull(lstr_result.observation_id)
	setnull(lstr_result.result_sequence)
	setnull(lstr_result.encounter_id)
	setnull(lstr_result.result_date_time)
	setnull(lstr_result.attachment_id)
	setnull(lstr_result.result_value)
	setnull(lstr_result.result_unit)
	setnull(lstr_result.abnormal_flag)
	setnull(lstr_result.abnormal_nature)
	setnull(lstr_result.observed_by)
	setnull(lstr_result.created)
	setnull(lstr_result.created_by)
end if

return lstr_result

end function

public function long find_observation (long pl_parent_observation_sequence, string ps_observation_id, integer pi_child_ordinal, string ps_observation_tag, long pl_stage);long ll_row
integer li_sts
long ll_observation_sequence
string ls_find
long i
long ll_p_rows
boolean lb_followon
integer li_found_count

if pi_child_ordinal <= 0 then setnull(pi_child_ordinal)

ll_p_rows = p_observation.rowcount()

// Now, count the total p_observation records under the corresponding
// parent with the same child observation_id
li_found_count = 0

if isnull(pl_parent_observation_sequence) then
	ls_find = "isnull(parent_observation_sequence)"
	// if the parent_observation_sequence is null then don't use the child ordinal
	setnull(pi_child_ordinal)
else
	ls_find = "parent_observation_sequence=" + string(pl_parent_observation_sequence)
end if

ls_find += " and observation_id='" + ps_observation_id + "'"

if isnull(ps_observation_tag) then
	ls_find += " and isnull(observation_tag)"
else
	ls_find += " and observation_tag='" + ps_observation_tag + "'"
end if

if not isnull(pl_stage) then
	ls_find += " and stage=" + string(pl_stage)
end if

ll_row = p_observation.find(ls_find, 1, ll_p_rows)
DO WHILE ll_row > 0 and ll_row <= ll_p_rows
	li_found_count += 1
	// If the found count equals the child ordinal, then assume that this is the corresponding p record
	if li_found_count = pi_child_ordinal or isnull(pi_child_ordinal) then
		// return the existing observation_sequence
		ll_observation_sequence = p_observation.object.observation_sequence[ll_row]
		return ll_observation_sequence
	end if
	
	ll_row = p_observation.find(ls_find, ll_row + 1, ll_p_rows + 1)
LOOP

// If we get here, then we didn't find the observation
setnull(ll_observation_sequence)

return ll_observation_sequence



end function

public function integer get_child_observations (long pl_parent_observation_sequence, ref str_p_observation pstra_observations[]);integer li_count
integer li_result_count
string ls_find
long ll_row
long ll_rowcount

ll_rowcount = p_observation.rowcount()

// First, find a p_Observation record which has a stage number and is
// under the specified parent
ls_find = "parent_observation_sequence=" + string(pl_parent_observation_sequence)
ll_row = p_observation.find(ls_find, 1, ll_rowcount)
DO WHILE ll_row > 0 and ll_row <= ll_rowcount
	// Create the structure for this observation
	li_count += 1
	pstra_observations[li_count] = get_observation_structure(ll_row)
	
	// Get the next observation
	ll_row = p_observation.find(ls_find, ll_row + 1, ll_rowcount + 1)
LOOP

return li_count

end function

public function long add_result (long pl_observation_sequence, integer pi_result_sequence, string ps_location, datetime pdt_result_date_time);string ls_null

setnull(ls_null)

return add_result(pl_observation_sequence, pi_result_sequence, ps_location, pdt_result_date_time, ls_null, ls_null, ls_null, ls_null)

end function

public function long add_comment (long pl_observation_sequence, string ps_comment);string ls_comment_title
string ls_abnormal_flag
integer li_severity

setnull(ls_comment_title)
setnull(ls_abnormal_flag)
setnull(li_severity)

return add_comment(pl_observation_sequence, ls_comment_title, ls_abnormal_flag, li_severity, ps_comment)


end function

public function long add_comment (long pl_observation_sequence, string ps_comment_title, string ps_abnormal_flag, integer pi_severity, string ps_comment);long ll_attachment_id

setnull(ll_attachment_id)

return add_comment(pl_observation_sequence, ps_comment_title, ps_abnormal_flag, pi_severity, ll_attachment_id, ps_comment)


end function

public function long add_comment (long pl_observation_sequence, string ps_comment_title, string ps_abnormal_flag, integer pi_severity, long pl_attachment_id, string ps_comment);long ll_row
long ll_observation_comment_id
string ls_observation_id
integer li_sts
string ls_find
string ls_null
datetime ldt_comment_date_time
long ll_patient_workplan_item_id
integer li_diagnosis_sequence

setnull(ls_null)
setnull(li_diagnosis_sequence)
setnull(ldt_comment_date_time)
setnull(ll_patient_workplan_item_id)

if isnull(pl_observation_sequence) then
	log.log(this, "add_comment()", "Null observation_sequence", 4)
	return -1
end if

setnull(ls_observation_id)

if not isnull(pl_attachment_id) and isnull(ps_comment) then
	ps_comment = current_patient.attachments.attachment_text(pl_attachment_id)
end if


li_sts = f_set_progress2(current_patient.cpr_id, & 
								"Observation", &
								pl_observation_sequence, &
								"Comment", &
								ps_comment_title, &
								ps_comment, &
								ldt_comment_date_time, &
								pi_severity, &
								pl_attachment_id, &
								ll_patient_workplan_item_id, &
								li_diagnosis_sequence, &
								ps_abnormal_flag)
if li_sts < 0 then return -1

return 1


end function

public function string get_observation_id (long pl_observation_sequence);long ll_row
string ls_find
long ll_o_count
string ls_observation_id

ll_o_count = p_observation.rowcount()

setnull(ls_observation_id)

if isnull(pl_observation_sequence) then return ls_observation_id

ls_find = "observation_sequence=" + string(pl_observation_sequence)
ll_row = p_observation.find(ls_find, 1, ll_o_count)
if ll_row <= 0 then
	log.log(this, "remove_results()", "Observation_sequence not found (" + string(pl_observation_sequence) + ")", 4)
	return ls_observation_id
end if

ls_observation_id = p_observation.object.observation_id[ll_row]

return ls_observation_id

end function

private function integer set_exam_defaults (long pl_observation_sequence, integer pi_default_result_count, str_exam_default_result pstra_default_results[]);integer li_sts
long i
string ls_null

setnull(ls_null)


// If this child is simple then set the default results
for i = 1 to pi_default_result_count
	li_sts = add_result(pl_observation_sequence, &
								pstra_default_results[i].result_sequence, &
								pstra_default_results[i].location, &
								datetime(today(), now()), &
								pstra_default_results[i].result_value, &
								pstra_default_results[i].result_unit, &
								ls_null, &
								ls_null )
	if li_sts < 0 then
		log.log(this, "set_exam_defaults()", "Error adding default results", 4)
		return -1
	end if
next
									
return pi_default_result_count

end function

public function integer add_collection_result (long pl_observation_sequence, string ps_location);string ls_observation_id
integer li_sts
integer li_result_sequence

DECLARE lsp_add_default_collect_result PROCEDURE FOR dbo.sp_add_default_collect_result
		@ps_observation_id = :ls_observation_id,
		@pi_result_sequence = :li_result_sequence OUT;

ls_observation_id = get_observation_id(pl_observation_sequence)

SELECT min(result_sequence) as result_sequence
INTO :li_result_sequence
FROM c_Observation_Result
WHERE observation_id = :ls_observation_id
AND result_type = 'COLLECT'
AND status = 'OK';
if not tf_check() then return -1
if sqlca.sqlcode = 100 or isnull(li_result_sequence) then
	EXECUTE lsp_add_default_collect_result;
	if not tf_check() then return -1
	
	FETCH lsp_add_default_collect_result INTO :li_result_sequence;
	if not tf_check() then return -1
	
	CLOSE lsp_add_default_collect_result;
end if

li_sts = remove_results(pl_observation_sequence, li_result_sequence)

li_sts = add_result(pl_observation_sequence, li_result_sequence, ps_location)

return li_sts

end function

public function long remove_comment (long pl_observation_sequence, long pl_observation_comment_id);string ls_observation_id
integer li_sts
string ls_find
datetime ldt_comment_date_time
string ls_comment_type
string ls_comment_title
string ls_comment
long ll_attachment_id
integer li_diagnosis_sequence
long ll_patient_workplan_item_id

if isnull(pl_observation_sequence) then
	log.log(this, "add_comment()", "Null observation_sequence", 4)
	return -1
end if

setnull(ls_comment)
setnull(li_diagnosis_sequence)
setnull(ll_patient_workplan_item_id)
setnull(ll_attachment_id)

SELECT comment_type,
		comment_title,
		comment_date_time,
		observation_id
INTO :ls_comment_type,
		:ls_comment_title,
		:ldt_comment_date_time,
		:ls_observation_id
FROM p_Observation_Comment
WHERE cpr_id = :current_patient.cpr_id
AND observation_sequence = :pl_observation_sequence
AND observation_comment_id = :pl_observation_comment_id;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then return 0


li_sts = f_set_progress2(current_patient.cpr_id, & 
								"Observation", &
								pl_observation_sequence, &
								ls_comment_type, &
								ls_comment_title, &
								ls_comment, &
								ldt_comment_date_time, &
								0, &
								ll_attachment_id, &
								ll_patient_workplan_item_id, &
								li_diagnosis_sequence, &
								"N")
if li_sts < 0 then return -1

return 1


end function

public function string get_observation_description (long pl_observation_sequence);long ll_row
string ls_find
long ll_o_count
string ls_observation_id

ll_o_count = p_observation.rowcount()

setnull(ls_observation_id)

if isnull(pl_observation_sequence) then return ls_observation_id

ls_find = "observation_sequence=" + string(pl_observation_sequence)
ll_row = p_observation.find(ls_find, 1, ll_o_count)
if ll_row <= 0 then
	log.log(this, "remove_results()", "Observation_sequence not found (" + string(pl_observation_sequence) + ")", 4)
	return ls_observation_id
end if

ls_observation_id = p_observation.object.description[ll_row]

return ls_observation_id

end function

public function integer unset_progress_key (string ps_progress_type, string ps_progress_key);string ls_progress_value

setnull(ls_progress_value)

return current_patient.treatments.set_treatment_progress_key(treatment_id, ps_progress_type, ps_progress_key, ls_progress_value)


end function

public function integer set_progress_key (string ps_progress_type, string ps_progress_key, string ps_progress_value);integer li_sts

// If we don't have a treatment_id yet then this is a prospective treatment.  In that case just log the
// progress record to the new_progress structure array
if isnull(treatment_id) or treatment_id = 0 then
	new_progress.progress_count += 1
	new_progress.progress[new_progress.progress_count].encounter_id = current_patient.open_encounter_id
	new_progress.progress[new_progress.progress_count].progress_type = ps_progress_type
	new_progress.progress[new_progress.progress_count].progress_key = ps_progress_key
	setnull(new_progress.progress[new_progress.progress_count].progress_date_time)
	new_progress.progress[new_progress.progress_count].user_id = current_user.user_id
	new_progress.progress[new_progress.progress_count].created_by = current_scribe.user_id
	new_progress.progress[new_progress.progress_count].progress = ps_progress_value
	li_sts = 1
else
	// Otherwise, just report the new progress record
	li_sts = current_patient.treatments.set_treatment_progress(treatment_id, ps_progress_type, ps_progress_key, ps_progress_value)
end if


return li_sts


end function

public function integer xx_define_treatment ();///////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description: If an external component then call the respective method
//
// Returns: 1 - Success 
//          100 - No decendent class
//
// Created By:Sumathi Chinnasamy										Creation dt: 04/27/2000
//
// Modified By:															Modified On:
///////////////////////////////////////////////////////////////////////////////////////////////////////

string lsa_attributes[]
string lsa_values[]
long ll_count
integer li_sts
string ls_attribute
string ls_value
long ll_row
long i, j
str_attributes lstr_attributes
string ls_description

If ole_class then
	ll_count = get_attributes(lsa_attributes, lsa_values)
	li_sts = ole.define_treatment(treatment_type, ll_count, lsa_attributes, lsa_values)
	if li_sts <= 0 then return li_sts
	
	treatment_count = ole.treatment_count
	for i = 1 to treatment_count
		treatment_definition[j].treatment_type = treatment_type
		treatment_definition[j].item_description = ole.treatments[i].description
		treatment_definition[j].attribute_count = ole.treatments[i].attribute_count
		for j = 1 to treatment_definition[i].attribute_count
			treatment_definition[i].attribute[j] = ole.treatments[i].attribute[j]
			treatment_definition[i].value[j] = ole.treatments[i].value[j]
		next
	next
Else
	li_sts = f_get_params(id, "Order", lstr_attributes)
	
	ls_description = f_attribute_find_attribute(lstr_attributes, "treatment_description")
	if isnull(ls_description) then ls_description = datalist.treatment_type_description(treatment_type)

	// If not overridden by descendent class, then create a treatment from the treatment type
	treatment_count = 1
	treatment_definition[1].treatment_type = treatment_type
	treatment_definition[1].item_description = ls_description
	treatment_definition[1].attribute_count = f_attribute_str_to_arrays(lstr_attributes, &
																							treatment_definition[1].attribute, &
																							treatment_definition[1].value)

	Return 1
end if


end function

public function integer do_treatment ();//String					buttons[], ls_service_param
//String					ls_button,ls_help,ls_title
//String					ls_temp,ls_service
//String					ls_attributes[],ls_values[],ls_attribute,ls_value
//Integer					button_pressed, li_attachment_button
//Integer					li_sts,li_attribute_count
//Boolean 					lb_encounter_open = False, lb_display_encounter_open = False
//Boolean 					lb_no_attachments
//Long 						ll_encounter_log_id
//Long						ll_count,i,ll_service_count,ll_patient_workplan_item_id
//long ll_service_sequence
//string ls_arg
///* user defined */
//window 					lw_pop_buttons
//str_popup				popup
//str_popup_return 		popup_return
//u_attachment_list		luo_attachment_list
//u_ds_data 				luo_services
//
//
//DECLARE lsp_get_treatment_service_attributes PROCEDURE FOR dbo.sp_get_treatment_service_attributes
//		@ps_treatment_type = :treatment_type,
//		@pl_service_sequence = :ll_service_sequence ;
//
//luo_services = CREATE u_ds_data
//
//// Set current or past encounter status
//IF current_display_encounter.encounter_status = "OPEN" THEN lb_display_encounter_open = TRUE
//// Set If valid encounter
//If Not Isnull(current_patient.open_encounter) Then lb_encounter_open = true
//
//// Display the services already dispatched for this treatment
//If NOT current_patient.display_only AND lb_display_encounter_open THEN
//	luo_services.set_dataobject("dw_do_treatment_items", cprdb)
//	ll_count = luo_services.retrieve(current_patient.cpr_id, treatment_id)
//	
//	for i = 1 to ll_count
//		ls_button = luo_services.object.button[i]
//		ls_help = luo_services.object.description[i]
//		ls_title = luo_services.object.service_description[i]
//		If Not Isnull(ls_button) And Len(ls_button) > 0 Then
//			popup.button_count = popup.button_count + 1
//			popup.button_icons[popup.button_count] = ls_button
//			popup.button_helps[popup.button_count] = ls_help
//			popup.button_titles[popup.button_count] = ls_title
//			buttons[popup.button_count] = "ID=" + string(luo_services.object.patient_workplan_item_id[i])
//		End If
//	next
//End If
//
//// Display the services permanently associated with this treatment type
//If NOT current_patient.display_only AND lb_display_encounter_open THEN
//	if isnull(end_date) then
//		luo_services.set_dataobject("dw_do_treatment_before_services", cprdb)
//	else
//		luo_services.set_dataobject("dw_do_treatment_after_services", cprdb)
//	end if
//	ll_count = luo_services.retrieve(treatment_type)
//	
//	for i = 1 to ll_count
//		ls_button = luo_services.object.button[i]
//		ls_help = luo_services.object.button_help[i]
//		ls_title = luo_services.object.button_title[i]
//		If Not Isnull(ls_button) And Len(ls_button) > 0 Then
//			popup.button_count = popup.button_count + 1
//			popup.button_icons[popup.button_count] = ls_button
//			popup.button_helps[popup.button_count] = ls_help
//			popup.button_titles[popup.button_count] = ls_title
//			// Concatinate service sequence and service id
//			buttons[popup.button_count] = "SERVICE=" + string(luo_services.object.service_sequence[i])+&
//													","+luo_services.object.service[i]
//		End If
//	next
//End If
//
//ll_service_count = popup.button_count
//
//// We can perform treatments if they show on the open encounter and have an associated service
//If not isnull(procedure_id) then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button18.bmp"
//	popup.button_helps[popup.button_count] = "Enter New Progress Notes"
//	popup.button_titles[popup.button_count] = "Progress Notes"
//	buttons[popup.button_count] = "PROGRESS"
//End If
//
//// We can cancel a treatment if it's open and shows on the open encounter
//if isnull(treatment_status) and not current_patient.display_only and lb_display_encounter_open then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button12.bmp"
//	popup.button_helps[popup.button_count] = "Cancel This Treatment"
//	popup.button_titles[popup.button_count] = "Cancel Treatment"
//	buttons[popup.button_count] = "CANCEL TREATMENT"
//end if
//
//// We can only edit billing for a treatment which was created in the current open encounter
//if not isnull(procedure_id) and lb_display_encounter_open and &
//	open_encounter_id = current_display_encounter.encounter_id then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button21.bmp"
//	popup.button_helps[popup.button_count] = "View/Edit billing for this treatment"
//	popup.button_titles[popup.button_count] = "Billing"
//	buttons[popup.button_count] = "BILLING"
//end if
//
//if true then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button17.bmp"
//	popup.button_helps[popup.button_count] = "Treatment Properties"
//	popup.button_titles[popup.button_count] = "Properties"
//	buttons[popup.button_count] = "PROPERTIES"
//end if
//
//if true then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button11.bmp"
//	popup.button_helps[popup.button_count] = "Cancel"
//	popup.button_titles[popup.button_count] = "Cancel"
//	buttons[popup.button_count] = "CANCEL"
//end if
//
//if attachment_list.attachment_count <= 0 then
//	lb_no_attachments = true
//else
//	lb_no_attachments = false
//end if
//
//// Only show the attachments button if we have an open encounter or if there are attachments
//if lb_encounter_open or not lb_no_attachments then
//	// When adding the attachment button, set the data_row_count to the number
//	// of the button where then attachment button should be inserted
//	li_attachment_button = popup.button_count
//	popup.data_row_count = li_attachment_button
//	setnull(popup.items[1])
//	setnull(popup.items[2])
//	popup.objectparm = current_patient
//	popup.objectparm2 = attachment_list
//end if
//
//popup.button_titles_used = true
//
//if popup.button_count > 1 then
//	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
//	if isvalid(message.powerobjectparm) then
//		popup_return = message.powerobjectparm
//		button_pressed = popup_return.item_index
//	else
//		button_pressed = message.doubleparm
//	end if
//
//	if button_pressed < 1 or button_pressed > popup.button_count then return 0
//
//	if button_pressed = li_attachment_button then
//		luo_attachment_list = popup_return.objectparm2
//		if lb_no_attachments and not isnull(luo_attachment_list) and isvalid(luo_attachment_list) then
//			if luo_attachment_list.attachment_count > 0 then
//				save_attachment()
//			end if
//		end if
//	end if
//elseif popup.button_count = 1 then
//	button_pressed = 1
//else
//	return 0
//end if
//
//If button_pressed <= ll_service_count then
//	f_split_string(buttons[button_pressed], "=", ls_temp, ls_arg)
//	If ls_temp = "ID" then
//		ll_patient_workplan_item_id = long(ls_arg)
//		li_sts = service_list.do_service(ll_patient_workplan_item_id, this)
//		Return li_sts
//	Elseif ls_temp = "SERVICE" then
//		f_split_string(ls_arg, ",",ls_arg,ls_service)
//		ll_service_sequence = long(ls_arg)
//		EXECUTE lsp_get_treatment_service_attributes;
//		FETCH lsp_get_treatment_service_attributes INTO :ls_attribute,:ls_value;
//		Do While Sqlca.Sqlcode = 0
//			li_attribute_count++
//			ls_attributes[li_attribute_count] = ls_attribute
//			ls_values[li_attribute_count] = ls_value
//			FETCH lsp_get_treatment_service_attributes INTO :ls_attribute,:ls_value;
//		Loop
//		CLOSE lsp_get_treatment_service_attributes;
//		li_sts = service_list.do_service(current_patient.cpr_id, current_patient.open_encounter_id, &
//					ls_service, this,li_attribute_count,ls_attributes,ls_values)
//		Return li_sts
//	End if
//Else
//	CHOOSE CASE buttons[button_pressed]
//		CASE "PROGRESS"
////			popup.data_row_count = 5
////			popup.items[1] = "TREATMENT"
////			popup.items[2] = current_patient.cpr_id
////			popup.items[3] = string(current_patient.open_encounter_id)
////			popup.items[4] = "HISTORY"
////			popup.items[5] = string(treatment_id)
////			openwithparm(w_display_history, popup)
//		CASE "CANCEL TREATMENT"
//			This.Close("CANCELLED")
//		CASE "BILLING"
//			popup.data_row_count = 4
//			popup.items[1] = current_patient.cpr_id
//			popup.items[2] = string(open_encounter_id)
//			popup.items[3] = string(problem_id())
//			popup.items[4] = string(treatment_id)
//			popup.title = "Billing for " + description()
//			openwithparm(w_pick_proc_assessments, popup)
//		CASE "PROPERTIES"
//			display_properties()
//		CASE "CANCEL"
//			Return 0
//		CASE ELSE
//	END CHOOSE
//End if
//
//Return 1
//

//openwithparm(w_do_treatment, this)

string ls_service

ls_service = "TREATMENT_REVIEW"

service_list.do_service(current_patient.cpr_id, &
								current_patient.open_encounter_id, &
								ls_service, &
								this)

return 1

end function

public function integer associate_assessment (long pl_problem_id, boolean pb_associated);integer li_sts

li_sts = current_patient.treatments.set_treatment_assessment(this, pl_problem_id, pb_associated)

return li_sts


end function

public function string assessment_description (boolean pb_all_assessments);str_assessment_description lstra_assessments[]
string ls_description
integer li_count
integer i

setnull(ls_description)

li_count = current_patient.assessments.get_assessments(problem_count, problem_ids, lstra_assessments)
if li_count <= 0 then return ls_description

ls_description = ""
for i = 1 to li_count
	if i > 1 then
		if not pb_all_assessments then exit
		ls_description += "~r~n"
	end if
	ls_description += lstra_assessments[i].assessment
next

return ls_description

end function

public function integer get_comment (long pl_observation_sequence, string ps_comment_title, ref str_observation_comment pstr_comment);// returns structure str_observation_comment_list containing
// the latest comment for the given observation_id/comment_title combination
// where the observation_id is recorded as a root observation in p_Observation
str_observation_comment_list lstr_list
integer i

lstr_list = get_comments(pl_observation_sequence, ps_comment_title)
if lstr_list.comment_count <= 0 then return 0

// Then get the last comment...
pstr_comment = lstr_list.comment[lstr_list.comment_count]

// And add all the other comments as previous comments
pstr_comment.previous_comments.comment_count = lstr_list.comment_count - 1
for i = 1 to lstr_list.comment_count - 1
	pstr_comment.previous_comments.comment[i] = lstr_list.comment[i]
next

return 1

end function

public function integer set_progress (string ps_progress_type, string ps_progress);return current_patient.treatments.set_treatment_progress(treatment_id, ps_progress_type, ps_progress)

end function

public function long add_attachment (long pl_observation_sequence, string ps_comment_title, long pl_attachment_id);string ls_abnormal_flag
integer li_severity
string ls_comment

setnull(ls_abnormal_flag)
setnull(li_severity)
setnull(ls_comment)

if trim(ps_comment_title) = "" then setnull(ps_comment_title)

return add_comment(pl_observation_sequence, ps_comment_title, ls_abnormal_flag, li_severity, pl_attachment_id, ls_comment)


end function

public function integer load_observations ();integer li_sts

if isnull(observation_id) then return 0

li_sts = p_observation.retrieve(parent_patient.cpr_id, treatment_id)
li_sts = p_observation_result.retrieve(parent_patient.cpr_id, treatment_id)
li_sts = p_observation_location.retrieve(parent_patient.cpr_id, treatment_id)
//li_sts = p_observation_result_qualifier.retrieve(parent_patient.cpr_id, treatment_id)

return 1


end function

public function integer close (string ps_treatment_status, datetime pdt_end_date);
add_progress(ps_treatment_status, pdt_end_date)

return 1

end function

public function long add_observation (long pl_parent_observation_sequence, string ps_observation_id, integer pi_child_ordinal, string ps_observation_tag, long pl_stage, boolean pb_find_existing);string ls_service

setnull(ls_service)

if isnull(pl_parent_observation_sequence) then
	log.log(this, "add_observation()", "This method is not allowed to add a root observation", 4)
	return -1
end if

return add_observation(pl_parent_observation_sequence, ps_observation_id, pi_child_ordinal, ps_observation_tag, pl_stage, ls_service, true)

end function

private function integer set_exam_defaults (long pl_parent_observation_sequence, str_observation_tree pstr_tree);string ls_composite_flag
integer li_sts
integer li_found
long i, j
long ll_child_observation_sequence
string ls_null
boolean lb_wait
long ll_stage

setnull(ll_stage)
setnull(ls_null)

li_found = 0

if isvalid(w_pop_please_wait) then
	lb_wait = false
else
	lb_wait = true
	open(w_pop_please_wait)
	w_pop_please_wait.initialize(1, pstr_tree.branch_count)
end if

for i = 1 to pstr_tree.branch_count
	ll_child_observation_sequence = add_observation(pl_parent_observation_sequence, &
																	pstr_tree.branch[i].child_observation_id, &
																	pstr_tree.branch[i].child_ordinal, &
																	pstr_tree.branch[i].observation_tag, &
																	ll_stage, &
																	true)
	if ll_child_observation_sequence <= 0 then
		log.log(this, "set_exam_defaults()", "Error adding new observation", 4)
		if lb_wait then close(w_pop_please_wait)
		return -1
	end if

	ls_composite_flag = datalist.observation_composite_flag(pstr_tree.branch[i].child_observation_id)
	if ls_composite_flag = "Y" then
		// If this child is composite then recursively call this function to set its default results
		li_sts = set_exam_defaults(ll_child_observation_sequence, pstr_tree.branch[i].child_observation_tree)
		if li_sts < 0 then
			log.log(this, "set_exam_defaults()", "Error adding child defaults", 4)
			if lb_wait then close(w_pop_please_wait)
			return -1
		elseif li_sts > 0 then
			li_found = 1
		end if
	else
		li_sts = set_exam_defaults(ll_child_observation_sequence, pstr_tree.branch[i].default_result_count, pstr_tree.branch[i].default_result)
		if li_sts < 0 then
			log.log(this, "set_exam_defaults()", "Error setting default results", 4)
			if lb_wait then close(w_pop_please_wait)
			return -1
		elseif li_sts > 0 then
			li_found = 1
		end if
	end if
	
	if lb_wait then w_pop_please_wait.set_progress(i)
next

if lb_wait then close(w_pop_please_wait)

return li_found

end function

private function long find_root_observation (string ps_observation_id, string ps_observation_tag);long ll_parent_observation_sequence
integer li_child_ordinal
long ll_stage

setnull(ll_parent_observation_sequence)
setnull(li_child_ordinal)
setnull(ll_stage)

return find_observation(ll_parent_observation_sequence, ps_observation_id, li_child_ordinal, ps_observation_tag, ll_stage)

end function

public function string get_observation_service (long pl_observation_sequence);long ll_row
string ls_find
long ll_o_count
string ls_service

ll_o_count = p_observation.rowcount()

setnull(ls_service)

if isnull(pl_observation_sequence) then return ls_service

ls_find = "observation_sequence=" + string(pl_observation_sequence)
ll_row = p_observation.find(ls_find, 1, ll_o_count)
if ll_row <= 0 then
	log.log(this, "remove_results()", "Observation_sequence not found (" + string(pl_observation_sequence) + ")", 4)
	return ls_service
end if

ls_service = p_observation.object.service[ll_row]

return ls_service

end function

public function long add_observation (long pl_parent_observation_sequence, string ps_observation_id, integer pi_child_ordinal, string ps_observation_tag, long pl_stage, ref string ps_service, boolean pb_find_existing);string ls_stage_description

setnull(ls_stage_description)

return add_observation(pl_parent_observation_sequence, &
								ps_observation_id, &
								pi_child_ordinal, &
								ps_observation_tag, &
								pl_stage, &
								ls_stage_description, &
								ps_service, &
								pb_find_existing)


end function

public function long add_root_observation (string ps_observation_id, string ps_observation_tag, ref string ps_service);return add_root_observation(ps_observation_id, ps_observation_tag, ps_service, true)

end function

public function long add_root_observation (string ps_observation_id, string ps_observation_tag, ref string ps_service, boolean pb_find_existing);long ll_parent_observation_sequence
integer li_child_ordinal
integer ll_stage

setnull(ll_parent_observation_sequence)
setnull(li_child_ordinal)
setnull(ll_stage)


return add_observation(ll_parent_observation_sequence, ps_observation_id, li_child_ordinal, ps_observation_tag, ll_stage, ps_service, pb_find_existing)

end function

public subroutine map_attr_to_data_columns (str_attributes pstr_attributes);///////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description: Map the attributes to data columns
//
//
// Created By:Sumathi Chinnasamy										Creation dt: 03/24/2000
//
//
// Note: Comparing the attribute values b'z if any non-treatment properties(like spl ins)
//       are modified we still need to update them.
///////////////////////////////////////////////////////////////////////////////////////////////////////

Integer  i
Datetime ldt_progress_date
Long		ll_row
string ls_date, ls_time
string ls_new_value
string ls_progress_key

Setnull(ldt_progress_date)

// map attributes to data columns
For i = 1 To pstr_attributes.attribute_count
	// Perform the appropriate run-time substitution
	ls_new_value = f_attribute_value_substitute("Treatment", treatment_id, pstr_attributes.attribute[i].value)
	
	if left(lower(pstr_attributes.attribute[i].attribute), 21) = "order_observation_id_" then
		ls_progress_key = mid(pstr_attributes.attribute[i].attribute, 22)
		if len(ls_progress_key) > 0 then
			set_progress_key("order_observation_id", ls_progress_key, ls_new_value)
		end if
	else
		Choose Case lower(pstr_attributes.attribute[i].attribute)
			CASE 'appointment_date_time'
				If f_is_modified(appointment_date_time,ls_new_value) Then
					f_split_string(ls_new_value, " ", ls_date, ls_time)
					appointment_date_time = datetime(date(ls_date), time(ls_time))
					updated = true
				End If
			Case 'past_treatment'
				past_treatment = f_string_to_boolean(ls_new_value)
			Case 'begin_date'
				If f_is_modified(begin_date,ls_new_value) Then
					f_split_string(ls_new_value, " ", ls_date, ls_time)
					begin_date = datetime(date(ls_date), time(ls_time))
					updated = true
				End If
			Case 'end_date'
				If f_is_modified(end_date,ls_new_value) Then
					f_split_string(ls_new_value, " ", ls_date, ls_time)
					end_date = datetime(date(ls_date), time(ls_time))
					updated = true
				End If
			Case 'treatment_description'
				If f_is_modified(treatment_description,ls_new_value) Then
					treatment_description = ls_new_value
					updated = true
				End If
			Case 'treatment_goal'
				If f_is_modified(treatment_goal,ls_new_value) Then
					treatment_goal = ls_new_value
					updated = true
				End If
			Case 'package_id'
				If f_is_modified(package_id,ls_new_value) Then
					package_id = ls_new_value
					updated = true
				End If
			Case 'dose_amount'
				If f_is_modified(dose_amount,ls_new_value) Then
					dose_amount = Real(ls_new_value)
					updated = true
				End If
			Case 'dose_unit'
				If f_is_modified(dose_unit,ls_new_value) Then
					dose_unit = ls_new_value
					updated = true
				End If
			Case 'dispense_amount'
				If f_is_modified(dispense_amount,ls_new_value) Then
					dispense_amount = Real(ls_new_value)
					updated = true
				End If
			Case 'office_dispense_amount'
				If f_is_modified(office_dispense_amount,ls_new_value) Then
					office_dispense_amount = real(ls_new_value)
					updated = true
				End If
			Case 'dispense_unit'
				If f_is_modified(dispense_unit,ls_new_value) Then
					dispense_unit = ls_new_value
					updated = true
				End If
			Case 'duration_amount'
				If f_is_modified(duration_amount,ls_new_value) Then
					duration_amount = Real(ls_new_value)
					updated = true
				End If
			Case 'duration_prn'
				If f_is_modified(duration_prn,ls_new_value) Then
					duration_prn = ls_new_value
					updated = true
				End If
			Case 'duration_unit'
				If f_is_modified(duration_unit,ls_new_value) Then
					duration_unit = ls_new_value
					updated = true
				End If
			Case 'administer_frequency'
				If f_is_modified(administer_frequency,ls_new_value) Then
					administer_frequency = ls_new_value
					updated = true
				End If
			Case 'brand_name_required'
				If f_is_modified(brand_name_required,ls_new_value) Then
					brand_name_required = ls_new_value
					updated = true
				End If
			Case 'procedure_id'
				If f_is_modified(procedure_id,ls_new_value) Then
					procedure_id = ls_new_value
					updated = true
				End If
			Case 'attach_flag'
				If f_is_modified(attach_flag,ls_new_value) Then
					attach_flag = ls_new_value
					updated = true
				End If
			Case 'referral_question'
				If f_is_modified(referral_question,ls_new_value) Then
					referral_question = ls_new_value
					updated = true
				End If
			Case 'referral_question_assmnt_id'
				If f_is_modified(referral_question_assmnt_id,ls_new_value) Then
					referral_question_assmnt_id = ls_new_value
					updated = true
				End If
			Case 'refills'
				If f_is_modified(refills,ls_new_value) Then
					refills = integer(ls_new_value)
					updated = true
				End If
			Case 'maker_id'
				If f_is_modified(maker_id,ls_new_value) Then
					maker_id = ls_new_value
					updated = true
				End If
			Case 'lot_number'
				If f_is_modified(lot_number,ls_new_value) Then
					lot_number = ls_new_value
					updated = true
				End If
			Case 'treatment_office_id'
				If f_is_modified(treatment_office_id,ls_new_value) Then
					treatment_office_id = ls_new_value
					updated = true
				End If
			Case 'location'
				If f_is_modified(location,ls_new_value) Then
					location = ls_new_value
					updated = true
				End If
			Case 'administration_sequence'
				If f_is_modified(administration_sequence,ls_new_value) Then
					administration_sequence = Integer(ls_new_value)
					updated = true
				End If
			Case 'drug_id'
				If f_is_modified(drug_id,ls_new_value) Then
					drug_id = ls_new_value
					updated = true
				End If
			Case 'dosage_form'
				If f_is_modified(dosage_form,ls_new_value) Then
					dosage_form = ls_new_value
					updated = true
					// Dosage_form is not on the p_treatment_item record so we need to report it
					// as a property in order to persist it to the database
					set_progress_key("Property", pstr_attributes.attribute[i].attribute, ls_new_value)
				End If
			Case 'observation_id'
				If f_is_modified(observation_id,ls_new_value) Then
					observation_id = ls_new_value
					updated = true
				End If
			Case 'send_out_flag'
				If f_is_modified(send_out_flag,ls_new_value) Then
					send_out_flag = ls_new_value
					updated = true
				End If
			Case 'material_id'
				If f_is_modified(material_id,ls_new_value) Then
					material_id = Long(ls_new_value)
					updated = true
				End If
			Case 'ordered_by'
				If f_is_modified(ordered_by,ls_new_value) Then
					ordered_by = ls_new_value
					updated = true
				End If
			Case 'treatment_mode'
				If f_is_modified(treatment_mode,ls_new_value) Then
					treatment_mode = ls_new_value
					updated = true
				End If
			Case 'specialty_id'
				If f_is_modified(specialty_id,ls_new_value) Then
					specialty_id = ls_new_value
					updated = true
				End If
			Case 'specimen_id'
				If f_is_modified(specimen_id,ls_new_value) Then
					specimen_id = ls_new_value
					updated = true
				End If
			Case 'ordered_by'
				If f_is_modified(ordered_by,ls_new_value) Then
					ordered_by = ls_new_value
					updated = true
				End If
			Case 'ordered_for'
				If f_is_modified(ordered_for,ls_new_value) Then
					ordered_for = ls_new_value
					updated = true
				End If
			Case 'ordered_by_supervisor'
				If f_is_modified(ordered_by_supervisor,ls_new_value) Then
					ordered_by_supervisor = ls_new_value
					updated = true
				End If
			Case 'followup_workplan_id'
				If f_is_modified(followup_workplan_id,ls_new_value) Then
					followup_workplan_id = long(ls_new_value)
					updated = true
				End If
			Case 'expiration_date'
				If f_is_modified(expiration_date,ls_new_value) Then
					expiration_date = datetime(ls_new_value)
					updated = true
				End If
			Case 'patient_instructions', 'pharmacist_instructions'
				set_progress_key("Instructions", pstr_attributes.attribute[i].attribute, ls_new_value)
			Case Else
				// If the attribute isn't recognized then report it as a property
				set_progress_key("Property", pstr_attributes.attribute[i].attribute, ls_new_value)
		End Choose
	end if
Next

return

end subroutine

public function integer set_exam_defaults_old (long pl_exam_sequence, long pl_branch_id, long pl_observation_sequence, integer pi_result_sequence, string ps_location);str_default_results lstr_default_results
str_observation_tree lstr_observation_tree
str_observation_tree_branch lstr_branch
string ls_root_observation_id
string ls_exam_root_observation_id
integer li_sts
string ls_composite_flag
string ls_child_observation_id
string ls_null
boolean lb_wait

setnull(ls_null)

if isnull(pl_observation_sequence) then
	log.log(this, "set_exam_defaults()", "Null root_observation_sequence", 4)
	return -1
end if

ls_root_observation_id = get_observation_id(pl_observation_sequence) 
if isnull(ls_root_observation_id) then
	log.log(this, "set_exam_defaults()", "No exam root (" + string(pl_observation_sequence) + ")", 4)
	return -1
end if

if isnull(pl_exam_sequence) or pl_exam_sequence <= 0 then
	pl_exam_sequence = datalist.observation_default_exam_sequence(ls_root_observation_id)
end if
	
if isnull(pl_exam_sequence) or pl_exam_sequence <= 0 then
	log.log(this, "set_exam_defaults()", "Invalid exam_sequence", 4)
	return -1
end if

// See if exam_sequence exists
ls_exam_root_observation_id = datalist.exam_root_observation_id(pl_exam_sequence)
if isnull(ls_exam_root_observation_id) then
	log.log(this, "set_exam_defaults()", "exam_sequence not found (" + string(pl_exam_sequence) + ")", 4)
	return -1
end if

// Set the child observation_id
if pl_branch_id > 0 then
	lstr_branch = datalist.observation_tree_branch(pl_branch_id)
	
	if isnull(lstr_branch.child_observation_id) then
		log.log(this, "set_exam_defaults()", "branch not found (" + string(pl_branch_id) + ")", 4)
		return -1
	end if

	ls_child_observation_id = lstr_branch.child_observation_id
else
	ls_child_observation_id = ls_root_observation_id
end if

ls_composite_flag = datalist.observation_composite_flag(ls_child_observation_id)
if ls_composite_flag = "Y" then
	// Get the first set of branches
	if isvalid(w_pop_please_wait) then
		lb_wait = false
	else
		lb_wait = true
		open(w_pop_please_wait)
	end if
	lstr_observation_tree = datalist.exam_default_results(pl_exam_sequence, pl_branch_id)
	if lb_wait then close(w_pop_please_wait)
	
	// Set the default results
	li_sts = set_exam_defaults(pl_observation_sequence, lstr_observation_tree)
else
	// Get the default results
	if not isnull(pi_result_sequence) then
		lstr_default_results = datalist.exam_default_results_simple(pl_exam_sequence, pl_branch_id, pi_result_sequence)
	elseif not isnull(ps_location) then
		lstr_default_results = datalist.exam_default_results_simple(pl_exam_sequence, pl_branch_id, ps_location)
	else
		lstr_default_results = datalist.exam_default_results_simple(pl_exam_sequence, pl_branch_id)
	end if
		
	if lstr_default_results.default_result_count = 0 then
		lstr_default_results = datalist.observation_default_results_simple(ls_child_observation_id, pi_result_sequence, ps_location)
	end if

	// Set the default results
	li_sts = set_exam_defaults(pl_observation_sequence, lstr_default_results.default_result_count, lstr_default_results.default_result)
end if

return li_sts


end function

private function str_p_observation get_observation_structure (long pl_row);str_p_observation lstr_observation

lstr_observation.cpr_id = p_Observation.object.cpr_id[pl_row]
lstr_observation.treatment_id = p_Observation.object.treatment_id[pl_row]
lstr_observation.observation_sequence = p_Observation.object.observation_sequence[pl_row]
lstr_observation.observation_id = p_Observation.object.observation_id[pl_row]
lstr_observation.encounter_id = p_Observation.object.encounter_id[pl_row]
lstr_observation.attachment_id = p_Observation.object.attachment_id[pl_row]
lstr_observation.result_expected_date = p_Observation.object.result_expected_date[pl_row]
lstr_observation.observation_tag = p_Observation.object.observation_tag[pl_row]
lstr_observation.abnormal_flag = p_Observation.object.abnormal_flag[pl_row]
lstr_observation.severity = p_Observation.object.severity[pl_row]
lstr_observation.composite_flag = p_Observation.object.composite_flag[pl_row]
lstr_observation.parent_observation_sequence = p_Observation.object.parent_observation_sequence[pl_row]
lstr_observation.stage = p_Observation.object.stage[pl_row]
lstr_observation.observed_by = p_Observation.object.observed_by[pl_row]
lstr_observation.created = p_Observation.object.created[pl_row]
lstr_observation.created_by = p_Observation.object.created_by[pl_row]

// Then add the latest results
lstr_observation.result_count = get_observation_results( &
																lstr_observation.observation_sequence, &
																lstr_observation.results )
	

return lstr_observation


end function

public function long set_result (long pl_observation_sequence, integer pi_result_sequence, string ps_location);long ll_row
integer li_sts
string ls_observation_id
string ls_find
long i
long ll_p_rows
string ls_result_value
string ls_new_result_value
string ls_result_unit
string ls_abnormal_flag
string ls_abnormal_nature
string ls_result_amount_flag
str_popup popup
str_popup_return popup_return
u_unit luo_result_unit
u_unit luo_display_unit
datetime ldt_result_date_time
str_c_observation_result lstr_result
string top_20_code_1
string top_20_code_2
string ls_temp
string ls_display_unit_id
str_amount_unit lstr_amount_unit
string ls_property_context_object
string ls_property
str_property lstr_property
string ls_edit_service
str_attributes lstr_attributes
str_observation_comment lstr_comment

ll_p_rows = p_observation_result.rowcount()

// We must have have an observation sequence
if isnull(pl_observation_sequence) then
	log.log(this, "set_result()", "Null observation sequence", 4)
	return -1
end if

if isnull(pi_result_sequence) then
	log.log(this, "set_result()", "Null result sequence", 4)
	return -1
end if

if isnull(ps_location) then
	log.log(this, "set_result()", "Null location", 4)
	return -1
end if

ls_observation_id = get_observation_id(pl_observation_sequence)
if isnull(ls_observation_id) then
	log.log(this, "set_result()", "Observation Not Found (" + string(pl_observation_sequence) + ")", 4)
	return -1
end if

lstr_result = datalist.observation_result(ls_observation_id, pi_result_sequence)
if isnull(lstr_result.result_sequence) then
	log.log(this, "set_result()", "Observation Result Not Found (" + ls_observation_id + ", " + string(pi_result_sequence) + ")", 4)
	return -1
end if

// Set up the attributes in case we need to call a service
lstr_attributes.attribute_count = 0
f_attribute_add_attribute(lstr_attributes, "treatment_type", treatment_type)
f_attribute_add_attribute(lstr_attributes, "treatment_id", string(treatment_id))
f_attribute_add_attribute(lstr_attributes, "observation_id", ls_observation_id)
f_attribute_add_attribute(lstr_attributes, "observation_sequence", string(pl_observation_sequence))
f_attribute_add_attribute(lstr_attributes, "result_sequence", string(pi_result_sequence))
f_attribute_add_attribute(lstr_attributes, "location", ps_location)


CHOOSE CASE upper(lstr_result.result_type)
	CASE "PERFORM", "COLLECT"
		if lstr_result.result_amount_flag = "Y" and not isnull(lstr_result.result_unit) then
			// We need a value with this result, so get the latest one
			li_sts = get_result(pl_observation_sequence, &
										pi_result_sequence, &
										ps_location, &
										ldt_result_date_time, &
										ls_result_value, &
										ls_result_unit, &
										ls_abnormal_flag, &
										ls_abnormal_nature )
			
			if li_sts <= 0 or isnull(ldt_result_date_time) then
				ls_result_value = ""
				ls_result_unit = lstr_result.result_unit
				ls_abnormal_flag = lstr_result.abnormal_flag
				setnull(ls_abnormal_nature)
			end if
		
			luo_result_unit = unit_list.find_unit(ls_result_unit)
			if isnull(luo_result_unit) then
				log.log(this, "set_result()", "Error finding unit (" + ls_result_unit + ")", 4)
				return -1
			end if
			
			// Now convert the result unit to the appropriate display unit
			// First get the display amount
			ls_result_value = luo_result_unit.pretty_amount(ls_result_value, lstr_result.unit_preference, lstr_result.display_mask)
			// Then get the display unit
			ls_temp = luo_result_unit.pretty_unit(lstr_result.unit_preference, ls_display_unit_id)
			luo_display_unit = unit_list.find_unit(ls_display_unit_id)
			if isnull(luo_display_unit) then
				log.log(this, "set_result()", "Error finding display unit (" + ls_display_unit_id + ")", 4)
				return -1
			end if
		
			// Now prompt the user for a new value
			top_20_code_2 = "ResultPick|" + ls_observation_id + "|" + string(pi_result_sequence)
			top_20_code_1 = current_patient.cpr_id + "|" + top_20_code_2
		
			lstr_amount_unit = luo_display_unit.get_value_and_unit(ls_result_value, top_20_code_1, top_20_code_2, false, lstr_result.result)
		
			ls_result_value = lstr_amount_unit.amount
			ls_result_unit = lstr_amount_unit.unit
		else
			setnull(ls_result_value)
			setnull(ls_result_unit)
			ls_abnormal_flag = lstr_result.abnormal_flag
			setnull(ls_abnormal_nature)
		end if
		
		
		// If there isn't a current encounter then use the treatment date
		if isnull(current_patient.open_encounter) then
			ldt_result_date_time = begin_date
		else
			// If the treatment and the current encounter are both still open then the patient is in the office so
			// use the current date/time
			if current_patient.open_encounter.encounter_status = "OPEN" &
				and isnull(treatment_status) &
				and date(begin_date) = date(current_patient.open_encounter.encounter_date) then
					ldt_result_date_time = datetime(today(), now())
			else
				// If the current encounter is closed then it happened in the past
				// so use the treatment date as the result_date_time
				ldt_result_date_time = begin_date
			end if
		end if
		
		// Add the result record
		li_sts = add_result(pl_observation_sequence, &
									pi_result_sequence, &
									ps_location, &
									ldt_result_date_time, &
									ls_result_value, &
									ls_result_unit, &
									ls_abnormal_flag, &
									ls_abnormal_nature )
		if li_sts <= 0 then
			log.log(this, "set_result()", "Error adding result", 4)
			return -1
		end if
	CASE "COMMENT"
		li_sts = get_comment(pl_observation_sequence, lstr_result.result, lstr_comment)
		if li_sts > 0 then
			f_attribute_add_attribute(lstr_attributes, "observation_comment_id", string(lstr_comment.observation_comment_id))
		end if
		
		if not isnull(lstr_result.external_source) then
			if pos(lstr_result.external_source, "_") > 0 then
				f_attribute_add_attribute(lstr_attributes, "external_source", lstr_result.external_source)
			else
				f_attribute_add_attribute(lstr_attributes, "external_source_type", lstr_result.external_source)
			end if
		end if

		f_attribute_add_attribute(lstr_attributes, "comment_title", lstr_result.result)

		if len(lstr_result.service) > 0 then
			ls_edit_service = lstr_result.service
		else
			ls_edit_service = comment_service
		end if
		
		// Call service with attributes
		li_sts = service_list.do_service( &
													current_patient.cpr_id, &
													current_patient.open_encounter_id, &
													ls_edit_service, &
													this, &
													lstr_attributes )
	CASE "ATTACHMENT"
		li_sts = get_comment(pl_observation_sequence, lstr_result.result, lstr_comment)
		if li_sts > 0 then
			f_attribute_add_attribute(lstr_attributes, "observation_comment_id", string(lstr_comment.observation_comment_id))
		end if
		
		if not isnull(lstr_result.external_source) then
			if pos(lstr_result.external_source, "_") > 0 then
				f_attribute_add_attribute(lstr_attributes, "external_source", lstr_result.external_source)
			else
				f_attribute_add_attribute(lstr_attributes, "external_source_type", lstr_result.external_source)
			end if
		end if

		f_attribute_add_attribute(lstr_attributes, "comment_title", lstr_result.result)
	
		// Call service with attributes
		li_sts = service_list.do_service( &
													current_patient.cpr_id, &
													current_patient.open_encounter_id, &
													attachment_service, &
													this, &
													lstr_attributes )

	CASE "PROPERTY"
		lstr_property = datalist.find_property(lstr_result.property_id)
		if not isnull(lstr_result.service) and not isnull(lstr_property.property_id) then
			// If we have an edit_service, then call the service
			f_attribute_add_attribute(lstr_attributes, "progress_key", lstr_property.function_name)
			
			// Call service with attributes
			li_sts = service_list.do_service( &
														current_patient.cpr_id, &
														current_patient.open_encounter_id, &
														lstr_result.service, &
														this, &
														lstr_attributes )
		end if
END CHOOSE

return 1



end function

public function long add_result (long pl_observation_sequence, integer pi_result_sequence, string ps_location);string ls_null
datetime ldt_result_date_time

setnull(ls_null)
setnull(ldt_result_date_time)

return add_result(pl_observation_sequence, pi_result_sequence, ps_location, ldt_result_date_time, ls_null, ls_null, ls_null, ls_null)

end function

public function long add_result (long pl_observation_sequence, integer pi_result_sequence, string ps_location, datetime pdt_result_date_time, string ps_result_value, string ps_result_unit, string ps_abnormal_flag, string ps_abnormal_nature);string ls_normal_range

setnull(ls_normal_range)

return add_result(pl_observation_sequence, &
						pi_result_sequence, &
						ps_location, &
						pdt_result_date_time, &
						ps_result_value, &
						ps_result_unit, &
						ps_abnormal_flag, &
						ps_abnormal_nature, &
						ls_normal_range)

end function

public subroutine reset ();setnull(administer_frequency)
setnull(attach_flag)
setnull(brand_name_required)
setnull(id)
setnull(lot_number)
setnull(patient_instructions)
setnull(pharmacist_instructions)
setnull(maker_id)
setnull(treatment_office_id)

setnull(observation_id)
Setnull(treatment_mode)
Setnull(package_id)
Setnull(specialty_id)
Setnull(drug_id)
Setnull(dose_unit)
Setnull(duration_unit)
Setnull(duration_prn)
Setnull(dispense_unit)
Setnull(treatment_goal)
Setnull(send_out_flag)
Setnull(referral_question)
Setnull(referral_question_assmnt_id)
Setnull(dosage_form)
Setnull(administration_sequence)
setnull(refills)
setnull(material_id)
setnull(location)

Setnull(dose_amount)
Setnull(duration_amount)
Setnull(dispense_amount)
Setnull(office_dispense_amount)

problem_count = 0

Setnull(treatment_id)
Setnull(treatment_type)
Setnull(open_encounter_id)
Setnull(begin_date)
Setnull(end_date)
Setnull(expiration_date)
Setnull(treatment_description)
Setnull(treatment_goal)
Setnull(attachment_list)
Setnull(original_treatment_id)
Setnull(parent_treatment_id)
//Setnull(signature)
Setnull(procedure_id)
Setnull(ordered_by_supervisor)
Setnull(appointment_date_time)

Setnull(ordered_workplan_id)
Setnull(followup_workplan_id)

setnull(assessment.problem_id)

past_treatment = False
setnull(treatment_status)

exists = False
deleted = False
updated = False
treatment_count = 0

new_progress.progress_count = 0


end subroutine

public function integer delete_item_old ();integer i
u_str_encounter luo_encounter

deleted = true

//Return save()
return 1
end function

public function integer update (str_attributes pstr_attributes);///////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description: If the existing prescription is modified, then set the status as 'modified' for
//              previous encounter and order a new prescription for the current encounter.
//
// Returns: integer
//
// Created By:Sumathi Chinnasamy										Creation dt: 03/17/2000
//
// Modified By:															Modified On:
///////////////////////////////////////////////////////////////////////////////////////////////////////
integer li_sts

// First map the attributes to data columns
updated = false
map_attr_to_data_columns(pstr_attributes)

// If the updated flad is true then something changed and we have to update the treatment
if updated then
	li_sts = current_patient.treatments.update_treatment(this)
else
	li_sts = 1
end if

return li_sts

end function

private function integer set_exam_defaults_add_observations (long pl_exam_sequence, long pl_branch_id, long pl_observation_sequence, integer pi_result_sequence, string ps_location, u_ds_data puo_data);string ls_composite_flag
integer li_sts
integer li_found
long i, j
long ll_parent_observation_sequence
string ls_null
boolean lb_wait
long ll_stage
long ll_rowcount
long lla_observation_sequence[]
long ll_branch_id
string ls_parent_observation_id
string ls_child_observation_id
string ls_user_id
integer li_result_sequence
string ls_location
string ls_result_value
string ls_result_unit
integer li_child_ordinal
string ls_find
long ll_row
string ls_observation_tag
long ll_parent_branch_id

setnull(ll_stage)
setnull(ls_null)

li_found = 0

ll_rowcount = puo_data.rowcount()
if ll_rowcount <= 0 then return ll_rowcount

// Display the please-wait window
if isvalid(w_pop_please_wait) then
	lb_wait = false
else
	lb_wait = true
	open(w_pop_please_wait)
	w_pop_please_wait.initialize(1, ll_rowcount)
end if

// Then, loop through the default results and construct the observation tree
for i = 1 to ll_rowcount
	ll_branch_id = puo_data.object.branch_id[i]
	ls_parent_observation_id = puo_data.object.parent_observation_id[i]
	ls_child_observation_id = puo_data.object.child_observation_id[i]
	ls_user_id = puo_data.object.user_id[i]
	li_result_sequence = puo_data.object.result_sequence[i]
	ls_location = puo_data.object.location[i]
	ls_result_value = puo_data.object.result_value[i]
	ls_result_unit = puo_data.object.result_unit[i]
	ll_parent_branch_id = puo_data.object.parent_branch_id[i]
	ls_observation_tag = puo_data.object.observation_tag[i]
	
	setnull(lla_observation_sequence[i])
	
	// If the branch_id is the same as the passed in branch, then  then
	// passed in observation is already the right observation
	if ll_branch_id = pl_branch_id or ll_branch_id = 0 then
		lla_observation_sequence[i] = pl_observation_sequence
	elseif not isnull(ls_child_observation_id) then
		// Get the parent observation_sequence
		if isnull(ll_parent_branch_id) then
			ll_parent_observation_sequence = pl_observation_sequence
			
			// Set the find string for later
			ls_find = "isnull(parent_branch_id)"
		else
			// Find the parent row
			ls_find = "branch_id=" + string(ll_parent_branch_id)
			ll_row = puo_data.find(ls_find, 1, i - 1)
			if ll_row <= 0 then continue
			ll_parent_observation_sequence = lla_observation_sequence[ll_row]
			
			// Reset the find string for later
			ls_find = "parent_branch_id=" + string(ll_parent_branch_id)
			ls_find += " and branch_id<>" + string(ll_branch_id)
		end if
		
		// calculate the child_ordinal
		li_child_ordinal = 1
		ls_find += " and child_observation_id='" + ls_child_observation_id + "'"
		ll_row = puo_data.find(ls_find, 1, i - 1)
		DO WHILE ll_row > 0 and ll_row < i
			li_child_ordinal += 1
			ll_row = puo_data.find(ls_find, ll_row + 1, i)
		LOOP
		
		lla_observation_sequence[i] = add_observation(ll_parent_observation_sequence, &
																		ls_child_observation_id, &
																		li_child_ordinal, &
																		ls_observation_tag, &
																		ll_stage, &
																		true)
		if lla_observation_sequence[i] <= 0 then
			log.log(this, "set_exam_defaults()", "Error adding new observation", 4)
			if lb_wait then close(w_pop_please_wait)
			return -1
		end if
	end if

	// If we have a result/location, and it matches the specified result/location (or the specified
	// result/location is null) then add the result
	if not isnull(li_result_sequence) and not isnull(ls_location) and not isnull(lla_observation_sequence[i]) then
		if (isnull(pi_result_sequence) or (pi_result_sequence = li_result_sequence)) &
			and (isnull(ps_location) or (ls_location = ps_location)) then
				li_sts = add_result(lla_observation_sequence[i], &
											li_result_sequence, &
											ls_location, &
											datetime(today(), now()), &
											ls_result_value, &
											ls_result_unit, &
											ls_null, &
											ls_null )
				if li_sts < 0 then
					log.log(this, "set_exam_defaults()", "Error adding default results", 4)
					if lb_wait then close(w_pop_please_wait)
					return -1
				end if
				li_found += 1
		end if
	end if

	
	if lb_wait then w_pop_please_wait.set_progress(i)
next

if lb_wait then close(w_pop_please_wait)

return li_found


end function

public function string observation_id (long pl_observation_sequence);string ls_find
long ll_row
string ls_observation_id

ls_find = "observation_sequence=" + string(pl_observation_sequence)
ll_row = p_Observation.find(ls_find, 1, p_Observation.rowcount())
if ll_row > 0 then
	ls_observation_id = p_Observation.object.observation_id[ll_row]
else
	setnull(ls_observation_id)
end if

return ls_observation_id

end function

public function integer set_exam_defaults (long pl_exam_sequence, long pl_branch_id, long pl_observation_sequence, integer pi_result_sequence, string ps_location);u_ds_data luo_data
long ll_rowcount
string ls_observation_id


ll_rowcount = sqlca.sp_apply_standard_exam( current_patient.cpr_id, &
															treatment_id, &
															current_patient.open_encounter_id, &
															pl_observation_sequence, &
															pl_branch_id, &
															pl_exam_sequence, &
															current_user.user_id, &
															current_scribe.user_id)
if not tf_check() then return -1

load_observations()

if ll_rowcount <= 0 then
	// If there weren't any default results for the specified exam, then try to figure
	// out a set of reasonable default results
	luo_data = CREATE u_ds_data
	luo_data.set_dataobject("dw_sp_default_default_results")
	ls_observation_id = observation_id(pl_observation_sequence)
	ll_rowcount = luo_data.retrieve(pl_branch_id, ls_observation_id, pi_result_sequence, ps_location)
	if ll_rowcount < 0 then return -1
	
	ll_rowcount = set_exam_defaults_add_observations(pl_exam_sequence, &
																pl_branch_id, &
																pl_observation_sequence, &
																pi_result_sequence, &
																ps_location, &
																luo_data)
	if ll_rowcount < 0 then return -1
	DESTROY luo_data
end if

return ll_rowcount

end function

public function integer get_stage_observations (long pl_parent_observation_sequence, ref str_p_observation_stages pstr_observation_stages);integer li_count
string ls_find
long ll_row
long ll_rowcount
long ll_observation_sequence
long ll_stage
integer li_observation_count
str_p_observation_stage lstr_stage
integer i

ll_rowcount = p_observation.rowcount()


// First, find a p_Observation record which has a stage number and is
// under the specified parent
if isnull(pl_parent_observation_sequence) then
	ls_find = "isnull(parent_observation_sequence)"
else
	ls_find = "parent_observation_sequence=" + string(pl_parent_observation_sequence)
end if
ls_find += " and composite_flag='Y'"
ls_find += " and not isnull(stage)"
ll_row = p_observation.find(ls_find, 1, ll_rowcount)
DO WHILE ll_row > 0 and ll_row <= ll_rowcount
	ll_observation_sequence = p_observation.object.observation_sequence[ll_row]
	ll_stage = p_observation.object.stage[ll_row]
	
	// Fill the stage structure
	lstr_stage.parent_observation = get_observation(ll_observation_sequence)
	lstr_stage.stage = ll_stage
	lstr_stage.child_observation_count = get_child_observations(ll_observation_sequence, lstr_stage.child_observation)

	// Add the stage to the stages structure
	pstr_observation_stages.stage_count += 1
	pstr_observation_stages.observation_stage[pstr_observation_stages.stage_count] = lstr_stage
	
	// Get the next observation
	ll_row = p_observation.find(ls_find, ll_row + 1, ll_rowcount + 1)
LOOP

return li_count

end function

public function boolean any_results ();long ll_any_results
string ls_result_type

// Null result type means any result type
setnull(ls_result_type)

ll_any_results = sqlca.sp_treatment_any_results( current_patient.cpr_id, treatment_id, ls_result_type)
if not tf_check() then return false

if ll_any_results > 0 then return true

return false

end function

public function long add_observation_stage (long pl_parent_observation_sequence, string ps_observation_id, integer pi_child_ordinal, string ps_observation_tag, long pl_stage, string ps_stage_description, boolean pb_find_existing);string ls_service

setnull(ls_service)

if isnull(pl_parent_observation_sequence) then
	log.log(this, "add_observation()", "This method is not allowed to add a root observation", 4)
	return -1
end if

return add_observation(pl_parent_observation_sequence, &
								ps_observation_id, &
								pi_child_ordinal, &
								ps_observation_tag, &
								pl_stage, &
								ps_stage_description, &
								ls_service, &
								true)


end function

public function long add_observation (long pl_parent_observation_sequence, string ps_observation_id, integer pi_child_ordinal, string ps_observation_tag, long pl_stage, string ps_stage_description, ref string ps_service, boolean pb_find_existing);long ll_row
integer li_sts
long ll_observation_sequence
string ls_find
long i
long ll_p_rows
boolean lb_followon
integer li_found_count
integer li_branch_sort_sequence
string ls_parent_observation_id
str_observation_tree_branch lstr_branch
string ls_description
string ls_check_cpr_id
long ll_check_treatment_id
long ll_incorrect_observation_sequence
long ll_original_branch_id

// The pc_service param is passed in by reference.  The caller should set it to the service (or null) that
// should be used if the observation has not been created yet.  If the observation has already been
// created, then the original value of ps_service will be retrieved and will replace the value
// passed in by the caller.

if pb_find_existing then
	ll_observation_sequence = find_observation(pl_parent_observation_sequence, ps_observation_id, pi_child_ordinal, ps_observation_tag, pl_stage)
	if ll_observation_sequence < 0 then
		log.log(this, "add_observation()", "Error finding observation (" + ps_observation_id + ")", 4)
		return -1
	end if

	// If we found the observation then return it
	if not isnull(ll_observation_sequence) then
		ps_service = get_observation_service(ll_observation_sequence)
		return ll_observation_sequence
	end if
end if

ls_description = datalist.observation_description(ps_observation_id)

if isnull(pl_parent_observation_sequence) then
	setnull(ls_parent_observation_id)
	setnull(li_branch_sort_sequence)
	setnull(ll_original_branch_id)
else
	ls_parent_observation_id = get_observation_id(pl_parent_observation_sequence)
	lstr_branch = datalist.observation_branch(ls_parent_observation_id, ps_observation_id, pi_child_ordinal)
	if isnull(lstr_branch.branch_id) then
		setnull(li_branch_sort_sequence)
		setnull(ll_original_branch_id)
	else
		ll_original_branch_id = lstr_branch.branch_id
		li_branch_sort_sequence = lstr_branch.sort_sequence
		if not isnull(lstr_branch.description) and trim(lstr_branch.description) <> "" then
			ls_description = lstr_branch.description
		end if
	end if
end if

// If we get here, then we must be adding a new record.
ll_row = p_observation.insertrow(0)
p_observation.object.cpr_id[ll_row] = parent_patient.cpr_id
p_observation.object.treatment_id[ll_row] = treatment_id
p_observation.object.observation_id[ll_row] = ps_observation_id
p_observation.object.description[ll_row] = ls_description
p_observation.object.encounter_id[ll_row] = parent_patient.open_encounter_id
p_observation.object.composite_flag[ll_row] = datalist.observation_composite_flag(ps_observation_id)
p_observation.object.parent_observation_sequence[ll_row] = pl_parent_observation_sequence
p_observation.object.observation_tag[ll_row] = ps_observation_tag
p_observation.object.stage[ll_row] = pl_stage
p_observation.object.stage_description[ll_row] = ps_stage_description
p_observation.object.service[ll_row] = ps_service
p_observation.object.observed_by[ll_row] = current_user.user_id
p_observation.object.branch_sort_sequence[ll_row] = li_branch_sort_sequence
p_observation.object.original_branch_id[ll_row] = ll_original_branch_id
p_observation.object.created[ll_row] = datetime(today(), now())
p_observation.object.created_by[ll_row] = current_scribe.user_id

li_sts = p_observation.update()
if li_sts <= 0 then
	log.log(this, "add_observation()", "Error adding p_observation record", 4)
	return -1
end if

ll_observation_sequence = p_observation.object.observation_sequence[ll_row]

if isnull(ll_observation_sequence) then
	log.log(this, "add_observation()", "Error adding p_observation record, null observation_sequence", 4)
	return -1
end if

SELECT treatment_id
INTO :ll_check_treatment_id
FROM p_Observation
WHERE cpr_id = :current_patient.cpr_id
AND observation_sequence = :ll_observation_sequence;
if not tf_check() then return -1
if (sqlca.sqlcode = 100) or (ll_check_treatment_id <> treatment_id) then
	ll_incorrect_observation_sequence = ll_observation_sequence
	
	// We got the wrong observation_sequence so query the database to get the right one
	SELECT max(observation_sequence)
	INTO :ll_observation_sequence
	FROM p_Observation
	WHERE cpr_id = :current_patient.cpr_id
	AND treatment_id = :treatment_id
	AND observation_id = :ps_observation_id;
	if not tf_check() then return -1
	if isnull(ll_observation_sequence) then
		log.log(this, "add_observation()", "Unable to determine the correct observation_sequence (" + string(ll_incorrect_observation_sequence) + ")", 4)
		return -1
	end if
	
	p_observation.object.observation_sequence[ll_row] = ll_observation_sequence
	p_observation.setitemstatus(ll_row, 0, Primary!, NotModified!)
	log.log_db(this, "add_observation()", "Correct observation_sequence found (" + string(ll_incorrect_observation_sequence) + ", " + string(ll_observation_sequence) + ")", 3)
end if


return ll_observation_sequence



end function

public function long add_observation (long pl_parent_observation_sequence, string ps_observation_id, integer pi_child_ordinal, string ps_observation_tag, boolean pb_find_existing);string ls_service
long ll_stage

setnull(ll_stage)
setnull(ls_service)

return add_observation(pl_parent_observation_sequence, ps_observation_id, pi_child_ordinal, ps_observation_tag, ll_stage, ls_service, true)

end function

public function integer add_followup_treatments (string ps_treatment_type, string ps_description, str_attributes pstr_attributes);Long		ll_patient_workplan_id,ll_patient_workplan_item_id
Integer	i
String	ls_workplan_type,lc_followup_flag
datetime ldt_created
long ll_new_treatment_id
long ll_null

setnull(ll_null)
setnull(ldt_created)

 DECLARE lsp_get_treatment_followup_workplan PROCEDURE FOR dbo.sp_get_treatment_followup_workplan
			@ps_cpr_id = :current_patient.cpr_id,
			@pl_treatment_id = :treatment_id,
			@pl_encounter_id = :current_patient.open_encounter.encounter_id,
			@ps_ordered_by = :current_user.user_id,
			@ps_created_by = :current_scribe.user_id,
			@ps_workplan_type = :ls_workplan_type,
			@pl_patient_workplan_id = :ll_patient_workplan_id OUT;


lc_followup_flag = datalist.treatment_type_followup_flag(treatment_type)
If lc_followup_flag = "F" Then
	ls_workplan_type = "Followup"
ElseIf lc_followup_flag = "R" Then
	ls_workplan_type = "Referral"
End If
	
tf_begin_transaction(this, "add_followup_workplan()")

EXECUTE lsp_get_treatment_followup_workplan;
If Not tf_check() then Return -1

FETCH lsp_get_treatment_followup_workplan INTO :ll_patient_workplan_id;
If Not tf_check() then Return -1

CLOSE lsp_get_treatment_followup_workplan;

If Not isnull(ll_patient_workplan_id) Then
	ll_new_treatment_id = sqlca.sp_set_treatment_followup_workplan_item(current_patient.cpr_id, &
																								current_patient.open_encounter.encounter_id, &
																								ll_patient_workplan_id, &
																								ps_treatment_type, &
																								ps_description, &
																								current_user.user_id, &
																								current_scribe.user_id, &
																								ldt_created, &
																								ll_patient_workplan_item_id)
	If Not tf_check() then Return -1
	
	If Not isnull(ll_patient_workplan_item_id) Then
		For i = 1 to pstr_attributes.attribute_count
			if ll_new_treatment_id > 0 then
				sqlca.sp_set_treatment_progress(current_patient.cpr_id, &
															ll_new_treatment_id, &
															current_patient.open_encounter.encounter_id, &
															"Modify", &
															pstr_attributes.attribute[i].attribute, &
															pstr_attributes.attribute[i].value, &
															datetime(today(), now()), &
															current_service.patient_workplan_item_id, & 
															ll_null, &
															ll_null, &
															current_user.user_id, &
															current_scribe.user_id )
				If Not tf_check() Then Return -1
			else
				sqlca.sp_add_workplan_item_attribute(current_patient.cpr_id, &
																	ll_patient_workplan_id, &
																	ll_patient_workplan_item_id, &
																	pstr_attributes.attribute[i].attribute, &
																	pstr_attributes.attribute[i].value, &
																	current_scribe.user_id, &
																	current_user.user_id)
				If Not tf_check() Then Return -1
			end if
		Next
	End if
End if
tf_commit_transaction()

Return 1
end function

public function boolean any_results (long pl_root_observation_sequence, string ps_result_type);long ll_any_results

ll_any_results = sqlca.sp_patient_any_results( current_patient.cpr_id, pl_root_observation_sequence, ps_result_type, "N")
if not tf_check() then return false

if ll_any_results > 0 then return true

return false

end function

public function integer remove_collection_results (long pl_observation_sequence);string ls_observation_id
integer li_sts
integer li_result_sequence

DECLARE lsp_add_default_collect_result PROCEDURE FOR dbo.sp_add_default_collect_result
		@ps_observation_id = :ls_observation_id,
		@pi_result_sequence = :li_result_sequence OUT;

ls_observation_id = get_observation_id(pl_observation_sequence)

SELECT min(result_sequence) as result_sequence
INTO :li_result_sequence
FROM c_Observation_Result
WHERE observation_id = :ls_observation_id
AND result_type = 'COLLECT'
AND status = 'OK';
if not tf_check() then return -1
if sqlca.sqlcode = 100 or isnull(li_result_sequence) then
	EXECUTE lsp_add_default_collect_result;
	if not tf_check() then return -1
	
	FETCH lsp_add_default_collect_result INTO :li_result_sequence;
	if not tf_check() then return -1
	
	CLOSE lsp_add_default_collect_result;
end if

li_sts = remove_results(pl_observation_sequence, li_result_sequence)

return li_sts

end function

public function boolean is_authorized ();///////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description:Check whether the current user is authorized to write prescription
//
// Returns: true - success, false - failure
//
// Created By:Sumathi Chinnasamy										Creation dt: 03/17/2000
//
// Modified By:															Modified On:
///////////////////////////////////////////////////////////////////////////////////////////////////////

Integer				ll_log_id
integer li_sts
str_drug_definition lstr_drug
str_package_definition lstr_package
str_drug_package lstr_drug_package


// We don't need authorization to order past treatments
if past_treatment then return true

If current_user.certified <> "Y" or isnull(current_user.certified) Then
	// If either the drug or package is null then assume it's authorized
	if isnull(drug_id) or isnull(package_id) then return true
	
	li_sts = drugdb.get_drug_package(drug_id, package_id, lstr_drug, lstr_package, lstr_drug_package)
	// If the drug/package doesn't exist then assume it's authorized
	if li_sts = 0 then return true
	if li_sts < 0 then
		log.log(this, "is_authorized()", "Error getting Drug/Package (" + drug_id + ", " + package_id + ")", 4)
		return false
	end if
	If lstr_drug_package.prescription_flag = "Y" Then
		If isnull(current_user.supervisor) Then
			mylog.log(This, "add_medication()", "User (" + current_user.user_id +&
											") not authorized to write prescription", 3)
			Openwithparm(w_pop_message, "You are not authorized to write a "+&
							"		prescription for " + lstr_drug.common_name)
			Return false
//		Else
//		// Check to see if prescription signature has already been ordered.  When supervisor
//		// signs, all unsigned prescription medications will be presented for approval.
//			ll_log_id = luo_encounter.find_service("RX_SIGNATURE")
//			If ll_log_id = 0 Then
//				ll_log_id = luo_encounter.order_service("RX_SIGNATURE", &
//																"Signature for " + lstr_drug.common_name, &
//																current_user.supervisor.user_id)
//			End If
		End if
	End if
End if

// authorized
Return true
end function

public function long remove_results (long pl_observation_sequence, string ps_location, integer pi_result_sequence);string ls_find
long ll_row
long ll_rowcount
integer li_sts

sqlca.sp_remove_results ( &
	current_patient.cpr_id, &
	pl_observation_sequence, &
	ps_location, &
	pi_result_sequence, &
	current_patient.open_encounter_id, &
	current_user.user_id, &
	current_scribe.user_id)
if not tf_check() then return -1

li_sts = p_observation_result.retrieve(parent_patient.cpr_id, treatment_id)

//
//// Now remove them from the datastore
//ll_rowcount = p_observation_result.rowcount()
//ls_find = "observation_sequence=" + string(pl_observation_sequence)
//ls_find += " and result_sequence = " + string(pi_result_sequence)
//ls_find += " and location = '" + ps_location + "'"
//
//ll_row = p_observation_result.find(ls_find, 1, ll_rowcount)
//DO WHILE ll_row > 0 and ll_row <= ll_rowcount
//	p_observation_result.deleterow()
//	
//	ll_row = p_observation_result.find(ls_find, ll_row + 1, ll_rowcount + 1)
//LOOP

return 1

end function

public function long remove_results (long pl_observation_sequence);string ls_location
integer li_result_sequence

setnull(ls_location)
setnull(li_result_sequence)

return remove_results(pl_observation_sequence, ls_location, li_result_sequence)


end function

public function str_p_observation get_observation (long pl_observation_sequence);
str_p_observation lstr_observation

SELECT cpr_id,
		treatment_id,
		observation_sequence,
		observation_id,
		encounter_id,
		result_expected_date,
		observation_tag,
		abnormal_flag,
		severity,
		composite_flag,
		parent_observation_sequence,
		stage,
		observed_by,
		created,
		created_by
INTO :lstr_observation.cpr_id,
		:lstr_observation.treatment_id,
		:lstr_observation.observation_sequence,
		:lstr_observation.observation_id,
		:lstr_observation.encounter_id,
		:lstr_observation.result_expected_date,
		:lstr_observation.observation_tag,
		:lstr_observation.abnormal_flag,
		:lstr_observation.severity,
		:lstr_observation.composite_flag,
		:lstr_observation.parent_observation_sequence,
		:lstr_observation.stage,
		:lstr_observation.observed_by,
		:lstr_observation.created,
		:lstr_observation.created_by
FROM p_Observation
WHERE cpr_id = :current_patient.cpr_id
AND observation_sequence = :pl_observation_sequence;
if not tf_check() then setnull(lstr_observation.observation_sequence)

return lstr_observation

end function

public function str_observation_comment_list get_comments (long pl_observation_sequence, string ps_comment_title);string ls_find
long ll_rowcount
str_observation_comment_list lstr_list
string ls_sort
integer i
integer li_comment_index
u_ds_data luo_data

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_observation_comment")

if isnull(ps_comment_title) or trim(ps_comment_title) = "" then ps_comment_title = "%"

ll_rowcount = luo_data.retrieve(current_patient.cpr_id, pl_observation_sequence, ps_comment_title)
if ll_rowcount <= 0 then
	DESTROY luo_data
	return lstr_list
end if

// First get all the comments into a list
lstr_list.comment_count = 0
for i = 1 to ll_rowcount
	// First, get the comment into a local structure
	lstr_list.comment_count += 1
	lstr_list.comment[lstr_list.comment_count].observation_comment_id = luo_data.object.observation_comment_id[i]
	lstr_list.comment[lstr_list.comment_count].comment_type = luo_data.object.comment_type[i]
	lstr_list.comment[lstr_list.comment_count].comment_title = luo_data.object.comment_title[i]
	lstr_list.comment[lstr_list.comment_count].comment_date_time = luo_data.object.comment_date_time[i]
	lstr_list.comment[lstr_list.comment_count].comment = luo_data.object.comment[i]
	lstr_list.comment[lstr_list.comment_count].abnormal_flag = luo_data.object.abnormal_flag[i]
	lstr_list.comment[lstr_list.comment_count].severity = luo_data.object.severity[i]
	lstr_list.comment[lstr_list.comment_count].encounter_id = luo_data.object.encounter_id[i]
	lstr_list.comment[lstr_list.comment_count].attachment_id = luo_data.object.attachment_id[i]
	lstr_list.comment[lstr_list.comment_count].root_observation_sequence = luo_data.object.root_observation_sequence[i]
	lstr_list.comment[lstr_list.comment_count].user_id = luo_data.object.user_id[i]
	lstr_list.comment[lstr_list.comment_count].created_by = luo_data.object.created_by[i]
	lstr_list.comment[lstr_list.comment_count].created = luo_data.object.created[i]
next

DESTROY luo_data

return lstr_list


end function

public function long get_observation_results (long pl_observation_sequence, ref str_p_observation_result pstra_result[]);string ls_find
long ll_row
str_c_observation_result lstr_c_result
long ll_rowcount
long ll_result_count

// This method returns a structure holding the data elements for a single result.

ll_rowcount = p_observation_result.rowcount()
ll_result_count = 0

ls_find = "observation_sequence=" + string(pl_observation_sequence)
ll_row = p_observation_result.find(ls_find, 1, ll_rowcount)
DO WHILE ll_row > 0 and ll_row <= ll_rowcount
	ll_result_count += 1
	pstra_result[ll_result_count].cpr_id = p_observation_result.object.cpr_id[ll_row]
	pstra_result[ll_result_count].treatment_id = p_observation_result.object.treatment_id[ll_row]
	pstra_result[ll_result_count].observation_sequence = p_observation_result.object.observation_sequence[ll_row]
	pstra_result[ll_result_count].location_result_sequence = p_observation_result.object.location_result_sequence[ll_row]
	pstra_result[ll_result_count].location = p_observation_result.object.location[ll_row]
	pstra_result[ll_result_count].observation_id = p_observation_result.object.observation_id[ll_row]
	pstra_result[ll_result_count].result_sequence = p_observation_result.object.result_sequence[ll_row]
	pstra_result[ll_result_count].encounter_id = p_observation_result.object.encounter_id[ll_row]
	pstra_result[ll_result_count].result_date_time = p_observation_result.object.result_date_time[ll_row]
	pstra_result[ll_result_count].attachment_id = p_observation_result.object.attachment_id[ll_row]
	pstra_result[ll_result_count].result_value = p_observation_result.object.result_value[ll_row]
	pstra_result[ll_result_count].result_unit = p_observation_result.object.result_unit[ll_row]
	pstra_result[ll_result_count].abnormal_flag = p_observation_result.object.abnormal_flag[ll_row]
	pstra_result[ll_result_count].abnormal_nature = p_observation_result.object.abnormal_nature[ll_row]
	pstra_result[ll_result_count].observed_by = p_observation_result.object.observed_by[ll_row]
	pstra_result[ll_result_count].created = p_observation_result.object.created[ll_row]
	pstra_result[ll_result_count].created_by = p_observation_result.object.created_by[ll_row]
	
	// Check for a null result_unit
	if isnull(pstra_result[ll_result_count].result_unit) then
		// replace with result_unit from c_table
		lstr_c_result = datalist.observation_result(pstra_result[ll_result_count].observation_id, &
																	pstra_result[ll_result_count].result_sequence)
		pstra_result[ll_result_count].result_unit = lstr_c_result.result_unit
	end if
	
	ll_row = p_observation_result.find(ls_find, ll_row + 1, ll_rowcount + 1)
LOOP


return ll_result_count

end function

public function integer get_result (long pl_observation_sequence, integer pi_result_sequence, string ps_location, ref string ps_result);long ll_row
integer li_sts
string ls_find
long ll_p_rows
string ls_result_value
string ls_result_unit
string ls_abnormal_flag
string ls_abnormal_nature
string ls_result
string ls_result_amount_flag
string ls_print_result_flag
string ls_print_result_separator
string ls_unit_preference
string ls_display_mask


ll_p_rows = p_observation_result.rowcount()

// We must have have an observation sequence
if isnull(pl_observation_sequence) then
	log.log(this, "get_result()", "Null observation sequence", 4)
	return -1
end if

// Find the result record
ls_find = "observation_sequence=" + string(pl_observation_sequence)
ls_find += " and result_sequence=" + string(pi_result_sequence)
ls_find += " and location='" + ps_location + "'"
ll_row = p_observation_result.find(ls_find, 1, ll_p_rows)
if ll_row > 0 then
	ls_result = p_observation_result.object.result[ll_row]
	ls_result_value = p_observation_result.object.result_value[ll_row]
	ls_result_unit = p_observation_result.object.result_unit[ll_row]
	ls_result_amount_flag = p_observation_result.object.result_amount_flag[ll_row]
	ls_print_result_flag = p_observation_result.object.print_result_flag[ll_row]
	ls_print_result_separator = p_observation_result.object.print_result_separator[ll_row]
	ls_abnormal_flag = p_observation_result.object.abnormal_flag[ll_row]
	ls_unit_preference = p_observation_result.object.unit_preference[ll_row]
	ls_display_mask = p_observation_result.object.display_mask[ll_row]
	
	ps_result = f_pretty_result( ls_result, &
											"", &
											"", &
											ls_result_value, &
											ls_result_unit, &
											ls_result_amount_flag, &
											ls_print_result_flag, &
											ls_print_result_separator, &
											ls_abnormal_flag, &
											ls_unit_preference, &
											ls_display_mask, &
											false, &
											false, &
											true )
	
	if len(ps_result) > 0 then
		li_sts = 1
	else
		li_sts = 0
	end if
else
	li_sts = 0
end if


return li_sts



end function

public function integer order_treatment_old (string ps_cpr_id, long pl_encounter_id, string ps_treatment_type, string ps_treatment_desc, long pl_problem_id, boolean pb_past_treatment, string ps_user_id, datetime pdt_begin_dt, datetime pdt_end_dt, long pl_parent_treatment_id, integer pi_attribute_count, ref string ps_attributes[], ref string ps_values[]);///////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description: Call the respective treatment component to order a treatment
//
// Returns: 1 - Success 
//          0 - No Operation
//         -1 - Failure
//
// Created By:Sumathi Chinnasamy										Creation dt: 03/24/2000
//
// Modified By:															Modified On:
///////////////////////////////////////////////////////////////////////////////////////////////////////
integer 	li_sts
String	ls_proc_drug_id
str_drug_definition lstr_drug
str_attributes lstr_attributes
string ls_in_office_flag
string ls_workplan_close_flag
string ls_encounter_status
long ll_patient_workplan_id
datetime ldt_encounter_date

SetNull(treatment_id)
treatment_type 			= ps_treatment_type
open_encounter_id 		= pl_encounter_id
begin_date 					= pdt_begin_dt
end_date 					= pdt_end_dt
treatment_description	= ps_treatment_desc
ordered_by 					= ps_user_id
past_treatment 			= pb_past_treatment
parent_treatment_id		= pl_parent_treatment_id

// Set the open_encounter_id if none was provided
if isnull(open_encounter_id) then
	// If there's a current service the use that
	if not isnull(current_service) then open_encounter_id = current_service.encounter_id
	
	// If it's still null then use the current_display_encounter
	if isnull(open_encounter_id) and not isnull(current_display_encounter) then
		open_encounter_id = current_display_encounter.encounter_id
	end if
end if

if isnull(begin_date) then
	ls_encounter_status = current_patient.encounters.encounter_status(open_encounter_id)
	ldt_encounter_date = current_patient.encounters.encounter_date(open_encounter_id)
	if upper(ls_encounter_status) = "OPEN" then
		if date(ldt_encounter_date) < today() then
			// If the encounter was started on a previous day then use the encounter date
			begin_date = ldt_encounter_date
		else
			// If the encounter was started today then use the current date/time
			begin_date = datetime(today(), now())
		end if
	else
		li_sts = f_get_treatment_dates(treatment_type, treatment_description, open_encounter_id, begin_date, end_date)
		if li_sts <= 0 then return 0
	end if
end if


ls_in_office_flag = datalist.treatment_type_in_office_flag(treatment_type)
ls_workplan_close_flag = datalist.treatment_type_workplan_close_flag(treatment_type)

if isnull(pl_problem_id) then
	problem_count = 0
else
	problem_count = 1
	problem_ids[1]				= pl_problem_id
end if

If parent_treatment_id = 0 Then Setnull(parent_treatment_id)

lstr_attributes = f_attribute_arrays_to_str(pi_attribute_count, ps_attributes, ps_values)
map_attr_to_data_columns(lstr_attributes)

if not isnull(drug_id) then
	If Not current_patient.check_drug_allergy(drug_id) Then Return 0
	
	// check whether the user can write prescription
	If Not is_authorized() Then Return 0
end if

If Not Isnull(procedure_id) Then
	// Get the drug id from procedure table
	SELECT vaccine_id
	 INTO :ls_proc_drug_id
	 FROM c_Procedure
	 WHERE procedure_id = :procedure_id Using cprdb;

	If Not tf_check() Then Return -1

	If cprdb.Sqlcode = 100 Then
		Setnull(ls_proc_drug_id)
	End If

	// Set the drug attribute
	drug_id = ls_proc_drug_id
	
End If

// If we don't have a treatment description then create one
if isnull(treatment_description) then
	if not isnull(observation_id) then
		treatment_description = datalist.observation_description(observation_id)
	elseif not isnull(drug_id) then
		li_sts = drugdb.get_drug_definition(drug_id, lstr_drug)
		if li_sts <= 0 then
			mylog.log(this, "order_treatment()", "Unable to get drug definition (" + drug_id + ")", 4)
			treatment_description = "Drug Treatment"
		else
			treatment_description = lstr_drug.common_name
		end if
	elseif not isnull(procedure_id) then
		SELECT description
		INTO :treatment_description
		FROM c_Procedure
		WHERE procedure_id = :procedure_id
		USING cprdb;
		if not cprdb.check() then return -1
		if cprdb.sqlcode = 100 then
			mylog.log(this, "order_treatment()", "Unable to get procedure definition (" + procedure_id + ")", 4)
			treatment_description = "Procedure Treatment"
		end if
	else
		treatment_description = datalist.treatment_type_description(treatment_type)
	end if
end if

// Reset Flags
exists = false
updated = false
deleted = false

li_sts = current_patient.treatments.new_treatment(this, true)
If li_sts < 0 Then Return -1

// Do autoperform Services
this.function POST do_autoperform_services()

// See if we have a current workplan
SELECT min(patient_workplan_id)
INTO :ll_patient_workplan_id
FROM p_Patient_WP
WHERE cpr_id = :current_patient.cpr_id
AND treatment_id = :treatment_id
AND status = 'Current';
if not tf_check() then return -1

// If this is an in-office treatment without a workplan and the workplan close flag is "Y", then close it.
// Or if it is a past in-office treatment then close it.
// Or if the caller provided an end_date then close it.
if (ls_in_office_flag = "Y" and ls_workplan_close_flag = "Y" and isnull(ll_patient_workplan_id)) &
 or (past_treatment and ls_in_office_flag = "Y") &
 or not Isnull(end_date) then
	if isnull(end_date) then end_date = begin_date
	Close("CLOSED", end_date)
end if

return li_sts


end function

public function str_treatment_description treatment_description ();str_treatment_description lstr_treatment


lstr_treatment.treatment_id = treatment_id
lstr_treatment.treatment_type = treatment_type
lstr_treatment.treatment_description = treatment_description
lstr_treatment.begin_date = begin_date
lstr_treatment.end_date = end_date
lstr_treatment.treatment_status = treatment_status
lstr_treatment.open_encounter_id = open_encounter_id
lstr_treatment.close_encounter_id = close_encounter_id
lstr_treatment.parent_treatment_id = parent_treatment_id
lstr_treatment.observation_id = observation_id
// Check for previous bug that set observation_id to empty string
if trim(lstr_treatment.observation_id) = "" then setnull(lstr_treatment.observation_id)
lstr_treatment.drug_id = drug_id
lstr_treatment.package_id = package_id
lstr_treatment.specialty_id = specialty_id
lstr_treatment.procedure_id = procedure_id
lstr_treatment.location = location
lstr_treatment.ordered_by = ordered_by
lstr_treatment.material_id = material_id
lstr_treatment.treatment_mode = treatment_mode
lstr_treatment.created = created
lstr_treatment.created_by = created_by


lstr_treatment.dose_amount = dose_amount
lstr_treatment.dose_unit = dose_unit
lstr_treatment.duration_amount = duration_amount
lstr_treatment.duration_unit = duration_unit
lstr_treatment.duration_prn = duration_prn
lstr_treatment.dispense_amount = dispense_amount
lstr_treatment.office_dispense_amount = office_dispense_amount
lstr_treatment.dispense_unit = dispense_unit
lstr_treatment.administration_sequence = administration_sequence
lstr_treatment.administer_frequency = administer_frequency
lstr_treatment.refills = refills
lstr_treatment.brand_name_required = brand_name_required

lstr_treatment.problem_count = problem_count

lstr_treatment.treatment_description = treatment_description


return lstr_treatment


end function

private function long add_result_record (long pl_observation_sequence, integer pi_result_sequence, string ps_location, datetime pdt_result_date_time, string ps_result_value, string ps_result_unit, string ps_abnormal_flag, string ps_abnormal_nature, string ps_normal_range);long ll_row
integer li_sts
string ls_observation_id
string ls_find
long i
long ll_p_rows
boolean lb_followon
string ls_location_description
integer li_location_sort_sequence
str_c_observation_result lstr_result
u_unit luo_unit

ll_p_rows = p_observation_result.rowcount()

// We must have have an observation sequence
if isnull(pl_observation_sequence) then
	log.log(this, "add_result()", "Null observation sequence", 4)
	return -1
end if

// Find the result record
ls_find = "observation_sequence=" + string(pl_observation_sequence)
ll_row = p_observation.find(ls_find, 1, p_observation.rowcount())
if ll_row <= 0 then
	log.log(this, "add_result()", "observation sequence not found (" + string(pl_observation_sequence) + ")", 4)
	return -1
end if

ls_observation_id = p_observation.object.observation_id[ll_row]

lstr_result = datalist.observation_result(ls_observation_id, pi_result_sequence)
if isnull(lstr_result.result_sequence) then
	log.log(this, "add_result()", "observation result not found (" + ls_observation_id + ", " + string(pi_result_sequence) + ")", 4)
	return -1
end if


ls_location_description = datalist.location_description(ps_location)
li_location_sort_sequence = datalist.location_sort_sequence(ps_location)

if isnull(ps_abnormal_flag) then
	ps_abnormal_flag = lstr_result.abnormal_flag
end if

if upper(lstr_result.result_amount_flag) = "Y" then
	// If the result unit is not supplied then default to the result definition
	if isnull(ps_result_unit) then ps_result_unit = lstr_result.result_unit
	if isnull(ps_result_unit) then
		log.log(this, "add_result_record()", "result_amount_flag is Y but unit is not provided", 4)
		return -1
	end if
	
	luo_unit = unit_list.find_unit(ps_result_unit)
	if isnull(luo_unit) then
		log.log(this, "add_result_record()", "Unit not found (" + ps_result_unit + ")", 4)
		return -1
	end if
	
	// Now that we have the unit object, make sure that this result is valid
	li_sts = luo_unit.check_value(ps_result_value)
	if li_sts < 0 then
		log.log(this, "add_result_record()", "Result value not valid (" + ps_result_value + ")", 4)
		return -1
	end if
end if

// If the record doesn't exist then add it
ll_row = p_observation_result.insertrow(0)
// Result fields
p_observation_result.object.cpr_id[ll_row] = current_patient.cpr_id
p_observation_result.object.treatment_id[ll_row] = treatment_id
p_observation_result.object.observation_sequence[ll_row] = pl_observation_sequence
p_observation_result.object.observation_id[ll_row] = ls_observation_id
p_observation_result.object.encounter_id[ll_row] = current_patient.open_encounter_id
p_observation_result.object.location[ll_row] = ps_location
p_observation_result.object.result_sequence[ll_row] = pi_result_sequence
p_observation_result.object.observed_by[ll_row] = current_user.user_id
p_observation_result.object.created[ll_row] = datetime(today(), now())
p_observation_result.object.created_by[ll_row] = current_scribe.user_id
p_observation_result.object.result_date_time[ll_row] = pdt_result_date_time
p_observation_result.object.result_type[ll_row] = lstr_result.result_type
p_observation_result.object.result[ll_row] = lstr_result.result
p_observation_result.object.result_value[ll_row] = ps_result_value
p_observation_result.object.result_unit[ll_row] = ps_result_unit	
p_observation_result.object.abnormal_flag[ll_row] = ps_abnormal_flag	
p_observation_result.object.abnormal_nature[ll_row] = ps_abnormal_nature	
p_observation_result.object.severity[ll_row] = lstr_result.severity
p_observation_result.object.normal_range[ll_row] = ps_normal_range

// Joined-in fields
p_observation_result.object.c_result_unit[ll_row] = lstr_result.result_unit
p_observation_result.object.result_amount_flag[ll_row] = lstr_result.result_amount_flag
p_observation_result.object.print_result_flag[ll_row] = lstr_result.print_result_flag
p_observation_result.object.c_severity[ll_row] = lstr_result.severity
p_observation_result.object.c_abnormal_flag[ll_row] = lstr_result.abnormal_flag
p_observation_result.object.unit_preference[ll_row] = lstr_result.unit_preference
p_observation_result.object.display_mask[ll_row] = lstr_result.display_mask
p_observation_result.object.sort_sequence[ll_row] = lstr_result.sort_sequence
p_observation_result.object.status[ll_row] = lstr_result.status
p_observation_result.object.location_description[ll_row] = ls_location_description
p_observation_result.object.location_sort_sequence[ll_row] = li_location_sort_sequence

// Update the database
tf_begin_transaction(this, "add_result_record()")
li_sts = p_observation_result.update()
if li_sts <= 0 then
	log.log(this, "add_result()", "Error adding p_observation_result record", 4)
	tf_rollback()
	return -1
end if
tf_commit()

p_observation_result.sort()

return 1



end function

public function long add_result (long pl_observation_sequence, integer pi_result_sequence, string ps_location, datetime pdt_result_date_time, string ps_result_value, string ps_result_unit, string ps_abnormal_flag, string ps_abnormal_nature, string ps_normal_range);
if isnull(pdt_result_date_time) then
	// If there isn't a current encounter then use the current date/time
	if isnull(current_patient.open_encounter) then
		pdt_result_date_time = begin_date
	else
		// If the current encounter is open and the treatment date matches the encounter date then
		// use the current date/time
		if current_patient.open_encounter.encounter_status = "OPEN" &
			and isnull(treatment_status) &
			and date(begin_date) = date(current_patient.open_encounter.encounter_date) then
				pdt_result_date_time = datetime(today(), now())
		else
			// If the current encounter is closed then it happened in the past
			// so use the past encounter date as the result_date_time
			pdt_result_date_time = begin_date
		end if
	end if
end if

return add_result_record(pl_observation_sequence, pi_result_sequence, ps_location, pdt_result_date_time, ps_result_value, ps_result_unit, ps_abnormal_flag, ps_abnormal_nature, ps_normal_range)

end function

public function integer define_treatment (str_assessment_description pstr_assessment);return define_treatment(pstr_assessment, false)

end function

public function integer define_treatment (str_assessment_description pstr_assessment, boolean pb_grant_access);/////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description: Call the respective treatment component to define a treatment
//
// Returns: 1 - Success 
//          0 - No Operation
//         -1 - Failure
//
// Created By:Sumathi Chinnasamy										Creation dt: 04/27/2000
//
// Modified By:															Modified On:
///////////////////////////////////////////////////////////////////////////////////////////////////////
integer li_sts
long i, j
long ll_attribute_count
string ls_description
boolean lb_found
string ls_treatment_key
str_attributes lstr_attributes

assessment = pstr_assessment

// If the called sets pb_grant_access to true, then we don't need to check the clinical access flag
if not pb_grant_access then
	if not user_list.user_clinical_access_flag(current_scribe.user_id) then
		if cpr_mode = "CLIENT" then
			openwithparm(w_pop_message, "You are not authorized to define new treatments.")
		end if
		return 0
	end if
end if

li_sts = xx_define_treatment()

for i = 1 to treatment_count
	ls_description = treatment_definition[i].item_description
	
	// Check the treatment for contraindications
	ls_treatment_key = f_get_treatment_key(treatment_type, &
														treatment_definition[i].attribute_count, &
														treatment_definition[i].attribute, &
														treatment_definition[i].value)
	
	lstr_attributes = f_attribute_arrays_to_str(treatment_definition[i].attribute_count, &
														treatment_definition[i].attribute, &
														treatment_definition[i].value)
	
	if not isnull(current_patient) then
		f_cpr_set_msg("Checking for contraindications...")
		li_sts = f_check_contraindications(current_patient.cpr_id, assessment.assessment_id, treatment_type, ls_treatment_key, ls_description, lstr_attributes)
		f_cpr_set_msg("")
		if li_sts <= 0 then
			// skip this treatment
			for j = i to treatment_count - 1
				treatment_definition[j] = treatment_definition[j + 1]
			next
			treatment_count -= 1
			i -= 1
			continue
		end if
	end if
	
	// If the description returned is greater than 80 characters, make sure it's listed as an attribute
	if len(ls_description) > 80 then
		ll_attribute_count = treatment_definition[i].attribute_count
		lb_found = false
		for j = 1 to ll_attribute_count
			if lower(treatment_definition[i].attribute[j]) = "treatment_description" then
				treatment_definition[i].value[j] = ls_description
				lb_found = true
			end if
		next
		if not lb_found then
			ll_attribute_count += 1
			treatment_definition[i].attribute[ll_attribute_count] = "treatment_description"
			treatment_definition[i].value[ll_attribute_count] = ls_description
			treatment_definition[i].attribute_count = ll_attribute_count
		end if
	end if
next

return li_sts


end function

public function integer define_treatment (u_component_service puo_service);/////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description: Call the respective treatment component to define a treatment
//
// Returns: 1 - Success 
//          0 - No Operation
//         -1 - Failure
//
// Created By:Sumathi Chinnasamy										Creation dt: 04/27/2000
//
// Modified By:															Modified On:
///////////////////////////////////////////////////////////////////////////////////////////////////////
boolean lb_grant_access
string ls_grant
integer li_sts

if isnull(puo_service.problem_id) then
	assessment = f_empty_assessment()
else
	li_sts = current_patient.assessments.assessment(assessment, puo_service.problem_id)
	if li_sts <= 0 then
		assessment = f_empty_assessment()
	end if
end if

ls_grant = user_list.is_user_service_grant(current_user.user_id, puo_service.service)
if ls_grant = "G" then
	lb_grant_access = true
else
	lb_grant_access = false
end if

Return define_treatment(assessment, lb_grant_access)

end function

on u_component_treatment.create
call super::create
end on

on u_component_treatment.destroy
call super::destroy
end on

event constructor;call super::constructor;
p_observation = CREATE u_ds_data
p_observation_result = CREATE u_ds_data
p_observation_location = CREATE u_ds_data
p_observation_result_qualifier = CREATE u_ds_data

results = CREATE u_ds_observation_results

// create instance dwo to hold all the trt progress
p_observation.set_dataobject("dw_p_observation")
p_observation_result.set_dataobject("dw_p_observation_result")
p_observation_location.set_dataobject("dw_p_observation_location")
p_observation_result_qualifier.set_dataobject("dw_p_observation_result_qualifier")

results.set_dataobject("dw_sp_obstree_treatment")

reset()


end event

event destructor;if isvalid(attachment_list) and not isnull(attachment_list) then DESTROY attachment_list

if isvalid(p_observation) and not isnull(p_observation) then DESTROY p_observation
if isvalid(p_observation_location) and not isnull(p_observation_location) then DESTROY p_observation_location
if isvalid(p_observation_result) and not isnull(p_observation_result) then DESTROY p_observation_result
if isvalid(p_observation_result_qualifier) and not isnull(p_observation_result_qualifier) then DESTROY p_observation_result_qualifier

end event

