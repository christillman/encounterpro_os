HA$PBExportHeader$u_treatments_timeline.sru
forward
global type u_treatments_timeline from UserObject
end type
type st_problem_end from statictext within u_treatments_timeline
end type
type st_problem_begin from statictext within u_treatments_timeline
end type
type st_date_4 from statictext within u_treatments_timeline
end type
type st_date_3 from statictext within u_treatments_timeline
end type
type st_date_2 from statictext within u_treatments_timeline
end type
type st_line_59 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_58 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_57 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_56 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_55 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_54 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_53 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_52 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_51 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_50 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_49 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_40 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_39 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_38 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_37 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_36 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_35 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_34 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_33 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_32 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_31 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_30 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_29 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_12 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_11 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_10 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_9 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_8 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_7 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_6 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_5 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_4 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_3 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_2 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_1 from u_st_treatment_line within u_treatments_timeline
end type
type st_date_1 from statictext within u_treatments_timeline
end type
type ln_divider from line within u_treatments_timeline
end type
type st_line_47 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_46 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_45 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_44 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_43 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_42 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_41 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_28 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_27 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_26 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_25 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_24 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_23 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_22 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_21 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_20 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_19 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_18 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_17 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_16 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_15 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_14 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_13 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_48 from u_st_treatment_line within u_treatments_timeline
end type
type st_line_60 from u_st_treatment_line within u_treatments_timeline
end type
type ln_date_1 from line within u_treatments_timeline
end type
type ln_date_2 from line within u_treatments_timeline
end type
type ln_date_3 from line within u_treatments_timeline
end type
type st_today from statictext within u_treatments_timeline
end type
type st_vertical from statictext within u_treatments_timeline
end type
end forward

global type u_treatments_timeline from UserObject
int Width=2318
int Height=432
boolean Border=true
long BackColor=12632256
long PictureMaskColor=536870912
long TabTextColor=33554432
long TabBackColor=67108864
event clicked pbm_lbuttonclk
event date_selected ( date date_selected )
event treatments_selected ( date date_selected,  str_treatment_description current_treatments[] )
event date_range_changed ( date new_begin_date,  date new_end_date )
st_problem_end st_problem_end
st_problem_begin st_problem_begin
st_date_4 st_date_4
st_date_3 st_date_3
st_date_2 st_date_2
st_line_59 st_line_59
st_line_58 st_line_58
st_line_57 st_line_57
st_line_56 st_line_56
st_line_55 st_line_55
st_line_54 st_line_54
st_line_53 st_line_53
st_line_52 st_line_52
st_line_51 st_line_51
st_line_50 st_line_50
st_line_49 st_line_49
st_line_40 st_line_40
st_line_39 st_line_39
st_line_38 st_line_38
st_line_37 st_line_37
st_line_36 st_line_36
st_line_35 st_line_35
st_line_34 st_line_34
st_line_33 st_line_33
st_line_32 st_line_32
st_line_31 st_line_31
st_line_30 st_line_30
st_line_29 st_line_29
st_line_12 st_line_12
st_line_11 st_line_11
st_line_10 st_line_10
st_line_9 st_line_9
st_line_8 st_line_8
st_line_7 st_line_7
st_line_6 st_line_6
st_line_5 st_line_5
st_line_4 st_line_4
st_line_3 st_line_3
st_line_2 st_line_2
st_line_1 st_line_1
st_date_1 st_date_1
ln_divider ln_divider
st_line_47 st_line_47
st_line_46 st_line_46
st_line_45 st_line_45
st_line_44 st_line_44
st_line_43 st_line_43
st_line_42 st_line_42
st_line_41 st_line_41
st_line_28 st_line_28
st_line_27 st_line_27
st_line_26 st_line_26
st_line_25 st_line_25
st_line_24 st_line_24
st_line_23 st_line_23
st_line_22 st_line_22
st_line_21 st_line_21
st_line_20 st_line_20
st_line_19 st_line_19
st_line_18 st_line_18
st_line_17 st_line_17
st_line_16 st_line_16
st_line_15 st_line_15
st_line_14 st_line_14
st_line_13 st_line_13
st_line_48 st_line_48
st_line_60 st_line_60
ln_date_1 ln_date_1
ln_date_2 ln_date_2
ln_date_3 ln_date_3
st_today st_today
st_vertical st_vertical
end type
global u_treatments_timeline u_treatments_timeline

type variables
long problem_id
date problem_begin_date
date problem_end_date

u_ds_data treatment_types

date begin_date
date end_date
long total_days
string date_unit

long treatment_count
str_treatment_description treatments[]

