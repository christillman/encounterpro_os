$PBExportHeader$w_referral_old.srw
forward
global type w_referral_old from w_window_base
end type
type sle_description from singlelineedit within w_referral_old
end type
type st_desc_title from statictext within w_referral_old
end type
type st_page from statictext within w_referral_old
end type
type pb_down from u_picture_button within w_referral_old
end type
type pb_up from u_picture_button within w_referral_old
end type
type cb_1 from commandbutton within w_referral_old
end type
type dw_child_treatments from u_dw_child_treatments within w_referral_old
end type
type st_first_available from statictext within w_referral_old
end type
type rb_asap from radiobutton within w_referral_old
end type
type rb_first from radiobutton within w_referral_old
end type
type rb_when from radiobutton within w_referral_old
end type
type uo_when from u_st_time within w_referral_old
end type
type st_consultant from statictext within w_referral_old
end type
type st_3 from statictext within w_referral_old
end type
type st_no from u_st_ref_yesno within w_referral_old
end type
type st_yes from u_st_ref_yesno within w_referral_old
end type
type uo_referral_assessment from u_st_referral_assessment within w_referral_old
end type
type st_diagnosis from statictext within w_referral_old
end type
type st_ruleout from statictext within w_referral_old
end type
type rb_eval from radiobutton within w_referral_old
end type
type rb_ruleout from radiobutton within w_referral_old
end type
type st_2 from statictext within w_referral_old
end type
type uo_consultant from u_consultant within w_referral_old
end type
type st_title from statictext within w_referral_old
end type
type cb_be_back from commandbutton within w_referral_old
end type
type cb_done from commandbutton within w_referral_old
end type
type gb_when from groupbox within w_referral_old
end type
end forward

global type w_referral_old from w_window_base
windowtype windowtype = response!
string button_type = "COMMAND"
integer max_buttons = 2
event post_open pbm_custom01
sle_description sle_description
st_desc_title st_desc_title
st_page st_page
pb_down pb_down
pb_up pb_up
cb_1 cb_1
dw_child_treatments dw_child_treatments
st_first_available st_first_available
rb_asap rb_asap
rb_first rb_first
rb_when rb_when
uo_when uo_when
st_consultant st_consultant
st_3 st_3
st_no st_no
st_yes st_yes
uo_referral_assessment uo_referral_assessment
st_diagnosis st_diagnosis
st_ruleout st_ruleout
rb_eval rb_eval
rb_ruleout rb_ruleout
st_2 st_2
uo_consultant uo_consultant
st_title st_title
cb_be_back cb_be_back
cb_done cb_done
gb_when gb_when
end type
global w_referral_old w_referral_old

type variables
u_component_service service

String 	referral_question,referral_question_assmnt_desc
String 	attach_flag
String 	appointment_responsible
String 	duration_unit,duration_prn
String	consultant_id
Real 		duration_amount
Date	 	appointment_date
u_component_treatment	treat_referral


end variables

forward prototypes
public function string get_description ()
end prototypes

event post_open;String	ls_null,ls_value
integer li_progress_count
string ls_Referral_When
string ls_amount
string ls_unit

Setnull(ls_null)
Setnull(appointment_date)
Setnull(appointment_responsible)
Setnull(duration_unit)
Setnull(duration_prn)
duration_amount = 0
//st_diagnosis.text = "Diagnosis: " + treat_referral.assessment.assessment

attach_flag = treat_referral.attach_flag
IF attach_flag = "Y" THEN
	st_yes.triggerevent("clicked")
ELSE
	st_no.triggerevent("clicked")
END IF

dw_child_treatments.initialize(service)
// Set the page
dw_child_treatments.set_page(1, st_page.text)
If dw_child_treatments.last_page > 1 then
	pb_up.visible = true
	pb_down.visible = true
	st_page.visible = true
	pb_up.enabled = false
	pb_down.enabled = true
Else
	pb_up.visible = false
	pb_down.visible = false
	st_page.visible = false
End if

uo_consultant.set_specialty(treat_referral.specialty_id)

// Referral To ..
ls_value = current_patient.treatments.get_property_value(treat_referral.treatment_id, "consultant_id")
consultant_id = ls_value

If isnull(consultant_id)then
	uo_consultant.postevent("clicked")
Else
	uo_consultant.set_consultant(consultant_id)
End If

