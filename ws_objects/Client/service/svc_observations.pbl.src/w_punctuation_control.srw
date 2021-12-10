$PBExportHeader$w_punctuation_control.srw
forward
global type w_punctuation_control from w_window_base
end type
type st_1 from statictext within w_punctuation_control
end type
type st_2 from statictext within w_punctuation_control
end type
type sle_punctuation from singlelineedit within w_punctuation_control
end type
type st_cr_period from statictext within w_punctuation_control
end type
type st_cr_always from statictext within w_punctuation_control
end type
type st_cr_never from statictext within w_punctuation_control
end type
type cb_finished from commandbutton within w_punctuation_control
end type
end forward

global type w_punctuation_control from w_window_base
integer x = 498
integer y = 400
integer width = 1975
integer height = 1024
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_1 st_1
st_2 st_2
sle_punctuation sle_punctuation
st_cr_period st_cr_period
st_cr_always st_cr_always
st_cr_never st_cr_never
cb_finished cb_finished
end type
global w_punctuation_control w_punctuation_control

type variables
string cr_rule

end variables

on w_punctuation_control.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_2=create st_2
this.sle_punctuation=create sle_punctuation
this.st_cr_period=create st_cr_period
this.st_cr_always=create st_cr_always
this.st_cr_never=create st_cr_never
this.cb_finished=create cb_finished
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.sle_punctuation
this.Control[iCurrent+4]=this.st_cr_period
this.Control[iCurrent+5]=this.st_cr_always
this.Control[iCurrent+6]=this.st_cr_never
this.Control[iCurrent+7]=this.cb_finished
end on

on w_punctuation_control.destroy
call super::destroy
destroy(this.st_1)
destroy(this.st_2)
destroy(this.sle_punctuation)
destroy(this.st_cr_period)
destroy(this.st_cr_always)
destroy(this.st_cr_never)
destroy(this.cb_finished)
end on

event open;call super::open;string ls_control

ls_control = message.stringparm

if isnull(ls_control) then
	cr_rule = "PERIOD"
	sle_punctuation.text = ", "
else
	f_split_string(ls_control, "|", cr_rule, sle_punctuation.text)
end if

CHOOSE CASE UPPER(cr_rule)
	CASE "ALWAYS"
		st_cr_always.backcolor = color_object_selected
	CASE "NEVER"
		st_cr_never.backcolor = color_object_selected
	CASE ELSE
		cr_rule = "PERIOD"
		st_cr_period.backcolor = color_object_selected
END CHOOSE


end event

type pb_epro_help from w_window_base`pb_epro_help within w_punctuation_control
boolean visible = true
integer x = 59
integer y = 860
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_punctuation_control
end type

type st_1 from statictext within w_punctuation_control
integer y = 128
integer width = 1161
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Punctuation between selected items:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_punctuation_control
integer x = 101
integer y = 332
integer width = 1061
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Carriage Return When:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_punctuation from singlelineedit within w_punctuation_control
integer x = 1221
integer y = 108
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
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_cr_period from statictext within w_punctuation_control
integer x = 1221
integer y = 472
integer width = 576
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "After a period (.)"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;cr_rule = "PERIOD"
st_cr_always.backcolor = color_object
st_cr_period.backcolor = color_object_selected
st_cr_never.backcolor = color_object

end event

type st_cr_always from statictext within w_punctuation_control
integer x = 1221
integer y = 320
integer width = 576
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Always"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;cr_rule = "ALWAYS"
st_cr_always.backcolor = color_object_selected
st_cr_period.backcolor = color_object
st_cr_never.backcolor = color_object

end event

type st_cr_never from statictext within w_punctuation_control
integer x = 1221
integer y = 624
integer width = 576
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Never"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;cr_rule = "NEVER"
st_cr_always.backcolor = color_object
st_cr_period.backcolor = color_object
st_cr_never.backcolor = color_object_selected

end event

type cb_finished from commandbutton within w_punctuation_control
integer x = 1504
integer y = 860
integer width = 402
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
boolean default = true
end type

event clicked;string ls_control

ls_control = cr_rule + "|" + sle_punctuation.text

closewithreturn(parent, ls_control)

end event

