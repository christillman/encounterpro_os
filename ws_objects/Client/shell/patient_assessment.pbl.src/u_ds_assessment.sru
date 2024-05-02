$PBExportHeader$u_ds_assessment.sru
forward
global type u_ds_assessment from u_ds_base_class
end type
type icd_parts from structure within u_ds_assessment
end type
end forward

type icd_parts from structure
	string		icd_part
	long		icd_part_count
end type

global type u_ds_assessment from u_ds_base_class
string dataobject = "dw_assessment_data"
string context_object = "Assessment"
end type
global u_ds_assessment u_ds_assessment

type variables
str_assessment_type assessment_types[]
integer type_count

private integer icd_part_count
private icd_parts icd_part[]

boolean cache_valid[]
str_assessment_description cache[]

end variables

forward prototypes
public function integer next_diagnosis_sequence (long pl_problem_id)
public function integer close_auto_close ()
public function boolean is_rediagnosed (long pl_problem_id, integer pi_diagnosis_sequence)
public function integer load_assessment_types ()
public function boolean in_encounter (long pl_problem_id, long pl_encounter_id)
public function integer set_progress (long pl_problem_id, integer pi_diagnosis_sequence, string ps_progress_type, string ps_progress, string ps_severity, datetime pdt_progress_date_time)
public function integer save_attachment (long pl_problem_id, integer pi_diagnosis_sequence, long pl_attachment_id)
public function integer get_assessment_type (string ps_assessment_type, ref str_assessment_type pstr_assessment_type)
public function integer get_assessments (integer pl_problem_count, long pl_problem_ids[], ref str_assessment_description pstra_assessments[])
public function integer set_progress (long pl_problem_id, string ps_progress_type, string ps_progress_key, string ps_progress, long pl_risk_level)
public function integer set_progress (long pl_problem_id, integer pi_diagnosis_sequence, string ps_progress_type, string ps_progress, string ps_severity, u_attachment_list puo_attachment_list)
public function integer set_progress (long pl_problem_id, string ps_progress_type, string ps_progress_key, string ps_progress)
public function integer rediagnose (long pl_problem_id, long pl_encounter_id, string ps_assessment_id, datetime pdt_begin_date, string ps_diagnosed_by, string ps_created_by)
public function integer assessment (ref str_assessment_description pstr_assessment, long pl_problem_id)
public function integer assessment (ref u_str_assessment puo_assessment, long pl_problem_id)
public function string assessment_description (long pl_problem_id, integer pi_diagnosis_sequence)
public function string assessment_bitmap (str_assessment_description pstr_assessment)
public function string assessment_type (long pl_problem_id)
public function integer set_progress (long pl_problem_id, integer pi_diagnosis_sequence, string ps_progress_type, string ps_progress, string ps_severity)
public function integer set_progress (long pl_problem_id, integer pi_diagnosis_sequence, string ps_progress_type, string ps_progress, string ps_severity, datetime pdt_progress_date_time, u_attachment_list puo_attachment_list)
public function integer set_progress (long pl_problem_id, integer pi_diagnosis_sequence, string ps_progress_type, string ps_progress, string ps_severity, datetime pdt_progress_date_time, long pl_attachment_id)
public function integer set_progress (long pl_problem_id, datetime pdt_progress_date_time, integer pi_diagnosis_sequence, string ps_progress_type, string ps_progress_key, string ps_progress, string ps_severity, long pl_attachment_id, long pl_risk_level)
public function integer assessment (ref str_assessment_description pstr_assessment, long pl_problem_id, integer pi_diagnosis_sequence)
public function integer assessment (ref u_str_assessment puo_assessment, long pl_problem_id, integer pi_diagnosis_sequence)
public function integer get_encounter_assessments (long pl_encounter_id, ref str_assessment_description pstra_assessments[])
public function string assessment_description (long pl_problem_id)
public function integer get_assessments (string ps_find, ref str_assessment_description pstra_assessments[])
public function string assessment_assessment (long pl_problem_id)
private function str_assessment_description get_assessment (long pl_row)
public function long add_assessment (long pl_open_encounter_id, string ps_assessment_type, string ps_assessment_id, string ps_assessment, long pl_attachment_id, datetime pdt_begin_date, string ps_diagnosed_by, string ps_location, string ps_created_by)
protected function integer display_progress_old (u_rich_text_edit puo_rte, long pl_problem_id, string ps_progress_type)
public function integer display_progress_old (u_rich_text_edit puo_rte, long pl_problem_id)
public function long get_assessment_row (long pl_problem_id, integer pi_diagnosis_sequence)
public function long find_object_row (long pl_object_key)
public function integer modify_assessment (long pl_problem_id, integer pi_diagnosis_sequence, string ps_assessment_field, string ps_new_value)
public function integer modify_assessment (long pl_problem_id, string ps_assessment_field, string ps_new_value)
public function str_property_value get_property (long pl_object_key, string ps_property, str_attributes pstr_attributes)
public function integer set_progress (long pl_problem_id, string ps_progress_type, string ps_progress_key, string ps_progress, long pl_risk_level, datetime pdt_progress_date_time)
private subroutine icd_part_count_calculate ()
public function long icd_part_count (string ps_icd10_code)
public function integer add_assessment (ref str_assessment_description pstr_assessment)
public function integer get_encounter_assessments (long pl_encounter_id, boolean pb_include_deleted, ref str_assessment_description pstra_assessments[])
public subroutine set_assessment_changed (long pl_problem_id)
end prototypes

public function integer next_diagnosis_sequence (long pl_problem_id);string ls_find
integer li_diagnosis_sequence
long ll_row
integer li_max
long ll_rows

ll_rows = rowcount()
li_max = 0

if ll_rows <= 0 then return 1

ls_find = "problem_id=" + string(pl_problem_id)
ll_row = find(ls_find, 1, ll_rows)

