$PBExportHeader$w_svc_config_service.srw
forward
global type w_svc_config_service from w_window_base
end type
type st_service_type_title from statictext within w_svc_config_service
end type
type st_service_type from statictext within w_svc_config_service
end type
type dw_services from u_dw_pick_list within w_svc_config_service
end type
type st_secure_flag_title from statictext within w_svc_config_service
end type
type st_secure_flag from statictext within w_svc_config_service
end type
type dw_access from u_dw_pick_list within w_svc_config_service
end type
type pb_access_up from u_picture_button within w_svc_config_service
end type
type pb_access_down from u_picture_button within w_svc_config_service
end type
type st_2 from statictext within w_svc_config_service
end type
type cb_exit from commandbutton within w_svc_config_service
end type
type cb_new_access from commandbutton within w_svc_config_service
end type
type st_access_page from statictext within w_svc_config_service
end type
type st_access_title from statictext within w_svc_config_service
end type
type cb_configure from commandbutton within w_svc_config_service
end type
type cb_define_params from commandbutton within w_svc_config_service
end type
type st_1 from statictext within w_svc_config_service
end type
type st_expiration from statictext within w_svc_config_service
end type
type cb_change_expiration from commandbutton within w_svc_config_service
end type
type cb_new_service from commandbutton within w_svc_config_service
end type
end forward

global type w_svc_config_service from w_window_base
integer width = 2944
integer height = 1848
boolean titlebar = false
string title = ""
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_service_type_title st_service_type_title
st_service_type st_service_type
dw_services dw_services
st_secure_flag_title st_secure_flag_title
st_secure_flag st_secure_flag
dw_access dw_access
pb_access_up pb_access_up
pb_access_down pb_access_down
st_2 st_2
cb_exit cb_exit
cb_new_access cb_new_access
st_access_page st_access_page
st_access_title st_access_title
cb_configure cb_configure
cb_define_params cb_define_params
st_1 st_1
st_expiration st_expiration
cb_change_expiration cb_change_expiration
cb_new_service cb_new_service
end type
global w_svc_config_service w_svc_config_service

type variables
string service_type

u_component_service config_service


end variables

forward prototypes
public function integer show_services ()
public subroutine access_menu (long pl_row)
end prototypes

public function integer show_services ();long ll_rows

CHOOSE CASE service_type
	CASE "General"
		ll_rows = dw_services.retrieve("Y", "%", "%", "%", "%", "%", "%")
	CASE "Patient"
		ll_rows = dw_services.retrieve("%", "Y", "%", "%", "%", "%", "%")
	CASE "Encounter"
		ll_rows = dw_services.retrieve("%", "%", "Y", "%", "%", "%", "%")
	CASE "Treatment"
		ll_rows = dw_services.retrieve("%", "%", "%", "Y", "%", "%", "%")
	CASE "Assessment"
		ll_rows = dw_services.retrieve("%", "%", "%", "%", "Y", "%", "%")
	CASE "Observation"
		ll_rows = dw_services.retrieve("%", "%", "%", "%", "%", "Y", "%")
	CASE "Attachment"
		ll_rows = dw_services.retrieve("%", "%", "%", "%", "%", "%", "Y")
END CHOOSE



return 1

end function

public subroutine access_menu (long pl_row);u_component_service luo_service
str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons
string ls_user_id
integer li_update_flag
string ls_temp
string ls_access_flag
string ls_null

setnull(ls_null)

ls_access_flag = dw_access.object.access_flag[pl_row]

if ls_access_flag = "G" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_revoke.bmp"
	popup.button_helps[popup.button_count] = "Revoke Access"
	popup.button_titles[popup.button_count] = "Revoke Access"
	buttons[popup.button_count] = "REVOKE"
else
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_grant.bmp"
	popup.button_helps[popup.button_count] = "Grant Access"
	popup.button_titles[popup.button_count] = "Grant Access"
	buttons[popup.button_count] = "GRANT"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Delete Workplan Item"
	popup.button_titles[popup.button_count] = "Delete Item"
	buttons[popup.button_count] = "DELETE"
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
	CASE "GRANT"
		dw_access.object.access_flag[pl_row] = "G"
	CASE "REVOKE"
		dw_access.object.access_flag[pl_row] = "R"
	CASE "DELETE"
		ls_temp = "Are you sure you wish to delete the access record for " + dw_access.object.compute_name[pl_row] + "?"
		openwithparm(w_pop_yes_no, ls_temp)
		popup_return = message.powerobjectparm
		if popup_return.item = "YES" then
			dw_access.deleterow(pl_row)
		end if
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

dw_access.update()

return


end subroutine

