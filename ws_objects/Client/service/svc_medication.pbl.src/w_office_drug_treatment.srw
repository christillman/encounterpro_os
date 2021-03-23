$PBExportHeader$w_office_drug_treatment.srw
forward
global type w_office_drug_treatment from w_window_base
end type
type st_display_only from statictext within w_office_drug_treatment
end type
type st_hcpcs_procedure from statictext within w_office_drug_treatment
end type
type st_mult_display from statictext within w_office_drug_treatment
end type
type uo_drug_administration from u_drug_administration within w_office_drug_treatment
end type
type uo_drug_package from u_drug_package within w_office_drug_treatment
end type
type st_procedure from statictext within w_office_drug_treatment
end type
type uo_procedure from u_admin_method_procedure within w_office_drug_treatment
end type
type st_dosebase from statictext within w_office_drug_treatment
end type
type uo_dose from u_dose_amount within w_office_drug_treatment
end type
type st_method_description from statictext within w_office_drug_treatment
end type
type st_drug from statictext within w_office_drug_treatment
end type
type uo_hcpcs_procedure from u_hcpcs_procedure within w_office_drug_treatment
end type
type st_cocktail_title from statictext within w_office_drug_treatment
end type
type dw_cocktail from datawindow within w_office_drug_treatment
end type
type st_dose from statictext within w_office_drug_treatment
end type
type st_package from statictext within w_office_drug_treatment
end type
type st_1 from statictext within w_office_drug_treatment
end type
type cb_be_back from commandbutton within w_office_drug_treatment
end type
type cb_done from commandbutton within w_office_drug_treatment
end type
type cb_cancel from commandbutton within w_office_drug_treatment
end type
end forward

global type w_office_drug_treatment from w_window_base
windowtype windowtype = response!
string button_type = "COMMAND"
event post_open pbm_custom01
st_display_only st_display_only
st_hcpcs_procedure st_hcpcs_procedure
st_mult_display st_mult_display
uo_drug_administration uo_drug_administration
uo_drug_package uo_drug_package
st_procedure st_procedure
uo_procedure uo_procedure
st_dosebase st_dosebase
uo_dose uo_dose
st_method_description st_method_description
st_drug st_drug
uo_hcpcs_procedure uo_hcpcs_procedure
st_cocktail_title st_cocktail_title
dw_cocktail dw_cocktail
st_dose st_dose
st_package st_package
st_1 st_1
cb_be_back cb_be_back
cb_done cb_done
cb_cancel cb_cancel
end type
global w_office_drug_treatment w_office_drug_treatment

type variables
string param_class

string drug_id

real default_duration_amount
string default_duration_unit
string default_duration_prn
real max_dose_per_day
u_unit max_dose_unit
integer refills = 0

string prev_instructions
string instructions

integer package_list_index = 0
integer drug_admin_index = 0
integer last_package_list_index = 0

long problem_id
long treatment_id
long treatment_sequence

u_component_treatment treat_officemed
u_component_service	 service

str_encounter_charge hcpcs_charge
str_encounter_charge admin_charge

str_drug_definition drug_definition

boolean package_selected
boolean display_only = false


end variables

forward prototypes
public subroutine recalcdose ()
public subroutine recalcdose_old ()
public function integer load_defaults ()
public function integer set_hcpcs ()
public function integer select_best_package (string ps_dosage_form)
public function integer administer_amount (ref real pr_amount, ref string ps_unit)
public function integer set_drug ()
public subroutine load_officemed ()
public function integer display_cocktail ()
public function integer add_cocktail ()
public function integer remove_cocktail ()
public function integer save_changes ()
end prototypes

event post_open;Integer              li_sts,li_charge_count
String               ls_null

Setnull(ls_null)

drug_id = treat_officemed.drug_id
li_sts = set_drug()
If li_sts <= 0 Then 
	Close(This)
	Return
End if

if lower(drug_definition.drug_type) <> "cocktail" then
	If Len(treat_officemed.package_id) = 0 Or &
			isnull(treat_officemed.package_id) Then
		load_defaults()
	Else
		load_officemed()
	End if
end if

uo_hcpcs_procedure.visible = True
st_hcpcs_procedure.visible = True


end event

public subroutine recalcdose ();integer i, j
real lr_dose_amount