DO WHILE ll_row > 0 and ll_row <= ll_rows
	li_diagnosis_sequence = object.diagnosis_sequence[ll_row]
	if li_diagnosis_sequence > li_max then li_max = li_diagnosis_sequence
	ll_row = find(ls_find, ll_row + 1, ll_rows + 1)
LOOP

return li_max + 1


end function

public function integer close_auto_close ();long ll_problem_id
integer li_diagnosis_sequence
string ls_null
string ls_find
long ll_row
long ll_rowcount

setnull(ls_null)

ll_rowcount = rowcount()

// close all the well assessments that are still open
ls_find = "assessment_type = 'WELL' and isnull(assessment_status)"
ll_row = find(ls_find, 1, ll_rowcount)
DO WHILE ll_row > 0 and ll_row <= ll_rowcount
	ll_problem_id = object.problem_id[ll_row]
	li_diagnosis_sequence = object.diagnosis_sequence[ll_row]

	set_progress(ll_problem_id, li_diagnosis_sequence, "CLOSED", ls_null, ls_null)
	
	ll_row = find(ls_find, ll_row + 1, ll_rowcount + 1)
LOOP

return 1


end function

public function boolean is_rediagnosed (long pl_problem_id, integer pi_diagnosis_sequence);string ls_find
long ll_row

ls_find = "problem_id=" + string(pl_problem_id) + " and diagnosis_sequence>" + string(pi_diagnosis_sequence)

ll_row = find(ls_find, 1, rowcount())
if ll_row <= 0 then return false

return true


end function

public function integer load_assessment_types ();string ls_assessment_type
string ls_description
string ls_button
string ls_icon_open
string ls_icon_closed
boolean lb_loop

 DECLARE lc_assessment_types CURSOR FOR  
  SELECT c_Assessment_Type.assessment_type,   
         c_Assessment_Type.description,   
         c_Assessment_Type.button,   
         c_Assessment_Type.icon_open,   
         c_Assessment_Type.icon_closed  
    FROM c_Assessment_Type  ;


open lc_assessment_types;
if not tf_check() then return -1

lb_loop = true
type_count = 0

DO
	FETCH lc_assessment_types INTO
		:ls_assessment_type,
		:ls_description,
		:ls_button,
		:ls_icon_open,
		:ls_icon_closed;
	if not tf_check() then return -1
	
	if sqlca.sqlcode = 0 then
		type_count++
		assessment_types[type_count].assessment_type = ls_assessment_type
		assessment_types[type_count].description = ls_description
		assessment_types[type_count].button = ls_button
		assessment_types[type_count].icon_open = ls_icon_open
		assessment_types[type_count].icon_closed = ls_icon_closed
	else
		lb_loop = false
	end if
LOOP WHILE lb_loop

CLOSE lc_assessment_types;

return type_count






end function

public function boolean in_encounter (long pl_problem_id, long pl_encounter_id);string ls_bill_flag


SELECT bill_flag
INTO :ls_bill_flag
FROM p_Encounter_Assessment
WHERE cpr_id = :parent_patient.cpr_id
AND encounter_id = :pl_encounter_id
AND problem_id = :pl_problem_id;
if not tf_check() then return false
if sqlca.sqlcode = 100 then return false

if ls_bill_flag = "N" then return false

return true

end function

public function integer set_progress (long pl_problem_id, integer pi_diagnosis_sequence, string ps_progress_type, string ps_progress, string ps_severity, datetime pdt_progress_date_time);u_attachment_list luo_attachment_list

setnull(luo_attachment_list)

return set_progress(pl_problem_id, pi_diagnosis_sequence, ps_progress_type, ps_progress, ps_severity, pdt_progress_date_time, luo_attachment_list)


end function

public function integer save_attachment (long pl_problem_id, integer pi_diagnosis_sequence, long pl_attachment_id);integer li_sts
string ls_null
datetime ldt_now

ldt_now = datetime(today(), now())
setnull(ls_null)

if isnull(pl_problem_id) then
	log.log(this, "u_ds_assessment.save_attachment:0009", "ERROR! Cannot save attachment when problem_id=null", 4)
	return -1
end if


return set_progress(pl_problem_id, pi_diagnosis_sequence, "ATTACHMENT", ls_null, ls_null, ldt_now, pl_attachment_id)


end function

public function integer get_assessment_type (string ps_assessment_type, ref str_assessment_type pstr_assessment_type);integer i

if type_count = 0 then load_assessment_types()

for i = 1 to type_count
	if assessment_types[i].assessment_type = ps_assessment_type then
		pstr_assessment_type = assessment_types[i]
		return 1
	end if
next

return 0

end function

public function integer get_assessments (integer pl_problem_count, long pl_problem_ids[], ref str_assessment_description pstra_assessments[]);Long 		ll_row,ll_rowcount,ll_problem_id
Integer 	li_count,i

ll_rowcount = rowcount()
li_count = 0
ll_row = 0

FOR i = 1 To pl_problem_count
	ll_problem_id = pl_problem_ids[i]
	ll_row = Find("problem_id = "+String(ll_problem_id), 1, ll_rowcount)
	If ll_row > 0 Then 
		li_count++
		pstra_assessments[li_count] = get_assessment(ll_row)
	End If
NEXT

Return li_count

end function

public function integer set_progress (long pl_problem_id, string ps_progress_type, string ps_progress_key, string ps_progress, long pl_risk_level);string ls_severity
long ll_attachment_id
datetime ldt_progress_date_time
integer li_diagnosis_sequence

setnull(ls_severity)
setnull(ll_attachment_id)
setnull(ldt_progress_date_time)
setnull(li_diagnosis_sequence)

