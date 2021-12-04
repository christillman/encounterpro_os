$PBExportHeader$w_define_followup.srw
forward
global type w_define_followup from w_window_base
end type
type cb_cancel from commandbutton within w_define_followup
end type
type cb_finished from commandbutton within w_define_followup
end type
type sle_description from singlelineedit within w_define_followup
end type
type st_encounter_type from statictext within w_define_followup
end type
type st_desc from statictext within w_define_followup
end type
type st_title from statictext within w_define_followup
end type
type st_available from statictext within w_define_followup
end type
type st_when_title from statictext within w_define_followup
end type
type uo_when from u_st_time within w_define_followup
end type
type st_asap from statictext within w_define_followup
end type
type st_emergency from statictext within w_define_followup
end type
type st_appt_title from statictext within w_define_followup
end type
type st_approx_title from statictext within w_define_followup
end type
type st_appointment_date_time from statictext within w_define_followup
end type
type cb_recalculate_description from commandbutton within w_define_followup
end type
type st_if from statictext within w_define_followup
end type
type st_ordered_for_title from statictext within w_define_followup
end type
type sle_duration_prn from singlelineedit within w_define_followup
end type
type cb_duration_prn_pick from commandbutton within w_define_followup
end type
type st_treatment_goal_title from statictext within w_define_followup
end type
type sle_treatment_goal from singlelineedit within w_define_followup
end type
type cb_treatment_goal_pick from commandbutton within w_define_followup
end type
type st_ordered_for from statictext within w_define_followup
end type
type st_encounter_type_title from statictext within w_define_followup
end type
type cb_clear_encounter_type from commandbutton within w_define_followup
end type
type cb_clear_ordered_for from commandbutton within w_define_followup
end type
end forward

global type w_define_followup from w_window_base
windowtype windowtype = response!
cb_cancel cb_cancel
cb_finished cb_finished
sle_description sle_description
st_encounter_type st_encounter_type
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
st_if st_if
st_ordered_for_title st_ordered_for_title
sle_duration_prn sle_duration_prn
cb_duration_prn_pick cb_duration_prn_pick
st_treatment_goal_title st_treatment_goal_title
sle_treatment_goal sle_treatment_goal
cb_treatment_goal_pick cb_treatment_goal_pick
st_ordered_for st_ordered_for
st_encounter_type_title st_encounter_type_title
cb_clear_encounter_type cb_clear_encounter_type
cb_clear_ordered_for cb_clear_ordered_for
end type
global w_define_followup w_define_followup

type variables
Datetime appointment_date_time
Real duration_amount
String duration_unit
string ordered_for
string encounter_type

boolean custom_description

u_component_treatment_followup treat_followup
end variables

forward prototypes
public function integer set_screen ()
public function string calculate_description ()
end prototypes

public function integer set_screen ();String		ls_null,ls_followup_description

Setnull(ls_null)

//duration_amount = treat_followup.duration_amount
//duration_unit = treat_followup.duration_unit
//sle_description.text = treat_followup.treatment_description
//followup_workplan_id = treat_followup.followup_workplan_id

//uo_followup_prn.set_prn(treat_followup.duration_prn)
//uo_treatment_goal.set_goal(treat_followup.treatment_goal)
//dw_child_treatments.initialize(treat_followup,"FOLLOWUP")
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

if isnull(ordered_for) then
	st_ordered_for.text = ""
	st_ordered_for.backcolor = color_object
	cb_clear_ordered_for.visible = false
else
	st_ordered_for.text = user_list.user_full_name(ordered_for)
	st_ordered_for.backcolor = user_list.user_color(ordered_for)
	cb_clear_ordered_for.visible = true
end if

if isnull(encounter_type) then
	st_encounter_type.text = ""
	cb_clear_encounter_type.visible = false
else
	st_encounter_type.text = datalist.encounter_type_description(encounter_type)
	cb_clear_encounter_type.visible = true
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

ls_description = "Followup " 

if not isnull(ordered_for) then
	ls_description += user_list.user_short_name(ordered_for) + " "
end if

ls_description += f_appointment_string(appointment_date_time, duration_amount, duration_unit, sle_duration_prn.text)

If len(sle_treatment_goal.text) > 0 then
	ls_description += " for " + lower(sle_treatment_goal.text)
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
Setnull(encounter_type)
Setnull(ordered_for)
duration_amount = 0

If Not Isvalid(Message.powerobjectparm) Then
	log.log(this,"w_define_followup:open","Invalid parameter; Expecting treatment component as it's parameter",4)
	cb_cancel.event clicked()
	Return
End If
treat_followup = Message.powerobjectparm


end event

