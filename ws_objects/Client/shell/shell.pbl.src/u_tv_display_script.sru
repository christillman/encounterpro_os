$PBExportHeader$u_tv_display_script.sru
forward
global type u_tv_display_script from treeview
end type
type str_severity from structure within u_tv_display_script
end type
type str_item_data from structure within u_tv_display_script
end type
type str_display_script_reference from structure within u_tv_display_script
end type
end forward

type str_severity from structure
	integer		severity
	string		description
	string		bitmap
	integer		index
end type

type str_item_data from structure
	string		node_type
	long		parent_display_script_id
	long		display_script_id
	long		display_command_id
	string		param_title
	string		attribute
	string		value
	long		command_index
	str_c_display_script_command		command
end type

type str_display_script_reference from structure
	long		referenced_display_script_id
	long		actual_display_script_id
	long		display_script_index
end type

global type u_tv_display_script from treeview
integer width = 1106
integer height = 876
integer taborder = 10
string dragicon = "AppIcon!"
boolean dragauto = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
boolean hideselection = false
string picturename[] = {"Report!","Step!","Custom041!","","",""}
long picturemaskcolor = 536870912
long statepicturemaskcolor = 536870912
event changes_made ( )
event command_selected ( str_c_display_script_command pstr_command )
end type
global u_tv_display_script u_tv_display_script

type variables
private boolean allow_editing

private long dragging_handle

//u_ds_data c_observation_tree

//str_display_script display_script

private str_c_display_script_command_stack command_stack
//private str_c_display_script_command_stack all_commands

private long root_display_script_id

private long last_command_handle
private long last_command_index

private str_display_script display_script[]
private long display_script_count

private str_display_script_reference display_script_reference[]
private long display_script_reference_count

private boolean initializing

private str_config_object_info parent_config_object

boolean changes_made

private long temp_display_command_id = 0

private long drag_handle
private boolean drag_right_button

private long copy_item_handle
private str_item_data copy_item_data

end variables

forward prototypes
public subroutine redisplay_parent (long pl_handle)
public subroutine display_script_menu (long pl_handle)
public function long get_display_command (long pl_display_script_index, long pl_display_command_id)
public function integer configure_attribute (long pl_handle)
public function integer configure_command (long pl_handle)
public function integer save_changes ()
public function integer display_display_script (long pl_display_script_id, str_config_object_info pstr_parent_config_object_info, str_c_display_script_command_stack pstr_command_stack, boolean pb_allow_editing)
public subroutine changes_made ()
public subroutine display_command_menu (long pl_handle)
public subroutine display_command_attribute_menu (long pl_handle)
public function treeviewitem create_command_item (str_c_display_script_command pstr_command)
public function long temp_display_command_id ()
public function integer display_children (long pl_handle)
public function string attribute_description (long pl_display_script_index, long pl_display_command_index, string ps_attribute, string ps_param_title)
public subroutine redisplay_branch_old (long pl_handle)
public function long copy_command (long pl_from_handle, long pl_target_handle, boolean pb_above)
public function long move_command (long pl_from_handle, long pl_to_handle, boolean pb_above)
public function integer set_attribute (long pl_handle, string ps_new_value)
public function long insert_command (str_c_display_script_command pstr_command, long pl_target_handle, boolean pb_above)
public function long get_display_script (long pl_display_script_id)
public subroutine new_command (long pl_handle, string ls_where)
public subroutine new_command_old (long pl_handle, boolean pb_above)
public subroutine new_command (long pl_handle, boolean pb_above)
public function integer selected_command (ref str_c_display_script_command pstr_command)
public subroutine select_next ()
public function integer first_command (ref str_c_display_script_command pstr_command)
public function integer select_command (str_c_display_script_command pstr_command)
end prototypes

public subroutine redisplay_parent (long pl_handle);long ll_parent_handle
treeviewitem ltvi_item
integer li_sts

ll_parent_handle = finditem(ParentTreeItem!, pl_handle)
if ll_parent_handle < 0 then return

display_children(ll_parent_handle)


end subroutine

public subroutine display_script_menu (long pl_handle);str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons
string ls_user_id
str_item_data lstr_item_data
treeviewitem ltvi_item

if not allow_editing then return

li_sts = getitem(pl_handle, ltvi_item)
if li_sts <= 0 then
	log.log(this, "u_tv_display_script.display_script_menu:0014", "Error getting new treeview item (" + string(pl_handle) + ")", 4)
	return
end if

lstr_item_data = ltvi_item.data

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "b_new09.bmp"
	popup.button_helps[popup.button_count] = "Insert New Command at the Beginning"
	popup.button_titles[popup.button_count] = "Insert Command"
	buttons[popup.button_count] = "INSERT"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "b_new09.bmp"
	popup.button_helps[popup.button_count] = "Append New Command to the End"
	popup.button_titles[popup.button_count] = "Append Command"
	buttons[popup.button_count] = "APPEND"
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
	CASE "INSERT"
		new_command(pl_handle, "top")
	CASE "APPEND"
		new_command(pl_handle, "bottom")
	CASE ELSE
END CHOOSE

return

end subroutine

public function long get_display_command (long pl_display_script_index, long pl_display_command_id);long i
str_display_script lstr_display_script
integer li_sts

if pl_display_script_index <= 0 or pl_display_script_index > display_script_count then return 0

for i = 1 to display_script[pl_display_script_index].display_command_count
	if display_script[pl_display_script_index].display_command[i].display_command_id = pl_display_command_id then return i
next

return 0

end function

public function integer configure_attribute (long pl_handle);str_param_setting lstr_param
str_param_wizard_return lstr_return
str_params lstr_params
integer li_sts
str_attributes lstr_attributes
u_ds_data luo_data
string lsa_words[]
integer li_count
long i
long ll_ds_idx
long ll_dc_idx
long ll_param_index
treeviewitem ltvi_item
str_item_data lstr_item_data
string ls_new_value
w_param_setting lw_param_window

li_sts = getitem(pl_handle, ltvi_item)
if li_sts <= 0 then return -1

lstr_item_data = ltvi_item.data

ll_ds_idx = get_display_script(lstr_item_data.display_script_id)
if ll_ds_idx <= 0 then return -1

ll_dc_idx = get_display_command(ll_ds_idx, lstr_item_data.display_command_id)
if ll_dc_idx <= 0 then return -1

// Find the param record
ll_param_index = 0
lstr_params = f_get_component_params(display_script[ll_ds_idx].display_command[ll_dc_idx].command_component_id, "Config")
for i = 1 to lstr_params.param_count
	if lower(lstr_params.params[i].token1) = lower(lstr_item_data.attribute) then
		ll_param_index = i
		exit
	end if
next
if ll_param_index <= 0 then return -1

// Prompt user for new attribute value
lstr_param.param = lstr_params.params[ll_param_index]
f_attribute_add_attribute(lstr_param.attributes, lstr_item_data.attribute, lstr_item_data.value)
f_attribute_add_attribute(lstr_param.attributes, "parent_config_object_id", parent_config_object.config_object_id)
f_attribute_add_attribute(lstr_param.attributes, "context_object", display_script[ll_ds_idx].display_command[ll_dc_idx].context_object)

openwithparm(lw_param_window, lstr_param, "w_param_setting")
lstr_return = message.powerobjectparm
if lstr_return.return_status <= 0 then
	return 0
end if

ls_new_value = f_attribute_find_attribute(lstr_return.attributes, lstr_item_data.attribute)

return set_attribute(pl_handle, ls_new_value)


end function

public function integer configure_command (long pl_handle);integer li_sts
str_attributes lstr_attributes
u_ds_data luo_data
string lsa_words[]
integer li_count
long i
str_attributes lstr_state_attributes
long ll_ds_idx
long ll_dc_idx
long ll_param_index
treeviewitem ltvi_item
string ls_value_description
str_item_data lstr_item_data
string ls_description
long ll_next_child_handle
long ll_temp_handle

li_sts = getitem(pl_handle, ltvi_item)
if li_sts <= 0 then return -1

lstr_item_data = ltvi_item.data

ll_ds_idx = get_display_script(lstr_item_data.display_script_id)
if ll_ds_idx <= 0 then return -1

ll_dc_idx = get_display_command(ll_ds_idx, lstr_item_data.display_command_id)
if ll_dc_idx <= 0 then return -1

// Add the existing attributes
lstr_attributes = display_script[ll_ds_idx].display_command[ll_dc_idx].attributes

// Set the parent_config_object_id so any searches will know
if not isnull(parent_config_object.config_object_id) then
	f_attribute_add_attribute(lstr_state_attributes, "parent_config_object_id", parent_config_object.config_object_id)
end if