return set_progress(pl_problem_id, &
							ldt_progress_date_time, &
							li_diagnosis_sequence, &
							ps_progress_type, &
							ps_progress_key, &
							ps_progress, &
							ls_severity, &
							ll_attachment_id, &
							pl_risk_level)


end function

public function integer set_progress (long pl_problem_id, integer pi_diagnosis_sequence, string ps_progress_type, string ps_progress, string ps_severity, u_attachment_list puo_attachment_list);datetime ldt_now

ldt_now = datetime(today(), now())

return set_progress(pl_problem_id, pi_diagnosis_sequence, ps_progress_type, ps_progress, ps_severity, ldt_now, puo_attachment_list)


end function

public function integer set_progress (long pl_problem_id, string ps_progress_type, string ps_progress_key, string ps_progress);string ls_severity
long ll_attachment_id
datetime ldt_progress_date_time
integer li_diagnosis_sequence
long ll_risk_level

setnull(ls_severity)
setnull(ll_attachment_id)
setnull(ldt_progress_date_time)
setnull(li_diagnosis_sequence)
setnull(ll_risk_level)

return set_progress(pl_problem_id, &
							ldt_progress_date_time, &
							li_diagnosis_sequence, &
							ps_progress_type, &
							ps_progress_key, &
							ps_progress, &
							ls_severity, &
							ll_attachment_id, &
							ll_risk_level)


end function

public function integer rediagnose (long pl_problem_id, long pl_encounter_id, string ps_assessment_id, datetime pdt_begin_date, string ps_diagnosed_by, string ps_created_by);integer li_sts
integer li_old_diagnosis_sequence
integer li_new_diagnosis_sequence
long ll_row
integer li_null
string ls_find
string ls_null
string ls_assessment_type
string ls_assessment

setnull(ls_null)
setnull(li_null)

if isnull(pl_problem_id) then
	log.log(this, "u_ds_assessment.rediagnose:0015", "Null problem_id", 4)
	return li_null
end if

ls_find = "problem_id=" + string(pl_problem_id) + " and isnull(assessment_status)"
ll_row = find(ls_find, 1, rowcount())
if ll_row <= 0 then
	log.log(this, "u_ds_assessment.rediagnose:0022", "Invalid problem_id", 4)
	return li_null
end if

li_old_diagnosis_sequence = object.diagnosis_sequence[ll_row]
li_new_diagnosis_sequence = next_diagnosis_sequence(pl_problem_id)

ls_assessment_type = datalist.assessment_assessment_type(ps_assessment_id)
ls_assessment = datalist.assessment_description(ps_assessment_id)

tf_begin_transaction(this, "rediagnose()")

li_sts = set_progress(pl_problem_id, li_old_diagnosis_sequence, "REDIAGNOSED", ls_null, ls_null)
if li_sts <= 0 then
	tf_rollback()
	return -1
end if

ll_row = insertrow(0)
cache_valid[ll_row] = false

object.cpr_id[ll_row] = current_patient.cpr_id
object.problem_id[ll_row] = pl_problem_id
object.diagnosis_sequence[ll_row] = li_new_diagnosis_sequence
object.open_encounter_id[ll_row] = pl_encounter_id
object.assessment_type[ll_row] = ls_assessment_type
object.assessment_id[ll_row] = ps_assessment_id
object.assessment[ll_row] = ls_assessment
object.begin_date[ll_row] = pdt_begin_date
object.diagnosed_by[ll_row] = ps_diagnosed_by
object.created_by[ll_row] = ps_created_by

update()

tf_commit()

return li_new_diagnosis_sequence


end function

public function integer assessment (ref str_assessment_description pstr_assessment, long pl_problem_id);integer li_diagnosis_sequence

setnull(li_diagnosis_sequence)

return assessment(pstr_assessment, pl_problem_id, li_diagnosis_sequence)

end function

public function integer assessment (ref u_str_assessment puo_assessment, long pl_problem_id);integer li_diagnosis_sequence

setnull(li_diagnosis_sequence)

return assessment(puo_assessment, pl_problem_id, li_diagnosis_sequence)
end function

public function string assessment_description (long pl_problem_id, integer pi_diagnosis_sequence);string ls_null
str_assessment_description lstr_assessment
integer li_sts

setnull(ls_null)

li_sts = assessment(lstr_assessment, pl_problem_id, pi_diagnosis_sequence)
if li_sts <= 0 then return ls_null

return f_assessment_description(lstr_assessment)

end function

public function string assessment_bitmap (str_assessment_description pstr_assessment);str_assessment_type lstr_assessment_type
integer li_sts

li_sts = parent_patient.assessments.get_assessment_type(pstr_assessment.assessment_type, lstr_assessment_type)
if li_sts <= 0 then return "icon019.bmp"

if isnull(pstr_assessment.assessment_status) then return lstr_assessment_type.icon_open

if isnull(current_patient.open_encounter) then return lstr_assessment_type.icon_closed

if pstr_assessment.end_date <= current_patient.open_encounter_date then
	return lstr_assessment_type.icon_open
else
	return lstr_assessment_type.icon_closed
end if

return lstr_assessment_type.icon_closed

end function

public function string assessment_type (long pl_problem_id);string ls_null
str_assessment_description lstr_assessment
integer li_sts
integer li_diagnosis_sequence

setnull(ls_null)
setnull(li_diagnosis_sequence)

li_sts = assessment(lstr_assessment, pl_problem_id, li_diagnosis_sequence)
if li_sts <= 0 then return ls_null

return lstr_assessment.assessment_type

end function

public function integer set_progress (long pl_problem_id, integer pi_diagnosis_sequence, string ps_progress_type, string ps_progress, string ps_severity);u_attachment_list luo_attachment_list
datetime ldt_now

setnull(luo_attachment_list)

ldt_now = datetime(today(), now())

return set_progress(pl_problem_id, pi_diagnosis_sequence, ps_progress_type, ps_progress, ps_severity, ldt_now, luo_attachment_list)


