HA$PBExportHeader$u_soap_display.sru
forward
global type u_soap_display from u_dw_pick_list
end type
end forward

global type u_soap_display from u_dw_pick_list
integer width = 2327
integer height = 1220
string dataobject = "dw_soap_display"
boolean select_computed = false
boolean multiselect_ctrl = true
event key_down pbm_dwnkey
end type
global u_soap_display u_soap_display

type variables
string result_type = "PERFORM"
string abnormal_flag = "Y"
string display_mode
boolean new_data
boolean show_deleted = false

str_treatment_description  treatments[]
integer treatment_count

string treatment_service
string assessment_service
string encounter_service

long text_color_new
long back_color_services
long back_color_deleted = rgb(255, 196, 196)

str_assessment_description assessments[]
integer assessment_count

long max_result_length = 220

u_ds_data encounter_charges

string report_service
string sincelast_report_id
long sincelast_display_script_id

u_ds_observation_results treatment_results
boolean treatment_results_current


str_encounter_description encounter_context

u_ds_data encounter_services
u_ds_data encounter_documents

string load_assessment_type

// lets the caller overide the assessment type setting
string assessment_soap_display_rule


end variables

forward prototypes
public function boolean treatment_in_assessment (str_treatment_description pstr_treatment, long pl_problem_id)
public subroutine encounter_menu (long pl_row)
public function integer load_encounter ()
public subroutine treatment_menu (long pl_row)
public subroutine child_treatment_menu (long pl_row)
public subroutine assessment_menu (long pl_row)
public function integer load_encounter (string ps_display_mode, boolean pb_new_data)
public function integer load_patient (string ps_display_mode, string ps_assessment_type, string ps_assessment_status, string ps_treatment_type, string ps_treatment_status)
public function integer initialize ()
public function boolean has_new_treatments (long pl_problem_id, long pl_encounter_id)
public function integer load_treatment_list (string ps_find_string)
public function integer refresh_row (long pl_row)
public function string get_treatment_results (long pl_treatment_id, string ps_abnormal_flag)
private function integer check_encounter_context ()
private function integer refresh_treatment_row (long pl_row, str_encounter_description pstr_encounter, str_treatment_description pstr_treatment)
private function integer refresh_assessment_row (long pl_row, str_encounter_description pstr_encounter, str_assessment_description pstr_assessment)
private function integer load_treatment_items (long pl_parent_row)
private function integer load_treatment_items ()
private function integer load_assessments ()
private function integer load_assessments_and_treatments ()
private function integer load_objects (string ps_which)
public function boolean any_services (string ps_context_object, long pl_object_key)
public function integer load_patient (string ps_display_mode, string ps_assessment_type, string ps_assessment_status, string ps_assessment_soap_display_rule, string ps_treatment_type, string ps_treatment_status)
public function boolean any_assessment_treatments (long pl_problem_id)
public function boolean has_new_child_treatments (long pl_treatment_id, long pl_encounter_id)
end prototypes

public function boolean treatment_in_assessment (str_treatment_description pstr_treatment, long pl_problem_id);integer i

for i = 1 to pstr_treatment.problem_count
	if pstr_treatment.problem_ids[i] = pl_problem_id then return true
next

return false

end function

public subroutine encounter_menu (long pl_row);integer li_sts
string ls_null
string ls_context
string ls_key
long ll_object_key
string ls_object_type
long ll_menu_id
str_attributes lstr_attributes

setnull(ls_null)

ll_object_key = long(string(object.key[pl_row]))

li_sts = f_set_current_encounter(ll_object_key)
if li_sts <= 0 then return

SELECT dbo.fn_context_object_type('Encounter', :current_patient.cpr_id, :ll_object_key)
INTO :ls_object_type
FROM c_1_Record;
if not tf_check() then return

ll_menu_id = f_get_context_menu("SOAP_ENC_LN", ls_object_type)
if ll_menu_id > 0 then
	f_display_menu_with_attributes(ll_menu_id, true, lstr_attributes)
end if


//ls_context = "Encounter"
//
//ls_key = wordcap(ls_encounter_status)
//
//// Display the room-specific menu
//li_sts = f_display_context_menu(ls_context, ls_key)

return

end subroutine

public function integer load_encounter ();if isnull(display_mode) or trim(display_mode) = "" then
	return load_encounter("ATAT", new_data)
else
	return load_encounter(display_mode, new_data)
end if

end function

public subroutine treatment_menu (long pl_row);integer li_sts
str_attributes lstr_attributes
long ll_object_key
string ls_object_type
long ll_menu_id

lstr_attributes.attribute_count = 1
lstr_attributes.attribute[1].attribute = "treatment_id"
lstr_attributes.attribute[1].value = object.key[pl_row]

ll_object_key = long(string(object.key[pl_row]))

SELECT dbo.fn_context_object_type('Treatment', :current_patient.cpr_id, :ll_object_key)
INTO :ls_object_type
FROM c_1_Record;
if not tf_check() then return

ll_menu_id = f_get_context_menu("SOAP_TRT_LN", ls_object_type)
if ll_menu_id > 0 then
	f_display_menu_with_attributes(ll_menu_id, true, lstr_attributes)
end if

//service_list.do_service(current_patient.cpr_id, &
//								current_patient.open_encounter_id, &
//								treatment_service, &
//								lstr_attributes)
//

end subroutine

public subroutine child_treatment_menu (long pl_row);integer li_sts
str_attributes lstr_attributes

lstr_attributes.attribute_count = 1
lstr_attributes.attribute[1].attribute = "treatment_id"
lstr_attributes.attribute[1].value = object.key[pl_row]

