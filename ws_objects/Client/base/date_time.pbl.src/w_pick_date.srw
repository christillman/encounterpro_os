$PBExportHeader$w_pick_date.srw
forward
global type w_pick_date from w_window_base
end type
type dw_year from u_dw_pick_list within w_pick_date
end type
type st_title from statictext within w_pick_date
end type
type cb_year_back from commandbutton within w_pick_date
end type
type cb_year_forward from commandbutton within w_pick_date
end type
type dw_decade from u_dw_pick_list within w_pick_date
end type
type dw_months from u_dw_pick_list within w_pick_date
end type
type mc_calendar from u_calendar_pb within w_pick_date
end type
type st_shift_title from statictext within w_pick_date
end type
type cb_cancel from commandbutton within w_pick_date
end type
type cb_ok from commandbutton within w_pick_date
end type
type st_decade_title from statictext within w_pick_date
end type
type st_year_title from statictext within w_pick_date
end type
type st_month_title from statictext within w_pick_date
end type
type dp_enter_date from datepicker within w_pick_date
end type
type st_enter_date_title from statictext within w_pick_date
end type
end forward

global type w_pick_date from w_window_base
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean auto_resize_objects = false
dw_year dw_year
st_title st_title
cb_year_back cb_year_back
cb_year_forward cb_year_forward
dw_decade dw_decade
dw_months dw_months
mc_calendar mc_calendar
st_shift_title st_shift_title
cb_cancel cb_cancel
cb_ok cb_ok
st_decade_title st_decade_title
st_year_title st_year_title
st_month_title st_month_title
dp_enter_date dp_enter_date
st_enter_date_title st_enter_date_title
end type
global w_pick_date w_pick_date

type variables
date this_date

integer this_year
integer this_month


end variables

forward prototypes
public subroutine set_date ()
public subroutine show_decade ()
end prototypes

public subroutine set_date ();date ld_date
integer li_day
long ll_this_decade
long ll_year
long i

ld_date = mc_calendar.current_date()
li_day = day(ld_date)

ld_date = date(this_year, this_month, li_day)

// Check for an invalid date
if ld_date = date("1/1/1900") &
	and (this_year <> 1900 or this_month <> 1 or li_day <> 1) then
	DO WHILE ld_date = date("1/1/1900") and li_day > 28
		li_day -= 1
		ld_date = date(this_year, this_month, li_day)
	LOOP
end if

mc_calendar.set_date(ld_date)
dp_enter_date.setvalue(ld_date, time(""))

ll_this_decade = int(this_year/10) * 10

dw_year.clear_selected()
for i = 1 to dw_year.rowcount()
	ll_year = ll_this_decade + i - 1
	dw_year.object.year[i] = ll_year
	if ll_year = this_year then
		dw_year.object.selected_flag[i] = 1
	end if
next


// Shift the decade to include the current year
show_decade()

end subroutine

public subroutine show_decade ();
// Shift the decade to include the current year

long ll_latest_decade
long ll_earliest_decade
long ll_this_decade
long ll_row
long ll_scroll
string ls_find

ll_this_decade = int(this_year/10) * 10

ll_row = long(string(dw_decade.object.datawindow.firstrowonpage))
if ll_row > 0 then
	ll_latest_decade = dw_decade.object.year[ll_row]
else
	return
end if

ll_row = long(string(dw_decade.object.datawindow.lastrowonpage))
if ll_row > 0 then
	ll_earliest_decade = dw_decade.object.year[ll_row]
else
	return
end if

dw_decade.clear_selected()
ls_find = "year=" + string(ll_this_decade)
ll_row = dw_decade.find(ls_find, 1, dw_decade.rowcount())
if ll_row > 0 then
	dw_decade.object.selected_flag[ll_row] = 1
	if ll_this_decade > ll_latest_decade or ll_this_decade < ll_earliest_decade then
		dw_decade.scrolltorow(ll_row)
	end if
end if


end subroutine

