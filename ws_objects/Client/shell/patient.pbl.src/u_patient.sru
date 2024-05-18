$PBExportHeader$u_patient.sru
forward
global type u_patient from nonvisualobject
end type
type str_dev_item from structure within u_patient
end type
type str_dev_stage from structure within u_patient
end type
end forward

type str_dev_item from structure
    long last_encounter_id
    boolean last_accomplished
    long encounter_id
    u_attachment_list attachment_list
    boolean accomplished
    boolean exists
    boolean deleted
    boolean updated
end type

type str_dev_stage from structure
    str_dev_item item[]
end type

global type u_patient from nonvisualobject
end type
global u_patient u_patient

type variables
string address_line_1
string address_line_2
long attachment_location_id
string attachment_path
string billing_id
string city
string country
string cpr_id
datetime created
string created_by
date date_of_birth
time time_of_birth
date date_of_conception
string degree
string department
string email_address
string employeeID
string employer
string employment_status
string financial_class
string first_name
string job_description
string last_name
string maiden_name
string marital_status
string middle_name
string name_prefix
string name_suffix
string nickname
string nationality
string patient_office_id
string patient_status
string phone_number
string primary_language
string primary_provider_id
string race
string referring_provider_id
string religion
string secondary_phone_number
string secondary_provider_id
string sex
string shift
string ssn
datetime start_date
string state
datetime termination_date
string zip

// Share variables
string attachment_server
string attachment_share

// Encounter objects and variables
string encounter_bitmap = "icon018.bmp"
u_ds_patient_encounter encounters
u_str_encounter open_encounter
long open_encounter_id
datetime open_encounter_date
long patient_workplan_id

// Calculated patient data
date gaa_date_of_birth
long weeks_premature

string assessment_bitmap = "icon018.bmp"
u_ds_assessment assessments
u_ds_treatment_item treatments
u_ds_attachments attachments
u_ds_data p_Patient_Authority
u_ds_data p_Object_Security
u_ds_patient p_Patient
u_ds_data progress

boolean display_only

string context_object = "Patient"

str_access_control_list access_control_list

str_p_patient_list_item list_item[]

boolean test_patient

end variables

forward prototypes
public function boolean check_drug_allergy (string ps_drug_id)
public function boolean is_encounter_open ()
public function integer print_reports (string ps_report_type)
public function integer next_diagnosis_sequence (long pl_problem_id)
public function u_str_assessment find_assessment (long pl_problem_id)
public function u_str_assessment find_assessment (long pl_problem_id, integer pi_diagnosis_sequence)
public function boolean is_adult ()
public function string patient_user ()
public function u_str_encounter find_encounter (long pl_encounter_id)
public function u_attachment_list find_encounter_attachment_list (long pl_encounter_id)
public function long age_months ()
public function long age_years ()
public function u_component_treatment find_treatment (long pl_treatment_id)
public function integer print (string ps_report_id)
public function boolean any_allergies ()
public function integer load_assessments ()
public subroutine clear_patient ()
public function long find_encounter_billing_id (long pl_encounter_billing_id)
public function integer load_treatments ()
public function integer load_encounters ()
public function long age_days ()
public function long add_observation_result (string ps_observation_id, string ps_location, integer pi_result_sequence, datetime pdt_result_date_time)
public function long add_observation_result (long pl_observation_sequence, string ps_location, integer pi_result_sequence, datetime pdt_result_date_time)
public function integer load_attachments ()
public function integer load (string ps_cpr_id)
public function long new_encounter (string ps_office_id, string ps_encounter_type, datetime pdt_encounter_date, string ps_new_flag, string ps_encounter_description, string ps_attending_doctor, string ps_created_by, boolean pb_open_encounter)
public function integer set_property (string ps_progress_key, string ps_progress)
public function long add_observation (string ps_observation_id)
public function string get_encounter_property (long pl_encounter_id, string ps_progress_key)
public function string id_line ()
public function string id_line1 ()
public function integer load ()
public function integer modify_patient (string ps_field, string ps_value)
public function long new_encounter (str_encounter_description pstr_encounter, string ps_created_by, boolean pb_open_encounter)
public function integer load_patient ()
public function str_patient_authorities get_authorities ()
public function integer get_primary_authority (string ps_authority_type, ref str_patient_authority pstr_patient_authority)
public function integer set_encounter_property (long pl_encounter_id, string ps_progress_key, string ps_progress)
public function boolean if_condition (string ps_condition)
public function integer exit_office_old ()
public subroutine close_encounter_old ()
public function string get_property_value (string ps_property)
public function str_property_value get_property (string ps_property, str_attributes pstr_attributes)
public function integer reload ()
public function integer set_progress (string ps_progress_type, string ps_progress_key, datetime pdt_progress_date_time, string ps_progress, long pl_risk_level)
public function integer set_progress (string ps_progress_type, string ps_progress_key, string ps_progress, long pl_risk_level)
public function str_progress_list get_progress_list (string ps_context_object, long pl_object_key, string ps_progress_type, string ps_progress_key, string ps_attachments_only_flag)
public function integer set_object_progress_old (string ps_context_object, long pl_object_key, string ps_progress_type, string ps_progress_key, string ps_progress, datetime pdt_progress_date_time, long pl_risk_level, long pl_attachment_id, long pl_patient_workplan_item_id, integer pi_diagnosis_sequence, string ps_severity)
public function integer set_object_progress_old (string ps_context_object, long pl_object_key, string ps_progress_type, string ps_progress_key, string ps_progress, datetime pdt_progress_date_time, long pl_risk_level, long pl_attachment_id, long pl_patient_workplan_item_id)
public function string context_object_type (string ps_context_object, long pl_object_key)
public function string name_fml ()
public function str_access_control_list get_access_control_list (string ps_context_object, long pl_object_key, boolean pb_default_grant)
public function string address ()
public function string pretty_age ()
public subroutine calc_gaa ()
public function string address (string ps_line_delimiter)
public function long new_encounter (str_encounter_description pstr_encounter, string ps_created_by, boolean pb_open_encounter, boolean pb_order_workplan)
public function long new_encounter (string ps_office_id, string ps_encounter_type, datetime pdt_encounter_date, string ps_new_flag, string ps_encounter_description, string ps_attending_doctor, string ps_created_by, boolean pb_open_encounter, boolean pb_order_workplan)
public function string name (string ps_name_format)
public function string name ()
public subroutine chart_encounter_old ()
end prototypes

public function boolean check_drug_allergy (string ps_drug_id);// check_drug_allergy
//
// Parameters	ps_drug_id = Drug to be checked for allergic reactions
//
//	Return Value	TRUE = No allergic reactions or user overrode
//						FALSE = Allergic reactions exist and user did not override

