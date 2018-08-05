$PBExportHeader$w_define_referral.srw
forward
global type w_define_referral from w_window_base
end type
type cb_cancel from commandbutton within w_define_referral
end type
type cb_finished from commandbutton within w_define_referral
end type
type sle_description from singlelineedit within w_define_referral
end type
type st_desc from statictext within w_define_referral
end type
type st_title from statictext within w_define_referral
end type
type st_available from statictext within w_define_referral
end type
type st_when_title from statictext within w_define_referral
end type
type uo_when from u_st_time within w_define_referral
end type
type st_asap from statictext within w_define_referral
end type
type st_emergency from statictext within w_define_referral
end type
type st_appt_title from statictext within w_define_referral
end type
type st_approx_title from statictext within w_define_referral
end type
type st_appointment_date_time from statictext within w_define_referral
end type
type cb_recalculate_description from commandbutton within w_define_referral
end type
type st_consultant from statictext within w_define_referral
end type
type uo_consultant from u_consultant within w_define_referral
end type
type uo_referral_assessment from u_st_referral_assessment within w_define_referral
end type
type st_ruleout from statictext within w_define_referral
end type
type rb_eval from radiobutton within w_define_referral
end type
type rb_ruleout from radiobutton within w_define_referral
end type
type st_specialty_t from statictext within w_define_referral
end type
type st_specialty from statictext within w_define_referral
end type
type st_modes from statictext within w_define_referral
end type
type st_review_t from statictext within w_define_referral
end type
type st_referral_wp_t from statictext within w_define_referral
end type
type st_referral_workplan from statictext within w_define_referral
end type
type gb_1 from groupbox within w_define_referral
end type
end forward

global type w_define_referral from w_window_base
windowtype windowtype = response!
cb_cancel cb_cancel
cb_finished cb_finished
sle_description sle_description
st_desc st_desc
st_title st_title
st_available st_available
st_when_title st_when_title
uo_when uo_when
st_asap st_asap
st_emergency st_emergency
st_appt_title st_appt_title
st_approx_title st_approx_title
st_appointment_date_time st_appointment_date_time
cb_recalculate_description cb_recalculate_description
st_consultant st_consultant
uo_consultant uo_consultant
uo_referral_assessment uo_referral_assessment
st_ruleout st_ruleout
rb_eval rb_eval
rb_ruleout rb_ruleout
st_specialty_t st_specialty_t
st_specialty st_specialty
st_modes st_modes
st_review_t st_review_t
st_referral_wp_t st_referral_wp_t
st_referral_workplan st_referral_workplan
gb_1 gb_1
end type
global w_define_referral w_define_referral

type variables
Datetime appointment_date_time
Real duration_amount
String duration_unit

boolean custom_description

date 								appointment_date
string 							referral_question,attach_flag
string 							appointment_responsible,specialty_id
string 							duration_prn
long								referral_workplan_id
String								treatment_mode
u_component_treatment		treat_referral
u_attachment_list 				attachment_list

end variables

forward prototypes
public function integer set_screen ()
public function string calculate_description ()
end prototypes

public function integer set_screen ();String		ls_null,ls_followup_description

Setnull(ls_null)

//duration_amount = treat_referral.duration_amount
//duration_unit = treat_referral.duration_unit
//sle_description.text = treat_referral.treatment_description
//followup_workplan_id = treat_referral.followup_workplan_id

//uo_followup_prn.set_prn(treat_referral.duration_prn)
//uo_treatment_goal.set_goal(treat_referral.treatment_goal)
//dw_child_treatments.initialize(treat_referral,"FOLLOWUP")
//
//// Set the page
//dw_child_treatments.set_page(1, pb_up, pb_down, st_page)

uo_when.backcolor = color_object
st_available.backcolor = color_object
st_asap.backcolor = color_object
st_emergency.backcolor = color_object
st_appointment_date_time.backcolor = color_object

if isnull(appointment_date_time) then
	if not isnull(duration_amount) then
		If duration_amount >= 0 Then
			if isnull(duration_unit) then duration_unit = "DAY"
			uo_when.set_time(duration_amount, duration_unit)
			uo_when.backcolor = color_object_selected
		Else
			setnull(duration_unit)
			CHOOSE CASE duration_amount
				CASE -2
					st_available.backcolor = color_object_selected
				CASE -3
					st_asap.backcolor = color_object_selected
				CASE -99
					st_emergency.backcolor = color_object_selected
				CASE ELSE
					// No other negative values are allowed
					setnull(duration_amount)
			END CHOOSE
		End If
	end if
