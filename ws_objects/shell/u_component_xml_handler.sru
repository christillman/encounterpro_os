HA$PBExportHeader$u_component_xml_handler.sru
forward
global type u_component_xml_handler from u_component_base_class
end type
end forward

global type u_component_xml_handler from u_component_base_class
end type
global u_component_xml_handler u_component_xml_handler

type variables
u_xml_document xml
str_complete_context my_context
str_complete_context document_context

any document_payload

long successful_mapping_count
long successful_mapping[]
long failed_mapping_count
long failed_mapping[]

// Whose codes to use by default
long owner_id

// What customer originated this data and owns the JMJ domains
long customer_id


end variables

forward prototypes
protected function integer xx_interpret_xml ()
public function string get_childelement_gettext (pbdom_element puo_pbdom_element, string ps_element)
public function integer interpret_xml (u_xml_document po_document, str_complete_context pstr_context, ref str_complete_context pstr_document_context)
public function integer set_patient_id (string ps_cpr_id, str_id_instance pstr_id)
public function string lookup_patient (string ps_id_domain, string ps_id_value, str_patient pstr_patient)
public function long find_treatment (str_treatment_description pstr_treatment, boolean pb_create_automatically, boolean pb_prompt_user, ref boolean pb_new_object)
public function long find_assessment (str_assessment_description pstr_assessment, boolean pb_create_automatically, boolean pb_prompt_user, ref boolean pb_new_object)
public function integer find_patient (ref str_patient pstr_patient, boolean pb_create_automatically, boolean pb_prompt_user, ref boolean pb_new_object)
public function long find_encounter (str_encounter_description pstr_encounter, boolean pb_create_automatically, boolean pb_prompt_user, boolean pb_checkin, ref boolean pb_new_object)
protected function string lookup_epro_id (long pl_owner_id, string ps_code_domain, string ps_code, string ps_description, string ps_epro_domain)
public subroutine log_mapping (long pl_code_id, boolean pb_success)
end prototypes

protected function integer xx_interpret_xml ();// Date Begun: ??/??/??
// Programmer: Mark Copenhaver (MC)
//
// Purpose: 
// Expects: 
//
// Returns: integer 									
// Limits:	
// History:

string lsa_attributes[]
string lsa_values[]
integer li_count
str_popup_return        popup_return
str_popup					popup
string ls_window_class
integer li_sts

If ole_class then
	li_sts = common_thread.get_adodb(adodb)
	if li_sts <= 0 then
		mylog.log(this, "xx_do_service()", "Unable to establish ADO Connection", 4)
		return -1
	end if
	
	li_count = get_attributes(lsa_attributes, lsa_values)
	return ole.do_service(adodb, xml.xml_string , li_count, lsa_attributes, lsa_values)
Else
	return 0
end if

end function

public function string get_childelement_gettext (pbdom_element puo_pbdom_element, string ps_element);string ls_return

If isvalid(puo_pbdom_element.GetChildElement(ps_element)) Then
	ls_return = puo_pbdom_element.GetChildElement(ps_element).GetText()
Else
	setnull (ls_return)
End If

Return ls_return
end function

public function integer interpret_xml (u_xml_document po_document, str_complete_context pstr_context, ref str_complete_context pstr_document_context);integer li_sts
integer li_please_wait
boolean lb_my_patient
string ls_null
datetime ldt_now
string ls_progress
long i

setnull(ls_null)

// Initialize instance variables
xml = po_document
my_context = pstr_context
document_context = f_empty_context()
if isnull(current_patient) then
	lb_my_patient = true
else
	lb_my_patient = false
end if

// reset the mapping counts
failed_mapping_count = 0
successful_mapping_count = 0

//li_please_wait = f_please_wait_open()

li_sts = xx_interpret_xml()

if li_sts <= 0 then
	ldt_now = datetime(today(), now())
	setnull(ls_progress)
	sqlca.sp_Set_Attachment_Progress(ls_null, &
												pstr_context.attachment_id, &
												pstr_context.service_id, &
												current_user.user_id, &
												ldt_now, &
												"Failed Posting", &
												ls_progress, &
												current_scribe.user_id)
	if not tf_check() then return -1
end if
//f_please_wait_close(li_please_wait)

// if we have an attachment context then lod the mappings
if pstr_context.attachment_id > 0 then
	// Successful Mappings
	ls_progress = ""
	for i = 1 to successful_mapping_count
		if len(ls_progress) > 0 then ls_progress += ","
		ls_progress += string(successful_mapping[i])
	next
	if len(ls_progress) > 0 then
		ldt_now = datetime(today(), now())
		sqlca.sp_Set_Attachment_Progress(ls_null, &
													pstr_context.attachment_id, &
													pstr_context.service_id, &
													current_user.user_id, &
													ldt_now, &
													"Successful Mappings", &
													ls_progress, &
													current_scribe.user_id)
		if not tf_check() then return -1
	end if
	
	// Failed Mappings
	ls_progress = ""
	for i = 1 to failed_mapping_count
		if len(ls_progress) > 0 then ls_progress += ","
		ls_progress += string(failed_mapping[i])
	next
	if len(ls_progress) > 0 then
		ldt_now = datetime(today(), now())
		sqlca.sp_Set_Attachment_Progress(ls_null, &
													pstr_context.attachment_id, &
													pstr_context.service_id, &
													current_user.user_id, &
													ldt_now, &
													"Failed Mappings", &
													ls_progress, &
													current_scribe.user_id)
		if not tf_check() then return -1
	else
		// Turn off the failed mappings
		UPDATE p_Attachment_Progress
		SET current_flag = 'N'
		WHERE attachment_id = :pstr_context.attachment_id
		AND progress_type = 'Failed Mappings'
		AND current_flag = 'Y';
		if not tf_check() then return -1
	end if
	
	if owner_id > 0 then
		UPDATE p_Attachment
		SET owner_id = :owner_id
		WHERE attachment_id = :pstr_context.attachment_id;
		if not tf_check() then return -1
	end if
		
