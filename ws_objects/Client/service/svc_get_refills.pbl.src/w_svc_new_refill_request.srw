$PBExportHeader$w_svc_new_refill_request.srw
forward
global type w_svc_new_refill_request from w_window_base
end type
type cb_be_back from commandbutton within w_svc_new_refill_request
end type
type cb_done from commandbutton within w_svc_new_refill_request
end type
type st_refill_history_title from statictext within w_svc_new_refill_request
end type
type st_refill_note_title from statictext within w_svc_new_refill_request
end type
type cb_pick_note from commandbutton within w_svc_new_refill_request
end type
type cb_view_chart from commandbutton within w_svc_new_refill_request
end type
type st_ordered_rx_title from statictext within w_svc_new_refill_request
end type
type mle_ordered_medication from multilineedit within w_svc_new_refill_request
end type
type st_checking_contraindications from statictext within w_svc_new_refill_request
end type
type st_refills_requested_title from statictext within w_svc_new_refill_request
end type
type st_refills_requested from statictext within w_svc_new_refill_request
end type
type st_title from statictext within w_svc_new_refill_request
end type
type ole_refill_history from u_rich_text_edit within w_svc_new_refill_request
end type
type mle_note from multilineedit within w_svc_new_refill_request
end type
type st_ordered_for_title from statictext within w_svc_new_refill_request
end type
type st_ordered_for from statictext within w_svc_new_refill_request
end type
type st_scheduled_warning from statictext within w_svc_new_refill_request
end type
type cb_cancel from commandbutton within w_svc_new_refill_request
end type
end forward

global type w_svc_new_refill_request from w_window_base
string title = "Retry Posting"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
string button_type = "COMMAND"
cb_be_back cb_be_back
cb_done cb_done
st_refill_history_title st_refill_history_title
st_refill_note_title st_refill_note_title
cb_pick_note cb_pick_note
cb_view_chart cb_view_chart
st_ordered_rx_title st_ordered_rx_title
mle_ordered_medication mle_ordered_medication
st_checking_contraindications st_checking_contraindications
st_refills_requested_title st_refills_requested_title
st_refills_requested st_refills_requested
st_title st_title
ole_refill_history ole_refill_history
mle_note mle_note
st_ordered_for_title st_ordered_for_title
st_ordered_for st_ordered_for
st_scheduled_warning st_scheduled_warning
cb_cancel cb_cancel
end type
global w_svc_new_refill_request w_svc_new_refill_request

type variables
u_component_service service

string ordered_for
integer refills

string refill_progress_type

str_drug_definition drug
boolean controlled_substance

string refill_note_progress_key

boolean ordered_for_changed
boolean refills_changed
boolean note_changed

end variables

forward prototypes
public function integer check_contraindications ()
public function integer refresh ()
public function integer initialize ()
public function integer order_refill_request ()
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

public function integer refresh ();string ls_temp
string ls_progress_key
long ll_null
integer li_sts

setnull(ll_null)

if len(ordered_for) > 0 then
	st_ordered_for.text = user_list.user_full_name(ordered_for)
	st_ordered_for.backcolor = user_list.user_color(ordered_for)
else
	st_ordered_for.text = "<Choose Provider>"
	st_ordered_for.backcolor = color_light_yellow
end if

if refills > 0 then
	st_refills_requested.text = string(refills)
else
	st_refills_requested.text = "N/A"
end if


mle_ordered_medication.text = service.treatment.treatment_description
if f_string_to_boolean(drug.controlled_substance_flag) then
	ls_temp = "Controlled Substance"
	if not isnull(drug.dea_schedule) and upper(drug.dea_schedule) <> "NA" then
		ls_temp += " Schedule " + drug.dea_schedule
	end if
	mle_ordered_medication.text += "~r~n" + ls_temp
	controlled_substance = true
	st_scheduled_warning.visible = true
else
	st_scheduled_warning.visible = false
end if


