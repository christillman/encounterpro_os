$PBExportHeader$w_drug_attributes.srw
forward
global type w_drug_attributes from w_window_base
end type
type sle_common_name from singlelineedit within w_drug_attributes
end type
type st_common_name from statictext within w_drug_attributes
end type
type st_max_dose_unit from statictext within w_drug_attributes
end type
type st_dose_amount_title from statictext within w_drug_attributes
end type
type st_max_dose_unit_title from statictext within w_drug_attributes
end type
type sle_generic_name from singlelineedit within w_drug_attributes
end type
type st_generic_name from statictext within w_drug_attributes
end type
type cb_set_max_dose_amount from commandbutton within w_drug_attributes
end type
type u_max_dose_per_day from u_sle_real_number within w_drug_attributes
end type
type st_controlled_substance_flag from statictext within w_drug_attributes
end type
type st_controlled_substance_title from statictext within w_drug_attributes
end type
type dw_packages from u_dw_pick_list within w_drug_attributes
end type
type st_package_title from statictext within w_drug_attributes
end type
type dw_constituents from u_dw_pick_list within w_drug_attributes
end type
type st_constituents_title from statictext within w_drug_attributes
end type
type dw_hcpcs from u_dw_pick_list within w_drug_attributes
end type
type st_hcpcs_title from statictext within w_drug_attributes
end type
type st_default_duration from statictext within w_drug_attributes
end type
type u_default_duration from u_duration_amount within w_drug_attributes
end type
type dw_administration from u_dw_pick_list within w_drug_attributes
end type
type st_admin_title from statictext within w_drug_attributes
end type
type cb_common_list from commandbutton within w_drug_attributes
end type
type st_drug_type from statictext within w_drug_attributes
end type
type st_drug_type_title from statictext within w_drug_attributes
end type
type cb_categories from commandbutton within w_drug_attributes
end type
type cb_cancel from commandbutton within w_drug_attributes
end type
type cb_ok from commandbutton within w_drug_attributes
end type
type st_patient_reference_material_title from statictext within w_drug_attributes
end type
type st_patient_reference_material from statictext within w_drug_attributes
end type
type st_provider_reference_material_title from statictext within w_drug_attributes
end type
type st_provider_reference_material from statictext within w_drug_attributes
end type
type st_1 from statictext within w_drug_attributes
end type
type cb_1 from commandbutton within w_drug_attributes
end type
type st_dea_schedule from statictext within w_drug_attributes
end type
type st_dea_schedule_title from statictext within w_drug_attributes
end type
end forward

global type w_drug_attributes from w_window_base
integer width = 2944
integer height = 1844
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
sle_common_name sle_common_name
st_common_name st_common_name
st_max_dose_unit st_max_dose_unit
st_dose_amount_title st_dose_amount_title
st_max_dose_unit_title st_max_dose_unit_title
sle_generic_name sle_generic_name
st_generic_name st_generic_name
cb_set_max_dose_amount cb_set_max_dose_amount
u_max_dose_per_day u_max_dose_per_day
st_controlled_substance_flag st_controlled_substance_flag
st_controlled_substance_title st_controlled_substance_title
dw_packages dw_packages
st_package_title st_package_title
dw_constituents dw_constituents
st_constituents_title st_constituents_title
dw_hcpcs dw_hcpcs
st_hcpcs_title st_hcpcs_title
st_default_duration st_default_duration
u_default_duration u_default_duration
dw_administration dw_administration
st_admin_title st_admin_title
cb_common_list cb_common_list
st_drug_type st_drug_type
st_drug_type_title st_drug_type_title
cb_categories cb_categories
cb_cancel cb_cancel
cb_ok cb_ok
st_patient_reference_material_title st_patient_reference_material_title
st_patient_reference_material st_patient_reference_material
st_provider_reference_material_title st_provider_reference_material_title
st_provider_reference_material st_provider_reference_material
st_1 st_1
cb_1 cb_1
st_dea_schedule st_dea_schedule
st_dea_schedule_title st_dea_schedule_title
end type
global w_drug_attributes w_drug_attributes

type variables
boolean new_drug

integer deleted_count
string deleted_category[]
string deleted_key[]

integer drug_admin_count
str_drug_administration drug_admin[]

str_drug_definition drug


end variables

forward prototypes
public function integer remove_hcpcs ()
public function integer remove_package ()
public function integer remove_admin ()
public function integer add_package ()
public function integer edit_admin ()
public function integer edit_package (string ps_package_id)
public function integer edit_package ()
public function integer load_drug_admin ()
public function integer save_new_drug ()
public function integer add_category ()
public function integer remove_category ()
public function integer remove_constituent ()
public function integer add_cocktail_drugs ()
public function integer add_compound_drugs ()
public function integer add_admin ()
public subroutine count_drug_categories ()
public subroutine set_screen ()
public function integer add_hcpcs ()
public function integer load_drug (string ps_drug_id)
public subroutine count_common_list ()
public function integer new_drug ()
end prototypes

public function integer remove_hcpcs ();str_popup popup
str_popup_return popup_return
long ll_hcpcs_sequence

 DECLARE lsp_delete_drug_hcpcs PROCEDURE FOR dbo.sp_delete_drug_hcpcs
         @ps_drug_id = :drug.drug_id,   
         @pl_hcpcs_sequence = :ll_hcpcs_sequence;


popup.dataobject = "dw_drug_hcpcs_pick_list"
popup.datacolumn = 2
popup.displaycolumn = 1
popup.argument_count = 1
popup.argument[1] = drug.drug_id

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <= 0 then return 0

