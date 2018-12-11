$PBExportHeader$u_configuration_node_alerts_chart.sru
forward
global type u_configuration_node_alerts_chart from u_configuration_node_base
end type
end forward

global type u_configuration_node_alerts_chart from u_configuration_node_base
end type
global u_configuration_node_alerts_chart u_configuration_node_alerts_chart

forward prototypes
public function integer activate ()
public subroutine set_required_privilege ()
public function integer change_chart_alert_component ()
end prototypes

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
	popup.button_helps[popup.button_count] = "Change Chart Alert Component"
	popup.button_titles[popup.button_count] = "Change"
	lsa_buttons[popup.button_count] = "CHANGE"
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
	CASE "CHANGE"
		return change_chart_alert_component()
	CASE "CANCEL"
		return 1
	CASE ELSE
		return 1
END CHOOSE

Return 1

end function

public subroutine set_required_privilege ();required_privilege = "Practice Configuration"
end subroutine

public function integer change_chart_alert_component ();integer li_sts
str_popup popup
str_popup_return	popup_return
long ll_domain_sequence
string ls_component_id

popup.dataobject = "dw_c_component_definition_pick"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = "ALERT"

Openwithparm(w_pop_pick, popup)
popup_return = Message.powerobjectparm
If popup_return.item_count <> 1 then
	if popup_return.choices_count > 0 then return 0
	openwithparm(w_pop_message, "The EncounterPRO Standard Chart Alert is the only chart alert component available")
	return 0
end if

ls_component_id = popup_return.items[1]


li_sts = common_thread.set_chart_alert_component(ls_component_id)

openwithparm(w_pop_message, "Changing the Chart Alert component has succeeded")

return 2

end function

on u_configuration_node_alerts_chart.create
call super::create
end on

on u_configuration_node_alerts_chart.destroy
call super::destroy
end on