if drug_admin_index > 0 and package_list_index > 0 then
	i = package_list_index
	j = drug_admin_index
	uo_dose.calc_dose_amount(	uo_drug_administration.administer_amount[j], &
										uo_drug_administration.administer_unit[j], &
										uo_drug_package.pkg_administer_unit[i], &
										uo_drug_administration.mult_by_what[j], &
										uo_drug_administration.calc_per[j], &
										uo_drug_administration.daily_frequency[j], &
										uo_drug_package.administer_per_dose[i], &
										uo_drug_package.dose_amount[i], &
										uo_drug_package.dose_unit[i], &
										max_dose_per_day, &
										max_dose_unit, &
										st_mult_display.text, &
										lr_dose_amount)
	uo_dose.set_amount(lr_dose_amount, uo_drug_package.dose_unit[package_list_index])
elseif package_list_index > 0 then
	i = package_list_index
	if isnull(uo_dose.amount) or uo_dose.amount <= 0 then
		uo_dose.set_amount(1, uo_drug_package.dose_unit[i])
	elseif last_package_list_index > 0 then
		j = last_package_list_index
		uo_dose.convert_dose_amount(uo_drug_package.pkg_administer_unit[j], &
											uo_drug_package.administer_per_dose[j], &
											uo_drug_package.dose_unit[j], &
											uo_drug_package.pkg_administer_unit[i], &
											uo_drug_package.administer_per_dose[i], &
											uo_drug_package.dose_amount[i], &
											uo_drug_package.dose_unit[i] )
	end if
end if

if isnull(hcpcs_charge.encounter_charge_id) then set_hcpcs()

end subroutine

public subroutine recalcdose_old ();//integer i, j, li_sts
//
//if package_list_index = 0 then return
//
//i = package_list_index
//j = drug_admin_index
//if j > 0 then
//		uo_dose.calc_dose_amount(	uo_drug_administration.administer_amount[j], &
//											uo_drug_administration.administer_unit[j], &
//											uo_drug_package.pkg_administer_unit[i], &
//											uo_drug_administration.mult_by_what[j], &
//											uo_drug_administration.calc_per[j], &
//											uo_drug_administration.daily_frequency[j], &
//											uo_drug_package.administer_per_dose[i], &
//											uo_drug_package.dose_amount[i], &
//											uo_drug_package.dose_unit[i], &
//											max_dose_per_day, &
//											max_dose_unit, &
//											st_mult_display.text )
//else
//	if last_package_list_index > 0 then
//		j = last_package_list_index
//		li_sts = uo_dose.convert_dose_amount(uo_drug_package.pkg_administer_unit[j], &
//											uo_drug_package.administer_per_dose[j], &
//											uo_drug_package.dose_unit[j], &
//											uo_drug_package.pkg_administer_unit[i], &
//											uo_drug_package.administer_per_dose[i], &
//											uo_drug_package.dose_amount[i], &
//											uo_drug_package.dose_unit[i] )
//		if li_sts <= 0 then uo_dose.set_amount(1, uo_drug_package.dose_unit[i])
//	else
//		uo_dose.set_amount(1, uo_drug_package.dose_unit[i])
//	end if
//end if
//
//
end subroutine

public function integer load_defaults ();integer i, li_sts
string ls_null

setnull(ls_null)

package_selected = false
package_list_index = 0
drug_admin_index = 0

if isnull(treat_officemed.administration_sequence) then
	if not isnull(treat_officemed.dosage_form) then
		// Set the package from the dosage form and pick a compatible administration
		package_list_index = uo_drug_package.selectdosageform(treat_officemed.dosage_form)
		if package_list_index > 0 then
			drug_admin_index = uo_drug_administration.select_first_compatible(uo_drug_package.pkg_administer_unit[package_list_index])
		end if
	else
		// No dosage form supplied, so look for the first
		// package which has a compatible administration
		for i = 1 to uo_drug_package.package_count
			drug_admin_index = uo_drug_administration.select_first_compatible(uo_drug_package.pkg_administer_unit[i])
			if drug_admin_index > 0 then
				package_list_index = uo_drug_package.selectpackage(uo_drug_package.package_id[i])
				exit
			end if
		next
		// If there are no packages with compatible administrations, just pick the first
		if package_list_index <= 0 then
			package_list_index = uo_drug_package.selectpackage(uo_drug_package.package_id[1])
		end if
	end if
else
	drug_admin_index = uo_drug_administration.selectadminsequence(treat_officemed.administration_sequence)
	package_list_index = select_best_package(treat_officemed.dosage_form)
	uo_drug_package.selectitem(package_list_index)
end if

if package_list_index = 0 then
	uo_drug_package.selectpackage("")
end if

if drug_admin_index = 0 then
	uo_drug_administration.selectadminsequence(0)
end if

uo_procedure.set_value(ls_null)
setnull(admin_charge.encounter_charge_id)

uo_drug_administration.triggerevent("newadmin")
uo_drug_package.triggerevent("newpackage")

uo_hcpcs_procedure.set_value(ls_null)
setnull(hcpcs_charge.encounter_charge_id)

