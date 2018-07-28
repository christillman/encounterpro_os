$PBExportHeader$w_pop_prompt_observation_cpt_code.srw
forward
global type w_pop_prompt_observation_cpt_code from window
end type
type st_collect from statictext within w_pop_prompt_observation_cpt_code
end type
type st_perform from statictext within w_pop_prompt_observation_cpt_code
end type
type sle_string from singlelineedit within w_pop_prompt_observation_cpt_code
end type
type pb_cancel from u_picture_button within w_pop_prompt_observation_cpt_code
end type
type st_prompt from statictext within w_pop_prompt_observation_cpt_code
end type
type pb_ok from u_picture_button within w_pop_prompt_observation_cpt_code
end type
end forward

global type w_pop_prompt_observation_cpt_code from window
integer x = 434
integer y = 604
integer width = 2034
integer height = 736
windowtype windowtype = response!
long backcolor = 33538240
st_collect st_collect
st_perform st_perform
sle_string sle_string
pb_cancel pb_cancel
st_prompt st_prompt
pb_ok pb_ok
end type
global w_pop_prompt_observation_cpt_code w_pop_prompt_observation_cpt_code

type variables
string which_code
end variables

event open;str_popup popup

which_code = "P"
st_collect.backcolor = color_object
st_perform.backcolor = color_object_selected

sle_string.setfocus()


end event

on w_pop_prompt_observation_cpt_code.create
this.st_collect=create st_collect
this.st_perform=create st_perform
this.sle_string=create sle_string
this.pb_cancel=create pb_cancel
this.st_prompt=create st_prompt
this.pb_ok=create pb_ok
this.Control[]={this.st_collect,&
this.st_perform,&
this.sle_string,&
this.pb_cancel,&
this.st_prompt,&
this.pb_ok}
end on

on w_pop_prompt_observation_cpt_code.destroy
destroy(this.st_collect)
destroy(this.st_perform)
destroy(this.sle_string)
destroy(this.pb_cancel)
destroy(this.st_prompt)
destroy(this.pb_ok)
end on

type st_collect from statictext within w_pop_prompt_observation_cpt_code
integer x = 517
integer y = 416
integer width = 384
integer height = 160
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Collect Code"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;which_code = "C"
st_collect.backcolor = color_object_selected
st_perform.backcolor = color_object

sle_string.setfocus()

end event

type st_perform from statictext within w_pop_prompt_observation_cpt_code
integer x = 1088
integer y = 416
integer width = 384
integer height = 160
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Perform Code"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;which_code = "P"
st_collect.backcolor = color_object
st_perform.backcolor = color_object_selected

sle_string.setfocus()

end event

type sle_string from singlelineedit within w_pop_prompt_observation_cpt_code
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

type pb_cancel from u_picture_button within w_pop_prompt_observation_cpt_code
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

type st_prompt from statictext within w_pop_prompt_observation_cpt_code
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
long backcolor = 33538240
boolean enabled = false
string text = "Enter the CPT code of the observation"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_ok from u_picture_button within w_pop_prompt_observation_cpt_code
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
	popup_return.items[1] = sle_string.text
	popup_return.items[2] = which_code
	popup_return.item_count = 2
end if

closewithreturn(parent, popup_return)

end event

