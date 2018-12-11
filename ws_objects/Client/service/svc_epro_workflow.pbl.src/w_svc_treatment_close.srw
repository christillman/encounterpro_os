$PBExportHeader$w_svc_treatment_close.srw
forward
global type w_svc_treatment_close from w_window_base
end type
type cb_close from commandbutton within w_svc_treatment_close
end type
type st_title from statictext within w_svc_treatment_close
end type
type st_progress_title from statictext within w_svc_treatment_close
end type
type cb_pick_reason from commandbutton within w_svc_treatment_close
end type
type st_treatment_description from statictext within w_svc_treatment_close
end type
type cb_cancel from commandbutton within w_svc_treatment_close
end type
type sle_progress from singlelineedit within w_svc_treatment_close
end type
type st_close_date from statictext within w_svc_treatment_close
end type
type st_close_date_title from statictext within w_svc_treatment_close
end type
type st_eff_progress_title from statictext within w_svc_treatment_close
end type
type sle_effectiveness_progress from singlelineedit within w_svc_treatment_close
end type
type st_effectiveness_title from statictext within w_svc_treatment_close
end type
type cb_pick_effectiveness_comment from commandbutton within w_svc_treatment_close
end type
type st_eff_very_effective from statictext within w_svc_treatment_close
end type
type st_eff_effective from statictext within w_svc_treatment_close
end type
type st_eff_no_effect from statictext within w_svc_treatment_close
end type
type st_eff_adverse from statictext within w_svc_treatment_close
end type
type st_eff_very_adverse from statictext within w_svc_treatment_close
end type
type cb_clear_effectiveness from commandbutton within w_svc_treatment_close
end type
type st_close_progress_required from statictext within w_svc_treatment_close
end type
type st_effectiveness_progress_required from statictext within w_svc_treatment_close
end type
type ln_1 from line within w_svc_treatment_close
end type
type st_cancel_help from statictext within w_svc_treatment_close
end type
type st_assessment from statictext within w_svc_treatment_close
end type
type str_effectiveness from structure within w_svc_treatment_close
end type
end forward

type str_effectiveness from structure
	string		assessment_id
	string		assessment
	string		effectiveness
	string		comment
	boolean		comment_required
end type

global type w_svc_treatment_close from w_window_base
integer width = 2935
integer height = 1912
string title = "Patients Waiting"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
integer max_buttons = 4
cb_close cb_close
st_title st_title
st_progress_title st_progress_title
cb_pick_reason cb_pick_reason
st_treatment_description st_treatment_description
cb_cancel cb_cancel
sle_progress sle_progress
st_close_date st_close_date
st_close_date_title st_close_date_title
st_eff_progress_title st_eff_progress_title
sle_effectiveness_progress sle_effectiveness_progress
st_effectiveness_title st_effectiveness_title
cb_pick_effectiveness_comment cb_pick_effectiveness_comment
st_eff_very_effective st_eff_very_effective
st_eff_effective st_eff_effective
st_eff_no_effect st_eff_no_effect
st_eff_adverse st_eff_adverse
st_eff_very_adverse st_eff_very_adverse
cb_clear_effectiveness cb_clear_effectiveness
st_close_progress_required st_close_progress_required
st_effectiveness_progress_required st_effectiveness_progress_required
ln_1 ln_1
st_cancel_help st_cancel_help
st_assessment st_assessment
end type
global w_svc_treatment_close w_svc_treatment_close

type variables
u_component_service service

string close_progress_type
string close_progress_key
string close_progress
datetime close_progress_date_time

string effectiveness_progress_type = "Effectiveness"
string effectiveness_comment_progress_type = "Effectiveness Comment"

boolean close_progress_required = false

long close_encounter_id
long patient_workplan_item_id
long attachment_id
long risk_level

private str_effectiveness effectiveness_assessment[]
private long effectiveness_assessment_count
private long current_effectiveness_assessment = 0
private string all_assessments


