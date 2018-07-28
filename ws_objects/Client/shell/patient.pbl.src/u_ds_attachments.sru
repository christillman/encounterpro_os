$PBExportHeader$u_ds_attachments.sru
$PBExportComments$new_attachment,new_attachment_record are called from utility images.
forward
global type u_ds_attachments from u_ds_base_class
end type
end forward

global type u_ds_attachments from u_ds_base_class
string dataobject = "dw_p_attachment"
string context_object = "Attachment"
end type
global u_ds_attachments u_ds_attachments

type variables

end variables

forward prototypes
public function integer attachment_list (ref u_attachment_list puo_attachment_list, string ps_find)
public function integer assessment_attachment_list (ref u_attachment_list puo_attachment_list, long pl_problem_id)
public function integer treatment_attachment_list (ref u_attachment_list puo_attachment_list, long pl_treatment_id)
public function integer observation_attachment_list (ref u_attachment_list puo_attachment_list, long pl_observation_sequence)
public function integer patient_attachment_list (ref u_attachment_list puo_attachment_list)
public function integer encounter_attachment_list (ref u_attachment_list puo_attachment_list, long pl_encounter_id)
public function long new_attachment (ref str_attachment pstr_attachment, string ps_file)
public function integer refresh_attachment (long pl_attachment_id)
public function string attachment_text (long pl_attachment_id)
public function string attachment_extension_description (long pl_attachment_id)
public function string attachment_extension (long pl_attachment_id)
private function long new_attachment_record (ref str_attachment pstr_attachment, string ps_attachment_object)
public function long new_attachment (ref str_attachment pstr_attachment, blob pbl_attachment)
public function long new_attachment (ref str_attachment pstr_attachment, blob pbl_attachment, string ps_attachment_object)
public function integer attachment_list (ref u_attachment_list puo_attachment_list, long pl_attachment_id)
public function string attachment_file_path (str_attachment pstr_attachment)
public function integer attachment (ref u_component_attachment puo_attachment, long pl_attachment_id)
private function integer new_attachment_record (ref str_attachment pstr_attachment)
public function long new_attachment (ref str_attachment pstr_attachment, string ps_file, string ps_attachment_object)
public function long new_attachment (ref str_attachment pstr_attachment, string ps_file, string ps_attachment_object, string ps_progress_type)
private function long new_attachment_record (ref str_attachment pstr_attachment, string ps_attachment_object, string ps_progress_type)
public function long new_attachment (ref str_attachment pstr_attachment, blob pbl_attachment, string ps_attachment_object, string ps_progress_type)
public function integer add_progress (long pl_attachment_id, string ps_progress_type, string ps_progress)
public function string description (long pl_attachment_id)
public function long get_attachment_row (long pl_attachment_id)
public function long find_object_row (long pl_object_key)
public function str_property_value get_property (long pl_object_key, string ps_property, str_attributes pstr_attributes)
public function integer attachment_blob (long pl_attachment_id, ref blob pbl_attachment)
public function str_attachment get_attachment_structure (long pl_row)
public function string get_attachment (long pl_attachment_id)
public function string attachment_folder (long pl_attachment_id)
public subroutine display_properties (long pl_attachment_id)
public function integer delete_attachment (long pl_attachment_id)
public subroutine post_attachment (long pl_attachment_id, string ps_context_object, long pl_object_key)
public subroutine menu (long pl_attachment_id, string ps_context_object, long pl_object_key)
public function str_progress_list get_attachments (string ps_context_object, long pl_object_key, string ps_progress_type, string ps_progress_key)
public function integer generate_new_file_name (ref str_attachment pstr_attachment)
public function integer attachment_save_as (long pl_attachment_id, string ps_file)
private function long new_attachment_record (ref str_attachment pstr_attachment, string ps_attachment_object, string ps_progress_type, string ps_progress_key)
public function long new_attachment (ref str_attachment pstr_attachment, string ps_file, string ps_attachment_object, string ps_progress_type, string ps_progress_key)
public function long new_attachment (ref str_attachment pstr_attachment, blob pbl_attachment, string ps_attachment_object, string ps_progress_type, string ps_progress_key)
public function integer ocr_attachment (long pl_attachment_id, string ps_context_object, long pl_object_key)
public function integer store_attachment_database (long pl_attachment_id)
public function integer add_progress (long pl_attachment_id, string ps_progress_type, string ps_progress, ref long pl_attachment_progress_sequence)
public function integer move_all_attachments_to_database ()
public function integer store_attachment_file (long pl_attachment_id)
public function long find_attachments (string ps_find, ref str_attachment pstr_attachment[])
end prototypes

public function integer attachment_list (ref u_attachment_list puo_attachment_list, string ps_find);integer li_rows

if isnull(puo_attachment_list) or not isvalid(puo_attachment_list) then puo_attachment_list = CREATE u_attachment_list

if isnull(ps_find) or trim(ps_find) = "" then
	puo_attachment_list.attachment_count = 0
	return 0
end if

setfilter(ps_find)
filter()

li_rows = rowcount()

if li_rows > 0 then
	puo_attachment_list.attachments.object.data = object.data
	puo_attachment_list.attachment_count = li_rows
else
	puo_attachment_list.attachment_count = 0
	puo_attachment_list.attachments.reset()
end if

setnull(puo_attachment_list.attachment_id)

setfilter("")
filter()

puo_attachment_list.attachments.settransobject(sqlca)
puo_attachment_list.attachments.resetupdate()

return li_rows


end function

public function integer assessment_attachment_list (ref u_attachment_list puo_attachment_list, long pl_problem_id);string ls_find
integer li_sts


if isnull(puo_attachment_list) or not isvalid(puo_attachment_list) then puo_attachment_list = CREATE u_attachment_list

puo_attachment_list.attachments.dataobject = "dw_p_attachment_assessment"
puo_attachment_list.attachments.settransobject(sqlca)
puo_attachment_list.attachment_count = puo_attachment_list.attachments.retrieve(current_patient.cpr_id, pl_problem_id)

if puo_attachment_list.attachment_count < 0 then return -1

return 1


end function

public function integer treatment_attachment_list (ref u_attachment_list puo_attachment_list, long pl_treatment_id);string ls_find
integer li_sts


if isnull(puo_attachment_list) or not isvalid(puo_attachment_list) then puo_attachment_list = CREATE u_attachment_list

puo_attachment_list.attachments.dataobject = "dw_p_attachment_treatment"
puo_attachment_list.attachments.settransobject(sqlca)
puo_attachment_list.attachment_count = puo_attachment_list.attachments.retrieve(current_patient.cpr_id, pl_treatment_id)

if puo_attachment_list.attachment_count < 0 then return -1

return 1


end function

public function integer observation_attachment_list (ref u_attachment_list puo_attachment_list, long pl_observation_sequence);string ls_find
integer li_sts


if isnull(puo_attachment_list) or not isvalid(puo_attachment_list) then puo_attachment_list = CREATE u_attachment_list

