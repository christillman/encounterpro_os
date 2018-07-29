$PBExportHeader$u_component_xml_handler_base.sru
forward
global type u_component_xml_handler_base from u_component_xml_handler
end type
end forward

global type u_component_xml_handler_base from u_component_xml_handler
end type
global u_component_xml_handler_base u_component_xml_handler_base

type variables
// Actor cache
protected long actor_count
protected str_actor_type actor[]
protected string actor_id[]

str_jmjdocumentcontext_type jmjdocumentcontext


end variables

forward prototypes
public function str_element get_child_element (ref str_element pstr_element, string ps_child_element)
public function str_element get_element (pbdom_element po_element)
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
public function str_patientknowledge_type get_patientknowledge_type (ref str_element pstr_element)
public function str_problem_type get_problem_type (ref str_element pstr_element)
public function datetime find_date (str_date_type pstr_dates[], string ps_date_type)
public function string find_code (str_code_type pstr_codes[], string ps_code_type)
public function str_informationsystem_type get_informationsystem_type (ref str_element pstr_element)
public function str_organization_type get_organization_type (ref str_element pstr_element)
public function str_alert_type get_alert_type (ref str_element pstr_element)
public function str_reaction_type get_reaction_type (ref str_element pstr_element)
public function str_medication_type get_medication_type (ref str_element pstr_element)
public function str_amount_type get_amount_type (ref str_element pstr_element)
public function str_link_type get_link_type (ref str_element pstr_element)
public function str_indication_type get_indication_type (ref str_element pstr_element)
public function str_rxhistory_type get_rxhistory_type (ref str_element pstr_element)
public function str_test_type get_test_type (ref str_element pstr_element)
public function str_substance_type get_substance_type (ref str_element pstr_element)
public function str_result_type get_result_type (ref str_element pstr_element)
public function integer add_results_treatment (string ps_treatment_type, str_result_type pstr_result)
public function str_procedure_type get_procedure_type (ref str_element pstr_element)
public function str_currenthealthstatus_type get_currenthealthstatus_type (ref str_element pstr_element)
public function str_encounter_type get_encounter_type (ref str_element pstr_element)
public function datetime get_datetime (string ps_datetime)
public function str_id_instance get_objectid_type (ref str_element pstr_element)
public function str_person_type get_person_type (ref str_element pstr_element)
public function str_address_type get_address_type (ref str_element pstr_element)
public function str_actor_type get_actor_type (ref str_element pstr_element)
public function integer get_actor (string ps_id, ref str_actor_type pstr_actor_type)
public function integer get_default_actor (ref str_actor_type pstr_actor_type)
public function str_attachment_type get_attachment_type (ref str_element pstr_element)
public function str_note_type get_note_type (ref str_element pstr_element)
public function str_context_type get_context_type (ref str_element pstr_element)
public function str_treatment_type get_treatment_type (ref str_element pstr_element)
public function str_observation_result_type get_observation_result_type (ref str_element pstr_element)
public function str_observation_type get_observation_type (ref str_element pstr_element)
public function integer get_actors (pbdom_element po_actors)
public function str_contraindication_type get_contraindication_type (ref str_element pstr_element)
public function str_objecthandling_type get_objecthandling_type (ref str_element pstr_element)
public function str_assessment_instance_type get_assessment_type (ref str_element pstr_element)
public function str_patientid_type get_patientid_type (ref str_element pstr_element)
public function str_patientrecord_type get_patientrecord_type (ref str_element pstr_element)
public function str_message_type get_message_type (ref str_element pstr_element)
public function integer send_message (str_context pstr_context, str_message_type pstr_message)
public function str_patient translate_patient_info (ref str_patientrecord_type pstr_patientrecord)
public function str_inpatient_type get_inpatient_type (ref str_element pstr_element)
public function str_outpatient_type get_outpatient_type (ref str_element pstr_element)
public function long get_object_key_from_id (str_patientrecord_type pstr_patient, string ps_context_object, string ps_object_id)
public function str_unit_type get_unit_type (ref str_element pstr_element)
public function str_amountunit_type get_amountunit_type (ref str_element pstr_element)
public function str_unit_type empty_str_unit_type ()
public function str_drugpackage_type get_drugpackage_type (ref str_element pstr_element)
public function str_frequency_type get_frequency_type (ref str_element pstr_element)
public function str_frequency_type empty_str_frequency_type ()
public function str_amountunit_type empty_str_amountunit_type ()
public function str_treatmentmedication_type get_treatmentmedication_type (ref str_element pstr_element)
public function str_treatmentmedication_type empty_str_treatmentmedication_type ()
public function str_drugpackage_type empty_str_drugpackage_type ()
public function str_encounter_description translate_encounter_info (ref str_patientrecord_type pstr_patient_info, ref str_encounter_type pstr_encounter_info)
public function str_assessment_description translate_assessment_info (ref str_patientrecord_type pstr_patient_info, ref str_assessment_instance_type pstr_assessment_info)
public function str_treatment_description translate_treatment_info (ref str_patientrecord_type pstr_patient_info, ref str_treatment_type pstr_treatment_info)
public function str_jmjdocumentcontext_type get_jmjdocumentcontext_type (ref str_element pstr_element)
public function str_jmjdocumentcontext_type empty_jmjdocumentcontext_type ()
public function str_patientrelation_type get_patientrelation_type (ref str_element pstr_element)
public function str_authority_type get_authority_type (ref str_element pstr_element)
public function str_treatment_type get_treatment_type (ref str_element pstr_element, boolean pb_is_constituent_treatment)
public function integer add_encounter_indications (string ps_cpr_id, long pl_encounter_id, str_indication_type pstr_indications[])
public function str_jmjdocument_messageid_type get_jmjdocument_messageid_type (ref str_element pstr_element)
protected function integer add_observation_and_results (long pl_treatment_id, str_treatment_description pstr_parent_treatment, str_observation_type pstr_observation, string ps_observation_tag, long pl_encounter_id, long pl_parent_observation_sequence)
end prototypes

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

// First get the named child
lstr_cd = get_codeddescription_type(pstr_element, ps_child_element)

ls_epro_value = lookup_epro_id(owner_id, ps_child_element, lstr_cd.code, lstr_cd.description, ps_epro_domain)

return ls_epro_value



end function

public function str_communication_type get_communication_type (ref str_element pstr_element);str_communication_type lstr_communication_type
long i

setnull(lstr_communication_type.communication_name)
setnull(lstr_communication_type.value)
setnull(lstr_communication_type.communication_type)
setnull(lstr_communication_type.priority)
setnull(lstr_communication_type.status)
setnull(lstr_communication_type.note)

if not pstr_element.valid then return lstr_communication_type

// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "name"
			lstr_communication_type.communication_name = pstr_element.child[i].gettexttrim()
		CASE "value"
			lstr_communication_type.value = pstr_element.child[i].gettexttrim()
		CASE "type"
			lstr_communication_type.communication_type = pstr_element.child[i].gettexttrim()
		CASE "priority"
			lstr_communication_type.priority = pstr_element.child[i].gettexttrim()
		CASE "status"
			lstr_communication_type.status = pstr_element.child[i].gettexttrim()
		CASE "note"
			lstr_communication_type.note = pstr_element.child[i].gettexttrim()
	END CHOOSE
next

return lstr_communication_type

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

public function str_informationsystem_type get_informationsystem_type (ref str_element pstr_element);string ls_description
str_informationsystem_type lstr_informationsystem_type
long i
long ll_objectid_count
str_element lstr_element

setnull(lstr_informationsystem_type.name)
setnull(lstr_informationsystem_type.informationsystem_type)
setnull(lstr_informationsystem_type.version)

if not pstr_element.valid then return lstr_informationsystem_type

ll_objectid_count = 0

// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "objectid"
			ll_objectid_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_informationsystem_type.objectid[ll_objectid_count] = get_objectid_type(lstr_element)
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
long ll_objectid_count
str_element lstr_element

setnull(lstr_organization.name)

if not pstr_element.valid then return lstr_organization

ll_objectid_count = 0

// Assume that this is a "organization" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "objectid"
			ll_objectid_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_organization.objectid[ll_objectid_count] = get_objectid_type(lstr_element)
		CASE "name"
			lstr_organization.name = pstr_element.child[i].gettexttrim()
		CASE "contact"
			lstr_element = get_element(pstr_element.child[i])
			lstr_organization.contact = get_person_type(lstr_element)
		CASE "director"
			lstr_element = get_element(pstr_element.child[i])
			lstr_organization.director = get_person_type(lstr_element)
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

luo_treatment.treatment_type = ps_treatment_type
luo_treatment.treatment_description = pstr_result.description

// See if the treatment already exists
ll_treatment_id = current_patient.treatments.find_treatment(ps_treatment_type, ldt_begin_date, luo_treatment.treatment_description)
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

public function str_encounter_type get_encounter_type (ref str_element pstr_element);str_encounter_type lstr_encounter_type
long i
string ls_date
str_element lstr_element
string ls_id
integer li_sts
str_actor_type lstr_actor
long ll_objectid_count
long ll_encounternote_count
long ll_message_count
string ls_temp

setnull(lstr_actor.actor_id)
setnull(lstr_actor.user_id)
setnull(lstr_actor.name)

setnull(lstr_encounter_type.encounterpro_encounter_id)
setnull(lstr_encounter_type.encounterid)
setnull(lstr_encounter_type.encounterdate)
setnull(lstr_encounter_type.description)
setnull(lstr_encounter_type.EncounterType)
lstr_encounter_type.attendingdoctor = f_empty_actor_type()
lstr_encounter_type.referringdoctor = f_empty_actor_type()
lstr_encounter_type.supervisingdoctor = f_empty_actor_type()
setnull(lstr_encounter_type.NewPatient)
lstr_encounter_type.EncounterLocation = f_empty_actor_type()
setnull(lstr_encounter_type.WorkersCompStatus)
setnull(lstr_encounter_type.EncounterModality)

// Default encounter handling flags
lstr_encounter_type.encounterhandling.create_flag = true
lstr_encounter_type.encounterhandling.create_ask = true
lstr_encounter_type.encounterhandling.update_flag = false
lstr_encounter_type.encounterhandling.update_ask = false

if not pstr_element.valid then return lstr_encounter_type

ll_objectid_count = 0
ll_encounternote_count = 0
ll_message_count = 0

lstr_encounter_type.EncounterID = pstr_element.element.GetAttributeValue("EncounterID")

// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "objectid"
			ll_objectid_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_encounter_type.objectid[ll_objectid_count] = get_objectid_type(lstr_element)
		CASE "encounterhandling"
			lstr_element = get_element(pstr_element.child[i])
			lstr_encounter_type.encounterhandling = get_objecthandling_type(lstr_element)
			// Go ahead and set the flags here
			CHOOSE CASE lower(lstr_encounter_type.encounterhandling.objectcreate)
				CASE "createalways"
					lstr_encounter_type.encounterhandling.create_flag = true
					lstr_encounter_type.encounterhandling.create_ask = true
				CASE "createnever"
					lstr_encounter_type.encounterhandling.create_flag = false
					lstr_encounter_type.encounterhandling.create_ask = true
			END CHOOSE
			CHOOSE CASE lower(lstr_encounter_type.encounterhandling.objectupdate)
				CASE "updatealways"
					lstr_encounter_type.encounterhandling.update_flag = true
					lstr_encounter_type.encounterhandling.update_ask = false
				CASE "updatenever"
					lstr_encounter_type.encounterhandling.update_flag = false
					lstr_encounter_type.encounterhandling.update_ask = false
				CASE "updateask"
					lstr_encounter_type.encounterhandling.update_flag = false
					lstr_encounter_type.encounterhandling.update_ask = true
			END CHOOSE
		CASE "encounterdate"
			ls_date = pstr_element.child[i].gettexttrim()
			lstr_encounter_type.encounterdate = f_xml_datetime(ls_date)
		CASE "description"
			lstr_encounter_type.description = pstr_element.child[i].gettexttrim()
		CASE "encountertype"
			lstr_encounter_type.encountertype = pstr_element.child[i].gettexttrim()
		CASE "attendingdoctor"
			ls_id = pstr_element.child[i].gettexttrim()
			li_sts = get_actor(ls_id, lstr_actor)
			if li_sts > 0 then lstr_encounter_type.attendingdoctor = lstr_actor
		CASE "referringdoctor"
			ls_id = pstr_element.child[i].gettexttrim()
			li_sts = get_actor(ls_id, lstr_actor)
			if li_sts > 0 then lstr_encounter_type.referringdoctor = lstr_actor
		CASE "supervisingdoctor"
			ls_id = pstr_element.child[i].gettexttrim()
			li_sts = get_actor(ls_id, lstr_actor)
			if li_sts > 0 then lstr_encounter_type.supervisingdoctor = lstr_actor
		CASE "newpatient"
			ls_temp = pstr_element.child[i].gettexttrim()
			if len(ls_temp) > 0 then
				lstr_encounter_type.newpatient = f_string_to_boolean(ls_temp)
			end if
		CASE "encounterlocation"
			ls_id = pstr_element.child[i].gettexttrim()
			li_sts = get_actor(ls_id, lstr_actor)
			if li_sts > 0 then lstr_encounter_type.encounterlocation = lstr_actor
		CASE "workerscompstatus"
			ls_temp = pstr_element.child[i].gettexttrim()
			if len(ls_temp) > 0 then
				lstr_encounter_type.workerscompstatus = f_string_to_boolean(ls_temp)
			end if
		CASE "inpatientstatus"
			lstr_encounter_type.EncounterModality = "Inpatient"
			lstr_element = get_element(pstr_element.child[i])
			lstr_encounter_type.inpatientstatus = get_inpatient_type(lstr_element)
		CASE "outpatientstatus"
			lstr_encounter_type.EncounterModality = "Outpatient"
			lstr_element = get_element(pstr_element.child[i])
			lstr_encounter_type.outpatientstatus = get_outpatient_type(lstr_element)
		CASE "indirectencounterstatus"
			lstr_encounter_type.EncounterModality = "Indirect"
		CASE "otherencounterstatus"
			lstr_encounter_type.EncounterModality = "Other"
		CASE "encounternote"
			ll_encounternote_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_encounter_type.encounternote[ll_encounternote_count] = get_note_type(lstr_element)
		CASE "message"
			ll_message_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_encounter_type.message[ll_message_count] = get_message_type(lstr_element)
	END CHOOSE
next

return lstr_encounter_type

end function

public function datetime get_datetime (string ps_datetime);datetime ldt_datetime
string ls_date
string ls_time


ls_date = left(ps_datetime,4)+"/"+mid(ps_datetime,5,2)+"/"+mid(ps_datetime,7,2)
ls_time = mid(ps_datetime,9,2)+":"+mid(ps_datetime,11,2)+":"+right(ps_datetime,2)

if isdate(ls_date) then
	if istime(ls_time) then
		ldt_datetime = datetime(date(ls_date), time(ls_time))
	else
		ldt_datetime = datetime(date(ls_date), time(""))
	end if
else
	setnull(ldt_datetime)
end if

return ldt_datetime


end function

public function str_id_instance get_objectid_type (ref str_element pstr_element);string ls_description
str_id_instance lstr_id
long i

lstr_id = f_empty_id_instance()

if not pstr_element.valid then return lstr_id

// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "iddomain"
			lstr_id.iddomain = pstr_element.child[i].gettexttrim()
		CASE "idvalue"
			lstr_id.idvalue = pstr_element.child[i].gettexttrim()
		CASE "jmjdomain"
			lstr_id.epro_domain = pstr_element.child[i].gettexttrim()
		CASE "jmjvalue"
			lstr_id.epro_value = pstr_element.child[i].gettexttrim()
		CASE "ownerid"
			lstr_id.owner_id = long(pstr_element.child[i].gettexttrim())
		CASE "customerid"
			lstr_id.customer_id = long(pstr_element.child[i].gettexttrim())
		CASE "patientiddomain"
			lstr_id.iddomain = pstr_element.child[i].gettexttrim()
			if lower(lstr_id.iddomain) = "jmjbillingid" then
				if isnull(lstr_id.owner_id) then lstr_id.owner_id = sqlca.customer_id
			else
				if isnull(lstr_id.owner_id) then lstr_id.owner_id = owner_id
			end if
		CASE "patientid"
			lstr_id.idvalue = pstr_element.child[i].gettexttrim()
	END CHOOSE
