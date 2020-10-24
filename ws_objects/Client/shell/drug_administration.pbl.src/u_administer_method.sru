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
string package_id
boolean WasModified
end variables

forward prototypes
public subroutine set_method (string ps_method)
public subroutine set_package (string ps_package_id)
end prototypes

public subroutine set_method (string ps_method);
if ps_method = "" then
	setnull(method)
	text = ""
else
	method = ps_method
	text = ps_method
end if

if len(text) > 22 then
	textsize = -10
else
	textsize = -12
end if

end subroutine

public subroutine set_package (string ps_package_id);
package_id = ps_package_id

datastore lds
lds = CREATE datastore
lds.dataobject = "dw_package_administer_method_list"
lds.Settransobject(SQLCA)
lds.Retrieve(package_id)
IF lds.rowcount( ) = 1 THEN
	set_method(lds.Object.description[1])
END IF

end subroutine

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_package_administer_method_list"
popup.datacolumn = 1
popup.displaycolumn = 1
popup.argument[1] = package_id
popup.argument_count = 1
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

