$PBExportHeader$w_treatment_list_change_sort_order.srw
forward
global type w_treatment_list_change_sort_order from w_window_base
end type
type pb_top from u_picture_button within w_treatment_list_change_sort_order
end type
type pb_bottom from u_picture_button within w_treatment_list_change_sort_order
end type
type pb_down from u_picture_button within w_treatment_list_change_sort_order
end type
type pb_up from u_picture_button within w_treatment_list_change_sort_order
end type
type cb_finished from commandbutton within w_treatment_list_change_sort_order
end type
type cb_sort_by_description from commandbutton within w_treatment_list_change_sort_order
end type
type cb_sort_by_type from commandbutton within w_treatment_list_change_sort_order
end type
type dw_treatments from u_dw_pick_list within w_treatment_list_change_sort_order
end type
type st_title from statictext within w_treatment_list_change_sort_order
end type
end forward

global type w_treatment_list_change_sort_order from w_window_base
windowtype windowtype = response!
boolean auto_resize_window = false
boolean auto_resize_objects = false
boolean nested_user_object_resize = false
real y_factor = 0.00
pb_top pb_top
pb_bottom pb_bottom
pb_down pb_down
pb_up pb_up
cb_finished cb_finished
cb_sort_by_description cb_sort_by_description
cb_sort_by_type cb_sort_by_type
dw_treatments dw_treatments
st_title st_title
end type
global w_treatment_list_change_sort_order w_treatment_list_change_sort_order

type variables
string assessment_id
string list_user_id
long care_plan_id
long parent_definition_id


end variables

event open;call super::open;str_popup popup
integer li_sts
long i
long ll_count
string ls_filter

popup = message.powerobjectparm

if popup.argument_count >= 3 then
	// Passed in a parent_definition_id
	assessment_id = popup.argument[1]
	list_user_id = popup.argument[2]
	care_plan_id = long(popup.argument[3])
else
	log.log(this, "w_treatment_list_change_sort_order:open", "Invalid arguments", 4)
	close(this)
	return
end if


if popup.argument_count >= 4 then
	parent_definition_id = long(popup.argument[4])
else
	setnull(parent_definition_id)
end if

if len(popup.title) > 0 then
	st_title.text = popup.title
else
	st_title.text = datalist.assessment_description(assessment_id)
end if

if isnull(parent_definition_id) then
	ls_filter = "isnull(parent_definition_id)"
else
	ls_filter = "parent_definition_id=" + string(parent_definition_id)
end if


dw_treatments.settransobject(sqlca)
dw_treatments.setfilter(ls_filter)

ll_count = dw_treatments.retrieve(current_patient.cpr_id, assessment_id, list_user_id, care_plan_id)
if ll_count < 0 then
	log.log(this, "w_treatment_list_change_sort_order:open", "Error getting treatment list", 4)
	close(this)
	return
end if

for i = 1 to dw_treatments.rowcount()
	dw_treatments.object.treatment_sort_sequence[i] = i
	if isnull(parent_definition_id) then
		dw_treatments.object.sort_parent_sort_sequence[i] = i
	end if
next

x = (main_window.width - width) / 2
y = (main_window.height - height) / 2

cb_sort_by_description.x = width - cb_sort_by_description.width - 30
cb_sort_by_type.x = cb_sort_by_description.x

pb_top.x = cb_sort_by_description.x + (cb_sort_by_description.width - pb_top.width) / 2
pb_up.x = pb_top.x
pb_down.x = pb_top.x
pb_bottom.x = pb_top.x

dw_treatments.width = cb_sort_by_description.x - dw_treatments.x - 30
dw_treatments.height = height - dw_treatments.y - 200
dw_treatments.object.t_info_background.x = dw_treatments.width - 672

cb_finished.x = width - cb_finished.width - 30
cb_finished.y = height - cb_finished.height - 80


pb_top.enabled = false
pb_up.enabled = false
pb_down.enabled = false
pb_bottom.enabled = false


end event

on w_treatment_list_change_sort_order.create
int iCurrent
call super::create
this.pb_top=create pb_top
this.pb_bottom=create pb_bottom
this.pb_down=create pb_down
this.pb_up=create pb_up
this.cb_finished=create cb_finished
this.cb_sort_by_description=create cb_sort_by_description
this.cb_sort_by_type=create cb_sort_by_type
this.dw_treatments=create dw_treatments
this.st_title=create st_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_top
this.Control[iCurrent+2]=this.pb_bottom
this.Control[iCurrent+3]=this.pb_down
this.Control[iCurrent+4]=this.pb_up
this.Control[iCurrent+5]=this.cb_finished
this.Control[iCurrent+6]=this.cb_sort_by_description
this.Control[iCurrent+7]=this.cb_sort_by_type
this.Control[iCurrent+8]=this.dw_treatments
this.Control[iCurrent+9]=this.st_title
end on

