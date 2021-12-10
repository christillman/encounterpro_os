$PBExportHeader$w_schedule_item_edit.srw
forward
global type w_schedule_item_edit from window
end type
type st_3 from statictext within w_schedule_item_edit
end type
type st_2 from statictext within w_schedule_item_edit
end type
type cb_warning_days from commandbutton within w_schedule_item_edit
end type
type sle_warning_days from singlelineedit within w_schedule_item_edit
end type
type st_1 from statictext within w_schedule_item_edit
end type
type cb_age from commandbutton within w_schedule_item_edit
end type
type st_age_unit from statictext within w_schedule_item_edit
end type
type sle_age from singlelineedit within w_schedule_item_edit
end type
type pb_cancel from u_picture_button within w_schedule_item_edit
end type
type pb_close from u_picture_button within w_schedule_item_edit
end type
end forward

global type w_schedule_item_edit from window
integer x = 498
integer y = 200
integer width = 1902
integer height = 1400
windowtype windowtype = response!
long backcolor = 7191717
st_3 st_3
st_2 st_2
cb_warning_days cb_warning_days
sle_warning_days sle_warning_days
st_1 st_1
cb_age cb_age
st_age_unit st_age_unit
sle_age sle_age
pb_cancel pb_cancel
pb_close pb_close
end type
global w_schedule_item_edit w_schedule_item_edit

type variables
date age
u_unit age_unit


end variables

event open;str_popup popup
long ll_age
string ls_age_unit

popup = message.powerobjectparm

if popup.data_row_count = 0 then
	setnull(age)
	sle_age.text = ""
	age_unit = unit_list.find_unit("YEAR")
	sle_warning_days.text = "30"
else
	age = date(popup.items[1])
	f_pretty_age_unit(immunization_date_of_birth, age, ll_age, ls_age_unit)
	
	sle_age.text = string(ll_age)
	age_unit = unit_list.find_unit(ls_age_unit)
	
	sle_warning_days.text = popup.items[2]
end if

st_age_unit.text = age_unit.description



end event

on w_schedule_item_edit.create
this.st_3=create st_3
this.st_2=create st_2
this.cb_warning_days=create cb_warning_days
this.sle_warning_days=create sle_warning_days
this.st_1=create st_1
this.cb_age=create cb_age
this.st_age_unit=create st_age_unit
this.sle_age=create sle_age
this.pb_cancel=create pb_cancel
this.pb_close=create pb_close
this.Control[]={this.st_3,&
this.st_2,&
this.cb_warning_days,&
this.sle_warning_days,&
this.st_1,&
this.cb_age,&
this.st_age_unit,&
this.sle_age,&
this.pb_cancel,&
this.pb_close}
end on

on w_schedule_item_edit.destroy
destroy(this.st_3)
destroy(this.st_2)
destroy(this.cb_warning_days)
destroy(this.sle_warning_days)
destroy(this.st_1)
destroy(this.cb_age)
destroy(this.st_age_unit)
destroy(this.sle_age)
destroy(this.pb_cancel)
destroy(this.pb_close)
end on

type st_3 from statictext within w_schedule_item_edit
integer width = 1893
integer height = 148
integer textsize = -14
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Immunization Schedule Item"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_schedule_item_edit
integer x = 795
integer y = 284
integer width = 306
integer height = 112
integer textsize = -14
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 7191717
boolean enabled = false
string text = "Age"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_warning_days from commandbutton within w_schedule_item_edit
integer x = 960
integer y = 868
integer width = 146
integer height = 104
integer textsize = -16
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.realitem = real(sle_warning_days.text)

openwithparm(w_number, popup)

popup_return = message.powerobjectparm

if popup_return.item = "CANCEL" then return

sle_warning_days.text = string(popup_return.realitem)

end event

type sle_warning_days from singlelineedit within w_schedule_item_edit
integer x = 695
integer y = 868
integer width = 247
integer height = 104
integer taborder = 20
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_schedule_item_edit
integer x = 471
integer y = 736
integer width = 901
integer height = 112
integer textsize = -14
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 7191717
boolean enabled = false
string text = "Warning Days"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_age from commandbutton within w_schedule_item_edit
integer x = 809
integer y = 420
integer width = 146
integer height = 104
integer textsize = -16
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.realitem = real(sle_age.text)
popup.objectparm = age_unit

openwithparm(w_number, popup)

popup_return = message.powerobjectparm

if popup_return.item = "CANCEL" then return

sle_age.text = string(popup_return.realitem)

end event

type st_age_unit from statictext within w_schedule_item_edit
integer x = 1015
integer y = 420
integer width = 370
integer height = 104
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Month"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
u_unit luo_unit

popup.data_row_count = 4
popup.items[1] = "Days"
popup.items[2] = "Weeks"
popup.items[3] = "Months"
popup.items[4] = "Years"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count = 0 then return

CHOOSE CASE popup_return.item_indexes[1]
	CASE 1
		luo_unit = unit_list.find_unit("DAY")
	CASE 2
		luo_unit = unit_list.find_unit("WEEK")
	CASE 3
		luo_unit = unit_list.find_unit("MONTH")
	CASE 4
		luo_unit = unit_list.find_unit("YEAR")
END CHOOSE

if isnull(luo_unit) then return

age_unit = luo_unit
text = luo_unit.description


end event

type sle_age from singlelineedit within w_schedule_item_edit
integer x = 507
integer y = 420
integer width = 279
integer height = 104
integer taborder = 10
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type pb_cancel from u_picture_button within w_schedule_item_edit
integer x = 59
integer y = 1112
integer width = 256
integer height = 224
integer taborder = 0
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "button11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

on mouse_move;f_cpr_set_msg("Cancel")
end on

type pb_close from u_picture_button within w_schedule_item_edit
integer x = 1554
integer y = 1112
integer width = 256
integer height = 224
integer taborder = 0
boolean default = true
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return
long ll_age
datetime ldt_age

 DECLARE lsp_get_age_date PROCEDURE FOR dbo.sp_get_age_date
 			@pdt_from_date = :immunization_date_of_birth,
         @pl_add_number = :ll_age,   
         @ps_add_unit = :age_unit.unit_id,   
         @pdt_date = :ldt_age OUT  ;

ll_age = long(sle_age.text)

EXECUTE lsp_get_age_date;
if not tf_check() then return

FETCH lsp_get_age_date INTO :ldt_age;
if not tf_check() then return

CLOSE lsp_get_age_date;

popup_return.items[1] = string(date(ldt_age))
popup_return.items[2] = string(integer(sle_warning_days.text))
popup_return.item_count = 2

closewithreturn(parent, popup_return)


end event

