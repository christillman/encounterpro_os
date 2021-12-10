$PBExportHeader$u_tabpage_drug_properties.sru
forward
global type u_tabpage_drug_properties from u_tabpage_drug_base
end type
type st_max_dose_unit_title from statictext within u_tabpage_drug_properties
end type
type shl_drug from statichyperlink within u_tabpage_drug_properties
end type
type cb_equivalence from commandbutton within u_tabpage_drug_properties
end type
type st_constituents_title from statictext within u_tabpage_drug_properties
end type
type dw_constituents from u_dw_pick_list within u_tabpage_drug_properties
end type
type st_max_dose_title from statictext within u_tabpage_drug_properties
end type
type st_provider_reference_material from statictext within u_tabpage_drug_properties
end type
type st_provider_reference_material_title from statictext within u_tabpage_drug_properties
end type
type st_patient_reference_material from statictext within u_tabpage_drug_properties
end type
type st_patient_reference_material_title from statictext within u_tabpage_drug_properties
end type
type u_max_dose_per_day from u_sle_real_number within u_tabpage_drug_properties
end type
type cb_set_max_dose_amount from commandbutton within u_tabpage_drug_properties
end type
type st_link from statictext within u_tabpage_drug_properties
end type
type st_dose_amount_title from statictext within u_tabpage_drug_properties
end type
type st_max_dose_unit from statictext within u_tabpage_drug_properties
end type
type st_dea_schedule_title from statictext within u_tabpage_drug_properties
end type
type st_dea_schedule from statictext within u_tabpage_drug_properties
end type
type st_drug_type_title from statictext within u_tabpage_drug_properties
end type
type st_drug_type from statictext within u_tabpage_drug_properties
end type
type u_default_duration from u_duration_amount within u_tabpage_drug_properties
end type
type st_default_duration from statictext within u_tabpage_drug_properties
end type
type st_controlled_substance_title from statictext within u_tabpage_drug_properties
end type
type st_controlled_substance_flag from statictext within u_tabpage_drug_properties
end type
end forward

global type u_tabpage_drug_properties from u_tabpage_drug_base
integer width = 2802
integer height = 1116
st_max_dose_unit_title st_max_dose_unit_title
shl_drug shl_drug
cb_equivalence cb_equivalence
st_constituents_title st_constituents_title
dw_constituents dw_constituents
st_max_dose_title st_max_dose_title
st_provider_reference_material st_provider_reference_material
st_provider_reference_material_title st_provider_reference_material_title
st_patient_reference_material st_patient_reference_material
st_patient_reference_material_title st_patient_reference_material_title
u_max_dose_per_day u_max_dose_per_day
cb_set_max_dose_amount cb_set_max_dose_amount
st_link st_link
st_dose_amount_title st_dose_amount_title
st_max_dose_unit st_max_dose_unit
st_dea_schedule_title st_dea_schedule_title
st_dea_schedule st_dea_schedule
st_drug_type_title st_drug_type_title
st_drug_type st_drug_type
u_default_duration u_default_duration
st_default_duration st_default_duration
st_controlled_substance_title st_controlled_substance_title
st_controlled_substance_flag st_controlled_substance_flag
end type
global u_tabpage_drug_properties u_tabpage_drug_properties

forward prototypes
public subroutine set_screen ()
public function integer add_compound_drugs ()
public function integer add_cocktail_drugs ()
public function integer remove_constituent ()
public function integer initialize ()
end prototypes

public subroutine set_screen ();integer li_count

