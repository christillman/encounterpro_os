HA$PBExportHeader$u_component_billing_foxmeadows.sru
forward
global type u_component_billing_foxmeadows from u_component_billing
end type
type str_foxmeadows_out from structure within u_component_billing_foxmeadows
end type
end forward

type str_foxmeadows_out from structure
	integer		row_num
	string		cpr_id
	long		encounter_id
	integer		encounter_charge_id
	long		encounter_number
	long		account_number
	datetime	encounter_date_time
	string		encounter_type
	string		chief_complaint
	string		indirect_flag
	long		attending_doctor
	string		new_flag
	string		courtesy_code
	string		billing_note
	string		icd_9_code1
	string		icd_9_code2
	string		icd_9_code3
	string		icd_9_code4
	string		cpt_code
	string		modifier
	string		other_modifiers
	long		units
	decimal {2}	charge
end type

shared variables

end variables

global type u_component_billing_foxmeadows from u_component_billing
end type
global u_component_billing_foxmeadows u_component_billing_foxmeadows

type variables
integer li_charge_count
integer li_icd9_codes

long sl_attending_doctor

string is_icd_9_code[]
integer ii_assessment_seq[], ii_cpt_count
string is_cpt_assembly[]
string ss_charge_acct
string is_encounter_id
string is_encounter_type
string is_indirect_flag
string is_new_flag
string is_courtesy_code
string is_billing_note 
string is_doctor_id
string is_chief_complaint
string ss_Facility
string is_encounterdate
end variables

forward prototypes
public function integer get_new_id (string ps_idtype, ref long pl_id)
public function integer get_carriers (long pl_patientprofileid, ref long pl_currentcarrier, ref long pl_primarypicarrierid, ref long pl_primaryinsurancecarriersid, ref long pla_patientinsuranceid[], ref integer pi_insurance_count, ref long pl_currentpicarrierid, ref long pl_currentinsurancecarriersid, ref long pl_filingmethodmlc, ref integer pi_acceptassignment)
protected function long xx_post_other (string ps_cpr_id, long pl_encounter_id)
protected function long xx_post_treatment (string ps_cpr_id, long pl_encounter_id, long pl_encounter_charge_id)
public function integer xx_initialize ()
protected function integer xx_xref_procedure (string ps_cpt_code)
protected function long xx_post_assessment (string ps_cpr_id, long pl_encounter_id, long pl_problem_id, integer pi_assessment_sequence)
protected function integer xx_xref_assessment (string ps_icd9_code)
protected function long xx_post_encounter (string ps_cpr_id, long pl_encounter_id)
end prototypes

public function integer get_new_id (string ps_idtype, ref long pl_id);/*
Function Name:	get_new_id for u_component_billing_foxmeadows
Date Begun:		
Programmer:		
Purpose:		Not Defined
Expects:		Not Defined
Returns"		Integer
Limits:			Not Defined
History			None
Note:				

11/09/98:	Not currently used in this object
*/

RETURN 1



end function

public function integer get_carriers (long pl_patientprofileid, ref long pl_currentcarrier, ref long pl_primarypicarrierid, ref long pl_primaryinsurancecarriersid, ref long pla_patientinsuranceid[], ref integer pi_insurance_count, ref long pl_currentpicarrierid, ref long pl_currentinsurancecarriersid, ref long pl_filingmethodmlc, ref integer pi_acceptassignment);/*
Function Name:	get_carriers for u_component_billing_foxmeadows
Date Begun:		
Programmer:		
Purpose:		Not Defined
Expects:		Not Defined
Returns"		Integer
Limits:			Not Defined
History			None
Note:				

declare local variables
11/09/98:	Not currently used in this object
*/

RETURN 1


end function

protected function long xx_post_other (string ps_cpr_id, long pl_encounter_id);/*
Function Name:	xx_post_other for u_component_billing_foxmeadows
Date Begun:		
Programmer:		
Purpose:		Create and write uniquely named "transfer data files" which pass 
					completed encounter information to the foxmeadows application 
					by way of the "my_component_manager.message_server.send_to_subscribers()"
					function.  
Expects:			ps_cpr_id			string
					pl_encounter_id	long
Returns"			Integer
Limits:			None
History			New 1

Notes:			cprdb = EncounterPRO database
					This will create a filename + the ".txt" (foxmeadowsXfer)
					extension.  
*/
//1.	foxmeadows Encounter Number
//2.	foxmeadows Account number
//3.	Encounter date/time	
//4.	foxmeadows encounter_type
//5	Chief Complaint
//06.	indirect_flag  d=direct, i=indirect, n = notapplicable
//07.	foxmeadows attending docter (long)
//08.	new_flag
//09.	courtesy_code
//10.	billing_note
//11.	icd_9_code1
//12.	icd_9_code2
//13.	icd_9_code3
//14.	icd_9_code4
//15.	cpt_code
//16.	modifier
//17.	other_modifiers
//18.	units
//19.	charge
//20. facility id (for medisys) 

