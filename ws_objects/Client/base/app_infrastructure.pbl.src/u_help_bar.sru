$PBExportHeader$u_help_bar.sru
$PBExportComments$Simulates a Microhelp bar on a non MDI frame window
forward
global type u_help_bar from userobject
end type
type st_clock from statictext within u_help_bar
end type
type st_msg from statictext within u_help_bar
end type
type p_alert from picture within u_help_bar
end type
type st_progress_back from statictext within u_help_bar
end type
type st_progress_fill from statictext within u_help_bar
end type
type st_about from statictext within u_help_bar
end type
end forward

global type u_help_bar from userobject
integer width = 2491
integer height = 80
long backcolor = 12632256
long tabtextcolor = 33554432
event documentation pbm_custom75
st_clock st_clock
st_msg st_msg
p_alert p_alert
st_progress_back st_progress_back
st_progress_fill st_progress_fill
st_about st_about
end type
global u_help_bar u_help_bar

type variables
window iw_parent_window
integer ii_menu_ht = 0
Boolean ib_show_clock
integer ii_resizeable_offset

integer error_seconds = 120

string picture_ok = "result_0.bmp"
string picture_error = "result_4.bmp"

long minvalue
long maxvalue
long value

long maxwidth

end variables

forward prototypes
public subroutine uf_resized ()
public subroutine uf_init (window aw_win, boolean ab_clock_on)
public subroutine uf_set_msg (string as_msg)
public subroutine uf_set_clock ()
public subroutine set_error (str_event_log_entry pstr_log)
public subroutine initialize_progress (long pl_minvalue, long pl_maxvalue)
public subroutine set_progress (long pl_value)
public subroutine close_progress ()
end prototypes

on documentation;/*
User Object : u_help_bar
	This is a Microhelp like object than can be dropped on any window
	and used to give information to a user much like using the
	Setmicrohelp function on an MDI Frame window. It 
	automatically places and resizes itself if it is initialized and 
	called from the resize event of the window. It can optionally display
	the date and time in the right hand portion of the bar.
	The developer needs to place the following function calls to the
	object in the appropriate events. If the clock is to be displayed then
	the developer also needs to set a timer event on the window (usually
	for 60 seconds).
Functions :
	init(window,boolean); Called in the open event of the window that it
		is placed on. The first parameter registers the window with the
		object and the second parameter tells the object whether to display
		the date and time or not. Only needs to be called once.
		Usage : init(this,true)
	resize(); Called from the resize event of the parent window. It 
		resizes and moves the bar so that it is always the width of the 
		window and at the bottom of the window.
	set_clock(); Called from the timer event of the parent window. It 
		causes the curent time to be displayed.
	Set_msg(string); Called to display a new message in the left hand
		portion of the bar. Call with an empty string to clear the display.

*/		


         
end on

public subroutine uf_resized ();///////////////////////////////////////////////////////////////////////////
//
// Function:	uf_resized
//
//	Purpose:
//
//		This function's primary purpose is correctly place the user
//		object on the window it is placed on.  This function should
//		be called from the parent window's resize event.
//
// Scope:		public
//
// Parameters:
//					None
//
// Returns : 	None
//
//	DATE			NAME		REVISION
// ----		------------------------------------------------------------
// Powersoft Corporation	INITIAL VERSION
//
//////////////////////////////////////////////////////////////////////
long ll_progress_width

if ii_menu_ht=0 then return // object has not been initialized yet
// using hide then show has less flicker than set redraw off for this
// object when changing the size and moving it.

hide(this)


// resize the object to the new size of the window
this.y = iw_parent_window.WorkSpaceHeight()  - height
this.width = iw_parent_window.WorkSpacewidth() - this.x

p_alert.x = 0

ll_progress_width = (width - p_alert.width - st_clock.width - 60) / 3

st_msg.x = p_alert.width + 4
st_msg.width = 2 * ll_progress_width

st_progress_back.x = st_msg.x + st_msg.width + 4
st_progress_back.width = ll_progress_width
st_progress_fill.x = st_progress_back.x + 4

st_about.x = st_progress_back.x
st_about.width = st_progress_back.width

st_clock.x = st_progress_back.x + st_progress_back.width + 4

// move the object to the bottom of the window
//move(this,1,iw_parent_window.WorkSpaceHeight() - (this.height+ii_menu_ht) + ii_resizeable_offset)
this.move(0,iw_parent_window.WorkSpaceHeight() - this.height + 20)

show(this)
end subroutine

public subroutine uf_init (window aw_win, boolean ab_clock_on);///////////////////////////////////////////////////////////////////////////
//
// Function:	uf_init
//
//	Purpose:
//
//		Called in the open event of the window that it is placed on. The
//		first parameter registers the window with the object and the second
//		parameter tells the object whether to display the date and time or
//		not. Only needs to be called once.
//
// Scope:		public
//
// Parameters:
//					aw_win	   :window
//					ab_clock_on	:boolean
//
// Returns : None
//
//	DATE			NAME			REVISION
// ----		------------------------------------------------------------
// Powersoft Corporation	INITIAL VERSION
//
//////////////////////////////////////////////////////////////////////////*


// set the individual lines object to their proper position


