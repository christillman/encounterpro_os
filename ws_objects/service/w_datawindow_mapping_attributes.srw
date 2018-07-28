HA$PBExportHeader$w_datawindow_mapping_attributes.srw
forward
global type w_datawindow_mapping_attributes from w_window_base
end type
type cb_finished from commandbutton within w_datawindow_mapping_attributes
end type
type dw_attributes from u_dw_pick_list within w_datawindow_mapping_attributes
end type
type cb_add_attrribute from commandbutton within w_datawindow_mapping_attributes
end type
end forward

global type w_datawindow_mapping_attributes from w_window_base
integer width = 3150
integer height = 1912
string title = "Menu"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean auto_resize_window = false
boolean auto_resize_objects = false
boolean nested_user_object_resize = false
cb_finished cb_finished
dw_attributes dw_attributes
cb_add_attrribute cb_add_attrribute
end type
global w_datawindow_mapping_attributes w_datawindow_mapping_attributes

type variables
string config_object_id
str_complete_context context
string control_name
str_attributes mapping_attributes

str_datawindow_controls controls
str_datawindow_nested_datawindow nested_datawindow


end variables
forward prototypes
public function integer refresh ()
public subroutine modify_attribute_value (long pl_row)
public function integer save_attributes (string ps_config_object_id, string ps_control_name, str_attributes pstr_attributes)
end prototypes

public function integer refresh ();long i
long ll_row

dw_attributes.reset()

for i = 1 to mapping_attributes.attribute_count
	ll_row = dw_attributes.insertrow(0)
	dw_attributes.object.attribute[ll_row] =  mapping_attributes.attribute[i].attribute
	dw_attributes.object.value[ll_row] =  mapping_attributes.attribute[i].value
next


return 1

end function

public subroutine modify_attribute_value (long pl_row);long ll_row
str_popup popup
str_popup_return popup_return
string ls_attribute
string ls_value
string ls_find
integer li_sts
w_data_address_builder_tree lw_edas
str_edas_context lstr_edas_context
string ls_property
long i

ls_attribute = dw_attributes.object.attribute[pl_row]

popup.data_row_count = 3
popup.items[1] = "Datawindow Control"
popup.items[2] = "EDAS Property"
popup.items[3] = "Free Text"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

