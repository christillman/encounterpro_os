$PBExportHeader$u_component_service_change_room.sru
forward
global type u_component_service_change_room from u_component_service
end type
end forward

global type u_component_service_change_room from u_component_service
integer max_retries = 5
boolean do_autoperform = true
end type
global u_component_service_change_room u_component_service_change_room

forward prototypes
public function integer xx_do_service ()
end prototypes

public function integer xx_do_service ();///////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description: Change the patient room from one to another
//
// Returns: 1 - Complete the Service 
//          2 - Cancel the Service
//          0 - No operation[Continue]
//         <0 - Failure
//
// Created By:Sumathi Chinnasamy										Creation dt: 08/07/01
//
// Modified By:															Modified On:
///////////////////////////////////////////////////////////////////////////////////////////////////////
String	ls_room_id
integer li_sts

if in_office_flag = "Y" then
	If isnull(current_patient.open_encounter) Then
		log.log(this, "u_component_service_change_room.xx_do_service:0019", "No current appointment", 3)
		Return 2
	End If
	
	ls_room_id = get_attribute("room_id")
	if isnull(ls_room_id) then
		ls_room_id = room_list.room_menu("!ALL")
		If isnull(ls_room_id) Then Return 2
	end if
	
	li_sts = current_patient.open_encounter.change_room(ls_room_id)
elseif patient_workplan_id > 0 then
	
else
	log.log(this, "u_component_service_change_room.xx_do_service:0033", "not-in-office service without a workplan cannot change rooms", 3)
	return 1
end if

Return 1

end function

on u_component_service_change_room.create
call super::create
end on

on u_component_service_change_room.destroy
call super::destroy
end on

