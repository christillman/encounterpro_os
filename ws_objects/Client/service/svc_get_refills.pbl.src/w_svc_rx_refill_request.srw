$PBExportHeader$w_svc_rx_refill_request.srw
forward
global type w_svc_rx_refill_request from w_window_base
end type
type cb_be_back from commandbutton within w_svc_rx_refill_request
end type
type cb_done from commandbutton within w_svc_rx_refill_request
end type
type st_resolution_title from statictext within w_svc_rx_refill_request
end type
type st_denied from statictext within w_svc_rx_refill_request
end type
type st_modify_rx from statictext within w_svc_rx_refill_request
end type
type st_refill_history_title from statictext within w_svc_rx_refill_request
end type
type st_refill_comment_title from statictext within w_svc_rx_refill_request
end type
type cb_pick_comment from commandbutton within w_svc_rx_refill_request
end type
type cb_view_chart from commandbutton within w_svc_rx_refill_request
end type
type st_ordered_rx_title from statictext within w_svc_rx_refill_request
end type
type mle_ordered_medication from multilineedit within w_svc_rx_refill_request
end type
type st_change_med from statictext within w_svc_rx_refill_request
end type
type sle_refill_comment from singlelineedit within w_svc_rx_refill_request
end type
type st_refill_comment_required from statictext within w_svc_rx_refill_request
end type
type st_checking_contraindications from statictext within w_svc_rx_refill_request
end type
type st_refills_requested_title from statictext within w_svc_rx_refill_request
end type
type st_refills_requested from statictext within w_svc_rx_refill_request
end type
type st_refills_authorized_title from statictext within w_svc_rx_refill_request
end type
type st_refills_authorized from statictext within w_svc_rx_refill_request
end type
type st_refills_authorized_required from statictext within w_svc_rx_refill_request
end type
type st_refill_response_required from statictext within w_svc_rx_refill_request
end type
type gb_additional_refills from groupbox within w_svc_rx_refill_request
end type
type mle_refill_request from multilineedit within w_svc_rx_refill_request
end type
type st_2 from statictext within w_svc_rx_refill_request
end type
type st_title from statictext within w_svc_rx_refill_request
end type
type st_requested_by_title from statictext within w_svc_rx_refill_request
end type
type st_requested_by from statictext within w_svc_rx_refill_request
end type
type st_requested_date_time_title from statictext within w_svc_rx_refill_request
end type
type st_requested_date_time from statictext within w_svc_rx_refill_request
end type
type st_requester_note_title from statictext within w_svc_rx_refill_request
end type
type st_requester_note from statictext within w_svc_rx_refill_request
end type
type st_scheduled_warning from statictext within w_svc_rx_refill_request
end type
type st_approved from statictext within w_svc_rx_refill_request
end type
type ole_refill_history from u_rich_text_edit within w_svc_rx_refill_request
end type
end forward

global type w_svc_rx_refill_request from w_window_base
string title = "Retry Posting"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
string button_type = "COMMAND"
boolean auto_resize_objects = false
cb_be_back cb_be_back
cb_done cb_done
st_resolution_title st_resolution_title
st_denied st_denied
st_modify_rx st_modify_rx
st_refill_history_title st_refill_history_title
st_refill_comment_title st_refill_comment_title
cb_pick_comment cb_pick_comment
cb_view_chart cb_view_chart
st_ordered_rx_title st_ordered_rx_title
mle_ordered_medication mle_ordered_medication
st_change_med st_change_med
sle_refill_comment sle_refill_comment
st_refill_comment_required st_refill_comment_required
st_checking_contraindications st_checking_contraindications
st_refills_requested_title st_refills_requested_title
st_refills_requested st_refills_requested
st_refills_authorized_title st_refills_authorized_title
st_refills_authorized st_refills_authorized
st_refills_authorized_required st_refills_authorized_required
st_refill_response_required st_refill_response_required
gb_additional_refills gb_additional_refills
mle_refill_request mle_refill_request
st_2 st_2
st_title st_title
st_requested_by_title st_requested_by_title
st_requested_by st_requested_by
st_requested_date_time_title st_requested_date_time_title
st_requested_date_time st_requested_date_time
st_requester_note_title st_requester_note_title
st_requester_note st_requester_note
st_scheduled_warning st_scheduled_warning
st_approved st_approved
ole_refill_history ole_refill_history
end type
global w_svc_rx_refill_request w_svc_rx_refill_request

type variables
u_component_service service

str_treatment_description ordered_treatment
str_treatment_description refill_treatment

string refill_response

date refill_date

string refill_progress_type

string signature_service

integer refills_authorized

boolean refill_approver_comment_changed = false

boolean refills_authorized_changed = false

string rx_reference_number_property

string response_report_service
string response_report_id

string response_message_service

string new_rx_report_service
string new_rx_report_id
long new_rx_treatment_id

string refill_note_progress_key
string refill_note_progress_key2

string denial_code_domain_id
string denial_reason_code
string denial_reason_text

// List of progress_keys to copy from refreq
long copy_property_key_count
string copy_property_keys[]

str_drug_definition drug

boolean controlled_substance
boolean local_request

end variables

forward prototypes
public function integer check_contraindications ()
public function integer refresh ()
public function integer modify_parent_med ()
public function integer change_parent_med ()
public function integer send_response ()
public function integer manage_documents (long pl_treatment_id)
public function integer order_rx_document (long pl_treatment_id)
public function integer send_new_treatment (long pl_treatment_id)
end prototypes

public function integer check_contraindications ();integer li_sts
string ls_assessment_id
str_attributes lstr_attributes
st_checking_contraindications.visible = true

ls_assessment_id = service.treatment.assessment.assessment_id

lstr_attributes = service.get_attributes()

li_sts = f_check_contraindications(service.cpr_id, ls_assessment_id, service.treatment.treatment_type, service.treatment.treatment_key, service.treatment.treatment_description, lstr_attributes)


st_checking_contraindications.visible = false


return li_sts


end function

public function integer refresh ();string ls_progress_key
integer li_sts
str_attributes lstr_attributes
integer li_default_refills_authorized
string ls_temp
long ll_null

setnull(ll_null)

mle_refill_request.text = refill_treatment.treatment_description
ls_temp = f_get_patient_property_value(service.cpr_id, &
													refill_treatment.treatment_id, &
													"Treatment", &
													"LastFillDate", &
													lstr_attributes)
if len(ls_temp) > 0 then
	mle_refill_request.text += "~r~nLast Fill Date: " + ls_temp
end if

controlled_substance = false
st_approved.visible = true
mle_ordered_medication.text = ordered_treatment.treatment_description
if not isnull(ordered_treatment.treatment_status) and lower(ordered_treatment.treatment_status) <> "open" then
	mle_ordered_medication.text += "~r~n" + wordcap(ordered_treatment.treatment_status)
end if
if f_string_to_boolean(drug.controlled_substance_flag) then
	ls_temp = "Controlled Substance"
	if not isnull(drug.dea_schedule) and upper(drug.dea_schedule) <> "NA" then
		ls_temp += " Schedule " + drug.dea_schedule
	end if
	mle_ordered_medication.text += "~r~n" + ls_temp
	controlled_substance = true
	st_approved.text = "Approved**"
	st_scheduled_warning.visible = true
