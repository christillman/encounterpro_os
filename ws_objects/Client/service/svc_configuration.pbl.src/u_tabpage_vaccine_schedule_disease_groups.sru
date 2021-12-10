$PBExportHeader$u_tabpage_vaccine_schedule_disease_groups.sru
forward
global type u_tabpage_vaccine_schedule_disease_groups from u_tabpage_vaccine_schedule_base
end type
type cb_move_disease from commandbutton within u_tabpage_vaccine_schedule_disease_groups
end type
type cb_move_disease_group from commandbutton within u_tabpage_vaccine_schedule_disease_groups
end type
type cb_edit_disease_group from commandbutton within u_tabpage_vaccine_schedule_disease_groups
end type
type cb_remove_disease from commandbutton within u_tabpage_vaccine_schedule_disease_groups
end type
type cb_add_disease from commandbutton within u_tabpage_vaccine_schedule_disease_groups
end type
type cb_remove_disease_group from commandbutton within u_tabpage_vaccine_schedule_disease_groups
end type
type cb_add_disease_group from commandbutton within u_tabpage_vaccine_schedule_disease_groups
end type
type st_diseases_title from statictext within u_tabpage_vaccine_schedule_disease_groups
end type
type dw_diseases from u_dw_pick_list within u_tabpage_vaccine_schedule_disease_groups
end type
type st_disease_groups_title from statictext within u_tabpage_vaccine_schedule_disease_groups
end type
type dw_disease_groups from u_dw_pick_list within u_tabpage_vaccine_schedule_disease_groups
end type
end forward

global type u_tabpage_vaccine_schedule_disease_groups from u_tabpage_vaccine_schedule_base
cb_move_disease cb_move_disease
cb_move_disease_group cb_move_disease_group
cb_edit_disease_group cb_edit_disease_group
cb_remove_disease cb_remove_disease
cb_add_disease cb_add_disease
cb_remove_disease_group cb_remove_disease_group
cb_add_disease_group cb_add_disease_group
st_diseases_title st_diseases_title
dw_diseases dw_diseases
st_disease_groups_title st_disease_groups_title
dw_disease_groups dw_disease_groups
end type
global u_tabpage_vaccine_schedule_disease_groups u_tabpage_vaccine_schedule_disease_groups

forward prototypes
public subroutine refresh ()
end prototypes

public subroutine refresh ();long ll_count
long ll_row

ll_row = dw_disease_groups.get_selected_row()
if isnull(ll_row) or ll_row <= 0 then ll_row = 1

dw_disease_groups.settransobject(sqlca)
ll_count = dw_disease_groups.retrieve()
if ll_count >= ll_row then
	dw_disease_groups.object.selected_flag[ll_row] = 1
	dw_disease_groups.event POST selected(ll_row)
else
	dw_diseases.reset()
end if



end subroutine

on u_tabpage_vaccine_schedule_disease_groups.create
int iCurrent
call super::create
this.cb_move_disease=create cb_move_disease
this.cb_move_disease_group=create cb_move_disease_group
this.cb_edit_disease_group=create cb_edit_disease_group
this.cb_remove_disease=create cb_remove_disease
this.cb_add_disease=create cb_add_disease
this.cb_remove_disease_group=create cb_remove_disease_group
this.cb_add_disease_group=create cb_add_disease_group
this.st_diseases_title=create st_diseases_title
this.dw_diseases=create dw_diseases
this.st_disease_groups_title=create st_disease_groups_title
this.dw_disease_groups=create dw_disease_groups
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_move_disease
this.Control[iCurrent+2]=this.cb_move_disease_group
this.Control[iCurrent+3]=this.cb_edit_disease_group
this.Control[iCurrent+4]=this.cb_remove_disease
this.Control[iCurrent+5]=this.cb_add_disease
this.Control[iCurrent+6]=this.cb_remove_disease_group
this.Control[iCurrent+7]=this.cb_add_disease_group
this.Control[iCurrent+8]=this.st_diseases_title
this.Control[iCurrent+9]=this.dw_diseases
this.Control[iCurrent+10]=this.st_disease_groups_title
this.Control[iCurrent+11]=this.dw_disease_groups
end on

on u_tabpage_vaccine_schedule_disease_groups.destroy
call super::destroy
destroy(this.cb_move_disease)
destroy(this.cb_move_disease_group)
destroy(this.cb_edit_disease_group)
destroy(this.cb_remove_disease)
destroy(this.cb_add_disease)
destroy(this.cb_remove_disease_group)
destroy(this.cb_add_disease_group)
destroy(this.st_diseases_title)
destroy(this.dw_diseases)
destroy(this.st_disease_groups_title)
destroy(this.dw_disease_groups)
end on

