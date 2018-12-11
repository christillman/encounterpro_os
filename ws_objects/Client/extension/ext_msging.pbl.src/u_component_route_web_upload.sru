$PBExportHeader$u_component_route_web_upload.sru
forward
global type u_component_route_web_upload from u_component_route
end type
end forward

global type u_component_route_web_upload from u_component_route
end type
global u_component_route_web_upload u_component_route_web_upload

forward prototypes
protected function integer xx_send_document (u_component_wp_item_document puo_document)
end prototypes

protected function integer xx_send_document (u_component_wp_item_document puo_document);w_window_base lw_window
string ls_return

// This route is client only
if gnv_app.cpr_mode <> "CLIENT" then return 0

openwithparm(lw_window, puo_document, "w_route_web_upload")
ls_return = message.stringparm

if ls_return = "OK" then
	return 1
else
	return 0
end if



end function

on u_component_route_web_upload.create
call super::create
end on

on u_component_route_web_upload.destroy
call super::destroy
end on

