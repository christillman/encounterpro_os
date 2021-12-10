$PBExportHeader$w_encounter_type_definition.srw
forward
global type w_encounter_type_definition from w_window_base
end type
type sle_description from singlelineedit within w_encounter_type_definition
end type
type st_1 from statictext within w_encounter_type_definition
end type
type st_title from statictext within w_encounter_type_definition
end type
type st_results from statictext within w_encounter_type_definition
end type
type dw_selection from u_dw_pick_list within w_encounter_type_definition
end type
type st_step_desc_title from statictext within w_encounter_type_definition
end type
type st_step_room_title from statictext within w_encounter_type_definition
end type
type cb_add_workplan from commandbutton within w_encounter_type_definition
end type
type cb_change_description from commandbutton within w_encounter_type_definition
end type
type st_encounter_mode from statictext within w_encounter_type_definition
end type
type st_mode_title from statictext within w_encounter_type_definition
end type
type st_bill_flag from statictext within w_encounter_type_definition
end type
type st_bill_flag_title from statictext within w_encounter_type_definition
end type
type st_selection_title from statictext within w_encounter_type_definition
end type
type st_sex_title from statictext within w_encounter_type_definition
end type
type pb_up from u_picture_button within w_encounter_type_definition
end type
type pb_down from u_picture_button within w_encounter_type_definition
end type
type st_page from statictext within w_encounter_type_definition
end type
type st_em_code_group_title from statictext within w_encounter_type_definition
end type
type st_em_code_group from statictext within w_encounter_type_definition
end type
type st_close_workplan_title from statictext within w_encounter_type_definition
end type
type st_close_encounter_workplan from statictext within w_encounter_type_definition
end type
type cb_finished from commandbutton within w_encounter_type_definition
end type
type cb_cancel from commandbutton within w_encounter_type_definition
end type
end forward

global type w_encounter_type_definition from w_window_base
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
sle_description sle_description
st_1 st_1
st_title st_title
st_results st_results
dw_selection dw_selection
st_step_desc_title st_step_desc_title
st_step_room_title st_step_room_title
cb_add_workplan cb_add_workplan
cb_change_description cb_change_description
st_encounter_mode st_encounter_mode
st_mode_title st_mode_title
st_bill_flag st_bill_flag
st_bill_flag_title st_bill_flag_title
st_selection_title st_selection_title
st_sex_title st_sex_title
pb_up pb_up
pb_down pb_down
st_page st_page
st_em_code_group_title st_em_code_group_title
st_em_code_group st_em_code_group
st_close_workplan_title st_close_workplan_title
st_close_encounter_workplan st_close_encounter_workplan
cb_finished cb_finished
cb_cancel cb_cancel
end type
global w_encounter_type_definition w_encounter_type_definition

type variables
string encounter_type
boolean changed = false
string bill_flag
string visit_code_group
long close_encounter_workplan_id
end variables

forward prototypes
public function integer save_changes ()
public function integer load_encounter_type ()
public subroutine selection_menu (long pl_row)
end prototypes

public function integer save_changes ();integer li_sts

if changed then
	UPDATE c_Encounter_Type
	SET description = :sle_description.text,
		bill_flag = :bill_flag,
		visit_code_group = :visit_code_group,
		close_encounter_workplan_id = :close_encounter_workplan_id
	WHERE encounter_type = :encounter_type;
	if not tf_check() then return -1
end if

li_sts = dw_selection.update()
if li_sts <= 0 then return -1


return 1

end function

public function integer load_encounter_type ();long ll_count
long i
string ls_room_name
string ls_room_id
string ls_default_indirect_flag

SELECT bill_flag,
		description,
		default_indirect_flag,
		visit_code_group,
		close_encounter_workplan_id
INTO :bill_flag,
		:sle_description.text,
		:ls_default_indirect_flag, 
		:visit_code_group,
		:close_encounter_workplan_id
