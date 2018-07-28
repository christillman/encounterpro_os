$PBExportHeader$u_configuration_node_system.sru
forward
global type u_configuration_node_system from u_configuration_node_base
end type
end forward

global type u_configuration_node_system from u_configuration_node_base
end type
global u_configuration_node_system u_configuration_node_system

forward prototypes
public function boolean has_children ()
public function str_configuration_nodes get_children ()
public subroutine set_required_privilege ()
end prototypes

public function boolean has_children ();return true
end function

public function str_configuration_nodes get_children ();u_user luo_practice
str_configuration_nodes lstr_nodes


lstr_nodes.node_count = 0


lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "System Administrators"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_sysadmins"
lstr_nodes.node[lstr_nodes.node_count].button = "button_administrators.gif"
lstr_nodes.node[lstr_nodes.node_count].key = "" // No key needed

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Attachment Settings"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_attachment_settings"
lstr_nodes.node[lstr_nodes.node_count].button = "button_attachments.gif"
lstr_nodes.node[lstr_nodes.node_count].key = "" // No key needed

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Printers"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_printers"
lstr_nodes.node[lstr_nodes.node_count].button = "button_print.bmp"
lstr_nodes.node[lstr_nodes.node_count].key = "" // No key needed

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Scheduled Tasks"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_system_schedules"
lstr_nodes.node[lstr_nodes.node_count].button = "button_print.bmp"
lstr_nodes.node[lstr_nodes.node_count].key = "" // No key needed

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Preferences"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_service"
lstr_nodes.node[lstr_nodes.node_count].key = "CONFIG_PREFERENCES"
lstr_nodes.node[lstr_nodes.node_count].button = datalist.service_button(lstr_nodes.node[lstr_nodes.node_count].key)

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Components"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_components"
lstr_nodes.node[lstr_nodes.node_count].button = "button_components.gif"
lstr_nodes.node[lstr_nodes.node_count].key = "" // No key needed

return lstr_nodes

end function

public subroutine set_required_privilege ();required_privilege = "Edit System Config"

end subroutine

on u_configuration_node_system.create
call super::create
end on

on u_configuration_node_system.destroy
call super::destroy
end on

