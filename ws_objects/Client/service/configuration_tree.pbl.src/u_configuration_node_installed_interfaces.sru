$PBExportHeader$u_configuration_node_installed_interfaces.sru
forward
global type u_configuration_node_installed_interfaces from u_configuration_node_base
end type
end forward

global type u_configuration_node_installed_interfaces from u_configuration_node_base
end type
global u_configuration_node_installed_interfaces u_configuration_node_installed_interfaces

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

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_practice_interfaces")
ll_count = luo_data.retrieve(node.key)

lstr_nodes.node_count = 0

for i = 1 to ll_count
	lstr_nodes.node_count += 1
	lstr_nodes.node[lstr_nodes.node_count].label = luo_data.object.interfacedescription[i]
	lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_installed_interface"
	lstr_nodes.node[lstr_nodes.node_count].key = string(luo_data.object.interfaceserviceid[i])
	lstr_nodes.node[lstr_nodes.node_count].button = luo_data.object.interfaceServiceType_icon[i]
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
str_service_info lstr_service
long ll_interfaceserviceid

Setnull(ls_null)
Setnull(ll_null)


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
	if ll_button_pressed < 1 or ll_button_pressed > popup.button_count then return 1
elseif popup.button_count = 1 then
	ll_button_pressed = 1
else
	return 1
end if

CHOOSE CASE lsa_buttons[ll_button_pressed]
	CASE "NEW"
		setnull(ll_interfaceserviceid)
		li_sts = f_configure_local_interface(ll_interfaceserviceid)
		return 2
	CASE "CANCEL"
		return 1
	CASE ELSE
END CHOOSE

Return 1

end function

on u_configuration_node_installed_interfaces.create
call super::create
end on

on u_configuration_node_installed_interfaces.destroy
call super::destroy
end on

