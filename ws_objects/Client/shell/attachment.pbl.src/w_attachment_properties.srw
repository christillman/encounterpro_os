$PBExportHeader$w_attachment_properties.srw
forward
global type w_attachment_properties from w_window_base
end type
type st_page from statictext within w_attachment_properties
end type
type pb_up from picturebutton within w_attachment_properties
end type
type pb_down from picturebutton within w_attachment_properties
end type
type cb_ok from commandbutton within w_attachment_properties
end type
type dw_transcription_history from u_dw_pick_list within w_attachment_properties
end type
type st_1 from statictext within w_attachment_properties
end type
type st_status from statictext within w_attachment_properties
end type
type st_status_title from statictext within w_attachment_properties
end type
type st_created_by from statictext within w_attachment_properties
end type
type st_created_by_title from statictext within w_attachment_properties
end type
type st_created from statictext within w_attachment_properties
end type
type st_created_title from statictext within w_attachment_properties
end type
type st_title from statictext within w_attachment_properties
end type
type st_storage_flag from statictext within w_attachment_properties
end type
type st_storage_flag_title from statictext within w_attachment_properties
end type
type st_extension from statictext within w_attachment_properties
end type
type st_extension_title from statictext within w_attachment_properties
end type
type st_attachment_type from statictext within w_attachment_properties
end type
type st_attachment_type_title from statictext within w_attachment_properties
end type
type st_attached_by from statictext within w_attachment_properties
end type
type st_attached_by_title from statictext within w_attachment_properties
end type
type st_attachment_date from statictext within w_attachment_properties
end type
type st_attachment_date_title from statictext within w_attachment_properties
end type
type st_attachment_folder from statictext within w_attachment_properties
end type
type st_attachment_folder_title from statictext within w_attachment_properties
end type
end forward

global type w_attachment_properties from w_window_base
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_page st_page
pb_up pb_up
pb_down pb_down
cb_ok cb_ok
dw_transcription_history dw_transcription_history
st_1 st_1
st_status st_status
st_status_title st_status_title
st_created_by st_created_by
st_created_by_title st_created_by_title
st_created st_created
st_created_title st_created_title
st_title st_title
st_storage_flag st_storage_flag
st_storage_flag_title st_storage_flag_title
st_extension st_extension
st_extension_title st_extension_title
st_attachment_type st_attachment_type
st_attachment_type_title st_attachment_type_title
st_attached_by st_attached_by
st_attached_by_title st_attached_by_title
st_attachment_date st_attachment_date
st_attachment_date_title st_attachment_date_title
st_attachment_folder st_attachment_folder
st_attachment_folder_title st_attachment_folder_title
end type
global w_attachment_properties w_attachment_properties

type variables
u_component_attachment attachment

end variables

on w_attachment_properties.create
int iCurrent
call super::create
this.st_page=create st_page
this.pb_up=create pb_up
this.pb_down=create pb_down
this.cb_ok=create cb_ok
this.dw_transcription_history=create dw_transcription_history
this.st_1=create st_1
this.st_status=create st_status
this.st_status_title=create st_status_title
this.st_created_by=create st_created_by
this.st_created_by_title=create st_created_by_title
this.st_created=create st_created
this.st_created_title=create st_created_title
this.st_title=create st_title
this.st_storage_flag=create st_storage_flag
this.st_storage_flag_title=create st_storage_flag_title
this.st_extension=create st_extension
this.st_extension_title=create st_extension_title
this.st_attachment_type=create st_attachment_type
this.st_attachment_type_title=create st_attachment_type_title
this.st_attached_by=create st_attached_by
this.st_attached_by_title=create st_attached_by_title
this.st_attachment_date=create st_attachment_date
this.st_attachment_date_title=create st_attachment_date_title
this.st_attachment_folder=create st_attachment_folder
this.st_attachment_folder_title=create st_attachment_folder_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_page
this.Control[iCurrent+2]=this.pb_up
this.Control[iCurrent+3]=this.pb_down
this.Control[iCurrent+4]=this.cb_ok
this.Control[iCurrent+5]=this.dw_transcription_history
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.st_status
this.Control[iCurrent+8]=this.st_status_title
this.Control[iCurrent+9]=this.st_created_by
this.Control[iCurrent+10]=this.st_created_by_title
this.Control[iCurrent+11]=this.st_created
this.Control[iCurrent+12]=this.st_created_title
this.Control[iCurrent+13]=this.st_title
this.Control[iCurrent+14]=this.st_storage_flag
this.Control[iCurrent+15]=this.st_storage_flag_title
this.Control[iCurrent+16]=this.st_extension
this.Control[iCurrent+17]=this.st_extension_title
this.Control[iCurrent+18]=this.st_attachment_type
this.Control[iCurrent+19]=this.st_attachment_type_title
this.Control[iCurrent+20]=this.st_attached_by
this.Control[iCurrent+21]=this.st_attached_by_title
this.Control[iCurrent+22]=this.st_attachment_date
this.Control[iCurrent+23]=this.st_attachment_date_title
this.Control[iCurrent+24]=this.st_attachment_folder
this.Control[iCurrent+25]=this.st_attachment_folder_title
end on

