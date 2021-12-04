$PBExportHeader$w_epro_review_message.srw
forward
global type w_epro_review_message from w_window_base
end type
type dw_message from datawindow within w_epro_review_message
end type
type cb_reply from commandbutton within w_epro_review_message
end type
type cb_forward from commandbutton within w_epro_review_message
end type
type cb_folder from commandbutton within w_epro_review_message
end type
type cb_finished from commandbutton within w_epro_review_message
end type
type mle_message from multilineedit within w_epro_review_message
end type
type cb_beback from commandbutton within w_epro_review_message
end type
type st_1 from statictext within w_epro_review_message
end type
type cb_print from commandbutton within w_epro_review_message
end type
type cb_delete from commandbutton within w_epro_review_message
end type
type cb_properties from commandbutton within w_epro_review_message
end type
end forward

global type w_epro_review_message from w_window_base
boolean titlebar = false
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
cb_beback cb_beback
st_1 st_1
cb_print cb_print
cb_delete cb_delete
cb_properties cb_properties
end type
global w_epro_review_message w_epro_review_message

type variables
u_component_service service

long message_workplan_item_id
string ordered_by
string ordered_for
string owned_by
datetime dispatch_date
datetime begin_date
string cpr_id
long encounter_id
long problem_id
long treatment_id
string status

string message_object
string chart_service
string assessment_service
string treatment_service
string message_service

end variables

forward prototypes
public function integer get_message ()
end prototypes

public function integer get_message ();string ls_temp
string ls_patient_name
long ll_count
string ls_null
string ls_message
string ls_message_subject
string ls_item_description
u_ds_data luo_data
string ls_folder


setnull(ls_null)

// Get data about the message
SELECT description,
		ordered_by,
		ordered_for,
		owned_by,
		dispatch_date,
		begin_date,
		folder,
		cpr_id,
		encounter_id,
		dbo.fn_patient_full_name(cpr_id),
		status
INTO :ls_message_subject,
		:ordered_by,
		:ordered_for,
		:owned_by,
		:dispatch_date,
		:begin_date,
		:ls_folder,
		:cpr_id,
		:encounter_id,
		:ls_patient_name,
		:status
FROM p_Patient_WP_Item
WHERE patient_workplan_item_id = :message_workplan_item_id;
if not tf_check() then return -1

// Now get the message attributes
luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_p_patient_wp_item_attribute")
ll_count = luo_data.retrieve(message_workplan_item_id)
if ll_count < 0 then return -1

message_object = luo_data.get_attribute("message_object")
ls_message = luo_data.get_attribute("message")

ls_temp = luo_data.get_attribute("problem_id")
problem_id = long(ls_temp)

ls_temp = luo_data.get_attribute("treatment_id")
treatment_id = long(ls_temp)

if owned_by <> current_user.user_id then
	cb_folder.visible = false
	cb_reply.visible = false
	cb_delete.visible = false
end if

dw_message.reset()
dw_message.insertrow(0)

dw_message.object.subject[1] = ls_message_subject

dw_message.object.from_user[1] = user_list.user_full_name(ordered_by)
dw_message.object.from_user_color[1] = user_list.user_color(ordered_by)
dw_message.object.to_user[1] = user_list.user_full_name(ordered_for)
dw_message.object.to_user_color[1] = user_list.user_color(ordered_for)
dw_message.object.owner[1] = user_list.user_full_name(owned_by)
dw_message.object.owner_color[1] = user_list.user_color(owned_by)

dw_message.object.folder[1] = ls_folder
dw_message.object.sent_date_time[1] = dispatch_date
dw_message.object.received_date_time[1] = begin_date

if lower(ordered_for) = "#distlist" then
	dw_message.object.folder.visible = 0
	dw_message.object.owner.visible = 0
	dw_message.object.received_date_time.visible = 0
	dw_message.object.t_folder.visible = 0
	dw_message.object.t_owner.visible = 0
	dw_message.object.t_received.visible = 0
	
	dw_message.object.to_user.border = 6 // 3D Raised
end if


if isnull(cpr_id) then
	if lower(status) = "cancelled" then
		dw_message.object.patient_name[1] = ls_patient_name
		cb_delete.enabled = false
	else
		dw_message.object.patient_name[1] = ls_null
		setnull(message_object)
		cb_delete.enabled = true
	end if
else
	dw_message.object.patient_name[1] = ls_patient_name
	cb_delete.enabled = false
end if

if not isnull(cpr_id) then
	state_attributes.attribute_count += 1
	state_attributes.attribute[state_attributes.attribute_count].attribute = "cpr_id"
	state_attributes.attribute[state_attributes.attribute_count].value = string(cpr_id)
end if

if isnull(message_object) then
	dw_message.object.item_description[1] = ls_null
