$PBExportHeader$w_svc_compose_message.srw
forward
global type w_svc_compose_message from w_window_base
end type
type st_subject_title from statictext within w_svc_compose_message
end type
type sle_subject from singlelineedit within w_svc_compose_message
end type
type st_3 from statictext within w_svc_compose_message
end type
type st_message_title from statictext within w_svc_compose_message
end type
type mle_message from multilineedit within w_svc_compose_message
end type
type st_patient_title from statictext within w_svc_compose_message
end type
type st_patient from statictext within w_svc_compose_message
end type
type cb_send from commandbutton within w_svc_compose_message
end type
type cb_cancel from commandbutton within w_svc_compose_message
end type
type cb_subject from commandbutton within w_svc_compose_message
end type
type cb_body from commandbutton within w_svc_compose_message
end type
type st_item_title from statictext within w_svc_compose_message
end type
type st_item from statictext within w_svc_compose_message
end type
type cb_expand from commandbutton within w_svc_compose_message
end type
type dw_addressee from u_dw_pick_list within w_svc_compose_message
end type
type st_title from statictext within w_svc_compose_message
end type
type st_priority_title from statictext within w_svc_compose_message
end type
type st_priority from statictext within w_svc_compose_message
end type
type str_recipient from structure within w_svc_compose_message
end type
end forward

type str_recipient from structure
	string		user_id
	string		document_route
end type

global type w_svc_compose_message from w_window_base
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_subject_title st_subject_title
sle_subject sle_subject
st_3 st_3
st_message_title st_message_title
mle_message mle_message
st_patient_title st_patient_title
st_patient st_patient
cb_send cb_send
cb_cancel cb_cancel
cb_subject cb_subject
cb_body cb_body
st_item_title st_item_title
st_item st_item
cb_expand cb_expand
dw_addressee dw_addressee
st_title st_title
st_priority_title st_priority_title
st_priority st_priority
end type
global w_svc_compose_message w_svc_compose_message

type variables
u_component_workplan_item service

string message_service
string message_object
long message_object_key
str_attributes message_attributes
string in_office_flag
string top_20_prefix

string progress_type

boolean allow_multiple_recipients

boolean open_encounter_context = false
boolean reverted_to_inbox = false

long patient_count = 0
string patient_list[]

long collapse_height

integer priority

string message_purpose = "Message"

end variables

forward prototypes
public function integer send_message ()
public function long order_service (string ps_cpr_id, long pl_encounter_id, string ps_service, string ps_ordered_for, string ps_description, integer pi_step_number, str_attributes pstr_attributes)
public subroutine display_to_users (str_users pstr_to_users)
public function str_users get_to_users ()
public subroutine add_recipient (ref integer pi_recipient_count, ref str_recipient pstra_recipients[], string ps_new_recipient, string ps_document_route)
end prototypes

public function integer send_message ();integer li_step_number
integer li_sts
long ll_sts
str_attributes lstr_attributes
long ll_pos
string ls_message
//string lsa_recipients[]
integer li_recipient_count
integer i, j
str_user lstra_users[]
integer li_count
string ls_progress_key
datetime ldt_progress_date_time
long ll_risk_level
string ls_intended_recipients
long ll_dispatched_patient_workplan_item_id
long ll_patient_workplan_item_id
long ll_encounter_id
long ll_patient_count
integer li_please_wait
string ls_document_route
str_recipient lstra_recipients[]
long ll_addressee_count
string ls_user_id

setnull(ll_risk_level)
ldt_progress_date_time = datetime(today(), now())

setnull(li_step_number)

//lstr_to_users = get_to_users()
ll_addressee_count = dw_addressee.rowcount()

If ll_addressee_count <= 0 Then
	openwithparm(w_pop_message, "You must select a recipient")
	Return 0
End If

If ll_addressee_count = 1 Then
	ls_user_id = dw_addressee.object.user_id[1]
	if isnull(ls_user_id) then
		openwithparm(w_pop_message, "You must select a recipient")
		Return 0
	end if
End If

if isnull(sle_subject.text) or trim(sle_subject.text) = "" then
	openwithparm(w_pop_message, "You must enter a subject")
	return 0
