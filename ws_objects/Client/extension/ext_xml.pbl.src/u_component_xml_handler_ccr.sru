$PBExportHeader$u_component_xml_handler_ccr.sru
forward
global type u_component_xml_handler_ccr from u_component_xml_handler_base
end type
end forward

global type u_component_xml_handler_ccr from u_component_xml_handler_base
end type
global u_component_xml_handler_ccr u_component_xml_handler_ccr

type variables

// Cache the owner of the current ccr data
string consultant_id
string results_from_progress_type
string results_from_progress_key

// patient data found in this document
boolean patientrecord_found
str_ccr_continuityofcarerecord ccr_continuityofcarerecord

// patient data after translation
str_patient epro_patient

long encounter_count
long encounter_id[]

long treatment_count
long treatment_id[]

long assessment_count
long problem_id[]


end variables

forward prototypes
protected function integer xx_initialize ()
protected function integer xx_interpret_xml ()
public function integer process_patient (ref str_patientrecord_type pstr_patient)
public function integer process_assessment (ref str_patientrecord_type pstr_patient_info, ref str_assessment_instance_type pstr_assessment_info)
public function integer process_encounter (ref str_patientrecord_type pstr_patient_info, ref str_encounter_type pstr_encounter_info)
public subroutine interpret_objectcreate (string ps_context_object, string ps_objectcreate, ref boolean pb_auto_create, ref boolean pb_prompt_user)
public function integer process_treatment (ref str_patientrecord_type pstr_patient_info, ref str_treatment_type pstr_treatment_info, long parent_treatment_id)
public function str_actor_type get_actor_type (ref str_element pstr_element)
public function str_address_type get_address_type (ref str_element pstr_element)
public function str_ccr_codetype get_ccr_codetype (ref str_element pstr_element)
public function str_ccr_attributevalue get_ccr_attributevalue (ref str_element pstr_element)
public function str_ccr_objectattribute get_ccr_objectattribute (ref str_element pstr_element)
public function str_ccr_codeddescriptiontype get_ccr_codeddescriptiontype (ref str_element pstr_element)
public function str_communication_type get_communication_type (ref str_element pstr_element)
public function str_person_type get_ccr_personnametype (ref str_element pstr_element)
public function str_ccr_person_name get_ccr_person_name (ref str_element pstr_element)
public function str_ccr_person get_ccr_person (ref str_element pstr_element)
public function datetime get_ccr_datetime (ref str_element pstr_element)
public function str_problem_type get_ccr_problem_type (str_element pstr_element)
public function str_ccr_datetimetype get_ccr_datetimetype (ref str_element pstr_element)
public function str_ccr_units_type get_ccr_units_type (ref str_element pstr_element)
public function str_ccr_measuretype get_ccr_measuretype (ref str_element pstr_element)
public function str_ccr_datetime_rangepart get_ccr_datetime_rangepart (ref str_element pstr_element)
public function str_ccr_datetime_range get_ccr_datetime_range (ref str_element pstr_element)
public function str_ccr_actorreferencetype get_ccr_actorreferencetype (ref str_element pstr_element)
public function str_ccr_idtype get_ccr_idtype (ref str_element pstr_element)
public function str_ccr_sourcetype get_ccr_sourcetype (ref str_element pstr_element)
public function str_ccr_slrcgroup get_ccr_slrcgroup (ref str_element pstr_element)
public function str_ccr_internalccrlink_type get_ccr_internalccrlink_type (ref str_element pstr_element)
public function str_ccr_signatureid_type get_ccr_signatureid_type (ref str_element pstr_element)
public function str_ccr_ccrcodeddataobjecttype get_ccr_ccrcodeddataobjecttype (ref str_element pstr_element)
public function str_ccr_problemtype get_ccr_problemtype (ref str_element pstr_element)
public function str_ccr_body get_ccr_body (ref str_element pstr_element)
public function str_ccr_purposetype get_ccr_purposetype (ref str_element pstr_element)
public function str_ccr_continuityofcarerecord get_ccr_continuityofcarerecord (ref str_element pstr_element)
public function str_ccr_alert_type get_ccr_alert_type (ref str_element pstr_element)
public function str_ccr_agent get_ccr_agent (ref str_element pstr_element)
public function str_ccr_structuredproducttype get_ccr_structuredproducttype (ref str_element pstr_element)
public function str_ccr_codeddescriptiontype_2 get_ccr_codeddescriptiontype_2 (ref str_element pstr_element)
public function str_ccr_product_type get_ccr_product_type (ref str_element pstr_element)
public function str_ccr_size_type get_ccr_size_type (ref str_element pstr_element)
public function str_ccr_dimension_type get_ccr_dimension_type (ref str_element pstr_element)
public function str_ccr_direction get_ccr_direction (ref str_element pstr_element)
public function str_ccr_dose_type get_ccr_dose_type (ref str_element pstr_element)
public function str_ccr_datetimetype_2 get_ccr_datetimetype_2 (ref str_element pstr_element)
public function str_ccr_refill get_ccr_refill (ref str_element pstr_element)
public function str_ccr_reaction get_ccr_reaction (ref str_element pstr_element)
public function str_ccr_resulttype get_ccr_resulttype (ref str_element pstr_element)
public function str_ccr_testresulttype get_ccr_testresulttype (ref str_element pstr_element)
public function str_ccr_testtype get_ccr_testtype (ref str_element pstr_element)
public function str_patient translate_ccr_patient_info (str_ccr_continuityofcarerecord pstr_ccr)
public function integer process_ccr (ref str_ccr_continuityofcarerecord pstr_ccr)
public function str_assessment_description translate_ccr_problem_info (ref str_ccr_continuityofcarerecord pstr_ccr, ref str_ccr_problemtype pstr_problem)
public function integer process_problem (str_ccr_continuityofcarerecord pstr_ccr, ref str_ccr_problemtype pstr_problem)
public function integer process_alert (str_ccr_continuityofcarerecord pstr_ccr, ref str_ccr_alert_type pstr_alert)
public function str_assessment_description translate_ccr_alert_info (ref str_ccr_continuityofcarerecord pstr_ccr, ref str_ccr_alert_type pstr_alert)
public function integer process_structuredproduct (ref str_ccr_continuityofcarerecord pstr_ccr, ref str_ccr_structuredproducttype pstr_product, string ps_default_treatment_type, long parent_treatment_id)
public function integer process_resulttype (ref str_ccr_continuityofcarerecord pstr_ccr, ref str_ccr_resulttype pstr_result, string ps_default_treatment_type, long parent_treatment_id)
public function str_observation_type translate_ccr_testtype (ref str_ccr_continuityofcarerecord pstr_ccr, ref str_treatment_description pstr_treatment, ref str_ccr_testtype pstr_test)
public function integer translate_ccr_testresulttype (ref str_ccr_continuityofcarerecord pstr_ccr, ref str_treatment_description pstr_treatment, ref str_observation_type pstr_observation, ref str_ccr_testresulttype pstr_result)
public function str_observation_type get_empty_observation ()
public function str_observation_result_type get_empty_observation_result ()
public function str_treatment_description translate_ccr_structuredproduct_info (ref str_ccr_continuityofcarerecord pstr_ccr, ref str_ccr_structuredproducttype pstr_product, string ps_default_treatment_type)
end prototypes

protected function integer xx_initialize ();
setnull(consultant_id)

results_from_progress_type = get_attribute("results_from_progress_type")
if isnull(results_from_progress_type) then results_from_progress_type = "Property"

results_from_progress_key = get_attribute("results_from_progress_type")
if isnull(results_from_progress_key) then results_from_progress_key = "consultant_id"


return 1

end function

protected function integer xx_interpret_xml ();PBDOM_ELEMENT lo_root
datetime ldt_result_expected_date
integer li_sts
int i
string ls_root
string ls_tag
long ll_count
boolean lb_haschildren
str_element lstr_element
boolean lb_auto_create
boolean lb_prompt_user
string ls_value
str_jmjdocumentcontext_type lstr_jmjdocumentcontext_type
boolean lb_new_object
string ls_actorid
str_actor_type lstr_actor
string ls_owner_name

TRY
	lo_root = xml.XML_Document.GetRootElement()
	ls_root = lo_root.getname()
CATCH (pbdom_exception lo_error)
	log.log(this, "u_component_xml_handler_ccr.xx_interpret_xml:0023", "Error - " + lo_error.text, 4)
	return -1
END TRY

if isnull(ls_root) or lower(ls_root) <> "continuityofcarerecord" then
	log.log(this, "u_component_xml_handler_ccr.xx_interpret_xml:0028", "Error - Document root is not 'ContinuityOfCareRecord'", 4)
	return -1
end if

lstr_element = get_element(lo_root)
ccr_continuityofcarerecord = get_ccr_continuityofcarerecord(lstr_element)

if actor_count = 0 then
	log.log(this, "u_component_xml_handler_ccr.xx_interpret_xml:0036", "Error - Document has no actors", 4)
	return -1
end if


if isnull(customer_id) then
	customer_id = sqlca.customer_id
end if

owner_id = customer_id

// try to determine the document owner_id
for i = 1 to upperbound(ccr_continuityofcarerecord.ccrfrom)
	setnull(ls_owner_name)
	ls_actorid = ccr_continuityofcarerecord.ccrfrom[i].actorid
	li_sts = get_actor(ls_actorid, lstr_actor)
	if li_sts > 0 then
		if len(lstr_actor.informationsystem.name) > 0 then
			ls_owner_name = lstr_actor.informationsystem.name
		elseif  len(lstr_actor.organization.name) > 0 then
			ls_owner_name = lstr_actor.organization.name
		end if
	end if
	
	if len(ls_owner_name) > 0 then
//		owner_id = sqlca.fn_find_owner(ls_owner_name)
	end if
next



// If we found a patient actor then process the patient into EncounterPRO
if ccr_continuityofcarerecord.patient.actor_id > 0 then
	patientrecord_found = true
	// Get the patient info into a str_patient structure for using with the find_patient() method
	epro_patient = translate_ccr_patient_info(ccr_continuityofcarerecord)

//	interpret_objectcreate("Patient", patientrecord.patienthandling.objectcreate, lb_auto_create, lb_prompt_user)
	lb_auto_create = false
	lb_prompt_user = true

	li_sts = find_patient(epro_patient, lb_auto_create, lb_prompt_user, lb_new_object)
	if li_sts <= 0 then
		log.log(this,"u_component_xml_handler_ccr.xx_interpret_xml:0079","unable to find a patient record",4)
		return -1
	end if
	
	li_sts = process_ccr(ccr_continuityofcarerecord)
	if li_sts < 0 then return -1
end if


if len(document_context.cpr_id) > 0 then
	// Set the context keys where there was only one object
	if encounter_count = 1 and isnull(document_context.encounter_id) then
		document_context.encounter_id = encounter_id[1]
	end if
	if treatment_count = 1  and isnull(document_context.treatment_id) then
		document_context.treatment_id = treatment_id[1]
	end if
	if assessment_count = 1  and isnull(document_context.problem_id) then
		document_context.problem_id = problem_id[1]
	end if
end if

// If there was a message block in the primary context block, then send the message
if not isnull(jmjdocumentcontext.message.messageid) then
	li_sts = send_message(f_context_from_complete_context(document_context), jmjdocumentcontext.message)
	if li_sts < 0 then return -1
end if


return 1


end function

public function integer process_patient (ref str_patientrecord_type pstr_patient);integer li_sts
string ls_tag
long i
long ll_count
str_context lstr_context
long ll_null

setnull(ll_null)

// Process all the encounters
ll_count = upperbound(pstr_patient.encounter)
for i = 1 to ll_count
	li_sts = process_encounter(pstr_patient, pstr_patient.encounter[i])
	if li_sts < 0 then return -1
next
	
// Process all the assessments
ll_count = upperbound(pstr_patient.assessment)
for i = 1 to ll_count
	li_sts = process_assessment(pstr_patient, pstr_patient.assessment[i])
	if li_sts < 0 then return -1
next

// Process all the treatments
ll_count = upperbound(pstr_patient.treatment)
for i = 1 to ll_count
	li_sts = process_treatment(pstr_patient, pstr_patient.treatment[i], ll_null)
	if li_sts < 0 then return -1
next

// Process all the patient message
ll_count = upperbound(pstr_patient.message)
for i = 1 to ll_count
	lstr_context.cpr_id = my_context.cpr_id
	lstr_context.context_object = "Patient"
	setnull(lstr_context.object_key)
	li_sts = send_message(lstr_context, pstr_patient.message[i])
	if li_sts < 0 then return -1
next

return 1


end function

public function integer process_assessment (ref str_patientrecord_type pstr_patient_info, ref str_assessment_instance_type pstr_assessment_info);long i
integer li_sts
string ls_null
long ll_null
string ls_temp
long j
long ll_assessment_count
str_assessment_description lstr_assessment
string ls_find
string ls_date
long ll_problem_id
long lla_assessment_ids[]
integer li_null
long ll_attachment_id
boolean lb_auto_create
boolean lb_prompt_user
str_objecthandling_type lstr_handling
long ll_count
str_context lstr_context
boolean lb_new_object
long ll_patient_workplan_id
string ls_new_object
string ls_purpose

setnull(ls_null)
setnull(ll_null)
setnull(li_null)


// Transfer to assessment_description structure
lstr_assessment = translate_assessment_info(pstr_patient_info, pstr_assessment_info)

// if the treatment doesn't have a handling block, then use the patient handling instructions
if len(pstr_assessment_info.assessmenthandling.objectcreate) > 0 then
	lstr_handling = pstr_assessment_info.assessmenthandling
else
	lstr_handling = pstr_patient_info.patienthandling
end if

interpret_objectcreate("Assessment", lstr_handling.objectcreate, lb_auto_create, lb_prompt_user)


ll_problem_id = find_assessment(lstr_assessment, lb_auto_create, lb_prompt_user, lb_new_object)
if isnull(ll_problem_id) then 
	log.log(this, "u_component_xml_handler_ccr.process_assessment:0045", "Unable to find or create assessment", 4)
	return -1
end if


// See if this assessment block has a purpose
if len(pstr_assessment_info.assessmenthandling.purpose) > 0 then
	ls_purpose = pstr_assessment_info.assessmenthandling.purpose
end if

// See if this is the primary context for this document
if lower(jmjdocumentcontext.contextobject) = "assessment" then
	if isnull(jmjdocumentcontext.assessmentid) then
		// If the document has context_object = assessment and a null assessmentid, then the document
		// purpose applies to all assessments that don't already have a purpose
		if isnull(ls_purpose) and len(document_context.purpose) > 0 then
			ls_purpose = document_context.purpose
		end if
	elseif lower(jmjdocumentcontext.assessmentid) = lower(pstr_assessment_info.assessmentid) then
		document_context.problem_id = ll_problem_id

		// If this treatment block is the primary context for this document and the treatment block doesn't have a purpose
		// and the document does have a purpose, then use the document purpose
		if isnull(ls_purpose) and len(document_context.purpose) > 0 then
			ls_purpose = document_context.purpose
		end if
	end if
end if


my_context.problem_id = ll_problem_id
assessment_count += 1
problem_id[assessment_count] = ll_problem_id

// Now add the assessment Notes

for i = 1 to upperbound(pstr_assessment_info.assessmentnote)
	if len(pstr_assessment_info.assessmentnote[i].NoteAttachment.filetype) > 0 &
	 AND len(pstr_assessment_info.assessmentnote[i].NoteAttachment.attachmentdata) > 0 then
		ll_attachment_id = f_new_attachment("Treatment", &
							ll_problem_id, &
							pstr_assessment_info.assessmentnote[i].NoteType, &
							pstr_assessment_info.assessmentnote[i].NoteKey, &
							pstr_assessment_info.assessmentnote[i].NoteAttachment.filetype, &
							ls_null, &
							pstr_assessment_info.assessmentnote[i].NoteAttachment.attachmentname, &
							pstr_assessment_info.assessmentnote[i].NoteAttachment.filename, &
							pstr_assessment_info.assessmentnote[i].NoteAttachment.attachmentdata)
		if ll_attachment_id < 0 then return -1
	elseif len(pstr_assessment_info.assessmentnote[i].NoteText) > 0 then
		li_sts = f_set_progress2(my_context.cpr_id, &
										"assessment", &
										ll_problem_id, &
										pstr_assessment_info.assessmentnote[i].notetype, &
										pstr_assessment_info.assessmentnote[i].notekey, &
										pstr_assessment_info.assessmentnote[i].notetext, &
										pstr_assessment_info.assessmentnote[i].notedate, &
										ll_null, &
										ll_null, &
										ll_null, &
										li_null, &
										string(pstr_assessment_info.assessmentnote[i].noteseverity))
	end if
next


// Process all the assessment messages
ll_count = upperbound(pstr_assessment_info.message)
for i = 1 to ll_count
	lstr_context.cpr_id = my_context.cpr_id
	lstr_context.context_object = "Assessment"
	lstr_context.object_key = ll_problem_id
	li_sts = send_message(lstr_context, pstr_assessment_info.message[i])
	if li_sts < 0 then return -1
next

// Finally, order any workplan designated by the purpose
if len(ls_purpose) > 0 then
	if lb_new_object then
		ls_new_object = "Y"
	else
		ls_new_object = "N"
	end if
	ll_patient_workplan_id = sqlca.jmj_document_order_workplan( my_context.cpr_id, &
																					"Assessment", &
																					ll_problem_id, &
																					ls_purpose, &
																					ls_new_object, &
																					current_user.user_id, &
																					current_scribe.user_id, &
																					ls_null )
end if

return 1

end function

public function integer process_encounter (ref str_patientrecord_type pstr_patient_info, ref str_encounter_type pstr_encounter_info);long i
integer li_sts
string ls_null
long ll_null
string ls_temp
long j
long ll_encounter_count
str_encounter_description lstr_encounter
string ls_find
string ls_date
long ll_encounter_id
long lla_encounter_ids[]
integer li_null
long ll_attachment_id
boolean lb_auto_create
boolean lb_prompt_user
str_objecthandling_type lstr_handling
long ll_count
str_context lstr_context
boolean lb_new_object
long ll_patient_workplan_id
string ls_new_object
string ls_purpose

setnull(ls_null)
setnull(ll_null)
setnull(li_null)


// Transfer to encounter_description structure
lstr_encounter = translate_encounter_info(pstr_patient_info, pstr_encounter_info)

// if the treatment doesn't have a handling block, then use the patient handling instructions
if len(pstr_encounter_info.encounterhandling.objectcreate) > 0 then
	lstr_handling = pstr_encounter_info.encounterhandling
else
	lstr_handling = pstr_patient_info.patienthandling
end if

interpret_objectcreate("Encounter", lstr_handling.objectcreate, lb_auto_create, lb_prompt_user)

ll_encounter_id = find_encounter(lstr_encounter, lb_auto_create, lb_prompt_user, false, lb_new_object)
if isnull(ll_encounter_id) then 
	log.log(this, "u_component_xml_handler_ccr.process_encounter:0044", "Unable to find or create encounter", 4)
	return -1
end if

// See if this encounter block has a purpose
if len(pstr_encounter_info.encounterhandling.purpose) > 0 then
	ls_purpose = pstr_encounter_info.encounterhandling.purpose
end if

// See if this is the primary context for this document
if lower(jmjdocumentcontext.contextobject) = "encounter" then
	if isnull(jmjdocumentcontext.encounterid) then
		// If the document has context_object = encounter and a null encounterid, then the document
		// purpose applies to all encounters that don't already have a purpose
		if isnull(ls_purpose) and len(document_context.purpose) > 0 then
			ls_purpose = document_context.purpose
		end if
	elseif lower(jmjdocumentcontext.encounterid) = lower(pstr_encounter_info.encounterid) then
		document_context.encounter_id = ll_encounter_id

		// If this treatment block is the primary context for this document and the treatment block doesn't have a purpose
		// and the document does have a purpose, then use the document purpose
		if isnull(ls_purpose) and len(document_context.purpose) > 0 then
			ls_purpose = document_context.purpose
		end if
	end if
end if

my_context.encounter_id = ll_encounter_id
encounter_count += 1
encounter_id[encounter_count] = ll_encounter_id

// Now add the Encounter Notes

for i = 1 to upperbound(pstr_encounter_info.encounternote)
	if len(pstr_encounter_info.encounternote[i].NoteAttachment.filetype) > 0 &
	 AND len(pstr_encounter_info.encounternote[i].NoteAttachment.attachmentdata) > 0 then
		ll_attachment_id = f_new_attachment("Treatment", &
							ll_encounter_id, &
							pstr_encounter_info.encounternote[i].NoteType, &
							pstr_encounter_info.encounternote[i].NoteKey, &
							pstr_encounter_info.encounternote[i].NoteAttachment.filetype, &
							ls_null, &
							pstr_encounter_info.encounternote[i].NoteAttachment.attachmentname, &
							pstr_encounter_info.encounternote[i].NoteAttachment.filename, &
							pstr_encounter_info.encounternote[i].NoteAttachment.attachmentdata)
		if ll_attachment_id < 0 then return -1
	elseif len(pstr_encounter_info.encounternote[i].NoteText) > 0 then
		li_sts = f_set_progress2(my_context.cpr_id, &
										"Encounter", &
										ll_encounter_id, &
										pstr_encounter_info.encounternote[i].notetype, &
										pstr_encounter_info.encounternote[i].notekey, &
										pstr_encounter_info.encounternote[i].notetext, &
										pstr_encounter_info.encounternote[i].notedate, &
										ll_null, &
										ll_null, &
										ll_null, &
										li_null, &
										string(pstr_encounter_info.encounternote[i].noteseverity))
	end if
next

// Process all the encounter messages
ll_count = upperbound(pstr_encounter_info.message)
for i = 1 to ll_count
	lstr_context.cpr_id = my_context.cpr_id
	lstr_context.context_object = "Encounter"
	lstr_context.object_key = ll_encounter_id
	li_sts = send_message(lstr_context, pstr_encounter_info.message[i])
	if li_sts < 0 then return -1
next

// Finally, order any workplan designated by the purpose
if len(ls_purpose) > 0 then
	if lb_new_object then
		ls_new_object = "Y"
	else
		ls_new_object = "N"
	end if
	ll_patient_workplan_id = sqlca.jmj_document_order_workplan( my_context.cpr_id, &
																					"Encounter", &
																					ll_encounter_id, &
																					ls_purpose, &
																					ls_new_object, &
																					current_user.user_id, &
																					current_scribe.user_id, &
																					ls_null )
end if

return 1

end function