setnull(ls_progress_key)
ole_refill_history.initialize()
li_sts = ole_refill_history.display_progress("Treatment", service.treatment.treatment_id, refill_progress_type, ls_progress_key, "Dates", false, ll_null)
if li_sts <= 0 then
	ole_refill_history.add_text("No Previous Refills")
end if



return 1



end function

public function integer initialize ();string ls_progress_key
integer li_sts
str_attributes lstr_attributes
integer li_default_refills_authorized
string ls_temp
long ll_null

setnull(ll_null)

ls_temp = service.edas_property_value("Treatment.Property(Refill Request Ordered For).PropertyValue")
if isnull(ls_temp) then
	// Default to the last provider to order this medication
	ls_temp = service.edas_property_value("Treatment.Order(-1).OrderedBy")
	if isnull(ls_temp) then
		ls_temp = service.edas_property_value("Patient.PrimaryProvider")
	end if
end if
if len(ls_temp) > 0 then
	ordered_for = ls_temp
else
	setnull(ordered_for)
end if


ls_temp = service.edas_property_value("Treatment.Property(Refill Request Refills).PropertyValue")
if isnull(ls_temp) then
	refills = 0
elseif isnumber(ls_temp) then
	refills = integer(ls_temp)
else
	refills = 0
end if

ls_temp = service.edas_property_value("Treatment.Property(Refill Request Note).PropertyValue")
if isnull(ls_temp) then
	mle_note.text = ""
else
	mle_note.text = ls_temp
end if


return 1



end function

public function integer order_refill_request ();long ll_treatment_id
str_treatment_description lstr_treatment
long ll_null
long ll_ordered_patient_workplan_id
long ll_followup_patient_workplan_id
string ls_refill_note
integer li_sts
string ls_null

setnull(ll_null)
setnull(ls_null)

if isnull(ordered_for) or trim(ordered_for) = "" then
	openwithparm(w_pop_message, "You must choose an Ordered For Provider ")
	return 0
end if

lstr_treatment = f_empty_treatment()

lstr_treatment.open_encounter_id = service.encounter_id

lstr_treatment.treatment_type = "RefillMedication"
lstr_treatment.parent_treatment_id = service.treatment.treatment_id
if len(drug.common_name) > 0 then
	lstr_treatment.treatment_description = "Refill Request for " + drug.common_name
else
	lstr_treatment.treatment_description = "Refill Request for " + service.treatment.treatment_description
end if

lstr_treatment.begin_date = datetime(today(), now())
lstr_treatment.ordered_by = current_user.user_id
lstr_treatment.created_by = current_scribe.user_id
lstr_treatment.ordered_for = ordered_for
if refills > 0 then
	lstr_treatment.refills = refills
end if

ll_treatment_id = current_patient.treatments.new_treatment(lstr_treatment)
if ll_treatment_id > 0 then
	if len(mle_note.text) > 0 then
		f_set_patient_property(service.cpr_id, &
								"Treatment", &
								ll_treatment_id, &
								refill_note_progress_key, &
								mle_note.text)
	end if
	
	// Order the treatment workplan(s)
	sqlca.sp_order_treatment_workplans( &
			service.cpr_id, &
			ll_treatment_id, &
			lstr_treatment.treatment_type, &
			lstr_treatment.treatment_mode, &
			ll_null, &
			ll_null, &
			lstr_treatment.open_encounter_id, &
			lstr_treatment.treatment_description, &
			current_user.user_id, &
			lstr_treatment.ordered_for, &
			ll_null, &
			service.in_office_flag, &
			current_scribe.user_id, &
			ll_ordered_patient_workplan_id, &
			ll_followup_patient_workplan_id)
	If Not tf_check() then Return -1
else
	log.log(this, "w_svc_new_refill_request.order_refill_request:0067", "Error creating refill request treatment", 4)
	return -1
end if

// Log the refill request against the parent treatment
ls_refill_note = st_ordered_for.text
if len(mle_note.text) > 0 then
	ls_refill_note += "; " + mle_note.text
