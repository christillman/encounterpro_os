$PBExportHeader$w_pop_window_base.srw
forward
global type w_pop_window_base from w_window_base
end type
type dw_message from datawindow within w_pop_window_base
end type
end forward

global type w_pop_window_base from w_window_base
integer x = 439
integer y = 592
integer width = 2034
integer height = 928
boolean titlebar = false
string title = ""
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
boolean show_more_buttons = false
dw_message dw_message
end type
global w_pop_window_base w_pop_window_base

type variables

string is_default_return = "YES"
end variables

event open;call super::open;string ls_temp
str_popup_return popup_return
integer li_rc
datawindowchild dwc_ok

ls_temp = message.stringparm

if gnv_app.cpr_mode = "SERVER" then
	log.log(this, ":open", message.stringparm, 2)
	popup_return.item = is_default_return
	closewithreturn(this, popup_return)
	return
end if


dw_message.reset()
dw_message.insertrow(0)
li_rc = dw_message.setitem(1,1,message.stringparm)
ls_temp = dw_message.GetItemString(1, 1)
return li_rc

end event

on w_pop_window_base.create
int iCurrent
call super::create
this.dw_message=create dw_message
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_message
end on

on w_pop_window_base.destroy
call super::destroy
destroy(this.dw_message)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_pop_window_base
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_pop_window_base
end type

type dw_message from datawindow within w_pop_window_base
integer x = 59
integer y = 120
integer width = 1906
integer height = 608
string dataobject = "dw_ok"
boolean vscrollbar = true
boolean border = false
end type