next

if isnull(lstr_id.owner_id) then lstr_id.owner_id = owner_id

if isnull(lstr_id.customer_id) then lstr_id.customer_id = customer_id
if isnull(lstr_id.customer_id) then lstr_id.customer_id = sqlca.customer_id

return lstr_id


end function

public function str_person_type get_person_type (ref str_element pstr_element);string ls_description
str_person_type lstr_person_type
long i
long ll_objectid_count
str_element lstr_element

setnull(lstr_person_type.lastname)
setnull(lstr_person_type.firstname)
setnull(lstr_person_type.middlename)
setnull(lstr_person_type.title)
setnull(lstr_person_type.suffix)
setnull(lstr_person_type.prefix)
setnull(lstr_person_type.degree)

if not pstr_element.valid then return lstr_person_type

ll_objectid_count = 0

// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "objectid"
			ll_objectid_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_person_type.objectid[ll_objectid_count] = get_objectid_type(lstr_element)
		CASE "lastname"
			lstr_person_type.lastname = pstr_element.child[i].gettexttrim()
		CASE "firstname"
			lstr_person_type.firstname = pstr_element.child[i].gettexttrim()
		CASE "middlename"
			lstr_person_type.middlename = pstr_element.child[i].gettexttrim()
		CASE "title"
			lstr_person_type.title = pstr_element.child[i].gettexttrim()
		CASE "suffix"
			lstr_person_type.suffix = pstr_element.child[i].gettexttrim()
		CASE "prefix"
			lstr_person_type.prefix = pstr_element.child[i].gettexttrim()
		CASE "degree"
			lstr_person_type.degree = pstr_element.child[i].gettexttrim()
	END CHOOSE
next

return lstr_person_type

end function

public function str_address_type get_address_type (ref str_element pstr_element);string ls_description
str_address_type lstr_address_type
long i
long ll_objectid_count
str_element lstr_element

setnull(lstr_address_type.description)
setnull(lstr_address_type.addressline1)
setnull(lstr_address_type.addressline2)
setnull(lstr_address_type.city)
setnull(lstr_address_type.state)
setnull(lstr_address_type.zip)
setnull(lstr_address_type.country)

if not pstr_element.valid then return lstr_address_type

ll_objectid_count = 0

// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "objectid"
			ll_objectid_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_address_type.objectid[ll_objectid_count] = get_objectid_type(lstr_element)
		CASE "description"
			lstr_address_type.description = pstr_element.child[i].gettexttrim()
		CASE "addressline1"
			lstr_address_type.addressline1 = pstr_element.child[i].gettexttrim()
		CASE "addressline2"
			lstr_address_type.addressline2 = pstr_element.child[i].gettexttrim()
		CASE "city"
			lstr_address_type.city = pstr_element.child[i].gettexttrim()
		CASE "state"
			lstr_address_type.state = pstr_element.child[i].gettexttrim()
		CASE "zip"
			lstr_address_type.zip = pstr_element.child[i].gettexttrim()
		CASE "country"
			lstr_address_type.country = pstr_element.child[i].gettexttrim()
	END CHOOSE
next

// Set the default description
if isnull(lstr_address_type.description) then
	lstr_address_type.description = "Address"
end if

return lstr_address_type

end function

public function str_actor_type get_actor_type (ref str_element pstr_element);string ls_progress_key
string ls_user_id
string ls_actor
str_actor_type lstr_actor
long i
integer li_sts
long ll_objectid_count
long ll_address_count
long ll_communication_count
str_element lstr_element
string ls_description
string ls_null
string ls_contact
string ls_director
long ll_count
long ll_temp
string ls_actor_category
datetime ldt_progress_date_time
long ll_owner_id
string ls_default_actor_class
string ls_id_domain
string ls_id_value
string ls_cpr_id
long ll_null
datetime ldt_null
str_patient lstr_patient
long ll_code_id

setnull(ll_null)
setnull(ldt_null)
setnull(ls_null)
setnull(ldt_progress_date_time)

setnull(lstr_actor.actorclass)
setnull(lstr_actor.actorcategory)
setnull(lstr_actor.actor_id)
setnull(lstr_actor.user_id)
setnull(lstr_actor.name)
setnull(ls_description)

setnull(lstr_actor.person.lastname)
setnull(lstr_actor.person.firstname)
setnull(lstr_actor.person.middlename)
setnull(lstr_actor.person.title)
setnull(lstr_actor.person.suffix)
setnull(lstr_actor.person.prefix)
setnull(lstr_actor.person.degree)

setnull(lstr_actor.organization.name)
setnull(lstr_actor.organization.director.lastname)
setnull(lstr_actor.organization.director.firstname)
setnull(lstr_actor.organization.director.middlename)
setnull(lstr_actor.organization.director.title)
setnull(lstr_actor.organization.director.suffix)
setnull(lstr_actor.organization.director.prefix)
setnull(lstr_actor.organization.director.degree)

setnull(lstr_actor.informationsystem.name)
setnull(lstr_actor.informationsystem.informationsystem_type)
setnull(lstr_actor.informationsystem.version)


if not pstr_element.valid then return lstr_actor

ll_objectid_count = 0
ll_address_count = 0
ll_communication_count = 0

ls_default_actor_class = "Person"

// Assume that this is a "actor" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "name"
			lstr_actor.name = pstr_element.child[i].gettexttrim()
		CASE "objectid"
			ll_objectid_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_actor.objectid[ll_objectid_count] = get_objectid_type(lstr_element)
		CASE "actorclass"
			lstr_actor.actorclass = pstr_element.child[i].gettexttrim()
		CASE "actorcategory"
			lstr_actor.actorcategory = pstr_element.child[i].gettexttrim()
		CASE "person"
			lstr_element = get_element(pstr_element.child[i])
			lstr_actor.person = get_person_type(lstr_element)
			ls_description = f_pretty_name(lstr_actor.person.lastname, &
																lstr_actor.person.firstname, &
																lstr_actor.person.middlename, &
																lstr_actor.person.suffix, &
																lstr_actor.person.prefix, &
																lstr_actor.person.degree )
			ls_default_actor_class = "Person"
		CASE "organization"
			lstr_element = get_element(pstr_element.child[i])
			lstr_actor.organization = get_organization_type(lstr_element)
			ls_description = lstr_actor.organization.name
			ls_default_actor_class = "Organization"
		CASE "informationsystem"
			lstr_element = get_element(pstr_element.child[i])
			lstr_actor.informationsystem = get_informationsystem_type(lstr_element)
			ls_description = lstr_actor.informationsystem.name
			ls_default_actor_class = "Information System"
		CASE "address"
			ll_address_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_actor.address[ll_address_count] = get_address_type(lstr_element)
		CASE "communication"
			ll_communication_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_actor.communication[ll_communication_count] = get_communication_type(lstr_element)
	END CHOOSE
next

if isnull(lstr_actor.name) and len(ls_description) > 0 then
	lstr_actor.name = ls_description
end if

if isnull(lstr_actor.name) or trim(lstr_actor.name) = "" then
	log.log(this, "get_actor_type()", "Actor record must have a <Name> element", 4)
	return lstr_actor
end if

// Set the default actor class if none was provided
if isnull(lstr_actor.actorclass) then lstr_actor.actorclass = ls_default_actor_class

////////////////////////////////////////////////////////////////////////////////////////////
// Attempt to lookup the actor based on the ID's provided in the ObjectID block
////////////////////////////////////////////////////////////////////////////////////////////
if lower(lstr_actor.actorclass) = "person" or lower(lstr_actor.actorclass) = "patient" then
	// the "person" actor class is really a patient
	
	// Lookup the patient from the provided IDs
	for i = 1 to upperbound(lstr_actor.objectid)
		setnull(ls_cpr_id)
		
		// If the JMJ domain/value are supplied, try that
		if len(lstr_actor.objectid[i].epro_domain) > 0 and len(lstr_actor.objectid[i].epro_value) > 0 then
			ls_cpr_id = sqlca.fn_lookup_patient2(lstr_actor.objectid[i].customer_id, lstr_actor.objectid[i].epro_domain, lstr_actor.objectid[i].epro_value)
			if not tf_check() then setnull(ls_cpr_id)
			
			if len(ls_cpr_id) > 0 and isnull(lstr_actor.user_id) then
				lstr_actor.actor_id = 0
				lstr_actor.user_id = "##" + ls_cpr_id
			end if
		end if
		
		// If a 3rd party domain/value are supplied, try that
		if len(lstr_actor.objectid[i].iddomain) > 0 and len(lstr_actor.objectid[i].idvalue) > 0 then
			ls_cpr_id = sqlca.fn_lookup_patient2(lstr_actor.objectid[i].owner_id, lstr_actor.objectid[i].iddomain, lstr_actor.objectid[i].idvalue)
			if not tf_check() then setnull(ls_cpr_id)
			
			if len(ls_cpr_id) > 0 and isnull(lstr_actor.user_id) then
				lstr_actor.actor_id = 0
				lstr_actor.user_id = "##" + ls_cpr_id
			end if
			
			// If the cpr_id is still null then we have an unmapped patient ID
			if isnull(ls_cpr_id) then
				ll_code_id = sqlca.xml_add_mapping(owner_id, lstr_actor.objectid[i].iddomain, ls_null, lstr_actor.objectid[i].idvalue, lstr_actor.name, "cpr_id", ls_cpr_id, lstr_actor.name, sqlca.customer_id, current_scribe.user_id)
				if not tf_check() then setnull(ll_code_id)
				if ll_code_id > 0 then
					log_mapping(ll_code_id, false)
				end if
			end if
		end if
		
	next
else
	for i = 1 to upperbound(lstr_actor.objectid)
		// See if the user_id was provided
		if lstr_actor.objectid[i].customer_id = sqlca.customer_id &
			AND lower(lstr_actor.objectid[i].epro_domain) = "user_id" &
			AND len(lstr_actor.objectid[i].epro_value) > 0 then
			ls_user_id = lstr_actor.objectid[i].epro_value
			// Validate the user_id by looking up the actor_id
			ll_temp = user_list.user_property(ls_user_id, "actor_id")
			if ll_temp > 0 then
				lstr_actor.actor_id = ll_temp
				lstr_actor.user_id = ls_user_id
				exit
			end if
		end if
		
		// See if the user's GUID was provided
		if lstr_actor.objectid[i].customer_id = sqlca.customer_id &
			AND lower(lstr_actor.objectid[i].epro_domain) = "id" &
			AND len(lstr_actor.objectid[i].epro_value) > 0 then
			// Find the user_id from the c_User table
			SELECT user_id
			INTO :ls_user_id
			FROM c_User
			WHERE id = :lstr_actor.objectid[i].epro_value;
			if not tf_check() then setnull(ls_user_id)
			if sqlca.sqlnrows <> 1 then setnull(ls_user_id)
			if len(ls_user_id) > 0 then
				// Validate the user_id by looking up the actor_id
				ll_temp = user_list.user_property(ls_user_id, "actor_id")
				if ll_temp > 0 then
					lstr_actor.actor_id = ll_temp
					lstr_actor.user_id = ls_user_id
					exit
				end if
			end if
		end if
		
		// Try to look up the iddomain/idvalue
		if len(lstr_actor.objectid[i].iddomain) > 0 &
			and len(lstr_actor.objectid[i].idvalue) > 0 &
			and (lower(lstr_actor.objectid[i].epro_domain) = "user_id" &
					OR isnull(lstr_actor.objectid[i].epro_domain)) then
			// Find the user_id from the c_User_Progress table
			ls_user_id = sqlca.fn_lookup_user_IDValue(lstr_actor.objectid[i].owner_id, lstr_actor.objectid[i].iddomain, lstr_actor.objectid[i].idvalue)
			if len(ls_user_id) > 0 then
				// Validate the user_id by looking up the actor_id
				ll_temp = user_list.user_property(ls_user_id, "actor_id")
				if ll_temp > 0 then
					lstr_actor.actor_id = ll_temp
					lstr_actor.user_id = ls_user_id
					exit
				end if
			else
				// If the ls_user_id is still null then we have an unmapped actor
				setnull(ls_user_id)
				ll_code_id = sqlca.xml_add_mapping(owner_id, lstr_actor.objectid[i].iddomain, ls_null, lstr_actor.objectid[i].idvalue, lstr_actor.name, lstr_actor.actorclass + ".user_id", ls_user_id, lstr_actor.name, sqlca.customer_id, current_scribe.user_id)
				if not tf_check() then setnull(ll_code_id)
				if ll_code_id > 0 then
					log_mapping(ll_code_id, false)
				end if
			end if
		end if
		
	next
end if

if isnull(lstr_actor.actor_id) then
	CHOOSE CASE lower(lstr_actor.actorclass)
		CASE "user"
			// If we don't already have a user_id then we have an error
			log.log(this, "get_actor_type()", "User not mapped (" + lstr_actor.name + ")" , 3)
		CASE "office"
			// If we don't already have a user_id then we have an error
			log.log(this, "get_actor_type()", "Office not mapped (" + lstr_actor.name + ")" , 3)
		CASE "person", "patient"
			// A "Person" actor is actually a patient, probably for a relative or guarantor or something
			lstr_patient = f_empty_patient()
			lstr_patient.last_name = lstr_actor.person.lastname
			lstr_patient.first_name = lstr_actor.person.firstname
			lstr_patient.middle_name = lstr_actor.person.middlename
			lstr_patient.name_prefix = lstr_actor.person.prefix
			lstr_patient.name_suffix = lstr_actor.person.suffix
			lstr_patient.degree = lstr_actor.person.degree
			if lower(lstr_actor.actorclass) = "person" then
				lstr_patient.patient_status = "Relation"
			else
				lstr_patient.patient_status = "Active"
			end if
			
			li_sts = f_new_patient(lstr_patient)
			if li_sts > 0 then
				lstr_actor.user_id = "##" + lstr_patient.cpr_id
				lstr_actor.actor_id = 0
			end if
		CASE ELSE
			// for any other actor class, we just create a new actor if we didn't find a match
			ls_contact = f_pretty_name(lstr_actor.organization.contact.lastname, &
												lstr_actor.organization.contact.firstname, &
												lstr_actor.organization.contact.middlename, &
												lstr_actor.organization.contact.suffix, &
												lstr_actor.organization.contact.prefix, &
												lstr_actor.organization.contact.degree)
			if trim(ls_contact) = "" then setnull(ls_contact)
			
			ls_director = f_pretty_name(lstr_actor.organization.director.lastname, &
												lstr_actor.organization.director.firstname, &
												lstr_actor.organization.director.middlename, &
												lstr_actor.organization.director.suffix, &
												lstr_actor.organization.director.prefix, &
												lstr_actor.organization.director.degree)
			if trim(ls_director) = "" then setnull(ls_director)
		
			lstr_actor.actor_id = sqlca.sp_new_actor( wordcap(lstr_actor.actorclass),&
																lstr_actor.name, &
																lstr_actor.person.lastname,&
																lstr_actor.person.firstname,&
																lstr_actor.person.middlename,&
																lstr_actor.person.prefix,&
																lstr_actor.person.suffix, &
																lstr_actor.person.degree,&
																lstr_actor.person.title,&
																lstr_actor.informationsystem.informationsystem_type,&
																lstr_actor.informationsystem.version,&
																ls_contact,&
																ls_director )
			tf_check()
			
			if lstr_actor.actor_id > 0 then
				// Lookup the user_id from the actor_id
				SELECT user_id
				INTO :lstr_actor.user_id
				FROM c_User
				WHERE actor_id = :lstr_actor.actor_id;
				tf_check()
			end if
	END CHOOSE
end if

