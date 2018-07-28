HA$PBExportHeader$u_component_service_procedure.sru
forward
global type u_component_service_procedure from u_component_service
end type
end forward

global type u_component_service_procedure from u_component_service
end type
global u_component_service_procedure u_component_service_procedure

forward prototypes
public function integer xx_do_service ()
end prototypes

public function integer xx_do_service ();str_popup_return popup_return

Openwithparm(service_window, this, "w_do_procedure")
popup_return = message.powerobjectparm
If popup_return.item_count <> 1 Then Return 0

If upper(popup_return.items[1]) = "CLOSE" or upper(popup_return.items[1]) = "OK" Then
	Return 1
Elseif popup_return.items[1] = "CANCEL" Then
	Return 2
Else
	Return 0
End if


end function

on u_component_service_procedure.create
call super::create
end on

on u_component_service_procedure.destroy
call super::destroy
end on

