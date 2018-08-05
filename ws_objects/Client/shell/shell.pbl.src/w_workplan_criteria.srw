$PBExportHeader$w_workplan_criteria.srw
forward
global type w_workplan_criteria from w_window_base
end type
type st_title from statictext within w_workplan_criteria
end type
type st_new_flag_title from statictext within w_workplan_criteria
end type
type st_sex_title from statictext within w_workplan_criteria
end type
type st_stage_title from statictext within w_workplan_criteria
end type
type st_new_flag from statictext within w_workplan_criteria
end type
type st_sex from statictext within w_workplan_criteria
end type
type st_age_range from statictext within w_workplan_criteria
end type
type sle_modes from singlelineedit within w_workplan_criteria
end type
type st_modes_title from statictext within w_workplan_criteria
end type
type cb_clear_age_range from commandbutton within w_workplan_criteria
end type
type st_workplan_owner_title from statictext within w_workplan_criteria
end type
type st_workplan_owner from statictext within w_workplan_criteria
end type
type cb_clear_workplan_owner from commandbutton within w_workplan_criteria
end type
type cb_ok from commandbutton within w_workplan_criteria
end type
type cb_cancel from commandbutton within w_workplan_criteria
end type
type st_abnormal_flag_title from statictext within w_workplan_criteria
end type
type st_abnormal_flag from statictext within w_workplan_criteria
end type
type st_severity_title from statictext within w_workplan_criteria
end type
type st_severity from statictext within w_workplan_criteria
end type
end forward

global type w_workplan_criteria from w_window_base
integer x = 347
integer y = 272
integer width = 2606
integer height = 1632
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_title st_title
st_new_flag_title st_new_flag_title
st_sex_title st_sex_title
st_stage_title st_stage_title
st_new_flag st_new_flag
st_sex st_sex
st_age_range st_age_range
sle_modes sle_modes
st_modes_title st_modes_title
cb_clear_age_range cb_clear_age_range
st_workplan_owner_title st_workplan_owner_title
st_workplan_owner st_workplan_owner
cb_clear_workplan_owner cb_clear_workplan_owner
cb_ok cb_ok
cb_cancel cb_cancel
st_abnormal_flag_title st_abnormal_flag_title
st_abnormal_flag st_abnormal_flag
st_severity_title st_severity_title
st_severity st_severity
end type
global w_workplan_criteria w_workplan_criteria

type variables
str_workplan_item_criteria criteria
str_workplan_item_criteria original_criteria

end variables

on w_workplan_criteria.create
int iCurrent
call super::create
this.st_title=create st_title
this.st_new_flag_title=create st_new_flag_title
this.st_sex_title=create st_sex_title
this.st_stage_title=create st_stage_title
this.st_new_flag=create st_new_flag
this.st_sex=create st_sex
this.st_age_range=create st_age_range
this.sle_modes=create sle_modes
this.st_modes_title=create st_modes_title
this.cb_clear_age_range=create cb_clear_age_range
this.st_workplan_owner_title=create st_workplan_owner_title
this.st_workplan_owner=create st_workplan_owner
this.cb_clear_workplan_owner=create cb_clear_workplan_owner
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.st_abnormal_flag_title=create st_abnormal_flag_title
this.st_abnormal_flag=create st_abnormal_flag
this.st_severity_title=create st_severity_title
this.st_severity=create st_severity
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.st_new_flag_title
this.Control[iCurrent+3]=this.st_sex_title
this.Control[iCurrent+4]=this.st_stage_title
this.Control[iCurrent+5]=this.st_new_flag
this.Control[iCurrent+6]=this.st_sex
this.Control[iCurrent+7]=this.st_age_range
this.Control[iCurrent+8]=this.sle_modes
this.Control[iCurrent+9]=this.st_modes_title
this.Control[iCurrent+10]=this.cb_clear_age_range
this.Control[iCurrent+11]=this.st_workplan_owner_title
this.Control[iCurrent+12]=this.st_workplan_owner
this.Control[iCurrent+13]=this.cb_clear_workplan_owner
this.Control[iCurrent+14]=this.cb_ok
this.Control[iCurrent+15]=this.cb_cancel
this.Control[iCurrent+16]=this.st_abnormal_flag_title
this.Control[iCurrent+17]=this.st_abnormal_flag
this.Control[iCurrent+18]=this.st_severity_title
this.Control[iCurrent+19]=this.st_severity
end on

