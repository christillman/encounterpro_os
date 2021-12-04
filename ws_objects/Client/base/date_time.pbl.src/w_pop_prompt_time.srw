$PBExportHeader$w_pop_prompt_time.srw
forward
global type w_pop_prompt_time from w_window_base
end type
type cb_hour_plus_10 from commandbutton within w_pop_prompt_time
end type
type cb_hour_minus_10 from commandbutton within w_pop_prompt_time
end type
type cb_second_plus_10 from commandbutton within w_pop_prompt_time
end type
type cb_second_minus_10 from commandbutton within w_pop_prompt_time
end type
type cb_minute_minus_10 from commandbutton within w_pop_prompt_time
end type
type cb_minute_plus_10 from commandbutton within w_pop_prompt_time
end type
type cb_cancel from commandbutton within w_pop_prompt_time
end type
type cb_done from commandbutton within w_pop_prompt_time
end type
type st_second_title from statictext within w_pop_prompt_time
end type
type cb_second_plus_1 from commandbutton within w_pop_prompt_time
end type
type cb_second_minus_1 from commandbutton within w_pop_prompt_time
end type
type st_hour_title from statictext within w_pop_prompt_time
end type
type cb_hour_plus_1 from commandbutton within w_pop_prompt_time
end type
type cb_hour_minus_1 from commandbutton within w_pop_prompt_time
end type
type cb_minute_minus_1 from commandbutton within w_pop_prompt_time
end type
type cb_minute_plus_1 from commandbutton within w_pop_prompt_time
end type
type st_minute_title from statictext within w_pop_prompt_time
end type
type st_time_title from statictext within w_pop_prompt_time
end type
type em_time from editmask within w_pop_prompt_time
end type
type st_prompt from statictext within w_pop_prompt_time
end type
end forward

global type w_pop_prompt_time from w_window_base
integer x = 434
integer y = 452
integer width = 2034
integer height = 944
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
cb_hour_plus_10 cb_hour_plus_10
cb_hour_minus_10 cb_hour_minus_10
cb_second_plus_10 cb_second_plus_10
cb_second_minus_10 cb_second_minus_10
cb_minute_minus_10 cb_minute_minus_10
cb_minute_plus_10 cb_minute_plus_10
cb_cancel cb_cancel
cb_done cb_done
st_second_title st_second_title
cb_second_plus_1 cb_second_plus_1
cb_second_minus_1 cb_second_minus_1
st_hour_title st_hour_title
cb_hour_plus_1 cb_hour_plus_1
cb_hour_minus_1 cb_hour_minus_1
cb_minute_minus_1 cb_minute_minus_1
cb_minute_plus_1 cb_minute_plus_1
st_minute_title st_minute_title
st_time_title st_time_title
em_time em_time
st_prompt st_prompt
end type
global w_pop_prompt_time w_pop_prompt_time

type variables

end variables

event open;call super::open;str_popup popup

popup = message.powerobjectparm

st_prompt.text = popup.title

if istime(popup.item) then
	em_time.text = string(time(popup.item), time_format_string)
else
	em_time.text = string(now(), time_format_string)
end if

em_time.setfocus()


end event