// Add the command's context object to the state attributes
f_attribute_add_attribute(lstr_state_attributes, "context_object", display_script[ll_ds_idx].display_command[ll_dc_idx].context_object)

// If the last word in the display command matches a context object, then assume the nested script will use that context object
li_count = f_parse_string(lower(display_script[ll_ds_idx].display_command[ll_dc_idx].display_command), " ", lsa_words)
if li_count > 0 then
	if left(lsa_words[li_count], 7) = "patient" then
		f_attribute_add_attribute(lstr_state_attributes, "context_object", "Patient")
	elseif left(lsa_words[li_count], 9) = "encounter" then
		f_attribute_add_attribute(lstr_state_attributes, "context_object", "Encounter")
	elseif left(lsa_words[li_count], 10) = "assessment" then
		f_attribute_add_attribute(lstr_state_attributes, "context_object", "Assessment")
	elseif left(lsa_words[li_count], 9) = "treatment" then
		f_attribute_add_attribute(lstr_state_attributes, "context_object", "Treatment")
	elseif left(lsa_words[li_count], 11) = "observation" then
		f_attribute_add_attribute(lstr_state_attributes, "context_object", "Observation")
	elseif left(lsa_words[li_count], 10) = "attachment" then
		f_attribute_add_attribute(lstr_state_attributes, "context_object", "Attachment")
	end if
end if

li_sts = f_get_params_with_state(display_script[ll_ds_idx].display_command[ll_dc_idx].command_component_id, "Config", lstr_attributes, lstr_state_attributes)
if li_sts < 0 then
	return 0
end if

// Update our cache
for i = 1 to lstr_attributes.attribute_count
	f_attribute_add_attribute(display_script[ll_ds_idx].display_command[ll_dc_idx].attributes, lstr_attributes.attribute[i].attribute, lstr_attributes.attribute[i].value)
next

display_children(pl_handle)

changes_made()

return 1

end function

public function integer save_changes ();long ll_old_display_script_id
long i
integer li_sts


// Now loop through each display script we're referenced and save it
for i = 1 to display_script_count
	ll_old_display_script_id = display_script[i].display_script_id
	li_sts = f_save_display_script(display_script[i])
	if li_sts <= 0 then
		log.log(this, "u_tv_display_script.save_changes:0011", "Saving display script failed", 4)
		openwithparm(w_pop_message, "Saving display script failed")
		return -1
	end if
next

changes_made = false

return 1

end function

public function integer display_display_script (long pl_display_script_id, str_config_object_info pstr_parent_config_object_info, str_c_display_script_command_stack pstr_command_stack, boolean pb_allow_editing);treeviewitem ltvi_node
long ll_handle
integer li_sts
long ll_rows
str_item_data lstr_new_item_data
long ll_index


root_display_script_id = pl_display_script_id
parent_config_object = pstr_parent_config_object_info
command_stack = pstr_command_stack
allow_editing = pb_allow_editing

display_script_count = 0
display_script_reference_count = 0

if isnull(pl_display_script_id) then
	log.log(this, "u_tv_display_script.display_display_script:0018", "Null display_script_id", 4)
	return -1
end if

ll_index = get_display_script(pl_display_script_id)
if ll_index <= 0 then
	log.log(this, "u_tv_display_script.display_display_script:0024", "display_script not found (" + string(pl_display_script_id) + ")", 4)
	return -1
end if

initializing = true
changes_made = false

setredraw(false)

// Delete existing treeview items
DO
	ll_handle = finditem(RootTreeItem!, 0)
	if ll_handle > 0 then deleteitem(ll_handle)
LOOP WHILE ll_handle > 0

lstr_new_item_data.node_type = "DISPLAY_SCRIPT"
lstr_new_item_data.parent_display_script_id = 0
lstr_new_item_data.display_script_id = root_display_script_id
lstr_new_item_data.display_command_id = 0
lstr_new_item_data.attribute = ""
lstr_new_item_data.value = ""
if command_stack.command_count > 0 then
	lstr_new_item_data.command_index = 1
else
	lstr_new_item_data.command_index = 0
end if

ltvi_node.data = lstr_new_item_data
ltvi_node.label = display_script[ll_index].description
ltvi_node.children = true
ltvi_node.PictureIndex = 1
ltvi_node.SelectedPictureIndex = 1
ll_handle = insertitemlast(0, ltvi_node)

expanditem(ll_handle)

if last_command_handle > 0 then
	selectitem(last_command_handle)
end if

setredraw(true)

initializing = false

return 1

end function

public subroutine changes_made ();
changes_made = true

this.event POST changes_made()


end subroutine

public subroutine display_command_menu (long pl_handle);long i
str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons
string ls_user_id
str_item_data lstr_item_data
treeviewitem ltvi_item
long ll_ds_idx
long ll_dc_idx
str_attributes lstr_attributes
boolean lb_above
long ll_from_ds_index
long ll_from_dc_index
long ll_new_item_handle

if not allow_editing then return

li_sts = getitem(pl_handle, ltvi_item)
if li_sts <= 0 then
	log.log(this, "u_tv_display_script.display_command_menu:0022", "Error getting new treeview item (" + string(pl_handle) + ")", 4)
	return
end if

lstr_item_data = ltvi_item.data

ll_ds_idx = get_display_script(lstr_item_data.display_script_id)
if ll_ds_idx <= 0 then return

ll_dc_idx = get_display_command(ll_ds_idx, lstr_item_data.display_command_id)
if ll_dc_idx <= 0 then return

lstr_attributes = display_script[ll_ds_idx].display_command[ll_dc_idx].attributes

if upper(display_script[ll_ds_idx].display_command[ll_dc_idx].status) = "OK" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "b_push09.bmp"
	popup.button_helps[popup.button_count] = "Disable Command"
	popup.button_titles[popup.button_count] = "Disable Command"
	buttons[popup.button_count] = "DISABLE"
end if

if upper(display_script[ll_ds_idx].display_command[ll_dc_idx].status) = "NA" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button09.bmp"
	popup.button_helps[popup.button_count] = "Enable Command"
	popup.button_titles[popup.button_count] = "Enable Command"
	buttons[popup.button_count] = "ENABLE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Configure Command"
	popup.button_titles[popup.button_count] = "Configure Command"
	buttons[popup.button_count] = "CONFIGURE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonclone.bmp"
	popup.button_helps[popup.button_count] = "Copy Command"
	popup.button_titles[popup.button_count] = "Copy Command"
	buttons[popup.button_count] = "COPY"
end if

if copy_item_data.node_type = "COMMAND" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_docs_ok.bmp"
	popup.button_helps[popup.button_count] = "Paste Command Above Target Command"
	popup.button_titles[popup.button_count] = "Paste Above"
	buttons[popup.button_count] = "PASTE ABOVE"
end if

if copy_item_data.node_type = "COMMAND" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_docs_ok.bmp"
	popup.button_helps[popup.button_count] = "Paste Command Below Target Command"
	popup.button_titles[popup.button_count] = "Paste Below"
	buttons[popup.button_count] = "PASTE BELOW"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Delete Command"
	popup.button_titles[popup.button_count] = "Delete Command"
	buttons[popup.button_count] = "DELETE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "b_new09.bmp"
	popup.button_helps[popup.button_count] = "Insert New Command Above This Command"
	popup.button_titles[popup.button_count] = "Insert Above"
	buttons[popup.button_count] = "INSERTABOVE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "b_new09.bmp"
	popup.button_helps[popup.button_count] = "Insert New Command Below This Command"
	popup.button_titles[popup.button_count] = "Insert Below"
	buttons[popup.button_count] = "INSERTBELOW"
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
	CASE "DISABLE"
		 display_script[ll_ds_idx].display_command[ll_dc_idx].status = "NA"
		 if right(ltvi_item.label, 11) <> " (Disabled)" then
			ltvi_item.label += " (Disabled)"
			setitem(pl_handle, ltvi_item)
		end if
		changes_made()
	CASE "ENABLE"
		 display_script[ll_ds_idx].display_command[ll_dc_idx].status = "OK"
		 if right(ltvi_item.label, 11) = " (Disabled)" then
			ltvi_item.label = left(ltvi_item.label, len(ltvi_item.label) - 11)
			setitem(pl_handle, ltvi_item)
		end if
		changes_made()
	CASE "CONFIGURE"
		configure_command(pl_handle)
		return
	CASE "COPY"
		copy_item_handle = pl_handle
		copy_item_data = lstr_item_data
	CASE "PASTE ABOVE", "PASTE BELOW"
		ll_from_ds_index = get_display_script(copy_item_data.display_script_id)
		if ll_from_ds_index <= 0 then return
		
		ll_from_dc_index = get_display_command(ll_from_ds_index, copy_item_data.display_command_id)
		if ll_from_dc_index <= 0 then return
		
		IF buttons[button_pressed] = "PASTE ABOVE" then
			lb_above = true
		else
			lb_above = false
		end if
		
		ll_new_item_handle = insert_command(display_script[ll_from_ds_index].display_command[ll_from_dc_index], pl_handle, lb_above)
		
		selectitem(ll_new_item_handle)

	CASE "DELETE"
		for i = ll_dc_idx to display_script[ll_ds_idx].display_command_count - 1
			display_script[ll_ds_idx].display_command[i] = display_script[ll_ds_idx].display_command[i + 1]
		next
		display_script[ll_ds_idx].display_command_count -= 1
		deleteitem(pl_handle)
		changes_made()
	CASE "INSERTABOVE"
		new_command(pl_handle, true)
	CASE "INSERTBELOW"
		new_command(pl_handle, false)