on w_attachment_properties.destroy
call super::destroy
destroy(this.st_page)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.cb_ok)
destroy(this.dw_transcription_history)
destroy(this.st_1)
destroy(this.st_status)
destroy(this.st_status_title)
destroy(this.st_created_by)
destroy(this.st_created_by_title)
destroy(this.st_created)
destroy(this.st_created_title)
destroy(this.st_title)
destroy(this.st_storage_flag)
destroy(this.st_storage_flag_title)
destroy(this.st_extension)
destroy(this.st_extension_title)
destroy(this.st_attachment_type)
destroy(this.st_attachment_type_title)
destroy(this.st_attached_by)
destroy(this.st_attached_by_title)
destroy(this.st_attachment_date)
destroy(this.st_attachment_date_title)
destroy(this.st_attachment_folder)
destroy(this.st_attachment_folder_title)
end on

event open;call super::open;integer i
long ll_row
string ls_who
string ls_what
str_p_attachment_progress lstra_progress[]
integer li_count

attachment = message.powerobjectparm

st_attachment_type.text = datalist.attachment_type_description(attachment.attachment_type)
st_attached_by.text = user_list.user_full_name(attachment.attached_by)
st_attachment_date.text = string(attachment.attachment_date)
st_attachment_folder.text = attachment.attachment_folder
st_created.text = string(attachment.created)
st_created_by.text = user_list.user_full_name(attachment.created_by)
st_extension.text = attachment.extension
st_status.text = attachment.status
if attachment.storage_flag = "F" then
	st_storage_flag.text = "File"
else
	st_storage_flag.text = "Database"
end if

li_count = attachment.get_attachment_progress("1=1",lstra_progress)

ls_who = string(attachment.created, "[shortdate] [time]")
ls_who += "  " + user_list.user_full_name(attachment.attached_by)
ll_row = dw_transcription_history.insertrow(0)
dw_transcription_history.object.who[ll_row] = ls_who
dw_transcription_history.object.what[ll_row] = "Attachment Created"
dw_transcription_history.object.progress_type[ll_row] = "CREATED"
	
for i = 1 to li_count
	ls_who = string(lstra_progress[i].created, "[shortdate] [time]")
	ls_who += "  " + user_list.user_full_name(lstra_progress[i].user_id)
	CHOOSE CASE upper(lstra_progress[i].progress_type)
		CASE "UPDATE"
			ls_what = "Attachment Modified"
		CASE "TEXT"
			ls_what = "Transcription"
		CASE "DELETED"
			ls_what = "Deleted"
		CASE "ATTACHMENT_FOLDER"
			ls_what = "File In Folder"
		CASE ELSE
			ls_what = lstra_progress[i].progress_type
	END CHOOSE
	ll_row = dw_transcription_history.insertrow(0)
	dw_transcription_history.object.who[ll_row] = ls_who
	dw_transcription_history.object.what[ll_row] = ls_what
	dw_transcription_history.object.progress_type[ll_row] = lstra_progress[i].progress_type
	dw_transcription_history.object.transcription[ll_row] = lstra_progress[i].progress
	dw_transcription_history.object.attachment_progress_sequence[ll_row] = lstra_progress[i].attachment_progress_sequence
next

dw_transcription_history.set_page(1, pb_up, pb_down, st_page)

end event