long treatment_line_count
u_st_treatment_line treatment_lines[]

integer stack_height = 12

integer line_height = 50

integer timeline_y = 80

integer color_count
long line_colors[]

end variables

forward prototypes
public function integer initialize (long pl_problem_id)
private function integer refresh (date pd_begin_date, date pd_end_date)
public subroutine set_months (date pd_date)
public subroutine set_quarters (date pd_date)
public subroutine set_years (date pd_date)
public subroutine scroll_left ()
public subroutine scroll_right ()
public subroutine set_treatment_type (string ps_treatment_type, boolean pb_display)
public function boolean is_displayed (string ps_treatment_type)
public function integer initialize ()
private function integer initialize (string ls_treatment_filter)
end prototypes

event clicked;long ll_days
date ld_date_selected
str_treatment_description lstra_treatments[]
integer i, j

// Calculate the clicked date
ll_days = (real(xpos) / real(width)) * total_days

ld_date_selected = relativedate(begin_date, ll_days)

// Build an array of all treatments visible on that date
j = 0

for i = 1 to treatment_line_count
	if treatment_lines[i].visible &
	 and treatment_lines[i].x <= xpos &
	 and (treatment_lines[i].x + treatment_lines[i].width) >= xpos then
		j += 1
		lstra_treatments[j] = treatment_lines[i].treatment
		lstra_treatments[j].color = treatment_lines[i].backcolor
	end if
next

// Show the vertical line on the selected date
if xpos < 6 then
	st_vertical.x = 0
else
	st_vertical.x = xpos - 6
end if
st_vertical.visible = true

// Trigger the appropriate event so the parent can do something
if ypos <= ln_divider.beginy then
	this.event TRIGGER date_selected(ld_date_selected)
else
	this.event TRIGGER treatments_selected(ld_date_selected, lstra_treatments)
end if

// Hide the vertical line
st_vertical.visible = false



end event

public function integer initialize (long pl_problem_id);string ls_filter
integer li_min_diagnoses_sequence
integer li_max_diagnoses_sequence
datetime ldt_begin_date
datetime ldt_end_date

problem_id = pl_problem_id

ls_filter = "problem_id=" + string(problem_id)

// Select the min and max diagnosis_sequence and dates
SELECT min(diagnosis_sequence), max(diagnosis_sequence), min(begin_date), max(end_date)
INTO :li_min_diagnoses_sequence, :li_max_diagnoses_sequence, :ldt_begin_date, :ldt_end_date
FROM p_Assessment
WHERE cpr_id = :current_patient.cpr_id
AND problem_id = :pl_problem_id;
if not tf_check() then return -1

// If there is more than one diagnosis_sequence, then get the max end_date from the last record
if li_min_diagnoses_sequence <> li_max_diagnoses_sequence then
	SELECT end_date
	INTO :ldt_end_date
	FROM p_Assessment
	WHERE cpr_id = :current_patient.cpr_id
	AND problem_id = :pl_problem_id
	AND diagnosis_sequence = :li_max_diagnoses_sequence;
	if not tf_check() then return -1
end if

problem_begin_date = date(ldt_begin_date)
problem_end_date = date(ldt_end_date)

return initialize(ls_filter)



end function

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

// Initialize variables
li_line_count = 0
li_color = 1
for i = 1 to stack_height
	lia_stack[i] = 0
next

// Make all the lines invisible
for i = 1 to treatment_line_count
	treatment_lines[i].visible = false
next

