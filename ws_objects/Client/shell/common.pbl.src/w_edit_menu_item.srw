$PBExportHeader$w_edit_menu_item.srw
forward
global type w_edit_menu_item from w_window_base
end type
type st_1 from statictext within w_edit_menu_item
end type
type st_2 from statictext within w_edit_menu_item
end type
type st_3 from statictext within w_edit_menu_item
end type
type st_4 from statictext within w_edit_menu_item
end type
type st_5 from statictext within w_edit_menu_item
end type
type st_item_type from statictext within w_edit_menu_item
end type
type st_item from statictext within w_edit_menu_item
end type
type sle_button_title from singlelineedit within w_edit_menu_item
end type
type sle_help from singlelineedit within w_edit_menu_item
end type
type sle_button from singlelineedit within w_edit_menu_item
end type
type st_title from statictext within w_edit_menu_item
end type
type st_6 from statictext within w_edit_menu_item
end type
type st_menu_description from statictext within w_edit_menu_item
end type
type dw_menu_item_attributes from u_dw_pick_list within w_edit_menu_item
end type
type st_menu_attributes_title from statictext within w_edit_menu_item
end type
type st_no_attributes from statictext within w_edit_menu_item
end type
type cb_finished from commandbutton within w_edit_menu_item
end type
type cb_cancel from commandbutton within w_edit_menu_item
end type
type st_auto_close_flag_title from statictext within w_edit_menu_item
end type
type st_auto_close_flag from statictext within w_edit_menu_item
end type
type st_authorized_user from statictext within w_edit_menu_item
end type
type st_7 from statictext within w_edit_menu_item
end type
type cb_1 from commandbutton within w_edit_menu_item
end type
end forward

global type w_edit_menu_item from w_window_base
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_1 st_1
st_2 st_2
st_3 st_3
st_4 st_4
st_5 st_5
st_item_type st_item_type
st_item st_item
sle_button_title sle_button_title
sle_help sle_help
sle_button sle_button
st_title st_title
st_6 st_6
st_menu_description st_menu_description
dw_menu_item_attributes dw_menu_item_attributes
st_menu_attributes_title st_menu_attributes_title
st_no_attributes st_no_attributes
cb_finished cb_finished
cb_cancel cb_cancel
st_auto_close_flag_title st_auto_close_flag_title
st_auto_close_flag st_auto_close_flag
st_authorized_user st_authorized_user
st_7 st_7
cb_1 cb_1
end type
global w_edit_menu_item w_edit_menu_item

type variables
str_menu_item original_menu_item
str_menu_item modified_menu_item

string menu_context_object

boolean updated

end variables

forward prototypes
public subroutine get_service ()
public subroutine get_treatment ()
public function integer configure_service ()
public subroutine refresh_attributes ()
public function integer save_changes ()
public function integer configure_treatment ()
public function integer configure_item ()
public function integer configure_treatment_type ()
end prototypes

public subroutine get_service ();integer li_sts
string ls_context_object
str_popup			popup
str_popup_return popup_return

// get the service type
popup.dataobject = "dw_v_Compatible_Context_Object"
popup.datacolumn = 1
popup.displaycolumn = 1
popup.argument_count = 1
popup.argument[1] = menu_context_object
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_context_object = popup_return.items[1]

popup.dataobject = "dw_sp_compatible_services"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = ls_context_object
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

modified_menu_item.menu_item = popup_return.items[1]
modified_menu_item.context_object = ls_context_object
modified_menu_item.button_title = popup_return.descriptions[1]
modified_menu_item.button_help = popup_return.descriptions[1]
modified_menu_item.button = datalist.service_button(popup_return.items[1])

st_item.text = popup_return.descriptions[1]
sle_button_title.text = modified_menu_item.button_title
sle_help.text = modified_menu_item.button_help
sle_button.text = modified_menu_item.button

// We need to save the changes before we configure the service
li_sts = save_changes()
if li_sts <= 0 then return

