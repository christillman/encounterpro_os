$PBExportHeader$u_configuration_node_document_purpose.sru
forward
global type u_configuration_node_document_purpose from u_configuration_node_base
end type
end forward

global type u_configuration_node_document_purpose from u_configuration_node_base
end type
global u_configuration_node_document_purpose u_configuration_node_document_purpose

forward prototypes
public function boolean has_children ()
public function str_configuration_nodes get_children ()
end prototypes

public function boolean has_children ();return true
end function

public function str_configuration_nodes get_children ();str_configuration_nodes lstr_nodes

lstr_nodes.node_count = 0

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Recipients"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_document_purpose_recipients"
lstr_nodes.node[lstr_nodes.node_count].key = node.key
lstr_nodes.node[lstr_nodes.node_count].button = "button_out_only.bmp"

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Workplans"
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_document_purpose_workplans"
lstr_nodes.node[lstr_nodes.node_count].key = node.key
lstr_nodes.node[lstr_nodes.node_count].button = "button_workflow.bmp"


return lstr_nodes

end function

on u_configuration_node_document_purpose.create
call super::create
end on

on u_configuration_node_document_purpose.destroy
call super::destroy
end on

