$PBExportHeader$u_component_service_rediagnose.sru
forward
global type u_component_service_rediagnose from u_component_service
end type
end forward

global type u_component_service_rediagnose from u_component_service
end type
global u_component_service_rediagnose u_component_service_rediagnose

forward prototypes
public function integer xx_do_service ()
end prototypes

public function integer xx_do_service ();integer li_sts
string ls_new_assessment_id
boolean lb_exists
long ll_attachment_id
integer li_diagnosis_sequence
str_popup popup
str_assessment_description lstr_assessment

setnull(ll_attachment_id)

if isnull(problem_id) then
	log.log(this, "u_component_service_rediagnose.xx_do_service:0013", "No problem_id", 4)
	return -1
end if

li_sts = current_patient.assessments.assessment(lstr_assessment, problem_id)
if li_sts <= 0 then
	log.log(this, "u_component_service_rediagnose.xx_do_service:0019", "Error getting assessment (" + string(problem_id) + ", " + string(li_sts) + ")", 4)
	return -1
end if

popup.data_row_count = 2
popup.items[1] = lstr_assessment.assessment_type
popup.items[2] = "SVCREDIAG|"
if not isnull(lstr_assessment.assessment_id) then popup.items[2] += lstr_assessment.assessment_id

openwithparm(service_window, popup, "w_find_assessment")
ls_new_assessment_id = message.stringparm
if isnull(ls_new_assessment_id) then return 2

li_diagnosis_sequence = current_patient.assessments.rediagnose( &
															problem_id, &
															encounter_id, &
															ls_new_assessment_id, &
															datetime(today(), now()), &
															current_user.user_id, &
															current_scribe.user_id)


if li_diagnosis_sequence <= 0 then
	return -1
else
	return 1
end if

end function

on u_component_service_rediagnose.create
call super::create
end on

on u_component_service_rediagnose.destroy
call super::destroy
end on

