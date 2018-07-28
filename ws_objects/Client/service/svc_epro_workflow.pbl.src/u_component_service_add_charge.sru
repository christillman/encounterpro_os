$PBExportHeader$u_component_service_add_charge.sru
forward
global type u_component_service_add_charge from u_component_service
end type
end forward

global type u_component_service_add_charge from u_component_service
end type
global u_component_service_add_charge u_component_service_add_charge

forward prototypes
public function integer xx_do_service ()
end prototypes

public function integer xx_do_service ();long ll_sts
string ls_procedure_id


ls_procedure_id = get_attribute("charge_procedure_id")
if isnull(ls_procedure_id) then return 1

ll_sts = sqlca.sp_add_charge(cpr_id, &
										encounter_id, &
										ls_procedure_id, &
										problem_id, &
										treatment_id, &
										current_scribe.user_id)
if not tf_check() then return -1
if ll_sts < 0 then return -1


Return 1


end function

on u_component_service_add_charge.create
call super::create
end on

on u_component_service_add_charge.destroy
call super::destroy
end on

