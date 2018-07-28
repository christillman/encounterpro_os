HA$PBExportHeader$w_pop_get_password.srw
forward
global type w_pop_get_password from w_window_base
end type
type sle_string from singlelineedit within w_pop_get_password
end type
type pb_cancel from u_picture_button within w_pop_get_password
end type
type st_title from statictext within w_pop_get_password
end type
type pb_ok from u_picture_button within w_pop_get_password
end type
end forward

global type w_pop_get_password from w_window_base
integer x = 434
integer y = 604
integer width = 2034
integer height = 752
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
sle_string sle_string
pb_cancel pb_cancel
st_title st_title
pb_ok pb_ok
end type
global w_pop_get_password w_pop_get_password

event open;call super::open;
st_title.text = message.stringparm

sle_string.setfocus()

end event

on w_pop_get_password.create
int iCurrent
call super::create
this.sle_string=create sle_string
this.pb_cancel=create pb_cancel
this.st_title=create st_title
this.pb_ok=create pb_ok
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_string
this.Control[iCurrent+2]=this.pb_cancel
this.Control[iCurrent+3]=this.st_title
this.Control[iCurrent+4]=this.pb_ok
end on

on w_pop_get_password.destroy
call super::destroy
destroy(this.sle_string)
destroy(this.pb_cancel)
destroy(this.st_title)
destroy(this.pb_ok)
end on

type sle_string from singlelineedit within w_pop_get_password
integer x = 503
integer y = 260
integer width = 969
integer height = 96
integer taborder = 1
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean password = true
borderstyle borderstyle = stylelowered!
end type

type pb_cancel from u_picture_button within w_pop_get_password
integer x = 82
integer y = 444
integer taborder = 20
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

setnull(popup_return.item)
popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

type st_title from statictext within w_pop_get_password
integer x = 82
integer y = 80
integer width = 1851
integer height = 92
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 33538240
boolean enabled = false
boolean focusrectangle = false
end type

type pb_ok from u_picture_button within w_pop_get_password
integer x = 1687
integer y = 444
integer taborder = 10
boolean default = true
string picturename = "button26.bmp"
string disabledname = "button26.bmp"
end type

event clicked;call super::clicked;
closewithreturn(parent, sle_string.text)

end event

