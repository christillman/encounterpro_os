HA$PBExportHeader$u_configuration_node_document_purpose_workplans.sru
forward
global type u_configuration_node_document_purpose_workplans from u_configuration_node_base
end type
end forward

global type u_configuration_node_document_purpose_workplans from u_configuration_node_base
end type
global u_configuration_node_document_purpose_workplans u_configuration_node_document_purpose_workplans

forward prototypes
public function boolean has_children ()
public function str_configuration_nodes get_children ()
end prototypes

public function boolean has_children ();return true
end function

public function str_configuration_nodes get_children ();str_configuration_nodes lstr_nodes
long ll_count
long i
string ls_sql
long ll_new_object_workplan_id
long ll_existing_object_workplan_id
string ls_new_description
string ls_exists_description

SELECT p.new_object_workplan_id,   
         p.existing_object_workplan_id,   
         wp_new.description as new_description,   
         wp_exist.description as exists_description
INTO :ll_new_object_workplan_id, :ll_existing_object_workplan_id, :ls_new_description, :ls_exists_description
FROM c_Document_Purpose p
	LEFT OUTER JOIN c_Workplan wp_new 
	ON p.new_object_workplan_id = wp_new.workplan_id 
	LEFT OUTER JOIN c_Workplan wp_exist 
	ON p.existing_object_workplan_id = wp_exist.workplan_id
WHERE p.purpose = :node.key;

lstr_nodes.node_count = 0

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "New Object Workplan:  "
if len(ls_new_description) > 0 then
	lstr_nodes.node[lstr_nodes.node_count].label += ls_new_description
else
	lstr_nodes.node[lstr_nodes.node_count].label += "<None>"
end if
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_document_purpose_workplan"
if ll_new_object_workplan_id > 0 then
	lstr_nodes.node[lstr_nodes.node_count].key = "NEW|" + string(ll_new_object_workplan_id)
else
	lstr_nodes.node[lstr_nodes.node_count].key = "NEW|"
end if
lstr_nodes.node[lstr_nodes.node_count].button = "button_workflow.bmp"

lstr_nodes.node_count += 1
lstr_nodes.node[lstr_nodes.node_count].label = "Existing Object Workplan:  "
if len(ls_exists_description) > 0 then
	lstr_nodes.node[lstr_nodes.node_count].label += ls_exists_description
else
	lstr_nodes.node[lstr_nodes.node_count].label += "<None>"
end if
lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_document_purpose_workplan"
if ll_existing_object_workplan_id > 0 then
	lstr_nodes.node[lstr_nodes.node_count].key = "EXISTING|" + string(ll_existing_object_workplan_id)
else
	lstr_nodes.node[lstr_nodes.node_count].key = "EXISTING|"
end if
lstr_nodes.node[lstr_nodes.node_count].button = "button_workflow.bmp"


return lstr_nodes

end function

on u_configuration_node_document_purpose_workplans.create
call super::create
end on

on u_configuration_node_document_purpose_workplans.destroy
call super::destroy
end on

