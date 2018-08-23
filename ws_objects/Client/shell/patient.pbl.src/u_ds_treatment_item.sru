$PBExportHeader$u_ds_treatment_item.sru
forward
global type u_ds_treatment_item from u_ds_base_class
end type
type str_treatment_type_treatment_key_field from structure within u_ds_treatment_item
end type
end forward

type str_treatment_type_treatment_key_field from structure
	string		treatment_type
	string		treatment_key_field
end type

global type u_ds_treatment_item from u_ds_base_class
string dataobject = "dw_treatment_data"
end type
global u_ds_treatment_item u_ds_treatment_item

type variables
u_ds_data p_Assessment_Treatment

boolean cache_valid[]
str_treatment_description cache[]

private integer treatment_type_key_count
private str_treatment_type_treatment_key_field treatment_type_key[]

private string cpr_id

end variables

forward prototypes
public function integer refresh_service (long al_encounter_log_id)
public function integer refresh_service (long al_encounter_log_id, ref string as_treatment_status, ref datetime adt_end_date, ref long al_close_encounter_id)
public function integer refresh_status (long al_treatment_id)
public function boolean any_treatments (long pl_encounter_id, string ps_treatment_type)
public function integer close_assessment (long pl_problem_id)
public function integer delete_treatment (long pl_treatment_id)
public function integer get_assessment_treatments (long pl_problem_id, ref long pl_treatment_id[])
public function integer set_treatment_assessment (u_component_treatment puo_treatment, long pl_problem_id, boolean pb_associated)
public function integer set_treatment_assessment (long pl_treatment_id, long pl_problem_id, boolean pb_associated)
public function integer refresh_status (long al_treatment_id, ref string as_treatment_status, ref datetime adt_end_date, ref long al_close_encounter_id)
public function integer count_treatments (string ps_find)
public function integer get_assessment_treatments (long pl_problem_id, ref long pl_treatment_id[], ref long pl_encounter_id[])
public function integer get_child_treatments (long pl_treatment_id, ref str_treatment_description pstr_treatments[])
public function integer get_treatments (string ps_find, ref str_treatment_description pstra_treatments[])
public function integer set_treatment_progress (long pl_treatment_id, string ps_progress_type)
public function integer set_treatment_progress (long pl_treatment_id, string ps_progress_type, datetime pdt_progress_date_time)
public function integer set_treatment_progress (long pl_treatment_id, string ps_progress_type, string ps_progress)
public function integer get_treatment_assessments (long pl_treatment_id, ref long pl_problem_id[])
public function integer initialize (string ps_cpr_id)
public function integer set_treatment_progress (long pl_treatment_id, string ps_progress_type, string ps_progress_key, string ps_progress, u_attachment_list puo_attachment_list)
public function integer set_treatment_progress (long pl_treatment_id, string ps_progress_type, string ps_progress_key, string ps_progress, datetime pdt_progress_date_time, u_attachment_list puo_attachment_list)
public function integer set_treatment_progress (long pl_treatment_id, string ps_progress_type, string ps_progress_key, string ps_progress)
public function integer set_treatment_progress (long pl_treatment_id, string ps_progress_type, string ps_progress, u_attachment_list puo_attachment_list)
public function integer set_treatment_progress_key (long pl_treatment_id, string ps_progress_type, string ps_progress_key, string ps_progress)
public function integer set_treatment_progress (long pl_treatment_id, string ps_progress_type, string ps_progress_key, string ps_progress, long pl_risk_level)
public function integer set_treatment_progress (long pl_treatment_id, string ps_progress_type, string ps_progress_key, string ps_progress, datetime pdt_progress_date_time, long pl_risk_level)
public function string treatment_type (long pl_treatment_id)
public function boolean any_completed_treatments (long pl_problem_id)
public function string assessment_description (long pl_treatment_id, boolean pb_all_assessments)
public function integer get_tagged_comment (long pl_treatment_id, string ps_observation_tag, string ps_comment_title, str_observation_comment pstr_comment)
public function integer get_assessment_treatments (long pl_problem_id, long pl_encounter_id, ref str_treatment_description pstra_treatments[])
public function boolean is_ordered (long pl_treatment_id, string ps_service, ref integer pi_step_number)
public function integer get_comment (long pl_treatment_id, string ps_observation_id, string ps_comment_title, ref str_observation_comment pstr_comment)
public function string treatment_description (long pl_treatment_id)
public function string treatment_status (long pl_treatment_id)
public function integer get_encounter_treatments (long pl_encounter_id, ref str_treatment_description pstra_treatments[])
public function integer get_assessment_treatments (long pl_problem_id, ref str_treatment_description pstra_treatments[])
public function integer treatment (ref str_treatment_description pstr_treatment, long pl_treatment_id)
public function integer update_treatment (u_component_treatment puo_treatment)
public function integer treatment (ref u_component_treatment puo_treatment, long pl_treatment_id)
public function string treatment_key (long pl_treatment_id)
public function boolean any_assessment_treatments (long pl_problem_id, boolean pb_open_only)
public function integer modify_treatment (long pl_treatment_id, string ps_treatment_field, string ps_new_value)
public function long get_treatment_row (long pl_treatment_id)
public function long find_object_row (long pl_object_key)
public function long order_treatment (string ps_cpr_id, long pl_encounter_id, string ps_treatment_type, string ps_treatment_desc, long pl_problem_id, boolean pb_past_treatment, string ps_user_id, long pl_parent_treatment_id, str_attributes pstr_attributes)
protected function integer set_treatment_progress (long pl_treatment_id, string ps_progress_type, string ps_progress_key, string ps_progress, datetime pdt_progress_date_time, long pl_risk_level, u_attachment_list puo_attachment_list)
public function str_property_value get_property (long pl_object_key, string ps_property, str_attributes pstr_attributes)
public function string treatment_drug_id (long pl_treatment_id)
public function integer add_followup_treatment_item (long pl_parent_treatment_id, string ps_treatment_type, string ps_description, str_attributes pstr_attributes)
public function long order_treatment (string ps_cpr_id, long pl_encounter_id, string ps_treatment_type, string ps_treatment_desc, long pl_problem_id, boolean pb_past_treatment, string ps_user_id, long pl_parent_treatment_id, str_attributes pstr_attributes, boolean pb_do_autoperform)
public function integer do_autoperform_services (long pl_treatment_id)
public function long find_treatment (datetime pdt_begin_date, string ps_description)
public function long find_treatment (str_treatment_description pstr_treatment)
public function string treatment_observation_id (long pl_treatment_id)
public function string treatment_procedure_id (long pl_treatment_id)
public function long new_treatment (ref str_treatment_description pstr_treatment)
public function integer refresh_treatment_object (ref u_component_treatment puo_treatment, long pl_row)
public function integer treatment_update_if_modified (ref u_component_treatment puo_treatment)
private function string get_treatment_key (long pl_row)
public function long treatment_open_encounter_id (long pl_treatment_id)
public function integer get_assessment_treatments (long pl_problem_id, long pl_encounter_id, boolean pb_only_attached_treatments, ref str_treatment_description pstra_treatments[])
public function integer get_assessment_treatments (long pl_problem_id, boolean pb_only_attached_treatments, ref str_treatment_description pstra_treatments[])
public function str_treatment_description get_treatment (long pl_row)
public function integer initialize (string ps_cpr_id, long pl_treatment_id)
public function integer get_encounter_treatments (long pl_encounter_id, boolean pb_show_deleted, ref str_treatment_description pstra_treatments[])
public function long find_treatment (string ps_treatment_type, datetime pdt_begin_date, string ps_description)
public function long order_treatment (str_assessment_treatment_definition pstr_treatment_def, boolean pb_past_treatment)
public function long order_treatment (string ps_cpr_id, long pl_encounter_id, string ps_treatment_type, string ps_treatment_desc, long pl_problem_id, boolean pb_past_treatment, string ps_user_id, long pl_parent_treatment_id, str_attributes pstr_attributes, boolean pb_do_autoperform, boolean pb_get_treatment_dates)
public function integer new_treatment_old (u_component_treatment puo_treatment, boolean pb_workflow)
public function long new_treatment_record (string ps_cpr_id, long pl_open_encounter_id, string ps_treatment_type, string ps_treatment_mode, datetime pdt_begin_date, datetime pdt_end_date, string ps_treatment_description, long pl_original_treatment_id, long pl_parent_treatment_id, string ps_ordered_by, string ps_created_by, string ps_office_id, string ps_treatment_status, str_attributes pstr_attributes)
public function integer new_treatment (u_component_treatment puo_treatment, boolean pb_workflow)
public function integer refresh_row (long pl_row)
public subroutine set_treatment_changed (long pl_treatment_id)
end prototypes

public function integer refresh_service (long al_encounter_log_id);string ls_treatment_status
datetime ldt_end_date
long ll_close_encounter_id

return refresh_service(al_encounter_log_id, ls_treatment_status, ldt_end_date, ll_close_encounter_id)


end function

public function integer refresh_service (long al_encounter_log_id, ref string as_treatment_status, ref datetime adt_end_date, ref long al_close_encounter_id);String		ls_find
Long			ll_row
long ll_treatment_id


IF Isnull(parent_patient.open_encounter) THEN
	log.log(This, "u_ds_treatment_item.refresh_service:0007", "No open encounter", 4)
	RETURN -1
END IF

SELECT treatment_id
INTO :ll_treatment_id
FROM p_Encounter_Log
WHERE cpr_id = :parent_patient.cpr_id
AND encounter_id = :parent_patient.open_encounter_id
AND encounter_log_id = :al_encounter_log_id;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then
	log.log(this, "u_ds_treatment_item.refresh_service:0019", "encounter log record not found (" + string(al_encounter_log_id) + ")", 4)
	return -1
end if

// If this service doesn't have a treatment_id, then we're done
if isnull(ll_treatment_id) then return 1

return refresh_status(ll_treatment_id, as_treatment_status, adt_end_date, al_close_encounter_id)


end function

public function integer refresh_status (long al_treatment_id);string ls_treatment_status
datetime ldt_end_date
long ll_close_encounter_id

return refresh_status(al_treatment_id, ls_treatment_status, ldt_end_date, ll_close_encounter_id)

end function

public function boolean any_treatments (long pl_encounter_id, string ps_treatment_type);long ll_row
string ls_find

ls_find = "open_encounter_id=" + string(pl_encounter_id) &
	+ " and treatment_type = '" + ps_treatment_type + "'" &
	+ " and (isnull(treatment_status) or upper(treatment_status) <> 'CANCELLED')" &

ll_row = find(ls_find, 1, rowcount())
if ll_row <= 0 then return false

return true



end function

public function integer close_assessment (long pl_problem_id);long ll_row
long ll_rowcount
string ls_find
integer li_count
long ll_treatment_id
string ls_treatment_status
long ll_treatment_ids[]
integer i
integer li_at_count

if isnull(pl_problem_id) then return 0

ll_rowcount = rowcount()
li_count = 0

li_at_count = get_assessment_treatments(pl_problem_id, ll_treatment_ids)

for i = 1 to li_at_count
	ls_find = "treatment_id=" + string(ll_treatment_ids[i])
	ll_row = find(ls_find, 1, ll_rowcount)
	if ll_row <= 0 then continue
	
	ll_treatment_id = object.treatment_id[ll_row]
	ls_treatment_status = object.treatment_status[ll_row]
	if isnull(ls_treatment_status) or (upper(ls_treatment_status) <> "CLOSED" and upper(ls_treatment_status) <> "CANCELLED") then
		set_treatment_progress(ll_treatment_id, "CLOSED")
		reselectrow(ll_row)
		cache_valid[ll_row] = false
		li_count += 1
	end if
next

return li_count


end function

public function integer delete_treatment (long pl_treatment_id);integer li_sts

li_sts = set_treatment_progress(pl_treatment_id, "Cancelled")

return li_sts

end function

public function integer get_assessment_treatments (long pl_problem_id, ref long pl_treatment_id[]);long ll_problem_row
string ls_find_problem
integer li_count
long ll_at_count
long ll_treatment_id
string ls_treatment_status

ll_at_count = p_Assessment_Treatment.rowcount()
li_count = 0

ls_find_problem = "problem_id=" + string(pl_problem_id)

// Loop through all the treatments attached to this assessment
ll_problem_row = p_Assessment_Treatment.find(ls_find_problem, 1, ll_at_count)
DO WHILE ll_problem_row > 0 and ll_problem_row <= ll_at_count
	ll_treatment_id = p_Assessment_Treatment.object.treatment_id[ll_problem_row]
	ls_treatment_status = treatment_status(ll_treatment_id)
	if isnull(ls_treatment_status) or upper(ls_treatment_status) <> "CANCELLED" then 
		li_count += 1
		pl_treatment_id[li_count] = ll_treatment_id
	end if

	ll_problem_row = p_Assessment_Treatment.find(ls_find_problem, ll_problem_row + 1, ll_at_count + 1)
LOOP

return li_count



end function

public function integer set_treatment_assessment (u_component_treatment puo_treatment, long pl_problem_id, boolean pb_associated);long ll_row
string ls_find
long ll_at_count
integer li_sts

li_sts = set_treatment_assessment(puo_treatment.treatment_id, pl_problem_id, pb_associated)
if li_sts <= 0 then return li_sts

// Refresh the list of associated assessments
puo_treatment.problem_count = get_treatment_assessments(puo_treatment.treatment_id, puo_treatment.problem_ids)

return 1

end function

public function integer set_treatment_assessment (long pl_treatment_id, long pl_problem_id, boolean pb_associated);string ls_associate
long ll_at_count
integer li_sts

if pb_associated then
	ls_associate = "Associate"
else
	ls_associate = "Disassociate"
end if

li_sts = set_treatment_progress(pl_treatment_id, "ASSESSMENT", ls_associate, string(pl_problem_id))
if li_sts <= 0 then return -1

li_sts = p_Assessment_Treatment.retrieve(current_patient.cpr_id)

return li_sts

end function

public function integer refresh_status (long al_treatment_id, ref string as_treatment_status, ref datetime adt_end_date, ref long al_close_encounter_id);String		ls_find
Long			ll_row

IF Isnull(al_treatment_id) or al_treatment_id <= 0 THEN
	log.log(This, "u_ds_treatment_item.refresh_status:0005", "Invalid treatment_id", 4)
	RETURN -1
END IF

ls_find = "treatment_id=" + string(al_treatment_id)
ll_row = Find(ls_find, 1, rowcount())
IF ll_row <= 0 THEN
	log.log(This, "u_ds_treatment_item.refresh_status:0012", "treatment not found", 4)
	RETURN -1
END IF

// Refresh the updatable column values for this particular row
reselectrow(ll_row)
cache_valid[ll_row] = false

as_treatment_status = object.treatment_status[ll_row]
adt_end_date = object.end_date[ll_row]
al_close_encounter_id = object.close_encounter_id[ll_row]

// Now get the calculated fields which might have changed.
//SELECT treatment_status, end_date, close_encounter_id
//INTO :as_treatment_status, :adt_end_date, :al_close_encounter_id
//FROM p_Treatment_Item
//WHERE cpr_id = :parent_patient.cpr_id
//AND treatment_id = :al_treatment_id;
//IF not tf_check() THEN RETURN -1
//IF sqlca.sqlcode = 100 THEN
//	log.log(This, "u_ds_treatment_item.refresh_status:0032", "Unable to refresh treatment_status", 3)
//ELSE
//	object.treatment_status[ll_row] = as_treatment_status
//	object.end_date[ll_row] = adt_end_date
//	object.close_encounter_id[ll_row] = al_close_encounter_id
//END IF

RETURN 1

end function

public function integer count_treatments (string ps_find);Long		ll_rowcount
long ll_row
Integer	li_count

li_count = 0
ll_rowcount = rowcount()

ll_row = Find(ps_find,ll_row,ll_rowcount)
DO WHILE ll_row > 0 AND ll_row <= ll_rowcount
	li_count++
	ll_row = Find(ps_find, ll_row + 1, ll_rowcount + 1)
LOOP

return li_count

end function

public function integer get_assessment_treatments (long pl_problem_id, ref long pl_treatment_id[], ref long pl_encounter_id[]);long ll_problem_row
string ls_find_problem
integer li_count
long ll_at_count
long ll_treatment_id
string ls_treatment_status

ll_at_count = p_Assessment_Treatment.rowcount()
li_count = 0

ls_find_problem = "problem_id=" + string(pl_problem_id)

// Loop through all the treatments attached to this assessment
ll_problem_row = p_Assessment_Treatment.find(ls_find_problem, 1, ll_at_count)
DO WHILE ll_problem_row > 0 and ll_problem_row <= ll_at_count
	ll_treatment_id = p_Assessment_Treatment.object.treatment_id[ll_problem_row]
	ls_treatment_status = treatment_status(ll_treatment_id)
	if isnull(ls_treatment_status) or upper(ls_treatment_status) <> "CANCELLED" then 
		li_count += 1
		pl_treatment_id[li_count] = p_Assessment_Treatment.object.treatment_id[ll_problem_row]
		pl_encounter_id[li_count] = p_Assessment_Treatment.object.encounter_id[ll_problem_row]
	end if
	
	ll_problem_row = p_Assessment_Treatment.find(ls_find_problem, ll_problem_row + 1, ll_at_count + 1)