end function

public function integer set_progress (long pl_problem_id, integer pi_diagnosis_sequence, string ps_progress_type, string ps_progress, string ps_severity, datetime pdt_progress_date_time, u_attachment_list puo_attachment_list);long ll_attachment_id

if isnull(puo_attachment_list) or not isvalid(puo_attachment_list) then
	setnull(ll_attachment_id)
else
	ll_attachment_id = puo_attachment_list.attachment_id
end if

return set_progress(pl_problem_id, pi_diagnosis_sequence, ps_progress_type, ps_progress, ps_severity, pdt_progress_date_time, ll_attachment_id)


end function

public function integer set_progress (long pl_problem_id, integer pi_diagnosis_sequence, string ps_progress_type, string ps_progress, string ps_severity, datetime pdt_progress_date_time, long pl_attachment_id);string ls_progress_key
long ll_risk_level

setnull(ls_progress_key)
setnull(ll_risk_level)

return set_progress(pl_problem_id, &
							pdt_progress_date_time, &
							pi_diagnosis_sequence, &
							ps_progress_type, &
							ls_progress_key, &
							ps_progress, &
							ps_severity, &
							pl_attachment_id, &
							ll_risk_level)


end function

public function integer set_progress (long pl_problem_id, datetime pdt_progress_date_time, integer pi_diagnosis_sequence, string ps_progress_type, string ps_progress_key, string ps_progress, string ps_severity, long pl_attachment_id, long pl_risk_level);string ls_find
long ll_row
//string ls_original_assessment_status
string ls_new_assessment_status
datetime ldt_end_date
long ll_close_encounter_id
integer li_sts
integer ll_patient_workplan_item_id

setnull(ll_patient_workplan_item_id)

if isnull(parent_patient.open_encounter) then
	log.log(this, "u_ds_assessment.set_progress:0013", "No Open Encounter", 4)
	return -1
end if

if isnull(ps_progress_type) or trim(ps_progress_type) = "" then
	log.log(this, "u_ds_assessment.set_progress:0018", "Invalid progress type", 4)
	return -1
end if

if ps_progress = "" then setnull(ps_progress)
if ps_severity = "" then setnull(ps_severity)

ls_find = "problem_id=" + string(pl_problem_id)

// If no diagnosis_sequence is provided, then we'll just get the first record
// which will be the latest diagnosis sequence
if not isnull(pi_diagnosis_sequence) then
	ls_find += " AND diagnosis_sequence=" + string(pi_diagnosis_sequence)
end if

ll_row = find(ls_find, 1, rowcount())
if ll_row <= 0 then
	log.log(this, "u_ds_assessment.set_progress:0035", "assessment not found", 4)
	return -1
end if

if isnull(pi_diagnosis_sequence) then pi_diagnosis_sequence = object.diagnosis_sequence[ll_row]


li_sts = f_set_progress2(current_patient.cpr_id, &
								"Assessment", &
								pl_problem_id, &
								ps_progress_type, &
								ps_progress_key, &
								ps_progress, &
								pdt_progress_date_time, &
								pl_risk_level, &
								pl_attachment_id, &
								ll_patient_workplan_item_id, &
								pi_diagnosis_sequence, &
								ps_severity)
if li_sts < 0 then return -1

li_sts = reselectrow(ll_row)
cache_valid[ll_row] = false

ls_new_assessment_status = object.assessment_status[ll_row]
if isnull(ls_new_assessment_status) then ls_new_assessment_status = "Open"

// Removed code to close treatments because close treatment service
// and p_Assessment_Progress trigger are handling the treatment closes now

if upper(ls_new_assessment_status) = "CANCELLED" then
	icd_part_count_calculate()
end if

return 1

end function

public function integer assessment (ref str_assessment_description pstr_assessment, long pl_problem_id, integer pi_diagnosis_sequence);long ll_row,ll_problem_id
string ls_find
boolean lb_default_grant

ll_row = get_assessment_row(pl_problem_id, pi_diagnosis_sequence)
if ll_row <= 0 then return 0

pstr_assessment.problem_id = object.problem_id[ll_row]
pstr_assessment.diagnosis_sequence = object.diagnosis_sequence[ll_row]
pstr_assessment.assessment_type = object.assessment_type[ll_row]
pstr_assessment.assessment_id = object.assessment_id[ll_row]
pstr_assessment.assessment = object.assessment[ll_row]
pstr_assessment.open_encounter_id = object.open_encounter_id[ll_row]
pstr_assessment.begin_date = object.begin_date[ll_row]
pstr_assessment.assessment_status = object.assessment_status[ll_row]
pstr_assessment.end_date = object.end_date[ll_row]
pstr_assessment.close_encounter_id = object.close_encounter_id[ll_row]
pstr_assessment.icd10_code = object.icd10_code[ll_row]
pstr_assessment.diagnosed_by = object.diagnosed_by[ll_row]
pstr_assessment.created = object.created[ll_row]
pstr_assessment.created_by = object.created_by[ll_row]
pstr_assessment.location = object.location[ll_row]
pstr_assessment.acuteness = object.acuteness[ll_row]
pstr_assessment.sort_sequence = object.sort_sequence[ll_row]

if int(object.default_grant[ll_row]) = 0 then
	lb_default_grant = false
else
	lb_default_grant = true
end if
pstr_assessment.access_control_list = current_patient.get_access_control_list( "Assessment", &
																										pstr_assessment.problem_id, &
																										lb_default_grant)

return 1

end function

public function integer assessment (ref u_str_assessment puo_assessment, long pl_problem_id, integer pi_diagnosis_sequence);long ll_row
string ls_find
long ll_problem_id

ll_row = get_assessment_row(pl_problem_id, pi_diagnosis_sequence)
if ll_row <= 0 then return 0

