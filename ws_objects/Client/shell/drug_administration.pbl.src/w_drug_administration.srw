$PBExportHeader$w_drug_administration.srw
forward
global type w_drug_administration from w_window_base
end type
type st_title from statictext within w_drug_administration
end type
type st_unit from statictext within w_drug_administration
end type
type st_duration_amount from statictext within w_drug_administration
end type
type st_duration_unit from statictext within w_drug_administration
end type
type st_duration_prn from statictext within w_drug_administration
end type
type pb_done from u_picture_button within w_drug_administration
end type
type pb_cancel from u_picture_button within w_drug_administration
end type
type uo_administer_frequency from u_administer_frequency within w_drug_administration
end type
type st_2 from statictext within w_drug_administration
end type
type uo_yes from u_st_radio_multby_yesno within w_drug_administration
end type
type uo_no from u_st_radio_multby_yesno within w_drug_administration
end type
type st_calc_per_title from statictext within w_drug_administration
end type
type uo_calc_per_day from u_st_radio_calc_per within w_drug_administration
end type
type uo_calc_per_dose from u_st_radio_calc_per within w_drug_administration
end type
type cb_set_amount from commandbutton within w_drug_administration
end type
type sle_description from singlelineedit within w_drug_administration
end type
type st_description from statictext within w_drug_administration
end type
type u_amount from u_sle_real_number within w_drug_administration
end type
type pb_1 from u_pb_help_button within w_drug_administration
end type
type st_strength_t from statictext within w_drug_administration
end type
type st_strength from statictext within w_drug_administration
end type
end forward

global type w_drug_administration from w_window_base
boolean titlebar = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_title st_title
st_unit st_unit
st_duration_amount st_duration_amount
st_duration_unit st_duration_unit
st_duration_prn st_duration_prn
pb_done pb_done
pb_cancel pb_cancel
uo_administer_frequency uo_administer_frequency
st_2 st_2
uo_yes uo_yes
uo_no uo_no
st_calc_per_title st_calc_per_title
uo_calc_per_day uo_calc_per_day
uo_calc_per_dose uo_calc_per_dose
cb_set_amount cb_set_amount
sle_description sle_description
st_description st_description
u_amount u_amount
pb_1 pb_1
st_strength_t st_strength_t
st_strength st_strength
end type
global w_drug_administration w_drug_administration

type variables
string drug_id

boolean mult_by_kg
string calc_per
u_unit administer_unit
string administer_form_rxcui
end variables

forward prototypes
public function integer default_admin_unit ()
end prototypes

public function integer default_admin_unit ();u_ds_data luo_data
long ll_row
long ll_count
string ls_unit_id
string ls_find

// Get the possible package unit choices (ref. c_Drug_Package)
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
	log.log(this, "w_drug_administration.default_admin_unit:0025", "Admin unit not found (" + ls_unit_id + ")", 3)
	st_unit.text = ""
else
	st_unit.text = administer_unit.description
end if

return 1

end function

on w_drug_administration.create
int iCurrent
call super::create
this.st_title=create st_title
this.st_unit=create st_unit
this.st_duration_amount=create st_duration_amount
this.st_duration_unit=create st_duration_unit
this.st_duration_prn=create st_duration_prn
this.pb_done=create pb_done
this.pb_cancel=create pb_cancel
this.uo_administer_frequency=create uo_administer_frequency
this.st_2=create st_2
this.uo_yes=create uo_yes
this.uo_no=create uo_no
this.st_calc_per_title=create st_calc_per_title
this.uo_calc_per_day=create uo_calc_per_day
this.uo_calc_per_dose=create uo_calc_per_dose
this.cb_set_amount=create cb_set_amount
this.sle_description=create sle_description
this.st_description=create st_description
this.u_amount=create u_amount
this.pb_1=create pb_1
this.st_strength_t=create st_strength_t
this.st_strength=create st_strength
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.st_unit
this.Control[iCurrent+3]=this.st_duration_amount
this.Control[iCurrent+4]=this.st_duration_unit
this.Control[iCurrent+5]=this.st_duration_prn
this.Control[iCurrent+6]=this.pb_done
this.Control[iCurrent+7]=this.pb_cancel
this.Control[iCurrent+8]=this.uo_administer_frequency
this.Control[iCurrent+9]=this.st_2
this.Control[iCurrent+10]=this.uo_yes
this.Control[iCurrent+11]=this.uo_no
this.Control[iCurrent+12]=this.st_calc_per_title
this.Control[iCurrent+13]=this.uo_calc_per_day
this.Control[iCurrent+14]=this.uo_calc_per_dose
this.Control[iCurrent+15]=this.cb_set_amount
this.Control[iCurrent+16]=this.sle_description
this.Control[iCurrent+17]=this.st_description
this.Control[iCurrent+18]=this.u_amount
this.Control[iCurrent+19]=this.pb_1
this.Control[iCurrent+20]=this.st_strength_t
this.Control[iCurrent+21]=this.st_strength
end on

