$PBExportHeader$w_svc_encounter_coding.srw
forward
global type w_svc_encounter_coding from w_window_base
end type
type dw_history from u_dw_pick_list within w_svc_encounter_coding
end type
type dw_exam from u_dw_pick_list within w_svc_encounter_coding
end type
type dw_decision from u_dw_pick_list within w_svc_encounter_coding
end type
type st_history_title from statictext within w_svc_encounter_coding
end type
type st_exam_title from statictext within w_svc_encounter_coding
end type
type st_decision_title from statictext within w_svc_encounter_coding
end type
type cb_history_details from commandbutton within w_svc_encounter_coding
end type
type cb_exam_details from commandbutton within w_svc_encounter_coding
end type
type cb_decision_details from commandbutton within w_svc_encounter_coding
end type
type st_1 from statictext within w_svc_encounter_coding
end type
type st_2 from statictext within w_svc_encounter_coding
end type
type st_3 from statictext within w_svc_encounter_coding
end type
type st_calculated_visit_level from statictext within w_svc_encounter_coding
end type
type st_override from statictext within w_svc_encounter_coding
end type
type st_selected_visit_level from statictext within w_svc_encounter_coding
end type
type cb_done from commandbutton within w_svc_encounter_coding
end type
type cb_be_back from commandbutton within w_svc_encounter_coding
end type
type st_user_1 from statictext within w_svc_encounter_coding
end type
type st_user_2 from statictext within w_svc_encounter_coding
end type
type st_user_3 from statictext within w_svc_encounter_coding
end type
type st_user_4 from statictext within w_svc_encounter_coding
end type
type st_user_5 from statictext within w_svc_encounter_coding
end type
type st_calc_1 from statictext within w_svc_encounter_coding
end type
type st_calc_2 from statictext within w_svc_encounter_coding
end type
type st_calc_3 from statictext within w_svc_encounter_coding
end type
type st_calc_4 from statictext within w_svc_encounter_coding
end type
type st_calc_5 from statictext within w_svc_encounter_coding
end type
type st_title from statictext within w_svc_encounter_coding
end type
type st_documentation_guide from statictext within w_svc_encounter_coding
end type
type st_display_only from statictext within w_svc_encounter_coding
end type
type cb_rules from commandbutton within w_svc_encounter_coding
end type
type st_4 from statictext within w_svc_encounter_coding
end type
type dw_time_with_patient from u_dw_pick_list within w_svc_encounter_coding
end type
end forward

global type w_svc_encounter_coding from w_window_base
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
string button_type = "COMMAND"
dw_history dw_history
dw_exam dw_exam
dw_decision dw_decision
st_history_title st_history_title
st_exam_title st_exam_title
st_decision_title st_decision_title
cb_history_details cb_history_details
cb_exam_details cb_exam_details
cb_decision_details cb_decision_details
st_1 st_1
st_2 st_2
st_3 st_3
st_calculated_visit_level st_calculated_visit_level
st_override st_override
st_selected_visit_level st_selected_visit_level
cb_done cb_done
cb_be_back cb_be_back
st_user_1 st_user_1
st_user_2 st_user_2
st_user_3 st_user_3
st_user_4 st_user_4
st_user_5 st_user_5
st_calc_1 st_calc_1
st_calc_2 st_calc_2
st_calc_3 st_calc_3
st_calc_4 st_calc_4
st_calc_5 st_calc_5
st_title st_title
st_documentation_guide st_documentation_guide
st_display_only st_display_only
cb_rules cb_rules
st_4 st_4
dw_time_with_patient dw_time_with_patient
end type
global w_svc_encounter_coding w_svc_encounter_coding

type variables

integer selected_history
integer selected_exam
integer selected_decision
integer selected_encounter

integer new_selected_history
integer new_selected_exam
integer new_selected_decision
integer new_selected_encounter

integer calculated_history
integer calculated_exam
integer calculated_decision
integer calculated_encounter

u_component_service service
str_encounter_description encounter

string em_documentation_guide


end variables

forward prototypes
public function integer save_changes ()
public subroutine calculate_visit_level ()
public subroutine set_visit_level_fields ()
end prototypes

public function integer save_changes ();integer li_sts
string ls_null

setnull(ls_null)

