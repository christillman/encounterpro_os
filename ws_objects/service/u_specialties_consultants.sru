HA$PBExportHeader$u_specialties_consultants.sru
forward
global type u_specialties_consultants from userobject
end type
type st_left_page from statictext within u_specialties_consultants
end type
type st_right_page from statictext within u_specialties_consultants
end type
type pb_right_down from u_picture_button within u_specialties_consultants
end type
type pb_right_up from u_picture_button within u_specialties_consultants
end type
type pb_left_down from u_picture_button within u_specialties_consultants
end type
type pb_left_up from u_picture_button within u_specialties_consultants
end type
type cb_new_consultant from commandbutton within u_specialties_consultants
end type
type cb_delete_specialty from commandbutton within u_specialties_consultants
end type
type cb_new_specialty from commandbutton within u_specialties_consultants
end type
type st_2 from statictext within u_specialties_consultants
end type
type dw_consultant_list from u_dw_pick_list within u_specialties_consultants
end type
type dw_specialty_list from u_dw_pick_list within u_specialties_consultants
end type
type st_1 from statictext within u_specialties_consultants
end type
end forward

global type u_specialties_consultants from userobject
integer width = 2400
integer height = 1748
long backcolor = 33538240
long tabbackcolor = 16777215
long picturemaskcolor = 536870912
st_left_page st_left_page
st_right_page st_right_page
pb_right_down pb_right_down
pb_right_up pb_right_up
pb_left_down pb_left_down
pb_left_up pb_left_up
cb_new_consultant cb_new_consultant
cb_delete_specialty cb_delete_specialty
cb_new_specialty cb_new_specialty
st_2 st_2
dw_consultant_list dw_consultant_list
dw_specialty_list dw_specialty_list
st_1 st_1
end type
global u_specialties_consultants u_specialties_consultants

type variables
string specialty_id,specialty_description
string consultant_id

end variables

forward prototypes
public subroutine move_up ()
public subroutine move_down ()
public function integer initialize ()
public function string get_consultant_id (string ps_description)
public subroutine edit_consultant ()
end prototypes

public subroutine move_up ();integer li_sort_sequence, li_sort_sequence_above
long ll_row

ll_row = dw_consultant_list.get_selected_row()

if ll_row > 1 then
	li_sort_sequence = dw_consultant_list.object.sort_sequence[ll_row]
	li_sort_sequence_above = dw_consultant_list.object.sort_sequence[ll_row - 1]
	dw_consultant_list.setitem(ll_row, "sort_sequence", li_sort_sequence_above)
	dw_consultant_list.setitem(ll_row - 1, "sort_sequence", li_sort_sequence)
	dw_consultant_list.update()
	dw_consultant_list.sort()
	dw_consultant_list.postevent("consultant_selected")
end if

end subroutine

public subroutine move_down ();integer li_sort_sequence, li_sort_sequence_below
long ll_row

ll_row = dw_consultant_list.get_selected_row()

if ll_row > 0 and ll_row < dw_consultant_list.rowcount() then
	li_sort_sequence = dw_consultant_list.object.sort_sequence[ll_row]
	li_sort_sequence_below = dw_consultant_list.object.sort_sequence[ll_row + 1]
	dw_consultant_list.setitem(ll_row, "sort_sequence", li_sort_sequence_below)
	dw_consultant_list.setitem(ll_row + 1, "sort_sequence", li_sort_sequence)
	dw_consultant_list.update()
	dw_consultant_list.sort()
	dw_consultant_list.postevent("consultant_selected")
end if


end subroutine

public function integer initialize ();dw_specialty_list.settransobject(sqlca)
dw_specialty_list.retrieve()

dw_consultant_list.settransobject(sqlca)
dw_consultant_list.retrieve()

if dw_specialty_list.rowcount() > 0 then
	dw_specialty_list.setitem(1, "selected_flag", 1)
	dw_specialty_list.postevent("specialty_selected")
else
	dw_specialty_list.postevent("specialty_not_selected")