service_list.do_service(current_patient.cpr_id, &
								current_patient.open_encounter_id, &
								treatment_service, &
								lstr_attributes)


end subroutine

public subroutine assessment_menu (long pl_row);string ls_key
string ls_problem_id
string ls_diagnosis_sequence
integer li_sts
str_attributes lstr_attributes
str_assessment_description lstr_assessment
str_assessment_description lstr_assessment_new
string ls_message
str_popup_return popup_return
long ll_object_key
string ls_object_type
long ll_menu_id

ls_key = object.key[pl_row]
f_split_string(ls_key, ",", ls_problem_id, ls_diagnosis_sequence)

li_sts = current_patient.assessments.assessment(lstr_assessment, long(ls_problem_id), integer(ls_diagnosis_sequence))
if li_sts <= 0 then
	log.log(this, "assessment_menu()", "Assessment not found (" + current_patient.cpr_id + ", " + ls_problem_id + ", " + ls_diagnosis_sequence + ")", 4)
	return
end if

li_sts = current_patient.assessments.assessment(lstr_assessment_new, long(ls_problem_id))
if li_sts <= 0 then
	log.log(this, "assessment_menu()", "Assessment not found (" + current_patient.cpr_id + ", " + ls_problem_id + ")", 4)
	return
end if

if upper(lstr_assessment.assessment_status) = "REDIAGNOSED" then
	ls_message = "The assessment you have selected (" + lstr_assessment.assessment + ") has been rediagnosed"
	ls_message += " and is thus no longer editable.  The current diagnosis is " + lstr_assessment_new.assessment + "."
	ls_message += "  Would you like to open the current diagnosis instead?"
	openwithparm(w_pop_yes_no, ls_message)
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return
end if

f_attribute_add_attribute(lstr_attributes, "problem_id", ls_problem_id)

if integer(ls_diagnosis_sequence) > 0 then
	f_attribute_add_attribute(lstr_attributes, "diagnosis_sequence", ls_diagnosis_sequence)
end if

ll_object_key = long(ls_problem_id)

SELECT dbo.fn_context_object_type('Assessment', :current_patient.cpr_id, :ll_object_key)
INTO :ls_object_type
FROM c_1_Record;
if not tf_check() then return

ll_menu_id = f_get_context_menu("SOAP_ASM_LN", ls_object_type)
if ll_menu_id > 0 then
	f_display_menu_with_attributes(ll_menu_id, true, lstr_attributes)
end if

//service_list.do_service(current_patient.cpr_id, &
//								current_patient.open_encounter_id, &
//								assessment_service, &
//								lstr_attributes)
//
//
end subroutine

public function integer load_encounter (string ps_display_mode, boolean pb_new_data);string ls_description
long ll_row
u_user luo_attending_doctor
integer li_sts
long ll_color
ulong ll_hCursor
long ll_charge_count
u_ds_data luo_data
long ll_count
long ll_rows

// Turn off the mouse pointer
setnull(ll_hCursor)
ll_hCursor = SetCursor(ll_hCursor)

display_mode = ps_display_mode
new_data = pb_new_data

li_sts = check_encounter_context()
if li_sts <= 0 then
	log.log(this, "load_encounter()", "Error checking encounter context", 4)
	return -1
end if

ll_charge_count = encounter_charges.retrieve(current_patient.cpr_id, encounter_context.encounter_id)

reset()
last_page = 0

treatment_count = current_patient.treatments.get_encounter_treatments(encounter_context.encounter_id, show_deleted, treatments)
treatment_results.set_dataobject("dw_sp_obstree_encounter_treatments")
ll_rows = treatment_results.retrieve(current_patient.cpr_id, encounter_context.encounter_id)


assessment_count = current_patient.assessments.get_encounter_assessments(encounter_context.encounter_id, show_deleted, assessments)

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_sp_get_objects_since_last_encounter")
ll_count = luo_data.retrieve(current_patient.cpr_id, encounter_context.encounter_id)
if ll_count > 0 then
	// Add the header for the past objects
	ll_row = insertrow(0)
	object.soap_type[ll_row] = "SINCELAST"
	object.description[ll_row] = "Items Added/Modified Since Last Encounter (" + string(ll_count) + ")"
	object.icon_bitmap[ll_row] = "button21.bmp"
	object.text_color[ll_row] = text_color_new
end if


last_page = 0

// If we're in display objects mode, then load the objects added/modified during this encounter
if display_mode = "OBJ" then
	// Add the header for the past objects
	ll_row = insertrow(0)
	object.soap_type[ll_row] = "DURING"
	object.description[ll_row] = "Items Added/Modified During This Encounter"
	object.icon_bitmap[ll_row] = "button21.bmp"
	
	// Load the objects since the last encounter
	li_sts = load_objects("DURING")
	if li_sts <= 0 then
		// If there weren't any, then delete the header
		deleterow(ll_row)
	end if
else
	li_sts = load_assessments_and_treatments()
end if

return li_sts


end function

public function integer load_patient (string ps_display_mode, string ps_assessment_type, string ps_assessment_status, string ps_treatment_type, string ps_treatment_status);string ls_null

setnull(ls_null)

return load_patient(ps_display_mode, &
							ps_assessment_type, &
							ps_assessment_status, &
							ls_null, &
							ps_treatment_type, &
							ps_treatment_status )



end function

public function integer initialize ();
object.attachment.x = width - 300

if isnull(assessment_service) or trim(assessment_service) = "" then assessment_service = "ASSESSMENT_REVIEW"
if isnull(treatment_service) or trim(treatment_service) = "" then treatment_service = "TREATMENT_REVIEW"
if isnull(encounter_service) or trim(encounter_service) = "" then encounter_service = "OBJECT_REVIEW"

