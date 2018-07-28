$PBExportHeader$u_tabpage_attachments_to_be_posted.sru
forward
global type u_tabpage_attachments_to_be_posted from u_tabpage
end type
type st_attachment_details from statictext within u_tabpage_attachments_to_be_posted
end type
type cb_delete from commandbutton within u_tabpage_attachments_to_be_posted
end type
type cb_post from commandbutton within u_tabpage_attachments_to_be_posted
end type
type uo_picture from u_picture_display within u_tabpage_attachments_to_be_posted
end type
type pb_down from u_picture_button within u_tabpage_attachments_to_be_posted
end type
type pb_up from u_picture_button within u_tabpage_attachments_to_be_posted
end type
type dw_holding_list from u_dw_pick_list within u_tabpage_attachments_to_be_posted
end type
type st_page from statictext within u_tabpage_attachments_to_be_posted
end type
end forward

global type u_tabpage_attachments_to_be_posted from u_tabpage
st_attachment_details st_attachment_details
cb_delete cb_delete
cb_post cb_post
uo_picture uo_picture
pb_down pb_down
pb_up pb_up
dw_holding_list dw_holding_list
st_page st_page
end type
global u_tabpage_attachments_to_be_posted u_tabpage_attachments_to_be_posted

type variables
u_ds_attachments attachments

end variables

forward prototypes
public function integer initialize ()
public function integer load_holding_list ()
public subroutine delete_temp_files ()
public subroutine delete_selected ()
public function string append_selected ()
public subroutine refresh ()
public subroutine select_image (long pl_row)
public function integer select_attachments (boolean pb_remove)
end prototypes

public function integer initialize ();cb_post.y = height - cb_post.height - 30
cb_post.x = width - cb_post.width - 30
cb_delete.y = cb_post.y
cb_delete.x = st_attachment_details.x + st_attachment_details.width + 100

uo_picture.width = width - uo_picture.x - 10
uo_picture.height = cb_post.y - uo_picture.y - 30

st_attachment_details.y = height - st_attachment_details.height - 10

dw_holding_list.height = st_attachment_details.y - dw_holding_list.y - 10

attachments = CREATE u_ds_attachments
attachments.settransobject(sqlca)

uo_picture.initialize()

return 1

end function

public function integer load_holding_list ();String 	ls_null
long ll_rows
long i
long ll_row

// First delete any temp files in the holding list
delete_temp_files()

Setnull(ls_null)
dw_holding_list.setredraw(false)
dw_holding_list.reset()
ll_rows = attachments.retrieve(ls_null)
for i = 1 to ll_rows
	ll_row = dw_holding_list.insertrow(0)
	dw_holding_list.object.attachment_id[ll_row] = attachments.object.attachment_id[i]
	dw_holding_list.object.attachment_tag[ll_row] = attachments.object.attachment_tag[i]
	dw_holding_list.object.attachment_type[ll_row] = attachments.object.attachment_type[i]
	dw_holding_list.object.extension[ll_row] = attachments.object.extension[i]
	dw_holding_list.object.user_full_name[ll_row] = user_list.user_full_name(string(attachments.object.attached_by[i]))
	dw_holding_list.object.created[ll_row] = attachments.object.created[i]
next

dw_holding_list.sort()

if ll_rows <= 0 Then
	cb_delete.enabled = false
	cb_post.enabled = false
end if

dw_holding_list.setredraw(true)

dw_holding_list.set_page(1, pb_up, pb_down, st_page)

return ll_rows


end function

public subroutine delete_temp_files ();long ll_rows
long i
string ls_file

ll_rows = dw_holding_list.rowcount()
for i = 1 to ll_rows
	ls_file = dw_holding_list.object.attachment_file[i]
	if not isnull(ls_file) then filedelete(ls_file)
next

end subroutine

public subroutine delete_selected ();String 				ls_null,ls_find
Long 					ll_attachment_id
Long					ll_rowcount,ll_row
long ll_rows