LOOP

return li_count



end function

public function integer get_child_treatments (long pl_treatment_id, ref str_treatment_description pstr_treatments[]);integer			i,ll_rowcount,li_return
u_ds_data      lds_data

lds_data = create u_ds_data

lds_data.set_dataobject("dw_sp_get_child_treatments")
lds_data.settransobject(sqlca)

li_return = lds_data.retrieve(pl_treatment_id)
If not tf_check() then 
	destroy lds_data
	return -1
end if

ll_rowcount = lds_data.rowcount()

For i = 1 to ll_rowcount
	pstr_treatments[i].treatment_type = lds_data.object.ordered_treatment_type[i]
	pstr_treatments[i].treatment_description = lds_data.object.description[i]
	pstr_treatments[i].cpt_code = lds_data.object.cpt_code[i]
next
destroy lds_data

Return ll_rowcount

end function

public function integer get_treatments (string ps_find, ref str_treatment_description pstra_treatments[]);Long		ll_rowcount, ll_row = 1
Integer	li_count

ps_find = "( " + ps_find + " )"
ps_find += " and ( isnull(treatment_status) or lower(treatment_status) <> 'cancelled' )"

ll_rowcount = rowcount()
ll_row = Find(ps_find,ll_row,ll_rowcount)

DO WHILE ll_row > 0
	li_count++
	pstra_treatments[li_count] = get_treatment(ll_row)

	ll_row++
	// Prevent endless loop
	IF ll_row > ll_rowcount THEN EXIT
	ll_row = Find(ps_find, ll_row, ll_rowcount)

LOOP

return li_count

end function

public function integer set_treatment_progress (long pl_treatment_id, string ps_progress_type);u_attachment_list luo_attachment_list
string ls_progress
string ls_progress_key

setnull(ls_progress_key)
setnull(ls_progress)
setnull(luo_attachment_list)

return set_treatment_progress(pl_treatment_id, ps_progress_type, ls_progress_key, ls_progress, luo_attachment_list)


end function

public function integer set_treatment_progress (long pl_treatment_id, string ps_progress_type, datetime pdt_progress_date_time);u_attachment_list luo_attachment_list
string ls_progress
string ls_progress_key

setnull(ls_progress_key)
setnull(ls_progress)
setnull(luo_attachment_list)

return set_treatment_progress(pl_treatment_id, ps_progress_type, ls_progress_key, ls_progress, pdt_progress_date_time, luo_attachment_list)


end function

public function integer set_treatment_progress (long pl_treatment_id, string ps_progress_type, string ps_progress);u_attachment_list luo_attachment_list
string ls_progress_key

setnull(ls_progress_key)
setnull(luo_attachment_list)

return set_treatment_progress(pl_treatment_id, ps_progress_type, ls_progress_key, ps_progress, luo_attachment_list)


end function

public function integer get_treatment_assessments (long pl_treatment_id, ref long pl_problem_id[]);long ll_treatment_row
string ls_find_treatment
integer li_count
long ll_at_count

ll_at_count = p_Assessment_Treatment.rowcount()

li_count = 0

ls_find_treatment = "treatment_id=" + string(pl_treatment_id)

// Loop through all the problems attached to this assessment
ll_treatment_row = p_Assessment_Treatment.find(ls_find_treatment, 1, ll_at_count)
DO WHILE ll_treatment_row > 0 and ll_treatment_row <= ll_at_count
	li_count += 1
	pl_problem_id[li_count] = p_Assessment_Treatment.object.problem_id[ll_treatment_row]

	ll_treatment_row = p_Assessment_Treatment.find(ls_find_treatment, ll_treatment_row + 1, ll_at_count + 1)
LOOP

return li_count



end function

public function integer initialize (string ps_cpr_id);long ll_treatment_id

setnull(ll_treatment_id)

return initialize(ps_cpr_id, ll_treatment_id)


end function

public function integer set_treatment_progress (long pl_treatment_id, string ps_progress_type, string ps_progress_key, string ps_progress, u_attachment_list puo_attachment_list);datetime ldt_progress_date_time

setnull(ldt_progress_date_time)

return set_treatment_progress(pl_treatment_id, ps_progress_type, ps_progress_key, ps_progress, ldt_progress_date_time, puo_attachment_list)

end function

public function integer set_treatment_progress (long pl_treatment_id, string ps_progress_type, string ps_progress_key, string ps_progress, datetime pdt_progress_date_time, u_attachment_list puo_attachment_list);long ll_risk_level

setnull(ll_risk_level)

return set_treatment_progress(pl_treatment_id, &
										ps_progress_type, &
										ps_progress_key, &
										ps_progress, &
										pdt_progress_date_time, &
										ll_risk_level, &
										puo_attachment_list )
										


end function

public function integer set_treatment_progress (long pl_treatment_id, string ps_progress_type, string ps_progress_key, string ps_progress);u_attachment_list luo_attachment_list
datetime ldt_progress_date_time
long ll_risk_level

setnull(luo_attachment_list)
setnull(ldt_progress_date_time)
setnull(ll_risk_level)

return set_treatment_progress(pl_treatment_id, ps_progress_type, ps_progress_key, ps_progress, ldt_progress_date_time, ll_risk_level, luo_attachment_list)


end function

public function integer set_treatment_progress (long pl_treatment_id, string ps_progress_type, string ps_progress, u_attachment_list puo_attachment_list);u_attachment_list luo_attachment_list
string ls_progress_key

setnull(luo_attachment_list)
setnull(ls_progress_key)

return set_treatment_progress(pl_treatment_id, ps_progress_type, ls_progress_key, ps_progress, luo_attachment_list)


end function

public function integer set_treatment_progress_key (long pl_treatment_id, string ps_progress_type, string ps_progress_key, string ps_progress);u_attachment_list luo_attachment_list
long ll_risk_level
datetime ldt_progress_date_time

setnull(ll_risk_level)
setnull(ldt_progress_date_time)
setnull(luo_attachment_list)

return set_treatment_progress(pl_treatment_id, ps_progress_type, ps_progress_key, ps_progress, ldt_progress_date_time, ll_risk_level, luo_attachment_list)


end function

public function integer set_treatment_progress (long pl_treatment_id, string ps_progress_type, string ps_progress_key, string ps_progress, long pl_risk_level);u_attachment_list luo_attachment_list
datetime ldt_progress_date_time

setnull(luo_attachment_list)
setnull(ldt_progress_date_time)

return set_treatment_progress(pl_treatment_id, ps_progress_type, ps_progress_key, ps_progress, ldt_progress_date_time, pl_risk_level, luo_attachment_list)


end function

public function integer set_treatment_progress (long pl_treatment_id, string ps_progress_type, string ps_progress_key, string ps_progress, datetime pdt_progress_date_time, long pl_risk_level);u_attachment_list luo_attachment_list

setnull(luo_attachment_list)

return set_treatment_progress(pl_treatment_id, ps_progress_type, ps_progress_key, ps_progress, pdt_progress_date_time, pl_risk_level, luo_attachment_list)


end function

public function string treatment_type (long pl_treatment_id);Long	ll_row
integer li_sts
String	ls_treatment_type
string ls_find

setnull(ls_treatment_type)

If isnull(pl_treatment_id) Then return ls_treatment_type

ls_find = "treatment_id=" + string(pl_treatment_id)

ll_row = find(ls_find, 1, rowcount())
If ll_row > 0 Then
	ls_treatment_type = object.treatment_type[ll_row]
end if

return ls_treatment_type

end function

public function boolean any_completed_treatments (long pl_problem_id);long ll_treatment_row
string ls_find_treatment
long li_at_count
string ls_treatment_status
long ll_treatment_ids[]
integer i

li_at_count = get_assessment_treatments(pl_problem_id, ll_treatment_ids)

for i = 1 to li_at_count
	// Loop through all the treatments attached to this assessment
	ls_find_treatment = "treatment_id=" + string(pl_problem_id)
	ll_treatment_row = find(ls_find_treatment, 1, rowcount())
	if ll_treatment_row <= 0 then continue

	// Check the status of the treatment
	ls_treatment_status = object.treatment_status[ll_treatment_row]
	
	// If it's not null, then we've found at least one completed treatment, so we're done
	if not isnull(ls_treatment_status) then return true
next

return false



end function

public function string assessment_description (long pl_treatment_id, boolean pb_all_assessments);str_assessment_description lstra_assessments[]
string ls_description
integer li_count
integer i
long lla_problem_ids[]
integer li_problem_count

setnull(ls_description)

li_problem_count = get_treatment_assessments(pl_treatment_id, lla_problem_ids)

li_count = current_patient.assessments.get_assessments(li_problem_count, lla_problem_ids, lstra_assessments)
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

public function integer get_tagged_comment (long pl_treatment_id, string ps_observation_tag, string ps_comment_title, str_observation_comment pstr_comment);// returns structure str_observation_comment_list containing
// the latest comment for the given observation_id/comment_title combination
// where the observation_id is recorded as a root observation in p_Observation
string ls_find
long ll_rowcount
str_observation_comment_list lstr_list
string ls_sort
integer i
integer li_comment_index
u_ds_data luo_data

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_root_observation_comment")

ll_rowcount = luo_data.retrieve(current_patient.cpr_id, pl_treatment_id, ps_observation_tag, ps_comment_title)
if ll_rowcount <= 0 then
	DESTROY luo_data
	return ll_rowcount
end if

// First get all the comments into a list
lstr_list.comment_count = 0
for i = 1 to ll_rowcount
	// First, get the comment into a local structure
	lstr_list.comment_count += 1
	lstr_list.comment[lstr_list.comment_count].observation_comment_id = luo_data.object.observation_comment_id[i]
	lstr_list.comment[lstr_list.comment_count].comment_title = luo_data.object.comment_title[i]
	lstr_list.comment[lstr_list.comment_count].comment = luo_data.object.comment[i]
	lstr_list.comment[lstr_list.comment_count].abnormal_flag = luo_data.object.abnormal_flag[i]
	lstr_list.comment[lstr_list.comment_count].severity = luo_data.object.severity[i]
	lstr_list.comment[lstr_list.comment_count].encounter_id = luo_data.object.encounter_id[i]
	lstr_list.comment[lstr_list.comment_count].attachment_id = luo_data.object.attachment_id[i]
	lstr_list.comment[lstr_list.comment_count].user_id = luo_data.object.user_id[i]
	lstr_list.comment[lstr_list.comment_count].created_by = luo_data.object.created_by[i]
	lstr_list.comment[lstr_list.comment_count].created = luo_data.object.created[i]
next

// Then get the last comment...
pstr_comment = lstr_list.comment[lstr_list.comment_count]

// And add all the other comments as previous comments
pstr_comment.previous_comments.comment_count = lstr_list.comment_count - 1
for i = 1 to lstr_list.comment_count - 1
	pstr_comment.previous_comments.comment[i] = lstr_list.comment[i]
next

DESTROY luo_data

return 1

end function

public function integer get_assessment_treatments (long pl_problem_id, long pl_encounter_id, ref str_treatment_description pstra_treatments[]);return get_assessment_treatments(pl_problem_id, pl_encounter_id, true, pstra_treatments[])

end function

public function boolean is_ordered (long pl_treatment_id, string ps_service, ref integer pi_step_number);integer li_count

SELECT count(*), min(i.step_number)
INTO :li_count, :pi_step_number
FROM p_Patient_WP w, p_Patient_WP_Item i
WHERE w.patient_workplan_id = i.patient_workplan_id
AND w.cpr_id = :current_patient.cpr_id
AND w.treatment_id = :pl_treatment_id
AND i.item_type = 'Service'
AND i.ordered_service = :ps_service
AND ((i.status IS NULL) OR (i.status IN ('Dispatched', 'Started')));
if not tf_check() then return false

if li_count > 0 then return true

return false

end function

public function integer get_comment (long pl_treatment_id, string ps_observation_id, string ps_comment_title, ref str_observation_comment pstr_comment);// returns structure str_observation_comment_list containing
// the latest comment for the given observation_id/comment_title combination
// where the observation_id is recorded as a root observation in p_Observation
string ls_find
long ll_rowcount
str_observation_comment_list lstr_list
string ls_sort
integer i
integer li_comment_index
u_ds_data luo_data

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_root_observation_comment")

if isnull(ps_comment_title) or trim(ps_comment_title) = "" then ps_comment_title = "%"

ll_rowcount = luo_data.retrieve(current_patient.cpr_id, pl_treatment_id, ps_observation_id, ps_comment_title)
if ll_rowcount <= 0 then
	DESTROY luo_data
	return ll_rowcount
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

// Then get the last comment...
pstr_comment = lstr_list.comment[lstr_list.comment_count]

// And add all the other comments as previous comments
pstr_comment.previous_comments.comment_count = lstr_list.comment_count - 1
for i = 1 to lstr_list.comment_count - 1
	pstr_comment.previous_comments.comment[i] = lstr_list.comment[i]
next

DESTROY luo_data

return 1

end function

public function string treatment_description (long pl_treatment_id);Long	ll_row
integer li_sts
String	ls_treatment_description
string ls_find

setnull(ls_treatment_description)

If isnull(pl_treatment_id) Then return ls_treatment_description

ls_find = "treatment_id=" + string(pl_treatment_id)

ll_row = find(ls_find, 1, rowcount())
If ll_row > 0 Then
	ls_treatment_description = object.treatment_description[ll_row]
end if

return ls_treatment_description

end function

public function string treatment_status (long pl_treatment_id);Long	ll_row
integer li_sts
String	ls_treatment_status
string ls_find

setnull(ls_treatment_status)

If isnull(pl_treatment_id) Then return ls_treatment_status

ls_find = "treatment_id=" + string(pl_treatment_id)

ll_row = find(ls_find, 1, rowcount())
If ll_row > 0 Then
	ls_treatment_status = object.treatment_status[ll_row]
end if

return upper(ls_treatment_status)

end function

public function integer get_encounter_treatments (long pl_encounter_id, ref str_treatment_description pstra_treatments[]);return get_encounter_treatments(pl_encounter_id, false, pstra_treatments)

end function

public function integer get_assessment_treatments (long pl_problem_id, ref str_treatment_description pstra_treatments[]);return get_assessment_treatments(pl_problem_id, true, pstra_treatments[])

end function

public function integer treatment (ref str_treatment_description pstr_treatment, long pl_treatment_id);Long					ll_row
integer li_sts
String				ls_treatment_type,ls_component_id,ls_find
Long					ll_treatment_id
Integer				li_attachment_sequence
u_attachment_list luo_attachment_list
integer li_count

If isnull(pl_treatment_id) Then
	Setnull(pstr_treatment.treatment_id)
	Return 0
End if

ls_find = "treatment_id=" + string(pl_treatment_id)

ll_row = find(ls_find, 1, rowcount())
If ll_row < 0 Then
	setnull(pstr_treatment.treatment_id)
	Return -1
End if

If ll_row = 0 Then
	// Insert a record into p_treatment_item table.
	ll_row = insertrow(0)
	cache_valid[ll_row] = false
	
	object.cpr_id[ll_row] = current_patient.cpr_id
	object.treatment_id[ll_row] = pl_treatment_id
	
	li_sts = refresh_row(ll_row)
	if li_sts < 0 then
		setnull(pstr_treatment.treatment_id)
		return -1
	end if

	p_Assessment_Treatment.retrieve(current_patient.cpr_id)
end if

pstr_treatment = get_treatment(ll_row)

return 1

end function

public function integer update_treatment (u_component_treatment puo_treatment);integer li_sts
string ls_find
long ll_row
long ll_open_encounter_id
datetime ldt_original_begin_date

if isnull(current_patient.open_encounter) then
	log.log(this, "u_ds_treatment_item.update_treatment:0008", "Cannot save treatment without an encounter context", 4)
	return -1
end if

ls_find = "treatment_id=" + string(puo_treatment.treatment_id)
ll_row = find(ls_find, 1, rowcount())
if ll_row <= 0 then return -1

ll_open_encounter_id = object.open_encounter_id[ll_row]

