$PBExportHeader$w_message_folder_edit.srw
forward
global type w_message_folder_edit from w_window_base
end type
type cb_ok from commandbutton within w_message_folder_edit
end type
type cb_sort from commandbutton within w_message_folder_edit
end type
type cb_move from commandbutton within w_message_folder_edit
end type
type st_page from statictext within w_message_folder_edit
end type
type pb_down from u_picture_button within w_message_folder_edit
end type
type pb_up from u_picture_button within w_message_folder_edit
end type
type dw_top_20_list from u_dw_pick_list within w_message_folder_edit
end type
type cb_delete from commandbutton within w_message_folder_edit
end type
type cb_new_item from commandbutton within w_message_folder_edit
end type
type st_title from statictext within w_message_folder_edit
end type
end forward

global type w_message_folder_edit from w_window_base
integer height = 1836
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_ok cb_ok
cb_sort cb_sort
cb_move cb_move
st_page st_page
pb_down pb_down
pb_up pb_up
dw_top_20_list dw_top_20_list
cb_delete cb_delete
cb_new_item cb_new_item
st_title st_title
end type
global w_message_folder_edit w_message_folder_edit

type variables
string top_20_code

end variables

forward prototypes
public function integer move_row (long pl_row)
public subroutine new_item ()
public subroutine sort_rows ()
public function integer refresh ()
end prototypes

public function integer move_row (long pl_row);str_popup popup
string ls_user_id
long i
string ls_procedure_id
string ls_description
string ls_null
long ll_null
long ll_row
integer li_sts

setnull(ls_null)
setnull(ll_null)

if pl_row <= 0 then return 0

ll_row = dw_top_20_list.get_selected_row()
if ll_row <= 0 then
	dw_top_20_list.object.selected_flag[pl_row] = 1
end if

popup.objectparm = dw_top_20_list

openwithparm(w_pick_list_sort, popup)

li_sts = dw_top_20_list.update()

if ll_row <= 0 then
	dw_top_20_list.clear_selected()
end if

return 1
end function

public subroutine new_item ();long ll_row
long ll_top_20_sequence
string ls_description
str_popup popup
str_popup_return popup_return
string ls_item_text, ls_item_id, ls_item_id2
long ll_item_id3
integer li_sts

popup.item = "Enter New " + st_title.text + ":"
openwithparm(w_pop_get_string, popup)
popup_return = message.powerobjectparm
ls_item_text = popup_return.item
if isnull(ls_item_text) or ls_item_text = "" then return
setnull(ls_item_id)
setnull(ls_item_id2)
setnull(ll_item_id3)

li_sts = tf_add_personal_top_20(top_20_code, ls_item_text, ls_item_id, ls_item_id2, ll_item_id3)

refresh()

end subroutine

public subroutine sort_rows ();long i
long ll_rowcount
long ll_row
integer li_sts

dw_top_20_list.clear_selected()

dw_top_20_list.setsort("item_text A")
dw_top_20_list.sort()

ll_rowcount = dw_top_20_list.rowcount()

for i = 1 to ll_rowcount
	dw_top_20_list.setitem(i, "sort_sequence", i)
next

dw_top_20_list.setsort("sort_sequence A")
dw_top_20_list.sort()

dw_top_20_list.set_page(1, pb_up, pb_down, st_page)

li_sts = dw_top_20_list.update()

return

end subroutine

public function integer refresh ();integer li_sts

li_sts = dw_top_20_list.retrieve(current_user.user_id, top_20_code)
if li_sts < 0 then return -1

dw_top_20_list.set_page(1, pb_up, pb_down, st_page)

return 1

end function

event open;call super::open;
top_20_code = message.stringparm

dw_top_20_list.settransobject(sqlca)

refresh()



end event

on w_message_folder_edit.create
int iCurrent
call super::create
this.cb_ok=create cb_ok
this.cb_sort=create cb_sort
this.cb_move=create cb_move
this.st_page=create st_page
this.pb_down=create pb_down
this.pb_up=create pb_up
this.dw_top_20_list=create dw_top_20_list
this.cb_delete=create cb_delete
this.cb_new_item=create cb_new_item
this.st_title=create st_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ok
this.Control[iCurrent+2]=this.cb_sort
this.Control[iCurrent+3]=this.cb_move
this.Control[iCurrent+4]=this.st_page
this.Control[iCurrent+5]=this.pb_down
this.Control[iCurrent+6]=this.pb_up
this.Control[iCurrent+7]=this.dw_top_20_list
this.Control[iCurrent+8]=this.cb_delete
this.Control[iCurrent+9]=this.cb_new_item
this.Control[iCurrent+10]=this.st_title
end on

on w_message_folder_edit.destroy
call super::destroy
destroy(this.cb_ok)
destroy(this.cb_sort)
destroy(this.cb_move)
destroy(this.st_page)
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.dw_top_20_list)
destroy(this.cb_delete)
destroy(this.cb_new_item)
destroy(this.st_title)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_message_folder_edit
boolean visible = true
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_message_folder_edit
end type

type cb_ok from commandbutton within w_message_folder_edit
integer x = 2336
integer y = 1596
integer width = 489
integer height = 112
integer taborder = 20
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

type cb_sort from commandbutton within w_message_folder_edit
integer x = 2007
integer y = 772
integer width = 503
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Sort"
end type

event clicked;sort_rows()

end event

type cb_move from commandbutton within w_message_folder_edit
integer x = 2007
integer y = 588
integer width = 503
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Move"
end type

event clicked;long ll_row
integer li_sts

ll_row = dw_top_20_list.get_selected_row()
if ll_row <= 0 then return

li_sts = move_row(ll_row)


end event

type st_page from statictext within w_message_folder_edit
integer x = 1513
integer y = 444
integer width = 293
integer height = 64
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
boolean focusrectangle = false
end type

type pb_down from u_picture_button within w_message_folder_edit
integer x = 1509
integer y = 328
integer width = 137
integer height = 116
integer taborder = 50
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_top_20_list.current_page
li_last_page = dw_top_20_list.last_page

dw_top_20_list.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type pb_up from u_picture_button within w_message_folder_edit
integer x = 1509
integer y = 204
integer width = 137
integer height = 116
integer taborder = 60
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_top_20_list.current_page

dw_top_20_list.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true
end event

type dw_top_20_list from u_dw_pick_list within w_message_folder_edit
integer x = 197
integer y = 196
integer width = 1312
integer height = 1492
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_top_20_edit"
boolean border = false
boolean livescroll = false
end type

type cb_delete from commandbutton within w_message_folder_edit
integer x = 2007
integer y = 960
integer width = 503
integer height = 108
integer taborder = 90
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete"
end type

event clicked;integer li_sts
long ll_row

ll_row = dw_top_20_list.get_selected_row()
if ll_row <= 0 then return

dw_top_20_list.deleterow(ll_row)
li_sts = dw_top_20_list.update()


end event

type cb_new_item from commandbutton within w_message_folder_edit
integer x = 2007
integer y = 1148
integer width = 503
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Folder"
end type

event clicked;new_item()

end event

type st_title from statictext within w_message_folder_edit
integer width = 2921
integer height = 136
integer textsize = -14
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Edit Message Folders"
alignment alignment = center!
boolean focusrectangle = false
end type

