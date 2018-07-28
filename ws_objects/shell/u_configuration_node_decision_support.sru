HA$PBExportHeader$u_configuration_node_decision_support.sru
forward
global type u_configuration_node_decision_support from u_configuration_node_base
end type
end forward

global type u_configuration_node_decision_support from u_configuration_node_base
end type
global u_configuration_node_decision_support u_configuration_node_decision_support

forward prototypes
public function boolean has_children ()
public function str_configuration_nodes get_children ()
public subroutine set_required_privilege ()
end prototypes

public function boolean has_children ();return true
end function

public function str_configuration_nodes get_children ();str_configuration_nodes lstr_nodes
str_config_object_info lstr_vaccine_schedule

lstr_nodes.node_count = 0

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Health Maintenance"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_service"
lstr_nodes.node[lstr_nodes.node_count].key = "CONFIG_HEALTH_MAINT"
lstr_nodes.node[lstr_nodes.node_count].button = datalist.service_button(lstr_nodes.node[lstr_nodes.node_count].key)

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "E & M Coding"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_service"
lstr_nodes.node[lstr_nodes.node_count].key = "CONFIG_EM"
lstr_nodes.node[lstr_nodes.node_count].button = datalist.service_button(lstr_nodes.node[lstr_nodes.node_count].key)

lstr_vaccine_schedule = common_thread.vaccine_schedule()

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Vaccine Schedule"
if lstr_vaccine_schedule.installed_version >= 0 then
	lstr_nodes.node[lstr_nodes.node_count].label += " - " + lstr_vaccine_schedule.description + ", v." + string(lstr_vaccine_schedule.installed_version)
end if

lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_vaccine_schedule"
lstr_nodes.node[lstr_nodes.node_count].key = ""
lstr_nodes.node[lstr_nodes.node_count].button = "button_vaccine_schedule.bmp"

return lstr_nodes

end function

public subroutine set_required_privilege ();required_privilege = "Practice Configuration"
end subroutine

on u_configuration_node_decision_support.create
call super::create
end on

on u_configuration_node_decision_support.destroy
call super::destroy
end on

