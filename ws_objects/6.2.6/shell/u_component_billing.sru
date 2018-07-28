HA$PBExportHeader$u_component_billing.sru
forward
global type u_component_billing from u_component_base_class
end type
type str_encounters from structure within u_component_billing
end type
type str_assessments from structure within u_component_billing
end type
type str_treatments from structure within u_component_billing
end type
end forward

type str_encounters from structure
	string		cpr_id
	long		encounter_id
end type

type str_assessments from structure
	long		problem_id
	integer		assessment_sequence
	string		assessment_id
end type

type str_treatments from structure
	long		encounter_charge_id
	long		treatment_id
	string		procedure_type
	string		procedure_id
end type

global type u_component_billing from u_component_base_class
end type
global u_component_billing u_component_billing

type variables

boolean copy_cc_to_description
boolean no_fee_hold


end variables

forward prototypes
public function integer post_encounter (string ps_cpr_id, long pl_encounter_id)
public function integer xref_assessment (string ps_assessment_id)
public function integer xref_procedure (string ps_procedure_id)
protected function long x_post_assessments (string ps_cpr_id, long pl_encounter_id)
protected function long x_post_encounter (string ps_cpr_id, long pl_encounter_id)
protected function long x_post_other (string ps_cpr_id, long pl_encounter_id)
protected function long x_post_treatments (string ps_cpr_id, long pl_encounter_id)
protected function long xx_post_encounter (string ps_cpr_id, long pl_encounter_id)
protected function long xx_post_other (string ps_cpr_id, long pl_encounter_id)
protected function integer xx_xref_assessment (string ps_icd9_code)
protected function integer xx_xref_procedure (string ps_cpt_code)
protected function string get_icd9 (string ps_cpr_id, string ps_assessment_id)
protected function string get_cpt (string ps_cpr_id, string ps_procedure_id)
protected function long xx_post_treatment (string ps_cpr_id, long pl_encounter_id, long pl_encounter_charge_id)
protected function long xx_post_assessment (string ps_cpr_id, long pl_encounter_id, long pl_problem_id, integer pi_assessment_sequence)
protected function long xx_post_memo (string ps_cpr_id, long pl_encounter_id, string ps_memo)
protected function long xx_post_referral (string ps_cpr_id, long pl_encounter_id, long pl_treatment_id)
protected function long x_post_followups (string ps_cpr_id, long pl_encounter_id)
protected function long xx_post_followup (string ps_cpr_id, long pl_encounter_id, long pl_treatment_id)
protected function long x_post_referrals (string ps_cpr_id, long pl_encounter_id)
public function integer xx_xref_procedure (string ps_procedure_id, string ps_cpt_code, string ps_modifier, string ps_billing_id)
protected function integer base_initialize ()
end prototypes

public function integer post_encounter (string ps_cpr_id, long pl_encounter_id);// Date Begun: ??/??/??
// Programmer: Mark Copenhaver (MC)
//				   Charles Appel (CA)
// Purpose: Calls all posting routines and updates EncounterPro database to indicate that
//				items have been posted.
// Expects: string	ps_cpr_id					uniquely identifies patient
//				long		pl_encounter_id			within a patient, uniquely identifies an encounter
// Returns: integer 									success = 1, failure = 0 or negative
// Limits:	
// History: 07/02/98 - CA - Comments added

// Note: cprdb = encounterpro database
// 		mydb  = billing database

// declare local variables
long ll_sts

// declare local alias for stored procedure that updates posted status
DECLARE lsp_set_encounter_posted PROCEDURE FOR dbo.sp_set_encounter_posted  
   @ps_cpr_id = :ps_cpr_id,   
   @pl_encounter_id = :pl_encounter_id
USING cprdb;

mylog.log(this, "post_encounter()", "Posting Encounter (" + ps_cpr_id + ", " + string(pl_encounter_id) + ")", 2)

