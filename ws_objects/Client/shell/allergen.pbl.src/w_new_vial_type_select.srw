$PBExportHeader$w_new_vial_type_select.srw
forward
global type w_new_vial_type_select from w_window_base
end type
type st_title from statictext within w_new_vial_type_select
end type
type cb_done from commandbutton within w_new_vial_type_select
end type
type cb_cancel from commandbutton within w_new_vial_type_select
end type
type dw_dilute_from from u_dw_pick_list within w_new_vial_type_select
end type
type st_assessments_title from statictext within w_new_vial_type_select
end type
type st_vial_type_title from statictext within w_new_vial_type_select
end type
type st_vial_type from statictext within w_new_vial_type_select
end type
type cb_change_vial_type from commandbutton within w_new_vial_type_select
end type
type st_other_modifiers_title from statictext within w_new_vial_type_select
end type
type st_vial_size from statictext within w_new_vial_type_select
end type
end forward

global type w_new_vial_type_select from w_window_base
integer x = 201
integer y = 100
integer width = 2437
integer height = 1584
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_title st_title
cb_done cb_done
cb_cancel cb_cancel
dw_dilute_from dw_dilute_from
st_assessments_title st_assessments_title
st_vial_type_title st_vial_type_title
st_vial_type st_vial_type
cb_change_vial_type cb_change_vial_type
st_other_modifiers_title st_other_modifiers_title
st_vial_size st_vial_size
end type
global w_new_vial_type_select w_new_vial_type_select

type variables

str_new_vial_properties vial_properties

u_unit vial_size_unit

long parent_treatment_id
real lr_parent_dose_amount
string ls_parent_dose_unit

end variables

forward prototypes
public function integer change_vial_type ()
end prototypes

public function integer change_vial_type ();str_popup popup
str_popup_return popup_return
long ll_rows
string ls_vial_type
long ll_full_strength_ratio

popup.dataobject = "dw_vial_type_list"
popup.datacolumn = 1
popup.displaycolumn = 5
popup.title = "Select Vial Type"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

ls_vial_type = popup_return.items[1]

// Get some data from the vial type
SELECT default_amount, default_unit, full_strength_ratio
INTO :vial_properties.new_vial_amount, :vial_properties.new_vial_unit, :ll_full_strength_ratio
FROM c_Vial_Type
WHERE vial_type = :ls_vial_type;
if not tf_check() then return -1

// Check to see if the user selected the full strength vial
if ll_full_strength_ratio = 1 then
	vial_properties.new_vial_type = ls_vial_type
	setnull(vial_properties.dilute_from_vial_type)
	setnull(vial_properties.new_vial_amount)
	setnull(vial_properties.new_vial_unit)
	return 2
end if


ll_rows = dw_dilute_from.retrieve(current_patient.cpr_id, ls_vial_type)
if ll_rows <= 0 then
	openwithparm(w_pop_message, "There are no valid dilute-from choices for the " + ls_vial_type + " vial type.")
	return -1
end if

// auto select the last one in the list cuz it will be the lowest concentration
dw_dilute_from.object.selected_flag[ll_rows] = 1
dw_dilute_from.event POST selected(ll_rows)

// Make sure we have a valid amount/unit
if isnull(vial_properties.new_vial_unit) or isnull(vial_properties.new_vial_amount) then
	vial_properties.new_vial_amount = lr_parent_dose_amount
	vial_properties.new_vial_unit = ls_parent_dose_unit
end if

vial_size_unit = unit_list.find_unit(vial_properties.new_vial_unit)
if isnull(vial_size_unit) then
	openwithparm(w_pop_message, "The unit for this vial type is not valid.")
	return -1
end if

st_vial_size.text = vial_size_unit.pretty_amount_unit(vial_properties.new_vial_amount)

vial_properties.new_vial_type = ls_vial_type
st_vial_type.text = ls_vial_type


return 1

end function

on w_new_vial_type_select.create
int iCurrent
call super::create
this.st_title=create st_title
this.cb_done=create cb_done
this.cb_cancel=create cb_cancel
this.dw_dilute_from=create dw_dilute_from
this.st_assessments_title=create st_assessments_title
this.st_vial_type_title=create st_vial_type_title
this.st_vial_type=create st_vial_type
this.cb_change_vial_type=create cb_change_vial_type
this.st_other_modifiers_title=create st_other_modifiers_title
this.st_vial_size=create st_vial_size
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.cb_done
this.Control[iCurrent+3]=this.cb_cancel
this.Control[iCurrent+4]=this.dw_dilute_from
this.Control[iCurrent+5]=this.st_assessments_title
this.Control[iCurrent+6]=this.st_vial_type_title
this.Control[iCurrent+7]=this.st_vial_type
this.Control[iCurrent+8]=this.cb_change_vial_type
this.Control[iCurrent+9]=this.st_other_modifiers_title
this.Control[iCurrent+10]=this.st_vial_size
end on

