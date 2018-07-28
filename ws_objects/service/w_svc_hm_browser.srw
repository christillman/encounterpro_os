HA$PBExportHeader$w_svc_hm_browser.srw
forward
global type w_svc_hm_browser from w_window_base
end type
type st_title from statictext within w_svc_hm_browser
end type
type cb_finished from commandbutton within w_svc_hm_browser
end type
type st_class_description from statictext within w_svc_hm_browser
end type
type tab_hm_class from u_tab_hm_class_main within w_svc_hm_browser
end type
type tab_hm_class from u_tab_hm_class_main within w_svc_hm_browser
end type
end forward

global type w_svc_hm_browser from w_window_base
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean auto_resize_objects = false
boolean nested_user_object_resize = false
st_title st_title
cb_finished cb_finished
st_class_description st_class_description
tab_hm_class tab_hm_class
end type
global w_svc_hm_browser w_svc_hm_browser

type variables
u_component_service service
str_hm_context hm_context

end variables

on w_svc_hm_browser.create
int iCurrent
call super::create
this.st_title=create st_title
this.cb_finished=create cb_finished
this.st_class_description=create st_class_description
this.tab_hm_class=create tab_hm_class
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.cb_finished
this.Control[iCurrent+3]=this.st_class_description
this.Control[iCurrent+4]=this.tab_hm_class
end on

on w_svc_hm_browser.destroy
call super::destroy
destroy(this.st_title)
destroy(this.cb_finished)
destroy(this.st_class_description)
destroy(this.tab_hm_class)
end on

event open;call super::open;

service = message.powerobjectparm

service.get_attribute("maintenance_rule_id", hm_context.maintenance_rule_id)
service.get_attribute("compliant_filter", hm_context.compliant_filter)
service.get_attribute("controlled_filter", hm_context.controlled_filter)
service.get_attribute("measured_filter", hm_context.measured_filter)
service.get_attribute("mode", hm_context.mode)
service.get_attribute("tabpage", hm_context.tabpage)


st_title.width = width

st_class_description.x = (width - st_class_description.width) / 2

tab_hm_class.width = width
tab_hm_class.height = height - tab_hm_class.y - 180

cb_finished.x = width - 460
cb_finished.y = height - 160

tab_hm_class.initialize(hm_context)

if tab_hm_class.initial_tab > 1 then
	tab_hm_class.function POST selecttab(tab_hm_class.initial_tab)
end if

st_class_description.text = tab_hm_class.hm_class.description

end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_hm_browser
integer x = 2857
integer y = 28
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_hm_browser
end type

type st_title from statictext within w_svc_hm_browser
integer width = 2921
integer height = 100
boolean bringtotop = true
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Health Management Class Status"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_finished from commandbutton within w_svc_hm_browser
integer x = 2450
integer y = 1676
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
string text = "Finished"
boolean default = true
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)

end event

type st_class_description from statictext within w_svc_hm_browser
integer x = 347
integer y = 120
integer width = 2222
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
boolean enabled = false
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type tab_hm_class from u_tab_hm_class_main within w_svc_hm_browser
integer y = 240
integer width = 2917
integer height = 1408
integer taborder = 20
boolean bringtotop = true
end type