// Get the config params from the user
li_sts = configure_service()

refresh_attributes()

return

end subroutine

public subroutine get_treatment ();long ll_attribute_count
integer li_sts,i,j
string ls_treatment_type
u_ds_data luo_attributes
str_popup popup
str_popup_return popup_return
u_component_treatment luo_treatment_component
long ll_row

popup.dataobject = "dw_treatment_type_edit_list"
popup.datacolumn = 2
popup.displaycolumn = 4
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_treatment_type = popup_return.items[1]
if isnull(ls_treatment_type) then return

modified_menu_item.menu_item = ls_treatment_type
modified_menu_item.button = datalist.treatment_type_define_button(ls_treatment_type)
st_item.text = datalist.treatment_type_description(ls_treatment_type)
sle_button.text = modified_menu_item.button

luo_treatment_component = f_get_treatment_component(ls_treatment_type)
if isnull(luo_treatment_component) then
	log.log(this, "clicked", "Unable to get treatment object (" + ls_treatment_type + ")", 4)
	return
end if

li_sts = save_changes()
if li_sts <= 0 then return

li_sts = configure_treatment()
if li_sts <= 0 then return

refresh_attributes()


end subroutine

public function integer configure_service ();integer li_sts
long ll_display_command_id
string ls_service_id
str_attributes lstr_attributes
u_ds_data luo_data
string ls_context_object
string ls_display_command
long i
str_attributes lstr_state_attributes
string ls_param_mode

if isnull(modified_menu_item.menu_id) or modified_menu_item.menu_id <= 0 then return 0
if isnull(modified_menu_item.menu_item_id) or modified_menu_item.menu_item_id <= 0 then return 0

if isnull(modified_menu_item.menu_item_type) or upper(modified_menu_item.menu_item_type) <> "SERVICE" then return 0
if isnull(modified_menu_item.menu_item) then return 0

SELECT CAST(id as varchar(36))
INTO :ls_service_id
FROM o_Service
WHERE service = :modified_menu_item.menu_item;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then
	log.log(this, "configure_command()", "service not found (" + modified_menu_item.menu_item + ")", 4)
	return -1
end if


lstr_attributes.attribute_count = 0
f_attribute_dw_to_str(dw_menu_item_attributes, lstr_attributes)

// Add the config object to the state attributes
f_attribute_add_attribute(lstr_state_attributes, "context_object", modified_menu_item.context_object)
f_attribute_add_attribute(lstr_state_attributes, "parent_config_object_id", ls_service_id)
ls_param_mode = "Order"

li_sts = f_get_params_with_state(ls_service_id, ls_param_mode, lstr_attributes, lstr_state_attributes)
if li_sts < 0 then
	return 0
end if

// Get the existing attributes
luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_menu_item_attribute")
li_sts = luo_data.retrieve(modified_menu_item.menu_id, modified_menu_item.menu_item_id)

// Add/replace the new attributes, removing any attributes no longer referenced
f_attribute_str_to_ds_with_removal(lstr_attributes, luo_data)

// For any new records, add the key values
for i = 1 to luo_data.rowcount()
	if isnull(long(luo_data.object.menu_id[i])) then
		luo_data.object.menu_id[i] = modified_menu_item.menu_id
		luo_data.object.menu_item_id[i] = modified_menu_item.menu_item_id
	end if
next

// Update the attributes
li_sts = luo_data.update()
DESTROY luo_data
if li_sts < 0 then
	log.log(this, "configure_command()", "Error updating command attributes", 4)
	return -1
end if

return 1

end function

public subroutine refresh_attributes ();long ll_count

CHOOSE CASE upper(modified_menu_item.menu_item_type)
	CASE "MENU"
		dw_menu_item_attributes.visible = false
	CASE "SERVICE"
		dw_menu_item_attributes.visible = true
	CASE "TREATMENT"
		dw_menu_item_attributes.visible = true
	CASE "TREATMENT_LIST"
		dw_menu_item_attributes.visible = false
	CASE "TREATMENT_TYPE"
		dw_menu_item_attributes.visible = true
