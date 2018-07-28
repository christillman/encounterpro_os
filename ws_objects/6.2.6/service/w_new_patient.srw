HA$PBExportHeader$w_new_patient.srw
forward
global type w_new_patient from w_window_base
end type
type sle_phone_number from singlelineedit within w_new_patient
end type
type st_phone_num_title from statictext within w_new_patient
end type
type st_date_of_birth from statictext within w_new_patient
end type
type st_birthdate from statictext within w_new_patient
end type
type em_ssn from editmask within w_new_patient
end type
type st_ssn_t from statictext within w_new_patient
end type
type sle_nickname from singlelineedit within w_new_patient
end type
type st_3 from statictext within w_new_patient
end type
type st_race from statictext within w_new_patient
end type
type st_race_title from statictext within w_new_patient
end type
type uo_cb_sex from u_cb_sex_toggle within w_new_patient
end type
type st_sex from statictext within w_new_patient
end type
type st_name_suffix_title from statictext within w_new_patient
end type
type sle_name_suffix from singlelineedit within w_new_patient
end type
type st_name_prefix_title from statictext within w_new_patient
end type
type sle_name_prefix from singlelineedit within w_new_patient
end type
type sle_middle_name from singlelineedit within w_new_patient
end type
type st_middle_name_title from statictext within w_new_patient
end type
type sle_first_name from singlelineedit within w_new_patient
end type
type st_first_name_title from statictext within w_new_patient
end type
type st_last_name_title from statictext within w_new_patient
end type
type st_title from statictext within w_new_patient
end type
type cb_finished from commandbutton within w_new_patient
end type
type sle_last_name from singlelineedit within w_new_patient
end type
type cb_cancel from commandbutton within w_new_patient
end type
type st_1 from statictext within w_new_patient
end type
type sle_email_address from singlelineedit within w_new_patient
end type
type st_patient_status from statictext within w_new_patient
end type
type st_patient_status_t from statictext within w_new_patient
end type
type sle_address_1 from singlelineedit within w_new_patient
end type
type st_address1_title from statictext within w_new_patient
end type
type st_9 from statictext within w_new_patient
end type
type st_7 from statictext within w_new_patient
end type
type st_6 from statictext within w_new_patient
end type
type sle_city from singlelineedit within w_new_patient
end type
type sle_zip from singlelineedit within w_new_patient
end type
type sle_state from singlelineedit within w_new_patient
end type
type sle_address_2 from singlelineedit within w_new_patient
end type
type st_address_2_title from statictext within w_new_patient
end type
end forward

global type w_new_patient from w_window_base
integer x = 649
integer y = 252
integer width = 2555
integer height = 1788
string title = "Import Selected Files"
boolean controlmenu = false
windowtype windowtype = response!
boolean auto_resize_window = false
boolean auto_resize_objects = false
boolean nested_user_object_resize = false
event postopen ( )
sle_phone_number sle_phone_number
st_phone_num_title st_phone_num_title
st_date_of_birth st_date_of_birth
st_birthdate st_birthdate
em_ssn em_ssn
st_ssn_t st_ssn_t
sle_nickname sle_nickname
st_3 st_3
st_race st_race
st_race_title st_race_title
uo_cb_sex uo_cb_sex
st_sex st_sex
st_name_suffix_title st_name_suffix_title
sle_name_suffix sle_name_suffix
st_name_prefix_title st_name_prefix_title
sle_name_prefix sle_name_prefix
sle_middle_name sle_middle_name
st_middle_name_title st_middle_name_title
sle_first_name sle_first_name
st_first_name_title st_first_name_title
st_last_name_title st_last_name_title
st_title st_title
cb_finished cb_finished
sle_last_name sle_last_name
cb_cancel cb_cancel
st_1 st_1
sle_email_address sle_email_address
st_patient_status st_patient_status
st_patient_status_t st_patient_status_t
sle_address_1 sle_address_1
st_address1_title st_address1_title
st_9 st_9
st_7 st_7
st_6 st_6
sle_city sle_city
sle_zip sle_zip
sle_state sle_state
sle_address_2 sle_address_2
st_address_2_title st_address_2_title
end type
global w_new_patient w_new_patient

type variables
str_patient new_patient
end variables