ll_hcpcs_sequence = long(popup_return.items[1])

EXECUTE lsp_delete_drug_hcpcs;
if not tf_check() then return -1

dw_hcpcs.retrieve(drug.drug_id)

return 1


end function

public function integer remove_package ();str_popup popup
str_popup_return popup_return
string ls_package_id

 DECLARE lsp_delete_drug_package PROCEDURE FOR dbo.sp_delete_drug_package 
         @ps_drug_id = :drug.drug_id,   
         @ps_package_id = :ls_package_id  ;


popup.dataobject = "dw_drug_package_pick_list"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = drug.drug_id
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

ls_package_id = popup_return.items[1]

EXECUTE lsp_delete_drug_package;
if not tf_check() then return -1

dw_packages.retrieve(drug.drug_id)

return 1


end function

public function integer remove_admin ();str_popup popup
str_popup_return popup_return
integer li_administration_sequence
integer i

 DECLARE lsp_delete_drug_administration PROCEDURE FOR dbo.sp_delete_drug_administration  
         @ps_drug_id = :drug.drug_id,   
         @pi_administration_sequence = :li_administration_sequence  ;


popup.data_row_count = drug_admin_count
for i = 1 to drug_admin_count
	popup.items[i] = drug_admin[i].description
next
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <= 0 then return 0

li_administration_sequence = drug_admin[popup_return.item_indexes[1]].administration_sequence

EXECUTE lsp_delete_drug_administration;
if not tf_check() then return -1

load_drug_admin()

return 1


end function

public function integer add_package ();str_popup popup
str_popup_return popup_return
string ls_package_id
string ls_description  

open(w_drug_package_selection)
popup_return = message.powerobjectparm

if popup_return.item_count <> 1 then return 0

ls_package_id = popup_return.items[1]
ls_description = popup_return.descriptions[1]

 DECLARE lsp_new_drug_package PROCEDURE FOR dbo.sp_new_drug_package  
         @ps_drug_id = :drug.drug_id,   
         @ps_package_id = :ls_package_id;

	
EXECUTE lsp_new_drug_package;
if not tf_check() then return -1

return edit_package(ls_package_id)


end function

public function integer edit_admin ();str_popup popup
str_popup_return popup_return
long ll_row, ll_count
string ls_find
string ls_package_id
integer li_sort_order
string ls_prescription_flag
real lr_default_dispense_amount
string ls_default_dispense_unit
string ls_take_as_directed
string ls_description  

popup.title = sle_common_name.text
openwithparm(w_drug_package, popup)
popup_return = message.powerobjectparm

if popup_return.item_count <> 6 then return 0

ls_package_id = popup_return.items[1]
lr_default_dispense_amount = real(popup_return.items[2])
ls_default_dispense_unit = popup_return.items[3]
ls_prescription_flag = popup_return.items[4]
ls_take_as_directed = popup_return.items[5]
ls_description = popup_return.items[6]


end function

public function integer edit_package (string ps_package_id);str_popup popup
str_popup_return popup_return
long ll_row, ll_count
string ls_find
string ls_package_id
integer li_sort_order
string ls_prescription_flag
real lr_default_dispense_amount
string ls_default_dispense_unit
string ls_take_as_directed
string ls_description  

popup.title = sle_common_name.text
popup.data_row_count = 2
popup.items[1] = drug.drug_id
popup.items[2] = ps_package_id
openwithparm(w_drug_package, popup)

dw_packages.retrieve(drug.drug_id)

return 1
end function

public function integer edit_package ();str_popup popup
str_popup_return popup_return
string ls_package_id

popup.dataobject = "dw_drug_package_pick_list"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = drug.drug_id
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

ls_package_id = popup_return.items[1]

return edit_package(ls_package_id)

end function

public function integer load_drug_admin ();integer i
long ll_row

drug_admin_count = f_get_drug_administration(drug.drug_id, drug_admin)

dw_administration.setredraw(false)

dw_administration.reset()

for i = 1 to drug_admin_count
	ll_row = dw_administration.insertrow(0)
	dw_administration.object.administration_sequence[ll_row] = drug_admin[i].administration_sequence
	dw_administration.object.description[ll_row] = drug_admin[i].description
next

dw_administration.setredraw(true)

return drug_admin_count


end function

public function integer save_new_drug ();integer li_sts
string ls_specialty_id
u_ds_data luo_data
long ll_count

if isnull(sle_common_name.text) or trim(sle_common_name.text) = "" then
	openwithparm(w_pop_message, "You must enter a common name")
	return 0
end if

if not sle_generic_name.visible then
	sle_generic_name.text = sle_common_name.text
end if

if isnull(sle_generic_name.text) or trim(sle_generic_name.text) = "" then
	openwithparm(w_pop_message, "You must enter a generic name")
	return 0
end if

li_sts = drugdb.save_new_drug(drug)
if li_sts <= 0 then
	openwithparm(w_pop_message, "Error saving new drug")
	return 0
end if

// Add this drug to this specialty
ls_specialty_id = current_user.common_list_id()

SELECT count(*)
INTO :ll_count
FROM c_Common_Drug
WHERE specialty_id = :ls_specialty_id
AND drug_id = :drug.drug_id;
if not tf_check() then return -1

if ll_count = 0 then
	INSERT INTO c_Common_Drug (
		specialty_id,
		drug_id)
	VALUES (
		:ls_specialty_id,
		:drug.drug_id );
	if not tf_check() then return -1
