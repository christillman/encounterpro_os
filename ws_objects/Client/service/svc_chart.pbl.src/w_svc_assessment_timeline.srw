$PBExportHeader$w_svc_assessment_timeline.srw
forward
global type w_svc_assessment_timeline from w_window_base
end type
end forward

global type w_svc_assessment_timeline from w_window_base
boolean visible = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
end type
global w_svc_assessment_timeline w_svc_assessment_timeline

type variables
string assessment_id
long problem_id
str_assessment_description assessment
end variables

on w_svc_assessment_timeline.create
call super::create
end on

on w_svc_assessment_timeline.destroy
call super::destroy
end on

event open;call super::open;integer						li_sts,li_count
u_component_service		service
str_popup_return			popup_return

service = message.powerobjectparm
title = current_patient.id_line()

if isnull(service.problem_id) then
	log.log(this, "open", "Null problem_id", 4)
	closewithreturn(this, popup_return)
	return
end if

li_sts = current_patient.assessments.assessment(assessment, service.problem_id)
if li_sts <= 0 then
	log.log(this, "open", "Error getting assessment object (" + string(service.problem_id) + ")", 4)
	closewithreturn(this, popup_return)
	return
end if

assessment_id = assessment.assessment_id
problem_id = service.problem_id
postevent("post_open")
end event

event post_open;call super::post_open;String						ls_observation_id,ls_top_20_code
string						ls_user_id,ls_treatment_type
integer						li_sts,li_count
w_pick_observations		lw_pick
u_str_encounter			luo_encounter
str_popup					popup
str_popup_return			popup_return
str_picked_observations lstr_observations

Setnull(luo_encounter)
Setnull(ls_treatment_type)
// See if there are any objective lists for this assessment
ls_top_20_code = "ASST_TIMELINE|"+assessment_id
ls_user_id = current_user.common_list_id()

SELECT count(*)
	INTO :li_count
	FROM u_Top_20
	WHERE top_20_code = :ls_top_20_code
	AND user_id = :ls_user_id;
IF Not tf_check() Then Return
If li_count = 0 Then
	// If no objective lists, then let the user select a new one
	popup.data_row_count = 4
	popup.items[1] = ls_treatment_type
	popup.items[2] = current_user.specialty_id
	popup.items[3] = ls_top_20_code
	popup.items[4] = 'Y' //Show only Composite observations
	popup.multiselect = false

	openwithparm(lw_pick, popup, "w_pick_observations")
	lstr_observations = message.powerobjectparm
	If  lstr_observations.observation_count <> 1 Then Return
	ls_observation_id =  lstr_observations.observation_id[1]
			
	// The call the timeline screen
	popup.data_row_count = 2
	popup.items[1] = String(problem_id)
	popup.items[2] = ls_observation_id
	popup.title = f_assessment_description(assessment)
	Openwithparm(w_treatment_vs_results, popup)
Else
	// If there are objective lists, then let the user select one
	popup.data_row_count = 0
	popup.dataobject = "dw_assessment_obj_list"
	popup.displaycolumn = 2
	popup.datacolumn = 1
	popup.argument_count = 2
	popup.argument[1] = ls_top_20_code
	popup.argument[2] = ls_user_id
	popup.auto_singleton = true
	openwithparm(w_pop_pick, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return
			
	// The call the timeline screen
	popup.data_row_count = 2
	popup.items[1] = string(problem_id)
	popup.items[2] = popup_return.items[1]
	popup.title = f_assessment_description(assessment)
	openwithparm(w_treatment_vs_results, popup)
End If
// Complete the service
popup_return.item_count = 1
popup_return.items[1] = "OK"

Closewithreturn(this, popup_return)
end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_assessment_timeline
end type