on w_new_patient.create
int iCurrent
call super::create
this.sle_phone_number=create sle_phone_number
this.st_phone_num_title=create st_phone_num_title
this.st_date_of_birth=create st_date_of_birth
this.st_birthdate=create st_birthdate
this.em_ssn=create em_ssn
this.st_ssn_t=create st_ssn_t
this.sle_nickname=create sle_nickname
this.st_3=create st_3
this.st_race=create st_race
this.st_race_title=create st_race_title
this.uo_cb_sex=create uo_cb_sex
this.st_sex=create st_sex
this.st_name_suffix_title=create st_name_suffix_title
this.sle_name_suffix=create sle_name_suffix
this.st_name_prefix_title=create st_name_prefix_title
this.sle_name_prefix=create sle_name_prefix
this.sle_middle_name=create sle_middle_name
this.st_middle_name_title=create st_middle_name_title
this.sle_first_name=create sle_first_name
this.st_first_name_title=create st_first_name_title
this.st_last_name_title=create st_last_name_title
this.st_title=create st_title
this.cb_finished=create cb_finished
this.sle_last_name=create sle_last_name
this.cb_cancel=create cb_cancel
this.st_1=create st_1
this.sle_email_address=create sle_email_address
this.st_patient_status=create st_patient_status
this.st_patient_status_t=create st_patient_status_t
this.sle_address_1=create sle_address_1
this.st_address1_title=create st_address1_title
this.st_9=create st_9
this.st_7=create st_7
this.st_6=create st_6
this.sle_city=create sle_city
this.sle_zip=create sle_zip
this.sle_state=create sle_state
this.sle_address_2=create sle_address_2
this.st_address_2_title=create st_address_2_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_phone_number
this.Control[iCurrent+2]=this.st_phone_num_title
this.Control[iCurrent+3]=this.st_date_of_birth
this.Control[iCurrent+4]=this.st_birthdate
this.Control[iCurrent+5]=this.em_ssn
this.Control[iCurrent+6]=this.st_ssn_t
this.Control[iCurrent+7]=this.sle_nickname
this.Control[iCurrent+8]=this.st_3
this.Control[iCurrent+9]=this.st_race
this.Control[iCurrent+10]=this.st_race_title
this.Control[iCurrent+11]=this.uo_cb_sex
this.Control[iCurrent+12]=this.st_sex
this.Control[iCurrent+13]=this.st_name_suffix_title
this.Control[iCurrent+14]=this.sle_name_suffix
this.Control[iCurrent+15]=this.st_name_prefix_title
this.Control[iCurrent+16]=this.sle_name_prefix
this.Control[iCurrent+17]=this.sle_middle_name
this.Control[iCurrent+18]=this.st_middle_name_title
this.Control[iCurrent+19]=this.sle_first_name
this.Control[iCurrent+20]=this.st_first_name_title
this.Control[iCurrent+21]=this.st_last_name_title
this.Control[iCurrent+22]=this.st_title
this.Control[iCurrent+23]=this.cb_finished
this.Control[iCurrent+24]=this.sle_last_name
this.Control[iCurrent+25]=this.cb_cancel
this.Control[iCurrent+26]=this.st_1
this.Control[iCurrent+27]=this.sle_email_address
this.Control[iCurrent+28]=this.st_patient_status
this.Control[iCurrent+29]=this.st_patient_status_t
this.Control[iCurrent+30]=this.sle_address_1
this.Control[iCurrent+31]=this.st_address1_title
this.Control[iCurrent+32]=this.st_9
this.Control[iCurrent+33]=this.st_7
this.Control[iCurrent+34]=this.st_6
this.Control[iCurrent+35]=this.sle_city
this.Control[iCurrent+36]=this.sle_zip
this.Control[iCurrent+37]=this.sle_state
this.Control[iCurrent+38]=this.sle_address_2
this.Control[iCurrent+39]=this.st_address_2_title
end on