end if
dw_specialty_list.last_page = 0
// up & dn for specialties
dw_specialty_list.set_page(1, st_left_page.text)
If dw_specialty_list.last_page < 2 then
	pb_left_down.visible = false
	pb_left_up.visible = false
Else
	pb_left_down.visible = true
	pb_left_up.visible = true
	pb_left_up.enabled = false
	pb_left_down.enabled = true
End if
// up & dn for consultants
dw_consultant_list.last_page = 0
dw_consultant_list.set_page(1, st_right_page.text)
If dw_consultant_list.last_page < 2 then
	pb_right_down.visible = false
	pb_right_up.visible = false
Else
	pb_right_down.visible = true
	pb_right_up.visible = true
	pb_right_up.enabled = false
	pb_right_down.enabled = true
End If
Return 1

end function

public function string get_consultant_id (string ps_description);String ls_consultant_id,ls_description
String ls_find,ls_temp,ls_char
Integer i
Long   ll_row
long ll_count
string ls_null

setnull(ls_null)

ls_description = ps_description

ls_consultant_id = upper(trim(ls_description))
if len(ls_consultant_id) > 24 then ls_consultant_id = left(ls_consultant_id, 24)
for i = 1 to len(ls_consultant_id)
	ls_char = mid(ls_consultant_id, i, 1)
	if ls_char < "A" or ls_char > "Z" then ls_consultant_id = replace(ls_consultant_id, i, 1, "_")
next

for i = 1 to 100
	SELECT count(*)
	INTO :ll_count
	FROM c_Consultant
	WHERE consultant_id = :ls_consultant_id;
	if not tf_check() then return ls_null
	if ll_count = 0 then return ls_consultant_id
	
	ls_temp = string(i)
	ls_consultant_id = left(ls_consultant_id, len(ls_consultant_id) - len(ls_temp)) + ls_temp
next

Return ls_null


end function

public subroutine edit_consultant ();Long 			ll_row,ll_rowcount
Integer 		li_sort_sequence,i
String		ls_temp, ls_char, ls_find
String		ls_consultant_id
long ll_owner_id

str_c_consultant lstr_consultant

Openwithparm(w_edit_consultant,consultant_id)

lstr_consultant = message.powerobjectparm
If isnull(lstr_consultant.consultant_id) then return

ll_rowcount = dw_consultant_list.rowcount()
If isnull(consultant_id) Then // new
	ls_consultant_id = get_consultant_id(lstr_consultant.description)
	if ll_rowcount > 0 then
		li_sort_sequence = dw_consultant_list.object.sort_sequence[ll_rowcount] + 10
	else
		li_sort_sequence = 10
	end if

	ll_row = dw_consultant_list.insertrow(0)
	dw_consultant_list.object.sort_sequence[ll_row] = li_sort_sequence
Else
	ls_consultant_id = consultant_id
	ls_find = "specialty_id='"+specialty_id+"' And consultant_id='"+ls_consultant_id+"'"
	ll_row = dw_consultant_list.find(ls_find,1,ll_rowcount)
	If ll_row <= 0 Then Return
End If

dw_consultant_list.object.specialty_id[ll_row] = specialty_id
dw_consultant_list.object.consultant_id[ll_row] = ls_consultant_id
dw_consultant_list.object.description[ll_row] = lstr_consultant.description
dw_consultant_list.object.address1[ll_row] = lstr_consultant.address1
dw_consultant_list.object.address2[ll_row] = lstr_consultant.address2
dw_consultant_list.object.city[ll_row] = lstr_consultant.city
dw_consultant_list.object.state[ll_row] = lstr_consultant.state
dw_consultant_list.object.zip[ll_row] = lstr_consultant.zip
dw_consultant_list.object.phone[ll_row] = lstr_consultant.phone
dw_consultant_list.object.fax[ll_row] = lstr_consultant.fax
dw_consultant_list.object.phone2[ll_row] = lstr_consultant.phone2
dw_consultant_list.object.email[ll_row] = lstr_consultant.email
dw_consultant_list.object.contact[ll_row] = lstr_consultant.contact
dw_consultant_list.object.first_name[ll_row] = lstr_consultant.first_name
dw_consultant_list.object.middle_name[ll_row] = lstr_consultant.middle_name
dw_consultant_list.object.last_name[ll_row] = lstr_consultant.last_name
dw_consultant_list.object.degree[ll_row] = lstr_consultant.degree
dw_consultant_list.object.name_prefix[ll_row] = lstr_consultant.name_prefix
dw_consultant_list.object.name_suffix[ll_row] = lstr_consultant.name_suffix
dw_consultant_list.object.owner_id[ll_row] = lstr_consultant.owner_id

