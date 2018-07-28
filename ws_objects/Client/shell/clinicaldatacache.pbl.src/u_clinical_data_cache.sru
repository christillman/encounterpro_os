$PBExportHeader$u_clinical_data_cache.sru
forward
global type u_clinical_data_cache from nonvisualobject
end type
type str_treatment_type_treatment_key_field from structure within u_clinical_data_cache
end type
end forward

type str_treatment_type_treatment_key_field from structure
	string		treatment_type
	string		treatment_key_field
end type

global type u_clinical_data_cache from nonvisualobject
end type
global u_clinical_data_cache u_clinical_data_cache

type variables
// patient cache
private u_ds_clinical_data_cache clinical_data_patient

// encounter cache
private u_ds_clinical_data_cache clinical_data_encounter

// assessment cache
private u_ds_clinical_data_cache clinical_data_assessment

// treatment cache
private u_ds_clinical_data_cache clinical_data_treatment

// attachment cache
private u_ds_clinical_data_cache clinical_data_attachment

private time time_reset



// patient workplan cache
private u_ds_data patient_workplan
private u_ds_data patient_object_workplan
private u_ds_data patient_results

end variables

forward prototypes
public function boolean if_condition (string ps_cpr_id, string ps_context_object, long pl_object_key, string ps_condition)
public function integer get_treatment (string ps_cpr_id, long pl_object_key, str_treatment_description pstr_treatment)
public subroutine clear_cache ()
public function str_property_value get_property (str_property pstr_property, string ps_cpr_id, long pl_object_key, str_attributes pstr_attributes)
public function long get_results (string ps_cpr_id, string ps_context_object, long pl_object_key, string ps_observation_id, integer pi_result_sequence, string ps_result_type, ref str_p_observation_result pstr_results[])
public function integer patient_object_workplan (string ps_cpr_id, string ps_context_object, long pl_object_key, ref str_p_patient_wp pstr_workplan)
public function integer patient_workplan (long pl_patient_workplan_id, ref str_p_patient_wp pstr_workplan)
public function integer modify_property (string ps_cpr_id, string ps_context_object, long pl_object_key, string ps_property, string ps_new_value)
private function integer get_data (string ps_cpr_id, string ps_context_object, long pl_object_key, ref u_ds_clinical_data_cache puo_cache_data)
public function str_property_value get_property (string ps_context_object, string ps_property, string ps_cpr_id, long pl_object_key)
end prototypes

public function boolean if_condition (string ps_cpr_id, string ps_context_object, long pl_object_key, string ps_condition);boolean lb_result
integer li_sts
long ll_row
u_ds_clinical_data_cache luo_data

li_sts = get_data(ps_cpr_id, ps_context_object, pl_object_key, luo_data)
if li_sts < 0 then
	log.log(this, "if_condition()", "Error getting data", 4)
	return false
end if

lb_result = false

ll_row = luo_data.find(ps_condition, 1, 1)
if ll_row > 0 then lb_result = true

return lb_result

end function

public function integer get_treatment (string ps_cpr_id, long pl_object_key, str_treatment_description pstr_treatment);string ls_description
integer li_sts
boolean lb_default_grant
u_ds_clinical_data_cache luo_treatment
str_treatment_description lstr_treatment

li_sts = get_data(ps_cpr_id, "Treatment", pl_object_key, luo_treatment)
if li_sts <= 0 then
	log.log(this, "get_treatment()", "Error getting treatment data", 4)
	return -1
end if

li_sts = luo_treatment.get_treatment(lstr_treatment)
if li_sts <= 0 then return -1

return 1

end function

public subroutine clear_cache ();clinical_data_assessment.clear_cache()
clinical_data_patient.clear_cache()
clinical_data_encounter.clear_cache()
clinical_data_assessment.clear_cache()
clinical_data_treatment.clear_cache()
clinical_data_attachment.clear_cache()

end subroutine

public function str_property_value get_property (str_property pstr_property, string ps_cpr_id, long pl_object_key, str_attributes pstr_attributes);str_property_value lstr_property_value
integer li_sts
string ls_property
u_ds_clinical_data_cache luo_data

ls_property = pstr_property.function_name

li_sts = get_data(ps_cpr_id, pstr_property.property_object, pl_object_key, luo_data)
if li_sts < 0 then return lstr_property_value

lstr_property_value = luo_data.get_property(ls_property)

return lstr_property_value



end function

public function long get_results (string ps_cpr_id, string ps_context_object, long pl_object_key, string ps_observation_id, integer pi_result_sequence, string ps_result_type, ref str_p_observation_result pstr_results[]);long ll_count
long ll_rowcount
string ls_filter
long i

ll_count = patient_results.retrieve(ps_cpr_id, ps_observation_id, pi_result_sequence)
if ll_count < 0 then return -1
if ll_count = 0 then return 0

