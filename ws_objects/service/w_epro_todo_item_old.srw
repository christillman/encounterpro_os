HA$PBExportHeader$w_epro_todo_item_old.srw
forward
global type w_epro_todo_item_old from w_window_base
end type
type dw_message from datawindow within w_epro_todo_item_old
end type
type cb_forward from commandbutton within w_epro_todo_item_old
end type
type cb_leave_for_role from commandbutton within w_epro_todo_item_old
end type
type cb_finished from commandbutton within w_epro_todo_item_old
end type
type mle_disposition from multilineedit within w_epro_todo_item_old
end type
type cb_dolater from commandbutton within w_epro_todo_item_old
end type
type cb_beback from commandbutton within w_epro_todo_item_old
end type
type st_message_title from statictext within w_epro_todo_item_old
end type
type st_message from statictext within w_epro_todo_item_old
end type
type st_disposition_title from statictext within w_epro_todo_item_old
end type
type st_more from statictext within w_epro_todo_item_old
end type
type st_title from statictext within w_epro_todo_item_old
end type
type cb_body from commandbutton within w_epro_todo_item_old
end type
type cb_cancel from commandbutton within w_epro_todo_item_old
end type
type cb_reply from commandbutton within w_epro_todo_item_old
end type
end forward

global type w_epro_todo_item_old from w_window_base
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
dw_message dw_message
cb_forward cb_forward
cb_leave_for_role cb_leave_for_role
cb_finished cb_finished
mle_disposition mle_disposition
cb_dolater cb_dolater
cb_beback cb_beback
st_message_title st_message_title
st_message st_message
st_disposition_title st_disposition_title
st_more st_more
st_title st_title
cb_body cb_body
cb_cancel cb_cancel
cb_reply cb_reply
end type
global w_epro_todo_item_old w_epro_todo_item_old

type variables
u_component_service service

string chart_service
string assessment_service
string treatment_service
string encounter_service
string observation_service
string attachment_service
string message_service
string reply_with_service
string patient_service = "PATIENT_DATA"

string original_disposition

end variables

forward prototypes
public function integer get_message ()
public function integer update_message ()
public function integer set_progress ()
end prototypes

public function integer get_message ();string ls_cpr_id
string ls_patient_name
long ll_count
string ls_null
string ls_item_description

setnull(ls_null)

st_title.text = service.description

original_disposition = service.get_attribute("disposition")
mle_disposition.text = original_disposition

st_message.text = service.get_attribute("message")
if len(st_message.text) > 220 then
	st_more.visible = true
else
	st_more.visible = false
end if

dw_message.reset()
dw_message.insertrow(0)

dw_message.object.from_user[1] = user_list.user_full_name(service.ordered_by)
dw_message.object.from_user_color[1] = user_list.user_color(service.ordered_by)
dw_message.object.to_user[1] = user_list.user_full_name(service.ordered_for)
dw_message.object.to_user_color[1] = user_list.user_color(service.ordered_for)
dw_message.object.owner[1] = user_list.user_full_name(service.owned_by)
dw_message.object.owner_color[1] = user_list.user_color(service.owned_by)

dw_message.object.folder[1] = service.folder
dw_message.object.sent_date_time[1] = service.dispatch_date
dw_message.object.finished_date_time[1] = service.end_date

if isnull(current_patient) then
	dw_message.object.patient_name[1] = ls_null
else
	dw_message.object.patient_name[1] = current_patient.name()
end if

if not isnull(service.cpr_id) then
	state_attributes.attribute_count += 1
	state_attributes.attribute[state_attributes.attribute_count].attribute = "cpr_id"
	state_attributes.attribute[state_attributes.attribute_count].value = string(service.cpr_id)
end if

if isnull(service.context_object) then
	dw_message.object.item_description[1] = ls_null