//	declare local variables

boolean 	lb_loop						// Loop "continue or stop" flag
integer	li_array_null				//	Status variable to report function array_null result
integer	li_filehandle				// Transfer file filehandle
integer	li_write_sts				// Status variable to report FileWrite result
integer 	li_file_sts					//	Status variable to report FileClose result
integer	li_sts						// Status variable for RegistryGet() function
integer 	ti_loop_count				// Current element counter for the data arrays
integer  i,j,k
long     ll_len,ll_start
string   ls_left,ls_right
string	ls_current_filename		// Current filename (Time to 8 places...100th of a second)
string 	ls_filepath					//	Filepath for the transfer files
string 	ls_foxmeadows_row				//	Variable to store each row prior to writing &
											//	into the transfer file
string	ls_message_type			// Variable for the message_type returned from the &
											// get_attribute() function
string   ls_nullcheck
string 	ls_filename,ls_drive,ls_directory,ls_inifilename,ls_iniextension
long 		ll_next_counter
setnull(ls_nullcheck)
u_component_messageserver luo_messageserver

ti_loop_count = 1
lb_loop = TRUE

//	A fully qualified path is now available in ls_filepath
/*
ls_filepath = temp_path
if not mylog.of_directoryexists(ls_filepath) then
	mylog.log(this, "xx_post_other()", "Error getting temp path "+ls_filepath, 4)
	return -1
end if
*/
f_parse_filepath(ini_file,ls_drive,ls_directory,ls_inifilename,ls_iniextension)

ls_filepath = ls_drive+ls_directory
if right(ls_filepath, 1) <> "\" then ls_filepath += "\"
ls_filepath += "Messages"

if not mylog.of_directoryexists(ls_filepath) then
	mylog.log(this, "xx_post_other()", "Error getting temp path "+ls_filepath, 4)
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

// Now ready to open the file and pass the file number to integer variable li_filehandle
li_filehandle = fileopen(ls_current_filename,LineMode!,Write!,Shared!,Append!)
// If the fileopen() function fails and returns -1 then Quit returning -1, we got a problem
IF li_filehandle = -1 THEN 
	mylog.log(this, "xx_post_other()", "The FileOpen function failed...Aborted Billing (" + ps_cpr_id + ", " + string(pl_encounter_id) + ")", 4)
	RETURN -1		
END IF

if isnull(is_encounter_id) then is_encounter_id = ""
if isnull(ss_charge_acct) then ss_charge_acct = ""
if isnull(is_encounterdate) then is_encounterdate = ""
if isnull(is_encounter_type) then is_encounter_type = ""
if isnull(is_chief_complaint) then is_chief_complaint = ""
if isnull(is_indirect_flag) then is_indirect_flag = ""
if isnull(is_doctor_id) then is_doctor_id = ""
if isnull(is_new_flag) then is_new_flag = ""
if isnull(is_courtesy_code) then is_courtesy_code = ""
if isnull(is_billing_note) then is_billing_note = ""
if isnull(ss_facility) then ss_facility = ""

For  ti_loop_count  = 1 to  ii_cpt_count 
		if isnull(is_cpt_assembly[ti_loop_count]) then continue
		
		// populate one element of each array for each row as we loop through
		ls_foxmeadows_row = '~"' + "CHG" + '~"' 
		ls_foxmeadows_row += ","+'~"' + is_encounter_id + '~"' 
		ls_foxmeadows_row += ","+'~"' + ss_charge_acct + '~"'
		ls_foxmeadows_row += ","+'~"' + is_encounterdate + '~"'
		ls_foxmeadows_row += ","+'~"' + is_encounter_type + '~"'
		ls_foxmeadows_row += ","+'~"' + is_chief_complaint + '~"'
		ls_foxmeadows_row += ","+'~"' + is_indirect_flag + '~"'
		ls_foxmeadows_row += ","+'~"' + is_doctor_id + '~"'
		ls_foxmeadows_row += ","+'~"' + is_new_flag + '~"'
		ls_foxmeadows_row += ","+'~"' + is_courtesy_code + '~"'
		ls_foxmeadows_row += ","+'~"' + is_billing_note + '~"'
		ls_foxmeadows_row += ","+ is_cpt_assembly[ti_loop_count] 	
		ls_foxmeadows_row += ","+'~"' + ss_facility + '~"'
		//check for nulls	again
		ll_len = len(ls_foxmeadows_row)
		ll_start = 1
		k = int(ll_len)
		for i = 1 to k
			j =  pos(ls_foxmeadows_row,ls_nullcheck,ll_start)
			if j > 0 then
				ls_left = Left(ls_foxmeadows_row, j - 1)
				ls_right = Mid(ls_foxmeadows_row, j + 1)
				ls_foxmeadows_row = ls_left + "" + ls_right
				ll_start = long(j + 1)
			else
				i = k
			end if
		next	
		// Write the row to the previously named and opened file
		ll_len = len(ls_foxmeadows_row)
		if isnull(ll_len) or ll_len = 0 then
			mylog.log(this, "xx_post_other()", "o length record...Aborted Billing (" + ps_cpr_id + ", " + string(pl_encounter_id) + ")", 4)
			RETURN -1
		end if	