else
	st_approved.text = "Approved"
	st_scheduled_warning.visible = false
end if

st_requested_by.text = user_list.user_full_name(refill_treatment.ordered_by)
st_requested_date_time.text = string(refill_treatment.begin_date)
st_requester_note.text = f_get_patient_property_value(service.cpr_id, &
																		refill_treatment.treatment_id, &
																		"Treatment", &
																		refill_note_progress_key, &
																		lstr_attributes)
if isnull(st_requester_note.text) then
	// Try the internal refill request noe
	st_requester_note.text = f_get_patient_property_value(service.cpr_id, &
																			refill_treatment.treatment_id, &
																			"Treatment", &
																			refill_note_progress_key2, &
																			lstr_attributes)
end if

if refill_treatment.refills > 0 then
	st_refills_requested.text = string(refill_treatment.refills)
	st_refills_authorized_required.visible = false
	li_default_refills_authorized = refill_treatment.refills
elseif refill_treatment.refills = -1 then
	// -1 is the special code for "PRN"
	st_refills_requested.text = "PRN"
	st_refills_authorized_required.visible = false
	li_default_refills_authorized = 0
else
	st_refills_requested.text = "N/A"
	st_refills_authorized_required.visible = false
	li_default_refills_authorized = 0
end if

ls_temp = f_get_patient_property_value(service.cpr_id, &
													refill_treatment.treatment_id, &
													"Treatment", &
													"Refills Authorized", &
													lstr_attributes)
if isnull(ls_temp) or not isnumber(ls_temp) then
	refills_authorized = li_default_refills_authorized
	refills_authorized_changed = true
else
	refills_authorized = integer(ls_temp)
end if

st_refills_authorized.text = string(refills_authorized)

st_refill_comment_required.visible = false
sle_refill_comment.text = f_get_patient_property_value(service.cpr_id, &
																		refill_treatment.treatment_id, &
																		"Treatment", &
																		"Refill Approver Comment", &
																		lstr_attributes)

setnull(ls_progress_key)

ole_refill_history.initialize()
li_sts = ole_refill_history.display_progress("Treatment", service.treatment.treatment_id, refill_progress_type, ls_progress_key, "Dates", false, ll_null)
if li_sts <= 0 then
	ole_refill_history.add_text("No Previous Refills")
end if



return 1



end function

public function integer modify_parent_med ();str_service_info lstr_service
str_treatment_description lstr_med
integer li_sts

lstr_service.service = "EDIT_MEDICATION"
f_attribute_add_attribute(lstr_service.attributes, "treatment_id", string(ordered_treatment.treatment_id))

service_list.do_service(lstr_service)


// Check to see if ordered med was modified
li_sts = current_patient.treatments.treatment(lstr_med, ordered_treatment.treatment_id)
if li_sts <= 0 then 
	log.log(this, "modify_parent_med()", "Error finding modified treatment (" + string(ordered_treatment.treatment_id) + ")", 4)
	return -1
end if



if lower(lstr_med.treatment_status) = "modified" then
	// Lookup new treatment_id
	SELECT max(treatment_id)
	INTO :new_rx_treatment_id
	FROM p_Treatment_Item
	WHERE cpr_id = :service.cpr_id
	AND original_treatment_id = :ordered_treatment.treatment_id;
	if not tf_check() then return -1
	if isnull(new_rx_treatment_id) then
		log.log(this, "modify_parent_med()", "Error finding new treatment (" + string(ordered_treatment.treatment_id) + ")", 4)
		return -1
	end if

	return 1
end if

return 0

end function

public function integer change_parent_med ();str_service_info lstr_service
str_treatment_description lstr_med
String	ls_treatment_type
long ll_null
datetime ldt_null
integer i
string lsa_attributes[]
string lsa_values[]
integer li_sts
long ll_list_sequence
string ls_defined_flag
string ls_description
str_attributes lstr_order_attributes
str_attributes lstr_pre_attributes
str_attributes lstr_trt_attributes
u_component_treatment	luo_treatment
long ll_treatment_id
str_popup_return popup_return
string ls_ref_number
str_attributes lstr_attributes

setnull(ldt_null)
Setnull(ll_null)

ls_treatment_type = "MEDICATION"

// Add right now as out begin_date
f_attribute_add_attribute(lstr_pre_attributes, "begin_date", string(datetime(today(), now())))

luo_treatment = f_get_treatment_component(ls_treatment_type)
If Isnull(luo_treatment) Then
	log.log(this, "order_treatment()", "Unable to get treatment component (" + ls_treatment_type + ")", 4)
	return -1
end if

luo_treatment.define_treatment()
if luo_treatment.treatment_count <= 0 then return 0
for i = 1 to luo_treatment.treatment_count
	// Reinitialize to the pre-defined attributes
	lstr_order_attributes = lstr_pre_attributes
	
	// Get the attributes for this new treatment
	lstr_trt_attributes = f_attribute_arrays_to_str(luo_treatment.treatment_definition[i].attribute_count, &
															luo_treatment.treatment_definition[i].attribute, &
															luo_treatment.treatment_definition[i].value)
	
	// Add the treatment attributes to the predefined attributes
	f_attribute_add_attributes(lstr_order_attributes, lstr_trt_attributes)
	
	ll_treatment_id = current_patient.treatments.order_treatment(current_patient.cpr_id, &
																					current_patient.open_encounter_id, &
																					ls_treatment_type, &
																					luo_treatment.treatment_definition[i].item_description, &
																					ll_null, &
																					false, &
																					current_user.user_id, &
																					ll_null, &
																					lstr_order_attributes)
	if ll_treatment_id <= 0 then return -1

	f_set_patient_property(service.cpr_id, &
								"Treatment", &
								ll_treatment_id, &
								"changed_from_treatment_id", &
								string(refill_treatment.treatment_id) )

	f_set_patient_property(service.cpr_id, &
								"Treatment", &
								refill_treatment.treatment_id, &
								"changed_to_treatment_id", &
								string(ll_treatment_id) )
next

openwithparm(w_pop_yes_no, "Do you wish to close the existing medication - " + ordered_treatment.treatment_description + "?")
popup_return = message.powerobjectparm
if popup_return.item = "YES" then
	lstr_service.service = "CLOSE_TREAT"
	f_attribute_add_attribute(lstr_service.attributes, "treatment_id", string(ordered_treatment.treatment_id))
	
	service_list.do_service(lstr_service)
end if

new_rx_treatment_id = ll_treatment_id

Return 1


end function

public function integer send_response ();str_service_info lstr_service
integer li_sts
string ls_description
integer li_step_number
str_attributes lstr_attributes
string ls_message

if local_request then
	lstr_attributes = f_get_context_attributes()
	f_attribute_add_attribute(lstr_attributes, "context_object", "Treatment")
	if new_rx_treatment_id > 0 then
		f_attribute_add_attribute(lstr_attributes, "treatment_id", string(new_rx_treatment_id))
	else
		f_attribute_add_attribute(lstr_attributes, "treatment_id", string(ordered_treatment.treatment_id))
	end if

	ls_description = UPPER(refill_response) + " " + refill_treatment.Treatment_description
	setnull(li_step_number)
	
	ls_message = ""
	if lower(refill_response) = "denied" and len(denial_reason_code) > 0 and len(denial_reason_text) > 0 then
		ls_message = denial_reason_text
	end if
	if len(sle_refill_comment.text) > 0 then
		if len(ls_message) > 0 then ls_message += "; "
		ls_message += sle_refill_comment.text
	end if
	
	if len(ls_message) > 0 then
		f_attribute_add_attribute(lstr_attributes, "message", sle_refill_comment.text)
	end if
	
	li_sts = service_list.order_service(service.cpr_id, &
												service.encounter_id, &
												response_message_service, &
												refill_treatment.ordered_by, &
												ls_description, &
												li_step_number, &
												lstr_attributes)
	if li_sts <= 0 then return -1
