$PBExportHeader$u_configuration_node_office_waiting_rooms.sru
forward
global type u_configuration_node_office_waiting_rooms from u_configuration_node_base
end type
end forward

global type u_configuration_node_office_waiting_rooms from u_configuration_node_base
end type
global u_configuration_node_office_waiting_rooms u_configuration_node_office_waiting_rooms

forward prototypes
public function boolean has_children ()
public function str_configuration_nodes get_children ()
public function integer activate ()
public function integer add_room_to_group (string ps_office_id, long pl_group_id)
end prototypes

public function boolean has_children ();str_configuration_nodes lstr_nodes
u_ds_data luo_data
long ll_count
long i
string ls_status
str_room_type lstr_room_type
string ls_room_type

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_waiting_room_list")
ll_count = luo_data.retrieve(node.key)

if ll_count > 0 then
	return true
else
	return false
end if

end function

public function str_configuration_nodes get_children ();str_configuration_nodes lstr_nodes
u_ds_data luo_data
long ll_count
long i
string ls_status
str_room_type lstr_room_type
string ls_room_type

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_waiting_room_list")
ll_count = luo_data.retrieve(node.key)

lstr_nodes.node_count = 0

for i = 1 to ll_count
	ls_status = luo_data.object.status[i]
	ls_room_type = luo_data.object.room_type[i]
	
	lstr_nodes.node_count += 1
	lstr_nodes.node[lstr_nodes.node_count].label = luo_data.object.room_name[i]
	lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_office_room"
	lstr_nodes.node[lstr_nodes.node_count].key = luo_data.object.room_id[i]

	lstr_room_type = datalist.room_type(ls_room_type)
	lstr_nodes.node[lstr_nodes.node_count].button = lstr_room_type.button
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
str_users lstr_users
str_pick_users lstr_pick_users
integer li_count
long i, j
str_room lstr_room
w_window_base lw_window
string ls_office_id

Setnull(ls_null)
Setnull(ll_null)

ls_office_id = parent_configuration_node.node.key
if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button10.bmp"
	popup.button_helps[popup.button_count] = "Define New Room in this Room Group"
	popup.button_titles[popup.button_count] = "New Room"
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
		lstr_room = f_new_waiting_room(ls_office_id)
		openwithparm(lw_window, lstr_room.room_id, "w_room_properties")
		return 2
	CASE "CANCEL"
		return 1
	CASE ELSE
END CHOOSE

Return 1

end function

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

on u_configuration_node_office_waiting_rooms.create
call super::create
end on

on u_configuration_node_office_waiting_rooms.destroy
call super::destroy
end on

