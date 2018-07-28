$PBExportHeader$w_package_edit.srw
forward
global type w_package_edit from w_window_base
end type
type st_description from statictext within w_package_edit
end type
type st_administer_method from statictext within w_package_edit
end type
type st_administer_unit from statictext within w_package_edit
end type
type st_dose_unit from statictext within w_package_edit
end type
type st_administer_method_title from statictext within w_package_edit
end type
type st_2 from statictext within w_package_edit
end type
type st_3 from statictext within w_package_edit
end type
type st_4 from statictext within w_package_edit
end type
type st_5 from statictext within w_package_edit
end type
type pb_done from u_picture_button within w_package_edit
end type
type pb_cancel from u_picture_button within w_package_edit
end type
type sle_administer_per_dose from singlelineedit within w_package_edit
end type
type sle_dose_amount from singlelineedit within w_package_edit
end type
end forward

global type w_package_edit from w_window_base
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
event post_open pbm_custom01
st_description st_description
st_administer_method st_administer_method
st_administer_unit st_administer_unit
st_dose_unit st_dose_unit
st_administer_method_title st_administer_method_title
st_2 st_2
st_3 st_3
st_4 st_4
st_5 st_5
pb_done pb_done
pb_cancel pb_cancel
sle_administer_per_dose sle_administer_per_dose
sle_dose_amount sle_dose_amount
end type
global w_package_edit w_package_edit

type variables
string package_id
string dosage_form
string dosage_form_description
u_unit dose_unit
u_unit administer_unit
string dose_in_name_flag
string administer_method

end variables

forward prototypes
public function integer pick_dosage_form ()
public function integer get_package_data ()
public function string description ()
end prototypes

event post_open;call super::post_open;integer li_sts
str_popup_return popup_return
popup_return.item_count = 0
// if package_id is null then create a new package
if isnull(package_id) then
	li_sts = pick_dosage_form()
	if li_sts <= 0 then
		closewithreturn(this, popup_return)
		return
	end if
	sle_administer_per_dose.setfocus()
else
	li_sts = get_package_data()
	if li_sts <= 0 then
		closewithreturn(this, popup_return)
		return
	end if
end if


end event

public function integer pick_dosage_form ();integer li_sts
str_popup popup
str_popup_return popup_return
string ls_administer_method_description
real lr_dose_amount
string ls_dose_unit
string ls_administer_unit

popup.dataobject = "dw_dosage_form_list"
popup.datacolumn = 1
popup.displaycolumn = 2
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if isnull(popup_return.item) then return 0

dosage_form = popup_return.item

li_sts = tf_get_dosage_form_detail( &
				dosage_form, &
				dosage_form_description, &
				administer_method, &
				ls_administer_method_description, &
				lr_dose_amount, &
				ls_dose_unit, &
				dose_in_name_flag, &
				ls_administer_unit)
				
if li_sts <= 0 then return li_sts

st_administer_method.text = ls_administer_method_description

dose_unit = unit_list.find_unit(ls_dose_unit)
if not isnull(dose_unit) then
	st_dose_unit.text = dose_unit.description
else
	st_dose_unit.text = ""
end if

if lr_dose_amount <= 0 or isnull(lr_dose_amount) then
	sle_dose_amount.text = "1"
else
	sle_dose_amount.text = string(lr_dose_amount)
end if

administer_unit = unit_list.find_unit(ls_administer_unit)
if not isnull(administer_unit) then
	st_administer_unit.text = administer_unit.description
else
	st_administer_unit.text = ""
end if

st_description.text = "New " + dosage_form_description + " Package"

return 1


end function

public function integer get_package_data ();string ls_administer_unit
string ls_dose_unit
real lr_administer_per_dose
string ls_package_description
string ls_administer_method
string ls_method_description
real lr_dose_amount
integer li_sts

li_sts = tf_get_package( &
							package_id, &
							ls_administer_method, &
							ls_administer_unit, &
							ls_dose_unit, &
							lr_administer_per_dose, &
							ls_package_description, &
							ls_method_description, &
							lr_dose_amount, &
							dosage_form)

