$PBExportHeader$u_tv_practice_config.sru
forward
global type u_tv_practice_config from treeview
end type
type str_item_data from structure within u_tv_practice_config
end type
end forward

type str_item_data from structure
	string		node_type
	string		node_key
	string		id
	string		attribute
	string		value
	string		title
	long		interfaceserviceid
	long		transportsequence
	string		office_id
	string		room_id
	string		context_object
	string		purpose
	long		workplan_id
end type

global type u_tv_practice_config from treeview
integer width = 2569
integer height = 1544
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
string picturename[] = {"Report!","Step!","Custom041!","Structure!","interface_bidirectional_icon.bmp","GroupBox!","interface_out_only_icon.bmp","interface_in_only_icon.bmp","Exit!","Print!","Custom014!","DBAdmin!","Custom039!","button_changepurpose.bmp","Custom084!","ServerProfile!","Custom002!","NotFound!","SelectAll!","icon_peices.bmp","button_exclam_red.bmp","Library5!","button_workflow.bmp"}
long picturemaskcolor = 536870912
long statepicturemaskcolor = 536870912
event changes_made ( )
end type
global u_tv_practice_config u_tv_practice_config

type variables
private boolean allow_editing

private long last_item_handle

private boolean initializing

boolean changes_made


end variables

forward prototypes
public function integer display_practice (boolean pb_allow_editing)
public function integer display_practice_children (long pl_handle)
public function integer display_offices (long pl_handle)
public function integer display_interfaces (long pl_handle)
public function integer display_interface_children (long pl_handle)
public function integer display_transport_children (long pl_handle)
public function string attribute_description (string ps_attribute, string ps_value, string ps_param_title)
public subroutine delete_children (long pl_handle)
public function integer configure_transport_attribute (ref str_item_data pstr_item_data)
public function integer display_group_children (long pl_handle)
public subroutine practice_menu (long pl_handle)
public subroutine office_menu (long pl_handle)
public subroutine common_menu (long pl_handle)
public subroutine offices_menu (long pl_handle)
public function integer display_printers (long pl_handle)
public function integer display_attachments_children (long pl_handle)
public function integer display_locations (long pl_handle)
public function integer display_filetypes (long pl_handle)
public subroutine location_menu (long pl_handle)
public subroutine locations_menu (long pl_handle)
public subroutine interface_menu (long pl_handle)
public subroutine interfaces_menu (long pl_handle)
public subroutine interface_transport_menu (long pl_handle)
public subroutine redisplay (long pl_handle)
public subroutine refresh_description (long pl_handle)
public function integer display_interface_configuration (long pl_handle)
public function integer picture_index (string ps_picturename)
public function integer display_document_purposes (long pl_handle)
public function integer display_document_purpose_contexts (long pl_handle)
public function integer display_document_purpose_children (long pl_handle)
public function integer display_document_purpose_recipients (long pl_handle)
public function integer display_document_purpose_workplans (long pl_handle)
public subroutine purpose_workplan_menu (long pl_handle)
public function long configure_local_interface_transport (long pl_interfaceserviceid, ref long pl_transportsequence)
public function long new_interface_transport_old (long pl_interfaceserviceid)
public function integer configure_local_interface (ref long pl_interfaceserviceid)
public function long new_interface_old ()
public function long configure_interface_transport_actors (long pl_interfaceserviceid, ref long pl_transportsequence)
public function integer configure_epie_transport (str_item_data pstr_item_data)
public function integer display_sysadmin (long pl_handle)
public subroutine menu_sysadmins (long pl_handle)
public function integer display_sysadmins (long pl_handle)
public subroutine menu_sysadmin (long pl_handle)
public subroutine redisplay_parent (long pl_handle)
public function integer display_office_children_old (long pl_handle)
public function integer display_groups (long pl_handle)
public subroutine menu_group (long pl_handle)
public subroutine menu_room (long pl_handle)
public function integer add_room_to_group (string ps_office_id, long pl_group_id)
public function integer display_component_children (long pl_handle)
end prototypes

public function integer display_practice (boolean pb_allow_editing);treeviewitem ltvi_node
long ll_handle
integer li_sts
long ll_rows
str_item_data lstr_new_item_data
long ll_index
u_user luo_practice


allow_editing = pb_allow_editing

if isnull(common_thread.practice_user_id) then
	log.log(this, "u_tv_practice_config.display_practice.0013", "NULL practice_user_id", 4)
	return -1
end if

luo_practice = user_list.find_user(common_thread.practice_user_id)
if isnull(luo_practice) then
	log.log(this, "u_tv_practice_config.display_practice.0013", "practice_user_id not found (" + common_thread.practice_user_id + ")", 4)
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

lstr_new_item_data.node_type = "PRACTICE"
lstr_new_item_data.node_key = luo_practice.user_id

ltvi_node.data = lstr_new_item_data

ltvi_node.label = luo_practice.user_full_name
ltvi_node.children = true
ltvi_node.PictureIndex = 1
ltvi_node.SelectedPictureIndex = 1
ll_handle = insertitemlast(0, ltvi_node)

expanditem(ll_handle)

if last_item_handle > 0 then
	selectitem(last_item_handle)
end if

setredraw(true)

initializing = false

return 1

end function

public function integer display_practice_children (long pl_handle);treeviewitem ltvi_node
long ll_handle
integer li_sts
long ll_rows
str_item_data lstr_new_item_data
long ll_index
u_user luo_practice


// Add Offices Root
lstr_new_item_data.node_type = "OFFICES"
setnull(lstr_new_item_data.node_key)

ltvi_node.data = lstr_new_item_data

ltvi_node.label = "Offices"
ltvi_node.children = true
ltvi_node.PictureIndex = 4
ltvi_node.SelectedPictureIndex = 4
ll_handle = insertitemlast(pl_handle, ltvi_node)

// Add Administrator Root
lstr_new_item_data.node_type = "SYSADMINS"
setnull(lstr_new_item_data.node_key)

ltvi_node.data = lstr_new_item_data

ltvi_node.label = "System Administrators"
ltvi_node.children = true
ltvi_node.PictureIndex = 16
ltvi_node.SelectedPictureIndex = 16
ll_handle = insertitemlast(pl_handle, ltvi_node)

// Add Printers Root
lstr_new_item_data.node_type = "PRINTERS"
setnull(lstr_new_item_data.node_key)

ltvi_node.data = lstr_new_item_data

ltvi_node.label = "Server Printers"
ltvi_node.children = true
ltvi_node.PictureIndex = 10
ltvi_node.SelectedPictureIndex = 10
ll_handle = insertitemlast(pl_handle, ltvi_node)

// Add Attachment Settings
lstr_new_item_data.node_type = "ATTACHMENTS"
setnull(lstr_new_item_data.node_key)

ltvi_node.data = lstr_new_item_data

ltvi_node.label = "Attachment Settings"
ltvi_node.children = true
ltvi_node.PictureIndex = 11
ltvi_node.SelectedPictureIndex = 11
ll_handle = insertitemlast(pl_handle, ltvi_node)

// Add Interfaces Root
lstr_new_item_data.node_type = "INTERFACECONFIG"
setnull(lstr_new_item_data.node_key)

ltvi_node.data = lstr_new_item_data

ltvi_node.label = "Interface Configuration"
ltvi_node.children = true
ltvi_node.PictureIndex = 5
ltvi_node.SelectedPictureIndex = 5
ll_handle = insertitemlast(pl_handle, ltvi_node)

// Add Components Root
lstr_new_item_data.node_type = "COMPONENTS"
setnull(lstr_new_item_data.node_key)

ltvi_node.data = lstr_new_item_data

ltvi_node.label = "Components"
ltvi_node.children = true
ltvi_node.PictureIndex = 20
ltvi_node.SelectedPictureIndex = 20
ll_handle = insertitemlast(pl_handle, ltvi_node)

return 1

end function

public function integer display_offices (long pl_handle);treeviewitem ltvi_node
long ll_handle
integer li_sts
long ll_rows
str_item_data lstr_new_item_data
long ll_index
u_user luo_practice
u_ds_data luo_data
long ll_office_count
long i
string ls_status

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_office_list")
ll_office_count = luo_data.retrieve()

for i = 1 to ll_office_count
	lstr_new_item_data.node_type = "OFFICE"
	lstr_new_item_data.office_id = luo_data.object.office_id[i]
	ls_status = luo_data.object.status[i]
	
	ltvi_node.data = lstr_new_item_data
	
	ltvi_node.label = luo_data.object.description[i]
	if upper(ls_status) = "NA" then
		ltvi_node.label += " (Inactive)"
	end if
	
	ltvi_node.children = true
	ltvi_node.PictureIndex = 4
	ltvi_node.SelectedPictureIndex = 4
	ll_handle = insertitemlast(pl_handle, ltvi_node)
next

DESTROY luo_data


return 1

end function

public function integer display_interfaces (long pl_handle);treeviewitem ltvi_node
long ll_handle
integer li_sts
long ll_rows
str_item_data lstr_new_item_data
long ll_index
u_user luo_practice
u_ds_data luo_data
long ll_office_count
long i
string ls_status
string ls_icon
string ls_receive_flag
string ls_send_flag

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_practice_interfaces")
ll_office_count = luo_data.retrieve()

for i = 1 to ll_office_count
	lstr_new_item_data.node_type = "INTERFACE"
	lstr_new_item_data.interfaceserviceid = luo_data.object.interfaceserviceid[i]
	ltvi_node.data = lstr_new_item_data
	
	ltvi_node.label = luo_data.object.interfacedescription[i]
	ltvi_node.children = true
	
	ls_receive_flag = luo_data.object.receive_flag[i]
	ls_send_flag = luo_data.object.receive_flag[i]
	
	ls_icon = luo_data.object.interfaceServiceType_icon[i]
	
	ltvi_node.PictureIndex = picture_index(ls_icon)
	ltvi_node.SelectedPictureIndex = ltvi_node.PictureIndex
	ll_handle = insertitemlast(pl_handle, ltvi_node)
next

DESTROY luo_data


return 1

end function

public function integer display_interface_children (long pl_handle);treeviewitem ltvi_parent
treeviewitem ltvi_node
long ll_handle
integer li_sts
long ll_rows
str_item_data lstr_parent_item_data
str_item_data lstr_new_item_data
long ll_index
u_user luo_practice
u_ds_data luo_data
long ll_office_count
long i
string ls_direction
string ls_status
string ls_commcomponent
boolean lb_receiver_found
boolean lb_sender_found
string ls_receive_flag
string ls_send_flag
long ll_owner_id
string ls_comm_component_description

li_sts = getitem( pl_handle, ltvi_parent)
if li_sts < 0 then return -1

lstr_parent_item_data = ltvi_parent.data

SELECT receive_flag, send_flag, owner_id
INTO :ls_receive_flag, :ls_send_flag, :ll_owner_id
FROM dbo.fn_practice_interfaces()
WHERE interfaceserviceid = :lstr_parent_item_data.interfaceserviceid;
if not tf_check() then return -1


luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_practice_interface_transports")
ll_office_count = luo_data.retrieve(sqlca.customer_id, lstr_parent_item_data.interfaceserviceid)

lb_receiver_found = false
lb_sender_found = false
for i = 1 to ll_office_count
	if upper(string(luo_data.object.direction[i])) = "I" then
		lb_receiver_found = true
	end if
	if upper(string(luo_data.object.direction[i])) = "O" then
		lb_sender_found = true
	end if
next

if not lb_receiver_found and upper(ls_receive_flag) = "Y" and ll_owner_id <> sqlca.customer_id then
	ll_office_count = luo_data.insertrow(0)
	luo_data.object.transportsequence[ll_office_count] = 0
	luo_data.object.direction[ll_office_count] = "I"
	luo_data.object.commcomponent[ll_office_count] = 'Receiver_EpIE'
	luo_data.object.transportdescription[ll_office_count] = 'EpIE Receiver'
	luo_data.object.status[ll_office_count] = 'OK'
end if

if not lb_sender_found and upper(ls_send_flag) = "Y" and ll_owner_id <> sqlca.customer_id then
	ll_office_count = luo_data.insertrow(0)
	luo_data.object.transportsequence[ll_office_count] = 0
	luo_data.object.direction[ll_office_count] = "O"
	luo_data.object.commcomponent[ll_office_count] = 'Sender_EpIE'
	luo_data.object.transportdescription[ll_office_count] = 'EpIE Sender'
	luo_data.object.status[ll_office_count] = 'OK'
end if

for i = 1 to ll_office_count
	lstr_new_item_data.transportsequence = luo_data.object.transportsequence[i]
	ls_direction = upper(string(luo_data.object.direction[i]))
	ls_commcomponent = luo_data.object.commcomponent[i]
	lstr_new_item_data.node_type = "INTERFACE TRANSPORT"
	lstr_new_item_data.node_key = lstr_parent_item_data.node_key
	lstr_new_item_data.interfaceserviceid = lstr_parent_item_data.interfaceserviceid
	lstr_new_item_data.id = luo_data.object.comm_component_id[i]
	ls_comm_component_description = luo_data.object.comm_component_description[i]
	
	if len(lstr_new_item_data.id) > 0 then
		ltvi_node.children = true
	else
		ltvi_node.children = false
	end if
	
	ltvi_node.data = lstr_new_item_data
	
	if len(ls_comm_component_description) > 0 then
		ltvi_node.label = ls_comm_component_description + ": " + luo_data.object.transportdescription[i]
	else
		ltvi_node.label = luo_data.object.transportdescription[i]
	end if
	
	ls_status = luo_data.object.status[i]
	if lower(ls_status) <> 'ok' then
		ltvi_node.label += " (Disabled)"
	end if
	
	
	if ls_direction = "O" then
		ltvi_node.PictureIndex = 7
		ltvi_node.SelectedPictureIndex = 7
	else
		ltvi_node.PictureIndex = 8
		ltvi_node.SelectedPictureIndex = 8
	end if
	ll_handle = insertitemlast(pl_handle, ltvi_node)
next

DESTROY luo_data


return 1

end function

public function integer display_transport_children (long pl_handle);treeviewitem ltvi_node
long ll_handle
integer li_sts
long ll_rows
str_item_data lstr_new_item_data
long ll_index
u_user luo_practice
u_ds_data luo_data
long ll_attribute_count
long i
string ls_direction
string ls_left
string ls_right
str_params lstr_params
str_attributes lstr_attributes
treeviewitem ltvi_parent
str_item_data lstr_parent_item_data

li_sts = getitem(pl_handle, ltvi_parent)
if li_sts < 0 then return -1

lstr_parent_item_data = ltvi_parent.data

// Get the existing attributes for this transport
luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_practice_interface_transport_properties")
ll_attribute_count = luo_data.retrieve(sqlca.customer_id, lstr_parent_item_data.interfaceserviceid, lstr_parent_item_data.transportsequence)

f_attribute_ds_to_str(luo_data, lstr_attributes)

// Display each param with it's current value if any
for i = 1 to lstr_attributes.attribute_count
	// Add the attribute
	lstr_new_item_data.id = lstr_parent_item_data.id
	lstr_new_item_data.node_type = "TRANSPORT ATTRIBUTE"
	lstr_new_item_data.node_key = lstr_parent_item_data.node_key
	lstr_new_item_data.interfaceserviceid =  lstr_parent_item_data.interfaceserviceid
	lstr_new_item_data.transportsequence =  lstr_parent_item_data.transportsequence
	lstr_new_item_data.title = lstr_attributes.attribute[i].attribute
	lstr_new_item_data.attribute = lstr_attributes.attribute[i].attribute
	lstr_new_item_data.value = lstr_attributes.attribute[i].value
	ltvi_node.label = attribute_description(lstr_new_item_data.attribute, lstr_new_item_data.value, lstr_new_item_data.title)

	ltvi_node.children = false
	
	ltvi_node.PictureIndex = 3
	ltvi_node.SelectedPictureIndex = 3
	
	ltvi_node.data = lstr_new_item_data
	ll_handle = insertitemlast(pl_handle, ltvi_node)
next


DESTROY luo_data


return 1

end function

public function string attribute_description (string ps_attribute, string ps_value, string ps_param_title);string ls_description
string ls_value_description
string ls_null

setnull(ls_null)

if isnull(ps_attribute) or trim(ps_attribute) = "" then return ls_null

if isnull(ps_value) then ps_value = ""
ls_value_description = sqlca.fn_attribute_description(ps_attribute, ps_value)

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

