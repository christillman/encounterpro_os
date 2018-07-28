$PBExportHeader$u_str_assessment.sru
forward
global type u_str_assessment from nonvisualobject
end type
type str_therapy_item from structure within u_str_assessment
end type
end forward

type str_therapy_item from structure
    integer therapy_item_sequence
    string treatment_type
    integer administration_sequence
    string drug_id
    string package_id
    string specialty_id
    string observation_id
    string procedure_id
    integer relative_start_day
    real duration_amount
    string duration_unit
    string duration_prn
    real dispense_amount
    string dispense_unit
    string brand_name_required
    string treatment_description
    string treatment_goal
    string appointment_responsible
    string attach_subjective_flag
    string attach_objective_flag
    string attach_treatment_flag
    string referral_question
    string referral_question_assmnt_id
    integer parent_therapy_item_sequence
    integer treatment_sequence
    integer parent_treatment_sequence
    string special_instructions
end type

global type u_str_assessment from nonvisualobject
end type
global u_str_assessment u_str_assessment

type variables
string assessment_status, assessment_type
string created_by, diagnosed_by
string assessment_id, assessment,icd9_code

long close_encounter_id, open_encounter_id
long problem_id

string location
string acuteness
long sort_sequence

integer diagnosis_sequence

datetime begin_date, end_date, created

boolean exists, deleted, updated

u_attachment_list attachment_list
u_patient parent_patient

string new_treatment_service = "ORDERTREATMENT"


end variables

forward prototypes
public function boolean any_completed_treatments ()
public function integer check_updated_old (u_sqlca p_sqlca)
public function string bitmap (u_str_encounter puo_encounter)
public function integer add_progress (string ps_progress_type, string ps_progress, long pl_attachment_id)
public function boolean in_encounter (long pl_encounter_id)
public function integer add_progress (string ps_progress_type, string ps_progress, string ps_severity, long pl_attachment_id)
public function integer save_attachments ()
public function integer save_attachment ()
public subroutine display_properties ()
public function integer add_progress (string ps_progress_type, string ps_progress, string ps_severity, datetime pdt_progress_date_time, long pl_attachment_id)
public function u_component_treatment find_treatment (long pi_treatment_id)
public function integer add_progress (string ps_progress_type, datetime pdt_progress_date_time)
public function integer save_old ()
end prototypes

public function boolean any_completed_treatments ();return parent_patient.treatments.any_completed_treatments(problem_id)


end function

public function integer check_updated_old (u_sqlca p_sqlca);//// FUNCTION		check_updated()
////
//// PURPOSE		This function checks the p_Patient table to see if this patient
////					data has been updated since it was loaded into memory.
////
//// PARAMETERS	None
////
////	RETURNS		0 = not updated
////					1 = updated
////					-1 = error
//
//integer li_sts
//datetime ldt_last_update
//
//if not exists then return 0
//
//if isnull(last_update) then
//	log.log(this, "check_updated()", "Assessment Last update is null (" + parent_patient.cpr_id + "," + string(problem_id) + ")", 3)
//	return 1
//end if
//
//p_sqlca.begin_transaction(this, "check_updated (" + parent_patient.cpr_id + "," + string(problem_id) + ")")
//
//SELECT last_update
//INTO :ldt_last_update
//FROM p_Assessment (NOLOCK)
//WHERE	cpr_id = :parent_patient.cpr_id
//AND problem_id = :problem_id
//USING p_sqlca;
//if not p_sqlca.check() then return -1
//
//if sqlca.sqlcode = 0 then
//	if ldt_last_update > last_update then
//		li_sts = 1
//	else
//		li_sts = 0
//	end if
//elseif sqlca.sqlcode = 100 then
//	log.log(this, "check_updated()", "Problem # " + parent_patient.cpr_id + "," + string(problem_id) + " is not found", 4)
//	li_sts = -1
//end if
//
//p_sqlca.commit_transaction()
//
//return li_sts
//	
//
return 1
end function

public function string bitmap (u_str_encounter puo_encounter);str_assessment_type lstr_assessment_type
integer li_sts

li_sts = parent_patient.assessments.get_assessment_type(assessment_type, lstr_assessment_type)
if li_sts <= 0 then return "icon019.bmp"

if isnull(assessment_status) then return lstr_assessment_type.icon_open

if isnull(puo_encounter) then return lstr_assessment_type.icon_closed

if end_date <= puo_encounter.encounter_date then
	return lstr_assessment_type.icon_open
else
	return lstr_assessment_type.icon_closed
end if

return lstr_assessment_type.icon_closed
end function

public function integer add_progress (string ps_progress_type, string ps_progress, long pl_attachment_id);string ls_severity

setnull(ls_severity)

return add_progress(ps_progress_type, ps_progress, ls_severity, pl_attachment_id)

end function

public function boolean in_encounter (long pl_encounter_id);string ls_bill_flag


