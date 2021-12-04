$PBExportHeader$w_referral.srw
forward
global type w_referral from w_window_base
end type
type st_page from statictext within w_referral
end type
type pb_down from picturebutton within w_referral
end type
type pb_up from picturebutton within w_referral
end type
type cb_new_treatment from commandbutton within w_referral
end type
type dw_child_treatments from u_dw_child_treatments within w_referral
end type
type st_description from statictext within w_referral
end type
type sle_description from singlelineedit within w_referral
end type
type cb_finished from commandbutton within w_referral
end type
type cb_be_back from commandbutton within w_referral
end type
type cb_recalculate_description from commandbutton within w_referral
end type
type st_available from statictext within w_referral
end type
type st_when_title from statictext within w_referral
end type
type uo_when from u_st_time within w_referral
end type
type st_asap from statictext within w_referral
end type
type st_emergency from statictext within w_referral
end type
type st_appt_title from statictext within w_referral
end type
type st_approx_title from statictext within w_referral
end type
type st_appointment_date_time from statictext within w_referral
end type
type st_1 from statictext within w_referral
end type
type st_consultant from statictext within w_referral
end type
type uo_consultant from u_consultant within w_referral
end type
type st_title from statictext within w_referral
end type
type st_diagnosis from statictext within w_referral
end type
type st_2 from statictext within w_referral
end type
type uo_referral_assessment from u_st_referral_assessment within w_referral
end type
type st_ruleout from statictext within w_referral
end type
type rb_eval from radiobutton within w_referral
end type
type rb_ruleout from radiobutton within w_referral
end type
type gb_1 from groupbox within w_referral
end type
end forward

global type w_referral from w_window_base
boolean controlmenu = false
windowtype windowtype = response!
string button_type = "COMMAND"
event postopen ( )
st_page st_page
pb_down pb_down
pb_up pb_up
cb_new_treatment cb_new_treatment
dw_child_treatments dw_child_treatments
st_description st_description
sle_description sle_description
cb_finished cb_finished
cb_be_back cb_be_back
cb_recalculate_description cb_recalculate_description
st_available st_available
st_when_title st_when_title
uo_when uo_when
st_asap st_asap
st_emergency st_emergency
st_appt_title st_appt_title
st_approx_title st_approx_title
st_appointment_date_time st_appointment_date_time
st_1 st_1
st_consultant st_consultant
uo_consultant uo_consultant
st_title st_title
st_diagnosis st_diagnosis
st_2 st_2
uo_referral_assessment uo_referral_assessment
st_ruleout st_ruleout
rb_eval rb_eval
rb_ruleout rb_ruleout
gb_1 gb_1
end type
global w_referral w_referral

type variables
long attachment_id

datetime appointment_date_time
real duration_amount
string duration_unit
string original_consultant_id

boolean custom_description

u_component_service service

u_component_treatment treat_referral


String 	referral_question,referral_question_assmnt_desc
String 	attach_flag
String 	appointment_responsible
String 	duration_prn
Date	 	appointment_date


end variables

forward prototypes
public function integer set_screen ()
public function string calculate_description ()
public function integer save_changes ()
end prototypes

event postopen();string ls_description
string ls_Referral_When
string ls_amount
string ls_unit
string ls_temp

appointment_date_time = treat_referral.appointment_date_time
duration_amount = treat_referral.duration_amount
duration_unit = treat_referral.duration_unit
duration_prn = treat_referral.duration_prn

if duration_amount >= 0 and not isnull(duration_unit) then
	uo_when.set_time(duration_amount, duration_unit)
else
	service.get_attribute("Referral When", ls_Referral_When)
	if isnull(ls_Referral_When) then ls_Referral_When = "ASAP"
	CHOOSE CASE upper(ls_Referral_When)
		CASE "ASAP"
			st_asap.triggerevent("clicked")
		CASE "FIRST AVAILABLE"
			st_available.triggerevent("clicked")
		CASE ELSE
			// See if we can interpret as amount and unit
			f_split_string(ls_Referral_When, " ", ls_amount, ls_unit)
			if isnumber(ls_amount) and (upper(ls_unit) = "DAY" or upper(ls_unit) = "DAY" or upper(ls_unit) = "DAY") then
				duration_amount = real(ls_amount)
				duration_unit = ls_unit
				uo_when.set_time(duration_amount, duration_unit)
			else
				uo_when.set_time(1, "DAY")
			end if
	END CHOOSE
