HA$PBExportHeader$w_svc_config_encounter_type.srw
forward
global type w_svc_config_encounter_type from w_window_base
end type
type st_title from statictext within w_svc_config_encounter_type
end type
type cb_finished from commandbutton within w_svc_config_encounter_type
end type
type tab_encounter_type from u_tab_encounter_type_definition within w_svc_config_encounter_type
end type
type tab_encounter_type from u_tab_encounter_type_definition within w_svc_config_encounter_type
end type
end forward

global type w_svc_config_encounter_type from w_window_base
boolean titlebar = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_title st_title
cb_finished cb_finished
tab_encounter_type tab_encounter_type
end type
global w_svc_config_encounter_type w_svc_config_encounter_type

type variables
u_component_service service
string encounter_type

end variables

forward prototypes
public function integer save_changes ()
public subroutine selection_menu (long pl_row)
end prototypes

public function integer save_changes ();//integer li_sts
//
//if changed then
//	UPDATE c_Encounter_Type
//	SET description = :sle_description.text,
//		bill_flag = :bill_flag,
//		visit_code_group = :visit_code_group,
//		close_encounter_workplan_id = :close_encounter_workplan_id
//	WHERE encounter_type = :encounter_type;
//	if not tf_check() then return -1
//end if
//
//li_sts = dw_selection.update()
//if li_sts <= 0 then return -1
//
//
return 1

end function

public subroutine selection_menu (long pl_row);//long ll_count
//str_popup popup
//str_popup_return popup_return
//string lsa_buttons[]
//integer li_button_pressed, li_sts, li_service_count
//window lw_pop_buttons
//string ls_user_id
//integer li_update_flag
//long ll_workplan_selection_id
//long ll_workplan_id
//string ls_temp
//long i
//integer li_search_order
//w_window_base lw_workplan_definition_display
//
//ll_workplan_selection_id = dw_selection.object.workplan_selection_id[pl_row]
//ll_workplan_id = dw_selection.object.workplan_id[pl_row]
//
//if true then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button_workflow.bmp"
//	popup.button_helps[popup.button_count] = "Edit Workplan"
//	popup.button_titles[popup.button_count] = "Edit Workplan"
//	lsa_buttons[popup.button_count] = "WORKPLAN"
//end if
//
//if true then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button17.bmp"
//	popup.button_helps[popup.button_count] = "Edit Workplan Selection Criteria"
//	popup.button_titles[popup.button_count] = "Edit Criteria"
//	lsa_buttons[popup.button_count] = "EDIT"
//end if
//
//if pl_row > 1 then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "buttonup.bmp"
//	popup.button_helps[popup.button_count] = "Move Workplan Selection Rule Up"
//	popup.button_titles[popup.button_count] = "Move Up"
//	lsa_buttons[popup.button_count] = "UP"
//end if
//
//if pl_row < dw_selection.rowcount() then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "buttondn.bmp"
//	popup.button_helps[popup.button_count] = "Move Workplan Selection Rule Down"
//	popup.button_titles[popup.button_count] = "Move Down"
//	lsa_buttons[popup.button_count] = "DOWN"
//end if
//
//if true then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button13.bmp"
//	popup.button_helps[popup.button_count] = "Remove Workplan Selection"
//	popup.button_titles[popup.button_count] = "Remove Workplan"
//	lsa_buttons[popup.button_count] = "REMOVE"
//end if
//
//if true then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button11.bmp"
//	popup.button_helps[popup.button_count] = "Cancel"
//	popup.button_titles[popup.button_count] = "Cancel"
//	lsa_buttons[popup.button_count] = "CANCEL"
//end if
//
//popup.button_titles_used = true
//
//if popup.button_count > 1 then
//	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
//	li_button_pressed = message.doubleparm
//	if li_button_pressed < 1 or li_button_pressed > popup.button_count then return
//elseif popup.button_count = 1 then
//	li_button_pressed = 1
//else
//	return
//end if
//
//CHOOSE CASE lsa_buttons[li_button_pressed]
//	CASE "WORKPLAN"
//		popup.items[1] = string(ll_workplan_id)
//		popup.data_row_count = 1
//		openwithparm(lw_workplan_definition_display, popup,"w_workplan_definition_display")
//
//		ll_count = dw_selection.retrieve(encounter_type)
//		dw_selection.set_page(1, pb_up, pb_down, st_page)
//	CASE "EDIT"
//		popup.data_row_count = 3
//		popup.items[1] = dw_selection.object.new_flag[pl_row]
//		popup.items[2] = dw_selection.object.sex[pl_row]
//		popup.items[3] = string(long(dw_selection.object.age_range_id[pl_row]))
//		openwithparm(w_encounter_workplan_criteria, popup)
//		popup_return = message.powerobjectparm
//		if popup_return.item_count < 3 then return
//		dw_selection.object.new_flag[pl_row] = popup_return.items[1]
//		dw_selection.object.sex[pl_row] = popup_return.items[2]
//		dw_selection.object.age_range_id[pl_row] = long(popup_return.items[3])
//		dw_selection.object.age_range_description[pl_row] = popup_return.descriptions[3]
//	CASE "UP"
//		li_search_order = dw_selection.object.search_order[pl_row]
//		dw_selection.object.search_order[pl_row] = dw_selection.object.search_order[pl_row - 1]
//		dw_selection.object.search_order[pl_row - 1] = li_search_order
//		dw_selection.sort()
//	CASE "DOWN"
//		li_search_order = dw_selection.object.search_order[pl_row]
//		dw_selection.object.search_order[pl_row] = dw_selection.object.search_order[pl_row + 1]
//		dw_selection.object.search_order[pl_row + 1] = li_search_order
//		dw_selection.sort()
//	CASE "REMOVE"
//		ls_temp = "Are you sure you wish to remove this workplan?"
//		openwithparm(w_pop_yes_no, ls_temp)
//		popup_return = message.powerobjectparm
//		if popup_return.item = "YES" then
//			dw_selection.deleterow(pl_row)
//		end if
//	CASE "CANCEL"
//		return
//	CASE ELSE
//END CHOOSE
//
//return
//
//
end subroutine

