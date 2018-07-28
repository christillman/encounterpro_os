HA$PBExportHeader$u_configuration_node_content.sru
forward
global type u_configuration_node_content from u_configuration_node_base
end type
end forward

global type u_configuration_node_content from u_configuration_node_base
end type
global u_configuration_node_content u_configuration_node_content

forward prototypes
public function boolean has_children ()
public function str_configuration_nodes get_children ()
end prototypes

public function boolean has_children ();return true
end function

public function str_configuration_nodes get_children ();str_configuration_nodes lstr_nodes


lstr_nodes.node_count = 0

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Consultants"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_service"
lstr_nodes.node[lstr_nodes.node_count].key = "CONFIG_SPECIALTIES_CONS"
lstr_nodes.node[lstr_nodes.node_count].button = datalist.service_button(lstr_nodes.node[lstr_nodes.node_count].key)

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Diagnoses"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_service"
lstr_nodes.node[lstr_nodes.node_count].key = "CONFIG_ASSESSMENTS"
lstr_nodes.node[lstr_nodes.node_count].button = datalist.service_button(lstr_nodes.node[lstr_nodes.node_count].key)

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Drugs"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_service"
lstr_nodes.node[lstr_nodes.node_count].key = "CONFIG_DRUGS"
lstr_nodes.node[lstr_nodes.node_count].button = datalist.service_button(lstr_nodes.node[lstr_nodes.node_count].key)

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Observations"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_service"
lstr_nodes.node[lstr_nodes.node_count].key = "CONFIG_OBSERVATIONS"
lstr_nodes.node[lstr_nodes.node_count].button = datalist.service_button(lstr_nodes.node[lstr_nodes.node_count].key)

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Patient Materials"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_service"
lstr_nodes.node[lstr_nodes.node_count].key = "CONFIG_PATIENT_MTRL"
lstr_nodes.node[lstr_nodes.node_count].button = datalist.service_button(lstr_nodes.node[lstr_nodes.node_count].key)

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Payers"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_service"
lstr_nodes.node[lstr_nodes.node_count].key = "CONFIG_INSURANCE_CARRIER"
lstr_nodes.node[lstr_nodes.node_count].button = datalist.service_button(lstr_nodes.node[lstr_nodes.node_count].key)

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Procedures"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_service"
lstr_nodes.node[lstr_nodes.node_count].key = "CONFIG_PROCEDURES"
lstr_nodes.node[lstr_nodes.node_count].button = datalist.service_button(lstr_nodes.node[lstr_nodes.node_count].key)

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Vaccines"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_service"
lstr_nodes.node[lstr_nodes.node_count].key = "CONFIG_VACCINES_DISEASES"
lstr_nodes.node[lstr_nodes.node_count].button = datalist.service_button(lstr_nodes.node[lstr_nodes.node_count].key)


return lstr_nodes

end function

on u_configuration_node_content.create
call super::create
end on

on u_configuration_node_content.destroy
call super::destroy
end on