if isnull(sincelast_report_id) or trim(sincelast_report_id) = "" then sincelast_report_id = "{4B657EFA-AB67-482B-9FAB-1764440DF116}"

if isnull(sincelast_display_script_id) or sincelast_display_script_id <= 0 then sincelast_display_script_id = long(datalist.get_preference("PREFERENCES", "default_sincelast_display_script_id"))

if isnull(report_service) or trim(report_service) = "" then report_service = "REPORT"

return 1

end function

public function boolean has_new_treatments (long pl_problem_id, long pl_encounter_id);integer i, j

// Loop through the treatments to find the new ones
for i = 1 to treatment_count
	if treatments[i].dispatch_encounter_id = pl_encounter_id then
		// If we find a new treatment then see if it's associated with the specified assessment
		for j = 1 to treatments[i].problem_count
			if treatments[i].problem_ids[j] = pl_problem_id then return true
		next
	end if
next

return false

end function

public function integer load_treatment_list (string ps_find_string);integer li_sts

display_mode = "TT"
new_data = false

li_sts = check_encounter_context()
if li_sts <= 0 then
	log.log(this, "load_treatment_list()", "Error checking encounter context", 4)
	return -1
end if

setredraw(false)

reset()

last_page = 0


treatment_count = current_patient.treatments.get_treatments(ps_find_string, treatments)
treatment_results.set_dataobject("dw_sp_obstree_treatment")

li_sts = load_treatment_items()

setredraw(true)

return li_sts


end function

public function integer refresh_row (long pl_row);string ls_soap_type
long ll_problem_id
integer li_diagnosis_sequence
long ll_treatment_id
str_assessment_description lstr_assessment
str_treatment_description lstr_treatment
integer li_sts
string ls_key
string ls_left
string ls_right

li_sts = check_encounter_context()
if li_sts <= 0 then
	log.log(this, "refresh_row()", "Error checking encounter context", 4)
	return -1
end if


ls_soap_type = object.soap_type[pl_row]
ls_key = object.key[pl_row]

CHOOSE CASE upper(ls_soap_type)
	CASE "ASSESSMENT"
		f_split_string(ls_key, ",", ls_left, ls_right)
		ll_problem_id = long(ls_left)
		li_diagnosis_sequence = integer(ls_right)
		if li_diagnosis_sequence <= 0 then setnull(li_diagnosis_sequence)
		li_sts = current_patient.assessments.assessment(lstr_assessment, ll_problem_id, li_diagnosis_sequence)
		if li_sts <= 0 then return 0
		return refresh_assessment_row(pl_row, encounter_context, lstr_assessment)
	CASE "TREATMENT", "TREATCHILD"
		ll_treatment_id = long(ls_key)
		li_sts = current_patient.treatments.treatment(lstr_treatment, ll_treatment_id)
		if li_sts <= 0 then return 0
		return refresh_treatment_row(pl_row, encounter_context, lstr_treatment)
END CHOOSE

return 1

end function

public function string get_treatment_results (long pl_treatment_id, string ps_abnormal_flag);long ll_count
string ls_results

setnull(ls_results)
if isnull(ps_abnormal_flag) then ps_abnormal_flag = "N"

// If the dataobject is "dw_sp_obstree_treatment" then we need to retrieve the datastore for each treatment
if treatment_results.dataobject = "dw_sp_obstree_treatment" then
	ll_count = treatment_results.retrieve(current_patient.cpr_id, pl_treatment_id)
end if

treatment_results.display_treatment_roots(pl_treatment_id, result_type, ps_abnormal_flag, ls_results)

return ls_results


end function

private function integer check_encounter_context ();integer li_sts

if isnull(current_display_encounter) then
	log.log(this, "check_encounter_context()", "Invalid current_display_encounter", 4)
	return -1
end if

// If we alreade have the encounter context, don't get it again
if isnull(encounter_context.encounter_id) or encounter_context.encounter_id <> current_display_encounter.encounter_id then
	li_sts = current_patient.encounters.encounter(encounter_context, current_display_encounter.encounter_id)
	if li_sts <= 0 then
		log.log(this, "check_encounter_context()", "Error getting encounter context", 4)
		return -1
	end if
end if

// Refresh the list of encounter services
li_sts = encounter_services.retrieve(current_patient.cpr_id, encounter_context.encounter_id, current_user.user_id)
if li_sts < 0 then return -1

// Refresh the list of encounter documents
li_sts = encounter_documents.retrieve("Encounter", current_patient.cpr_id, encounter_context.encounter_id)
if li_sts < 0 then return -1

return 1


end function

private function integer refresh_treatment_row (long pl_row, str_encounter_description pstr_encounter, str_treatment_description pstr_treatment);string ls_attachment_bitmap
string ls_progress
string ls_results
long ll_progress_type_count
str_progress_type lstra_progress_type[]
str_progress_list lstr_progress
long pt
long ll_encounter_progress_count
string ls_description
string ls_null
long j
string ls_soap_display_rule
long ll_text_color
long ll_charge_problem_id
long ll_charge_row
long ll_charges
string ls_bill_flag
string ls_find
long ll_back_color
long ll_documents
long ll_document_row
string ls_document_bitmap
string ls_document_status

setnull(ls_null)

setnull(ls_attachment_bitmap)
ls_progress = ""
ls_results = ""

if not pstr_treatment.access_control_list.default_grant then
	ls_progress = " <Confidential>"
end if

ls_description = f_treatment_full_description(pstr_treatment, pstr_encounter)