end if

lstr_attributes = message_attributes

lstr_attributes.attribute_count += 1
lstr_attributes.attribute[lstr_attributes.attribute_count].attribute = "in_office_flag"
lstr_attributes.attribute[lstr_attributes.attribute_count].value = in_office_flag

if isnull(progress_type) then
	if not isnull(sle_subject.text) and trim(sle_subject.text) <> "" then
		lstr_attributes.attribute_count += 1
		lstr_attributes.attribute[lstr_attributes.attribute_count].attribute = "message_subject"
		lstr_attributes.attribute[lstr_attributes.attribute_count].value = sle_subject.text
	end if
	
	if not isnull(mle_message.text) and trim(mle_message.text) <> "" then
		lstr_attributes.attribute_count += 1
		lstr_attributes.attribute[lstr_attributes.attribute_count].attribute = "message"
		lstr_attributes.attribute[lstr_attributes.attribute_count].value = mle_message.text
	end if
end if

// Log the intended recipients
ls_intended_recipients = ""
for i = 1 to ll_addressee_count
	ls_intended_recipients += dw_addressee.object.user_id[i] + ";"
next
service.add_attribute("intended_recipients", ls_intended_recipients)

// If we are allowing multiple recipients, then we have to translate the to_user array into recipients.
// To do this we'll transfer them one by one into the recipients
// array translating each role into it's constituent users
if allow_multiple_recipients then
	for i = 1 to ll_addressee_count
		ls_document_route = dw_addressee.object.document_route[i]
		
		if left(dw_addressee.object.user_id[i], 1) = "!" then
			li_count = user_list.users_in_role(dw_addressee.object.user_id[i], lstra_users)
			for j = 1 to li_count
				add_recipient(li_recipient_count, lstra_recipients, lstra_users[j].user_id, ls_document_route)
			next
		else
			add_recipient(li_recipient_count, lstra_recipients, dw_addressee.object.user_id[i], ls_document_route)
		end if
	next
else
	// For all other services, just use the users and roles selected
	for i = 1 to ll_addressee_count
		ls_document_route = dw_addressee.object.document_route[i]
		add_recipient(li_recipient_count, lstra_recipients, dw_addressee.object.user_id[i], ls_document_route)
	next
end if

// Then we loop through each recipient and send a copy of the message
if patient_count > 0 then
	ll_patient_count = patient_count
	setnull(ll_encounter_id)
else
	ll_patient_count = 1
	patient_list[1] = service.cpr_id
	ll_encounter_id = service.encounter_id
end if
li_please_wait = f_please_wait_open( )
f_please_wait_progress_bar(li_please_wait, 0, ll_patient_count)

for i = 1 to ll_patient_count
	if li_recipient_count = 1 then
		ll_dispatched_patient_workplan_item_id = order_service(patient_list[i], &
																				ll_encounter_id, &
																				message_service, &
																				lstra_recipients[1].user_id, &
																				sle_subject.text, &
																				li_step_number, &
																				lstr_attributes)
	else
		ll_dispatched_patient_workplan_item_id = order_service(patient_list[i], &
																				ll_encounter_id, &
																				message_service, &
																				"#DistList", &
																				sle_subject.text, &
																				li_step_number, &
																				lstr_attributes)
		for i = 1 to li_recipient_count
			ll_sts = sqlca.jmj_order_message_recipient(ll_dispatched_patient_workplan_item_id, lstra_recipients[i].user_id, current_scribe.user_id, ll_patient_workplan_item_id, lstra_recipients[i].document_route)
			if not tf_check() then
				f_please_wait_close(li_please_wait)
				return -1
			end if
		next
		
		// Show the DistList message as "Sent"
		UPDATE p_Patient_WP_Item
		SET status = 'Sent'
		WHERE patient_workplan_item_id = :ll_dispatched_patient_workplan_item_id;
		if not tf_check() then
			f_please_wait_close(li_please_wait)
			return -1
		end if
	end if
	
	// If we're supposed to add this message to the notes, then create the
	// appropriate progress_note record
	// Only do this if we ordering this from a specific patient context
	if not isnull(progress_type) and patient_count = 0 then
		ls_message = f_remove_trailing_white_space(mle_message.text)
		ls_progress_key = sle_subject.text
		
		CHOOSE CASE lower(service.context_object)
			CASE "patient"
				current_patient.set_progress(progress_type, ls_progress_key, ldt_progress_date_time, ls_message, ll_risk_level)
			CASE "encounter"
				current_patient.encounters.set_encounter_progress(service.encounter_id, progress_type, ls_progress_key, ls_message)
			CASE "assessment"
				current_patient.assessments.set_progress(service.problem_id, progress_type, ls_progress_key, ls_message)
			CASE "treatment"
				current_patient.treatments.set_treatment_progress(service.treatment_id, progress_type, ls_progress_key, ls_message)
		END CHOOSE
	end if
	
	f_please_wait_progress_bump(li_please_wait)
