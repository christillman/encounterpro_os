HA$PBExportHeader$w_define_activity.srw
forward
global type w_define_activity from w_window_base
end type
type st_treatment_title from statictext within w_define_activity
end type
type uo_duration from u_duration_amount within w_define_activity
end type
type st_3 from statictext within w_define_activity
end type
type uo_frequency from u_administer_frequency within w_define_activity
end type
type st_5 from statictext within w_define_activity
end type
type st_title from statictext within w_define_activity
end type
type st_specific_list from statictext within w_define_activity
end type
type st_2 from statictext within w_define_activity
end type
type st_generic_list from statictext within w_define_activity
end type
type cb_add_to_top_20 from commandbutton within w_define_activity
end type
type cb_which_list from commandbutton within w_define_activity
end type
type cb_page from commandbutton within w_define_activity
end type
type dw_progress_top_20 from u_dw_pick_list within w_define_activity
end type
type mle_progress_note from multilineedit within w_define_activity
end type
type cb_cancel from commandbutton within w_define_activity
end type
type cb_finished from commandbutton within w_define_activity
end type
end forward

global type w_define_activity from w_window_base
windowtype windowtype = response!
st_treatment_title st_treatment_title
uo_duration uo_duration
st_3 st_3
uo_frequency uo_frequency
st_5 st_5
st_title st_title
st_specific_list st_specific_list
st_2 st_2
st_generic_list st_generic_list
cb_add_to_top_20 cb_add_to_top_20
cb_which_list cb_which_list
cb_page cb_page
dw_progress_top_20 dw_progress_top_20
mle_progress_note mle_progress_note
cb_cancel cb_cancel
cb_finished cb_finished
end type
global w_define_activity w_define_activity

type variables
string top_20_specific_code
string top_20_generic_code
string top_20_user_id
string top_20_code

string original_progress

u_component_treatment treatment

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
		dw_progress_top_20.recalc_page(cb_page.text)
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
	dw_progress_top_20.set_page(dw_progress_top_20.current_page, cb_page.text)
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
	dw_progress_top_20.set_page(dw_progress_top_20.current_page, cb_page.text)
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
dw_progress_top_20.set_page(1, cb_page.text)

end subroutine

public function integer load_pick_list ();integer li_count

li_count = dw_progress_top_20.retrieve(top_20_user_id, top_20_code)
dw_progress_top_20.set_page(1, cb_page.text)
if dw_progress_top_20.last_page <= 1 then
	cb_page.visible = false
else
	cb_page.visible = true
end if

return li_count



end function

event open;call super::open;str_popup popup
str_popup_return popup_return
integer li_sts
long ll_len
string ls_description
string ls_administer_frequency
real lr_duration_amount
string ls_duration_prn
string ls_duration_unit
string ls_suffix
string ls_duration

popup_return.item_count = 0

treatment = message.powerobjectparm
original_progress = ""
setnull(ls_administer_frequency)
setnull(lr_duration_amount)
setnull(ls_duration_unit)
setnull(ls_duration_prn)

top_20_generic_code = "DEF|" + treatment.treatment_type

if isnull(treatment.assessment) then
	st_title.text = "Define Activity"
	top_20_specific_code = "DEF|" + treatment.treatment_type + "|"
else
	st_title.text = "Define Activity For " + treatment.assessment.assessment
	top_20_specific_code = "DEF|" + treatment.treatment_type + "|" + treatment.assessment.assessment_id
end if

dw_progress_top_20.settransobject(sqlca)


mle_progress_note.text = original_progress

st_title.text = popup.title


// First try displaying the specific personal list
top_20_user_id = current_user.user_id
top_20_code = top_20_specific_code
li_sts = load_pick_list()
if li_sts < 0 then
	log.log(this, "open", "Error loading pick list", 4)
	closewithreturn(this, popup_return)
	return
end if

// If we still don't have any entries then display the specific common list
if li_sts = 0 then
	top_20_user_id = current_user.common_list_id() //"!DEFAULT"
	li_sts = load_pick_list()
	if li_sts < 0 then
		log.log(this, "open", "Error loading pick list", 4)
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
		log.log(this, "open", "Error loading pick list", 4)
		closewithreturn(this, popup_return)
		return
	end if