// Add the progress notes or indicators
ll_progress_type_count = datalist.progress_types_soap('Treatment', pstr_treatment.treatment_type, lstra_progress_type)
for pt = 1 to ll_progress_type_count
	CHOOSE CASE lower(lstra_progress_type[pt].soap_display_style)
		CASE "indicator"
			ll_encounter_progress_count = sqlca.fn_count_progress_in_encounter(current_patient.cpr_id, &
																									encounter_context.encounter_id, &
																									'Treatment', &
																									pstr_treatment.treatment_id, &
																									lstra_progress_type[pt].progress_type)
		
			if ll_encounter_progress_count > 0 then
				ls_description += " <" + lstra_progress_type[pt].progress_type + ">"
			end if
		CASE "indicator_any"
			ll_encounter_progress_count = sqlca.fn_count_progress_for_object(current_patient.cpr_id, &
																									'Treatment', &
																									pstr_treatment.treatment_id, &
																									lstra_progress_type[pt].progress_type)
		
			if ll_encounter_progress_count > 0 then
				ls_description += " <" + lstra_progress_type[pt].progress_type + ">"
			end if
		CASE "last"
			lstr_progress = f_get_progress(current_patient.cpr_id, &
													'Treatment', &
													pstr_treatment.treatment_id, &
													lstra_progress_type[pt].progress_type, &
													ls_null)
			if lstr_progress.progress_count > 0 then
				if ls_progress <> "" then ls_progress += "~r~n"
				ls_progress += "Last " + lstra_progress_type[pt].progress_type + ": "
				ls_progress += string(date(lstr_progress.progress[lstr_progress.progress_count].progress_date_time))
				ls_progress += " " + lstr_progress.progress[lstr_progress.progress_count].progress_full_description
			end if
		CASE "all"
			lstr_progress = f_get_progress_in_encounter(current_patient.cpr_id, &
													'Treatment', &
													pstr_treatment.treatment_id, &
													lstra_progress_type[pt].progress_type, &
													ls_null, &
													encounter_context.encounter_id)
			for j = 1 to lstr_progress.progress_count
				if ls_progress <> "" then ls_progress += "~r~n"
				ls_progress += string(date(lstr_progress.progress[j].progress_date_time))
				ls_progress += " " + lstr_progress.progress[j].progress_full_description
			next
		CASE "all_any"
			lstr_progress = f_get_progress(current_patient.cpr_id, &
													'Treatment', &
													pstr_treatment.treatment_id, &
													lstra_progress_type[pt].progress_type, &
													ls_null)
			for j = 1 to lstr_progress.progress_count
				if ls_progress <> "" then ls_progress += "~r~n"
				ls_progress += string(date(lstr_progress.progress[j].progress_date_time))
				ls_progress += " " + lstr_progress.progress[j].progress_full_description
			next
	END CHOOSE
next

ls_soap_display_rule = datalist.treatment_type_soap_display_rule( pstr_treatment.treatment_type)
CHOOSE CASE lower(ls_soap_display_rule)
	CASE "all results"
		ls_results = get_treatment_results(pstr_treatment.treatment_id, "N")
	CASE "abnormal results"
		ls_results = get_treatment_results(pstr_treatment.treatment_id, "Y")
	CASE ELSE
		setnull(ls_results)
END CHOOSE

if len(ls_results) > max_result_length then
	ls_results = left(ls_results, max_result_length) + " ..."
end if

if ls_progress <> "" then
	if isnull(ls_results) or trim(ls_results) = "" then
		ls_results = ls_progress
	else
		ls_results += "~r~n" + ls_progress
	end if
end if

// If the treatment was created during the displayed encounter, change it's text color
if pstr_treatment.dispatch_encounter_id = pstr_encounter.encounter_id then
	ll_text_color = text_color_new
else
	ll_text_color = rgb(0,0,0)
end if

// If the assessment has outstanding services, change the back color
if lower(pstr_treatment.treatment_status) = 'cancelled' then
	ll_back_color = back_color_deleted
elseif any_services("treatment", pstr_treatment.treatment_id) then
	ll_back_color = back_color_services
else
	ll_back_color = 0
end if

// See if there is a charge for this treatment in this encounter
ll_charges = encounter_charges.rowcount()
ls_find = "treatment_id=" + string(pstr_treatment.treatment_id)
ll_charge_row = encounter_charges.find(ls_find, 1, ll_charges)
if ll_charge_row > 0 then
	ls_bill_flag = encounter_charges.object.bill_flag[ll_charge_row]
	if upper(ls_bill_flag) = "Y" then
		ls_attachment_bitmap = "icon_in_service.bmp"
	else
		ls_attachment_bitmap = "icon_out_service.bmp"
	end if
else
	setnull(ls_attachment_bitmap)
end if

// See if there is a document for this treatment in this encounter
ll_documents = encounter_documents.rowcount()
ls_find = "lower(document_context_object)='treatment' and document_object_key=" + string(pstr_treatment.treatment_id)
ll_document_row = encounter_documents.find(ls_find + " and lower(status) IN ('ordered', 'created')", 1, ll_documents)
if ll_document_row > 0 then
	// Unsent documents exist
	ls_document_bitmap = "icon_docs_pending.bmp"
else
	ll_document_row = encounter_documents.find(ls_find, 1, ll_documents)
	if ll_document_row > 0 then
		// Sent documents exist
		ls_document_bitmap = "icon_docs_ok.bmp"
	else
		// No documents exist
		setnull(ls_document_bitmap)
	end if
end if


object.description[pl_row] = left(ls_description, 4000)
object.text_color[pl_row] = ll_text_color
object.color[pl_row] = ll_back_color
object.results[pl_row] = left(ls_results, 8000)
object.icon_bitmap[pl_row] = datalist.treatment_type_icon(pstr_treatment.treatment_type)
object.attachment_bitmap[pl_row] = ls_attachment_bitmap
object.document_bitmap[pl_row] = ls_document_bitmap

