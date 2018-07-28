HA$PBExportHeader$w_assessment_type_definition.srw
forward
global type w_assessment_type_definition from w_window_base
end type
type cb_ok from commandbutton within w_assessment_type_definition
end type
type tab_assessment_type from u_tab_assessment_type_definition within w_assessment_type_definition
end type
type tab_assessment_type from u_tab_assessment_type_definition within w_assessment_type_definition
end type
end forward

global type w_assessment_type_definition from w_window_base
integer width = 2944
integer height = 1848
boolean titlebar = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean auto_resize_objects = false
boolean nested_user_object_resize = false
cb_ok cb_ok
tab_assessment_type tab_assessment_type
end type
global w_assessment_type_definition w_assessment_type_definition

type variables
boolean allow_editing

string assessment_type

end variables

event open;call super::open;str_popup popup
integer li_sts

assessment_type = message.stringparm

if user_list.is_user_service(current_user.user_id, "CONFIG_ASSESSMENTS") then
	allow_editing = true
else
	allow_editing = false
end if

cb_ok.x = width - cb_ok.width - 50
cb_ok.y = height - cb_ok.height - 50

tab_assessment_type.width = width
tab_assessment_type.height = cb_ok.y - 50


li_sts = tab_assessment_type.initialize(assessment_type)
if li_sts <= 0 then
	close(this)
	return
end if


end event

on w_assessment_type_definition.create
int iCurrent
call super::create
this.cb_ok=create cb_ok
this.tab_assessment_type=create tab_assessment_type
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ok
this.Control[iCurrent+2]=this.tab_assessment_type
end on

on w_assessment_type_definition.destroy
call super::destroy
destroy(this.cb_ok)
destroy(this.tab_assessment_type)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_assessment_type_definition
integer x = 2866
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_assessment_type_definition
end type

type cb_ok from commandbutton within w_assessment_type_definition
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

type tab_assessment_type from u_tab_assessment_type_definition within w_assessment_type_definition
integer width = 2935
integer height = 1696
integer taborder = 20
boolean bringtotop = true
end type

