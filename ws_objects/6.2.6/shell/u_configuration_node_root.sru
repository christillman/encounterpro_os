HA$PBExportHeader$u_configuration_node_root.sru
forward
global type u_configuration_node_root from u_configuration_node_base
end type
end forward

global type u_configuration_node_root from u_configuration_node_base
end type
global u_configuration_node_root u_configuration_node_root

forward prototypes
public function boolean has_children ()
public function str_configuration_nodes get_children ()
end prototypes

public function boolean has_children ();return true
end function

public function str_configuration_nodes get_children ();u_user luo_practice
str_configuration_nodes lstr_nodes


lstr_nodes.node_count = 0


if isnull(common_thread.practice_user_id) then
	log.log(this, "display_practice()", "NULL practice_user_id", 4)
	return lstr_nodes
end if

luo_practice = user_list.find_user(common_thread.practice_user_id)
if isnull(luo_practice) then
	log.log(this, "display_practice()", "practice_user_id not found (" + common_thread.practice_user_id + ")", 4)
	return lstr_nodes
end if

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Practice - " + luo_practice.user_full_name
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_practice"
lstr_nodes.node[lstr_nodes.node_count].button = "button_practice.gif"
lstr_nodes.node[lstr_nodes.node_count].key = common_thread.practice_user_id

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Content - Tables and Picklists"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_content"
lstr_nodes.node[lstr_nodes.node_count].button = "button_content.bmp"
lstr_nodes.node[lstr_nodes.node_count].key = "" // No key needed

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Workflow Components"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_workflow"
lstr_nodes.node[lstr_nodes.node_count].button = "button_workflow.bmp"
lstr_nodes.node[lstr_nodes.node_count].key = "" // No key needed

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Decision Support Components"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_decision_support"
lstr_nodes.node[lstr_nodes.node_count].button = "button_library.bmp"
lstr_nodes.node[lstr_nodes.node_count].key = "" // No key needed

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Alert Components"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_alerts"
lstr_nodes.node[lstr_nodes.node_count].button = "button_alerts.gif"
lstr_nodes.node[lstr_nodes.node_count].key = "" // No key needed

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Reports"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_service"
lstr_nodes.node[lstr_nodes.node_count].key = "CONFIG_REPORTS"
lstr_nodes.node[lstr_nodes.node_count].button = datalist.service_button(lstr_nodes.node[lstr_nodes.node_count].key)
f_attribute_add_attribute(lstr_nodes.node[lstr_nodes.node_count].attributes, "config_object_type", "Report")

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Interfaces"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_interfaces"
lstr_nodes.node[lstr_nodes.node_count].button = "button_interfaces.bmp"
lstr_nodes.node[lstr_nodes.node_count].key = "" // No key needed

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "System"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_system"
lstr_nodes.node[lstr_nodes.node_count].button = "button_system.gif"
lstr_nodes.node[lstr_nodes.node_count].key = "" // No key needed

return lstr_nodes

end function

on u_configuration_node_root.create
call super::create
end on

on u_configuration_node_root.destroy
call super::destroy
end on

