HA$PBExportHeader$u_attachment_list.sru
forward
global type u_attachment_list from nonvisualobject
end type
end forward

global type u_attachment_list from nonvisualobject
end type
global u_attachment_list u_attachment_list

type variables
integer attachment_count
u_ds_attachments attachments

// !!!! Left for compatibility, but need to remove
long attachment_id


end variables

forward prototypes
public function string attachment_button (string ps_attachment_type)
public function string button_bitmap (string ps_attachment_tag)
public function integer count_attachments (string ps_attachment_type, string ps_attachment_tag)
public function integer delete_attachment (u_component_attachment puo_attachment)
public function u_component_attachment find_attachment (long pl_attachment_id)
public function u_component_attachment find_tagged_attachment (string ps_attachment_tag)
public function u_component_attachment find_tagged_attachment (string ps_attachment_type, string ps_attachment_tag)
public function string get_text (long pl_encounter_id)
public function string get_text (string ps_attachment_type, string ps_attachment_tag)
public function boolean any_attachments ()
public function string get_text (string ps_find)
public function string get_text ()
end prototypes

public function string attachment_button (string ps_attachment_type);string ls_button

ls_button = datalist.attachment_button(ps_attachment_type)

if isnull(ls_button) then ls_button = "button07.bmp"

return ls_button

end function

public function string button_bitmap (string ps_attachment_tag);string ls_bitmap
string ls_temp
integer i
string ls_attachment_tag
string ls_attachment_type

setnull(ls_attachment_type)

for i = 1 to attachment_count
	ls_attachment_tag = attachments.object.attachment_tag[i]
	ls_temp = attachments.object.attachment_type[i]

	if (isnull(ps_attachment_tag) and isnull(ls_attachment_tag)) or ps_attachment_tag = ls_attachment_tag then
		if isnull(ls_attachment_type) then
			ls_attachment_type = ls_temp
		elseif ls_attachment_type <> ls_temp then
			return "button21.bmp"
		end if
	end if
next

return f_bitmap_for_attachment_type(ls_attachment_type)


end function

public function integer count_attachments (string ps_attachment_type, string ps_attachment_tag);long ll_row
integer li_count

for ll_row = 1 to attachment_count
	if isnull(ps_attachment_type) or ps_attachment_type = attachments.object.attachment_type[ll_row] then
		if isnull(ps_attachment_tag) or ps_attachment_tag = attachments.object.attachment_tag[ll_row] then
			li_count++
		end if
	end if
next

return li_count		

end function

public function integer delete_attachment (u_component_attachment puo_attachment);string ls_find
long ll_row

// If the attachment is not valid, then log a warning
if isnull(puo_attachment) or not isvalid(puo_attachment) then
	log.log(this, "delete_atachment()", "Attachment not valid", 3)
	return 0
end if


ls_find = "attachment_id=" + string(puo_attachment.attachment_id)

ll_row = attachments.find(ls_find, 1, attachments.rowcount())
if ll_row > 0 then
	puo_attachment.add_progress("DELETED")
	attachments.reselectrow(ll_row)
end if

component_manager.destroy_component(puo_attachment)

return 1

end function

public function u_component_attachment find_attachment (long pl_attachment_id);integer li_sts
u_component_attachment luo_attachment

li_sts = attachments.attachment(luo_attachment, pl_attachment_id)
if li_sts <= 0 then setnull(luo_attachment)

return luo_attachment

end function

public function u_component_attachment find_tagged_attachment (string ps_attachment_tag);integer li_sts
long ll_row
string ls_find
long ll_attachment_id
u_component_attachment luo_attachment

ls_find = "attachment_tag='" + ps_attachment_tag + "'"

ll_row = attachments.find(ls_find, 1, attachments.rowcount())
if ll_row <= 0 then
	setnull(luo_attachment)
	return luo_attachment
end if

ll_attachment_id = attachments.object.attachment_id[ll_row]

li_sts = attachments.attachment(luo_attachment, ll_attachment_id)
if li_sts <= 0 then setnull(luo_attachment)

return luo_attachment


end function

public function u_component_attachment find_tagged_attachment (string ps_attachment_type, string ps_attachment_tag);integer li_sts
long ll_row
string ls_find
long ll_attachment_id
u_component_attachment luo_attachment

ls_find = "attachment_type='" + ps_attachment_type + "' and (attachment_tag='" + ps_attachment_tag + "' or isnull(attachment_tag))"

ll_row = attachments.find(ls_find, 1, attachments.rowcount())
if ll_row <= 0 then
	setnull(luo_attachment)
	return luo_attachment
end if

ll_attachment_id = attachments.object.attachment_id[ll_row]

li_sts = attachments.attachment(luo_attachment, ll_attachment_id)
if li_sts <= 0 then setnull(luo_attachment)

return luo_attachment


end function

public function string get_text (long pl_encounter_id);string ls_find
ls_find = "encounter_id=" + string(pl_encounter_id)
return get_text(ls_find)
 
end function

public function string get_text (string ps_attachment_type, string ps_attachment_tag);string ls_find
ls_find = "attachment_type='" + ps_attachment_type + "' and attachment_tag='" + ps_attachment_tag + "'"
return get_text(ls_find)
 
end function

public function boolean any_attachments ();string ls_find
long ll_row

ls_find = "attachment_type<>'SIGNATURE'"
ll_row = attachments.find(ls_find, 1, attachments.rowcount())

if ll_row > 0 then return true

return false

end function

public function string get_text (string ps_find);integer i, j
string ls_text, ls_a_sep, ls_o_sep, ls_date_string
long ll_row
long ll_rowcount
integer li_attachment_sequence
integer li_sts
string ls_attachment_text

ls_a_sep = ""
ls_text = ""

ll_rowcount = attachments.rowcount()
ll_row = 0
ps_find = "(" + ps_find + ") and not isnull(attachment_text)"

ll_row = attachments.find(ps_find, ll_row + 1, ll_rowcount + 1)
DO WHILE ll_row > 0 AND ll_row <= ll_rowcount
	// First get an attachment object
	ls_attachment_text = attachments.object.attachment_text[ll_row]
	
	if trim(ls_attachment_text) <> "" then
		// First add the seperator
		ls_text += ls_a_sep
	
		// Change the seperator to a new-line
		ls_a_sep = "~n"
	
		// Add the text
		ls_text += ls_attachment_text
	
	end if
	
	ll_row = attachments.find(ps_find, ll_row + 1, ll_rowcount + 1)
LOOP

if ls_text = "" then setnull(ls_text)

return ls_text
 
end function

public function string get_text ();// We want all attachments, so give a find string which will match everything
return get_text("1=1")

 
end function

on u_attachment_list.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_attachment_list.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;attachments = CREATE u_ds_attachments
attachments.settransobject(sqlca)

attachment_count = 0


end event

event destructor;DESTROY attachments

end event

