$PBExportHeader$u_component_treatment_test.sru
forward
global type u_component_treatment_test from u_component_treatment
end type
end forward

global type u_component_treatment_test from u_component_treatment
end type
global u_component_treatment_test u_component_treatment_test

forward prototypes
public function integer xx_define_treatment ()
end prototypes

public function integer xx_define_treatment ();//////////////////////////////////////////////////////////////////////////////////////
//
// Description:load all labs/tests and it's attributes into structure.
//
//
// Modified By:Sumathi Chinnasamy									Creation dt: 04/27/2000
/////////////////////////////////////////////////////////////////////////////////////

Integer				i
String				ls_observation_id,ls_send_out_flag
// user defined data types
str_picked_observations lstr_observations
str_popup popup

popup.data_row_count = 2
popup.items[1] = treatment_type
popup.items[2] = current_user.specialty_id

Openwithparm(w_trt_pick_observations, popup)
lstr_observations = Message.powerobjectparm
If lstr_observations.observation_count <= 0 Then return 0

// Load selected treatments & attributes into structure
treatment_count = lstr_observations.observation_count

For i = 1 To treatment_count
	if isnull(lstr_observations.observation_id[i]) then continue
	treatment_definition[i].item_description = lstr_observations.description[i]
	treatment_definition[i].treatment_type   = treatment_type

	treatment_definition[i].attribute_count  = 1
	treatment_definition[i].attribute[1]     = "observation_id"
	treatment_definition[i].value[1]         = lstr_observations.observation_id[i]
	
	if not isnull(lstr_observations.treatment_mode[i]) then
		treatment_definition[i].attribute_count  += 1
		treatment_definition[i].attribute[treatment_definition[i].attribute_count] = "treatment_mode"
		treatment_definition[i].value[treatment_definition[i].attribute_count] = lstr_observations.treatment_mode[i]
	end if
	
	if not isnull(lstr_observations.location[i]) then
		treatment_definition[i].attribute_count  += 1
		treatment_definition[i].attribute[treatment_definition[i].attribute_count] = "location"
		treatment_definition[i].value[treatment_definition[i].attribute_count] = lstr_observations.location[i]
	end if
Next

Return treatment_count

end function

on u_component_treatment_test.create
call super::create
end on

on u_component_treatment_test.destroy
call super::destroy
end on

