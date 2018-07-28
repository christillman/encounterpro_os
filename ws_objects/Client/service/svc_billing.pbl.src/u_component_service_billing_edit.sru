$PBExportHeader$u_component_service_billing_edit.sru
forward
global type u_component_service_billing_edit from u_component_service
end type
end forward

global type u_component_service_billing_edit from u_component_service
end type
global u_component_service_billing_edit u_component_service_billing_edit

forward prototypes
public function integer xx_do_service ()
end prototypes

public function integer xx_do_service ();str_popup		popup

popup.objectparm = current_patient.open_encounter
Openwithparm(service_window, popup, "w_billing_edit")
Return 1
end function

on u_component_service_billing_edit.create
call super::create
end on

on u_component_service_billing_edit.destroy
call super::destroy
end on

