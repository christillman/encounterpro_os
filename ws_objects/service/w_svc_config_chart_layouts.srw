HA$PBExportHeader$w_svc_config_chart_layouts.srw
forward
global type w_svc_config_chart_layouts from w_window_base
end type
type cb_ok from commandbutton within w_svc_config_chart_layouts
end type
type st_1 from statictext within w_svc_config_chart_layouts
end type
end forward

global type w_svc_config_chart_layouts from w_window_base
integer height = 1836
windowtype windowtype = response!
cb_ok cb_ok
st_1 st_1
end type
global w_svc_config_chart_layouts w_svc_config_chart_layouts

type variables
boolean top_20_list

string top_20_code
string top_20_user_id
string top_20_bitmap

string top_20_dataobject
string alpha_dataobject
string cat_dataobject
string cat_pick_dataobject

string assessment_type
string assessment_type_description
string specialty_id

string search_type

string common_flag = "Y"

end variables

on w_svc_config_chart_layouts.create
int iCurrent
call super::create
this.cb_ok=create cb_ok
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ok
this.Control[iCurrent+2]=this.st_1
end on

on w_svc_config_chart_layouts.destroy
call super::destroy
destroy(this.cb_ok)
destroy(this.st_1)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_svc_config_chart_layouts
integer x = 2830
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_config_chart_layouts
end type

type cb_ok from commandbutton within w_svc_config_chart_layouts
integer x = 2400
integer y = 1548
integer width = 402
integer height = 112
integer taborder = 90
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;str_popup_return popup_return
integer li_sts

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)
end event

type st_1 from statictext within w_svc_config_chart_layouts
integer x = 603
integer y = 512
integer width = 1669
integer height = 236
boolean bringtotop = true
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Under Construction"
alignment alignment = center!
boolean focusrectangle = false
end type