string ls_description
string ls_allergies
string ls_comma
string ls_message
string ls_drug_description
integer li_allergy_count, li_sts
boolean lb_loop

 DECLARE lc_drug_allergies CURSOR FOR  
  SELECT c_Assessment_Definition.description
    FROM p_Assessment (nolock),   
         c_Allergy_Drug (nolock),
			c_Assessment_Definition (nolock)
   WHERE p_Assessment.cpr_id = :cpr_id
	AND	p_Assessment.assessment_id = c_Allergy_Drug.assessment_id
   AND	p_Assessment.assessment_id = c_Assessment_Definition.assessment_id
	AND	c_Allergy_Drug.drug_id = :ps_drug_id
	AND	p_Assessment.assessment_status IS NULL;

tf_begin_transaction(this, "check_drug_allergy()")

OPEN lc_drug_allergies;
if not tf_check() then return false

lb_loop = true
li_allergy_count = 0
ls_comma = ""

DO
	FETCH lc_drug_allergies INTO
		:ls_description;
	if not tf_check() then return false

	if sqlca.sqlcode = 0 and sqlca.sqlnrows > 0 then
		li_allergy_count = li_allergy_count + 1
		ls_allergies = ls_allergies + ls_comma + ls_description
		ls_comma = ", "
	else
		lb_loop = false
	end if
LOOP WHILE lb_loop

CLOSE lc_drug_allergies;

tf_commit()

if li_allergy_count = 0 then return true

li_sts = tf_get_drug_name(ps_drug_id, ls_drug_description)
if li_sts <= 0 then return false

if li_allergy_count = 1 then
	ls_message = "This patient has an allergy ("
else
	ls_message = "This patient has allergies ("
end if

ls_message = ls_message + ls_allergies + ") which may cause an adverse reaction to "
ls_message = ls_message + ls_drug_description
ls_message = ls_message + ".  Are you sure you wish to prescribe this drug?"

openwithparm(w_drug_alert, ls_message)
if message.doubleparm = 1 then
	return true
end if

return false

end function

public function boolean is_encounter_open ();if isnull(open_encounter) then return false

return true
end function

public function integer print_reports (string ps_report_type);

//if isnull(open_encounter) then return 0
//
//encounter_report.load(open_encounter)
//encounter_report.print(false)
//
//tf_begin_transaction(this, "print_reports()")
//
//UPDATE o_Patients
//SET reports_printed = "Y"
//WHERE cpr_id = :cpr_id;
//if not tf_check() then return -1
//
//tf_commit()
//
//reports_printed = "Y"

return 1


end function

public function integer next_diagnosis_sequence (long pl_problem_id);return assessments.next_diagnosis_sequence(pl_problem_id)


end function

public function u_str_assessment find_assessment (long pl_problem_id);integer li_sts
u_str_assessment luo_assessment

li_sts = assessments.assessment(luo_assessment, pl_problem_id)
if li_sts <= 0 then
	setnull(luo_assessment)
end if

return luo_assessment

end function

public function u_str_assessment find_assessment (long pl_problem_id, integer pi_diagnosis_sequence);integer li_sts
u_str_assessment luo_assessment

li_sts = assessments.assessment(luo_assessment, pl_problem_id, pi_diagnosis_sequence)
if li_sts <= 0 then
	setnull(luo_assessment)
end if

return luo_assessment

end function

public function boolean is_adult ();if isnull(date_of_birth) then return true

if date_of_birth <= relativedate(today(), -(365*18 + 4)) then
	return true
else
	return false
end if

end function

public function string patient_user ();if is_adult() then
	return "!PATIENT"
else
	return "!PARENT"
end if

end function

public function u_str_encounter find_encounter (long pl_encounter_id);u_str_encounter luo_encounter
integer li_sts

li_sts = encounters.encounter(luo_encounter, pl_encounter_id)
if li_sts <= 0 then setnull(luo_encounter)

return luo_encounter
end function

public function u_attachment_list find_encounter_attachment_list (long pl_encounter_id);/////////////////////////////////////////////////////////////////////////////////////////////////////
//	Return: Handle (u_attachment_list )
//
// Modified By:Sumathi Chinnasamy									Modified On:08/12/99
//
// Description:
//returns attachment list handle based on encounter id.
////////////////////////////////////////////////////////////////////////////////////////////////////
u_attachment_list luo_attachment_list

// returns attachment list for currently open encounter
IF pl_encounter_id = open_encounter_id THEN RETURN open_encounter.attachment_list

// returns attachment list for 'CLOSED' encounters based on encounter id
luo_attachment_list = encounters.attachment_list(pl_encounter_id)

return luo_attachment_list

end function

public function long age_months ();return f_age_months(date_of_birth, today())

end function

public function long age_years ();return f_age_years(date_of_birth, today())

end function

public function u_component_treatment find_treatment (long pl_treatment_id);integer li_sts
u_component_treatment luo_treatment

li_sts = treatments.treatment(luo_treatment, pl_treatment_id)
if li_sts <= 0 then
	setnull(luo_treatment)
end if

return luo_treatment


end function

public function integer print (string ps_report_id);///////////////////////////////////////////////////////////////////////////////////////////
//
//	Return: Integer [ -1 - Failure , 1 - success ]
//
//	Description:Add the required attribute and values and call runreport() of report
// component to add more runtime/other attributes.
//
// Created By:Sumathi Chinnasamy										Creation dt: 10/21/99
//
// Modified By:															Modified On:
////////////////////////////////////////////////////////////////////////////////////////////
string					lsa_attributes[]
string					lsa_values[]

lsa_attributes[1] = "REPORT_ID"
lsa_values[1] = ps_report_id

//return service_list.do_service(cpr_id, open_encounter_id, "REPORT", 1, lsa_attributes, lsa_values)
return 1

end function

public function boolean any_allergies ();string ls_find
long ll_row
long ll_count

ll_count = assessments.rowcount()

ls_find = "assessment_type='ALLERGY' and isnull(assessment_status)"

ll_row = assessments.find(ls_find, 1, ll_count)

if ll_row > 0 then
	return true
else
	return false
end if


end function

public function integer load_assessments ();long ll_assessment_count

ll_assessment_count = assessments.retrieve(cpr_id)
if ll_assessment_count < 0 then
	log.log(this, "u_patient.load_assessments:0005", "Error loading assessments", 4)
	return -1
end if

return 1


end function

public subroutine clear_patient ();
setnull(cpr_id)
setnull(open_encounter)


end subroutine

public function long find_encounter_billing_id (long pl_encounter_billing_id);long ll_row
long ll_encounter_id
string ls_find
long ll_count

ll_count = encounters.rowcount()

ls_find = "encounter_billing_id=" + string(pl_encounter_billing_id)

ll_row = encounters.find(ls_find, 1, ll_count)

if ll_row <= 0 then
	setnull(ll_encounter_id)
else
	ll_encounter_id = encounters.object.encounter_id[ll_row]
end if

return ll_encounter_id

end function

public function integer load_treatments ();long ll_treatment_count

ll_treatment_count = treatments.initialize(cpr_id)
if ll_treatment_count < 0 then
	log.log(this, "u_patient.load_treatments:0005", "Error loading treatments", 4)
	return -1
end if

return 1


end function

public function integer load_encounters ();long ll_count
integer li_sts

