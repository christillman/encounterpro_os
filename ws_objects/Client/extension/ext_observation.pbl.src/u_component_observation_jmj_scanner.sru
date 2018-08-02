$PBExportHeader$u_component_observation_jmj_scanner.sru
forward
global type u_component_observation_jmj_scanner from u_component_observation
end type
end forward

global type u_component_observation_jmj_scanner from u_component_observation
end type
global u_component_observation_jmj_scanner u_component_observation_jmj_scanner

forward prototypes
protected function integer xx_initialize ()
private function integer load_and_annotate_file (string ps_file, string ps_annotation, ref blob pbl_blob)
protected function integer xx_do_source ()
protected function integer add_attachment (long pl_observation_index, string ps_file)
end prototypes

protected function integer xx_initialize ();connected = true

return 1

end function

private function integer load_and_annotate_file (string ps_file, string ps_annotation, ref blob pbl_blob);oleobject lo_tiffdll
string ls_param
string ls_temp
string ls_drive
string ls_directory
string ls_filename
string ls_extension
integer li_sts
long ll_result
string ls_temp_file


if isnull(ps_annotation) or trim(ps_annotation) = "" then
	ls_temp_file = ps_file
else
	lo_tiffdll = CREATE oleobject
	li_sts = lo_tiffdll.connecttonewobject("TiffDLL50vic.ClsTiffDLL50")
	if li_sts < 0 then
		log.log(this, "u_component_observation_jmj_scanner.load_and_annotate_file.0019", "Connection to RunTiffDLL failed (" + string(li_sts) + ")", 4)
		return -1
	end if
	
	f_parse_filepath(ps_file, ls_drive, ls_directory, ls_filename, ls_extension)
	
	ls_param = "in=" + ps_file + ";"
	
	ls_temp_file = f_temp_file(ls_extension)
	ls_param += "out=" + ls_temp_file + ";"
	
	ls_param += "text=1/0/1/" + ps_annotation + ";"
	ll_result = lo_tiffdll.runtiffdll(ls_param)
/*	if ll_result = 0 then
		log.log(this, "u_component_observation_jmj_scanner.load_and_annotate_file.0019", "RunTiffDLL returned zero.  Check tiffdll license (" + ls_param + ")", 4)
		return -1
	end if */
	if ll_result < 0 then
		log.log(this, "u_component_observation_jmj_scanner.load_and_annotate_file.0019", "RunTiffDLL failed (" + string(ll_result) + ", " + ls_param + ")", 4)
		return -1
	end if
	
	lo_tiffdll.disconnectobject()
	DESTROY lo_tiffdll
end if



li_sts = mylog.file_read(ls_temp_file, pbl_blob)
if li_sts <= 0 then
	log.log(this, "u_component_observation_jmj_scanner.load_and_annotate_file.0019", "Read into blob failed", 4)
	return -1
end if

return 1

end function

protected function integer xx_do_source ();//////////////////////////////////////////////////////////////////////////////////////
//
// Description:Get scanned image
//             
// Returns: 0 = no images were scanned
//          >0 = number of image files scanned
//
// Modified By:Sumathi Chinnasamy									Creation dt: 10/23/2001
/////////////////////////////////////////////////////////////////////////////////////

Integer 	li_sts
String 	ls_comment_title
str_popup_return popup_return
long ll_attachment_count
string ls_drive
string ls_directory
string ls_filename
string ls_extension
string ls_annotation
long i
long ll_box_id
long ll_item_id
str_popup popup
integer li_choice
boolean lb_reverse

ls_comment_title = get_attribute("comment_title")
If trim(ls_comment_title) = "" Then setnull(ls_comment_title)

get_attribute("box_id", ll_box_id)

openwithparm(w_twain_scanner, this)
popup_return = message.powerobjectparm

ll_attachment_count = 0
observation_count = 1
observations[observation_count].result_count = 0

get_attribute("reverse_batch", lb_reverse, true)