end variables

forward prototypes
public function integer initialize ()
public function integer close_treatment ()
public function boolean check_date (date pd_vaccine_date)
public subroutine set_current_effectiveness_assessment (long pl_current_effectiveness_assessment)
public subroutine set_effectiveness_comment (string ps_comment)
end prototypes

public function integer initialize ();integer li_sts
string ls_progress
string ls_prompt
string ls_default_prompt
integer i
str_assessment_description lstra_assessments[]

setnull(patient_workplan_item_id)
setnull(attachment_id)
setnull(risk_level)
setnull(close_progress_key)

close_progress_date_time = datetime(today(), now())

if isnull(service.treatment) then
	log.log(this, "w_svc_treatment_close.initialize:0016", "Null treatment object", 4)
	return -1
end if

close_progress_type = service.get_attribute("treatment_status")
if isnull(close_progress_type) then close_progress_type = "CLOSED"

CHOOSE CASE upper(close_progress_type)
	CASE "CLOSED"
		st_title.text = "Close Treatment"
		ls_default_prompt = "Enter the reason to close this treatment"
	CASE "CANCELLED"
		st_title.text = "Cancel Treatment"
		ls_default_prompt = "Enter the reason to cancel this treatment"
	CASE ELSE
		st_title.text = wordcap(close_progress_type) + " Treatment"
		ls_default_prompt = "Enter the reason to make this treatment " + wordcap(close_progress_type)
END CHOOSE

cb_close.text = st_title.text

ls_progress = service.get_attribute("progress")
ls_prompt = service.get_attribute("prompt")
if isnull(ls_prompt) then
	ls_prompt = ls_default_prompt
end if


service.get_attribute("prompt_for_progress", close_progress_required)

if isnull(service.encounter_id) then
	if isnull(current_patient.open_encounter_id) then
		log.log(this, "w_svc_treatment_close.initialize:0048", "No open encounter", 4)
		return -1
	else
		close_encounter_id = current_patient.open_encounter_id
	end if
else
	close_encounter_id = service.encounter_id
end if

// If the progress type is "Cancelled" then require a comment
If upper(close_progress_type) = 'CANCELLED' THEN
	If Isnull(ls_progress) THEN
		close_progress_required = true
	end if
	
	ln_1.visible = false
	st_effectiveness_title.visible = false
	cb_clear_effectiveness.visible = false
	sle_effectiveness_progress.visible = false
	st_eff_adverse.visible = false
	st_eff_effective.visible = false
	st_eff_no_effect.visible = false
	st_eff_progress_title.visible = false
	st_eff_very_adverse.visible = false
	st_eff_very_effective.visible = false
	st_effectiveness_progress_required.visible = false
	cb_pick_effectiveness_comment.visible = false

	st_cancel_help.visible = true
end if

if service.treatment.problem_count > 0 then
	if service.treatment.problem_count = 1 then
		st_effectiveness_title.text = "Please rate the effectiveness of this treatment for this assessment:"
		st_assessment.borderstyle = StyleBox!
	else
		st_effectiveness_title.text = "Please rate the effectiveness of this treatment for these assessments:"
		st_assessment.borderstyle = StyleRaised!
	end if
	all_assessments = ""
	effectiveness_assessment_count = current_patient.assessments.get_assessments(service.treatment.problem_count, service.treatment.problem_ids, lstra_assessments)
	
	for i = 1 to effectiveness_assessment_count
		if len(all_assessments) > 0 then all_assessments += ", "
		all_assessments += lstra_assessments[i].assessment
		effectiveness_assessment[i].assessment_id = lstra_assessments[i].assessment_id
		effectiveness_assessment[i].assessment = lstra_assessments[i].assessment
		setnull(effectiveness_assessment[i].effectiveness)
		setnull(effectiveness_assessment[i].comment)
	next
	
	current_effectiveness_assessment = 0
	st_assessment.text = all_assessments
	st_assessment.visible = true
