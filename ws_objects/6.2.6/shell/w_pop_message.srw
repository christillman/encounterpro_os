HA$PBExportHeader$w_pop_message.srw
forward
global type w_pop_message from w_window_base
end type
type cb_ok from commandbutton within w_pop_message
end type
type dw_message from datawindow within w_pop_message
end type
type cb_help from commandbutton within w_pop_message
end type
type cb_edit_help from commandbutton within w_pop_message
end type
end forward

global type w_pop_message from w_window_base
integer x = 325
integer y = 604
integer width = 2313
integer height = 656
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
cb_ok cb_ok
dw_message dw_message
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

if cpr_mode = "SERVER" then
	log.log(this, "open", message.stringparm, 2)
	close(this)
	return
end if

if not isnull(current_scribe) then
	help_article = f_display_help_article(message.stringparm, "USER")
end if


dw_message.reset()
dw_message.insertrow(0)
dw_message.setitem(1,1,message.stringparm)
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
if cpr_mode = "NA" then
	timer(5)
else
	timer(30)
end if


end event

on w_pop_message.create
int iCurrent
call super::create
this.cb_ok=create cb_ok
this.dw_message=create dw_message
this.cb_help=create cb_help
this.cb_edit_help=create cb_edit_help
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ok
this.Control[iCurrent+2]=this.dw_message
this.Control[iCurrent+3]=this.cb_help
this.Control[iCurrent+4]=this.cb_edit_help
end on

on w_pop_message.destroy
call super::destroy
destroy(this.cb_ok)
destroy(this.dw_message)
destroy(this.cb_help)
destroy(this.cb_edit_help)
end on

event timer;// If the timer goes off then close this message window

close(this)
return

end event

type pb_epro_help from w_window_base`pb_epro_help within w_pop_message
integer taborder = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_pop_message
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

type dw_message from datawindow within w_pop_message
integer x = 69
integer y = 60
integer width = 2130
integer height = 356
string dataobject = "dw_ok"
boolean vscrollbar = true
boolean border = false
end type

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