else
	lstr_service.service = response_report_service
	f_attribute_add_attribute(lstr_service.attributes, "treatment_id", string(refill_treatment.treatment_id))
	f_attribute_add_attribute(lstr_service.attributes, "report_id", response_report_id)
	f_attribute_add_attribute(lstr_service.attributes, "ordered_for", refill_treatment.ordered_by)
	f_attribute_add_attribute(lstr_service.attributes, "send_now", "True")
	f_attribute_add_attribute(lstr_service.attributes, "Purpose", "Refill Response")
	f_attribute_add_attribute(lstr_service.attributes, "Refill Response", refill_response)
	f_attribute_add_attribute(lstr_service.attributes, "Manage Document", "Order Document")
	
	li_sts = service_list.do_service(lstr_service)
end if

return 1

end function

public function integer manage_documents (long pl_treatment_id);str_service_info lstr_service
integer li_sts


lstr_service.service = "Manage Documents"
f_attribute_add_attribute(lstr_service.attributes, "context_object", "Treatment")
f_attribute_add_attribute(lstr_service.attributes, "treatment_id", string(pl_treatment_id))

li_sts = service_list.do_service(lstr_service)


return li_sts

end function

public function integer order_rx_document (long pl_treatment_id);str_service_info lstr_service
integer li_sts

if isnull(pl_treatment_id) or pl_treatment_id <= 0 then
	log.log(this, "order_rx_document()", "No treatment for newrx message", 4)
	return -1
end if

lstr_service.service = new_rx_report_service
f_attribute_add_attribute(lstr_service.attributes, "treatment_id", string(pl_treatment_id))
f_attribute_add_attribute(lstr_service.attributes, "report_id", new_rx_report_id)
f_attribute_add_attribute(lstr_service.attributes, "Purpose", "NEWRX")
f_attribute_add_attribute(lstr_service.attributes, "Manage Document", "Order Document")

service_list.do_service(lstr_service)


return 1

end function

public function integer send_new_treatment (long pl_treatment_id);str_service_info lstr_service
integer li_sts
long ll_patient_workplan_item_id
u_component_wp_item_document luo_document
string ls_controlled_substance_flag
string ls_document_route
string ls_purpose

if isnull(pl_treatment_id) or pl_treatment_id <= 0 then
	log.log(this, "send_new_treatment()", "No treatment for newrx message", 4)
	return -1
end if

// Set the desired purpose to "NewRX"
ls_purpose = "NewRX"

// First see if the drug is controlled
SELECT d.controlled_substance_flag
INTO :ls_controlled_substance_flag
FROM p_Treatment_Item t
	INNER JOIN c_Drug_Definition d
	ON t.drug_id = d.drug_id
WHERE t.cpr_id = :service.cpr_id
AND t.treatment_id = :pl_treatment_id;
if not tf_check() then return -1

if f_string_to_boolean(ls_controlled_substance_flag) then
	openwithparm(w_pop_message, "The new medication will not be automatically sent because it is a controlled substance")
	return 0
end if

// Then see if the document for this treatment is already queued up
SELECT max(i.patient_workplan_item_id)
INTO :ll_patient_workplan_item_id
FROM p_Patient_WP_Item i
	INNER JOIN p_Patient_WP_Item_attribute a
	ON i.patient_workplan_item_id = a.patient_workplan_item_id
WHERE i.cpr_id = :service.cpr_id
AND i.treatment_id = :pl_treatment_id
AND i.item_type = 'Document'
AND i.status = 'Ordered'
AND a.attribute = 'Purpose'
AND a.value = :ls_purpose;
if not tf_check() then return -1



if ll_patient_workplan_item_id > 0 then
	luo_document = CREATE u_component_wp_item_document
	
	li_sts = luo_document.initialize(ll_patient_workplan_item_id)
	if li_sts < 0 then return -1

	// If the document hasn't been sent yet, send it now
	if lower(luo_document.status) = "ordered" then
		// Make sure it's going to whoever sent us the refill request
		if isnull(luo_document.ordered_for) or lower(luo_document.ordered_for) <> lower(refill_treatment.ordered_by) then
			luo_document.document_set_recipient(refill_treatment.ordered_by)
		end if
		
		// Send it
		li_sts = luo_document.document_send()
		if li_sts < 0 then return -1
	end if
	
	DESTROY luo_document
	return 1
end if

// If we get here then we didn't find a pre-ordered document to send.  So order one now...
lstr_service.service = new_rx_report_service
f_attribute_add_attribute(lstr_service.attributes, "treatment_id", string(pl_treatment_id))
f_attribute_add_attribute(lstr_service.attributes, "ordered_for", refill_treatment.ordered_by)
f_attribute_add_attribute(lstr_service.attributes, "send_now", "True")
f_attribute_add_attribute(lstr_service.attributes, "Purpose", ls_purpose)
f_attribute_add_attribute(lstr_service.attributes, "Manage Document", "Order Document")


service_list.do_service(lstr_service)

return 1

end function