ll_sts = x_post_encounter( ps_cpr_id, pl_encounter_id )
if ll_sts < 0 then 
	mylog.log(this, "post_encounter()", "Posting Encounter Failed (" + ps_cpr_id + ", " + string(pl_encounter_id) + ")", 4)
	return ll_sts
end if

ll_sts = x_post_assessments( ps_cpr_id, pl_encounter_id )
if ll_sts < 0 then 
	mylog.log(this, "post_encounter()", "Posting Encounter-Assessments Failed (" + ps_cpr_id + ", " + string(pl_encounter_id) + ")", 4)
	return ll_sts
end if

ll_sts = x_post_treatments( ps_cpr_id, pl_encounter_id )
if ll_sts < 0 then 
	mylog.log(this, "post_encounter()", "Posting Encounter-Treatments Failed (" + ps_cpr_id + ", " + string(pl_encounter_id) + ")", 4)
	return ll_sts
end if

ll_sts = x_post_followups( ps_cpr_id, pl_encounter_id )
if ll_sts < 0 then 
	mylog.log(this, "post_encounter()", "Posting Encounter-Followups Failed (" + ps_cpr_id + ", " + string(pl_encounter_id) + ")", 4)
	return ll_sts
end if

ll_sts = x_post_referrals( ps_cpr_id, pl_encounter_id )
if ll_sts < 0 then 
	mylog.log(this, "post_encounter()", "Posting Encounter-Referrals Failed (" + ps_cpr_id + ", " + string(pl_encounter_id) + ")", 4)
	return ll_sts
end if

ll_sts = x_post_other( ps_cpr_id, pl_encounter_id )
if ll_sts < 0 then 
	mylog.log(this, "post_encounter()", "Posting Encounter-Other Failed (" + ps_cpr_id + ", " + string(pl_encounter_id) + ")", 4)
	return ll_sts
end if

EXECUTE lsp_set_encounter_posted;
if not cprdb.check() then return -1

mylog.log(this, "post_encounter()", "Encounter Successfully Posted (" + ps_cpr_id + ", " + string(pl_encounter_id) + ")", 2)

return 1


end function

public function integer xref_assessment (string ps_assessment_id);// Date Begun: ??/??/??
// Programmer: Mark Copenhaver (MC)
//				   Charles Appel (CA)
// Purpose: 
// Expects: string	ps_assessment_id			
// Returns: integer 									
// Limits:	
// History: 07/02/98 - CA - Comments added

return xx_xref_assessment(ps_assessment_id)

end function

public function integer xref_procedure (string ps_procedure_id);// Date Begun: ??/??/??
// Programmer: Mark Copenhaver (MC)
//				   Charles Appel (CA)
// Purpose: 
// Expects: string	ps_procedure_id
// Returns: integer 									
// Limits:	
// History: 07/02/98 - CA - Comments added

string ls_cpt_code
string ls_billing_id
string ls_modifier
integer li_sts
SELECT cpt_code, modifier, billing_id
INTO :ls_cpt_code, :ls_modifier, :ls_billing_id
FROM c_Procedure
WHERE procedure_id = :ps_procedure_id
USING cprdb;
if not cprdb.check() then return -1

li_sts = xx_xref_procedure(ps_procedure_id, ls_cpt_code, ls_modifier, ls_billing_id)

if li_sts = 0 then li_sts = xx_xref_procedure(ls_cpt_code)

return li_sts

end function

protected function long x_post_assessments (string ps_cpr_id, long pl_encounter_id);/*************************************************************************
*
* Description:
*
* Returns: -1 - Failure
*           1 - Success
*
*************************************************************************/

// declare local variables
long ll_problem_id
string ls_assessment_id
long ll_assessment_count
integer i
boolean lb_loop
integer li_sts
integer li_assessment_sequence
string ls_description
string ls_icd_9_code
string ls_temp
string ls_billing_note
long ll_assessment_billing_id
string ls_bill_flag
u_ds_data luo_data

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_p_encounter_assessment")
ll_assessment_count = luo_data.retrieve(ps_cpr_id, pl_encounter_id)

