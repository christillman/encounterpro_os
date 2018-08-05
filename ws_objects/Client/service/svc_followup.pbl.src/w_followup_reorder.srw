$PBExportHeader$w_followup_reorder.srw
forward
global type w_followup_reorder from w_window_base
end type
type st_description from statictext within w_followup_reorder
end type
type sle_description from singlelineedit within w_followup_reorder
end type
type st_title from statictext within w_followup_reorder
end type
type cb_finished from commandbutton within w_followup_reorder
end type
type cb_be_back from commandbutton within w_followup_reorder
end type
type cb_recalculate_description from commandbutton within w_followup_reorder
end type
type st_available from statictext within w_followup_reorder
end type
type st_when_title from statictext within w_followup_reorder
end type
type uo_when from u_st_time within w_followup_reorder
end type
type st_asap from statictext within w_followup_reorder
end type
type st_emergency from statictext within w_followup_reorder
end type
type st_appt_title from statictext within w_followup_reorder
end type
type st_approx_title from statictext within w_followup_reorder
end type
type st_appointment_date_time from statictext within w_followup_reorder
end type
type st_encounter_type from statictext within w_followup_reorder
end type
type st_if from statictext within w_followup_reorder
end type
type st_ordered_for_title from statictext within w_followup_reorder
end type
type sle_duration_prn from singlelineedit within w_followup_reorder
end type
type st_treatment_goal_title from statictext within w_followup_reorder
end type
type sle_treatment_goal from singlelineedit within w_followup_reorder
end type
type st_ordered_for from statictext within w_followup_reorder
end type
type st_encounter_type_title from statictext within w_followup_reorder
end type
type cb_duration_prn_pick from commandbutton within w_followup_reorder
end type
type cb_treatment_goal_pick from commandbutton within w_followup_reorder
end type
type st_1 from statictext within w_followup_reorder
end type
type cb_clear_ordered_for from commandbutton within w_followup_reorder
end type
type cb_clear_encounter_type from commandbutton within w_followup_reorder
end type
type dw_treatments from u_dw_pick_list within w_followup_reorder
end type
type cb_cancel from commandbutton within w_followup_reorder
end type
end forward

global type w_followup_reorder from w_window_base
boolean controlmenu = false
windowtype windowtype = response!
string button_type = "COMMAND"
event postopen ( )
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
dw_treatments dw_treatments
cb_cancel cb_cancel
end type
global w_followup_reorder w_followup_reorder

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
public function integer order_followup ()
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

ls_description = calculate_description()
if ls_description = treat_followup.treatment_description then
	custom_description = false
else
	custom_description = true
	sle_description.text = treat_followup.treatment_description
end if

dw_treatments.settransobject(sqlca)
dw_treatments.retrieve(current_patient.cpr_id, treat_followup.treatment_id)

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

public function integer order_followup ();integer li_sts
str_assessment_treatment_definition lstr_treatment_def
long ll_new_followup_treatment_id
long ll_patient_workplan_id
long ll_patient_workplan_item_id
Integer	i,li_attribute_count
String	ls_attribute,ls_value
datetime ldt_created
long ll_new_treatment_id
long ll_null
string ls_find
long ll_treatment_count
long ll_row
string ls_treatment_type
string ls_treatment_description
long ll_old_treatment_id
long ll_modify_count
setnull(ll_null)
setnull(ldt_created)
u_ds_data luo_data


// First order the new followup treatment
lstr_treatment_def = f_empty_assessment_treatment_definition()

lstr_treatment_def.problem_id = treat_followup.problem_id()
lstr_treatment_def.treatment_type = treat_followup.treatment_type
lstr_treatment_def.treatment_description = sle_description.text
lstr_treatment_def.open_encounter_id = current_patient.open_encounter.encounter_id
lstr_treatment_def.treatment_mode = treat_followup.treatment_mode

f_attribute_add_attribute(lstr_treatment_def.attributes, "duration_amount", string(duration_amount))
f_attribute_add_attribute(lstr_treatment_def.attributes, "duration_unit", string(duration_unit))
f_attribute_add_attribute(lstr_treatment_def.attributes, "appointment_date_time", string(appointment_date_time))
f_attribute_add_attribute(lstr_treatment_def.attributes, "ordered_for", ordered_for)

if len(sle_duration_prn.text) > 0 then
	f_attribute_add_attribute(lstr_treatment_def.attributes, "duration_prn", sle_duration_prn.text)
end if

if len(sle_treatment_goal.text) > 0 then
	f_attribute_add_attribute(lstr_treatment_def.attributes, "treatment_goal", sle_treatment_goal.text)
end if

if len(encounter_type) > 0 then
	f_attribute_add_attribute(lstr_treatment_def.attributes, "encounter_type", encounter_type)
end if

