$PBExportHeader$u_component_attachment.sru
forward
global type u_component_attachment from u_component_base_class
end type
end forward

global type u_component_attachment from u_component_base_class
end type
global u_component_attachment u_component_attachment

type variables
long attachment_id
string cpr_id
long encounter_id
long problem_id
long treatment_id
long observation_sequence
string attachment_type
string attachment_tag
string attachment_file_path
string attachment_file
string extension
string attachment_text
string storage_flag
datetime attachment_date
string attachment_folder
string attached_by
datetime created
string created_by
string common_dir
string status
//string id
u_user originator

u_ds_data attachment_progress

string render_filetype = "bmp"


blob attachment_image
boolean local_image
boolean local_image_updated


end variables

forward prototypes
public function integer display ()
public function string attachment_file_path ()
public function integer get_attachment_progress (string ps_find, ref str_p_attachment_progress pstra_progress[])
public function integer save_as (string ps_file)
public function integer xx_transcribe ()
public function integer xx_display ()
public function integer xx_render (string ps_file_type, ref string ps_file, integer pi_width, integer pi_height)
public function integer render (string ps_file_type, ref string ps_file, integer pi_width, integer pi_height)
public function integer xx_edit ()
public function integer edit ()
public function integer add_update (string ps_updated_file)
public function integer add_update (blob pbl_attachment)
public function integer add_progress (string ps_progress_type)
public function integer add_progress (string ps_progress_type, string ps_progress)
public function string get_attachment ()
public function integer get_attachment_blob (ref blob pbl_attachment)
protected function boolean xx_is_editable ()
protected function boolean xx_is_transcribeable ()
public function boolean is_transcribeable ()
protected function boolean xx_is_displayable ()
public function boolean is_displayable ()
public function boolean is_editable ()
public function integer transcribe ()
public function integer edit_attachment (string ps_attachment_file)
public function integer edit_attachment ()
public function integer xx_review ()
public function integer review ()
public function integer open_attachment ()
public function integer open_attachment (string ps_attachment_file)
public function integer open_attachment (string ps_action, boolean pb_wait_for_completion, ref unsignedlong pul_process_id)
protected function boolean xx_is_interpretable ()
public function boolean is_interpretable ()
public function integer interpret ()
protected function integer xx_interpret ()
public function string get_attachment_for_display ()
public function string render ()
public function integer save_as ()
protected function boolean xx_is_printable ()
public function boolean is_printable ()
public function integer print ()
public function integer xx_print ()
public function integer get_attachment (ref str_external_observation_attachment pstr_attachment)
public subroutine set_attachment_data (string ps_extension, blob pbl_data)
public subroutine set_attachment_data (string ps_attachment_tag, string ps_attachment_file, string ps_extension, blob pbl_data)
public function integer print (string ps_printer)
public subroutine load_extension_attributes ()
end prototypes

public function integer display ();integer li_sts

li_sts = xx_display()

return li_sts

end function

public function string attachment_file_path ();string ls_filepath
string ls_filespec
string ls_filename
integer i
string ls_null

setnull(ls_null)

if trim(attachment_file_path) = "" then setnull(attachment_file_path)

if isnull(attachment_file) or (trim(attachment_file) = "") then
	log.log(this, "u_component_attachment.attachment_file_path:0012", "No attachment file name", 4)
	return ls_null
end if

if isnull(extension) or (trim(extension) = "") then
	log.log(this, "u_component_attachment.attachment_file_path:0017", "No attachment file extension", 4)
	return ls_null
end if

ls_filepath = f_patient_file_path(cpr_id)

if not isnull(attachment_file_path) then
	ls_filepath += attachment_file_path
	if right(ls_filepath, 1) <> "\" then ls_filepath += "\"
end if

ls_filespec = ls_filepath + attachment_file + "." + extension

return ls_filespec

end function

public function integer get_attachment_progress (string ps_find, ref str_p_attachment_progress pstra_progress[]);long ll_row
long ll_rowcount
integer li_count

li_count = 0
ll_rowcount = attachment_progress.rowcount()

ll_row = attachment_progress.find(ps_find, 1, ll_rowcount)
DO WHILE ll_row > 0 and ll_row <= ll_rowcount
	li_count += 1
	pstra_progress[li_count] = attachment_progress.object.data[ll_row]
	
	ll_row = attachment_progress.find(ps_find, ll_row + 1, ll_rowcount + 1)
LOOP

return li_count


end function

public function integer save_as (string ps_file);integer li_sts
blob lbl_attachment
string ls_file_path
long ll_attachment_progress_sequence
string ls_find
long ll_row

if isnull(ps_file) then
	log.log(this, "u_component_attachment.save_as:0009", "Null filename", 4)
	return -1
end if

if local_image then
	li_sts = mylog.file_write(attachment_image, ps_file)
	if li_sts <= 0 then return -1
