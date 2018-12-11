$PBExportHeader$u_component_billing_encounterpro.sru
forward
global type u_component_billing_encounterpro from u_component_billing
end type
end forward

shared variables
string is_default_facility
end variables

global type u_component_billing_encounterpro from u_component_billing
end type
global u_component_billing_encounterpro u_component_billing_encounterpro

type variables
//oleobject ole_ahcmessenger

//oleobject ole_factory
string is_encounterdate, is_facilitycode
string is_defaultfacility
string is_icd10_code[]
integer ii_assessment_seq[]
string procedurecodeidentifier
string primary_provider_id
string is_icd10_desc[]
string is_attending_doctor
string is_supervisor_doctor
string is_supervising_doctor
string is_encounter_location
string is_cpt_assembly[]
string is_billingsystem
integer ii_cpt_count
datetime idt_encounter_date
boolean ib_supervisorbill
string  batch_billing
boolean bill_to_patient_domain
string billing_id_domain
end variables

forward prototypes
protected function long xx_post_assessment (string ps_cpr_id, long pl_encounter_id, long pl_problem_id, integer pi_assessment_sequence)
protected function long xx_post_followup (string ps_cpr_id, long pl_encounter_id, long pl_treatment_id)
protected function long xx_post_referral (string ps_cpr_id, long pl_encounter_id, long pl_treatment_id)
protected function long xx_post_memo (string ps_cpr_id, long pl_encounter_id, string ps_memo)
public function integer xx_xref_procedure (string ps_procedure_id, string ps_cpt_code, string ps_modifier, string ps_billing_id)
protected function integer xx_xref_assessment (string ps_icd10_code)
protected function long xx_post_treatment (string ps_cpr_id, long pl_encounter_id, long pl_encounter_charge_id)
protected function integer xx_initialize ()
protected function long xx_post_encounter (string ps_cpr_id, long pl_encounter_id)
protected function long xx_post_other (string ps_cpr_id, long pl_encounter_id)
end prototypes

protected function long xx_post_assessment (string ps_cpr_id, long pl_encounter_id, long pl_problem_id, integer pi_assessment_sequence);integer li_sts
string ls_assessment_id
string ls_asst_description
string ls_insurance_id
integer i
string ls_icd10_code

// declare local alias for stored procedure
u_ds_data luo_sp_get_assessment_icd10
integer li_spdw_count

SELECT assessment_id
INTO :ls_assessment_id
FROM p_Encounter_Assessment
WHERE cpr_id = :ps_cpr_id
AND encounter_id = :pl_encounter_id
AND problem_id = :pl_problem_id
USING cprdb;
// if an sql error occurs return -1
if not cprdb.check() then return -1
// if no records were found, return 0
If cprdb.sqlcode = 100 then 
	log.log(this, "u_component_billing_encounterpro.xx_post_assessment:0023", "no records found in p_encounter_assessment for problem_id= (" + string(pl_problem_id) + ")", 3)
	Return 0
End if

i = upperbound(is_icd10_code)
luo_sp_get_assessment_icd10 = CREATE u_ds_data
luo_sp_get_assessment_icd10.set_dataobject("dw_sp_get_assessment_icd10", cprdb)
li_spdw_count = luo_sp_get_assessment_icd10.retrieve(ps_cpr_id, ls_assessment_id)
If li_spdw_count <= 0 Then
	setnull(ls_insurance_id)
	setnull(ls_icd10_code)
Else
	ls_insurance_id = luo_sp_get_assessment_icd10.object.insurance_id[1]
	ls_icd10_code = luo_sp_get_assessment_icd10.object.icd10_code[1]
	ls_asst_description = luo_sp_get_assessment_icd10.object.asst_description[1]
	If Not isnull(ls_icd10_code) Then
		i++
		is_icd10_code[i] = ls_icd10_code
		is_icd10_desc[i] = ls_asst_description
		ii_assessment_seq[i] = pi_assessment_sequence
		// once the icd code is included then set the flag as posted
		Update p_encounter_assessment
		set posted = 'Y'
		where cpr_id = :ps_cpr_id
		and encounter_id = :pl_encounter_id
		and problem_id = :pl_problem_id
		using cprdb;
	End If
End If
destroy luo_sp_get_assessment_icd10

log.log(this, "u_component_billing_encounterpro.xx_post_assessment:0054", "The icd10 retrieve done (" + ps_cpr_id + ", " + string(pl_encounter_id) + ", " + ls_icd10_code + ")", 1)
return 1
end function

protected function long xx_post_followup (string ps_cpr_id, long pl_encounter_id, long pl_treatment_id);return 1
end function

protected function long xx_post_referral (string ps_cpr_id, long pl_encounter_id, long pl_treatment_id);return 1
end function

protected function long xx_post_memo (string ps_cpr_id, long pl_encounter_id, string ps_memo);return 1
end function

