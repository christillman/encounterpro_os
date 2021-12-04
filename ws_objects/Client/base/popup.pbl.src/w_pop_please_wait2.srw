$PBExportHeader$w_pop_please_wait2.srw
forward
global type w_pop_please_wait2 from w_window_base
end type
type st_progress_back_2 from statictext within w_pop_please_wait2
end type
type st_progress_fill_2 from statictext within w_pop_please_wait2
end type
type st_percentile_2 from statictext within w_pop_please_wait2
end type
type st_units_done_2 from statictext within w_pop_please_wait2
end type
type st_units_done_1 from statictext within w_pop_please_wait2
end type
type st_percentile_1 from statictext within w_pop_please_wait2
end type
type st_progress_fill_1 from statictext within w_pop_please_wait2
end type
type st_title from statictext within w_pop_please_wait2
end type
type st_progress_back_1 from statictext within w_pop_please_wait2
end type
end forward

global type w_pop_please_wait2 from w_window_base
integer x = 361
integer y = 608
integer width = 2176
integer height = 1004
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
windowtype windowtype = popup!
event close_window ( )
st_progress_back_2 st_progress_back_2
st_progress_fill_2 st_progress_fill_2
st_percentile_2 st_percentile_2
st_units_done_2 st_units_done_2
st_units_done_1 st_units_done_1
st_percentile_1 st_percentile_1
st_progress_fill_1 st_progress_fill_1
st_title st_title
st_progress_back_1 st_progress_back_1
end type
global w_pop_please_wait2 w_pop_please_wait2

type variables

// Max width for each progress bar.  Assumes all are same width
long maxwidth

// Arrays of progress status variables
long minvalue[]
long maxvalue[]
long value[]

// Arrays of controls for displaying progress bars
statictext units_done[]
statictext percentile[]
statictext progress_fill[]
statictext progress_back[]
integer max_display_controls

// list of callers
integer caller_count = 0
boolean caller_open[]
integer caller_progress[]
integer caller_progress_count = 0


end variables

forward prototypes
public subroutine close_caller (integer pi_index)
public function integer open_caller ()
public subroutine set_progress_bar (integer pi_index, long pl_currentvalue, long pl_maxvalue)
public subroutine set_progress_bar (integer pi_index, long pl_currentvalue)
public subroutine bump_progress (integer pi_index)
end prototypes

event close_window();close(this)
return

end event

public subroutine close_caller (integer pi_index);integer li_progress_index
integer i

// If this is the first caller or not a valid caller then close the window
if pi_index <= 1 or pi_index > caller_count or isnull(pi_index) then
	close(this)
	return
end if

caller_open[pi_index] = false

// Get the progress bar index
li_progress_index = caller_progress[pi_index]

// Now make the associated progress bar and all subordinate progress bars disappear
if li_progress_index > 0 and li_progress_index <= caller_progress_count then
	for i = li_progress_index to caller_progress_count
		units_done[i].visible = false
		percentile[i].visible = false
		progress_back[i].visible = false
		progress_fill[i].visible = false
	next
	
	// ... And reset and progress indexes for these progress bars
	for i = 1 to caller_count
		if caller_progress[i] >= li_progress_index then caller_progress[i] = 0
	next

	// ... And set the progress count to one less than the dissapearing progress bar
	caller_progress_count = li_progress_index - 1
end if

return

end subroutine

public function integer open_caller ();
caller_count += 1
caller_open[caller_count] = true
caller_progress[caller_count] = 0

return caller_count


end function

public subroutine set_progress_bar (integer pi_index, long pl_currentvalue, long pl_maxvalue);real lr_width
integer li_percentile
integer li_progress_index

// Make sure it's a valid index
if pi_index <= 0 or pi_index > caller_count or isnull(pi_index) then return

// Make sure caller is open
if not caller_open[pi_index] then return

// Get the progress bar index
li_progress_index = caller_progress[pi_index]

// If this is the first progress call for this caller, then set him up
if li_progress_index = 0 then
	// First make sure we have an available progress_bar
	if caller_progress_count >= max_display_controls then return
	
	caller_progress_count += 1
	li_progress_index = caller_progress_count
	caller_progress[pi_index] = li_progress_index
end if

minvalue[li_progress_index] = 0
maxvalue[li_progress_index] = pl_maxvalue
value[li_progress_index] = pl_currentvalue

// Don't go any further if there are no controls for this index
if li_progress_index > max_display_controls then return

// Make sure the appropriate controls are visible
units_done[li_progress_index].visible = true
percentile[li_progress_index].visible = true
progress_back[li_progress_index].visible = true
progress_fill[li_progress_index].visible = true


units_done[li_progress_index].text = string(value[li_progress_index]) + " of " + string(maxvalue[li_progress_index])

if value[li_progress_index] >= maxvalue[li_progress_index] then
	progress_fill[li_progress_index].width = maxwidth
	percentile[li_progress_index].text = "100%"
	return
end if

if value[li_progress_index] <= minvalue[li_progress_index] then
	progress_fill[li_progress_index].visible = false
	percentile[li_progress_index].text = "0%"
	return
end if

lr_width = real(value[li_progress_index] - minvalue[li_progress_index])/real(maxvalue[li_progress_index] - minvalue[li_progress_index])

