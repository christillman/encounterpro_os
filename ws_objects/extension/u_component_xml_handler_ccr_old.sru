HA$PBExportHeader$u_component_xml_handler_ccr_old.sru
forward
global type u_component_xml_handler_ccr_old from u_component_xml_handler
end type
type str_codeddescription_type from structure within u_component_xml_handler_ccr_old
end type
type str_element from structure within u_component_xml_handler_ccr_old
end type
type str_name_type from structure within u_component_xml_handler_ccr_old
end type
type str_code_type from structure within u_component_xml_handler_ccr_old
end type
type str_elements from structure within u_component_xml_handler_ccr_old
end type
type str_date_type from structure within u_component_xml_handler_ccr_old
end type
type str_communication_type from structure within u_component_xml_handler_ccr_old
end type
type str_problem_type from structure within u_component_xml_handler_ccr_old
end type
type str_patientknowledge_type from structure within u_component_xml_handler_ccr_old
end type
type str_informationsystem_type from structure within u_component_xml_handler_ccr_old
end type
type str_organization_type from structure within u_component_xml_handler_ccr_old
end type
type str_alert_type from structure within u_component_xml_handler_ccr_old
end type
type str_reaction_type from structure within u_component_xml_handler_ccr_old
end type
type str_medication_type from structure within u_component_xml_handler_ccr_old
end type
type str_amount_type from structure within u_component_xml_handler_ccr_old
end type
type str_link_type from structure within u_component_xml_handler_ccr_old
end type
type str_indication_type from structure within u_component_xml_handler_ccr_old
end type
type str_rxhistory_type from structure within u_component_xml_handler_ccr_old
end type
type str_test_type from structure within u_component_xml_handler_ccr_old
end type
type str_result_type from structure within u_component_xml_handler_ccr_old
end type
type str_substance_type from structure within u_component_xml_handler_ccr_old
end type
type str_procedure_type from structure within u_component_xml_handler_ccr_old
end type
type str_currenthealthstatus_type from structure within u_component_xml_handler_ccr_old
end type
type str_encounter_type from structure within u_component_xml_handler_ccr_old
end type
end forward

type str_codeddescription_type from structure
	string		description
	string		code
end type

type str_element from structure
	pbdom_element		element
	pbdom_element		child[]
	long		child_count
	str_code_type		id[]
	long		id_count
	boolean		valid
end type

type str_name_type from structure
	string		first_name
	string		middle_name
	string		last_name
	string		suffix
	string		degree
end type

type str_code_type from structure
	string		code_value
	string		code_type
	string		code_version
end type

type str_elements from structure
	long		element_count
	str_element		element[]
end type

type str_date_type from structure
	string		date_type
	string		age
	datetime		date_and_time
	string		approximate
end type

type str_communication_type from structure
	string		value
	string		communication_type
	string		priority
	string		status
end type

type str_problem_type from structure
	string		description
	string		attribute[]
	string		modifier[]
	str_code_type		code[]
	str_date_type		problem_date[]
	string		occurences
	string		status
	str_patientknowledge_type		patientknowledge
end type

type str_patientknowledge_type from structure
	string		description
	string		reason
end type

type str_informationsystem_type from structure
	string		name
	string		informationsystem_type
	string		version
end type

type str_organization_type from structure
	string		name
end type

type str_alert_type from structure
	string		description
	string		attribute[]
	string		modifier[]
	str_code_type		code[]
	str_reaction_type		reaction[]
	str_codeddescription_type		causativeagent[]
	str_date_type		alert_date[]
	str_codeddescription_type		intervention[]
	str_patientknowledge_type		patientknowledge
end type

type str_reaction_type from structure
	string		description
	string		severity
end type

type str_medication_type from structure
	string		genericname
	string		brandname
	string		manufacturer
	string		lotnumber
	string		preparation
	str_code_type		code[]
	str_date_type		medication_date[]
	string		dosestrength
	string		quantity
	str_amount_type		amount
	string		route
	string		site
	string		frequency
	str_indication_type		indication[]
	string		instructions
	string		refill
	str_rxhistory_type		OrderRxHistory[]
	str_rxhistory_type		Fulfillment[]
end type

type str_amount_type from structure
	string		quantity
	string		unit
end type

type str_link_type from structure
	string		link_type
	string		id
end type

type str_indication_type from structure
	string		description
	string		modifier
	str_link_type		link
end type

type str_RxHistory_Type from structure
	str_date_type		rx_date
	string		rxhistory_type
	str_link_type		practitioner
	str_link_type		location
end type

type str_test_type from structure
	string		description
	string		modifier
	str_code_type		code[]
	string		value
	string		unit
	string		normalrange
	string		flag
end type

type str_result_type from structure
	string		description
	str_code_type		code[]
	str_substance_type		substance
	str_date_type		result_date[]
	str_test_type		test[]
	string		position
	string		location
	string		method
end type

type str_substance_type from structure
	string		substance_type
	str_code_type		code[]
end type

type str_procedure_type from structure
	string		description
	string		attribute[]
	str_code_type		code[]
	str_date_type		procedure_date[]
	str_indication_type		indication[]
	str_currenthealthstatus_type		currenthealthstatus
	str_patientknowledge_type		patientknowledge
end type

type str_currenthealthstatus_type from structure
	string		status
	str_code_type		code
	string		causeofdeath
	str_date_type		timeofdeath
end type

type str_encounter_type from structure
	string		description
	string		attribute[]
	str_code_type		code[]
	str_date_type		encounter_date[]
	str_indication_type		indication[]
end type

global type u_component_xml_handler_ccr_old from u_component_xml_handler
end type
global u_component_xml_handler_ccr_old u_component_xml_handler_ccr_old

type variables

private long actor_count
private str_element actor[]
private string actor_id[]

// Special elements
private str_element patient
private str_element source
private str_element body


// Cache the owner of the current ccr data
long owner_id

private long problem_count
private str_element problem[]
private string ccr_problem_id[]
private long epro_problem_id[]


private long alert_count
private str_element alert[]
private string ccr_alert_id[]

private long medication_count
private str_element medication[]
private string ccr_medication_id[]

private long immunization_count
private str_element immunization[]
private string ccr_immunization_id[]

private long vitalsign_count
private str_element vitalsign[]
private string ccr_vitalsign_id[]

private long result_count
private str_element result[]
private string ccr_result_id[]

private long procedure_count
private str_element ccrprocedure[]
private string ccr_procedure_id[]

private long encounter_count
private str_element encounter[]
private string ccr_encounter_id[]

end variables

forward prototypes
protected function integer xx_interpret_xml ()
public function integer get_actors (pbdom_element po_actors)
public function integer process_body ()
public function str_element get_child_element (ref str_element pstr_element, string ps_child_element)
public function str_element get_element (pbdom_element po_element)
public function integer get_actor (string ps_id, ref str_element pstr_actor)
public function integer set_patient ()
public function str_code_type get_code_type (ref str_element pstr_element)
public function str_elements get_child_elements (ref str_element pstr_element, string ps_child_element)
public function str_codeddescription_type get_codeddescription_type (ref str_element pstr_element)
public function str_codeddescription_type get_codeddescription_type (ref str_element pstr_element, string ps_child_element)
public function str_date_type get_date_type (ref str_element pstr_element)
public function str_date_type get_date_type (ref str_element pstr_element, string ps_child_element)
public function str_name_type get_name_type (ref str_element pstr_element)
public function str_name_type get_name_type (ref str_element pstr_element, string ps_child_element)
public function string get_cd_epro_value (ref str_element pstr_element, string ps_child_element, string ps_epro_domain)
public function str_communication_type get_communication_type (ref str_element pstr_element)
public function integer process_problems (str_element pstr_element)
public function integer process_insurance (str_element pstr_element)
public function integer process_advancedirectives (str_element pstr_element)
public function integer process_familyhistory (str_element pstr_element)
public function integer process_alerts (str_element pstr_element)
public function integer process_socialhistory (str_element pstr_element)
public function integer process_immunizations (str_element pstr_element)
public function integer process_medications (str_element pstr_element)
public function integer process_vitalsigns (str_element pstr_element)
public function integer process_results (str_element pstr_element)
public function integer process_procedures (str_element pstr_element)
public function integer process_encounters (str_element pstr_element)
public function integer process_planofcare (str_element pstr_element)
public function integer process_practitioners (str_element pstr_element)
public function str_patientknowledge_type get_patientknowledge_type (ref str_element pstr_element)
public function str_problem_type get_problem_type (ref str_element pstr_element)
public function datetime find_date (str_date_type pstr_dates[], string ps_date_type)
public function string find_code (str_code_type pstr_codes[], string ps_code_type)
public function integer set_source ()
public function str_informationsystem_type get_informationsystem_type (ref str_element pstr_element)
public function str_organization_type get_organization_type (ref str_element pstr_element)
public function str_alert_type get_alert_type (ref str_element pstr_element)
public function str_reaction_type get_reaction_type (ref str_element pstr_element)
public function str_medication_type get_medication_type (ref str_element pstr_element)
public function str_amount_type get_amount_type (ref str_element pstr_element)
public function str_link_type get_link_type (ref str_element pstr_element)
public function str_indication_type get_indication_type (ref str_element pstr_element)
public function str_rxhistory_type get_rxhistory_type (ref str_element pstr_element)
public function long find_epro_problem_id (string ps_ccr_problem_id)
public function str_test_type get_test_type (ref str_element pstr_element)
public function str_substance_type get_substance_type (ref str_element pstr_element)
public function str_result_type get_result_type (ref str_element pstr_element)
public function integer add_results_treatment (string ps_treatment_type, str_result_type pstr_result)
public function str_procedure_type get_procedure_type (ref str_element pstr_element)
public function str_currenthealthstatus_type get_currenthealthstatus_type (ref str_element pstr_element)
public function integer add_treatment_indications (long pl_treatment_id, str_indication_type pstr_indications[])
public function str_encounter_type get_encounter_type (ref str_element pstr_element)
public function integer add_encounter_indications (long pl_encounter_id, str_indication_type pstr_indications[])
end prototypes