END CHOOSE

if dw_menu_item_attributes.visible then
	st_menu_attributes_title.visible = true
	dw_menu_item_attributes.settransobject(sqlca)
	ll_count = dw_menu_item_attributes.retrieve(modified_menu_item.menu_id, modified_menu_item.menu_item_id)
	if ll_count <= 0 then
		st_no_attributes.visible = true
	else
		st_no_attributes.visible = false
	end if
else
	st_menu_attributes_title.visible = false
	st_no_attributes.visible = false
end if


end subroutine

public function integer save_changes ();long ll_menu_item_id

if isnull(modified_menu_item.menu_item_id) then
	ll_menu_item_id = sqlca.sp_new_menu_item(modified_menu_item.menu_id, &
														modified_menu_item.menu_item_type , &
														modified_menu_item.menu_item , &
														modified_menu_item.button_title , &
														modified_menu_item.button_help , &
														modified_menu_item.button , &
														modified_menu_item.sort_sequence)
	if ll_menu_item_id <= 0 then return -1
	
	modified_menu_item.menu_item_id = ll_menu_item_id
	
	UPDATE c_Menu_Item
	SET auto_close_flag = :modified_menu_item.auto_close_flag,
		authorized_user_id = :modified_menu_item.authorized_user_id,
		context_object = :modified_menu_item.context_object
	WHERE menu_id = :modified_menu_item.menu_id
	AND menu_item_id = :modified_menu_item.menu_item_id;
	if not tf_check() then return -1
else
	UPDATE c_Menu_Item
	SET menu_item_type = :modified_menu_item.menu_item_type ,
		menu_item = :modified_menu_item.menu_item ,
		button_title = :modified_menu_item.button_title ,
		button_help = :modified_menu_item.button_help ,
		button = :modified_menu_item.button,
		auto_close_flag = :modified_menu_item.auto_close_flag ,
		authorized_user_id = :modified_menu_item.authorized_user_id,
		context_object = :modified_menu_item.context_object
	WHERE menu_id = :modified_menu_item.menu_id
	AND menu_item_id = :modified_menu_item.menu_item_id;
	if not tf_check() then return -1
end if

original_menu_item = modified_menu_item

updated = false

return 1


end function

public function integer configure_treatment ();long ll_attribute_count
integer li_sts,i,j
u_ds_data luo_attributes
str_popup popup
str_popup_return popup_return
u_component_treatment luo_treatment_component
long ll_row
boolean lb_past_treatment

if updated then
	li_sts = save_changes()
	if li_sts <= 0 then return -1
end if

luo_treatment_component = f_get_treatment_component(modified_menu_item.menu_item)
if isnull(luo_treatment_component) then
	log.log(this, "clicked", "Unable to get treatment object (" + modified_menu_item.menu_item + ")", 4)
	return -1
end if

li_sts = luo_treatment_component.define_treatment()
if li_sts <= 0 then
	component_manager.destroy_component(luo_treatment_component)
	return 0
end if

openwithparm(w_pop_yes_no, "Is this a past treatment?")
popup_return = message.powerobjectparm
if popup_return.item = "YES" then
	lb_past_treatment = true
else
	lb_past_treatment = false
end if

luo_attributes = CREATE u_ds_data
luo_attributes.set_dataobject("dw_menu_item_attribute")

