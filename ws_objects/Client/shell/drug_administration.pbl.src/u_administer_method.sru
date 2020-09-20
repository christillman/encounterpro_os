$PBExportHeader$u_administer_method.sru
forward
global type u_administer_method from statictext
end type
end forward

global type u_administer_method from statictext
integer width = 613
integer height = 68
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type
global u_administer_method u_administer_method

type variables
string method
boolean WasModified
end variables

forward prototypes
public subroutine set_method (string ps_method)
end prototypes

public subroutine set_method (string ps_method);

if ps_method = "" then
	setnull(method)
else
	method = ps_method
end if

end subroutine

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_package_administer_method_list"
popup.datacolumn = 1
popup.displaycolumn = 1
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

set_method(popup_return.items[1])

end event

event constructor;method = ""
end event

on u_administer_method.create
end on

on u_administer_method.destroy
end on