on w_svc_rx_refill_request.create
int iCurrent
call super::create
this.cb_be_back=create cb_be_back
this.cb_done=create cb_done
this.st_resolution_title=create st_resolution_title
this.st_denied=create st_denied
this.st_modify_rx=create st_modify_rx
this.st_refill_history_title=create st_refill_history_title
this.st_refill_comment_title=create st_refill_comment_title
this.cb_pick_comment=create cb_pick_comment
this.cb_view_chart=create cb_view_chart
this.st_ordered_rx_title=create st_ordered_rx_title
this.mle_ordered_medication=create mle_ordered_medication
this.st_change_med=create st_change_med
this.sle_refill_comment=create sle_refill_comment
this.st_refill_comment_required=create st_refill_comment_required
this.st_checking_contraindications=create st_checking_contraindications
this.st_refills_requested_title=create st_refills_requested_title
this.st_refills_requested=create st_refills_requested
this.st_refills_authorized_title=create st_refills_authorized_title
this.st_refills_authorized=create st_refills_authorized
this.st_refills_authorized_required=create st_refills_authorized_required
this.st_refill_response_required=create st_refill_response_required
this.gb_additional_refills=create gb_additional_refills
this.mle_refill_request=create mle_refill_request
this.st_2=create st_2
this.st_title=create st_title
this.st_requested_by_title=create st_requested_by_title
this.st_requested_by=create st_requested_by
this.st_requested_date_time_title=create st_requested_date_time_title
this.st_requested_date_time=create st_requested_date_time
this.st_requester_note_title=create st_requester_note_title
this.st_requester_note=create st_requester_note
this.st_scheduled_warning=create st_scheduled_warning
this.st_approved=create st_approved
this.ole_refill_history=create ole_refill_history
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_be_back
this.Control[iCurrent+2]=this.cb_done
this.Control[iCurrent+3]=this.st_resolution_title
this.Control[iCurrent+4]=this.st_denied
this.Control[iCurrent+5]=this.st_modify_rx
this.Control[iCurrent+6]=this.st_refill_history_title
this.Control[iCurrent+7]=this.st_refill_comment_title
this.Control[iCurrent+8]=this.cb_pick_comment
this.Control[iCurrent+9]=this.cb_view_chart
this.Control[iCurrent+10]=this.st_ordered_rx_title
this.Control[iCurrent+11]=this.mle_ordered_medication
this.Control[iCurrent+12]=this.st_change_med
this.Control[iCurrent+13]=this.sle_refill_comment
this.Control[iCurrent+14]=this.st_refill_comment_required
this.Control[iCurrent+15]=this.st_checking_contraindications
this.Control[iCurrent+16]=this.st_refills_requested_title
this.Control[iCurrent+17]=this.st_refills_requested
this.Control[iCurrent+18]=this.st_refills_authorized_title
this.Control[iCurrent+19]=this.st_refills_authorized
this.Control[iCurrent+20]=this.st_refills_authorized_required
this.Control[iCurrent+21]=this.st_refill_response_required
this.Control[iCurrent+22]=this.gb_additional_refills
this.Control[iCurrent+23]=this.mle_refill_request
this.Control[iCurrent+24]=this.st_2
this.Control[iCurrent+25]=this.st_title
this.Control[iCurrent+26]=this.st_requested_by_title
this.Control[iCurrent+27]=this.st_requested_by
this.Control[iCurrent+28]=this.st_requested_date_time_title
this.Control[iCurrent+29]=this.st_requested_date_time
this.Control[iCurrent+30]=this.st_requester_note_title
this.Control[iCurrent+31]=this.st_requester_note
this.Control[iCurrent+32]=this.st_scheduled_warning
this.Control[iCurrent+33]=this.st_approved
this.Control[iCurrent+34]=this.ole_refill_history
end on

on w_svc_rx_refill_request.destroy
call super::destroy
destroy(this.cb_be_back)
destroy(this.cb_done)
destroy(this.st_resolution_title)
destroy(this.st_denied)
destroy(this.st_modify_rx)
destroy(this.st_refill_history_title)
destroy(this.st_refill_comment_title)
destroy(this.cb_pick_comment)
destroy(this.cb_view_chart)
destroy(this.st_ordered_rx_title)
destroy(this.mle_ordered_medication)
destroy(this.st_change_med)
destroy(this.sle_refill_comment)
destroy(this.st_refill_comment_required)
destroy(this.st_checking_contraindications)
destroy(this.st_refills_requested_title)
destroy(this.st_refills_requested)
destroy(this.st_refills_authorized_title)
destroy(this.st_refills_authorized)
destroy(this.st_refills_authorized_required)
destroy(this.st_refill_response_required)
destroy(this.gb_additional_refills)
destroy(this.mle_refill_request)
destroy(this.st_2)
destroy(this.st_title)
destroy(this.st_requested_by_title)
destroy(this.st_requested_by)
destroy(this.st_requested_date_time_title)
destroy(this.st_requested_date_time)
destroy(this.st_requester_note_title)
destroy(this.st_requester_note)
destroy(this.st_scheduled_warning)
destroy(this.st_approved)
destroy(this.ole_refill_history)
end on

event post_open;call super::post_open;integer li_sts
str_popup_return popup_return


li_sts = check_contraindications()
if li_sts <= 0 then
	popup_return.item_count = 1
	popup_return.items[1] = "CANCEL"
	closewithreturn(this, popup_return)
end if

return

end event

event open;call super::open;str_popup_return popup_return
long ll_menu_id
integer li_sts
string ls_refill_comment
string ls_progress_key
string ls_actor_class

popup_return.item_count = 1
popup_return.items[1] = "ERROR"

service = message.powerobjectparm


if isnull(service.treatment) then
	log.log(this, "open", "Null treatment object", 4)
	closewithreturn(this, popup_return)
	return
end if

title = current_patient.id_line()

// Don't offer the "I'll Be Back" option for manual services
max_buttons = 2
if service.manual_service then
	cb_be_back.visible = false
	max_buttons = 3
end if

li_sts = current_patient.treatments.treatment(refill_treatment, service.treatment_id)
if li_sts <= 0 then
	log.log(this, "open", "Error getting refill treatment data", 4)
	closewithreturn(this, popup_return)
	return
end if

if isnull(refill_treatment.parent_treatment_id) then
	log.log(this, "open", "Refill treatment is not a child treatment", 4)
	closewithreturn(this, popup_return)
	return
end if

li_sts = current_patient.treatments.treatment(ordered_treatment, refill_treatment.parent_treatment_id)
if li_sts <= 0 then
	log.log(this, "open", "Error getting ordered treatment data", 4)
	closewithreturn(this, popup_return)
	return
end if

if len(ordered_treatment.drug_id) > 0 then
	li_sts = drugdb.get_drug_definition(ordered_treatment.drug_id, drug)
end if

//ll_menu_id = long(service.get_attribute("menu_id"))
//paint_menu(ll_menu_id)

signature_service = service.get_attribute("signature_service")
if isnull(signature_service) then signature_service = "EXTERNAL_SOURCE"

response_message_service = service.get_attribute("response_message_service")
if isnull(response_message_service) then response_message_service = "TODO"

response_report_service = service.get_attribute("response_report_service")
if isnull(response_report_service) then response_report_service = "REPORT"

response_report_id = service.get_attribute("response_report_id")
if isnull(response_report_id) then response_report_id = "{463D24B6-084A-4AB6-97A1-AFB34540A245}" // Treatment JMJDocument

new_rx_report_service = service.get_attribute("new_rx_report_service")
if isnull(new_rx_report_service) then new_rx_report_service = "REPORT"

new_rx_report_id = service.get_attribute("new_rx_report_id")
if isnull(new_rx_report_id) then new_rx_report_id = datalist.get_preference( "PREFERENCES", "rx_prescription_report", "{ED21F61C-D7A2-40EF-9022-2FE20658839D}")  // PB Prescription Report

refill_progress_type = service.get_attribute("refill_progress_type")
if isnull(refill_progress_type) then refill_progress_type = "Refill"

refill_note_progress_key = service.get_attribute("refill_note_progress_key")
if isnull(refill_note_progress_key) then refill_note_progress_key = "Pharmacy Instructions To Provider"

refill_note_progress_key2 = service.get_attribute("refill_note_progress_key2")
if isnull(refill_note_progress_key2) then refill_note_progress_key2 = "Refill Request Notes"

denial_code_domain_id = service.get_attribute("denial_code_domain_id")
if isnull(denial_code_domain_id) then denial_code_domain_id = "SureScriptsDenialCode"

rx_reference_number_property = datalist.get_preference("E-Prescribing", "rx_reference_number_property")
if isnull(rx_reference_number_property) then rx_reference_number_property = "SSRx Reference Number"

// If the requester was a user, then this is a local request
ls_actor_class = user_list.user_property(refill_treatment.ordered_by, "actor_class")
if upper(ls_actor_class) = "USER" then
	local_request = true
else
	local_request = false
end if

refresh()