puo_attachment_list.attachments.dataobject = "dw_p_attachment_observation"
puo_attachment_list.attachments.settransobject(sqlca)
puo_attachment_list.attachment_count = puo_attachment_list.attachments.retrieve(current_patient.cpr_id, pl_observation_sequence)

if puo_attachment_list.attachment_count < 0 then return -1

return 1


end function

public function integer patient_attachment_list (ref u_attachment_list puo_attachment_list);string ls_find
integer li_sts


if isnull(puo_attachment_list) or not isvalid(puo_attachment_list) then puo_attachment_list = CREATE u_attachment_list

puo_attachment_list.attachments.dataobject = "dw_p_attachment_patient"
puo_attachment_list.attachments.settransobject(sqlca)
puo_attachment_list.attachment_count = puo_attachment_list.attachments.retrieve(current_patient.cpr_id)

if puo_attachment_list.attachment_count < 0 then return -1

return 1


end function

public function integer encounter_attachment_list (ref u_attachment_list puo_attachment_list, long pl_encounter_id);string ls_find
integer li_sts


if isnull(puo_attachment_list) or not isvalid(puo_attachment_list) then puo_attachment_list = CREATE u_attachment_list

puo_attachment_list.attachments.dataobject = "dw_p_attachment_encounter"
puo_attachment_list.attachments.settransobject(sqlca)
puo_attachment_list.attachment_count = puo_attachment_list.attachments.retrieve(current_patient.cpr_id, pl_encounter_id)

if puo_attachment_list.attachment_count < 0 then return -1

return 1


end function

public function long new_attachment (ref str_attachment pstr_attachment, string ps_file);string ls_attachment_object

setnull(ls_attachment_object)

return new_attachment(pstr_attachment, ps_file, ls_attachment_object)

end function

public function integer refresh_attachment (long pl_attachment_id);long ll_row
string ls_find
string ls_status
integer li_sts
string ls_cpr_id

ls_find = "attachment_id=" + string(pl_attachment_id)
ll_row = find(ls_find, 1, rowcount())
if ll_row > 0 then
	reselectrow(ll_row)
	// If the record has been deleted, the reselect the attachment records
	ls_status = object.status[ll_row]
	if ls_status = "DELETED" then
		ls_cpr_id = object.cpr_id[ll_row]
		li_sts = retrieve(ls_cpr_id)
	end if
	return 1
end if

return 0




end function

public function string attachment_text (long pl_attachment_id);long ll_row
string ls_find
string ls_null

setnull(ls_null)

ls_find = "attachment_id=" + string(pl_attachment_id)
ll_row = find(ls_find, 1, rowcount())
if ll_row > 0 then
	return string(object.attachment_text[ll_row])
end if

return ls_null




end function

public function string attachment_extension_description (long pl_attachment_id);long ll_row
string ls_find
string ls_null
string ls_extension
string ls_description

setnull(ls_description)

ls_find = "attachment_id=" + string(pl_attachment_id)
ll_row = find(ls_find, 1, rowcount())
if ll_row > 0 then
	ls_extension = object.extension[ll_row]
	ls_description = datalist.extension_description(ls_extension)
	if isnull(ls_description) then ls_description = ls_extension
end if

return ls_description




end function

public function string attachment_extension (long pl_attachment_id);long ll_row
string ls_find
string ls_null
string ls_extension
string ls_description

setnull(ls_description)

ls_find = "attachment_id=" + string(pl_attachment_id)
ll_row = find(ls_find, 1, rowcount())
if ll_row > 0 then
	ls_extension = object.extension[ll_row]
end if

return ls_extension




end function

private function long new_attachment_record (ref str_attachment pstr_attachment, string ps_attachment_object);string ls_progress_type

setnull(ls_progress_type)

return new_attachment_record(pstr_attachment, ps_attachment_object, ls_progress_type)

end function

public function long new_attachment (ref str_attachment pstr_attachment, blob pbl_attachment);string ls_attachment_object

setnull(ls_attachment_object)

return new_attachment(pstr_attachment, pbl_attachment, ls_attachment_object)

end function

public function long new_attachment (ref str_attachment pstr_attachment, blob pbl_attachment, string ps_attachment_object);string ls_progress_type

setnull(ls_progress_type)

return new_attachment(pstr_attachment, pbl_attachment, ps_attachment_object, ls_progress_type)

end function

public function integer attachment_list (ref u_attachment_list puo_attachment_list, long pl_attachment_id);string ls_find
integer li_sts

ls_find = "attachment_id=" + string(pl_attachment_id)

li_sts = attachment_list(puo_attachment_list, ls_find)

if li_sts <= 0 then return li_sts

puo_attachment_list.attachment_id = pl_attachment_id

return 1


end function

public function string attachment_file_path (str_attachment pstr_attachment);string ls_filepath
string ls_filespec
string ls_filename
integer i
string ls_null

setnull(ls_null)

if trim(pstr_attachment.attachment_file_path) = "" then setnull(pstr_attachment.attachment_file_path)

if isnull(pstr_attachment.attachment_file) or (trim(pstr_attachment.attachment_file) = "") then
	log.log(this, "attachment_file_path()", "No attachment file name", 4)
	return ls_null
end if

if isnull(pstr_attachment.extension) or (trim(pstr_attachment.extension) = "") then
	log.log(this, "attachment_file_path()", "No attachment file extension", 4)
	return ls_null
end if

ls_filepath = f_patient_file_path(pstr_attachment.cpr_id)

if len(pstr_attachment.attachment_file_path) > 0 then
	ls_filepath += pstr_attachment.attachment_file_path
	if right(ls_filepath, 1) <> "\" then ls_filepath += "\"
end if

ls_filespec = ls_filepath + pstr_attachment.attachment_file + "." + pstr_attachment.extension

return ls_filespec

end function

public function integer attachment (ref u_component_attachment puo_attachment, long pl_attachment_id);long ll_row
string ls_find
string ls_attachment_type
string ls_extension
string ls_component_id
long ll_count

if isnull(pl_attachment_id) then
	setnull(puo_attachment)
	return 0
end if

ls_find = "attachment_id=" + string(pl_attachment_id)

ll_row = find(ls_find, 1, rowcount())

if ll_row <= 0 then
	// Before giving up, try re-retrieving the attachments
	if isnull(current_patient) then
		set_dataobject("dw_p_attachment_single")
		ll_count = retrieve(pl_attachment_id)
		if ll_count <= 0 then
			log.log(this, "attachment()", "Error retrieving attachment (" + string(pl_attachment_id) + ")", 4)
			return -1
		end if
		ll_row = 1
	else
		set_dataobject("dw_p_attachment")
		retrieve(current_patient.cpr_id)
		ll_row = find(ls_find, 1, rowcount())
	end if

	if ll_row <= 0 then
		setnull(puo_attachment)
		return 0
	end if
end if