on w_treatment_list_change_sort_order.destroy
call super::destroy
destroy(this.pb_top)
destroy(this.pb_bottom)
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.cb_finished)
destroy(this.cb_sort_by_description)
destroy(this.cb_sort_by_type)
destroy(this.dw_treatments)
destroy(this.st_title)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_treatment_list_change_sort_order
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_treatment_list_change_sort_order
end type

type pb_top from u_picture_button within w_treatment_list_change_sort_order
integer x = 2405
integer y = 188
integer taborder = 70
boolean bringtotop = true
boolean originalsize = false
string picturename = "buttontop.bmp"
string disabledname = "buttontopx.bmp"
end type

event clicked;long ll_row,ll_rowcount
integer li_temp
string ls_text
long i

ll_row = dw_treatments.get_selected_row()
if ll_row <= 1 then return

dw_treatments.setredraw(false)

dw_treatments.object.treatment_sort_sequence[ll_row] = 1
if isnull(parent_definition_id) then
	dw_treatments.object.sort_parent_sort_sequence[ll_row] = 1
end if

for i = 1 to ll_row - 1
	dw_treatments.object.treatment_sort_sequence[i] = i + 1
	if isnull(parent_definition_id) then
		dw_treatments.object.sort_parent_sort_sequence[i] = i + 1
	end if
next

dw_treatments.sort()

ll_row = dw_treatments.get_selected_row()

dw_treatments.scrolltorow(ll_row)

dw_treatments.update()

dw_treatments.setredraw(true)

pb_up.enabled = false
pb_down.enabled = true
pb_bottom.enabled = true
enabled = false


end event

type pb_bottom from u_picture_button within w_treatment_list_change_sort_order
integer x = 2405
integer y = 888
integer taborder = 50
boolean bringtotop = true
boolean originalsize = false
string picturename = "buttonlast.bmp"
string disabledname = "buttonlastx.bmp"
end type

event clicked;call super::clicked;long ll_row,ll_rowcount
integer li_temp
string ls_text
long i

ll_row = dw_treatments.get_selected_row()
if ll_row <= 0 then return
ll_rowcount = dw_treatments.rowcount()
if ll_row >= ll_rowcount then return

dw_treatments.setredraw(false)

dw_treatments.object.treatment_sort_sequence[ll_row] = ll_rowcount
if isnull(parent_definition_id) then
	dw_treatments.object.sort_parent_sort_sequence[ll_row] = ll_rowcount
end if

for i = ll_row + 1 to ll_rowcount
	dw_treatments.object.treatment_sort_sequence[i] = i - 1
	if isnull(parent_definition_id) then
		dw_treatments.object.sort_parent_sort_sequence[i] = i - 1
	end if
next

li_temp = dw_treatments.object.treatment_sort_sequence[ll_rowcount]

dw_treatments.object.treatment_sort_sequence[ll_row] = dw_treatments.object.treatment_sort_sequence[ll_rowcount] + 1

dw_treatments.sort()

ll_row = dw_treatments.get_selected_row()

dw_treatments.scrolltorow(ll_row)

dw_treatments.update()

dw_treatments.setredraw(true)

pb_up.enabled = true
pb_down.enabled = false
pb_top.enabled = true
enabled = false
end event

type pb_down from u_picture_button within w_treatment_list_change_sort_order
integer x = 2405
integer y = 656
integer taborder = 40
boolean originalsize = false
string picturename = "buttondn.bmp"
string disabledname = "buttondnx.bmp"
end type

event clicked;call super::clicked;long ll_row
string ls_text

ll_row = dw_treatments.get_selected_row()
if ll_row <= 0 then return
if ll_row >= dw_treatments.rowcount() then
	pb_bottom.enabled = false
	return
end if
pb_bottom.enabled = true
dw_treatments.setredraw(false)

dw_treatments.object.treatment_sort_sequence[ll_row + 1] = ll_row
if isnull(parent_definition_id) then
	dw_treatments.object.sort_parent_sort_sequence[ll_row + 1] = ll_row
end if

dw_treatments.object.treatment_sort_sequence[ll_row] = ll_row + 1
if isnull(parent_definition_id) then
	dw_treatments.object.sort_parent_sort_sequence[ll_row] = ll_row + 1
end if