recalcdose()

refills = 0

return 1

end function

public function integer set_hcpcs ();integer li_sts
real lr_administer_amount
string ls_administer_unit


li_sts = administer_amount(lr_administer_amount, ls_administer_unit)
if li_sts <= 0 then return li_sts

uo_hcpcs_procedure.set_value(lr_administer_amount, ls_administer_unit)


return li_sts

end function

public function integer select_best_package (string ps_dosage_form);integer i, j, li_best_package, li_first, li_last
real lr_best_amount, lr_dose_amount
string ls_dosage_form

setnull(lr_best_amount)
li_best_package = 0

// If there is no admin selected, then we can't find a best package
if drug_admin_index <= 0 then return 0

j = drug_admin_index

// Now loop through all the packages and calculate the dose for each one
// which matches the specified dosage form
for i = 1 to uo_drug_package.package_count
	if lower(uo_drug_package.dosage_form[i]) <> lower(ps_dosage_form) then continue
	uo_dose.calc_dose_amount(	uo_drug_administration.administer_amount[j], &
										uo_drug_administration.administer_unit[j], &
										uo_drug_package.pkg_administer_unit[i], &
										uo_drug_administration.mult_by_what[j], &
										uo_drug_administration.calc_per[j], &
										uo_drug_administration.daily_frequency[j], &
										uo_drug_package.administer_per_dose[i], &
										uo_drug_package.dose_amount[i], &
										uo_drug_package.dose_unit[i], &
										max_dose_per_day, &
										max_dose_unit, &
										st_mult_display.text, &
										lr_dose_amount)
	if isnull(lr_best_amount) then
		lr_best_amount = lr_dose_amount
		li_best_package = i
	elseif abs(lr_dose_amount - 1) < abs(lr_best_amount - 1) then
		lr_best_amount = lr_dose_amount
		li_best_package = i
	end if
next

return li_best_package


end function

public function integer administer_amount (ref real pr_amount, ref string ps_unit);real lr_dose_amount, lr_administer_per_dose
string ls_pkg_administer_unit
integer li_sts

if package_list_index = 0 then return 0

// First, convert the dose unit to the package dose unit

li_sts = f_unit_convert(uo_dose.amount, uo_dose.unit, uo_drug_package.dose_unit[package_list_index], lr_dose_amount)
if li_sts <= 0 then return li_sts

// Next, divide the dose amount by the package dose unit

lr_dose_amount = lr_dose_amount / uo_drug_package.dose_amount[package_list_index]

// Next, multiply by the amount of administer unit per dose unit

lr_dose_amount = lr_dose_amount * uo_drug_package.administer_per_dose[package_list_index]

// Finally, set the return params

pr_amount = lr_dose_amount
ps_unit = uo_drug_package.pkg_administer_unit[package_list_index]

return 1

end function

public function integer set_drug ();integer li_count, i, j, li_sts
string ls_null
setnull(ls_null)

// Get the name and default duration
st_drug.text = drug_definition.common_name
default_duration_amount = drug_definition.default_duration_amount
default_duration_unit = drug_definition.default_duration_unit
default_duration_prn = drug_definition.default_duration_prn
max_dose_per_day = drug_definition.max_dose_per_day
max_dose_unit = unit_list.find_unit(drug_definition.max_dose_unit)

if lower(drug_definition.drug_type) = "cocktail" then
	uo_dose.visible = false
	uo_drug_package.visible = false
	st_method_description.visible = false
	st_dosebase.visible = false
	uo_drug_administration.visible = false
	dw_cocktail.visible = true
	st_cocktail_title.visible = true
	display_cocktail()
else
	uo_dose.visible = true
	uo_drug_package.visible = true
	st_method_description.visible = true
	st_dosebase.visible = true
	uo_drug_administration.visible = true
	dw_cocktail.visible = false
	st_cocktail_title.visible = false
	
	// Get the package list for this drug
	li_count = uo_drug_package.retrieve(drug_id)
	if li_count <= 0 then
		messagebox("w_drug_treatment-set_drug()","This drug (" + st_drug.text + ") has no packages defined.")
		return -1
	end if
	
	// Get the admin list for this drug
	li_count = uo_drug_administration.retrieve(drug_id, "DOSE")
	
	last_package_list_index = 0
end if


uo_hcpcs_procedure.initialize(drug_id)


// Check for display-only condition
//	 or current_user.check_drug(drug_id) <= 0 &
If Not isnull(treat_officemed.end_date) &
	 Or isnull(current_patient.open_encounter) Then
	st_display_only.visible = True
	uo_dose.enabled = False
	uo_drug_administration.enabled = False
	uo_drug_package.enabled = False
	uo_hcpcs_procedure.enabled = False
	uo_procedure.enabled = False
	cb_cancel.visible = false
	display_only = true
