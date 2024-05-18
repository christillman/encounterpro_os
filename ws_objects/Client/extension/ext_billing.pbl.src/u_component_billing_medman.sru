$PBExportHeader$u_component_billing_medman.sru
forward
global type u_component_billing_medman from u_component_billing
end type
type str_medman_out from structure within u_component_billing_medman
end type
end forward

type str_medman_out from structure
	integer		row_num
	string		cpr_id
	long		encounter_id
	integer		encounter_charge_id
	long		encounter_number
	long		account_number
	datetime		encounter_date_time
	string		encounter_type
	string		chief_complaint
	string		indirect_flag
	long		attending_doctor
	string		new_flag
	string		courtesy_code
	string		billing_note
	string		icd10_code1
	string		icd10_code2
	string		icd10_code3
	string		icd10_code4
	string		cpt_code
	string		modifier
	string		other_modifiers
	long		units
	decimal {2}	charge
end type

shared variables

end variables

global type u_component_billing_medman from u_component_billing
end type
global u_component_billing_medman u_component_billing_medman

type variables
integer li_charge_count
integer li_icd10_codes

long sl_attending_doctor
string ss_billing_note


string is_icd10_code[]
integer ii_assessment_seq[], ii_cpt_count
string is_cpt_assembly[]
integer ii_cpt_units[]
string ss_charge_acct
string ss_charge_dep
string is_doctor_id
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
protected function integer xx_xref_assessment (string ps_icd10_code)
protected function long xx_post_encounter (string ps_cpr_id, long pl_encounter_id)
end prototypes

public function integer get_new_id (string ps_idtype, ref long pl_id);/*
Function Name:	get_new_id for u_component_billing_medman
Date Begun:		11/09/98
Programmer:		George Snead
Purpose:			Not Defined
Expects:			Not Defined
Returns"			Integer
Limits:			Not Defined
History			None
Note:				

11/09/98:	Not currently used in this object
*/

RETURN 1



end function

public function integer get_carriers (long pl_patientprofileid, ref long pl_currentcarrier, ref long pl_primarypicarrierid, ref long pl_primaryinsurancecarriersid, ref long pla_patientinsuranceid[], ref integer pi_insurance_count, ref long pl_currentpicarrierid, ref long pl_currentinsurancecarriersid, ref long pl_filingmethodmlc, ref integer pi_acceptassignment);/*
Function Name:	get_carriers for u_component_billing_medman
Date Begun:		11/09/98
Programmer:		George Snead
Purpose:			Not Defined
Expects:			Not Defined
Returns"			Integer
Limits:			Not Defined
History			None
Note:				

declare local variables
11/09/98:	Not currently used in this object
*/

RETURN 1


end function

protected function long xx_post_other (string ps_cpr_id, long pl_encounter_id);/*
Function Name:	xx_post_other for u_component_billing_medman
Date Begun:		11/09/98
Programmer:		George Snead
Purpose:			Create and write uniquely named "transfer data files" which pass 
					completed encounter information to the Medical Manager application 
					by way of the "my_component_manager.message_server.send_to_subscribers()"
					function.  
Expects:			ps_cpr_id			string
					pl_encounter_id	long
Returns"			Integer
Limits:			None
History			New 12/01/98

Notes:			cprdb = EncounterPRO database
					This will create a filename + the ".mmx" (MedManXfer)
					extension.  
*/
//1.	n/a	[ Record Type]	A3	G=Guarantor, P=Patient, R=RefDr, I=InsPlan, CHG, PMT
//2.		[ Action ]	A1	A=Add, M=Modify, D=Delete
//3.		(Reserved)			
//4.		(Reserved)			
//05.	1.2	Charge Acct #	A6	Charge Account #
//06.	1.3	Charge Dependent #	N2	Charge Dependent #
//07.	1.6	Charge Unique	N6	Unique # of Charge
//08.	1.7	Charge Amount	N8	Original Charge Amount
//09.	1.8	Charge Payments	N8	Payments Applied to charge
//10.	1.9	Charge Adjustments	N8	Adjustments Applied to charge
//11.	1.11	Procedure Code	A10	Charge procedure code
//12.	1.12	Modifiers	A6	up to 3 procedure modifiers
//13.	1.13	Primary Diag	A10	Primary Diagnosis Code
//14.	1.14	Secondary Diag	A10	Secondary Diagnosis Code
//15.	1.44	3rd diagnosis	A10	3rd diagnosis
//16.	1.45	4th diagnosis	A10	4th diagnosis
//17.	1.16	Charge Doctor	N3	charge doctor
//18.	1.17	Place of Service Code	A3	POS Code
//19.	1.18	Type of Service Code	A3	TOS Code
//20.	1.20	Charge Dept	N2	Charge department
//21.	1.21	Charge Voucher	A6	Charge Voucher
//22.	1.22	current insurance plan	N5	(0=no insurance)
//23.	1.49	current insurance policyholder	N2	(0=guarantor)
//24.	1.23	other insurance plan	N5	(0=no insurance)
//25.	1.50	other insurance policyholder	N2	(0=guarantor)
//26.	1.24	units	N5	units
//27.	1.26	from service date	N8	from service date
//28.	1.30	thru service date	N8	thru service date
//29.	1.27	date posted	N8	date posted
//30.	1.28	date patient billed	N8	date patient billed
//31.	1.29	date current ins billed	N8	date current insurance billed
//32.	1.32	assignment flag	A1	assigned: Y/N, blank or (E)stimate
//33.	1.38	location 	A4	location
//34.	1.39	claim number	A8	"unbilled" if unbilled
//35.	1.43	posting location	N2	posting location
//36.	31.4	Charge Comment	A35	Charge comment
//37.	1.19	Charge Status	N2	Charge Status
//38..		(Reserved)	A1	
//
//

