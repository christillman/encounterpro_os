HA$PBExportHeader$u_configuration_node_workflow.sru
forward
global type u_configuration_node_workflow from u_configuration_node_base
end type
end forward

global type u_configuration_node_workflow from u_configuration_node_base
end type
global u_configuration_node_workflow u_configuration_node_workflow

forward prototypes
public function boolean has_children ()
public function str_configuration_nodes get_children ()
public subroutine set_required_privilege ()
end prototypes

public function boolean has_children ();return true
end function

public function str_configuration_nodes get_children ();str_configuration_nodes lstr_nodes


lstr_nodes.node_count = 0

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Services"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_service"
lstr_nodes.node[lstr_nodes.node_count].key = "CONFIG_SERVICE"
lstr_nodes.node[lstr_nodes.node_count].button = datalist.service_button(lstr_nodes.node[lstr_nodes.node_count].key)

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Encounter Types"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_service"
lstr_nodes.node[lstr_nodes.node_count].key = "CONFIG_ENCOUNTER_TYPES"
lstr_nodes.node[lstr_nodes.node_count].button = datalist.service_button(lstr_nodes.node[lstr_nodes.node_count].key)

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Treatment Types"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_service"
lstr_nodes.node[lstr_nodes.node_count].key = "CONFIG_TREATMENT_TYPES"
lstr_nodes.node[lstr_nodes.node_count].button = datalist.service_button(lstr_nodes.node[lstr_nodes.node_count].key)

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Chart Service Configuration"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_chart_service"
lstr_nodes.node[lstr_nodes.node_count].button = "button17.bmp"
lstr_nodes.node[lstr_nodes.node_count].key = "" // No key needed

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Datawindows"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_service"
lstr_nodes.node[lstr_nodes.node_count].key = "CONFIG_REPORTS"
lstr_nodes.node[lstr_nodes.node_count].button = "button_datawindow.gif"
f_attribute_add_attribute(lstr_nodes.node[lstr_nodes.node_count].attributes, "config_object_type", "Datawindow")

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Controllers"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_service"
lstr_nodes.node[lstr_nodes.node_count].key = "CONFIG_REPORTS"
lstr_nodes.node[lstr_nodes.node_count].button = "button_controller.gif"
f_attribute_add_attribute(lstr_nodes.node[lstr_nodes.node_count].attributes, "config_object_type", "Controller")


return lstr_nodes

end function

public subroutine set_required_privilege ();required_privilege = "Practice Configuration"
end subroutine

on u_configuration_node_workflow.create
call super::create
end on

on u_configuration_node_workflow.destroy
call super::destroy
end on