public function integer xx_xref_procedure (string ps_procedure_id, string ps_cpt_code, string ps_modifier, string ps_billing_id);return 1
//if not is_billingsystem = 'MILLBROOK' then return 1
//long ll_proceduresid
//
//setnull(ll_proceduresid)
//
//if not isnull(ps_billing_id) then
//	SELECT proceduresid
//	INTO :ll_proceduresid
//	FROM procedures
//	WHERE code = :ps_billing_id
//	USING mydb;
//	if not mydb.check() then return -1
//end if
//
//if isnull(ll_proceduresid) then
//	// modifier lookup
//	if not isnull(ps_modifier) then
//		SELECT min(proceduresid)
//		INTO :ll_proceduresid
//		FROM procedures p, medlists m
//		WHERE p.cptcode = :ps_cpt_code
//		AND p.Modifier1Mid = m.medlistsid
//		AND m.code = :ps_modifier
//		USING mydb;
//		if not mydb.check() then return -1
//		if mydb.sqlcode = 100 then return 0
//		if isnull(ll_proceduresid) then return 0
//	else
//		SELECT min(proceduresid)
//		INTO :ll_proceduresid
//		FROM procedures
//		WHERE cptcode = :ps_cpt_code
//		USING mydb;
//		if not mydb.check() then return -1
//		if mydb.sqlcode = 100 then return 0
//		if isnull(ll_proceduresid) then return 0
//	END IF
//end if
//
//if isnull(ll_proceduresid) then return 0
//
//UPDATE c_Procedure
//SET billing_code = :ll_proceduresid
//WHERE procedure_id = :ps_procedure_id
//USING cprdb;
//if not cprdb.check() then return -1
//
//UPDATE c_Procedure_Insurance
//SET billing_code = :ll_proceduresid
//WHERE procedure_id = :ps_procedure_id
//USING cprdb;
//if not cprdb.check() then return -1
//
//
//return 1
//
end function

protected function integer xx_xref_assessment (string ps_icd10_code);return 1
end function

protected function long xx_post_treatment (string ps_cpr_id, long pl_encounter_id, long pl_encounter_charge_id);// // declare local variables
long ll_treatment_id
long ll_treatment_billing_id
string ls_procedure_type
string ls_procedure_id
string ls_charge_bill_flag
decimal ldc_encounter_charge
decimal ldc_procedure_charge
string ls_cpt_code
string ls_TxnModifier1
string ls_TxnModifier2
string ls_icd10
real lr_procedure_units
string ls_insurance_id
string ls_modifier
string ls_other_modifiers
string ls_unit
integer 		lic_problem_id	,li_charge_units
long 			i
string 		ls_proc_description
u_ds_data luo_sp_get_procedure_cpt
integer li_spdw_count
u_ds_data luo_data
long ll_assessment_count
string ls_icd10_code
string ls_assessment_description

// First get some info from the charge table
SELECT	treatment_id,
			treatment_billing_id,
			procedure_type,
			procedure_id,
			charge,
			bill_flag,
			units
INTO		:ll_treatment_id,
			:ll_treatment_billing_id,
			:ls_procedure_type,
			:ls_procedure_id,
			:ldc_encounter_charge,
			:ls_charge_bill_flag,
			:li_charge_units
FROM p_Encounter_Charge
WHERE cpr_id = :ps_cpr_id
AND encounter_id = :pl_encounter_id
AND encounter_charge_id = :pl_encounter_charge_id
USING cprdb;
if not cprdb.check() then 
	mylog.log(this, "u_component_billing_encounterpro.xx_post_treatment:0049", "treatment charge access (" + ps_cpr_id + ", " + string(pl_encounter_id) + ")", 3)	
	return -1
end if	
if cprdb.sqlcode = 100 then
	mylog.log(this, "u_component_billing_encounterpro.xx_post_treatment:0053", "treatment charge not found (" + ps_cpr_id + ", " + string(pl_encounter_id) + ", " + string(pl_encounter_charge_id) + ")", 3)	
	return 0
end if	

// Now determine the cpt_code and other stuff
luo_sp_get_procedure_cpt = CREATE u_ds_data
luo_sp_get_procedure_cpt.set_dataobject("dw_sp_get_procedure_cpt", cprdb)
li_spdw_count = luo_sp_get_procedure_cpt.retrieve(ps_cpr_id, ls_procedure_id)
if li_spdw_count <= 0 then
	setnull(ls_insurance_id)
	setnull(ls_cpt_code)
	setnull(ls_modifier)
	setnull(ls_other_modifiers)
	setnull(lr_procedure_units)
	setnull(ldc_procedure_charge)
	setnull(ls_proc_description)
