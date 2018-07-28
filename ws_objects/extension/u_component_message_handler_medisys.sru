HA$PBExportHeader$u_component_message_handler_medisys.sru
forward
global type u_component_message_handler_medisys from u_component_message_handler
end type
end forward

global type u_component_message_handler_medisys from u_component_message_handler
end type
global u_component_message_handler_medisys u_component_message_handler_medisys

type variables
string is_stg, is_array[]
string is_default_facility


end variables

forward prototypes
protected function integer medisys_diagnosis ()
protected function integer medisys_notes ()
protected function integer medisys_procedure ()
protected function integer parse_csv (integer pi_max_fields)
protected function integer xx_handle_message ()
protected function integer xx_initialize ()
protected function integer medisys_insurance ()
protected function integer medisys_patient ()
protected function integer medisys_arrived ()
end prototypes

protected function integer medisys_diagnosis ();  
int li_sts
long ll_array_count
//1	05.	3.2	Diagnosis Code	A10	Diagnosis Code
//2	06.	3.3	Description	A45	Description


//	Call the parsing function to put the comma separated values into ls_array[]
li_sts = parse_csv(255)
IF li_sts < 0 THEN
		mylog.log(this, "medisys_diagnosis()", "The parse_csv() function failed Aborting Encounter Creation for Message ID (" + string(message_id) + ")", 4)
		RETURN -1
END IF
ll_array_count = UpperBound(is_array)
if (isnull(ll_array_count) or ll_array_count = -1) then 
		mylog.log(this, "medisys diagnosis()", "The parse_csv() function failed Message ID (" + string(message_id) + ")", 4)
		RETURN -1
else 
	li_sts = ll_array_count
END IF	
string ls_icd_9
boolean lb_ok
integer li_count
ls_icd_9 = is_array[1]
if is_array[1] = "" then return 1
if is_array[2] = "" then return 1

SELECT count(c_Assessment_Definition.icd_9_code )  
    INTO :li_count 
    FROM c_Assessment_Definition  
   WHERE c_Assessment_Definition.icd_9_code = :ls_icd_9 using cprdb ;
	
if not cprdb.check() then return -1	

If li_count > 1 then return 1
if li_count = 1 then
	  UPDATE c_Assessment_Definition  
     SET description = :is_array[2]
   WHERE c_Assessment_Definition.icd_9_code = :ls_icd_9  using cprdb ;
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
     SET icd_9_code = :ls_icd_9 
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
           icd_9_code,   
           billing_code,   
           billing_id,   
           status )  
  VALUES ( :ls_fix,   
           null,   
           null,   
           :is_array[2],   
           null,
			  null,
           :ls_icd_9,   
           null,   
           null,   
           null )  ;


return 1
end function

protected function integer medisys_notes ();
//1	05.	2.2	notes account #	A6	notes account #
//2	06.	7.2	notes dep #	N2	notes dep #
//3	07.	95.5	notes system	A4	notes system
//4	08.	95.6	notes type	A4	notes type
//5	09.		notes sequence #	A8	may be blank - use record order
//6	10.		notes text	A80	notes text


return 1
end function

protected function integer medisys_procedure ();int li_sts
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
		mylog.log(this, "medisys_procedure()", "The parse_csv() function failed Aborting Encounter Creation for Message ID (" + string(message_id) + ")", 4)
		RETURN -1
END IF
ll_array_count = UpperBound(is_array)
if (isnull(ll_array_count) or ll_array_count = -1) then 
		mylog.log(this, "medisys procedure()", "The parse_csv() function failed Message ID (" + string(message_id) + ")", 4)
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
	mylog.log(this, "parse_csv()", "The input string does not start with a quote, string PARSING FAILED for (" + is_stg + ", " + + ")",4)
	RETURN -1
END IF	

