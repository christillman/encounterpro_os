$PBExportHeader$u_domain_list_edit.sru
forward
global type u_domain_list_edit from userobject
end type
type st_page from statictext within u_domain_list_edit
end type
type pb_down from u_picture_button within u_domain_list_edit
end type
type pb_up from u_picture_button within u_domain_list_edit
end type
type cb_delete from commandbutton within u_domain_list_edit
end type
type cb_move_down from commandbutton within u_domain_list_edit
end type
type cb_move_up from commandbutton within u_domain_list_edit
end type
type cb_new_item from commandbutton within u_domain_list_edit
end type
type dw_domain_item_list from u_dw_pick_list within u_domain_list_edit
end type
type st_title from statictext within u_domain_list_edit
end type
end forward

global type u_domain_list_edit from userobject
integer width = 2400
integer height = 1748
long backcolor = 33538240
long tabtextcolor = 33554432
long tabbackcolor = 16777215
long picturemaskcolor = 536870912
st_page st_page
pb_down pb_down
pb_up pb_up
cb_delete cb_delete
cb_move_down cb_move_down
cb_move_up cb_move_up
cb_new_item cb_new_item
dw_domain_item_list dw_domain_item_list
st_title st_title
end type
global u_domain_list_edit u_domain_list_edit

type variables
string domain_id
integer selected_row

end variables

forward prototypes
public subroutine move_down ()
public subroutine move_up ()
public subroutine scroll (long pi_page)
public function integer initialize (string ps_domain_id, string ps_title)
public subroutine set_selected_row (long pl_row)
public subroutine delete_item ()
public subroutine new_item ()
end prototypes

public subroutine move_down ();integer li_domain_sequence, li_domain_sequence_below
long ll_row

if selected_row > 0 and selected_row < dw_domain_item_list.rowcount() then
	li_domain_sequence = dw_domain_item_list.object.domain_sequence[selected_row]
	li_domain_sequence_below = dw_domain_item_list.object.domain_sequence[selected_row + 1]
	dw_domain_item_list.setitem(selected_row, "domain_sequence", li_domain_sequence_below)
	dw_domain_item_list.setitem(selected_row + 1, "domain_sequence", li_domain_sequence)
	dw_domain_item_list.sort()
	ll_row = dw_domain_item_list.find("selected_flag=1", 1, dw_domain_item_list.rowcount())
	dw_domain_item_list.update()
	set_selected_row(ll_row)
end if


end subroutine

public subroutine move_up ();integer li_domain_sequence, li_domain_sequence_above
long ll_row

if selected_row > 1 then
	li_domain_sequence = dw_domain_item_list.object.domain_sequence[selected_row]
	li_domain_sequence_above = dw_domain_item_list.object.domain_sequence[selected_row - 1]
	dw_domain_item_list.setitem(selected_row, "domain_sequence", li_domain_sequence_above)
	dw_domain_item_list.setitem(selected_row - 1, "domain_sequence", li_domain_sequence)
	dw_domain_item_list.sort()
	ll_row = dw_domain_item_list.find("selected_flag=1", 1, dw_domain_item_list.rowcount())
	dw_domain_item_list.update()
	set_selected_row(ll_row)
end if


end subroutine

public subroutine scroll (long pi_page);dw_domain_item_list.last_page = 0
dw_domain_item_list.set_page(1, st_page.text)
if dw_domain_item_list.last_page < 2 then
	pb_down.visible = false
	pb_up.visible = false
else
	pb_down.visible = true
	pb_up.visible = true
	pb_up.enabled = false
	pb_down.enabled = true
end if
end subroutine

public function integer initialize (string ps_domain_id, string ps_title);

domain_id = ps_domain_id

st_title.text = ps_title

dw_domain_item_list.settransobject(sqlca)
dw_domain_item_list.retrieve(domain_id)

dw_domain_item_list.last_page = 0
dw_domain_item_list.set_page(1, st_page.text)
if dw_domain_item_list.last_page < 2 then
	pb_down.visible = false
	pb_up.visible = false
else
	pb_down.visible = true
	pb_up.visible = true
	pb_up.enabled = false
	pb_down.enabled = true
end if
return 1

end function

public subroutine set_selected_row (long pl_row);
if pl_row > 0 then
	if selected_row > 0 then dw_domain_item_list.setitem(selected_row, "selected_flag", 0)
	dw_domain_item_list.setitem(pl_row, "selected_flag", 1)
else
	dw_domain_item_list.clear_selected()
end if

selected_row = pl_row

if selected_row > 1 then
	cb_move_up.enabled = true
else
	cb_move_up.enabled = false
end if

	
if selected_row > 0 and selected_row < dw_domain_item_list.rowcount() then
	cb_move_down.enabled = true
else
	cb_move_down.enabled = false
end if

if selected_row > 0 then
	cb_delete.enabled = true
else
	cb_delete.enabled = false
end if

dw_domain_item_list.scrolltorow(selected_row)

dw_domain_item_list.recalc_page(st_page.text)
if dw_domain_item_list.last_page < 2 then
	pb_down.visible = false
	pb_up.visible = false
else
	pb_down.visible = true
	pb_up.visible = true
	pb_up.enabled = true
	pb_down.enabled = true