on w_drug_administration.destroy
call super::destroy
destroy(this.st_title)
destroy(this.st_unit)
destroy(this.st_duration_amount)
destroy(this.st_duration_unit)
destroy(this.st_duration_prn)
destroy(this.pb_done)
destroy(this.pb_cancel)
destroy(this.uo_administer_frequency)
destroy(this.st_2)
destroy(this.uo_yes)
destroy(this.uo_no)
destroy(this.st_calc_per_title)
destroy(this.uo_calc_per_day)
destroy(this.uo_calc_per_dose)
destroy(this.cb_set_amount)
destroy(this.sle_description)
destroy(this.st_description)
destroy(this.u_amount)
destroy(this.pb_1)
destroy(this.st_strength_t)
destroy(this.st_strength)
end on

event open;call super::open;integer li_sts
string ls_generic_rxcui, ls_brand_name_rxcui, ls_form_rxcui

str_popup popup
str_popup_return popup_return

popup_return.item_count = 0
popup = message.powerobjectparm

if popup.data_row_count <> 1 then
	log.log(this, "w_drug_administration:open", "No drug_id supplied", 4)
	close(this)
	return
end if

drug_id = popup.items[1]

st_title.text = "Administration for " + popup.title


SetNull(ls_generic_rxcui)
SetNull(ls_brand_name_rxcui)
SetNull(administer_form_rxcui)

f_get_rxnorm(drug_id, ls_generic_rxcui, ls_brand_name_rxcui)

IF IsNull(ls_brand_name_rxcui) THEN
	IF NOT IsNull(ls_generic_rxcui) THEN
		administer_form_rxcui = ls_generic_rxcui
	END IF
ELSE
	administer_form_rxcui = ls_brand_name_rxcui
END IF

// For RXNORM drugs, record SCDs/SBDs/GPCKs/BPCKs	
IF NOT IsNull(ls_generic_rxcui) THEN 
	// generic_rxcui, and possibly brand_name_rxcui, have been located
	// Rather than using the amount / units, we refer to the drug's 
	// formulation description and extract the drug's strength
	st_duration_unit.visible = false
	st_unit.visible = false
	st_duration_amount.visible = false
	u_amount.visible = false
	cb_set_amount.visible = false
	st_strength_t.visible = True
	st_strength.visible = True
	
	st_strength.Text = sqlca.fn_strength(administer_form_rxcui)
	
ELSE
	st_duration_unit.visible = true
	st_unit.visible = true
	st_duration_amount.visible = true
	u_amount.visible = true
	cb_set_amount.visible = true
	st_strength_t.visible = false
	st_strength.visible = false
	
	li_sts = default_admin_unit()
	if li_sts = 0 then
		openwithparm(w_pop_message, "This drug has no valid administration units")
		log.log(this, "w_drug_administration:open", "No valid admin units for this drug (" + drug_id + ")", 4)
		closewithreturn(this, popup_return)
		return
	elseif li_sts < 0 then
		log.log(this, "w_drug_administration:open", "Error retrieving default admin unit", 4)
		closewithreturn(this, popup_return)
		return
	end if
END IF

uo_calc_per_day.postevent("clicked")
uo_no.postevent("clicked")

uo_administer_frequency.postevent("clicked")

end event