public subroutine interpret_objectcreate (string ps_context_object, string ps_objectcreate, ref boolean pb_auto_create, ref boolean pb_prompt_user);
CHOOSE CASE lower(ps_objectcreate) 
	CASE "createifnotfound"
		pb_auto_create  = true
		pb_prompt_user = true
	CASE "createalways"
		pb_auto_create  = true
		pb_prompt_user = true
	CASE "createnever"
		pb_auto_create  = false
		pb_prompt_user = true
	CASE ELSE
		CHOOSE CASE lower(ps_context_object)
			CASE "patient"
				pb_auto_create  = false
				pb_prompt_user = true
			CASE "encounter"
				pb_auto_create  = true
				pb_prompt_user = true
			CASE "assessment"
				pb_auto_create  = true
				pb_prompt_user = true
			CASE "treatment"
				pb_auto_create  = false
				pb_prompt_user = true
			CASE ELSE
				pb_auto_create  = false
				pb_prompt_user = true
		END CHOOSE
END CHOOSE


return

end subroutine

public function integer process_treatment (ref str_patientrecord_type pstr_patient_info, ref str_treatment_type pstr_treatment_info, long parent_treatment_id);long i
integer li_sts
string ls_null
long ll_null
string ls_temp
long j
long ll_treatment_count
str_treatment_description lstr_treatment
string ls_find
string ls_date
long lla_treatment_ids[]
integer li_null
long ll_observation_count
boolean lb_auto_create
long ll_encounter_id
datetime ldt_null
string ls_consultant_id
long ll_treatmentnote_count
long ll_assessment_count
long ll_attachment_id
boolean lb_prompt_user
string ls_observation_tag
long ll_problem_id
str_objecthandling_type lstr_handling
long ll_count
str_context lstr_context
string ls_purpose
long ll_patient_workplan_id
string ls_new_object
boolean lb_new_object

setnull(ls_null)
setnull(ll_null)
setnull(li_null)
setnull(ldt_null)
setnull(ls_purpose)

ll_observation_count = upperbound(pstr_treatment_info.observation)

// Transfer to treatment_description structure
lstr_treatment = translate_treatment_info(pstr_patient_info, pstr_treatment_info)

// Set the parent if there is one
lstr_treatment.parent_treatment_id = parent_treatment_id

// If we still don't have a treatment description then report an error
if isnull(lstr_treatment.treatment_description) then
	log.log(this,"u_component_xml_handler_ccr.process_treatment:0048","No treatment description provided in treatment block", 4)
	return -1
end if

if lstr_treatment.parent_treatment_id > 0 then
	// If this is a child treatment, then always create and don't prompt the user
	lb_auto_create = true
	lb_prompt_user = false
else
	// if the treatment doesn't have a handling block, then use the patient handling instructions
	if len(pstr_treatment_info.treatmenthandling.objectcreate) > 0 then
		lstr_handling = pstr_treatment_info.treatmenthandling
	else
		lstr_handling = pstr_patient_info.patienthandling
	end if
	
	interpret_objectcreate("Treatment", lstr_handling.objectcreate, lb_auto_create, lb_prompt_user)
end if

lstr_treatment.treatment_id = find_treatment(lstr_treatment, lb_auto_create, lb_prompt_user, lb_new_object)
if isnull(lstr_treatment.treatment_id) then
	log.log(this,"u_component_xml_handler_ccr.process_treatment:0069","unable to find or create treatment",4)
	return -1
end if

// See if this treatment block has a purpose
if len(pstr_treatment_info.treatmenthandling.purpose) > 0 then
	ls_purpose = pstr_treatment_info.treatmenthandling.purpose
end if

// See if this is the primary context for this document
if lower(jmjdocumentcontext.contextobject) = "treatment" then
	if isnull(jmjdocumentcontext.treatmentid) then
		// If the document has context_object = treatment and a null treatmentid, then the document
		// purpose applies to all root-level treatments that don't already have a purpose
		if isnull(ls_purpose) and isnull(parent_treatment_id) and len(document_context.purpose) > 0 then
			ls_purpose = document_context.purpose
		end if
	elseif lower(jmjdocumentcontext.treatmentid) = lower(pstr_treatment_info.treatmentid) then
		document_context.treatment_id = lstr_treatment.treatment_id

		// If this treatment block is the primary context for this document and the treatment block doesn't have a purpose
		// and the document does have a purpose, then use the document purpose
		if isnull(ls_purpose) and len(document_context.purpose) > 0 then
			ls_purpose = document_context.purpose
		end if
	end if
end if

my_context.treatment_id = lstr_treatment.treatment_id
treatment_count += 1
treatment_id[treatment_count] = lstr_treatment.treatment_id


// Create Treatment Observations
If ll_observation_count > 0 then
	// find encounter id from the treatment id
	SELECT open_encounter_id
		INTO :ll_encounter_id
	FROM p_treatment_item
	WHERE treatment_id = :lstr_treatment.treatment_id;
	if not tf_check() then return -1

	// If we don't already have an encounter_id, then get it from the treatment, or from the current context
	if isnull(lstr_treatment.encounter_id) then
		if ll_encounter_id > 0 then
			lstr_treatment.encounter_id = ll_encounter_id
		elseif my_context.encounter_id > 0 then
			lstr_treatment.encounter_id = my_context.encounter_id
		end if
	end if

	For i = 1 to ll_observation_count
		// Set the observation tag to the status
		setnull(ls_observation_tag)
		if len(pstr_treatment_info.observation[i].observationstatus) > 0 then
			ls_observation_tag = pstr_treatment_info.observation[i].observationstatus
		elseif  len(pstr_treatment_info.treatmentstatus) > 0 then
			// If there isn't an observation status set, but there is a treatment status set, then inherit the treatment status
			ls_observation_tag = pstr_treatment_info.treatmentstatus
		end if
		
		// Make sure the tag is only 12 characters
		ls_observation_tag = left(ls_observation_tag, 12)
		
		li_sts = add_observation_and_results(lstr_treatment.treatment_id, lstr_treatment, pstr_treatment_info.observation[i], ls_observation_tag, lstr_treatment.encounter_id, ll_null)
		if li_sts < 0 then return -1
	Next
End If

// Mark 1/4/07 commented out because the new_treatment() method will establish the relationship for new treatments,
// and we don't want to mess with the associations of existing treatments
//
//// Process the assessment associations
//ll_assessment_count = upperbound(pstr_treatment_info.assessment)
//For i = 1 to ll_assessment_count
//	ll_problem_id = get_object_key_from_id(pstr_patient_info, "Assessment", pstr_treatment_info.assessment[i].id)
//	if ll_problem_id > 0 then
//		li_sts = f_set_progress(my_context.cpr_id, &
//							"Treatment", &
//							lstr_treatment.treatment_id, &
//							"ASSESSMENT", &
//							"Associate", &
//							string(ll_problem_id), &
//							ldt_null, &
//							ll_null, &
//							ll_null, &
//							ll_null)
//		if li_sts < 0 then return -1
//	end if
//Next
//

// See if there are any instructions
if len(pstr_treatment_info.medication.dosinginstructions) > 0 then
	li_sts = f_set_progress(my_context.cpr_id, &
						"Treatment", &
						lstr_treatment.treatment_id, &
						"Instructions", &
						"Dosing Instructions", &
						pstr_treatment_info.medication.dosinginstructions, &
						ldt_null, &
						ll_null, &
						ll_null, &
						ll_null)
end if
if len(pstr_treatment_info.medication.admininstructions) > 0 then
	li_sts = f_set_progress(my_context.cpr_id, &
						"Treatment", &
						lstr_treatment.treatment_id, &
						"Instructions", &
						"Admin Instructions", &
						pstr_treatment_info.medication.admininstructions, &
						ldt_null, &
						ll_null, &
						ll_null, &
						ll_null)
end if
if len(pstr_treatment_info.medication.patientinstructions) > 0 then
	li_sts = f_set_progress(my_context.cpr_id, &
						"Treatment", &
						lstr_treatment.treatment_id, &
						"Instructions", &
						"Patient Instructions", &
						pstr_treatment_info.medication.patientinstructions, &
						ldt_null, &
						ll_null, &
						ll_null, &
						ll_null)
end if
if len(pstr_treatment_info.medication.pharmacistinstructions) > 0 then
	li_sts = f_set_progress(my_context.cpr_id, &
						"Treatment", &
						lstr_treatment.treatment_id, &
						"Instructions", &
						"Pharmacist Instructions", &
						pstr_treatment_info.medication.pharmacistinstructions, &
						ldt_null, &
						ll_null, &
						ll_null, &
						ll_null)
end if

// Process the TreatmentNote blocks
ll_treatmentnote_count = upperbound(pstr_treatment_info.treatmentnote)
For i = 1 to ll_treatmentnote_count
	if len(pstr_treatment_info.treatmentnote[i].NoteAttachment.filetype) > 0 &
	 AND len(pstr_treatment_info.treatmentnote[i].NoteAttachment.attachmentdata) > 0 then
		ll_attachment_id = f_new_attachment("Treatment", &
							lstr_treatment.treatment_id, &
							pstr_treatment_info.treatmentnote[i].NoteType, &
							pstr_treatment_info.treatmentnote[i].NoteKey, &
							pstr_treatment_info.treatmentnote[i].NoteAttachment.filetype, &
							ls_null, &
							pstr_treatment_info.treatmentnote[i].NoteAttachment.attachmentname, &
							pstr_treatment_info.treatmentnote[i].NoteAttachment.filename, &
							pstr_treatment_info.treatmentnote[i].NoteAttachment.attachmentdata)
		if ll_attachment_id < 0 then return -1
	elseif len(pstr_treatment_info.treatmentnote[i].NoteText) > 0 then
		// set the treatment progress record
		li_sts = f_set_progress(my_context.cpr_id, &
							"Treatment", &
							lstr_treatment.treatment_id, &
							pstr_treatment_info.treatmentnote[i].NoteType, &
							pstr_treatment_info.treatmentnote[i].NoteKey, &
							pstr_treatment_info.treatmentnote[i].NoteText, &
							pstr_treatment_info.treatmentnote[i].NoteDate, &
							ll_null, &
							ll_null, &
							ll_null)
		if li_sts < 0 then return -1
	end if
Next


// set the treatment progress record
if len(pstr_treatment_info.treatmentstatus) > 0 then
	f_set_progress(my_context.cpr_id, &
						"Treatment", &
						lstr_treatment.treatment_id, &
						"Results", &
						"Status", &
						pstr_treatment_info.treatmentstatus, &
						ldt_null, &
						ll_null, &
						ll_null, &
						ll_null)
end if


if len(consultant_id) > 0 then
	// If we're associated with a consultant, and this treatment is not yet associated
	// with a consultant, then associate this treatment with the consultant
	ls_consultant_id = sqlca.fn_patient_object_progress_value(my_context.cpr_id, &
																				'Treatment', &
																				results_from_progress_type, &
																				lstr_treatment.treatment_id, &
																				results_from_progress_key)

	if isnull(ls_consultant_id) or ls_consultant_id <> consultant_id then
		f_set_progress(my_context.cpr_id, &
							"Treatment", &
							lstr_treatment.treatment_id, &
							results_from_progress_type, &
							results_from_progress_key, &
							consultant_id, &
							ldt_null, &
							ll_null, &
							ll_null, &
							ll_null)
	end if	
end if

// Process all the encounter messages
ll_count = upperbound(pstr_treatment_info.message)
for i = 1 to ll_count
	lstr_context.cpr_id = my_context.cpr_id
	lstr_context.context_object = "Treatment"
	lstr_context.object_key = lstr_treatment.treatment_id
	li_sts = send_message(lstr_context, pstr_treatment_info.message[i])
	if li_sts < 0 then return -1
next

//// Process all the constituent treatment messages
//ll_count = upperbound(pstr_treatment_info.constituenttreatment)
//for i = 1 to ll_count
//	process_treatment(pstr_patient_info, pstr_treatment_info.constituenttreatment[i].constituenttreatment, lstr_treatment.treatment_id)
//next


// Finally, order any workplan designated by the purpose
if len(ls_purpose) > 0 then
	if lb_new_object then
		ls_new_object = "Y"
	else
		ls_new_object = "N"
	end if
	ll_patient_workplan_id = sqlca.jmj_document_order_workplan( my_context.cpr_id, &
																					"Treatment", &
																					lstr_treatment.treatment_id, &
																					ls_purpose, &
																					ls_new_object, &
																					current_user.user_id, &
																					current_scribe.user_id, &
																					ls_null )
end if

Return 1


end function

public function str_actor_type get_actor_type (ref str_element pstr_element);string ls_actor
str_actor_type lstr_actor
long i
long ll_objectid_count
long ll_address_count
long ll_communication_count
str_element lstr_element
string ls_description
string ls_null
string ls_contact
string ls_director
long ll_count
str_ccr_person lstr_ccr_person
str_ccr_idtype lstr_ccr_idtype

setnull(ls_null)

setnull(lstr_actor.actorclass)
setnull(lstr_actor.actor_id)
setnull(lstr_actor.user_id)
setnull(lstr_actor.name)
setnull(ls_description)

if not pstr_element.valid then return lstr_actor

ll_objectid_count = 0
ll_address_count = 0
ll_communication_count = 0

// Assume that this is a "actor" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "actorobjectid"
			lstr_actor.actorobjectid = pstr_element.child[i].gettexttrim()
		CASE "ids"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_idtype = get_ccr_idtype(lstr_element)
			if len(lstr_ccr_idtype.idtype.text) > 0 then
				ll_objectid_count += 1
				lstr_actor.objectid[ll_objectid_count].iddomain = lstr_ccr_idtype.idtype.text
				lstr_actor.objectid[ll_objectid_count].idvalue = lstr_ccr_idtype.id
			end if
//		CASE "actorclass"
//			lstr_actor.actorclass = pstr_element.child[i].gettexttrim()
		CASE "person"
			lstr_actor.actorclass = "Person"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_person = get_ccr_person(lstr_element)

			// Assume current name has fields we want
			lstr_actor.person = lstr_ccr_person.name.currentname
			lstr_actor.person.dateofbirth = lstr_ccr_person.dateofbirth
			lstr_actor.person.gender = lstr_ccr_person.gender

			ls_description = f_pretty_name(lstr_actor.person.lastname, &
																lstr_actor.person.firstname, &
																lstr_actor.person.middlename, &
																lstr_actor.person.suffix, &
																lstr_actor.person.prefix, &
																lstr_actor.person.degree )
		CASE "organization"
			lstr_actor.actorclass = "Organization"
			lstr_element = get_element(pstr_element.child[i])
			lstr_actor.organization = get_organization_type(lstr_element)
			ls_description = lstr_actor.organization.name
		CASE "informationsystem"
			lstr_actor.actorclass = "InformationSystem"
			lstr_element = get_element(pstr_element.child[i])
			lstr_actor.informationsystem = get_informationsystem_type(lstr_element)
			ls_description = lstr_actor.informationsystem.name
		CASE "address"
			ll_address_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_actor.address[ll_address_count] = get_address_type(lstr_element)
		CASE "telephone"
			ll_communication_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_actor.communication[ll_communication_count] = get_communication_type(lstr_element)
			lstr_actor.communication[ll_communication_count].communication_type = "Phone"
		CASE "email"
			ll_communication_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_actor.communication[ll_communication_count] = get_communication_type(lstr_element)
			lstr_actor.communication[ll_communication_count].communication_type = "Email"
		CASE "url"
			ll_communication_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_actor.communication[ll_communication_count] = get_communication_type(lstr_element)
			lstr_actor.communication[ll_communication_count].communication_type = "URL"
	END CHOOSE
next

if isnull(lstr_actor.name) and len(ls_description) > 0 then
	lstr_actor.name = ls_description
end if


CHOOSE CASE lower(lstr_actor.actorclass)
	CASE "user"
		for i = 1 to upperbound(lstr_actor.objectid)
			if lstr_actor.objectid[i].epro_domain = "user_id" then
				lstr_actor.user_id = lstr_actor.objectid[i].epro_value
			end if
		next
	CASE "person"
		lstr_actor.actor_id = sqlca.sp_new_actor( lstr_actor.actorclass,&
															lstr_actor.name,&
															lstr_actor.person.lastname,&
															lstr_actor.person.firstname,&
															lstr_actor.person.middlename,&
															lstr_actor.person.prefix,&
															lstr_actor.person.suffix, &
															lstr_actor.person.degree,&
															lstr_actor.person.title,&
															ls_null,&
															ls_null,&
															ls_null,&
															ls_null )
		tf_check()
	CASE "organization"
		ls_contact = f_pretty_name(lstr_actor.organization.contact.lastname, &
											lstr_actor.organization.contact.firstname, &
											lstr_actor.organization.contact.middlename, &
											lstr_actor.organization.contact.suffix, &
											lstr_actor.organization.contact.prefix, &
											lstr_actor.organization.contact.degree)
		ls_director = f_pretty_name(lstr_actor.organization.director.lastname, &
											lstr_actor.organization.director.firstname, &
											lstr_actor.organization.director.middlename, &
											lstr_actor.organization.director.suffix, &
											lstr_actor.organization.director.prefix, &
											lstr_actor.organization.director.degree)
		
		lstr_actor.actor_id = sqlca.sp_new_actor( wordcap(lstr_actor.actorclass),&
															lstr_actor.organization.name, &
															ls_null,&
															ls_null,&
															ls_null,&
															ls_null,&
															ls_null,&
															ls_null,&
															ls_null,&
															ls_null,&
															ls_null,&
															ls_contact,&
															ls_director )
		tf_check()
	CASE "informationsystem"
		lstr_actor.actor_id = sqlca.sp_new_actor( wordcap(lstr_actor.actorclass),&
															lstr_actor.informationsystem.name, &
															ls_null,&
															ls_null,&
															ls_null,&
															ls_null,&
															ls_null,&
															ls_null,&
															ls_null,&
															lstr_actor.informationsystem.informationsystem_type,&
															lstr_actor.informationsystem.version,&
															ls_null,&
															ls_null )
		tf_check()
	CASE ELSE
		if len(lstr_actor.name) > 0 then
			if isnull(lstr_actor.actorclass) then lstr_actor.actorclass = "DataSource"
			lstr_actor.actor_id = sqlca.sp_new_actor( wordcap(lstr_actor.actorclass),&
																lstr_actor.name, &
																ls_null,&
																ls_null,&
																ls_null,&
																ls_null,&
																ls_null,&
																ls_null,&
																ls_null,&
																ls_null,&
																ls_null,&
																ls_null,&
																ls_null )
		tf_check()
		end if
END CHOOSE

// Find the actual user_id for this actor
if not isnull(lstr_actor.actor_id) then
	if isnull(lstr_actor.user_id) or trim(lstr_actor.user_id) = "" then
		SELECT user_id
		INTO :lstr_actor.user_id
		FROM c_User
		WHERE actor_id = :lstr_actor.actor_id;
		tf_check()
	end if
	
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

end if


return lstr_actor

end function

public function str_address_type get_address_type (ref str_element pstr_element);string ls_description
str_address_type lstr_address_type
long i
long ll_objectid_count
str_element lstr_element
str_ccr_codeddescriptiontype lstr_ccr_codeddescriptiontype

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
		CASE "type"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_codeddescriptiontype = get_ccr_codeddescriptiontype(lstr_element)
			if len(lstr_ccr_codeddescriptiontype.text) > 0 then
				lstr_address_type.description = lstr_ccr_codeddescriptiontype.text
			end if
		CASE "objectid"
			ll_objectid_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_address_type.objectid[ll_objectid_count] = get_objectid_type(lstr_element)
		CASE "description"
			lstr_address_type.description = pstr_element.child[i].gettexttrim()
		CASE "line1"
			lstr_address_type.addressline1 = pstr_element.child[i].gettexttrim()
		CASE "line2"
			lstr_address_type.addressline2 = pstr_element.child[i].gettexttrim()
		CASE "city"
			lstr_address_type.city = pstr_element.child[i].gettexttrim()
		CASE "state"
			lstr_address_type.state = pstr_element.child[i].gettexttrim()
		CASE "postalcode"
			lstr_address_type.zip = pstr_element.child[i].gettexttrim()
		CASE "country"
			lstr_address_type.country = pstr_element.child[i].gettexttrim()
		CASE "priority"
			lstr_address_type.priority = pstr_element.child[i].gettexttrim()
		CASE "status"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_codeddescriptiontype = get_ccr_codeddescriptiontype(lstr_element)
			if len(lstr_ccr_codeddescriptiontype.text) > 0 then
				lstr_address_type.status = lstr_ccr_codeddescriptiontype.text
			end if
	END CHOOSE
next

// Set the default description
if isnull(lstr_address_type.description) then
	lstr_address_type.description = "Address"
end if

return lstr_address_type

end function

public function str_ccr_codetype get_ccr_codetype (ref str_element pstr_element);str_ccr_codetype lstr_ccr_codetype
string ls_description
long i

setnull(lstr_ccr_codetype.value)
setnull(lstr_ccr_codetype.codingsystem)
setnull(lstr_ccr_codetype.version)

if not pstr_element.valid then return lstr_ccr_codetype

// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "value"
			lstr_ccr_codetype.value = pstr_element.child[i].gettexttrim()
		CASE "codingsystem"
			lstr_ccr_codetype.codingsystem = pstr_element.child[i].gettexttrim()
		CASE "version"
			lstr_ccr_codetype.version = pstr_element.child[i].gettexttrim()
	END CHOOSE
next


return lstr_ccr_codetype

end function

public function str_ccr_attributevalue get_ccr_attributevalue (ref str_element pstr_element);str_ccr_attributevalue lstr_ccr_attributevalue
string ls_description
long i
long ll_code_count
str_element lstr_element

setnull(lstr_ccr_attributevalue.value)

ll_code_count = 0

if not pstr_element.valid then return lstr_ccr_attributevalue

// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "value"
			lstr_ccr_attributevalue.value = pstr_element.child[i].gettexttrim()
		CASE "code"
			lstr_element = get_element(pstr_element.child[i])
			ll_code_count += 1
			lstr_ccr_attributevalue.code[ll_code_count] = get_ccr_codetype(lstr_element)
	END CHOOSE
next


return lstr_ccr_attributevalue

end function

public function str_ccr_objectattribute get_ccr_objectattribute (ref str_element pstr_element);str_ccr_objectattribute lstr_ccr_objectattribute
string ls_description
long i
long ll_attributevalue_count
long ll_code_count
str_element lstr_element

setnull(lstr_ccr_objectattribute.attribute)

ll_attributevalue_count = 0
ll_code_count = 0

if not pstr_element.valid then return lstr_ccr_objectattribute

// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "attribute"
			lstr_ccr_objectattribute.attribute = pstr_element.child[i].gettexttrim()
		CASE "attributevalue"
			lstr_element = get_element(pstr_element.child[i])
			ll_attributevalue_count += 1
			lstr_ccr_objectattribute.attributevalue[ll_attributevalue_count] = get_ccr_attributevalue(lstr_element)
		CASE "code"
			lstr_element = get_element(pstr_element.child[i])
			ll_code_count += 1
			lstr_ccr_objectattribute.code[ll_code_count] = get_ccr_codetype(lstr_element)
	END CHOOSE