else
	if storage_flag = "D" then
		ls_find = "progress_type='UPDATE'"
		ll_row = attachment_progress.find(ls_find, attachment_progress.rowcount(), 1)
		if ll_row > 0 then
			// If the attachment has been updated then get the latest update
			ll_attachment_progress_sequence = attachment_progress.object.attachment_progress_sequence[ll_row]
			SELECTBLOB attachment_image
			INTO :lbl_attachment
			FROM p_Attachment_Progress
			WHERE attachment_id = :attachment_id
			AND attachment_progress_sequence = :ll_attachment_progress_sequence
			USING cprdb;
			if not cprdb.check() then return -1
		else
			SELECTBLOB attachment_image
			INTO :lbl_attachment
			FROM p_Attachment
			WHERE attachment_id = :attachment_id
			USING cprdb;
			if not cprdb.check() then return -1
		end if
		if isnull(lbl_attachment) then
			log.log(this, "u_component_attachment.save_as:0039", "Null attachment file data (" + string(attachment_id) + ")", 3)
			lbl_attachment = blob("")
		end if
		li_sts = mylog.file_write(lbl_attachment, ps_file)
		if li_sts <= 0 then return -1
	else
		ls_file_path = attachment_file_path()
		if isnull(ls_file_path) then return -1
		li_sts = mylog.file_copy(ls_file_path, ps_file)
		if li_sts <= 0 then return -1
	end if
end if

// One last check to make sure the file exists
if not fileexists(ps_file) then
	log.log(this, "u_component_attachment.save_as:0054", "Error saving attachment to file (" + string(attachment_id) + ", " + ps_file + ")", 4)
	return -1
end if

return 1




end function

public function integer xx_transcribe ();integer li_sts
w_attachment_transcribe lw_window

openwithparm(lw_window, this, "w_attachment_transcribe", f_active_window())

return 1

end function

public function integer xx_display ();integer li_sts
blob lbl_attachment
unsignedlong lul_process_id
string ls_executable
string ls_arguments
string ls_file
string ls_message
string ls_display_how
boolean lb_wait_for_completion
string ls_verb


/////////////////////////////////////////////////////////
// Handle the COM attachment handlers
/////////////////////////////////////////////////////////
if ole_class then
	li_sts = get_attachment_blob(lbl_attachment)
	if li_sts <= 0 then return -1
	
	TRY
		li_sts = ole.display(lbl_attachment, extension)
	CATCH (throwable lt_error1)
		log.log(this, "u_component_attachment.xx_display:0023", "Error editing attachment (" + lt_error1.text + ")", 4)
		return -1
	END TRY
	
	if li_sts < 0 then return -1
	if li_sts = 0 then return 0
	return 1
end if


// If we get here then we're using the generic display logic, which is driven by the c_Attachment_Extension table

ls_display_how = get_attribute("display_how")

CHOOSE CASE lower(ls_display_how)
	CASE "shell"
		ls_file = get_attachment()
		lb_wait_for_completion = false
		ls_verb = get_attribute("display_shell_verb")
		if isnull(ls_verb) then ls_verb = "Open"
		
		li_sts = windows_api.shell32.open_file_ex(ls_file, ls_verb, lb_wait_for_completion, lul_process_id)
		if li_sts < 0 then
			log.log(this, "u_component_attachment.xx_display:0046", "Error calling the Windows Shell ~"" + ls_verb + "~" verb", 4)
			return -1
		end if
	CASE "specify program"
		ls_executable = get_attribute("display_executable")
		ls_arguments = get_attribute("display_arguments")
		
		if len(ls_executable) > 0 then
			// Substitute the file and description into the command
			ls_executable = f_string_substitute(ls_executable, "%ProgramDir%", gnv_app.program_directory)
			ls_executable = f_string_substitute(ls_executable, "%EproCommon%", common_dir)
			
			ls_file = get_attachment()
			if isnull(ls_arguments) then
				ls_arguments = ls_file
			else
				ls_arguments = f_string_substitute(ls_arguments, "%File%", ls_file)
			end if
			
			if common_thread.utilities_ok() then
				TRY
					common_thread.eprolibnet4.of_ExecuteProgram(ls_executable, ls_arguments)
				CATCH (oleruntimeerror lt_error)
					ls_message = "Error Displaying Attachment ~r~n"
					ls_message += ls_executable + "  " + ls_arguments + "~r~n"
					ls_message += lt_error.text + "~r~n" + lt_error.description
					log.log(this, "u_component_attachment.xx_display:0071", ls_message, 4)
					return -1
				END TRY
			else
				log.log(this, "u_component_attachment.xx_display:0076", "Error Displaying Attachment (Utilities not available)", 3)
				return -1
			end if

		end if
	CASE ELSE
		// If we don't have any other instructions then use the old Open_Atachment logic
		ls_file = get_attachment()
		li_sts = f_open_file(ls_file, false)
		if li_sts < 0 then return -1
		if li_sts = 0 then return 0
