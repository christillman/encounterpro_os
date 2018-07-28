HA$PBExportHeader$u_component_treatment_activity.sru
forward
global type u_component_treatment_activity from u_component_treatment
end type
end forward

global type u_component_treatment_activity from u_component_treatment
end type
global u_component_treatment_activity u_component_treatment_activity

forward prototypes
public function integer xx_define_treatment ()
end prototypes

public function integer xx_define_treatment ();//////////////////////////////////////////////////////////////////////////////////////
//
// Returns: 1 - Success
//          0 - No Operation
//
// Description:Opens the activity window and fills in array of treatments. Treatment
//             mode needs to set to differtiate the window is returns array of treatment
//             structure [DEFINE] or single[REVIEW].
//
// Modified By:Sumathi Chinnasamy									Creation dt: 04/27/2000
/////////////////////////////////////////////////////////////////////////////////////
str_popup_return popup_return

Openwithparm(w_define_activity,this)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

if popup_return.items[1] = "OK" then
	Return 1
else
	return 0
end if



end function

on u_component_treatment_activity.create
call super::create
end on

on u_component_treatment_activity.destroy
call super::destroy
end on

