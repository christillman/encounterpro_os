HA$PBExportHeader$u_component_service_patient_msg.sru
forward
global type u_component_service_patient_msg from u_component_service
end type
end forward

global type u_component_service_patient_msg from u_component_service
end type
global u_component_service_patient_msg u_component_service_patient_msg

forward prototypes
public function integer xx_do_service ()
end prototypes

public function integer xx_do_service ();str_popup			popup

popup.data_row_count = 1
popup.items[1] = current_patient.cpr_id
Openwithparm(service_window, popup, "w_patient_messages")

Return 1


end function

on u_component_service_patient_msg.create
call super::create
end on

on u_component_service_patient_msg.destroy
call super::destroy
end on