END CHOOSE

return 1



end function

public function integer xx_render (string ps_file_type, ref string ps_file, integer pi_width, integer pi_height);integer li_sts
string ls_file
blob lbl_attachment
blob lbl_bitmap

if ole_class then
	li_sts = get_attachment_blob(lbl_attachment)
	if li_sts <= 0 then return -1

	TRY
		if isnull(pi_width) then pi_width = 0
		if isnull(pi_height) then pi_height = 0
		lbl_bitmap = ole.render(lbl_attachment, extension, pi_width, pi_height)
	CATCH (throwable lt_error)
		log.log(this, "u_component_attachment.xx_render:0015", "Error rendering attachment (" + lt_error.text + ")", 4)
		return -1
	END TRY

	if isnull(lbl_bitmap) or len(lbl_bitmap) = 0 then
		// attachment wasn't renerable
		return 0
	end if
	
	ps_file = f_temp_file(render_filetype)
	
	li_sts = log.file_write(lbl_bitmap, ps_file)
	if li_sts <= 0 then return -1
	
else
	ls_file = get_attachment()
	
	CHOOSE CASE lower(extension)
		CASE "tif", "tiff"
			li_sts = f_convert_tiff_to_bmp(ls_file, ps_file)
			if li_sts <= 0 then return 0
		CASE ELSE
			ps_file = ls_file
	END CHOOSE
end if

if fileexists(ps_file) then
	return 1
else
	return 0
end if


end function

public function integer render (string ps_file_type, ref string ps_file, integer pi_width, integer pi_height);integer li_sts

if isnull(pi_width) or pi_width <= 0 or isnull(pi_height) or pi_height <= 0 then
	setnull(pi_width)
	setnull(pi_height)
end if

li_sts = xx_render(ps_file_type, ps_file, pi_width, pi_height)

return li_sts

end function

public function integer xx_edit ();integer li_sts
blob lbl_attachment
blob lbl_modified_attachment
unsignedlong lul_process_id
string ls_executable
string ls_arguments
string ls_file
string ls_message
string ls_edit_how
boolean lb_wait_for_completion
string ls_verb
str_file_attributes lstr_file
datetime ldt_before
datetime ldt_after


/////////////////////////////////////////////////////////
// Handle the COM attachment handlers
/////////////////////////////////////////////////////////
if ole_class then
	li_sts = get_attachment_blob(lbl_attachment)
	if li_sts <= 0 then return -1
	
	TRY
		lbl_modified_attachment = ole.edit(lbl_attachment, extension)
	CATCH (throwable lt_error1)
		log.log(this, "u_component_attachment.xx_edit:0027", "Error editing attachment (" + lt_error1.text + ")", 4)
		return -1
	END TRY
	
	if isnull(lbl_modified_attachment) or len(lbl_modified_attachment) = 0 then
		// attachment wasn't edited
		return 0
	end if
	
	li_sts = add_update(lbl_modified_attachment)
	if li_sts <= 0 then return -1
	return 1
end if


// If we get here then we're using the generic edit logic, which is driven by the c_Attachment_Extension table


/////////////////////////////////////////////////////////////////////////////////
// Make sure we have a file and get it's datetime stamp
/////////////////////////////////////////////////////////////////////////////////

ls_file = get_attachment()

if isnull(ls_file) then
	log.log(this, "u_component_attachment.xx_edit:0052", "Null attachment file", 4)
	return -1
end if

if not fileexists(ls_file) then
	log.log(this, "u_component_attachment.xx_edit:0057", "Attachment file does not exist (" + ls_file + ")", 4)
	return -1
end if

li_sts = log.file_attributes(ls_file, lstr_file)
if li_sts <= 0 then
	log.log(this, "u_component_attachment.xx_edit:0063", "Error getting file attributes (" + ls_file + ")", 4)
	return -1
end if

// Get the mod date before editing
ldt_before = datetime(lstr_file.lastwritedate, lstr_file.lastwritetime)



/////////////////////////////////////////////////////////////////////////////////
// Open the file according to the current configuration
/////////////////////////////////////////////////////////////////////////////////

ls_edit_how = get_attribute("edit_how")

