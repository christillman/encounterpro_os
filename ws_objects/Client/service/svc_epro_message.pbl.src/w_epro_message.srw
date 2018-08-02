$PBExportHeader$w_epro_message.srw
forward
global type w_epro_message from w_window_base
end type
type dw_message from datawindow within w_epro_message
end type
type cb_reply from commandbutton within w_epro_message
end type
type cb_forward from commandbutton within w_epro_message
end type
type cb_folder from commandbutton within w_epro_message
end type
type cb_finished from commandbutton within w_epro_message
end type
type mle_message from multilineedit within w_epro_message
end type
type cb_dolater from commandbutton within w_epro_message
end type
type cb_beback from commandbutton within w_epro_message
end type
type st_title from statictext within w_epro_message
end type
type cb_print from commandbutton within w_epro_message
end type
type cb_delete from commandbutton within w_epro_message
end type
end forward

global type w_epro_message from w_window_base
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
dw_message dw_message
cb_reply cb_reply
cb_forward cb_forward
cb_folder cb_folder
cb_finished cb_finished
mle_message mle_message
cb_dolater cb_dolater
cb_beback cb_beback
st_title st_title
cb_print cb_print
cb_delete cb_delete
end type
global w_epro_message w_epro_message

type variables
u_component_service service

string message_object
string chart_service
string assessment_service
string treatment_service
string encounter_service
string observation_service
string attachment_service
string message_service

end variables

forward prototypes
public function integer get_message ()
end prototypes

public function integer get_message ();string ls_cpr_id
string ls_patient_name
long ll_count
string ls_null
string ls_message
string ls_message_subject
string ls_item_description

setnull(ls_null)

message_object = service.get_attribute("message_object")
if isnull(message_object) then message_object = service.context_object
ls_message = service.get_attribute("message")
ls_message_subject = service.get_attribute("message_subject")
if isnull(ls_message_subject) then ls_message_subject = service.description

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
dw_message.object.received_date_time[1] = service.begin_date

if isnull(current_patient) then
	dw_message.object.patient_name[1] = ls_null
	setnull(message_object)
	cb_delete.enabled = true
else
	dw_message.object.patient_name[1] = current_patient.name()
	cb_delete.enabled = false
end if

if not isnull(service.cpr_id) then
	state_attributes.attribute_count += 1
	state_attributes.attribute[state_attributes.attribute_count].attribute = "cpr_id"
	state_attributes.attribute[state_attributes.attribute_count].value = string(service.cpr_id)
end if

if isnull(message_object) then
	dw_message.object.item_description[1] = ls_null
else
	f_attribute_add_attribute(state_attributes, "context_object", message_object)
	
	CHOOSE CASE lower(message_object)
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

dw_message.object.subject[1] = ls_message_subject

dw_message.object.body[1] = ls_message

if isnull(ls_message) then
	mle_message.text = ""
else
	mle_message.text = ls_message
end if

return 1

end function

on w_epro_message.create
int iCurrent
call super::create
this.dw_message=create dw_message
this.cb_reply=create cb_reply
this.cb_forward=create cb_forward
this.cb_folder=create cb_folder
this.cb_finished=create cb_finished
this.mle_message=create mle_message
this.cb_dolater=create cb_dolater
this.cb_beback=create cb_beback
this.st_title=create st_title
this.cb_print=create cb_print
this.cb_delete=create cb_delete
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_message
this.Control[iCurrent+2]=this.cb_reply
this.Control[iCurrent+3]=this.cb_forward
this.Control[iCurrent+4]=this.cb_folder
this.Control[iCurrent+5]=this.cb_finished
this.Control[iCurrent+6]=this.mle_message
this.Control[iCurrent+7]=this.cb_dolater
this.Control[iCurrent+8]=this.cb_beback
this.Control[iCurrent+9]=this.st_title
this.Control[iCurrent+10]=this.cb_print
this.Control[iCurrent+11]=this.cb_delete
end on

