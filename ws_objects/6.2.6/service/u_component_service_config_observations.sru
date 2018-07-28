HA$PBExportHeader$u_component_service_config_observations.sru
forward
global type u_component_service_config_observations from u_component_service
end type
end forward

global type u_component_service_config_observations from u_component_service
end type
global u_component_service_config_observations u_component_service_config_observations

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
string ls_observation_id
string ls_composite_flag


ls_observation_id = get_attribute("observation_id")
if isnull(ls_observation_id) then
	Openwithparm(service_window, this, "w_edit_observations")
else
	popup.data_row_count = 2
	popup.items[1] = ls_observation_id
	popup.items[2] = f_boolean_to_string(true)
	
	ls_composite_flag = datalist.observation_composite_flag(ls_observation_id)
	if ls_composite_flag = "Y" then
		if f_string_to_boolean(get_attribute("use_tree_display")) then
			openwithparm(service_window, popup, "w_observation_tree_display")
		else
			openwithparm(service_window, popup, "w_composite_observation_definition")
		end if
	else
		openwithparm(service_window, popup, "w_observation_definition")
	end if
end if


// Always return "I'm Finished" for configuration services
return 1

end function

on u_component_service_config_observations.create
call super::create
end on

on u_component_service_config_observations.destroy
call super::destroy
end on

