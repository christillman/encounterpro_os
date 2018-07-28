HA$PBExportHeader$u_component_observation_jmj_material.sru
forward
global type u_component_observation_jmj_material from u_component_observation
end type
end forward

global type u_component_observation_jmj_material from u_component_observation
end type
global u_component_observation_jmj_material u_component_observation_jmj_material

forward prototypes
protected function integer xx_do_source ()
protected function integer xx_initialize ()
end prototypes

protected function integer xx_do_source ();//////////////////////////////////////////////////////////////////////////////////////
//
// Description:Opens a window to import file
//             
// Returns: 1 - Success
//          0 - Continue
//
// Modified By:Sumathi Chinnasamy									Creation dt: 10/23/2001
/////////////////////////////////////////////////////////////////////////////////////

String					ls_filename,ls_filepath
String					ls_comment_title
String					ls_attachment_type,ls_file,ls_extension
Integer					li_sts
w_ext_observation_jmj_attachments lw_window
str_external_observation_attachment lstr_attachment

openwithparm(lw_window, this, "w_ext_observation_jmj_attachments")
lstr_attachment = message.powerobjectparm

if isnull(lstr_attachment.attachment_type) then return 0

observation_count = 1
observations[1].result_count = 0
observations[1].attachment_list.attachment_count = 1
observations[1].attachment_list.attachments[1] = lstr_attachment

Return 1

end function

protected function integer xx_initialize ();connected = true

return 1

end function

on u_component_observation_jmj_material.create
call super::create
end on

on u_component_observation_jmj_material.destroy
call super::destroy
end on

