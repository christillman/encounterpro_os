$PBExportHeader$w_standard_exams.srw
forward
global type w_standard_exams from w_window_base
end type
type pb_done from u_picture_button within w_standard_exams
end type
type pb_cancel from u_picture_button within w_standard_exams
end type
type dw_exam_selection from u_dw_pick_list within w_standard_exams
end type
type st_page from statictext within w_standard_exams
end type
type st_personal_exams from statictext within w_standard_exams
end type
type st_common_exams from statictext within w_standard_exams
end type
type st_title from statictext within w_standard_exams
end type
type cb_add_exam from commandbutton within w_standard_exams
end type
type st_treatment_type_title from statictext within w_standard_exams
end type
type st_treatment_type from statictext within w_standard_exams
end type
type pb_page_down from u_picture_button within w_standard_exams
end type
type pb_page_up from u_picture_button within w_standard_exams
end type
end forward

global type w_standard_exams from w_window_base
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
pb_done pb_done
pb_cancel pb_cancel
dw_exam_selection dw_exam_selection
st_page st_page
st_personal_exams st_personal_exams
st_common_exams st_common_exams
st_title st_title
cb_add_exam cb_add_exam
st_treatment_type_title st_treatment_type_title
st_treatment_type st_treatment_type
pb_page_down pb_page_down
pb_page_up pb_page_up
end type
global w_standard_exams w_standard_exams

type variables
string treatment_type
string root_observation_id
string exam_list_user_id
string disabled_flag

end variables

forward prototypes
public subroutine move_row (long pl_row)
public function long create_new_exam ()
public subroutine exam_menu (integer pl_row)
end prototypes

public subroutine move_row (long pl_row);str_popup popup
long i
long ll_row


for i = 1 to dw_exam_selection.rowcount()
	dw_exam_selection.object.sort_sequence[i] = i
next

if pl_row <= 0 then return

ll_row = dw_exam_selection.get_selected_row()
if ll_row <> pl_row then
	dw_exam_selection.clear_selected()
	dw_exam_selection.object.selected_flag[pl_row] = 1
end if

popup.objectparm = dw_exam_selection

openwithparm(w_pick_list_sort, popup)

dw_exam_selection.update()

return

end subroutine

public function long create_new_exam ();str_popup popup
long ll_exam_sequence
str_popup_return popup_return

popup.title = "Enter Description for New Exam"
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0
if trim(popup_return.items[1]) = "" then return 0

ll_exam_sequence = datalist.new_exam(popup_return.items[1], root_observation_id)

return ll_exam_sequence




end function

public subroutine exam_menu (integer pl_row);str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons
string ls_user_id
integer li_update_flag
string ls_observation_id
string ls_temp

// Make sure user has appropriate privileges
if exam_list_user_id = current_user.specialty_id and not current_user.check_privilege("Common Exams") then return

if disabled_flag <> "Y" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button10.bmp"
	popup.button_helps[popup.button_count] = "Select Standard Exam"
	popup.button_titles[popup.button_count] = "Select Exam"
	buttons[popup.button_count] = "SELECT"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit Standard Exam Criteria"
	popup.button_titles[popup.button_count] = "Criteria"
	buttons[popup.button_count] = "CRITERIA"
end if
	
if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	if exam_list_user_id = current_user.specialty_id then
		popup.button_helps[popup.button_count] = "Remove Standard Exam From Common List"
	else
		popup.button_helps[popup.button_count] = "Remove Standard Exam From Personal List"
	end if
	popup.button_titles[popup.button_count] = "Remove Exam"
	buttons[popup.button_count] = "REMOVE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonmove.bmp"
	popup.button_helps[popup.button_count] = "Move record up or down"
	popup.button_titles[popup.button_count] = "Move"
	buttons[popup.button_count] = "MOVE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

button_pressed = 0

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	button_pressed = message.doubleparm
	if button_pressed < 1 or button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	button_pressed = 1
end if

dw_exam_selection.clear_selected()

if button_pressed <= 0 then return