//	declare local variables

boolean 	lb_loop						// Loop "continue or stop" flag
integer	li_array_null				//	Status variable to report function array_null result
integer	li_filehandle				// Transfer file filehandle
integer	li_write_sts				// Status variable to report FileWrite result
integer 	li_file_sts					//	Status variable to report FileClose result
integer	li_sts						// Status variable for RegistryGet() function
integer 	ti_loop_count				// Current element counter for the data arrays
string	ls_current_filename		// Current filename (Time to 8 places...100th of a second)
string 	ls_filepath					//	Filepath for the transfer files
string 	ls_medman_row				//	Variable to store each row prior to writing &
											//	into the transfer file
string	ls_message_type			// Variable for the message_type returned from the &
											// get_attribute() function
string	ls_day_aray[]
string	ls_unique
string   ls_encounter,ls_filename
long     ll_next_counter
ls_day_aray = {'1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V'} 
integer  li_day_ndx, li_record_count 
long ll_len
string ls_drive,ls_directory,ls_inifilename,ls_iniextension
u_component_messageserver luo_messageserver

if ii_cpt_count > 0 then
	if isnull(is_cpt_assembly[ii_cpt_count]) then
		ii_cpt_count --
	end if
end if	

if ii_cpt_count  = 0 then 
	mylog.log(this, "u_component_billing_medman.xx_post_other:0092", "There was no cpt charged for (" + ps_cpr_id + ", " + string(pl_encounter_id) + ")", 2)
	return 1
end if

ti_loop_count = 1
lb_loop = TRUE

SELECT 	encounter
INTO		:ls_encounter
FROM		x_medman_Arrived
	WHERE		status = 'ARRIVED' AND
				cpr_id = :ps_cpr_id AND
				encounter_id = :pl_encounter_id
	USING 	cprdb;
if not cprdb.check() then return -1

if isnull(ls_encounter) then ls_encounter = '""'

//	A fully qualified path is now available in ls_filepath
f_parse_filepath(gnv_app.ini_file,ls_drive,ls_directory,ls_inifilename,ls_iniextension)

ls_filepath = ls_drive+ls_directory
if right(ls_filepath, 1) <> "\" then ls_filepath += "\"
ls_filepath += "Messages"

if not mylog.of_directoryexists(ls_filepath) then
	mylog.log(this, "u_component_billing_medman.xx_post_other:0118", "Error getting temp path "+ls_filepath, 4)
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
	mylog.log(this, "u_component_billing_medman.xx_post_other:0136", "The FileOpen function failed...Aborted Billing (" + ps_cpr_id + ", " + string(pl_encounter_id) + ")", 4)
	RETURN -1		
END IF

