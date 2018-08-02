$PBExportHeader$u_component_message_handler_foxy.sru
forward
global type u_component_message_handler_foxy from u_component_message_handler
end type
end forward

global type u_component_message_handler_foxy from u_component_message_handler
end type
global u_component_message_handler_foxy u_component_message_handler_foxy

type variables
string is_stg, is_array[]
string is_default_facility
string is_interface
boolean ib_doublequote


end variables

forward prototypes
protected function integer foxmeadows_diagnosis ()
protected function integer foxmeadows_notes ()
protected function integer foxmeadows_procedure ()
protected function integer parse_csv (integer pi_max_fields)
protected function integer xx_initialize ()
protected function integer foxmeadows_insurance ()
protected function integer foxmeadows_patient ()
protected function integer foxmeadows_arrived ()
protected function integer xx_handle_message ()
public function integer referring_provider ()
end prototypes

protected function integer foxmeadows_diagnosis ();  
int li_sts
long ll_array_count
//1	05.	3.2	Diagnosis Code	A10	Diagnosis Code
//2	06.	3.3	Description	A45	Description


//	Call the parsing function to put the comma separated values into ls_array[]
li_sts = parse_csv(255)
IF li_sts < 0 THEN
		mylog.log(this, "u_component_message_handler_foxy.foxmeadows_diagnosis.0011", "The parse_csv() function failed Aborting Encounter Creation for Message ID (" + string(message_id) + ")", 4)
		RETURN -1
END IF
ll_array_count = UpperBound(is_array)
if (isnull(ll_array_count) or ll_array_count = -1) then 
		mylog.log(this, "u_component_message_handler_foxy.foxmeadows_diagnosis.0016", "The parse_csv() function failed Message ID (" + string(message_id) + ")", 4)
		RETURN -1
else 
	li_sts = ll_array_count
END IF	
string ls_icd10
boolean lb_ok
integer li_count
ls_icd10 = is_array[1]
if is_array[1] = "" then return 1
if is_array[2] = "" then return 1

SELECT count(c_Assessment_Definition.icd10_code )  
    INTO :li_count 
    FROM c_Assessment_Definition  
   WHERE c_Assessment_Definition.icd10_code = :ls_icd10 using cprdb ;
	
if not cprdb.check() then return -1	

If li_count > 1 then return 1
if li_count = 1 then
	  UPDATE c_Assessment_Definition  
     SET description = :is_array[2]
   WHERE c_Assessment_Definition.icd10_code = :ls_icd10  using cprdb ;
	if not cprdb.check() then 
		return -1	
	else
		return 1
	end if
end if

SELECT count(c_Assessment_Definition.description )  
    INTO :li_count 
    FROM c_Assessment_Definition  
   WHERE c_Assessment_Definition.description = :is_array[2] using cprdb ;
	
if not cprdb.check() then return -1	

If li_count > 1 then return 1
if li_count = 1 then
	  UPDATE c_Assessment_Definition  
     SET icd10_code = :ls_icd10 
   WHERE c_Assessment_Definition.description = :is_array[2] using cprdb ;
	if not cprdb.check() then 
		return -1	
	else
		return 1
	end if
end if

string ls_assessment_id, ls_check, ls_fix
ls_assessment_id = Upper(is_array[2])
int li_len, i
li_len = Len(is_array[2])
for i = 1 to li_len
	ls_check = Mid(ls_assessment_id,i,1)
	If not ls_check = " " then
		ls_fix = ls_fix + ls_check
	end if	
Next


  INSERT INTO c_Assessment_Definition  
         ( assessment_id,   
           assessment_type,   
           assessment_category_id,   
           description,   
           common_flag,   
           auto_close,   
           icd10_code,   
           billing_code,   
           billing_id,   
           status )  
  VALUES ( :ls_fix,   
           null,   
           null,   
           :is_array[2],   
           null,
			  null,
           :ls_icd10,   
           null,   
           null,   
           null )  ;


return 1
end function

protected function integer foxmeadows_notes ();
//1	05.	2.2	notes account #	A6	notes account #
//2	06.	7.2	notes dep #	N2	notes dep #
//3	07.	95.5	notes system	A4	notes system
//4	08.	95.6	notes type	A4	notes type
//5	09.		notes sequence #	A8	may be blank - use record order
//6	10.		notes text	A80	notes text


return 1
end function

protected function integer foxmeadows_procedure ();int li_sts
long ll_array_count

//1	05.	5.23	Procedure Code	A10	Procedure Code
//2	06.	5.24	Description	A35	Description
//3	07.	5.33	Group	N2	Group (1-99)
//4	08.	5.34	Type Of Service	A3	Type Of Service
//5	09.	5.2	Standard Fee	N7	Standard Fee
//6	10.	5.3	Medicare Profile	N7	Medicare Profile
//7	11.		(Reserved)	A1	


//	Call the parsing function to put the comma separated values into ls_array[]
li_sts = parse_csv(255)
IF li_sts < 0 THEN
		mylog.log(this, "u_component_message_handler_foxy.foxmeadows_procedure.0016", "The parse_csv() function failed Aborting Encounter Creation for Message ID (" + string(message_id) + ")", 4)
		RETURN -1
END IF
ll_array_count = UpperBound(is_array)
if (isnull(ll_array_count) or ll_array_count = -1) then 
		mylog.log(this, "u_component_message_handler_foxy.foxmeadows_procedure.0021", "The parse_csv() function failed Message ID (" + string(message_id) + ")", 4)
		RETURN -1
else 
	li_sts = ll_array_count
END IF	
string ls_cpt
boolean lb_ok
integer li_count
ls_cpt = is_array[1]
if is_array[1] = "" then return 1
if is_array[2] = "" then return 1

SELECT count(c_Procedure.cpt_code )  
    INTO :li_count 
    FROM c_Procedure  
   WHERE c_Procedure.cpt_code = :ls_cpt using cprdb ;
	
if not cprdb.check() then return -1	

if li_count > 1 then return 1
if li_count = 1 then
	  UPDATE c_Procedure  
     SET description = :is_array[2],
	  		procedure_type = :is_array[4]
   WHERE c_Procedure.cpt_code = :ls_cpt  using cprdb ;
	if not cprdb.check() then 
		return -1	
	else
		return 1
	end if
end if

SELECT count(c_Procedure.description )  
    INTO :li_count 
    FROM c_Procedure 
   WHERE c_Procedure.description = :is_array[2] using cprdb ;
	
