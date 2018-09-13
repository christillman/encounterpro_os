$PBExportHeader$w_drug_package.srw
forward
global type w_drug_package from w_window_base
end type
type st_title from statictext within w_drug_package
end type
type st_unit from statictext within w_drug_package
end type
type st_dispense_amount from statictext within w_drug_package
end type
type st_dispense_unit from statictext within w_drug_package
end type
type pb_done from u_picture_button within w_drug_package
end type
type pb_cancel from u_picture_button within w_drug_package
end type
type st_needs_rx_title from statictext within w_drug_package
end type
type cb_set_amount from commandbutton within w_drug_package
end type
type st_take_as_directed from statictext within w_drug_package
end type
type st_default_dispense from statictext within w_drug_package
end type
type st_needs_rx from statictext within w_drug_package
end type
type st_take_as_directed_title from statictext within w_drug_package
end type
type sle_amount from singlelineedit within w_drug_package
end type
type uo_package from u_package_description within w_drug_package
end type
type st_dispense_choices_title from statictext within w_drug_package
end type
type dw_dispense_choices from u_dw_pick_list within w_drug_package
end type
end forward

global type w_drug_package from w_window_base
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_title st_title
st_unit st_unit
st_dispense_amount st_dispense_amount
st_dispense_unit st_dispense_unit
pb_done pb_done
pb_cancel pb_cancel
st_needs_rx_title st_needs_rx_title
cb_set_amount cb_set_amount
st_take_as_directed st_take_as_directed
st_default_dispense st_default_dispense
st_needs_rx st_needs_rx
st_take_as_directed_title st_take_as_directed_title
sle_amount sle_amount
uo_package uo_package
st_dispense_choices_title st_dispense_choices_title
dw_dispense_choices dw_dispense_choices
end type
global w_drug_package w_drug_package

type variables

u_unit default_dispense_unit
string prescription_flag
string take_as_directed

string drug_id
string package_id

integer sort_order

end variables

forward prototypes
public function integer save_changes ()
public function integer load_dispense_choices ()
public subroutine add_dispense_choice ()
public subroutine remove_dispense_choice ()
end prototypes

public function integer save_changes ();real lr_default_dispense_amount

lr_default_dispense_amount = real(trim(sle_amount.text))

sqlca.sp_update_drug_package(drug_id,   &
										package_id,   &
										prescription_flag,   &
										lr_default_dispense_amount,   &
										default_dispense_unit.unit_id,   &
										take_as_directed,&
										sort_order)
if not tf_check() then return -1

return 1


end function

public function integer load_dispense_choices ();str_drug_package_dispense_list lstr_dispense_list
integer li_sts
integer i
long ll_row

dw_dispense_choices.setredraw(false)

dw_dispense_choices.reset()

li_sts = drugdb.get_dispense_list(drug_id, package_id, lstr_dispense_list)

for i = 1 to lstr_dispense_list.dispense_count
	dw_dispense_choices.object.description[i] = lstr_dispense_list.dispense[i].description
next

dw_dispense_choices.setredraw(true)

return 1

end function

public subroutine add_dispense_choice ();str_popup popup
str_popup_return popup_return
string ls_dispense_unit
real lr_dispense_amount
u_unit luo_unit
integer li_sts

popup.title = "Select Dispense Unit"
popup.dataobject = "dw_unit_list"
popup.displaycolumn = 1
popup.datacolumn = 2

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_dispense_unit = popup_return.items[1]
luo_unit = unit_list.find_unit(ls_dispense_unit)

popup.title = "Enter Dispense Amount"
popup.realitem = 0
popup.objectparm = luo_unit

openwithparm(w_number, popup)
popup_return = message.powerobjectparm
if popup_return.item = "CANCEL" then return

lr_dispense_amount = popup_return.realitem

INSERT INTO c_Drug_Package_Dispense (
	drug_id,
	package_id,
	dispense_amount,
	dispense_unit)
VALUES (
	:drug_id,
	:package_id,
	:lr_dispense_amount,
	:ls_dispense_unit);
if not tf_check() then return

li_sts = load_dispense_choices()

return

end subroutine

public subroutine remove_dispense_choice ();str_popup popup
str_popup_return popup_return
str_drug_package_dispense_list lstr_dispense_list
integer li_sts
integer i
long ll_dispense_sequence

li_sts = drugdb.get_dispense_list(drug_id, package_id, lstr_dispense_list)

if lstr_dispense_list.dispense_count <= 0 then return

for i = 1 to lstr_dispense_list.dispense_count
	popup.items[i] = lstr_dispense_list.dispense[i].description
next

popup.data_row_count = lstr_dispense_list.dispense_count
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return
if popup_return.item_indexes[1] <= 0 then return

ll_dispense_sequence = lstr_dispense_list.dispense[popup_return.item_indexes[1]].dispense_sequence