// First validate and get the icd codes
for i = 1 to ll_assessment_count
	ls_bill_flag = upper(string(luo_data.object.bill_flag[i]))
	ll_problem_id = luo_data.object.problem_id[i]
	ls_assessment_id = luo_data.object.assessment_id[i]
	li_assessment_sequence = luo_data.object.assessment_sequence[i]
	ls_description = luo_data.object.description[i]
	ll_assessment_billing_id = luo_data.object.assessment_billing_id[i]
	ls_icd_9_code = luo_data.object.icd_9_code[i]

	// Skip if it's not billed
	if ls_bill_flag <> "Y" then continue // assessment not billable 
	
	// Skip if the assessment_id is null
	if isnull(ls_assessment_id) then
		luo_data.object.bill_flag[i] = "N"
		continue
	end if

	// Determine the icd_9_code
	if isnull(ls_icd_9_code) then
		ls_icd_9_code = get_icd9(ps_cpr_id, ls_assessment_id)
		if isnull(ls_icd_9_code) then
			mylog.log(this, "x_post_assessments()", "No icd9 for assessment (" + ls_assessment_id + ")", 3)
			luo_data.object.bill_flag[i] = "N"
			continue
		end if
		luo_data.object.icd_9_code[i] = ls_icd_9_code
	end if
	
	li_sts = xx_xref_assessment(ls_icd_9_code)
	if li_sts <= 0 then
		ls_temp = "No billing record found for icd code <" + ls_icd_9_code + ">"

		ls_description = datalist.assessment_description(ls_assessment_id)
		if not isnull(ls_description) then
			ls_temp += " - " + ls_description
		end if
	
		xx_post_memo(ps_cpr_id, pl_encounter_id, ls_temp)
		
		luo_data.object.bill_flag[i] = "N"
		continue
	end if
next

// Filter out the unbilled assessments
luo_data.setfilter("bill_flag='Y'")
luo_data.filter()
ll_assessment_count = luo_data.rowcount()

// Now sort the assessments 
for i = 1 to ll_assessment_count
	ll_problem_id = luo_data.object.problem_id[i]
	ls_assessment_id = luo_data.object.assessment_id[i]
	li_assessment_sequence = luo_data.object.assessment_sequence[i]
	ls_description = luo_data.object.description[i]
	ll_assessment_billing_id = luo_data.object.assessment_billing_id[i]
	ls_icd_9_code = luo_data.object.icd_9_code[i]
	if li_assessment_sequence <> i or isnull(li_assessment_sequence) then
		luo_data.object.assessment_sequence[i] = i
	end if
next

// Remove the filter and save any changes back to the database
luo_data.setfilter("")
luo_data.filter()
li_sts = luo_data.update()
if li_sts < 0 then return -1

// Refilter and sort the datastore because the assessment_sequence values might have changed
luo_data.setfilter("bill_flag='Y'")
luo_data.filter()
ll_assessment_count = luo_data.rowcount()
luo_data.sort()

if ll_assessment_count <= 0 Then // no assessments to bill
	mylog.log(this, "x_post_assessments()", "No billable icd's for patient,encounter(" + ps_cpr_id+","+string(pl_encounter_id)+")", 4)
	Return -1 
end if
mylog.log(this, "x_post_assessments()", "("+string(ll_assessment_count)+") billable icd's for patient,encounter(" + ps_cpr_id+","+string(pl_encounter_id)+")", 1)
// Now bill each assessment which is still marked as billable
for i = 1 to ll_assessment_count
	ls_bill_flag = upper(string(luo_data.object.bill_flag[i]))
	ll_problem_id = luo_data.object.problem_id[i]
	li_assessment_sequence = luo_data.object.assessment_sequence[i]
	
	// Skip if it's not billed
	if ls_bill_flag <> "Y" then continue
	
	xx_post_assessment(ps_cpr_id, &
							pl_encounter_id, &
							ll_problem_id, &
							li_assessment_sequence)
next

