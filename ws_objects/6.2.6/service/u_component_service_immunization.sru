HA$PBExportHeader$u_component_service_immunization.sru
forward
global type u_component_service_immunization from u_component_service
end type
end forward

global type u_component_service_immunization from u_component_service
end type
global u_component_service_immunization u_component_service_immunization

forward prototypes
public function integer xx_do_service ()
end prototypes

public function integer xx_do_service ();//////////////////////////////////////////////////////////////////////////////////////
//
// Description:Close or cancel the service
//
// Returns: 1 - Close and complete the service
//          2 - Cancel the service
//          0 - No Operation
//
// Created By:Sumathi Chinnasamy										Creation dt: 05/10/2000
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////

str_popup_return	popup_return

Openwithparm(service_window, this, "w_do_immunization")
popup_return = Message.powerobjectparm
If popup_return.item_count <> 1 Then Return 0

If popup_return.items[1] = "CLOSE" Then
	Return 1
Elseif popup_return.items[1] = "CANCEL" Then
	Return 2
Else
	Return 0
End if



end function

on u_component_service_immunization.create
call super::create
end on

on u_component_service_immunization.destroy
call super::destroy
end on