end if


new_drug = false
cb_cancel.visible = false

load_drug(drug.drug_id)

return 1

end function

public function integer add_category ();str_popup popup
str_popup_return popup_return
integer i
integer li_added_count
string ls_find
long ll_row
//
//li_added_count = 0
//
//popup.multiselect = true
//popup.dataobject = "dw_drug_category_list"
//popup.datacolumn = 1
//popup.displaycolumn = 2
//popup.argument_count = 1
//popup.argument[1] = drug_id
//
//openwithparm(w_pop_pick, popup)
//popup_return = message.powerobjectparm
//if popup_return.item_count <= 0 then return li_added_count
//
//for i = 1 to popup_return.item_count
//	// First make sure the category isn't already attached to this drug
//	ls_find = "drug_category_id='" + popup_return.items[i] + "'"
//	ll_row = dw_categories.find(ls_find, 1 , dw_categories.rowcount())
//	if ll_row > 0 then continue
//	
//	// If not, then add it
//	li_added_count += 1
//	ll_row = dw_categories.insertrow(0)
//	dw_categories.object.drug_id[ll_row] = drug_id
//	dw_categories.object.drug_category_id[ll_row] = popup_return.items[i]
//	dw_categories.object.description[ll_row] = popup_return.descriptions[i]
//next
//
//if li_added_count > 0 then
//	dw_categories.update()
//	dw_categories.sort()
//end if
//
return li_added_count

end function

public function integer remove_category ();str_popup popup
str_popup_return popup_return
string ls_drug_category_id

 DECLARE lsp_delete_drug_drug_category PROCEDURE FOR dbo.sp_delete_drug_drug_category  
         @ps_drug_id = :drug.drug_id,   
         @ps_drug_category_id = :ls_drug_category_id  ;


popup.dataobject = "dw_drug_drug_category_pick_list"
popup.datacolumn = 2
popup.displaycolumn = 3
popup.argument_count = 1
popup.argument[1] = drug.drug_id

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <= 0 then return 0

ls_drug_category_id = popup_return.items[1]

EXECUTE lsp_delete_drug_drug_category;
if not tf_check() then return -1

//dw_categories.retrieve(drug_id)

return 1


end function

public function integer remove_constituent ();str_popup popup
str_popup_return popup_return
long ll_compound_sequence


popup.dataobject = "dw_drug_constituents_pick"
popup.datacolumn = 1
popup.displaycolumn = 3
popup.argument_count = 1
popup.argument[1] = drug.drug_id

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <= 0 then return 0

ll_compound_sequence = long(popup_return.items[1])

DELETE FROM c_Drug_Compound
WHERE drug_id = :drug.drug_id
AND compound_sequence = :ll_compound_sequence;
if not tf_check() then return -1

dw_constituents.retrieve(drug.drug_id)

return 1


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
		:drug.drug_id,
		:lstr_drugs.drugs[i].drug_id,
		:lstr_drugs.drugs[i].administer_amount,
		:lstr_drugs.drugs[i].administer_unit);
	if not tf_check() then return -1
next

return li_added_count

end function

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
		:drug.drug_id,
		:lstr_drugs.drugs[i].drug_id,
		:lstr_drugs.drugs[i].percentage);
	if not tf_check() then return -1
next

return li_added_count

end function

public function integer add_admin ();str_popup popup
str_popup_return popup_return
long ll_row, ll_count
string ls_find
integer li_temp
string ls_attribute_description
string ls_administer_frequency
string ls_administer_unit
real lr_administer_amount
string ls_mult_by_what
string ls_calc_per
string ls_description
integer li_administration_sequence

popup.title = sle_common_name.text
popup.data_row_count = 1
popup.items[1] = drug.drug_id
openwithparm(w_drug_administration, popup)
popup_return = message.powerobjectparm

if popup_return.item_count <> 1 then return 0

load_drug_admin()

return 1

end function

public subroutine count_drug_categories ();integer li_count
// Set the categories button
SELECT count(*)
INTO :li_count
FROM c_Drug_Drug_Category
WHERE drug_id = :drug.drug_id;
if not tf_check() then return

if isnull(li_count) then li_count = 0

cb_categories.text = "Categories (" + string(li_count) + ")"
if li_count <= 0 then
	cb_categories.weight = 400
else
	cb_categories.weight = 700
end if
end subroutine

public subroutine set_screen ();integer li_count


count_drug_categories()

count_common_list()