on w_define_followup.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.cb_finished=create cb_finished
this.sle_description=create sle_description
this.st_encounter_type=create st_encounter_type
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
this.st_if=create st_if
this.st_ordered_for_title=create st_ordered_for_title
this.sle_duration_prn=create sle_duration_prn
this.cb_duration_prn_pick=create cb_duration_prn_pick
this.st_treatment_goal_title=create st_treatment_goal_title
this.sle_treatment_goal=create sle_treatment_goal
this.cb_treatment_goal_pick=create cb_treatment_goal_pick
this.st_ordered_for=create st_ordered_for
this.st_encounter_type_title=create st_encounter_type_title
this.cb_clear_encounter_type=create cb_clear_encounter_type
this.cb_clear_ordered_for=create cb_clear_ordered_for
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.cb_finished
this.Control[iCurrent+3]=this.sle_description
this.Control[iCurrent+4]=this.st_encounter_type
this.Control[iCurrent+5]=this.st_desc
this.Control[iCurrent+6]=this.st_title
this.Control[iCurrent+7]=this.st_available
this.Control[iCurrent+8]=this.st_when_title
this.Control[iCurrent+9]=this.uo_when
this.Control[iCurrent+10]=this.st_asap
this.Control[iCurrent+11]=this.st_emergency
this.Control[iCurrent+12]=this.st_appt_title
this.Control[iCurrent+13]=this.st_approx_title
this.Control[iCurrent+14]=this.st_appointment_date_time
this.Control[iCurrent+15]=this.cb_recalculate_description
this.Control[iCurrent+16]=this.st_if
this.Control[iCurrent+17]=this.st_ordered_for_title
this.Control[iCurrent+18]=this.sle_duration_prn
this.Control[iCurrent+19]=this.cb_duration_prn_pick
this.Control[iCurrent+20]=this.st_treatment_goal_title
this.Control[iCurrent+21]=this.sle_treatment_goal
this.Control[iCurrent+22]=this.cb_treatment_goal_pick
this.Control[iCurrent+23]=this.st_ordered_for
this.Control[iCurrent+24]=this.st_encounter_type_title
this.Control[iCurrent+25]=this.cb_clear_encounter_type
this.Control[iCurrent+26]=this.cb_clear_ordered_for
end on

on w_define_followup.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.cb_finished)
destroy(this.sle_description)
destroy(this.st_encounter_type)
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
destroy(this.st_if)
destroy(this.st_ordered_for_title)
destroy(this.sle_duration_prn)
destroy(this.cb_duration_prn_pick)
destroy(this.st_treatment_goal_title)
destroy(this.sle_treatment_goal)
destroy(this.cb_treatment_goal_pick)
destroy(this.st_ordered_for)
destroy(this.st_encounter_type_title)
destroy(this.cb_clear_encounter_type)
destroy(this.cb_clear_ordered_for)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_define_followup
integer x = 2619
boolean originalsize = false
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_define_followup
end type

type cb_cancel from commandbutton within w_define_followup
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

event clicked;treat_followup.treatment_count = 0
Close(parent)

end event

type cb_finished from commandbutton within w_define_followup
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
	openwithparm(w_pop_message, "You must enter a description for the followup")
	return
End if

treat_followup.treatment_count = 1
treat_followup.treatment_definition[1].item_description = sle_description.text
treat_followup.treatment_definition[1].treatment_type = treat_followup.treatment_type

if not isnull(duration_amount) then
	f_attribute_add_attribute(lstr_attributes, "duration_amount", String(duration_amount))
end if

if len(duration_unit) > 0 then
	f_attribute_add_attribute(lstr_attributes, "duration_unit", duration_unit)
end if

if len(sle_duration_prn.text) > 0 then
	f_attribute_add_attribute(lstr_attributes, "duration_prn", sle_duration_prn.text)
end if

if len(sle_treatment_goal.text) > 0 then
	f_attribute_add_attribute(lstr_attributes, "treatment_goal", sle_treatment_goal.text)
end if

if not isnull(ordered_for) then
	f_attribute_add_attribute(lstr_attributes, "ordered_for", ordered_for)
end if

if not isnull(encounter_type) then
	f_attribute_add_attribute(lstr_attributes, "encounter_type", encounter_type)
end if

if not isnull(appointment_date_time) then
	f_attribute_add_attribute(lstr_attributes, "appointment_date_time", string(appointment_date_time))
end if

treat_followup.treatment_definition[1].attribute_count = f_attribute_str_to_arrays(lstr_attributes, &
																											treat_followup.treatment_definition[1].attribute, &
																											treat_followup.treatment_definition[1].value)

Close(parent)


end event

type sle_description from singlelineedit within w_define_followup
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

type st_encounter_type from statictext within w_define_followup
integer x = 969
integer y = 992
integer width = 1600
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
string ls_encounter_type

