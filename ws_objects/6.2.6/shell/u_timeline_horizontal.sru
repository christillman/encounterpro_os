HA$PBExportHeader$u_timeline_horizontal.sru
forward
global type u_timeline_horizontal from UserObject
end type
type st_date_4 from statictext within u_timeline_horizontal
end type
type st_date_3 from statictext within u_timeline_horizontal
end type
type st_date_2 from statictext within u_timeline_horizontal
end type
type st_date_1 from statictext within u_timeline_horizontal
end type
type ln_date_1 from line within u_timeline_horizontal
end type
type ln_date_2 from line within u_timeline_horizontal
end type
type ln_date_3 from line within u_timeline_horizontal
end type
end forward

global type u_timeline_horizontal from UserObject
int Width=2318
int Height=184
boolean Border=true
long BackColor=12632256
long PictureMaskColor=536870912
long TabTextColor=33554432
long TabBackColor=67108864
event clicked pbm_lbuttonclk
event date_selected ( date date_selected )
event date_range_changed ( date new_begin_date,  date new_end_date )
st_date_4 st_date_4
st_date_3 st_date_3
st_date_2 st_date_2
st_date_1 st_date_1
ln_date_1 ln_date_1
ln_date_2 ln_date_2
ln_date_3 ln_date_3
end type
global u_timeline_horizontal u_timeline_horizontal

type variables
date begin_date
date end_date
long total_days
string date_unit


end variables

forward prototypes
private function integer refresh (date pd_begin_date, date pd_end_date)
public subroutine set_months (date pd_date)
public subroutine set_quarters (date pd_date)
public subroutine set_years (date pd_date)
public subroutine scroll_left ()
public subroutine scroll_right ()
public function integer initialize ()
end prototypes

event clicked;long ll_days
date ld_date_selected
str_treatment_description lstra_treatments[]
integer i, j

// Calculate the clicked date
ll_days = (real(xpos) / real(width)) * total_days

ld_date_selected = relativedate(begin_date, ll_days)

this.event TRIGGER date_selected(ld_date_selected)


end event

private function integer refresh (date pd_begin_date, date pd_end_date);integer li_color
integer li_sts
integer i, j
integer li_line_count
integer lia_stack[]
u_st_treatment_line luo_line
long ll_begin_days
long ll_end_days
long ll_x
long ll_y
long ll_width
date ld_temp
string ls_date_format


begin_date = pd_begin_date
end_date = pd_end_date

total_days = daysafter(begin_date, end_date)

CHOOSE CASE date_unit
	CASE "YEAR"
		ls_date_format = "yyyy"
	CASE "QUARTER"
		ls_date_format = "mmm yyyy"
	CASE "MONTH"
		ls_date_format = "mmm yyyy"
END CHOOSE

st_date_1.text = string(begin_date, ls_date_format)

ld_temp = relativedate(begin_date, (total_days/4) + 10)
st_date_2.text = string(ld_temp, ls_date_format)

ld_temp = relativedate(begin_date, (total_days/2) + 10)
st_date_3.text = string(ld_temp, ls_date_format)

ld_temp = relativedate(begin_date, (3 * total_days / 4) + 10)
st_date_4.text = string(ld_temp, ls_date_format)

this.event POST date_range_changed(begin_date, end_date)

return 1

end function

public subroutine set_months (date pd_date);integer li_year
integer li_month
date ld_begin_date
date ld_end_date

date_unit = "MONTH"

// Since we don't want to care how many days are in a month, we'll find the first month and
// Calculate everything from it.
if isnull(pd_date) then
	// if the date passed in is null, then we want today to appear in the forth month
	li_year = year(today())
	li_month = month(today()) - 3
	if li_month <= 0 then
		li_month += 12
		li_year -= 1
	end if
else
	// If a date is passed in, then we want that date to appear in the third quarter
	li_year = year(pd_date)
	li_month = month(pd_date) - 2
	if li_month <= 0 then
		li_month += 12
		li_year -= 1
	end if
end if

// The begin date is the first day of the first month
ld_begin_date = date(li_year, li_month, 1)

// The end date is one day before four months after the begin date
li_month += 4
if li_month > 12 then
	li_month -= 12
	li_year += 1
