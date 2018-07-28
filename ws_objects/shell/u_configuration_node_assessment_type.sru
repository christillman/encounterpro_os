HA$PBExportHeader$u_configuration_node_assessment_type.sru
forward
global type u_configuration_node_assessment_type from u_configuration_node_base
end type
end forward

global type u_configuration_node_assessment_type from u_configuration_node_base
end type
global u_configuration_node_assessment_type u_configuration_node_assessment_type

forward prototypes
public function boolean has_children ()
public function integer activate ()
end prototypes

public function boolean has_children ();return false
end function

public function integer activate ();openwithparm(w_assessment_type_definition, node.key)

return 1

end function

on u_configuration_node_assessment_type.create
call super::create
end on

on u_configuration_node_assessment_type.destroy
call super::destroy
end on