popup.data_row_count = 2
popup.items[1] = "PICK"
popup.items[2] = "D" // direct encounter

openwithparm(w_pick_encounter_type, popup)
ls_encounter_type = message.stringparm
if isnull(ls_encounter_type) then return

encounter_type = ls_encounter_type

set_screen()

end event

type st_desc from statictext within w_define_followup
integer x = 23
integer y = 1296
integer width = 421
integer height = 76
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Description"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_title from statictext within w_define_followup
integer y = 4
integer width = 2889
integer height = 120
integer textsize = -20
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Schedule New Followup Visit"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_available from statictext within w_define_followup
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

type st_when_title from statictext within w_define_followup
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
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Followup When"
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_when from u_st_time within w_define_followup
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

type st_asap from statictext within w_define_followup
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

type st_emergency from statictext within w_define_followup
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

type st_appt_title from statictext within w_define_followup
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
long backcolor = COLOR_BACKGROUND
string text = "Specific Date/Time"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_approx_title from statictext within w_define_followup
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
long backcolor = COLOR_BACKGROUND
string text = "Approximately"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_appointment_date_time from statictext within w_define_followup
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
	popup.item = string(treat_followup.appointment_date_time)
end if
popup.title = "Enter Appointment Date/Time"
openwithparm(w_pop_prompt_date_time, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 2 then return

appointment_date_time = datetime(date(popup_return.items[1]), time(popup_return.items[2]))
text = string(appointment_date_time)

set_screen()

end event

type cb_recalculate_description from commandbutton within w_define_followup
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

type st_if from statictext within w_define_followup
integer x = 978
integer y = 220
integer width = 393
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
string text = "Followup If"
boolean focusrectangle = false
end type

type st_ordered_for_title from statictext within w_define_followup
integer x = 978
integer y = 672
integer width = 699
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
string text = "Followup With Provider"
boolean focusrectangle = false
end type

type sle_duration_prn from singlelineedit within w_define_followup
integer x = 969
integer y = 288
integer width = 1600
integer height = 92
integer taborder = 20
boolean bringtotop = true
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

event modified;set_screen()

end event

type cb_duration_prn_pick from commandbutton within w_define_followup
integer x = 2587
integer y = 288
integer width = 133
integer height = 96
integer taborder = 20
boolean bringtotop = true
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
String	ls_null

Setnull(ls_null)
popup.data_row_count = 2
popup.items[1] = "FOLLOWUPPRN"
popup.items[2] = sle_duration_prn.text
popup.title = "Pick Followup Prns"
popup.multiselect = false

openwithparm(w_pick_top_20_multiline, popup, f_active_window())
popup_return = message.powerobjectparm
if popup_return.item_count <= 0 then return

sle_duration_prn.text = popup_return.items[1]

set_screen()

end event

type st_treatment_goal_title from statictext within w_define_followup
integer x = 978
integer y = 444
integer width = 498
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
string text = "Followup Goal"
boolean focusrectangle = false
end type

type sle_treatment_goal from singlelineedit within w_define_followup
integer x = 969
integer y = 516
integer width = 1600
integer height = 92
integer taborder = 30
boolean bringtotop = true
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

event modified;set_screen()

end event

type cb_treatment_goal_pick from commandbutton within w_define_followup
integer x = 2587
integer y = 516
integer width = 133
integer height = 96
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ". . ."
end type

event clicked;str_popup 			popup
str_popup_return 	popup_return
String				ls_null

Setnull(ls_null)
popup.data_row_count = 2
popup.items[1] = "FOLLOWUPGOAL"
popup.items[2] = sle_treatment_goal.text
popup.title = "Pick Treatment Goal"
popup.multiselect = false
openwithparm(w_pick_top_20_multiline, popup, f_active_window())
popup_return = message.powerobjectparm
if popup_return.item_count <= 0 then return

sle_treatment_goal.text = popup_return.items[1]

set_screen()


end event

type st_ordered_for from statictext within w_define_followup
integer x = 969
integer y = 744
integer width = 1600
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

event clicked;u_user luo_user

luo_user = user_list.pick_user(true, false, false)

if isnull(luo_user) then return

ordered_for = luo_user.user_id

set_screen()

end event

type st_encounter_type_title from statictext within w_define_followup
integer x = 978
integer y = 920
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
string text = "Followup Encounter Type"
boolean focusrectangle = false
end type

type cb_clear_encounter_type from commandbutton within w_define_followup
integer x = 2587
integer y = 1032
integer width = 192
integer height = 72
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear"
end type

event clicked;setnull(encounter_type)

set_screen()

end event

type cb_clear_ordered_for from commandbutton within w_define_followup
integer x = 2587
integer y = 784
integer width = 192
integer height = 72
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear"
end type

event clicked;setnull(ordered_for)

set_screen()

end event

