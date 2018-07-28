HA$PBExportHeader$u_configuration_node_contraindication_component.sru
forward
global type u_configuration_node_contraindication_component from u_configuration_node_base
end type
end forward

global type u_configuration_node_contraindication_component from u_configuration_node_base
end type
global u_configuration_node_contraindication_component u_configuration_node_contraindication_component

forward prototypes
public function boolean has_children ()
public function integer activate ()
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

if len(node.key) > 0 then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Remove Alert Component"
	popup.button_titles[popup.button_count] = "Remove"
	lsa_buttons[popup.button_count] = "REMOVE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_wrench.bmp"
	popup.button_helps[popup.button_count] = "Configure Alert Component"
	popup.button_titles[popup.button_count] = "Configure"
	lsa_buttons[popup.button_count] = "CONFIGURE"
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
		if len(node.key) > 0 then
			openwithparm(w_pop_yes_no, "Are you sure you want to remove this Alert Component?")
			popup_return = message.powerobjectparm
			if popup_return.item <> "YES" then return 1
			
			DELETE FROM c_Domain
			WHERE domain_id = 'Config Contraindication Alerts'
			AND domain_item = :node.key;
			if not tf_check() then return -1
			
			openwithparm(w_pop_message, "Removing the Alert Component has succeeded and the change is in effect now at this workstation.  It will take effect at each other workstation when EncounterPRO is restarted at that workstation.")
			
			common_thread.load_contraindication_alerts()
			return 3
		else
			openwithparm(w_pop_message, "The ~"EncounterPRO Standard Alerts~" component cannot be removed")
			return 1
		end if
	CASE "CONFIGURE"
		if len(node.key) > 0 then
			f_configure_config_object(node.key)
			return 2
		else
			openwithparm(w_pop_message, "The ~"EncounterPRO Standard Alerts~" component has no configuration options")
			return 1
		end if
	CASE "CANCEL"
		return 1
	CASE ELSE
		return 1
END CHOOSE

Return 1

end function

on u_configuration_node_contraindication_component.create
call super::create
end on

on u_configuration_node_contraindication_component.destroy
call super::destroy
end on