next

f_please_wait_close(li_please_wait)

return 1


end function

public function long order_service (string ps_cpr_id, long pl_encounter_id, string ps_service, string ps_ordered_for, string ps_description, integer pi_step_number, str_attributes pstr_attributes);long 							ll_patient_workplan_item_id
u_component_service 		luo_service
u_component_treatment	luo_treatment

setnull(luo_treatment)
luo_service = service_list.get_service_component(ps_service)
if isnull(luo_service) then
	log.log(this, "w_svc_compose_message.order_service:0008", "Error getting service component (" + ps_service + ")", 4)
	return -1
end if

if not isnull(current_service) then
	luo_service.treatment = current_service.treatment
else
	luo_service.treatment = luo_treatment
end if

ll_patient_workplan_item_id = luo_service.order_service(ps_cpr_id, pl_encounter_id, ps_ordered_for, pi_step_number, priority, ps_description, pstr_attributes)
if ll_patient_workplan_item_id <= 0 then
	log.log(this, "w_svc_compose_message.order_service:0020", "Error ordering service (" + ps_service + ")", 4)
	return -1
end if

component_manager.destroy_component(luo_service)
Return ll_patient_workplan_item_id


end function

public subroutine display_to_users (str_users pstr_to_users);long ll_row
string ls_actor_class
long i
long ll_rowcount
boolean lba_found[]
string ls_find
string ls_document_route
string ls_report_id
string ls_null
string ls_in_office_flag

setnull(ls_report_id)
setnull(ls_null)

if pstr_to_users.user_count <= 0 then
	dw_addressee.reset()
	ll_row = dw_addressee.insertrow(0)
	dw_addressee.object.user_full_name[ll_row] = ""
	dw_addressee.object.color[ll_row] = color_object
	if in_office_flag = "Y" then
		dw_addressee.object.document_route[ll_row] = "Office View"
	else
		dw_addressee.object.document_route[ll_row] = "Inbox"
	end if
	cb_expand.visible = false
	return
end if

ll_rowcount = dw_addressee.rowcount()
for i = 1 to ll_rowcount
	lba_found[i] = false
next

for i = 1 to pstr_to_users.user_count
	ls_find = "user_id='" + pstr_to_users.user[i].user_id + "'"
	ll_row = dw_addressee.find(ls_find, 1, ll_rowcount)
	if ll_row > 0 then
		lba_found[ll_row] = true
		ls_actor_class = dw_addressee.object.actor_class[ll_row]
	else
		ll_row = dw_addressee.insertrow(0)
		ls_actor_class = user_list.user_property(pstr_to_users.user[i].user_id, "actor_class")
		dw_addressee.object.user_id[ll_row] = pstr_to_users.user[i].user_id
		dw_addressee.object.actor_class[ll_row] = ls_actor_class
		if allow_multiple_recipients then dw_addressee.object.allow_multiple[ll_row] = 1
		if lower(ls_actor_class) = "user" or lower(ls_actor_class) = "role" or lower(ls_actor_class) = "system" or lower(ls_actor_class) = "special" then
			if in_office_flag = "Y" then
				dw_addressee.object.document_route[ll_row] = "Office View"
				dw_addressee.object.allow_route_choice[ll_row] = "Y"
			else
				dw_addressee.object.document_route[ll_row] = "Inbox"
				dw_addressee.object.allow_route_choice[ll_row] = "N"
			end if
		else
			dw_addressee.object.allow_route_choice[ll_row] = "Y"
			setnull(ls_document_route)
			SELECT document_route
			INTO :ls_document_route
			FROM dbo.fn_document_default_recipient(:service.cpr_id ,
													:service.encounter_id ,
													:message_object ,
													:message_object_key ,
													:ls_report_id ,
													:message_purpose ,
													:current_user.user_id ,
													:pstr_to_users.user[i].user_id ,
													:ls_null);
			if not tf_check() then return
			
			dw_addressee.object.document_route[ll_row] = ls_document_route
		end if
	end if
	dw_addressee.object.user_full_name[ll_row] = pstr_to_users.user[i].user_full_name
	dw_addressee.object.user_short_name[i] = pstr_to_users.user[i].user_short_name
	dw_addressee.object.color[ll_row] = pstr_to_users.user[i].color