else
	CHOOSE CASE lower(message_object)
		CASE "encounter"
			ls_item_description = current_patient.encounters.encounter_description(encounter_id)
			
			state_attributes.attribute_count += 1
			state_attributes.attribute[state_attributes.attribute_count].attribute = "encounter_id"
			state_attributes.attribute[state_attributes.attribute_count].value = string(encounter_id)
		CASE "assessment"
			ls_item_description = current_patient.assessments.assessment_description(problem_id)
			
			state_attributes.attribute_count += 1
			state_attributes.attribute[state_attributes.attribute_count].attribute = "assessment_id"
			state_attributes.attribute[state_attributes.attribute_count].value = string(problem_id)
		CASE "treatment"
			ls_item_description = current_patient.treatments.treatment_description(treatment_id)
			
			state_attributes.attribute_count += 1
			state_attributes.attribute[state_attributes.attribute_count].attribute = "treatment_id"
			state_attributes.attribute[state_attributes.attribute_count].value = string(treatment_id)
		CASE ELSE
			ls_item_description = ls_null
	END CHOOSE
	
	dw_message.object.item_description[1] = ls_item_description
end if

dw_message.object.body[1] = ls_message

if isnull(ls_message) then
	mle_message.text = ""
else
	mle_message.text = ls_message
end if

return 1

end function

on w_epro_review_message.create
int iCurrent
call super::create
this.dw_message=create dw_message
this.cb_reply=create cb_reply
this.cb_forward=create cb_forward
this.cb_folder=create cb_folder
this.cb_finished=create cb_finished
this.mle_message=create mle_message
this.cb_beback=create cb_beback
this.st_1=create st_1
this.cb_print=create cb_print
this.cb_delete=create cb_delete
this.cb_properties=create cb_properties
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_message
this.Control[iCurrent+2]=this.cb_reply
this.Control[iCurrent+3]=this.cb_forward
this.Control[iCurrent+4]=this.cb_folder
this.Control[iCurrent+5]=this.cb_finished
this.Control[iCurrent+6]=this.mle_message
this.Control[iCurrent+7]=this.cb_beback
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.cb_print
this.Control[iCurrent+10]=this.cb_delete
this.Control[iCurrent+11]=this.cb_properties
end on

on w_epro_review_message.destroy
call super::destroy
destroy(this.dw_message)
destroy(this.cb_reply)
destroy(this.cb_forward)
destroy(this.cb_folder)
destroy(this.cb_finished)
destroy(this.mle_message)
destroy(this.cb_beback)
destroy(this.st_1)
destroy(this.cb_print)
destroy(this.cb_delete)
destroy(this.cb_properties)
end on

event open;call super::open;long ll_rows
long i
string ls_treatment_type
str_popup_return popup_return
integer li_sts

service = message.powerobjectparm

service.get_attribute("message_workplan_item_id", message_workplan_item_id)
if isnull(message_workplan_item_id) then
	log.log(this, "w_epro_review_message:open", "No message_workplan_item_id", 4)
	return -1
end if


assessment_service = service.get_attribute("assessment_service")
if isnull(assessment_service) then assessment_service = "ASSESSMENT_REVIEW"

treatment_service = service.get_attribute("treatment_service")
if isnull(treatment_service) then treatment_service = "TREATMENT_REVIEW"

chart_service = service.get_attribute("chart_service")
if isnull(chart_service) then chart_service = "CHART"

message_service = service.get_attribute("message_service")
if isnull(message_service) then message_service = "SENDMESSAGE"

// Prepare popup_return for error return
popup_return.item_count = 1
popup_return.items[1] = "ERROR"

li_sts = get_message()
if li_sts <= 0 then
	log.log(this, "w_epro_review_message:open", "Error retrieving message (" + string(service.patient_workplan_item_id) + ")", 4)
	closewithreturn(this, popup_return)
	return
end if

if service.manual_service then
	cb_beback.visible = false
else
	cb_beback.visible = true
end if

if gnv_app.cpr_mode = "SERVER" then
	cb_finished.event trigger clicked()
	return
end if

end event

