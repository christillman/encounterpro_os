HA$PBExportHeader$u_component_message_handler_medware.sru
forward
global type u_component_message_handler_medware from u_component_message_handler
end type
end forward

global type u_component_message_handler_medware from u_component_message_handler
end type
global u_component_message_handler_medware u_component_message_handler_medware

type variables
string is_stg, is_array[]
string is_default_facility



end variables

forward prototypes
protected function integer parse_csv (integer pi_max_fields)
protected function integer xx_handle_message ()
protected function integer xx_initialize ()
protected function integer medware_patient ()
end prototypes

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
li_pos = pos(is_stg,'~"',1)
ls_quotecomma = '~",'
ls_quote = '~"'

IF li_pos = 1 THEN 
	li_start = li_pos + 1		// If so, it;s OK to start
	lb_loop = TRUE					// OK to loop
	li_ctr = 1
ELSE
	mylog.log(this, "parse_csv()", "The input string does not start with a quote, string PARSING FAILED for (" + is_stg + ", " + + ")",4)
	RETURN -1
END IF	

li_str_len = len(is_stg)
char lc_last_char
lc_last_char = Right(is_Stg,1)

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
			mylog.log(this, "parse_csv()", "A field length exceeds maximum number of characters, string PARSING FAILED for (" + is_stg + ", " + string(li_value_max_len) + ")",4)
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
						mylog.log(this, "parse_csv()", "A field of form 'x,x' does not have an ending quote PARSING FAILED for (" + is_stg + ")",4)
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
			mylog.log(this, "parse_csv()", "Never found an occurrance of quote-comma-quote in the input value, string PARSING FAILED for (" + is_stg + ", " + + ")",4)
			RETURN -1
		ELSE
			// This ELSE section runs only once, on the last array element if above test is passed
			li_pos = li_pos + 1 								//	We're here because the (",") test failed at the end of the string
			li_end = pos(is_stg,ls_quote,li_pos)		//	Get the location of the last quote
			li_start ++
			li_length = li_end - li_start 				//	This gives the selected character string length
			IF li_length > li_value_max_len THEN 
				mylog.log(this, "parse_csv()", "A field length exceeds maximum number of characters,string PARSING FAILED for (" + is_stg + ", " + string(li_value_max_len) + ")",4)
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
		mylog.log(this, "parse_csv()", "Number of fields in record " + string(li_ctr) + " exceeds the maximum of " + string(li_max_fields) + " PARSING FAILED for (" + is_stg + ", " + + ")",4)
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
	mylog.log(this, "parse_csv()", "None of the fields in record contains an entry, string PARSING FAILED for (" + is_stg + ", " + + ")",4)
	RETURN -1	
END IF

RETURN 1

end function