public subroutine delete_children (long pl_handle);long ll_next_child_handle
long ll_temp_handle

// First delete the existing children
ll_next_child_handle = FindItem(ChildTreeItem!, pl_handle)
do while ll_next_child_handle > 0
	ll_temp_handle = ll_next_child_handle
	ll_next_child_handle = FindItem(NextTreeItem!, ll_temp_handle)
	deleteitem(ll_temp_handle)
loop

end subroutine

public function integer configure_transport_attribute (ref str_item_data pstr_item_data);str_params lstr_params
str_attributes lstr_attributes
string ls_value
integer li_sts
u_ds_data luo_data
long ll_attribute_count
long i
long ll_param_index
str_param_setting lstr_param
str_param_wizard_return lstr_return
string ls_new_value
string ls_find
long ll_row
w_param_setting lw_param_window

if isnull(pstr_item_data.id) or pstr_item_data.id = "" then return 0

// Get the existing attributes for this transport
luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_practice_interface_transport_properties")
ll_attribute_count = luo_data.retrieve(sqlca.customer_id, pstr_item_data.interfaceserviceid, pstr_item_data.transportsequence)

f_attribute_ds_to_str(luo_data, lstr_attributes)

ls_value = f_attribute_find_attribute(lstr_attributes, pstr_item_data.attribute)

// Find the param record
ll_param_index = 0
lstr_params = f_get_component_params(pstr_item_data.id, "Config")
for i = 1 to lstr_params.param_count
	if lower(lstr_params.params[i].token1) = lower(pstr_item_data.attribute) then
		ll_param_index = i
		exit
	end if
next
if ll_param_index <= 0 then return 0

// Prompt user for new attribute value
lstr_param.param = lstr_params.params[ll_param_index]
f_attribute_add_attribute(lstr_param.attributes, pstr_item_data.attribute, ls_value)

openwithparm(lw_param_window, lstr_param, "w_param_setting")
lstr_return = message.powerobjectparm
if lstr_return.return_status <= 0 then
	return 0
end if

ls_new_value = f_attribute_find_attribute(lstr_return.attributes, pstr_item_data.attribute)

ls_find = "attribute='" + pstr_item_data.attribute + "'"
ll_row = luo_data.find(ls_find, 1, luo_data.rowcount())
if ll_row > 0 then
	luo_data.object.value[ll_row] = ls_new_value
	li_sts = luo_data.update()
	pstr_item_data.value = ls_new_value
end if

DESTROY luo_data

return 1

end function

public function integer display_group_children (long pl_handle);treeviewitem ltvi_parent
treeviewitem ltvi_node
long ll_handle
integer li_sts
long ll_rows
str_item_data lstr_parent_item_data
str_item_data lstr_new_item_data
long ll_index
u_user luo_practice
long i
long ll_group_id
u_ds_data luo_data
long ll_room_count
string ls_status

li_sts = getitem(pl_handle, ltvi_parent)
if li_sts < 0 then return -1

lstr_parent_item_data = ltvi_parent.data

lstr_new_item_data.office_id = lstr_parent_item_data.office_id
ll_group_id = long(lstr_parent_item_data.node_key)

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_rooms_in_group_list")
ll_room_count = luo_data.retrieve(ll_group_id)
if ll_room_count < 0 then return -1


for i = 1 to ll_room_count
	ls_status = luo_data.object.status[i]
	lstr_new_item_data.node_type = "ROOM"
	lstr_new_item_data.room_id = luo_data.object.room_id[i]
	
	ltvi_node.data = lstr_new_item_data
	
	ltvi_node.label = luo_data.object.room_name[i]
	ltvi_node.children = false
	if ls_status = "OK" then
		ltvi_node.PictureIndex = 9
		ltvi_node.SelectedPictureIndex = 9
	else
		ltvi_node.PictureIndex = 18
		ltvi_node.SelectedPictureIndex = 18
	end if
	ll_handle = insertitemlast(pl_handle, ltvi_node)
next



return 1

end function

public subroutine practice_menu (long pl_handle);String		lsa_buttons[]
String 		ls_drug_id
String 		ls_description,ls_null
String		ls_top_20_code
Integer		li_sts, li_service_count
Long			ll_null
string ls_property
string ls_literal
str_property_value lstr_property_value
w_document_element_properties lw_document_element_properties
long ll_button_pressed
str_document_element_context lstr_document_element_context
window 				lw_pop_buttons
str_popup 			popup
str_popup 			popup2
str_popup_return 	popup_return
str_item_data lstr_item_data
treeviewitem ltvi_item

Setnull(ls_null)
Setnull(ll_null)

li_sts = getitem(pl_handle, ltvi_item)
if li_sts <= 0 then
	log.log(this, "u_tv_practice_config.practice_menu.0025", "Error getting new treeview item (" + string(pl_handle) + ")", 4)
	return
end if

lstr_item_data = ltvi_item.data

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_wrench.bmp"
	popup.button_helps[popup.button_count] = "Edit Practice Definition"
	popup.button_titles[popup.button_count] = "Edit Practice"
	lsa_buttons[popup.button_count] = "EDIT"
end if


if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	lsa_buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	ll_button_pressed = message.doubleparm
	if ll_button_pressed < 1 or ll_button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	ll_button_pressed = 1
else
	return
end if

