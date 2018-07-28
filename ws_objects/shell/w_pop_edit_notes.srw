HA$PBExportHeader$w_pop_edit_notes.srw
forward
global type w_pop_edit_notes from w_window_base
end type
type cb_notes from commandbutton within w_pop_edit_notes
end type
type mle_string from multilineedit within w_pop_edit_notes
end type
type pb_cancel from u_picture_button within w_pop_edit_notes
end type
type st_prompt from statictext within w_pop_edit_notes
end type
type pb_ok from u_picture_button within w_pop_edit_notes
end type
end forward

global type w_pop_edit_notes from w_window_base
integer x = 434
integer y = 604
integer width = 2034
integer height = 1056
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
cb_notes cb_notes
mle_string mle_string
pb_cancel pb_cancel
st_prompt st_prompt
pb_ok pb_ok
end type
global w_pop_edit_notes w_pop_edit_notes

event open;call super::open;mle_string.text = Message.Stringparm


end event

on w_pop_edit_notes.create
int iCurrent
call super::create
this.cb_notes=create cb_notes
this.mle_string=create mle_string
this.pb_cancel=create pb_cancel
this.st_prompt=create st_prompt
this.pb_ok=create pb_ok
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_notes
this.Control[iCurrent+2]=this.mle_string
this.Control[iCurrent+3]=this.pb_cancel
this.Control[iCurrent+4]=this.st_prompt
this.Control[iCurrent+5]=this.pb_ok
end on

on w_pop_edit_notes.destroy
call super::destroy
destroy(this.cb_notes)
destroy(this.mle_string)
destroy(this.pb_cancel)
destroy(this.st_prompt)
destroy(this.pb_ok)
end on

type cb_notes from commandbutton within w_pop_edit_notes
integer x = 814
integer y = 828
integer width = 402
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Edit Notes"
end type

event clicked;call super::clicked;mle_string.enabled = true

end event

type mle_string from multilineedit within w_pop_edit_notes
integer x = 82
integer y = 256
integer width = 1856
integer height = 448
integer taborder = 10
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean enabled = false
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type pb_cancel from u_picture_button within w_pop_edit_notes
integer x = 82
integer y = 772
integer taborder = 30
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

setnull(popup_return.item)
popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

type st_prompt from statictext within w_pop_edit_notes
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
boolean focusrectangle = false
end type

type pb_ok from u_picture_button within w_pop_edit_notes
integer x = 1687
integer y = 772
integer taborder = 20
boolean default = true
string picturename = "button26.bmp"
string disabledname = "button26.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

if trim(mle_string.text) = "" then
	setnull(popup_return.item)
	popup_return.item_count = 0
else
	popup_return.item = mle_string.text
	popup_return.items[1] = mle_string.text
	popup_return.item_count = 1
end if

closewithreturn(parent, popup_return)

end event

