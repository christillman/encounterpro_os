﻿$PBExportHeader$u_component_treatment_officemed.sru
forward
global type u_component_treatment_officemed from u_component_treatment
end type
end forward

global type u_component_treatment_officemed from u_component_treatment
end type
global u_component_treatment_officemed u_component_treatment_officemed

type variables

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
/////////////////////////////////////////////////////////////////////////////////////

Integer				i
str_popup			popup
str_attributes_list lstr_attributes_list

popup.data_row_count = 1
popup.items[1] = treatment_type
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

on u_component_treatment_officemed.create
call super::create
end on

on u_component_treatment_officemed.destroy
call super::destroy
end on