ll_count = encounters.retrieve(cpr_id)
if ll_count < 0 then
	log.log(this, "u_patient.load_encounters:0006", "Error loading appointments", 4)
	return -1
end if

return 1

end function

public function long age_days ();return f_age_days(date_of_birth, today())

end function

public function long add_observation_result (string ps_observation_id, string ps_location, integer pi_result_sequence, datetime pdt_result_date_time);long ll_observation_sequence

ll_observation_sequence = add_observation(ps_observation_id)
if ll_observation_sequence < 0 then return -1

return add_observation_result(ll_observation_sequence, &
										ps_location, &
										pi_result_sequence, &
										pdt_result_date_time )


end function

public function long add_observation_result (long pl_observation_sequence, string ps_location, integer pi_result_sequence, datetime pdt_result_date_time);long ll_treatment_id
string ls_result_value
string ls_result_unit
long ll_location_result_sequence

setnull(ll_treatment_id)
setnull(ls_result_value)
setnull(ls_result_unit)

sqlca.sp_add_patient_observation_result( &
		cpr_id, &
		pl_observation_sequence, &
		ll_treatment_id, &
		open_encounter_id, &
		ps_location, &
		pi_result_sequence, &
		pdt_result_date_time, &
		ls_result_value, &
		ls_result_unit, &
		current_user.user_id, &
		current_scribe.user_id, &
		ll_location_result_sequence)
	
if not tf_check() then return -1

return ll_location_result_sequence


end function

public function integer load_attachments ();long ll_attachment_count
integer li_sts

ll_attachment_count = attachments.retrieve(cpr_id)
if ll_attachment_count < 0 then
	log.log(this, "u_patient.load_attachments:0006", "Error loading attachments", 4)
	return -1
end if


return 1


end function

public function integer load (string ps_cpr_id);// initialize
//
// This function locks the patient and then loads the patient data
//
// Parameters:		ps_cpr_id	cpr_id of patient
//
// Returns:			-1	Failure
//						0 Successful load but could not lock patient
//						1 Success
integer li_sts

cpr_id = ps_cpr_id
display_only = false

li_sts = load()

if li_sts <= 0 then
	log.log(this, "u_patient.load:0019", "Unable to load patient", 4)
	return -1
end if

return 1


end function

public function long new_encounter (string ps_office_id, string ps_encounter_type, datetime pdt_encounter_date, string ps_new_flag, string ps_encounter_description, string ps_attending_doctor, string ps_created_by, boolean pb_open_encounter);return new_encounter(ps_office_id, ps_encounter_type, pdt_encounter_date, ps_new_flag, ps_encounter_description, ps_attending_doctor, ps_created_by, pb_open_encounter, true)

end function

public function integer set_property (string ps_progress_key, string ps_progress);long ll_risk_level
string ls_progress_type

setnull(ll_risk_level)
ls_progress_type = "Property"

return set_progress(ls_progress_type, ps_progress_key, ps_progress, ll_risk_level)





end function

public function long add_observation (string ps_observation_id);long ll_parent_observation_sequence
long ll_treatment_id
long ll_observation_sequence

setnull(ll_parent_observation_sequence)
setnull(ll_treatment_id)

sqlca.sp_add_patient_observation(&
		cpr_id, &
		ps_observation_id, &
		ll_parent_observation_sequence, &
		ll_treatment_id, &
		open_encounter_id, &
		current_user.user_id, &
		current_scribe.user_id, &
		ll_observation_sequence)

if not tf_check() then return -1

return ll_observation_sequence


end function

public function string get_encounter_property (long pl_encounter_id, string ps_progress_key);return f_get_encounter_property(cpr_id, pl_encounter_id, ps_progress_key)

end function

public function string id_line ();string ls_id_line
string ls_temp,ls_room_description
string ls_insurance
integer li_insurance_sequence
u_user luo_user
string ls_encounter_type_description


ls_id_line = ""

if not isnull(billing_id) then ls_id_line += billing_id + " "


ls_temp = name("List")
if len(ls_temp) > 0 then ls_id_line += ls_temp

if not isnull(sex) then
	ls_id_line += "  "
	if sex = "M" then
		ls_id_line += "M  "
	else
		ls_id_line += "F  "
	end if
end if

ls_temp = string(date_of_birth, date_format_string)
if not isnull(ls_temp) then ls_id_line += ls_temp

ls_temp = pretty_age()
if not isnull(ls_temp) then ls_id_line += " (" + ls_temp + ")"

if not isnull(current_user) then
	ls_id_line += "  [" + current_user.user_short_name
	if not isnull(current_scribe) then
		if current_scribe.user_id <> current_user.user_id then
			ls_id_line += ", Scribe: " + current_scribe.user_short_name
		end if
	end if
	ls_id_line += "]"
end if

If not isnull(open_encounter) Then
	if not isnull(open_encounter.encounter_description) then
		ls_id_line += ", " + open_encounter.encounter_description
	end if
	
	ls_room_description = room_list.room_name(open_encounter.patient_location)
	if not isnull(ls_room_description) then
		ls_id_line += " in " + ls_room_description
	end if
End If

return ls_id_line

end function

public function string id_line1 ();string ls_id_line
string ls_temp,ls_room_description
string ls_insurance
integer li_insurance_sequence
u_user luo_user

ls_id_line = ""

if not isnull(billing_id) then ls_id_line += billing_id + " "


ls_temp += f_pretty_name(last_name, first_name, middle_name, name_suffix, name_prefix, degree)
if not isnull(ls_temp) then ls_id_line += ls_temp

if not isnull(sex) then
	ls_id_line += "  "
	if sex = "M" then
		ls_id_line += "Sex: Male "
	else
		ls_id_line += "Sex: Female  "
	end if
end if

ls_temp = string(date_of_birth, date_format_string)
if not isnull(ls_temp) then ls_id_line += " Birth Date: "+ls_temp

ls_temp = pretty_age()
if not isnull(ls_temp) then ls_id_line += " (" + ls_temp + ")"

//if not isnull(current_user) then ls_id_line += "  [" + current_user.user_short_name + "]"

//If not isnull(open_encounter) Then
//	ls_id_line += " ," + open_encounter.encounter_type+" Encounter"
//End If

return ls_id_line

end function

public function integer load ();integer li_sts, i

// First reset some instance variables
display_only = false

setnull(open_encounter_id)
setnull(open_encounter_date)
setnull(open_encounter)
setnull(current_display_encounter)


// Load the attachments
li_sts = load_attachments()
if li_sts <= 0 then return -1

// Load the patient data
li_sts = load_patient()
if li_sts <= 0 then return -1

// Now load the encounters
li_sts = load_encounters()
if li_sts < 0 then return -1

// Now load the assessments
li_sts = load_assessments()
if li_sts < 0 then return -1

// Now load the treatments
li_sts = load_treatments()
if li_sts < 0 then return -1

return 1

end function