end if

dw_child_treatments.initialize(service)
dw_child_treatments.last_page = 0
dw_child_treatments.set_page(1, pb_up, pb_down, st_page)

ls_description = calculate_description()
if ls_description = treat_referral.treatment_description then
	custom_description = false
else
	custom_description = true
	sle_description.text = treat_referral.treatment_description
end if

uo_consultant.set_specialty(treat_referral.specialty_id)

// Referral To ..
ls_temp = current_patient.treatments.get_property_value(treat_referral.treatment_id, "consultant_id")

If isnull(ls_temp)then
	uo_consultant.postevent("clicked")
Else
	uo_consultant.set_consultant(ls_temp)
End If

original_consultant_id = uo_consultant.consultant_id

If isnull(treat_referral.referral_question) Then
	rb_eval.triggerevent("clicked")
Else
	st_ruleout.text = treat_referral.referral_question
	uo_referral_assessment.set_assessment(treat_referral.referral_question_assmnt_id, &
												referral_question_assmnt_desc)
	rb_ruleout.triggerevent("clicked")
End if

if len(uo_consultant.specialty_description) > 0 then
	st_title.text = uo_consultant.specialty_description + " Referral"
else
	st_title.text = "Referral"
end if


set_screen()

end event

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

public function integer save_changes ();integer li_sts


service.treatment.treatment_description = sle_description.text
service.treatment.duration_amount = duration_amount
service.treatment.duration_unit = duration_unit
service.treatment.duration_prn = duration_prn
service.treatment.appointment_date_time = appointment_date_time

service.treatment.referral_question = referral_question
service.treatment.referral_question_assmnt_id = uo_referral_assessment.assessment_id


if f_string_modified(original_consultant_id, uo_consultant.consultant_id) then
	current_patient.treatments.set_treatment_progress(service.treatment_id, "Property", "consultant_id", uo_consultant.consultant_id)
end if

service.treatment.updated = true

current_patient.treatments.update_treatment(service.treatment)
//li_sts = service.treatment.save()
if li_sts < 0 then return -1

return 1

end function

event open;call super::open;///////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description: Set default values
//
// Created By:Mark																				Creation dt: 
//
// Modified By:Sumathi Chinnasamy															Modified On:03/23/2000
///////////////////////////////////////////////////////////////////////////////////////////////////////
str_popup_return popup_return
long ll_menu_id

Setnull(appointment_date_time)
Setnull(duration_unit)
Setnull(duration_amount)

popup_return.item_count = 0

service = Message.powerobjectparm

If isnull(service.treatment) Then
	log.log(this,"w_referral:open","No Treatment Object",4)
	closewithreturn(this, popup_return)
	Return
end if

treat_referral = service.treatment

title = current_patient.id_line()

// Don't offer the "I'll Be Back" option for manual services
if service.manual_service then
	cb_be_back.visible = false
	max_buttons = 4
end if

ll_menu_id = long(service.get_attribute("menu_id"))
paint_menu(ll_menu_id)

postevent("postopen")


end event

