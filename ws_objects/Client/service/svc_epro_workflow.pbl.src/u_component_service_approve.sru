$PBExportHeader$u_component_service_approve.sru
forward
global type u_component_service_approve from u_component_service
end type
end forward

global type u_component_service_approve from u_component_service
end type
global u_component_service_approve u_component_service_approve

forward prototypes
public function integer xx_do_service ()
end prototypes

public function integer xx_do_service ();str_popup_return popup_return

if isnull(encounter_id) then
	log.log(this, "u_component_service_approve.xx_do_service.0004", "No encounter context", 4)
	return -1
end if

openwithparm(service_window, this, "w_approve_encounter")
popup_return = message.powerobjectparm

if popup_return.item_count <> 1 then
	// If this is a manual service then just cancel it if the user didn't approve the encounter
	if manual_service then
		return 2
	else
		return 0
	end if
end if

if popup_return.items[1] = "COMPLETE" then
	current_patient.set_encounter_property( encounter_id, "approved_by", current_user.user_id)
	return 1
elseif popup_return.items[1] = "CANCEL" then
	return 2
else
	// If this is a manual service then just cancel it if the user didn't approve the encounter
	if manual_service then
		return 2
	else
		return 0
	end if
end if


end function

on u_component_service_approve.create
call super::create
end on

on u_component_service_approve.destroy
call super::destroy
end on