li_percentile = integer(lr_width * 100)
percentile[li_progress_index].text = string(li_percentile) + "%"

lr_width = lr_width * real(maxwidth)

progress_fill[li_progress_index].width = integer(lr_width)

if progress_fill[li_progress_index].width >= 8 then
	progress_fill[li_progress_index].visible = true
else
	progress_fill[li_progress_index].visible = false
end if


end subroutine

public subroutine set_progress_bar (integer pi_index, long pl_currentvalue);integer li_progress_index

// Get the progress bar index
li_progress_index = caller_progress[pi_index]

if li_progress_index <= 0 or li_progress_index > max_display_controls then return

set_progress_bar(pi_index, pl_currentvalue, maxvalue[li_progress_index])

end subroutine

public subroutine bump_progress (integer pi_index);integer li_progress_index

// Get the progress bar index
li_progress_index = caller_progress[pi_index]

if li_progress_index <= 0 or li_progress_index > max_display_controls then return

set_progress_bar(pi_index, value[li_progress_index] + 1)

end subroutine

on w_pop_please_wait2.create
int iCurrent
call super::create
this.st_progress_back_2=create st_progress_back_2
this.st_progress_fill_2=create st_progress_fill_2
this.st_percentile_2=create st_percentile_2
this.st_units_done_2=create st_units_done_2
this.st_units_done_1=create st_units_done_1
this.st_percentile_1=create st_percentile_1
this.st_progress_fill_1=create st_progress_fill_1
this.st_title=create st_title
this.st_progress_back_1=create st_progress_back_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_progress_back_2
this.Control[iCurrent+2]=this.st_progress_fill_2
this.Control[iCurrent+3]=this.st_percentile_2
this.Control[iCurrent+4]=this.st_units_done_2
this.Control[iCurrent+5]=this.st_units_done_1
this.Control[iCurrent+6]=this.st_percentile_1
this.Control[iCurrent+7]=this.st_progress_fill_1
this.Control[iCurrent+8]=this.st_title
this.Control[iCurrent+9]=this.st_progress_back_1
end on

on w_pop_please_wait2.destroy
call super::destroy
destroy(this.st_progress_back_2)
destroy(this.st_progress_fill_2)
destroy(this.st_percentile_2)
destroy(this.st_units_done_2)
destroy(this.st_units_done_1)
destroy(this.st_percentile_1)
destroy(this.st_progress_fill_1)
destroy(this.st_title)
destroy(this.st_progress_back_1)
end on

event open;call super::open;

st_units_done_1.visible = false
st_percentile_1.visible = false
st_progress_back_1.visible = false
st_progress_fill_1.visible = false

units_done[1] = st_units_done_1
percentile[1] = st_percentile_1
progress_back[1] = st_progress_back_1
progress_fill[1] = st_progress_fill_1


st_units_done_2.visible = false
st_percentile_2.visible = false
st_progress_back_2.visible = false
st_progress_fill_2.visible = false

units_done[2] = st_units_done_2
percentile[2] = st_percentile_2
progress_back[2] = st_progress_back_2
progress_fill[2] = st_progress_fill_2

max_display_controls = 2


maxwidth = st_progress_back_1.width - 8


if isvalid(main_window) and not isnull(main_window) then
	x = main_window.x + ((main_window.width - width) / 2)
	y = main_window.y + ((main_window.height - height) / 2)
end if

end event

type pb_epro_help from w_window_base`pb_epro_help within w_pop_please_wait2
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_pop_please_wait2
end type

type st_progress_back_2 from statictext within w_pop_please_wait2
integer x = 352
integer y = 760
integer width = 1495
integer height = 92
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "HourGlass!"
long backcolor = 12632256
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type st_progress_fill_2 from statictext within w_pop_please_wait2
integer x = 357
integer y = 764
integer width = 247
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "HourGlass!"
long backcolor = 16711680
boolean enabled = false
boolean focusrectangle = false
end type

type st_percentile_2 from statictext within w_pop_please_wait2
integer x = 923
integer y = 672
integer width = 347
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "HourGlass!"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type st_units_done_2 from statictext within w_pop_please_wait2
integer x = 357
integer y = 672
integer width = 507
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "HourGlass!"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
boolean focusrectangle = false
end type

type st_units_done_1 from statictext within w_pop_please_wait2
integer x = 357
integer y = 404
integer width = 507
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "HourGlass!"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
boolean focusrectangle = false
end type

type st_percentile_1 from statictext within w_pop_please_wait2
integer x = 923
integer y = 404
integer width = 347
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "HourGlass!"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type st_progress_fill_1 from statictext within w_pop_please_wait2
integer x = 357
integer y = 496
integer width = 247
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "HourGlass!"
long backcolor = 16711680
boolean enabled = false
boolean focusrectangle = false
end type

type st_title from statictext within w_pop_please_wait2
integer x = 9
integer y = 140
integer width = 2176
integer height = 212
integer textsize = -24
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Processing... Please Wait"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_progress_back_1 from statictext within w_pop_please_wait2
integer x = 352
integer y = 492
integer width = 1495
integer height = 92
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "HourGlass!"
long backcolor = 12632256
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