if li_sts <= 0 then return li_sts

dose_unit = unit_list.find_unit(ls_dose_unit)
if isnull(dose_unit) then
	log.log(this, "get_package_date()", "Invalid Dose Unit (" + ls_dose_unit + ")", 4)
	return 0
end if

administer_unit = unit_list.find_unit(ls_administer_unit)
if isnull(administer_unit) then
	log.log(this, "get_package_date()", "Invalid Dose Unit (" + ls_administer_unit + ")", 4)
	return 0
end if

li_sts = tf_get_dosage_form(dosage_form, dosage_form_description)
if li_sts <= 0 then return li_sts

st_description.text = ls_package_description
st_administer_method.text = ls_method_description
st_dose_unit.text = dose_unit.description
st_administer_unit.text = administer_unit.description
sle_administer_per_dose.text = string(lr_administer_per_dose)
sle_dose_amount.text = string(lr_dose_amount)

return 1

end function

public function string description ();string ls_description
real lr_dose_amount, lr_administer_per_dose

lr_dose_amount = real(sle_dose_amount.text)
lr_administer_per_dose = real(sle_administer_per_dose.text)

ls_description = dosage_form_description

if lr_dose_amount = lr_administer_per_dose &
 and administer_unit.unit_id = dose_unit.unit_id then
 return ls_description
end if

ls_description += " " + f_pretty_amount_unit(lr_administer_per_dose, administer_unit.unit_id)

If dose_in_name_flag = "Y" then
	ls_description += "/" + f_pretty_amount_unit(lr_dose_amount, dose_unit.unit_id)
end if

return ls_description

end function

on w_package_edit.create
int iCurrent
call super::create
this.st_description=create st_description
this.st_administer_method=create st_administer_method
this.st_administer_unit=create st_administer_unit
this.st_dose_unit=create st_dose_unit
this.st_administer_method_title=create st_administer_method_title
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.st_5=create st_5
this.pb_done=create pb_done
this.pb_cancel=create pb_cancel
this.sle_administer_per_dose=create sle_administer_per_dose
this.sle_dose_amount=create sle_dose_amount
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_description
this.Control[iCurrent+2]=this.st_administer_method
this.Control[iCurrent+3]=this.st_administer_unit
this.Control[iCurrent+4]=this.st_dose_unit
this.Control[iCurrent+5]=this.st_administer_method_title
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.st_4
this.Control[iCurrent+9]=this.st_5
this.Control[iCurrent+10]=this.pb_done
this.Control[iCurrent+11]=this.pb_cancel
this.Control[iCurrent+12]=this.sle_administer_per_dose
this.Control[iCurrent+13]=this.sle_dose_amount
end on

on w_package_edit.destroy
call super::destroy
destroy(this.st_description)
destroy(this.st_administer_method)
destroy(this.st_administer_unit)
destroy(this.st_dose_unit)
destroy(this.st_administer_method_title)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.pb_done)
destroy(this.pb_cancel)
destroy(this.sle_administer_per_dose)
destroy(this.sle_dose_amount)
end on

event open;call super::open;str_popup popup

popup = message.powerobjectparm

package_id = popup.item

postevent("post_open")

end event