if left(lstr_actor.user_id, 2) = "##" then
	// Patient actor
	ls_cpr_id = mid(lstr_actor.user_id, 3)
	
	// Record all the IDs for the new actor			
	for i = 1 to upperbound(lstr_actor.objectid)
		if len(lstr_actor.objectid[i].iddomain) > 0 and len(lstr_actor.objectid[i].idvalue) > 0 then
			sqlca.jmj_set_patient_idvalue(ls_cpr_id, lstr_actor.objectid[i].owner_id, lstr_actor.objectid[i].iddomain, lstr_actor.objectid[i].idvalue, current_scribe.user_id)
			tf_check()
		end if
	next
	
	// Add the addresses
	ll_count = upperbound(lstr_actor.address)
	for i = 1 to ll_count
		sqlca.sp_new_patient_address(ls_cpr_id, &
											lstr_actor.address[i].description, &
											lstr_actor.address[i].addressline1, &
											lstr_actor.address[i].addressline2, &
											lstr_actor.address[i].city, &
											lstr_actor.address[i].state, &
											lstr_actor.address[i].zip, &
											lstr_actor.address[i].country, &
											current_scribe.user_id)
		tf_check()
	next
	
	// Add the communication types
	ll_count = upperbound(lstr_actor.communication)
	for i = 1 to ll_count
		sqlca.sp_new_patient_communication(ls_cpr_id, &
													lstr_actor.communication[i].communication_type, &
													lstr_actor.communication[i].value, &
													lstr_actor.communication[i].note, &
													current_scribe.user_id, &
													lstr_actor.communication[i].communication_name)
		tf_check()
	next
elseif not isnull(lstr_actor.user_id) then
	// Add the ID mappings
	ll_count = upperbound(lstr_actor.objectid)
	for i = 1 to ll_count
		if len(lstr_actor.objectid[i].iddomain) > 0 and len(lstr_actor.objectid[i].idvalue) > 0 then
			sqlca.jmj_set_user_idvalue(lstr_actor.user_id, lstr_actor.objectid[i].owner_id, lstr_actor.objectid[i].iddomain, lstr_actor.objectid[i].idvalue, current_scribe.user_id)
			tf_check()
		end if
	next
	
	// Add the addresses
	ll_count = upperbound(lstr_actor.address)
	for i = 1 to ll_count
		sqlca.sp_new_actor_address( lstr_actor.actor_id, &
											lstr_actor.address[i].description, &
											lstr_actor.address[i].addressline1, &
											lstr_actor.address[i].addressline2, &
											lstr_actor.address[i].city, &
											lstr_actor.address[i].state, &
											lstr_actor.address[i].zip, &
											lstr_actor.address[i].country, &
											current_scribe.user_id)
		tf_check()
	next
	
	// Add the communication types
	ll_count = upperbound(lstr_actor.communication)
	for i = 1 to ll_count
		sqlca.sp_new_actor_communication( lstr_actor.actor_id, &
													lstr_actor.communication[i].communication_type, &
													lstr_actor.communication[i].value, &
													lstr_actor.communication[i].note, &
													current_scribe.user_id, &
													lstr_actor.communication[i].communication_name)
		tf_check()
	next

	if len(lstr_actor.actorcategory) > 0 then
		if len(lstr_actor.actorclass) > 0 then
			ls_progress_key = lstr_actor.actorclass + ".Category"
		else
			ls_progress_key = "Actor.Category"
		end if
		ls_actor_category = lookup_epro_id(owner_id, ls_progress_key, lstr_actor.actorcategory, lstr_actor.actorcategory, ls_progress_key)
		sqlca.sp_set_user_progress( lstr_actor.user_id, &
											current_user.user_id, &
											ldt_progress_date_time,&
											"Property", &
											ls_progress_key, &
											ls_actor_category, &
											current_scribe.user_id )
	end if
end if


return lstr_actor

end function

public function integer get_actor (string ps_id, ref str_actor_type pstr_actor_type);long i
str_element lstr_actor
integer li_sts

for i = 1 to actor_count
	if upper(actor_id[i]) = upper(ps_id) then
		 pstr_actor_type = actor[i]
		 return 1
	end if
next

return 0


end function

public function integer get_default_actor (ref str_actor_type pstr_actor_type);str_element lstr_actor

if actor_count >= 1 then
	 pstr_actor_type = actor[1]
	 return 1
end if

return 0


end function

public function str_attachment_type get_attachment_type (ref str_element pstr_element);string ls_attachment
str_attachment_type lstr_attachment
long i
long ll_objectid_count
long ll_address_count
long ll_communication_count
str_element lstr_element
string ls_description
string ls_date_and_time
string ls_data

lstr_attachment = f_empty_attachment_type()

if not pstr_element.valid then return lstr_attachment

ll_objectid_count = 0
ll_address_count = 0
ll_communication_count = 0

// Assume that this is a "attachment" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "filename"
			lstr_attachment.filename = pstr_element.child[i].gettexttrim()
		CASE "filetype"
			lstr_attachment.filetype = pstr_element.child[i].gettexttrim()
		CASE "attachmentname"
			lstr_attachment.attachmentname = pstr_element.child[i].gettexttrim()
		CASE "attachmentdata"
			ls_data = pstr_element.child[i].gettexttrim()
			lstr_attachment.attachmentdata = f_xml_blob(ls_data)
		CASE "attachmentdate"
			ls_date_and_time = pstr_element.child[i].gettexttrim()
			lstr_attachment.attachmentdate = f_xml_datetime(ls_date_and_time)
	END CHOOSE
next


return lstr_attachment

end function

public function str_note_type get_note_type (ref str_element pstr_element);integer li_sts
string ls_id
string ls_note
str_note_type lstr_note
long i
long ll_objectid_count
long ll_address_count
long ll_communication_count
str_element lstr_element
string ls_description
string ls_date_and_time
string ls_data
str_actor_type lstr_actor

setnull(lstr_note.notetype)
setnull(lstr_note.notekey)
setnull(lstr_note.notetext)
setnull(lstr_note.noteattachment.filename)
setnull(lstr_note.noteattachment.filetype)
setnull(lstr_note.noteattachment.attachmentname)
setnull(lstr_note.noteattachment.attachmentdata)
setnull(lstr_note.noteattachment.attachmentdate)
setnull(lstr_note.notedate)
setnull(lstr_note.noteseverity)
lstr_note.noteby = f_empty_actor_type()

if not pstr_element.valid then return lstr_note

ll_objectid_count = 0
ll_address_count = 0
ll_communication_count = 0

// Assume that this is a "note" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "context"
			lstr_element = get_element(pstr_element.child[i])
			lstr_note.context = get_context_type(lstr_element)
		CASE "notetype"
			lstr_note.notetype = pstr_element.child[i].gettexttrim()
		CASE "notekey"
			lstr_note.notekey = pstr_element.child[i].gettexttrim()
		CASE "notetext"
			lstr_note.notetext = pstr_element.child[i].gettexttrim()
		CASE "noteattachment"
			lstr_element = get_element(pstr_element.child[i])
			lstr_note.noteattachment = get_attachment_type(lstr_element)
		CASE "notedate"
			ls_date_and_time = pstr_element.child[i].gettexttrim()
			lstr_note.notedate = f_xml_datetime(ls_date_and_time)
		CASE "noteby"
			ls_id = pstr_element.child[i].gettexttrim()
			li_sts = get_actor(ls_id, lstr_actor)
			if li_sts > 0 then lstr_note.noteby = lstr_actor
		CASE "noteseverity"
			lstr_note.noteseverity = integer(pstr_element.child[i].gettexttrim())
	END CHOOSE
next


return lstr_note

end function

public function str_context_type get_context_type (ref str_element pstr_element);string ls_context
str_context_type lstr_context
long i
long ll_objectid_count
long ll_patientid_count
str_element lstr_element
string ls_description

setnull(lstr_context.contextobject)

if not pstr_element.valid then return lstr_context

ll_objectid_count = 0
ll_patientid_count = 0

// Assume that this is a "context" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "patientid"
			ll_patientid_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_context.patientid[ll_patientid_count] = get_objectid_type(lstr_element)
		CASE "contextobject"
			lstr_context.contextobject = pstr_element.child[i].gettexttrim()
		CASE "objectid"
			ll_objectid_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_context.objectid[ll_objectid_count] = get_objectid_type(lstr_element)
	END CHOOSE
next


return lstr_context

end function

public function str_treatment_type get_treatment_type (ref str_element pstr_element);return get_treatment_type(pstr_element, false)

end function

public function str_observation_result_type get_observation_result_type (ref str_element pstr_element);str_observation_result_type lstr_observation_result_type
long i
string ls_date
str_element lstr_element
string ls_id
integer li_sts
str_actor_type lstr_actor
long ll_objectid_count

setnull(lstr_observation_result_type.location)
setnull(lstr_observation_result_type.result_definition_id)
setnull(lstr_observation_result_type.encounter_date)
setnull(lstr_observation_result_type.resultdate)
setnull(lstr_observation_result_type.resulttype)
setnull(lstr_observation_result_type.result)
setnull(lstr_observation_result_type.resultvalue)
setnull(lstr_observation_result_type.resultunit)
lstr_observation_result_type.resultfile = f_empty_attachment_type()
setnull(lstr_observation_result_type.abnormalflag)
setnull(lstr_observation_result_type.abnormalnature)
setnull(lstr_observation_result_type.severity)
setnull(lstr_observation_result_type.referencerange)
setnull(lstr_observation_result_type.resultstatus)
lstr_observation_result_type.observedby = f_empty_actor_type()


if not pstr_element.valid then return lstr_observation_result_type

ll_objectid_count = 0

// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "objectid"
			ll_objectid_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_observation_result_type.objectid[ll_objectid_count] = get_objectid_type(lstr_element)
		CASE "location"
			lstr_observation_result_type.location = pstr_element.child[i].gettexttrim()
		CASE "result_definition_id"
			lstr_observation_result_type.result_definition_id = pstr_element.child[i].gettexttrim()
		CASE "encounter_date"
			ls_date = pstr_element.child[i].gettexttrim()
			lstr_observation_result_type.encounter_date = f_xml_datetime(ls_date)
		CASE "resultdate"
			ls_date = pstr_element.child[i].gettexttrim()
			lstr_observation_result_type.resultdate = f_xml_datetime(ls_date)
		CASE "resulttype"
			lstr_observation_result_type.resulttype = pstr_element.child[i].gettexttrim()
		CASE "result"
			lstr_observation_result_type.result = pstr_element.child[i].gettexttrim()
		CASE "resultvalue"
			lstr_observation_result_type.resultvalue = pstr_element.child[i].gettexttrim()
		CASE "resultunit"
			lstr_observation_result_type.resultunit = pstr_element.child[i].gettexttrim()
		CASE "resultfile"
			lstr_element = get_element(pstr_element.child[i])
			lstr_observation_result_type.resultfile = get_attachment_type(lstr_element)
		CASE "abnormalflag"
			lstr_observation_result_type.abnormalflag = pstr_element.child[i].gettexttrim()
		CASE "abnormalnature"
			lstr_observation_result_type.abnormalnature = pstr_element.child[i].gettexttrim()
		CASE "severity"
			lstr_observation_result_type.severity = integer(pstr_element.child[i].gettexttrim())
		CASE "observedby"
			ls_id = pstr_element.child[i].gettexttrim()
			li_sts = get_actor(ls_id, lstr_actor)
			if li_sts > 0 then lstr_observation_result_type.observedby = lstr_actor
		CASE "referencerange"
			lstr_observation_result_type.referencerange = pstr_element.child[i].gettexttrim()
		CASE "resultstatus"
			lstr_observation_result_type.resultstatus = pstr_element.child[i].gettexttrim()
	END CHOOSE
next

return lstr_observation_result_type

end function

public function str_observation_type get_observation_type (ref str_element pstr_element);str_observation_type lstr_observation_type
long i
string ls_date
str_element lstr_element
string ls_id
integer li_sts
str_actor_type lstr_actor
long ll_objectid_count
long ll_encounter_count
long ll_observationresult_count
long ll_observation_count
long ll_observationnote_count

setnull(lstr_observation_type.description)
setnull(lstr_observation_type.resultexpecteddate)
setnull(lstr_observation_type.stage)
setnull(lstr_observation_type.stagedescription)
setnull(lstr_observation_type.specimencollected)
setnull(lstr_observation_type.observationstatus)

if not pstr_element.valid then return lstr_observation_type

ll_objectid_count = 0
ll_encounter_count = 0
ll_observationresult_count = 0
ll_observation_count = 0
ll_observationnote_count = 0

// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "objectid"
			ll_objectid_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_observation_type.objectid[ll_objectid_count] = get_objectid_type(lstr_element)
		CASE "description"
			lstr_observation_type.description = pstr_element.child[i].gettexttrim()
		CASE "encounter"
			ll_encounter_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_observation_type.encounter[ll_encounter_count] = get_encounter_type(lstr_element)
		CASE "resultexpecteddate"
			ls_date = pstr_element.child[i].gettexttrim()
			lstr_observation_type.resultexpecteddate = f_xml_datetime(ls_date)
		CASE "stage"
			lstr_observation_type.stage = long(pstr_element.child[i].gettexttrim())
		CASE "stagedescription"
			lstr_observation_type.stagedescription = pstr_element.child[i].gettexttrim()
		CASE "observationresult"
			ll_observationresult_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_observation_type.observationresult[ll_observationresult_count] = get_observation_result_type(lstr_element)
		CASE "observation"
			ll_observation_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_observation_type.observation[ll_observation_count].observation = get_observation_type(lstr_element)
		CASE "observationnote"
			ll_observationnote_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_observation_type.observationnote[ll_observationnote_count] = get_note_type(lstr_element)
		CASE "specimencollected"
			ls_date = pstr_element.child[i].gettexttrim()
			lstr_observation_type.specimencollected = f_xml_datetime(ls_date)
		CASE "observationstatus"
			lstr_observation_type.observationstatus = pstr_element.child[i].gettexttrim()
	END CHOOSE
next

return lstr_observation_type

end function

public function integer get_actors (pbdom_element po_actors);long i
str_codeddescription_type lstr_defaultrole
pbdom_element lo_actor[]
str_element lstr_element
string ls_null
string ls_contact
string ls_director
long ll_count
long j
boolean lb_user_not_found

setnull(ls_null)

TRY
	po_actors.getchildelements(lo_actor)
	actor_count = upperbound(lo_actor)
CATCH (pbdom_exception lo_error)
	log.log(this, "get_actors()", "Error - " + lo_error.text, 4)
	return -1
END TRY

lb_user_not_found = false

for i = 1 to actor_count
	lstr_element = get_element(lo_actor[i])
	actor_id[i] = lo_actor[i].getattributevalue("ActorID")
	
	actor[i] = get_actor_type(lstr_element)
	if isnull(actor[i].user_id) then lb_user_not_found = true
next

if lb_user_not_found then
	return -1
end if

return 1

end function

public function str_contraindication_type get_contraindication_type (ref str_element pstr_element);str_contraindication_type lstr_contraindication_type
long i

setnull(lstr_contraindication_type.treatmentdefinitionid)
setnull(lstr_contraindication_type.treatmenttype)
setnull(lstr_contraindication_type.treatmentkey)
setnull(lstr_contraindication_type.contraindicationtype)
setnull(lstr_contraindication_type.icon)
setnull(lstr_contraindication_type.severity)
setnull(lstr_contraindication_type.shortdescription)
setnull(lstr_contraindication_type.longdescription)
setnull(lstr_contraindication_type.warning)
setnull(lstr_contraindication_type.references)

if not pstr_element.valid then return lstr_contraindication_type

// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "treatmentdefinitionid"
			lstr_contraindication_type.treatmentdefinitionid = long(pstr_element.child[i].gettexttrim())
		CASE "treatmenttype"
			lstr_contraindication_type.treatmenttype = pstr_element.child[i].gettexttrim()
		CASE "treatmentkey"
			lstr_contraindication_type.treatmentkey = pstr_element.child[i].gettexttrim()
		CASE "contraindicationtype"
			lstr_contraindication_type.contraindicationtype = pstr_element.child[i].gettexttrim()
		CASE "icon"
			lstr_contraindication_type.icon = pstr_element.child[i].gettexttrim()
		CASE "severity"
			lstr_contraindication_type.severity = long(pstr_element.child[i].gettexttrim())
		CASE "shortdescription"
			lstr_contraindication_type.shortdescription = pstr_element.child[i].gettexttrim()
		CASE "longdescription"
			lstr_contraindication_type.longdescription = pstr_element.child[i].gettexttrim()
		CASE "warning"
			lstr_contraindication_type.warning = pstr_element.child[i].gettexttrim()
		CASE "references"
			lstr_contraindication_type.references = pstr_element.child[i].gettexttrim()
	END CHOOSE