end if

// Pass back context from the document
pstr_document_context = document_context

if lb_my_patient then f_clear_patient()

return li_sts

end function

public function integer set_patient_id (string ps_cpr_id, str_id_instance pstr_id);str_popup popup
str_popup_return popup_return
long ll_null
integer li_sts
string ls_progress_key
string ls_other_cpr_id
string ls_billing_id
string ls_last_name
string ls_first_name
string ls_message
integer li_count

setnull(ll_null)

if isnull(pstr_id.idvalue) or pstr_id.idvalue = "" then
	return 0
end if

if lower(pstr_id.iddomain) = "jmjbillingid" then
	if len(pstr_id.IDValue) > 0 then
		// See if this ID is already assigned to this patient
		SELECT billing_id
		INTO :ls_billing_id
		FROM p_Patient
		WHERE cpr_id = :ps_cpr_id;
		if not tf_check() then return -1
		if ls_billing_id = pstr_id.IDValue then return 1
		
		// If the patient already has a billing ID and it's not the same as the document
		// then DON'T CHANGE IT!!!
		if isnull(ls_billing_id) then
			li_sts = f_Set_Progress(ps_cpr_id, &
											"Patient", &
											ll_null, &
											"Modify", &
											"billing_id", &
											pstr_id.IDValue, &
											datetime(today(), now()), &
											ll_null, &
											ll_null, &
											ll_null )
			if li_sts < 0 then return -1
		end if
	end if
else
	ls_progress_key = string(pstr_id.owner_id) + "^" + pstr_id.iddomain
	
	// See if this ID is already assigned to this patient
	SELECT count(*)
	INTO :li_count
	FROM p_Patient_Progress
	WHERE cpr_id = :ps_cpr_id
	AND progress_type = 'ID'
	AND progress_key = :ls_progress_key
	AND progress_value = :pstr_id.idvalue
	AND current_flag = 'Y';
	if not tf_check() then return -1
	if li_count > 0 then return 1
	
	// It's not assigned to this patient, so see if it's assigned to any other patients
	SELECT min(cpr_id)
	INTO :ls_other_cpr_id
	FROM p_Patient_Progress
	WHERE progress_type = 'ID'
	AND progress_key = :ls_progress_key
	AND progress_value = :pstr_id.idvalue
	AND current_flag = 'Y'
	AND cpr_id <> :ps_cpr_id;
	if not tf_check() then return -1
	
	if len(ls_other_cpr_id) > 0 then
		SELECT billing_id, last_name, first_name
		INTO :ls_billing_id, :ls_last_name, :ls_first_name
		FROM p_Patient
		WHERE cpr_id = :ls_other_cpr_id;
		if not tf_check() then return -1
		
		ls_message = "The ID value is already assigned to another patient ("
		if len(ls_billing_id) > 0 then
			ls_message += ls_billing_id + ", "
		end if
	
		if len(ls_first_name) > 0 then
			ls_message += ls_first_name + " "
		end if
	
		if len(ls_last_name) > 0 then
			ls_message += ls_last_name
		end if
	
		ls_message += ")."
	
		log.log(this, "set_patient_id()", ls_message, 4)
		return -1
	end if
	
	li_sts = f_Set_Progress(ps_cpr_id, &
									"Patient", &
									ll_null, &
									"ID", &
									ls_progress_key, &
									pstr_id.IDValue, &
									datetime(today(), now()), &
									ll_null, &
									ll_null, &
									ll_null )
	if li_sts < 0 then return -1
end if

return 1


end function

public function string lookup_patient (string ps_id_domain, string ps_id_value, str_patient pstr_patient);string ls_cpr_id
string ls_last_name
string ls_first_name
datetime ldt_date_of_birth
string ls_null

setnull(ls_null)

ls_cpr_id = sqlca.fn_lookup_patient(ps_id_domain, ps_id_value)
if ls_cpr_id = "" then setnull(ls_cpr_id)
if len(ls_cpr_id) > 0 then
	SELECT last_name, first_name, date_of_birth
	INTO :ls_last_name, :ls_first_name, :ldt_date_of_birth
	FROM p_Patient
	WHERE cpr_id = :ls_cpr_id;
	if not tf_check() then return ls_null
	if sqlca.sqlcode = 100 then return ls_null
	
	// If we have name and dob data, then check them against the patient record
	if len(ls_last_name) > 0 and len(pstr_patient.last_name) > 0 then
		if upper(left(ls_last_name, 1)) <> upper(left(pstr_patient.last_name, 1)) then return ls_null
	end if
	if len(ls_first_name) > 0 and len(pstr_patient.first_name) > 0 then
		if upper(left(ls_first_name, 1)) <> upper(left(pstr_patient.first_name, 1)) then return ls_null
	end if
	if not isnull(ldt_date_of_birth) and not isnull(pstr_patient.date_of_birth) then
		if date(ldt_date_of_birth) <> date(pstr_patient.date_of_birth) then return ls_null
	end if
	
	return ls_cpr_id
end if

return ls_null

end function