//		mylog.log(this, "xx_post_other()", "Row " + ls_foxmeadows_row , 2)
		li_write_sts = FileWrite(li_filehandle,ls_foxmeadows_row)	
				IF li_write_sts < 0 THEN 
			mylog.log(this, "xx_post_other()", "The FileWrite function failed...Aborted Billing (" + ps_cpr_id + ", " + string(pl_encounter_id) + ")", 4)
			RETURN -1
		END IF

Next

// Close the file
li_file_sts = FileClose(li_filehandle)

IF li_file_sts < 0 THEN
	mylog.log(this, "xx_post_other()", "The FileClose function failed...Aborted Billing (" + ps_cpr_id + ", " + string(pl_encounter_id) + ")", 4)
	RETURN -1
END IF

long ll_filelen
ll_filelen = FileLength(ls_current_filename)
If ll_filelen < 1 then 
	mylog.log(this, "xx_post_other()", "No file length (" + ps_cpr_id + ", " + string(pl_encounter_id) + ")", 4)
	return 1
end if

// Pass the filename to the message server
ls_message_type = get_attribute("MESSAGE_TYPE")
if isnull(ls_message_type) then
	ls_message_type = "FOXMEADOWS_CHECKOUT"
end if	
// If the message was created successfully, then ship it.

luo_messageserver = my_component_manager.get_component("JMJMESSAGESERVER")
if isnull(luo_messageserver) then
	mylog.log(this, "xx_post_other()", "Unable to get messageserver component", 4)
	return -1
end if

mylog.log(this, "xx_post_other()", "send "+ ls_message_type + ", " + ls_current_filename, 2)
li_sts = luo_messageserver.send_to_subscribers(ls_message_type, ls_current_filename,ps_cpr_id,pl_encounter_id)

my_component_manager.destroy_component(luo_messageserver)

if li_sts <= 0 then
	mylog.log(this, "xx_post_other()", "Error sending message", 4)
	return -1
end if

IF li_sts < 0 THEN
	mylog.log(this, "xx_post_other()", "The Message_Server.send_to_subscribers function failed...Aborted Billing (" + ps_cpr_id + ", " + string(pl_encounter_id) + ")", 4)
	RETURN -1
END IF

// Return 1, now going back to post_encounter of u_component_billing

RETURN 1

end function

protected function long xx_post_treatment (string ps_cpr_id, long pl_encounter_id, long pl_encounter_charge_id);/*
Function Name:	xx_post_treatment for u_component_billing_foxmeadows

Purpose:			Not Defined
Expects:			Not Defined
Returns"			Integer
Limits:			Not Defined
History:			None
Note:				mydb  = billing database
*/

// declare local variables
long ll_treatment_id
long ll_treatment_billing_id
string ls_procedure_type
string ls_procedure_id
decimal ldc_encounter_charge
string ls_charge_bill_flag
string dbc_row

integer li_write_sts,li_charge_units
decimal ldc_procedure_charge
long ll_assessment_billing_id1
long ll_assessment_billing_id2
long ll_assessment_billing_id3
long ll_assessment_billing_id4
long ll_problem_id
integer li_assessment_sequence
long ll_assessment_billing_id
string ls_assessment_bill_flag
string ls_assessment_charge_bill_flag
boolean lb_loop
integer li_diagnum
integer li_DiagnosisPointer
string ls_treatment_description
string ls_cpt_code,ls_unit

long ll_PatientID
string ls_facilitycode
long ll_PatientVisitId
long ll_ProceduresID
string ls_TxnModifier

real lr_procedure_units
string ls_code
integer li_sts
boolean lb_exists
string ls_insurance_id
string ls_modifier
string ls_other_modifiers
string ls_temp_icd9
decimal{2} 	ld_charge						
integer 		li_encounter_charge_id		
integer 		li_enc_assmnt_chg_cnt		
integer 		li_enc_assmnt_seq_limit	
integer 		li_icd_9_ctr 
integer 		lic_problem_id	
integer     li_temp_seq 
string 		lsc_assessment_id