return 1


end function

private function integer refresh_assessment_row (long pl_row, str_encounter_description pstr_encounter, str_assessment_description pstr_assessment);integer li_sts
integer li_treatment_count
string ls_description
long ll_total_progress_count
long ll_encounter_progress_count
long ll_text_color
long ll_back_color
long ll_icd_part_count

sqlca.sp_assessment_progress_status(current_patient.cpr_id, &
												encounter_context.encounter_id, &
												pstr_assessment.problem_id, &
												ll_total_progress_count, &
												ll_encounter_progress_count)
if not tf_check() then return -1

ls_description = f_assessment_description(pstr_assessment)
ls_description = f_string_substitute(ls_description, "~t", " ")

if ll_encounter_progress_count > 0 then
	ls_description += " <Prg Note>"
end if

if not pstr_assessment.access_control_list.default_grant then
	ls_description += " <Confidential>"
end if

// If the assessment was created during the displayed encounter, change it's text color
if pstr_assessment.open_encounter_id = pstr_encounter.encounter_id then
	ll_text_color = text_color_new
else
	ll_text_color = rgb(0,0,0)
end if

// If the assessment has outstanding services, change the back color
if lower(pstr_assessment.assessment_status) = 'cancelled' then
	ll_back_color = back_color_deleted
elseif any_services("assessment", pstr_assessment.problem_id) then
	ll_back_color = back_color_services
else
	ll_back_color = 0
end if

if upper(left(pstr_assessment.icd9_code, 1)) <> "V" then
	ll_icd_part_count = current_patient.assessments.icd_part_count(pstr_assessment.icd9_code)
	if ll_icd_part_count > 1 then
		ls_description += " (" + string(ll_icd_part_count) + "x)"
	end if
end if

object.description[pl_row] = ls_description
object.text_color[pl_row] = ll_text_color
object.color[pl_row] = ll_back_color
object.icon_bitmap[pl_row] = current_patient.assessments.assessment_bitmap(pstr_assessment)

return 1


end function

private function integer load_treatment_items (long pl_parent_row);Long 		ll_row
long ll_parent_treatment_id
Integer 	li_sts
Integer	i, j, k
long ll_problem_id
long ll_trt_problem_id
long ll_assm_problem_id
integer li_diagnosis_sequence
string ls_left
string ls_right
string ls_temp
string ls_description
string ls_attachment_bitmap
string ls_key
string ls_soap_type
string ls_null
string ls_soap_display_rule
string ls_treatment_type_status
boolean lb_found

setnull(ls_null)

setnull(ll_parent_treatment_id)

if isnull(pl_parent_row) then
	setnull(ls_soap_type)
else
	ls_soap_type = object.soap_type[pl_parent_row]
end if

CHOOSE CASE display_mode
	CASE "ATAT"
		if isnull(ls_soap_type) then
			setnull(ll_problem_id)
		elseif ls_soap_type = "TREATMENT" then
			setnull(ll_problem_id)
			ls_temp = object.key[pl_parent_row]
			if isnull(ls_temp) then
				log.log(this, "load_treatment_items()", "Null treatment_id", 4)
				return -1
			else
				ll_parent_treatment_id = long(ls_temp)
			end if
		elseif ls_soap_type = "ASSESSMENT" then
			ls_temp = object.key[pl_parent_row]
			if isnull(ls_temp) then
				log.log(this, "load_treatment_items()", "Null assessment key", 4)
				return -1
			end if
			
			f_split_string(ls_temp, ",", ls_left, ls_right)
			if ls_left = "" then
				log.log(this, "load_treatment_items()", "Invalid assessment key (" + ls_temp + ")", 4)
				return -1
			end if
			
			ll_problem_id = long(ls_left)
			if ls_right = "" then
				setnull(li_diagnosis_sequence)
			else
				li_diagnosis_sequence = integer(ls_right)
			end if
			
			// Don't show treatments for rediagnosed assessments.  The treatments will show under the new assessment
			if current_patient.assessments.is_rediagnosed(ll_problem_id, li_diagnosis_sequence) then return 1
		else
			return 0
		end if
	CASE "AATT", "TT"
		setnull(ll_problem_id)
		if ls_soap_type = "TREATMENT" then
			ls_temp = object.key[pl_parent_row]
			if isnull(ls_temp) then
				log.log(this, "load_treatment_items()", "Null treatment_id", 4)
				return -1
			else
				ll_parent_treatment_id = long(ls_temp)
			end if
		end if
	CASE ELSE
		return 0
END CHOOSE