li_str_len = len(is_stg)
char lc_last_char
lc_last_char = Right(is_Stg,1)

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
			mylog.log(this, "parse_csv()", "A field length exceeds maximum number of characters, string PARSING FAILED for (" + is_stg + ", " + string(li_value_max_len) + ")",4)
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
			li_end = pos(is_stg,"~"",li_pos)					//	Get the location of the last quote
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
if is_array[li_array_upper] = "'" then
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
Function Name:		xx_handle_message for u_component_message_handler_medisys
Date Begun:			
Programmer:			
Purpose:			Process incoming Encounter Messages from the medisys
						billing program.  Entries will be made into the x_medisys_Arrived
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
						li_sts = medisys_patient()
					CASE "INS"
						li_sts = medisys_insurance()	
					CASE "DGN"
						li_sts = medisys_diagnosis()		
					CASE "CHK"
						li_sts = medisys_arrived()
						if li_sts < 1 then
							li_sts_stg = -1
							return li_sts
						end if	
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
		mylog.log(this, "xx_handle_message()", "Unable to close the medisys.mmi incoming transfer file...Aborting Encounter Creation for Message ID (" + string(li_message_id) + ")", 4)
		RETURN -1									
	END IF
END IF
yield()
RETURN 1

end function

protected function integer xx_initialize ();set_timer() 
return 1
end function

protected function integer medisys_insurance ();long ll_array_count
string ls_billing_id
string ls_insurance_id
string ls_insurance_type
string ls_name
string ls_allocation
string ls_cpr_id
string ls_insurance_sequence
integer i,j
setnull(ls_allocation)

//  Account #
//  Insurance Id
//  Insurance type
//  Insurance Name
//  Patient Insurance sequence

//	Call the parsing function to put the comma separated values into ls_array[]
integer li_sts
li_sts = parse_csv(255)
IF li_sts < 0 THEN
		mylog.log(this, "medisys insurance()", "The parse_csv() function failed Aborting Encounter Creation for Message ID (" + string(message_id) + ")", 4)
		RETURN -1
END IF	

ll_array_count = UpperBound(is_array)
if (isnull(ll_array_count) or ll_array_count = -1) then 
		mylog.log(this, "medisys insurance()", "The parse_csv() function failed Message ID ("+ string(message_id) + ")", 4)
		RETURN -1
else 
	li_sts = ll_array_count
END IF	

if ll_array_count < 5 then
	mylog.log(this, "medisys insurance()","Interface did not provide insurance sequence (" + is_stg + ")",2)
	return -1
end if

ls_billing_id = is_array[1]
ls_insurance_id = is_array[2]
ls_name = is_array[4]
ls_insurance_type = is_array[3]
ls_insurance_sequence = is_array[5]

SELECT cpr_id
	INTO :ls_cpr_id
	FROM p_Patient
	WHERE billing_id = :ls_billing_id
	and patient_status = 'ACTIVE'
	USING cprdb;
	if not cprdb.check() then return -1
	if cprdb.sqlcode = 100 then 
		mylog.log(this, "medisys insurance()", "Patient does not exist for  ("+ ls_billing_id + ")", 4)
		RETURN -1
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
	
	if isnumber(ls_insurance_sequence) then
		i = integer(ls_insurance_sequence)
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
return 1
	


end function

protected function integer medisys_patient ();string ls_race
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
long ll_patient_id
long ll_null
long ll_DoctorId, ll_array_count
integer li_sts
integer li_priority

//1	pat account	A4	pat Account Number.
//2	pat last name	A?	pat last name
//3	pat first name	A?	pat first name
//4	pat middle initial A1	pat middle initial
//5   	pat race? 	a1 pat race
//6	pat sex	A1	pat sex
//7	pat date of birth	N8	MMDDYYYY
//8   	pat provider code? A2
//9	pat phone	A14	(xxx) xxx-xxxx
//10	pat marital status Free-form or blank

li_sts = parse_csv(255)
IF li_sts < 0 THEN
	mylog.log(this, "medisys_patient()", "The parse_csv() function failed Aborting Encounter Creation)", 4)
	RETURN -1
END IF	

ls_billing_id = is_array[1] 
mylog.log(this, "medisys_patient()", "The patient billing_id=" + ls_billing_id, 2)
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

if isnull(ls_DoctorId) then
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
	mylog.log(this, "medisys_patient()", "birthdate error=" + ls_error + " (" + is_stg + ", " + + ")", 3)
	setnull(ldt_date_of_birth)
	setnull(ld_birthdate)
else	
	if isdate(is_array[7]) then
		ld_birthdate = date(is_array[7])
		ldt_date_of_birth = datetime(ld_birthdate)
	else
		ls_error = is_array[7]
		mylog.log(this, "medisys_patient()", "birthdate error=" + ls_error + " (" + is_stg + ", " + + ")", 4)
		setnull(ld_birthdate)
		setnull(ldt_date_of_birth)
	end if
end if

setnull(ll_patient_id)

ls_phone_number = is_array[9]
ls_marital_status = is_array[10]

setnull(ls_primary_language)
setnull(ls_degree)
setnull(ls_name_prefix)
setnull(ls_name_suffix)
setnull(ls_secondary_provider_id)
setnull(li_priority)
setnull(ls_ssn)
setnull(ll_null)
if isnull(ls_cpr_id) then
	mylog.log(this, "medisys_patient()", "create new patient, lname=" + ls_last_name, 1)
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
		marital_status = :ls_marital_status,
		race = :ls_race
	WHERE cpr_id = :ls_cpr_id
	USING cprdb;
	if not cprdb.check() then return -1
	if cprdb.sqlcode = 100 then return -5
end if
mylog.log(this, "medisys_patient()", "The patient funcion complete, cpr_id=" + ls_cpr_id, 1)

return 1
end function

protected function integer medisys_arrived ();datetime	ldt_encounter_date_time
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
string	ls_fixer
string   ls_hours
string   ls_minutes
long 		ll_DoctorId, ll_array_count
long		ll_encounter_billing_id
integer	li_encounter_facility_id
boolean  lb_noappt_type
date	   ld_medisys_date
time     lt_arrival_time
string ls_thisdatetime
date ld_thisdate, ld_scheduledate
datetime ldt_datetimebefore, ldt_datetimeafter,ld_scheduledatetime, ldt_beginofdate
time lt_thistime, lt_minbefore, lt_minafter, lt_scheduletime, lt_begin_time

ls_thisdatetime = string(today(),"yyyy/mm/dd hh:mm:ss")
ld_thisdate = Date(left(ls_thisdatetime,10))
lt_thistime = Time(Mid(ls_thisdatetime,12))

li_message_id = message_id
setnull(ls_Attending_doctor)
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
//	Call the parsing function to put the comma separated values into ls_array[]
li_sts = parse_csv(255)
IF li_sts < 0 THEN
		mylog.log(this, "medisys arrived()", "The parse_csv() function failed Aborting Encounter Creation for Billing ID, Message ID (" + ls_billing_id + ", " + string(message_id) + ")", 4)
		RETURN -1
END IF	

ldt_encounter_date_time = datetime(today(),now())
ld_scheduledatetime = ldt_encounter_date_time

//check for facility
int li_array_upper
li_array_upper = UpperBound(is_array )
if li_array_upper < 10 then
	setnull(ls_facility)
else	
	ls_facility = is_array[10]
end if	

//check for patient type
if ll_array_count = 11 then
	ls_new_flag = is_array[11]
else
	setnull(ls_new_flag)
end if	

//	Populate variables with the array contents
ls_billing_id = is_array[1] 
If isnull(ls_billing_id) or ls_billing_id = "" then
	mylog.log(this, "medisys arrived()", "Billingid not found Aborting Encounter Creation for Billing ID, Message ID (" + ls_billing_id + ", " + string(message_id) + ")", 4)
	RETURN -1
END IF	
If isnumber(ls_billing_id) then
	ll_encounter_billing_id = long(ls_billing_id)
else
	mylog.log(this, "medisys arrived()", "Billingid not numeric Aborting Encounter Creation for Billing ID, Message ID (" + ls_billing_id + ", " + string(message_id) + ")", 4)
	RETURN -1
END IF

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
	mylog.log(this, "medisys arrived()","Interface did not provide mapped encounter type (" + ls_appointment_type + ")" ,2)
end if

if isnull(is_Array[4]) then
	setnull(ls_primary_provider_id)
else
	ls_doctor_id = is_Array[4]
	SELECT user_id
	INTO :ls_primary_provider_id
	FROM c_User
	WHERE billing_id = :ls_doctor_id
	and user_status = 'OK'
	USING cprdb;
	if not cprdb.check() then return -1
	if cprdb.sqlcode = 100 then
		setnull(ls_primary_provider_id)
	end if
end if

if isnumber(is_array[8]) then
	li_message_id = integer(is_array[8])
end if

if is_array[3] = "" then
	ls_chief_complaint = is_array[9]
else
	if not (is_array[9] = "") then 
		ls_chief_complaint = is_array[3] + ", " + is_array[9]
	end if	
end if	
 
ls_comment2 = is_array[2]

if isnumber(ls_facility) then
	li_encounter_facility_id = integer(ls_facility)
end if	

ls_fixer = mid(is_array[5],5) + ' ' + mid(is_array[5],1,2) + ' ' + mid(is_array[5],3,2)
if isdate(ls_fixer) then
	ld_medisys_date = date(ls_fixer)
	ls_fixer = is_array[6]
	ls_hours = left(ls_fixer,POS(ls_fixer,":") - 1)
	ls_minutes = mid(ls_fixer,POS(ls_fixer,":") + 1)
	lt_arrival_time = time(integer(ls_hours),integer(ls_minutes),0)
	ld_scheduledatetime = datetime(ld_medisys_date,lt_arrival_time)
end if		

SELECT cpr_id,
		primary_provider_id
INTO	:ls_cprid,
		:ls_patient_doctor
FROM		p_Patient
WHERE		p_Patient.billing_id = :ls_billing_id
and patient_status = 'ACTIVE'
USING		cprdb;
IF NOT cprdb.check() THEN RETURN -1
IF cprdb.sqlcode = 100 THEN
	mylog.log(this, "medisys_arrived()", "Unable to retrieve a CPR_ID to match the Billing_ID..Aborting Encounter Creation for Billing ID, Message ID (" + ls_billing_id + ", " + string(message_id) + ")", 4)
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
	mylog.log(this, "medisys_arrived()", "Unable to retrieve a provider_ID to match the input provider_ID " + ls_error + " ..Aborting Encounter Creation for Billing ID, Message ID (" + ls_billing_id + ", " + string(message_id) + ")", 4)
	RETURN -1
End if			

ls_status = "SCHEDULED"
if isnull(ls_primary_provider_id) or len(ls_primary_provider_id) = 0 then
	ls_primary_provider_id = '!PHYSICIAN'
end if

INSERT INTO 	x_medman_Arrived (
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
	// The new entry failed
	mylog.log(this, "xx_medisys_arrived()", "Unable write a record to x_medisys_Arrived...Aborting Encounter Creation for Billing ID, Message ID (" + ls_billing_id + ", " + string(li_message_id) + ")", 4)
	RETURN -1									
END IF
	
Return 1
end function

on u_component_message_handler_medisys.create
call super::create
end on

on u_component_message_handler_medisys.destroy
call super::destroy
end on

