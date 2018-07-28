HA$PBExportHeader$u_configuration_node_component_upgrade_manager.sru
forward
global type u_configuration_node_component_upgrade_manager from u_configuration_node_base
end type
end forward

global type u_configuration_node_component_upgrade_manager from u_configuration_node_base
end type
global u_configuration_node_component_upgrade_manager u_configuration_node_component_upgrade_manager

forward prototypes
public function integer activate ()
end prototypes

public function integer activate ();w_window_base lw_window

open(lw_window, "w_component_manage_upgrades")

return 1

end function

on u_configuration_node_component_upgrade_manager.create
call super::create
end on

on u_configuration_node_component_upgrade_manager.destroy
call super::destroy
end on

