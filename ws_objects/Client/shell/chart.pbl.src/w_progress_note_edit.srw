$PBExportHeader$w_progress_note_edit.srw
forward
global type w_progress_note_edit from w_window_base
end type
type pb_up from u_picture_button within w_progress_note_edit
end type
type st_page from statictext within w_progress_note_edit
end type
type pb_down from u_picture_button within w_progress_note_edit
end type
type p_risk_level from picture within w_progress_note_edit
end type
type st_risk_level from statictext within w_progress_note_edit
end type
type st_1 from statictext within w_progress_note_edit
end type
type st_title from statictext within w_progress_note_edit
end type
type st_specific_list from statictext within w_progress_note_edit
end type
type st_2 from statictext within w_progress_note_edit
end type
type st_generic_list from statictext within w_progress_note_edit
end type
type cb_add_to_top_20 from commandbutton within w_progress_note_edit
end type
type cb_which_list from commandbutton within w_progress_note_edit
end type
type mle_progress_note from multilineedit within w_progress_note_edit
end type
type dw_progress_top_20 from u_dw_pick_list within w_progress_note_edit
end type
type pb_cancel from u_picture_button within w_progress_note_edit
end type
type pb_close from u_picture_button within w_progress_note_edit
end type
end forward

global type w_progress_note_edit from w_window_base
windowtype windowtype = response!
pb_up pb_up
st_page st_page
pb_down pb_down
p_risk_level p_risk_level
st_risk_level st_risk_level
st_1 st_1
st_title st_title
st_specific_list st_specific_list
st_2 st_2
st_generic_list st_generic_list
cb_add_to_top_20 cb_add_to_top_20
cb_which_list cb_which_list
mle_progress_note mle_progress_note
dw_progress_top_20 dw_progress_top_20
pb_cancel pb_cancel
pb_close pb_close
end type
global w_progress_note_edit w_progress_note_edit

type variables
string top_20_generic_code
string top_20_specific_code
string top_20_user_id
string top_20_code

long risk_level

string original_progress

end variables

forward prototypes
public subroutine top_20_menu (long pl_row)
public subroutine move_up (long pl_row)
public subroutine move_down (long pl_row)
public subroutine sort ()
public function integer load_pick_list ()
public function integer set_risk_level (long pl_risk_level)
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

if pl_row < dw_progress_top_20.rowcount() then
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
		dw_progress_top_20.deleterow(pl_row)
		dw_progress_top_20.update()
		dw_progress_top_20.recalc_page(st_page.text)
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
	li_sort_sequence = dw_progress_top_20.object.sort_sequence[pl_row]
	li_sort_sequence_above = dw_progress_top_20.object.sort_sequence[pl_row - 1]
	dw_progress_top_20.setitem(pl_row, "sort_sequence", li_sort_sequence_above)
	dw_progress_top_20.setitem(pl_row - 1, "sort_sequence", li_sort_sequence)
	dw_progress_top_20.sort()
	dw_progress_top_20.update()
	dw_progress_top_20.clear_selected()
	dw_progress_top_20.set_page(dw_progress_top_20.current_page, st_page.text)
end if


end subroutine

public subroutine move_down (long pl_row);integer li_sort_sequence, li_sort_sequence_below

if pl_row > 0 and pl_row < dw_progress_top_20.rowcount() then
	li_sort_sequence = dw_progress_top_20.object.sort_sequence[pl_row]
	li_sort_sequence_below = dw_progress_top_20.object.sort_sequence[pl_row + 1]
	dw_progress_top_20.setitem(pl_row, "sort_sequence", li_sort_sequence_below)
	dw_progress_top_20.setitem(pl_row + 1, "sort_sequence", li_sort_sequence)
	dw_progress_top_20.sort()
	dw_progress_top_20.update()
	dw_progress_top_20.clear_selected()
	dw_progress_top_20.set_page(dw_progress_top_20.current_page, st_page.text)