// If updates are not allowed to this treatment type then see if we need to close the old treatment and open a new one
if not f_string_to_boolean(datalist.treatment_type_field(puo_treatment.treatment_type, "update_flag")) then
	// If we're in a different encounter from when the treatment was created, or
	// if the encounter is closed before today, then mark the old treatment as modified
	// and create a new treatment
	ldt_original_begin_date = object.begin_date[ll_row]
	If ll_open_encounter_id <> current_patient.open_encounter.encounter_id &
		or (upper(current_patient.open_encounter.encounter_status) = "CLOSED" &
		     and date(ldt_original_begin_date) < today())  then
		// close the existing treatment record with a status of "MODIFIED" and then
		// save this object as a new treatment
		puo_treatment.original_treatment_id = puo_treatment.treatment_id
		Setnull(puo_treatment.treatment_id)
		puo_treatment.open_encounter_id = current_patient.open_encounter.encounter_id
		puo_treatment.begin_date = datetime(today(), now())
		puo_treatment.ordered_by = current_user.user_id
		puo_treatment.past_treatment = true
		puo_treatment.updated = false
		puo_treatment.exists = false
		
		// Mark the old treatment as "Modified" as of the begin_date of the new treatment
		set_treatment_progress(puo_treatment.original_treatment_id, "MODIFIED", puo_treatment.begin_date)
		
		// Create the new treatment record
		li_sts = new_treatment(puo_treatment, false)
		
		return li_sts
	end if
end if

// If we get here then just modify the editable fields
modify_treatment(puo_treatment.treatment_id, "begin_date", string(puo_treatment.begin_date, db_datetime_format))
modify_treatment(puo_treatment.treatment_id, "package_id", puo_treatment.package_id)
modify_treatment(puo_treatment.treatment_id, "specialty_id", puo_treatment.specialty_id)
modify_treatment(puo_treatment.treatment_id, "procedure_id", puo_treatment.procedure_id)
modify_treatment(puo_treatment.treatment_id, "drug_id", puo_treatment.drug_id)
modify_treatment(puo_treatment.treatment_id, "observation_id", puo_treatment.observation_id)
modify_treatment(puo_treatment.treatment_id, "administration_sequence", string(puo_treatment.administration_sequence))
modify_treatment(puo_treatment.treatment_id, "dose_amount", string(puo_treatment.dose_amount))
modify_treatment(puo_treatment.treatment_id, "dose_unit", puo_treatment.dose_unit)
modify_treatment(puo_treatment.treatment_id, "administer_frequency", puo_treatment.administer_frequency)
modify_treatment(puo_treatment.treatment_id, "duration_amount", string(puo_treatment.duration_amount))
modify_treatment(puo_treatment.treatment_id, "duration_unit", puo_treatment.duration_unit)
modify_treatment(puo_treatment.treatment_id, "duration_prn", puo_treatment.duration_prn)
modify_treatment(puo_treatment.treatment_id, "dispense_amount", string(puo_treatment.dispense_amount))
modify_treatment(puo_treatment.treatment_id, "office_dispense_amount", string(puo_treatment.office_dispense_amount))
modify_treatment(puo_treatment.treatment_id, "dispense_unit", puo_treatment.dispense_unit)
modify_treatment(puo_treatment.treatment_id, "brand_name_required", puo_treatment.brand_name_required)
modify_treatment(puo_treatment.treatment_id, "refills", string(puo_treatment.refills))
modify_treatment(puo_treatment.treatment_id, "treatment_goal", puo_treatment.treatment_goal)
modify_treatment(puo_treatment.treatment_id, "location", puo_treatment.location)
modify_treatment(puo_treatment.treatment_id, "maker_id", puo_treatment.maker_id)
modify_treatment(puo_treatment.treatment_id, "lot_number", puo_treatment.lot_number)
modify_treatment(puo_treatment.treatment_id, "expiration_date", string(puo_treatment.expiration_date, db_datetime_format))
modify_treatment(puo_treatment.treatment_id, "send_out_flag", puo_treatment.send_out_flag)
modify_treatment(puo_treatment.treatment_id, "original_treatment_id", string(puo_treatment.original_treatment_id))
modify_treatment(puo_treatment.treatment_id, "referral_question", puo_treatment.referral_question)
modify_treatment(puo_treatment.treatment_id, "referral_question_assmnt_id", puo_treatment.referral_question_assmnt_id)
modify_treatment(puo_treatment.treatment_id, "material_id", string(puo_treatment.material_id))
modify_treatment(puo_treatment.treatment_id, "treatment_mode", puo_treatment.treatment_mode)
modify_treatment(puo_treatment.treatment_id, "treatment_description", puo_treatment.treatment_description)
modify_treatment(puo_treatment.treatment_id, "office_id", puo_treatment.treatment_office_id)
modify_treatment(puo_treatment.treatment_id, "ordered_for", puo_treatment.ordered_for)
modify_treatment(puo_treatment.treatment_id, "ordered_by_supervisor", puo_treatment.ordered_by_supervisor)
modify_treatment(puo_treatment.treatment_id, "appointment_date_time", string(puo_treatment.appointment_date_time, db_datetime_format))

Return 1


end function

public function integer treatment (ref u_component_treatment puo_treatment, long pl_treatment_id);Long					ll_row
integer li_sts
String				ls_treatment_type,ls_find
Integer				li_attachment_sequence
u_attachment_list luo_attachment_list
integer li_count
string ls_treatment_description

If Isvalid(puo_treatment) And Not Isnull(puo_treatment) Then DESTROY puo_treatment

If isnull(pl_treatment_id) Then
	Setnull(puo_treatment)
	Return 0
End if

ls_find = "treatment_id=" + string(pl_treatment_id)

ll_row = find(ls_find, 1, rowcount())
If ll_row < 0 Then
	setnull(puo_treatment)
	Return -1
End if

If ll_row = 0 Then
	// Insert a record into p_treatment_item table.
	ll_row = insertrow(0)
	cache_valid[ll_row] = false
	
	object.cpr_id[ll_row] = current_patient.cpr_id
	object.treatment_id[ll_row] = pl_treatment_id
	
	li_sts = refresh_row(ll_row)
	if li_sts < 0 then
		setnull(puo_treatment)
		return -1
	end if

	p_Assessment_Treatment.retrieve(current_patient.cpr_id)
end if

// Instantiate the treatment component if it has valid component id
ls_treatment_type = object.treatment_type[ll_row]
puo_treatment = f_get_treatment_component(ls_treatment_type)
If Isnull(puo_treatment) Then
	log.log(This,"u_ds_treatment_item.treatment:0045","unable to create treatment component for "+&
				ls_treatment_type,4)
	Return 0
End If

return refresh_treatment_object(puo_treatment, ll_row)


end function

public function string treatment_key (long pl_treatment_id);Long	ll_row
String	ls_treatment_key
string ls_find

setnull(ls_treatment_key)

If isnull(pl_treatment_id) Then return ls_treatment_key

ls_find = "treatment_id=" + string(pl_treatment_id)
ll_row = find(ls_find, 1, rowcount())
if ll_row > 0 then
	ls_treatment_key = get_treatment_key(ll_row)
end if

return ls_treatment_key

end function

public function boolean any_assessment_treatments (long pl_problem_id, boolean pb_open_only);long ll_problem_row
string ls_find_problem
integer li_count
long ll_at_count
long ll_treatment_id
string ls_treatment_status

ll_at_count = p_Assessment_Treatment.rowcount()
li_count = 0

ls_find_problem = "problem_id=" + string(pl_problem_id)

// Loop through all the treatments attached to this assessment
ll_problem_row = p_Assessment_Treatment.find(ls_find_problem, 1, ll_at_count)
DO WHILE ll_problem_row > 0 and ll_problem_row <= ll_at_count
	ll_treatment_id = p_Assessment_Treatment.object.treatment_id[ll_problem_row]
	ls_treatment_status = treatment_status(ll_treatment_id)
	if isnull(ls_treatment_status) then return true
	if not pb_open_only and upper(ls_treatment_status) <> "CANCELLED" then return true

	ll_problem_row = p_Assessment_Treatment.find(ls_find_problem, ll_problem_row + 1, ll_at_count + 1)
LOOP

return false




end function

public function integer modify_treatment (long pl_treatment_id, string ps_treatment_field, string ps_new_value);string ls_old_value

// See if the value changed before we modify it
ls_old_value = get_property_value(pl_treatment_id, ps_treatment_field)
if f_string_modified(ls_old_value, ps_new_value) then
	return set_treatment_progress(pl_treatment_id, "Modify", ps_treatment_field, ps_new_value)
end if

return 0



end function

public function long get_treatment_row (long pl_treatment_id);Long					ll_row
String				ls_find

If isnull(pl_treatment_id) Then return 0

ls_find = "treatment_id=" + string(pl_treatment_id)

ll_row = find(ls_find, 1, rowcount())
If ll_row > 0 then return ll_row

return 0



end function

public function long find_object_row (long pl_object_key);return get_treatment_row(pl_object_key)

end function

public function long order_treatment (string ps_cpr_id, long pl_encounter_id, string ps_treatment_type, string ps_treatment_desc, long pl_problem_id, boolean pb_past_treatment, string ps_user_id, long pl_parent_treatment_id, str_attributes pstr_attributes);return order_treatment(ps_cpr_id, &
								pl_encounter_id, &
								ps_treatment_type, &
								ps_treatment_desc, &
								pl_problem_id, &
								pb_past_treatment, &
								ps_user_id, &
								pl_parent_treatment_id, &
								pstr_attributes, &
								true, &
								true)



end function

protected function integer set_treatment_progress (long pl_treatment_id, string ps_progress_type, string ps_progress_key, string ps_progress, datetime pdt_progress_date_time, long pl_risk_level, u_attachment_list puo_attachment_list);string ls_find
long ll_row
string ls_treatment_status
datetime ldt_end_date
long ll_close_encounter_id
long ll_encounter_id
long ll_patient_workplan_item_id
long ll_attachment_id
integer li_sts
str_encounter_description lstr_encounter

setnull(ll_patient_workplan_item_id)
setnull(ll_attachment_id)

str_popup	popup
str_popup_return popup_return

if isnull(pl_treatment_id) or pl_treatment_id <= 0 then
	log.log(this, "u_ds_treatment_item.set_treatment_progress:0019", "Invalid treatment_id", 4)
	return -1
end if

setnull(ll_encounter_id)
if isnull(current_service) then
	ll_encounter_id = current_patient.open_encounter_id
else
	ll_encounter_id = current_service.encounter_id
end if

// If we don't have an encounter_id, then use the open encounter_id for the treatment
if isnull(ll_encounter_id) then
	ll_encounter_id = treatment_open_encounter_id(pl_treatment_id)
end if

// If we still don't have an encounter_id, then use the last encounter
if isnull(ll_encounter_id) then
	lstr_encounter = current_patient.encounters.last_encounter("1=1")
	ll_encounter_id = lstr_encounter.encounter_id
end if


ls_find = "treatment_id=" + string(pl_treatment_id)
ll_row = find(ls_find, 1, rowcount())
if ll_row <= 0 then
	log.log(this, "u_ds_treatment_item.set_treatment_progress:0045", "treatment not found", 4)
	return -1
end if

