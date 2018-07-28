$PBExportHeader$u_component_observation_wia.sru
forward
global type u_component_observation_wia from u_component_observation
end type
end forward

global type u_component_observation_wia from u_component_observation
end type
global u_component_observation_wia u_component_observation_wia

type variables

end variables

forward prototypes
protected function integer xx_initialize ()
protected function integer xx_do_source ()
protected function integer add_attachment (long pl_observation_index, str_external_observation_attachment pstr_attachment)
end prototypes

protected function integer xx_initialize ();
connected = true

return 1

end function

protected function integer xx_do_source ();//////////////////////////////////////////////////////////////////////////////////////
//
// Description:Get scanned image from WIA source
//             
// Returns: 0 = no images were scanned
//          >0 = number of image files scanned
//
// Modified By:Mark Copenhaver									Creation dt: 1/8/2003
/////////////////////////////////////////////////////////////////////////////////////

Integer 	li_sts
String 	ls_comment_title
str_popup_return popup_return
long ll_attachment_count
string ls_drive
string ls_directory
string ls_filename
string ls_extension
string ls_attachment_comment_title
long i
long ll_box_id
long ll_item_id
str_popup popup
integer li_choice
boolean lb_reverse
str_external_observation_attachment_list lstr_attachments

ls_comment_title = get_attribute("comment_title")
If trim(ls_comment_title) = "" Then setnull(ls_comment_title)

get_attribute("box_id", ll_box_id)
setnull(ll_item_id)
setnull(ls_attachment_comment_title)

observation_count = 1
observations[observation_count].result_count = 0

get_attribute("reverse_batch", lb_reverse, true)

lstr_attachments = common_thread.get_wia_attachments(external_source, true)

if lb_reverse then
	for i = lstr_attachments.attachment_count to 1 step -1
		li_sts = add_attachment(observation_count, lstr_attachments.attachments[i])
		if li_sts < 0 then
			log.log(this, "xx_do_source()", "Error adding attachment", 4)
			return -1
		end if
	next
else
	for i = 1 to lstr_attachments.attachment_count
		li_sts = add_attachment(observation_count, lstr_attachments.attachments[i])
		if li_sts < 0 then
			log.log(this, "xx_do_source()", "Error adding attachment", 4)
			return -1
		end if
	next
end if

Return 1

end function

protected function integer add_attachment (long pl_observation_index, str_external_observation_attachment pstr_attachment);//////////////////////////////////////////////////////////////////////////////////////
//
// Description:Get scanned image from WIA source
//             
// Returns: 0 = no images were scanned
//          >0 = number of image files scanned
//
// Modified By:Mark Copenhaver									Creation dt: 1/8/2003
/////////////////////////////////////////////////////////////////////////////////////

Integer 	li_sts
String 	ls_comment_title
str_popup_return popup_return
long ll_attachment_count
string ls_drive
string ls_directory
string ls_filename
string ls_extension
string ls_attachment_comment_title
long i
long ll_box_id
long ll_item_id
str_popup popup
integer li_choice

ls_comment_title = get_attribute("comment_title")
If trim(ls_comment_title) = "" Then setnull(ls_comment_title)

get_attribute("box_id", ll_box_id)
setnull(ll_item_id)
setnull(ls_attachment_comment_title)

// Read the file into the structure blob
if not isnull(ll_box_id) then
	ll_item_id = f_get_next_box_item(ll_box_id)
end if

// Set the other attachment attributes
pstr_attachment.box_id = ll_box_id
pstr_attachment.item_id = ll_item_id

// if no comment_title was provided, then use the annotation
if isnull(pstr_attachment.attachment_comment_title) or trim(pstr_attachment.attachment_comment_title) = "" then
	if isnull(ls_comment_title) then
		ls_attachment_comment_title = upper(ls_extension)
		ls_attachment_comment_title += " " + wordcap(lower(pstr_attachment.attachment_type))
		ls_attachment_comment_title += " File"
	else
		ls_attachment_comment_title = ls_comment_title
	end if
	
	if ll_item_id > 0 then
		ls_attachment_comment_title += " " + string(ll_item_id)
	end if
	
	pstr_attachment.attachment_comment_title = ls_attachment_comment_title
end if

// Add this attachment to the specified observation
ll_attachment_count = observations[pl_observation_index].attachment_list.attachment_count + 1
observations[pl_observation_index].attachment_list.attachment_count = ll_attachment_count
observations[pl_observation_index].attachment_list.attachments[ll_attachment_count] = pstr_attachment

Return 1

end function

on u_component_observation_wia.create
call super::create
end on

on u_component_observation_wia.destroy
call super::destroy
end on

