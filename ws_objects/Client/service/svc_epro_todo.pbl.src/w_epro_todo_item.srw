$PBExportHeader$w_epro_todo_item.srw
forward
global type w_epro_todo_item from w_window_base
end type
type dw_message from datawindow within w_epro_todo_item
end type
type cb_forward from commandbutton within w_epro_todo_item
end type
type cb_finished from commandbutton within w_epro_todo_item
end type
type mle_disposition from multilineedit within w_epro_todo_item
end type
type cb_beback from commandbutton within w_epro_todo_item
end type
type st_message_title from statictext within w_epro_todo_item
end type
type st_message from statictext within w_epro_todo_item
end type
type st_disposition_title from statictext within w_epro_todo_item
end type
type cb_body from commandbutton within w_epro_todo_item
end type
type cb_reply from commandbutton within w_epro_todo_item
end type
type st_1 from statictext within w_epro_todo_item
end type
type sle_task from singlelineedit within w_epro_todo_item
end type
type cb_pick_description from commandbutton within w_epro_todo_item
end type
type mle_message from multilineedit within w_epro_todo_item
end type
type dw_comment_pick from u_dw_pick_list within w_epro_todo_item
end type
end forward

global type w_epro_todo_item from w_window_base
integer width = 2944
integer height = 1920
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean clientedge = true
boolean zoom_dw_on_resize = true
dw_message dw_message
cb_forward cb_forward
cb_finished cb_finished
mle_disposition mle_disposition
cb_beback cb_beback
st_message_title st_message_title
st_message st_message
st_disposition_title st_disposition_title
cb_body cb_body
cb_reply cb_reply
st_1 st_1
sle_task sle_task
cb_pick_description cb_pick_description
mle_message mle_message
dw_comment_pick dw_comment_pick
end type
global w_epro_todo_item w_epro_todo_item

type variables
u_component_service service

string chart_service
string assessment_service
string treatment_service
string encounter_service
string observation_service
string attachment_service
string message_service
string patient_service = "PATIENT_DATA"

string original_disposition

boolean read_only

string reply_to_user_id

string comment_top_20_code
string comment_top_20_user_id

end variables

forward prototypes
public function integer get_message ()
public function integer set_progress ()
end prototypes

public function integer get_message ();string ls_cpr_id
string ls_patient_name
long ll_count
string ls_null
string ls_item_description
u_ds_data luo_data
string ls_find
long ll_row
datetime ldt_sent_date_time
string ls_sent_by_name

setnull(ls_null)

luo_data = CREATE u_ds_data

sle_task.text = service.description

original_disposition = service.get_attribute("disposition")
if len(original_disposition) > 0 then
	mle_disposition.text = original_disposition
else
	mle_disposition.text = ""
end if

mle_message.text = f_get_service_messages(service.patient_workplan_item_id, false)

dw_message.reset()
dw_message.insertrow(0)

setnull(reply_to_user_id)
luo_data.set_dataobject("dw_p_patient_wp_item_attribute")
ll_count = luo_data.retrieve(service.patient_workplan_item_id)
if ll_count < 0 then return -1
if ll_count > 0 then
	ls_find = "lower(attribute)='forwarded_to_user_id'"
	// It's already sorted oldest to newest, so just get the first one
	ll_row = luo_data.find(ls_find, 1, ll_count)
	if ll_row > 0 then
		reply_to_user_id = luo_data.object.user_id[ll_row]
		ldt_sent_date_time = luo_data.object.created[ll_row]
	end if
end if

if isnull(reply_to_user_id) or reply_to_user_id = "" then
	reply_to_user_id = service.ordered_by
	ldt_sent_date_time = service.dispatch_date
end if

ls_sent_by_name = user_list.user_full_name(reply_to_user_id)
dw_message.object.sent_by[1] = ls_sent_by_name
dw_message.object.sent_date_time[1] = ldt_sent_date_time
if reply_to_user_id = current_user.user_id then
	cb_reply.visible = false
else
	cb_reply.text = "Reply to " + ls_sent_by_name
end if

dw_message.object.originated_by[1] = user_list.user_full_name(service.ordered_by)
dw_message.object.date_originated[1] = service.dispatch_date

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

DESTROY luo_data

return 1

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

