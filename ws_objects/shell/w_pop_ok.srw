HA$PBExportHeader$w_pop_ok.srw
forward
global type w_pop_ok from w_window_base
end type
type cb_ok from commandbutton within w_pop_ok
end type
type cb_cancel from commandbutton within w_pop_ok
end type
type dw_message from datawindow within w_pop_ok
end type
end forward

global type w_pop_ok from w_window_base
integer x = 407
integer y = 608
integer width = 2053
integer height = 528
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
cb_ok cb_ok
cb_cancel cb_cancel
dw_message dw_message
end type
global w_pop_ok w_pop_ok

on open;string ls_temp

dw_message.reset()
dw_message.insertrow(0)
dw_message.setitem(1,1,message.stringparm)

end on

on w_pop_ok.create
int iCurrent
call super::create
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.dw_message=create dw_message
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ok
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.dw_message
end on

on w_pop_ok.destroy
call super::destroy
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.dw_message)
end on

type cb_ok from commandbutton within w_pop_ok
integer x = 1550
integer y = 348
integer width = 421
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
boolean default = true
end type

event clicked;closewithreturn(parent, 1)
end event

type cb_cancel from commandbutton within w_pop_ok
integer x = 32
integer y = 348
integer width = 421
integer height = 112
integer taborder = 20
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

event clicked;closewithreturn(parent, 0)
end event

type dw_message from datawindow within w_pop_ok
integer x = 69
integer y = 60
integer width = 1906
integer height = 204
integer taborder = 10
boolean enabled = false
string dataobject = "dw_ok"
boolean border = false
end type