END CHOOSE

return

end subroutine

public subroutine display_command_attribute_menu (long pl_handle);long i
str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons
string ls_user_id
str_item_data lstr_item_data
treeviewitem ltvi_item
long ll_ds_idx
long ll_dc_idx
str_attributes lstr_attributes
string ls_null
string ls_message

setnull(ls_null)

if not allow_editing then return

li_sts = getitem(pl_handle, ltvi_item)
if li_sts <= 0 then
	log.log(this, "u_tv_display_script.display_command_attribute_menu:0022", "Error getting new treeview item (" + string(pl_handle) + ")", 4)
	return
end if

lstr_item_data = ltvi_item.data

ll_ds_idx = get_display_script(lstr_item_data.display_script_id)
if ll_ds_idx <= 0 then return

ll_dc_idx = get_display_command(ll_ds_idx, lstr_item_data.display_command_id)
if ll_dc_idx <= 0 then return

lstr_attributes = display_script[ll_ds_idx].display_command[ll_dc_idx].attributes

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Configure Attribute"
	popup.button_titles[popup.button_count] = "Configure Attribute"
	buttons[popup.button_count] = "CONFIGURE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonclone.bmp"
	popup.button_helps[popup.button_count] = "Copy Attribute"
	popup.button_titles[popup.button_count] = "Copy Attribute"
	buttons[popup.button_count] = "COPY"
end if

if copy_item_data.node_type = "ATTRIBUTE" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_docs_ok.bmp"
	popup.button_helps[popup.button_count] = "Paste Attribute"
	popup.button_titles[popup.button_count] = "Paste Attribute"
	buttons[popup.button_count] = "PASTE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Clear Attribute"
	popup.button_titles[popup.button_count] = "Clear Attribute"
	buttons[popup.button_count] = "CLEAR"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Display Attribute Properties"
	popup.button_titles[popup.button_count] = "Properties"
	buttons[popup.button_count] = "PROPERTIES"
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
	CASE "CONFIGURE"
		configure_attribute(pl_handle)
	CASE "CLEAR"
		f_attribute_add_attribute(display_script[ll_ds_idx].display_command[ll_dc_idx].attributes, lstr_item_data.attribute, ls_null)
		setnull(lstr_item_data.value)

		// Update the item label
		ltvi_item.label = attribute_description(ll_ds_idx, ll_dc_idx, lstr_item_data.attribute, lstr_item_data.param_title)

		// Update the item data
		ltvi_item.data = lstr_item_data

		// Save the item back to the display
		setitem( pl_handle, ltvi_item)

		// Redisplay children if necessary
		display_children(pl_handle)
		
		changes_made()
	CASE "COPY"
		copy_item_handle = pl_handle
		copy_item_data = lstr_item_data
	CASE "PASTE"
		if len(copy_item_data.value) > 0 then
			set_attribute(pl_handle, copy_item_data.value)
			changes_made()
		end if
	CASE "PROPERTIES"
		ls_message = "display_script_id = " + string(display_script[ll_ds_idx].display_script_id)
		ls_message += "~r~ndisplay_command_id = " + string(display_script[ll_ds_idx].display_command[ll_dc_idx].display_command_id)
		ls_message += "~r~nattribute = " + lstr_item_data.attribute
		openwithparm(w_pop_message, ls_message)
	CASE ELSE
END CHOOSE

return

end subroutine

public function treeviewitem create_command_item (str_c_display_script_command pstr_command);string ls_description
str_item_data lstr_new_item_data
treeviewitem ltvi_new_item

if lower(pstr_command.context_object) = "general" then
	ls_description = wordcap(pstr_command.display_command)
else
	ls_description = wordcap(pstr_command.context_object + " " + pstr_command.display_command)
end if

if upper(pstr_command.status) = "NA" then
	ls_description += " (Disabled)"
end if

// Set data structure for new item
lstr_new_item_data.node_type = "COMMAND"
lstr_new_item_data.display_script_id = pstr_command.display_script_id
lstr_new_item_data.display_command_id = pstr_command.display_command_id
lstr_new_item_data.attribute = ""
lstr_new_item_data.value = ""
lstr_new_item_data.command_index = 0
lstr_new_item_data.command = pstr_command

ltvi_new_item.data = lstr_new_item_data
ltvi_new_item.label = ls_description
ltvi_new_item.children = true
ltvi_new_item.PictureIndex = 2
ltvi_new_item.SelectedPictureIndex = 2

return ltvi_new_item

end function

public function long temp_display_command_id ();temp_display_command_id -= 1

return temp_display_command_id

end function

public function integer display_children (long pl_handle);treeviewitem ltvi_parent_item
treeviewitem ltvi_new_item
integer li_sts
long i, j
long ll_rows
long ll_new_handle
string ls_data
string ls_context_object
string ls_display_command
string ls_status
long ll_next_command_display_script_id
boolean lb_display_command_found
boolean lb_display_script_found
long ll_command_handle
str_item_data lstr_parent_item_data
str_item_data lstr_new_item_data
long ll_parent_display_script_id
long ll_display_script_index
long ll_idx_2
long ll_display_command_index
str_params lstr_params
boolean lb_child_item_found
long ll_next_child_handle
long ll_temp_handle

li_sts = getitem(pl_handle, ltvi_parent_item)
if li_sts <= 0 then
	log.log(this, "u_tv_display_script.display_children:0028", "Error getting new treeview item (" + string(pl_handle) + ")", 4)
	return 1
end if

lstr_parent_item_data = ltvi_parent_item.data

// First delete the existing children
ll_next_child_handle = FindItem(ChildTreeItem!, pl_handle)
do while ll_next_child_handle > 0
	ll_temp_handle = ll_next_child_handle
	ll_next_child_handle = FindItem(NextTreeItem!, ll_temp_handle)
	deleteitem(ll_temp_handle)
loop


lb_child_item_found = false

if isnull(lstr_parent_item_data.display_script_id) or lstr_parent_item_data.display_script_id <= 0 then
	log.log(this, "u_tv_display_script.display_children:0046", "Invalid display script id (" + string(lstr_parent_item_data.display_script_id) + ")", 4)
	return 1
end if

ll_display_script_index = get_display_script(lstr_parent_item_data.display_script_id)
if ll_display_script_index <= 0 then
	log.log(this, "u_tv_display_script.display_children:0052", "Error getting display script (" + string(lstr_parent_item_data.display_script_id) + ")", 4)
	return 1
end if