if not cprdb.check() then return -1	

if li_count > 1 then return 1
if li_count = 1 then
	  UPDATE c_Procedure  
     SET cpt_code = :ls_cpt
   WHERE c_Procedure.description = :is_array[2] using cprdb ;
	if not cprdb.check() then 
		return -1	
	else
		return 1
	end if
end if


  INSERT INTO c_Procedure  
         ( procedure_id,   
           procedure_type,   
           procedure_category_id,   
           description,   
           long_description,   
           service,   
           cpt_code,   
           modifier,   
           other_modifiers,   
           units,   
           charge,   
           billing_code,   
           billing_id,   
           status,   
           vaccine_id,   
           default_location,   
           default_bill_flag )  
  VALUES ( :ls_cpt,   
           :is_array[4],   
           null,   
           :is_array[2],   
           null,   
           null,   
           :ls_cpt,   
           null,   
           null,   
           null,   
           null,   
           null,   
           null,   
           null,   
           null,   
           null,   
           null )  ;


return 1
end function

protected function integer parse_csv (integer pi_max_fields);/*
Function Name:		parse_csv
Date Begun:			
Programmer:			
Purpose:				To parse individual values from a string containing
						Quoted "Comma Separated Values"
Expects:				arrived_string		String			By Value				
Modifies:			arrived_array[]	String_array	By Reference
Returns:				Integer
Access:				Public
History:				None
Notes:
This function is expecting to be passed a string in the "arrived_string" variable. 
This string may begin and end with a "DOUBLE QUOTE".  Each of the individual data 
segments within the string may begin and end with a "DOUBLE QUOTE".  Each of these 
individual data segments must be separated by a "COMMA".  

Numeric data does not have quotes around 


The resulting data is placed into a local string array variable "is_array []".
After processing, and validating that some data is contained in the array, the value 
of is_array [] is passed back to arrived_array[] for use by the calling processing.
*/

// Declare Local Variables

boolean lb_empty_flag
boolean lb_loop
boolean lb_quote_true
integer li_pos
integer li_comma
integer li_quote_comma
integer li_quote
integer li_start
integer li_end
integer li_length
integer li_ctr
integer li_str_len
integer li_value_max_len
integer li_max_fields
integer li_array_upper	
integer li_test_ctr
integer li_offset_len
string ls_value, ls_numvalue
string ls_quotecomma
string ls_quote
integer i

li_pos = 0
li_comma = 0
li_quote = 0
li_start = 0
li_end = 0
li_length = 0
li_str_len = 0 
li_value_max_len = 255
li_max_fields = pi_max_fields
li_array_upper = 1
li_test_ctr = 1
ls_value = ''

for i = 1 to upperbound(is_array)
	is_array[i] = ""
next
lb_loop = FALSE
lb_empty_flag = TRUE
if ib_doublequote then
	li_pos = pos(is_stg,'~"',1)
	ls_quotecomma = '~",'
	ls_quote = '~"'
else	
	li_pos = pos(is_stg,"~'",1)		// Validate the 1st character is a quote
	ls_quotecomma = "~',"
	ls_quote = "~'"
end if

IF li_pos = 1 THEN 
	li_start = li_pos + 1		// If so, it;s OK to start
	lb_loop = TRUE					// OK to loop
	li_ctr = 1
ELSE
	mylog.log(this, "u_component_message_handler_foxy.parse_csv.0083", "The input string does not start with a quote, string PARSING FAILED for (" + is_stg + ", " + + ")",4)
	RETURN -1
END IF	

li_str_len = len(is_stg)
char lc_last_char
lc_last_char = Right(is_Stg,1)
mylog.log(this, "u_component_message_handler_foxy.parse_csv.0083", "Message received (" + is_stg + ")",1)

//	Start the main data parsing loop
DO WHILE lb_loop 
	li_comma = pos(is_stg,"~,",li_pos)				// Be sure this is a comma
	li_quote_comma = pos(is_stg,ls_quotecomma,li_pos)
	if li_quote_comma < li_comma then 
		li_comma = li_quote_comma
		lb_quote_true = true
	else
		lb_quote_true = false
	end if	
	// The first section of this IF statement runs until the last element is found	
	// If a positive number is returned, then continue
	IF li_comma > 0 THEN									// We're still in a valid string
		li_end = li_comma 								//	Set the end same as start of the quote,comma,quote test location
		li_length = li_end - li_start					//	Set the length of the string to get the desired characters
		IF li_length > li_value_max_len THEN 
			mylog.log(this, "u_component_message_handler_foxy.parse_csv.0083", "A field length exceeds maximum number of characters, string PARSING FAILED for (" + is_stg + ", " + string(li_value_max_len) + ")",4)
			RETURN -1
		END IF
		if li_length = 0 then
			ls_value = ""
		else	
		ls_numvalue = Mid(is_stg,li_start,li_length) //check for a numeric value without quotes
		IF not IsNumber(ls_numvalue) then
			li_quote = pos(is_stg,ls_quote,li_start)  // check for a beginning quote in the value
			if li_quote = li_start then 
				li_start ++
				if lb_quote_true = false then 	//Adjust for special situation where there is a comma in middle of text field of form "xxx,xxx" 
					li_quote_comma = pos(is_stg,ls_quotecomma,li_pos)
					if li_quote_comma > li_comma then
						li_comma = li_quote_comma
						lb_quote_true = true
						li_end = li_comma
						li_length = li_end - li_start
					else
						mylog.log(this, "u_component_message_handler_foxy.parse_csv.0083", "A field of form 'x,x' does not have an ending quote PARSING FAILED for (" + is_stg + ")",4)
						RETURN -1
					end if
				else
					li_length = li_end - li_start
				end if
			end if
		END IF	
		ls_value = mid(is_stg,li_start,li_length)		// Assign the currently selected value to ls_value
		END IF
		is_array [li_ctr] = ls_value					//	Assign ls_value to the current array value
		li_ctr ++										// Increment the array counter
		if lb_quote_true = true then li_end ++
		li_start = li_end + 1				// The start of the next string is the end location + 1 chars
	ELSE
		//	This ELSE section runs only once, on the last array element
		IF li_ctr = 1 THEN
			lb_loop = FALSE								//	Set lb_loop to false, we're not going to start
			mylog.log(this, "u_component_message_handler_foxy.parse_csv.0083", "Never found an occurrance of quote-comma-quote in the input value, string PARSING FAILED for (" + is_stg + ", " + + ")",4)
			RETURN -1
		ELSE
			// This ELSE section runs only once, on the last array element if above test is passed
			li_pos = li_pos + 1 								//	We're here because the (",") test failed at the end of the string
			li_end = pos(is_stg,ls_quote,li_pos)		//	Get the location of the last quote
			li_start ++
			li_length = li_end - li_start 				//	This gives the selected character string length
			IF li_length > li_value_max_len THEN 
				mylog.log(this, "u_component_message_handler_foxy.parse_csv.0083", "A field length exceeds maximum number of characters,string PARSING FAILED for (" + is_stg + ", " + string(li_value_max_len) + ")",4)
				RETURN -1
			END IF	
			ls_value = mid(is_stg,li_start,li_length)		// Assign the currently selected value to ls_value
			is_array [li_ctr] = ls_value					//	Assign ls_value to the current array value
			lb_loop = FALSE									//	Set lb_loop to false, we're done
		END IF
	END IF
	if lb_quote_true = true then li_comma ++
	li_pos = li_comma  + 1								//	Increments ll_pos for the next loop, if one is coming
	ls_value = ''												//	Set ls_value to an empty string
	IF li_ctr > li_max_fields THEN
		mylog.log(this, "u_component_message_handler_foxy.parse_csv.0083", "Number of fields in record " + string(li_ctr) + " exceeds the maximum of " + string(li_max_fields) + " PARSING FAILED for (" + is_stg + ", " + + ")",4)
		RETURN -1
	END IF