if isnull(new_selected_history) and not isnull(selected_history) then
		current_patient.set_encounter_property(encounter.encounter_id, "EM_HISTORY_LEVEL", ls_null)
elseif not isnull(new_selected_history) and isnull(selected_history) then
		current_patient.set_encounter_property(encounter.encounter_id, "EM_HISTORY_LEVEL", string(new_selected_history))
elseif not isnull(new_selected_history) and not isnull(selected_history) then
	if new_selected_history <> selected_history then
		current_patient.set_encounter_property(encounter.encounter_id, "EM_HISTORY_LEVEL", string(new_selected_history))
	end if
end if

if isnull(new_selected_exam) and not isnull(selected_exam) then
		current_patient.set_encounter_property(encounter.encounter_id, "EM_EXAM_LEVEL", ls_null)
elseif not isnull(new_selected_exam) and isnull(selected_exam) then
		current_patient.set_encounter_property(encounter.encounter_id, "EM_EXAM_LEVEL", string(new_selected_exam))
elseif not isnull(new_selected_exam) and not isnull(selected_exam) then
	if new_selected_exam <> selected_exam then
		current_patient.set_encounter_property(encounter.encounter_id, "EM_EXAM_LEVEL", string(new_selected_exam))
	end if
end if

if isnull(new_selected_decision) and not isnull(selected_decision) then
		current_patient.set_encounter_property(encounter.encounter_id, "EM_DECISION_LEVEL", ls_null)
elseif not isnull(new_selected_decision) and isnull(selected_decision) then
		current_patient.set_encounter_property(encounter.encounter_id, "EM_DECISION_LEVEL", string(new_selected_decision))
elseif not isnull(new_selected_decision) and not isnull(selected_decision) then
	if new_selected_decision <> selected_decision then
		current_patient.set_encounter_property(encounter.encounter_id, "EM_DECISION_LEVEL", string(new_selected_decision))
	end if
end if

if isnull(new_selected_encounter) and not isnull(selected_encounter) then
		current_patient.set_encounter_property(encounter.encounter_id, "EM_ENCOUNTER_LEVEL", ls_null)
elseif not isnull(new_selected_encounter) and isnull(selected_encounter) then
		current_patient.set_encounter_property(encounter.encounter_id, "EM_ENCOUNTER_LEVEL", string(new_selected_encounter))
elseif not isnull(new_selected_encounter) and not isnull(selected_encounter) then
	if new_selected_encounter <> selected_encounter then
		current_patient.set_encounter_property(encounter.encounter_id, "EM_ENCOUNTER_LEVEL", string(new_selected_encounter))
	end if
end if




return 1

end function

public subroutine calculate_visit_level ();integer li_history_level
integer li_exam_level
integer li_decision_level
integer li_encounter_level

if isnull(new_selected_history) then
	li_history_level = calculated_history
else
	li_history_level = new_selected_history
end if

if isnull(new_selected_exam) then
	li_exam_level = calculated_exam
else
	li_exam_level = new_selected_exam
end if

if isnull(new_selected_decision) then
	li_decision_level = calculated_decision
else
	li_decision_level = new_selected_decision
end if

li_encounter_level = datalist.visit_level(em_documentation_guide, encounter.new_flag, li_history_level, li_exam_level, li_decision_level)

if li_encounter_level > 0 then new_selected_encounter = li_encounter_level

set_visit_level_fields()

end subroutine

public subroutine set_visit_level_fields ();
st_user_1.backcolor = color_object
st_calc_1.backcolor = color_object
st_user_2.backcolor = color_object
st_calc_2.backcolor = color_object
st_user_3.backcolor = color_object
st_calc_3.backcolor = color_object
st_user_4.backcolor = color_object
st_calc_4.backcolor = color_object
st_user_5.backcolor = color_object
st_calc_5.backcolor = color_object

if isnull(new_selected_encounter) then
	st_selected_visit_level.text = "N/A"
else
	st_selected_visit_level.text = datalist.visit_level_description(new_selected_encounter)
	CHOOSE CASE new_selected_encounter
		CASE 1
			st_user_1.backcolor = color_object_selected
		CASE 2
			st_user_2.backcolor = color_object_selected
		CASE 3
			st_user_3.backcolor = color_object_selected
		CASE 4
			st_user_4.backcolor = color_object_selected
		CASE 5
			st_user_5.backcolor = color_object_selected
		CASE ELSE
			setnull(new_selected_encounter)
			st_selected_visit_level.text = "N/A"
	END CHOOSE