DESTROY luo_data
Return 1
end function

protected function long x_post_encounter (string ps_cpr_id, long pl_encounter_id);// Date Begun: ??/??/??
// Programmer: Mark Copenhaver (MC)
//				   Charles Appel (CA)
// Purpose: 
// Expects: string	ps_cpr_id					uniquely identifies patient
//				long		pl_encounter_id			within a patient, uniquely identifies an encounter
// Returns: integer 									
// Limits:	
// History: 07/02/98 - CA - Comments added
//				07/03/98 - CA - Change return from integer to long

return xx_post_encounter( ps_cpr_id, pl_encounter_id )


end function

protected function long x_post_other (string ps_cpr_id, long pl_encounter_id);// Date Begun: ??/??/??
// Programmer: Mark Copenhaver (MC)
//				   Charles Appel (CA)
// Purpose: 
// Expects: string	ps_cpr_id					uniquely identifies patient
//				long		pl_encounter_id			within a patient, uniquely identifies an encounter
// Returns: integer 									
// Limits:	
// History: 07/02/98 - CA - Comments added
//				07/03/98 - CA - Change return from integer to long

// declare local variables
return xx_post_other(ps_cpr_id, pl_encounter_id)


end function

protected function long x_post_treatments (string ps_cpr_id, long pl_encounter_id);/**************************************************************************
*
*
* Description:
*
* Return: -1 - Failure
*          1 - Success
*
*
*
***************************************************************************/
// Note: cprdb = encounterpro database
// 		mydb  = billing database

// declare local variables
long ll_encounter_charge_id
string ls_procedure_type
long ll_treatment_id
integer li_treatment_sequence
string ls_procedure_id
boolean lb_loop
integer i,j,k
integer li_sts
string ls_cpt_code
string ls_description
decimal ldc_charge
string ls_temp
string ls_billing_note
u_ds_data luo_data
long ll_treatment_count
string ls_bill_flag

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_p_encounter_charge")
ll_treatment_count = luo_data.retrieve(ps_cpr_id, pl_encounter_id)

// First validate the charges
for i = 1 to ll_treatment_count
	ll_encounter_charge_id = luo_data.object.encounter_charge_id[i]
	ls_procedure_type = luo_data.object.procedure_type[i]
	ll_treatment_id = luo_data.object.treatment_id[i]
	ls_procedure_id = luo_data.object.procedure_id[i]
	ls_bill_flag = luo_data.object.bill_flag[i]
	ls_cpt_code = luo_data.object.cpt_code[i]

	if isnull(ls_procedure_id) then
		luo_data.object.bill_flag[i] = "N"
		continue
	end if

	if isnull(ls_cpt_code) then
		ls_cpt_code = get_cpt(ps_cpr_id, ls_procedure_id)
		if isnull(ls_cpt_code) then
			mylog.log(this, "x_post_treatments()", "No cpt for treatment (" + ls_procedure_id + ")", 3)
			luo_data.object.bill_flag[i] = "N"
			continue
		else
			luo_data.object.cpt_code[i] = ls_cpt_code
		end if
	end if

	li_sts = xref_procedure(ls_procedure_id)
	if li_sts <= 0 then
		ls_temp = "No billing record found for icd code <" + ls_cpt_code + ">"

		ls_description = luo_data.object.description[i]
		if not isnull(ls_description) then
			ls_temp += " - " + ls_description
		end if
	
		xx_post_memo(ps_cpr_id, pl_encounter_id, ls_temp)
		
		luo_data.object.bill_flag[i] = "N"
		continue
	end if
next

// Save any changes back to the database
li_sts = luo_data.update()
if li_sts < 0 then return -1

// Filter out the unbilled assessments
luo_data.setfilter("bill_flag='Y'")
luo_data.filter()
ll_treatment_count = luo_data.rowcount()

if ll_treatment_count <= 0 Then // no billable treatments
	mylog.log(this, "x_post_treatments()", "No billable cpt's for patient,encounter(" + ps_cpr_id+","+string(pl_encounter_id)+")", 4)
	return -1