type pb_epro_help from w_window_base`pb_epro_help within w_epro_review_message
boolean visible = true
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_epro_review_message
end type

type dw_message from datawindow within w_epro_review_message
integer x = 192
integer y = 144
integer width = 2533
integer height = 604
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_message_header"
borderstyle borderstyle = stylelowered!
end type

event buttonclicked;//string ls_cpr_id
//integer li_sts
//long ll_encounter_id
//string ls_temp
//
//ls_cpr_id = dw_message.object.cpr_id[1]
//
//if not isnull(calling_service) then
//	ls_temp = calling_service.get_attribute("ENCOUNTER_ID")
//	if isnull(ls_temp) then
//		setnull(ll_encounter_id)
//	else
//		ll_encounter_id = long(ls_temp)
//	end if
//else
//	setnull(ll_encounter_id)
//end if
//
//li_sts = service_list.do_service(ls_cpr_id, ll_encounter_id, "LOOK")
//
//
end event

event clicked;string ls_service
str_attributes lstr_attributes
integer li_sts
str_popup popup

if isnull(dwo) or not isvalid(dwo) then return
if row <= 0 or isnull(row) then return

lstr_attributes = state_attributes
setnull(ls_service)

CHOOSE CASE upper(dwo.name)
	CASE "TO_USER"
		popup.dataobject = "dw_message_distlist_recipients"
		popup.argument_count = 1
		popup.argument[1] = string(message_workplan_item_id)
		popup.numeric_argument = true
		popup.datacolumn = 1
		popup.displaycolumn = 4
		openwithparm(w_pop_pick, popup)
	CASE "PATIENT_NAME"
		ls_service = chart_service
	CASE "ITEM_DESCRIPTION"
		CHOOSE CASE lower(message_object)
			CASE "treatment"
				ls_service = treatment_service
			CASE "assessment"
				ls_service = assessment_service
			CASE ELSE
				ls_service = chart_service
		END CHOOSE
END CHOOSE

if not isnull(ls_service) then
	li_sts = service_list.do_service(ls_service, lstr_attributes)
	if li_sts <= 0 then return
end if


end event

type cb_reply from commandbutton within w_epro_review_message
integer x = 325
integer y = 1536
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
	ls_user_tag = user_list.user_full_name(ordered_by)
	if isnull(ls_user_tag) or trim(ls_user_tag) = "" then
		ls_user_tag = "<Unknown>"
	end if
	
	ls_user_tag = string(dispatch_date, date_format_string + " hh:mm") + " " + ls_user_tag
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
lstr_attributes.attribute[lstr_attributes.attribute_count].value = ordered_by

li_sts = service_list.do_service(cpr_id, &
											encounter_id, &
											message_service, &
											lstr_attributes)
if li_sts <= 0 then return


end event

type cb_forward from commandbutton within w_epro_review_message
integer x = 905
integer y = 1536
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
	ls_user_tag = user_list.user_full_name(ordered_by)
	if isnull(ls_user_tag) or trim(ls_user_tag) = "" then
		ls_user_tag = "<Unknown>"
	end if
	
	ls_user_tag = string(dispatch_date, date_format_string + " hh:mm") + " " + ls_user_tag
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

li_sts = service_list.do_service(cpr_id, encounter_id, message_service, &
												lstr_attributes)
if li_sts <= 0 then return


end event

type cb_folder from commandbutton within w_epro_review_message
integer x = 1486
integer y = 1536
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
string ls_cpr_id
long ll_patient_workplan_id
string ls_attribute
string ls_value
string ls_message

setnull(ls_cpr_id)
setnull(ll_patient_workplan_id)

popup.dataobject = "dw_top_20_user_list_pick"
popup.datacolumn = 4
popup.displaycolumn = 4
popup.argument_count = 2
popup.argument[1] = current_user.user_id
popup.argument[2] = "MESSAGE_FOLDER"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then
	if popup_return.choices_count = 0 then
		if lower(status) = "cancelled" then
			ls_message = "You must create at least one personal folder in order to move a message out of the ~"Deleted~" list"
		else
			ls_message = "There are no folders available"
		end if
		openwithparm(w_pop_message, ls_message)
	end if
	return
end if

ls_attribute = "folder"
ls_value = popup_return.items[1]

// If the message is deleted then it needs to be undeleted here
if lower(status) = "cancelled" then
	sqlca.sp_set_workplan_item_progress( message_workplan_item_id, & 
														current_user.user_id, & 
														"Uncancel", & 
														datetime(today(), now()), & 
														current_scribe.user_id, & 
														gnv_app.computer_id)
end if

sqlca.sp_add_workplan_item_attribute(&
		ls_cpr_id, &
		ll_patient_workplan_id, &
		message_workplan_item_id, &
		ls_attribute, &
		ls_value, &
		current_scribe.user_id, &
		current_user.user_id)

if not tf_check() then return

dw_message.object.folder[1] = popup_return.descriptions[1]

end event

type cb_finished from commandbutton within w_epro_review_message
integer x = 2341
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

type mle_message from multilineedit within w_epro_review_message
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

type cb_beback from commandbutton within w_epro_review_message
integer x = 1893
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

type st_1 from statictext within w_epro_review_message
integer width = 2912
integer height = 124
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Review EncounterPRO Message"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_print from commandbutton within w_epro_review_message
integer x = 46
integer y = 1720
integer width = 315
integer height = 76
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Print"
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

type cb_delete from commandbutton within w_epro_review_message
integer x = 2066
integer y = 1536
integer width = 503
integer height = 108
integer taborder = 40
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

sqlca.sp_set_workplan_item_progress(message_workplan_item_id, &
												current_user.user_id, &
												"Cancelled", &
												ldt_now, &
												current_scribe.user_id, &
												gnv_app.computer_id)
if not tf_check() then return

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)

end event

type cb_properties from commandbutton within w_epro_review_message
integer x = 393
integer y = 1720
integer width = 315
integer height = 76
integer taborder = 100
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Properties"
end type

event clicked;service_list.display_service_properties(message_workplan_item_id)

end event

