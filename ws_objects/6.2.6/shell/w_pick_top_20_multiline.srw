HA$PBExportHeader$w_pick_top_20_multiline.srw
forward
global type w_pick_top_20_multiline from w_window_base
end type
type cb_cancel from commandbutton within w_pick_top_20_multiline
end type
type cb_ok from commandbutton within w_pick_top_20_multiline
end type
type pb_up from u_picture_button within w_pick_top_20_multiline
end type
type st_page from statictext within w_pick_top_20_multiline
end type
type pb_down from u_picture_button within w_pick_top_20_multiline
end type
type st_title from statictext within w_pick_top_20_multiline
end type
type cb_add_to_top_20 from commandbutton within w_pick_top_20_multiline
end type
type cb_which_list from commandbutton within w_pick_top_20_multiline
end type
type mle_note_note from multilineedit within w_pick_top_20_multiline
end type
type dw_note_top_20 from u_dw_pick_list within w_pick_top_20_multiline
end type
end forward

global type w_pick_top_20_multiline from w_window_base
windowtype windowtype = response!
cb_cancel cb_cancel
cb_ok cb_ok
pb_up pb_up
st_page st_page
pb_down pb_down
st_title st_title
cb_add_to_top_20 cb_add_to_top_20
cb_which_list cb_which_list
mle_note_note mle_note_note
dw_note_top_20 dw_note_top_20
end type
global w_pick_top_20_multiline w_pick_top_20_multiline

type variables
string top_20_user_id
string top_20_code

string original_note

end variables

forward prototypes
public subroutine top_20_menu (long pl_row)
public subroutine move_up (long pl_row)
public subroutine move_down (long pl_row)
public subroutine sort ()
public function integer load_pick_list ()
end prototypes

public subroutine top_20_menu (long pl_row);str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons
string ls_user_id
integer li_update_flag
string ls_description
string ls_assessment_id
string ls_null
long ll_null
string ls_top_20_code
setnull(ls_null)
setnull(ll_null)

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Remove From Top-20 List"
	popup.button_titles[popup.button_count] = "Remove Top-20"
	buttons[popup.button_count] = "REMOVE"
end if

if pl_row > 1 then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonup.bmp"
	popup.button_helps[popup.button_count] = "Move item one space up"
	popup.button_titles[popup.button_count] = "Move Up"
	buttons[popup.button_count] = "UP"
end if

if pl_row < dw_note_top_20.rowcount() then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttondn.bmp"
	popup.button_helps[popup.button_count] = "Move item one space down"
	popup.button_titles[popup.button_count] = "Move Down"
	buttons[popup.button_count] = "DOWN"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button21.bmp"
	popup.button_helps[popup.button_count] = "Sort all items"
	popup.button_titles[popup.button_count] = "Sort"
	buttons[popup.button_count] = "SORTALL"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	button_pressed = message.doubleparm
	if button_pressed < 1 or button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	button_pressed = 1
else
	return
end if

CHOOSE CASE buttons[button_pressed]
	CASE "REMOVE"
		dw_note_top_20.deleterow(pl_row)
		dw_note_top_20.update()
		dw_note_top_20.recalc_page(st_page.text)
	CASE "UP"
		move_up(pl_row)
	CASE "DOWN"
		move_down(pl_row)
	CASE "SORTALL"
		sort()
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return


end subroutine

public subroutine move_up (long pl_row);integer li_sort_sequence, li_sort_sequence_above

if pl_row > 1 then
	li_sort_sequence = dw_note_top_20.object.sort_sequence[pl_row]
	li_sort_sequence_above = dw_note_top_20.object.sort_sequence[pl_row - 1]
	dw_note_top_20.setitem(pl_row, "sort_sequence", li_sort_sequence_above)
	dw_note_top_20.setitem(pl_row - 1, "sort_sequence", li_sort_sequence)
	dw_note_top_20.sort()
	dw_note_top_20.update()
	dw_note_top_20.clear_selected()
	dw_note_top_20.set_page(dw_note_top_20.current_page, st_page.text)
end if


end subroutine

public subroutine move_down (long pl_row);integer li_sort_sequence, li_sort_sequence_below

