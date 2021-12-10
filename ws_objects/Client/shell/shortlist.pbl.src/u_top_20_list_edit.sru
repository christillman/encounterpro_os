$PBExportHeader$u_top_20_list_edit.sru
forward
global type u_top_20_list_edit from u_tabpage
end type
type cb_sort from commandbutton within u_top_20_list_edit
end type
type cb_move from commandbutton within u_top_20_list_edit
end type
type st_page from statictext within u_top_20_list_edit
end type
type pb_down from u_picture_button within u_top_20_list_edit
end type
type pb_up from u_picture_button within u_top_20_list_edit
end type
type st_title from statictext within u_top_20_list_edit
end type
type dw_top_20_list from u_dw_pick_list within u_top_20_list_edit
end type
type cb_delete from commandbutton within u_top_20_list_edit
end type
type cb_new_item from commandbutton within u_top_20_list_edit
end type
type cb_toggle_list from commandbutton within u_top_20_list_edit
end type
type st_which_list from statictext within u_top_20_list_edit
end type
type cb_delete_list from commandbutton within u_top_20_list_edit
end type
end forward

global type u_top_20_list_edit from u_tabpage
integer height = 1628
cb_sort cb_sort
cb_move cb_move
st_page st_page
pb_down pb_down
pb_up pb_up
st_title st_title
dw_top_20_list dw_top_20_list
cb_delete cb_delete
cb_new_item cb_new_item
cb_toggle_list cb_toggle_list
st_which_list st_which_list
cb_delete_list cb_delete_list
end type
global u_top_20_list_edit u_top_20_list_edit

type variables
string top_20_code
boolean use_default

long selected_row

boolean user_only

end variables

forward prototypes
public subroutine save_changes ()
public subroutine new_item ()
public subroutine set_selected_row (long pl_row)
public subroutine set_user_list ()
public function integer initialize (string ps_top_20_code)
public subroutine delete_item ()
public subroutine set_default_list ()
public function integer move_row (long pl_row)
public subroutine sort_rows ()
end prototypes

public subroutine save_changes ();integer li_sts

li_sts = dw_top_20_list.update()

return

end subroutine

public subroutine new_item ();long ll_row
long ll_top_20_sequence
string ls_description
str_popup popup
str_popup_return popup_return
string ls_item_text, ls_item_id, ls_item_id2
long ll_item_id3

popup.item = "Enter New " + st_title.text + ":"
openwithparm(w_pop_get_string, popup)
popup_return = message.powerobjectparm
ls_item_text = popup_return.item
if isnull(ls_item_text) or ls_item_text = "" then return
setnull(ls_item_id)
setnull(ls_item_id2)
setnull(ll_item_id3)

ll_row = dw_top_20_list.rowcount()
if ll_row > 0 then
	ll_top_20_sequence = dw_top_20_list.object.top_20_sequence[ll_row] + 10
else
	ll_top_20_sequence = 10
end if

ll_row = dw_top_20_list.insertrow(0)
if use_default then
	dw_top_20_list.setitem(ll_row, "user_id", current_user.common_list_id())
else
	dw_top_20_list.setitem(ll_row, "user_id", current_user.user_id)
end if
dw_top_20_list.setitem(ll_row, "top_20_code", top_20_code)
dw_top_20_list.setitem(ll_row, "top_20_sequence", ll_top_20_sequence)
dw_top_20_list.setitem(ll_row, "item_text", ls_item_text)
dw_top_20_list.setitem(ll_row, "item_id", ls_item_id)
dw_top_20_list.setitem(ll_row, "item_id2", ls_item_id2)
dw_top_20_list.setitem(ll_row, "item_id3", ll_item_id3)

set_selected_row(ll_row)

end subroutine

public subroutine set_selected_row (long pl_row);
if pl_row > 0 then
	if selected_row > 0 then dw_top_20_list.setitem(selected_row, "selected_flag", 0)
	dw_top_20_list.setitem(pl_row, "selected_flag", 1)
else
	dw_top_20_list.clear_selected()
end if

selected_row = pl_row

if selected_row > 0 then
	cb_delete.enabled = true
else
	cb_delete.enabled = false
end if

