HA$PBExportHeader$u_component_service_vitals.sru
forward
global type u_component_service_vitals from u_component_service
end type
end forward

global type u_component_service_vitals from u_component_service
end type
global u_component_service_vitals u_component_service_vitals

forward prototypes
public function integer xx_do_service ()
end prototypes

public function integer xx_do_service ();str_popup_return popup_return

openwithparm(service_window, this, "w_do_vitals")
popup_return = message.powerobjectparm

if popup_return.item_count <> 1 then return 0

if popup_return.items[1] = "CLOSE" then
	return 1
elseif popup_return.items[1] = "CANCEL" then
	return 2
else
	return 0
end if


end function

on u_component_service_vitals.create
call super::create
end on

on u_component_service_vitals.destroy
call super::destroy
end on

