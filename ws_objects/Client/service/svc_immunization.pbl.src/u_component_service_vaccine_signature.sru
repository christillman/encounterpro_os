$PBExportHeader$u_component_service_vaccine_signature.sru
forward
global type u_component_service_vaccine_signature from u_component_service
end type
end forward

global type u_component_service_vaccine_signature from u_component_service
end type
global u_component_service_vaccine_signature u_component_service_vaccine_signature

forward prototypes
public function integer xx_do_service ()
end prototypes

public function integer xx_do_service ();String				ls_item
str_popup_return	popup_return

Openwithparm(service_window, this, "w_vaccine_signature")
popup_return = message.powerobjectparm
If popup_return.item_count > 0 Then
	ls_item = popup_return.items[1]
	If ls_item = "ACCEPTNOSIG" Or ls_item = "ACCEPT" then // Complete the treatment
		Return 1
	End If
End If
Return 0
end function

on u_component_service_vaccine_signature.create
call super::create
end on

on u_component_service_vaccine_signature.destroy
call super::destroy
end on

