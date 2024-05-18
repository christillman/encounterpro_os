$PBExportHeader$w_svc_assessment_close.srw
forward
global type w_svc_assessment_close from w_window_base
end type
type st_open_date from statictext within w_svc_assessment_close
end type
type st_open_date_title from statictext within w_svc_assessment_close
end type
type st_2 from statictext within w_svc_assessment_close
end type
type st_close_date from statictext within w_svc_assessment_close
end type
type st_bill_flag from statictext within w_svc_assessment_close
end type
type st_title from statictext within w_svc_assessment_close
end type
type st_bill_flag_title from statictext within w_svc_assessment_close
end type
type st_close_treatments_title from statictext within w_svc_assessment_close
end type
type cb_cancel from commandbutton within w_svc_assessment_close
end type
type cb_close from commandbutton within w_svc_assessment_close
end type
type dw_treatments from u_dw_pick_list within w_svc_assessment_close
end type
type st_outcome_title from statictext within w_svc_assessment_close
end type
type dw_outcome from u_dw_pick_list within w_svc_assessment_close
end type
type st_3 from statictext within w_svc_assessment_close
end type
type sle_comment from singlelineedit within w_svc_assessment_close
end type
type cb_pick_comment from commandbutton within w_svc_assessment_close
end type
type st_leave_open_help from statictext within w_svc_assessment_close
end type
type cb_ill_be_back from commandbutton within w_svc_assessment_close
end type
end forward

global type w_svc_assessment_close from w_window_base
integer width = 2953
integer height = 1856
windowtype windowtype = response!
st_open_date st_open_date
st_open_date_title st_open_date_title
st_2 st_2
st_close_date st_close_date
st_bill_flag st_bill_flag
st_title st_title
st_bill_flag_title st_bill_flag_title
st_close_treatments_title st_close_treatments_title
cb_cancel cb_cancel
cb_close cb_close
dw_treatments dw_treatments
st_outcome_title st_outcome_title
dw_outcome dw_outcome
st_3 st_3
sle_comment sle_comment
cb_pick_comment cb_pick_comment
st_leave_open_help st_leave_open_help
cb_ill_be_back cb_ill_be_back
end type
global w_svc_assessment_close w_svc_assessment_close

type variables
u_component_service service

str_assessment_description assessment

string bill_flag
string outcome

date close_date

string effectiveness_progress_type = "Effectiveness"

string leave_open_text = "<Leave Open>"
end variables

forward prototypes
public function long show_treatments ()
public function integer close_assessment ()
end prototypes

public function long show_treatments ();long ll_treatment_count
str_treatment_description lstra_treatments[]
long ll_count
long i

ll_count = current_patient.treatments.get_assessment_treatments(assessment.problem_id, lstra_treatments)
ll_treatment_count = 0

for i = 1 to ll_count
	if isnull(lstra_treatments[i].treatment_status) or lower(lstra_treatments[i].treatment_status) = "open" then
		ll_treatment_count += 1
		dw_treatments.object.treatment_id[ll_treatment_count] = lstra_treatments[i].treatment_id
		dw_treatments.object.description[ll_treatment_count] = lstra_treatments[i].treatment_description
		if lstra_treatments[i].problem_count > 1 then
			dw_treatments.object.effectiveness[ll_treatment_count] = leave_open_text
		end if
	end if
next

return ll_treatment_count

end function

public function integer close_assessment ();integer i
integer li_sts
string ls_comment
long ll_risk_level
string ls_outcome_comment
string ls_progress_key
string ls_progress
datetime ldt_progress_date_time
long ll_attachment_id
long ll_patient_workplan_item_id
long ll_treatment_id
string ls_effectiveness

setnull(ls_outcome_comment)
setnull(ls_progress_key)
setnull(ls_progress)
ldt_progress_date_time = datetime(today(), now())
setnull(ll_risk_level)
setnull(ll_attachment_id)
setnull(ll_patient_workplan_item_id)

if len(trim(sle_comment.text)) > 0 then
	ls_comment = trim(sle_comment.text)
else
	setnull(ls_comment)
end if

