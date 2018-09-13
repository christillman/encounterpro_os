$PBExportHeader$u_configuration_node_alerts_contraindication.sru
forward
global type u_configuration_node_alerts_contraindication from u_configuration_node_base
end type
end forward

global type u_configuration_node_alerts_contraindication from u_configuration_node_base
end type
global u_configuration_node_alerts_contraindication u_configuration_node_alerts_contraindication

forward prototypes
public function boolean has_children ()
public function str_configuration_nodes get_children ()
public function integer activate ()
public function integer add_contraindication_alerts ()
public subroutine set_required_privilege ()
end prototypes

public function boolean has_children ();return true
end function

public function str_configuration_nodes get_children ();str_configuration_nodes lstr_nodes
long i

lstr_nodes.node_count = 0

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "EncounterPRO Standard Alerts"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_contraindication_component"
lstr_nodes.node[lstr_nodes.node_count].button = "button_epie.bmp"
lstr_nodes.node[lstr_nodes.node_count].key = "" // built in alerts

for i = 1 to common_thread.contraindication_count
	lstr_nodes.node_count += 1
	lstr_nodes.node[lstr_nodes.node_count].label = common_thread.contraindication_alerts[i].description
	if common_thread.contraindication_alerts[i].installed_version > 0 then
		lstr_nodes.node[lstr_nodes.node_count].label += " Ver. " + string(common_thread.contraindication_alerts[i].installed_version)
	end if
	lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_contraindication_component"
	lstr_nodes.node[lstr_nodes.node_count].button = "button_exclam_red.bmp"
	lstr_nodes.node[lstr_nodes.node_count].key = common_thread.contraindication_alerts[i].config_object_id
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

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Add Alert Component"
	popup.button_titles[popup.button_count] = "Add Alert Component"
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
		return add_contraindication_alerts()
	CASE "CANCEL"
		return 1
	CASE ELSE
		return 1
END CHOOSE

Return 1

end function

public function integer add_contraindication_alerts ();str_popup_return	popup_return
w_window_base lw_pick
str_pick_config_object lstr_pick_config_object
long ll_domain_sequence

lstr_pick_config_object.config_object_type = "Contraindication Alerts"
lstr_pick_config_object.context_object = "Patient"

openwithparm(lw_pick, lstr_pick_config_object, "w_pick_config_object")
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

//ls_display = popup_return.descriptions[1]
//param_value = popup_return.items[1]

SELECT max(domain_sequence)
INTO :ll_domain_sequence
FROM c_Domain
WHERE domain_id = 'Config Contraindication Alerts';
if not tf_check() then return -1

if isnull(ll_domain_sequence) then
	ll_domain_sequence = 1
else
	ll_domain_sequence += 1
end if

INSERT INTO c_Domain (
	domain_id,
	domain_sequence,
	domain_item)
VALUES (
	'Config Contraindication Alerts',
	:ll_domain_sequence,
	:popup_return.items[1]);
if not tf_check() then return -1

openwithparm(w_pop_message, "Adding the Alert Component has succeeded and the change is in effect now at this workstation.  It will take effect at each other workstation when EncounterPRO is restarted at that workstation.")

common_thread.load_contraindication_alerts()

return 2

end function

public subroutine set_required_privilege ();required_privilege = "Practice Configuration"
end subroutine

on u_configuration_node_alerts_contraindication.create
call super::create
end on

on u_configuration_node_alerts_contraindication.destroy
call super::destroy
end on

