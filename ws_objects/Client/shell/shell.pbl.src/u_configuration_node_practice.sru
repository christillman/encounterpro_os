$PBExportHeader$u_configuration_node_practice.sru
forward
global type u_configuration_node_practice from u_configuration_node_base
end type
end forward

global type u_configuration_node_practice from u_configuration_node_base
end type
global u_configuration_node_practice u_configuration_node_practice

forward prototypes
public function boolean has_children ()
public function str_configuration_nodes get_children ()
public function integer activate ()
public subroutine set_required_privilege ()
end prototypes

public function boolean has_children ();return true
end function

public function str_configuration_nodes get_children ();u_user luo_practice
str_configuration_nodes lstr_nodes


lstr_nodes.node_count = 0

luo_practice = user_list.find_user(node.key)
if isnull(luo_practice) then
	log.log(this, "u_configuration_node_practice.get_children.0009", "practice_user_id not found (" + node.key + ")", 4)
	return lstr_nodes
end if

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Users and Roles"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_service"
lstr_nodes.node[lstr_nodes.node_count].key = "CONFIG_USERS"
lstr_nodes.node[lstr_nodes.node_count].button = datalist.service_button(lstr_nodes.node[lstr_nodes.node_count].key)

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Services"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_service"
lstr_nodes.node[lstr_nodes.node_count].key = "CONFIG_SERVICE"
lstr_nodes.node[lstr_nodes.node_count].button = datalist.service_button(lstr_nodes.node[lstr_nodes.node_count].key)

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Preferences"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_service"
lstr_nodes.node[lstr_nodes.node_count].key = "CONFIG_PREFERENCES"
lstr_nodes.node[lstr_nodes.node_count].button = datalist.service_button(lstr_nodes.node[lstr_nodes.node_count].key)

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Offices"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_offices"
lstr_nodes.node[lstr_nodes.node_count].button = "button_offices.gif"
lstr_nodes.node[lstr_nodes.node_count].key = "" // No key needed

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

Setnull(ls_null)
Setnull(ll_null)


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
	if ll_button_pressed < 1 or ll_button_pressed > popup.button_count then return 1
elseif popup.button_count = 1 then
	ll_button_pressed = 1
else
	return 1
end if

CHOOSE CASE lsa_buttons[ll_button_pressed]
	CASE "EDIT"
		popup.data_row_count = 1
		popup.items[1] = node.key
		openwithparm(w_user_definition, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return 1
		node.label = popup_return.descriptions[1]
		
		return 2
	CASE "CANCEL"
		return 1
	CASE ELSE
END CHOOSE

Return 1

end function

public subroutine set_required_privilege ();required_privilege = "Practice Configuration"

end subroutine

on u_configuration_node_practice.create
call super::create
end on

on u_configuration_node_practice.destroy
call super::destroy
end on

