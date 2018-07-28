HA$PBExportHeader$u_users_edit.sru
forward
global type u_users_edit from userobject
end type
type st_license_flag from statictext within u_users_edit
end type
type st_license_flag_title from statictext within u_users_edit
end type
type st_page from statictext within u_users_edit
end type
type pb_down from u_picture_button within u_users_edit
end type
type pb_up from u_picture_button within u_users_edit
end type
type st_radio_other from u_st_radio_user_role within u_users_edit
end type
type cb_new from commandbutton within u_users_edit
end type
type dw_users from u_dw_pick_list within u_users_edit
end type
type st_radio_roles from u_st_radio_user_role within u_users_edit
end type
type st_radio_inactive from u_st_radio_user_role within u_users_edit
end type
type r_1 from rectangle within u_users_edit
end type
type st_radio_active from u_st_radio_user_role within u_users_edit
end type
end forward

global type u_users_edit from userobject
integer width = 2400
integer height = 1748
long backcolor = 33538240
long tabtextcolor = 33554432
long tabbackcolor = 16777215
long picturemaskcolor = 536870912
st_license_flag st_license_flag
st_license_flag_title st_license_flag_title
st_page st_page
pb_down pb_down
pb_up pb_up
st_radio_other st_radio_other
cb_new cb_new
dw_users dw_users
st_radio_roles st_radio_roles
st_radio_inactive st_radio_inactive
r_1 r_1
st_radio_active st_radio_active
end type
global u_users_edit u_users_edit

type variables
string display_status
boolean display_only
string license_flag = "%"

end variables

forward prototypes
public subroutine refresh_users ()
public function integer initialize ()
public subroutine user_menu (long pl_row)
end prototypes

public subroutine refresh_users ();
if display_status = "ROLE" then
	dw_users.dataobject = "dw_role_select_list"
	dw_users.settransobject(sqlca)
	dw_users.retrieve()
	cb_new.text = "New Role"
	cb_new.visible = true
	st_license_flag.visible = false
	st_license_flag_title.visible = false
else
	dw_users.dataobject = "dw_user_list_by_provider_class"
	dw_users.settransobject(sqlca)
	dw_users.retrieve(license_flag, display_status)
	
	if display_status = "OK" or display_status = "OTHER" then
		cb_new.text = "New User"
		cb_new.visible = true
	else
		cb_new.visible = false
	end if
	st_license_flag.visible = true
	st_license_flag_title.visible = true
end if
dw_users.last_page = 0
dw_users.set_page(1, st_page.text)
if dw_users.last_page < 2 then
	pb_down.visible = false
	pb_up.visible = false
else
	pb_down.visible = true
	pb_up.visible = true
	pb_up.enabled = false
	pb_down.enabled = true
end if
end subroutine

public function integer initialize ();dw_users.height = height - dw_users.y - 100
cb_new.y = height - 250

if user_list.is_user_service(current_user.user_id, "CONFIG_USERS") then
	cb_new.enabled = true
	display_only = false
else
	cb_new.enabled = false
	display_only = true
end if

st_radio_active.postevent("clicked")

return 1

end function

public subroutine user_menu (long pl_row);str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons
integer li_update_flag
string ls_in_service
boolean lb_active
string ls_provider_id
string ls_user_id
string ls_license_flag
integer li_count
long ll_picked_computer_id

lb_active = false

if display_status <> "ROLE" then
	ls_user_id = dw_users.object.user_id[pl_row]
	SELECT count(*)
	INTO :li_count
	FROM o_Users
	WHERE user_id = :ls_user_id
	AND computer_id <> :computer_id;
	if not tf_check() then return
	if sqlca.sqlcode = 0 and li_count > 0 then
		lb_active = true
	end if
end if

if display_status = "OK" or display_status = "OTHER" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit User"
	popup.button_titles[popup.button_count] = "Edit user"
	buttons[popup.button_count] = "EDITUSER"
end if

if display_status = "ROLE" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit Role"
	popup.button_titles[popup.button_count] = "Edit Role"
	buttons[popup.button_count] = "EDITROLE"
end if

if display_status = "OK" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Set User as Inactive"
	popup.button_titles[popup.button_count] = "Inactive"
	buttons[popup.button_count] = "INACTIVE"
end if

if display_status = "NA" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Set User as Active"
	popup.button_titles[popup.button_count] = "Active"
	buttons[popup.button_count] = "ACTIVE"
end if

if display_status = "OK" and lb_active then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button06.bmp"
	popup.button_helps[popup.button_count] = "Reset User"
	popup.button_titles[popup.button_count] = "Reset"
	buttons[popup.button_count] = "RESET"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	button_pressed = message.doubleparm
	if button_pressed < 1 or button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	button_pressed = 1
else
	return
end if