duration_amount = treat_referral.duration_amount
duration_unit = treat_referral.duration_unit
duration_prn = treat_referral.duration_prn
If isnull(duration_amount) Or isnull(duration_unit) Then
	If isnull(duration_prn) Then
		service.get_attribute("Referral When", ls_Referral_When)
		if isnull(ls_Referral_When) then ls_Referral_When = "ASAP"
		CHOOSE CASE upper(ls_Referral_When)
			CASE "ASAP"
				rb_asap.triggerevent("clicked")
			CASE "FIRST AVAILABLE"
				rb_first.triggerevent("clicked")
			CASE ELSE
				// See if we can interpret as amount and unit
				f_split_string(ls_Referral_When, " ", ls_amount, ls_unit)
				if isnumber(ls_amount) and (upper(ls_unit) = "DAY" or upper(ls_unit) = "DAY" or upper(ls_unit) = "DAY") then
					duration_amount = real(ls_amount)
					duration_unit = ls_unit
					uo_when.set_time(duration_amount, duration_unit)
				else
					rb_asap.triggerevent("clicked")
				end if
		END CHOOSE
				
	Else
		If duration_prn = "ASAP" Then
			rb_asap.triggerevent("clicked")
		Elseif duration_prn = "First Available Appointment" Then
			rb_first.triggerevent("clicked")
		Else
			log.log(this, "post_open", "Unrecognized prn (" + duration_prn + ")", 3)
			rb_asap.triggerevent("clicked")
		End if
	End if
Else
	uo_when.set_time(duration_amount, duration_unit)
	rb_when.triggerevent("clicked")
End if

If isnull(treat_referral.referral_question) Then
	rb_eval.triggerevent("clicked")
Else
	st_ruleout.text = treat_referral.referral_question
	uo_referral_assessment.set_assessment(treat_referral.referral_question_assmnt_id, &
												referral_question_assmnt_desc)
	rb_ruleout.triggerevent("clicked")
End if

st_title.text = uo_consultant.specialty_description + " Referral"
sle_description.text = treat_referral.treatment_description


end event

public function string get_description ();string ls_description
string ls_duration
string ls_specialty_id

if len(uo_consultant.consultant_id) > 0 then
	ls_specialty_id = user_list.user_property(uo_consultant.consultant_id, "specialty_id")
	ls_description = datalist.specialty_description(ls_specialty_id) + ", "
	if isnull(ls_description) then ls_description = ""
elseif len(uo_consultant.specialty_description) > 0 then
	ls_description = uo_consultant.specialty_description + ", "
else
	ls_description = ""
end if

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

event open;call super::open;long ll_menu_id

service = Message.powerobjectparm
treat_referral = service.treatment


// Don't offer the "I'll Be Back" option for manual services
max_buttons = 3
if service.manual_service then
	cb_be_back.visible = false
	max_buttons = 4
end if

ll_menu_id = long(service.get_attribute("menu_id"))
paint_menu(ll_menu_id)

postevent("post_open")

end event

on w_referral_old.create
int iCurrent
call super::create
this.sle_description=create sle_description
this.st_desc_title=create st_desc_title
this.st_page=create st_page
this.pb_down=create pb_down
this.pb_up=create pb_up
this.cb_1=create cb_1
this.dw_child_treatments=create dw_child_treatments
this.st_first_available=create st_first_available
this.rb_asap=create rb_asap
this.rb_first=create rb_first
this.rb_when=create rb_when
this.uo_when=create uo_when
this.st_consultant=create st_consultant
this.st_3=create st_3
this.st_no=create st_no
this.st_yes=create st_yes
this.uo_referral_assessment=create uo_referral_assessment
this.st_diagnosis=create st_diagnosis
this.st_ruleout=create st_ruleout
this.rb_eval=create rb_eval
this.rb_ruleout=create rb_ruleout
this.st_2=create st_2
this.uo_consultant=create uo_consultant
this.st_title=create st_title
this.cb_be_back=create cb_be_back
this.cb_done=create cb_done
this.gb_when=create gb_when
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_description
this.Control[iCurrent+2]=this.st_desc_title
this.Control[iCurrent+3]=this.st_page
this.Control[iCurrent+4]=this.pb_down
this.Control[iCurrent+5]=this.pb_up
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.dw_child_treatments
this.Control[iCurrent+8]=this.st_first_available
this.Control[iCurrent+9]=this.rb_asap
this.Control[iCurrent+10]=this.rb_first
this.Control[iCurrent+11]=this.rb_when
this.Control[iCurrent+12]=this.uo_when
this.Control[iCurrent+13]=this.st_consultant
this.Control[iCurrent+14]=this.st_3
this.Control[iCurrent+15]=this.st_no
this.Control[iCurrent+16]=this.st_yes
this.Control[iCurrent+17]=this.uo_referral_assessment
this.Control[iCurrent+18]=this.st_diagnosis
this.Control[iCurrent+19]=this.st_ruleout
this.Control[iCurrent+20]=this.rb_eval
this.Control[iCurrent+21]=this.rb_ruleout
this.Control[iCurrent+22]=this.st_2
this.Control[iCurrent+23]=this.uo_consultant
this.Control[iCurrent+24]=this.st_title
this.Control[iCurrent+25]=this.cb_be_back
this.Control[iCurrent+26]=this.cb_done
this.Control[iCurrent+27]=this.gb_when
end on

