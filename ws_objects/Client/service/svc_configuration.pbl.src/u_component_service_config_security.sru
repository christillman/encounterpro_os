$PBExportHeader$u_component_service_config_security.sru
forward
global type u_component_service_config_security from u_component_service
end type
end forward

global type u_component_service_config_security from u_component_service
end type
global u_component_service_config_security u_component_service_config_security

forward prototypes
public function integer xx_do_service ()
end prototypes

public function integer xx_do_service ();///////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description:If any changes made then update it. This always deals with only one treatment
//
// Returns: 1 - Complete the Service 
//          2 - Cancel the Service
//          0 - No operation[Continue]
//
// Created By:Sumathi Chinnasamy										Creation dt: 11/30/2000
//
// Modified By:															Modified On:
///////////////////////////////////////////////////////////////////////////////////////////////////////

Integer    					li_sts

li_sts = user_list.configure_security()

// Always return "I'm Finished" for configuration services
return 1

end function

on u_component_service_config_security.create
call super::create
end on

on u_component_service_config_security.destroy
call super::destroy
end on