end if


end subroutine

public subroutine sort ();long i
long ll_rowcount
long ll_row
string ls_code

dw_progress_top_20.setsort("description A")
dw_progress_top_20.sort()

ll_rowcount = dw_progress_top_20.rowcount()

// Update the sort_sequences
for i = 1 to ll_rowcount
	dw_progress_top_20.setitem(i, "sort_sequence", i)
next

// Update the database
dw_progress_top_20.update()

dw_progress_top_20.setsort("sort_sequence A")

dw_progress_top_20.clear_selected()
dw_progress_top_20.set_page(1, st_page.text)
if dw_progress_top_20.last_page <= 1 then
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

li_count = dw_progress_top_20.retrieve(top_20_user_id, top_20_code)
dw_progress_top_20.set_page(1, st_page.text)
if dw_progress_top_20.last_page <= 1 then
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

public function integer set_risk_level (long pl_risk_level);string ls_description
string ls_icon


risk_level = pl_risk_level
if isnull(risk_level) then
	p_risk_level.visible = false
	st_risk_level.text = "N/A"
	return 1
end if

SELECT description, icon
INTO :ls_description, :ls_icon
FROM em_Risk
WHERE risk_level = :risk_level;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then
	p_risk_level.visible = false
	st_risk_level.text = "N/A"
	return 0
end if

p_risk_level.visible = true
st_risk_level.text = ls_description
p_risk_level.picturename = ls_icon

return 1

end function

event open;call super::open;str_popup popup
str_popup_return popup_return
integer li_sts
long ll_len
string ls_description
long ll_risk_level


popup_return.item_count = 0

popup = message.powerobjectparm

Setnull(ll_risk_level)

dw_progress_top_20.settransobject(sqlca)
if popup.data_row_count = 4 Then
	top_20_specific_code = popup.items[1]
	top_20_generic_code = popup.items[2]
	original_progress = popup.items[3]
	ll_risk_level = long(popup.items[4])
Elseif popup.data_row_count = 3 Then
	top_20_specific_code = popup.items[1]
	top_20_generic_code = popup.items[2]
	original_progress = popup.items[3]
Else
	log.log(this, "w_progress_note_edit:open", "Invalid Parameters", 4)
	closewithreturn(this, popup_return)
	return
end if

set_risk_level(ll_risk_level)

If isnull(original_progress) Then
	mle_progress_note.text = ""
Else
	mle_progress_note.text = original_progress
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
top_20_code = top_20_specific_code
li_sts = load_pick_list()
if li_sts < 0 then
	log.log(this, "w_progress_note_edit:open", "Error loading pick list", 4)
	closewithreturn(this, popup_return)
	return
end if

// If we still don't have any entries then display the specific common list
if li_sts = 0 then
	top_20_user_id = current_user.common_list_id()
	li_sts = load_pick_list()
	if li_sts < 0 then
		log.log(this, "w_progress_note_edit:open", "Error loading pick list", 4)
		closewithreturn(this, popup_return)
		return
	end if
end if

// If we still don't have any entries then display the generic personal
if li_sts = 0 then
	top_20_user_id = current_user.user_id
	top_20_code = top_20_generic_code
	li_sts = load_pick_list()
	if li_sts < 0 then
		log.log(this, "w_progress_note_edit:open", "Error loading pick list", 4)
		closewithreturn(this, popup_return)
		return
	end if
end if

// If we still don't have any entries then display the generic common
if li_sts = 0 then
	top_20_user_id = current_user.common_list_id()
	li_sts = load_pick_list()
	if li_sts < 0 then
		log.log(this, "w_progress_note_edit:open", "Error loading pick list", 4)
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

if top_20_code = top_20_generic_code then
	st_generic_list.backcolor = color_object_selected
else
	st_specific_list.backcolor = color_object_selected
end if

dw_progress_top_20.object.compute_text.width = dw_progress_top_20.width - 230

