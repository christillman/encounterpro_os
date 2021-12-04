$PBExportHeader$w_security_disclaimer.srw
forward
global type w_security_disclaimer from window
end type
type cb_1 from commandbutton within w_security_disclaimer
end type
type st_title from statictext within w_security_disclaimer
end type
type cb_ok from commandbutton within w_security_disclaimer
end type
type dw_message from datawindow within w_security_disclaimer
end type
end forward

global type w_security_disclaimer from window
integer x = 434
integer y = 604
integer width = 2359
integer height = 1108
windowtype windowtype = response!
long backcolor = COLOR_BACKGROUND
cb_1 cb_1
st_title st_title
cb_ok cb_ok
dw_message dw_message
end type
global w_security_disclaimer w_security_disclaimer

event open;
str_security_alert lstr_security_alert

lstr_security_alert = message.powerobjectparm

if len(lstr_security_alert.alert_title) > 0 then
	st_title.text = lstr_security_alert.alert_title
end if

dw_message.reset()
dw_message.insertrow(0)
dw_message.setitem(1,1,lstr_security_alert.alert_message )

if not isnull(main_window) and isvalid(main_window) then
	x = main_window.x + (main_window.width - width) / 2
	y = main_window.y + (main_window.height - height) / 2
end if

end event

on w_security_disclaimer.create
this.cb_1=create cb_1
this.st_title=create st_title
this.cb_ok=create cb_ok
this.dw_message=create dw_message
this.Control[]={this.cb_1,&
this.st_title,&
this.cb_ok,&
this.dw_message}
end on

on w_security_disclaimer.destroy
destroy(this.cb_1)
destroy(this.st_title)
destroy(this.cb_ok)
destroy(this.dw_message)
end on

type cb_1 from commandbutton within w_security_disclaimer
integer x = 187
integer y = 936
integer width = 773
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I Disagree"
boolean default = true
end type

event clicked;closewithreturn(parent, "NO")
end event

type st_title from statictext within w_security_disclaimer
integer width = 2350
integer height = 136
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Security Alert"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_ok from commandbutton within w_security_disclaimer
integer x = 1403
integer y = 936
integer width = 773
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I Agree"
boolean default = true
end type

event clicked;closewithreturn(parent, "YES")
end event

type dw_message from datawindow within w_security_disclaimer
integer x = 50
integer y = 200
integer width = 2258
integer height = 652
boolean enabled = false
string dataobject = "dw_security_alert_message"
boolean vscrollbar = true
boolean border = false
end type

