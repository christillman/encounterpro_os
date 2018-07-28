$PBExportHeader$w_import_material.srw
forward
global type w_import_material from window
end type
type cb_display_file from commandbutton within w_import_material
end type
type st_1 from statictext within w_import_material
end type
type cb_cancel from commandbutton within w_import_material
end type
type cb_finished from commandbutton within w_import_material
end type
type st_selected_files_title from statictext within w_import_material
end type
type st_page from statictext within w_import_material
end type
type pb_up from u_picture_button within w_import_material
end type
type st_description from statictext within w_import_material
end type
type st_category from statictext within w_import_material
end type
type sle_title from singlelineedit within w_import_material
end type
type st_title_title from statictext within w_import_material
end type
type pb_down from u_picture_button within w_import_material
end type
type dw_materials_list from u_dw_pick_list within w_import_material
end type
end forward

global type w_import_material from window
integer width = 2926
integer height = 1832
boolean titlebar = true
string title = "Import Selected Files"
windowtype windowtype = response!
long backcolor = 33538240
event postopen ( )
cb_display_file cb_display_file
st_1 st_1
cb_cancel cb_cancel
cb_finished cb_finished
st_selected_files_title st_selected_files_title
st_page st_page
pb_up pb_up
st_description st_description
st_category st_category
sle_title sle_title
st_title_title st_title_title
pb_down pb_down
dw_materials_list dw_materials_list
end type
global w_import_material w_import_material

type variables
String  files_selected[]
integer file_count

end variables

event postopen();//////////////////////////////////////////////////////////////////////////////////////
//
// Description:Load materials into datawindow
//
// Created By:Sumathi Chinnasamy										Creation dt: 02/02/2000
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////

Long					 ll_row, ll_return
integer i
string ls_drive, ls_directory, ls_filename, ls_extension

for i = 1 to file_count
	f_parse_filepath(files_selected[i], ls_drive, ls_directory, ls_filename, ls_extension)
	ll_row = dw_materials_list.Insertrow(0)	
	// set the values
	dw_materials_list.object.title[ll_row] = ls_filename + "." + ls_extension
	dw_materials_list.object.filepath[ll_row] = files_selected[i]
next

dw_materials_list.object.selected_flag[1] = 1
sle_title.text = dw_materials_list.object.title[1]

dw_materials_list.last_page = 0
dw_materials_list.set_page(1, pb_up, pb_down, st_page)

end event

on w_import_material.create
this.cb_display_file=create cb_display_file
this.st_1=create st_1
this.cb_cancel=create cb_cancel
this.cb_finished=create cb_finished
this.st_selected_files_title=create st_selected_files_title
this.st_page=create st_page
this.pb_up=create pb_up
this.st_description=create st_description
this.st_category=create st_category
this.sle_title=create sle_title
this.st_title_title=create st_title_title
this.pb_down=create pb_down
this.dw_materials_list=create dw_materials_list
this.Control[]={this.cb_display_file,&
this.st_1,&
this.cb_cancel,&
this.cb_finished,&
this.st_selected_files_title,&
this.st_page,&
this.pb_up,&
this.st_description,&
this.st_category,&
this.sle_title,&
this.st_title_title,&
this.pb_down,&
this.dw_materials_list}
end on

on w_import_material.destroy
destroy(this.cb_display_file)
destroy(this.st_1)
destroy(this.cb_cancel)
destroy(this.cb_finished)
destroy(this.st_selected_files_title)
destroy(this.st_page)
destroy(this.pb_up)
destroy(this.st_description)
destroy(this.st_category)
destroy(this.sle_title)
destroy(this.st_title_title)
destroy(this.pb_down)
destroy(this.dw_materials_list)
end on

event open;//////////////////////////////////////////////////////////////////////////////////////
//
// Description:Split the file names delimited by ',' and load them into an array.
//
// Created By:Sumathi Chinnasamy										Creation dt: 02/02/2000
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////

String			ls_filenames, ls_temp
Long           ll_count = 1
Integer        li_pos
str_popup popup

popup = message.powerobjectparm

files_selected = popup.items
file_count = popup.data_row_count

Postevent("postopen")

end event

type cb_display_file from commandbutton within w_import_material
integer x = 1970
integer y = 1144
integer width = 498
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Display File"
end type

event clicked;string ls_filepath
long ll_row
integer li_sts

ll_row = dw_materials_list.get_selected_row()
if ll_row <= 0 then return

ls_filepath = dw_materials_list.object.filepath[ll_row]

li_sts = f_open_file(ls_filepath, false)
if li_sts <= 0 then
	log.log(this, "display_material()", "Error opening material file.", 4)
	return -1
end if
	
return 1





end event

type st_1 from statictext within w_import_material
integer x = 1746
integer y = 176
integer width = 946
integer height = 256
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "You may optionally assign a new title and/or a category to each file"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_import_material
integer x = 1833
integer y = 1604
integer width = 402
integer height = 112
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
end type

event clicked;str_popup_return popup_return

openwithparm(w_pop_yes_no, "Are you sure yuou wish to cancel without importing these files?")
popup_return = message.powerobjectparm
if popup_return.item = "YES" then close(parent)



end event

type cb_finished from commandbutton within w_import_material
integer x = 2354
integer y = 1604
integer width = 517
integer height = 112
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
end type