If Isnull(ps_progress) AND upper(ps_progress_type) = 'CANCELLED' THEN
	// enter the reason for cancellation
	popup.argument_count = 1
	popup.argument[1] = "DELETE_TREATMENT"
	popup.title = "Please enter the reason this treatment is being cancelled:"
	openwithparm(w_pop_prompt_string, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return 0
	
	ps_progress = popup_return.items[1]
End If

li_sts = f_set_progress(current_patient.cpr_id, &
								"Treatment", &
								pl_treatment_id, &
								ps_progress_type, &
								ps_progress_key, &
								ps_progress, &
								pdt_progress_date_time, &
								pl_risk_level, &
								ll_attachment_id, &
								ll_patient_workplan_item_id)
if li_sts < 0 then return -1

reselectrow(ll_row)
cache_valid[ll_row] = false

Return 1

end function

public function str_property_value get_property (long pl_object_key, string ps_property, str_attributes pstr_attributes);str_property_value lstr_property_value
long ll_row
real lr_amount
string ls_unit
u_unit luo_unit
string ls_prn
str_progress lstr_progress
u_user luo_user
string ls_null
integer li_sts
real lr_duration_amount
string ls_duration_unit
string ls_duration_prn
datetime ldt_appointment_date_time
string ls_temp

setnull(ls_null)

setnull(lstr_property_value.value)
setnull(lstr_property_value.display_value)
setnull(lstr_property_value.textcolor)
setnull(lstr_property_value.backcolor)
setnull(lstr_property_value.weight)

pstr_attributes.attribute_count = 0

ll_row = find_object_row(pl_object_key)
if isnull(ll_row) or ll_row <= 0 then return lstr_property_value

CHOOSE CASE lower(ps_property)
	CASE "administer_frequency_description"
		ls_temp = object.administer_frequency[ll_row]
		lstr_property_value.value = drugdb.administration_frequency_property(ls_temp, "description")
		lstr_property_value.display_value = lstr_property_value.value
//		SELECT description
//		INTO :lstr_property_value.display_value
//		FROM c_Administration_Frequency
//		WHERE administer_frequency = :lstr_property_value.value;
//		if not tf_check() or sqlca.sqlcode = 100 then lstr_property_value.display_value = lstr_property_value.value
	CASE "administer_method"
		ls_temp = object.package_id[ll_row]
		lstr_property_value.value = drugdb.get_package_property(ls_temp, "administer_method")
		lstr_property_value.display_value = lstr_property_value.value
	CASE "administer_method_description"
		ls_temp = object.package_id[ll_row]
		lstr_property_value.value = drugdb.get_package_property(ls_temp, "method_description")
		lstr_property_value.display_value = lstr_property_value.value
	CASE "dispense"
		lr_amount = object.dispense_amount[ll_row]
		ls_unit = object.dispense_unit[ll_row]
		luo_unit = unit_list.find_unit(ls_unit)
		if not isnull(luo_unit) then
			lstr_property_value.value = luo_unit.pretty_amount_unit(lr_amount)
			lstr_property_value.display_value = lstr_property_value.value
		end if
	CASE "dose"
		lr_amount = object.dose_amount[ll_row]
		ls_unit = object.dose_unit[ll_row]
		luo_unit = unit_list.find_unit(ls_unit)
		if not isnull(luo_unit) then
			lstr_property_value.value = luo_unit.pretty_amount_unit(lr_amount)
			lstr_property_value.display_value = lstr_property_value.value
		end if
	CASE "drug_sig_brief"
		f_attribute_add_attribute(pstr_attributes, "drug_id", string(object.drug_id[ll_row]))
		f_attribute_add_attribute(pstr_attributes, "package_id", string(object.package_id[ll_row]))
		f_attribute_add_attribute(pstr_attributes, "dose_amount", string(real(object.dose_amount[ll_row])))
		f_attribute_add_attribute(pstr_attributes, "dose_unit", string(object.dose_unit[ll_row]))
		f_attribute_add_attribute(pstr_attributes, "administer_frequency", string(object.administer_frequency[ll_row]))
		f_attribute_add_attribute(pstr_attributes, "duration_amount", string(real(object.duration_amount[ll_row])))
		f_attribute_add_attribute(pstr_attributes, "duration_unit", string(object.duration_unit[ll_row]))
		f_attribute_add_attribute(pstr_attributes, "duration_prn", string(object.duration_prn[ll_row]))
		f_attribute_add_attribute(pstr_attributes, "administration_sequence", string(integer(object.administration_sequence[ll_row])))
		f_attribute_add_attribute(pstr_attributes, "dosage_form", string(object.dosage_form[ll_row]))
		lstr_property_value.value = f_drug_treatment_sig(pstr_attributes)
		lstr_property_value.display_value = lstr_property_value.value
	CASE "drug_sig_full"
		f_attribute_add_attribute(pstr_attributes, "drug_id", string(object.drug_id[ll_row]))
		f_attribute_add_attribute(pstr_attributes, "package_id", string(object.package_id[ll_row]))
		f_attribute_add_attribute(pstr_attributes, "dose_amount", string(real(object.dose_amount[ll_row])))
		f_attribute_add_attribute(pstr_attributes, "dose_unit", string(object.dose_unit[ll_row]))
		f_attribute_add_attribute(pstr_attributes, "administer_frequency", string(object.administer_frequency[ll_row]))
		f_attribute_add_attribute(pstr_attributes, "duration_amount", string(real(object.duration_amount[ll_row])))
		f_attribute_add_attribute(pstr_attributes, "duration_unit", string(object.duration_unit[ll_row]))
		f_attribute_add_attribute(pstr_attributes, "duration_prn", string(object.duration_prn[ll_row]))
		f_attribute_add_attribute(pstr_attributes, "administration_sequence", string(integer(object.administration_sequence[ll_row])))
		f_attribute_add_attribute(pstr_attributes, "dosage_form", string(object.dosage_form[ll_row]))
		f_attribute_add_attribute(pstr_attributes, "pharmacist_instructions", get_property_value(pl_object_key, "pharmacist_instructions"))
		f_attribute_add_attribute(pstr_attributes, "patient_instructions", get_property_value(pl_object_key, "patient_instructions"))
		f_attribute_add_attribute(pstr_attributes, "dispense_amount", string(real(object.dispense_amount[ll_row])))
		f_attribute_add_attribute(pstr_attributes, "dispense_unit", string(object.dispense_unit[ll_row]))
		f_attribute_add_attribute(pstr_attributes, "refills", string(integer(object.refills[ll_row])))
		f_attribute_add_attribute(pstr_attributes, "brand_name_required", string(object.brand_name_required[ll_row]))
		lstr_property_value.value = f_drug_treatment_sig(pstr_attributes)
		lstr_property_value.display_value = lstr_property_value.value
	CASE "duration"
		lr_amount = object.duration_amount[ll_row]
		ls_unit = object.duration_unit[ll_row]
		ls_prn = object.duration_prn[ll_row]
		luo_unit = unit_list.find_unit(ls_unit)
		if isnull(luo_unit) then
			lstr_property_value.value = ls_prn
		else
			lstr_property_value.value = luo_unit.pretty_amount_unit(lr_amount)
		end if
		lstr_property_value.display_value = lstr_property_value.value
	CASE "last_ordered_by"
		// The last provider to order a refill will be the last_ordered_by provider.  If no refills have been ordered
		// then the last provider to sign for the prescription will be the last_ordered_by provider.  If no one
		// has signed for the prescription then the provider who originally ordered the prescription will
		// be the last_ordered_by provider.
		setnull(luo_user)
		li_sts = f_get_last_progress(current_patient.cpr_id, &
												'Treatment', &
												pl_object_key, &
												'Refill', &
												ls_null, &
												lstr_progress)
		if li_sts > 0 then
			luo_user = user_list.find_user(lstr_progress.user_id)
		else
			// If there were no refills then see who last signed for the prescription
			li_sts = f_get_last_progress(current_patient.cpr_id, &
													'Treatment', &
													pl_object_key, &
													'Attachment', &
													'Signature', &
													lstr_progress)
			if li_sts > 0 then
				// If someone signed then they ordered the prescriptino
				luo_user = user_list.find_user(lstr_progress.user_id)
			else
				// If no one signed then see who ordered the prescription
				luo_user = user_list.find_user(object.ordered_by[ll_row])
			end if
		end if
		if not isnull(luo_user) then
			lstr_property_value.value = luo_user.user_id
			lstr_property_value.display_value = luo_user.user_full_name
		end if
	CASE "office_dispense"
		lr_amount = object.office_dispense_amount[ll_row]
		ls_unit = object.dispense_unit[ll_row]
		luo_unit = unit_list.find_unit(ls_unit)
		if not isnull(luo_unit) then
			lstr_property_value.value = luo_unit.pretty_amount_unit(lr_amount)
			lstr_property_value.display_value = lstr_property_value.value
		end if
	CASE "followup_when", "referral_when"
		lr_duration_amount = object.duration_amount[ll_row]
		ls_duration_unit = object.duration_unit[ll_row]
		ls_duration_prn = object.duration_prn[ll_row]
		ldt_appointment_date_time = object.appointment_date_time[ll_row]
		
		lstr_property_value.value = f_appointment_string(ldt_appointment_date_time, lr_duration_amount, ls_duration_unit, ls_duration_prn)
		lstr_property_value.display_value = lstr_property_value.value
	CASE "appointment_date"
		ldt_appointment_date_time = object.appointment_date_time[ll_row]
		lstr_property_value.value = string(date(ldt_appointment_date_time))
		lstr_property_value.display_value = lstr_property_value.value
	CASE "appointment_time"
		ldt_appointment_date_time = object.appointment_date_time[ll_row]
		lstr_property_value.value = string(time(ldt_appointment_date_time), "hh:mm")
		lstr_property_value.display_value = lstr_property_value.value
	CASE ELSE
		lstr_property_value = get_property(pl_object_key, ps_property)
END CHOOSE

return lstr_property_value

end function

public function string treatment_drug_id (long pl_treatment_id);Long	ll_row
integer li_sts
String	ls_drug_id
string ls_find

setnull(ls_drug_id)

If isnull(pl_treatment_id) Then return ls_drug_id

ls_find = "treatment_id=" + string(pl_treatment_id)

ll_row = find(ls_find, 1, rowcount())
If ll_row > 0 Then
	ls_drug_id = object.drug_id[ll_row]
end if

return ls_drug_id

end function

public function integer add_followup_treatment_item (long pl_parent_treatment_id, string ps_treatment_type, string ps_description, str_attributes pstr_attributes);Long		ll_patient_workplan_id,ll_patient_workplan_item_id
Integer	i
String	ls_workplan_type,lc_followup_flag
datetime ldt_created
string ls_parent_treatment_type
long ll_new_treatment_id
long ll_null

setnull(ll_null)
setnull(ldt_created)

 DECLARE lsp_get_treatment_followup_workplan PROCEDURE FOR dbo.sp_get_treatment_followup_workplan
			@ps_cpr_id = :current_patient.cpr_id,
			@pl_treatment_id = :pl_parent_treatment_id,
			@pl_encounter_id = :current_patient.open_encounter.encounter_id,
			@ps_ordered_by = :current_user.user_id,
			@ps_created_by = :current_scribe.user_id,
			@ps_workplan_type = :ls_workplan_type,
			@pl_patient_workplan_id = :ll_patient_workplan_id OUT;


ls_parent_treatment_type = treatment_type(pl_parent_treatment_id)
if isnull(ls_parent_treatment_type) then
	log.log(this, "u_ds_treatment_item.add_followup_treatment_item:0024", "error getting treatment_type (" + string(pl_parent_treatment_id) + ")", 4)
	return -1
end if

lc_followup_flag = datalist.treatment_type_followup_flag(ls_parent_treatment_type)
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
	ll_new_treatment_id = sqlca.sp_set_treatment_followup_workplan_item( &
			current_patient.cpr_id, &
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

public function long order_treatment (string ps_cpr_id, long pl_encounter_id, string ps_treatment_type, string ps_treatment_desc, long pl_problem_id, boolean pb_past_treatment, string ps_user_id, long pl_parent_treatment_id, str_attributes pstr_attributes, boolean pb_do_autoperform);return order_treatment(ps_cpr_id, &
								pl_encounter_id, &
								ps_treatment_type, &
								ps_treatment_desc, &
								pl_problem_id, &
								pb_past_treatment, &
								ps_user_id, &
								pl_parent_treatment_id, &
								pstr_attributes, &
								pb_do_autoperform, &
								true)



end function

public function integer do_autoperform_services (long pl_treatment_id);///////////////////////////////////////////////////////////////////////////////////////////////////////
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

Long		ll_patient_workplan_item_id
string ls_service

DECLARE lsp_treatment_auto_perform_services PROCEDURE FOR dbo.sp_treatment_auto_perform_services
         @ps_cpr_id = :current_patient.cpr_id,   
         @pl_treatment_id = :pl_treatment_id,
			@ps_user_id = :current_user.user_id;

Setnull(ll_patient_workplan_item_id)
Execute lsp_treatment_auto_perform_services;
If not tf_check() Then Return -1

Fetch lsp_treatment_auto_perform_services into :ll_patient_workplan_item_id;
If not tf_check() Then Return -1
Close lsp_treatment_auto_perform_services;
If not tf_check() Then Return -1

If Not isnull(ll_patient_workplan_item_id) Then
	// Make sure the user is authorized to perform this service
	SELECT ordered_service
	INTO :ls_service
	FROM p_Patient_WP_Item
	WHERE patient_workplan_item_id = :ll_patient_workplan_item_id;
	if not tf_check() then return -1
	
	if user_list.is_user_authorized(current_user.user_id, ls_service, "Treatment") then
		service_list.do_service(ll_patient_workplan_item_id)
	end if
End If

Return 1

end function

public function long find_treatment (datetime pdt_begin_date, string ps_description);string ls_treatment_type

setnull(ls_treatment_type)

return find_treatment(ls_treatment_type, pdt_begin_date, ps_description)

end function

public function long find_treatment (str_treatment_description pstr_treatment);long ll_row
string ls_find
string ls_find_date
string ls_find_other
string ls_find2
long ll_treatment_id
string ls_date_from
string ls_date_to
boolean lb_c_object_present
long ll_rowcount
long ll_row2
boolean lb_found_multiple
long ll_treatment_date_match_range

//// If we don't have a begin_date or specimen_id then we're not even gonna bother
//if isnull(pstr_treatment.begin_date) and isnull(pstr_treatment.specimen_id) then 
//	setnull(ll_treatment_id)
//	return ll_treatment_id
//end if

ll_rowcount = rowcount()
lb_c_object_present = false

if isnull(pstr_treatment.begin_date) then
	ls_find_date = "(1=1)"
	ls_find = " and isnull(treatment_status)"
else
	// Search only on the date-part because sometimes the time isn't preserved
	ls_date_from = "date('" + string(pstr_treatment.begin_date, "[shortdate]") + "')"
	ll_treatment_date_match_range = datalist.get_preference_int("SYSTEM", "treatment_date_match_range", 2)
	if ll_treatment_date_match_range > 1 then
		ls_date_to = "date('" + string(relativedate(date(pstr_treatment.begin_date), ll_treatment_date_match_range)) + "')"
		ls_find_date = "(date(begin_date)>=" + ls_date_from + " AND date(begin_date)<=" + ls_date_to + ")"
	else
		ls_find_date = "(date(begin_date)=" + ls_date_from + ")"
	end if
end if

if len(pstr_treatment.observation_id) > 0 then
	ls_find += " and lower(observation_id)='" + lower(pstr_treatment.observation_id) + "'"
	lb_c_object_present = true
end if

if len(pstr_treatment.drug_id) > 0 then
	ls_find += " and lower(drug_id)='" + lower(pstr_treatment.drug_id) + "'"
	lb_c_object_present = true
end if

if len(pstr_treatment.procedure_id) > 0 then
	ls_find += " and lower(procedure_id)='" + lower(pstr_treatment.procedure_id) + "'"
	lb_c_object_present = true
end if

if len(ls_find) > 4 then
	ls_find = "(" + mid(ls_find, 5) + ")"
end if


ls_find_other = "("
ls_find_other += "(isnull(treatment_status) or upper(treatment_status) <> 'CANCELLED')"
if not isnull(pstr_treatment.treatment_type) then
	ls_find_other += " and lower(treatment_type)='" + lower(pstr_treatment.treatment_type) + "'"
end if
ls_find_other += ")"


lb_found_multiple = false

// First try to find it with the date and description
if not isnull(pstr_treatment.treatment_description) then
	ls_find2 = ls_find_date
	ls_find2 += " and " + ls_find
	ls_find2 += " and " + ls_find_other
	ls_find2 += " and lower(left(treatment_description, 80))='" + lower(left(pstr_treatment.treatment_description, 80)) + "'"
	ll_row = find(ls_find2, 1, ll_rowcount)
	if ll_row > 0 then
		// Make sure there isn't another one
		ll_row2 = find(ls_find2, ll_row + 1, ll_rowcount + 1)
		if ll_row2 > 0 and ll_row2 <= ll_rowcount then
			lb_found_multiple = true
		else
			ll_treatment_id = object.treatment_id[ll_row]
			return ll_treatment_id
		end if
	end if
end if

// If we didn't find it with the description and we have at least one
// c-object present, then try to find the treatment without the description
if lb_c_object_present then
	lb_found_multiple = false
	ls_find2 = ls_find_date
	ls_find2 += " and " + ls_find
	ls_find2 += " and " + ls_find_other
	ll_row = find(ls_find2, 1, ll_rowcount)
	if ll_row > 0 then
		// Make sure there isn't another one
		ll_row2 = find(ls_find2, ll_row + 1, ll_rowcount + 1)
		if ll_row2 > 0 and ll_row2 <= ll_rowcount then
			lb_found_multiple = true
		else
			ll_treatment_id = object.treatment_id[ll_row]
			return ll_treatment_id
		end if
	end if
	
	// If we don't have a distinct treatment, try using the specimen_id
	if lb_found_multiple and not isnull(pstr_treatment.specimen_id) then
		ls_find2 += " and lower(specimen_id)='" + lower(pstr_treatment.specimen_id) + "'"
		ll_row = find(ls_find2, 1, ll_rowcount)
		if ll_row > 0 then
			// Make sure there isn't another one
			ll_row2 = find(ls_find2, ll_row + 1, ll_rowcount + 1)
			if ll_row2 > 0 and ll_row2 <= ll_rowcount then
				lb_found_multiple = true
			else
				ll_treatment_id = object.treatment_id[ll_row]
				return ll_treatment_id
			end if
		end if
	end if
end if

// If we still don't have a match but we have a specimen_id, try it without the date
if lb_c_object_present and not isnull(pstr_treatment.specimen_id) then
	ls_find2 = ls_find
	ls_find2 += " and lower(specimen_id)='" + lower(pstr_treatment.specimen_id) + "'"
	ls_find2 += " and " + ls_find_other
	ll_row = find(ls_find2, 1, ll_rowcount)
	if ll_row > 0 then
		// Make sure there isn't another one
		ll_row2 = find(ls_find2, ll_row + 1, ll_rowcount + 1)
		if ll_row2 > 0 and ll_row2 <= ll_rowcount then
			lb_found_multiple = true
		else
			ll_treatment_id = object.treatment_id[ll_row]
			return ll_treatment_id
		end if
	end if
end if


setnull(ll_treatment_id)
return ll_treatment_id


end function

public function string treatment_observation_id (long pl_treatment_id);Long	ll_row
integer li_sts
String	ls_observation_id
string ls_find

setnull(ls_observation_id)

If isnull(pl_treatment_id) Then return ls_observation_id

ls_find = "treatment_id=" + string(pl_treatment_id)

ll_row = find(ls_find, 1, rowcount())
If ll_row > 0 Then
	ls_observation_id = object.observation_id[ll_row]
end if

return ls_observation_id

end function

public function string treatment_procedure_id (long pl_treatment_id);Long	ll_row
integer li_sts
String	ls_procedure_id
string ls_find

setnull(ls_procedure_id)

If isnull(pl_treatment_id) Then return ls_procedure_id

ls_find = "treatment_id=" + string(pl_treatment_id)

ll_row = find(ls_find, 1, rowcount())
If ll_row > 0 Then
	ls_procedure_id = object.procedure_id[ll_row]
end if

return ls_procedure_id

end function

public function long new_treatment (ref str_treatment_description pstr_treatment);Integer 	li_sts
Integer 	i
long		ll_row,ll_null
long 		ll_ordered_patient_workplan_id
long 		ll_followup_patient_workplan_id
long 		ll_problem_id
long 		ll_at_row,ll_rowcount
long 		ll_sort_sequence
long 		ll_workplan_id
string ls_procedure_id

String 	ls_component_id
String 	ls_description
String 	ls_in_office_flag
String 	ls_treatment_in_office_flag
String 	ls_define_title
String 	ls_button
String 	ls_icon
String 	ls_followup_flag
String 	ls_observation_type
String 	ls_workplan_close_flag
String 	ls_workplan_cancel_flag
String 	ls_status
string ls_check_cpr_id
string ls_check_treatment_type
string ls_ordered_for
long ll_parent_patient_workplan_item_id
long ll_real_treatment_id
string ls_progress_user_id
string ls_null
datetime ldt_null
str_attributes lstr_treatment_attributes

setnull(ls_null)
setnull(ldt_null)
setnull(ls_ordered_for)
setnull(ll_parent_patient_workplan_item_id)

Setnull(ll_null)

if isnull(pstr_treatment.open_encounter_id) then
	if isnull(current_patient.open_encounter) then
		openwithparm(w_pop_message, "You may not create a new treatment without an encounter context")
		return -1
	else
		pstr_treatment.open_encounter_id = current_patient.open_encounter.encounter_id
	end if
end if

// Make sure the begin date is set
If isnull(pstr_treatment.begin_date) Then pstr_treatment.begin_date = datetime(today(), now())

// Enforce character limits on freeform fields
pstr_treatment.duration_prn = left(pstr_treatment.duration_prn, 32)


f_attribute_add_attribute(lstr_treatment_attributes, "package_id", pstr_treatment.package_id   )
f_attribute_add_attribute(lstr_treatment_attributes, "specialty_id", pstr_treatment.specialty_id)
f_attribute_add_attribute(lstr_treatment_attributes, "procedure_id", pstr_treatment.procedure_id)
f_attribute_add_attribute(lstr_treatment_attributes, "drug_id", pstr_treatment.drug_id)
f_attribute_add_attribute(lstr_treatment_attributes, "observation_id", pstr_treatment.observation_id)
f_attribute_add_attribute(lstr_treatment_attributes, "administration_sequence", string(pstr_treatment.administration_sequence   ))
f_attribute_add_attribute(lstr_treatment_attributes, "dose_amount", string(pstr_treatment.dose_amount   ))
f_attribute_add_attribute(lstr_treatment_attributes, "dose_unit", pstr_treatment.dose_unit   )
f_attribute_add_attribute(lstr_treatment_attributes, "administer_frequency", pstr_treatment.administer_frequency   )
f_attribute_add_attribute(lstr_treatment_attributes, "duration_amount", string(pstr_treatment.duration_amount))
f_attribute_add_attribute(lstr_treatment_attributes, "duration_unit", pstr_treatment.duration_unit)
f_attribute_add_attribute(lstr_treatment_attributes, "duration_prn", pstr_treatment.duration_prn)
f_attribute_add_attribute(lstr_treatment_attributes, "dispense_amount", string(pstr_treatment.dispense_amount   ))
f_attribute_add_attribute(lstr_treatment_attributes, "office_dispense_amount", string(pstr_treatment.office_dispense_amount))
f_attribute_add_attribute(lstr_treatment_attributes, "dispense_unit", pstr_treatment.dispense_unit   )
f_attribute_add_attribute(lstr_treatment_attributes, "brand_name_required", pstr_treatment.brand_name_required   )
f_attribute_add_attribute(lstr_treatment_attributes, "refills", string(pstr_treatment.refills   ))
//f_attribute_add_attribute(lstr_treatment_attributes, "treatment_goal", pstr_treatment.treatment_goal   )
f_attribute_add_attribute(lstr_treatment_attributes, "location", pstr_treatment.location)
f_attribute_add_attribute(lstr_treatment_attributes, "maker_id", pstr_treatment.maker_id)
f_attribute_add_attribute(lstr_treatment_attributes, "lot_number", pstr_treatment.lot_number)
//f_attribute_add_attribute(lstr_treatment_attributes, "send_out_flag", pstr_treatment.send_out_flag)
//f_attribute_add_attribute(lstr_treatment_attributes, "attach_flag", pstr_treatment.attach_flag)
//f_attribute_add_attribute(lstr_treatment_attributes, "referral_question", pstr_treatment.referral_question)
//f_attribute_add_attribute(lstr_treatment_attributes, "referral_question_assmnt_id", pstr_treatment.referral_question_assmnt_id)
f_attribute_add_attribute(lstr_treatment_attributes, "material_id", string(pstr_treatment.material_id))
f_attribute_add_attribute(lstr_treatment_attributes, "expiration_date", string(pstr_treatment.expiration_date))
f_attribute_add_attribute(lstr_treatment_attributes, "specimen_id", pstr_treatment.specimen_id)
f_attribute_add_attribute(lstr_treatment_attributes, "ordered_by_supervisor", pstr_treatment.ordered_by_supervisor)
f_attribute_add_attribute(lstr_treatment_attributes, "appointment_date_time", string(pstr_treatment.appointment_date_time))
f_attribute_add_attribute(lstr_treatment_attributes, "ordered_for", pstr_treatment.ordered_for)


ll_row = new_treatment_record(parent_patient.cpr_id   , &
										pstr_treatment.open_encounter_id   , &
										pstr_treatment.treatment_type, &
										pstr_treatment.treatment_mode, &
										pstr_treatment.begin_date   , &
										pstr_treatment.end_date, &
										pstr_treatment.treatment_description, &
										ll_null, &
										pstr_treatment.parent_treatment_id, &
										pstr_treatment.ordered_by, &
										current_scribe.user_id, &
										ls_null, &
										pstr_treatment.treatment_status, &
										lstr_treatment_attributes )
if ll_row <= 0 then return -1

// Make sure we had a treatment_id generated
pstr_treatment.treatment_id = object.treatment_id[ll_row]
If isnull(pstr_treatment.treatment_id) Then
	log.log(this, "u_ds_treatment_item.new_treatment:0109", "treatment_id not generated", 4)
	Return -1
End if

for i = 1 to pstr_treatment.problem_count
	set_treatment_assessment(pstr_treatment.treatment_id, pstr_treatment.problem_ids[i], true)
next

// IF the treatment is a past treatment then just order an associated workplan
ls_in_office_flag = "N"

// Close the treatment if there's and end date
if not isnull(pstr_treatment.end_date) or (lower(pstr_treatment.treatment_status) = "closed") then
	if isnull(pstr_treatment.end_date) then pstr_treatment.end_date = pstr_treatment.begin_date
	if isnull(pstr_treatment.completed_by) then
		if isnull(pstr_treatment.ordered_by) then
			ls_progress_user_id = current_user.user_id
		else
			ls_progress_user_id = pstr_treatment.ordered_by
		end if
	else
		ls_progress_user_id = pstr_treatment.completed_by
	end if
	
	sqlca.sp_set_treatment_progress( current_patient.cpr_id, &
												pstr_treatment.treatment_id, &
												pstr_treatment.open_encounter_id, &
												"Closed", &
												ls_null, &
												ls_null, &
												pstr_treatment.end_date, &
												ll_null, &
												ll_null, &
												ll_null, &
												ls_progress_user_id, &
												current_scribe.user_id)
	if not tf_check() then return -1
	reselectrow(ll_row)
	cache_valid[ll_row] = false
	pstr_treatment.treatment_status = "Closed"
end if

// Get the list of associated assessments
pstr_treatment.problem_count = get_treatment_assessments(pstr_treatment.treatment_id, pstr_treatment.problem_ids)

Return pstr_treatment.treatment_id


end function

public function integer refresh_treatment_object (ref u_component_treatment puo_treatment, long pl_row);integer li_sts
Integer				li_attachment_sequence
u_attachment_list luo_attachment_list
integer li_count
string ls_treatment_description

If not Isvalid(puo_treatment) or Isnull(puo_treatment) Then
	log.log(this, "u_ds_treatment_item.refresh_treatment_object:0008", "Invalid treatment object", 4)
	return -1
end if

If isnull(pl_row) or pl_row <= 0 Then
	Return 0
End if

puo_treatment.treatment_id = object.treatment_id[pl_row]
puo_treatment.open_encounter_id = object.open_encounter_id[pl_row]
puo_treatment.treatment_type = object.treatment_type[pl_row]
puo_treatment.package_id = object.package_id[pl_row]
puo_treatment.specialty_id = object.specialty_id[pl_row]
puo_treatment.procedure_id = object.procedure_id[pl_row]
puo_treatment.drug_id = object.drug_id[pl_row]
puo_treatment.observation_id = object.observation_id[pl_row]
// Check for previous bug that set observation_id to empty string
if trim(puo_treatment.observation_id) = "" then setnull(puo_treatment.observation_id)
puo_treatment.begin_date = object.begin_date[pl_row]
puo_treatment.administration_sequence = object.administration_sequence[pl_row]
puo_treatment.dose_amount = object.dose_amount[pl_row]
puo_treatment.dose_unit = object.dose_unit[pl_row]
puo_treatment.administer_frequency = object.administer_frequency[pl_row]
puo_treatment.duration_amount = object.duration_amount[pl_row]
puo_treatment.duration_unit = object.duration_unit[pl_row]
puo_treatment.duration_prn = object.duration_prn[pl_row]
puo_treatment.dispense_amount = object.dispense_amount[pl_row]
puo_treatment.office_dispense_amount = object.office_dispense_amount[pl_row]
puo_treatment.dispense_unit = object.dispense_unit[pl_row]
puo_treatment.brand_name_required = object.brand_name_required[pl_row]
puo_treatment.refills = object.refills[pl_row]
puo_treatment.treatment_description = object.treatment_description[pl_row]
puo_treatment.treatment_goal = object.treatment_goal[pl_row]
puo_treatment.location = object.location[pl_row]
puo_treatment.maker_id = object.maker_id[pl_row]
// Check for previous bug that set maker_id to empty string
if trim(puo_treatment.maker_id) = "" then setnull(puo_treatment.maker_id)
puo_treatment.lot_number = object.lot_number[pl_row]
// Check for previous bug that set lot_number to empty string
if trim(puo_treatment.lot_number) = "" then setnull(puo_treatment.lot_number)
puo_treatment.expiration_date = object.expiration_date[pl_row]
puo_treatment.treatment_office_id = object.office_id[pl_row]
puo_treatment.send_out_flag = object.send_out_flag[pl_row]
puo_treatment.original_treatment_id = object.original_treatment_id[pl_row]
puo_treatment.parent_treatment_id = object.parent_treatment_id[pl_row]
puo_treatment.attach_flag = object.attach_flag[pl_row]
puo_treatment.referral_question = object.referral_question[pl_row]
puo_treatment.referral_question_assmnt_id = object.referral_question_assmnt_id[pl_row]
puo_treatment.ordered_by = object.ordered_by[pl_row]
puo_treatment.created = object.created[pl_row]
puo_treatment.created_by = object.created_by[pl_row]
puo_treatment.specimen_id = object.specimen_id[pl_row]

puo_treatment.ordered_by_supervisor = object.ordered_by_supervisor[pl_row]
puo_treatment.appointment_date_time = object.appointment_date_time[pl_row]
puo_treatment.ordered_for = object.ordered_for[pl_row]


// Calculated fields
puo_treatment.treatment_status = object.treatment_status[pl_row]
puo_treatment.end_date = object.end_date[pl_row]
puo_treatment.close_encounter_id = object.close_encounter_id[pl_row]
// Patient material attributes
puo_treatment.material_id = object.material_id[pl_row]
puo_treatment.treatment_mode = object.treatment_mode[pl_row]

// If there are any properties of this treatment object which are not on the p_treatment_item
// record, then get them here as properties
CHOOSE CASE upper(puo_treatment.treatment_type)
	CASE "MEDICATION", "OFFICEMED"
		puo_treatment.dosage_form = f_get_progress_value(current_patient.cpr_id, &
														"Treatment", &
														puo_treatment.treatment_id, &
														"Property", &
														"dosage_form")
END CHOOSE

puo_treatment.parent_patient = parent_patient

// if the treatment description is 80 characters then it might actually be longer,
// so get complete description from the progress table
if len(puo_treatment.treatment_description) = 80 then
	ls_treatment_description = f_get_progress_value(current_patient.cpr_id, &
											"Treatment", &
											puo_treatment.treatment_id, &
											"Modify", &
											"treatment_description")
	if left(ls_treatment_description, 80) = puo_treatment.treatment_description then
		puo_treatment.treatment_description = ls_treatment_description
	end if
end if

// get all the treatment attachments
parent_patient.attachments.treatment_attachment_list(puo_treatment.attachment_list, puo_treatment.treatment_id)

// Get the treatment_key
puo_treatment.treatment_key = get_treatment_key(pl_row)

// Get the list of associated assessments
puo_treatment.problem_count = get_treatment_assessments(puo_treatment.treatment_id, puo_treatment.problem_ids)

// Determine if this is a past treatment
if not isnull(puo_treatment.treatment_status) then
	puo_treatment.past_treatment = true
elseif not current_patient.encounters.is_encounter_open(puo_treatment.open_encounter_id) then
	puo_treatment.past_treatment = true
elseif puo_treatment.begin_date < current_patient.encounters.encounter_date(puo_treatment.open_encounter_id) then
	puo_treatment.past_treatment = true
else
	puo_treatment.past_treatment = false
end if

puo_treatment.exists = true
puo_treatment.updated = false
puo_treatment.deleted = false

li_sts = puo_treatment.load_observations()
if li_sts < 0 then return -1

return 1

end function

public function integer treatment_update_if_modified (ref u_component_treatment puo_treatment);Long	ll_row
integer li_sts
string ls_current_status
String ls_find

If Isvalid(puo_treatment) And Not Isnull(puo_treatment) Then return 0

If isnull(puo_treatment.treatment_id) Then return 0

ls_current_status = treatment_status(puo_treatment.treatment_id)

// If the treatment isn't modified then just return
if isnull(ls_current_status) OR upper(ls_current_status) <> "MODIFIED" then return 0

ls_find = "original_treatment_id=" + string(puo_treatment.treatment_id)
ls_find += " and ( isnull(treatment_status) or lower(treatment_status) <> 'cancelled' )"
ll_row = find(ls_find, 1, rowcount())
If ll_row > 0 Then
	return refresh_treatment_object(puo_treatment, ll_row)
End if

return 0


end function

private function string get_treatment_key (long pl_row);string ls_treatment_type
string ls_treatment_key_field
boolean lb_found
integer i
string ls_treatment_key
string ls_null
string ls_coltype

setnull(ls_null)

if isnull(pl_row) or pl_row <= 0 then return ls_null

ls_treatment_type = upper(object.treatment_type[pl_row])

lb_found = false
for i = 1 to treatment_type_key_count
	if treatment_type_key[i].treatment_type = ls_treatment_type then
		lb_found = true
		ls_treatment_key_field = treatment_type_key[i].treatment_key_field
		exit
	end if
next

// If we didn't find it in the cache then query the database
if not lb_found then
	ls_treatment_key_field = sqlca.fn_treatment_type_treatment_key(ls_treatment_type)
	if not tf_check() then return ls_null
	
	if len(ls_treatment_key_field) > 0 then
		// Save it in the cache
		treatment_type_key_count += 1
		treatment_type_key[treatment_type_key_count].treatment_type = ls_treatment_type
		treatment_type_key[treatment_type_key_count].treatment_key_field = ls_treatment_key_field
	else
		return ls_null
	end if
end if


ls_coltype = describe(ls_treatment_key_field + ".ColType")
CHOOSE CASE lower(left(ls_coltype, 5))
	CASE "char ", "char("
		ls_treatment_key = getitemstring(pl_row, ls_treatment_key_field)
	CASE "date"
		ls_treatment_key = string(getitemdate(pl_row, ls_treatment_key_field))
	CASE "datet"
		ls_treatment_key = string(getitemdatetime(pl_row, ls_treatment_key_field))
	CASE "decim"
		ls_treatment_key = string(getitemdecimal(pl_row, ls_treatment_key_field))
	CASE "int"
		ls_treatment_key = string(getitemnumber(pl_row, ls_treatment_key_field))
	CASE "long"
		ls_treatment_key = string(getitemnumber(pl_row, ls_treatment_key_field))
	CASE "numbe"
		ls_treatment_key = string(getitemnumber(pl_row, ls_treatment_key_field))
	CASE "real"
		ls_treatment_key = string(getitemnumber(pl_row, ls_treatment_key_field))
	CASE "time"
		ls_treatment_key = string(getitemtime(pl_row, ls_treatment_key_field))
	CASE "times"
		ls_treatment_key = string(getitemtime(pl_row, ls_treatment_key_field))
	CASE "ulong"
		ls_treatment_key = string(getitemnumber(pl_row, ls_treatment_key_field))
END CHOOSE

return ls_treatment_key

end function

public function long treatment_open_encounter_id (long pl_treatment_id);Long	ll_row
integer li_sts
string ls_find
long ll_open_encounter_id

setnull(ll_open_encounter_id)

If isnull(pl_treatment_id) Then return ll_open_encounter_id

ls_find = "treatment_id=" + string(pl_treatment_id)

ll_row = find(ls_find, 1, rowcount())
If ll_row > 0 Then
	ll_open_encounter_id = object.open_encounter_id[ll_row]
end if

return ll_open_encounter_id

end function

public function integer get_assessment_treatments (long pl_problem_id, long pl_encounter_id, boolean pb_only_attached_treatments, ref str_treatment_description pstra_treatments[]);long ll_row
Integer	li_count
long ll_at_count
integer li_e_count
string ls_find
str_treatment_description lstra_treatments[]
integer i, j
str_assessment_description lstr_assessment
integer li_sts
boolean lb_found
long ll_rowcount

ll_rowcount = rowcount()

ll_at_count = p_Assessment_Treatment.rowcount()
li_count = 0

// First get the treatments in the encounter
li_e_count = get_encounter_treatments(pl_encounter_id, lstra_treatments)

// Now, find the ones which are in the specified assessment
for i = 1 to li_e_count
	ls_find = "problem_id=" + string(pl_problem_id)
	ls_find += " and treatment_id=" + string(lstra_treatments[i].treatment_id)
	
	ll_row = p_Assessment_Treatment.find(ls_find, 1, ll_at_count)
	if ll_row > 0 then
		li_count += 1
		pstra_treatments[li_count] = lstra_treatments[i]
	end if
next

if not pb_only_attached_treatments then
	li_sts = current_patient.assessments.assessment(lstr_assessment, pl_problem_id)
	if li_sts <= 0 then return li_count

	for i = 1 to li_e_count
		if lstra_treatments[i].begin_date < lstr_assessment.begin_date then continue
		
		if lstra_treatments[i].begin_date > lstr_assessment.end_date then continue
		
		// Make sure we didn't already get this treatment
		lb_found = false
		for j = 1 to li_count
			if lstra_treatments[i].treatment_id = pstra_treatments[j].treatment_id then
				lb_found = true
				exit
			end if
		next
		
		if not lb_found then
			li_count += 1
			pstra_treatments[li_count] = lstra_treatments[i]
		end if
	next
end if

return li_count

end function

public function integer get_assessment_treatments (long pl_problem_id, boolean pb_only_attached_treatments, ref str_treatment_description pstra_treatments[]);long i
Long		ll_rowcount, ll_row = 1
Integer	li_count
long ll_at_count
long ll_treatment_id
string ls_find_problem
string ls_find
long ll_problem_row
string ls_treatment_status
str_assessment_description lstr_assessment
integer li_sts
string ls_date
boolean lb_found

ll_rowcount = rowcount()
ll_at_count = p_Assessment_Treatment.rowcount()
li_count = 0

ls_find_problem = "problem_id=" + string(pl_problem_id)

// Loop through all the treatments attached to this assessment
ll_problem_row = p_Assessment_Treatment.find(ls_find_problem, 1, ll_at_count)
DO WHILE ll_problem_row > 0 and ll_problem_row <= ll_at_count
	ll_treatment_id = p_Assessment_Treatment.object.treatment_id[ll_problem_row]
	
	ls_find = "treatment_id=" + string(ll_treatment_id)
	ll_row = find(ls_find, 1, ll_rowcount)
	if ll_row > 0 then
		ls_treatment_status = object.treatment_status[ll_row]
		if isnull(ls_treatment_status) or ls_treatment_status <> "CANCELLED" then 
			li_count += 1
			pstra_treatments[li_count] = get_treatment(ll_row)
		end if
	end if
	
	ll_problem_row = p_Assessment_Treatment.find(ls_find_problem, ll_problem_row + 1, ll_at_count + 1)
LOOP

if not pb_only_attached_treatments then
	li_sts = current_patient.assessments.assessment(lstr_assessment, pl_problem_id)
	if li_sts <= 0 then return li_count
	
	ls_date = "datetime('" + string(lstr_assessment.begin_date, "[shortdate] [time]") + "')"
	ls_find = "begin_date >= " + ls_date
	
	if not isnull(lstr_assessment.end_date) then
		ls_date = "datetime('" + string(lstr_assessment.end_date, "[shortdate] [time]") + "')"
		ls_find = " and begin_date <= " + ls_date
	end if
	
	ll_row = find(ls_find, 1, ll_rowcount)
	DO WHILE ll_row > 0 and ll_row <= ll_rowcount
		ll_treatment_id = object.treatment_id[ll_row]
		ls_treatment_status = object.treatment_status[ll_row]
		if isnull(ls_treatment_status) or ls_treatment_status <> "CANCELLED" then 
			
			// Make sure we didn't already get this treatment
			lb_found = false
			for i = 1 to li_count
				if ll_treatment_id = pstra_treatments[i].treatment_id then
					lb_found = true
					exit
				end if
			next
			
			if not lb_found then
				li_count += 1
				pstra_treatments[li_count] = get_treatment(ll_row)
			end if
		end if

	ll_row = find(ls_find, ll_row + 1, ll_rowcount + 1)
	LOOP
end if

return li_count

end function

public function str_treatment_description get_treatment (long pl_row);string ls_description
integer li_sts
boolean lb_default_grant

if cache_valid[pl_row] then return cache[pl_row]

cache[pl_row] = f_empty_treatment()

if isnull(pl_row) or pl_row <= 0 or pl_row > rowcount() then
	setnull(cache[pl_row].treatment_id)
else
	cache[pl_row].treatment_id = object.treatment_id[pl_row]
	cache[pl_row].treatment_type = object.treatment_type[pl_row]
	cache[pl_row].treatment_description = object.treatment_description[pl_row]
	cache[pl_row].begin_date = object.begin_date[pl_row]
	cache[pl_row].end_date = object.end_date[pl_row]
	cache[pl_row].treatment_status = object.treatment_status[pl_row]
	cache[pl_row].open_encounter_id = object.open_encounter_id[pl_row]
	cache[pl_row].close_encounter_id = object.close_encounter_id[pl_row]
	cache[pl_row].parent_treatment_id = object.parent_treatment_id[pl_row]
	cache[pl_row].observation_id = object.observation_id[pl_row]
	// Check for previous bug that set observation_id to empty string
	if trim(cache[pl_row].observation_id) = "" then setnull(cache[pl_row].observation_id)
	cache[pl_row].drug_id = object.drug_id[pl_row]
	cache[pl_row].package_id = object.package_id[pl_row]
	cache[pl_row].specialty_id = object.specialty_id[pl_row]
	cache[pl_row].procedure_id = object.procedure_id[pl_row]
	cache[pl_row].location = object.location[pl_row]
	cache[pl_row].ordered_by = object.ordered_by[pl_row]
	cache[pl_row].material_id = object.material_id[pl_row]
	cache[pl_row].treatment_mode = object.treatment_mode[pl_row]
	cache[pl_row].observation_type = object.observation_type[pl_row]
	cache[pl_row].created = object.created[pl_row]
	cache[pl_row].created_by = object.created_by[pl_row]

	
	cache[pl_row].dose_amount = object.dose_amount[pl_row]
	cache[pl_row].dose_unit = object.dose_unit[pl_row]
	cache[pl_row].duration_amount = object.duration_amount[pl_row]
	cache[pl_row].duration_unit = object.duration_unit[pl_row]
	cache[pl_row].duration_prn = object.duration_prn[pl_row]
	cache[pl_row].dispense_amount = object.dispense_amount[pl_row]
	cache[pl_row].office_dispense_amount = object.office_dispense_amount[pl_row]
	cache[pl_row].dispense_unit = object.dispense_unit[pl_row]
	cache[pl_row].administration_sequence = object.administration_sequence[pl_row]
	cache[pl_row].administer_frequency = object.administer_frequency[pl_row]
	cache[pl_row].refills = object.refills[pl_row]
	cache[pl_row].brand_name_required = object.brand_name_required[pl_row]
	cache[pl_row].maker_id = object.maker_id[pl_row]
	cache[pl_row].lot_number = object.lot_number[pl_row]
	cache[pl_row].expiration_date = object.expiration_date[pl_row]
	cache[pl_row].specimen_id = object.specimen_id[pl_row]
	cache[pl_row].ordered_by_supervisor = object.ordered_by_supervisor[pl_row]
	cache[pl_row].appointment_date_time = object.appointment_date_time[pl_row]
	cache[pl_row].ordered_for = object.ordered_for[pl_row]
	cache[pl_row].completed_by = object.completed_by[pl_row]
	
	cache[pl_row].treatment_key = get_treatment_key(pl_row)
	
	cache[pl_row].problem_count = get_treatment_assessments(cache[pl_row].treatment_id, cache[pl_row].problem_ids)
	
	// if the treatment description is 80 characters long then it may be more, so get the 
	// progress record if there is one
	if len(cache[pl_row].treatment_description) = 80 then
		ls_description = f_get_progress_value(current_patient.cpr_id, &
												"Treatment", &
												cache[pl_row].treatment_id, &
												"Modify", &
												"treatment_description")
		if left(ls_description, 80) = cache[pl_row].treatment_description then
			cache[pl_row].treatment_description = ls_description
		end if
	end if
	
	if int(object.default_grant[pl_row]) = 0 then
		lb_default_grant = false
	else
		lb_default_grant = true
	end if
	cache[pl_row].access_control_list = current_patient.get_access_control_list( "Treatment", &
																											cache[pl_row].treatment_id, &
																											lb_default_grant)
	
	// Determine the dispatch_encounter_id
	if isnull(cache[pl_row].parent_treatment_id) then
		// If this is not a child treatment then the treatment was dispatched when it was ordered, so save the query to the database by assuming that
		cache[pl_row].dispatch_encounter_id = cache[pl_row].open_encounter_id
	else
		SELECT max(w.encounter_id)
		INTO :cache[pl_row].dispatch_encounter_id
		FROM p_Patient_WP w
		WHERE cpr_id = :current_patient.cpr_id
		AND treatment_id = :cache[pl_row].treatment_id
		AND workplan_type = 'Treatment';
		tf_check()
	end if
	
	cache_valid[pl_row] = true
end if

return cache[pl_row]


end function

public function integer initialize (string ps_cpr_id, long pl_treatment_id);long ll_count
integer li_sts
string ls_at_dataobject

cpr_id = ps_cpr_id

if isnull(pl_treatment_id) then
	ls_at_dataobject = "dw_assessment_treatment_data"
else
	ls_at_dataobject = "dw_assessment_treatment_data_1"
end if

if not isvalid(p_Assessment_Treatment) then
	p_Assessment_Treatment = CREATE u_ds_data
	p_Assessment_Treatment.set_dataobject(ls_at_dataobject)
end if

if p_Assessment_Treatment.dataobject <> ls_at_dataobject then
	p_Assessment_Treatment.set_dataobject(ls_at_dataobject)
end if	

if isnull(pl_treatment_id) then
	ll_count = retrieve(ps_cpr_id)
	if ll_count < 0 then return ll_count
	li_sts = p_Assessment_Treatment.retrieve(ps_cpr_id)
else
	if rowcount() < 1 then
		li_sts = insertrow(0)
		if li_sts < 0 then return -1
	end if
	object.cpr_id[1] = ps_cpr_id
	object.treatment_id[1] = pl_treatment_id
	li_sts = reselectrow(1)
	if li_sts <= 0 then
		log.log(this, "u_ds_treatment_item.initialize:0035", "Reselect treatment data failed", 4)
		return -1
	end if
	li_sts = p_Assessment_Treatment.retrieve(ps_cpr_id, pl_treatment_id)
end if


return ll_count


end function

public function integer get_encounter_treatments (long pl_encounter_id, boolean pb_show_deleted, ref str_treatment_description pstra_treatments[]);Long		ll_rowcount
//long ll_row = 1
//Integer	li_count
//string ls_find
//string ls_date
//string ls_in_office_flag
//string ls_treatment_status
//long ll_open_encounter_id
//str_encounter_description  lstr_encounter
integer li_sts
u_ds_data luo_data
string ls_include_deleted
long ll_treatment_id
long i

if isnull(pl_encounter_id) then return 0

if pb_show_deleted then
	ls_include_deleted = "Y"
else
	ls_include_deleted = "N"
end if

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_jmj_get_encounter_treatments")
ll_rowcount = luo_data.retrieve(current_patient.cpr_id, pl_encounter_id, ls_include_deleted)
if ll_rowcount <= 0 then return 0

for i = 1 to ll_rowcount
	ll_treatment_id = luo_data.object.treatment_id[i]
	li_sts = treatment(pstra_treatments[i], ll_treatment_id)
	if li_sts <= 0 then
		log.log(this, "u_ds_treatment_item.get_encounter_treatments:0033", "Error getting treatment details (" + current_patient.cpr_id + ", " + string(ll_treatment_id) + ")", 4)
		return -1
	end if
next

return ll_rowcount

//li_sts = current_patient.encounters.encounter(lstr_encounter, pl_encounter_id)
//if li_sts <= 0 then return 0
//
//// Get all treatments which should display in this encounter
//ls_date = "datetime('" + string(lstr_encounter.encounter_date, "[shortdate] [time]") + "')"
//
//ls_find = "((open_encounter_id=" + string(lstr_encounter.encounter_id) + ")"
//ls_find += " or (begin_date<=" + ls_date + " and (isnull(end_date) or end_date>=" + ls_date + "))"
//ls_find += " or (close_encounter_id=" + string(lstr_encounter.encounter_id) + ") )"
//
//// Add a clause to remove treatments which were modified in this encounter
//ls_find += " and not (close_encounter_id=" + string(lstr_encounter.encounter_id)
//ls_find +=          " and lower(treatment_status)='modified' )"
//
//ll_rowcount = rowcount()
//ll_row = 0
//
//DO WHILE true
//	// Get the next row
//	ll_row = Find(ls_find, ll_row + 1, ll_rowcount + 1)
//	if ll_row <= 0 or ll_row > ll_rowcount then exit
//	
//	// Get some properties of the treatment
//	ls_in_office_flag = object.in_office_flag[ll_row]
//	ll_open_encounter_id = object.open_encounter_id[ll_row]
//	ls_treatment_status = object.treatment_status[ll_row]
//	
//	// Now apply some extra logic:
//	
//	// Don't show in-office treatments unless they were opened in this encounter
//	if ls_in_office_flag = "Y" and ll_open_encounter_id <> pl_encounter_id then continue
//	
//	// Don't show cancelled treatments that were opened in this encounter
//	if upper(ls_treatment_status) = "CANCELLED" and not pb_show_deleted then continue
//	
//	li_count++
//	pstra_treatments[li_count] = get_treatment(ll_row)
//
//LOOP
//
//return li_count
//
end function

public function long find_treatment (string ps_treatment_type, datetime pdt_begin_date, string ps_description);long ll_row
string ls_find
long ll_treatment_id
string ls_date

ls_date = "datetime('" + string(pdt_begin_date, "[shortdate] [time]") + "')"

ls_find = "begin_date = " + ls_date
ls_find += " and left(lower(treatment_description), 80)='" + left(lower(ps_description), 80) + "'"

if len(ps_treatment_type) > 0 then
	ls_find += " and lower(treatment_type)='" + lower(ps_treatment_type) + "'"
end if

ll_row = find(ls_find, 1, rowcount())
if ll_row > 0 then
	ll_treatment_id = object.treatment_id[ll_row]
else
	setnull(ll_treatment_id)
end if


return ll_treatment_id


end function

public function long order_treatment (str_assessment_treatment_definition pstr_treatment_def, boolean pb_past_treatment);long ll_treatment_id
integer li_sts
boolean lb_get_treatment_dates
boolean lb_do_autoperform

// make sure followup_workplan_id is in the attributes
if pstr_treatment_def.followup_workplan_id > 0 then
	f_attribute_add_attribute(pstr_treatment_def.attributes, "followup_workplan_id", String(pstr_treatment_def.followup_workplan_id))
end if

if not isnull(pstr_treatment_def.begin_date) then
	f_attribute_add_attribute(pstr_treatment_def.attributes, "begin_date", string(pstr_treatment_def.begin_date))
end if

if not isnull(pstr_treatment_def.end_date) then
	f_attribute_add_attribute(pstr_treatment_def.attributes, "end_date", string(pstr_treatment_def.end_date))
end if


// Don't autoperform for assessment treatments because the assessment-treatment screen will do them later
lb_do_autoperform = false

// Don't get the treatment dates for past treatments because the assessment-treatment screen has already done that
lb_get_treatment_dates = false

// now order the treatment
ll_treatment_id = current_patient.treatments.order_treatment(current_patient.cpr_id, &
																				pstr_treatment_def.open_encounter_id, &
																				pstr_treatment_def.treatment_type, &
																				pstr_treatment_def.treatment_description, &
																				pstr_treatment_def.problem_id, &
																				pb_past_treatment, &
																				current_user.user_id, &
																				0, &
																				pstr_treatment_def.attributes, &
																				lb_do_autoperform, &
																				lb_get_treatment_dates)
if ll_treatment_id <= 0 then
	return -1
end if

return ll_treatment_id

end function

public function long order_treatment (string ps_cpr_id, long pl_encounter_id, string ps_treatment_type, string ps_treatment_desc, long pl_problem_id, boolean pb_past_treatment, string ps_user_id, long pl_parent_treatment_id, str_attributes pstr_attributes, boolean pb_do_autoperform, boolean pb_get_treatment_dates);///////////////////////////////////////////////////////////////////////////////////////////////////////
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
u_component_treatment luo_treatment
str_treatment_description lstr_treatment
boolean lb_past_treatment
datetime ldt_encounter_date
boolean lb_order_workflow
str_encounter_description lstr_encounter

luo_treatment = f_get_treatment_component(ps_treatment_type)
if isnull(luo_treatment) then return -1

luo_treatment.open_encounter_id 		= pl_encounter_id
luo_treatment.treatment_description	= ps_treatment_desc
luo_treatment.ordered_by 				= ps_user_id
luo_treatment.past_treatment 			= pb_past_treatment
luo_treatment.parent_treatment_id	= pl_parent_treatment_id

luo_treatment.map_attr_to_data_columns(pstr_attributes)

// Set the open_encounter_id if none was provided
if isnull(luo_treatment.open_encounter_id) then
	// If there's a current service the use that
	if not isnull(current_service) then luo_treatment.open_encounter_id = current_service.encounter_id
	
	// If it's still null then use the current_display_encounter
	if isnull(luo_treatment.open_encounter_id) and not isnull(current_display_encounter) then
		luo_treatment.open_encounter_id = current_display_encounter.encounter_id
	end if
end if

// If we don't have an encounter yet and this is not a past treatment, then use the latest encounter
if isnull(luo_treatment.open_encounter_id) and not luo_treatment.past_treatment then
	lstr_encounter = current_patient.encounters.last_encounter("1=1")
	luo_treatment.open_encounter_id = lstr_encounter.encounter_id
end if

if isnull(luo_treatment.begin_date) then
	ls_encounter_status = current_patient.encounters.encounter_status(luo_treatment.open_encounter_id)
	ldt_encounter_date = current_patient.encounters.encounter_date(luo_treatment.open_encounter_id)
	
	// If the treatment doesn't have a begin_date and we're posting to a closed encounter, then the treatment is a past_treatment by default
	if upper(ls_encounter_status) = "CLOSED" and not luo_treatment.past_treatment then
		luo_treatment.past_treatment = true
	end if
	
	if not luo_treatment.past_treatment then
		if date(ldt_encounter_date) < today() then
			// If the encounter was started on a previous day then use the encounter date
			luo_treatment.begin_date = ldt_encounter_date
		else
			// If the encounter was started today then use the current date/time
			luo_treatment.begin_date = datetime(today(), now())
		end if
	elseif pb_get_treatment_dates then
		li_sts = f_get_treatment_dates(luo_treatment.treatment_type, &
												luo_treatment.treatment_description, &
												luo_treatment.open_encounter_id, &
												luo_treatment.begin_date, &
												luo_treatment.end_date)
		if li_sts <= 0 then return 0

		// msc if we got a treatment edate then force this treatment to a past-treatment
		luo_treatment.past_treatment = true
	end if
end if


ls_in_office_flag = datalist.treatment_type_in_office_flag(luo_treatment.treatment_type)
ls_workplan_close_flag = datalist.treatment_type_workplan_close_flag(luo_treatment.treatment_type)

if isnull(pl_problem_id) then
	luo_treatment.problem_count = 0
else
	luo_treatment.problem_count = 1
	luo_treatment.problem_ids[1]				= pl_problem_id
end if

If luo_treatment.parent_treatment_id = 0 Then Setnull(luo_treatment.parent_treatment_id)


if isnull(luo_treatment.drug_id) then
	If Not Isnull(luo_treatment.procedure_id) Then
		// Get the drug id from procedure table
		SELECT vaccine_id
		 INTO :ls_proc_drug_id
		 FROM c_Procedure
		 WHERE procedure_id = :luo_treatment.procedure_id;
		If Not tf_check() Then Return -1
	
		If sqlca.Sqlcode = 100 Then
			Setnull(ls_proc_drug_id)
		End If
	
		// Set the drug attribute
		luo_treatment.drug_id = ls_proc_drug_id	
	End If
elseif Not luo_treatment.is_authorized() Then
	Return 0
end if


// If we don't have a treatment description then create one
if isnull(luo_treatment.treatment_description) then
	if not isnull(luo_treatment.observation_id) then
		luo_treatment.treatment_description = datalist.observation_description(luo_treatment.observation_id)
	elseif not isnull(luo_treatment.drug_id) then
		li_sts = drugdb.get_drug_definition(luo_treatment.drug_id, lstr_drug)
		if li_sts <= 0 then
			log.log(this, "u_ds_treatment_item.order_treatment:0128", "Unable to get drug definition (" + luo_treatment.drug_id + ")", 4)
			luo_treatment.treatment_description = "Drug Treatment"
		else
			luo_treatment.treatment_description = lstr_drug.common_name
		end if
	elseif not isnull(luo_treatment.procedure_id) then
		SELECT description
		INTO :luo_treatment.treatment_description
		FROM c_Procedure
		WHERE procedure_id = :luo_treatment.procedure_id;
		if not tf_check() then return -1
		if sqlca.sqlcode = 100 then
			log.log(this, "u_ds_treatment_item.order_treatment:0140", "Unable to get procedure definition (" + luo_treatment.procedure_id + ")", 4)
			luo_treatment.treatment_description = "Procedure Treatment"
		end if
	else
		luo_treatment.treatment_description = datalist.treatment_type_description(luo_treatment.treatment_type)
	end if
end if

// Reset Flags
luo_treatment.exists = false
luo_treatment.updated = false
luo_treatment.deleted = false

// Always order the workflow from this method
// even bother ordering the workflow item(s)
lb_order_workflow = true

li_sts = new_treatment(luo_treatment, lb_order_workflow)
If li_sts < 0 Then Return -1

// Remember the treatment data but destroy the component
lb_past_treatment = luo_treatment.past_treatment
li_sts = treatment(lstr_treatment, luo_treatment.treatment_id)
if li_sts <= 0 then return -1
component_manager.destroy_component(luo_treatment)

// If we're supposed to do the autoperform services now, then do them
if pb_do_autoperform then do_autoperform_services(lstr_treatment.treatment_id)

// See if we have a current workplan
SELECT min(patient_workplan_id)
INTO :ll_patient_workplan_id
FROM p_Patient_WP
WHERE cpr_id = :current_patient.cpr_id
AND treatment_id = :lstr_treatment.treatment_id
AND status = 'Current';
if not tf_check() then return -1

// If this is an in-office treatment without a workplan and the workplan close flag is "Y", then close it.
// Or if it is a past in-office treatment then close it.
// Or if the caller provided an end_date then close it.
if (ls_in_office_flag = "Y" and ls_workplan_close_flag = "Y" and isnull(ll_patient_workplan_id)) &
 or (lb_past_treatment and ls_in_office_flag = "Y") &
 or not Isnull(lstr_treatment.end_date) then
	if isnull(lstr_treatment.end_date) then lstr_treatment.end_date = lstr_treatment.begin_date
	li_sts = set_treatment_progress(lstr_treatment.treatment_id, "Closed", lstr_treatment.end_date)
end if

return lstr_treatment.treatment_id



end function

public function integer new_treatment_old (u_component_treatment puo_treatment, boolean pb_workflow);Integer 	li_sts
Integer 	i
long		ll_row,ll_treatment_id,ll_null
long 		ll_ordered_patient_workplan_id
long 		ll_followup_patient_workplan_id
long 		ll_problem_id
long 		ll_at_row,ll_rowcount
long 		ll_sort_sequence
long 		ll_workplan_id
string ls_procedure_id

String 	ls_component_id
String 	ls_description
String 	ls_in_office_flag
String 	ls_treatment_in_office_flag
String 	ls_define_title
String 	ls_button
String 	ls_icon
String 	ls_followup_flag
String 	ls_observation_type
String 	ls_workplan_close_flag
String 	ls_workplan_cancel_flag
String 	ls_status
string ls_check_cpr_id
string ls_check_treatment_type
string ls_ordered_for
long ll_parent_patient_workplan_item_id
long ll_real_treatment_id

setnull(ls_ordered_for)
setnull(ll_parent_patient_workplan_item_id)

Setnull(ll_null)

if isnull(puo_treatment.open_encounter_id) then
	if isnull(current_patient.open_encounter) then
		openwithparm(w_pop_message, "You may not create a new treatment without an encounter context")
		return -1
	else
		puo_treatment.open_encounter_id = current_patient.open_encounter.encounter_id
	end if
end if

ll_problem_id = puo_treatment.problem_id()

// Make sure the begin date is set
If isnull(puo_treatment.begin_date) Then puo_treatment.begin_date = datetime(today(), now())

// Enforce character limits on freeform fields
puo_treatment.duration_prn = left(puo_treatment.duration_prn, 32)
puo_treatment.treatment_goal = left(puo_treatment.treatment_goal, 80)

// Make sure the office_id is set if it needs to be
If not puo_treatment.past_treatment and pb_workflow and isnull(puo_treatment.treatment_office_id) Then
	puo_treatment.treatment_office_id = office_id
end if



// Insert a record into p_treatment_item table.
ll_row = insertrow(0)
cache_valid[ll_row] = false

object.cpr_id[ll_row] = parent_patient.cpr_id   
object.open_encounter_id[ll_row] = puo_treatment.open_encounter_id   
object.treatment_type[ll_row] = puo_treatment.treatment_type
object.begin_date[ll_row] = puo_treatment.begin_date   
object.package_id[ll_row] = puo_treatment.package_id   
object.specialty_id[ll_row] = puo_treatment.specialty_id
object.procedure_id[ll_row] = puo_treatment.procedure_id
object.drug_id[ll_row] = puo_treatment.drug_id
object.observation_id[ll_row] = puo_treatment.observation_id
object.administration_sequence[ll_row] = puo_treatment.administration_sequence   
object.dose_amount[ll_row] = puo_treatment.dose_amount   
object.dose_unit[ll_row] = puo_treatment.dose_unit   
object.administer_frequency[ll_row] = puo_treatment.administer_frequency   
object.duration_amount[ll_row] = puo_treatment.duration_amount
object.duration_unit[ll_row] = puo_treatment.duration_unit
object.duration_prn[ll_row] = puo_treatment.duration_prn
object.dispense_amount[ll_row] = puo_treatment.dispense_amount   
object.office_dispense_amount[ll_row] = puo_treatment.office_dispense_amount
object.dispense_unit[ll_row] = puo_treatment.dispense_unit   
object.brand_name_required[ll_row] = puo_treatment.brand_name_required   
object.refills[ll_row] = puo_treatment.refills   
object.treatment_description[ll_row] = left(puo_treatment.treatment_description, 80)
object.treatment_goal[ll_row] = puo_treatment.treatment_goal   
object.location[ll_row] = puo_treatment.location
object.maker_id[ll_row] = puo_treatment.maker_id
object.lot_number[ll_row] = puo_treatment.lot_number
object.office_id[ll_row] = puo_treatment.treatment_office_id
object.send_out_flag[ll_row] = puo_treatment.send_out_flag
object.original_treatment_id[ll_row] = puo_treatment.original_treatment_id
object.parent_treatment_id[ll_row] = puo_treatment.parent_treatment_id
object.attach_flag[ll_row] = puo_treatment.attach_flag
object.referral_question[ll_row] = puo_treatment.referral_question
object.referral_question_assmnt_id[ll_row] = puo_treatment.referral_question_assmnt_id
object.ordered_by[ll_row] = puo_treatment.ordered_by
object.created_by[ll_row] = current_scribe.user_id
object.material_id[ll_row] = puo_treatment.material_id
object.treatment_mode[ll_row] = puo_treatment.treatment_mode
object.expiration_date[ll_row] = puo_treatment.expiration_date
object.specimen_id[ll_row] = puo_treatment.specimen_id
object.ordered_by_supervisor[ll_row] = puo_treatment.ordered_by_supervisor
object.appointment_date_time[ll_row] = puo_treatment.appointment_date_time
object.ordered_for[ll_row] = puo_treatment.ordered_for




SELECT
	component_id,
	description,
	in_office_flag,
	define_title,
	button,
	icon,
	sort_sequence,
	workplan_id,
	followup_flag,
	observation_type,
	workplan_close_flag,
	workplan_cancel_flag,
	status
INTO
	:ls_component_id,
	:ls_description,
	:ls_treatment_in_office_flag,
	:ls_define_title,
	:ls_button,
	:ls_icon,
	:ll_sort_sequence,
	:ll_workplan_id,
	:ls_followup_flag,
	:ls_observation_type,
	:ls_workplan_close_flag,
	:ls_workplan_cancel_flag,
	:ls_status
FROM c_Treatment_Type
WHERE treatment_type = :puo_treatment.treatment_type;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then
	log.log(this, "u_ds_treatment_item.new_treatment_old:0142", "Treatment type not found (" + puo_treatment.treatment_type + ")", 3)
end if

object.component_id[ll_row] = ls_component_id
object.description[ll_row] = ls_description
object.in_office_flag[ll_row] = ls_treatment_in_office_flag
object.define_title[ll_row] = ls_define_title
object.button[ll_row] = ls_button
object.icon[ll_row] = ls_icon
object.sort_sequence[ll_row] = ll_sort_sequence
object.workplan_id[ll_row] = ll_workplan_id
object.followup_flag[ll_row] = ls_followup_flag
object.observation_type[ll_row] = ls_observation_type
object.workplan_close_flag[ll_row] = ls_workplan_close_flag
object.workplan_cancel_flag[ll_row] = ls_workplan_cancel_flag
object.status[ll_row] = ls_status

// Open a transaction to hold locks while powerbuilder queries for the treatment_id
tf_begin_transaction(this, "new_treatment()")

li_sts = Update()
If li_sts <= 0 Then
	tf_rollback()
	log.log(this, "u_ds_treatment_item.new_treatment_old:0165", "Error saving new treatment", 4)
	Return -1
End if

// Commit the transaction
tf_commit_transaction()

// Make sure we had a treatment_id generated
ll_treatment_id = object.treatment_id[ll_row]
If isnull(ll_treatment_id) Then
	log.log(this, "u_ds_treatment_item.new_treatment_old:0175", "treatment_id not generated", 4)
	Return -1
End if

// Make sure this is the correct treatment_id
ll_real_treatment_id = sqlca.fn_last_treatment_for_patient( current_patient.cpr_id, ll_treatment_id)
if isnull(ll_real_treatment_id) then
	log.log(this, "u_ds_treatment_item.new_treatment_old:0182", "Incorrect Treatment_id", 4)
	return -1
end if

if ll_real_treatment_id <> ll_treatment_id then
	// If we got the wrong treatment_id, then correct it.  Sometimes we get the wrong treatment_id
	// at first because the mechanism for getting the treatment_id is that when powerbuilder
	// inserts the record into the database it immediately follows with a SELECT MAX(IDENTITYCOL) to get the
	// new treatment_id.  It rarely but occaisionally happens that another process will succeed in inserting
	// a record in between this process inserting and selecting the new key value.  When that happens, the
	// other process will retrieve the correct new key value but this process will get the key value from
	// the other process, which will be one greater than the value actually assigned to this process' record.
	ll_treatment_id = ll_real_treatment_id
	object.treatment_id[ll_row] = ll_treatment_id
	setitemstatus(ll_row, 0, Primary!, NotModified!)
end if

// Add the "Created" progress record
set_treatment_progress(ll_treatment_id, "Created")

for i = 1 to puo_treatment.problem_count
	set_treatment_assessment(ll_treatment_id, puo_treatment.problem_ids[i], true)
next

// IF the treatment is a past treatment then just order an associated workplan
If puo_treatment.past_treatment Then
	ls_in_office_flag = "N"
else
	ls_in_office_flag = "Y"
end if

if len(puo_treatment.treatment_description) > 80 then
	set_treatment_progress(ll_treatment_id, "Modify", "treatment_description", puo_treatment.treatment_description)
end if

// Add the new-progress records to the database
for i = 1 to puo_treatment.new_progress.progress_count
	set_treatment_progress(ll_treatment_id, &
									puo_treatment.new_progress.progress[i].progress_type, &
									puo_treatment.new_progress.progress[i].progress_key, &
									puo_treatment.new_progress.progress[i].progress )
next

if pb_workflow then
	// Order the treatment workplan(s)
	sqlca.sp_order_treatment_workplans( &
			parent_patient.cpr_id, &
			ll_treatment_id, &
			puo_treatment.treatment_type, &
			puo_treatment.treatment_mode, &
			puo_treatment.ordered_workplan_id, &
			puo_treatment.followup_workplan_id, &
			puo_treatment.open_encounter_id, &
			puo_treatment.treatment_description, &
			current_user.user_id, &
			ls_ordered_for, &
			ll_parent_patient_workplan_item_id, &
			ls_in_office_flag, &
			current_scribe.user_id, &
			ll_ordered_patient_workplan_id, &
			ll_followup_patient_workplan_id)
	If Not tf_check() then Return -1
	
end if

// If it's not a past treatment, then set the billing
If not puo_treatment.past_treatment Then
	sqlca.sp_add_treatment_charges(current_patient.cpr_id, &
												puo_treatment.open_encounter_id, &
												ll_treatment_id, &
												current_scribe.user_id)
	if not tf_check() then return -1
End if


// Now finish initializing the puo_treatment object because it now represents a real live treatment

puo_treatment.treatment_id = ll_treatment_id

puo_treatment.parent_patient = parent_patient

// Get an empty attachment list
parent_patient.attachments.treatment_attachment_list(puo_treatment.attachment_list, ll_treatment_id)

// Close the treatment if there's and end date
if not isnull(puo_treatment.end_date) or (lower(puo_treatment.treatment_status) = "closed") then
	if isnull(puo_treatment.end_date) then puo_treatment.end_date = puo_treatment.begin_date
	li_sts = set_treatment_progress(puo_treatment.treatment_id, "Closed", puo_treatment.end_date)
	if li_sts <= 0 then return -1
	puo_treatment.treatment_status = "Closed"
end if


// Get the list of associated assessments
puo_treatment.problem_count = get_treatment_assessments(ll_treatment_id, puo_treatment.problem_ids)

li_sts = puo_treatment.load_observations()
if li_sts < 0 then return -1

Return 1


end function

public function long new_treatment_record (string ps_cpr_id, long pl_open_encounter_id, string ps_treatment_type, string ps_treatment_mode, datetime pdt_begin_date, datetime pdt_end_date, string ps_treatment_description, long pl_original_treatment_id, long pl_parent_treatment_id, string ps_ordered_by, string ps_created_by, string ps_office_id, string ps_treatment_status, str_attributes pstr_attributes);integer li_sts
long i
long		ll_treatment_id
string ls_treatment_description_80
long ll_row
datetime ldt_null
long ll_null
string ls_null

setnull(ls_null)
setnull(ldt_null)
setnull(ll_null)

if isnull(pl_open_encounter_id) then
	if isnull(current_patient.open_encounter) then
		openwithparm(w_pop_message, "You may not create a new treatment without an encounter context")
		return -1
	else
		pl_open_encounter_id = current_patient.open_encounter.encounter_id
	end if
end if


// Make sure the begin date is set
If isnull(pdt_begin_date) Then pdt_begin_date = datetime(today(), now())

// Make sure the office_id is set if it needs to be
If isnull(ps_office_id) Then
	ps_office_id = office_id
end if

ls_treatment_description_80 = left(ps_treatment_description, 80)

// Close the treatment if there's and end date
if not isnull(pdt_end_date) or (lower(ps_treatment_status) = "closed") then
	if isnull(pdt_end_date) then pdt_end_date = pdt_begin_date
	ps_treatment_status = "Closed"
end if


INSERT INTO dbo.p_Treatment_Item
           (cpr_id
           ,open_encounter_id
           ,treatment_type
           ,treatment_mode
           ,begin_date
           ,end_date
           ,treatment_description
           ,original_treatment_id
           ,parent_treatment_id
           ,ordered_by
           ,created_by
           ,office_id
           ,treatment_status)
     VALUES
           (:ps_cpr_id
           ,:pl_open_encounter_id
           ,:ps_treatment_type
           ,:ps_treatment_mode
           ,:pdt_begin_date
           ,:pdt_end_date
           ,:ls_treatment_description_80
           ,:pl_original_treatment_id
           ,:pl_parent_treatment_id
           ,:ps_ordered_by
           ,:ps_created_by
           ,:ps_office_id
           ,:ps_treatment_status);
if not tf_check() then return -1

SELECT SCOPE_IDENTITY()
INTO :ll_treatment_id
FROM c_1_record;
if not tf_check() then return -1

// Add the "Created" progress record
li_sts = f_set_progress(ps_cpr_id, &
								"Treatment", &
								ll_treatment_id, &
								"Created", &
								ls_null, &
								ls_null, &
								ldt_null, &
								ll_null, &
								ll_null, &
								ll_null)
if li_sts < 0 then return -1

if len(ps_treatment_description) > 80 then
	li_sts = f_set_progress(ps_cpr_id, &
									"Treatment", &
									ll_treatment_id, &
									"Modify", &
									"treatment_description", &
									ps_treatment_description, &
									ldt_null, &
									ll_null, &
									ll_null, &
									ll_null)
	if li_sts < 0 then return -1
end if

for i = 1 to pstr_attributes.attribute_count
	li_sts = f_set_progress(ps_cpr_id, &
									"Treatment", &
									ll_treatment_id, &
									"Modify", &
									pstr_attributes.attribute[i].attribute, &
									pstr_attributes.attribute[i].value, &
									ldt_null, &
									ll_null, &
									ll_null, &
									ll_null)
	if li_sts < 0 then return -1
next

// Insert a record into p_treatment_item table.
ll_row = insertrow(0)
cache_valid[ll_row] = false

object.cpr_id[ll_row] = ps_cpr_id
object.treatment_id[ll_row] = ll_treatment_id
object.treatment_type[ll_row] = ps_treatment_type

li_sts = refresh_row(ll_row)
if li_sts < 0 then return -1


Return ll_row


end function

public function integer new_treatment (u_component_treatment puo_treatment, boolean pb_workflow);Integer 	li_sts
Integer 	i
long		ll_row,ll_treatment_id,ll_null
long 		ll_ordered_patient_workplan_id
long 		ll_followup_patient_workplan_id
long 		ll_problem_id
long 		ll_at_row,ll_rowcount
long 		ll_sort_sequence
long 		ll_workplan_id
string ls_procedure_id

String 	ls_component_id
String 	ls_description
String 	ls_in_office_flag
String 	ls_treatment_in_office_flag
String 	ls_define_title
String 	ls_button
String 	ls_icon
String 	ls_followup_flag
String 	ls_observation_type
String 	ls_workplan_close_flag
String 	ls_workplan_cancel_flag
String 	ls_status
string ls_check_cpr_id
string ls_check_treatment_type
string ls_ordered_for
long ll_parent_patient_workplan_item_id
long ll_real_treatment_id
str_attributes lstr_treatment_attributes

setnull(ls_ordered_for)
setnull(ll_parent_patient_workplan_item_id)

Setnull(ll_null)

if isnull(puo_treatment.open_encounter_id) then
	if isnull(current_patient.open_encounter) then
		openwithparm(w_pop_message, "You may not create a new treatment without an encounter context")
		return -1
	else
		puo_treatment.open_encounter_id = current_patient.open_encounter.encounter_id
	end if
end if

ll_problem_id = puo_treatment.problem_id()

// Make sure the begin date is set
If isnull(puo_treatment.begin_date) Then puo_treatment.begin_date = datetime(today(), now())

// Enforce character limits on freeform fields
puo_treatment.duration_prn = left(puo_treatment.duration_prn, 32)
puo_treatment.treatment_goal = left(puo_treatment.treatment_goal, 80)

// Make sure the office_id is set if it needs to be
If not puo_treatment.past_treatment and pb_workflow and isnull(puo_treatment.treatment_office_id) Then
	puo_treatment.treatment_office_id = office_id
end if


f_attribute_add_attribute(lstr_treatment_attributes, "package_id", puo_treatment.package_id   )
f_attribute_add_attribute(lstr_treatment_attributes, "specialty_id", puo_treatment.specialty_id)
f_attribute_add_attribute(lstr_treatment_attributes, "procedure_id", puo_treatment.procedure_id)
f_attribute_add_attribute(lstr_treatment_attributes, "drug_id", puo_treatment.drug_id)
f_attribute_add_attribute(lstr_treatment_attributes, "observation_id", puo_treatment.observation_id)
f_attribute_add_attribute(lstr_treatment_attributes, "administration_sequence", string(puo_treatment.administration_sequence   ))
f_attribute_add_attribute(lstr_treatment_attributes, "dose_amount", string(puo_treatment.dose_amount   ))
f_attribute_add_attribute(lstr_treatment_attributes, "dose_unit", puo_treatment.dose_unit   )
f_attribute_add_attribute(lstr_treatment_attributes, "administer_frequency", puo_treatment.administer_frequency   )
f_attribute_add_attribute(lstr_treatment_attributes, "duration_amount", string(puo_treatment.duration_amount))
f_attribute_add_attribute(lstr_treatment_attributes, "duration_unit", puo_treatment.duration_unit)
f_attribute_add_attribute(lstr_treatment_attributes, "duration_prn", puo_treatment.duration_prn)
f_attribute_add_attribute(lstr_treatment_attributes, "dispense_amount", string(puo_treatment.dispense_amount   ))
f_attribute_add_attribute(lstr_treatment_attributes, "office_dispense_amount", string(puo_treatment.office_dispense_amount))
f_attribute_add_attribute(lstr_treatment_attributes, "dispense_unit", puo_treatment.dispense_unit   )
f_attribute_add_attribute(lstr_treatment_attributes, "brand_name_required", puo_treatment.brand_name_required   )
f_attribute_add_attribute(lstr_treatment_attributes, "refills", string(puo_treatment.refills   ))
f_attribute_add_attribute(lstr_treatment_attributes, "treatment_goal", puo_treatment.treatment_goal   )
f_attribute_add_attribute(lstr_treatment_attributes, "location", puo_treatment.location)
f_attribute_add_attribute(lstr_treatment_attributes, "maker_id", puo_treatment.maker_id)
f_attribute_add_attribute(lstr_treatment_attributes, "lot_number", puo_treatment.lot_number)
f_attribute_add_attribute(lstr_treatment_attributes, "send_out_flag", puo_treatment.send_out_flag)
f_attribute_add_attribute(lstr_treatment_attributes, "attach_flag", puo_treatment.attach_flag)
f_attribute_add_attribute(lstr_treatment_attributes, "referral_question", puo_treatment.referral_question)
f_attribute_add_attribute(lstr_treatment_attributes, "referral_question_assmnt_id", puo_treatment.referral_question_assmnt_id)
f_attribute_add_attribute(lstr_treatment_attributes, "material_id", string(puo_treatment.material_id))
f_attribute_add_attribute(lstr_treatment_attributes, "expiration_date", string(puo_treatment.expiration_date))
f_attribute_add_attribute(lstr_treatment_attributes, "specimen_id", puo_treatment.specimen_id)
f_attribute_add_attribute(lstr_treatment_attributes, "ordered_by_supervisor", puo_treatment.ordered_by_supervisor)
f_attribute_add_attribute(lstr_treatment_attributes, "appointment_date_time", string(puo_treatment.appointment_date_time))
f_attribute_add_attribute(lstr_treatment_attributes, "ordered_for", puo_treatment.ordered_for)


ll_row = new_treatment_record(parent_patient.cpr_id   , &
										puo_treatment.open_encounter_id   , &
										puo_treatment.treatment_type, &
										puo_treatment.treatment_mode, &
										puo_treatment.begin_date   , &
										puo_treatment.end_date, &
										puo_treatment.treatment_description, &
										puo_treatment.original_treatment_id, &
										puo_treatment.parent_treatment_id, &
										puo_treatment.ordered_by, &
										current_scribe.user_id, &
										puo_treatment.treatment_office_id, &
										puo_treatment.treatment_status, &
										lstr_treatment_attributes )
if ll_row <= 0 then return -1

// Make sure we had a treatment_id generated
ll_treatment_id = object.treatment_id[ll_row]
If isnull(ll_treatment_id) Then
	log.log(this, "u_ds_treatment_item.new_treatment:0112", "treatment_id not generated", 4)
	Return -1
End if


for i = 1 to puo_treatment.problem_count
	set_treatment_assessment(ll_treatment_id, puo_treatment.problem_ids[i], true)
next

// IF the treatment is a past treatment then just order an associated workplan
If puo_treatment.past_treatment Then
	ls_in_office_flag = "N"
else
	ls_in_office_flag = "Y"
end if

// Add the new-progress records to the database
for i = 1 to puo_treatment.new_progress.progress_count
	set_treatment_progress(ll_treatment_id, &
									puo_treatment.new_progress.progress[i].progress_type, &
									puo_treatment.new_progress.progress[i].progress_key, &
									puo_treatment.new_progress.progress[i].progress )
next

if pb_workflow then
	// Order the treatment workplan(s)
	sqlca.sp_order_treatment_workplans( &
			parent_patient.cpr_id, &
			ll_treatment_id, &
			puo_treatment.treatment_type, &
			puo_treatment.treatment_mode, &
			puo_treatment.ordered_workplan_id, &
			puo_treatment.followup_workplan_id, &
			puo_treatment.open_encounter_id, &
			puo_treatment.treatment_description, &
			current_user.user_id, &
			ls_ordered_for, &
			ll_parent_patient_workplan_item_id, &
			ls_in_office_flag, &
			current_scribe.user_id, &
			ll_ordered_patient_workplan_id, &
			ll_followup_patient_workplan_id)
	If Not tf_check() then Return -1
	
end if

// If it's not a past treatment, then set the billing
If not puo_treatment.past_treatment Then
	sqlca.sp_add_treatment_charges(current_patient.cpr_id, &
												puo_treatment.open_encounter_id, &
												ll_treatment_id, &
												current_scribe.user_id)
	if not tf_check() then return -1
End if


// Now finish initializing the puo_treatment object because it now represents a real live treatment

puo_treatment.treatment_id = ll_treatment_id

puo_treatment.parent_patient = parent_patient

// Get an empty attachment list
parent_patient.attachments.treatment_attachment_list(puo_treatment.attachment_list, ll_treatment_id)

// Close the treatment if there's and end date
if not isnull(puo_treatment.end_date) or (lower(puo_treatment.treatment_status) = "closed") then
	if isnull(puo_treatment.end_date) then puo_treatment.end_date = puo_treatment.begin_date
	li_sts = set_treatment_progress(puo_treatment.treatment_id, "Closed", puo_treatment.end_date)
	if li_sts <= 0 then return -1
	puo_treatment.treatment_status = "Closed"
end if


// Get the list of associated assessments
puo_treatment.problem_count = get_treatment_assessments(ll_treatment_id, puo_treatment.problem_ids)

li_sts = puo_treatment.load_observations()
if li_sts < 0 then return -1

Return 1


end function

public function integer refresh_row (long pl_row);integer li_sts
string ls_component_id
string ls_description
string ls_treatment_in_office_flag
string ls_define_title
string ls_button
string ls_icon
long ll_sort_sequence
long ll_workplan_id
string ls_followup_flag
string ls_observation_type
string ls_workplan_close_flag
string ls_workplan_cancel_flag
string ls_status
string ls_treatment_type
string ls_cpr_id
long ll_treatment_id

ls_treatment_type = object.treatment_type[pl_row]
if isnull(ls_treatment_type) or trim(ls_treatment_type) = "" then
	ls_cpr_id = object.cpr_id[pl_row]
	ll_treatment_id = object.treatment_id[pl_row]
	
	SELECT treatment_type
	INTO :ls_treatment_type
	FROM p_Treatment_Item
	WHERE cpr_id = :ls_cpr_id
	AND treatment_id = :ll_treatment_id;
	if not tf_check() then return -1
	if isnull(ls_treatment_type) or trim(ls_treatment_type) = "" then
		log.log(this, "u_ds_treatment_item.refresh_row:0031", "Invalid treatment_type (" + string(ll_treatment_id) + ")", 4)
		return -1
	end if
end if
		
	
setitemstatus(pl_row, 0, Primary!, NotModified!)
li_sts = reselectrow(pl_row)
if li_sts <= 0 then return -1


// Refresh the values that were not retrieved by reselectrow()
SELECT
	component_id,
	description,
	in_office_flag,
	define_title,
	button,
	icon,
	sort_sequence,
	workplan_id,
	followup_flag,
	observation_type,
	workplan_close_flag,
	workplan_cancel_flag,
	status
INTO
	:ls_component_id,
	:ls_description,
	:ls_treatment_in_office_flag,
	:ls_define_title,
	:ls_button,
	:ls_icon,
	:ll_sort_sequence,
	:ll_workplan_id,
	:ls_followup_flag,
	:ls_observation_type,
	:ls_workplan_close_flag,
	:ls_workplan_cancel_flag,
	:ls_status
FROM c_Treatment_Type
WHERE treatment_type = :ls_treatment_type;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then
	INSERT INTO c_treatment_type (
		treatment_type,
		description,
		component_id,
		in_office_flag,
		sort_sequence,
		button,
		icon,
		status)
	VALUES (
		:ls_treatment_type,
		:ls_treatment_type,
		'TREAT_TEST',
		'N',
		999,
		'button_todo.bmp',
		'button_todo.bmp',
		'OK' );
	if not tf_check() then return -1
end if

object.component_id[pl_row] = ls_component_id
object.description[pl_row] = ls_description
object.in_office_flag[pl_row] = ls_treatment_in_office_flag
object.define_title[pl_row] = ls_define_title
object.button[pl_row] = ls_button
object.icon[pl_row] = ls_icon
object.sort_sequence[pl_row] = ll_sort_sequence
object.workplan_id[pl_row] = ll_workplan_id
object.followup_flag[pl_row] = ls_followup_flag
object.observation_type[pl_row] = ls_observation_type
object.workplan_close_flag[pl_row] = ls_workplan_close_flag
object.workplan_cancel_flag[pl_row] = ls_workplan_cancel_flag
object.status[pl_row] = ls_status

setitemstatus(pl_row, 0, Primary!, NotModified!)

return 1

end function

public subroutine set_treatment_changed (long pl_treatment_id);string ls_find
long ll_row

if isnull(pl_treatment_id) or pl_treatment_id <= 0 then
	log.log(this, "u_ds_treatment_item.set_treatment_changed:0005", "Invalid treatment_id", 4)
	return
end if

ls_find = "treatment_id=" + string(pl_treatment_id)
ll_row = find(ls_find, 1, rowcount())
if ll_row <= 0 then
	log.log(this, "u_ds_treatment_item.set_treatment_changed:0012", "treatment not found", 4)
	return
end if

reselectrow(ll_row)
cache_valid[ll_row] = false

Return

end subroutine

on u_ds_treatment_item.create
call super::create
end on

on u_ds_treatment_item.destroy
call super::destroy
end on

event destructor;call super::destructor;if isvalid(p_Assessment_Treatment) and not isnull(p_Assessment_Treatment) then
	DESTROY p_Assessment_Treatment
end if

end event

event constructor;call super::constructor;context_object = "Treatment"

end event

event retrieveend;call super::retrieveend;long i

for i = 1 to rowcount
	cache_valid[i] = false
next

end event