ls_attachment_type = object.attachment_type[ll_row]
ls_extension = object.extension[ll_row]
ls_component_id = datalist.extension_component_id(ls_extension)
if isnull(ls_component_id) then ls_component_id = "ATCH_GENERIC"

puo_attachment = component_manager.get_component(ls_component_id)
if isnull(puo_attachment) then
	log.log(this, "attachment()", "Unable to get component (" + ls_component_id + ")", 4)
	setnull(puo_attachment)
	return -1
end if

puo_attachment.attachment_id = object.attachment_id[ll_row]
puo_attachment.cpr_id = object.cpr_id[ll_row]
puo_attachment.encounter_id = object.encounter_id[ll_row]
puo_attachment.problem_id = object.problem_id[ll_row]
puo_attachment.treatment_id = object.treatment_id[ll_row]
puo_attachment.observation_sequence = object.observation_sequence[ll_row]
puo_attachment.attachment_type = object.attachment_type[ll_row]
puo_attachment.attachment_tag = object.attachment_tag[ll_row]
puo_attachment.attachment_file_path = object.attachment_file_path[ll_row]
puo_attachment.attachment_file = object.attachment_file[ll_row]
puo_attachment.extension = object.extension[ll_row]
puo_attachment.attachment_text = object.attachment_text[ll_row]
puo_attachment.storage_flag = object.storage_flag[ll_row]
puo_attachment.attachment_date = object.attachment_date[ll_row]
puo_attachment.attachment_folder = object.attachment_folder[ll_row]
puo_attachment.attached_by = object.attached_by[ll_row]
puo_attachment.created = object.created[ll_row]
puo_attachment.created_by = object.created_by[ll_row]
puo_attachment.status = object.status[ll_row]
puo_attachment.context_object = object.context_object[ll_row]
puo_attachment.object_key = object.object_key[ll_row]
puo_attachment.id = object.id[ll_row]

puo_attachment.originator = user_list.find_user(puo_attachment.attached_by)

puo_attachment.attachment_progress.retrieve(puo_attachment.attachment_id)

puo_attachment.load_extension_attributes()

return 1


end function

private function integer new_attachment_record (ref str_attachment pstr_attachment);long ll_row
integer li_sts
string ls_cpr_id

if isnull(pstr_attachment.status) or trim(pstr_attachment.status) = "" then
	pstr_attachment.status ="OK"
end if

if trim(pstr_attachment.attachment_folder) = "" then setnull(pstr_attachment.attachment_folder)
if trim(pstr_attachment.attachment_tag) = "" then setnull(pstr_attachment.attachment_tag)
if trim(pstr_attachment.attachment_file_path) = "" then setnull(pstr_attachment.attachment_file_path)
if pstr_attachment.encounter_id <= 0 then setnull(pstr_attachment.encounter_id)
if pstr_attachment.treatment_id <= 0 then setnull(pstr_attachment.treatment_id)
if pstr_attachment.observation_sequence <= 0 then setnull(pstr_attachment.observation_sequence)
if pstr_attachment.problem_id <= 0 then setnull(pstr_attachment.problem_id)
if pstr_attachment.interfaceserviceid <= 0 then setnull(pstr_attachment.interfaceserviceid)

pstr_attachment.attachment_date = datetime(today(), now())
pstr_attachment.attached_by = current_user.user_id
pstr_attachment.created = datetime(today(), now())
pstr_attachment.created_by = current_scribe.user_id

// Limit length of user-enterable string fields
pstr_attachment.attachment_tag = left(pstr_attachment.attachment_tag, 80)

ll_row = insertrow(0)
object.cpr_id[ll_row] = pstr_attachment.cpr_id
object.encounter_id[ll_row] = pstr_attachment.encounter_id
object.problem_id[ll_row] = pstr_attachment.problem_id
object.treatment_id[ll_row] = pstr_attachment.treatment_id
object.observation_sequence[ll_row] = pstr_attachment.observation_sequence
object.attachment_type[ll_row] = pstr_attachment.attachment_type
object.attachment_tag[ll_row] = pstr_attachment.attachment_tag
object.attachment_file_path[ll_row] = pstr_attachment.attachment_file_path
object.attachment_file[ll_row] = pstr_attachment.attachment_file
object.extension[ll_row] = pstr_attachment.extension
object.storage_flag[ll_row] = pstr_attachment.storage_flag
object.attachment_date[ll_row] = pstr_attachment.attachment_date
object.attachment_folder[ll_row] = pstr_attachment.attachment_folder
object.attached_by[ll_row] = pstr_attachment.attached_by
object.created[ll_row] = pstr_attachment.created
object.created_by[ll_row] = pstr_attachment.created_by
object.status[ll_row] = pstr_attachment.status
object.interfaceserviceid[ll_row] = pstr_attachment.interfaceserviceid

li_sts = update()
if li_sts < 0 then return -1

pstr_attachment.attachment_id = object.attachment_id[ll_row]

select cpr_id
INTO :ls_cpr_id
FROM p_Attachment
WHERE attachment_id = :pstr_attachment.attachment_id;
if not tf_check() then return -1
if f_string_modified(ls_cpr_id, pstr_attachment.cpr_id) then
	SELECT max(attachment_id)
	INTO :pstr_attachment.attachment_id
	FROM p_Attachment
	WHERE cpr_id = :pstr_attachment.cpr_id;
	if isnull(pstr_attachment.attachment_id) then return -1
end if

if isnull(pstr_attachment.attachment_id) or pstr_attachment.attachment_id <= 0 then
	log.log(this, "new_attachment_record()", "Unable to determine attachment_id", 4)
	return -1
end if

if not isnull(pstr_attachment.attachment_text) and trim(pstr_attachment.attachment_text) <> "" then
	li_sts = add_progress(pstr_attachment.attachment_id, "TEXT", pstr_attachment.attachment_text)
	if li_sts <= 0 then return -1
end if

return 1



end function

public function long new_attachment (ref str_attachment pstr_attachment, string ps_file, string ps_attachment_object);string ls_progress_type

setnull(ls_progress_type)

return new_attachment(pstr_attachment, ps_file, ps_attachment_object, ls_progress_type)

end function

public function long new_attachment (ref str_attachment pstr_attachment, string ps_file, string ps_attachment_object, string ps_progress_type);string ls_progress_key

setnull(ls_progress_key)

return new_attachment(pstr_attachment, ps_file, ps_attachment_object, ps_progress_type, ls_progress_key)

end function

private function long new_attachment_record (ref str_attachment pstr_attachment, string ps_attachment_object, string ps_progress_type);string ls_progress_key

setnull(ls_progress_key)

return new_attachment_record(pstr_attachment, ps_attachment_object, ps_progress_type, ls_progress_key)

end function

public function long new_attachment (ref str_attachment pstr_attachment, blob pbl_attachment, string ps_attachment_object, string ps_progress_type);string ls_progress_key

setnull(ls_progress_key)

return new_attachment(pstr_attachment, pbl_attachment, ps_attachment_object, ps_progress_type, ls_progress_key)


