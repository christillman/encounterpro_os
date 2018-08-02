$PBExportHeader$u_file_action.sru
forward
global type u_file_action from nonvisualobject
end type
end forward

global type u_file_action from nonvisualobject autoinstantiate
end type

forward prototypes
public function integer display_file (str_external_observation_attachment pstr_file)
public function integer print_file (str_external_observation_attachment pstr_file)
public function integer print_file (str_external_observation_attachment pstr_file, string ps_printer)
public function integer edit_file (str_external_observation_attachment pstr_file, string ps_desired_file_type, long pl_width, long pl_height, ref string ps_actual_file_type, ref blob pbl_file)
public function integer render_file (str_external_observation_attachment pstr_file, string ps_desired_file_type, integer pi_desired_width_pixels, integer pi_desired_height_pixels, ref string ps_rendered_file_type, ref blob pbl_rendered_file)
public function integer render_file (string ps_file, string ps_desired_file_type, integer pi_desired_width_pixels, integer pi_desired_height_pixels, ref string ps_rendered_file_type, ref blob pbl_rendered_file)
public function integer render_file (blob pbl_file, string ps_file_type, string ps_desired_file_type, integer pi_desired_width_pixels, integer pi_desired_height_pixels, ref string ps_rendered_file_type, ref blob pbl_rendered_file)
end prototypes

public function integer display_file (str_external_observation_attachment pstr_file);long ll_row
string ls_component_id
u_component_attachment luo_attachment
string ls_file
integer li_sts
str_filepath pstr_filepath
long ll_filelength

ls_component_id = datalist.extension_component_id(pstr_file.extension)
if isnull(ls_component_id) then ls_component_id = "ATCH_GENERIC"

luo_attachment = component_manager.get_component(ls_component_id)
if isnull(luo_attachment) then
	log.log(this, "u_file_action.display_file.0014", "Unable to get component (" + ls_component_id + ")", 4)
	setnull(luo_attachment)
	return -1
end if

luo_attachment.set_attachment_data(pstr_file.attachment_comment_title, pstr_file.filename, pstr_file.extension, pstr_file.attachment)

li_sts = luo_attachment.display()
if li_sts < 0 then return -1

component_manager.destroy_component(luo_attachment)

return 1


end function

public function integer print_file (str_external_observation_attachment pstr_file);long ll_row
string ls_component_id
u_component_attachment luo_attachment
string ls_file
integer li_sts
str_filepath pstr_filepath
long ll_filelength

ls_component_id = datalist.extension_component_id(pstr_file.extension)
if isnull(ls_component_id) then ls_component_id = "ATCH_GENERIC"

luo_attachment = component_manager.get_component(ls_component_id)
if isnull(luo_attachment) then
	log.log(this, "u_file_action.display_file.0014", "Unable to get component (" + ls_component_id + ")", 4)
	setnull(luo_attachment)
	return -1
end if

luo_attachment.set_attachment_data(pstr_file.attachment_comment_title, pstr_file.filename, pstr_file.extension, pstr_file.attachment)

li_sts = luo_attachment.print()
if li_sts < 0 then return -1

component_manager.destroy_component(luo_attachment)

return 1


end function

public function integer print_file (str_external_observation_attachment pstr_file, string ps_printer);long ll_row
string ls_component_id
u_component_attachment luo_attachment
string ls_file
integer li_sts
str_filepath pstr_filepath
long ll_filelength

ls_component_id = datalist.extension_component_id(pstr_file.extension)
if isnull(ls_component_id) then ls_component_id = "ATCH_GENERIC"

luo_attachment = component_manager.get_component(ls_component_id)
if isnull(luo_attachment) then
	log.log(this, "u_file_action.display_file.0014", "Unable to get component (" + ls_component_id + ")", 4)
	setnull(luo_attachment)
	return -1
end if

luo_attachment.set_attachment_data(pstr_file.attachment_comment_title, pstr_file.filename, pstr_file.extension, pstr_file.attachment)

li_sts = luo_attachment.print(ps_printer)
if li_sts < 0 then return -1

component_manager.destroy_component(luo_attachment)

return 1


end function

