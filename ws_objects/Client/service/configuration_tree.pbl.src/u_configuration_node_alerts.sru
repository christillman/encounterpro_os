$PBExportHeader$u_configuration_node_alerts.sru
forward
global type u_configuration_node_alerts from u_configuration_node_base
end type
end forward

global type u_configuration_node_alerts from u_configuration_node_base
end type
global u_configuration_node_alerts u_configuration_node_alerts

forward prototypes
public function boolean has_children ()
public function str_configuration_nodes get_children ()
public subroutine set_required_privilege ()
end prototypes

public function boolean has_children ();return true
end function

public function str_configuration_nodes get_children ();str_configuration_nodes lstr_nodes

str_component_definition lstr_component_definition

lstr_nodes.node_count = 0

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Contraindication Alerts"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_alerts_contraindication"
lstr_nodes.node[lstr_nodes.node_count].key = ""
lstr_nodes.node[lstr_nodes.node_count].button = "button_alerts_contraindication.gif"

lstr_component_definition = f_get_component_definition(common_thread.chart_alert_component())

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Chart Alerts"
if len(lstr_component_definition.description) > 0 then
	lstr_nodes.node[lstr_nodes.node_count].label += " - " + lstr_component_definition.description
end if
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_alerts_chart"
lstr_nodes.node[lstr_nodes.node_count].key = lstr_component_definition.component_id
lstr_nodes.node[lstr_nodes.node_count].button = "button_alerts_chart.gif"


return lstr_nodes

end function

public subroutine set_required_privilege ();required_privilege = "Practice Configuration"
end subroutine

on u_configuration_node_alerts.create
call super::create
end on

on u_configuration_node_alerts.destroy
call super::destroy
end on

