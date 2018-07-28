$PBExportHeader$u_configuration_node_interfaces.sru
forward
global type u_configuration_node_interfaces from u_configuration_node_base
end type
end forward

global type u_configuration_node_interfaces from u_configuration_node_base
end type
global u_configuration_node_interfaces u_configuration_node_interfaces

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
lstr_nodes.node[lstr_nodes.node_count].label = "Device Interfaces (External Sources)"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_service"
lstr_nodes.node[lstr_nodes.node_count].key = "CONFIG_SOURCES"
lstr_nodes.node[lstr_nodes.node_count].button = datalist.service_button(lstr_nodes.node[lstr_nodes.node_count].key)

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Practice Management"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_service"
lstr_nodes.node[lstr_nodes.node_count].key = "CONFIG_PRACTICEMGT"
lstr_nodes.node[lstr_nodes.node_count].button = datalist.service_button(lstr_nodes.node[lstr_nodes.node_count].key)

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Datafiles"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_service"
lstr_nodes.node[lstr_nodes.node_count].key = "CONFIG_REPORTS"
lstr_nodes.node[lstr_nodes.node_count].button = datalist.service_button(lstr_nodes.node[lstr_nodes.node_count].key)
f_attribute_add_attribute(lstr_nodes.node[lstr_nodes.node_count].attributes, "config_object_type", "Datafile")

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Document Purposes"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_document_purposes"
lstr_nodes.node[lstr_nodes.node_count].key = "" // No key needed
lstr_nodes.node[lstr_nodes.node_count].button = "button_doc_purpose.bmp"

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Installed Interfaces"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_installed_interfaces"
lstr_nodes.node[lstr_nodes.node_count].button = "button_interfaces_installed.bmp"
lstr_nodes.node[lstr_nodes.node_count].key = "" // No key needed

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Installable Interfaces"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_installable_interfaces"
lstr_nodes.node[lstr_nodes.node_count].button = "button_interfaces_installable.bmp"
lstr_nodes.node[lstr_nodes.node_count].key = "" // No key needed

return lstr_nodes

end function

public subroutine set_required_privilege ();required_privilege = "Edit System Config"

end subroutine

on u_configuration_node_interfaces.create
call super::create
end on

on u_configuration_node_interfaces.destroy
call super::destroy
end on

