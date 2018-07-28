HA$PBExportHeader$u_configuration_node_assessment_types.sru
forward
global type u_configuration_node_assessment_types from u_configuration_node_base
end type
end forward

global type u_configuration_node_assessment_types from u_configuration_node_base
end type
global u_configuration_node_assessment_types u_configuration_node_assessment_types

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
string ls_status

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_assessment_type_list")
ll_count = luo_data.retrieve()

lstr_nodes.node_count = 0

for i = 1 to ll_count
	ls_status = luo_data.object.status[i]
	
	lstr_nodes.node_count += 1
	lstr_nodes.node[lstr_nodes.node_count].label = luo_data.object.description[i]
	if upper(ls_status) = "NA" then
		lstr_nodes.node[lstr_nodes.node_count].label += " (Inactive)"
	end if
	lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_assessment_type"
	lstr_nodes.node[lstr_nodes.node_count].key = luo_data.object.assessment_type[i]
	lstr_nodes.node[lstr_nodes.node_count].button = luo_data.object.icon_open[i]
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
string ls_user_id
long ll_new_handle
string ls_office_id
string ls_status

Setnull(ls_null)
Setnull(ll_null)

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
	if ll_button_pressed < 1 or ll_button_pressed > popup.button_count then return 1
elseif popup.button_count = 1 then
	ll_button_pressed = 1
else
	return 1
end if

CHOOSE CASE lsa_buttons[ll_button_pressed]
	CASE "NEW"
		// Create the new office
		ls_user_id = user_list.new_user("Office")

		if len(ls_user_id) > 0 then
			return 2
		end if
	CASE "CANCEL"
		return 1
	CASE ELSE
END CHOOSE

Return 1

end function

on u_configuration_node_assessment_types.create
call super::create
end on

on u_configuration_node_assessment_types.destroy
call super::destroy
end on

