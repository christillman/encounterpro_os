$PBExportHeader$u_configuration_node_attachment_locations.sru
forward
global type u_configuration_node_attachment_locations from u_configuration_node_base
end type
end forward

global type u_configuration_node_attachment_locations from u_configuration_node_base
end type
global u_configuration_node_attachment_locations u_configuration_node_attachment_locations

forward prototypes
public function boolean has_children ()
public function str_configuration_nodes get_children ()
public function integer activate ()
end prototypes

public function boolean has_children ();return true
end function

public function str_configuration_nodes get_children ();str_configuration_nodes lstr_nodes
u_ds_data luo_data
long ll_count
long i
long ll_attachment_location_id
string ls_attachment_server
string ls_attachment_share
string ls_status

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_c_attachment_location")
ll_count = luo_data.retrieve(node.key)

lstr_nodes.node_count = 0

for i = 1 to ll_count
	ll_attachment_location_id = luo_data.object.attachment_location_id[i]
	ls_attachment_server = luo_data.object.attachment_server[i]
	ls_attachment_share = luo_data.object.attachment_share[i]
	ls_status = luo_data.object.status[i]
	
	lstr_nodes.node_count += 1
	lstr_nodes.node[lstr_nodes.node_count].label = string(ll_attachment_location_id) + "    \\" + ls_attachment_server + "\" + ls_attachment_share
	if upper(ls_status) = "NA" then
		lstr_nodes.node[lstr_nodes.node_count].label += "  (Disabled)"
	end if
	lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_attachment_location"
	lstr_nodes.node[lstr_nodes.node_count].key = string(ll_attachment_location_id)
	lstr_nodes.node[lstr_nodes.node_count].button = "button_folder.png"
next


DESTROY luo_data

return lstr_nodes

end function

public function integer activate ();String		lsa_buttons[]
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
string ls_status
long ll_new_attachment_location_id
string ls_attachment_server
string ls_attachment_share
long ll_new_handle

Setnull(ls_null)
Setnull(ll_null)


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
	if ll_button_pressed < 1 or ll_button_pressed > popup.button_count then return 1
elseif popup.button_count = 1 then
	ll_button_pressed = 1
else
	return 1
end if

CHOOSE CASE lsa_buttons[ll_button_pressed]
	CASE "ADD"
		ll_new_attachment_location_id = f_new_attachment_location()
		
		return 2
	CASE "CANCEL"
		return 1
	CASE ELSE
END CHOOSE

Return 1

end function

on u_configuration_node_attachment_locations.create
call super::create
end on

on u_configuration_node_attachment_locations.destroy
call super::destroy
end on

