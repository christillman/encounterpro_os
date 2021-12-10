$PBExportHeader$w_pop_new_assessment_description.srw
forward
global type w_pop_new_assessment_description from w_window_base
end type
type st_1 from statictext within w_pop_new_assessment_description
end type
type st_2 from statictext within w_pop_new_assessment_description
end type
type cb_ok from commandbutton within w_pop_new_assessment_description
end type
type cb_cancel from commandbutton within w_pop_new_assessment_description
end type
type st_3 from statictext within w_pop_new_assessment_description
end type
type sle_icd10_code from singlelineedit within w_pop_new_assessment_description
end type
type mle_description from multilineedit within w_pop_new_assessment_description
end type
end forward

global type w_pop_new_assessment_description from w_window_base
integer x = 462
integer y = 424
integer width = 2002
integer height = 924
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_1 st_1
st_2 st_2
cb_ok cb_ok
cb_cancel cb_cancel
st_3 st_3
sle_icd10_code sle_icd10_code
mle_description mle_description
end type
global w_pop_new_assessment_description w_pop_new_assessment_description

on w_pop_new_assessment_description.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_2=create st_2
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.st_3=create st_3
this.sle_icd10_code=create sle_icd10_code
this.mle_description=create mle_description
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.cb_ok
this.Control[iCurrent+4]=this.cb_cancel
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.sle_icd10_code
this.Control[iCurrent+7]=this.mle_description
end on

on w_pop_new_assessment_description.destroy
call super::destroy
destroy(this.st_1)
destroy(this.st_2)
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.st_3)
destroy(this.sle_icd10_code)
destroy(this.mle_description)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_pop_new_assessment_description
integer taborder = 40
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_pop_new_assessment_description
end type

type st_1 from statictext within w_pop_new_assessment_description
integer x = 187
integer y = 200
integer width = 343
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Description:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_pop_new_assessment_description
integer width = 1993
integer height = 160
boolean bringtotop = true
integer textsize = -22
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "New Assessment"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_ok from commandbutton within w_pop_new_assessment_description
integer x = 1550
integer y = 768
integer width = 402
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;str_popup_return popup_return

if trim(mle_description.text) = "" then
	openwithparm(w_pop_message, "Please enter a description for the new assessment")
	return
end if

popup_return.item_count = 2
popup_return.items[1] = trim(mle_description.text)

if len(trim(sle_icd10_code.text)) > 0 then
	popup_return.items[2] = trim(sle_icd10_code.text)
else
	setnull(popup_return.items[2])
end if

closewithreturn(parent, popup_return)

end event

type cb_cancel from commandbutton within w_pop_new_assessment_description
integer x = 41
integer y = 768
integer width = 402
integer height = 112
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

event clicked;str_popup_return popup_return

popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

type st_3 from statictext within w_pop_new_assessment_description
integer x = 178
integer y = 572
integer width = 352
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "ICD10 Code:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_icd10_code from singlelineedit within w_pop_new_assessment_description
integer x = 549
integer y = 560
integer width = 663
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type mle_description from multilineedit within w_pop_new_assessment_description
integer x = 549
integer y = 192
integer width = 1335
integer height = 304
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;string ls_message


if len(text) > 80 then
	ls_message = "The maximum length for an assessment description is 40 characters."
	ls_message += "  On the Assessment Definition configuration screen, you will have"
	ls_message += " the opportunity to enter a long description"
	openwithparm(w_pop_message, ls_message)
	text = left(text, 80)
end if

end event

