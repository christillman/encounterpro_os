$PBExportHeader$w_pop_get_string_multiline.srw
forward
global type w_pop_get_string_multiline from w_window_base
end type
type mle_string from multilineedit within w_pop_get_string_multiline
end type
type pb_cancel from u_picture_button within w_pop_get_string_multiline
end type
type st_prompt from statictext within w_pop_get_string_multiline
end type
type pb_ok from u_picture_button within w_pop_get_string_multiline
end type
end forward

global type w_pop_get_string_multiline from w_window_base
integer x = 434
integer y = 604
integer width = 2034
integer height = 1060
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
mle_string mle_string
pb_cancel pb_cancel
st_prompt st_prompt
pb_ok pb_ok
end type
global w_pop_get_string_multiline w_pop_get_string_multiline

event open;call super::open;str_popup popup

popup = message.powerobjectparm

st_prompt.text = popup.title

if not isnull(popup.item) and trim(popup.item) <> "" then
	mle_string.text = popup.item
	mle_string.selecttext(1, len(mle_string.text))
end if

mle_string.setfocus()


end event

on w_pop_get_string_multiline.create
int iCurrent
call super::create
this.mle_string=create mle_string
this.pb_cancel=create pb_cancel
this.st_prompt=create st_prompt
this.pb_ok=create pb_ok
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.mle_string
this.Control[iCurrent+2]=this.pb_cancel
this.Control[iCurrent+3]=this.st_prompt
this.Control[iCurrent+4]=this.pb_ok
end on

on w_pop_get_string_multiline.destroy
call super::destroy
destroy(this.mle_string)
destroy(this.pb_cancel)
destroy(this.st_prompt)
destroy(this.pb_ok)
end on

type mle_string from multilineedit within w_pop_get_string_multiline
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
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type pb_cancel from u_picture_button within w_pop_get_string_multiline
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

type st_prompt from statictext within w_pop_get_string_multiline
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

type pb_ok from u_picture_button within w_pop_get_string_multiline
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

