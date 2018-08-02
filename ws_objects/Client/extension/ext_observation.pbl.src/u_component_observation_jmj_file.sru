$PBExportHeader$u_component_observation_jmj_file.sru
forward
global type u_component_observation_jmj_file from u_component_observation
end type
end forward

global type u_component_observation_jmj_file from u_component_observation
end type
global u_component_observation_jmj_file u_component_observation_jmj_file

type variables
long max_files
long max_file_size

string xslt


end variables

forward prototypes
protected function integer xx_do_source ()
protected function integer xx_initialize ()
protected function integer xx_set_processed (string ps_id, integer pi_status)
public function integer get_attachments ()
public function integer run_program_old ()
end prototypes

protected function integer xx_do_source ();integer li_sts

li_sts = get_attachments()
if li_sts < 0 then
	log.log(this, "u_component_observation_jmj_file.xx_do_source.0005", "Error getting attachments", 4)
	return -1
end if

return 1

end function

protected function integer xx_initialize ();integer li_sts
long ll_material_id
str_patient_material lstr_material

connected = true

// Default the max file count to 100
get_attribute("max_files", max_files)
if isnull(max_files) then max_files = 100

// Default the max file size to 2 MB
get_attribute("max_file_size", max_file_size)
if isnull(max_file_size) then max_file_size = 2000000

setnull(xslt)

get_attribute("xslt_material_id", ll_material_id)
lstr_material = f_get_patient_material(ll_material_id, true)
if isnull(lstr_material.material_id) then
	xslt = string(lstr_material.material_object)
end if


return 1

end function

protected function integer xx_set_processed (string ps_id, integer pi_status);string ls_move_to_success
string ls_move_to_error
string ls_temp
boolean lb_delete_file
string ls_drive
string ls_directory
string ls_filename
string ls_extension
integer li_sts

ls_move_to_success = trim(get_attribute("move_to_success"))
if len(ls_move_to_success) > 0 then
	if right(ls_move_to_success, 1) <> "\" then ls_move_to_success += "\"
else
	setnull(ls_move_to_success)
end if

ls_move_to_error = trim(get_attribute("move_to_error"))
if len(ls_move_to_error) > 0 then
	if right(ls_move_to_error, 1) <> "\" then ls_move_to_error += "\"
else
	setnull(ls_move_to_error)
end if

get_attribute("delete_file", lb_delete_file)

f_parse_filepath(ps_id, ls_drive, ls_directory, ls_filename, ls_extension)
if len(ls_extension) > 0 then ls_filename += "." + ls_extension

if pi_status > 0 then
	if not isnull(ls_move_to_success) then
		ls_temp = ls_move_to_success + ls_filename
		li_sts = filemove(ps_id, ls_temp)
		if li_sts<= 0 then
			log.log(this, "u_component_observation_jmj_file.xx_do_source.0005", "Error moving file (" + ps_id + ", " + ls_temp + ", " + string(li_sts) + ")", 4)
		end if
	elseif lb_delete_file then
		// If we're supposed to delete it then delete it
		if not filedelete(ps_id) then
			log.log(this, "u_component_observation_jmj_file.xx_do_source.0005", "Error deleting file (" + ps_id + ")", 4)
			li_sts = -1
		end if
	end if
else
	if not isnull(ls_move_to_error) then
		ls_temp = ls_move_to_error + ls_filename
		li_sts = filemove(ps_id, ls_temp)
		if li_sts<= 0 then
			log.log(this, "u_component_observation_jmj_file.xx_do_source.0005", "Error moving file (" + ps_id + ", " + ls_temp + ", " + string(li_sts) + ")", 4)
		end if
	elseif lb_delete_file then
		// If we're supposed to delete it then delete it
		if not filedelete(ps_id) then
			log.log(this, "u_component_observation_jmj_file.xx_do_source.0005", "Error deleting file (" + ps_id + ")", 4)
			li_sts = -1
		end if
	end if
end if

Return 1


end function