LOOP	
		
// Test after finishing the loop for a completly empty variable array
li_array_upper = UpperBound(is_array )

//Check last array entry
if is_array[li_array_upper] = ls_quote then
	is_array[li_array_upper] = ""
end if	

DO WHILE li_test_ctr <= li_array_upper and lb_empty_flag = TRUE
	
	IF len(is_array [li_test_ctr]) > 0 THEN			// Check the length of the data
		li_test_ctr = li_array_upper					// Set the counter to the maximum value to force a quit
		lb_empty_flag = FALSE							// and set lb_empty_flag tp FALSE since a value was found
	ELSE														// At least one array element has a value in it
		li_test_ctr ++
	END IF	
LOOP
 
IF lb_empty_flag THEN
	mylog.log(this, "u_component_message_handler_foxy.parse_csv.0083", "None of the fields in record contains an entry, string PARSING FAILED for (" + is_stg + ", " + + ")",4)
	RETURN -1	
END IF

RETURN 1

end function

protected function integer xx_initialize ();
SELECT c_Component_Attribute.value  
    INTO :is_interface
    FROM c_Component_Attribute  
   WHERE ( c_Component_Attribute.component_id = 'FOXMEADOWS_BILL' ) AND  
         ( c_Component_Attribute.attribute = 'billing_system' )  using cprdb  ;
			
	if not cprdb.check() then
		return -1
	end if
if is_interface = '' or isnull(is_interface) then
	is_interface = 'FOXMEADOWS'
end if

set_timer() 
return 1	

end function

protected function integer foxmeadows_insurance ();long ll_array_count
string ls_billing_id
string ls_insurance_id
string ls_insurance_type
string ls_name
string ls_allocation
string ls_sequence
string ls_cpr_id
integer i,j
setnull(ls_allocation)

//  Account #
//  Insurance Id
//  Insurance Name
//  Insurance type
//  Insurance sequence 

//	Call the parsing function to put the comma separated values into ls_array[]
integer li_sts
li_sts = parse_csv(255)
IF li_sts < 0 THEN
		mylog.log(this, "u_component_message_handler_foxy.foxmeadows_insurance.0022", "The parse_csv() function failed Aborting Encounter Creation for Message ID (" + string(message_id) + ")", 4)
		RETURN -1
END IF	

ll_array_count = UpperBound(is_array)
if (isnull(ll_array_count) or ll_array_count = -1) then 
		mylog.log(this, "u_component_message_handler_foxy.foxmeadows_insurance.0022", "The parse_csv() function failed Message ID ("+ string(message_id) + ")", 4)
		RETURN -1
else 
	li_sts = ll_array_count
END IF	

ls_billing_id = is_array[1]
ls_insurance_id = is_array[2]
ls_name = is_array[3]
ls_insurance_type = is_array[4]
if ll_array_count = 5 then
	ls_sequence = is_array[5]
end if

if ls_sequence = '' then ls_sequence = '1'
if ls_insurance_type = '' then
	if upper(trim(ls_name)) = 'MEDICARE' then 
		ls_insurance_type = 'MEDICARE'
	elseif upper(trim(ls_name)) = 'MEDICAID' then
		ls_insurance_type = 'MEDICAID'
	else
		ls_insurance_type = 'STANDARDPOS'
	end if
end if	

	mylog.log(this, "u_component_message_handler_foxy.foxmeadows_insurance.0022", "Patient billing id  ("+ ls_billing_id + ")", 2)
	SELECT cpr_id
	INTO :ls_cpr_id
	FROM p_Patient
	WHERE billing_id = :ls_billing_id
	and patient_status = 'ACTIVE'
	USING cprdb;
	if not cprdb.check() then return -1
	if cprdb.sqlcode = 100 then 
		mylog.log(this, "u_component_message_handler_foxy.foxmeadows_insurance.0022", "Patient does not exist for  ("+ ls_billing_id + ")", 4)
		RETURN -1
	end if
	
	mylog.log(this, "u_component_message_handler_foxy.foxmeadows_insurance.0022", "Patient billing id  ("+ ls_insurance_id + ")",1)
	SELECT authority_id
	INTO :ls_insurance_id
	FROM c_Authority
	WHERE authority_id = :ls_insurance_id
	USING cprdb;
	if not cprdb.check() then return -1
	
	if cprdb.sqlcode = 100 then
		INSERT INTO c_Authority (
			authority_id,
			authority_type,
			authority_category,
			name,
			coding_component_id,
			status)
		VALUES (
			:ls_insurance_id,
			'PAYOR',
			:ls_insurance_type,
			:ls_name,
			null,
			'OK')
		USING cprdb;			
		if not cprdb.check() then return -1
	else
		update c_Authority
		Set 	name = :ls_name
		WHERE authority_id = :ls_insurance_id
		USING cprdb;	 
		if not cprdb.check() then return -1
	end if
	
	Delete from p_Patient_Authority
		where cpr_id = :ls_cpr_id USING cprdb;
	if not cprdb.check() then return -1	
	
	if isnumber(ls_sequence) then
		i = integer(ls_sequence)
	else 
		i = 1
	end if	
	
		INSERT INTO p_Patient_Authority  
         ( cpr_id,  
			  authority_type,	
           authority_sequence,   
           authority_id,   
           notes,   
           created,   
           created_by,   
           modified_by)
 			VALUES ( :ls_cpr_id,
  				'PAYOR',
           :i,
           :ls_insurance_id,   
           null,   
           getdate(),
           :system_user_id,
			  :system_user_id)		
			USING cprdb;
		if not cprdb.check() then return -1