next


return lstr_ccr_objectattribute

end function

public function str_ccr_codeddescriptiontype get_ccr_codeddescriptiontype (ref str_element pstr_element);str_ccr_codeddescriptiontype lstr_ccr_codeddescriptiontype
string ls_description
long i
long ll_objectattribute_count
long ll_code_count
str_element lstr_element

setnull(lstr_ccr_codeddescriptiontype.text)

ll_objectattribute_count = 0
ll_code_count = 0

if not pstr_element.valid then return lstr_ccr_codeddescriptiontype

// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "text"
			lstr_ccr_codeddescriptiontype.text = pstr_element.child[i].gettexttrim()
		CASE "objectattribute"
			lstr_element = get_element(pstr_element.child[i])
			ll_objectattribute_count += 1
			lstr_ccr_codeddescriptiontype.objectattribute[ll_objectattribute_count] = get_ccr_objectattribute(lstr_element)
		CASE "code"
			lstr_element = get_element(pstr_element.child[i])
			ll_code_count += 1
			lstr_ccr_codeddescriptiontype.code[ll_code_count] = get_ccr_codetype(lstr_element)
	END CHOOSE
next


return lstr_ccr_codeddescriptiontype

end function

public function str_communication_type get_communication_type (ref str_element pstr_element);str_communication_type lstr_communication_type
long i
str_ccr_codeddescriptiontype lstr_ccr_codeddescriptiontype
str_element lstr_element

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
		CASE "value"
			lstr_communication_type.value = pstr_element.child[i].gettexttrim()
		CASE "type"
			// What CCR calls "type" we call communication_name
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_codeddescriptiontype = get_ccr_codeddescriptiontype(lstr_element)
			if len(lstr_ccr_codeddescriptiontype.text) > 0 then
				lstr_communication_type.communication_name = lstr_ccr_codeddescriptiontype.text
			end if
		CASE "priority"
			lstr_communication_type.priority = pstr_element.child[i].gettexttrim()
		CASE "status"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_codeddescriptiontype = get_ccr_codeddescriptiontype(lstr_element)
			if len(lstr_ccr_codeddescriptiontype.text) > 0 then
				lstr_communication_type.status = lstr_ccr_codeddescriptiontype.text
			end if
	END CHOOSE
next

return lstr_communication_type

end function

public function str_person_type get_ccr_personnametype (ref str_element pstr_element);string ls_description
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
setnull(lstr_person_type.nickname)

if not pstr_element.valid then return lstr_person_type

ll_objectid_count = 0

// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "objectid"
			ll_objectid_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_person_type.objectid[ll_objectid_count] = get_objectid_type(lstr_element)
		CASE "family"
			lstr_person_type.lastname = pstr_element.child[i].gettexttrim()
		CASE "given"
			lstr_person_type.firstname = pstr_element.child[i].gettexttrim()
		CASE "middle"
			lstr_person_type.middlename = pstr_element.child[i].gettexttrim()
		CASE "title"
			lstr_person_type.title = pstr_element.child[i].gettexttrim()
		CASE "suffix"
			lstr_person_type.suffix = pstr_element.child[i].gettexttrim()
		CASE "prefix"
			lstr_person_type.prefix = pstr_element.child[i].gettexttrim()
		CASE "degree"
			lstr_person_type.degree = pstr_element.child[i].gettexttrim()
		CASE "nickname"
			lstr_person_type.nickname = pstr_element.child[i].gettexttrim()
	END CHOOSE
next

return lstr_person_type

end function

public function str_ccr_person_name get_ccr_person_name (ref str_element pstr_element);string ls_description
str_ccr_person_name lstr_ccr_person_name
long i
long ll_objectid_count
long ll_additionalname_count
str_element lstr_element
str_element lstr_element2



setnull(lstr_ccr_person_name.displayname)

setnull(lstr_ccr_person_name.birthname.lastname)
setnull(lstr_ccr_person_name.birthname.firstname)
setnull(lstr_ccr_person_name.birthname.middlename)
setnull(lstr_ccr_person_name.birthname.title)
setnull(lstr_ccr_person_name.birthname.suffix)
setnull(lstr_ccr_person_name.birthname.prefix)
setnull(lstr_ccr_person_name.birthname.degree)
setnull(lstr_ccr_person_name.birthname.nickname)

setnull(lstr_ccr_person_name.currentname.lastname)
setnull(lstr_ccr_person_name.currentname.firstname)
setnull(lstr_ccr_person_name.currentname.middlename)
setnull(lstr_ccr_person_name.currentname.title)
setnull(lstr_ccr_person_name.currentname.suffix)
setnull(lstr_ccr_person_name.currentname.prefix)
setnull(lstr_ccr_person_name.currentname.degree)
setnull(lstr_ccr_person_name.currentname.nickname)

if not pstr_element.valid then return lstr_ccr_person_name


ll_objectid_count = 0
ll_additionalname_count = 0

// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "birthname"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_person_name.birthname = get_ccr_personnametype(lstr_element)
		CASE "additionalname"
			ll_additionalname_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_person_name.additionalname[ll_additionalname_count] = get_ccr_personnametype(lstr_element)
		CASE "currentname"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_person_name.currentname = get_ccr_personnametype(lstr_element)
	END CHOOSE
next

return lstr_ccr_person_name

end function

public function str_ccr_person get_ccr_person (ref str_element pstr_element);string ls_description
str_ccr_person lstr_ccr_person
long i
str_element lstr_element
str_ccr_codeddescriptiontype lstr_ccr_codeddescriptiontype

setnull(lstr_ccr_person.dateofbirth)
setnull(lstr_ccr_person.gender)

if not pstr_element.valid then return lstr_ccr_person


// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "name"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_person.name = get_ccr_person_name(lstr_element)
		CASE "dateofbirth"
			// What CCR calls "type" we call communication_name
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_person.dateofbirth =  get_ccr_datetime(lstr_element)
		CASE "gender"
			// What CCR calls "type" we call communication_name
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_codeddescriptiontype = get_ccr_codeddescriptiontype(lstr_element)
			if len(lstr_ccr_codeddescriptiontype.text) > 0 then
				lstr_ccr_person.gender = lstr_ccr_codeddescriptiontype.text
			end if
	END CHOOSE
next

return lstr_ccr_person

end function

public function datetime get_ccr_datetime (ref str_element pstr_element);string ls_description
datetime ldt_datetime
datetime ldt_null
long i
str_element lstr_element
str_ccr_codeddescriptiontype lstr_ccr_codeddescriptiontype
string ls_datetime

setnull(ldt_null)

if not pstr_element.valid then return ldt_null


// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "type"
		CASE "exactdatetime"
			ls_datetime = pstr_element.child[i].gettexttrim()
			ldt_datetime = f_xml_datetime(ls_datetime)
			if not isnull(ldt_datetime) then return ldt_datetime
		CASE "age"
		CASE "approximatedatetime"
		CASE "datetimerange"
	END CHOOSE
next

return ldt_null

end function

public function str_problem_type get_ccr_problem_type (str_element pstr_element);str_problem_type lstr_problem_type
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

public function str_ccr_datetimetype get_ccr_datetimetype (ref str_element pstr_element);str_ccr_datetimetype lstr_ccr_datetimetype
string ls_description
datetime ldt_null
long i
str_element lstr_element
str_ccr_codeddescriptiontype lstr_ccr_codeddescriptiontype
string ls_datetime
long ll_datetimerange_count

setnull(ldt_null)

setnull(lstr_ccr_datetimetype.exactdatetime)

ll_datetimerange_count = 0

if not pstr_element.valid then return lstr_ccr_datetimetype


// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "type"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_datetimetype.datetimetype = get_ccr_codeddescriptiontype(lstr_element)
		CASE "exactdatetime"
			ls_datetime = pstr_element.child[i].gettexttrim()
			lstr_ccr_datetimetype.exactdatetime = f_xml_datetime(ls_datetime)
		CASE "age"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_datetimetype.age = get_ccr_measuretype(lstr_element)
		CASE "approximatedatetime"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_datetimetype.approximatedatetime = get_ccr_codeddescriptiontype(lstr_element)
		CASE "datetimerange"
			lstr_element = get_element(pstr_element.child[i])
			ll_datetimerange_count += 1
			lstr_ccr_datetimetype.datetimerange[ll_datetimerange_count] = get_ccr_datetime_range(lstr_element)
	END CHOOSE
next

return lstr_ccr_datetimetype

end function

public function str_ccr_units_type get_ccr_units_type (ref str_element pstr_element);str_ccr_units_type lstr_ccr_units_type
string ls_description
datetime ldt_null
long i
str_element lstr_element
str_ccr_codeddescriptiontype lstr_ccr_codeddescriptiontype
string ls_datetime
long ll_code_count

setnull(ldt_null)

setnull(lstr_ccr_units_type.unit)

ll_code_count = 0

if not pstr_element.valid then return lstr_ccr_units_type


// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "unit"
			lstr_ccr_units_type.unit = pstr_element.child[i].gettexttrim()
		CASE "code"
			lstr_element = get_element(pstr_element.child[i])
			ll_code_count += 1
			lstr_ccr_units_type.code[ll_code_count] = get_ccr_codetype(lstr_element)
	END CHOOSE
next

return lstr_ccr_units_type

end function

public function str_ccr_measuretype get_ccr_measuretype (ref str_element pstr_element);str_ccr_measuretype lstr_ccr_measuretype
string ls_description
datetime ldt_null
long i
str_element lstr_element
str_ccr_codeddescriptiontype lstr_ccr_codeddescriptiontype
string ls_datetime
long ll_code_count
string ls_name

setnull(ldt_null)

setnull(lstr_ccr_measuretype.value)

ll_code_count = 0

if not pstr_element.valid then return lstr_ccr_measuretype


// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	ls_name = lower(pstr_element.child[i].getname())
	CHOOSE CASE ls_name
		CASE "value"
			lstr_ccr_measuretype.value = pstr_element.child[i].gettexttrim()
		CASE "units"
			lstr_element = get_element(pstr_element.child[i])
			ll_code_count += 1
			lstr_ccr_measuretype.units = get_ccr_units_type(lstr_element)
		CASE "code"
			lstr_element = get_element(pstr_element.child[i])
			ll_code_count += 1
			lstr_ccr_measuretype.code[ll_code_count] = get_ccr_codetype(lstr_element)
		CASE ELSE
			if right(ls_name, 16) = "sequenceposition" then
				lstr_ccr_measuretype.sequenceposition = long(pstr_element.child[i].gettexttrim())
			end if
			if right(ls_name, 8) = "modifier" then
				lstr_element = get_element(pstr_element.child[i])
				lstr_ccr_measuretype.modifier = get_ccr_codeddescriptiontype(lstr_element)
			end if
	END CHOOSE
next

return lstr_ccr_measuretype

end function

public function str_ccr_datetime_rangepart get_ccr_datetime_rangepart (ref str_element pstr_element);str_ccr_datetime_rangepart lstr_ccr_datetime_rangepart
string ls_description
long i
str_element lstr_element
str_ccr_codeddescriptiontype lstr_ccr_codeddescriptiontype
string ls_datetime


setnull(lstr_ccr_datetime_rangepart.exactdatetime)


if not pstr_element.valid then return lstr_ccr_datetime_rangepart


// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "exactdatetime"
			ls_datetime = pstr_element.child[i].gettexttrim()
			lstr_ccr_datetime_rangepart.exactdatetime = f_xml_datetime(ls_datetime)
		CASE "age"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_datetime_rangepart.age = get_ccr_measuretype(lstr_element)
		CASE "approximatedatetime"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_datetime_rangepart.approximatedatetime = get_ccr_codeddescriptiontype(lstr_element)
	END CHOOSE
next

return lstr_ccr_datetime_rangepart

end function

public function str_ccr_datetime_range get_ccr_datetime_range (ref str_element pstr_element);str_ccr_datetime_range lstr_ccr_datetime_range
string ls_description
long i
str_element lstr_element
str_ccr_codeddescriptiontype lstr_ccr_codeddescriptiontype
string ls_datetime


if not pstr_element.valid then return lstr_ccr_datetime_range


// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "beginrange"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_datetime_range.beginrange = get_ccr_datetime_rangepart(lstr_element)
		CASE "endrange"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_datetime_range.endrange = get_ccr_datetime_rangepart(lstr_element)
	END CHOOSE
next

return lstr_ccr_datetime_range

end function

public function str_ccr_actorreferencetype get_ccr_actorreferencetype (ref str_element pstr_element);str_ccr_actorreferencetype lstr_ccr_actorreferencetype
string ls_description
datetime ldt_null
long i
str_element lstr_element
str_ccr_codeddescriptiontype lstr_ccr_codeddescriptiontype
string ls_datetime
long ll_actorrole_count
string ls_actorid

setnull(ldt_null)


ll_actorrole_count = 0

if not pstr_element.valid then return lstr_ccr_actorreferencetype


// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "actorid"
			lstr_ccr_actorreferencetype.actorid = pstr_element.child[i].gettexttrim()
		CASE "actorrole"
			lstr_element = get_element(pstr_element.child[i])
			ll_actorrole_count += 1
			lstr_ccr_actorreferencetype.actorrole[ll_actorrole_count] = get_ccr_codeddescriptiontype(lstr_element)
	END CHOOSE
next

return lstr_ccr_actorreferencetype

end function

public function str_ccr_idtype get_ccr_idtype (ref str_element pstr_element);str_ccr_idtype lstr_ccr_idtype
string ls_description
datetime ldt_null
long i
str_element lstr_element
str_ccr_codeddescriptiontype lstr_ccr_codeddescriptiontype
string ls_datetime
long ll_datetime_count

setnull(ldt_null)

setnull(lstr_ccr_idtype.id)

ll_datetime_count = 0

if not pstr_element.valid then return lstr_ccr_idtype


// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "datetime"
			lstr_element = get_element(pstr_element.child[i])
			ll_datetime_count += 1
			lstr_ccr_idtype.datetime[ll_datetime_count] = get_ccr_datetimetype(lstr_element)
		CASE "type"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_idtype.idtype = get_ccr_codeddescriptiontype(lstr_element)
		CASE "id"
			lstr_ccr_idtype.id = pstr_element.child[i].gettexttrim()
		CASE "issuedby"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_idtype.issuedby = get_ccr_actorreferencetype(lstr_element)
	END CHOOSE
next

// get the elements from the slrcgroup fields
lstr_ccr_idtype.slrcgroup = get_ccr_slrcgroup(pstr_element)


return lstr_ccr_idtype

end function

public function str_ccr_sourcetype get_ccr_sourcetype (ref str_element pstr_element);str_ccr_sourcetype lstr_ccr_sourcetype
string ls_description
datetime ldt_null
long i
str_element lstr_element
str_ccr_codeddescriptiontype lstr_ccr_codeddescriptiontype
string ls_datetime
long ll_actor_count
long ll_referenceid_count
long ll_commentid_count

setnull(ldt_null)


ll_actor_count = 0
ll_referenceid_count = 0
ll_commentid_count = 0

if not pstr_element.valid then return lstr_ccr_sourcetype


// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "description"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_sourcetype.description = get_ccr_codeddescriptiontype(lstr_element)
		CASE "actor"
			lstr_element = get_element(pstr_element.child[i])
			ll_actor_count += 1
			lstr_ccr_sourcetype.actor[ll_actor_count] = get_ccr_actorreferencetype(lstr_element)
		CASE "datetime"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_sourcetype.datetime = get_ccr_datetimetype(lstr_element)
		CASE "referenceid"
			ll_referenceid_count += 1
			lstr_ccr_sourcetype.referenceid[ll_referenceid_count] = pstr_element.child[i].gettexttrim()
		CASE "commentid"
			ll_commentid_count += 1
			lstr_ccr_sourcetype.commentid[ll_commentid_count] = pstr_element.child[i].gettexttrim()
	END CHOOSE
next

return lstr_ccr_sourcetype

end function

public function str_ccr_slrcgroup get_ccr_slrcgroup (ref str_element pstr_element);str_ccr_slrcgroup lstr_ccr_slrcgroup
string ls_description
datetime ldt_null
long i
str_element lstr_element
str_ccr_codeddescriptiontype lstr_ccr_codeddescriptiontype
string ls_datetime
long ll_source_count
long ll_link_count
long ll_referenceid_count
long ll_commentid_count
long ll_signature_count

setnull(ldt_null)


ll_source_count = 0
ll_link_count = 0
ll_referenceid_count = 0
ll_commentid_count = 0
ll_signature_count = 0

if not pstr_element.valid then return lstr_ccr_slrcgroup


// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "source"
			lstr_element = get_element(pstr_element.child[i])
			ll_source_count += 1
			lstr_ccr_slrcgroup.source[ll_source_count] = get_ccr_sourcetype(lstr_element)
		CASE "internalccrlink"
			lstr_element = get_element(pstr_element.child[i])
			ll_link_count += 1
			lstr_ccr_slrcgroup.internalccrlink[ll_link_count] = get_ccr_internalccrlink_type(lstr_element)
		CASE "referenceid"
			ll_referenceid_count += 1
			lstr_ccr_slrcgroup.referenceid[ll_referenceid_count] = pstr_element.child[i].gettexttrim()
		CASE "commentid"
			ll_commentid_count += 1
			lstr_ccr_slrcgroup.commentid[ll_commentid_count] = pstr_element.child[i].gettexttrim()
		CASE "signature"
			lstr_element = get_element(pstr_element.child[i])
			ll_signature_count += 1
			lstr_ccr_slrcgroup.signature[ll_signature_count] = get_ccr_signatureid_type(lstr_element)
	END CHOOSE
next

return lstr_ccr_slrcgroup

end function

public function str_ccr_internalccrlink_type get_ccr_internalccrlink_type (ref str_element pstr_element);str_ccr_internalccrlink_type lstr_ccr_internalccrlink_type
string ls_description
long i
str_element lstr_element
str_ccr_codeddescriptiontype lstr_ccr_codeddescriptiontype
string ls_datetime
long ll_link_count


setnull(lstr_ccr_internalccrlink_type.linkid)

ll_link_count = 0

if not pstr_element.valid then return lstr_ccr_internalccrlink_type


// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "linkid"
			lstr_ccr_internalccrlink_type.linkid = pstr_element.child[i].gettexttrim()
		CASE "linkrelationship"
			ll_link_count += 1
			lstr_ccr_internalccrlink_type.linkrelationship[ll_link_count] = pstr_element.child[i].gettexttrim()
		CASE "source"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_internalccrlink_type.source = get_ccr_sourcetype(lstr_element)
	END CHOOSE
next

return lstr_ccr_internalccrlink_type

end function

public function str_ccr_signatureid_type get_ccr_signatureid_type (ref str_element pstr_element);str_ccr_signatureid_type lstr_ccr_signatureid_type
string ls_description
long i
str_element lstr_element
str_ccr_codeddescriptiontype lstr_ccr_codeddescriptiontype
string ls_datetime

setnull(lstr_ccr_signatureid_type.signatureid)

if not pstr_element.valid then return lstr_ccr_signatureid_type


// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "signatureid"
			lstr_ccr_signatureid_type.signatureid = pstr_element.child[i].gettexttrim()
	END CHOOSE
next

return lstr_ccr_signatureid_type

end function

public function str_ccr_ccrcodeddataobjecttype get_ccr_ccrcodeddataobjecttype (ref str_element pstr_element);str_ccr_ccrcodeddataobjecttype lstr_ccr_ccrcodeddataobjecttype
string ls_description
datetime ldt_null
long i
str_element lstr_element
str_ccr_codeddescriptiontype lstr_ccr_codeddescriptiontype
string ls_datetime
long ll_datetime_count
long ll_id_count

setnull(lstr_ccr_ccrcodeddataobjecttype.ccrdataobjectid)

ll_datetime_count = 0
ll_id_count = 0

if not pstr_element.valid then return lstr_ccr_ccrcodeddataobjecttype


for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "ccrdataobjectid"
			lstr_ccr_ccrcodeddataobjecttype.ccrdataobjectid = pstr_element.child[i].gettexttrim()
		CASE "datetime"
			lstr_element = get_element(pstr_element.child[i])
			ll_datetime_count += 1
			lstr_ccr_ccrcodeddataobjecttype.datetime[ll_datetime_count] = get_ccr_datetimetype(lstr_element)
		CASE "ids"
			lstr_element = get_element(pstr_element.child[i])
			ll_id_count += 1
			lstr_ccr_ccrcodeddataobjecttype.ids[ll_id_count] = get_ccr_idtype(lstr_element)
		CASE "type"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_ccrcodeddataobjecttype.objecttype = get_ccr_codeddescriptiontype(lstr_element)
		CASE "description"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_ccrcodeddataobjecttype.description = get_ccr_codeddescriptiontype(lstr_element)
		CASE "status"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_ccrcodeddataobjecttype.status = get_ccr_codeddescriptiontype(lstr_element)
	END CHOOSE
next

// get the elements from the slrcgroup fields
lstr_ccr_ccrcodeddataobjecttype.slrcgroup = get_ccr_slrcgroup(pstr_element)

return lstr_ccr_ccrcodeddataobjecttype

end function

public function str_ccr_problemtype get_ccr_problemtype (ref str_element pstr_element);str_ccr_problemtype lstr_ccr_problemtype
string ls_description
datetime ldt_null
long i
str_element lstr_element
str_ccr_codeddescriptiontype lstr_ccr_codeddescriptiontype
string ls_datetime
long ll_datetime_count
long ll_id_count

setnull(lstr_ccr_problemtype.ccrdataobjectid)

ll_datetime_count = 0
ll_id_count = 0

if not pstr_element.valid then return lstr_ccr_problemtype


for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "ccrdataobjectid"
			lstr_ccr_problemtype.ccrdataobjectid = pstr_element.child[i].gettexttrim()
		CASE "datetime"
			lstr_element = get_element(pstr_element.child[i])
			ll_datetime_count += 1
			lstr_ccr_problemtype.datetime[ll_datetime_count] = get_ccr_datetimetype(lstr_element)
		CASE "ids"
			lstr_element = get_element(pstr_element.child[i])
			ll_id_count += 1
			lstr_ccr_problemtype.ids[ll_id_count] = get_ccr_idtype(lstr_element)
		CASE "type"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_problemtype.objecttype = get_ccr_codeddescriptiontype(lstr_element)
		CASE "description"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_problemtype.description = get_ccr_codeddescriptiontype(lstr_element)
		CASE "status"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_problemtype.status = get_ccr_codeddescriptiontype(lstr_element)
	END CHOOSE
next

// get the elements from the slrcgroup fields
lstr_ccr_problemtype.slrcgroup = get_ccr_slrcgroup(pstr_element)

return lstr_ccr_problemtype

end function