postevent("post_open")

end event

event resize;call super::resize;long ll_midpoint
long ll_x
long ll_gap
long ll_left_side_bottom
long ll_right_side_bottom
long ll_resolution_block_height = 740
long ll_requested_by_block_height = 428
long ll_refill_history_block_height = 316

ll_midpoint = width/2

st_title.width = width

cb_view_chart.x = 41
cb_view_chart.y = height - cb_view_chart.height - 141

cb_done.x = width - cb_done.width - 41
cb_done.y = cb_view_chart.y

cb_be_back.x = cb_done.x - cb_be_back.width - 66
cb_be_back.y = cb_view_chart.y

mle_refill_request.width = ll_midpoint - (2 * mle_refill_request.x)
mle_ordered_medication.x = ll_midpoint + mle_refill_request.x
mle_ordered_medication.width = mle_refill_request.width
st_ordered_rx_title.x = mle_ordered_medication.x

st_checking_contraindications.x = ll_midpoint - (st_checking_contraindications.width / 2)


// Center the disposition buttons under the ordered Rx
ll_x = mle_ordered_medication.x + (mle_ordered_medication.width / 2) - (st_approved.width / 2)

// Slide them over on a small screen
if width < 3200 then ll_x += 137

st_resolution_title.x = ll_x - ((st_resolution_title.width - st_approved.width) / 2)
st_refill_response_required.x = st_resolution_title.x + st_resolution_title.width + 10
st_approved.x = ll_x
st_denied.x = ll_x
st_modify_rx.x = ll_x
st_change_med.x = ll_x


st_refill_comment_title.x = width - 1523
if st_refill_comment_title.x > mle_ordered_medication.x then
	st_refill_comment_title.x = mle_ordered_medication.x
end if
st_refill_comment_title.y = cb_view_chart.y - 216

st_refill_comment_required.x = st_refill_comment_title.x + st_refill_comment_title.width
st_refill_comment_required.y = st_refill_comment_title.y

sle_refill_comment.x = st_refill_comment_title.x
sle_refill_comment.y = st_refill_comment_title.y + st_refill_comment_title.height + 4
sle_refill_comment.width = width - sle_refill_comment.x - 174

cb_pick_comment.x = sle_refill_comment.x + sle_refill_comment.width + 15
cb_pick_comment.y = sle_refill_comment.y + 4

if st_refill_comment_title.y - (st_change_med.y + st_change_med.height) > (gb_additional_refills.height + 100) then
	// If there is room bewteen the resolution block and the comment, slide the refills group over
	gb_additional_refills.x = mle_ordered_medication.x
	gb_additional_refills.width = mle_ordered_medication.width
	ll_gap = (st_refill_comment_title.y - (st_change_med.y + st_change_med.height) - gb_additional_refills.height) / 2
	gb_additional_refills.y = st_change_med.y + st_change_med.height + ll_gap
	
	ll_left_side_bottom = cb_view_chart.y
	ll_right_side_bottom = gb_additional_refills.y
else
	// otherwise bottom justify refills group with comment
	gb_additional_refills.x = mle_refill_request.x
	gb_additional_refills.width = mle_refill_request.width
	gb_additional_refills.y = sle_refill_comment.y + sle_refill_comment.height - gb_additional_refills.height

	ll_left_side_bottom = gb_additional_refills.y
	ll_right_side_bottom = st_refill_comment_title.y
end if

// Now place the refills requested/authorized controls
ll_gap = (gb_additional_refills.width - st_refills_requested_title.width - st_refills_requested.width - st_refills_authorized_title.width - st_refills_authorized.width) / 3
st_refills_requested_title.x = gb_additional_refills.x + ll_gap
st_refills_requested.x = st_refills_requested_title.x + st_refills_requested_title.width
st_refills_authorized_title.x = st_refills_requested.x + st_refills_requested.width + ll_gap
st_refills_authorized.x = st_refills_authorized_title.x + st_refills_authorized_title.width
st_refills_authorized_required.x = st_refills_authorized.x + st_refills_authorized.width

st_refills_requested_title.y = gb_additional_refills.y + 92
st_refills_requested.y = gb_additional_refills.y + 84
st_refills_authorized_title.y = gb_additional_refills.y + 92
st_refills_authorized.y = gb_additional_refills.y + 84
st_refills_authorized_required.y = gb_additional_refills.y + 96


// Position the resolution block between the ordered Rx and the right-side-bottom
ll_gap = (ll_right_side_bottom - mle_ordered_medication.y - mle_ordered_medication.height - ll_resolution_block_height) / 2
st_resolution_title.y = mle_ordered_medication.y + mle_ordered_medication.height + ll_gap
st_refill_response_required.y = st_resolution_title.y + 16
st_approved.y = st_resolution_title.y + 156
st_denied.y = st_approved.y + 156
st_modify_rx.y = st_denied.y + 156
st_change_med.y = st_modify_rx.y + 156

st_scheduled_warning.x = st_approved.x + st_approved.width + 16
st_scheduled_warning.y = st_approved.y - 8




// Give 2 gap-shares to the height of the refill history
ll_gap = (ll_left_side_bottom - mle_refill_request.y - mle_refill_request.height - ll_requested_by_block_height - ll_refill_history_block_height) / 5
if ll_gap > 36 then
	// If there is enough room to move the requested_by_block, then move the requested_by_block and the refill history
	st_requested_by_title.y = mle_refill_request.y + mle_refill_request.height + ll_gap
	st_requested_by.y = st_requested_by_title.y
	st_requested_date_time_title.y = st_requested_by_title.y + 96
	st_requested_date_time.y = st_requested_date_time_title.y
	st_requester_note_title.y = st_requested_date_time_title.y + 96
	st_requester_note.y = st_requester_note_title.y
	
	st_refill_history_title.y =  st_requester_note.y + st_requester_note.height + ll_gap
	ole_refill_history.y = st_refill_history_title.y + st_refill_history_title.height
	ole_refill_history.height = 244 + (ll_gap * 2)
	if ole_refill_history.width < mle_refill_request.width then ole_refill_history.width = mle_refill_request.width
end if




end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_rx_refill_request
integer x = 2661
integer y = 24
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_rx_refill_request
integer x = 114
integer y = 1220
end type

type cb_be_back from commandbutton within w_svc_rx_refill_request
integer x = 1600
integer y = 1600
integer width = 599
integer height = 108
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I~'ll Be Back"
end type

event clicked;str_popup_return popup_return
integer li_sts


if refills_authorized_changed then
	f_set_patient_property(service.cpr_id, &
								"Treatment", &
								refill_treatment.treatment_id, &
								"Refills Authorized", &
								string(refills_authorized) )
end if

if refill_approver_comment_changed then
	f_set_patient_property(service.cpr_id, &
								"Treatment", &
								refill_treatment.treatment_id, &
								"Refill Approver Comment", &
								sle_refill_comment.text )
end if


popup_return.item_count = 0
closewithreturn(parent, popup_return)

end event

type cb_done from commandbutton within w_svc_rx_refill_request
integer x = 2258
integer y = 1600
integer width = 599
integer height = 108
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
end type

event clicked;str_popup_return popup_return
integer li_sts
string ls_null
long ll_null
datetime ldt_null
string ls_ref_number
str_attributes lstr_attributes
string ls_message
string ls_refill_comment
string ls_medication_progress_type
string ls_medication_progress_key
string ls_progress

