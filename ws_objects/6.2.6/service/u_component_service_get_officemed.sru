HA$PBExportHeader$u_component_service_get_officemed.sru
forward
global type u_component_service_get_officemed from u_component_service
end type
end forward

global type u_component_service_get_officemed from u_component_service
end type
global u_component_service_get_officemed u_component_service_get_officemed

type variables

end variables

forward prototypes
public function integer xx_do_service ()
end prototypes

public function integer xx_do_service ();/////////////////////////////////////////////////////////////////////////////////////////////////////////
////
//// Description:If any changes made then update it.
////
//// Returns: 1 - Complete the Service 
////          2 - Cancel the Service
////          0 - No operation[Continue]
////
//// Created By:Sumathi Chinnasamy										Creation dt: 11/24/2000
////
//// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////////////////////////
//Integer    					li_return
//
//
//// Call this window to get additional information
//Openwithparm(w_office_drug_treatment, this)
////if treatment.treatment_count <= 0 then return 0
//
//// We know that w_office_drug_treatment will only put one treatment_definition
//li_return = treatment.treatment_definition[1].attribute_count
//If li_return > 0 Then
//	treatment.update(treatment.treatment_definition[1].attribute,&
//						treatment.treatment_definition[1].value)
//	Return 1
//ElseIf li_return < 0 Then // Error Or Cancel
////	treatment.delete_item()
//	Return 2
//Else
//	Return 0
//End If
str_popup_return popup_return

openwithparm(service_window, this, "w_office_drug_treatment")
popup_return = message.powerobjectparm

if popup_return.item_count <> 1 then return 0

if popup_return.items[1] = "OK" then
	return 1
elseif popup_return.items[1] = "CANCEL" then
	return 2
else
	return 0
end if


end function

on u_component_service_get_officemed.create
call super::create
end on

on u_component_service_get_officemed.destroy
call super::destroy
end on