end if
mylog.log(this, "x_post_treatments()", "("+string(ll_treatment_count)+")billable cpt's for patient,encounter(" + ps_cpr_id+","+string(pl_encounter_id)+")", 1)
// Now post the PRIMARY treatments
for i = 1 to ll_treatment_count
	ll_encounter_charge_id = luo_data.object.encounter_charge_id[i]
	ls_procedure_type = luo_data.object.procedure_type[i]
	ll_treatment_id = luo_data.object.treatment_id[i]
	ls_procedure_id = luo_data.object.procedure_id[i]

	if upper(ls_procedure_type) = "PRIMARY" then
		xx_post_treatment(ps_cpr_id, &
							pl_encounter_id, &
							ll_encounter_charge_id)
	end if
next

// Now post the non-PRIMARY treatments
for i = 1 to ll_treatment_count
	ll_encounter_charge_id = luo_data.object.encounter_charge_id[i]
	ls_procedure_type = luo_data.object.procedure_type[i]
	ll_treatment_id = luo_data.object.treatment_id[i]
	ls_procedure_id = luo_data.object.procedure_id[i]

	if upper(ls_procedure_type) <> "PRIMARY" then
		xx_post_treatment(ps_cpr_id, &
							pl_encounter_id, &
							ll_encounter_charge_id)
	end if
next

return 1


end function

protected function long xx_post_encounter (string ps_cpr_id, long pl_encounter_id);// Date Begun: ??/??/??
// Programmer: Mark Copenhaver (MC)
//				   Charles Appel (CA)
// Purpose: 
// Expects: string	ps_cpr_id					uniquely identifies patient
//				long		pl_encounter_id			within a patient, uniquely identifies an encounter
// Returns: integer 									
// Limits:	
// History: 07/02/98 - CA - Comments added
//				07/03/98 - CA - Change return from integer to long

if ole_class then
	return ole.post_encounter(ps_cpr_id, pl_encounter_id)
else
	return 100
end if

end function

protected function long xx_post_other (string ps_cpr_id, long pl_encounter_id);// Date Begun: ??/??/??
// Programmer: Mark Copenhaver (MC)
//				   Charles Appel (CA)
// Purpose: 
// Expects: string	ps_cpr_id					uniquely identifies patient
//				long		pl_encounter_id			within a patient, uniquely identifies an encounter
// Returns: integer 									
// Limits:	
// History: 07/02/98 - CA - Comments added
//				07/03/98 - CA - Change return from integer to long

if ole_class then
	return ole.post_other( ps_cpr_id, pl_encounter_id )
else
	return 100
end if

end function

protected function integer xx_xref_assessment (string ps_icd9_code);// Date Begun: ??/??/??
// Programmer: Mark Copenhaver (MC)
//				   Charles Appel (CA)
// Purpose: 
// Expects: string	ps_assessment_id
// Returns: integer 									
// Limits:	
// History: 07/02/98 - CA - Comments added

if ole_class then
	return ole.xref_assessment(ps_icd9_code)
else
	return 100
end if

end function

protected function integer xx_xref_procedure (string ps_cpt_code);// Date Begun: ??/??/??
// Programmer: Mark Copenhaver (MC)
//				   Charles Appel (CA)
// Purpose: 
// Expects: string	ps_procedure_id
// Returns: integer 									
// Limits:	
// History: 07/02/98 - CA - Comments added

if ole_class then
	return ole.xref_procedure(ps_cpt_code)
else
	return 100
end if

end function

protected function string get_icd9 (string ps_cpr_id, string ps_assessment_id);string ls_insurance_id
string ls_icd_9_code
string ls_null

//CWW, BEGIN
u_ds_data luo_sp_get_assessment_icd9
integer li_spdw_count
// DECLARE lsp_get_assessment_icd9 PROCEDURE FOR dbo.sp_get_assessment_icd9  
//         @ps_cpr_id = :ps_cpr_id,   
//			@ps_assessment_id = :ps_assessment_id,
//			@ps_insurance_id = :ls_insurance_id OUT,
//			@ps_icd_9_code = :ls_icd_9_code OUT
// USING cprdb;
//CWW, END