li_sts = f_set_progress(service.cpr_id, &
								"Assessment", &
								assessment.problem_id, &
								"Closed", &
								"Closed", &
								ls_comment, &
								datetime(close_date), &
								ll_risk_level, &
								ll_attachment_id, &
								ll_patient_workplan_item_id)
if li_sts < 0 then return -1

// See if we need to also send a billing message
CHOOSE CASE upper(bill_flag)
	CASE "Y"
		li_sts = f_set_progress(service.cpr_id, &
										"Assessment", &
										assessment.problem_id, &
										"Bill", &
										"Encounter", &
										"Y", &
										ldt_progress_date_time, &
										ll_risk_level, &
										ll_attachment_id, &
										ll_patient_workplan_item_id)
		if li_sts < 0 then return -1
	CASE "N"
		li_sts = f_set_progress(service.cpr_id, &
										"Assessment", &
										assessment.problem_id, &
										"Bill", &
										"Encounter", &
										"N", &
										ldt_progress_date_time, &
										ll_risk_level, &
										ll_attachment_id, &
										ll_patient_workplan_item_id)
		if li_sts < 0 then return -1
END CHOOSE


if len(outcome) > 0 then
	li_sts = f_set_progress(service.cpr_id, &
									"Assessment", &
									assessment.problem_id, &
									"Outcome", &
									outcome, &
									ls_outcome_comment, &
									ldt_progress_date_time, &
									ll_risk_level, &
									ll_attachment_id, &
									ll_patient_workplan_item_id)
end if


// Close the treatments
for i = 1 to dw_treatments.rowcount()
	// Skip the treatment if the user said to leave it open
	ls_effectiveness = dw_treatments.object.effectiveness[i]
	if lower(ls_effectiveness) = lower(leave_open_text) then continue
	
	ll_treatment_id = dw_treatments.object.treatment_id[i]
	f_set_progress(service.cpr_id, &
						"Treatment", &
						ll_treatment_id, &
						"Closed", &
						ls_progress_key, &
						ls_progress, &
						ldt_progress_date_time, &
						ll_risk_level, &
						ll_attachment_id, &
						ll_patient_workplan_item_id)

	if len(ls_effectiveness) > 0 and upper(ls_effectiveness) <> "N/A" then
		li_sts = f_set_progress(service.cpr_id, &
										"Treatment", &
										ll_treatment_id, &
										effectiveness_progress_type, &
										ls_effectiveness, &
										ls_progress, &
										ldt_progress_date_time, &
										ll_risk_level, &
										ll_attachment_id, &
										ll_patient_workplan_item_id)
	end if

next



return 1


end function

event open;call super::open;str_popup popup
str_popup_return popup_return
integer li_sts
long ll_count

popup_return.item_count = 1
popup_return.items[1] = "ERROR"

service = message.powerobjectparm

if service.manual_service then
	cb_ill_be_back.visible = false
end if

if isnull(service.problem_id) then
	log.log(this, "w_svc_assessment_close:open", "Error, no assessment context", 4)
	closewithreturn(this, popup_return)
	return
end if


li_sts = current_patient.assessments.assessment(assessment, service.problem_id)
if li_sts <= 0 then
	log.log(this, "w_svc_assessment_close:open", "Error getting assessment object (" + string(service.problem_id) + ")", 4)
	closewithreturn(this, popup_return)
	return
end if


st_title.text = "Close " + assessment.assessment

title = current_patient.id_line()

setnull(close_date)
setnull(outcome)

if service.encounter_id > 0 then
	SELECT count(*)
	INTO :ll_count
	FROM p_Encounter_Assessment
	WHERE cpr_id = :service.cpr_id
	AND encounter_id = :service.encounter_id
	AND problem_id = :service.problem_id;
	if not tf_check() then
		closewithreturn(this, popup_return)
		return
	end if
	
	if ll_count > 0 then
		st_bill_flag.backcolor = color_object_selected
		st_bill_flag.text = "Yes"
		bill_flag = "Y"
	else
		st_bill_flag.backcolor = color_object
		st_bill_flag.text = "No"
		bill_flag = "N"
	end if
	
	st_open_date.text = string(assessment.begin_date)
	
	close_date = date(current_patient.encounters.encounter_date(service.encounter_id))
