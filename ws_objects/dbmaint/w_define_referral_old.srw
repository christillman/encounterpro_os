HA$PBExportHeader$w_define_referral_old.srw
//
//EncounterPRO Open Source Project
//
//Copyright 2010 EncounterPRO Healthcare Resources, Inc.
//
//This program is free software: you can redistribute it and/or modify it under the terms
//of the GNU Affero General Public License as published by  the Free Software Foundation, 
//either version 3 of the License, or (at your option) any later version.
//
//This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//See the GNU Affero General Public License for more details.
//
//You should have received a copy of the GNU Affero General Public License along with this
//program.  If not, see <http://www.gnu.org/licenses/>.
//
//EncounterPRO Open Source Project (“The Project”) is distributed under the GNU Affero
//General Public License version 3, or any later version.  As such, linking the Project
//statically or dynamically with other components is making a combined work based on the
//Project. Thus, the terms and conditions of the GNU Affero General Public License 
//version 3, or any later version, cover the whole combination. 
//
//However, as an additional permission, the copyright holders of EncounterPRO Open Source 
//Project give you permission to link the Project with independent components, regardless 
//of the license terms of these independent components, provided that all of the following
//are true:
// 
//1) all access from the independent component to persisted data which resides inside any 
//   EncounterPRO Open Source data store (e.g. SQL Server database) be made through a 
//   publically available database driver (e.g. ODBC, SQL Native Client, etc) or through 
//   a service which itself is part of The Project.
//2) the independent component does not create or rely on any code or data structures 
//   within the EncounterPRO Open Source data store unless such code or data structures, 
//   and all code and data structures referred to by such code or data structures, are 
//   themselves part of The Project.
//3) the independent component either a) runs locally on the user's computer, or b) is 
//   linked to at runtime by The Project’s Component Manager object which in turn is 
//   called by code which itself is part of The Project.
//
//An independent component is a component which is not derived from or based on the
//Project. If you modify the Project, you may extend this additional permission to your
//version of the Project, but you are not obligated to do so. If you do not wish to do
//so, delete this additional permission statement from your version. 
forward
global type w_define_referral_old from w_window_base
end type
type cb_done from commandbutton within w_define_referral_old
end type
type cb_cancel from commandbutton within w_define_referral_old
end type
type st_modes from statictext within w_define_referral_old
end type
type sle_description from singlelineedit within w_define_referral_old
end type
type st_desc_t from statictext within w_define_referral_old
end type
type st_review_t from statictext within w_define_referral_old
end type
type st_specialty_t from statictext within w_define_referral_old
end type
type st_specialty from statictext within w_define_referral_old
end type
type st_referral_wp_t from statictext within w_define_referral_old
end type
type st_referral_workplan from statictext within w_define_referral_old
end type
type st_first_available from statictext within w_define_referral_old
end type
type rb_asap from radiobutton within w_define_referral_old
end type
type rb_first from radiobutton within w_define_referral_old
end type
type rb_when from radiobutton within w_define_referral_old
end type
type uo_when from u_st_time within w_define_referral_old
end type
type st_consultant from statictext within w_define_referral_old
end type
type st_no from u_st_ref_yesno within w_define_referral_old
end type
type st_yes from u_st_ref_yesno within w_define_referral_old
end type
type uo_referral_assessment from u_st_referral_assessment within w_define_referral_old
end type
type st_ruleout from statictext within w_define_referral_old
end type
type rb_eval from radiobutton within w_define_referral_old
end type
type rb_ruleout from radiobutton within w_define_referral_old
end type
type st_2 from statictext within w_define_referral_old
end type
type uo_consultant from u_consultant within w_define_referral_old
end type
type st_title from statictext within w_define_referral_old
end type
type gb_when from groupbox within w_define_referral_old
end type
end forward

global type w_define_referral_old from w_window_base
boolean controlmenu = false
windowtype windowtype = response!
event post_open pbm_custom01
cb_done cb_done
cb_cancel cb_cancel
st_modes st_modes
sle_description sle_description
st_desc_t st_desc_t
st_review_t st_review_t
st_specialty_t st_specialty_t
st_specialty st_specialty
st_referral_wp_t st_referral_wp_t
st_referral_workplan st_referral_workplan
st_first_available st_first_available
rb_asap rb_asap
rb_first rb_first
rb_when rb_when
uo_when uo_when
st_consultant st_consultant
st_no st_no
st_yes st_yes
uo_referral_assessment uo_referral_assessment
st_ruleout st_ruleout
rb_eval rb_eval
rb_ruleout rb_ruleout
st_2 st_2
uo_consultant uo_consultant
st_title st_title
gb_when gb_when
end type
global w_define_referral_old w_define_referral_old