end if

// If we still don't have any entries then display the generic common
if li_sts = 0 then
	top_20_user_id = current_user.common_list_id() //"!DEFAULT"
	li_sts = load_pick_list()
	if li_sts < 0 then
		log.log(this, "open", "Error loading pick list", 4)
		closewithreturn(this, popup_return)
		return
	end if
end if

// Set the display according to which list had entries
if top_20_user_id = current_user.user_id then
	cb_which_list.text = "Personal"
else
	cb_which_list.text = "Common"
end if

if top_20_code = top_20_generic_code then
	st_generic_list.backcolor = color_object_selected
else
	st_specific_list.backcolor = color_object_selected
end if


uo_duration.set_amount(lr_duration_amount, ls_duration_unit, ls_duration_prn)
uo_frequency.set_frequency(ls_administer_frequency)

mle_progress_note.setfocus()
ll_len = len(mle_progress_note.text)
mle_progress_note.selecttext(ll_len + 1, 0)

dw_progress_top_20.object.item_text.width = dw_progress_top_20.width - 173

end event

on w_define_activity.create
int iCurrent
call super::create
this.st_treatment_title=create st_treatment_title
this.uo_duration=create uo_duration
this.st_3=create st_3
this.uo_frequency=create uo_frequency
this.st_5=create st_5
this.st_title=create st_title
this.st_specific_list=create st_specific_list
this.st_2=create st_2
this.st_generic_list=create st_generic_list
this.cb_add_to_top_20=create cb_add_to_top_20
this.cb_which_list=create cb_which_list
this.cb_page=create cb_page
this.dw_progress_top_20=create dw_progress_top_20
this.mle_progress_note=create mle_progress_note
this.cb_cancel=create cb_cancel
this.cb_finished=create cb_finished
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_treatment_title
this.Control[iCurrent+2]=this.uo_duration
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.uo_frequency
this.Control[iCurrent+5]=this.st_5
this.Control[iCurrent+6]=this.st_title
this.Control[iCurrent+7]=this.st_specific_list
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.st_generic_list
this.Control[iCurrent+10]=this.cb_add_to_top_20
this.Control[iCurrent+11]=this.cb_which_list
this.Control[iCurrent+12]=this.cb_page
this.Control[iCurrent+13]=this.dw_progress_top_20
this.Control[iCurrent+14]=this.mle_progress_note
this.Control[iCurrent+15]=this.cb_cancel
this.Control[iCurrent+16]=this.cb_finished
end on

on w_define_activity.destroy
call super::destroy
destroy(this.st_treatment_title)
destroy(this.uo_duration)
destroy(this.st_3)
destroy(this.uo_frequency)
destroy(this.st_5)
destroy(this.st_title)
destroy(this.st_specific_list)
destroy(this.st_2)
destroy(this.st_generic_list)
destroy(this.cb_add_to_top_20)
destroy(this.cb_which_list)
destroy(this.cb_page)
destroy(this.dw_progress_top_20)
destroy(this.mle_progress_note)
destroy(this.cb_cancel)
destroy(this.cb_finished)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_define_activity
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_define_activity
end type

type st_treatment_title from statictext within w_define_activity
integer x = 1371
integer y = 400
integer width = 576
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Treatment Description"
boolean focusrectangle = false
end type

type uo_duration from u_duration_amount within w_define_activity
integer x = 1733
integer y = 1292
integer width = 1079
integer height = 96
end type

type st_3 from statictext within w_define_activity
integer x = 1417
integer y = 1308
integer width = 297
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Duration:"
alignment alignment = right!
boolean focusrectangle = false
end type

type uo_frequency from u_administer_frequency within w_define_activity
integer x = 1733
integer y = 1124
integer width = 1079
integer height = 96
end type

type st_5 from statictext within w_define_activity
integer x = 1362
integer y = 1132
integer width = 352
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Frequency:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_title from statictext within w_define_activity
integer width = 2926
integer height = 116
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