end if

if isnull(calculated_encounter) then
	st_calculated_visit_level.text = "N/A"
else
	st_calculated_visit_level.text = datalist.visit_level_description(calculated_encounter)
	CHOOSE CASE calculated_encounter
		CASE 1
			st_calc_1.backcolor = color_object_selected
		CASE 2
			st_calc_2.backcolor = color_object_selected
		CASE 3
			st_calc_3.backcolor = color_object_selected
		CASE 4
			st_calc_4.backcolor = color_object_selected
		CASE 5
			st_calc_5.backcolor = color_object_selected
		CASE ELSE
			setnull(calculated_encounter)
			st_calculated_visit_level.text = "N/A"
	END CHOOSE
end if


end subroutine

on w_svc_encounter_coding.create
int iCurrent
call super::create
this.dw_history=create dw_history
this.dw_exam=create dw_exam
this.dw_decision=create dw_decision
this.st_history_title=create st_history_title
this.st_exam_title=create st_exam_title
this.st_decision_title=create st_decision_title
this.cb_history_details=create cb_history_details
this.cb_exam_details=create cb_exam_details
this.cb_decision_details=create cb_decision_details
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.st_calculated_visit_level=create st_calculated_visit_level
this.st_override=create st_override
this.st_selected_visit_level=create st_selected_visit_level
this.cb_done=create cb_done
this.cb_be_back=create cb_be_back
this.st_user_1=create st_user_1
this.st_user_2=create st_user_2
this.st_user_3=create st_user_3
this.st_user_4=create st_user_4
this.st_user_5=create st_user_5
this.st_calc_1=create st_calc_1
this.st_calc_2=create st_calc_2
this.st_calc_3=create st_calc_3
this.st_calc_4=create st_calc_4
this.st_calc_5=create st_calc_5
this.st_title=create st_title
this.st_documentation_guide=create st_documentation_guide
this.st_display_only=create st_display_only
this.cb_rules=create cb_rules
this.st_4=create st_4
this.dw_time_with_patient=create dw_time_with_patient
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_history
this.Control[iCurrent+2]=this.dw_exam
this.Control[iCurrent+3]=this.dw_decision
this.Control[iCurrent+4]=this.st_history_title
this.Control[iCurrent+5]=this.st_exam_title
this.Control[iCurrent+6]=this.st_decision_title
this.Control[iCurrent+7]=this.cb_history_details
this.Control[iCurrent+8]=this.cb_exam_details
this.Control[iCurrent+9]=this.cb_decision_details
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.st_2
this.Control[iCurrent+12]=this.st_3
this.Control[iCurrent+13]=this.st_calculated_visit_level
this.Control[iCurrent+14]=this.st_override
this.Control[iCurrent+15]=this.st_selected_visit_level
this.Control[iCurrent+16]=this.cb_done
this.Control[iCurrent+17]=this.cb_be_back
this.Control[iCurrent+18]=this.st_user_1
this.Control[iCurrent+19]=this.st_user_2
this.Control[iCurrent+20]=this.st_user_3
this.Control[iCurrent+21]=this.st_user_4
this.Control[iCurrent+22]=this.st_user_5
this.Control[iCurrent+23]=this.st_calc_1
this.Control[iCurrent+24]=this.st_calc_2
this.Control[iCurrent+25]=this.st_calc_3
this.Control[iCurrent+26]=this.st_calc_4
this.Control[iCurrent+27]=this.st_calc_5
this.Control[iCurrent+28]=this.st_title
this.Control[iCurrent+29]=this.st_documentation_guide
this.Control[iCurrent+30]=this.st_display_only
this.Control[iCurrent+31]=this.cb_rules
this.Control[iCurrent+32]=this.st_4
this.Control[iCurrent+33]=this.dw_time_with_patient
end on