if pl_row > 0 and pl_row < dw_note_top_20.rowcount() then
	li_sort_sequence = dw_note_top_20.object.sort_sequence[pl_row]
	li_sort_sequence_below = dw_note_top_20.object.sort_sequence[pl_row + 1]
	dw_note_top_20.setitem(pl_row, "sort_sequence", li_sort_sequence_below)
	dw_note_top_20.setitem(pl_row + 1, "sort_sequence", li_sort_sequence)
	dw_note_top_20.sort()
	dw_note_top_20.update()
	dw_note_top_20.clear_selected()
	dw_note_top_20.set_page(dw_note_top_20.current_page, st_page.text)
end if


end subroutine

public subroutine sort ();long i
long ll_rowcount
long ll_row
string ls_code

dw_note_top_20.setsort("description A")
dw_note_top_20.sort()

ll_rowcount = dw_note_top_20.rowcount()

// Update the sort_sequences
for i = 1 to ll_rowcount
	dw_note_top_20.setitem(i, "sort_sequence", i)
next

// Update the database
dw_note_top_20.update()

dw_note_top_20.setsort("sort_sequence A")

dw_note_top_20.clear_selected()
dw_note_top_20.set_page(1, st_page.text)
if dw_note_top_20.last_page <= 1 then
	pb_down.visible = false
	pb_up.visible = false
	st_page.visible = false
else
	pb_down.visible = true
	pb_up.visible = true
	pb_up.enabled = false
	pb_down.enabled = true
	st_page.visible = true
end if

end subroutine

public function integer load_pick_list ();integer li_count

li_count = dw_note_top_20.retrieve(top_20_user_id, top_20_code)
dw_note_top_20.set_page(1, st_page.text)
if dw_note_top_20.last_page <= 1 then
	pb_down.visible = false
	pb_up.visible = false
	st_page.visible = false
else
	pb_down.visible = true
	pb_up.visible = true
	pb_up.enabled = false
	pb_down.enabled = true
	st_page.visible = true
end if

return li_count



end function

event open;call super::open;str_popup popup
str_popup_return popup_return
integer li_sts
long ll_len
string ls_description
long ll_risk_level


popup_return.item_count = 0

popup = message.powerobjectparm

dw_note_top_20.settransobject(sqlca)
if popup.data_row_count = 2 Then
	top_20_code = popup.items[1]
	original_note = popup.items[2]
Else
	log.log(this, "open", "Invalid Parameters", 4)
	closewithreturn(this, popup_return)
	return
end if

If isnull(original_note) Then
	mle_note_note.text = ""
Else
	mle_note_note.text = original_note
End If

st_title.text = popup.title

if len(st_title.text) > 42 then
	if len(st_title.text) > 60 then
		if len(st_title.text) > 70 then
			st_title.textsize = -10
		else
			st_title.textsize = -12
		end if
	else
		st_title.textsize = -14
	end if
else
	st_title.textsize = -18
end if

// First try displaying the specific personal list
top_20_user_id = current_user.user_id
li_sts = load_pick_list()
if li_sts < 0 then
	log.log(this, "open", "Error loading pick list", 4)
	closewithreturn(this, popup_return)
	return
end if

// If we still don't have any entries then display the specific common list
if li_sts = 0 then
	top_20_user_id = current_user.common_list_id()
	li_sts = load_pick_list()
	if li_sts < 0 then
		log.log(this, "open", "Error loading pick list", 4)
		closewithreturn(this, popup_return)
		return
	end if
end if

// Set the display according to which list had entries
if top_20_user_id = current_user.common_list_id() then
	cb_which_list.text = "Common"
else
	cb_which_list.text = "Personal"
end if

mle_note_note.setfocus()
ll_len = len(mle_note_note.text)
mle_note_note.selecttext(ll_len + 1, 0)

dw_note_top_20.object.item_text.width = dw_note_top_20.width - 160


end event

on w_pick_top_20_multiline.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.pb_up=create pb_up
this.st_page=create st_page
this.pb_down=create pb_down
this.st_title=create st_title
this.cb_add_to_top_20=create cb_add_to_top_20
this.cb_which_list=create cb_which_list
this.mle_note_note=create mle_note_note
this.dw_note_top_20=create dw_note_top_20
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.cb_ok
this.Control[iCurrent+3]=this.pb_up
this.Control[iCurrent+4]=this.st_page
this.Control[iCurrent+5]=this.pb_down
this.Control[iCurrent+6]=this.st_title
this.Control[iCurrent+7]=this.cb_add_to_top_20
this.Control[iCurrent+8]=this.cb_which_list
this.Control[iCurrent+9]=this.mle_note_note
this.Control[iCurrent+10]=this.dw_note_top_20
end on

