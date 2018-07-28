$PBExportHeader$u_component_service_utility.sru
forward
global type u_component_service_utility from u_component_service
end type
end forward

global type u_component_service_utility from u_component_service
end type
global u_component_service_utility u_component_service_utility

forward prototypes
public function integer xx_do_service ()
end prototypes

public function integer xx_do_service ();///////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description:opens the respective utility window
//
// Returns: 1 - Complete the Service 
//          2 - Cancel the Service
//          0 - No operation[Continue]
//
// Created By:Sumathi Chinnasamy										Creation dt: 08/14/2001
//
// Modified By:															Modified On:
///////////////////////////////////////////////////////////////////////////////////////////////////////

string ls_window_class

ls_window_class = get_attribute("window_class")
if isnull(ls_window_class) then
	log.log(this, "xx_do_service()", "Unable to determine window class", 4)
	return -1
end if

Openwithparm(service_window, this, ls_window_class)

// Always return "I'm Finished" for configuration services
return 1

end function

on u_component_service_utility.create
call super::create
end on

on u_component_service_utility.destroy
call super::destroy
end on

