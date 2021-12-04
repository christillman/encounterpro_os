$PBExportHeader$w_transcription_history.srw
forward
global type w_transcription_history from w_window_base
end type
type st_title from statictext within w_transcription_history
end type
type st_page from statictext within w_transcription_history
end type
type pb_up from picturebutton within w_transcription_history
end type
type pb_down from picturebutton within w_transcription_history
end type
type cb_ok from commandbutton within w_transcription_history
end type
type dw_transcription_history from u_dw_pick_list within w_transcription_history
end type
type ole_attachment from u_ole_control within w_transcription_history
end type
end forward

global type w_transcription_history from w_window_base
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_title st_title
st_page st_page
pb_up pb_up
pb_down pb_down
cb_ok cb_ok
dw_transcription_history dw_transcription_history
ole_attachment ole_attachment
end type
global w_transcription_history w_transcription_history

type variables
u_component_attachment attachment

end variables

on w_transcription_history.create
int iCurrent
call super::create
this.st_title=create st_title
this.st_page=create st_page
this.pb_up=create pb_up
this.pb_down=create pb_down
this.cb_ok=create cb_ok
this.dw_transcription_history=create dw_transcription_history
this.ole_attachment=create ole_attachment
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.st_page
this.Control[iCurrent+3]=this.pb_up
this.Control[iCurrent+4]=this.pb_down
this.Control[iCurrent+5]=this.cb_ok
this.Control[iCurrent+6]=this.dw_transcription_history
this.Control[iCurrent+7]=this.ole_attachment
end on

on w_transcription_history.destroy
call super::destroy
destroy(this.st_title)
destroy(this.st_page)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.cb_ok)
destroy(this.dw_transcription_history)
destroy(this.ole_attachment)
end on

event open;call super::open;integer i
long ll_row
string ls_who
string ls_what
str_p_attachment_progress lstra_progress[]
integer li_count

attachment = message.powerobjectparm

li_count = attachment.get_attachment_progress("1=1",lstra_progress)

if li_count <= 0 then
	log.log(this, "w_transcription_history:open", "No transcription history", 4)
	close(this)
	return
end if

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

dw_transcription_history.set_page(1, st_page.text)
If dw_transcription_history.last_page > 1 then
	pb_up.visible = true
	pb_down.visible = true
	st_page.visible = true
	pb_up.enabled = false
	pb_down.enabled = true
else
	pb_up.visible = false
	pb_down.visible = false
	st_page.visible = false
End if

end event

type pb_epro_help from w_window_base`pb_epro_help within w_transcription_history
end type

type st_title from statictext within w_transcription_history
integer width = 2921
integer height = 120
boolean bringtotop = true
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Transcription History"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_page from statictext within w_transcription_history
integer x = 2702
integer y = 76
integer width = 197
integer height = 56
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "99 of 99"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_up from picturebutton within w_transcription_history
integer x = 2734
integer y = 132
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

type pb_down from picturebutton within w_transcription_history
integer x = 2734
integer y = 264
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

type cb_ok from commandbutton within w_transcription_history
integer x = 2391
integer y = 1696
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

type dw_transcription_history from u_dw_pick_list within w_transcription_history
integer x = 178
integer y = 140
integer width = 2528
integer height = 1536
integer taborder = 20
string dataobject = "dw_transcription_history"
borderstyle borderstyle = stylelowered!
end type

event post_click(long clicked_row);call super::post_click;string ls_temp_file,ls_progress_type
integer li_sts
blob lbl_attachment
long ll_attachment_progress_sequence

ls_progress_type = object.progress_type[clicked_row]
CHOOSE CASE upper(ls_progress_type)
	CASE "CREATED"
		ls_temp_file = f_temp_file(attachment.extension)
		if isnull(ls_temp_file) then return
		
		ll_attachment_progress_sequence = object.attachment_progress_sequence[clicked_row]
			
		SELECTBLOB attachment_image
		INTO :lbl_attachment
		FROM p_Attachment
		WHERE attachment_id = :attachment.attachment_id
		USING sqlca;
		if not tf_check() then 
			log.log(this,"w_transcription_history.dw_transcription_history.post_click:0020","unable to get attachment image",3)
			return
		end if
	
		li_sts = log.file_write(lbl_attachment, ls_temp_file)
		if li_sts <= 0 Then return
		
		ole_attachment.insertfile(ls_temp_file)
		ole_attachment.activate(offsite!)
	CASE "UPDATE"
		ls_temp_file = f_temp_file(attachment.extension)
		if isnull(ls_temp_file) then return
		
		ll_attachment_progress_sequence = object.attachment_progress_sequence[clicked_row]
			
		SELECTBLOB attachment_image
		INTO :lbl_attachment
		FROM p_Attachment_Progress
		WHERE attachment_id = :attachment.attachment_id
		AND attachment_progress_sequence = :ll_attachment_progress_sequence
		USING sqlca;
		if not tf_check() then 
			log.log(this,"w_transcription_history.dw_transcription_history.post_click:0042","unable to get attachment image",3)
			return
		end if
	
		li_sts = log.file_write(lbl_attachment, ls_temp_file)
		if li_sts <= 0 Then return
		
		ole_attachment.insertfile(ls_temp_file)
		ole_attachment.activate(offsite!)
END CHOOSE


end event

type ole_attachment from u_ole_control within w_transcription_history
boolean visible = false
integer x = 178
integer y = 140
integer width = 2528
integer height = 1536
integer taborder = 60
string binarykey = "w_transcription_history.win"
end type


Start of PowerBuilder Binary Data Section : Do NOT Edit
0Ew_transcription_history.bin 
200000000a0000000000000000002b00000600e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe00000006000000000000000000000001000000010000000000001000fffffffe00000000fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000fffffffe00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2F000000000000000000000000000000000000001e0000000a00000000000000000000000e0000000000000000000000000000000a0000000000000000000000000000000f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1Ew_transcription_history.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