next

// Finally, remove any users that weren't found
for i = ll_rowcount to 1 step -1
	if not lba_found[i] then
		dw_addressee.deleterow(i)
	end if
next

ll_row = long(dw_addressee.object.DataWindow.LastRowOnPage)
if ll_row < ll_rowcount then
	cb_expand.visible = true
else
	cb_expand.visible = false
end if


//if pstr_to_users.user_count <= 0 then
//	st_recipient.text = ""
//	st_recipient.backcolor = color_object
//elseif pstr_to_users.user_count = 1 then
//	st_recipient.text = pstr_to_users.user[1].user_full_name
//	st_recipient.backcolor = pstr_to_users.user[1].color
//else
//	st_recipient.text = "<Distribution List>"
//	st_recipient.backcolor = color_object
//end if
//
end subroutine

public function str_users get_to_users ();// Get the to_users list from the datawindow
long i
str_users lstr_to_users
string ls_user_id

lstr_to_users.user_count = dw_addressee.rowcount()

// Make sure the single record isn't a placeholder
if lstr_to_users.user_count = 1 then
	ls_user_id = dw_addressee.object.user_id[1]
	if isnull(ls_user_id) then
		lstr_to_users.user_count = 0
		return lstr_to_users
	end if
end if

for i = 1 to lstr_to_users.user_count
	lstr_to_users.user[i].user_id = dw_addressee.object.user_id[i]
	lstr_to_users.user[i].user_full_name = dw_addressee.object.user_full_name[i]
	lstr_to_users.user[i].user_short_name = dw_addressee.object.user_short_name[i]
	lstr_to_users.user[i].color = dw_addressee.object.color[i]
next

return lstr_to_users

end function

public subroutine add_recipient (ref integer pi_recipient_count, ref str_recipient pstra_recipients[], string ps_new_recipient, string ps_document_route);integer i

for i = 1 to pi_recipient_count
	if ps_new_recipient = pstra_recipients[i].user_id then return
next

pi_recipient_count += 1
pstra_recipients[pi_recipient_count].user_id = ps_new_recipient
pstra_recipients[pi_recipient_count].document_route = ps_document_route

end subroutine

on w_svc_compose_message.create
int iCurrent
call super::create
this.st_subject_title=create st_subject_title
this.sle_subject=create sle_subject
this.st_3=create st_3
this.st_message_title=create st_message_title
this.mle_message=create mle_message
this.st_patient_title=create st_patient_title
this.st_patient=create st_patient
this.cb_send=create cb_send
this.cb_cancel=create cb_cancel
this.cb_subject=create cb_subject
this.cb_body=create cb_body
this.st_item_title=create st_item_title
this.st_item=create st_item
this.cb_expand=create cb_expand
this.dw_addressee=create dw_addressee
this.st_title=create st_title
this.st_priority_title=create st_priority_title
this.st_priority=create st_priority
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_subject_title
this.Control[iCurrent+2]=this.sle_subject
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_message_title
this.Control[iCurrent+5]=this.mle_message
this.Control[iCurrent+6]=this.st_patient_title
this.Control[iCurrent+7]=this.st_patient
this.Control[iCurrent+8]=this.cb_send
this.Control[iCurrent+9]=this.cb_cancel
this.Control[iCurrent+10]=this.cb_subject
this.Control[iCurrent+11]=this.cb_body
this.Control[iCurrent+12]=this.st_item_title
this.Control[iCurrent+13]=this.st_item
this.Control[iCurrent+14]=this.cb_expand
this.Control[iCurrent+15]=this.dw_addressee
this.Control[iCurrent+16]=this.st_title
this.Control[iCurrent+17]=this.st_priority_title
this.Control[iCurrent+18]=this.st_priority
end on

