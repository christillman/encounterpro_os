$PBExportHeader$u_component_xml_handler_jmj.sru
forward
global type u_component_xml_handler_jmj from u_component_xml_handler_base
end type
end forward

global type u_component_xml_handler_jmj from u_component_xml_handler_base
end type
global u_component_xml_handler_jmj u_component_xml_handler_jmj

type variables

// Cache the owner of the current ccr data
string consultant_id
string results_from_progress_type
string results_from_progress_key

// patient data found in this document
boolean patientrecord_found
str_patientrecord_type patientrecord

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
public function integer process_assessment (ref str_patientrecord_type pstr_patient_info, ref str_assessment_instance_type pstr_assessment_info)
public function integer process_encounter (ref str_patientrecord_type pstr_patient_info, ref str_encounter_type pstr_encounter_info)
public function integer process_treatment (ref str_patientrecord_type pstr_patient_info, ref str_treatment_type pstr_treatment_info, long parent_treatment_id)
public function integer process_patient (ref str_patientrecord_type pstr_patient_xml, ref str_patient pstr_patient_local, boolean pb_new_patient)
public function integer process_authority (ref str_patientrecord_type pstr_patient_xml, ref str_patient pstr_patient_local, ref str_authority_type pstr_authority)
public function integer pick_office (ref str_actor_type pstr_office)
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
PBDOM_ELEMENT lo_elem[]
PBDOM_ATTRIBUTE pbdom_attribute_array[]
datetime ldt_result_expected_date
integer li_sts
long ll_owner_id
int i
string ls_root
string ls_tag
long ll_count
boolean lb_haschildren
PBDOM_ELEMENT lo_actors
str_element lstr_element
str_element lstr_patient_element
str_patient lstr_patient
string ls_value
boolean lb_new_object
str_popup_return popup_return
long ll_root_attribute_count

TRY
	lo_root = xml.XML_Document.GetRootElement()
	ls_root = lo_root.getname()
	
	lo_root.GetChildElements(ref lo_elem)
	ll_count = UpperBound(lo_elem)

	lo_root.GetAttributes(ref pbdom_attribute_array[])
	ll_root_attribute_count = UpperBound(pbdom_attribute_array)
CATCH (pbdom_exception lo_error)
	log.log(this, "u_component_xml_handler_jmj.xx_interpret_xml:0031", "Error - " + lo_error.text, 4)
	return -1
END TRY

if isnull(ls_root) or lower(ls_root) <> "jmjdocument" then
	log.log(this, "u_component_xml_handler_jmj.xx_interpret_xml:0036", "Error - Document root is not 'JMJDocument'", 4)
	return -1
end if

// Initialize the document context
jmjdocumentcontext = empty_jmjdocumentcontext_type()

patientrecord_found = false

// Get the sendermessageid from the document root attribute, if present.  Will be overwritten by <Message> block if present
for i = 1 to ll_root_attribute_count
	CHOOSE CASE lower(pbdom_attribute_array[i].GetName())
		CASE "documentid"
			jmjdocumentcontext.messageid.sendermessageid =  pbdom_attribute_array[i].GetText()
	END CHOOSE
next



