$PBExportHeader$u_configuration_node_office_room.sru
forward
global type u_configuration_node_office_room from u_configuration_node_base
end type
end forward

global type u_configuration_node_office_room from u_configuration_node_base
end type
global u_configuration_node_office_room u_configuration_node_office_room

forward prototypes
public function boolean has_children ()
public subroutine refresh_label ()
public function integer activate ()
end prototypes

public function boolean has_children ();return false
end function

public subroutine refresh_label ();string ls_status
string ls_room_name
str_room_type lstr_room_type
string ls_room_type

SELECT status, room_name, room_type
INTO :ls_status, :ls_room_name, :ls_room_type
FROM o_Rooms
WHERE room_id = :node.key;
if not tf_check() then return

node.label = ls_room_name

lstr_room_type = datalist.room_type(ls_room_type)
node.button = lstr_room_type.button

end subroutine

public function integer activate ();String		lsa_buttons[]
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

ls_room_name = node.label

ls_group_name = parent_configuration_node.node.label
ll_group_id = long(parent_configuration_node.node.key)

if lower(parent_configuration_node.node.class) = "u_configuration_node_office_waiting_rooms" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Remove Waiting Room"
	popup.button_titles[popup.button_count] = "Remove"
	lsa_buttons[popup.button_count] = "REMOVEWAITING"
else
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
	if ll_button_pressed < 1 or ll_button_pressed > popup.button_count then return 1
elseif popup.button_count = 1 then
	ll_button_pressed = 1
else
	return 1
end if

CHOOSE CASE lsa_buttons[ll_button_pressed]
	CASE "REMOVEWAITING"
		openwithparm(w_pop_yes_no, "Are you sure you want to remove the waiting room ~"" + ls_room_name + "~"?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return 1
		
		UPDATE o_Rooms
		SET status = 'NA'
		WHERE room_id = :node.key;
		if not tf_check() then return 1
		
		return 3
	CASE "REMOVE"
		openwithparm(w_pop_yes_no, "Are you sure you want to remove ~"" + ls_room_name + "~" from the " + ls_group_name + " group?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return 1
		
		DELETE FROM o_Group_Rooms
		WHERE group_id = :ll_group_id
		AND room_id = :node.key;
		if not tf_check() then return 1
		
		return 3
	CASE "EDIT"
		openwithparm(lw_window, node.key, "w_room_properties")
		return 2
	CASE "CANCEL"
		return 1
	CASE ELSE
END CHOOSE

Return 1


end function

on u_configuration_node_office_room.create
call super::create
end on

on u_configuration_node_office_room.destroy
call super::destroy
end on