end if
ld_end_date = date(li_year, li_month, 1)
ld_end_date = relativedate(ld_end_date, -1)


refresh(ld_begin_date, ld_end_date)



end subroutine

public subroutine set_quarters (date pd_date);integer li_year
integer li_month
integer li_quarter
date ld_begin_date
date ld_end_date

date_unit = "QUARTER"

// Since we don't want to care how many days are in a month, we'll find the first quarter
if isnull(pd_date) then
	// if the date passed in is null, then we want today to appear in the forth quarter
	li_year = year(today())
	li_month = month(today())
	li_quarter = int((li_month - 1) / 3) - 3
	if li_quarter < 0 then
		li_quarter += 4
		li_year -= 1
	end if
else
	// If a date is passed in, then we want that date to appear in the third quarter
	li_year = year(pd_date)
	li_month = month(pd_date)
	li_quarter = int((li_month - 1) / 3) - 2
	if li_quarter < 0 then
		li_quarter += 4
		li_year -= 1
	end if
end if

// The begin date is the first day of the first month in the quarter
ld_begin_date = date(li_year, (li_quarter * 3) + 1, 1)

// The end date is one day before one year after the begin date
ld_end_date = date(li_year + 1, (li_quarter * 3) + 1, 1)
ld_end_date = relativedate(ld_end_date, -1)

refresh(ld_begin_date, ld_end_date)



end subroutine

public subroutine set_years (date pd_date);integer li_year
date ld_begin_date
date ld_end_date

date_unit = "YEAR"

// if the date passed in is null, then assume we want to end with today
if isnull(pd_date) then
	li_year = year(today())
else
	li_year = year(pd_date) + 1
end if

ld_end_date = date(li_year, 12, 31)
ld_begin_date = date(li_year - 3, 1, 1)

refresh(ld_begin_date, ld_end_date)



end subroutine

public subroutine scroll_left ();date ld_begin_date
date ld_end_date
integer li_year
integer li_month
integer li_quarter

// scrolling left means that the graphs should appear to shift to the left, which
// means that the date range increases by one unit

CHOOSE CASE date_unit
	CASE "MONTH"
		li_year = year(begin_date)
		li_month = month(begin_date) + 1
		if li_month > 12 then
			li_month -= 12
			li_year += 1
		end if

		// The begin date is the first day of the first month
		ld_begin_date = date(li_year, li_month, 1)
		
		// The end date is one day before four months after the begin date
		li_month += 4
		if li_month > 12 then
			li_month -= 12
			li_year += 1
		end if
		ld_end_date = date(li_year, li_month, 1)
		ld_end_date = relativedate(ld_end_date, -1)		
	CASE "QUARTER"
		li_year = year(begin_date)
		li_month = month(begin_date)
		li_quarter = int((li_month - 1) / 3) + 1
		if li_quarter > 3 then
			li_quarter -= 4
			li_year += 1
		end if

		// The begin date is the first day of the first month in the quarter
		ld_begin_date = date(li_year, (li_quarter * 3) + 1, 1)
		
		// The end date is one day before one year after the begin date
		ld_end_date = date(li_year + 1, (li_quarter * 3) + 1, 1)
		ld_end_date = relativedate(ld_end_date, -1)
	CASE "YEAR"
		li_year = year(begin_date) + 1
		
		ld_begin_date = date(li_year, 1, 1)
		ld_end_date = date(li_year + 3, 12, 31)
END CHOOSE

refresh(ld_begin_date, ld_end_date)


end subroutine

public subroutine scroll_right ();date ld_begin_date
date ld_end_date
integer li_year
integer li_month
integer li_quarter

// scrolling right means that the graphs should appear to shift to the right, which
// means that the date range decreases by one unit

