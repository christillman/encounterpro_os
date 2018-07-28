$PBExportHeader$u_component_service_new_refill_request.sru
forward
global type u_component_service_new_refill_request from u_component_service_get_refills
end type
end forward

global type u_component_service_new_refill_request from u_component_service_get_refills
end type
global u_component_service_new_refill_request u_component_service_new_refill_request

on u_component_service_new_refill_request.create
call super::create
end on

on u_component_service_new_refill_request.destroy
call super::destroy
end on