if isnull(puo_assessment) or not isvalid(puo_assessment) then puo_assessment = CREATE u_str_assessment

puo_assessment.problem_id = object.problem_id[ll_row]
puo_assessment.diagnosis_sequence = object.diagnosis_sequence[ll_row]
puo_assessment.assessment_type = object.assessment_type[ll_row]
puo_assessment.assessment_id = object.assessment_id[ll_row]
puo_assessment.assessment = object.assessment[ll_row]
puo_assessment.open_encounter_id = object.open_encounter_id[ll_row]
puo_assessment.begin_date = object.begin_date[ll_row]
puo_assessment.diagnosed_by = object.diagnosed_by[ll_row]
puo_assessment.created = object.created[ll_row]
puo_assessment.created_by = object.created_by[ll_row]

puo_assessment.assessment_status = object.assessment_status[ll_row]
puo_assessment.end_date = object.end_date[ll_row]
puo_assessment.close_encounter_id = object.close_encounter_id[ll_row]
puo_assessment.icd10_code = object.icd10_code[ll_row]

puo_assessment.location = object.location[ll_row]
puo_assessment.acuteness = object.acuteness[ll_row]
puo_assessment.sort_sequence = object.sort_sequence[ll_row]

parent_patient.attachments.assessment_attachment_list(puo_assessment.attachment_list, ll_problem_id)

puo_assessment.ib_exists = true
puo_assessment.updated = false
puo_assessment.deleted = false

puo_assessment.parent_patient = parent_patient

return 1

end function

public function integer get_encounter_assessments (long pl_encounter_id, ref str_assessment_description pstra_assessments[]);return get_encounter_assessments(pl_encounter_id, false, pstra_assessments)

end function

public function string assessment_description (long pl_problem_id);integer li_diagnosis_sequence

setnull(li_diagnosis_sequence)

return assessment_description(pl_problem_id, li_diagnosis_sequence)

end function

public function integer get_assessments (string ps_find, ref str_assessment_description pstra_assessments[]);long ll_row
long ll_rowcount
integer li_count
string ls_find


ll_rowcount = rowcount()
li_count = 0
ll_row = 0

ls_find = "(" + ps_find + ") and (isnull(assessment_status) or assessment_status <> 'CANCELLED')"

DO
	ll_row = find(ls_find, ll_row + 1, ll_rowcount + 1)
	if ll_row <= 0 or ll_row > ll_rowcount then exit
	
	li_count++
	pstra_assessments[li_count] = get_assessment(ll_row)
LOOP WHILE true


return li_count

end function

public function string assessment_assessment (long pl_problem_id);string ls_null
str_assessment_description lstr_assessment
integer li_sts
integer li_diagnosis_sequence

setnull(ls_null)
setnull(li_diagnosis_sequence)

li_sts = assessment(lstr_assessment, pl_problem_id, li_diagnosis_sequence)
if li_sts <= 0 then return ls_null

return lstr_assessment.assessment

end function

private function str_assessment_description get_assessment (long pl_row);boolean lb_default_grant

if cache_valid[pl_row] then return cache[pl_row]


cache[pl_row].problem_id = object.problem_id[pl_row]
cache[pl_row].diagnosis_sequence = object.diagnosis_sequence[pl_row]
cache[pl_row].assessment_id = object.assessment_id[pl_row]
cache[pl_row].assessment_type = object.assessment_type[pl_row]
cache[pl_row].assessment = object.assessment[pl_row]
cache[pl_row].begin_date = object.begin_date[pl_row]
cache[pl_row].end_date = object.end_date[pl_row]
cache[pl_row].open_encounter_id = object.open_encounter_id[pl_row]
cache[pl_row].close_encounter_id = object.close_encounter_id[pl_row]
cache[pl_row].assessment_status = object.assessment_status[pl_row]
cache[pl_row].icd10_code = object.icd10_code[pl_row]
cache[pl_row].location = object.location[pl_row]
cache[pl_row].acuteness = object.acuteness[pl_row]
cache[pl_row].sort_sequence = object.sort_sequence[pl_row]

if int(object.default_grant[pl_row]) = 0 then
	lb_default_grant = false
else
	lb_default_grant = true
end if
cache[pl_row].access_control_list = current_patient.get_access_control_list( "Assessment", &
																										cache[pl_row].problem_id, &
																										lb_default_grant)

cache_valid[pl_row] = true

return cache[pl_row]

end function

public function long add_assessment (long pl_open_encounter_id, string ps_assessment_type, string ps_assessment_id, string ps_assessment, long pl_attachment_id, datetime pdt_begin_date, string ps_diagnosed_by, string ps_location, string ps_created_by);integer li_sts
long ll_problem_id
integer li_diagnosis_sequence
long ll_row
long i, j
long ll_open_encounter_id
long ll_sort_sequence
long ll_new_sort_sequence
string ls_new_assessment_sort
long ll_rowcount_before_insert
long ll_first_row_for_encounter
long ll_last_row_for_encounter
string ls_find

log.log(this, "u_ds_assessment.add_assessment:0015", "Adding assessment " + ps_assessment_id, 1)

li_sts = tf_get_next_key(parent_patient.cpr_id, "PROBLEM_ID", ll_problem_id)
if li_sts <= 0 then
	log.log(this, "u_ds_assessment.add_assessment:0019","Unable to generate problem_id key", 4)
	return 0
end if

li_diagnosis_sequence = next_diagnosis_sequence(ll_problem_id)

ll_rowcount_before_insert = rowcount()

if ll_rowcount_before_insert > 0 then
	for i = 1 to ll_rowcount_before_insert
		object.sort_sequence[i] = i
	next
	ls_find = "open_encounter_id=" + string(pl_open_encounter_id)
	ll_first_row_for_encounter = find(ls_find, 1, ll_rowcount_before_insert)
	if ll_first_row_for_encounter = 0 then ll_first_row_for_encounter = 1
	ll_last_row_for_encounter = find(ls_find, ll_rowcount_before_insert, 1)
