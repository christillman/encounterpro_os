HA$PBExportHeader$u_configuration_node_attachment_filetype.sru
forward
global type u_configuration_node_attachment_filetype from u_configuration_node_base
end type
end forward

global type u_configuration_node_attachment_filetype from u_configuration_node_base
end type
global u_configuration_node_attachment_filetype u_configuration_node_attachment_filetype

forward prototypes
public function boolean has_children ()
public function integer activate ()
end prototypes

public function boolean has_children ();return false
end function

public function integer activate ();w_window_base lw_window
openwithparm(lw_window, node.key, "w_config_attachment_extension")

return 1

end function

on u_configuration_node_attachment_filetype.create
call super::create
end on

on u_configuration_node_attachment_filetype.destroy
call super::destroy
end on