on w_svc_compose_message.destroy
call super::destroy
destroy(this.st_subject_title)
destroy(this.sle_subject)
destroy(this.st_3)
destroy(this.st_message_title)
destroy(this.mle_message)
destroy(this.st_patient_title)
destroy(this.st_patient)
destroy(this.cb_send)
destroy(this.cb_cancel)
destroy(this.cb_subject)
destroy(this.cb_body)
destroy(this.st_item_title)
destroy(this.st_item)
destroy(this.cb_expand)
destroy(this.dw_addressee)
destroy(this.st_title)
destroy(this.st_priority_title)
destroy(this.st_priority)
end on

event open;call super::open;string ls_subject
string ls_message
integer li_null
string ls_null
string ls_to_user_id
integer li_sts
str_popup_return popup_return
boolean lb_auto_send
string ls_context_object
long ll_object_key
string ls_requested_in_office_flag
string ls_service_description
string ls_patients
str_users lstr_to_users

popup_return.item_count = 1
popup_return.items[1] = "ERROR"

setnull(li_null)
setnull(ls_null)

service = message.powerobjectparm

if lower(service.item_type) = "document" then
	message_service = "Document"
else
	message_service = service.get_attribute("message_service")
	if isnull(message_service) then message_service = "MESSAGE"
end if

if upper(message_service) = "MESSAGE" then
	allow_multiple_recipients = true
	dw_addressee.border = true
	st_patient_title.visible = false
	st_patient.visible = false
	setnull(priority)
else
	allow_multiple_recipients = false
	dw_addressee.border = false
	dw_addressee.object.user_full_name.height = 96
	dw_addressee.object.document_route.height = 96
	dw_addressee.object.datawindow.detail.height = 116
	st_patient_title.visible = true
	st_patient.visible = true
	service.get_attribute("message_priority", priority)
end if

progress_type = service.get_attribute("progress_type")

if upper(message_service) = "MESSAGE" then
	st_title.text = "Compose Message"
else
	ls_service_description = datalist.service_description(message_service)
	st_title.text = "Compose " + ls_service_description
end if

ls_subject = service.get_attribute("message_subject")
ls_message = service.get_attribute("message")
ls_to_user_id = service.get_attribute("to_user_id")
if isnull(ls_to_user_id) then
	lstr_to_users.user_count = 0
else
	li_sts = user_list.get_user(ls_to_user_id, lstr_to_users.user[1])
	if li_sts <= 0 then
		lstr_to_users.user_count = 0
	else
		lstr_to_users.user_count = 1
	end if
end if

if isnull(ls_subject) or trim(ls_subject) = "" then
	sle_subject.setfocus()
else
	sle_subject.text = ls_subject
	mle_message.setfocus()
end if

if not isnull(ls_message) then mle_message.text = ls_message

ls_patients = service.get_attribute("patient_list")
if len(ls_patients) > 0 then
	patient_count = f_parse_string(ls_patients, "|", patient_list)
end if

if patient_count > 0 then
	st_patient.text = "Patient List"
else
	if isnull(current_patient) then
		st_patient.text = ls_null
		setnull(message_object)
	else
		st_patient.text = current_patient.name()
	end if
end if

top_20_prefix = "MSG_" + message_service

open_encounter_context = false
ls_requested_in_office_flag = service.get_attribute("message_in_office_flag")

if isnull(current_patient) or patient_count > 0 then
	setnull(message_object)