else
	st_appointment_date_time.text = string(appointment_date_time)
	st_appointment_date_time.backcolor = color_object_selected
end if


if custom_description then
	cb_recalculate_description.visible = true
else
	sle_description.text = calculate_description()
	cb_recalculate_description.visible = false
end if

return 1

end function

public function string calculate_description ();string ls_description
string ls_specialty_id

if len(uo_consultant.consultant_id) > 0 then
	ls_specialty_id = user_list.user_property(uo_consultant.consultant_id, "specialty_id")
	ls_description = datalist.specialty_description(ls_specialty_id) + " Referral "
	if isnull(ls_description) then ls_description = ""
elseif len(uo_consultant.specialty_description) > 0 then
	ls_description = uo_consultant.specialty_description + " Referral "
else
	ls_description = "Referral "
end if

if not isnull(duration_amount) and not isnull(duration_unit) then
	ls_description = ls_description + "in " + lower(f_pretty_amount_unit(duration_amount, duration_unit)) + " "
end if

if len(duration_prn) > 0 then
	ls_description = ls_description + lower(duration_prn) + " "
end if

if isnull(referral_question) or isnull(uo_referral_assessment.assessment_id) then
	ls_description = ls_description + "for evaluation "
else
	ls_description = ls_description + "to " + lower(referral_question) + " " + lower(uo_referral_assessment.text) + " "
end if

return trim(ls_description)



end function

event open;call super::open;///////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description: Set default values
//
// Created By:Mark																				Creation dt: 
//
// Modified By:Sumathi Chinnasamy															Modified On:03/23/2000
///////////////////////////////////////////////////////////////////////////////////////////////////////
String			ls_null

Setnull(ls_null)
Setnull(appointment_date_time)
Setnull(duration_unit)
Setnull(referral_workplan_id)
duration_amount = -3  // ASAP

If Not Isvalid(Message.powerobjectparm) Then
	log.log(this,"w_define_referral:open","Invalid parameter; Expecting treatment component as it's parameter",4)
	cb_cancel.event clicked()
	Return
End If
treat_referral = Message.powerobjectparm

postevent("post_open")
end event

on w_define_referral.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.cb_finished=create cb_finished
this.sle_description=create sle_description
this.st_desc=create st_desc
this.st_title=create st_title
this.st_available=create st_available
this.st_when_title=create st_when_title
this.uo_when=create uo_when
this.st_asap=create st_asap
this.st_emergency=create st_emergency
this.st_appt_title=create st_appt_title
this.st_approx_title=create st_approx_title
this.st_appointment_date_time=create st_appointment_date_time
this.cb_recalculate_description=create cb_recalculate_description
this.st_consultant=create st_consultant
this.uo_consultant=create uo_consultant
this.uo_referral_assessment=create uo_referral_assessment
this.st_ruleout=create st_ruleout
this.rb_eval=create rb_eval
this.rb_ruleout=create rb_ruleout
this.st_specialty_t=create st_specialty_t
this.st_specialty=create st_specialty
this.st_modes=create st_modes
this.st_review_t=create st_review_t
this.st_referral_wp_t=create st_referral_wp_t
this.st_referral_workplan=create st_referral_workplan
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.cb_finished
this.Control[iCurrent+3]=this.sle_description
this.Control[iCurrent+4]=this.st_desc
this.Control[iCurrent+5]=this.st_title
this.Control[iCurrent+6]=this.st_available
this.Control[iCurrent+7]=this.st_when_title
this.Control[iCurrent+8]=this.uo_when
this.Control[iCurrent+9]=this.st_asap
this.Control[iCurrent+10]=this.st_emergency
this.Control[iCurrent+11]=this.st_appt_title
this.Control[iCurrent+12]=this.st_approx_title
this.Control[iCurrent+13]=this.st_appointment_date_time
this.Control[iCurrent+14]=this.cb_recalculate_description
this.Control[iCurrent+15]=this.st_consultant
this.Control[iCurrent+16]=this.uo_consultant
this.Control[iCurrent+17]=this.uo_referral_assessment
this.Control[iCurrent+18]=this.st_ruleout
this.Control[iCurrent+19]=this.rb_eval
this.Control[iCurrent+20]=this.rb_ruleout
this.Control[iCurrent+21]=this.st_specialty_t
this.Control[iCurrent+22]=this.st_specialty
this.Control[iCurrent+23]=this.st_modes
this.Control[iCurrent+24]=this.st_review_t
this.Control[iCurrent+25]=this.st_referral_wp_t
this.Control[iCurrent+26]=this.st_referral_workplan
this.Control[iCurrent+27]=this.gb_1
end on

