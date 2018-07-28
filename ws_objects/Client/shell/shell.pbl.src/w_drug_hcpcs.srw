$PBExportHeader$w_drug_hcpcs.srw
forward
global type w_drug_hcpcs from w_window_base
end type
type st_unit from statictext within w_drug_hcpcs
end type
type st_dispense_amount from statictext within w_drug_hcpcs
end type
type st_dispense_unit from statictext within w_drug_hcpcs
end type
type cb_set_amount from commandbutton within w_drug_hcpcs
end type
type st_default_dispense from statictext within w_drug_hcpcs
end type
type u_amount from u_sle_real_number within w_drug_hcpcs
end type
type hcpcs_procedure from statictext within w_drug_hcpcs
end type
type st_title_perform_procedure from statictext within w_drug_hcpcs
end type
type st_title from statictext within w_drug_hcpcs
end type
type cb_ok from commandbutton within w_drug_hcpcs
end type
type cb_cancel from commandbutton within w_drug_hcpcs
end type
end forward

global type w_drug_hcpcs from w_window_base
integer width = 2501
integer height = 1016
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean center = true
st_unit st_unit
st_dispense_amount st_dispense_amount
st_dispense_unit st_dispense_unit
cb_set_amount cb_set_amount
st_default_dispense st_default_dispense
u_amount u_amount
hcpcs_procedure hcpcs_procedure
st_title_perform_procedure st_title_perform_procedure
st_title st_title
cb_ok cb_ok
cb_cancel cb_cancel
end type
global w_drug_hcpcs w_drug_hcpcs

type variables
u_unit administer_unit
string hcpcs_procedure_id,drug_id

end variables

forward prototypes
public function long default_admin_unit ()
end prototypes

public function long default_admin_unit ();u_ds_data luo_data
long ll_row
long ll_count
string ls_unit_id
string ls_find

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_sp_compatible_admin_units")
ll_count = luo_data.retrieve(drug_id)
if ll_count <= 0 then return ll_count


// If MG (milligrams) is a valid admin unit for this drug, then use it
// Otherwise use the first one in the list
ls_find = "unit_id='MG'"
ll_row = luo_data.find(ls_find, 1, ll_count)
if ll_row <= 0 then
	ls_unit_id = luo_data.object.unit_id[1]
else
	ls_unit_id = luo_data.object.unit_id[ll_row]
end if

administer_unit = unit_list.find_unit(ls_unit_id)
if isnull(administer_unit) then
	log.log(this, "default_admin_unit", "Admin unit not found (" + ls_unit_id + ")", 3)
	st_unit.text = ""
else
	st_unit.text = administer_unit.description
end if

return 1
end function

on w_drug_hcpcs.create
int iCurrent
call super::create
this.st_unit=create st_unit
this.st_dispense_amount=create st_dispense_amount
this.st_dispense_unit=create st_dispense_unit
this.cb_set_amount=create cb_set_amount
this.st_default_dispense=create st_default_dispense
this.u_amount=create u_amount
this.hcpcs_procedure=create hcpcs_procedure
this.st_title_perform_procedure=create st_title_perform_procedure
this.st_title=create st_title
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_unit
this.Control[iCurrent+2]=this.st_dispense_amount
this.Control[iCurrent+3]=this.st_dispense_unit
this.Control[iCurrent+4]=this.cb_set_amount
this.Control[iCurrent+5]=this.st_default_dispense
this.Control[iCurrent+6]=this.u_amount
this.Control[iCurrent+7]=this.hcpcs_procedure
this.Control[iCurrent+8]=this.st_title_perform_procedure
this.Control[iCurrent+9]=this.st_title
this.Control[iCurrent+10]=this.cb_ok
this.Control[iCurrent+11]=this.cb_cancel
end on

on w_drug_hcpcs.destroy
call super::destroy
destroy(this.st_unit)
destroy(this.st_dispense_amount)
destroy(this.st_dispense_unit)
destroy(this.cb_set_amount)
destroy(this.st_default_dispense)
destroy(this.u_amount)
destroy(this.hcpcs_procedure)
destroy(this.st_title_perform_procedure)
destroy(this.st_title)
destroy(this.cb_ok)
destroy(this.cb_cancel)
end on

event open;call super::open;str_popup popup
string ls_cat_description
string ls_procedure_description
decimal ldc_charge
string ls_cpt_code
string ls_category_id
integer li_sts
str_popup_return popup_return

popup_return.item_count = 0


popup = message.powerobjectparm

st_title.text = "HCPCS for " + popup.title