long 			i
integer 		j, k, l, m, n

boolean		lb_icd9_hit[]


// Declare procedure which determines cpt_code
//CWW, BEGIN
u_ds_data luo_sp_get_procedure_cpt
integer li_spdw_count
// DECLARE lsp_get_procedure_cpt PROCEDURE FOR dbo.sp_get_procedure_cpt
//         @ps_cpr_id = :ps_cpr_id,
//			@ps_procedure_id = :ls_procedure_id,
//			@ps_insurance_id = :ls_insurance_id OUT,
//			@ps_cpt_code = :ls_cpt_code OUT,
//			@ps_modifier = :ls_modifier OUT,
//			@ps_other_modifiers = :ls_other_modifiers OUT,
//			@pr_units = :lr_procedure_units OUT,
//			@pdc_charge = :ldc_procedure_charge OUT
// USING cprdb;
 //CWW, END

// declare local alias for get treatment assessments stored procedure
DECLARE lsp_get_treatment_assessments PROCEDURE FOR dbo.sp_get_treatment_assessments  
   @ps_cpr_id = :ps_cpr_id,   
   @pl_encounter_id = :pl_encounter_id,   
   @pl_encounter_charge_id = :pl_encounter_charge_id
USING cprdb;

//mylog.log(this, "xx_post_treatment()", "treatment start (" + ps_cpr_id + ", " + string(pl_encounter_id) + ", " + string(pl_encounter_charge_id) + ")", 2)	

EXECUTE lsp_get_treatment_assessments;
if not cprdb.check() then 
	mylog.log(this, "xx_post_treatment()", "EXECUTE lsp_get_treatment_assessments (" + ps_cpr_id + ", " + string(pl_encounter_id) + ")", 3)	
	return -1
end if	

lb_loop = true
li_diagnum = 0
i = upperbound(is_icd_9_code)
j = integer(i)

//set the hit to false
for k = 1 to j
	lb_icd9_hit[k] = false
next

//bubbleup sort for the assessment so that the icd9 codes are in sequence
if j > 1 then
	n = j - 1
	for m = 1 to n
		for k = j to 2 step -1
			l = k - 1
			if ii_assessment_seq[k] < ii_assessment_seq[l] then
				li_temp_seq = ii_assessment_seq[l]
				ls_temp_icd9 = is_icd_9_code[l]
				ii_assessment_seq[l] = ii_assessment_seq[k]
				is_icd_9_code[l]  = is_icd_9_code[k]
				ii_assessment_seq[k] = li_temp_seq
				is_icd_9_code[k] = ls_temp_icd9
			end if
		next	
	next
end if	

DO
	FETCH lsp_get_treatment_assessments
	INTO :ll_problem_id,
			:li_assessment_sequence,
			:ll_assessment_billing_id,
			:ls_assessment_bill_flag,
			:ls_assessment_charge_bill_flag;
			
	if not cprdb.check() then 
		mylog.log(this, "xx_post_treatment()", "The Fetch not ok for lsp_get_treatment_assessments (" + ps_cpr_id + ", " + string(pl_encounter_id) +  ")", 3)	
		return -1
	end if	

	if cprdb.sqlcode = 0 then
		if ls_assessment_bill_flag = "N" then continue
		if ls_assessment_charge_bill_flag = "N" then continue
		if isnull(li_assessment_sequence) then continue
		for k = 1 to j
			if ii_assessment_seq[k] = li_assessment_sequence then
				lb_icd9_hit[k] = true
			end if		
		next	
	else
		lb_loop = false
	end if
	
LOOP WHILE lb_loop

CLOSE lsp_get_treatment_assessments;

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
	mylog.log(this, "xx_post_treatment()", "treatment charge access (" + ps_cpr_id + ", " + string(pl_encounter_id) + ")", 3)	
	return -1
end if	
if cprdb.sqlcode = 100 then
	mylog.log(this, "xx_post_treatment()", "treatment charge not found (" + ps_cpr_id + ", " + string(pl_encounter_id) + ", " + string(pl_encounter_charge_id) + ")", 3)	
	return 0
end if	