on w_pick_date.create
int iCurrent
call super::create
this.dw_year=create dw_year
this.st_title=create st_title
this.cb_year_back=create cb_year_back
this.cb_year_forward=create cb_year_forward
this.dw_decade=create dw_decade
this.dw_months=create dw_months
this.mc_calendar=create mc_calendar
this.st_shift_title=create st_shift_title
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.st_decade_title=create st_decade_title
this.st_year_title=create st_year_title
this.st_month_title=create st_month_title
this.dp_enter_date=create dp_enter_date
this.st_enter_date_title=create st_enter_date_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_year
this.Control[iCurrent+2]=this.st_title
this.Control[iCurrent+3]=this.cb_year_back
this.Control[iCurrent+4]=this.cb_year_forward
this.Control[iCurrent+5]=this.dw_decade
this.Control[iCurrent+6]=this.dw_months
this.Control[iCurrent+7]=this.mc_calendar
this.Control[iCurrent+8]=this.st_shift_title
this.Control[iCurrent+9]=this.cb_cancel
this.Control[iCurrent+10]=this.cb_ok
this.Control[iCurrent+11]=this.st_decade_title
this.Control[iCurrent+12]=this.st_year_title
this.Control[iCurrent+13]=this.st_month_title
this.Control[iCurrent+14]=this.dp_enter_date
this.Control[iCurrent+15]=this.st_enter_date_title
end on

on w_pick_date.destroy
call super::destroy
destroy(this.dw_year)
destroy(this.st_title)
destroy(this.cb_year_back)
destroy(this.cb_year_forward)
destroy(this.dw_decade)
destroy(this.dw_months)
destroy(this.mc_calendar)
destroy(this.st_shift_title)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.st_decade_title)
destroy(this.st_year_title)
destroy(this.st_month_title)
destroy(this.dp_enter_date)
destroy(this.st_enter_date_title)
end on

event open;call super::open;str_popup popup
integer li_pos
integer i
long ll_row
integer li_day
integer li_this_decade
integer li_current_decade
long ll_decade_row
integer li_firstday

mc_calendar.firstdayofweek = f_first_day_of_week()


popup = message.powerobjectparm
If len(popup.title) > 0 Then
	st_title.text = popup.title
Else
	st_title.text = "Select Date"
End if

If popup.data_row_count = 1 Then
	If Isdate(popup.items[1]) Then
		this_date = date(popup.items[1])
	Else
		Setnull(this_date)
	End If
ElseIf isdate(popup.item) Then
	this_date = date(popup.item)
Else
	setnull(this_date)
End If

If isnull(this_date) Then
	this_date = today()
End If
mc_calendar.set_date(this_date)
this_year = year(this_date)
this_month = month(this_date)

li_this_decade = int(this_year/10) * 10
li_current_decade = int(year(today())/10) * 10

// First, populate the pick lists

dw_months.reset()
for i = 1 to 12
	ll_row = dw_months.insertrow(0)
	dw_months.object.month[ll_row] = month_str[i]
	dw_months.object.month_number[ll_row] = i
	if i = this_month and not isnull(this_date) then dw_months.object.selected_flag[i] = 1
next

ll_decade_row = 0

dw_decade.reset()
for i = li_current_decade + 10 to li_current_decade - 200 step -10
	ll_row = dw_decade.insertrow(0)
	dw_decade.object.year[ll_row] = i
	if i = li_this_decade then
		ll_decade_row = ll_row
		dw_decade.object.selected_flag[ll_decade_row] = 1
	end if
next

if ll_decade_row > 0 then dw_decade.event trigger selected(ll_decade_row)



set_date()

end event

event resize;call super::resize;
st_title.width = newwidth

dw_year.x = newwidth - dw_year.width - 50
st_year_title.x = dw_year.x

dw_decade.x = dw_year.x - dw_decade.width - 20
st_decade_title.x = dw_decade.x

cb_year_forward.x = newwidth - cb_year_forward.width - 50
st_shift_title.x = cb_year_forward.x - st_shift_title.width - 4
cb_year_back.x = st_shift_title.x - cb_year_back.width - 4


cb_ok.x = newwidth - cb_ok.width - 40
cb_ok.y = newheight - cb_ok.height - 40

cb_cancel.x = 50
cb_cancel.y = cb_ok.y

mc_calendar.width = dw_decade.x - mc_calendar.x - 40
mc_calendar.height = cb_ok.y - 300

dp_enter_date.x = mc_calendar.x + mc_calendar.width - dp_enter_date.width
dp_enter_date.y = mc_calendar.y + mc_calendar.height + 26

st_enter_date_title.x = dp_enter_date.x - st_enter_date_title.width - 20
st_enter_date_title.y = dp_enter_date.y + 24

end event