For  ti_loop_count  = 1 to  ii_cpt_count 
		ll_len = Len(is_cpt_assembly[ti_loop_count] )
		IF ll_len = 0  or is_cpt_assembly[ti_loop_count]  = "" then CONTINUE
		//unique id combination of encounter and a serial number 
		if ti_loop_count < 10 then 
			ls_unique = string(pl_encounter_id) + '0' + string(ti_loop_count)
		else
			ls_unique = string(pl_encounter_id) + string(ti_loop_count)
		end if	
		// populate one element of each array for each row as we loop through 
		ls_medman_row = '"CHG","A","",""'
		ls_medman_row += ","+"~"" + ss_charge_acct + "~""  			//5
		ls_medman_row += ","+ ss_charge_dep 							   //6
		ls_medman_row += ","+ ls_unique                             //7
		ls_medman_row += ','     	                              	//8
		ls_medman_row += ','        	                           	//9
		ls_medman_row += ','     	                              	//10
		ls_medman_row += ',' + is_cpt_assembly[ti_loop_count] 		//11-16
		
		ls_medman_row +=  is_doctor_id + ','								//17
		ls_medman_row += '"",'                                   	//18
		ls_medman_row += '"",'                                   	//19
		ls_medman_row += ','		                                   	//20
		ls_medman_row += ls_encounter + ','                       	//21
		ls_medman_row += ','   		                                	//22
		ls_medman_row += ','       	                            	//23
		ls_medman_row += ',' 	                                  	//24
		ls_medman_row += ','  	                                 	//25
		ls_medman_row += string(ii_cpt_units[ti_loop_count]) + ',' 	//26
		ls_medman_row += is_encounterdate + ","							//27
		ls_medman_row += ","														//28   
		ls_medman_row += ','   		                                	//29
		ls_medman_row += ','  	                                 	//30
		ls_medman_row += ','   		                                	//31
		ls_medman_row += '"",'                                   	//32
		ls_medman_row += "~"" + ss_Facility + "~"" + ","           	//33
		ls_medman_row += '"",'                                   	//34
		ls_medman_row += ','      		                            	//35
		ls_medman_row += '"",'                                   	//36
		ls_medman_row += ','  	                                 	//37
		ls_medman_row += '"",'                                   	//38
		// Write the row to the previously named and opened file		
		li_write_sts = FileWrite(li_filehandle,ls_medman_row)	
				IF li_write_sts < 0 THEN 
			mylog.log(this, "u_component_billing_medman.xx_post_other:0184", "The FileWrite function failed...Aborted Billing (" + ps_cpr_id + ", " + string(pl_encounter_id) + ")", 4)
			RETURN -1
		END IF
		li_record_count ++
Next

// Close the file
li_file_sts = FileClose(li_filehandle)

IF li_file_sts < 0 THEN
	mylog.log(this, "u_component_billing_medman.xx_post_other:0194", "The FileClose function failed...Aborted Billing (" + ps_cpr_id + ", " + string(pl_encounter_id) + ")", 4)
	RETURN -1
END IF

if li_record_count = 0 then return 1

// Pass the filename to the message server
ls_message_type = get_attribute("MESSAGE_TYPE")
if isnull(ls_message_type) then
	ls_message_type = "MEDMAN_CHECKOUT"
end if	
// If the message was created successfully, then ship it.
luo_messageserver = my_component_manager.get_component("JMJMESSAGESERVER")
if isnull(luo_messageserver) then
	mylog.log(this, "u_component_billing_medman.xx_post_other:0208", "Unable to get messageserver component", 4)
	return -1
end if

li_sts = luo_messageserver.send_to_subscribers(ls_message_type, ls_current_filename,ps_cpr_id,pl_encounter_id)

my_component_manager.destroy_component(luo_messageserver)

if li_sts <= 0 then
	mylog.log(this, "u_component_billing_medman.xx_post_other:0217", "Error sending message", 4)
	return -1
end if

IF li_sts < 0 THEN
	mylog.log(this, "u_component_billing_medman.xx_post_other:0222", "The Message_Server.send_to_subscribers function failed...Aborted Billing (" + ps_cpr_id + ", " + string(pl_encounter_id) + ")", 4)
	RETURN -1
END IF

// Return 1, now going back to post_encounter of u_component_billing
yield()
RETURN 1

end function

