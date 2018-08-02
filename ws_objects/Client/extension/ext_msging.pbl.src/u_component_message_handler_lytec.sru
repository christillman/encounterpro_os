$PBExportHeader$u_component_message_handler_lytec.sru
forward
global type u_component_message_handler_lytec from u_component_message_handler
end type
end forward

global type u_component_message_handler_lytec from u_component_message_handler
end type
global u_component_message_handler_lytec u_component_message_handler_lytec

type variables
string is_stg, is_array[]
string billing_id_domain  // used to look up patients from different domain [multiple PMS]
string billing_id_prefix // prefix the billingid if there are more than one PMS

integer ii_message_id
end variables

forward prototypes
protected function integer xx_handle_message ()
protected function integer parse_csv (integer pi_max_fields)
protected function integer xx_initialize ()
public function integer lytec_patient ()
end prototypes

protected function integer xx_handle_message ();/*
Function Name:		xx_handle_message for u_component_message_handler_lytec
Purpose:				Process incoming Encounter Messages from the lytec
						billing program.  Entries will be made into the x_Medman_Arrived
						table.
Access:				Protected
Expects:				Nothing
Returns:				Integer
History:				
Notes:
Called by ancestor 'u_component_message_handler.handle_message'
which was called because an incoming *.out file was detected by 
'u_component_incoming.timer_ding'. 
*/
//	Declare Local Variables

boolean	lb_sts, lb_good
integer	li_filenum
integer	li_message_id
integer	li_sts
integer	li_sts_stg
integer	i
string	ls_filepath
string	ls_status

long ll_str_len

string 	ls_rectype
li_sts_stg = 1
ls_filepath = message_file

IF FileExists(ls_filepath) THEN
	li_filenum = FileOpen(ls_filepath)
ELSE
	mylog.log(this, "u_component_message_handler_lytec.xx_handle_message.0035", "Unable to find the message_file at the expected location, message id (" + ls_filepath + ", " + string(li_message_id) + ")",4)
	RETURN -1
END IF