// Now determine the cpt_code and other stuff
//CWW, BEGIN
//EXECUTE lsp_get_procedure_cpt;
//if not cprdb.check() then 
//	mylog.log(this, "xx_post_treatment()", "EXECUTE lsp_get_procedure_cpt (" + ps_cpr_id + ", " + string(pl_encounter_id) + ")", 3)
//	return -1
//end if
//
//FETCH lsp_get_procedure_cpt INTO
//		:ls_insurance_id ,
//		:ls_cpt_code ,
//		:ls_modifier ,
//		:ls_other_modifiers ,
//		:lr_procedure_units ,
//		:ldc_procedure_charge ;
//if not cprdb.check() then 
//	mylog.log(this, "xx_post_treatment()", "The Fetch not ok for lsp_get_procedure_cpt (" + ps_cpr_id + ", " + string(pl_encounter_id) +  ")", 3)	
//	return -1
//end if
//CLOSE lsp_get_procedure_cpt;

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
else
	ls_insurance_id = luo_sp_get_procedure_cpt.object.authority_id[1]
	ls_cpt_code = luo_sp_get_procedure_cpt.object.cpt_code[1]
	ls_modifier = luo_sp_get_procedure_cpt.object.modifier[1]
	ls_other_modifiers = luo_sp_get_procedure_cpt.object.other_modifiers[1]
	lr_procedure_units = luo_sp_get_procedure_cpt.object.units[1]
	ldc_procedure_charge = luo_sp_get_procedure_cpt.object.charge[1]
end if
destroy luo_sp_get_procedure_cpt
//CWW, END

if isnull(ls_cpt_code) or ls_cpt_code = "" then
	mylog.log(this, "xx_post_treatment()", "no cpt code for lsp_get_procedure_cpt (" + ps_cpr_id + ", " + string(pl_encounter_id) + ", " + ls_procedure_id + ")", 3)	
	return -1
end if

// Get the billing code
//SELECT billing_code
//INTO :ll_ProceduresID
//FROM c_Procedure
//WHERE procedure_id = :ls_procedure_id
//USING cprdb;
//if not cprdb.check() then 
//	mylog.log(this, "xx_post_treatment()", "select billing code failed (" + ps_cpr_id + ", " + string(pl_encounter_id) +  ")", 3)	
//	return -1
//end if	
//if cprdb.sqlcode = 100 then 
//	mylog.log(this, "xx_post_treatment()", "no billing code (" + ps_cpr_id + ", " + string(pl_encounter_id) + ", " + ls_procedure_id +  ")", 3)	
//	return 0
//end if	

// Determine the codes for the billing system
if isnull(ldc_encounter_charge) and not isnull(ldc_procedure_charge) then
	ldc_encounter_charge = ldc_procedure_charge
end if

if isnull(ls_modifier) then 
	ls_modifier = ""
end if

if isnull(ls_other_modifiers) then
	ls_other_modifiers = ""
end if

string ls_charge
if isnull(ldc_encounter_charge) then 
	ls_charge = '""' 
else 
	ls_charge = '"' + string(ldc_encounter_charge) + '"'
end if	


/////////////////////////////////////////////
string ls_cpt_assembly
integer li_count
li_count = 0
setnull(ls_cpt_assembly)
for k = 1 to j
	if lb_icd9_hit[k] = true then
		if isnull(is_icd_9_code[k]) then
			if isnull(ls_cpt_assembly) then
				ls_cpt_assembly = '"",'
			else	
				ls_cpt_assembly += '"",'
			end if	
		else
			if isnull(ls_cpt_assembly) then
				ls_cpt_assembly = '"' + is_icd_9_code[k] + '"' + ','
			else
				ls_cpt_assembly += '"' + is_icd_9_code[k] + '"' + ','
			end if	
		end if	
		li_count ++
	end if
	if li_count = 4 then exit
next
if li_count < 4 then
	j = li_count + 1
	for k = j to 4
		ls_cpt_assembly += '"",'
	next
end if	
if isnull(lr_procedure_units) or lr_procedure_units <= 0 then lr_procedure_units = 1
// if p_encounter_charge units is filled in use it otherwise get the unit from procedure table
if isnull(li_charge_units) or li_charge_units <= 0 then 
	ls_unit = String(lr_procedure_units)
else
	ls_unit = String(li_charge_units)
end if

ls_cpt_assembly += '"' + ls_cpt_code + '"' + ',' + '"' + ls_modifier + '"' + ',' + '"' + ls_other_modifiers + '"'
ls_cpt_assembly += ',' + '"' + ls_unit + '"' + ',' + ls_charge
if not isnull(ls_cpt_assembly) then
	ii_cpt_count ++
	is_cpt_assembly[ii_cpt_count] = ls_cpt_assembly
end if	
// once the cpt code is included then set the flag as posted
Update p_encounter_charge
	set posted = 'Y'
where cpr_id = :ps_cpr_id
	and encounter_id = :pl_encounter_id
	and encounter_charge_id = :pl_encounter_charge_id
using cprdb;
////////////////////////////////////////////

RETURN 1


end function

public function integer xx_initialize ();//	Function Name:	initialize for u_component_billing_foxmeadows
//	Date Begun:		
//	Programmer:		
//	Purpose:		Container for user object documentation
//	Expects:		Nothing
//	Returns:		Integer
//	Limits:			None
//	History			Clone of u_component_billing_paradigm3
//	Notes:		

