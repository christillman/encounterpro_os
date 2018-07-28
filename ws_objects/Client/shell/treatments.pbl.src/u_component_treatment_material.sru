$PBExportHeader$u_component_treatment_material.sru
forward
global type u_component_treatment_material from u_component_treatment
end type
end forward

global type u_component_treatment_material from u_component_treatment
end type
global u_component_treatment_material u_component_treatment_material

forward prototypes
public function integer xx_define_treatment ()
end prototypes

public function integer xx_define_treatment ();//////////////////////////////////////////////////////////////////////////////////////
//
// Description:Opens a window to pick one or more materials.
//             
//
// Modified By:Sumathi Chinnasamy									Creation dt: 12/19/2001
//
/////////////////////////////////////////////////////////////////////////////////////

Integer								i
str_popup							popup
str_picked_patient_materials	lstr_materials


popup.data_row_count = 1
popup.items[1] = treatment_type
Openwithparm(w_pick_patient_materials, popup)
lstr_materials = Message.powerobjectparm

If lstr_materials.material_count > 0 Then
	treatment_count = lstr_materials.material_count
	For i = 1 To lstr_materials.material_count
	
		treatment_definition[i].item_description = lstr_materials.materials[i].description
		treatment_definition[i].treatment_type   = treatment_type
		treatment_definition[i].attribute[1]     = "material_id"
		treatment_definition[i].value[1]         = lstr_materials.materials[i].material_id
		treatment_definition[i].attribute[2]     = "treatment_mode"
		treatment_definition[i].value[2]         = lstr_materials.materials[i].treatment_mode
		treatment_definition[i].attribute_count  = 2
	
	Next
End if
Return 1
end function

on u_component_treatment_material.create
call super::create
end on

on u_component_treatment_material.destroy
call super::destroy
end on