protected function long xx_post_treatment (string ps_cpr_id, long pl_encounter_id, long pl_encounter_charge_id);/*
Function Name:	xx_post_treatment for u_component_billing_medman
Date Begun:		11/09/98
Programmer:		George Snead
Purpose:			Not Defined
Expects:			Not Defined
Returns"			Integer
Limits:			Not Defined
History:			None
Note:				mydb  = billing database
*/

// declare local variables
decimal ldc_encounter_charge
decimal ldc_procedure_charge
decimal{2} 	ld_charge

long ll_treatment_id
long ll_treatment_billing_id
long ll_assessment_billing_id
long ll_problem_id
long ll_PatientID
long ll_PatientVisitId
long ll_ProceduresID
long i

string ls_procedure_type
string ls_procedure_id
string ls_charge_bill_flag
string ls_assessment_bill_flag
string ls_assessment_charge_bill_flag
string ls_treatment_description
string ls_cpt_code
string ls_facilitycode
string ls_TxnModifier
string ls_code
string ls_insurance_id
string ls_modifier
string ls_other_modifiers
string lsc_assessment_id
string ls_temp_icd10

integer li_write_sts
integer li_assessment_sequence
integer li_diagnum
integer li_DiagnosisPointer
integer li_sts
integer li_encounter_charge_id		
integer li_enc_assmnt_chg_cnt		
integer li_enc_assmnt_seq_limit	
integer li_icd10_ctr 
integer lic_problem_id
integer li_temp_seq,li_charge_units
integer j, k, l, m, n

boolean lb_loop
boolean lb_exists
boolean lb_icd10_hit[]
boolean lb_any_icd10

real lr_procedure_units

u_ds_data luo_sp_get_procedure_cpt
integer li_spdw_count

// declare local alias for get treatment assessments stored procedure
DECLARE lsp_get_treatment_assessments PROCEDURE FOR dbo.sp_get_treatment_assessments  
   @ps_cpr_id = :ps_cpr_id,   
   @pl_encounter_id = :pl_encounter_id,   
   @pl_encounter_charge_id = :pl_encounter_charge_id
USING cprdb;


EXECUTE lsp_get_treatment_assessments;
if not cprdb.check() then 
	mylog.log(this, "u_component_billing_medman.xx_post_treatment:0076", "EXECUTE lsp_get_treatment_assessments (" + ps_cpr_id + ", " + string(pl_encounter_id) + ")", 3)	
	return -1
end if	

lb_any_icd10 = false
lb_loop = true
li_diagnum = 0
i = upperbound(is_icd10_code)
j = integer(i)
for k = 1 to j
	lb_icd10_hit[k] = false
next	

//bubbleup sort for the assesment so that the icd10 codes are in sequence
if j > 1 then
	n = j - 1
	for m = 1 to n
		for k = j to 2 step -1
			l = k - 1
			if ii_assessment_seq[k] < ii_assessment_seq[l] then
				li_temp_seq = ii_assessment_seq[l]
				ls_temp_icd10 = is_icd10_code[l]
				ii_assessment_seq[l] = ii_assessment_seq[k]
				is_icd10_code[l]  = is_icd10_code[k]
				ii_assessment_seq[k] = li_temp_seq
				is_icd10_code[k] = ls_temp_icd10
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
		mylog.log(this, "u_component_billing_medman.xx_post_treatment:0116", "The Fetch not ok for lsp_get_treatment_assessments (" + ps_cpr_id + ", " + string(pl_encounter_id) +  ")", 3)	
		return -1
	end if	

	if cprdb.sqlcode = 0 then
		if ls_assessment_bill_flag = "N" then continue
		if ls_assessment_charge_bill_flag = "N" then continue
		if isnull(li_assessment_sequence) then continue
		for k = 1 to j
			if ii_assessment_seq[k] = li_assessment_sequence then
				lb_icd10_hit[k] = true
				lb_any_icd10 = true
			end if		
		next	
	else
		lb_loop = false
	end if
	
LOOP WHILE lb_loop

CLOSE lsp_get_treatment_assessments;
//if no icd10 code was found for the assessment then assume that there will be no charge for the treatment (northampton rule)
if not lb_any_icd10 then return 1

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
	mylog.log(this, "u_component_billing_medman.xx_post_treatment:0161", "treatment charge access (" + ps_cpr_id + ", " + string(pl_encounter_id) + ")", 3)	
	return -1