dw_top_20_list.scrolltorow(selected_row)
dw_top_20_list.recalc_page(pb_up,pb_down,st_page)
end subroutine

public subroutine set_user_list ();string ls_filter
str_popup_return popup_return
long i, ll_row
string ls_item_text, ls_item_id, ls_item_id2
long ll_item_id3


dw_top_20_list.setredraw(false)
dw_top_20_list.retrieve(current_user.user_id, top_20_code)

use_default = false
cb_toggle_list.text = "Use Personal List"
st_which_list.text = "Personal List"

cb_new_item.visible = true
cb_move.visible = true

if user_only then
	cb_delete_list.visible = false
else
	cb_delete_list.visible = true
end if

If dw_top_20_list.rowcount() = 0 AND NOT user_only Then
	Openwithparm(w_pop_yes_no, "Do you wish to start with the defaults")
	popup_return = message.powerobjectparm
	If popup_return.item = "YES" Then
 		f_copy_top_20_common_list(current_user.user_id,current_user.specialty_id,top_20_code)
		dw_top_20_list.retrieve(current_user.user_id, top_20_code)
	End If
End If

set_selected_row(0)
dw_top_20_list.last_page = 0
dw_top_20_list.set_page(1, pb_up,pb_down, st_page)
dw_top_20_list.setredraw(true)
end subroutine

public function integer initialize (string ps_top_20_code);string ls_find
long ll_find
integer li_sts


dw_top_20_list.height = height - dw_top_20_list.y
cb_toggle_list.y = height - 250
cb_delete_list.y = cb_toggle_list.y

top_20_code = ps_top_20_code

li_sts = tf_get_domain_item("TOP_20_CODE", top_20_code, st_title.text)
if li_sts < 0 then st_title.text = top_20_code


dw_top_20_list.settransobject(sqlca)

if not user_only then
	set_default_list()
else
	set_user_list()
end if

if user_only then
	cb_toggle_list.visible = false
	st_which_list.visible = false
else
	cb_toggle_list.visible = true
	st_which_list.visible = true
end if

dw_top_20_list.last_page = 0
dw_top_20_list.set_page(1,pb_up, pb_down, st_page)

Return 1

end function

public subroutine delete_item ();if selected_row > 0 and selected_row <= dw_top_20_list.rowcount() then
	dw_top_20_list.deleterow(selected_row)
	dw_top_20_list.update()
	dw_top_20_list.recalc_page(st_page.text)
end if

//set_selected_row(0)


end subroutine

public subroutine set_default_list ();string ls_common_list_id

dw_top_20_list.setredraw(false)
ls_common_list_id = current_user.common_list_id()
dw_top_20_list.retrieve(ls_common_list_id, top_20_code)

use_default = true
cb_toggle_list.text = "Use Common List"
st_which_list.text = "Common List"
cb_delete_list.visible = false

if current_user.check_privilege("Edit Common Short Lists") then
	cb_new_item.visible = true
	cb_move.visible = true
	cb_delete.visible = true
else
	openwithparm(w_pop_message, "You do not have permission to edit the default list")
	cb_new_item.visible = false
	cb_move.visible = false
	cb_delete.visible = false
end if

set_selected_row(0)
dw_top_20_list.last_page = 0
dw_top_20_list.set_page(1,pb_up,pb_down,st_page)

dw_top_20_list.setredraw(true)

end subroutine

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

on u_top_20_list_edit.create
int iCurrent
call super::create
this.cb_sort=create cb_sort
this.cb_move=create cb_move
this.st_page=create st_page
this.pb_down=create pb_down
this.pb_up=create pb_up
this.st_title=create st_title
this.dw_top_20_list=create dw_top_20_list
this.cb_delete=create cb_delete
this.cb_new_item=create cb_new_item
this.cb_toggle_list=create cb_toggle_list
this.st_which_list=create st_which_list
this.cb_delete_list=create cb_delete_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_sort
this.Control[iCurrent+2]=this.cb_move
this.Control[iCurrent+3]=this.st_page
this.Control[iCurrent+4]=this.pb_down
this.Control[iCurrent+5]=this.pb_up
this.Control[iCurrent+6]=this.st_title
this.Control[iCurrent+7]=this.dw_top_20_list
this.Control[iCurrent+8]=this.cb_delete
this.Control[iCurrent+9]=this.cb_new_item
this.Control[iCurrent+10]=this.cb_toggle_list
this.Control[iCurrent+11]=this.st_which_list
this.Control[iCurrent+12]=this.cb_delete_list
end on

