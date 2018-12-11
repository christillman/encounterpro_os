$PBExportHeader$w_pop_please_wait.srw
forward
global type w_pop_please_wait from w_window_base
end type
type cb_cancelled from commandbutton within w_pop_please_wait
end type
type st_units_done from statictext within w_pop_please_wait
end type
type st_percentile from statictext within w_pop_please_wait
end type
type st_progress_fill from statictext within w_pop_please_wait
end type
type st_title from statictext within w_pop_please_wait
end type
type st_progress_back from statictext within w_pop_please_wait
end type
end forward

global type w_pop_please_wait from w_window_base
integer x = 361
integer y = 608
integer width = 2176
integer height = 796
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
windowtype windowtype = popup!
event close_window ( )
cb_cancelled cb_cancelled
st_units_done st_units_done
st_percentile st_percentile
st_progress_fill st_progress_fill
st_title st_title
st_progress_back st_progress_back
end type
global w_pop_please_wait w_pop_please_wait

type variables

long minvalue
long maxvalue
long value

long maxwidth

u_component_base_class caller

boolean new_window = true

w_window_base caller_window

end variables

forward prototypes
public subroutine set_progress (long pl_value)
public subroutine initialize (long pl_minvalue, long pl_maxvalue)
public subroutine initialize (long pl_minvalue, long pl_maxvalue, u_component_base_class puo_caller)
public subroutine bump_progress ()
public subroutine resize_and_move ()
public subroutine initialize (long pl_minvalue, long pl_maxvalue, w_window_base pw_caller_window)
end prototypes

event close_window();close(this)
return

end event

public subroutine set_progress (long pl_value);real lr_width
integer li_percentile

value = pl_value

st_units_done.text = string(value) + " of " + string(maxvalue)

if value >= maxvalue then
	st_progress_fill.width = maxwidth
	st_percentile.text = "100%"
	return
end if

if value <= minvalue then
	st_progress_fill.visible = false
	st_percentile.text = "0%"
	return
end if

lr_width = real(value - minvalue)/real(maxvalue - minvalue)

li_percentile = integer(lr_width * 100)
st_percentile.text = string(li_percentile) + "%"

lr_width = lr_width * real(maxwidth)

st_progress_fill.width = integer(lr_width)

if st_progress_fill.width >= 8 then
	st_progress_fill.visible = true
else
	st_progress_fill.visible = false
end if


end subroutine

public subroutine initialize (long pl_minvalue, long pl_maxvalue);u_component_base_class luo_caller

setnull(luo_caller)

initialize(pl_minvalue, pl_maxvalue, luo_caller)

end subroutine

public subroutine initialize (long pl_minvalue, long pl_maxvalue, u_component_base_class puo_caller);minvalue = pl_minvalue
maxvalue = pl_maxvalue

maxwidth = st_progress_back.width - 8

st_progress_back.visible = true
st_progress_fill.visible = true
st_percentile.visible = true

set_progress(minvalue)

if isvalid(puo_caller) and not isnull(puo_caller) then
	cb_cancelled.visible = true
	caller = puo_caller
else
	cb_cancelled.visible = false
	setnull(caller)
end if



end subroutine

public subroutine bump_progress ();set_progress(value + 1)

end subroutine

public subroutine resize_and_move ();
st_progress_back.visible = false
st_progress_fill.visible = false
st_percentile.visible = false
cb_cancelled.visible = false


end subroutine

public subroutine initialize (long pl_minvalue, long pl_maxvalue, w_window_base pw_caller_window);minvalue = pl_minvalue
maxvalue = pl_maxvalue

maxwidth = st_progress_back.width - 8

st_progress_back.visible = true
st_progress_fill.visible = true
st_percentile.visible = true

set_progress(minvalue)

if isvalid(pw_caller_window) and not isnull(pw_caller_window) then
	cb_cancelled.visible = true
	caller_window = pw_caller_window
else
	cb_cancelled.visible = false
	setnull(caller_window)
end if



end subroutine

on w_pop_please_wait.create
int iCurrent
call super::create
this.cb_cancelled=create cb_cancelled
this.st_units_done=create st_units_done
this.st_percentile=create st_percentile
this.st_progress_fill=create st_progress_fill
this.st_title=create st_title
this.st_progress_back=create st_progress_back
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancelled
this.Control[iCurrent+2]=this.st_units_done
this.Control[iCurrent+3]=this.st_percentile
this.Control[iCurrent+4]=this.st_progress_fill
this.Control[iCurrent+5]=this.st_title
this.Control[iCurrent+6]=this.st_progress_back
end on

on w_pop_please_wait.destroy
call super::destroy
destroy(this.cb_cancelled)
destroy(this.st_units_done)
destroy(this.st_percentile)
destroy(this.st_progress_fill)
destroy(this.st_title)
destroy(this.st_progress_back)
end on

event open;call super::open;
st_progress_back.visible = false
st_progress_fill.visible = false
st_percentile.visible = false
cb_cancelled.visible = false

setnull(caller_window)
setnull(caller)

if isvalid(main_window) and not isnull(main_window) then
	x = main_window.x + ((main_window.width - width) / 2)
	y = main_window.y + ((main_window.height - height) / 2)
end if


end event

type pb_epro_help from w_window_base`pb_epro_help within w_pop_please_wait
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_pop_please_wait
end type

type cb_cancelled from commandbutton within w_pop_please_wait
integer x = 901
integer y = 632
integer width = 393
integer height = 108
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
end type

event clicked;if not isnull(caller) and isvalid(caller) then
	caller.triggerevent("cancelled")
end if

if not isnull(caller_window) and isvalid(caller_window) then
	caller_window.triggerevent("cancelled")
end if


end event

type st_units_done from statictext within w_pop_please_wait
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
long backcolor = 33538240
boolean enabled = false
boolean focusrectangle = false
end type

type st_percentile from statictext within w_pop_please_wait
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
long backcolor = 33538240
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type st_progress_fill from statictext within w_pop_please_wait
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

type st_title from statictext within w_pop_please_wait
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
long backcolor = 33538240
boolean enabled = false
string text = "Processing... Please Wait"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_progress_back from statictext within w_pop_please_wait
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