if not isnull(pl_object_key) then
	CHOOSE CASE lower(ps_context_object)
		CASE "encounter"
			ls_filter = "encounter_id=" + string(pl_object_key)
		CASE "assessment"
	//		ls_filter = "problem_id=" + string(pl_object_key)
		CASE "treatment"
			ls_filter = "treatment_id=" + string(pl_object_key)
		CASE "observation"
			ls_filter = "observation_sequence=" + string(pl_object_key)
		CASE "attachment"
	END CHOOSE
end if

if isnull(pi_result_sequence) and len(ps_result_type) > 0 and  len(ls_filter) > 0 then
	ls_filter = "(" + ls_filter + ") and (upper(result_type)='" + upper(ps_result_type) + "')"
end if

patient_results.setfilter(ls_filter)
patient_results.filter()
ll_rowcount = patient_results.rowcount()

for i = 1 to ll_rowcount
	pstr_results[i].cpr_id = patient_results.object.cpr_id[i]
	pstr_results[i].treatment_id = patient_results.object.treatment_id[i]
	pstr_results[i].observation_sequence = patient_results.object.observation_sequence[i]
	pstr_results[i].location_result_sequence = patient_results.object.location_result_sequence[i]
	pstr_results[i].location = patient_results.object.location[i]
	pstr_results[i].observation_id = patient_results.object.observation_id[i]
	pstr_results[i].result_sequence = patient_results.object.result_sequence[i]
	pstr_results[i].result_type = patient_results.object.result_type[i]
	pstr_results[i].encounter_id = patient_results.object.encounter_id[i]
	pstr_results[i].result_date_time = patient_results.object.result_date_time[i]
	pstr_results[i].attachment_id = patient_results.object.attachment_id[i]
	pstr_results[i].result_value = patient_results.object.result_value[i]
	pstr_results[i].result_unit = patient_results.object.result_unit[i]
	pstr_results[i].abnormal_flag = patient_results.object.abnormal_flag[i]
	pstr_results[i].abnormal_nature = patient_results.object.abnormal_nature[i]
	pstr_results[i].observed_by = patient_results.object.observed_by[i]
	pstr_results[i].created = patient_results.object.created[i]
	pstr_results[i].created_by = patient_results.object.created_by[i]
	pstr_results[i].result = patient_results.object.result[i]
	pstr_results[i].severity = patient_results.object.severity[i]
	pstr_results[i].normal_range = patient_results.object.normal_range[i]
	pstr_results[i].root_observation_sequence = patient_results.object.root_observation_sequence[i]
	pstr_results[i].result_amount_flag = patient_results.object.result_amount_flag[i]
	pstr_results[i].print_result_flag = patient_results.object.print_result_flag[i]
	pstr_results[i].print_result_separator = patient_results.object.print_result_separator[i]
	pstr_results[i].unit_preference = patient_results.object.unit_preference[i]
	pstr_results[i].sort_sequence = patient_results.object.sort_sequence[i]
	pstr_results[i].display_mask = patient_results.object.display_mask[i]
next

return ll_rowcount

end function

public function integer patient_object_workplan (string ps_cpr_id, string ps_context_object, long pl_object_key, ref str_p_patient_wp pstr_workplan);long ll_rows

ll_rows = patient_object_workplan.retrieve(ps_cpr_id, ps_context_object, pl_object_key)
if ll_rows <= 0 then
	return -1
else
	pstr_workplan.patient_workplan_id = patient_object_workplan.object.patient_workplan_id[1]
	pstr_workplan.cpr_id = patient_object_workplan.object.cpr_id[1]
	pstr_workplan.workplan_id = patient_object_workplan.object.workplan_id[1]
	pstr_workplan.workplan_type = patient_object_workplan.object.workplan_type[1]
	pstr_workplan.in_office_flag = patient_object_workplan.object.in_office_flag[1]
	pstr_workplan.mode = patient_object_workplan.object.mode[1]
	pstr_workplan.last_step_dispatched = patient_object_workplan.object.last_step_dispatched[1]
	pstr_workplan.last_step_date = patient_object_workplan.object.last_step_date[1]
	pstr_workplan.encounter_id = patient_object_workplan.object.encounter_id[1]
	pstr_workplan.problem_id = patient_object_workplan.object.problem_id[1]
	pstr_workplan.treatment_id = patient_object_workplan.object.treatment_id[1]
	pstr_workplan.observation_sequence = patient_object_workplan.object.observation_sequence[1]
	pstr_workplan.attachment_id = patient_object_workplan.object.attachment_id[1]
	pstr_workplan.description = patient_object_workplan.object.description[1]
	pstr_workplan.ordered_by = patient_object_workplan.object.ordered_by[1]
	pstr_workplan.owned_by = patient_object_workplan.object.owned_by[1]
	pstr_workplan.prnt_patient_workplan_item_id = patient_object_workplan.object.parent_patient_workplan_item_id[1]
	pstr_workplan.status = patient_object_workplan.object.status[1]
	pstr_workplan.created_by = patient_object_workplan.object.created_by[1]
	pstr_workplan.created = patient_object_workplan.object.created[1]
