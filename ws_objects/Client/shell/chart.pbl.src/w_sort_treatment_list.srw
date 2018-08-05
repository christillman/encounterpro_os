$PBExportHeader$w_sort_treatment_list.srw
forward
global type w_sort_treatment_list from window
end type
type cb_sort_by_description from commandbutton within w_sort_treatment_list
end type
type cb_sort_by_type from commandbutton within w_sort_treatment_list
end type
type cb_down from commandbutton within w_sort_treatment_list
end type
type cb_up from commandbutton within w_sort_treatment_list
end type
type cb_page from commandbutton within w_sort_treatment_list
end type
type dw_therapies from u_dw_pick_list within w_sort_treatment_list
end type
type pb_done from u_picture_button within w_sort_treatment_list
end type
type st_title from statictext within w_sort_treatment_list
end type
end forward

global type w_sort_treatment_list from window
integer width = 2926
integer height = 1832
windowtype windowtype = response!
long backcolor = 33538240
cb_sort_by_description cb_sort_by_description
cb_sort_by_type cb_sort_by_type
cb_down cb_down
cb_up cb_up
cb_page cb_page
dw_therapies dw_therapies
pb_done pb_done
st_title st_title
end type
global w_sort_treatment_list w_sort_treatment_list

type variables
u_dw_pick_list treatments
string assessment_description

long parent_definition_id


end variables

event open;str_popup popup
integer li_sts
long i

popup = message.powerobjectparm

treatments = popup.objectparm
assessment_description = popup.title

st_title.text = assessment_description

li_sts = treatments.sharedata(dw_therapies)
if li_sts <= 0 then
	log.log(this, "w_sort_treatment_list:open", "Error getting treatment data", 4)
	close(this)
	return
end if


for i = 1 to dw_therapies.rowcount()
	dw_therapies.object.sort_sequence[i] = i
next

dw_therapies.set_page(1, cb_page.text)

setnull(parent_definition_id)

end event

on w_sort_treatment_list.create
this.cb_sort_by_description=create cb_sort_by_description
this.cb_sort_by_type=create cb_sort_by_type
this.cb_down=create cb_down
this.cb_up=create cb_up
this.cb_page=create cb_page
this.dw_therapies=create dw_therapies
this.pb_done=create pb_done
this.st_title=create st_title
this.Control[]={this.cb_sort_by_description,&
this.cb_sort_by_type,&
this.cb_down,&
this.cb_up,&
this.cb_page,&
this.dw_therapies,&
this.pb_done,&
this.st_title}
end on

on w_sort_treatment_list.destroy
destroy(this.cb_sort_by_description)
destroy(this.cb_sort_by_type)
destroy(this.cb_down)
destroy(this.cb_up)
destroy(this.cb_page)
destroy(this.dw_therapies)
destroy(this.pb_done)
destroy(this.st_title)
end on

type cb_sort_by_description from commandbutton within w_sort_treatment_list
integer x = 2057
integer y = 1072
integer width = 645
integer height = 108
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Sort by Description"
end type

event clicked;long i

dw_therapies.setredraw(false)

dw_therapies.setsort("treatment_description")
dw_therapies.sort()

for i = 1 to dw_therapies.rowcount()
	dw_therapies.object.sort_sequence[i] = i
next

dw_therapies.setsort("sort_sequence,type_sort_sequence,treatment_description")
dw_therapies.sort()

dw_therapies.setredraw(true)

end event

type cb_sort_by_type from commandbutton within w_sort_treatment_list
integer x = 2057
integer y = 904
integer width = 645
integer height = 108
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Sort by Type"
end type

event clicked;long i

dw_therapies.setredraw(false)

dw_therapies.setsort("type_sort_sequence,treatment_description")
dw_therapies.sort()

for i = 1 to dw_therapies.rowcount()
	dw_therapies.object.sort_sequence[i] = i
next

dw_therapies.setsort("sort_sequence,type_sort_sequence,treatment_description")
dw_therapies.sort()

dw_therapies.setredraw(true)

end event

type cb_down from commandbutton within w_sort_treatment_list
integer x = 2057
integer y = 612
integer width = 645
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Move Down"
end type

event clicked;long ll_row
integer li_temp

ll_row = dw_therapies.get_selected_row()
if ll_row <= 0 then return
if ll_row >= dw_therapies.rowcount() then return

dw_therapies.setredraw(false)