on u_top_20_list_edit.destroy
call super::destroy
destroy(this.cb_sort)
destroy(this.cb_move)
destroy(this.st_page)
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.st_title)
destroy(this.dw_top_20_list)
destroy(this.cb_delete)
destroy(this.cb_new_item)
destroy(this.cb_toggle_list)
destroy(this.st_which_list)
destroy(this.cb_delete_list)
end on

event resize_tabpage;integer li_right
integer li_x

dw_top_20_list.width = width / 2
dw_top_20_list.height = height
st_title.x = width / 2
st_title.width = width / 2
//cb_page.x = (width / 2) + 40

li_right = ((width / 2) - cb_move.width) / 2

li_x = width - cb_move.width - li_right

cb_move.x = li_x
cb_delete.x = li_x
cb_new_item.x = li_x




end event

type cb_sort from commandbutton within u_top_20_list_edit
integer x = 1733
integer y = 724
integer width = 402
integer height = 112
integer taborder = 30
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

type cb_move from commandbutton within u_top_20_list_edit
integer x = 1733
integer y = 540
integer width = 402
integer height = 112
integer taborder = 20
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

type st_page from statictext within u_top_20_list_edit
integer x = 1312
integer y = 500
integer width = 293
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Page 99/99"
boolean focusrectangle = false
end type

type pb_down from u_picture_button within u_top_20_list_edit
integer x = 1307
integer y = 384
integer width = 137
integer height = 116
integer taborder = 40
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

type pb_up from u_picture_button within u_top_20_list_edit
integer x = 1307
integer y = 260
integer width = 137
integer height = 116
integer taborder = 50
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_top_20_list.current_page

dw_top_20_list.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true
end event

type st_title from statictext within u_top_20_list_edit
integer x = 1312
integer y = 4
integer width = 1243
integer height = 136
boolean bringtotop = true
integer textsize = -14
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_top_20_list from u_dw_pick_list within u_top_20_list_edit
integer width = 1312
integer height = 1620
integer taborder = 10
string dataobject = "dw_top_20_edit"
boolean border = false
boolean livescroll = false
end type

event post_click;call super::post_click;integer li_selected_flag

if lastrow <= 0 then return

li_selected_flag = object.selected_flag[lastrow]
if li_selected_flag > 0 then
	set_selected_row(lastrow)
else
	set_selected_row(0)
end if

end event

type cb_delete from commandbutton within u_top_20_list_edit
integer x = 1733
integer y = 912
integer width = 393
integer height = 108
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete"
end type

event clicked;delete_item()

end event

type cb_new_item from commandbutton within u_top_20_list_edit
integer x = 1733
integer y = 1100
integer width = 393
integer height = 108
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Item"
end type

event clicked;new_item()

end event

type cb_toggle_list from commandbutton within u_top_20_list_edit
integer x = 1349
integer y = 1416
integer width = 603
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Personal List"
end type

event clicked;if use_default then
	set_user_list()
else
	set_default_list()
end if
If dw_top_20_list.last_page < 2 then
	pb_down.visible = false
	pb_up.visible = false
Else
	pb_down.visible = true
	pb_up.visible = true
	pb_up.enabled = false
	pb_down.enabled = true
End if
end event

type st_which_list from statictext within u_top_20_list_edit
integer x = 1312
integer y = 160
integer width = 1243
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_delete_list from commandbutton within u_top_20_list_edit
integer x = 1989
integer y = 1416
integer width = 370
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete List"
end type

event clicked;str_popup_return popup_return
long i
long ll_rowcount

openwithparm(w_pop_yes_no, "Are you sure you wish to delete your personal list?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

ll_rowcount = dw_top_20_list.rowcount()

for i = ll_rowcount to 1 step -1
	dw_top_20_list.deleterow(i)
next
dw_top_20_list.update()
set_default_list()


end event