ll_new_followup_treatment_id = current_patient.treatments.order_treatment(lstr_treatment_def, false)
if ll_new_followup_treatment_id <= 0 then return -1

// Create the followup workplan
sqlca.sp_get_treatment_followup_workplan(service.cpr_id, &
														ll_new_followup_treatment_id, &
														current_patient.open_encounter.encounter_id, &
														current_user.user_id, &
														current_scribe.user_id, &
														"Followup" , &
														ll_patient_workplan_id)
If Not tf_check() then Return -1

if isnull(ll_patient_workplan_id) then
	log.log(this, "w_followup_reorder.order_followup:0063", "Null patient_workplan_id returned from sp_get_treatment_followup_workplan", 4)
	return -1
end if

// Add the postponed treatments to the followup workplan and cancel them in this encounter

luo_data = CREATE u_ds_data

ll_treatment_count = dw_treatments.rowcount()
ls_find = "lower(treatment_status) = 'open' and action = 1"
ll_row = dw_treatments.find(ls_find, 1, ll_treatment_count)
DO WHILE ll_row > 0
	ll_old_treatment_id = dw_treatments.object.treatment_id[ll_row]
	ls_treatment_type = dw_treatments.object.treatment_type[ll_row]
	ls_treatment_description = dw_treatments.object.treatment_description[ll_row]
	ll_new_treatment_id = sqlca.sp_set_treatment_followup_workplan_item(current_patient.cpr_id, &
																								current_patient.open_encounter.encounter_id, &
																								ll_patient_workplan_id, &
																								ls_treatment_type, &
																								ls_treatment_description, &
																								current_user.user_id, &
																								current_scribe.user_id, &
																								ldt_created, &
																								ll_patient_workplan_item_id)
	If Not tf_check() then Return -1
	

	if isnull(ll_patient_workplan_item_id) then
		log.log(this, "w_followup_reorder.order_followup:0091", "Null patient_workplan_item_id returned from sp_set_treatment_followup_workplan_item", 4)
		return -1
	end if

	if isnull(ll_new_treatment_id) then
		log.log(this, "w_followup_reorder.order_followup:0096", "Null treatment_id returned from sp_set_treatment_followup_workplan_item", 4)
		return -1
	end if

	ll_modify_count = luo_data.retrieve(service.cpr_id, ll_old_treatment_id)
	For i = 1 to ll_modify_count
		ls_attribute = luo_data.object.progress_key[i]
		ls_value = luo_data.object.value[i]
		
		sqlca.sp_set_treatment_progress(current_patient.cpr_id, &
													ll_new_treatment_id, &
													current_patient.open_encounter.encounter_id, &
													"Modify", &
													ls_attribute, &
													ls_value, &
													datetime(today(), now()), &
													current_service.patient_workplan_item_id, & 
													ll_null, &
													ll_null, &
													current_user.user_id, &
													current_scribe.user_id )
		If Not tf_check() Then Return -1
	Next
	
	sqlca.sp_set_treatment_progress(current_patient.cpr_id, &
												ll_old_treatment_id, &
												current_patient.open_encounter.encounter_id, &
												"Cancelled", &
												ls_attribute, &
												"Postponed", &
												datetime(today(), now()), &
												current_service.patient_workplan_item_id, & 
												ll_null, &
												ll_null, &
												current_user.user_id, &
												current_scribe.user_id )
	If Not tf_check() Then Return -1
	
	ll_row = dw_treatments.find(ls_find, ll_row + 1, ll_treatment_count + 1)
LOOP

DESTROY luo_data


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
	log.log(this,"w_followup_reorder:open","No Treatment Object",4)
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

on w_followup_reorder.create
int iCurrent
call super::create
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
this.dw_treatments=create dw_treatments
this.cb_cancel=create cb_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_description
this.Control[iCurrent+2]=this.sle_description
this.Control[iCurrent+3]=this.st_title
this.Control[iCurrent+4]=this.cb_finished
this.Control[iCurrent+5]=this.cb_be_back
this.Control[iCurrent+6]=this.cb_recalculate_description
this.Control[iCurrent+7]=this.st_available
this.Control[iCurrent+8]=this.st_when_title
this.Control[iCurrent+9]=this.uo_when
this.Control[iCurrent+10]=this.st_asap
this.Control[iCurrent+11]=this.st_emergency
this.Control[iCurrent+12]=this.st_appt_title
this.Control[iCurrent+13]=this.st_approx_title
this.Control[iCurrent+14]=this.st_appointment_date_time
this.Control[iCurrent+15]=this.st_encounter_type
this.Control[iCurrent+16]=this.st_if
this.Control[iCurrent+17]=this.st_ordered_for_title
this.Control[iCurrent+18]=this.sle_duration_prn
this.Control[iCurrent+19]=this.st_treatment_goal_title
this.Control[iCurrent+20]=this.sle_treatment_goal
this.Control[iCurrent+21]=this.st_ordered_for
this.Control[iCurrent+22]=this.st_encounter_type_title
this.Control[iCurrent+23]=this.cb_duration_prn_pick
this.Control[iCurrent+24]=this.cb_treatment_goal_pick
this.Control[iCurrent+25]=this.st_1
this.Control[iCurrent+26]=this.cb_clear_ordered_for
this.Control[iCurrent+27]=this.cb_clear_encounter_type
this.Control[iCurrent+28]=this.dw_treatments
this.Control[iCurrent+29]=this.cb_cancel
end on

