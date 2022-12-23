$PBExportHeader$u_component_treatment_immunization.sru
forward
global type u_component_treatment_immunization from u_component_treatment
end type
end forward

global type u_component_treatment_immunization from u_component_treatment
end type
global u_component_treatment_immunization u_component_treatment_immunization

forward prototypes
public function integer xx_define_treatment ()
end prototypes

public function integer xx_define_treatment ();//////////////////////////////////////////////////////////////////////////////////////
//
// Description:Opens a window to pick one or more procedures.
//             
//
// Modified By:Sumathi Chinnasamy									Creation dt: 04/27/2000
/////////////////////////////////////////////////////////////////////////////////////
Integer						i
String						ls_description
Long							ll_row
str_popup					popup
str_picked_procedures 	lstr_procedures

popup.data_row_count = 2
popup.items[1] = treatment_type
popup.items[2] = "IMMUNIZATION"
Openwithparm(w_trt_pick_procedures, popup)
lstr_procedures = message.powerobjectparm

// Load selected treatments & attributes into structure
If lstr_procedures.procedure_count > 0 Then
	treatment_count = lstr_procedures.procedure_count
	For i = 1 To lstr_procedures.procedure_count
		
		treatment_definition[i].item_description = lstr_procedures.procedures[i].description
		treatment_definition[i].treatment_type   = treatment_type
		treatment_definition[i].attribute[1]     = "procedure_id"
		treatment_definition[i].value[1]         = lstr_procedures.procedures[i].procedure_id
		treatment_definition[i].attribute[2]     = "treatment_mode"
		treatment_definition[i].value[2]         = lstr_procedures.procedures[i].treatment_mode
		treatment_definition[i].attribute_count  = 2
		
	Next

End If
Return 1


end function

on u_component_treatment_immunization.create
call super::create
end on

on u_component_treatment_immunization.destroy
call super::destroy
end on