end function

public function integer add_progress (long pl_attachment_id, string ps_progress_type, string ps_progress);long ll_attachment_progress_sequence
integer li_sts

li_sts = add_progress(pl_attachment_id, ps_progress_type, ps_progress, ll_attachment_progress_sequence)

return li_sts


end function

public function string description (long pl_attachment_id);long ll_row
string ls_find
string ls_null
string ls_description
string ls_attachment_type
setnull(ls_description)

ls_find = "attachment_id=" + string(pl_attachment_id)
ll_row = find(ls_find, 1, rowcount())
if ll_row > 0 then
	ls_description = object.attachment_tag[ll_row]
	if isnull(ls_description) or trim(ls_description) = "" then
		ls_attachment_type = object.attachment_type[ll_row]
		ls_description = datalist.attachment_type_description(ls_attachment_type)
		if isnull(ls_description) then ls_description = "Attachment"
	end if
end if

return ls_description




end function

public function long get_attachment_row (long pl_attachment_id);long ll_row
string ls_find

ls_find = "attachment_id=" + string(pl_attachment_id)
ll_row = find(ls_find, 1, rowcount())
if ll_row > 0 then return ll_row

return 0

end function

public function long find_object_row (long pl_object_key);return get_attachment_row(pl_object_key)

end function

public function str_property_value get_property (long pl_object_key, string ps_property, str_attributes pstr_attributes);str_property_value lstr_property_value
long ll_row

setnull(lstr_property_value.value)
setnull(lstr_property_value.display_value)
setnull(lstr_property_value.textcolor)
setnull(lstr_property_value.backcolor)
setnull(lstr_property_value.weight)

ll_row = find_object_row(pl_object_key)
if isnull(ll_row) or ll_row <= 0 then return lstr_property_value

CHOOSE CASE lower(ps_property)
	CASE ""
	CASE ELSE
		lstr_property_value = get_property(pl_object_key, ps_property)
END CHOOSE

return lstr_property_value

end function

public function integer attachment_blob (long pl_attachment_id, ref blob pbl_attachment);integer li_sts
string ls_file_path
long ll_attachment_progress_sequence
string ls_find
long ll_row
string ls_storage_flag
str_attachment lstr_attachment
string ls_cpr_id


ll_row = get_attachment_row(pl_attachment_id)
if ll_row <= 0 then return -1

ls_cpr_id = object.cpr_id[ll_row]
ls_storage_flag = object.storage_flag[ll_row]

if ls_storage_flag = "D" then
	SELECT max(attachment_progress_sequence)
	INTO :ll_attachment_progress_sequence
	FROM p_Attachment_Progress
	WHERE cpr_id = :ls_cpr_id
	AND attachment_id = :pl_attachment_id
	AND progress_type = 'UPDATE';
	if not tf_check() then return -1
	
	if isnull(ll_attachment_progress_sequence) then
		SELECTBLOB attachment_image
		INTO :pbl_attachment
		FROM p_Attachment
		WHERE cpr_id = :ls_cpr_id
		AND attachment_id = :pl_attachment_id;
		if not tf_check() then return -1
	else
		SELECTBLOB attachment_image
		INTO :pbl_attachment
		FROM p_Attachment_Progress
		WHERE cpr_id = :ls_cpr_id
		AND attachment_id = :pl_attachment_id
		AND attachment_progress_sequence = :ll_attachment_progress_sequence;
		if not tf_check() then return -1
	end if
else
	lstr_attachment = get_attachment_structure(ll_row)
	ls_file_path = attachment_file_path(lstr_attachment)
	if isnull(ls_file_path) then return -1
	li_sts = log.file_read(ls_file_path, pbl_attachment)
	if li_sts <= 0 then return -1
end if

return 1




end function

public function str_attachment get_attachment_structure (long pl_row);str_attachment lstr_attachment

lstr_attachment.attachment_id = object.attachment_id[pl_row]
lstr_attachment.cpr_id = object.cpr_id[pl_row]
lstr_attachment.treatment_id = object.treatment_id[pl_row]
lstr_attachment.encounter_id = object.encounter_id[pl_row]
lstr_attachment.problem_id = object.problem_id[pl_row]
lstr_attachment.observation_sequence = object.observation_sequence[pl_row]
lstr_attachment.attachment_type = object.attachment_type[pl_row]
lstr_attachment.attachment_tag = object.attachment_tag[pl_row]
lstr_attachment.attachment_file_path = object.attachment_file_path[pl_row]
lstr_attachment.attachment_file = object.attachment_file[pl_row]
lstr_attachment.extension = object.extension[pl_row]
lstr_attachment.attachment_text = object.attachment_text[pl_row]
lstr_attachment.storage_flag = object.storage_flag[pl_row]
lstr_attachment.attachment_date = object.attachment_date[pl_row]
lstr_attachment.attachment_folder = object.attachment_folder[pl_row]
lstr_attachment.attached_by = object.attached_by[pl_row]
lstr_attachment.created = object.created[pl_row]
lstr_attachment.created_by = object.created_by[pl_row]
lstr_attachment.status = object.status[pl_row]

return lstr_attachment


end function

public function string get_attachment (long pl_attachment_id);string ls_file
integer li_sts
blob lbl_attachment
string ls_extension

ls_extension = attachment_extension(pl_attachment_id)

// Get a temp file name to put it in
ls_file = f_temp_file(ls_extension)
if isnull(ls_file) then return ls_file

// Get the blob
li_sts = attachment_blob(pl_attachment_id, lbl_attachment)
if li_sts <= 0 then
	setnull(ls_file)
	return ls_file
end if

// Write the file
li_sts = log.file_write(lbl_attachment, ls_file)
if li_sts <= 0 then
	setnull(ls_file)
	return ls_file
end if

// One last check to make sure the file exists
if not fileexists(ls_file) then
	log.log(this, "get_attachment()", "Error saving attachment to file (" + string(pl_attachment_id) + ", " + ls_file + ")", 4)
	setnull(ls_file)
	return ls_file
end if

return ls_file

end function

public function string attachment_folder (long pl_attachment_id);long ll_row
string ls_find
string ls_null
string ls_attachment_folder
string ls_description

setnull(ls_description)

ls_find = "attachment_id=" + string(pl_attachment_id)
ll_row = find(ls_find, 1, rowcount())
if ll_row > 0 then
	ls_attachment_folder = object.attachment_folder[ll_row]
end if

return ls_attachment_folder




end function

public subroutine display_properties (long pl_attachment_id);Long		ll_row
u_component_attachment luo_attachment
integer li_sts

li_sts = attachment(luo_attachment, pl_attachment_id)
if li_sts <= 0 then
	log.log(this, "display_properties()", "Error getting attachment object", 4)
	return
end if
openwithparm(w_attachment_properties, luo_attachment, f_active_window())
component_manager.destroy_component(luo_attachment)



end subroutine

public function integer delete_attachment (long pl_attachment_id);integer li_sts

