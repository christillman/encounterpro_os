HA$PBExportHeader$w_pop_appointment_date_time.srw
forward
global type w_pop_appointment_date_time from w_window_base
end type
type cb_2 from commandbutton within w_pop_appointment_date_time
end type
type cb_1 from commandbutton within w_pop_appointment_date_time
end type
type ole_calendar from u_calendar within w_pop_appointment_date_time
end type
type st_minute_title from statictext within w_pop_appointment_date_time
end type
type cb_hour_minus_1 from commandbutton within w_pop_appointment_date_time
end type
type cb_hour_plus_1 from commandbutton within w_pop_appointment_date_time
end type
type st_hour_title from statictext within w_pop_appointment_date_time
end type
type cb_minute_plus_10 from commandbutton within w_pop_appointment_date_time
end type
type cb_minute_minus_10 from commandbutton within w_pop_appointment_date_time
end type
type cb_done from commandbutton within w_pop_appointment_date_time
end type
type cb_cancel from commandbutton within w_pop_appointment_date_time
end type
type st_time_title from statictext within w_pop_appointment_date_time
end type
type em_time from editmask within w_pop_appointment_date_time
end type
type st_prompt from statictext within w_pop_appointment_date_time
end type
end forward

global type w_pop_appointment_date_time from w_window_base
integer x = 434
integer y = 604
integer width = 2720
integer height = 1492
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
cb_2 cb_2
cb_1 cb_1
ole_calendar ole_calendar
st_minute_title st_minute_title
cb_hour_minus_1 cb_hour_minus_1
cb_hour_plus_1 cb_hour_plus_1
st_hour_title st_hour_title
cb_minute_plus_10 cb_minute_plus_10
cb_minute_minus_10 cb_minute_minus_10
cb_done cb_done
cb_cancel cb_cancel
st_time_title st_time_title
em_time em_time
st_prompt st_prompt
end type
global w_pop_appointment_date_time w_pop_appointment_date_time

type variables
string appointment_time_format_string = "hh:mm"


end variables

event open;call super::open;//str_popup popup
//datetime ldt_datetime
//string ls_date
//string ls_time
//
//popup = message.powerobjectparm
//
//st_prompt.text = popup.title
//
//if not isnull(popup.item) and trim(popup.item) <> "" then
//	f_split_string(popup.item, " ", ls_date, ls_time)
//	
//	if isdate(ls_date) then
//		st_date.text = string(date(ls_date), date_format_string)
//	else
//		st_date.text = string(today(), date_format_string)
//	end if
//	
//	if istime(ls_time) then
//		em_time.text = string(time(ls_time), time_format_string)
//	else
//		em_time.text = string(now(), time_format_string)
//	end if
//else
//	st_date.text = string(today(), date_format_string)
//	em_time.text = string(now(), time_format_string)
//end if
//
//em_time.setfocus()
//
//
end event

on w_pop_appointment_date_time.create
int iCurrent
call super::create
this.cb_2=create cb_2
this.cb_1=create cb_1
this.ole_calendar=create ole_calendar
this.st_minute_title=create st_minute_title
this.cb_hour_minus_1=create cb_hour_minus_1
this.cb_hour_plus_1=create cb_hour_plus_1
this.st_hour_title=create st_hour_title
this.cb_minute_plus_10=create cb_minute_plus_10
this.cb_minute_minus_10=create cb_minute_minus_10
this.cb_done=create cb_done
this.cb_cancel=create cb_cancel
this.st_time_title=create st_time_title
this.em_time=create em_time
this.st_prompt=create st_prompt
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.ole_calendar
this.Control[iCurrent+4]=this.st_minute_title
this.Control[iCurrent+5]=this.cb_hour_minus_1
this.Control[iCurrent+6]=this.cb_hour_plus_1
this.Control[iCurrent+7]=this.st_hour_title
this.Control[iCurrent+8]=this.cb_minute_plus_10
this.Control[iCurrent+9]=this.cb_minute_minus_10
this.Control[iCurrent+10]=this.cb_done
this.Control[iCurrent+11]=this.cb_cancel
this.Control[iCurrent+12]=this.st_time_title
this.Control[iCurrent+13]=this.em_time
this.Control[iCurrent+14]=this.st_prompt
end on

on w_pop_appointment_date_time.destroy
call super::destroy
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.ole_calendar)
destroy(this.st_minute_title)
destroy(this.cb_hour_minus_1)
destroy(this.cb_hour_plus_1)
destroy(this.st_hour_title)
destroy(this.cb_minute_plus_10)
destroy(this.cb_minute_minus_10)
destroy(this.cb_done)
destroy(this.cb_cancel)
destroy(this.st_time_title)
destroy(this.em_time)
destroy(this.st_prompt)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_pop_appointment_date_time
boolean visible = true
integer x = 2432
integer y = 28
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_pop_appointment_date_time
end type

type cb_2 from commandbutton within w_pop_appointment_date_time
integer x = 919
integer y = 192
integer width = 215
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ">>"
end type

