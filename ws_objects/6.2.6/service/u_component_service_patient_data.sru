HA$PBExportHeader$u_component_service_patient_data.sru
forward
global type u_component_service_patient_data from u_component_service
end type
end forward

global type u_component_service_patient_data from u_component_service
end type
global u_component_service_patient_data u_component_service_patient_data

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

Openwithparm(service_window, this, "w_patient_data")
popup_return = message.powerobjectparm

if popup_return.item_count <> 1 then return 0

if (popup_return.items[1] = "COMPLETE") or (popup_return.items[1] = "OK") then
	return 1
elseif popup_return.items[1] = "CANCEL" then
	return 2
elseif popup_return.items[1] = "DOLATER" then
	return 3
elseif popup_return.items[1] = "REVERT" then
	return 4
elseif popup_return.items[1] = "ERROR" then
	return -1
else
	return 0
end if

end function

on u_component_service_patient_data.create
call super::create
end on

on u_component_service_patient_data.destroy
call super::destroy
end on