on w_define_referral.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.cb_finished)
destroy(this.sle_description)
destroy(this.st_desc)
destroy(this.st_title)
destroy(this.st_available)
destroy(this.st_when_title)
destroy(this.uo_when)
destroy(this.st_asap)
destroy(this.st_emergency)
destroy(this.st_appt_title)
destroy(this.st_approx_title)
destroy(this.st_appointment_date_time)
destroy(this.cb_recalculate_description)
destroy(this.st_consultant)
destroy(this.uo_consultant)
destroy(this.uo_referral_assessment)
destroy(this.st_ruleout)
destroy(this.rb_eval)
destroy(this.rb_ruleout)
destroy(this.st_specialty_t)
destroy(this.st_specialty)
destroy(this.st_modes)
destroy(this.st_review_t)
destroy(this.st_referral_wp_t)
destroy(this.st_referral_workplan)
destroy(this.gb_1)
end on

event post_open;call super::post_open;String						ls_null
Integer						li_sts
str_progress 	lstr_progress

IF isnull(treat_referral.specialty_id) THEN
	specialty_id = f_pick_specialty("")
	IF isnull(specialty_id) THEN
		cb_cancel.event clicked()
		Return
	End If
	st_specialty.text = datalist.specialty_description(specialty_id)
End If

uo_consultant.set_specialty(specialty_id)
//uo_consultant.postevent("clicked")

set_screen()



end event

