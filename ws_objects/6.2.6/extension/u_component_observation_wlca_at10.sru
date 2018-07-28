HA$PBExportHeader$u_component_observation_wlca_at10.sru
forward
global type u_component_observation_wlca_at10 from u_component_observation
end type
end forward

global type u_component_observation_wlca_at10 from u_component_observation
end type
global u_component_observation_wlca_at10 u_component_observation_wlca_at10

type variables
w_ext_observation_wlca_at10 at10_window
string attachment_path
end variables

forward prototypes
protected function integer xx_shutdown ()
private function integer connect_device ()
protected function integer xx_initialize ()
private function string ecg_interpretation (string ps_filepath)
protected function integer xx_do_source ()
end prototypes

protected function integer xx_shutdown ();integer li_sts

if isvalid(at10_window) then
	at10_window.Disconnect_Device()
	close(at10_window)
end if

return 1

end function

private function integer connect_device ();

if not isvalid(at10_window) then
	mylog.log(this, "connect_device()", "No valid window", 4)
	return -1
end if

return at10_window.connect_device()

end function

protected function integer xx_initialize ();integer li_sts

attachment_path = get_attribute("file_path")
if isnull(attachment_path) then attachment_path = "c:\temp\ecgfiles\"
if right(attachment_path, 1) <> "\" then
	attachment_path += "\"
end if

if not mylog.of_directoryexists(attachment_path) then
	li_sts = mylog.of_createdirectory(attachment_path)
	if li_sts <= 0 then
		log.log(this, "xx_initialize()", "Error creating directory (" + attachment_path + ")", 4)
		return -1
	end if
end if

openwithparm(at10_window, this)

at10_window.attachment_path = attachment_path
li_sts = at10_window.connect_device()
if li_sts <= 0 then return -1

return 1

end function

private function string ecg_interpretation (string ps_filepath);//Dim TEcgData As EcgData
//Set TEcgData = New EcgData

oleobject TEcgData
integer li_sts
string ls_interp
integer i
integer li_len

setnull(ls_interp)

TEcgData = CREATE oleobject
li_sts = TEcgData.connecttonewobject("WAEcgSvr.EcgData")
if li_sts <> 0 then
	mylog.log(this, "ecg_interpretation()", "Error connecting to WAEcgSvr.EcgData (" + string(li_sts) + ")", 4)
	return ls_interp
end if

TEcgData.FileName = ps_filepath
TEcgData.Load()

ls_interp = TEcgData.PatientAndDevice.Interpretation

TEcgData.disconnectobject()
DESTROY TEcgData

// Now trim the trailing CRs and replace other CRs with CRNL
li_len = len(ls_interp)
for i = li_len to 1 step -1
	if asc(mid(ls_interp, i)) = 13 then
		if i = len(ls_interp) then
			ls_interp = replace(ls_interp, i, 1, "")
		else
			ls_interp = replace(ls_interp, i, 1, "~r~n")
		end if
	end if
next

return ls_interp


end function

protected function integer xx_do_source ();integer i, j
str_file_attributes lstra_files[]
string ls_file
integer li_sts
integer li_count
string ls_filespec
string ls_comment_title

observation_count = 0

ls_comment_title = get_attribute("comment_title")
if trim(ls_comment_title) = "" then setnull(ls_comment_title)
//if isnull(ls_comment_title) then
//	ls_comment_title = "ECG"
//	ls_comment_title += " " + string(now(), "hh:mm:ss")
//end if

ls_filespec = attachment_path + "*.ecg"

li_count = mylog.directory_list(ls_filespec, lstra_files)
if li_count <= 0 then return 0

observations[1].result_count = 0
observations[1].attachment_list.attachment_count = 0


for i = 1 to li_count
	ls_file = attachment_path + lstra_files[i].filename
	if fileexists(ls_file) then
		observations[1].attachment_list.attachment_count += 1
		j = observations[1].attachment_list.attachment_count
		observations[1].attachment_list.attachments[j].attachment_type = "ECG"
		observations[1].attachment_list.attachments[j].extension = "ecg_wlca"
		li_sts = mylog.file_read(ls_file, observations[1].attachment_list.attachments[j].attachment)
		if i = 1 then
			observations[1].attachment_list.attachments[j].attachment_comment_title = ls_comment_title
		elseif isnull(ls_comment_title) then
			observations[1].attachment_list.attachments[j].attachment_comment_title = datalist.external_source_description(external_source) + " (" + string(i) + ")"
		else
			observations[1].attachment_list.attachments[j].attachment_comment_title = ls_comment_title + " (" + string(i) + ")"
		end if
		observations[1].attachment_list.attachments[j].attachment_comment = ecg_interpretation(ls_file)
		filedelete(ls_file)
	end if
next

if observations[1].attachment_list.attachment_count > 0 then observation_count = 1

return observation_count


end function

on u_component_observation_wlca_at10.create
call super::create
end on

on u_component_observation_wlca_at10.destroy
call super::destroy
end on

