$PBExportHeader$w_svc_change_office.srw
forward
global type w_svc_change_office from w_window_base
end type
type cb_finished from commandbutton within w_svc_change_office
end type
type cb_be_back from commandbutton within w_svc_change_office
end type
type cb_cancel from commandbutton within w_svc_change_office
end type
type st_title from statictext within w_svc_change_office
end type
type dw_office from u_dw_pick_list within w_svc_change_office
end type
type st_default_title from statictext within w_svc_change_office
end type
type st_default_yes from statictext within w_svc_change_office
end type
type st_default_no from statictext within w_svc_change_office
end type
end forward

global type w_svc_change_office from w_window_base
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_finished cb_finished
cb_be_back cb_be_back
cb_cancel cb_cancel
st_title st_title
dw_office dw_office
st_default_title st_default_title
st_default_yes st_default_yes
st_default_no st_default_no
end type
global w_svc_change_office w_svc_change_office

type variables
u_component_service	service
boolean set_default

end variables

on w_svc_change_office.create
int iCurrent
call super::create
this.cb_finished=create cb_finished
this.cb_be_back=create cb_be_back
this.cb_cancel=create cb_cancel
this.st_title=create st_title
this.dw_office=create dw_office
this.st_default_title=create st_default_title
this.st_default_yes=create st_default_yes
this.st_default_no=create st_default_no
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_finished
this.Control[iCurrent+2]=this.cb_be_back
this.Control[iCurrent+3]=this.cb_cancel
this.Control[iCurrent+4]=this.st_title
this.Control[iCurrent+5]=this.dw_office
this.Control[iCurrent+6]=this.st_default_title
this.Control[iCurrent+7]=this.st_default_yes
this.Control[iCurrent+8]=this.st_default_no
end on

on w_svc_change_office.destroy
call super::destroy
destroy(this.cb_finished)
destroy(this.cb_be_back)
destroy(this.cb_cancel)
destroy(this.st_title)
destroy(this.dw_office)
destroy(this.st_default_title)
destroy(this.st_default_yes)
destroy(this.st_default_no)
end on

event open;call super::open;integer ll_menu_id

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

// Don't offer the "I'll Be Back" option for manual services
max_buttons = 3
if service.manual_service then
	cb_be_back.visible = false
	cb_cancel.x = cb_be_back.x
	max_buttons = 4
end if

ll_menu_id = long(service.get_attribute("menu_id"))
paint_menu(ll_menu_id)

dw_office.object.office_nickname.width = dw_office.width - 100

dw_office.settransobject(sqlca)
dw_office.retrieve(current_user.user_id, "View Patients")

st_default_no.backcolor = color_object_selected
set_default = false

end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_change_office
boolean visible = true
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_change_office
integer width = 686
end type

type cb_finished from commandbutton within w_svc_change_office
integer x = 2427
integer y = 1612
integer width = 443
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
end type

event clicked;str_popup_return popup_return
long ll_row
integer li_sts

ll_row = dw_office.get_selected_row()
if ll_row <= 0 then return

li_sts = f_change_office(dw_office.object.office_id[ll_row], set_default)
if li_sts <= 0 then return

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)


end event

type cb_be_back from commandbutton within w_svc_change_office
integer x = 1961
integer y = 1612
integer width = 443
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I~'ll Be Back"
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 0
closewithreturn(parent, popup_return)
end event

type cb_cancel from commandbutton within w_svc_change_office
integer x = 1490
integer y = 1612
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

type st_title from statictext within w_svc_change_office
integer width = 2921
integer height = 120
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Change Office"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_office from u_dw_pick_list within w_svc_change_office
integer x = 937
integer y = 176
integer width = 933
integer height = 1340
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_fn_user_privilege_offices"
boolean vscrollbar = true
boolean border = false
end type

type st_default_title from statictext within w_svc_change_office
integer x = 2176
integer y = 780
integer width = 539
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
string text = "Set Default Office"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_default_yes from statictext within w_svc_change_office
integer x = 2162
integer y = 876
integer width = 256
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Yes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_default_no.backcolor = color_object
st_default_yes.backcolor = color_object_selected
set_default = true

end event

type st_default_no from statictext within w_svc_change_office
integer x = 2459
integer y = 876
integer width = 256
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "No"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_default_no.backcolor = color_object_selected
st_default_yes.backcolor = color_object
set_default = false

end event