type cb_1 from commandbutton within w_pop_appointment_date_time
integer x = 686
integer y = 192
integer width = 215
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "<<"
end type

type ole_calendar from u_calendar within w_pop_appointment_date_time
integer x = 210
integer y = 308
integer width = 1413
integer height = 884
integer taborder = 10
string binarykey = "w_pop_appointment_date_time.win"
end type

event afterupdate;call super::afterupdate;//integer li_month
//integer li_year
//integer i
//
//li_month = object.month
//li_year = object.year
//
//if li_month <> this_month and li_month >= 1 and li_month <= 12 then
//	dw_months.clear_selected()
//	dw_months.object.selected_flag[li_month] = 1
//	this_month = li_month
//end if
//
//if li_year <> this_year then
//	dw_year.clear_selected()
//	this_year = li_year
//	for i = 1 to dw_year.rowcount()
//		li_year = dw_year.object.year[i]
//		if li_year = this_year then
//			dw_year.object.selected_flag[i] = 1
//		end if
//	next
//end if
//
//
end event

type st_minute_title from statictext within w_pop_appointment_date_time
integer x = 1911
integer y = 708
integer width = 210
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Minute"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_hour_minus_1 from commandbutton within w_pop_appointment_date_time
integer x = 2295
integer y = 572
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
em_time.text = string(lt_time, appointment_time_format_string)

end event

type cb_hour_plus_1 from commandbutton within w_pop_appointment_date_time
integer x = 2144
integer y = 572
integer width = 137
integer height = 96
integer taborder = 10
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
em_time.text = string(lt_time, appointment_time_format_string)

end event

type st_hour_title from statictext within w_pop_appointment_date_time
integer x = 1911
integer y = 584
integer width = 210
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Hour"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_minute_plus_10 from commandbutton within w_pop_appointment_date_time
integer x = 2144
integer y = 696
integer width = 137
integer height = 96
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "+15"
end type

event clicked;time lt_time

lt_time = time(em_time.text)
lt_time = relativetime(lt_time, 900)
em_time.text = string(lt_time, appointment_time_format_string)

end event

type cb_minute_minus_10 from commandbutton within w_pop_appointment_date_time
integer x = 2295
integer y = 696
integer width = 137
integer height = 96
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "-15"
end type

event clicked;time lt_time

lt_time = time(em_time.text)
lt_time = relativetime(lt_time, -900)
em_time.text = string(lt_time, appointment_time_format_string)

end event

type cb_done from commandbutton within w_pop_appointment_date_time
integer x = 2208
integer y = 1304
integer width = 402
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;//str_popup_return popup_return
//
//if not isdate(st_date.text) then
//	openwithparm(w_pop_message, "Please enter a valid date")
//	return
//end if
//
//if not istime(em_time.text) then
//	openwithparm(w_pop_message, "Please enter a valid time")
//	return 
//end if
//
//popup_return.item = st_date.text + " " + em_time.text
//popup_return.items[1] = st_date.text
//popup_return.items[2] = em_time.text
//popup_return.item_count = 2
//
//closewithreturn(parent, popup_return)
//
end event

type cb_cancel from commandbutton within w_pop_appointment_date_time
integer x = 46
integer y = 1304
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 700
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

type st_time_title from statictext within w_pop_appointment_date_time
integer x = 1847
integer y = 444
integer width = 210
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Time:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_time from editmask within w_pop_appointment_date_time
integer x = 2071
integer y = 428
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
string mask = "hh:mm"
end type

type st_prompt from statictext within w_pop_appointment_date_time
integer width = 2679
integer height = 132
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 33538240
boolean enabled = false
boolean focusrectangle = false
end type


Start of PowerBuilder Binary Data Section : Do NOT Edit
05w_pop_appointment_date_time.bin 
2200000e00e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd00000004fffffffe00000005fffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff00000003000000000000000000000000000000000000000000000000000000003f4e4da001c6a70100000003000003000000000000500003004c004200430049004e0045004500530045004b000000590000000000000000000000000000000000000000000000000000000000000000000000000002001cffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000fffffffe000000000000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000002001affffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000017a00000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000101001a0000000200000001000000048e27c92b101c126402042f8a029c0024000000003f4e4da001c6a7013f4e4da001c6a7010000000000000000000000000000000100000002000000030000000400000005fffffffe0000000700000008000000090000000a0000000bfffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
27ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0008000000001ff0000016d7000b07d2000f00190000800000000000001000a000008000000100a00002000700010000000100000001000000010000000100000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000002bc000000012a706972410500016c610190000000012a706972410500016c6102bc00000001dd586972410500656c61004600000008000000001ff0000016d7000b07d2000f00190000800000000000001000a000008000000100a000020007000100000001000000010000000100000001000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006f00430074006e006e00650073007400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000060000017a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000002bc000000012a706972410500016c610190000000012a706972410500016c6102bc00000001dd5869724105ffff6c61ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
15w_pop_appointment_date_time.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
