$PBExportHeader$w_pop_prompt_string_multiline.srw
forward
global type w_pop_prompt_string_multiline from w_window_base
end type
type mle_string from multilineedit within w_pop_prompt_string_multiline
end type
type st_prompt from statictext within w_pop_prompt_string_multiline
end type
type cb_cancel from commandbutton within w_pop_prompt_string_multiline
end type
type cb_ok from commandbutton within w_pop_prompt_string_multiline
end type
end forward

global type w_pop_prompt_string_multiline from w_window_base
integer x = 201
integer y = 252
integer width = 2409
integer height = 1432
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
mle_string mle_string
st_prompt st_prompt
cb_cancel cb_cancel
cb_ok cb_ok
end type
global w_pop_prompt_string_multiline w_pop_prompt_string_multiline

event open;call super::open;str_popup popup

popup = message.powerobjectparm

st_prompt.text = popup.title

if not isnull(popup.item) and trim(popup.item) <> "" then
	mle_string.text = popup.item
	mle_string.selecttext(1, len(mle_string.text))
end if

mle_string.setfocus()


end event

on w_pop_prompt_string_multiline.create
int iCurrent
call super::create
this.mle_string=create mle_string
this.st_prompt=create st_prompt
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.mle_string
this.Control[iCurrent+2]=this.st_prompt
this.Control[iCurrent+3]=this.cb_cancel
this.Control[iCurrent+4]=this.cb_ok
end on

on w_pop_prompt_string_multiline.destroy
call super::destroy
destroy(this.mle_string)
destroy(this.st_prompt)
destroy(this.cb_cancel)
destroy(this.cb_ok)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_pop_prompt_string_multiline
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_pop_prompt_string_multiline
end type

type mle_string from multilineedit within w_pop_prompt_string_multiline
integer x = 69
integer y = 256
integer width = 2249
integer height = 892
integer taborder = 10
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean vscrollbar = true
boolean autovscroll = true
borderstyle borderstyle = stylelowered!
end type

type st_prompt from statictext within w_pop_prompt_string_multiline
integer width = 2405
integer height = 236
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_pop_prompt_string_multiline
integer x = 41
integer y = 1232
integer width = 402
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;str_popup_return popup_return

setnull(popup_return.item)
popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

type cb_ok from commandbutton within w_pop_prompt_string_multiline
integer x = 1925
integer y = 1232
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

event clicked;str_popup_return popup_return

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

