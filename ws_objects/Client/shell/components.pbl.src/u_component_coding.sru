$PBExportHeader$u_component_coding.sru
forward
global type u_component_coding from u_component_base_class
end type
type str_assessment_type from structure within u_component_coding
end type
end forward

type str_assessment_type from structure
	string		assessment_type
	string		bill_flag
end type

global type u_component_coding from u_component_base_class
end type
global u_component_coding u_component_coding

type variables
private integer assessment_type_count
private str_assessment_type assessment_types[]

protected u_ds_data assessments
protected u_ds_data charges
protected u_ds_data assessment_charges

string cpr_id
long encounter_id

datetime date_of_birth
datetime encounter_date
string encounter_type
string new_flag

string coding_mode
string new_list_id
string est_list_id


end variables

forward prototypes
public function integer get_cpt_code (string ps_procedure_id, ref string ps_cpt_code, ref string ps_description)
protected function integer xx_encounter_procedure (ref string psa_procedure_id[])
public function long get_first_sick_problem ()
public function integer encounter_procedure (string ps_cpr_id, long pl_encounter_id, ref string psa_procedure_id[])
protected function boolean is_billed (string ps_assessment_type)
public subroutine sort_assessments_to_top (string ps_assessment_type)
public function integer suppress_well_assessments ()
public function integer get_unbilled_charges (long pla_charges[])
end prototypes

public function integer get_cpt_code (string ps_procedure_id, ref string ps_cpt_code, ref string ps_description);
SELECT cpt_code, description
INTO :ps_cpt_code, :ps_description
FROM c_Procedure
WHERE procedure_id = :ps_procedure_id
USING cprdb;
if not cprdb.check() then return -1
if cprdb.sqlcode = 100 then return 0

return 1

end function

protected function integer xx_encounter_procedure (ref string psa_procedure_id[]);// Date Begun: ??/??/??
// Programmer: Mark Copenhaver (MC)
//				   Charles Appel (CA)
// Purpose: 
// Expects: string	ps_cpr_id					uniquely identifies patient
//				long		pl_encounter_id			within a patient, uniquely identifies an encounter
//    		string ps_cpt_code					returns cpt code for encounter
//				string ps_description				returns cpt description for encounter
//
// Returns: integer 									
// Limits:	
// History: 

if ole_class then
	return ole.encounter_procedure(cpr_id, encounter_id, psa_procedure_id)
else
	return 100
end if

end function

public function long get_first_sick_problem ();long ll_problem_id
string ls_find
long ll_row

ls_find = "assessment_type='SICK' and bill_flag='Y'"
ls_find += "and open_encounter_id=" + string(encounter_id)
ll_row = assessments.find(ls_find, 1, assessments.rowcount())
if ll_row > 0 then
	ll_problem_id = assessments.object.problem_id[ll_row]
	return ll_problem_id
end if

// If we didn't find an assessment created in this encounter, then look for any billed assessment
ls_find = "assessment_type='SICK' and bill_flag='Y'"
ll_row = assessments.find(ls_find, 1, assessments.rowcount())
if ll_row > 0 then
	ll_problem_id = assessments.object.problem_id[ll_row]
	return ll_problem_id
end if

setnull(ll_problem_id)

return ll_problem_id

end function

public function integer encounter_procedure (string ps_cpr_id, long pl_encounter_id, ref string psa_procedure_id[]);// Date Begun: ??/??/??
// Programmer: Mark Copenhaver (MC)
//				   Charles Appel (CA)
// Purpose: 
// Expects: string	ps_cpr_id					uniquely identifies patient
//				long		pl_encounter_id			within a patient, uniquely identifies an encounter
//				string array psa_procedure_id		Array of procedures for this encounter
//
// Returns: integer:		>0	Number of procedures to bill with this encounter
//								=0	No procedures were found
//								<1 Error
// Limits:	
// History: 
string ls_cpt_code
string ls_description
long ll_count
string ls_procedure_id
string ls_null
long ll_sts
string ls_procedure_type
string ls_procedure_category_id
string ls_service
real lr_units
decimal ldc_charge
integer i, j
integer li_count
string ls_assessment_type
string ls_bill_flag
boolean lb_found
string ls_encounter_bill_flag
integer li_sts

