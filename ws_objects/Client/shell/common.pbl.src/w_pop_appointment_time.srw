$PBExportHeader$w_pop_appointment_time.srw
forward
global type w_pop_appointment_time from w_window_base
end type
type cb_cancel from commandbutton within w_pop_appointment_time
end type
type cb_OK from commandbutton within w_pop_appointment_time
end type
type st_title from statictext within w_pop_appointment_time
end type
type uo_time_interval from u_time_interval within w_pop_appointment_time
end type
end forward

global type w_pop_appointment_time from w_window_base
integer x = 219
integer y = 224
integer width = 2418
integer height = 1468
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
boolean toolbarvisible = false
cb_cancel cb_cancel
cb_OK cb_OK
st_title st_title
uo_time_interval uo_time_interval
end type
global w_pop_appointment_time w_pop_appointment_time

type variables

end variables

event open;call super::open;str_popup popup
str_popup_return popup_return

popup = message.powerobjectparm

if popup.data_row_count <> 2 then
	log.log(this, "w_pop_appointment_time.open.0007", "Invalid Parameters", 4)
	closewithreturn(this, popup_return)
	return
end if

st_title.text = popup.title
uo_time_interval.set_time(real(popup.items[1]), popup.items[2])


end event

on w_pop_appointment_time.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.cb_OK=create cb_OK
this.st_title=create st_title
this.uo_time_interval=create uo_time_interval
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.cb_OK
this.Control[iCurrent+3]=this.st_title
this.Control[iCurrent+4]=this.uo_time_interval
end on

on w_pop_appointment_time.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.cb_OK)
destroy(this.st_title)
destroy(this.uo_time_interval)
end on

type cb_cancel from commandbutton within w_pop_appointment_time
integer x = 46
integer y = 1284
integer width = 402
integer height = 112
integer taborder = 30
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

popup_return.item_count = 0

closewithreturn(parent, popup_return)


end event

type cb_OK from commandbutton within w_pop_appointment_time
integer x = 1925
integer y = 1284
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

event clicked;str_popup_return popup_return

popup_return.item_count = 2
popup_return.items[1] = string(uo_time_interval.amount)
popup_return.items[2] = uo_time_interval.unit


closewithreturn(parent, popup_return)


end event

type st_title from statictext within w_pop_appointment_time
integer width = 2409
integer height = 232
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_time_interval from u_time_interval within w_pop_appointment_time
integer x = 110
integer y = 212
integer taborder = 10
end type

on uo_time_interval.destroy
call u_time_interval::destroy
end on