else
	effectiveness_assessment_count = 1
	setnull(effectiveness_assessment[1].assessment_id)
	setnull(effectiveness_assessment[1].assessment)
	setnull(effectiveness_assessment[1].effectiveness)
	setnull(effectiveness_assessment[1].comment)
	st_effectiveness_title.text = "Please rate the effectiveness of this treatment"
	st_assessment.visible = false
end if

close_progress_type = wordcap(close_progress_type)

close_progress = ls_progress

if len(close_progress) > 0 then
	sle_progress.text = close_progress
end if
st_progress_title.text = ls_prompt

if close_progress_required then
	st_close_progress_required.visible = true
end if

Return 1


end function

public function integer close_treatment ();long i
integer li_sts
boolean lb_post_progress_as_property
long ll_null

setnull(ll_null)

service.get_attribute("post_progress_as_property", lb_post_progress_as_property)


li_sts = f_set_progress(current_patient.cpr_id, &
								"Treatment", &
								service.treatment.treatment_id, &
								close_progress_type, &
								close_progress_key, &
								close_progress, &
								close_progress_date_time, &
								risk_level, &
								attachment_id, &
								patient_workplan_item_id)
if li_sts < 0 then return -1

// set the reason for closing as a property
if not isnull(close_progress) and lb_post_progress_as_property then
	li_sts = f_set_progress(current_patient.cpr_id, &
									"Treatment", &
									service.treatment.treatment_id, &
									'PROPERTY', &
									close_progress_type, &
									close_progress, &
									datetime(today(), now()), &
									ll_null, &
									ll_null, &
									ll_null)
end if

// set the effectiveness progress notes
for i = 1 to effectiveness_assessment_count
	if not isnull(effectiveness_assessment[i].effectiveness) then
		li_sts = f_set_progress(current_patient.cpr_id, &
										"Treatment", &
										service.treatment.treatment_id, &
										effectiveness_progress_type, &
										effectiveness_assessment[i].assessment_id, &
										effectiveness_assessment[i].effectiveness, &
										datetime(today(), now()), &
										ll_null, &
										ll_null, &
										ll_null)
	end if
	if not isnull(effectiveness_assessment[i].comment) then
		li_sts = f_set_progress(current_patient.cpr_id, &
										"Treatment", &
										service.treatment.treatment_id, &
										effectiveness_comment_progress_type, &
										effectiveness_assessment[i].assessment_id, &
										effectiveness_assessment[i].comment, &
										datetime(today(), now()), &
										ll_null, &
										ll_null, &
										ll_null)
	end if
next

current_patient.treatments.refresh_status(service.treatment.treatment_id)

Return 1


end function

public function boolean check_date (date pd_vaccine_date);
if pd_vaccine_date < date("1/1/1901") then
	openwithparm(w_pop_message, "Invalid Date.  Date must be later than 1/1/1901.")
	return false
end if

if pd_vaccine_date > today() then
	openwithparm(w_pop_message, "Invalid Date.  Date must not be in the future.")
	return false
end if

return true

end function

public subroutine set_current_effectiveness_assessment (long pl_current_effectiveness_assessment);long i
boolean lb_required
long ll_idx

if isnull(pl_current_effectiveness_assessment) then return
if effectiveness_assessment_count <= 0 then return

if pl_current_effectiveness_assessment <= 0 or pl_current_effectiveness_assessment > effectiveness_assessment_count then
	current_effectiveness_assessment = 0
	
	// For "all assessments", use the predefined concatenation of the assessment descriptions
	st_assessment.text = all_assessments
	
	// For "all assessments", check to see if any of the assessments require a comment
	lb_required = false
	for i = 1 to effectiveness_assessment_count
		if effectiveness_assessment[i].comment_required then
			lb_required = true
			exit
		end if
	next
	st_effectiveness_progress_required.visible = lb_required
	
	// For "all assessments", use the first assessment to populate the comment and select the button
	ll_idx = 1
