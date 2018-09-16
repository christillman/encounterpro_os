$PBExportHeader$w_trace_control.srw
forward
global type w_trace_control from w_window_base
end type
type rb_timer_none from radiobutton within w_trace_control
end type
type rb_timer_clock from radiobutton within w_trace_control
end type
type rb_timer_process from radiobutton within w_trace_control
end type
type rb_timer_thread from radiobutton within w_trace_control
end type
type cbx_routineentry from checkbox within w_trace_control
end type
type cbx_routineline from checkbox within w_trace_control
end type
type cbx_embeddedsql from checkbox within w_trace_control
end type
type cbx_objectcreate from checkbox within w_trace_control
end type
type cbx_userdefined from checkbox within w_trace_control
end type
type cbx_systemerrors from checkbox within w_trace_control
end type
type cbx_garbagecoll from checkbox within w_trace_control
end type
type cb_clear_all from commandbutton within w_trace_control
end type
type cb_set_all from commandbutton within w_trace_control
end type
type cb_startstop from commandbutton within w_trace_control
end type
type cb_exit from commandbutton within w_trace_control
end type
type cbx_objectdestroy from checkbox within w_trace_control
end type
type st_tracing_title from statictext within w_trace_control
end type
type gb_1 from groupbox within w_trace_control
end type
type gb_2 from groupbox within w_trace_control
end type
end forward

global type w_trace_control from w_window_base
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
rb_timer_none rb_timer_none
rb_timer_clock rb_timer_clock
rb_timer_process rb_timer_process
rb_timer_thread rb_timer_thread
cbx_routineentry cbx_routineentry
cbx_routineline cbx_routineline
cbx_embeddedsql cbx_embeddedsql
cbx_objectcreate cbx_objectcreate
cbx_userdefined cbx_userdefined
cbx_systemerrors cbx_systemerrors
cbx_garbagecoll cbx_garbagecoll
cb_clear_all cb_clear_all
cb_set_all cb_set_all
cb_startstop cb_startstop
cb_exit cb_exit
cbx_objectdestroy cbx_objectdestroy
st_tracing_title st_tracing_title
gb_1 gb_1
gb_2 gb_2
end type
global w_trace_control w_trace_control

type variables
string is_title = 'Trace Options ' 
string is_starttext

end variables

forward prototypes
public function string of_converterror (errorreturn a_error)
public subroutine of_errmsg (errorreturn ae_error, string as_msg)
end prototypes

public function string of_converterror (errorreturn a_error);// of_converterror: convert enumerated type 
// ErrorReturn parameter to text.
String ls_result
choose case a_error
   Case Success!
      ls_result =  "Success!"
   Case FileCloseError!
      ls_result =  "FileCloseError!"
   Case FileOpenError!
      ls_result =  "FileOpenError!"
   Case FileReadError!
      ls_result =  "FileReadError!"
   Case FileWriteError!
      ls_result =  "FileWriteError!"
   Case FileNotOpenError!
      ls_result =  "FileNotOpenError!"
   Case FileAlreadyOpenError!
      ls_result =  "FileAlreadyOpenError!"
   Case FileInvalidFormatError!
      ls_result =  "FileInvalidFormatError!"
   Case FileNotSetError!
      ls_result =  "FileNotSetError!"
   Case EventNotExistError!
      ls_result =  "EventNotExistError!"
   Case EventWrongPrototypeError!
      ls_result =  "EventWrongPrototypeError!"
   Case ModelNotExistsError!
      ls_result =  "ModelNotExistsError!"
   Case ModelExistsError!
      ls_result =  "ModelExistsError!"
   Case TraceStartedError!
      ls_result =  "TraceStartedError!"
   Case TraceNotStartedError!
      ls_result =  "TraceNotStartedError!"
   Case TraceNoMoreNodes!
      ls_result =  "TraceNoMoreNodes!"
   Case TraceGeneralError!
      ls_result =  "TraceGeneralError!"
   Case FeatureNotSupportedError!
      ls_result =  "FeatureNotSupportedError!"
   Case else
      ls_result =  "Unknown Error Code"
end choose
return ls_result 

end function

public subroutine of_errmsg (errorreturn ae_error, string as_msg);Messagebox(this.title,'Error executing '+as_msg+ &
   '. Error code : '+of_converterror(ae_error)) 
end subroutine