public function integer modify_patient (string ps_field, string ps_value);integer li_sts
string ls_progress_type
long ll_attachment_id
datetime ldt_progress_date_time
long ll_risk_level
long ll_object_key
long ll_patient_workplan_item_id

setnull(ll_object_key)
setnull(ll_attachment_id)
setnull(ldt_progress_date_time)
setnull(ll_risk_level)
setnull(ll_patient_workplan_item_id)

ls_progress_type = "Modify"

li_sts = f_set_progress(cpr_id, &
								"Patient", &
								ll_object_key, &
								ls_progress_type, &
								ps_field, &
								ps_value, &
								ldt_progress_date_time, &
								ll_risk_level, &
								ll_attachment_id, &
								ll_patient_workplan_item_id)
if li_sts < 0 then return -1

load_patient()

return 1




end function

public function long new_encounter (str_encounter_description pstr_encounter, string ps_created_by, boolean pb_open_encounter);return new_encounter(pstr_encounter, ps_created_by, pb_open_encounter, true)

end function

public function integer load_patient ();long ll_workplan_id
integer li_sort_sequence
datetime ldt_room_time
datetime ldt_date_of_birth
datetime ldt_date_of_conception
string ls_locked_by
long ll_encounter_id
integer li_sts
long ll_attachment_location_id
long ll_count
long ll_rows
boolean lb_default_grant
str_attachment_location lstr_attachment_location
integer li_test_patient

setnull(ll_workplan_id)
setnull(ls_locked_by)

li_sts = p_Patient.set_patient(cpr_id)
if li_sts <= 0 then
	log.log(this, "u_patient.load_patient:0021", "Invalid cpr_id (" + cpr_id + ")", 4)
	return -1
end if

address_line_1 = p_patient.object.address_line_1[1]
address_line_2 = p_patient.object.address_line_2[1]
attachment_location_id = p_patient.object.attachment_location_id[1]
attachment_path = p_patient.object.attachment_path[1]
billing_id = p_patient.object.billing_id[1]
city = p_patient.object.city[1]
country = p_patient.object.country[1]
created = p_patient.object.created[1]
created_by = p_patient.object.created_by[1]
ldt_date_of_birth = p_patient.object.date_of_birth[1]
ldt_date_of_conception = p_patient.object.date_of_conception[1]
degree = p_patient.object.degree[1]
department = p_patient.object.department[1]
email_address = p_patient.object.email_address[1]
employeeID = p_patient.object.employeeID[1]
employer = p_patient.object.employer[1]
employment_status = p_patient.object.employment_status[1]
financial_class = p_patient.object.financial_class[1]
first_name = p_patient.object.first_name[1]
job_description = p_patient.object.job_description[1]
last_name = p_patient.object.last_name[1]
maiden_name = p_patient.object.maiden_name[1]
marital_status = p_patient.object.marital_status[1]
middle_name = p_patient.object.middle_name[1]
name_prefix = p_patient.object.name_prefix[1]
name_suffix = p_patient.object.name_suffix[1]
nickname = p_patient.object.nickname[1]
nationality = p_patient.object.nationality[1]
patient_office_id = p_patient.object.office_id[1]
patient_status = p_patient.object.patient_status[1]
phone_number = p_patient.object.phone_number[1]
primary_language = p_patient.object.primary_language[1]
primary_provider_id = p_patient.object.primary_provider_id[1]
race = p_patient.object.race[1]
referring_provider_id = p_patient.object.referring_provider_id[1]
religion = p_patient.object.religion[1]
secondary_phone_number = p_patient.object.secondary_phone_number[1]
secondary_provider_id = p_patient.object.secondary_provider_id[1]
sex = p_patient.object.sex[1]
shift = p_patient.object.shift[1]
ssn = p_patient.object.ssn[1]
start_date = p_patient.object.start_date[1]
state = p_patient.object.state[1]
termination_date = p_patient.object.termination_date[1]
zip = p_patient.object.zip[1]
ll_attachment_location_id = p_patient.object.attachment_location_id[1]
li_test_patient = p_patient.object.test_patient[1]

date_of_birth = date(ldt_date_of_birth)
time_of_birth = time(ldt_date_of_birth)

date_of_conception = date(ldt_date_of_conception)
calc_gaa()

if isnull(ll_attachment_location_id) then
	ll_attachment_location_id = datalist.get_attachment_location_assignment(cpr_id)

	if ll_attachment_location_id > 0 then
		UPDATE p_Patient
		SET attachment_location_id = :ll_attachment_location_id
		WHERE cpr_id = :cpr_id;
		if not tf_check() then return -1
	end if
end if

lstr_attachment_location = datalist.get_attachment_location(ll_attachment_location_id)

attachment_server = lstr_attachment_location.attachment_server
attachment_share = lstr_attachment_location.attachment_share

if li_test_patient = 0 then
	test_patient = false
else
	test_patient = true
end if

if isnull(attachment_server) or isnull(attachment_share) then
	log.log(this, "u_patient.load_patient:0102", "Invalid Attachment Location (" + string(ll_attachment_location_id) + ")", 4)
	return -1
end if

// Load authority data
ll_count = p_Patient_Authority.retrieve(cpr_id)
if ll_count < 0 then return -1

// Load progress data
ll_count = progress.retrieve(cpr_id)
if ll_count < 0 then return -1

// Load security data
ll_count = p_Object_Security.retrieve(cpr_id)
if ll_count < 0 then return -1

if int(p_Patient.object.default_grant[1]) = 0 then
	lb_default_grant = false
else
	lb_default_grant = true
end if
access_control_list = get_access_control_list("Patient", 0, lb_default_grant)

f_load_patient_list_items(cpr_id, list_item)

return 1

end function

public function str_patient_authorities get_authorities ();str_patient_authorities lstr_patient_authorities
long i
long ll_count

// Load authority data
ll_count = p_Patient_Authority.retrieve(cpr_id)
if ll_count < 0 then return lstr_patient_authorities

lstr_patient_authorities.authority_count = p_Patient_Authority.rowcount()

for i = 1 to lstr_patient_authorities.authority_count
	lstr_patient_authorities.authority[i].cpr_id = cpr_id
	lstr_patient_authorities.authority[i].authority_type = p_Patient_Authority.object.authority_type[i]
	lstr_patient_authorities.authority[i].authority_sequence = p_Patient_Authority.object.authority_sequence[i]
	lstr_patient_authorities.authority[i].authority_id = p_Patient_Authority.object.authority_id[i]
	lstr_patient_authorities.authority[i].authority_name = p_Patient_Authority.object.authority_name[i]
next

return lstr_patient_authorities

end function

public function integer get_primary_authority (string ps_authority_type, ref str_patient_authority pstr_patient_authority);long ll_row
string ls_find

ls_find = "lower(authority_type)='" + lower(ps_authority_type) + "'"
ls_find += " and authority_sequence=1"

