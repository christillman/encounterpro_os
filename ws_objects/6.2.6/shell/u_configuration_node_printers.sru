HA$PBExportHeader$u_configuration_node_printers.sru
forward
global type u_configuration_node_printers from u_configuration_node_base
end type
end forward

global type u_configuration_node_printers from u_configuration_node_base
end type
global u_configuration_node_printers u_configuration_node_printers

forward prototypes
public function boolean has_children ()
public function str_configuration_nodes get_children ()
public function integer activate ()
end prototypes

public function boolean has_children ();u_ds_data luo_data
long ll_count

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_server_printers_small")
ll_count = luo_data.retrieve(node.key)

if ll_count > 0 then
	return true
else
	return false
end if


end function

public function str_configuration_nodes get_children ();str_configuration_nodes lstr_nodes
u_ds_data luo_data
long ll_count
long i
string ls_fax_flag

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_server_printers_small")
ll_count = luo_data.retrieve(node.key)

lstr_nodes.node_count = 0

for i = 1 to ll_count
	ls_fax_flag = luo_data.object.fax_flag[i]
	
	lstr_nodes.node_count += 1
	lstr_nodes.node[lstr_nodes.node_count].label = luo_data.object.display_name[i]
	if upper(ls_fax_flag) = "Y" then
		lstr_nodes.node[lstr_nodes.node_count].button = "button_fax.bmp"
		lstr_nodes.node[lstr_nodes.node_count].label += "  (Fax)"
	else
		lstr_nodes.node[lstr_nodes.node_count].button = "button_print.bmp"
	end if
	lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_printer"
	lstr_nodes.node[lstr_nodes.node_count].key = luo_data.object.printer[i]
next

DESTROY luo_data

return lstr_nodes

end function

public function integer activate ();open(w_configure_printers)

return 2

end function

on u_configuration_node_printers.create
call super::create
end on

on u_configuration_node_printers.destroy
call super::destroy
end on