end if
li_sts = current_patient.treatments.set_treatment_progress(service.treatment.treatment_id, "Refill Request", ls_null, ls_refill_note)


return 1

end function

on w_svc_new_refill_request.create
int iCurrent
call super::create
this.cb_be_back=create cb_be_back
this.cb_done=create cb_done
this.st_refill_history_title=create st_refill_history_title
this.st_refill_note_title=create st_refill_note_title
this.cb_pick_note=create cb_pick_note
this.cb_view_chart=create cb_view_chart
this.st_ordered_rx_title=create st_ordered_rx_title
this.mle_ordered_medication=create mle_ordered_medication
this.st_checking_contraindications=create st_checking_contraindications
this.st_refills_requested_title=create st_refills_requested_title
this.st_refills_requested=create st_refills_requested
this.st_title=create st_title
this.ole_refill_history=create ole_refill_history
this.mle_note=create mle_note
this.st_ordered_for_title=create st_ordered_for_title
this.st_ordered_for=create st_ordered_for
this.st_scheduled_warning=create st_scheduled_warning
this.cb_cancel=create cb_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_be_back
this.Control[iCurrent+2]=this.cb_done
this.Control[iCurrent+3]=this.st_refill_history_title
this.Control[iCurrent+4]=this.st_refill_note_title
this.Control[iCurrent+5]=this.cb_pick_note
this.Control[iCurrent+6]=this.cb_view_chart
this.Control[iCurrent+7]=this.st_ordered_rx_title
this.Control[iCurrent+8]=this.mle_ordered_medication
this.Control[iCurrent+9]=this.st_checking_contraindications
this.Control[iCurrent+10]=this.st_refills_requested_title
this.Control[iCurrent+11]=this.st_refills_requested
this.Control[iCurrent+12]=this.st_title
this.Control[iCurrent+13]=this.ole_refill_history
this.Control[iCurrent+14]=this.mle_note
this.Control[iCurrent+15]=this.st_ordered_for_title
this.Control[iCurrent+16]=this.st_ordered_for
this.Control[iCurrent+17]=this.st_scheduled_warning
this.Control[iCurrent+18]=this.cb_cancel
end on

on w_svc_new_refill_request.destroy
call super::destroy
destroy(this.cb_be_back)
destroy(this.cb_done)
destroy(this.st_refill_history_title)
destroy(this.st_refill_note_title)
destroy(this.cb_pick_note)
destroy(this.cb_view_chart)
destroy(this.st_ordered_rx_title)
destroy(this.mle_ordered_medication)
destroy(this.st_checking_contraindications)
destroy(this.st_refills_requested_title)
destroy(this.st_refills_requested)
destroy(this.st_title)
destroy(this.ole_refill_history)
destroy(this.mle_note)
destroy(this.st_ordered_for_title)
destroy(this.st_ordered_for)
destroy(this.st_scheduled_warning)
destroy(this.cb_cancel)
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

popup_return.item_count = 1
popup_return.items[1] = "ERROR"

service = message.powerobjectparm


if isnull(service.treatment) then
	log.log(this, "w_svc_new_refill_request:open", "Null treatment object", 4)
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

if len(service.treatment.drug_id) > 0 then
	li_sts = drugdb.get_drug_definition(service.treatment.drug_id, drug)
end if

refill_note_progress_key = service.get_attribute("refill_note_progress_key")
if isnull(refill_note_progress_key) then refill_note_progress_key = "Refill Request Notes"

refill_progress_type = service.get_attribute("refill_progress_type")
if isnull(refill_progress_type) then refill_progress_type = "Refill"

initialize()

refresh()

postevent("post_open")

end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_new_refill_request
integer x = 2857
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_new_refill_request
integer x = 59
integer y = 1512
end type

type cb_be_back from commandbutton within w_svc_new_refill_request
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