else
	ls_insurance_id = luo_sp_get_procedure_cpt.object.authority_id[1]
	ls_cpt_code = luo_sp_get_procedure_cpt.object.cpt_code[1]
	ls_modifier = luo_sp_get_procedure_cpt.object.modifier[1]
	ls_other_modifiers = luo_sp_get_procedure_cpt.object.other_modifiers[1]
	lr_procedure_units = luo_sp_get_procedure_cpt.object.units[1]
	ldc_procedure_charge = luo_sp_get_procedure_cpt.object.charge[1]
	ls_proc_description = luo_sp_get_procedure_cpt.object.proc_description[1]
end if
destroy luo_sp_get_procedure_cpt

if isnull(ls_cpt_code) or ls_cpt_code = "" then
	mylog.log(this, "u_component_billing_encounterpro.xx_post_treatment:0081", "no cpt code for lsp_get_procedure_cpt (" + ps_cpr_id + ", " + string(pl_encounter_id) + ", " + ls_procedure_id + ")", 3)	
	return -1
else	
	procedurecodeidentifier = ls_cpt_code
end if

// Determine the codes for the billing system
ls_TxnModifier1 = ls_modifier
ls_TxnModifier2 = ls_other_modifiers

if isnull(ls_TxnModifier1) then ls_TxnModifier1 = ""

if not isnull(ls_TxnModifier2) and len(trim(ls_TxnModifier2)) <> 0 then
	ls_TxnModifier1 = ls_TxnModifier1 + "," + ls_TxnModifier2
end if

if isnull(ldc_encounter_charge) and not isnull(ldc_procedure_charge) then
	ldc_encounter_charge = ldc_procedure_charge
end if

if isnull(lr_procedure_units) or lr_procedure_units <= 0 then lr_procedure_units = 1
// if p_encounter_charge units is filled in use it otherwise get the unit from procedure table
if isnull(li_charge_units) or li_charge_units <= 0 then 
	ls_unit = String(lr_procedure_units)
else
	ls_unit = String(li_charge_units)
end if

if isnull(ls_proc_description) then ls_proc_description = ""


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Add the CPT Code and modifiers
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
string ls_cpt_assembly, ls_line_break
ls_line_break = '~013'
ii_cpt_count++

ls_cpt_assembly = ls_cpt_code + ls_line_break
ls_cpt_assembly += ls_TxnModifier1 + ls_line_break 
ls_cpt_assembly += ls_unit + ls_line_break
ls_cpt_assembly += ls_proc_description + ls_line_break

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Add the ICD codes
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_encounter_charges_for_treatment")
ll_assessment_count = luo_data.retrieve(ps_cpr_id, pl_encounter_id, pl_encounter_charge_id)
if ll_assessment_count < 0 then 
	return -1
end if
if ll_assessment_count = 0 then 
	mylog.log(this, "u_component_billing_encounterpro.xx_post_treatment:0134", "No associated ICD10 for CPT (" + ls_cpt_code + ", " + ps_cpr_id + ", " + string(pl_encounter_id) +  ")", 3)	
	return -1
End If

ls_icd10 = ""
for i = 1 to ll_assessment_count
	ls_icd10_code = luo_data.object.icd10_code[i]
	ls_assessment_description = luo_data.object.assessment_description[i]
	if not isnull(ls_icd10_code) and len(ls_assessment_description) > 0 then
		ls_icd10 += ls_icd10_code + "~t"+ ls_assessment_description + ls_line_break
	end if	
next
	
ls_cpt_assembly += string(ll_assessment_count) + ls_line_break // matching icd10's for cpt
ls_cpt_assembly += ls_icd10


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Finish
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
is_cpt_assembly[ii_cpt_count] = ls_cpt_assembly

// once the cpt code is included then set the flag as posted
Update p_encounter_charge
	set posted = 'Y'
where cpr_id = :ps_cpr_id
	and encounter_id = :pl_encounter_id
	and encounter_charge_id = :pl_encounter_charge_id
using cprdb;

mylog.log(this, "u_component_billing_encounterpro.xx_post_treatment:0164", ls_cpt_assembly,1)
////////////////////////////////////////////

Return 1
end function

protected function integer xx_initialize ();string 	ls_bill_to_patient_domain
integer 	li_sts
integer	li_message_id
string	ls_filepath
string	ls_status
string 	ls_hl7engine
string 	ls_current_filename
string	ls_default_supervisor_id
long 		ll_str_len
Any 		la_vm

string ls_supervisorbill

setnull(ls_supervisorbill)
ib_supervisorbill = False
get_attribute("FacilityId", is_defaultfacility)

get_attribute("bill_to_supervisor",ls_supervisorbill)

if upper(ls_supervisorbill) = 'YES' then
	ib_supervisorbill = True
end if	
get_attribute("billing_system",is_billingsystem)
if is_billingsystem = upper('MILLBROOK') then 
end if	
	
get_attribute("default_supervisor_id",ls_default_supervisor_id)
if isnull(ls_default_supervisor_id) or ls_default_supervisor_id = '' then 
	setnull(is_supervisor_doctor)
	mylog.log(this, "u_component_billing_encounterpro.xx_initialize:0030", "default_supervisor_id not found in table", 1)
