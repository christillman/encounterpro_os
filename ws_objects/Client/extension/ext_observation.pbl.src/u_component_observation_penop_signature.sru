$PBExportHeader$u_component_observation_penop_signature.sru
forward
global type u_component_observation_penop_signature from u_component_observation
end type
end forward

global type u_component_observation_penop_signature from u_component_observation
end type
global u_component_observation_penop_signature u_component_observation_penop_signature

forward prototypes
protected function integer xx_do_source ()
end prototypes

protected function integer xx_do_source ();//////////////////////////////////////////////////////////////////////////////////////
//
// Description:Opens a window to get 'Penop' signature
//             
// Returns: 1 - Success
//          0 - Continue
//
// Modified By:Sumathi Chinnasamy									Creation dt: 10/22/2001
/////////////////////////////////////////////////////////////////////////////////////

String ls_claimedid,ls_gravityprompt
String ls_sig_file,ls_extension
Integer li_sts

ls_claimedid = get_attribute("claimed_id")
If isnull(ls_claimedid) then ls_claimedid = current_patient.name()
ls_gravityprompt = get_attribute("gravityprompt")
If isnull(ls_gravityprompt) then ls_gravityprompt = "Please Sign"
ls_extension = "penop_btoken"

ls_sig_file = f_temp_file(ls_extension)

If fileexists(ls_sig_file) Then filedelete(ls_sig_file)

li_sts = common_thread.mm.get_signature(ls_claimedid, ls_gravityprompt, ls_sig_file)
if li_sts <= 0 then
	log.log(this, "u_component_observation_penop_signature.xx_do_source:0027", "No Signature Captured (" + string(common_thread.mm.error_code) + ")", 3)
	Return 0
end if
If Not fileexists(ls_sig_file) Then Return 0

observation_count = 1
observations[1].result_count = 0
observations[1].attachment_list.attachment_count = 1
observations[1].attachment_list.attachments[1].attachment_type = "SIGNATURE"
observations[1].attachment_list.attachments[1].extension = "penop_btoken"
li_sts = mylog.file_read(ls_sig_file, observations[1].attachment_list.attachments[1].attachment)
If li_sts <= 0 Then Return 0
filedelete(ls_sig_file)

Return 1
end function

on u_component_observation_penop_signature.create
call super::create
end on

on u_component_observation_penop_signature.destroy
call super::destroy
end on

