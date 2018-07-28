HA$PBExportHeader$u_configuration_node_chart_service.sru
forward
global type u_configuration_node_chart_service from u_configuration_node_base
end type
end forward

global type u_configuration_node_chart_service from u_configuration_node_base
end type
global u_configuration_node_chart_service u_configuration_node_chart_service

forward prototypes
public function boolean has_children ()
public function str_configuration_nodes get_children ()
end prototypes

public function boolean has_children ();return true
end function

public function str_configuration_nodes get_children ();str_configuration_nodes lstr_nodes


lstr_nodes.node_count = 0

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Chart Pages"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_chart_pages"
lstr_nodes.node[lstr_nodes.node_count].key = "" // No key needed
lstr_nodes.node[lstr_nodes.node_count].button = "button_page.bmp"

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Folders"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_service"
lstr_nodes.node[lstr_nodes.node_count].key = "CONFIG_LETTER_TYPES"
lstr_nodes.node[lstr_nodes.node_count].button = datalist.service_button(lstr_nodes.node[lstr_nodes.node_count].key)

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Chart Layouts"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_service"
lstr_nodes.node[lstr_nodes.node_count].key = "CONFIG_CHARTS"
lstr_nodes.node[lstr_nodes.node_count].button = datalist.service_button(lstr_nodes.node[lstr_nodes.node_count].key)

return lstr_nodes

end function

on u_configuration_node_chart_service.create
call super::create
end on

on u_configuration_node_chart_service.destroy
call super::destroy
end on

