$PBExportHeader$u_component_treatment_medication.sru
forward
global type u_component_treatment_medication from u_component_treatment
end type
end forward

global type u_component_treatment_medication from u_component_treatment
end type
global u_component_treatment_medication u_component_treatment_medication

type variables
string prescription_flag,common_name,take_as_directed
end variables

forward prototypes
public function integer xx_define_treatment ()
end prototypes

public function integer xx_define_treatment ();//////////////////////////////////////////////////////////////////////////////////////
//
// Description:Opens a window to pick one or more drugs.
//             
//
// Modified By:Sumathi Chinnasamy									Creation dt: 04/27/2000
//
// Note: 'CurrentMeds' service window w_svc_current_meds also uses this component
// to create past meds.
/////////////////////////////////////////////////////////////////////////////////////

Integer				i
str_popup			popup
str_attributes_list lstr_attributes_list

popup.data_row_count = 2
popup.items[1] = treatment_type
popup.items[2] = f_boolean_to_string(past_treatment) 

Openwithparm(w_trt_pick_drugs, popup)

lstr_attributes_list = Message.powerobjectparm

treatment_count = lstr_attributes_list.attributes_count
For i = 1 To treatment_count
	treatment_definition[i].item_description = f_attribute_find_attribute(lstr_attributes_list.attributes[i], "treatment_description")
	treatment_definition[i].treatment_type   = treatment_type
	treatment_definition[i].attribute_count  = f_attribute_str_to_arrays(lstr_attributes_list.attributes[i], &
																								treatment_definition[i].attribute, &
																								treatment_definition[i].value)
Next

Return 1

end function

on u_component_treatment_medication.create
call super::create
end on

on u_component_treatment_medication.destroy
call super::destroy
end on