if popup.data_row_count = 4 then
	drug_id = popup.items[1]
	u_amount.text = popup.items[2]
	administer_unit = unit_list.find_unit(popup.items[3])
	if isnull(administer_unit) then
		st_unit.text = ""
	else
		st_unit.text = administer_unit.description
	end if
	hcpcs_procedure_id = popup.items[4]
elseif popup.data_row_count = 1 then
	drug_id = popup.items[1]
	setnull(hcpcs_procedure_id)
	setnull(administer_unit)
	li_sts = default_admin_unit()
	if li_sts = 0 then
		openwithparm(w_pop_message, "This drug has no valid administration units")
		log.log(this, "open", "No valid admin units for this drug (" + drug_id + ")", 4)
		closewithreturn(this, popup_return)
		return
	elseif li_sts < 0 then
		log.log(this, "open", "Error retrieving default admin unit", 4)
		closewithreturn(this, popup_return)
		return
	end if
	hcpcs_procedure.postevent("clicked")
else
	log.log(this, "open", "Invalid Parameters", 4)
	closewithreturn(this, popup_return)
	return
end if


end event

type pb_epro_help from w_window_base`pb_epro_help within w_drug_hcpcs
integer x = 0
integer y = 0
integer width = 247
integer height = 120
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_drug_hcpcs
end type

type st_unit from statictext within w_drug_hcpcs
integer x = 1600
integer y = 560
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

popup.dataobject = "dw_sp_compatible_admin_units"
popup.displaycolumn = 2
popup.datacolumn = 1
popup.argument_count = 1
popup.argument[1] = drug_id

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm

if popup_return.item_count = 1 then
	administer_unit = unit_list.find_unit(popup_return.items[1])
	text = popup_return.descriptions[1]
end if


end event

type st_dispense_amount from statictext within w_drug_hcpcs
integer x = 1266
integer y = 432
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

type st_dispense_unit from statictext within w_drug_hcpcs
integer x = 1266
integer y = 572
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

type cb_set_amount from commandbutton within w_drug_hcpcs
integer x = 2062
integer y = 416
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

popup.realitem = real(u_amount.text)
popup.objectparm = administer_unit

openwithparm(w_number, popup)
popup_return = message.powerobjectparm

if isnull(administer_unit) then
	u_amount.text = string(popup_return.realitem)
else
	u_amount.text = f_pretty_amount(popup_return.realitem, "", administer_unit)
end if


end event

type st_default_dispense from statictext within w_drug_hcpcs
integer x = 192
integer y = 440
integer width = 960
integer height = 172
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "If the Administered Amount is at least this:"
alignment alignment = center!
boolean focusrectangle = false
end type

type u_amount from u_sle_real_number within w_drug_hcpcs
integer x = 1600
integer y = 416
integer width = 439
integer height = 100
integer taborder = 10
end type

type hcpcs_procedure from statictext within w_drug_hcpcs
event clicked pbm_bnclicked
integer x = 1248
integer y = 184
integer width = 1106
integer height = 144
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
str_picked_procedures lstr_procedures


popup.data_row_count = 1
popup.items[1] = "DRUGHCPCS"
popup.multiselect = false
openwithparm(w_pick_procedures, popup)
lstr_procedures = message.powerobjectparm

if lstr_procedures.procedure_count < 1 then return

hcpcs_procedure_id = lstr_procedures.procedures[1].procedure_id
text = lstr_procedures.procedures[1].description

end event

type st_title_perform_procedure from statictext within w_drug_hcpcs
integer x = 133
integer y = 224
integer width = 1029
integer height = 84
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Bill this HCPCS Procedure:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_title from statictext within w_drug_hcpcs
integer width = 2501
integer height = 120
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "HCPCS for "
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_ok from commandbutton within w_drug_hcpcs
integer x = 2016
integer y = 832
integer width = 402
integer height = 112
integer taborder = 50
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

if isnull(hcpcs_procedure_id) then
	openwithparm(w_pop_message, "You must supply a HCPCS Procedure")
	return
end if

popup_return.item_count = 4

if isnull(administer_unit) or u_amount.value <= 0 then
	setnull(popup_return.items[1])
	setnull(popup_return.items[2])
else
	popup_return.items[1] = u_amount.text
	popup_return.items[2] = administer_unit.unit_id
end if

popup_return.items[3] = hcpcs_procedure_id

popup_return.items[4] = hcpcs_procedure.text

closewithreturn(parent, popup_return)

end event

type cb_cancel from commandbutton within w_drug_hcpcs
integer x = 73
integer y = 824
integer width = 402
integer height = 112
integer taborder = 60
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

event clicked;str_popup_return popup_return

popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