CHOOSE CASE upper(lstr_parent_item_data.node_type)
	CASE "DISPLAY_SCRIPT"
		lb_display_command_found = false
		// If this is a display_script then show the steps
		for i = 1 to display_script[ll_display_script_index].display_command_count
			// Create the treeviewitem
			ltvi_new_item = create_command_item(display_script[ll_display_script_index].display_command[i])
			
			// Update some fields before adding the item to the tree
			lstr_new_item_data = ltvi_new_item.data
			
			lstr_new_item_data.parent_display_script_id = lstr_parent_item_data.parent_display_script_id
			if lstr_parent_item_data.command_index > 0 then
				if command_stack.command[lstr_parent_item_data.command_index].display_script_id = lstr_new_item_data.display_script_id &
					and command_stack.command[lstr_parent_item_data.command_index].display_command_id = lstr_new_item_data.display_command_id then
					lstr_new_item_data.command_index = lstr_parent_item_data.command_index
				end if
			end if
			
			ltvi_new_item.data = lstr_new_item_data
			
			ll_new_handle = insertitemlast(pl_handle, ltvi_new_item)
			lb_child_item_found = true
			
			if initializing then
				if lstr_new_item_data.command_index > 0 then
					last_command_handle = ll_new_handle
					last_command_index = lstr_new_item_data.command_index
					expanditem(ll_new_handle)
				end if
			end if
		next
	CASE "COMMAND"
		// If this command is linked to our passed in command stack then make a note of the next display script id so we
		// can look for it as we display the attributes
		if lstr_parent_item_data.command_index > 0 and lstr_parent_item_data.command_index < command_stack.command_count then
			ll_next_command_display_script_id = command_stack.command[lstr_parent_item_data.command_index + 1].display_script_id
		else
			ll_next_command_display_script_id = 0
		end if
		
		// Find the command
		ll_display_command_index = get_display_command(ll_display_script_index, lstr_parent_item_data.display_command_id)
		if ll_display_command_index <= 0 then
			log.log(this, "u_tv_display_script.display_children:0100", "Error getting display command (" + string(lstr_parent_item_data.display_script_id) + ", " + string(lstr_parent_item_data.display_command_id) + ")", 4)
			return 1
		end if

		lstr_params = f_get_component_params(display_script[ll_display_script_index].display_command[ll_display_command_index].command_component_id, "Config")
		
		for i = 1 to  lstr_params.param_count
			if isnull(lstr_params.params[i].token1) or trim(lstr_params.params[i].token1) = "" then continue
			
			// Add the attribute
			lstr_new_item_data.node_type = "ATTRIBUTE"
			lstr_new_item_data.parent_display_script_id = lstr_parent_item_data.parent_display_script_id
			lstr_new_item_data.display_script_id = lstr_parent_item_data.display_script_id
			lstr_new_item_data.display_command_id = lstr_parent_item_data.display_command_id
			lstr_new_item_data.param_title = lstr_params.params[i].param_title
			lstr_new_item_data.attribute = lstr_params.params[i].token1
			lstr_new_item_data.value = f_attribute_find_attribute(display_script[ll_display_script_index].display_command[ll_display_command_index].attributes, lstr_new_item_data.attribute)
			ltvi_new_item.label = attribute_description(ll_display_script_index, ll_display_command_index, lstr_new_item_data.attribute, lstr_new_item_data.param_title)
			lstr_new_item_data.command_index = 0

			if lower(right(lstr_new_item_data.attribute, 17)) = "display_script_id" &
			  OR lower(right(lstr_new_item_data.attribute, 13)) = "xml_script_id" then
				ltvi_new_item.children = true
				
				// if this is the nested display script we're looking for, then set the command index
				if isnumber(lstr_new_item_data.value) then
					// First get the actual script used
					ll_idx_2 = get_display_script(long(lstr_new_item_data.value))
					if ll_idx_2 > 0 then
						// Save the actual script_id back to the attribute value
						lstr_new_item_data.value = string(display_script[ll_idx_2].display_script_id)
						// The compare the script used with the next script in the stack
						if display_script[ll_idx_2].display_script_id = ll_next_command_display_script_id then
							lstr_new_item_data.command_index = lstr_parent_item_data.command_index + 1
						end if
					end if
				end if
			else
				ltvi_new_item.children = false
			end if
			ltvi_new_item.PictureIndex = 3
			ltvi_new_item.SelectedPictureIndex = 3
			
			ltvi_new_item.data = lstr_new_item_data
			ll_new_handle = insertitemlast(pl_handle, ltvi_new_item)
			lb_child_item_found = true

			if lstr_new_item_data.command_index > 0 and initializing then
				expanditem(ll_new_handle)
			end if
		next
		
	CASE "ATTRIBUTE"
		lb_display_script_found = false
		// don't go lower than this if we're still initializing
		// If this is an attribute then show the properties
		if (lower(right(lstr_parent_item_data.attribute, 17)) = "display_script_id" OR lower(right(lstr_parent_item_data.attribute, 13)) = "xml_script_id") &
		  AND isnumber(lstr_parent_item_data.value) then
		  
			lstr_new_item_data.node_type = "DISPLAY_SCRIPT"
			lstr_new_item_data.parent_display_script_id = lstr_parent_item_data.display_script_id
			lstr_new_item_data.display_script_id = long(lstr_parent_item_data.value)
			lstr_new_item_data.display_command_id = 0
			lstr_new_item_data.attribute = ""
			lstr_new_item_data.value = ""
			lstr_new_item_data.command_index = lstr_parent_item_data.command_index
	
			ll_idx_2 = get_display_script(lstr_new_item_data.display_script_id)
			if ll_idx_2 > 0 then
				ltvi_new_item.data = lstr_new_item_data
				ltvi_new_item.label = display_script[ll_idx_2].description
				ltvi_new_item.children = true
				ltvi_new_item.PictureIndex = 1
				ltvi_new_item.SelectedPictureIndex = 1
				ll_new_handle = insertitemlast(pl_handle, ltvi_new_item)
				lb_child_item_found = true
				expanditem(ll_new_handle)
			end if
		end if
END CHOOSE

if ltvi_parent_item.children and not lb_child_item_found then
	ltvi_parent_item.children = false
	setitem(pl_handle, ltvi_parent_item)
	return 0
end if

//// Expand the parent item if it's not already expanded
//if not ltvi_parent_item.expanded then
//	expanditem(pl_handle)
//end if

return 0

end function

public function string attribute_description (long pl_display_script_index, long pl_display_command_index, string ps_attribute, string ps_param_title);string ls_value
string ls_description
string ls_value_description
string ls_null

setnull(ls_null)

if isnull(ps_attribute) or trim(ps_attribute) = "" then return ls_null

if isnull(pl_display_script_index) or pl_display_script_index <= 0 then return ls_null

if isnull(pl_display_command_index) or pl_display_command_index <= 0 then return ls_null

ls_value = f_attribute_find_attribute(display_script[pl_display_script_index].display_command[pl_display_command_index].attributes, ps_attribute)
if isnull(ls_value) then ls_value = ""
ls_value_description = sqlca.fn_attribute_description(ps_attribute, ls_value)

if len(ps_param_title) > 0 then
	ls_description = ps_param_title + " = "
else
	ls_description = ps_attribute + " = "
end if

if len(ls_value_description) > 0 then
	ls_description += ls_value_description
else
	ls_description += "<Null>"
end if

return ls_description

end function

public subroutine redisplay_branch_old (long pl_handle);long ll_next_child_handle
long ll_temp_handle
treeviewitem ltvi_item
integer li_sts

li_sts = getitem(pl_handle, ltvi_item)
if li_sts <= 0 then return

if ltvi_item.expandedonce then display_children(pl_handle)
if ltvi_item.expanded then expanditem(pl_handle)


end subroutine

public function long copy_command (long pl_from_handle, long pl_target_handle, boolean pb_above);integer li_sts
long ll_from_ds_index
long ll_from_dc_index
treeviewitem ltvi_from_item
str_item_data lstr_from_item_data
long ll_new_item_handle
str_c_display_script_command lstr_from_command

// Get the from command information
li_sts = getitem(pl_from_handle, ltvi_from_item)
if li_sts <= 0 then return -1 

lstr_from_item_data = ltvi_from_item.data

ll_from_ds_index = get_display_script(lstr_from_item_data.display_script_id)
if ll_from_ds_index <= 0 then return -1

ll_from_dc_index = get_display_command(ll_from_ds_index, lstr_from_item_data.display_command_id)
if ll_from_dc_index <= 0 then return -1

// Copy the from command
lstr_from_command =  display_script[ll_from_ds_index].display_command[ll_from_dc_index]

ll_new_item_handle = insert_command(lstr_from_command, pl_target_handle, pb_above)

return ll_new_item_handle



end function

public function long move_command (long pl_from_handle, long pl_to_handle, boolean pb_above);long i
integer li_sts
long ll_from_ds_index
long ll_from_dc_index
long ll_to_ds_index
long ll_to_dc_index
treeviewitem ltvi_from_item
str_item_data lstr_from_item_data
treeviewitem ltvi_to_item
str_item_data lstr_to_item_data
long ll_insert_before_idx
long ll_new_handle
str_c_display_script_command lstr_command
long ll_parenthandle
long ll_insert_after_handle

// Get the from command information
li_sts = getitem(pl_from_handle, ltvi_from_item)
if li_sts <= 0 then return -1

lstr_from_item_data = ltvi_from_item.data

li_sts = getitem(pl_to_handle, ltvi_to_item)
if li_sts <= 0 then return -1

lstr_to_item_data = ltvi_to_item.data


ll_from_ds_index = get_display_script(lstr_from_item_data.display_script_id)
if ll_from_ds_index <= 0 then return -1

ll_from_dc_index = get_display_command(ll_from_ds_index, lstr_from_item_data.display_command_id)
if ll_from_dc_index <= 0 then return -1