CHOOSE CASE lower(ls_edit_how)
	CASE "shell"
		lb_wait_for_completion = false
		ls_verb = get_attribute("edit_shell_verb")
		if isnull(ls_verb) then ls_verb = "Edit"
		
		li_sts = windows_api.shell32.open_file_ex(ls_file, ls_verb, lb_wait_for_completion, lul_process_id)
		if li_sts < 0 then
			log.log(this, "u_component_attachment.xx_edit:0086", "Error calling the Windows Shell ~"" + ls_verb + "~" verb", 4)
			return -1
		end if
	CASE "specify program"
		ls_executable = get_attribute("edit_executable")
		ls_arguments = get_attribute("edit_arguments")
		
		if len(ls_executable) > 0 then
			// Substitute the file and description into the command
			ls_executable = f_string_substitute(ls_executable, "%ProgramDir%", gnv_app.program_directory)
			ls_executable = f_string_substitute(ls_executable, "%EproCommon%", common_dir)
			
			if isnull(ls_arguments) then
				ls_arguments = ls_file
			else
				ls_arguments = f_string_substitute(ls_arguments, "%File%", ls_file)
			end if
			
			if common_thread.utilities_ok() then
				TRY
					common_thread.eprolibnet4.of_ExecuteProgram(ls_executable, ls_arguments)
				CATCH (oleruntimeerror lt_error)
					ls_message = "Error editing Attachment ~r~n"
					ls_message += ls_executable + "  " + ls_arguments + "~r~n"
					ls_message += lt_error.text + "~r~n" + lt_error.description
					log.log(this, "u_component_attachment.xx_edit:0111", ls_message, 4)
					return -1
				END TRY
			else
				log.log(this, "u_component_attachment.xx_edit:0115", "Error editing Attachment (Utilities not available)", 3)
				return -1
			end if
			
		end if
	CASE ELSE
		// If we don't have any other instructions then use the old Open_Atachment logic
		// true = wait until program closes
		li_sts = f_open_file(ls_file, true)
		if li_sts <= 0 then
			log.log(this, "u_component_attachment.xx_edit:0119", "Error opening attachment (" + ls_file + ")", 4)
			return -1
		end if
END CHOOSE

return 1


/////////////////////////////////////////////////////////////////////////////////
// See if the file has changed
/////////////////////////////////////////////////////////////////////////////////

// Get the mod date after editing
li_sts = log.file_attributes(ls_file, lstr_file)
if li_sts <= 0 then
	log.log(this, "u_component_attachment.xx_edit:0134", "Error getting file attributes after editing (" + ls_file + ")", 4)
	return -1
end if
ldt_after = datetime(lstr_file.lastwritedate, lstr_file.lastwritetime)


if ldt_after > ldt_before then
	// The user modified the attachment, so post the updated file into Epro
	li_sts = add_update(ls_file)
	if li_sts <= 0 then
		log.log(this, "u_component_attachment.xx_edit:0144", "Error saving modified attachment (" + ls_file + ")", 4)
		return -1
	end if
end if


return 1


end function

public function integer edit ();integer li_sts

li_sts = xx_edit()

return li_sts

end function

public function integer add_update (string ps_updated_file);blob lbl_attachment
integer li_sts

li_sts = mylog.file_read(ps_updated_file, lbl_attachment)
if li_sts <= 0 then return -1

return add_update(lbl_attachment)

end function

public function integer add_update (blob pbl_attachment);long ll_row
long ll_attachment_progress_sequence
integer li_sts
string ls_find
boolean lb_first_update
blob lbl_original

if local_image then
	attachment_image = pbl_attachment
	local_image_updated = true
	return 1
end if

ls_find = "progress_type='UPDATE'"
ll_row = attachment_progress.find(ls_find, 1, attachment_progress.rowcount())
if ll_row > 0 then
	lb_first_update = false
else
	lb_first_update = true
end if

ll_row = attachment_progress.insertrow(0)
attachment_progress.object.attachment_id[ll_row] = attachment_id
attachment_progress.object.cpr_id[ll_row] = current_patient.cpr_id
if not isnull(current_service) then
	attachment_progress.object.patient_workplan_item_id[ll_row] = current_service.patient_workplan_item_id
end if
attachment_progress.object.user_id[ll_row] = current_user.user_id
attachment_progress.object.progress_date_time[ll_row] = datetime(today(), now())
attachment_progress.object.progress_type[ll_row] = "UPDATE"
attachment_progress.object.created[ll_row] = datetime(today(), now())
attachment_progress.object.created_by[ll_row] = current_scribe.user_id

li_sts = attachment_progress.update()
if li_sts < 0 then return -1

ll_attachment_progress_sequence = attachment_progress.object.attachment_progress_sequence[ll_row]
if ll_attachment_progress_sequence <= 0 then
	tf_rollback()
	log.log(this, "u_component_attachment.add_update:0040", "Unable to get new progress record", 4)
	return -1
end if

UPDATEBLOB p_Attachment_Progress
SET attachment_image = :pbl_attachment
WHERE attachment_id = :attachment_id
AND attachment_progress_sequence = :ll_attachment_progress_sequence;
if not tf_check() then return -1

