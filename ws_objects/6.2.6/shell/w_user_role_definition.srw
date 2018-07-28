HA$PBExportHeader$w_user_role_definition.srw
forward
global type w_user_role_definition from w_window_base
end type
type pb_done from u_picture_button within w_user_role_definition
end type
type pb_cancel from u_picture_button within w_user_role_definition
end type
type st_roles_title from statictext within w_user_role_definition
end type
type dw_roles from u_dw_pick_list within w_user_role_definition
end type
type st_user_name_title from statictext within w_user_role_definition
end type
type st_user_name from statictext within w_user_role_definition
end type
type cb_add_role from commandbutton within w_user_role_definition
end type
type cb_up from commandbutton within w_user_role_definition
end type
type cb_down from commandbutton within w_user_role_definition
end type
type cb_remove_role from commandbutton within w_user_role_definition
end type
type st_title from statictext within w_user_role_definition
end type
end forward

global type w_user_role_definition from w_window_base
integer x = 329
integer y = 96
integer width = 2213
integer height = 1668
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
pb_done pb_done
pb_cancel pb_cancel
st_roles_title st_roles_title
dw_roles dw_roles
st_user_name_title st_user_name_title
st_user_name st_user_name
cb_add_role cb_add_role
cb_up cb_up
cb_down cb_down
cb_remove_role cb_remove_role
st_title st_title
end type
global w_user_role_definition w_user_role_definition

type variables
string user_id

end variables

on w_user_role_definition.create
int iCurrent
call super::create
this.pb_done=create pb_done
this.pb_cancel=create pb_cancel
this.st_roles_title=create st_roles_title
this.dw_roles=create dw_roles
this.st_user_name_title=create st_user_name_title
this.st_user_name=create st_user_name
this.cb_add_role=create cb_add_role
this.cb_up=create cb_up
this.cb_down=create cb_down
this.cb_remove_role=create cb_remove_role
this.st_title=create st_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_done
this.Control[iCurrent+2]=this.pb_cancel
this.Control[iCurrent+3]=this.st_roles_title
this.Control[iCurrent+4]=this.dw_roles
this.Control[iCurrent+5]=this.st_user_name_title
this.Control[iCurrent+6]=this.st_user_name
this.Control[iCurrent+7]=this.cb_add_role
this.Control[iCurrent+8]=this.cb_up
this.Control[iCurrent+9]=this.cb_down
this.Control[iCurrent+10]=this.cb_remove_role
this.Control[iCurrent+11]=this.st_title
end on

on w_user_role_definition.destroy
call super::destroy
destroy(this.pb_done)
destroy(this.pb_cancel)
destroy(this.st_roles_title)
destroy(this.dw_roles)
destroy(this.st_user_name_title)
destroy(this.st_user_name)
destroy(this.cb_add_role)
destroy(this.cb_up)
destroy(this.cb_down)
destroy(this.cb_remove_role)
destroy(this.st_title)
end on

event open;call super::open;string ls_filter
str_popup popup

popup = message.powerobjectparm

if popup.data_row_count <> 2 then
	log.log(this, "open", "Invalid Parameters", 4)
	close(this)
	return
end if

user_id = popup.items[1]
st_user_name.text = popup.items[2]

dw_roles.settransobject(sqlca)
dw_roles.retrieve(user_id)

cb_up.enabled = false
cb_down.enabled = false
cb_remove_role.enabled = false


end event

type pb_epro_help from w_window_base`pb_epro_help within w_user_role_definition
boolean visible = true
integer x = 1938
integer y = 24
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_user_role_definition
end type

type pb_done from u_picture_button within w_user_role_definition
integer x = 1888
integer y = 1364
integer taborder = 10
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;integer li_sts

li_sts = dw_roles.update()
if li_sts < 0 then return

close(parent)



end event

type pb_cancel from u_picture_button within w_user_role_definition
boolean visible = false
integer x = 69
integer y = 1364
integer taborder = 30
boolean bringtotop = true
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 0

closewithreturn(parent, popup_return)


end event

type st_roles_title from statictext within w_user_role_definition
integer x = 343
integer y = 332
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

type dw_roles from u_dw_pick_list within w_user_role_definition
integer x = 82
integer y = 416
integer width = 1257
integer height = 904
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_user_role_select_list"
boolean border = false
end type

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

event unselected;call super::unselected;cb_up.enabled = false
cb_down.enabled = false
cb_remove_role.enabled = false

end event

type st_user_name_title from statictext within w_user_role_definition
integer x = 462
integer y = 196
integer width = 311
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
string text = "User:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_user_name from statictext within w_user_role_definition
integer x = 795
integer y = 188
integer width = 791
integer height = 88
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
boolean enabled = false
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type cb_add_role from commandbutton within w_user_role_definition
integer x = 1527
integer y = 444
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
string text = "Add"
end type

event clicked;str_popup popup
str_popup_return popup_return
string ls_find
long ll_row

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
dw_roles.object.user_id[ll_row] = user_id
dw_roles.object.role_id[ll_row] = popup_return.items[1]
dw_roles.object.role_order[ll_row] = ll_row
dw_roles.object.role_name[ll_row] = popup_return.descriptions[1]



end event

type cb_up from commandbutton within w_user_role_definition
integer x = 1527
integer y = 892
integer width = 407
integer height = 108
integer taborder = 50
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

ll_row = dw_roles.get_selected_row()
if ll_row <= 1 then return

li_temp = dw_roles.object.role_order[ll_row]
dw_roles.object.role_order[ll_row] = dw_roles.object.role_order[ll_row - 1]
dw_roles.object.role_order[ll_row - 1] = li_temp

dw_roles.sort()



end event

type cb_down from commandbutton within w_user_role_definition
integer x = 1527
integer y = 1040
integer width = 407
integer height = 108
integer taborder = 60
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

ll_row = dw_roles.get_selected_row()
if ll_row <= 0 or ll_row >= dw_roles.rowcount() then return

li_temp = dw_roles.object.role_order[ll_row]
dw_roles.object.role_order[ll_row] = dw_roles.object.role_order[ll_row + 1]
dw_roles.object.role_order[ll_row + 1] = li_temp

dw_roles.sort()



end event

type cb_remove_role from commandbutton within w_user_role_definition
integer x = 1527
integer y = 668
integer width = 407
integer height = 108
integer taborder = 50
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

end event

type st_title from statictext within w_user_role_definition
integer width = 2208
integer height = 132
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Select User Roles"
alignment alignment = center!
boolean focusrectangle = false
end type