public function str_ccr_body get_ccr_body (ref str_element pstr_element);str_ccr_body lstr_ccr_body
string ls_description
long i
str_element lstr_element
str_element lstr_element2
str_ccr_codeddescriptiontype lstr_ccr_codeddescriptiontype
long ll_problem_count
long ll_alert_count
long ll_medication_count
long ll_immunization_count
long ll_vitalsign_count
long ll_result_count
long j

ll_problem_count = 0
ll_alert_count = 0
ll_medication_count = 0
ll_immunization_count = 0
ll_vitalsign_count = 0
ll_result_count = 0

if not pstr_element.valid then return lstr_ccr_body


for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "problems"
			lstr_element = get_element(pstr_element.child[i])
			for j = 1 to lstr_element.child_count
				if lower(lstr_element.child[j].getname()) = "problem" then
					lstr_element2 = get_element(lstr_element.child[j])
					ll_problem_count += 1
					lstr_ccr_body.problems[ll_problem_count] = get_ccr_problemtype(lstr_element2)
				end if
			next
		CASE "alerts"
			lstr_element = get_element(pstr_element.child[i])
			for j = 1 to lstr_element.child_count
				if lower(lstr_element.child[j].getname()) = "alert" then
					lstr_element2 = get_element(lstr_element.child[j])
					ll_alert_count += 1
					lstr_ccr_body.alerts[ll_alert_count] = get_ccr_alert_type(lstr_element2)
				end if
			next
		CASE "medications"
			lstr_element = get_element(pstr_element.child[i])
			for j = 1 to lstr_element.child_count
				if lower(lstr_element.child[j].getname()) = "medication" then
					lstr_element2 = get_element(lstr_element.child[j])
					ll_medication_count += 1
					lstr_ccr_body.medications[ll_medication_count] = get_ccr_structuredproducttype(lstr_element2)
				end if
			next
		CASE "immunizations"
			lstr_element = get_element(pstr_element.child[i])
			for j = 1 to lstr_element.child_count
				if lower(lstr_element.child[j].getname()) = "immunization" then
					lstr_element2 = get_element(lstr_element.child[j])
					ll_immunization_count += 1
					lstr_ccr_body.immunizations[ll_immunization_count] = get_ccr_structuredproducttype(lstr_element2)
				end if
			next
		CASE "vitalsigns"
			lstr_element = get_element(pstr_element.child[i])
			for j = 1 to lstr_element.child_count
				if lower(lstr_element.child[j].getname()) = "result" then
					lstr_element2 = get_element(lstr_element.child[j])
					ll_vitalsign_count += 1
					lstr_ccr_body.vitalsigns[ll_vitalsign_count] = get_ccr_resulttype(lstr_element2)
				end if
			next
		CASE "results"
			lstr_element = get_element(pstr_element.child[i])
			for j = 1 to lstr_element.child_count
				if lower(lstr_element.child[j].getname()) = "result" then
					lstr_element2 = get_element(lstr_element.child[j])
					ll_result_count += 1
					lstr_ccr_body.results[ll_result_count] = get_ccr_resulttype(lstr_element2)
				end if
			next
	END CHOOSE
next


return lstr_ccr_body

end function

public function str_ccr_purposetype get_ccr_purposetype (ref str_element pstr_element);str_ccr_purposetype lstr_ccr_purposetype
string ls_description
long i
str_element lstr_element
str_ccr_codeddescriptiontype lstr_ccr_codeddescriptiontype
long ll_datetime_count
long ll_description_count
long ll_orderrequest_count
long ll_indications_count
long ll_referenceid_count
long ll_commentid_count

ll_datetime_count = 0
ll_description_count = 0
ll_orderrequest_count = 0
ll_indications_count = 0
ll_referenceid_count = 0
ll_commentid_count = 0

if not pstr_element.valid then return lstr_ccr_purposetype


for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "datetime"
			lstr_element = get_element(pstr_element.child[i])
			ll_datetime_count += 1
			lstr_ccr_purposetype.datetime[ll_datetime_count] = get_ccr_datetimetype(lstr_element)
		CASE "description"
			lstr_element = get_element(pstr_element.child[i])
			ll_description_count += 1
			lstr_ccr_purposetype.description[ll_description_count] = get_ccr_codeddescriptiontype(lstr_element)
		CASE "orderrequest"
			lstr_element = get_element(pstr_element.child[i])
			ll_orderrequest_count += 1
//			lstr_ccr_purposetype.orderrequest[ll_orderrequest_count] = get_ccr_planofcaretype(lstr_element)
		CASE "indications"
			lstr_element = get_element(pstr_element.child[i])
			ll_indications_count += 1
//			lstr_ccr_purposetype.indications[ll_indications_count] = get_ccr_indicationtype(lstr_element)
		CASE "referenceid"
			ll_referenceid_count += 1
			lstr_ccr_purposetype.referenceid[ll_referenceid_count] = pstr_element.child[i].gettexttrim()
		CASE "commentid"
			ll_commentid_count += 1
			lstr_ccr_purposetype.commentid[ll_commentid_count] = pstr_element.child[i].gettexttrim()
	END CHOOSE
next


return lstr_ccr_purposetype

end function

public function str_ccr_continuityofcarerecord get_ccr_continuityofcarerecord (ref str_element pstr_element);str_ccr_continuityofcarerecord lstr_ccr_continuityofcarerecord
string ls_description
long i
str_element lstr_element
str_element lstr_element2
str_ccr_codeddescriptiontype lstr_ccr_codeddescriptiontype
string ls_actorid
long j
long ll_ccrfrom_count
long ll_ccrto_count
long ll_purpose_count

ll_ccrfrom_count = 0
ll_ccrto_count = 0
ll_purpose_count = 0

actor_count = 0

if not pstr_element.valid then return lstr_ccr_continuityofcarerecord

// We need to process the actors first so the links wii be valid
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "actors"
			lstr_element = get_element(pstr_element.child[i])
			for j = 1 to lstr_element.child_count
				if lower(lstr_element.child[j].getname()) = "actor" then
					lstr_element2 = get_element(lstr_element.child[j])
					actor_count += 1
					actor[actor_count] = get_actor_type(lstr_element2)
					actor_id[actor_count] = actor[actor_count].actorobjectid
				end if
			next
	END CHOOSE
next

for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "ccrdocumentobjectid"
			lstr_ccr_continuityofcarerecord.CCRDocumentObjectID = pstr_element.child[i].gettexttrim()
		CASE "language"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_continuityofcarerecord.language = get_ccr_codeddescriptiontype(lstr_element)
		CASE "version"
			lstr_ccr_continuityofcarerecord.version = pstr_element.child[i].gettexttrim()
		CASE "datetime"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_continuityofcarerecord.datetime = get_ccr_datetimetype(lstr_element)
		CASE "patient"
			lstr_element = get_element(pstr_element.child[i])
			for j = 1 to lstr_element.child_count
				if lower(lstr_element.child[j].getname()) = "actorid" then
					ls_actorid = lstr_element.child[j].gettexttrim()
					get_actor(ls_actorid, lstr_ccr_continuityofcarerecord.patient)
				end if
			next
		CASE "ccrfrom"
			lstr_element = get_element(pstr_element.child[i])
			for j = 1 to lstr_element.child_count
				if lower(lstr_element.child[j].getname()) = "actorlink" then
					lstr_element2 = get_element(lstr_element.child[j])
					ll_ccrfrom_count += 1
					lstr_ccr_continuityofcarerecord.ccrfrom[ll_ccrfrom_count] = get_ccr_actorreferencetype(lstr_element2)
				end if
			next
		CASE "ccrto"
			lstr_element = get_element(pstr_element.child[i])
			for j = 1 to lstr_element.child_count
				if lower(lstr_element.child[j].getname()) = "actorlink" then
					lstr_element2 = get_element(lstr_element.child[j])
					ll_ccrto_count += 1
					lstr_ccr_continuityofcarerecord.ccrto[ll_ccrto_count] = get_ccr_actorreferencetype(lstr_element2)
				end if
			next
		CASE "purpose"
			lstr_element = get_element(pstr_element.child[i])
			ll_purpose_count += 1
			lstr_ccr_continuityofcarerecord.purpose[ll_purpose_count] = get_ccr_purposetype(lstr_element)
		CASE "body"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_continuityofcarerecord.body = get_ccr_body(lstr_element)
	END CHOOSE
next


return lstr_ccr_continuityofcarerecord

end function

public function str_ccr_alert_type get_ccr_alert_type (ref str_element pstr_element);str_ccr_alert_type lstr_ccr_alert_type
string ls_description
datetime ldt_null
long i
str_element lstr_element
str_ccr_codeddescriptiontype lstr_ccr_codeddescriptiontype
string ls_datetime
long ll_datetime_count
long ll_id_count
long ll_agent_count
long ll_reaction_count

setnull(lstr_ccr_alert_type.ccrdataobjectid)

ll_datetime_count = 0
ll_id_count = 0
ll_agent_count = 0
ll_reaction_count = 0

if not pstr_element.valid then return lstr_ccr_alert_type


for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "ccrdataobjectid"
			lstr_ccr_alert_type.ccrdataobjectid = pstr_element.child[i].gettexttrim()
		CASE "datetime"
			lstr_element = get_element(pstr_element.child[i])
			ll_datetime_count += 1
			lstr_ccr_alert_type.datetime[ll_datetime_count] = get_ccr_datetimetype(lstr_element)
		CASE "ids"
			lstr_element = get_element(pstr_element.child[i])
			ll_id_count += 1
			lstr_ccr_alert_type.ids[ll_id_count] = get_ccr_idtype(lstr_element)
		CASE "type"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_alert_type.alerttype = get_ccr_codeddescriptiontype(lstr_element)
		CASE "description"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_alert_type.description = get_ccr_codeddescriptiontype(lstr_element)
		CASE "status"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_alert_type.status = get_ccr_codeddescriptiontype(lstr_element)
		CASE "agent"
			lstr_element = get_element(pstr_element.child[i])
			ll_agent_count += 1
			lstr_ccr_alert_type.agent[ll_agent_count] = get_ccr_agent(lstr_element)
		CASE "reaction"
			lstr_element = get_element(pstr_element.child[i])
			ll_reaction_count += 1
			lstr_ccr_alert_type.reaction[ll_reaction_count] = get_ccr_reaction(lstr_element)
	END CHOOSE
next

// get the elements from the slrcgroup fields
lstr_ccr_alert_type.slrcgroup = get_ccr_slrcgroup(pstr_element)

return lstr_ccr_alert_type

end function

public function str_ccr_agent get_ccr_agent (ref str_element pstr_element);str_ccr_agent lstr_ccr_agent
string ls_description
datetime ldt_null
long i
long j
str_element lstr_element
str_element lstr_element2
str_ccr_codeddescriptiontype lstr_ccr_codeddescriptiontype
string ls_datetime
long ll_product_count
long ll_environmentalagent_count
long ll_problem_count
long ll_procedure_count
long ll_result_count


ll_product_count = 0
ll_environmentalagent_count = 0
ll_problem_count = 0
ll_procedure_count = 0
ll_result_count = 0

if not pstr_element.valid then return lstr_ccr_agent


for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "products"
			lstr_element = get_element(pstr_element.child[i])
			for j = 1 to lstr_element.child_count
				if lower(lstr_element.child[j].getname()) = "product" then
					lstr_element2 = get_element(lstr_element.child[j])
					ll_problem_count += 1
					lstr_ccr_agent.products[ll_problem_count] = get_ccr_structuredproducttype(lstr_element2)
				end if
			next
		CASE "environmentalagents"
			lstr_element = get_element(pstr_element.child[i])
			for j = 1 to lstr_element.child_count
				if lower(lstr_element.child[j].getname()) = "environmentalagent" then
					lstr_element2 = get_element(lstr_element.child[j])
					ll_problem_count += 1
					lstr_ccr_agent.environmentalagents[ll_problem_count] = get_ccr_ccrcodeddataobjecttype(lstr_element2)
				end if
			next
		CASE "problems"
			lstr_element = get_element(pstr_element.child[i])
			for j = 1 to lstr_element.child_count
				if lower(lstr_element.child[j].getname()) = "problem" then
					lstr_element2 = get_element(lstr_element.child[j])
					ll_problem_count += 1
					lstr_ccr_agent.problems[ll_problem_count] = get_ccr_problemtype(lstr_element2)
				end if
			next
		CASE "procedures"
			lstr_element = get_element(pstr_element.child[i])
			for j = 1 to lstr_element.child_count
				if lower(lstr_element.child[j].getname()) = "procedure" then
					lstr_element2 = get_element(lstr_element.child[j])
					ll_problem_count += 1
//					lstr_ccr_agent.procedures[ll_problem_count] = get_ccr_proceduretype(lstr_element2)
				end if
			next
		CASE "results"
			lstr_element = get_element(pstr_element.child[i])
			for j = 1 to lstr_element.child_count
				if lower(lstr_element.child[j].getname()) = "result" then
					lstr_element2 = get_element(lstr_element.child[j])
					ll_problem_count += 1
					lstr_ccr_agent.results[ll_problem_count] = get_ccr_resulttype(lstr_element2)
				end if
			next
	END CHOOSE
next


return lstr_ccr_agent

end function

public function str_ccr_structuredproducttype get_ccr_structuredproducttype (ref str_element pstr_element);str_ccr_structuredproducttype lstr_ccr_structuredproducttype
string ls_description
datetime ldt_null
long i
long j
str_element lstr_element
str_element lstr_element2
str_ccr_codeddescriptiontype lstr_ccr_codeddescriptiontype
string ls_datetime
long ll_datetime_count
long ll_id_count
long ll_product_count
long ll_quantity_count
long ll_direction_count
long ll_patientinstruction_count
long ll_fulfillmentinstruction_count
long ll_refill_count

setnull(lstr_ccr_structuredproducttype.ccrdataobjectid)

ll_datetime_count = 0
ll_id_count = 0
ll_product_count = 0
ll_quantity_count = 0
ll_direction_count = 0
ll_patientinstruction_count = 0
ll_fulfillmentinstruction_count = 0
ll_refill_count = 0

if not pstr_element.valid then return lstr_ccr_structuredproducttype


for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "ccrdataobjectid"
			lstr_ccr_structuredproducttype.ccrdataobjectid = pstr_element.child[i].gettexttrim()
		CASE "datetime"
			lstr_element = get_element(pstr_element.child[i])
			ll_datetime_count += 1
			lstr_ccr_structuredproducttype.datetime[ll_datetime_count] = get_ccr_datetimetype(lstr_element)
		CASE "ids"
			lstr_element = get_element(pstr_element.child[i])
			ll_id_count += 1
			lstr_ccr_structuredproducttype.ids[ll_id_count] = get_ccr_idtype(lstr_element)
		CASE "type"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_structuredproducttype.objecttype = get_ccr_codeddescriptiontype(lstr_element)
		CASE "description"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_structuredproducttype.description = get_ccr_codeddescriptiontype(lstr_element)
		CASE "status"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_structuredproducttype.status = get_ccr_codeddescriptiontype(lstr_element)
		CASE "product"
			lstr_element = get_element(pstr_element.child[i])
			ll_product_count += 1
			lstr_ccr_structuredproducttype.product[ll_product_count] = get_ccr_product_type(lstr_element)
		CASE "quantity"
			lstr_element = get_element(pstr_element.child[i])
			ll_quantity_count += 1
			lstr_ccr_structuredproducttype.quantity[ll_quantity_count] = get_ccr_measuretype(lstr_element)
		CASE "directions"
			lstr_element = get_element(pstr_element.child[i])
			for j = 1 to lstr_element.child_count
				if lower(lstr_element.child[j].getname()) = "direction" then
					lstr_element2 = get_element(lstr_element.child[j])
					ll_direction_count += 1
					lstr_ccr_structuredproducttype.directions[ll_direction_count] = get_ccr_direction(lstr_element2)
				end if
			next
		CASE "patientinstructions"
			lstr_element = get_element(pstr_element.child[i])
			for j = 1 to lstr_element.child_count
				if lower(lstr_element.child[j].getname()) = "instruction" then
					lstr_element2 = get_element(lstr_element.child[j])
					ll_patientinstruction_count += 1
					lstr_ccr_structuredproducttype.patientinstructions[ll_patientinstruction_count] = get_ccr_codeddescriptiontype_2(lstr_element2)
				end if
			next
		CASE "fullfillmentinstructions"
			lstr_element = get_element(pstr_element.child[i])
			for j = 1 to lstr_element.child_count
				if lower(lstr_element.child[j].getname()) = "instruction" then
					lstr_element2 = get_element(lstr_element.child[j])
					ll_fulfillmentinstruction_count += 1
					lstr_ccr_structuredproducttype.fulfillmentinstructions[ll_fulfillmentinstruction_count] = get_ccr_codeddescriptiontype_2(lstr_element2)
				end if
			next
		CASE "refills"
			lstr_element = get_element(pstr_element.child[i])
			for j = 1 to lstr_element.child_count
				if lower(lstr_element.child[j].getname()) = "refill" then
					lstr_element2 = get_element(lstr_element.child[j])
					ll_refill_count += 1
					lstr_ccr_structuredproducttype.refills[ll_refill_count] = get_ccr_refill(lstr_element2)
				end if
			next
		CASE "seriesnumber"
			lstr_ccr_structuredproducttype.seriesnumber = pstr_element.child[i].gettexttrim()
		CASE "consent"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_structuredproducttype.consent = get_ccr_ccrcodeddataobjecttype(lstr_element)
		CASE "reaction"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_structuredproducttype.reaction = get_ccr_reaction(lstr_element)
		CASE "fulfillmenthistory"
	END CHOOSE
next

// get the elements from the slrcgroup fields
lstr_ccr_structuredproducttype.slrcgroup = get_ccr_slrcgroup(pstr_element)

return lstr_ccr_structuredproducttype

end function

public function str_ccr_codeddescriptiontype_2 get_ccr_codeddescriptiontype_2 (ref str_element pstr_element);str_ccr_codeddescriptiontype_2 lstr_ccr_codeddescriptiontype_2
string ls_description
long i
long ll_objectattribute_count
long ll_code_count
str_element lstr_element
string ls_name

setnull(lstr_ccr_codeddescriptiontype_2.text)

ll_objectattribute_count = 0
ll_code_count = 0

if not pstr_element.valid then return lstr_ccr_codeddescriptiontype_2

// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	ls_name = lower(pstr_element.child[i].getname())
	CHOOSE CASE ls_name
		CASE "text"
			lstr_ccr_codeddescriptiontype_2.text = pstr_element.child[i].gettexttrim()
		CASE "objectattribute"
			lstr_element = get_element(pstr_element.child[i])
			ll_objectattribute_count += 1
			lstr_ccr_codeddescriptiontype_2.objectattribute[ll_objectattribute_count] = get_ccr_objectattribute(lstr_element)
		CASE "code"
			lstr_element = get_element(pstr_element.child[i])
			ll_code_count += 1
			lstr_ccr_codeddescriptiontype_2.code[ll_code_count] = get_ccr_codetype(lstr_element)
		CASE ELSE
			if right(ls_name, 16) = "sequenceposition" then
				lstr_ccr_codeddescriptiontype_2.sequenceposition = long(pstr_element.child[i].gettexttrim())
			end if
			if right(ls_name, 8) = "modifier" then
				lstr_element = get_element(pstr_element.child[i])
				lstr_ccr_codeddescriptiontype_2.modifier = get_ccr_codeddescriptiontype(lstr_element)
			end if
//		CASE "dimensions"
//		CASE "sizesequenceposition"
//			lstr_ccr_codeddescriptiontype_2.sequenceposition = long(pstr_element.child[i].gettexttrim())
//		CASE "variablesizemodifier"
//			lstr_element = get_element(pstr_element.child[i])
//			lstr_ccr_codeddescriptiontype_2.modifier = get_ccr_codeddescriptiontype(lstr_element)
	END CHOOSE
next


return lstr_ccr_codeddescriptiontype_2

end function

public function str_ccr_product_type get_ccr_product_type (ref str_element pstr_element);str_ccr_product_type lstr_ccr_product_type
string ls_description
datetime ldt_null
long i
long j
str_element lstr_element
str_element lstr_element2
str_ccr_codeddescriptiontype lstr_ccr_codeddescriptiontype
string ls_datetime
long ll_strength_count
long ll_form_count
long ll_concentration_count
long ll_size_count
long ll_id_count


setnull(lstr_ccr_product_type.sequenceposition)

ll_strength_count = 0
ll_form_count = 0
ll_concentration_count = 0
ll_size_count = 0
ll_id_count = 0

if not pstr_element.valid then return lstr_ccr_product_type


for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "productname"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_product_type.productname = get_ccr_codeddescriptiontype(lstr_element)
		CASE "brandname"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_product_type.brandname = get_ccr_codeddescriptiontype(lstr_element)
		CASE "strength"
			lstr_element = get_element(pstr_element.child[i])
			ll_strength_count += 1
			lstr_ccr_product_type.strength[ll_strength_count] = get_ccr_measuretype(lstr_element)
		CASE "form"
			lstr_element = get_element(pstr_element.child[i])
			ll_form_count += 1
			lstr_ccr_product_type.form[ll_form_count] = get_ccr_measuretype(lstr_element)
		CASE "concentration"
			lstr_element = get_element(pstr_element.child[i])
			ll_concentration_count += 1
			lstr_ccr_product_type.concentration[ll_concentration_count] = get_ccr_measuretype(lstr_element)
		CASE "size"
			lstr_element = get_element(pstr_element.child[i])
			ll_size_count += 1
			lstr_ccr_product_type.size[ll_size_count] = get_ccr_size_type(lstr_element)
		CASE "manufacturer"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_product_type.manufacturer = get_ccr_actorreferencetype(lstr_element)
		CASE "ids"
			lstr_element = get_element(pstr_element.child[i])
			ll_id_count += 1
			lstr_ccr_product_type.ids[ll_id_count] = get_ccr_idtype(lstr_element)
		CASE "productsequenceposition"
			lstr_ccr_product_type.sequenceposition = long(pstr_element.child[i].gettexttrim())
		CASE "multipleproductmodifier"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_product_type.modifier = get_ccr_codeddescriptiontype(lstr_element)
	END CHOOSE
next


return lstr_ccr_product_type

end function

public function str_ccr_size_type get_ccr_size_type (ref str_element pstr_element);str_ccr_size_type lstr_ccr_size_type
string ls_description
long i
long j
long ll_objectattribute_count
long ll_code_count
long ll_dimension_count
str_element lstr_element
str_element lstr_element2
string ls_name

setnull(lstr_ccr_size_type.text)

ll_objectattribute_count = 0
ll_code_count = 0
ll_dimension_count = 0

if not pstr_element.valid then return lstr_ccr_size_type

// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	ls_name = lower(pstr_element.child[i].getname())
	CHOOSE CASE ls_name
		CASE "text"
			lstr_ccr_size_type.text = pstr_element.child[i].gettexttrim()
		CASE "objectattribute"
			lstr_element = get_element(pstr_element.child[i])
			ll_objectattribute_count += 1
			lstr_ccr_size_type.objectattribute[ll_objectattribute_count] = get_ccr_objectattribute(lstr_element)
		CASE "code"
			lstr_element = get_element(pstr_element.child[i])
			ll_code_count += 1
			lstr_ccr_size_type.code[ll_code_count] = get_ccr_codetype(lstr_element)
		CASE "dimensions"
			lstr_element = get_element(pstr_element.child[i])
			for j = 1 to lstr_element.child_count
				if lower(lstr_element.child[j].getname()) = "dimension" then
					lstr_element2 = get_element(lstr_element.child[j])
					ll_dimension_count += 1
					lstr_ccr_size_type.dimension[ll_dimension_count] = get_ccr_dimension_type(lstr_element2)
				end if
			next
		CASE "sizesequenceposition"
			lstr_ccr_size_type.sequenceposition = long(pstr_element.child[i].gettexttrim())
		CASE "variablesizemodifier"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_size_type.modifier = get_ccr_codeddescriptiontype(lstr_element)
	END CHOOSE
next


return lstr_ccr_size_type

end function

public function str_ccr_dimension_type get_ccr_dimension_type (ref str_element pstr_element);str_ccr_dimension_type lstr_ccr_dimension_type
string ls_description
datetime ldt_null
long i
str_element lstr_element
str_ccr_codeddescriptiontype lstr_ccr_codeddescriptiontype
string ls_datetime
long ll_code_count
string ls_name

setnull(ldt_null)

setnull(lstr_ccr_dimension_type.value)

ll_code_count = 0

if not pstr_element.valid then return lstr_ccr_dimension_type


// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	ls_name = lower(pstr_element.child[i].getname())
	CHOOSE CASE ls_name
		CASE "value"
			lstr_ccr_dimension_type.value = pstr_element.child[i].gettexttrim()
		CASE "units"
			lstr_element = get_element(pstr_element.child[i])
			ll_code_count += 1
			lstr_ccr_dimension_type.units = get_ccr_units_type(lstr_element)
		CASE "code"
			lstr_element = get_element(pstr_element.child[i])
			ll_code_count += 1
			lstr_ccr_dimension_type.code[ll_code_count] = get_ccr_codetype(lstr_element)
		CASE "description"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_dimension_type.description = get_ccr_codeddescriptiontype(lstr_element)
	END CHOOSE
next

return lstr_ccr_dimension_type

end function

public function str_ccr_direction get_ccr_direction (ref str_element pstr_element);str_ccr_direction lstr_ccr_direction
string ls_description
datetime ldt_null
long i
long j
str_element lstr_element
str_element lstr_element2
str_ccr_codeddescriptiontype lstr_ccr_codeddescriptiontype
string ls_datetime
long ll_dose_count
long ll_id_count
long ll_dosecalculation_count
long ll_vehicle_count
long ll_route_count
long ll_site_count
long ll_administrationtiming_count
long ll_frequency_count
long ll_interval_count
long ll_duration_count
long ll_doserestriction_count
long ll_indication_count

setnull(lstr_ccr_direction.sequenceposition)

ll_dose_count = 0
ll_id_count = 0
ll_dosecalculation_count = 0
ll_vehicle_count = 0
ll_route_count = 0
ll_site_count = 0
ll_administrationtiming_count = 0
ll_frequency_count = 0
ll_interval_count = 0
ll_duration_count = 0
ll_doserestriction_count = 0
ll_indication_count = 0

if not pstr_element.valid then return lstr_ccr_direction


for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "description"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_direction.description = get_ccr_codeddescriptiontype(lstr_element)
		CASE "doseindicator"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_direction.doseindicator = get_ccr_codeddescriptiontype(lstr_element)
		CASE "deliverymethod"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_direction.deliverymethod = get_ccr_codeddescriptiontype(lstr_element)
		CASE "dose"
			lstr_element = get_element(pstr_element.child[i])
			ll_dose_count += 1
			lstr_ccr_direction.dose[ll_dose_count] = get_ccr_dose_type(lstr_element)
		CASE "dosecalculation"
			lstr_element = get_element(pstr_element.child[i])
			ll_dosecalculation_count += 1
//			lstr_ccr_direction.dosecalculation[ll_dosecalculation_count] = get_ccr_dosecalculationtype(lstr_element)
		CASE "vehicle"
			lstr_element = get_element(pstr_element.child[i])
			ll_vehicle_count += 1
//			lstr_ccr_direction.vehicle[ll_vehicle_count] = get_ccr_vehicletype(lstr_element)
		CASE "route"
			lstr_element = get_element(pstr_element.child[i])
			ll_route_count += 1
			lstr_ccr_direction.route[ll_route_count] = get_ccr_codeddescriptiontype_2(lstr_element)
		CASE "site"
			lstr_element = get_element(pstr_element.child[i])
			ll_site_count += 1
			lstr_ccr_direction.site[ll_site_count] = get_ccr_codeddescriptiontype_2(lstr_element)
		CASE "administrationtiming"
			lstr_element = get_element(pstr_element.child[i])
			ll_administrationtiming_count += 1
			lstr_ccr_direction.administrationtiming[ll_administrationtiming_count] = get_ccr_datetimetype_2(lstr_element)
		CASE "frequency"
			lstr_element = get_element(pstr_element.child[i])
			ll_frequency_count += 1
//			lstr_ccr_direction.frequency[ll_frequency_count] = get_ccr_intervaltype(lstr_element)
		CASE "interval"
			lstr_element = get_element(pstr_element.child[i])
			ll_interval_count += 1
//			lstr_ccr_direction.interval[ll_interval_count] = get_ccr_intervaltype(lstr_element)
		CASE "duration"
			lstr_element = get_element(pstr_element.child[i])
			ll_duration_count += 1
//			lstr_ccr_direction.duration[ll_duration_count] = get_ccr_intervaltype(lstr_element)
		CASE "doserestriction"
			lstr_element = get_element(pstr_element.child[i])
			ll_doserestriction_count += 1
//			lstr_ccr_direction.doserestriction[ll_doserestriction_count] = get_ccr_dosecalculationtype(lstr_element)
		CASE "indication"
			lstr_element = get_element(pstr_element.child[i])
			ll_indication_count += 1
//			lstr_ccr_direction.indication[ll_indication_count] = get_ccr_indicationtype(lstr_element)
		CASE "stopindicator"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_direction.stopindicator = get_ccr_codeddescriptiontype(lstr_element)
		CASE "directionsequenceposition"
			lstr_ccr_direction.sequenceposition = long(pstr_element.child[i].gettexttrim())
		CASE "multipledirectionmodifier"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_direction.modifier = get_ccr_codeddescriptiontype(lstr_element)
	END CHOOSE
next


return lstr_ccr_direction

end function

public function str_ccr_dose_type get_ccr_dose_type (ref str_element pstr_element);str_ccr_dose_type lstr_ccr_dose_type
string ls_description
datetime ldt_null
long i
str_element lstr_element
str_ccr_codeddescriptiontype lstr_ccr_codeddescriptiontype
string ls_datetime
long ll_code_count
string ls_name

setnull(ldt_null)

setnull(lstr_ccr_dose_type.value)

ll_code_count = 0

if not pstr_element.valid then return lstr_ccr_dose_type


// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	ls_name = lower(pstr_element.child[i].getname())
	CHOOSE CASE ls_name
		CASE "value"
			lstr_ccr_dose_type.value = pstr_element.child[i].gettexttrim()
		CASE "units"
			lstr_element = get_element(pstr_element.child[i])
			ll_code_count += 1
			lstr_ccr_dose_type.units = get_ccr_units_type(lstr_element)
		CASE "code"
			lstr_element = get_element(pstr_element.child[i])
			ll_code_count += 1
			lstr_ccr_dose_type.code[ll_code_count] = get_ccr_codetype(lstr_element)
		CASE "rate"
		CASE ELSE
			if right(ls_name, 16) = "sequenceposition" then
				lstr_ccr_dose_type.sequenceposition = long(pstr_element.child[i].gettexttrim())
			end if
			if right(ls_name, 8) = "modifier" then
				lstr_element = get_element(pstr_element.child[i])
				lstr_ccr_dose_type.modifier = get_ccr_codeddescriptiontype(lstr_element)
			end if
	END CHOOSE
next

return lstr_ccr_dose_type

end function

public function str_ccr_datetimetype_2 get_ccr_datetimetype_2 (ref str_element pstr_element);str_ccr_datetimetype_2 lstr_ccr_datetimetype_2
string ls_description
datetime ldt_null
long i
str_element lstr_element
str_ccr_codeddescriptiontype lstr_ccr_codeddescriptiontype
string ls_datetime
long ll_datetimerange_count
string ls_name

setnull(ldt_null)

setnull(lstr_ccr_datetimetype_2.exactdatetime)

ll_datetimerange_count = 0

if not pstr_element.valid then return lstr_ccr_datetimetype_2


// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	ls_name = lower(pstr_element.child[i].getname())
	CHOOSE CASE ls_name
		CASE "type"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_datetimetype_2.datetimetype = get_ccr_codeddescriptiontype(lstr_element)
		CASE "exactdatetime"
			ls_datetime = pstr_element.child[i].gettexttrim()
			lstr_ccr_datetimetype_2.exactdatetime = f_xml_datetime(ls_datetime)
		CASE "age"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_datetimetype_2.age = get_ccr_measuretype(lstr_element)
		CASE "approximatedatetime"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_datetimetype_2.approximatedatetime = get_ccr_codeddescriptiontype(lstr_element)
		CASE "datetimerange"
			lstr_element = get_element(pstr_element.child[i])
			ll_datetimerange_count += 1
			lstr_ccr_datetimetype_2.datetimerange[ll_datetimerange_count] = get_ccr_datetime_range(lstr_element)
		CASE ELSE
			if right(ls_name, 16) = "sequenceposition" then
				lstr_ccr_datetimetype_2.sequenceposition = long(pstr_element.child[i].gettexttrim())
			end if
			if right(ls_name, 8) = "modifier" then
				lstr_element = get_element(pstr_element.child[i])
				lstr_ccr_datetimetype_2.modifier = get_ccr_codeddescriptiontype(lstr_element)
			end if
	END CHOOSE
next

return lstr_ccr_datetimetype_2

end function

public function str_ccr_refill get_ccr_refill (ref str_element pstr_element);str_ccr_refill lstr_ccr_refill
string ls_description
datetime ldt_null
long i
long j
str_element lstr_element
str_element lstr_element2
str_ccr_codeddescriptiontype lstr_ccr_codeddescriptiontype
string ls_datetime
string ls_temp

long ll_number_count
long ll_quantity_count
long ll_datetime_count
long ll_comment_count


ll_number_count = 0
ll_quantity_count = 0
ll_datetime_count = 0
ll_comment_count = 0

if not pstr_element.valid then return lstr_ccr_refill


for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "number"
			ls_temp = pstr_element.child[i].gettexttrim()
			if len(ls_temp) > 0 and isnumber(ls_temp) then
				ll_number_count += 1
				lstr_ccr_refill.number[ll_number_count] = long(ls_temp)
			end if
		CASE "quantity"
			lstr_element = get_element(pstr_element.child[i])
			ll_quantity_count += 1
			lstr_ccr_refill.quantity[ll_quantity_count] = get_ccr_measuretype(lstr_element)
		CASE "status"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_refill.status = get_ccr_codeddescriptiontype(lstr_element)
		CASE "datetime"
			lstr_element = get_element(pstr_element.child[i])
			ll_datetime_count += 1
			lstr_ccr_refill.datetime[ll_datetime_count] = get_ccr_datetimetype(lstr_element)
		CASE "comment"
			lstr_element = get_element(pstr_element.child[i])
			ll_comment_count += 1
//			lstr_ccr_refill.comment[ll_comment_count] = get_ccr_commenttype(lstr_element)
	END CHOOSE
next


return lstr_ccr_refill

end function

public function str_ccr_reaction get_ccr_reaction (ref str_element pstr_element);str_ccr_reaction lstr_ccr_reaction
string ls_description
long i
long j
long ll_intervention_count
str_element lstr_element
str_element lstr_element2
string ls_name

setnull(lstr_ccr_reaction.sequenceposition)

ll_intervention_count = 0

if not pstr_element.valid then return lstr_ccr_reaction

// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	ls_name = lower(pstr_element.child[i].getname())
	CHOOSE CASE ls_name
		CASE "description"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_reaction.description = get_ccr_codeddescriptiontype(lstr_element)
		CASE "status"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_reaction.status = get_ccr_codeddescriptiontype(lstr_element)
		CASE "severity"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_reaction.severity = get_ccr_codeddescriptiontype(lstr_element)
		CASE "interventions"
			lstr_element = get_element(pstr_element.child[i])
			for j = 1 to lstr_element.child_count
				if lower(lstr_element.child[j].getname()) = "intervention" then
					lstr_element2 = get_element(lstr_element.child[j])
					ll_intervention_count += 1
//					lstr_ccr_reaction.interventions[ll_intervention_count] = get_ccr_interventiontype(lstr_element2)
				end if
			next
		CASE "reactionsequenceposition"
			lstr_ccr_reaction.sequenceposition = long(pstr_element.child[i].gettexttrim())
		CASE "variablesizemodifier"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_reaction.modifier = get_ccr_codeddescriptiontype(lstr_element)
	END CHOOSE
next


return lstr_ccr_reaction

end function

public function str_ccr_resulttype get_ccr_resulttype (ref str_element pstr_element);str_ccr_resulttype lstr_ccr_resulttype
string ls_description
datetime ldt_null
long i
str_element lstr_element
str_ccr_codeddescriptiontype lstr_ccr_codeddescriptiontype
string ls_datetime
long ll_datetime_count
long ll_id_count
long ll_procedure_count
long ll_test_count

setnull(lstr_ccr_resulttype.ccrdataobjectid)

ll_datetime_count = 0
ll_id_count = 0
ll_procedure_count = 0
ll_test_count = 0

if not pstr_element.valid then return lstr_ccr_resulttype


for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "ccrdataobjectid"
			lstr_ccr_resulttype.ccrdataobjectid = pstr_element.child[i].gettexttrim()
		CASE "datetime"
			lstr_element = get_element(pstr_element.child[i])
			ll_datetime_count += 1
			lstr_ccr_resulttype.datetime[ll_datetime_count] = get_ccr_datetimetype(lstr_element)
		CASE "ids"
			lstr_element = get_element(pstr_element.child[i])
			ll_id_count += 1
			lstr_ccr_resulttype.ids[ll_id_count] = get_ccr_idtype(lstr_element)
		CASE "type"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_resulttype.objecttype = get_ccr_codeddescriptiontype(lstr_element)
		CASE "description"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_resulttype.description = get_ccr_codeddescriptiontype(lstr_element)
		CASE "status"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_resulttype.status = get_ccr_codeddescriptiontype(lstr_element)
		CASE "procedure"
			lstr_element = get_element(pstr_element.child[i])
			ll_procedure_count += 1
//			lstr_ccr_resulttype.procedures[ll_procedure_count] = get_ccr_proceduretype(lstr_element)
		CASE "substance"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_resulttype.substance = get_ccr_codeddescriptiontype(lstr_element)
		CASE "test"
			lstr_element = get_element(pstr_element.child[i])
			ll_test_count += 1
			lstr_ccr_resulttype.test[ll_test_count] = get_ccr_testtype(lstr_element)
	END CHOOSE
next

// get the elements from the slrcgroup fields
lstr_ccr_resulttype.slrcgroup = get_ccr_slrcgroup(pstr_element)

return lstr_ccr_resulttype

end function

public function str_ccr_testresulttype get_ccr_testresulttype (ref str_element pstr_element);str_ccr_testresulttype lstr_ccr_testresulttype
string ls_description
datetime ldt_null
long i
str_element lstr_element
str_ccr_codeddescriptiontype lstr_ccr_codeddescriptiontype
string ls_datetime
long ll_code_count
long ll_description_count
string ls_name

setnull(ldt_null)

setnull(lstr_ccr_testresulttype.value)

ll_code_count = 0
ll_description_count = 0

if not pstr_element.valid then return lstr_ccr_testresulttype


// Assume that this is a "CodedDescription" element
for i = 1 to pstr_element.child_count
	ls_name = lower(pstr_element.child[i].getname())
	CHOOSE CASE ls_name
		CASE "value"
			lstr_ccr_testresulttype.value = pstr_element.child[i].gettexttrim()
		CASE "units"
			lstr_element = get_element(pstr_element.child[i])
			ll_code_count += 1
			lstr_ccr_testresulttype.units = get_ccr_units_type(lstr_element)
		CASE "code"
			lstr_element = get_element(pstr_element.child[i])
			ll_code_count += 1
			lstr_ccr_testresulttype.code[ll_code_count] = get_ccr_codetype(lstr_element)
		CASE "description"
			lstr_element = get_element(pstr_element.child[i])
			ll_description_count += 1
			lstr_ccr_testresulttype.description[ll_description_count] = get_ccr_codeddescriptiontype(lstr_element)
		CASE ELSE
			if right(ls_name, 16) = "sequenceposition" then
				lstr_ccr_testresulttype.sequenceposition = long(pstr_element.child[i].gettexttrim())
			end if
			if right(ls_name, 8) = "modifier" then
				lstr_element = get_element(pstr_element.child[i])
				lstr_ccr_testresulttype.modifier = get_ccr_codeddescriptiontype(lstr_element)
			end if
	END CHOOSE
next

return lstr_ccr_testresulttype

end function

public function str_ccr_testtype get_ccr_testtype (ref str_element pstr_element);str_ccr_testtype lstr_ccr_testtype
string ls_description
datetime ldt_null
long i
str_element lstr_element
str_ccr_codeddescriptiontype lstr_ccr_codeddescriptiontype
string ls_datetime
long ll_datetime_count
long ll_id_count
long ll_method_count
long ll_agent_count
long ll_flag_count

setnull(lstr_ccr_testtype.ccrdataobjectid)

ll_datetime_count = 0
ll_id_count = 0
ll_method_count = 0
ll_agent_count = 0
ll_flag_count = 0

if not pstr_element.valid then return lstr_ccr_testtype


for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "ccrdataobjectid"
			lstr_ccr_testtype.ccrdataobjectid = pstr_element.child[i].gettexttrim()
		CASE "datetime"
			lstr_element = get_element(pstr_element.child[i])
			ll_datetime_count += 1
			lstr_ccr_testtype.datetime[ll_datetime_count] = get_ccr_datetimetype(lstr_element)
		CASE "ids"
			lstr_element = get_element(pstr_element.child[i])
			ll_id_count += 1
			lstr_ccr_testtype.ids[ll_id_count] = get_ccr_idtype(lstr_element)
		CASE "type"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_testtype.objecttype = get_ccr_codeddescriptiontype(lstr_element)
		CASE "description"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_testtype.description = get_ccr_codeddescriptiontype(lstr_element)
		CASE "status"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_testtype.status = get_ccr_codeddescriptiontype(lstr_element)
		CASE "method"
			lstr_element = get_element(pstr_element.child[i])
			ll_method_count += 1
			lstr_ccr_testtype.method[ll_method_count] = get_ccr_codeddescriptiontype(lstr_element)
		CASE "agent"
			lstr_element = get_element(pstr_element.child[i])
			ll_agent_count += 1
			lstr_ccr_testtype.agent[ll_agent_count] = get_ccr_agent(lstr_element)
		CASE "testresult"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_testtype.testresult = get_ccr_testresulttype(lstr_element)
		CASE "normalresult"
			lstr_element = get_element(pstr_element.child[i])
//			lstr_ccr_testtype.normalresult[ll_test_count] = get_ccr_normaltype(lstr_element)
		CASE "flag"
			lstr_element = get_element(pstr_element.child[i])
			ll_flag_count += 1
			lstr_ccr_testtype.flag[ll_flag_count] = get_ccr_codeddescriptiontype(lstr_element)
		CASE "confidencevalue"
			lstr_element = get_element(pstr_element.child[i])
			lstr_ccr_testtype.confidencevalue = get_ccr_codeddescriptiontype(lstr_element)
	END CHOOSE
next

// get the elements from the slrcgroup fields
lstr_ccr_testtype.slrcgroup = get_ccr_slrcgroup(pstr_element)

return lstr_ccr_testtype

end function