/* need to be enhanced to accept multiples. for now we take only one treatment */		
if luo_treatment_component.treatment_count > 0 Then
	// We got one
	modified_menu_item.button_title = luo_treatment_component.treatment_definition[1].item_description
	modified_menu_item.button_help = luo_treatment_component.treatment_definition[1].item_description
	
	sle_button_title.text = modified_menu_item.button_title
	sle_help.text = modified_menu_item.button_help
	
	// Delete any existing attributes
	DELETE FROM c_menu_item_attribute
	WHERE menu_id = :modified_menu_item.menu_id
	AND menu_item_id = :modified_menu_item.menu_item_id;
	if not tf_check() then return -1
	
	ll_attribute_count = luo_treatment_component.treatment_definition[1].attribute_count
	for j = 1 to ll_attribute_count
		ll_row = luo_attributes.insertrow(0)
		luo_attributes.object.menu_id[ll_row] = modified_menu_item.menu_id
		luo_attributes.object.menu_item_id[ll_row] = modified_menu_item.menu_item_id
		luo_attributes.object.attribute[ll_row] = luo_treatment_component.treatment_definition[1].attribute[j]
		luo_attributes.object.value[ll_row] = luo_treatment_component.treatment_definition[1].value[j]
	next
	
	if lb_past_treatment then
		ll_row = luo_attributes.insertrow(0)
		luo_attributes.object.menu_id[ll_row] = modified_menu_item.menu_id
		luo_attributes.object.menu_item_id[ll_row] = modified_menu_item.menu_item_id
		luo_attributes.object.attribute[ll_row] = "past_treatment"
		luo_attributes.object.value[ll_row] = "True"
	end if
	
	li_sts = luo_attributes.update()
end if

component_manager.destroy_component(luo_treatment_component)

return 1

end function

public function integer configure_item ();integer li_sts
long ll_count

CHOOSE CASE upper(modified_menu_item.menu_item_type)
	CASE "SERVICE"
		li_sts = configure_service()
	CASE "TREATMENT"
		li_sts = configure_treatment()
	CASE "TREATMENT_TYPE"
		li_sts = configure_treatment_type()
END CHOOSE

refresh_attributes()

return li_sts


end function

public function integer configure_treatment_type ();long ll_attribute_count
integer li_sts,i,j
u_ds_data luo_attributes
str_popup popup
str_popup_return popup_return
long ll_row
boolean lb_past_treatment

if updated then
	li_sts = save_changes()
	if li_sts <= 0 then return -1
end if

openwithparm(w_pop_yes_no, "Is this a past treatment?")
popup_return = message.powerobjectparm
if popup_return.item = "YES" then
	lb_past_treatment = true
else
	lb_past_treatment = false
end if

luo_attributes = CREATE u_ds_data
luo_attributes.set_dataobject("dw_menu_item_attribute")

// Delete any existing attributes
DELETE FROM c_menu_item_attribute
WHERE menu_id = :modified_menu_item.menu_id
AND menu_item_id = :modified_menu_item.menu_item_id;
if not tf_check() then return -1

if lb_past_treatment then
	ll_row = luo_attributes.insertrow(0)
	luo_attributes.object.menu_id[ll_row] = modified_menu_item.menu_id
	luo_attributes.object.menu_item_id[ll_row] = modified_menu_item.menu_item_id
	luo_attributes.object.attribute[ll_row] = "past_treatment"
	luo_attributes.object.value[ll_row] = "True"
end if

li_sts = luo_attributes.update()

return 1

end function

on w_edit_menu_item.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.st_5=create st_5
this.st_item_type=create st_item_type
this.st_item=create st_item
this.sle_button_title=create sle_button_title
this.sle_help=create sle_help
this.sle_button=create sle_button
this.st_title=create st_title
this.st_6=create st_6
this.st_menu_description=create st_menu_description
this.dw_menu_item_attributes=create dw_menu_item_attributes
this.st_menu_attributes_title=create st_menu_attributes_title
this.st_no_attributes=create st_no_attributes
this.cb_finished=create cb_finished
this.cb_cancel=create cb_cancel
this.st_auto_close_flag_title=create st_auto_close_flag_title
this.st_auto_close_flag=create st_auto_close_flag
this.st_authorized_user=create st_authorized_user
this.st_7=create st_7
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.st_5
this.Control[iCurrent+6]=this.st_item_type
this.Control[iCurrent+7]=this.st_item
this.Control[iCurrent+8]=this.sle_button_title
this.Control[iCurrent+9]=this.sle_help
this.Control[iCurrent+10]=this.sle_button
this.Control[iCurrent+11]=this.st_title
this.Control[iCurrent+12]=this.st_6
this.Control[iCurrent+13]=this.st_menu_description
this.Control[iCurrent+14]=this.dw_menu_item_attributes
this.Control[iCurrent+15]=this.st_menu_attributes_title
this.Control[iCurrent+16]=this.st_no_attributes
this.Control[iCurrent+17]=this.cb_finished
this.Control[iCurrent+18]=this.cb_cancel
this.Control[iCurrent+19]=this.st_auto_close_flag_title
this.Control[iCurrent+20]=this.st_auto_close_flag
this.Control[iCurrent+21]=this.st_authorized_user
this.Control[iCurrent+22]=this.st_7
this.Control[iCurrent+23]=this.cb_1
end on