setnull(ls_null)
setnull(ll_null)
setnull(ldt_null)

setnull(ls_medication_progress_key)

if lower(refill_response) = "approved" and refills_authorized = 0 then
	openwithparm(w_pop_message, "You must specify the Total Number of Dispenses Authorized")
	return
end if

if refills_authorized_changed then
	f_set_patient_property(service.cpr_id, &
								"Treatment", &
								refill_treatment.treatment_id, &
								"Refills Authorized", &
								string(refills_authorized) )
end if

if len(sle_refill_comment.text) > 0 then
	ls_refill_comment = sle_refill_comment.text
else
	setnull(ls_refill_comment)
end if

if refill_approver_comment_changed then
	f_set_patient_property(service.cpr_id, &
								"Treatment", &
								refill_treatment.treatment_id, &
								"Refill Approver Comment", &
								ls_refill_comment)
end if

if lower(refill_response) = "denied" then
	// There must be either a comment or a denial reason code
	if isnull(denial_reason_code) or trim(denial_reason_code) = "" then
		if isnull(ls_refill_comment) then
			openwithparm(w_pop_message, "You must either select a Denial Reason or provide a Refill Comment when you deny a refill request")
			return
		end if
	end if
else
	if st_refill_comment_required.visible then
		if isnull(ls_refill_comment) then
			openwithparm(w_pop_message, "You must provide a Refill Comment")
			return
		end if
	end if
end if



CHOOSE CASE lower(refill_response)
	CASE "approved"
	CASE "denied"
		if len(denial_reason_code) > 0 then
			f_set_patient_property(service.cpr_id, &
										"Treatment", &
										refill_treatment.treatment_id, &
										"Denial Reason Code", &
										denial_reason_code )
		end if
	CASE "modify"
		li_sts = modify_parent_med()
		if li_sts <= 0 then return
	CASE "change"
		li_sts = change_parent_med()
		if li_sts <= 0 then return
	CASE ELSE
		openwithparm(w_pop_message, "Please select a Refill Response")
		return
END CHOOSE

if new_rx_treatment_id > 0 then
	// Copy the Rx Reference Number to the new treatment if there is one
	ls_ref_number = f_get_patient_property_value(service.cpr_id, refill_treatment.treatment_id, "Treatment", rx_reference_number_property, lstr_attributes)
	if len(ls_ref_number) > 0 then
		f_set_patient_property(service.cpr_id, &
									"Treatment", &
									new_rx_treatment_id, &
									rx_reference_number_property, &
									ls_ref_number )
	end if
end if

f_set_patient_property(service.cpr_id, &
							"Treatment", &
							refill_treatment.treatment_id, &
							"Refill Approver Response", &
							refill_response )


// Close the refill request treatment
li_sts = f_set_progress(current_patient.cpr_id, &
								"Treatment", &
								refill_treatment.treatment_id, &
								"Closed", &
								ls_null, &
								ls_null, &
								ldt_null, &
								ll_null, &
								ll_null, &
								service.patient_workplan_item_id)
if li_sts < 0 then return -1



//////////////////////////////////////////////////////////////////////////////////////////////////////////

// We've taken care of creating new treatments if necessary and setting properties.  Now
// We need to send the appropriate response back to the requester, and if necessary order
// a new prescription document

if len(response_report_id) > 0 and len(response_report_service) > 0 then
	li_sts = send_response( )
	if li_sts <= 0 then return
end if

CHOOSE CASE lower(refill_response)
	CASE "approved"
		if controlled_substance and not local_request then
			// If this is a controlled substance and not a local request, then we're going to treat it like a physician initiated refill request and send a NEWRX message
			ls_message = "This medication is a controlled substance so EncounterPRO will not be able to send the refill electronically.  Do you wish to print the refill now?"
			openwithparm(w_pop_yes_no, ls_message)
			popup_return = message.powerobjectparm
			if popup_return.item = "YES" then
				li_sts = order_rx_document(ordered_treatment.treatment_id)
				if li_sts <= 0 then return
				
				li_sts = manage_documents(ordered_treatment.treatment_id)
				if li_sts <= 0 then return
			end if
		elseif local_request then
			// If this was a local request then the prescription document still needs to be ordered
			li_sts = order_rx_document(ordered_treatment.treatment_id)
			if li_sts <= 0 then return
		end if
		ls_medication_progress_type = "Refill"
		ls_medication_progress_key = "Approved"
	CASE "denied"
		ls_medication_progress_type = "Refill Denied"
	CASE "modify"
		if local_request then
			// If this was a local request then the prescription document still needs to be ordered
			li_sts = order_rx_document(new_rx_treatment_id)
			if li_sts <= 0 then return
		else
			li_sts = send_new_treatment(new_rx_treatment_id)
			if li_sts <= 0 then return
		end if
		ls_medication_progress_type = "Refill"
		ls_medication_progress_key = "Changes Made"
	CASE "change"
		if not local_request then
			li_sts = send_new_treatment(new_rx_treatment_id)
			if li_sts <= 0 then return
		end if
		ls_medication_progress_type = "Refill Denied"
		ls_medication_progress_key = "New Rx Ordered"
END CHOOSE

// Log the disposition against the parent medication treatment
ls_progress = ""
if lower(refill_response) = "denied" and len(denial_reason_code) > 0 and len(denial_reason_text) > 0 then
	ls_progress = denial_reason_text
end if
if len(ls_refill_comment) > 0 then
	if len(ls_progress) > 0 then ls_progress += "; "
	ls_progress += ls_refill_comment
end if
if trim(ls_progress) = "" then setnull(ls_progress)
li_sts = current_patient.treatments.set_treatment_progress(ordered_treatment.treatment_id, ls_medication_progress_type, ls_medication_progress_key, ls_progress)
if li_sts < 0 then return -1


popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)

end event

type st_resolution_title from statictext within w_svc_rx_refill_request
integer x = 1952
integer y = 624
integer width = 763
integer height = 104
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 33538240
string text = "Refill Response"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_denied from statictext within w_svc_rx_refill_request
integer x = 2039
integer y = 936
integer width = 603
integer height = 116
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Denied"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

st_approved.backcolor = color_object
st_denied.backcolor = color_object_selected
st_modify_rx.backcolor = color_object
st_change_med.backcolor = color_object

refill_response = "Denied"

setnull(denial_reason_code)
text = "Denied"

st_refill_comment_required.visible = true
cb_done.enabled = true

refills_authorized = 0
refills_authorized_changed = true

popup.dataobject = "dw_domain_translate_list_long"
popup.datacolumn = 2
popup.displaycolumn = 3
popup.argument_count = 1
popup.argument[1] = denial_code_domain_id
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if len(popup_return.items[1]) > 0 then
	denial_reason_code = popup_return.items[1]
	denial_reason_text = popup_return.descriptions[1]
	text = "Denied - " + denial_reason_code
	st_refill_comment_required.visible = false
end if

st_refills_authorized.text = string(refills_authorized)

end event

type st_modify_rx from statictext within w_svc_rx_refill_request
integer x = 2039
integer y = 1092
integer width = 603
integer height = 116
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Modify Rx"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_approved.backcolor = color_object
st_denied.backcolor = color_object
st_modify_rx.backcolor = color_object_selected
st_change_med.backcolor = color_object