ll_row = p_Patient_Authority.find(ls_find, 1, p_Patient_Authority.rowcount())
if ll_row > 0 then
	pstr_patient_authority.cpr_id = cpr_id
	pstr_patient_authority.authority_type = p_Patient_Authority.object.authority_type[ll_row]
	pstr_patient_authority.authority_sequence = p_Patient_Authority.object.authority_sequence[ll_row]
	pstr_patient_authority.authority_id = p_Patient_Authority.object.authority_id[ll_row]
	pstr_patient_authority.authority_name = p_Patient_Authority.object.authority_name[ll_row]
else
	return 0
end if

return 1

end function

public function integer set_encounter_property (long pl_encounter_id, string ps_progress_key, string ps_progress);string ls_progress_type
integer li_sts
long ll_attachment_id
datetime ldt_progress_date_time
long ll_patient_workplan_item_id
long ll_risk_level

setnull(ll_attachment_id)
setnull(ldt_progress_date_time)
setnull(ll_patient_workplan_item_id)
setnull(ll_risk_level)

ls_progress_type = "PROPERTY"

li_sts = f_set_progress(cpr_id, &
								"Encounter", &
								pl_encounter_id, &
								ls_progress_type, &
								ps_progress_key, &
								ps_progress, &
								ldt_progress_date_time, &
								ll_risk_level, &
								ll_attachment_id, &
								ll_patient_workplan_item_id)
if li_sts < 0 then return -1

return 1




end function

public function boolean if_condition (string ps_condition);long ll_row

ll_row = p_patient.find(ps_condition, 1, p_patient.rowcount())
if ll_row > 0 then return true

return false


end function

public function integer exit_office_old ();string ls_null
datetime ldt_null
integer li_sts

setnull(ls_null)
setnull(ldt_null)

if not isnull(open_encounter) then 
//	li_sts = open_encounter.close()
	if li_sts < 0 then
		return li_sts
	elseif li_sts = 0 then
		log.log(this, "u_patient.exit_office_old:0013", "Unable to close current appointment", 4)
		return 0
	end if
end if

return 1
end function

public subroutine close_encounter_old ();

if isnull(open_encounter) then return

//open_encounter.close()

setnull(open_encounter_id)
setnull(open_encounter_date)


end subroutine

public function string get_property_value (string ps_property);str_property_value lstr_property_value
str_attributes lstr_attributes

lstr_property_value = get_property(ps_property, lstr_attributes)

return lstr_property_value.value


end function

public function str_property_value get_property (string ps_property, str_attributes pstr_attributes);str_property_value lstr_property_value

lstr_property_value = p_Patient.get_property(ps_property, pstr_attributes)

return lstr_property_value


//string ls_null
//long ll_row
//integer li_column_id
//long ll_null
//long ll_property_id
//str_property_value lstr_property_value
//u_user luo_provider
//integer li_sts
//str_patient_authority lstr_authority
//str_property lstr_property
//str_attributes lstr_attributes
//string ls_date
//date ld_date
//
//setnull(ls_null)
//setnull(ll_null)
//
//setnull(lstr_property_value.value)
//setnull(lstr_property_value.textcolor)
//setnull(lstr_property_value.backcolor)
//setnull(lstr_property_value.weight)
//
//
//CHOOSE CASE lower(ps_property)
//	CASE "address"
//		lstr_property_value.value = address()
//	CASE "address1line"
//		lstr_property_value.value = address(" ")
//	CASE "age"
//		ls_date = f_attribute_find_attribute(pstr_attributes, "property_date")
//		if isdate(ls_date) then
//			ld_date = date(ls_date)
//		else
//			ld_date = today()
//		end if
//		lstr_property_value.value = f_pretty_age(date_of_birth, ld_date)
//	CASE "date_of_birth"
//		lstr_property_value.value = string(current_patient.date_of_birth, "[shortdate]")
//	CASE "full_name"
//		lstr_property_value.value = current_patient.name()
//	CASE "primary_office"
//		lstr_property_value.value = datalist.office_description(current_patient.patient_office_id)
//	CASE "phone_number"
//		lstr_property_value.value = current_patient.phone_number
//	CASE "primary_provider"
//		luo_provider = user_list.find_user(current_patient.primary_provider_id)
//		if not isnull(luo_provider) then
//			lstr_property_value.value = luo_provider.user_short_name
//			lstr_property_value.backcolor = luo_provider.color
//		else
//			setnull(lstr_property_value.value)
//		end if
//	CASE "primary_payor"
//		li_sts = current_patient.get_primary_authority("Payor", lstr_authority)
//		if li_sts > 0 then
//			lstr_property_value.value = lstr_authority.authority_name
//		else
//			setnull(lstr_property_value.value)
//		end if
//	CASE "sex_male_female"
//		if upper(sex) = "F" then
//			lstr_property_value.value = "female"
//		else
//			lstr_property_value.value = "male"
//		end if
//	CASE "allergies"
//		if current_patient.any_allergies() then
//			lstr_property_value.value = "Allergies"
//			lstr_property_value.textcolor = COLOR_RED
//			lstr_property_value.weight = 700
//		else
//			lstr_property_value.value = "No Allergies"
//			lstr_property_value.textcolor = COLOR_BLACK
//			lstr_property_value.weight = 400
//		end if
//	CASE ELSE
//		li_column_id = p_Patient.column_id(ps_property)
//		
//		if li_column_id > 0 then
//			lstr_property_value.value = string(p_Patient.object.data[1, li_column_id])
//		else
//			lstr_property_value.value = f_get_progress_value(cpr_id, "Patient", ll_null, "Property", ps_property)
//		end if
//END CHOOSE
//
//lstr_property_value.display_value = f_property_value_display(ps_property, lstr_property_value.value)
//
//return lstr_property_value
//
end function

public function integer reload ();integer li_sts


// Load the attachments
li_sts = load_attachments()
if li_sts <= 0 then return -1

// Load the patient data
li_sts = load_patient()
if li_sts <= 0 then return -1

// Now load the encounters
li_sts = load_encounters()
if li_sts < 0 then return -1

// Now load the assessments
li_sts = load_assessments()
if li_sts < 0 then return -1

// Now load the treatments
li_sts = load_treatments()
if li_sts < 0 then return -1

li_sts = encounters.encounter(open_encounter, open_encounter_id)
if li_sts <= 0 then
	setnull(open_encounter_id)
	setnull(open_encounter_date)
	setnull(open_encounter)
	setnull(current_display_encounter)
else
	current_display_encounter = open_encounter
	open_encounter_date = open_encounter.encounter_date
end if

return 1

end function

public function integer set_progress (string ps_progress_type, string ps_progress_key, datetime pdt_progress_date_time, string ps_progress, long pl_risk_level);long ll_attachment_id
long ll_patient_workplan_item_id
long ll_object_key
integer li_sts

setnull(ll_object_key)
setnull(ll_attachment_id)
setnull(ll_patient_workplan_item_id)


li_sts = f_set_progress(cpr_id, &
								"Patient", &
								ll_object_key, &
								ps_progress_type, &
								ps_progress_key, &
								ps_progress, &
								pdt_progress_date_time, &
								pl_risk_level, &
								ll_attachment_id, &
								ll_patient_workplan_item_id)