FROM c_Encounter_Type
WHERE encounter_type = :encounter_type;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then
	log.log(this, "w_encounter_type_definition.load_encounter_type:0021", "encounter_type not found (" + encounter_type + ")", 4)
	return -1
end if

ll_count = dw_selection.retrieve(encounter_type)
dw_selection.set_page(1, pb_up, pb_down, st_page)

if bill_flag = "Y" then
	st_bill_flag.text = "Yes"
else
	st_bill_flag.text = "No"
end if

if ls_default_indirect_flag = "D" then
	st_encounter_mode.text = "Direct"
elseif ls_default_indirect_flag = "I" then
	st_encounter_mode.text = "Indrect"
else
	st_encounter_mode.text = "Other"
end if

if isnull(visit_code_group) then
	st_em_code_group.text = "N/A"
else
	SELECT description
	INTO :st_em_code_group.text
	FROM em_visit_code_group
	WHERE visit_code_group = :visit_code_group;
	if not tf_check() then return -1
end if

if isnull(close_encounter_workplan_id) then
	st_close_encounter_workplan.text = "N/A"
else
	SELECT description
	INTO :st_close_encounter_workplan.text
	FROM c_Workplan
	WHERE workplan_id = :close_encounter_workplan_id;
	if not tf_check() then return -1
	if sqlca.sqlcode = 100 then
		st_close_encounter_workplan.text = "<Unknown " + string(close_encounter_workplan_id) + ">"
	end if
end if

return 1

end function

public subroutine selection_menu (long pl_row);long ll_count
str_popup popup
str_popup_return popup_return
string lsa_buttons[]
integer li_button_pressed, li_sts, li_service_count
window lw_pop_buttons
string ls_user_id
integer li_update_flag
long ll_workplan_selection_id
long ll_workplan_id
string ls_temp
long i
integer li_search_order
w_window_base lw_workplan_definition_display

ll_workplan_selection_id = dw_selection.object.workplan_selection_id[pl_row]
ll_workplan_id = dw_selection.object.workplan_id[pl_row]

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_workflow.bmp"
	popup.button_helps[popup.button_count] = "Edit Workplan"
	popup.button_titles[popup.button_count] = "Edit Workplan"
	lsa_buttons[popup.button_count] = "WORKPLAN"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit Workplan Selection Criteria"
	popup.button_titles[popup.button_count] = "Edit Criteria"
	lsa_buttons[popup.button_count] = "EDIT"
end if

if pl_row > 1 then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonup.bmp"
	popup.button_helps[popup.button_count] = "Move Workplan Selection Rule Up"
	popup.button_titles[popup.button_count] = "Move Up"
	lsa_buttons[popup.button_count] = "UP"
end if

if pl_row < dw_selection.rowcount() then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttondn.bmp"
	popup.button_helps[popup.button_count] = "Move Workplan Selection Rule Down"
	popup.button_titles[popup.button_count] = "Move Down"
	lsa_buttons[popup.button_count] = "DOWN"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Remove Workplan Selection"
	popup.button_titles[popup.button_count] = "Remove Workplan"
	lsa_buttons[popup.button_count] = "REMOVE"
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
	li_button_pressed = message.doubleparm
	if li_button_pressed < 1 or li_button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	li_button_pressed = 1
else
	return
end if