on w_trace_control.create
int iCurrent
call super::create
this.rb_timer_none=create rb_timer_none
this.rb_timer_clock=create rb_timer_clock
this.rb_timer_process=create rb_timer_process
this.rb_timer_thread=create rb_timer_thread
this.cbx_routineentry=create cbx_routineentry
this.cbx_routineline=create cbx_routineline
this.cbx_embeddedsql=create cbx_embeddedsql
this.cbx_objectcreate=create cbx_objectcreate
this.cbx_userdefined=create cbx_userdefined
this.cbx_systemerrors=create cbx_systemerrors
this.cbx_garbagecoll=create cbx_garbagecoll
this.cb_clear_all=create cb_clear_all
this.cb_set_all=create cb_set_all
this.cb_startstop=create cb_startstop
this.cb_exit=create cb_exit
this.cbx_objectdestroy=create cbx_objectdestroy
this.st_tracing_title=create st_tracing_title
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_timer_none
this.Control[iCurrent+2]=this.rb_timer_clock
this.Control[iCurrent+3]=this.rb_timer_process
this.Control[iCurrent+4]=this.rb_timer_thread
this.Control[iCurrent+5]=this.cbx_routineentry
this.Control[iCurrent+6]=this.cbx_routineline
this.Control[iCurrent+7]=this.cbx_embeddedsql
this.Control[iCurrent+8]=this.cbx_objectcreate
this.Control[iCurrent+9]=this.cbx_userdefined
this.Control[iCurrent+10]=this.cbx_systemerrors
this.Control[iCurrent+11]=this.cbx_garbagecoll
this.Control[iCurrent+12]=this.cb_clear_all
this.Control[iCurrent+13]=this.cb_set_all
this.Control[iCurrent+14]=this.cb_startstop
this.Control[iCurrent+15]=this.cb_exit
this.Control[iCurrent+16]=this.cbx_objectdestroy
this.Control[iCurrent+17]=this.st_tracing_title
this.Control[iCurrent+18]=this.gb_1
this.Control[iCurrent+19]=this.gb_2
end on

on w_trace_control.destroy
call super::destroy
destroy(this.rb_timer_none)
destroy(this.rb_timer_clock)
destroy(this.rb_timer_process)
destroy(this.rb_timer_thread)
destroy(this.cbx_routineentry)
destroy(this.cbx_routineline)
destroy(this.cbx_embeddedsql)
destroy(this.cbx_objectcreate)
destroy(this.cbx_userdefined)
destroy(this.cbx_systemerrors)
destroy(this.cbx_garbagecoll)
destroy(this.cb_clear_all)
destroy(this.cb_set_all)
destroy(this.cb_startstop)
destroy(this.cb_exit)
destroy(this.cbx_objectdestroy)
destroy(this.st_tracing_title)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;call super::open;String ls_tracedir

application lapp_current 
lapp_current = getapplication()

CHOOSE CASE trc_Timerkind
	CASE Timernone!
		rb_timer_none.checked = true
	CASE Clock!
		rb_timer_clock.checked = true
	CASE Process!
		rb_timer_process.checked = true
	CASE Thread!
		rb_timer_thread.checked = true
	CASE ELSE
		trc_Timerkind = Clock!
		rb_timer_clock.checked = true
END CHOOSE

if trace_mode then
	st_tracing_title.text = "Tracing is ON"
	cb_startstop.text = "Stop Tracing"
else
	st_tracing_title.text = "Tracing is OFF"
	cb_startstop.text = "Start Tracing"
end if

cbx_embeddedsql.checked = trc_ActESql
cbx_routineentry.checked = trc_ActRoutine
cbx_userdefined.checked = trc_ActUser
cbx_systemerrors.checked = trc_ActError
cbx_routineline.checked = trc_ActLine
cbx_objectcreate.checked = trc_ActObjectCreate
cbx_objectdestroy.checked = trc_ActObjectDestroy
cbx_garbagecoll.checked = trc_ActGarbageCollect

end event