setnull(ls_null)

cpr_id = ps_cpr_id
encounter_id = pl_encounter_id

SELECT p.date_of_birth, e.encounter_type, e.encounter_date, e.new_flag, e.bill_flag
INTO :date_of_birth, :encounter_type, :encounter_date, :new_flag, :ls_encounter_bill_flag
FROM p_Patient p, p_Patient_Encounter e
WHERE p.cpr_id = :ps_cpr_id
AND e.cpr_id = :ps_cpr_id
AND e.encounter_id = :pl_encounter_id
USING cprdb;
if not cprdb.check() then return -1

li_count = assessments.retrieve(cpr_id, encounter_id)
if li_count < 0 then return -1

li_count = charges.retrieve(cpr_id, encounter_id)
if li_count < 0 then return -1

li_count = assessment_charges.retrieve(cpr_id, encounter_id)
if li_count < 0 then return -1

// Reset the "X" bill flags
li_count = assessments.rowcount()
for i = 1 to li_count
	ls_bill_flag = assessments.object.bill_flag[i]
	if ls_bill_flag = "X" then
		assessments.object.bill_flag[i] = "Y"
	end if
next

li_sts = assessments.update()


// Construct a list of assessment types and whether or not they're billed
assessment_type_count = 0
li_count = assessments.rowcount()
for i = 1 to li_count
	ls_assessment_type = assessments.object.assessment_type[i]
	ls_bill_flag = assessments.object.bill_flag[i]
	lb_found = false

	// If we already have at least one assessment_type, then we might
	// already have this assessment_type in the list
	for j = 1 to assessment_type_count
		// Check to see if we've already got this assessment type
		if upper(ls_assessment_type) = upper(assessment_types[j].assessment_type) then
			lb_found = true
			// If so, and the current bill_flag is "Y", then update the last entries bill_flag
			if ls_bill_flag = "Y" then
				assessment_types[j].bill_flag = ls_bill_flag
			end if
			exit
		end if
	next
	
	// If this is a new assessment_type, then add it to the list
	if not lb_found then
		assessment_type_count++
		assessment_types[assessment_type_count].assessment_type = ls_assessment_type
		assessment_types[assessment_type_count].bill_flag = ls_bill_flag
	end if
next

// Get the coding mode and list_ids
coding_mode = datalist.encounter_type_coding_mode(encounter_type)
new_list_id = datalist.encounter_type_new_list_id(encounter_type)
est_list_id = datalist.encounter_type_est_list_id(encounter_type)

// Get an array of encounter charges which should be posted
ll_count = xx_encounter_procedure(psa_procedure_id)

if ll_count < 0 and upper(ls_encounter_bill_flag) = "Y" then
	mylog.log(this, "encounter_procedure()", "Error getting encounter procedure", 4)
	return -1
elseif ll_count = 0 and upper(ls_encounter_bill_flag) = "Y" then
	mylog.log(this, "encounter_procedure()", "No encounter procedure found (" + ps_cpr_id + ", " + string(pl_encounter_id) + ")", 3)
	return -1
end if

return ll_count



end function

protected function boolean is_billed (string ps_assessment_type);integer i

for i = 1 to assessment_type_count
	if assessment_types[i].assessment_type = ps_assessment_type then
		if assessment_types[i].bill_flag = "Y" or assessment_types[i].bill_flag = "X" then
			return true
		else
			return false
		end if
	end if
next

return false

end function

public subroutine sort_assessments_to_top (string ps_assessment_type);integer i
integer li_assessment_sequence
integer li_count
string ls_assessment_type
integer li_null

setnull(li_null)

li_count = assessments.rowcount()
li_assessment_sequence = 0

// First sort on the existing sort sequence
assessments.setsort("assessment_sequence a")
assessments.sort()

// Then sort the assessments of the specified type to the top
for i = 1 to li_count
	ls_assessment_type = assessments.object.assessment_type[i]
	if ls_assessment_type = ps_assessment_type then
		li_assessment_sequence += 1
		assessments.object.assessment_sequence[i] = li_assessment_sequence
	else
		assessments.object.assessment_sequence[i] = li_null
	end if