type pb_epro_help from w_window_base`pb_epro_help within w_package_edit
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_package_edit
end type

type st_description from statictext within w_package_edit
integer width = 2926
integer height = 148
boolean bringtotop = true
integer textsize = -22
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "New Package"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_administer_method from statictext within w_package_edit
integer x = 1271
integer y = 288
integer width = 805
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_administer_method_list"
popup.datacolumn = 1
popup.displaycolumn = 2
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <= 0 then return

administer_method = popup_return.items[1]
text = popup_return.descriptions[1]

end event

type st_administer_unit from statictext within w_package_edit
integer x = 1312
integer y = 872
integer width = 466
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_unit_list"
popup.displaycolumn = 1
popup.datacolumn = 2

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm

if popup_return.item_count = 1 then
	administer_unit = unit_list.find_unit(popup_return.items[1])
	text = popup_return.descriptions[1]
end if


end event

type st_dose_unit from statictext within w_package_edit
integer x = 1312
integer y = 672
integer width = 466
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_unit_list"
popup.displaycolumn = 1
popup.datacolumn = 2

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm

if popup_return.item_count = 1 then
	dose_unit = unit_list.find_unit(popup_return.items[1])
	text = popup_return.descriptions[1]
end if


end event

type st_administer_method_title from statictext within w_package_edit
integer x = 608
integer y = 304
integer width = 576
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Administer Method:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_package_edit
integer x = 567
integer y = 668
integer width = 379
integer height = 92
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Each"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_3 from statictext within w_package_edit
integer x = 1851
integer y = 672
integer width = 663
integer height = 92
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "of this package"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_4 from statictext within w_package_edit
integer x = 521
integer y = 868
integer width = 398
integer height = 92
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Contains"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_5 from statictext within w_package_edit
integer x = 1833
integer y = 868
integer width = 370
integer height = 92
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "of drug"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_done from u_picture_button within w_package_edit
integer x = 2574
integer y = 1536
integer taborder = 0
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;real lr_dose_amount, lr_administer_per_dose
string ls_description
str_popup_return popup_return
str_package_definition lstr_package
integer li_sts

if isnull(administer_method) then
	openwithparm(w_pop_message, "You must select an Administer Method")
	return
end if

if isnull(dose_unit) then
	openwithparm(w_pop_message, "You must select a Dose Unit")
	return
end if

if isnull(administer_unit) then
	openwithparm(w_pop_message, "You must select an Administer Unit")
	return
end if

lr_dose_amount = real(sle_dose_amount.text)
if lr_dose_amount <= 0 then
	openwithparm(w_pop_message, "You must select a Dose Amount")
	sle_dose_amount.setfocus()
	return
end if

lr_administer_per_dose = real(sle_administer_per_dose.text)
if lr_administer_per_dose <= 0 then
	openwithparm(w_pop_message, "You must select an Administer Amount")
	sle_administer_per_dose.setfocus()
	return
end if

ls_description = description()

if isnull(package_id) then
	lstr_package.administer_method = administer_method
	lstr_package.description = ls_description
	lstr_package.administer_unit = administer_unit.unit_id
	lstr_package.dose_unit = dose_unit.unit_id
	lstr_package.administer_per_dose = lr_administer_per_dose
	lstr_package.dosage_form = dosage_form
	lstr_package.dose_amount = lr_dose_amount
	li_sts = drugdb.new_package(lstr_package)
	if li_sts <= 0 then
		log.log(this, "clicked", "Error saving new package", 4)
		return
	end if
	package_id = lstr_package.package_id
else
	sqlca.sp_update_package(package_id,   &
									administer_method,   &
									ls_description,   &
									administer_unit.unit_id,   &
									dose_unit.unit_id,   &
									lr_administer_per_dose,   &
									dosage_form,   &
									lr_dose_amount)
	if not tf_check() then return
end if

popup_return.items[1] = package_id
popup_return.descriptions[1] = ls_description
popup_return.item_count = 1
closewithreturn(parent, popup_return)

end event

type pb_cancel from u_picture_button within w_package_edit
integer x = 128
integer y = 1528
integer taborder = 0
boolean bringtotop = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

type sle_administer_per_dose from singlelineedit within w_package_edit
integer x = 1010
integer y = 868
integer width = 270
integer height = 100
integer taborder = 10
fontcharset fontcharset = ansi!
string facename = "System"
borderstyle borderstyle = stylelowered!
end type

type sle_dose_amount from singlelineedit within w_package_edit
integer x = 1010
integer y = 668
integer width = 270
integer height = 100
integer taborder = 20
fontcharset fontcharset = ansi!
string facename = "System"
borderstyle borderstyle = stylelowered!
end type