for i = 1 to treatment_count
	// Don't display if it wasn't active during the displayed date range
	if isnull(treatments[i].end_date) then
		// Treatments with no end date appear to end today
		if today() <= begin_date then continue
	else
		if date(treatments[i].end_date) <= begin_date then continue
	end if
	if date(treatments[i].begin_date) >= end_date then continue
	
	// Don't display if the treatment type isn't set to display
	if not is_displayed(treatments[i].treatment_type) then continue
	
	// Don't display if the treatment didn't last more than one day
	if date(treatments[i].begin_date) >= date(treatments[i].end_date) then continue
	
	// Make sure we don't exceed the available lines.
	li_line_count += 1
	if li_line_count > treatment_line_count then
		log.log(this, "refresh()", "Displayable treatments exceeded max treatment lines (" + string(treatment_line_count) + ")", 3)
		exit
	end if
	luo_line = treatment_lines[li_line_count]
	
	// Now place the line and set its color
	// First, find it's stack index
	j = 1
	DO
		// If the stack height is currently unoccupied, then use it
		if lia_stack[j] = 0 then exit
		
		// If the stack height is occupied, but doesn't overlap, then use it
		if date(treatments[i].begin_date) >= date(treatments[lia_stack[j]].end_date) then exit
		if date(treatments[i].end_date) <= date(treatments[lia_stack[j]].begin_date) then exit
		
		// Try the next stack height
		j += 1
	LOOP WHILE j <= stack_height
	
	if j > stack_height then
		log.log(this, "refresh()", "Maximum stack height exceeded (" + string(stack_height) + ")", 3)
		continue
	end if
	
	// If we get here, then we have a treatment, a treatment line and a stack height, so size and
	// position the treatment line
	
	// Save the treatment in the stack array and the line object
	lia_stack[j] = i
	luo_line.treatment = treatments[i]
	luo_line.text = treatments[i].treatment_description
	
	// Calculate the size and position
	ll_begin_days = daysafter(begin_date, date(treatments[i].begin_date))
	if isnull(treatments[i].end_date) then
		ll_end_days = daysafter(begin_date, today())
		if ll_end_days > total_days then ll_end_days = total_days
	else
		ll_end_days = daysafter(pd_begin_date, date(treatments[i].end_date))
	end if
	ll_x = (real(ll_begin_days) / real(total_days)) * width
	ll_y = timeline_y + ((j - 1) * line_height)
	luo_line.height = line_height
	luo_line.width = (real(ll_end_days - ll_begin_days) / real(total_days)) * width
	luo_line.move(ll_x, ll_y)
	
	// Now color the line
	li_color += 1
	if li_color > color_count then li_color = 1
	luo_line.color_index = li_color
	luo_line.backcolor = line_colors[li_color]
	
next

// Now make the used lines visible
for i = 1 to li_line_count
	treatment_lines[i].visible = true
next

// Position the "Today" vertical bar
ld_temp = today()
if ld_temp >= begin_date and ld_temp < end_date then
	ll_begin_days = daysafter(begin_date, ld_temp)
	ll_x = (real(ll_begin_days) / real(total_days)) * width
	if ll_x + st_today.width > width then ll_x = width - st_today.width
	ll_y = timeline_y
	st_today.move(ll_x, ll_y)
	st_today.visible = true
	st_today.setposition(ToTop!)
else
	st_today.visible = false
end if

// Position the "Started" vertical bar
if problem_begin_date >= begin_date and problem_begin_date < end_date then
	ll_begin_days = daysafter(begin_date, problem_begin_date)
	ll_x = ((real(ll_begin_days) / real(total_days)) * width) - st_problem_begin.width
	if ll_x + st_problem_begin.width > width then ll_x = width - st_problem_begin.width
	ll_y = timeline_y
	st_problem_begin.move(ll_x, ll_y)
	st_problem_begin.visible = true
	st_problem_begin.setposition(ToTop!)
else
	st_problem_begin.visible = false
end if

// Position the "Stopped" vertical bar
if problem_end_date >= begin_date and problem_end_date < end_date then
	ll_begin_days = daysafter(begin_date, problem_end_date)
	ll_x = (real(ll_begin_days) / real(total_days)) * width
	if ll_x + st_problem_end.width > width then ll_x = width - st_problem_end.width
	ll_y = timeline_y
	st_problem_end.move(ll_x, ll_y)
	st_problem_end.visible = true
	st_problem_end.setposition(ToTop!)
else
	st_problem_end.visible = false
end if

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

public subroutine set_treatment_type (string ps_treatment_type, boolean pb_display);string ls_find
long i
long ll_rowcount

ll_rowcount = treatment_types.rowcount()

for i = 1 to ll_rowcount
	if ps_treatment_type = treatment_types.object.treatment_type[i] then
		if pb_display then
			treatment_types.object.selected_flag[i] = 1
		else
			treatment_types.object.selected_flag[i] = 0
		end if
	end if
next
			

end subroutine

public function boolean is_displayed (string ps_treatment_type);string ls_find
long i
long ll_rowcount

ll_rowcount = treatment_types.rowcount()

for i = 1 to ll_rowcount
	if ps_treatment_type = treatment_types.object.treatment_type[i] then
		if treatment_types.object.selected_flag[i] = 1 then
			return true
		else
			return false
		end if
	end if
next
			
return false

end function

public function integer initialize ();string ls_filter

// This filter always resolves to true, so all treatments will be displayed
ls_filter = "1=1"

return initialize(ls_filter)



end function

private function integer initialize (string ls_treatment_filter);integer i
integer li_gap
long ll_rows