on w_svc_encounter_coding.destroy
call super::destroy
destroy(this.dw_history)
destroy(this.dw_exam)
destroy(this.dw_decision)
destroy(this.st_history_title)
destroy(this.st_exam_title)
destroy(this.st_decision_title)
destroy(this.cb_history_details)
destroy(this.cb_exam_details)
destroy(this.cb_decision_details)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_calculated_visit_level)
destroy(this.st_override)
destroy(this.st_selected_visit_level)
destroy(this.cb_done)
destroy(this.cb_be_back)
destroy(this.st_user_1)
destroy(this.st_user_2)
destroy(this.st_user_3)
destroy(this.st_user_4)
destroy(this.st_user_5)
destroy(this.st_calc_1)
destroy(this.st_calc_2)
destroy(this.st_calc_3)
destroy(this.st_calc_4)
destroy(this.st_calc_5)
destroy(this.st_title)
destroy(this.st_documentation_guide)
destroy(this.st_display_only)
destroy(this.cb_rules)
destroy(this.st_4)
destroy(this.dw_time_with_patient)
end on

event open;call super::open;str_popup_return popup_return
integer li_sts
long ll_rows
string ls_specialty_id
long i
string ls_find
long ll_row
string ls_temp
long ll_menu_id
string ls_display_only

 DECLARE lsp_encounter_level PROCEDURE FOR dbo.sp_encounter_level  
         @ps_cpr_id = :current_patient.cpr_id,   
         @pl_encounter_id = :encounter.encounter_id,   
			@ps_em_documentation_guide = :em_documentation_guide,
         @pi_history_level = :calculated_history OUT,   
         @pi_exam_level = :calculated_exam OUT,   
         @pi_decision_level = :calculated_decision OUT ;

popup_return.item_count = 0

service = Message.powerobjectparm

if isnull(service.encounter_id) then
	log.log(this, "w_svc_encounter_coding:open", "No current encounter", 4)
	closewithreturn(this, popup_return)
	return
end if

li_sts = current_patient.encounters.encounter(encounter, service.encounter_id)
if li_sts <= 0 then
	log.log(this, "w_svc_encounter_coding:open", "Error getting encounter", 4)
	closewithreturn(this, popup_return)
	return
end if

title = current_patient.id_line()

st_title.text = "Encounter Coding Levels"
if upper(encounter.new_flag) = "Y" then
	st_title.text += " (New Patient)"
else
	st_title.text += " (Established Patient)"
end if

dw_history.settransobject(sqlca)
dw_exam.settransobject(sqlca)
dw_decision.settransobject(sqlca)


dw_history.retrieve("History")
dw_exam.retrieve("Examination")
dw_decision.retrieve("Decision Making")

// Get the selected levels
ls_temp = current_patient.get_encounter_property(encounter.encounter_id, "EM_HISTORY_LEVEL")
selected_history = integer(ls_temp)
ls_find = "em_component_level=" + string(selected_history)
ll_row = dw_history.find(ls_find, 1, dw_history.rowcount())
if ll_row > 0 then
	dw_history.object.selected_flag[ll_row] = 1
else
	setnull(selected_history)
end if

ls_temp = current_patient.get_encounter_property(encounter.encounter_id, "EM_EXAM_LEVEL")
selected_exam = integer(ls_temp)
ls_find = "em_component_level=" + string(selected_exam)
ll_row = dw_exam.find(ls_find, 1, dw_exam.rowcount())
if ll_row > 0 then
	dw_exam.object.selected_flag[ll_row] = 1
else
	setnull(selected_exam)
end if

ls_temp = current_patient.get_encounter_property(encounter.encounter_id, "EM_DECISION_LEVEL")
selected_decision = integer(ls_temp)
ls_find = "em_component_level=" + string(selected_decision)
ll_row = dw_decision.find(ls_find, 1, dw_decision.rowcount())
if ll_row > 0 then
	dw_decision.object.selected_flag[ll_row] = 1
else
	setnull(selected_decision)
end if

ls_temp = current_patient.get_encounter_property(encounter.encounter_id, "EM_ENCOUNTER_LEVEL")
selected_encounter = integer(ls_temp)

em_documentation_guide = f_get_encounter_property(current_patient.cpr_id, encounter.encounter_id, "em_documentation_guide")
if isnull(em_documentation_guide) then em_documentation_guide = "1997 E&M"
SELECT description
INTO :st_documentation_guide.text
FROM em_documentation_guide
WHERE em_documentation_guide = :em_documentation_guide;
if not tf_check() then
	log.log(this, "w_svc_encounter_coding:open", "Error getting documentation guide", 4)
	closewithreturn(this, popup_return)
	return
