$PBExportHeader$w_pop_duration.srw
forward
global type w_pop_duration from window
end type
type cb_prn from commandbutton within w_pop_duration
end type
type st_prn from statictext within w_pop_duration
end type
type sle_prn from singlelineedit within w_pop_duration
end type
type st_title from statictext within w_pop_duration
end type
type st_radio_indefinite from u_st_radio_duration_type within w_pop_duration
end type
type st_radio_prn from u_st_radio_duration_type within w_pop_duration
end type
type st_radio_time from u_st_radio_duration_type within w_pop_duration
end type
type pb_cancel from u_picture_button within w_pop_duration
end type
type pb_close from u_picture_button within w_pop_duration
end type
type uo_time_interval from u_time_interval within w_pop_duration
end type
end forward

global type w_pop_duration from window
integer width = 2926
integer height = 1832
windowtype windowtype = response!
long backcolor = 33538240
cb_prn cb_prn
st_prn st_prn
sle_prn sle_prn
st_title st_title
st_radio_indefinite st_radio_indefinite
st_radio_prn st_radio_prn
st_radio_time st_radio_time
pb_cancel pb_cancel
pb_close pb_close
uo_time_interval uo_time_interval
end type
global w_pop_duration w_pop_duration

type variables
u_st_time st_time

statictext st_current

integer mode

end variables

event open;str_popup popup

popup = message.powerobjectparm

if popup.data_row_count <> 3 then
	log.log(this, "open", "Invalid popup parameter", 4)
	close(this)
	return
end if

uo_time_interval.set_time(real(popup.items[1]), popup.items[2])
sle_prn.text = popup.items[3]

if not isnull(popup.items[3]) and popup.items[3] <> "" then
	st_radio_prn.triggerevent("clicked")
elseif real(popup.items[1]) = -1 then
	st_radio_indefinite.triggerevent("clicked")
else
	st_radio_time.triggerevent("clicked")
end if


end event

on w_pop_duration.create
this.cb_prn=create cb_prn
this.st_prn=create st_prn
this.sle_prn=create sle_prn
this.st_title=create st_title
this.st_radio_indefinite=create st_radio_indefinite
this.st_radio_prn=create st_radio_prn
this.st_radio_time=create st_radio_time
this.pb_cancel=create pb_cancel
this.pb_close=create pb_close
this.uo_time_interval=create uo_time_interval
this.Control[]={this.cb_prn,&
this.st_prn,&
this.sle_prn,&
this.st_title,&
this.st_radio_indefinite,&
this.st_radio_prn,&
this.st_radio_time,&
this.pb_cancel,&
this.pb_close,&
this.uo_time_interval}
end on

on w_pop_duration.destroy
destroy(this.cb_prn)
destroy(this.st_prn)
destroy(this.sle_prn)
destroy(this.st_title)
destroy(this.st_radio_indefinite)
destroy(this.st_radio_prn)
destroy(this.st_radio_time)
destroy(this.pb_cancel)
destroy(this.pb_close)
destroy(this.uo_time_interval)
end on

type cb_prn from commandbutton within w_pop_duration
integer x = 2327
integer y = 828
integer width = 174
integer height = 108
integer taborder = 10
integer textsize = -16
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.title = "Select Duration PRN Phrase"
popup.data_row_count = 2
popup.items[1] = "PRNPHRASE"
popup.items[2] = sle_prn.text
openwithparm(w_pick_top_20_multiline, popup, f_active_window())
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

sle_prn.text = popup_return.items[1]

end event

type st_prn from statictext within w_pop_duration
integer x = 425
integer y = 756
integer width = 174
integer height = 76
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "PRN:"
boolean focusrectangle = false
end type

type sle_prn from singlelineedit within w_pop_duration
integer x = 425
integer y = 828
integer width = 1874
integer height = 108
integer taborder = 20
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type st_title from statictext within w_pop_duration
integer width = 2930
integer height = 152
integer textsize = -24
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Duration"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_radio_indefinite from u_st_radio_duration_type within w_pop_duration
integer x = 2048
integer y = 264
integer width = 530
integer height = 96
string text = "Indefinite"
end type

event clicked;call super::clicked;
cb_prn.visible = false
sle_prn.visible = false
st_prn.visible = false

uo_time_interval.visible = false

mode = 3

end event

type st_radio_prn from u_st_radio_duration_type within w_pop_duration
integer x = 1170
integer y = 264
integer width = 530
integer height = 96
string text = "Specify PRN"
end type

event clicked;call super::clicked;
cb_prn.visible = true
sle_prn.visible = true
st_prn.visible = true

uo_time_interval.visible = false

mode = 2

sle_prn.setfocus()

end event

type st_radio_time from u_st_radio_duration_type within w_pop_duration
integer x = 293
integer y = 264
integer width = 530
integer height = 96
string text = "Specify Time"
end type

event clicked;call super::clicked;
cb_prn.visible = false
sle_prn.visible = false
st_prn.visible = false

uo_time_interval.visible = true

setnull(sle_prn.text)

mode = 1

end event

type pb_cancel from u_picture_button within w_pop_duration
integer x = 64
integer y = 1560
integer taborder = 30
string picturename = "button11.bmp"
string disabledname = "button11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

on mouse_move;f_cpr_set_msg("Cancel")
end on

type pb_close from u_picture_button within w_pop_duration
integer x = 2606
integer y = 1560
integer taborder = 40
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 3

if mode = 1 then
	popup_return.items[1] = string(uo_time_interval.amount)
	popup_return.items[2] = uo_time_interval.unit
	setnull(popup_return.items[3])
elseif mode = 2 then
	popup_return.items[1] = "0"
	setnull(popup_return.items[2])
	popup_return.items[3] = sle_prn.text
elseif mode = 3 then
	popup_return.items[1] = "-1"
	setnull(popup_return.items[2])
	setnull(popup_return.items[3])
else
	return
end if


closewithreturn(parent, popup_return)
end event

type uo_time_interval from u_time_interval within w_pop_duration
integer x = 334
integer y = 432
integer taborder = 10
end type

on uo_time_interval.destroy
call u_time_interval::destroy
end on