type variables
date 										appointment_date
string 									referral_question,attach_flag
string 									appointment_responsible,specialty_id
real 										duration_amount
string 									duration_unit,duration_prn
long										referral_workplan_id
String									treatment_mode
u_component_treatment				treat_referral
u_attachment_list 					attachment_list
end variables

forward prototypes
public function string get_description ()
end prototypes

event post_open;String						ls_null
Integer						li_sts
str_progress 	lstr_progress

IF isnull(treat_referral.specialty_id) THEN
	specialty_id = f_pick_specialty("")
	IF isnull(specialty_id) THEN
		cb_cancel.event clicked()
		Return
	End If
	st_specialty.text = datalist.specialty_description(specialty_id)
	sle_description.text = get_description()
End If

uo_consultant.set_specialty(specialty_id)
uo_consultant.postevent("clicked")


									
end event

public function string get_description ();string ls_description
string ls_duration

ls_description = st_specialty.text + ", "

if not isnull(duration_amount) and not isnull(duration_unit) then
	ls_description = ls_description + "in " + lower(f_pretty_amount_unit(duration_amount, duration_unit)) + " "
end if

if not isnull(duration_prn) then
	ls_description = ls_description + lower(duration_prn) + " "
end if

if isnull(referral_question) or isnull(uo_referral_assessment.assessment_id) then
	ls_description = ls_description + "for evaluation "
else
	ls_description = ls_description + "to " + lower(referral_question) + " " + lower(uo_referral_assessment.text) + " "
end if


return ls_description

end function

event open;call super::open;If Not Isvalid(Message.powerobjectparm) Then
	log.log(this,"open()","Invalid parameter; Expecting treatment component as it's parameter",4)
	cb_cancel.event clicked()
	Return
End If
treat_referral = Message.powerobjectparm
Setnull(referral_workplan_id)
//st_diagnosis.text = "Diagnosis: " + treat_referral.assessment.assessment

postevent("post_open")
end event

on w_define_referral_old.create
int iCurrent
call super::create
this.cb_done=create cb_done
this.cb_cancel=create cb_cancel
this.st_modes=create st_modes
this.sle_description=create sle_description
this.st_desc_t=create st_desc_t
this.st_review_t=create st_review_t
this.st_specialty_t=create st_specialty_t
this.st_specialty=create st_specialty
this.st_referral_wp_t=create st_referral_wp_t
this.st_referral_workplan=create st_referral_workplan
this.st_first_available=create st_first_available
this.rb_asap=create rb_asap
this.rb_first=create rb_first
this.rb_when=create rb_when
this.uo_when=create uo_when
this.st_consultant=create st_consultant
this.st_no=create st_no
this.st_yes=create st_yes
this.uo_referral_assessment=create uo_referral_assessment
this.st_ruleout=create st_ruleout
this.rb_eval=create rb_eval
this.rb_ruleout=create rb_ruleout
this.st_2=create st_2
this.uo_consultant=create uo_consultant
this.st_title=create st_title
this.gb_when=create gb_when
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_done
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.st_modes
this.Control[iCurrent+4]=this.sle_description
this.Control[iCurrent+5]=this.st_desc_t
this.Control[iCurrent+6]=this.st_review_t
this.Control[iCurrent+7]=this.st_specialty_t
this.Control[iCurrent+8]=this.st_specialty
this.Control[iCurrent+9]=this.st_referral_wp_t
this.Control[iCurrent+10]=this.st_referral_workplan
this.Control[iCurrent+11]=this.st_first_available
this.Control[iCurrent+12]=this.rb_asap
this.Control[iCurrent+13]=this.rb_first
this.Control[iCurrent+14]=this.rb_when
this.Control[iCurrent+15]=this.uo_when
this.Control[iCurrent+16]=this.st_consultant
this.Control[iCurrent+17]=this.st_no
this.Control[iCurrent+18]=this.st_yes
this.Control[iCurrent+19]=this.uo_referral_assessment
this.Control[iCurrent+20]=this.st_ruleout
this.Control[iCurrent+21]=this.rb_eval
this.Control[iCurrent+22]=this.rb_ruleout
this.Control[iCurrent+23]=this.st_2
this.Control[iCurrent+24]=this.uo_consultant
this.Control[iCurrent+25]=this.st_title
this.Control[iCurrent+26]=this.gb_when
end on