ll_to_ds_index = get_display_script(lstr_to_item_data.display_script_id)
if ll_to_ds_index <= 0 then return -1

ll_to_dc_index = get_display_command(ll_to_ds_index, lstr_to_item_data.display_command_id)
if ll_to_dc_index <= 0 then return -1

if ll_from_ds_index = ll_to_ds_index then
	// if the from and to are in the same display script, then just move the commands around.  This way we don't
	// need to be deleteing and re-adding commands

	if ll_from_dc_index = ll_to_dc_index then return 0
	
	// save the from command
	lstr_command = display_script[ll_from_ds_index].display_command[ll_from_dc_index]
	
	// Shift everything over
	if ll_from_dc_index < ll_to_dc_index then
		if pb_above then
			for i = ll_from_dc_index + 1 to ll_to_dc_index -1
				display_script[ll_from_ds_index].display_command[i - 1] = display_script[ll_from_ds_index].display_command[i]
			next
		else
			for i = ll_from_dc_index + 1 to ll_to_dc_index
				display_script[ll_from_ds_index].display_command[i - 1] = display_script[ll_from_ds_index].display_command[i]
			next
		end if
	else
		if pb_above then
			for i = ll_from_dc_index - 1 to ll_to_dc_index step -1
				display_script[ll_from_ds_index].display_command[i + 1] = display_script[ll_from_ds_index].display_command[i]
			next
		else
			for i = ll_from_dc_index - 1 to ll_to_dc_index + 1 step -1
				display_script[ll_from_ds_index].display_command[i + 1] = display_script[ll_from_ds_index].display_command[i]
			next
		end if
	end if
	
	// copy the saved from-command into the to-spot
	display_script[ll_to_ds_index].display_command[ll_to_dc_index] = lstr_command
	
	// Then fix all the sort sequences
	for i = 1 to display_script[ll_from_ds_index].display_command_count
		display_script[ll_from_ds_index].display_command[i].sort_sequence = i
	next
	
	// Finally, move the treeviewitem
	ll_parenthandle = FindItem(ParentTreeItem!, pl_to_handle)
	if ll_parenthandle < 0 then return -1
	
	deleteitem(pl_from_handle)
	ltvi_from_item.expanded = false
	ltvi_from_item.expandedonce = false

	if pb_above then
		ll_insert_after_handle = FindItem(PreviousTreeItem!, pl_to_handle)
		if ll_insert_after_handle >= 0 then
			ll_new_handle = InsertItem(ll_parenthandle, ll_insert_after_handle, ltvi_from_item)
		else
			ll_new_handle = InsertItemFirst(ll_parenthandle, ltvi_from_item)
		end if
	else
		ll_new_handle = InsertItem (ll_parenthandle, pl_to_handle, ltvi_from_item)
	end if
else
	// If the from and to are in different display scripts, then copy and delete
	// First copy the command
	ll_new_handle = copy_command(pl_from_handle, pl_to_handle, pb_above)
	if ll_new_handle <= 0 then return -1
	
	// Get the from command index again cuz it might have changed
	ll_from_dc_index = get_display_command(ll_from_ds_index, lstr_from_item_data.display_command_id)
	if ll_from_dc_index <= 0 then return -1
	
	// Then remove the from command
	for i = ll_from_dc_index to display_script[ll_from_ds_index].display_command_count - 1
		display_script[ll_from_ds_index].display_command[i] = display_script[ll_from_ds_index].display_command[i + 1]
	next
	display_script[ll_from_ds_index].display_command_count -= 1
	
	// Then remove the from treeviewitem
	deleteitem(pl_from_handle)
end if

return ll_new_handle
end function

public function integer set_attribute (long pl_handle, string ps_new_value);integer li_sts
long ll_ds_idx
long ll_dc_idx
long ll_param_index
treeviewitem ltvi_item
str_item_data lstr_item_data

li_sts = getitem(pl_handle, ltvi_item)
if li_sts <= 0 then return -1

lstr_item_data = ltvi_item.data

ll_ds_idx = get_display_script(lstr_item_data.display_script_id)
if ll_ds_idx <= 0 then return -1

ll_dc_idx = get_display_command(ll_ds_idx, lstr_item_data.display_command_id)
if ll_dc_idx <= 0 then return -1

lstr_item_data.value = ps_new_value

// Update our cache
f_attribute_add_attribute(display_script[ll_ds_idx].display_command[ll_dc_idx].attributes, lstr_item_data.attribute, lstr_item_data.value)

// Update the item label
ltvi_item.label = attribute_description(ll_ds_idx, ll_dc_idx, lstr_item_data.attribute, lstr_item_data.param_title)

// Update the item data
ltvi_item.data = lstr_item_data

// Save the item back to the display
setitem( pl_handle, ltvi_item)

// Redisplay children if necessary
display_children(pl_handle)

changes_made()

return 1

end function

public function long insert_command (str_c_display_script_command pstr_command, long pl_target_handle, boolean pb_above);str_script_command_context lstr_context
str_popup popup
str_popup_return popup_return
long ll_row
long ll_rowcount
long i
integer li_sts
long ll_display_command_id
string ls_command_id
str_attributes lstr_attributes
u_ds_data luo_data
long lstr_target_ds_index
long lstr_target_dc_index
treeviewitem ltvi_target_item
str_item_data lstr_target_item_data
treeviewitem ltvi_new_item
long ll_insert_before_idx
long ll_parenthandle
long ll_insert_after_handle
long ll_new_item_handle

// Get the target command information
li_sts = getitem(pl_target_handle, ltvi_target_item)
if li_sts <= 0 then return -1 

lstr_target_item_data = ltvi_target_item.data

lstr_target_ds_index = get_display_script(lstr_target_item_data.display_script_id)
if lstr_target_ds_index <= 0 then return -1

lstr_target_dc_index = get_display_command(lstr_target_ds_index, lstr_target_item_data.display_command_id)
if lstr_target_dc_index <= 0 then return -1

// Determine the insertion point
if pb_above then
	ll_insert_before_idx = lstr_target_dc_index
else
	ll_insert_before_idx = lstr_target_dc_index + 1
end if

// Before insertion, fix all the sort sequences
for i = 1 to display_script[lstr_target_ds_index].display_command_count
	display_script[lstr_target_ds_index].display_command[i].sort_sequence = i
next

// Next, make room for the new command
for i = display_script[lstr_target_ds_index].display_command_count to ll_insert_before_idx step -1
	display_script[lstr_target_ds_index].display_command[i + 1] = display_script[lstr_target_ds_index].display_command[i]
	display_script[lstr_target_ds_index].display_command[i + 1].sort_sequence = i + 1
next
display_script[lstr_target_ds_index].display_command_count += 1

// Copy the entire command
display_script[lstr_target_ds_index].display_command[ll_insert_before_idx] = pstr_command

// Now reset the display_command_id, id, and the sort_sequence
display_script[lstr_target_ds_index].display_command[ll_insert_before_idx].display_script_id = lstr_target_item_data.display_script_id
display_script[lstr_target_ds_index].display_command[ll_insert_before_idx].display_command_id = temp_display_command_id()
display_script[lstr_target_ds_index].display_command[ll_insert_before_idx].sort_sequence = ll_insert_before_idx
setnull(display_script[lstr_target_ds_index].display_command[ll_insert_before_idx].id)

// Now create the new treeviewitem
ltvi_new_item = create_command_item(display_script[lstr_target_ds_index].display_command[ll_insert_before_idx])

ll_parenthandle = FindItem(ParentTreeItem!, pl_target_handle)
if ll_parenthandle < 0 then return -1

if pb_above then
	ll_insert_after_handle = FindItem(PreviousTreeItem!, pl_target_handle)
	if ll_insert_after_handle >= 0 then
		ll_new_item_handle = InsertItem(ll_parenthandle, ll_insert_after_handle, ltvi_new_item)
	else
		ll_new_item_handle = InsertItemFirst(ll_parenthandle, ltvi_new_item)
	end if
else
	ll_new_item_handle = InsertItem (ll_parenthandle, pl_target_handle, ltvi_new_item)
end if

//if ll_new_item_handle > 0 then
//	expanditem(ll_new_item_handle)
//	selectitem(ll_new_item_handle)
//end if

changes_made()

return ll_new_item_handle

end function

public function long get_display_script (long pl_display_script_id);long i
str_display_script lstr_display_script
integer li_sts
long ll_found_reference
long ll_new_display_script_id
string ls_null
long ll_display_script_index

setnull(ls_null)

// We need to construct a local cache of all the display scripts referenced by our root display script.  This is so we can exit
// without saving the changes.