setnull(ls_null)

// Now get the codes for this assessment
//CWW, BEGIN
//EXECUTE lsp_get_assessment_icd9;
//if not cprdb.check() then return ls_null
//FETCH lsp_get_assessment_icd9 INTO :ls_insurance_id, :ls_icd_9_code;
//if not cprdb.check() then return ls_null
//CLOSE lsp_get_assessment_icd9;

luo_sp_get_assessment_icd9 = CREATE u_ds_data
luo_sp_get_assessment_icd9.set_dataobject("dw_sp_get_assessment_icd9", cprdb)
li_spdw_count = luo_sp_get_assessment_icd9.retrieve(ps_cpr_id, ps_assessment_id)
if li_spdw_count <= 0 then
	setnull(ls_insurance_id)
	setnull(ls_icd_9_code)
else
	ls_insurance_id = luo_sp_get_assessment_icd9.object.insurance_id[1]
	ls_icd_9_code = luo_sp_get_assessment_icd9.object.icd_9_code[1]
end if
destroy luo_sp_get_assessment_icd9
//CWW, END

return ls_icd_9_code

end function

protected function string get_cpt (string ps_cpr_id, string ps_procedure_id);string ls_insurance_id
string ls_cpt_code
string ls_modifier
string ls_other_modifiers
real lr_units
string ls_null
decimal ldc_charge

//CWW, BEGIN
u_ds_data luo_sp_get_procedure_cpt
integer li_spdw_count
// DECLARE lsp_get_procedure_cpt PROCEDURE FOR sp_get_procedure_cpt  
//         @ps_cpr_id = :ps_cpr_id,   
//         @ps_procedure_id = :ps_procedure_id,   
//         @ps_insurance_id = :ls_insurance_id OUT,   
//         @ps_cpt_code = :ls_cpt_code OUT,   
//         @ps_modifier = :ls_modifier OUT,   
//         @ps_other_modifiers = :ls_other_modifiers OUT,   
//         @pr_units = :lr_units OUT,   
//         @pdc_charge = :ldc_charge OUT
// USING cprdb;
 //CWW, END

setnull(ls_null)

// Now get the codes for this assessment
//CWW, BEGIN
//EXECUTE lsp_get_procedure_cpt;
//if not cprdb.check() then return ls_null
//FETCH lsp_get_procedure_cpt INTO
//			:ls_insurance_id,
//			:ls_cpt_code,
//			:ls_modifier,
//			:ls_other_modifiers,
//			:lr_units,
//			:ldc_charge;
//if not cprdb.check() then return ls_null
//CLOSE lsp_get_procedure_cpt;

luo_sp_get_procedure_cpt = CREATE u_ds_data
luo_sp_get_procedure_cpt.set_dataobject("dw_sp_get_procedure_cpt", cprdb)
li_spdw_count = luo_sp_get_procedure_cpt.retrieve(ps_cpr_id, ps_procedure_id)
if li_spdw_count <= 0 then
	setnull(ls_insurance_id)
	setnull(ls_cpt_code)
	setnull(ls_modifier)
	setnull(ls_other_modifiers)
	setnull(lr_units)
	setnull(ldc_charge)
else
	ls_insurance_id = luo_sp_get_procedure_cpt.object.authority_id[1]
	ls_cpt_code = luo_sp_get_procedure_cpt.object.cpt_code[1]
	ls_modifier = luo_sp_get_procedure_cpt.object.modifier[1]
	ls_other_modifiers = luo_sp_get_procedure_cpt.object.other_modifiers[1]
	lr_units = luo_sp_get_procedure_cpt.object.units[1]
	ldc_charge = luo_sp_get_procedure_cpt.object.charge[1]
end if

destroy luo_sp_get_procedure_cpt
//CWW, END