if storage_flag = "F" then
	// If the attachment is stored as a file the write it out to the proper location
	if lb_first_update then
		// If this is the first time the attachment is updated then read the
		// file into the attachment record so we have a record of the original file
		li_sts = mylog.file_read(attachment_file_path(), lbl_original)
		if li_sts <= 0 then
			tf_rollback()
			log.log(this, "u_component_attachment.add_update:0058", "Error reading original attachment file", 4)
			return -1
		end if
		
		UPDATEBLOB p_Attachment
		SET attachment_image = :lbl_original
		WHERE attachment_id = :attachment_id;
		if not tf_check() then return -1
	end if
	
	li_sts = mylog.file_write(pbl_attachment, attachment_file_path())
	if li_sts <= 0 then
		tf_rollback()
		log.log(this, "u_component_attachment.add_update:0071", "Error writing updated attachment file", 4)
		return -1
	end if
end if

return 1


end function

public function integer add_progress (string ps_progress_type);string ls_progress

setnull(ls_progress)

return add_progress(ps_progress_type, ls_progress)

end function

public function integer add_progress (string ps_progress_type, string ps_progress);long ll_row
integer li_sts
string ls_null

setnull(ls_null)


ll_row = attachment_progress.insertrow(0)
attachment_progress.object.attachment_id[ll_row] = attachment_id
if isvalid(current_patient) and not isnull(current_patient) then
	attachment_progress.object.cpr_id[ll_row] = current_patient.cpr_id
else
	attachment_progress.object.cpr_id[ll_row] = ls_null
end if

if not isnull(current_service) then
	attachment_progress.object.patient_workplan_item_id[ll_row] = current_service.patient_workplan_item_id
end if
attachment_progress.object.user_id[ll_row] = current_user.user_id
attachment_progress.object.progress_date_time[ll_row] = datetime(today(), now())
attachment_progress.object.progress_type[ll_row] = ps_progress_type
attachment_progress.object.progress[ll_row] = ps_progress
attachment_progress.object.created[ll_row] = datetime(today(), now())
attachment_progress.object.created_by[ll_row] = current_scribe.user_id

li_sts = attachment_progress.update()
if li_sts < 0 then return -1

if isvalid(current_patient) and not isnull(current_patient) then
	current_patient.attachments.refresh_attachment(attachment_id)
	attachment_text = current_patient.attachments.attachment_text(attachment_id)
end if



return 1


end function

public function string get_attachment ();string ls_file
integer li_sts

ls_file = f_temp_file(extension)
if isnull(ls_file) then return ls_file

li_sts = save_as(ls_file)
if li_sts <= 0 then setnull(ls_file)

return ls_file

end function

public function integer get_attachment_blob (ref blob pbl_attachment);Integer		li_sts
Blob			lbl_attachment
String		ls_file_path,ls_find,ls_file
Long			ll_row,ll_attachment_progress_sequence
long ll_length

if local_image then
	ll_length = len(attachment_image)
	if ll_length <= 0 then return 0
	pbl_attachment = attachment_image
else
	If storage_flag = "D" then
		ls_find = "progress_type='UPDATE'"
		ll_row = attachment_progress.find(ls_find, attachment_progress.rowcount(), 1)
		If ll_row > 0 then
			// If the attachment has been updated then get the latest update
			ll_attachment_progress_sequence = attachment_progress.object.attachment_progress_sequence[ll_row]
			SELECTBLOB attachment_image
			INTO :lbl_attachment
			FROM p_Attachment_Progress
			WHERE attachment_id = :attachment_id
			AND attachment_progress_sequence = :ll_attachment_progress_sequence
			USING cprdb;
			if not cprdb.check() then return -1
		Else
			SELECTBLOB attachment_image
			INTO :lbl_attachment
			FROM p_Attachment
			WHERE attachment_id = :attachment_id
			USING cprdb;
			if not cprdb.check() then return -1
		End if
	Else
		ls_file_path = attachment_file_path()
		if isnull(ls_file_path) then return -1
		ls_file = f_temp_file(extension)
		if isnull(ls_file) then return -1
		li_sts = mylog.file_copy(ls_file_path,ls_file)
		if li_sts <= 0 then return -1
		li_sts = mylog.file_read(ls_file, lbl_attachment)
		if li_sts <= 0 then return -1
	End if
	pbl_attachment = lbl_attachment
end if


return 1




end function

protected function boolean xx_is_editable ();boolean lb_is_editable

if ole_class then
	TRY
		lb_is_editable = ole.is_editable(extension)
	CATCH (throwable lt_error)
		log.log(this, "u_component_attachment.xx_is_editable:0007", "Error calling is_editable (" + lt_error.text + ")", 4)
		return false
	END TRY
else
	lb_is_editable = true
end if

return lb_is_editable

end function

protected function boolean xx_is_transcribeable ();return true


end function

public function boolean is_transcribeable ();return xx_is_transcribeable()



end function

protected function boolean xx_is_displayable ();boolean lb_is_displayable

