HA$PBExportHeader$u_component_treatment_referral.sru
forward
global type u_component_treatment_referral from u_component_treatment
end type
end forward

global type u_component_treatment_referral from u_component_treatment
end type
global u_component_treatment_referral u_component_treatment_referral

type variables

end variables

forward prototypes
public function integer xx_define_treatment ()
end prototypes

public function integer xx_define_treatment ();//////////////////////////////////////////////////////////////////////////////////////
//
// Returns: Integer
//
// Description:get referral attributes and values.
//
// Modified By:Sumathi Chinnasamy									Creation dt: 03/03/2000
/////////////////////////////////////////////////////////////////////////////////////

Openwithparm(w_define_referral,this)
Return 1

end function

on u_component_treatment_referral.create
call super::create
end on

on u_component_treatment_referral.destroy
call super::destroy
end on