dw_consultant_list.object.selected_flag[ll_row] = 1

dw_consultant_list.update()

end subroutine

on u_specialties_consultants.create
this.st_left_page=create st_left_page
this.st_right_page=create st_right_page
this.pb_right_down=create pb_right_down
this.pb_right_up=create pb_right_up
this.pb_left_down=create pb_left_down
this.pb_left_up=create pb_left_up
this.cb_new_consultant=create cb_new_consultant
this.cb_delete_specialty=create cb_delete_specialty
this.cb_new_specialty=create cb_new_specialty
this.st_2=create st_2
this.dw_consultant_list=create dw_consultant_list
this.dw_specialty_list=create dw_specialty_list
this.st_1=create st_1
this.Control[]={this.st_left_page,&
this.st_right_page,&
this.pb_right_down,&
this.pb_right_up,&
this.pb_left_down,&
this.pb_left_up,&
this.cb_new_consultant,&
this.cb_delete_specialty,&
this.cb_new_specialty,&
this.st_2,&
this.dw_consultant_list,&
this.dw_specialty_list,&
this.st_1}
end on

on u_specialties_consultants.destroy
destroy(this.st_left_page)
destroy(this.st_right_page)
destroy(this.pb_right_down)
destroy(this.pb_right_up)
destroy(this.pb_left_down)
destroy(this.pb_left_up)
destroy(this.cb_new_consultant)
destroy(this.cb_delete_specialty)
destroy(this.cb_new_specialty)
destroy(this.st_2)
destroy(this.dw_consultant_list)
destroy(this.dw_specialty_list)
destroy(this.st_1)
end on

type st_left_page from statictext within u_specialties_consultants
integer x = 731
integer y = 8
integer width = 320
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Page 99/99"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_right_page from statictext within u_specialties_consultants
integer x = 2002
integer y = 20
integer width = 320
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Page 99/99"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_right_down from u_picture_button within u_specialties_consultants
boolean visible = false
integer x = 1970
integer y = 96
integer width = 137
integer height = 116
integer taborder = 20
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_consultant_list.current_page
li_last_page = dw_consultant_list.last_page