else
	f_attribute_add_attribute(state_attributes, "context_object", service.context_object)
	
	CHOOSE CASE lower(service.context_object)
		CASE "encounter"
			ls_item_description = current_patient.encounters.encounter_description(service.encounter_id)
			f_attribute_add_attribute(state_attributes, "encounter_id", string(service.encounter_id))
		CASE "assessment"
			ls_item_description = current_patient.assessments.assessment_description(service.problem_id)
			f_attribute_add_attribute(state_attributes, "problem_id", string(service.problem_id))
		CASE "treatment"
			ls_item_description = service.treatment.treatment_description
			f_attribute_add_attribute(state_attributes, "treatment_id", string(service.treatment_id))
		CASE "observation"
			ls_item_description = service.description
			f_attribute_add_attribute(state_attributes, "observation_sequence", string(service.observation_sequence))
		CASE "attachment"
			ls_item_description = current_patient.attachments.description(service.attachment_id)
			f_attribute_add_attribute(state_attributes, "attachment_id", string(service.attachment_id))
		CASE ELSE
			ls_item_description = ls_null
	END CHOOSE
	
	dw_message.object.item_description[1] = ls_item_description
end if


return 1

end function

public function integer update_message ();String	ls_attribute,ls_value
String	ls_cpr_id

If f_string_modified(original_disposition, mle_disposition.text) Then
	service.add_attribute( "Disposition", mle_disposition.text)
End If

Return 1


end function

public function integer set_progress ();integer li_sts
string ls_severity
long ll_attachment_id
integer li_diagnosis_sequence
u_attachment_list luo_attachment_list
string ls_progress_type
string ls_progress_key
datetime ldt_progress_date_time
string ls_progress
long ll_risk_level

setnull(ls_severity)
setnull(ll_attachment_id)
setnull(li_diagnosis_sequence)
setnull(luo_attachment_list)
setnull(ll_risk_level)

ls_progress_type = service.get_attribute("progress_type")
ls_progress_key = service.get_attribute("progress_key")
if isnull(ls_progress_type) or isnull(ls_progress_key) then return 0

ls_progress = mle_disposition.text
ldt_progress_date_time = datetime(today(), now())

CHOOSE CASE lower(service.context_object)
	CASE "patient"
		li_sts = current_patient.set_progress(ls_progress_type, ls_progress_key, ldt_progress_date_time, ls_progress, ll_risk_level)
	CASE "encounter"
		li_sts = current_patient.encounters.set_encounter_progress(service.object_key, &
																						ls_progress_type, &
																						ls_progress_key, &
																						ls_progress, &
																						ll_risk_level, &
																						ldt_progress_date_time, &
																						luo_attachment_list)
	CASE "assessment"
		li_sts = current_patient.assessments.set_progress(service.object_key, &
																			ldt_progress_date_time, &
																			li_diagnosis_sequence, &
																			ls_progress_type, &
																			ls_progress_key, &
																			ls_progress, &
																			ls_severity, &
																			ll_attachment_id, &
																			ll_risk_level)
	CASE "treatment"
		li_sts = current_patient.treatments.set_treatment_progress(service.object_key, &
																					ls_progress_type, &
																					ls_progress_key, &
																					ls_progress, &
																					ldt_progress_date_time, &
																					ll_risk_level)
END CHOOSE
		
return li_sts

end function

on w_epro_todo_item_old.create
int iCurrent
call super::create
this.dw_message=create dw_message
this.cb_forward=create cb_forward
this.cb_leave_for_role=create cb_leave_for_role
this.cb_finished=create cb_finished
this.mle_disposition=create mle_disposition
this.cb_dolater=create cb_dolater
this.cb_beback=create cb_beback
this.st_message_title=create st_message_title
this.st_message=create st_message
this.st_disposition_title=create st_disposition_title
this.st_more=create st_more
this.st_title=create st_title
this.cb_body=create cb_body
this.cb_cancel=create cb_cancel
this.cb_reply=create cb_reply
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_message
this.Control[iCurrent+2]=this.cb_forward
this.Control[iCurrent+3]=this.cb_leave_for_role
this.Control[iCurrent+4]=this.cb_finished
this.Control[iCurrent+5]=this.mle_disposition
this.Control[iCurrent+6]=this.cb_dolater
this.Control[iCurrent+7]=this.cb_beback
this.Control[iCurrent+8]=this.st_message_title
this.Control[iCurrent+9]=this.st_message
this.Control[iCurrent+10]=this.st_disposition_title
this.Control[iCurrent+11]=this.st_more
this.Control[iCurrent+12]=this.st_title
this.Control[iCurrent+13]=this.cb_body
this.Control[iCurrent+14]=this.cb_cancel
this.Control[iCurrent+15]=this.cb_reply
end on