next

return lstr_contraindication_type

end function

public function str_objecthandling_type get_objecthandling_type (ref str_element pstr_element);str_objecthandling_type lstr_objecthandling
long i
str_element lstr_element
string ls_null

setnull(ls_null)

setnull(lstr_objecthandling.purpose)
setnull(lstr_objecthandling.objectcreate)
setnull(lstr_objecthandling.objectupdate)
setnull(lstr_objecthandling.notify)
setnull(lstr_objecthandling.newobjectworkflowname)
setnull(lstr_objecthandling.existingobjectworkflowname)

if not pstr_element.valid then return lstr_objecthandling


// Assume that this is a "objecthandling" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "purpose"
			lstr_objecthandling.purpose = pstr_element.child[i].gettexttrim()
		CASE "objectcreate"
			lstr_objecthandling.objectcreate = pstr_element.child[i].gettexttrim()
		CASE "objectupdate"
			lstr_objecthandling.objectupdate = pstr_element.child[i].gettexttrim()
		CASE "notify"
			lstr_objecthandling.notify = pstr_element.child[i].gettexttrim()
		CASE "newobjectworkflowname"
			lstr_objecthandling.newobjectworkflowname = pstr_element.child[i].gettexttrim()
		CASE "existingobjectworkflowname"
			lstr_objecthandling.existingobjectworkflowname = pstr_element.child[i].gettexttrim()
	END CHOOSE
next



return lstr_objecthandling

end function

public function str_assessment_instance_type get_assessment_type (ref str_element pstr_element);str_assessment_instance_type lstr_assessment_type
long i
string ls_date
str_element lstr_element
string ls_id
integer li_sts
str_actor_type lstr_actor
long ll_objectid_count
long ll_treatmentid_count
long ll_assessmentnote_count
long ll_message_count

setnull(lstr_assessment_type.assessmentdefinitionid)
setnull(lstr_assessment_type.link_openencounter)
setnull(lstr_assessment_type.assessmenttype)
setnull(lstr_assessment_type.description)
setnull(lstr_assessment_type.location)
setnull(lstr_assessment_type.acuteness)
setnull(lstr_assessment_type.ICD10)
setnull(lstr_assessment_type.begindate)
setnull(lstr_assessment_type.assessmentstatus)
setnull(lstr_assessment_type.link_closeencounter)
setnull(lstr_assessment_type.enddate)
lstr_assessment_type.diagnosedby = f_empty_actor_type()

// Default assessment handling flags
lstr_assessment_type.assessmenthandling.create_flag = true
lstr_assessment_type.assessmenthandling.create_ask = true
lstr_assessment_type.assessmenthandling.update_flag = false
lstr_assessment_type.assessmenthandling.update_ask = false

ll_objectid_count = 0
ll_treatmentid_count = 0
ll_assessmentnote_count = 0
ll_message_count = 0

if not pstr_element.valid then return lstr_assessment_type

lstr_assessment_type.AssessmentID = pstr_element.element.GetAttributeValue("AssessmentID")

// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "objectid"
			ll_objectid_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_assessment_type.objectid[ll_objectid_count] = get_objectid_type(lstr_element)
		CASE "assessmenthandling"
			lstr_element = get_element(pstr_element.child[i])
			lstr_assessment_type.assessmenthandling = get_objecthandling_type(lstr_element)
			// Go ahead and set the flags here
			CHOOSE CASE lower(lstr_assessment_type.assessmenthandling.objectcreate)
				CASE "createalways"
					lstr_assessment_type.assessmenthandling.create_flag = true
					lstr_assessment_type.assessmenthandling.create_ask = true
				CASE "createnever"
					lstr_assessment_type.assessmenthandling.create_flag = false
					lstr_assessment_type.assessmenthandling.create_ask = true
			END CHOOSE
			CHOOSE CASE lower(lstr_assessment_type.assessmenthandling.objectupdate)
				CASE "updatealways"
					lstr_assessment_type.assessmenthandling.update_flag = true
					lstr_assessment_type.assessmenthandling.update_ask = false
				CASE "updatenever"
					lstr_assessment_type.assessmenthandling.update_flag = false
					lstr_assessment_type.assessmenthandling.update_ask = false
				CASE "updateask"
					lstr_assessment_type.assessmenthandling.update_flag = false
					lstr_assessment_type.assessmenthandling.update_ask = true
			END CHOOSE
		CASE "assessmentdefinitionid"
			lstr_assessment_type.assessmentdefinitionid = pstr_element.child[i].gettexttrim()
		CASE "openencounterid"
			lstr_element = get_element(pstr_element.child[i])
			lstr_assessment_type.link_openencounter = pstr_element.child[i].gettexttrim()
		CASE "assessmenttype"
			lstr_assessment_type.assessmenttype = pstr_element.child[i].gettexttrim()
		CASE "description"
			lstr_assessment_type.description = pstr_element.child[i].gettexttrim()
		CASE "location"
			lstr_assessment_type.location = pstr_element.child[i].gettexttrim()
		CASE "acuteness"
			lstr_assessment_type.acuteness = pstr_element.child[i].gettexttrim()
		CASE "icd10"
			lstr_assessment_type.icd10 = pstr_element.child[i].gettexttrim()
		CASE "begindate"
			ls_date = pstr_element.child[i].gettexttrim()
			lstr_assessment_type.begindate = f_xml_datetime(ls_date)
		CASE "diagnosedby"
			ls_id = pstr_element.child[i].gettexttrim()
			li_sts = get_actor(ls_id, lstr_actor)
			if li_sts > 0 then lstr_assessment_type.diagnosedby = lstr_actor
		CASE "assessmentstatus"
			lstr_assessment_type.assessmentstatus = pstr_element.child[i].gettexttrim()
		CASE "closeencounterid"
			lstr_element = get_element(pstr_element.child[i])
			lstr_assessment_type.link_closeencounter = pstr_element.child[i].gettexttrim()
		CASE "enddate"
			ls_date = pstr_element.child[i].gettexttrim()
			lstr_assessment_type.enddate = f_xml_datetime(ls_date)
		CASE "treatmentid"
			lstr_element = get_element(pstr_element.child[i])
			ll_treatmentid_count += 1
			lstr_assessment_type.link_treatment[ll_treatmentid_count] = pstr_element.child[i].gettexttrim()
		CASE "assessmentnote"
			ll_assessmentnote_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_assessment_type.assessmentnote[ll_assessmentnote_count] = get_note_type(lstr_element)
		CASE "message"
			ll_message_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_assessment_type.message[ll_message_count] = get_message_type(lstr_element)
	END CHOOSE
next

return lstr_assessment_type

end function

public function str_patientid_type get_patientid_type (ref str_element pstr_element);string ls_description
str_patientid_type lstr_id
long i

setnull(lstr_id.ownerid)
setnull(lstr_id.patientiddomain)
setnull(lstr_id.patientid)

if not pstr_element.valid then return lstr_id

for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "ownerid"
			lstr_id.ownerid = long(pstr_element.child[i].gettexttrim())
		CASE "patientiddomain"
			lstr_id.patientiddomain = pstr_element.child[i].gettexttrim()
			if left(lower(lstr_id.patientiddomain), 3) = "jmj" then
				if isnull(lstr_id.ownerid) then lstr_id.ownerid = sqlca.customer_id
			else
				if isnull(lstr_id.ownerid) then lstr_id.ownerid = owner_id
			end if
		CASE "patientid"
			lstr_id.patientid = pstr_element.child[i].gettexttrim()
	END CHOOSE
next

if isnull(lstr_id.ownerid) then lstr_id.ownerid = owner_id


return lstr_id


end function

public function str_patientrecord_type get_patientrecord_type (ref str_element pstr_element);/*********************************************************************
*
*
*  Description: create patient
*
*  Return: -1 - Error
*           1 - Success
*
*
*
*
***********************************************************************/
PBDOM_Element luo_pbdom_patient_ids[]
PBDOM_Element luo_pbdom_element
long i
str_patientrecord_type lstr_patient
str_element lstr_element
str_actor_type lstr_actor
string ls_id
integer li_sts

long ll_patientid_count
long ll_communication_count
long ll_patientaddress_count
long ll_encounter_count
long ll_assessment_count
long ll_treatment_count
long ll_patientnote_count
long ll_message_count
long ll_relation_count
long ll_authority_count

setnull(lstr_patient.race)
setnull(lstr_patient.dateofbirth)
setnull(lstr_patient.timeofbirth)
setnull(lstr_patient.sex)
setnull(lstr_patient.primarylanguage)
setnull(lstr_patient.maritalstatus)
setnull(lstr_patient.ssn)
setnull(lstr_patient.firstname)
setnull(lstr_patient.lastname)
setnull(lstr_patient.degree)
setnull(lstr_patient.nameprefix)
setnull(lstr_patient.middlename)
setnull(lstr_patient.namesuffix)
setnull(lstr_patient.maidenname)
setnull(lstr_patient.patientstatus)
setnull(lstr_patient.religion)
setnull(lstr_patient.nationality)
setnull(lstr_patient.financialclass)
setnull(lstr_patient.employer)
setnull(lstr_patient.employeeid)
setnull(lstr_patient.department)
setnull(lstr_patient.shift)
setnull(lstr_patient.jobdescription)
setnull(lstr_patient.startdate)
setnull(lstr_patient.terminationdate)
setnull(lstr_patient.employmentstatus)
lstr_patient.primaryprovider = f_empty_actor_type()
lstr_patient.secondaryprovider = f_empty_actor_type()
lstr_patient.referringprovider = f_empty_actor_type()

// Default patient handling flags
lstr_patient.patienthandling.create_flag = false
lstr_patient.patienthandling.create_ask = true
lstr_patient.patienthandling.update_flag = false
lstr_patient.patienthandling.update_ask = false

ll_patientid_count = 0
ll_communication_count = 0
ll_patientaddress_count = 0
ll_encounter_count = 0
ll_assessment_count = 0
ll_treatment_count = 0
ll_patientnote_count = 0
ll_message_count = 0
ll_relation_count = 0
ll_authority_count = 0

if not pstr_element.valid then return lstr_patient

For i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "patientid"
			ll_patientid_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_patient.patientid[ll_patientid_count] = get_patientid_type(lstr_element)
		CASE "patienthandling"
			lstr_element = get_element(pstr_element.child[i])
			lstr_patient.patienthandling = get_objecthandling_type(lstr_element)
			// Go ahead and set the flags here
			CHOOSE CASE lower(lstr_patient.patienthandling.objectcreate)
				CASE "createalways"
					lstr_patient.patienthandling.create_flag = true
					lstr_patient.patienthandling.create_ask = true
				CASE "createnever"
					lstr_patient.patienthandling.create_flag = false
					lstr_patient.patienthandling.create_ask = true
			END CHOOSE
			CHOOSE CASE lower(lstr_patient.patienthandling.objectupdate)
				CASE "updatealways"
					lstr_patient.patienthandling.update_flag = true
					lstr_patient.patienthandling.update_ask = false
				CASE "updatenever"
					lstr_patient.patienthandling.update_flag = false
					lstr_patient.patienthandling.update_ask = false
				CASE "updateask"
					lstr_patient.patienthandling.update_flag = false
					lstr_patient.patienthandling.update_ask = true
			END CHOOSE
		CASE "race"
			lstr_patient.race = pstr_element.child[i].gettexttrim()
		CASE "dateofbirth"
			lstr_patient.dateofbirth = f_xml_date(pstr_element.child[i].gettexttrim())
		CASE "timeofbirth"
			lstr_patient.timeofbirth = f_xml_time(pstr_element.child[i].gettexttrim())
		CASE "sex"
			lstr_patient.sex = pstr_element.child[i].gettexttrim()
		CASE "primarylanguage"
			lstr_patient.primarylanguage = pstr_element.child[i].gettexttrim()
		CASE "maritalstatus"
			lstr_patient.maritalstatus = pstr_element.child[i].gettexttrim()
		CASE "ssn"
			lstr_patient.ssn = pstr_element.child[i].gettexttrim()
		CASE "firstname"
			lstr_patient.firstname = pstr_element.child[i].gettexttrim()
		CASE "lastname"
			lstr_patient.lastname = pstr_element.child[i].gettexttrim()
		CASE "degree"
			lstr_patient.degree = pstr_element.child[i].gettexttrim()
		CASE "nameprefix"
			lstr_patient.nameprefix = pstr_element.child[i].gettexttrim()
		CASE "middlename"
			lstr_patient.middlename = pstr_element.child[i].gettexttrim()
		CASE "namesuffix"
			lstr_patient.namesuffix = pstr_element.child[i].gettexttrim()
		CASE "maidenname"
			lstr_patient.maidenname = pstr_element.child[i].gettexttrim()
		CASE "communication"
			ll_communication_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_patient.communication[ll_communication_count] = get_communication_type(lstr_element)
		CASE "primarylocation"
			ls_id = pstr_element.child[i].gettexttrim()
			li_sts = get_actor(ls_id, lstr_actor)
			if li_sts > 0 then lstr_patient.primarylocation = lstr_actor
		CASE "patientstatus"
			lstr_patient.patientstatus = pstr_element.child[i].gettexttrim()
		CASE "patientaddress"
			ll_patientaddress_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_patient.patientaddress[ll_patientaddress_count] = get_address_type(lstr_element)
		CASE "religion"
			lstr_patient.religion = pstr_element.child[i].gettexttrim()
		CASE "nationality"
			lstr_patient.nationality = pstr_element.child[i].gettexttrim()
		CASE "financialclass"
			lstr_patient.financialclass = pstr_element.child[i].gettexttrim()
		CASE "employer"
			lstr_patient.employer = pstr_element.child[i].gettexttrim()
		CASE "employeeid"
			lstr_patient.employeeid = pstr_element.child[i].gettexttrim()
		CASE "department"
			lstr_patient.department = pstr_element.child[i].gettexttrim()
		CASE "shift"
			lstr_patient.shift = pstr_element.child[i].gettexttrim()
		CASE "jobdescription"
			lstr_patient.jobdescription = pstr_element.child[i].gettexttrim()
		CASE "startdate"
			lstr_patient.startdate = f_xml_date(pstr_element.child[i].gettexttrim())
		CASE "terminationdate"
			lstr_patient.terminationdate = f_xml_date(pstr_element.child[i].gettexttrim())
		CASE "employmentstatus"
			lstr_patient.employmentstatus = pstr_element.child[i].gettexttrim()
		CASE "relation"
			ll_relation_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_patient.relation[ll_relation_count] = get_patientrelation_type(lstr_element)
		CASE "primaryprovider"
			ls_id = pstr_element.child[i].gettexttrim()
			li_sts = get_actor(ls_id, lstr_actor)
			if li_sts > 0 then lstr_patient.primaryprovider = lstr_actor
		CASE "secondaryprovider"
			ls_id = pstr_element.child[i].gettexttrim()
			li_sts = get_actor(ls_id, lstr_actor)
			if li_sts > 0 then lstr_patient.secondaryprovider = lstr_actor
		CASE "referringprovider"
			ls_id = pstr_element.child[i].gettexttrim()
			li_sts = get_actor(ls_id, lstr_actor)
			if li_sts > 0 then lstr_patient.referringprovider = lstr_actor
		CASE "authority"
			ll_authority_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_patient.authority[ll_authority_count] = get_authority_type(lstr_element)
		CASE "encounter"
			ll_encounter_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_patient.encounter[ll_encounter_count] = get_encounter_type(lstr_element)
		CASE "assessment"
			ll_assessment_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_patient.assessment[ll_assessment_count] = get_assessment_type(lstr_element)
		CASE "treatment"
			ll_treatment_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_patient.treatment[ll_treatment_count] = get_treatment_type(lstr_element)
		CASE "patientnote"
			ll_patientnote_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_patient.patientnote[ll_patientnote_count] = get_note_type(lstr_element)
		CASE "message"
			ll_message_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_patient.message[ll_message_count] = get_message_type(lstr_element)
	END CHOOSE
next

Return lstr_patient


end function

