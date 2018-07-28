HA$PBExportHeader$u_component_observation_cic_signature.sru
forward
global type u_component_observation_cic_signature from u_component_observation
end type
end forward

global type u_component_observation_cic_signature from u_component_observation
end type
global u_component_observation_cic_signature u_component_observation_cic_signature

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

ls_claimedid = get_attribute("claimed_id")
ls_gravityprompt = get_attribute("gravityprompt")

popup.data_row_count = 2
popup.items[1] = ls_claimedid
popup.items[2] = ls_gravityprompt
popup.title = "Please Sign"

openwithparm(w_cic_signature, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then Return 0

observation_count = 1
observations[1].result_count = 0
observations[1].attachment_list.attachment_count = 1
observations[1].attachment_list.attachments[1].attachment_type = "SIGNATURE"
observations[1].attachment_list.attachments[1].extension = "cic_signature"
observations[1].attachment_list.attachments[1].attachment = blob(popup_return.items[1])

Return 1

end function

on u_component_observation_cic_signature.create
call super::create
end on

on u_component_observation_cic_signature.destroy
call super::destroy
end on

