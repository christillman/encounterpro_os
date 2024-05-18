$PBExportHeader$u_component_message_handler_medman.sru
forward
global type u_component_message_handler_medman from u_component_message_handler
end type
end forward

global type u_component_message_handler_medman from u_component_message_handler
end type
global u_component_message_handler_medman u_component_message_handler_medman

type variables
string is_stg, is_array[]
string is_offices[]
string is_default_office
integer ii_office_count
boolean	siblings_phone
string northampton_rules
string yamajala_rules
string default_provider
string default_facility


end variables

forward prototypes
protected function integer medman_diagnosis ()
protected function integer medman_notes ()
protected function integer medman_procedure ()
protected function integer parse_csv (integer pi_max_fields)
protected function integer xx_handle_message ()
public function integer patient_guarantor ()
public function integer parse_message ()
protected function integer xx_initialize ()
protected function integer medman_insurance ()
protected function integer medman_patient ()
protected function integer medman_arrived ()
end prototypes

protected function integer medman_diagnosis ();  
int li_sts
long ll_array_count
//1	05.	3.2	Diagnosis Code	A10	Diagnosis Code
//2	06.	3.3	Description	A45	Description


//	Call the parsing function to put the comma separated values into ls_array[]
li_sts = parse_csv(255)
IF li_sts < 0 THEN
		mylog.log(this, "u_component_message_handler_medman.medman_diagnosis:0011", "The parse_csv() function failed Aborting Appointment Creation for Message ID (" + string(message_id) + ")", 4)
		RETURN -1
END IF
ll_array_count = UpperBound(is_array)
if (isnull(ll_array_count) or ll_array_count = -1) then 
		mylog.log(this, "u_component_message_handler_medman.medman_diagnosis:0016", "The parse_csv() function failed Message ID (" + string(message_id) + ")", 4)
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

protected function integer medman_notes ();
//1	05.	2.2	notes account #	A6	notes account #
//2	06.	7.2	notes dep #	N2	notes dep #
//3	07.	95.5	notes system	A4	notes system
//4	08.	95.6	notes type	A4	notes type
//5	09.		notes sequence #	A8	may be blank - use record order
//6	10.		notes text	A80	notes text


return 1
end function

protected function integer medman_procedure ();int li_sts
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
		mylog.log(this, "u_component_message_handler_medman.medman_procedure:0016", "The parse_csv() function failed Aborting Appointment Creation for Message ID (" + string(message_id) + ")", 4)
		RETURN -1
END IF
ll_array_count = UpperBound(is_array)
if (isnull(ll_array_count) or ll_array_count = -1) then 
		mylog.log(this, "u_component_message_handler_medman.medman_procedure:0021", "The parse_csv() function failed Message ID (" + string(message_id) + ")", 4)
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
Date Begun:			December 10, 1998
Programmer:			George E. Snead
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

if len(is_stg) = 0 THEN return -1

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
//first position is a number ...	
	li_start = 1
	li_end =  pos(is_stg,"~,",1)
	li_length = li_end - li_start
	ls_numvalue = Mid(is_stg,li_start,li_length) 
	IF not IsNumber(ls_numvalue) then
			mylog.log(this, "u_component_message_handler_medman.parse_csv:0077", "The input string does not start with a quote, string PARSING FAILED for (" + is_stg + ", " + + ")",4)
			RETURN -1
	END IF
	is_array [1] = ls_numvalue
	lb_loop = true
	li_ctr = 2
	li_start = li_end + 1
END IF	

li_str_len = len(is_stg)
mylog.log(this, "u_component_message_handler_medman.parse_csv:0087", "Message received (" + is_stg + ")",1)