protected function integer xx_interpret_xml ();PBDOM_ELEMENT lo_root
PBDOM_ELEMENT lo_elem[]
datetime ldt_result_expected_date
integer li_sts
long ll_owner_id
int i
string ls_root
string ls_tag
long ll_count
boolean lb_haschildren
PBDOM_ELEMENT lo_actors

TRY
	lo_root = xml.XML_Document.GetRootElement()
	ls_root = lo_root.getname()
	
	lo_root.GetChildElements(ref lo_elem)
	ll_count = UpperBound(lo_elem)
	
CATCH (pbdom_exception lo_error)
	log.log(this, "process_xml", "Error - " + lo_error.text, 4)
	return -1
END TRY


for i = 1 to ll_count
	ls_tag = lo_elem[i].getname()
	
	CHOOSE CASE lower(ls_tag)
		CASE "documentdate"
		CASE "actors"
			lo_actors = lo_elem[i]
		CASE "purpose"
		CASE "participants"
		CASE "reference"
		CASE "comment"
		CASE "body"
			body = get_element(lo_elem[i])
	END CHOOSE
next

if not isvalid(lo_actors) then
	log.log(this, "xx_interpret_xml()", "Error - Document has no actors", 4)
	return -1
else
	get_actors(lo_actors)
end if

// If we didn't find an actor with a defaultrole of 'Source', then
// assume that the second actor is the source
if not source.valid then
	if actor_count >= 2 then
		log.log(this, "xx_interpret_xml()", "Document has no actor labeled 'Source'.  Assuming that second actor is the source.", 3)
		source = actor[2]
	end if
end if

// If we still don't have a valid source, then we have an error
if not source.valid then
	log.log(this, "xx_interpret_xml()", "Error - Document has no source", 4)
	return -1
else
	li_sts = set_source()
	if li_sts <= 0 then
		log.log(this, "xx_interpret_xml()", "Error - Unable to set source", 4)
		return -1
	end if
end if

if not patient.valid then
	log.log(this, "xx_interpret_xml()", "Error - Document has no patient", 4)
	return -1
else
	li_sts = set_patient()
	if li_sts <= 0 then
		log.log(this, "xx_interpret_xml()", "Error - Unable to set patient", 4)
		return -1
	end if
end if

if not isvalid(body) then
	log.log(this, "xx_interpret_xml()", "Error - Document has no body", 4)
	return -1
else
	li_sts = process_body()
	if li_sts < 0 then return -1
end if

return 1


end function

public function integer get_actors (pbdom_element po_actors);long i
str_codeddescription_type lstr_defaultrole
pbdom_element lo_actor[]
boolean lb_patient_found
boolean lb_source_found

TRY
	po_actors.getchildelements(lo_actor)
	actor_count = upperbound(lo_actor)
CATCH (pbdom_exception lo_error)
	log.log(this, "get_actors()", "Error - " + lo_error.text, 4)
	return -1
END TRY

lb_patient_found = false
lb_source_found = false

for i = 1 to actor_count
	actor[i] = get_element(lo_actor[i])
	actor_id[i] = lo_actor[i].getattributevalue("ID")
	
	// Set the patient_actor to be the first actor with a default_rolw of "patient"
	lstr_defaultrole = get_codeddescription_type(actor[i], "DefaultRole")
	
	if lower(lstr_defaultrole.description) = "patient" and not lb_patient_found then
		patient = actor[i]
		lb_patient_found = true
	end if
	
	if lower(lstr_defaultrole.description) = "source" and not lb_source_found then
		source = actor[i]
		lb_patient_found = true
	end if
next

return 1

end function

public function integer process_body ();integer li_sts
string ls_tag
long i

for i = 1 to body.child_count
	ls_tag = body.child[i].getname()
	
	CHOOSE CASE lower(ls_tag)
		CASE "insurance"
			li_sts = process_insurance(get_element(body.child[i]))
		CASE "advancedirectives"
			li_sts = process_advancedirectives(get_element(body.child[i]))
		CASE "problems"
			li_sts = process_problems(get_element(body.child[i]))
		CASE "familyhistory"
			li_sts = process_familyhistory(get_element(body.child[i]))
		CASE "socialhistory"
			li_sts = process_socialhistory(get_element(body.child[i]))
		CASE "alerts"
			li_sts = process_alerts(get_element(body.child[i]))
		CASE "medications"
			li_sts = process_medications(get_element(body.child[i]))
		CASE "immunizations"
			li_sts = process_immunizations(get_element(body.child[i]))
		CASE "vitalsigns"
			li_sts = process_vitalsigns(get_element(body.child[i]))
		CASE "results"
			li_sts = process_results(get_element(body.child[i]))
		CASE "procedures"
			li_sts = process_procedures(get_element(body.child[i]))
		CASE "encounters"
// Mark - Turned off process encounters for now because display is not clear
//			li_sts = process_encounters(get_element(body.child[i]))
		CASE "planofcare"
			li_sts = process_planofcare(get_element(body.child[i]))
		CASE "practitioners"
			li_sts = process_practitioners(get_element(body.child[i]))
	END CHOOSE
next

return 1


end function

public function str_element get_child_element (ref str_element pstr_element, string ps_child_element);long i
string ls_tag
str_element lstr_element

// Initialize to not-valid in case we don't find a child
lstr_element.valid = false

// Make sure we have the children in an array
if pstr_element.child_count = 0 then
	pstr_element.element.getchildelements(pstr_element.child)
	pstr_element.child_count = upperbound(pstr_element.child)
end if

// scan the array for the named child
for i = 1 to pstr_element.child_count
	ls_tag = pstr_element.child[i].getname()
	if lower(ls_tag) = lower(ps_child_element) then
		lstr_element = get_element(pstr_element.child[i])
		exit
	end if
next

return lstr_element

end function

public function str_element get_element (pbdom_element po_element);str_element lstr_element
str_elements lstr_ids
str_code_type lstr_id
long i

if not isvalid(po_element) or isnull(po_element) then
	lstr_element.valid = false
	return lstr_element
end if

TRY
	lstr_element.element = po_element
	po_element.getchildelements(lstr_element.child)
	lstr_element.child_count = upperbound(lstr_element.child)
	
	// Get the id structures for this element
	
	lstr_ids = get_child_elements(lstr_element, "ID")
	lstr_element.id_count = lstr_ids.element_count
	
	for i = 1 to lstr_ids.element_count
		lstr_element.id[i] = get_code_type(lstr_ids.element[i])
	next
	
	lstr_element.valid = true
CATCH (pbdom_exception lo_error)
	log.log(this, "get_element()", "Error - " + lo_error.text, 4)
	lstr_element.valid = false
END TRY

return lstr_element

end function

public function integer get_actor (string ps_id, ref str_element pstr_actor);long i
str_element str_notfound

for i = 1 to actor_count
	if upper(actor_id[i]) = upper(ps_id) then
		 pstr_actor = actor[i]
		 return 1
	end if
next

return 0

end function

public function integer set_patient ();string ls_cpr_id
long i
integer li_sts
str_popup_return popup_return
str_patient lstr_patient
str_element lstr_person_element
str_name_type lstr_name
str_date_type lstr_dob
str_codeddescription_type lstr_cd
str_elements lstr_comms
str_communication_type lstr_comm

// Find the patient from the ID values supplied

for i = 1 to patient.id_count
	ls_cpr_id = sqlca.fn_lookup_patient(patient.id[i].code_type, patient.id[i].code_value)
	if len(ls_cpr_id) > 0 then exit
next

// If we didn't find a patient from the id values, then look up the patient from the demographics
if isnull(ls_cpr_id) or len(ls_cpr_id) = 0 then
	lstr_person_element = get_child_element(patient, "Person")
	if not lstr_person_element.valid then
		log.log(this, "set_patient()", "Warning - the patient actor is not a person", 3)
	else
		// Fill out what we know from the "person" element
		lstr_name = get_name_type(lstr_person_element, "Name")
		lstr_patient.first_name = lstr_name.first_name
		lstr_patient.last_name = lstr_name.last_name
		lstr_patient.middle_name = lstr_name.middle_name
		lstr_patient.name_suffix = lstr_name.suffix
		lstr_patient.degree = lstr_name.degree
		
		lstr_dob = get_date_type(lstr_person_element, "DateOfBirth")
		lstr_patient.date_of_birth = date(lstr_dob.date_and_time)
		
		lstr_patient.sex = get_cd_epro_value(lstr_person_element, "Gender", "Sex")
		
		lstr_patient.race = get_cd_epro_value(lstr_person_element, "Race", "Race")
		
		// Process the communication elements
		lstr_comms = get_child_elements(patient, "Communication")
		for i = 1 to lstr_comms.element_count
			lstr_comm = get_communication_type(lstr_comms.element[i])
			CHOOSE CASE lower(lstr_comm.communication_type)
				CASE "home phone"
					lstr_patient.phone_number = lstr_comm.value
				CASE "personal email"
					lstr_patient.email_address = lstr_comm.value
			END CHOOSE
		next
	end if
	
	openwithparm(w_patient_search, lstr_patient)
	ls_cpr_id = message.stringparm
	if isnull(ls_cpr_id) or len(ls_cpr_id) = 0 then return 0