setnull(ls_null)

ls_find = "selected_flag=1"
ll_rowcount = dw_holding_list.rowcount()
ll_row = dw_holding_list.find(ls_find, 1, ll_rowcount)
DO WHILE ll_row > 0
	ll_attachment_id = dw_holding_list.object.attachment_id[ll_row]
	attachments.add_progress(ll_attachment_id,"DELETED",ls_null)

	ll_row = dw_holding_list.find(ls_find, ll_row + 1, ll_rowcount + 1)
LOOP

load_holding_list()


end subroutine

public function string append_selected ();long ll_row, ll_rowcount, ll_object_sequence
String ls_find,ls_append_file,ls_temp
string ls_temp_file
//u_component_attachment luo_attachment
boolean lb_first_file
oleobject lo_tiffdll
string ls_param
integer li_sts
string ls_null
//long ll_attachment_id
integer li_pages
string ls_extension
long i

setnull(ls_null)

// This combination routine only works with "tif" files!!!!
lo_tiffdll = CREATE oleobject
li_sts = lo_tiffdll.connecttonewobject("TiffDLL50vic.ClsTiffDLL50")
if li_sts < 0 then
	log.log(this, "append_selected()", "Connection to RunTiffDLL failed (" + string(li_sts) + ")", 4)
	return ls_null
end if

lb_first_file = true

ls_find = "selected_flag=1"
ll_rowcount = dw_holding_list.rowcount()
ll_row = dw_holding_list.find(ls_find, 1, ll_rowcount)
DO WHILE ll_row > 0
	ls_extension = dw_holding_list.object.extension[ll_row]
	if upper(ls_extension) = "TIF" then
		// Get the file to be appended
		ls_temp_file = dw_holding_list.object.attachment_file[ll_row]
		
		// Make sure it exists
		if not fileexists(ls_temp_file) then
			log.log(this, "append_selected()", "Temp file doesn't exist (" + ls_temp_file + ")", 4)
		else
			// If this is the first file to be appended, just use it as the appended file
			if lb_first_file then
				ls_append_file = f_temp_file("TIF")
				li_sts = filecopy(ls_temp_file, ls_append_file, true)
				if li_sts <= 0 then
					log.log(this, "append_selected()", "Error copying tif file (" + ls_temp_file + ", " + ls_append_file + ")", 4)
					return ls_null
				end if
				lb_first_file = false
			else
				// Find out how many pages are in the merge file
				ls_param = "in=" + ls_temp_file + ";out=info_p"
				li_pages = lo_tiffdll.runtiffdll(ls_param)
	
				for i = 1 to li_pages
					ls_param = "in=" + ls_temp_file + ";"
					ls_param += "pages=" + string(i) + ";"
					ls_param += "out=" + ls_append_file + ";"
					ls_param += "save=1;"
					
					li_sts = lo_tiffdll.runtiffdll(ls_param)
			/*		if li_sts = 0 then
						log.log(this, "append_selected()", "RunTiffDLL returned zero.  Check tiffdll license (" + ls_param + ")", 4)
						return ls_null
					end if */
					if li_sts < 0 then
						log.log(this, "append_selected()", "RunTiffDLL failed (" + ls_param + ")", 4)
						return ls_null
					end if
				next
			end if
		end if
	end if
	
	ll_row = dw_holding_list.find(ls_find, ll_row + 1, ll_rowcount + 1)
LOOP

lo_tiffdll.disconnectobject()
DESTROY lo_tiffdll

return ls_append_file

end function

public subroutine refresh ();long ll_rows

ll_rows = load_holding_list()
if ll_rows > 0 Then 
	select_image(1)
end if


end subroutine

public subroutine select_image (long pl_row);long 		ll_row, ll_rowcount

ll_rowcount = dw_holding_list.rowcount()
if ll_rowcount <= 0 then return