CHOOSE CASE date_unit
	CASE "MONTH"
		li_year = year(begin_date)
		li_month = month(begin_date) - 1
		if li_month < 1 then
			li_month += 12
			li_year -= 1
		end if

		// The begin date is the first day of the first month
		ld_begin_date = date(li_year, li_month, 1)
		
		// The end date is one day before four months after the begin date
		li_month += 4
		if li_month > 12 then
			li_month -= 12
			li_year += 1
		end if
		ld_end_date = date(li_year, li_month, 1)
		ld_end_date = relativedate(ld_end_date, -1)		
	CASE "QUARTER"
		li_year = year(begin_date)
		li_month = month(begin_date)
		li_quarter = ((li_month - 1) / 3) - 1
		if li_quarter < 0 then
			li_quarter += 4
			li_year -= 1
		end if

		// The begin date is the first day of the first month in the quarter
		ld_begin_date = date(li_year, (li_quarter * 3) + 1, 1)
		
		// The end date is one day before one year after the begin date
		ld_end_date = date(li_year + 1, (li_quarter * 3) + 1, 1)
		ld_end_date = relativedate(ld_end_date, -1)
	CASE "YEAR"
		li_year = year(begin_date) - 1
		
		ld_begin_date = date(li_year, 1, 1)
		ld_end_date = date(li_year + 3, 12, 31)
END CHOOSE

refresh(ld_begin_date, ld_end_date)


end subroutine

public function integer initialize ();integer i
integer li_gap
long ll_rows

li_gap = (width - 12) / 4

ln_date_1.beginx = li_gap
ln_date_1.endx = ln_date_1.beginx
ln_date_1.beginy = 0
ln_date_1.endy = height

ln_date_2.beginx = (2 * li_gap) + 4
ln_date_2.endx = ln_date_2.beginx
ln_date_2.beginy = 0
ln_date_2.endy = height

ln_date_3.beginx = (3 * li_gap) + 8
ln_date_3.endx = ln_date_3.beginx
ln_date_3.beginy = 0
ln_date_3.endy = height

st_date_1.x = 0
st_date_1.width = li_gap
st_date_2.x = li_gap + 4
st_date_2.width = li_gap
st_date_3.x = (2 * li_gap) + 8
st_date_3.width = li_gap
st_date_4.x = (3 * li_gap) + 12
st_date_4.width = li_gap

st_date_1.y = (height - st_date_1.height) / 2
st_date_2.y = st_date_1.y
st_date_3.y = st_date_1.y
st_date_4.y = st_date_1.y


return 1


end function

on u_timeline_horizontal.create
this.st_date_4=create st_date_4
this.st_date_3=create st_date_3
this.st_date_2=create st_date_2
this.st_date_1=create st_date_1
this.ln_date_1=create ln_date_1
this.ln_date_2=create ln_date_2
this.ln_date_3=create ln_date_3
this.Control[]={this.st_date_4,&
this.st_date_3,&
this.st_date_2,&
this.st_date_1,&
this.ln_date_1,&
this.ln_date_2,&
this.ln_date_3}
end on

on u_timeline_horizontal.destroy
destroy(this.st_date_4)
destroy(this.st_date_3)
destroy(this.st_date_2)
destroy(this.st_date_1)
destroy(this.ln_date_1)
destroy(this.ln_date_2)
destroy(this.ln_date_3)
end on

type st_date_4 from statictext within u_timeline_horizontal
int X=1975
int Width=297
int Height=76
boolean Enabled=false
string Text="99/99"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=12632256
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_date_3 from statictext within u_timeline_horizontal
int X=1367
int Width=297
int Height=76
boolean Enabled=false
string Text="99/99"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=12632256
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_date_2 from statictext within u_timeline_horizontal
int X=773
int Width=297
int Height=76
boolean Enabled=false
string Text="99/99"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=12632256
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_date_1 from statictext within u_timeline_horizontal
int X=142
int Width=297
int Height=76
boolean Enabled=false
string Text="Dec 2000"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=12632256
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type ln_date_1 from line within u_timeline_horizontal
boolean Enabled=false
int BeginX=494
int BeginY=4
int EndX=494
int EndY=84
int LineThickness=4
long LineColor=33554432
end type

type ln_date_2 from line within u_timeline_horizontal
boolean Enabled=false
int BeginX=1115
int BeginY=8
int EndX=1115
int EndY=88
int LineThickness=4
long LineColor=33554432
end type

type ln_date_3 from line within u_timeline_horizontal
boolean Enabled=false
int BeginX=1710
int BeginY=8
int EndX=1710
int EndY=88
int LineThickness=4
long LineColor=33554432
end type

