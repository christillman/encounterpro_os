$PBExportHeader$u_configuration_node_chart_pages.sru
forward
global type u_configuration_node_chart_pages from u_configuration_node_base
end type
end forward

global type u_configuration_node_chart_pages from u_configuration_node_base
end type
global u_configuration_node_chart_pages u_configuration_node_chart_pages

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

luo_data.settransobject(sqlca)
ll_count = luo_data.load_query( "SELECT page_class, description, bitmap FROM c_Chart_Page_Definition WHERE status = 'OK' ORDER BY description")

lstr_nodes.node_count = 0

for i = 1 to ll_count
	lstr_nodes.node_count += 1
	lstr_nodes.node[lstr_nodes.node_count].label = luo_data.object.description[i]
	lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_chart_page"
	lstr_nodes.node[lstr_nodes.node_count].key = luo_data.object.page_class[i]
	lstr_nodes.node[lstr_nodes.node_count].button = luo_data.object.bitmap[i]
next

return lstr_nodes

end function

on u_configuration_node_chart_pages.create
call super::create
end on

on u_configuration_node_chart_pages.destroy
call super::destroy
end on

