$PBExportHeader$w_svc_assessment_list.srw
forward
global type w_svc_assessment_list from w_window_base
end type
type st_title from statictext within w_svc_assessment_list
end type
type dw_allergies from u_dw_pick_list within w_svc_assessment_list
end type
type st_no_assessments from statictext within w_svc_assessment_list
end type
type cb_finished from commandbutton within w_svc_assessment_list
end type
type cb_be_back from commandbutton within w_svc_assessment_list
end type
end forward

global type w_svc_assessment_list from w_window_base
integer height = 1840
boolean controlmenu = false
windowtype windowtype = response!
string button_type = "COMMAND"
integer max_buttons = 3
st_title st_title
dw_allergies dw_allergies
st_no_assessments st_no_assessments
cb_finished cb_finished
cb_be_back cb_be_back
end type
global w_svc_assessment_list w_svc_assessment_list

type variables
string assessment_type
string assessment_type_description
string assessment_service
string progress_type

end variables

forward prototypes
public subroutine refresh_screen ()
end prototypes

public subroutine refresh_screen ();integer i
integer li_sts
integer li_progress_count
integer li_count
string ls_find
str_assessment_description lstra_assessments[]
str_progress_list lstr_progress
long ll_row
string ls_reaction
string ls_severity
string ls_progress_key

setnull(ls_progress_key)

dw_allergies.reset()

ls_find = "upper(assessment_type)='" + upper(assessment_type) + "' and isnull(assessment_status)"

li_count = current_patient.assessments.get_assessments(ls_find, lstra_assessments)

if li_count <= 0 then
	st_no_assessments.text = "No Open " + assessment_type_description + " Assessments"
	st_no_assessments.visible = true
else
	st_no_assessments.visible = false
	for i = 1 to li_count
		lstr_progress = f_get_progress(current_patient.cpr_id, "Assessment", lstra_assessments[i].problem_id, progress_type, ls_progress_key)
		li_progress_count = lstr_progress.progress_count
		if li_progress_count <= 0 then
			ls_reaction = ""
			ls_severity = ""
		else
			ls_reaction = lstr_progress.progress[li_progress_count].progress
			ls_severity = lstr_progress.progress[li_progress_count].progress_key
		end if
		ll_row = dw_allergies.insertrow(0)
		dw_allergies.object.problem_id[ll_row] = lstra_assessments[i].problem_id
		dw_allergies.object.diagnosis_sequence[ll_row] = lstra_assessments[i].diagnosis_sequence
		dw_allergies.object.identification_date[ll_row] = lstra_assessments[i].begin_date
		dw_allergies.object.description[ll_row] = lstra_assessments[i].assessment
		dw_allergies.object.allergy_reaction[ll_row] = ls_reaction
		dw_allergies.object.severity[ll_row] = ls_severity
	next
end if


end subroutine

event open;call super::open;long ll_menu_id

u_component_service service

service = message.powerobjectparm
assessment_type = service.get_attribute("assessment_type")
if isnull(assessment_type) then assessment_type = "ALLERGY"

assessment_type_description = datalist.assessment_type_description(assessment_type)

assessment_service = service.get_attribute("assessment_service")
if isnull(assessment_service) then assessment_service = "ASSESSMENT_REVIEW"

progress_type = service.get_attribute("progress_type")
if isnull(progress_type) then progress_type = "Reaction"

// Set the title and sizes
title = current_patient.id_line()

st_title.text = assessment_type_description + " Assessments"

if len(st_title.text) > 42 then
	if len(st_title.text) > 60 then
		if len(st_title.text) > 70 then
			st_title.textsize = -10
		else
			st_title.textsize = -12
		end if
	else
		st_title.textsize = -14
	end if
else
	st_title.textsize = -18
end if

// Don't offer the "I'll Be Back" option for manual services
if service.manual_service then
	cb_be_back.visible = false
	max_buttons = 4
end if

ll_menu_id = long(service.get_attribute("menu_id"))
if not isnull(ll_menu_id) then paint_menu(ll_menu_id)

state_attributes.attribute_count = 1
state_attributes.attribute[1].attribute = "assessment_type"
state_attributes.attribute[1].value = assessment_type

//dw_allergies.object.identification_date.width = dw_allergies.width - 196
//dw_allergies.object.description.width = dw_allergies.width - 530
//dw_allergies.object.severity.width = dw_allergies.width - 1345
//dw_allergies.object.allergy_reaction.x = dw_allergies.width - 1601
dw_allergies.object.t_back.width = dw_allergies.width - 100

refresh_screen()

end event

on w_svc_assessment_list.create
int iCurrent
call super::create
this.st_title=create st_title
this.dw_allergies=create dw_allergies
this.st_no_assessments=create st_no_assessments
this.cb_finished=create cb_finished
this.cb_be_back=create cb_be_back
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.dw_allergies
this.Control[iCurrent+3]=this.st_no_assessments
this.Control[iCurrent+4]=this.cb_finished
this.Control[iCurrent+5]=this.cb_be_back
end on

on w_svc_assessment_list.destroy
call super::destroy
destroy(this.st_title)
destroy(this.dw_allergies)
destroy(this.st_no_assessments)
destroy(this.cb_finished)
destroy(this.cb_be_back)
end on

event button_pressed(integer button_index);call super::button_pressed;refresh_screen()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_assessment_list
boolean visible = true
integer x = 2629
integer y = 1476
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_assessment_list
end type

type st_title from statictext within w_svc_assessment_list
integer width = 2898
integer height = 132
integer textsize = -22
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Allergies and Adverse Reactions"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_allergies from u_dw_pick_list within w_svc_assessment_list
integer x = 41
integer y = 160
integer width = 2802
integer height = 1256
integer taborder = 10
string dataobject = "dw_allergies"
boolean vscrollbar = true
boolean border = false
end type

event selected(long selected_row);call super::selected;long ll_problem_id
integer li_diagnosis_sequence
str_attributes lstr_attributes

ll_problem_id = object.problem_id[selected_row]
li_diagnosis_sequence = object.diagnosis_sequence[selected_row]

lstr_attributes.attribute_count = 1
lstr_attributes.attribute[1].attribute = "problem_id"
lstr_attributes.attribute[1].value = string(ll_problem_id)

if li_diagnosis_sequence > 0 then
	lstr_attributes.attribute_count = 2
	lstr_attributes.attribute[2].attribute = "diagnosis_sequence"
	lstr_attributes.attribute[2].value = string(li_diagnosis_sequence)
end if

service_list.do_service(current_patient.cpr_id, &
								current_patient.open_encounter_id, &
								assessment_service, &
								lstr_attributes)

clear_selected()

refresh_screen()

end event

type st_no_assessments from statictext within w_svc_assessment_list
integer x = 347
integer y = 604
integer width = 2167
integer height = 156
boolean bringtotop = true
integer textsize = -16
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "No Open Allergy Assessments"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_finished from commandbutton within w_svc_assessment_list
integer x = 2427
integer y = 1620
integer width = 443
integer height = 108
integer taborder = 150
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

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)

end event

type cb_be_back from commandbutton within w_svc_assessment_list
integer x = 1961
integer y = 1620
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
string text = "I~'ll Be Back"
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 0
closewithreturn(parent, popup_return)


end event