type pb_epro_help from w_window_base`pb_epro_help within w_attachment_properties
integer x = 2670
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_attachment_properties
integer x = 59
integer y = 1564
end type

type st_page from statictext within w_attachment_properties
integer x = 2725
integer y = 1056
integer width = 151
integer height = 116
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Page 99/99"
boolean focusrectangle = false
end type

type pb_up from picturebutton within w_attachment_properties
integer x = 2725
integer y = 800
integer width = 137
integer height = 116
integer taborder = 20
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;integer li_page

li_page = dw_transcription_history.current_page

dw_transcription_history.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from picturebutton within w_attachment_properties
integer x = 2725
integer y = 932
integer width = 137
integer height = 116
integer taborder = 50
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;integer li_page
integer li_last_page

li_page = dw_transcription_history.current_page
li_last_page = dw_transcription_history.last_page

dw_transcription_history.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type cb_ok from commandbutton within w_attachment_properties
integer x = 2386
integer y = 1592
integer width = 471
integer height = 104
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;close(parent)

end event

type dw_transcription_history from u_dw_pick_list within w_attachment_properties
integer x = 105
integer y = 800
integer width = 2601
integer height = 748
integer taborder = 20
string dataobject = "dw_transcription_history"
borderstyle borderstyle = stylelowered!
end type

event post_click;call super::post_click;string ls_temp_file,ls_progress_type
integer li_sts
blob lbl_attachment
long ll_attachment_progress_sequence

ls_progress_type = object.progress_type[clicked_row]

ls_temp_file = f_temp_file(attachment.extension)
if isnull(ls_temp_file) then return

CHOOSE CASE upper(ls_progress_type)
	CASE "CREATED"
		
		ll_attachment_progress_sequence = object.attachment_progress_sequence[clicked_row]
			
		SELECTBLOB attachment_image
		INTO :lbl_attachment
		FROM p_Attachment
		WHERE attachment_id = :attachment.attachment_id
		USING sqlca;
		if not tf_check() then 
			log.log(this,"w_attachment_properties.dw_transcription_history.post_click:0022","unable to get attachment image",3)
			return
		end if
	
		li_sts = log.file_write(lbl_attachment, ls_temp_file)
		if li_sts <= 0 Then return
		
	CASE "UPDATE"
		
		ll_attachment_progress_sequence = object.attachment_progress_sequence[clicked_row]
			
		SELECTBLOB attachment_image
		INTO :lbl_attachment
		FROM p_Attachment_Progress
		WHERE attachment_id = :attachment.attachment_id
		AND attachment_progress_sequence = :ll_attachment_progress_sequence
		USING sqlca;
		if not tf_check() then 
			log.log(this,"w_attachment_properties.dw_transcription_history.post_click:0040","unable to get attachment image",3)
			return
		end if
	
		li_sts = log.file_write(lbl_attachment, ls_temp_file)
		if li_sts <= 0 Then return
		
END CHOOSE

if fileexists(ls_temp_file) then
	f_open_file(ls_temp_file, false)
end if

end event

type st_1 from statictext within w_attachment_properties
integer x = 105
integer y = 732
integer width = 247
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "History"
boolean focusrectangle = false
end type

type st_status from statictext within w_attachment_properties
integer x = 1938
integer y = 636
integer width = 818
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type st_status_title from statictext within w_attachment_properties
integer x = 1422
integer y = 636
integer width = 494
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Current Status:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_created_by from statictext within w_attachment_properties
integer x = 1938
integer y = 536
integer width = 818
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type st_created_by_title from statictext within w_attachment_properties
integer x = 1422
integer y = 536
integer width = 494
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Created By:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_created from statictext within w_attachment_properties
integer x = 1938
integer y = 436
integer width = 818
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type st_created_title from statictext within w_attachment_properties
integer x = 1490
integer y = 436
integer width = 425
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Create Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_title from statictext within w_attachment_properties
integer width = 2921
integer height = 120
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Attachment Properties"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_storage_flag from statictext within w_attachment_properties
integer x = 567
integer y = 436
integer width = 818
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type st_storage_flag_title from statictext within w_attachment_properties
integer x = 50
integer y = 436
integer width = 494
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Storage:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_extension from statictext within w_attachment_properties
integer x = 567
integer y = 260
integer width = 818
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type st_extension_title from statictext within w_attachment_properties
integer x = 50
integer y = 260
integer width = 494
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "File Extension:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_attachment_type from statictext within w_attachment_properties
integer x = 567
integer y = 160
integer width = 818
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type st_attachment_type_title from statictext within w_attachment_properties
integer x = 18
integer y = 160
integer width = 526
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Attachment Type:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_attached_by from statictext within w_attachment_properties
integer x = 1938
integer y = 260
integer width = 818
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type st_attached_by_title from statictext within w_attachment_properties
integer x = 1422
integer y = 260
integer width = 494
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Attached By:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_attachment_date from statictext within w_attachment_properties
integer x = 1938
integer y = 160
integer width = 818
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type st_attachment_date_title from statictext within w_attachment_properties
integer x = 1403
integer y = 160
integer width = 512
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Attachment Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_attachment_folder from statictext within w_attachment_properties
integer x = 567
integer y = 536
integer width = 818
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type st_attachment_folder_title from statictext within w_attachment_properties
integer x = 50
integer y = 536
integer width = 494
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Folder:"
alignment alignment = right!
boolean focusrectangle = false
end type