on w_svc_config_service.create
int iCurrent
call super::create
this.st_service_type_title=create st_service_type_title
this.st_service_type=create st_service_type
this.dw_services=create dw_services
this.st_secure_flag_title=create st_secure_flag_title
this.st_secure_flag=create st_secure_flag
this.dw_access=create dw_access
this.pb_access_up=create pb_access_up
this.pb_access_down=create pb_access_down
this.st_2=create st_2
this.cb_exit=create cb_exit
this.cb_new_access=create cb_new_access
this.st_access_page=create st_access_page
this.st_access_title=create st_access_title
this.cb_configure=create cb_configure
this.cb_define_params=create cb_define_params
this.st_1=create st_1
this.st_expiration=create st_expiration
this.cb_change_expiration=create cb_change_expiration
this.cb_new_service=create cb_new_service
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_service_type_title
this.Control[iCurrent+2]=this.st_service_type
this.Control[iCurrent+3]=this.dw_services
this.Control[iCurrent+4]=this.st_secure_flag_title
this.Control[iCurrent+5]=this.st_secure_flag
this.Control[iCurrent+6]=this.dw_access
this.Control[iCurrent+7]=this.pb_access_up
this.Control[iCurrent+8]=this.pb_access_down
this.Control[iCurrent+9]=this.st_2
this.Control[iCurrent+10]=this.cb_exit
this.Control[iCurrent+11]=this.cb_new_access
this.Control[iCurrent+12]=this.st_access_page
this.Control[iCurrent+13]=this.st_access_title
this.Control[iCurrent+14]=this.cb_configure
this.Control[iCurrent+15]=this.cb_define_params
this.Control[iCurrent+16]=this.st_1
this.Control[iCurrent+17]=this.st_expiration
this.Control[iCurrent+18]=this.cb_change_expiration
this.Control[iCurrent+19]=this.cb_new_service
end on

on w_svc_config_service.destroy
call super::destroy
destroy(this.st_service_type_title)
destroy(this.st_service_type)
destroy(this.dw_services)
destroy(this.st_secure_flag_title)
destroy(this.st_secure_flag)
destroy(this.dw_access)
destroy(this.pb_access_up)
destroy(this.pb_access_down)
destroy(this.st_2)
destroy(this.cb_exit)
destroy(this.cb_new_access)
destroy(this.st_access_page)
destroy(this.st_access_title)
destroy(this.cb_configure)
destroy(this.cb_define_params)
destroy(this.st_1)
destroy(this.st_expiration)
destroy(this.cb_change_expiration)
destroy(this.cb_new_service)
end on

event open;call super::open;
config_service = message.powerobjectparm

service_type = "Encounter"
st_service_type.text = service_type

dw_services.settransobject(sqlca)

dw_services.object.description.width = dw_services.width - 137

if user_list.is_user_privileged(current_scribe.user_id, "Edit System Config") then
	cb_new_service.visible = true
else
	cb_new_service.visible = false
end if

show_services()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_config_service
boolean visible = true
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_config_service
end type

type st_service_type_title from statictext within w_svc_config_service
integer x = 224
integer y = 52
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Service Type:"
boolean focusrectangle = false
end type

type st_service_type from statictext within w_svc_config_service
integer x = 635
integer y = 36
integer width = 549
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Encounter"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.data_row_count = 7
popup.items[1] = "General"
popup.items[2] = "Patient"
popup.items[3] = "Encounter"
popup.items[4] = "Assessment"
popup.items[5] = "Treatment"
popup.items[6] = "Observation"
popup.items[7] = "Attachment"

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm

if popup_return.item_count = 0 then return

text = popup_return.items[1]
service_type = text

show_services()

end event

type dw_services from u_dw_pick_list within w_svc_config_service
integer x = 55
integer y = 168
integer width = 1385
integer height = 1496
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_service_by_type_list"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;string ls_service
string ls_secure_flag
long ll_expiration_amount
string ls_expiration_unit_id
real lr_amount

ls_service = object.service[selected_row]

dw_access.settransobject(sqlca)
dw_access.retrieve(ls_service)

ls_secure_flag = object.secure_flag[selected_row]
if ls_secure_flag = "Y" then
	st_secure_flag.text = "Don't Allow"
else
	ls_secure_flag = "N"
	st_secure_flag.text = "Allow"
end if

st_secure_flag.enabled = true
cb_new_access.enabled = true

cb_define_params.enabled = true
cb_configure.enabled = true

dw_access.last_page = 0
dw_access.set_page(1, pb_access_up, pb_access_down, st_access_page)

ll_expiration_amount = object.default_expiration_time[selected_row]
ls_expiration_unit_id = object.default_expiration_unit_id[selected_row]

lr_amount = real(ll_expiration_amount)
st_expiration.text = f_pretty_amount_unit(lr_amount, ls_expiration_unit_id)
cb_change_expiration.enabled = true

