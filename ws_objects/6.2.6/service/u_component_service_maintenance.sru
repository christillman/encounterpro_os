HA$PBExportHeader$u_component_service_maintenance.sru
forward
global type u_component_service_maintenance from u_component_service
end type
end forward

global type u_component_service_maintenance from u_component_service
end type
global u_component_service_maintenance u_component_service_maintenance

forward prototypes
public function integer xx_do_service ()
end prototypes

public function integer xx_do_service ();long ll_sts
string ls_rebuild_tables


ls_rebuild_tables = get_attribute("rebuild_tables")
if isnull(ls_rebuild_tables) then return 1



Return 1


end function

on u_component_service_maintenance.create
call super::create
end on

on u_component_service_maintenance.destroy
call super::destroy
end on