public function integer edit_file (str_external_observation_attachment pstr_file, string ps_desired_file_type, long pl_width, long pl_height, ref string ps_actual_file_type, ref blob pbl_file);long ll_row
string ls_component_id
u_component_attachment luo_attachment
string ls_file
integer li_sts
str_filepath pstr_filepath
long ll_filelength

ls_component_id = datalist.extension_component_id(pstr_file.extension)
if isnull(ls_component_id) then ls_component_id = "ATCH_GENERIC"

luo_attachment = component_manager.get_component(ls_component_id)
if isnull(luo_attachment) then
	log.log(this, "u_file_action.display_file.0014", "Unable to get component (" + ls_component_id + ")", 4)
	setnull(luo_attachment)
	return -1
end if

luo_attachment.set_attachment_data(pstr_file.attachment_comment_title, pstr_file.filename, pstr_file.extension, pstr_file.attachment)

li_sts = luo_attachment.edit()
if li_sts < 0 then return -1

component_manager.destroy_component(luo_attachment)

return 1


end function

public function integer render_file (str_external_observation_attachment pstr_file, string ps_desired_file_type, integer pi_desired_width_pixels, integer pi_desired_height_pixels, ref string ps_rendered_file_type, ref blob pbl_rendered_file);long ll_row
string ls_component_id
u_component_attachment luo_attachment
string ls_file
integer li_sts
str_filepath pstr_filepath
long ll_filelength
str_filepath lstr_filepath

ls_component_id = datalist.extension_component_id(pstr_file.extension)
if isnull(ls_component_id) then ls_component_id = "ATCH_GENERIC"

luo_attachment = component_manager.get_component(ls_component_id)
if isnull(luo_attachment) then
	log.log(this, "u_file_action.display_file.0014", "Unable to get component (" + ls_component_id + ")", 4)
	setnull(luo_attachment)
	return -1
end if

luo_attachment.set_attachment_data(pstr_file.attachment_comment_title, pstr_file.filename, pstr_file.extension, pstr_file.attachment)

li_sts = luo_attachment.render(ps_desired_file_type, ls_file, pi_desired_width_pixels, pi_desired_height_pixels)
if li_sts < 0 then return -1

if fileexists(ls_file) then
	li_sts = log.file_read(ls_file, pbl_rendered_file)
	if li_sts > 0 then
		lstr_filepath = f_parse_filepath2(ls_file)
		ps_rendered_file_type = lstr_filepath.extension
	end if
else
	li_sts = -1
end if

component_manager.destroy_component(luo_attachment)

return li_sts


end function

public function integer render_file (string ps_file, string ps_desired_file_type, integer pi_desired_width_pixels, integer pi_desired_height_pixels, ref string ps_rendered_file_type, ref blob pbl_rendered_file);integer li_sts
str_filepath lstr_filepath
blob lbl_file
str_external_observation_attachment lstr_attachment

li_sts = log.file_read(ps_file, lbl_file)
if li_sts <= 0 then return -1

lstr_filepath = f_parse_filepath2(ps_file)

lstr_attachment.filename = lstr_filepath.filename
lstr_attachment.extension = lstr_filepath.extension
lstr_attachment.attachment_comment_title = lstr_filepath.filename
lstr_attachment.attachment = lbl_file

return render_file(lstr_attachment, ps_desired_file_type, pi_desired_width_pixels, pi_desired_height_pixels, ps_rendered_file_type, pbl_rendered_file)


end function

public function integer render_file (blob pbl_file, string ps_file_type, string ps_desired_file_type, integer pi_desired_width_pixels, integer pi_desired_height_pixels, ref string ps_rendered_file_type, ref blob pbl_rendered_file);str_external_observation_attachment lstr_attachment

lstr_attachment.filename = ps_file_type + "_file"
lstr_attachment.extension = ps_file_type
lstr_attachment.attachment_comment_title = ps_file_type + "_file"
lstr_attachment.attachment = pbl_file

return render_file(lstr_attachment, ps_desired_file_type, pi_desired_width_pixels, pi_desired_height_pixels, ps_rendered_file_type, pbl_rendered_file)


end function

on u_file_action.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_file_action.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