mylog.log(this, "u_component_message_handler_foxy.foxmeadows_insurance.0022", "end of insurance ", 1)

return 1
	


end function

protected function integer foxmeadows_patient ();/*****************************************************************************************************************
*
* Description : add or update a referring provider into
*               c_consultant
*
* Returns: Integer 1 - Success
*                 -1 - Failure
*
*
* Sample data:
* 'PAT','0327601','Wilsone','Katrinka','Q','W','F','08/09/1971','01','(803) 444-5555','M','999999999','','','', &
* '0001','13 Mccords-Ferris Road','','Goffin','SC','29178','','01','',''
*
* Specification:
*	1	pat account	A4	pat Account Number.
*	2	pat last name	A?	pat last name
*	3	pat first name	A?	pat first name
*	4	pat middle initial A1	pat middle initial
*	5   pat race? a1 pat race
*	6	pat sex	A1	pat sex
*	7	pat date of birth	N8	MMDDYYYY
*	8   pat provider code? A2
*	9	pat phone	A14	(xxx) xxx-xxxx
*	10	pat marital status Free-form or blank
* 	11 SSN
* 	12 deceased date (data is filled in the patient is deceased and null for valid status)
* 	13 name_prefix
*	14 Name Suffix
* 	15 referring_provider_id
* 	16 address_line_1
* 	17 address_line_2
* 	18 city
* 	19 state
* 	20 zip
* 	21 email_address
* 	22 office_id
* 	23 degree 
* 	24 secondary phone number
********************************************************************************************************************/

string ls_race,ls_patient_status
string ls_consultant
date	ld_birthdate		
datetime ldt_date_of_birth
string ls_sex
string ls_phone_number,ls_sec_phone_number
string ls_deceased_date
string ls_primary_language
string ls_marital_status,ls_emailaddress
string ls_billing_id,ls_officeid
long ll_patient_id
string ls_first_name
string ls_last_name
string ls_degree
string ls_name_prefix
string ls_middle_name
string ls_name_suffix
string ls_primary_provider_id
string ls_secondary_provider_id,ls_ref_provider_id
string ls_addr1,ls_addr2,ls_city,ls_state,ls_zip
string ls_error
string fix_date
string ls_doctorid
string ls_ssn  
string ls_cpr_id
long ll_DoctorId, ll_array_count
long ll_null
integer li_sts
Integer li_priority

li_sts = parse_csv(255)
IF li_sts < 0 THEN
	mylog.log(this, "u_component_message_handler_foxy.foxmeadows_patient.0073", "The parse_csv() function failed Aborting Encounter Creation)", 4)
	RETURN -1
END IF	

ls_billing_id = is_array[1] 
mylog.log(this, "u_component_message_handler_foxy.foxmeadows_patient.0073", "The patient billing_id=" + ls_billing_id, 2)
SELECT cpr_id
INTO :ls_cpr_id
FROM p_Patient
WHERE billing_id = :ls_billing_id
and patient_status = 'ACTIVE'
USING cprdb;
if not cprdb.check() then return -1
if cprdb.sqlcode = 100 then
	setnull(ls_cpr_id)
end if

ls_Doctorid = is_array[8]

if isnull(ls_DoctorId) or len(ls_doctorid) = 0 then
	setnull(ls_primary_provider_id)
else
	SELECT user_id
	INTO :ls_primary_provider_id
	FROM c_User
	WHERE billing_id = :ls_Doctorid
	and user_status = 'OK'
	USING cprdb;
	if not cprdb.check() then return -1
	if cprdb.sqlcode = 100 then
		mylog.log(this, "u_component_message_handler_foxy.foxmeadows_patient.0073", "provider id =" + ls_doctorid+ " is not mapped", 3)
		ls_primary_provider_id = '!PHYSICIAN'
	end if
end if

ls_last_name 	= is_array[2]
ls_first_name 	= is_array[3]
ls_middle_name	= is_array[4]
ls_race 	= is_array[5]
ls_sex		= is_array[6]

if (is_array[7] = "0" or isnull(is_array[7]) or is_array[7] = "") then
	ls_error = is_array[7]
	mylog.log(this, "u_component_message_handler_foxy.foxmeadows_patient.0073", "birthdate error=" + ls_error + " (" + is_stg + ", " + + ")", 3)
	setnull(ldt_date_of_birth)
	setnull(ld_birthdate)
else	
	if isdate(is_array[7]) then
		ld_birthdate = date(is_array[7])
		ldt_date_of_birth = datetime(ld_birthdate)
	else
//reformat... try yyyymmdd	
		fix_date = left(is_array[7],4) + ' ' + mid(is_array[7],5,2) + ' ' + mid(is_array[7],7,2)
		if isdate(fix_date) then
			ld_birthdate = date(fix_date)
			ldt_date_of_birth = datetime(ld_birthdate)
		else
			ls_error = is_array[7]
			mylog.log(this, "u_component_message_handler_foxy.foxmeadows_patient.0073", "birthdate error=" + ls_error + " (" + is_stg + ", " + + ")", 4)
			setnull(ld_birthdate)
			setnull(ldt_date_of_birth)
		end if	
	end if
end if

setnull(ll_patient_id)

ls_phone_number = is_array[9]
ls_marital_status = is_array[10]

If upperbound(is_array) = 24 then // if foxmeadows latest spec sends more details in patient record
	ls_ssn = is_array[11]
	ls_deceased_date = is_array[12]
	ls_name_prefix = is_array[13]
	ls_name_suffix = is_array[14]
	ls_ref_provider_id = is_array[15]
	ls_addr1 = is_array[16]
	ls_addr2 = is_array[17]
	ls_city = is_array[18]
	ls_state = is_array[19]
	ls_zip = is_array[20]
	ls_emailaddress = is_array[21]
	ls_officeid = is_array[22]
	ls_degree = is_array[23]
	ls_sec_phone_number = is_array[24]
