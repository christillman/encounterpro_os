$PBExportHeader$w_security_alert.srw
forward
global type w_security_alert from window
end type
type st_title from statictext within w_security_alert
end type
type cb_ok from commandbutton within w_security_alert
end type
type cb_override from commandbutton within w_security_alert
end type
type dw_message from datawindow within w_security_alert
end type
end forward

global type w_security_alert from window
integer x = 434
integer y = 604
integer width = 2359
integer height = 1108
windowtype windowtype = response!
long backcolor = 33538240
st_title st_title
cb_ok cb_ok
cb_override cb_override
dw_message dw_message
end type
global w_security_alert w_security_alert

event open;str_security_alert lstr_security_alert

lstr_security_alert = message.powerobjectparm

if len(lstr_security_alert.alert_title) > 0 then
	st_title.text = lstr_security_alert.alert_title
end if

dw_message.reset()
dw_message.insertrow(0)
dw_message.setitem(1,1,lstr_security_alert.alert_message )

if lstr_security_alert.allow_override then
	cb_override.visible = true
else
	cb_override.visible = false
end if

if not isnull(main_window) and isvalid(main_window) then
	x = main_window.x + (main_window.width - width) / 2
	y = main_window.y + (main_window.height - height) / 2
end if

end event

on w_security_alert.create
this.st_title=create st_title
this.cb_ok=create cb_ok
this.cb_override=create cb_override
this.dw_message=create dw_message
this.Control[]={this.st_title,&
this.cb_ok,&
this.cb_override,&
this.dw_message}
end on

on w_security_alert.destroy
destroy(this.st_title)
destroy(this.cb_ok)
destroy(this.cb_override)
destroy(this.dw_message)
end on

type st_title from statictext within w_security_alert
integer width = 2350
integer height = 136
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Security Alert"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_ok from commandbutton within w_security_alert
integer x = 1883
integer y = 940
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;closewithreturn(parent, "OK")
end event

type cb_override from commandbutton within w_security_alert
integer x = 46
integer y = 904
integer width = 297
integer height = 148
integer taborder = 50
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Override"
end type

event clicked;closewithreturn(parent, "OVERRIDE")


end event

type dw_message from datawindow within w_security_alert
integer x = 50
integer y = 200
integer width = 2258
integer height = 652
boolean enabled = false
string dataobject = "dw_security_alert_message"
boolean vscrollbar = true
boolean border = false
end type