/* 
Whenever the foxmeadows Billing user object is initialized, the 
following variable array declarations are made.  These 
arrays are the temporary repositories for data which will 
be passed to the Medical Manager billing application by 
the server version of the EncounterPro application.  These 
values communicate to the Medical Manager application,
information necessary to bill the encounter.
===============================================================
integer si_row_num[]................Row counter to read and write individual rows 
												for each encounter 
string ss_cpr_id[]..................Cpr_id of this encounter	
long sl_encounter_id[]..............Encounter_id of this encounter
integer si_encounter_charge_id[]....Encounter_charge_id of this encounter
long sl_encounter_number[]..........p_Patient_Encounter.billing_id
long sl_account_number[]............p_Patient.billing_id
datetime sdt_encounter_date_time[]..p_Patient_Encounter.encounter_date
string ss_encounter_type[]..........p_Patient_Encounter.encounter_type
string ss_chief_complaint[].........p_Patient_Encounter.chief_complaint
string ss_indirect_flag[]...........p_Patient_Encounter.indirect_flag
long sl_attending_doctor[]..........Retrieve attending Doctor, a string value from p_Patient_encounter
												.attending_doctor (string) into ls_attending_doctor.	
												Use ls_attending_doctor to get c_Provider.billing_code (integer) 
												from c_Provider_Id into ll_attending_doctor
string ss_new_flag[]................p_Patient_Encounter.new_flag
string ss_courtesy_code[]...........p_Patient_Encounter.courtesy_code
string ss_billing_note[]............p_Patient_Encounter.billing.note
string ss_icd_9_code1[].............c_Assessment_Definition
string ss_icd_9_code2[].............c_Assessment_Definition
string ss_icd_9_code3[].............c_Assessment_Definition
string ss_icd_9_code4[].............c_Assessment_Definition
string ss_cpt_code[]................c_Procedure.cpt_code		
string ss_modifier[]................c_Procedure.modifier
string ss_other_modifiers[].........c_Procedure.other_modifiers
long sl_units[].....................c_Procedure.units
dec{2} sd_charge[]..................c_Procedure.charge

These array variables exist during the life of the 
billing record processing.  As passes are made through the 
first billing function, xx_post_encounter, information on this
specific encounter is accumulated.  As the information is 
gathered, the appropriate fields are populated.  Any fields 
not populated with database data during the pass through 
xx_post_encounter, are populated with zero for numeric fields 
and empty strings are placed into character fields.  
All elements of the array must contain "some" entry. 

These array variables, (after filling) are then used in the xx_post_other
function to populate (for each encounter), a unique file.  The file naming 
convention will be to use the current time (to 100ths of a second).
By stripping out characters other than numbers, a unique 8 character 
filename can be generated.  As an option, the date and time can be used.  
This will create a unique 16 character filename (from time to 100ths of 
a second).  Optionally, append the characters ".mmx" (foxmeadowsXfer file) 
to the end of the filename as a location extension. 

Each numbered element of the arrays, for a specific encounter, 
will be used to populate a unique string and and each string will
be written to the billing data transfer file as a separate row.

The 'u_component_billing_foxmeadows' object has 10 functions (methods).
With the exception of xx_initialize (whose primary use is to provide this 
documentation), three functions (xx_post_encounter, xx_post_other, and
array_null) are the only methods on the user object which do any work. 
The remainder are simply stubs returning "1" to the calling object.  
The 6 non-functional methods are stubbed with a return value of 1 
because the ancestor object makes calls to them.  These functions remain 
because they are used by the ancestor with other Billing System 
interfaces.  
*/

return 1


end function

protected function integer xx_xref_procedure (string ps_cpt_code);/*
Function Name:	xx_xref_procedure for u_component_billing_foxmeadows
Date Begun:		
Programmer:		
Purpose:		Not Defined
Expects:		Not Defined
Returns"		Integer
Limits:			Not Defined
History			None
Note:				cprdb = EncounterPRO database

11/09/98:	Not currently used in this object

*/

RETURN 1

end function

protected function long xx_post_assessment (string ps_cpr_id, long pl_encounter_id, long pl_problem_id, integer pi_assessment_sequence);/*
Function Name:	xx_post_assessment for u_component_billing_foxmeadows
Purpose:			Not Currently used
Expects:			Not Defined
Returns"			Integer
Limits:			Not Defined
History			None
Note:	
*/

// declare local variables
integer li_sts

string ls_assessment_id
string ls_insurance_id
string ls_icd_9_code