end if

// Get the calculated levels
EXECUTE lsp_encounter_level;
if not tf_check() then closewithreturn(this, popup_return)

FETCH lsp_encounter_level INTO :calculated_history, :calculated_exam, :calculated_decision;
if not tf_check() then closewithreturn(this, popup_return)

CLOSE lsp_encounter_level;

calculated_encounter = datalist.visit_level(em_documentation_guide, encounter.new_flag, calculated_history, calculated_exam, calculated_decision)

ls_find = "em_component_level=" + string(calculated_history)
ll_row = dw_history.find(ls_find, 1, dw_history.rowcount())
if ll_row > 0 then
	dw_history.object.calculated_flag[ll_row] = 1
end if

ls_find = "em_component_level=" + string(calculated_exam)
ll_row = dw_exam.find(ls_find, 1, dw_exam.rowcount())
if ll_row > 0 then
	dw_exam.object.calculated_flag[ll_row] = 1
end if

ls_find = "em_component_level=" + string(calculated_decision)
ll_row = dw_decision.find(ls_find, 1, dw_decision.rowcount())
if ll_row > 0 then
	dw_decision.object.calculated_flag[ll_row] = 1
end if


new_selected_history = selected_history
new_selected_exam = selected_exam
new_selected_decision = selected_decision
new_selected_encounter = selected_encounter

set_visit_level_fields()

// Decide whether or not we're in display-only mode
if encounter.billing_posted then
	ls_display_only = "Display Only (Billing has already been posted)"
elseif current_user.user_id = encounter.attending_doctor &
	or current_user.user_id = user_list.supervisor_user_id(encounter.attending_doctor) &
	or current_user.user_id = encounter.supervising_doctor &
	or current_user.check_privilege("Encounter Coding")    then
	setnull(ls_display_only)
else
	ls_display_only = "Display Only (You are not the encounter owner)"
end if

if isnull(ls_display_only) then
	st_display_only.visible = false
else
	st_display_only.visible = true
	st_display_only.text = ls_display_only
	dw_decision.enabled = false
	dw_exam.enabled = false
	dw_history.enabled = false
	st_user_1.enabled = false
	st_user_2.enabled = false
	st_user_3.enabled = false
	st_user_4.enabled = false
	st_user_5.enabled = false
	st_user_1.borderstyle = stylebox!
	st_user_2.borderstyle = stylebox!
	st_user_3.borderstyle = stylebox!
	st_user_4.borderstyle = stylebox!
	st_user_5.borderstyle = stylebox!
end if

dw_time_with_patient.settransobject(sqlca)
dw_time_with_patient.retrieve(current_patient.cpr_id, service.encounter_id)

// Don't offer the "I'll Be Back" option for manual services
if service.manual_service then
	cb_be_back.visible = false
	max_buttons = 4
end if

ll_menu_id = long(service.get_attribute("menu_id"))
paint_menu(ll_menu_id)



end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_encounter_coding
integer x = 2857
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_encounter_coding
end type

type dw_history from u_dw_pick_list within w_svc_encounter_coding
integer x = 105
integer y = 348
integer width = 846
integer height = 500
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_em_component_level"
boolean border = false
end type

event selected;new_selected_history = object.em_component_level[selected_row]
calculate_visit_level()

end event

event unselected;call super::unselected;setnull(new_selected_history)
calculate_visit_level()

end event

type dw_exam from u_dw_pick_list within w_svc_encounter_coding
integer x = 1010
integer y = 348
integer width = 846
integer height = 500
integer taborder = 21
boolean bringtotop = true
string dataobject = "dw_em_component_level"
boolean border = false
end type

event selected;new_selected_exam = object.em_component_level[selected_row]
calculate_visit_level()

end event

event unselected;setnull(new_selected_exam)
calculate_visit_level()

end event

type dw_decision from u_dw_pick_list within w_svc_encounter_coding
integer x = 1915
integer y = 348
integer width = 846
integer height = 500
integer taborder = 21
boolean bringtotop = true
string dataobject = "dw_em_component_level"
boolean border = false
end type

event selected;call super::selected;new_selected_decision = object.em_component_level[selected_row]
calculate_visit_level()

end event

event unselected;setnull(new_selected_decision)
calculate_visit_level()

end event