end if

if isnull(current_patient) then
	li_sts = f_set_patient(ls_cpr_id)
	if li_sts <= 0 then return -1
	
	current_patient.encounters.last_encounter()
end if


return 1


end function

public function str_code_type get_code_type (ref str_element pstr_element);string ls_description
str_code_type lstr_code
long i

setnull(lstr_code.code_value)
setnull(lstr_code.code_type)
setnull(lstr_code.code_version)

if not pstr_element.valid then return lstr_code

// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "value"
			lstr_code.code_value = pstr_element.child[i].gettexttrim()
		CASE "type"
			lstr_code.code_type = pstr_element.child[i].gettexttrim()
		CASE "version"
			lstr_code.code_version = pstr_element.child[i].gettexttrim()
	END CHOOSE
next

return lstr_code

end function

public function str_elements get_child_elements (ref str_element pstr_element, string ps_child_element);long i
string ls_tag
str_elements lstr_elements

// Make sure we have the children in an array
if pstr_element.child_count = 0 then
	pstr_element.element.getchildelements(pstr_element.child)
	pstr_element.child_count = upperbound(pstr_element.child)
end if

// scan the array for the named child
for i = 1 to pstr_element.child_count
	ls_tag = pstr_element.child[i].getname()
	if lower(ls_tag) = lower(ps_child_element) then
		lstr_elements.element_count += 1
		lstr_elements.element[lstr_elements.element_count] = get_element(pstr_element.child[i])
	end if
next

return lstr_elements

end function

public function str_codeddescription_type get_codeddescription_type (ref str_element pstr_element);string ls_description
str_codeddescription_type lstr_description
long i

setnull(lstr_description.description)
setnull(lstr_description.code)

if not pstr_element.valid then return lstr_description


// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "description"
			lstr_description.description = pstr_element.child[i].gettexttrim()
		CASE "code"
			lstr_description.code = pstr_element.child[i].gettexttrim()
	END CHOOSE
next

return lstr_description

end function

public function str_codeddescription_type get_codeddescription_type (ref str_element pstr_element, string ps_child_element);str_element lstr_child

// First get the named child
lstr_child = get_child_element(pstr_element, ps_child_element)

return get_codeddescription_type(lstr_child)

end function

public function str_date_type get_date_type (ref str_element pstr_element);string ls_description
str_date_type lstr_date_type
long i
string ls_date_and_time
string ls_amount
string ls_unit
long ll_amount
date ld_date

setnull(lstr_date_type.date_type)
setnull(lstr_date_type.age)
setnull(lstr_date_type.date_and_time)
setnull(lstr_date_type.approximate)

if not pstr_element.valid then return lstr_date_type

// Assume that this is a "Name" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "type"
			lstr_date_type.date_type = pstr_element.child[i].gettexttrim()
		CASE "age"
			lstr_date_type.age = pstr_element.child[i].gettexttrim()
		CASE "datetime"
			ls_date_and_time = pstr_element.child[i].gettexttrim()
			lstr_date_type.date_and_time = f_xml_datetime(ls_date_and_time)
		CASE "approximate"
			lstr_date_type.approximate = pstr_element.child[i].gettexttrim()
	END CHOOSE
next

// interpret the age
if isnull(lstr_date_type.date_and_time) and not isnull(lstr_date_type.age) then
	f_split_string(lstr_date_type.age, " ", ls_amount, ls_unit)
	if isnumber(ls_amount) then
		setnull(ld_date)
		ll_amount = long(ls_amount)
		if ls_unit = "" then ls_unit = "Year"
		CHOOSE CASE upper(left(ls_unit, 1))
			CASE "D"
				ld_date = f_add_days(current_patient.date_of_birth, ll_amount)
			CASE "W"
				ld_date = f_add_weeks(current_patient.date_of_birth, ll_amount)
			CASE "M"
				ld_date = f_add_months(current_patient.date_of_birth, ll_amount)
			CASE "Y"
				ld_date = f_add_years(current_patient.date_of_birth, ll_amount)
		END CHOOSE
		if not isnull(ld_date) then
			lstr_date_type.date_and_time = datetime(ld_date, time(""))
		end if
	end if
end if

return lstr_date_type

end function

public function str_date_type get_date_type (ref str_element pstr_element, string ps_child_element);str_element lstr_child

// First get the named child
lstr_child = get_child_element(pstr_element, ps_child_element)

return get_date_type(lstr_child)

end function

public function str_name_type get_name_type (ref str_element pstr_element);string ls_description
str_name_type lstr_name_type
long i

setnull(lstr_name_type.first_name)
setnull(lstr_name_type.middle_name)
setnull(lstr_name_type.last_name)
setnull(lstr_name_type.suffix)
setnull(lstr_name_type.degree)

if not pstr_element.valid then return lstr_name_type

// Assume that this is a "Name" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "first"
			lstr_name_type.first_name = pstr_element.child[i].gettexttrim()
		CASE "middle"
			lstr_name_type.middle_name = pstr_element.child[i].gettexttrim()
		CASE "last"
			lstr_name_type.last_name = pstr_element.child[i].gettexttrim()
		CASE "suffix"
			lstr_name_type.suffix = pstr_element.child[i].gettexttrim()
		CASE "degree"
			lstr_name_type.degree = pstr_element.child[i].gettexttrim()
	END CHOOSE
next

return lstr_name_type

end function

public function str_name_type get_name_type (ref str_element pstr_element, string ps_child_element);str_element lstr_child

// First get the named child
lstr_child = get_child_element(pstr_element, ps_child_element)

return get_name_type(lstr_child)

end function

public function string get_cd_epro_value (ref str_element pstr_element, string ps_child_element, string ps_epro_domain);str_codeddescription_type lstr_cd
string ls_epro_value
string ls_null

setnull(ls_null)

// First get the named child
lstr_cd = get_codeddescription_type(pstr_element, ps_child_element)

ls_epro_value = lookup_epro_id(owner_id, ps_child_element, lstr_cd.code, lstr_cd.description, ps_epro_domain)

return ls_epro_value



end function

public function str_communication_type get_communication_type (ref str_element pstr_element);str_communication_type lstr_communication_type
long i

setnull(lstr_communication_type.value)
setnull(lstr_communication_type.communication_type)
setnull(lstr_communication_type.priority)
setnull(lstr_communication_type.status)

if not pstr_element.valid then return lstr_communication_type

// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "value"
			lstr_communication_type.value = pstr_element.child[i].gettexttrim()
		CASE "type"
			lstr_communication_type.communication_type = pstr_element.child[i].gettexttrim()
		CASE "priority"
			lstr_communication_type.priority = pstr_element.child[i].gettexttrim()
		CASE "status"
			lstr_communication_type.status = pstr_element.child[i].gettexttrim()
	END CHOOSE
next

return lstr_communication_type

end function

public function integer process_problems (str_element pstr_element);str_elements lstr_problems
str_problem_type lstr_problem
str_assessment_description lstr_assessment
long i
integer li_sts
string ls_null

setnull(ls_null)

lstr_problems = get_child_elements(pstr_element, "Problem")

problem_count = lstr_problems.element_count
problem = lstr_problems.element

for i = 1 to problem_count
	ccr_problem_id[i] = problem[i].element.getattributevalue("ID")
	lstr_problem = get_problem_type(problem[i])
	
	lstr_assessment = f_empty_assessment()
	
	lstr_assessment.end_date = find_date(lstr_problem.problem_date, "Resolved")
	
	lstr_assessment.begin_date = find_date(lstr_problem.problem_date, "Onset")
	if isnull(lstr_assessment.begin_date) then
		lstr_assessment.begin_date = find_date(lstr_problem.problem_date, "Occurence")
		if not isnull(lstr_assessment.begin_date) and isnull(lstr_assessment.end_date) then
			lstr_assessment.end_date = lstr_assessment.begin_date
		end if
	end if
	
	lstr_assessment.assessment = lstr_problem.description

	lstr_assessment.assessment_id = lookup_epro_id(owner_id, "Problem", lstr_problem.description, lstr_problem.description, "assessment_id")
	
	lstr_assessment.assessment_type = datalist.assessment_assessment_type(lstr_assessment.assessment_id)

	lstr_assessment.icd9_code = find_code(lstr_problem.code, "ICD9-CM")

	lstr_assessment.open_encounter_id = current_patient.open_encounter_id
	
	li_sts = current_patient.assessments.add_assessment(lstr_assessment)
	if li_sts > 0 then
		epro_problem_id[i] = lstr_assessment.problem_id
	else
		epro_problem_id[i] = 0
	end if
next

return 1

end function

public function integer process_insurance (str_element pstr_element);


return 1


end function

public function integer process_advancedirectives (str_element pstr_element);


return 1


end function

public function integer process_familyhistory (str_element pstr_element);


return 1


end function

public function integer process_alerts (str_element pstr_element);str_elements lstr_alerts
str_alert_type lstr_alert
str_assessment_description lstr_assessment
long i
long j
integer li_sts
string ls_null

setnull(ls_null)

lstr_alerts = get_child_elements(pstr_element, "alert")