else
	mylog.log(this, "u_component_billing_encounterpro.xx_initialize:0032", "default_supervisor_id: "+ls_default_supervisor_id, 2)
	SELECT billing_code
		INTO :is_supervisor_doctor
		FROM c_user
		WHERE user_id = :ls_default_supervisor_id
		USING cprdb;
	if not cprdb.check() then return -1
	if cprdb.sqlcode = 100 then 
		setnull(is_supervisor_doctor)
		mylog.log(this, "u_component_billing_encounterpro.xx_initialize:0041", "No billing code for default_supervisor_id ", 3)
	end if

end if	

get_attribute("billing_id_domain",billing_id_domain)
if isnull(billing_id_domain) then billing_id_domain = "JMJBILLINGID"

get_attribute("bill_to_patient_domain",ls_bill_to_patient_domain)
if isnull(ls_bill_to_patient_domain) then bill_to_patient_domain = false

if upper(left(ls_bill_to_patient_domain,1)) = "Y" or &
	upper(left(ls_bill_to_patient_domain,1)) = "T" Then
	bill_to_patient_domain = true
end if

return 1


end function

protected function long xx_post_encounter (string ps_cpr_id, long pl_encounter_id);/*************************************************************************************
*
* description:
*
* returns: -1 - Failure
*           1 - Success
*           0 - 
*
*************************************************************************************/

date ld_encounterdate
string      ls_date 
string		ls_office_id
string		ls_attending_doctor
string 		ls_referring_doctor
string 		ls_emptyarray[]
string		ls_facilitycode

is_cpt_assembly = ls_emptyarray[]
ii_cpt_count = 0
is_icd10_code = ls_emptyarray[]
//ii_diagnosis_count = 0

mylog.log(this, "u_component_billing_encounterpro.xx_post_encounter:0024", "Start(" + ps_cpr_id + ", " + string(pl_encounter_id) + ")", 1)
setnull(ls_attending_doctor)

// Get the EncounterPRO Billing ID
SELECT 	primary_provider_id
INTO 		:primary_provider_id
FROM 		p_Patient
WHERE 	cpr_id = :ps_cpr_id
USING 	cprdb;
IF NOT cprdb.check() THEN RETURN -1

IF cprdb.sqlcode = 100 THEN
	mylog.log(this, "u_component_billing_encounterpro.xx_post_encounter:0036", "Patient Record does not exist", 4)
	RETURN -1
END IF

// get info about the encounter
SELECT
	encounter_date,
	attending_doctor,
	supervising_doctor,
	office_id
INTO
	:idt_encounter_Date,
	:ls_attending_doctor,
	:is_supervising_doctor,
	:ls_office_id
FROM p_Patient_Encounter
WHERE cpr_id = :ps_cpr_id
AND encounter_id = :pl_encounter_id
USING cprdb;
if not cprdb.check() then return -1

If cprdb.sqlcode = 100 then
	mylog.log(this, "u_component_billing_encounterpro.xx_post_encounter:0058", "Patient encounter Record does not exist ", 4)
	return -1
End If

ld_encounterdate = Date(idt_encounter_Date)
is_encounterdate = String(ld_encounterdate, "yyyymmdd")
is_attending_doctor = ls_attending_doctor
is_encounter_location = ls_office_id
// Get the billing code for this office
If isnull(ls_office_id) then 
	mylog.log(this, "u_component_billing_encounterpro.xx_post_encounter:0068", "office id is null, assumes default facility", 3)
	is_facilitycode = is_defaultfacility
else
	SELECT billing_id
	INTO :ls_FacilityCode
	FROM c_Office
	WHERE office_id = :ls_office_id
	USING cprdb;
	if not cprdb.check() then return -1
	if cprdb.sqlcode = 100 then
		mylog.log(this,"u_component_billing_encounterpro.xx_post_encounter:0078","office id(id="+ls_office_id+") dont have a match in c_office", 3)
		is_facilitycode = is_defaultfacility
	end if
	if isnull(ls_facilitycode) or ls_facilitycode = '' then
		is_facilitycode = is_defaultfacility
	else
		is_facilitycode = ls_facilitycode
	end if	
end if
return 1
end function

protected function long xx_post_other (string ps_cpr_id, long pl_encounter_id);//	declare local variables
string ls_patient_location,ls_doctor_id
string ls_office_id
string ls_internal_id
string ls_external_id
string ls_billing_id
string ls_facility
string ls_patient_Class
string ls_primary_provider_id
string ls_attending_provider_id
string ls_visitnumber_id
string ls_alternatevisitid_id
string ls_encounter_type
string ls_sending_destination
string ls_message_type
string ls_supervisor,ls_primary_provider
string ls_thisdate 
string ls_billing_doc
string ls_nullcheck
string ls_encounter_id,ls_filename
string ls_scheduledatetime 
integer li_sts, li_record_count
integer li_null[]
string ls_filepath
string ls_current_filename
long li_filehandle,ll_next_counter
long ll_provider_code
long ll_len, ll_start, ll_pos
long ll_count
string ls_line_break, ls_vertical_tab, ls_record, ls_left, ls_right
string ls_given,ls_family, ls_middle, ls_degree, ls_prefix, ls_suffix 
string ls_dgiven,ls_dfamily, ls_dmiddle, ls_ddegree, ls_dprefix, ls_dsuffix 
boolean lb_interface_arrival
datetime ld_scheduledatetime
string ls_drive,ls_directory,ls_inifilename,ls_iniextension
string ls_batch_billing,ls_billable_provider

