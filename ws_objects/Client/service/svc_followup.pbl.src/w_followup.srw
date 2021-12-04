$PBExportHeader$w_followup.srw
forward
global type w_followup from w_window_base
end type
type st_page from statictext within w_followup
end type
type pb_down from picturebutton within w_followup
end type
type pb_up from picturebutton within w_followup
end type
type cb_new_treatment from commandbutton within w_followup
end type
type dw_child_treatments from u_dw_child_treatments within w_followup
end type
type st_description from statictext within w_followup
end type
type sle_description from singlelineedit within w_followup
end type
type st_title from statictext within w_followup
end type
type cb_finished from commandbutton within w_followup
end type
type cb_be_back from commandbutton within w_followup
end type
type cb_recalculate_description from commandbutton within w_followup
end type
type st_available from statictext within w_followup
end type
type st_when_title from statictext within w_followup
end type
type uo_when from u_st_time within w_followup
end type
type st_asap from statictext within w_followup
end type
type st_emergency from statictext within w_followup
end type
type st_appt_title from statictext within w_followup
end type
type st_approx_title from statictext within w_followup
end type
type st_appointment_date_time from statictext within w_followup
end type
type st_encounter_type from statictext within w_followup
end type
type st_if from statictext within w_followup
end type
type st_ordered_for_title from statictext within w_followup
end type
type sle_duration_prn from singlelineedit within w_followup
end type
type st_treatment_goal_title from statictext within w_followup
end type
type sle_treatment_goal from singlelineedit within w_followup
end type
type st_ordered_for from statictext within w_followup
end type
type st_encounter_type_title from statictext within w_followup
end type
type cb_duration_prn_pick from commandbutton within w_followup
end type
type cb_treatment_goal_pick from commandbutton within w_followup
end type
type st_1 from statictext within w_followup
end type
type cb_clear_ordered_for from commandbutton within w_followup
end type
type cb_clear_encounter_type from commandbutton within w_followup
end type
type st_display_only from statictext within w_followup
end type
end forward

global type w_followup from w_window_base
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
st_title st_title
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
st_encounter_type st_encounter_type
st_if st_if
st_ordered_for_title st_ordered_for_title
sle_duration_prn sle_duration_prn
st_treatment_goal_title st_treatment_goal_title
sle_treatment_goal sle_treatment_goal
st_ordered_for st_ordered_for
st_encounter_type_title st_encounter_type_title
cb_duration_prn_pick cb_duration_prn_pick
cb_treatment_goal_pick cb_treatment_goal_pick
st_1 st_1
cb_clear_ordered_for cb_clear_ordered_for
cb_clear_encounter_type cb_clear_encounter_type
st_display_only st_display_only
end type
global w_followup w_followup

type variables
long attachment_id

datetime appointment_date_time
real duration_amount
string duration_unit
string ordered_for
string original_encounter_type
string encounter_type

boolean custom_description

u_component_service service

u_component_treatment treat_followup


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

appointment_date_time = treat_followup.appointment_date_time
duration_amount = treat_followup.duration_amount
duration_unit = treat_followup.duration_unit

if duration_amount >= 0 and not isnull(duration_unit) then
	uo_when.set_time(duration_amount, duration_unit)
else
	service.get_attribute("Referral When", ls_Referral_When)
	if isnull(ls_Referral_When) then ls_Referral_When = "1 DAY"
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

sle_duration_prn.text = treat_followup.duration_prn

sle_treatment_goal.text = treat_followup.treatment_goal

encounter_type = f_get_progress_value(current_patient.cpr_id, &
													"Treatment", &
													treat_followup.treatment_id, &
													"Property", &
													"encounter_type")
original_encounter_type = encounter_type

ordered_for = treat_followup.ordered_for

dw_child_treatments.initialize(service)
dw_child_treatments.last_page = 0
dw_child_treatments.set_page(1, pb_up, pb_down, st_page)

ls_description = calculate_description()
if ls_description = treat_followup.treatment_description then
	custom_description = false
else
	custom_description = true
	sle_description.text = treat_followup.treatment_description
end if

set_screen()

end event

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


// If treatment is closed then nothing can be edited
if upper(treat_followup.treatment_status) = "OPEN" OR isnull(treat_followup.treatment_status) then
	uo_when.enabled = true
	st_available.enabled = true
	st_asap.enabled = true
	st_emergency.enabled = true
	st_appointment_date_time.enabled = true
	st_encounter_type.enabled = true
	st_ordered_for.enabled = true
	
	cb_new_treatment.visible = true
	cb_recalculate_description.visible = true
	cb_clear_encounter_type.visible = true
	cb_clear_ordered_for.visible = true
	cb_duration_prn_pick.visible = true
	cb_treatment_goal_pick.visible = true
	
	dw_child_treatments.enabled = true
	
	sle_description.enabled = true
	sle_duration_prn.enabled = true
	sle_treatment_goal.enabled = true
	
	st_display_only.visible = false