Else
	st_display_only.visible = False
	uo_dose.enabled = True
	uo_drug_administration.enabled = True
	uo_drug_package.enabled = True
	uo_hcpcs_procedure.enabled = True
	uo_procedure.enabled = True
	cb_cancel.visible = true
	display_only = false
End If

Return 1
end function

public subroutine load_officemed ();integer li_count, i, j, li_sts
string ls_null
integer li_charge_count
str_encounter_charge lstra_charges[]

setnull(ls_null)

// Set the package
if isnull(treat_officemed.package_id) then
	if isnull(treat_officemed.dosage_form) then
		package_list_index = uo_drug_package.selectpackage(uo_drug_package.package_id[1])
	else
		package_list_index = uo_drug_package.selectdosageform(treat_officemed.dosage_form)
	end if
else
	package_list_index = uo_drug_package.selectpackage(treat_officemed.package_id)
	if package_list_index = 0 then
		messagebox("Drug Treatment", "Package ID " + treat_officemed.package_id + " is not available for this drug." )
		package_list_index = uo_drug_package.selectpackage(uo_drug_package.package_id[1])
	end if
end if

uo_drug_package.triggerevent("newpackage")

// If there is no dose amount, then set the drug administration to the one specified
// in the officemed object.
if isnull(treat_officemed.dose_amount) then
	drug_admin_index = uo_drug_administration.selectadminsequence(treat_officemed.administration_sequence)
	uo_drug_administration.triggerevent("newadmin")
else
	// If there is a dose amount then load it.
	uo_dose.set_amount(treat_officemed.dose_amount, uo_drug_package.dose_unit[package_list_index])
end if

li_charge_count = treat_officemed.get_charges("DRUGHCPCS", lstra_charges)
if li_charge_count < 0 then
	log.log(this, "w_office_drug_treatment.load_officemed:0037", "Error getting hcpcs charges", 4)
	uo_hcpcs_procedure.set_value(ls_null)
	setnull(hcpcs_charge.encounter_charge_id)
elseif li_charge_count = 0 then
	uo_hcpcs_procedure.set_value(ls_null)
	setnull(hcpcs_charge.encounter_charge_id)
else
	if li_charge_count > 0 then
		log.log(this, "w_office_drug_treatment.load_officemed:0045", "Multiple hcpcs charges", 3)
	end if
	hcpcs_charge = lstra_charges[1]
	uo_hcpcs_procedure.set_value(hcpcs_charge.procedure_id, hcpcs_charge.description)
end if

li_charge_count = treat_officemed.get_charges("DRUGADMIN", lstra_charges)
if li_charge_count < 0 then
	log.log(this, "w_office_drug_treatment.load_officemed:0053", "Error getting admin charges", 4)
	uo_procedure.set_value(ls_null)
	setnull(admin_charge.encounter_charge_id)
elseif li_charge_count = 0 then
	uo_procedure.set_value(ls_null)
	setnull(admin_charge.encounter_charge_id)
else
	if li_charge_count > 0 then
		log.log(this, "w_office_drug_treatment.load_officemed:0061", "Multiple admin charges", 3)
	end if
	admin_charge = lstra_charges[1]
	uo_procedure.set_value(admin_charge.procedure_id, admin_charge.description)
end if

recalcdose()



end subroutine

public function integer display_cocktail ();str_progress_list lstr_progress
integer i
long ll_row
string ls_progress_key

setnull(ls_progress_key)

dw_cocktail.reset()

lstr_progress = f_get_progress(current_patient.cpr_id, &
										"Treatment", &
										treat_officemed.treatment_id, &
										"Cocktail", &
										ls_progress_key)

for i = 1 to lstr_progress.progress_count
	ll_row = dw_cocktail.insertrow(0)
	dw_cocktail.object.description[ll_row] = lstr_progress.progress[i].progress_full_description
next

return 1

end function

public function integer add_cocktail ();str_popup popup
str_popup_return popup_return
string ls_progress_type
string ls_progress_key
long ll_row
long i
u_unit luo_unit
string ls_value
str_picked_drugs lstr_drugs
Datetime ldt_begin_date
Date		ld_begin_date
Integer	li_count,li_administration_sequence
String	ls_temp
String	ls_admin_description,ls_administer_unit
String	ls_description,ls_dosage_form,ls_package_id
string ls_specific_code
string ls_generic_code
string lsa_unit_id[]
string lsa_description[]
string ls_unit
str_amount_unit lstr_amount_unit
string ls_constituent_drug_id

ls_progress_type = "Cocktail"

