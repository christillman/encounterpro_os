HA$PBExportHeader$w_svc_encounter_review.srw
forward
global type w_svc_encounter_review from w_window_base
end type
type cb_done from commandbutton within w_svc_encounter_review
end type
type cb_be_back from commandbutton within w_svc_encounter_review
end type
type tab_properties from u_tab_encounter_review within w_svc_encounter_review
end type
type tab_properties from u_tab_encounter_review within w_svc_encounter_review
end type
end forward

global type w_svc_encounter_review from w_window_base
integer width = 2907
integer height = 1892
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean auto_resize_objects = false
boolean nested_user_object_resize = false
cb_done cb_done
cb_be_back cb_be_back
tab_properties tab_properties
end type
global w_svc_encounter_review w_svc_encounter_review

type variables
u_component_service service

end variables

on w_svc_encounter_review.create
int iCurrent
call super::create
this.cb_done=create cb_done
this.cb_be_back=create cb_be_back
this.tab_properties=create tab_properties
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_done
this.Control[iCurrent+2]=this.cb_be_back
this.Control[iCurrent+3]=this.tab_properties
end on

on w_svc_encounter_review.destroy
call super::destroy
destroy(this.cb_done)
destroy(this.cb_be_back)
destroy(this.tab_properties)
end on

event open;call super::open;str_popup popup
str_popup_return popup_return
integer li_sts
long ll_menu_id
string ls_progress_key_required_flag
string ls_progress_key_enumerated_flag
string ls_progress_type
integer li_count

popup_return.item_count = 0

service = message.powerobjectparm

title = current_patient.id_line()

if isnull(service.encounter_id) then
	log.log(this, "open", "Null encounter_id", 4)
	closewithreturn(this, popup_return)
	return
end if


cb_done.x = width - cb_done.width - 52
cb_done.y = height - cb_done.height - 144

cb_be_back.x = cb_done.x - cb_be_back.width - 32
cb_be_back.y = cb_done.y

if service.manual_service then
	pb_epro_help.x = cb_be_back.x
else
	pb_epro_help.x = cb_be_back.x - pb_epro_help.width - 32
end if
pb_epro_help.y = cb_done.y


// Don't offer the "I'll Be Back" option for manual services
if service.manual_service then
	cb_be_back.visible = false
	max_buttons = (pb_epro_help.x - spacing) / (button_width + spacing)
end if

ll_menu_id = long(service.get_attribute("menu_id"))
if not isnull(ll_menu_id) then
	paint_menu(ll_menu_id)
end if


state_attributes.attribute_count = 1
state_attributes.attribute[1].attribute = "encounter_id"
state_attributes.attribute[1].value = string(service.encounter_id)

tab_properties.resize_tabs(width - 30, button_top - 30)

tab_properties.initialize(service)


end event

event close;integer i

for i = 1 to button_count
	if button_type = "COMMAND" then
		closeuserobject(cbuttons[i])
	else
		closeuserobject(pbuttons[i])
		closeuserobject(titles[i])
	end if
next

button_count = 0

end event

event button_pressed;call super::button_pressed;tab_properties.refresh()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_encounter_review
integer x = 2839
integer y = 28
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_encounter_review
integer x = 14
integer y = 1520
end type

type cb_done from commandbutton within w_svc_encounter_review
integer x = 2432
integer y = 1600
integer width = 443
integer height = 108
integer taborder = 160
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
integer li_sts

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)

end event

type cb_be_back from commandbutton within w_svc_encounter_review
integer x = 1966
integer y = 1600
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

type tab_properties from u_tab_encounter_review within w_svc_encounter_review
integer width = 2889
integer height = 1520
integer taborder = 20
boolean bringtotop = true
end type