end if	
if cprdb.sqlcode = 100 then
	mylog.log(this, "u_component_billing_medman.xx_post_treatment:0165", "treatment charge not found (" + ps_cpr_id + ", " + string(pl_encounter_id) + ", " + string(pl_encounter_charge_id) + ")", 3)	
	return 0
end if	

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

//if there is no cpt code then the procedure for the diagnosis is not billed...
//so don'tcreate an assembly.
if isnull(ls_cpt_code) then return 1

// Determine the codes for the billing system
if isnull(ls_modifier) then ls_modifier = ""
if isnull(ls_other_modifiers) then ls_other_modifiers = ""
ls_TxnModifier = ls_modifier + ls_other_modifiers
IF ISNULL(ls_TxnModifier) then ls_TxnModifier = ""
if len(ls_txnModifier) > 6 then
	ls_txnModifier = Left(ls_TxnModifier,6)
end if	

if isnull(ldc_encounter_charge) and not isnull(ldc_procedure_charge) then
	ldc_encounter_charge = ldc_procedure_charge
end if

if isnull(lr_procedure_units) or lr_procedure_units <= 0 then lr_procedure_units = 1

/////////////////////////////////////////////
string ls_cpt_assembly
integer li_count
li_count = 0
setnull(ls_cpt_assembly)
ii_cpt_count++
ls_cpt_assembly = '"' + ls_cpt_code + '"' + ',' + '"' + ls_TxnModifier + '"' + ','
for k = 1 to j
	if lb_icd10_hit[k] = true then
		if isnull(is_icd10_code[k]) then
			ls_cpt_assembly += '"",'
		else	
			ls_cpt_assembly += '"' + is_icd10_code[k] + '"' + ','
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

is_cpt_assembly[ii_cpt_count] = ls_cpt_assembly
// if p_encounter_charge units is filled in use it otherwise get the unit from procedure table
if isnull(li_charge_units) or li_charge_units <= 0 then 
	ii_cpt_units[ii_cpt_count] = integer(lr_procedure_units)
else
	ii_cpt_units[ii_cpt_count] = li_charge_units
end if
// once the cpt code is included then set the flag as posted
Update p_encounter_charge
	set posted = 'Y'
where cpr_id = :ps_cpr_id
	and encounter_id = :pl_encounter_id
	and encounter_charge_id = :pl_encounter_charge_id
using cprdb;

RETURN 1


end function

public function integer xx_initialize ();//	Function Name:	initialize for u_component_billing_medman
//	Date Begun:		11/09/98
//	Programmer:		George Snead
//	Purpose:			Container for user object documentation
//	Expects:			Nothing
//	Returns:			Integer
//	Limits:			None
//	History			Clone of u_component_billing_paradigm3
//	Notes:		

/* 
Whenever the MedMan Billing user object is initialized, the 
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
string ss_icd10_code1[].............c_Assessment_Definition
string ss_icd10_code2[].............c_Assessment_Definition
string ss_icd10_code3[].............c_Assessment_Definition
string ss_icd10_code4[].............c_Assessment_Definition
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
a second).  Optionally, append the characters ".mmx" (MedManXfer file) 
to the end of the filename as a location extension. 

Each numbered element of the arrays, for a specific encounter, 
will be used to populate a unique string and and each string will
be written to the billing data transfer file as a separate row.

The 'u_component_billing_medman' object has 10 functions (methods).
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
Function Name:	xx_xref_procedure for u_component_billing_medman
Date Begun:		11/09/98
Programmer:		George Snead
Purpose:			Not Defined
Expects:			Not Defined
Returns"			Integer
Limits:			Not Defined
History			None
Note:				cprdb = EncounterPRO database

11/09/98:	Not currently used in this object

*/

RETURN 1

end function

protected function long xx_post_assessment (string ps_cpr_id, long pl_encounter_id, long pl_problem_id, integer pi_assessment_sequence);// declare local variables
integer li_sts

string ls_assessment_id
string ls_insurance_id
string ls_icd10_code

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
if not cprdb.check() then 
	mylog.log(this, "u_component_billing_medman.xx_post_assessment:0020", "select error p_Encounter_Assessment (" + ps_cpr_id + ", " + string(pl_encounter_id) + ", " + string(pl_problem_id) + ")", 3)
	return -1