on w_new_patient.destroy
call super::destroy
destroy(this.sle_phone_number)
destroy(this.st_phone_num_title)
destroy(this.st_date_of_birth)
destroy(this.st_birthdate)
destroy(this.em_ssn)
destroy(this.st_ssn_t)
destroy(this.sle_nickname)
destroy(this.st_3)
destroy(this.st_race)
destroy(this.st_race_title)
destroy(this.uo_cb_sex)
destroy(this.st_sex)
destroy(this.st_name_suffix_title)
destroy(this.sle_name_suffix)
destroy(this.st_name_prefix_title)
destroy(this.sle_name_prefix)
destroy(this.sle_middle_name)
destroy(this.st_middle_name_title)
destroy(this.sle_first_name)
destroy(this.st_first_name_title)
destroy(this.st_last_name_title)
destroy(this.st_title)
destroy(this.cb_finished)
destroy(this.sle_last_name)
destroy(this.cb_cancel)
destroy(this.st_1)
destroy(this.sle_email_address)
destroy(this.st_patient_status)
destroy(this.st_patient_status_t)
destroy(this.sle_address_1)
destroy(this.st_address1_title)
destroy(this.st_9)
destroy(this.st_7)
destroy(this.st_6)
destroy(this.sle_city)
destroy(this.sle_zip)
destroy(this.sle_state)
destroy(this.sle_address_2)
destroy(this.st_address_2_title)
end on

event open;
new_patient = f_empty_patient()

center_popup()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_new_patient
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_new_patient
integer x = 18
integer y = 1368
end type

type sle_phone_number from singlelineedit within w_new_patient
integer x = 1687
integer y = 796
integer width = 768
integer height = 108
integer taborder = 70
integer textsize = -9
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;new_patient.phone_number = sqlca.fn_pretty_phone(text)
text = new_patient.phone_number

end event

type st_phone_num_title from statictext within w_new_patient
integer x = 1426
integer y = 812
integer width = 229
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Phone"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_date_of_birth from statictext within w_new_patient
integer x = 1691
integer y = 276
integer width = 443
integer height = 104
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;date ld_date_of_birth
string ls_text

ld_date_of_birth = new_patient.date_of_birth

ls_text = f_select_date(ld_date_of_birth, "Date of Birth")
if isnull(ls_text) then return

new_patient.date_of_birth = date(ls_text)
text = ls_text

end event

type st_birthdate from statictext within w_new_patient
integer x = 1385
integer y = 288
integer width = 274
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Birthdate"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_ssn from editmask within w_new_patient
integer x = 1691
integer y = 532
integer width = 402
integer height = 108
integer taborder = 70
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string mask = "###-##-####"
end type

event modified;new_patient.ssn = text

end event

type st_ssn_t from statictext within w_new_patient
integer x = 1509
integer y = 552
integer width = 151
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "SSN"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_nickname from singlelineedit within w_new_patient
integer x = 539
integer y = 776
integer width = 768
integer height = 108
integer taborder = 60
integer textsize = -9
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;new_patient.nickname = text

end event

type st_3 from statictext within w_new_patient
integer x = 210
integer y = 792
integer width = 306
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Nickname"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_race from statictext within w_new_patient
integer x = 1691
integer y = 404
integer width = 530
integer height = 104
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
u_user luo_user

popup.dataobject = "dw_domain_notranslate_list"
popup.datacolumn = 2
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = "RACE"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

new_patient.race = popup_return.items[1]
text = new_patient.race

end event

type st_race_title from statictext within w_new_patient
integer x = 1486
integer y = 424
integer width = 174
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Race"
alignment alignment = right!
boolean focusrectangle = false
end type

type uo_cb_sex from u_cb_sex_toggle within w_new_patient
integer x = 1691
integer y = 144
integer taborder = 120
end type

event clicked;call super::clicked;new_patient.sex = sex

end event

type st_sex from statictext within w_new_patient
integer x = 1486
integer y = 160
integer width = 174
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Sex"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_name_suffix_title from statictext within w_new_patient
integer x = 110
integer y = 664
integer width = 407
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Name Suffix"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_name_suffix from singlelineedit within w_new_patient
integer x = 539
integer y = 648
integer width = 768
integer height = 108
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 100
borderstyle borderstyle = stylelowered!
end type

event modified;new_patient.name_suffix = text

end event

type st_name_prefix_title from statictext within w_new_patient
integer x = 110
integer y = 536
integer width = 407
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Name Prefix"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_name_prefix from singlelineedit within w_new_patient
integer x = 539
integer y = 520
integer width = 768
integer height = 108
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 100
borderstyle borderstyle = stylelowered!
end type