type st_history_title from statictext within w_svc_encounter_coding
integer x = 105
integer y = 280
integer width = 846
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "History"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_exam_title from statictext within w_svc_encounter_coding
integer x = 1010
integer y = 280
integer width = 846
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Examination"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_decision_title from statictext within w_svc_encounter_coding
integer x = 1915
integer y = 280
integer width = 846
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Decision Making"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_history_details from commandbutton within w_svc_encounter_coding
integer x = 325
integer y = 880
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
string text = "Details"
end type

event clicked;str_popup popup

popup.data_row_count = 4
popup.items[1] = em_documentation_guide
popup.items[2] = "History"
popup.items[3] = string(calculated_history)
popup.items[4] = string(service.encounter_id)

openwithparm(w_encounter_coding_detail, popup)


end event

type cb_exam_details from commandbutton within w_svc_encounter_coding
integer x = 1230
integer y = 880
integer width = 402
integer height = 112
integer taborder = 31
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Details"
end type

event clicked;str_popup popup

popup.data_row_count = 4
popup.items[1] = em_documentation_guide
popup.items[2] = "Examination"
popup.items[3] = string(calculated_exam)
popup.items[4] = string(service.encounter_id)

openwithparm(w_encounter_coding_detail, popup)


end event

type cb_decision_details from commandbutton within w_svc_encounter_coding
integer x = 2135
integer y = 880
integer width = 402
integer height = 112
integer taborder = 31
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Details"
end type

event clicked;str_popup popup
w_encounter_coding_detail lw_encounter_coding_detail

popup.data_row_count = 4
popup.items[1] = em_documentation_guide
popup.items[2] = "Decision Making"
popup.items[3] = string(calculated_decision)
popup.items[4] = string(service.encounter_id)

openwithparm(lw_encounter_coding_detail, popup, "w_encounter_coding_detail", parent)


end event

type st_1 from statictext within w_svc_encounter_coding
integer x = 2377
integer y = 1004
integer width = 503
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "= Calculated Level"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_svc_encounter_coding
integer x = 2304
integer y = 1008
integer width = 69
integer height = 64
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "*"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_3 from statictext within w_svc_encounter_coding
integer x = 55
integer y = 1304
integer width = 809
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Calculated Visit Level:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_calculated_visit_level from statictext within w_svc_encounter_coding
integer x = 1760
integer y = 1284
integer width = 855
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_override from statictext within w_svc_encounter_coding
integer x = 55
integer y = 1448
integer width = 809
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "User Selected Visit Level:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_selected_visit_level from statictext within w_svc_encounter_coding
integer x = 1760
integer y = 1428
integer width = 855
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_em_visit_level"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.add_blank_row = true
popup.blank_text = "N/A"

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	setnull(new_selected_encounter)
	backcolor = color_object
else
	new_selected_encounter = long(popup_return.items[1])
	backcolor = color_object_selected
end if

text = popup_return.descriptions[1]



end event

type cb_done from commandbutton within w_svc_encounter_coding
integer x = 2427
integer y = 1584
integer width = 443
integer height = 108
integer taborder = 160
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
end type

event clicked;str_popup_return popup_return
integer li_sts

li_sts = save_changes()
if li_sts <= 0 then return

popup_return.item_count = 1
popup_return.items[1] = "COMPLETE"

closewithreturn(parent, popup_return)

end event

type cb_be_back from commandbutton within w_svc_encounter_coding
integer x = 1961
integer y = 1584
integer width = 443
integer height = 108
integer taborder = 170
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I~'ll Be Back"
end type

event clicked;str_popup_return popup_return
integer li_sts

li_sts = save_changes()
if li_sts <= 0 then return

popup_return.item_count = 0
closewithreturn(parent, popup_return)


end event

type st_user_1 from statictext within w_svc_encounter_coding
integer x = 914
integer y = 1428
integer width = 151
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "1"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if new_selected_encounter = 1 then
	setnull(new_selected_encounter)
	backcolor = color_object
	st_selected_visit_level.text = "N/A"
else
	new_selected_encounter = 1
	backcolor = color_object_selected
	st_selected_visit_level.text = datalist.visit_level_description(new_selected_encounter)
end if

st_user_2.backcolor = color_object
st_user_3.backcolor = color_object
st_user_4.backcolor = color_object
st_user_5.backcolor = color_object



