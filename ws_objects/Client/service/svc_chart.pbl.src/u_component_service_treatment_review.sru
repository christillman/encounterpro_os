$PBExportHeader$u_component_service_treatment_review.sru
forward
global type u_component_service_treatment_review from u_component_service
end type
end forward

global type u_component_service_treatment_review from u_component_service
end type
global u_component_service_treatment_review u_component_service_treatment_review

forward prototypes
public function integer xx_do_service ()
end prototypes

public function integer xx_do_service ();str_popup_return popup_return

if isnull(treatment) then
	mylog.log(this, "u_component_service_treatment_review.xx_do_service:0004", "Null treatment object", 4)
	return -1
end if

openwithparm(service_window, this, "w_do_treatment")
popup_return = message.powerobjectparm

if popup_return.item_count <> 1 then return 0

if popup_return.items[1] = "CLOSE" OR popup_return.items[1] = "OK" then
	return 1
elseif popup_return.items[1] = "CANCEL" then
	return 2
else
	return 0
end if


end function

on u_component_service_treatment_review.create
call super::create
end on

on u_component_service_treatment_review.destroy
call super::destroy
end on

