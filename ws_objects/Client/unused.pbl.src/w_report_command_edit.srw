$PBExportHeader$w_report_command_edit.srw
forward
global type w_report_command_edit from w_window_base
end type
type st_co_title from statictext within w_report_command_edit
end type
type st_co_general from statictext within w_report_command_edit
end type
type st_co_patient from statictext within w_report_command_edit
end type
type st_co_encounter from statictext within w_report_command_edit
end type
type st_co_assessment from statictext within w_report_command_edit
end type
type st_co_treatment from statictext within w_report_command_edit
end type
type st_command_title from statictext within w_report_command_edit
end type
type mle_command_help from multilineedit within w_report_command_edit
end type
type st_1 from statictext within w_report_command_edit
end type
type st_command from statictext within w_report_command_edit
end type
type st_3 from statictext within w_report_command_edit
end type
type sle_argument from singlelineedit within w_report_command_edit
end type
type cb_ok from commandbutton within w_report_command_edit
end type
type cb_cancel from commandbutton within w_report_command_edit
end type
end forward

global type w_report_command_edit from w_window_base
string title = "EncounterPRO Report Command Create/Edit"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_co_title st_co_title
st_co_general st_co_general
st_co_patient st_co_patient
st_co_encounter st_co_encounter
st_co_assessment st_co_assessment
st_co_treatment st_co_treatment
st_command_title st_command_title
mle_command_help mle_command_help
st_1 st_1
st_command st_command
st_3 st_3
sle_argument sle_argument
cb_ok cb_ok
cb_cancel cb_cancel
end type
global w_report_command_edit w_report_command_edit

type variables
str_c_report_command c_report_command
str_c_report_command original_report_command

end variables

on w_report_command_edit.create
int iCurrent
call super::create
this.st_co_title=create st_co_title
this.st_co_general=create st_co_general
this.st_co_patient=create st_co_patient
this.st_co_encounter=create st_co_encounter
this.st_co_assessment=create st_co_assessment
this.st_co_treatment=create st_co_treatment
this.st_command_title=create st_command_title
this.mle_command_help=create mle_command_help
this.st_1=create st_1
this.st_command=create st_command
this.st_3=create st_3
this.sle_argument=create sle_argument
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_co_title
this.Control[iCurrent+2]=this.st_co_general
this.Control[iCurrent+3]=this.st_co_patient
this.Control[iCurrent+4]=this.st_co_encounter
this.Control[iCurrent+5]=this.st_co_assessment
this.Control[iCurrent+6]=this.st_co_treatment
this.Control[iCurrent+7]=this.st_command_title
this.Control[iCurrent+8]=this.mle_command_help
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.st_command
this.Control[iCurrent+11]=this.st_3
this.Control[iCurrent+12]=this.sle_argument
this.Control[iCurrent+13]=this.cb_ok
this.Control[iCurrent+14]=this.cb_cancel
end on

on w_report_command_edit.destroy
call super::destroy
destroy(this.st_co_title)
destroy(this.st_co_general)
destroy(this.st_co_patient)
destroy(this.st_co_encounter)
destroy(this.st_co_assessment)
destroy(this.st_co_treatment)
destroy(this.st_command_title)
destroy(this.mle_command_help)
destroy(this.st_1)
destroy(this.st_command)
destroy(this.st_3)
destroy(this.sle_argument)
destroy(this.cb_ok)
destroy(this.cb_cancel)
end on

event open;call super::open;

original_report_command = message.powerobjectparm
c_report_command = original_report_command

CHOOSE CASE lower(c_report_command.context_object)
	CASE "patient"
		st_co_patient.backcolor = color_object_selected
	CASE "encounter"
		st_co_encounter.backcolor = color_object_selected
	CASE "assessment"
		st_co_assessment.backcolor = color_object_selected
	CASE "treatment"
		st_co_treatment.backcolor = color_object_selected
	CASE ELSE
		c_report_command.context_object = "general"
		st_co_general.backcolor = color_object_selected