refill_response = "Modify"

cb_done.enabled = true

refills_authorized = 0
st_refills_authorized.text = string(refills_authorized)
refills_authorized_changed = true

end event

type st_refill_history_title from statictext within w_svc_rx_refill_request
integer x = 46
integer y = 984
integer width = 398
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Refill History"
boolean focusrectangle = false
end type

type st_refill_comment_title from statictext within w_svc_rx_refill_request
integer x = 1394
integer y = 1384
integer width = 411
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Refill Comment"
boolean focusrectangle = false
end type

type cb_pick_comment from commandbutton within w_svc_rx_refill_request
integer x = 2757
integer y = 1452
integer width = 114
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.title = "Select Refill Comment"
popup.data_row_count = 2
popup.items[1] = "Refill Comment"
popup.items[2] = ""
openwithparm(w_pick_top_20_multiline, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

sle_refill_comment.replacetext(popup_return.items[1])
refill_approver_comment_changed = true
sle_refill_comment.setfocus()

end event

type cb_view_chart from commandbutton within w_svc_rx_refill_request
integer x = 41
integer y = 1600
integer width = 599
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "View Chart"
end type

event clicked;str_service_info lstr_service

lstr_service.service = "Chart"

service_list.do_service(lstr_service)

end event

type st_ordered_rx_title from statictext within w_svc_rx_refill_request
integer x = 1536
integer y = 92
integer width = 384
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Ordered Rx"
boolean focusrectangle = false
end type

type mle_ordered_medication from multilineedit within w_svc_rx_refill_request
integer x = 1536
integer y = 160
integer width = 1339
integer height = 380
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean vscrollbar = true
boolean autovscroll = true
end type

type st_change_med from statictext within w_svc_rx_refill_request
integer x = 2039
integer y = 1248
integer width = 603
integer height = 116
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Change Med"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_approved.backcolor = color_object
st_denied.backcolor = color_object
st_modify_rx.backcolor = color_object
st_change_med.backcolor = color_object_selected

refill_response = "Change"

cb_done.enabled = true

refills_authorized = 0
st_refills_authorized.text = string(refills_authorized)
refills_authorized_changed = true


end event

type sle_refill_comment from singlelineedit within w_svc_rx_refill_request
integer x = 1394
integer y = 1448
integer width = 1349
integer height = 92
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;refill_approver_comment_changed = true

end event

type st_refill_comment_required from statictext within w_svc_rx_refill_request
integer x = 1797
integer y = 1384
integer width = 82
integer height = 60
boolean bringtotop = true
integer textsize = -18
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 33538240
string text = "*"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_checking_contraindications from statictext within w_svc_rx_refill_request
boolean visible = false
integer x = 983
integer y = 304
integer width = 955
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 33538240
string text = "<  Checking Contraindications  >"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_refills_requested_title from statictext within w_svc_rx_refill_request
integer x = 123
integer y = 1420
integer width = 338
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Requested:"
boolean focusrectangle = false
end type

type st_refills_requested from statictext within w_svc_rx_refill_request
integer x = 457
integer y = 1412
integer width = 183
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "PRN"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_refills_authorized_title from statictext within w_svc_rx_refill_request
integer x = 722
integer y = 1420
integer width = 347
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Authorized:"
boolean focusrectangle = false
end type

type st_refills_authorized from statictext within w_svc_rx_refill_request
integer x = 1070
integer y = 1412
integer width = 183
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "99"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;// By Sumathi Chinnasamy On 12/08/1999
// To allow the user to key-in the no. of refills

str_popup 			popup
str_popup_return	popup_return

popup.realitem = refills_authorized
Openwithparm(w_number,popup)

popup_return = Message.powerobjectparm

If popup_return.item = "CANCEL" Then Return

refills_authorized				 = popup_return.realitem
If Isnull(refills_authorized) Then refills_authorized = 0

st_refills_authorized.text = string(refills_authorized)
refills_authorized_changed = true

end event

type st_refills_authorized_required from statictext within w_svc_rx_refill_request
integer x = 1253
integer y = 1424
integer width = 82
integer height = 60
boolean bringtotop = true
integer textsize = -18
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 33538240
string text = "*"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_refill_response_required from statictext within w_svc_rx_refill_request
integer x = 2670
integer y = 640
integer width = 82
integer height = 60
boolean bringtotop = true
integer textsize = -18
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 33538240
string text = "*"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_additional_refills from groupbox within w_svc_rx_refill_request
integer x = 78
integer y = 1328
integer width = 1271
integer height = 212
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 33538240
string text = "Total Number of Dispenses:"
end type

type mle_refill_request from multilineedit within w_svc_rx_refill_request
integer x = 46
integer y = 160
integer width = 1339
integer height = 380
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean vscrollbar = true
boolean autovscroll = true
end type

type st_2 from statictext within w_svc_rx_refill_request
integer x = 46
integer y = 92
integer width = 1033
integer height = 84
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Refill Requested For Rx"
boolean focusrectangle = false
end type

type st_title from statictext within w_svc_rx_refill_request
integer width = 2921
integer height = 120
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Medication Refill Request"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_requested_by_title from statictext within w_svc_rx_refill_request
integer x = 46
integer y = 576
integer width = 434
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Requested By:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_requested_by from statictext within w_svc_rx_refill_request
integer x = 494
integer y = 576
integer width = 1376
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_service_info lstr_service


lstr_service.service = "Show Actor"
f_attribute_add_attribute(lstr_service.attributes, "user_id", refill_treatment.ordered_by)

service_list.do_service(lstr_service)

end event

type st_requested_date_time_title from statictext within w_svc_rx_refill_request
integer x = 46
integer y = 672
integer width = 434
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Date/Time:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_requested_date_time from statictext within w_svc_rx_refill_request
integer x = 494
integer y = 672
integer width = 727
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_requester_note_title from statictext within w_svc_rx_refill_request
integer x = 46
integer y = 768
integer width = 434
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Note:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_requester_note from statictext within w_svc_rx_refill_request
integer x = 494
integer y = 768
integer width = 1381
integer height = 236
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
boolean focusrectangle = false
end type

type st_scheduled_warning from statictext within w_svc_rx_refill_request
boolean visible = false
integer x = 2651
integer y = 772
integer width = 183
integer height = 132
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 33538240
string text = "Print Only"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_approved from statictext within w_svc_rx_refill_request
integer x = 2039
integer y = 780
integer width = 603
integer height = 116
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Approved"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_approved.backcolor = color_object_selected
st_denied.backcolor = color_object
st_modify_rx.backcolor = color_object
st_change_med.backcolor = color_object

refill_response = "Approved"

st_refill_comment_required.visible = false

cb_done.enabled = true

end event

type ole_refill_history from u_rich_text_edit within w_svc_rx_refill_request
integer x = 46
integer y = 1060
integer width = 1669
integer height = 244
integer taborder = 30
boolean bringtotop = true
borderstyle borderstyle = stylebox!
string binarykey = "w_svc_rx_refill_request.win"
end type


Start of PowerBuilder Binary Data Section : Do NOT Edit
07w_svc_rx_refill_request.bin 
2800001800e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd00000008fffffffe0000000400000005000000060000000700000009fffffffe0000000afffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff00000003000000000000000000000000000000000000000000000000000000003ca67b3001ca361f0000000300000cc00000000000500003004c004200430049004e0045004500530045004b000000590000000000000000000000000000000000000000000000000000000000000000000000000002001cffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000001a0000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000002001affffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000010000087b00000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000101001a00000002000000010000000426bd990111dde7d0130041aa7c6650d3000000003ca67b3001ca361f3ca67b3001ca361f000000000000000000000000fffffffe00000002000000030000000400000005000000060000000700000008000000090000000a0000000b0000000c0000000d0000000e0000000f000000100000001100000012000000130000001400000015000000160000001700000018000000190000001a0000001b0000001c0000001d0000001e0000001f000000200000002100000022fffffffe0000002400000025000000260000002700000028000000290000002a0000002b0000002c0000002d0000002e0000002f000000300000003100000032fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
29ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff005000540036002d0031003400360032003900370031003600000039746e6f63636c6f727372616800012d0000000800646e690072746e6500011e00000009000000fffe0002020526bd990111dde7d0130041aa7c6650d300000001fb8f0821101b01640008ed8413c72e2b000000300000084b0000003a00000100000001d800000101000001e000000102000001e800000103000001f000000104000001f8000001050000020000000106000002080000010700000210000001080000021800000109000002200000010a000002280000010b000002300000010c000002380000010d000002400000010e000002480000010f00000250000001100000025800000111000002600000011200000268000001130000027000000114000002ac00000115000002b400000116000002bc00000117000002c400000118000002cc00000119000002d40000011a000002dc0000011b000002e40000011c000002ec0000011d000002f40000011e000002fc0000011f0000030c0000012000000314000001210000031c0000012200000324000001230000032c0000012400000334000001250000033c0000012600000344000001270000034c0000012800000354000001290000035c0000012a000003640000012b0000036c0000012c000003740000012d0000037c0000012e000003840000012f0000038c0000013000000394000001310000039c00000132000003a800000133000003b000000134000003b800000135000003c000000136000003c800000137000003d000000138000003d800000000000003e0000000030002000000000003000025b9000000030000064e00000003000000490000000200000001000000020000000100000002000000010000000b0000000000000002000000000000000b0000ffff0000000b0000ffff0000000200000000000000020000006400000002000000030000000b000000000000000b0000ffff00000002000000000000000b0000ffff0000000b000000000000000800000031505c3a4352474f525c317e4149454854317e414d5458545c7e5458455c302e325c6e694252454d414e4143494454562e0000000000000002000000030000000300002fd00000000300003de000000003000005a000000003000005a000000003000005a000000003000005a000000002000000640000000b000000000000000b0000ffff0000000800000006616972410000006c000000020000000c0000000b000000000000000b000000000000000b000000000000000b0000000000000002000000000000000300ffffff0000000200000000000000020000006400000002000000000000000200000020000000020000000000000002000000140000000200000000000000020000000000000002000000000000000200000000000000020000000000000008000000010000000000000002000000010000000b0000ffff0000000b0000ffff0000000b000000000000000200000000000000020000000100000002000000000000003a00000000000000010001330000000a006c6c61006e75776f32006f640d000001770000007764726f6d7061720065646f00000112000000106d726f66657374617463656c006e6f69000001090000000e65646968656c65736f6974630108006e00090000646500006f6d7469280065640d0000016c00000073656e69696361700074676e000001190000000c656761706772616d00726e69000001070000000d746e6f63636c6f727372616800012d0000000800646e690072746e6500011e00000009006e6f66006d616e74011a0065000c000061700000616d65676e696772010e0062000d00006c6300006863706972646c6930006e6508000001690000006e65646e180062740c000001700000006d656761696772611500746e0a00000170000000776567616874646900010b0000000d00756f6d006f70657365746e6901060072000a00006162000074736b6300656c790000013400000015747865746d61726672616d656c72656b73656e6900012f0000000800646e690074746e650001270000000c006e696c0061707365676e696300010c0000000b006f6f7a006361666d00726f740000010a0000000e65736e696f697472646f6d6e012a0065000e00007266000064656d61617473690065636e000001130000001270737476646c6c656974636972616e6f01030079000c0000735f00006b636f74706f7270013600730010000061700000726f6567746e65696f6974610135006e00170000696600006c646c65746b6e696567726172616d747372656b0001210000000b006e6f6600617469740063696c0000011000000009657a697365646f6d0001050000000c00726f620073726564656c79740001370000000e006761700065697665797473772600656c0a000001610000006e67696c746e656d0001240000000900736162006e696c6501160065000b00006170000065686567746867690001250000000c0078657400636b6274726f6c6f0001230000000e006e6f6600646e7574696c72652200656e0f0000016600000073746e6f6b69727472687465011f0075000900006f6600006973746e1100657a0700000174000000656b6261012b0079000f0000726600006c656d6177656e69687464690001290000000b0061726600
2C7473656d00656c7900000101000000097478655f78746e6500012000000009006e6f66006c6f62740102006400090000655f00006e657478380079740d0000016600000073746e6f697474650073676e0000011d0000000c6e6972706c6f63740073726f000001170000000c656761706772616d006c6e690000010d000000097765697665646f6d00012c0000000800646e69006c746e6500012e0000000900646e690066746e650131006c00050000657400001c0074780c00000170000000746e69727366666f1b0074650a00000170000000746e69726d6f6f7a0001140000000b0072637300626c6c6f007372610000010400000009676e616c65676175000100000000090065765f006f697372010f006e000d00006c630000697370696e696c62000073670000000000020000000025b90000064e000000490000000000ffffff0100010100000100010100000064000001000003000100005c3a4330474f5250317e41524548545c7e414d4958545c3154584554302e327e6e69425c454d415c4143495254562e4e03000044002fd000003de0000005a0000005a0000005a0000005a00000006400724105010c6c616900000000ff0000000000ffff000064000000200000001400000000000000000001000000010100010100000020000000dc0000030e0001050000000000000000020000005c000000010000010100010000000100000000009f000000010001000000000000000000000000000000000000ff1050000000000001900000000000412202006c616972000000000000000000000000000000000000000000000000010000000100010000000000000000000000000020006400006f00430074006e006e00650073007400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000023000003db000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001400046e01000108dc01b8010d4a16260111011a940170011f0227de0123012c4c01280130ba39960135003e040100000000000000000000000041000000690072006c0061000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e4000000010000040900010000010006002e000000ffffb7000000000000000000000000010000000000000000000000000000000000000000000100000000000000000000000000010000000100010000000100000000000000000000000000000000005400000030000001000000000000000000000000000000000000000000400000000000000100000000000000000000000000000024000000010000010000000000ff1000000000000001900000000000410202006c6169720000000000000000000000000000000000000000000000000000000000000000000000000000000041000000690072006c006100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400000005000000000000000002000640000000f00046e01000108dc01b8010d4a16260111011a940170011f0227de0123012c4c01280130ba39960135013e04010900010000010006002e000000ffffb700000000000000000000000000000000000012000000000000000000000000000000000000000000000000004e005b0072006f0061006d005d006c000100000000004e0000003200000000003700000037023702d0023702e000002fa000003da005a0052005a00500800f020000000001000000000000001b000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
17w_svc_rx_refill_request.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