type st_specific_list from statictext within w_define_activity
integer x = 2382
integer y = 232
integer width = 425
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

type st_2 from statictext within w_define_activity
integer x = 2098
integer y = 132
integer width = 480
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

type st_generic_list from statictext within w_define_activity
integer x = 1915
integer y = 232
integer width = 425
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

type cb_add_to_top_20 from commandbutton within w_define_activity
integer x = 1371
integer y = 924
integer width = 439
integer height = 104
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
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
dw_progress_top_20.object.item_text[ll_row] = ls_item_text
dw_progress_top_20.object.sort_sequence[ll_row] = ll_row

dw_progress_top_20.update()


end event

type cb_which_list from commandbutton within w_define_activity
integer x = 1362
integer y = 1588
integer width = 480
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

type cb_page from commandbutton within w_define_activity
integer x = 1367
integer y = 140
integer width = 389
integer height = 108
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Page 1 of 3"
end type

event clicked;dw_progress_top_20.set_page(dw_progress_top_20.current_page + 1, text)

end event

type dw_progress_top_20 from u_dw_pick_list within w_define_activity
integer y = 148
integer width = 1339
integer height = 1548
integer taborder = 10
string dataobject = "dw_top_20_list_with_icon"
boolean border = false
boolean livescroll = false
end type

event selected;call super::selected;string ls_item_text
string ls_temp
string ls_sep
long ll_len

if lasttype = 'compute' then
	top_20_menu(selected_row)
	clear_selected()
	return
end if


ls_item_text = object.item_text[lastrow]
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

object.selected_flag[lastrow] = 0

mle_progress_note.setfocus()
ll_len = len(mle_progress_note.text)
mle_progress_note.selecttext(ll_len + 1, 0)

end event

type mle_progress_note from multilineedit within w_define_activity
integer x = 1371
integer y = 460
integer width = 1422
integer height = 444
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autovscroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_cancel from commandbutton within w_define_activity
integer x = 1915
integer y = 1588
integer width = 357
integer height = 108
integer taborder = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
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

type cb_finished from commandbutton within w_define_activity
integer x = 2464
integer y = 1588
integer width = 357
integer height = 108
integer taborder = 110
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
end type

event clicked;str_popup_return popup_return
integer li_sts
long ll_null
integer li_null
u_component_treatment luo_treatment
string ls_description
string ls_instructions
string ls_duration

setnull(ll_null)
setnull(li_null)

ls_description = trim(mle_progress_note.text)

if isnull(ls_description) or ls_description = "" then
	openwithparm(w_pop_message, "You must provide a treatment description")
	return
end if

// Now construct the description with the frequency and duration added
if not isnull(uo_frequency.administer_frequency) then
	ls_description += " " + uo_frequency.administer_frequency
end if

ls_duration = ""
if isnull(uo_duration.prn) then
	if not isnull(uo_duration.amount) and not isnull(uo_duration.unit) then
		ls_duration = " x " + f_pretty_amount_unit(uo_duration.amount, uo_duration.unit)
	end if
else
	ls_duration = " PRN " + string(uo_duration.prn)
end if

ls_description += ls_duration

treatment.treatment_count = 1
treatment.treatment_definition[1].attribute_count = 5
treatment.treatment_definition[1].item_description = ls_description
treatment.treatment_definition[1].treatment_type = treatment.treatment_type
treatment.treatment_definition[1].attribute[1] = "duration_amount"
treatment.treatment_definition[1].value[1] = String(uo_duration.amount)
treatment.treatment_definition[1].attribute[2] = "duration_unit"
treatment.treatment_definition[1].value[2] = uo_duration.unit
treatment.treatment_definition[1].attribute[3] = "duration_prn"
treatment.treatment_definition[1].value[3] = uo_duration.prn
treatment.treatment_definition[1].attribute[4] = "administer_frequency"
treatment.treatment_definition[1].value[4] = uo_frequency.administer_frequency
treatment.treatment_definition[1].attribute[5] = "treatment_description"
treatment.treatment_definition[1].value[5] = ls_description


popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)


end event

