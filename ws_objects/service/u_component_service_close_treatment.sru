HA$PBExportHeader$u_component_service_close_treatment.sru
forward
global type u_component_service_close_treatment from u_component_service
end type
end forward

global type u_component_service_close_treatment from u_component_service
end type
global u_component_service_close_treatment u_component_service_close_treatment

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

string lsa_attributes[]
string lsa_values[]
integer li_count
str_popup_return        popup_return
str_popup					popup
string ls_window_class
integer li_sts

ls_window_class = "w_svc_treatment_close"

Openwithparm(service_window, this, ls_window_class, f_active_window())
if lower(classname(message.powerobjectparm)) = "str_popup_return" then
	popup_return = message.powerobjectparm
else
	log.log(this, "xx_do_service()", "Invalid class returned from service window (" + service + ", " + ls_window_class + ")", 4)
	return -1
end if

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

on u_component_service_close_treatment.create
call super::create
end on

on u_component_service_close_treatment.destroy
call super::destroy
end on

