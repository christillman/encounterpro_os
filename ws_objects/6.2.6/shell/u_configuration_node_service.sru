HA$PBExportHeader$u_configuration_node_service.sru
forward
global type u_configuration_node_service from u_configuration_node_base
end type
end forward

global type u_configuration_node_service from u_configuration_node_base
end type
global u_configuration_node_service u_configuration_node_service

forward prototypes
public function boolean has_children ()
public function integer activate ()
public subroutine set_required_privilege ()
end prototypes

public function boolean has_children ();return false
end function

public function integer activate ();str_service_info lstr_service

lstr_service.service = node.key
lstr_service.attributes = node.attributes
service_list.do_service(lstr_service)

return 1

end function

public subroutine set_required_privilege ();
CHOOSE CASE upper(node.key)
	CASE "CONFIG_USERS"
		// These services should be controlled by "Edit Users"
		required_privilege = "Edit Users"
	CASE ELSE
		// These services should default to the service specific authorization
		required_privilege = "!Service"
END CHOOSE



end subroutine

on u_configuration_node_service.create
call super::create
end on

on u_configuration_node_service.destroy
call super::destroy
end on

