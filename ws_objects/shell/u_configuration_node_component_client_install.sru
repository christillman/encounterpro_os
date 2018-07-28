HA$PBExportHeader$u_configuration_node_component_client_install.sru
forward
global type u_configuration_node_component_client_install from u_configuration_node_base
end type
end forward

global type u_configuration_node_component_client_install from u_configuration_node_base
end type
global u_configuration_node_component_client_install u_configuration_node_component_client_install

forward prototypes
public function integer activate ()
end prototypes

public function integer activate ();w_window_base lw_window

open(lw_window, "w_component_client_install")

return 1

end function

on u_configuration_node_component_client_install.create
call super::create
end on

on u_configuration_node_component_client_install.destroy
call super::destroy
end on

