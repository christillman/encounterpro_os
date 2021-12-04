$PBExportHeader$w_age_range_selection.srw
forward
global type w_age_range_selection from w_window_base
end type
type dw_category from u_dw_pick_list within w_age_range_selection
end type
type dw_age_range from u_dw_pick_list within w_age_range_selection
end type
type cb_ok from commandbutton within w_age_range_selection
end type
type cb_cancel from commandbutton within w_age_range_selection
end type
type st_3 from statictext within w_age_range_selection
end type
type cb_new_age_range from commandbutton within w_age_range_selection
end type
type cb_new_category from commandbutton within w_age_range_selection
end type
type st_overlap_asterisk from statictext within w_age_range_selection
end type
type st_overlap_text from statictext within w_age_range_selection
end type
type cbx_show_disabled_items from checkbox within w_age_range_selection
end type
end forward

global type w_age_range_selection from w_window_base
integer width = 2898
integer height = 1808
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
dw_category dw_category
dw_age_range dw_age_range
cb_ok cb_ok
cb_cancel cb_cancel
st_3 st_3
cb_new_age_range cb_new_age_range
cb_new_category cb_new_category
st_overlap_asterisk st_overlap_asterisk
st_overlap_text st_overlap_text
cbx_show_disabled_items cbx_show_disabled_items
end type
global w_age_range_selection w_age_range_selection

type variables
string age_range_category
boolean allow_editing

end variables

forward prototypes
public function integer refresh ()
public subroutine age_range_category_menu (long pl_row)
public subroutine age_range_menu (long pl_row)
public subroutine sort_age_ranges ()
public subroutine sort_age_range_categories ()
public subroutine move_age_range_category (long pl_row)
public subroutine move_age_range (long pl_row)
end prototypes

public function integer refresh ();long ll_rowcount
long ll_row
long ll_selected_age_range_id
long ll_lastrowonpage
string ls_filter

ll_row = dw_age_range.get_selected_row()
if ll_row > 0 then
	ll_selected_age_range_id = dw_age_range.object.age_range_id[ll_row]
else
	setnull(ll_selected_age_range_id)
end if

if cbx_show_disabled_items.checked then
	ls_filter = ""
else
	ls_filter = "upper(status)='OK'"
end if

dw_category.setredraw(false)
dw_age_range.setredraw(false)

dw_category.setfilter(ls_filter)
ll_rowcount = dw_category.retrieve()
if not tf_check() then return -1
if ll_rowcount <= 0 then return -1

If Len(age_range_category) > 0 Then
	ll_row = dw_category.find("age_range_category = '"+age_range_category+"'",1,ll_rowcount)
	If ll_row <= 0 Then ll_row = 1
else
	ll_row = 1
end if

dw_category.object.selected_flag[ll_row] = 1
age_range_category = dw_category.object.age_range_category[ll_row]

ll_lastrowonpage = long(dw_category.object.datawindow.lastrowonpage)
if ll_row > ll_lastrowonpage then
	dw_category.scroll_to_row(ll_row)
end if

dw_age_range.setfilter(ls_filter)
ll_rowcount = dw_age_range.retrieve(age_range_category)

if ll_selected_age_range_id > 0 then
	ll_row = dw_age_range.find("age_range_id = "+ string(ll_selected_age_range_id),1,ll_rowcount)
	If ll_row > 0 Then
		dw_age_range.object.selected_flag[ll_row] = 1
	
		ll_lastrowonpage = long(dw_category.object.datawindow.lastrowonpage)
		if ll_row > ll_lastrowonpage then
			dw_category.scroll_to_row(ll_row)
		end if
	end if
end if
	
dw_category.setredraw(true)
dw_age_range.setredraw(true)

return 1

end function

public subroutine age_range_category_menu (long pl_row);String		lsa_buttons[]
String 		ls_drug_id
String 		ls_description,ls_null
String		ls_top_20_code
Integer		li_sts, li_service_count
Long			ll_null
string ls_property
string ls_literal
long ll_button_pressed
str_document_element_context lstr_document_element_context
window 				lw_pop_buttons
str_popup 			popup
str_popup 			popup2
str_popup_return 	popup_return
string ls_status
str_users lstr_users
str_pick_users lstr_pick_users
integer li_count
long i, j
w_window_base lw_window
string ls_group_name
string ls_room_name
long ll_group_id
string ls_age_range_category
long ll_owner_id

Setnull(ls_null)
Setnull(ll_null)

if isnull(pl_row) or pl_row <= 0 then return

ls_age_range_category = dw_category.object.age_range_category[pl_row]
ll_owner_id = dw_category.object.owner_id[pl_row]
ls_status = upper(string(dw_category.object.status[pl_row]))