dw_treatments.sort()

ll_row = dw_treatments.get_selected_row()

dw_treatments.scrolltorow(ll_row)

dw_treatments.update()

dw_treatments.setredraw(true)

pb_up.enabled = true
pb_top.enabled = true

if ll_row < dw_treatments.rowcount() then
	pb_down.enabled = true
	pb_bottom.enabled = true
else
	pb_down.enabled = false
	pb_bottom.enabled = false
end if

end event

type pb_up from u_picture_button within w_treatment_list_change_sort_order
integer x = 2405
integer y = 424
integer taborder = 70
boolean originalsize = false
string picturename = "buttonup.bmp"
string disabledname = "buttonupx.bmp"
end type

event clicked;long ll_row
string ls_text

ll_row = dw_treatments.get_selected_row()
if ll_row <= 1 then
	pb_top.enabled = false
	return
end if
pb_top.enabled = true
dw_treatments.setredraw(false)

dw_treatments.object.treatment_sort_sequence[ll_row - 1] = ll_row
if isnull(parent_definition_id) then
	dw_treatments.object.sort_parent_sort_sequence[ll_row - 1] = ll_row
end if

dw_treatments.object.treatment_sort_sequence[ll_row] = ll_row - 1
if isnull(parent_definition_id) then
	dw_treatments.object.sort_parent_sort_sequence[ll_row] = ll_row - 1
end if

dw_treatments.sort()

ll_row = dw_treatments.get_selected_row()

dw_treatments.scrolltorow(ll_row)

dw_treatments.update()

dw_treatments.setredraw(true)

pb_down.enabled = true
pb_bottom.enabled = true

if ll_row > 1 then
	pb_up.enabled = true
	pb_top.enabled = true
else
	pb_up.enabled = false
	pb_top.enabled = false
end if

end event

type cb_finished from commandbutton within w_treatment_list_change_sort_order
integer x = 2446
integer y = 1588
integer width = 402
integer height = 112
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
boolean default = true
end type

event clicked;close(parent)

end event

type cb_sort_by_description from commandbutton within w_treatment_list_change_sort_order
integer x = 2199
integer y = 1356
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

dw_treatments.setredraw(false)

dw_treatments.clear_selected()

dw_treatments.setsort("treatment_description")
dw_treatments.sort()

for i = 1 to dw_treatments.rowcount()
	dw_treatments.object.treatment_sort_sequence[i] = i
	if isnull(parent_definition_id) then
		dw_treatments.object.sort_parent_sort_sequence[i] = i
	end if
next

dw_treatments.setsort("sort_parent_sort_sequence, sort_parent_definition_id, parent_definition_id desc, treatment_sort_sequence, definition_id")
dw_treatments.sort()

dw_treatments.update()

dw_treatments.setredraw(true)

end event

type cb_sort_by_type from commandbutton within w_treatment_list_change_sort_order
integer x = 2199
integer y = 1188
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
boolean cancel = true
end type

event clicked;long i
string ls_sort

dw_treatments.setredraw(false)

dw_treatments.clear_selected()

dw_treatments.setsort("treatment_type_sort_sequence,treatment_description")
dw_treatments.sort()

for i = 1 to dw_treatments.rowcount()
	dw_treatments.object.treatment_sort_sequence[i] = i
	if isnull(parent_definition_id) then
		dw_treatments.object.sort_parent_sort_sequence[i] = i
	end if
next

dw_treatments.setsort("sort_parent_sort_sequence, sort_parent_definition_id, parent_definition_id desc, treatment_sort_sequence, definition_id")
dw_treatments.sort()

dw_treatments.update()

dw_treatments.setredraw(true)

end event

type dw_treatments from u_dw_pick_list within w_treatment_list_change_sort_order
integer x = 14
integer y = 108
integer width = 2062
integer height = 1704
integer taborder = 60
string dataobject = "dw_jmj_treatment_list"
boolean vscrollbar = true
boolean border = false
end type

event selected;if selected_row > 1 then
	pb_top.enabled = true
	pb_up.enabled = true
else
	pb_top.enabled = false
	pb_up.enabled = false
end if
	
if selected_row < rowcount() then
	pb_down.enabled = true
	pb_bottom.enabled = true
else
	pb_down.enabled = false
	pb_bottom.enabled = false
end if


end event

event unselected;call super::unselected;pb_top.enabled = false
pb_up.enabled = false
pb_down.enabled = false
pb_bottom.enabled = false

end event

type st_title from statictext within w_treatment_list_change_sort_order
integer width = 2930
integer height = 112
integer textsize = -18
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

