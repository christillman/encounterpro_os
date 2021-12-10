$PBExportHeader$w_component_manage.srw
forward
global type w_component_manage from w_window_base
end type
type cb_ok from commandbutton within w_component_manage
end type
type st_title from statictext within w_component_manage
end type
type tab_component from u_tab_component within w_component_manage
end type
type tab_component from u_tab_component within w_component_manage
end type
end forward

global type w_component_manage from w_window_base
integer width = 2944
integer height = 1848
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean auto_resize_objects = false
boolean nested_user_object_resize = false
cb_ok cb_ok
st_title st_title
tab_component tab_component
end type
global w_component_manage w_component_manage

type variables

end variables

event open;call super::open;str_popup popup
integer li_sts
string ls_component_id
string ls_version_name

ls_component_id = message.stringparm
f_split_string(ls_component_id, "|", ls_component_id, ls_version_name)

st_title.width = width

cb_ok.x = width - cb_ok.width - 50
cb_ok.y = height - cb_ok.height - 50

tab_component.width = width - 50
tab_component.height = cb_ok.y - tab_component.y - 50

if user_list.is_user_privileged(current_user.user_id, "Edit System Config") then
	tab_component.allow_editing = true
else
	tab_component.allow_editing = false
end if

tab_component.initialize(ls_component_id, ls_version_name)

st_title.text = wordcap(tab_component.component.component_type) + " Component - " + tab_component.component.description

end event

on w_component_manage.create
int iCurrent
call super::create
this.cb_ok=create cb_ok
this.st_title=create st_title
this.tab_component=create tab_component
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ok
this.Control[iCurrent+2]=this.st_title
this.Control[iCurrent+3]=this.tab_component
end on

on w_component_manage.destroy
call super::destroy
destroy(this.cb_ok)
destroy(this.st_title)
destroy(this.tab_component)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_component_manage
integer x = 2875
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_component_manage
end type

type cb_ok from commandbutton within w_component_manage
integer x = 2414
integer y = 1712
integer width = 489
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;
close(parent)

end event

type st_title from statictext within w_component_manage
integer width = 2944
integer height = 108
boolean bringtotop = true
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Component"
alignment alignment = center!
boolean focusrectangle = false
end type

type tab_component from u_tab_component within w_component_manage
integer y = 120
integer height = 1564
integer taborder = 20
boolean bringtotop = true
end type

