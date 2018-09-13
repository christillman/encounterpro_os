$PBExportHeader$u_configuration_node_installable_interfaces.sru
forward
global type u_configuration_node_installable_interfaces from u_configuration_node_base
end type
end forward

global type u_configuration_node_installable_interfaces from u_configuration_node_base
end type
global u_configuration_node_installable_interfaces u_configuration_node_installable_interfaces

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

//luo_data = CREATE u_ds_data
//luo_data.set_dataobject("dw_document_purposes_for_context")
//ll_count = luo_data.retrieve(node.key)
//
//lstr_nodes.node_count = 0
//
//for i = 1 to ll_count
//	lstr_nodes.node_count += 1
//	lstr_nodes.node[lstr_nodes.node_count].label = luo_data.object.purpose[i]
//	lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_document_purpose"
//	lstr_nodes.node[lstr_nodes.node_count].key = luo_data.object.purpose[i]
//	lstr_nodes.node[lstr_nodes.node_count].button = "button_changepurpose.bmp"
//next
//
//DESTROY luo_data

return lstr_nodes

end function

on u_configuration_node_installable_interfaces.create
call super::create
end on

on u_configuration_node_installable_interfaces.destroy
call super::destroy
end on

