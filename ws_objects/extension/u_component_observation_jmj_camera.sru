HA$PBExportHeader$u_component_observation_jmj_camera.sru
forward
global type u_component_observation_jmj_camera from u_component_observation
end type
end forward

global type u_component_observation_jmj_camera from u_component_observation
end type
global u_component_observation_jmj_camera u_component_observation_jmj_camera

forward prototypes
protected function integer xx_initialize ()
protected function integer xx_do_source ()
end prototypes

protected function integer xx_initialize ();connected = true

return 1

end function

protected function integer xx_do_source ();//////////////////////////////////////////////////////////////////////////////////////
//
// Description: get the image files ( digital camera )
//             
// Returns: 1 - Success
//          0 - Continue
//
// Modified By:Sumathi Chinnasamy									Creation dt: 10/22/2001
/////////////////////////////////////////////////////////////////////////////////////

Integer 	li_sts,i
String	ls_filename,ls_drive,ls_directory,ls_extension
long		ll_attachment_count
String	ls_camera_type
String 	ls_comment_title
str_popup_return popup_return

ls_comment_title = get_attribute("comment_title")
If trim(ls_comment_title) = "" Then 
	ls_comment_title="Portrait"
End If

ls_extension = get_attribute("extension")
If isnull(ls_extension) Or len(ls_extension) = 0 then ls_extension = "jpg"

openwithparm(w_twain_scanner, this)
popup_return = message.powerobjectparm

ll_attachment_count = 0
observation_count = 1
observations[1].result_count = 0

for i = 1 to popup_return.item_count
	if fileexists(popup_return.items[i]) then
		f_parse_filepath(popup_return.items[i], ls_drive, ls_directory, ls_filename, ls_extension)
		
		// Increment the attachment count
		ll_attachment_count += 1
		observations[1].attachment_list.attachment_count = ll_attachment_count
		li_sts = mylog.file_read(popup_return.items[i], observations[1].attachment_list.attachments[1].attachment)
		If li_sts <= 0 Then Return 0
		// Set the other attachment attributes
		observations[1].attachment_list.attachments[ll_attachment_count].attachment_type = "IMAGE"
		observations[1].attachment_list.attachments[ll_attachment_count].extension = ls_extension
		observations[1].attachment_list.attachments[ll_attachment_count].attachment_comment_title = ls_comment_title
		
		// Delete the disk file
		filedelete(popup_return.items[i])
	end if
next

Return ll_attachment_count
end function

on u_component_observation_jmj_camera.create
call super::create
end on

on u_component_observation_jmj_camera.destroy
call super::destroy
end on

