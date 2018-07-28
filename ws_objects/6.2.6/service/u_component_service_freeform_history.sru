HA$PBExportHeader$u_component_service_freeform_history.sru
forward
global type u_component_service_freeform_history from u_component_service
end type
end forward

global type u_component_service_freeform_history from u_component_service
end type
global u_component_service_freeform_history u_component_service_freeform_history

forward prototypes
public function integer xx_do_service ()
end prototypes

public function integer xx_do_service ();str_popup_return popup_return

Openwithparm(service_window, this, "w_freeform_history", f_active_window())
popup_return = Message.Powerobjectparm
If popup_return.item_count <> 1 Then Return 0

If popup_return.items[1] = "CLOSE" Then
	Return 1
ElseIf popup_return.items[1] = "CANCEL" Then
	Return 2
Else
	Return 0
End If
end function

on u_component_service_freeform_history.create
call super::create
end on

on u_component_service_freeform_history.destroy
call super::destroy
end on