public function long find_treatment (str_treatment_description pstr_treatment, boolean pb_create_automatically, boolean pb_prompt_user, ref boolean pb_new_object);string ls_progress_key
string ls_find
long ll_treatment_id
str_attachment_context lstr_attachment_context
long i
long j
string ls_id_domain
string ls_null
string ls_temp
str_c_xml_code_list lstr_codes
str_c_xml_code_list lstr_new_codes
str_treatment_description lstr_find_treatment
str_encounter_description lstr_encounter
str_encounter_description lstr_last_direct_encounter
string ls_date
integer li_sts
str_attributes lstr_object_ids
long ll_null
datetime ldt_null
string ls_id_value
string ls_epro_domain
long ll_last_encounter_id

setnull(ll_null)
setnull(ldt_null)
setnull(ls_null)
setnull(ll_treatment_id)

pb_new_object = false

// See if we can find the treatment from the xml data
if pstr_treatment.treatment_id > 0 then
	ll_treatment_id = sqlca.fn_lookup_treatment(current_patient.cpr_id, "jmj_treatment_id", string(pstr_treatment.treatment_id))
	if ll_treatment_id <= 0 then setnull(ll_treatment_id)
end if

// If we still haven't found the treatment, see if we can find the
// treatment from the list of foreign ids
for i = 1 to pstr_treatment.id_list.id_count
	if len(pstr_treatment.id_list.id[i].epro_domain) > 0 and len(pstr_treatment.id_list.id[i].epro_value) > 0 then
		if pstr_treatment.id_list.id[i].customer_id = sqlca.customer_id then
			ls_id_domain = pstr_treatment.id_list.id[i].epro_domain
			ls_id_value = pstr_treatment.id_list.id[i].epro_value
		else
			ls_id_domain = string(pstr_treatment.id_list.id[i].owner_id) + "^" + pstr_treatment.id_list.id[i].epro_domain
			ls_id_value = pstr_treatment.id_list.id[i].epro_value
		
			// save id for later adding the mapping
			f_attribute_add_attribute(lstr_object_ids, ls_id_domain, ls_id_value)
		end if
		
		ll_treatment_id = sqlca.fn_lookup_treatment(current_patient.cpr_id, ls_id_domain, ls_id_value)
		if ll_treatment_id > 0 then
			return ll_treatment_id
		else
			setnull(ll_treatment_id)
		end if
	end if
		
	if len(pstr_treatment.id_list.id[i].iddomain) > 0 and len(pstr_treatment.id_list.id[i].idvalue) > 0 then
		ls_epro_domain = lower(pstr_treatment.id_list.id[i].epro_domain)
		// Assume the epro domain is "treatment_id" if it is not specified
		if isnull(ls_epro_domain) or trim(ls_epro_domain) = "" then ls_epro_domain = "treatment_id"

		CHOOSE CASE ls_epro_domain
			CASE "treatment_id"
				ls_id_domain = string(pstr_treatment.id_list.id[i].owner_id) + "^" + pstr_treatment.id_list.id[i].iddomain
				ls_id_value = pstr_treatment.id_list.id[i].idvalue
				
				ll_treatment_id = sqlca.fn_lookup_treatment(current_patient.cpr_id, ls_id_domain, ls_id_value)
				if ll_treatment_id > 0 then
					return ll_treatment_id
				else
					setnull(ll_treatment_id)
				end if
				
				// save id for later adding the mapping
				f_attribute_add_attribute(lstr_object_ids, ls_id_domain, ls_id_value)
			CASE "observation_id", "drug_id", "procedure_id"
				// Reset the find_treatment structure
				lstr_find_treatment = pstr_treatment
				
				if len(pstr_treatment.id_list.id[i].epro_value) > 0 then
					CHOOSE CASE lower(pstr_treatment.id_list.id[i].epro_domain)
						CASE "observation_id"
							lstr_find_treatment.observation_id = pstr_treatment.id_list.id[i].epro_value
						CASE "drug_id"
							lstr_find_treatment.drug_id = pstr_treatment.id_list.id[i].epro_value
						CASE "procedure_id"
							lstr_find_treatment.procedure_id = pstr_treatment.id_list.id[i].epro_value
						CASE ELSE
					END CHOOSE
					
					// See if we can find the treatment from what we have now
					ll_treatment_id = current_patient.treatments.find_treatment(lstr_find_treatment)
					if ll_treatment_id > 0 then return ll_treatment_id
				else
					// Get every epro_id associated with this code
					lstr_codes = datalist.xml_get_epro_ids(pstr_treatment.id_list.id[i].owner_id, &
																		pstr_treatment.id_list.id[i].iddomain, &
																		ls_null, &
																		pstr_treatment.id_list.id[i].idvalue)
					
					// Now loop through the epro_ids and see if we can find a treatment with any of them
					for j = 1 to lstr_codes.code_count
						CHOOSE CASE lower(pstr_treatment.id_list.id[i].epro_domain)
							CASE "observation_id"
								lstr_find_treatment.observation_id = lstr_codes.code[j].epro_id
							CASE "drug_id"
								lstr_find_treatment.drug_id = lstr_codes.code[j].epro_id
							CASE "procedure_id"
								lstr_find_treatment.procedure_id = lstr_codes.code[j].epro_id
							CASE ELSE
						END CHOOSE
						
						// See if we can find the treatment from what we have now
						ll_treatment_id = current_patient.treatments.find_treatment(lstr_find_treatment)
						if ll_treatment_id > 0 then return ll_treatment_id
					next
				end if
				
				// Since we didn't find a mapping, add this code to the list to map later if the user picks a treatment
				lstr_new_codes.code_count += 1
				lstr_new_codes.code[lstr_new_codes.code_count].owner_id = pstr_treatment.id_list.id[i].owner_id
				lstr_new_codes.code[lstr_new_codes.code_count].code_domain = pstr_treatment.id_list.id[i].iddomain
				lstr_new_codes.code[lstr_new_codes.code_count].code = pstr_treatment.id_list.id[i].idvalue
				lstr_new_codes.code[lstr_new_codes.code_count].epro_domain = pstr_treatment.id_list.id[i].epro_domain
				setnull(lstr_new_codes.code[lstr_new_codes.code_count].epro_id)
		END CHOOSE
	end if