// Make appropriate controls visible based on drug type
CHOOSE CASE lower(drug_tab.drug.drug_type)
	CASE "allergen"
		st_constituents_title.visible = false
		dw_constituents.visible = false
		st_dose_amount_title.visible = false
		st_max_dose_title.visible = false
		u_max_dose_per_day.visible = false
		cb_set_max_dose_amount.visible = false
		st_max_dose_unit_title.visible = false
		st_max_dose_unit.visible = false
		st_controlled_substance_title.visible = false
		st_controlled_substance_flag.visible = false
		st_dea_schedule_title.visible = false
		st_dea_schedule.visible = false
		st_default_duration.visible = false
		u_default_duration.visible = false
	CASE "single drug"
		st_constituents_title.visible = false
		dw_constituents.visible = false
		st_dose_amount_title.visible = true
		st_max_dose_title.visible = true
		u_max_dose_per_day.visible = true
		cb_set_max_dose_amount.visible = true
		st_max_dose_unit_title.visible = true
		st_max_dose_unit.visible = true
		st_controlled_substance_title.visible = true
		st_controlled_substance_flag.visible = true
		st_dea_schedule_title.visible = false
		st_dea_schedule.visible = false
		st_default_duration.visible = true
		u_default_duration.visible = true
	CASE "compound drug"
		st_constituents_title.visible = true
		dw_constituents.visible = true
		st_dose_amount_title.visible = true
		st_max_dose_title.visible = true
		u_max_dose_per_day.visible = true
		cb_set_max_dose_amount.visible = true
		st_max_dose_unit_title.visible = true
		st_max_dose_unit.visible = true
		st_controlled_substance_title.visible = true
		st_controlled_substance_flag.visible = true
		st_dea_schedule_title.visible = false
		st_dea_schedule.visible = false
		st_default_duration.visible = true
		u_default_duration.visible = true
	CASE "cocktail"
		st_constituents_title.visible = true
		dw_constituents.visible = true
		st_dose_amount_title.visible = false
		st_max_dose_title.visible = false
		u_max_dose_per_day.visible = false
		cb_set_max_dose_amount.visible = false
		st_max_dose_unit_title.visible = false
		st_max_dose_unit.visible = false
		st_controlled_substance_title.visible = true
		st_controlled_substance_flag.visible = true
		st_dea_schedule_title.visible = false
		st_dea_schedule.visible = false
		st_default_duration.visible = true
		u_default_duration.visible = true
	CASE "vaccine"
		st_constituents_title.visible = false
		dw_constituents.visible = false
		st_dose_amount_title.visible = false
		st_max_dose_title.visible = false
		u_max_dose_per_day.visible = false
		cb_set_max_dose_amount.visible = false
		st_max_dose_unit_title.visible = false
		st_max_dose_unit.visible = false
		st_controlled_substance_title.visible = false
		st_controlled_substance_flag.visible = false
		st_dea_schedule_title.visible = false
		st_dea_schedule.visible = false
		st_default_duration.visible = false
		u_default_duration.visible = false
END CHOOSE


end subroutine

public function integer add_compound_drugs ();str_popup popup
str_popup_return popup_return
str_picked_drugs lstr_drugs
integer li_added_count
long i

popup.data_row_count = 2
popup.items[1] = "DrugCompound"
popup.items[2] = "True"

openwithparm(w_pick_drug_compound, popup)
lstr_drugs = message.powerobjectparm

for i = 1 to lstr_drugs.drug_count
	INSERT INTO c_Drug_Compound (
		drug_id,
		constituent_drug_id,
		percentage)
	VALUES (
		:drug_tab.drug.drug_id,
		:lstr_drugs.drugs[i].drug_id,
		:lstr_drugs.drugs[i].percentage);
	if not tf_check() then return -1
next

return li_added_count

end function

public function integer add_cocktail_drugs ();str_popup popup
str_popup_return popup_return
str_picked_drugs lstr_drugs
integer li_added_count
long i

popup.data_row_count = 2
popup.items[1] = "DrugCocktail"
popup.items[2] = "True"

openwithparm(w_pick_drug_cocktail, popup)
lstr_drugs = message.powerobjectparm

for i = 1 to lstr_drugs.drug_count
	INSERT INTO c_Drug_Compound (
		drug_id,
		constituent_drug_id,
		administer_amount,
		administer_unit)
	VALUES (
		:drug_tab.drug.drug_id,
		:lstr_drugs.drugs[i].drug_id,
		:lstr_drugs.drugs[i].administer_amount,
		:lstr_drugs.drugs[i].administer_unit);
	if not tf_check() then return -1
next

return li_added_count

end function