else
	current_effectiveness_assessment = pl_current_effectiveness_assessment
	st_assessment.text = effectiveness_assessment[current_effectiveness_assessment].assessment
	st_effectiveness_progress_required.visible = effectiveness_assessment[current_effectiveness_assessment].comment_required
	ll_idx = current_effectiveness_assessment
end if

// Set the comment
sle_effectiveness_progress.text = effectiveness_assessment[ll_idx].comment

// Set the selected button
st_eff_very_effective.backcolor = color_object
st_eff_effective.backcolor = color_object
st_eff_no_effect.backcolor = color_object
st_eff_adverse.backcolor = color_object
st_eff_very_adverse.backcolor = color_object

if lower(effectiveness_assessment[ll_idx].effectiveness) = lower(st_eff_very_effective.text) then
	st_eff_very_effective.backcolor = color_object_selected
elseif lower(effectiveness_assessment[ll_idx].effectiveness) = lower(st_eff_effective.text) then
	st_eff_effective.backcolor = color_object_selected
elseif lower(effectiveness_assessment[ll_idx].effectiveness) = lower(st_eff_no_effect.text) then
	st_eff_no_effect.backcolor = color_object_selected
elseif lower(effectiveness_assessment[ll_idx].effectiveness) = lower(st_eff_adverse.text) then
	st_eff_adverse.backcolor = color_object_selected
elseif lower(effectiveness_assessment[ll_idx].effectiveness) = lower(st_eff_very_adverse.text) then
	st_eff_very_adverse.backcolor = color_object_selected
end if

end subroutine

public subroutine set_effectiveness_comment (string ps_comment);long i

if current_effectiveness_assessment > 0 then
	effectiveness_assessment[current_effectiveness_assessment].comment = ps_comment
else
	for i = 1 to effectiveness_assessment_count
		effectiveness_assessment[i].comment = ps_comment
	next
end if


end subroutine

on w_svc_treatment_close.create
int iCurrent
call super::create
this.cb_close=create cb_close
this.st_title=create st_title
this.st_progress_title=create st_progress_title
this.cb_pick_reason=create cb_pick_reason
this.st_treatment_description=create st_treatment_description
this.cb_cancel=create cb_cancel
this.sle_progress=create sle_progress
this.st_close_date=create st_close_date
this.st_close_date_title=create st_close_date_title
this.st_eff_progress_title=create st_eff_progress_title
this.sle_effectiveness_progress=create sle_effectiveness_progress
this.st_effectiveness_title=create st_effectiveness_title
this.cb_pick_effectiveness_comment=create cb_pick_effectiveness_comment
this.st_eff_very_effective=create st_eff_very_effective
this.st_eff_effective=create st_eff_effective
this.st_eff_no_effect=create st_eff_no_effect
this.st_eff_adverse=create st_eff_adverse
this.st_eff_very_adverse=create st_eff_very_adverse
this.cb_clear_effectiveness=create cb_clear_effectiveness
this.st_close_progress_required=create st_close_progress_required
this.st_effectiveness_progress_required=create st_effectiveness_progress_required
this.ln_1=create ln_1
this.st_cancel_help=create st_cancel_help
this.st_assessment=create st_assessment
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_close
this.Control[iCurrent+2]=this.st_title
this.Control[iCurrent+3]=this.st_progress_title
this.Control[iCurrent+4]=this.cb_pick_reason
this.Control[iCurrent+5]=this.st_treatment_description
this.Control[iCurrent+6]=this.cb_cancel
this.Control[iCurrent+7]=this.sle_progress
this.Control[iCurrent+8]=this.st_close_date
this.Control[iCurrent+9]=this.st_close_date_title
this.Control[iCurrent+10]=this.st_eff_progress_title
this.Control[iCurrent+11]=this.sle_effectiveness_progress
this.Control[iCurrent+12]=this.st_effectiveness_title
this.Control[iCurrent+13]=this.cb_pick_effectiveness_comment
this.Control[iCurrent+14]=this.st_eff_very_effective
this.Control[iCurrent+15]=this.st_eff_effective
this.Control[iCurrent+16]=this.st_eff_no_effect
this.Control[iCurrent+17]=this.st_eff_adverse
this.Control[iCurrent+18]=this.st_eff_very_adverse
this.Control[iCurrent+19]=this.cb_clear_effectiveness
this.Control[iCurrent+20]=this.st_close_progress_required
this.Control[iCurrent+21]=this.st_effectiveness_progress_required
this.Control[iCurrent+22]=this.ln_1
this.Control[iCurrent+23]=this.st_cancel_help
this.Control[iCurrent+24]=this.st_assessment
end on