next

// If we have enough information and the caller wants to create the treatment
// automatically, then do it here

if not isnull(pstr_treatment.begin_date) &
  and not isnull(pstr_treatment.treatment_type) &
  and not isnull(pstr_treatment.treatment_description) &
  and pb_create_automatically then
	
	// First see if the treatment already exists
	ll_treatment_id = current_patient.treatments.find_treatment(pstr_treatment.treatment_type, pstr_treatment.begin_date, pstr_treatment.treatment_description)
	if ll_treatment_id > 0 then return ll_treatment_id
	
	// See if we need to assign an encounter
	if isnull(pstr_treatment.open_encounter_id) then
		// Get the last direct encounter
		li_sts = current_patient.encounters.last_encounter_of_mode("D", lstr_last_direct_encounter)
		if li_sts <> 1 OR date(lstr_last_direct_encounter.encounter_date) < relativedate(today(), -10) then
			// The last direct encounter didn't work out so just use the last encounter
			lstr_encounter = current_patient.encounters.last_encounter("1=1")
			if lstr_encounter.encounter_id > 0 then
				pstr_treatment.open_encounter_id = lstr_encounter.encounter_id
			else
				log.log(this, "find_treatment()", "Unable to find last encounter", 4)
				return -1
			end if
		else
			pstr_treatment.open_encounter_id = lstr_last_direct_encounter.encounter_id
		end if
	end if
	
	// Create a new treatment record
	ll_treatment_id = current_patient.treatments.new_treatment(pstr_treatment)
	if ll_treatment_id > 0 then
		// Add any ID mappings gathered
		for i = 1 to lstr_object_ids.attribute_count
			f_set_progress(current_patient.cpr_id, &
							"Treatment", &
							ll_treatment_id, &
							"ID", &
							lstr_object_ids.attribute[i].attribute, &
							lstr_object_ids.attribute[i].value, &
							ldt_null, &
							ll_null, &
							ll_null, &
							ll_null)
		next

		pb_new_object = true
		return ll_treatment_id
	end if
	
	log.log(this, "find_treatment()", "Error creating new treatment (" + pstr_treatment.treatment_description + ")", 4)
end if


// If we get here then we didn't find the treatment and we couldn't create
// the treatment.  See if the caller wants to prompt the user
if not pb_prompt_user or cpr_mode <> "CLIENT" then
	setnull(ll_treatment_id)
	return ll_treatment_id
end if

// Prompt the user to select or create the desired treatment
lstr_attachment_context = f_empty_attachment_context()

lstr_attachment_context.context_object = "Treatment"
lstr_attachment_context.context_object_type = pstr_treatment.treatment_type
lstr_attachment_context.description = pstr_treatment.treatment_description
lstr_attachment_context.begin_date = pstr_treatment.begin_date
lstr_attachment_context.user_id = pstr_treatment.ordered_by

if len(pstr_treatment.specimen_id) > 0 then
	f_attribute_add_attribute(lstr_attachment_context.object_attributes, "specimen_id", pstr_treatment.specimen_id)
end if
if len(pstr_treatment.ordered_by) > 0 then
	f_attribute_add_attribute(lstr_attachment_context.object_attributes, "ordered_by", pstr_treatment.ordered_by)
end if

openwithparm(w_post_attachment_to_object, lstr_attachment_context)
lstr_attachment_context = message.powerobjectparm
ll_treatment_id = lstr_attachment_context.object_key
pb_new_object = lstr_attachment_context.new_object

// If the user picked one, then let's update the code mappings
if ll_treatment_id > 0 then
	// Add any ID mappings gathered
	for i = 1 to lstr_object_ids.attribute_count
		f_set_progress(current_patient.cpr_id, &
						"Treatment", &
						ll_treatment_id, &
						"ID", &
						lstr_object_ids.attribute[i].attribute, &
						lstr_object_ids.attribute[i].value, &
						ldt_null, &
						ll_null, &
						ll_null, &
						ll_null)
	next

	for i = 1 to lstr_new_codes.code_count
		CHOOSE CASE lower(lstr_new_codes.code[i].epro_domain)
			CASE "observation_id"
				lstr_new_codes.code[i].epro_id = current_patient.treatments.treatment_observation_id(ll_treatment_id)
			CASE "drug_id"
				lstr_new_codes.code[i].epro_id = current_patient.treatments.treatment_drug_id(ll_treatment_id)
			CASE "procedure_id"
				lstr_new_codes.code[i].epro_id = current_patient.treatments.treatment_procedure_id(ll_treatment_id)
			CASE ELSE
		END CHOOSE
		if not isnull(lstr_new_codes.code[i].epro_id) then
			datalist.xml_add_mapping(lstr_new_codes.code[i])
		end if
	next
	
end if

return ll_treatment_id

end function

public function long find_assessment (str_assessment_description pstr_assessment, boolean pb_create_automatically, boolean pb_prompt_user, ref boolean pb_new_object);long ll_problem_id
str_attachment_context lstr_attachment_context
long i
long j
string ls_id_domain
string ls_null
string ls_temp
str_c_xml_code lstr_new_mapping
str_c_xml_code_list lstr_codes
str_assessment_description lstr_find_assessment
string ls_id_value
str_attributes lstr_object_ids
long ll_null
datetime ldt_null