CHOOSE CASE popup_return.item_indexes[1]
	CASE 1
		popup.data_row_count = controls.control_count + nested_datawindow.controls.control_count
		for i = 1 to controls.control_count
			popup.items[i] = ":" + controls.control[i].control_name
		next
		for i = 1 to nested_datawindow.controls.control_count
			popup.items[controls.control_count + i] = ":" + nested_datawindow.controlname + "." + nested_datawindow.controls.control[i].control_name
		next
		
		openwithparm(w_pop_pick, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		
		ls_value = popup_return.items[1]
	CASE 2
		lstr_edas_context.root_object = "Root"
		lstr_edas_context.objects_only = false
		lstr_edas_context.context = context
		openwithparm(lw_edas,  lstr_edas_context, "w_data_address_builder_tree")
		ls_property = message.stringparm
		if len(ls_property) > 0 then
			ls_value = "%" + ls_property + "%"
		end if
	CASE 3
		popup.title = "Enter the new value"
		popup.data_row_count = 0
		openwithparm(w_pop_prompt_string, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		
		ls_value = popup_return.items[1]
	CASE ELSE
		return
END CHOOSE

f_attribute_add_attribute(mapping_attributes, ls_attribute, ls_value)

li_sts = save_attributes(config_object_id, control_name, mapping_attributes)
if li_sts <= 0 then return

dw_attributes.object.value[pl_row] = ls_value

return

end subroutine

public function integer save_attributes (string ps_config_object_id, string ps_control_name, str_attributes pstr_attributes);integer li_sts
string ls_context_object
str_config_object_info lstr_config_object
u_ds_data luo_mappings
u_ds_data luo_attributes
string ls_current_status
long i
long j
string ls_value
string ls_long_value
long ll_row

// We need to already have a config_object_id in order to save it.  The config search screen will create the config_object_id before the user ever gets a chance to edit it
if isnull(ps_config_object_id) or trim(ps_config_object_id) = "" then
	log.log(this, "save_attributes()", "No config_object_id", 4)
	return -1
end if

// We need to already have a config_object_id in order to save it.  The config search screen will create the config_object_id before the user ever gets a chance to edit it
if isnull(ps_control_name) or trim(ps_control_name) = "" then
	log.log(this, "save_attributes()", "No control_name", 4)
	return -1
end if

tf_begin_transaction(this, "Datawindow Config Object Save Attributes")

// Delete the existing attributes
DELETE a
FROM dbo.c_Datawindow_Mapping_Attribute a
WHERE config_object_id = :ps_config_object_id
AND control_name = :ps_control_name;
if not tf_check() then
	tf_rollback()
	return -1
end if


luo_attributes = CREATE u_ds_data
luo_attributes.set_dataobject("dw_c_datawindow_mapping_attribute")

for j = 1 to pstr_attributes.attribute_count
	if len(pstr_attributes.attribute[j].value) > 255 then
		setnull(ls_value)
		ls_long_value = pstr_attributes.attribute[j].value
	else
		setnull(ls_long_value)
		ls_value = pstr_attributes.attribute[j].value
	end if
	ll_row = luo_attributes.insertrow(0)
	luo_attributes.object.config_object_id[ll_row] = ps_config_object_id
	luo_attributes.object.control_name[ll_row] = ps_control_name
	luo_attributes.object.attribute[ll_row] = pstr_attributes.attribute[j].attribute
	luo_attributes.object.value[ll_row] = ls_value
	luo_attributes.object.long_value[ll_row] = ls_long_value
	luo_attributes.object.created_by[ll_row] = current_scribe.user_id
next

li_sts = luo_attributes.update()
if li_sts < 0 then
	log.log(this, "save_attributes()", "Error saving mapping attributess (" + ps_config_object_id + ")", 4)
	tf_rollback()
	return -1
end if

tf_commit_transaction()

return 1

end function

on w_datawindow_mapping_attributes.create
int iCurrent
call super::create
this.cb_finished=create cb_finished
this.dw_attributes=create dw_attributes
this.cb_add_attrribute=create cb_add_attrribute
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_finished
this.Control[iCurrent+2]=this.dw_attributes
this.Control[iCurrent+3]=this.cb_add_attrribute
end on

on w_datawindow_mapping_attributes.destroy
call super::destroy
destroy(this.cb_finished)
destroy(this.dw_attributes)
destroy(this.cb_add_attrribute)
end on

event open;call super::open;str_popup popup

popup = message.powerobjectparm

config_object_id = popup.items[1]
control_name = popup.items[2]
mapping_attributes = popup.objectparm
controls = popup.objectparm2
if isvalid(popup.objectparm3) and not isnull(popup.objectparm3) then
	nested_datawindow = popup.objectparm3
end if

context = f_current_complete_context( )

center_popup()

refresh()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_datawindow_mapping_attributes
integer x = 3538
integer y = 36
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_datawindow_mapping_attributes
end type

type cb_finished from commandbutton within w_datawindow_mapping_attributes
integer x = 2665
integer y = 1680
integer width = 402
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
end type

event clicked;str_popup_return popup_return

popup_return.item = "OK"
popup_return.returnobject = mapping_attributes
closewithreturn(parent, popup_return)



end event

type dw_attributes from u_dw_pick_list within w_datawindow_mapping_attributes
integer x = 91
integer y = 88
integer width = 3013
integer height = 1536
integer taborder = 11
string dataobject = "dw_datawindow_mapping_attributes"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;if lower(lastcolumnname) = "value" then
	modify_attribute_value(selected_row)
end if

clear_selected()


end event

type cb_add_attrribute from commandbutton within w_datawindow_mapping_attributes
integer x = 64
integer y = 1680
integer width = 402
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add Attribute"
end type

event clicked;long ll_row
str_popup popup
str_popup_return popup_return
string ls_attribute
string ls_find

popup.title = "Enter the new attribute name"
popup.displaycolumn = 64
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return -1

ls_attribute = popup_return.items[1]

ls_find = "attribute='" + ls_attribute + "'"
ll_row = dw_attributes.find(ls_find, 1, dw_attributes.rowcount())
if ll_row > 0 then
	openwithparm(w_pop_message, "That attribute already exists.  Click on it's value to change or remove it.")
	return
end if

ll_row = dw_attributes.insertrow(0)
dw_attributes.object.attribute[ll_row] = ls_attribute
dw_attributes.object.value[ll_row] = "<None>"

return


end event

