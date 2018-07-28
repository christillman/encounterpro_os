HA$PBExportHeader$u_component_service_patient_workplan.sru
forward
global type u_component_service_patient_workplan from u_component_service
end type
end forward

global type u_component_service_patient_workplan from u_component_service
end type
global u_component_service_patient_workplan u_component_service_patient_workplan

forward prototypes
public function integer xx_do_service ()
end prototypes

public function integer xx_do_service ();str_popup_return popup_return

openwithparm(service_window, this, "w_svc_patient_workplan")
//openwithparm(service_window, this, "w_svc_patient_object_workplan")
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

on u_component_service_patient_workplan.create
call super::create
end on

on u_component_service_patient_workplan.destroy
call super::destroy
end on