DECLARE lsp_get_billable_provider PROCEDURE FOR sp_get_billable_provider
		@ps_attending_doctor = :is_attending_doctor,
		@ps_supervising_doctor = :is_supervising_doctor,
		@ps_primary_provider_id = :ls_primary_provider,
		@ps_billable_provider = :ls_billable_provider OUT Using Sqlca;

ls_encounter_id = string(pl_encounter_id)
setnull(ls_nullcheck)

If ii_cpt_count <= 0 then // Cancel the billing request
	log.log(this, "u_component_billing_encounterpro.xx_post_other:0048", "No billable CPT's & ICD10's for patient("+ps_cpr_id+","+string(pl_encounter_id)+")", 4)
	return -1
End if
if isnull(is_cpt_assembly[ii_cpt_count]) then
	ii_cpt_count --
end if

if ii_cpt_count <= 0 then // Cancel the billing request
	log.log(this, "u_component_billing_encounterpro.xx_post_other:0056", "No billable CPT's & ICD10's for patient("+ps_cpr_id+","+string(pl_encounter_id)+")", 4)
	return -1
End if

lb_interface_arrival = true
SELECT count(*)
INTO :ll_count
FROM		x_encounterpro_Arrived
WHERE	cpr_id = :ps_cpr_id AND
		encounter_id = :pl_encounter_id
USING 	cprdb;
IF NOT cprdb.check() THEN 
	log.log(this, "u_component_billing_encounterpro.xx_post_other:0068", "select from x_encounterpro_arrivel error(" + ps_cpr_id + ", " + string(pl_encounter_id) + ")", 3)
	RETURN -1
end if
	
IF ll_count = 0 THEN
	log.log(this, "u_component_billing_encounterpro.xx_post_other:0073", "no arrival encounter (" + ps_cpr_id + ", " + string(pl_encounter_id) + ")", 2)	
	lb_interface_arrival= false
	ls_facility = is_facilitycode
	ld_scheduledatetime = idt_encounter_date
ELSEIF ll_count = 1 THEN	
	SELECT 	billing_id,
				encounter_type,
				internal_id,
				external_id,
				patient_class,
				facility_namespaceid,
				primary_provider_id,
				visitnumber_id,
				alternatevisitid_id,
				destination,
				appointment_time
	INTO		:ls_billing_id,
				:ls_encounter_type,
				:ls_internal_id:li_null[1],
				:ls_external_id:li_null[2],
				:ls_patient_class:li_null[3],
				:ls_facility:li_null[4],
				:ls_primary_provider_id:li_null[5],
				:ls_visitnumber_id:li_null[6],
				:ls_alternatevisitid_id:li_null[7],
				:ls_sending_destination:li_null[8],
				:ld_scheduledatetime
	FROM		x_encounterpro_Arrived
	WHERE		cpr_id = :ps_cpr_id AND
				encounter_id = :pl_encounter_id
	USING 	cprdb;
	
	IF NOT cprdb.check() THEN 
		log.log(this, "u_component_billing_encounterpro.xx_post_other:0106", "select from x_encounterpro_arrivel error (" + ps_cpr_id + ", " + string(pl_encounter_id) + ")", 3)
		RETURN -1
	end if
ELSE
	DECLARE X_cursor Cursor for
		SELECT 	billing_id,
				encounter_type,
				internal_id,
				external_id,
				patient_class,
				facility_namespaceid,
				primary_provider_id,
				visitnumber_id,
				alternatevisitid_id,
				destination,
				appointment_time
		FROM		x_encounterpro_Arrived
		WHERE		cpr_id = :ps_cpr_id AND
				encounter_id = :pl_encounter_id
	USING 	cprdb;	
	OPEN X_CURSOR;	
	Fetch X_cursor
	INTO		:ls_billing_id,
				:ls_encounter_type,
				:ls_internal_id:li_null[1],
				:ls_external_id:li_null[2],
				:ls_patient_class:li_null[3],
				:ls_facility:li_null[4],
				:ls_primary_provider_id:li_null[5],
				:ls_visitnumber_id:li_null[6],
				:ls_alternatevisitid_id:li_null[7],
				:ls_sending_destination:li_null[8],
				:ld_scheduledatetime;
		IF NOT cprdb.check() THEN 
		log.log(this, "u_component_billing_encounterpro.xx_post_other:0140", "Fetch from x_encounterpro_arrivel error (" + ps_cpr_id + ", " + string(pl_encounter_id) + ")", 3)
		RETURN -1
	end if
	CLOSE X_cursor;	
