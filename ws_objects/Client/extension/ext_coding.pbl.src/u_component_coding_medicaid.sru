$PBExportHeader$u_component_coding_medicaid.sru
forward
global type u_component_coding_medicaid from u_component_coding
end type
type str_assessment_types from structure within u_component_coding_medicaid
end type
type str_problem_assessment_types from structure within u_component_coding_medicaid
end type
end forward

type str_assessment_types from structure
	string		assessment_type
	string		bill_flag
end type

type str_problem_assessment_types from structure
	long		problem_id
	string		assessment_type
end type

global type u_component_coding_medicaid from u_component_coding
end type
global u_component_coding_medicaid u_component_coding_medicaid

type variables
string well_sick_visit_procedure

end variables

forward prototypes
public function integer xx_initialize ()
protected function long other_encounter (ref string psa_procedure_id[])
protected function integer xx_encounter_procedure (ref string psa_procedure_id[])
public function integer well_encounter (ref string psa_procedure_id[])
end prototypes

public function integer xx_initialize ();
well_sick_visit_procedure = get_attribute("well_sick_visit_procedure")

if isnull(well_sick_visit_procedure) then
	SELECT min(procedure_id)
	INTO :well_sick_visit_procedure
	FROM c_Procedure
	WHERE cpt_code = '99212'
	AND status = 'OK'
	USING cprdb;
	if not cprdb.check() then return -1
	if cprdb.sqlcode = 100 then setnull(well_sick_visit_procedure)
end if

return 1

end function

protected function long other_encounter (ref string psa_procedure_id[]);long ll_visit_level
string ls_procedure_id

//CWW, BEGIN
u_ds_data luo_sp_get_default_encounter_proc
integer li_spdw_count
// DECLARE lsp_get_default_encounter_proc PROCEDURE FOR dbo.sp_get_default_encounter_proc  
//         @ps_encounter_type = :encounter_type,   
//         @ps_new_flag = :new_flag,   
//         @pl_visit_level = :ll_visit_level,   
//         @ps_procedure_id = :ls_procedure_id OUT
//	USING cprdb;
//CWW, END

ll_visit_level = f_current_visit_level(cpr_id, encounter_id)

//CWW, BEGIN
//EXECUTE lsp_get_default_encounter_proc;
//if not cprdb.check() then return -1
//FETCH lsp_get_default_encounter_proc INTO :ls_procedure_id;
//if not cprdb.check() then return -1
//CLOSE lsp_get_default_encounter_proc;
luo_sp_get_default_encounter_proc = CREATE u_ds_data
luo_sp_get_default_encounter_proc.set_dataobject("dw_sp_get_default_encounter_proc")
li_spdw_count = luo_sp_get_default_encounter_proc.retrieve(encounter_type, new_flag, ll_visit_level)
if li_spdw_count <= 0 then
	setnull(ls_procedure_id)
else
	ls_procedure_id = luo_sp_get_default_encounter_proc.object.procedure_id[1]
end if
destroy luo_sp_get_default_encounter_proc
//CWW, END

if isnull(ls_procedure_id) then return 0

psa_procedure_id[1] = ls_procedure_id

return 1

end function

protected function integer xx_encounter_procedure (ref string psa_procedure_id[]);if is_billed("WELL") then
	return well_encounter(psa_procedure_id)
else
	return other_encounter(psa_procedure_id)
end if


end function

public function integer well_encounter (ref string psa_procedure_id[]);integer li_sts
string ls_stage_id
string ls_procedure_id
long ll_problem_id
str_problem_assessment_types lstr_problems[]
integer li_count
integer i
long lla_unbilled_charges[]
integer li_codes
u_ds_data luo_data
string ls_list_id

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_procedures_by_age_range_list_id")


DECLARE lsp_set_assmnt_charge_billing PROCEDURE FOR dbo.sp_set_assmnt_charge_billing
			@ps_cpr_id = :cpr_id,
			@pl_encounter_id = :encounter_id,
			@pl_problem_id = :ll_problem_id,
			@pl_encounter_charge_id = :lla_unbilled_charges[i],
			@ps_bill_flag = 'Y',
			@ps_created_by = :current_scribe.user_id
	USING cprdb;

setnull(ll_problem_id)
li_codes = 0

if is_billed("SICK") then
	ls_list_id = get_attribute("list_id_abnormal")
	if isnull(ls_list_id) then ls_list_id = "Medicaid Visit Abnormal"

	li_count = luo_data.retrieve(cpr_id, ls_list_id)
	if li_count > 0 then
		ls_procedure_id = luo_data.object.procedure_id[li_count]
	else
		mylog.log(this, "u_component_coding_medicaid.well_encounter.0037", "Unable to get abnormal code for stage", 3)
		return 0
	end if

	li_codes += 1
	psa_procedure_id[li_codes] = ls_procedure_id

	// Now, get the first sick diagnosis billed with this encounter
	ll_problem_id = get_first_sick_problem()

	// Suppress billing for all diagnoses except the first sick assessment
	string ls_suppress
	ls_suppress = get_attribute("suppress_after_first_sick")
	if isnull(ls_suppress) then ls_suppress = "Y"
	if upper(left(ls_suppress, 1)) = "Y" then
		if ll_problem_id > 0 then
			li_count = assessments.rowcount()
			for i = 1 to li_count
				// Don't suppress the first sick diagnosis
				if long(assessments.object.problem_id[i]) <> ll_problem_id then
					if string(assessments.object.bill_flag[i]) = "Y" &
						AND assessments.object.assessment_type[i] <> "WELL" &
						AND assessments.object.assessment_type[i] <> "VACCINE" then
						assessments.object.bill_flag[i] = "X"
					end if
				end if
			next
			assessments.update()
		end if
	end if

	// When we suppressed the diagnoses, we might have caused some charges to not be attached to
	// a billed diagnosis.  Find them and attach them to the first sick diagnosis.
	li_count = get_unbilled_charges(lla_unbilled_charges)
	for i = 1 to li_count
		EXECUTE lsp_set_assmnt_charge_billing;
		if not cprdb.check() then return -1
	next

	// Finally, if we have a well_sick_visit_procedure then bill the second visit code
	if not isnull(well_sick_visit_procedure) then
		li_codes += 1
		psa_procedure_id[li_codes] = well_sick_visit_procedure
	end if
else
	ls_list_id = get_attribute("list_id_normal")
	if isnull(ls_list_id) then ls_list_id = "Medicaid Visit Normal"

	li_count = luo_data.retrieve(cpr_id, ls_list_id)
	if li_count > 0 then
		ls_procedure_id = luo_data.object.procedure_id[li_count]
	else
		mylog.log(this, "u_component_coding_medicaid.well_encounter.0037", "Unable to get normal code for stage", 3)
		return 0
	end if

	li_codes += 1
	psa_procedure_id[li_codes] = ls_procedure_id	
end if

sort_assessments_to_top("WELL")

DESTROY luo_data

return li_codes

end function

on u_component_coding_medicaid.create
call super::create
end on

on u_component_coding_medicaid.destroy
call super::destroy
end on