public function str_message_type get_message_type (ref str_element pstr_element);str_message_type lstr_message_type
long i
string ls_date
str_element lstr_element
string ls_id
integer li_sts
long ll_messagerecipient_count
long ll_messageattachment_count
str_actor_type lstr_actor

setnull(lstr_message_type.messageid)
setnull(lstr_message_type.threadid)
setnull(lstr_message_type.messagesubject)
setnull(lstr_message_type.messagebody)
setnull(lstr_message_type.messagesent)
lstr_message_type.messagesender = f_empty_actor_type()

ll_messagerecipient_count = 0
ll_messageattachment_count = 0

if not pstr_element.valid then return lstr_message_type

for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "messageid"
			lstr_message_type.messageid = pstr_element.child[i].gettexttrim()
		CASE "threadid"
			lstr_message_type.threadid = pstr_element.child[i].gettexttrim()
		CASE "messagerecipient"
			ls_id = pstr_element.child[i].gettexttrim()
			li_sts = get_actor(ls_id, lstr_actor)
			if li_sts > 0 then
				ll_messagerecipient_count += 1
				lstr_message_type.messagerecipient[ll_messagerecipient_count] = lstr_actor
			end if
		CASE "messagesender"
			ls_id = pstr_element.child[i].gettexttrim()
			li_sts = get_actor(ls_id, lstr_actor)
			if li_sts > 0 then lstr_message_type.messagesender = lstr_actor
		CASE "messagesubject"
			lstr_message_type.messagesubject = pstr_element.child[i].gettexttrim()
		CASE "messagebody"
			lstr_message_type.messagebody = pstr_element.child[i].gettexttrim()
		CASE "messagesent"
			ls_date = pstr_element.child[i].gettexttrim()
			lstr_message_type.messagesent = f_xml_datetime(ls_date)
		CASE "messageattachment"
			ll_messageattachment_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_message_type.messageattachment[ll_messagerecipient_count] = get_attachment_type(lstr_element)
	END CHOOSE
next

return lstr_message_type

end function

public function integer send_message (str_context pstr_context, str_message_type pstr_message);long ll_patient_workplan_item_id
long ll_recipient_patient_workplan_item_id
long ll_recipient_count
long ll_to_user_id_count
string lsa_to_user_id[]
string ls_to_user_id
long i
long ll_encounter_id
long ll_patient_workplan_id
string ls_observation_tag
string ls_message_description
integer li_step_number
long ll_sts
string ls_attribute
string ls_null

setnull(ls_null)

ll_recipient_count = upperbound(pstr_message.messagerecipient)
if ll_recipient_count <= 0 then
	return 0
end if

ll_to_user_id_count = 0
for i = 1 to ll_recipient_count
	if len(pstr_message.messagerecipient[i].user_id) > 0 then
		ll_to_user_id_count += 1
		lsa_to_user_id[ll_to_user_id_count] = pstr_message.messagerecipient[i].user_id
	end if
next

// Make sure we found at least one to_user_id
if ll_to_user_id_count <= 0 then
	return 0
end if

if ll_to_user_id_count = 1 then
	ls_to_user_id = lsa_to_user_id[1]
else
	ls_to_user_id = "#DistList"
end if

if lower(pstr_context.context_object) = "encounter" then
	ll_encounter_id = pstr_context.object_key
else
	setnull(ll_encounter_id)
end if

ll_patient_workplan_id = 0
setnull(ls_observation_tag)
ls_message_description = left(pstr_message.messagesubject, 80)
setnull(li_step_number)

// Order the service
sqlca.sp_order_service_workplan_item( &
		pstr_context.cpr_id, &
		ll_encounter_id, &
		ll_patient_workplan_id, &
		"MESSAGE", &
		"N", &
		"N", &
		ls_observation_tag, &
		ls_message_description, &
		pstr_message.messagesender.user_id, &
		ls_to_user_id, &
		li_step_number, &
		current_scribe.user_id, &
		ll_patient_workplan_item_id)
if not tf_check() then return -1


// Set the message id
if len(pstr_message.messageid) > 0 then
	sqlca.sp_add_workplan_item_attribute( &
			pstr_context.cpr_id, &
			ll_patient_workplan_id, &
			ll_patient_workplan_item_id, &
			"message_id", &
			pstr_message.messageid, &
			current_scribe.user_id, &
			current_user.user_id)
	if not tf_check() then return -1
end if

// Set the message id
if len(pstr_message.threadid) > 0 then
	sqlca.sp_add_workplan_item_attribute( &
			pstr_context.cpr_id, &
			ll_patient_workplan_id, &
			ll_patient_workplan_item_id, &
			"thread_id", &
			pstr_message.threadid, &
			current_scribe.user_id, &
			current_user.user_id)
	if not tf_check() then return -1
end if

// Set the message subject
if len(pstr_message.messagesubject) > 0 then
	sqlca.sp_add_workplan_item_attribute( &
			pstr_context.cpr_id, &
			ll_patient_workplan_id, &
			ll_patient_workplan_item_id, &
			"message_subject", &
			pstr_message.messagesubject, &
			current_scribe.user_id, &
			current_user.user_id)
	if not tf_check() then return -1
end if

// Set the message body
if len(pstr_message.messagebody) > 0 then
	sqlca.sp_add_workplan_item_attribute( &
			pstr_context.cpr_id, &
			ll_patient_workplan_id, &
			ll_patient_workplan_item_id, &
			"message", &
			pstr_message.messagebody, &
			current_scribe.user_id, &
			current_user.user_id)
	if not tf_check() then return -1
end if

// Set the message context
sqlca.sp_add_workplan_item_attribute( &
		pstr_context.cpr_id, &
		ll_patient_workplan_id, &
		ll_patient_workplan_item_id, &
		"message_object", &
		pstr_context.context_object, &
		current_scribe.user_id, &
			current_user.user_id)
if not tf_check() then return -1

CHOOSE CASE lower(pstr_context.context_object)
	CASE "encounter"
		ls_attribute = "encounter_id"
	CASE "assessment"
		ls_attribute = "problem_id"
	CASE "treatment"
		ls_attribute = "treatment_id"
	CASE ELSE
		setnull(ls_attribute)
END CHOOSE

if not isnull(ls_attribute) then
	sqlca.sp_add_workplan_item_attribute( &
			pstr_context.cpr_id, &
			ll_patient_workplan_id, &
			ll_patient_workplan_item_id, &
			ls_attribute, &
			string(pstr_context.object_key), &
			current_scribe.user_id, &
			current_user.user_id)
	if not tf_check() then return -1
end if

// Create the recipients if this is a multi-recipient message
if ll_to_user_id_count > 1 then
	for i = 1 to ll_to_user_id_count
		ll_sts = sqlca.jmj_order_message_recipient(ll_patient_workplan_item_id, &
																lsa_to_user_id[i], &
																current_scribe.user_id, &
																ll_recipient_patient_workplan_item_id, &
																ls_null)
		if not tf_check() then return -1
	next
	
	// Show the DistList message as "Sent"
	UPDATE p_Patient_WP_Item
	SET status = 'Sent'
	WHERE patient_workplan_item_id = :ll_patient_workplan_item_id;
	if not tf_check() then return -1
end if

return 1

end function

public function str_patient translate_patient_info (ref str_patientrecord_type pstr_patientrecord);/*********************************************************************
*
*
*  Description: Interprete a str_patientrecord_type structure and put the patient data
* into a str_patient structure
*
*  Return: -1 - Error
*           1 - Success
*
*
*
*
***********************************************************************/
long i
long ll_count
string ls_null

setnull(ls_null)

str_patient lstr_patient

lstr_patient = f_empty_patient()

lstr_patient.id_list.id_count = upperbound(pstr_patientrecord.patientid)
for i = 1 to lstr_patient.id_list.id_count
	// Start with empty ID block
	lstr_patient.id_list.id[i] = f_empty_id_instance()
	lstr_patient.id_list.id[i].owner_id = owner_id // default owner is document owner
	lstr_patient.id_list.id[i].customer_id = sqlca.customer_id // default map to the local customer
	
	// Transfer from XML patient ID block to id_instance based on <patientiddomain>
	CHOOSE CASE lower(pstr_patientrecord.patientid[i].patientiddomain)
		CASE "jmjbillingid"
			// JMJ Billing ID
			lstr_patient.id_list.id[i].customer_id = pstr_patientrecord.patientid[i].ownerid
			lstr_patient.id_list.id[i].epro_domain = pstr_patientrecord.patientid[i].patientiddomain
			lstr_patient.id_list.id[i].epro_value = pstr_patientrecord.patientid[i].patientid
			
			// Also update the patient property
			lstr_patient.billing_id = lstr_patient.id_list.id[i].epro_value
		CASE "jmjcprid", "cpr_id"
			// JMJ CPR ID
			lstr_patient.id_list.id[i].customer_id = pstr_patientrecord.patientid[i].ownerid
			lstr_patient.id_list.id[i].epro_domain = pstr_patientrecord.patientid[i].patientiddomain
			lstr_patient.id_list.id[i].epro_value = pstr_patientrecord.patientid[i].patientid
		CASE "treatment_id", "encounter_id", "attachment_id", "treatment.id", "encounter.id", "problem.id", "attachment.id", "context.id"
			// Lookup via context object within chart
			lstr_patient.id_list.id[i].customer_id = pstr_patientrecord.patientid[i].ownerid
			lstr_patient.id_list.id[i].epro_domain = pstr_patientrecord.patientid[i].patientiddomain
			lstr_patient.id_list.id[i].epro_value = pstr_patientrecord.patientid[i].patientid
		CASE ELSE
			lstr_patient.id_list.id[i].owner_id = pstr_patientrecord.patientid[i].ownerid
			lstr_patient.id_list.id[i].iddomain = pstr_patientrecord.patientid[i].patientiddomain
			lstr_patient.id_list.id[i].idvalue = pstr_patientrecord.patientid[i].patientid
			lstr_patient.id_list.id[i].epro_domain = "cpr_id"
	END CHOOSE
	
next

lstr_patient.date_of_birth =  pstr_patientrecord.dateofbirth
lstr_patient.time_of_birth =  pstr_patientrecord.timeofbirth

// Standard sex mapping
if lower(pstr_patientrecord.sex) = "f" or lower(pstr_patientrecord.sex) = "female" then
	lstr_patient.sex = "F"
elseif lower(pstr_patientrecord.sex) = "m" or lower(pstr_patientrecord.sex) = "male" then
	lstr_patient.sex = "M"
end if

if len(pstr_patientrecord.race) > 0 then lstr_patient.race = pstr_patientrecord.race
if len(pstr_patientrecord.primarylanguage) > 0 then lstr_patient.primary_language =  pstr_patientrecord.primarylanguage
if len(pstr_patientrecord.maritalstatus) > 0 then lstr_patient.marital_status =  pstr_patientrecord.maritalstatus
if len(pstr_patientrecord.ssn) > 0 then lstr_patient.ssn =  pstr_patientrecord.ssn
if len(pstr_patientrecord.firstname) > 0 then lstr_patient.first_name =  pstr_patientrecord.firstname
if len(pstr_patientrecord.lastname) > 0 then lstr_patient.last_name = pstr_patientrecord.lastname
if len(pstr_patientrecord.degree) > 0 then lstr_patient.degree = pstr_patientrecord.degree
if len(pstr_patientrecord.nameprefix) > 0 then lstr_patient.name_prefix = pstr_patientrecord.nameprefix
if len(pstr_patientrecord.middlename) > 0 then lstr_patient.middle_name = pstr_patientrecord.middlename
if len(pstr_patientrecord.namesuffix) > 0 then lstr_patient.name_suffix = pstr_patientrecord.namesuffix

if len(pstr_patientrecord.primarylocation.user_id) > 0 then
	lstr_patient.office_id = user_list.user_property(pstr_patientrecord.primarylocation.user_id, "office_id")
end if

lstr_patient.primary_provider_id = pstr_patientrecord.primaryprovider.user_id
lstr_patient.secondary_provider_id = pstr_patientrecord.secondaryprovider.user_id
lstr_patient.referring_provider_id = pstr_patientrecord.referringprovider.user_id


lstr_patient.patient_status =  lookup_epro_id( owner_id, &
															"patientstatus", &
															ls_null, &
															pstr_patientrecord.patientstatus, &
															"patient_status")

ll_count = upperbound(pstr_patientrecord.communication)
for i = 1 to ll_count
	lstr_patient.communications.communication_count += 1
	lstr_patient.communications.communication[lstr_patient.communications.communication_count].communication_type = pstr_patientrecord.communication[i].communication_type
	lstr_patient.communications.communication[lstr_patient.communications.communication_count].communication_name = pstr_patientrecord.communication[i].communication_name
	lstr_patient.communications.communication[lstr_patient.communications.communication_count].communication_value = pstr_patientrecord.communication[i].value
	
	if isnull(lstr_patient.phone_number) &
		and lower(pstr_patientrecord.communication[i].communication_type) = "phone" &
		and (lower(pstr_patientrecord.communication[i].communication_name) = "phone" &
				OR isnull(lower(pstr_patientrecord.communication[i].communication_name)) &
			 ) then
		lstr_patient.phone_number = pstr_patientrecord.communication[i].value
	end if
	if isnull(lstr_patient.email_address) and lower(pstr_patientrecord.communication[i].communication_type) = "email" then
		lstr_patient.email_address = pstr_patientrecord.communication[i].value
	end if
next

ll_count = upperbound(pstr_patientrecord.patientaddress)
for i = 1 to ll_count
	if lower(pstr_patientrecord.patientaddress[i].description) = "address" OR &
		lower(pstr_patientrecord.patientaddress[i].description) = "home address" then
		lstr_patient.address_line_1 = pstr_patientrecord.patientaddress[i].addressline1
		lstr_patient.address_line_2 = pstr_patientrecord.patientaddress[i].addressline2
		lstr_patient.city = pstr_patientrecord.patientaddress[i].city
		lstr_patient.state = pstr_patientrecord.patientaddress[i].state
		lstr_patient.zip = pstr_patientrecord.patientaddress[i].zip
		lstr_patient.country = pstr_patientrecord.patientaddress[i].country
	end if
next

Return lstr_patient


end function

public function str_inpatient_type get_inpatient_type (ref str_element pstr_element);str_inpatient_type lstr_inpatient_type
long i
string ls_date
str_element lstr_element
string ls_id
integer li_sts

setnull(lstr_inpatient_type.admissiontype)
setnull(lstr_inpatient_type.admitreason)
setnull(lstr_inpatient_type.dischargedisposition)
setnull(lstr_inpatient_type.dischargedate)

if not pstr_element.valid then return lstr_inpatient_type

// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "admissiontype"
			lstr_inpatient_type.admissiontype = pstr_element.child[i].gettexttrim()
		CASE "admitreason"
			lstr_inpatient_type.admitreason = pstr_element.child[i].gettexttrim()
		CASE "dischargedisposition"
			lstr_inpatient_type.dischargedisposition = pstr_element.child[i].gettexttrim()
		CASE "dischargedate"
			ls_date = pstr_element.child[i].gettexttrim()
			lstr_inpatient_type.dischargedate = f_xml_datetime(ls_date)
	END CHOOSE
next

return lstr_inpatient_type

end function

public function str_outpatient_type get_outpatient_type (ref str_element pstr_element);str_outpatient_type lstr_outpatient_type
long i
string ls_date
str_element lstr_element
string ls_id
integer li_sts
string ls_temp

setnull(lstr_outpatient_type.appointmenttime)
setnull(lstr_outpatient_type.estappointmentlength)
setnull(lstr_outpatient_type.encounterstatus)

if not pstr_element.valid then return lstr_outpatient_type

// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "appointmenttime"
			ls_date = pstr_element.child[i].gettexttrim()
			lstr_outpatient_type.appointmenttime = f_xml_datetime(ls_date)
		CASE "estappointmentlength"
			ls_temp = pstr_element.child[i].gettexttrim()
			if isnumber(ls_temp) then
				lstr_outpatient_type.estappointmentlength = long(ls_temp)
			end if
		CASE "encounterstatus"
			lstr_outpatient_type.encounterstatus = pstr_element.child[i].gettexttrim()
		CASE "encounterenddate"
			ls_date = pstr_element.child[i].gettexttrim()
			lstr_outpatient_type.encounterenddate = f_xml_datetime(ls_date)
	END CHOOSE
