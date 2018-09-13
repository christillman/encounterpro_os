$PBExportHeader$w_encounter_workplan_criteria.srw
forward
global type w_encounter_workplan_criteria from w_window_base
end type
type st_title from statictext within w_encounter_workplan_criteria
end type
type st_new_flag_title from statictext within w_encounter_workplan_criteria
end type
type st_sex_title from statictext within w_encounter_workplan_criteria
end type
type st_stage_title from statictext within w_encounter_workplan_criteria
end type
type st_new_flag from statictext within w_encounter_workplan_criteria
end type
type st_sex from statictext within w_encounter_workplan_criteria
end type
type st_age_range from statictext within w_encounter_workplan_criteria
end type
type cb_clear_age_range from commandbutton within w_encounter_workplan_criteria
end type
type cb_ok from commandbutton within w_encounter_workplan_criteria
end type
type cb_cancel from commandbutton within w_encounter_workplan_criteria
end type
end forward

global type w_encounter_workplan_criteria from w_window_base
integer x = 347
integer y = 272
integer width = 2606
integer height = 1072
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
cb_clear_age_range cb_clear_age_range
cb_ok cb_ok
cb_cancel cb_cancel
end type
global w_encounter_workplan_criteria w_encounter_workplan_criteria

type variables
string new_flag
string sex
long age_range_id

end variables

on w_encounter_workplan_criteria.create
int iCurrent
call super::create
this.st_title=create st_title
this.st_new_flag_title=create st_new_flag_title
this.st_sex_title=create st_sex_title
this.st_stage_title=create st_stage_title
this.st_new_flag=create st_new_flag
this.st_sex=create st_sex
this.st_age_range=create st_age_range
this.cb_clear_age_range=create cb_clear_age_range
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.st_new_flag_title
this.Control[iCurrent+3]=this.st_sex_title
this.Control[iCurrent+4]=this.st_stage_title
this.Control[iCurrent+5]=this.st_new_flag
this.Control[iCurrent+6]=this.st_sex
this.Control[iCurrent+7]=this.st_age_range
this.Control[iCurrent+8]=this.cb_clear_age_range
this.Control[iCurrent+9]=this.cb_ok
this.Control[iCurrent+10]=this.cb_cancel
end on

on w_encounter_workplan_criteria.destroy
call super::destroy
destroy(this.st_title)
destroy(this.st_new_flag_title)
destroy(this.st_sex_title)
destroy(this.st_stage_title)
destroy(this.st_new_flag)
destroy(this.st_sex)
destroy(this.st_age_range)
destroy(this.cb_clear_age_range)
destroy(this.cb_ok)
destroy(this.cb_cancel)
end on

event open;call super::open;str_popup popup

popup = message.powerobjectparm

st_title.text = popup.title + " Criteria"

if popup.data_row_count <> 3 then
	log.log(this, "w_encounter_workplan_criteria:open", "Invalid Parameters", 4)
	close(this)
	return
end if

new_flag = popup.items[1]
sex = popup.items[2]
age_range_id = long(popup.items[3])


if isnull(new_flag) then
	st_new_flag.text = "<Any>"
elseif new_flag = "Y" then
	st_new_flag.text = "New"
else
	new_flag = "N"
	st_new_flag.text = "Established"
end if

if isnull(sex) then
	st_sex.text = "<Any>"
elseif sex = "M" then
	st_sex.text = "Male"
else
	sex = "F"
	st_sex.text = "Female"
end if

if isnull(age_range_id) then
	st_age_range.text = "<Any>"
	cb_clear_age_range.visible = false
else
	SELECT description
	INTO :st_age_range.text
	FROM c_Age_Range
	WHERE age_range_id = :age_range_id;
	if not tf_check() then
		log.log(this, "w_encounter_workplan_criteria:open", "Error getting stage description", 4)
		close(this)
		return
	end if
	cb_clear_age_range.visible = true
end if


end event

type pb_epro_help from w_window_base`pb_epro_help within w_encounter_workplan_criteria
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_encounter_workplan_criteria
integer y = 856
end type

type st_title from statictext within w_encounter_workplan_criteria
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

type st_new_flag_title from statictext within w_encounter_workplan_criteria
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

type st_sex_title from statictext within w_encounter_workplan_criteria
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

type st_stage_title from statictext within w_encounter_workplan_criteria
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

type st_new_flag from statictext within w_encounter_workplan_criteria
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
	setnull(new_flag)
elseif popup_return.items[1] = "New" then
	new_flag = "Y"
else
	new_flag = "N"
end if


end event

type st_sex from statictext within w_encounter_workplan_criteria
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
	setnull(sex)
elseif popup_return.items[1] = "Male" then
	sex = "M"
else
	sex = "F"
end if


end event

type st_age_range from statictext within w_encounter_workplan_criteria
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

age_range_id = long(popup_return.items[1])
text = popup_return.descriptions[1]
cb_clear_age_range.visible = true

end event

type cb_clear_age_range from commandbutton within w_encounter_workplan_criteria
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

event clicked;setnull(age_range_id)
st_age_range.text = "<Any>"
visible = false

end event

type cb_ok from commandbutton within w_encounter_workplan_criteria
integer x = 2158
integer y = 900
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

event clicked;long ll_row
str_popup_return popup_return


popup_return.item_count = 3

popup_return.items[1] = new_flag
popup_return.descriptions[1] = st_new_flag.text
popup_return.items[2] = sex
popup_return.descriptions[2] = st_sex.text
popup_return.items[3] = string(age_range_id)
popup_return.descriptions[3] = st_age_range.text

closewithreturn(parent, popup_return)



end event

type cb_cancel from commandbutton within w_encounter_workplan_criteria
integer x = 46
integer y = 908
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

event clicked;str_popup_return popup_return

popup_return.item_count = 0

closewithreturn(parent, popup_return)


end event

