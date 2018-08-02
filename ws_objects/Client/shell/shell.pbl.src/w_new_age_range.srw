$PBExportHeader$w_new_age_range.srw
forward
global type w_new_age_range from w_window_base
end type
type st_title from statictext within w_new_age_range
end type
type st_age_range_category_t from statictext within w_new_age_range
end type
type st_age_from from statictext within w_new_age_range
end type
type st_age_from_unit from statictext within w_new_age_range
end type
type st_age_to_unit from statictext within w_new_age_range
end type
type st_age_to from statictext within w_new_age_range
end type
type st_age_from_t from statictext within w_new_age_range
end type
type st_age_to_t from statictext within w_new_age_range
end type
type st_age_range_category from statictext within w_new_age_range
end type
type sle_age_range_description from singlelineedit within w_new_age_range
end type
type st_age_range_description_t from statictext within w_new_age_range
end type
type st_and_over from statictext within w_new_age_range
end type
type cb_ok from commandbutton within w_new_age_range
end type
type cb_cancel from commandbutton within w_new_age_range
end type
end forward

global type w_new_age_range from w_window_base
integer width = 2898
integer height = 1880
string title = ""
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_title st_title
st_age_range_category_t st_age_range_category_t
st_age_from st_age_from
st_age_from_unit st_age_from_unit
st_age_to_unit st_age_to_unit
st_age_to st_age_to
st_age_from_t st_age_from_t
st_age_to_t st_age_to_t
st_age_range_category st_age_range_category
sle_age_range_description sle_age_range_description
st_age_range_description_t st_age_range_description_t
st_and_over st_and_over
cb_ok cb_ok
cb_cancel cb_cancel
end type
global w_new_age_range w_new_age_range

type variables
String	age_range_category,age_range_description
String	age_from_unit,age_to_unit,overlap_flag
Long		age_from,age_to,sort_sequence
end variables

forward prototypes
public subroutine set_screen ()
public subroutine set_age_range_desc ()
end prototypes

public subroutine set_screen ();
st_age_from.text = string(age_from)
st_age_from_unit.text = wordcap(age_from_unit)

if isnull(age_to) then
	st_age_to.text = "..."
	st_age_to_unit.text = "..."
	st_and_over.backcolor = color_object_selected
else
	st_age_to.text = string(age_to)
	st_age_to_unit.text = wordcap(age_to_unit)
	st_and_over.backcolor = color_object
end if


end subroutine

public subroutine set_age_range_desc ();string ls_description

ls_description = String(age_from)
if upper(age_from_unit) = upper(age_to_unit) and not isnull(age_to) then
else
	ls_description += " " + wordcap(age_from_unit)
	if age_from <> 1 then
		ls_description += "s"
	end if
end if

if isnull(age_to) then
	ls_description += " and Over"
else
	ls_description += " - " + String(age_to) + " "
	ls_description += wordcap(age_to_unit)
	if age_to <> 1 or upper(age_from_unit) = upper(age_to_unit) then
		ls_description += "s"
	end if
end if

age_range_description = ls_description
sle_age_range_description.text = age_range_description

Return


end subroutine

on w_new_age_range.create
int iCurrent
call super::create
this.st_title=create st_title
this.st_age_range_category_t=create st_age_range_category_t
this.st_age_from=create st_age_from
this.st_age_from_unit=create st_age_from_unit
this.st_age_to_unit=create st_age_to_unit
this.st_age_to=create st_age_to
this.st_age_from_t=create st_age_from_t
this.st_age_to_t=create st_age_to_t
this.st_age_range_category=create st_age_range_category
this.sle_age_range_description=create sle_age_range_description
this.st_age_range_description_t=create st_age_range_description_t
this.st_and_over=create st_and_over
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.st_age_range_category_t
this.Control[iCurrent+3]=this.st_age_from
this.Control[iCurrent+4]=this.st_age_from_unit
this.Control[iCurrent+5]=this.st_age_to_unit
this.Control[iCurrent+6]=this.st_age_to
this.Control[iCurrent+7]=this.st_age_from_t
this.Control[iCurrent+8]=this.st_age_to_t
this.Control[iCurrent+9]=this.st_age_range_category
this.Control[iCurrent+10]=this.sle_age_range_description
this.Control[iCurrent+11]=this.st_age_range_description_t
this.Control[iCurrent+12]=this.st_and_over
this.Control[iCurrent+13]=this.cb_ok
this.Control[iCurrent+14]=this.cb_cancel
end on