on w_svc_treatment_close.destroy
call super::destroy
destroy(this.cb_close)
destroy(this.st_title)
destroy(this.st_progress_title)
destroy(this.cb_pick_reason)
destroy(this.st_treatment_description)
destroy(this.cb_cancel)
destroy(this.sle_progress)
destroy(this.st_close_date)
destroy(this.st_close_date_title)
destroy(this.st_eff_progress_title)
destroy(this.sle_effectiveness_progress)
destroy(this.st_effectiveness_title)
destroy(this.cb_pick_effectiveness_comment)
destroy(this.st_eff_very_effective)
destroy(this.st_eff_effective)
destroy(this.st_eff_no_effect)
destroy(this.st_eff_adverse)
destroy(this.st_eff_very_adverse)
destroy(this.cb_clear_effectiveness)
destroy(this.st_close_progress_required)
destroy(this.st_effectiveness_progress_required)
destroy(this.ln_1)
destroy(this.st_cancel_help)
destroy(this.st_assessment)
end on

event open;call super::open;str_popup_return popup_return
integer li_sts
boolean lb_show_ui
string ls_temp

popup_return.item_count = 1
popup_return.items[1] = "ERROR"

service = message.powerobjectparm

title = current_patient.id_line()

li_sts = initialize()

st_treatment_description.text = service.treatment.treatment_description
st_close_date.text = string(close_progress_date_time, "[shortdate]")

if gnv_app.cpr_mode = "SERVER" then
	if Isnull(close_progress) and close_progress_required then
		close_progress = "Treatment " + lower(close_progress_type) + " by server"
	end if
	
	li_sts = close_treatment()
	if li_sts < 0 then
		popup_return.items[1] = "ERROR"
	else
		popup_return.items[1] = "OK"
	end if
	
	popup_return.item_count = 1
	closewithreturn(this, popup_return)
	return
end if

ls_temp = service.get_attribute("progress")
if len(ls_temp) > 0 then
	sle_progress.text = ls_temp
end if
 
ls_temp = service.get_attribute("show_ui")
if isnull(ls_temp) then
	ls_temp = sqlca.fn_get_specific_preference('SYSTEM', 'TreatType', service.treatment.treatment_type, 'show_ui_on_close')
end if
lb_show_ui = f_string_to_boolean(ls_temp)

if not lb_show_ui and (len(close_progress) > 0 or not close_progress_required) then
	li_sts = close_treatment()
	if li_sts < 0 then return
	
	popup_return.items[1] = "OK"
	popup_return.item_count = 1
	closewithreturn(this, popup_return)
end if

end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_treatment_close
boolean visible = true
integer x = 2665
integer taborder = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_treatment_close
end type

type cb_close from commandbutton within w_svc_treatment_close
integer x = 2089
integer y = 1600
integer width = 777
integer height = 180
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Close Treatment"
boolean default = true
end type

event clicked;str_popup_return popup_return
integer li_sts
long i

if len(sle_progress.text) > 0 then
	close_progress = sle_progress.text
else
	setnull(close_progress)
end if