// Make appropriate controls visible based on drug type
CHOOSE CASE lower(st_drug_type.text)
	CASE "allergen"
		st_generic_name.visible = false
		sle_generic_name.visible = false
		dw_administration.visible = false
		dw_packages.visible = true
		st_admin_title.visible = false
		st_package_title.visible = true
		st_constituents_title.visible = false
		dw_constituents.visible = false
		st_dose_amount_title.visible = false
		u_max_dose_per_day.visible = false
		cb_set_max_dose_amount.visible = false
		st_max_dose_unit_title.visible = false
		st_max_dose_unit.visible = false
		dw_hcpcs.visible = false
		st_hcpcs_title.visible = false
		st_controlled_substance_title.visible = false
		st_controlled_substance_flag.visible = false
		st_default_duration.visible = false
		u_default_duration.visible = false
	CASE "single drug"
		st_generic_name.visible = true
		sle_generic_name.visible = true
		dw_administration.visible = true
		dw_packages.visible = true
		st_admin_title.visible = true
		st_package_title.visible = true
		st_constituents_title.visible = false
		dw_constituents.visible = false
		st_dose_amount_title.visible = true
		u_max_dose_per_day.visible = true
		cb_set_max_dose_amount.visible = true
		st_max_dose_unit_title.visible = true
		st_max_dose_unit.visible = true
		dw_hcpcs.visible = true
		st_hcpcs_title.visible = true
		st_controlled_substance_title.visible = true
		st_controlled_substance_flag.visible = true
		st_default_duration.visible = true
		u_default_duration.visible = true
	CASE "compound drug"
		st_generic_name.visible = true
		sle_generic_name.visible = true
		dw_administration.visible = true
		dw_packages.visible = true
		st_admin_title.visible = true
		st_package_title.visible = true
		st_constituents_title.visible = true
		dw_constituents.visible = true
		st_dose_amount_title.visible = true
		u_max_dose_per_day.visible = true
		cb_set_max_dose_amount.visible = true
		st_max_dose_unit_title.visible = true
		st_max_dose_unit.visible = true
		dw_hcpcs.visible = true
		st_hcpcs_title.visible = true
		st_controlled_substance_title.visible = true
		st_controlled_substance_flag.visible = true
		st_default_duration.visible = true
		u_default_duration.visible = true
	CASE "cocktail"
		st_generic_name.visible = false
		sle_generic_name.visible = false
		dw_administration.visible = false
		dw_packages.visible = true
		st_admin_title.visible = false
		st_package_title.visible = true
		st_constituents_title.visible = true
		dw_constituents.visible = true
		st_dose_amount_title.visible = false
		u_max_dose_per_day.visible = false
		cb_set_max_dose_amount.visible = false
		st_max_dose_unit_title.visible = false
		st_max_dose_unit.visible = false
		dw_hcpcs.visible = true
		st_hcpcs_title.visible = true
		st_controlled_substance_title.visible = true
		st_controlled_substance_flag.visible = true
		st_default_duration.visible = true
		u_default_duration.visible = true
END CHOOSE

st_common_name.text = st_drug_type.text + " Name"



end subroutine

public function integer add_hcpcs ();str_popup popup
str_popup_return popup_return
long ll_row
string ls_administer_unit
real lr_administer_amount
string ls_description
string ls_hcpcs_procedure_id

/* DECLARE lsp_new_drug_hcpcs PROCEDURE FOR dbo.sp_new_drug_hcpcs 
         @ps_drug_id = :drug.drug_id,   
         @pr_administer_amount = :lr_administer_amount,   
         @ps_administer_unit = :ls_administer_unit,   
         @ps_hcpcs_procedure_id = :ls_hcpcs_procedure_id;
*/
popup.title = sle_common_name.text
popup.data_row_count = 1
popup.items[1] = drug.drug_id
openwithparm(w_drug_hcpcs, popup)
popup_return = message.powerobjectparm

if popup_return.item_count <> 4 then return 0

lr_administer_amount = real(popup_return.items[1])
ls_administer_unit = popup_return.items[2]
ls_hcpcs_procedure_id = popup_return.items[3]
ls_description = popup_return.items[4]

sqlca.sp_new_drug_hcpcs(drug.drug_id,lr_administer_amount,ls_administer_unit,ls_hcpcs_procedure_id)

//EXECUTE lsp_new_drug_hcpcs;
if not tf_check() then return -1

dw_hcpcs.retrieve(drug.drug_id)

return 1



end function

public function integer load_drug (string ps_drug_id);//string ls_common_name
//string ls_generic_name
//real lr_default_duration_amount
//string ls_default_duration_unit
//string ls_default_duration_prn
//real lr_max_dose_per_day
//string ls_max_dose_unit
//string ls_drug_type
integer li_sts
str_patient_material lstr_patient_material

drug.drug_id = ps_drug_id

// we don't want a cached drug
drugdb.clear_cache()
li_sts = drugdb.get_drug_definition(ps_drug_id, drug)
if li_sts <= 0 then return -1


//SELECT	drug_type,
//			common_name,
//			generic_name,
//			default_duration_amount,
//			default_duration_unit,
//			default_duration_prn,
//			max_dose_per_day,
//			max_dose_unit,
//			controlled_substance_flag
//into	:ls_drug_type,
//		:ls_common_name,
//		:ls_generic_name,
//		:lr_default_duration_amount,
//		:ls_default_duration_unit,
//		:ls_default_duration_prn,
//		:lr_max_dose_per_day,
//		:ls_max_dose_unit,
//		:drug.controlled_substance_flag
//from c_drug_definition
//where drug_id = :drug.drug_id;
//if not tf_check() then return -1
//
st_drug_type.text = drug.drug_type

sle_common_name.text = drug.common_name
sle_generic_name.text = drug.generic_name

u_default_duration.set_amount(drug.default_duration_amount, drug.default_duration_unit, drug.default_duration_prn)

u_max_dose_per_day.text = string(drug.max_dose_per_day)

//drug.max_dose_unit = ls_max_dose_unit
//max_dose_unit = unit_list.find_unit(ls_max_dose_unit)
if isnull(drug.max_dose_unit) then
	st_max_dose_unit.text = ""
else
	st_max_dose_unit.text = unit_list.unit_description(drug.max_dose_unit)
end if

st_dea_schedule.text = drug.dea_schedule

if drug.controlled_substance_flag = "Y" then
	st_controlled_substance_flag.text = "Yes"
	st_dea_schedule.visible = true
	st_dea_schedule_title.visible = true