on w_define_referral_old.destroy
call super::destroy
destroy(this.cb_done)
destroy(this.cb_cancel)
destroy(this.st_modes)
destroy(this.sle_description)
destroy(this.st_desc_t)
destroy(this.st_review_t)
destroy(this.st_specialty_t)
destroy(this.st_specialty)
destroy(this.st_referral_wp_t)
destroy(this.st_referral_workplan)
destroy(this.st_first_available)
destroy(this.rb_asap)
destroy(this.rb_first)
destroy(this.rb_when)
destroy(this.uo_when)
destroy(this.st_consultant)
destroy(this.st_no)
destroy(this.st_yes)
destroy(this.uo_referral_assessment)
destroy(this.st_ruleout)
destroy(this.rb_eval)
destroy(this.rb_ruleout)
destroy(this.st_2)
destroy(this.uo_consultant)
destroy(this.st_title)
destroy(this.gb_when)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_define_referral_old
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_define_referral_old
end type

type cb_done from commandbutton within w_define_referral_old
integer x = 2405
integer y = 1596
integer width = 443
integer height = 108
integer taborder = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;String		ls_referral_desc

ls_referral_desc = sle_description.text
If isnull(ls_referral_desc) Or Len(ls_referral_desc) = 0 Then
	openwithparm(w_pop_message, "You must enter a valid referral description")
	return
End If
treat_referral.treatment_count = 1
treat_referral.treatment_definition[1].item_description = ls_referral_desc
treat_referral.treatment_definition[1].treatment_type   = treat_referral.treatment_type
treat_referral.treatment_definition[1].attribute[1] = "duration_amount"
treat_referral.treatment_definition[1].value[1] =String(duration_amount)
treat_referral.treatment_definition[1].attribute[2] = "duration_unit"
treat_referral.treatment_definition[1].value[2] = duration_unit
treat_referral.treatment_definition[1].attribute[3] = "duration_prn"
treat_referral.treatment_definition[1].value[3] = duration_prn
treat_referral.treatment_definition[1].attribute[4] = "attach_flag"
treat_referral.treatment_definition[1].value[4] = attach_flag
treat_referral.treatment_definition[1].attribute[5] = "referral_question"
treat_referral.treatment_definition[1].value[5] = referral_question
treat_referral.treatment_definition[1].attribute[6] = "referral_question_assmnt_id"
treat_referral.treatment_definition[1].value[6] = uo_referral_assessment.assessment_id
// the same attribute is used to hold both referral and followup workplan id's
treat_referral.treatment_definition[1].attribute[7] = "followup_workplan_id"
treat_referral.treatment_definition[1].value[7] = string(referral_workplan_id)
treat_referral.treatment_definition[1].attribute[8] = "specialty_id"
treat_referral.treatment_definition[1].value[8]     = specialty_id
treat_referral.treatment_definition[1].attribute[9] = "treatment_mode"
treat_referral.treatment_definition[1].value[9] = treatment_mode
// Set the consultant id in trt progress table
treat_referral.treatment_definition[1].attribute[10] = "consultant_id"
treat_referral.treatment_definition[1].value[10] = uo_consultant.consultant_id

treat_referral.treatment_definition[1].attribute_count = 10

Close(Parent)
end event

type cb_cancel from commandbutton within w_define_referral_old
integer x = 59
integer y = 1596
integer width = 443
integer height = 108
integer taborder = 90
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
Close(Parent)
end event

type st_modes from statictext within w_define_referral_old
integer x = 695
integer y = 1056
integer width = 1362
integer height = 132
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

type sle_description from singlelineedit within w_define_referral_old
integer x = 439
integer y = 1308
integer width = 2231
integer height = 112
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 80
borderstyle borderstyle = stylelowered!
end type

type st_desc_t from statictext within w_define_referral_old
integer x = 23
integer y = 1332
integer width = 416
integer height = 72
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Description"
boolean focusrectangle = false
end type

type st_review_t from statictext within w_define_referral_old
integer x = 411
integer y = 1076
integer width = 233
integer height = 84
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

type st_specialty_t from statictext within w_define_referral_old
integer x = 430
integer y = 176
integer width = 549
integer height = 72
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Specialty"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_specialty from statictext within w_define_referral_old
integer x = 101
integer y = 260
integer width = 1193
integer height = 112
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

sle_description.text = get_description()
uo_consultant.set_specialty(specialty_id)
uo_consultant.event clicked()
end event