// Save what the user has set so far
if ordered_for_changed then
	f_set_patient_property(service.cpr_id, &
								"Treatment", &
								service.treatment.treatment_id, &
								"Refill Request Ordered For", &
								ordered_for)
end if
							
if refills_changed then
	f_set_patient_property(service.cpr_id, &
								"Treatment", &
								service.treatment.treatment_id, &
								"Refill Request Refills", &
								string(refills) )
end if

if note_changed then
	f_set_patient_property(service.cpr_id, &
								"Treatment", &
								service.treatment.treatment_id, &
								"Refill Request Note", &
								mle_note.text )
end if

// Close with "I'll Be Back"
closewithreturn(parent, 0)

end event

type cb_done from commandbutton within w_svc_new_refill_request
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

event clicked;integer li_sts

li_sts = order_refill_request()
if li_sts <= 0 then return

closewithreturn(parent, 1)

end event

type st_refill_history_title from statictext within w_svc_new_refill_request
integer x = 1413
integer y = 104
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
long backcolor = 7191717
string text = "Refill History"
boolean focusrectangle = false
end type

type st_refill_note_title from statictext within w_svc_new_refill_request
integer x = 585
integer y = 960
integer width = 411
integer height = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Refill Note:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_pick_note from commandbutton within w_svc_new_refill_request
integer x = 2519
integer y = 1284
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