else
	message_object = service.get_attribute("message_object")
	if isnull(message_object) then message_object = service.context_object

	top_20_prefix += "_" + upper(message_object)
	// Now make sure we have the right attributes for the message object
	f_attribute_add_attribute(message_attributes, "message_object", message_object)

	CHOOSE CASE lower(message_object)
//		CASE "observation"
//			if isnull(service.observation_sequence) then
//				log.log(this, "w_svc_compose_message:open", "Null observation_sequence", 4)
//				closewithreturn(this, popup_return)
//				return
//			end if
//			message_attributes.attribute[2].attribute = "observation_sequence"
//			message_attributes.attribute[2].value = string(service.observation_sequence)
		CASE "treatment"
			if isnull(service.treatment) then
				log.log(this, "w_svc_compose_message:open", "Null treatment_id", 4)
				closewithreturn(this, popup_return)
				return
			end if
			
			f_attribute_add_attribute(message_attributes, "treatment_id", string(service.treatment_id))
			
			st_item.text = service.treatment.treatment_description
			message_object_key = service.treatment_id
		CASE "assessment"
			if isnull(service.problem_id) then
				log.log(this, "w_svc_compose_message:open", "Null problem_id", 4)
				closewithreturn(this, popup_return)
				return
			end if

			f_attribute_add_attribute(message_attributes, "problem_id", string(service.problem_id))
			
			st_item.text = current_patient.assessments.assessment_description(service.problem_id, li_null)
			message_object_key = service.problem_id
		CASE "encounter"
			if isnull(service.encounter_id) then
				log.log(this, "w_svc_compose_message:open", "Null encounter_id", 4)
				closewithreturn(this, popup_return)
				return
			end if
			
			f_attribute_add_attribute(message_attributes, "encounter_id", string(service.encounter_id))
			
			st_item.text = current_patient.encounters.encounter_description(service.encounter_id)
			message_object_key = service.encounter_id
		CASE "patient"
			f_attribute_add_attribute(message_attributes, "cpr_id", current_patient.cpr_id)
			setnull(message_object_key)
		CASE "attachment"
			f_attribute_add_attribute(message_attributes, "attachment_id", string(service.attachment_id))
			
			st_item.text = current_patient.attachments.description(service.attachment_id)
			message_object_key = service.attachment_id
		CASE ELSE
			log.log(this, "w_svc_compose_message:open", "Invalid message_object (" + message_object + ")", 4)
			closewithreturn(this, popup_return)
			return
	END CHOOSE
	
	
	if not isnull(service.encounter_id) then
		open_encounter_context = current_patient.encounters.is_encounter_open(service.encounter_id)
	end if
end if


if open_encounter_context then
	if isnull(ls_requested_in_office_flag) or ls_requested_in_office_flag = "Y" then
		in_office_flag = "Y"
	else
		in_office_flag = "N"
	end if
else
	if ls_requested_in_office_flag = "Y" then
		reverted_to_inbox = true
	end if
	in_office_flag = "N"
end if

service.get_attribute("auto_send", lb_auto_send)
if lb_auto_send or gnv_app.cpr_mode = "SERVER" then
	li_sts = send_message()
	
	if li_sts > 0 then
		popup_return.items[1] = "OK"
	else
		popup_return.items[1] = "ERROR"
	end if
	
	popup_return.item_count = 1
	closewithreturn(this, popup_return)
	return
end if

dw_addressee.object.user_full_name.width = dw_addressee.width - 789

collapse_height = dw_addressee.height

display_to_users(lstr_to_users)

postevent("post_open")



end event

event post_open;call super::post_open;
if reverted_to_inbox then
//	openwithparm(w_pop_message, "There is no open encounter context available so the Office View is not an option.  Reverting to InBox " + datalist.service_description(message_service) + ".")
end if



end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_compose_message
integer x = 2857
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_compose_message
integer y = 1504
end type

type st_subject_title from statictext within w_svc_compose_message
integer x = 101
integer y = 728
integer width = 343
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Subject:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_subject from singlelineedit within w_svc_compose_message
integer x = 471
integer y = 720
integer width = 2194
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_svc_compose_message
integer x = 197
integer y = 140
integer width = 247
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "To:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_message_title from statictext within w_svc_compose_message
integer x = 101
integer y = 876
integer width = 343
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Message:"
alignment alignment = right!
boolean focusrectangle = false
end type