on w_epro_todo_item_old.destroy
call super::destroy
destroy(this.dw_message)
destroy(this.cb_forward)
destroy(this.cb_leave_for_role)
destroy(this.cb_finished)
destroy(this.mle_disposition)
destroy(this.cb_dolater)
destroy(this.cb_beback)
destroy(this.st_message_title)
destroy(this.st_message)
destroy(this.st_disposition_title)
destroy(this.st_more)
destroy(this.st_title)
destroy(this.cb_body)
destroy(this.cb_cancel)
destroy(this.cb_reply)
end on

event open;call super::open;long ll_rows
long i
string ls_treatment_type
str_popup_return popup_return
integer li_sts

service = message.powerobjectparm

chart_service = service.get_attribute("chart_service")
if isnull(chart_service) then chart_service = "CHART"

assessment_service = service.get_attribute("assessment_service")
if isnull(assessment_service) then assessment_service = "ASSESSMENT_REVIEW"

treatment_service = service.get_attribute("treatment_service")
if isnull(treatment_service) then treatment_service = "TREATMENT_REVIEW"

encounter_service = service.get_attribute("encounter_service")
if isnull(encounter_service) then encounter_service = "CHART"

observation_service = service.get_attribute("observation_service")
if isnull(observation_service) then observation_service = "TREATMENT_REVIEW"

attachment_service = service.get_attribute("attachment_service")
if isnull(attachment_service) then attachment_service = "ATTACHMENT"

message_service = service.get_attribute("message_service")
if isnull(message_service) then message_service = "SENDMESSAGE"

reply_with_service = service.get_attribute("reply_with_service")
if isnull(reply_with_service) then reply_with_service = "MESSAGE"

// Prepare popup_return for error return
popup_return.item_count = 1
popup_return.items[1] = "ERROR"

if left(service.ordered_for, 1) = "!" then
	// Ordered for a role
	cb_leave_for_role.visible = true
else
	cb_leave_for_role.visible = false
end if

li_sts = get_message()
if li_sts <= 0 then
	log.log(this, "open", "Error retrieving message (" + string(service.patient_workplan_item_id) + ")", 4)
	closewithreturn(this, popup_return)
	return
end if

service.set_service_buttons(cb_finished, cb_beback, cb_dolater)

if upper(service.status) <> "COMPLETED" and upper(service.status) <> "CANCELLED" then
	cb_cancel.visible = true
else
	cb_cancel.visible = false
end if


end event