type pb_epro_help from w_window_base`pb_epro_help within w_define_referral
integer x = 2830
integer y = 0
boolean originalsize = false
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_define_referral
end type

type cb_cancel from commandbutton within w_define_referral
integer x = 32
integer y = 1600
integer width = 443
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

event clicked;treat_referral.treatment_count = 0
Close(parent)

end event

type cb_finished from commandbutton within w_define_referral
integer x = 2405
integer y = 1600
integer width = 443
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
end type

event clicked;///////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description: Return values based on treatment mode.
//
// Created By:Mark																				Creation dt: 
//
// Modified By:Sumathi Chinnasamy															Modified On:03/23/2000
///////////////////////////////////////////////////////////////////////////////////////////////////////

Integer							li_null,i
Date								ld_null
String							ls_null, ls_description
// user defined
str_popup_return				popup_return
str_item_definition 			lstr_treatment_definition
str_attributes lstr_attributes

Setnull(ld_null)
Setnull(ls_null)
Setnull(li_null)

If Isnull(sle_description.text) Or Len(sle_description.text) = 0 Then
	openwithparm(w_pop_message, "You must enter a description for the referral")
	return
End if

treat_referral.treatment_count = 1
treat_referral.treatment_definition[1].item_description = sle_description.text
treat_referral.treatment_definition[1].treatment_type = treat_referral.treatment_type

if not isnull(duration_amount) then
	f_attribute_add_attribute(lstr_attributes, "duration_amount", String(duration_amount))
end if

if len(duration_unit) > 0 then
	f_attribute_add_attribute(lstr_attributes, "duration_unit", duration_unit)
end if

if len(duration_prn) > 0 then
	f_attribute_add_attribute(lstr_attributes, "duration_prn", duration_prn)
end if

if len(referral_question) > 0 then
	f_attribute_add_attribute(lstr_attributes, "referral_question", referral_question)
end if

if len(uo_referral_assessment.assessment_id) > 0 then
	f_attribute_add_attribute(lstr_attributes, "referral_question_assmnt_id", uo_referral_assessment.assessment_id)
end if

if referral_workplan_id > 0 then
	f_attribute_add_attribute(lstr_attributes, "referral_workplan_id", string(referral_workplan_id))
end if

if len(specialty_id) > 0 then
	f_attribute_add_attribute(lstr_attributes, "specialty_id", specialty_id)
end if

if len(treatment_mode) > 0 then
	f_attribute_add_attribute(lstr_attributes, "treatment_mode", treatment_mode)
end if

if len(uo_consultant.consultant_id) > 0 then
	f_attribute_add_attribute(lstr_attributes, "consultant_id", uo_consultant.consultant_id)
end if

if not isnull(appointment_date_time) then
	f_attribute_add_attribute(lstr_attributes, "appointment_date_time", string(appointment_date_time))
end if

treat_referral.treatment_definition[1].attribute_count = f_attribute_str_to_arrays(lstr_attributes, &
																											treat_referral.treatment_definition[1].attribute, &
																											treat_referral.treatment_definition[1].value)

Close(parent)


end event

type sle_description from singlelineedit within w_define_referral
integer x = 457
integer y = 1292
integer width = 2391
integer height = 92
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 80
borderstyle borderstyle = stylelowered!
end type

event modified;custom_description = true
set_screen()

end event

type st_desc from statictext within w_define_referral
integer x = 23
integer y = 1296
integer width = 421
integer height = 76
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Description"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_title from statictext within w_define_referral
integer width = 2889
integer height = 104
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Order Referral"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_available from statictext within w_define_referral
integer x = 110
integer y = 628
integer width = 613
integer height = 172
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "First Available Appointment"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;
duration_amount = -2
setnull(duration_unit)
setnull(appointment_date_time)

set_screen()

end event

type st_when_title from statictext within w_define_referral
integer x = 114
integer y = 132
integer width = 613
integer height = 80
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 33538240
boolean enabled = false
string text = "Referral When"
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_when from u_st_time within w_define_referral
integer x = 110
integer y = 452
integer height = 112
boolean bringtotop = true
boolean disabledlook = true
end type

event clicked;call super::clicked;
duration_amount = amount
duration_unit = unit
setnull(appointment_date_time)

set_screen()


end event

type st_asap from statictext within w_define_referral
integer x = 110
integer y = 864
integer width = 613
integer height = 112
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "ASAP"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;
duration_amount = -3
setnull(duration_unit)
setnull(appointment_date_time)

set_screen()

end event

type st_emergency from statictext within w_define_referral
integer x = 110
integer y = 1040
integer width = 613
integer height = 112
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Emergency"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;
duration_amount = -99
setnull(duration_unit)
setnull(appointment_date_time)

set_screen()

end event

type st_appt_title from statictext within w_define_referral
integer x = 110
integer y = 220
integer width = 613
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Specific Date/Time"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_approx_title from statictext within w_define_referral
integer x = 110
integer y = 396
integer width = 613
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Approximately"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_appointment_date_time from statictext within w_define_referral
integer x = 110
integer y = 276
integer width = 613
integer height = 112
boolean bringtotop = true
integer textsize = -12
integer weight = 700
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

if isnull(appointment_date_time) then
	if len(text) > 0 then
		popup.item = text
	else
		setnull(popup.item)
	end if
else
	popup.item = string(treat_referral.appointment_date_time)
end if
popup.title = "Enter Appointment Date/Time"
openwithparm(w_pop_prompt_date_time, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 2 then return

appointment_date_time = datetime(date(popup_return.items[1]), time(popup_return.items[2]))
text = string(appointment_date_time)

set_screen()

end event

type cb_recalculate_description from commandbutton within w_define_referral
integer x = 1307
integer y = 1400
integer width = 562
integer height = 76
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recalculate Description"
end type

event clicked;custom_description = false
set_screen()

end event

type st_consultant from statictext within w_define_referral
integer x = 992
integer y = 312
integer width = 407
integer height = 72
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Consultant:"
alignment alignment = right!
boolean focusrectangle = false
end type

type uo_consultant from u_consultant within w_define_referral
integer x = 1422
integer y = 292
integer width = 1362
integer height = 112
boolean bringtotop = true
end type

event clicked;call super::clicked;set_screen()

end event

type uo_referral_assessment from u_st_referral_assessment within w_define_referral
integer x = 1659
integer y = 644
integer width = 1125
integer height = 96
boolean bringtotop = true
integer textsize = -10
fontcharset fontcharset = ansi!
boolean enabled = true
end type

event clicked;w_find_assessment     lw_find_assessment
string ls_assessment_id
str_popup popup

// By Sumathi Chinnasamy On 12/23/99
// Created an instance of window type to avoid hanging apps. if
// the same window is opened more than once.
popup.data_row_count = 2
popup.items[1] = "SICK"
popup.items[2] = "RFASS|"
if not isnull(treat_referral.specialty_id) then popup.items[2] += treat_referral.specialty_id

openwithparm(lw_find_assessment, popup, "w_find_assessment")
ls_assessment_id = message.stringparm
if isnull(ls_assessment_id) or trim(ls_assessment_id) = "" then return

set_assessment(ls_assessment_id, datalist.assessment_description(ls_assessment_id))
rb_ruleout.triggerevent("clicked")



end event

type st_ruleout from statictext within w_define_referral
integer x = 1175
integer y = 644
integer width = 439
integer height = 96
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Evaluate For"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.data_row_count = 2
popup.items[1] = "Rule Out"
popup.items[2] = "Evaluate For"

openwithparm(w_pop_pick, popup)

popup_return = message.powerobjectparm
if popup_return.item_index > 0 then	
	text = popup.items[popup_return.item_index]
	rb_ruleout.triggerevent("clicked")
end if


end event

type rb_eval from radiobutton within w_define_referral
integer x = 827
integer y = 532
integer width = 658
integer height = 76
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Please Evaluate"
end type

event clicked;checked = true
uo_referral_assessment.visible = false
setnull(referral_question)

set_screen()

end event

type rb_ruleout from radiobutton within w_define_referral
integer x = 827
integer y = 656
integer width = 338
integer height = 96
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Please"
end type

event clicked;checked = true
uo_referral_assessment.visible = true
referral_question = st_ruleout.text

set_screen()

end event

type st_specialty_t from statictext within w_define_referral
integer x = 1047
integer y = 176
integer width = 352
integer height = 72
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Specialty"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_specialty from statictext within w_define_referral
integer x = 1422
integer y = 156
integer width = 1362
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string ls_specialty_id

ls_specialty_id = f_pick_specialty("")
if isnull(ls_specialty_id) then return

specialty_id = ls_specialty_id
text = datalist.specialty_description(specialty_id)

uo_consultant.set_specialty(specialty_id)
uo_consultant.event clicked()


end event

type st_modes from statictext within w_define_referral
integer x = 1422
integer y = 1088
integer width = 1362
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
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

event clicked;Long					ll_rows
Integer				i,j
String   			ls_default_workplan,ls_preference_id
Datastore 			lds_datastore
str_popup			popup
str_popup_return 	popup_return


lds_datastore = Create datastore
lds_datastore.dataobject = "dw_treatment_mode_pick"
lds_datastore.Settransobject(SQLCA)
ll_rows = lds_datastore.retrieve(treat_referral.treatment_type)
If ll_rows > 0 Then // if any treatment modes
	SELECT wp.description
	INTO :ls_default_workplan
	From c_Treatment_Type tt,c_Workplan wp	
	Where tt.workplan_id = wp.workplan_id
	And tt.treatment_type = :treat_referral.treatment_type;
		
	If Not isnull(ls_default_workplan) and len(ls_default_workplan) > 0 Then
		i++
		popup.items[i] = ls_default_workplan
	End if
	For j = 1 To ll_rows
		i++
		popup.items[i] = lds_datastore.object.treatment_mode[j]
	Next
	i++
	popup.items[i] = "<None>"
	popup.data_row_count = i
	popup.auto_singleton = True
	openwithparm(w_pop_pick, popup)
	popup_return = message.powerobjectparm
	If popup_return.item_count <> 1 Then Return
	
	If popup_return.items[1] = "<None>" Then
		text = ""
		Setnull(treatment_mode)
	Else
		treatment_mode = popup_return.items[1]
		text = treatment_mode
		datalist.update_preference("REFERRAL", "Global", "Global", ls_preference_id, popup_return.items[1])
	End If
Else
	text = ""
	Setnull(treatment_mode)
End If
Destroy lds_datastore
end event

type st_review_t from statictext within w_define_referral
integer x = 965
integer y = 1104
integer width = 434
integer height = 84
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Modes"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_referral_wp_t from statictext within w_define_referral
integer x = 773
integer y = 908
integer width = 626
integer height = 72
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Referral Workplan:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_referral_workplan from statictext within w_define_referral
integer x = 1422
integer y = 888
integer width = 1362
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup			popup
str_popup_return	popup_return

popup.dataobject = "dw_followup_workplan_list"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = "Referral"
popup.add_blank_row = true

Openwithparm(w_pop_pick, popup)
popup_return = Message.powerobjectparm
If popup_return.item_count <> 1 Then Return
referral_workplan_id = Long(popup_return.items[1])
text = popup_return.descriptions[1]

end event

type gb_1 from groupbox within w_define_referral
integer x = 777
integer y = 440
integer width = 2053
integer height = 364
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Referral Purpose"
end type