if li_sts < 0 then return -1


return 1




end function

public function integer set_progress (string ps_progress_type, string ps_progress_key, string ps_progress, long pl_risk_level);datetime ldt_progress_date_time

setnull(ldt_progress_date_time)

return set_progress(ps_progress_type, ps_progress_key, ldt_progress_date_time, ps_progress, pl_risk_level)


end function

public function str_progress_list get_progress_list (string ps_context_object, long pl_object_key, string ps_progress_type, string ps_progress_key, string ps_attachments_only_flag);long ll_rows
integer li_count
str_progress_list lstr_progress
string ls_progress_short
string ls_progress_long
string ls_progress
long ll_attachment_id
string ls_progress_type
str_progress_type lstr_progress_type
string ls_context_object_type
integer li_sts
string ls_progress_key
string ls_find
long ll_row
long ll_rowcount

li_count = 0
ls_context_object_type = context_object_type(ps_context_object, pl_object_key)

ls_find = "lower(context_object)='" + lower(ps_context_object) + "'"
if not isnull(pl_object_key) and lower(ps_context_object) <> "patient" then
	ls_find += " and object_key=" + string(pl_object_key)
end if
if len(ps_progress_type) > 0 then
	ls_find += " and lower(progress_type)='" + lower(ps_progress_type) + "'"
end if
if len(ps_progress_key) > 0 then
	ps_progress_key = f_string_substitute(ps_progress_key, "'", "~~'")
	ls_find += " and lower(progress_key)='" + lower(ps_progress_key) + "'"
end if
if upper(ps_attachments_only_flag) = 'Y' then
	ls_find += " and not isnull(attachment_id)"
end if

ll_rowcount = progress.rowcount()

ll_row = progress.find(ls_find, 1, ll_rowcount)
DO WHILE ll_row > 0 and ll_row <= ll_rowcount
	ls_progress_short = progress.object.progress_value[ll_row]
	ls_progress_long = progress.object.progress[ll_row]
	ls_progress = f_progress_value(ls_progress_short, ls_progress_long)
	ll_attachment_id = progress.object.attachment_id[ll_row]
	ls_progress_type = progress.object.progress_type[ll_row]
	ls_progress_key = progress.object.progress_key[ll_row]
	
	// If the short and long and attachment_id values are all null then we should interpret it as "not found"
	if isnull(ls_progress_short) and isnull(ls_progress_long) and isnull(ll_attachment_id) then
		// ...unless it's a "special" progress type
		if lower(ls_progress_type) = "created" or lower(ls_progress_type) = "closed" or lower(ls_progress_type) = "reviewed" or left(lower(ls_progress_type), 6) = "refill" then
			// These special progress types can be null and should still be included in the list
		else
			// All other progress types can't be null and should be excluded
			
			// ... but first get the next matching progress record
			ll_row = progress.find(ls_find, ll_row + 1, ll_rowcount + 1)
			continue
		end if
	end if
	
	li_count += 1
	lstr_progress.progress[li_count].progress_sequence = progress.object.progress_sequence[ll_row]
	lstr_progress.progress[li_count].encounter_id = progress.object.encounter_id[ll_row]
	lstr_progress.progress[li_count].user_id = progress.object.user_id[ll_row]
	lstr_progress.progress[li_count].progress_date_time = progress.object.progress_date_time[ll_row]
	lstr_progress.progress[li_count].progress_type = ls_progress_type
	lstr_progress.progress[li_count].progress_key = ls_progress_key
	lstr_progress.progress[li_count].progress = ls_progress
	lstr_progress.progress[li_count].attachment_id = ll_attachment_id
	lstr_progress.progress[li_count].created = progress.object.created[ll_row]
	lstr_progress.progress[li_count].created_by = progress.object.created_by[ll_row]

	// Add the progress type structure
	li_sts = datalist.progress_type(ps_context_object, ls_context_object_type, ps_progress_type, lstr_progress_type)
	lstr_progress.progress[li_count].progress_type_properties = lstr_progress_type

	// Populate the progress_key_description and progress_note_description fields
	f_progress_description(lstr_progress.progress[li_count])
	
	// Get the next matching progress record
	ll_row = progress.find(ls_find, ll_row + 1, ll_rowcount + 1)
LOOP

lstr_progress.progress_count = li_count

return lstr_progress

end function

public function integer set_object_progress_old (string ps_context_object, long pl_object_key, string ps_progress_type, string ps_progress_key, string ps_progress, datetime pdt_progress_date_time, long pl_risk_level, long pl_attachment_id, long pl_patient_workplan_item_id, integer pi_diagnosis_sequence, string ps_severity);//long ll_encounter_id
//integer li_sts
//
//setnull(ll_encounter_id)
//if not isnull(current_service) then
//	ll_encounter_id = current_service.encounter_id
//end if
//
//
//CHOOSE CASE lower(ps_context_object)
//	CASE "patient"
//		sqlca.sp_set_patient_progress(cpr_id, &
//												ll_encounter_id, &
//												pl_attachment_id, &
//												ps_progress_type, &
//												ps_progress_key, &
//												ps_progress, &
//												pdt_progress_date_time, &
//												pl_patient_workplan_item_id, &
//												pl_risk_level, &
//												current_user.user_id, &
//												current_scribe.user_id )
//		if not tf_check() then return -1
//	CASE "encounter"
//		sqlca.sp_set_encounter_progress( cpr_id, &
//													pl_object_key, &
//													pl_attachment_id, &
//													ps_progress_type, &
//													ps_progress_key, &
//													ps_progress, &
//													pdt_progress_date_time, &
//													pl_patient_workplan_item_id, &
//													pl_risk_level, &
//													current_user.user_id, &
//													current_scribe.user_id)
//		if not tf_check() then return -1
//	CASE "assessment"
//		sqlca.sp_set_assessment_progress(cpr_id, &
//													pl_object_key, &
//													ll_encounter_id, &
//													pdt_progress_date_time, &
//													pi_diagnosis_sequence, &  
//													ps_progress_type, &  
//													ps_progress_key, &  
//													ps_progress, &  
//													ps_severity, &  
//													pl_attachment_id, &
//													pl_patient_workplan_item_id, &
//													pl_risk_level, &  
//													current_user.user_id, &  
//													current_scribe.user_id)
//		if not tf_check() then return -1
//	CASE "treatment"
//		sqlca.sp_set_treatment_progress( cpr_id, &
//													pl_object_key, &
//													ll_encounter_id, &
//													ps_progress_type, &
//													ps_progress_key, &
//													ps_progress, &
//													pdt_progress_date_time, &
//													pl_patient_workplan_item_id, &
//													pl_risk_level, &
//													pl_attachment_id, &
//													current_user.user_id, &
//													current_scribe.user_id)
//		if not tf_check() then return -1
//	CASE "observation"
//END CHOOSE
//
//li_sts = load_patient()
//if li_sts < 0 then return -1
//
return 1


end function