type pb_epro_help from w_window_base`pb_epro_help within w_trace_control
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_trace_control
integer x = 46
integer y = 1640
end type

type rb_timer_none from radiobutton within w_trace_control
integer x = 800
integer y = 368
integer width = 325
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "None"
end type

event clicked;trc_Timerkind = timernone!

end event

type rb_timer_clock from radiobutton within w_trace_control
integer x = 1161
integer y = 368
integer width = 325
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Clock"
boolean checked = true
end type

event clicked;trc_Timerkind = Clock!

end event

type rb_timer_process from radiobutton within w_trace_control
integer x = 1522
integer y = 368
integer width = 325
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Process"
end type

event clicked;trc_Timerkind = Process!


end event

type rb_timer_thread from radiobutton within w_trace_control
integer x = 1883
integer y = 368
integer width = 325
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Thread"
end type

event clicked;trc_Timerkind = Thread!

end event

type cbx_routineentry from checkbox within w_trace_control
integer x = 475
integer y = 720
integer width = 599
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Routine Entry/Exit"
end type

event clicked;trc_ActRoutine = checked

end event

type cbx_routineline from checkbox within w_trace_control
integer x = 475
integer y = 836
integer width = 535
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Routine Line Hits"
boolean checked = true
end type

event clicked;trc_ActLine = checked

end event

type cbx_embeddedsql from checkbox within w_trace_control
integer x = 475
integer y = 952
integer width = 503
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Embedded SQL"
boolean checked = true
end type

event clicked;trc_ActESql = checked

end event

type cbx_objectcreate from checkbox within w_trace_control
integer x = 475
integer y = 1068
integer width = 814
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Object Creation"
boolean checked = true
end type

event clicked;trc_ActObjectCreate = checked

end event

type cbx_userdefined from checkbox within w_trace_control
integer x = 1550
integer y = 952
integer width = 677
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "User Defined Activities"
boolean checked = true
end type

event clicked;trc_ActUser = checked

end event

type cbx_systemerrors from checkbox within w_trace_control
integer x = 1550
integer y = 720
integer width = 466
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "System Errors"
boolean checked = true
end type

event clicked;trc_ActError = checked

end event

type cbx_garbagecoll from checkbox within w_trace_control
integer x = 1550
integer y = 836
integer width = 585
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Garbage Collection"
boolean checked = true
end type

event clicked;trc_ActGarbageCollect = checked

end event

type cb_clear_all from commandbutton within w_trace_control
integer x = 1513
integer y = 1148
integer width = 402
integer height = 112
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear All"
end type

event clicked;cbx_embeddedsql.checked = false
cbx_garbagecoll.checked = false
cbx_objectcreate.checked = false
cbx_objectdestroy.checked = false
cbx_routineentry.checked = false
cbx_routineline.checked = false
cbx_systemerrors.checked = false
cbx_userdefined.checked = false

end event

type cb_set_all from commandbutton within w_trace_control
integer x = 1952
integer y = 1144
integer width = 402
integer height = 112
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Set All"
end type

event clicked;cbx_embeddedsql.checked = true
cbx_garbagecoll.checked = true
cbx_objectcreate.checked = true
cbx_objectdestroy.checked = true
cbx_routineentry.checked = true
cbx_routineline.checked = true
cbx_systemerrors.checked = true
cbx_userdefined.checked = true

end event

type cb_startstop from commandbutton within w_trace_control
integer x = 997
integer y = 1348
integer width = 809
integer height = 112
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Start Tracing"
end type

event clicked;if trace_mode then
	trace_mode = false
	st_tracing_title.text = "Tracing is OFF"
	cb_startstop.text = "Start Tracing"
	f_stop_tracing()
else
	trace_mode = true
	st_tracing_title.text = "Tracing is ON"
	cb_startstop.text = "Stop Tracing"
	f_start_tracing("EproTrace_" + string(computer_id) + ".pbp")
end if


end event

type cb_exit from commandbutton within w_trace_control
integer x = 2395
integer y = 1568
integer width = 402
integer height = 112
integer taborder = 90
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Exit"
end type

event clicked;close(parent)
end event

type cbx_objectdestroy from checkbox within w_trace_control
integer x = 475
integer y = 1184
integer width = 814
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Object Destruction"
boolean checked = true
end type

event clicked;trc_ActObjectDestroy = checked

end event

type st_tracing_title from statictext within w_trace_control
integer x = 741
integer y = 80
integer width = 1349
integer height = 108
boolean bringtotop = true
integer textsize = -14
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Tracing is OFF"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_trace_control
integer x = 686
integer y = 264
integer width = 1559
integer height = 244
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Timer Kind"
borderstyle borderstyle = styleraised!
end type

type gb_2 from groupbox within w_trace_control
integer x = 393
integer y = 608
integer width = 2043
integer height = 704
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Trace Activities"
borderstyle borderstyle = styleraised!
end type