setnull(ll_null)
setnull(ldt_null)
setnull(ls_null)
setnull(ll_problem_id)

pb_new_object = false

// See if we can find the assessment from the xml data
if pstr_assessment.problem_id > 0 then
	ll_problem_id = sqlca.fn_lookup_assessment(current_patient.cpr_id, "problem_id", string(pstr_assessment.problem_id))
	if ll_problem_id <= 0 then setnull(ll_problem_id)
end if

// If we still haven't found the assessment, see if we can find the
// assessment from the list of foreign ids
if isnull(ll_problem_id) then
	for i = 1 to pstr_assessment.id_list.id_count
		if len(pstr_assessment.id_list.id[i].epro_domain) > 0 and len(pstr_assessment.id_list.id[i].epro_value) > 0 then
			if pstr_assessment.id_list.id[i].owner_id = sqlca.customer_id then
				ls_id_domain = pstr_assessment.id_list.id[i].epro_domain
				ls_id_value = pstr_assessment.id_list.id[i].epro_value
			else
				ls_id_domain = string(pstr_assessment.id_list.id[i].owner_id) + "^" + pstr_assessment.id_list.id[i].epro_domain
				ls_id_value = pstr_assessment.id_list.id[i].epro_value
			
				// save id for later adding the mapping
				f_attribute_add_attribute(lstr_object_ids, ls_id_domain, ls_id_value)
			end if
			ll_problem_id = sqlca.fn_lookup_assessment(current_patient.cpr_id, ls_id_domain, ls_id_value)
			if ll_problem_id > 0 then return ll_problem_id
		end if
			
		if len(pstr_assessment.id_list.id[i].iddomain) > 0 and len(pstr_assessment.id_list.id[i].idvalue) > 0 then
			ls_id_domain = string(pstr_assessment.id_list.id[i].owner_id) + "^" + pstr_assessment.id_list.id[i].iddomain
			ls_id_value = pstr_assessment.id_list.id[i].idvalue
			ll_problem_id = sqlca.fn_lookup_assessment(current_patient.cpr_id, ls_id_domain, ls_id_value)
			if ll_problem_id > 0 then return ll_problem_id
			
			// save id for later adding the mapping
			f_attribute_add_attribute(lstr_object_ids, ls_id_domain, ls_id_value)
		end if
	next
end if

// If we still haven't found the assessment and we have a description and a begin_date, then look up using those
if isnull(ll_problem_id) and not isnull(pstr_assessment.begin_date) and len(pstr_assessment.assessment) > 0  then
	SELECT problem_id
	INTO :ll_problem_id
	FROM p_Assessment
	WHERE cpr_id = :current_patient.cpr_id
	AND begin_date = :pstr_assessment.begin_date
	AND assessment = :pstr_assessment.assessment
	AND current_flag = 'Y';
	if not tf_check() then return -1
	if ll_problem_id > 0 then return ll_problem_id
end if

// If we have enough information and the caller wants to create the assessment
// automatically, then do it here

if not isnull(pstr_assessment.begin_date) and len(pstr_assessment.assessment) > 0 and pb_create_automatically then
	ll_problem_id = current_patient.assessments.add_assessment(pstr_assessment)
	if ll_problem_id > 0 then
		// Add any ID mappings gathered
		for i = 1 to lstr_object_ids.attribute_count
			f_set_progress(current_patient.cpr_id, &
							"Assessment", &
							ll_problem_id, &
							"ID", &
							lstr_object_ids.attribute[i].attribute, &
							lstr_object_ids.attribute[i].value, &
							ldt_null, &
							ll_null, &
							ll_null, &
							ll_null)
		next

		pb_new_object = true
		return ll_problem_id
	end if
	
	log.log(this, "find_assessment()", "Error creating new assessment (" + pstr_assessment.assessment + ", " +  string(pstr_assessment.begin_date) + ")", 4)
end if


// If we get here then we didn't find the assessment and we couldn't create
// the assessment.  See if the caller wants to prompt the user
if not pb_prompt_user or cpr_mode <> "CLIENT" then
	setnull(ll_problem_id)
	return ll_problem_id
end if

// Prompt the user to select or create the desired assessment
lstr_attachment_context = f_empty_attachment_context()

lstr_attachment_context.context_object = "assessment"
lstr_attachment_context.context_object_type = pstr_assessment.assessment_type
lstr_attachment_context.description = pstr_assessment.assessment
lstr_attachment_context.begin_date = pstr_assessment.begin_date

openwithparm(w_post_attachment_to_object, lstr_attachment_context)
lstr_attachment_context = message.powerobjectparm
ll_problem_id = lstr_attachment_context.object_key
pb_new_object = lstr_attachment_context.new_object

// If the user picked one, then let's update the code mappings
if ll_problem_id > 0 then
	// Add any ID mappings gathered
	for i = 1 to lstr_object_ids.attribute_count
		f_set_progress(current_patient.cpr_id, &
						"Assessment", &
						ll_problem_id, &
						"ID", &
						lstr_object_ids.attribute[i].attribute, &
						lstr_object_ids.attribute[i].value, &
						ldt_null, &
						ll_null, &
						ll_null, &
						ll_null)
	next
end if

return ll_problem_id

end function

