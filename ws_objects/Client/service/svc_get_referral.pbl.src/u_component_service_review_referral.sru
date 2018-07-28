$PBExportHeader$u_component_service_review_referral.sru
forward
global type u_component_service_review_referral from u_component_service
end type
end forward

global type u_component_service_review_referral from u_component_service
end type
global u_component_service_review_referral u_component_service_review_referral

forward prototypes
public function integer xx_do_service ()
end prototypes

public function integer xx_do_service ();str_popup_return        popup_return

Openwithparm(service_window, this, "w_referral")
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

on u_component_service_review_referral.create
call super::create
end on

on u_component_service_review_referral.destroy
call super::destroy
end on

