$PBExportHeader$u_configuration_node_system_schedule_group.sru
forward
global type u_configuration_node_system_schedule_group from u_configuration_node_base
end type
end forward

global type u_configuration_node_system_schedule_group from u_configuration_node_base
end type
global u_configuration_node_system_schedule_group u_configuration_node_system_schedule_group

forward prototypes
public function boolean has_children ()
public function str_configuration_nodes get_children ()
public subroutine refresh_label ()
public function integer activate ()
end prototypes

public function boolean has_children ();str_configuration_nodes lstr_nodes
u_ds_data luo_data
long ll_count

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_fn_scheduled_services")
luo_data.setfilter("status='" + node.key + "'")
ll_count = luo_data.retrieve()

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
long ll_service_sequence
string ls_description
string ls_schedule_description
string ls_user_full_name

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_fn_scheduled_services")
luo_data.setfilter("status='" + node.key + "'")
ll_count = luo_data.retrieve()

lstr_nodes.node_count = 0

for i = 1 to ll_count
	ll_service_sequence = luo_data.object.service_sequence[i]
	ls_description = luo_data.object.description[i]
	ls_schedule_description = luo_data.object.schedule_description[i]
	ls_user_full_name = luo_data.object.user_full_name[i]
	lstr_nodes.node_count += 1
	lstr_nodes.node[lstr_nodes.node_count].label = ls_description + ", " + ls_schedule_description + " for " + ls_user_full_name
	lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_system_schedule"
	lstr_nodes.node[lstr_nodes.node_count].key = string(ll_service_sequence)
	lstr_nodes.node[lstr_nodes.node_count].button = "button_clock.bmp"
next

DESTROY luo_data

return lstr_nodes

end function

public subroutine refresh_label ();u_ds_data luo_data
long ll_count
long i
string ls_label
string ls_filter

if upper(node.key) = "OK" then
	ls_filter = "status='OK'"
	ls_label = "Enabled Scheduled Tasks"
else
	ls_filter = "status='NA'"
	ls_label = "Disabled Scheduled Tasks"
end if

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_fn_scheduled_services")
luo_data.setfilter(ls_filter)
ll_count = luo_data.retrieve()

node.label = ls_label + " (" + string(ll_count) + ")"

DESTROY luo_data

return

end subroutine

public function integer activate ();String		lsa_buttons[]
String 		ls_null
Integer		li_sts, li_service_count
Long			ll_null
long ll_button_pressed
window 				lw_pop_buttons
str_popup 			popup
str_popup_return 	popup_return
string ls_status
long i
w_window_base lw_window
string ls_parent_object_id
long ll_service_sequence

Setnull(ls_null)
Setnull(ll_null)

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_clock.bmp"
	popup.button_helps[popup.button_count] = "Create a New Scheduled Task"
	popup.button_titles[popup.button_count] = "New Task"
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
		setnull(ls_parent_object_id)
		ll_service_sequence = f_new_scheduled_service(ls_parent_object_id)
		if ll_service_sequence <= 0 then return 1
		
		openwithparm(lw_window, ll_service_sequence, "w_scheduled_service_edit")
		
		return 2
	CASE "CANCEL"
		return 1
	CASE ELSE
END CHOOSE

Return 1


end function

on u_configuration_node_system_schedule_group.create
call super::create
end on

on u_configuration_node_system_schedule_group.destroy
call super::destroy
end on