next

return lstr_outpatient_type

end function

public function long get_object_key_from_id (str_patientrecord_type pstr_patient, string ps_context_object, string ps_object_id);long ll_object_key
long ll_count
long i

setnull(ll_object_key)


CHOOSE CASE lower(ps_context_object)
	CASE "encounter"
		ll_count = upperbound(pstr_patient.encounter)
		for i = 1 to ll_count
			if lower(pstr_patient.encounter[i].encounterid) = lower(ps_object_id) then
				if pstr_patient.encounter[i].encounterpro_encounter_id > 0 then
					return pstr_patient.encounter[i].encounterpro_encounter_id
				end if
				exit
			end if
		next
	CASE "assessment"
		ll_count = upperbound(pstr_patient.assessment)
		for i = 1 to ll_count
			if lower(pstr_patient.assessment[i].assessmentid) = lower(ps_object_id) then
				if pstr_patient.assessment[i].encounterpro_problem_id > 0 then
					return pstr_patient.assessment[i].encounterpro_problem_id
				end if
				exit
			end if
		next
	CASE "treatment"
		ll_count = upperbound(pstr_patient.treatment)
		for i = 1 to ll_count
			if lower(pstr_patient.treatment[i].treatmentid) = lower(ps_object_id) then
				if pstr_patient.treatment[i].encounterpro_treatment_id > 0 then
					return pstr_patient.treatment[i].encounterpro_treatment_id
				end if
				exit
			end if
		next
END CHOOSE


return ll_object_key

end function

public function str_unit_type get_unit_type (ref str_element pstr_element);str_unit_type lstr_unit_type
long i
str_element lstr_element

lstr_unit_type = empty_str_unit_type()

if not pstr_element.valid then return lstr_unit_type

// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "unitid"
			lstr_unit_type.unitid = pstr_element.child[i].gettexttrim()
		CASE "unit"
			lstr_unit_type.unit = pstr_element.child[i].gettexttrim()
		CASE "unitamounttype"
			lstr_unit_type.unitamounttype = pstr_element.child[i].gettexttrim()
		CASE "pluralrule"
			lstr_unit_type.pluralrule = pstr_element.child[i].gettexttrim()
		CASE "printunit"
			lstr_unit_type.printunit = pstr_element.child[i].gettexttrim()
		CASE "displaytemplate"
			lstr_unit_type.displaytemplate = pstr_element.child[i].gettexttrim()
		CASE "prefix"
			lstr_unit_type.prefix = pstr_element.child[i].gettexttrim()
		CASE "majorunitdisplaysuffix"
			lstr_unit_type.majorunitdisplaysuffix = pstr_element.child[i].gettexttrim()
		CASE "minorunitdisplaysuffix"
			lstr_unit_type.minorunitdisplaysuffix = pstr_element.child[i].gettexttrim()
		CASE "majorunitinputsuffix"
			lstr_unit_type.majorunitinputsuffix = pstr_element.child[i].gettexttrim()
		CASE "minorunitinputsuffix"
			lstr_unit_type.minorunitinputsuffix = pstr_element.child[i].gettexttrim()
		CASE "majorminormultiplier"
			lstr_unit_type.majorminormultiplier = pstr_element.child[i].gettexttrim()
		CASE "displayminorunits"
			lstr_unit_type.displayminorunits = pstr_element.child[i].gettexttrim()
	END CHOOSE
next

return lstr_unit_type

end function

public function str_amountunit_type get_amountunit_type (ref str_element pstr_element);string ls_amountunit
str_amountunit_type lstr_amountunit
long i
str_element lstr_element
string ls_temp

setnull(lstr_amountunit.amount)
lstr_amountunit.unit = empty_str_unit_type()

if not pstr_element.valid then return lstr_amountunit

// Assume that this is a "amountunit" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "amount"
			lstr_amountunit.amount = pstr_element.child[i].gettexttrim()
		CASE "unit"
			lstr_element = get_element(pstr_element.child[i])
			lstr_amountunit.unit = get_unit_type(lstr_element)
			
			// if the unit structure doesn't have a unit field, then see if this element has a value
			if isnull(lstr_amountunit.unit.unit) then
				ls_temp = pstr_element.child[i].gettexttrim()
				if len(ls_temp) > 0 then
					lstr_amountunit.unit.unit = ls_temp
				end if
			end if
	END CHOOSE
next

return lstr_amountunit

end function

public function str_unit_type empty_str_unit_type ();str_unit_type lstr_unit_type

setnull(lstr_unit_type.unitid)
setnull(lstr_unit_type.unit)
setnull(lstr_unit_type.unitamounttype)
setnull(lstr_unit_type.pluralrule)
setnull(lstr_unit_type.printunit)
setnull(lstr_unit_type.displaytemplate)
setnull(lstr_unit_type.prefix)
setnull(lstr_unit_type.majorunitdisplaysuffix)
setnull(lstr_unit_type.minorunitdisplaysuffix)
setnull(lstr_unit_type.majorunitinputsuffix)
setnull(lstr_unit_type.minorunitinputsuffix)
setnull(lstr_unit_type.majorminormultiplier)
setnull(lstr_unit_type.displayminorunits)

return lstr_unit_type

end function

public function str_drugpackage_type get_drugpackage_type (ref str_element pstr_element);str_drugpackage_type lstr_drugpackage_type
long i
string ls_date
str_element lstr_element
string ls_id
integer li_sts
str_actor_type lstr_actor
long ll_objectid_count

lstr_drugpackage_type = empty_str_drugpackage_type( )

ll_objectid_count = 0

if not pstr_element.valid then return lstr_drugpackage_type

// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "packageid"
			lstr_drugpackage_type.packageid = pstr_element.child[i].gettexttrim()
		CASE "objectid"
			ll_objectid_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_drugpackage_type.objectid[ll_objectid_count] = get_objectid_type(lstr_element)
		CASE "administermethod"
			lstr_drugpackage_type.administermethod = pstr_element.child[i].gettexttrim()
		CASE "description"
			lstr_drugpackage_type.description = pstr_element.child[i].gettexttrim()
		CASE "dose"
			lstr_element = get_element(pstr_element.child[i])
			lstr_drugpackage_type.dose = get_amountunit_type(lstr_element)
		CASE "administerperdose"
			lstr_element = get_element(pstr_element.child[i])
			lstr_drugpackage_type.administerperdose = get_amountunit_type(lstr_element)
		CASE "dosageform"
			lstr_drugpackage_type.dosageform = pstr_element.child[i].gettexttrim()
	END CHOOSE
next

return lstr_drugpackage_type

end function

public function str_frequency_type get_frequency_type (ref str_element pstr_element);string ls_frequency
str_frequency_type lstr_frequency
long i
str_element lstr_element
string ls_temp

setnull(lstr_frequency.abbreviation)
setnull(lstr_frequency.description)
setnull(lstr_frequency.timesperdaycalc)

if not pstr_element.valid then return lstr_frequency

// Assume that this is a "frequency" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "abbreviation"
			lstr_frequency.abbreviation = pstr_element.child[i].gettexttrim()
		CASE "description"
			lstr_frequency.description = pstr_element.child[i].gettexttrim()
		CASE "timesperdaycalc"
			ls_temp = pstr_element.child[i].gettexttrim()
			if isnumber(ls_temp) then
				lstr_frequency.timesperdaycalc = dec(ls_temp)
			end if
	END CHOOSE
next

return lstr_frequency

end function

public function str_frequency_type empty_str_frequency_type ();str_frequency_type lstr_frequency_type

setnull(lstr_frequency_type.abbreviation)
setnull(lstr_frequency_type.description)
setnull(lstr_frequency_type.timesperdaycalc)

return lstr_frequency_type

end function

public function str_amountunit_type empty_str_amountunit_type ();str_amountunit_type lstr_amountunit_type

setnull(lstr_amountunit_type.amount)
lstr_amountunit_type.unit = empty_str_unit_type()

return lstr_amountunit_type

end function

public function str_treatmentmedication_type get_treatmentmedication_type (ref str_element pstr_element);str_treatmentmedication_type lstr_treatmentmedication_type
long i
string ls_date
str_element lstr_element
string ls_id
integer li_sts
str_actor_type lstr_actor
long ll_objectid_count
string ls_temp

lstr_treatmentmedication_type = empty_str_treatmentmedication_type( )

if not pstr_element.valid then return lstr_treatmentmedication_type

ll_objectid_count = 0

for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "drugid"
			lstr_treatmentmedication_type.drugid = pstr_element.child[i].gettexttrim()
		CASE "objectid"
			ll_objectid_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_treatmentmedication_type.objectid[ll_objectid_count] = get_objectid_type(lstr_element)
		CASE "commonname"
			lstr_treatmentmedication_type.commonname = pstr_element.child[i].gettexttrim()
		CASE "genericname"
			lstr_treatmentmedication_type.genericname = pstr_element.child[i].gettexttrim()
		CASE "brandname"
			lstr_treatmentmedication_type.brandname = pstr_element.child[i].gettexttrim()
		CASE "lotnumber"
			lstr_treatmentmedication_type.lotnumber = pstr_element.child[i].gettexttrim()
		CASE "expirationdate"
			ls_date = pstr_element.child[i].gettexttrim()
			lstr_treatmentmedication_type.expirationdate = f_xml_datetime(ls_date)
		CASE "manufacturer"
			lstr_treatmentmedication_type.manufacturer = pstr_element.child[i].gettexttrim()
		CASE "package"
			lstr_element = get_element(pstr_element.child[i])
			lstr_treatmentmedication_type.package = get_drugpackage_type(lstr_element)
		CASE "dosinginstructions"
			lstr_treatmentmedication_type.dosinginstructions = pstr_element.child[i].gettexttrim()
		CASE "admininstructions"
			lstr_treatmentmedication_type.admininstructions = pstr_element.child[i].gettexttrim()
		CASE "patientinstructions"
			lstr_treatmentmedication_type.patientinstructions = pstr_element.child[i].gettexttrim()
		CASE "pharmacistinstructions"
			lstr_treatmentmedication_type.pharmacistinstructions = pstr_element.child[i].gettexttrim()
		CASE "dose"
			lstr_element = get_element(pstr_element.child[i])
			lstr_treatmentmedication_type.dose = get_amountunit_type(lstr_element)
		CASE "frequency"
			lstr_element = get_element(pstr_element.child[i])
			lstr_treatmentmedication_type.frequency = get_frequency_type(lstr_element)
		CASE "duration"
			lstr_element = get_element(pstr_element.child[i])
			lstr_treatmentmedication_type.duration = get_amountunit_type(lstr_element)
		CASE "durationprn"
			lstr_treatmentmedication_type.durationprn = pstr_element.child[i].gettexttrim()
		CASE "dispenseatpharmacy"
			lstr_element = get_element(pstr_element.child[i])
			lstr_treatmentmedication_type.dispenseatpharmacy = get_amountunit_type(lstr_element)
		CASE "dispenseinoffice"
			lstr_element = get_element(pstr_element.child[i])
			lstr_treatmentmedication_type.dispenseinoffice = get_amountunit_type(lstr_element)
		CASE "substitutionallowed"
			ls_temp = pstr_element.child[i].gettexttrim()
			if len(ls_temp) > 0 then
				lstr_treatmentmedication_type.substitutionallowed = f_xml_boolean(ls_temp)
			end if
		CASE "refillsallowed"
			ls_temp = pstr_element.child[i].gettexttrim()
			if isnumber(ls_temp) then
				lstr_treatmentmedication_type.refillsallowed = integer(ls_temp)
			end if
	END CHOOSE
next

return lstr_treatmentmedication_type

end function

public function str_treatmentmedication_type empty_str_treatmentmedication_type ();str_treatmentmedication_type lstr_treatmentmedication_type

setnull(lstr_treatmentmedication_type.drugid)
setnull(lstr_treatmentmedication_type.commonname)
setnull(lstr_treatmentmedication_type.genericname)
setnull(lstr_treatmentmedication_type.brandname)
setnull(lstr_treatmentmedication_type.lotnumber)
setnull(lstr_treatmentmedication_type.expirationdate)
setnull(lstr_treatmentmedication_type.manufacturer)

lstr_treatmentmedication_type.package = empty_str_drugpackage_type( )
lstr_treatmentmedication_type.dose = empty_str_amountunit_type( )
lstr_treatmentmedication_type.frequency = empty_str_frequency_type( )
lstr_treatmentmedication_type.duration = empty_str_amountunit_type( )

setnull(lstr_treatmentmedication_type.durationprn)

lstr_treatmentmedication_type.dispenseatpharmacy = empty_str_amountunit_type( )
lstr_treatmentmedication_type.dispenseinoffice = empty_str_amountunit_type( )

setnull(lstr_treatmentmedication_type.substitutionallowed)
setnull(lstr_treatmentmedication_type.refillsallowed)

return lstr_treatmentmedication_type

end function

public function str_drugpackage_type empty_str_drugpackage_type ();str_drugpackage_type lstr_drugpackage_type

setnull(lstr_drugpackage_type.packageid)
setnull(lstr_drugpackage_type.administermethod)
setnull(lstr_drugpackage_type.description)
lstr_drugpackage_type.dose = empty_str_amountunit_type( )
lstr_drugpackage_type.administerperdose = empty_str_amountunit_type( )
setnull(lstr_drugpackage_type.dosageform)

return lstr_drugpackage_type

end function

public function str_encounter_description translate_encounter_info (ref str_patientrecord_type pstr_patient_info, ref str_encounter_type pstr_encounter_info);long i
long ll_count
string ls_null

setnull(ls_null)

str_encounter_description lstr_encounter

lstr_encounter = f_empty_encounter()

lstr_encounter.id_list.id_count = upperbound(pstr_encounter_info.objectid)
lstr_encounter.id_list.id = pstr_encounter_info.objectid

lstr_encounter.encounter_date = pstr_encounter_info.encounterdate
lstr_encounter.description = pstr_encounter_info.description

lstr_encounter.encounter_type = lookup_epro_id(owner_id, "encountertype", ls_null, pstr_encounter_info.encountertype, "encounter_type")

lstr_encounter.attending_doctor = pstr_encounter_info.attendingdoctor.user_id
lstr_encounter.referring_doctor = pstr_encounter_info.referringdoctor.user_id
lstr_encounter.supervising_doctor = pstr_encounter_info.supervisingdoctor.user_id

if isnull( pstr_encounter_info.newpatient) then
	setnull(lstr_encounter.new_flag)
elseif  pstr_encounter_info.newpatient then
	lstr_encounter.new_flag = "Y"
else
	lstr_encounter.new_flag = "N"
end if

if len(pstr_encounter_info.encounterlocation.user_id) > 0 then
	lstr_encounter.office_id = user_list.user_property(pstr_encounter_info.encounterlocation.user_id, "office_id")
end if

if lower(pstr_encounter_info.EncounterModality) = "inpatient" then
	lstr_encounter.indirect_flag = "H"
	lstr_encounter.discharge_date = pstr_encounter_info.inpatientstatus.dischargedate
elseif lower(pstr_encounter_info.EncounterModality) = "outpatient" then
	lstr_encounter.indirect_flag = "D"
	lstr_encounter.discharge_date = pstr_encounter_info.outpatientstatus.encounterenddate
	lstr_encounter.encounter_status = lookup_epro_id( owner_id, &
																		"encounterstatus", &
																		ls_null, &
																		pstr_encounter_info.outpatientstatus.encounterstatus, &
																		"encounter_status")
elseif lower(pstr_encounter_info.EncounterModality) = "indirect" then
	lstr_encounter.indirect_flag = "I"
elseif lower(pstr_encounter_info.EncounterModality) = "other" then
	lstr_encounter.indirect_flag = "N"
else
	lstr_encounter.indirect_flag = "D"
end if


Return lstr_encounter


end function

public function str_assessment_description translate_assessment_info (ref str_patientrecord_type pstr_patient_info, ref str_assessment_instance_type pstr_assessment_info);str_c_xml_code lstr_xml_code
long i
long ll_count
string ls_assessment_id
boolean lb_found
string ls_null
integer li_null
long ll_null
long ll_code_id
string ls_temp

