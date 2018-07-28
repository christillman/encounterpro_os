$PBExportHeader$u_configuration_node_component_types.sru
forward
global type u_configuration_node_component_types from u_configuration_node_base
end type
end forward

global type u_configuration_node_component_types from u_configuration_node_base
end type
global u_configuration_node_component_types u_configuration_node_component_types

forward prototypes
public function boolean has_children ()
public function str_configuration_nodes get_children ()
end prototypes

public function boolean has_children ();return true
end function

public function str_configuration_nodes get_children ();str_configuration_nodes lstr_nodes
u_ds_data luo_data
long ll_count
long i
long ll_attachment_location_id
string ls_component_type
string ls_description

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_c_component_type_pick_list")
ll_count = luo_data.retrieve()

lstr_nodes.node_count = 0

for i = 1 to ll_count
	ls_component_type = luo_data.object.component_type[i]
	ls_description = luo_data.object.description[i]
	
	lstr_nodes.node_count += 1
	lstr_nodes.node[lstr_nodes.node_count].label = ls_description
	lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_component_type"
	lstr_nodes.node[lstr_nodes.node_count].key = ls_component_type
	lstr_nodes.node[lstr_nodes.node_count].button = "button_component_type-" + ls_component_type + ".gif"
next


DESTROY luo_data

return lstr_nodes

end function

on u_configuration_node_component_types.create
call super::create
end on

on u_configuration_node_component_types.destroy
call super::destroy
end on

