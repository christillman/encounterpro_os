$PBExportHeader$u_component_service_close_assessment.sru
forward
global type u_component_service_close_assessment from u_component_service
end type
end forward

global type u_component_service_close_assessment from u_component_service
end type
global u_component_service_close_assessment u_component_service_close_assessment

forward prototypes
public function integer xx_do_service ()
end prototypes

public function integer xx_do_service ();integer 					li_sts,i, li_count
string 					ls_bill_flag
datetime 				ldt_close_date
date 						ld_temp
str_assessment_description lstr_assessment
str_popup 				popup
str_popup_return 		popup_return
string ls_assessment_status
string ls_reason
string ls_severity


ldt_close_date = datetime(today(), now())
if isnull(problem_id) then
	log.log(this, "u_component_service_close_assessment.xx_do_service:0015", "Null problem_id", 4)
	return 1
end if

ls_assessment_status = get_attribute("assessment_status")
if isnull(ls_assessment_status) then ls_assessment_status = "CLOSED"

ls_reason = get_attribute("reason")
ls_severity = get_attribute("severity")

setnull(ls_bill_flag)


li_sts = current_patient.assessments.assessment(lstr_assessment, problem_id)
if li_sts <= 0 then
	log.log(this, "u_component_service_close_assessment.xx_do_service:0030", "Error getting assessment object (" + string(problem_id) + ")", 4)
	return 1
end if

if upper(ls_assessment_status) = "CLOSED" then
	if cpr_mode = "CLIENT" then
		openwithparm(service_window, this, "w_svc_assessment_close")
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return 0
		
		if (popup_return.items[1] = "COMPLETE") or (popup_return.items[1] = "OK") then
			return 1
		elseif popup_return.items[1] = "CANCEL" then
			return 2
		elseif popup_return.items[1] = "DOLATER" then
			return 3
		elseif popup_return.items[1] = "REVERT" then
			return 4
		elseif popup_return.items[1] = "ERROR" then
			return -1
		else
			return 0
		end if
	else
		setnull(ldt_close_date)
	end if
end if

if upper(ls_assessment_status) = "CANCELLED" then
	if cpr_mode = "CLIENT" then
		// enter the reason for cancellation
		popup.argument_count = 1
		popup.argument[1] = "DELETE_ASSESSMENT"
		popup.title = "Enter the reason:"
		popup.item = ""
		openwithparm(w_pop_prompt_string, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count = 1 then
			ls_reason = popup_return.items[1]
		else
			return 1
		end if
		
		// Prompt once more to make sure
		openwithparm(w_pop_yes_no, "Are you sure you wish to cancel this assessment?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return 1
	else
		log.log(this, "u_component_service_close_assessment.xx_do_service:0078", "The server mode may not cancel an assessment", 4)
		return 1
	end if
end if


li_sts = current_patient.assessments.set_progress(lstr_assessment.problem_id, &
																	lstr_assessment.diagnosis_sequence, &
																	ls_assessment_status, &
																	ls_reason, &
																	ls_severity, &
																	ldt_close_date)


Return 1

end function

on u_component_service_close_assessment.create
call super::create
end on

on u_component_service_close_assessment.destroy
call super::destroy
end on

