HA$PBExportHeader$u_tabpage_treatment_type_services.sru
forward
global type u_tabpage_treatment_type_services from u_tabpage
end type
type st_past_title from statictext within u_tabpage_treatment_type_services
end type
type st_other_services_title from statictext within u_tabpage_treatment_type_services
end type
type st_page from statictext within u_tabpage_treatment_type_services
end type
type pb_up from picturebutton within u_tabpage_treatment_type_services
end type
type pb_down from picturebutton within u_tabpage_treatment_type_services
end type
type cb_add_other_service from commandbutton within u_tabpage_treatment_type_services
end type
type st_after_title from statictext within u_tabpage_treatment_type_services
end type
type st_before_title from statictext within u_tabpage_treatment_type_services
end type
type st_svc_title from statictext within u_tabpage_treatment_type_services
end type
type dw_services from u_dw_pick_list within u_tabpage_treatment_type_services
end type
end forward

global type u_tabpage_treatment_type_services from u_tabpage
integer width = 2802
integer height = 1000
st_past_title st_past_title
st_other_services_title st_other_services_title
st_page st_page
pb_up pb_up
pb_down pb_down
cb_add_other_service cb_add_other_service
st_after_title st_after_title
st_before_title st_before_title
st_svc_title st_svc_title
dw_services dw_services
end type
global u_tabpage_treatment_type_services u_tabpage_treatment_type_services

type variables
string treatment_type

end variables

forward prototypes
public subroutine refresh ()
public subroutine service_menu (long pl_row)
public function integer initialize (string ps_key)
public function integer configure_service (long pl_row)
end prototypes

public subroutine refresh ();dw_services.settransobject(sqlca)
dw_services.retrieve(treatment_type)

dw_services.set_page(1, pb_up, pb_down, st_page)


end subroutine

public subroutine service_menu (long pl_row);str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons
string ls_user_id
integer li_update_flag
string ls_temp


if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit Treatment Type Service Attributes"
	popup.button_titles[popup.button_count] = "Edit Service"
	buttons[popup.button_count] = "EDIT"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Configure Treatment Type Service"
	popup.button_titles[popup.button_count] = "Configure Service"
	buttons[popup.button_count] = "CONFIGURE"
end if

if dw_services.rowcount() > 1 then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonmove.bmp"
	popup.button_helps[popup.button_count] = "Move record up or down"
	popup.button_titles[popup.button_count] = "Move"
	buttons[popup.button_count] = "MOVE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Remove Treatment Type Service Mapping"
	popup.button_titles[popup.button_count] = "Remove Service"
	buttons[popup.button_count] = "REMOVE"
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
	CASE "EDIT"
		popup.data_row_count = 7
		popup.items[1] = dw_services.object.before_flag[pl_row]
		popup.items[2] = dw_services.object.after_flag[pl_row]
		popup.items[3] = dw_services.object.button[pl_row]
		popup.items[4] = dw_services.object.button_help[pl_row]
		popup.items[5] = dw_services.object.button_title[pl_row]
		popup.items[6] = dw_services.object.observation_tag[pl_row]
		popup.items[7] = dw_services.object.auto_perform_flag[pl_row]
		openwithparm(w_treatment_type_service_edit, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 7 then return
		dw_services.object.before_flag[pl_row] = popup_return.items[1]
		dw_services.object.after_flag[pl_row] = popup_return.items[2]
		dw_services.object.button[pl_row] = popup_return.items[3]
		dw_services.object.button_help[pl_row] = popup_return.items[4]
		dw_services.object.button_title[pl_row] = popup_return.items[5]
		dw_services.object.observation_tag[pl_row] = popup_return.items[6]
		dw_services.object.auto_perform_flag[pl_row] = popup_return.items[7]
		dw_services.update()
	CASE "CONFIGURE"
		li_sts = configure_service(pl_row)
	CASE "REMOVE"
		ls_temp = "Are you sure you wish to remove the service '" + dw_services.object.service_description[pl_row] + "' from this treatment type?"
		openwithparm(w_pop_yes_no, ls_temp)
		popup_return = message.powerobjectparm
		if popup_return.item = "YES" then
			dw_services.deleterow(pl_row)
			dw_services.update()
		end if
	CASE "MOVE"
		popup.objectparm = dw_services
		popup.objectparm2 = st_page
		popup.item = "SAVE"
		openwithparm(w_pick_list_sort, popup)
		if dw_services.current_page > 1 then
			pb_up.enabled = true
		else
			pb_up.enabled = false
		end if
		if dw_services.current_page < dw_services.last_page then
			pb_down.enabled = true
		else
			pb_down.enabled = false
		end if
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return


end subroutine

public function integer initialize (string ps_key);treatment_type = ps_key

return 1

end function

public function integer configure_service (long pl_row);string ls_service
long ll_service_sequence
integer li_sts
long i
long ll_rows
str_attributes lstr_attributes
str_popup_return popup_return
string ls_service_id
u_ds_data luo_data

// Get the item number
ll_service_sequence = dw_services.object.service_sequence[pl_row]
if isnull(ll_service_sequence) then return 0

// Get the service component object
ls_service = dw_services.object.service[pl_row]
if isnull(ls_service) then
	log.log(this, "configure_service()", "Null service", 4)
	return -1
end if

ls_service_id = datalist.service_id(ls_service)
if isnull(ls_service_id) then
	log.log(this, "configure_service()", "Service not found (" + ls_service + ")", 4)
	return -1
end if

// Get the existing params
luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_c_Treatment_Type_Service")
ll_rows = luo_data.retrieve(treatment_type, ll_service_sequence)

// Convert the params into a structure
f_attribute_ds_to_str(luo_data, lstr_attributes)

// Make sure the param screens know the context
f_attribute_add_attribute(lstr_attributes, "context_object", "treatment")

// Get the config params from the user
li_sts = f_get_params(ls_service_id, "Order", lstr_attributes)
if li_sts < 0 then return 0

// Copy the new config attributes to the attributes datastore
f_attribute_str_to_ds_with_removal(lstr_attributes, luo_data)

// Add the keys to any new records
ll_rows = luo_data.rowcount()
for i = 1 to ll_rows
	if isnull(long(luo_data.object.service_sequence[i])) then
		luo_data.object.treatment_type[i] = treatment_type
		luo_data.object.service_sequence[i] = ll_service_sequence
	end if
next

li_sts = luo_data.update()
if li_sts < 0 then
	log.log(this, "configure_service()", "Error updating attributes", 4)
	return -1
end if

return 1

end function

on u_tabpage_treatment_type_services.create
int iCurrent
call super::create
this.st_past_title=create st_past_title
this.st_other_services_title=create st_other_services_title
this.st_page=create st_page
this.pb_up=create pb_up
this.pb_down=create pb_down
this.cb_add_other_service=create cb_add_other_service
this.st_after_title=create st_after_title
this.st_before_title=create st_before_title
this.st_svc_title=create st_svc_title
this.dw_services=create dw_services
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_past_title
this.Control[iCurrent+2]=this.st_other_services_title
this.Control[iCurrent+3]=this.st_page
this.Control[iCurrent+4]=this.pb_up
this.Control[iCurrent+5]=this.pb_down
this.Control[iCurrent+6]=this.cb_add_other_service
this.Control[iCurrent+7]=this.st_after_title
this.Control[iCurrent+8]=this.st_before_title
this.Control[iCurrent+9]=this.st_svc_title
this.Control[iCurrent+10]=this.dw_services
end on

on u_tabpage_treatment_type_services.destroy
call super::destroy
destroy(this.st_past_title)
destroy(this.st_other_services_title)
destroy(this.st_page)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.cb_add_other_service)
destroy(this.st_after_title)
destroy(this.st_before_title)
destroy(this.st_svc_title)
destroy(this.dw_services)
end on