ll_found_reference = 0
for i = 1 to display_script_reference_count
	if display_script_reference[i].referenced_display_script_id = pl_display_script_id &
	 OR display_script_reference[i].actual_display_script_id = pl_display_script_id then
			ll_found_reference = i
			exit
	end if
next

if ll_found_reference > 0 then
	lstr_display_script = display_script[display_script_reference[ll_found_reference].display_script_index]
else
	// We didn't find the display script in our local cache, so get it from the bigger cache
	li_sts = datalist.display_script(pl_display_script_id, lstr_display_script, true)
	if li_sts <= 0 then return -1
end if

// If we need to edit it, then make sure we own it
if (not allow_editing) or (lstr_display_script.owner_id = sqlca.customer_id) then
	ll_new_display_script_id = lstr_display_script.display_script_id
else
	ll_new_display_script_id = sqlca.sp_local_copy_display_script(pl_display_script_id, lstr_display_script.id, ls_null, parent_config_object.config_object_id )
	if not tf_check() then return -1

	// We didn't find the display script in our local cache, so get it from the bigger cache
	li_sts = datalist.display_script(ll_new_display_script_id, lstr_display_script, true)
	if li_sts <= 0 then return -1

	// If we created a local copy for a found reference, then update the display script and the reference
	if ll_found_reference > 0 then
		display_script[display_script_reference[ll_found_reference].display_script_index] = lstr_display_script
		display_script_reference[ll_found_reference].actual_display_script_id = ll_new_display_script_id
	end if
end if

// If we hadn't found this display script before then add it to our cache
if ll_found_reference = 0 then
	// Add the display script to the local cache
	display_script_count += 1
	display_script[display_script_count] = lstr_display_script
	
	// Add the reference
	display_script_reference_count += 1
	display_script_reference[display_script_reference_count].referenced_display_script_id = pl_display_script_id
	display_script_reference[display_script_reference_count].actual_display_script_id = ll_new_display_script_id
	display_script_reference[display_script_reference_count].display_script_index = display_script_count
	
	// Return the newliy added script
	return display_script_count
else
	// if we already have the reference then return it
	return ll_found_reference
end if


end function

public subroutine new_command (long pl_handle, string ls_where);str_script_command_context lstr_context
str_popup popup
str_popup_return popup_return
str_c_display_command_definition lstr_command
long ll_row
long ll_rowcount
long i
integer li_sts
long ll_display_command_id
string ls_command_id
str_attributes lstr_attributes
u_ds_data luo_data
long ll_ds_idx
long ll_dc_idx
str_item_data lstr_item_data
treeviewitem ltvi_existing_item
treeviewitem ltvi_new_item
long ll_insert_before_idx
long ll_parenthandle
long ll_insert_after_handle
long ll_new_item_handle



li_sts = getitem(pl_handle, ltvi_existing_item)
if li_sts <= 0 then return 

lstr_item_data = ltvi_existing_item.data

ll_ds_idx = get_display_script(lstr_item_data.display_script_id)
if ll_ds_idx <= 0 then return

lstr_context.context_object = display_script[ll_ds_idx].context_object
lstr_context.script_type = display_script[ll_ds_idx].script_type
openwithparm(w_display_command_pick, lstr_context)
lstr_command = message.powerobjectparm
if isnull(lstr_command.display_command) then return

CHOOSE CASE lower(ls_where)
	CASE "top"
		// pl_handle is the parent under which the new command should be placed at the top
		ll_dc_idx = 1
		ll_insert_before_idx = 1
	CASE "bottom"
		// pl_handle is the parent under which the new command should be placed at the bottom
		ll_dc_idx = display_script[ll_ds_idx].display_command_count 
		ll_insert_before_idx = ll_dc_idx + 1
	CASE "above"
		// pl_handle is the sibling above which the new command should be placed
		ll_dc_idx = get_display_command(ll_ds_idx, lstr_item_data.display_command_id)
		if ll_dc_idx <= 0 then return
		ll_insert_before_idx = ll_dc_idx
	CASE "below"
		// pl_handle is the sibling below which the new command should be placed
		ll_dc_idx = get_display_command(ll_ds_idx, lstr_item_data.display_command_id)
		if ll_dc_idx <= 0 then return
		ll_insert_before_idx = ll_dc_idx + 1
	CASE ELSE
		return
END CHOOSE

// Make room for the new command, if necessary
for i = display_script[ll_ds_idx].display_command_count to ll_insert_before_idx step -1
	display_script[ll_ds_idx].display_command[i + 1] = display_script[ll_ds_idx].display_command[i]
next

// Increment the command count
display_script[ll_ds_idx].display_command_count += 1

// Reset the sort sequences
for i = 1 to display_script[ll_ds_idx].display_command_count
	display_script[ll_ds_idx].display_command[i].sort_sequence = i
next

// Fill in the data for the new command
display_script[ll_ds_idx].display_command[ll_insert_before_idx].display_script_id = display_script[ll_ds_idx].display_script_id
display_script[ll_ds_idx].display_command[ll_insert_before_idx].display_command_id = temp_display_command_id()
display_script[ll_ds_idx].display_command[ll_insert_before_idx].context_object = lstr_command.context_object
display_script[ll_ds_idx].display_command[ll_insert_before_idx].display_command = lstr_command.display_command
display_script[ll_ds_idx].display_command[ll_insert_before_idx].status = "OK"
setnull(display_script[ll_ds_idx].display_command[ll_insert_before_idx].id)
display_script[ll_ds_idx].display_command[ll_insert_before_idx].attributes.attribute_count = 0
display_script[ll_ds_idx].display_command[ll_insert_before_idx].command_component_id = lstr_command.id

// Now create the new treeviewitem
ltvi_new_item = create_command_item(display_script[ll_ds_idx].display_command[ll_insert_before_idx])


CHOOSE CASE lower(ls_where)
	CASE "top"
		ll_new_item_handle = InsertItemFirst(pl_handle, ltvi_new_item)
	CASE "bottom"
		ll_new_item_handle = InsertItemLast(pl_handle, ltvi_new_item)
	CASE "above"
		ll_parenthandle = FindItem(ParentTreeItem!, pl_handle)
		if ll_parenthandle < 0 then return
		
		ll_insert_after_handle = FindItem(PreviousTreeItem!, pl_handle)
		if ll_insert_after_handle >= 0 then
			ll_new_item_handle = InsertItem(ll_parenthandle, ll_insert_after_handle, ltvi_new_item)
		else
			ll_new_item_handle = InsertItemFirst(ll_parenthandle, ltvi_new_item)
		end if
	CASE "below"
		ll_parenthandle = FindItem(ParentTreeItem!, pl_handle)
		if ll_parenthandle < 0 then return
		
		ll_new_item_handle = InsertItem(ll_parenthandle, pl_handle, ltvi_new_item)
	CASE ELSE
		return
END CHOOSE


if ll_new_item_handle > 0 then
	selectitem(ll_new_item_handle)
	configure_command(ll_new_item_handle)
	expanditem(ll_new_item_handle)
end if


return

end subroutine

public subroutine new_command_old (long pl_handle, boolean pb_above);str_script_command_context lstr_context
str_popup popup
str_popup_return popup_return
str_c_display_command_definition lstr_command
long ll_row
long ll_rowcount
long i
integer li_sts
long ll_display_command_id
string ls_command_id
str_attributes lstr_attributes
u_ds_data luo_data
long ll_ds_idx
long ll_dc_idx
str_item_data lstr_item_data
treeviewitem ltvi_existing_item
treeviewitem ltvi_new_item
long ll_insert_before_idx
long ll_parenthandle
long ll_insert_after_handle
long ll_new_item_handle

li_sts = getitem(pl_handle, ltvi_existing_item)
if li_sts <= 0 then return 

lstr_item_data = ltvi_existing_item.data

ll_ds_idx = get_display_script(lstr_item_data.display_script_id)
if ll_ds_idx <= 0 then return

ll_dc_idx = get_display_command(ll_ds_idx, lstr_item_data.display_command_id)
if ll_dc_idx <= 0 then return

lstr_context.context_object = display_script[ll_ds_idx].display_command[ll_dc_idx].context_object
lstr_context.script_type = display_script[ll_ds_idx].script_type
openwithparm(w_display_command_pick, lstr_context)
lstr_command = message.powerobjectparm
if isnull(lstr_command.display_command) then return

if pb_above then
	ll_insert_before_idx = ll_dc_idx
else
	ll_insert_before_idx = ll_dc_idx + 1
end if

// Make room for the new command
for i = display_script[ll_ds_idx].display_command_count to ll_insert_before_idx step -1
	display_script[ll_ds_idx].display_command[i + 1] = display_script[ll_ds_idx].display_command[i]
	display_script[ll_ds_idx].display_command[i + 1].sort_sequence += 1