end event

event unselected;call super::unselected;st_secure_flag.text = ""
st_secure_flag.enabled = false
dw_access.reset()
cb_new_access.enabled = false

pb_access_up.visible = false
pb_access_down.visible = false
st_access_page.visible = false

cb_define_params.enabled = false
cb_configure.enabled = false

st_expiration.text = ""
cb_change_expiration.enabled = false

end event

type st_secure_flag_title from statictext within w_svc_config_service
integer x = 1614
integer y = 144
integer width = 494
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Default Security:"
boolean focusrectangle = false
end type

type st_secure_flag from statictext within w_svc_config_service
integer x = 2107
integer y = 128
integer width = 489
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;long ll_row
integer li_sts

ll_row = dw_services.get_selected_row()
if ll_row <= 0 then return

if text = "Allow" then
	dw_services.object.secure_flag[ll_row] = "Y"
	text = "Don't Allow"
else
	dw_services.object.secure_flag[ll_row] = "N"
	text = "Allow"
end if

li_sts = dw_services.update()
if li_sts < 0 then 
	log.log(this, "w_svc_config_service.st_secure_flag.clicked:0017", "Update unsuccessful for " + dw_services.object.service[ll_row], 4)
end if

end event

type dw_access from u_dw_pick_list within w_svc_config_service
integer x = 1513
integer y = 352
integer width = 1216
integer height = 816
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_service_access_list"
end type

event selected;call super::selected;access_menu(selected_row)
clear_selected()

end event

type pb_access_up from u_picture_button within w_svc_config_service
integer x = 2743
integer y = 360
integer width = 137
integer height = 116
integer taborder = 40
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;string ls_temp
integer li_page

li_page = dw_access.current_page

dw_access.set_page(li_page - 1, st_access_page.text)

if li_page <= 2 then enabled = false
pb_access_down.enabled = true

end event

type pb_access_down from u_picture_button within w_svc_config_service
integer x = 2743
integer y = 492
integer width = 137
integer height = 116
integer taborder = 50
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;string ls_temp
integer li_page
integer li_last_page

li_page = dw_access.current_page
li_last_page = dw_access.last_page