on w_workplan_criteria.destroy
call super::destroy
destroy(this.st_title)
destroy(this.st_new_flag_title)
destroy(this.st_sex_title)
destroy(this.st_stage_title)
destroy(this.st_new_flag)
destroy(this.st_sex)
destroy(this.st_age_range)
destroy(this.sle_modes)
destroy(this.st_modes_title)
destroy(this.cb_clear_age_range)
destroy(this.st_workplan_owner_title)
destroy(this.st_workplan_owner)
destroy(this.cb_clear_workplan_owner)
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.st_abnormal_flag_title)
destroy(this.st_abnormal_flag)
destroy(this.st_severity_title)
destroy(this.st_severity)
end on

event open;call super::open;str_popup popup

criteria = message.powerobjectparm
original_criteria = criteria

st_title.text = criteria.criteria_title + " Criteria"


if isnull(criteria.new_flag) then
	st_new_flag.text = "<Any>"
elseif criteria.new_flag = "Y" then
	st_new_flag.text = "New"
else
	criteria.new_flag = "N"
	st_new_flag.text = "Established"
end if

if isnull(criteria.sex) then
	st_sex.text = "<Any>"
elseif criteria.sex = "M" then
	st_sex.text = "Male"
else
	criteria.sex = "F"
	st_sex.text = "Female"
end if

if isnull(criteria.age_range_id) then
	st_age_range.text = "<Any>"
	cb_clear_age_range.visible = false
else
	SELECT description
	INTO :st_age_range.text
	FROM c_Age_Range
	WHERE age_range_id = :criteria.age_range_id;
	if not tf_check() then
		log.log(this, "w_workplan_criteria:open", "Error getting stage description", 4)
		close(this)
		return
	end if
	cb_clear_age_range.visible = true
end if

if isnull(criteria.workplan_owner) then
	st_workplan_owner.text = "<Any>"
	cb_clear_workplan_owner.visible = false
else
	if user_list.is_role(criteria.workplan_owner) then
		st_workplan_owner.text = user_list.role_description(criteria.workplan_owner)
		st_workplan_owner.backcolor = user_list.role_color(criteria.workplan_owner)
	else
		st_workplan_owner.text = user_list.user_full_name(criteria.workplan_owner)
		st_workplan_owner.backcolor = user_list.user_color(criteria.workplan_owner)
	end if
end if

// Earlier versions of Epro automatically set the Abnormal_flag to "N".  This would cause undesired workplan item skipping
// so we're using 0,1 as the valid domain for c_workplan_item and mapping "N" to NULL which means <Any>
if isnull(criteria.abnormal_flag) or criteria.abnormal_flag = "N" then
	setnull(criteria.abnormal_flag)
	st_abnormal_flag.text = "<Any>"
elseif criteria.abnormal_flag = "1" then
	st_abnormal_flag.text = "Yes"
else
	criteria.abnormal_flag = "0"
	st_abnormal_flag.text = "No"
end if

if isnull(criteria.severity) then
	st_severity.text = "<Any>"
else
	st_severity.text = string(criteria.severity)
end if


end event

