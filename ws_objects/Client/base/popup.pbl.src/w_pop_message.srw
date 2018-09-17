$PBExportHeader$w_pop_message.srw
forward
global type w_pop_message from w_pop_window_base
end type
type cb_ok from commandbutton within w_pop_message
end type
type cb_help from commandbutton within w_pop_message
end type
type cb_edit_help from commandbutton within w_pop_message
end type
end forward

global type w_pop_message from w_pop_window_base
integer x = 325
integer y = 604
integer width = 2313
integer height = 656
cb_ok cb_ok
cb_help cb_help
cb_edit_help cb_edit_help
end type
global w_pop_message w_pop_message

type variables
str_help_article help_article

end variables

event open;call super::open;string ls_temp
long ll_scroll_position
long ll_scroll_maximum

if not isnull(current_scribe) then
	help_article = f_display_help_article(message.stringparm, "USER")
end if

dw_message.object.message.width = dw_message.width - 100

ll_scroll_position = long(string(dw_message.object.datawindow.verticalscrollposition))
ll_scroll_maximum = long(string(dw_message.object.datawindow.verticalscrollmaximum))

if ll_scroll_maximum > ll_scroll_position then
	if ll_scroll_maximum > 1000 then ll_scroll_maximum = 1000
	dw_message.height = dw_message.height + ll_scroll_maximum
	this.height = this.height + ll_scroll_maximum
	cb_ok.y = cb_ok.y + ll_scroll_maximum
	this.y = this.y - (ll_scroll_maximum / 2)
end if

cb_help.y = cb_ok.y
cb_edit_help.y = cb_help.y + cb_help.height - cb_edit_help.height

if len(help_article.article) > 0 then
	cb_help.visible = true
else
	cb_help.visible = false
end if

if help_article.user_may_edit and config_mode then
	cb_edit_help.visible = true
else
	cb_edit_help.visible = false
end if

// If we don't know our cpr_mode yet then set a short timeout
if gnv_app.cpr_mode = "NA" then
	timer(5)
else
	timer(30)
end if


end event

on w_pop_message.create
int iCurrent
call super::create
this.cb_ok=create cb_ok
this.cb_help=create cb_help
this.cb_edit_help=create cb_edit_help
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ok
this.Control[iCurrent+2]=this.cb_help
this.Control[iCurrent+3]=this.cb_edit_help
end on

on w_pop_message.destroy
call super::destroy
destroy(this.cb_ok)
destroy(this.cb_help)
destroy(this.cb_edit_help)
end on

event timer;// If the timer goes off then close this message window

// close(this)

// If the timer goes off, then beep

BEEP(1)
end event

type pb_epro_help from w_pop_window_base`pb_epro_help within w_pop_message
unsignedlong __hwnd = 0
boolean visible = false
accessiblerole accessiblerole = defaultrole!
integer x = 2651
integer y = 20
integer width = 256
integer height = 128
integer taborder = 0
boolean dragauto = false
boolean bringtotop = false
integer transparency = 0
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = false
boolean underline = false
boolean enabled = true
boolean cancel = false
boolean default = false
boolean flatstyle = false
boolean originalsize = true
string picturename = "buttonhelp.bmp"
string disabledname = "buttonhelp.bmp"
alignment htextalign = left!
vtextalign vtextalign = bottom!
boolean map3dcolors = false
long textcolor = 0
long backcolor = 1073741824
end type

type st_config_mode_menu from w_pop_window_base`st_config_mode_menu within w_pop_message
unsignedlong __hwnd = 0
boolean visible = false
accessiblerole accessiblerole = defaultrole!
integer x = 55
integer y = 1468
integer width = 997
integer height = 48
integer taborder = 0
boolean dragauto = false
boolean bringtotop = false
integer transparency = 0
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = false
boolean underline = false
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = true
alignment alignment = left!
boolean border = false
long bordercolor = 0
fillpattern fillpattern = solid!
borderstyle borderstyle = stylebox!
boolean focusrectangle = false
boolean righttoleft = false
boolean disabledlook = false
end type

type dw_message from w_pop_window_base`dw_message within w_pop_message
integer x = 69
integer y = 60
integer width = 2130
integer height = 356
boolean vscrollbar = true
end type

type cb_ok from commandbutton within w_pop_message
integer x = 933
integer y = 440
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;close(parent)
end event

type cb_help from commandbutton within w_pop_message
integer x = 37
integer y = 444
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
string text = "Help"
end type

event clicked;f_display_help(help_article.help_context, help_article.which_help , false)

end event

type cb_edit_help from commandbutton within w_pop_message
integer x = 466
integer y = 464
integer width = 320
integer height = 76
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Edit Help"
end type

event clicked;f_display_help(help_article.help_context, help_article.which_help , true)

end event