on w_epro_message.destroy
call super::destroy
destroy(this.dw_message)
destroy(this.cb_reply)
destroy(this.cb_forward)
destroy(this.cb_folder)
destroy(this.cb_finished)
destroy(this.mle_message)
destroy(this.cb_dolater)
destroy(this.cb_beback)
destroy(this.st_title)
destroy(this.cb_print)
destroy(this.cb_delete)
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

encounter_service = service.get_attribute("chart_service")
if isnull(chart_service) then chart_service = "CHART"

observation_service = service.get_attribute("observation_service")
if isnull(observation_service) then observation_service = "OBSERVATION_REVIEW"

attachment_service = service.get_attribute("attachment_service")
if isnull(attachment_service) then attachment_service = "ATTACHMENT_REVIEW"

message_service = service.get_attribute("message_service")
if isnull(message_service) then message_service = "SENDMESSAGE"

// Prepare popup_return for error return
popup_return.item_count = 1
popup_return.items[1] = "ERROR"

st_title.text = service.description

li_sts = get_message()
if li_sts <= 0 then
	log.log(this, "w_epro_message.open.0038", "Error retrieving message (" + string(service.patient_workplan_item_id) + ")", 4)
	closewithreturn(this, popup_return)
	return
end if

if service.owned_by <> current_user.user_id then
	cb_folder.visible = false
	cb_reply.visible = false
end if

service.set_service_buttons(cb_finished, cb_beback, cb_dolater)

if cpr_mode = "SERVER" then
	cb_finished.event trigger clicked()
	return
end if


end event