// declare local alias for stored procedure
//CWW, BEGIN
u_ds_data luo_sp_get_assessment_icd9
integer li_spdw_count
// DECLARE lsp_get_assessment_icd9 PROCEDURE FOR dbo.sp_get_assessment_icd9  
//         @ps_cpr_id = :ps_cpr_id,   
//			@ps_assessment_id = :ls_assessment_id,
//			@ps_insurance_id = :ls_insurance_id OUT,
//			@ps_icd_9_code = :ls_icd_9_code OUT
// USING cprdb;
 //CWW, END

SELECT assessment_id
INTO :ls_assessment_id
FROM p_Encounter_Assessment
WHERE cpr_id = :ps_cpr_id
AND encounter_id = :pl_encounter_id
AND problem_id = :pl_problem_id
USING cprdb;
// if an sql error occurs return -1
if not cprdb.check() then 
	mylog.log(this, "xx_post_assessments()", "select error p_Encounter_Assessment (" + ps_cpr_id + ", " + string(pl_encounter_id) + ", " + string(pl_problem_id) + ")", 3)
	return -1
end if	
// if no records were found, return 0
if cprdb.sqlcode = 100 then 
	mylog.log(this, "xx_post_assessments()", "no records (" + ps_cpr_id + ", " + string(pl_encounter_id) + ", " + string(pl_problem_id) + ")", 3)
	return 0
end if

// Now get the codes for this assessment
//CWW, BEGIN
//EXECUTE lsp_get_assessment_icd9;
//if not cprdb.check() then 
//	mylog.log(this, "xx_post_assessments()", "EXECUTE lsp_get_assessment_icd9 (" + ps_cpr_id + ", " + string(pl_encounter_id) + ", " + string(pl_problem_id) + ")", 3)
//	return -1
//end if	
//integer i
//i = upperbound(is_icd_9_code)
//
//FETCH lsp_get_assessment_icd9 INTO :ls_insurance_id, :ls_icd_9_code;
//if not cprdb.check() then 
//	mylog.log(this, "xx_post_assessments()", "fetch lsp_get_assessment_icd9 (" + ps_cpr_id + ", " + string(pl_encounter_id) + ", " + string(pl_problem_id) + ")", 3)
//	return -1
//end if	
//
//if not isnull(ls_icd_9_code) then
//	i++
//	is_icd_9_code[i] = ls_icd_9_code
//	ii_assessment_seq[i] = pi_assessment_sequence
//end if	
//
//CLOSE lsp_get_assessment_icd9;
//
//mylog.log(this, "xx_post_assessments()", "The icd_9 retrieve done (" + ps_cpr_id + ", " + string(pl_encounter_id) + ", " + ls_icd_9_code + ")", 1)	

integer i
i = upperbound(is_icd_9_code)

luo_sp_get_assessment_icd9 = CREATE u_ds_data
luo_sp_get_assessment_icd9.set_dataobject("dw_sp_get_assessment_icd9", cprdb)
li_spdw_count = luo_sp_get_assessment_icd9.retrieve(ps_cpr_id, ls_assessment_id)
if li_spdw_count <= 0 then
	setnull(ls_insurance_id)
	setnull(ls_icd_9_code)
else
	ls_insurance_id = luo_sp_get_assessment_icd9.object.insurance_id[1]
	ls_icd_9_code = luo_sp_get_assessment_icd9.object.icd_9_code[1]
	if not isnull(ls_icd_9_code) then
		i++
		is_icd_9_code[i] = ls_icd_9_code
		ii_assessment_seq[i] = pi_assessment_sequence
		// once the icd code is included then set the flag as posted
		Update p_encounter_assessment
		set posted = 'Y'
		where cpr_id = :ps_cpr_id
		and encounter_id = :pl_encounter_id
		and problem_id = :pl_problem_id
		using cprdb;
	end if	
end if
destroy luo_sp_get_assessment_icd9
//CWW, END

return 1


end function

protected function integer xx_xref_assessment (string ps_icd9_code);/*
Function Name:	xx_xref_assessment for u_component_billing_foxmeadows
Date Begun:		
Programmer:		
Purpose:		Not Defined
Expects:		Not Defined
Returns"		Integer
Limits:			Not Defined
History			None
Note:

11/09/98:	Not currently used in this object
*/

RETURN 1


end function

protected function long xx_post_encounter (string ps_cpr_id, long pl_encounter_id);/*
Function Name:	xx_post_encounter for u_component_billing_foxmeadows
Access:			Protected
Date Begun:		
Programmer:		

Expects:			String 	ps_cpr_id
					Long		pl_encounter_id
Returns:			Integer
Limits:			None
History			New 
Note:			cprdb = EncounterPRO database

*/
//	Declare local variables
datetime 	ldt_encounter_date	  		
integer 		lic_problem_id				
integer	 	li_treatment_id				
string		ls_attending_doctor			
long 			ll_encounter_billing_id		
string 		ls_insurance_id				
string 		ls_indirect_flag				
string	 	ls_new_flag						
string		ls_office_id
string		ls_billing_id
real 			lr_units							
string		arrayempty[]
string      ls_primary_provider,ls_supervising_doctor,ls_billable_provider
is_cpt_assembly = arrayempty
ii_cpt_count = 0
is_icd_9_code = arrayempty
li_icd9_codes = 0
li_charge_count = 1
// ready to begin 
// Get the EncounterPRO Billing ID

