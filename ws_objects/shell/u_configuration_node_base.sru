HA$PBExportHeader$u_configuration_node_base.sru
forward
global type u_configuration_node_base from nonvisualobject
end type
end forward

global type u_configuration_node_base from nonvisualobject
end type
global u_configuration_node_base u_configuration_node_base

type variables
str_configuration_node node

u_configuration_node_base parent_configuration_node

string required_privilege
end variables

forward prototypes
public function boolean has_children ()
public function str_configuration_nodes get_children ()
public function integer activate ()
public subroutine refresh_label ()
public function boolean is_authorized ()
public subroutine set_required_privilege ()
end prototypes

public function boolean has_children ();return false

end function

public function str_configuration_nodes get_children ();str_configuration_nodes lstr_configuration_nodes

lstr_configuration_nodes.node_count = 0


return lstr_configuration_nodes

end function

public function integer activate ();
openwithparm(w_pop_message, "This node has no configuration options")

return 0

end function

public subroutine refresh_label ();

return

end subroutine

public function boolean is_authorized ();
if upper(required_privilege) = "!SERVICE" then
	// Treat the node.key as a service and test the authorization
	return user_list.is_user_authorized(current_user.user_id, node.key, "General")
elseif len(required_privilege) > 0 then
	return user_list.is_user_privileged(current_user.user_id, required_privilege)
end if

// If no required privilege then access is granted
return true


end function

public subroutine set_required_privilege ();
// The default required privilege is the parent node's required privilege
if isnull(required_privilege) or trim(required_privilege) = "" then required_privilege = parent_configuration_node.required_privilege





end subroutine

on u_configuration_node_base.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_configuration_node_base.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

