$PBExportHeader$u_component_service_configuration.sru
forward
global type u_component_service_configuration from u_component_service
end type
end forward

global type u_component_service_configuration from u_component_service
end type
global u_component_service_configuration u_component_service_configuration

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

Integer    					li_return
str_popup_return popup_return
string ls_window_class

// Short circuit the vaccine configuration so V4 will still see the old screens

if upper(service) = "CONFIG_VACCINES_DISEASES" then
	add_attribute("window_class", "w_svc_config_drugs")
	add_attribute("drug_type", "Vaccine")
	add_attribute("common_flag", "N")
end if

ls_window_class = get_attribute("window_class")
if isnull(ls_window_class) then
	log.log(this, "u_component_service_configuration.xx_do_service.0028", "Unable to determine window class", 4)
	return -1
end if

Openwithparm(service_window, this, ls_window_class)

// Always return "I'm Finished" for configuration services
return 1

end function

on u_component_service_configuration.create
call super::create
end on

on u_component_service_configuration.destroy
call super::destroy
end on

