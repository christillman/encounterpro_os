HA$PBExportHeader$w_exam_selection_criteria.srw
forward
global type w_exam_selection_criteria from w_window_base
end type
type pb_done from u_picture_button within w_exam_selection_criteria
end type
type pb_cancel from u_picture_button within w_exam_selection_criteria
end type
type st_title from statictext within w_exam_selection_criteria
end type
type st_race_title from statictext within w_exam_selection_criteria
end type
type st_sex_title from statictext within w_exam_selection_criteria
end type
type st_stage_title from statictext within w_exam_selection_criteria
end type
type st_race from statictext within w_exam_selection_criteria
end type
type st_sex from statictext within w_exam_selection_criteria
end type
type st_age_range from statictext within w_exam_selection_criteria
end type
type cb_clear_age_range from commandbutton within w_exam_selection_criteria
end type
end forward

global type w_exam_selection_criteria from w_window_base
integer x = 347
integer y = 272
integer width = 2213
integer height = 1080
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
pb_done pb_done
pb_cancel pb_cancel
st_title st_title
st_race_title st_race_title
st_sex_title st_sex_title
st_stage_title st_stage_title
st_race st_race
st_sex st_sex
st_age_range st_age_range
cb_clear_age_range cb_clear_age_range
end type
global w_exam_selection_criteria w_exam_selection_criteria

type variables
string race
string sex
long age_range_id

end variables

on w_exam_selection_criteria.create
int iCurrent
call super::create
this.pb_done=create pb_done
this.pb_cancel=create pb_cancel
this.st_title=create st_title
this.st_race_title=create st_race_title
this.st_sex_title=create st_sex_title
this.st_stage_title=create st_stage_title
this.st_race=create st_race
this.st_sex=create st_sex
this.st_age_range=create st_age_range
this.cb_clear_age_range=create cb_clear_age_range
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_done
this.Control[iCurrent+2]=this.pb_cancel
this.Control[iCurrent+3]=this.st_title
this.Control[iCurrent+4]=this.st_race_title
this.Control[iCurrent+5]=this.st_sex_title
this.Control[iCurrent+6]=this.st_stage_title
this.Control[iCurrent+7]=this.st_race
this.Control[iCurrent+8]=this.st_sex
this.Control[iCurrent+9]=this.st_age_range
this.Control[iCurrent+10]=this.cb_clear_age_range
end on

on w_exam_selection_criteria.destroy
call super::destroy
destroy(this.pb_done)
destroy(this.pb_cancel)
destroy(this.st_title)
destroy(this.st_race_title)
destroy(this.st_sex_title)
destroy(this.st_stage_title)
destroy(this.st_race)
destroy(this.st_sex)
destroy(this.st_age_range)
destroy(this.cb_clear_age_range)
end on

event open;call super::open;str_popup popup

popup = message.powerobjectparm

st_title.text = popup.title

if popup.data_row_count <> 3 then
	log.log(this, "open", "Invalid Parameters", 4)
	close(this)
	return
end if

age_range_id = long(popup.items[1])
sex = popup.items[2]
race = popup.items[3]


if isnull(race) then
	st_race.text = "<Any>"
else
	st_race.text = race
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
else
	SELECT description
	INTO :st_age_range.text
	FROM c_Age_Range
	WHERE age_range_id = :age_range_id;
	if not tf_check() then
		log.log(this, "open", "Error getting stage description", 4)
		close(this)
		return
	end if
end if




end event

type pb_epro_help from w_window_base`pb_epro_help within w_exam_selection_criteria
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_exam_selection_criteria
end type

type pb_done from u_picture_button within w_exam_selection_criteria
integer x = 1893
integer y = 808
integer taborder = 10
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;long ll_row
str_popup_return popup_return


popup_return.items[1] = string(age_range_id)
if isnull(age_range_id) then
	setnull(popup_return.descriptions[1])
else
	popup_return.descriptions[1] = st_age_range.text
end if

popup_return.items[2] = sex
if isnull(sex) then
	setnull(popup_return.descriptions[2])
else
	popup_return.descriptions[2] = st_sex.text
end if

popup_return.items[3] = race
if isnull(race) then
	setnull(popup_return.descriptions[3])
else
	popup_return.descriptions[3] = st_race.text
end if


popup_return.item_count = 3

closewithreturn(parent, popup_return)



end event

type pb_cancel from u_picture_button within w_exam_selection_criteria
integer x = 73
integer y = 808
integer taborder = 30
boolean bringtotop = true
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 0

closewithreturn(parent, popup_return)


end event

type st_title from statictext within w_exam_selection_criteria
integer width = 2208
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

type st_race_title from statictext within w_exam_selection_criteria
integer x = 695
integer y = 676
integer width = 229
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

type st_sex_title from statictext within w_exam_selection_criteria
integer x = 686
integer y = 464
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

type st_stage_title from statictext within w_exam_selection_criteria
integer x = 453
integer y = 252
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

type st_race from statictext within w_exam_selection_criteria
integer x = 978
integer y = 656
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
string text = "<Any>"
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
popup.argument[1] = "RACE"
popup.add_blank_row = true
popup.blank_text = "<Any>"

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if trim(popup_return.items[1]) = "" then
	setnull(race)
	text = "<Any>"
else
	race = popup_return.items[1]
	text = popup_return.descriptions[1]
end if



end event

type st_sex from statictext within w_exam_selection_criteria
integer x = 978
integer y = 444
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

type st_age_range from statictext within w_exam_selection_criteria
integer x = 978
integer y = 232
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

event clicked;str_popup popup
str_popup_return popup_return

openwithparm(w_age_range_selection, "")
popup_return = message.powerobjectparm
if popup_return.item_count <> 6 then return

age_range_id = long(popup_return.items[1])
text = popup_return.descriptions[1]
cb_clear_age_range.visible = true


end event

type cb_clear_age_range from commandbutton within w_exam_selection_criteria
integer x = 1806
integer y = 268
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

event clicked;setnull(age_range_id)
st_age_range.text = "<Any>"
visible = false

end event