dw_holding_list.clear_selected()

if pl_row <= 0 or pl_row > ll_rowcount then pl_row = ll_rowcount

dw_holding_list.setitem(pl_row, "selected_flag", 1)

dw_holding_list.event post selected(pl_row)
end subroutine

public function integer select_attachments (boolean pb_remove);String 			ls_cpr_id, ls_file
String 			ls_attachment_tag,ls_attachment_type
Integer 			li_sts
Long 				ll_row, ll_object_sequence
string ls_extension
str_popup popup
str_popup_return popup_return
u_tab_attachments luo_parent
str_external_observation_attachment lstr_attachment

Setnull(ls_attachment_tag)

ll_row = dw_holding_list.get_selected_row()
if ll_row <= 0 then return 0

ls_extension = dw_holding_list.object.extension[ll_row]
ls_attachment_tag = dw_holding_list.object.attachment_tag[ll_row]
ls_attachment_type = dw_holding_list.object.attachment_type[ll_row]

// If it's a tif attachment, then append all the selected rows together
If upper(ls_extension) = "TIF" then
	ls_file = append_selected()
else
	ls_file = dw_holding_list.object.attachment_file[ll_row]
End if

If isnull(ls_file) then return 0

lstr_attachment.attachment_type = ls_attachment_type
lstr_attachment.extension = ls_extension
lstr_attachment.attachment_comment_title = ls_attachment_tag
setnull(lstr_attachment.attachment_comment)
li_sts = log.file_read(ls_file, lstr_attachment.attachment)
if li_sts <= 0 then return -1

// If this is a tiff file then delete the concatenation file
If upper(ls_extension) = "TIF" then
	filedelete(ls_file)
End if

If pb_remove then
	delete_selected()
End if

luo_parent = parent_tab
luo_parent.event POST attachment_selected(lstr_attachment)

return 1


end function

on u_tabpage_attachments_to_be_posted.create
int iCurrent
call super::create
this.st_attachment_details=create st_attachment_details
this.cb_delete=create cb_delete
this.cb_post=create cb_post
this.uo_picture=create uo_picture
this.pb_down=create pb_down
this.pb_up=create pb_up
this.dw_holding_list=create dw_holding_list
this.st_page=create st_page
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_attachment_details
this.Control[iCurrent+2]=this.cb_delete
this.Control[iCurrent+3]=this.cb_post
this.Control[iCurrent+4]=this.uo_picture
this.Control[iCurrent+5]=this.pb_down
this.Control[iCurrent+6]=this.pb_up
this.Control[iCurrent+7]=this.dw_holding_list
this.Control[iCurrent+8]=this.st_page
end on

on u_tabpage_attachments_to_be_posted.destroy
call super::destroy
destroy(this.st_attachment_details)
destroy(this.cb_delete)
destroy(this.cb_post)
destroy(this.uo_picture)
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.dw_holding_list)
destroy(this.st_page)
end on

event destructor;call super::destructor;delete_temp_files()

end event

type st_attachment_details from statictext within u_tabpage_attachments_to_be_posted
integer y = 1360
integer width = 1321
integer height = 128
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_delete from commandbutton within u_tabpage_attachments_to_be_posted
integer x = 1403
integer y = 1368
integer width = 402
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete"
end type

event clicked;openwithparm(w_pop_ok, "Are you sure you want to delete the selected pages?")
if message.doubleparm = 1 then 
	delete_selected()
end if

end event

type cb_post from commandbutton within u_tabpage_attachments_to_be_posted
integer x = 2135
integer y = 1376
integer width = 402
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select"
end type

event clicked;str_popup_return popup_return
string ls_remove
boolean lb_remove
integer li_sts

ls_remove = "Do you wish to remove these attachments from the to-be-posted list?"

openwithparm(w_pop_yes_no, ls_remove)
popup_return = message.powerobjectparm
if popup_return.item = "YES" then
	lb_remove = true