li_sts = add_progress(pl_attachment_id, "DELETED", "Attachment Deleted")

return li_sts

end function

public subroutine post_attachment (long pl_attachment_id, string ps_context_object, long pl_object_key);String 			ls_file
Integer 			li_sts
Long 				ll_row
str_attachment_context lstr_attachment_context
w_post_attachment lw_post_attachment
str_folder_selection_info lstr_folder_select
string ls_progress_type
string ls_progress_key
string ls_progress
datetime ldt_progress_date_time
long ll_risk_level
long ll_patient_workplan_item_id
string ls_null
long ll_null
string ls_attachment_tag

setnull(ls_null)
setnull(ll_null)

ll_row = find_object_row(pl_attachment_id)

ls_file = get_attachment(pl_attachment_id)

// If the file doesn't exist the skip it
If isnull(ls_file) then
	log.log(this, "post_attachment()", "Null attachment file", 4)
	return
end if

if not fileexists(ls_file) then
	log.log(this, "post_attachment()", "Attachment file doesn't exist (" + ls_file + ")", 4)
	return
end if

ls_attachment_tag = object.attachment_tag[ll_row]

// Open the folder selection window with information about this attachment
lstr_folder_select.filepath = ls_file
lstr_folder_select.context_object = ps_context_object
lstr_folder_select.object_key = pl_object_key
if isnull(pl_object_key) then
	setnull(lstr_folder_select.context_object_type)
else
	lstr_folder_select.context_object_type = sqlca.fn_context_object_type(ps_context_object, &
																								current_patient.cpr_id, &
																								pl_object_key)
end if
lstr_folder_select.attachment_type = object.attachment_type[ll_row]
lstr_folder_select.extension = object.extension[ll_row]
lstr_folder_select.description = ls_attachment_tag
// Hide the "Apply to all" options
lstr_folder_select.apply_to_all_flag = "X"
// Hide the "Remove" options
lstr_folder_select.remove_flag = "Y"

Openwithparm(lw_post_attachment, lstr_folder_select, "w_post_attachment")
lstr_attachment_context = message.powerobjectparm
if lstr_attachment_context.user_cancelled then return

// Update the attachment with the new folder and description
add_progress(pl_attachment_id,"ATTACHMENT_FOLDER", lstr_attachment_context.folder)
//add_progress(pl_attachment_id, "ATTACHMENT_TAG", lstr_attachment_context.description)

// Remove the attachment from any existing objects
sqlca.sp_remove_attachment(current_patient.cpr_id, &
									pl_attachment_id, &
									current_user.user_id, &
									current_scribe.user_id, &
									ls_null, &
									ll_null )

// Finally, add a new progress record to the appropriate object to show this new attachment
ls_progress_type = 'ATTACHMENT'

if isnull(ls_attachment_tag) then
	ls_progress_key = object.attachment_type[ll_row]
else
	ls_progress_key = ls_attachment_tag
end if

setnull(ls_progress)
ldt_progress_date_time = datetime(today(), now())
setnull(ll_risk_level)
setnull(ll_patient_workplan_item_id)

li_sts = f_set_progress(current_patient.cpr_id, &
								lstr_attachment_context.context_object, &
								lstr_attachment_context.object_key, &
								ls_progress_type, &
								ls_progress_key, &
								ls_progress, &
								ldt_progress_date_time, &
								ll_risk_level, &
								pl_attachment_id, &
								ll_patient_workplan_item_id)
if li_sts < 0 then
	log.log(this, "post_attachment()", "Error adding progress record", 4)
	return
end if



end subroutine

public subroutine menu (long pl_attachment_id, string ps_context_object, long pl_object_key);string ls_extension
string ls_attachment_tag
string buttons[]
integer button_pressed, li_sts, li_service_count
string ls_attachment_folder
long ll_row
str_attributes lstr_attributes
u_component_attachment luo_attachment
string ls_null
long ll_null

str_popup popup
str_popup_return popup_return
window lw_pop_buttons


if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Display Attachment"
	popup.button_titles[popup.button_count] = "Display Attachment"
	buttons[popup.button_count] = "DISPLAY"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit Attachment"
	popup.button_titles[popup.button_count] = "Edit Attachment"
	buttons[popup.button_count] = "EDIT"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Print or Fax This Attachment"
	popup.button_titles[popup.button_count] = "Print/Fax"
	buttons[popup.button_count] = "PRINT"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Review Attachment"
	popup.button_titles[popup.button_count] = "Review Attachment"
	buttons[popup.button_count] = "REVIEW"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Transcribe Attachment"
	popup.button_titles[popup.button_count] = "Transcribe Attachment"
	buttons[popup.button_count] = "TRANCRIBE"
end if

if f_is_external_source_available("OCR") then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Transcribe the image using OCR software"
	popup.button_titles[popup.button_count] = "OCR"
	buttons[popup.button_count] = "OCR"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "View Attachment Properties"
	popup.button_titles[popup.button_count] = "Properties"
	buttons[popup.button_count] = "PROPERTIES"
end if

If true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Move Attachment to Different Folder"
	popup.button_titles[popup.button_count] = "Change Folder"
	buttons[popup.button_count] = "MOVE"
End if

If true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonSaveToFile.bmp"
	popup.button_helps[popup.button_count] = "Save attachment to windows file"
	popup.button_titles[popup.button_count] = "Save To File"
	buttons[popup.button_count] = "SAVEAS"
End if

If true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Rename Attachment"
	popup.button_titles[popup.button_count] = "Rename Attachment"
	buttons[popup.button_count] = "RENAME"
End if

If true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Delete Attachment"
	popup.button_titles[popup.button_count] = "Delete Attachment"
	buttons[popup.button_count] = "DELETE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	button_pressed = message.doubleparm
	if button_pressed < 1 or button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	button_pressed = 1
else
	return
end if

if buttons[button_pressed] <> "CANCEL" then
	f_set_progress(current_patient.cpr_id, &
						"Attachment", & 
						pl_attachment_id, & 
						"Menu:" + popup.button_titles[button_pressed], & 
						ls_null, & 
						ls_null, & 
						datetime(today(), now()), & 
						ll_null, & 
						pl_attachment_id, & 
						current_service.patient_workplan_item_id)
end if