else
	drug.controlled_substance_flag = "N"
	st_controlled_substance_flag.text = "No"
	st_dea_schedule.visible = false
	st_dea_schedule_title.visible = false
end if


//sle_common_name.enabled = false
sle_generic_name.enabled = false
cb_common_list.visible = true
cb_categories.visible = true
new_drug = false

dw_constituents.retrieve(drug.drug_id)
dw_packages.retrieve(drug.drug_id)
dw_hcpcs.retrieve(drug.drug_id)
load_drug_admin()

lstr_patient_material = f_get_patient_material(drug.patient_reference_material_id, false)
if len(lstr_patient_material.title) > 0 then
	st_patient_reference_material.text = lstr_patient_material.title
else
	st_patient_reference_material.text = "N/A"
end if

lstr_patient_material = f_get_patient_material(drug.provider_reference_material_id, false)
if len(lstr_patient_material.title) > 0 then
	st_provider_reference_material.text = lstr_patient_material.title
else
	st_provider_reference_material.text = "N/A"
end if


set_screen()

return 1


end function

public subroutine count_common_list ();integer li_count
// Set the common lists button
SELECT count(*)
INTO :li_count
FROM c_Common_Drug
WHERE drug_id = :drug.drug_id;
if not tf_check() then return

if isnull(li_count) then li_count = 0

cb_common_list.text = "Specialty Lists (" + string(li_count) + ")"
if li_count <= 0 then
	cb_common_list.weight = 400
else
	cb_common_list.weight = 700
end if
end subroutine

public function integer new_drug ();integer li_sts
long ll_nextkey
string ls_null
u_unit luo_unit

setnull(ls_null)

setnull(drug.drug_id)
sle_common_name.text = drug.common_name
sle_generic_name.text = drug.generic_name

if drug.patient_reference_material_id = 0 then setnull(drug.patient_reference_material_id)
if drug.provider_reference_material_id = 0 then setnull(drug.provider_reference_material_id)
if drug.controlled_substance_flag = "" then setnull(drug.controlled_substance_flag)
if drug.dea_schedule = "" then setnull(drug.dea_schedule)
if drug.dea_number = "" then setnull(drug.dea_number)
if drug.dea_narcotic_status = "" then setnull(drug.dea_narcotic_status)

luo_unit = unit_list.find_unit(drug.max_dose_unit)
if isnull(luo_unit) then
	setnull(drug.max_dose_unit)
	u_max_dose_per_day.text = ""
	st_max_dose_unit.text = ""
else
	u_max_dose_per_day.text = luo_unit.pretty_amount(drug.max_dose_per_day)
	st_max_dose_unit.text = luo_unit.description
end if

st_dea_schedule.text = drug.dea_schedule
if drug.controlled_substance_flag = "Y" then
	st_controlled_substance_flag.text = "Yes"
	st_dea_schedule.visible = true
	st_dea_schedule_title.visible = true
else
	drug.controlled_substance_flag = "N"
	st_controlled_substance_flag.text = "No"
	st_dea_schedule.visible = false
	st_dea_schedule_title.visible = false
end if



sle_common_name.enabled = true
sle_generic_name.enabled = true

new_drug = true

if len(drug.drug_type) > 0 then
	st_drug_type.text = drug.drug_type
else
	st_drug_type.text = datalist.get_preference("PREFERENCES", "default_drug_type", "Single Drug")
end if

set_screen()

sle_common_name.setfocus()

return 1

end function

on w_drug_attributes.create
int iCurrent
call super::create
this.sle_common_name=create sle_common_name
this.st_common_name=create st_common_name
this.st_max_dose_unit=create st_max_dose_unit
this.st_dose_amount_title=create st_dose_amount_title
this.st_max_dose_unit_title=create st_max_dose_unit_title
this.sle_generic_name=create sle_generic_name
this.st_generic_name=create st_generic_name
this.cb_set_max_dose_amount=create cb_set_max_dose_amount
this.u_max_dose_per_day=create u_max_dose_per_day
this.st_controlled_substance_flag=create st_controlled_substance_flag
this.st_controlled_substance_title=create st_controlled_substance_title
this.dw_packages=create dw_packages
this.st_package_title=create st_package_title
this.dw_constituents=create dw_constituents
this.st_constituents_title=create st_constituents_title
this.dw_hcpcs=create dw_hcpcs
this.st_hcpcs_title=create st_hcpcs_title
this.st_default_duration=create st_default_duration
this.u_default_duration=create u_default_duration
this.dw_administration=create dw_administration
this.st_admin_title=create st_admin_title
this.cb_common_list=create cb_common_list
this.st_drug_type=create st_drug_type
this.st_drug_type_title=create st_drug_type_title
this.cb_categories=create cb_categories
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.st_patient_reference_material_title=create st_patient_reference_material_title
this.st_patient_reference_material=create st_patient_reference_material
this.st_provider_reference_material_title=create st_provider_reference_material_title
this.st_provider_reference_material=create st_provider_reference_material
this.st_1=create st_1
this.cb_1=create cb_1
this.st_dea_schedule=create st_dea_schedule
this.st_dea_schedule_title=create st_dea_schedule_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_common_name
this.Control[iCurrent+2]=this.st_common_name
this.Control[iCurrent+3]=this.st_max_dose_unit
this.Control[iCurrent+4]=this.st_dose_amount_title
this.Control[iCurrent+5]=this.st_max_dose_unit_title
this.Control[iCurrent+6]=this.sle_generic_name
this.Control[iCurrent+7]=this.st_generic_name
this.Control[iCurrent+8]=this.cb_set_max_dose_amount
this.Control[iCurrent+9]=this.u_max_dose_per_day
this.Control[iCurrent+10]=this.st_controlled_substance_flag
this.Control[iCurrent+11]=this.st_controlled_substance_title
this.Control[iCurrent+12]=this.dw_packages
this.Control[iCurrent+13]=this.st_package_title
this.Control[iCurrent+14]=this.dw_constituents
this.Control[iCurrent+15]=this.st_constituents_title
this.Control[iCurrent+16]=this.dw_hcpcs
this.Control[iCurrent+17]=this.st_hcpcs_title
this.Control[iCurrent+18]=this.st_default_duration
this.Control[iCurrent+19]=this.u_default_duration
this.Control[iCurrent+20]=this.dw_administration
this.Control[iCurrent+21]=this.st_admin_title
this.Control[iCurrent+22]=this.cb_common_list
this.Control[iCurrent+23]=this.st_drug_type
this.Control[iCurrent+24]=this.st_drug_type_title
this.Control[iCurrent+25]=this.cb_categories
this.Control[iCurrent+26]=this.cb_cancel
this.Control[iCurrent+27]=this.cb_ok
this.Control[iCurrent+28]=this.st_patient_reference_material_title
this.Control[iCurrent+29]=this.st_patient_reference_material
this.Control[iCurrent+30]=this.st_provider_reference_material_title
this.Control[iCurrent+31]=this.st_provider_reference_material
this.Control[iCurrent+32]=this.st_1
this.Control[iCurrent+33]=this.cb_1
this.Control[iCurrent+34]=this.st_dea_schedule
this.Control[iCurrent+35]=this.st_dea_schedule_title
end on