if close_progress_required and isnull(close_progress) then
	openwithparm(w_pop_message, "You must " + lower(st_progress_title.text) )
	return
end if


//if len(sle_effectiveness_progress.text) > 0 then
//	effectiveness_progress = sle_effectiveness_progress.text
//else
//	setnull(effectiveness_progress)
//end if

// See if any comments are missing
for i = 1 to effectiveness_assessment_count
	if effectiveness_assessment[i].comment_required then
		if isnull(effectiveness_assessment[i].comment) or trim(effectiveness_assessment[i].comment) = "" then
			openwithparm(w_pop_message, "You must enter a comment when the effectiveness is ~"Adverse~" or ~"Very Adverse~"")
			if current_effectiveness_assessment > 0 then
				set_current_effectiveness_assessment(i)
			end if
			return
		end if
	end if
next

li_sts = close_treatment()
if li_sts < 0 then
	openwithparm(w_pop_message, "Error closing treatment" )
	return
end if	

popup_return.items[1] = "OK"
popup_return.item_count = 1
closewithreturn(parent, popup_return)


end event

type st_title from statictext within w_svc_treatment_close
integer width = 2921
integer height = 120
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Close Treatment"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_progress_title from statictext within w_svc_treatment_close
integer x = 114
integer y = 492
integer width = 1408
integer height = 68
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Enter the reason to close this treatment:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_pick_reason from commandbutton within w_svc_treatment_close
integer x = 2363
integer y = 576
integer width = 425
integer height = 108
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Pick Reason"
boolean default = true
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.argument_count = 1
// Do this for backward compatibilty
if upper(close_progress_type) = 'CANCELLED' then
	popup.argument[1] = "DELETE_TREATMENT"
else
	popup.argument[1] = close_progress_type + "_TREATMENT"
end if
popup.title = st_progress_title.text
popup.item = sle_progress.text

openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count = 1 then
	sle_progress.text = popup_return.items[1]
end if



end event

type st_treatment_description from statictext within w_svc_treatment_close
integer x = 306
integer y = 140
integer width = 2309
integer height = 312
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_svc_treatment_close
integer x = 73
integer y = 1672
integer width = 521
integer height = 108
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;str_popup_return popup_return


popup_return.item_count = 0
closewithreturn(parent, popup_return)


end event

type sle_progress from singlelineedit within w_svc_treatment_close
integer x = 114
integer y = 572
integer width = 2235
integer height = 112
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_close_date from statictext within w_svc_treatment_close
integer x = 1056
integer y = 736
integer width = 809
integer height = 124
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "<None>"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;date ld_close_date
string ls_text

ld_close_date = date(close_progress_date_time)

ls_text = f_select_date(ld_close_date, st_title.text + " Date")
if isnull(ls_text) then return

if not check_date(ld_close_date) then return

close_progress_date_time = datetime(ld_close_date, time(""))

text = ls_text

end event

type st_close_date_title from statictext within w_svc_treatment_close
integer x = 498
integer y = 764
integer width = 535
integer height = 68
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Effective Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_eff_progress_title from statictext within w_svc_treatment_close
integer x = 110
integer y = 1312
integer width = 421
integer height = 68
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Comment:"
boolean focusrectangle = false
end type

type sle_effectiveness_progress from singlelineedit within w_svc_treatment_close
integer x = 101
integer y = 1380
integer width = 2235
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;set_effectiveness_comment(this.text)

end event

type st_effectiveness_title from statictext within w_svc_treatment_close
integer x = 69
integer y = 908
integer width = 2811
integer height = 72
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Please rate the effectiveness of this treatment for this assessment of:"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_pick_effectiveness_comment from commandbutton within w_svc_treatment_close
integer x = 2345
integer y = 1384
integer width = 448
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Pick Comment"
boolean default = true
end type

event clicked;str_popup popup
str_popup_return popup_return
long ll_idx

popup.title = "Treatment Effectiveness Comment"