on w_referral.create
int iCurrent
call super::create
this.st_page=create st_page
this.pb_down=create pb_down
this.pb_up=create pb_up
this.cb_new_treatment=create cb_new_treatment
this.dw_child_treatments=create dw_child_treatments
this.st_description=create st_description
this.sle_description=create sle_description
this.cb_finished=create cb_finished
this.cb_be_back=create cb_be_back
this.cb_recalculate_description=create cb_recalculate_description
this.st_available=create st_available
this.st_when_title=create st_when_title
this.uo_when=create uo_when
this.st_asap=create st_asap
this.st_emergency=create st_emergency
this.st_appt_title=create st_appt_title
this.st_approx_title=create st_approx_title
this.st_appointment_date_time=create st_appointment_date_time
this.st_1=create st_1
this.st_consultant=create st_consultant
this.uo_consultant=create uo_consultant
this.st_title=create st_title
this.st_diagnosis=create st_diagnosis
this.st_2=create st_2
this.uo_referral_assessment=create uo_referral_assessment
this.st_ruleout=create st_ruleout
this.rb_eval=create rb_eval
this.rb_ruleout=create rb_ruleout
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_page
this.Control[iCurrent+2]=this.pb_down
this.Control[iCurrent+3]=this.pb_up
this.Control[iCurrent+4]=this.cb_new_treatment
this.Control[iCurrent+5]=this.dw_child_treatments
this.Control[iCurrent+6]=this.st_description
this.Control[iCurrent+7]=this.sle_description
this.Control[iCurrent+8]=this.cb_finished
this.Control[iCurrent+9]=this.cb_be_back
this.Control[iCurrent+10]=this.cb_recalculate_description
this.Control[iCurrent+11]=this.st_available
this.Control[iCurrent+12]=this.st_when_title
this.Control[iCurrent+13]=this.uo_when
this.Control[iCurrent+14]=this.st_asap
this.Control[iCurrent+15]=this.st_emergency
this.Control[iCurrent+16]=this.st_appt_title
this.Control[iCurrent+17]=this.st_approx_title
this.Control[iCurrent+18]=this.st_appointment_date_time
this.Control[iCurrent+19]=this.st_1
this.Control[iCurrent+20]=this.st_consultant
this.Control[iCurrent+21]=this.uo_consultant
this.Control[iCurrent+22]=this.st_title
this.Control[iCurrent+23]=this.st_diagnosis
this.Control[iCurrent+24]=this.st_2
this.Control[iCurrent+25]=this.uo_referral_assessment
this.Control[iCurrent+26]=this.st_ruleout
this.Control[iCurrent+27]=this.rb_eval
this.Control[iCurrent+28]=this.rb_ruleout
this.Control[iCurrent+29]=this.gb_1
end on

on w_referral.destroy
call super::destroy
destroy(this.st_page)
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.cb_new_treatment)
destroy(this.dw_child_treatments)
destroy(this.st_description)
destroy(this.sle_description)
destroy(this.cb_finished)
destroy(this.cb_be_back)
destroy(this.cb_recalculate_description)
destroy(this.st_available)
destroy(this.st_when_title)
destroy(this.uo_when)
destroy(this.st_asap)
destroy(this.st_emergency)
destroy(this.st_appt_title)
destroy(this.st_approx_title)
destroy(this.st_appointment_date_time)
destroy(this.st_1)
destroy(this.st_consultant)
destroy(this.uo_consultant)
destroy(this.st_title)
destroy(this.st_diagnosis)
destroy(this.st_2)
destroy(this.uo_referral_assessment)
destroy(this.st_ruleout)
destroy(this.rb_eval)
destroy(this.rb_ruleout)
destroy(this.gb_1)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_referral
integer x = 2830
integer y = 0
boolean originalsize = false
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_referral
integer x = 46
integer y = 1488
end type

type st_page from statictext within w_referral
integer x = 2702
integer y = 1216
integer width = 142
integer height = 128
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Page 99/99"
boolean focusrectangle = false
end type

type pb_down from picturebutton within w_referral
integer x = 2702
integer y = 1092
integer width = 137
integer height = 116
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
alignment htextalign = left!
end type

event clicked;string ls_temp
integer li_page
integer li_last_page

li_page = dw_child_treatments.current_page
li_last_page = dw_child_treatments.last_page

dw_child_treatments.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type pb_up from picturebutton within w_referral
integer x = 2702
integer y = 968
integer width = 137
integer height = 116
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
alignment htextalign = left!
end type

event clicked;string ls_temp
integer li_page

li_page = dw_child_treatments.current_page

dw_child_treatments.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type cb_new_treatment from commandbutton within w_referral
integer x = 343
integer y = 1216
integer width = 480
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add Treatment"
end type

event clicked;integer li_current_page

li_current_page = dw_child_treatments.current_page
if isnull(li_current_page) or li_current_page <= 0 then li_current_page = 1