on w_epro_todo_item.create
int iCurrent
call super::create
this.dw_message=create dw_message
this.cb_forward=create cb_forward
this.cb_finished=create cb_finished
this.mle_disposition=create mle_disposition
this.cb_beback=create cb_beback
this.st_message_title=create st_message_title
this.st_message=create st_message
this.st_disposition_title=create st_disposition_title
this.cb_body=create cb_body
this.cb_reply=create cb_reply
this.st_1=create st_1
this.sle_task=create sle_task
this.cb_pick_description=create cb_pick_description
this.mle_message=create mle_message
this.dw_comment_pick=create dw_comment_pick
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_message
this.Control[iCurrent+2]=this.cb_forward
this.Control[iCurrent+3]=this.cb_finished
this.Control[iCurrent+4]=this.mle_disposition
this.Control[iCurrent+5]=this.cb_beback
this.Control[iCurrent+6]=this.st_message_title
this.Control[iCurrent+7]=this.st_message
this.Control[iCurrent+8]=this.st_disposition_title
this.Control[iCurrent+9]=this.cb_body
this.Control[iCurrent+10]=this.cb_reply
this.Control[iCurrent+11]=this.st_1
this.Control[iCurrent+12]=this.sle_task
this.Control[iCurrent+13]=this.cb_pick_description
this.Control[iCurrent+14]=this.mle_message
this.Control[iCurrent+15]=this.dw_comment_pick
end on

on w_epro_todo_item.destroy
call super::destroy
destroy(this.dw_message)
destroy(this.cb_forward)
destroy(this.cb_finished)
destroy(this.mle_disposition)
destroy(this.cb_beback)
destroy(this.st_message_title)
destroy(this.st_message)
destroy(this.st_disposition_title)
destroy(this.cb_body)
destroy(this.cb_reply)
destroy(this.st_1)
destroy(this.sle_task)
destroy(this.cb_pick_description)
destroy(this.mle_message)
destroy(this.dw_comment_pick)
end on

event open;call super::open;long ll_rows
long i
string ls_treatment_type
str_popup_return popup_return
integer li_sts
long ll_count

service = message.powerobjectparm

if isnull(current_patient) then
	title = service.description
else
	title = current_patient.id_line()
end if

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

// Prepare popup_return for error return
popup_return.item_count = 1
popup_return.items[1] = "ERROR"

li_sts = get_message()
if li_sts <= 0 then
	log.log(this, "w_epro_todo_item:open", "Error retrieving message (" + string(service.patient_workplan_item_id) + ")", 4)
	closewithreturn(this, popup_return)
	return
end if

if upper(service.status) = "COMPLETED" OR upper(service.status) = "CANCELLED" then
	read_only = true
	cb_reply.visible = false
	cb_forward.visible = false
	cb_beback.visible = false
	cb_pick_description.visible = false
	cb_body.visible = false
	sle_task.enabled = false
	mle_disposition.enabled = false
	cb_finished.text = "OK"
else
	read_only = false
end if

dw_comment_pick.Object.DataWindow.zoom = 100
dw_comment_pick.object.item_text.width = dw_comment_pick.width - 110
dw_comment_pick.settransobject(sqlca)
comment_top_20_code = service.service + "_DISPOSITION"
comment_top_20_user_id = current_user.user_id
ll_count = dw_comment_pick.retrieve(comment_top_20_user_id, comment_top_20_code)
if ll_count <= 0 then
	comment_top_20_user_id = current_user.common_list_id()
	ll_count = dw_comment_pick.retrieve(comment_top_20_user_id, comment_top_20_code)
end if




end event