type st_past_title from statictext within u_tabpage_treatment_type_services
integer x = 2002
integer y = 96
integer width = 174
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Past"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_other_services_title from statictext within u_tabpage_treatment_type_services
integer x = 1019
integer y = 24
integer width = 718
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 33538240
boolean enabled = false
string text = "Other Services"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_page from statictext within u_tabpage_treatment_type_services
integer x = 2190
integer y = 412
integer width = 247
integer height = 56
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "99 of 99"
boolean focusrectangle = false
end type

type pb_up from picturebutton within u_tabpage_treatment_type_services
integer x = 2185
integer y = 164
integer width = 137
integer height = 116
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
alignment htextalign = left!
end type

event clicked;integer li_page

li_page = dw_services.current_page

dw_services.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from picturebutton within u_tabpage_treatment_type_services
integer x = 2185
integer y = 288
integer width = 137
integer height = 116
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
alignment htextalign = left!
end type

event clicked;integer li_page
integer li_last_page

li_page = dw_services.current_page
li_last_page = dw_services.last_page

dw_services.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type cb_add_other_service from commandbutton within u_tabpage_treatment_type_services
integer x = 2258
integer y = 860
integer width = 443
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add Service "
end type

event clicked;long ll_row
long i
string ls_service

openwithparm(w_pick_service, "Treatment")
ls_service = message.stringparm
if isnull(ls_service) then return

for i = 1 to dw_services.rowcount()
	dw_services.object.sort_sequence[i] = i
next

ll_row = dw_services.insertrow(0)
dw_services.object.treatment_type[ll_row] = treatment_type
dw_services.object.service[ll_row] = ls_service
dw_services.object.before_flag[ll_row] = "N"
dw_services.object.after_flag[ll_row] = "Y"
dw_services.object.auto_perform_flag[ll_row] = "N"
dw_services.object.button[ll_row] = datalist.service_button(ls_service)
dw_services.object.button_help[ll_row] = datalist.service_description(ls_service)
dw_services.object.button_title[ll_row] = datalist.service_description(ls_service)
dw_services.object.service_description[ll_row] = datalist.service_description(ls_service)
dw_services.object.sort_sequence[ll_row] = ll_row

dw_services.update()

dw_services.recalc_page(st_page.text)
if dw_services.last_page < 2 then
	st_page.visible = false
	pb_up.visible = false
	pb_down.visible = false
else
	dw_services.set_page(dw_services.last_page, st_page.text)
	st_page.visible = true
	pb_up.visible = true
	pb_down.visible = true
	pb_up.enabled = true
	pb_down.enabled = false
end if


end event

type st_after_title from statictext within u_tabpage_treatment_type_services
integer x = 1824
integer y = 96
integer width = 174
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "After"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_before_title from statictext within u_tabpage_treatment_type_services
integer x = 1627
integer y = 96
integer width = 206
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Before"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_svc_title from statictext within u_tabpage_treatment_type_services
integer x = 521
integer y = 96
integer width = 256
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Service"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_services from u_dw_pick_list within u_tabpage_treatment_type_services
integer x = 530
integer y = 156
integer width = 1650
integer height = 812
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_treatment_type_service_display_list"
boolean border = false
end type

event selected;call super::selected;service_menu(selected_row)
clear_selected()

end event