type mle_message from multilineedit within w_svc_compose_message
integer x = 471
integer y = 848
integer width = 2194
integer height = 656
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
boolean autovscroll = true
borderstyle borderstyle = stylelowered!
end type

type st_patient_title from statictext within w_svc_compose_message
integer x = 101
integer y = 476
integer width = 343
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Patient:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_patient from statictext within w_svc_compose_message
integer x = 471
integer y = 468
integer width = 1280
integer height = 88
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type cb_send from commandbutton within w_svc_compose_message
integer x = 2309
integer y = 1608
integer width = 498
integer height = 108
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Send"
end type

event clicked;integer li_sts
str_popup_return popup_return

li_sts = send_message()

if li_sts <= 0 then return

popup_return.item_count = 1
popup_return.items[1] = "OK"
closewithreturn(parent, popup_return)

end event

type cb_cancel from commandbutton within w_svc_compose_message
integer x = 1801
integer y = 1608
integer width = 402
integer height = 112
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;integer li_sts
str_popup_return popup_return

popup_return.item_count = 1
popup_return.items[1] = "CANCEL"
closewithreturn(parent, popup_return)

end event

type cb_subject from commandbutton within w_svc_compose_message
integer x = 2679
integer y = 716
integer width = 128
integer height = 100
integer taborder = 30
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