if allow_editing then
	if ls_status = "OK" then
		popup.button_count = popup.button_count + 1
		popup.button_icons[popup.button_count] = "b_push30.bmp"
		popup.button_helps[popup.button_count] = "Disable Age Range Category"
		popup.button_titles[popup.button_count] = "Disable Category"
		lsa_buttons[popup.button_count] = "DISABLE"
	else
		popup.button_count = popup.button_count + 1
		popup.button_icons[popup.button_count] = "button30.bmp"
		popup.button_helps[popup.button_count] = "Enable Age Range Category"
		popup.button_titles[popup.button_count] = "Enable Category"
		lsa_buttons[popup.button_count] = "ENABLE"
	end if
end if

if allow_editing then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonmove.bmp"
	popup.button_helps[popup.button_count] = "Move record up or down"
	popup.button_titles[popup.button_count] = "Move"
	lsa_buttons[popup.button_count] = "MOVE"
end if

if allow_editing then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonx3.bmp"
	popup.button_helps[popup.button_count] = "Sort Age Range Categories Aphabetically"
	popup.button_titles[popup.button_count] = "Sort"
	lsa_buttons[popup.button_count] = "SORT"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	lsa_buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	ll_button_pressed = message.doubleparm
	if ll_button_pressed < 1 or ll_button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	ll_button_pressed = 1
else
	return
end if

CHOOSE CASE lsa_buttons[ll_button_pressed]
	CASE "DISABLE"
		UPDATE c_Age_Range_Category
		SET status = 'NA'
		WHERE age_range_category = :ls_age_range_category
		AND owner_id = :ll_owner_id;
		if not tf_check() then return
	CASE "ENABLE"
		UPDATE c_Age_Range_Category
		SET status = 'OK'
		WHERE age_range_category = :ls_age_range_category
		AND owner_id = :ll_owner_id;
		if not tf_check() then return
	CASE "MOVE"
		move_age_range_category(pl_row)
	CASE "SORT"
		sort_age_range_categories()
	CASE ELSE
		return
END CHOOSE

refresh()

end subroutine

public subroutine age_range_menu (long pl_row);String		lsa_buttons[]
String 		ls_drug_id
String 		ls_description,ls_null
String		ls_top_20_code
Integer		li_sts, li_service_count
Long			ll_null
string ls_property
string ls_literal
long ll_button_pressed
str_document_element_context lstr_document_element_context
window 				lw_pop_buttons
str_popup 			popup
str_popup 			popup2
str_popup_return 	popup_return
string ls_status
str_users lstr_users
str_pick_users lstr_pick_users
integer li_count
long i, j
w_window_base lw_window
string ls_group_name
string ls_room_name
long ll_age_range_id

Setnull(ls_null)
Setnull(ll_null)

if isnull(pl_row) or pl_row <= 0 then return

ll_age_range_id = dw_age_range.object.age_range_id[pl_row]
ls_status = upper(string(dw_age_range.object.status[pl_row]))

if allow_editing then
	if ls_status = "OK" then
		popup.button_count = popup.button_count + 1
		popup.button_icons[popup.button_count] = "b_push14.bmp"
		popup.button_helps[popup.button_count] = "Disable Age Range"
		popup.button_titles[popup.button_count] = "Disable Age Range"
		lsa_buttons[popup.button_count] = "DISABLE"
	else
		popup.button_count = popup.button_count + 1
		popup.button_icons[popup.button_count] = "button14.bmp"
		popup.button_helps[popup.button_count] = "Enable Age Range"
		popup.button_titles[popup.button_count] = "Enable Age Range"
		lsa_buttons[popup.button_count] = "ENABLE"
	end if
end if

if allow_editing then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonmove.bmp"
	popup.button_helps[popup.button_count] = "Move record up or down"
	popup.button_titles[popup.button_count] = "Move"
	lsa_buttons[popup.button_count] = "MOVE"
end if

if allow_editing then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonx3.bmp"
	popup.button_helps[popup.button_count] = "Sort Age Ranges by From Age"
	popup.button_titles[popup.button_count] = "Sort"
	lsa_buttons[popup.button_count] = "SORT"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	lsa_buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	ll_button_pressed = message.doubleparm
	if ll_button_pressed < 1 or ll_button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	ll_button_pressed = 1
else
	return
end if

CHOOSE CASE lsa_buttons[ll_button_pressed]
	CASE "DISABLE"
		UPDATE c_Age_Range
		SET status = 'NA'
		WHERE age_range_id = :ll_age_range_id;
		if not tf_check() then return
	CASE "ENABLE"
		UPDATE c_Age_Range
		SET status = 'OK'
		WHERE age_range_id = :ll_age_range_id;
		if not tf_check() then return
	CASE "MOVE"
		move_age_range(pl_row)
	CASE "SORT"
		sort_age_ranges()
	CASE ELSE
		return
