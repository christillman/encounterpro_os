HA$PBExportHeader$u_component_service_browser.sru
forward
global type u_component_service_browser from u_component_service
end type
end forward

global type u_component_service_browser from u_component_service
end type
global u_component_service_browser u_component_service_browser

forward prototypes
public function integer xx_do_service ()
end prototypes

public function integer xx_do_service ();str_popup_return popup_return

Openwithparm(service_window, this, "w_svc_web")
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

on u_component_service_browser.create
call super::create
end on

on u_component_service_browser.destroy
call super::destroy
end on