on w_followup_reorder.destroy
call super::destroy
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
destroy(this.dw_treatments)
destroy(this.cb_cancel)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_followup_reorder
integer x = 2629
boolean originalsize = false
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_followup_reorder
integer x = 46
integer y = 1500
end type

type st_description from statictext within w_followup_reorder
integer x = 41
integer y = 1400
integer width = 421
integer height = 76
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Description"
boolean focusrectangle = false
end type

type sle_description from singlelineedit within w_followup_reorder
integer x = 462
integer y = 1396
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

type st_title from statictext within w_followup_reorder
integer y = 4
integer width = 2898
integer height = 120
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Re-Order Followup"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_finished from commandbutton within w_followup_reorder
integer x = 2418
integer y = 1600
integer width = 443
integer height = 108
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
end type

event clicked;str_popup_return popup_return
integer li_sts

li_sts = order_followup()
if li_sts < 0 then return

popup_return.item_count = 1
popup_return.items[1] = "COMPLETE"

Closewithreturn(parent, popup_return)

end event

type cb_be_back from commandbutton within w_followup_reorder
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


popup_return.item_count = 0

Closewithreturn(parent, popup_return)

end event

type cb_recalculate_description from commandbutton within w_followup_reorder
integer x = 1344
integer y = 1504
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

type st_available from statictext within w_followup_reorder
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

type st_when_title from statictext within w_followup_reorder
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
long backcolor = 33538240
boolean enabled = false
string text = "Followup When"
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_when from u_st_time within w_followup_reorder
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

type st_asap from statictext within w_followup_reorder
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

type st_emergency from statictext within w_followup_reorder
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

type st_appt_title from statictext within w_followup_reorder
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
long backcolor = 33538240
string text = "Specific Date/Time"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_approx_title from statictext within w_followup_reorder
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
long backcolor = 33538240
string text = "Approximately"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_appointment_date_time from statictext within w_followup_reorder
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

type st_encounter_type from statictext within w_followup_reorder
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

type st_if from statictext within w_followup_reorder
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
long backcolor = 33538240
boolean enabled = false
string text = "Followup If"
boolean focusrectangle = false
end type

type st_ordered_for_title from statictext within w_followup_reorder
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
long backcolor = 33538240
boolean enabled = false
string text = "Followup With Provider"
boolean focusrectangle = false
end type

type sle_duration_prn from singlelineedit within w_followup_reorder
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

type st_treatment_goal_title from statictext within w_followup_reorder
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
long backcolor = 33538240
boolean enabled = false
string text = "Followup Goal"
boolean focusrectangle = false
end type

type sle_treatment_goal from singlelineedit within w_followup_reorder
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

type st_ordered_for from statictext within w_followup_reorder
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

type st_encounter_type_title from statictext within w_followup_reorder
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
long backcolor = 33538240
boolean enabled = false
string text = "Followup Encounter Type"
boolean focusrectangle = false
end type

type cb_duration_prn_pick from commandbutton within w_followup_reorder
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

type cb_treatment_goal_pick from commandbutton within w_followup_reorder
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

type st_1 from statictext within w_followup_reorder
integer x = 754
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
long backcolor = 33538240
boolean enabled = false
string text = "Followup Treatments"
boolean focusrectangle = false
end type

type cb_clear_ordered_for from commandbutton within w_followup_reorder
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

type cb_clear_encounter_type from commandbutton within w_followup_reorder
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

type dw_treatments from u_dw_pick_list within w_followup_reorder
integer x = 731
integer y = 952
integer width = 2130
integer height = 428
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_fn_followup_treatment_status"
boolean vscrollbar = true
end type

event clicked;call super::clicked;string ls_object

if isnull(row) or row <= 0 then return

ls_object = dwo.name

if lower(ls_object) = 't_keep' then
	object.action[row] = 0
elseif lower(ls_object) = 't_postpone' then
	object.action[row] = 1
end if


end event

type cb_cancel from commandbutton within w_followup_reorder
integer x = 27
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
string text = "Cancel"
boolean cancel = true
end type

event clicked;str_popup_return popup_return
integer li_sts


popup_return.item_count = 1
popup_return.items[1] = "CANCEL"

Closewithreturn(parent, popup_return)

end event