on w_pop_prompt_time.create
int iCurrent
call super::create
this.cb_hour_plus_10=create cb_hour_plus_10
this.cb_hour_minus_10=create cb_hour_minus_10
this.cb_second_plus_10=create cb_second_plus_10
this.cb_second_minus_10=create cb_second_minus_10
this.cb_minute_minus_10=create cb_minute_minus_10
this.cb_minute_plus_10=create cb_minute_plus_10
this.cb_cancel=create cb_cancel
this.cb_done=create cb_done
this.st_second_title=create st_second_title
this.cb_second_plus_1=create cb_second_plus_1
this.cb_second_minus_1=create cb_second_minus_1
this.st_hour_title=create st_hour_title
this.cb_hour_plus_1=create cb_hour_plus_1
this.cb_hour_minus_1=create cb_hour_minus_1
this.cb_minute_minus_1=create cb_minute_minus_1
this.cb_minute_plus_1=create cb_minute_plus_1
this.st_minute_title=create st_minute_title
this.st_time_title=create st_time_title
this.em_time=create em_time
this.st_prompt=create st_prompt
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_hour_plus_10
this.Control[iCurrent+2]=this.cb_hour_minus_10
this.Control[iCurrent+3]=this.cb_second_plus_10
this.Control[iCurrent+4]=this.cb_second_minus_10
this.Control[iCurrent+5]=this.cb_minute_minus_10
this.Control[iCurrent+6]=this.cb_minute_plus_10
this.Control[iCurrent+7]=this.cb_cancel
this.Control[iCurrent+8]=this.cb_done
this.Control[iCurrent+9]=this.st_second_title
this.Control[iCurrent+10]=this.cb_second_plus_1
this.Control[iCurrent+11]=this.cb_second_minus_1
this.Control[iCurrent+12]=this.st_hour_title
this.Control[iCurrent+13]=this.cb_hour_plus_1
this.Control[iCurrent+14]=this.cb_hour_minus_1
this.Control[iCurrent+15]=this.cb_minute_minus_1
this.Control[iCurrent+16]=this.cb_minute_plus_1
this.Control[iCurrent+17]=this.st_minute_title
this.Control[iCurrent+18]=this.st_time_title
this.Control[iCurrent+19]=this.em_time
this.Control[iCurrent+20]=this.st_prompt
end on

on w_pop_prompt_time.destroy
call super::destroy
destroy(this.cb_hour_plus_10)
destroy(this.cb_hour_minus_10)
destroy(this.cb_second_plus_10)
destroy(this.cb_second_minus_10)
destroy(this.cb_minute_minus_10)
destroy(this.cb_minute_plus_10)
destroy(this.cb_cancel)
destroy(this.cb_done)
destroy(this.st_second_title)
destroy(this.cb_second_plus_1)
destroy(this.cb_second_minus_1)
destroy(this.st_hour_title)
destroy(this.cb_hour_plus_1)
destroy(this.cb_hour_minus_1)
destroy(this.cb_minute_minus_1)
destroy(this.cb_minute_plus_1)
destroy(this.st_minute_title)
destroy(this.st_time_title)
destroy(this.em_time)
destroy(this.st_prompt)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_pop_prompt_time
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_pop_prompt_time
end type

type cb_hour_plus_10 from commandbutton within w_pop_prompt_time
integer x = 1550
integer y = 264
integer width = 137
integer height = 96
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "+10"
end type

event clicked;time lt_time

lt_time = time(em_time.text)
lt_time = relativetime(lt_time, 36000)
em_time.text = string(lt_time, time_format_string)

end event

type cb_hour_minus_10 from commandbutton within w_pop_prompt_time
integer x = 1701
integer y = 264
integer width = 137
integer height = 96
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "-10"
end type

event clicked;time lt_time

lt_time = time(em_time.text)
lt_time = relativetime(lt_time, -36000)
em_time.text = string(lt_time, time_format_string)

end event

type cb_second_plus_10 from commandbutton within w_pop_prompt_time
integer x = 1550
integer y = 512
integer width = 137
integer height = 96
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "+10"
end type

event clicked;time lt_time

lt_time = time(em_time.text)
lt_time = relativetime(lt_time, 10)
em_time.text = string(lt_time, time_format_string)

end event

type cb_second_minus_10 from commandbutton within w_pop_prompt_time
integer x = 1701
integer y = 512
integer width = 137
integer height = 96
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "-10"
end type

event clicked;time lt_time

lt_time = time(em_time.text)
lt_time = relativetime(lt_time, -10)
em_time.text = string(lt_time, time_format_string)

end event

type cb_minute_minus_10 from commandbutton within w_pop_prompt_time
integer x = 1701
integer y = 388
integer width = 137
integer height = 96
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "-10"
end type