public function integer remove_constituent ();str_popup popup
str_popup_return popup_return
long ll_compound_sequence


popup.dataobject = "dw_drug_constituents_pick"
popup.datacolumn = 1
popup.displaycolumn = 3
popup.argument_count = 1
popup.argument[1] = drug_tab.drug.drug_id

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <= 0 then return 0

ll_compound_sequence = long(popup_return.items[1])

DELETE FROM c_Drug_Compound
WHERE drug_id = :drug_tab.drug.drug_id
AND compound_sequence = :ll_compound_sequence;
if not tf_check() then return -1

dw_constituents.retrieve(drug_tab.drug.drug_id)

return 1


end function

public function integer initialize ();integer li_sts
str_patient_material lstr_patient_material

set_screen()

shl_drug.text = drug_tab.drug.common_name
shl_drug.url = "https://mor.nlm.nih.gov/RxNav/search?searchBy=String&searchTerm=" + drug_tab.drug.common_name

st_drug_type.text = drug_tab.drug.drug_type

u_default_duration.set_amount(drug_tab.drug.default_duration_amount, drug_tab.drug.default_duration_unit, drug_tab.drug.default_duration_prn)

u_max_dose_per_day.text = string(drug_tab.drug.max_dose_per_day)

//drug_tab.drug.max_dose_unit = ls_max_dose_unit
//max_dose_unit = unit_list.find_unit(ls_max_dose_unit)
if isnull(drug_tab.drug.max_dose_unit) then
	st_max_dose_unit.text = ""
else
	st_max_dose_unit.text = unit_list.unit_description(drug_tab.drug.max_dose_unit)
end if

st_dea_schedule.text = drug_tab.drug.dea_schedule

if drug_tab.drug.controlled_substance_flag = "Y" then
	st_controlled_substance_flag.text = "Yes"
	st_dea_schedule.visible = true
	st_dea_schedule_title.visible = true
else
	drug_tab.drug.controlled_substance_flag = "N"
	st_controlled_substance_flag.text = "No"
	st_dea_schedule.visible = false
	st_dea_schedule_title.visible = false
end if

if dw_constituents.visible then
	dw_constituents.settransobject(sqlca)
	dw_constituents.retrieve(drug_tab.drug.drug_id)
end if

lstr_patient_material = f_get_patient_material(drug_tab.drug.patient_reference_material_id, false)
if len(lstr_patient_material.title) > 0 then
	st_patient_reference_material.text = lstr_patient_material.title
else
	st_patient_reference_material.text = "N/A"
end if

lstr_patient_material = f_get_patient_material(drug_tab.drug.provider_reference_material_id, false)
if len(lstr_patient_material.title) > 0 then
	st_provider_reference_material.text = lstr_patient_material.title
else
	st_provider_reference_material.text = "N/A"
end if


return 1


end function

