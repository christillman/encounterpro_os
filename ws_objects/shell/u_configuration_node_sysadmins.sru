HA$PBExportHeader$u_configuration_node_sysadmins.sru
forward
global type u_configuration_node_sysadmins from u_configuration_node_base
end type
end forward

global type u_configuration_node_sysadmins from u_configuration_node_base
end type
global u_configuration_node_sysadmins u_configuration_node_sysadmins

forward prototypes
public function boolean has_children ()
public function str_configuration_nodes get_children ()
public function integer activate ()
end prototypes

public function boolean has_children ();str_configuration_nodes lstr_nodes
long ll_count
long i
str_users lstr_users

lstr_nodes.node_count = 0

lstr_users = common_thread.practice_users("Sysadmin")

if lstr_users.user_count > 0 then
	return true
else
	return false
end if

end function

public function str_configuration_nodes get_children ();str_configuration_nodes lstr_nodes
long ll_count
long i
str_users lstr_users

lstr_nodes.node_count = 0

lstr_users = common_thread.practice_users("Sysadmin")

for i = 1 to lstr_users.user_count
	lstr_nodes.node_count += 1
	lstr_nodes.node[lstr_nodes.node_count].label = lstr_users.user[i].user_full_name
	lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_sysadmin"
	lstr_nodes.node[lstr_nodes.node_count].key = lstr_users.user[i].user_id
	lstr_nodes.node[lstr_nodes.node_count].button = "button_sysadmin.bmp"
next

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
u_user luo_user

Setnull(ls_null)
Setnull(ll_null)

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
	if ll_button_pressed < 1 or ll_button_pressed > popup.button_count then return 1
elseif popup.button_count = 1 then
	ll_button_pressed = 1
else
	return 1
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
		
		return 2
	CASE "CANCEL"
		return 1
	CASE ELSE
END CHOOSE

Return 1


end function

on u_configuration_node_sysadmins.create
call super::create
end on

on u_configuration_node_sysadmins.destroy
call super::destroy
end on

