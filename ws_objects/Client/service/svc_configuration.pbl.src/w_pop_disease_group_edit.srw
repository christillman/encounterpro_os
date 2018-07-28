$PBExportHeader$w_pop_disease_group_edit.srw
forward
global type w_pop_disease_group_edit from w_window_base
end type
type cb_ok from commandbutton within w_pop_disease_group_edit
end type
type st_age_range_title from statictext within w_pop_disease_group_edit
end type
type st_sex_title from statictext within w_pop_disease_group_edit
end type
type st_title from statictext within w_pop_disease_group_edit
end type
type st_description_title from statictext within w_pop_disease_group_edit
end type
type sle_description from singlelineedit within w_pop_disease_group_edit
end type
type st_age_range from statictext within w_pop_disease_group_edit
end type
type st_sex_any from statictext within w_pop_disease_group_edit
end type
type st_sex_male from statictext within w_pop_disease_group_edit
end type
type st_sex_female from statictext within w_pop_disease_group_edit
end type
type cb_clear_age_range from commandbutton within w_pop_disease_group_edit
end type
type cb_cancel from commandbutton within w_pop_disease_group_edit
end type
end forward

global type w_pop_disease_group_edit from w_window_base
integer x = 951
integer y = 400
integer width = 2167
integer height = 1004
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_ok cb_ok
st_age_range_title st_age_range_title
st_sex_title st_sex_title
st_title st_title
st_description_title st_description_title
sle_description sle_description
st_age_range st_age_range
st_sex_any st_sex_any
st_sex_male st_sex_male
st_sex_female st_sex_female
cb_clear_age_range cb_clear_age_range
cb_cancel cb_cancel
end type
global w_pop_disease_group_edit w_pop_disease_group_edit

type variables
string disease_group

long age_range_id
string sex

end variables

forward prototypes
public function integer save_changes ()
end prototypes

public function integer save_changes ();

UPDATE c_Disease_Group
SET description = :sle_description.text,
	age_range = :age_range_id,
	sex = :sex
WHERE disease_group = :disease_group;
if not tf_check() then return -1

return 1

end function

on w_pop_disease_group_edit.create
int iCurrent
call super::create
this.cb_ok=create cb_ok
this.st_age_range_title=create st_age_range_title
this.st_sex_title=create st_sex_title
this.st_title=create st_title
this.st_description_title=create st_description_title
this.sle_description=create sle_description
this.st_age_range=create st_age_range
this.st_sex_any=create st_sex_any
this.st_sex_male=create st_sex_male
this.st_sex_female=create st_sex_female
this.cb_clear_age_range=create cb_clear_age_range
this.cb_cancel=create cb_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ok
this.Control[iCurrent+2]=this.st_age_range_title
this.Control[iCurrent+3]=this.st_sex_title
this.Control[iCurrent+4]=this.st_title
this.Control[iCurrent+5]=this.st_description_title
this.Control[iCurrent+6]=this.sle_description
this.Control[iCurrent+7]=this.st_age_range
this.Control[iCurrent+8]=this.st_sex_any
this.Control[iCurrent+9]=this.st_sex_male
this.Control[iCurrent+10]=this.st_sex_female
this.Control[iCurrent+11]=this.cb_clear_age_range
this.Control[iCurrent+12]=this.cb_cancel
end on

on w_pop_disease_group_edit.destroy
call super::destroy
destroy(this.cb_ok)
destroy(this.st_age_range_title)
destroy(this.st_sex_title)
destroy(this.st_title)
destroy(this.st_description_title)
destroy(this.sle_description)
destroy(this.st_age_range)
destroy(this.st_sex_any)
destroy(this.st_sex_male)
destroy(this.st_sex_female)
destroy(this.cb_clear_age_range)
destroy(this.cb_cancel)
end on

event open;call super::open;
disease_group = message.stringparm

st_title.text = "Disease Group Properties for " + disease_group

SELECT g.description, g.age_range, g.sex, a.description
INTO :sle_description.text, :age_range_id, :sex, :st_age_range.text
FROM c_Disease_Group g
	LEFT OUTER JOIN c_Age_Range a
	ON g.age_range = a.age_range_id
WHERE disease_group = :disease_group;
if not tf_check() then
	close(this)
	return
end if

if isnull(age_range_id) then
	st_age_range.text = "<Any>"
	cb_clear_age_range.visible = false
else
	cb_clear_age_range.visible = true
end if

if isnull(sex) then
	st_sex_any.backcolor = color_object_selected
elseif sex = "M" then
	st_sex_male.backcolor = color_object_selected
else
	st_sex_female.backcolor = color_object_selected
end if

center_popup()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_pop_disease_group_edit
integer x = 2519
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_pop_disease_group_edit
end type

type cb_ok from commandbutton within w_pop_disease_group_edit
integer x = 1591
integer y = 744
integer width = 475
integer height = 112
integer taborder = 30
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

event clicked;integer li_sts

li_sts = save_changes()
if li_sts <= 0 then return

close(parent)

end event

type st_age_range_title from statictext within w_pop_disease_group_edit
integer x = 87
integer y = 372
integer width = 411
integer height = 84
boolean bringtotop = true
integer textsize = -11
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

type st_sex_title from statictext within w_pop_disease_group_edit
integer x = 87
integer y = 556
integer width = 411
integer height = 64
boolean bringtotop = true
integer textsize = -11
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

type st_title from statictext within w_pop_disease_group_edit
integer width = 2171
integer height = 140
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Disease Group Properties for ~"xxxxxxxxxxxxx~""
alignment alignment = center!
boolean focusrectangle = false
end type

type st_description_title from statictext within w_pop_disease_group_edit
integer x = 55
integer y = 196
integer width = 443
integer height = 84
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Description"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_description from singlelineedit within w_pop_disease_group_edit
integer x = 535
integer y = 180
integer width = 1499
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
borderstyle borderstyle = stylelowered!
end type

type st_age_range from statictext within w_pop_disease_group_edit
integer x = 535
integer y = 360
integer width = 1029
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
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
integer li_sts

openwithparm(w_age_range_selection,"Immunization")
popup_return = Message.powerobjectparm
If popup_return.item_count < 1 Then return

text = popup_return.descriptions[1]
age_range_id = long(popup_return.items[1])


cb_clear_age_range.visible = true

end event

type st_sex_any from statictext within w_pop_disease_group_edit
integer x = 1367
integer y = 536
integer width = 325
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
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

event clicked;st_sex_male.backcolor = color_object
st_sex_female.backcolor = color_object
st_sex_any.backcolor = color_object_selected

setnull(sex)

end event

type st_sex_male from statictext within w_pop_disease_group_edit
integer x = 535
integer y = 536
integer width = 325
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Male"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_sex_male.backcolor = color_object_selected
st_sex_female.backcolor = color_object
st_sex_any.backcolor = color_object

sex = "M"

end event

type st_sex_female from statictext within w_pop_disease_group_edit
integer x = 951
integer y = 536
integer width = 325
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Female"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_sex_male.backcolor = color_object
st_sex_female.backcolor = color_object_selected
st_sex_any.backcolor = color_object

sex = "F"

end event

type cb_clear_age_range from commandbutton within w_pop_disease_group_edit
integer x = 1577
integer y = 404
integer width = 183
integer height = 64
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear"
end type

event clicked;setnull(age_range_id)
st_age_range.text = "<Any>"

cb_clear_age_range.visible = false

end event

type cb_cancel from commandbutton within w_pop_disease_group_edit
integer x = 87
integer y = 740
integer width = 475
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

event clicked;close(parent)

end event

