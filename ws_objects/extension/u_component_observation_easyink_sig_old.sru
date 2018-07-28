HA$PBExportHeader$u_component_observation_easyink_sig_old.sru
forward
global type u_component_observation_easyink_sig_old from u_component_observation
end type
end forward

global type u_component_observation_easyink_sig_old from u_component_observation
end type
global u_component_observation_easyink_sig_old u_component_observation_easyink_sig_old

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
str_captured_signature lstr_captured_signature
w_ext_observation_easyink_signature lw_easyink

str_popup popup
str_popup_return popup_return

ls_claimedid = get_attribute("claimed_id")
if isnull(ls_claimedid) then
	ls_claimedid = user_list.user_full_name(current_user.user_id)
end if

ls_gravityprompt = get_attribute("gravityprompt")

popup.data_row_count = 2
popup.items[1] = ls_claimedid
popup.items[2] = ls_gravityprompt
popup.title = "Please Sign"

openwithparm(lw_easyink, this, "w_ext_observation_easyink_signature")
lstr_captured_signature = message.powerobjectparm
if isnull(lstr_captured_signature.captured_signature_file) then return 0
if len(lstr_captured_signature.captured_signature_file) <= 0 then return 0

observation_count = 1
observations[1].result_count = 0
observations[1].attachment_list.attachment_count = 1
observations[1].attachment_list.attachments[1].attachment_type = "SIGNATURE"
observations[1].attachment_list.attachments[1].extension = lstr_captured_signature.captured_signature_file_type
observations[1].attachment_list.attachments[1].attachment = lstr_captured_signature.captured_signature_file
observations[1].attachment_list.attachments[1].attachment_render_file_type = lstr_captured_signature.signature_render_file_type
observations[1].attachment_list.attachments[1].attachment_render_file = lstr_captured_signature.signature_render_file
observations[1].attachment_list.attachments[1].attached_by_user_id = lstr_captured_signature.captured_from_user

Return 1

end function

on u_component_observation_easyink_sig_old.create
call super::create
end on

on u_component_observation_easyink_sig_old.destroy
call super::destroy
end on

