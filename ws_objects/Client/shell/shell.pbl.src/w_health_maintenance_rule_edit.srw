$PBExportHeader$w_health_maintenance_rule_edit.srw
forward
global type w_health_maintenance_rule_edit from w_window_base
end type
type st_sex from statictext within w_health_maintenance_rule_edit
end type
type st_1 from statictext within w_health_maintenance_rule_edit
end type
type st_age_from_title from statictext within w_health_maintenance_rule_edit
end type
type st_warning_days_title from statictext within w_health_maintenance_rule_edit
end type
type st_warning_days from statictext within w_health_maintenance_rule_edit
end type
type st_assmnt_flag_title from statictext within w_health_maintenance_rule_edit
end type
type st_assessment_flag from statictext within w_health_maintenance_rule_edit
end type
type st_race_title from statictext within w_health_maintenance_rule_edit
end type
type st_race from statictext within w_health_maintenance_rule_edit
end type
type st_age_range from statictext within w_health_maintenance_rule_edit
end type
type st_interval_title from statictext within w_health_maintenance_rule_edit
end type
type st_interval from statictext within w_health_maintenance_rule_edit
end type
type st_interval_unit from statictext within w_health_maintenance_rule_edit
end type
type cb_ok from commandbutton within w_health_maintenance_rule_edit
end type
type cb_cancel from commandbutton within w_health_maintenance_rule_edit
end type
type st_title from statictext within w_health_maintenance_rule_edit
end type
type st_description from statictext within w_health_maintenance_rule_edit
end type
end forward

global type w_health_maintenance_rule_edit from w_window_base
integer x = 233
integer y = 112
integer width = 2414
integer height = 1516
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_sex st_sex
st_1 st_1
st_age_from_title st_age_from_title
st_warning_days_title st_warning_days_title
st_warning_days st_warning_days
st_assmnt_flag_title st_assmnt_flag_title
st_assessment_flag st_assessment_flag
st_race_title st_race_title
st_race st_race
st_age_range st_age_range
st_interval_title st_interval_title
st_interval st_interval
st_interval_unit st_interval_unit
cb_ok cb_ok
cb_cancel cb_cancel
st_title st_title
st_description st_description
end type
global w_health_maintenance_rule_edit w_health_maintenance_rule_edit

type variables
String	age_from_unit,age_to_unit,interval_unit
String assessment_flag,race,sex
Long		interval,age_to,age_from
Long warning_days,age_range_id
end variables

on w_health_maintenance_rule_edit.create
int iCurrent
call super::create
this.st_sex=create st_sex
this.st_1=create st_1
this.st_age_from_title=create st_age_from_title
this.st_warning_days_title=create st_warning_days_title
this.st_warning_days=create st_warning_days
this.st_assmnt_flag_title=create st_assmnt_flag_title
this.st_assessment_flag=create st_assessment_flag
this.st_race_title=create st_race_title
this.st_race=create st_race
this.st_age_range=create st_age_range
this.st_interval_title=create st_interval_title
this.st_interval=create st_interval
this.st_interval_unit=create st_interval_unit
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.st_title=create st_title
this.st_description=create st_description
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_sex
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_age_from_title
this.Control[iCurrent+4]=this.st_warning_days_title
this.Control[iCurrent+5]=this.st_warning_days
this.Control[iCurrent+6]=this.st_assmnt_flag_title
this.Control[iCurrent+7]=this.st_assessment_flag
this.Control[iCurrent+8]=this.st_race_title
this.Control[iCurrent+9]=this.st_race
this.Control[iCurrent+10]=this.st_age_range
this.Control[iCurrent+11]=this.st_interval_title
this.Control[iCurrent+12]=this.st_interval
this.Control[iCurrent+13]=this.st_interval_unit
this.Control[iCurrent+14]=this.cb_ok
this.Control[iCurrent+15]=this.cb_cancel
this.Control[iCurrent+16]=this.st_title
this.Control[iCurrent+17]=this.st_description
end on

