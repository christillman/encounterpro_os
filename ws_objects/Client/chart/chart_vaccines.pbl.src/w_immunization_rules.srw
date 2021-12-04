$PBExportHeader$w_immunization_rules.srw
forward
global type w_immunization_rules from w_window_base
end type
type dw_immunization_rules from u_dw_pick_list within w_immunization_rules
end type
type cb_ok from commandbutton within w_immunization_rules
end type
type st_title from statictext within w_immunization_rules
end type
end forward

global type w_immunization_rules from w_window_base
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
dw_immunization_rules dw_immunization_rules
cb_ok cb_ok
st_title st_title
end type
global w_immunization_rules w_immunization_rules

on w_immunization_rules.create
int iCurrent
call super::create
this.dw_immunization_rules=create dw_immunization_rules
this.cb_ok=create cb_ok
this.st_title=create st_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_immunization_rules
this.Control[iCurrent+2]=this.cb_ok
this.Control[iCurrent+3]=this.st_title
end on

on w_immunization_rules.destroy
call super::destroy
destroy(this.dw_immunization_rules)
destroy(this.cb_ok)
destroy(this.st_title)
end on

event open;call super::open;str_disease_group lstr_disease_group

lstr_disease_group = message.powerobjectparm

dw_immunization_rules.object.dose_text.width = dw_immunization_rules.width - 489
dw_immunization_rules.object.l_1.x2 = dw_immunization_rules.width - 201
dw_immunization_rules.object.l_2.x2 = dw_immunization_rules.width - 201

dw_immunization_rules.settransobject(sqlca)
dw_immunization_rules.retrieve(lstr_disease_group.disease_group, &
											lstr_disease_group.disease_id)
											

st_title.text = lstr_disease_group.description + " Rules"

end event

type pb_epro_help from w_window_base`pb_epro_help within w_immunization_rules
boolean visible = true
integer x = 64
integer y = 1608
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_immunization_rules
end type

type dw_immunization_rules from u_dw_pick_list within w_immunization_rules
integer x = 105
integer y = 160
integer width = 2683
integer height = 1400
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_jmj_immunization_rules"
boolean vscrollbar = true
end type

type cb_ok from commandbutton within w_immunization_rules
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

type st_title from statictext within w_immunization_rules
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
long backcolor = COLOR_BACKGROUND
alignment alignment = center!
boolean focusrectangle = false
end type