CHOOSE CASE buttons[button_pressed]
	CASE "DELETE"
		openwithparm(w_pop_yes_no, "Do you want to delete this attachment?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return
		
		delete_attachment(pl_attachment_id)
	CASE "DISPLAY"
		f_display_attachment(pl_attachment_id)
	CASE "EDIT"
		f_edit_attachment(pl_attachment_id)
	CASE "PRINT"
		f_print_attachment(pl_attachment_id)
	CASE "REVIEW"
		li_sts = f_review_attachment_with_attributes(pl_attachment_id, lstr_attributes)
	CASE "TRANSCRIBE"
		li_sts = f_transcribe_attachment_with_attributes(pl_attachment_id, lstr_attributes)
	CASE "OCR"
		li_sts = ocr_attachment(pl_attachment_id, ps_context_object, pl_object_key)
	CASE "PROPERTIES"
		display_properties(pl_attachment_id)
	CASE "SAVEAS"
		li_sts = attachment(luo_attachment, pl_attachment_id)
		if li_sts <= 0 then
			log.log(this, "menu()", "Error getting attachment object", 4)
			return
		end if
		luo_attachment.save_as()
	CASE "MOVE"
		post_attachment(pl_attachment_id, ps_context_object, pl_object_key)
	CASE "RENAME"
		ll_row = find_object_row(pl_attachment_id)
		
		ls_attachment_folder = object.attachment_folder[ll_row]
		ls_extension = object.extension[ll_row]
		
		popup.title = "Enter Description:"
		popup.item = object.attachment_tag[ll_row]
		popup.argument_count = 1
		popup.argument[1] = "POST|" + ls_attachment_folder + "|" + ls_extension
		openwithparm(w_pop_prompt_string, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count = 0 then
			return
		else
			ls_attachment_tag = popup_return.items[1]
		end if
		
		add_progress(pl_attachment_id, "ATTACHMENT_TAG", ls_attachment_tag)
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

Return
end subroutine

public function str_progress_list get_attachments (string ps_context_object, long pl_object_key, string ps_progress_type, string ps_progress_key);str_progress_list lstr_progress
str_progress_list lstr_attachments
long i

lstr_progress = f_get_progress(current_patient.cpr_id, ps_context_object, pl_object_key, ps_progress_type, ps_progress_key)

lstr_attachments.progress_count = 0

for i = 1 to lstr_progress.progress_count
	if lstr_progress.progress[i].attachment_id > 0 then
		lstr_attachments.progress_count += 1
		lstr_attachments.progress[lstr_attachments.progress_count] = lstr_progress.progress[i]
	end if
next

return lstr_attachments


end function

public function integer generate_new_file_name (ref str_attachment pstr_attachment);string ls_filespec
integer i
string ls_filename

// Make sure we have an extension
if isnull(pstr_attachment.extension) or (trim(pstr_attachment.extension)) = "" then
	log.log(this, "check_file_name()", "No attachment file extension", 4)
	return -1
end if

if isnull(current_patient) then
	pstr_attachment.attachment_file = "Attachment"
else
	pstr_attachment.attachment_file = current_patient.cpr_id
end if
pstr_attachment.attachment_file += "_" + string(datetime(today(), now()), "yymmddhhmmssffffff")


if trim(pstr_attachment.attachment_file_path) = "" then setnull(pstr_attachment.attachment_file_path)

pstr_attachment.attachment_file = f_sub_nonalphanumeric(pstr_attachment.attachment_file, "_")

ls_filespec = attachment_file_path(pstr_attachment)

if fileexists(ls_filespec) then
	ls_filename = pstr_attachment.attachment_file
	for i = 1 to 1000
		pstr_attachment.attachment_file = ls_filename + "_" + string(i)
		ls_filespec = attachment_file_path(pstr_attachment)
		if not fileexists(ls_filespec) then exit
	next
	if i >= 1000 then
		// If we couldn't find a unique file name the return error
		pstr_attachment.attachment_file = ls_filename
		log.log(this, "check_file_name()", "Duplicate File Name (" + pstr_attachment.attachment_file + ")", 4)
		return -1
	end if
end if

return 1


end function

public function integer attachment_save_as (long pl_attachment_id, string ps_file);integer li_sts
blob lbl_attachment
string ls_file_path
long ll_attachment_progress_sequence
string ls_find
long ll_row

if isnull(ps_file) then
	log.log(this, "attachment_save_as()", "Null filename", 4)
	return -1
end if

li_sts = attachment_blob(pl_attachment_id, lbl_attachment)
if li_sts <= 0 then
	log.log(this, "attachment_save_as()", "Error getting attachment blob", 4)
	return -1
end if

li_sts = log.file_write(lbl_attachment, ps_file)
if li_sts <= 0 then return -1

// One last check to make sure the file exists
if not fileexists(ps_file) then
	log.log(this, "save_as()", "Error saving attachment to file (" + string(pl_attachment_id) + ", " + ps_file + ")", 4)
	return -1
end if

return 1




end function

private function long new_attachment_record (ref str_attachment pstr_attachment, string ps_attachment_object, string ps_progress_type, string ps_progress_key);long ll_patient_workplan_item_id
string ls_observation_id
datetime ldt_now
integer li_sts
string ls_progress
long ll_risk_level
datetime ldt_progress_date_time
integer li_diagnosis_sequence
string ls_severity
long ll_object_key

setnull(ldt_progress_date_time)
setnull(li_diagnosis_sequence)
setnull(ls_severity)

ldt_now = datetime(today(), now())
setnull(ll_risk_level)

if isnull(pstr_attachment.attachment_text) or trim(pstr_attachment.attachment_text) = "" then
	ls_progress = datalist.extension_description(pstr_attachment.extension)
else
	ls_progress = pstr_attachment.attachment_text
end if

if isnull(pstr_attachment.encounter_id) then
	if not isnull(current_service) then
		pstr_attachment.encounter_id = current_service.encounter_id
	end if
end if
	
if isnull(current_service) then
	setnull(ll_patient_workplan_item_id)
else
	ll_patient_workplan_item_id = current_service.patient_workplan_item_id
end if

li_sts = new_attachment_record(pstr_attachment)
if li_sts <= 0 then return -1

if isnull(ps_progress_key) or trim(ps_progress_key) = "" then
	if isnull(pstr_attachment.attachment_tag) then
		ps_progress_key = pstr_attachment.attachment_type
	else
		ps_progress_key = pstr_attachment.attachment_tag
	end if
end if

if isnull(ps_progress_type) then ps_progress_type = 'ATTACHMENT'

ll_object_key = f_attachment_object_key(pstr_attachment, ps_attachment_object)

li_sts = f_set_progress(pstr_attachment.cpr_id, &
								ps_attachment_object, &
								ll_object_key, &
								ps_progress_type, &
								ps_progress_key, &
								ls_progress, &
								ldt_progress_date_time, &
								ll_risk_level, &
								pstr_attachment.attachment_id, &
								ll_patient_workplan_item_id)
if li_sts < 0 then return -1

//	CASE "observation"
//		if isnull(ps_progress_type) or trim(ps_progress_type) = "" then ps_progress_type = "Comment"
//		
//		SELECT observation_id
//		INTO :ls_observation_id
//		FROM p_Observation
//		WHERE cpr_id = :pstr_attachment.cpr_id
//		AND observation_sequence = :pstr_attachment.observation_sequence;
//		if not tf_check() then return -1
//		if sqlca.sqlcode = 100 then
//			log.log(this, "new_attachment_record()", "Invalid observation_sequence", 4)
//			return -1
//		end if
//		
//		// Get the latest comment date time for this key
//		SELECT max(comment_date_time)
//		INTO :ldt_progress_date_time
//		FROM p_Observation_Comment
//		WHERE cpr_id = :pstr_attachment.cpr_id
//		AND observation_sequence = :pstr_attachment.observation_sequence
//		AND comment_type = :ps_progress_type
//		AND comment_title = :pstr_attachment.attachment_tag;
//		if not tf_check() then return -1
//		if isnull(ldt_progress_date_time) then ldt_progress_date_time = datetime(today(), now())
//		
//		INSERT INTO p_Observation_Comment (
//			cpr_id,
//			observation_sequence,
//			observation_id,
//			comment_date_time,
//			comment_type,
//			comment_title,
//			treatment_id,
//			encounter_id,
//			attachment_id,
//			user_id,
//			created_by )
//		VALUES (
//			:pstr_attachment.cpr_id,
//			:pstr_attachment.observation_sequence,
//			:ls_observation_id,
//			:ldt_progress_date_time,
//			:ps_progress_type,
//			:pstr_attachment.attachment_tag,
//			:pstr_attachment.treatment_id,
//			:pstr_attachment.encounter_id,
//			:pstr_attachment.attachment_id,
//			:current_user.user_id,
//			:current_scribe.user_id );
//		if not tf_check() then return -1

return 1




end function

public function long new_attachment (ref str_attachment pstr_attachment, string ps_file, string ps_attachment_object, string ps_progress_type, string ps_progress_key);long ll_row
integer li_sts
string ls_filespec
blob lbl_attachment

li_sts = generate_new_file_name(pstr_attachment)
if li_sts <= 0 then return -1

if isnull(pstr_attachment.storage_flag) or trim(pstr_attachment.storage_flag) = "" then
	pstr_attachment.storage_flag = datalist.extension_default_storage_flag(pstr_attachment.extension)
end if

// Don't allow file attachments with demonstration databases
if sqlca.is_dbmode("Demonstration") then pstr_attachment.storage_flag = "D"

if pstr_attachment.storage_flag = "F" then
	// Get the path where the file should be stored
	ls_filespec = attachment_file_path(pstr_attachment)
	
	// Copy the file
	li_sts = log.file_copy(ps_file, ls_filespec)
	if li_sts <= 0 then
		log.log(this, "new_attachment()", "Error copying attachment file", 4)
		return -1
	end if
else
	// If the storage_flag isn't "F", then make it "D"
	pstr_attachment.storage_flag = "D"
	
	// Get the file
	li_sts = log.file_read(ps_file, lbl_attachment)
	if li_sts <= 0 then
		log.log(this, "new_attachment()", "Error reading attachment file (" + ps_file + ")", 4)
		return -1
	end if
end if

li_sts = new_attachment_record(pstr_attachment, ps_attachment_object, ps_progress_type, ps_progress_key)
if li_sts <= 0 then return -1

// If the attachment should be stored in the database, then put it there
if pstr_attachment.storage_flag = "D" then
	UPDATEBLOB p_Attachment
	SET attachment_image = :lbl_attachment
	WHERE attachment_id = :pstr_attachment.attachment_id;
	if not tf_check() then return -1
end if

return pstr_attachment.attachment_id



end function

public function long new_attachment (ref str_attachment pstr_attachment, blob pbl_attachment, string ps_attachment_object, string ps_progress_type, string ps_progress_key);long ll_row
integer li_sts
string ls_filespec

li_sts = generate_new_file_name(pstr_attachment)
if li_sts <= 0 then return -1

if isnull(pstr_attachment.storage_flag) or trim(pstr_attachment.storage_flag) = "" then
	pstr_attachment.storage_flag = datalist.extension_default_storage_flag(pstr_attachment.extension)
end if

// Don't allow file attachments with demonstration databases
if pstr_attachment.storage_flag = "F" and eml <> "D" then
	// Get the path where the file should be stored
	ls_filespec = attachment_file_path(pstr_attachment)
	
	// Store the file
	li_sts = log.file_write(pbl_attachment, ls_filespec)
	if li_sts <= 0 then
		log.log(this, "new_attachment()", "Error writing attachment to disk", 4)
		return -1
	end if
else
	// If the storage_flag isn't "F", then set it to "D"
	pstr_attachment.storage_flag = "D"
end if

li_sts = new_attachment_record(pstr_attachment, ps_attachment_object, ps_progress_type, ps_progress_key)
if li_sts <= 0 then return -1

// If the attachment should be stored in the database, then put it there
if pstr_attachment.storage_flag = "D" then
	UPDATEBLOB p_Attachment
	SET attachment_image = :pbl_attachment
	WHERE attachment_id = :pstr_attachment.attachment_id;
	if not tf_check() then return -1
end if

return pstr_attachment.attachment_id



end function

public function integer ocr_attachment (long pl_attachment_id, string ps_context_object, long pl_object_key);u_xml_document luo_xml_document
integer li_sts
str_complete_context lstr_from_context
str_complete_context lstr_document_context
str_contraindications lstr_contraindications
long i
string ls_find
long ll_treatment_count
long ll_row
long ll_index
str_attributes lstr_attributes
string ls_attachment_file
string ls_OCR_external_source
str_external_observation_attachment lstr_attachment
string ls_ocr_text

ls_OCR_external_source = datalist.get_preference( "SYSTEM", "ocr_external_source", "OCR")

lstr_attributes = f_get_context_attributes()
f_attribute_add_attribute(lstr_attributes, "context_object", ps_context_object)
f_attribute_add_attribute(lstr_attributes, "object_key", string(pl_object_key))

ls_attachment_file = get_attachment(pl_attachment_id)
if isnull(ls_attachment_file) then
	log.log(this, "ocr_attachment()", "Error getting attachment file (" + string(pl_attachment_id) + ")", 4)
	return -1
end if

f_attribute_add_attribute(lstr_attributes, "ImageFile", ls_attachment_file)

li_sts = f_call_external_source(ls_OCR_external_source, lstr_attributes, lstr_attachment)
if li_sts <= 0 then return li_sts

ls_ocr_text = trim(f_blob_to_string(lstr_attachment.attachment))
if isnull(ls_ocr_text) or ls_ocr_text = "" then return 0

li_sts = add_progress(pl_attachment_id, "TEXT", ls_ocr_text)
if li_sts <= 0 then
	openwithparm(w_pop_message, "Error saving OCR Text")
	return -1
end if


return 1


end function

public function integer store_attachment_database (long pl_attachment_id);// This method moves the specified attachment from being stored in a file to
// being stored in the database

long ll_row
str_attachment lstr_attachment
blob lbl_attachment
integer li_sts
long ll_attachment_progress_sequence
string ls_null

setnull(ls_null)

if isnull(pl_attachment_id) then
	log.log(this, "store_attachment_database()", "Null attachment_id", 4)
	return -1
end if

ll_row = get_attachment_row(pl_attachment_id)
if ll_row <= 0 then
	log.log(this, "store_attachment_database()", "attachment_id not found (" + string(pl_attachment_id) + ")", 4)
	return -1
end if

lstr_attachment = get_attachment_structure(ll_row)

// If the attachment is already in the database then we're done
if upper(lstr_attachment.storage_flag) = "D" then return 1

li_sts = attachment_blob(pl_attachment_id, lbl_attachment)
if li_sts <= 0 then
	log.log(this, "store_attachment_database()", "Error getting attachment file (" + string(pl_attachment_id) + ")", 4)
	return -1
end if

sqlca.begin_transaction(this, "store_attachment_database()")

// Add the UPDATE progress, getting the attachment_progress_sequence
li_sts = add_progress(pl_attachment_id, "UPDATE", ls_null, ll_attachment_progress_sequence)
if li_sts <= 0 then
	sqlca.rollback_transaction()
	log.log(this, "store_attachment_database()", "Error saving storage_flag progress (" + string(pl_attachment_id) + ")", 4)
	return -1
end if

// Set the attachment blob into the UPDATE record
UPDATEBLOB p_Attachment_Progress
SET attachment_image = :lbl_attachment
WHERE attachment_id = :pl_attachment_id
AND attachment_progress_sequence = :ll_attachment_progress_sequence;
if not tf_check() then
	sqlca.rollback_transaction()
	log.log(this, "store_attachment_database()", "Error saving attachment data to database (" + string(pl_attachment_id) + ")", 4)
	return -1
end if

li_sts = add_progress(pl_attachment_id, "storage_flag", "D")
if li_sts <= 0 then
	sqlca.rollback_transaction()
	log.log(this, "store_attachment_database()", "Error saving storage_flag progress (" + string(pl_attachment_id) + ")", 4)
	return -1
end if

sqlca.commit_transaction()

return 1

end function

public function integer add_progress (long pl_attachment_id, string ps_progress_type, string ps_progress, ref long pl_attachment_progress_sequence);string ls_find,ls_cpr_id
long ll_row
integer li_sts
long ll_patient_workplan_item_id
datetime ldt_now
string ls_status


// Find the attachment row
ls_find = "attachment_id=" + string(pl_attachment_id)
ll_row = find(ls_find, 1, rowcount())
if ll_row <= 0 then
	log.log(this, "add_progress()", "Attachment record not found", 4)
	return -1
end if

ls_cpr_id = object.cpr_id[ll_row]
ldt_now = datetime(today(), now())

if not isnull(current_service) then
	ll_patient_workplan_item_id = current_service.patient_workplan_item_id
else
	setnull(ll_patient_workplan_item_id)
end if

pl_attachment_progress_sequence = sqlca.sp_Set_Attachment_Progress(ls_cpr_id, &
																								pl_attachment_id, &
																								ll_patient_workplan_item_id, &
																								current_user.user_id, &
																								ldt_now, &
																								ps_progress_type, &
																								ps_progress, &
																								current_scribe.user_id )
if not tf_check() then return -1

// Make sure the attachment record is up-to-date
refresh_attachment(pl_attachment_id)

return 1


end function

public function integer move_all_attachments_to_database ();long ll_attachment_count
str_attachment lstra_attachments[]
string ls_find
long i
integer li_sts
integer li_index

ls_find = "upper(storage_flag)='F'"
ll_attachment_count = find_attachments(ls_find, lstra_attachments)

li_index = f_please_wait_open()

f_please_wait_progress_bar(li_index, 0, ll_attachment_count)

for i = 1 to ll_attachment_count
	li_sts = store_attachment_database(lstra_attachments[i].attachment_id)
	if li_sts < 0 then
		f_please_wait_close(li_index)
		log.log(this, "move_all_attachments_to_database()", "Error moving attachment to database (" + string(lstra_attachments[i].attachment_id) + ")", 4)
		return -1
	end if
	f_please_wait_progress_bar(li_index, i, ll_attachment_count)
next

f_please_wait_close(li_index)

return 1

end function

public function integer store_attachment_file (long pl_attachment_id);// This method moves the specified attachment from being stored in a file to
// being stored in the database

long ll_row
str_attachment lstr_attachment
blob lbl_attachment
integer li_sts
long ll_attachment_progress_sequence
string ls_null
string ls_file_path

setnull(ls_null)

if isnull(pl_attachment_id) then
	log.log(this, "store_attachment_file()", "Null attachment_id", 4)
	return -1
end if

ll_row = get_attachment_row(pl_attachment_id)
if ll_row <= 0 then
	log.log(this, "store_attachment_file()", "attachment_id not found (" + string(pl_attachment_id) + ")", 4)
	return -1
end if

lstr_attachment = get_attachment_structure(ll_row)
ls_file_path = attachment_file_path(lstr_attachment)
if isnull(ls_file_path) then
	log.log(this, "store_attachment_file()", "unable to determine file path (" + string(pl_attachment_id) + ")", 4)
	return -1
end if

// If the attachment is already in the database then we're done
if upper(lstr_attachment.storage_flag) = "F" then return 1

// Check to see if the file already exists
if fileexists(ls_file_path) then
	log.log(this, "store_attachment_file()", "The destination file already exists (" + ls_file_path + ")", 4)
	return -1
end if

li_sts = attachment_blob(pl_attachment_id, lbl_attachment)
if li_sts <= 0 then
	log.log(this, "store_attachment_file()", "Error getting attachment file (" + string(pl_attachment_id) + ")", 4)
	return -1
end if

// Store the file
li_sts = log.file_write(lbl_attachment, ls_file_path)
if li_sts <= 0 then
	log.log(this, "store_attachment_file()", "Error writing attachment to disk (" + string(pl_attachment_id) + ", " + ls_file_path + ")", 4)
	return -1
end if

li_sts = add_progress(pl_attachment_id, "storage_flag", "F")
if li_sts <= 0 then
	log.log(this, "store_attachment_file()", "Error saving storage_flag progress (" + string(pl_attachment_id) + ")", 4)
	return -1
end if

return 1

end function

public function long find_attachments (string ps_find, ref str_attachment pstr_attachment[]);// list of attachments for a given criteria 
// returns the list from the latest

long ll_rowcount
long ll_row
long ll_found_count

ll_rowcount = rowcount()
ll_found_count = 0

// Add logic to exclude deleted attachments
ps_find = "(" + ps_find + ") and upper(status) <> 'DELETED'"

ll_row = find(ps_find, 1, ll_rowcount)
if ll_row < 0 then return -1
DO WHILE ll_row > 0 and ll_row <= ll_rowcount
	ll_found_count += 1
	pstr_attachment[ll_found_count] = get_attachment_structure(ll_row)

	ll_row = find(ps_find, ll_row + 1, ll_rowcount + 1)
LOOP

return ll_found_count



end function

on u_ds_attachments.create
call super::create
end on

on u_ds_attachments.destroy
call super::destroy
end on

event constructor;call super::constructor;context_object = "Attachment"

end event