end event

type st_user_2 from statictext within w_svc_encounter_coding
integer x = 1083
integer y = 1428
integer width = 151
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "2"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if new_selected_encounter = 2 then
	setnull(new_selected_encounter)
	backcolor = color_object
	st_selected_visit_level.text = "N/A"
else
	new_selected_encounter = 2
	backcolor = color_object_selected
	st_selected_visit_level.text = datalist.visit_level_description(new_selected_encounter)
end if

st_user_1.backcolor = color_object
st_user_3.backcolor = color_object
st_user_4.backcolor = color_object
st_user_5.backcolor = color_object



end event

type st_user_3 from statictext within w_svc_encounter_coding
integer x = 1253
integer y = 1428
integer width = 151
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "3"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if new_selected_encounter = 3 then
	setnull(new_selected_encounter)
	backcolor = color_object
	st_selected_visit_level.text = "N/A"
else
	new_selected_encounter = 3
	backcolor = color_object_selected
	st_selected_visit_level.text = datalist.visit_level_description(new_selected_encounter)
end if

st_user_2.backcolor = color_object
st_user_1.backcolor = color_object
st_user_4.backcolor = color_object
st_user_5.backcolor = color_object



end event

type st_user_4 from statictext within w_svc_encounter_coding
integer x = 1422
integer y = 1428
integer width = 151
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "4"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if new_selected_encounter = 4 then
	setnull(new_selected_encounter)
	backcolor = color_object
	st_selected_visit_level.text = "N/A"
else
	new_selected_encounter = 4
	backcolor = color_object_selected
	st_selected_visit_level.text = datalist.visit_level_description(new_selected_encounter)
end if

st_user_2.backcolor = color_object
st_user_3.backcolor = color_object
st_user_1.backcolor = color_object
st_user_5.backcolor = color_object



end event

type st_user_5 from statictext within w_svc_encounter_coding
integer x = 1591
integer y = 1428
integer width = 151
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "5"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if new_selected_encounter = 5 then
	setnull(new_selected_encounter)
	backcolor = color_object
	st_selected_visit_level.text = "N/A"
else
	new_selected_encounter = 5
	backcolor = color_object_selected
	st_selected_visit_level.text = datalist.visit_level_description(new_selected_encounter)
end if

st_user_2.backcolor = color_object
st_user_3.backcolor = color_object
st_user_4.backcolor = color_object
st_user_1.backcolor = color_object



end event

type st_calc_1 from statictext within w_svc_encounter_coding
integer x = 914
integer y = 1284
integer width = 151
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "1"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_calc_2 from statictext within w_svc_encounter_coding
integer x = 1083
integer y = 1284
integer width = 151
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "2"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_calc_3 from statictext within w_svc_encounter_coding
integer x = 1253
integer y = 1284
integer width = 151
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "3"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_calc_4 from statictext within w_svc_encounter_coding
integer x = 1422
integer y = 1284
integer width = 151
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "4"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_calc_5 from statictext within w_svc_encounter_coding
integer x = 1591
integer y = 1284
integer width = 151
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "5"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_title from statictext within w_svc_encounter_coding
integer width = 2921
integer height = 104
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Encounter Coding Levels"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_documentation_guide from statictext within w_svc_encounter_coding
integer y = 104
integer width = 2921
integer height = 96
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "1997 Documentation Guidelines for Evaluation and Management Services"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_display_only from statictext within w_svc_encounter_coding
integer y = 180
integer width = 2921
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Display Only (Billing has already been posted)"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_rules from commandbutton within w_svc_encounter_coding
integer x = 2629
integer y = 1284
integer width = 238
integer height = 108
integer taborder = 41
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Rules"
end type

event clicked;str_popup popup

popup.data_row_count = 3
popup.items[1] = em_documentation_guide
popup.items[2] = encounter.new_flag
popup.items[3] = string(encounter.encounter_id)
openwithparm(w_em_visit_level_rules, popup)


end event

type st_4 from statictext within w_svc_encounter_coding
integer x = 375
integer y = 1024
integer width = 489
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Time in Chart:"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_time_with_patient from u_dw_pick_list within w_svc_encounter_coding
integer x = 914
integer y = 1024
integer width = 1033
integer height = 224
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_sp_time_spent_with_patient"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

