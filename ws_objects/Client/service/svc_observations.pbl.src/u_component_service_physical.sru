$PBExportHeader$u_component_service_physical.sru
forward
global type u_component_service_physical from u_component_service
end type
end forward

global type u_component_service_physical from u_component_service
end type
global u_component_service_physical u_component_service_physical

forward prototypes
public function integer xx_do_service ()
end prototypes

public function integer xx_do_service ();str_popup_return popup_return

openwithparm(service_window, this, "w_physical_exam")
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

on u_component_service_physical.create
call super::create
end on

on u_component_service_physical.destroy
call super::destroy
end on