return ls_cpt_code

end function

protected function long xx_post_treatment (string ps_cpr_id, long pl_encounter_id, long pl_encounter_charge_id);// Date Begun: ??/??/??
// Programmer: Mark Copenhaver (MC)
//				   Charles Appel (CA)
// Purpose: 
// Expects: string	ps_cpr_id					uniquely identifies patient
//				long		pl_encounter_id			within a patient, uniquely identifies an encounter
//				long		pl_problem_id
//				integer	pi_treatment_sequence
// Returns: integer 									billing id for posted assessment or error code
// Limits:	
// History: 07/02/98 - CA - Comments added
//				07/03/98 - CA - Change return from integer to long

if ole_class then
	return ole.post_treatment(ps_cpr_id, pl_encounter_id, pl_encounter_charge_id)
else
	return 100
end if

end function

protected function long xx_post_assessment (string ps_cpr_id, long pl_encounter_id, long pl_problem_id, integer pi_assessment_sequence);// Date Begun: ??/??/??
// Programmer: Mark Copenhaver (MC)
//				   Charles Appel (CA)
// Purpose: 
// Expects: string	ps_cpr_id					uniquely identifies patient
//				long		pl_encounter_id			within a patient, uniquely identifies an encounter
//    		long pl_problem_id
//				pi_assessment_sequence
// Returns: integer 									
// Limits:	
// History: 07/02/98 - CA - Comments added
//				07/03/98 - CA - Change return from integer to long

if ole_class then
	return ole.post_assessment(ps_cpr_id, pl_encounter_id, pl_problem_id, pi_assessment_sequence)
else
	return 100
end if

end function

protected function long xx_post_memo (string ps_cpr_id, long pl_encounter_id, string ps_memo);string ls_billing_note

if ole_class then
	return ole.post_memo(ps_cpr_id, pl_encounter_id, ps_memo)
else
	SELECT billing_note
	INTO :ls_billing_note
	FROM p_Patient_Encounter
	WHERE cpr_id = :ps_cpr_id
	AND encounter_id = :pl_encounter_id;
	if not cprdb.check() then return -1

	if isnull(ls_billing_note) then
		ls_billing_note = ps_memo
	else
		ls_billing_note += "; " + ps_memo
	end if

	UPDATE p_Patient_Encounter
	SET billing_hold_flag = "Y",
		 billing_note = :ls_billing_note
	WHERE cpr_id = :ps_cpr_id
	AND encounter_id = :pl_encounter_id;
	if not cprdb.check() then return -1
		
end if

return 1

end function

protected function long xx_post_referral (string ps_cpr_id, long pl_encounter_id, long pl_treatment_id);string ls_billing_note

if ole_class then
	return ole.post_referral(ps_cpr_id, pl_encounter_id, pl_treatment_id)
else
	return 100
end if

end function

protected function long x_post_followups (string ps_cpr_id, long pl_encounter_id);// declare local variables
// encounterpro fields
string ls_attending_doctor
// medicat fields
long ll_TicketID
string ls_billing_note
string ls_ProviderCode
boolean lb_loop
integer li_count
long lla_treatment_id[]
long ll_treatment_id
integer li_duration
integer i
date ld_encounter_date
datetime ldt_encounter_date
date ld_followup_date
integer li_sts

// Declare cursor for getting followups
 DECLARE lc_followups CURSOR FOR  
  SELECT treatment_id
    FROM p_Treatment_Item  
   WHERE ( cpr_id = :ps_cpr_id ) AND  
         ( open_encounter_id = :pl_encounter_id ) AND  
         ( treatment_type = 'FOLLOWUP' ) AND  
         ( treatment_status is NULL )
	USING cprdb;


// First get all the followups into an array
lb_loop = true
li_count = 0
OPEN lc_followups;
if not cprdb.check() then return -1