type pb_epro_help from w_window_base`pb_epro_help within w_epro_todo_item
boolean visible = true
integer x = 2674
integer y = 136
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_epro_todo_item
integer y = 1632
end type

type dw_message from datawindow within w_epro_todo_item
integer width = 2917
integer height = 552
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_todo_item_header"
boolean border = false
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
		f_attribute_add_attribute(lstr_attributes, "context_object", "Patient")
	CASE "B_VIEW_CHART"
		ls_service = chart_service
		f_attribute_add_attribute(lstr_attributes, "context_object", "Patient")
	CASE "B_OPEN_ITEM"
		CHOOSE CASE lower(service.context_object)
			CASE "treatment"
				ls_service = treatment_service
				f_attribute_add_attribute(lstr_attributes, "context_object", "Treatment")
			CASE "assessment"
				ls_service = assessment_service
				f_attribute_add_attribute(lstr_attributes, "context_object", "Assessment")
			CASE "observation"
				ls_service = observation_service
				f_attribute_add_attribute(lstr_attributes, "context_object", "Observation")
			CASE "attachment"
				ls_service = attachment_service
				f_attribute_add_attribute(lstr_attributes, "context_object", "Attachment")
			CASE ELSE
				ls_service = chart_service
				f_attribute_add_attribute(lstr_attributes, "context_object", "Patient")
		END CHOOSE
	CASE ELSE
		return
END CHOOSE

li_sts = service_list.do_service(ls_service, lstr_attributes)
if li_sts <= 0 then return


end event

type cb_forward from commandbutton within w_epro_todo_item
integer x = 1207
integer y = 1688
integer width = 443
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Send to ..."
end type

event clicked;string ls_description
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

luo_user = user_list.pick_user("ALL", true)
If isnull(luo_user) then return

if f_string_modified(sle_task.text, service.description) then
	ls_description = sle_task.text
else
	setnull(ls_description)
end if

if len(mle_disposition.text) > 0 then
	ls_new_message = mle_disposition.text
else
	setnull(ls_new_message)
end if

// Forward the todo service to the specified user with the new description and message
li_sts = service.forward_workplan_item(luo_user.user_id, ls_description, ls_new_message)
if li_sts < 0 then return

// automatically exit service with "I'll Be Back"
popup_return.item_count = 0
Closewithreturn(parent, popup_return)


end event

type cb_finished from commandbutton within w_epro_todo_item
integer x = 2135
integer y = 1688
integer width = 736
integer height = 108
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Close with Comment"
end type

event clicked;str_popup_return popup_return
integer li_sts

if read_only then
	popup_return.item_count = 1
	popup_return.items[1] = "OK"
	closewithreturn(parent, popup_return)
	return
end if

if isnull(mle_disposition.text) or trim(mle_disposition.text) = "" then
	openwithparm(w_pop_message, "You must enter a comment to complete a task")
	return
end if

service.add_attribute("Disposition", mle_disposition.text)

li_sts = set_progress()
If li_sts < 0 then return

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)

end event

type mle_disposition from multilineedit within w_epro_todo_item
integer x = 498
integer y = 1300
integer width = 1408
integer height = 328
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

type cb_beback from commandbutton within w_epro_todo_item
integer x = 1696
integer y = 1688
integer width = 393
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I~'ll Be Back"
boolean cancel = true
end type

event clicked;str_popup_return popup_return
integer li_sts

if f_string_modified(mle_disposition.text, original_disposition) then
	service.add_attribute("Disposition", mle_disposition.text)
end if

popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

type st_message_title from statictext within w_epro_todo_item
integer x = 46
integer y = 700
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
long backcolor = COLOR_BACKGROUND
string text = "Message:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_message from statictext within w_epro_todo_item
integer x = 498
integer y = 704
integer width = 2231
integer height = 412
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
popup.title = "Task Message"
popup.items[1] = text
openwithparm(w_display_large_string, popup)

end event

type st_disposition_title from statictext within w_epro_todo_item
integer y = 1300
integer width = 494
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Comment/Reply:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_body from commandbutton within w_epro_todo_item
integer x = 2743
integer y = 1528
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

type cb_reply from commandbutton within w_epro_todo_item
integer x = 46
integer y = 1688
integer width = 1115
integer height = 108
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reply to ..."
end type

event clicked;string ls_description
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

luo_user = user_list.find_user(reply_to_user_id)
If isnull(luo_user) then return

if f_string_modified(sle_task.text, service.description) then
	ls_description = sle_task.text
else
	setnull(ls_description)
end if

if len(mle_disposition.text) > 0 then
	ls_new_message = mle_disposition.text
else
	setnull(ls_new_message)
end if

// Forward the todo service to the specified user with the new description and message
li_sts = service.forward_workplan_item(luo_user.user_id, ls_description, ls_new_message)
if li_sts < 0 then return

// automatically exit service with "I'll Be Back"
popup_return.item_count = 0
Closewithreturn(parent, popup_return)


end event

type st_1 from statictext within w_epro_todo_item
integer x = 46
integer y = 592
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
long backcolor = COLOR_BACKGROUND
string text = "Task:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_task from singlelineedit within w_epro_todo_item
integer x = 498
integer y = 568
integer width = 2231
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_pick_description from commandbutton within w_epro_todo_item
integer x = 2743
integer y = 576
integer width = 128
integer height = 100
integer taborder = 60
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

popup.title = "Select Task"
popup.data_row_count = 2
popup.items[1] = service.service + "_Task"
popup.items[2] = ""
openwithparm(w_pick_top_20_multiline, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

sle_task.replacetext(popup_return.items[1])

sle_task.setfocus()

end event

type mle_message from multilineedit within w_epro_todo_item
integer x = 498
integer y = 704
integer width = 2231
integer height = 572
integer taborder = 70
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
boolean displayonly = true
borderstyle borderstyle = styleraised!
end type

type dw_comment_pick from u_dw_pick_list within w_epro_todo_item
integer x = 1911
integer y = 1304
integer width = 818
integer height = 328
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_pick_top_20_multiline_small"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;string ls_item_text
string ls_temp
string ls_sep
long ll_len
long ll_risk_level

if lasttype = 'compute' then return


ls_item_text = object.item_text[selected_row]
ls_temp = trim(mle_disposition.text)

if ls_temp = "" then
	ls_sep = ""
elseif right(ls_temp, 1) = "," then
	ls_sep = " "
elseif right(ls_temp, 1) = "." then
	ls_sep = "~r~n"
else
	ls_sep = " "
end if

mle_disposition.text += ls_sep + ls_item_text

object.selected_flag[selected_row] = 0

mle_disposition.setfocus()
ll_len = len(mle_disposition.text)
mle_disposition.selecttext(ll_len + 1, 0)



end event