on w_new_age_range.destroy
call super::destroy
destroy(this.st_title)
destroy(this.st_age_range_category_t)
destroy(this.st_age_from)
destroy(this.st_age_from_unit)
destroy(this.st_age_to_unit)
destroy(this.st_age_to)
destroy(this.st_age_from_t)
destroy(this.st_age_to_t)
destroy(this.st_age_range_category)
destroy(this.sle_age_range_description)
destroy(this.st_age_range_description_t)
destroy(this.st_and_over)
destroy(this.cb_ok)
destroy(this.cb_cancel)
end on

event open;call super::open;str_popup		popup

popup = Message.Powerobjectparm

if popup.data_row_count <> 3 then
	log.log(this,"w_new_age_range.open.0006","invalid parameters",3)
	return
end if

age_range_category = popup.items[1]
sort_sequence = long(popup.items[2])
overlap_flag = popup.items[3]

If Isnull(age_range_category) Then
	st_age_range_category.text = "N/A"
else
	st_age_range_category.text = age_range_category
end if

age_from = 1
age_from_unit = "MONTH"

setnull(age_to)
setnull(age_to_unit)

set_screen()

set_age_range_desc()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_new_age_range
integer x = 2830
integer y = 0
integer taborder = 30
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_new_age_range
end type

type st_title from statictext within w_new_age_range
integer width = 2889
integer height = 132
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "New Age Range Definition"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_age_range_category_t from statictext within w_new_age_range
integer x = 334
integer y = 556
integer width = 613
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Age Range Category"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_age_from from statictext within w_new_age_range
integer x = 1051
integer y = 740
integer width = 283
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 80269524
string text = "99"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.objectparm = unit_list.find_unit(age_from_unit)
popup.realitem = real(age_from)
openwithparm(w_number, popup)
popup_return = message.powerobjectparm
if popup_return.item <> "OK" then return

age_from = long(popup_return.realitem)
set_screen()

set_age_range_desc()

end event

type st_age_from_unit from statictext within w_new_age_range
integer x = 1394
integer y = 740
integer width = 283
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 80269524
string text = "Month"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;call super::clicked;str_popup popup
str_popup_return popup_return
integer li_index

popup.data_row_count = 3
popup.items[1] = "Days"
popup.items[2] = "Months"
popup.items[3] = "Years"

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

li_index = popup_return.item_indexes[1]
if li_index = 1 then
	age_from_unit = "DAY"
elseif li_index = 2 then
	age_from_unit = "MONTH"
else
	age_from_unit = "YEAR"
end if

set_screen()

set_age_range_desc()

end event

type st_age_to_unit from statictext within w_new_age_range
integer x = 1390
integer y = 936
integer width = 283
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 80269524
string text = "Month"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;call super::clicked;str_popup popup
str_popup_return popup_return
integer li_index

popup.data_row_count = 3
popup.items[1] = "Days"
popup.items[2] = "Months"
popup.items[3] = "Years"

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

li_index = popup_return.item_indexes[1]
if li_index = 1 then
	age_to_unit = "DAY"
elseif li_index = 2 then
	age_to_unit = "MONTH"
else
	age_to_unit = "YEAR"
end if

set_screen()

set_age_range_desc()

end event

type st_age_to from statictext within w_new_age_range
integer x = 1047
integer y = 936
integer width = 283
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 80269524
string text = "99"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.objectparm = unit_list.find_unit(age_to_unit)
popup.realitem = real(age_to)
openwithparm(w_number, popup)
popup_return = message.powerobjectparm
if popup_return.item <> "OK" then return

age_to = long(popup_return.realitem)

if isnull(age_to_unit) then
	age_to_unit = "YEAR"
end if