type pb_epro_help from w_window_base`pb_epro_help within w_workplan_criteria
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_workplan_criteria
end type

type st_title from statictext within w_workplan_criteria
integer width = 2601
integer height = 132
boolean bringtotop = true
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type st_new_flag_title from statictext within w_workplan_criteria
integer x = 325
integer y = 276
integer width = 731
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
string text = "New/Etablished Patient:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_sex_title from statictext within w_workplan_criteria
integer x = 818
integer y = 476
integer width = 238
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

type st_stage_title from statictext within w_workplan_criteria
integer x = 585
integer y = 676
integer width = 471
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
string text = "Patient Stage:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_new_flag from statictext within w_workplan_criteria
integer x = 1083
integer y = 256
integer width = 466
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Established"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.data_row_count = 3
popup.items[1] = "<Any>"
popup.items[2] = "New"
popup.items[3] = "Established"

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

text = popup_return.items[1]

if popup_return.items[1] = "<Any>" then
	setnull(criteria.new_flag)
elseif popup_return.items[1] = "New" then
	criteria.new_flag = "Y"
else
	criteria.new_flag = "N"
end if


end event

type st_sex from statictext within w_workplan_criteria
integer x = 1083
integer y = 456
integer width = 466
integer height = 112
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

popup.data_row_count = 3
popup.items[1] = "<Any>"
popup.items[2] = "Male"
popup.items[3] = "Female"

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

text = popup_return.items[1]

if popup_return.items[1] = "<Any>" then
	setnull(criteria.sex)
elseif popup_return.items[1] = "Male" then
	criteria.sex = "M"
else
	criteria.sex = "F"
end if


end event

type st_age_range from statictext within w_workplan_criteria
integer x = 1083
integer y = 656
integer width = 814
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "20 Years"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup_return popup_return


openwithparm(w_age_range_selection, "")
popup_return = message.powerobjectparm
if popup_return.item_count <> 6 then return

criteria.age_range_id = long(popup_return.items[1])
text = popup_return.descriptions[1]
cb_clear_age_range.visible = true

end event

type sle_modes from singlelineedit within w_workplan_criteria
integer x = 626
integer y = 1256
integer width = 1531
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
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type st_modes_title from statictext within w_workplan_criteria
integer x = 315
integer y = 1256
integer width = 288
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
string text = "Modes:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_clear_age_range from commandbutton within w_workplan_criteria
integer x = 1906
integer y = 692
integer width = 256
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear"
end type

event clicked;setnull(criteria.age_range_id)
st_age_range.text = "<Any>"
visible = false

end event

type st_workplan_owner_title from statictext within w_workplan_criteria
integer x = 325
integer y = 876
integer width = 731
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
string text = "Workplan Owner:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_workplan_owner from statictext within w_workplan_criteria
integer x = 1083
integer y = 856
integer width = 814
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "<Any>"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;u_user luo_user

luo_user = user_list.pick_user(true, false, false)
if isnull(luo_user) then return

text = luo_user.user_full_name
backcolor = luo_user.color

criteria.workplan_owner = luo_user.user_id

cb_clear_workplan_owner.visible = true

end event

type cb_clear_workplan_owner from commandbutton within w_workplan_criteria
integer x = 1906
integer y = 892
integer width = 256
integer height = 76
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear"
end type

event clicked;setnull(criteria.workplan_owner)
st_workplan_owner.text = "<Any>"
st_workplan_owner.backcolor = color_object
visible = false

end event

type cb_ok from commandbutton within w_workplan_criteria
integer x = 2158
integer y = 1468
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

event clicked;closewithreturn(parent, criteria)



end event

type cb_cancel from commandbutton within w_workplan_criteria
integer x = 46
integer y = 1476
integer width = 402
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;closewithreturn(parent, original_criteria)


end event

type st_abnormal_flag_title from statictext within w_workplan_criteria
integer x = 105
integer y = 1076
integer width = 951
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
string text = "Abnormal Results Present:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_abnormal_flag from statictext within w_workplan_criteria
integer x = 1083
integer y = 1056
integer width = 229
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "No"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.data_row_count = 3
popup.items[1] = "<Any>"
popup.items[2] = "Yes"
popup.items[3] = "No"

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

text = popup_return.items[1]

if popup_return.items[1] = "<Any>" then
	setnull(criteria.abnormal_flag)
elseif popup_return.items[1] = "Yes" then
	criteria.abnormal_flag = "1"
else
	criteria.abnormal_flag = "0"
end if



end event

type st_severity_title from statictext within w_workplan_criteria
integer x = 1413
integer y = 1076
integer width = 590
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
string text = "Min Result Severity:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_severity from statictext within w_workplan_criteria
integer x = 2025
integer y = 1056
integer width = 229
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "<Any>"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string ls_bitmap
str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_domain_pick_list"
popup.datacolumn = 2
popup.displaycolumn = 3
popup.argument_count = 1
popup.argument[1] = "RESULTSEVERITY"
popup.add_blank_row = true
popup.blank_text = "<Any>"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count = 0 then return

text = popup_return.descriptions[1]

if popup_return.items[1] = "" then
	setnull(criteria.severity)
else
	criteria.severity = integer(popup_return.items[1])
end if


end event

