$PBExportHeader$w_window_full_response.srw
forward
global type w_window_full_response from w_window_base
end type
type pb_done from u_picture_button within w_window_full_response
end type
type pb_cancel from u_picture_button within w_window_full_response
end type
end forward

global type w_window_full_response from w_window_base
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
pb_done pb_done
pb_cancel pb_cancel
end type
global w_window_full_response w_window_full_response

on w_window_full_response.create
int iCurrent
call super::create
this.pb_done=create pb_done
this.pb_cancel=create pb_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_done
this.Control[iCurrent+2]=this.pb_cancel
end on

on w_window_full_response.destroy
call super::destroy
destroy(this.pb_done)
destroy(this.pb_cancel)
end on

event open;call super::open;// Extend ancestor script
end event

type pb_epro_help from w_window_base`pb_epro_help within w_window_full_response
boolean visible = true
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_window_full_response
end type

type pb_done from u_picture_button within w_window_full_response
integer x = 2597
integer y = 1480
boolean originalsize = false
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

type pb_cancel from u_picture_button within w_window_full_response
integer x = 55
integer y = 1480
integer width = 256
integer height = 224
boolean bringtotop = true
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