public function integer set_object_progress_old (string ps_context_object, long pl_object_key, string ps_progress_type, string ps_progress_key, string ps_progress, datetime pdt_progress_date_time, long pl_risk_level, long pl_attachment_id, long pl_patient_workplan_item_id);integer li_diagnosis_sequence
//string ls_severity
//
//
//setnull(li_diagnosis_sequence)
//setnull(ls_severity)
//
//return set_object_progress(ps_context_object, &
//									pl_object_key, &
//									ps_progress_type, &
//									ps_progress_key, &
//									ps_progress, &
//									pdt_progress_date_time, &
//									pl_risk_level, &
//									pl_attachment_id, &
//									pl_patient_workplan_item_id, &
//									li_diagnosis_sequence, &
//									ls_severity )
//
//
return 1

end function

public function string context_object_type (string ps_context_object, long pl_object_key);string ls_context_object_type

CHOOSE CASE lower(ps_context_object)
	CASE "patient"
		setnull(ls_context_object_type)
	CASE "encounter"
		ls_context_object_type = current_patient.encounters.encounter_type(pl_object_key)
	CASE "assessment"
		ls_context_object_type = current_patient.assessments.assessment_type(pl_object_key)
	CASE "treatment"
		ls_context_object_type = current_patient.treatments.treatment_type(pl_object_key)
	CASE ELSE
		ls_context_object_type = sqlca.fn_context_object_type(ps_context_object, cpr_id, pl_object_key)
END CHOOSE

return ls_context_object_type

end function

public function string name_fml ();return name("Full")

end function

public function str_access_control_list get_access_control_list (string ps_context_object, long pl_object_key, boolean pb_default_grant);string ls_find
long ll_row
long ll_rowcount
str_access_control_list lstr_list
str_access_control_item lstr_item
string ls_access_flag

ls_find = "context_object='" + ps_context_object + "'"
ls_find += " and object_key=" + string(pl_object_key)

ll_rowcount = p_object_security.rowcount()

lstr_list.access_count = 0

ll_row = p_object_security.find(ls_find, 1, ll_rowcount)
DO WHILE ll_row > 0 and ll_row <= ll_rowcount
	ls_access_flag = p_object_security.object.access_flag[ll_row]
	if upper(ls_access_flag) = "G" then
		lstr_item.grant_access = true
	else
		lstr_item.grant_access = false
	end if
	lstr_item.user_id = p_object_security.object.user_id[ll_row]
	
	// Add the item to the list
	lstr_list.access_count += 1
	lstr_list.access_list[lstr_list.access_count] = lstr_item
	
	ll_row = p_object_security.find(ls_find, ll_row + 1, ll_rowcount + 1)
LOOP

lstr_list.default_grant = pb_default_grant

return lstr_list


end function

public function string address ();return address("~r~n")

end function

public function string pretty_age ();string ls_pretty_age

if daysafter(gaa_date_of_birth, today()) >= 730 &
  or gaa_date_of_birth = date_of_birth then
	ls_pretty_age = f_pretty_age(date_of_birth, today())
else
	ls_pretty_age = f_pretty_age(gaa_date_of_birth, today())
	ls_pretty_age += " GAA"
end if

return ls_pretty_age

end function

public subroutine calc_gaa ();weeks_premature = 0

if not isnull(date_of_conception) then
	weeks_premature = 40 - (daysafter(date_of_conception, date_of_birth) / 7)
	// Ignore absurd values and treat 3 weeks or less premature as normal.
	if weeks_premature < 4 or weeks_premature > 30 then
		weeks_premature = 0
	end if
end if

gaa_date_of_birth = relativedate(date_of_birth, 7 * weeks_premature)


end subroutine

public function string address (string ps_line_delimiter);string ls_address
string ls_city_state_zip

ls_address = ""

if len(address_line_1) > 0 then ls_address += address_line_1

if len(address_line_2) > 0 then
	if len(ls_address) > 0 then ls_address += ps_line_delimiter
	ls_address += address_line_2
end if

ls_city_state_zip = ""
if len(city) > 0 then
	ls_city_state_zip += city
end if

if len(state) > 0 then
	if len(ls_city_state_zip) > 0 then ls_city_state_zip += ", "
	ls_city_state_zip += state
end if

if len(zip) > 0 then
	if len(ls_city_state_zip) > 0 then ls_city_state_zip += "  "
	ls_city_state_zip += zip
end if

if len(ls_city_state_zip) > 0 then
	if len(ls_address) > 0 then ls_address += ps_line_delimiter
	ls_address += ls_city_state_zip
end if

return ls_address


end function

public function long new_encounter (str_encounter_description pstr_encounter, string ps_created_by, boolean pb_open_encounter, boolean pb_order_workplan);long ll_encounter_id
integer li_count
string ls_encounter_status
string ls_patient_class
string ls_patient_location
string ls_next_patient_location
string ls_admission_type
string ls_referring_doctor
string ls_ambulatory_status
string ls_vip_indicator
string ls_charge_price_ind
string ls_courtesy_code
string ls_discharge_disp
datetime ldt_discharge_date
string ls_admit_reason
string ls_indirect_flag
string ls_primary_procedure_id
string ls_secondary_procedure_id
integer li_secondary_procedure_multiplier
datetime ldt_last_update
string ls_auto_close
integer li_consult_time
decimal ldc_charge
string ls_billing_note
long ll_encounter_billing_id
string ls_bill_flag
string ls_null
string ls_first_room_id
long ll_null
str_stamp lstr_stamp
string ls_assessment_id, ls_description, ls_icd10_code
integer li_sts, li_encounter_index

setnull(ls_null)
setnull(ll_null)

if isnull(pstr_encounter.encounter_date) then
	log.log(this, "u_patient.new_encounter:0038", "Null appointment date", 4)
	return -1
end if

lstr_stamp = f_get_stamp()
if not lstr_stamp.create_encounters then
	log.log(this, "u_patient.new_encounter:0044", "This installation is not properly licensed to create appointments", 4)
	return 0
end if

setnull(ls_patient_class)
setnull(ls_patient_location)
setnull(ls_next_patient_location)
setnull(ls_admission_type)
setnull(ls_referring_doctor)
setnull(ls_ambulatory_status)
setnull(ls_vip_indicator)
setnull(ls_charge_price_ind)
setnull(ls_courtesy_code)
setnull(ls_discharge_disp)
setnull(ldt_discharge_date)
setnull(ls_admit_reason)
setnull(ls_indirect_flag)
setnull(ls_primary_procedure_id)
setnull(ls_secondary_procedure_id)
setnull(li_secondary_procedure_multiplier)
setnull(ldt_last_update)
setnull(li_consult_time)
setnull(ls_billing_note)
setnull(ll_encounter_billing_id)
setnull(ls_assessment_id)
setnull(ll_encounter_id)
setnull(ls_encounter_status)

// Set the current stage
//current_stage_index = stage_list.determine_stage_index(date_of_birth, date(pdt_encounter_date))

// If we didn't get an office_id passed in, the use the current office_id
if isnull(pstr_encounter.office_id) then
	pstr_encounter.office_id = gnv_app.office_id
