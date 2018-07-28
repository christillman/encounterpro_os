HA$PBExportHeader$u_component_observation_jmj_dictation.sru
forward
global type u_component_observation_jmj_dictation from u_component_observation
end type
end forward

global type u_component_observation_jmj_dictation from u_component_observation
end type
global u_component_observation_jmj_dictation u_component_observation_jmj_dictation

forward prototypes
protected function integer xx_do_source ()
protected function integer xx_initialize ()
end prototypes

protected function integer xx_do_source ();integer li_sts
string ls_audio_file
string ls_comment_title

ls_comment_title = get_attribute("comment_title")
If trim(ls_comment_title) = "" Then setnull(ls_comment_title)

ls_audio_file = f_temp_file("wav")

if fileexists(ls_audio_file) then filedelete(ls_audio_file)

li_sts = common_thread.mm.record_audio(ls_audio_file)
if li_sts <= 0 then return 0
if not fileexists(ls_audio_file) then return 0

observation_count = 1
observations[1].result_count = 0
observations[1].attachment_list.attachment_count = 1
observations[1].attachment_list.attachments[1].attachment_type = "DICTATION"
observations[1].attachment_list.attachments[1].extension = "wav"
li_sts = mylog.file_read(ls_audio_file, observations[1].attachment_list.attachments[1].attachment)
if li_sts <= 0 then return 0
observations[1].attachment_list.attachments[1].attachment_comment_title = ls_comment_title
observations[1].attachment_list.attachments[1].attachment_comment = "< Pending Transcription >"
filedelete(ls_audio_file)


return 1

end function

protected function integer xx_initialize ();connected = true

return 1

end function

on u_component_observation_jmj_dictation.create
call super::create
end on

on u_component_observation_jmj_dictation.destroy
call super::destroy
end on