type pb_epro_help from w_window_base`pb_epro_help within w_epro_message
integer x = 2857
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_epro_message
end type

type dw_message from datawindow within w_epro_message
integer x = 192
integer y = 144
integer width = 2533
integer height = 604
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_message_header"
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
		CHOOSE CASE lower(message_object)
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

type cb_reply from commandbutton within w_epro_message
integer x = 338
integer y = 1532
integer width = 503
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reply"
end type

event clicked;str_popup_return popup_return
string ls_message
string ls_subject
string ls_user_tag
str_attributes lstr_attributes
integer li_sts

lstr_attributes = state_attributes

if not isnull(mle_message.text) and trim(mle_message.text) <> "" then
	ls_user_tag = user_list.user_full_name(service.ordered_by)
	if isnull(ls_user_tag) or trim(ls_user_tag) = "" then
		ls_user_tag = "<Unknown>"
	end if
	
	ls_user_tag = string(service.dispatch_date, date_format_string + " hh:mm") + " " + ls_user_tag
	ls_message = "~r~n~r~n<<" + ls_user_tag + " Wrote:>>~r~n" + mle_message.text
end if

ls_subject = dw_message.object.subject[1]
if isnull(ls_subject) then ls_subject = ""
if lower(left(ls_subject, 3)) <> "re:" then ls_subject = "Re: " + ls_subject

if not isnull(ls_subject) and trim(ls_subject) <> "" then
	lstr_attributes.attribute_count += 1
	lstr_attributes.attribute[lstr_attributes.attribute_count].attribute = "message_subject"
	lstr_attributes.attribute[lstr_attributes.attribute_count].value = ls_subject
end if

if not isnull(ls_message) and trim(ls_message) <> "" then
	lstr_attributes.attribute_count += 1
	lstr_attributes.attribute[lstr_attributes.attribute_count].attribute = "message"
	lstr_attributes.attribute[lstr_attributes.attribute_count].value = ls_message
end if

lstr_attributes.attribute_count += 1
lstr_attributes.attribute[lstr_attributes.attribute_count].attribute = "to_user_id"
lstr_attributes.attribute[lstr_attributes.attribute_count].value = service.ordered_by

li_sts = service_list.do_service(service.cpr_id, &
											service.encounter_id, &
											message_service, &
											lstr_attributes)
if li_sts <= 0 then return


end event

type cb_forward from commandbutton within w_epro_message
integer x = 919
integer y = 1532
integer width = 503
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Forward"
end type

event clicked;str_popup_return popup_return
string ls_message
string ls_subject
string ls_user_tag
str_attributes lstr_attributes
integer li_sts

lstr_attributes = state_attributes

if not isnull(mle_message.text) and trim(mle_message.text) <> "" then
	ls_user_tag = user_list.user_full_name(service.ordered_by)
	if isnull(ls_user_tag) or trim(ls_user_tag) = "" then
		ls_user_tag = "<Unknown>"
	end if
	
	ls_user_tag = string(service.dispatch_date, date_format_string + " hh:mm") + " " + ls_user_tag
	ls_message = "~r~n~r~n<<" + ls_user_tag + " Wrote:>>~r~n" + mle_message.text
end if

ls_subject = dw_message.object.subject[1]
if isnull(ls_subject) then ls_subject = ""
if lower(left(ls_subject, 4)) <> "fwd:" then ls_subject = "Fwd: " + ls_subject

if not isnull(ls_subject) and trim(ls_subject) <> "" then
	lstr_attributes.attribute_count += 1
	lstr_attributes.attribute[lstr_attributes.attribute_count].attribute = "message_subject"
	lstr_attributes.attribute[lstr_attributes.attribute_count].value = ls_subject
end if

if not isnull(ls_message) and trim(ls_message) <> "" then
	lstr_attributes.attribute_count += 1
	lstr_attributes.attribute[lstr_attributes.attribute_count].attribute = "message"
	lstr_attributes.attribute[lstr_attributes.attribute_count].value = ls_message
end if

li_sts = service_list.do_service(service.cpr_id, service.encounter_id, message_service, &
												lstr_attributes)
if li_sts <= 0 then return


end event

type cb_folder from commandbutton within w_epro_message
integer x = 1499
integer y = 1532
integer width = 503
integer height = 108
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Move To Folder"
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_top_20_user_list_pick"
popup.datacolumn = 2
popup.displaycolumn = 4
popup.argument_count = 2
popup.argument[1] = current_user.user_id
popup.argument[2] = "MESSAGE_FOLDER"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

UPDATE p_Patient_WP_Item
SET folder = :popup_return.descriptions[1]
WHERE patient_workplan_item_id = :service.patient_workplan_item_id;
if not tf_check() then return

dw_message.object.folder[1] = popup_return.descriptions[1]

end event

type cb_finished from commandbutton within w_epro_message
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

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)

end event

type mle_message from multilineedit within w_epro_message
integer x = 192
integer y = 776
integer width = 2533
integer height = 720
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean vscrollbar = true
boolean autovscroll = true
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type cb_dolater from commandbutton within w_epro_message
integer x = 1426
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

popup_return.item_count = 1
popup_return.items[1] = "DOLATER"

closewithreturn(parent, popup_return)

end event

type cb_beback from commandbutton within w_epro_message
integer x = 1874
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

popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

type st_title from statictext within w_epro_message
integer width = 2912
integer height = 124
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "EncounterPRO Message"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_print from commandbutton within w_epro_message
integer x = 50
integer y = 1688
integer width = 503
integer height = 108
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Print Message"
end type

event clicked;window lw_wait
string ls_printer
u_ds_data luo_data

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_message_print")

dw_message.rowscopy( 1, 1, Primary!, luo_data, 1, Primary!)


//ls_printer = common_thread.select_printer()
//// If the user didn't select a printer then don't do anything
//if isnull(ls_printer) then return
//
//open(lw_wait, "w_pop_please_wait", parent)
//
//common_thread.set_printer(ls_printer)

luo_data.print(true, true)

//common_thread.set_default_printer()

//close(lw_wait)




end event

type cb_delete from commandbutton within w_epro_message
integer x = 2080
integer y = 1532
integer width = 503
integer height = 108
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete"
end type

event clicked;str_popup popup
str_popup_return popup_return
string ls_cpr_id
long ll_patient_workplan_id
string ls_attribute
string ls_value
datetime ldt_now

setnull(ls_cpr_id)
setnull(ll_patient_workplan_id)

openwithparm(w_pop_yes_no, "Are you sure you want to delete this message?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

ldt_now = datetime(today(), now())

sqlca.sp_set_workplan_item_progress(service.patient_workplan_item_id, &
												current_user.user_id, &
												"Cancelled", &
												ldt_now, &
												current_scribe.user_id, &
												computer_id)
if not tf_check() then return

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)

end event

