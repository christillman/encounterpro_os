$PBExportHeader$u_tabpage_user_stamp_other.sru
forward
global type u_tabpage_user_stamp_other from u_tabpage_user_stamp_base
end type
type cb_external_source from commandbutton within u_tabpage_user_stamp_other
end type
type st_no_stamp from statictext within u_tabpage_user_stamp_other
end type
type cb_clear_stamp from commandbutton within u_tabpage_user_stamp_other
end type
type st_display_title from statictext within u_tabpage_user_stamp_other
end type
type uo_signature_stamp_display from u_picture_display within u_tabpage_user_stamp_other
end type
type cb_import_bitmap from commandbutton within u_tabpage_user_stamp_other
end type
type st_import_title from statictext within u_tabpage_user_stamp_other
end type
type st_title from statictext within u_tabpage_user_stamp_other
end type
end forward

global type u_tabpage_user_stamp_other from u_tabpage_user_stamp_base
integer width = 2917
integer height = 1716
cb_external_source cb_external_source
st_no_stamp st_no_stamp
cb_clear_stamp cb_clear_stamp
st_display_title st_display_title
uo_signature_stamp_display uo_signature_stamp_display
cb_import_bitmap cb_import_bitmap
st_import_title st_import_title
st_title st_title
end type
global u_tabpage_user_stamp_other u_tabpage_user_stamp_other

type variables
u_user user
string signature_stamp
boolean signature_changed = false
boolean signature_deleted = false

string stamp_name

end variables

forward prototypes
public function integer save ()
public function boolean stamp_changed ()
public function integer initialize (u_user puo_user)
end prototypes

public function integer save ();blob lbl_signature_stamp
integer li_sts
string ls_stamp_data
string ls_server
str_filepath lstr_filepath

if signature_changed then
	if signature_deleted then
		setnull(lbl_signature_stamp)
	else
		if isnull(signature_stamp) or not fileexists(signature_stamp) then
			setnull(lbl_signature_stamp)
		else
			li_sts = log.file_read(signature_stamp, lbl_signature_stamp)
			if li_sts <= 0 then
				openwithparm(w_pop_message, "Error reading signature file")
				return -1
			end if
		end if
	end if
	
	if isnull(lbl_signature_stamp) then
		setnull(ls_stamp_data)
	else
		TRY
			ls_stamp_data = common_thread.eprolibnet4.convertbinarytohex(lbl_signature_stamp)
		CATCH (throwable lo_error)
			log.log(this, "u_tabpage_user_stamp_other.save.0028", "Error converting user stamp to hex (" + lo_error.text + ")", 4)
			return -1
		END TRY
	end if

	if len(ls_stamp_data) > 0 then
		lstr_filepath = f_parse_filepath2(signature_stamp)
		ls_stamp_data = lstr_filepath.extension + "." + ls_stamp_data
	end if
	
	sqlca.sp_set_user_progress(user.user_id, &
										current_user.user_id, &
										datetime(today(), now()), &
										"User Stamp", &
										stamp_name, &
										ls_stamp_data, &
										current_scribe.user_id)
	if not tf_check() then
		openwithparm(w_pop_message, "Error saving signature file")
		return -1
	end if
end if

return 1

end function

public function boolean stamp_changed ();return signature_changed

end function

public function integer initialize (u_user puo_user);string ls_stamp_data
blob lbl_stamp_data
integer li_sts
string ls_extension
string ls_data

user = puo_user
if isnull(user) then return -1
stamp_name = text

setnull(signature_stamp)

st_import_title.text = "Create New " + stamp_name + " Stamp"
cb_external_source.text = "Capture New " + stamp_name + " Stamp"
st_title.text = "User " + stamp_name + " Stamp"
st_display_title.text = stamp_name + " Stamp"
cb_clear_stamp.text = "Remove " +  stamp_name + " Stamp"
st_no_stamp.text = "No " +  stamp_name + " Stamp On File"

uo_signature_stamp_display.initialize()


SELECT top 1 progress
INTO :ls_stamp_data 
FROM dbo.fn_user_progress(:user.user_id, 'User Stamp', :stamp_name);
if not tf_check() then return -1

// we might have embedded the file type into the file data
f_split_string(ls_stamp_data, ".", ls_extension, ls_data)
if len(ls_data) > 0 then
	ls_stamp_data = ls_data
else
	ls_extension = "bmp"
end if

if len(ls_stamp_data) > 0 then
	TRY
		lbl_stamp_data = common_thread.eprolibnet4.converthextobinary(ls_stamp_data)
	CATCH (throwable lo_error)
		log.log(this, "u_tabpage_user_stamp_other.initialize.0040", "Error converting user stamp to binary (" + lo_error.text + ")", 4)
		return -1
	END TRY
	signature_stamp = f_temp_file(ls_extension)
	li_sts = log.file_write(lbl_stamp_data, signature_stamp)
	if li_sts <= 0 then return -1
end if

if isnull(signature_stamp) or not fileexists(signature_stamp) then
	setnull(signature_stamp)
	st_no_stamp.visible = true
	uo_signature_stamp_display.visible = false
else
	st_no_stamp.visible = false
	uo_signature_stamp_display.visible = true
	uo_signature_stamp_display.display_picture(signature_stamp)
end if

this.event trigger resize_tabpage()

return 1

end function