on u_tabpage_drug_properties.create
int iCurrent
call super::create
this.st_max_dose_unit_title=create st_max_dose_unit_title
this.shl_drug=create shl_drug
this.cb_equivalence=create cb_equivalence
this.st_constituents_title=create st_constituents_title
this.dw_constituents=create dw_constituents
this.st_max_dose_title=create st_max_dose_title
this.st_provider_reference_material=create st_provider_reference_material
this.st_provider_reference_material_title=create st_provider_reference_material_title
this.st_patient_reference_material=create st_patient_reference_material
this.st_patient_reference_material_title=create st_patient_reference_material_title
this.u_max_dose_per_day=create u_max_dose_per_day
this.cb_set_max_dose_amount=create cb_set_max_dose_amount
this.st_link=create st_link
this.st_dose_amount_title=create st_dose_amount_title
this.st_max_dose_unit=create st_max_dose_unit
this.st_dea_schedule_title=create st_dea_schedule_title
this.st_dea_schedule=create st_dea_schedule
this.st_drug_type_title=create st_drug_type_title
this.st_drug_type=create st_drug_type
this.u_default_duration=create u_default_duration
this.st_default_duration=create st_default_duration
this.st_controlled_substance_title=create st_controlled_substance_title
this.st_controlled_substance_flag=create st_controlled_substance_flag
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_max_dose_unit_title
this.Control[iCurrent+2]=this.shl_drug
this.Control[iCurrent+3]=this.cb_equivalence
this.Control[iCurrent+4]=this.st_constituents_title
this.Control[iCurrent+5]=this.dw_constituents
this.Control[iCurrent+6]=this.st_max_dose_title
this.Control[iCurrent+7]=this.st_provider_reference_material
this.Control[iCurrent+8]=this.st_provider_reference_material_title
this.Control[iCurrent+9]=this.st_patient_reference_material
this.Control[iCurrent+10]=this.st_patient_reference_material_title
this.Control[iCurrent+11]=this.u_max_dose_per_day
this.Control[iCurrent+12]=this.cb_set_max_dose_amount
this.Control[iCurrent+13]=this.st_link
this.Control[iCurrent+14]=this.st_dose_amount_title
this.Control[iCurrent+15]=this.st_max_dose_unit
this.Control[iCurrent+16]=this.st_dea_schedule_title
this.Control[iCurrent+17]=this.st_dea_schedule
this.Control[iCurrent+18]=this.st_drug_type_title
this.Control[iCurrent+19]=this.st_drug_type
this.Control[iCurrent+20]=this.u_default_duration
this.Control[iCurrent+21]=this.st_default_duration
this.Control[iCurrent+22]=this.st_controlled_substance_title
this.Control[iCurrent+23]=this.st_controlled_substance_flag
end on

on u_tabpage_drug_properties.destroy
call super::destroy
destroy(this.st_max_dose_unit_title)
destroy(this.shl_drug)
destroy(this.cb_equivalence)
destroy(this.st_constituents_title)
destroy(this.dw_constituents)
destroy(this.st_max_dose_title)
destroy(this.st_provider_reference_material)
destroy(this.st_provider_reference_material_title)
destroy(this.st_patient_reference_material)
destroy(this.st_patient_reference_material_title)
destroy(this.u_max_dose_per_day)
destroy(this.cb_set_max_dose_amount)
destroy(this.st_link)
destroy(this.st_dose_amount_title)
destroy(this.st_max_dose_unit)
destroy(this.st_dea_schedule_title)
destroy(this.st_dea_schedule)
destroy(this.st_drug_type_title)
destroy(this.st_drug_type)
destroy(this.u_default_duration)
destroy(this.st_default_duration)
destroy(this.st_controlled_substance_title)
destroy(this.st_controlled_substance_flag)
end on

type st_max_dose_unit_title from statictext within u_tabpage_drug_properties
integer x = 389
integer y = 912
integer width = 155
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

type shl_drug from statichyperlink within u_tabpage_drug_properties
integer x = 928
integer y = 272
integer width = 791
integer height = 92
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 134217856
long backcolor = 12632256
string text = "Tapentadol"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
string url = "https://mor.nlm.nih.gov/RxNav/search?searchBy=String&searchTerm=Tapentadol"
end type

type cb_equivalence from commandbutton within u_tabpage_drug_properties
integer x = 1975
integer y = 296
integer width = 626
integer height = 112
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Equivalence"
end type

event clicked;str_content_object lstr_item
w_object_equivalence lw_window

if isnull(drug_tab.drug.drug_id) then return

lstr_item.object_id = sqlca.fn_object_id_from_key("Drug", drug_tab.drug.drug_id)
lstr_item.object_type = "Drug"
lstr_item.object_key = drug_tab.drug.drug_id
lstr_item.description = drug_tab.drug.common_name
lstr_item.owner_id = drug_tab.drug.owner_id

openwithparm(lw_window, lstr_item, "w_object_equivalence")

end event