public function integer find_patient (ref str_patient pstr_patient, boolean pb_create_automatically, boolean pb_prompt_user, ref boolean pb_new_object);long ll_treatment_id
str_attachment_context lstr_attachment_context
long i
string ls_cpr_id
integer li_sts
string ls_id_domain
string ls_id_value
string ls_last_name
string ls_first_name
datetime ldt_date_of_birth
str_popup_return popup_return
boolean lb_map_ids
u_ds_data luo_data
long ll_count
str_attributes lstr_object_ids
long ll_null
datetime ldt_null
datetime ldt_patient_created
datetime ldt_now
string ls_temp

setnull(ll_null)
setnull(ldt_null)
setnull(ls_cpr_id)
lb_map_ids = true

pb_new_object = false

// See if we can find the patient from the cpr_id
if len(pstr_patient.cpr_id) > 0 then
	ls_cpr_id = sqlca.fn_lookup_patient("jmj_cpr_id", pstr_patient.cpr_id)
	if ls_cpr_id = "" then setnull(ls_cpr_id)
end if

// If we still haven't found the patient, see if we can find the
// patient from the list of foreign ids
if isnull(ls_cpr_id) then
	for i = 1 to pstr_patient.id_list.id_count
		if len(pstr_patient.id_list.id[i].epro_domain) > 0 and len(pstr_patient.id_list.id[i].epro_value) > 0 then
			if pstr_patient.id_list.id[i].customer_id = sqlca.customer_id then
				ls_id_domain = pstr_patient.id_list.id[i].epro_domain
				ls_id_value = pstr_patient.id_list.id[i].epro_value
			else
				ls_id_domain = string(pstr_patient.id_list.id[i].customer_id) + "^" + pstr_patient.id_list.id[i].epro_domain
				ls_id_value = pstr_patient.id_list.id[i].epro_value
			
				// save id for later adding the mapping
				f_attribute_add_attribute(lstr_object_ids, ls_id_domain, ls_id_value)
			end if
			ls_cpr_id = lookup_patient(ls_id_domain, ls_id_value, pstr_patient)
			if not isnull(ls_cpr_id) then exit
		end if
			
		if len(pstr_patient.id_list.id[i].iddomain) > 0 and len(pstr_patient.id_list.id[i].idvalue) > 0 then
			ls_id_domain = string(pstr_patient.id_list.id[i].owner_id) + "^" + pstr_patient.id_list.id[i].iddomain
			ls_id_value = pstr_patient.id_list.id[i].idvalue
			
			ls_cpr_id = lookup_patient(ls_id_domain, ls_id_value, pstr_patient)
			if not isnull(ls_cpr_id) then exit
			
			// save id for later adding the mapping
			f_attribute_add_attribute(lstr_object_ids, ls_id_domain, ls_id_value)
		end if
	next
end if

// If we still haven't found the patient, see if we can find the
// patient from the data
if isnull(ls_cpr_id) then
	luo_data = CREATE u_ds_data
	luo_data.set_dataobject("dw_jmj_find_patient")
	ll_count = luo_data.retrieve(	pstr_patient.billing_id , &
											pstr_patient.last_name , &
											pstr_patient.first_name , &
											pstr_patient.middle_name , &
											pstr_patient.sex , &
											datetime(pstr_patient.date_of_birth, time("")) , &
											pstr_patient.ssn , &
											pstr_patient.phone_number , &
											pstr_patient.address_line_1 , &
											pstr_patient.address_line_2 , &
											pstr_patient.state , &
											pstr_patient.zip , &
											pstr_patient.email_address , &
											pstr_patient.city )
	
	if ll_count = 1 then
		ls_cpr_id = luo_data.object.cpr_id[1]
	end if
end if

if not isnull(ls_cpr_id) then
	pstr_patient.cpr_id = ls_cpr_id
	if isnull(current_patient) then
		li_sts = f_set_patient(ls_cpr_id)
		if li_sts <= 0 then return -1
		
		current_patient.encounters.last_encounter()
		
		GOTO SUCCESS
	elseif current_patient.cpr_id = ls_cpr_id then
		GOTO SUCCESS
	else
		log.log(this, "find_treatment()", "The current patient does not match the patient found for this XML document.", 4)
		if pb_prompt_user then
			openwithparm(w_pop_message, "The current patient does not match the patient found for this XML document.  EncounterPRO is unable to process this XML document.")
		end if
		return -1
	end if
end if

// If we have enough information and the caller wants to create the patient
// automatically, then do it here

if not isnull(pstr_patient.last_name) &
  and not isnull(pstr_patient.first_name) &
  and pb_create_automatically then
	
	li_sts = f_new_patient(pstr_patient)
	if li_sts <= 0 then
		log.log(this, "find_treatment()", "Error creating new patient (" + pstr_patient.last_name + ", " + pstr_patient.first_name +")", 4)
		return -1
	end if

	li_sts = f_set_patient(pstr_patient.cpr_id)
	if li_sts <= 0 then
		log.log(this, "find_treatment()", "Error setting patient (" + pstr_patient.cpr_id + ")", 4)
		return -1
	end if

	// Add any ID mappings gathered
	for i = 1 to lstr_object_ids.attribute_count
		f_set_progress(current_patient.cpr_id, &
						"Patient", &
						ll_null, &
						"ID", &
						lstr_object_ids.attribute[i].attribute, &
						lstr_object_ids.attribute[i].value, &
						ldt_null, &
						ll_null, &
						ll_null, &
						ll_null)
	next
	
	pb_new_object = true
	
	GOTO SUCCESS
end if