if lb_reverse then
	for i = popup_return.item_count to 1 step -1
		li_sts = add_attachment(observation_count, popup_return.items[i])
		if li_sts < 0 then
			log.log(this, "u_component_observation_jmj_scanner.xx_do_source.0045", "Error loading scanned file", 4)
			return -1
		end if
	next
else
	for i = 1 to popup_return.item_count
		li_sts = add_attachment(observation_count, popup_return.items[i])
		if li_sts < 0 then
			log.log(this, "u_component_observation_jmj_scanner.xx_do_source.0045", "Error loading scanned file", 4)
			return -1
		end if
	next
end if


Return 1


end function

protected function integer add_attachment (long pl_observation_index, string ps_file);//////////////////////////////////////////////////////////////////////////////////////
//
// Description: Add specified file to the attachment list
//             
// Returns: 1 = Succeeded
//          0 = No such file
//				<0 = Error
//
// Modified By:Sumathi Chinnasamy									Creation dt: 10/23/2001
/////////////////////////////////////////////////////////////////////////////////////

Integer 	li_sts
String 	ls_comment_title
long ll_attachment_count
string ls_drive
string ls_directory
string ls_filename
string ls_extension
string ls_annotation
long i
long ll_box_id
long ll_item_id
str_popup popup
integer li_choice

ls_comment_title = get_attribute("comment_title")
If trim(ls_comment_title) = "" Then setnull(ls_comment_title)

get_attribute("box_id", ll_box_id)

ll_attachment_count = observations[pl_observation_index].attachment_list.attachment_count

if not fileexists(ps_file) then
	return 0
end if

f_parse_filepath(ps_file, ls_drive, ls_directory, ls_filename, ls_extension)

// Read the file into the structure blob
if not isnull(ll_box_id) then
	ls_annotation = "Box " + string(ll_box_id)
	ll_item_id = f_get_next_box_item(ll_box_id)
	if not isnull(ll_item_id) then
		ls_annotation += ", Item = " + string(ll_item_id)
	end if
end if

DO WHILE true
	li_sts = load_and_annotate_file(ps_file, ls_annotation, observations[pl_observation_index].attachment_list.attachments[ll_attachment_count + 1].attachment)
	If li_sts <= 0 Then
		popup.data_row_count = 3
		popup.items[1] = "Retry Annotation"
		popup.items[2] = "Skip Annotation"
		popup.items[3] = "Skip File"
		popup.title = "The Box/Item # annotation failed on file # " + string(i) + ".  Do you wish to:"
		openwithparm(w_pop_choices_3, popup)
		li_choice = message.doubleparm
		if li_choice = 1 then
			continue
		elseif li_choice = 2 then
			// Is the user wants to skip the annotation, then just load the file into the attachment blob
			li_sts = mylog.file_read(ps_file, observations[pl_observation_index].attachment_list.attachments[ll_attachment_count + 1].attachment)
			if li_sts <= 0 then
				log.log(this, "u_component_observation_jmj_scanner.xx_do_source.0045", "Read into blob failed", 4)
				return -1
			end if
			exit
		else
			// If the user wants to skip the file then skip it
			li_sts = 0
			exit
		end if
	else
		exit
	end if
LOOP

// If we don't have a success status here then skip the file
if li_sts = 0 then return 0
if li_sts < 0 then return -1

// Increment the attachment count
ll_attachment_count += 1
observations[pl_observation_index].attachment_list.attachment_count = ll_attachment_count

// Set the other attachment attributes
observations[pl_observation_index].attachment_list.attachments[ll_attachment_count].attachment_type = "IMAGE"
observations[pl_observation_index].attachment_list.attachments[ll_attachment_count].extension = ls_extension

// if no comment_title was provided, then use the annotation
if isnull(ls_comment_title) then
	observations[pl_observation_index].attachment_list.attachments[ll_attachment_count].attachment_comment_title = ls_annotation
else
	observations[pl_observation_index].attachment_list.attachments[ll_attachment_count].attachment_comment_title = ls_comment_title
end if

// Delete the disk file
filedelete(ps_file)

Return 1


end function

on u_component_observation_jmj_scanner.create
call super::create
end on

on u_component_observation_jmj_scanner.destroy
call super::destroy
end on