protected function integer xx_handle_message ();/*
Function Name:		xx_handle_message for u_component_message_handler_medware
Date Begun:			
Programmer:			
Purpose:			Process incoming Encounter Messages from the medware
						billing program. 
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

li_sts_stg = 1
ls_filepath = message_file

IF FileExists(ls_filepath) THEN
	li_filenum = FileOpen(ls_filepath)
ELSE
	mylog.log(this, "xx_handle_message()", "Unable to find the message_file at the expected location, message id (" + ls_filepath + ", " + string(li_message_id) + ")",4)
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
				li_pos = pos(is_stg,"~"",1)	// Validate the 1st character is a quote
				IF li_pos = 1 THEN 
					li_start = li_pos + 1		// If so, it;s OK to start
				ELSE
					mylog.log(this, "xx_handle_message()", "The input string does not start with a quote, string PARSING FAILED for (" + is_stg + ", " + + ")",4)
					RETURN -1
				END IF
				li_comma = pos(is_stg,"~",~"",li_pos)	// Be sure this is a quote,comma,quote sequence
				// If a positive number is returned, then continue
				IF li_comma > 0 THEN				// We're still in a valid string
					li_length = li_comma - li_start	//	Set the length of the string to get the desired characters
					IF li_length > li_value_max_len THEN 
						mylog.log(this, "xx_handle_message()", "A field length exceeds maximum number of characters, string PARSING FAILED for (" + is_stg + ", " + string(li_value_max_len) + ")",4)
						RETURN -1
					END IF	
					
					ls_rectype = mid(is_stg,li_start,li_length)		// Assign the currently selected value to ls_value
					is_stg = mid(is_stg,li_comma + 1)
					if left(is_stg,1) = "," then is_stg = mid(is_stg,2)
					is_array = emptyarray
					
					CHOOSE CASE ls_rectype
					CASE "PAT" 
						li_sts = medware_patient()
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
		mylog.log(this, "xx_handle_message()", "Unable to close the medware.mmi incoming transfer file...Aborting Encounter Creation for Message ID (" + string(li_message_id) + ")", 4)
		RETURN -1									
	END IF
END IF

RETURN 1

end function

protected function integer xx_initialize ();set_timer() 
return 1
end function

protected function integer medware_patient ();date	ld_birthdate		
datetime ldt_date_of_birth
string ls_race
string ls_sex
string ls_phone_number
string ls_primary_language
string ls_marital_status
string ls_billing_id
string ls_cpr_id
string ls_first_name
string ls_last_name
string ls_degree
string ls_name_prefix
string ls_middle_name
string ls_name_suffix
string ls_primary_provider_id
string ls_secondary_provider_id
string ls_ssn
string ls_error
string fix_date
string ls_doctorid
string ls_name
string ls_insurance_id
string ls_fix_insurance_id
string ls_insurance_type
string ls_allocation
long ll_DoctorId, ll_array_count
long ll_pos
long ll_patient_id
integer li_sts, i
integer li_priority

//1	pat account	A4	pat Account Number.
//2	pat last name	A?	pat last name
//3	pat first name	A?	pat first name
//4	pat middle initial A1	pat middle initial
//5	pat sex	A1	pat sex
//6	pat date of birth	N8	MMDDYYYY
//7   pat provider code? A2
//8	pat phone	A14	(xxx) xxx-xxxx
//9	pat marital status Free-form or blank
//10  pat insurance name

li_sts = parse_csv(255)
IF li_sts < 0 THEN
	mylog.log(this, "medware_patient()", "The parse_csv() function failed Aborting Encounter Creation)", 4)
	RETURN -1
END IF	

ls_billing_id = is_array[1] 
if isnull(ls_billing_id) or ls_billing_id = '' then
	mylog.log(this, "medware_patient()", "no patient billing_id " + is_array[2] + "," + is_array[3], 2)
	return 1
end if

mylog.log(this, "medware_patient()", "The patient billing_id=" + ls_billing_id, 2)
SELECT cpr_id
INTO :ls_cpr_id
FROM p_Patient
WHERE billing_id = :ls_billing_id
USING cprdb;
if not cprdb.check() then return -1
if cprdb.sqlcode = 100 then
	setnull(ls_cpr_id)
end if

ls_Doctorid = is_array[7]

if isnull(ls_DoctorId) then
	setnull(ls_primary_provider_id)
else
	SELECT user_id
	INTO :ls_primary_provider_id
	FROM c_User
	WHERE billing_id = :ls_Doctorid
	USING cprdb;
	if not cprdb.check() then return -1
	if cprdb.sqlcode = 100 then
		setnull(ls_primary_provider_id)
	end if
end if

ls_last_name 	= is_array[2]
ls_first_name 	= is_array[3]
ls_middle_name	= is_array[4]
ls_sex			= is_array[5]
setnull(ls_race)
setnull(ls_allocation)

if (is_array[6] = "0" or isnull(is_array[6]) or is_array[6] = "") then
	ls_error = is_array[6]
	mylog.log(this, "medware_patient()", "birthdate error=" + ls_error + " (" + is_stg + ", " + + ")", 3)
	setnull(ldt_date_of_birth)
	setnull(ld_birthdate)
else	
	if isdate(is_array[6]) then
		ld_birthdate = date(is_array[6])
		ldt_date_of_birth = datetime(ld_birthdate)
	else
//reformat... try mmddyyyy	
		fix_date = mid(is_array[6],5,4) + ' ' + mid(is_array[6],1,2) + ' ' + mid(is_array[6],3,2)
		if isdate(fix_date) then
			ld_birthdate = date(fix_date)
			ldt_date_of_birth = datetime(ld_birthdate)
		else
			ls_error = is_array[6]
			mylog.log(this, "medware_patient()", "birthdate error=" + ls_error + " (" + is_stg + ", " + + ")", 4)
			setnull(ld_birthdate)
			setnull(ldt_date_of_birth)
		end if	
	end if
end if

setnull(ll_patient_id)

ls_phone_number = is_array[8]
ls_marital_status = is_array[9]

setnull(ls_primary_language)
setnull(ls_degree)
setnull(ls_name_prefix)
setnull(ls_name_suffix)
setnull(ls_secondary_provider_id)
setnull(li_priority)
setnull(ls_ssn)

if isnull(ls_cpr_id) then
	mylog.log(this, "medware_patient()", "create new patient, lname=" + ls_last_name, 1)
	li_sts = f_create_new_patient( &
						ls_cpr_id,   &
						ls_race,   &
						ld_birthdate,   &
						ls_sex,   &
						ls_phone_number, &
						ls_primary_language,   &
						ls_marital_status,   &
						ls_billing_id,   &
						ll_patient_id,   &
						ls_first_name,   &
						ls_last_name,   &
						ls_degree,   &
						ls_name_prefix,   &
						ls_middle_name,   &
						ls_name_suffix,   &
						ls_primary_provider_id, &
						ls_secondary_provider_id, &
						li_priority, &
						ls_ssn )
	if li_sts <= 0 then return -4
else
	UPDATE p_Patient
	SET first_name = :ls_first_name,
		middle_name = :ls_middle_name,
		last_name = :ls_last_name,
		date_of_birth = :ldt_date_of_birth,
		sex = :ls_sex,
		phone_number = :ls_phone_number,
		primary_provider_id = :ls_primary_provider_id,
		billing_id = :ls_billing_id,
		marital_status = :ls_marital_status
		WHERE cpr_id = :ls_cpr_id
	USING cprdb;
	if not cprdb.check() then return -1
	if cprdb.sqlcode = 100 then return -5
end if
mylog.log(this, "medware_patient()", "The patient funcion complete, cpr_id=" + ls_cpr_id, 1)

if isnull(is_array[10]) or is_array[10] = '' then return 1
ls_name = is_array[10]
ls_fix_insurance_id = UPPER(trim(ls_name))
if len(ls_fix_insurance_id) > 24 then
	ls_fix_insurance_id = left(ls_fix_insurance_id,24)
	ls_fix_insurance_id = trim(ls_fix_insurance_id)
end if

ll_pos = POS(ls_name,'Medicare',1)
if ll_pos = 0 then
	ll_pos = POS(ls_name,'Medicare',1)
	if ll_pos > 0 then ls_insurance_type = 'Medicare'
else 
	ls_insurance_type = 'Medicare'
end if

if ll_pos = 0 then
	ll_pos = POS(ls_name,'MEDICAID',1)
	if ll_pos > 0 then ls_insurance_type = 'Medicaid'
else 
	ll_pos = POS(ls_name,'Medicaid',1)
	if ll_pos > 0 then ls_insurance_type = 'Medicaid'
end if

if ll_pos = 0 then
	ls_insurance_type = 'StandardPOS'
end if	

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
		i = 1
		
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
	
return 1
end function

on u_component_message_handler_medware.create
call super::create
end on

on u_component_message_handler_medware.destroy
call super::destroy
end on

