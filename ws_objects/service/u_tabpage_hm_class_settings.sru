HA$PBExportHeader$u_tabpage_hm_class_settings.sru
forward
global type u_tabpage_hm_class_settings from u_tabpage_hm_class_base
end type
type st_6 from statictext within u_tabpage_hm_class_settings
end type
type st_5 from statictext within u_tabpage_hm_class_settings
end type
type st_4 from statictext within u_tabpage_hm_class_settings
end type
type st_3 from statictext within u_tabpage_hm_class_settings
end type
type st_2 from statictext within u_tabpage_hm_class_settings
end type
type st_1 from statictext within u_tabpage_hm_class_settings
end type
type st_age_range from statictext within u_tabpage_hm_class_settings
end type
type st_race from statictext within u_tabpage_hm_class_settings
end type
type st_sex from statictext within u_tabpage_hm_class_settings
end type
type st_age_range_title from statictext within u_tabpage_hm_class_settings
end type
type st_race_title from statictext within u_tabpage_hm_class_settings
end type
type st_sex_title from statictext within u_tabpage_hm_class_settings
end type
type st_controlled_warning from statictext within u_tabpage_hm_class_settings
end type
type st_controlled_ok from statictext within u_tabpage_hm_class_settings
end type
type st_measured_warning from statictext within u_tabpage_hm_class_settings
end type
type st_measured_ok from statictext within u_tabpage_hm_class_settings
end type
type st_compliance_warning from statictext within u_tabpage_hm_class_settings
end type
type st_compliance_ok from statictext within u_tabpage_hm_class_settings
end type
end forward

global type u_tabpage_hm_class_settings from u_tabpage_hm_class_base
integer width = 3063
st_6 st_6
st_5 st_5
st_4 st_4
st_3 st_3
st_2 st_2
st_1 st_1
st_age_range st_age_range
st_race st_race
st_sex st_sex
st_age_range_title st_age_range_title
st_race_title st_race_title
st_sex_title st_sex_title
st_controlled_warning st_controlled_warning
st_controlled_ok st_controlled_ok
st_measured_warning st_measured_warning
st_measured_ok st_measured_ok
st_compliance_warning st_compliance_warning
st_compliance_ok st_compliance_ok
end type
global u_tabpage_hm_class_settings u_tabpage_hm_class_settings

type variables

end variables

forward prototypes
public subroutine refresh ()
public function integer initialize (str_hm_context pstr_hm_context, long pl_index)
end prototypes

public subroutine refresh ();long i
long ll_row
string ls_sex
string ls_race
long ll_age_range_id


for i = 1 to HMClassTab.hm_class.criteria_count
	if lower(HMClassTab.hm_class.criteria[i].property) = "sex" then
		if isnull(HMClassTab.hm_class.criteria[i].value) then
			st_sex.text = "<Any>"
		else
			st_sex.text = f_property_value_display(HMClassTab.hm_class.criteria[i].property, HMClassTab.hm_class.criteria[i].value)
		end if
	end if
	if lower(HMClassTab.hm_class.criteria[i].property) = "race" then
		if isnull(HMClassTab.hm_class.criteria[i].value) then
			st_race.text = "<Any>"
		else
			st_race.text = f_property_value_display(HMClassTab.hm_class.criteria[i].property, HMClassTab.hm_class.criteria[i].value)
		end if
	end if
	if lower(HMClassTab.hm_class.criteria[i].property) = "age_range" then
		if isnull(HMClassTab.hm_class.criteria[i].value) then
			st_age_range.text = "<Any>"
		else
			st_age_range.text = f_property_value_display(HMClassTab.hm_class.criteria[i].property, HMClassTab.hm_class.criteria[i].value)
		end if
	end if
next


st_compliance_ok.text = string(hmclasstab.hm_class.compliance_ok_percent)
st_compliance_warning.text = string(hmclasstab.hm_class.compliance_warning_percent)
st_measured_ok.text = string(hmclasstab.hm_class.measured_ok_percent)
st_measured_warning.text = string(hmclasstab.hm_class.measured_warning_percent)
st_controlled_ok.text = string(hmclasstab.hm_class.controlled_ok_percent)
st_controlled_warning.text = string(hmclasstab.hm_class.controlled_warning_percent)

end subroutine

public function integer initialize (str_hm_context pstr_hm_context, long pl_index);long i
long ll_row