next

// Then sort the remaining assessments in their original order
for i = 1 to li_count
	if isnull(assessments.object.assessment_sequence[i]) then
		li_assessment_sequence += 1
		assessments.object.assessment_sequence[i] = li_assessment_sequence
	end if		
next

assessments.update()


end subroutine

public function integer suppress_well_assessments ();integer li_count
integer i
long lla_unbilled_charges[]
long ll_problem_id
string ls_assessment_type
integer li_sts
string ls_bill_flag

DECLARE lsp_set_assmnt_charge_billing PROCEDURE FOR dbo.sp_set_assmnt_charge_billing
			@ps_cpr_id = :cpr_id,
			@pl_encounter_id = :encounter_id,
			@pl_problem_id = :ll_problem_id,
			@pl_encounter_charge_id = :lla_unbilled_charges[i],
			@ps_bill_flag = 'Y',
			@ps_created_by = :current_scribe.user_id
	USING cprdb;

li_count = assessments.rowcount()
for i = 1 to li_count
	ls_assessment_type = assessments.object.assessment_type[i]
	ls_bill_flag = assessments.object.bill_flag[i]
	if ls_assessment_type = "WELL" and ls_bill_flag = "Y" then
		assessments.object.bill_flag[i] = "X"
	end if
next

li_sts = assessments.update()

li_count = assessment_charges.retrieve(cpr_id, encounter_id)
if li_count < 0 then return -1

// When we suppressed the diagnoses, we might have caused some charges to not be attached to
// a billed diagnosis.  Find them and attach them to the first sick diagnosis.
ll_problem_id = get_first_sick_problem()
li_count = get_unbilled_charges(lla_unbilled_charges)
for i = 1 to li_count
	EXECUTE lsp_set_assmnt_charge_billing;
	if not cprdb.check() then return -1
next

return 1

end function

public function integer get_unbilled_charges (long pla_charges[]);integer li_a_count
integer li_c_count
integer li_ac_count
integer i
long ll_encounter_charge_id
long ll_row
string ls_find
integer li_count
long ll_problem_id

li_a_count = assessments.rowcount()
li_c_count = charges.rowcount()
li_ac_count = assessment_charges.rowcount()

for i = 1 to li_c_count
	// for each billed charge...
	if string(charges.object.bill_flag[i]) = "Y" then
		// Find an assessment_charge record with bill_flag='Y'
		ll_encounter_charge_id = charges.object.encounter_charge_id[i]
		ls_find = "encounter_charge_id=" + string(ll_encounter_charge_id)
		ls_find += " and bill_flag='Y'"
		ll_row = assessment_charges.find(ls_find, 1, li_ac_count)
		if ll_row > 0 then
			// If we found a charge record, make sure the parent assessment is billed
			ll_problem_id = assessment_charges.object.problem_id[ll_row]
			ls_find = "problem_id=" + string(ll_problem_id)
			ls_find += " and bill_flag='Y'"
			ll_row = assessments.find(ls_find, 1, li_a_count)
			if ll_row <= 0 then
				// We didn't find a billed assessment record so add this charge to the list
				li_count++
				pla_charges[li_count] = ll_encounter_charge_id
			end if
		else
			// If we didn't find an assessment_charge record, then this
			// charge is not attached to a diagnosis, so add it to the list
			li_count++
			pla_charges[li_count] = ll_encounter_charge_id
		end if
	end if
next
			

return li_count








end function

on u_component_coding.create
call super::create
end on

on u_component_coding.destroy
call super::destroy
end on

event constructor;call super::constructor;assessments = CREATE u_ds_data
charges = CREATE u_ds_data
assessment_charges = CREATE u_ds_data

assessments.set_dataobject("dw_p_encounter_assessment")
charges.set_dataobject("dw_p_encounter_charge")
assessment_charges.set_dataobject("dw_p_encounter_assessment_charge")

end event

event destructor;call super::destructor;
DESTROY assessments
DESTROY charges
DESTROY assessment_charges


end event