// If we get here then we didn't find the patient and we couldn't create
// the patient.  See if the caller wants to prompt the user
if not pb_prompt_user or cpr_mode <> "CLIENT" then
	ls_temp = ""
	if not isnull(pstr_patient.last_name) then
		ls_temp = pstr_patient.last_name
	end if
	if not isnull(pstr_patient.first_name) then 
		ls_temp += ", " + pstr_patient.first_name
	end if
	
	log.log(this, "find_patient()", "Patient not found and auto-create not allowed (" + ls_temp + ")", 3)
	return 0
end if

// If we get here then we're going to ask the user to select or create a patient.
//f_clear_patient()
if isnull(current_patient) then
	openwithparm(w_patient_search, pstr_patient)
	ls_cpr_id = message.stringparm
	li_sts = f_set_patient(ls_cpr_id)
	if li_sts <= 0 then return -1
	
	// If this was just created then ask user if we should map the IDs
	SELECT DATEADD(second, 30, created)
	INTO :ldt_patient_created
	FROM p_Patient
	WHERE cpr_id = :ls_cpr_id;
	if not tf_check() then return -1
	
	ldt_now = datetime(today(), now())
	
	if ldt_patient_created > ldt_now then
		pb_new_object = true
	elseif pstr_patient.id_list.id_count > 0 then
		openwithparm(w_pop_yes_no, "This XML document has one or more patient identifiers.  Do you wish to map the identifiers in this document to the selected patient?  Select ~"No~" if you are not absolutely certain that this XML document is for the selected patient.")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then
			lb_map_ids = false
		end if
	end if

	current_patient.encounters.last_encounter()
else
	openwithparm(w_pop_yes_no, "Encounter could not find the patient referenced in this XML document.  Do you wish to process this XML document into the current patient?")
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return -1
	
	if pstr_patient.id_list.id_count > 0 then
		openwithparm(w_pop_yes_no, "This XML document has one or more patient identifiers.  Do you wish to map the identifiers in this document to the current patient?  Select ~"No~" if you are not absolutely certain that this XML document is for this patient.")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then
			lb_map_ids = false
		end if
	end if
		
end if

SUCCESS:

// Set the patient context for usage in this object
my_context.cpr_id = current_patient.cpr_id

// Set the patient context for usage by the caller
if isnull(document_context.cpr_id) or document_context.cpr_id = current_patient.cpr_id then
	document_context.cpr_id = current_patient.cpr_id
else
	// If the patient context doesn't match a previous patient context, then this
	// is a multi-patient document.  That means that for processing purposes,
	// it has no context
	document_context = f_empty_context()
end if

// Loop through the patient IDs and map them to this patient if they're not already mapped
if lb_map_ids then
	for i = 1 to pstr_patient.id_list.id_count
		li_sts = set_patient_id(my_context.cpr_id, pstr_patient.id_list.id[i])
	next
end if

return 1


end function

public function long find_encounter (str_encounter_description pstr_encounter, boolean pb_create_automatically, boolean pb_prompt_user, boolean pb_checkin, ref boolean pb_new_object);long ll_encounter_id
str_attachment_context lstr_attachment_context
long i
long j
string ls_id_domain
string ls_null
string ls_temp
str_c_xml_code lstr_new_mapping
str_c_xml_code_list lstr_codes
str_encounter_description lstr_find_encounter
str_encounter_description lstra_encounters[]
long ll_count
string ls_id_value
string ls_find
string ls_date
str_attributes lstr_object_ids
long ll_null
datetime ldt_null
boolean lb_workflow

setnull(ls_null)
setnull(ll_null)
setnull(ldt_null)
setnull(ll_encounter_id)

pb_new_object = false

// See if we can find the encounter from the xml data
if pstr_encounter.encounter_id > 0 then
	ll_encounter_id = sqlca.fn_lookup_encounter(current_patient.cpr_id, "encounter_id", string(pstr_encounter.encounter_id))
	if ll_encounter_id <= 0 then setnull(ll_encounter_id)
end if

// If we still haven't found the encounter, see if we can find the
// encounter from the list of foreign ids
if isnull(ll_encounter_id) then
	for i = 1 to pstr_encounter.id_list.id_count
		// See if the jmj domain/value is specified
		if len(pstr_encounter.id_list.id[i].epro_domain) > 0 and len(pstr_encounter.id_list.id[i].epro_value) > 0 then
			if pstr_encounter.id_list.id[i].owner_id = sqlca.customer_id then
				ls_id_domain = pstr_encounter.id_list.id[i].epro_domain
				ls_id_value = pstr_encounter.id_list.id[i].epro_value
			else
				ls_id_domain = string(pstr_encounter.id_list.id[i].owner_id) + "^" + pstr_encounter.id_list.id[i].epro_domain
				ls_id_value = pstr_encounter.id_list.id[i].epro_value
				
				// save id for later adding the mapping
				f_attribute_add_attribute(lstr_object_ids, ls_id_domain, ls_id_value)
			end if
			ll_encounter_id = sqlca.fn_lookup_encounter(current_patient.cpr_id, ls_id_domain, ls_id_value)
			if ll_encounter_id > 0 then return ll_encounter_id
		end if
		
		// See if we get a match from the foreign domain/value
		if len(pstr_encounter.id_list.id[i].iddomain) > 0 and len(pstr_encounter.id_list.id[i].idvalue) > 0 then
			ls_id_domain = string(pstr_encounter.id_list.id[i].owner_id) + "^" + pstr_encounter.id_list.id[i].iddomain
			ls_id_value = pstr_encounter.id_list.id[i].idvalue
			ll_encounter_id = sqlca.fn_lookup_encounter(current_patient.cpr_id, ls_id_domain, ls_id_value)
			if ll_encounter_id > 0 then return ll_encounter_id
			// save id for later adding the mapping
			f_attribute_add_attribute(lstr_object_ids, ls_id_domain, ls_id_value)
		end if
	next