type st_constituents_title from statictext within u_tabpage_drug_properties
integer x = 1783
integer y = 560
integer width = 818
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Constituents"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_constituents from u_dw_pick_list within u_tabpage_drug_properties
integer x = 1783
integer y = 632
integer width = 818
integer height = 372
integer taborder = 50
boolean bringtotop = true
string dataobject = "dw_drug_constituents_small"
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
	popup.button_helps[popup.button_count] = "Add Constituent Drugs"
	popup.button_titles[popup.button_count] = "Add Constituents"
	buttons[popup.button_count] = "ADD"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Remove Constituent Drugs"
	popup.button_titles[popup.button_count] = "Remove Constituents"
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
		if lower(st_drug_type.text) = "compound drug" then
			li_sts = add_compound_drugs()
		elseif lower(st_drug_type.text) = "cocktail" then
			li_sts = add_cocktail_drugs()
		end if
	CASE "REMOVE"
		li_sts = remove_constituent()
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

dw_constituents.retrieve(drug_tab.drug.drug_id)

return

end event

type st_max_dose_title from statictext within u_tabpage_drug_properties
integer x = 411
integer y = 688
integer width = 791
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 7191717
boolean enabled = false
string text = "Max Calculated Dose"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_provider_reference_material from statictext within u_tabpage_drug_properties
integer x = 928
integer y = 500
integer width = 791
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;w_pick_patient_material lw_pick
long ll_material_id
str_patient_material lstr_patient_material
str_popup popup
str_popup_return popup_return
integer li_choice