event open;call super::open;integer li_sts

service = message.powerobjectparm

encounter_type = service.get_attribute("encounter_type")

if isnull(encounter_type) then
	log.log(this, "open", "Null encounter_type", 4)
	close(this)
	return
end if

cb_finished.x = width - cb_finished.width - 50
cb_finished.y = height - cb_finished.height - 50

tab_encounter_type.width = width
tab_encounter_type.height = cb_finished.y - tab_encounter_type.y - 50

li_sts = tab_encounter_type.initialize(encounter_type)
if li_sts <= 0 then
	log.log(this, "open", "Error loading encounter_type (" + encounter_type + ")", 4)
	close(this)
	return
end if


end event

on w_svc_config_encounter_type.create
int iCurrent
call super::create
this.st_title=create st_title
this.cb_finished=create cb_finished
this.tab_encounter_type=create tab_encounter_type
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.cb_finished
this.Control[iCurrent+3]=this.tab_encounter_type
end on

on w_svc_config_encounter_type.destroy
call super::destroy
destroy(this.st_title)
destroy(this.cb_finished)
destroy(this.tab_encounter_type)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_svc_config_encounter_type
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_config_encounter_type
end type

type st_title from statictext within w_svc_config_encounter_type
integer width = 2926
integer height = 144
boolean bringtotop = true
integer textsize = -24
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Encounter Type Definition"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_finished from commandbutton within w_svc_config_encounter_type
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

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)

end event

type tab_encounter_type from u_tab_encounter_type_definition within w_svc_config_encounter_type
integer y = 156
integer width = 2898
integer height = 1472
integer taborder = 20
boolean bringtotop = true
end type

