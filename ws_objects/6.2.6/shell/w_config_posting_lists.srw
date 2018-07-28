HA$PBExportHeader$w_config_posting_lists.srw
forward
global type w_config_posting_lists from w_window_base
end type
type cb_finished from commandbutton within w_config_posting_lists
end type
type pb_up from u_picture_button within w_config_posting_lists
end type
type pb_down from u_picture_button within w_config_posting_lists
end type
type st_page from statictext within w_config_posting_lists
end type
type st_folder_title from statictext within w_config_posting_lists
end type
type st_description_title from statictext within w_config_posting_lists
end type
type dw_folders from u_dw_pick_list within w_config_posting_lists
end type
type st_description from statictext within w_config_posting_lists
end type
type cb_move from commandbutton within w_config_posting_lists
end type
type cb_delete from commandbutton within w_config_posting_lists
end type
type cb_new_folder from commandbutton within w_config_posting_lists
end type
end forward

global type w_config_posting_lists from w_window_base
string title = "Letter Types"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_finished cb_finished
pb_up pb_up
pb_down pb_down
st_page st_page
st_folder_title st_folder_title
st_description_title st_description_title
dw_folders dw_folders
st_description st_description
cb_move cb_move
cb_delete cb_delete
cb_new_folder cb_new_folder
end type
global w_config_posting_lists w_config_posting_lists

type variables

end variables

forward prototypes
public function integer refresh ()
end prototypes

public function integer refresh ();long ll_rows

ll_rows = dw_folders.retrieve()
dw_folders.set_page(1, pb_up, pb_down, st_page)


if ll_rows > 0 then
	dw_folders.object.selected_flag[1] = 1
	dw_folders.event trigger selected(1)
else
	st_description.text = ""
	
	st_description.enabled = false
	cb_delete.enabled = false
	cb_move.enabled = false
end if


return 1

end function

on w_config_posting_lists.create
int iCurrent
call super::create
this.cb_finished=create cb_finished
this.pb_up=create pb_up
this.pb_down=create pb_down
this.st_page=create st_page
this.st_folder_title=create st_folder_title
this.st_description_title=create st_description_title
this.dw_folders=create dw_folders
this.st_description=create st_description
this.cb_move=create cb_move
this.cb_delete=create cb_delete
this.cb_new_folder=create cb_new_folder
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_finished
this.Control[iCurrent+2]=this.pb_up
this.Control[iCurrent+3]=this.pb_down
this.Control[iCurrent+4]=this.st_page
this.Control[iCurrent+5]=this.st_folder_title
this.Control[iCurrent+6]=this.st_description_title
this.Control[iCurrent+7]=this.dw_folders
this.Control[iCurrent+8]=this.st_description
this.Control[iCurrent+9]=this.cb_move
this.Control[iCurrent+10]=this.cb_delete
this.Control[iCurrent+11]=this.cb_new_folder
end on

on w_config_posting_lists.destroy
call super::destroy
destroy(this.cb_finished)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.st_page)
destroy(this.st_folder_title)
destroy(this.st_description_title)
destroy(this.dw_folders)
destroy(this.st_description)
destroy(this.cb_move)
destroy(this.cb_delete)
destroy(this.cb_new_folder)
end on

event open;call super::open;integer li_sts
boolean lb_allow_delete
string ls_temp

dw_folders.settransobject(sqlca)

dw_folders.object.folder.width = dw_folders.width - 120

refresh()


end event