event clicked;time lt_time

lt_time = time(em_time.text)
lt_time = relativetime(lt_time, -600)
em_time.text = string(lt_time, time_format_string)

end event

type cb_minute_plus_10 from commandbutton within w_pop_prompt_time
integer x = 1550
integer y = 388
integer width = 137
integer height = 96
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "+10"
end type

event clicked;time lt_time

lt_time = time(em_time.text)
lt_time = relativetime(lt_time, 600)
em_time.text = string(lt_time, time_format_string)

end event

type cb_cancel from commandbutton within w_pop_prompt_time
integer x = 73
integer y = 760
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

setnull(popup_return.item)
popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

type cb_done from commandbutton within w_pop_prompt_time
integer x = 1550
integer y = 764
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

event clicked;str_popup_return popup_return

if not istime(em_time.text) then
	openwithparm(w_pop_message, "Please enter a valid time")
	return 
end if

popup_return.items[1] = em_time.text
popup_return.item_count = 1

closewithreturn(parent, popup_return)

end event

type st_second_title from statictext within w_pop_prompt_time
integer x = 969
integer y = 524
integer width = 215
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Second"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_second_plus_1 from commandbutton within w_pop_prompt_time
integer x = 1207
integer y = 512
integer width = 137
integer height = 96
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "+1"
end type

event clicked;time lt_time

lt_time = time(em_time.text)
lt_time = relativetime(lt_time, 1)
em_time.text = string(lt_time, time_format_string)

end event

type cb_second_minus_1 from commandbutton within w_pop_prompt_time
integer x = 1358
integer y = 512
integer width = 137
integer height = 96
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "-1"
end type

event clicked;time lt_time

lt_time = time(em_time.text)
lt_time = relativetime(lt_time, -1)
em_time.text = string(lt_time, time_format_string)

end event

type st_hour_title from statictext within w_pop_prompt_time
integer x = 974
integer y = 276
integer width = 210
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Hour"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_hour_plus_1 from commandbutton within w_pop_prompt_time
integer x = 1207
integer y = 264
integer width = 137
integer height = 96
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "+1"
end type

event clicked;time lt_time

lt_time = time(em_time.text)
lt_time = relativetime(lt_time, 3600)
em_time.text = string(lt_time, time_format_string)

end event

type cb_hour_minus_1 from commandbutton within w_pop_prompt_time
integer x = 1358
integer y = 264
integer width = 137
integer height = 96
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "-1"
end type

event clicked;time lt_time

lt_time = time(em_time.text)
lt_time = relativetime(lt_time, -3600)
em_time.text = string(lt_time, time_format_string)

end event

type cb_minute_minus_1 from commandbutton within w_pop_prompt_time
integer x = 1358
integer y = 388
integer width = 137
integer height = 96
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "-1"
end type

event clicked;time lt_time

lt_time = time(em_time.text)
lt_time = relativetime(lt_time, -60)
em_time.text = string(lt_time, time_format_string)

end event

type cb_minute_plus_1 from commandbutton within w_pop_prompt_time
integer x = 1207
integer y = 388
integer width = 137
integer height = 96
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "+1"
end type

event clicked;time lt_time

lt_time = time(em_time.text)
lt_time = relativetime(lt_time, 60)
em_time.text = string(lt_time, time_format_string)

end event

type st_minute_title from statictext within w_pop_prompt_time
integer x = 974
integer y = 400
integer width = 210
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Minute"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_time_title from statictext within w_pop_prompt_time
integer x = 215
integer y = 396
integer width = 210
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Time:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_time from editmask within w_pop_prompt_time
integer x = 462
integer y = 380
integer width = 402
integer height = 100
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = timemask!
string mask = "hh:mm:ss"
end type

type st_prompt from statictext within w_pop_prompt_time
integer width = 2030
integer height = 188
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = COLOR_BACKGROUND
boolean enabled = false
boolean focusrectangle = false
end type