else
	st_bill_flag_title.visible = false
	st_bill_flag.visible = false
end if

if isnull(close_date) then close_date = today()
st_close_date.text = string(close_date)

show_treatments()

dw_outcome.object.domain_item_description.width = dw_outcome.width - 50
dw_outcome.settransobject(sqlca)
dw_outcome.retrieve("Assessment Outcome")

st_leave_open_help.text = "* To leave a treatment open, set its effectiveness to ~"" + leave_open_text + "~""

dw_treatments.object.description.width = dw_treatments.width - 603
dw_treatments.object.effectiveness.x = dw_treatments.width - 566
dw_treatments.object.t_effectiveness.x = dw_treatments.width - 566


end event

on w_svc_assessment_close.create
int iCurrent
call super::create
this.st_open_date=create st_open_date
this.st_open_date_title=create st_open_date_title
this.st_2=create st_2
this.st_close_date=create st_close_date
this.st_bill_flag=create st_bill_flag
this.st_title=create st_title
this.st_bill_flag_title=create st_bill_flag_title
this.st_close_treatments_title=create st_close_treatments_title
this.cb_cancel=create cb_cancel
this.cb_close=create cb_close
this.dw_treatments=create dw_treatments
this.st_outcome_title=create st_outcome_title
this.dw_outcome=create dw_outcome
this.st_3=create st_3
this.sle_comment=create sle_comment
this.cb_pick_comment=create cb_pick_comment
this.st_leave_open_help=create st_leave_open_help
this.cb_ill_be_back=create cb_ill_be_back
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_open_date
this.Control[iCurrent+2]=this.st_open_date_title
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_close_date
this.Control[iCurrent+5]=this.st_bill_flag
this.Control[iCurrent+6]=this.st_title
this.Control[iCurrent+7]=this.st_bill_flag_title
this.Control[iCurrent+8]=this.st_close_treatments_title
this.Control[iCurrent+9]=this.cb_cancel
this.Control[iCurrent+10]=this.cb_close
this.Control[iCurrent+11]=this.dw_treatments
this.Control[iCurrent+12]=this.st_outcome_title
this.Control[iCurrent+13]=this.dw_outcome
this.Control[iCurrent+14]=this.st_3
this.Control[iCurrent+15]=this.sle_comment
this.Control[iCurrent+16]=this.cb_pick_comment
this.Control[iCurrent+17]=this.st_leave_open_help
this.Control[iCurrent+18]=this.cb_ill_be_back
end on

on w_svc_assessment_close.destroy
call super::destroy
destroy(this.st_open_date)
destroy(this.st_open_date_title)
destroy(this.st_2)
destroy(this.st_close_date)
destroy(this.st_bill_flag)
destroy(this.st_title)
destroy(this.st_bill_flag_title)
destroy(this.st_close_treatments_title)
destroy(this.cb_cancel)
destroy(this.cb_close)
destroy(this.dw_treatments)
destroy(this.st_outcome_title)
destroy(this.dw_outcome)
destroy(this.st_3)
destroy(this.sle_comment)
destroy(this.cb_pick_comment)
destroy(this.st_leave_open_help)
destroy(this.cb_ill_be_back)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_svc_assessment_close
integer taborder = 20
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_assessment_close
integer x = 59
integer y = 1532
end type

type st_open_date from statictext within w_svc_assessment_close
integer x = 718
integer y = 192
integer width = 558
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
boolean enabled = false
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_open_date_title from statictext within w_svc_assessment_close
integer x = 73
integer y = 200
integer width = 613
integer height = 76
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Open Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_svc_assessment_close
integer x = 73
integer y = 316
integer width = 613
integer height = 76
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Close Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_close_date from statictext within w_svc_assessment_close
integer x = 718
integer y = 308
integer width = 558
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string ls_temp
date ld_temp

ld_temp = close_date

ls_temp = f_select_date(ld_temp, "Appointment Close Date (opened " + st_open_date.text + ")")
if isnull(ls_temp) then return

if ld_temp < date(assessment.begin_date) then
	openwithparm(w_pop_message, "Close Date must be on or after begin date")
	return
end if

close_date = ld_temp
text = ls_temp


end event