type pb_epro_help from w_window_base`pb_epro_help within w_epro_todo_item_old
boolean visible = true
integer x = 2674
integer y = 136
integer width = 247
integer height = 120
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_epro_todo_item_old
integer y = 1632
end type

type dw_message from datawindow within w_epro_todo_item_old
integer x = 197
integer y = 256
integer width = 2533
integer height = 552
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_todo_item_header"
borderstyle borderstyle = stylelowered!
end type

event clicked;string ls_service
str_attributes lstr_attributes
integer li_sts

if isnull(dwo) or not isvalid(dwo) then return
if row <= 0 or isnull(row) then return

lstr_attributes = state_attributes

CHOOSE CASE upper(dwo.name)
	CASE "PATIENT_NAME"
		ls_service = chart_service
	CASE "ITEM_DESCRIPTION"
		CHOOSE CASE lower(service.context_object)
			CASE "treatment"
				ls_service = treatment_service
			CASE "assessment"
				ls_service = assessment_service
			CASE "observation"
				ls_service = observation_service
			CASE "attachment"
				ls_service = attachment_service
			CASE ELSE
				ls_service = chart_service
		END CHOOSE
	CASE ELSE
		return
END CHOOSE

li_sts = service_list.do_service(ls_service, lstr_attributes)
if li_sts <= 0 then return


end event

event buttonclicked;string ls_service
str_attributes lstr_attributes
integer li_sts

if isnull(dwo) or not isvalid(dwo) then return
if row <= 0 or isnull(row) then return

lstr_attributes = state_attributes

CHOOSE CASE upper(dwo.name)
	CASE "B_VIEW_PATIENT"
		ls_service = patient_service
	CASE "B_VIEW_CHART"
		ls_service = chart_service
	CASE "B_OPEN_ITEM"
		CHOOSE CASE lower(service.context_object)
			CASE "treatment"
				ls_service = treatment_service
			CASE "assessment"
				ls_service = assessment_service
			CASE "observation"
				ls_service = observation_service
			CASE "attachment"
				ls_service = attachment_service
			CASE ELSE
				ls_service = chart_service
		END CHOOSE
	CASE ELSE
		return
END CHOOSE

li_sts = service_list.do_service(ls_service, lstr_attributes)
if li_sts <= 0 then return


end event

type cb_forward from commandbutton within w_epro_todo_item_old
integer x = 55
integer y = 1688
integer width = 535
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Forward This"
end type

event clicked;string ls_description
string ls_service
string ls_todo_user_id
integer 				li_sts
str_popup 			popup
str_popup_return 	popup_return
u_user 				luo_user
string ls_new_message
string ls_user_tag
string ls_cpr_id
long ll_patient_workplan_id

setnull(ls_cpr_id)
setnull(ll_patient_workplan_id)

// First prepare the new message text
If len(mle_disposition.text) > 0 then
	// For forwarding, treat the disposition text as additional message text
	ls_user_tag = string(service.dispatch_date, date_format_string + " hh:mm") + " " + current_user.user_full_name
	ls_new_message = "<<" + ls_user_tag + " Wrote:>>~r~n~r~n" + mle_disposition.text + "~r~n~r~n"
else
	ls_new_message = ""
End If

if len(st_message.text) > 0 then
	ls_new_message += "<<Original Message:>>~r~n~r~n" + st_message.text
end if

if ls_new_message = "" then setnull(ls_new_message)

luo_user = user_list.pick_user("ALL", true)
If isnull(luo_user) then return

setnull(ls_description)
setnull(ls_service)

// Forward the todo service to the specified user with the new message attached
sqlca.sp_forward_todo_service( &
		service.patient_workplan_item_id, &
		current_user.user_id, &
		luo_user.user_id, &
		ls_description, &
		ls_service, &
		current_user.user_id, &
		ls_new_message)
if not tf_check() then Return -1

// Log the disposition of this todo item as "Forwarded to ..."
sqlca.sp_add_workplan_item_attribute( &
		ls_cpr_id, &
		ll_patient_workplan_id, &
		service.patient_workplan_item_id, &
		"disposition", &
		"Forwarded to " + luo_user.user_full_name, &
		current_scribe.user_id, &
		current_user.user_id)

popup_return.item_count = 1
popup_return.items[1] = "COMPLETE"

Closewithreturn(parent, popup_return)


end event

type cb_leave_for_role from commandbutton within w_epro_todo_item_old
integer x = 617
integer y = 1688
integer width = 430
integer height = 108
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Leave For Role"
end type

event clicked;integer 				li_sts
str_popup_return 	popup_return


li_sts = update_message()
if li_sts <= 0 then return

popup_return.item_count = 1
popup_return.items[1] = "REVERT"

closewithreturn(parent, popup_return)

end event

type cb_finished from commandbutton within w_epro_todo_item_old
integer x = 2322
integer y = 1688
integer width = 503
integer height = 108
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I~'m Finished"
end type

event clicked;str_popup_return popup_return
integer li_sts

li_sts = update_message()
if li_sts <= 0 then return

if upper(service.status) <> "COMPLETED" and upper(service.status) <> "CANCELLED" then
	li_sts = set_progress()
	If li_sts < 0 then return
end if

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)

end event

type mle_disposition from multilineedit within w_epro_todo_item_old
integer x = 466
integer y = 1136
integer width = 2263
integer height = 492
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
boolean vscrollbar = true
boolean autovscroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_dolater from commandbutton within w_epro_todo_item_old
integer x = 1490
integer y = 1688
integer width = 389
integer height = 108
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I~'ll Do Later"
end type

event clicked;str_popup_return popup_return
integer li_sts

li_sts = update_message()
if li_sts <= 0 then return

popup_return.item_count = 1
popup_return.items[1] = "DOLATER"

closewithreturn(parent, popup_return)

end event

type cb_beback from commandbutton within w_epro_todo_item_old
integer x = 1906
integer y = 1688
integer width = 389
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I~'ll Be Back"
boolean cancel = true
end type

event clicked;str_popup_return popup_return
integer li_sts

li_sts = update_message()
if li_sts <= 0 then return

popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

type st_message_title from statictext within w_epro_todo_item_old
integer x = 9
integer y = 828
integer width = 448
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
string text = "Todo Message:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_message from statictext within w_epro_todo_item_old
integer x = 466
integer y = 836
integer width = 2263
integer height = 280
boolean bringtotop = true
integer textsize = -10
integer weight = 400
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

event clicked;str_popup popup

popup.data_row_count = 1
popup.title = "Todo Message"
popup.items[1] = text
openwithparm(w_display_large_string, popup)

end event

type st_disposition_title from statictext within w_epro_todo_item_old
integer x = 87
integer y = 1136
integer width = 370
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
string text = "Disposition:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_more from statictext within w_epro_todo_item_old
integer x = 2482
integer y = 1048
integer width = 233
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "<More>"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_title from statictext within w_epro_todo_item_old
integer width = 2912
integer height = 232
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "EncounterPRO Todo Item"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_body from commandbutton within w_epro_todo_item_old
integer x = 2743
integer y = 1536
integer width = 128
integer height = 100
integer taborder = 50
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

popup.title = "Select Disposition"
popup.data_row_count = 2
popup.items[1] = service.service + "_DISPOSITION"
popup.items[2] = ""
openwithparm(w_pick_top_20_multiline, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

mle_disposition.replacetext(popup_return.items[1])

mle_disposition.setfocus()

end event

type cb_cancel from commandbutton within w_epro_todo_item_old
integer x = 1074
integer y = 1688
integer width = 389
integer height = 108
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel item"
boolean cancel = true
end type

event clicked;str_popup_return popup_return
integer li_sts

if isnull(mle_disposition.text) or trim(mle_disposition.text) = "" then
	openwithparm(w_pop_message, "You must enter a disposition when you cancel a to-do item")
	return
end if

li_sts = update_message()
if li_sts <= 0 then return

popup_return.item_count = 1
popup_return.items[1] = "CANCEL"

closewithreturn(parent, popup_return)

end event

type cb_reply from commandbutton within w_epro_todo_item_old
integer x = 55
integer y = 1328
integer width = 379
integer height = 108
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Send Msg"
end type

event clicked;str_popup_return popup_return
string ls_message
string ls_subject
string ls_user_tag
str_attributes lstr_attributes
integer li_sts

lstr_attributes = state_attributes

if not isnull(st_message.text) and trim(st_message.text) <> "" then
	ls_user_tag = user_list.user_full_name(service.ordered_by)
	if isnull(ls_user_tag) or trim(ls_user_tag) = "" then
		ls_user_tag = "<Unknown>"
	end if
	
	ls_user_tag = string(service.dispatch_date, date_format_string + " hh:mm") + " " + ls_user_tag
	ls_message = "~r~n~r~n<<" + ls_user_tag + " Wrote:>>~r~n" + st_message.text
end if

ls_subject = service.description
if isnull(ls_subject) then ls_subject = ""
if upper(left(ls_subject, 3)) <> "RE:" then ls_subject = "RE: " + ls_subject

if not isnull(ls_subject) and trim(ls_subject) <> "" then
	f_attribute_add_attribute(lstr_attributes, "message_subject", ls_subject)
end if

if not isnull(ls_message) and trim(ls_message) <> "" then
	f_attribute_add_attribute(lstr_attributes, "message", ls_message)
end if

f_attribute_add_attribute(lstr_attributes, "to_user_id", service.ordered_by)
f_attribute_add_attribute(lstr_attributes, "message_service", reply_with_service)

li_sts = service_list.do_service(service.cpr_id, service.encounter_id, message_service, &
												lstr_attributes)
if li_sts <= 0 then return


end event