on w_referral_old.destroy
call super::destroy
destroy(this.sle_description)
destroy(this.st_desc_title)
destroy(this.st_page)
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.cb_1)
destroy(this.dw_child_treatments)
destroy(this.st_first_available)
destroy(this.rb_asap)
destroy(this.rb_first)
destroy(this.rb_when)
destroy(this.uo_when)
destroy(this.st_consultant)
destroy(this.st_3)
destroy(this.st_no)
destroy(this.st_yes)
destroy(this.uo_referral_assessment)
destroy(this.st_diagnosis)
destroy(this.st_ruleout)
destroy(this.rb_eval)
destroy(this.rb_ruleout)
destroy(this.st_2)
destroy(this.uo_consultant)
destroy(this.st_title)
destroy(this.cb_be_back)
destroy(this.cb_done)
destroy(this.gb_when)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_referral_old
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_referral_old
end type

type sle_description from singlelineedit within w_referral_old
integer x = 439
integer y = 1344
integer width = 2423
integer height = 112
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_desc_title from statictext within w_referral_old
integer x = 37
integer y = 1368
integer width = 379
integer height = 76
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Description"
boolean focusrectangle = false
end type

type st_page from statictext within w_referral_old
integer x = 1861
integer y = 988
integer width = 165
integer height = 140
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Page 99/99"
boolean focusrectangle = false
end type

type pb_down from u_picture_button within w_referral_old
integer x = 1861
integer y = 864
integer width = 137
integer height = 116
integer taborder = 40
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_child_treatments.current_page
li_last_page = dw_child_treatments.last_page

dw_child_treatments.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type pb_up from u_picture_button within w_referral_old
integer x = 1861
integer y = 744
integer width = 137
integer height = 116
integer taborder = 30
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_child_treatments.current_page

dw_child_treatments.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type cb_1 from commandbutton within w_referral_old
integer x = 1408
integer y = 640
integer width = 421
integer height = 96
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add Treatment"
end type

event clicked;dw_child_treatments.add_treatment()

end event

type dw_child_treatments from u_dw_child_treatments within w_referral_old
integer x = 37
integer y = 744
integer width = 1815
integer height = 572
integer taborder = 50
borderstyle borderstyle = stylebox!
end type

event child_treatments_loaded;call super::child_treatments_loaded;dw_child_treatments.last_page = 0
dw_child_treatments.set_page(1, st_page.text)
if dw_child_treatments.last_page < 2 then
	pb_down.visible = false
	pb_up.visible = false
	st_page.visible = false
else
	pb_down.visible = true
	pb_up.visible = true
	st_page.visible = true
	pb_down.enabled = true
	pb_up.enabled = false
end if

end event

type st_first_available from statictext within w_referral_old
integer x = 2254
integer y = 876
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

type rb_asap from radiobutton within w_referral_old
event clicked pbm_bnclicked
integer x = 2107
integer y = 764
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

type rb_first from radiobutton within w_referral_old
event clicked pbm_bnclicked
integer x = 2107
integer y = 916
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

type rb_when from radiobutton within w_referral_old
event clicked pbm_bnclicked
integer x = 2107
integer y = 1104
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

type uo_when from u_st_time within w_referral_old
event clicked pbm_bnclicked
integer x = 2208
integer y = 1092
integer width = 608
integer height = 96
end type

event clicked;call super::clicked;if amount > 0 and not isnull(unit) then
	rb_when.postevent("clicked")
else
	rb_asap.postevent("clicked")
end if

end event

type st_consultant from statictext within w_referral_old
integer x = 1979
integer y = 140
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

