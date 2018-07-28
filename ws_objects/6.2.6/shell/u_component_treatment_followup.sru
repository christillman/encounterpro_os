HA$PBExportHeader$u_component_treatment_followup.sru
forward
global type u_component_treatment_followup from u_component_treatment
end type
end forward

global type u_component_treatment_followup from u_component_treatment
end type
global u_component_treatment_followup u_component_treatment_followup

forward prototypes
public function integer xx_define_treatment ()
end prototypes

public function integer xx_define_treatment ();//////////////////////////////////////////////////////////////////////////////////////
//
// Description:Opens a window to enter followup details
//             
//
// Modified By:Sumathi Chinnasamy									Creation dt: 04/27/2000
/////////////////////////////////////////////////////////////////////////////////////

Openwithparm(w_define_followup,this)
Return 1
end function

on u_component_treatment_followup.create
call super::create
end on

on u_component_treatment_followup.destroy
call super::destroy
end on