for i = 1 to treatment_count
	ls_treatment_type_status = datalist.treatment_type_field(treatments[i].treatment_type, "status")
	if upper(ls_treatment_type_status) <> "OK" then continue

	// Make sure we want to display this assessment
	if new_data and not (encounter_context.encounter_id = treatments[i].dispatch_encounter_id) then
		if not has_new_child_treatments(treatments[i].treatment_id, encounter_context.encounter_id) then continue
	end if

	// If we're under an assessment, then don't show treatment unless it's part of the assessment
	if not isnull(ll_problem_id) then
		if not treatment_in_assessment(treatments[i], ll_problem_id) then continue
	end if

	if isnull(ll_parent_treatment_id) then
		// If we're not working under a parent, then suppress child treatments
		if treatments[i].parent_treatment_id > 0 then continue
		
		// Don't show in_office treatments unless they're ordered in this encounter
		if f_flag_to_bool(datalist.treatment_type_in_office_flag(treatments[i].treatment_type)) then
			if treatments[i].open_encounter_id <> encounter_context.encounter_id then continue
		end if
	else
		// If we're working under a parent treatment, then we only want to show treatments that are children of that parent
		if ll_parent_treatment_id <> treatments[i].parent_treatment_id or isnull(treatments[i].parent_treatment_id) then continue
	end if

	// If we're under the encounter, then only show treatments which aren't under any assessments that are displayed in this encounter
	if isnull(pl_parent_row) and display_mode = "ATAT" then
		lb_found = false
		for j = 1 to treatments[i].problem_count
			ll_trt_problem_id = treatments[i].problem_ids[j]
			for k = 1 to assessment_count
				ll_assm_problem_id = assessments[k].problem_id
				
				// If we found this treatment under an assessment in this encounter, then skip it for now because it will display when the assessment displays
				if ll_trt_problem_id = ll_assm_problem_id then
					lb_found = true
					exit
				end if
			next
			if lb_found then exit
		next
		if lb_found then continue
	end if
	
	ll_row = insertrow(0)
	object.display_mode[ll_row] = display_mode
	if ls_soap_type = "TREATMENT" then 
		object.soap_type[ll_row] = "TREATCHILD" 
	else
		object.soap_type[ll_row] = "TREATMENT"
	end if
	
	object.key[ll_row] = string(treatments[i].treatment_id)
	refresh_treatment_row(ll_row, encounter_context, treatments[i])

	ls_soap_display_rule = datalist.treatment_type_soap_display_rule(treatments[i].treatment_type)

	if lower(ls_soap_display_rule) = "show children" then
		li_sts = load_treatment_items(ll_row)
	end if
next

return 1


end function

private function integer load_treatment_items ();Long 		ll_parent_row

setnull(ll_parent_row)

return load_treatment_items(ll_parent_row)

end function

private function integer load_assessments ();integer i
string ls_date
string ls_find
integer li_sts
long ll_row
integer li_treatment_count
string ls_description
long ll_total_progress_count
long ll_encounter_progress_count
long ll_text_color
string ls_soap_display_rule

for i = 1 to assessment_count
	// Make sure we want to display this assessment
	if new_data and not (encounter_context.encounter_id = assessments[i].open_encounter_id) then
		// Make sure the assessment doesn't have any new treatments before skipping it.
		if not has_new_treatments(assessments[i].problem_id, encounter_context.encounter_id) then continue
	end if

	if isnull(assessment_soap_display_rule) then
		// If we're specifically loading this assessment type, then the soap display rule is "display always"
		if load_assessment_type = assessments[i].assessment_type then
			ls_soap_display_rule = "display always"
		else
			ls_soap_display_rule = datalist.assessment_type_property(assessments[i].assessment_type, "soap_display_rule")
		end if
	else
		ls_soap_display_rule = assessment_soap_display_rule
	end if
	
	CHOOSE CASE lower(ls_soap_display_rule)
		CASE "display never"
			continue
		CASE "display if treatments"
			if not any_assessment_treatments(assessments[i].problem_id) then continue
	END CHOOSE
	

	ll_row = insertrow(0)
	object.display_mode[ll_row] = display_mode
	object.soap_type[ll_row] = "ASSESSMENT"
	object.key[ll_row] = string(assessments[i].problem_id) + "," + string(assessments[i].diagnosis_sequence)
	
	refresh_assessment_row(ll_row, encounter_context, assessments[i])
	
	if display_mode = "ATAT" then
		li_sts = load_treatment_items(ll_row)
	end if
next


return 1


end function

private function integer load_assessments_and_treatments ();string ls_description
long ll_row
u_user luo_attending_doctor
integer li_sts
long ll_color
long ll_rowcount

// If we need to show treatments above the assessments...
if display_mode = "ATAT" then
	// record how many rows we already have
	ll_rowcount = rowcount()
	
	// Add the treatments with no assessments
	li_sts = load_treatment_items()
	if li_sts < 0 then
		log.log(this, "load_encounter()", "Error loading stand-alone treatments", 4)
		return -1
	end if
	
	// If we added any treatments with no assessments, then add a header for them
	if rowcount() > ll_rowcount then
		ll_row = insertrow(ll_rowcount + 1)
		object.display_mode[ll_row] = display_mode
		object.soap_type[ll_row] = "NOASSESSMENT"
		ls_description = datalist.get_preference("PREFERENCES", "Standalone Treatment Heading", "Treatments With No Assessment")
		object.description[ll_row] = ls_description
		object.icon_bitmap[ll_row] = "icon018.bmp"
	end if
end if

// If we're just showing treatments the load them
if display_mode = "TT" then
	// record how many rows we already have
	ll_rowcount = rowcount()
	
	// Then load the treatment items
	li_sts = load_treatment_items()
	if li_sts < 0 then
		log.log(this, "load_encounter()", "Error loading treatments", 4)
		return -1
	end if
	
	// If we added any treatments, then add a header for them
	if rowcount() > ll_rowcount then
		ll_row = insertrow(ll_rowcount + 1)
		object.display_mode[ll_row] = display_mode
		object.soap_type[ll_row] = "Treatments"
		object.description[ll_row] = "Treatments"
		object.icon_bitmap[ll_row] = "icon012.bmp"
	end if
end if

// If we're loading assessments only or assessments followed by treatments, then add the header and load the assessments
if display_mode = "AA" or display_mode = "AATT" then
	ll_row = insertrow(0)
	object.display_mode[ll_row] = display_mode
	object.soap_type[ll_row] = "Assessments"
	object.description[ll_row] = "Assessments"
	object.icon_bitmap[ll_row] = "icon018.bmp"
	li_sts = load_assessments()
end if

