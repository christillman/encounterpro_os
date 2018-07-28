$PBExportHeader$u_component_observation_pbink_sig.sru
forward
global type u_component_observation_pbink_sig from u_component_observation
end type
end forward

global type u_component_observation_pbink_sig from u_component_observation
end type
global u_component_observation_pbink_sig u_component_observation_pbink_sig

forward prototypes
protected function integer xx_do_source ()
end prototypes

protected function integer xx_do_source ();//////////////////////////////////////////////////////////////////////////////////////
//
// Description:Opens a window to get 'CIC' signature
//             
// Returns: 1 - Success
//          0 - Continue
//
// Modified By:Sumathi Chinnasamy									Creation dt: 10/22/2001
/////////////////////////////////////////////////////////////////////////////////////

String ls_claimedid,ls_gravityprompt

str_popup popup
str_popup_return popup_return


openwithparm(w_ext_observation_pbink_signature, this)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then Return 0

if popup_return.items[1] = "OK" then return 1

Return -1

end function

on u_component_observation_pbink_sig.create
call super::create
end on

on u_component_observation_pbink_sig.destroy
call super::destroy
end on