CHOOSE CASE lsa_buttons[ll_button_pressed]
	CASE "EDIT"
		popup.data_row_count = 1
		popup.items[1] = lstr_item_data.node_key
		openwithparm(w_user_definition, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		ltvi_item.label = popup_return.descriptions[1]
		
		setitem(pl_handle, ltvi_item)
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

Return

end subroutine

public subroutine office_menu (long pl_handle);String		lsa_buttons[]
String 		ls_drug_id
String 		ls_description,ls_null
String		ls_top_20_code
Integer		li_sts, li_service_count
Long			ll_null
string ls_property
string ls_literal
str_property_value lstr_property_value
w_document_element_properties lw_document_element_properties
long ll_button_pressed
str_document_element_context lstr_document_element_context
window 				lw_pop_buttons
str_popup 			popup
str_popup 			popup2
str_popup_return 	popup_return
str_item_data lstr_item_data
treeviewitem ltvi_item
string ls_status
long ll_sort_sequence

Setnull(ls_null)
Setnull(ll_null)

li_sts = getitem(pl_handle, ltvi_item)
if li_sts <= 0 then
	log.log(this, "u_tv_practice_config.practice_menu.0025", "Error getting new treeview item (" + string(pl_handle) + ")", 4)
	return
end if

lstr_item_data = ltvi_item.data

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_wrench.bmp"
	popup.button_helps[popup.button_count] = "Edit Office Definition"
	popup.button_titles[popup.button_count] = "Edit Office"
	lsa_buttons[popup.button_count] = "EDIT"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_wrench.bmp"
	popup.button_helps[popup.button_count] = "New Room Group"
	popup.button_titles[popup.button_count] = "New Room Group"
	lsa_buttons[popup.button_count] = "NEWROOMGROUP"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonmove.bmp"
	popup.button_helps[popup.button_count] = "Order the groups in this office"
	popup.button_titles[popup.button_count] = "Group Order"
	lsa_buttons[popup.button_count] = "GROUPORDER"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonmove.bmp"
	popup.button_helps[popup.button_count] = "Order the rooms in this office"
	popup.button_titles[popup.button_count] = "Room Order"
	lsa_buttons[popup.button_count] = "ROOMORDER"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	lsa_buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	ll_button_pressed = message.doubleparm
	if ll_button_pressed < 1 or ll_button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	ll_button_pressed = 1
else
	return
end if

CHOOSE CASE lsa_buttons[ll_button_pressed]
	CASE "EDIT"
		popup.data_row_count = 1
		popup.items[1] = sqlca.fn_office_user_id(lstr_item_data.office_id)
		openwithparm(w_user_definition, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		
		// Refresh the status
		SELECT status
		INTO :ls_status
		FROM c_Office
		WHERE office_id = :lstr_item_data.office_id;
		if not tf_check() then return
		
		ltvi_item.label = popup_return.descriptions[1]
		if upper(ls_status) <> "OK" then
			ltvi_item.label += " (Inactive)"
		end if
		
		setitem(pl_handle, ltvi_item)
	CASE "NEWROOMGROUP"
		popup.title = "Enter name for new room group"
		popup.datacolumn = 32
		popup.dataobject = ""
		popup.data_row_count = 0
		openwithparm(w_pop_prompt_string, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		
		if len(popup_return.items[1]) > 0 then
			SELECT max(sort_sequence)
			INTO :ll_sort_sequence
			FROM o_Groups
			WHERE office_id = :lstr_item_data.office_id;
			if not tf_check() then return
			
			if ll_sort_sequence > 0 then
				ll_sort_sequence += 1
			else
				ll_sort_sequence = 1
			end if
			
			INSERT INTO o_Groups (
				description,
				sort_sequence,
				office_id,
				persistence_flag)
			VALUES (
				:popup_return.items[1],
				:ll_sort_sequence,
				:lstr_item_data.office_id,
				'Y');
			if not tf_check() then return
			
			redisplay(pl_handle)
		end if
	CASE "GROUPORDER"
		popup.dataobject = "dw_o_groups_for_office"
		popup.datacolumn = 1
		popup.displaycolumn = 2
		popup.argument_count = 1
		popup.argument[1] = lstr_item_data.office_id
		openwithparm(w_pop_order_datawindow, popup)
	CASE "ROOMORDER"
		popup.dataobject = "dw_room_list_office"
		popup.datacolumn = 1
		popup.displaycolumn = 2
		popup.argument_count = 1
		popup.argument[1] = lstr_item_data.office_id
		openwithparm(w_pop_order_datawindow, popup)
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

Return

end subroutine

public subroutine common_menu (long pl_handle);integer li_sts
str_item_data lstr_item_data
treeviewitem ltvi_item
string ls_display_name
string ls_fax_flag
string ls_printer

if not allow_editing then return

li_sts = getitem(pl_handle, ltvi_item)
if li_sts <= 0 then
	log.log(this, "u_tv_practice_config.practice_menu.0025", "Error getting new treeview item (" + string(pl_handle) + ")", 4)
	return
end if

lstr_item_data = ltvi_item.data

CHOOSE CASE upper(lstr_item_data.node_type)
	CASE "PRACTICE"
		practice_menu(pl_handle)
	CASE "OFFICES"
		offices_menu(pl_handle)
	CASE "OFFICE"
		office_menu(pl_handle)
	CASE "SYSADMINS"
		menu_sysadmins(pl_handle)
	CASE "SYSADMIN"
		menu_sysadmin(pl_handle)
	CASE "FILETYPE"
		openwithparm(w_config_attachment_extension, lstr_item_data.node_key)
	CASE "FILETYPES"
	CASE "GROUP"
		menu_group(pl_handle)
	CASE "LOCATION"
		location_menu(pl_handle)
	CASE "LOCATIONS"
		locations_menu(pl_handle)
	CASE "PRINTERS"
		open(w_configure_printers)
	CASE "PRINTER"
		ls_printer = lstr_item_data.node_key
		
		openwithparm(w_pop_printer_edit, ls_printer)
		
		SELECT display_name, fax_flag
		INTO :ls_display_name, :ls_fax_flag
		FROM o_Computer_Printer
		WHERE computer_id = 0
		AND printer = :ls_printer;
		if not tf_check() then return
		if sqlca.sqlnrows = 1 then
			ltvi_item.label = ls_display_name
			if upper(ls_fax_flag) = "Y" then
				ltvi_item.label += "  (Fax)"
			end if
			setitem(pl_handle, ltvi_item)
		end if
	CASE "PURPOSEWORKPLAN"
		purpose_workplan_menu(pl_handle)
	CASE "ROOM"
		menu_room(pl_handle)
	CASE "INTERFACES"
		interfaces_menu(pl_handle)
	CASE "INTERFACE"
		interface_menu(pl_handle)
	CASE "INTERFACE TRANSPORT"
		interface_transport_menu(pl_handle)
	CASE "TRANSPORT ATTRIBUTE"
		li_sts = configure_transport_attribute(lstr_item_data)
		if li_sts > 0 then
			ltvi_item.data = lstr_item_data
			ltvi_item.label = attribute_description(lstr_item_data.attribute, lstr_item_data.value, lstr_item_data.title)
			setitem(pl_handle, ltvi_item)
		end if
END CHOOSE


// Since the double-click will close the item, then if it was expanded before then expand it now
if ltvi_item.expanded then this.function POST expanditem(pl_handle)

end subroutine

public subroutine offices_menu (long pl_handle);String		lsa_buttons[]
String 		ls_drug_id
String 		ls_description,ls_null
String		ls_top_20_code
Integer		li_sts, li_service_count
Long			ll_null
string ls_property
string ls_literal
str_property_value lstr_property_value
w_document_element_properties lw_document_element_properties
long ll_button_pressed
str_document_element_context lstr_document_element_context
window 				lw_pop_buttons
str_popup 			popup
str_popup 			popup2
str_popup_return 	popup_return
str_item_data lstr_item_data
str_item_data lstr_new_item_data
treeviewitem ltvi_item
treeviewitem ltvi_new_item
string ls_user_id
long ll_new_handle
string ls_office_id
string ls_status

Setnull(ls_null)
Setnull(ll_null)

li_sts = getitem(pl_handle, ltvi_item)
if li_sts <= 0 then
	log.log(this, "u_tv_practice_config.practice_menu.0025", "Error getting new treeview item (" + string(pl_handle) + ")", 4)
	return
end if

lstr_item_data = ltvi_item.data

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_wrench.bmp"
	popup.button_helps[popup.button_count] = "New Office"
	popup.button_titles[popup.button_count] = "New Office"
	lsa_buttons[popup.button_count] = "NEW"
end if


if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	lsa_buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	ll_button_pressed = message.doubleparm
	if ll_button_pressed < 1 or ll_button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	ll_button_pressed = 1
else
	return
end if

CHOOSE CASE lsa_buttons[ll_button_pressed]
	CASE "NEW"
		// Create the new office
		ls_user_id = user_list.new_user("Office")

		// Add the new office to the display
		SELECT office_id, user_full_name, status
		INTO :ls_office_id, :ls_description, :ls_status
		FROM c_User
		WHERE user_id = :ls_user_id;
		if not tf_check() then return
		
		lstr_new_item_data.node_type = "OFFICE"
		lstr_new_item_data.office_id = ls_office_id
		
		ltvi_new_item.data = lstr_new_item_data
		
		ltvi_new_item.label = ls_description
		if upper(ls_status) <> "OK" then
			ltvi_item.label += " (Inactive)"
		end if
		
		ltvi_new_item.children = true
		ltvi_new_item.PictureIndex = 4
		ltvi_new_item.SelectedPictureIndex = 4
		ll_new_handle = insertitemlast(pl_handle, ltvi_new_item)
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

Return

end subroutine

public function integer display_printers (long pl_handle);treeviewitem ltvi_node
long ll_handle
integer li_sts
long ll_rows
str_item_data lstr_new_item_data
long ll_index
u_user luo_practice
u_ds_data luo_data
long ll_office_count
long i
string ls_fax_flag

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_server_printers_small")
ll_office_count = luo_data.retrieve()

for i = 1 to ll_office_count
	lstr_new_item_data.node_type = "PRINTER"
	lstr_new_item_data.node_key = luo_data.object.printer[i]
	ltvi_node.data = lstr_new_item_data
	
	ltvi_node.label = luo_data.object.display_name[i]
	ls_fax_flag = luo_data.object.fax_flag[i]
	if upper(ls_fax_flag) = "Y" then
		ltvi_node.label += "  (Fax)"
	end if
	
	ltvi_node.children = false
	ltvi_node.PictureIndex = 10
	ltvi_node.SelectedPictureIndex = 10
	ll_handle = insertitemlast(pl_handle, ltvi_node)
next

DESTROY luo_data


return 1

end function

public function integer display_attachments_children (long pl_handle);treeviewitem ltvi_node
long ll_handle
integer li_sts
long ll_rows
str_item_data lstr_new_item_data
long ll_index
u_user luo_practice


// Add Locations Root
lstr_new_item_data.node_type = "LOCATIONS"
setnull(lstr_new_item_data.node_key)

ltvi_node.data = lstr_new_item_data

ltvi_node.label = "Locations"
ltvi_node.children = true
ltvi_node.PictureIndex = 12
ltvi_node.SelectedPictureIndex = 12
ll_handle = insertitemlast(pl_handle, ltvi_node)

// Add File Types Root
lstr_new_item_data.node_type = "FILETYPES"
setnull(lstr_new_item_data.node_key)

ltvi_node.data = lstr_new_item_data

ltvi_node.label = "File Types"
ltvi_node.children = true
ltvi_node.PictureIndex = 13
ltvi_node.SelectedPictureIndex = 13
ll_handle = insertitemlast(pl_handle, ltvi_node)


return 1

end function

public function integer display_locations (long pl_handle);treeviewitem ltvi_node
long ll_handle
integer li_sts
long ll_rows
str_item_data lstr_new_item_data
long ll_index
u_user luo_practice
u_ds_data luo_data
long ll_office_count
long i
string ls_attachment_server
string ls_attachment_share
long ll_attachment_location_id
string ls_status

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_c_attachment_location")
ll_office_count = luo_data.retrieve()

for i = 1 to ll_office_count
	lstr_new_item_data.node_type = "LOCATION"
	
	ll_attachment_location_id = luo_data.object.attachment_location_id[i]
	ls_status = luo_data.object.status[i]
	
	lstr_new_item_data.node_key = string(ll_attachment_location_id)
	
	ltvi_node.data = lstr_new_item_data
	
	ls_attachment_server = luo_data.object.attachment_server[i]
	ls_attachment_share = luo_data.object.attachment_share[i]
	
	ltvi_node.label = string(ll_attachment_location_id) + "    \\" + ls_attachment_server + "\" + ls_attachment_share
	if upper(ls_status) = "NA" then
		ltvi_node.label += "  (Disabled)"
	end if
	
	ltvi_node.children = false
	ltvi_node.PictureIndex = 12
	ltvi_node.SelectedPictureIndex = 12
	ll_handle = insertitemlast(pl_handle, ltvi_node)
next

DESTROY luo_data


return 1

end function

public function integer display_filetypes (long pl_handle);treeviewitem ltvi_node
long ll_handle
integer li_sts
long ll_rows
str_item_data lstr_new_item_data
long ll_index
u_user luo_practice
u_ds_data luo_data
long ll_office_count
long i
string ls_extension

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_c_attachment_extension")
ll_office_count = luo_data.retrieve()

for i = 1 to ll_office_count
	lstr_new_item_data.node_type = "FILETYPE"
	
	ls_extension = luo_data.object.extension[i]
	
	lstr_new_item_data.node_key = ls_extension
	ltvi_node.data = lstr_new_item_data
	
	ltvi_node.label = "." + ls_extension
	
	ltvi_node.children = false
	ltvi_node.PictureIndex = 13
	ltvi_node.SelectedPictureIndex = 13
	ll_handle = insertitemlast(pl_handle, ltvi_node)
next

DESTROY luo_data


return 1

end function

public subroutine location_menu (long pl_handle);String		lsa_buttons[]
String 		ls_drug_id
String 		ls_description,ls_null
String		ls_top_20_code
Integer		li_sts, li_service_count
Long			ll_null
string ls_property
string ls_literal
str_property_value lstr_property_value
w_document_element_properties lw_document_element_properties
long ll_button_pressed
str_document_element_context lstr_document_element_context
window 				lw_pop_buttons
str_popup 			popup
str_popup 			popup2
str_popup_return 	popup_return
str_item_data lstr_item_data
treeviewitem ltvi_item
string ls_status
long ll_attachment_location_id
long ll_active_count
string ls_attachment_server
string ls_attachment_share

Setnull(ls_null)
Setnull(ll_null)

li_sts = getitem(pl_handle, ltvi_item)
if li_sts <= 0 then
	log.log(this, "u_tv_practice_config.practice_menu.0025", "Error getting new treeview item (" + string(pl_handle) + ")", 4)
	return
end if

lstr_item_data = ltvi_item.data

ll_attachment_location_id = long(lstr_item_data.node_key)
SELECT attachment_server, attachment_share, status
INTO :ls_attachment_server, :ls_attachment_share, :ls_status
FROM c_Attachment_Location
WHERE attachment_location_id = :ll_attachment_location_id;
if not tf_check() then return

if upper(ls_status) = "OK" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_wrench.bmp"
	popup.button_helps[popup.button_count] = "Disable this attachment location"
	popup.button_titles[popup.button_count] = "Disable"
	lsa_buttons[popup.button_count] = "DISABLE"
else
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_wrench.bmp"
	popup.button_helps[popup.button_count] = "Enable this attachment location"
	popup.button_titles[popup.button_count] = "Enable"
	lsa_buttons[popup.button_count] = "ENABLE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	lsa_buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	ll_button_pressed = message.doubleparm
	if ll_button_pressed < 1 or ll_button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	ll_button_pressed = 1
else
	return
end if

CHOOSE CASE lsa_buttons[ll_button_pressed]
	CASE "DISABLE"
		SELECT count(*)
		INTO :ll_active_count
		FROM c_Attachment_Location
		WHERE status = 'OK';
		if not tf_check() then return
		
		if ll_active_count > 1 then
			UPDATE c_Attachment_Location
			SET status = 'NA'
			WHERE attachment_location_id = :ll_attachment_location_id;
			if not tf_check() then return
			
			ltvi_item.label = string(ll_attachment_location_id) + "    \\" + ls_attachment_server + "\" + ls_attachment_share + "  (Disabled)"
			setitem(pl_handle, ltvi_item)
		else
			openwithparm(w_pop_message, "You may not disable the only active attachment location")
			return
		end if
	CASE "ENABLE"
		UPDATE c_Attachment_Location
		SET status = 'OK'
		WHERE attachment_location_id = :ll_attachment_location_id;
		if not tf_check() then return
		
		ltvi_item.label = string(ll_attachment_location_id) + "    \\" + ls_attachment_server + "\" + ls_attachment_share
		setitem(pl_handle, ltvi_item)
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

Return

end subroutine

public subroutine locations_menu (long pl_handle);String		lsa_buttons[]
String 		ls_drug_id
String 		ls_description,ls_null
String		ls_top_20_code
Integer		li_sts, li_service_count
Long			ll_null
string ls_property
string ls_literal
str_property_value lstr_property_value
w_document_element_properties lw_document_element_properties
long ll_button_pressed
str_document_element_context lstr_document_element_context
window 				lw_pop_buttons
str_popup 			popup
str_popup 			popup2
str_popup_return 	popup_return
str_item_data lstr_item_data
str_item_data lstr_new_item_data
treeviewitem ltvi_item
treeviewitem ltvi_new_item
string ls_status
long ll_new_attachment_location_id
string ls_attachment_server
string ls_attachment_share
long ll_new_handle

Setnull(ls_null)
Setnull(ll_null)

li_sts = getitem(pl_handle, ltvi_item)
if li_sts <= 0 then
	log.log(this, "u_tv_practice_config.practice_menu.0025", "Error getting new treeview item (" + string(pl_handle) + ")", 4)
	return
end if

lstr_item_data = ltvi_item.data

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_wrench.bmp"
	popup.button_helps[popup.button_count] = "Add New Attachment Location"
	popup.button_titles[popup.button_count] = "Add Location"
	lsa_buttons[popup.button_count] = "ADD"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	lsa_buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	ll_button_pressed = message.doubleparm
	if ll_button_pressed < 1 or ll_button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	ll_button_pressed = 1
else
	return
end if

CHOOSE CASE lsa_buttons[ll_button_pressed]
	CASE "ADD"
		ll_new_attachment_location_id = f_new_attachment_location()
		if ll_new_attachment_location_id > 0 and ltvi_item.expandedonce then
			lstr_new_item_data.node_key = string(ll_new_attachment_location_id)
			
			ltvi_new_item.data = lstr_new_item_data
			
			SELECT attachment_server, attachment_share
			INTO :ls_attachment_server, :ls_attachment_share
			FROM c_Attachment_Location
			WHERE attachment_location_id = :ll_new_attachment_location_id;
			if not tf_check() then return
			
			ltvi_new_item.label = string(ll_new_attachment_location_id) + "    \\" + ls_attachment_server + "\" + ls_attachment_share
			
			ltvi_new_item.children = false
			ltvi_new_item.PictureIndex = 12
			ltvi_new_item.SelectedPictureIndex = 12
			ll_new_handle = insertitemlast(pl_handle, ltvi_new_item)
		end if
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

Return

end subroutine

public subroutine interface_menu (long pl_handle);String		lsa_buttons[]
String 		ls_drug_id
String 		ls_description,ls_null
String		ls_top_20_code
Integer		li_sts, li_service_count
Long			ll_null
string ls_property
string ls_literal
str_property_value lstr_property_value
w_document_element_properties lw_document_element_properties
long ll_button_pressed
str_document_element_context lstr_document_element_context
window 				lw_pop_buttons
str_popup 			popup
str_popup 			popup2
str_popup_return 	popup_return
str_item_data lstr_item_data
treeviewitem ltvi_item
string ls_status
str_service_info lstr_service
long ll_transportsequence
long ll_interface_owner_id
string ls_document_route

Setnull(ls_null)
Setnull(ll_null)

li_sts = getitem(pl_handle, ltvi_item)
if li_sts <= 0 then
	log.log(this, "u_tv_practice_config.practice_menu.0025", "Error getting new treeview item (" + string(pl_handle) + ")", 4)
	return
end if

lstr_item_data = ltvi_item.data


SELECT owner_id, status, document_route
INTO :ll_interface_owner_id, :ls_status,  :ls_document_route
FROM c_Component_Interface
WHERE subscriber_owner_id = :sqlca.customer_id
AND interfaceserviceid = :lstr_item_data.interfaceserviceid;
if not tf_check() then return

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_mapping.bmp"
	popup.button_helps[popup.button_count] = "View/Edit Interface Mappings"
	popup.button_titles[popup.button_count] = "Mappings"
	lsa_buttons[popup.button_count] = "MAPPINGS"
end if

if ll_interface_owner_id = sqlca.customer_id then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_wrench.bmp"
	popup.button_helps[popup.button_count] = "Configure Interface"
	popup.button_titles[popup.button_count] = "Configure Interface"
	lsa_buttons[popup.button_count] = "CONFIGURE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_traffic_light_red.bmp"
	popup.button_helps[popup.button_count] = "Disable All Transports"
	popup.button_titles[popup.button_count] = "Disable All Transports"
	lsa_buttons[popup.button_count] = "DISABLE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_traffic_light_green.bmp"
	popup.button_helps[popup.button_count] = "Enable All Transports"
	popup.button_titles[popup.button_count] = "Enable All Transports"
	lsa_buttons[popup.button_count] = "ENABLE"
end if

if ll_interface_owner_id = sqlca.customer_id then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "interface_in_out.bmp"
	popup.button_helps[popup.button_count] = "New Transport"
	popup.button_titles[popup.button_count] = "New Transport"
	lsa_buttons[popup.button_count] = "NEWTRANSPORT"
end if

if ll_interface_owner_id = sqlca.customer_id then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Delete Interface"
	popup.button_titles[popup.button_count] = "Delete Interface"
	lsa_buttons[popup.button_count] = "DELETE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	lsa_buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	ll_button_pressed = message.doubleparm
	if ll_button_pressed < 1 or ll_button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	ll_button_pressed = 1
else
	return
end if

CHOOSE CASE lsa_buttons[ll_button_pressed]
	CASE "MAPPINGS"
		lstr_service.service = "Code Mappings"
		f_attribute_add_attribute(lstr_service.attributes, "interfaceserviceid", string(lstr_item_data.interfaceserviceid))
		
		li_sts = service_list.do_service(lstr_service)
		if li_sts < 0 then
			openwithparm(w_pop_message, "An error occured ordering tasks")
			return
		end if
	CASE "CONFIGURE"
		li_sts = configure_local_interface(lstr_item_data.interfaceserviceid)
		redisplay(pl_handle)
	CASE "DISABLE"
		UPDATE c_Component_Interface_Route
		SET status = 'NA'
		WHERE subscriber_owner_id = :sqlca.customer_id
		AND interfaceserviceid = :lstr_item_data.interfaceserviceid;
		if not tf_check() then return
		
		redisplay(pl_handle)
	CASE "ENABLE"
		UPDATE c_Component_Interface_Route
		SET status = 'OK'
		WHERE subscriber_owner_id = :sqlca.customer_id
		AND interfaceserviceid = :lstr_item_data.interfaceserviceid;
		if not tf_check() then return
		
		redisplay(pl_handle)
	CASE "NEWTRANSPORT"
		setnull(ll_transportsequence)
		li_sts = configure_local_interface_transport(lstr_item_data.interfaceserviceid, ll_transportsequence)
		if li_sts > 0 then
			redisplay(pl_handle)
		end if
	CASE "DELETE"
		if ll_interface_owner_id = sqlca.customer_id then
			openwithparm(w_pop_yes_no, "Are you sure you want to delete this interface?")
			popup_return = message.powerobjectparm
			if popup_return.item = "YES" then
				sqlca.config_delete_interface(lstr_item_data.interfaceserviceid)
				if not tf_check() then return
				
				deleteitem(pl_handle)
			end if
		else
			openwithparm(w_pop_message, "Only locally defined interfaces may be deleted")
			return
		end if
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

Return

end subroutine

public subroutine interfaces_menu (long pl_handle);String		lsa_buttons[]
String 		ls_drug_id
String 		ls_description,ls_null
String		ls_top_20_code
Integer		li_sts, li_service_count
Long			ll_null
string ls_property
string ls_literal
str_property_value lstr_property_value
w_document_element_properties lw_document_element_properties
long ll_button_pressed
str_document_element_context lstr_document_element_context
window 				lw_pop_buttons
str_popup 			popup
str_popup 			popup2
str_popup_return 	popup_return
str_item_data lstr_item_data
treeviewitem ltvi_item
string ls_status
str_service_info lstr_service
long ll_interfaceserviceid

Setnull(ls_null)
Setnull(ll_null)

li_sts = getitem(pl_handle, ltvi_item)
if li_sts <= 0 then
	log.log(this, "u_tv_practice_config.practice_menu.0025", "Error getting new treeview item (" + string(pl_handle) + ")", 4)
	return
end if

lstr_item_data = ltvi_item.data

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_interface.bmp"
	popup.button_helps[popup.button_count] = "New Interface"
	popup.button_titles[popup.button_count] = "New Interface"
	lsa_buttons[popup.button_count] = "NEW"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	lsa_buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	ll_button_pressed = message.doubleparm
	if ll_button_pressed < 1 or ll_button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	ll_button_pressed = 1
else
	return
end if

CHOOSE CASE lsa_buttons[ll_button_pressed]
	CASE "NEW"
		setnull(ll_interfaceserviceid)
		li_sts = configure_local_interface(ll_interfaceserviceid)
		redisplay(pl_handle)
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

Return

end subroutine

public subroutine interface_transport_menu (long pl_handle);String		lsa_buttons[]
String 		ls_drug_id
String 		ls_description,ls_null
String		ls_top_20_code
Integer		li_sts, li_service_count
Long			ll_null
string ls_property
string ls_literal
str_property_value lstr_property_value
w_document_element_properties lw_document_element_properties
long ll_button_pressed
str_document_element_context lstr_document_element_context
window 				lw_pop_buttons
str_popup 			popup
str_popup 			popup2
str_popup_return 	popup_return
str_item_data lstr_item_data
treeviewitem ltvi_item
string ls_status
str_service_info lstr_service
long ll_transport_owner_id
string ls_purpose
string ls_document_route
string ls_document_route_suffix
boolean lb_virtual_transport
string ls_direction

Setnull(ls_null)
Setnull(ll_null)

li_sts = getitem(pl_handle, ltvi_item)
if li_sts <= 0 then
	log.log(this, "u_tv_practice_config.practice_menu.0025", "Error getting new treeview item (" + string(pl_handle) + ")", 4)
	return
end if

lstr_item_data = ltvi_item.data

lb_virtual_transport = false // a virtual transport is a conection to or from EpIE that is not represented by an actual transport record

SELECT ownerid, status, purpose, document_route_suffix, direction
INTO :ll_transport_owner_id, :ls_status,  :ls_purpose, :ls_document_route_suffix, :ls_direction
FROM c_Component_Interface_Route
WHERE subscriber_owner_id = :sqlca.customer_id
AND interfaceserviceid = :lstr_item_data.interfaceserviceid
AND transportsequence = :lstr_item_data.transportsequence;
if not tf_check() then return
if sqlca.sqlnrows = 0 then
	lb_virtual_transport = true
end if

SELECT document_route
INTO :ls_document_route
FROM c_Component_Interface
WHERE subscriber_owner_id = :sqlca.customer_id
AND interfaceserviceid = :lstr_item_data.interfaceserviceid;
if not tf_check() then return

if len(ls_document_route_suffix) > 0 and len(ls_document_route) > 0 then
	ls_document_route += "." + ls_document_route_suffix
end if

if not lb_virtual_transport then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_wrench.bmp"
	popup.button_helps[popup.button_count] = "Configure Interface"
	popup.button_titles[popup.button_count] = "Configure Interface"
	lsa_buttons[popup.button_count] = "CONFIGURE"
end if

if not lb_virtual_transport then
	if upper(ls_status) = "OK" then
		popup.button_count = popup.button_count + 1
		popup.button_icons[popup.button_count] = "button_traffic_light_red.bmp"
		popup.button_helps[popup.button_count] = "Disable Transport"
		popup.button_titles[popup.button_count] = "Disable Transport"
		lsa_buttons[popup.button_count] = "DISABLE"
	else
		popup.button_count = popup.button_count + 1
		popup.button_icons[popup.button_count] = "button_traffic_light_green.bmp"
		popup.button_helps[popup.button_count] = "Enable Transport"
		popup.button_titles[popup.button_count] = "Enable Transport"
		lsa_buttons[popup.button_count] = "ENABLE"
	end if
end if

if upper(ls_direction) = "O" and ll_transport_owner_id = sqlca.customer_id then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_document_recipient.bmp"
	popup.button_helps[popup.button_count] = "Set Actors"
	popup.button_titles[popup.button_count] = "Set Actors"
	lsa_buttons[popup.button_count] = "ACTORS"
end if

if ll_transport_owner_id = sqlca.customer_id and not lb_virtual_transport then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Delete Transport"
	popup.button_titles[popup.button_count] = "Delete Transport"
	lsa_buttons[popup.button_count] = "DELETE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	lsa_buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	ll_button_pressed = message.doubleparm
	if ll_button_pressed < 1 or ll_button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	ll_button_pressed = 1
else
	return
end if

CHOOSE CASE lsa_buttons[ll_button_pressed]
	CASE "ACTORS"
		li_sts = configure_interface_transport_actors(lstr_item_data.interfaceserviceid, lstr_item_data.transportsequence)
	CASE "CONFIGURE"
		if ll_transport_owner_id = sqlca.customer_id then
			li_sts = configure_local_interface_transport(lstr_item_data.interfaceserviceid, lstr_item_data.transportsequence)
			if li_sts > 0 then
				redisplay(pl_handle)
			end if
		else
			li_sts = configure_epie_transport(lstr_item_data)
			if li_sts > 0 then
				redisplay(pl_handle)
			end if
		end if
	CASE "DISABLE"
		UPDATE c_Component_Interface_Route
		SET status = 'NA'
		WHERE subscriber_owner_id = :sqlca.customer_id
		AND interfaceserviceid = :lstr_item_data.interfaceserviceid
		AND transportsequence = :lstr_item_data.transportsequence;
		if not tf_check() then return
		
		refresh_description(pl_handle)
	CASE "ENABLE"
		UPDATE c_Component_Interface_Route
		SET status = 'OK'
		WHERE subscriber_owner_id = :sqlca.customer_id
		AND interfaceserviceid = :lstr_item_data.interfaceserviceid
		AND transportsequence = :lstr_item_data.transportsequence;
		if not tf_check() then return
		
		refresh_description(pl_handle)
	CASE "DELETE"
		openwithparm(w_pop_yes_no, "Are you sure you want to delete this transport?")
		popup_return = message.powerobjectparm
		if popup_return.item = "YES" then
			DELETE c_Component_Interface_Route_Property
			WHERE subscriber_owner_id = :sqlca.customer_id
			AND interfaceserviceid = :lstr_item_data.interfaceserviceid
			AND transportsequence = :lstr_item_data.transportsequence;
			if not tf_check() then return
			
			DELETE c_Component_Interface_Route
			WHERE subscriber_owner_id = :sqlca.customer_id
			AND interfaceserviceid = :lstr_item_data.interfaceserviceid
			AND transportsequence = :lstr_item_data.transportsequence;
			if not tf_check() then return

			if len(ls_document_route) > 0 then
				DELETE c_Document_Route
				WHERE document_route = :ls_document_route;
				if not tf_check() then return
			end if
			
			deleteitem(pl_handle)
		end if
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

Return

end subroutine

public subroutine redisplay (long pl_handle);treeviewitem ltvi_node
integer li_sts

refresh_description(pl_handle)

li_sts = getitem(pl_handle, ltvi_node)
if li_sts < 0 then return

delete_children(pl_handle)
if ltvi_node.expandedonce then
	this.event trigger itempopulate(pl_handle)
end if

end subroutine

public subroutine refresh_description (long pl_handle);string ls_description
string ls_status
treeviewitem ltvi_item
integer li_sts
str_item_data lstr_item_data
string ls_suffix
long ll_interface_owner_id
string ls_temp
string ls_room_name
string ls_persistence_flag
long ll_group_id

li_sts = getitem(pl_handle, ltvi_item)
if li_sts <= 0 then
	log.log(this, "u_tv_practice_config.practice_menu.0025", "Error getting new treeview item (" + string(pl_handle) + ")", 4)
	return
end if

lstr_item_data = ltvi_item.data

CHOOSE CASE upper(lstr_item_data.node_type)
	CASE "PURPOSEWORKPLAN"
		if lstr_item_data.node_key = "NEW" then
			ls_description = "New Object Workplan:  "
		else
			ls_description = "Existing Object Workplan:  "
		end if
		
		SELECT description
		INTO :ls_temp
		FROM c_Workplan
		WHERE workplan_id = :lstr_item_data.workplan_id;
		if not tf_check() then return
		if len(ls_temp) > 0 then
			ls_description += ls_temp
		else
			ls_description += "<None>"
		end if
		
		ltvi_item.label = ls_description
	CASE "INTERFACE"
		setnull(ls_description)
		
		SELECT interfacedescription
		INTO :ls_description
		FROM dbo.fn_practice_interfaces()
		WHERE interfaceserviceid = :lstr_item_data.interfaceserviceid;
		if not tf_check() then return
		if sqlca.sqlnrows < 1 then return
		
		ltvi_item.label = ls_description
	CASE "INTERFACE TRANSPORT"
		setnull(ls_description)
		
		SELECT transportdescription, status
		INTO :ls_description, :ls_status
		FROM c_Component_Interface_Route
		WHERE subscriber_owner_id = :sqlca.customer_id
		AND interfaceserviceid = :lstr_item_data.interfaceserviceid
		AND transportsequence = :lstr_item_data.transportsequence;
		if not tf_check() then return
		if sqlca.sqlnrows < 1 then return

		ltvi_item.label = ls_description
		if lower(ls_status) <> 'ok' then
			ltvi_item.label += " (Disabled)"
		end if
	CASE "ROOM"
		SELECT status, room_name
		INTO :ls_status, :ls_room_name
		FROM o_Rooms
		WHERE room_id = :lstr_item_data.room_id;
		if not tf_check() then return
		
		ltvi_item.label = ls_room_name
		ltvi_item.children = false
		if ls_status = "OK" then
			ltvi_item.PictureIndex = 9
			ltvi_item.SelectedPictureIndex = 9
		else
			ltvi_item.PictureIndex = 18
			ltvi_item.SelectedPictureIndex = 18
		end if
	CASE "GROUP"
		ll_group_id = long(lstr_item_data.node_key)
		
		SELECT description, persistence_flag
		INTO :ls_description, :ls_persistence_flag
		FROM o_Groups
		WHERE group_id = :ll_group_id;
		if not tf_check() then return
		
		ltvi_item.label = ls_description
		ltvi_item.children = true
		if ls_persistence_flag = "Y" then
			ltvi_item.PictureIndex = 6
			ltvi_item.SelectedPictureIndex = 6
		else
			ltvi_item.PictureIndex = 19
			ltvi_item.SelectedPictureIndex = 19
		end if
END CHOOSE

setitem(pl_handle, ltvi_item)

return



end subroutine

public function integer display_interface_configuration (long pl_handle);treeviewitem ltvi_node
long ll_handle
integer li_sts
long ll_rows
str_item_data lstr_new_item_data
long ll_index
u_user luo_practice


// Add Attachment Settings
lstr_new_item_data.node_type = "INTERFACEPURPOSE"
setnull(lstr_new_item_data.node_key)

ltvi_node.data = lstr_new_item_data

ltvi_node.label = "Document Purposes"
ltvi_node.children = true
ltvi_node.PictureIndex = 14
ltvi_node.SelectedPictureIndex = 14
ll_handle = insertitemlast(pl_handle, ltvi_node)

// Add Interfaces Root
lstr_new_item_data.node_type = "INTERFACES"
setnull(lstr_new_item_data.node_key)

ltvi_node.data = lstr_new_item_data

ltvi_node.label = "Installed Interfaces"
ltvi_node.children = true
ltvi_node.PictureIndex = 5
ltvi_node.SelectedPictureIndex = 5
ll_handle = insertitemlast(pl_handle, ltvi_node)

// Add Interfaces Root
lstr_new_item_data.node_type = "AVAILABLEINTERFACES"
setnull(lstr_new_item_data.node_key)

ltvi_node.data = lstr_new_item_data

ltvi_node.label = "Installable Interfaces"
ltvi_node.children = true
ltvi_node.PictureIndex = 5
ltvi_node.SelectedPictureIndex = 5
ll_handle = insertitemlast(pl_handle, ltvi_node)

return 1

end function

public function integer picture_index (string ps_picturename);integer i
integer li_index

li_index = 0
for i = 1 to upperbound(picturename)
	if lower(picturename[i]) = lower(ps_picturename) then
		li_index = i
		exit
	end if
next

if li_index = 0 then
	li_index = addpicture(ps_picturename)
end if

return li_index

end function

public function integer display_document_purposes (long pl_handle);treeviewitem ltvi_parent
treeviewitem ltvi_node
long ll_handle
integer li_sts
long ll_rows
str_item_data lstr_parent_item_data
str_item_data lstr_new_item_data
long ll_index
u_user luo_practice
u_ds_data luo_data
long ll_count
long i
string ls_direction
string ls_status

li_sts = getitem( pl_handle, ltvi_parent)
if li_sts < 0 then return -1

lstr_parent_item_data = ltvi_parent.data


luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_document_purposes_for_context")
ll_count = luo_data.retrieve(lstr_parent_item_data.node_key)


for i = 1 to ll_count
	lstr_new_item_data.node_type = "DOCUMENTPURPOSE"
	lstr_new_item_data.node_key = luo_data.object.purpose[i]
	lstr_new_item_data.purpose = luo_data.object.purpose[i]
	
	ltvi_node.children = true
	
	ltvi_node.data = lstr_new_item_data
	
	ltvi_node.label = lstr_new_item_data.node_key
	
	ltvi_node.PictureIndex = picture_index("button_changepurpose.bmp")
	ltvi_node.SelectedPictureIndex = ltvi_node.PictureIndex
	ll_handle = insertitemlast(pl_handle, ltvi_node)
next

DESTROY luo_data


return 1

end function

public function integer display_document_purpose_contexts (long pl_handle);treeviewitem ltvi_node
long ll_handle
integer li_sts
long ll_rows
str_item_data lstr_new_item_data
long ll_index
u_user luo_practice
u_ds_data luo_data
long ll_count
long ll_context_count
long i
string ls_status
string ls_icon
string ls_receive_flag
string ls_send_flag

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_domain_pick_list")
ll_context_count = luo_data.retrieve("CONTEXT_OBJECT")

for i = 1 to ll_context_count
	lstr_new_item_data.node_type = "PURPOSECONTEXT"
	lstr_new_item_data.node_key = luo_data.object.domain_item[i]
	lstr_new_item_data.context_object = luo_data.object.domain_item[i]
	ltvi_node.data = lstr_new_item_data
	
	ltvi_node.label = wordcap(lstr_new_item_data.node_key)
	
	SELECT count(*)
	INTO :ll_count
	FROM c_Document_Purpose
	WHERE context_object = :lstr_new_item_data.node_key;
	if not tf_check() then return -1
	
	if ll_count > 0 then
		ltvi_node.children = true
	else
		ltvi_node.children = false
	end if
	
	ltvi_node.PictureIndex = picture_index("button_changepurpose.bmp")
	ltvi_node.SelectedPictureIndex = ltvi_node.PictureIndex
	ll_handle = insertitemlast(pl_handle, ltvi_node)
next

DESTROY luo_data


return 1

end function

public function integer display_document_purpose_children (long pl_handle);treeviewitem ltvi_parent
treeviewitem ltvi_node
long ll_handle
integer li_sts
long ll_rows
str_item_data lstr_parent_item_data
str_item_data lstr_new_item_data
long ll_index
u_user luo_practice
u_ds_data luo_data
long ll_count
long i
string ls_direction
string ls_status

li_sts = getitem( pl_handle, ltvi_parent)
if li_sts < 0 then return -1

lstr_parent_item_data = ltvi_parent.data


////////////////////////////////////////////////////////////////////////////
// Actors
////////////////////////////////////////////////////////////////////////////
lstr_new_item_data = lstr_parent_item_data
lstr_new_item_data.node_type = "DOCUMENTPURPOSEACTORS"

SELECT count(*)
INTO :ll_count
FROM c_Actor_Class_Purpose
WHERE purpose = :lstr_new_item_data.purpose;
if not tf_check() then return -1

if ll_count > 0 then
	ltvi_node.children = true
else
	ltvi_node.children = false
end if
		

ltvi_node.data = lstr_new_item_data

ltvi_node.label = "Recipients"

ltvi_node.PictureIndex = picture_index("interface_out_only_icon.bmp")
ltvi_node.SelectedPictureIndex = ltvi_node.PictureIndex
ll_handle = insertitemlast(pl_handle, ltvi_node)



////////////////////////////////////////////////////////////////////////////
// Workplans
////////////////////////////////////////////////////////////////////////////
lstr_new_item_data = lstr_parent_item_data
lstr_new_item_data.node_type = "DOCUMENTPURPOSEWORKPLANS"

ltvi_node.children = true

ltvi_node.data = lstr_new_item_data

ltvi_node.label = "Workplans"

ltvi_node.PictureIndex = picture_index("button_workflow.bmp")
ltvi_node.SelectedPictureIndex = ltvi_node.PictureIndex
ll_handle = insertitemlast(pl_handle, ltvi_node)



return 1

end function

public function integer display_document_purpose_recipients (long pl_handle);treeviewitem ltvi_parent
treeviewitem ltvi_node
long ll_handle
integer li_sts
long ll_rows
str_item_data lstr_parent_item_data
str_item_data lstr_new_item_data
long ll_index
u_user luo_practice
u_ds_data luo_data
long ll_count
long i
string ls_direction
string ls_status
string ls_sql

li_sts = getitem( pl_handle, ltvi_parent)
if li_sts < 0 then return -1

lstr_parent_item_data = ltvi_parent.data

ls_sql = "SELECT actor_class FROM c_Actor_Class_Purpose WHERE purpose = '" + lstr_parent_item_data.purpose + "' AND status = 'OK' ORDER BY sort_sequence, actor_class"
luo_data = CREATE u_ds_data
ll_count = luo_data.load_query(ls_sql)

for i = 1 to ll_count
	lstr_new_item_data.node_type = "PURPOSEACTOR"
	lstr_new_item_data.node_key = luo_data.object.actor_class[i]
	ltvi_node.data = lstr_new_item_data
	
	ltvi_node.label = wordcap(lstr_new_item_data.node_key)
	ltvi_node.children = false
	
	ltvi_node.PictureIndex = picture_index("button_document_recipient.bmp")
	ltvi_node.SelectedPictureIndex = ltvi_node.PictureIndex
	ll_handle = insertitemlast(pl_handle, ltvi_node)
next


return 1

end function

public function integer display_document_purpose_workplans (long pl_handle);treeviewitem ltvi_parent
treeviewitem ltvi_node
long ll_handle
integer li_sts
long ll_rows
str_item_data lstr_parent_item_data
str_item_data lstr_new_item_data
long ll_index
u_user luo_practice
u_ds_data luo_data
long ll_count
long i
string ls_direction
string ls_status
long ll_new_object_workplan_id
long ll_existing_object_workplan_id
string ls_new_description
string ls_exists_description

li_sts = getitem( pl_handle, ltvi_parent)
if li_sts < 0 then return -1

lstr_parent_item_data = ltvi_parent.data


SELECT p.new_object_workplan_id,   
         p.existing_object_workplan_id,   
         wp_new.description as new_description,   
         wp_exist.description as exists_description
INTO :ll_new_object_workplan_id, :ll_existing_object_workplan_id, :ls_new_description, :ls_exists_description
FROM c_Document_Purpose p
	LEFT OUTER JOIN c_Workplan wp_new 
	ON p.new_object_workplan_id = wp_new.workplan_id 
	LEFT OUTER JOIN c_Workplan wp_exist 
	ON p.existing_object_workplan_id = wp_exist.workplan_id
WHERE p.purpose = :lstr_parent_item_data.purpose;


////////////////////////////////////////////////////////////////////////////
// New object workplan
////////////////////////////////////////////////////////////////////////////
lstr_new_item_data = lstr_parent_item_data
lstr_new_item_data.node_type = "PURPOSEWORKPLAN"
lstr_new_item_data.node_key = "NEW"
lstr_new_item_data.workplan_id = ll_new_object_workplan_id

ltvi_node.children = false

ltvi_node.data = lstr_new_item_data

ltvi_node.label = "New Object Workplan:  "
if len(ls_new_description) > 0 then
	ltvi_node.label += ls_new_description
else
	ltvi_node.label += "<None>"
end if

ltvi_node.PictureIndex = picture_index("button_workflow.bmp")
ltvi_node.SelectedPictureIndex = ltvi_node.PictureIndex
ll_handle = insertitemlast(pl_handle, ltvi_node)


////////////////////////////////////////////////////////////////////////////
// Existing object workplan
////////////////////////////////////////////////////////////////////////////
lstr_new_item_data = lstr_parent_item_data
lstr_new_item_data.node_type = "PURPOSEWORKPLAN"
lstr_new_item_data.node_key = "EXISTING"
lstr_new_item_data.workplan_id = ll_existing_object_workplan_id

ltvi_node.children = false

ltvi_node.data = lstr_new_item_data

ltvi_node.label = "Existing Object Workplan:  "
if len(ls_exists_description) > 0 then
	ltvi_node.label += ls_exists_description
else
	ltvi_node.label += "<None>"
end if

ltvi_node.PictureIndex = picture_index("button_workflow.bmp")
ltvi_node.SelectedPictureIndex = ltvi_node.PictureIndex
ll_handle = insertitemlast(pl_handle, ltvi_node)


return 1

end function

public subroutine purpose_workplan_menu (long pl_handle);String		lsa_buttons[]
String 		ls_drug_id
String 		ls_description,ls_null
String		ls_top_20_code
Integer		li_sts, li_service_count
Long			ll_null
string ls_property
string ls_literal
str_property_value lstr_property_value
w_document_element_properties lw_document_element_properties
long ll_button_pressed
str_document_element_context lstr_document_element_context
window 				lw_pop_buttons
str_popup 			popup
str_popup 			popup2
str_popup_return 	popup_return
str_item_data lstr_item_data
treeviewitem ltvi_item
string ls_status
str_service_info lstr_service
string ls_id
w_window_base lw_window
str_c_workplan lstr_workplan
str_workplan_context lstr_workplan_context

Setnull(ls_null)
Setnull(ll_null)

li_sts = getitem(pl_handle, ltvi_item)
if li_sts <= 0 then
	log.log(this, "u_tv_practice_config.practice_menu.0025", "Error getting new treeview item (" + string(pl_handle) + ")", 4)
	return
end if

lstr_item_data = ltvi_item.data


if lstr_item_data.workplan_id > 0 then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_wrench.bmp"
	popup.button_helps[popup.button_count] = "Edit Workplan"
	popup.button_titles[popup.button_count] = "Edit Workplan"
	lsa_buttons[popup.button_count] = "EDIT"
end if

if lstr_item_data.workplan_id > 0 then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_wrench.bmp"
	popup.button_helps[popup.button_count] = "Change Workplan"
	popup.button_titles[popup.button_count] = "Change Workplan"
	lsa_buttons[popup.button_count] = "SET"
else
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_wrench.bmp"
	popup.button_helps[popup.button_count] = "Set Workplan"
	popup.button_titles[popup.button_count] = "Set Workplan"
	lsa_buttons[popup.button_count] = "SET"
end if

if lstr_item_data.workplan_id > 0 then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_wrench.bmp"
	popup.button_helps[popup.button_count] = "Remove Workplan"
	popup.button_titles[popup.button_count] = "Remove Workplan"
	lsa_buttons[popup.button_count] = "REMOVE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	lsa_buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	ll_button_pressed = message.doubleparm
	if ll_button_pressed < 1 or ll_button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	ll_button_pressed = 1
else
	return
end if

CHOOSE CASE lsa_buttons[ll_button_pressed]
	CASE "EDIT"
		SELECT CAST(id AS varchar(40))
		INTO :ls_id
		FROM c_workplan
		WHERE workplan_id = :lstr_item_data.workplan_id;
		if not tf_check() then return
		if sqlca.sqlcode = 100 then return
		
		popup.data_row_count = 2
		popup.items[1] = ls_id
		popup.items[2] = "true"
		
		openwithparm(lw_window, popup, "w_Workplan_definition_display")
	CASE "SET"
		lstr_workplan_context.context_object = lstr_item_data.context_object
		lstr_workplan_context.in_office_flag = "N"
		
		openwithparm(lw_window, lstr_workplan_context, "w_pick_workplan")
		lstr_workplan = message.powerobjectparm
		if isnull(lstr_workplan.workplan_id) then return
		
		if lstr_item_data.node_key = "NEW" then
			UPDATE c_Document_Purpose
			SET new_object_workplan_id = :lstr_workplan.workplan_id
			WHERE purpose = :lstr_item_data.purpose;
			if not tf_check() then return
		else
			UPDATE c_Document_Purpose
			SET existing_object_workplan_id = :lstr_workplan.workplan_id
			WHERE purpose = :lstr_item_data.purpose;
			if not tf_check() then return
		end if
		
		lstr_item_data.workplan_id = lstr_workplan.workplan_id
		ltvi_item.data = lstr_item_data
		setitem(pl_handle, ltvi_item)
		
		refresh_description(pl_handle)
	CASE "REMOVE"
		if lstr_item_data.node_key = "NEW" then
			UPDATE c_Document_Purpose
			SET new_object_workplan_id = NULL
			WHERE purpose = :lstr_item_data.purpose;
			if not tf_check() then return
		else
			UPDATE c_Document_Purpose
			SET existing_object_workplan_id = NULL
			WHERE purpose = :lstr_item_data.purpose;
			if not tf_check() then return
		end if
		
		setnull(lstr_item_data.workplan_id)
		ltvi_item.data = lstr_item_data
		setitem(pl_handle, ltvi_item)
		
		refresh_description(pl_handle)
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

Return

end subroutine

public function long configure_local_interface_transport (long pl_interfaceserviceid, ref long pl_transportsequence);str_popup popup
str_popup_return popup_return
string ls_id
str_params lstr_params
str_attributes lstr_attributes
string ls_value
integer li_sts
long ll_attribute_count
long i
string ls_interfaceservicetype
string ls_commcomponent
string ls_transportdescription
string ls_documenttype
long ll_count
string ls_interfacedescription
string ls_purpose
string ls_document_route
string ls_document_route_suffix
string ls_original_document_route
string ls_original_document_route_suffix
string ls_new_document_route
string ls_document_format
string ls_send_from
string ls_direction
u_ds_data luo_data
string ls_receive_flag
string ls_send_flag
string ls_original_document_format
string ls_original_documenttype
string ls_original_send_from
string ls_original_commcomponent

if isnull(pl_interfaceserviceid) then
	log.log(this, "u_tv_practice_config.configure_local_interface_transport.0034", "NULL interface service id", 4)
	return -1
end if

// Get some info about the interface
SELECT description, interfaceservicetype, document_route, receive_flag, send_flag
INTO :ls_interfacedescription, :ls_interfaceservicetype, :ls_document_route, :ls_receive_flag, :ls_send_flag
FROM c_component_interface
WHERE interfaceserviceid = :pl_interfaceserviceid;
if not tf_check() then return -1
if sqlca.sqlnrows = 0 then
	log.log(this, "u_tv_practice_config.configure_local_interface_transport.0034", "interface service id not found (" + string(pl_interfaceserviceid) + ")", 4)
	return -1
end if

// Get the existing attributes for this transport
luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_practice_interface_transport_properties")

if isnull(pl_transportsequence) then
	setnull(ls_original_document_route)
	setnull(ls_original_document_route_suffix)
	
	// If this is a new transport then figure out if it's incoming or outgoing.
	popup.data_row_count = 0
	if ls_receive_flag = "Y" then
		popup.data_row_count += 1
		popup.items[popup.data_row_count] = "In"
	end if
	if ls_send_flag = "Y" then
		popup.data_row_count += 1
		popup.items[popup.data_row_count] = "Out"
	end if
	popup.title = "New Transport Direction"
	if popup.data_row_count = 0 then
		log.log(this, "u_tv_practice_config.configure_local_interface_transport.0069", "Interface does not allow either sending or receiving (" + string(pl_interfaceserviceid) + ")", 4)
		return -1
	end if
	if popup.data_row_count = 1 then
		ls_direction = popup.items[1]
	else
		openwithparm(w_pop_pick, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return 0
		ls_direction = popup_return.items[1]
	end if
	ls_direction = left(ls_direction, 1)
else
	SELECT direction
	INTO :ls_direction
	FROM c_component_interface_route
	WHERE interfaceserviceid = :pl_interfaceserviceid
	AND transportsequence = :pl_transportsequence;
	if not tf_check() then return -1
	
	ll_attribute_count = luo_data.retrieve(sqlca.customer_id, pl_interfaceserviceid, pl_transportsequence)
	
	f_attribute_ds_to_str(luo_data, lstr_attributes)
	
	ls_original_document_route_suffix = f_attribute_find_attribute(lstr_attributes, "document_route_suffix")
	if len(ls_original_document_route_suffix) > 0 then
		ls_original_document_route = ls_document_route + "." + ls_original_document_route_suffix
	else
		ls_original_document_route = ls_document_route
	end if
	
	SELECT document_format, document_type, send_from, sender_component_id
	INTO 		:ls_original_document_format,
				:ls_original_documenttype,
				:ls_original_send_from,
				:ls_original_commcomponent
	FROM c_Document_Route
	WHERE document_route = :ls_original_document_route;
	if not tf_check() then return -1
end if

// Define the new interface transport
if ls_direction = "O" then
	ls_id = "{18D9F50E-5DC2-4322-960E-BCC418B1B57E}"  // New outgoing transport
else
	ls_id = "{184E2FB6-7532-4860-ABC3-1550341CF96F}"  // New incoming transport
end if

li_sts = f_get_params(ls_id, "Config", lstr_attributes)
if li_sts < 0 then return -1

// Get attributes returned from wizard
ls_commcomponent = f_attribute_find_attribute(lstr_attributes, "component_id")
if isnull(ls_commcomponent) then
	openwithparm(w_pop_message, "Comm Component is required")
	return 0
end if
ls_transportdescription = f_attribute_find_attribute(lstr_attributes, "transportdescription")
if isnull(ls_transportdescription) then
	openwithparm(w_pop_message, "Transport Description is required")
	return 0
end if
ls_documenttype = f_attribute_find_attribute(lstr_attributes, "documenttype")
ls_purpose = f_attribute_find_attribute(lstr_attributes, "purpose")
ls_document_route_suffix = f_attribute_find_attribute(lstr_attributes, "document_route_suffix")
ls_document_format = f_attribute_find_attribute(lstr_attributes, "document_format")
if isnull(ls_document_format) or lower(ls_document_format) <> "machine" then ls_document_format = "Human"
ls_send_from = f_attribute_find_attribute(lstr_attributes, "send_from")
if isnull(ls_send_from) or lower(ls_send_from) <> "client" then ls_send_from = "Server"

// validate the document_route_suffix
if len(ls_document_route_suffix) > 0 then
	ls_new_document_route = ls_document_route + "." + ls_document_route_suffix
	if len(ls_new_document_route) > 24 then
		openwithparm(w_pop_message, "The document route suffix is too long.  The combination of the document route and document route suffix must not exceed 24 characters")
		return -1
	end if
else
	ls_new_document_route = ls_document_route
end if

if not isnull(pl_transportsequence) and ls_original_document_route <> ls_new_document_route then
	SELECT count(*)
	INTO :ll_count
	FROM c_Document_Route
	WHERE document_route = :ls_new_document_route;
	if not tf_check() then return -1
	
	if ll_count > 0 then
		openwithparm(w_pop_message, "The document route ~"" + ls_new_document_route + "~" already exists.  Document route suffix must be unique within the interface or left blank.")
		return -1
	end if
end if

if isnull(pl_transportsequence) then
	SELECT max(transportsequence)
	INTO :pl_transportsequence
	FROM c_component_interface_route
	WHERE subscriber_owner_id = :sqlca.customer_id
	AND interfaceserviceid = :pl_interfaceserviceid;
	if not tf_check() then return -1
	
	if isnull(pl_transportsequence) or pl_transportsequence <= 0 then
		pl_transportsequence = 1
	else
		pl_transportsequence += 1
	end if
	
	INSERT INTO c_component_interface_route  
				( ownerid,   
				  subscriber_owner_id,   
				  interfaceservicetype,   
				  interfaceserviceid,   
				  interfacedescription,   
				  transportsequence,   
				  transportdescription,   
				  commcomponent,   
				  documenttype,   
				  direction,   
				  epie_transform,   
				  status,   
				  purpose,   
				  document_route_suffix )  
	  VALUES ( :sqlca.customer_id,   
				  :sqlca.customer_id,   
				  :ls_interfaceservicetype,   
				  :pl_interfaceserviceid,   
				  :ls_interfacedescription,   
				  :pl_transportsequence,   
				  :ls_transportdescription,   
				  :ls_commcomponent,   
				  :ls_documenttype,   
				  :ls_direction,   
				  'N',   
				  'OK',   
				  :ls_purpose,   
				  :ls_document_route_suffix )  ;
	if not tf_check() then return -1
else
	UPDATE c_component_interface_route  
	SET transportdescription = :ls_transportdescription,   
		  commcomponent = :ls_commcomponent,   
		  documenttype = :ls_documenttype,   
		  purpose = :ls_purpose,   
		  document_route_suffix = :ls_document_route_suffix
	WHERE interfaceserviceid = :pl_interfaceserviceid
	AND transportsequence = :pl_transportsequence;
	if not tf_check() then return -1
end if


if ls_direction = "O" and len(ls_new_document_route) > 0 then
	if isnull(ls_original_document_route) or (ls_original_document_route <> ls_new_document_route) then
		// remove the old document_route if necessary
		if len(ls_original_document_route) > 0 then
			DELETE dbo.c_Document_Route 
			WHERE document_route = :ls_original_document_route;
			if not tf_check() then return -1
		end if
		
		// Add the document route for this transport
		INSERT INTO dbo.c_Document_Route (
				document_route,
				sent_status,
				status,
				owner_id,
				last_updated,
				id,
				document_format,
				sender_id_key,
				receiver_id_key,
				send_via_addressee,
				document_type,
				communication_type,
				sending_status,
				send_from,
				sender_component_id)
		VALUES (
				:ls_new_document_route,
				'Sent',
				'OK',
				:sqlca.customer_id,
				getdate(),
				newid(),
				:ls_document_format,
				NULL,
				NULL,
				:pl_interfaceserviceid,
				:ls_documenttype,
				NULL,
				'Sending',
				:ls_send_from,
				:ls_commcomponent );
		if not tf_check() then return -1
	elseif len(ls_original_document_route) > 0 then
		// We have a document_route that already existed.  See if any of the properties need to be updated
		if not f_strings_equal(ls_original_document_format, ls_document_format) then
			UPDATE dbo.c_Document_Route
			SET document_format = :ls_document_format
			WHERE document_route = :ls_new_document_route;
			if not tf_check() then return -1
		end if
		
		if not f_strings_equal(ls_original_documenttype, ls_documenttype) then
			UPDATE dbo.c_Document_Route
			SET document_type = :ls_documenttype
			WHERE document_route = :ls_new_document_route;
			if not tf_check() then return -1
		end if
		
		if not f_strings_equal(ls_original_send_from, ls_send_from) then
			UPDATE dbo.c_Document_Route
			SET send_from = :ls_send_from
			WHERE document_route = :ls_new_document_route;
			if not tf_check() then return -1
		end if
		
		if not f_strings_equal(ls_original_commcomponent, ls_commcomponent) then
			UPDATE dbo.c_Document_Route
			SET sender_component_id = :ls_commcomponent
			WHERE document_route = :ls_new_document_route;
			if not tf_check() then return -1
		end if
	end if
end if


// Save the attributes in the properties table
f_attribute_str_to_ds_with_removal(lstr_attributes, luo_data)

for i = 1 to luo_data.rowcount()
	if isnull(luo_data.object.subscriber_owner_id[i]) then
		luo_data.object.subscriber_owner_id[i] = sqlca.customer_id
		luo_data.object.interfaceserviceid[i] = pl_interfaceserviceid
		luo_data.object.transportsequence[i] = pl_transportsequence
		luo_data.object.property[i] = luo_data.object.attribute[i]
		luo_data.object.last_updated[i] = datetime(today(), now())
	end if
next

li_sts = luo_data.update()

DESTROY luo_data

return 1



end function

public function long new_interface_transport_old (long pl_interfaceserviceid);string ls_id
str_params lstr_params
str_attributes lstr_attributes
string ls_value
integer li_sts
long ll_attribute_count
long i
long ll_transportsequence
string ls_interfaceservicetype
string ls_commcomponent
string ls_transportdescription
string ls_documenttype
long ll_count
string ls_interfacedescription
string ls_purpose
string ls_document_route
string ls_document_route_suffix
string ls_new_document_route
string ls_document_format
string ls_send_from

if isnull(pl_interfaceserviceid) then
	log.log(this, "u_tv_practice_config.configure_local_interface_transport.0034", "NULL interface service id", 4)
	return -1
end if

// Get some info about the interface
SELECT description, interfaceservicetype, document_route
INTO :ls_interfacedescription, :ls_interfaceservicetype, :ls_document_route
FROM c_component_interface
WHERE subscriber_owner_id = :sqlca.customer_id
AND interfaceserviceid = :pl_interfaceserviceid;
if not tf_check() then return -1
if sqlca.sqlnrows = 0 then
	log.log(this, "u_tv_practice_config.configure_local_interface_transport.0034", "interface service id not found (" + string(pl_interfaceserviceid) + ")", 4)
	return -1
end if

// Define the new interface transport
ls_id = "{18D9F50E-5DC2-4322-960E-BCC418B1B57E}"

// Add a component_type so that the component param will filter for the document senders
//f_attribute_add_attribute(lstr_attributes, "component_type", "Document Sender")

li_sts = f_get_params(ls_id, "Config", lstr_attributes)
if li_sts < 0 then return -1

// Get attributes returned from wizard
ls_commcomponent = f_attribute_find_attribute(lstr_attributes, "component_id")
if isnull(ls_commcomponent) then
	openwithparm(w_pop_message, "Comm Component is required")
	return 0
end if
ls_transportdescription = f_attribute_find_attribute(lstr_attributes, "transportdescription")
if isnull(ls_transportdescription) then
	openwithparm(w_pop_message, "Transport Description is required")
	return 0
end if
ls_documenttype = f_attribute_find_attribute(lstr_attributes, "documenttype")
ls_purpose = f_attribute_find_attribute(lstr_attributes, "purpose")
ls_document_route_suffix = f_attribute_find_attribute(lstr_attributes, "document_route_suffix")
ls_document_format = f_attribute_find_attribute(lstr_attributes, "document_format")
if isnull(ls_document_format) or lower(ls_document_format) <> "machine" then ls_document_format = "Human"
ls_send_from = f_attribute_find_attribute(lstr_attributes, "send_from")
if isnull(ls_send_from) or lower(ls_send_from) <> "client" then ls_send_from = "Server"

// validate the document_route_suffix
if len(ls_document_route_suffix) > 0 then
	ls_new_document_route = ls_document_route + "." + ls_document_route_suffix
	if len(ls_new_document_route) > 24 then
		openwithparm(w_pop_message, "The document route suffix is too long.  The combination of the document route and document route suffix must not exceed 24 characters")
		return -1
	end if
else
	ls_new_document_route = ls_document_route
end if

SELECT count(*)
INTO :ll_count
FROM c_Document_Route
WHERE document_route = :ls_new_document_route;
if not tf_check() then return -1

if ll_count > 0 then
	openwithparm(w_pop_message, "The document route ~"" + ls_new_document_route + "~" already exists.  Only one transport may have a blank document route suffix, and all transports for an interface must have different document route suffixes")
	return -1
end if

SELECT max(transportsequence)
INTO :ll_transportsequence
FROM c_component_interface_route
WHERE subscriber_owner_id = :sqlca.customer_id
AND interfaceserviceid = :pl_interfaceserviceid;
if not tf_check() then return -1

if isnull(ll_transportsequence) or ll_transportsequence <= 0 then
	ll_transportsequence = 1
else
	ll_transportsequence += 1
end if

INSERT INTO c_component_interface_route  
         ( ownerid,   
           subscriber_owner_id,   
           interfaceservicetype,   
           interfaceserviceid,   
           interfacedescription,   
           transportsequence,   
           transportdescription,   
           commcomponent,   
           documenttype,   
           direction,   
           epie_transform,   
           status,   
           purpose,   
           document_route_suffix )  
  VALUES ( :sqlca.customer_id,   
           :sqlca.customer_id,   
           :ls_interfaceservicetype,   
           :pl_interfaceserviceid,   
           :ls_interfacedescription,   
           :ll_transportsequence,   
           :ls_transportdescription,   
           :ls_commcomponent,   
           :ls_documenttype,   
           'O',   
           'N',   
           'OK',   
           :ls_purpose,   
           :ls_document_route_suffix )  ;
if not tf_check() then return -1


// Add the document route for this transport
INSERT INTO dbo.c_Document_Route (
		document_route,
		sent_status,
		status,
		owner_id,
		last_updated,
		id,
		document_format,
		sender_id_key,
		receiver_id_key,
		send_via_addressee,
		document_type,
		communication_type,
		sending_status,
		send_from,
		sender_component_id)
VALUES (
		:ls_new_document_route,
		'Sent',
		'OK',
		:sqlca.customer_id,
		getdate(),
		newid(),
		:ls_document_format,
		NULL,
		NULL,
		NULL,
		:ls_documenttype,
		NULL,
		'Sending',
		:ls_send_from,
		:ls_commcomponent );
if not tf_check() then return -1


return ll_transportsequence



end function

public function integer configure_local_interface (ref long pl_interfaceserviceid);str_popup popup
str_popup_return popup_return
string ls_id
str_params lstr_params
str_attributes lstr_attributes
string ls_value
integer li_sts
long ll_attribute_count
long i
string ls_interfaceservicetype
string ls_commcomponent
string ls_transportdescription
string ls_documenttype
long ll_count
string ls_interfacedescription
string ls_purpose
string ls_document_route
string ls_document_route_suffix
string ls_original_document_route
string ls_original_document_route_suffix
string ls_new_document_route
string ls_document_format
string ls_send_from
string ls_direction
u_ds_data luo_data
string ls_receive_flag
string ls_send_flag

string ls_description

// Get the existing attributes for this transport
luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_practice_interface_transport_properties")

if isnull(pl_interfaceserviceid) then
else
	// Get some info about the interface
	SELECT description, interfaceservicetype, document_route, receive_flag, send_flag
	INTO :ls_interfacedescription, :ls_interfaceservicetype, :ls_document_route, :ls_receive_flag, :ls_send_flag
	FROM c_component_interface
	WHERE interfaceserviceid = :pl_interfaceserviceid;
	if not tf_check() then return -1
	if sqlca.sqlnrows = 0 then
		log.log(this, "u_tv_practice_config.configure_local_interface_transport.0034", "interface service id not found (" + string(pl_interfaceserviceid) + ")", 4)
		return -1
	end if
	
	ll_count = luo_data.retrieve(pl_interfaceserviceid, 0)
	
	f_attribute_ds_to_str(luo_data, lstr_attributes)
	
	f_attribute_add_attribute(lstr_attributes, "description", ls_interfacedescription)
	f_attribute_add_attribute(lstr_attributes, "document_route", ls_document_route)
end if

// Define the new interface transport
ls_id = "{32FB1A09-E3F6-4c43-AB90-6F88AC4554B4}"

li_sts = f_get_params(ls_id, "Config", lstr_attributes)
if li_sts < 0 then return -1

// Get attributes returned from wizard
ls_description = f_attribute_find_attribute(lstr_attributes, "description")
if isnull(ls_description) then
	openwithparm(w_pop_message, "Interface description is required")
	return 0
end if
ls_document_route = f_attribute_find_attribute(lstr_attributes, "document_route")
if isnull(ls_document_route) then
	openwithparm(w_pop_message, "Document Route Name is required")
	return 0
elseif left(lower(ls_document_route), 6) <> "local." then
	ls_document_route = "Local." + ls_document_route
end if
if len(ls_document_route) > 24 then
	openwithparm(w_pop_message, "The total length of the document route, including the prepended ~"Local.~", must not exceed 24 characters.")
	return 0
end if

ls_direction = f_attribute_find_attribute(lstr_attributes, "interface_direction")
CHOOSE CASE upper(ls_direction)
	CASE "IN"
		ls_receive_flag = "Y"
		ls_send_flag = "N"
	CASE "OUT"
		ls_receive_flag = "N"
		ls_send_flag = "Y"
	CASE "BOTH"
		ls_receive_flag = "Y"
		ls_send_flag = "Y"
	CASE ELSE
		ls_receive_flag = "N"
		ls_send_flag = "Y"
END CHOOSE

if isnull(pl_interfaceserviceid) then
	SELECT min(interfaceserviceid)
	INTO :pl_interfaceserviceid
	FROM c_component_interface
	WHERE subscriber_owner_id = :sqlca.customer_id
	AND owner_id = :sqlca.customer_id
	AND interfaceservicetype = 'Local';
	if not tf_check() then return -1
	
	// Local interface services start at -1 and go down
	if isnull(pl_interfaceserviceid) or pl_interfaceserviceid >= 0 then
		pl_interfaceserviceid = -1
	else
		pl_interfaceserviceid -= 1
	end if
	
	  INSERT INTO c_Component_Interface  
				( subscriber_owner_id,   
				  interfaceServiceId,   
				  owner_id,   
				  interfaceServiceType,   
				  sortSequence,   
				  description,   
				  document_route,
			  receive_flag,
			  send_flag,
			  servicestate,
				  status )  
	  VALUES ( :sqlca.customer_id,   
				  :pl_interfaceserviceid,   
				  :sqlca.customer_id,   
				  'Local',   
				  1,   
				  :ls_description,   
				  :ls_document_route,   
			  :ls_receive_flag,
			  :ls_send_flag,
			 'Production',
				  'OK' )  ;
	if not tf_check() then return -1
else
	UPDATE c_Component_Interface  
	SET	description = :ls_description,   
			document_route = :ls_document_route,
			receive_flag = :ls_receive_flag,
			send_flag = :ls_send_flag
	WHERE interfaceserviceid = :pl_interfaceserviceid;
	if not tf_check() then return -1
end if

// Save the attributes in the properties table
f_attribute_str_to_ds_with_removal(lstr_attributes, luo_data)

for i = 1 to luo_data.rowcount()
	if isnull(luo_data.object.subscriber_owner_id[i]) then
		luo_data.object.subscriber_owner_id[i] = sqlca.customer_id
		luo_data.object.interfaceserviceid[i] = pl_interfaceserviceid
		luo_data.object.transportsequence[i] = 0
		luo_data.object.property[i] = luo_data.object.attribute[i]
		luo_data.object.last_updated[i] = datetime(today(), now())
	end if
next

li_sts = luo_data.update()

DESTROY luo_data

return 1



end function

public function long new_interface_old ();string ls_id
str_params lstr_params
str_attributes lstr_attributes
string ls_value
integer li_sts
long ll_attribute_count
long i
long ll_transportsequence
long ll_interfaceserviceid

string ls_description
string ls_document_route
string ls_direction
string ls_receive_flag
string ls_send_flag

// Define the new interface transport
ls_id = "{32FB1A09-E3F6-4c43-AB90-6F88AC4554B4}"

li_sts = f_get_params(ls_id, "Config", lstr_attributes)
if li_sts < 0 then return -1

// Get attributes returned from wizard
ls_description = f_attribute_find_attribute(lstr_attributes, "description")
if isnull(ls_description) then
	openwithparm(w_pop_message, "Interface description is required")
	return 0
end if
ls_document_route = f_attribute_find_attribute(lstr_attributes, "document_route")
if isnull(ls_document_route) then
	openwithparm(w_pop_message, "Document Route Name is required")
	return 0
elseif left(lower(ls_document_route), 6) <> "local." then
	ls_document_route = "Local." + ls_document_route
end if
if len(ls_document_route) > 24 then
	openwithparm(w_pop_message, "The total length of the document route, including the prepended ~"Local.~", must not exceed 24 characters.")
	return 0
end if

ls_direction = f_attribute_find_attribute(lstr_attributes, "interface_direction")
CHOOSE CASE upper(ls_direction)
	CASE "IN"
		ls_receive_flag = "Y"
		ls_send_flag = "N"
	CASE "OUT"
		ls_receive_flag = "N"
		ls_send_flag = "Y"
	CASE "BOTH"
		ls_receive_flag = "Y"
		ls_send_flag = "Y"
	CASE ELSE
		ls_receive_flag = "N"
		ls_send_flag = "Y"
END CHOOSE

SELECT min(interfaceserviceid)
INTO :ll_interfaceserviceid
FROM c_component_interface
WHERE subscriber_owner_id = :sqlca.customer_id
AND owner_id = :sqlca.customer_id
AND interfaceservicetype = 'Local';
if not tf_check() then return -1

// Local interface services start at -1 and go down
if isnull(ll_interfaceserviceid) or ll_interfaceserviceid >= 0 then
	ll_interfaceserviceid = -1
else
	ll_interfaceserviceid -= 1
end if

  INSERT INTO c_Component_Interface  
         ( subscriber_owner_id,   
           interfaceServiceId,   
           owner_id,   
           interfaceServiceType,   
           sortSequence,   
           description,   
           document_route,
		  receive_flag,
		  send_flag,
		  servicestate,
           status )  
  VALUES ( :sqlca.customer_id,   
           :ll_interfaceserviceid,   
           :sqlca.customer_id,   
           'Local',   
           1,   
           :ls_description,   
           :ls_document_route,   
		  :ls_receive_flag,
		  :ls_send_flag,
		 'Production',
           'OK' )  ;
if not tf_check() then return -1

setnull(ll_transportsequence)
li_sts = configure_local_interface_transport(ll_interfaceserviceid, ll_transportsequence)

return ll_interfaceserviceid



end function

public function long configure_interface_transport_actors (long pl_interfaceserviceid, ref long pl_transportsequence);integer li_sts
str_popup popup
str_popup_return popup_return
long i, j
string ls_interfaceservicetype
string ls_interfacedescription
string ls_interface_document_route
string ls_document_route_suffix
string ls_document_route
u_ds_data luo_data
u_ds_data luo_actors
string ls_receive_flag
string ls_send_flag
string ls_find
long ll_row
long ll_route_actor_count
string ls_actor_class
boolean lb_found
string ls_document_format

if isnull(pl_interfaceserviceid) then
	log.log(this, "u_tv_practice_config.configure_local_interface_transport.0034", "NULL interface service id", 4)
	return -1
end if

if isnull(pl_transportsequence) then
	log.log(this, "u_tv_practice_config.configure_local_interface_transport.0034", "NULL transport sequence", 4)
	return -1
end if

// Get some info about the interface
SELECT description, interfaceservicetype, document_route, receive_flag, send_flag
INTO :ls_interfacedescription, :ls_interfaceservicetype, :ls_interface_document_route, :ls_receive_flag, :ls_send_flag
FROM c_component_interface
WHERE interfaceserviceid = :pl_interfaceserviceid;
if not tf_check() then return -1
if sqlca.sqlnrows = 0 then
	log.log(this, "u_tv_practice_config.configure_local_interface_transport.0034", "interface service id not found (" + string(pl_interfaceserviceid) + ")", 4)
	return -1
end if

SELECT document_route_suffix
INTO :ls_document_route_suffix
FROM c_component_interface_Route
WHERE interfaceserviceid = :pl_interfaceserviceid
AND transportsequence = :pl_transportsequence;
if not tf_check() then return -1
if sqlca.sqlnrows = 0 then
	log.log(this, "u_tv_practice_config.configure_local_interface_transport.0034", "interface service id not found (" + string(pl_interfaceserviceid) + ")", 4)
	return -1
end if

if len(ls_document_route_suffix) > 0 then
	ls_document_route = ls_interface_document_route + "." + ls_document_route_suffix
else
	ls_document_route = ls_interface_document_route
end if

SELECT document_format
INTO :ls_document_format
FROM c_Document_Route
WHERE document_route = :ls_document_route;
if not tf_check() then return -1
if sqlca.sqlnrows = 0 then
	log.log(this, "u_tv_practice_config.configure_local_interface_transport.0034", "document_route not found (" + ls_document_route + ")", 4)
	return -1
end if


// Get the existing attributes for this transport
luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_actor_classes_for_route")
ll_route_actor_count = luo_data.retrieve(ls_document_route)

luo_actors = CREATE u_ds_data
luo_actors.set_dataobject("dw_c_actor_class")
popup.data_row_count = luo_actors.retrieve()

for i = 1 to popup.data_row_count
	popup.items[i] = luo_actors.object.actor_class[i]
	
	ls_find = "lower(actor_class) = '" + lower(popup.items[i]) + "'"
	ll_row = luo_data.find(ls_find, 1, ll_route_actor_count)
	if ll_row > 0 then
		popup.preselected_items[i] = true
	else
		popup.preselected_items[i] = false
	end if
next
popup.title = "Allowed Actor Classes"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.cancel_selected then return 0

// Delete any rows that weren't picked
for i = ll_route_actor_count to 1 step -1 // go backwards so the deletes don't mess up the row numbers
	ls_actor_class = luo_data.object.actor_class[i]
	lb_found = false
	for j = 1 to popup_return.item_count
		if lower(popup_return.items[i]) = lower(ls_actor_class) then
			lb_found = true
			exit
		end if
	next
	if not lb_found then
		luo_data.deleterow(i)
	end if
next

// Now add any rows that were not already in the selected list		
for i = 1 to popup_return.item_count
	ls_find = "lower(actor_class) = '" + lower(popup_return.items[i]) + "'"
	ll_row = luo_data.find(ls_find, 1, luo_data.rowcount())
	if ll_row = 0 then
		ll_row = luo_data.insertrow(0)
		luo_data.object.actor_class[ll_row] = popup_return.items[i]
		luo_data.object.document_route[ll_row] = ls_document_route
		luo_data.object.document_format[ll_row] = ls_document_format
		luo_data.object.status[ll_row] = "OK"
		luo_data.object.owner_id[ll_row] = sqlca.customer_id
	end if
next

li_sts = luo_data.update()

DESTROY luo_data
DESTROY luo_actors

return 1



end function

public function integer configure_epie_transport (str_item_data pstr_item_data);string ls_id
str_params lstr_params
str_attributes lstr_attributes
string ls_value
integer li_sts
u_ds_data luo_data
long ll_attribute_count
long i

if isnull(pstr_item_data.id) or pstr_item_data.id = "" then return 0


// Get the existing attributes for this transport
luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_practice_interface_transport_properties")
ll_attribute_count = luo_data.retrieve(sqlca.customer_id, pstr_item_data.interfaceserviceid, pstr_item_data.transportsequence)

f_attribute_ds_to_str(luo_data, lstr_attributes)

ls_id = "{18D9F50E-5DC2-4322-960E-BCC418B1B57E}"

li_sts = f_get_params(ls_id, "Config", lstr_attributes)
if li_sts < 0 then return -1

f_attribute_str_to_ds_with_removal(lstr_attributes, luo_data)

for i = 1 to luo_data.rowcount()
	if isnull(luo_data.object.subscriber_owner_id[i]) then
		luo_data.object.subscriber_owner_id[i] = sqlca.customer_id
		luo_data.object.interfaceserviceid[i] = pstr_item_data.interfaceserviceid
		luo_data.object.transportsequence[i] = pstr_item_data.transportsequence
		luo_data.object.property[i] = luo_data.object.attribute[i]
		luo_data.object.last_updated[i] = datetime(today(), now())
	end if
next

li_sts = luo_data.update()

DESTROY luo_data

return 1


end function

public function integer display_sysadmin (long pl_handle);treeviewitem ltvi_node
long ll_handle
integer li_sts
long ll_rows
str_item_data lstr_new_item_data
long ll_index
u_user luo_practice
u_ds_data luo_data
long ll_office_count
long i
string ls_status
str_users lstr_users

lstr_users = common_thread.practice_users("Sysadmin")

for i = 1 to lstr_users.user_count
	lstr_new_item_data.node_type = "SYSADMIN"
	lstr_new_item_data.node_key = lstr_users.user[i].user_id
	
	ltvi_node.data = lstr_new_item_data
	
	ltvi_node.label = lstr_users.user[i].user_full_name
	
	ltvi_node.children = false
	ltvi_node.PictureIndex = 17
	ltvi_node.SelectedPictureIndex = 17
	ll_handle = insertitemlast(pl_handle, ltvi_node)
next

return 1

end function

public subroutine menu_sysadmins (long pl_handle);String		lsa_buttons[]
String 		ls_drug_id
String 		ls_description,ls_null
String		ls_top_20_code
Integer		li_sts, li_service_count
Long			ll_null
string ls_property
string ls_literal
str_property_value lstr_property_value
w_document_element_properties lw_document_element_properties
long ll_button_pressed
str_document_element_context lstr_document_element_context
window 				lw_pop_buttons
str_popup 			popup
str_popup 			popup2
str_popup_return 	popup_return
str_item_data lstr_item_data
treeviewitem ltvi_item
string ls_status
str_users lstr_users
str_pick_users lstr_pick_users
integer li_count
long i, j
u_user luo_user

Setnull(ls_null)
Setnull(ll_null)

li_sts = getitem(pl_handle, ltvi_item)
if li_sts <= 0 then
	log.log(this, "u_tv_practice_config.practice_menu.0025", "Error getting new treeview item (" + string(pl_handle) + ")", 4)
	return
end if

lstr_item_data = ltvi_item.data

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_wrench.bmp"
	popup.button_helps[popup.button_count] = "Add System Administrators"
	popup.button_titles[popup.button_count] = "Add Admin(s)"
	lsa_buttons[popup.button_count] = "ADD"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	lsa_buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	ll_button_pressed = message.doubleparm
	if ll_button_pressed < 1 or ll_button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	ll_button_pressed = 1
else
	return
end if

CHOOSE CASE lsa_buttons[ll_button_pressed]
	CASE "ADD"
		lstr_users = common_thread.practice_users("Sysadmin")

		lstr_pick_users.actor_class = "Person"
		lstr_pick_users.allow_multiple = true
		li_count = user_list.pick_users(lstr_pick_users)
		if li_count > 0 then
			for i = 1 to lstr_pick_users.selected_users.user_count
				luo_user = user_list.find_user(lstr_pick_users.selected_users.user[i].user_id)
				if isnull(luo_user) then continue
				luo_user.get_communications()
				if lower(luo_user.actor_class) <> "user" then
					if isnull(luo_user.get_communication_value("Email", "Email")) then
						openwithparm(w_pop_message, "Non-user administrators must have an email address")
						continue
					end if
				end if
				common_thread.practice_users_add_user("Sysadmin", lstr_pick_users.selected_users.user[i].user_id)
			next
		end if
		
		redisplay(pl_handle)
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

Return

end subroutine

public function integer display_sysadmins (long pl_handle);treeviewitem ltvi_node
long ll_handle
integer li_sts
long ll_rows
str_item_data lstr_new_item_data
long ll_index
u_user luo_practice
u_ds_data luo_data
long ll_office_count
long i
string ls_status
str_users lstr_users

lstr_users = common_thread.practice_users("Sysadmin")

for i = 1 to lstr_users.user_count
	lstr_new_item_data.node_type = "SYSADMIN"
	lstr_new_item_data.node_key = lstr_users.user[i].user_id
	
	ltvi_node.data = lstr_new_item_data
	
	ltvi_node.label = lstr_users.user[i].user_full_name
	
	ltvi_node.children = false
	ltvi_node.PictureIndex = 17
	ltvi_node.SelectedPictureIndex = 17
	ll_handle = insertitemlast(pl_handle, ltvi_node)
next

return 1

end function

public subroutine menu_sysadmin (long pl_handle);String		lsa_buttons[]
String 		ls_drug_id
String 		ls_description,ls_null
String		ls_top_20_code
Integer		li_sts, li_service_count
Long			ll_null
string ls_property
string ls_literal
str_property_value lstr_property_value
w_document_element_properties lw_document_element_properties
long ll_button_pressed
str_document_element_context lstr_document_element_context
window 				lw_pop_buttons
str_popup 			popup
str_popup 			popup2
str_popup_return 	popup_return
str_item_data lstr_item_data
treeviewitem ltvi_item
string ls_status
str_users lstr_users
str_pick_users lstr_pick_users
integer li_count
long i, j
string ls_user_id

Setnull(ls_null)
Setnull(ll_null)

li_sts = getitem(pl_handle, ltvi_item)
if li_sts <= 0 then
	log.log(this, "u_tv_practice_config.practice_menu.0025", "Error getting new treeview item (" + string(pl_handle) + ")", 4)
	return
end if

lstr_item_data = ltvi_item.data

ls_user_id = lstr_item_data.node_key

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Remove System Administrator"
	popup.button_titles[popup.button_count] = "Remove"
	lsa_buttons[popup.button_count] = "REMOVE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_edit2.bmp"
	popup.button_helps[popup.button_count] = "Edit Actor Profile"
	popup.button_titles[popup.button_count] = "Edit"
	lsa_buttons[popup.button_count] = "EDIT"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	lsa_buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	ll_button_pressed = message.doubleparm
	if ll_button_pressed < 1 or ll_button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	ll_button_pressed = 1
else
	return
end if

CHOOSE CASE lsa_buttons[ll_button_pressed]
	CASE "REMOVE"
		common_thread.practice_users_remove_user("Sysadmin", ls_user_id)
		redisplay_parent(pl_handle)
	CASE "EDIT"
		popup.data_row_count = 1
		popup.items[1] = ls_user_id
		openwithparm(w_user_definition, popup)
		redisplay(pl_handle)
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

Return

end subroutine

public subroutine redisplay_parent (long pl_handle);long ll_parent_handle

ll_parent_handle = finditem(ParentTreeItem!, pl_handle)

if ll_parent_handle > 0 then
	redisplay(ll_parent_handle)
end if

end subroutine

public function integer display_office_children_old (long pl_handle);treeviewitem ltvi_node
long ll_handle
integer li_sts
long ll_rows
str_item_data lstr_new_item_data
long ll_index
u_user luo_practice
treeviewitem ltvi_parent
str_item_data lstr_parent_item_data

li_sts = getitem(pl_handle, ltvi_parent)
if li_sts < 0 then return -1

lstr_parent_item_data = ltvi_parent.data


// Add Offices Root
lstr_new_item_data.node_type = "GROUPS"
setnull(lstr_new_item_data.node_key)
lstr_new_item_data.office_id = lstr_parent_item_data.office_id

ltvi_node.data = lstr_new_item_data

ltvi_node.label = "Room Groups"
ltvi_node.children = true
ltvi_node.PictureIndex = 4
ltvi_node.SelectedPictureIndex = 4
ll_handle = insertitemlast(pl_handle, ltvi_node)

// Add Interfaces Root
lstr_new_item_data.node_type = "INTERFACES"
setnull(lstr_new_item_data.node_key)
lstr_new_item_data.office_id = lstr_parent_item_data.office_id

ltvi_node.data = lstr_new_item_data

ltvi_node.label = "Interfaces"
ltvi_node.children = true
ltvi_node.PictureIndex = 5
ltvi_node.SelectedPictureIndex = 5
ll_handle = insertitemlast(pl_handle, ltvi_node)



return 1

end function

public function integer display_groups (long pl_handle);treeviewitem ltvi_parent
treeviewitem ltvi_node
long ll_handle
integer li_sts
long ll_rows
str_item_data lstr_parent_item_data
str_item_data lstr_new_item_data
long ll_index
u_user luo_practice
u_ds_data luo_data
long ll_office_count
long i
string ls_persistence_flag

li_sts = getitem(pl_handle, ltvi_parent)
if li_sts < 0 then return -1

lstr_parent_item_data = ltvi_parent.data

lstr_new_item_data.office_id = lstr_parent_item_data.office_id

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_o_groups_for_office")
ll_office_count = luo_data.retrieve(lstr_parent_item_data.office_id)

for i = 1 to ll_office_count
	lstr_new_item_data.node_type = "GROUP"
	lstr_new_item_data.node_key = string(long(luo_data.object.group_id[i]))
	lstr_new_item_data.office_id = lstr_parent_item_data.office_id

	ls_persistence_flag = luo_data.object.persistence_flag[i]
	
	ltvi_node.data = lstr_new_item_data
	
	ltvi_node.label = luo_data.object.description[i]
	ltvi_node.children = true
	if ls_persistence_flag = "Y" then
		ltvi_node.PictureIndex = 6
		ltvi_node.SelectedPictureIndex = 6
	else
		ltvi_node.PictureIndex = 19
		ltvi_node.SelectedPictureIndex = 19
	end if
	ll_handle = insertitemlast(pl_handle, ltvi_node)
next

DESTROY luo_data


return 1

end function

public subroutine menu_group (long pl_handle);String		lsa_buttons[]
String 		ls_drug_id
String 		ls_description,ls_null
String		ls_top_20_code
Integer		li_sts, li_service_count
Long			ll_null
string ls_property
string ls_literal
str_property_value lstr_property_value
w_document_element_properties lw_document_element_properties
long ll_button_pressed
str_document_element_context lstr_document_element_context
window 				lw_pop_buttons
str_popup 			popup
str_popup 			popup2
str_popup_return 	popup_return
str_item_data lstr_item_data
treeviewitem ltvi_item
string ls_status
str_users lstr_users
str_pick_users lstr_pick_users
integer li_count
long i, j
str_room lstr_room
w_window_base lw_window
string ls_office_id
long ll_group_id
string ls_persistence_flag

Setnull(ls_null)
Setnull(ll_null)

li_sts = getitem(pl_handle, ltvi_item)
if li_sts <= 0 then
	log.log(this, "u_tv_practice_config.practice_menu.0025", "Error getting new treeview item (" + string(pl_handle) + ")", 4)
	return
end if

lstr_item_data = ltvi_item.data

ls_office_id = lstr_item_data.office_id
ll_group_id = long(lstr_item_data.node_key)

SELECT persistence_flag
INTO :ls_persistence_flag
FROM o_Groups
WHERE group_id = :ll_group_id;
if not tf_check() then return

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_edit2.bmp"
	popup.button_helps[popup.button_count] = "Rename Group"
	popup.button_titles[popup.button_count] = "Rename Group"
	lsa_buttons[popup.button_count] = "RENAME"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button10.bmp"
	popup.button_helps[popup.button_count] = "Define New Room in this Room Group"
	popup.button_titles[popup.button_count] = "New Room"
	lsa_buttons[popup.button_count] = "NEW"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button10.bmp"
	popup.button_helps[popup.button_count] = "Add Selected Room to This Group"
	popup.button_titles[popup.button_count] = "Add Room"
	lsa_buttons[popup.button_count] = "ADD"
end if

if ls_persistence_flag = "Y" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_unpinned.bmp"
	popup.button_helps[popup.button_count] = "Hide group when empty"
	popup.button_titles[popup.button_count] = "Unpin Group"
	lsa_buttons[popup.button_count] = "UNPIN"
else
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_pinned.bmp"
	popup.button_helps[popup.button_count] = "Show group even when empty"
	popup.button_titles[popup.button_count] = "Pin Group"
	lsa_buttons[popup.button_count] = "PIN"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Delete This Group"
	popup.button_titles[popup.button_count] = "Delete Group"
	lsa_buttons[popup.button_count] = "DELETE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	lsa_buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	ll_button_pressed = message.doubleparm
	if ll_button_pressed < 1 or ll_button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	ll_button_pressed = 1
else
	return
end if

CHOOSE CASE lsa_buttons[ll_button_pressed]
	CASE "RENAME"
		popup.title = "Enter new name for room group"
		popup.datacolumn = 32
		popup.dataobject = ""
		popup.data_row_count = 0
		popup.item = ltvi_item.label
		openwithparm(w_pop_prompt_string, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		
		if len(popup_return.items[1]) > 0 then
			UPDATE o_Groups
			SET description = :popup_return.items[1]
			WHERE group_id = :ll_group_id;
			if not tf_check() then return
			
			redisplay(pl_handle)
		end if
	CASE "NEW"
		lstr_room = f_new_room(ls_office_id)
		if len(lstr_room.room_id) > 0 then
			INSERT INTO o_Group_Rooms (group_id, room_id)
			VALUES (:ll_group_id, :lstr_room.room_id);
			if not tf_check() then return
			
			openwithparm(lw_window, lstr_room.room_id, "w_room_properties")
			redisplay(pl_handle)
		end if
	CASE "ADD"
		li_sts = add_room_to_group(ls_office_id, ll_group_id)
		if li_sts <= 0 then return
		
		redisplay(pl_handle)
	CASE "PIN"
		UPDATE o_Groups
		SET persistence_flag = 'Y'
		WHERE group_id = :ll_group_id;
		if not tf_check() then return
		
		redisplay(pl_handle)
	CASE "UNPIN"
		UPDATE o_Groups
		SET persistence_flag = 'N'
		WHERE group_id = :ll_group_id;
		if not tf_check() then return
		
		redisplay(pl_handle)
	CASE "DELETE"
		openwithparm(w_pop_yes_no, "Are you sure you want to delete this group?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return
		
		DELETE FROM o_Groups
		WHERE group_id = :ll_group_id;
		if not tf_check() then return
		
		redisplay_parent(pl_handle)
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

Return

end subroutine

public subroutine menu_room (long pl_handle);String		lsa_buttons[]
String 		ls_drug_id
String 		ls_description,ls_null
String		ls_top_20_code
Integer		li_sts, li_service_count
Long			ll_null
string ls_property
string ls_literal
long ll_button_pressed
str_document_element_context lstr_document_element_context
window 				lw_pop_buttons
str_popup 			popup
str_popup 			popup2
str_popup_return 	popup_return
str_item_data lstr_item_data
str_item_data lstr_item_data_parent
treeviewitem ltvi_item
long ll_parent_handle
treeviewitem ltvi_item_parent
string ls_status
str_users lstr_users
str_pick_users lstr_pick_users
integer li_count
long i, j
w_window_base lw_window
string ls_group_name
string ls_room_name
long ll_group_id

Setnull(ls_null)
Setnull(ll_null)

li_sts = getitem(pl_handle, ltvi_item)
if li_sts <= 0 then
	log.log(this, "u_tv_practice_config.practice_menu.0025", "Error getting treeview item (" + string(pl_handle) + ")", 4)
	return
end if

ll_parent_handle = finditem(ParentTreeItem!, pl_handle)
if ll_parent_handle <= 0 then
	log.log(this, "u_tv_practice_config.practice_menu.0025", "Error finding parent treeview item (" + string(pl_handle) + ")", 4)
	return
end if

li_sts = getitem(ll_parent_handle, ltvi_item_parent)
if li_sts <= 0 then
	log.log(this, "u_tv_practice_config.practice_menu.0025", "Error getting parent treeview item (" + string(ll_parent_handle) + ")", 4)
	return
end if


ls_room_name = ltvi_item.label
lstr_item_data = ltvi_item.data

ls_group_name = ltvi_item_parent.label
lstr_item_data_parent = ltvi_item_parent.data
ll_group_id = long(lstr_item_data_parent.node_key)

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Remove Room from This Group"
	popup.button_titles[popup.button_count] = "Remove"
	lsa_buttons[popup.button_count] = "REMOVE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_edit2.bmp"
	popup.button_helps[popup.button_count] = "Edit Room Properties"
	popup.button_titles[popup.button_count] = "Properties"
	lsa_buttons[popup.button_count] = "EDIT"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	lsa_buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	ll_button_pressed = message.doubleparm
	if ll_button_pressed < 1 or ll_button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	ll_button_pressed = 1
else
	return
end if

CHOOSE CASE lsa_buttons[ll_button_pressed]
	CASE "REMOVE"
		openwithparm(w_pop_yes_no, "Are you sure you want to remove " + ls_room_name + " from the " + ls_group_name + " group?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return
		
		DELETE FROM o_Group_Rooms
		WHERE group_id = :ll_group_id
		AND room_id = :lstr_item_data.room_id;
		if not tf_check() then return
		
		redisplay_parent(pl_handle)
	CASE "EDIT"
		openwithparm(lw_window, lstr_item_data.room_id, "w_room_properties")
		redisplay(pl_handle)
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

Return

end subroutine

public function integer add_room_to_group (string ps_office_id, long pl_group_id);str_popup popup
str_popup_return popup_return
string ls_room_id
long ll_office_count
string ls_other_office_id

SELECT count(*)
INTO :ll_office_count
FROM c_Office
WHERE status = 'OK';
if not tf_check() then return -1


popup.dataobject = "dw_room_list_office"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = ps_office_id
if ll_office_count > 1 then
	popup.add_blank_row = true
	popup.blank_at_bottom = true
	popup.blank_text = "Other Office..."
end if
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

if popup_return.items[1] = "" then
	DO WHILE true
		popup.dataobject = "dw_office_pick"
		popup.datacolumn = 1
		popup.displaycolumn = 2
		popup.argument_count = 0
		popup.add_blank_row = false
		openwithparm(w_pop_pick, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return 0
		
		ls_other_office_id = popup_return.items[1]
		
		popup.dataobject = "dw_room_list_office"
		popup.datacolumn = 1
		popup.displaycolumn = 2
		popup.argument_count = 1
		popup.argument[1] = ls_other_office_id
		if ll_office_count > 1 then
			popup.add_blank_row = true
			popup.blank_at_bottom = true
			popup.blank_text = "Other Office..."
		end if
		openwithparm(w_pop_pick, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return 0
		
		if len(popup_return.items[1]) > 0 then
			ls_room_id = popup_return.items[1]
			exit
		end if
	LOOP
else
	ls_room_id = popup_return.items[1]
end if

if len(ls_room_id) > 0 then
	INSERT INTO o_Group_Rooms (group_id, room_id)
	VALUES (:pl_group_id, :ls_room_id);
	if not tf_check() then return -1
end if

return 1

end function

public function integer display_component_children (long pl_handle);treeviewitem ltvi_node
long ll_handle
integer li_sts
long ll_rows
str_item_data lstr_new_item_data
long ll_index
u_user luo_practice


// Add Decision Support Root
lstr_new_item_data.node_type = "DECISIONSUPPORT"
setnull(lstr_new_item_data.node_key)

ltvi_node.data = lstr_new_item_data

ltvi_node.label = "Decision Support"
ltvi_node.children = true
ltvi_node.PictureIndex = 22
ltvi_node.SelectedPictureIndex = 22
ll_handle = insertitemlast(pl_handle, ltvi_node)

// Add Alerts Root
lstr_new_item_data.node_type = "ALERTS"
setnull(lstr_new_item_data.node_key)

ltvi_node.data = lstr_new_item_data

ltvi_node.label = "Alerts"
ltvi_node.children = true
ltvi_node.PictureIndex = 21
ltvi_node.SelectedPictureIndex = 21
ll_handle = insertitemlast(pl_handle, ltvi_node)

// Add Workflow Root
lstr_new_item_data.node_type = "WORKFLOW"
setnull(lstr_new_item_data.node_key)

ltvi_node.data = lstr_new_item_data

ltvi_node.label = "Workflow"
ltvi_node.children = true
ltvi_node.PictureIndex = 23
ltvi_node.SelectedPictureIndex = 23
ll_handle = insertitemlast(pl_handle, ltvi_node)

return 1

end function

on u_tv_practice_config.create
end on

on u_tv_practice_config.destroy
end on

event itempopulate;integer li_sts
str_item_data lstr_item_data
treeviewitem ltvi_node

li_sts = getitem(handle, ltvi_node)
if li_sts < 0 then return -1

lstr_item_data = ltvi_node.data

CHOOSE CASE upper(lstr_item_data.node_type)
	CASE "ATTACHMENTS"
		li_sts = display_attachments_children(handle)
		if li_sts < 0 then return -1
	CASE "COMPONENTS"
		li_sts = display_component_children(handle)
		if li_sts < 0 then return -1
	CASE "LOCATIONS"
		li_sts = display_locations(handle)
		if li_sts < 0 then return -1
	CASE "FILETYPES"
		li_sts = display_filetypes(handle)
		if li_sts < 0 then return -1
	CASE "PRACTICE"
		li_sts = display_practice_children(handle)
		if li_sts < 0 then return -1
	CASE "OFFICES"
		li_sts = display_offices(handle)
		if li_sts < 0 then return -1
	CASE "SYSADMINS"
		li_sts = display_sysadmins(handle)
		if li_sts < 0 then return -1
	CASE "SYSADMIN"
		li_sts = display_sysadmin(handle)
		if li_sts < 0 then return -1
	CASE "OFFICE"
		li_sts = display_groups(handle)
		if li_sts < 0 then return -1
	CASE "GROUP"
		li_sts = display_group_children(handle)
		if li_sts < 0 then return -1
	CASE "ROOM"
		//li_sts = display_room_children(handle)
		if li_sts < 0 then return -1
	CASE "DOCUMENTPURPOSEACTORS"
		li_sts = display_document_purpose_recipients(handle)
		if li_sts < 0 then return -1
	CASE "DOCUMENTPURPOSEWORKPLANS"
		li_sts = display_document_purpose_workplans(handle)
		if li_sts < 0 then return -1
	CASE "INTERFACECONFIG"
		li_sts = display_interface_configuration(handle)
	CASE "DOCUMENTPURPOSE"
		li_sts = display_document_purpose_children(handle)
	CASE "PURPOSECONTEXT"
		li_sts = display_document_purposes(handle)
	CASE "INTERFACEPURPOSE"
		li_sts = display_document_purpose_contexts(handle)
	CASE "INTERFACES"
		li_sts = display_interfaces(handle)
		if li_sts < 0 then return -1
	CASE "INTERFACE"
		li_sts = display_interface_children(handle)
		if li_sts < 0 then return -1
	CASE "INTERFACE TRANSPORT"
		li_sts = display_transport_children(handle)
		if li_sts < 0 then return -1
	CASE "PRINTERS"
		li_sts = display_printers(handle)
		if li_sts < 0 then return -1
END CHOOSE


return 0

end event

event doubleclicked;common_menu(handle)

end event

event rightclicked;common_menu(handle)

end event

event key;////keyflags:
//// 1 Shift key
//// 2 Ctrl key
//// 3 Shift and Ctrl keys
////
//// display script Hotkeys
//// Ctrl-C = copy
//// Ctrl-V = Paste
//// Delete = Delete
//// Insert = Append Below (bottom if Display Script is selected)
//// Shift-Insert = Append Above (Top if Display Script is selected)
//// Shift-up = move up
//// Shift-down = move down
//
//integer li_sts
//str_item_data lstr_item_data
//treeviewitem ltvi_item
//long ll_handle
//long ll_from_ds_index
//long ll_from_dc_index
//boolean lb_above
//long ll_new_item_handle
//long ll_ds_idx
//long ll_dc_idx
//str_attributes lstr_attributes
//long i
//long ll_prev_handle
//
//
//if not allow_editing then return
//
//if key = KeyShift! then return
//if key = KeyControl! then return
//
//
//ll_handle = FindItem ( CurrentTreeItem!	, 0 )
//if ll_handle <= 0 then return
//
//li_sts = getitem(ll_handle, ltvi_item)
//if li_sts <= 0 then return
//
//lstr_item_data = ltvi_item.data
//
//ll_ds_idx = get_display_script(lstr_item_data.display_script_id)
//if ll_ds_idx <= 0 then return
//
//ll_dc_idx = get_display_command(ll_ds_idx, lstr_item_data.display_command_id)
//if ll_dc_idx <= 0 then return
//
//lstr_attributes = display_script[ll_ds_idx].display_command[ll_dc_idx].attributes
//
//
//CHOOSE CASE upper(lstr_item_data.node_type)
//	CASE "DISPLAY_SCRIPT"
//		CHOOSE CASE key
//			CASE KeySpaceBar!
//				if ltvi_item.expanded then
//					collapseitem(ll_handle)
//				else
//					if keyflags = 1 then
//						expandall(ll_handle)
//					else
//						expanditem(ll_handle)
//					end if
//				end if
//			CASE KeyInsert!
//				if keyflags = 1 then
//					new_command(ll_handle, "top")
//				else
//					new_command(ll_handle, "bottom")
//				end if
//		END CHOOSE
//	CASE "COMMAND"
//		CHOOSE CASE key
//			CASE KeyInsert!
//				if keyflags = 1 then
//					new_command(ll_handle, true)
//				else
//					new_command(ll_handle, false)
//				end if
//			CASE KeySpaceBar!
//				if ltvi_item.expanded then
//					collapseitem(ll_handle)
//				else
//					if keyflags = 1 then
//						expandall(ll_handle)
//					else
//						expanditem(ll_handle)
//					end if
//				end if
//			CASE KeyEnter!
//				configure_command(ll_handle)
//			CASE KeyC!
//				if keyflags = 2 then
//					copy_item_handle = ll_handle
//					copy_item_data = lstr_item_data
//				end if
//			CASE KeyV!
//				// Ctrl-V = paste above
//				// Ctrl-Shift-V = paste below
//				if keyflags = 2  or keyflags = 3 then
//					if keyflags = 2 then
//						lb_above = true
//					else
//						lb_above = false
//					end if
//					
//					ll_from_ds_index = get_display_script(copy_item_data.display_script_id)
//					if ll_from_ds_index <= 0 then return
//					
//					ll_from_dc_index = get_display_command(ll_from_ds_index, copy_item_data.display_command_id)
//					if ll_from_dc_index <= 0 then return
//					
//					ll_new_item_handle = insert_command(display_script[ll_from_ds_index].display_command[ll_from_dc_index], ll_handle, lb_above)
//					
//					selectitem(ll_new_item_handle)
//				end if
//			CASE KeyDelete!
//				for i = ll_dc_idx to display_script[ll_ds_idx].display_command_count - 1
//					display_script[ll_ds_idx].display_command[i] = display_script[ll_ds_idx].display_command[i + 1]
//				next
//				display_script[ll_ds_idx].display_command_count -= 1
//				deleteitem(ll_handle)
//				changes_made()
//			CASE KeyUpArrow!
//				ll_prev_handle = FindItem (PreviousTreeItem!	, ll_handle )
//				if ll_prev_handle <= 0 then return
//				
//				if keyflags = 1 then
//					move_command(ll_prev_handle, ll_handle, false)
//					this.function post selectitem(ll_handle)
//				end if
//			CASE KeyDownArrow!
//				ll_prev_handle = FindItem ( NextTreeItem!	, ll_handle )
//				if ll_prev_handle <= 0 then return
//				
//				if keyflags = 1 then
//					move_command(ll_prev_handle, ll_handle, true)
//					this.function post selectitem(ll_handle)
//				end if
//		END CHOOSE
//	CASE "ATTRIBUTE"
//		CHOOSE CASE key
//			CASE KeyEnter!
//				configure_attribute(ll_handle)
//			CASE KeySpaceBar!
//				if ltvi_item.expanded then
//					collapseitem(ll_handle)
//				else
//					if keyflags = 1 then
//						expandall(ll_handle)
//					else
//						expanditem(ll_handle)
//					end if
//				end if
//		END CHOOSE
//END CHOOSE
//
//
//
end event

event constructor;pictureheight = 16
picturewidth = 18
picturemaskcolor = rgb(192,192,192)
end event