CHOOSE CASE buttons[button_pressed]
	CASE "EDITUSER"
		popup.data_row_count = 1
		popup.items[1] = dw_users.object.user_id[pl_row]
		openwithparm(w_user_definition, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		dw_users.object.user_full_name[pl_row] = popup_return.descriptions[1]
	CASE "EDITROLE"
		popup.item = dw_users.object.role_id[pl_row]
		openwithparm(w_role_definition, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		dw_users.object.role_name[pl_row] = popup_return.descriptions[1]
	CASE "INACTIVE"
		ls_license_flag = dw_users.object.license_flag[pl_row]
		if not isnull(ls_license_flag) then
			openwithparm(w_pop_yes_no, "You are about to make inactive a licensed user.  You will not be able to re-activate this user for " + string(reactdays) + " days.  Are you sure you want to do this?")
			popup_return = message.powerobjectparm
			if popup_return.item <> "YES" then return
		end if
		ls_user_id = dw_users.object.user_id[pl_row]
		user_list.inactivate_user(ls_user_id)
	CASE "ACTIVE"
		ls_user_id = dw_users.object.user_id[pl_row]
		user_list.activate_user(ls_user_id)
	CASE "RESET"
		popup.dataobject = "dw_user_active_computer_list"
		popup.datacolumn = 2
		popup.displaycolumn = 3
		popup.argument_count = 2
		popup.argument[1] = ls_user_id
		popup.argument[2] = string(computer_id)
		popup.auto_singleton = true
		openwithparm(w_pop_pick, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		
		ll_picked_computer_id = long(popup_return.items[1])
		DELETE o_User_Service_Lock
		WHERE user_id = :ls_user_id
		AND computer_id = :ll_picked_computer_id;
		if not tf_check() then return
		DELETE o_Users
		WHERE user_id = :ls_user_id
		AND computer_id = :ll_picked_computer_id;
		if not tf_check() then return
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return


end subroutine

on u_users_edit.create
this.st_license_flag=create st_license_flag
this.st_license_flag_title=create st_license_flag_title
this.st_page=create st_page
this.pb_down=create pb_down
this.pb_up=create pb_up
this.st_radio_other=create st_radio_other
this.cb_new=create cb_new
this.dw_users=create dw_users
this.st_radio_roles=create st_radio_roles
this.st_radio_inactive=create st_radio_inactive
this.r_1=create r_1
this.st_radio_active=create st_radio_active
this.Control[]={this.st_license_flag,&
this.st_license_flag_title,&
this.st_page,&
this.pb_down,&
this.pb_up,&
this.st_radio_other,&
this.cb_new,&
this.dw_users,&
this.st_radio_roles,&
this.st_radio_inactive,&
this.r_1,&
this.st_radio_active}
end on

on u_users_edit.destroy
destroy(this.st_license_flag)
destroy(this.st_license_flag_title)
destroy(this.st_page)
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.st_radio_other)
destroy(this.cb_new)
destroy(this.dw_users)
destroy(this.st_radio_roles)
destroy(this.st_radio_inactive)
destroy(this.r_1)
destroy(this.st_radio_active)
end on

type st_license_flag from statictext within u_users_edit
integer x = 105
integer y = 284
integer width = 457
integer height = 108
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "All"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return


popup.data_row_count = 4
popup.items[1] = "Physician"
popup.items[2] = "Extender"
popup.items[3] = "Staff"
popup.items[4] = "All"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

text = popup_return.items[1]

CHOOSE CASE popup_return.item_indexes[1]
	CASE 1
		license_flag = "P"
	CASE 2
		license_flag = "E"
	CASE 3
		license_flag = "S"
	CASE 4
		license_flag = "%"
END CHOOSE

refresh_users()


end event

type st_license_flag_title from statictext within u_users_edit
integer x = 105
integer y = 212
integer width = 457
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Provider Class"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_page from statictext within u_users_edit
integer x = 1838
integer y = 60
integer width = 306
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Page 99/99"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_down from u_picture_button within u_users_edit
integer x = 1861
integer y = 156
integer width = 137
integer height = 116
integer taborder = 20
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_users.current_page
li_last_page = dw_users.last_page

dw_users.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true
end event

type pb_up from u_picture_button within u_users_edit
integer x = 2048
integer y = 156
integer width = 137
integer height = 116
integer taborder = 21
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_users.current_page

dw_users.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type st_radio_other from u_st_radio_user_role within u_users_edit
integer x = 105
integer y = 1192
integer width = 457
integer height = 108
boolean bringtotop = true
string text = "Other"
end type

event clicked;call super::clicked;display_status = "OTHER"
refresh_users()

end event

type cb_new from commandbutton within u_users_edit
integer x = 133
integer y = 1524
integer width = 357
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New User"
end type

event clicked;str_popup popup

if display_status = "ROLE" then
	setnull(popup.item)
	openwithparm(w_role_definition, popup)
else
	popup.data_row_count = 0
	openwithparm(w_user_definition, popup)
end if

refresh_users()

end event

type dw_users from u_dw_pick_list within u_users_edit
integer x = 677
integer y = 120
integer width = 1120
integer height = 1548
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_user_list_by_provider_class"
boolean border = false
boolean livescroll = false
end type

event constructor;call super::constructor;settransobject(sqlca)

end event

event selected;call super::selected;if not display_only then user_menu(selected_row)
clear_selected()

end event

type st_radio_roles from u_st_radio_user_role within u_users_edit
event clicked pbm_bnclicked
integer x = 105
integer y = 992
integer width = 457
integer height = 108
boolean bringtotop = true
string text = "Roles"
end type

event clicked;call super::clicked;display_status = "ROLE"
refresh_users()

end event

type st_radio_inactive from u_st_radio_user_role within u_users_edit
event clicked pbm_bnclicked
integer x = 105
integer y = 792
integer width = 457
integer height = 108
boolean bringtotop = true
string text = "Inactive Users"
end type

event clicked;call super::clicked;display_status = "NA"
refresh_users()

end event

type r_1 from rectangle within u_users_edit
integer linethickness = 4
long fillcolor = 33538240
integer x = 59
integer y = 540
integer width = 553
integer height = 808
end type

type st_radio_active from u_st_radio_user_role within u_users_edit
event clicked pbm_bnclicked
integer x = 105
integer y = 592
integer width = 457
integer height = 108
string text = "Active Users"
end type

event clicked;call super::clicked;display_status = "OK"
refresh_users()

end event