integer li_pos
integer li_comma
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
				li_pos = pos(is_stg,"~"",1)	// Validate the 1st character is a quote
				IF li_pos = 1 THEN 
					li_start = li_pos + 1		// If so, it;s OK to start
				ELSE
					mylog.log(this, "u_component_message_handler_lytec.xx_handle_message.0035", "The input string does not start with a quote, string PARSING FAILED for (" + is_stg + ", " + + ")",4)
					RETURN -1
				END IF
				li_comma = pos(is_stg,"~",~"",li_pos)	// Be sure this is a quote,comma,quote sequence
				// If a positive number is returned, then continue
				IF li_comma > 0 THEN				// We're still in a valid string
					li_length = li_comma - li_start	//	Set the length of the string to get the desired characters
					IF li_length > li_value_max_len THEN 
						mylog.log(this, "u_component_message_handler_lytec.xx_handle_message.0035", "A field length exceeds maximum number of characters, string PARSING FAILED for (" + is_stg + ", " + string(li_value_max_len) + ")",4)
						RETURN -1
					END IF	
					ls_rectype = mid(is_stg,li_start,li_length)		// Assign the currently selected value to ls_value
				// go down past the reserved section -> record type indicator	
					is_stg = mid(is_stg,li_comma + 2)
									
					CHOOSE CASE ls_rectype
					CASE "PAT" 
						li_sts = lytec_patient()
					
					END CHOOSE
					if li_sts < 0 then return li_sts
				END IF
			END IF	
		END IF
	LOOP
END IF

IF li_filenum >0 THEN
	li_sts = FileClose(li_filenum)
	//	If the FileClose() function returns less than 1, then quit
	IF li_sts < 1 THEN
		mylog.log(this, "u_component_message_handler_lytec.xx_handle_message.0035", "Unable to close the lytec.mmi incoming transfer file...Aborting Encounter Creation for Message ID (" + string(li_message_id) + ")", 4)
		RETURN -1									
	END IF
	
	lb_sts = FileDelete(ls_filepath)
	//	If the FileDelete() function does not return TRUE, then quit	
	IF NOT lb_sts THEN
		mylog.log(this, "u_component_message_handler_lytec.xx_handle_message.0035", "Unable to delete the lytec.mmi incoming transfer file...Aborting Encounter Creation for Message ID (" + string(li_message_id) + ")", 4)
		RETURN -1									
	END IF
END IF

RETURN 1

end function

protected function integer parse_csv (integer pi_max_fields);/*
Function Name:		parse_csv
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
string ls_value
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

lb_loop = FALSE
lb_empty_flag = TRUE

li_pos = pos(is_stg,"~"",1)		// Validate the 1st character is a quote
IF li_pos = 1 THEN 
	li_start = li_pos + 1		// If so, it;s OK to start
	lb_loop = TRUE					// OK to loop
	li_ctr = 1
ELSE
	mylog.log(this, "u_component_message_handler_lytec.parse_csv.0066", "The input string does not start with a quote, string PARSING FAILED for (" + is_stg + ", " + + ")",4)
	RETURN -1
END IF	

li_str_len = len(is_stg)
mylog.log(this, "u_component_message_handler_lytec.parse_csv.0066", "Message received (" + is_stg + ")",1)

//	Start the main data parsing loop
DO WHILE lb_loop 
	li_comma = pos(is_stg,"~,",li_pos)				// Be sure this is a comma
	li_quote_comma = pos(is_stg,"~",",li_pos)
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
			mylog.log(this, "u_component_message_handler_lytec.parse_csv.0066", "A field length exceeds maximum number of characters, string PARSING FAILED for (" + is_stg + ", " + string(li_value_max_len) + ")",4)
			RETURN -1
		END IF	
		li_quote = pos(is_stg,"~"",li_start)  // check for a beginning quote in the value
		if li_quote = li_start then 
			li_start ++
			if lb_quote_true = false then 	//Adjust for special situation where ther is a comma in middle of text field of form "xxx,xxx" 
					li_quote_comma = pos(is_stg,"~",",li_pos)
					if li_quote_comma > li_comma then
						li_comma = li_quote_comma
						lb_quote_true = true
						li_end = li_comma
						li_length = li_end - li_start
					else
						mylog.log(this, "u_component_message_handler_lytec.parse_csv.0066", "A field of form 'x,x' does not have an ending quote PARSING FAILED for (" + is_stg + ")",4)
						RETURN -1
					end if
				else
					li_length = li_end - li_start
			end if
		end if	
		ls_value = mid(is_stg,li_start,li_length)		// Assign the currently selected value to ls_value
		is_array [li_ctr] = ls_value					//	Assign ls_value to the current array value
		li_ctr ++										// Increment the array counter
		if lb_quote_true = true then li_end ++
		li_start = li_end + 1				// The start of the next string is the end location + 1 chars
	ELSE
		//	This ELSE section runs only once, on the last array element
		IF li_ctr = 1 THEN
			lb_loop = FALSE								//	Set lb_loop to false, we're not going to start
			mylog.log(this, "u_component_message_handler_lytec.parse_csv.0066", "Never found an occurrance of quote-comma-quote in the input value, string PARSING FAILED for (" + is_stg + ", " + + ")",4)
			RETURN -1
		ELSE
			// This ELSE section runs only once, on the last array element if above test is passed
			li_pos = li_pos + 1 								//	We're here because the (",") test failed at the end of the string
			li_end = pos(is_stg,"~"",li_pos)					//	Get the location of the last quote
			li_start ++
			li_length = li_end - li_start 				//	This gives the selected character string length
			IF li_length > li_value_max_len THEN 
				mylog.log(this, "u_component_message_handler_lytec.parse_csv.0066", "A field length exceeds maximum number of characters,string PARSING FAILED for (" + is_stg + ", " + string(li_value_max_len) + ")",4)
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
		mylog.log(this, "u_component_message_handler_lytec.parse_csv.0066", "Number of fields in record " + string(li_ctr) + " exceeds the maximum of " + string(li_max_fields) + " PARSING FAILED for (" + is_stg + ", " + + ")",4)
		RETURN -1
	END IF
LOOP	
		
// Test after finishing the loop for a completly empty variable array
li_array_upper = UpperBound(is_array )

DO WHILE li_test_ctr <= li_array_upper and lb_empty_flag = TRUE
	
	IF len(is_array [li_test_ctr]) > 0 THEN			// Check the length of the data
		li_test_ctr = li_array_upper					// Set the counter to the maximum value to force a quit
		lb_empty_flag = FALSE							// and set lb_empty_flag tp FALSE since a value was found
	ELSE														// At least one array element has a value in it
		li_test_ctr ++
	END IF	
LOOP
 
IF lb_empty_flag THEN
	mylog.log(this, "u_component_message_handler_lytec.parse_csv.0066", "None of the fields in record contains an entry, string PARSING FAILED for (" + is_stg + ", " + + ")",4)
	RETURN -1	
END IF

RETURN 1

end function

protected function integer xx_initialize ();get_attribute("billing_id_domain",billing_id_domain)
if isnull(billing_id_domain) then billing_id_domain = "JMJBILLINGID"

get_attribute("billing_id_prefix",billing_id_prefix)

get_attribute("billing_id_prefix",billing_id_prefix)
if isnull(billing_id_prefix) then
	if billing_id_domain <> "JMJBILLINGID" then
		log.log(this,"u_component_message_handler_lytec.xx_initialize.0009","Billing ID Prefix is required for multi billing system domains",4)
		return -1
	end if
end if

set_timer() 
Return 1
end function

public function integer lytec_patient ();/***************************************************************************
*
*  Description: 
*
*
*
*
*
*  Message Format:
* //1	pat account	A4	pat Account Number.
*	//2	pat last name	A?	pat last name
*	//3	pat first name	A?	pat first name
*	//4	pat middle initial A1	pat middle initial
*	//5   	pat race? 	a1 pat race
*	//6	pat sex		A1	pat sex
*	//7	pat date of birth	N8	MMDDYYYY
*	//8   	pat provider code? A2
*	//9	pat phone	A14	(xxx) xxx-xxxx
*	//10	pat marital status Free-form or blank
*
*
***************************************************************************/
string ls_epro_doctorid
string ls_race
date	ld_birthdate		
datetime ldt_date_of_birth,ldt_null
string ls_sex
string ls_phone_number
string ls_primary_language
string ls_marital_status
string ls_billing_id
string ls_first_name
string ls_last_name
string ls_degree
string ls_name_prefix
string ls_middle_name
string ls_name_suffix
string ls_primary_provider_id
string ls_secondary_provider_id
string ls_error
string ls_DoctorId
string ls_ssn 
string ls_cpr_id
string ls_epro_billing_id
integer li_sts
integer li_priority
long ll_patient_id
long ll_null

setnull(ll_null)
setnull(ldt_null)
setnull(ll_patient_id)
setnull(ls_primary_language)
setnull(ls_degree)
setnull(ls_name_prefix)
setnull(ls_name_suffix)
setnull(ls_secondary_provider_id)
setnull(li_priority)
setnull(ls_ssn)

li_sts = parse_csv(10)
IF li_sts < 0 THEN
	mylog.log(this, "u_component_message_handler_lytec.lytec_patient.0063", "The parse_csv() function failed Aborting Encounter Creation for Message ID (" + string(ii_message_id) + ")", 4)
	RETURN -1
END IF	

ls_billing_id = is_array[1] 
mylog.log(this, "u_component_message_handler_lytec.lytec_patient.0063", "The patient billing_id=" + ls_billing_id, 2)

// Patient Lookup
ls_cpr_id = sqlca.fn_lookup_patient(billing_id_domain,ls_billing_id)
if ls_cpr_id = "" then setnull(ls_cpr_id)

ls_Doctorid = is_array[8]
if isnull(ls_DoctorId) then
	setnull(ls_primary_provider_id)
else
	// Translate Provider
	ls_epro_doctorid = sqlca.fn_lookup_user(message_office_id,ls_doctorid)
	if isnull(ls_epro_doctorid) or len(ls_epro_doctorid)=0 then ls_epro_doctorid = ls_doctorid
	
	SELECT user_id
	INTO :ls_primary_provider_id
	FROM c_User
	WHERE billing_id = :ls_Doctorid
	and user_status = 'OK'
	USING cprdb;
	if not cprdb.check() then return -1
	if cprdb.sqlcode = 100 then
		setnull(ls_primary_provider_id)
	end if 
end if

ls_last_name 	= is_array[2]
ls_first_name 	= is_array[3]
ls_middle_name	= is_array[4]
ls_race 			= is_array[5]
ls_sex			= is_array[6]

if (is_array[7] = "0" or isnull(is_array[7]) or is_array[7] = "") then
	ls_error = is_array[7]
	mylog.log(this, "u_component_message_handler_lytec.lytec_patient.0063", "birthdate error=" + ls_error + " (" + is_stg + ", " + + ")", 3)
	setnull(ldt_date_of_birth)
	setnull(ld_birthdate)
else	
		if isdate(is_array[7]) then
		ld_birthdate = date(is_array[7])
		ldt_date_of_birth = datetime(ld_birthdate)
	else
		ls_error = is_array[7]
		mylog.log(this, "u_component_message_handler_lytec.lytec_patient.0063", "birthdate error=" + ls_error + " (" + is_stg + ", " + + ")", 4)
		return -1
	end if
end if


ls_phone_number = is_array[9]
ls_marital_status = is_array[10]
if isnull(billing_id_prefix) then
	ls_epro_billing_id = ls_billing_id
else
	ls_epro_billing_id = billing_id_prefix + ls_billing_id
end if

if isnull(ls_cpr_id) then
	mylog.log(this, "u_component_message_handler_lytec.lytec_patient.0063", "create new patient, lname=" + ls_last_name, 2)
	li_sts = f_create_new_patient( &
									ls_cpr_id,   &
									ls_race,   &
									date(ldt_date_of_birth),   &
									ls_sex,   &
									ls_phone_number, &
									ls_primary_language,   &
									ls_marital_status,   &
									ls_epro_billing_id,   &
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
	
	// add patient progress
	sqlca.sp_Set_Patient_Progress(ls_cpr_id,ll_null,ll_null,"ID",billing_id_domain,ls_billing_id, ldt_null,ll_null,ll_null,current_user.user_id,current_user.user_id)	
End if
UPDATE p_Patient
SET first_name = :ls_first_name,
	middle_name = :ls_middle_name,
	last_name = :ls_last_name,
	date_of_birth = :ldt_date_of_birth,
	sex = :ls_sex,
	phone_number = :ls_phone_number,
	primary_provider_id = :ls_primary_provider_id,
	marital_status = :ls_marital_status,
	race = :ls_race,
	office_id = :message_office_id
WHERE cpr_id = :ls_cpr_id
USING cprdb;

if not cprdb.check() then return -1
if cprdb.sqlcode = 100 then return -5
mylog.log(this, "u_component_message_handler_lytec.lytec_patient.0063", "The patient funcion complete, cpr_id=" + ls_cpr_id, 1)

Return 1
end function

on u_component_message_handler_lytec.create
call super::create
end on

on u_component_message_handler_lytec.destroy
call super::destroy
end on