type pb_epro_help from w_window_base`pb_epro_help within w_drug_administration
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_drug_administration
end type

type st_title from statictext within w_drug_administration
integer y = 8
integer width = 2917
integer height = 132
boolean bringtotop = true
integer textsize = -18
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Administration for "
alignment alignment = center!
boolean focusrectangle = false
end type

type st_unit from statictext within w_drug_administration
integer x = 978
integer y = 800
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

type st_duration_amount from statictext within w_drug_administration
integer x = 571
integer y = 672
integer width = 320
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Amount:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_duration_unit from statictext within w_drug_administration
integer x = 571
integer y = 808
integer width = 320
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Unit:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_duration_prn from statictext within w_drug_administration
integer x = 544
integer y = 396
integer width = 338
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Frequency:"
alignment alignment = right!
boolean focusrectangle = false
end type

type pb_done from u_picture_button within w_drug_administration
integer x = 2592
integer y = 1556
integer width = 256
integer height = 224
integer taborder = 30
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return
string ls_description  
integer li_administration_sequence
string ls_administer_frequency
string ls_administer_unit
real lr_administer_amount
string ls_mult_by_what
string ls_calc_per
string ls_form_rxcui

if isnull(administer_form_rxcui) then
	
	if isnull(u_amount.text) or trim(u_amount.text) = "" or real(u_amount.text) = 0 then
		openwithparm(w_pop_message, "You must supply an administration amount")
		return
	end if
	
	if isnull(administer_unit) then
		openwithparm(w_pop_message, "You must supply an administration unit")
		return
	end if
end if

ls_administer_frequency = uo_administer_frequency.administer_frequency
lr_administer_amount = real(u_amount.text)
ls_administer_unit = administer_unit.unit_id
if mult_by_kg then
	ls_mult_by_what = "KG"
	ls_calc_per = calc_per
else
	setnull(ls_mult_by_what)
	setnull(ls_calc_per)
end if
if isnull(sle_description.text) or trim(sle_description.text) = "" then
	setnull(ls_description)
else
	ls_description = sle_description.text
end if

SELECT max(administration_sequence)
INTO :li_administration_sequence
FROM c_Drug_Administration
WHERE drug_id = :drug_id;
if not tf_check() then return
if isnull(li_administration_sequence) then
	li_administration_sequence = 1
else
	li_administration_sequence += 1
end if


sqlca.sp_new_drug_administration(drug_id,   &
											li_administration_sequence,   &
											ls_administer_frequency,   &
											lr_administer_amount,   &
											ls_administer_unit,   &
											ls_mult_by_what,   &
											ls_calc_per,   &
											ls_description,  &
											ls_form_rxcui)
if not tf_check() then return

popup_return.item_count = 1
popup_return.items[1] = string(li_administration_sequence)

closewithreturn(parent, popup_return)



end event

type pb_cancel from u_picture_button within w_drug_administration
integer x = 82
integer y = 1556
integer width = 256
integer height = 224
integer taborder = 20
boolean bringtotop = true
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

type uo_administer_frequency from u_administer_frequency within w_drug_administration
integer x = 969
integer y = 384
integer width = 1289
integer height = 104
end type

type st_2 from statictext within w_drug_administration
integer x = 626
integer y = 1068
integer width = 576
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Multiply By Weight:"
alignment alignment = right!
boolean focusrectangle = false
end type

type uo_yes from u_st_radio_multby_yesno within w_drug_administration
integer x = 1289
integer y = 1056
integer width = 270
integer height = 104
string text = "Yes"
end type

event clicked;call super::clicked;

mult_by_kg = true

st_calc_per_title.visible = true
uo_calc_per_day.visible = true
uo_calc_per_dose.visible = true

end event

type uo_no from u_st_radio_multby_yesno within w_drug_administration
integer x = 1627
integer y = 1056
integer width = 270
integer height = 104
boolean bringtotop = true
string text = "No"
end type

event clicked;call super::clicked;
mult_by_kg = false

st_calc_per_title.visible = false
uo_calc_per_day.visible = false
uo_calc_per_dose.visible = false

end event

type st_calc_per_title from statictext within w_drug_administration
integer x = 777
integer y = 1272
integer width = 425
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Calculate Per:"
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_calc_per_day from u_st_radio_calc_per within w_drug_administration
integer x = 1289
integer y = 1256
integer width = 270
integer height = 104
string text = "Day"
end type

event clicked;call super::clicked;calc_per = "DAY"

end event

type uo_calc_per_dose from u_st_radio_calc_per within w_drug_administration
integer x = 1627
integer y = 1256
integer width = 270
integer height = 104
boolean bringtotop = true
string text = "Dose"
end type

event clicked;call super::clicked;calc_per = "DOSE"

end event

type cb_set_amount from commandbutton within w_drug_administration
integer x = 2368
integer y = 660
integer width = 146
integer height = 100
integer taborder = 50
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

type sle_description from singlelineedit within w_drug_administration
integer x = 1289
integer y = 1424
integer width = 1157
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type st_description from statictext within w_drug_administration
integer x = 544
integer y = 1424
integer width = 658
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Description (Optional):"
alignment alignment = center!
boolean focusrectangle = false
end type

type u_amount from u_sle_real_number within w_drug_administration
integer x = 978
integer y = 656
integer width = 1289
integer height = 100
integer taborder = 10
end type

type pb_1 from u_pb_help_button within w_drug_administration
integer x = 1330
integer y = 1608
integer width = 256
integer height = 128
integer taborder = 20
boolean bringtotop = true
end type

type st_strength_t from statictext within w_drug_administration
integer x = 544
integer y = 532
integer width = 338
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Strength:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_strength from statictext within w_drug_administration
integer x = 978
integer y = 532
integer width = 1280
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
alignment alignment = Right!
boolean border = true
borderstyle borderstyle = StyleBox!
boolean focusrectangle = false
end type