// Pick which drug
popup.dataobject = "dw_drug_constituents_pick"
popup.displaycolumn = 3
popup.datacolumn = 2
popup.argument_count = 1
popup.argument[1] = drug_id
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

ls_constituent_drug_id = popup_return.items[1]


// Get the drug amount
li_count = f_get_drug_administer_unit(ls_constituent_drug_id, "DOSE", lsa_unit_id, lsa_description)
if li_count < 0 then return 0

// If we didn't find a "DOSE" admin rule then just get all admin units
if li_count = 0 then li_count = f_get_drug_administer_unit(ls_constituent_drug_id, "%", lsa_unit_id, lsa_description)
if li_count < 0 then return -1

if li_count = 0 then
	log.log(this, "w_office_drug_treatment.add_cocktail:0048", "Unable to get drug administrations (" + ls_constituent_drug_id + ")", 4)
	openwithparm(w_pop_message, "No administration rules for this drug")
	return 0
elseif li_count = 1 then
	ls_administer_unit = lsa_unit_id[1]
else
	popup.data_row_count = li_count
	for i = 1 to li_count
		popup.items = lsa_description
	next
	openwithparm(w_pop_pick, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count = 1 then
		ls_administer_unit = lsa_unit_id[popup_return.item_indexes[1]]
	else
		return 0
	end if
end if

ls_specific_code = "CocktailDrug" + "|" + ls_constituent_drug_id
setnull(ls_generic_code)

luo_unit = unit_list.find_unit(ls_administer_unit)
if isnull(luo_unit) then
	log.log(this, "w_office_drug_treatment.add_cocktail:0072", "Invalid admin unit (" + ls_administer_unit + ")", 4)
	return 0
end if

lstr_amount_unit = luo_unit.get_value_and_unit("", ls_specific_code, ls_generic_code, true)
if len(lstr_amount_unit.amount) > 0 and len(lstr_amount_unit.unit) > 0 then
	ls_value = lstr_amount_unit.amount + " " + lstr_amount_unit.unit
else
	return 0
end if

// Post the drug w/ amount
treat_officemed.set_progress_key(ls_progress_type, ls_constituent_drug_id, ls_value)

display_cocktail()

return 1

end function

public function integer remove_cocktail ();str_progress_list lstr_progress
integer i
long ll_row
str_popup popup
str_popup_return popup_return
string ls_progress_key

setnull(ls_progress_key)
lstr_progress = f_get_progress(current_patient.cpr_id, &
										"Treatment", &
										treat_officemed.treatment_id, &
										"Cocktail", &
										ls_progress_key)

popup.data_row_count = lstr_progress.progress_count
popup.multiselect = true
for i = 1 to lstr_progress.progress_count
	popup.items[i] = lstr_progress.progress[i].progress_full_description
next
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <= 0 then return 0

for i = 1 to popup_return.item_count
	ls_progress_key = lstr_progress.progress[popup_return.item_indexes[i]].progress_key
	treat_officemed.unset_progress_key("Cocktail", ls_progress_key)
next

display_cocktail()

return 1

end function

public function integer save_changes ();String	ls_description
Integer	li_sts
str_attributes lstr_attributes
string ls_null
long ll_old_treatment_id

setnull(ls_null)

lstr_attributes.attribute_count = 0

lstr_attributes.attribute_count += 1
lstr_attributes.attribute[lstr_attributes.attribute_count].attribute = "package_id"
If package_list_index > 0 Then
	lstr_attributes.attribute[lstr_attributes.attribute_count].value = uo_drug_package.package_id[package_list_index]
else
	lstr_attributes.attribute[lstr_attributes.attribute_count].value = ls_null
End if

lstr_attributes.attribute_count += 1
lstr_attributes.attribute[lstr_attributes.attribute_count].attribute = "dose_amount"
if uo_dose.amount <= 0 or isnull(uo_dose.unit) then
	lstr_attributes.attribute[lstr_attributes.attribute_count].value = ls_null
else
	lstr_attributes.attribute[lstr_attributes.attribute_count].value = String(uo_dose.amount)
end if

lstr_attributes.attribute_count += 1
lstr_attributes.attribute[lstr_attributes.attribute_count].attribute = "dose_unit"
lstr_attributes.attribute[lstr_attributes.attribute_count].value = uo_dose.unit

// First map the attributes to data columns
treat_officemed.updated = false
treat_officemed.map_attr_to_data_columns(lstr_attributes)

// If the updated flad is true then something changed and we have to update the treatment
ll_old_treatment_id = treat_officemed.treatment_id
if treat_officemed.updated then
	treat_officemed.treatment_description = f_medication_description(treat_officemed)
	li_sts = current_patient.treatments.update_treatment(treat_officemed)
end if

If len(uo_hcpcs_procedure.procedure_id) > 0 Then
	sqlca.sp_add_encounter_charge( current_patient.cpr_id, &
								current_patient.open_encounter_id, &
								uo_hcpcs_procedure.procedure_id, &
								treat_officemed.treatment_id, &
								current_scribe.user_id, &
								"Y")
	if not tf_check() then return -1
end if

If len(uo_procedure.procedure_id) > 0 Then
	sqlca.sp_add_encounter_charge( current_patient.cpr_id, &
								current_patient.open_encounter_id, &
								uo_procedure.procedure_id, &
								treat_officemed.treatment_id, &
								current_scribe.user_id, &
								"Y")
	if not tf_check() then return -1
end if

// Update patient instructions
If prev_instructions <> instructions &
	OR (isnull(prev_instructions) And Not isnull(instructions)) &
	 OR (isnull(instructions) And Not isnull(prev_instructions)) Then
	treat_officemed.set_progress("Instructions", instructions)
End If


return 1




end function

event open;call super::open;string ls_temp
integer li_sts
long ll_menu_id

service = Message.Powerobjectparm
treat_officemed = service.treatment
ls_temp = f_get_global_preference("PREFERENCES", "bill_officemed_administration")
if f_string_to_boolean(ls_temp) then
	st_procedure.visible = true
	uo_procedure.visible = true
else
	st_procedure.visible = false
	uo_procedure.visible = false
end if

title = current_patient.id_line()

li_sts = drugdb.get_drug_definition(treat_officemed.drug_id, drug_definition)


// Don't offer the "I'll Be Back" option for manual services
max_buttons = 2
if service.manual_service then
	cb_be_back.visible = false
	max_buttons = 3
end if

ll_menu_id = long(service.get_attribute("menu_id"))
paint_menu(ll_menu_id)


postevent("post_open")
end event

on w_office_drug_treatment.create
int iCurrent
call super::create
this.st_display_only=create st_display_only
this.st_hcpcs_procedure=create st_hcpcs_procedure
this.st_mult_display=create st_mult_display
this.uo_drug_administration=create uo_drug_administration
this.uo_drug_package=create uo_drug_package
this.st_procedure=create st_procedure
this.uo_procedure=create uo_procedure
this.st_dosebase=create st_dosebase
this.uo_dose=create uo_dose
this.st_method_description=create st_method_description
this.st_drug=create st_drug
this.uo_hcpcs_procedure=create uo_hcpcs_procedure
this.st_cocktail_title=create st_cocktail_title
this.dw_cocktail=create dw_cocktail
this.st_dose=create st_dose
this.st_package=create st_package
this.st_1=create st_1
this.cb_be_back=create cb_be_back
this.cb_done=create cb_done
this.cb_cancel=create cb_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_display_only
this.Control[iCurrent+2]=this.st_hcpcs_procedure
this.Control[iCurrent+3]=this.st_mult_display
this.Control[iCurrent+4]=this.uo_drug_administration
this.Control[iCurrent+5]=this.uo_drug_package
this.Control[iCurrent+6]=this.st_procedure
this.Control[iCurrent+7]=this.uo_procedure
this.Control[iCurrent+8]=this.st_dosebase
this.Control[iCurrent+9]=this.uo_dose
this.Control[iCurrent+10]=this.st_method_description
this.Control[iCurrent+11]=this.st_drug
this.Control[iCurrent+12]=this.uo_hcpcs_procedure
this.Control[iCurrent+13]=this.st_cocktail_title
this.Control[iCurrent+14]=this.dw_cocktail
this.Control[iCurrent+15]=this.st_dose
this.Control[iCurrent+16]=this.st_package
this.Control[iCurrent+17]=this.st_1
this.Control[iCurrent+18]=this.cb_be_back
this.Control[iCurrent+19]=this.cb_done
this.Control[iCurrent+20]=this.cb_cancel
end on

on w_office_drug_treatment.destroy
call super::destroy
destroy(this.st_display_only)
destroy(this.st_hcpcs_procedure)
destroy(this.st_mult_display)
destroy(this.uo_drug_administration)
destroy(this.uo_drug_package)
destroy(this.st_procedure)
destroy(this.uo_procedure)
destroy(this.st_dosebase)
destroy(this.uo_dose)
destroy(this.st_method_description)
destroy(this.st_drug)
destroy(this.uo_hcpcs_procedure)
destroy(this.st_cocktail_title)
destroy(this.dw_cocktail)
destroy(this.st_dose)
destroy(this.st_package)
destroy(this.st_1)
destroy(this.cb_be_back)
destroy(this.cb_done)
destroy(this.cb_cancel)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_office_drug_treatment
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_office_drug_treatment
end type

type st_display_only from statictext within w_office_drug_treatment
integer x = 1230
integer y = 160
integer width = 462
integer height = 72
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Display Only"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_hcpcs_procedure from statictext within w_office_drug_treatment
integer x = 1870
integer y = 840
integer width = 773
integer height = 60
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "HCPCS Procedure:"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_mult_display from statictext within w_office_drug_treatment
integer x = 201
integer y = 388
integer width = 1042
integer height = 60
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_drug_administration from u_drug_administration within w_office_drug_treatment
integer x = 183
integer y = 912
integer width = 1070
integer height = 140
boolean enabled = true
end type

event clicked;call super::clicked;window w
real lr_temp
integer li_temp, i
str_popup popup
str_popup_return popup_return

if package_list_index <= 0 then
	messagebox("Drug Admin Select", "Please select a drug package.")
	selectitem(0)
	return
end if

popup.items = administration
popup.data_row_count = admin_count
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_index <= 0 then return
li_temp = popup_return.item_index

if li_temp > 0 then
	if f_unit_convert(1, administer_unit[li_temp], &
							uo_drug_package.pkg_administer_unit[package_list_index], &
							lr_temp) <= 0 then
			messagebox("Drug Administration Selection","This administration plan is not compatible with the selected package")
			selectitem(drug_admin_index)
	else
		selectitem(li_temp)
		drug_admin_index = li_temp
		triggerevent("newadmin")
		recalcdose()
	end if
else
	drug_admin_index = 0
end if


end event

type uo_drug_package from u_drug_package within w_office_drug_treatment
integer x = 1719
integer y = 252
integer width = 1070
integer height = 140
boolean enabled = true
end type

event clicked;call super::clicked;window w
integer i
real lr_temp
str_popup popup
str_popup_return popup_return

last_package_list_index = package_list_index

popup.items = package_description
popup.data_row_count = package_count
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_index <= 0 then return
package_list_index = popup_return.item_index
selectitem(package_list_index)

if package_list_index <= 0 then return

triggerevent("newpackage")

if drug_admin_index > 0 AND package_list_index > 0 then
	if f_unit_convert(1, uo_drug_administration.administer_unit[drug_admin_index], &
							pkg_administer_unit[package_list_index], &
							lr_temp) <= 0 then
		drug_admin_index = 0
		for i = 1 to uo_drug_administration.admin_count
			if uo_drug_administration.selectifcompatible(i, pkg_administer_unit[package_list_index]) > 0 then
				uo_drug_administration.postevent("selectionchanged")
				drug_admin_index = i
				exit
			end if
		next
		if drug_admin_index = 0 then
			uo_drug_administration.selectitem(0)
		else
			messagebox("Drug Administration Selection","The previous administration plan was not compatible with the selected package.  A compatible administration plan has been selected.")
		end if
	end if
end if

package_selected = true
recalcdose()

end event

event newpackage;call super::newpackage;if package_list_index > 0 then
	// administer_method no longer part of the package
//	st_method_description.text = method_description[package_list_index]
//	uo_procedure.get_default(administer_method[package_list_index])
end if

end event

type st_procedure from statictext within w_office_drug_treatment
integer x = 1870
integer y = 512
integer width = 773
integer height = 60
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Administration Procedure:"
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_procedure from u_admin_method_procedure within w_office_drug_treatment
integer x = 1719
integer y = 580
integer width = 1070
integer height = 140
long backcolor = 12632256
end type

event clicked;str_popup popup
str_popup_return popup_return
window w

w = parent

popup.dataobject = "dw_admin_method_procedure"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.argument_count = 1
popup.add_blank_row = true
popup.blank_text = "N/A"
popup.argument_count = 1
if package_list_index > 0 then
	// administer_method no longer part of package 
//	popup.argument[1] = uo_drug_package.administer_method[package_list_index]
//else
	popup.argument[1] = "IN OFFICE"
end if

popup.pointerx = this.pointerx() + this.x + w.x
popup.pointery = this.pointery() + this.y + w.y

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count = 0 then return

set_value(popup_return.items[1])


end event

type st_dosebase from statictext within w_office_drug_treatment
integer x = 183
integer y = 848
integer width = 1070
integer height = 60
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Dose Based On:"
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_dose from u_dose_amount within w_office_drug_treatment
integer x = 183
integer y = 248
integer width = 1070
integer height = 140
integer textsize = -12
integer weight = 700
end type

event clicked;call super::clicked;integer i

if WasModified then 
	uo_drug_administration.selectitem(0)
	drug_admin_index = 0
	set_hcpcs()
end if

end event

on constructor;call u_dose_amount::constructor;zero_warning = true
end on

type st_method_description from statictext within w_office_drug_treatment
integer x = 183
integer y = 580
integer width = 1070
integer height = 140
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_drug from statictext within w_office_drug_treatment
integer width = 2917
integer height = 144
integer textsize = -22
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 33538240
boolean enabled = false
alignment alignment = center!
long bordercolor = 8421504
boolean focusrectangle = false
end type

type uo_hcpcs_procedure from u_hcpcs_procedure within w_office_drug_treatment
integer x = 1719
integer y = 908
integer width = 1070
integer height = 140
long backcolor = 12632256
end type

event clicked;str_popup popup
str_popup_return popup_return
window w

w = parent

popup.dataobject = "dw_hcpcs_pick"
popup.datacolumn = 4
popup.displaycolumn = 5
popup.argument_count = 1
popup.add_blank_row = true
popup.blank_text = "N/A"
popup.argument[1] = drug_id

popup.pointerx = this.pointerx() + this.x + w.x
popup.pointery = this.pointery() + this.y + w.y

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count = 0 then return

set_value(popup_return.items[1], popup_return.descriptions[1])


end event

type st_cocktail_title from statictext within w_office_drug_treatment
integer x = 503
integer y = 508
integer width = 631
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Drug Cocktail"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_cocktail from datawindow within w_office_drug_treatment
integer x = 128
integer y = 584
integer width = 1381
integer height = 424
integer taborder = 40
string dataobject = "dw_display_drug_cocktail"
boolean livescroll = true
borderstyle borderstyle = styleraised!
end type

event clicked;string ls_prompt
String								buttons[]
Integer								button_pressed, li_attachment_button
Boolean 								lb_encounter_open
boolean								lb_display_encounter_open
Boolean 								lb_no_attachments
boolean								lb_test
str_popup							popup
str_popup_return 					popup_return
window 								lw_pop_buttons


// We can refill a prescription if it shows on the open encounter
if not display_only then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button10.bmp"
	popup.button_helps[popup.button_count] = "Add Cocktail Drugs"
	popup.button_titles[popup.button_count] = "Add Drugs"
	buttons[popup.button_count] = "ADD"
end if

if not display_only then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button10.bmp"
	popup.button_helps[popup.button_count] = "Remove Cocktail Drug(s)"
	popup.button_titles[popup.button_count] = "Remove Drug(s)"
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
	if isvalid(message.powerobjectparm) then
		popup_return = message.powerobjectparm
		button_pressed = popup_return.item_index
	else
		button_pressed = message.doubleparm
	end if

	if button_pressed < 1 or button_pressed > popup.button_count then return

elseif popup.button_count = 1 then
	button_pressed = 1
else
	return
end if

CHOOSE CASE buttons[button_pressed]
	CASE "ADD"
		add_cocktail()
	CASE "REMOVE"
		remove_cocktail()
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE


end event

type st_dose from statictext within w_office_drug_treatment
integer x = 430
integer y = 184
integer width = 576
integer height = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Dose"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_package from statictext within w_office_drug_treatment
integer x = 1966
integer y = 184
integer width = 576
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Package"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_office_drug_treatment
integer x = 430
integer y = 512
integer width = 576
integer height = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Admin Method"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_be_back from commandbutton within w_office_drug_treatment
integer x = 1454
integer y = 1600
integer width = 443
integer height = 108
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I~'ll Be Back"
end type

event clicked;str_popup_return popup_return
integer li_sts

popup_return.item_count = 0
closewithreturn(parent, popup_return)


end event

type cb_done from commandbutton within w_office_drug_treatment
integer x = 2414
integer y = 1600
integer width = 443
integer height = 108
integer taborder = 90
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
end type

event clicked;String	ls_description
str_popup_return popup_return
integer li_sts

If isnull(uo_dose.amount) or isnull(uo_dose.unit) Then
	messagebox("Prescription Review","You must specify a dose")
	Return
End if

li_sts = save_changes()
if li_sts <= 0 then return

popup_return.item_count = 1
popup_return.items[1] = "OK"
Closewithreturn(Parent, popup_return)


end event

type cb_cancel from commandbutton within w_office_drug_treatment
integer x = 1934
integer y = 1600
integer width = 443
integer height = 108
integer taborder = 90
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
end type

event clicked;str_popup_return popup_return

openwithparm(w_pop_yes_no, "Are you sure you wish to cancel this medication?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

service.treatment.Close("CANCELLED")

popup_return.item_count = 1
popup_return.items[1] = "CANCEL"
Closewithreturn(Parent, popup_return)


end event

