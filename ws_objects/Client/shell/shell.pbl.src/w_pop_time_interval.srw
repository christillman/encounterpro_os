$PBExportHeader$w_pop_time_interval.srw
forward
global type w_pop_time_interval from window
end type
type st_title from statictext within w_pop_time_interval
end type
type pb_cancel from u_picture_button within w_pop_time_interval
end type
type pb_close from u_picture_button within w_pop_time_interval
end type
type uo_time_interval from u_time_interval within w_pop_time_interval
end type
end forward

global type w_pop_time_interval from window
integer x = 219
integer y = 224
integer width = 2418
integer height = 1392
windowtype windowtype = response!
long backcolor = 33538240
boolean toolbarvisible = false
st_title st_title
pb_cancel pb_cancel
pb_close pb_close
uo_time_interval uo_time_interval
end type
global w_pop_time_interval w_pop_time_interval

type variables

end variables

event open;str_popup popup
str_popup_return popup_return

popup = message.powerobjectparm

if popup.data_row_count <> 2 then
	log.log(this, "open", "Invalid Parameters", 4)
	closewithreturn(this, popup_return)
	return
end if

st_title.text = popup.title
uo_time_interval.set_time(real(popup.items[1]), popup.items[2])


end event

on w_pop_time_interval.create
this.st_title=create st_title
this.pb_cancel=create pb_cancel
this.pb_close=create pb_close
this.uo_time_interval=create uo_time_interval
this.Control[]={this.st_title,&
this.pb_cancel,&
this.pb_close,&
this.uo_time_interval}
end on

on w_pop_time_interval.destroy
destroy(this.st_title)
destroy(this.pb_cancel)
destroy(this.pb_close)
destroy(this.uo_time_interval)
end on

type st_title from statictext within w_pop_time_interval
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

type pb_cancel from u_picture_button within w_pop_time_interval
integer x = 114
integer y = 1108
integer taborder = 10
string picturename = "button11.bmp"
string disabledname = "button11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 0

closewithreturn(parent, popup_return)


end event

on mouse_move;f_cpr_set_msg("Cancel")
end on

type pb_close from u_picture_button within w_pop_time_interval
integer x = 2057
integer y = 1108
integer taborder = 20
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 2
popup_return.items[1] = string(uo_time_interval.amount)
popup_return.items[2] = uo_time_interval.unit


closewithreturn(parent, popup_return)


end event

type uo_time_interval from u_time_interval within w_pop_time_interval
integer x = 110
integer y = 212
integer taborder = 10
end type

on uo_time_interval.destroy
call u_time_interval::destroy
end on