public function integer get_attachments ();//////////////////////////////////////////////////////////////////////////////////////
//
// Description:Opens a window to import file
//             
// Returns: 1 - Success
//          0 - Continue
//
// Modified By:Sumathi Chinnasamy									Creation dt: 10/23/2001
/////////////////////////////////////////////////////////////////////////////////////

string ls_drive, ls_directory
String					ls_comment_title
String					ls_attachment_type,ls_filename,ls_extension
Integer					li_sts
string lsa_paths[]
string lsa_files[]
string ls_filter
u_getopenfilename openfilename
integer li_count
integer i
string ls_address
string ls_move_to_pending
string ls_temp
str_file_attributes lstr_file_attributes
str_complete_context lstr_context
str_attributes lstr_attributes
blob lbl_file
long j
string ls_xml_results
boolean lb_read_xml_specified
boolean lb_read_xml
integer li_sts2
boolean lb_lock_file
long ll_filebytes

ls_comment_title = get_attribute("comment_title")
If trim(ls_comment_title) = "" Then setnull(ls_comment_title)

ls_xml_results = get_attribute("xml_results")
if isnull(ls_xml_results) then
	lb_read_xml_specified = false
else
	lb_read_xml = f_string_to_boolean(ls_xml_results)
end if

get_attribute("lock_file_when_reading", lb_lock_file)

ls_address = get_attribute("address")
if isnull(ls_address) then
	ls_address = get_attribute("attachment_address")
elseif lower(ls_address) = "pick" then
	ls_temp = get_attribute("attachment_address")
	if len(ls_temp) > 0 then ls_address = ls_temp
end if

ls_move_to_pending = trim(get_attribute("move_to_pending"))
if len(ls_move_to_pending) > 0 then
	if right(ls_move_to_pending, 1) <> "\" then ls_move_to_pending += "\"
else
	setnull(ls_move_to_pending)
end if

// Don't do anything if we have no address
if isnull(ls_address) then return 0

if lower(ls_address) = "pick" then
	if cpr_mode = "SERVER" then
		log.log(this, "u_component_observation_jmj_file.get_attachments.0068", "address is required in server mode", 4)
		return -1
	else
		ls_filter = get_attribute("attachment_file_filter")
		if isnull(ls_filter) then ls_filter = "All Files (*.*), *.*"
		
		li_sts = windows_api.comdlg32.getopenfilename( handle(w_main), &
																	"Select Attachment File(s)", &
																	lsa_paths, &
																	lsa_files, &
																	ls_filter)
		if li_sts < 0 then return 0
		
		li_count = upperbound(lsa_paths)
	end if
else
	lstr_context = f_current_complete_context()
	lstr_attributes = get_attributes()
	
	ls_address = f_attribute_value_substitute_string(ls_address, lstr_context, lstr_attributes)

	li_sts = f_parse_filepath(ls_address, ls_drive, ls_directory, ls_filename, ls_extension)
	li_count = mylog.get_all_files(ls_address, lsa_files)
	for i = 1 to li_count
		lsa_paths[i] = ls_drive + ls_directory + "\" + lsa_files[i]
	next
end if

for i = 1 to li_count
	// Skip the shorthand directories
	if lsa_files[i] = "." or lsa_files[i] = ".." then continue
	
	// Skip the file if we can't get its properties
	li_sts = log.file_attributes(lsa_paths[i], lstr_file_attributes)
	if li_sts <= 0 then continue
	
	// Skip the directories
	if lstr_file_attributes.subdirectory then continue
	
	// Skip the file if it's too big
	if lstr_file_attributes.filesize > max_file_size then
		log.log(this, "u_component_observation_jmj_file.get_attachments.0068", "File too large", 4)
		set_processed(lsa_paths[i], -1)
		continue
	end if
	
	li_sts = f_parse_filepath(lsa_paths[i], ls_drive, ls_directory, ls_filename, ls_extension )
	if li_sts <= 0 then continue
	
	// Read the file into the structure