next
display_script[ll_ds_idx].display_command_count += 1

// Leave the display_script_id and sort_sequence as is
display_script[ll_ds_idx].display_command[ll_insert_before_idx].display_command_id = temp_display_command_id()
display_script[ll_ds_idx].display_command[ll_insert_before_idx].context_object = lstr_command.context_object
display_script[ll_ds_idx].display_command[ll_insert_before_idx].display_command = lstr_command.display_command
display_script[ll_ds_idx].display_command[ll_insert_before_idx].status = "OK"
setnull(display_script[ll_ds_idx].display_command[ll_insert_before_idx].id)
display_script[ll_ds_idx].display_command[ll_insert_before_idx].attributes.attribute_count = 0
display_script[ll_ds_idx].display_command[ll_insert_before_idx].command_component_id = lstr_command.id

// Now create the new treeviewitem
ltvi_new_item = create_command_item(display_script[ll_ds_idx].display_command[ll_insert_before_idx])

ll_parenthandle = FindItem(ParentTreeItem!, pl_handle)
if ll_parenthandle < 0 then return

if pb_above then
	ll_insert_after_handle = FindItem(PreviousTreeItem!, pl_handle)
	if ll_insert_after_handle >= 0 then
		ll_new_item_handle = InsertItem(ll_parenthandle, ll_insert_after_handle, ltvi_new_item)
	else
		ll_new_item_handle = InsertItemFirst(ll_parenthandle, ltvi_new_item)
	end if
else
	ll_new_item_handle = InsertItem (ll_parenthandle, pl_handle, ltvi_new_item)
end if

if ll_new_item_handle > 0 then
	selectitem(ll_new_item_handle)
	configure_command(ll_new_item_handle)
end if

expanditem(ll_new_item_handle)

return

end subroutine

public subroutine new_command (long pl_handle, boolean pb_above);string ls_where

if pb_above then
	ls_where = "above"
else
	ls_where = "below"
end if

new_command(pl_handle, ls_where)

end subroutine

public function integer selected_command (ref str_c_display_script_command pstr_command);integer li_sts
str_item_data lstr_item_data
treeviewitem ltvi_item
long ll_handle
long ll_index

if not allow_editing then return 0

ll_handle = FindItem(CurrentTreeItem!, 0)
if isnull(ll_handle) or ll_handle <= 0 then return 0

li_sts = getitem(ll_handle, ltvi_item)
if li_sts <= 0 then
	log.log(this, "u_tv_display_script.selected_command:0014", "Error getting new treeview item (" + string(ll_handle) + ")", 4)
	return -1
end if

lstr_item_data = ltvi_item.data

if upper(lstr_item_data.node_type) = "COMMAND" then
	pstr_command = lstr_item_data.command
	return 1
end if

return 0


end function

public subroutine select_next ();long ll_current_handle
long ll_next_handle


ll_current_handle = FindItem(CurrentTreeItem!, 0)
if isnull(ll_current_handle) or ll_current_handle <= 0 then return

ll_next_handle = FindItem(NextTreeItem!, ll_current_handle)
if isnull(ll_next_handle) or ll_next_handle <= 0 then return

selectitem(ll_next_handle)

end subroutine

public function integer first_command (ref str_c_display_script_command pstr_command);integer li_sts
str_item_data lstr_item_data
treeviewitem ltvi_item
long ll_root_handle
long ll_first_handle
long ll_index

if not allow_editing then return 0

ll_root_handle = FindItem(RootTreeItem!, 0)
if isnull(ll_root_handle) or ll_root_handle <= 0 then return 0

ll_first_handle = FindItem(ChildTreeItem!, ll_root_handle)
if isnull(ll_first_handle) or ll_first_handle <= 0 then return 0

li_sts = getitem(ll_first_handle, ltvi_item)
if li_sts <= 0 then
	log.log(this, "u_tv_display_script.first_command:0018", "Error getting new treeview item (" + string(ll_first_handle) + ")", 4)
	return -1
end if

lstr_item_data = ltvi_item.data

if upper(lstr_item_data.node_type) = "COMMAND" then
	pstr_command = lstr_item_data.command
end if

return 0


end function

public function integer select_command (str_c_display_script_command pstr_command);integer li_sts
str_item_data lstr_item_data
treeviewitem ltvi_item
long ll_root_handle
long ll_child_handle
long ll_index

ll_root_handle = FindItem(RootTreeItem!, 0)
if isnull(ll_root_handle) or ll_root_handle <= 0 then return 0

ll_child_handle = FindItem(ChildTreeItem!, ll_root_handle)
if isnull(ll_child_handle) or ll_child_handle <= 0 then return 0

DO WHILE ll_child_handle > 0
	li_sts = getitem(ll_child_handle, ltvi_item)
	if li_sts <= 0 then
		log.log(this, "u_tv_display_script.select_command:0017", "Error getting new treeview item (" + string(ll_child_handle) + ")", 4)
		return -1
	end if
	
	lstr_item_data = ltvi_item.data
	
	if pstr_command.display_script_id =  lstr_item_data.display_script_id AND pstr_command.display_command_id =  lstr_item_data.command.display_command_id then
		selectitem(ll_child_handle)
		return 1
	end if
	
	ll_child_handle = FindItem(NextTreeItem!, ll_child_handle)
LOOP

return 0


end function

on u_tv_display_script.create
end on

on u_tv_display_script.destroy
end on

event itempopulate;integer li_sts

li_sts = display_children(handle)
if li_sts < 0 then return -1

return 0

end event

event doubleclicked;integer li_sts
str_item_data lstr_item_data
treeviewitem ltvi_item

if not allow_editing then return

li_sts = getitem(handle, ltvi_item)
if li_sts <= 0 then
	log.log(this, "u_tv_display_script:doub", "Error getting new treeview item (" + string(handle) + ")", 4)
	return 1
end if

lstr_item_data = ltvi_item.data


CHOOSE CASE upper(lstr_item_data.node_type)
	CASE "DISPLAY_SCRIPT"
		if lstr_item_data.display_script_id <= 0 then return
	CASE "COMMAND"
		if lstr_item_data.display_script_id <= 0 or lstr_item_data.display_command_id <= 0 then return
		configure_command(handle)
	CASE "ATTRIBUTE"
		if lstr_item_data.display_script_id <= 0 or lstr_item_data.display_command_id <= 0 then return
		
		configure_attribute(handle)
END CHOOSE


// Since the double-click will close the item, then if it was expanded before then expand it now
if ltvi_item.expanded then this.function POST expanditem(handle)

end event

event rightclicked;integer li_sts
str_item_data lstr_item_data
treeviewitem ltvi_item

if not allow_editing then return

li_sts = getitem(handle, ltvi_item)
if li_sts <= 0 then
	log.log(this, "u_tv_display_script:righ", "Error getting new treeview item (" + string(handle) + ")", 4)
	return 1
end if

lstr_item_data = ltvi_item.data


CHOOSE CASE upper(lstr_item_data.node_type)
	CASE "DISPLAY_SCRIPT"
		display_script_menu(handle)
	CASE "COMMAND"
		display_command_menu(handle)
	CASE "ATTRIBUTE"
		display_command_attribute_menu(handle)
END CHOOSE


end event

event begindrag;drag_handle = handle
drag_right_button = false

end event

event dragdrop;string ls_classname
TreeViewItem ltvi_dragged_item
TreeViewItem ltvi_target_item
str_item_data lstr_dragged_item_data
str_item_data lstr_target_item_data
str_popup popup
str_popup_return popup_return
integer li_sts
string ls_new_value
long ll_parenthandle
long ll_insert_after_handle
long ll_new_item_handle

if handle <= 0 then return
if drag_handle <= 0 then return

li_sts = GetItem(handle, ltvi_target_item)
if li_sts < 0 then return

li_sts = GetItem(drag_handle, ltvi_dragged_item)
if li_sts < 0 then return

lstr_dragged_item_data = ltvi_dragged_item.data
lstr_target_item_data = ltvi_target_item.data


