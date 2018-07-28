$PBExportHeader$u_component_service_config_doc_purpose.sru
forward
global type u_component_service_config_doc_purpose from u_component_service
end type
end forward

global type u_component_service_config_doc_purpose from u_component_service
end type
global u_component_service_config_doc_purpose u_component_service_config_doc_purpose

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
string ls_window_class

ls_window_class = "w_svc_config_doc_purpose"

Openwithparm(service_window, this, ls_window_class)

// Always return "I'm Finished" for configuration services
return 1

end function

on u_component_service_config_doc_purpose.create
call super::create
end on

on u_component_service_config_doc_purpose.destroy
call super::destroy
end on