on w_drug_attributes.destroy
call super::destroy
destroy(this.sle_common_name)
destroy(this.st_common_name)
destroy(this.st_max_dose_unit)
destroy(this.st_dose_amount_title)
destroy(this.st_max_dose_unit_title)
destroy(this.sle_generic_name)
destroy(this.st_generic_name)
destroy(this.cb_set_max_dose_amount)
destroy(this.u_max_dose_per_day)
destroy(this.st_controlled_substance_flag)
destroy(this.st_controlled_substance_title)
destroy(this.dw_packages)
destroy(this.st_package_title)
destroy(this.dw_constituents)
destroy(this.st_constituents_title)
destroy(this.dw_hcpcs)
destroy(this.st_hcpcs_title)
destroy(this.st_default_duration)
destroy(this.u_default_duration)
destroy(this.dw_administration)
destroy(this.st_admin_title)
destroy(this.cb_common_list)
destroy(this.st_drug_type)
destroy(this.st_drug_type_title)
destroy(this.cb_categories)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.st_patient_reference_material_title)
destroy(this.st_patient_reference_material)
destroy(this.st_provider_reference_material_title)
destroy(this.st_provider_reference_material)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.st_dea_schedule)
destroy(this.st_dea_schedule_title)
end on

event open;call super::open;string ls_null
str_popup_return	popup_return
integer li_sts

setnull(ls_null)

drug = message.powerobjectparm

dw_constituents.settransobject(sqlca)
dw_packages.settransobject(sqlca)
dw_administration.settransobject(sqlca)
dw_hcpcs.settransobject(sqlca)

if len(drug.drug_id) > 0 then
	li_sts = load_drug(drug.drug_id)
	if li_sts <= 0 then
		popup_return.item_count = 0
		popup_return.item = ls_null
		Closewithreturn(this,popup_return)
	end if
else
	li_sts = new_drug()
	if li_sts <= 0 then
		popup_return.item_count = 0
		popup_return.item = ls_null
		Closewithreturn(this,popup_return)
	end if

	cb_common_list.visible = false
	cb_categories.visible = false
end if

if new_drug then
	cb_cancel.visible = true
else
	cb_cancel.visible = false
end if


end event