treatment_types = CREATE u_ds_data
treatment_types.set_dataobject("dw_treatment_type_select")
ll_rows = treatment_types.retrieve()
if ll_rows <= 0 then
	log.log(this, "initialize()", "Error getting treatment types", 4)
	return -1
end if

li_gap = (width - 12) / 4

ln_date_1.beginx = li_gap
ln_date_1.endx = ln_date_1.beginx
ln_date_1.beginy = 0
ln_date_1.endy = timeline_y - 4

ln_date_2.beginx = (2 * li_gap) + 4
ln_date_2.endx = ln_date_2.beginx
ln_date_2.beginy = 0
ln_date_2.endy = timeline_y - 4

ln_date_3.beginx = (3 * li_gap) + 8
ln_date_3.endx = ln_date_3.beginx
ln_date_3.beginy = 0
ln_date_3.endy = timeline_y - 4

st_date_1.x = 0
st_date_1.width = li_gap
st_date_2.x = li_gap + 4
st_date_2.width = li_gap
st_date_3.x = (2 * li_gap) + 8
st_date_3.width = li_gap
st_date_4.x = (3 * li_gap) + 12
st_date_4.width = li_gap

st_date_1.y = 0
st_date_2.y = 0
st_date_3.y = 0
st_date_4.y = 0

treatment_count = current_patient.treatments.get_treatments(ls_treatment_filter, treatments)

// Initialize 40 lines
treatment_line_count = 60
treatment_lines[1] = st_line_1
treatment_lines[2] = st_line_2
treatment_lines[3] = st_line_3
treatment_lines[4] = st_line_4
treatment_lines[5] = st_line_5
treatment_lines[6] = st_line_6
treatment_lines[7] = st_line_7
treatment_lines[8] = st_line_8
treatment_lines[9] = st_line_9
treatment_lines[10] = st_line_10
treatment_lines[11] = st_line_11
treatment_lines[12] = st_line_12
treatment_lines[13] = st_line_13
treatment_lines[14] = st_line_14
treatment_lines[15] = st_line_15
treatment_lines[16] = st_line_16
treatment_lines[17] = st_line_17
treatment_lines[18] = st_line_18
treatment_lines[19] = st_line_19
treatment_lines[20] = st_line_20
treatment_lines[21] = st_line_21
treatment_lines[22] = st_line_22
treatment_lines[23] = st_line_23
treatment_lines[24] = st_line_24
treatment_lines[25] = st_line_25
treatment_lines[26] = st_line_26
treatment_lines[27] = st_line_27
treatment_lines[28] = st_line_28
treatment_lines[29] = st_line_29
treatment_lines[30] = st_line_30
treatment_lines[31] = st_line_31
treatment_lines[32] = st_line_32
treatment_lines[33] = st_line_33
treatment_lines[34] = st_line_34
treatment_lines[35] = st_line_35
treatment_lines[36] = st_line_36
treatment_lines[37] = st_line_37
treatment_lines[38] = st_line_38
treatment_lines[39] = st_line_39
treatment_lines[40] = st_line_40
treatment_lines[41] = st_line_41
treatment_lines[42] = st_line_42
treatment_lines[43] = st_line_43
treatment_lines[44] = st_line_44
treatment_lines[45] = st_line_45
treatment_lines[46] = st_line_46
treatment_lines[47] = st_line_47
treatment_lines[48] = st_line_48
treatment_lines[49] = st_line_49
treatment_lines[50] = st_line_50
treatment_lines[51] = st_line_51
treatment_lines[52] = st_line_52
treatment_lines[53] = st_line_53
treatment_lines[54] = st_line_54
treatment_lines[55] = st_line_55
treatment_lines[56] = st_line_56
treatment_lines[57] = st_line_57
treatment_lines[58] = st_line_58
treatment_lines[59] = st_line_59
treatment_lines[60] = st_line_60

// Initialize the colors
color_count = 12
line_colors[1] = rgb(255,128,128)
line_colors[2] = rgb(128,255,128)
line_colors[3] = rgb(128,128,255)
line_colors[4] = rgb(255,255,128)
line_colors[5] = rgb(255,128,255)
line_colors[6] = rgb(128,255,255)
line_colors[7] = rgb(255,0,0)
line_colors[8] = rgb(0,255,0)
line_colors[9] = rgb(0,0,255)
line_colors[10] = rgb(255,255,0)
line_colors[11] = rgb(255,0,255)
line_colors[12] = rgb(0,255,255)


// Make the lines invisible
for i = 1 to treatment_line_count
	treatment_lines[i].visible = false
next

st_vertical.visible = false
st_today.visible = false