Else	
	setnull(ls_primary_language)
	setnull(ls_degree)
	setnull(ls_name_prefix)
	setnull(ls_name_suffix)
	setnull(ls_secondary_provider_id)
	setnull(ls_ssn)
End If
setnull(li_priority)
setnull(ll_null)

ls_sex = upper(left(ls_sex,1))
ls_marital_status = upper(left(ls_marital_status,1))
ls_race = left(ls_race,12)
ls_name_prefix = left(ls_name_prefix,12)
ls_first_name = left(ls_first_name,20)
ls_middle_name = left(ls_middle_name,20)
ls_last_name= left(ls_last_name,40)
ls_name_suffix = left(ls_name_suffix,12)
ls_primary_provider_id = left(ls_primary_provider_id,24)
ls_primary_language = left(ls_primary_language,12)
ls_phone_number = left(ls_phone_number,32)
ls_ssn = left(ls_ssn,24)
ls_addr1 = left(ls_addr1,40)
ls_addr2 = left(ls_addr2,40)
ls_city = left(ls_city,40)
ls_state = left(ls_state,2)
ls_zip = left(ls_zip,10)
ls_sec_phone_number = left(ls_sec_phone_number,16)
ls_ref_provider_id = left(ls_ref_provider_id,24)

// set the patient status based on the deceased date
ls_patient_status = 'ACTIVE'
if isdate(ls_deceased_date) then ls_patient_status = 'INACTIVE'

// check the referring provider is existing
SELECT consultant_id
INTO :ls_consultant
FROM c_Consultant
WHERE consultant_id = :ls_ref_provider_id;
if isnull(ls_consultant) or len(ls_consultant) = 0 then
	mylog.log(this, "u_component_message_handler_foxy.foxmeadows_patient.0073", "Referring provider id=" + ls_ref_provider_id+" is not found in c_Consultant", 3)
	setnull(ls_ref_provider_id)
end if
if isnull(ls_cpr_id) then
	mylog.log(this, "u_component_message_handler_foxy.foxmeadows_patient.0073", "create new patient, lname=" + ls_last_name, 1)
	li_sts = f_create_new_patient( &
									ls_cpr_id,   &
									ls_race,   &
									date(ldt_date_of_birth),   &
									ls_sex,   &
									ls_phone_number, &
									ls_primary_language,   &
									ls_marital_status,   &
									ls_billing_id,   &
									ll_null,   &
									ls_first_name,   &
									ls_last_name,   &
									ls_degree,   &
									ls_name_prefix,   &
									ls_middle_name,   &
									ls_name_suffix,   &
									ls_primary_provider_id, &
									ls_secondary_provider_id, &
									li_priority, &
									ls_ssn)
	if li_sts <= 0 then return -4
End If
UPDATE p_Patient
SET	name_prefix = 	:ls_name_prefix,
		first_name = 	:ls_first_name,
		middle_name = 	:ls_middle_name,
		last_name = 	:ls_last_name,
		name_suffix = 	:ls_name_suffix,
		date_of_birth = :ldt_date_of_birth,
		sex = :ls_sex,
		marital_status = :ls_marital_status,
		race = :ls_race,
		primary_provider_id = :ls_primary_provider_id,
		billing_id = :ls_billing_id,
		primary_language = :ls_primary_language,
		phone_number = :ls_phone_number,
		patient_id =   :ll_patient_id,
		ssn = :ls_ssn,
		address_line_1 = :ls_addr1,
		address_line_2 = :ls_addr2,
		city = :ls_city,
		state = :ls_state,
		zip = :ls_zip,
		secondary_phone_number = :ls_sec_phone_number,
		referring_provider_id = :ls_ref_provider_id,
		patient_status = :ls_patient_status
WHERE cpr_id = :ls_cpr_id
and patient_status = 'ACTIVE'
USING cprdb;
If NOT cprdb.check() then return -1

mylog.log(this, "u_component_message_handler_foxy.foxmeadows_patient.0073", "The patient funcion complete, cpr_id=" + ls_cpr_id, 1)

Return 1
end function

protected function integer foxmeadows_arrived ();datetime	ldt_encounter_date_time
datetime	ldt_check_date_time
integer	li_encounter_billing_id
integer	li_sts
integer	li_message_id
string	ls_billing_id
string	ls_chief_complaint
string	ls_comment2
string	ls_cprid
string	ls_encounter_type
string	ls_new_flag
string 	ls_appointment_type
string	ls_primary_provider_id
string	ls_status
string	ls_type_status
string	ls_attending_doctor, ls_patient_doctor
string 	ls_doctor_id
string	ls_facility
string   ls_fixer
string   ls_hours
string   ls_minutes
string   ls_seconds
string   ls_AMPM
date	   ld_compumedic_date, ld_foxmeadows_date
date     ld_today
time     lt_arrival_time
long 		ll_DoctorId, ll_count
long		ll_encounter_billing_id
long     ll_pos
integer	li_encounter_facility_id
boolean  lb_noappt_type

string ls_thisdatetime
date ld_thisdate, ld_scheduledate
datetime ldt_datetimebefore, ldt_datetimeafter,ld_scheduledatetime, ldt_beginofdate
time lt_thistime, lt_minbefore, lt_minafter, lt_scheduletime, lt_begin_time

ls_thisdatetime = string(today(),"yyyy/mm/dd hh:mm:ss")
ld_thisdate = Date(left(ls_thisdatetime,10))
lt_thistime = Time(Mid(ls_thisdatetime,12))

li_message_id = message_id
setnull(ls_Attending_doctor)

//Foxmeadows layout
//1 	appt account #	A4	appt account #
//2 	appt reason code #	A3	
//3	appt reason description	A?	appt reason description
//4 	appt provider code #	A?	
//5	appt date entered	N8	appt date entered (mmddyyyy)
//6	appt checkin time (hh:mm)
//7	appt encounter code	A?	
//8	appt comment#1	A?	
//9	appt comment#2 A?
//10	appt facility
//11  appt visit type - (E)stablished (N)ew

//CompuMedic layout (this is the integration spec)
//1 	appt Account #
//2 	appt Reason #
//3	appt Reason Description
//4 	appt Provider #
//5	appt Appointment Date/Time
//6	appt Encounter #
//7	appt Comment 1
//8	appt Comment 2
//9	appt Facility Code

//	Call the parsing function to put the comma separated values into ls_array[]
li_sts = parse_csv(255)
IF li_sts < 0 THEN
		mylog.log(this, "u_component_message_handler_foxy.foxmeadows_arrived.0072", "The parse_csv() function failed Aborting Encounter Creation for Billing ID, Message ID (" + ls_billing_id + ", " + string(message_id) + ")", 4)
		RETURN -1
