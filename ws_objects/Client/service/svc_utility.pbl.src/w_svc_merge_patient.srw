$PBExportHeader$w_svc_merge_patient.srw
forward
global type w_svc_merge_patient from w_window_base
end type
type cb_finished from commandbutton within w_svc_merge_patient
end type
type cb_cancel from commandbutton within w_svc_merge_patient
end type
type st_title from statictext within w_svc_merge_patient
end type
type dw_from_patient from u_dw_patient_info within w_svc_merge_patient
end type
type dw_into_patient from u_dw_patient_info within w_svc_merge_patient
end type
type st_1 from statictext within w_svc_merge_patient
end type
type st_2 from statictext within w_svc_merge_patient
end type
type cb_search_from from commandbutton within w_svc_merge_patient
end type
type cb_search_into from commandbutton within w_svc_merge_patient
end type
type cb_im_sure from commandbutton within w_svc_merge_patient
end type
type st_warning from statictext within w_svc_merge_patient
end type
end forward

global type w_svc_merge_patient from w_window_base
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
string button_type = "COMMAND"
cb_finished cb_finished
cb_cancel cb_cancel
st_title st_title
dw_from_patient dw_from_patient
dw_into_patient dw_into_patient
st_1 st_1
st_2 st_2
cb_search_from cb_search_from
cb_search_into cb_search_into
cb_im_sure cb_im_sure
st_warning st_warning
end type
global w_svc_merge_patient w_svc_merge_patient

type variables
u_component_service	service

str_patient from_patient
str_patient into_patient


end variables

on w_svc_merge_patient.create
int iCurrent
call super::create
this.cb_finished=create cb_finished
this.cb_cancel=create cb_cancel
this.st_title=create st_title
this.dw_from_patient=create dw_from_patient
this.dw_into_patient=create dw_into_patient
this.st_1=create st_1
this.st_2=create st_2
this.cb_search_from=create cb_search_from
this.cb_search_into=create cb_search_into
this.cb_im_sure=create cb_im_sure
this.st_warning=create st_warning
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_finished
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.st_title
this.Control[iCurrent+4]=this.dw_from_patient
this.Control[iCurrent+5]=this.dw_into_patient
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.cb_search_from
this.Control[iCurrent+9]=this.cb_search_into
this.Control[iCurrent+10]=this.cb_im_sure
this.Control[iCurrent+11]=this.st_warning
end on

on w_svc_merge_patient.destroy
call super::destroy
destroy(this.cb_finished)
destroy(this.cb_cancel)
destroy(this.st_title)
destroy(this.dw_from_patient)
destroy(this.dw_into_patient)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.cb_search_from)
destroy(this.cb_search_into)
destroy(this.cb_im_sure)
destroy(this.st_warning)
end on

event open;call super::open;integer li_sts
integer ll_menu_id
string ls_cpr_id

service = message.powerobjectparm

// Set the title and sizes
If isvalid(current_patient) and not isnull(current_patient) Then
	title = current_patient.id_line()
End If

if len(st_title.text) > 42 then
	if len(st_title.text) > 60 then
		if len(st_title.text) > 70 then
			st_title.textsize = -10
		else
			st_title.textsize = -12
		end if
	else
		st_title.textsize = -14
	end if
else
	st_title.textsize = -18
end if

ll_menu_id = long(service.get_attribute("menu_id"))
paint_menu(ll_menu_id)

setnull(from_patient.cpr_id)
setnull(into_patient.cpr_id)

ls_cpr_id = service.get_attribute("from_cpr_id")
if not isnull(ls_cpr_id) then
	li_sts = f_get_patient(ls_cpr_id, from_patient)
	if li_sts > 0 then
		dw_from_patient.display_patient(from_patient)
	end if
end if

ls_cpr_id = service.get_attribute("into_cpr_id")
if not isnull(ls_cpr_id) then
	li_sts = f_get_patient(ls_cpr_id, into_patient)
	if li_sts > 0 then
		dw_from_patient.display_patient(into_patient)
	end if
end if

if not isnull(from_patient.cpr_id) and not isnull(into_patient.cpr_id) then
	cb_finished.enabled = true
else
	cb_finished.enabled = false
end if

cb_finished.visible = true
cb_search_from.visible = true
cb_search_into.visible = true

st_warning .visible = false
cb_im_sure.visible = false



end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_merge_patient
boolean visible = true
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_merge_patient
end type

type cb_finished from commandbutton within w_svc_merge_patient
integer x = 1230
integer y = 1268
integer width = 517
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Merge Patients"
end type

event clicked;string ls_warning

if from_patient.cpr_id = into_patient.cpr_id then
	openwithparm(w_pop_message, "From and Into patients must be different")
	return
end if


ls_warning = service.get_attribute("Warning Text")
if isnull(ls_warning) then
	ls_warning = "WARNING! This operation is permanent and cannot be undone."
	ls_warning += "  Are you sure you want to merge all of the clinical data from the patient"
	ls_warning += " chart on the left into the patient chart on the right?"
end if

st_warning.text = ls_warning

visible = false
cb_search_from.visible = false
cb_search_into.visible = false

st_warning .visible = true
cb_im_sure.visible = true