if ole_class then
	TRY
		lb_is_displayable = ole.is_displayable(extension)
	CATCH (throwable lt_error)
		log.log(this, "u_component_attachment.xx_is_displayable:0007", "Error calling is_displayable (" + lt_error.text + ")", 4)
		return false
	END TRY
else
	lb_is_displayable = true
end if

return lb_is_displayable

end function

public function boolean is_displayable ();return xx_is_displayable()



end function

public function boolean is_editable ();return xx_is_editable()



end function

public function integer transcribe ();integer li_sts

li_sts = xx_transcribe()
return li_sts


end function

public function integer edit_attachment (string ps_attachment_file);str_file_attributes lstr_file
integer li_sts
datetime ldt_before
datetime ldt_after


if isnull(ps_attachment_file) then
	log.log(this, "u_component_attachment.edit_attachment:0008", "Null attachment file", 4)
	return -1
end if

if not fileexists(ps_attachment_file) then
	log.log(this, "u_component_attachment.edit_attachment:0013", "Attachment file does not exist (" + ps_attachment_file + ")", 4)
	return -1
end if

li_sts = log.file_attributes(ps_attachment_file, lstr_file)
if li_sts <= 0 then
	log.log(this, "u_component_attachment.edit_attachment:0019", "Error getting file attributes (" + ps_attachment_file + ")", 4)
	return -1
end if

// Get the mod date before editing
ldt_before = datetime(lstr_file.lastwritedate, lstr_file.lastwritetime)

// true = wait until program closes
li_sts = f_open_file(ps_attachment_file, true)
if li_sts <= 0 then
	log.log(this, "u_component_attachment.edit_attachment:0029", "Error opening attachment (" + ps_attachment_file + ")", 4)
	return -1
end if

// Get the mod date after editing
li_sts = log.file_attributes(ps_attachment_file, lstr_file)
if li_sts <= 0 then
	log.log(this, "u_component_attachment.edit_attachment:0036", "Error getting file attributes after editing (" + ps_attachment_file + ")", 4)
	return -1
end if
ldt_after = datetime(lstr_file.lastwritedate, lstr_file.lastwritetime)


if ldt_after > ldt_before then
	// The user modified the attachment
	li_sts = add_update(ps_attachment_file)
	if li_sts <= 0 then
		log.log(this, "u_component_attachment.edit_attachment:0046", "Error saving modified attachment (" + ps_attachment_file + ")", 4)
		return -1
	end if
end if


return 1


end function

public function integer edit_attachment ();string ls_file

ls_file = get_attachment()
if isnull(ls_file) then
	log.log(this, "u_component_attachment.edit_attachment:0005", "Error getting attachment file", 4)
	return -1
end if

return edit_attachment(ls_file)

end function

public function integer xx_review ();integer li_sts
w_attachment_review lw_window

openwithparm(lw_window, this, "w_attachment_review", f_active_window())


return 1

end function

public function integer review ();integer li_sts

li_sts = xx_review()

return li_sts

end function

public function integer open_attachment ();string ls_file

ls_file = get_attachment()
if isnull(ls_file) then
	log.log(this, "u_component_attachment.open_attachment:0005", "Error getting attachment file", 4)
	return -1
end if

return open_attachment(ls_file)

end function

public function integer open_attachment (string ps_attachment_file);return f_open_file(ps_attachment_file, false)

end function

public function integer open_attachment (string ps_action, boolean pb_wait_for_completion, ref unsignedlong pul_process_id);string ls_file
integer li_sts

ls_file = get_attachment()
if isnull(ls_file) then
	log.log(this, "u_component_attachment.open_attachment:0006", "Error getting attachment file", 4)
	return -1
end if

li_sts = f_open_file_with_process(ls_file, ps_action, pb_wait_for_completion, pul_process_id)

if li_sts > 0 and pul_process_id > 0 then
	add_attribute("open_attachment_process_id", string(pul_process_id))
end if	

return li_sts


end function

protected function boolean xx_is_interpretable ();boolean lb_is_interpretable

if ole_class then
	TRY
		lb_is_interpretable = ole.is_interpretable(extension)
	CATCH (throwable lt_error)
		log.log(this, "u_component_attachment.xx_is_interpretable:0007", "Error calling is_interpretable (" + lt_error.text + ")", 4)
		return false
	END TRY
else
	lb_is_interpretable = false
end if

return lb_is_interpretable

end function

public function boolean is_interpretable ();return xx_is_interpretable()



end function

public function integer interpret ();//return xx_interpret()
return 1

end function

protected function integer xx_interpret ();integer li_sts
blob lbl_attachment
string ls_xml

li_sts = get_attachment_blob(lbl_attachment)
if li_sts <= 0 then return -1