on w_edit_menu_item.destroy
call super::destroy
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.st_item_type)
destroy(this.st_item)
destroy(this.sle_button_title)
destroy(this.sle_help)
destroy(this.sle_button)
destroy(this.st_title)
destroy(this.st_6)
destroy(this.st_menu_description)
destroy(this.dw_menu_item_attributes)
destroy(this.st_menu_attributes_title)
destroy(this.st_no_attributes)
destroy(this.cb_finished)
destroy(this.cb_cancel)
destroy(this.st_auto_close_flag_title)
destroy(this.st_auto_close_flag)
destroy(this.st_authorized_user)
destroy(this.st_7)
destroy(this.cb_1)
end on

event open;call super::open;long ll_menu_id
str_menu_item lstr_menu_item

original_menu_item = message.powerobjectparm

// Make sure the auto_close_flag is valid
if original_menu_item.auto_close_flag = "" or isnull(original_menu_item.auto_close_flag) then
	original_menu_item.auto_close_flag = "N"
end if

// Initialize the modified menu item to the original menu_item
modified_menu_item = original_menu_item

updated = false

if isnull(original_menu_item.menu_id) or original_menu_item.menu_id <= 0 then
	log.log(this, "open()", "Menu id is not valid", 3)
	closewithreturn(this, original_menu_item)
	return
end if

SELECT description, context_object
INTO :st_menu_description.text, :menu_context_object
FROM c_Menu
WHERE menu_id = :original_menu_item.menu_id;
if not tf_check() then
	closewithreturn(this, original_menu_item)
	return
end if

// If the menu context object is null then assume Patient
if isnull(menu_context_object) then menu_context_object = "Patient"

postevent("post_open")

end event

event post_open;call super::post_open;string ls_menu_desc
long ll_menu_id
integer li_return


st_item_type.text = original_menu_item.menu_item_type
st_item.text = original_menu_item.menu_item_description
sle_button_title.text = original_menu_item.button_title
sle_help.text = original_menu_item.button_help
sle_button.text = original_menu_item.button
if isnull(original_menu_item.authorized_user_id) then
	st_authorized_user.text = "<All>"
	st_authorized_user.backcolor = color_object
else
	st_authorized_user.text = user_list.user_short_name(original_menu_item.authorized_user_id)
	st_authorized_user.backcolor = user_list.user_color(original_menu_item.authorized_user_id)
end if

st_auto_close_flag.text = datalist.domain_item_description("Menu Auto Close", original_menu_item.auto_close_flag)

refresh_attributes()

// if we don't have a menu_item_type then go ahead and click it for the user
if isnull(original_menu_item.menu_item_type) then
	st_item_type.event POST clicked()
end if

end event