// If we're loading assessments interleaved with treatments, then add the header and load the assessments
if display_mode = "ATAT" then
	ll_row = insertrow(0)
	object.display_mode[ll_row] = display_mode
	object.soap_type[ll_row] = "Assessments"
	object.description[ll_row] = "Assessments and Treatments"
	object.icon_bitmap[ll_row] = "icon018.bmp"
	li_sts = load_assessments()
end if


// If we need to show treatments after the assessments, then load them
if display_mode = "AATT" then
	ll_row = insertrow(0)
	object.display_mode[ll_row] = display_mode
	object.soap_type[ll_row] = "Treatments"
	object.description[ll_row] = "Treatments"
	object.icon_bitmap[ll_row] = "icon012.bmp"

	li_sts = load_treatment_items()
	if li_sts < 0 then
		log.log(this, "load_encounter()", "Error loading treatments after assessments", 4)
		return -1
	end if
	
	if ll_row = rowcount() then deleterow(ll_row)
end if

return li_sts


end function

private function integer load_objects (string ps_which);u_ds_data luo_data
long ll_count
long ll_row
long i
string ls_description
string ls_progress_type
datetime ldt_progress_created
string ls_context_object
string ls_object_type
long ll_object_key
long ll_attachment_id
string ls_current_flag
string ls_attachment_extension
integer li_sts


luo_data = CREATE u_ds_data
if upper(ps_which) = "DURING" then
	luo_data.set_dataobject("dw_sp_get_objects_during_encounter")
else
	luo_data.set_dataobject("dw_sp_get_objects_since_last_encounter")
end if
ll_count = luo_data.retrieve(current_patient.cpr_id, encounter_context.encounter_id)

if ll_count > 0 then
	for i = 1 to ll_count
		ls_context_object = luo_data.object.context_object[i]
		ll_object_key = luo_data.object.object_key[i]
		ls_object_type = luo_data.object.object_type[i]
		ll_attachment_id = luo_data.object.progress_attachment_id[i]
		ls_current_flag = luo_data.object.progress_current_flag[i]
		
		ll_row = insertrow(0)
//		object.display_mode[ll_row] = display_mode
		object.soap_type[ll_row] = upper(ls_context_object)
		if not isnull(ll_attachment_id) then
			ls_attachment_extension = luo_data.object.attachment_extension[i]
			if isnull(ls_attachment_extension) then ls_attachment_extension = "bmp"
			object.attachment_bitmap[ll_row] = datalist.extension_button(ls_attachment_extension)
			object.attachment_id[ll_row] = ll_attachment_id
		end if
		object.key[ll_row] = string(ll_object_key)
		
		ls_description = luo_data.object.description[i]
		ls_progress_type = luo_data.object.progress_type[i]
		ldt_progress_created = luo_data.object.progress_created[i]
		ls_description = string(date(ldt_progress_created)) + "  " + ls_description + " (" + wordcap(lower(ls_progress_type)) + ")"
		
		object.description[ll_row] = ls_description
		object.text_color[ll_row] = text_color_new
		object.icon_bitmap[ll_row] = datalist.object_icon(ls_context_object, ls_object_type)
	next
end if


return 1


end function

public function boolean any_services (string ps_context_object, long pl_object_key);
string ls_find
long ll_row

ls_find = "lower(workplan_type)='" + lower(ps_context_object) + "' and "

CHOOSE CASE lower(ps_context_object)
	CASE "assessment"
		ls_find += "problem_id=" + string(pl_object_key)
	CASE "encounter"
		ls_find += "encounter_id=" + string(pl_object_key)
	CASE "treatment"
		ls_find += "treatment_id=" + string(pl_object_key)
	CASE ELSE
		return false
END CHOOSE

ll_row = encounter_services.find(ls_find, 1, encounter_services.rowcount())
if ll_row > 0 then return true

return false



end function

public function integer load_patient (string ps_display_mode, string ps_assessment_type, string ps_assessment_status, string ps_assessment_soap_display_rule, string ps_treatment_type, string ps_treatment_status);string ls_description
long ll_row
u_user luo_attending_doctor
integer li_sts
long ll_color
string ls_find
long ll_rows

display_mode = ps_display_mode
assessment_soap_display_rule = ps_assessment_soap_display_rule
load_assessment_type = ps_assessment_type
new_data = false

li_sts = check_encounter_context()
if li_sts <= 0 then
	log.log(this, "load_patient()", "Error checking encounter context", 4)
	return -1
end if

setredraw(false)

reset()

last_page = 0

// Get the specified treatments
if isnull(ps_treatment_type) or upper(ps_treatment_type) = "ALL" then
	ls_find = "(1=1)"
else
	ls_find = "upper(treatment_type)='" + upper(ps_treatment_type) + "'"
end if

if upper(ps_treatment_status) = "OPEN" then
	ls_find += " and isnull(end_date)"
elseif upper(ps_treatment_status) = "CLOSED" then
	ls_find += " and not isnull(end_date)"
end if

treatment_count = current_patient.treatments.get_treatments(ls_find, treatments)
treatment_results.set_dataobject("dw_sp_obstree_treatment")


// Get the specified assessments
if isnull(ps_assessment_type) or upper(ps_assessment_type) = "ALL" then
	ls_find = "(1=1)"
else
	ls_find = "upper(assessment_type)='" + upper(ps_assessment_type) + "'"
end if

if upper(ps_assessment_status) = "OPEN" then
	ls_find += " and isnull(end_date)"
elseif upper(ps_assessment_status) = "CLOSED" then
	ls_find += " and not isnull(end_date)"
end if

assessment_count = current_patient.assessments.get_assessments(ls_find, assessments)

li_sts = load_assessments_and_treatments()