END IF
int li_array_upper
li_array_upper = UpperBound(is_array )

setnull(ls_facility)
setnull(ls_new_flag)
ld_today = date(today())
ldt_check_date_time = datetime(ld_today)
ldt_encounter_date_time = datetime(today(),now())
ld_scheduledatetime = ldt_encounter_date_time

if is_interface = 'COMPUMEDIC' THEN
	if li_array_upper < 9 then
		mylog.log(this, "u_component_message_handler_foxy.foxmeadows_arrived.0087", "array length is short (" + string(li_array_upper) + ")", 4)
		RETURN -1
	else
		if isnumber(is_array[6]) then
			li_message_id = integer(is_array[6])
		else
			li_message_id = 1
		end if	
		ls_chief_complaint = is_array[7]
		ls_comment2 = is_array[2]
		ls_facility = is_array[9]
		ls_fixer = left(is_array[5],4) + ' ' + mid(is_array[5],5,2) + ' ' + mid(is_array[5],7,2)
		if isdate(ls_fixer) then
			ld_compumedic_date = date(ls_fixer)
			ls_AMPM = right(is_array[5],2)
			ls_fixer = mid(is_array[5],10)
			ls_fixer = left(ls_fixer,POS(ls_fixer," ") - 1)
			ls_hours = left(ls_fixer,POS(ls_fixer,":") - 1)
			ls_minutes = mid(ls_fixer,POS(ls_fixer,":") + 1)
			ls_seconds = mid(ls_minutes,POS(ls_minutes,":") + 1)
			ls_minutes = left(ls_minutes,POS(ls_minutes,":") - 1)
			if ls_AMPM = 'PM' then ls_hours = string(integer(ls_hours) + 12)
			lt_arrival_time = time(integer(ls_hours),integer(ls_minutes),integer(ls_seconds))
			ld_scheduledatetime = datetime(ld_compumedic_date,lt_arrival_time)
		else
			mylog.log(this, "u_component_message_handler_foxy.foxmeadows_arrived.0087", "date not provided", 2)
		end if	
	end if	
else
	//foxmeadows
	//check for facility
	if li_array_upper < 10 then
		setnull(ls_facility)
	else	
		ls_facility = is_array[10]
	end if	
	if li_array_upper = 11 then
		ls_new_flag = is_array[11]
	else
		setnull(ls_new_flag)
	end if	
//	ls_fixer = mid(is_array[5],5) + ' ' + mid(is_array[5],1,2) + ' ' + mid(is_array[5],3,2)
	ls_fixer = is_array[5]
	if isdate(ls_fixer) then
		ld_foxmeadows_date = date(ls_fixer)
		ls_fixer = is_array[6]
		if isnull(ls_fixer) or ls_fixer = '' then
			lt_arrival_time = now()
		else	
			ls_hours = left(ls_fixer,POS(ls_fixer,":") - 1)
			ls_minutes = mid(ls_fixer,POS(ls_fixer,":") + 1)
			lt_arrival_time = time(integer(ls_hours),integer(ls_minutes),0)
		end if	
		ld_scheduledatetime = datetime(ld_foxmeadows_date,lt_arrival_time)
	end if		
	if isnumber(is_array[8]) then	li_message_id = integer(is_array[8])
	if is_array[3] = "" then
		ls_chief_complaint = is_array[9]
	else
		if not (is_array[9] = "") then 
			ls_chief_complaint = is_array[3] + ", " + is_array[9]
		end if	
	end if	
	ls_comment2 = is_array[2]
end if	

//	Populate variables with the array contents
ls_billing_id = is_array[1] 
If isnull(ls_billing_id) or ls_billing_id = "" then
	mylog.log(this, "u_component_message_handler_foxy.foxmeadows_arrived.0072", "Billingid not found Aborting Encounter Creation for Billing ID, Message ID (" + ls_billing_id + ", " + string(message_id) + ")", 4)
	RETURN -1
END IF	
If isnumber(ls_billing_id) then
	ll_encounter_billing_id = long(ls_billing_id)
else
	mylog.log(this, "u_component_message_handler_foxy.foxmeadows_arrived.0072", "Billingid not numeric Aborting Encounter Creation for Billing ID, Message ID (" + ls_billing_id + ", " + string(message_id) + ")", 4)
	RETURN -1
END IF

//Check for duplicate message
SELECT count(x_medman_Arrived.billing_id )  
    INTO :ll_count
FROM x_medman_arrived
WHERE billing_id = :ls_billing_id AND
	appointment_time = :ld_scheduledatetime
	using cprdb;
if not cprdb.check() then return -1
if ll_count > 0 then 
	mylog.log(this, "u_component_message_handler_foxy.foxmeadows_arrived.0072", "billing id,scheduledatetime "+ls_billing_id+","+string(ld_scheduledatetime,"mm/dd/yyyy hh:mm:ss")+" already arrived", 3)
	return 1
end if
mylog.log(this, "u_component_message_handler_foxy.foxmeadows_arrived.0072", "billing id,scheduledatetime "+ls_billing_id+","+string(ld_scheduledatetime,"mm/dd/yyyy hh:mm:ss")+" arrived", 2)
ls_appointment_type = is_array[2]

lb_noappt_type = false
if isnull(ls_appointment_type) or ls_appointment_type = "" then
	setnull(ls_encounter_type)
else	
	SELECT encounter_type,
			 new_flag
	INTO :ls_encounter_type,
		  :ls_new_flag
	FROM b_Appointment_Type
	WHERE appointment_type = :ls_appointment_type
	USING cprdb;
	if not cprdb.check() then return -1
	if cprdb.sqlcode = 100 then
		lb_noappt_type = true
		SELECT encounter_type,
				 new_flag,
				 user_id
		INTO :ls_encounter_type,
			  :ls_new_flag,
			  :ls_attending_doctor
		FROM b_Resource
		WHERE resource = :ls_appointment_type
		USING cprdb;
		if not cprdb.check() then return -1
		if cprdb.sqlcode = 100 then
			setnull(ls_attending_doctor)
			setnull(ls_encounter_type)
			setnull(ls_new_flag)
		end if
	end if
end if

// If appointment_type didn't provide encounter_type, then use default
if isnull(ls_encounter_type) then
	ls_encounter_type = get_attribute("default_encounter_type")
	if isnull(ls_encounter_type) then ls_encounter_type = "SICK"