DELETE FROM c_Drug_Package_Dispense
WHERE drug_id = :drug_id
AND package_id = :package_id
AND dispense_sequence = :ll_dispense_sequence;
if not tf_check() then return

li_sts = load_dispense_choices()

return

end subroutine

on w_drug_package.create
int iCurrent
call super::create
this.st_title=create st_title
this.st_unit=create st_unit
this.st_dispense_amount=create st_dispense_amount
this.st_dispense_unit=create st_dispense_unit
this.pb_done=create pb_done
this.pb_cancel=create pb_cancel
this.st_needs_rx_title=create st_needs_rx_title
this.cb_set_amount=create cb_set_amount
this.st_take_as_directed=create st_take_as_directed
this.st_default_dispense=create st_default_dispense
this.st_needs_rx=create st_needs_rx
this.st_take_as_directed_title=create st_take_as_directed_title
this.sle_amount=create sle_amount
this.uo_package=create uo_package
this.st_dispense_choices_title=create st_dispense_choices_title
this.dw_dispense_choices=create dw_dispense_choices
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.st_unit
this.Control[iCurrent+3]=this.st_dispense_amount
this.Control[iCurrent+4]=this.st_dispense_unit
this.Control[iCurrent+5]=this.pb_done
this.Control[iCurrent+6]=this.pb_cancel
this.Control[iCurrent+7]=this.st_needs_rx_title
this.Control[iCurrent+8]=this.cb_set_amount
this.Control[iCurrent+9]=this.st_take_as_directed
this.Control[iCurrent+10]=this.st_default_dispense
this.Control[iCurrent+11]=this.st_needs_rx
this.Control[iCurrent+12]=this.st_take_as_directed_title
this.Control[iCurrent+13]=this.sle_amount
this.Control[iCurrent+14]=this.uo_package
this.Control[iCurrent+15]=this.st_dispense_choices_title
this.Control[iCurrent+16]=this.dw_dispense_choices
end on

on w_drug_package.destroy
call super::destroy
destroy(this.st_title)
destroy(this.st_unit)
destroy(this.st_dispense_amount)
destroy(this.st_dispense_unit)
destroy(this.pb_done)
destroy(this.pb_cancel)
destroy(this.st_needs_rx_title)
destroy(this.cb_set_amount)
destroy(this.st_take_as_directed)
destroy(this.st_default_dispense)
destroy(this.st_needs_rx)
destroy(this.st_take_as_directed_title)
destroy(this.sle_amount)
destroy(this.uo_package)
destroy(this.st_dispense_choices_title)
destroy(this.dw_dispense_choices)
end on

event open;call super::open;str_popup popup
string ls_cat_description
string ls_procedure_description
decimal ldc_charge
string ls_cpt_code
string ls_category_id
integer li_sts
real lr_default_dispense_amount
string ls_default_dispense_unit

popup = message.powerobjectparm

if popup.data_row_count <> 2 then
	log.log(this, "w_drug_package:open", "Invalid Parameter", 4)
	close(this)
	return
end if

drug_id = popup.items[1]
package_id = popup.items[2]

if isnull(drug_id) then
	log.log(this, "w_drug_package:open", "Null Drug ID", 4)
	close(this)
	return
end if

if isnull(package_id) then
	log.log(this, "w_drug_package:open", "Null Package ID", 4)
	close(this)
	return
end if

st_title.text = "Package for " + popup.title

SELECT default_dispense_amount,
		 default_dispense_unit,
		 prescription_flag,
		 take_as_directed
INTO :lr_default_dispense_amount,
		:ls_default_dispense_unit,
		:prescription_flag,
		:take_as_directed
FROM c_Drug_Package
WHERE drug_id = :drug_id
AND package_id = :package_id;
if not tf_check() then
	close(this)
	return
end if
if sqlca.sqlcode = 100 then
	log.log(this, "w_drug_package:open", "Drug pakcage not found (" + drug_id + ", " + package_id + ")", 4)
	close(this)
	return
end if

uo_package.set_package(package_id)

default_dispense_unit = unit_list.find_unit(ls_default_dispense_unit)
if isnull(default_dispense_unit) then default_dispense_unit = unit_list.find_unit("NA")
st_unit.text = default_dispense_unit.description

if isnull(lr_default_dispense_amount) then
	sle_amount.text = ""
else
	sle_amount.text = f_pretty_amount(lr_default_dispense_amount, "", default_dispense_unit)
end if

if prescription_flag = "Y" then
	st_needs_rx.text = "Yes"
	st_needs_rx.backcolor = color_object_selected
else
	st_needs_rx.text = "No"
	prescription_flag = "N"
	st_needs_rx.backcolor = color_object
end if

if take_as_directed = "Y" then
	st_take_as_directed.text = "Yes"
	st_take_as_directed.backcolor = color_object_selected