mle_progress_note.setfocus()
ll_len = len(mle_progress_note.text)
mle_progress_note.selecttext(ll_len + 1, 0)

end event

on w_progress_note_edit.create
int iCurrent
call super::create
this.pb_up=create pb_up
this.st_page=create st_page
this.pb_down=create pb_down
this.p_risk_level=create p_risk_level
this.st_risk_level=create st_risk_level
this.st_1=create st_1
this.st_title=create st_title
this.st_specific_list=create st_specific_list
this.st_2=create st_2
this.st_generic_list=create st_generic_list
this.cb_add_to_top_20=create cb_add_to_top_20
this.cb_which_list=create cb_which_list
this.mle_progress_note=create mle_progress_note
this.dw_progress_top_20=create dw_progress_top_20
this.pb_cancel=create pb_cancel
this.pb_close=create pb_close
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_up
this.Control[iCurrent+2]=this.st_page
this.Control[iCurrent+3]=this.pb_down
this.Control[iCurrent+4]=this.p_risk_level
this.Control[iCurrent+5]=this.st_risk_level
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.st_title
this.Control[iCurrent+8]=this.st_specific_list
this.Control[iCurrent+9]=this.st_2
this.Control[iCurrent+10]=this.st_generic_list
this.Control[iCurrent+11]=this.cb_add_to_top_20
this.Control[iCurrent+12]=this.cb_which_list
this.Control[iCurrent+13]=this.mle_progress_note
this.Control[iCurrent+14]=this.dw_progress_top_20
this.Control[iCurrent+15]=this.pb_cancel
this.Control[iCurrent+16]=this.pb_close
end on

on w_progress_note_edit.destroy
call super::destroy
destroy(this.pb_up)
destroy(this.st_page)
destroy(this.pb_down)
destroy(this.p_risk_level)
destroy(this.st_risk_level)
destroy(this.st_1)
destroy(this.st_title)
destroy(this.st_specific_list)
destroy(this.st_2)
destroy(this.st_generic_list)
destroy(this.cb_add_to_top_20)
destroy(this.cb_which_list)
destroy(this.mle_progress_note)
destroy(this.dw_progress_top_20)
destroy(this.pb_cancel)
destroy(this.pb_close)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_progress_note_edit
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_progress_note_edit
end type

type pb_up from u_picture_button within w_progress_note_edit
integer x = 1463
integer y = 176
integer width = 137
integer height = 116
integer taborder = 10
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_progress_top_20.current_page

dw_progress_top_20.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type st_page from statictext within w_progress_note_edit
integer x = 1614
integer y = 176
integer width = 256
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

type pb_down from u_picture_button within w_progress_note_edit
integer x = 1463
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

li_page = dw_progress_top_20.current_page
li_last_page = dw_progress_top_20.last_page

dw_progress_top_20.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true


end event

type p_risk_level from picture within w_progress_note_edit
integer x = 2702
integer y = 504
integer width = 133
integer height = 112
boolean originalsize = true
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_risk_level from statictext within w_progress_note_edit
integer x = 2149
integer y = 504
integer width = 539
integer height = 112
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "N/A"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;long ll_risk_level
str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_em_risk_pick"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.add_blank_row = true
popup.blank_text = "N/A"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	setnull(ll_risk_level)
else
	ll_risk_level = long(popup_return.items[1])
end if

text = popup_return.descriptions[1]

set_risk_level(ll_risk_level)

end event

type st_1 from statictext within w_progress_note_edit
integer x = 1445
integer y = 528
integer width = 690
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Risk Level Of This Note:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_title from statictext within w_progress_note_edit
integer width = 2926
integer height = 144
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

type st_specific_list from statictext within w_progress_note_edit
integer x = 1883
integer y = 368
integer width = 910
integer height = 100
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Specific"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;top_20_code = top_20_specific_code
backcolor = color_object_selected
st_generic_list.backcolor = color_object