set_screen()

set_age_range_desc()

end event

type st_age_from_t from statictext within w_new_age_range
integer x = 640
integer y = 752
integer width = 302
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Age From"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_age_to_t from statictext within w_new_age_range
integer x = 718
integer y = 960
integer width = 224
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Age To"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_age_range_category from statictext within w_new_age_range
integer x = 1051
integer y = 548
integer width = 1038
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 80269524
boolean enabled = false
string text = "N/A"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
boolean disabledlook = true
end type

type sle_age_range_description from singlelineedit within w_new_age_range
integer x = 1015
integer y = 1144
integer width = 1353
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 40
borderstyle borderstyle = stylelowered!
end type

event modified;age_range_description = text
end event

type st_age_range_description_t from statictext within w_new_age_range
integer x = 608
integer y = 1172
integer width = 338
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Description"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_and_over from statictext within w_new_age_range
integer x = 1733
integer y = 936
integer width = 425
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "and Over"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;setnull(age_to)
set_screen()
set_age_range_desc()

end event

type cb_ok from commandbutton within w_new_age_range
integer x = 2405
integer y = 1632
integer width = 402
integer height = 112
integer taborder = 20
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

event clicked;Datetime		ldt_from_dt,ldt_to_dt
Long			ll_age_from,ll_age_to
string ls_message
long ll_sts
long ll_new_age_range_id

If Len(age_range_description) > 0 and Not Isnull(age_range_category) Then
	ll_sts = sqlca.sp_is_valid_age_range(age_range_category, age_from, age_from_unit, age_to, age_to_unit, ls_message)
	if not sqlca.check() then 
		openwithparm(w_pop_message, "Error checking age range")
		return
	end if
	
	if ll_sts <= 0 then
		openwithparm(w_pop_message, ls_message)
		return
	end if
	
	Insert Into c_Age_Range
	(
	age_range_category,
	description,
	age_from,
	age_from_unit,
	age_to,
	age_to_unit,
	sort_sequence
	)
	Values
	(
	:age_range_category,
	:age_range_description,
	:age_from,
	:age_from_unit,
	:age_to,
	:age_to_unit,
	:sort_sequence + 1
	);
	If not tf_check() then return -1
	
	SELECT SCOPE_IDENTITY()
	INTO :ll_new_age_range_id
	FROM c_1_record;
	If not tf_check() then return -1
End If

closewithreturn(Parent, ll_new_age_range_id)


end event

type cb_cancel from commandbutton within w_new_age_range
integer x = 64
integer y = 1632
integer width = 402
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;Close(Parent)
end event

type pb_done from w_window_full_response`pb_done within w_new_age_range
integer x = 2560
integer y = 1272
integer taborder = 10
end type

event pb_done::clicked;call super::clicked;Datetime		ldt_from_dt,ldt_to_dt
Long			ll_age_from,ll_age_to
string ls_message
long ll_sts

If Len(age_range_description) > 0 and Not Isnull(age_range_category) Then
	ll_sts = sqlca.sp_is_valid_age_range(age_range_category, age_from, age_from_unit, age_to, age_to_unit, ls_message)
	if not sqlca.check() then 
		openwithparm(w_pop_message, "Error checking age range")
		return
	end if
	
	if ll_sts <= 0 then
		openwithparm(w_pop_message, ls_message)
		return
	end if
	
	Insert Into c_Age_Range
	(
	age_range_category,
	description,
	age_from,
	age_from_unit,
	age_to,
	age_to_unit,
	sort_sequence
	)
	Values
	(
	:age_range_category,
	:age_range_description,
	:age_from,
	:age_from_unit,
	:age_to,
	:age_to_unit,
	:sort_sequence + 1
	);

	If not tf_check() then
		log.log(this,"w_new_age_range.pb_done.clicked.0040","unable to create new age range",3)
	End If
End If
Close(Parent)


end event

type pb_cancel from w_window_full_response`pb_cancel within w_new_age_range
integer x = 73
integer y = 1272
integer taborder = 20
end type

event pb_cancel::clicked;call super::clicked;Close(Parent)
end event

