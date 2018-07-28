$PBExportHeader$u_configuration_node_sysadmin.sru
forward
global type u_configuration_node_sysadmin from u_configuration_node_base
end type
end forward

global type u_configuration_node_sysadmin from u_configuration_node_base
end type
global u_configuration_node_sysadmin u_configuration_node_sysadmin

forward prototypes
public function boolean has_children ()
public function integer activate ()
public subroutine refresh_label ()
end prototypes

public function boolean has_children ();return false
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
string ls_user_id

Setnull(ls_null)
Setnull(ll_null)

ls_user_id = node.key

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
	if ll_button_pressed < 1 or ll_button_pressed > popup.button_count then return 1
elseif popup.button_count = 1 then
	ll_button_pressed = 1
else
	return 1
end if

CHOOSE CASE lsa_buttons[ll_button_pressed]
	CASE "REMOVE"
		common_thread.practice_users_remove_user("Sysadmin", ls_user_id)
		return 3
	CASE "EDIT"
		popup.data_row_count = 1
		popup.items[1] = ls_user_id
		openwithparm(w_user_definition, popup)
		return 2
	CASE "CANCEL"
		return 1
	CASE ELSE
END CHOOSE

Return 1

end function

public subroutine refresh_label ();node.label = user_list.user_full_name(node.key)


end subroutine

on u_configuration_node_sysadmin.create
call super::create
end on

on u_configuration_node_sysadmin.destroy
call super::destroy
end on

