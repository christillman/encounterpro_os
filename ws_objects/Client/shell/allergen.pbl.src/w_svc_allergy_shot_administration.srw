$PBExportHeader$w_svc_allergy_shot_administration.srw
forward
global type w_svc_allergy_shot_administration from w_window_base
end type
type cb_be_back from commandbutton within w_svc_allergy_shot_administration
end type
type cb_finished from commandbutton within w_svc_allergy_shot_administration
end type
type tab_allergy_treatments from u_tab_vials_for_injection within w_svc_allergy_shot_administration
end type
type tab_allergy_treatments from u_tab_vials_for_injection within w_svc_allergy_shot_administration
end type
type st_no_treatments from statictext within w_svc_allergy_shot_administration
end type
end forward

global type w_svc_allergy_shot_administration from w_window_base
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
string button_type = "COMMAND"
integer max_buttons = 3
event add_state_attributes pbm_custom01
cb_be_back cb_be_back
cb_finished cb_finished
tab_allergy_treatments tab_allergy_treatments
st_no_treatments st_no_treatments
end type
global w_svc_allergy_shot_administration w_svc_allergy_shot_administration

event add_state_attributes;// add the treatment id in state attributes so that the menus can be
// active

string ls_value


ls_value = string(message.wordparm)
f_attribute_add_attribute(state_attributes,"treatment_id",ls_value)
end event

on w_svc_allergy_shot_administration.create
int iCurrent
call super::create
this.cb_be_back=create cb_be_back
this.cb_finished=create cb_finished
this.tab_allergy_treatments=create tab_allergy_treatments
this.st_no_treatments=create st_no_treatments
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_be_back
this.Control[iCurrent+2]=this.cb_finished
this.Control[iCurrent+3]=this.tab_allergy_treatments
this.Control[iCurrent+4]=this.st_no_treatments
end on

on w_svc_allergy_shot_administration.destroy
call super::destroy
destroy(this.cb_be_back)
destroy(this.cb_finished)
destroy(this.tab_allergy_treatments)
destroy(this.st_no_treatments)
end on

event open;call super::open;long		ll_menu_id

u_component_service			service


service = message.powerobjectparm
tab_allergy_treatments.service = service

if tab_allergy_treatments.initialize() <= 0 Then
	tab_allergy_treatments.visible = false
	st_no_treatments.visible = true
else
	tab_allergy_treatments.visible = true
	st_no_treatments.visible = false
end if

// Don't offer the "I'll Be Back" option for manual services
if service.manual_service then
	cb_be_back.visible = false
	max_buttons = 4
end if

ll_menu_id = long(service.get_attribute("menu_id"))
if not isnull(ll_menu_id) then paint_menu(ll_menu_id)


end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_allergy_shot_administration
integer x = 1673
integer y = 1628
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_allergy_shot_administration
integer x = 23
integer y = 1652
end type

type cb_be_back from commandbutton within w_svc_allergy_shot_administration
integer x = 1934
integer y = 1612
integer width = 443
integer height = 108
integer taborder = 170
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

type cb_finished from commandbutton within w_svc_allergy_shot_administration
integer x = 2400
integer y = 1612
integer width = 443
integer height = 108
integer taborder = 180
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

popup_return.item_count = 1
popup_return.items[1] = "OK"
closewithreturn(parent, popup_return)


end event

type tab_allergy_treatments from u_tab_vials_for_injection within w_svc_allergy_shot_administration
integer taborder = 20
end type

type st_no_treatments from statictext within w_svc_allergy_shot_administration
boolean visible = false
integer x = 293
integer y = 488
integer width = 2478
integer height = 356
integer textsize = -18
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "No Open Allergy Treatments"
alignment alignment = center!
boolean focusrectangle = false
end type