if drug_tab.drug.provider_reference_material_id > 0 then
	popup.data_row_count = 3
	popup.items[1] = "View Provider Material"
	popup.items[2] = "Pick Provider Material"
	popup.items[3] = "Clear Provider Material"
	openwithparm(w_pop_pick, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return
	
	li_choice = popup_return.item_indexes[1]
else
	li_choice = 2
end if

CHOOSE CASE li_choice
	CASE 1
		f_display_patient_material(drug_tab.drug.provider_reference_material_id)
	CASE 2
		open(lw_pick, "w_pick_patient_material")
		ll_material_id = message.doubleparm
		if ll_material_id <= 0 then return
		
		lstr_patient_material = f_get_patient_material(ll_material_id, false)
		if lstr_patient_material.material_id > 0 then
			drug_tab.drug.provider_reference_material_id = lstr_patient_material.material_id
			text = lstr_patient_material.title
		end if
	CASE 3
		setnull(drug_tab.drug.provider_reference_material_id)
		text = "N/A"
END CHOOSE




end event

type st_provider_reference_material_title from statictext within u_tabpage_drug_properties
integer x = 41
integer y = 508
integer width = 869
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Provider Reference Material:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_patient_reference_material from statictext within u_tabpage_drug_properties
integer x = 928
integer y = 388
integer width = 791
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;w_pick_patient_material lw_pick
long ll_material_id
str_patient_material lstr_patient_material
str_popup popup
str_popup_return popup_return
integer li_choice

if drug_tab.drug.patient_reference_material_id > 0 then
	popup.data_row_count = 3
	popup.items[1] = "View Patient Material"
	popup.items[2] = "Pick Patient Material"
	popup.items[3] = "Clear Patient Material"
	openwithparm(w_pop_pick, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return
	
	li_choice = popup_return.item_indexes[1]
else
	li_choice = 2
end if

CHOOSE CASE li_choice
	CASE 1
		f_display_patient_material(drug_tab.drug.patient_reference_material_id)
	CASE 2
		open(lw_pick, "w_pick_patient_material")
		ll_material_id = message.doubleparm
		if ll_material_id <= 0 then return
		
		lstr_patient_material = f_get_patient_material(ll_material_id, false)
		if lstr_patient_material.material_id > 0 then
			drug_tab.drug.patient_reference_material_id = lstr_patient_material.material_id
			text = lstr_patient_material.title
		end if
	CASE 3
		setnull(drug_tab.drug.patient_reference_material_id)
		text = "N/A"
END CHOOSE




end event

type st_patient_reference_material_title from statictext within u_tabpage_drug_properties
integer x = 41
integer y = 396
integer width = 869
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Patient Reference Material:"
alignment alignment = right!
boolean focusrectangle = false
end type

type u_max_dose_per_day from u_sle_real_number within u_tabpage_drug_properties
integer x = 558
integer y = 780
integer width = 439
integer height = 100
integer taborder = 70
boolean bringtotop = true
end type

event first_value;call super::first_value;
if isnull(drug_tab.drug.max_dose_unit) or drug_tab.drug.max_dose_unit = "" then
	drug_tab.drug.max_dose_unit = "MG"
	st_max_dose_unit.text = unit_list.unit_description(drug_tab.drug.max_dose_unit)
end if

end event

event modified;call super::modified;if isnumber(text) then
	drug_tab.drug.max_dose_per_day = real(text)
else
	text = ""
end if


end event

type cb_set_max_dose_amount from commandbutton within u_tabpage_drug_properties
integer x = 1010
integer y = 780
integer width = 146
integer height = 100
integer taborder = 70
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
u_unit luo_unit

luo_unit = unit_list.find_unit(drug_tab.drug.max_dose_unit)

popup.realitem = real(u_max_dose_per_day.text)
popup.objectparm = luo_unit

openwithparm(w_number, popup)
popup_return = message.powerobjectparm

if isnull(luo_unit) then
	u_max_dose_per_day.text = string(popup_return.realitem)
else
	u_max_dose_per_day.text = luo_unit.pretty_amount(popup_return.realitem)
end if

drug_tab.drug.max_dose_per_day = real(u_max_dose_per_day.text)

end event

type st_link from statictext within u_tabpage_drug_properties
integer x = 690
integer y = 284
integer width = 219
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "RxNav:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_dose_amount_title from statictext within u_tabpage_drug_properties
integer x = 251
integer y = 796
integer width = 293
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

type st_max_dose_unit from statictext within u_tabpage_drug_properties
integer x = 558
integer y = 912
integer width = 599
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
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
	drug_tab.drug.max_dose_unit = popup_return.items[1]
	text = popup_return.descriptions[1]
end if


end event

type st_dea_schedule_title from statictext within u_tabpage_drug_properties
integer x = 1792
integer y = 160
integer width = 571
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "DEA Schedule:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_dea_schedule from statictext within u_tabpage_drug_properties
integer x = 2386
integer y = 144
integer width = 215
integer height = 104
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
string ls_null
integer li_sts

setnull(ls_null)

// get the service type
popup.dataobject = "dw_domain_notranslate_list"
popup.datacolumn = 2
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = "DEA Schedule"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

drug_tab.drug.dea_schedule = popup_return.items[1]
text = drug_tab.drug.dea_schedule

end event

type st_drug_type_title from statictext within u_tabpage_drug_properties
integer x = 233
integer y = 32
integer width = 352
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Drug Type:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_drug_type from statictext within u_tabpage_drug_properties
integer x = 603
integer y = 20
integer width = 608
integer height = 104
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
string text = "Single Drug"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_drug_type_pick"
popup.displaycolumn = 1
popup.datacolumn = 1

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

drug_tab.drug.drug_type = popup_return.items[1]
text = drug_tab.drug.drug_type

set_screen()

end event

type u_default_duration from u_duration_amount within u_tabpage_drug_properties
integer x = 603
integer y = 144
integer width = 608
integer height = 104
integer taborder = 70
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
end type

event clicked;call super::clicked;drug_tab.drug.default_duration_amount = amount
drug_tab.drug.default_duration_unit = unit
drug_tab.drug.default_duration_prn = prn

end event

type st_default_duration from statictext within u_tabpage_drug_properties
integer x = 32
integer y = 160
integer width = 553
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Default Duration:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_controlled_substance_title from statictext within u_tabpage_drug_properties
integer x = 1691
integer y = 32
integer width = 672
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Controlled Substance:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_controlled_substance_flag from statictext within u_tabpage_drug_properties
integer x = 2386
integer y = 20
integer width = 215
integer height = 104
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "No"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if drug_tab.drug.controlled_substance_flag = "Y" then
	drug_tab.drug.controlled_substance_flag = "N"
	text = "No"
	st_dea_schedule.visible = false
	st_dea_schedule_title.visible = false
else
	drug_tab.drug.controlled_substance_flag = "Y"
	text = "Yes"
	st_dea_schedule.visible = true
	st_dea_schedule_title.visible = true
end if



end event