setnull(ls_null)
setnull(li_null)
setnull(ll_null)

str_assessment_description lstr_assessment

lstr_assessment = f_empty_assessment()

lstr_assessment.id_list.id_count = upperbound(pstr_assessment_info.objectid)
lstr_assessment.id_list.id = pstr_assessment_info.objectid

//////////////////////////////////////////////////////////////////////////////////////////////
// Determine the assessment_type
//////////////////////////////////////////////////////////////////////////////////////////////
if len(pstr_assessment_info.assessmenttype) > 0 then
	lstr_assessment.assessment_type =lookup_epro_id( owner_id, &
																		"AssessmentType", &
																		ls_null, &
																		pstr_assessment_info.assessmenttype, &
																		"assessment_type")
	if isnull(lstr_assessment.assessment_type) then
		// See if they supplied a locally valid value
		ls_temp = datalist.assessment_type_description(pstr_assessment_info.assessmenttype)
		if len(ls_temp) > 0 then
			// The supplied assessment type is valid so use it
			lstr_assessment.assessment_type = pstr_assessment_info.assessmenttype
		end if
	end if
end if
if isnull(lstr_assessment.assessment_type) then
	lstr_assessment.assessment_type = "Sick"
end if


lstr_assessment.open_encounter_id = get_object_key_from_id(pstr_patient_info, "Encounter", pstr_assessment_info.link_openencounter)
lstr_assessment.close_encounter_id = get_object_key_from_id(pstr_patient_info, "Encounter", pstr_assessment_info.link_closeencounter)

lstr_assessment.assessment = pstr_assessment_info.description
lstr_assessment.location = pstr_assessment_info.location
lstr_assessment.acuteness = pstr_assessment_info.acuteness
lstr_assessment.icd10_code = pstr_assessment_info.icd10
lstr_assessment.begin_date = pstr_assessment_info.begindate
lstr_assessment.diagnosed_by = pstr_assessment_info.diagnosedby.user_id
lstr_assessment.assessment_status = pstr_assessment_info.assessmentstatus

lstr_assessment.end_date = pstr_assessment_info.enddate


//////////////////////////////////////////////////////////////////////////////////////////////
// Determine the assessment_id
//////////////////////////////////////////////////////////////////////////////////////////////

// First, see if the Epro assessment_id was supplied
lb_found = false
for i = 1 to lstr_assessment.id_list.id_count
	if lower(lstr_assessment.id_list.id[i].epro_domain) = "assessment_id" and len(lstr_assessment.id_list.id[i].epro_value) > 0 then
		lstr_assessment.assessment_id = lstr_assessment.id_list.id[i].epro_value
		lb_found = true
		exit
	end if
next

if not lb_found then
	// The object ID array didn't have the epro assessment_id, so try looking it up if the sender supplied an AssessmentDefinitionId
	setnull(ls_assessment_id)
	if len(pstr_assessment_info.assessmentdefinitionid) > 0 then
		ls_assessment_id =  lookup_epro_id( owner_id, &
														"AssessmentDefinitionId", &
														ls_null, &
														pstr_assessment_info.assessmentdefinitionid, &
														"assessment_id")
	end if
	
	if isnull(ls_assessment_id) then
		// We still haven't found an assessment_id, so make one
		sqlca.sp_new_assessment(lstr_assessment.assessment_type, lstr_assessment.icd10_code, ls_null, lstr_assessment.assessment, ls_null, "N", li_null, ls_null, ll_null, ll_null, ls_null, owner_id, "NA", ls_assessment_id, "Y")
		if not tf_check() then
			setnull(ls_assessment_id)
		elseif len(pstr_assessment_info.assessmentdefinitionid) > 0 then
			// Map the new assessment_id to the supplied assessmentdefinitionid
			lstr_xml_code = f_empty_xml_code()
			
			lstr_xml_code.owner_id = owner_id
			lstr_xml_code.code_domain =  "AssessmentDefinitionId"
			setnull(lstr_xml_code.code_version)
			lstr_xml_code.code = pstr_assessment_info.assessmentdefinitionid
			lstr_xml_code.code_description = lstr_assessment.assessment
			lstr_xml_code.epro_owner_id = sqlca.customer_id
			lstr_xml_code.epro_domain = "assessment_id"
			lstr_xml_code.epro_id = ls_assessment_id
			lstr_xml_code.epro_description = lstr_assessment.assessment
			lstr_xml_code.unique_flag = 1
			lstr_xml_code.created_by = current_scribe.user_id
			lstr_xml_code.mapping_owner_id = sqlca.customer_id
			lstr_xml_code.status = "OK"
			lstr_xml_code.description = lstr_assessment.assessment
			
			ll_code_id = datalist.xml_add_mapping(lstr_xml_code)
		end if
	end if
	
	lstr_assessment.assessment_id = ls_assessment_id
end if





Return lstr_assessment


end function

public function str_treatment_description translate_treatment_info (ref str_patientrecord_type pstr_patient_info, ref str_treatment_type pstr_treatment_info);long i
long ll_count
string ls_null
long ll_observation_count
str_treatment_description lstr_treatment
long ll_problem_id
string ls_temp

setnull(ls_null)

ll_observation_count = upperbound(pstr_treatment_info.observation)

lstr_treatment = f_empty_treatment()

// Transfer to treatment_description structure
lstr_treatment.id_list.id_count = upperbound(pstr_treatment_info.objectid)
lstr_treatment.id_list.id = pstr_treatment_info.objectid


lstr_treatment.open_encounter_id = get_object_key_from_id(pstr_patient_info, "Encounter", pstr_treatment_info.link_openencounter)
lstr_treatment.begin_date = pstr_treatment_info.begindate
lstr_treatment.treatment_description = pstr_treatment_info.description
lstr_treatment.specimen_id = pstr_treatment_info.SpecimenID
lstr_treatment.location = lookup_epro_id(owner_id, "treatmentlocation", ls_null, pstr_treatment_info.treatmentlocation, "location")
lstr_treatment.treatment_status = lookup_epro_id(owner_id, "treatmentstatus", ls_null, pstr_treatment_info.treatmentstatus, "treatment_status")

lstr_treatment.close_encounter_id = get_object_key_from_id(pstr_patient_info, "Encounter", pstr_treatment_info.link_closeencounter)
lstr_treatment.end_date = pstr_treatment_info.enddate
lstr_treatment.ordered_by = pstr_treatment_info.orderedby.user_id
lstr_treatment.ordered_for = pstr_treatment_info.orderedfor.user_id
//lstr_treatment.completed_by = pstr_treatment_info.completedby.user_id

// Medication block
if len(pstr_treatment_info.medication.drugid) > 0 then
	lstr_treatment.drug_id = pstr_treatment_info.medication.drugid
end if
if len(pstr_treatment_info.medication.lotnumber) > 0 then
	lstr_treatment.lot_number = pstr_treatment_info.medication.lotnumber
end if
if pstr_treatment_info.medication.expirationdate >  datetime(date("1/1/1970"), time("00:00:00")) then
	lstr_treatment.expiration_date = pstr_treatment_info.medication.expirationdate
end if
if len(pstr_treatment_info.medication.package.packageid) > 0 then
	lstr_treatment.package_id = pstr_treatment_info.medication.package.packageid
end if
if isnumber(pstr_treatment_info.medication.dose.amount) then
	lstr_treatment.dose_amount = real(pstr_treatment_info.medication.dose.amount)
	lstr_treatment.dose_unit = pstr_treatment_info.medication.dose.unit.unitid
end if
lstr_treatment.administer_frequency = pstr_treatment_info.medication.frequency.abbreviation
if isnumber(pstr_treatment_info.medication.duration.amount) then
	lstr_treatment.duration_amount = real(pstr_treatment_info.medication.duration.amount)
	lstr_treatment.duration_unit = pstr_treatment_info.medication.duration.unit.unitid
end if
lstr_treatment.duration_prn = pstr_treatment_info.medication.durationprn
if isnumber(pstr_treatment_info.medication.dispenseatpharmacy.amount) then
	lstr_treatment.dispense_amount = real(pstr_treatment_info.medication.dispenseatpharmacy.amount)
	lstr_treatment.dispense_unit = pstr_treatment_info.medication.dispenseatpharmacy.unit.unitid
end if
if isnumber(pstr_treatment_info.medication.dispenseinoffice.amount) then
	lstr_treatment.office_dispense_amount = real(pstr_treatment_info.medication.dispenseinoffice.amount)
end if
if not isnull(pstr_treatment_info.medication.substitutionallowed) then
	if pstr_treatment_info.medication.substitutionallowed then
		lstr_treatment.brand_name_required = "N"
	else
		lstr_treatment.brand_name_required = "Y"
	end if
end if
lstr_treatment.refills = pstr_treatment_info.medication.refillsallowed

ll_count = upperbound(pstr_treatment_info.link_assessment)
lstr_treatment.problem_count = 0
for i = 1 to ll_count
	ll_problem_id = get_object_key_from_id(pstr_patient_info, "Assessment", pstr_treatment_info.link_assessment[i])
	if ll_problem_id > 0 then
		lstr_treatment.problem_count += 1
		lstr_treatment.problem_ids[lstr_treatment.problem_count] = ll_problem_id
	end if
next

// If a treatment description wasn't supplied then get the first observation description and use it as the
// treatment description
if isnull(lstr_treatment.treatment_description) then
	// get the first OBR desc
	if ll_observation_count > 0 then
		lstr_treatment.treatment_description = pstr_treatment_info.observation[1].description
	end if
end if

//////////////////////////////////////////////////////////////////////////////////////////////
// Determine the treatment_type
//////////////////////////////////////////////////////////////////////////////////////////////

if len(pstr_treatment_info.treatmenttype) > 0 then
	lstr_treatment.treatment_type = lookup_epro_id( owner_id, &
																	"TreatmentType", &
																	ls_null, &
																	pstr_treatment_info.treatmenttype, &
																	"treatment_type")
	if isnull(lstr_treatment.treatment_type) then
		// See if they supplied a locally valid value
		ls_temp = datalist.treatment_type_description(pstr_treatment_info.treatmenttype)
		if len(ls_temp) > 0 then
			// The supplied treatment type is valid so use it
			lstr_treatment.treatment_type = pstr_treatment_info.treatmenttype
		end if
	end if
end if
if isnull(lstr_treatment.treatment_type) then
	// No default treatment type found, so set the defaul based on what treatment key was found
	if len(lstr_treatment.drug_id) > 0 then
		lstr_treatment.treatment_type = "Medication"
	elseif len(lstr_treatment.observation_id) > 0 then
		lstr_treatment.treatment_type = "Lab"
	elseif len(lstr_treatment.procedure_id) > 0 then
		lstr_treatment.treatment_type = "Procedure"
	elseif ll_observation_count > 0 then
		lstr_treatment.treatment_type = "Lab"
	else
		lstr_treatment.treatment_type = "Treatment"
	end if
end if


Return lstr_treatment


end function

public function str_jmjdocumentcontext_type get_jmjdocumentcontext_type (ref str_element pstr_element);str_jmjdocumentcontext_type lstr_jmjdocumentcontext_type
long i
string ls_date
str_element lstr_element
string ls_id
integer li_sts

lstr_jmjdocumentcontext_type = empty_jmjdocumentcontext_type()

if not pstr_element.valid then return lstr_jmjdocumentcontext_type

for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "contextobject"
			lstr_jmjdocumentcontext_type.ContextObject = pstr_element.child[i].gettexttrim()
		CASE "encounterid"
			lstr_jmjdocumentcontext_type.EncounterID = pstr_element.child[i].gettexttrim()
		CASE "assessmentid"
			lstr_jmjdocumentcontext_type.AssessmentID = pstr_element.child[i].gettexttrim()
		CASE "treatmentid"
			lstr_jmjdocumentcontext_type.TreatmentID = pstr_element.child[i].gettexttrim()
		CASE "purpose"
			lstr_jmjdocumentcontext_type.Purpose = pstr_element.child[i].gettexttrim()
		CASE "message"
			lstr_element = get_element(pstr_element.child[i])
			lstr_jmjdocumentcontext_type.message = get_message_type(lstr_element)
	END CHOOSE
next

return lstr_jmjdocumentcontext_type

end function

public function str_jmjdocumentcontext_type empty_jmjdocumentcontext_type ();str_jmjdocumentcontext_type lstr_jmjdocumentcontext_type

setnull(lstr_jmjdocumentcontext_type.ContextObject)
setnull(lstr_jmjdocumentcontext_type.EncounterID)
setnull(lstr_jmjdocumentcontext_type.AssessmentID)
setnull(lstr_jmjdocumentcontext_type.TreatmentID)
setnull(lstr_jmjdocumentcontext_type.Purpose)

setnull(lstr_jmjdocumentcontext_type.Message.MessageID)
setnull(lstr_jmjdocumentcontext_type.Message.threadid)
setnull(lstr_jmjdocumentcontext_type.Message.messagesubject)
setnull(lstr_jmjdocumentcontext_type.Message.messagebody)
setnull(lstr_jmjdocumentcontext_type.Message.messagesent)

return lstr_jmjdocumentcontext_type

end function

public function str_patientrelation_type get_patientrelation_type (ref str_element pstr_element);str_patientrelation_type lstr_patientrelation_type
long i
string ls_date
str_element lstr_element
string ls_id
integer li_sts
str_actor_type lstr_actor
long ll_relationship_count
string ls_temp

setnull(lstr_patientrelation_type.relationshipdescription)
lstr_patientrelation_type.relationactor = f_empty_actor_type()

if not pstr_element.valid then return lstr_patientrelation_type

ll_relationship_count = 0


// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "relationactor"
			ls_id = pstr_element.child[i].gettexttrim()
			li_sts = get_actor(ls_id, lstr_actor)
			if li_sts > 0 then lstr_patientrelation_type.relationactor = lstr_actor
		CASE "relationship"
			ls_temp = pstr_element.child[i].gettexttrim()
			if len(ls_temp) > 0 then
				ll_relationship_count += 1
				lstr_patientrelation_type.relationship[ll_relationship_count] = ls_temp
			end if
		CASE "relationshipdescription"
			lstr_patientrelation_type.relationshipdescription = pstr_element.child[i].gettexttrim()
	END CHOOSE
next

return lstr_patientrelation_type

end function

public function str_authority_type get_authority_type (ref str_element pstr_element);string ls_description
str_authority_type lstr_authority_type
str_actor_type lstr_actor
long i
string ls_date_and_time
string ls_amount
string ls_unit
long ll_amount
date ld_date
string ls_id
integer li_sts

setnull(lstr_authority_type.startdate)
setnull(lstr_authority_type.enddate)
setnull(lstr_authority_type.sequence)
lstr_authority_type.authority = f_empty_actor_type()

if not pstr_element.valid then return lstr_authority_type

// Assume that this is a "Name" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "startdate"
			ls_date_and_time = pstr_element.child[i].gettexttrim()
			lstr_authority_type.startdate = f_xml_datetime(ls_date_and_time)
		CASE "enddate"
			ls_date_and_time = pstr_element.child[i].gettexttrim()
			lstr_authority_type.enddate = f_xml_datetime(ls_date_and_time)
		CASE "sequence"
			lstr_authority_type.sequence = pstr_element.child[i].gettexttrim()
		CASE "authority"
			ls_id = pstr_element.child[i].gettexttrim()
			li_sts = get_actor(ls_id, lstr_actor)
			if li_sts > 0 then lstr_authority_type.authority = lstr_actor
	END CHOOSE
next


return lstr_authority_type

end function

public function str_treatment_type get_treatment_type (ref str_element pstr_element, boolean pb_is_constituent_treatment);str_treatment_type lstr_treatment_type
long i, j
string ls_date
str_element lstr_element
str_element lstr_element2
string ls_id
integer li_sts
str_actor_type lstr_actor
long ll_objectid_count
long ll_assessment_count
long ll_observation_count
long ll_treatmentnote_count
long ll_message_count
long ll_constituenttreatment_count
string ls_element_name