END CHOOSE

refresh()

end subroutine

public subroutine sort_age_ranges ();integer li_sts
integer i
long ll_sort_sequence

dw_age_range.setredraw(false)

dw_age_range.clear_selected()

dw_age_range.setsort("from_age_days a")
dw_age_range.sort()

for i = 1 to dw_age_range.rowcount()
	dw_age_range.object.sort_sequence[i] = i
next

li_sts = dw_age_range.update()

dw_age_range.setsort("sort_sequence a, from_age_days a")

dw_age_range.setredraw(true)

return

end subroutine

public subroutine sort_age_range_categories ();integer li_sts
integer i
long ll_sort_sequence

dw_category.setredraw(false)

dw_category.clear_selected()

dw_category.setsort("description a")
dw_category.sort()

for i = 1 to dw_category.rowcount()
	dw_category.object.sort_sequence[i] = i
next

li_sts = dw_category.update()

dw_category.setsort("sort_sequence a, description a")

dw_category.setredraw(true)

return

end subroutine

public subroutine move_age_range_category (long pl_row);str_popup popup
integer li_sts
long ll_row

if pl_row <= 0 then return

ll_row = dw_category.get_selected_row()
if ll_row <> pl_row then
	dw_category.clear_selected()
	dw_category.object.selected_flag[pl_row] = 1
end if

popup.objectparm = dw_category

Openwithparm(w_pick_list_sort, popup)

li_sts = dw_category.update()


return 

end subroutine

public subroutine move_age_range (long pl_row);str_popup popup
integer li_sts
long ll_row

if pl_row <= 0 then return

ll_row = dw_age_range.get_selected_row()
if ll_row <> pl_row then
	dw_age_range.clear_selected()
	dw_age_range.object.selected_flag[pl_row] = 1
end if

popup.objectparm = dw_age_range

Openwithparm(w_pick_list_sort, popup)

li_sts = dw_age_range.update()


return 

end subroutine

on w_age_range_selection.create
int iCurrent
call super::create
this.dw_category=create dw_category
this.dw_age_range=create dw_age_range
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.st_3=create st_3
this.cb_new_age_range=create cb_new_age_range
this.cb_new_category=create cb_new_category
this.st_overlap_asterisk=create st_overlap_asterisk
this.st_overlap_text=create st_overlap_text
this.cbx_show_disabled_items=create cbx_show_disabled_items
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_category
this.Control[iCurrent+2]=this.dw_age_range
this.Control[iCurrent+3]=this.cb_ok
this.Control[iCurrent+4]=this.cb_cancel
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.cb_new_age_range
this.Control[iCurrent+7]=this.cb_new_category
this.Control[iCurrent+8]=this.st_overlap_asterisk
this.Control[iCurrent+9]=this.st_overlap_text
this.Control[iCurrent+10]=this.cbx_show_disabled_items
end on

on w_age_range_selection.destroy
call super::destroy
destroy(this.dw_category)
destroy(this.dw_age_range)
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.st_3)
destroy(this.cb_new_age_range)
destroy(this.cb_new_category)
destroy(this.st_overlap_asterisk)
destroy(this.st_overlap_text)
destroy(this.cbx_show_disabled_items)
end on

event open;call super::open;integer li_sts

str_popup_return popup_return

if not isnull(current_patient) then title = current_patient.id_line()

age_range_category = Message.Stringparm

dw_category.width = 1170
dw_category.x = cb_new_category.x + ((cb_new_category.width - dw_category.width) / 2)

dw_age_range.width = 1399
dw_age_range.x = cb_new_age_range.x + ((cb_new_age_range.width - dw_age_range.width) / 2)

st_overlap_asterisk.width = 59
st_overlap_asterisk.height = 48
st_overlap_asterisk.x = cb_new_category.x + cb_new_category.width + 75
st_overlap_asterisk.y = cb_new_category.y + ((cb_new_category.height - 60) / 2)

st_overlap_text.width = 741
st_overlap_text.height = 64
st_overlap_text.x = st_overlap_asterisk.x + 60
st_overlap_text.y = st_overlap_asterisk.y - 8

cbx_show_disabled_items.width = 809
cbx_show_disabled_items.height = 80
cbx_show_disabled_items.x = st_overlap_asterisk.x
cbx_show_disabled_items.y = st_overlap_asterisk.y + 100

allow_editing = user_list.is_user_privileged(current_scribe.user_id, "Configuration Mode")

cbx_show_disabled_items.checked = false
if allow_editing then
	cbx_show_disabled_items.visible = true
else
	cbx_show_disabled_items.visible = false
end if

dw_category.Settransobject(SQLCA)
dw_age_range.Settransobject(SQLCA)

li_sts = refresh()
if li_sts < 0 then
	popup_return.item_count = 1
	popup_return.items[1] = "ERROR"
	Closewithreturn(this,popup_return)
	return