end if

if isnull(is_Array[4]) then
	setnull(ls_primary_provider_id)
else
	ls_doctor_id = is_Array[4]
	mylog.log(this, "u_component_message_handler_foxy.foxmeadows_arrived.0072", "Doctor Code: " + string(ls_doctor_id) , 2)
	if isnull(ls_doctor_id) or len(ls_doctor_id) = 0 Then
			setnull(ls_primary_provider_id)
	else
		SELECT user_id
		INTO :ls_primary_provider_id
		FROM c_User
		WHERE billing_id = :ls_doctor_id
		USING cprdb;
		if not cprdb.check() then return -1
		if cprdb.sqlcode = 100 then
			setnull(ls_primary_provider_id)
		end if
	end if
end if

if isnumber(ls_facility) then
	li_encounter_facility_id = integer(ls_facility)
end if	

SELECT cpr_id,
		primary_provider_id
INTO :ls_cprid,
	:ls_patient_doctor
FROM		p_Patient
WHERE		p_Patient.billing_id = :ls_billing_id
and patient_status = 'ACTIVE'
USING		cprdb;
IF NOT cprdb.check() THEN RETURN -1
IF cprdb.sqlcode = 100 THEN
	mylog.log(this, "u_component_message_handler_foxy.foxmeadows_arrived.0253", "Unable to retrieve a CPR_ID for Billing ID, Message ID (" + ls_billing_id + ", " + string(message_id) + ")", 4)
	RETURN 1
END IF

if isnull(ls_primary_provider_id) then
	if isnull(ls_attending_doctor) then
		ls_primary_provider_id = ls_patient_doctor
	else
		ls_primary_provider_id = ls_attending_doctor
	end if	
END IF	

string ls_error
If Isnull(ls_primary_provider_id) then
	ls_error = is_array[4]
	mylog.log(this, "u_component_message_handler_foxy.foxmeadows_arrived.0253", "Unable to retrieve a provider_ID to match the input provider_ID " + ls_error + " ..Aborting Encounter Creation for Billing ID, Message ID (" + ls_billing_id + ", " + string(message_id) + ")", 4)
	RETURN -1
End if	

ls_status = "SCHEDULED"
	
INSERT INTO	x_medman_Arrived (
				billing_id,
				encounter_billing_id,
				message_id,
				encounter_type,
				primary_provider_id,
				chief_complaint,
				comment2,
				cpr_id,
				encounter_date_time,
				status,
				facilityid,
				new_flag,
				appointment_time)
VALUES (
				:ls_billing_id,
				:ll_encounter_billing_id,
				:li_message_id,
				:ls_encounter_type,
				:ls_primary_provider_id,
				:ls_chief_complaint,
				:ls_comment2,
				:ls_cprid,
				:ldt_encounter_date_time,
				:ls_status,
				:ls_facility,
				:ls_new_flag,
				:ld_scheduledatetime);
	
IF NOT cprdb.check() THEN 
	mylog.log(this, "u_component_message_handler_foxy.foxmeadows_arrived.0304", "Unable write a record to x_foxmeadows_Arrived...Aborting Encounter Creation for Billing ID, Message ID (" + ls_billing_id + ", " + string(li_message_id) + ")", 4)
	RETURN -1									
END IF
	
Return 1
end function

protected function integer xx_handle_message ();/*
Function Name:		xx_handle_message for u_component_message_handler_foxy
Date Begun:			
Programmer:			
Purpose:			Process incoming Encounter Messages from the foxmeadows
						billing program.  Entries will be made into the x_foxmeadows_Arrived
						table.
Access:				Protected
Expects:				Nothing
Returns:				Integer
History:				
Notes:
Called by ancestor 'u_component_message_handler.handle_message'
which was called because an incoming *.mmi file was detected by 
'u_component_incoming.timer_ding'. 
*/
//	Declare Local Variables

boolean	lb_sts, lb_good
integer	li_filenum
integer	li_message_id
integer	li_sts
integer	li_sts_stg
integer	i,j
string	ls_filepath
string	ls_status
string 	emptyarray[]
string	ls_numvalue
long ll_str_len

string 	ls_rectype
//"CM" format file layout by Medical Manager
//Record types     
//   	G		Guarantor
//		P		Patient
//		C		Coverage Policy
//		R		Referring Docter
//		F		Facility
//		I		Insurance Plan
//		DR		Docter
//		DG		Diagnosis
//		PC		Procedure Codes
//		A		Appointment
//		N		Notes
//		CHG	Open Charges
//		AIL	Ailment
//		PMT	Open Payment
//		HCH	History Charges
//		HPM	History Payments	

li_sts_stg = 1
ls_filepath = message_file

IF FileExists(ls_filepath) THEN
	If FileLength(ls_filepath) <= 0 Then
		mylog.log(this, "u_component_message_handler_foxy.xx_handle_message.0056", "message file is empty ("+ ls_filepath + ")",3)
		FileDelete(ls_filepath)
		Return 1
	End If
	li_filenum = FileOpen(ls_filepath)
ELSE
	mylog.log(this, "u_component_message_handler_foxy.xx_handle_message.0056", "Unable to find the message_file at the expected location, message id (" + ls_filepath + ", " + string(li_message_id) + ")",4)
	RETURN -1
END IF

integer li_pos
integer li_comma, li_quote_comma
integer li_start
integer li_value_max_len
integer li_length

li_value_max_len = 3

