$PBExportHeader$w_pop_prompt_procedure_cpt_code.srw
forward
global type w_pop_prompt_procedure_cpt_code from window
end type
type sle_string from singlelineedit within w_pop_prompt_procedure_cpt_code
end type
type pb_cancel from u_picture_button within w_pop_prompt_procedure_cpt_code
end type
type st_prompt from statictext within w_pop_prompt_procedure_cpt_code
end type
type pb_ok from u_picture_button within w_pop_prompt_procedure_cpt_code
end type
end forward

global type w_pop_prompt_procedure_cpt_code from window
integer x = 434
integer y = 604
integer width = 2034
integer height = 736
windowtype windowtype = response!
long backcolor = COLOR_BACKGROUND
sle_string sle_string
pb_cancel pb_cancel
st_prompt st_prompt
pb_ok pb_ok
end type
global w_pop_prompt_procedure_cpt_code w_pop_prompt_procedure_cpt_code

type variables

end variables

event open;sle_string.setfocus()


end event

on w_pop_prompt_procedure_cpt_code.create
this.sle_string=create sle_string
this.pb_cancel=create pb_cancel
this.st_prompt=create st_prompt
this.pb_ok=create pb_ok
this.Control[]={this.sle_string,&
this.pb_cancel,&
this.st_prompt,&
this.pb_ok}
end on

on w_pop_prompt_procedure_cpt_code.destroy
destroy(this.sle_string)
destroy(this.pb_cancel)
destroy(this.st_prompt)
destroy(this.pb_ok)
end on

type sle_string from singlelineedit within w_pop_prompt_procedure_cpt_code
integer x = 782
integer y = 232
integer width = 421
integer height = 96
integer taborder = 1
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

type pb_cancel from u_picture_button within w_pop_prompt_procedure_cpt_code
integer x = 82
integer y = 444
integer taborder = 20
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

setnull(popup_return.item)
popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

type st_prompt from statictext within w_pop_prompt_procedure_cpt_code
integer x = 82
integer y = 80
integer width = 1851
integer height = 92
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Enter the CPT code of the procedure"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_ok from u_picture_button within w_pop_prompt_procedure_cpt_code
integer x = 1687
integer y = 444
integer taborder = 10
boolean default = true
string picturename = "button26.bmp"
string disabledname = "button26.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

if trim(sle_string.text) = "" then
	setnull(popup_return.item)
	popup_return.item_count = 0
else
	popup_return.items[1] = sle_string.text+"%"
	popup_return.descriptions[1] = sle_string.text
	popup_return.item_count = 1
end if

closewithreturn(parent, popup_return)

end event