End If


end event

type pb_epro_help from w_window_base`pb_epro_help within w_age_range_selection
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_age_range_selection
end type

type dw_category from u_dw_pick_list within w_age_range_selection
integer x = 114
integer y = 160
integer width = 1170
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_age_range_category"
boolean vscrollbar = true
boolean border = false
end type

event selected;long ll_rowcount

age_range_category = dw_category.object.age_range_category[selected_row]

ll_rowcount = dw_age_range.retrieve(age_range_category)


end event

event computed_clicked;call super::computed_clicked;
if clicked_row > 0 then age_range_category_menu(clicked_row)


end event

type dw_age_range from u_dw_pick_list within w_age_range_selection
integer x = 1394
integer y = 160
integer width = 1399
integer taborder = 21
boolean bringtotop = true
string dataobject = "dw_age_range_selection"
boolean vscrollbar = true
boolean border = false
end type

event computed_clicked;call super::computed_clicked;
if clicked_row > 0 then age_range_menu(clicked_row)


end event

type cb_ok from commandbutton within w_age_range_selection
integer x = 2418
integer y = 1580
integer width = 402
integer height = 112
integer taborder = 11
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;Long					ll_row
str_popup_return  popup_return


ll_row = dw_age_range.get_selected_row()
if ll_row <= 0 then return

popup_return.item_count = 6
popup_return.items[1] = String(dw_age_range.object.age_range_id[ll_row])
popup_return.items[2] = String(dw_age_range.object.age_from[ll_row])
popup_return.items[3] = dw_age_range.object.age_from_unit[ll_row]
popup_return.items[4] = String(dw_age_range.object.age_to[ll_row])
popup_return.items[5] = dw_age_range.object.age_to_unit[ll_row]
popup_return.descriptions[1] = dw_age_range.object.description[ll_row]

Closewithreturn(parent,popup_return)


end event

type cb_cancel from commandbutton within w_age_range_selection
integer x = 82
integer y = 1580
integer width = 402
integer height = 112
integer taborder = 21
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;str_popup_return   popup_return

popup_return.item_count = 0
Closewithreturn(parent,popup_return)
end event

type st_3 from statictext within w_age_range_selection
integer width = 2921
integer height = 120
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Select Age Range"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_new_age_range from commandbutton within w_age_range_selection
integer x = 1851
integer y = 1396
integer width = 480
integer height = 112
integer taborder = 31
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Age Range"
end type

event clicked;Long			ll_row
long ll_sort_sequence
str_popup	popup
long ll_new_age_range_id
long ll_rowcount
long ll_lastrowonpage
string ls_overlap_flag
w_window_base lw_window


SELECT overlap_flag
INTO :ls_overlap_flag
FROM dbo.c_Age_Range_Category
WHERE age_range_category = :age_range_category;
if not tf_check() then return -1

SELECT max(sort_sequence)
INTO :ll_sort_sequence
FROM dbo.c_Age_Range;
if not tf_check() then return -1

popup.data_row_count = 3
popup.items[1] = age_range_category
popup.items[2] = string(ll_sort_sequence)
popup.items[3] = ls_overlap_flag
Openwithparm(lw_window, popup, "w_new_age_range")
ll_new_age_range_id = message.doubleparm

refresh()

ll_rowcount = dw_age_range.rowcount()

if ll_new_age_range_id > 0 then
	ll_row = dw_age_range.find("age_range_id = "+ string(ll_new_age_range_id),1,ll_rowcount)
	If ll_row > 0 Then
		dw_age_range.object.selected_flag[ll_row] = 1
	
		ll_lastrowonpage = long(dw_age_range.object.datawindow.lastrowonpage)
		if ll_row > ll_lastrowonpage then
			dw_age_range.scroll_to_row(ll_row)
		end if
	end if
end if


end event

type cb_new_category from commandbutton within w_age_range_selection
integer x = 389
integer y = 1396
integer width = 425
integer height = 112
integer taborder = 21
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Category"
end type

event clicked;string ls_age_range_category

ls_age_range_category = f_new_age_range_category()
if isnull(ls_age_range_category) then return

age_range_category = ls_age_range_category

refresh()


end event

type st_overlap_asterisk from statictext within w_age_range_selection
integer x = 882
integer y = 1432
integer width = 59
integer height = 48
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "*"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_overlap_text from statictext within w_age_range_selection
integer x = 942
integer y = 1424
integer width = 741
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "= Age Ranges May Overlap"
alignment alignment = center!
boolean focusrectangle = false
end type

type cbx_show_disabled_items from checkbox within w_age_range_selection
integer x = 891
integer y = 1536
integer width = 809
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Show Disabled Items"
end type

event clicked;refresh()

end event

