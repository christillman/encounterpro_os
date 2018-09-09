$PBExportHeader$u_configuration_node_configuration.sru
forward
global type u_configuration_node_configuration from u_configuration_node_base
end type
end forward

global type u_configuration_node_configuration from u_configuration_node_base
end type
global u_configuration_node_configuration u_configuration_node_configuration

forward prototypes
public function boolean has_children ()
public function str_configuration_nodes get_children ()
end prototypes

public function boolean has_children ();return true
end function

public function str_configuration_nodes get_children ();str_configuration_nodes lstr_nodes


lstr_nodes.node_count = 0

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Workflow"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_workflow"
lstr_nodes.node[lstr_nodes.node_count].button = "button_workflow.bmp"
lstr_nodes.node[lstr_nodes.node_count].key = "" // No key needed

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Chart Service"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_chart_service"
lstr_nodes.node[lstr_nodes.node_count].button = "button17.bmp"
lstr_nodes.node[lstr_nodes.node_count].key = "" // No key needed

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Reports"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_service"
lstr_nodes.node[lstr_nodes.node_count].key = "CONFIG_REPORTS"
lstr_nodes.node[lstr_nodes.node_count].button = datalist.service_button(lstr_nodes.node[lstr_nodes.node_count].key)
f_attribute_add_attribute(lstr_nodes.node[lstr_nodes.node_count].attributes, "config_object_type", "Report")

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Decision Support"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_decision_support"
lstr_nodes.node[lstr_nodes.node_count].button = "button_decision_support.bmp"
lstr_nodes.node[lstr_nodes.node_count].key = "" // No key needed

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Alerts"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_alerts"
lstr_nodes.node[lstr_nodes.node_count].button = "button_exclam_red.bmp"
lstr_nodes.node[lstr_nodes.node_count].key = "" // No key needed

return lstr_nodes

end function

on u_configuration_node_configuration.create
call super::create
end on

on u_configuration_node_configuration.destroy
call super::destroy
end on