for i = 1 to ll_count
	ls_tag = lo_elem[i].getname()
	ls_value = lo_elem[i].gettexttrim( )
	
	CHOOSE CASE lower(ls_tag)
		CASE "customerid"
			if len(ls_value) > 0 then
				if isnumber(ls_value) then
					customer_id = long(ls_value)
				else
					log.log(this, "u_component_xml_handler_jmj.xx_interpret_xml:0065", "Customer ID not numeric", 3)
				end if
			end if
		CASE "ownerid"
			if len(ls_value) > 0 then
				if isnumber(ls_value) then
					owner_id = long(ls_value)
					consultant_id = datalist.consultant_from_owner_id(owner_id)
				else
					log.log(this, "u_component_xml_handler_jmj.xx_interpret_xml:0074", "Owner ID not numeric", 3)
				end if
			end if
		CASE "actors"
			lo_actors = lo_elem[i]
		CASE "primarycontext"
			lstr_element = get_element(lo_elem[i])
			jmjdocumentcontext = get_jmjdocumentcontext_type(lstr_element)
			document_context.context_object = jmjdocumentcontext.contextobject
			document_context.purpose = jmjdocumentcontext.purpose
		CASE "patientrecord"
			lstr_patient_element = get_element(lo_elem[i])
			patientrecord_found = true
		CASE "message"
			lstr_element = get_element(lo_elem[i])
			jmjdocumentcontext.messageid = get_jmjdocument_messageid_type(lstr_element)
	END CHOOSE
next

if not isvalid(lo_actors) then
	log.log(this, "u_component_xml_handler_jmj.xx_interpret_xml:0094", "Error - Document has no actors", 4)
	return -1
else
	li_sts = get_actors(lo_actors)
	if li_sts < 0 then
		log.log(this, "u_component_xml_handler_jmj.xx_interpret_xml:0099", "Error - An error has occured while reading the actors", 4)
		return -1
	end if
end if

if isnull(owner_id) then
	log.log(this, "u_component_xml_handler_jmj.xx_interpret_xml:0105", "Error - Document has no OwnerID element", 4)
	return -1
end if

if isnull(customer_id) then
	customer_id = sqlca.customer_id