popup.argument_count = 1
popup.argument[1] = "Trt Effect"

if current_effectiveness_assessment > 0 then
	ll_idx = current_effectiveness_assessment
else
	ll_idx = 1
end if

if len(effectiveness_assessment[ll_idx].effectiveness) > 0 then
	popup.argument[1] += " " + effectiveness_assessment[ll_idx].effectiveness
	popup.title = '"' + effectiveness_assessment[ll_idx].effectiveness + '"' + " Treatment Comment"
end if

popup.item = sle_effectiveness_progress.text

openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count = 1 then
	sle_effectiveness_progress.text = popup_return.items[1]
	set_effectiveness_comment(popup_return.items[1])
end if



end event

type st_eff_very_effective from statictext within w_svc_treatment_close
integer x = 87
integer y = 1156
integer width = 517
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
string text = "Very Effective"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;
st_eff_very_effective.backcolor = color_object_selected
st_eff_effective.backcolor = color_object
st_eff_no_effect.backcolor = color_object
st_eff_adverse.backcolor = color_object
st_eff_very_adverse.backcolor = color_object

long i
boolean lb_comment_required = false

if current_effectiveness_assessment > 0 then
	effectiveness_assessment[current_effectiveness_assessment].effectiveness = this.text
	effectiveness_assessment[current_effectiveness_assessment].comment_required = lb_comment_required
else
	for i = 1 to effectiveness_assessment_count
		effectiveness_assessment[i].effectiveness = this.text
		effectiveness_assessment[i].comment_required = lb_comment_required
	next
end if

st_effectiveness_progress_required.visible = lb_comment_required
sle_effectiveness_progress.setfocus()

end event

type st_eff_effective from statictext within w_svc_treatment_close
integer x = 640
integer y = 1156
integer width = 517
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
string text = "Effective"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;
st_eff_very_effective.backcolor = color_object
st_eff_effective.backcolor = color_object_selected
st_eff_no_effect.backcolor = color_object
st_eff_adverse.backcolor = color_object
st_eff_very_adverse.backcolor = color_object

long i
boolean lb_comment_required = false

if current_effectiveness_assessment > 0 then
	effectiveness_assessment[current_effectiveness_assessment].effectiveness = this.text
	effectiveness_assessment[current_effectiveness_assessment].comment_required = lb_comment_required
else
	for i = 1 to effectiveness_assessment_count
		effectiveness_assessment[i].effectiveness = this.text
		effectiveness_assessment[i].comment_required = lb_comment_required
	next
end if

st_effectiveness_progress_required.visible = lb_comment_required
sle_effectiveness_progress.setfocus()

end event

type st_eff_no_effect from statictext within w_svc_treatment_close
integer x = 1193
integer y = 1156
integer width = 517
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
string text = "No Effect"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;
st_eff_very_effective.backcolor = color_object
st_eff_effective.backcolor = color_object
st_eff_no_effect.backcolor = color_object_selected
st_eff_adverse.backcolor = color_object
st_eff_very_adverse.backcolor = color_object

long i
boolean lb_comment_required = false

if current_effectiveness_assessment > 0 then
	effectiveness_assessment[current_effectiveness_assessment].effectiveness = this.text
	effectiveness_assessment[current_effectiveness_assessment].comment_required = lb_comment_required
else
	for i = 1 to effectiveness_assessment_count
		effectiveness_assessment[i].effectiveness = this.text
		effectiveness_assessment[i].comment_required = lb_comment_required
	next
end if

st_effectiveness_progress_required.visible = lb_comment_required
sle_effectiveness_progress.setfocus()

end event

type st_eff_adverse from statictext within w_svc_treatment_close
integer x = 1746
integer y = 1156
integer width = 517
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
string text = "Adverse"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;
st_eff_very_effective.backcolor = color_object
st_eff_effective.backcolor = color_object
st_eff_no_effect.backcolor = color_object
st_eff_adverse.backcolor = color_object_selected
st_eff_very_adverse.backcolor = color_object