alert_count = lstr_alerts.element_count
alert = lstr_alerts.element

for i = 1 to alert_count
	ccr_alert_id[i] = alert[i].element.getattributevalue("ID")
	lstr_alert = get_alert_type(alert[i])
	
	lstr_assessment = f_empty_assessment()
	
	lstr_assessment.end_date = find_date(lstr_alert.alert_date, "Resolved")
	
	lstr_assessment.begin_date = find_date(lstr_alert.alert_date, "Onset")
	if isnull(lstr_assessment.begin_date) then
		lstr_assessment.begin_date = find_date(lstr_alert.alert_date, "Initial Occurence")
	end if
	if isnull(lstr_assessment.begin_date) then
		lstr_assessment.begin_date = find_date(lstr_alert.alert_date, "Occurence")
		if not isnull(lstr_assessment.begin_date) and isnull(lstr_assessment.end_date) then
			lstr_assessment.end_date = lstr_assessment.begin_date
		end if
	end if
	
	lstr_assessment.assessment = lstr_alert.description

	lstr_assessment.assessment_id = lookup_epro_id(owner_id, "alert", lstr_alert.description, lstr_alert.description, "Allergy assessment_id")
	
	lstr_assessment.assessment_type = datalist.assessment_assessment_type(lstr_assessment.assessment_id)

	lstr_assessment.icd9_code = find_code(lstr_alert.code, "ICD9-CM")

	lstr_assessment.open_encounter_id = current_patient.open_encounter_id
	
	li_sts = current_patient.assessments.add_assessment(lstr_assessment)
	
	for j = 1 to upperbound(lstr_alert.reaction)
		if len(lstr_alert.reaction[j].severity) > 0 and len(lstr_alert.reaction[j].description) > 0 then
			current_patient.assessments.set_progress(lstr_assessment.problem_id, &
																	"Reaction", &
																	lstr_alert.reaction[j].severity, &
																	lstr_alert.reaction[j].description )
		end if
	next
		
	for j = 1 to upperbound(lstr_alert.causativeagent)
		if len(lstr_alert.causativeagent[j].description) > 0 then
			current_patient.assessments.set_progress(lstr_assessment.problem_id, &
																	"Causative Agent", &
																	"Agent", &
																	lstr_alert.causativeagent[j].description )
		end if
	next
next

return 1

end function

public function integer process_socialhistory (str_element pstr_element);


return 1


end function

public function integer process_immunizations (str_element pstr_element);str_elements lstr_immunizations
str_medication_type lstr_immunization
long i
integer li_sts
string ls_null
long ll_treatment_id
datetime ldt_begin_date
long ll_null
str_attributes lstr_attributes
string ls_temp
string ls_dosage_form
long j
long ll_problem_id
u_component_treatment luo_treatment
datetime ldt_expiration_date

setnull(ls_null)
setnull(ll_null)

lstr_immunizations = get_child_elements(pstr_element, "immunization")

immunization_count = lstr_immunizations.element_count
immunization = lstr_immunizations.element

for i = 1 to immunization_count
	// Reset local variables
	setnull(ls_dosage_form)
	lstr_attributes.attribute_count = 0
	
	
	ccr_immunization_id[i] = immunization[i].element.getattributevalue("ID")
	lstr_immunization = get_medication_type(immunization[i])
	
	ldt_begin_date = find_date(lstr_immunization.medication_date, "Administration Date")
	ls_temp = string(ldt_begin_date)
	f_attribute_add_attribute(lstr_attributes, "begin_date", ls_temp)
	f_attribute_add_attribute(lstr_attributes, "end_date", ls_temp)

	ls_temp = lookup_epro_id(owner_id, "immunization", lstr_immunization.brandname, lstr_immunization.genericname, "vaccine_id")
	f_attribute_add_attribute(lstr_attributes, "drug_id", ls_temp)

	ls_temp = lookup_epro_id(owner_id, "site", lstr_immunization.site, lstr_immunization.site, "location")
	f_attribute_add_attribute(lstr_attributes, "location", ls_temp)

	ls_temp = lookup_epro_id(owner_id, "manufacturer", lstr_immunization.manufacturer, lstr_immunization.manufacturer, "maker_id")
	f_attribute_add_attribute(lstr_attributes, "maker_id", ls_temp)

	f_attribute_add_attribute(lstr_attributes, "lot_number", lstr_immunization.lotnumber)

	ldt_expiration_date = find_date(lstr_immunization.medication_date, "Expiration Date")
	ls_temp = string(ldt_expiration_date)
	f_attribute_add_attribute(lstr_attributes, "expiration_date", ls_temp)

	// Now build the treatment object
	luo_treatment = f_get_treatment_component("IMMUNIZATION")
	if isnull(luo_treatment) then return -1

	luo_treatment.map_attr_to_data_columns(lstr_attributes)

	luo_treatment.treatment_description = lstr_immunization.genericname

	// See if the treatment already exists
	ll_treatment_id = current_patient.treatments.find_treatment(ldt_begin_date, luo_treatment.treatment_description)
	if isnull(ll_treatment_id) or ll_treatment_id <= 0 then
		li_sts = current_patient.treatments.new_treatment(luo_treatment, false)
		if li_sts <= 0 then
			log.log(this, "process_immunizations()", "Error creating immunization treatment (" + luo_treatment.treatment_description + ")", 4)
			return -1
		else
			ll_treatment_id = luo_treatment.treatment_id
		end if
	end if
	
	// Now attach the treatment to it's assessments
	add_treatment_indications(ll_treatment_id, lstr_immunization.indication)
next

return 1

end function

public function integer process_medications (str_element pstr_element);str_elements lstr_medications
str_medication_type lstr_medication
long i
integer li_sts
string ls_null
long ll_treatment_id
datetime ldt_begin_date
datetime ldt_end_date
string ls_drug_id
long ll_null
str_attributes lstr_attributes
string ls_temp
string ls_dose_unit
string ls_package_dose_unit
string ls_package_id
string ls_administer_unit
string ls_ccr_dosage_form
string ls_ccr_admin_string
string ls_ccr_admin_amount
string ls_ccr_admin_unit
string ls_ccr_package_dose_string
string ls_ccr_package_dose_amount
string ls_ccr_package_dose_unit
real lr_administer_per_dose
real lr_package_dose_amount
string ls_package_description
string ls_administer_method
string ls_dosage_form
u_ds_data luo_package
long ll_count
string ls_administer_frequency
long j
long ll_problem_id
u_component_treatment luo_treatment

setnull(ls_null)
setnull(ll_null)

lstr_medications = get_child_elements(pstr_element, "medication")

medication_count = lstr_medications.element_count
medication = lstr_medications.element

luo_package = CREATE u_ds_data
luo_package.set_dataobject("dw_sp_get_package_id")

for i = 1 to medication_count
	// Reset local variables
	setnull(ls_package_id)
	setnull(ls_dosage_form)
	lstr_attributes.attribute_count = 0
	
	
	ccr_medication_id[i] = medication[i].element.getattributevalue("ID")
	lstr_medication = get_medication_type(medication[i])
	
	ldt_begin_date = find_date(lstr_medication.medication_date, "Prescription Date")
	ls_temp = string(ldt_begin_date)
	f_attribute_add_attribute(lstr_attributes, "begin_date", ls_temp)

	ls_temp = lookup_epro_id(owner_id, "medication", lstr_medication.genericname, lstr_medication.brandname, "drug_id")
	f_attribute_add_attribute(lstr_attributes, "drug_id", ls_temp)
	
	ls_dose_unit = lookup_epro_id(owner_id, "unit", ls_null, lstr_medication.amount.unit, "unit_id")
	f_attribute_add_attribute(lstr_attributes, "dose_amount", lstr_medication.amount.quantity)
	f_attribute_add_attribute(lstr_attributes, "dose_unit", ls_dose_unit)

	ls_administer_frequency = lookup_epro_id(owner_id, "frequency", ls_null, lstr_medication.frequency, "administer_frequency")
	f_attribute_add_attribute(lstr_attributes, "administer_frequency", ls_administer_frequency)


	// Interpret DoseStrength
	f_split_string(lstr_medication.dosestrength, "/", ls_ccr_admin_string, ls_ccr_package_dose_string)
	if ls_ccr_package_dose_string = "" then
		// We didn't have two parts separated by "/" so get the dosing info from the med amount
		lr_package_dose_amount = 1
		ls_package_dose_unit = ls_dose_unit
	else
		// Get the package dose info
		f_split_string(ls_ccr_package_dose_string, " ", ls_ccr_package_dose_amount, ls_ccr_package_dose_unit)
		ls_package_dose_unit = lookup_epro_id(owner_id, "unit", ls_null, ls_ccr_package_dose_unit, "unit_id")
		if isnumber(ls_ccr_package_dose_amount) then
			lr_package_dose_amount = real(ls_ccr_package_dose_amount)
		else
			lr_package_dose_amount = 1
		end if
	end if

	// Get the package admin info
	f_split_string(ls_ccr_admin_string, " ", ls_ccr_admin_amount, ls_ccr_admin_unit)
	ls_administer_unit = lookup_epro_id(owner_id, "unit", ls_null, ls_ccr_admin_unit, "unit_id")
	if isnumber(ls_ccr_admin_amount) then
		lr_administer_per_dose = real(ls_ccr_admin_amount)
	else
		lr_administer_per_dose = 1
	end if
	
	
	ls_ccr_dosage_form = lstr_medication.preparation
	if isnull(ls_ccr_dosage_form) then
		setnull(ls_dosage_form)
	else
		ls_dosage_form = lookup_epro_id(owner_id, "preparation", ls_ccr_dosage_form, ls_null, "dosage_form")
	end if
	
	ls_administer_method = lookup_epro_id(owner_id, "route", lstr_medication.route, ls_null, "administer_method")
	
	// Calculate a decent package description to use if this is a new package
	ls_package_description = f_default_package_description( real(lstr_medication.amount.quantity), &
																				ls_dose_unit, &
																				lr_administer_per_dose, &
																				ls_administer_unit, &
																				ls_dosage_form)

	ll_count = luo_package.retrieve(ls_package_description, &
												ls_administer_method, &
												ls_administer_unit, &
												ls_package_dose_unit, &
												lr_administer_per_dose, &
												lr_package_dose_amount, &
												ls_dosage_form, &
												owner_id )
	if ll_count > 0 then
		ls_package_id = luo_package.object.package_id[1]
		f_attribute_add_attribute(lstr_attributes, "package_id", ls_package_id)
	end if
	
	f_attribute_add_attribute(lstr_attributes, "refills", lstr_medication.refill)

	f_attribute_add_attribute(lstr_attributes, "patient_instructions", lstr_medication.instructions)


	luo_treatment = f_get_treatment_component("MEDICATION")
	if isnull(luo_treatment) then return -1

	luo_treatment.map_attr_to_data_columns(lstr_attributes)

	luo_treatment.treatment_description = f_medication_description(luo_treatment)

	// See if the treatment already exists
	ll_treatment_id = current_patient.treatments.find_treatment(ldt_begin_date, luo_treatment.treatment_description)
	if isnull(ll_treatment_id) or ll_treatment_id <= 0 then
		li_sts = current_patient.treatments.new_treatment(luo_treatment, false)
		if li_sts <= 0 then
			log.log(this, "process_medications()", "Error creating medication treatment (" + luo_treatment.treatment_description + ")", 4)
			return -1
		else
			ll_treatment_id = luo_treatment.treatment_id
		end if
	end if
	
	// Now attach the treatment to it's assessments
	add_treatment_indications(ll_treatment_id, lstr_medication.indication)
