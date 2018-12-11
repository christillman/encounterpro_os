$PBExportHeader$u_tabpage_user_roles.sru
forward
global type u_tabpage_user_roles from u_tabpage_user_base
end type
type cb_remove_role from commandbutton within u_tabpage_user_roles
end type
type cb_down from commandbutton within u_tabpage_user_roles
end type
type cb_up from commandbutton within u_tabpage_user_roles
end type
type cb_add_role from commandbutton within u_tabpage_user_roles
end type
type dw_roles from u_dw_pick_list within u_tabpage_user_roles
end type
type st_roles_title from statictext within u_tabpage_user_roles
end type
end forward

global type u_tabpage_user_roles from u_tabpage_user_base
string tag = "User"
cb_remove_role cb_remove_role
cb_down cb_down
cb_up cb_up
cb_add_role cb_add_role
dw_roles dw_roles
st_roles_title st_roles_title
end type
global u_tabpage_user_roles u_tabpage_user_roles

type variables

end variables

forward prototypes
public subroutine refresh ()
end prototypes

public subroutine refresh ();dw_roles.settransobject(sqlca)
dw_roles.retrieve(user.user_id)

cb_up.enabled = false
cb_down.enabled = false
cb_remove_role.enabled = false

end subroutine

on u_tabpage_user_roles.create
int iCurrent
call super::create
this.cb_remove_role=create cb_remove_role
this.cb_down=create cb_down
this.cb_up=create cb_up
this.cb_add_role=create cb_add_role
this.dw_roles=create dw_roles
this.st_roles_title=create st_roles_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_remove_role
this.Control[iCurrent+2]=this.cb_down
this.Control[iCurrent+3]=this.cb_up
this.Control[iCurrent+4]=this.cb_add_role
this.Control[iCurrent+5]=this.dw_roles
this.Control[iCurrent+6]=this.st_roles_title
end on

on u_tabpage_user_roles.destroy
call super::destroy
destroy(this.cb_remove_role)
destroy(this.cb_down)
destroy(this.cb_up)
destroy(this.cb_add_role)
destroy(this.dw_roles)
destroy(this.st_roles_title)
end on

type cb_remove_role from commandbutton within u_tabpage_user_roles
integer x = 1650
integer y = 504
integer width = 407
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Remove"
end type

event clicked;string ls_temp
long ll_row
str_popup_return popup_return
long i
integer li_sts

ll_row = dw_roles.get_selected_row()
if ll_row <= 0 then return

ls_temp = "Are you sure you wish to remove the role '" + dw_roles.object.role_name[ll_row] + "' from this user?"
openwithparm(w_pop_yes_no, ls_temp)
popup_return = message.powerobjectparm
if popup_return.item = "YES" then
	dw_roles.deleterow(ll_row)
	for i = 1 to dw_roles.rowcount()
		dw_roles.object.role_order[i] = i
	next
end if

li_sts = dw_roles.update()

return

end event

type cb_down from commandbutton within u_tabpage_user_roles
integer x = 1650
integer y = 876
integer width = 407
integer height = 108
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Move Down"
end type

event clicked;long ll_row
integer li_temp
integer li_sts

ll_row = dw_roles.get_selected_row()
if ll_row <= 0 or ll_row >= dw_roles.rowcount() then return

li_temp = dw_roles.object.role_order[ll_row]
dw_roles.object.role_order[ll_row] = dw_roles.object.role_order[ll_row + 1]
dw_roles.object.role_order[ll_row + 1] = li_temp

dw_roles.sort()


li_sts = dw_roles.update()

return

end event

type cb_up from commandbutton within u_tabpage_user_roles
integer x = 1650
integer y = 728
integer width = 407
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Move Up"
end type

event clicked;long ll_row
integer li_temp
integer li_sts

ll_row = dw_roles.get_selected_row()
if ll_row <= 1 then return

li_temp = dw_roles.object.role_order[ll_row]
dw_roles.object.role_order[ll_row] = dw_roles.object.role_order[ll_row - 1]
dw_roles.object.role_order[ll_row - 1] = li_temp

dw_roles.sort()


li_sts = dw_roles.update()

return

end event

type cb_add_role from commandbutton within u_tabpage_user_roles
integer x = 1650
integer y = 280
integer width = 407
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add"
end type

event clicked;str_popup popup
str_popup_return popup_return
string ls_find
long ll_row
integer li_sts

popup.dataobject = "dw_role_select_list"
popup.datacolumn = 1
popup.displaycolumn = 2

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_find = "role_id='" + popup_return.items[1] + "'"
ll_row = dw_roles.find(ls_find, 1, dw_roles.rowcount())
if ll_row > 0 then return

ll_row = dw_roles.insertrow(0)
dw_roles.object.user_id[ll_row] = user.user_id
dw_roles.object.role_id[ll_row] = popup_return.items[1]
dw_roles.object.role_order[ll_row] = ll_row
dw_roles.object.role_name[ll_row] = popup_return.descriptions[1]


li_sts = dw_roles.update()

return

end event

type dw_roles from u_dw_pick_list within u_tabpage_user_roles
integer x = 206
integer y = 252
integer width = 1257
integer height = 904
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_user_role_select_list"
boolean border = false
end type

event unselected;call super::unselected;cb_up.enabled = false
cb_down.enabled = false
cb_remove_role.enabled = false

end event

event selected;call super::selected;if selected_row > 1 then
	cb_up.enabled = true
else
	cb_up.enabled = false
end if


if selected_row < rowcount() then
	cb_down.enabled = true
else
	cb_down.enabled = false
end if


cb_remove_role.enabled = true

end event

type st_roles_title from statictext within u_tabpage_user_roles
integer x = 466
integer y = 168
integer width = 626
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "User Roles"
alignment alignment = center!
boolean focusrectangle = false
end type