event resize_tabpage;call super::resize_tabpage;long ll_gap


ll_gap = (width - (dw_disease_groups.width + dw_diseases.width)) / 3

dw_disease_groups.x = ll_gap
st_disease_groups_title.x = dw_disease_groups.x

dw_diseases.x = width - ll_gap - dw_diseases.width
st_diseases_title.x = dw_diseases.x


cb_add_disease_group.x = dw_disease_groups.x - 50
cb_move_disease_group.x = dw_disease_groups.x + dw_disease_groups.width + 50 - cb_move_disease_group.width
ll_gap = (cb_move_disease_group.x - cb_add_disease_group.x - cb_add_disease_group.width - cb_edit_disease_group.width - cb_remove_disease_group.width) / 3
cb_edit_disease_group.x = cb_add_disease_group.x + cb_add_disease_group.width + ll_gap
cb_remove_disease_group.x = cb_edit_disease_group.x + cb_edit_disease_group.width + ll_gap

cb_add_disease.x = dw_diseases.x - 50
cb_move_disease.x = dw_diseases.x + dw_diseases.width + 50 - cb_move_disease.width
cb_remove_disease.x = dw_diseases.x + ((dw_diseases.width - cb_remove_disease.width) / 2)

cb_add_disease_group.y = height - cb_add_disease_group.height - 100
cb_edit_disease_group.y = cb_add_disease_group.y
cb_remove_disease_group.y = cb_add_disease_group.y
cb_move_disease_group.y = cb_add_disease_group.y
cb_add_disease.y = cb_add_disease_group.y
cb_remove_disease.y = cb_add_disease_group.y
cb_move_disease.y = cb_add_disease_group.y


dw_disease_groups.height = cb_remove_disease_group.y - dw_disease_groups.y - 100
dw_diseases.height = dw_disease_groups.height

end event

type cb_move_disease from commandbutton within u_tabpage_vaccine_schedule_disease_groups
integer x = 2167
integer y = 1340
integer width = 306
integer height = 108
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Move"
end type

event clicked;long ll_row

ll_row = dw_diseases.get_selected_row()
if ll_row <= 0 then return

f_pick_list_move_row(dw_diseases, ll_row)

end event

type cb_move_disease_group from commandbutton within u_tabpage_vaccine_schedule_disease_groups
integer x = 1070
integer y = 1424
integer width = 306
integer height = 108
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Move"
end type

event clicked;long ll_row

ll_row = dw_disease_groups.get_selected_row()
if ll_row <= 0 then return

f_pick_list_move_row(dw_disease_groups, ll_row)

end event

type cb_edit_disease_group from commandbutton within u_tabpage_vaccine_schedule_disease_groups
integer x = 375
integer y = 1356
integer width = 306
integer height = 108
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Edit"
end type

event clicked;long ll_row
string ls_disease_group

ll_row = dw_disease_groups.get_selected_row()
if ll_row <= 0 then return

ls_disease_group = dw_disease_groups.object.disease_group[ll_row]

openwithparm(w_pop_disease_group_edit, ls_disease_group)

refresh()

end event

type cb_remove_disease from commandbutton within u_tabpage_vaccine_schedule_disease_groups
integer x = 1801
integer y = 1336
integer width = 306
integer height = 108
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Remove"
end type

event clicked;integer li_sts
long ll_row
string ls_disease_group
string ls_disease
str_popup_return popup_return
long ll_disease_id

ll_row = dw_disease_groups.get_selected_row()
if ll_row <= 0 then return

ls_disease_group = dw_disease_groups.object.disease_group[ll_row]

ll_row = dw_diseases.get_selected_row()
if ll_row <= 0 then return

ll_disease_id = dw_diseases.object.disease_id[ll_row]
ls_disease = dw_diseases.object.description[ll_row]

