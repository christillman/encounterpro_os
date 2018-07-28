HA$PBExportHeader$u_configuration_node_components.sru
forward
global type u_configuration_node_components from u_configuration_node_base
end type
end forward

global type u_configuration_node_components from u_configuration_node_base
end type
global u_configuration_node_components u_configuration_node_components

forward prototypes
public function boolean has_children ()
public function str_configuration_nodes get_children ()
end prototypes

public function boolean has_children ();return true
end function

public function str_configuration_nodes get_children ();u_user luo_practice
str_configuration_nodes lstr_nodes


lstr_nodes.node_count = 0


lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Component Upgrade Manager"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_component_upgrade_manager"
lstr_nodes.node[lstr_nodes.node_count].button = "button_component_upgrade.gif"
lstr_nodes.node[lstr_nodes.node_count].key = "" // No key needed

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Component Trial Manager"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_component_trial_manager"
lstr_nodes.node[lstr_nodes.node_count].button = "button_component_trial.gif"
lstr_nodes.node[lstr_nodes.node_count].key = "" // No key needed

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Component Client Install"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_component_client_install"
lstr_nodes.node[lstr_nodes.node_count].button = "button_computer.gif"
lstr_nodes.node[lstr_nodes.node_count].key = "" // No key needed

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Component Types"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_component_types"
lstr_nodes.node[lstr_nodes.node_count].button = "button_component_types.gif"
lstr_nodes.node[lstr_nodes.node_count].key = "" // No key needed

return lstr_nodes

end function

on u_configuration_node_components.create
call super::create
end on

on u_configuration_node_components.destroy
call super::destroy
end on