dw_child_treatments.add_treatment()
dw_child_treatments.last_page = 0
dw_child_treatments.set_page(li_current_page, pb_up, pb_down, st_page)

end event

type dw_child_treatments from u_dw_child_treatments within w_referral
integer x = 837
integer y = 964
integer width = 1856
integer height = 368
integer taborder = 30
end type

type st_description from statictext within w_referral
integer x = 41
integer y = 1388
integer width = 421
integer height = 76
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
string text = "Description"
boolean focusrectangle = false
end type

type sle_description from singlelineedit within w_referral
integer x = 462
integer y = 1384
integer width = 2395
integer height = 96
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;custom_description = true
set_screen()

end event

type cb_finished from commandbutton within w_referral
integer x = 2418
integer y = 1600
integer width = 443
integer height = 108
integer taborder = 40
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
if li_sts < 0 then return

popup_return.item_count = 1
popup_return.items[1] = "COMPLETE"

Closewithreturn(parent, popup_return)

end event

type cb_be_back from commandbutton within w_referral
integer x = 1947
integer y = 1600
integer width = 443
integer height = 108
integer taborder = 50
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
if li_sts < 0 then return

popup_return.item_count = 0

Closewithreturn(parent, popup_return)

end event

type cb_recalculate_description from commandbutton within w_referral
integer x = 1344
integer y = 1492
integer width = 562
integer height = 76
integer taborder = 40
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

type st_available from statictext within w_referral
integer x = 69
integer y = 620
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

type st_when_title from statictext within w_referral
integer x = 73
integer y = 124
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
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Referral When"
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_when from u_st_time within w_referral
event clicked pbm_bnclicked
integer x = 69
integer y = 444
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

type st_asap from statictext within w_referral
integer x = 69
integer y = 856
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

type st_emergency from statictext within w_referral
integer x = 69
integer y = 1032
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

type st_appt_title from statictext within w_referral
integer x = 69
integer y = 212
integer width = 613
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
string text = "Specific Date/Time"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_approx_title from statictext within w_referral
integer x = 69
integer y = 388
integer width = 613
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
string text = "Approximately"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_appointment_date_time from statictext within w_referral
integer x = 69
integer y = 268
integer width = 613
integer height = 112
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

type st_1 from statictext within w_referral
integer x = 841
integer y = 892
integer width = 754
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Followup Treatments"
boolean focusrectangle = false
end type

type st_consultant from statictext within w_referral
integer x = 850
integer y = 320
integer width = 407
integer height = 72
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Consultant:"
alignment alignment = right!
boolean focusrectangle = false
end type

type uo_consultant from u_consultant within w_referral
integer x = 1266
integer y = 304
integer width = 1559
integer height = 104
boolean bringtotop = true
end type

event clicked;call super::clicked;set_screen()

end event

type st_title from statictext within w_referral
integer width = 2898
integer height = 104
boolean bringtotop = true
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Edit Referral"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_diagnosis from statictext within w_referral
integer x = 1266
integer y = 152
integer width = 1559
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_2 from statictext within w_referral
integer x = 837
integer y = 160
integer width = 421
integer height = 72
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Assessment:"
alignment alignment = right!
boolean focusrectangle = false
end type

type uo_referral_assessment from u_st_referral_assessment within w_referral
integer x = 1646
integer y = 668
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

type st_ruleout from statictext within w_referral
integer x = 1161
integer y = 668
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

type rb_eval from radiobutton within w_referral
integer x = 814
integer y = 556
integer width = 658
integer height = 76
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
string text = "Please Evaluate"
end type

event clicked;checked = true
uo_referral_assessment.visible = false
setnull(referral_question)

set_screen()

end event

type rb_ruleout from radiobutton within w_referral
integer x = 814
integer y = 680
integer width = 338
integer height = 96
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
string text = "Please"
end type

event clicked;checked = true
uo_referral_assessment.visible = true
referral_question = st_ruleout.text

set_screen()

end event

type gb_1 from groupbox within w_referral
integer x = 763
integer y = 464
integer width = 2053
integer height = 364
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
string text = "Referral Purpose"
end type