//	li_sts = mylog.file_read(lsa_paths[i], lbl_file)
	ll_filebytes = mylog.file_read2(lsa_paths[i], lbl_file, lb_lock_file)
	if ll_filebytes <= 0 then
		li_sts = ll_filebytes
	else
		li_sts = 1
	end if
	if li_sts > 0 then
		// If the "read_xml" attribute is specified, then obey it.  Otherwise,
		// process as an xml file if the extension is "xml"
		if not lb_read_xml_specified then
			if lower(ls_extension) = "xml" then
				lb_read_xml = true
			else
				lb_read_xml = false
			end if
		end if
		if lb_read_xml  then
			li_sts2 = f_observation_read_xml_documents(this, f_blob_to_string(lbl_file), lsa_paths[i])
			if li_sts2 < 0 then
				log.log(this, "u_component_observation_jmj_file.get_attachments.0068", "Error reading xml document (" + lsa_paths[i] + ")", 4)
				li_sts = 0 //skip this file
			end if
		else
			observation_count += 1
			ls_attachment_type = f_attachment_type_from_object_type(ls_extension)
			observations[observation_count].external_item_id = lsa_paths[i]
			observations[observation_count].result_count = 0
			observations[observation_count].attachment_list.attachment_count = 1
			observations[observation_count].attachment_list.attachments[1].attachment_type = ls_attachment_type
			observations[observation_count].attachment_list.attachments[1].filename = ls_filename
			observations[observation_count].attachment_list.attachments[1].extension = ls_extension
			if isnull(ls_comment_title) then
				observations[observation_count].attachment_list.attachments[1].attachment_comment_title = ls_filename + "." + ls_extension
			else
				observations[observation_count].attachment_list.attachments[1].attachment_comment_title = ls_comment_title
			end if
			observations[observation_count].attachment_list.attachments[1].attachment = lbl_file
		end if
	end if
	
	// Process the original file according to the li_sts value
	if li_sts > 0 then
		if len(lbl_file) > 0 then
			// If we're supposed to move the file then move it
			if not isnull(ls_move_to_pending) then
				ls_temp = ls_move_to_pending + lsa_files[i]
				li_sts = filemove(lsa_paths[i], ls_temp)
				if li_sts > 0 then
					// If we moved the file, then point the id to the new place
					observations[observation_count].external_item_id = ls_temp
				else
					log.log(this, "u_component_observation_jmj_file.get_attachments.0068", "Error moving file (" + lsa_paths[i] + ", " + ls_temp + ", " + string(li_sts) + ")", 4)
				end if
			end if
		else
			log.log(this, "u_component_observation_jmj_file.get_attachments.0068", "Error: file is empty (" + lsa_paths[i] + ")", 4)
			li_sts = -1
		end if
	elseif li_sts < 0 then
		log.log(this, "u_component_observation_jmj_file.get_attachments.0068", "Error reading file (" + lsa_paths[i] + ", " + string(li_sts) + ")", 4)
	end if
	
	// If we didn't successfully handle the file then skip it
	if li_sts <= 0 then observation_count -= 1
	
	
	if observation_count >= max_files then exit
next

Return 1

end function

public function integer run_program_old ();string ls_command
ulong lul_pid
integer li_sts
str_complete_context lstr_context
str_attributes lstr_attributes

// Run ("C:\Program Files\Primetime Medical Software\Primetime Instant Medical History\imh.exe -fn Robert -mn M -ln Smith -g male -dob 11-9-1956 -pid 12345")

// Run "%executable%" -fn %Patient first_name% -mn %Patient middle_name% -ln %Patient last_name% -g %Patient Sex_male_female% -dob %Patient date_of_birth% -pid %Patient cpr_id%

ls_command = get_attribute("command_line")
if isnull(ls_command) then return 0

lstr_context = f_current_complete_context()
lstr_attributes = get_attributes()

ls_command = f_attribute_value_substitute_string(ls_command, lstr_context, lstr_attributes)

li_sts = windows_api.kernel32.run_command(ls_command, true, lul_pid)
if li_sts < 0 then
	log.log(this, "u_component_observation_jmj_file.run_program_old.0021", "Error running command (" + ls_command + ")", 4)
	return -1
end if

return 1


end function

on u_component_observation_jmj_file.create
call super::create
end on

on u_component_observation_jmj_file.destroy
call super::destroy
end on