else
	uo_when.enabled = false
	st_available.enabled = false
	st_asap.enabled = false
	st_emergency.enabled = false
	st_appointment_date_time.enabled = false
	st_encounter_type.enabled = false
	st_ordered_for.enabled = false
	
	cb_new_treatment.visible = false
	cb_recalculate_description.visible = false
	cb_clear_encounter_type.visible = false
	cb_clear_ordered_for.visible = false
	cb_duration_prn_pick.visible = false
	cb_treatment_goal_pick.visible = false
	
	dw_child_treatments.enabled = false
	
	sle_description.enabled = false
	sle_duration_prn.enabled = false
	sle_treatment_goal.enabled = false
	
	if upper(treat_followup.treatment_status) = "CLOSED" then
		st_display_only.text = "Display Only - Followup Has Already Been Dispatched"
	else
		st_display_only.text = "Display Only - Followup Has Already Been " + wordcap(treat_followup.treatment_status)
	end if
	st_display_only.visible = true
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

public function integer save_changes ();integer li_sts


service.treatment.treatment_description = sle_description.text
service.treatment.duration_amount = duration_amount
service.treatment.duration_unit = duration_unit
service.treatment.appointment_date_time = appointment_date_time

if len(sle_duration_prn.text) > 0 then
	service.treatment.duration_prn = sle_duration_prn.text
else
	setnull(service.treatment.duration_prn)
end if

if len(sle_treatment_goal.text) > 0 then
	service.treatment.treatment_goal = sle_treatment_goal.text
else
	setnull(service.treatment.treatment_goal)
end if

service.treatment.ordered_for = ordered_for

if f_string_modified(original_encounter_type, encounter_type) then
	current_patient.treatments.set_treatment_progress(service.treatment_id, "Property", "encounter_type", encounter_type)
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
Setnull(encounter_type)
Setnull(ordered_for)

popup_return.item_count = 0

service = Message.powerobjectparm

If isnull(service.treatment) Then
	log.log(this,"w_followup:open","No Treatment Object",4)
	closewithreturn(this, popup_return)
	Return
end if

treat_followup = service.treatment

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

on w_followup.create
int iCurrent
call super::create
this.st_page=create st_page
this.pb_down=create pb_down
this.pb_up=create pb_up
this.cb_new_treatment=create cb_new_treatment
this.dw_child_treatments=create dw_child_treatments
this.st_description=create st_description
this.sle_description=create sle_description
this.st_title=create st_title
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
this.st_encounter_type=create st_encounter_type
this.st_if=create st_if
this.st_ordered_for_title=create st_ordered_for_title
this.sle_duration_prn=create sle_duration_prn
this.st_treatment_goal_title=create st_treatment_goal_title
this.sle_treatment_goal=create sle_treatment_goal
this.st_ordered_for=create st_ordered_for
this.st_encounter_type_title=create st_encounter_type_title
this.cb_duration_prn_pick=create cb_duration_prn_pick
this.cb_treatment_goal_pick=create cb_treatment_goal_pick
this.st_1=create st_1
this.cb_clear_ordered_for=create cb_clear_ordered_for
this.cb_clear_encounter_type=create cb_clear_encounter_type
this.st_display_only=create st_display_only
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_page
this.Control[iCurrent+2]=this.pb_down
this.Control[iCurrent+3]=this.pb_up
this.Control[iCurrent+4]=this.cb_new_treatment
this.Control[iCurrent+5]=this.dw_child_treatments
this.Control[iCurrent+6]=this.st_description
this.Control[iCurrent+7]=this.sle_description
this.Control[iCurrent+8]=this.st_title
this.Control[iCurrent+9]=this.cb_finished
this.Control[iCurrent+10]=this.cb_be_back
this.Control[iCurrent+11]=this.cb_recalculate_description
this.Control[iCurrent+12]=this.st_available
this.Control[iCurrent+13]=this.st_when_title
this.Control[iCurrent+14]=this.uo_when
this.Control[iCurrent+15]=this.st_asap
this.Control[iCurrent+16]=this.st_emergency
this.Control[iCurrent+17]=this.st_appt_title
this.Control[iCurrent+18]=this.st_approx_title
this.Control[iCurrent+19]=this.st_appointment_date_time
this.Control[iCurrent+20]=this.st_encounter_type
this.Control[iCurrent+21]=this.st_if
this.Control[iCurrent+22]=this.st_ordered_for_title
this.Control[iCurrent+23]=this.sle_duration_prn
this.Control[iCurrent+24]=this.st_treatment_goal_title
this.Control[iCurrent+25]=this.sle_treatment_goal
this.Control[iCurrent+26]=this.st_ordered_for
this.Control[iCurrent+27]=this.st_encounter_type_title
this.Control[iCurrent+28]=this.cb_duration_prn_pick
this.Control[iCurrent+29]=this.cb_treatment_goal_pick
this.Control[iCurrent+30]=this.st_1
this.Control[iCurrent+31]=this.cb_clear_ordered_for
this.Control[iCurrent+32]=this.cb_clear_encounter_type
this.Control[iCurrent+33]=this.st_display_only
end on