next

DESTROY luo_package


return 1

end function

public function integer process_vitalsigns (str_element pstr_element);str_elements lstr_results
str_result_type lstr_result
long i

lstr_results = get_child_elements(pstr_element, "vitalsign")

result_count = lstr_results.element_count
result = lstr_results.element


for i = 1 to result_count
	ccr_result_id[i] = result[i].element.getattributevalue("ID")
	lstr_result = get_result_type(result[i])
	
	add_results_treatment("VITAL", lstr_result)
next


return 1


end function

public function integer process_results (str_element pstr_element);str_elements lstr_results
str_result_type lstr_result
long i

lstr_results = get_child_elements(pstr_element, "result")

result_count = lstr_results.element_count
result = lstr_results.element


for i = 1 to result_count
	ccr_result_id[i] = result[i].element.getattributevalue("ID")
	lstr_result = get_result_type(result[i])
	
	add_results_treatment("LAB", lstr_result)
next


return 1

end function

public function integer process_procedures (str_element pstr_element);str_elements lstr_procedures
str_procedure_type lstr_procedure
long i
integer li_sts
string ls_null
long ll_treatment_id
datetime ldt_begin_date
long ll_null
str_attributes lstr_attributes
string ls_temp
string ls_dosage_form
long j
long ll_problem_id
u_component_treatment luo_treatment
datetime ldt_expiration_date

setnull(ls_null)
setnull(ll_null)

lstr_procedures = get_child_elements(pstr_element, "procedure")

procedure_count = lstr_procedures.element_count
ccrprocedure = lstr_procedures.element

for i = 1 to procedure_count
	// Reset local variables
	setnull(ls_dosage_form)
	lstr_attributes.attribute_count = 0
	
	
	ccr_procedure_id[i] = ccrprocedure[i].element.getattributevalue("ID")
	lstr_procedure = get_procedure_type(ccrprocedure[i])
	
	ldt_begin_date = find_date(lstr_procedure.procedure_date, "Procedure Date")
	ls_temp = string(ldt_begin_date)
	f_attribute_add_attribute(lstr_attributes, "begin_date", ls_temp)
	f_attribute_add_attribute(lstr_attributes, "end_date", ls_temp)

	// Now build the treatment object
	luo_treatment = f_get_treatment_component("procedure")
	if isnull(luo_treatment) then return -1

	luo_treatment.map_attr_to_data_columns(lstr_attributes)

	luo_treatment.treatment_description = lstr_procedure.description

	// See if the treatment already exists
	ll_treatment_id = current_patient.treatments.find_treatment(ldt_begin_date, luo_treatment.treatment_description)
	if isnull(ll_treatment_id) or ll_treatment_id <= 0 then
		li_sts = current_patient.treatments.new_treatment(luo_treatment, false)
		if li_sts <= 0 then
			log.log(this, "process_procedures()", "Error creating procedure treatment (" + luo_treatment.treatment_description + ")", 4)
			return -1
		else
			ll_treatment_id = luo_treatment.treatment_id
		end if
	end if
	
	// Now attach the treatment to it's assessments
	add_treatment_indications(ll_treatment_id, lstr_procedure.indication)
next

return 1

end function

public function integer process_encounters (str_element pstr_element);str_elements lstr_encounters
str_encounter_type lstr_encounter
long i
integer li_sts
string ls_null
datetime ldt_encounter_date
long ll_null
string ls_temp
string ls_dosage_form
long j
long ll_encounter_count
str_encounter_description lstra_encounters[]
string ls_find
string ls_date
long ll_encounter_id

setnull(ls_null)
setnull(ll_null)

lstr_encounters = get_child_elements(pstr_element, "encounter")

encounter_count = lstr_encounters.element_count
encounter = lstr_encounters.element

for i = 1 to encounter_count
	// Reset local variables
	setnull(ls_dosage_form)
	
	ccr_encounter_id[i] = encounter[i].element.getattributevalue("ID")
	lstr_encounter = get_encounter_type(encounter[i])
	
	ldt_encounter_date = find_date(lstr_encounter.encounter_date, "Encounter Date")
	if isnull(ldt_encounter_date) then
		ldt_encounter_date = find_date(lstr_encounter.encounter_date, "Admission Date")
	end if


	// See if the encounter already exists
	ls_date = "datetime('" + string(ldt_encounter_date, "[shortdate] [time]") + "')"
	ls_find = "encounter_description='" + lstr_encounter.description + "'"
	ls_find += " and encounter_date=" + ls_date
	ll_encounter_count = current_patient.encounters.get_encounters(ls_find, lstra_encounters)
	if ll_encounter_count > 0 then
		ll_encounter_id = lstra_encounters[1].encounter_id
	else
		ll_encounter_id = current_patient.new_encounter( office_id, &
																		"SICK", &
																		ldt_encounter_date, &
																		"N", &
																		lstr_encounter.description, &
																		"!PHYSICIAN", &
																		current_scribe.user_id, &
																		false)
		if ll_encounter_id <= 0 then
			log.log(this, "process_encounters()", "Error creating encounter (" + lstr_encounter.description + ")", 4)
			return -1
		end if
	end if
	
	// Now attach the treatment to it's assessments
	add_encounter_indications(ll_encounter_id, lstr_encounter.indication)
next

return 1

end function

public function integer process_planofcare (str_element pstr_element);


return 1


end function

public function integer process_practitioners (str_element pstr_element);


return 1


end function

public function str_patientknowledge_type get_patientknowledge_type (ref str_element pstr_element);str_patientknowledge_type lstr_patientknowledge_type
long i

setnull(lstr_patientknowledge_type.description)
setnull(lstr_patientknowledge_type.reason)

if not pstr_element.valid then return lstr_patientknowledge_type

// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "description"
			lstr_patientknowledge_type.description = pstr_element.child[i].gettexttrim()
		CASE "reason"
			lstr_patientknowledge_type.reason = pstr_element.child[i].gettexttrim()
	END CHOOSE
next

return lstr_patientknowledge_type

end function

public function str_problem_type get_problem_type (ref str_element pstr_element);str_problem_type lstr_problem_type
long i
long ll_attribute_count
long ll_modifier_count
long ll_code_count
long ll_datetime_count
str_element lstr_element

setnull(lstr_problem_type.description)
setnull(lstr_problem_type.status)

if not pstr_element.valid then return lstr_problem_type

ll_attribute_count = 0
ll_modifier_count = 0
ll_code_count = 0
ll_datetime_count = 0

for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "description"
			lstr_problem_type.description = pstr_element.child[i].gettexttrim()
		CASE "attribute"
			ll_attribute_count += 1
			lstr_problem_type.attribute[ll_attribute_count] = pstr_element.child[i].gettexttrim()
		CASE "modifier"
			ll_modifier_count += 1
			lstr_problem_type.modifier[ll_modifier_count] = pstr_element.child[i].gettexttrim()
		CASE "code"
			ll_code_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_problem_type.code[ll_code_count] = get_code_type(lstr_element)
		CASE "datetime"
			ll_datetime_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_problem_type.problem_date[ll_datetime_count] = get_date_type(lstr_element)
		CASE "status"
			lstr_problem_type.status = pstr_element.child[i].gettexttrim()
		CASE "patientknowledge"
			lstr_element = get_element(pstr_element.child[i])
			lstr_problem_type.patientknowledge = get_patientknowledge_type(lstr_element)
	END CHOOSE