li_temp = dw_therapies.object.sort_sequence[ll_row + 1]

dw_therapies.object.sort_sequence[ll_row + 1] = dw_therapies.object.sort_sequence[ll_row]

dw_therapies.object.sort_sequence[ll_row] = li_temp

dw_therapies.sort()

ll_row = dw_therapies.get_selected_row()

dw_therapies.scrolltorow(ll_row)
dw_therapies.recalc_page(cb_page.text)

dw_therapies.setredraw(true)

cb_up.enabled = true

if ll_row < dw_therapies.rowcount() then
	cb_down.enabled = true
else
	cb_down.enabled = false
end if

end event

type cb_up from commandbutton within w_sort_treatment_list
integer x = 2057
integer y = 444
integer width = 645
integer height = 108
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Move Up"
end type

event clicked;long ll_row
integer li_temp

ll_row = dw_therapies.get_selected_row()
if ll_row <= 1 then return

dw_therapies.setredraw(false)

li_temp = dw_therapies.object.sort_sequence[ll_row - 1]

dw_therapies.object.sort_sequence[ll_row - 1] = dw_therapies.object.sort_sequence[ll_row]

dw_therapies.object.sort_sequence[ll_row] = li_temp

dw_therapies.sort()

ll_row = dw_therapies.get_selected_row()

dw_therapies.scrolltorow(ll_row)
dw_therapies.recalc_page(cb_page.text)

dw_therapies.setredraw(true)

cb_down.enabled = true

if ll_row > 1 then
	cb_up.enabled = true
else
	cb_up.enabled = false
end if

end event

type cb_page from commandbutton within w_sort_treatment_list
integer x = 1888
integer y = 116
integer width = 402
integer height = 108
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Page 99 of 99"
end type

event clicked;dw_therapies.set_page(dw_therapies.current_page + 1, this.text)

end event

type dw_therapies from u_dw_pick_list within w_sort_treatment_list
integer x = 14
integer y = 108
integer width = 1838
integer height = 1704
integer taborder = 60
string dataobject = "dw_assessment_treatments"
boolean border = false
end type

event selected;if selected_row > 1 then
	cb_up.enabled = true
else
	cb_up.enabled = false
end if
	
if selected_row < rowcount() then
	cb_down.enabled = true
else
	cb_down.enabled = false
end if
end event

event unselected;call super::unselected;cb_up.enabled = false
cb_down.enabled = false

end event

event computed_clicked;Long 		i
String	ls_filter

If object.treatment_type[clicked_row] = "!COMPOSITE" Then
	clear_selected()
	parent_definition_id = object.definition_id[clicked_row]
	st_title.text = object.treatment_description[clicked_row]
	ls_filter = "parent_definition_id=" + string(parent_definition_id)+" And update_flag >= 0"
	setfilter(ls_filter)
	filter()
	sort()
	
	For i = 1 To rowcount()
		dw_therapies.object.sort_sequence[i] = i
	Next
	
	cb_up.enabled = False
	cb_down.enabled = False
	dw_therapies.set_page(1, cb_page.text)
End If
end event

type pb_done from u_picture_button within w_sort_treatment_list
integer x = 2629
integer y = 1560
integer taborder = 50
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;string ls_find
long ll_row

// If we're looking at the main list, then return
if isnull(parent_definition_id) then
	dw_therapies.clear_selected()
	close(parent)
	return
end if

// Otherwise, display the main list
st_title.text = assessment_description
dw_therapies.setfilter("isnull(parent_definition_id)")
dw_therapies.filter()
dw_therapies.sort()

// Now select the composite treatment
ls_find = "parent_definition_id=" + string(parent_definition_id)
ll_row = dw_therapies.find(ls_find, 1, dw_therapies.rowcount())
if ll_row > 0 then
	dw_therapies.object.selected_flag[ll_row] = 1
	if ll_row > 1 then
		cb_up.enabled = true
	else
		cb_up.enabled = false
	end if
	
	if ll_row < dw_therapies.rowcount() then
		cb_down.enabled = true
	else
		cb_down.enabled = false
	end if
end if

dw_therapies.set_page(1, cb_page.text)

setnull(parent_definition_id)


end event

on mouse_move;f_cpr_set_msg("Done")
end on

type st_title from statictext within w_sort_treatment_list
integer width = 2930
integer height = 112
integer textsize = -18
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