END CHOOSE

st_command.text = c_report_command.command
sle_argument.text = c_report_command.argument


end event

type pb_epro_help from w_window_base`pb_epro_help within w_report_command_edit
boolean visible = true
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_report_command_edit
end type

type st_co_title from statictext within w_report_command_edit
integer x = 78
integer y = 120
integer width = 585
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Context Object"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_co_general from statictext within w_report_command_edit
integer x = 78
integer y = 212
integer width = 585
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "General"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_co_general.backcolor = color_object_selected
st_co_patient.backcolor = color_object
st_co_encounter.backcolor = color_object
st_co_assessment.backcolor = color_object
st_co_treatment.backcolor = color_object

c_report_command.context_object = "general"

end event

type st_co_patient from statictext within w_report_command_edit
integer x = 78
integer y = 328
integer width = 585
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Patient"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_co_general.backcolor = color_object
st_co_patient.backcolor = color_object_selected
st_co_encounter.backcolor = color_object
st_co_assessment.backcolor = color_object
st_co_treatment.backcolor = color_object

c_report_command.context_object = "patient"

end event

type st_co_encounter from statictext within w_report_command_edit
integer x = 78
integer y = 444
integer width = 585
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Encounter"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_co_general.backcolor = color_object
st_co_patient.backcolor = color_object
st_co_encounter.backcolor = color_object_selected
st_co_assessment.backcolor = color_object
st_co_treatment.backcolor = color_object

c_report_command.context_object = "encounter"

end event

type st_co_assessment from statictext within w_report_command_edit
integer x = 78
integer y = 560
integer width = 585
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Assessment"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_co_general.backcolor = color_object
st_co_patient.backcolor = color_object
st_co_encounter.backcolor = color_object
st_co_assessment.backcolor = color_object_selected
st_co_treatment.backcolor = color_object

c_report_command.context_object = "assessment"

end event

type st_co_treatment from statictext within w_report_command_edit
integer x = 78
integer y = 676
integer width = 585
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Treatment"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_co_general.backcolor = color_object
st_co_patient.backcolor = color_object
st_co_encounter.backcolor = color_object
st_co_assessment.backcolor = color_object
st_co_treatment.backcolor = color_object_selected

c_report_command.context_object = "treatment"

end event

type st_command_title from statictext within w_report_command_edit
integer x = 750
integer y = 120
integer width = 841
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Command"
alignment alignment = center!
boolean focusrectangle = false
end type

type mle_command_help from multilineedit within w_report_command_edit
integer x = 1678
integer y = 212
integer width = 1166
integer height = 1232
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean autovscroll = true
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_report_command_edit
integer x = 1678
integer y = 120
integer width = 1166
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Command Help"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_command from statictext within w_report_command_edit
integer x = 750
integer y = 212
integer width = 841
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_c_report_command_pick"
popup.argument_count = 1
popup.argument[1] = c_report_command.context_object
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

c_report_command.command = popup_return.items[1]
text = c_report_command.command

SELECT command_help
INTO :mle_command_help.text
FROM c_report_command
WHERE context_object = :c_report_command.context_object
AND command = :c_report_command.command;
if not tf_check() then mle_command_help.text = ""
if sqlca.sqlcode = 100 then mle_command_help.text = ""

end event

type st_3 from statictext within w_report_command_edit
integer x = 91
integer y = 936
integer width = 443
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Argument"
boolean focusrectangle = false
end type

type sle_argument from singlelineedit within w_report_command_edit
integer x = 73
integer y = 1016
integer width = 1518
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;c_report_command.argument = text

end event

type cb_ok from commandbutton within w_report_command_edit
integer x = 2441
integer y = 1580
integer width = 402
integer height = 112
integer taborder = 40
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

event clicked;closewithreturn(parent, c_report_command)

end event

type cb_cancel from commandbutton within w_report_command_edit
integer x = 78
integer y = 1580
integer width = 402
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;closewithreturn(parent, original_report_command)

end event