end if

// If we still haven't found the encounter, see if we can find the
// encounter from the encounter data
if not isnull(pstr_encounter.encounter_date) and len(pstr_encounter.description) > 0 then
	ls_date = "datetime('" + string(pstr_encounter.encounter_date, "[shortdate] [time]") + "')"
	ls_find = "encounter_date=" + ls_date + " and description='" + f_string_substitute(pstr_encounter.description, "'", "~'") + "'"
	ll_count = current_patient.encounters.get_encounters(ls_find, lstra_encounters)
	if ll_count = 1 then
		// We found the encounter so return
		return lstra_encounters[1].encounter_id
	end if
end if

// If we have enough information and the caller wants to create the encounter
// automatically, then do it here

if not isnull(pstr_encounter.encounter_date) and pb_create_automatically then
	if isnull(pstr_encounter.encounter_type) then
		pstr_encounter.encounter_type = datalist.get_preference( "PREFERENCES", "default_encounter_type")
	end if
	if isnull(pstr_encounter.encounter_type) then
		log.log(this, "find_encounter()", "Unable to create new encounter because the message contains no Encounter Type and no default Encounter Type is set in Preferences.", 3)
	else
		if pb_checkin then
			lb_workflow = true
		else
			lb_workflow = false
		end if
		ll_encounter_id = current_patient.new_encounter(pstr_encounter, current_scribe.user_id, pb_checkin, lb_workflow)
		if ll_encounter_id > 0 then
			// Add any ID mappings gathered
			for i = 1 to lstr_object_ids.attribute_count
				f_set_progress(current_patient.cpr_id, &
								"Encounter", &
								ll_encounter_id, &
								"ID", &
								lstr_object_ids.attribute[i].attribute, &
								lstr_object_ids.attribute[i].value, &
								ldt_null, &
								ll_null, &
								ll_null, &
								ll_null)
			next
			
			pb_new_object = true
			return ll_encounter_id
		end if
		
		log.log(this, "find_encounter()", "Error creating new encounter (" + string(pstr_encounter.encounter_date) + ")", 4)
	end if
end if


// If we get here then we didn't find the encounter and we couldn't create
// the encounter.  See if the caller wants to prompt the user
if not pb_prompt_user or cpr_mode <> "CLIENT" then
	setnull(ll_encounter_id)
	return ll_encounter_id
end if

// Prompt the user to select or create the desired encounter
lstr_attachment_context = f_empty_attachment_context()

lstr_attachment_context.context_object = "encounter"
lstr_attachment_context.context_object_type = pstr_encounter.encounter_type
lstr_attachment_context.description = pstr_encounter.description
lstr_attachment_context.begin_date = pstr_encounter.encounter_date

openwithparm(w_post_attachment_to_object, lstr_attachment_context)
lstr_attachment_context = message.powerobjectparm
ll_encounter_id = lstr_attachment_context.object_key
pb_new_object = lstr_attachment_context.new_object

// If the user picked one, then let's update the code mappings
if ll_encounter_id > 0 then
	// Add any ID mappings gathered
	for i = 1 to lstr_object_ids.attribute_count
		f_set_progress(current_patient.cpr_id, &
						"Encounter", &
						ll_encounter_id, &
						"ID", &
						lstr_object_ids.attribute[i].attribute, &
						lstr_object_ids.attribute[i].value, &
						ldt_null, &
						ll_null, &
						ll_null, &
						ll_null)
	next
end if

return ll_encounter_id

end function

protected function string lookup_epro_id (long pl_owner_id, string ps_code_domain, string ps_code, string ps_description, string ps_epro_domain);string ls_epro_id
string ls_null
long ll_code_id

setnull(ls_null)

// Some of the old CCR code calls this method with a NULL ps_code because all it has is a description.  If that's the case then use the description as both the code and description.
if isnull(ps_code) and not isnull(ps_description) then
	ps_code = ps_description
end if

ll_code_id = sqlca.xml_lookup_epro_id(pl_owner_id, ps_code_domain, ls_null, ps_code, ps_description, ps_epro_domain, current_scribe.user_id, ls_epro_id)
if not tf_check() then return ls_null

if isnull(ll_code_id) or ll_code_id <= 0 then return ls_null

if len(ls_epro_id) > 0 then
	log_mapping(ll_code_id, true)
	return ls_epro_id
else
	// Failed mapping lookup, but ll_code_id contains the empty "Unmapped" record
	log_mapping(ll_code_id, false)
	return ls_null
end if


// If we get here then something went wrong
return ls_null

end function

public subroutine log_mapping (long pl_code_id, boolean pb_success);long i
boolean lb_found

lb_found = false
if pb_success then
	for i = 1 to successful_mapping_count
		if successful_mapping[i] = pl_code_id then
			lb_found = true
			exit
		end if
	next
	if not lb_found then
		successful_mapping_count += 1
		successful_mapping[successful_mapping_count] = pl_code_id
	end if
else
	for i = 1 to failed_mapping_count
		if failed_mapping[i] = pl_code_id then
			lb_found = true
			exit
		end if
	next
	if not lb_found then
		failed_mapping_count += 1
		failed_mapping[failed_mapping_count] = pl_code_id
	end if
end if


end subroutine

on u_component_xml_handler.create
call super::create
end on

on u_component_xml_handler.destroy
call super::destroy
end on

event constructor;call super::constructor;setnull(document_payload)

end event

