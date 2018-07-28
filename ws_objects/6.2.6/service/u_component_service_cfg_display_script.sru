HA$PBExportHeader$u_component_service_cfg_display_script.sru
forward
global type u_component_service_cfg_display_script from u_component_service
end type
end forward

global type u_component_service_cfg_display_script from u_component_service
end type
global u_component_service_cfg_display_script u_component_service_cfg_display_script

forward prototypes
public function integer xx_do_service ()
end prototypes

public function integer xx_do_service ();///////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description:If any changes made then update it. This always deals with only one treatment
//
// Returns: 1 - Complete the Service 
//          2 - Cancel the Service
//          0 - No operation[Continue]
//
// Created By:Sumathi Chinnasamy										Creation dt: 11/30/2000
//
// Modified By:															Modified On:
///////////////////////////////////////////////////////////////////////////////////////////////////////

Integer    					li_return
str_popup popup
str_popup_return popup_return
long ll_display_script_id
string ls_script_type

get_attribute("display_script_id", ll_display_script_id)

if isnull(ll_display_script_id) then
	ls_script_type = get_attribute("script_type", ll_display_script_id)
	if isnull(ls_script_type) then ls_script_type = "RTF"
	popup.data_row_count = 3
	setnull(popup.items[1])
	popup.items[2] = "EDIT"
	popup.items[3] = ls_script_type
	Openwithparm(service_window, popup, "w_pick_display_script")
	ll_display_script_id = message.doubleparm
	if isnull(ll_display_script_id) then return 1
end if

openwithparm(w_display_script_edit, ll_display_script_id)

// Always return "I'm Finished" for configuration services
return 1

end function

on u_component_service_cfg_display_script.create
call super::create
end on

on u_component_service_cfg_display_script.destroy
call super::destroy
end on