end if

// Get indirect flag
if isnull(pstr_encounter.indirect_flag) then
	pstr_encounter.indirect_flag = datalist.encounter_type_default_indirect_flag(pstr_encounter.encounter_type)
end if

// bill_flag
if isnull(pstr_encounter.bill_flag) then
	pstr_encounter.bill_flag = datalist.encounter_type_bill_flag(pstr_encounter.encounter_type)
end if

// new_flag
if upper(pstr_encounter.new_flag) = "Y" then
	pstr_encounter.new_flag = "Y"
else
	pstr_encounter.new_flag = "N"
end if

setnull(open_encounter_id)
setnull(open_encounter_date)

open_encounter = CREATE u_str_encounter

open_encounter.parent_patient = this

open_encounter.encounter_id = ll_null
open_encounter.patient_workplan_id = ll_null
if pb_open_encounter then
	open_encounter.encounter_status = "OPEN"
else
	open_encounter.encounter_status = "CLOSED"
end if

if trim(pstr_encounter.description) = "" then
	setnull(pstr_encounter.description)
end if

// Set the passed in values
open_encounter.encounter_date = pstr_encounter.encounter_date
open_encounter.encounter_type = pstr_encounter.encounter_type
open_encounter.encounter_description = pstr_encounter.description
open_encounter.indirect_flag = pstr_encounter.indirect_flag
open_encounter.attending_doctor = pstr_encounter.attending_doctor
open_encounter.referring_doctor = pstr_encounter.referring_doctor
open_encounter.supervising_doctor = pstr_encounter.supervising_doctor
open_encounter.new_flag = pstr_encounter.new_flag
open_encounter.bill_flag = pstr_encounter.bill_flag
open_encounter.encounter_office_id = pstr_encounter.office_id
open_encounter.created_by = ps_created_by

// Set the other fields to default values
open_encounter.patient_class = ls_patient_class
open_encounter.patient_location = ls_patient_location
open_encounter.next_patient_location = ls_next_patient_location
open_encounter.admission_type = ls_admission_type
open_encounter.ambulatory_status = ls_ambulatory_status
open_encounter.vip_indicator = ls_vip_indicator
open_encounter.charge_price_ind = ls_charge_price_ind
open_encounter.courtesy_code = ls_courtesy_code
open_encounter.discharge_disp = ls_discharge_disp
open_encounter.discharge_date = ldt_discharge_date
open_encounter.admit_reason = ls_admit_reason
open_encounter.billing_note = ls_billing_note
open_encounter.encounter_billing_id = ll_encounter_billing_id
open_encounter.billing_hold_flag = "N"


open_encounter.deleted = false
open_encounter.updated = false
open_encounter.ib_exists = false
li_sts = current_patient.encounters.new_encounter(open_encounter)
if li_sts < 0 then return -1

if isnull(open_encounter.encounter_id) then
	log.log(this, "u_patient.new_encounter:0153", "Error creating new appointment", 4)
	// Since we know we created this encounter object, we can destroy it here
	DESTROY open_encounter
	setnull(open_encounter)
	return -1
end if

open_encounter_id = open_encounter.encounter_id
open_encounter_date = open_encounter.encounter_date
current_display_encounter = open_encounter

attachments.encounter_attachment_list(open_encounter.attachment_list, open_encounter_id)
display_only = false

if pb_order_workplan then
	li_sts = open_encounter.order_encounter_workplan()
	if li_sts <= 0 then
		log.log(this, "u_patient.new_encounter:0170", "Error ordering appointment workplan", 4)
	end if
end if

return open_encounter_id


end function

public function long new_encounter (string ps_office_id, string ps_encounter_type, datetime pdt_encounter_date, string ps_new_flag, string ps_encounter_description, string ps_attending_doctor, string ps_created_by, boolean pb_open_encounter, boolean pb_order_workplan);str_encounter_description lstr_encounter


lstr_encounter.office_id = ps_office_id
lstr_encounter.encounter_type = ps_encounter_type
lstr_encounter.encounter_date = pdt_encounter_date
lstr_encounter.new_flag = ps_new_flag
lstr_encounter.description = ps_encounter_description
lstr_encounter.attending_doctor = ps_attending_doctor

setnull(lstr_encounter.indirect_flag)
setnull(lstr_encounter.referring_doctor)
setnull(lstr_encounter.supervising_doctor)
setnull(lstr_encounter.bill_flag)

return new_encounter(lstr_encounter, ps_created_by, pb_open_encounter, pb_order_workplan)


end function

public function string name (string ps_name_format);string ls_name

ls_name = f_pretty_name_formatted( first_name, & 
												middle_name, & 
												last_name, & 
												nickname, & 
												name_suffix, & 
												name_prefix, & 
												degree, & 
												ps_name_format)

return ls_name

end function

public function string name ();return name("Full")

end function

public subroutine chart_encounter_old ();//str_popup_return popup_return
//integer li_sts
//datetime ldt_encounter_date
//string lsa_attribute[]
//string lsa_value[]
//
//if not isnull(open_encounter) then
//	openwithparm(w_pop_message, "An appointment is already open")
//	return
//end if
//
//open(w_new_past_encounter)
//popup_return = message.powerobjectparm
//if popup_return.item_count = 0 then return
//
//lsa_attribute[1] = "ENCOUNTER_TYPE"
//lsa_value[1] = popup_return.items[1]
//
//lsa_attribute[2] = "ENCOUNTER_DATE"
//lsa_value[2] = popup_return.items[2]
//
//lsa_attribute[3] = "ATTENDING_DOCTOR"
//lsa_value[3] = popup_return.items[3]
//
//lsa_attribute[4] = "OFFICE_ID"
//lsa_value[4] = popup_return.items[4]
//
//
////do_todo_service("CHART", 4, lsa_attribute, lsa_value)
//
//
end subroutine

event constructor;
setnull(open_encounter_id)
setnull(open_encounter)

encounters = CREATE u_ds_patient_encounter
encounters.parent_patient = this
encounters.set_dataobject("dw_encounter_data")

assessments = CREATE u_ds_assessment
assessments.parent_patient = this
assessments.set_dataobject("dw_assessment_data")

treatments = CREATE u_ds_treatment_item
treatments.parent_patient = this
treatments.set_dataobject("dw_treatment_data")

attachments = CREATE u_ds_attachments
attachments.set_dataobject("dw_p_attachment")

p_Patient_Authority = CREATE u_ds_data
p_Patient_Authority.set_dataobject("dw_p_Patient_Authority")

p_Patient = CREATE u_ds_patient

progress = CREATE u_ds_data
progress.set_dataobject("dw_sp_patient_object_progress_current")

p_Object_Security = CREATE u_ds_data
p_Object_Security.set_dataobject("dw_p_object_security")

end event

on u_patient.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_patient.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;DESTROY p_Patient
DESTROY encounters
DESTROY assessments
DESTROY treatments
DESTROY attachments
DESTROY p_Patient_Authority

end event