long i
boolean lb_comment_required = true

if current_effectiveness_assessment > 0 then
	effectiveness_assessment[current_effectiveness_assessment].effectiveness = this.text
	effectiveness_assessment[current_effectiveness_assessment].comment_required = lb_comment_required
else
	for i = 1 to effectiveness_assessment_count
		effectiveness_assessment[i].effectiveness = this.text
		effectiveness_assessment[i].comment_required = lb_comment_required
	next
end if

st_effectiveness_progress_required.visible = lb_comment_required
sle_effectiveness_progress.setfocus()

end event

type st_eff_very_adverse from statictext within w_svc_treatment_close
integer x = 2299
integer y = 1156
integer width = 517
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
string text = "Very Adverse"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;
st_eff_very_effective.backcolor = color_object
st_eff_effective.backcolor = color_object
st_eff_no_effect.backcolor = color_object
st_eff_adverse.backcolor = color_object
st_eff_very_adverse.backcolor = color_object_selected

long i
boolean lb_comment_required = true

if current_effectiveness_assessment > 0 then
	effectiveness_assessment[current_effectiveness_assessment].effectiveness = this.text
	effectiveness_assessment[current_effectiveness_assessment].comment_required = lb_comment_required
else
	for i = 1 to effectiveness_assessment_count
		effectiveness_assessment[i].effectiveness = this.text
		effectiveness_assessment[i].comment_required = lb_comment_required
	next
end if

st_effectiveness_progress_required.visible = lb_comment_required
sle_effectiveness_progress.setfocus()

end event

type cb_clear_effectiveness from commandbutton within w_svc_treatment_close
integer x = 1207
integer y = 1532
integer width = 503
integer height = 84
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear Effectiveness"
end type

event clicked;long i

st_eff_very_effective.backcolor = color_object
st_eff_effective.backcolor = color_object
st_eff_no_effect.backcolor = color_object
st_eff_adverse.backcolor = color_object
st_eff_very_adverse.backcolor = color_object

if current_effectiveness_assessment = 0 then
	for i = 1 to effectiveness_assessment_count
		setnull(effectiveness_assessment[i].effectiveness)
		setnull(effectiveness_assessment[i].comment)
	next
else
	setnull(effectiveness_assessment[current_effectiveness_assessment].effectiveness)
	setnull(effectiveness_assessment[current_effectiveness_assessment].comment)
end if

sle_effectiveness_progress.text = ""

end event

type st_close_progress_required from statictext within w_svc_treatment_close
boolean visible = false
integer x = 2144
integer y = 512
integer width = 210
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Required"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_effectiveness_progress_required from statictext within w_svc_treatment_close
boolean visible = false
integer x = 2130
integer y = 1320
integer width = 210
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Required"
alignment alignment = right!
boolean focusrectangle = false
end type

type ln_1 from line within w_svc_treatment_close
integer linethickness = 9
integer beginx = 78
integer beginy = 900
integer endx = 2821
integer endy = 900
end type

type st_cancel_help from statictext within w_svc_treatment_close
boolean visible = false
integer x = 457
integer y = 1144
integer width = 2002
integer height = 236
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Cancelling a treatment tells EncounterPRO that this treatment wasn~'t really ordered and should not be displayed in the chart.  A comment is required (e.g. ~"Entered in error~")."
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_assessment from statictext within w_svc_treatment_close
integer x = 78
integer y = 1000
integer width = 2747
integer height = 84
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
long i
boolean lb_required

if effectiveness_assessment_count <= 1 then return

popup.data_row_count = effectiveness_assessment_count + 1
for i = 1 to effectiveness_assessment_count
	popup.items[i] = effectiveness_assessment[i].assessment
next
popup.items[effectiveness_assessment_count + 1] = "All Assessments"

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

set_current_effectiveness_assessment(popup_return.item_indexes[1])


end event