iw_parent_window = aw_win

st_progress_back.visible = false
st_progress_fill.visible = false

// if there is a menu then offset the position of the object as needed

if len(iw_parent_window.menuname) > 0 then
	ii_menu_ht = 175
else
	ii_menu_ht = 98
end if

// If the window argument passed is resizable...
if aw_win.resizable then
	ii_resizeable_offset = 0
else
	ii_resizeable_offset = 16
end if
// is the clock shown ?

ib_show_clock = ab_clock_on
if not ib_show_clock then 
	hide(st_clock)
else
	uf_set_clock()
end if

// make it fit on the window properly

uf_resized()


end subroutine

public subroutine uf_set_msg (string as_msg);///////////////////////////////////////////////////////////////////////////
//
// Function:	uf_set_msg
//
//	Purpose:
//
//					Sets the message on the user object to the message
//					passed to this function.  Can be called from any
//					event script in the parent window.
//
// Scope:		public
//
// Parameters:
//					as_msg:	string
//
// Returns : 	None
//
//	DATE			NAME			REVISION
// ----		------------------------------------------------------------
// Powersoft Corporation	INITIAL VERSION
//
//////////////////////////////////////////////////////////////////////////

st_msg.text = ' '+as_msg
end subroutine

public subroutine uf_set_clock ();///////////////////////////////////////////////////////////////////////////
//
// Function:	uf_set_clock
//
//	Purpose:
//
//		Causes the clock portion of the UO to be refreshed. Is typically 
//    called from the timer event of the window that the user object is
//    on.
//
// Scope:		public
//
// Parameters:
//					None
//
// Returns :   None
//
//	DATE			NAME			REVISION
// ----		------------------------------------------------------------
// Powersoft Corporation	INITIAL VERSION
//
//////////////////////////////////////////////////////////////////////////

st_clock.text = string(today(),"[shortdate]")+ & 
                "  "+string(now(),"hh:mm AM/PM")


if (date(last_error.date_time) = today()) and (secondsafter(time(last_error.date_time), now()) <= error_seconds) then
	p_alert.picturename = picture_error
else
	p_alert.picturename = picture_ok
end if

end subroutine

public subroutine set_error (str_event_log_entry pstr_log);p_alert.picturename = picture_error

end subroutine

public subroutine initialize_progress (long pl_minvalue, long pl_maxvalue);minvalue = pl_minvalue
maxvalue = pl_maxvalue

maxwidth = st_progress_back.width - 8

st_progress_back.visible = true
st_progress_fill.visible = true
st_about.visible = false

set_progress(minvalue)


end subroutine

public subroutine set_progress (long pl_value);real lr_width
integer li_percentile

value = pl_value

if value >= maxvalue then
	st_progress_fill.width = maxwidth
	return
end if

if value <= minvalue then
	st_progress_fill.visible = false
	return
end if

lr_width = real(value - minvalue)/real(maxvalue - minvalue)

li_percentile = integer(lr_width * 100)

lr_width = lr_width * real(maxwidth)

st_progress_fill.width = integer(lr_width)

if st_progress_fill.width >= 8 then
	st_progress_fill.visible = true
else
	st_progress_fill.visible = false
end if


end subroutine

public subroutine close_progress ();st_progress_back.visible = false
st_progress_fill.visible = false
st_about.visible = true

end subroutine

on u_help_bar.create
this.st_clock=create st_clock
this.st_msg=create st_msg
this.p_alert=create p_alert
this.st_progress_back=create st_progress_back
this.st_progress_fill=create st_progress_fill
this.st_about=create st_about
this.Control[]={this.st_clock,&
this.st_msg,&
this.p_alert,&
this.st_progress_back,&
this.st_progress_fill,&
this.st_about}
end on

on u_help_bar.destroy
destroy(this.st_clock)
destroy(this.st_msg)
destroy(this.p_alert)
destroy(this.st_progress_back)
destroy(this.st_progress_fill)
destroy(this.st_about)
end on

type st_clock from statictext within u_help_bar
integer x = 1961
integer y = 8
integer width = 521
integer height = 60
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 12632256
boolean enabled = false
string text = "12/12/19  12:12 PM"
alignment alignment = right!
end type

type st_msg from statictext within u_help_bar
integer x = 96
integer y = 8
integer width = 1166
integer height = 60
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 12632256
boolean enabled = false
string text = " Ready"
boolean focusrectangle = false
end type

type p_alert from picture within u_help_bar
integer y = 8
integer width = 96
integer height = 60
string picturename = "result_0.bmp"
boolean focusrectangle = false
end type

event clicked;
if date(last_error.date_time) >= today() then
	f_display_log_entry(last_error)
end if



end event

type st_progress_back from statictext within u_help_bar
integer x = 1239
integer y = 8
integer width = 699
integer height = 60
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

type st_progress_fill from statictext within u_help_bar
integer x = 1243
integer y = 12
integer width = 247
integer height = 52
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

type st_about from statictext within u_help_bar
integer x = 1239
integer y = 8
integer width = 699
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 12632256
string text = "About EncounterPRO-OS"
alignment alignment = center!
boolean focusrectangle = false
end type

event clicked;open(w_about_encounterpro)

end event