end if
end subroutine

public subroutine delete_item ();if selected_row > 0 and selected_row <= dw_domain_item_list.rowcount() then
	dw_domain_item_list.deleterow(selected_row)
end if

dw_domain_item_list.update()

set_selected_row(0)


end subroutine

public subroutine new_item ();long ll_row
integer li_domain_sequence
string ls_description
str_popup popup
str_popup_return popup_return
string ls_domain_item_description, ls_domain_item, ls_temp, ls_char, ls_find
integer i

popup.item = "Enter New " + st_title.text + ":"
openwithparm(w_pop_get_string, popup)
popup_return = message.powerobjectparm
ls_domain_item_description = popup_return.item
if isnull(ls_domain_item_description) or trim(ls_domain_item_description) = "" then return

ls_domain_item = upper(trim(ls_domain_item_description))
if len(ls_domain_item) > 24 then ls_domain_item = left(ls_domain_item, 24)
for i = 1 to len(ls_domain_item)
	ls_char = mid(ls_domain_item, i, 1)
	if ls_char < "A" or ls_char > "Z" then ls_domain_item = replace(ls_domain_item, i, 1, "_")
next

ls_find = "domain_id='" + ls_domain_item + "'"
ll_row = dw_domain_item_list.find(ls_find, 1, dw_domain_item_list.rowcount())
if ll_row > 0 then
	i = 0
	DO
		i += 1
		ls_temp = string(i)
		ls_domain_item = left(ls_domain_item, len(ls_domain_item) - len(ls_temp)) + ls_temp
		ls_find = "domain_id='" + ls_domain_item + "'"
		ll_row = dw_domain_item_list.find(ls_find, 1, dw_domain_item_list.rowcount())
	LOOP WHILE ll_row > 0
end if

ll_row = dw_domain_item_list.rowcount()
if ll_row > 0 then
	li_domain_sequence = dw_domain_item_list.object.domain_sequence[ll_row] + 10
else
	li_domain_sequence = 10
end if

ll_row = dw_domain_item_list.insertrow(0)
dw_domain_item_list.setitem(ll_row, "domain_id", domain_id)
dw_domain_item_list.setitem(ll_row, "domain_sequence", li_domain_sequence)
dw_domain_item_list.setitem(ll_row, "domain_item", ls_domain_item)
dw_domain_item_list.setitem(ll_row, "domain_item_description", ls_domain_item_description)

dw_domain_item_list.update()

set_selected_row(ll_row)

end subroutine

on u_domain_list_edit.create
this.st_page=create st_page
this.pb_down=create pb_down
this.pb_up=create pb_up
this.cb_delete=create cb_delete
this.cb_move_down=create cb_move_down
this.cb_move_up=create cb_move_up
this.cb_new_item=create cb_new_item
this.dw_domain_item_list=create dw_domain_item_list
this.st_title=create st_title
this.Control[]={this.st_page,&
this.pb_down,&
this.pb_up,&
this.cb_delete,&
this.cb_move_down,&
this.cb_move_up,&
this.cb_new_item,&
this.dw_domain_item_list,&
this.st_title}
end on

on u_domain_list_edit.destroy
destroy(this.st_page)
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.cb_delete)
destroy(this.cb_move_down)
destroy(this.cb_move_up)
destroy(this.cb_new_item)
destroy(this.dw_domain_item_list)
destroy(this.st_title)
end on

type st_page from statictext within u_domain_list_edit
integer x = 1339
integer y = 184
integer width = 270
integer height = 64
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

type pb_down from u_picture_button within u_domain_list_edit
boolean visible = false
integer x = 1317
integer y = 264
integer width = 137
integer height = 116
integer taborder = 10
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;integer li_page
integer li_last_page

li_page = dw_domain_item_list.current_page
li_last_page = dw_domain_item_list.last_page

dw_domain_item_list.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type pb_up from u_picture_button within u_domain_list_edit
boolean visible = false
integer x = 1504
integer y = 264
integer width = 137
integer height = 116
integer taborder = 60
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_domain_item_list.current_page

dw_domain_item_list.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true
end event

type cb_delete from commandbutton within u_domain_list_edit
event clicked pbm_bnclicked
integer x = 1710
integer y = 1148
integer width = 393
integer height = 108
integer taborder = 10
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

type cb_move_down from commandbutton within u_domain_list_edit
event clicked pbm_bnclicked
integer x = 1710
integer y = 896
integer width = 393
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Move Down"
end type

event clicked;move_down()

end event

type cb_move_up from commandbutton within u_domain_list_edit
event clicked pbm_bnclicked
integer x = 1710
integer y = 744
integer width = 393
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Move Up"
end type

event clicked;move_up()

end event

type cb_new_item from commandbutton within u_domain_list_edit
event clicked pbm_bnclicked
integer x = 1710
integer y = 460
integer width = 393
integer height = 108
integer taborder = 40
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

type dw_domain_item_list from u_dw_pick_list within u_domain_list_edit
integer x = 37
integer y = 200
integer width = 1243
integer height = 1504
integer taborder = 50
string dataobject = "dw_domain_item_list"
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

type st_title from statictext within u_domain_list_edit
integer width = 2400
integer height = 136
boolean bringtotop = true
integer textsize = -20
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