popup.title = "Select Message Subject"
popup.data_row_count = 2
popup.items[1] = top_20_prefix + "_SUBJECT"
popup.items[2] = ""
openwithparm(w_pick_top_20_multiline, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

sle_subject.text = popup_return.items[1]

mle_message.setfocus()

end event

type cb_body from commandbutton within w_svc_compose_message
integer x = 2679
integer y = 1404
integer width = 128
integer height = 100
integer taborder = 40
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

popup.title = "Select Message Body"
popup.data_row_count = 2
popup.items[1] = top_20_prefix + "_BODY"
popup.items[2] = ""
openwithparm(w_pick_top_20_multiline, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

mle_message.replacetext(popup_return.items[1])

mle_message.setfocus()

end event

type st_item_title from statictext within w_svc_compose_message
integer x = 101
integer y = 604
integer width = 343
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Item:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_item from statictext within w_svc_compose_message
integer x = 471
integer y = 596
integer width = 2194
integer height = 88
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type cb_expand from commandbutton within w_svc_compose_message
integer x = 2683
integer y = 124
integer width = 96
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "V"
end type

event clicked;if collapse_height = dw_addressee.height then
	dw_addressee.height = cb_send.y - 100 - dw_addressee.y
else
	dw_addressee.height = collapse_height
end if

end event

type dw_addressee from u_dw_pick_list within w_svc_compose_message
integer x = 471
integer y = 124
integer width = 2194
integer height = 300
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_addressee_list"
boolean vscrollbar = true
end type

event buttonclicked;call super::buttonclicked;long ll_row

deleterow(row)
if rowcount() = 0 then
	ll_row = dw_addressee.insertrow(0)
	dw_addressee.object.user_full_name[ll_row] = ""
	dw_addressee.object.color[ll_row] = color_object
	if in_office_flag = "Y" then
		dw_addressee.object.document_route[ll_row] = "Office View"
	else
		dw_addressee.object.document_route[ll_row] = "Inbox"
	end if
	cb_expand.visible = false
end if

end event

event selected;call super::selected;u_user luo_user
str_pick_users lstr_pick_users
integer li_sts
string ls_actor_class
string ls_document_route
str_users lstr_to_users
string ls_report_id
string ls_ordered_for
str_popup popup
str_popup_return popup_return

if lastcolumnname = "user_full_name" then
	lstr_pick_users.cpr_id = service.cpr_id
	if upper(message_service) = "MESSAGE" or upper(message_service) = "DOCUMENT" then
		lstr_pick_users.actor_class = "Consultant"
	else
		setnull(lstr_pick_users.actor_class)
	end if
	lstr_pick_users.allow_roles = true
	lstr_pick_users.allow_system_users = false
	lstr_pick_users.allow_special_users = false
	lstr_pick_users.allow_support = user_list.is_user_privileged(current_scribe.user_id, "Interact With Support")
	lstr_pick_users.allow_multiple = allow_multiple_recipients
	lstr_pick_users.selected_users = get_to_users()
	
	li_sts = user_list.pick_users(lstr_pick_users)
	
	lstr_to_users = lstr_pick_users.selected_users
	if lstr_to_users.user_count > 0 then
		display_to_users(lstr_to_users)
		
		if isnull(sle_subject.text) or trim(sle_subject.text) = "" then
			sle_subject.setfocus()
		else
			mle_message.setfocus()
		end if
	end if
elseif lastcolumnname = "document_route" then
	ls_ordered_for = dw_addressee.object.user_id[selected_row]
	ls_actor_class = dw_addressee.object.actor_class[selected_row]
	ls_document_route = dw_addressee.object.document_route[selected_row]
	if lower(ls_actor_class) = "user" or lower(ls_actor_class) = "role" or lower(ls_actor_class) = "system" or lower(ls_actor_class) = "special" then
		if lower(ls_document_route) = "inbox" and in_office_flag = "Y" then
			dw_addressee.object.document_route[selected_row] = "Office View"
		else
			dw_addressee.object.document_route[selected_row] = "Inbox"
		end if
	else
		// Show the choices for this actor
		setnull(ls_report_id)
		
		popup.dataobject = "dw_document_valid_routes_pick"
		popup.datacolumn = 1
		popup.displaycolumn = 1
		popup.auto_singleton = false
		popup.add_blank_row = true
		popup.blank_text = "<Show All Routes>"
		popup.blank_at_bottom = true
		popup.argument_count = 5
		popup.argument[1] = current_user.user_id
		popup.argument[2] = ls_ordered_for
		popup.argument[3] = message_purpose
		popup.argument[4] = service.cpr_id
		popup.argument[5] = ls_report_id
		openwithparm(w_pop_pick, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count = 1 then
			if popup_return.items[1] = "" then
				// There were no choices so show the routes
				popup.data_row_count = 5
				popup.title = "All Routes"
				popup.add_blank_row = false
				popup.items[1] = current_user.user_id
				popup.items[2] = ls_ordered_for
				popup.items[3] = message_purpose
				popup.items[4] = service.cpr_id
				popup.items[5] = ls_report_id
				openwithparm(w_pop_document_routes, popup)
			else
				dw_addressee.object.document_route[selected_row] = popup_return.items[1]
			end if
		end if
		
		if popup_return.choices_count <= 0 then
			// There were no choices so show the routes
			popup.data_row_count = 5
			popup.title = "No valid Routes"
			popup.items[1] = current_user.user_id
			popup.items[2] = ls_ordered_for
			popup.items[3] = message_purpose
			popup.items[4] = service.cpr_id
			popup.items[5] = ls_report_id
			openwithparm(w_pop_document_routes, popup)
		end if
	end if
end if

clear_selected()
end event

type st_title from statictext within w_svc_compose_message
integer width = 2921
integer height = 124
boolean bringtotop = true
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Compose Message"
alignment alignment = center!
boolean focusrectangle = false
boolean righttoleft = true
end type

type st_priority_title from statictext within w_svc_compose_message
integer x = 1906
integer y = 476
integer width = 343
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Priority:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_priority from statictext within w_svc_compose_message
integer x = 2267
integer y = 468
integer width = 398
integer height = 88
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "N/A"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string ls_bitmap
str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_domain_pick_list"
popup.datacolumn = 2
popup.displaycolumn = 3
popup.argument_count = 1
popup.argument[1] = "Workplan Item Priority"
popup.add_blank_row = true
popup.blank_text = "N/A"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count = 0 then return

text = popup_return.descriptions[1]

if popup_return.items[1] = "" then
	setnull(priority)
else
	priority = integer(popup_return.items[1])
end if


end event

