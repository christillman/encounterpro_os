HA$PBExportHeader$u_component_service_review_activity.sru
forward
global type u_component_service_review_activity from u_component_service
end type
end forward

global type u_component_service_review_activity from u_component_service
end type
global u_component_service_review_activity u_component_service_review_activity

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

Openwithparm(service_window, this, "w_edit_activity")
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

if popup_return.items[1] = "OK" then
	current_patient.treatments.update_treatment(treatment)
//	treatment.save()
	Return 1
else
	Return 0
End If



end function

on u_component_service_review_activity.create
call super::create
end on

on u_component_service_review_activity.destroy
call super::destroy
end on