on w_followup.destroy
call super::destroy
destroy(this.st_page)
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.cb_new_treatment)
destroy(this.dw_child_treatments)
destroy(this.st_description)
destroy(this.sle_description)
destroy(this.st_title)
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
destroy(this.st_encounter_type)
destroy(this.st_if)
destroy(this.st_ordered_for_title)
destroy(this.sle_duration_prn)
destroy(this.st_treatment_goal_title)
destroy(this.sle_treatment_goal)
destroy(this.st_ordered_for)
destroy(this.st_encounter_type_title)
destroy(this.cb_duration_prn_pick)
destroy(this.cb_treatment_goal_pick)
destroy(this.st_1)
destroy(this.cb_clear_ordered_for)
destroy(this.cb_clear_encounter_type)
destroy(this.st_display_only)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_followup
integer x = 2629
boolean originalsize = false
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_followup
integer x = 46
integer y = 1488
end type

type st_page from statictext within w_followup
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

type pb_down from picturebutton within w_followup
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

type pb_up from picturebutton within w_followup
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

type cb_new_treatment from commandbutton within w_followup
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

type dw_child_treatments from u_dw_child_treatments within w_followup
integer x = 837
integer y = 964
integer width = 1856
integer height = 368
integer taborder = 30
end type

type st_description from statictext within w_followup
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

type sle_description from singlelineedit within w_followup
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

type st_title from statictext within w_followup
integer y = 4
integer width = 2898
integer height = 120
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Edit Followup / Appointment"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_finished from commandbutton within w_followup
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

type cb_be_back from commandbutton within w_followup
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

type cb_recalculate_description from commandbutton within w_followup
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

type st_available from statictext within w_followup
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

type st_when_title from statictext within w_followup
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
string text = "Followup When"
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_when from u_st_time within w_followup
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

type st_asap from statictext within w_followup
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

type st_emergency from statictext within w_followup
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

type st_appt_title from statictext within w_followup
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

type st_approx_title from statictext within w_followup
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

type st_appointment_date_time from statictext within w_followup
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

type st_encounter_type from statictext within w_followup
integer x = 978
integer y = 764
integer width = 1600
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

type st_if from statictext within w_followup
integer x = 987
integer y = 144
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

type st_ordered_for_title from statictext within w_followup
integer x = 987
integer y = 500
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

type sle_duration_prn from singlelineedit within w_followup
integer x = 978
integer y = 212
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

type st_treatment_goal_title from statictext within w_followup
integer x = 987
integer y = 320
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

type sle_treatment_goal from singlelineedit within w_followup
integer x = 978
integer y = 388
integer width = 1600
integer height = 92
integer taborder = 40
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

type st_ordered_for from statictext within w_followup
integer x = 978
integer y = 568
integer width = 1600
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

event clicked;u_user luo_user

luo_user = user_list.pick_user(true, false, false)

if isnull(luo_user) then return

ordered_for = luo_user.user_id

set_screen()

end event

type st_encounter_type_title from statictext within w_followup
integer x = 987
integer y = 692
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

type cb_duration_prn_pick from commandbutton within w_followup
integer x = 2597
integer y = 212
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

type cb_treatment_goal_pick from commandbutton within w_followup
integer x = 2597
integer y = 388
integer width = 133
integer height = 96
integer taborder = 50
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

type st_1 from statictext within w_followup
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

type cb_clear_ordered_for from commandbutton within w_followup
integer x = 2597
integer y = 608
integer width = 192
integer height = 72
integer taborder = 60
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

type cb_clear_encounter_type from commandbutton within w_followup
integer x = 2597
integer y = 804
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

event clicked;setnull(encounter_type)

set_screen()

end event

type st_display_only from statictext within w_followup
integer x = 663
integer y = 84
integer width = 1573
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = COLOR_BACKGROUND
string text = "Display Only - Followup Has Already Been Dispatched"
alignment alignment = center!
boolean focusrectangle = false
end type