DO
	FETCH lc_followups INTO
		:ll_treatment_id;
	if not cprdb.check() then return -1

	if cprdb.sqlcode = 0 then
		li_count += 1
		lla_treatment_id[li_count] = ll_treatment_id
	else
		lb_loop = false
	end if
LOOP WHILE lb_loop

CLOSE lc_followups;


// Then loop through the followups and post them into Medicat

for i = 1 to li_count
	if isnull(lla_treatment_id[i]) then continue
	li_sts = xx_post_followup(ps_cpr_id, pl_encounter_id, lla_treatment_id[i])
	if li_sts < 0 then
		mylog.log(this, "x_post_followups()", "Error posting followup (" + ps_cpr_id + ", " + string(pl_encounter_id) + ", " + string(lla_treatment_id[i]) + ")", 4)
	end if
next

return 1

end function

protected function long xx_post_followup (string ps_cpr_id, long pl_encounter_id, long pl_treatment_id);string ls_billing_note

if ole_class then
	return ole.post_followup(ps_cpr_id, pl_encounter_id, pl_treatment_id)
else
	return 100
end if

end function

protected function long x_post_referrals (string ps_cpr_id, long pl_encounter_id);// declare local variables
// encounterpro fields
string ls_attending_doctor
// medicat fields
long ll_TicketID
string ls_billing_note
string ls_ProviderCode
boolean lb_loop
integer li_count
long lla_treatment_id[]
long ll_treatment_id
integer li_duration
integer i
date ld_encounter_date
datetime ldt_encounter_date
date ld_followup_date
integer li_sts

// Declare cursor for getting followups
 DECLARE lc_followups CURSOR FOR  
  SELECT treatment_id
    FROM p_Treatment_Item  
   WHERE ( cpr_id = :ps_cpr_id ) AND  
         ( open_encounter_id = :pl_encounter_id ) AND  
         ( treatment_type = 'REFERRAL' ) AND  
         ( treatment_status is NULL )
	USING cprdb;


// First get all the followups into an array
lb_loop = true
li_count = 0
OPEN lc_followups;
if not cprdb.check() then return -1

DO
	FETCH lc_followups INTO
		:ll_treatment_id;
	if not cprdb.check() then return -1

	if cprdb.sqlcode = 0 then
		li_count += 1
		lla_treatment_id[li_count] = ll_treatment_id
	else
		lb_loop = false
	end if
LOOP WHILE lb_loop

CLOSE lc_followups;


// Then loop through the followups and post them into Medicat

for i = 1 to li_count
	if isnull(lla_treatment_id[i]) then continue
	li_sts = xx_post_referral(ps_cpr_id, pl_encounter_id, lla_treatment_id[i])
	if li_sts < 0 then
		mylog.log(this, "x_post_referrals()", "Error posting referral (" + ps_cpr_id + ", " + string(pl_encounter_id) + ", " + string(lla_treatment_id[i]) + ")", 4)
	end if
next

return 1

end function

public function integer xx_xref_procedure (string ps_procedure_id, string ps_cpt_code, string ps_modifier, string ps_billing_id);// Date Begun: ??/??/??
// Programmer: Mark Copenhaver (MC)
//				   Charles Appel (CA)
// Purpose: 
// Expects: string	ps_procedure_id
// Returns: integer 									
// Limits:	
// History: 07/02/98 - CA - Comments added

if ole_class then
	return ole.xref_procedure(ps_procedure_id,ps_cpt_code,ps_modifier,ps_billing_id)
else
	return 0
end if
end function

protected function integer base_initialize ();// Date Begun: ??/??/??
// Programmer: Mark Copenhaver (MC)
//				   Charles Appel (CA)
// Purpose: Provide place to put initialization code that is common to all billing objects
// Expects: 
// Returns: integer - always 1
// Limits:	none known
// History: 07/02/98 - CA - Comments added


get_attribute( "copy_cc_to_description", copy_cc_to_description )
get_attribute( "no_fee_hold", no_fee_hold )

return 1

end function

on u_component_billing.create
call super::create
end on

on u_component_billing.destroy
call super::destroy
end on