type st_bill_flag from statictext within w_svc_assessment_close
event clicked pbm_bnclicked
integer x = 2304
integer y = 196
integer width = 229
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Yes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if bill_flag = "Y" then
	backcolor = color_object
	bill_flag = "N"
	text = "No"
else
	backcolor = color_object_selected
	bill_flag = "Y"
	text = "Yes"
end if


end event

type st_title from statictext within w_svc_assessment_close
integer y = 4
integer width = 2921
integer height = 156
integer textsize = -18
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type st_bill_flag_title from statictext within w_svc_assessment_close
integer x = 1477
integer y = 208
integer width = 809
integer height = 80
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Bill with this Appointment:"
alignment alignment = right!
boolean focusrectangle = false
end type

event clicked;if bill_flag = "Y" then
	bill_flag = "N"
	backcolor = color_object
else
	bill_flag = "Y"
	backcolor = color_object_selected
end if

end event

type st_close_treatments_title from statictext within w_svc_assessment_close
integer x = 73
integer y = 480
integer width = 1851
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Closing this assessment will close these associated treatments:"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_svc_assessment_close
integer x = 73
integer y = 1604
integer width = 521
integer height = 108
integer taborder = 60
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

popup_return.item_count = 1
popup_return.items[1] = "CANCEL"

closewithreturn(parent, popup_return)

end event

type cb_close from commandbutton within w_svc_assessment_close
integer x = 2089
integer y = 1532
integer width = 777
integer height = 180
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Close Assessment"
boolean default = true
end type

event clicked;str_popup_return popup_return
integer li_sts

li_sts = close_assessment()
if li_sts <= 0 then
	openwithparm(w_pop_message, "AN error occured closing the assessment")
	return
end if

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)


end event

type dw_treatments from u_dw_pick_list within w_svc_assessment_close
integer x = 73
integer y = 560
integer width = 1851
integer height = 660
integer taborder = 30
boolean bringtotop = true
string dataobject = "dw_treatments_to_close"
boolean vscrollbar = true
end type

event clicked;call super::clicked;str_popup popup
str_popup_return popup_return
u_user luo_user

popup.dataobject = "dw_domain_notranslate_list"
popup.datacolumn = 2
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = "Treatment Effectiveness"
popup.add_blank_row = true
popup.blank_text = leave_open_text
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	object.effectiveness[row] = leave_open_text
else
	object.effectiveness[row] = popup_return.items[1]
end if


end event

type st_outcome_title from statictext within w_svc_assessment_close
integer x = 2043
integer y = 404
integer width = 713
integer height = 140
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Please rate the outcome of this assessment:"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_outcome from u_dw_pick_list within w_svc_assessment_close
integer x = 2011
integer y = 552
integer width = 791
integer height = 708
integer taborder = 40
boolean bringtotop = true
string dataobject = "dw_domain_pick_list"
boolean border = false
end type

event selected;call super::selected;outcome = object.domain_item[selected_row]

end event

event unselected;call super::unselected;setnull(outcome)

end event

type st_3 from statictext within w_svc_assessment_close
integer x = 78
integer y = 1312
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
string text = "Comment"
boolean focusrectangle = false
end type

type sle_comment from singlelineedit within w_svc_assessment_close
integer x = 78
integer y = 1376
integer width = 2496
integer height = 92
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

type cb_pick_comment from commandbutton within w_svc_assessment_close
integer x = 2583
integer y = 1380
integer width = 165
integer height = 88
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ". . ."
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.title = "Enter comment for closing assessment ~"" + assessment.assessment + "~""
popup.data_row_count = 2
popup.items[1] = "CloseAssessmentComment"
popup.items[2] = ""
openwithparm(w_pick_top_20_multiline, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

sle_comment.text = popup_return.items[1]




end event

type st_leave_open_help from statictext within w_svc_assessment_close
integer x = 78
integer y = 1216
integer width = 1723
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
string text = "* To leave a treatment open, set its effectiveness to ~"<Leave Open>~""
boolean focusrectangle = false
end type

type cb_ill_be_back from commandbutton within w_svc_assessment_close
integer x = 1527
integer y = 1604
integer width = 521
integer height = 108
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I~'ll Be Back"
boolean cancel = true
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