elseif customer_id <> sqlca.customer_id then
	if cpr_mode = "SERVER" then
		log.log(this, "u_component_xml_handler_jmj.xx_interpret_xml:0113", "Data file customer_id doesn't match local database", 4)
		return -1
	else
		openwithparm(w_pop_yes_no, "This Data File is intended for customer # " + string(customer_id) + ", but the local database is customer # " + string(sqlca.customer_id) + ".  Are you sure you want to process this data file?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return -1
		customer_id = sqlca.customer_id
	end if
end if


// Now process the "patientrecord" element
if patientrecord_found then
	patientrecord = get_patientrecord_type(lstr_patient_element)
	
	// Get the patient info into a str_patient structure for using with the find_patient() method
	lstr_patient = translate_patient_info(patientrecord)

	li_sts = find_patient(lstr_patient, patientrecord.patienthandling.create_flag, patientrecord.patienthandling.create_ask, lb_new_object)
	if li_sts <= 0 then
		log.log(this,"u_component_xml_handler_jmj.xx_interpret_xml:0133","unable to find a patient record",4)
		return -1
	end if
	
	li_sts = process_patient(patientrecord, lstr_patient, lb_new_object)
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
long lla_assessment_ids[]
integer li_null
long ll_attachment_id
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

setnull(ls_purpose)

// Transfer to assessment_description structure
lstr_assessment = translate_assessment_info(pstr_patient_info, pstr_assessment_info)

// if the treatment doesn't have a handling block, then use the patient handling instructions
if len(pstr_assessment_info.assessmenthandling.objectcreate) > 0 then
	lstr_handling = pstr_assessment_info.assessmenthandling
else
	lstr_handling = pstr_patient_info.patienthandling
end if

//interpret_objectcreate("Assessment", lstr_handling.objectcreate, lb_auto_create, lb_prompt_user)


pstr_assessment_info.encounterpro_problem_id = find_assessment(lstr_assessment, pstr_assessment_info.assessmenthandling.create_flag , pstr_assessment_info.assessmenthandling.create_ask, lb_new_object)
if isnull(pstr_assessment_info.encounterpro_problem_id) then 
	log.log(this, "u_component_xml_handler_jmj.process_assessment:0043", "Unable to find or create assessment", 4)
	return -1
end if

lstr_assessment.problem_id = pstr_assessment_info.encounterpro_problem_id

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
		document_context.problem_id = pstr_assessment_info.encounterpro_problem_id

		// If this treatment block is the primary context for this document and the treatment block doesn't have a purpose
		// and the document does have a purpose, then use the document purpose
		if isnull(ls_purpose) and len(document_context.purpose) > 0 then
			ls_purpose = document_context.purpose
		end if
	end if
end if


my_context.problem_id = pstr_assessment_info.encounterpro_problem_id
assessment_count += 1
problem_id[assessment_count] = pstr_assessment_info.encounterpro_problem_id

// Now add the assessment Notes

for i = 1 to upperbound(pstr_assessment_info.assessmentnote)
	if len(pstr_assessment_info.assessmentnote[i].NoteAttachment.filetype) > 0 &
	 AND len(pstr_assessment_info.assessmentnote[i].NoteAttachment.attachmentdata) > 0 then
		ll_attachment_id = f_new_attachment("Treatment", &
							pstr_assessment_info.encounterpro_problem_id, &
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
										pstr_assessment_info.encounterpro_problem_id, &
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
	lstr_context.object_key = pstr_assessment_info.encounterpro_problem_id
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
																					pstr_assessment_info.encounterpro_problem_id, &
																					ls_purpose, &
																					ls_new_object, &
																					current_user.user_id, &
																					current_scribe.user_id, &
																					ls_null)
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
long ll_count
str_context lstr_context
boolean lb_new_object
long ll_patient_workplan_id
string ls_new_object
string ls_purpose
str_c_office lstr_offices[]
long ll_office_count
boolean lb_is_document_context
boolean lb_checkin
date ld_encounter_date
str_c_xml_code lstr_xml_code

setnull(ls_null)
setnull(ll_null)
setnull(li_null)

lb_is_document_context = false
lb_checkin = false
setnull(ls_purpose)

// Transfer to encounter_description structure
lstr_encounter = translate_encounter_info(pstr_patient_info, pstr_encounter_info)

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
		//document_context.encounter_id = ll_encounter_id
		lb_is_document_context = true

		// If this treatment block is the primary context for this document and the treatment block doesn't have a purpose
		// and the document does have a purpose, then use the document purpose
		if isnull(ls_purpose) and len(document_context.purpose) > 0 then
			ls_purpose = document_context.purpose
		end if
	end if
end if

// Make sure we have an encounter date
if isnull(lstr_encounter.encounter_date) then
	log.log(this, "u_component_xml_handler_jmj.process_encounter:0066", "Encounter must have an encounter date", 4)
	return -1
end if

// If this is a check-in, then enforce some mapping requirements
if lower(ls_purpose) = "check in" then
	// Make sure the encounter date is valid
	ld_encounter_date = date(lstr_encounter.encounter_date)
	if ld_encounter_date > today() then
		log.log(this, "u_component_xml_handler_jmj.process_encounter:0075", "Encounter date may not be in the future", 4)
		return -1
	end if
	if ld_encounter_date < today() then
		if not datalist.get_preference_boolean( "Preferences", "ALLOW_PAST_ENCOUNTERS", false) then
			log.log(this, "u_component_xml_handler_jmj.process_encounter:0080", "Encounter date may not be in the past", 3)
			// Do not leave this case for the to-be-posted screen
			return 0
		end if
	end if
	
	// Enforce an office mapping
	if isnull(lstr_encounter.office_id) then
		ll_office_count = datalist.get_offices(lstr_offices)
		if ll_office_count = 1 then
			// If there's only one office then automatically check the patient into the one office
			lstr_encounter.office_id = lstr_offices[1].office_id
		elseif cpr_mode = "CLIENT" and len(pstr_encounter_info.encounterlocation.user_id) > 0 then
			li_sts = pick_office(pstr_encounter_info.encounterlocation)
			if li_sts > 0 then
				lstr_encounter.office_id = user_list.user_property(pstr_encounter_info.encounterlocation.user_id, "office_id")
			end if
		end if
		if isnull(lstr_encounter.office_id) then
			log.log(this, "u_component_xml_handler_jmj.process_encounter:0099", "Encounter Location must be mapped to an Office for check-in events", 4)
			return -1
		end if
	end if

	//	Make sure there's a real encounter type.  If not then use a default
	if isnull(lstr_encounter.encounter_type) then
		// Log an unmapped encounter type so a user can map it easily
		lstr_xml_code = f_empty_xml_code()
		
		lstr_xml_code.owner_id = owner_id
		lstr_xml_code.code_domain =  "EncounterType"
		setnull(lstr_xml_code.code_version)
		lstr_xml_code.code = pstr_encounter_info.encountertype
		lstr_xml_code.code_description = ls_null
		lstr_xml_code.epro_domain = "encounter_type"
		lstr_xml_code.epro_id = ls_null
		lstr_xml_code.epro_owner_id = sqlca.customer_id
		lstr_xml_code.epro_description = ls_null
		lstr_xml_code.created_by = current_scribe.user_id
		lstr_xml_code.mapping_owner_id = sqlca.customer_id
		lstr_xml_code.status = "Unmapped"
		lstr_xml_code.description = ls_null
		
		datalist.xml_add_mapping(lstr_xml_code)
		
		lstr_encounter.encounter_type = datalist.get_preference("PREFERENCES", "default_encounter_type")
		if isnull(lstr_encounter.encounter_type) then
			lstr_encounter.encounter_type = "SICK"
		end if
	end if
	
	// Make sure there's an attending doctor.  If not then use a default
	if isnull(lstr_encounter.attending_doctor) or lower(pstr_encounter_info.attendingdoctor.actorclass) <> "user" then
		lstr_encounter.attending_doctor = datalist.get_preference("PREFERENCES", "default_encounter_owner")
		if isnull(lstr_encounter.attending_doctor) then
			lstr_encounter.attending_doctor = "!Physician"
		end if
	end if
	
	lb_checkin = true
end if

if isnull(lstr_encounter.encounter_type) then
	lstr_encounter.encounter_type = lookup_epro_id(owner_id, "EncounterType", ls_null, pstr_encounter_info.encountertype, "encounter_type")
end if

ll_encounter_id = find_encounter(lstr_encounter, pstr_encounter_info.encounterhandling.create_flag, pstr_encounter_info.encounterhandling.create_ask, lb_checkin, lb_new_object)
if isnull(ll_encounter_id) then 
	log.log(this, "u_component_xml_handler_jmj.process_encounter:0148", "Unable to find or create encounter", 4)
	return -1
end if

if lb_is_document_context then
	document_context.encounter_id = ll_encounter_id
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
long ll_encounter_id
datetime ldt_null
string ls_consultant_id
long ll_treatmentnote_count
long ll_assessment_count
long ll_attachment_id
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
	log.log(this,"u_component_xml_handler_jmj.process_treatment:0046","No treatment description provided in treatment block", 4)
	return -1
end if

// If we still don't have a begin_date then report an error
if isnull(lstr_treatment.begin_date) then
	log.log(this,"u_component_xml_handler_jmj.process_treatment:0052","No begin_date provided in treatment block", 4)
	return -1
end if

lstr_treatment.treatment_id = find_treatment(lstr_treatment, pstr_treatment_info.treatmenthandling.create_flag, pstr_treatment_info.treatmenthandling.create_ask, lb_new_object)
if isnull(lstr_treatment.treatment_id) then
	log.log(this,"u_component_xml_handler_jmj.process_treatment:0058","unable to find or create treatment",4)
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

// Process all the constituent treatment messages
ll_count = upperbound(pstr_treatment_info.constituenttreatments.treatment)
for i = 1 to ll_count
	li_sts = process_treatment(pstr_patient_info, pstr_treatment_info.constituenttreatments.treatment[i], lstr_treatment.treatment_id)
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

public function integer process_patient (ref str_patientrecord_type pstr_patient_xml, ref str_patient pstr_patient_local, boolean pb_new_patient);integer li_sts
string ls_tag
long i
long ll_count
str_context lstr_context
long ll_null

setnull(ll_null)

// If this isn't a new patient and we want to update the patient
if not pb_new_patient and pstr_patient_xml.patienthandling.update_flag then
	f_update_patient(pstr_patient_local)
end if

// If this is a new patient OR if we are posting updates, then process the authorities
if pb_new_patient or pstr_patient_xml.patienthandling.update_flag then
	for i = 1 to upperbound(pstr_patient_xml.authority)
		li_sts = process_authority(pstr_patient_xml, pstr_patient_local, pstr_patient_xml.authority[i])
	next
end if

// Process all the encounters
ll_count = upperbound(pstr_patient_xml.encounter)
for i = 1 to ll_count
	li_sts = process_encounter(pstr_patient_xml, pstr_patient_xml.encounter[i])
	if li_sts < 0 then return -1
next
	
// Process all the assessments
ll_count = upperbound(pstr_patient_xml.assessment)
for i = 1 to ll_count
	li_sts = process_assessment(pstr_patient_xml, pstr_patient_xml.assessment[i])
	if li_sts < 0 then return -1
next

// Process all the treatments
ll_count = upperbound(pstr_patient_xml.treatment)
for i = 1 to ll_count
	li_sts = process_treatment(pstr_patient_xml, pstr_patient_xml.treatment[i], ll_null)
	if li_sts < 0 then return -1
next

// Process all the patient message
ll_count = upperbound(pstr_patient_xml.message)
for i = 1 to ll_count
	lstr_context.cpr_id = my_context.cpr_id
	lstr_context.context_object = "Patient"
	setnull(lstr_context.object_key)
	li_sts = send_message(lstr_context, pstr_patient_xml.message[i])
	if li_sts < 0 then return -1
next

return 1


end function

public function integer process_authority (ref str_patientrecord_type pstr_patient_xml, ref str_patient pstr_patient_local, ref str_authority_type pstr_authority);string ls_authority_id
long ll_authority_sequence

ls_authority_id = sqlca.fn_lookup_user_id(pstr_authority.authority.user_id, customer_id, "authority_id")
if not tf_check() then return -1
if isnull(ls_authority_id) then return 0

if isnumber(pstr_authority.sequence) then
	ll_authority_sequence = long(pstr_authority.sequence)
else
	ll_authority_sequence = 1
end if

sqlca.sp_set_patient_authority( my_context.cpr_id, &
										pstr_authority.startdate, &
										pstr_authority.enddate, &
										ll_authority_sequence, &
										ls_authority_id, &
										current_user.user_id, &
										current_scribe.user_id)
if not tf_check() then return -1

return 1

end function

public function integer pick_office (ref str_actor_type pstr_office);integer li_sts
str_popup popup
str_popup_return popup_return
string ls_office_id
string ls_description
string ls_mapped_office_user_id

popup.dataobject = "dw_office_pick"
popup.title = "Select office for ~"" + pstr_office.name + "~""
popup.datacolumn = 1
popup.displaycolumn = 2

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

ls_office_id = popup_return.items[1]
ls_description = popup_return.descriptions[1]

li_sts = sqlca.jmj_set_office_actor(pstr_office.user_id, ls_office_id, current_scribe.user_id, ls_mapped_office_user_id)
if not tf_check() then return -1
if li_sts <= 0 then
	log.log(this, "u_component_xml_handler_jmj.pick_office:0023", "Error setting office actor", 4)
	return -1
end if

pstr_office.user_id = ls_mapped_office_user_id

return 1

end function

on u_component_xml_handler_jmj.create
call super::create
end on

on u_component_xml_handler_jmj.destroy
call super::destroy
end on