type pb_epro_help from w_window_base`pb_epro_help within w_edit_menu_item
boolean visible = true
integer x = 2624
integer y = 28
integer textsize = -18
integer weight = 700
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_edit_menu_item
end type

type st_1 from statictext within w_edit_menu_item
integer x = 151
integer y = 296
integer width = 626
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Menu Item Type:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_edit_menu_item
integer x = 151
integer y = 444
integer width = 626
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Menu Item:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_edit_menu_item
integer x = 151
integer y = 592
integer width = 626
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Button Title:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_4 from statictext within w_edit_menu_item
integer x = 151
integer y = 740
integer width = 626
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Button help:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_5 from statictext within w_edit_menu_item
integer x = 151
integer y = 888
integer width = 626
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Button:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_item_type from statictext within w_edit_menu_item
integer x = 782
integer y = 288
integer width = 965
integer height = 108
integer taborder = 20
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
boolean disabledlook = true
end type

event clicked;str_popup popup
str_popup_return popup_return
integer li_sts
string ls_button

popup.dataobject = "dw_domain_notranslate_list"
popup.datacolumn = 2
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = "MENU_ITEM_TYPE"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if not f_string_modified(modified_menu_item.menu_item_type, popup_return.items[1]) then return

updated = true

modified_menu_item.menu_item_type = popup_return.items[1]
text = popup_return.descriptions[1]

setnull(modified_menu_item.menu_item)
st_item.text = ""
st_item.event POST clicked()

end event

type st_item from statictext within w_edit_menu_item
integer x = 782
integer y = 436
integer width = 2021
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
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
boolean disabledlook = true
end type

event clicked;string ls_treatment_type

w_config_treatment_types lw_config_treatment_types
w_pick_menu	lw_pick_menu
str_popup			popup
str_popup_return	popup_return

CHOOSE CASE upper(modified_menu_item.menu_item_type)
	CASE "MENU"
		Open(lw_pick_menu, "w_pick_menu")
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		modified_menu_item.menu_item = popup_return.items[1]
		modified_menu_item.button_title = popup_return.descriptions[1]
		modified_menu_item.button_help = popup_return.descriptions[1]
		modified_menu_item.button = "button21.bmp"

		st_item.text = popup_return.descriptions[1]
		sle_button_title.text = modified_menu_item.button_title
		sle_help.text = modified_menu_item.button_help
		sle_button.text = modified_menu_item.button
		updated = true
	CASE "TREATMENT"
		get_treatment()
	CASE "TREATMENT_LIST"
		// get the treatment list
		popup.dataobject = "dw_c_treatment_type_list_def"
		popup.datacolumn = 1
		popup.displaycolumn = 2
		openwithparm(w_pop_pick, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return

		modified_menu_item.menu_item = popup_return.items[1]
		modified_menu_item.button_title = popup_return.descriptions[1]
		modified_menu_item.button_help = popup_return.descriptions[1]
		modified_menu_item.button = datalist.treatment_type_list_button(modified_menu_item.menu_item)

		st_item.text = popup_return.descriptions[1]
		sle_button_title.text = modified_menu_item.button_title
		sle_help.text = modified_menu_item.button_help
		sle_button.text = modified_menu_item.button
		updated = true
	CASE "SERVICE"
		get_service()
	CASE "TREATMENT_TYPE"
		popup.dataobject = "dw_treatment_type_edit_list"
		popup.datacolumn = 2
		popup.displaycolumn = 4
		openwithparm(w_pop_pick, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return

		modified_menu_item.menu_item = popup_return.items[1]
		modified_menu_item.button_title = popup_return.descriptions[1]
		modified_menu_item.button_help = popup_return.descriptions[1]
		modified_menu_item.button = datalist.treatment_type_define_button(modified_menu_item.menu_item)

		st_item.text = popup_return.descriptions[1]
		sle_button_title.text = modified_menu_item.button_title
		sle_help.text = modified_menu_item.button_help
		sle_button.text = modified_menu_item.button
		updated = true
END CHOOSE

refresh_attributes()

end event

type sle_button_title from singlelineedit within w_edit_menu_item
integer x = 782
integer y = 584
integer width = 1742
integer height = 108
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;modified_menu_item.button_title = text
updated = true

end event

type sle_help from singlelineedit within w_edit_menu_item
integer x = 782
integer y = 732
integer width = 1742
integer height = 108
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;modified_menu_item.button_help = text
updated = true

end event

type sle_button from singlelineedit within w_edit_menu_item
integer x = 782
integer y = 880
integer width = 1742
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;modified_menu_item.button = text
updated = true

end event

type st_title from statictext within w_edit_menu_item
integer width = 2930
integer height = 88
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Menu Item Properties"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_6 from statictext within w_edit_menu_item
integer x = 187
integer y = 120
integer width = 247
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Menu:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_menu_description from statictext within w_edit_menu_item
integer x = 453
integer y = 112
integer width = 2021
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
boolean focusrectangle = false
boolean disabledlook = true
end type

type dw_menu_item_attributes from u_dw_pick_list within w_edit_menu_item
integer x = 101
integer y = 1164
integer width = 1029
integer height = 592
integer taborder = 21
boolean bringtotop = true
string dataobject = "dw_menu_item_attributes_small"
borderstyle borderstyle = styleraised!
end type

event clicked;call super::clicked;configure_item()

end event

type st_menu_attributes_title from statictext within w_edit_menu_item
integer x = 101
integer y = 1092
integer width = 1029
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
string text = "Menu Item Attributes"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_no_attributes from statictext within w_edit_menu_item
integer x = 389
integer y = 1252
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
long backcolor = 12632256
string text = "No Attributes"
alignment alignment = center!
boolean focusrectangle = false
end type

event clicked;configure_item()

end event

type cb_finished from commandbutton within w_edit_menu_item
integer x = 2391
integer y = 1644
integer width = 462
integer height = 112
integer taborder = 110
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
boolean default = true
end type

event clicked;integer li_sts

li_sts = save_changes()
if li_sts <= 0 then
	openwithparm(w_pop_message, "Saving changes failed")
	return
end if

closewithreturn(parent, modified_menu_item)


end event

type cb_cancel from commandbutton within w_edit_menu_item
integer x = 1234
integer y = 1644
integer width = 462
integer height = 112
integer taborder = 120
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;str_popup_return popup_return

if updated then
	openwithparm(w_pop_yes_no, "Are you sure you wish to exit without saving your changes?")
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return
end if

Closewithreturn(Parent,original_menu_item)


end event

type st_auto_close_flag_title from statictext within w_edit_menu_item
integer x = 2208
integer y = 1072
integer width = 425
integer height = 132
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Auto Close Window"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_auto_close_flag from statictext within w_edit_menu_item
integer x = 2240
integer y = 1216
integer width = 366
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "No"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
boolean disabledlook = true
end type

event clicked;str_popup popup
str_popup_return popup_return
integer li_sts
string ls_button

popup.dataobject = "dw_domain_translate_list"
popup.datacolumn = 2
popup.displaycolumn = 3
popup.argument_count = 1
popup.argument[1] = "Menu Auto Close"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

modified_menu_item.auto_close_flag = popup_return.items[1]
text = popup_return.descriptions[1]


end event

type st_authorized_user from statictext within w_edit_menu_item
integer x = 2053
integer y = 1456
integer width = 736
integer height = 116
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "<All>"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;u_user luo_user

luo_user = user_list.pick_user(true, false, false)
if isnull(luo_user) then return

text = luo_user.user_full_name
backcolor = luo_user.color

modified_menu_item.authorized_user_id = luo_user.user_id


end event

type st_7 from statictext within w_edit_menu_item
integer x = 2021
integer y = 1384
integer width = 795
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
string text = "Authorized User/Role"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_edit_menu_item
integer x = 1253
integer y = 1216
integer width = 763
integer height = 108
integer taborder = 31
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Define Runtime Params"
end type

event clicked;str_popup popup

popup.data_row_count = 2
popup.items[1] = original_menu_item.id
popup.items[2] = "Runtime"

openwithparm(w_component_params_edit, popup)


end event