else
	lb_remove = false
end if

li_sts = select_attachments(lb_remove)
if li_sts <= 0 then return


end event

type uo_picture from u_picture_display within u_tabpage_attachments_to_be_posted
event destroy ( )
integer x = 1381
integer y = 4
integer width = 1184
integer height = 1180
integer taborder = 60
boolean bringtotop = true
boolean border = true
end type

on uo_picture.destroy
call u_picture_display::destroy
end on

event picture_clicked;call super::picture_clicked;integer li_sts

li_sts = view_image()

end event

type pb_down from u_picture_button within u_tabpage_attachments_to_be_posted
integer x = 1234
integer y = 132
integer width = 137
integer height = 116
integer taborder = 30
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_holding_list.current_page
li_last_page = dw_holding_list.last_page

dw_holding_list.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true


end event

type pb_up from u_picture_button within u_tabpage_attachments_to_be_posted
integer x = 1234
integer y = 8
integer width = 137
integer height = 116
integer taborder = 20
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_holding_list.current_page

dw_holding_list.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type dw_holding_list from u_dw_pick_list within u_tabpage_attachments_to_be_posted
integer width = 1239
integer height = 1340
integer taborder = 10
string dataobject = "dw_holding_attachments"
boolean border = false
boolean livescroll = false
end type

event constructor;call super::constructor;multiselect = true
settransobject(sqlca)

end event

event unselected;integer li_count

li_count = count_selected()
if li_count <= 0 then
	cb_post.enabled = false
	cb_delete.enabled = false
else
	cb_post.enabled = true
	cb_delete.enabled = true
end if



end event

event selected;Blob 		lbl_attachment
Long		ll_attachment_id
Integer 	li_sts,li_count
String 	ls_filepath,ls_filename
String 	ls_attachment_file_path,ls_extension,ls_attachment_file
string ls_find
long ll_row
string   ls_prev_extension
String	ls_file,ls_title
u_component_attachment luo_displayed_attachment

cb_post.enabled = true
cb_delete.enabled = true

ll_attachment_id = dw_holding_list.object.attachment_id[selected_row]
ls_extension = dw_holding_list.object.extension[selected_row]

// if it's not a 'TIF' file then clear all the selected files. only 'tif'
// files can be merged
ls_find = "selected_flag=1 and attachment_id<>" + string(ll_attachment_id)
ll_row = find(ls_find, 1, rowcount())
If ll_row > 0 Then
	ls_prev_extension = dw_holding_list.object.extension[ll_row]
	If (upper(ls_prev_extension) <> "TIF" or upper(ls_extension) <> "TIF") Then
		clear_selected()
		object.selected_flag[selected_row] = 1
	End If
End If


// If we haven't extracted this file yet then get it
ls_file = dw_holding_list.object.attachment_file[selected_row]
if isnull(ls_file) then
	li_sts = attachments.attachment(luo_displayed_attachment, ll_attachment_id)
	if li_sts <= 0 then
		setnull(ls_file)
		log.log(this, "clicked", "Error getting attachment object", 3)
	else
		if isnull(ls_file) then
			ls_file = luo_displayed_attachment.get_attachment()
			dw_holding_list.object.attachment_file[selected_row] = ls_file
		end if
	end if
	component_manager.destroy_component(luo_displayed_attachment)
end if
	
// Display the attachment in the browser object
uo_picture.display_picture(ls_file)

ls_title = "File Attached by "
ls_title += dw_holding_list.object.user_full_name[selected_row]
ls_title += " on " + string(dw_holding_list.object.created[selected_row], "[shortdate] [time]")
st_attachment_details.text = ls_title

Return
end event

type st_page from statictext within u_tabpage_attachments_to_be_posted
integer x = 1234
integer y = 256
integer width = 146
integer height = 124
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Page 99/99"
boolean focusrectangle = false
end type