next

return lstr_problem_type

end function

public function datetime find_date (str_date_type pstr_dates[], string ps_date_type);integer i
datetime ldt_null

setnull(ldt_null)

for i = 1 to upperbound(pstr_dates)
	if lower(pstr_dates[i].date_type) = lower(ps_date_type) then
		return pstr_dates[i].date_and_time
	end if
next

return ldt_null

end function

public function string find_code (str_code_type pstr_codes[], string ps_code_type);integer i
string ls_null

setnull(ls_null)

for i = 1 to upperbound(pstr_codes)
	if lower(pstr_codes[i].code_type) = lower(ps_code_type) then
		return pstr_codes[i].code_value
	end if
next

return ls_null

end function

public function integer set_source ();string ls_tag
long i
str_organization_type lstr_organization
str_informationsystem_type lstr_informationsystem
str_element lstr_element

string ls_source_name
string ls_description
string ls_owner_type


for i = 1 to source.child_count
	ls_tag = source.child[i].getname()
	CHOOSE CASE lower(ls_tag)
		CASE "persion"
			log.log(this, "set_cource()", "Error - source cannot be a person", 4)
			return -1
		CASE "organization"
			lstr_element = get_element(source.child[i])
			lstr_organization = get_organization_type(lstr_element)
			ls_source_name = lstr_organization.name
			ls_owner_type = "Organization"
		CASE "informationsystem"
			lstr_element = get_element(source.child[i])
			lstr_informationsystem = get_informationsystem_type(lstr_element)
			ls_source_name = lstr_informationsystem.name
			ls_owner_type = "Information System"
	END CHOOSE
next

if isnull(ls_source_name) or len(ls_source_name) = 0 then
	log.log(this, "set_cource()", "Error - source name not found", 4)
	return -1
end if

owner_id = sqlca.jmj_owner_lookup(ls_source_name, ls_description, ls_owner_type, current_scribe.user_id)
if isnull(owner_id) then
	log.log(this, "set_cource()", "Error - unable to look up owner (" + ls_source_name + ")", 4)
	return -1
end if
	
return 1


end function

public function str_informationsystem_type get_informationsystem_type (ref str_element pstr_element);string ls_description
str_informationsystem_type lstr_informationsystem_type
long i

setnull(lstr_informationsystem_type.name)
setnull(lstr_informationsystem_type.informationsystem_type)
setnull(lstr_informationsystem_type.version)

if not pstr_element.valid then return lstr_informationsystem_type


// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "name"
			lstr_informationsystem_type.name = pstr_element.child[i].gettexttrim()
		CASE "type"
			lstr_informationsystem_type.informationsystem_type = pstr_element.child[i].gettexttrim()
		CASE "version"
			lstr_informationsystem_type.version = pstr_element.child[i].gettexttrim()
	END CHOOSE
next

return lstr_informationsystem_type

end function

public function str_organization_type get_organization_type (ref str_element pstr_element);string ls_organization
str_organization_type lstr_organization
long i

setnull(lstr_organization.name)

if not pstr_element.valid then return lstr_organization


// Assume that this is a "organization" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "name"
			lstr_organization.name = pstr_element.child[i].gettexttrim()
	END CHOOSE
next

return lstr_organization

end function

public function str_alert_type get_alert_type (ref str_element pstr_element);str_alert_type lstr_alert_type
long i
long ll_attribute_count
long ll_modifier_count
long ll_code_count
long ll_datetime_count
long ll_reaction_count
long ll_causativeagent_count
long ll_intervention_count
str_element lstr_element

setnull(lstr_alert_type.description)

if not pstr_element.valid then return lstr_alert_type

ll_attribute_count = 0
ll_modifier_count = 0
ll_code_count = 0
ll_datetime_count = 0
ll_reaction_count = 0
ll_causativeagent_count = 0
ll_intervention_count = 0

// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "description"
			lstr_alert_type.description = pstr_element.child[i].gettexttrim()
		CASE "attribute"
			ll_attribute_count += 1
			lstr_alert_type.attribute[ll_attribute_count] = pstr_element.child[i].gettexttrim()
		CASE "modifier"
			ll_modifier_count += 1
			lstr_alert_type.modifier[ll_modifier_count] = pstr_element.child[i].gettexttrim()
		CASE "code"
			ll_code_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_alert_type.code[ll_code_count] = get_code_type(lstr_element)
		CASE "reaction"
			ll_reaction_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_alert_type.reaction[ll_code_count] = get_reaction_type(lstr_element)
		CASE "causativeagent"
			ll_causativeagent_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_alert_type.causativeagent[ll_code_count] = get_codeddescription_type(lstr_element)
		CASE "datetime"
			ll_datetime_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_alert_type.alert_date[ll_datetime_count] = get_date_type(lstr_element)
		CASE "intervention"
			ll_intervention_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_alert_type.intervention[ll_code_count] = get_codeddescription_type(lstr_element)
		CASE "patientknowledge"
			lstr_element = get_element(pstr_element.child[i])
			lstr_alert_type.patientknowledge = get_patientknowledge_type(lstr_element)
	END CHOOSE
next

return lstr_alert_type

end function

public function str_reaction_type get_reaction_type (ref str_element pstr_element);string ls_reaction
str_reaction_type lstr_reaction
long i

setnull(lstr_reaction.description)
setnull(lstr_reaction.severity)

if not pstr_element.valid then return lstr_reaction


// Assume that this is a "reaction" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "description"
			lstr_reaction.description = pstr_element.child[i].gettexttrim()
		CASE "severity"
			lstr_reaction.severity = pstr_element.child[i].gettexttrim()
	END CHOOSE
next

return lstr_reaction

end function

public function str_medication_type get_medication_type (ref str_element pstr_element);str_medication_type lstr_medication_type
long i
long ll_code_count
long ll_datetime_count
long ll_indication_count
long ll_orderrxhistory_count
long ll_fulfillment_count
str_element lstr_element

setnull(lstr_medication_type.genericname)
setnull(lstr_medication_type.brandname)
setnull(lstr_medication_type.manufacturer)
setnull(lstr_medication_type.lotnumber)
setnull(lstr_medication_type.preparation)
setnull(lstr_medication_type.dosestrength)
setnull(lstr_medication_type.quantity)
setnull(lstr_medication_type.route)
setnull(lstr_medication_type.site)
setnull(lstr_medication_type.frequency)
setnull(lstr_medication_type.instructions)
setnull(lstr_medication_type.refill)

if not pstr_element.valid then return lstr_medication_type

ll_code_count = 0
ll_datetime_count = 0
ll_indication_count = 0
ll_orderrxhistory_count = 0
ll_fulfillment_count = 0

// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "genericname"
			lstr_medication_type.genericname = pstr_element.child[i].gettexttrim()
		CASE "brandname"
			lstr_medication_type.brandname = pstr_element.child[i].gettexttrim()
		CASE "manufacturer"
			lstr_medication_type.manufacturer = pstr_element.child[i].gettexttrim()
		CASE "lotnumber"
			lstr_medication_type.lotnumber = pstr_element.child[i].gettexttrim()
		CASE "preparation"
			lstr_medication_type.preparation = pstr_element.child[i].gettexttrim()
		CASE "code"
			ll_code_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_medication_type.code[ll_code_count] = get_code_type(lstr_element)
		CASE "datetime"
			ll_datetime_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_medication_type.medication_date[ll_datetime_count] = get_date_type(lstr_element)
		CASE "dosestrength"
			lstr_medication_type.dosestrength = pstr_element.child[i].gettexttrim()
		CASE "quantity"
			lstr_medication_type.quantity = pstr_element.child[i].gettexttrim()
		CASE "amount"
			lstr_element = get_element(pstr_element.child[i])
			lstr_medication_type.amount = get_amount_type(lstr_element)
		CASE "route"
			lstr_medication_type.route = pstr_element.child[i].gettexttrim()
		CASE "site"
			lstr_medication_type.site = pstr_element.child[i].gettexttrim()
		CASE "frequency"
			lstr_medication_type.frequency = pstr_element.child[i].gettexttrim()
		CASE "indication"
			ll_indication_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_medication_type.indication[ll_datetime_count] = get_indication_type(lstr_element)
		CASE "instructions"
			lstr_medication_type.instructions = pstr_element.child[i].gettexttrim()
		CASE "refill"
			lstr_medication_type.refill = pstr_element.child[i].gettexttrim()
		CASE "orderrxhistory"
			ll_orderrxhistory_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_medication_type.orderrxhistory[ll_datetime_count] = get_rxhistory_type(lstr_element)
		CASE "fulfillment"
			ll_fulfillment_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_medication_type.fulfillment[ll_datetime_count] = get_rxhistory_type(lstr_element)
	END CHOOSE
next

return lstr_medication_type

end function

public function str_amount_type get_amount_type (ref str_element pstr_element);str_amount_type lstr_amount
long i

setnull(lstr_amount.quantity)
setnull(lstr_amount.unit)

if not pstr_element.valid then return lstr_amount

// Assume that this is a "amountdDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "quantity"
			lstr_amount.quantity = pstr_element.child[i].gettexttrim()
		CASE "unit"
			lstr_amount.unit = pstr_element.child[i].gettexttrim()
	END CHOOSE
next

return lstr_amount

end function

public function str_link_type get_link_type (ref str_element pstr_element);str_link_type lstr_link
long i