on u_tabpage_user_stamp_other.create
int iCurrent
call super::create
this.cb_external_source=create cb_external_source
this.st_no_stamp=create st_no_stamp
this.cb_clear_stamp=create cb_clear_stamp
this.st_display_title=create st_display_title
this.uo_signature_stamp_display=create uo_signature_stamp_display
this.cb_import_bitmap=create cb_import_bitmap
this.st_import_title=create st_import_title
this.st_title=create st_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_external_source
this.Control[iCurrent+2]=this.st_no_stamp
this.Control[iCurrent+3]=this.cb_clear_stamp
this.Control[iCurrent+4]=this.st_display_title
this.Control[iCurrent+5]=this.uo_signature_stamp_display
this.Control[iCurrent+6]=this.cb_import_bitmap
this.Control[iCurrent+7]=this.st_import_title
this.Control[iCurrent+8]=this.st_title
end on

on u_tabpage_user_stamp_other.destroy
call super::destroy
destroy(this.cb_external_source)
destroy(this.st_no_stamp)
destroy(this.cb_clear_stamp)
destroy(this.st_display_title)
destroy(this.uo_signature_stamp_display)
destroy(this.cb_import_bitmap)
destroy(this.st_import_title)
destroy(this.st_title)
end on

event resize_tabpage;call super::resize_tabpage;long ll_x_diff
long ll_y_diff

ll_x_diff = (width - 2917) / 2
ll_y_diff = (height - 1716) / 2

st_title.width = width

cb_clear_stamp.x = 1143 + ll_x_diff
cb_external_source.x = 891 + ll_x_diff
cb_import_bitmap.x = 891 + ll_x_diff
st_display_title.x = 23 + ll_x_diff
st_import_title.x = 891 + ll_x_diff
st_no_stamp.x = 567 + ll_x_diff
uo_signature_stamp_display.x = 567 + ll_x_diff

cb_clear_stamp.y = 1568 + ll_y_diff
cb_external_source.y = 456 + ll_y_diff
cb_import_bitmap.y = 640 + ll_y_diff
st_display_title.y = 996 + ll_y_diff
st_import_title.y = 336 + ll_y_diff
st_no_stamp.y = 988 + ll_y_diff
uo_signature_stamp_display.y = 996 + ll_y_diff



end event

type cb_external_source from commandbutton within u_tabpage_user_stamp_other
integer x = 891
integer y = 456
integer width = 1134
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Capture New Signature"
end type

event clicked;integer li_sts
string ls_filepath
string ls_filename
str_external_observation_attachment lstr_attachment
str_attributes lstr_attributes
integer li_width
integer li_height
string ls_image_filetype
blob lbl_image_data

li_sts = f_call_external_source("Signature", lstr_attributes, lstr_attachment)
if li_sts <= 0 then return

ls_image_filetype = "bmp"

li_sts = f_render_file_as_image(lstr_attachment.extension, &
										lstr_attachment.attachment, &
										ls_image_filetype, &
										lbl_image_data, &
										li_width, &
										li_height)
if li_sts <= 0 then return

signature_stamp = f_temp_file(ls_image_filetype)
li_sts = log.file_write(lbl_image_data, signature_stamp)
if li_sts <= 0 then
	openwithparm(w_pop_message, "Error saving stamp data")
	return
end if

uo_signature_stamp_display.display_picture(signature_stamp)
st_no_stamp.visible = false
uo_signature_stamp_display.visible = true

signature_changed = true
signature_deleted = false

end event

type st_no_stamp from statictext within u_tabpage_user_stamp_other
integer x = 567
integer y = 988
integer width = 1582
integer height = 124
boolean bringtotop = true
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "No Signature Stamp On File"
boolean focusrectangle = false
end type

type cb_clear_stamp from commandbutton within u_tabpage_user_stamp_other
integer x = 1143
integer y = 1568
integer width = 727
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Remove Signature Stamp"
boolean cancel = true
end type

event clicked;st_no_stamp.visible = true
uo_signature_stamp_display.visible = false

signature_changed = true
signature_deleted = true

end event

type st_display_title from statictext within u_tabpage_user_stamp_other
integer x = 23
integer y = 996
integer width = 521
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Signature Stamp"
alignment alignment = right!
boolean focusrectangle = false
end type

type uo_signature_stamp_display from u_picture_display within u_tabpage_user_stamp_other
event destroy ( )
integer x = 567
integer y = 996
integer width = 2176
integer height = 540
integer taborder = 30
boolean bringtotop = true
long backcolor = 33538240
end type

on uo_signature_stamp_display.destroy
call u_picture_display::destroy
end on

type cb_import_bitmap from commandbutton within u_tabpage_user_stamp_other
integer x = 891
integer y = 640
integer width = 1134
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Import Bitmap File"
end type

event clicked;integer li_sts
string ls_filepath
string ls_filename

li_sts = GetFileOpenName ("Select Bitmap File Containing User Signature", ls_filepath, ls_filename ,"bmp", "Bitmap Files,*.bmp")
If li_sts <= 0 Then Return 0

if isnull(signature_stamp) then
	signature_stamp = f_temp_file("bmp")
end if

filecopy(ls_filepath, signature_stamp, true)

uo_signature_stamp_display.initialize( )
uo_signature_stamp_display.display_picture(signature_stamp)
st_no_stamp.visible = false
uo_signature_stamp_display.visible = true

signature_changed = true
signature_deleted = false

end event

type st_import_title from statictext within u_tabpage_user_stamp_other
integer x = 891
integer y = 336
integer width = 1134
integer height = 72
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 33538240
string text = "Create New Signature"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_title from statictext within u_tabpage_user_stamp_other
integer width = 2921
integer height = 152
boolean bringtotop = true
integer textsize = -24
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "User Signature Stamp"
alignment alignment = center!
boolean focusrectangle = false
end type