on w_pick_top_20_multiline.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.pb_up)
destroy(this.st_page)
destroy(this.pb_down)
destroy(this.st_title)
destroy(this.cb_add_to_top_20)
destroy(this.cb_which_list)
destroy(this.mle_note_note)
destroy(this.dw_note_top_20)
end on

type cb_cancel from commandbutton within w_pick_top_20_multiline
integer x = 2057
integer y = 1584
integer width = 283
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 0
closewithreturn(parent, popup_return)



end event

type cb_ok from commandbutton within w_pick_top_20_multiline
integer x = 2441
integer y = 1584
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;str_popup_return popup_return
integer li_sts

if isnull(mle_note_note.text) or trim(mle_note_note.text) = "" then
	popup_return.item_count = 0
else
	popup_return.item_count = 1
	popup_return.items[1] = mle_note_note.text
end if

closewithreturn(parent, popup_return)



end event

type pb_up from u_picture_button within w_pick_top_20_multiline
integer x = 1390
integer y = 176
integer width = 137
integer height = 116
integer taborder = 10
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_note_top_20.current_page

dw_note_top_20.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type st_page from statictext within w_pick_top_20_multiline
integer x = 1541
integer y = 176
integer width = 302
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
boolean focusrectangle = false
end type

type pb_down from u_picture_button within w_pick_top_20_multiline
integer x = 1390
integer y = 312
integer width = 137
integer height = 116
integer taborder = 20
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_note_top_20.current_page
li_last_page = dw_note_top_20.last_page

dw_note_top_20.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true


end event

type st_title from statictext within w_pick_top_20_multiline
integer width = 2926
integer height = 164
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "none"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_add_to_top_20 from commandbutton within w_pick_top_20_multiline
integer x = 1422
integer y = 1340
integer width = 539
integer height = 108
integer taborder = 40
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "<< Add To List <<"
end type

event clicked;string ls_item_text
long ll_row


ls_item_text = trim(mle_note_note.selectedtext())
if isnull(ls_item_text) or ls_item_text = "" then
	ls_item_text = trim(mle_note_note.text)
	if isnull(ls_item_text) or ls_item_text = "" then return
end if

ll_row = dw_note_top_20.insertrow(0)
dw_note_top_20.object.user_id[ll_row] = top_20_user_id
dw_note_top_20.object.top_20_code[ll_row] = top_20_code
dw_note_top_20.object.item_text[ll_row] = ls_item_text
dw_note_top_20.object.sort_sequence[ll_row] = ll_row


dw_note_top_20.update()


dw_note_top_20.recalc_page(st_page.text)


end event

type cb_which_list from commandbutton within w_pick_top_20_multiline
integer x = 1417
integer y = 1588
integer width = 535
integer height = 108
integer taborder = 60
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Personal List"
end type

event clicked;integer	li_count

top_20_user_id = datalist.get_edit_list_id(top_20_user_id,top_20_code)
li_count = load_pick_list()

If top_20_user_id = current_user.user_id Then
	text = "Personal List"
Else
	text = "Common List"
End If

end event

type mle_note_note from multilineedit within w_pick_top_20_multiline
integer x = 1422
integer y = 552
integer width = 1422
integer height = 772
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type dw_note_top_20 from u_dw_pick_list within w_pick_top_20_multiline
integer x = 14
integer y = 164
integer width = 1358
integer height = 1532
integer taborder = 10
string dataobject = "dw_pick_top_20_multiline"
boolean border = false
boolean livescroll = false
end type

event selected(long selected_row);string ls_item_text
string ls_temp
string ls_sep
long ll_len
long ll_risk_level

if lasttype = 'compute' then return


ls_item_text = object.item_text[selected_row]
ls_temp = trim(mle_note_note.text)

if ls_temp = "" then
	ls_sep = ""
elseif right(ls_temp, 1) = "," then
	ls_sep = " "
elseif right(ls_temp, 1) = "." then
	ls_sep = "~r~n"
else
	ls_sep = " "
end if

mle_note_note.text += ls_sep + ls_item_text

object.selected_flag[selected_row] = 0

mle_note_note.setfocus()
ll_len = len(mle_note_note.text)
mle_note_note.selecttext(ll_len + 1, 0)



end event

event computed_clicked;call super::computed_clicked;top_20_menu(clicked_row)
clear_selected()

end event