setnull(lstr_treatment_type.link_openencounter)
setnull(lstr_treatment_type.treatmenttype)
setnull(lstr_treatment_type.begindate)
setnull(lstr_treatment_type.description)
setnull(lstr_treatment_type.specimenid)
setnull(lstr_treatment_type.treatmentlocation)
setnull(lstr_treatment_type.treatmentstatus)
setnull(lstr_treatment_type.link_closeencounter)
setnull(lstr_treatment_type.enddate)
lstr_treatment_type.orderedfor = f_empty_actor_type()
lstr_treatment_type.orderedby = f_empty_actor_type()
lstr_treatment_type.completedby = f_empty_actor_type()

// Default treatment handling flags
if pb_is_constituent_treatment then
	lstr_treatment_type.treatmenthandling.create_flag = true
	lstr_treatment_type.treatmenthandling.create_ask = false
	lstr_treatment_type.treatmenthandling.update_flag = true
	lstr_treatment_type.treatmenthandling.update_ask = false
else
	lstr_treatment_type.treatmenthandling.create_flag = false
	lstr_treatment_type.treatmenthandling.create_ask = true
	lstr_treatment_type.treatmenthandling.update_flag = false
	lstr_treatment_type.treatmenthandling.update_ask = false
end if

if not pstr_element.valid then return lstr_treatment_type

ll_objectid_count = 0
ll_assessment_count = 0
ll_observation_count = 0
ll_treatmentnote_count = 0
ll_message_count = 0
ll_constituenttreatment_count = 0

lstr_treatment_type.TreatmentID = pstr_element.element.GetAttributeValue("TreatmentID")

// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	ls_element_name = lower(pstr_element.child[i].getname())
	CHOOSE CASE ls_element_name
		CASE "objectid"
			ll_objectid_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_treatment_type.objectid[ll_objectid_count] = get_objectid_type(lstr_element)
		CASE "treatmenthandling"
			lstr_element = get_element(pstr_element.child[i])
			lstr_treatment_type.treatmenthandling = get_objecthandling_type(lstr_element)
			// Go ahead and set the flags here
			CHOOSE CASE lower(lstr_treatment_type.treatmenthandling.objectcreate)
				CASE "createalways"
					lstr_treatment_type.treatmenthandling.create_flag = true
					if pb_is_constituent_treatment then
						lstr_treatment_type.treatmenthandling.create_ask = false
					else
						lstr_treatment_type.treatmenthandling.create_ask = true
					end if
				CASE "createnever"
					lstr_treatment_type.treatmenthandling.create_flag = false
					if pb_is_constituent_treatment then
						lstr_treatment_type.treatmenthandling.create_ask = false
					else
						lstr_treatment_type.treatmenthandling.create_ask = true
					end if
			END CHOOSE
			CHOOSE CASE lower(lstr_treatment_type.treatmenthandling.objectupdate)
				CASE "updatealways"
					lstr_treatment_type.treatmenthandling.update_flag = true
					lstr_treatment_type.treatmenthandling.update_ask = false
				CASE "updatenever"
					lstr_treatment_type.treatmenthandling.update_flag = false
					lstr_treatment_type.treatmenthandling.update_ask = false
				CASE "updateask"
					lstr_treatment_type.treatmenthandling.update_flag = false
					lstr_treatment_type.treatmenthandling.update_ask = true
			END CHOOSE
		CASE "openencounter"
			lstr_element = get_element(pstr_element.child[i])
			lstr_treatment_type.link_openencounter = pstr_element.child[i].gettexttrim()
		CASE "treatmenttype"
			lstr_treatment_type.treatmenttype = pstr_element.child[i].gettexttrim()
		CASE "begindate"
			ls_date = pstr_element.child[i].gettexttrim()
			lstr_treatment_type.begindate = f_xml_datetime(ls_date)
		CASE "description"
			lstr_treatment_type.description = pstr_element.child[i].gettexttrim()
		CASE "specimenid"
			lstr_treatment_type.specimenid = pstr_element.child[i].gettexttrim()
		CASE "treatmentlocation"
			lstr_treatment_type.treatmentlocation = pstr_element.child[i].gettexttrim()
		CASE "treatmentstatus"
			lstr_treatment_type.treatmentstatus = pstr_element.child[i].gettexttrim()
		CASE "closeencounterid"
			lstr_element = get_element(pstr_element.child[i])
			lstr_treatment_type.link_closeencounter = pstr_element.child[i].gettexttrim()
		CASE "enddate"
			ls_date = pstr_element.child[i].gettexttrim()
			lstr_treatment_type.enddate = f_xml_datetime(ls_date)
		CASE "orderedby"
			ls_id = pstr_element.child[i].gettexttrim()
			li_sts = get_actor(ls_id, lstr_actor)
			if li_sts > 0 then lstr_treatment_type.orderedby = lstr_actor
		CASE "orderedfor"
			ls_id = pstr_element.child[i].gettexttrim()
			li_sts = get_actor(ls_id, lstr_actor)
			if li_sts > 0 then lstr_treatment_type.orderedfor = lstr_actor
		CASE "completedby"
			ls_id = pstr_element.child[i].gettexttrim()
			li_sts = get_actor(ls_id, lstr_actor)
			if li_sts > 0 then lstr_treatment_type.completedby = lstr_actor
		CASE "medication"
			lstr_element = get_element(pstr_element.child[i])
			lstr_treatment_type.Medication = get_treatmentmedication_type(lstr_element)
		CASE "assessment"
			lstr_element = get_element(pstr_element.child[i])
			ll_assessment_count += 1
			lstr_treatment_type.link_Assessment[ll_assessment_count] = pstr_element.child[i].gettexttrim()
		CASE "observation"
			ll_observation_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_treatment_type.observation[ll_observation_count] = get_observation_type(lstr_element)
		CASE "treatmentnote"
			ll_treatmentnote_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_treatment_type.treatmentnote[ll_treatmentnote_count] = get_note_type(lstr_element)
		CASE "message"
			ll_message_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_treatment_type.message[ll_message_count] = get_message_type(lstr_element)
		CASE "constituenttreatments"
			lstr_element = get_element(pstr_element.child[i])
			for j = 1 to lstr_element.child_count
				if lower(lstr_element.child[j].getname()) = "treatment" then
					lstr_element2 = get_element(lstr_element.child[j])
					ll_constituenttreatment_count += 1
					lstr_treatment_type.constituenttreatments.treatment[ll_constituenttreatment_count] = get_treatment_type(lstr_element2, true)
				end if
			next
	END CHOOSE
next

return lstr_treatment_type

end function

public function integer add_encounter_indications (string ps_cpr_id, long pl_encounter_id, str_indication_type pstr_indications[]);long j
long ll_problem_id
boolean lb_found
integer li_diagnosis_sequence
string ls_severity
long ll_attachment_id
long ll_patient_workplan_item_id
long ll_risk_level
integer li_sts
datetime ldt_progress_date_time

setnull(li_diagnosis_sequence)
setnull(ls_severity)
setnull(ll_attachment_id)
setnull(ll_patient_workplan_item_id)
setnull(ll_risk_level)
setnull(ldt_progress_date_time)

// Now attach the treatment to it's assessments
for j = 1 to upperbound(pstr_indications)
	lb_found = false
//	if lower(pstr_indications[j].link.link_type) = "diagnosis" then
//		ll_problem_id = find_epro_problem_id(pstr_indications[j].link.id)
//		if ll_problem_id > 0 then
//			sqlca.sp_set_assessment_progress(ps_cpr_id, &
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
		li_sts = f_set_progress(ps_cpr_id, &
										"Encounter", &
										pl_encounter_id, &
										"Indication", &
										pstr_indications[j].modifier, &
										pstr_indications[j].description, &
										ldt_progress_date_time, &
										ll_risk_level, &
										ll_attachment_id, &
										ll_patient_workplan_item_id)
		if li_sts < 0 then return -1
	end if
next

return 1

end function

public function str_jmjdocument_messageid_type get_jmjdocument_messageid_type (ref str_element pstr_element);str_jmjdocument_messageid_type lstr_jmjdocument_messageid_type
long i
str_element lstr_element

setnull(lstr_jmjdocument_messageid_type.sendermessageid)
setnull(lstr_jmjdocument_messageid_type.epiemessageid)

if not pstr_element.valid then return lstr_jmjdocument_messageid_type

// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "sendermessageid"
			lstr_jmjdocument_messageid_type.sendermessageid = pstr_element.child[i].gettexttrim()
		CASE "epiemessageid"
			lstr_jmjdocument_messageid_type.epiemessageid = pstr_element.child[i].gettexttrim()
	END CHOOSE
next

return lstr_jmjdocument_messageid_type

end function

protected function integer add_observation_and_results (long pl_treatment_id, str_treatment_description pstr_parent_treatment, str_observation_type pstr_observation, string ps_observation_tag, long pl_encounter_id, long pl_parent_observation_sequence);/*********************************************************************
*
*
*  Description: create observation & results
*               find a observation id by doing a domain look up in					 
*					 c_XML_Code table. if it not found then it creates a
*               new observation (c_observation) record.
*
*  Return: -1 - Error
*           1 - Success
*
*
***********************************************************************/

integer				i
integer				li_null
integer				li_result_sequence

long					ll_observation_sequence
long					ll_attachment_id
long					ll_sts

string				ls_location
string ls_print_result_flag
string ls_resulttype
string				ls_event_id
string				ls_result
string ls_resultunit
string ls_resultvalue
string				ls_abnormalflag
string ls_abnormalnature
string ls_referencerange
string ls_resultstatus
string				ls_null
string				ls_observation_id
integer li_sts
long ll_result_count
long ll_observation_count
long ll_objectid_count
string ls_observed_by_user
str_actor_type lstr_observedby

string ls_progress_type
string ls_progress_key
string ls_attachment_type
string ls_folder


u_component_treatment luo_treatment


setnull(li_null)
setnull(ls_null)
setnull(ls_event_id)
setnull(ls_observation_id)

// If the sendermessageid is present then use it as the event_id
if len(jmjdocumentcontext.messageid.sendermessageid) > 0 then
	ls_event_id = jmjdocumentcontext.messageid.sendermessageid
end if

// Find the observation_id
ll_objectid_count = upperbound(pstr_observation.objectid)
for i = 1 to ll_objectid_count
	if lower(pstr_observation.objectid[i].epro_domain) = "observation_id" then
		if len(pstr_observation.objectid[i].epro_value) > 0 then
			ls_observation_id = pstr_observation.objectid[i].epro_value
		elseif owner_id > 0 and pstr_observation.objectid[i].owner_id = owner_id &
		 and len(pstr_observation.objectid[i].iddomain) > 0 &
		 and len(pstr_observation.objectid[i].idvalue) > 0 then
			ls_observation_id = lookup_epro_id(owner_id, pstr_observation.objectid[i].iddomain, pstr_observation.objectid[i].idvalue, pstr_observation.description, pstr_observation.objectid[i].epro_domain)
		end if
	end if
	
	// As soon as we find the observation_id then stop looking
	if len(ls_observation_id) > 0 then exit
next

// add p_observation record
ll_observation_sequence = sqlca.sp_xml_add_observation(my_context.cpr_id, & 
																			pstr_observation.description, &
																			pl_treatment_id, & 
																			pl_encounter_id, & 														
																			pstr_observation.resultexpecteddate, &														
																			pl_parent_observation_sequence, & 
																			owner_id, & 
																			ls_event_id, &
																			current_user.user_id, &
																			current_scribe.user_id, &
																			ls_observation_id, &
																			ps_observation_tag)
if not tf_check() then return -1

if isnull(ll_observation_sequence) or ll_observation_sequence <= 0 then
	log.log(this,"process_observation()","Error getting observation_sequence",4)
	return -1
end if

// if any results then add c_ & p_observation_result records
ll_result_count = upperbound(pstr_observation.observationresult)
for i = 1 to ll_result_count
	ls_observed_by_user = pstr_observation.observationresult[i].observedby.user_id
	if isnull(ls_observed_by_user) then
		li_sts = get_default_actor(lstr_observedby)
		if li_sts > 0 then
			ls_observed_by_user = lstr_observedby.user_id
		else
			ls_observed_by_user = current_user.user_id
		end if
	end if
	
	ls_location = pstr_observation.observationresult[i].location
	if isnull(ls_location) then ls_location = "NA"
	ls_print_result_flag = "Y"
	ls_resulttype	= pstr_observation.observationresult[i].ResultType
	ls_result = pstr_observation.observationresult[i].Result
	ls_resultunit = pstr_observation.observationresult[i].ResultUnit
	ls_resultvalue = pstr_observation.observationresult[i].ResultValue
	ls_referencerange = pstr_observation.observationresult[i].ReferenceRange
	ls_resultstatus = pstr_observation.observationresult[i].ResultStatus

	if len(pstr_observation.observationresult[i].resultfile.attachmentdata) > 0 then
		ls_progress_type = "Attachment"
		if len(pstr_observation.observationresult[i].resultfile.attachmentname) > 0 then
			ls_progress_key = pstr_observation.observationresult[i].resultfile.attachmentname
		else
			ls_progress_key = ls_result
		end if
		setnull(ls_attachment_type) // assign default attachment_type based on file type
		
		ll_attachment_id = f_new_attachment_2(my_context.cpr_id, &
															"Treatment", &
															pl_treatment_id, &
															ls_progress_type, &
															ls_progress_key, &
															pstr_observation.observationresult[i].resultfile.filetype, &
															ls_attachment_type, &
															ls_progress_key, &
															pstr_observation.observationresult[i].resultfile.filename, &
															pstr_observation.observationresult[i].resultfile.attachmentdata, &
															ls_folder)
		if ll_attachment_id < 0 then return -1
	else
		setnull(ll_attachment_id)
	end if

	if f_string_to_boolean(lookup_epro_id(owner_id, "abnormalflag", ls_null, pstr_observation.observationresult[i].abnormalflag, "abnormal_flag")) then
		ls_abnormalflag = "Y"
	else
		ls_abnormalflag = "N"
	end if
	
	ls_abnormalnature = lookup_epro_id(owner_id, "abnormalnature", ls_null, pstr_observation.observationresult[i].abnormalnature, "abnormal_nature")
	
	if isnull(ls_resultunit) then
		ls_resultunit = "NA"
	else
		ls_resultunit = lookup_epro_id(owner_id, "testunit", ls_null, ls_resultunit, "unit_id")
	end if
	
	if isnull(ls_result) then // if no result title
		if isnull(ls_resultvalue) then
			ls_result = "No Result"
			ls_print_result_flag = "Y"
		else
			if ls_resultunit <> "NA" then
				if len(ls_resultvalue) > 80 then
					ls_result = "Result"
					ls_print_result_flag = "N"
				else
					ls_result = ls_resultvalue
					setnull(ls_resultvalue)
					ls_print_result_flag = "Y"
					ls_resultunit = "NA"
				end if
			end if
		end if
	elseif len(ls_result) > 80 then
		ls_resultvalue = ls_result
		setnull(ls_result)
		ls_resultunit = "TEXT"
	elseif lower(ls_result) = "result" and ls_resultunit <> "NA" then
		ls_print_result_flag = "N"
	else
		ls_print_result_flag = "Y"
	end if
	
	
	ll_sts = sqlca.sp_xml_add_observation_result( ll_observation_sequence, & 
																ls_location, &
																ls_result, & 
																ls_resultvalue, & 
																ls_print_result_flag, &
																ls_resultunit, & 
																ls_abnormalflag, & 
																ls_abnormalnature, & 
																pstr_observation.observationresult[i].severity, & 
																ls_observed_by_user, &
																current_scribe.user_id, &
																pstr_observation.observationresult[i].resultdate, &
																pl_encounter_id, &
																ll_attachment_id, &
																ls_referencerange)
	if not sqlca.check() then return -1
next

// Recursively process any child observations
ll_observation_count = upperbound(pstr_observation.observation)
For i = 1 to ll_observation_count
	// Recursively call this method for the child observations, but don't pass through the tag
	li_sts = add_observation_and_results( pl_treatment_id, pstr_parent_treatment, pstr_observation.observation[i].observation, ls_null, pl_encounter_id,ll_observation_sequence)
	if li_sts < 0 then return -1
Next

Return 1



end function

on u_component_xml_handler_base.create
call super::create
end on

on u_component_xml_handler_base.destroy
call super::destroy
end on

event constructor;call super::constructor;setnull(owner_id)
setnull(customer_id)

end event