dw_consultant_list.set_page(li_page + 1, st_right_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_right_up.enabled = true
end event

type pb_right_up from u_picture_button within u_specialties_consultants
boolean visible = false
integer x = 2158
integer y = 96
integer width = 137
integer height = 116
integer taborder = 20
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_consultant_list.current_page

dw_consultant_list.set_page(li_page - 1, st_right_page.text)

if li_page <= 2 then enabled = false
pb_right_down.enabled = true

end event

type pb_left_down from u_picture_button within u_specialties_consultants
boolean visible = false
integer x = 727
integer y = 84
integer width = 137
integer height = 116
integer taborder = 10
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;integer li_page
integer li_last_page

li_page = dw_specialty_list.current_page
li_last_page = dw_specialty_list.last_page

dw_specialty_list.set_page(li_page + 1, st_left_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_left_up.enabled = true
end event

type pb_left_up from u_picture_button within u_specialties_consultants
boolean visible = false
integer x = 914
integer y = 84
integer width = 137
integer height = 116
integer taborder = 10
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;integer li_page

li_page = dw_specialty_list.current_page

dw_specialty_list.set_page(li_page - 1, st_left_page.text)

if li_page <= 2 then enabled = false
pb_left_down.enabled = true

end event

type cb_new_consultant from commandbutton within u_specialties_consultants
event clicked pbm_bnclicked
integer x = 1563
integer y = 1608
integer width = 425
integer height = 108
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New"
end type

event clicked;str_popup popup
str_popup_return popup_return
string ls_consultant_id
long ll_row
integer li_sts
string ls_description

popup.title = "Enter consultant name or description"
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_description = trim(popup_return.items[1])
if ls_description = "" then return

ls_consultant_id = get_consultant_id(ls_description)

ll_row = dw_consultant_list.insertrow(0)
dw_consultant_list.object.specialty_id[ll_row] = specialty_id
dw_consultant_list.object.consultant_id[ll_row] = ls_consultant_id
dw_consultant_list.object.description[ll_row] = ls_description
dw_consultant_list.object.sort_sequence[ll_row] = ll_row

li_sts = dw_consultant_list.update()
if li_sts <= 0 then
	openwithparm(w_pop_message, "Error saving new consultant")
	return
end if

consultant_id = ls_consultant_id

edit_consultant()


end event

type cb_delete_specialty from commandbutton within u_specialties_consultants
event clicked pbm_bnclicked
integer x = 608
integer y = 1604
integer width = 425
integer height = 108
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete"
end type

event clicked;str_popup_return popup_return

openwithparm(w_pop_yes_no, "Are you sure you wish to delete the selected specialties?")
popup_return = message.powerobjectparm
if popup_return.item = "YES" then
	dw_specialty_list.delete_selected()
	dw_specialty_list.update()
	dw_specialty_list.postevent("specialty_not_selected")
end if


end event

type cb_new_specialty from commandbutton within u_specialties_consultants
event clicked pbm_bnclicked
integer x = 110
integer y = 1608
integer width = 407
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New"
end type

event clicked;long ll_row
string ls_description
str_popup popup
str_popup_return popup_return
string ls_temp, ls_char, ls_find
integer i

popup.item = "Enter New Specialty:"
openwithparm(w_pop_get_string, popup)
popup_return = message.powerobjectparm
ls_description = popup_return.item
if isnull(ls_description) or trim(ls_description) = "" then return

specialty_id = upper(trim(ls_description))
if len(specialty_id) > 24 then specialty_id = left(specialty_id, 24)
for i = 1 to len(specialty_id)
	ls_char = mid(specialty_id, i, 1)
	if ls_char < "A" or ls_char > "Z" then specialty_id = replace(specialty_id, i, 1, "_")
next

ls_find = "specialty_id='" + specialty_id + "'"
ll_row = dw_specialty_list.find(ls_find, 1, dw_specialty_list.rowcount())
if ll_row > 0 then
	i = 0
	DO
		i += 1
		ls_temp = string(i)
		specialty_id = left(specialty_id, len(specialty_id) - len(ls_temp)) + ls_temp
		ls_find = "specialty_id='" + specialty_id + "'"
		ll_row = dw_specialty_list.find(ls_find, 1, dw_specialty_list.rowcount())
	LOOP WHILE ll_row > 0
end if

dw_specialty_list.clear_selected()

ll_row = dw_specialty_list.insertrow(0)
dw_specialty_list.setitem(ll_row, "specialty_id", specialty_id)
dw_specialty_list.setitem(ll_row, "description", ls_description)
dw_specialty_list.setitem(ll_row, "selected_flag", 1)
dw_specialty_list.update()
dw_specialty_list.postevent("specialty_selected")


end event

type st_2 from statictext within u_specialties_consultants
integer x = 1248
integer y = 116
integer width = 581
integer height = 100
boolean bringtotop = true
integer textsize = -16
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Consultants"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_consultant_list from u_dw_pick_list within u_specialties_consultants
event consultant_not_selected pbm_custom03
integer x = 1175
integer y = 228
integer width = 1157
integer height = 1344
integer taborder = 10
string dataobject = "dw_consultants"
boolean border = false
boolean livescroll = false
end type

event consultant_not_selected;Setnull(consultant_id)


end event

event post_click;call super::post_click;integer li_selected_flag
long ll_row,ll_button_pressed
String ls_buttons[]

str_popup popup,popup_edit
w_pop_buttons lw_pop_buttons

if lastrow <= 0 then return

li_selected_flag = object.selected_flag[lastrow]
if li_selected_flag <= 0 then
	clear_selected()
	return
end if

ll_row = get_selected_row()

If ll_row <= 0 then
	setnull(consultant_id)
	return
End if

If true Then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit"
	popup.button_titles[popup.button_count] = "Edit"
	ls_buttons[popup.button_count] = "EDIT"
End If

If ll_row > 1 Then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonup.bmp"
	popup.button_helps[popup.button_count] = "Move Up"
	popup.button_titles[popup.button_count] = "Up"
	ls_buttons[popup.button_count] = "UP"
End If
If ll_row < rowcount() Then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttondn.bmp"
	popup.button_helps[popup.button_count] = "Move down"
	popup.button_titles[popup.button_count] = "Down"
	ls_buttons[popup.button_count] = "DOWN"
End If

If true Then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Delete Item"
	popup.button_titles[popup.button_count] = "Delete Item"
	ls_buttons[popup.button_count] = "DELETE"
End If

If True Then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	ls_buttons[popup.button_count] = "CANCEL"
End If

popup.button_titles_used = True

If popup.button_count > 1 Then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	ll_button_pressed = message.doubleparm
	If ll_button_pressed < 1 Or ll_button_pressed > popup.button_count Then Return
ElseIf popup.button_count = 1 Then
	ll_button_pressed = 1
Else
	Return
End If

CHOOSE CASE ls_buttons[ll_button_pressed]
	CASE "EDIT"
		consultant_id = object.consultant_id[ll_row]
		edit_consultant()
	CASE "UP"
		move_up()
	CASE "DOWN"
		move_down()
	CASE "DELETE"
		dw_consultant_list.delete_selected()
		dw_consultant_list.update()
		dw_consultant_list.postevent("consultant_not_selected")
	CASE "CANCEL"
		Return
	CASE ELSE
END CHOOSE

Return

end event

type dw_specialty_list from u_dw_pick_list within u_specialties_consultants
event specialty_selected pbm_custom02
event specialty_not_selected pbm_custom03
integer x = 14
integer y = 220
integer width = 1079
integer height = 1364
integer taborder = 20
string dataobject = "dw_specialty_list"
boolean border = false
boolean livescroll = false
end type

event specialty_selected;string ls_filter
long ll_row


ll_row = get_selected_row()
if ll_row <= 0 then return


specialty_id = dw_specialty_list.object.specialty_id[ll_row]
specialty_description = dw_specialty_list.object.description[ll_row]
ls_filter = "specialty_id='" + specialty_id + "'"
dw_consultant_list.setfilter(ls_filter)
dw_consultant_list.filter()
dw_consultant_list.clear_selected()
dw_consultant_list.visible = true
cb_delete_specialty.enabled = true
cb_new_consultant.enabled = true
// up & dn for consultants
dw_consultant_list.last_page = 0
dw_consultant_list.set_page(1, st_right_page.text)
If dw_consultant_list.last_page < 2 then
	pb_right_down.visible = false
	pb_right_up.visible = false
Else
	pb_right_down.visible = true
	pb_right_up.visible = true
	pb_right_up.enabled = false
	pb_right_down.enabled = true
End If

//dw_consultant_list.postevent("consultant_not_selected")


end event

event specialty_not_selected;setnull(specialty_id)
dw_consultant_list.visible = false
cb_delete_specialty.enabled = false
cb_new_consultant.enabled = false
dw_consultant_list.postevent("consultant_not_selected")


end event

event post_click;call super::post_click;integer li_selected_flag
string ls_filter

if lastrow <= 0 then return

li_selected_flag = object.selected_flag[lastrow]
if li_selected_flag > 0 then
	postevent("specialty_selected")
else
	postevent("specialty_not_selected")
end if

end event

type st_1 from statictext within u_specialties_consultants
integer x = 55
integer y = 100
integer width = 544
integer height = 96
boolean bringtotop = true
integer textsize = -16
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Specialties"
alignment alignment = center!
boolean focusrectangle = false
end type