type pb_epro_help from w_window_base`pb_epro_help within w_pick_date
integer taborder = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_pick_date
end type

type dw_year from u_dw_pick_list within w_pick_date
integer x = 2565
integer y = 272
integer width = 283
integer height = 1168
integer taborder = 0
boolean bringtotop = true
string dataobject = "dw_year_list"
boolean border = false
end type

event selected;call super::selected;this_year = object.year[selected_row]
set_date()
end event

type st_title from statictext within w_pick_date
integer width = 2917
integer height = 136
boolean bringtotop = true
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Select Date"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_year_back from commandbutton within w_pick_date
integer x = 2336
integer y = 1472
integer width = 155
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "<<"
end type

event clicked;
this_year -= 10

set_date()

end event

type cb_year_forward from commandbutton within w_pick_date
integer x = 2683
integer y = 1472
integer width = 155
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ">>"
end type

event clicked;
this_year += 10

set_date()

end event

type dw_decade from u_dw_pick_list within w_pick_date
integer x = 2272
integer y = 272
integer width = 283
integer height = 1168
integer taborder = 0
boolean bringtotop = true
string dataobject = "dw_decade_list"
boolean border = false
end type

event selected;call super::selected;integer li_decade
integer i
long ll_row

li_decade = object.year[selected_row]

dw_year.reset()

for i = li_decade to li_decade + 9
	ll_row = dw_year.insertrow(0)
	dw_year.object.year[ll_row] = i
	if i = this_year then dw_year.object.selected_flag[ll_row] = 1
next


end event

type dw_months from u_dw_pick_list within w_pick_date
integer x = 64
integer y = 236
integer width = 283
integer height = 1308
integer taborder = 0
boolean bringtotop = true
string dataobject = "dw_month_list"
boolean border = false
end type

event selected;call super::selected;this_month = object.month_number[selected_row]
set_date()

end event

type mc_calendar from u_calendar_pb within w_pick_date
integer x = 389
integer y = 208
integer width = 1774
integer height = 1360
end type

event datechanged;call super::datechanged;integer li_month
integer li_year
integer i
date ld_selected_date
integer li_sts

li_sts =  getselecteddate(ld_selected_date)
if li_sts < 0 then return

li_month = month(ld_selected_date)
li_year = year(ld_selected_date)

if li_month <> this_month and li_month >= 1 and li_month <= 12 then
	dw_months.clear_selected()
	dw_months.object.selected_flag[li_month] = 1
	this_month = li_month
end if

this_year = li_year

set_date()


end event

type st_shift_title from statictext within w_pick_date
integer x = 2487
integer y = 1472
integer width = 192
integer height = 128
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33536444
string text = "Shift Decade"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_pick_date
integer x = 69
integer y = 1676
integer width = 402
integer height = 112
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

event clicked;str_popup_return popup_return

setnull(popup_return.item)
popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

type cb_ok from commandbutton within w_pick_date
integer x = 2459
integer y = 1676
integer width = 402
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;str_popup_return popup_return
date ld_date

popup_return.item = string(mc_calendar.current_date(), date_format_string)
popup_return.item_count = 1
popup_return.items[1] = popup_return.item

closewithreturn(parent, popup_return)

end event

type st_decade_title from statictext within w_pick_date
integer x = 2272
integer y = 216
integer width = 274
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33536444
string text = "Decade"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_year_title from statictext within w_pick_date
integer x = 2565
integer y = 216
integer width = 274
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33536444
string text = "Year"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_month_title from statictext within w_pick_date
integer x = 78
integer y = 180
integer width = 210
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33536444
string text = "Month"
alignment alignment = center!
boolean focusrectangle = false
end type

type dp_enter_date from datepicker within w_pick_date
integer x = 1463
integer y = 1592
integer width = 686
integer height = 100
integer taborder = 10
boolean bringtotop = true
boolean border = true
borderstyle borderstyle = stylelowered!
date maxdate = Date("2999-12-31")
date mindate = Date("1800-01-01")
datetime value = DateTime(Date("2007-10-04"), Time("09:04:43.000000"))
integer textsize = -10
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
integer calendarfontweight = 400
boolean todaysection = true
boolean todaycircle = true
end type

event valuechanged;mc_calendar.set_date(date(dtm))

end event

type st_enter_date_title from statictext within w_pick_date
integer x = 960
integer y = 1616
integer width = 485
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "... or Enter Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

