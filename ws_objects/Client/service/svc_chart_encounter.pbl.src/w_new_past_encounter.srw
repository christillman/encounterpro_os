$PBExportHeader$w_new_past_encounter.srw
forward
global type w_new_past_encounter from w_window_base
end type
type st_attending_doctor from statictext within w_new_past_encounter
end type
type st_1 from statictext within w_new_past_encounter
end type
type st_location from statictext within w_new_past_encounter
end type
type st_2 from statictext within w_new_past_encounter
end type
type st_encounter_date from statictext within w_new_past_encounter
end type
type st_date_title from statictext within w_new_past_encounter
end type
type st_encounter_type_title from statictext within w_new_past_encounter
end type
type st_encounter_type from statictext within w_new_past_encounter
end type
type cb_ok from commandbutton within w_new_past_encounter
end type
type cb_cancel from commandbutton within w_new_past_encounter
end type
type st_title from statictext within w_new_past_encounter
end type
end forward

global type w_new_past_encounter from w_window_base
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_attending_doctor st_attending_doctor
st_1 st_1
st_location st_location
st_2 st_2
st_encounter_date st_encounter_date
st_date_title st_date_title
st_encounter_type_title st_encounter_type_title
st_encounter_type st_encounter_type
cb_ok cb_ok
cb_cancel cb_cancel
st_title st_title
end type
global w_new_past_encounter w_new_past_encounter

type variables
string encounter_type
string attending_doctor
string encounter_office_id
date encounter_date

end variables

on w_new_past_encounter.create
int iCurrent
call super::create
this.st_attending_doctor=create st_attending_doctor
this.st_1=create st_1
this.st_location=create st_location
this.st_2=create st_2
this.st_encounter_date=create st_encounter_date
this.st_date_title=create st_date_title
this.st_encounter_type_title=create st_encounter_type_title
this.st_encounter_type=create st_encounter_type
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.st_title=create st_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_attending_doctor
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_location
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_encounter_date
this.Control[iCurrent+6]=this.st_date_title
this.Control[iCurrent+7]=this.st_encounter_type_title
this.Control[iCurrent+8]=this.st_encounter_type
this.Control[iCurrent+9]=this.cb_ok
this.Control[iCurrent+10]=this.cb_cancel
this.Control[iCurrent+11]=this.st_title
end on

on w_new_past_encounter.destroy
call super::destroy
destroy(this.st_attending_doctor)
destroy(this.st_1)
destroy(this.st_location)
destroy(this.st_2)
destroy(this.st_encounter_date)
destroy(this.st_date_title)
destroy(this.st_encounter_type_title)
destroy(this.st_encounter_type)
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.st_title)
end on

event open;call super::open;str_popup popup
integer li_pos
string ls_image
str_popup_return popup_return

popup_return.item_count = 0

encounter_date = today()
st_encounter_date.text = string(encounter_date, date_format_string)

setnull(encounter_type)

st_attending_doctor.text = current_user.user_short_name
st_attending_doctor.backcolor = current_user.color
attending_doctor = current_user.user_id

encounter_office_id = gnv_app.office_id
st_location.text = office_description

if isnull(current_patient) then
	title = st_title.text
else
	title = current_patient.id_line()
end if

end event

type pb_epro_help from w_window_base`pb_epro_help within w_new_past_encounter
boolean visible = true
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_new_past_encounter
end type

type st_attending_doctor from statictext within w_new_past_encounter
integer x = 1083
integer y = 1004
integer width = 718
integer height = 124
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "<None>"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;u_user luo_user

luo_user = user_list.pick_user("ALL", true)
if isnull(luo_user) then return

text = luo_user.user_full_name
backcolor = luo_user.color

attending_doctor = luo_user.user_id


end event

type st_1 from statictext within w_new_past_encounter
integer x = 347
integer y = 1028
integer width = 713
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Provider:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_location from statictext within w_new_past_encounter
integer x = 1083
integer y = 1300
integer width = 718
integer height = 124
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "<None>"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;integer i
str_popup popup
str_popup_return popup_return
string lsa_user_id[]

popup.dataobject = "dw_pick_office_location"
popup.datacolumn = 1
popup.displaycolumn = 2

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm

if popup_return.item_count <> 1 then return

text = popup_return.descriptions[1]
encounter_office_id = popup_return.items[1]


end event

type st_2 from statictext within w_new_past_encounter
integer x = 347
integer y = 1324
integer width = 713
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Location:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_encounter_date from statictext within w_new_past_encounter
integer x = 1083
integer y = 412
integer width = 745
integer height = 124
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "<None>"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string ls_date

ls_date = f_select_date(encounter_date, "Past Encounter Date")
if not isnull(ls_date) then
	text = ls_date
	encounter_date = date(ls_date)
end if

end event

type st_date_title from statictext within w_new_past_encounter
integer x = 347
integer y = 436
integer width = 713
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Encounter Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_encounter_type_title from statictext within w_new_past_encounter
integer x = 347
integer y = 732
integer width = 713
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Encounter Type:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_encounter_type from statictext within w_new_past_encounter
integer x = 1083
integer y = 708
integer width = 1495
integer height = 124
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "<None>"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
string ls_encounter_type

popup.data_row_count = 2
popup.items[1] = "PICK"
popup.items[2] = "D"

openwithparm(w_pick_encounter_type, popup)
ls_encounter_type = message.stringparm
if isnull(ls_encounter_type) then return

encounter_type = ls_encounter_type
text = datalist.encounter_type_description(encounter_type)


end event

type cb_ok from commandbutton within w_new_past_encounter
integer x = 2409
integer y = 1588
integer width = 402
integer height = 112
integer taborder = 31
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

if isnull(encounter_type) then
	openwithparm(w_pop_message, "You must Select an Encounter Type")
	return
end if

if isnull(attending_doctor) then
	openwithparm(w_pop_message, "You must Select a Provider")
	return
end if

popup_return.items[1] = encounter_type
popup_return.items[2] = string(encounter_date, "[shortdate]")
popup_return.items[3] = attending_doctor
popup_return.items[4] = encounter_office_id
popup_return.item_count = 4

closewithreturn(parent, popup_return)

end event

type cb_cancel from commandbutton within w_new_past_encounter
integer x = 2021
integer y = 1588
integer width = 352
integer height = 112
integer taborder = 41
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

type st_title from statictext within w_new_past_encounter
integer width = 2921
integer height = 132
integer textsize = -20
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Chart Past Encounter"
alignment alignment = center!
boolean focusrectangle = false
end type

