HA$PBExportHeader$u_configuration_node_office.sru
forward
global type u_configuration_node_office from u_configuration_node_base
end type
end forward

global type u_configuration_node_office from u_configuration_node_base
end type
global u_configuration_node_office u_configuration_node_office

forward prototypes
public function boolean has_children ()
public function str_configuration_nodes get_children ()
public function integer activate ()
public subroutine refresh_label ()
end prototypes

public function boolean has_children ();return true
end function

public function str_configuration_nodes get_children ();str_configuration_nodes lstr_nodes
u_ds_data luo_data
long ll_count
long i
string ls_status
string ls_persistence_flag

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_o_groups_for_office")
ll_count = luo_data.retrieve(node.key)

lstr_nodes.node_count = 0

for i = 1 to ll_count
	ls_persistence_flag = luo_data.object.persistence_flag[i]
	
	lstr_nodes.node_count += 1
	lstr_nodes.node[lstr_nodes.node_count].label = luo_data.object.description[i]
	lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_office_group"
	lstr_nodes.node[lstr_nodes.node_count].key = string(long(luo_data.object.group_id[i]))

	if ls_persistence_flag = "Y" then
		lstr_nodes.node[lstr_nodes.node_count].button = "button_room_group.gif"
	else
		lstr_nodes.node[lstr_nodes.node_count].button = "button_room_group_dynamic.gif"
	end if
next

DESTROY luo_data

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Waiting Rooms"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_office_waiting_rooms"
lstr_nodes.node[lstr_nodes.node_count].key = node.key
lstr_nodes.node[lstr_nodes.node_count].button = "button_waiting_room.gif"

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
long ll_sort_sequence

Setnull(ls_null)
Setnull(ll_null)

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
	if ll_button_pressed < 1 or ll_button_pressed > popup.button_count then return 1
elseif popup.button_count = 1 then
	ll_button_pressed = 1
else
	return 1
end if

CHOOSE CASE lsa_buttons[ll_button_pressed]
	CASE "EDIT"
		popup.data_row_count = 1
		popup.items[1] = sqlca.fn_office_user_id(node.key)
		openwithparm(w_user_definition, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return 1
		
		return 2
	CASE "NEWROOMGROUP"
		popup.title = "Enter name for new room group"
		popup.datacolumn = 32
		popup.dataobject = ""
		popup.data_row_count = 0
		openwithparm(w_pop_prompt_string, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return 1
		
		if len(popup_return.items[1]) > 0 then
			SELECT max(sort_sequence)
			INTO :ll_sort_sequence
			FROM o_Groups
			WHERE office_id = :node.key;
			if not tf_check() then return 1
			
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
				:node.key,
				'Y');
			if not tf_check() then return 1
			
			return 2
		end if
	CASE "GROUPORDER"
		popup.dataobject = "dw_o_groups_for_office"
		popup.datacolumn = 1
		popup.displaycolumn = 2
		popup.argument_count = 1
		popup.argument[1] = node.key
		openwithparm(w_pop_order_datawindow, popup)
	CASE "ROOMORDER"
		popup.dataobject = "dw_room_list_office"
		popup.datacolumn = 1
		popup.displaycolumn = 2
		popup.argument_count = 1
		popup.argument[1] = node.key
		openwithparm(w_pop_order_datawindow, popup)
	CASE "CANCEL"
		return 1
	CASE ELSE
END CHOOSE

Return 1

end function

public subroutine refresh_label ();string ls_label
string ls_status
string ls_office_user_id

// Refresh the status
SELECT status
INTO :ls_status
FROM c_Office
WHERE office_id = :node.key;
if not tf_check() then return

ls_office_user_id = sqlca.fn_office_user_id(node.key)
ls_label = user_list.user_full_name(ls_office_user_id)

if upper(ls_status) <> "OK" then
	ls_label += " (Inactive)"
end if

node.label = ls_label


end subroutine

on u_configuration_node_office.create
call super::create
end on

on u_configuration_node_office.destroy
call super::destroy
end on