public function str_patient translate_ccr_patient_info (str_ccr_continuityofcarerecord pstr_ccr);/*********************************************************************
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

str_patient lstr_patient

lstr_patient = f_empty_patient()

//lstr_patient.id_list.id_count = upperbound(pstr_ccr.patient.patientid)
//for i = 1 to lstr_patient.id_list.id_count
//	lstr_patient.id_list.id[i].owner_id = pstr_ccr.patient.patientid[i].ownerid
//	lstr_patient.id_list.id[i].iddomain = pstr_ccr.patient.patientid[i].patientiddomain
//	lstr_patient.id_list.id[i].idvalue = pstr_ccr.patient.patientid[i].patientid
//	
//	// If this is the billing_id, then copy it to the patient structure
//	if lower(lstr_patient.id_list.id[i].iddomain) = "jmjbillingid" then
//		lstr_patient.billing_id = lstr_patient.id_list.id[i].idvalue
//	end if
//next

if upper(left((pstr_ccr.patient.person.gender), 1)) = "F" then
	lstr_patient.sex = "F"
elseif upper(left((pstr_ccr.patient.person.gender), 1)) = "M" then
	lstr_patient.sex = "M"
end if

lstr_patient.date_of_birth = date(pstr_ccr.patient.person.dateofbirth)
lstr_patient.first_name =  pstr_ccr.patient.person.firstname
lstr_patient.last_name = pstr_ccr.patient.person.lastname
lstr_patient.degree = pstr_ccr.patient.person.degree
lstr_patient.name_prefix = pstr_ccr.patient.person.prefix
lstr_patient.middle_name = pstr_ccr.patient.person.middlename
lstr_patient.name_suffix = pstr_ccr.patient.person.suffix


for i = 1 to upperbound(pstr_ccr.patient.objectid)
	CHOOSE CASE lower(pstr_ccr.patient.objectid[i].iddomain)
		CASE "ssn"
			lstr_patient.ssn =  pstr_ccr.patient.objectid[i].idvalue
	END CHOOSE
next

//lstr_patient.primary_language =  pstr_ccr.patient.primarylanguage
//lstr_patient.marital_status =  pstr_ccr.patient.maritalstatus
//lstr_patient.ssn =  pstr_ccr.patient.ssn
//lstr_patient.first_name =  pstr_ccr.patient.firstname
//lstr_patient.last_name = pstr_ccr.patient.lastname
//lstr_patient.degree = pstr_ccr.patient.degree
//lstr_patient.name_prefix = pstr_ccr.patient.nameprefix
//lstr_patient.middle_name = pstr_ccr.patient.middlename
//lstr_patient.name_suffix = pstr_ccr.patient.namesuffix

//lstr_patient.patient_status =  datalist.xml_translate_code( owner_id, &
//																		"patientstatus", &
//																		pstr_ccr.patient.patientstatus, &
//																		"patient_status", &
//																		true)
//
ll_count = upperbound(pstr_ccr.patient.communication)
for i = 1 to ll_count
	if lower(pstr_ccr.patient.communication[i].communication_type) = "phone" then
		lstr_patient.phone_number = pstr_ccr.patient.communication[i].value
	end if
	if lower(pstr_ccr.patient.communication[i].communication_type) = "email" then
		lstr_patient.email_address = pstr_ccr.patient.communication[i].value
	end if
next

ll_count = upperbound(pstr_ccr.patient.address)
for i = 1 to ll_count
	if lower(pstr_ccr.patient.address[i].description) = "address" OR &
		lower(pstr_ccr.patient.address[i].description) = "home" then
		lstr_patient.address_line_1 = pstr_ccr.patient.address[i].addressline1
		lstr_patient.address_line_2 = pstr_ccr.patient.address[i].addressline2
		lstr_patient.city = pstr_ccr.patient.address[i].city
		lstr_patient.state = pstr_ccr.patient.address[i].state
		lstr_patient.zip = pstr_ccr.patient.address[i].zip
		lstr_patient.country = pstr_ccr.patient.address[i].country
	end if
next

Return lstr_patient


end function

public function integer process_ccr (ref str_ccr_continuityofcarerecord pstr_ccr);long i
long ll_null

setnull(ll_null)

//////////////////////////////////////////////////////////////////////////////////////////////////////////
// First post patient fields to the current_patient
//////////////////////////////////////////////////////////////////////////////////////////////////////////

if len(epro_patient.address_line_1) > 0 then
	current_patient.modify_patient("address_line_1", epro_patient.address_line_1)
end if

if len(epro_patient.address_line_2) > 0 then
	current_patient.modify_patient("address_line_2", epro_patient.address_line_2)
end if

if len(epro_patient.city) > 0 then
	current_patient.modify_patient("city", epro_patient.city)
end if

if len(epro_patient.state) > 0 then
	current_patient.modify_patient("state", epro_patient.state)
end if

if len(epro_patient.zip) > 0 then
	current_patient.modify_patient("zip", epro_patient.zip)
end if

if len(epro_patient.country) > 0 then
	current_patient.modify_patient("country", epro_patient.country)
end if

if not isnull(epro_patient.date_of_conception) then
	current_patient.modify_patient("date_of_conception", string(epro_patient.date_of_conception, db_datetime_format))
end if

if len(epro_patient.email_address) > 0 then
	current_patient.modify_patient("email_address", epro_patient.email_address)
end if

if len(epro_patient.marital_status) > 0 then
	current_patient.modify_patient("marital_status", epro_patient.marital_status)
end if

if len(epro_patient.nickname) > 0 then
	current_patient.modify_patient("nickname", epro_patient.nickname)
end if

if len(epro_patient.phone_number) > 0 then
	current_patient.modify_patient("phone_number", epro_patient.phone_number)
end if

if len(epro_patient.primary_language) > 0 then
	current_patient.modify_patient("primary_language", epro_patient.primary_language)
end if

if len(epro_patient.race) > 0 then
	current_patient.modify_patient("race", epro_patient.race)
end if

if len(epro_patient.referring_provider_id) > 0 then
	current_patient.modify_patient("referring_provider_id", epro_patient.referring_provider_id)
end if

if len(epro_patient.primary_provider_id) > 0 then
	current_patient.modify_patient("primary_provider_id", epro_patient.primary_provider_id)
end if

if len(epro_patient.secondary_provider_id) > 0 then
	current_patient.modify_patient("secondary_provider_id", epro_patient.secondary_provider_id)
end if

if len(epro_patient.sex) > 0 then
	current_patient.modify_patient("sex", epro_patient.sex)
end if

if not isnull(epro_patient.time_of_birth) then
	current_patient.modify_patient("time_of_birth", string(epro_patient.time_of_birth))
end if
//////////////////////////////////////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////////////////////////////////////
// Process the body of the CCR message
//////////////////////////////////////////////////////////////////////////////////////////////////////////

for i = 1 to upperbound(pstr_ccr.body.problems)
	process_problem(pstr_ccr, pstr_ccr.body.problems[i])
next

for i = 1 to upperbound(pstr_ccr.body.alerts)
	process_alert(pstr_ccr, pstr_ccr.body.alerts[i])
next

for i = 1 to upperbound(pstr_ccr.body.medications)
	process_structuredproduct(pstr_ccr, pstr_ccr.body.medications[i], "MEDICATION", ll_null)
next

for i = 1 to upperbound(pstr_ccr.body.immunizations)
	process_structuredproduct(pstr_ccr, pstr_ccr.body.immunizations[i], "IMMUNIZATION", ll_null)
next

for i = 1 to upperbound(pstr_ccr.body.vitalsigns)
	process_resulttype(pstr_ccr, pstr_ccr.body.vitalsigns[i], "VITAL", ll_null)
next

for i = 1 to upperbound(pstr_ccr.body.results)
	process_resulttype(pstr_ccr, pstr_ccr.body.results[i], "TEST", ll_null)
next

return 1

end function

public function str_assessment_description translate_ccr_problem_info (ref str_ccr_continuityofcarerecord pstr_ccr, ref str_ccr_problemtype pstr_problem);long i
integer li_sts
long ll_count
long j
string ls_actorid
str_actor_type lstr_actor

str_assessment_description lstr_assessment

lstr_assessment = f_empty_assessment()

for i = 1 to upperbound(pstr_problem.datetime)
	CHOOSE CASE lower(pstr_problem.datetime[i].datetimetype.text)
		CASE "onset"
			lstr_assessment.begin_date = pstr_problem.datetime[i].exactdatetime
	END CHOOSE
next

CHOOSE CASE lower(pstr_problem.objecttype.text)
	CASE "diagnosis"
		lstr_assessment.assessment_type = "SICK"
END CHOOSE

CHOOSE CASE lower(pstr_problem.status.text)
	CASE "chronic"
		lstr_assessment.acuteness = "Chronic"
	CASE "acute"
		lstr_assessment.acuteness = "Acute"
END CHOOSE

lstr_assessment.assessment = pstr_problem.description.text

for i = 1 to upperbound(pstr_problem.description.code)
	CHOOSE CASE lower(pstr_problem.description.code[i].codingsystem)
		CASE "icd-10"
			lstr_assessment.icd10_code = pstr_problem.description.code[i].value
	END CHOOSE
next

for i = 1 to upperbound(pstr_problem.slrcgroup.source)
	for j = 1 to upperbound(pstr_problem.slrcgroup.source[i].actor)
		ls_actorid = pstr_problem.slrcgroup.source[i].actor[j].actorid
		li_sts = get_actor(ls_actorid, lstr_actor)
		if li_sts > 0 then lstr_assessment.diagnosed_by = lstr_actor.user_id
	next
next

//lstr_assessment.id_list.id_count = upperbound(pstr_assessment_info.objectid)
//lstr_assessment.id_list.id = pstr_assessment_info.objectid
//
//lstr_assessment.assessment_id = pstr_assessment_info.assessmentdefinitionid
//
//lstr_assessment.open_encounter_id = get_object_key_from_id(pstr_patient_info, "Encounter", pstr_assessment_info.link_openencounter)
//
//lstr_assessment.location = pstr_assessment_info.location
//lstr_assessment.assessment_status = pstr_assessment_info.assessmentstatus
//
//lstr_assessment.close_encounter_id = get_object_key_from_id(pstr_patient_info, "Encounter", pstr_assessment_info.link_closeencounter)
//
//lstr_assessment.end_date = pstr_assessment_info.enddate

Return lstr_assessment

end function

public function integer process_problem (str_ccr_continuityofcarerecord pstr_ccr, ref str_ccr_problemtype pstr_problem);long i
integer li_sts
string ls_null
long ll_null
string ls_temp
long j
long ll_assessment_count
str_assessment_description lstr_assessment
string ls_find
string ls_date
long ll_problem_id
long lla_assessment_ids[]
integer li_null
long ll_attachment_id
boolean lb_auto_create
boolean lb_prompt_user
str_objecthandling_type lstr_handling
long ll_count
str_context lstr_context
boolean lb_new_object
long ll_patient_workplan_id
string ls_new_object
string ls_purpose

setnull(ls_null)
setnull(ll_null)
setnull(li_null)


// Transfer to assessment_description structure
lstr_assessment = translate_ccr_problem_info(pstr_ccr, pstr_problem)

//// if the treatment doesn't have a handling block, then use the patient handling instructions
//if len(pstr_assessment_info.assessmenthandling.objectcreate) > 0 then
//	lstr_handling = pstr_assessment_info.assessmenthandling
//else
//	lstr_handling = pstr_patient_info.patienthandling
//end if

interpret_objectcreate("Assessment", lstr_handling.objectcreate, lb_auto_create, lb_prompt_user)

// Make sure we have an assessment_id
if isnull(lstr_assessment.assessment_id) then
	lstr_assessment.assessment_id = f_find_assessment_id(lstr_assessment.assessment_type, lstr_assessment.assessment, lstr_assessment.icd10_code)
end if

ll_problem_id = find_assessment(lstr_assessment, lb_auto_create, lb_prompt_user, lb_new_object)
if isnull(ll_problem_id) then 
	log.log(this, "u_component_xml_handler_ccr.process_problem:0049", "Unable to find or create assessment", 4)
	return -1
end if


//// See if this assessment block has a purpose
//if len(pstr_assessment_info.assessmenthandling.purpose) > 0 then
//	ls_purpose = pstr_assessment_info.assessmenthandling.purpose
//end if
//
//// See if this is the primary context for this document
//if lower(jmjdocumentcontext.contextobject) = "assessment" then
//	if isnull(jmjdocumentcontext.assessmentid) then
//		// If the document has context_object = assessment and a null assessmentid, then the document
//		// purpose applies to all assessments that don't already have a purpose
//		if isnull(ls_purpose) and len(document_context.purpose) > 0 then
//			ls_purpose = document_context.purpose
//		end if
//	elseif lower(jmjdocumentcontext.assessmentid) = lower(pstr_assessment_info.assessmentid) then
//		document_context.problem_id = ll_problem_id
//
//		// If this treatment block is the primary context for this document and the treatment block doesn't have a purpose
//		// and the document does have a purpose, then use the document purpose
//		if isnull(ls_purpose) and len(document_context.purpose) > 0 then
//			ls_purpose = document_context.purpose
//		end if
//	end if
//end if


my_context.problem_id = ll_problem_id
assessment_count += 1
problem_id[assessment_count] = ll_problem_id

// Now add the assessment Notes

//for i = 1 to upperbound(pstr_assessment_info.assessmentnote)
//	if len(pstr_assessment_info.assessmentnote[i].NoteAttachment.filetype) > 0 &
//	 AND len(pstr_assessment_info.assessmentnote[i].NoteAttachment.attachmentdata) > 0 then
//		ll_attachment_id = f_new_attachment("Treatment", &
//							ll_problem_id, &
//							pstr_assessment_info.assessmentnote[i].NoteType, &
//							pstr_assessment_info.assessmentnote[i].NoteKey, &
//							pstr_assessment_info.assessmentnote[i].NoteAttachment.filetype, &
//							ls_null, &
//							pstr_assessment_info.assessmentnote[i].NoteAttachment.attachmentname, &
//							pstr_assessment_info.assessmentnote[i].NoteAttachment.filename, &
//							pstr_assessment_info.assessmentnote[i].NoteAttachment.attachmentdata)
//		if ll_attachment_id < 0 then return -1
//	elseif len(pstr_assessment_info.assessmentnote[i].NoteText) > 0 then
//		li_sts = f_set_progress2(my_context.cpr_id, &
//										"assessment", &
//										ll_problem_id, &
//										pstr_assessment_info.assessmentnote[i].notetype, &
//										pstr_assessment_info.assessmentnote[i].notekey, &
//										pstr_assessment_info.assessmentnote[i].notetext, &
//										pstr_assessment_info.assessmentnote[i].notedate, &
//										ll_null, &
//										ll_null, &
//										ll_null, &
//										li_null, &
//										string(pstr_assessment_info.assessmentnote[i].noteseverity))
//	end if
//next


//// Process all the assessment messages
//ll_count = upperbound(pstr_assessment_info.message)
//for i = 1 to ll_count
//	lstr_context.cpr_id = my_context.cpr_id
//	lstr_context.context_object = "Assessment"
//	lstr_context.object_key = ll_problem_id
//	li_sts = send_message(lstr_context, pstr_assessment_info.message[i])
//	if li_sts < 0 then return -1
//next

// Finally, order any workplan designated by the purpose
if len(ls_purpose) > 0 then
	if lb_new_object then
		ls_new_object = "Y"
	else
		ls_new_object = "N"
	end if
	ll_patient_workplan_id = sqlca.jmj_document_order_workplan( my_context.cpr_id, &
																					"Assessment", &
																					ll_problem_id, &
																					ls_purpose, &
																					ls_new_object, &
																					current_user.user_id, &
																					current_scribe.user_id, &
																					ls_null )
end if

return 1

end function

public function integer process_alert (str_ccr_continuityofcarerecord pstr_ccr, ref str_ccr_alert_type pstr_alert);long i
integer li_sts
string ls_null
long ll_null
string ls_temp
long j
long ll_assessment_count
str_assessment_description lstr_assessment
string ls_find
string ls_date
long ll_problem_id
long lla_assessment_ids[]
integer li_null
long ll_attachment_id
boolean lb_auto_create
boolean lb_prompt_user
str_objecthandling_type lstr_handling
long ll_count
str_context lstr_context
boolean lb_new_object
long ll_patient_workplan_id
string ls_new_object
string ls_purpose

setnull(ls_null)
setnull(ll_null)
setnull(li_null)


// Transfer to assessment_description structure
lstr_assessment = translate_ccr_alert_info(pstr_ccr, pstr_alert)

//// if the treatment doesn't have a handling block, then use the patient handling instructions
//if len(pstr_assessment_info.assessmenthandling.objectcreate) > 0 then
//	lstr_handling = pstr_assessment_info.assessmenthandling
//else
//	lstr_handling = pstr_patient_info.patienthandling
//end if

interpret_objectcreate("Assessment", lstr_handling.objectcreate, lb_auto_create, lb_prompt_user)

// Make sure we have an assessment_id
if isnull(lstr_assessment.assessment_id) then
	lstr_assessment.assessment_id = f_find_assessment_id(lstr_assessment.assessment_type, lstr_assessment.assessment, lstr_assessment.icd10_code)
end if

ll_problem_id = find_assessment(lstr_assessment, lb_auto_create, lb_prompt_user, lb_new_object)
if isnull(ll_problem_id) then 
	log.log(this, "u_component_xml_handler_ccr.process_alert:0049", "Unable to find or create assessment", 4)
	return -1
end if


//// See if this assessment block has a purpose
//if len(pstr_assessment_info.assessmenthandling.purpose) > 0 then
//	ls_purpose = pstr_assessment_info.assessmenthandling.purpose
//end if
//
//// See if this is the primary context for this document
//if lower(jmjdocumentcontext.contextobject) = "assessment" then
//	if isnull(jmjdocumentcontext.assessmentid) then
//		// If the document has context_object = assessment and a null assessmentid, then the document
//		// purpose applies to all assessments that don't already have a purpose
//		if isnull(ls_purpose) and len(document_context.purpose) > 0 then
//			ls_purpose = document_context.purpose
//		end if
//	elseif lower(jmjdocumentcontext.assessmentid) = lower(pstr_assessment_info.assessmentid) then
//		document_context.problem_id = ll_problem_id
//
//		// If this treatment block is the primary context for this document and the treatment block doesn't have a purpose
//		// and the document does have a purpose, then use the document purpose
//		if isnull(ls_purpose) and len(document_context.purpose) > 0 then
//			ls_purpose = document_context.purpose
//		end if
//	end if
//end if


my_context.problem_id = ll_problem_id
assessment_count += 1
problem_id[assessment_count] = ll_problem_id

// Now add the assessment Notes

//for i = 1 to upperbound(pstr_assessment_info.assessmentnote)
//	if len(pstr_assessment_info.assessmentnote[i].NoteAttachment.filetype) > 0 &
//	 AND len(pstr_assessment_info.assessmentnote[i].NoteAttachment.attachmentdata) > 0 then
//		ll_attachment_id = f_new_attachment("Treatment", &
//							ll_problem_id, &
//							pstr_assessment_info.assessmentnote[i].NoteType, &
//							pstr_assessment_info.assessmentnote[i].NoteKey, &
//							pstr_assessment_info.assessmentnote[i].NoteAttachment.filetype, &
//							ls_null, &
//							pstr_assessment_info.assessmentnote[i].NoteAttachment.attachmentname, &
//							pstr_assessment_info.assessmentnote[i].NoteAttachment.filename, &
//							pstr_assessment_info.assessmentnote[i].NoteAttachment.attachmentdata)
//		if ll_attachment_id < 0 then return -1
//	elseif len(pstr_assessment_info.assessmentnote[i].NoteText) > 0 then
//		li_sts = f_set_progress2(my_context.cpr_id, &
//										"assessment", &
//										ll_problem_id, &
//										pstr_assessment_info.assessmentnote[i].notetype, &
//										pstr_assessment_info.assessmentnote[i].notekey, &
//										pstr_assessment_info.assessmentnote[i].notetext, &
//										pstr_assessment_info.assessmentnote[i].notedate, &
//										ll_null, &
//										ll_null, &
//										ll_null, &
//										li_null, &
//										string(pstr_assessment_info.assessmentnote[i].noteseverity))
//	end if
//next


//// Process all the assessment messages
//ll_count = upperbound(pstr_assessment_info.message)
//for i = 1 to ll_count
//	lstr_context.cpr_id = my_context.cpr_id
//	lstr_context.context_object = "Assessment"
//	lstr_context.object_key = ll_problem_id
//	li_sts = send_message(lstr_context, pstr_assessment_info.message[i])
//	if li_sts < 0 then return -1
//next

// Finally, order any workplan designated by the purpose
if len(ls_purpose) > 0 then
	if lb_new_object then
		ls_new_object = "Y"
	else
		ls_new_object = "N"
	end if
	ll_patient_workplan_id = sqlca.jmj_document_order_workplan( my_context.cpr_id, &
																					"Assessment", &
																					ll_problem_id, &
																					ls_purpose, &
																					ls_new_object, &
																					current_user.user_id, &
																					current_scribe.user_id, &
																					ls_null )
end if

return 1

end function

public function str_assessment_description translate_ccr_alert_info (ref str_ccr_continuityofcarerecord pstr_ccr, ref str_ccr_alert_type pstr_alert);long i
integer li_sts
long ll_count
long j
long k
string ls_actorid
str_actor_type lstr_actor
string lsa_agent[]
long ll_agent_count
long ll_allergy_drug_count

str_assessment_description lstr_assessment

lstr_assessment = f_empty_assessment()

for i = 1 to upperbound(pstr_alert.datetime)
	CHOOSE CASE lower(pstr_alert.datetime[i].datetimetype.text)
		CASE "onset", "initial occurrence"
			lstr_assessment.begin_date = pstr_alert.datetime[i].exactdatetime
	END CHOOSE
next

CHOOSE CASE lower(pstr_alert.alerttype.text)
	CASE "diagnosis"
		lstr_assessment.assessment_type = "SICK"
	CASE "allergy"
		lstr_assessment.assessment_type = "ALLERGY"
	CASE "well"
		lstr_assessment.assessment_type = "WELL"
	CASE ELSE
		lstr_assessment.assessment_type = "ALLERGY"
END CHOOSE
//
//CHOOSE CASE lower(pstr_alert.status.text)
//	CASE "chronic"
//		lstr_assessment.acuteness = "Chronic"
//	CASE "acute"
//		lstr_assessment.acuteness = "Acute"
//END CHOOSE
//
ll_agent_count = 0
lstr_assessment.assessment = pstr_alert.description.text
for i = 1 to upperbound(pstr_alert.agent)
	for j = 1 to upperbound(pstr_alert.agent[i].products)
		for k = 1 to upperbound(pstr_alert.agent[i].products[j].product)
			if len(pstr_alert.agent[i].products[j].product[k].productname.text) > 0 then
				ll_agent_count += 1
				lsa_agent[ll_agent_count] = pstr_alert.agent[i].products[j].product[k].productname.text
				
				// If we don't already have a description, make the first agent the description
				if isnull(lstr_assessment.assessment) or trim(lstr_assessment.assessment) = "" then
					lstr_assessment.assessment = lsa_agent[ll_agent_count]
				end if
			end if
		next
	next
next

// If this is an allergy, then find the allergy.  Create it if we don't have one
if upper(lstr_assessment.assessment_type) = "ALLERGY" and isnull(lstr_assessment.assessment_id) then
	lstr_assessment.assessment_id = f_find_assessment_id(lstr_assessment.assessment_type, lstr_assessment.assessment, lstr_assessment.icd10_code)
	if isnull(lstr_assessment.assessment_id) then
		log.log(this, "u_component_xml_handler_ccr.translate_ccr_alert_info:0063", "Unable to find or create assessment_id (" + lstr_assessment.assessment + ")", 4)
		return lstr_assessment
	end if
	// If this allergy doesn't have any drugs, then add the agents that match drugs
	SELECT count(*)
	INTO :ll_allergy_drug_count
	FROM c_Allergy_Drug
	WHERE assessment_id = :lstr_assessment.assessment_id;
	if not tf_check() then return lstr_assessment
	if ll_allergy_drug_count = 0 then
		for i = 1 to ll_agent_count
			INSERT INTO c_Allergy_Drug (
				assessment_id,
				drug_id)
			SELECT :lstr_assessment.assessment_id,
						d.drug_id
			FROM c_Drug_Definition d
			WHERE (d.common_name = :lsa_agent[i] OR d.generic_name = :lsa_agent[i])
			AND NOT EXISTS (
				SELECT 1
				FROM c_Allergy_Drug ad
				WHERE ad.assessment_id = :lstr_assessment.assessment_id
				AND ad.drug_id = d.drug_id);
			if not tf_check() then return lstr_assessment
		next
	end if
end if


//
//for i = 1 to upperbound(pstr_alert.description.code)
//	CHOOSE CASE lower(pstr_alert.description.code[i].codingsystem)
//		CASE "icd-10"
//			lstr_assessment.icd10_code = pstr_alert.description.code[i].value
//	END CHOOSE
//next

for i = 1 to upperbound(pstr_alert.slrcgroup.source)
	for j = 1 to upperbound(pstr_alert.slrcgroup.source[i].actor)
		ls_actorid = pstr_alert.slrcgroup.source[i].actor[j].actorid
		li_sts = get_actor(ls_actorid, lstr_actor)
		if li_sts > 0 then lstr_assessment.diagnosed_by = lstr_actor.user_id
	next
next

//lstr_assessment.id_list.id_count = upperbound(pstr_assessment_info.objectid)
//lstr_assessment.id_list.id = pstr_assessment_info.objectid
//
//lstr_assessment.assessment_id = pstr_assessment_info.assessmentdefinitionid
//
//lstr_assessment.open_encounter_id = get_object_key_from_id(pstr_patient_info, "Encounter", pstr_assessment_info.link_openencounter)
//
//lstr_assessment.location = pstr_assessment_info.location
//lstr_assessment.assessment_status = pstr_assessment_info.assessmentstatus
//
//lstr_assessment.close_encounter_id = get_object_key_from_id(pstr_patient_info, "Encounter", pstr_assessment_info.link_closeencounter)
//
//lstr_assessment.end_date = pstr_assessment_info.enddate

Return lstr_assessment

end function

public function integer process_structuredproduct (ref str_ccr_continuityofcarerecord pstr_ccr, ref str_ccr_structuredproducttype pstr_product, string ps_default_treatment_type, long parent_treatment_id);long i
string ls_progress_key
integer li_sts
string ls_null
long ll_null
string ls_temp
long j
long ll_treatment_count
str_treatment_description lstr_treatment
string ls_find
string ls_date
long lla_treatment_ids[]
integer li_null
long ll_observation_count
boolean lb_auto_create
long ll_encounter_id
datetime ldt_null
string ls_consultant_id
long ll_treatmentnote_count
long ll_assessment_count
long ll_attachment_id
boolean lb_prompt_user
string ls_observation_tag
long ll_problem_id
str_objecthandling_type lstr_handling
long ll_count
str_context lstr_context
string ls_purpose
long ll_patient_workplan_id
string ls_new_object
boolean lb_new_object
string ls_progress_user_id

setnull(ls_null)
setnull(ll_null)
setnull(li_null)
setnull(ldt_null)
setnull(ls_purpose)

//ll_observation_count = upperbound(pstr_treatment_info.observation)

// Transfer to treatment_description structure
lstr_treatment = translate_ccr_structuredproduct_info(pstr_ccr, pstr_product, ps_default_treatment_type)

// Make sure we have a treatment_type
if isnull(lstr_treatment.treatment_type) then
	lstr_treatment.treatment_type = ps_default_treatment_type
end if

// Set the parent if there is one
lstr_treatment.parent_treatment_id = parent_treatment_id

// If we still don't have a treatment description then report an error
if isnull(lstr_treatment.treatment_description) then
	log.log(this,"u_component_xml_handler_ccr.process_structuredproduct:0055","No treatment description provided in treatment block", 4)
	return -1
end if


if lstr_treatment.parent_treatment_id > 0 then
	// If this is a child treatment, then always create and don't prompt the user
	lb_auto_create = true
	lb_prompt_user = false
else
	// if the treatment doesn't have a handling block, then use the patient handling instructions
//	if len(pstr_treatment_info.treatmenthandling.objectcreate) > 0 then
//		lstr_handling = pstr_treatment_info.treatmenthandling
//	else
//		lstr_handling = pstr_patient_info.patienthandling
//	end if
	
	interpret_objectcreate("Treatment", "CreateAlways", lb_auto_create, lb_prompt_user)
//	interpret_objectcreate("Treatment", lstr_handling.objectcreate, lb_auto_create, lb_prompt_user)
end if

lstr_treatment.treatment_id = find_treatment(lstr_treatment, lb_auto_create, lb_prompt_user, lb_new_object)
if isnull(lstr_treatment.treatment_id) then
	log.log(this,"u_component_xml_handler_ccr.process_structuredproduct:0078","unable to find or create treatment",4)
	return -1
end if

// See if this treatment block has a purpose
//if len(pstr_treatment_info.treatmenthandling.purpose) > 0 then
//	ls_purpose = pstr_treatment_info.treatmenthandling.purpose
//end if

//// See if this is the primary context for this document
//if lower(jmjdocumentcontext.contextobject) = "treatment" then
//	if isnull(jmjdocumentcontext.treatmentid) then
//		// If the document has context_object = treatment and a null treatmentid, then the document
//		// purpose applies to all root-level treatments that don't already have a purpose
//		if isnull(ls_purpose) and isnull(parent_treatment_id) and len(document_context.purpose) > 0 then
//			ls_purpose = document_context.purpose
//		end if
//	elseif lower(jmjdocumentcontext.treatmentid) = lower(pstr_treatment_info.treatmentid) then
//		document_context.treatment_id = lstr_treatment.treatment_id
//
//		// If this treatment block is the primary context for this document and the treatment block doesn't have a purpose
//		// and the document does have a purpose, then use the document purpose
//		if isnull(ls_purpose) and len(document_context.purpose) > 0 then
//			ls_purpose = document_context.purpose
//		end if
//	end if
//end if

my_context.treatment_id = lstr_treatment.treatment_id
treatment_count += 1
treatment_id[treatment_count] = lstr_treatment.treatment_id



//// Create Treatment Observations
//If ll_observation_count > 0 then
//	// find encounter id from the treatment id
//	SELECT open_encounter_id
//		INTO :ll_encounter_id
//	FROM p_treatment_item
//	WHERE treatment_id = :lstr_treatment.treatment_id;
//	if not tf_check() then return -1
//
//	// If we don't already have an encounter_id, then get it from the treatment, or from the current context
//	if isnull(lstr_treatment.encounter_id) then
//		if ll_encounter_id > 0 then
//			lstr_treatment.encounter_id = ll_encounter_id
//		elseif my_context.encounter_id > 0 then
//			lstr_treatment.encounter_id = my_context.encounter_id
//		end if
//	end if
//
//	For i = 1 to ll_observation_count
//		// Set the observation tag to the status
//		setnull(ls_observation_tag)
//		if len(pstr_treatment_info.observation[i].observationstatus) > 0 then
//			ls_observation_tag = pstr_treatment_info.observation[i].observationstatus
//		elseif  len(pstr_treatment_info.treatmentstatus) > 0 then
//			// If there isn't an observation status set, but there is a treatment status set, then inherit the treatment status
//			ls_observation_tag = pstr_treatment_info.treatmentstatus
//		end if
//		
//		// Make sure the tag is only 12 characters
//		ls_observation_tag = left(ls_observation_tag, 12)
//		
//		li_sts = add_observation_and_results(lstr_treatment.treatment_id, pstr_treatment_info, pstr_treatment_info.observation[i], ls_observation_tag, lstr_treatment.encounter_id, ll_null)
//		if li_sts < 0 then return -1
//	Next
//End If
//
//// Mark 1/4/07 commented out because the new_treatment() method will establish the relationship for new treatments,
//// and we don't want to mess with the associations of existing treatments
////
////// Process the assessment associations
////ll_assessment_count = upperbound(pstr_treatment_info.assessment)
////For i = 1 to ll_assessment_count
////	ll_problem_id = get_object_key_from_id(pstr_patient_info, "Assessment", pstr_treatment_info.assessment[i].id)
////	if ll_problem_id > 0 then
////		li_sts = f_set_progress(my_context.cpr_id, &
////							"Treatment", &
////							lstr_treatment.treatment_id, &
////							"ASSESSMENT", &
////							"Associate", &
////							string(ll_problem_id), &
////							ldt_null, &
////							ll_null, &
////							ll_null, &
////							ll_null)
////		if li_sts < 0 then return -1
////	end if
////Next
////
//
//// See if there are any instructions
//if len(pstr_treatment_info.medication.dosinginstructions) > 0 then
//	li_sts = f_set_progress(my_context.cpr_id, &
//						"Treatment", &
//						lstr_treatment.treatment_id, &
//						"Instructions", &
//						"Dosing Instructions", &
//						pstr_treatment_info.medication.dosinginstructions, &
//						ldt_null, &
//						ll_null, &
//						ll_null, &
//						ll_null)
//end if
//if len(pstr_treatment_info.medication.admininstructions) > 0 then
//	li_sts = f_set_progress(my_context.cpr_id, &
//						"Treatment", &
//						lstr_treatment.treatment_id, &
//						"Instructions", &
//						"Admin Instructions", &
//						pstr_treatment_info.medication.admininstructions, &
//						ldt_null, &
//						ll_null, &
//						ll_null, &
//						ll_null)
//end if

if isnull(lstr_treatment.ordered_by) then
	ls_progress_user_id = current_user.user_id
else
	ls_progress_user_id =lstr_treatment.ordered_by
end if

for i = 1 to upperbound(pstr_product.patientinstructions)
	if len(pstr_product.patientinstructions[i].text) > 0 then
		sqlca.sp_set_treatment_progress( my_context.cpr_id, &
													lstr_treatment.treatment_id, &
													lstr_treatment.open_encounter_id, &
													"Instructions", &
													"Patient Instructions", &
													pstr_product.patientinstructions[i].text, &
													ldt_null, &
													ll_null, &
													ll_null, &
													ll_null, &
													ls_progress_user_id, &
													current_scribe.user_id)
		if not tf_check() then return -1
	end if
next

for i = 1 to upperbound(pstr_product.fulfillmentinstructions)
	if len(pstr_product.fulfillmentinstructions[i].text) > 0 then
		if upper(lstr_treatment.treatment_type) = "MEDICATION" then
			ls_progress_key = "Pharmacist Instructions"
		else
			ls_progress_key = "Fulfillment Instructions"
		end if
		
		sqlca.sp_set_treatment_progress( my_context.cpr_id, &
													lstr_treatment.treatment_id, &
													lstr_treatment.open_encounter_id, &
													"Instructions", &
													ls_progress_key, &
													pstr_product.patientinstructions[i].text, &
													ldt_null, &
													ll_null, &
													ll_null, &
													ll_null, &
													ls_progress_user_id, &
													current_scribe.user_id)
		if not tf_check() then return -1
	end if
next


//// Process the TreatmentNote blocks
//ll_treatmentnote_count = upperbound(pstr_treatment_info.treatmentnote)
//For i = 1 to ll_treatmentnote_count
//	if len(pstr_treatment_info.treatmentnote[i].NoteAttachment.filetype) > 0 &
//	 AND len(pstr_treatment_info.treatmentnote[i].NoteAttachment.attachmentdata) > 0 then
//		ll_attachment_id = f_new_attachment("Treatment", &
//							lstr_treatment.treatment_id, &
//							pstr_treatment_info.treatmentnote[i].NoteType, &
//							pstr_treatment_info.treatmentnote[i].NoteKey, &
//							pstr_treatment_info.treatmentnote[i].NoteAttachment.filetype, &
//							ls_null, &
//							pstr_treatment_info.treatmentnote[i].NoteAttachment.attachmentname, &
//							pstr_treatment_info.treatmentnote[i].NoteAttachment.filename, &
//							pstr_treatment_info.treatmentnote[i].NoteAttachment.attachmentdata)
//		if ll_attachment_id < 0 then return -1
//	elseif len(pstr_treatment_info.treatmentnote[i].NoteText) > 0 then
//		// set the treatment progress record
//		li_sts = f_set_progress(my_context.cpr_id, &
//							"Treatment", &
//							lstr_treatment.treatment_id, &
//							pstr_treatment_info.treatmentnote[i].NoteType, &
//							pstr_treatment_info.treatmentnote[i].NoteKey, &
//							pstr_treatment_info.treatmentnote[i].NoteText, &
//							pstr_treatment_info.treatmentnote[i].NoteDate, &
//							ll_null, &
//							ll_null, &
//							ll_null)
//		if li_sts < 0 then return -1
//	end if
//Next
//
//
//// set the treatment progress record
//if len(pstr_treatment_info.treatmentstatus) > 0 then
//	f_set_progress(my_context.cpr_id, &
//						"Treatment", &
//						lstr_treatment.treatment_id, &
//						"Results", &
//						"Status", &
//						pstr_treatment_info.treatmentstatus, &
//						ldt_null, &
//						ll_null, &
//						ll_null, &
//						ll_null)
//end if
//
//
//if len(consultant_id) > 0 then
//	// If we're associated with a consultant, and this treatment is not yet associated
//	// with a consultant, then associate this treatment with the consultant
//	ls_consultant_id = sqlca.fn_patient_object_progress_value(my_context.cpr_id, &
//																				'Treatment', &
//																				results_from_progress_type, &
//																				lstr_treatment.treatment_id, &
//																				results_from_progress_key)
//
//	if isnull(ls_consultant_id) or ls_consultant_id <> consultant_id then
//		f_set_progress(my_context.cpr_id, &
//							"Treatment", &
//							lstr_treatment.treatment_id, &
//							results_from_progress_type, &
//							results_from_progress_key, &
//							consultant_id, &
//							ldt_null, &
//							ll_null, &
//							ll_null, &
//							ll_null)
//	end if	
//end if
//
//// Process all the encounter messages
//ll_count = upperbound(pstr_treatment_info.message)
//for i = 1 to ll_count
//	lstr_context.cpr_id = my_context.cpr_id
//	lstr_context.context_object = "Treatment"
//	lstr_context.object_key = lstr_treatment.treatment_id
//	li_sts = send_message(lstr_context, pstr_treatment_info.message[i])
//	if li_sts < 0 then return -1
//next
//
//// Process all the constituent treatment messages
//ll_count = upperbound(pstr_treatment_info.constituenttreatment)
//for i = 1 to ll_count
//	process_treatment(pstr_patient_info, pstr_treatment_info.constituenttreatment[i].constituenttreatment, lstr_treatment.treatment_id)
//next


// Finally, order any workplan designated by the purpose
if len(ls_purpose) > 0 then
	if lb_new_object then
		ls_new_object = "Y"
	else
		ls_new_object = "N"
	end if
	ll_patient_workplan_id = sqlca.jmj_document_order_workplan( my_context.cpr_id, &
																					"Treatment", &
																					lstr_treatment.treatment_id, &
																					ls_purpose, &
																					ls_new_object, &
																					current_user.user_id, &
																					current_scribe.user_id, &
																					ls_null )
end if

Return 1


end function

public function integer process_resulttype (ref str_ccr_continuityofcarerecord pstr_ccr, ref str_ccr_resulttype pstr_result, string ps_default_treatment_type, long parent_treatment_id);long i
string ls_in_office_flag
string ls_progress_key
integer li_sts
string ls_null
long ll_null
string ls_temp
long j
long ll_treatment_count
str_treatment_description lstr_treatment
string ls_find
string ls_date
long lla_treatment_ids[]
integer li_null
long ll_test_count
boolean lb_auto_create
long ll_encounter_id
datetime ldt_null
string ls_consultant_id
long ll_treatmentnote_count
long ll_assessment_count
long ll_attachment_id
boolean lb_prompt_user
string ls_observation_tag
long ll_problem_id
str_objecthandling_type lstr_handling
long ll_count
str_context lstr_context
string ls_purpose
long ll_patient_workplan_id
string ls_new_object
boolean lb_new_object
string ls_progress_user_id
str_observation_type lstr_observation
string ls_actorid
str_actor_type lstr_actor
str_observation_type lstra_observations[]
long ll_observation_count


setnull(ls_null)
setnull(ll_null)
setnull(li_null)
setnull(ldt_null)
setnull(ls_purpose)


lstr_treatment = f_empty_treatment()

CHOOSE CASE lower(pstr_result.objecttype.text)
	CASE "medication"
		lstr_treatment.treatment_type = "MEDICATION"
	CASE "lab"
		lstr_treatment.treatment_type = "LAB"
	CASE "test"
		lstr_treatment.treatment_type = "TEST"
	CASE "vitalsigns", "vital signs"
		lstr_treatment.treatment_type = "VITAL"
END CHOOSE

if isnull(lstr_treatment.treatment_type) then
	lstr_treatment.treatment_type = ps_default_treatment_type
end if

for i = 1 to upperbound(pstr_result.datetime)
	CHOOSE CASE lower(pstr_result.datetime[i].datetimetype.text)
		CASE "onset", "date prescribed", "administration date", "assessment time", "result time"
			lstr_treatment.begin_date = pstr_result.datetime[i].exactdatetime
		CASE "closed", "end_date", "prescription stopdate"
			lstr_treatment.end_date = pstr_result.datetime[i].exactdatetime
	END CHOOSE
next

if len(pstr_result.description.text) > 0 then
	lstr_treatment.treatment_description = pstr_result.description.text
end if

CHOOSE CASE lower(pstr_result.status.text)
	CASE "active", "open"
		lstr_treatment.treatment_status = "OPEN"
	CASE "inactive", "closed", "prior history no longer active"
		if isnull(lstr_treatment.end_date) then
			lstr_treatment.end_date = lstr_treatment.begin_date
		end if
		lstr_treatment.treatment_status = "CLOSED"
	CASE ELSE
END CHOOSE


for i = 1 to upperbound(pstr_result.slrcgroup.source)
	for j = 1 to upperbound(pstr_result.slrcgroup.source[i].actor)
		ls_actorid = pstr_result.slrcgroup.source[i].actor[j].actorid
		li_sts = get_actor(ls_actorid, lstr_actor)
		if li_sts > 0 then lstr_treatment.ordered_by = lstr_actor.user_id
	next
next


// Make sure we have a treatment_type
if isnull(lstr_treatment.treatment_type) then
	lstr_treatment.treatment_type = ps_default_treatment_type
end if

// Set the parent if there is one
lstr_treatment.parent_treatment_id = parent_treatment_id

// If we still don't have a treatment description then report an error
if isnull(lstr_treatment.treatment_description) then
	log.log(this,"u_component_xml_handler_ccr.process_resulttype:0109","No treatment description provided in treatment block", 4)
	return -1
end if

//// Get Observations and Results
ll_observation_count = 0
ll_test_count = upperbound(pstr_result.test)
for i = 1 to ll_test_count
	lstr_observation = translate_ccr_testtype(pstr_ccr, lstr_treatment, pstr_result.test[i])
	if len(lstr_observation.description) > 0 then
		ll_observation_count += 1
		lstra_observations[ll_observation_count] = lstr_observation
	end if
next


if lstr_treatment.parent_treatment_id > 0 then
	// If this is a child treatment, then always create and don't prompt the user
	lb_auto_create = true
	lb_prompt_user = false
else
	// if the treatment doesn't have a handling block, then use the patient handling instructions
//	if len(pstr_treatment_info.treatmenthandling.objectcreate) > 0 then
//		lstr_handling = pstr_treatment_info.treatmenthandling
//	else
//		lstr_handling = pstr_patient_info.patienthandling
//	end if
	
	interpret_objectcreate("Treatment", "CreateAlways", lb_auto_create, lb_prompt_user)
//	interpret_objectcreate("Treatment", lstr_handling.objectcreate, lb_auto_create, lb_prompt_user)
end if

ls_in_office_flag = datalist.treatment_type_in_office_flag(lstr_treatment.treatment_type)
if upper(ls_in_office_flag) = "Y" and isnull(lstr_treatment.end_date) then
	lstr_treatment.end_date = lstr_treatment.begin_date
end if

lstr_treatment.treatment_id = find_treatment(lstr_treatment, lb_auto_create, lb_prompt_user, lb_new_object)
if isnull(lstr_treatment.treatment_id) then
	log.log(this,"u_component_xml_handler_ccr.process_resulttype:0148","unable to find or create treatment",4)
	return -1
end if

// See if this treatment block has a purpose
//if len(pstr_treatment_info.treatmenthandling.purpose) > 0 then
//	ls_purpose = pstr_treatment_info.treatmenthandling.purpose
//end if

//// See if this is the primary context for this document
//if lower(jmjdocumentcontext.contextobject) = "treatment" then
//	if isnull(jmjdocumentcontext.treatmentid) then
//		// If the document has context_object = treatment and a null treatmentid, then the document
//		// purpose applies to all root-level treatments that don't already have a purpose
//		if isnull(ls_purpose) and isnull(parent_treatment_id) and len(document_context.purpose) > 0 then
//			ls_purpose = document_context.purpose
//		end if
//	elseif lower(jmjdocumentcontext.treatmentid) = lower(pstr_treatment_info.treatmentid) then
//		document_context.treatment_id = lstr_treatment.treatment_id
//
//		// If this treatment block is the primary context for this document and the treatment block doesn't have a purpose
//		// and the document does have a purpose, then use the document purpose
//		if isnull(ls_purpose) and len(document_context.purpose) > 0 then
//			ls_purpose = document_context.purpose
//		end if
//	end if
//end if

my_context.treatment_id = lstr_treatment.treatment_id
treatment_count += 1
treatment_id[treatment_count] = lstr_treatment.treatment_id


for i = 1 to ll_observation_count
	li_sts = add_observation_and_results(lstr_treatment.treatment_id, lstr_treatment, lstra_observations[i], ls_observation_tag, lstr_treatment.encounter_id, ll_null)
next

//
//// Mark 1/4/07 commented out because the new_treatment() method will establish the relationship for new treatments,
//// and we don't want to mess with the associations of existing treatments
////
////// Process the assessment associations
////ll_assessment_count = upperbound(pstr_treatment_info.assessment)
////For i = 1 to ll_assessment_count
////	ll_problem_id = get_object_key_from_id(pstr_patient_info, "Assessment", pstr_treatment_info.assessment[i].id)
////	if ll_problem_id > 0 then
////		li_sts = f_set_progress(my_context.cpr_id, &
////							"Treatment", &
////							lstr_treatment.treatment_id, &
////							"ASSESSMENT", &
////							"Associate", &
////							string(ll_problem_id), &
////							ldt_null, &
////							ll_null, &
////							ll_null, &
////							ll_null)
////		if li_sts < 0 then return -1
////	end if
////Next
////
//
//// See if there are any instructions
//if len(pstr_treatment_info.medication.dosinginstructions) > 0 then
//	li_sts = f_set_progress(my_context.cpr_id, &
//						"Treatment", &
//						lstr_treatment.treatment_id, &
//						"Instructions", &
//						"Dosing Instructions", &
//						pstr_treatment_info.medication.dosinginstructions, &
//						ldt_null, &
//						ll_null, &
//						ll_null, &
//						ll_null)
//end if
//if len(pstr_treatment_info.medication.admininstructions) > 0 then
//	li_sts = f_set_progress(my_context.cpr_id, &
//						"Treatment", &
//						lstr_treatment.treatment_id, &
//						"Instructions", &
//						"Admin Instructions", &
//						pstr_treatment_info.medication.admininstructions, &
//						ldt_null, &
//						ll_null, &
//						ll_null, &
//						ll_null)
//end if

if isnull(lstr_treatment.ordered_by) then
	ls_progress_user_id = current_user.user_id
else
	ls_progress_user_id =lstr_treatment.ordered_by
end if


//// Process the TreatmentNote blocks
//ll_treatmentnote_count = upperbound(pstr_treatment_info.treatmentnote)
//For i = 1 to ll_treatmentnote_count
//	if len(pstr_treatment_info.treatmentnote[i].NoteAttachment.filetype) > 0 &
//	 AND len(pstr_treatment_info.treatmentnote[i].NoteAttachment.attachmentdata) > 0 then
//		ll_attachment_id = f_new_attachment("Treatment", &
//							lstr_treatment.treatment_id, &
//							pstr_treatment_info.treatmentnote[i].NoteType, &
//							pstr_treatment_info.treatmentnote[i].NoteKey, &
//							pstr_treatment_info.treatmentnote[i].NoteAttachment.filetype, &
//							ls_null, &
//							pstr_treatment_info.treatmentnote[i].NoteAttachment.attachmentname, &
//							pstr_treatment_info.treatmentnote[i].NoteAttachment.filename, &
//							pstr_treatment_info.treatmentnote[i].NoteAttachment.attachmentdata)
//		if ll_attachment_id < 0 then return -1
//	elseif len(pstr_treatment_info.treatmentnote[i].NoteText) > 0 then
//		// set the treatment progress record
//		li_sts = f_set_progress(my_context.cpr_id, &
//							"Treatment", &
//							lstr_treatment.treatment_id, &
//							pstr_treatment_info.treatmentnote[i].NoteType, &
//							pstr_treatment_info.treatmentnote[i].NoteKey, &
//							pstr_treatment_info.treatmentnote[i].NoteText, &
//							pstr_treatment_info.treatmentnote[i].NoteDate, &
//							ll_null, &
//							ll_null, &
//							ll_null)
//		if li_sts < 0 then return -1
//	end if
//Next
//
//
//// set the treatment progress record
//if len(pstr_treatment_info.treatmentstatus) > 0 then
//	f_set_progress(my_context.cpr_id, &
//						"Treatment", &
//						lstr_treatment.treatment_id, &
//						"Results", &
//						"Status", &
//						pstr_treatment_info.treatmentstatus, &
//						ldt_null, &
//						ll_null, &
//						ll_null, &
//						ll_null)
//end if
//
//
//if len(consultant_id) > 0 then
//	// If we're associated with a consultant, and this treatment is not yet associated
//	// with a consultant, then associate this treatment with the consultant
//	ls_consultant_id = sqlca.fn_patient_object_progress_value(my_context.cpr_id, &
//																				'Treatment', &
//																				results_from_progress_type, &
//																				lstr_treatment.treatment_id, &
//																				results_from_progress_key)
//
//	if isnull(ls_consultant_id) or ls_consultant_id <> consultant_id then
//		f_set_progress(my_context.cpr_id, &
//							"Treatment", &
//							lstr_treatment.treatment_id, &
//							results_from_progress_type, &
//							results_from_progress_key, &
//							consultant_id, &
//							ldt_null, &
//							ll_null, &
//							ll_null, &
//							ll_null)
//	end if	
//end if
//
//// Process all the encounter messages
//ll_count = upperbound(pstr_treatment_info.message)
//for i = 1 to ll_count
//	lstr_context.cpr_id = my_context.cpr_id
//	lstr_context.context_object = "Treatment"
//	lstr_context.object_key = lstr_treatment.treatment_id
//	li_sts = send_message(lstr_context, pstr_treatment_info.message[i])
//	if li_sts < 0 then return -1
//next
//
//// Process all the constituent treatment messages
//ll_count = upperbound(pstr_treatment_info.constituenttreatment)
//for i = 1 to ll_count
//	process_treatment(pstr_patient_info, pstr_treatment_info.constituenttreatment[i].constituenttreatment, lstr_treatment.treatment_id)
//next


// Finally, order any workplan designated by the purpose
if len(ls_purpose) > 0 then
	if lb_new_object then
		ls_new_object = "Y"
	else
		ls_new_object = "N"
	end if
	ll_patient_workplan_id = sqlca.jmj_document_order_workplan( my_context.cpr_id, &
																					"Treatment", &
																					lstr_treatment.treatment_id, &
																					ls_purpose, &
																					ls_new_object, &
																					current_user.user_id, &
																					current_scribe.user_id, &
																					ls_null )
end if

Return 1


end function

public function str_observation_type translate_ccr_testtype (ref str_ccr_continuityofcarerecord pstr_ccr, ref str_treatment_description pstr_treatment, ref str_ccr_testtype pstr_test);long i, j
long ll_count
str_observation_type lstr_observation
str_observation_result_type lstr_result
string ls_actorid
integer li_sts
str_actor_type lstr_actor
str_actor_type lstr_observed_by
long ll_result_count

lstr_observation = get_empty_observation()
ll_result_count = 0

CHOOSE CASE lower(pstr_test.objecttype.text)
	CASE "observation"
//		lstr_observation.treatment_type = "MEDICATION"
END CHOOSE

for i = 1 to upperbound(pstr_test.datetime)
	CHOOSE CASE lower(pstr_test.datetime[i].datetimetype.text)
		CASE "result expected date"
			lstr_observation.resultexpecteddate = pstr_test.datetime[i].exactdatetime
		CASE ELSE
			lstr_observation.specimencollected = pstr_test.datetime[i].exactdatetime
	END CHOOSE
next

if len(pstr_test.description.text) > 0 then
	lstr_observation.description = pstr_test.description.text
end if

CHOOSE CASE lower(pstr_test.status.text)
	CASE "ok"
		lstr_observation.observationstatus = "OK"
	CASE ELSE
END CHOOSE


for i = 1 to upperbound(pstr_test.slrcgroup.source)
	for j = 1 to upperbound(pstr_test.slrcgroup.source[i].actor)
		ls_actorid = pstr_test.slrcgroup.source[i].actor[j].actorid
		li_sts = get_actor(ls_actorid, lstr_observed_by)
	next
next

li_sts = translate_ccr_testresulttype( pstr_ccr, pstr_treatment, lstr_observation, pstr_test.testresult)
if li_sts > 0 then
	// If the Test block supplied an observedby actor, then use it for all results that don't already have an observedby actor
	if len(lstr_observed_by.user_id) > 0 then
		for i = 1 to upperbound(lstr_observation.observationresult)
			if isnull(lstr_observation.observationresult[i].observedby.user_id) or trim(lstr_observation.observationresult[i].observedby.user_id) = "" then
				lstr_observation.observationresult[i].observedby = lstr_observed_by
			end if
		next
	end if
end if


Return lstr_observation


end function

public function integer translate_ccr_testresulttype (ref str_ccr_continuityofcarerecord pstr_ccr, ref str_treatment_description pstr_treatment, ref str_observation_type pstr_observation, ref str_ccr_testresulttype pstr_result);long i, j
long ll_count
str_observation_result_type lstr_result
string ls_actorid
integer li_sts
str_actor_type lstr_actor
boolean lb_found

lstr_result = get_empty_observation_result()

lb_found = false

for i = 1 to upperbound(pstr_result.description)
	if len(pstr_result.description[i].text) > 0 then
		lstr_result.result = pstr_result.description[i].text
		lb_found = true
	end if
next

if len(pstr_result.value) > 0 then
	lstr_result.resultvalue = pstr_result.value
	lb_found = true
	
	if len(pstr_result.units.unit) > 0 then
		lstr_result.resultunit = pstr_result.units.unit
	end if
end if

if lb_found then
	if isnull(lstr_result.result) then
		if len(lstr_result.resultunit) > 0 then
			lstr_result.result = pstr_observation.description
		else
			lstr_result.result = lstr_result.resultvalue
			setnull(lstr_result.resultvalue)
		end if
	else
		if isnull(lstr_result.resultunit) and not isnull(lstr_result.resultvalue) then
			lstr_result.resultunit = "TEXT"
		end if
	end if

	ll_count = upperbound(pstr_observation.observationresult) + 1
	pstr_observation.observationresult[ll_count] = lstr_result
	
	return 1
end if



Return 0



end function

public function str_observation_type get_empty_observation ();str_observation_type lstr_observation_type


setnull(lstr_observation_type.description)
setnull(lstr_observation_type.resultexpecteddate)
setnull(lstr_observation_type.stage)
setnull(lstr_observation_type.stagedescription)
setnull(lstr_observation_type.specimencollected)
setnull(lstr_observation_type.observationstatus)


return lstr_observation_type

end function

public function str_observation_result_type get_empty_observation_result ();str_observation_result_type lstr_observation_result_type


setnull(lstr_observation_result_type.location)
setnull(lstr_observation_result_type.result_definition_id)
setnull(lstr_observation_result_type.encounter_date)
setnull(lstr_observation_result_type.resultdate)
setnull(lstr_observation_result_type.resulttype)
setnull(lstr_observation_result_type.result)
setnull(lstr_observation_result_type.resultvalue)
setnull(lstr_observation_result_type.resultunit)
setnull(lstr_observation_result_type.abnormalflag)
setnull(lstr_observation_result_type.abnormalnature)
setnull(lstr_observation_result_type.severity)
setnull(lstr_observation_result_type.referencerange)
setnull(lstr_observation_result_type.resultstatus)


return lstr_observation_result_type

end function

public function str_treatment_description translate_ccr_structuredproduct_info (ref str_ccr_continuityofcarerecord pstr_ccr, ref str_ccr_structuredproducttype pstr_product, string ps_default_treatment_type);str_actor_type lstr_actor
integer li_sts
long i, j
long ll_count
string ls_null
long ll_observation_count
str_treatment_description lstr_treatment
long ll_problem_id
string ls_actorid
string ls_productname
string ls_brandname
string ls_strength
string ls_description
str_drug_definition lstr_drug
string ls_treatment_key
string ls_vaccine_id
string ls_procedure_id
datetime ldt_end_date

setnull(ls_null)


//ll_observation_count = upperbound(pstr_product.observation)

lstr_treatment = f_empty_treatment()

CHOOSE CASE lower(pstr_product.objecttype.text)
	CASE "medication"
		lstr_treatment.treatment_type = "MEDICATION"
	CASE ELSE
		lstr_treatment.treatment_type = ps_default_treatment_type
END CHOOSE

setnull(ldt_end_date)

for i = 1 to upperbound(pstr_product.datetime)
	CHOOSE CASE lower(pstr_product.datetime[i].datetimetype.text)
		CASE "onset", "date prescribed", "administration date"
			lstr_treatment.begin_date = pstr_product.datetime[i].exactdatetime
		CASE "closed", "end_date", "prescription stopdate"
			ldt_end_date = pstr_product.datetime[i].exactdatetime
	END CHOOSE
next

if not isnull(ldt_end_date) then
	if date(ldt_end_date) > today() then
		if not isnull(lstr_treatment.begin_date) then
			// Future stop date - turn into a duration
			lstr_treatment.duration_amount = daysafter(date(lstr_treatment.begin_date), date(ldt_end_date))
			lstr_treatment.duration_unit = "DAY"
		end if
	else
		// past stop date
		lstr_treatment.end_date = ldt_end_date
	end if
end if

if len(pstr_product.description.text) > 0 then
	lstr_treatment.treatment_description = pstr_product.description.text
end if

CHOOSE CASE lower(pstr_product.status.text)
	CASE "active", "open"
		lstr_treatment.treatment_status = "OPEN"
	CASE "inactive", "closed", "prior history no longer active"
		// If no end_date is specified yet 
		if isnull(lstr_treatment.end_date) and isnull(ldt_end_date) then
			lstr_treatment.end_date = lstr_treatment.begin_date
			lstr_treatment.treatment_status = "CLOSED"
		end if
	CASE ELSE
END CHOOSE


for i = 1 to upperbound(pstr_product.slrcgroup.source)
	for j = 1 to upperbound(pstr_product.slrcgroup.source[i].actor)
		ls_actorid = pstr_product.slrcgroup.source[i].actor[j].actorid
		li_sts = get_actor(ls_actorid, lstr_actor)
		if li_sts > 0 then lstr_treatment.ordered_by = lstr_actor.user_id
	next
next

setnull(ls_productname)
setnull(ls_brandname)
setnull(ls_strength)

for i = 1 to upperbound(pstr_product.product)
	if len(pstr_product.product[i].productname.text) > 0 then
		ls_productname = pstr_product.product[i].productname.text
	end if

	if len(pstr_product.product[i].brandname.text) > 0 then
		ls_brandname = pstr_product.product[i].brandname.text
	end if

	for j = 1 to upperbound(pstr_product.product[i].strength)
		if len(pstr_product.product[i].strength[j].value) > 0 then
			ls_strength = pstr_product.product[i].strength[j].value
		end if
	next
next

for i = 1 to upperbound(pstr_product.quantity)
	if len(pstr_product.quantity[i].value) > 0 then
		if isnumber(pstr_product.quantity[i].value) then
			lstr_treatment.dispense_amount = long(pstr_product.quantity[i].value)
		end if
		if len(pstr_product.quantity[i].units.unit) > 0 then
			lstr_treatment.dispense_unit = lookup_epro_id(owner_id, "testunit", ls_null, pstr_product.quantity[i].value, "unit_id")
		end if
	end if
next

for i = 1 to upperbound(pstr_product.refills)
	for j = 1 to upperbound(pstr_product.refills[i].number)
		if not isnull(pstr_product.refills[i].number[j]) then
			lstr_treatment.refills = pstr_product.refills[i].number[j]
		end if
	next
next

// See if we can determine the treatment key
ls_treatment_key = sqlca.fn_treatment_type_treatment_key(lstr_treatment.treatment_type)
CHOOSE CASE lower(ls_treatment_key)
	CASE "drug_id"
		lstr_drug = f_empty_drug()
		
		CHOOSE CASE lower(lstr_treatment.treatment_type)
			CASE "immunization"
				lstr_drug.drug_type = "Vaccine"
			CASE ELSE
				lstr_drug.drug_type = "Single Drug"
		END CHOOSE

		if len(ls_brandname) > 0 then
			// If there is a brandname, then use it for the common_name  and use the productname as the generic name
			lstr_drug.common_name = lookup_epro_id(owner_id, lstr_treatment.treatment_type + ".BrandName", ls_null, ls_brandname, "drug.common_name")
			if isnull(lstr_drug.common_name) then lstr_drug.common_name = ls_brandname

			lstr_drug.generic_name = lookup_epro_id(owner_id, lstr_treatment.treatment_type + ".ProductName", ls_null, ls_productname, "drug.generic_name")
			if isnull(lstr_drug.generic_name) then lstr_drug.generic_name = ls_productname
		else
			// If there is not a brandname, then use the productname for the common_name
			lstr_drug.common_name = lookup_epro_id(owner_id, lstr_treatment.treatment_type + ".ProductName", ls_null, ls_productname, "drug.common_name")
			if isnull(lstr_drug.common_name) then lstr_drug.common_name = ls_productname
		end if
		
		if len(lstr_drug.common_name) > 0 then
			li_sts = drugdb.save_new_drug(lstr_drug)
			if li_sts > 0 then
				lstr_treatment.drug_id = lstr_drug.drug_id
			end if
		end if
	CASE "procedure_id"
		if lower(lstr_treatment.treatment_type) = "immunization" then
			// Start by treating the product name as a vaccine
			if len(ls_productname) > 0 then
//				lstr_treatment.dispense_unit = lookup_epro_id(owner_id, "testunit", ls_null, pstr_product.quantity[i].value, "unit_id")

				SELECT TOP 1 vaccine_id
				INTO :ls_vaccine_id
				FROM c_Vaccine
				WHERE description = :ls_productname
				ORDER BY status desc;
				if not tf_check() then
					// don't do anything on error
				elseif len(ls_vaccine_id) > 0 then
					// We found a vaccine_id, now find the procedure_id
					SELECT TOP 1 procedure_id
					INTO :ls_procedure_id
					FROM c_Procedure
					WHERE procedure_type = 'IMMUNIZATION'
					AND vaccine_id = :ls_vaccine_id;
					if not tf_check() then
						// don't do anything on error
					elseif len(ls_procedure_id) > 0 then
						lstr_treatment.procedure_id = ls_procedure_id
					end if
				end if
			end if
		end if
		if isnull(lstr_treatment.procedure_id) and len(ls_productname) > 0 then
			SELECT TOP 1 procedure_id
			INTO :ls_procedure_id
			FROM c_Procedure
			WHERE description = :ls_productname
			ORDER BY status desc;
			if not tf_check() then
				// don't do anything on error
			elseif len(ls_procedure_id) > 0 then
				lstr_treatment.procedure_id = ls_procedure_id
			end if
		end if
END CHOOSE
	
//	lstr_treatment.drug_id = pstr_product.medication.drugid
//	lstr_treatment.lot_number = pstr_product.medication.lotnumber
//	lstr_treatment.expiration_date = pstr_product.medication.expirationdate
//	lstr_treatment.package_id = pstr_product.medication.package.packageid
//	if isnumber(pstr_product.medication.dose.amount) then
//		lstr_treatment.dose_amount = real(pstr_product.medication.dose.amount)
//		lstr_treatment.dose_unit = pstr_product.medication.dose.unit.unitid
//	end if
//	lstr_treatment.administer_frequency = pstr_product.medication.frequency.abbreviation
//	if isnumber(pstr_product.medication.duration.amount) then
//		lstr_treatment.duration_amount = real(pstr_product.medication.duration.amount)
//		lstr_treatment.duration_unit = pstr_product.medication.duration.unit.unitid
//	end if
//	lstr_treatment.duration_prn = pstr_product.medication.durationprn
//	if isnumber(pstr_product.medication.dispenseatpharmacy.amount) then
//		lstr_treatment.dispense_amount = real(pstr_product.medication.dispenseatpharmacy.amount)
//		lstr_treatment.dispense_unit = pstr_product.medication.dispenseatpharmacy.unit.unitid
//	end if
//	if isnumber(pstr_product.medication.dispenseinoffice.amount) then
//		lstr_treatment.office_dispense_amount = real(pstr_product.medication.dispenseinoffice.amount)
//	end if
//	if not isnull(pstr_product.medication.substitutionallowed) then
//		if pstr_product.medication.substitutionallowed then
//			lstr_treatment.brand_name_required = "N"
//		else
//			lstr_treatment.brand_name_required = "Y"
//		end if
//	end if
//	lstr_treatment.refills = pstr_product.medication.refillsallowed


// If the treatment description is still null then construct it from the product info
if isnull(lstr_treatment.treatment_description) then
	ls_description = ""
	if len(ls_brandname) > 0 then
		if len(ls_description) > 0 then ls_description += ", "
		ls_description += ls_brandname
	end if

	if len(ls_productname) > 0 then
		if len(ls_description) > 0 then
			ls_description += " (" + ls_productname + ")"
		else
			ls_description = ls_productname
		end if
	end if

	if len(ls_strength) > 0 then
		if len(ls_description) > 0 then ls_description += " "
		ls_description += ls_strength
	end if

	if len(ls_description) > 0 then
		lstr_treatment.treatment_description = ls_description
	end if
end if


//// Transfer to treatment_description structure
//lstr_treatment.id_list.id_count = upperbound(pstr_product.objectid)
//lstr_treatment.id_list.id = pstr_product.objectid
//
//lstr_treatment.open_encounter_id = get_object_key_from_id(pstr_patient_info, "Encounter", pstr_product.link_openencounter)

//lstr_treatment.treatment_description = pstr_product.description
//lstr_treatment.specimen_id = pstr_product.SpecimenID
//lstr_treatment.location = lookup_epro_id(owner_id, "treatmentlocation", pstr_product.treatmentlocation, ls_null, "location")
//
//lstr_treatment.treatment_status = datalist.xml_translate_code(owner_id, "treatmentstatus", pstr_product.treatmentstatus, "treatment_status", false)
//
//lstr_treatment.close_encounter_id = get_object_key_from_id(pstr_patient_info, "Encounter", pstr_product.link_closeencounter)
//lstr_treatment.end_date = pstr_product.enddate
//lstr_treatment.ordered_by = pstr_product.orderedby.user_id
//lstr_treatment.ordered_for = pstr_product.orderedfor.user_id
////lstr_treatment.completed_by = pstr_product.completedby.user_id
//
//// Medication block
//if len(pstr_product.medication.commonname) > 0 then
//	lstr_treatment.drug_id = pstr_product.medication.drugid
//	lstr_treatment.lot_number = pstr_product.medication.lotnumber
//	lstr_treatment.expiration_date = pstr_product.medication.expirationdate
//	lstr_treatment.package_id = pstr_product.medication.package.packageid
//	if isnumber(pstr_product.medication.dose.amount) then
//		lstr_treatment.dose_amount = real(pstr_product.medication.dose.amount)
//		lstr_treatment.dose_unit = pstr_product.medication.dose.unit.unitid
//	end if
//	lstr_treatment.administer_frequency = pstr_product.medication.frequency.abbreviation
//	if isnumber(pstr_product.medication.duration.amount) then
//		lstr_treatment.duration_amount = real(pstr_product.medication.duration.amount)
//		lstr_treatment.duration_unit = pstr_product.medication.duration.unit.unitid
//	end if
//	lstr_treatment.duration_prn = pstr_product.medication.durationprn
//	if isnumber(pstr_product.medication.dispenseatpharmacy.amount) then
//		lstr_treatment.dispense_amount = real(pstr_product.medication.dispenseatpharmacy.amount)
//		lstr_treatment.dispense_unit = pstr_product.medication.dispenseatpharmacy.unit.unitid
//	end if
//	if isnumber(pstr_product.medication.dispenseinoffice.amount) then
//		lstr_treatment.office_dispense_amount = real(pstr_product.medication.dispenseinoffice.amount)
//	end if
//	if not isnull(pstr_product.medication.substitutionallowed) then
//		if pstr_product.medication.substitutionallowed then
//			lstr_treatment.brand_name_required = "N"
//		else
//			lstr_treatment.brand_name_required = "Y"
//		end if
//	end if
//	lstr_treatment.refills = pstr_product.medication.refillsallowed
//	
//end if
//
//
//ll_count = upperbound(pstr_product.link_assessment)
//lstr_treatment.problem_count = 0
//for i = 1 to ll_count
//	ll_problem_id = get_object_key_from_id(pstr_patient_info, "Assessment", pstr_product.link_assessment[i])
//	if ll_problem_id > 0 then
//		lstr_treatment.problem_count += 1
//		lstr_treatment.problem_ids[lstr_treatment.problem_count] = ll_problem_id
//	end if
//next
//
//// If a treatment description wasn't supplied then get the first observation description and use it as the
//// treatment description
//if isnull(lstr_treatment.treatment_description) then
//	// get the first OBR desc
//	if ll_observation_count > 0 then
//		lstr_treatment.treatment_description = pstr_product.observation[1].description
//	end if
//end if


Return lstr_treatment


end function

on u_component_xml_handler_ccr.create
call super::create
end on

on u_component_xml_handler_ccr.destroy
call super::destroy
end on

