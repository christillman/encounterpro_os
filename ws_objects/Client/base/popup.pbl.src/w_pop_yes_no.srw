$PBExportHeader$w_pop_yes_no.srw
forward
global type w_pop_yes_no from w_pop_window_base
end type
type cb_no from commandbutton within w_pop_yes_no
end type
type cb_yes from commandbutton within w_pop_yes_no
end type
end forward

global type w_pop_yes_no from w_pop_window_base
integer x = 439
integer y = 592
integer width = 2034
integer height = 928
boolean titlebar = false
string title = ""
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
cb_no cb_no
cb_yes cb_yes
end type
global w_pop_yes_no w_pop_yes_no

event open;call super::open;

is_default_return = "YES"

end event

on w_pop_yes_no.create
int iCurrent
call super::create
this.dw_message=create dw_message
this.cb_no=create cb_no
this.cb_yes=create cb_yes
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_no
this.Control[iCurrent+2]=this.cb_yes
end on

on w_pop_yes_no.destroy
call super::destroy
destroy(this.cb_no)
destroy(this.cb_yes)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_pop_yes_no
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_pop_yes_no
end type

type cb_no from commandbutton within w_pop_yes_no
integer x = 421
integer y = 716
integer width = 430
integer height = 136
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&No"
boolean cancel = true
end type

on clicked;str_popup_return popup_return

popup_return.item = "NO"
closewithreturn(parent, popup_return)

end on

type cb_yes from commandbutton within w_pop_yes_no
integer x = 1193
integer y = 716
integer width = 430
integer height = 136
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Yes"
boolean default = true
end type

on clicked;str_popup_return popup_return

popup_return.item = is_default_return
closewithreturn(parent, popup_return)

end on