type pb_epro_help from w_window_base`pb_epro_help within w_drug_attributes
integer x = 2875
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_drug_attributes
integer x = 553
integer y = 1728
end type

type sle_common_name from singlelineedit within w_drug_attributes
integer x = 91
integer y = 108
integer width = 1495
integer height = 104
integer taborder = 10
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

event modified;drug.common_name = text

end event

type st_common_name from statictext within w_drug_attributes
integer x = 91
integer y = 36
integer width = 539
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Trade Name"
boolean focusrectangle = false
end type

type st_max_dose_unit from statictext within w_drug_attributes
integer x = 1262
integer y = 1588
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
	drug.max_dose_unit = popup_return.items[1]
	text = popup_return.descriptions[1]
end if


end event

type st_dose_amount_title from statictext within w_drug_attributes
integer x = 946
integer y = 1472
integer width = 293
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

type st_max_dose_unit_title from statictext within w_drug_attributes
integer x = 1083
integer y = 1588
integer width = 155
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

type sle_generic_name from singlelineedit within w_drug_attributes
integer x = 91
integer y = 312
integer width = 1495
integer height = 104
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean enabled = false
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event modified;drug.generic_name = text

end event

type st_generic_name from statictext within w_drug_attributes
integer x = 91
integer y = 236
integer width = 759
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Generic Name"
boolean focusrectangle = false
end type

type cb_set_max_dose_amount from commandbutton within w_drug_attributes
event clicked pbm_bnclicked
integer x = 1710
integer y = 1460
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
u_unit luo_unit

luo_unit = unit_list.find_unit(drug.max_dose_unit)

popup.realitem = real(u_max_dose_per_day.text)
popup.objectparm = luo_unit

openwithparm(w_number, popup)
popup_return = message.powerobjectparm

if isnull(luo_unit) then
	u_max_dose_per_day.text = string(popup_return.realitem)
else
	u_max_dose_per_day.text = luo_unit.pretty_amount(popup_return.realitem)
end if


end event

type u_max_dose_per_day from u_sle_real_number within w_drug_attributes
integer x = 1253
integer y = 1456
integer width = 439
integer height = 100
integer taborder = 30
boolean bringtotop = true
end type

event first_value;call super::first_value;
if isnull(drug.max_dose_unit) or drug.max_dose_unit = "" then
	drug.max_dose_unit = "MG"
	st_max_dose_unit.text = unit_list.unit_description(drug.max_dose_unit)
end if

end event

type st_controlled_substance_flag from statictext within w_drug_attributes
integer x = 2619
integer y = 152
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

event clicked;if drug.controlled_substance_flag = "Y" then
	drug.controlled_substance_flag = "N"
	text = "No"
	st_dea_schedule.visible = false
	st_dea_schedule_title.visible = false
else
	drug.controlled_substance_flag = "Y"
	text = "Yes"
	st_dea_schedule.visible = true
	st_dea_schedule_title.visible = true
end if



end event

type st_controlled_substance_title from statictext within w_drug_attributes
integer x = 2551
integer y = 12
integer width = 352
integer height = 128
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Controlled Substance"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_packages from u_dw_pick_list within w_drug_attributes
integer x = 64
integer y = 548
integer width = 818
integer height = 732
integer taborder = 100
boolean bringtotop = true
string dataobject = "dw_drug_package_display_list"
borderstyle borderstyle = styleraised!
end type

event clicked;call super::clicked;str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons

if new_drug then
	li_sts = save_new_drug()
	if li_sts <= 0 then return
end if


if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Add Package"
	popup.button_titles[popup.button_count] = "Add Package"
	buttons[popup.button_count] = "ADD"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Edit Package"
	popup.button_titles[popup.button_count] = "Edit Package"
	buttons[popup.button_count] = "EDIT"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Remove Package"
	popup.button_titles[popup.button_count] = "Remove Package"
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
		li_sts = add_package()
	CASE "EDIT"
		li_sts = edit_package()
	CASE "REMOVE"
		li_sts = remove_package()
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return

end event

type st_package_title from statictext within w_drug_attributes
integer x = 82
integer y = 456
integer width = 818
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Packages"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_constituents from u_dw_pick_list within w_drug_attributes
integer x = 2016
integer y = 1028
integer width = 818
integer height = 372
integer taborder = 90
boolean bringtotop = true
string dataobject = "dw_drug_constituents_small"
borderstyle borderstyle = styleraised!
end type

event clicked;call super::clicked;str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons

if new_drug then
	li_sts = save_new_drug()
	if li_sts <= 0 then return
end if


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

dw_constituents.retrieve(drug.drug_id)

return

end event

type st_constituents_title from statictext within w_drug_attributes
integer x = 2007
integer y = 956
integer width = 818
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Constituents"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_hcpcs from u_dw_pick_list within w_drug_attributes
integer x = 2011
integer y = 532
integer width = 818
integer height = 400
integer taborder = 120
boolean bringtotop = true
string dataobject = "dw_drug_hcpcs_display_list"
borderstyle borderstyle = styleraised!
end type

event clicked;call super::clicked;str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons

if new_drug then
	li_sts = save_new_drug()
	if li_sts <= 0 then return
end if


if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Add HCPCS"
	popup.button_titles[popup.button_count] = "Add HCPCS"
	buttons[popup.button_count] = "ADD"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Remove HCPCS"
	popup.button_titles[popup.button_count] = "Remove HCPCS"
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
		li_sts = add_hcpcs()
	CASE "REMOVE"
		li_sts = remove_hcpcs()
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return

end event

type st_hcpcs_title from statictext within w_drug_attributes
integer x = 1998
integer y = 452
integer width = 818
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "HCPCS"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_default_duration from statictext within w_drug_attributes
integer x = 1897
integer y = 248
integer width = 553
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Default Duration"
boolean focusrectangle = false
end type

type u_default_duration from u_duration_amount within w_drug_attributes
integer x = 1897
integer y = 316
integer width = 608
integer height = 104
integer taborder = 70
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
end type

event clicked;call super::clicked;drug.default_duration_amount = amount
drug.default_duration_unit = unit
drug.default_duration_prn = prn

end event

type dw_administration from u_dw_pick_list within w_drug_attributes
integer x = 1051
integer y = 540
integer width = 818
integer height = 732
integer taborder = 110
boolean bringtotop = true
string dataobject = "dw_drug_admin_display_list"
borderstyle borderstyle = styleraised!
end type

event clicked;call super::clicked;str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons

if new_drug then
	li_sts = save_new_drug()
	if li_sts <= 0 then return
end if


if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Add Administration Rule"
	popup.button_titles[popup.button_count] = "Add Admin"
	buttons[popup.button_count] = "ADD"
end if

//if true then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button17.bmp"
//	popup.button_helps[popup.button_count] = "Edit Administration Rule"
//	popup.button_titles[popup.button_count] = "Edit Admin"
//	buttons[popup.button_count] = "EDIT"
//end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Remove Administration Rule"
	popup.button_titles[popup.button_count] = "Remove Admin"
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
		li_sts = add_admin()
	CASE "EDIT"
		li_sts = edit_admin()
	CASE "REMOVE"
		li_sts = remove_admin()
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return

end event

type st_admin_title from statictext within w_drug_attributes
integer x = 1051
integer y = 468
integer width = 818
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Administration Rules"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_common_list from commandbutton within w_drug_attributes
integer x = 2117
integer y = 1552
integer width = 622
integer height = 104
integer taborder = 130
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Specialty List"
end type

event clicked;str_popup popup

popup.title = sle_common_name.text
popup.items[1] = "Drug" // common list context
popup.items[2] = drug.drug_id // common list id
popup.data_row_count = 2

openwithparm(w_specialty_common_lists, popup)
count_common_list()
end event

type st_drug_type from statictext within w_drug_attributes
integer x = 1897
integer y = 116
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
string text = "Single Drug"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
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

drug.drug_type = popup_return.items[1]
text = drug.drug_type

set_screen()

end event

type st_drug_type_title from statictext within w_drug_attributes
integer x = 1897
integer y = 40
integer width = 352
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Drug Type"
boolean focusrectangle = false
end type

type cb_categories from commandbutton within w_drug_attributes
integer x = 2121
integer y = 1428
integer width = 622
integer height = 104
integer taborder = 140
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Categories"
end type

event clicked;str_popup popup

popup.title = sle_common_name.text
popup.item = drug.drug_id 

openwithparm(w_drug_category_common_lists, popup)
count_drug_categories()
end event

type cb_cancel from commandbutton within w_drug_attributes
integer x = 78
integer y = 1680
integer width = 402
integer height = 112
integer taborder = 50
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

event clicked;string ls_null
str_popup_return	popup_return

setnull(ls_null)
popup_return.item_count = 0
popup_return.item = ls_null
Closewithreturn(parent,popup_return)

end event

type cb_ok from commandbutton within w_drug_attributes
integer x = 2450
integer y = 1680
integer width = 402
integer height = 112
integer taborder = 60
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

event clicked;str_popup_return 	popup_return
integer li_sts

if isnull(sle_common_name.text) or trim(sle_common_name.text) = "" then
	openwithparm(w_pop_message, "You must enter a common name")
	return 0
end if

if len(drug.max_dose_unit) > 0 then
	drug.max_dose_per_day = real(u_max_dose_per_day.text)
else
	setnull(drug.max_dose_per_day)
	setnull(drug.max_dose_unit)
end if

if new_drug then
	li_sts = save_new_drug()
	if li_sts <= 0 then
		openwithparm(w_pop_message, "Error saving new drug definition")
		return
	end if
else
	li_sts = drugdb.update_drug(drug)
	if li_sts <= 0 then
		openwithparm(w_pop_message, "Error updating drug definition")
		return
	end if
end if

// define treatment of officemed trt, we now have the ability to create new drugs
// so return the drug created so that it can be shown in selected items list
popup_return.item_count = 1
popup_return.items[1] = sle_common_name.text
popup_return.item = drug.drug_id

Closewithreturn(parent,popup_return)

end event

type st_patient_reference_material_title from statictext within w_drug_attributes
integer x = 69
integer y = 1300
integer width = 791
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Patient Reference Material"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_patient_reference_material from statictext within w_drug_attributes
integer x = 69
integer y = 1376
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

if drug.patient_reference_material_id > 0 then
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
		f_display_patient_material(drug.patient_reference_material_id)
	CASE 2
		open(lw_pick, "w_pick_patient_material")
		ll_material_id = message.doubleparm
		if ll_material_id <= 0 then return
		
		lstr_patient_material = f_get_patient_material(ll_material_id, false)
		if lstr_patient_material.material_id > 0 then
			drug.patient_reference_material_id = lstr_patient_material.material_id
			text = lstr_patient_material.title
		end if
	CASE 3
		setnull(drug.patient_reference_material_id)
		text = "N/A"
END CHOOSE




end event

type st_provider_reference_material_title from statictext within w_drug_attributes
integer x = 46
integer y = 1480
integer width = 832
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Provider Reference Material"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_provider_reference_material from statictext within w_drug_attributes
integer x = 69
integer y = 1556
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

if drug.provider_reference_material_id > 0 then
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
		f_display_patient_material(drug.provider_reference_material_id)
	CASE 2
		open(lw_pick, "w_pick_patient_material")
		ll_material_id = message.doubleparm
		if ll_material_id <= 0 then return
		
		lstr_patient_material = f_get_patient_material(ll_material_id, false)
		if lstr_patient_material.material_id > 0 then
			drug.provider_reference_material_id = lstr_patient_material.material_id
			text = lstr_patient_material.title
		end if
	CASE 3
		setnull(drug.provider_reference_material_id)
		text = "N/A"
END CHOOSE




end event

type st_1 from statictext within w_drug_attributes
integer x = 1106
integer y = 1364
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
long backcolor = 33538240
boolean enabled = false
string text = "Max Calculated Dose"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_drug_attributes
integer x = 1609
integer y = 352
integer width = 219
integer height = 68
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Codes"
end type

type st_dea_schedule from statictext within w_drug_attributes
integer x = 2619
integer y = 340
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

drug.dea_schedule = popup_return.items[1]
text = drug.dea_schedule

end event

type st_dea_schedule_title from statictext within w_drug_attributes
integer x = 2551
integer y = 264
integer width = 352
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Schedule"
alignment alignment = center!
boolean focusrectangle = false
end type

