$PBExportHeader$w_pop_yes_no_alert.srw
forward
global type w_pop_yes_no_alert from w_pop_window_base
end type
type st_title from statictext within w_pop_yes_no_alert
end type
type cb_no from commandbutton within w_pop_yes_no_alert
end type
type cb_yes from commandbutton within w_pop_yes_no_alert
end type
end forward

global type w_pop_yes_no_alert from w_pop_window_base
integer x = 439
integer y = 592
integer width = 2034
integer height = 948
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
st_title st_title
cb_no cb_no
cb_yes cb_yes
end type
global w_pop_yes_no_alert w_pop_yes_no_alert

event open;call super::open;

is_default_return = "YES"

end event

on w_pop_yes_no_alert.create
int iCurrent
call super::create
this.st_title=create st_title
this.cb_no=create cb_no
this.cb_yes=create cb_yes
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.cb_no
this.Control[iCurrent+3]=this.cb_yes
end on

on w_pop_yes_no_alert.destroy
call super::destroy
destroy(this.st_title)
destroy(this.cb_no)
destroy(this.cb_yes)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_pop_yes_no_alert
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_pop_yes_no_alert
end type

type st_title from statictext within w_pop_yes_no_alert
integer width = 2030
integer height = 124
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "!!!   WARNING   !!!"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_no from commandbutton within w_pop_yes_no_alert
integer x = 416
integer y = 732
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

type cb_yes from commandbutton within w_pop_yes_no_alert
integer x = 1189
integer y = 732
integer width = 430
integer height = 136
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Yes"
end type

on clicked;str_popup_return popup_return

popup_return.item = is_default_return
closewithreturn(parent, popup_return)

end on

