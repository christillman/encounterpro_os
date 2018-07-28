HA$PBExportHeader$w_immunization_schedule.srw
forward
global type w_immunization_schedule from w_window_base
end type
type dw_immunization_schedule from u_dw_pick_list within w_immunization_schedule
end type
type cb_ok from commandbutton within w_immunization_schedule
end type
type st_title from statictext within w_immunization_schedule
end type
type cb_show_rules from commandbutton within w_immunization_schedule
end type
end forward

global type w_immunization_schedule from w_window_base
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
dw_immunization_schedule dw_immunization_schedule
cb_ok cb_ok
st_title st_title
cb_show_rules cb_show_rules
end type
global w_immunization_schedule w_immunization_schedule

type variables
str_disease_group disease_group_context

end variables

on w_immunization_schedule.create
int iCurrent
call super::create
this.dw_immunization_schedule=create dw_immunization_schedule
this.cb_ok=create cb_ok
this.st_title=create st_title
this.cb_show_rules=create cb_show_rules
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_immunization_schedule
this.Control[iCurrent+2]=this.cb_ok
this.Control[iCurrent+3]=this.st_title
this.Control[iCurrent+4]=this.cb_show_rules
end on

on w_immunization_schedule.destroy
call super::destroy
destroy(this.dw_immunization_schedule)
destroy(this.cb_ok)
destroy(this.st_title)
destroy(this.cb_show_rules)
end on

event open;call super::open;
disease_group_context = message.powerobjectparm

dw_immunization_schedule.object.dose_text.width = dw_immunization_schedule.width - 1147
dw_immunization_schedule.object.l_1.x2 = dw_immunization_schedule.width - 118
dw_immunization_schedule.object.l_2.x2 = dw_immunization_schedule.width - 118

dw_immunization_schedule.settransobject(sqlca)
dw_immunization_schedule.retrieve(current_patient.cpr_id, &
											disease_group_context.disease_group, &
											disease_group_context.disease_id)
											

st_title.text = disease_group_context.description + " Schedule"

end event

type pb_epro_help from w_window_base`pb_epro_help within w_immunization_schedule
boolean visible = true
integer x = 64
integer y = 1608
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_immunization_schedule
end type

type dw_immunization_schedule from u_dw_pick_list within w_immunization_schedule
integer x = 105
integer y = 160
integer width = 2683
integer height = 1400
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_jmj_patient_immunization_schedule"
boolean vscrollbar = true
end type

type cb_ok from commandbutton within w_immunization_schedule
integer x = 2437
integer y = 1608
integer width = 402
integer height = 112
integer taborder = 21
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;close(parent)

end event

type st_title from statictext within w_immunization_schedule
integer width = 2921
integer height = 112
boolean bringtotop = true
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_show_rules from commandbutton within w_immunization_schedule
integer x = 1157
integer y = 1608
integer width = 402
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Show Rules"
end type

event clicked;openwithparm(w_immunization_rules, disease_group_context)

end event