end if	
// if no records were found, return 0
if cprdb.sqlcode = 100 then 
	mylog.log(this, "u_component_billing_medman.xx_post_assessment:0025", "no records (" + ps_cpr_id + ", " + string(pl_encounter_id) + ", " + string(pl_problem_id) + ")", 3)
	return 0
end if


integer i
i = upperbound(is_icd10_code)

luo_sp_get_assessment_icd10 = CREATE u_ds_data
luo_sp_get_assessment_icd10.set_dataobject("dw_sp_get_assessment_icd10", cprdb)
li_spdw_count = luo_sp_get_assessment_icd10.retrieve(ps_cpr_id, ls_assessment_id)
if li_spdw_count <= 0 then
	setnull(ls_insurance_id)
	setnull(ls_icd10_code)
else
	ls_insurance_id = luo_sp_get_assessment_icd10.object.insurance_id[1]
	ls_icd10_code = luo_sp_get_assessment_icd10.object.icd10_code[1]
	if not isnull(ls_icd10_code) then
		i++
		is_icd10_code[i] = ls_icd10_code
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
destroy luo_sp_get_assessment_icd10

return 1

end function

protected function integer xx_xref_assessment (string ps_icd10_code);/*
Function Name:	xx_xref_assessment for u_component_billing_medman
Date Begun:		11/09/98
Programmer:		George Snead
Purpose:			Not Defined
Expects:			Not Defined
Returns"			Integer
Limits:			Not Defined
History			None
Note:

11/09/98:	Not currently used in this object
*/

RETURN 1


end function

protected function long xx_post_encounter (string ps_cpr_id, long pl_encounter_id);/*
Function Name:	xx_post_encounter for u_component_billing_medman
Access:			Proctected
Date Begun:		11/09/98
Programmer:		George E. Snead
Purpose:			Primary processing (of 4) in the Medical Manager "Billing" API.
					Processing is done in xx_post_encounter which collects the transfer data,
					then populates the transfer data arrays.  These arrays are used later in 
					xx_post_open.  Each unique encounter, passed to this function by post_encounter
					for u_component_billing, identified by the combination of 
					fields "cpr_id and encounter_id" will cause the generation of
					a uniquely named file which will contain one or more rows corresponding
					to each row in p_Encounter_Charge.  Xx_post_open, reading the data from the 
					transfer arrays, creates a transfer file containing 1 line for each 
					row in p_Encounter_charge..
Expects:			String 	ps_cpr_id
					Long		pl_encounter_id
Returns:			Integer
Limits:			None
History			New 12/01/98
Note:				cprdb = EncounterPRO database

*/



//	Declare local variables
datetime 	ldt_encounter_date	  		
integer 		lic_problem_id				
integer	 	li_treatment_id				
string		ls_attending_doctor,ls_supervising_doctor,ls_primary_provider,ls_billable_provider			
long 			ll_encounter_billing_id		
string 		ls_billing_id					
string 		ls_billing_note				
string 		ls_chief_complaint			
string 		ls_courtesy_code				
string 		ls_cpt_code						
string 		ls_encounter_type				
string 		ls_insurance_id				
string 		ls_indirect_flag				
string 		ls_modifier						
string	 	ls_new_flag						
string		ls_office_id
string 		ls_supervisor
real 			lr_units							
string arrayempty[]

DECLARE lsp_get_billable_provider PROCEDURE FOR sp_get_billable_provider
		@ps_attending_doctor = :ls_attending_doctor,
		@ps_supervising_doctor = :ls_supervising_doctor,
		@ps_primary_provider_id = :ls_primary_provider,
		@ps_billable_provider = :ls_billable_provider OUT Using Sqlca;

is_cpt_assembly = arrayempty
ii_cpt_count = 0
is_icd10_code = arrayempty
li_icd10_codes = 0
li_charge_count = 1
// ready to begin 
// Get the EncounterPRO Billing ID
	
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
		:ls_encounter_type,
		:ls_indirect_flag,
		:ls_new_flag,
		:ls_courtesy_code,
		:ls_billing_note,
		:ls_supervising_doctor
FROM 	p_Patient_Encounter
WHERE ( cpr_id = :ps_cpr_id ) AND
 		( encounter_id = :pl_encounter_id )