END IF	

ls_thisdate = string(idt_encounter_date,"yyyy/mm/dd hh:mm:ss")

//The MIK requires patient name
SELECT p_Patient.first_name,   
       p_Patient.last_name,   
       p_Patient.degree,   
       p_Patient.name_prefix,   
       p_Patient.middle_name,   
       p_Patient.name_suffix,
		p_Patient.billing_id,
		p_patient.primary_provider_id,
		p_patient.office_id
INTO :ls_given:li_null[9],   
      :ls_family:li_null[10],   
      :ls_degree:li_null[11],   
      :ls_prefix:li_null[12],   
      :ls_middle:li_null[13],   
      :ls_suffix:li_null[14],
		:ls_billing_id:li_null[15],
		:ls_primary_provider,
		:ls_patient_location
FROM p_Patient  
WHERE cpr_id = :ps_cpr_id using cprdb  ;
IF NOT cprdb.check() THEN 
	log.log(this, "u_component_billing_encounterpro.xx_post_other:0170", "patient record not found (" + ps_cpr_id  + ")", 3)
	RETURN -1
End if

if IsNull(ld_scheduledatetime) then 
	ls_scheduledatetime = ""
else
	ls_scheduledatetime = string(ld_scheduledatetime,"yyyy/mm/dd hh:mm:ss")
end if	

if isnull(ls_external_id) or ls_external_id = '' then
	ls_external_id = ls_billing_id
end if	

if isnull(ls_visitnumber_id) or ls_visitnumber_id = "" then
	if is_billingsystem = upper('MEDIC') then 
		ls_visitnumber_id = string(ps_cpr_id) + "." + string(pl_encounter_id) + "." + ls_thisdate
	else
		ls_visitnumber_id = ''
	end if
end if	

if is_billingsystem = upper('MILLBROOK') then
	ls_alternatevisitid_id = ps_cpr_id  + "." + string(pl_encounter_id)
	ls_alternatevisitid_id = left(ls_alternatevisitid_id,12)
	log.log(this, "u_component_billing_encounterpro.xx_post_other:0195", "millbrook visit id (" + ls_visitnumber_id + ")" + " encounterpro visit id (" + ls_alternatevisitid_id + ")" + " scheduledatetime (" + ls_scheduledatetime+ ")", 2)	
end if	

if isnull(ls_patient_class) then ls_patient_class = ""

// Get the billable Provider
EXECUTE lsp_get_billable_provider;
if not tf_check() then return -1
FETCH lsp_get_billable_provider INTO :ls_billable_provider;
if not tf_check() then return -1
CLOSE lsp_get_billable_provider;
if not tf_check() then return -1

IF isnull(ls_billable_provider) THEN 
	log.log(this, "u_component_billing_encounterpro.xx_post_other:0209", "BILLING FAILED.Attending doctor ("+is_attending_doctor+" ) for patient("+ps_cpr_id+"," + string(pl_encounter_id)+"  dont have valid billing code and he also dont have valid supervisor's billing code.", 4)
	RETURN -1
End if	
log.log(this,"u_component_billing_encounterpro.xx_post_other:0212","Billable Provider ID & Code:"+ls_billable_provider,2)

//The MIK requires doctor name
 SELECT c_User.first_name,   
         c_User.middle_name,   
         c_User.last_name,   
         c_User.degree,   
         c_User.name_prefix,   
         c_User.name_suffix,
			c_User.billing_id,
			c_User.billing_code
    INTO :ls_dgiven:li_null[15],      
         :ls_dmiddle:li_null[16],    
         :ls_dfamily:li_null[17],   
         :ls_ddegree:li_null[18],  
         :ls_dprefix:li_null[19], 
         :ls_dsuffix:li_null[20],
	      :ls_attending_provider_id:li_null[21],
			:ll_provider_code:li_null[22]
    FROM c_user  
   WHERE c_user.billing_id = :ls_billable_provider using cprdb ;
IF NOT cprdb.check() THEN 
		log.log(this, "u_component_billing_encounterpro.xx_post_other:0234", "provider record not found (" + is_attending_doctor  + ")", 3)
		RETURN -1
end if

ls_billing_doc = ls_attending_provider_id 