IF li_filenum > 0 THEN
	DO UNTIL li_sts_stg <= 0
	//  If the file is opened in LineMode and a CR or LF is encountered before any 
	// characters are read, FileRead returns 0. If an error occurs, FileRead returns -1	
	//	Read each line of the file contents into the string ls_stg
		is_stg = ''
		li_sts_stg = FileRead(li_filenum,is_stg)
		// Test the FileRead status, if we got some characters, then parse the line
		IF li_sts_stg > 0 THEN
			ll_str_len = len(is_stg)
			IF ll_str_len > 0 then
				li_pos = pos(is_stg,"~'",1)	// Validate the 1st character is a quote
				IF li_pos = 1 THEN 
					ib_doublequote = false
					li_start = li_pos + 1		// If so, it;s OK to start
				ELSE
					li_pos = pos(is_stg,'~"',1)	// Validate the 1st character is a doublequote
					IF li_pos = 1 THEN 
						ib_doublequote = true
						li_start = li_pos + 1		// If so, it;s OK to start
					ELSE
						mylog.log(this, "u_component_message_handler_foxy.xx_handle_message.0056", "The input string does not start with a quote, string PARSING FAILED for (" + is_stg + ", " + + ")",4)
						RETURN -1
					END IF
				END IF
				if ib_doublequote then
					li_comma = pos(is_stg,'~",~"',li_pos)	// Be sure this is a quote,comma,quote sequence
				else
					li_comma = pos(is_stg,"~',~'",li_pos)
				end if	
				// If a positive number is returned, then continue
				IF li_comma > 0 THEN				// We're still in a valid string
					li_length = li_comma - li_start	//	Set the length of the string to get the desired characters
					IF li_length > li_value_max_len THEN 
						mylog.log(this, "u_component_message_handler_foxy.xx_handle_message.0056", "A field length exceeds maximum number of characters, string PARSING FAILED for (" + is_stg + ", " + string(li_value_max_len) + ")",4)
						if li_filenum > 0 then FileClose(li_filenum)
						RETURN -1
					END IF	
					
					ls_rectype = mid(is_stg,li_start,li_length)		// Assign the currently selected value to ls_value
					is_stg = mid(is_stg,li_comma + 1)
					if left(is_stg,1) = "," then is_stg = mid(is_stg,2)
					is_array = emptyarray
					
					CHOOSE CASE ls_rectype
					CASE "PAT" 
						mylog.log(this, "u_component_message_handler_foxy.xx_handle_message.0056","entering foxmeadows_patient()",1)
						li_sts = foxmeadows_patient()
					CASE "INS"
						mylog.log(this, "u_component_message_handler_foxy.xx_handle_message.0056","entering foxmeadows_insurance()",1)
						li_sts = foxmeadows_insurance()	
					CASE "REF"
						li_sts = referring_provider()	
					CASE "DGN"
						mylog.log(this, "u_component_message_handler_foxy.xx_handle_message.0056","entering foxmeadows_diagnosis()",1)
						li_sts = foxmeadows_diagnosis()		
					CASE "CHK"
						mylog.log(this, "u_component_message_handler_foxy.xx_handle_message.0056","entering foxmeadows_arrived()",1)
						li_sts = foxmeadows_arrived()
						if li_sts < 1 then
							li_sts_stg = -1
							if li_filenum > 0 then FileClose(li_filenum)
							return li_sts
						end if	
					END CHOOSE
					if li_sts < 0 then 
						if li_filenum > 0 then FileClose(li_filenum)
						return li_sts
					end if
				END IF
			END IF	
		END IF
	
	LOOP
END IF

IF li_filenum >0 THEN
	li_sts = FileClose(li_filenum)
	IF li_sts < 1 THEN
		mylog.log(this, "u_component_message_handler_foxy.xx_handle_message.0056", "Unable to close the file (" + ls_filepath + ")", 3)
	END IF
END IF
RETURN 1

end function

public function integer referring_provider ();/*****************************************************************
*
* Description : add or update a referring provider into
*               c_consultant
*
* Returns: Integer 1 - Success
*                 -1 - Failure
*
*
*
// Specification
//1 "REF" Recrod Type
//2 consultant_id 
//3 Description[3]
//4 first_name
//5 middle_name
//6 last_name
//7 degree
//8 name_prefix
//9 Name suffix
//10 Practice name
//11 address1
//12 address2
//13 city
//14 state
//15 zip
//16 phone
//17 fax
//18 email
******************************************************************/
integer li_sts

string ls_consultant
string ls_first_name,ls_last_name,ls_middle_name
string ls_name_prefix,ls_name_suffix
string ls_prac_name
string ls_degree,ls_email
string ls_address1,ls_address2,ls_city,ls_state,ls_zip
string ls_phone,ls_fax
string ls_consultant_id,ls_name

li_sts = parse_csv(255)
IF li_sts < 0 THEN
	mylog.log(this, "u_component_message_handler_foxy.referring_provider.0044", "The parse_csv() function failed to parse ref provider", 4)
	RETURN -1
END IF

If upperbound(is_array) = 17 then
	ls_consultant_id = is_array[1]
	ls_name = is_array[2]
	ls_first_name = is_array[3]
	ls_middle_name = is_array[4]
	ls_last_name = is_array[5]
	ls_degree = is_array[6]
	ls_name_prefix = is_array[7]
	ls_name_suffix = is_array[8]
	ls_prac_name = is_array[9]
	ls_address1 = is_array[10]
	ls_address2 = is_array[11]
	ls_city = is_array[12]
	ls_state = is_array[13]
	ls_zip = is_array[14]
	ls_phone = is_array[15]
	ls_fax = is_array[16]
	ls_email = is_array[17]
End If
If not isnull(ls_consultant_id) and len(ls_consultant_id) > 0 then
	SELECT consultant_id
	INTO :ls_consultant
	FROM c_Consultant
	WHERE consultant_id = :ls_consultant_id
	using sqlca;
	
	If sqlca.sqlcode = 100 then
		INSERT INTO c_Consultant (
			specialty_id,
			consultant_id,
			description,
			first_name,
			middle_name,
			last_name,
			degree,
			name_prefix,
			name_suffix,
			address1,
			address2,
			city,
			state,
			zip,
			phone,
			fax,
			email
		)
		VALUES
		(
			'$',
			:ls_consultant_id,
			:ls_name,
			:ls_first_name,
			:ls_middle_name,
			:ls_last_name,
			:ls_degree,
			:ls_name_prefix,
			:ls_name_suffix,
			:ls_address1,
			:ls_address2,
			:ls_city,
			:ls_state,
			:ls_zip,
			:ls_phone,
			:ls_fax,
			:ls_email
		)
		Using sqlca;
	Else
		UPDATE c_Consultant
		SET description = :ls_name,
			first_name = :ls_first_name,
			middle_name = :ls_middle_name,
			last_name = :ls_last_name,
			degree = :ls_degree,
			name_prefix = :ls_name_prefix,
			name_suffix = :ls_name_suffix,
			address1 = :ls_address1,
			address2 = :ls_address2,
			city = :ls_city,
			state = :ls_state,
			zip = :ls_zip,
			phone = :ls_phone,
			fax = :ls_fax,
			email = :ls_email
		WHERE consultant_id = :ls_consultant
		Using SQLCA;
	End If
End If
Return 1
end function

on u_component_message_handler_foxy.create
call super::create
end on

on u_component_message_handler_foxy.destroy
call super::destroy
end on