else
	st_take_as_directed.text = "No"
	take_as_directed = "N"
	st_take_as_directed.backcolor = color_object
end if

dw_dispense_choices.object.description.width = dw_dispense_choices.width - 110

li_sts = load_dispense_choices()


return


end event

type pb_epro_help from w_window_base`pb_epro_help within w_drug_package
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_drug_package
end type

type st_title from statictext within w_drug_package
integer y = 8
integer width = 2917
integer height = 132
boolean bringtotop = true
integer textsize = -18
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Package for "
alignment alignment = center!
boolean focusrectangle = false
end type

type st_unit from statictext within w_drug_package
integer x = 2039
integer y = 1344
integer width = 608
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.title = "Select Dispense Unit"
popup.dataobject = "dw_unit_list"
popup.displaycolumn = 1
popup.datacolumn = 2

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm

if popup_return.item_count = 1 then
	default_dispense_unit = unit_list.find_unit(popup_return.items[1])
	text = popup_return.descriptions[1]
end if


end event

type st_dispense_amount from statictext within w_drug_package
integer x = 1691
integer y = 1220
integer width = 320
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Amount:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_dispense_unit from statictext within w_drug_package
integer x = 1687
integer y = 1352
integer width = 320
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Unit:"
alignment alignment = right!
boolean focusrectangle = false
end type

type pb_done from u_picture_button within w_drug_package
integer x = 2592
integer y = 1556
integer taborder = 30
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;integer li_sts

li_sts = save_changes()
if li_sts <= 0 then return

close(parent)

end event

type pb_cancel from u_picture_button within w_drug_package
integer x = 82
integer y = 1556
integer taborder = 20
boolean bringtotop = true
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;close(parent)

end event

type st_needs_rx_title from statictext within w_drug_package
integer x = 247
integer y = 1156
integer width = 576
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Needs Prescription:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_set_amount from commandbutton within w_drug_package
integer x = 2501
integer y = 1204
integer width = 146
integer height = 100
integer taborder = 40
boolean bringtotop = true
integer textsize = -16
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.realitem = real(sle_amount.text)
popup.objectparm = default_dispense_unit

openwithparm(w_number, popup)
popup_return = message.powerobjectparm

if isnull(default_dispense_unit) then
	sle_amount.text = string(popup_return.realitem)
else
	sle_amount.text = f_pretty_amount(popup_return.realitem, "", default_dispense_unit)
end if


end event

type st_take_as_directed from statictext within w_drug_package
event clicked pbm_bnclicked
integer x = 878
integer y = 1312
integer width = 247
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "No"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if take_as_directed = "Y" then
	text = "No"
	take_as_directed = "N"
	backcolor = color_object
else
	text = "Yes"
	take_as_directed = "Y"
	backcolor = color_object_selected
end if

end event

type st_default_dispense from statictext within w_drug_package
integer x = 1934
integer y = 1100
integer width = 814
integer height = 96
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 33538240
boolean enabled = false
string text = "Default Dispense"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_needs_rx from statictext within w_drug_package
integer x = 878
integer y = 1144
integer width = 247
integer height = 100
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

event clicked;if prescription_flag = "Y" then
	text = "No"
	prescription_flag = "N"
	backcolor = color_object
else
	text = "Yes"
	prescription_flag = "Y"
	backcolor = color_object_selected
end if

end event

type st_take_as_directed_title from statictext within w_drug_package
integer x = 247
integer y = 1328
integer width = 576
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Take As Directed:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_amount from singlelineedit within w_drug_package
integer x = 2039
integer y = 1208
integer width = 411
integer height = 92
integer taborder = 50
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

type uo_package from u_package_description within w_drug_package
event destroy ( )
integer x = 64
integer y = 240
integer taborder = 10
end type

on uo_package.destroy
call u_package_description::destroy
end on

type st_dispense_choices_title from statictext within w_drug_package
integer x = 1861
integer y = 188
integer width = 777
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Dispense Choices"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_dispense_choices from u_dw_pick_list within w_drug_package
integer x = 1861
integer y = 268
integer width = 777
integer height = 732
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_generic_list_small"
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event clicked;call super::clicked;str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons


if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Add Dispense Choice"
	popup.button_titles[popup.button_count] = "Add Dispense Choice"
	buttons[popup.button_count] = "ADD"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Remove Dispense Choice"
	popup.button_titles[popup.button_count] = "Remove Dispense Choice"
	buttons[popup.button_count] = "REMOVE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	button_pressed = message.doubleparm
	if button_pressed < 1 or button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	button_pressed = 1
else
	return
end if

CHOOSE CASE buttons[button_pressed]
	CASE "ADD"
		add_dispense_choice()
	CASE "REMOVE"
		remove_dispense_choice()
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return

end event