setredraw(true)

return li_sts


end function

public function boolean any_assessment_treatments (long pl_problem_id);long i, j

for i = 1 to treatment_count
	for j = 1 to treatments[i].problem_count
		if treatments[i].problem_ids[j] = pl_problem_id then return true
	next
next

return false

end function

public function boolean has_new_child_treatments (long pl_treatment_id, long pl_encounter_id);integer i, j

// Loop through the treatments to find the new ones
for i = 1 to treatment_count
	if treatments[i].dispatch_encounter_id = pl_encounter_id and treatments[i].parent_treatment_id = pl_treatment_id then return true
next

return false

end function

on u_soap_display.create
call super::create
end on

on u_soap_display.destroy
call super::destroy
end on

event selected;call super::selected;string ls_soap_type
long ll_attachment_id
str_attributes lstr_attributes

if keydown(KeyControl!) then
	return
end if

ls_soap_type = object.soap_type[selected_row]
ll_attachment_id = object.attachment_id[selected_row]

CHOOSE CASE ls_soap_type
	CASE "SINCELAST"
		f_attribute_add_attribute(lstr_attributes, "report_id", sincelast_report_id)
		f_attribute_add_attribute(lstr_attributes, "display_script_id", string(sincelast_display_script_id))
		f_attribute_add_attribute(lstr_attributes, "destination", "SCREEN")
		
		service_list.do_service(current_patient.cpr_id, current_patient.open_encounter_id, report_service, lstr_attributes)
	CASE "PATIENT"
		if not isnull(ll_attachment_id) then f_display_attachment(ll_attachment_id)
	CASE "ENCOUNTER"
		if not isnull(ll_attachment_id) then
			f_display_attachment(ll_attachment_id)
		else
			encounter_menu(selected_row)
		end if
	CASE "ASSESSMENT"
		assessment_menu(selected_row)
	CASE "TREATMENT"
		treatment_menu(selected_row)
	CASE "TREATCHILD"
		child_treatment_menu(selected_row)
	CASE "NOASSESSMENT"
		return
	CASE "TREATHEADER"
		return
	CASE ELSE
		return
END CHOOSE

clear_selected()


end event

event computed_clicked;call super::computed_clicked;string ls_soap_type
long ll_menu_id
str_attributes lstr_attributes
string ls_problem_id
string ls_diagnosis_sequence
string ls_key
long ll_attachment_id
string ls_menu_context
string ls_object_type
string ls_context_object
long ll_object_key

ls_key = object.key[clicked_row]
ls_soap_type = object.soap_type[clicked_row]
ll_attachment_id = object.attachment_id[clicked_row]

if lastcolumnname = "attachment" then
	if isnull(ll_attachment_id) then
		// Edit the billing for this object
	else
		f_display_attachment(ll_attachment_id)
	end if
elseif lastcolumnname = "compute_documents" then
	if isnumber(ls_key) then
		ll_object_key = long(ls_key)
		f_manage_documents("Treatment", current_patient.cpr_id, ll_object_key)
	end if
else
	CHOOSE CASE upper(ls_soap_type)
		CASE "PATIENT"
			ls_menu_context = "SOAP_PAT_ICN"
			ls_context_object = "Patient"
			setnull(ll_object_key)
		CASE "ENCOUNTER"
			ls_menu_context = "SOAP_ENC_ICN"
			ls_context_object = "Encounter"
			f_attribute_add_attribute(lstr_attributes, &
											"encounter_id", &
											string(encounter_context.encounter_id))
			ll_object_key = long(ls_key)
		CASE "ASSESSMENT"
			ls_menu_context = "SOAP_ASM_ICN"
			ls_context_object = "Assessment"
			f_split_string(ls_key, ",", ls_problem_id, ls_diagnosis_sequence)
			f_attribute_add_attribute(lstr_attributes, &
											"problem_id", &
											ls_problem_id)
			ll_object_key = long(ls_problem_id)
		CASE "TREATMENT"
			ls_menu_context = "SOAP_TRT_ICN"
			ls_context_object = "Treatment"
			f_attribute_add_attribute(lstr_attributes, &
											"treatment_id", &
											ls_key)
			ll_object_key = long(ls_key)
		CASE "TREATCHILD"
			ls_menu_context = "SOAP_TRT_ICN"
			ls_context_object = "Treatment"
			f_attribute_add_attribute(lstr_attributes, &
											"treatment_id", &
											ls_key)
			ll_object_key = long(ls_key)
		CASE "NOASSESSMENT"
			return
		CASE "TREATHEADER"
			return
		CASE ELSE
			return
	END CHOOSE
	
	SELECT dbo.fn_context_object_type(:ls_context_object, :current_patient.cpr_id, :ll_object_key)
	INTO :ls_object_type
	FROM c_1_Record;
	if not tf_check() then return
	
	ll_menu_id = f_get_context_menu(ls_menu_context, ls_object_type)
	if ll_menu_id > 0 then
		f_display_menu_with_attributes(ll_menu_id, true, lstr_attributes)
	end if
	
	setredraw(false)
	refresh_row(clicked_row)
	setredraw(true)
end if



end event

event destructor;call super::destructor;if isvalid(encounter_charges) then DESTROY encounter_charges

end event

event constructor;call super::constructor;encounter_charges = CREATE u_ds_data
encounter_charges.set_dataobject("dw_sp_get_encounter_charged_treatments")

treatment_results = CREATE u_ds_observation_results

encounter_services = CREATE u_ds_data
encounter_services.set_dataobject("dw_sp_get_encounter_user_services")

encounter_documents = CREATE u_ds_data
encounter_documents.set_dataobject("dw_jmj_get_documents")

end event

