HA$PBExportHeader$u_tabpage_encounter_type_workplans.sru
forward
global type u_tabpage_encounter_type_workplans from u_tabpage
end type
type cb_add_workplan from commandbutton within u_tabpage_encounter_type_workplans
end type
type dw_selection from u_dw_pick_list within u_tabpage_encounter_type_workplans
end type
end forward

global type u_tabpage_encounter_type_workplans from u_tabpage
integer width = 3131
string text = "Workplans"
cb_add_workplan cb_add_workplan
dw_selection dw_selection
end type
global u_tabpage_encounter_type_workplans u_tabpage_encounter_type_workplans

type variables
string encounter_type
end variables

forward prototypes
public function integer initialize (string ps_key)
public subroutine refresh ()
public subroutine selection_menu (long pl_row)
end prototypes

public function integer initialize (string ps_key);encounter_type = ps_key

return 1

end function

public subroutine refresh ();

dw_selection.settransobject(sqlca)
dw_selection.retrieve(encounter_type)

end subroutine

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

on u_tabpage_encounter_type_workplans.create
int iCurrent
call super::create
this.cb_add_workplan=create cb_add_workplan
this.dw_selection=create dw_selection
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_add_workplan
this.Control[iCurrent+2]=this.dw_selection
end on

on u_tabpage_encounter_type_workplans.destroy
call super::destroy
destroy(this.cb_add_workplan)
destroy(this.dw_selection)
end on

type cb_add_workplan from commandbutton within u_tabpage_encounter_type_workplans
integer x = 1280
integer y = 1228
integer width = 443
integer height = 108
integer taborder = 20
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


end event

type dw_selection from u_dw_pick_list within u_tabpage_encounter_type_workplans
integer x = 23
integer y = 356
integer width = 2976
integer height = 608
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_encounter_type_workplan_selection"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;//selection_menu(selected_row)
//clear_selected()
//
end event

