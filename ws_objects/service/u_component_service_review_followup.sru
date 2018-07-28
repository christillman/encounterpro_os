HA$PBExportHeader$u_component_service_review_followup.sru
forward
global type u_component_service_review_followup from u_component_service
end type
end forward

global type u_component_service_review_followup from u_component_service
end type
global u_component_service_review_followup u_component_service_review_followup

forward prototypes
public function integer xx_do_service ()
end prototypes

public function integer xx_do_service ();// Date Begun: ??/??/??
// Programmer: Mark Copenhaver (MC)
//
// Purpose: 
// Expects: 
//
// Returns: integer 									
// Limits:	
// History: 

str_popup_return        popup_return

Openwithparm(service_window, this, "w_followup")
popup_return = message.powerobjectparm

if popup_return.item_count <> 1 then return 0

if (popup_return.items[1] = "COMPLETE") or (popup_return.items[1] = "OK") then
	return 1
elseif popup_return.items[1] = "CANCEL" then
	return 2
else
	return 0
end if

end function

on u_component_service_review_followup.create
call super::create
end on

on u_component_service_review_followup.destroy
call super::destroy
end on

