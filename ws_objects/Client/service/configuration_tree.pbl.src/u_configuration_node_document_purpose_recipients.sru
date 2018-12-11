$PBExportHeader$u_configuration_node_document_purpose_recipients.sru
forward
global type u_configuration_node_document_purpose_recipients from u_configuration_node_base
end type
end forward

global type u_configuration_node_document_purpose_recipients from u_configuration_node_base
end type
global u_configuration_node_document_purpose_recipients u_configuration_node_document_purpose_recipients

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
string ls_sql

luo_data = CREATE u_ds_data

ls_sql = "SELECT actor_class FROM c_Actor_Class_Purpose WHERE purpose = '" + node.key + "' AND status = 'OK' ORDER BY sort_sequence, actor_class"
ll_count = luo_data.load_query(ls_sql)

lstr_nodes.node_count = 0

for i = 1 to ll_count
	lstr_nodes.node_count += 1
	lstr_nodes.node[lstr_nodes.node_count].label = wordcap(luo_data.object.actor_class[i])
	lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_document_purpose_actor"
	lstr_nodes.node[lstr_nodes.node_count].key = luo_data.object.actor_class[i]
	lstr_nodes.node[lstr_nodes.node_count].button = "button_document_recipient.bmp"
next

DESTROY luo_data

return lstr_nodes

end function

on u_configuration_node_document_purpose_recipients.create
call super::create
end on

on u_configuration_node_document_purpose_recipients.destroy
call super::destroy
end on