load_pick_list()

end event

type st_2 from statictext within w_progress_note_edit
integer x = 1883
integer y = 156
integer width = 910
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
string text = "Which List"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_generic_list from statictext within w_progress_note_edit
integer x = 1883
integer y = 240
integer width = 910
integer height = 100
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Generic"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;top_20_code = top_20_generic_code
backcolor = color_object_selected
st_specific_list.backcolor = color_object

load_pick_list()

end event

type cb_add_to_top_20 from commandbutton within w_progress_note_edit
integer x = 1458
integer y = 1444
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


ls_item_text = trim(mle_progress_note.selectedtext())
if isnull(ls_item_text) or ls_item_text = "" then
	ls_item_text = trim(mle_progress_note.text)
	if isnull(ls_item_text) or ls_item_text = "" then return
end if

ll_row = dw_progress_top_20.insertrow(0)
dw_progress_top_20.object.user_id[ll_row] = top_20_user_id
dw_progress_top_20.object.top_20_code[ll_row] = top_20_code
dw_progress_top_20.object.risk_level[ll_row] = risk_level
dw_progress_top_20.object.sort_sequence[ll_row] = ll_row

if len(ls_item_text) > 255 then
	dw_progress_top_20.object.item_text_long[ll_row] = ls_item_text
else
	dw_progress_top_20.object.item_text[ll_row] = ls_item_text
end if

tf_begin_transaction(this, "clicked")
dw_progress_top_20.update()
tf_commit()

dw_progress_top_20.recalc_page(st_page.text)


end event

type cb_which_list from commandbutton within w_progress_note_edit
integer x = 1463
integer y = 1600
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

type mle_progress_note from multilineedit within w_progress_note_edit
integer x = 1454
integer y = 656
integer width = 1385
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

type dw_progress_top_20 from u_dw_pick_list within w_progress_note_edit
integer x = 14
integer y = 164
integer width = 1422
integer height = 1536
integer taborder = 10
string dataobject = "dw_progress_top_20_display"
boolean vscrollbar = true
boolean border = false
boolean livescroll = false
end type

event selected;string ls_item_text
string ls_temp
string ls_sep
long ll_len
long ll_risk_level

if lastcolumnname = 'icon' then return


ls_item_text = object.compute_text[selected_row]
ls_temp = trim(mle_progress_note.text)

if ls_temp = "" then
	ls_sep = ""
elseif right(ls_temp, 1) = "," then
	ls_sep = " "
elseif right(ls_temp, 1) = "." then
	ls_sep = "~r~n"
else
	ls_sep = " "
end if

mle_progress_note.text += ls_sep + ls_item_text

object.selected_flag[selected_row] = 0

mle_progress_note.setfocus()
ll_len = len(mle_progress_note.text)
mle_progress_note.selecttext(ll_len + 1, 0)

ll_risk_level = object.risk_level[selected_row]
if ll_risk_level > risk_level or isnull(risk_level) then
	set_risk_level(ll_risk_level)
end if


end event

event computed_clicked;call super::computed_clicked;top_20_menu(clicked_row)
clear_selected()

end event

type pb_cancel from u_picture_button within w_progress_note_edit
integer x = 2167
integer y = 1492
integer taborder = 50
boolean originalsize = false
string picturename = "button11.bmp"
string disabledname = "button11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 0
closewithreturn(parent, popup_return)



end event

on mouse_move;f_cpr_set_msg("Cancel")
end on

type pb_close from u_picture_button within w_progress_note_edit
integer x = 2583
integer y = 1492
integer taborder = 70
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return
integer li_sts

if isnull(mle_progress_note.text) or trim(mle_progress_note.text) = "" then
	popup_return.item_count = 0
else
	popup_return.item_count = 2
	popup_return.items[1] = righttrim(mle_progress_note.text)
	popup_return.items[2] = string(risk_level)
end if

closewithreturn(parent, popup_return)



end event