type st_3 from statictext within w_referral_old
integer x = 41
integer y = 664
integer width = 1006
integer height = 72
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Please Perform The Following:"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_no from u_st_ref_yesno within w_referral_old
integer x = 2491
integer y = 448
integer width = 187
integer height = 120
string text = "No"
end type

event clicked;call super::clicked;attach_flag = "N"

end event

type st_yes from u_st_ref_yesno within w_referral_old
integer x = 2199
integer y = 448
integer width = 187
integer height = 120
end type

event clicked;call super::clicked;attach_flag = "Y"

end event

type uo_referral_assessment from u_st_referral_assessment within w_referral_old
integer x = 864
integer y = 476
integer width = 1125
integer height = 96
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

sle_description.text = get_description()

end event

type st_diagnosis from statictext within w_referral_old
integer x = 32
integer y = 152
integer width = 1559
integer height = 152
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type st_ruleout from statictext within w_referral_old
integer x = 379
integer y = 476
integer width = 439
integer height = 96
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

type rb_eval from radiobutton within w_referral_old
integer x = 32
integer y = 340
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

type rb_ruleout from radiobutton within w_referral_old
integer x = 32
integer y = 476
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

type st_2 from statictext within w_referral_old
integer x = 2194
integer y = 352
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

type uo_consultant from u_consultant within w_referral_old
integer x = 1659
integer y = 212
integer width = 1193
integer height = 104
end type

type st_title from statictext within w_referral_old
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

type cb_be_back from commandbutton within w_referral_old
integer x = 1929
integer y = 1600
integer width = 443
integer height = 108
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I~'ll Be Back"
end type

event clicked;String	ls_referral_desc
str_attributes lstr_attributes
str_popup_return popup_return

lstr_attributes.attribute_count = 0

openwithparm(w_pop_yes_no, "Do you wish to save any changes made to this screen?")
popup_return = message.powerobjectparm
if popup_return.item = "YES" then
	ls_referral_desc = sle_description.text
	If isnull(ls_referral_desc) Or Len(ls_referral_desc) = 0 Then
		openwithparm(w_pop_message, "You must enter a valid referral description")
		return
	End If
	
	f_attribute_add_attribute(lstr_attributes, "treatment_description", ls_referral_desc)
	f_attribute_add_attribute(lstr_attributes, "consultant_id", uo_consultant.consultant_id)
	f_attribute_add_attribute(lstr_attributes, "duration_amount", String(duration_amount))
	f_attribute_add_attribute(lstr_attributes, "duration_unit", duration_unit)
	f_attribute_add_attribute(lstr_attributes, "duration_prn", duration_prn)
	f_attribute_add_attribute(lstr_attributes, "attach_flag", attach_flag)
	f_attribute_add_attribute(lstr_attributes, "referral_question", referral_question)
	f_attribute_add_attribute(lstr_attributes, "referral_question_assmnt_id", uo_referral_assessment.assessment_id)
end if

popup_return.item_count = 0
popup_return.returnobject = lstr_attributes

Closewithreturn(Parent, popup_return)



end event

type cb_done from commandbutton within w_referral_old
integer x = 2414
integer y = 1600
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
string text = "Finished"
end type

event clicked;String	ls_referral_desc
str_attributes lstr_attributes
str_popup_return popup_return

ls_referral_desc = sle_description.text
If isnull(ls_referral_desc) Or Len(ls_referral_desc) = 0 Then
	openwithparm(w_pop_message, "You must enter a valid referral description")
	return
End If

f_attribute_add_attribute(lstr_attributes, "treatment_description", ls_referral_desc)
f_attribute_add_attribute(lstr_attributes, "consultant_id", uo_consultant.consultant_id)
f_attribute_add_attribute(lstr_attributes, "duration_amount", String(duration_amount))
f_attribute_add_attribute(lstr_attributes, "duration_unit", duration_unit)
f_attribute_add_attribute(lstr_attributes, "duration_prn", duration_prn)
f_attribute_add_attribute(lstr_attributes, "attach_flag", attach_flag)
f_attribute_add_attribute(lstr_attributes, "referral_question", referral_question)
f_attribute_add_attribute(lstr_attributes, "referral_question_assmnt_id", uo_referral_assessment.assessment_id)

popup_return.item_count = 1
popup_return.items[1] = "OK"
popup_return.returnobject = lstr_attributes

Closewithreturn(Parent, popup_return)



end event

type gb_when from groupbox within w_referral_old
integer x = 2066
integer y = 648
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