USING cprdb;
IF NOT cprdb.check() THEN RETURN -1
// IF we don't get an Encounter record, THEN QUIT
IF cprdb.sqlcode = 100 THEN
	mylog.log(this, "u_component_billing_medman.xx_post_encounter:0103", "Unable to retrieve an Appointment Record..Aborting Billing (" + ps_cpr_id + ", " + string(pl_encounter_id) + ")", 4)
 	RETURN -1
END IF

// Get the billing code for this office
If isnull(ls_office_id) then 
	mylog.log(this, "u_component_billing_medman.xx_post_encounter:0109", "office id is null in patient_appointment (" + ps_cpr_id + ", " + string(pl_encounter_id) + ")", 3)
	return 0
end if

SELECT billing_id
INTO :ss_Facility
FROM c_Office
WHERE office_id = :ls_office_id
USING cprdb;
if not cprdb.check() then 
	mylog.log(this, "u_component_billing_medman.xx_post_encounter:0119", "get billing code not OK (" + ps_cpr_id + ", " + string(pl_encounter_id) + ")", 3)
	return -1
	end if	
if cprdb.sqlcode = 100 then return 0
/*
//	Use ls_attending_doctor to get c_Provider.billing_id
//	From c_Provider_Id into doctor id 
SELECT 	billing_id,
			supervisor_user_id
INTO 		:is_doctor_id,
			:ls_supervisor
FROM 		c_User
WHERE 	user_id = :ls_attending_doctor
USING 	cprdb;
IF NOT cprdb.check() THEN RETURN -1
IF isnull(is_doctor_id) THEN RETURN -3
IF cprdb.sqlcode = 100 THEN 
	mylog.log(this, "u_component_billing_medman.xx_post_encounter:0136", "Unable to retrieve an Attending Doctor ID..Aborting Billing (" + ps_cpr_id + ", " + string(pl_encounter_id) + ")", 4)
 		RETURN -1
END IF

//when the user class is a nurse get the supervisor
if not (isnull(ls_supervisor) or ls_supervisor = '' or is_doctor_id = ls_supervisor) then
	SELECT c_User.billing_id
	INTO :is_doctor_id
	FROM  c_User,c_User_Role
	WHERE c_User.user_id = :ls_supervisor
		AND c_User.user_id = c_User_Role.user_id
		AND c_User_Role.role_id = '!NURSE'
	USING cprdb;
	if not cprdb.check() then 
		mylog.log(this, "u_component_billing_medman.xx_post_encounter:0150", "Unable to retrieve a supervising Doctor ID..Aborting Billing (" + ps_cpr_id + ", " + string(pl_encounter_id) + ")", 4)
 		RETURN -1
	end if	
end if
*/
// Get the billable Provider
EXECUTE lsp_get_billable_provider;
if not tf_check() then return -1
FETCH lsp_get_billable_provider INTO :ls_billable_provider;
if not tf_check() then return -1
CLOSE lsp_get_billable_provider;
if not tf_check() then return -1

IF isnull(ls_billable_provider) or ls_billable_provider = "" THEN 
	log.log(this, "u_component_billing_medman.xx_post_encounter:0164", "BILLING FAILED.Attending doctor ("+ls_attending_doctor+" ) for patient("+ps_cpr_id+"," + string(pl_encounter_id)+"  dont have valid billing code and he also dont have valid supervisor's billing code.", 4)
	RETURN -1
End if	
log.log(this,"u_component_billing_medman.xx_post_encounter:0167","Billable Provider ID & Code:"+ls_billable_provider,2)
is_doctor_id = ls_billable_provider

li_charge_count = 1

f_split_string(ls_billing_id, ".", ss_charge_acct, ss_charge_dep)

IF isNull(ldt_encounter_date) THEN
	// If we don't have an Encounter date and time, then we can't pass the encounter
	// to the Medical Manager billing system
	mylog.log(this, "u_component_billing_medman.xx_post_encounter:0177", "Unable to determine the Appointment Date and Time..Aborting Billing (" + ps_cpr_id + ", " + string(pl_encounter_id) + ")", 4)
	RETURN -1
END IF
		
date ld_encounterdate
ld_encounterdate = Date(ldt_encounter_date)
is_encounterdate = String(ld_encounterdate, "yyyymmdd")
ss_billing_note = ls_billing_note
if isnull(ls_chief_complaint) then ls_chief_complaint = ""

RETURN 1



end function

on u_component_billing_medman.create
call super::create
end on

on u_component_billing_medman.destroy
call super::destroy
end on