popup.title = "Select Refill Note"
popup.data_row_count = 2
popup.items[1] = "New Refill Note"
popup.items[2] = ""
openwithparm(w_pick_top_20_multiline, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

mle_note.replacetext(popup_return.items[1])
mle_note.setfocus()

end event

type cb_view_chart from commandbutton within w_svc_new_refill_request
integer x = 37
integer y = 1276
integer width = 462
integer height = 100
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

type st_ordered_rx_title from statictext within w_svc_new_refill_request
integer x = 37
integer y = 112
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
long backcolor = 7191717
string text = "Ordered Rx"
boolean focusrectangle = false
end type

type mle_ordered_medication from multilineedit within w_svc_new_refill_request
integer x = 37
integer y = 180
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

type st_checking_contraindications from statictext within w_svc_new_refill_request
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
long backcolor = 7191717
string text = "<  Checking Contraindications  >"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_refills_requested_title from statictext within w_svc_new_refill_request
integer x = 123
integer y = 824
integer width = 873
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Number of Refills  Requested:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_refills_requested from statictext within w_svc_new_refill_request
integer x = 1019
integer y = 812
integer width = 224
integer height = 88
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "N/A"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;// By Sumathi Chinnasamy On 12/08/1999
// To allow the user to key-in the no. of refills

str_popup 			popup
str_popup_return	popup_return

popup.realitem = refills
Openwithparm(w_number,popup)

popup_return = Message.powerobjectparm

If popup_return.item = "CANCEL" Then Return

refills				 = popup_return.realitem
If Isnull(refills) Then refills = 0

if refills > 0 then
	text = string(refills)
else
	text = "N/A"
end if

refills_changed = true

end event

type st_title from statictext within w_svc_new_refill_request
integer width = 2921
integer height = 100
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Medication Refill Request"
alignment alignment = center!
boolean focusrectangle = false
end type

type ole_refill_history from u_rich_text_edit within w_svc_new_refill_request
integer x = 1413
integer y = 180
integer width = 1445
integer height = 380
integer taborder = 30
borderstyle borderstyle = stylebox!
end type

type mle_note from multilineedit within w_svc_new_refill_request
integer x = 1019
integer y = 948
integer width = 1472
integer height = 428
integer taborder = 30
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

event modified;note_changed = true

end event

type st_ordered_for_title from statictext within w_svc_new_refill_request
integer x = 347
integer y = 688
integer width = 649
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Ordered For Provider:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_ordered_for from statictext within w_svc_new_refill_request
integer x = 1019
integer y = 676
integer width = 1394
integer height = 88
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "<Choose Provider>"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;u_user luo_user

luo_user = user_list.pick_user()
if isnull(luo_user) then return

ordered_for = luo_user.user_id
text = luo_user.user_full_name
backcolor = luo_user.color

ordered_for_changed = true

end event

type st_scheduled_warning from statictext within w_svc_new_refill_request
boolean visible = false
integer x = 773
integer y = 112
integer width = 603
integer height = 84
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 7191717
string text = "Controlled Substance"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_svc_new_refill_request
integer x = 37
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
string text = "Cancel"
boolean cancel = true
end type

event clicked;
// Close with "Cancel"
closewithreturn(parent, 2)

end event


Start of PowerBuilder Binary Data Section : Do NOT Edit
07w_svc_new_refill_request.bin 
2100001600e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd00000008fffffffe0000000400000005000000060000000700000009fffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff0000000300000000000000000000000000000000000000000000000000000000e8d6caf001ca361e0000000300000bc00000000000500003004c004200430049004e0045004500530045004b000000590000000000000000000000000000000000000000000000000000000000000000000000000002001cffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000001a0000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000002001affffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000001000007d900000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000101001a000000020000000100000004ab949ac111d9ec9740002b9ed2aba90500000000e8d6caf001ca361ee8d6caf001ca361e000000000000000000000000fffffffe00000002000000030000000400000005000000060000000700000008000000090000000a0000000b0000000c0000000d0000000e0000000f000000100000001100000012000000130000001400000015000000160000001700000018000000190000001a0000001b0000001c0000001d0000001e0000001f00000020fffffffe00000022000000230000002400000025000000260000002700000028000000290000002a0000002b0000002c0000002d0000002efffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
2Cffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff005000540039002d003400340032003700380034003900350065003400420072006900750064006c0072006500310020002e0031003b0030003a00430050005c0000fffe00020205ab949ac111d9ec9740002b9ed2aba90500000001fb8f0821101b01640008ed8413c72e2b00000030000007a90000003600000100000001b800000101000001c000000102000001c800000103000001d000000104000001d800000105000001e000000106000001e800000107000001f000000108000001f800000109000002000000010a000002080000010b000002100000010c000002180000010d000002200000010e000002280000010f000002300000011000000238000001110000024000000112000002480000011300000250000001140000028c0000011500000294000001160000029c00000117000002a400000118000002ac00000119000002b40000011a000002bc0000011b000002c40000011c000002cc0000011d000002d40000011e000002dc0000011f000002ec00000120000002f400000121000002fc0000012200000304000001230000030c0000012400000314000001250000031c0000012600000324000001270000032c0000012800000334000001290000033c0000012a000003440000012b0000034c0000012c000003540000012d0000035c0000012e000003640000012f0000036c0000013000000374000001310000037c00000132000003880000013300000390000001340000039800000000000003a0000000030001000700000003000020a900000003000009d200000003000000490000000200000001000000020000000100000002000000010000000b0000000000000002000000000000000b0000ffff0000000b0000ffff0000000200000000000000020000006400000002000000030000000b000000000000000b0000ffff00000002000000000000000b0000ffff0000000b000000000000000800000031505c3a4352474f525c317e4149454854317e414d5458545c7e5458455c302e335c6e694252454d414e4143494454562e0000000000000002000000030000000300002fd00000000300003de000000003000005a000000003000005a000000003000005a000000003000005a000000002000000640000000b000000000000000b0000ffff0000000800000006616972410000006c000000020000000c0000000b000000000000000b000000000000000b000000000000000b0000000000000002000000000000000300ffffff0000000200000000000000020000006400000002000000000000000200000020000000020000000000000002000000140000000200000000000000020000000000000002000000000000000200000000000000020000000000000008000000010000000000000002000000010000000b0000ffff0000000b0000ffff0000003600000000000000010001330000000a006c6c61006e75776f32006f640d000001770000007764726f6d7061720065646f00000112000000106d726f66657374617463656c006e6f69000001090000000e65646968656c65736f6974630108006e00090000646500006f6d7469280065640d0000016c00000073656e69696361700074676e000001190000000c656761706772616d00726e69000001070000000d746e6f63636c6f727372616800012d0000000800646e690072746e6500011e00000009006e6f66006d616e74011a0065000c000061700000616d65676e696772010e0062000d00006c6300006863706972646c6930006e6508000001690000006e65646e180062740c000001700000006d656761696772611500746e0a00000170000000776567616874646900010b0000000d00756f6d006f70657365746e6901060072000a00006162000074736b6300656c790000013400000015747865746d61726672616d656c72656b73656e6900012f0000000800646e690074746e650001270000000c006e696c0061707365676e696300010c0000000b006f6f7a006361666d00726f740000010a0000000e65736e696f697472646f6d6e012a0065000e00007266000064656d61617473690065636e000001130000001270737476646c6c656974636972616e6f01030079000c0000735f00006b636f74706f727001210073000b00006f6600007469746e63696c6100011000000009007a697300646f6d6501050065000c00006f620000726564726c79747301260065000a00006c6100006d6e676900746e65000001240000000965736162656e696c0001160000000b00676170006965686500746867000001250000000c747865746f636b6200726f6c000001230000000e746e6f6665646e756e696c7201220065000f00006f6600007473746e656b69727572687400011f00000009006e6f66007a69737401110065000700006174000079656b6200012b0000000f0061726600696c656d6977656e00687464000001290000000b6d617266797473650100656c090000015f000000657478650078746e0000012000000009746e6f66646c6f62000102000000090078655f00746e6574011d0079000c00007270000063746e69726f6c6f01170073000c000061700000616d65676e696772010d006c00090000697600006f6d77652c00656408000001690000006e65646e2e006c740900000169000000
296e65646e006c667400000131000000057478657400011c0000000c0069727000666f746e7465736600011b0000000a00697270006f7a746e14006d6f0b000001730000006c6f72637261626c0104007300090000616c00006175676e00006567090000015f00000073726576006e6f690000010f0000000d70696c636c62697373676e6900500000006f007200720067006d006100460020006c0069007300650053005c006200790073006100010007000020a9000009d2000000490000000000ffffff0100010100000100010100000064000001000003000100005c3a4330474f5250317e41524548545c7e414d4958545c3154584554302e337e6e69425c454d415c4143495254562e4e03000044002fd000003de0000005a0000005a0000005a0000005a00000006400724105010c6c616900000000ff0000000000ffff00006400000020000000140000000000000000000100000001010001000002ba000104b10000000e00000000000000000000000200000144000100010001000100000000000000000001001f00000001000000000000000000000000ff10500000000000019000000000000022020000616972410000006c0000000000000000000000000000000000000000000000000001000100000001000000000000000000640000001400206e01000008dc0104010d4a01260111b81a940116011f0201de0123702c4c01270130ba01960135283e0401390000000000000000000000000000000000720041006100690000006c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006f00430074006e006e00650073007400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000210000036e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004e400010001010002092e000000ffffb70000000000000000000000000000000000000000010000000000000000000000000001000000000000000000000000000000000000000000000000015400000030000000000000000005a0000005a0000000ffffff0000000000000000000000010000000000000000000000000000012400000001ff10000000000000019000000000000022020000616972410000006c0000000000000000000000000000000000000000000000000000000000000000000000000000000000720041006100690000006c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400000005000000000000000000000640000001400206e01000008dc0104010d4a01260111b81a940116011f0201de0123702c4c01270130ba01960135283e04013900010001010002092e000000ffffb7000000000000000000000000000000000000120000000000000000000000000000000000000000000000000000005b0000006f004e006d0072006c00610000005d0061000000530020006e0061002000730079005400650070007200770074006900720065004d000000690061006e0061007200640020006100440047004f000000520043004100200045002000740078006e006500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
17w_svc_new_refill_request.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