//// Set the object positions
//st_title.width = width
//
//dw_criteria.x = ((width - dw_criteria.width) / 2) + 110
//dw_criteria.height = height - 300
//
//cb_add_criterion.x = (width - cb_add_criterion.width) / 2
//cb_add_criterion.y = dw_criteria.y + dw_criteria.height + 36
//

return 1


end function

on u_tabpage_hm_class_settings.create
int iCurrent
call super::create
this.st_6=create st_6
this.st_5=create st_5
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.st_age_range=create st_age_range
this.st_race=create st_race
this.st_sex=create st_sex
this.st_age_range_title=create st_age_range_title
this.st_race_title=create st_race_title
this.st_sex_title=create st_sex_title
this.st_controlled_warning=create st_controlled_warning
this.st_controlled_ok=create st_controlled_ok
this.st_measured_warning=create st_measured_warning
this.st_measured_ok=create st_measured_ok
this.st_compliance_warning=create st_compliance_warning
this.st_compliance_ok=create st_compliance_ok
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_6
this.Control[iCurrent+2]=this.st_5
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.st_age_range
this.Control[iCurrent+8]=this.st_race
this.Control[iCurrent+9]=this.st_sex
this.Control[iCurrent+10]=this.st_age_range_title
this.Control[iCurrent+11]=this.st_race_title
this.Control[iCurrent+12]=this.st_sex_title
this.Control[iCurrent+13]=this.st_controlled_warning
this.Control[iCurrent+14]=this.st_controlled_ok
this.Control[iCurrent+15]=this.st_measured_warning
this.Control[iCurrent+16]=this.st_measured_ok
this.Control[iCurrent+17]=this.st_compliance_warning
this.Control[iCurrent+18]=this.st_compliance_ok
end on

on u_tabpage_hm_class_settings.destroy
call super::destroy
destroy(this.st_6)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.st_age_range)
destroy(this.st_race)
destroy(this.st_sex)
destroy(this.st_age_range_title)
destroy(this.st_race_title)
destroy(this.st_sex_title)
destroy(this.st_controlled_warning)
destroy(this.st_controlled_ok)
destroy(this.st_measured_warning)
destroy(this.st_measured_ok)
destroy(this.st_compliance_warning)
destroy(this.st_compliance_ok)
end on

type st_6 from statictext within u_tabpage_hm_class_settings
integer x = 1993
integer y = 916
integer width = 654
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Controlled Warning %"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_5 from statictext within u_tabpage_hm_class_settings
integer x = 1993
integer y = 784
integer width = 654
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Controlled OK %"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_4 from statictext within u_tabpage_hm_class_settings
integer x = 1993
integer y = 652
integer width = 654
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Measured Warning %"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within u_tabpage_hm_class_settings
integer x = 1993
integer y = 520
integer width = 654
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Measured OK %"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within u_tabpage_hm_class_settings
integer x = 1957
integer y = 388
integer width = 690
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Compliance Warning %"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within u_tabpage_hm_class_settings
integer x = 1993
integer y = 256
integer width = 654
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Compliance OK %"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_age_range from statictext within u_tabpage_hm_class_settings
integer x = 590
integer y = 520
integer width = 823
integer height = 84
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "<Any>"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup_return popup_return
string ls_property
string ls_operation
integer li_sts

ls_property = "age_range"
ls_operation = "In Age Range"

openwithparm(w_age_range_selection,"Maintenance")
popup_return = Message.powerobjectparm
If popup_return.item_count > 0 Then
	text = popup_return.descriptions[1]
	li_sts = hmclasstab.set_criterion(ls_property, ls_operation, popup_return.items[1])
End if	


end event

type st_race from statictext within u_tabpage_hm_class_settings
integer x = 590
integer y = 404
integer width = 402
integer height = 84
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "<Any>"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string ls_operation
string ls_property
str_popup_return	popup_return
str_popup popup
integer li_sts
string ls_value

ls_property = "Race"
ls_operation = "="

popup.dataobject = "dw_domain_showtranslate_list"
popup.datacolumn = 2
popup.displaycolumn = 3
popup.argument_count = 1
popup.argument[1] = "RACE"
popup.add_blank_row = true
popup.blank_text = "<Any>"

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then
	return
end if

text = popup_return.descriptions[1]
if popup_return.items[1] = "" then
	setnull(ls_value)
else
	ls_value = popup_return.items[1]
end if

li_sts = hmclasstab.set_criterion(ls_property, ls_operation, ls_value)

return


end event

