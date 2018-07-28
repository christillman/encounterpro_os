$PBExportHeader$u_configuration_node_document_purposes.sru
forward
global type u_configuration_node_document_purposes from u_configuration_node_base
end type
end forward

global type u_configuration_node_document_purposes from u_configuration_node_base
end type
global u_configuration_node_document_purposes u_configuration_node_document_purposes

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

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_domain_notranslate_list")
ll_count = luo_data.retrieve("CONTEXT_OBJECT")

lstr_nodes.node_count = 0

for i = 1 to ll_count
	lstr_nodes.node_count += 1
	lstr_nodes.node[lstr_nodes.node_count].label = wordcap(luo_data.object.domain_item[i])
	lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_document_purpose_context"
	lstr_nodes.node[lstr_nodes.node_count].key = luo_data.object.domain_item[i]
	lstr_nodes.node[lstr_nodes.node_count].button = luo_data.object.domain_item_bitmap[i]
next

DESTROY luo_data

return lstr_nodes

end function

on u_configuration_node_document_purposes.create
call super::create
end on

on u_configuration_node_document_purposes.destroy
call super::destroy
end on