return 1


end function

on u_treatments_timeline.create
this.st_problem_end=create st_problem_end
this.st_problem_begin=create st_problem_begin
this.st_date_4=create st_date_4
this.st_date_3=create st_date_3
this.st_date_2=create st_date_2
this.st_line_59=create st_line_59
this.st_line_58=create st_line_58
this.st_line_57=create st_line_57
this.st_line_56=create st_line_56
this.st_line_55=create st_line_55
this.st_line_54=create st_line_54
this.st_line_53=create st_line_53
this.st_line_52=create st_line_52
this.st_line_51=create st_line_51
this.st_line_50=create st_line_50
this.st_line_49=create st_line_49
this.st_line_40=create st_line_40
this.st_line_39=create st_line_39
this.st_line_38=create st_line_38
this.st_line_37=create st_line_37
this.st_line_36=create st_line_36
this.st_line_35=create st_line_35
this.st_line_34=create st_line_34
this.st_line_33=create st_line_33
this.st_line_32=create st_line_32
this.st_line_31=create st_line_31
this.st_line_30=create st_line_30
this.st_line_29=create st_line_29
this.st_line_12=create st_line_12
this.st_line_11=create st_line_11
this.st_line_10=create st_line_10
this.st_line_9=create st_line_9
this.st_line_8=create st_line_8
this.st_line_7=create st_line_7
this.st_line_6=create st_line_6
this.st_line_5=create st_line_5
this.st_line_4=create st_line_4
this.st_line_3=create st_line_3
this.st_line_2=create st_line_2
this.st_line_1=create st_line_1
this.st_date_1=create st_date_1
this.ln_divider=create ln_divider
this.st_line_47=create st_line_47
this.st_line_46=create st_line_46
this.st_line_45=create st_line_45
this.st_line_44=create st_line_44
this.st_line_43=create st_line_43
this.st_line_42=create st_line_42
this.st_line_41=create st_line_41
this.st_line_28=create st_line_28
this.st_line_27=create st_line_27
this.st_line_26=create st_line_26
this.st_line_25=create st_line_25
this.st_line_24=create st_line_24
this.st_line_23=create st_line_23
this.st_line_22=create st_line_22
this.st_line_21=create st_line_21
this.st_line_20=create st_line_20
this.st_line_19=create st_line_19
this.st_line_18=create st_line_18
this.st_line_17=create st_line_17
this.st_line_16=create st_line_16
this.st_line_15=create st_line_15
this.st_line_14=create st_line_14
this.st_line_13=create st_line_13
this.st_line_48=create st_line_48
this.st_line_60=create st_line_60
this.ln_date_1=create ln_date_1
this.ln_date_2=create ln_date_2
this.ln_date_3=create ln_date_3
this.st_today=create st_today
this.st_vertical=create st_vertical
this.Control[]={this.st_problem_end,&
this.st_problem_begin,&
this.st_date_4,&
this.st_date_3,&
this.st_date_2,&
this.st_line_59,&
this.st_line_58,&
this.st_line_57,&
this.st_line_56,&
this.st_line_55,&
this.st_line_54,&
this.st_line_53,&
this.st_line_52,&
this.st_line_51,&
this.st_line_50,&
this.st_line_49,&
this.st_line_40,&
this.st_line_39,&
this.st_line_38,&
this.st_line_37,&
this.st_line_36,&
this.st_line_35,&
this.st_line_34,&
this.st_line_33,&
this.st_line_32,&
this.st_line_31,&
this.st_line_30,&
this.st_line_29,&
this.st_line_12,&
this.st_line_11,&
this.st_line_10,&
this.st_line_9,&
this.st_line_8,&
this.st_line_7,&
this.st_line_6,&
this.st_line_5,&
this.st_line_4,&
this.st_line_3,&
this.st_line_2,&
this.st_line_1,&
this.st_date_1,&
this.ln_divider,&
this.st_line_47,&
this.st_line_46,&
this.st_line_45,&
this.st_line_44,&
this.st_line_43,&
this.st_line_42,&
this.st_line_41,&
this.st_line_28,&
this.st_line_27,&
this.st_line_26,&
this.st_line_25,&
this.st_line_24,&
this.st_line_23,&
this.st_line_22,&
this.st_line_21,&
this.st_line_20,&
this.st_line_19,&
this.st_line_18,&
this.st_line_17,&
this.st_line_16,&
this.st_line_15,&
this.st_line_14,&
this.st_line_13,&
this.st_line_48,&
this.st_line_60,&
this.ln_date_1,&
this.ln_date_2,&
this.ln_date_3,&
this.st_today,&
this.st_vertical}
end on

