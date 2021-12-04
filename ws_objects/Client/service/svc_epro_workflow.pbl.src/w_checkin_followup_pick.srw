$PBExportHeader$w_checkin_followup_pick.srw
forward
global type w_checkin_followup_pick from w_window_base
end type
type dw_followups from u_dw_pick_list within w_checkin_followup_pick
end type
type st_title from statictext within w_checkin_followup_pick
end type
type cb_cancel from commandbutton within w_checkin_followup_pick
end type
type cb_ok from commandbutton within w_checkin_followup_pick
end type
type st_instructions from statictext within w_checkin_followup_pick
end type
type cb_not_related from commandbutton within w_checkin_followup_pick
end type
type cb_beback from commandbutton within w_checkin_followup_pick
end type
end forward

global type w_checkin_followup_pick from w_window_base
integer x = 439
integer y = 592
integer width = 2862
integer height = 1532
windowtype windowtype = response!
dw_followups dw_followups
st_title st_title
cb_cancel cb_cancel
cb_ok cb_ok
st_instructions st_instructions
cb_not_related cb_not_related
cb_beback cb_beback
end type
global w_checkin_followup_pick w_checkin_followup_pick

type variables
u_component_service service
end variables

event open;string ls_temp
str_window_return window_return
long ll_timeout
long ll_count
long ll_null

setnull(ll_null)

service = message.powerobjectparm

if lower(service.context_object) = "patient" then
	cb_not_related.visible = true
	cb_beback.visible = false
elseif service.manual_service then
	cb_not_related.visible = false
	cb_beback.visible = false
else
	cb_not_related.visible = false
	cb_beback.visible = true
end if

dw_followups.settransobject(sqlca)
ll_count = dw_followups.retrieve(service.cpr_id)

// An error occured
if ll_count < 0 then
	window_return.return_status = -1
	closewithreturn(this, window_return)
	return
end if

// There aren't any followups to choose from
if ll_count = 0 then
	window_return.return_status = 1
	window_return.return_value = ll_null
	closewithreturn(this, window_return)
	return
end if

if ll_count = 1 then
	dw_followups.object.selected_flag[1] = 1
	dw_followups.event trigger selected(1)
end if


end event

on w_checkin_followup_pick.create
int iCurrent
call super::create
this.dw_followups=create dw_followups
this.st_title=create st_title
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.st_instructions=create st_instructions
this.cb_not_related=create cb_not_related
this.cb_beback=create cb_beback
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_followups
this.Control[iCurrent+2]=this.st_title
this.Control[iCurrent+3]=this.cb_cancel
this.Control[iCurrent+4]=this.cb_ok
this.Control[iCurrent+5]=this.st_instructions
this.Control[iCurrent+6]=this.cb_not_related
this.Control[iCurrent+7]=this.cb_beback
end on

on w_checkin_followup_pick.destroy
call super::destroy
destroy(this.dw_followups)
destroy(this.st_title)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.st_instructions)
destroy(this.cb_not_related)
destroy(this.cb_beback)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_checkin_followup_pick
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_checkin_followup_pick
end type

type dw_followups from u_dw_pick_list within w_checkin_followup_pick
integer x = 37
integer y = 452
integer width = 2747
integer height = 648
integer taborder = 10
string dataobject = "dw_jmj_patient_pending_followups"
boolean vscrollbar = true
end type

event selected;call super::selected;
cb_ok.enabled = true

end event

event unselected;call super::unselected;
cb_ok.enabled = false


end event

type st_title from statictext within w_checkin_followup_pick
integer width = 2825
integer height = 140
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Encounter Appointment/Followup"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_checkin_followup_pick
integer x = 59
integer y = 1296
integer width = 498
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;long ll_row
str_window_return window_return
long ll_null

setnull(ll_null)

window_return.return_status = 2
window_return.return_value = ll_null

closewithreturn(parent, window_return)


end event

type cb_ok from commandbutton within w_checkin_followup_pick
integer x = 2254
integer y = 1296
integer width = 498
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "OK"
end type

event clicked;long ll_row
str_window_return window_return

ll_row = dw_followups.get_selected_row()
if ll_row <= 0 then
	openwithparm(w_pop_message, "Please select a followup order before clicking OK")
	return
end if

window_return.return_status = 1
window_return.return_value = dw_followups.object.treatment_id[ll_row]

closewithreturn(parent, window_return)


end event

type st_instructions from statictext within w_checkin_followup_pick
integer x = 201
integer y = 156
integer width = 2405
integer height = 176
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "This patient has these appointments and followup orders pending.  Select the followup order which is related to this encounter."
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type cb_not_related from commandbutton within w_checkin_followup_pick
integer x = 626
integer y = 1296
integer width = 1541
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "This encounter is not related to a followup order"
end type

event clicked;long ll_row
str_window_return window_return
long ll_null

setnull(ll_null)

window_return.return_status = 1
window_return.return_value = ll_null

closewithreturn(parent, window_return)


end event

type cb_beback from commandbutton within w_checkin_followup_pick
integer x = 1669
integer y = 1296
integer width = 498
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I~'ll Be Back"
end type

event clicked;long ll_row
str_window_return window_return

window_return.return_status = 0
setnull(window_return.return_value)

closewithreturn(parent, window_return)


end event