event modified;new_patient.name_prefix = text

end event

type sle_middle_name from singlelineedit within w_new_patient
integer x = 539
integer y = 392
integer width = 768
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 100
borderstyle borderstyle = stylelowered!
end type

event modified;new_patient.middle_name = text

end event

type st_middle_name_title from statictext within w_new_patient
integer x = 101
integer y = 408
integer width = 416
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Middle Name"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_first_name from singlelineedit within w_new_patient
integer x = 539
integer y = 264
integer width = 768
integer height = 108
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 100
borderstyle borderstyle = stylelowered!
end type

event modified;new_patient.first_name = text

end event

type st_first_name_title from statictext within w_new_patient
integer x = 110
integer y = 280
integer width = 407
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "First Name"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_last_name_title from statictext within w_new_patient
integer x = 110
integer y = 152
integer width = 407
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Last Name"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_title from statictext within w_new_patient
integer width = 2546
integer height = 120
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "New Patient"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_finished from commandbutton within w_new_patient
integer x = 1934
integer y = 1536
integer width = 517
integer height = 112
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
end type

event clicked;integer li_sts

li_sts = f_new_patient(new_patient)
if li_sts <= 0 then return

closewithreturn(parent, new_patient.cpr_id)


end event

type sle_last_name from singlelineedit within w_new_patient
integer x = 539
integer y = 136
integer width = 768
integer height = 108
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 100
borderstyle borderstyle = stylelowered!
end type

event modified;new_patient.last_name = text

end event

type cb_cancel from commandbutton within w_new_patient
integer x = 69
integer y = 1536
integer width = 402
integer height = 112
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
end type

event clicked;string ls_cpr_id

setnull(ls_cpr_id)

closewithreturn(parent, ls_cpr_id)

end event

type st_1 from statictext within w_new_patient
integer x = 1426
integer y = 680
integer width = 229
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Email"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_email_address from singlelineedit within w_new_patient
integer x = 1687
integer y = 664
integer width = 768
integer height = 108
integer taborder = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;new_patient.email_address = text

end event

type st_patient_status from statictext within w_new_patient
integer x = 1070
integer y = 1416
integer width = 549
integer height = 104
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
u_user luo_user

popup.dataobject = "dw_domain_notranslate_list"
popup.datacolumn = 2
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = "PATIENT_STATUS"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

new_patient.patient_status = popup_return.items[1]
text = new_patient.patient_status

end event

type st_patient_status_t from statictext within w_new_patient
integer x = 608
integer y = 1424
integer width = 416
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Patient Status"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_address_1 from singlelineedit within w_new_patient
integer x = 539
integer y = 964
integer width = 955
integer height = 108
integer taborder = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;new_patient.address_line_1 = text

end event

type st_address1_title from statictext within w_new_patient
integer x = 165
integer y = 980
integer width = 352
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Address 1"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_9 from statictext within w_new_patient
integer x = 923
integer y = 1256
integer width = 174
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "State"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_7 from statictext within w_new_patient
integer x = 1335
integer y = 1252
integer width = 137
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Zip"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_6 from statictext within w_new_patient
integer x = 343
integer y = 1256
integer width = 174
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "City"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_city from singlelineedit within w_new_patient
integer x = 539
integer y = 1240
integer width = 352
integer height = 104
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;text = left(text,40)
new_patient.city = text

end event

type sle_zip from singlelineedit within w_new_patient
integer x = 1490
integer y = 1236
integer width = 352
integer height = 104
integer taborder = 90
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;text = left(text,10)
new_patient.zip = text

end event

type sle_state from singlelineedit within w_new_patient
integer x = 1111
integer y = 1240
integer width = 169
integer height = 104
integer taborder = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;text = left(text,2)

new_patient.state = text

end event

type sle_address_2 from singlelineedit within w_new_patient
integer x = 539
integer y = 1104
integer width = 955
integer height = 108
integer taborder = 100
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;new_patient.address_line_2 = text

end event

type st_address_2_title from statictext within w_new_patient
integer x = 165
integer y = 1132
integer width = 352
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Address 2"
alignment alignment = right!
boolean focusrectangle = false
end type