//IF pos(is_stg,"~"",li_str_len) = 0 THEN
//	if pos(is_stg,"~,",li_str_len) = 0 THEN
//		mylog.log(this, "u_component_message_handler_medman.parse_csv:0091", "The input string does not end with a comma, string PARSING FAILED for (" + is_stg + ", " + + ")",4)
//		RETURN -1
//	elseif pos(is_stg,"~ ",li_str_len) = 0 THEN
//		mylog.log(this, "u_component_message_handler_medman.parse_csv:0094", "The input string does not end with a space, string PARSING FAILED for (" + is_stg + ", " + + ")",4)
//		RETURN -1	
//	else
//		mylog.log(this, "u_component_message_handler_medman.parse_csv:0097", "The input string does not end with a quote, string PARSING FAILED for (" + is_stg + ", " + + ")",4)
//		RETURN -1
//	END IF	
//END IF

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
			mylog.log(this, "u_component_message_handler_medman.parse_csv:0118", "A field length exceeds maximum number of characters, string PARSING FAILED for (" + is_stg + ", " + string(li_value_max_len) + ")",4)
			RETURN -1
		END IF
		if li_length = 0 then
			ls_value = ""
		else	
		ls_numvalue = Mid(is_stg,li_start,li_length) //check for a numeric value without quotes
		IF not IsNumber(ls_numvalue) then
			li_quote = pos(is_stg,"~"",li_start)  // check for a beginning quote in the value
			if li_quote = li_start then 
				li_start ++
				if lb_quote_true = false then 	//Adjust for special situation where there is a comma in middle of text field of form "xxx,xxx" 
					li_quote_comma = pos(is_stg,"~",",li_pos)
					if li_quote_comma > li_comma then
						li_comma = li_quote_comma
						lb_quote_true = true
						li_end = li_comma
						li_length = li_end - li_start
					else
						mylog.log(this, "u_component_message_handler_medman.parse_csv:0137", "A field of form 'x,x' does not have an ending quote PARSING FAILED for (" + is_stg + ")",4)
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
			mylog.log(this, "u_component_message_handler_medman.parse_csv:0155", "Never found an occurrance of quote-comma-quote in the input value, string PARSING FAILED for (" + is_stg + ", " + + ")",4)
			RETURN -1
		ELSE
			// This ELSE section runs only once, on the last array element if above test is passed
			li_pos = li_pos + 1 								//	We're here because the (",") test failed at the end of the string
			li_end = pos(is_stg,"~"",li_pos)					//	Get the location of the last quote
			li_start ++
			li_length = li_end - li_start 				//	This gives the selected character string length
			IF li_length > li_value_max_len THEN 
				mylog.log(this, "u_component_message_handler_medman.parse_csv:0164", "A field length exceeds maximum number of characters,string PARSING FAILED for (" + is_stg + ", " + string(li_value_max_len) + ")",4)
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
		mylog.log(this, "u_component_message_handler_medman.parse_csv:0176", "Number of fields in record " + string(li_ctr) + " exceeds the maximum of " + string(li_max_fields) + " PARSING FAILED for (" + is_stg + ", " + + ")",4)
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
	mylog.log(this, "u_component_message_handler_medman.parse_csv:0195", "None of the fields in record contains an entry, string PARSING FAILED for (" + is_stg + ", " + + ")",4)
	RETURN -1	
END IF

RETURN 1

end function

protected function integer xx_handle_message ();/*
Function Name:		xx_handle_message for u_component_message_handler_medman
Date Begun:			December 11, 1998
Programmer:			George E. Snead
Purpose:				Process incoming Encounter Messages from the Medical Manager
						billing program.  Entries will be made into the x_MedMan_Arrived
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

boolean	lb_sts

integer	li_message_id
integer	li_sts
integer	li_sts_stg
integer	i,j

long 		ll_str_len


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

blob lblb_message
long ll_message_len
// Read the file into a local blob
li_sts = mylog.file_read(message_file, lblb_message)
if li_sts <= 0 then
	mylog.log(this, "u_component_message_handler_medman.xx_handle_message:0053", "Unable to find the message_file at the expected location, message id (" + message_file + ")",4)
	RETURN -1
END IF

ll_message_len =  len(lblb_message) 
if ll_message_len < 1 then return 1

integer li_pos
integer li_length
integer li_strings_count
integer li_specials_count
integer li_work_count
string  ls_stg
string  ls_strings[]
string  ls_unix_return, ls_win_return, ls_null, ls_newline, ls_carriage_return, ls_formfeed
string  ls_special_char
string  ls_specials[] 
string  ls_work_strings[]

ls_unix_return = "~h0A"
ls_win_return = "~013"
setnull(ls_null)
ls_newline = "~n"
ls_carriage_return = "~r"
ls_formfeed = "~f"

ls_stg = f_blob_to_string(lblb_message)
IF (ls_stg = "" or isnull(ls_stg)) THEN 
	mylog.log(this, "u_component_message_handler_medman.xx_handle_message:0081", "the message_file has no message, message id (" + message_file + ")",4)
	RETURN -1
END IF
ll_str_len = len(ls_stg)
if ll_str_len = 0 THEN 
	mylog.log(this, "u_component_message_handler_medman.xx_handle_message:0086", "the message_file has no message, message id (" + message_file + ")",4)
	RETURN -1
END IF

//UNIX surprise ... if the file share path is on a unix box then the special character
//for the unix return is imbedded in the record and the record must be split into pieces.

//there can be any special character mixed in... so scan the string for these badboy characters
//and put the pieces into the string array as seperate strings.

//check for unix return
li_pos = POS(ls_stg,ls_unix_return)
if li_pos > 0 then
	i ++
	ls_specials[i] = ls_unix_return
end if

//check for win return
li_pos = POS(ls_stg,ls_win_return)
if li_pos > 0 then
	i ++
	ls_specials[i] = ls_win_return
end if

//check for newline
li_pos = POS(ls_stg,ls_newline)
if li_pos > 0 then
	i ++
	ls_specials[i] = ls_newline
end if

//check for null
li_pos = POS(ls_stg,ls_null)
if li_pos > 0 then
	i ++
	ls_specials[i] = ls_null
end if
	
//check for carriage return
li_pos = POS(ls_stg,ls_carriage_return)
if li_pos > 0 then
	i ++
	ls_specials[i] = ls_carriage_return
end if

//check for formfeed
li_pos = POS(ls_stg,ls_formfeed)
if li_pos > 0 then
	i ++
	ls_specials[i] = ls_formfeed
end if

if i > 0 then
	li_specials_count = i
else	
	is_stg = ls_stg
	return parse_message()
end if

ls_special_char = ls_specials[1]	
Do while ll_str_len > 0
	li_pos = POS(ls_stg,ls_special_char)
	if li_pos > 0 then
		if li_pos = 1 then
			if li_pos < ll_str_len then
				ls_stg = mid(ls_stg,li_pos + 1)
			else
				ls_stg = ''
			end if	
		else	
			if li_pos < ll_str_len then 
				li_strings_count ++
				ls_strings[li_strings_count] = mid(ls_stg,1,li_pos - 1)
				ls_stg = mid(ls_stg,li_pos + 1)
			else
				li_strings_count ++
				ls_strings[li_strings_count] = mid(ls_stg,1,li_pos - 1)
				ls_stg = ''
			end if	
		end if
	end if
	if ls_stg = '' then 
		ll_str_len = 0 
	else	
		ll_str_len = len(ls_stg)
	end if
LOOP	

if li_strings_count = 0 then
		mylog.log(this, "u_component_message_handler_medman.xx_handle_message:0175", "the message_file has no message, message id (" + message_file + ")",4)
	RETURN -1
END IF

if li_specials_count> 1 then
//now check each string in the array for the other special characters
//if found then split the string again at the special character
	i = 1
	Do
		if ls_strings[i] = '' then 
			ll_str_len = 0 
		else	
			ll_str_len = len(ls_strings[i])
		end if	
		Do while ll_str_len > 0
			for j = 2 to li_specials_count
				ls_special_char = ls_specials[j]	
				ls_stg = ls_strings[i]
				li_pos = POS(ls_stg,ls_special_char)
				if li_pos > 0 then
					lb_sts = true
					if li_pos = 1 then
						if li_pos < ll_str_len then
							ls_strings[li_strings_count] = mid(ls_stg,li_pos + 1)
						else
							ls_strings[li_strings_count] = ''
						end if	
					else	
						if li_pos < ll_str_len then 
							li_strings_count ++
							ls_strings[i] = mid(ls_stg,1,li_pos - 1)
							ls_stg = mid(ls_stg,li_pos + 1)
							ls_strings[li_strings_count] = ls_stg
						else
							ls_strings[i] = mid(ls_stg,1,li_pos - 1)
							ls_stg = ''
						end if	
					end if
				else
					lb_sts = false
				end if
				if ls_stg = '' then 
					exit
				else	
					if lb_sts = false then
						ll_Str_len = 0
					else	
						ll_str_len = len(ls_stg)
					END IF	
				end if	
				if ll_str_len = 0 then exit
			next
		LOOP	
	i ++	
	LOOP until i > li_strings_count	
END IF

// remove dupe messages
for i = 1 to li_strings_count
	if not ls_strings[i] = '' then
		li_work_count ++
		ls_work_strings[li_work_count] = ls_strings[i]
		exit
	end if
next

if li_work_Count = 0 then return 1

for i = 2 to li_strings_count
	if not ls_strings[i] = '' then
		lb_sts = true
		for j = 1 to li_work_count
			if ls_strings[i] = ls_work_Strings[j] then
				lb_sts = false
				exit
			end if
		next
		if lb_sts then
			li_work_count ++
			ls_work_strings[li_work_count] = ls_strings[i]
		end if	
	end if
next

//finally parse the string message
for i = 1 to li_work_count
	is_stg = ls_work_Strings[i]
	li_sts =  parse_message()
next	

RETURN 1

end function

public function integer patient_guarantor ();string ls_race
date	ld_birthdate		
datetime ldt_date_of_birth
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
string fix_date
string ls_doctorid
string ls_ssn
string ls_cpr_id
string ls_office
string ls_addr1,ls_addr2,ls_city,ls_state,ls_zip
long ll_patient_id
long ll_DoctorId, ll_array_count
integer li_sts
integer li_priority
boolean lb_new_patient

// 1	05.	2.2	guar account #	A6	guar account number. Digits, possibly leading 0's
// 2	06.	2.17	guar last name	A18	guar last name
// 3	07.	2.18	guar first name	A12	guar first name
// 4	08.	2.19	guar middle initial	A1	guar middle initial
// 5 	09.	2.20	guar address	A25	guar address 1
// 6	10.	2.21	guar 2nd address	A25	guar address 2
// 7	11.	2.22	guar city	A15	guar city
// 8	12.	2.23	guar state	A3	guar state
// 9	13.	2.24	guar zip	A10	guar zip
//10	14.	2.25	guar phone	N10	guar phone1 (digits only)
//11	15.	2.26	guar work phone	N10	guar work phone (digits only)
//12	16.	2.57	guar work extension	A4	guar work extension
//13	17.	2.27	guar sex	A1	guar sex
//14	18.	2.28	guar date of birth	N8	YYYYMMDD
//15	19.	2.30	guar ss#	N9	soc sec num (digits only)
//16	20.	2.12	guar bill type	A2	billing type: digit 1:invoice 2:stmt
//17	21.	2.55	guar employment status	A3	employment status
//18	22.	2.56	guar employer name	A26	employer name
//19	23.	2.10	guar account date	N8	date of account
//20	24.	2.12	guar bill type	N2	2 digits. Char1:Bill Char2:Stmt. 0=suppress
//21	25.	2.38	guar status	N2	0=Inactive 1=Active 2-99.
//22	26.	2.47	guar class	A5	patient class
//23	27.	2.54	guar marital status	A3	marital status
//24	28.	2.45	guar ID	A15	misc guarantor ID
//25	29.	2.75	guar ID 2	A17	alternate misc guarantor ID
//26	30.	29.5	comment 1	A75	first comment
//27	31.	29.5	comment 2	A75	second comment

li_sts = parse_csv(255)
IF li_sts < 0 THEN
	mylog.log(this, "u_component_message_handler_medman.patient_guarantor:0060", "The parse_csv() function failed Aborting Appointment Creation for Message ID (" + string(message_id) + ")", 4)
	RETURN -1
END IF	
ll_array_count = UpperBound(is_array)
if (isnull(ll_array_count) or ll_array_count = -1) then 
		mylog.log(this, "u_component_message_handler_medman.patient_guarantor:0065", "The parse_csv() function failed Message ID (" + ls_billing_id + ", " + string(message_id) + ")", 4)
		RETURN -1
else 
	li_sts = ll_array_count
END IF	

IF li_sts < 27 then
	mylog.log(this, "u_component_message_handler_medman.patient_guarantor:0072", "The message is short (" + ls_billing_id + ", " + string(message_id) + ", " + string(li_sts) +  ", " + is_stg + ")", 2)
	return -1
END IF	

ls_billing_id = is_array[1] + '.0'
mylog.log(this, "u_component_message_handler_medman.patient_guarantor:0077", "The patient billing_id=" + ls_billing_id, 1)
SELECT cpr_id
INTO :ls_cpr_id
FROM p_Patient
WHERE billing_id = :ls_billing_id
USING cprdb;
if not cprdb.check() then return -1
if cprdb.sqlcode = 100 then
	setnull(ls_cpr_id)
end if

if isnull(ls_DoctorId) then
	setnull(ls_primary_provider_id)
end if

ls_last_name 	= is_array[2]
ls_first_name 	= is_array[3]
ls_middle_name	= is_array[4]
ls_addr1 = is_array[5]
ls_addr2 = is_array[6]
ls_city = is_array[7]
ls_state = is_array[8]
ls_zip = is_array[9]
ls_phone_number = is_array[10]
ls_sex			= is_array[13]
ls_marital_status = is_array[23]
if isnull(ls_phone_number) or ls_phone_number = '' then
	ls_phone_number = is_array[11] + is_array[12]
end if	

if (is_array[14] = "0" or isnull(is_array[14]) or is_array[14] = "") then
	ls_error = is_array[14]
	mylog.log(this, "u_component_message_handler_medman.patient_guarantor:0109", "birthdate error=" + ls_error + " (" + is_stg + ", " + + ")", 3)
	setnull(ldt_date_of_birth)
	setnull(ld_birthdate)
else	
	fix_date = left(is_array[14],4) + ' ' + mid(is_array[14],5,2) + ' ' + mid(is_array[14],7,2)
	if isdate(fix_date) then
		ld_birthdate = date(fix_date)
		ldt_date_of_birth = datetime(ld_birthdate)
	else
		ls_error = is_array[14]
		mylog.log(this, "u_component_message_handler_medman.patient_guarantor:0119", "birthdate error=" + ls_error + " (" + is_stg + ", " + + ")", 4)
		return -1
	end if
end if

If (IsNumber(is_array[15])) then
	ll_patient_id	= Long(is_array[15])
	ls_ssn = is_array[15]
else	
	setnull(ll_patient_id)
	setnull(ls_ssn)
end if

setnull(ls_primary_language)
setnull(ls_degree)
setnull(ls_name_prefix)
setnull(ls_name_suffix)
setnull(ls_secondary_provider_id)
setnull(li_priority)
if yamajala_rules  = "Y" then
	if isnull(ls_primary_provider_id)  or ls_primary_provider_id = '' then
		ls_primary_provider_id = default_provider
	end if
end if
if isnull(ls_cpr_id) then
	mylog.log(this, "u_component_message_handler_medman.patient_guarantor:0144", "create new patient, lname=" + ls_last_name, 1)
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
									ls_ssn &
									)
	if li_sts <= 0 then return -4
	lb_new_patient = true
end if
Update p_Patient
	Set first_name = :ls_first_name,
		middle_name = :ls_middle_name,
		last_name = :ls_last_name,
		date_of_birth = :ldt_date_of_birth,
		phone_number = :ls_phone_number,
		sex = :ls_sex,
		patient_id = :ll_patient_id,
      ssn = :ls_ssn,
		address_line_1 = :ls_addr1,
		address_line_2 = :ls_addr2,
		city = :ls_city,
		state = :ls_state,
		zip = :ls_zip
Where cpr_id = :ls_cpr_id
Using cprdb;
if not cprdb.check() then return -1

if lb_new_patient then
	if yamajala_rules = 'Y'  then
		UPDATE p_Patient
		SET office_id = :is_default_office
		WHERE cpr_id = :ls_cpr_id
		USING cprdb;
		if not cprdb.check() then return  -1
	end if	
end if

mylog.log(this, "u_component_message_handler_medman.patient_guarantor:0197", "The patient funcion complete, cpr_id=" + ls_cpr_id, 1)

return 1
end function

public function integer parse_message ();integer 	li_comma, li_quote_comma
integer 	li_start
integer 	li_length
integer 	li_pos
integer	i
integer	li_sts
integer 	li_value_max_len
string	ls_rectype
string	ls_numvalue
string	emptyarray[]

li_value_max_len = 3

if len(is_stg) = 0 THEN return -1

li_pos = pos(is_stg,"~"",1)	// Validate the 1st character is a quote
IF li_pos = 1 THEN 
	li_start = li_pos + 1		// If so, it;s OK to start
ELSE
	mylog.log(this, "u_component_message_handler_medman.parse_message:0020", "The input string does not start with a quote, string PARSING FAILED for (" + is_stg + ", " + + ")",4)
	is_stg = ''
	RETURN -1
END IF

li_comma = pos(is_stg,"~",~"",li_pos)	// Be sure this is a quote,comma,quote sequence
// If a positive number is returned, then continue
IF li_comma > 0 THEN				// We're still in a valid string
	li_length = li_comma - li_start	//	Set the length of the string to get the desired characters
	
	IF li_length > li_value_max_len THEN 
		mylog.log(this, "u_component_message_handler_medman.parse_message:0031", "A field length exceeds maximum number of characters, string PARSING FAILED for (" + is_stg + ", " + string(li_value_max_len) + ")",4)
		is_stg = ''
		RETURN -1
	END IF	
	
	ls_rectype = mid(is_stg,li_start,li_length)		// Assign the currently selected value to ls_value
	is_stg = mid(is_stg,li_comma + 1)

	// go down past the reserved section
	For i = 1 to 3
		ls_numvalue = Mid(is_stg,li_start,1) //check for a numeric value without quotes
		IF not IsNumber(ls_numvalue) then
			li_quote_comma = pos(is_stg,"~",",li_pos)
			if li_quote_comma > li_comma then 
				li_comma = li_quote_comma + 1
			else
				li_comma = pos(is_stg,"~,",li_pos)
			end if	
		ELSE
			li_comma = pos(is_stg,",",li_pos)
		END IF	
	
		is_stg = mid(is_stg,li_comma + 1)
	Next	
	
	if left(is_stg,1) = "," then is_stg = mid(is_stg,2)
	is_array = emptyarray
	
	CHOOSE CASE ls_rectype
		CASE "P" 
			li_sts = medman_patient()
		CASE "G"
			li_sts = patient_guarantor()
		CASE "A"
			li_sts = medman_arrived()
		CASE "I"
			li_sts = medman_insurance()
		CASE "DG"
			li_sts = medman_diagnosis()
		CASE "PC"
			li_sts = medman_procedure()
		CASE "N"
			li_sts = medman_notes()		
	END CHOOSE
	
END IF
is_stg = ''
return li_sts
end function

protected function integer xx_initialize ();string ls_temp, ls_temp2,ls_siblings_phone

 SELECT c_Component_Attribute.value  
    INTO :ls_temp
    FROM c_Component_Attribute  
   WHERE ( c_Component_Attribute.component_id = 'MEDMAN_SCHED' ) AND  
         ( c_Component_Attribute.attribute = 'FacilityId' )  using cprdb  ;
			
	if not cprdb.check() then
		return -1
	end if

if isnull(ls_temp) or ls_temp = "" then
	mylog.log(this, "u_component_message_handler_medman.xx_initialize:0014", "ERROR: No Schedule Facility ID Specified.", 4)
	return 1
end if

string ls_facilitycode

string ls_office
int li_count = 0
int thisnull
boolean lb_loop
long ll_pos

for li_count = 1 to ii_office_count
	is_offices[li_count] = ""
next

ll_pos = Pos(ls_temp,",")
ii_office_count = 1
do while ll_pos > 0
	ls_temp2 = trim(left(ls_temp, ll_pos - 1))
		is_offices[ii_office_count] = ls_temp2
		ii_office_count ++
	ls_temp = mid(ls_temp,ll_pos + 1)
	ll_pos = Pos(ls_temp,",")
loop

is_offices[ii_office_count] = ls_temp

if isnull(is_offices[1]) or is_offices[1] = "" then
	mylog.log(this, "u_component_message_handler_medman.xx_initialize:0043", "ERROR: Schedule Facility not entered.", 4)
	ii_office_count = 0
	return -1
end if	

for li_count = 1 to ii_office_count
	mylog.log(this, "u_component_message_handler_medman.xx_initialize:0049", " schedule facility=" + is_offices[li_count],2)
next	

DECLARE lc_facilitycursor CURSOR FOR  
  		SELECT c_Office.office_id
    	FROM c_Office using cprdb ;
	Open lc_facilitycursor;
	if not cprdb.check() then return -1
	Fetch lc_facilitycursor into 
			:is_default_office;
	if not cprdb.check() then return -1
	CLOSE lc_facilitycursor;

setnull(northampton_rules)
get_attribute("northampton_rules", northampton_rules)
if isnull(northampton_rules) then northampton_rules = "N"

setnull(yamajala_rules)
get_attribute("yamajala_rules", yamajala_rules)
if isnull(yamajala_rules) then yamajala_rules = "N"

get_attribute("default_provider_id",default_provider)
if isnull(default_provider) or default_provider = '' then 
	setnull(default_provider)
end if
get_attribute("default_facility",default_facility)
if isnull(default_facility) or len(default_facility) = 0 then 
	setnull(default_facility)
end if

get_attribute("update_siblings_phone_from_guarantor",ls_siblings_phone)
if isnull(ls_siblings_phone) or ls_siblings_phone = '' then 
	siblings_phone = false
else
	if upper(left(ls_siblings_phone,1))="T" or upper(left(ls_siblings_phone,1))="Y" then
		siblings_phone = true
	else
		siblings_phone = false
	end if
end if

set_timer() 
return 1
end function

protected function integer medman_insurance ();long ll_billing_code, ll_array_count
string ls_insurance_id
string ls_insurance_type
string ls_name
string ls_allocation
string ls_cpr_id

//1	05.	10.2	ins plan #	N5	insurance plan # (0=no policy)
//2	06.	10.3	plan name	A25	plan name
//3	07.	10.4	plan attention	A25	plan attention
//4	08.	10.5	plan address	A25	plan address
//5	09.	10.6	plan city	A15	plan city
//6	10.	10.7	plan state	A3	plan state
//7	11.	10.8	plan zip	A10	plan zip
//8	12.	10.9	plan phone	N10	plan phone
//9	13.	10.66	plan phone extension	A4	plan phone extension
//10	14.	10.47	plan fax	N10	plan fax phone number
//11	15.	10.73	plan fax extension	A4	plan fax extension
//12	16.	10.48	plan eligibility phone	N10	plan eligibility phone number
//13	17.	10.74	plan eligibility extension	A4	plan eligibility extension
//14	18.	10.65	plan authorization phone	N10	plan authorization phone number
//15	19.	10.75	plan authorization extension	A4	plan authorization extension
//16	20.	10.27	plan govt flag	N1	plan medicare or medicaid flag
//17	21.	10.42	plan code	A6	plan code
//18	22.	10.18	plan class	A5	plan class
//19	23.	10.49	plan assignment	A1	default assignment for plan (Y/N)
//20	24.	10.32	plan carrier code	A6	plan carrier code
//21	25.	81.3	carrier description	A25	carrier description

//	Call the parsing function to put the comma separated values into ls_array[]
integer li_sts
li_sts = parse_csv(255)
IF li_sts < 0 THEN
		mylog.log(this, "u_component_message_handler_medman.medman_insurance:0034", "The parse_csv() function failed Aborting Appointment Creation for Message ID (" + string(message_id) + ")", 4)
		RETURN -1
END IF	
ll_array_count = UpperBound(is_array)
if (isnull(ll_array_count) or ll_array_count = -1) then 
		mylog.log(this, "u_component_message_handler_medman.medman_insurance:0039", "The parse_csv() function failed Message ID ("+ string(message_id) + ")", 4)
		RETURN -1
else 
	li_sts = ll_array_count
END IF	

if isnull(is_array[1]) or is_array[1] = "" then return -1
ls_insurance_id = is_array[1]
if li_sts >= 21 then
	ls_insurance_type = is_array[21]
end if	
ls_name = is_array[2]
if ls_insurance_type = '' then
	if upper(trim(ls_name)) = 'MEDICARE' then 
		ls_insurance_type = 'MEDICARE'
	elseif upper(trim(ls_name)) = 'MEDICAID' then
		ls_insurance_type = 'MEDICAID'
	else
		ls_insurance_type = 'STANDARDPOS'
	end if
end if	
ls_insurance_type = left(ls_insurance_type,24)
ls_name = left(ls_name,80)
ls_insurance_id = left(ls_insurance_id,24)

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
		set name = :ls_name
		WHERE authority_id = :ls_insurance_id
		USING cprdb;
		if not cprdb.check() then return -1
	end if
	
mylog.log(this, "u_component_message_handler_medman.medman_insurance:0096", ls_insurance_id + "," + ls_name + "," + ls_insurance_type,2)
return 1
end function

protected function integer medman_patient ();string ls_race
date	ld_birthdate		
datetime ldt_date_of_birth
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
string fix_date
string ls_doctorid
string ls_ssn
string ls_cpr_id
string ls_office
long ll_patient_id
long ll_null
long ll_DoctorId, ll_array_count
integer li_sts
integer li_priority

string  ls_gaddr_1,ls_gaddr_2,ls_gstate,ls_gzip,ls_gcity,ls_gbilling_id,ls_gphone_number

boolean lb_new_patient
//1	05.	2.2	pat account	A6	pat Account Number.
//2	06.	7.2	pat dependent #	N2	0=Guarantor; 1-99: dependent
//3	07.	2.16/7.37	pat doctor #	N3	pat doctor
//4	08.	2.17/7.8	pat last name	A18	pat last name
//5	09.	2.18/7.4	pat first name	A12	pat first name
//6	10.	2.19/7.15	pat middle initial	A1	pat middle initial
//7	11.	2.27/7.6	pat sex	A1	pat sex
//8	12.	2.28/7.5	pat date of birth	N8	YYYYMMDD
//9	13.	2.30/7.16	pat ss#	N9	soc sec num (digits only)
//10	14.	2.54/7.21	pat marital status	A3	(M)arried, (S)ingle, (O)ther. Free-form or blank
//11	15.	2.55/7.22	pat employment status	A3	(E)mployed, Student:(F)ullTime,(P)artTime,blank
//12	16.	2.45/7.9	pat id	A15	patient id
//13	17.	2.75/7.39	pat id 2	A17	patient  alternate id
//14	18.	2.10/7.42	pat date	N9	Date became patient
//15	19.	2.81/7.43	pat race	A2	Free-form
//16	20.	2.77/7.40	relation to ipr	A7	pat relation to insured party (1 char/policy)
//17	21.	8.2	ref doctor #	N4	Referring doctor # (0=none)
//18	22.	8.19	UPIN #	A15	Ref Dr UPIN #
//19	23.	2.60/7.23	1st Policy Plan #	N5	Primary Policy
//20	24.	2.61/7.24	1st Policy Dep #	N2	Primary Policyholder Dependent #
//21	25.	2.62/7.25	2nd Policy Plan #	N5	Second Policy
//22	26.	2.63/7.26	2nd Policy Dep #	N2	Second Policyholder Dependent #
//23	27.	2.64/7.27	3rd Policy Plan #	N5	Third Policy
//24	28.	2.65/7.28	3rd Policy Dep #	N2	Third Policyholder Dependent #
//25	29.	2.66/7.29	4th Policy Plan #	N5	Fourth Policy
//26	30.	2.67/7.30	4th Policy Dep #	N2	Fourth Policyholder Dependent #
//27	31.	2.68/7.31	5th Policy Plan #	N5	Fifth Policy
//28	32.	2.69/7.32	5th Policy Dep #	N2	Fifth Policyholder Dependent #
//29	33.	2.70/7.33	6thPolicy Plan #	N5	Sixth Policy
//30	34.	2.71/7.34	6th Policy Dep #	N2	Sixth Policyholder Dependent #
//31	35.	2.72/7.35	7th Policy Plan #	N5	Seventh Policy
//32	36.	2.73/7.36	7th Policy Dep #	N2	Seventh Policyholder Dependent #
//33	37.	29.5	comment 1	A75	first comment
//34	38	   29.5	comment 2	A75	second comment
// reserved
li_sts = parse_csv(255)
IF li_sts < 0 THEN
	mylog.log(this, "u_component_message_handler_medman.medman_patient:0069", "The parse_csv() function failed Aborting Appointment Creation for Message ID (" + string(message_id) + ")", 4)
	RETURN -1
END IF	
ll_array_count = UpperBound(is_array)
if (isnull(ll_array_count) or ll_array_count = -1) then 
		mylog.log(this, "u_component_message_handler_medman.medman_patient:0074", "The parse_csv() function failed Message ID (" + ls_billing_id + ", " + string(message_id) + ")", 4)
		RETURN -1
else 
	li_sts = ll_array_count
END IF	

IF li_sts < 19 then
	mylog.log(this, "u_component_message_handler_medman.medman_patient:0081", "The message is short (" + ls_billing_id + ", " + string(message_id) + ", " + string(li_sts) +  ", " + is_stg + ")", 2)
	return -1
END IF	

ls_billing_id = is_array[1] + "." + is_array[2] 
ls_gbilling_id = is_array[1] + ".0" // gurantor

mylog.log(this, "u_component_message_handler_medman.medman_patient:0088", "The patient billing_id=" + ls_billing_id, 1)
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

ls_doctorid = is_array[3]
If (ISNumber(is_array[3])) then
	ll_DoctorId = long(is_array[3])
else
	setnull(ll_DoctorId)
END IF	

if isnull(ls_DoctorId) then
	setnull(ls_primary_provider_id)
else
	SELECT user_id
	INTO :ls_primary_provider_id
	FROM c_User
	WHERE billing_id = :ls_DoctorId
	and user_status = 'OK'
	USING cprdb;
	if not cprdb.check() then return -1
	if cprdb.sqlcode = 100 then
		setnull(ls_primary_provider_id)
	end if
end if

if yamajala_rules  = "Y" then
	if isnull(ls_primary_provider_id)  or ls_primary_provider_id = '' then
		ls_primary_provider_id = default_provider
	end if
end if

ls_last_name 	= is_array[4]
ls_first_name 	= is_array[5]
ls_middle_name	= is_array[6]
ls_sex			= is_array[7]

if (is_array[8] = "0" or isnull(is_array[8]) or is_array[8] = "") then
	ls_error = is_array[8]
	mylog.log(this, "u_component_message_handler_medman.medman_patient:0135", "birthdate error=" + ls_error + " (" + is_stg + ", " + + ")", 3)
	setnull(ldt_date_of_birth)
	setnull(ld_birthdate)
else	
	fix_date = left(is_array[8],4) + ' ' + mid(is_array[8],5,2) + ' ' + mid(is_array[8],7,2)
	if isdate(fix_date) then
		ld_birthdate = date(fix_date)
		ldt_date_of_birth = datetime(ld_birthdate)
	else
		ls_error = is_array[8]
		mylog.log(this, "u_component_message_handler_medman.medman_patient:0145", "birthdate error=" + ls_error + " (" + is_stg + ", " + + ")", 4)
		return -1
	end if
end if
setnull(ls_ssn)
If (IsNumber(is_array[9])) then
	ll_patient_id	= Long(is_array[9])
	ls_ssn = is_array[9]
elseif (ISNumber(is_array[12])) then 	
		ll_patient_id	= Long(is_array[12])
elseif (ISNumber(is_array[13])) then 	
		ll_patient_id	= Long(is_array[13])		
else
	setnull(ll_patient_id)
end if

ll_null = ll_patient_id
ls_marital_status = is_array[10]
ls_race	= is_array[15]

setnull(ls_phone_number)
setnull(ls_primary_language)
setnull(ls_degree)
setnull(ls_name_prefix)
setnull(ls_name_suffix)
setnull(ls_secondary_provider_id)
setnull(li_priority)
setnull(ll_null)
if isnull(ls_cpr_id) then
	mylog.log(this, "u_component_message_handler_medman.medman_patient:0174", "create new patient, lname=" + ls_last_name, 1)
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
	lb_new_patient = true
else
	UPDATE p_Patient
	SET	name_prefix = :ls_name_prefix,
		first_name = :ls_first_name,
		middle_name = :ls_middle_name,
		last_name = :ls_last_name,
		name_suffix = :ls_name_suffix,
		date_of_birth = :ldt_date_of_birth,
		sex = :ls_sex,
		marital_status = :ls_marital_status,
		race = :ls_race,
		patient_id = :ll_patient_id,
		ssn = :ls_ssn
	WHERE cpr_id = :ls_cpr_id
	USING cprdb;
	if not cprdb.check() then return -1
	if cprdb.sqlcode = 100 then return -5
end if
if lb_new_patient then
	if yamajala_rules = 'Y'  then
		UPDATE p_Patient
		SET office_id = :is_default_office
		WHERE cpr_id = :ls_cpr_id
		USING cprdb;
		if not cprdb.check() then return  -1
	end if	
end if

// get the dependent ph & add from guarantor
if siblings_phone then
	SELECT phone_number,
			address_line_1,
			address_line_2,
			city,
			state,
			zip
	INTO :ls_gphone_number,
		:ls_gaddr_1,
		:ls_gaddr_2,
		:ls_gcity,
		:ls_gstate,
		:ls_gzip
	FROM p_Patient
	WHERE billing_id = :ls_gbilling_id
	using cprdb;

	if not tf_check() then return -1
	
	Update p_patient
		set phone_number = :ls_gphone_number,
		address_line_1 = :ls_gaddr_1,
		address_line_2 = :ls_gaddr_2,
		city = :ls_gcity,
		state = :ls_gstate,
		zip = :ls_gzip
	where cpr_id = :ls_cpr_id
	using cprdb;
end if

mylog.log(this, "u_component_message_handler_medman.medman_patient:0256", "The patient funcion complete, cpr_id=" + ls_cpr_id, 2)

string ls_insurance_id
string ls_allocation
long ll_count
integer i
setnull(ls_allocation)

ls_insurance_id = is_array[19]
if isnull(ls_insurance_id) or ls_insurance_id = '' or ls_insurance_id = '0' then return 1

SELECT count(authority_id) into :ll_count
	FROM c_Authority
	WHERE authority_id = :ls_insurance_id
	USING cprdb;
	if not cprdb.check() then return 1
if ll_count = 0 then 
	mylog.log(this, "u_component_message_handler_medman.medman_patient:0273", "The patient insurance plan " +  ls_insurance_id + " is missing for " + ls_cpr_id, 4)
	return 1
end if

if not lb_new_patient then
	DELETE p_Patient_Authority
	WHERE cpr_id = :ls_cpr_id
	USING cprdb;
	if not cprdb.check() then return -1	
end if

i = 1
setnull(ls_allocation)
	
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
           dbo.get_client_datetime(),
           :system_user_id,
			  :system_user_id)		
			USING cprdb;
	if not cprdb.check() then return -1
	
ls_insurance_id = is_array[21]
if isnull(ls_insurance_id) or ls_insurance_id = '' or ls_insurance_id = '0' then return 1
SELECT count(authority_id) into :ll_count
	FROM c_Authority
	WHERE authority_id = :ls_insurance_id
	USING cprdb;
	if not cprdb.check() then return 1
if ll_count = 0 then 
	mylog.log(this, "u_component_message_handler_medman.medman_patient:0315", "The patient insurance plan " +  ls_insurance_id + "is missing for " + ls_cpr_id, 4)
	return 1
end if

i = 2
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
           dbo.get_client_datetime(),
           :system_user_id,
			  :system_user_id)		
			USING cprdb;

	if not cprdb.check() then return -1

ls_insurance_id = is_array[23]
if isnull(ls_insurance_id) or ls_insurance_id = '' or ls_insurance_id = '0' then return 1
SELECT count(authority_id) into :ll_count
	FROM c_Authority
	WHERE authority_id = :ls_insurance_id
	USING cprdb;
	if not cprdb.check() then return 1
if ll_count = 0 then 
	mylog.log(this, "u_component_message_handler_medman.medman_patient:0349", "The patient insurance plan " +  ls_insurance_id + "is missing for " + ls_cpr_id, 4)
	return 1
end if

i = 3
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
           dbo.get_client_datetime(),
           :system_user_id,
			  :system_user_id)		
			USING cprdb;
	if not cprdb.check() then return -1
return 1
end function

protected function integer medman_arrived ();datetime	ldt_encounter_date_time
datetime	ldt_check_date_time
long		ll_encounter_billing_id
long     ll_count
integer	li_sts, i
integer	li_message_id
string	ls_billing_id
string   ls_check_billing_id 
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
string 	ls_doctorid
string	ls_facilityid
string 	ls_special_phone
string	fix_date
string   ls_checkin_time 
string 	ls_check_Date
string   ls_encounter 
string   ls_hours
string   ls_minutes
long 		ll_DoctorId, ll_array_count
boolean  lb_noappt_type
boolean  lb_facilityfound

string ls_thisdatetime
date ld_thisdate, ld_scheduledate
date ld_medman_date
datetime ldt_datetimebefore, ldt_datetimeafter,ld_scheduledatetime, ldt_beginofdate
time lt_thistime, lt_minbefore, lt_minafter, lt_scheduletime, lt_begin_time
time lt_arrival_time

ls_thisdatetime = string(today(),"yyyy/mm/dd hh:mm:ss")
ld_thisdate = Date(left(ls_thisdatetime,10))
lt_thistime = Time(Mid(ls_thisdatetime,12))

li_message_id = message_id
setnull(ls_attending_doctor)
ldt_encounter_date_time = datetime(today(),now())
ld_scheduledatetime = ldt_encounter_date_time

//1 	05.	15.2	appt account #	A6	appt account # ("******" if write-in)
//2 	06.	15.3	appt dep #	N2	appt dep #
//3 	07.	15.4	appt date	N8	appt date
//4 	08.	15.5	appt dr slot #	N5	format: ###.#.
//5 	09.	15.6	appt room slot #	N5	format: ###.#
//6 	10.	15.7	appt time	A5	format: hh.mm
//7 	11.	15.8	appt reason #	N3	neg reasons are for reserved appts
//8 	12.	16.3	appt reason description	A25	appt reason description
//9 	13.	16.7	appt reason class	A2	appt reason class
//10 	14.	15.9	appt dr	N3	appt dr #
//11	15.	15.12	appt room #	N3	appt room #
//12	16.	15.10	appt len	N3	(in slots; negative if slot extension)
//13	17.	15.11	appt special phone	N10	appt special phone
//14	18.	15.13	appt date entered	N8	appt date entered
//15	19.	15.15	appt for whom	A19	name (most relevant for write-in appts)
//16	20.	15.16	appt unique	A7	base 36 - version 9 only
//17	21.	15.18	appt code	A4	appt code - version 9 only
//18	22.	15.19	appt operator	N3	(who made the appt)
//19	23.	15.20	appt AM/PM indicator	A1	A=AM, P=PM - version 9 only
//20	24.	15.22	appt location	A2	version 9 only
//21	25.	15.24	appt case number	A6	ver 9 - case mgmt number - base 36
//22	26.	29.5	appt comment 1	A75	appt comment 1
//23	27.	29.5	appt comment 2	A75	appt comment 2
//24	28				appt checkin time (hh:mm)
//25  29.	34.13	Encounter #	A8	For Arrivals
// the desired facility code for Encounter Pro needs to go in the "Appt Code" field when scheduling an appt.
// an arrival message also has a time stamped.


//	Call the parsing function to put the comma separated values into ls_array[]
li_sts = parse_csv(255)
IF li_sts < 0 THEN
		mylog.log(this, "u_component_message_handler_medman.medman_arrived:0080", "The parse_csv() function failed Aborting Appointment Creation for Billing ID, Message ID (" + ls_billing_id + ", " + string(message_id) + ")", 4)
		RETURN -1
END IF	
ll_array_count = UpperBound(is_array)
if (isnull(ll_array_count) or ll_array_count = -1) then 
		mylog.log(this, "u_component_message_handler_medman.medman_arrived:0085", "The parse_csv() function failed Message ID (" + ls_billing_id + ", " + string(message_id) + ")", 4)
		RETURN -1
else 
	li_sts = ll_array_count
	IF li_sts < 24 then
		mylog.log(this, "u_component_message_handler_medman.medman_arrived:0090", "The message is short (" + ls_billing_id + ", " + string(message_id) + ", " + string(li_sts) +  ", " + is_stg + ")", 2)
		return -1
	END IF	
END IF	

if li_sts = 25 then
	ls_encounter = is_array[25]
	if ls_encounter = '' then setnull(ls_encounter)
else
	setnull(ls_encounter)
end if	

// If this is a write-in then reject
if is_array[1] = "******" then
	mylog.log(this, "u_component_message_handler_medman.medman_arrived:0104", "Write IN -- Reject (" + ls_billing_id + ", " + string(message_id) + ")", 4)
	RETURN 1
end if	

//special for northampton
//If there is no checkin time ... then this is a schedule... ignore.
ls_checkin_time = is_array[24]
if northampton_rules = "Y" Then
	If Isnull(ls_checkin_time) or ls_checkin_time = "" then
		mylog.log(this, "u_component_message_handler_medman.medman_arrived:0113", "No checkin Time not provided, Message ID (" + ls_billing_id + ", " + string(message_id) + ")",2)
		return 1
	END IF
END IF	

//check for date supplied in appt date
ls_check_date = is_array[3]
If ls_check_date = "0" or isnull(ls_check_date) or ls_check_date = "" then
	mylog.log(this, "u_component_message_handler_medman.medman_arrived:0121", "Date of arrival not supplied (" + ls_billing_id + ", " + string(message_id) + ")", 2)
	RETURN 1
End IF
If IsDate(ls_check_date) then
	if today() > Date(ls_check_date) THEN
		mylog.log(this, "u_component_message_handler_medman.medman_arrived:0126", "Date of arrival not today (" + ls_billing_id + ", " + string(message_id) + ", " + ls_check_date + ")", 2)
		RETURN 1
	end if
	ld_medman_date = date(ls_check_date)
else
	fix_date = left(ls_check_date,4) + ' ' + mid(ls_check_date,5,2) + ' ' + mid(ls_check_date,7,2)
	if isdate(fix_date) then
		if today() > Date(fix_date) THEN
			mylog.log(this, "u_component_message_handler_medman.medman_arrived:0134", "Date of arrival not today (" + ls_billing_id + ", " + string(message_id) + ", " + ls_check_date + ")", 2)
			RETURN 1
		end if
		ld_medman_date = date(fix_date)
	else	
		mylog.log(this, "u_component_message_handler_medman.medman_arrived:0139", "Date of arrival not valid (" + ls_billing_id + ", " + string(message_id) + ", " + ls_check_date +")", 2)
		RETURN 1	
	end if	
end if
If Isnull(ls_checkin_time) or ls_checkin_time = "" then
	lt_arrival_time = now()
else
	ls_hours = left(ls_checkin_time,POS(ls_checkin_time,":") - 1)
	ls_minutes = mid(ls_checkin_time,POS(ls_checkin_time,":") + 1)
	lt_arrival_time = time(integer(ls_hours),integer(ls_minutes),0)
end if

ld_scheduledatetime = datetime(ld_medman_date,lt_arrival_time)
//	Populate variables with the array contents
ls_billing_id = is_array[1] + "." + is_array[2]
ls_check_billing_id = is_array[1] + is_array[2]
	
SELECT 	cpr_id
      ,primary_provider_id
INTO		:ls_cprid
        ,:ls_patient_doctor  
FROM		p_Patient
WHERE		p_Patient.billing_id = :ls_billing_id
and patient_status = 'ACTIVE'
USING		cprdb;
IF NOT cprdb.check() THEN RETURN -1
IF cprdb.sqlcode = 100 THEN
	mylog.log(this, "u_component_message_handler_medman.medman_arrived:0166", "Unable to retrieve a CPR_ID to match the Billing_ID..Aborting Appointment Creation for Billing ID, Message ID (" + ls_billing_id + ", " + string(message_id) + ")", 2)
	RETURN 1
END IF		

ls_appointment_type = is_array[7]
lb_noappt_type = false
if isnull(ls_appointment_type) or ls_appointment_type = "" then
	setnull(ls_encounter_type)
	setnull(ls_new_flag)
	mylog.log(this, "u_component_message_handler_medman.medman_arrived:0175", "AppointmentType not provided (" + ls_billing_id + ", " + string(message_id) + ")", 2)
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
if isnull(ls_new_flag) then
	ls_comment2 = 'N'
	ls_encounter_type = get_attribute("default_encounter_type")
	if isnull(ls_encounter_type) then ls_encounter_type = "SICK"
else
	ls_comment2 = ls_new_flag
end if

ls_doctorid = is_array[10]
If (ISNumber(is_array[10])) then
	ll_DoctorId = long(is_array[10])
else
	setnull(ll_DoctorId)
	mylog.log(this, "u_component_message_handler_medman.medman_arrived:0219", "Numeric DoctorId not provided (" + ls_billing_id + ", " + string(message_id) + ", " + ls_doctorid  +")", 2)
END IF	

//Special for northampton ...rules
//do not use the booked doctor for the patient checkin assigned doc
//... use the primary doc and if no primary doc then use the generic doc
//... except for nurse visits then use the nurse visit code if no primary doc
//use the booked doc to determine the facility code...
//this is supposed to be temporary until they get facility into med mgr
//range 101 to 107 --- northhampton
//range 121 to --- amherst

//the following is temporarly for northhampton until
//they fix the facility codes for checkin at northampton

if yamajala_rules  = 'Y' then 
	ls_facilityid = is_offices[1]
else
	ls_facilityid = is_array[20]
	if northampton_rules = "N" Then 
		If Isnull(ls_facilityid) or ls_facilityid = "" then
			if ii_office_count = 1 then
				ls_facilityid = is_offices[1]
			else
				mylog.log(this, "u_component_message_handler_medman.medman_arrived:0243", "facility is required for multi-office practices, messge rejected (" + ls_billing_id + ", " + string(message_id) + ")", 4)
				return 1
			end if
		else
			lb_facilityfound = false
			for i = 1 to ii_office_count
				if ls_facilityid = is_offices[i] then lb_facilityfound = true
			next	
			if lb_facilityfound = false then
				ls_facilityid = is_offices[1]
			end if	
		end if	
	end if	
end if

setnull(ls_primary_provider_id)
if northampton_rules = "Y" Then
	if isnull(ll_doctorId) or ls_DoctorId = "0" then
		ls_primary_provider_id = ls_patient_doctor
		if Isnull(ls_facilityid) or ls_facilityid = "" then
			ls_facilityid = '1'
		end if	
	else
		if ll_doctorid < 121 then 
			ls_facilityid = '1'
		else
			ls_facilityid = '2'
		end if
	end if	
//end of special rules for northampton
else
//the following is for regular processing
	if isnull(ls_DoctorId) or ls_DoctorId = "0" then
		setnull(ls_primary_provider_id)
	else
		SELECT user_id
		INTO :ls_primary_provider_id
		FROM c_User
		WHERE billing_id = :ls_DoctorId
		and user_status = 'OK'
		USING cprdb;
		if not cprdb.check() then return -1
		if cprdb.sqlcode = 100 then
			setnull(ls_primary_provider_id)
		end if
	end if
end if

if isnull(ls_primary_provider_id) then
	ls_primary_provider_id = ls_attending_doctor
	if isnull(ls_primary_provider_id) or ls_primary_provider_id = "0" then
		ls_primary_provider_id = ls_patient_doctor
	end if	
END IF	

string ls_error

//default the doctor id for a new patient with no assigned doctor
if northampton_rules = "Y" Then
	If Isnull(ls_primary_provider_id) or ls_primary_provider_id = "0" then
	// if nurse visit then assign the nurse code	
		if ls_attending_doctor = '!NURSE' then
			ls_primary_provider_id = '!NURSE'
		else
			ls_primary_provider_id = '!PHYSICIAN'
		end if	
	End if
end if	

//the following is for regular processing
if northampton_rules = "N" Then
	If Isnull(ls_primary_provider_id) or ls_primary_provider_id = "0" then
		ls_primary_provider_id = '!PHYSICIAN'
	else
		if ls_attending_doctor = '!NURSE' then
			ls_primary_provider_id = '!NURSE'
		end if	
	end if	
end if

If Isnull(ls_primary_provider_id) or ls_primary_provider_id = "0" then
	ls_error = is_array[10]
	mylog.log(this, "u_component_message_handler_medman.medman_arrived:0325", "Unable to retrieve a provider_ID to match the input provider_ID " + ls_error + " ..Aborting Appointment Creation for Billing ID, Message ID (" + ls_billing_id + ", " + string(message_id) + ")", 4)
	RETURN -1
end if

ls_check_billing_id = trim(ls_check_billing_id)
if not isnumber(ls_check_billing_id) then
	mylog.log(this, "u_component_message_handler_medman.medman_arrived:0331", "billingId not numeric, ..Aborting Appointment Creation for Message ID (" + ls_billing_id + ", " + string(message_id) + ")",4)
	RETURN -1
END IF	

ll_encounter_billing_id = long(ls_check_billing_id)

ls_chief_complaint = is_array[8]

//Special for yamajala - ignore the chief complaint, and encounter type (default to SICK, Esablished(N))
if yamajala_rules  = 'Y' then 
	ls_chief_complaint = ''
	ls_encounter_type = 'SICK'
	ls_comment2 = 'N'
end if	

//	Populate the remaining fields which need to be written to 
//	x_MedMan_Arrived

ls_status = "SCHEDULED"

//	Write a new "ARRIVED" record to the "x_MedMan_Arrived" table
//	It will be processed by the Scheduler
mylog.log(this, "u_component_message_handler_medman.medman_arrived:0353", "Schedule Date,AttendingDoctor for (" + ls_billing_id + " is ( " +string(ld_scheduledatetime,"mm/dd/yyyy hh:mm:ss") + ","+ls_primary_provider_id+")", 2)
		
			INSERT INTO 	x_MedMan_Arrived (
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
								encounter_id,
								encounter,
								new_flag,
								appointment_time)
			VALUES (
								:ls_billing_id,
								:ll_encounter_billing_id,
								:message_id,
								:ls_encounter_type,
								:ls_primary_provider_id,
								:ls_chief_complaint,
								:ls_comment2,
								:ls_cprid,
								:ldt_encounter_date_time,
								:ls_status,
								:ls_facilityid,
								null,
								:ls_encounter,
								:ls_new_flag,
								:ld_scheduledatetime);
	
			IF NOT cprdb.check() THEN 
				// The new entry failed
				mylog.log(this, "u_component_message_handler_medman.medman_arrived:0390", "Unable write a record to x_MedMan_Arrived...Aborting Appointment Creation for Billing ID, Message ID (" + ls_billing_id + ", " + string(li_message_id) + ")", 4)
				RETURN 1								
			END IF
		
return 1
end function

on u_component_message_handler_medman.create
call super::create
end on

on u_component_message_handler_medman.destroy
call super::destroy
end on

