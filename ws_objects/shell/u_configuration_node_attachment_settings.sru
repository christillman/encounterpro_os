HA$PBExportHeader$u_configuration_node_attachment_settings.sru
forward
global type u_configuration_node_attachment_settings from u_configuration_node_base
end type
end forward

global type u_configuration_node_attachment_settings from u_configuration_node_base
end type
global u_configuration_node_attachment_settings u_configuration_node_attachment_settings

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
lstr_nodes.node[lstr_nodes.node_count].label = "Locations"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_attachment_locations"
lstr_nodes.node[lstr_nodes.node_count].button = "button_data_server.bmp"
lstr_nodes.node[lstr_nodes.node_count].key = "" // No key needed

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "File Types"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_attachment_filetypes"
lstr_nodes.node[lstr_nodes.node_count].button = "button_docmgr.bmp"
lstr_nodes.node[lstr_nodes.node_count].key = "" // No key needed


return lstr_nodes

end function

on u_configuration_node_attachment_settings.create
call super::create
end on

on u_configuration_node_attachment_settings.destroy
call super::destroy
end on