on w_health_maintenance_rule_edit.destroy
call super::destroy
destroy(this.st_sex)
destroy(this.st_1)
destroy(this.st_age_from_title)
destroy(this.st_warning_days_title)
destroy(this.st_warning_days)
destroy(this.st_assmnt_flag_title)
destroy(this.st_assessment_flag)
destroy(this.st_race_title)
destroy(this.st_race)
destroy(this.st_age_range)
destroy(this.st_interval_title)
destroy(this.st_interval)
destroy(this.st_interval_unit)
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.st_title)
destroy(this.st_description)
end on

event open;call super::open;integer				li_pos
string				age_range_description
str_popup 			popup
u_unit 				luo_unit
str_popup_return 	popup_return

popup_return.item_count = 0

popup = message.powerobjectparm

if popup.data_row_count <> 13 then
	log.log(this, "w_health_maintenance_rule_edit.open.0012", "Invalid Parameters", 4)
	closewithreturn(this, popup_return)
	return
end if


sex = popup.items[1]
race = popup.items[2]
interval = long(popup.items[3])
interval_unit = popup.items[4]
warning_days = long(popup.items[5])
assessment_flag = popup.items[6]
age_range_description = popup.items[7]
age_range_id = long(popup.items[8])
age_from = long(popup.items[9])
age_from_unit = popup.items[10]
age_to = long(popup.items[11])
age_to_unit = popup.items[12]
st_description.text = popup.items[13]

if isnull(sex) then
	st_sex.text = "N/A"
elseif sex = "F" then
	st_sex.text = "Female"
else
	sex = "M"
	st_sex.text = "Male"
end if

if isnull(race) then
	st_race.text = "N/A"
else
	st_race.text = datalist.domain_item_description("RACE", race)
	if isnull(st_race.text) then st_race.text = race
end if
st_interval.text = string(interval)
st_interval_unit.text = interval_unit
st_warning_days.text = string(warning_days)

if assessment_flag = "Y" then
	st_assessment_flag.text = "Yes"
else
	st_assessment_flag.text = "No"
end if
if isnull(age_range_description) then
	st_age_range.text = "N/A"
else
	st_age_range.text = age_range_description
end if

end event