CHOOSE CASE upper(lstr_dragged_item_data.node_type) + "|" + upper(lstr_target_item_data.node_type)
	CASE "COMMAND|COMMAND"
		if lstr_dragged_item_data.parent_display_script_id <> lstr_target_item_data.parent_display_script_id &
		 OR drag_right_button then
			popup.data_row_count = 4
			popup.items[1] = "Copy Command Above"
			popup.items[2] = "Move Command Above"
			popup.items[3] = "Copy Command Below"
			popup.items[4] = "Move Command Below"
			openwithparm(w_pop_pick, popup)
			popup_return = message.powerobjectparm
			if popup_return.item_count <> 1 then return
			
			CHOOSE CASE popup_return.item_indexes[1]
				CASE 1
					copy_command(drag_handle, handle, true)
				CASE 2
					move_command(drag_handle, handle, true)
				CASE 3
					copy_command(drag_handle, handle, false)
				CASE 4
					move_command(drag_handle, handle, false)
				CASE ELSE
					return
			END CHOOSE
		else
			move_command(drag_handle, handle, true)
		end if
	CASE "COMMAND|DISPLAY_SCRIPT"
	CASE "ATTRIBUTE|ATTRIBUTE"
		if len(lstr_dragged_item_data.value) > 0 then
			set_attribute(handle, lstr_dragged_item_data.value)
			selectitem(handle)
		end if
END CHOOSE


//// Finally, to get around a bug in the treeview control, we need to delete and re-add the target node
//li_sts = GetItem(handle, ltvi_target_item)
//if li_sts < 0 then return
//
//ll_parenthandle = FindItem(ParentTreeItem!, handle)
//if ll_parenthandle < 0 then return -1
//
//
//ll_insert_after_handle = FindItem(PreviousTreeItem!, handle)
//if ll_insert_after_handle >= 0 then
//	ll_new_item_handle = InsertItem(ll_parenthandle, ll_insert_after_handle, ltvi_target_item)
//else
//	ll_new_item_handle = InsertItemFirst(ll_parenthandle, ltvi_target_item)
//end if
//deleteitem(handle)
//
end event

event beginrightdrag;drag_handle = handle
drag_right_button = true

end event

event dragwithin;treeviewitem ltvi_target_item
str_item_data lstr_target_item_data

GetItem(handle, ltvi_target_item)

lstr_target_item_data = ltvi_target_item.data

//selectitem(handle)

ltvi_target_item.drophighlighted = true

setitem(handle, ltvi_target_item)

return

end event

event key;//keyflags:
// 1 Shift key
// 2 Ctrl key
// 3 Shift and Ctrl keys
//
// display script Hotkeys
// Ctrl-C = copy
// Ctrl-V = Paste
// Delete = Delete
// Insert = Append Below (bottom if Display Script is selected)
// Shift-Insert = Append Above (Top if Display Script is selected)
// Shift-up = move up
// Shift-down = move down

integer li_sts
str_item_data lstr_item_data
treeviewitem ltvi_item
long ll_handle
long ll_from_ds_index
long ll_from_dc_index
boolean lb_above
long ll_new_item_handle
long ll_ds_idx
long ll_dc_idx
str_attributes lstr_attributes
long i
long ll_prev_handle


if not allow_editing then return

if key = KeyShift! then return
if key = KeyControl! then return


ll_handle = FindItem ( CurrentTreeItem!	, 0 )
if ll_handle <= 0 then return

li_sts = getitem(ll_handle, ltvi_item)
if li_sts <= 0 then return

lstr_item_data = ltvi_item.data

ll_ds_idx = get_display_script(lstr_item_data.display_script_id)
if ll_ds_idx <= 0 then return

ll_dc_idx = get_display_command(ll_ds_idx, lstr_item_data.display_command_id)
if ll_dc_idx <= 0 then return

lstr_attributes = display_script[ll_ds_idx].display_command[ll_dc_idx].attributes


CHOOSE CASE upper(lstr_item_data.node_type)
	CASE "DISPLAY_SCRIPT"
		CHOOSE CASE key
			CASE KeySpaceBar!
				if ltvi_item.expanded then
					collapseitem(ll_handle)
				else
					if keyflags = 1 then
						expandall(ll_handle)
					else
						expanditem(ll_handle)
					end if
				end if
			CASE KeyInsert!
				if keyflags = 1 then
					new_command(ll_handle, "top")
				else
					new_command(ll_handle, "bottom")
				end if
		END CHOOSE
	CASE "COMMAND"
		CHOOSE CASE key
			CASE KeyInsert!
				if keyflags = 1 then
					new_command(ll_handle, true)
				else
					new_command(ll_handle, false)
				end if
			CASE KeySpaceBar!
				if ltvi_item.expanded then
					collapseitem(ll_handle)
				else
					if keyflags = 1 then
						expandall(ll_handle)
					else
						expanditem(ll_handle)
					end if
				end if
			CASE KeyEnter!
				configure_command(ll_handle)
			CASE KeyC!
				if keyflags = 2 then
					copy_item_handle = ll_handle
					copy_item_data = lstr_item_data
				end if
			CASE KeyV!
				// Ctrl-V = paste above
				// Ctrl-Shift-V = paste below
				if keyflags = 2  or keyflags = 3 then
					if keyflags = 2 then
						lb_above = true
					else
						lb_above = false
					end if
					
					ll_from_ds_index = get_display_script(copy_item_data.display_script_id)
					if ll_from_ds_index <= 0 then return
					
					ll_from_dc_index = get_display_command(ll_from_ds_index, copy_item_data.display_command_id)
					if ll_from_dc_index <= 0 then return
					
					ll_new_item_handle = insert_command(display_script[ll_from_ds_index].display_command[ll_from_dc_index], ll_handle, lb_above)
					
					selectitem(ll_new_item_handle)
				end if
			CASE KeyDelete!
				for i = ll_dc_idx to display_script[ll_ds_idx].display_command_count - 1
					display_script[ll_ds_idx].display_command[i] = display_script[ll_ds_idx].display_command[i + 1]
				next
				display_script[ll_ds_idx].display_command_count -= 1
				deleteitem(ll_handle)
				changes_made()
			CASE KeyUpArrow!
				ll_prev_handle = FindItem (PreviousTreeItem!	, ll_handle )
				if ll_prev_handle <= 0 then return
				
				if keyflags = 1 then
					move_command(ll_prev_handle, ll_handle, false)
					this.function post selectitem(ll_handle)
					changes_made()
				elseif keyflags = 2 then
					 display_script[ll_ds_idx].display_command[ll_dc_idx].status = "NA"
					 if right(ltvi_item.label, 11) <> " (Disabled)" then
						ltvi_item.label += " (Disabled)"
						setitem(ll_handle, ltvi_item)
					end if
					this.function post selectitem(ll_prev_handle)
					changes_made()
				elseif keyflags = 3 then
					 display_script[ll_ds_idx].display_command[ll_dc_idx].status = "OK"
					 if right(ltvi_item.label, 11) = " (Disabled)" then
						ltvi_item.label = left(ltvi_item.label, len(ltvi_item.label) - 11)
						setitem(ll_handle, ltvi_item)
					end if
					this.function post selectitem(ll_prev_handle)
					changes_made()
				end if
			CASE KeyDownArrow!
				ll_prev_handle = FindItem ( NextTreeItem!	, ll_handle )
				if ll_prev_handle <= 0 then return
				
				if keyflags = 1 then
					move_command(ll_prev_handle, ll_handle, true)
					this.function post selectitem(ll_handle)
					changes_made()
				elseif keyflags = 2 then
					 display_script[ll_ds_idx].display_command[ll_dc_idx].status = "NA"
					 if right(ltvi_item.label, 11) <> " (Disabled)" then
						ltvi_item.label += " (Disabled)"
						setitem(ll_handle, ltvi_item)
					end if
					this.function post selectitem(ll_prev_handle)
					changes_made()
				elseif keyflags = 3 then
					 display_script[ll_ds_idx].display_command[ll_dc_idx].status = "OK"
					 if right(ltvi_item.label, 11) = " (Disabled)" then
						ltvi_item.label = left(ltvi_item.label, len(ltvi_item.label) - 11)
						setitem(ll_handle, ltvi_item)
					end if
					this.function post selectitem(ll_prev_handle)
					changes_made()
				end if
		END CHOOSE
	CASE "ATTRIBUTE"
		CHOOSE CASE key
			CASE KeyEnter!
				configure_attribute(ll_handle)
			CASE KeySpaceBar!
				if ltvi_item.expanded then
					collapseitem(ll_handle)
				else
					if keyflags = 1 then
						expandall(ll_handle)
					else
						expanditem(ll_handle)
					end if
				end if
		END CHOOSE
END CHOOSE



end event

event selectionchanged;integer li_sts
str_item_data lstr_item_data
treeviewitem ltvi_item

if not allow_editing then return

li_sts = getitem(newhandle, ltvi_item)
if li_sts <= 0 then
	log.log(this, "u_tv_display_script:sele", "Error getting new treeview item (" + string(newhandle) + ")", 4)
	return 1
end if

lstr_item_data = ltvi_item.data

if upper(lstr_item_data.node_type) = "COMMAND" then
	this.event post command_selected(lstr_item_data.command)
end if

end event