on u_treatments_timeline.destroy
destroy(this.st_problem_end)
destroy(this.st_problem_begin)
destroy(this.st_date_4)
destroy(this.st_date_3)
destroy(this.st_date_2)
destroy(this.st_line_59)
destroy(this.st_line_58)
destroy(this.st_line_57)
destroy(this.st_line_56)
destroy(this.st_line_55)
destroy(this.st_line_54)
destroy(this.st_line_53)
destroy(this.st_line_52)
destroy(this.st_line_51)
destroy(this.st_line_50)
destroy(this.st_line_49)
destroy(this.st_line_40)
destroy(this.st_line_39)
destroy(this.st_line_38)
destroy(this.st_line_37)
destroy(this.st_line_36)
destroy(this.st_line_35)
destroy(this.st_line_34)
destroy(this.st_line_33)
destroy(this.st_line_32)
destroy(this.st_line_31)
destroy(this.st_line_30)
destroy(this.st_line_29)
destroy(this.st_line_12)
destroy(this.st_line_11)
destroy(this.st_line_10)
destroy(this.st_line_9)
destroy(this.st_line_8)
destroy(this.st_line_7)
destroy(this.st_line_6)
destroy(this.st_line_5)
destroy(this.st_line_4)
destroy(this.st_line_3)
destroy(this.st_line_2)
destroy(this.st_line_1)
destroy(this.st_date_1)
destroy(this.ln_divider)
destroy(this.st_line_47)
destroy(this.st_line_46)
destroy(this.st_line_45)
destroy(this.st_line_44)
destroy(this.st_line_43)
destroy(this.st_line_42)
destroy(this.st_line_41)
destroy(this.st_line_28)
destroy(this.st_line_27)
destroy(this.st_line_26)
destroy(this.st_line_25)
destroy(this.st_line_24)
destroy(this.st_line_23)
destroy(this.st_line_22)
destroy(this.st_line_21)
destroy(this.st_line_20)
destroy(this.st_line_19)
destroy(this.st_line_18)
destroy(this.st_line_17)
destroy(this.st_line_16)
destroy(this.st_line_15)
destroy(this.st_line_14)
destroy(this.st_line_13)
destroy(this.st_line_48)
destroy(this.st_line_60)
destroy(this.ln_date_1)
destroy(this.ln_date_2)
destroy(this.ln_date_3)
destroy(this.st_today)
destroy(this.st_vertical)
end on

type st_problem_end from statictext within u_treatments_timeline
int X=1477
int Y=104
int Width=32
int Height=700
boolean Enabled=false
boolean BringToTop=true
string Text="s t o p p e d"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=8421504
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_problem_begin from statictext within u_treatments_timeline
int X=1312
int Y=140
int Width=32
int Height=700
boolean Enabled=false
boolean BringToTop=true
string Text="s t a r t e d"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=8421504
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_date_4 from statictext within u_treatments_timeline
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

type st_date_3 from statictext within u_treatments_timeline
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

type st_date_2 from statictext within u_treatments_timeline
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

type st_line_59 from u_st_treatment_line within u_treatments_timeline
int X=119
int Y=184
boolean Enabled=false
long BackColor=12632256
end type

type st_line_58 from u_st_treatment_line within u_treatments_timeline
int X=119
int Y=184
boolean Enabled=false
long BackColor=12632256
end type

type st_line_57 from u_st_treatment_line within u_treatments_timeline
int X=119
int Y=184
boolean Enabled=false
long BackColor=12632256
end type

type st_line_56 from u_st_treatment_line within u_treatments_timeline
int X=119
int Y=184
boolean Enabled=false
long BackColor=12632256
end type

type st_line_55 from u_st_treatment_line within u_treatments_timeline
int X=119
int Y=184
boolean Enabled=false
long BackColor=12632256
end type

type st_line_54 from u_st_treatment_line within u_treatments_timeline
int X=119
int Y=184
boolean Enabled=false
long BackColor=12632256
end type

type st_line_53 from u_st_treatment_line within u_treatments_timeline
int X=119
int Y=184
boolean Enabled=false
long BackColor=12632256
end type

type st_line_52 from u_st_treatment_line within u_treatments_timeline
int X=119
int Y=184
boolean Enabled=false
long BackColor=12632256
end type

type st_line_51 from u_st_treatment_line within u_treatments_timeline
int X=119
int Y=184
boolean Enabled=false
long BackColor=12632256
end type

type st_line_50 from u_st_treatment_line within u_treatments_timeline
int X=119
int Y=184
boolean Enabled=false
long BackColor=12632256
end type