setnull(lstr_link.link_type)
setnull(lstr_link.id)

if not pstr_element.valid then return lstr_link

// Assume that this is a "linkdDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "type"
			lstr_link.link_type = pstr_element.child[i].gettexttrim()
		CASE "id"
			lstr_link.id = pstr_element.child[i].gettexttrim()
	END CHOOSE
next

return lstr_link

end function

public function str_indication_type get_indication_type (ref str_element pstr_element);str_indication_type lstr_indication
str_element lstr_element
long i

setnull(lstr_indication.description)
setnull(lstr_indication.modifier)

if not pstr_element.valid then return lstr_indication

// Assume that this is a "indicationdDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "description"
			lstr_indication.description = pstr_element.child[i].gettexttrim()
		CASE "modifier"
			lstr_indication.modifier = pstr_element.child[i].gettexttrim()
		CASE "link"
			lstr_element = get_element(pstr_element.child[i])
			lstr_indication.link = get_link_type(lstr_element)
	END CHOOSE
next

return lstr_indication

end function

public function str_rxhistory_type get_rxhistory_type (ref str_element pstr_element);str_rxhistory_type lstr_rxhistory
str_element lstr_element
long i

setnull(lstr_rxhistory.rxhistory_type)

if not pstr_element.valid then return lstr_rxhistory

// Assume that this is a "rxhistorydDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "date"
			lstr_element = get_element(pstr_element.child[i])
			lstr_rxhistory.rx_date = get_date_type(lstr_element)
		CASE "type"
			lstr_rxhistory.rxhistory_type = pstr_element.child[i].gettexttrim()
		CASE "practitioner"
			lstr_element = get_element(pstr_element.child[i])
			lstr_rxhistory.practitioner = get_link_type(lstr_element)
		CASE "location"
			lstr_element = get_element(pstr_element.child[i])
			lstr_rxhistory.location = get_link_type(lstr_element)
	END CHOOSE
next

return lstr_rxhistory

end function

public function long find_epro_problem_id (string ps_ccr_problem_id);long i

for i = 1 to problem_count
	if lower(ccr_problem_id[i]) = lower(ps_ccr_problem_id) then return epro_problem_id[i]
next

return 0

end function

public function str_test_type get_test_type (ref str_element pstr_element);str_test_type lstr_test_type
long i
long ll_code_count
str_element lstr_element

setnull(lstr_test_type.description)
setnull(lstr_test_type.modifier)
setnull(lstr_test_type.value)
setnull(lstr_test_type.unit)
setnull(lstr_test_type.normalrange)
setnull(lstr_test_type.flag)

if not pstr_element.valid then return lstr_test_type

ll_code_count = 0

for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "description"
			lstr_test_type.description = pstr_element.child[i].gettexttrim()
		CASE "modifier"
			lstr_test_type.modifier = pstr_element.child[i].gettexttrim()
		CASE "code"
			ll_code_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_test_type.code[ll_code_count] = get_code_type(lstr_element)
		CASE "value"
			lstr_test_type.value = pstr_element.child[i].gettexttrim()
		CASE "unit"
			lstr_test_type.unit = pstr_element.child[i].gettexttrim()
		CASE "normalrange"
			lstr_test_type.normalrange = pstr_element.child[i].gettexttrim()
		CASE "flag"
			lstr_test_type.flag = pstr_element.child[i].gettexttrim()
	END CHOOSE
next

return lstr_test_type

end function

public function str_substance_type get_substance_type (ref str_element pstr_element);str_substance_type lstr_substance_type
long i
long ll_code_count
str_element lstr_element

setnull(lstr_substance_type.substance_type)

if not pstr_element.valid then return lstr_substance_type

ll_code_count = 0

for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "substance_type"
			lstr_substance_type.substance_type = pstr_element.child[i].gettexttrim()
		CASE "code"
			ll_code_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_substance_type.code[ll_code_count] = get_code_type(lstr_element)
	END CHOOSE
next

return lstr_substance_type

end function

public function str_result_type get_result_type (ref str_element pstr_element);str_result_type lstr_result_type
long i
long ll_code_count
long ll_datetime_count
long ll_test_count
str_element lstr_element

setnull(lstr_result_type.description)
setnull(lstr_result_type.position)
setnull(lstr_result_type.location)
setnull(lstr_result_type.method)

if not pstr_element.valid then return lstr_result_type

ll_test_count = 0
ll_code_count = 0
ll_datetime_count = 0

for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "description"
			lstr_result_type.description = pstr_element.child[i].gettexttrim()
		CASE "code"
			ll_code_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_result_type.code[ll_code_count] = get_code_type(lstr_element)
		CASE "substance"
			lstr_element = get_element(pstr_element.child[i])
			lstr_result_type.substance = get_substance_type(lstr_element)
		CASE "datetime"
			ll_datetime_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_result_type.result_date[ll_datetime_count] = get_date_type(lstr_element)
		CASE "test"
			ll_test_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_result_type.test[ll_test_count] = get_test_type(lstr_element)
		CASE "position"
			lstr_result_type.position = pstr_element.child[i].gettexttrim()
		CASE "location"
			lstr_result_type.location = pstr_element.child[i].gettexttrim()
		CASE "method"
			lstr_result_type.method = pstr_element.child[i].gettexttrim()
	END CHOOSE
next

return lstr_result_type

end function

public function integer add_results_treatment (string ps_treatment_type, str_result_type pstr_result);long i
integer li_sts
string ls_null
long ll_treatment_id
datetime ldt_begin_date
datetime ldt_end_date
long ll_null
str_attributes lstr_attributes
string ls_temp
long ll_count
u_component_treatment luo_treatment
string ls_root_observation_id
long ll_root_observation_sequence
string ls_location
integer li_null
integer li_result_sequence
string ls_result_unit
string ls_result_amount_flag
string ls_abnormal_flag
string ls_abnormal_nature

setnull(ls_null)
setnull(ll_null)
setnull(li_null)

// Reset local variables
lstr_attributes.attribute_count = 0

ldt_begin_date = find_date(pstr_result.result_date, "Sample Date/Time")
ls_temp = string(ldt_begin_date)
f_attribute_add_attribute(lstr_attributes, "begin_date", ls_temp)
f_attribute_add_attribute(lstr_attributes, "end_date", ls_temp)

ls_root_observation_id = lookup_epro_id(owner_id, "result", ls_null, pstr_result.description, "observation_id")
f_attribute_add_attribute(lstr_attributes, "observation_id", ls_root_observation_id)

// Now build the treatment object
luo_treatment = f_get_treatment_component(ps_treatment_type)
if isnull(luo_treatment) then return -1
luo_treatment.parent_patient = current_patient

luo_treatment.map_attr_to_data_columns(lstr_attributes)

luo_treatment.treatment_description = pstr_result.description

// See if the treatment already exists
ll_treatment_id = current_patient.treatments.find_treatment(ldt_begin_date, luo_treatment.treatment_description)
if isnull(ll_treatment_id) or ll_treatment_id <= 0 then
	li_sts = current_patient.treatments.new_treatment(luo_treatment, false)
	if li_sts <= 0 then
		log.log(this, "process_results()", "Error creating result treatment (" + luo_treatment.treatment_description + ")", 4)
		return -1
	else
		ll_treatment_id = luo_treatment.treatment_id
	end if
end if

// Create the root observation
ll_root_observation_sequence = luo_treatment.add_root_observation( ls_root_observation_id, ls_null, ls_null)
if ll_root_observation_sequence <= 0 then
	log.log(this, "process_results()", "Error creating result root observation (" + luo_treatment.treatment_description + ")", 4)
	return -1
end if

///////////////////////////////////////////////
// Add the collection details
///////////////////////////////////////////////

// Location
if not isnull(pstr_result.location) then
	li_result_sequence = 0
	sqlca.sp_new_observation_result( ls_root_observation_id, &
												"COLLECT", &
												"TEXT", &
												"Location", &
												"Y", &
												"N", &
												ls_null, &
												"N", &
												li_null, &
												ls_null, &
												ll_null, &
												ls_null, &
												ls_null, &
												"OK", &
												ref li_result_sequence)
	if not tf_check() then return -1
	if li_result_sequence > 0 then
		luo_treatment.add_result(	ll_root_observation_sequence, &
											li_result_sequence, &
											"NA", &
											luo_treatment.begin_date, &
											pstr_result.location, &
											"TEXT", &
											"N", &
											ls_null)
	else
		log.log(this, "process_results()", "Error creating result result (" + pstr_result.location + ")", 4)
		return -1
	end if
end if

// Position
if not isnull(pstr_result.position) then
	li_result_sequence = 0
	sqlca.sp_new_observation_result( ls_root_observation_id, &
												"COLLECT", &
												"TEXT", &
												"Position", &
												"Y", &
												"N", &
												ls_null, &
												"N", &
												li_null, &
												ls_null, &
												ll_null, &
												ls_null, &
												ls_null, &
												"OK", &
												ref li_result_sequence)
	if not tf_check() then return -1
	if li_result_sequence > 0 then
		luo_treatment.add_result(	ll_root_observation_sequence, &
											li_result_sequence, &
											"NA", &
											luo_treatment.begin_date, &
											pstr_result.position, &
											"TEXT", &
											"N", &
											ls_null)
	else
		log.log(this, "process_results()", "Error creating result result (" + pstr_result.location + ")", 4)
		return -1
	end if
end if