event clicked;//////////////////////////////////////////////////////////////////////////////////////
//
// Description:Load all materials into database
//
// Created By:Sumathi Chinnasamy										Creation dt: 02/02/2000
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////

Long				ll_rowcount, ll_material_id, ll_error
Blob				lbl_object_data
String			ls_title, ls_file
long			ll_category
string ls_drive
string ls_directory
string ls_filename
string ls_extension
integer i
integer li_sts
string ls_id
string ls_url
long ll_from_material_id
string ls_parent_config_object_id

ll_rowcount = dw_materials_list.Rowcount()

// Load all the materials into database
for i = 1 to ll_rowcount
// Get the title
	ls_title = dw_materials_list.object.title[i]
	ll_category = dw_materials_list.object.category[i]
	ls_file = dw_materials_list.object.filepath[i]

	f_parse_filepath(ls_file, ls_drive, ls_directory, ls_filename, ls_extension)

	li_sts = log.file_read(ls_file, lbl_object_data)
	If li_sts < 0 Then
		log.log(this,"clicked","Error: "+String(li_sts) + " Unable to load "+ls_title,4)
		Continue
	End if

	setnull(ls_id)
	setnull(ls_url)
	setnull(ll_from_material_id)
	setnull(ls_parent_config_object_id)
	
	ll_material_id = sqlca.jmj_new_material(ls_title, ll_category, "OK", ls_extension, ls_id, ls_url, current_scribe.user_id, ls_filename, ll_from_material_id, ls_parent_config_object_id)
	
	if not tf_check() then return
	if isnull(ll_material_id) or ll_material_id <= 0 then
		log.log(this,"clicked","Error creating new material",4)
		return
	end if
		

	// Update the blob column
	UpdateBlob c_patient_material
	Set object = :lbl_object_data 
	Where material_id = :ll_material_id;
	If not tf_check() Then return
next	

close(parent)

end event

type st_selected_files_title from statictext within w_import_material
integer x = 32
integer y = 20
integer width = 1294
integer height = 100
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Selected Files"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_page from statictext within w_import_material
integer x = 1472
integer y = 376
integer width = 160
integer height = 112
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Page 99/99"
boolean focusrectangle = false
end type

type pb_up from u_picture_button within w_import_material
boolean visible = false
integer x = 1467
integer y = 128
integer width = 137
integer height = 116
integer taborder = 40
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_materials_list.current_page

dw_materials_list.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type st_description from statictext within w_import_material
integer x = 1833
integer y = 820
integer width = 773
integer height = 136
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;//////////////////////////////////////////////////////////////////////////////////////
//
// Description: popup the material categories
//
// Created By:Sumathi Chinnasamy										Creation dt: 02/02/2000
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////

str_popup			popup
str_popup_return	popup_return
long ll_material_category_id
long ll_row

ll_row = dw_materials_list.get_selected_row()
if ll_row <= 0 then return

ll_material_category_id = dw_materials_list.object.category[ll_row]

popup.dataobject = "dw_material_category_list"
popup.datacolumn = 1
popup.displaycolumn = 2

Openwithparm(w_pop_pick, popup)
popup_return = Message.powerobjectparm
If popup_return.item_count <> 1 Then Return
If ll_material_category_id = Long(popup_return.items[1]) Then Return

ll_material_category_id = Long(popup_return.items[1])

dw_materials_list.object.category[ll_row] = ll_material_category_id
Text = popup_return.descriptions[1]
dw_materials_list.object.category_description[ll_row] = popup_return.descriptions[1]


end event

type st_category from statictext within w_import_material
integer x = 2066
integer y = 720
integer width = 302
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Category"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_title from singlelineedit within w_import_material
integer x = 1591
integer y = 576
integer width = 1253
integer height = 108
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 100
borderstyle borderstyle = stylelowered!
end type

event modified;//////////////////////////////////////////////////////////////////////////////////////
//
// Description: Set the new title to datawindow
//
// Created By:Sumathi Chinnasamy										Creation dt: 02/07/2000
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////

dw_materials_list.Setitem(dw_materials_list.Getrow(),"title",sle_title.text)
end event

type st_title_title from statictext within w_import_material
integer x = 2121
integer y = 472
integer width = 197
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Title"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_down from u_picture_button within w_import_material
boolean visible = false
integer x = 1467
integer y = 256
integer width = 137
integer height = 116
integer taborder = 40
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_materials_list.current_page
li_last_page = dw_materials_list.last_page

dw_materials_list.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true
end event

type dw_materials_list from u_dw_pick_list within w_import_material
integer x = 23
integer y = 124
integer width = 1413
integer height = 1452
integer taborder = 30
string dataobject = "dw_materials"
boolean vscrollbar = true
boolean border = false
boolean livescroll = false
end type

event post_click;call super::post_click;//////////////////////////////////////////////////////////////////////////////////////
//
// Description: Display the current row values
//
// Created By:Sumathi Chinnasamy										Creation dt: 02/07/2000
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////

String               ls_text

sle_title.text = object.title[clicked_row]
st_description.text = object.category_description[clicked_row]



end event

event computed_clicked;//if lasttype = 'compute' then
//	if not lastselected then set_last()
//	if lastselected then clear_last()
//end if
//
end event