on w_new_vial_type_select.destroy
call super::destroy
destroy(this.st_title)
destroy(this.cb_done)
destroy(this.cb_cancel)
destroy(this.dw_dilute_from)
destroy(this.st_assessments_title)
destroy(this.st_vial_type_title)
destroy(this.st_vial_type)
destroy(this.cb_change_vial_type)
destroy(this.st_other_modifiers_title)
destroy(this.st_vial_size)
end on

event open;call super::open;str_popup popup
str_new_vial_properties lstr_error
integer li_sts

setnull(lstr_error.new_vial_type)
setnull(vial_properties.new_vial_type)
setnull(vial_properties.dilute_from_vial_type)
setnull(vial_properties.new_vial_amount)
setnull(vial_properties.new_vial_unit)


parent_treatment_id = message.doubleparm

if isnull(parent_treatment_id) then
	log.log(this, "w_new_vial_type_select:open", "null treatment id", 4)
	closewithreturn(this, lstr_error)
end if

SELECT dose_amount, dose_unit
INTO :lr_parent_dose_amount, :ls_parent_dose_unit
FROM p_Treatment_Item
WHERE cpr_id = :current_patient.cpr_id
AND treatment_id = :parent_treatment_id;
if not tf_check() then
	closewithreturn(this, lstr_error)
end if

if sqlca.sqlcode = 100 then
	log.log(this, "w_new_vial_type_select:open", "treatment not found (" + string(parent_treatment_id) + ")", 4)
	closewithreturn(this, lstr_error)
end if

dw_dilute_from.settransobject(sqlca)

li_sts = change_vial_type()
if li_sts <= 0 then
	closewithreturn(this, lstr_error)
end if

// If the user selected full-strength, then we're done
if li_sts = 2 then
	closewithreturn(this, vial_properties)
end if

end event

type pb_epro_help from w_window_base`pb_epro_help within w_new_vial_type_select
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_new_vial_type_select
end type

type st_title from statictext within w_new_vial_type_select
integer x = 5
integer width = 2510
integer height = 128
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "New Vial Properties"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_done from commandbutton within w_new_vial_type_select
integer x = 1989
integer y = 1440
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

event clicked;

if isnull(vial_properties.dilute_from_vial_type) then
	openwithparm(w_pop_message, "You must select a dilute-from vial type")
	return
end if



closewithreturn(parent, vial_properties)

end event

type cb_cancel from commandbutton within w_new_vial_type_select
integer x = 78
integer y = 1440
integer width = 402
integer height = 112
integer taborder = 30
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

event clicked;str_new_vial_properties lstr_new_vial

setnull(lstr_new_vial.new_vial_type)

closewithreturn(parent, lstr_new_vial)

end event

type dw_dilute_from from u_dw_pick_list within w_new_vial_type_select
integer x = 635
integer y = 428
integer width = 1330
integer height = 708
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_jmj_dilute_from_vial_choices"
boolean vscrollbar = true
boolean border = false
boolean multiselect = true
end type

event selected;call super::selected;vial_properties.dilute_from_vial_type = object.vial_type[selected_row]

end event

event unselected;call super::unselected;setnull(vial_properties.dilute_from_vial_type)


end event

type st_assessments_title from statictext within w_new_vial_type_select
integer x = 759
integer y = 360
integer width = 997
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Dilute From"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_vial_type_title from statictext within w_new_vial_type_select
integer x = 306
integer y = 156
integer width = 453
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "New Vial Type:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_vial_type from statictext within w_new_vial_type_select
integer x = 782
integer y = 156
integer width = 809
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "none"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type cb_change_vial_type from commandbutton within w_new_vial_type_select
integer x = 1605
integer y = 156
integer width = 361
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Change"
end type

event clicked;integer li_sts
str_popup_return popup_return

li_sts = change_vial_type()
if li_sts = 2 then
	openwithparm(w_pop_yes_no, "Are you sure you wish to create a full strength vial?")
	popup_return = message.powerobjectparm
	if popup_return.item = "YES" then
		cb_done.postevent("clicked")
	end if
	
	this.postevent("clicked")
end if



end event

type st_other_modifiers_title from statictext within w_new_vial_type_select
integer x = 645
integer y = 1212
integer width = 498
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "New Vial Size:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_vial_size from statictext within w_new_vial_type_select
integer x = 1152
integer y = 1208
integer width = 421
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "5 ml"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
string ls_cpt_code


popup.argument_count = 1
popup.argument[1] = "NEWVIALSIZE"
popup.title = "Enter The Size of the New Vial"
popup.realitem = vial_properties.new_vial_amount
popup.objectparm = vial_size_unit

openwithparm(w_number, popup)
popup_return = message.powerobjectparm
if upper(popup_return.item) = "CANCEL" then return
if popup_return.realitem < 1 or isnull(popup_return.realitem) then return

vial_properties.new_vial_amount = popup_return.realitem

st_vial_size.text = vial_size_unit.pretty_amount_unit(vial_properties.new_vial_amount)

end event