end if

ll_row = insertrow(0)
cache_valid[ll_row] = false

object.cpr_id[ll_row] = parent_patient.cpr_id
object.problem_id[ll_row] = ll_problem_id
object.diagnosis_sequence[ll_row] = li_diagnosis_sequence
object.open_encounter_id[ll_row] = pl_open_encounter_id
object.assessment_type[ll_row] = ps_assessment_type
object.assessment_id[ll_row] = ps_assessment_id
object.assessment[ll_row] = ps_assessment
object.diagnosed_by[ll_row] = ps_diagnosed_by
object.location[ll_row] = ps_location
object.created_by[ll_row] = ps_created_by


// See if the user wants assessments sorted ascending or descending
setnull(ll_new_sort_sequence)
if ll_rowcount_before_insert > 0 then
	ls_new_assessment_sort = datalist.get_preference("PREFERENCES", "new_assessment_sort", "Ascending")
	if upper(left(ls_new_assessment_sort, 1)) = "A" then
		if ll_rowcount_before_insert > ll_last_row_for_encounter then
			ll_new_sort_sequence = object.sort_sequence[ll_last_row_for_encounter + 1]
			// Make room for the new assessment right after the last record for the encounter
			for i = ll_rowcount_before_insert - 1 to ll_last_row_for_encounter + 1 step -1
				object.sort_sequence[i] = object.sort_sequence[i + 1]
			next
			object.sort_sequence[ll_rowcount_before_insert] = object.sort_sequence[ll_rowcount_before_insert] + 1
		else
			ll_new_sort_sequence = object.sort_sequence[ll_last_row_for_encounter] + 1
		end if
	else
		ll_new_sort_sequence = object.sort_sequence[ll_first_row_for_encounter]
		if ll_rowcount_before_insert > ll_first_row_for_encounter then
			// Make room for the new assessment right before the first record for the encounter
			for i = ll_rowcount_before_insert - 1 to ll_first_row_for_encounter step -1
				object.sort_sequence[i] = object.sort_sequence[i + 1]
			next
		end if
		object.sort_sequence[ll_rowcount_before_insert] = object.sort_sequence[ll_rowcount_before_insert] + 1
	end if
end if

if isnull(ll_new_sort_sequence) then ll_new_sort_sequence = 1
object.sort_sequence[ll_row] = ll_new_sort_sequence


if isnull(pdt_begin_date) then
	// If the begin_date is null then use the encounter date if it exists
	if isnull(pl_open_encounter_id) then
		object.begin_date[ll_row] = datetime(today(), now())
	else
		object.begin_date[ll_row] = current_patient.encounters.encounter_date(pl_open_encounter_id)
	end if
else
	object.begin_date[ll_row] = pdt_begin_date
end if


object.icd10_code[ll_row] = datalist.assessment_icd10_code(ps_assessment_id)


sort()

update()


if not isnull(pl_attachment_id) and pl_attachment_id > 0 then
	save_attachment(ll_problem_id, li_diagnosis_sequence, pl_attachment_id)
end if

return ll_problem_id


end function

protected function integer display_progress_old (u_rich_text_edit puo_rte, long pl_problem_id, string ps_progress_type);///////////////////////////////////////////////////////////////////////////////////////////////////////
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
long ll_row
long i
long ll_left
long ll_wrap
long ll_right
str_progress			lstra_assessment_progress[]

//get_attribute("progress_left_margin", ll_left)
//if isnull(ll_left) then ll_left = 0
//
//get_attribute("progress_wrap_margin", ll_wrap)
//if isnull(ll_wrap) then ll_wrap = 2000
//
//get_attribute("progress_right_margin", ll_right)
//if isnull(ll_right) then ll_right = 1900
//
//puo_rte.set_margins(ll_left, ll_wrap, ll_right)
//puo_rte.set_margins(0, 2000, 1900)

puo_rte.set_bold(true)
puo_rte.add_text(ps_progress_type)
puo_rte.set_bold(true)
puo_rte.add_cr()

//ll_count = current_patient.assessments.get_progress_values(pl_problem_id, ps_progress_type, lstra_assessment_progress)
if ll_count <= 0 then
	puo_rte.delete_last_line()
else
	for i = 1 to ll_count
		puo_rte.add_text(lstra_assessment_progress[i].progress_key)
		puo_rte.add_tab()
		puo_rte.add_text(lstra_assessment_progress[i].progress)
		puo_rte.add_cr()
	next
end if

return 1

end function

public function integer display_progress_old (u_rich_text_edit puo_rte, long pl_problem_id);long ll_type_count
integer li_sts
long i
u_ds_data luo_progress_types
string ls_display_flag
string ls_progress_type
string ls_assessment_type
string ls_find
long ll_row

ls_find = "problem_id=" + string(pl_problem_id)
ll_row = find(ls_find, 1, rowcount())
if ll_row <= 0 then return 0

ls_assessment_type = object.assessment_type[ll_row]

luo_progress_types = CREATE u_ds_data
luo_progress_types.set_dataobject("dw_c_assessment_type_progress_type")
ll_type_count = luo_progress_types.retrieve(ls_assessment_type)

for i = 1 to ll_type_count
	ls_display_flag = luo_progress_types.object.display_flag[i]
	if upper(ls_display_flag) = "Y" then
		ls_progress_type = luo_progress_types.object.progress_type[i]
//		li_sts = display_progress(puo_rte, pl_problem_id, ls_progress_type)
	end if
next

DESTROY luo_progress_types

return 1

end function

public function long get_assessment_row (long pl_problem_id, integer pi_diagnosis_sequence);long ll_row
string ls_find
long ll_problem_id