// Method
if not isnull(pstr_result.method) then
	li_result_sequence = 0
	sqlca.sp_new_observation_result( ls_root_observation_id, &
												"COLLECT", &
												"TEXT", &
												"Method", &
												"Y", &
												"N", &
												ls_null, &
												"N", &
												li_null, &
												ls_null, &
												ll_null, &
												ls_null, &
												ls_null, &
												"OK", &
												ref li_result_sequence)
	if not tf_check() then return -1
	if li_result_sequence > 0 then
		luo_treatment.add_result(	ll_root_observation_sequence, &
											li_result_sequence, &
											"NA", &
											luo_treatment.begin_date, &
											pstr_result.method, &
											"TEXT", &
											"N", &
											ls_null)
	else
		log.log(this, "process_results()", "Error creating result result (" + pstr_result.location + ")", 4)
		return -1
	end if
end if

// Then ddd the actual results
for i = 1 to upperbound(pstr_result.test)
	// Get the inf about the result
	if isnull(pstr_result.test[i].unit) then
		if isnull(pstr_result.test[i].value) then
			ls_result_amount_flag = "N"
			setnull(ls_result_unit)
		else
			ls_result_amount_flag = "Y"
			ls_result_unit = "NA"
		end if
	else
		ls_result_amount_flag = "Y"
		ls_result_unit = lookup_epro_id(owner_id, "testunit", ls_null, pstr_result.test[i].unit, "unit_id")
		// Mark - Workaround
		// The unit_list doesn't refresh it's list when it can't find a unit so force a re-query here
		// Remove this workaround when the unit_list has been updated to query the database when
		// a unit_id is not found in its dw cache
		unit_list.load_units()
	end if
	
	if isnull(pstr_result.test[i].flag) then
		ls_abnormal_flag = "N"
		setnull(ls_abnormal_nature)
	else
		ls_abnormal_flag = lookup_epro_id(owner_id, "testflag", ls_null, pstr_result.test[i].flag, "abnormal_flag")
		ls_abnormal_nature = lookup_epro_id(owner_id, "testflag", ls_null, pstr_result.test[i].flag, "abnormal_nature")
	end if
	
	
	li_result_sequence = 0
	sqlca.sp_new_observation_result( ls_root_observation_id, &
												"PERFORM", &
												ls_result_unit, &
												pstr_result.test[i].description, &
												ls_result_amount_flag, &
												"Y", &
												ls_null, &
												ls_abnormal_flag, &
												li_null, &
												ls_null, &
												ll_null, &
												ls_null, &
												ls_null, &
												"OK", &
												ref li_result_sequence)
	if not tf_check() then return -1
	if li_result_sequence > 0 then
		luo_treatment.add_result(	ll_root_observation_sequence, &
											li_result_sequence, &
											"NA", &
											luo_treatment.begin_date, &
											pstr_result.test[i].value, &
											ls_result_unit, &
											ls_abnormal_flag, &
											ls_abnormal_nature, &
											pstr_result.test[i].normalrange)
	else
		log.log(this, "process_results()", "Error creating result result (" + pstr_result.location + ")", 4)
		return -1
	end if
next


return 1

end function

public function str_procedure_type get_procedure_type (ref str_element pstr_element);str_procedure_type lstr_procedure_type
long i
long ll_code_count
long ll_datetime_count
long ll_indication_count
long ll_attribute_count
str_element lstr_element

setnull(lstr_procedure_type.description)

if not pstr_element.valid then return lstr_procedure_type

ll_code_count = 0
ll_datetime_count = 0
ll_indication_count = 0
ll_attribute_count = 0

// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "description"
			lstr_procedure_type.description = pstr_element.child[i].gettexttrim()
		CASE "attribute"
			ll_attribute_count += 1
			lstr_procedure_type.attribute[ll_attribute_count] = pstr_element.child[i].gettexttrim()
		CASE "code"
			ll_code_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_procedure_type.code[ll_code_count] = get_code_type(lstr_element)
		CASE "datetime"
			ll_datetime_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_procedure_type.procedure_date[ll_datetime_count] = get_date_type(lstr_element)
		CASE "indication"
			ll_indication_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_procedure_type.indication[ll_datetime_count] = get_indication_type(lstr_element)
		CASE "currenthealthstatus"
			lstr_element = get_element(pstr_element.child[i])
			lstr_procedure_type.currenthealthstatus = get_currenthealthstatus_type(lstr_element)
		CASE "patientknowledge"
			lstr_element = get_element(pstr_element.child[i])
			lstr_procedure_type.patientknowledge = get_patientknowledge_type(lstr_element)
	END CHOOSE
next

return lstr_procedure_type

end function

public function str_currenthealthstatus_type get_currenthealthstatus_type (ref str_element pstr_element);str_currenthealthstatus_type lstr_currenthealthstatus
str_element lstr_element
long i

setnull(lstr_currenthealthstatus.status)
setnull(lstr_currenthealthstatus.causeofdeath)

if not pstr_element.valid then return lstr_currenthealthstatus

// Assume that this is a "currenthealthstatusdDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "status"
			lstr_currenthealthstatus.status = pstr_element.child[i].gettexttrim()
		CASE "code"
			lstr_element = get_element(pstr_element.child[i])
			lstr_currenthealthstatus.code = get_code_type(lstr_element)
		CASE "causeofdeath"
			lstr_currenthealthstatus.causeofdeath = pstr_element.child[i].gettexttrim()
		CASE "timeofdeath"
			lstr_element = get_element(pstr_element.child[i])
			lstr_currenthealthstatus.timeofdeath = get_date_type(lstr_element)
	END CHOOSE
next

return lstr_currenthealthstatus

end function

public function integer add_treatment_indications (long pl_treatment_id, str_indication_type pstr_indications[]);long j
long ll_problem_id
boolean lb_found

// Now attach the treatment to it's assessments
for j = 1 to upperbound(pstr_indications)
	lb_found = false
	if lower(pstr_indications[j].link.link_type) = "diagnosis" then
		ll_problem_id = find_epro_problem_id(pstr_indications[j].link.id)
		if ll_problem_id > 0 then
			sqlca.sp_set_assessment_treatment( current_patient.cpr_id, &
															ll_problem_id, &
															pl_treatment_id, &
															current_patient.open_encounter_id, &
															current_scribe.user_id)
			if not tf_check() then return -1
			lb_found = true
		end if
	end if
	
	if not lb_found and len(pstr_indications[j].description) > 0 then
		current_patient.treatments.set_treatment_progress( pl_treatment_id, &
																			"Indication", &
																			pstr_indications[j].modifier, &
																			pstr_indications[j].description)
	end if
next

return 1

end function

public function str_encounter_type get_encounter_type (ref str_element pstr_element);str_encounter_type lstr_encounter_type
long i
long ll_code_count
long ll_datetime_count
long ll_indication_count
long ll_attribute_count
str_element lstr_element

setnull(lstr_encounter_type.description)

if not pstr_element.valid then return lstr_encounter_type

ll_code_count = 0
ll_datetime_count = 0
ll_indication_count = 0
ll_attribute_count = 0

// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "description"
			lstr_encounter_type.description = pstr_element.child[i].gettexttrim()
		CASE "attribute"
			ll_attribute_count += 1
			lstr_encounter_type.attribute[ll_attribute_count] = pstr_element.child[i].gettexttrim()
		CASE "code"
			ll_code_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_encounter_type.code[ll_code_count] = get_code_type(lstr_element)
		CASE "datetime"
			ll_datetime_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_encounter_type.encounter_date[ll_datetime_count] = get_date_type(lstr_element)
		CASE "indication"
			ll_indication_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_encounter_type.indication[ll_datetime_count] = get_indication_type(lstr_element)
	END CHOOSE
next

return lstr_encounter_type

end function

public function integer add_encounter_indications (long pl_encounter_id, str_indication_type pstr_indications[]);long j
long ll_problem_id
boolean lb_found
integer li_diagnosis_sequence
string ls_severity
long ll_attachment_id
long ll_patient_workplan_item_id
long ll_risk_level

setnull(li_diagnosis_sequence)
setnull(ls_severity)
setnull(ll_attachment_id)
setnull(ll_patient_workplan_item_id)
setnull(ll_risk_level)

// Now attach the treatment to it's assessments
for j = 1 to upperbound(pstr_indications)
	lb_found = false
//	if lower(pstr_indications[j].link.link_type) = "diagnosis" then
//		ll_problem_id = find_epro_problem_id(pstr_indications[j].link.id)
//		if ll_problem_id > 0 then
//			sqlca.sp_set_assessment_progress(current_patient.cpr_id, &
//														ll_problem_id, &
//														pl_encounter_id, &
//														datetime(today(), now()), &
//														li_diagnosis_sequence, &  
//														"Indication", &  
//														pstr_indications[j].modifier, &
//														pstr_indications[j].description, &
//														ls_severity, &  
//														ll_attachment_id, &
//														ll_patient_workplan_item_id, &
//														ll_risk_level, &  
//														current_user.user_id, &  
//														current_scribe.user_id)
//			if not tf_check() then return -1
//			lb_found = true
//		end if
//	end if
	
	if not lb_found and len(pstr_indications[j].description) > 0 then
		current_patient.encounters.set_encounter_progress( pl_encounter_id, &
																			"Indication", &
																			pstr_indications[j].modifier, &
																			pstr_indications[j].description)
	end if
next

return 1

end function

on u_component_xml_handler_ccr_old.create
call super::create
end on

on u_component_xml_handler_ccr_old.destroy
call super::destroy
end on