dw_access.set_page(li_page + 1, st_access_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_access_up.enabled = true

end event

type st_2 from statictext within w_svc_config_service
integer x = 1509
integer y = 1176
integer width = 1221
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "G = Grant     R = Revoke"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_exit from commandbutton within w_svc_config_service
integer x = 2528
integer y = 1684
integer width = 352
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Exit"
end type

event clicked;
//user_list.refresh_security()

close(parent)

end event

type cb_new_access from commandbutton within w_svc_config_service
integer x = 1806
integer y = 1264
integer width = 649
integer height = 112
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Access Record"
end type

event clicked;string ls_service
string ls_access_flag
long ll_row
string ls_secure_flag
string ls_role_name
string ls_user_full_name
string ls_null
u_user luo_user

setnull(ls_null)

ll_row = dw_services.get_selected_row()
if ll_row <= 0 then return

ls_service = dw_services.object.service[ll_row]
ls_secure_flag = dw_services.object.secure_flag[ll_row]
if ls_secure_flag = "Y" then
	ls_access_flag = "G"
else
	ls_access_flag = "R"
end if

luo_user = user_list.pick_user(true, false, false)
if isnull(luo_user) then return

// Now create the new access record
dw_access.setredraw(false)

ll_row = dw_access.insertrow(0)
dw_access.object.user_id[ll_row] = luo_user.user_id
dw_access.object.office_id[ll_row] = office_id
dw_access.object.service[ll_row] = ls_service
dw_access.object.access_flag[ll_row] = ls_access_flag
dw_access.object.created[ll_row] = datetime(today(), now())
dw_access.object.created_by[ll_row] = current_scribe.user_id

if left(luo_user.user_id, 1) = "!" then
	dw_access.object.role_name[ll_row] = luo_user.user_full_name
	dw_access.object.role_color[ll_row] = luo_user.color
	dw_access.object.user_full_name[ll_row] = ls_null
else
	dw_access.object.user_full_name[ll_row] = luo_user.user_full_name
	dw_access.object.user_color[ll_row] = luo_user.color
	dw_access.object.role_name[ll_row] = ls_null
end if

// Update the database
dw_access.update()

dw_access.setredraw(true)

end event

type st_access_page from statictext within w_svc_config_service
integer x = 2560
integer y = 292
integer width = 311
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Page 99/99"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_access_title from statictext within w_svc_config_service
integer x = 1518
integer y = 284
integer width = 1221
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Access List"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_configure from commandbutton within w_svc_config_service
integer x = 704
integer y = 1684
integer width = 649
integer height = 112
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Configure Service"
end type

event clicked;long ll_row
str_popup popup
str_popup_return popup_return
string ls_service
string ls_specialty_id

ll_row = dw_services.get_selected_row()
if ll_row <= 0 then return

ls_service = dw_services.object.service[ll_row]

// See what specialty to configure this service for
ls_specialty_id = f_pick_specialty("<Default Settings>")
if isnull(ls_specialty_id) then return

if ls_specialty_id = "<Default Settings>" then
	setnull(ls_specialty_id)
end if

f_configure_service(ls_service, ls_specialty_id, service_type)



end event

type cb_define_params from commandbutton within w_svc_config_service
integer x = 37
integer y = 1684
integer width = 649
integer height = 112
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Define Service Atributes"
end type

event clicked;str_popup popup
str_popup_return popup_return

long ll_row
string ls_service
string ls_id

ll_row = dw_services.get_selected_row()
if ll_row <= 0 then return

ls_service = dw_services.object.service[ll_row]
ls_id = dw_services.object.id[ll_row]

popup.data_row_count = 3
popup.items[1] = "Define Config Attributes"
popup.items[2] = "Define Order Attributes"
popup.items[3] = "Define Runtime Attributes"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

popup.data_row_count = 2
popup.items[1] = ls_id
if popup_return.item_indexes[1] = 1 then
	popup.items[2] = "Config"
elseif popup_return.item_indexes[1] = 2 then
	popup.items[2] = "Order"
else
	popup.items[2] = "Runtime"
end if

openwithparm(w_component_params_edit, popup)

refresh()

end event

type st_1 from statictext within w_svc_config_service
integer x = 1467
integer y = 1504
integer width = 347
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Expiration:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_expiration from statictext within w_svc_config_service
integer x = 1829
integer y = 1500
integer width = 631
integer height = 88
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type cb_change_expiration from commandbutton within w_svc_config_service
integer x = 2469
integer y = 1508
integer width = 219
integer height = 76
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Change"
end type

event clicked;integer li_sts
str_popup popup
str_popup_return popup_return
string ls_time, ls_unit
long ll_row
string ls_expiration_unit_id
long ll_expiration_time
real lr_time

ll_row = dw_services.get_selected_row()
if ll_row <= 0 then return

// Parameters (popup.):
// title					Screen title/user instructions
// item					Default string value
//	data_row_count		Number of items in the canned selections list
// items[]				list of canned selections
// argument_count		Number of top_20 arguments supplied
// argument[]			List of top_20 arguments
//							argument[1] = specific top_20_code
//							argument[2] = generic top_20_code
// multiselect			True = Allow empty string
//							False = Don't allow empty string
//

popup.title = "Enter Default Expiration Time"
popup.item = st_expiration.text
popup.argument_count = 1
popup.argument[1] = "SVCDefaultExpirationTime"
popup.multiselect = false

openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

setnull(ls_expiration_unit_id)
f_split_string(popup_return.items[1], " ", ls_time, ls_unit)

if isnumber(ls_time) then
	ll_expiration_time = long(ls_time)
	ls_unit = upper(trim(ls_unit))
	CHOOSE CASE left(ls_unit, 1)
		CASE "S"
			ls_expiration_unit_id = "Second"
		CASE "M"
			IF mid(ls_unit, 2, 1) = "I" then
				ls_expiration_unit_id = "Minute"
			elseif mid(ls_unit, 2, 1) = "O" then
				ls_expiration_unit_id = "Month"
			else
			end if
		CASE "H"
			ls_expiration_unit_id = "Hour"
		CASE "D"
			ls_expiration_unit_id = "Day"
		CASE "Y"
			ls_expiration_unit_id = "Year"
	END CHOOSE
end if

if isnull(ls_expiration_unit_id) then
	openwithparm(w_pop_message, "The expiration time entered is not recognized.  Please enter a number and a unit of time (~"Hours~", ~"Minutes~", ~"Days~", ~"Months~", ~"Years~")")
	return
end if

dw_services.object.default_expiration_time[ll_row] = ll_expiration_time
dw_services.object.default_expiration_unit_id[ll_row] = ls_expiration_unit_id

li_sts = dw_services.update()
if li_sts < 0 then return

lr_time = real(ll_expiration_time)
st_expiration.text = f_pretty_amount_unit(lr_time, ls_expiration_unit_id)


end event

type cb_new_service from commandbutton within w_svc_config_service
integer x = 1669
integer y = 1684
integer width = 489
integer height = 112
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Service"
end type

event clicked;string ls_new_service

ls_new_service = f_new_service()
if isnull(ls_new_service) then
	openwithparm(w_pop_message, "An error occured and a new service has not been created.  See the error log  for more information.")
	return
end if

openwithparm(w_pop_message, "New service has been successfully created")

show_services()

end event