CHOOSE CASE buttons[button_pressed]
	CASE "SELECT"
		popup_return.item_count = 1
		popup_return.items[1] = string(dw_exam_selection.object.exam_sequence[pl_row])
		closewithreturn(this, popup_return)
		return
	CASE "REMOVE"
		ls_temp = "Remove " + string(dw_exam_selection.object.exam_description[pl_row]) + "?"
		openwithparm(w_pop_ok, ls_temp)
		if message.doubleparm = 1 then
			dw_exam_selection.deleterow(pl_row)
			dw_exam_selection.update()
		end if
	CASE "CRITERIA"
		popup.data_row_count = 3
		popup.items[1] = string(dw_exam_selection.object.age_range_id[pl_row])
		popup.items[2] = string(dw_exam_selection.object.sex[pl_row])
		popup.items[3] = string(dw_exam_selection.object.race[pl_row])
		popup.title = string(dw_exam_selection.object.exam_description[pl_row])
		openwithparm(w_exam_selection_criteria, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 3 then return
		dw_exam_selection.object.age_range_id[pl_row] = long(popup_return.items[1])
		dw_exam_selection.object.age_range_description[pl_row] = popup_return.descriptions[1]
		dw_exam_selection.object.sex[pl_row] = popup_return.items[2]
		dw_exam_selection.object.race[pl_row] = popup_return.items[3]
		dw_exam_selection.update()
	CASE "MOVE"
		move_row(pl_row)
	CASE "CANCEL"
	CASE ELSE
END CHOOSE

return

end subroutine

on w_standard_exams.create
int iCurrent
call super::create
this.pb_done=create pb_done
this.pb_cancel=create pb_cancel
this.dw_exam_selection=create dw_exam_selection
this.st_page=create st_page
this.st_personal_exams=create st_personal_exams
this.st_common_exams=create st_common_exams
this.st_title=create st_title
this.cb_add_exam=create cb_add_exam
this.st_treatment_type_title=create st_treatment_type_title
this.st_treatment_type=create st_treatment_type
this.pb_page_down=create pb_page_down
this.pb_page_up=create pb_page_up
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_done
this.Control[iCurrent+2]=this.pb_cancel
this.Control[iCurrent+3]=this.dw_exam_selection
this.Control[iCurrent+4]=this.st_page
this.Control[iCurrent+5]=this.st_personal_exams
this.Control[iCurrent+6]=this.st_common_exams
this.Control[iCurrent+7]=this.st_title
this.Control[iCurrent+8]=this.cb_add_exam
this.Control[iCurrent+9]=this.st_treatment_type_title
this.Control[iCurrent+10]=this.st_treatment_type
this.Control[iCurrent+11]=this.pb_page_down
this.Control[iCurrent+12]=this.pb_page_up
end on

on w_standard_exams.destroy
call super::destroy
destroy(this.pb_done)
destroy(this.pb_cancel)
destroy(this.dw_exam_selection)
destroy(this.st_page)
destroy(this.st_personal_exams)
destroy(this.st_common_exams)
destroy(this.st_title)
destroy(this.cb_add_exam)
destroy(this.st_treatment_type_title)
destroy(this.st_treatment_type)
destroy(this.pb_page_down)
destroy(this.pb_page_up)
end on

event open;call super::open;str_popup popup
str_popup_return popup_return
string ls_description
long ll_rows

popup_return.item_count = 0

popup = message.powerobjectparm

if popup.data_row_count <> 3 then
	log.log(this, "open", "Invalid Parameters", 4)
	closewithreturn(this, popup_return)
	return
end if

treatment_type = popup.items[1]
root_observation_id = popup.items[2]
disabled_flag = popup.items[3]

ls_description = datalist.observation_description(root_observation_id)
if isnull(ls_description) then
	log.log(this, "open", "Invalid Root Observation Id (" + root_observation_id + ")", 4)
	closewithreturn(this, popup_return)
	return
end if
	
st_title.text = "Standard Exams for " + ls_description

ls_description = datalist.treatment_type_description(treatment_type)
if isnull(ls_description) then
	log.log(this, "open", "Invalid Treatment Type (" + treatment_type + ")", 4)
	closewithreturn(this, popup_return)
	return
end if

st_treatment_type.text = ls_description

exam_list_user_id = current_user.user_id
dw_exam_selection.settransobject(sqlca)
st_common_exams.backcolor = color_object
st_personal_exams.backcolor = color_object_selected
ll_rows = dw_exam_selection.retrieve(root_observation_id, treatment_type, exam_list_user_id)
dw_exam_selection.set_page(1, pb_page_up, pb_page_down, st_page)

end event

type pb_epro_help from w_window_base`pb_epro_help within w_standard_exams
boolean visible = true
integer x = 2647
integer y = 156
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_standard_exams
end type

type pb_done from u_picture_button within w_standard_exams
integer x = 2629
integer y = 1488
boolean originalsize = false
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

type pb_cancel from u_picture_button within w_standard_exams
boolean visible = false
integer x = 2126
integer y = 1716
boolean bringtotop = true
boolean cancel = true
boolean originalsize = false
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

type dw_exam_selection from u_dw_pick_list within w_standard_exams
integer x = 41
integer y = 136
integer width = 2053
integer height = 1560
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_exam_selection"
boolean border = false
end type

event selected;exam_menu(selected_row)

end event

type st_page from statictext within w_standard_exams
integer x = 2235
integer y = 144
integer width = 293
integer height = 56
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Page 99 of 99"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_personal_exams from statictext within w_standard_exams
integer x = 2208
integer y = 752
integer width = 590
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Personal Exams"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_common_exams.backcolor = color_object
backcolor = color_object_selected
exam_list_user_id = current_user.user_id

dw_exam_selection.retrieve(root_observation_id, treatment_type, exam_list_user_id)
dw_exam_selection.set_page(1, pb_page_up, pb_page_down, st_page)

cb_add_exam.visible = true

end event

type st_common_exams from statictext within w_standard_exams
integer x = 2208
integer y = 928
integer width = 590
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Common Exams"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_personal_exams.backcolor = color_object
backcolor = color_object_selected
exam_list_user_id = current_user.specialty_id

dw_exam_selection.retrieve(root_observation_id, treatment_type, exam_list_user_id)
dw_exam_selection.set_page(1, pb_page_up, pb_page_down, st_page)

if current_user.check_privilege("Common Exams") then
	cb_add_exam.visible = true
else
	cb_add_exam.visible = false
end if

end event

type st_title from statictext within w_standard_exams
integer width = 2921
integer height = 112
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Standard Exams"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_add_exam from commandbutton within w_standard_exams
integer x = 2181
integer y = 1256
integer width = 645
integer height = 112
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add Standard Exam"
end type

event clicked;str_popup popup
str_popup_return popup_return
u_user luo_user
long ll_row
long ll_exam_sequence
string ls_description

popup.dataobject = "dw_exam_pick_by_root"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = root_observation_id
popup.add_blank_row = true
popup.blank_text = "<Create New Exam>"

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	ll_exam_sequence = create_new_exam()
	ls_description = datalist.exam_description(ll_exam_sequence)
else
	ll_exam_sequence = long(popup_return.items[1])
	ls_description = popup_return.descriptions[1]
end if

if isnull(ll_exam_sequence) or ll_exam_sequence <= 0 then return

ll_row = dw_exam_selection.insertrow(0)
dw_exam_selection.object.exam_sequence[ll_row] = ll_exam_sequence
dw_exam_selection.object.exam_description[ll_row] = ls_description
dw_exam_selection.object.treatment_type[ll_row] = treatment_type
dw_exam_selection.object.user_id[ll_row] = exam_list_user_id
dw_exam_selection.object.treatment_type_icon[ll_row] = datalist.treatment_type_icon(treatment_type)
dw_exam_selection.object.sort_sequence[ll_row] = ll_row

dw_exam_selection.update()

dw_exam_selection.scrolltorow(ll_row)
dw_exam_selection.recalc_page(pb_page_up, pb_page_down, st_page)

end event

type st_treatment_type_title from statictext within w_standard_exams
integer x = 2126
integer y = 460
integer width = 750
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Treatment Type"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_treatment_type from statictext within w_standard_exams
integer x = 2126
integer y = 536
integer width = 750
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Physical Exam"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type pb_page_down from u_picture_button within w_standard_exams
integer x = 2089
integer y = 276
integer width = 137
integer height = 116
integer taborder = 40
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;string ls_temp

dw_exam_selection.set_page(dw_exam_selection.current_page + 1, st_page.text)
if dw_exam_selection.current_page >= dw_exam_selection.last_page then
	enabled = false
end if

pb_page_up.enabled = true

end event

type pb_page_up from u_picture_button within w_standard_exams
integer x = 2089
integer y = 144
integer width = 137
integer height = 116
integer taborder = 50
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;string ls_temp

dw_exam_selection.set_page(dw_exam_selection.current_page - 1, st_page.text)
if dw_exam_selection.current_page < 2 then
	enabled = false
end if

pb_page_down.enabled = true

end event