end event

type cb_cancel from commandbutton within w_svc_merge_patient
integer x = 2391
integer y = 1592
integer width = 443
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 1
popup_return.items[1] = "CANCEL"

closewithreturn(parent, popup_return)
end event

type st_title from statictext within w_svc_merge_patient
integer width = 2921
integer height = 120
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Patient Merge Utility"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_from_patient from u_dw_patient_info within w_svc_merge_patient
integer x = 133
integer y = 400
integer height = 652
integer taborder = 50
boolean bringtotop = true
string dataobject = "dw_patient_info2"
end type

type dw_into_patient from u_dw_patient_info within w_svc_merge_patient
integer x = 1541
integer y = 400
integer height = 652
integer taborder = 60
boolean bringtotop = true
string dataobject = "dw_patient_info2"
end type

type st_1 from statictext within w_svc_merge_patient
integer x = 133
integer y = 284
integer width = 1248
integer height = 104
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Merge This Patient"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_svc_merge_patient
integer x = 1541
integer y = 284
integer width = 1248
integer height = 104
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Into This Patient"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_search_from from commandbutton within w_svc_merge_patient
integer x = 549
integer y = 1088
integer width = 402
integer height = 112
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Search"
end type

event clicked;w_patient_select lw_window
str_popup_return popup_return
integer li_sts

open(lw_window, "w_patient_select")
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

li_sts = f_get_patient(popup_return.items[1], from_patient)
if li_sts > 0 then
	dw_from_patient.display_patient(from_patient)
end if


if not isnull(from_patient.cpr_id) and not isnull(into_patient.cpr_id) then
	cb_finished.enabled = true
else
	cb_finished.enabled = false
end if

end event

type cb_search_into from commandbutton within w_svc_merge_patient
integer x = 1957
integer y = 1088
integer width = 402
integer height = 112
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Search"
end type

event clicked;w_patient_select lw_window
str_popup_return popup_return
integer li_sts

open(lw_window, "w_patient_select")
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

li_sts = f_get_patient(popup_return.items[1], into_patient)
if li_sts > 0 then
	dw_into_patient.display_patient(into_patient)
end if


if not isnull(from_patient.cpr_id) and not isnull(into_patient.cpr_id) then
	cb_finished.enabled = true
else
	cb_finished.enabled = false
end if

end event

type cb_im_sure from commandbutton within w_svc_merge_patient
integer x = 1230
integer y = 1360
integer width = 517
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I~'m Sure"
end type

event clicked;str_popup_return popup_return
integer li_sts
string ls_message
integer li_please_wait_index
long ll_count
string ls_name

ls_message = service.get_attribute("Are You Sure Text 1")
if isnull(ls_message) then
	ls_message = "This operation moves all of the clinical data from one electronic chart into"
	ls_message += " another electronic chart.  The data is removed from the ~"From~" chart and"
	ls_message += " the ~"From~" chart is left empty and unavailable.  This operation cannot be undone."
	ls_message += "  Are you sure you want to do this?"
end if

openwithparm(w_pop_yes_no_alert, ls_message)
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

ls_message = service.get_attribute("Are You Sure Text 2")
if isnull(ls_message) then
	ls_message = "In order to merge these charts, EncounterPRO will need to lock all of the patient"
	ls_message += " tables for the duration of the merge processing.  The processing may take up to"
	ls_message += " a minute and may result in other users seeing EncounterPRO freeze during that time."
	ls_message += "  Are you absolutely sure you want to do this?"
end if

openwithparm(w_pop_yes_no_alert, ls_message)
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

SELECT count(*)
INTO :ll_count
FROM p_Attachment
WHERE cpr_id = :from_patient.cpr_id
AND storage_flag = 'F'
AND status <> 'CANCELLED';
if not tf_check() then return

if ll_count > 0 then
	ls_name = f_pretty_name( from_patient.last_name, &
									from_patient.first_name, &
									from_patient.middle_name, &
									from_patient.name_suffix, &
									from_patient.name_prefix, &
									from_patient.degree)
	ls_message = "The ~"From~" patient (" + ls_name + ") has attachments stored outside of the database."
	ls_message += "  In order to merge this patient into another patient, the attachments must first all be"
	ls_message += " moved into the database.  Do you wish to move the attachments now?"

	openwithparm(w_pop_yes_no_alert, ls_message)
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return
	
	li_sts = f_move_attachments_into_database(from_patient.cpr_id)
	if li_sts < 0 then
		openwithparm(w_pop_message, "Move Attachments Failed")
		return
	end if
end if


li_please_wait_index = f_please_wait_open()
li_sts = sqlca.sp_patient_merge(into_patient.cpr_id, from_patient.cpr_id)
f_please_wait_close(li_please_wait_index)

if not tf_check() or li_sts <= 0 then
	openwithparm(w_pop_message, "Merging Patients Failed.  Check the error log and try again later.")
	return
else
	openwithparm(w_pop_message, "Merging Patients Succeeded.")
end if

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)

end event

type st_warning from statictext within w_svc_merge_patient
integer x = 389
integer y = 1076
integer width = 2135
integer height = 244
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 65535
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

