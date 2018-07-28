HA$PBExportHeader$u_component_service_history_display.sru
forward
global type u_component_service_history_display from u_component_service
end type
end forward

global type u_component_service_history_display from u_component_service
end type
global u_component_service_history_display u_component_service_history_display

forward prototypes
public function integer xx_do_service ()
end prototypes

public function integer xx_do_service ();///////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description:If any changes made then update it.
//
// Returns: 1 - Complete the Service 
//          2 - Cancel the Service
//          0 - No operation[Continue]
//         <0 - Failure
//
// Created By:Sumathi Chinnasamy										Creation dt: 08/03/01
//
// Modified By:															Modified On:
///////////////////////////////////////////////////////////////////////////////////////////////////////

str_popup_return        popup_return
str_popup					popup

Openwithparm(service_window, this, "w_svc_history_display")
popup_return = message.powerobjectparm

if popup_return.item_count <> 1 then return 0

if popup_return.items[1] = "COMPLETE" then
	return 1
elseif popup_return.items[1] = "CANCEL" then
	return 2
else
	return 0
end if


end function

on u_component_service_history_display.create
call super::create
end on

on u_component_service_history_display.destroy
call super::destroy
end on