CHOOSE CASE lsa_buttons[li_button_pressed]
	CASE "WORKPLAN"
		popup.items[1] = string(ll_workplan_id)
		popup.data_row_count = 1
		openwithparm(lw_workplan_definition_display, popup,"w_workplan_definition_display")

		ll_count = dw_selection.retrieve(encounter_type)
		dw_selection.set_page(1, pb_up, pb_down, st_page)
	CASE "EDIT"
		popup.data_row_count = 3
		popup.items[1] = dw_selection.object.new_flag[pl_row]
		popup.items[2] = dw_selection.object.sex[pl_row]
		popup.items[3] = string(long(dw_selection.object.age_range_id[pl_row]))
		openwithparm(w_encounter_workplan_criteria, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count < 3 then return
		dw_selection.object.new_flag[pl_row] = popup_return.items[1]
		dw_selection.object.sex[pl_row] = popup_return.items[2]
		dw_selection.object.age_range_id[pl_row] = long(popup_return.items[3])
		dw_selection.object.age_range_description[pl_row] = popup_return.descriptions[3]
	CASE "UP"
		li_search_order = dw_selection.object.search_order[pl_row]
		dw_selection.object.search_order[pl_row] = dw_selection.object.search_order[pl_row - 1]
		dw_selection.object.search_order[pl_row - 1] = li_search_order
		dw_selection.sort()
	CASE "DOWN"
		li_search_order = dw_selection.object.search_order[pl_row]
		dw_selection.object.search_order[pl_row] = dw_selection.object.search_order[pl_row + 1]
		dw_selection.object.search_order[pl_row + 1] = li_search_order
		dw_selection.sort()
	CASE "REMOVE"
		ls_temp = "Are you sure you wish to remove this workplan?"
		openwithparm(w_pop_yes_no, ls_temp)
		popup_return = message.powerobjectparm
		if popup_return.item = "YES" then
			dw_selection.deleterow(pl_row)
		end if
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return


end subroutine

event open;call super::open;str_popup popup
integer li_sts

popup = message.powerobjectparm

dw_selection.settransobject(sqlca)

if popup.data_row_count <> 1 then
	log.log(this, "w_encounter_type_definition:open", "Invalid parameters", 4)
	close(this)
	return
end if

encounter_type = popup.items[1]

if isnull(encounter_type) then
	log.log(this, "w_encounter_type_definition:open", "Null encounter_type", 4)
	close(this)
	return
end if

li_sts = load_encounter_type()
if li_sts <= 0 then
	log.log(this, "w_encounter_type_definition:open", "Error loading encounter_type (" + encounter_type + ")", 4)
	close(this)
	return
end if


end event

on w_encounter_type_definition.create
int iCurrent
call super::create
this.sle_description=create sle_description
this.st_1=create st_1
this.st_title=create st_title
this.st_results=create st_results
this.dw_selection=create dw_selection
this.st_step_desc_title=create st_step_desc_title
this.st_step_room_title=create st_step_room_title
this.cb_add_workplan=create cb_add_workplan
this.cb_change_description=create cb_change_description
this.st_encounter_mode=create st_encounter_mode
this.st_mode_title=create st_mode_title
this.st_bill_flag=create st_bill_flag
this.st_bill_flag_title=create st_bill_flag_title
this.st_selection_title=create st_selection_title
this.st_sex_title=create st_sex_title
this.pb_up=create pb_up
this.pb_down=create pb_down
this.st_page=create st_page
this.st_em_code_group_title=create st_em_code_group_title
this.st_em_code_group=create st_em_code_group
this.st_close_workplan_title=create st_close_workplan_title
this.st_close_encounter_workplan=create st_close_encounter_workplan
this.cb_finished=create cb_finished
this.cb_cancel=create cb_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_description
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_title
this.Control[iCurrent+4]=this.st_results
this.Control[iCurrent+5]=this.dw_selection
this.Control[iCurrent+6]=this.st_step_desc_title
this.Control[iCurrent+7]=this.st_step_room_title
this.Control[iCurrent+8]=this.cb_add_workplan
this.Control[iCurrent+9]=this.cb_change_description
this.Control[iCurrent+10]=this.st_encounter_mode
this.Control[iCurrent+11]=this.st_mode_title
this.Control[iCurrent+12]=this.st_bill_flag
this.Control[iCurrent+13]=this.st_bill_flag_title
this.Control[iCurrent+14]=this.st_selection_title
this.Control[iCurrent+15]=this.st_sex_title
this.Control[iCurrent+16]=this.pb_up
this.Control[iCurrent+17]=this.pb_down
this.Control[iCurrent+18]=this.st_page
this.Control[iCurrent+19]=this.st_em_code_group_title
this.Control[iCurrent+20]=this.st_em_code_group
this.Control[iCurrent+21]=this.st_close_workplan_title
this.Control[iCurrent+22]=this.st_close_encounter_workplan
this.Control[iCurrent+23]=this.cb_finished
this.Control[iCurrent+24]=this.cb_cancel
end on

on w_encounter_type_definition.destroy
call super::destroy
destroy(this.sle_description)
destroy(this.st_1)
destroy(this.st_title)
destroy(this.st_results)
destroy(this.dw_selection)
destroy(this.st_step_desc_title)
destroy(this.st_step_room_title)
destroy(this.cb_add_workplan)
destroy(this.cb_change_description)
destroy(this.st_encounter_mode)
destroy(this.st_mode_title)
destroy(this.st_bill_flag)
destroy(this.st_bill_flag_title)
destroy(this.st_selection_title)
destroy(this.st_sex_title)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.st_page)
destroy(this.st_em_code_group_title)
destroy(this.st_em_code_group)
destroy(this.st_close_workplan_title)
destroy(this.st_close_encounter_workplan)
destroy(this.cb_finished)
destroy(this.cb_cancel)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_encounter_type_definition
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_encounter_type_definition
end type