type st_referral_wp_t from statictext within w_define_referral_old
integer x = 23
integer y = 880
integer width = 645
integer height = 72
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Referral Workplan"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_referral_workplan from statictext within w_define_referral_old
integer x = 690
integer y = 856
integer width = 1362
integer height = 112
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

type st_first_available from statictext within w_define_referral_old
integer x = 2231
integer y = 924
integer width = 498
integer height = 168
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "First Available Appointment"
boolean focusrectangle = false
end type

event clicked;rb_first.postevent("clicked")
end event

type rb_asap from radiobutton within w_define_referral_old
event clicked pbm_bnclicked
integer x = 2144
integer y = 804
integer width = 407
integer height = 72
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "ASAP"
end type

event clicked;checked = true
uo_when.backcolor = color_object
duration_prn = "ASAP"
setnull(duration_amount)
setnull(duration_unit)

sle_description.text = get_description()
end event

type rb_first from radiobutton within w_define_referral_old
event clicked pbm_bnclicked
integer x = 2144
integer y = 956
integer width = 82
integer height = 108
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
end type

event clicked;checked = true
uo_when.backcolor = color_object
duration_prn = "First Available Appointment"
setnull(duration_amount)
setnull(duration_unit)

sle_description.text = get_description()
end event

type rb_when from radiobutton within w_define_referral_old
event clicked pbm_bnclicked
integer x = 2144
integer y = 1144
integer width = 78
integer height = 72
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
end type

event clicked;if uo_when.amount <= 0 or isnull(uo_when.unit) then
	uo_when.postevent("clicked")
	return
end if

uo_when.backcolor = color_object_selected
checked = true
setnull(duration_prn)
duration_amount = uo_when.amount
duration_unit = uo_when.unit
sle_description.text = get_description()

end event

type uo_when from u_st_time within w_define_referral_old
event clicked pbm_bnclicked
integer x = 2235
integer y = 1128
integer width = 608
integer height = 96
end type

event clicked;call super::clicked;if amount > 0 and not isnull(unit) then
	rb_when.postevent("clicked")
else
	rb_asap.postevent("clicked")
end if
end event

type st_consultant from statictext within w_define_referral_old
integer x = 2016
integer y = 184
integer width = 549
integer height = 72
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Consultant"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_no from u_st_ref_yesno within w_define_referral_old
integer x = 2633
integer y = 500
integer width = 187
integer height = 120
string text = "No"
end type

event clicked;call super::clicked;attach_flag = "N"

end event

type st_yes from u_st_ref_yesno within w_define_referral_old
integer x = 2341
integer y = 500
integer width = 187
integer height = 120
end type

event clicked;call super::clicked;attach_flag = "Y"

end event

type uo_referral_assessment from u_st_referral_assessment within w_define_referral_old
integer x = 878
integer y = 644
integer width = 1166
integer height = 112
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
if not isnull(specialty_id) then popup.items[2] += specialty_id

openwithparm(lw_find_assessment, popup, "w_find_assessment")
ls_assessment_id = message.stringparm
if isnull(ls_assessment_id) or trim(ls_assessment_id) = "" then return

set_assessment(ls_assessment_id, datalist.assessment_description(ls_assessment_id))
rb_ruleout.triggerevent("clicked")

sle_description.text = get_description()

end event

type st_ruleout from statictext within w_define_referral_old
integer x = 398
integer y = 644
integer width = 439
integer height = 112
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
sle_description.text = get_description()
end event

type rb_eval from radiobutton within w_define_referral_old
integer x = 59
integer y = 508
integer width = 658
integer height = 76
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
sle_description.text = get_description()
end event

type rb_ruleout from radiobutton within w_define_referral_old
integer x = 59
integer y = 644
integer width = 338
integer height = 96
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
end event

type st_2 from statictext within w_define_referral_old
integer x = 2336
integer y = 404
integer width = 485
integer height = 72
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 33538240
boolean enabled = false
string text = "Attach SOAP"
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_consultant from u_consultant within w_define_referral_old
integer x = 1669
integer y = 264
integer width = 1193
integer height = 104
end type

type st_title from statictext within w_define_referral_old
integer x = 347
integer width = 2199
integer height = 104
integer textsize = -16
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 33538240
boolean enabled = false
string text = "Referral"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_when from groupbox within w_define_referral_old
integer x = 2103
integer y = 688
integer width = 768
integer height = 592
integer taborder = 10
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "When"
end type