type st_line_49 from u_st_treatment_line within u_treatments_timeline
int X=119
int Y=184
boolean Enabled=false
long BackColor=12632256
end type

type st_line_40 from u_st_treatment_line within u_treatments_timeline
int X=119
int Y=184
boolean Enabled=false
long BackColor=12632256
end type

type st_line_39 from u_st_treatment_line within u_treatments_timeline
int X=119
int Y=184
boolean Enabled=false
long BackColor=12632256
end type

type st_line_38 from u_st_treatment_line within u_treatments_timeline
int X=119
int Y=184
boolean Enabled=false
long BackColor=12632256
end type

type st_line_37 from u_st_treatment_line within u_treatments_timeline
int X=119
int Y=184
boolean Enabled=false
long BackColor=12632256
end type

type st_line_36 from u_st_treatment_line within u_treatments_timeline
int X=119
int Y=184
boolean Enabled=false
long BackColor=12632256
end type

type st_line_35 from u_st_treatment_line within u_treatments_timeline
int X=119
int Y=184
boolean Enabled=false
long BackColor=12632256
end type

type st_line_34 from u_st_treatment_line within u_treatments_timeline
int X=119
int Y=184
boolean Enabled=false
long BackColor=12632256
end type

type st_line_33 from u_st_treatment_line within u_treatments_timeline
int X=119
int Y=184
boolean Enabled=false
long BackColor=12632256
end type

type st_line_32 from u_st_treatment_line within u_treatments_timeline
int X=119
int Y=184
boolean Enabled=false
long BackColor=12632256
end type

type st_line_31 from u_st_treatment_line within u_treatments_timeline
int X=119
int Y=184
boolean Enabled=false
long BackColor=12632256
end type

type st_line_30 from u_st_treatment_line within u_treatments_timeline
int X=119
int Y=184
boolean Enabled=false
long BackColor=12632256
end type

type st_line_29 from u_st_treatment_line within u_treatments_timeline
int X=119
int Y=184
boolean Enabled=false
long BackColor=12632256
end type

type st_line_12 from u_st_treatment_line within u_treatments_timeline
int X=119
int Y=184
boolean Enabled=false
long BackColor=12632256
end type

type st_line_11 from u_st_treatment_line within u_treatments_timeline
int X=119
int Y=184
boolean Enabled=false
long BackColor=12632256
end type

type st_line_10 from u_st_treatment_line within u_treatments_timeline
int X=119
int Y=184
boolean Enabled=false
long BackColor=12632256
end type

type st_line_9 from u_st_treatment_line within u_treatments_timeline
int X=119
int Y=184
boolean Enabled=false
long BackColor=12632256
end type

type st_line_8 from u_st_treatment_line within u_treatments_timeline
int X=119
int Y=184
boolean Enabled=false
long BackColor=12632256
end type

type st_line_7 from u_st_treatment_line within u_treatments_timeline
int X=119
int Y=184
boolean Enabled=false
long BackColor=12632256
end type

type st_line_6 from u_st_treatment_line within u_treatments_timeline
int X=119
int Y=184
boolean Enabled=false
long BackColor=12632256
end type

type st_line_5 from u_st_treatment_line within u_treatments_timeline
int X=119
int Y=184
boolean Enabled=false
long BackColor=12632256
end type

type st_line_4 from u_st_treatment_line within u_treatments_timeline
int X=119
int Y=184
boolean Enabled=false
long BackColor=12632256
end type

type st_line_3 from u_st_treatment_line within u_treatments_timeline
int X=119
int Y=184
boolean Enabled=false
long BackColor=12632256
end type

type st_line_2 from u_st_treatment_line within u_treatments_timeline
int X=119
int Y=184
boolean Enabled=false
long BackColor=12632256
end type

type st_line_1 from u_st_treatment_line within u_treatments_timeline
int X=119
int Y=184
boolean Enabled=false
long BackColor=12632256
end type

type st_date_1 from statictext within u_treatments_timeline
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

type ln_divider from line within u_treatments_timeline
boolean Enabled=false
int BeginY=76
int EndX=3003
int EndY=76
int LineThickness=4
long LineColor=33554432
end type

type st_line_47 from u_st_treatment_line within u_treatments_timeline
int X=146
int Y=296
boolean Enabled=false
long BackColor=12632256
end type

type st_line_46 from u_st_treatment_line within u_treatments_timeline
int X=197
int Y=296
boolean Enabled=false
long BackColor=12632256
end type