if isnull(pl_problem_id) then return 0

ls_find = "problem_id=" + string(pl_problem_id)
if pi_diagnosis_sequence > 0 then
	ls_find += " and diagnosis_sequence=" + string(pi_diagnosis_sequence)
end if

ll_row = find(ls_find, 1, rowcount())
if ll_row <= 0 then return 0

return ll_row

end function

public function long find_object_row (long pl_object_key);integer li_diagnosis_sequence

setnull(li_diagnosis_sequence)

return get_assessment_row(pl_object_key, li_diagnosis_sequence)


end function

public function integer modify_assessment (long pl_problem_id, integer pi_diagnosis_sequence, string ps_assessment_field, string ps_new_value);string ls_progress_type
long ll_risk_level
datetime ldt_progress_date_time
string ls_severity
long ll_attachment_id

setnull(ll_risk_level)
setnull(ls_severity)
setnull(ll_attachment_id)
ldt_progress_date_time = datetime(today(), now())
ls_progress_type = "Modify"

return set_progress(pl_problem_id, &
							ldt_progress_date_time, &
							pi_diagnosis_sequence, &
							ls_progress_type, &
							ps_assessment_field, &
							ps_new_value, &
							ls_severity, &
							ll_attachment_id, &
							ll_risk_level)


end function

public function integer modify_assessment (long pl_problem_id, string ps_assessment_field, string ps_new_value);integer li_diagnosis_sequence

setnull(li_diagnosis_sequence)

return modify_assessment(pl_problem_id, li_diagnosis_sequence, ps_assessment_field, ps_new_value)

end function

public function str_property_value get_property (long pl_object_key, string ps_property, str_attributes pstr_attributes);str_property_value lstr_property_value
long ll_row

setnull(lstr_property_value.value)
setnull(lstr_property_value.display_value)
setnull(lstr_property_value.textcolor)
setnull(lstr_property_value.backcolor)
setnull(lstr_property_value.weight)

ll_row = find_object_row(pl_object_key)
if isnull(ll_row) or ll_row <= 0 then return lstr_property_value

CHOOSE CASE lower(ps_property)
	CASE ""
	CASE ELSE
		lstr_property_value = get_property(pl_object_key, ps_property)
END CHOOSE

return lstr_property_value

end function

public function integer set_progress (long pl_problem_id, string ps_progress_type, string ps_progress_key, string ps_progress, long pl_risk_level, datetime pdt_progress_date_time);string ls_severity
long ll_attachment_id
integer li_diagnosis_sequence

setnull(ls_severity)
setnull(ll_attachment_id)
setnull(li_diagnosis_sequence)

return set_progress(pl_problem_id, &
							pdt_progress_date_time, &
							li_diagnosis_sequence, &
							ps_progress_type, &
							ps_progress_key, &
							ps_progress, &
							ls_severity, &
							ll_attachment_id, &
							pl_risk_level)


end function

private subroutine icd_part_count_calculate ();long ll_rows
string ls_icd10_code
string ls_icd_part
string ls_temp
long i, j
boolean lb_found

ll_rows = rowcount()
icd_part_count = 0

for i = 1 to ll_rows
	if upper(string(object.assessment_status[i])) = "CANCELLED" then continue
	if upper(string(object.current_flag[i])) = "Y" then
		ls_icd10_code = object.icd10_code[i]
		f_split_string(ls_icd10_code, ".", ls_icd_part, ls_temp)
		if len(ls_icd_part) > 0 then
			lb_found = false
			for j = 1 to icd_part_count
				if ls_icd_part = icd_part[j].icd_part then
					lb_found = true
					icd_part[j].icd_part_count += 1
				end if
			next
			if not lb_found then
				icd_part_count += 1
				icd_part[icd_part_count].icd_part = ls_icd_part
				icd_part[j].icd_part_count = 1
			end if
		end if
	end if
next


end subroutine

public function long icd_part_count (string ps_icd10_code);long ll_rows
string ls_icd10_code
string ls_icd_part
string ls_temp
long i

if icd_part_count <= 0 then icd_part_count_calculate()

f_split_string(ps_icd10_code, ".", ls_icd_part, ls_temp)

for i = 1 to icd_part_count
	if ls_icd_part = icd_part[i].icd_part then return icd_part[i].icd_part_count
next

return 0


end function

public function integer add_assessment (ref str_assessment_description pstr_assessment);integer li_sts
long ll_problem_id
long ll_attachment_id
string ls_null
long ll_row
string ls_find
string ls_date
string ls_progress_user_id
long ll_null

setnull(ls_null)
setnull(ll_null)
setnull(ll_attachment_id)


// First see if the assessment exists

ls_date = "datetime('" + string(pstr_assessment.begin_date, "[shortdate] [time]") + "')"

ls_find = "assessment='" + pstr_assessment.assessment + "'"
ls_find += " and begin_date=" + ls_date
ll_row = find(ls_find, 1, rowcount())
if ll_row > 0 then
	ll_problem_id = object.problem_id[ll_row]