openwithparm(w_pop_yes_no, "Are you sure you want to remove the disease ~"" + ls_disease + "~" from the disease group ~"" + ls_disease_group + "~"?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

dw_diseases.deleterow(ll_row)

li_sts = dw_diseases.update()
if li_sts <= 0 then
	openwithparm(w_pop_message, "An error occured removing the disease")
end if

refresh()

end event

type cb_add_disease from commandbutton within u_tabpage_vaccine_schedule_disease_groups
integer x = 1435
integer y = 1336
integer width = 306
integer height = 108
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Add"
end type

event clicked;str_popup popup
str_popup_return popup_return
long ll_disease_id
long ll_row
long ll_count
string ls_disease_group
long ll_sort_sequence

ll_row = dw_disease_groups.get_selected_row()
if ll_row <= 0 then return

ls_disease_group = dw_disease_groups.object.disease_group[ll_row]

popup.dataobject = "dw_disease_list"
popup.datacolumn = 1
popup.displaycolumn = 2

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ll_disease_id = long(popup_return.items[1])

SELECT count(*)
INTO :ll_count
FROM c_Disease_Group_Item
WHERE disease_group = :ls_disease_group
AND disease_id = :ll_disease_id;
if not tf_check() then return

if ll_count > 0 then
	openwithparm(w_pop_message, "The selected disease already exists in this disease group")
	return
end if

SELECT max(sort_sequence)
INTO :ll_sort_sequence
FROM c_Disease_Group_Item
WHERE disease_group = :ls_disease_group;
if not tf_check() then return

if isnull(ll_sort_sequence) then
	ll_sort_sequence = 1
else
	ll_sort_sequence +=1 
end if

INSERT INTO c_Disease_Group_Item (
	disease_group,
	disease_id,
	sort_sequence)
VALUES (
	:ls_disease_group,
	:ll_disease_id,
	:ll_sort_sequence);
if not tf_check() then return

dw_disease_groups.event POST selected(ll_row)

end event

type cb_remove_disease_group from commandbutton within u_tabpage_vaccine_schedule_disease_groups
integer x = 722
integer y = 1368
integer width = 306
integer height = 108
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Remove"
end type

event clicked;integer li_sts
long ll_row
string ls_disease_group
str_popup_return popup_return

ll_row = dw_disease_groups.get_selected_row()
if ll_row <= 0 then return

ls_disease_group = dw_disease_groups.object.disease_group[ll_row]

openwithparm(w_pop_yes_no, "Are you sure you want to remove the disease group ~"" + ls_disease_group + "~"?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

dw_disease_groups.deleterow(ll_row)

li_sts = dw_disease_groups.update()
if li_sts <= 0 then
	openwithparm(w_pop_message, "An error occured deleting the disease group")
else
	openwithparm(w_pop_message, "The disease group ~"" + ls_disease_group + "~" was successfully removed.")
end if

refresh()

end event

type cb_add_disease_group from commandbutton within u_tabpage_vaccine_schedule_disease_groups
integer x = 27
integer y = 1328
integer width = 306
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add"
end type

event clicked;string ls_new_disease_group
string ls_find
long ll_row

ls_new_disease_group = f_new_disease_group()
if isnull(ls_new_disease_group) then return

refresh()

ls_find = "disease_group='" + ls_new_disease_group + "'"
ll_row = dw_disease_groups.find(ls_find, 1, dw_disease_groups.rowcount())
if ll_row > 0 then
	dw_disease_groups.clear_selected()
	dw_disease_groups.object.selected_flag[ll_row] = 1
	dw_disease_groups.event post selected(ll_row)
	dw_disease_groups.scrolltorow(ll_row)
end if

end event

type st_diseases_title from statictext within u_tabpage_vaccine_schedule_disease_groups
integer x = 1481
integer y = 64
integer width = 901
integer height = 80
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Diseases in Group"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_diseases from u_dw_pick_list within u_tabpage_vaccine_schedule_disease_groups
integer x = 1481
integer y = 156
integer width = 983
integer height = 1140
integer taborder = 20
string dataobject = "dw_diseases_in_group"
end type

event selected;call super::selected;cb_remove_disease.enabled = true
cb_move_disease.enabled = true

end event

event unselected;call super::unselected;cb_remove_disease.enabled = false
cb_move_disease.enabled = false

end event

type st_disease_groups_title from statictext within u_tabpage_vaccine_schedule_disease_groups
integer x = 32
integer y = 64
integer width = 1234
integer height = 80
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Disease Groups"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_disease_groups from u_dw_pick_list within u_tabpage_vaccine_schedule_disease_groups
integer x = 23
integer y = 156
integer width = 1330
integer height = 1140
integer taborder = 10
string dataobject = "dw_c_disease_group"
end type

event selected;call super::selected;string ls_disease_group

ls_disease_group = object.disease_group[selected_row]

dw_diseases.settransobject(sqlca)
dw_diseases.retrieve(ls_disease_group)

cb_edit_disease_group.enabled = true
cb_remove_disease_group.enabled = true
cb_move_disease_group.enabled = true

cb_add_disease.enabled = true
cb_remove_disease.enabled = false


end event

event unselected;call super::unselected;dw_diseases.reset()

cb_edit_disease_group.enabled = false
cb_remove_disease_group.enabled = false

cb_add_disease.enabled = false
cb_remove_disease.enabled = false

cb_move_disease_group.enabled = false
cb_move_disease.enabled = false

end event

