$PBExportHeader$u_configuration_node_component.sru
forward
global type u_configuration_node_component from u_configuration_node_base
end type
end forward

global type u_configuration_node_component from u_configuration_node_base
end type
global u_configuration_node_component u_configuration_node_component

type variables
string disabled_suffix = "  (Disabled)"

end variables

forward prototypes
public function boolean has_children ()
public function integer activate ()
end prototypes

public function boolean has_children ();return false
end function

public function integer activate ();str_popup popup
w_window_base lw_window

//popup.title = node.label + " Component Properties"
//popup.dataobject = "dw_component_properties"
//popup.argument_count = 1
//popup.argument[1] = node.key
//openwithparm(w_pop_display_datawindow, popup)
//

openwithparm(lw_window, node.key, "w_component_manage")

return 1

end function

on u_configuration_node_component.create
call super::create
end on

on u_configuration_node_component.destroy
call super::destroy
end on