SELECT bill_flag
INTO :ls_bill_flag
FROM p_Encounter_Assessment
WHERE cpr_id = :parent_patient.cpr_id
AND encounter_id = :pl_encounter_id
AND problem_id = :problem_id;
if not tf_check() then return false
if sqlca.sqlcode = 100 then return false

if ls_bill_flag = "N" then return false

return true

end function

public function integer add_progress (string ps_progress_type, string ps_progress, string ps_severity, long pl_attachment_id);return parent_patient.assessments.set_progress(problem_id, diagnosis_sequence, ps_progress_type, ps_progress, ps_severity)

end function

public function integer save_attachments ();integer i
integer li_sts = 1
long ll_attachment_id

if isnull(attachment_list) then
	setnull(ll_attachment_id)
elseif attachment_list.attachment_count <= 0 then
	setnull(ll_attachment_id)
else
	ll_attachment_id = attachment_list.attachment_id
end if

UPDATE p_Assessment
SET	attachment_id = :ll_attachment_id
WHERE	cpr_id = :parent_patient.cpr_id
AND	problem_id = :problem_id
AND   diagnosis_sequence = :diagnosis_sequence;
if not tf_check() then return -1

return 1


end function

public function integer save_attachment ();long ll_attachment_id

if isnull(attachment_list) then
	setnull(ll_attachment_id)
elseif attachment_list.attachment_count <= 0 then
	setnull(ll_attachment_id)
else
	ll_attachment_id = attachment_list.attachment_id
end if

return parent_patient.assessments.save_attachment(problem_id, diagnosis_sequence, ll_attachment_id)

end function

public subroutine display_properties ();str_popup popup

popup.objectparm = this
openwithparm(w_assessment_properties, popup)

end subroutine

public function integer add_progress (string ps_progress_type, string ps_progress, string ps_severity, datetime pdt_progress_date_time, long pl_attachment_id);return parent_patient.assessments.set_progress(problem_id, diagnosis_sequence, ps_progress_type, ps_progress, ps_severity, pdt_progress_date_time)

end function

public function u_component_treatment find_treatment (long pi_treatment_id);integer li_sts
u_component_treatment luo_treatment

li_sts = parent_patient.treatments.treatment(luo_treatment, pi_treatment_id)
if li_sts <= 0 then setnull(luo_treatment)

return luo_treatment


end function

public function integer add_progress (string ps_progress_type, datetime pdt_progress_date_time);string ls_progress
string ls_severity

setnull(ls_progress)
setnull(ls_severity)

return parent_patient.assessments.set_progress(problem_id, diagnosis_sequence, ps_progress_type,&
																ls_progress, ls_severity, pdt_progress_date_time)

end function

public function integer save_old ();integer i
integer li_sts = 1
long ll_attachment_id

if isnull(attachment_list) then
	setnull(ll_attachment_id)
elseif attachment_list.attachment_count <= 0 then
	setnull(ll_attachment_id)
else
	ll_attachment_id = attachment_list.attachment_id
end if


tf_begin_transaction(this, "save (" + assessment_id + ")")

if deleted and exists then 
	DELETE FROM p_Assessment
	WHERE	cpr_id = :parent_patient.cpr_id
	AND	problem_id = :problem_id
	AND   diagnosis_sequence = :diagnosis_sequence;
	if not tf_check() then return -1
	exists = false
	updated = false
	if sqlca.sqlcode = 100 then
		li_sts = 0
	else
		li_sts = 1
	end if
elseif exists and updated and not deleted then
	UPDATE p_Assessment
	SET	attachment_id = :ll_attachment_id
	WHERE	cpr_id = :parent_patient.cpr_id
	AND	problem_id = :problem_id
	AND   diagnosis_sequence = :diagnosis_sequence;
	if not tf_check() then return -1
	updated = false
	if sqlca.sqlcode = 100 then
		li_sts = 0
	else
		li_sts = 1
	end if
elseif not exists and not deleted then

	INSERT INTO p_Assessment
			(
			cpr_id,
			problem_id,   
			diagnosis_sequence,
			assessment_type,
         assessment_id,
			assessment,
         open_encounter_id,   
         attachment_id,   
         begin_date,
			created_by
			)
	VALUES
			(
			:parent_patient.cpr_id,
			:problem_id,
			:diagnosis_sequence,
			:assessment_type,
         :assessment_id,
			:assessment,
         :open_encounter_id,
         :ll_attachment_id,
         :begin_date,
			:created_by
			) ;
	if not tf_check() then return -1
	exists = true
	updated = false

	if sqlca.sqlcode = 100 then
		li_sts = 0
	else
		li_sts = 1
	end if

end if

tf_commit()

return li_sts
end function

on u_str_assessment.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_str_assessment.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;if isvalid(attachment_list) and not isnull(attachment_list) then DESTROY attachment_list

end event