type sle_description from singlelineedit within w_encounter_type_definition
integer x = 142
integer y = 264
integer width = 2368
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean displayonly = true
end type

type st_1 from statictext within w_encounter_type_definition
integer x = 142
integer y = 180
integer width = 398
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Description:"
boolean focusrectangle = false
end type

type st_title from statictext within w_encounter_type_definition
integer width = 2926
integer height = 144
boolean bringtotop = true
integer textsize = -24
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Encounter Type Definition"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_results from statictext within w_encounter_type_definition
integer x = 160
integer y = 800
integer width = 270
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Workplan"
boolean focusrectangle = false
end type

type dw_selection from u_dw_pick_list within w_encounter_type_definition
integer x = 142
integer y = 872
integer width = 2569
integer height = 608
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_encounter_type_workplan_selection"
boolean vscrollbar = true
end type

event selected;call super::selected;selection_menu(selected_row)
clear_selected()

end event

type st_step_desc_title from statictext within w_encounter_type_definition
integer x = 2313
integer y = 800
integer width = 183
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Stage"
boolean focusrectangle = false
end type

type st_step_room_title from statictext within w_encounter_type_definition
integer x = 1595
integer y = 800
integer width = 238
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "New/Est"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_add_workplan from commandbutton within w_encounter_type_definition
integer x = 1243
integer y = 1496
integer width = 443
integer height = 108
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add Workplan"
end type

event clicked;long ll_row
string ls_indirect_flag
str_c_workplan lstr_workplan
w_pick_workplan lw_window
str_workplan_context lstr_workplan_context

lstr_workplan_context.context_object = "Encounter"
lstr_workplan_context.in_office_flag = "?" // Let the user pick

openwithparm(lw_window, lstr_workplan_context, "w_pick_workplan")
lstr_workplan = message.powerobjectparm
if isnull(lstr_workplan.workplan_id) then return

ll_row = dw_selection.insertrow(0)
dw_selection.object.workplan_id[ll_row] = lstr_workplan.workplan_id
dw_selection.object.workplan_description[ll_row] = lstr_workplan.description
dw_selection.object.encounter_type[ll_row] = encounter_type
if ll_row = 1 then
	dw_selection.object.search_order[ll_row] = 1
else
	dw_selection.object.search_order[ll_row] = dw_selection.object.search_order[ll_row - 1] + 1
end if

dw_selection.recalc_page(pb_up, pb_down, st_page)

end event

type cb_change_description from commandbutton within w_encounter_type_definition
integer x = 2537
integer y = 268
integer width = 256
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Change"
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.title = "Enter new Encounter Type description"
popup.item = sle_description.text

openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

sle_description.text = popup_return.items[1]
changed = true

end event

type st_encounter_mode from statictext within w_encounter_type_definition
event clicked pbm_bnclicked
integer x = 608
integer y = 396
integer width = 402
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_mode_title from statictext within w_encounter_type_definition
integer x = 91
integer y = 412
integer width = 503
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Encounter Mode:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_bill_flag from statictext within w_encounter_type_definition
event clicked pbm_bnclicked
integer x = 608
integer y = 536
integer width = 402
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if bill_flag = "Y" then
	bill_flag = "N"
	text = "No"
else
	bill_flag = "Y"
	text = "Yes"
end if

changed = true

end event

type st_bill_flag_title from statictext within w_encounter_type_definition
integer x = 91
integer y = 552
integer width = 503
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Bill Encounter:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_selection_title from statictext within w_encounter_type_definition
integer x = 1029
integer y = 696
integer width = 791
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 7191717
boolean enabled = false
string text = "Workplan Selection"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_sex_title from statictext within w_encounter_type_definition
integer x = 1925
integer y = 800
integer width = 119
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Sex"
boolean focusrectangle = false
end type

type pb_up from u_picture_button within w_encounter_type_definition
integer x = 2729
integer y = 868
integer width = 137
integer height = 116
integer taborder = 40
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;integer li_page

li_page = dw_selection.current_page

dw_selection.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from u_picture_button within w_encounter_type_definition
integer x = 2729
integer y = 1000
integer width = 137
integer height = 116
integer taborder = 40
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;integer li_page
integer li_last_page

li_page = dw_selection.current_page
li_last_page = dw_selection.last_page

dw_selection.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type st_page from statictext within w_encounter_type_definition
integer x = 2587
integer y = 800
integer width = 288
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
string text = "Page 99/99"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_em_code_group_title from statictext within w_encounter_type_definition
integer x = 1339
integer y = 412
integer width = 503
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "EM Code Group:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_em_code_group from statictext within w_encounter_type_definition
integer x = 1865
integer y = 396
integer width = 919
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_em_visit_code_group"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.add_blank_row = true
popup.blank_text = "N/A"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	setnull(visit_code_group)
	text = "N/A"
else
	visit_code_group = popup_return.items[1]
	text = popup_return.descriptions[1]
end if

changed = true

end event

type st_close_workplan_title from statictext within w_encounter_type_definition
integer x = 1339
integer y = 552
integer width = 503
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Close Workplan:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_close_encounter_workplan from statictext within w_encounter_type_definition
integer x = 1865
integer y = 536
integer width = 919
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_office_workplan_of_type_pick"
popup.title = "Select Workplan"
popup.datacolumn = 1
popup.displaycolumn = 3
popup.add_blank_row = true
popup.blank_text = "N/A"
popup.argument_count = 2
popup.argument[1] = "Patient"
popup.argument[2] = "N"

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	setnull(close_encounter_workplan_id)
else
	close_encounter_workplan_id = long(popup_return.items[1])
end if

text = popup_return.descriptions[1]

changed = true

end event

type cb_finished from commandbutton within w_encounter_type_definition
integer x = 2441
integer y = 1656
integer width = 402
integer height = 112
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
boolean default = true
end type

event clicked;str_popup_return popup_return
integer li_sts

li_sts = save_changes()
if li_sts <= 0 then return

popup_return.item_count = 1
popup_return.items[1] = string(dw_selection.rowcount())
popup_return.descriptions[1] = sle_description.text

closewithreturn(parent, popup_return)


end event

type cb_cancel from commandbutton within w_encounter_type_definition
integer x = 69
integer y = 1656
integer width = 402
integer height = 112
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
end type

event clicked;str_popup_return popup_return

setnull(popup_return.item)
popup_return.item_count = 0
closewithreturn(parent, popup_return)


end event

