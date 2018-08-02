$PBExportHeader$w_pop_close_assessment.srw
forward
global type w_pop_close_assessment from w_window_base
end type
type st_open_date from statictext within w_pop_close_assessment
end type
type st_open_date_title from statictext within w_pop_close_assessment
end type
type st_2 from statictext within w_pop_close_assessment
end type
type st_close_date from statictext within w_pop_close_assessment
end type
type st_bill_flag from statictext within w_pop_close_assessment
end type
type st_title from statictext within w_pop_close_assessment
end type
type st_bill from statictext within w_pop_close_assessment
end type
type pb_cancel from u_picture_button within w_pop_close_assessment
end type
type pb_ok from u_picture_button within w_pop_close_assessment
end type
type st_1 from statictext within w_pop_close_assessment
end type
end forward

global type w_pop_close_assessment from w_window_base
integer x = 425
integer y = 272
integer width = 2039
integer height = 1408
windowtype windowtype = response!
st_open_date st_open_date
st_open_date_title st_open_date_title
st_2 st_2
st_close_date st_close_date
st_bill_flag st_bill_flag
st_title st_title
st_bill st_bill
pb_cancel pb_cancel
pb_ok pb_ok
st_1 st_1
end type
global w_pop_close_assessment w_pop_close_assessment

type variables
string bill_flag

date open_date
date close_date

end variables

event open;call super::open;str_popup popup
str_popup_return popup_return

popup_return.item_count = 0

popup = message.powerobjectparm
st_title.text = popup.title

title = current_patient.id_line()

if popup.data_row_count = 2 then
	bill_flag = popup.items[1]
	if bill_flag = "Y" then
		st_bill_flag.backcolor = color_object_selected
		st_bill_flag.text = "Yes"
	else
		st_bill_flag.backcolor = color_object
		st_bill_flag.text = "No"
		bill_flag = "N"
	end if
	
	open_date = date(popup.items[2])
	st_open_date.text = string(open_date, date_format_string)
else
	log.log(this, "w_pop_close_assessment.open.0025", "Invalid parameters", 4)
	closewithreturn(this, popup_return)
	return
end if

close_date = date(current_patient.open_encounter.encounter_date)
st_close_date.text = string(close_date, date_format_string)



end event

on w_pop_close_assessment.create
int iCurrent
call super::create
this.st_open_date=create st_open_date
this.st_open_date_title=create st_open_date_title
this.st_2=create st_2
this.st_close_date=create st_close_date
this.st_bill_flag=create st_bill_flag
this.st_title=create st_title
this.st_bill=create st_bill
this.pb_cancel=create pb_cancel
this.pb_ok=create pb_ok
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_open_date
this.Control[iCurrent+2]=this.st_open_date_title
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_close_date
this.Control[iCurrent+5]=this.st_bill_flag
this.Control[iCurrent+6]=this.st_title
this.Control[iCurrent+7]=this.st_bill
this.Control[iCurrent+8]=this.pb_cancel
this.Control[iCurrent+9]=this.pb_ok
this.Control[iCurrent+10]=this.st_1
end on

on w_pop_close_assessment.destroy
call super::destroy
destroy(this.st_open_date)
destroy(this.st_open_date_title)
destroy(this.st_2)
destroy(this.st_close_date)
destroy(this.st_bill_flag)
destroy(this.st_title)
destroy(this.st_bill)
destroy(this.pb_cancel)
destroy(this.pb_ok)
destroy(this.st_1)
end on

type st_open_date from statictext within w_pop_close_assessment
integer x = 951
integer y = 464
integer width = 558
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
boolean enabled = false
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_open_date_title from statictext within w_pop_close_assessment
integer x = 306
integer y = 472
integer width = 613
integer height = 76
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Open Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_pop_close_assessment
integer x = 306
integer y = 664
integer width = 613
integer height = 76
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Close Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_close_date from statictext within w_pop_close_assessment
integer x = 951
integer y = 656
integer width = 558
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string ls_temp
date ld_temp

ld_temp = close_date

ls_temp = f_select_date(ld_temp, "Encounter Close Date (opened " + st_open_date.text + ")")
if isnull(ls_temp) then return

if ld_temp < open_date then
	openwithparm(w_pop_message, "Close Date must be on or after open date")
	return
end if

close_date = ld_temp
text = ls_temp


end event

type st_bill_flag from statictext within w_pop_close_assessment
event clicked pbm_bnclicked
integer x = 1170
integer y = 904
integer width = 229
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Yes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if bill_flag = "Y" then
	backcolor = color_object
	bill_flag = "N"
	text = "No"
else
	backcolor = color_object_selected
	bill_flag = "Y"
	text = "Yes"
end if


end event

type st_title from statictext within w_pop_close_assessment
integer y = 4
integer width = 2030
integer height = 156
integer textsize = -18
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type st_bill from statictext within w_pop_close_assessment
integer x = 453
integer y = 912
integer width = 686
integer height = 84
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Bill This Diagnosis:"
alignment alignment = right!
boolean focusrectangle = false
end type

event clicked;if bill_flag = "Y" then
	bill_flag = "N"
	backcolor = color_object
else
	bill_flag = "Y"
	backcolor = color_object_selected
end if

end event

type pb_cancel from u_picture_button within w_pop_close_assessment
integer x = 69
integer y = 1028
integer taborder = 10
string picturename = "button11.bmp"
string disabledname = "button11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 0
setnull(popup_return.item)

closewithreturn(parent, popup_return)

end event

type pb_ok from u_picture_button within w_pop_close_assessment
integer x = 1701
integer y = 1044
integer taborder = 20
string picturename = "button26.bmp"
string disabledname = "button26.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 2
popup_return.item = bill_flag
popup_return.items[1] = bill_flag
popup_return.items[2] = string(close_date, "[shortdate]")

closewithreturn(parent, popup_return)


end event

type st_1 from statictext within w_pop_close_assessment
integer x = 265
integer y = 184
integer width = 1490
integer height = 188
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Closing this diagnosis will close all associated treatment items."
alignment alignment = center!
boolean focusrectangle = false
end type

