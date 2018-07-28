$PBExportHeader$u_component_service_alert.sru
forward
global type u_component_service_alert from u_component_service
end type
end forward

global type u_component_service_alert from u_component_service
end type
global u_component_service_alert u_component_service_alert

forward prototypes
public function integer xx_do_service ()
end prototypes

public function integer xx_do_service ();u_component_alert		luo_alert
string ls_temp

boolean lb_always_show

get_attribute("always_show", lb_always_show, true)

luo_alert = component_manager.get_component(common_thread.chart_alert_component())

if lb_always_show then
	luo_alert.alert(current_patient.cpr_id,current_patient.open_encounter_id,"EDITALERTS")
else
	luo_alert.alert(current_patient.cpr_id,current_patient.open_encounter_id,"ALERT")
end if


component_manager.destroy_component(luo_alert)

Return 1
end function

on u_component_service_alert.create
call super::create
end on

on u_component_service_alert.destroy
call super::destroy
end on

