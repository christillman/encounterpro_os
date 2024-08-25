$PBExportHeader$u_component_service_chart.sru
forward
global type u_component_service_chart from u_component_service
end type
end forward

global type u_component_service_chart from u_component_service
end type
global u_component_service_chart u_component_service_chart

forward prototypes
public function integer xx_do_service ()
end prototypes

public function integer xx_do_service ();str_popup_return popup_return
string ls_returning_class

DO WHILE true
	openwithparm(service_window, this, "w_cpr_main")
	
	popup_return = f_popup_return("w_cpr_main,u_component_service_chart.xx_do_service:7")
	if popup_return.item_count <> 1 then return 0
	
	CHOOSE CASE upper(popup_return.items[1])
		CASE "CLOSE"
			return 1
		CASE "CANCEL"
			return 2
		CASE "ERROR"
			return -1
		CASE "TRY AGAIN"
			continue
		CASE ELSE
			return 0
	END CHOOSE
LOOP

end function

on u_component_service_chart.create
call super::create
end on

on u_component_service_chart.destroy
call super::destroy
end on