end if

return 1


end function

public function integer patient_workplan (long pl_patient_workplan_id, ref str_p_patient_wp pstr_workplan);long ll_rows

ll_rows = patient_workplan.retrieve(pl_patient_workplan_id)
if ll_rows <= 0 then
	return -1
else
	pstr_workplan.patient_workplan_id = patient_workplan.object.patient_workplan_id[1]
	pstr_workplan.cpr_id = patient_workplan.object.cpr_id[1]
	pstr_workplan.workplan_id = patient_workplan.object.workplan_id[1]
	pstr_workplan.workplan_type = patient_workplan.object.workplan_type[1]
	pstr_workplan.in_office_flag = patient_workplan.object.in_office_flag[1]
	pstr_workplan.mode = patient_workplan.object.mode[1]
	pstr_workplan.last_step_dispatched = patient_workplan.object.last_step_dispatched[1]
	pstr_workplan.last_step_date = patient_workplan.object.last_step_date[1]
	pstr_workplan.encounter_id = patient_workplan.object.encounter_id[1]
	pstr_workplan.problem_id = patient_workplan.object.problem_id[1]
	pstr_workplan.treatment_id = patient_workplan.object.treatment_id[1]
	pstr_workplan.observation_sequence = patient_workplan.object.observation_sequence[1]
	pstr_workplan.attachment_id = patient_workplan.object.attachment_id[1]
	pstr_workplan.description = patient_workplan.object.description[1]
	pstr_workplan.ordered_by = patient_workplan.object.ordered_by[1]
	pstr_workplan.owned_by = patient_workplan.object.owned_by[1]
	pstr_workplan.prnt_patient_workplan_item_id = patient_workplan.object.parent_patient_workplan_item_id[1]
	pstr_workplan.status = patient_workplan.object.status[1]
	pstr_workplan.created_by = patient_workplan.object.created_by[1]
	pstr_workplan.created = patient_workplan.object.created[1]
end if

return 1


end function

public function integer modify_property (string ps_cpr_id, string ps_context_object, long pl_object_key, string ps_property, string ps_new_value);integer li_sts
u_ds_clinical_data_cache luo_data

// Get the current value of this property
li_sts = get_data(ps_cpr_id, ps_context_object, pl_object_key, luo_data)
if li_sts < 0 then return -1

li_sts = luo_data.modify_property(ps_property, ps_new_value)
if li_sts < 0 then return -1

return 1




end function

private function integer get_data (string ps_cpr_id, string ps_context_object, long pl_object_key, ref u_ds_clinical_data_cache puo_cache_data);integer li_sts

// Keep seperate caches 
CHOOSE CASE lower(ps_context_object)
	CASE "patient"
		puo_cache_data = clinical_data_patient
	CASE "encounter"
		puo_cache_data = clinical_data_encounter
	CASE "assessment"
		puo_cache_data = clinical_data_assessment
	CASE "treatment"
		puo_cache_data = clinical_data_treatment
	CASE "attachment"
		puo_cache_data = clinical_data_attachment
	CASE ELSE
		log.log(this, "get_data()", "Invalid context_object(" + ps_context_object + ")", 4)
		return -1
END CHOOSE

li_sts = puo_cache_data.load_clinical_data(ps_cpr_id, ps_context_object, pl_object_key)
if li_sts <= 0 then return -1

return 1

end function

public function str_property_value get_property (string ps_context_object, string ps_property, string ps_cpr_id, long pl_object_key);str_property lstr_property
str_attributes lstr_attributes

lstr_property = datalist.find_property(ps_context_object, ps_property)

return get_property(lstr_property, ps_cpr_id, pl_object_key, lstr_attributes)




end function

on u_clinical_data_cache.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_clinical_data_cache.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;// Clinical data caches
clinical_data_patient = CREATE u_ds_clinical_data_cache
clinical_data_encounter = CREATE u_ds_clinical_data_cache
clinical_data_assessment = CREATE u_ds_clinical_data_cache
clinical_data_treatment = CREATE u_ds_clinical_data_cache
clinical_data_attachment = CREATE u_ds_clinical_data_cache

patient_workplan = CREATE u_ds_data
patient_workplan.set_dataobject("dw_p_patient_wp")

patient_object_workplan = CREATE u_ds_data
patient_object_workplan.set_dataobject("dw_sp_patient_object_workplans")

patient_results = CREATE u_ds_data
patient_results.set_dataobject("dw_fn_patient_results")


end event

