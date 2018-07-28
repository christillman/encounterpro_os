$PBExportHeader$u_component_observation_jmj_sonymavica.sru
forward
global type u_component_observation_jmj_sonymavica from u_component_observation
end type
end forward

global type u_component_observation_jmj_sonymavica from u_component_observation
end type
global u_component_observation_jmj_sonymavica u_component_observation_jmj_sonymavica

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

Integer 	li_sts
String	ls_image_file,ls_extension
String	ls_camera_type
String 	ls_comment_title

ls_comment_title = get_attribute("comment_title")
If trim(ls_comment_title) = "" Then setnull(ls_comment_title)

ls_extension = get_attribute("extension")
If isnull(ls_extension) Or len(ls_extension) = 0 then ls_extension = "tif"
ls_image_file = f_temp_file(ls_extension)

If fileexists(ls_image_file) Then filedelete(ls_image_file)

li_sts = MessageBox ( "Sony Mavica Digital Camera", "Place the floppy disk from the camera into the floppy drive and press OK." , Information!, OKCancel!)
If li_sts <> 1 Then Return 0
li_sts = common_thread.mm.get_image(current_patient.name(), ls_image_file, "a:\", "jpg")
If li_sts <= 0 Then Return 0
If Not fileexists(ls_image_file) Then Return 0

observation_count = 1
observations[1].result_count = 0
observations[1].attachment_list.attachment_count = 1
observations[1].attachment_list.attachments[1].attachment_type = "IMAGE"
observations[1].attachment_list.attachments[1].extension = ls_extension
li_sts = mylog.file_read(ls_image_file, observations[1].attachment_list.attachments[1].attachment)
If li_sts <= 0 Then Return 0
observations[1].attachment_list.attachments[1].attachment_comment_title = ls_comment_title
filedelete(ls_image_file)

Return 1
end function

on u_component_observation_jmj_sonymavica.create
call super::create
end on

on u_component_observation_jmj_sonymavica.destroy
call super::destroy
end on