if ole_class then
	TRY
		ls_xml = ole.interpret(lbl_attachment, extension)
	CATCH (throwable lt_error)
		log.log(this, "u_component_attachment.xx_interpret:0012", "Error editing attachment (" + lt_error.text + ")", 4)
		return -1
	END TRY
	
	if len(ls_xml) <= 0 then return 0
else
	// By default we don't actually interpret it
	return 0
end if

return 1

end function

public function string get_attachment_for_display ();string ls_file
integer li_sts

ls_file = f_temp_file(extension)
if isnull(ls_file) then return ls_file

li_sts = save_as(ls_file)
if li_sts <= 0 then setnull(ls_file)

return ls_file

end function

public function string render ();string ls_file_type
string ls_file
integer li_width
integer li_height
integer li_sts

setnull(ls_file_type)
setnull(li_width)
setnull(li_height)

li_sts = render(ls_file_type, ls_file, li_width, li_height)
if li_sts <= 0 then
	setnull(ls_file)
end if

return ls_file

end function

public function integer save_as ();string ls_filename
Integer					li_sts
string lsa_paths[]
string lsa_files[]
string ls_filter
integer li_count


//openfilename.of_getopenfilename( /*long al_hwnd*/, /*string as_title*/, /*ref string as_pathname[]*/, /*ref string as_filename[]*/, /*string as_filter */)
ls_filter = upper(extension) + " Files (*." + lower(extension) + "), *." + lower(extension)

ls_filename = windows_api.comdlg32.getsavefilename( handle(w_main), &
															"Save Attachment To File", &
															ls_filter)
if isnull(ls_filename) then return -1

if lower(right(ls_filename, len(extension))) <> lower(extension) then
	ls_filename += "." + extension
end if

return save_as(ls_filename)

end function

protected function boolean xx_is_printable ();boolean lb_is_printable

if ole_class then
	TRY
		lb_is_printable = ole.is_printable(extension)
	CATCH (throwable lt_error)
		log.log(this, "u_component_attachment.xx_is_printable:0007", "Error calling is_printable (" + lt_error.text + ")", 4)
		return false
	END TRY
else
	lb_is_printable = true
end if

return lb_is_printable

end function

public function boolean is_printable ();return xx_is_printable()



end function

public function integer print ();string ls_printer

ls_printer = get_attribute("Printer")

return print(ls_printer)


end function

public function integer xx_print ();integer li_sts
blob lbl_attachment
unsignedlong lul_process_id
string ls_executable
string ls_arguments
string ls_file
string ls_printer
string ls_message
string ls_print_how
boolean lb_wait_for_completion
string ls_verb
long ll_timeout

/////////////////////////////////////////////////////////
// Handle the COM attachment handlers
/////////////////////////////////////////////////////////
if ole_class then
	li_sts = get_attachment_blob(lbl_attachment)
	if li_sts <= 0 then return -1
	
	TRY
		li_sts = ole.display(lbl_attachment, extension)
	CATCH (throwable lt_error1)
		log.log(this, "u_component_attachment.xx_print:0024", "Error editing attachment (" + lt_error1.text + ")", 4)
		return -1
	END TRY
	
	if li_sts < 0 then return -1
	if li_sts = 0 then return 0
	return 1
end if


// If we get here then we're using the generic printer logic, which is driven by the c_Attachment_Extension table

ls_printer = get_attribute("printer")
ls_print_how = get_attribute("print_how")

CHOOSE CASE lower(ls_print_how)
	CASE "shell"
		ls_file = get_attachment()
		lb_wait_for_completion = false
		ls_verb = get_attribute("print_shell_verb")
		if isnull(ls_verb) then ls_verb = "Print"
		
		li_sts = windows_api.shell32.open_file_ex(ls_file, ls_verb, lb_wait_for_completion, lul_process_id)
		if li_sts < 0 then
			log.log(this, "u_component_attachment.xx_print:0048", "Error calling the Windows Shell ~"" + ls_verb + "~" verb", 4)
			return -1
		end if
	CASE "epro image"
		// This option is not support for printing
		log.log(this, "u_component_attachment.xx_print:0053", "Epro Image is not supported for printing", 4)
		return -1
	CASE "specify program"
		ls_executable = get_attribute("print_executable")
		ls_arguments = get_attribute("print_arguments")
		
		if len(ls_executable) > 0 then
			// Substitute the file and description into the command
			ls_executable = f_string_substitute(ls_executable, "%ProgramDir%", gnv_app.program_directory)
			ls_executable = f_string_substitute(ls_executable, "%EproCommon%", common_dir)
			
			ls_file = get_attachment()
			if isnull(ls_arguments) then
				ls_arguments = ls_file
			else
				ls_arguments = f_string_substitute(ls_arguments, "%File%", ls_file)
				ls_arguments = f_string_substitute(ls_arguments, "%Printer%", ls_printer)
			end if
			
			if common_thread.utilities_ok() then
				TRY
					get_attribute("print_program_timeout_" + gnv_app.cpr_mode, ll_timeout)
					if isnull(ll_timeout) then
						if gnv_app.cpr_mode = "CLIENT" then
							// Default client timeout = 10 minutes
							ll_timeout = 600000
						else
							// Default other timeout = 20 seconds
							ll_timeout = 20000
						end if
					end if
					
					common_thread.eprolibnet4.of_ExecuteProgramTimeout(ls_executable, ls_arguments, ll_timeout)
				CATCH (oleruntimeerror lt_error)
					ls_message = "Error Printing Attachment ~r~n"
					ls_message += ls_executable + "  " + ls_arguments + "~r~n"
					ls_message += lt_error.text + "~r~n" + lt_error.description
					log.log(this, "u_component_attachment.xx_print:0089", ls_message, 4)
					return -1
				END TRY
			else
				log.log(this, "u_component_attachment.xx_print:0094", "Error printing Attachment (Utilities not available)", 3)
				return -1
			end if
		end if
	CASE ELSE
		// If we don't have any other instructions then use the old Open_Atachment logic
		li_sts = open_attachment("print", false, lul_process_id)
		if li_sts < 0 then return -1
		if li_sts = 0 then return 0