type pb_epro_help from w_window_base`pb_epro_help within w_health_maintenance_rule_edit
integer x = 2345
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_health_maintenance_rule_edit
end type

type st_sex from statictext within w_health_maintenance_rule_edit
integer x = 1125
integer y = 336
integer width = 283
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Female"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
u_user luo_user

popup.dataobject = "dw_domain_translate_list"
popup.datacolumn = 2
popup.displaycolumn = 3
popup.argument_count = 1
popup.argument[1] = "SEX"
popup.add_blank_row = true
popup.blank_text = "N/A"

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if trim(popup_return.items[1]) = "" then
	setnull(sex)
	text = "N/A"
else
	sex = popup_return.items[1]
	text = popup_return.descriptions[1]
end if



end event

type st_1 from statictext within w_health_maintenance_rule_edit
integer x = 805
integer y = 352
integer width = 247
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Sex:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_age_from_title from statictext within w_health_maintenance_rule_edit
integer x = 667
integer y = 704
integer width = 379
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Age Range:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_warning_days_title from statictext within w_health_maintenance_rule_edit
integer x = 558
integer y = 1044
integer width = 462
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Warning Days:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_warning_days from statictext within w_health_maintenance_rule_edit
integer x = 1125
integer y = 1028
integer width = 283
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "99"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.realitem = real(warning_days)
openwithparm(w_number, popup)
popup_return = message.powerobjectparm
if popup_return.item <> "OK" then return

warning_days = long(popup_return.realitem)
text = string(warning_days)



end event

type st_assmnt_flag_title from statictext within w_health_maintenance_rule_edit
integer x = 370
integer y = 1204
integer width = 649
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Attach Assessments:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_assessment_flag from statictext within w_health_maintenance_rule_edit
integer x = 1125
integer y = 1188
integer width = 283
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Yes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if assessment_flag = "Y" then
	text = "No"
	assessment_flag = "N"
else
	text = "Yes"
	assessment_flag = "Y"
end if

end event

type st_race_title from statictext within w_health_maintenance_rule_edit
integer x = 590
integer y = 528
integer width = 462
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Race:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_race from statictext within w_health_maintenance_rule_edit
integer x = 1125
integer y = 512
integer width = 1161
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "N/A"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
u_user luo_user

popup.dataobject = "dw_domain_showtranslate_list"
popup.datacolumn = 2
popup.displaycolumn = 3
popup.argument_count = 1
popup.argument[1] = "RACE"
popup.add_blank_row = true
popup.blank_text = "N/A"

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if trim(popup_return.items[1]) = "" then
	setnull(race)
	text = "N/A"
else
	race = popup_return.items[1]
	text = popup_return.descriptions[1]
end if



end event

type st_age_range from statictext within w_health_maintenance_rule_edit
integer x = 1125
integer y = 684
integer width = 1175
integer height = 132
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "N/A"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup_return	popup_return

openwithparm(w_age_range_selection,"Stages")
popup_return = Message.powerobjectparm
If popup_return.item_count > 0 Then
	Text = popup_return.descriptions[1]
	age_range_id = Long(popup_return.items[1])
	age_from = long(popup_return.items[2])
	age_from_unit = popup_return.items[3]
	age_to = long(popup_return.items[4])
	age_to_unit = popup_return.items[5]
Else
//	st_description.Text = "N/A"
End if
end event

type st_interval_title from statictext within w_health_maintenance_rule_edit
integer x = 558
integer y = 888
integer width = 462
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Interval:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_interval from statictext within w_health_maintenance_rule_edit
integer x = 1125
integer y = 872
integer width = 283
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "99"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.realitem = real(interval)
openwithparm(w_number, popup)
popup_return = message.powerobjectparm
if popup_return.item <> "OK" then return

interval = long(popup_return.realitem)
text = string(interval)



end event

type st_interval_unit from statictext within w_health_maintenance_rule_edit
integer x = 1472
integer y = 872
integer width = 283
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Month"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;call super::clicked;str_popup popup
str_popup_return popup_return
integer li_index

popup.data_row_count = 3
popup.items[1] = "Days"
popup.items[2] = "Months"
popup.items[3] = "Years"

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

li_index = popup_return.item_indexes[1]
if li_index = 1 then
	interval_unit = "DAY"
	text = "Days"
elseif li_index = 2 then
	interval_unit = "MONTH"
	text = "Months"
else
	interval_unit = "YEAR"
	text = "Years"
end if
end event

type cb_ok from commandbutton within w_health_maintenance_rule_edit
integer x = 1925
integer y = 1352
integer width = 402
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;str_popup_return popup_return

if isnull(age_range_id) then
	openwithparm(w_pop_message,"Select a valid age range ..")
	return
end if
popup_return.item_count = 12

popup_return.items[1] = sex
popup_return.items[2] = race
popup_return.items[3] = string(age_range_id)
popup_return.items[4] = string(age_from)
popup_return.items[5] = age_from_unit
popup_return.items[6] = string(age_to)
popup_return.items[7] = age_to_unit
popup_return.items[8] = string(interval)
popup_return.items[9] = interval_unit
popup_return.items[10] = string(warning_days)
popup_return.items[11] = assessment_flag
popup_return.items[12] = st_age_range.text // age range description

closewithreturn(parent, popup_return)


end event

type cb_cancel from commandbutton within w_health_maintenance_rule_edit
integer x = 78
integer y = 1352
integer width = 402
integer height = 112
integer taborder = 20
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

type st_title from statictext within w_health_maintenance_rule_edit
integer x = 5
integer width = 2405
integer height = 100
boolean bringtotop = true
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Health Maintenance Rule Criteria"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_description from statictext within w_health_maintenance_rule_edit
integer x = 18
integer y = 148
integer width = 2359
integer height = 96
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Description"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