//The filewrite hates nulls ...so convert to empty	
ls_facility = is_facilitycode // the facility of patient encounter
if IsNull(ls_given) then ls_given = ""
if IsNull(ls_family) then ls_family = ""
if IsNull(ls_degree) then ls_degree = ""
if IsNull(ls_prefix) then ls_prefix = ""	
if IsNull(ls_middle) then ls_middle = ""
if IsNull(ls_suffix) then ls_suffix = ""
If Isnull(ls_facility) or ls_facility = "" then ls_facility = is_defaultfacility
If IsNull(ls_sending_destination) then ls_sending_destination = ""
If ls_billing_doc = '0' or isnull(ls_billing_doc) or trim(ls_billing_doc) = "" then
	log.log(this, "u_component_billing_encounterpro.xx_post_other:0251", "BILLING FAILED.Attending doctor ("+is_attending_doctor+" ) for patient("+ps_cpr_id+"," + string(pl_encounter_id)+"  dont have valid billing code and he also dont have valid supervisor's billing code.", 4)
	RETURN -1
End if
if IsNull(ls_dgiven) then ls_dgiven = ""
if IsNull(ls_dfamily) then ls_dfamily = ""
if IsNull(ls_ddegree) then ls_ddegree = ""
if IsNull(ls_dprefix) then ls_dprefix = ""	
if IsNull(ls_dmiddle) then ls_dmiddle = ""
if IsNull(ls_dsuffix) then ls_dsuffix = ""

//	A fully qualified path is now available in ls_filepath
f_parse_filepath(gnv_app.ini_file,ls_drive,ls_directory,ls_inifilename,ls_iniextension)

ls_filepath = ls_drive + ls_directory
if right(ls_filepath, 1) <> "\" then ls_filepath += "\"
ls_filepath += "Messages"

if not mylog.of_directoryexists(ls_filepath) then
	mylog.log(this, "u_component_billing_encounterpro.xx_post_other:0269", "Error getting temp path "+ls_filepath, 4)
	return -1
end if
if right(ls_filepath, 1) <> "\" then ls_filepath += "\"

// First, Create and open a new file
ls_current_filename = ps_cpr_id + string(pl_encounter_id) + String(Now(),"hhmmssff")
// The qualified file path will now added to the front of the filename and ".txt" will be appended
ls_current_filename = trim(ls_filepath) + trim(ls_current_filename) + ".txt"

if fileexists(ls_current_filename) then 
	filedelete(ls_current_filename)
end if
li_filehandle = fileopen(ls_current_filename,LineMode!,Write!,Shared!,Append!)
// If the fileopen() function fails and returns -1 then Quit returning -1, we got a problem
IF li_filehandle = -1 THEN 
	log.log(this, "u_component_billing_encounterpro.xx_post_other:0285", "The FileOpen function failed...Aborted )", 4)
	RETURN -1		
END IF
log.log(this, "u_component_billing_encounterpro.xx_post_other:0288", "Filename ("+ls_current_filename+") File handle("+string(li_filehandle)+")", 1)

u_component_messageserver luo_messageserver
// Pass the filename to the message server
ls_message_type = get_attribute("MESSAGE_TYPE")
if isnull(ls_message_type) then ls_message_type = "ENCOUNTERPRO_CHECKOUT"
ls_batch_billing = 'N'

if upper(is_billingsystem) = 'SHANDS' Then
	ls_batch_billing = get_attribute("batch_billing")

	If upper(left(ls_batch_billing,1)) = "Y" or upper(left(ls_batch_billing,1)) = "T" then
		ls_batch_billing = "Y"
	Else
		ls_batch_billing = "N"
	End If
end if

// If the message was created successfully, then ship it.
luo_messageserver = my_component_manager.get_component("JMJMESSAGESERVER")
if isnull(luo_messageserver) then
	log.log(this, "u_component_billing_encounterpro.xx_post_other:0309", "Unable to get messageserver component", 4)
	return -1
end if

//blob b, b_piece
ls_line_break = "~013"
ls_vertical_tab = "~v"
string ls_cpt_assembly
//string flatwire
integer i, li_loops, j, k, l 

//ls_record = "HL7DFTP03" + ls_line_break + string(ii_cpt_count) + ls_line_break
//li_sts = FileWrite(li_filehandle,ls_record)
ls_record = ""

if Isnull(ls_alternatevisitid_id) then
	ls_alternatevisitid_id = ""
end if

// 2 PMS Database - 1 EPRO database, do user,patient translation
// also decide the bill sent location 
If bill_to_patient_domain then
	ls_office_id = ls_patient_location
	SELECT billing_id
	INTO :ls_facility
	FROM c_Office
	WHERE office_id = :ls_patient_location
	USING cprdb;
else
	ls_office_id = is_encounter_location
	SELECT billing_id
	INTO :ls_facility
	FROM c_Office
	WHERE office_id = :is_encounter_location
	USING cprdb;
end if

if not cprdb.check() then 
	mylog.log(this, "u_component_billing_encounterpro.xx_post_other:0347", "get billing code not OK (" + ps_cpr_id + ", " + string(pl_encounter_id) + ")", 3)
	return -1
end if
if isnull(ls_office_id) or len(ls_office_id) = 0 then
	mylog.log(this, "u_component_billing_encounterpro.xx_post_other:0351", "unable to find patient billing domain (" + ps_cpr_id + ", " + string(pl_encounter_id) + ")", 3)
	return -1
