$PBExportHeader$u_configuration_node_chart_page.sru
forward
global type u_configuration_node_chart_page from u_configuration_node_base
end type
end forward

global type u_configuration_node_chart_page from u_configuration_node_base
end type
global u_configuration_node_chart_page u_configuration_node_chart_page

forward prototypes
public function boolean has_children ()
public function integer activate ()
end prototypes

public function boolean has_children ();return false
end function

public function integer activate ();f_configure_chart_page_definition(node.key)

return 1

end function

on u_configuration_node_chart_page.create
call super::create
end on

on u_configuration_node_chart_page.destroy
call super::destroy
end on