else
	// Use the current user if the diagnosed_by wasn't specified
	if isnull(pstr_assessment.diagnosed_by) then
		pstr_assessment.diagnosed_by = current_user.user_id
	end if
	
	// assessment_id is required
	if isnull(pstr_assessment.assessment_id) then
		log.log(this, "u_ds_assessment.add_assessment:0032", "assessment_id is required for new records", 4)
		return -1
	end if
	
	if isnull(pstr_assessment.diagnosed_by) then
		ls_progress_user_id = current_user.user_id
	else
		ls_progress_user_id = pstr_assessment.diagnosed_by
	end if
	
	// The assessment doesn't exist, so add it
	ll_problem_id = current_patient.assessments.add_assessment( &
																					current_patient.open_encounter_id, &
																					pstr_assessment.assessment_type, &
																					pstr_assessment.assessment_id, &
																					pstr_assessment.assessment, &
																					ll_attachment_id, &
																					pstr_assessment.begin_date, &
																					pstr_assessment.diagnosed_by, &
																					pstr_assessment.location, &
																					current_scribe.user_id &
																					)

	ll_row = find_object_row(ll_problem_id)
	if ll_row <= 0 then return -1
	
	if not isnull(pstr_assessment.end_date) OR lower(pstr_assessment.assessment_status) = "closed" then
		if isnull(pstr_assessment.end_date) then pstr_assessment.end_date = pstr_assessment.begin_date
		sqlca.sp_set_assessment_progress(current_patient.cpr_id, &
													ll_problem_id, &
													current_patient.open_encounter_id, &
													pstr_assessment.end_date, &
													1, &  
													"CLOSED", &
													ls_null, &
													ls_null, &
													ls_null, &  
													ll_null, &
													ll_null, &
													ll_null, &  
													ls_progress_user_id, &  
													current_scribe.user_id)
		if not tf_check() then return -1
		li_sts = reselectrow(ll_row)
		cache_valid[ll_row] = false
	end if

	if not isnull(pstr_assessment.acuteness) then
		sqlca.sp_set_assessment_progress(current_patient.cpr_id, &
													ll_problem_id, &
													current_patient.open_encounter_id, &
													pstr_assessment.begin_date, &
													1, &  
													"Modify", &
													"Acuteness", &
													pstr_assessment.acuteness, &
													ls_null, &  
													ll_null, &
													ll_null, &
													ll_null, &  
													ls_progress_user_id, &  
													current_scribe.user_id)
		if not tf_check() then return -1
		li_sts = reselectrow(ll_row)
		cache_valid[ll_row] = false
	end if
end if

// Get the latest state of the assessment
li_sts = current_patient.assessments.assessment(pstr_assessment, ll_problem_id)

return li_sts


end function

public function integer get_encounter_assessments (long pl_encounter_id, boolean pb_include_deleted, ref str_assessment_description pstra_assessments[]);string ls_find
str_encounter_description lstr_encounter
integer li_sts
string ls_date
long ll_row
long ll_rowcount
integer li_count
long ll_lastrow
str_assessment_description lstra_assessments[]
integer lia_order[]
integer i, j
integer li_temp

li_sts = current_patient.encounters.encounter(lstr_encounter, pl_encounter_id)
ls_date = "datetime('" + string(lstr_encounter.encounter_date, "[shortdate] [time]") + "')"
ll_rowcount = rowcount()
li_count = 0

//
// First we want all the assessments created in this encounter
//

ls_find = "open_encounter_id=" + string(lstr_encounter.encounter_id)
if not pb_include_deleted then
	ls_find = "(" + ls_find + ") and (isnull(assessment_status) or assessment_status <> 'CANCELLED')"
end if

// Find the rows from the end because they are stored in the datastore in descending order
// and we want them displayed in ascending order
ll_row = find(ls_find, ll_rowcount, 1)
DO WHILE ll_row > 0 and ll_row <= ll_rowcount
	li_count++
	lstra_assessments[li_count] = get_assessment(ll_row)
	
	ll_lastrow = ll_row
	ll_row = find(ls_find, ll_row - 1, 0)
	if ll_row >= ll_lastrow then exit
LOOP


//
// Then add all the assessments in this encounter but which weren't created in this encounter
//

// Initialize the find string
ls_find = "("

// Add all the assessments which were closed in this encounter
ls_find += " (close_encounter_id=" + string(lstr_encounter.encounter_id) + ")"

// Add all the assessments which started before this encounter and ended after this encounter
ls_find += " or (begin_date<=" + ls_date + " and (isnull(end_date) or end_date>=" + ls_date + "))"

// Terminate the "or" clauses
ls_find += ")"

// Exclude all the assessments which were opened in this encounter
ls_find += " and (open_encounter_id<>" + string(lstr_encounter.encounter_id) + ")"

// Now exclude the cancelled assessments
if not pb_include_deleted then
	ls_find += " and (isnull(assessment_status) or assessment_status <> 'CANCELLED')"
end if

ll_row = find(ls_find, 1, ll_rowcount)
DO WHILE ll_row > 0 and ll_row <= ll_rowcount
	li_count++
	lstra_assessments[li_count] = get_assessment(ll_row)
	
	ll_row = find(ls_find, ll_row + 1, ll_rowcount + 1)
LOOP


// Finally, sort the encounters into the return param
for i = 1 to li_count
	lia_order[i] = i
next
for i = 1 to li_count - 1
	for j = i + 1 to li_count
		if lstra_assessments[lia_order[i]].sort_sequence > lstra_assessments[lia_order[j]].sort_sequence then
			// these two are in the wrong order so swap them
			li_temp = lia_order[i]
			lia_order[i] = lia_order[j]
			lia_order[j] = li_temp
		end if
	next
next
			
for i = 1 to li_count
	pstra_assessments[i] = lstra_assessments[lia_order[i]]
next

return li_count





end function

public subroutine set_assessment_changed (long pl_problem_id);string ls_find
long ll_row
integer li_sts

ls_find = "problem_id=" + string(pl_problem_id)
ll_row = find(ls_find, 1, rowcount())
if ll_row <= 0 then
	log.log(this, "u_ds_assessment.set_assessment_changed:0008", "assessment not found", 4)
	return 
end if

li_sts = reselectrow(ll_row)
cache_valid[ll_row] = false

return

end subroutine

on u_ds_assessment.create
call super::create
end on

on u_ds_assessment.destroy
call super::destroy
end on

event constructor;call super::constructor;context_object = "Assessment"

end event

event retrieveend;call super::retrieveend;long i

icd_part_count = 0

for i = 1 to rowcount
	cache_valid[i] = false
next

end event

