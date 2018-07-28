$PBExportHeader$u_component_service_external_source.sru
forward
global type u_component_service_external_source from u_component_service
end type
end forward

global type u_component_service_external_source from u_component_service
end type
global u_component_service_external_source u_component_service_external_source

type variables

end variables

forward prototypes
public function integer xx_do_service ()
end prototypes

public function integer xx_do_service ();integer li_sts
w_svc_external_source lw_window

openwithparm(lw_window, this, "w_svc_external_source")
li_sts = message.doubleparm

//garbagecollect()

return li_sts

end function

on u_component_service_external_source.create
call super::create
end on

on u_component_service_external_source.destroy
call super::destroy
end on