type st_line_45 from u_st_treatment_line within u_treatments_timeline
int X=265
int Y=292
boolean Enabled=false
long BackColor=12632256
end type

type st_line_44 from u_st_treatment_line within u_treatments_timeline
int X=265
int Y=292
boolean Enabled=false
long BackColor=12632256
end type

type st_line_43 from u_st_treatment_line within u_treatments_timeline
int X=197
int Y=296
boolean Enabled=false
long BackColor=12632256
end type

type st_line_42 from u_st_treatment_line within u_treatments_timeline
int X=146
int Y=296
boolean Enabled=false
long BackColor=12632256
end type

type st_line_41 from u_st_treatment_line within u_treatments_timeline
int X=178
int Y=292
boolean Enabled=false
long BackColor=12632256
end type

type st_line_28 from u_st_treatment_line within u_treatments_timeline
int X=178
int Y=292
boolean Enabled=false
long BackColor=12632256
end type

type st_line_27 from u_st_treatment_line within u_treatments_timeline
int X=146
int Y=296
boolean Enabled=false
long BackColor=12632256
end type

type st_line_26 from u_st_treatment_line within u_treatments_timeline
int X=197
int Y=296
boolean Enabled=false
long BackColor=12632256
end type

type st_line_25 from u_st_treatment_line within u_treatments_timeline
int X=265
int Y=292
boolean Enabled=false
long BackColor=12632256
end type

type st_line_24 from u_st_treatment_line within u_treatments_timeline
int X=265
int Y=292
boolean Enabled=false
long BackColor=12632256
end type

type st_line_23 from u_st_treatment_line within u_treatments_timeline
int X=197
int Y=296
boolean Enabled=false
long BackColor=12632256
end type

type st_line_22 from u_st_treatment_line within u_treatments_timeline
int X=146
int Y=296
boolean Enabled=false
long BackColor=12632256
end type

type st_line_21 from u_st_treatment_line within u_treatments_timeline
int X=178
int Y=292
boolean Enabled=false
long BackColor=12632256
end type

type st_line_20 from u_st_treatment_line within u_treatments_timeline
int X=178
int Y=292
boolean Enabled=false
long BackColor=12632256
end type

type st_line_19 from u_st_treatment_line within u_treatments_timeline
int X=146
int Y=296
boolean Enabled=false
long BackColor=12632256
end type

type st_line_18 from u_st_treatment_line within u_treatments_timeline
int X=197
int Y=296
boolean Enabled=false
long BackColor=12632256
end type

type st_line_17 from u_st_treatment_line within u_treatments_timeline
int X=265
int Y=292
boolean Enabled=false
long BackColor=12632256
end type

type st_line_16 from u_st_treatment_line within u_treatments_timeline
int X=265
int Y=292
boolean Enabled=false
long BackColor=12632256
end type

type st_line_15 from u_st_treatment_line within u_treatments_timeline
int X=197
int Y=296
boolean Enabled=false
long BackColor=12632256
end type

type st_line_14 from u_st_treatment_line within u_treatments_timeline
int X=146
int Y=296
boolean Enabled=false
long BackColor=12632256
end type

type st_line_13 from u_st_treatment_line within u_treatments_timeline
int X=178
int Y=292
boolean Enabled=false
long BackColor=12632256
end type

type st_line_48 from u_st_treatment_line within u_treatments_timeline
int X=178
int Y=292
boolean Enabled=false
long BackColor=12632256
end type

type st_line_60 from u_st_treatment_line within u_treatments_timeline
int X=128
int Y=212
boolean Enabled=false
long BackColor=12632256
end type

type ln_date_1 from line within u_treatments_timeline
boolean Enabled=false
int BeginX=494
int BeginY=4
int EndX=494
int EndY=84
int LineThickness=4
long LineColor=33554432
end type

type ln_date_2 from line within u_treatments_timeline
boolean Enabled=false
int BeginX=1115
int BeginY=8
int EndX=1115
int EndY=88
int LineThickness=4
long LineColor=33554432
end type

type ln_date_3 from line within u_treatments_timeline
boolean Enabled=false
int BeginX=1710
int BeginY=8
int EndX=1710
int EndY=88
int LineThickness=4
long LineColor=33554432
end type

type st_today from statictext within u_treatments_timeline
int X=1202
int Y=80
int Width=32
int Height=700
boolean Enabled=false
boolean BringToTop=true
string Text="T o d a y"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=8421504
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_vertical from statictext within u_treatments_timeline
int X=498
int Y=80
int Width=14
int Height=700
boolean Enabled=false
boolean BringToTop=true
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=0
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

