$PBExportHeader$u_configuration_node_system_schedules.sru
forward
global type u_configuration_node_system_schedules from u_configuration_node_base
end type
end forward

global type u_configuration_node_system_schedules from u_configuration_node_base
end type
global u_configuration_node_system_schedules u_configuration_node_system_schedules

forward prototypes
public function boolean has_children ()
public function str_configuration_nodes get_children ()
end prototypes

public function boolean has_children ();str_configuration_nodes lstr_nodes
u_ds_data luo_data
long ll_count

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_fn_scheduled_services")
ll_count = luo_data.retrieve()

DESTROY luo_data

if ll_count > 0 then
	return true
else
	return false
end if

end function

public function str_configuration_nodes get_children ();u_user luo_practice
str_configuration_nodes lstr_nodes
u_ds_data luo_data
long ll_count
long i
string ls_status
str_room_type lstr_room_type
string ls_room_type

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_fn_scheduled_services")
ll_count = luo_data.retrieve()

lstr_nodes.node_count = 0

luo_data.setfilter("status='OK'")
luo_data.filter()
ll_count = luo_data.rowcount()
lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Enabled Scheduled Tasks (" + string(ll_count) + ")"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_system_schedule_group"
lstr_nodes.node[lstr_nodes.node_count].button = "button_clock.bmp"
lstr_nodes.node[lstr_nodes.node_count].key = "OK"

luo_data.setfilter("status='NA'")
luo_data.filter()
ll_count = luo_data.rowcount()
lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Disabled Scheduled Tasks (" + string(ll_count) + ")"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_system_schedule_group"
lstr_nodes.node[lstr_nodes.node_count].button = "button_clock.bmp"
lstr_nodes.node[lstr_nodes.node_count].key = "NA"

DESTROY luo_data

return lstr_nodes

end function

on u_configuration_node_system_schedules.create
call super::create
end on

on u_configuration_node_system_schedules.destroy
call super::destroy
end on