type pb_epro_help from w_window_base`pb_epro_help within w_config_posting_lists
boolean visible = true
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_config_posting_lists
end type

type cb_finished from commandbutton within w_config_posting_lists
integer x = 2395
integer y = 1588
integer width = 480
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
end type

event clicked;sqlca.sp_set_patient_folder_selection()
if not tf_check() then
	openwithparm(w_pop_message, "Folder Selection update failed")
	return
end if


close(parent)

end event

type pb_up from u_picture_button within w_config_posting_lists
integer x = 1714
integer y = 188
integer width = 137
integer height = 116
integer taborder = 40
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_folders.current_page

dw_folders.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from u_picture_button within w_config_posting_lists
integer x = 1714
integer y = 312
integer width = 137
integer height = 116
integer taborder = 30
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;integer li_page
integer li_last_page

li_page = dw_folders.current_page
li_last_page = dw_folders.last_page

dw_folders.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type st_page from statictext within w_config_posting_lists
integer x = 1723
integer y = 432
integer width = 123
integer height = 116
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Page 99/99"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_folder_title from statictext within w_config_posting_lists
integer x = 32
integer y = 84
integer width = 1673
integer height = 80
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Posting List"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_description_title from statictext within w_config_posting_lists
integer x = 1851
integer y = 376
integer width = 1024
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
string text = "Description"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_folders from u_dw_pick_list within w_config_posting_lists
integer x = 32
integer y = 180
integer width = 1673
integer height = 1476
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_posting_folder_display"
boolean border = false
end type

event selected;call super::selected;string ls_context_object
string ls_context_object_type
integer li_sts
str_popup popup
str_popup_return popup_return
string ls_folder
string ls_null
long ll_count
long ll_row

setnull(ls_null)

ls_folder = object.folder[selected_row]
ls_context_object = object.context_object[selected_row]
ls_context_object_type = object.context_object_type[selected_row]


st_description.text = object.description[selected_row]

st_description.enabled = true
cb_delete.enabled = true
cb_move.enabled = true


end event

event unselected;call super::unselected;st_description.text = ""

st_description.enabled = false
cb_delete.enabled = false
cb_move.enabled = false


end event

type st_description from statictext within w_config_posting_lists
integer x = 1851
integer y = 460
integer width = 1024
integer height = 228
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;integer li_sts
str_popup popup
str_popup_return popup_return
string ls_description
long ll_row

ll_row = dw_folders.get_selected_row()
if ll_row <= 0 then return 0

ls_description = dw_folders.object.description[ll_row]

popup.title = "Enter the description of this folder"
popup.item = ls_description
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_description = trim(popup_return.items[1])
if ls_description = "" then return

dw_folders.object.description[ll_row] = ls_description
text = ls_description

li_sts = dw_folders.update()
if li_sts <= 0 then
	openwithparm(w_pop_message, "description update failed")
	return
end if




end event

type cb_move from commandbutton within w_config_posting_lists
integer x = 1851
integer y = 1180
integer width = 480
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Move"
end type

event clicked;str_popup popup
long ll_row
integer li_sts
long ll_rowcount
long i

ll_row = dw_folders.get_selected_row()
if ll_row <= 0 then return 0

ll_rowcount = dw_folders.rowcount()
for i = 1 to ll_rowcount
	dw_folders.object.sort_sequence[ll_row] = i
next

popup.objectparm = dw_folders

openwithparm(w_pick_list_sort, popup)

li_sts = dw_folders.update()
if li_sts <= 0 then
	openwithparm(w_pop_message, "Sort update failed")
	return
end if

return


end event

type cb_delete from commandbutton within w_config_posting_lists
integer x = 2395
integer y = 1180
integer width = 480
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete"
end type

event clicked;str_popup_return popup_return
long ll_row
integer li_sts
string ls_folder

ll_row = dw_folders.get_selected_row()
if ll_row <= 0 then return

openwithparm(w_pop_yes_no, "Are you sure you want to delete the selected folder?")
popup_return = message.powerobjectparm
if popup_return.item = "YES" then
	ls_folder = dw_folders.object.folder[ll_row]
	dw_folders.object.status[ll_row] = 'NA'
	li_sts = dw_folders.update()
	if li_sts > 0 then
		// Clear the folder of any to-be-posted attachments still in that folder
		UPDATE p_Attachment
		SET attachment_folder = NULL
		WHERE cpr_id IS NULL
		AND attachment_folder = :ls_folder
		AND status = 'OK';
		if not tf_check() then return
	end if
	
	refresh()
end if


end event

type cb_new_folder from commandbutton within w_config_posting_lists
integer x = 2126
integer y = 1336
integer width = 480
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Folder"
end type

event clicked;integer li_sts
str_popup popup
str_popup_return popup_return
string ls_folder
long ll_row

popup.title = "Enter the name of the new folder"
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_folder = trim(popup_return.items[1])
if ls_folder = "" then return

dw_folders.clear_selected()

ll_row = dw_folders.insertrow(0)
dw_folders.object.folder[ll_row] = ls_folder
dw_folders.object.context_object[ll_row] = "General"
dw_folders.object.description[ll_row] = ls_folder
dw_folders.object.status[ll_row] = "OK"
dw_folders.object.sort_sequence[ll_row] = ll_row
dw_folders.object.selected_flag[ll_row] = 1

li_sts = dw_folders.update()
if li_sts <= 0 then
	openwithparm(w_pop_message, "New folder create failed")
	return
end if

dw_folders.scrolltorow(ll_row)

// post a selected event
dw_folders.event post selected(ll_row)



end event