END CHOOSE

return 1



end function

public function integer get_attachment (ref str_external_observation_attachment pstr_attachment);integer li_sts

li_sts = get_attachment_blob(pstr_attachment.attachment)
if li_sts <= 0 then return -1

pstr_attachment.attachment_type = attachment_type
pstr_attachment.extension = extension
pstr_attachment.attachment_comment_title = attachment_tag
setnull(pstr_attachment.filename)
pstr_attachment.message_id = id



return 1

end function

public subroutine set_attachment_data (string ps_extension, blob pbl_data);
extension = ps_extension
attachment_image = pbl_data
local_image = true
local_image_updated = false

load_extension_attributes()

end subroutine

public subroutine set_attachment_data (string ps_attachment_tag, string ps_attachment_file, string ps_extension, blob pbl_data);
attachment_tag = ps_attachment_tag
attachment_file = ps_attachment_file
extension = ps_extension
attachment_image = pbl_data
local_image = true
local_image_updated = false

load_extension_attributes()

end subroutine

public function integer print (string ps_printer);integer li_sts
boolean lb_use_default_printer

if isnull(ps_printer) then
	get_attribute("use_default_printer", lb_use_default_printer)
	if gnv_app.cpr_mode = "CLIENT" and not lb_use_default_printer then
		ps_printer = common_thread.select_printer()
		// If the user didn't select a printer then don't do anything
		if isnull(ps_printer) then return 0
	end if
end if


if len(ps_printer) > 0 then
	add_attribute("Printer", ps_printer)
	common_thread.set_printer(ps_printer)
end if
	
li_sts = xx_print()

add_progress("Printed", ps_printer)

// Set the printer back to the default
if len(ps_printer) > 0 then
	common_thread.set_default_printer()
end if

return li_sts

end function

public subroutine load_extension_attributes ();u_ds_data luo_data
long ll_count
str_attributes lstr_attributes

luo_data = CREATE u_ds_data

luo_data.set_dataobject("dw_c_attachment_extension_attribute")
ll_count = luo_data.retrieve(extension)
if ll_count > 0 then f_attribute_ds_to_str(luo_data, lstr_attributes)

DESTROY luo_data

add_attributes(lstr_attributes)

return


end subroutine

on u_component_attachment.create
call super::create
end on

on u_component_attachment.destroy
call super::destroy
end on

event constructor;call super::constructor;integer li_sts
environment lo_env
unsignedlong ll_ppidl
boolean lb_sts
string ls_common_files

attachment_progress = CREATE u_ds_data
attachment_progress.set_dataobject("dw_p_attachment_progress")

li_sts = windows_api.shell32.shgetspecialfolderlocation( handle(main_window), &
																windows_api.shell32.CSIDL_COMMONFILES , &
																ll_ppidl)
if li_sts = 0 then
	ls_common_files = space(500)
	lb_sts = windows_api.shell32.shgetpathfromidlist(ll_ppidl, ls_common_files)
	if lb_sts then
		ls_common_files = trim(ls_common_files)
		if right(ls_common_files, 1) <> "\" then ls_common_files += "\"
		common_dir = ls_common_files + "EncounterPRO-OS"
	else
		openwithparm(w_pop_message, "An error occured getting windows environment information (shgetpathfromidlist).")
		return -1
	end if
	windows_api.shell32.CoTaskMemFree(ll_ppidl)
else
	openwithparm(w_pop_message, "An error occured getting windows environment information (shgetspecialfolderlocation - " + string(li_sts) + ").")
	return -1
end if

end event

event destructor;call super::destructor;DESTROY attachment_progress

end event