end if

// translater patient id
ls_billing_id = sqlca.fn_lookup_patient_billingid(billing_id_domain,ps_cpr_id)
if isnull(ls_billing_id) or ls_billing_id = "" then ls_billing_id = ls_external_id
if Isnull(ls_billing_id) then ls_billing_id = ""

// Translate a provider
/*ls_attending_provider_id = sqlca.fn_lookup_user_billingid(ls_office_id,ls_billable_provider)
if isnull(ls_attending_provider_id) or ls_attending_provider_id = "" then ls_attending_provider_id = ls_billable_provider
*/
ls_attending_provider_id = ls_billable_provider
ls_billing_doc = ls_attending_provider_id 

// check for nulls
if Isnull(ls_alternatevisitid_id) then	ls_alternatevisitid_id = ""
if Isnull(ls_visitnumber_id) then ls_visitnumber_id = ""
if Isnull(ls_internal_id) then ls_internal_id = ""
if isnull(ls_facility) then ls_facility = ""

ls_record = "HL7DFTP03" + ls_line_break 
ls_record += trim(string(ii_cpt_count)) + ls_line_break
ls_record += ls_facility + ls_line_break
ls_record += ls_sending_destination + ls_line_break
ls_record += ls_internal_id + ls_line_break
ls_record += ls_billing_id + ls_line_break
ls_record += ls_thisdate + ls_line_break
ls_record += ls_billing_doc + ls_line_break
ls_record += ls_visitnumber_id + ls_line_break
ls_record += ls_alternatevisitid_id + ls_line_break
ls_record += ls_family + ls_line_break
ls_record += ls_given + ls_line_break
ls_record += ls_middle + ls_line_break
ls_record += ls_suffix + ls_line_break
ls_record += ls_prefix + ls_line_break
ls_record += ls_degree + ls_line_break
ls_record += ls_dfamily + ls_line_break
ls_record += ls_dgiven + ls_line_break
ls_record += ls_dmiddle + ls_line_break
ls_record += ls_dsuffix + ls_line_break
ls_record += ls_dprefix + ls_line_break
ls_record += ls_ddegree + ls_line_break
ls_record += ls_scheduledatetime + ls_line_break
for i = 1 to ii_cpt_count
	ls_cpt_assembly = is_cpt_assembly[i]
	ll_len = Len(ls_cpt_assembly)
	IF ll_len = 0  or ls_cpt_assembly = "" then CONTINUE
	ls_record += ls_cpt_assembly
	ls_record += ls_vertical_tab
	li_record_count ++
Next
k = integer(len(ls_record))
for l = 1 to k
	j =  pos(ls_record,ls_nullcheck,ll_start)
	if j > 0 then
		ls_left = Left(ls_record, j - 1)
		ls_right = Mid(ls_record, j + 1)
		ls_record = ls_left + "" + ls_right
		ll_start = long(j + 1)
	else
		l = k
	end if
next
if li_record_count > 0 then
	log.log(this, "u_component_billing_encounterpro.xx_post_other:0417", "write HL7DFTP03 record for " + ls_family + "," + ls_given + ", cpt count+" + string(li_record_count), 1)
	li_sts = FileWrite(li_filehandle,ls_record)	
end if	
log.log(this, "u_component_billing_encounterpro.xx_post_other:0420", "message ("+ls_record+")", 1)
// Close the file
li_sts = FileClose(li_Filehandle)
IF li_sts < 0 THEN
	log.log(this, "u_component_billing_encounterpro.xx_post_other:0424", "The FileClose function failed...Aborted )", 4)
	RETURN -1
END IF
if li_record_count <= 0 then 
	log.log(this, "u_component_billing_encounterpro.xx_post_other:0428", "Posting Failed:No billable CPT's & ICD10's for patient("+ps_cpr_id+","+string(pl_encounter_id)+")", 4)
	return -1
end if

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Post the file as an attachment to the bill service
string ls_folder
long ll_attachment_id

setnull(ls_folder)

if not isnull(current_service) then
	ll_attachment_id = current_service.new_attachment("ATTACHMENT", "BILLING", ls_current_filename, "Billing HL7 Data", ls_folder)
end if
////////////////////////////////////////////////////////////////////////////////////////////////////////////////



log.log(this, "u_component_billing_encounterpro.xx_post_other:0446", "send_to_subscribers begin", 1)
li_sts = luo_messageserver.send_to_subscribers(ls_message_type, ls_current_filename,ps_cpr_id,pl_encounter_id,ls_batch_billing)
if li_sts < 1 then return li_sts
log.log(this, "u_component_billing_encounterpro.xx_post_other:0449", "send_to_subscribers end", 1)

my_component_manager.destroy_component(luo_messageserver)

RETURN 1
end function

on u_component_billing_encounterpro.create
call super::create
end on

on u_component_billing_encounterpro.destroy
call super::destroy
end on