DECLARE lsp_get_billable_provider PROCEDURE FOR sp_get_billable_provider
		@ps_attending_doctor = :ls_attending_doctor,
		@ps_supervising_doctor = :ls_supervising_doctor,
		@ps_primary_provider_id = :ls_primary_provider,
		@ps_billable_provider = :ls_billable_provider OUT Using Sqlca;
		
SELECT 	billing_id,
			primary_provider_id
INTO 		:ls_billing_id,
			:ls_primary_provider
FROM 		p_Patient
WHERE 	cpr_id = :ps_cpr_id
USING 	cprdb;
IF NOT cprdb.check() THEN RETURN -1
IF cprdb.sqlcode = 100 THEN RETURN -1

//Get some information about the encounter from p_Patient_Encounter

SELECT
		attending_doctor,
		office_id,
		encounter_billing_id,
		encounter_date,
		encounter_type,
		indirect_flag,
		new_flag,
		courtesy_code,
		billing_note,
		supervising_doctor
INTO
		:ls_attending_doctor,
		:ls_office_id,
		:ll_encounter_billing_id,
		:ldt_encounter_date,
		:is_encounter_type,
		:is_indirect_flag,
		:is_new_flag,
		:is_courtesy_code,
		:is_billing_note,
		:ls_supervising_doctor
FROM 	p_Patient_Encounter
WHERE ( cpr_id = :ps_cpr_id ) AND
 		( encounter_id = :pl_encounter_id )
USING cprdb;
IF NOT cprdb.check() THEN RETURN -1
// IF we don't get an Encounter record, THEN QUIT
IF cprdb.sqlcode = 100 THEN
	mylog.log(this, "xx_post_encounter()", "Unable to retrieve an Encounter Record..Aborting Billing (" + ps_cpr_id + ", " + string(pl_encounter_id) + ")", 4)
 	RETURN -1
END IF

// Get the billing code for this office
If isnull(ls_office_id) then 
	mylog.log(this, "xx_post_encounter()", "office id is null in patient_encounter (" + ps_cpr_id + ", " + string(pl_encounter_id) + ")", 3)
	return 0
end if

SELECT billing_id
INTO :ss_Facility
FROM c_Office
WHERE office_id = :ls_office_id
USING cprdb;
if not cprdb.check() then 
	mylog.log(this, "xx_post_encounter()", "get billing code not OK (" + ps_cpr_id + ", " + string(pl_encounter_id) + ")", 3)
	return -1
	end if	
if cprdb.sqlcode = 100 then return 0

// Get the billable Provider
EXECUTE lsp_get_billable_provider;
if not tf_check() then return -1
FETCH lsp_get_billable_provider INTO :ls_billable_provider;
if not tf_check() then return -1
CLOSE lsp_get_billable_provider;
if not tf_check() then return -1

IF isnull(ls_billable_provider) THEN 
	log.log(this, "xx_post_encounter()", "BILLING FAILED.Attending doctor ("+ls_attending_doctor+" ) for patient("+ps_cpr_id+"," + string(pl_encounter_id)+"  dont have valid billing code and he also dont have valid supervisor's billing code.", 4)
	RETURN -1
End if	
log.log(this,"xx_post_encounter()","Billable Provider ID & Code:"+ls_billable_provider,2)
is_doctor_id = ls_billable_provider
ss_charge_acct = ls_billing_id

IF isNull(ldt_encounter_date) THEN
	// If we don't have an Encounter date and time, then we can't pass the encounter
	// to the foxmeadows billing system
	mylog.log(this, "xx_post_encounter()", "Unable to determine the Encounter Date and Time..Aborting Billing (" + ps_cpr_id + ", " + string(pl_encounter_id) + ")", 4)
	RETURN -1
END IF
		
date ld_encounterdate
ld_encounterdate = Date(ldt_encounter_date)
is_encounterdate = String(ld_encounterdate, "yyyymmdd")
if isnull(is_billing_note) then is_billing_note = ""
if isnull(is_chief_complaint) then is_chief_complaint = ""
if isnull(is_courtesy_code) then is_courtesy_code = ""
is_encounter_id = string(pl_encounter_id)
RETURN 1



end function

on u_component_billing_foxmeadows.create
call super::create
end on

on u_component_billing_foxmeadows.destroy
call super::destroy
end on