type st_sex from statictext within u_tabpage_hm_class_settings
integer x = 590
integer y = 288
integer width = 402
integer height = 84
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "<Any>"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string ls_operation
string ls_property
str_popup_return	popup_return
str_popup popup
integer li_sts
string ls_value

ls_property = "Sex"
ls_operation = "="

popup.dataobject = "dw_domain_translate_list"
popup.datacolumn = 2
popup.displaycolumn = 3
popup.argument_count = 1
popup.argument[1] = ls_property
popup.add_blank_row = true
popup.blank_text = "<Any>"

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then
	return
end if

text = popup_return.descriptions[1]
if popup_return.items[1] = "" then
	setnull(ls_value)
else
	ls_value = popup_return.items[1]
end if

li_sts = hmclasstab.set_criterion(ls_property, ls_operation, ls_value)

return


end event

type st_age_range_title from statictext within u_tabpage_hm_class_settings
integer x = 151
integer y = 528
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Age Range"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_race_title from statictext within u_tabpage_hm_class_settings
integer x = 155
integer y = 412
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Race"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_sex_title from statictext within u_tabpage_hm_class_settings
integer x = 155
integer y = 296
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Sex"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_controlled_warning from statictext within u_tabpage_hm_class_settings
integer x = 2683
integer y = 908
integer width = 201
integer height = 84
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup 			popup
str_popup_return	popup_return

popup.realitem = real(hmclasstab.hm_class.controlled_warning_percent)
Openwithparm(w_number,popup)

popup_return = Message.powerobjectparm

If popup_return.item = "CANCEL" Then Return

hmclasstab.hm_class.controlled_warning_percent = long(popup_return.realitem)

integer li_sts
li_sts = hmclasstab.update_class( )

refresh()


end event

type st_controlled_ok from statictext within u_tabpage_hm_class_settings
integer x = 2683
integer y = 776
integer width = 201
integer height = 84
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup 			popup
str_popup_return	popup_return

popup.realitem = real(hmclasstab.hm_class.controlled_ok_percent)
Openwithparm(w_number,popup)

popup_return = Message.powerobjectparm

If popup_return.item = "CANCEL" Then Return

hmclasstab.hm_class.controlled_ok_percent = long(popup_return.realitem)

integer li_sts
li_sts = hmclasstab.update_class( )

refresh()


end event

type st_measured_warning from statictext within u_tabpage_hm_class_settings
integer x = 2683
integer y = 644
integer width = 201
integer height = 84
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup 			popup
str_popup_return	popup_return

popup.realitem = real(hmclasstab.hm_class.measured_warning_percent)
Openwithparm(w_number,popup)

popup_return = Message.powerobjectparm

If popup_return.item = "CANCEL" Then Return

hmclasstab.hm_class.measured_warning_percent = long(popup_return.realitem)

integer li_sts
li_sts = hmclasstab.update_class( )

refresh()


end event

type st_measured_ok from statictext within u_tabpage_hm_class_settings
integer x = 2683
integer y = 512
integer width = 201
integer height = 84
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup 			popup
str_popup_return	popup_return

popup.realitem = real(hmclasstab.hm_class.measured_ok_percent)
Openwithparm(w_number,popup)

popup_return = Message.powerobjectparm

If popup_return.item = "CANCEL" Then Return

hmclasstab.hm_class.measured_ok_percent = long(popup_return.realitem)

integer li_sts
li_sts = hmclasstab.update_class( )

refresh()


end event

type st_compliance_warning from statictext within u_tabpage_hm_class_settings
integer x = 2683
integer y = 380
integer width = 201
integer height = 84
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup 			popup
str_popup_return	popup_return

popup.realitem = real(hmclasstab.hm_class.compliance_warning_percent)
Openwithparm(w_number,popup)

popup_return = Message.powerobjectparm

If popup_return.item = "CANCEL" Then Return

hmclasstab.hm_class.compliance_warning_percent = long(popup_return.realitem)

integer li_sts
li_sts = hmclasstab.update_class( )

refresh()


end event

type st_compliance_ok from statictext within u_tabpage_hm_class_settings
integer x = 2683
integer y = 248
integer width = 201
integer height = 84
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup 			popup
str_popup_return	popup_return

popup.realitem = real(hmclasstab.hm_class.compliance_ok_percent)
Openwithparm(w_number,popup)

popup_return = Message.powerobjectparm

If popup_return.item = "CANCEL" Then Return

hmclasstab.hm_class.compliance_ok_percent = long(popup_return.realitem)

integer li_sts
li_sts = hmclasstab.update_class( )

refresh()


end event

