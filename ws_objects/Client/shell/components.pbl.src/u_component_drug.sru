$PBExportHeader$u_component_drug.sru
forward
global type u_component_drug from u_component_base_class
end type
end forward

global type u_component_drug from u_component_base_class
end type
global u_component_drug u_component_drug

type variables
private str_drug_definition drug_definition[]
private long drug_count

private str_package_definition package_definition[]
private long package_count

private str_drug_package drug_package[]
private long drug_package_count

private boolean rx_allow_qs
private boolean rx_number_to_text
private boolean rx_dispense_amount_asterisks
private boolean include_generic_name

private u_ds_data administer_frequency
private u_ds_data administer_method

private time cache_timestamp

private string administer_frequency_display

u_ds_data administer_frequency_cache

end variables

forward prototypes
public function integer get_package_definition (string ps_package_id, ref str_package_definition pstr_package)
public function integer get_drug_definition (string ps_drug_id, ref str_drug_definition pstr_drug)
public function integer get_drug_package (string ps_drug_id, string ps_package_id, ref str_drug_definition pstr_drug, ref str_package_definition pstr_package, ref str_drug_package pstr_drug_package)
public function integer get_dispense_list (string ps_drug_id, string ps_package_id, ref str_drug_package_dispense_list pstr_dispense_list)
public function integer new_package (ref str_package_definition pstr_package)
public function string package_description (string ps_package_id)
public function string treatment_dispense_description (str_treatment_description pstr_treatment)
public function string treatment_dosing_description (str_treatment_description pstr_treatment)
public function string treatment_refill_description (str_treatment_description pstr_treatment)
public function string treatment_admin_description (str_treatment_description pstr_treatment)
public function string treatment_drug_sig (str_treatment_description pstr_treatment)
public function string treatment_drug_description (str_treatment_description pstr_treatment)
public function string get_drug_property (string ps_drug_id, string ps_property)
public function string get_package_property (string ps_package_id, string ps_property)
public function string get_drugpackage_property (string ps_drug_id, string ps_package_id, string ps_property)
public function string get_drugpackage_property (string ps_drugpackage_id, string ps_property)
protected function integer xx_initialize ()
public function string administration_frequency_property (string ps_administer_frequency, string ps_property)
public function boolean cache_expired ()
public function string administration_method_property (string ps_administer_method, string ps_property)
public subroutine clear_cache ()
public function integer update_drug (str_drug_definition pstr_drug)
public function integer save_new_drug (ref str_drug_definition pstr_drug)
public function string administer_frequency_description (string ps_administer_frequency_code)
end prototypes

public function integer get_package_definition (string ps_package_id, ref str_package_definition pstr_package);integer i
integer li_sts

if isnull(ps_package_id) then return 0

// Clear the cache if it's expired
cache_expired()


// First check to see if we've already got this package
for i = 1 to package_count
	if ps_package_id = package_definition[i].package_id then
		pstr_package = package_definition[i]
		return 1
	end if
next

// If not, then get it from the database
SELECT c_Package.administer_unit,
		c_Package.dose_unit,
		c_Package.administer_per_dose,
		c_Package.description,
		c_Package.administer_method,
		c_Administration_Method.description,
		c_Package.dose_amount,
		c_Package.dosage_form
INTO :package_definition[package_count + 1].administer_unit,
		:package_definition[package_count + 1].dose_unit,
		:package_definition[package_count + 1].administer_per_dose,
		:package_definition[package_count + 1].description,
		:package_definition[package_count + 1].administer_method,
		:package_definition[package_count + 1].method_description,
		:package_definition[package_count + 1].dose_amount,
		:package_definition[package_count + 1].dosage_form
FROM c_Package (NOLOCK),
		c_Administration_Method (NOLOCK)
WHERE c_Package.package_id = :ps_package_id
AND c_Package.administer_method = c_Administration_method.administer_method
USING cprdb;
if not cprdb.check() then return -1
if cprdb.sqlcode = 100 then return 0

package_count += 1
package_definition[package_count].package_id = ps_package_id

pstr_package = package_definition[package_count]

return 1


end function

public function integer get_drug_definition (string ps_drug_id, ref str_drug_definition pstr_drug);integer i

if isnull(ps_drug_id) then return 0

// Clear the cache if it's expired
cache_expired()

// First check to see if we've already got this drug
for i = 1 to drug_count
	if ps_drug_id = drug_definition[i].drug_id then
		pstr_drug = drug_definition[i]
		return 1
	end if
next

// If not, then get it from the database
SELECT drug_type,
		common_name,
		generic_name,
		controlled_substance_flag,
		default_duration_amount,
		default_duration_unit,
		default_duration_prn,
		max_dose_per_day,
		max_dose_unit,
		patient_reference_material_id,
		provider_reference_material_id,
		status,
		dea_schedule,
		dea_number,
		dea_narcotic_status,
		reference_ndc_code,
		owner_id
INTO	:drug_definition[drug_count + 1].drug_type,
		:drug_definition[drug_count + 1].common_name,
		:drug_definition[drug_count + 1].generic_name,
		:drug_definition[drug_count + 1].controlled_substance_flag,
		:drug_definition[drug_count + 1].default_duration_amount,
		:drug_definition[drug_count + 1].default_duration_unit,
		:drug_definition[drug_count + 1].default_duration_prn,
		:drug_definition[drug_count + 1].max_dose_per_day,
		:drug_definition[drug_count + 1].max_dose_unit,
		:drug_definition[drug_count + 1].patient_reference_material_id,
		:drug_definition[drug_count + 1].provider_reference_material_id,
		:drug_definition[drug_count + 1].status,
		:drug_definition[drug_count + 1].dea_schedule,
		:drug_definition[drug_count + 1].dea_number,
		:drug_definition[drug_count + 1].dea_narcotic_status,
		:drug_definition[drug_count + 1].reference_ndc_code,
		:drug_definition[drug_count + 1].owner_id
FROM c_Drug_Definition
WHERE drug_id = :ps_drug_id
USING cprdb;
if not cprdb.check() then return -1
if cprdb.sqlcode = 100 then return 0

drug_count += 1
drug_definition[drug_count].drug_id = ps_drug_id

pstr_drug = drug_definition[drug_count]

return 1


end function

public function integer get_drug_package (string ps_drug_id, string ps_package_id, ref str_drug_definition pstr_drug, ref str_package_definition pstr_package, ref str_drug_package pstr_drug_package);integer i
integer li_sts

if isnull(ps_package_id) or isnull(ps_drug_id) then return 0

// Make sure we have the drug
li_sts = get_drug_definition(ps_drug_id, pstr_drug)
if li_sts <= 0 then return li_sts

// Make sure we have the package
li_sts = get_package_definition(ps_package_id, pstr_package)
if li_sts <= 0 then return li_sts

// First check to see if we've already got this drug_package
for i = 1 to drug_package_count
	if ps_drug_id = drug_package[i].drug_id and ps_package_id = drug_package[i].package_id then
		pstr_drug_package = drug_package[i]
		return 1
	end if
next

// If not, then get it from the database
SELECT sort_order,
		prescription_flag,
		default_dispense_amount,
		default_dispense_unit,
		take_as_directed
INTO	:drug_package[drug_package_count + 1].sort_order,
		:drug_package[drug_package_count + 1].prescription_flag,
		:drug_package[drug_package_count + 1].default_dispense_amount,
		:drug_package[drug_package_count + 1].default_dispense_unit,
		:drug_package[drug_package_count + 1].take_as_directed
FROM c_drug_package
WHERE drug_id = :ps_drug_id
AND package_id = :ps_package_id
USING cprdb;
if not cprdb.check() then return -1
if cprdb.sqlcode = 100 then return 0

drug_package_count += 1
drug_package[drug_package_count].drug_id = ps_drug_id
drug_package[drug_package_count].package_id = ps_package_id

pstr_drug_package = drug_package[drug_package_count]

return 1


end function

public function integer get_dispense_list (string ps_drug_id, string ps_package_id, ref str_drug_package_dispense_list pstr_dispense_list);integer i
integer li_sts
u_ds_data luo_data
integer li_count
string ls_dispense_unit
real lr_dispense_amount
u_unit luo_unit

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_c_drug_package_dispense")
li_count = luo_data.retrieve(ps_drug_id, ps_package_id)
if li_count <= 0 then return li_count

pstr_dispense_list.dispense_count = 0

for i = 1 to li_count
	ls_dispense_unit = luo_data.object.dispense_unit[i]
	lr_dispense_amount = luo_data.object.dispense_amount[i]
	
	luo_unit = unit_list.find_unit(ls_dispense_unit)
	if isnull(luo_unit) then continue
	
	pstr_dispense_list.dispense_count += 1
	pstr_dispense_list.dispense[pstr_dispense_list.dispense_count].drug_id = luo_data.object.drug_id[i]
	pstr_dispense_list.dispense[pstr_dispense_list.dispense_count].package_id = luo_data.object.package_id[i]
	pstr_dispense_list.dispense[pstr_dispense_list.dispense_count].dispense_sequence = luo_data.object.dispense_sequence[i]
	pstr_dispense_list.dispense[pstr_dispense_list.dispense_count].dispense_unit = ls_dispense_unit
	pstr_dispense_list.dispense[pstr_dispense_list.dispense_count].dispense_amount = lr_dispense_amount
	
	pstr_dispense_list.dispense[pstr_dispense_list.dispense_count].description = luo_unit.pretty_amount_unit(lr_dispense_amount)
	
next

DESTROY luo_data

return 1


end function

public function integer new_package (ref str_package_definition pstr_package);string ls_package_id
integer i
integer li_count
string ls_i

// First, make sure the required fields are present
if isnull(pstr_package.administer_method) or trim(pstr_package.administer_method) = "" then
	log.log(this, "new_package()", "administer_menthod required", 4)
	return -1
end if
if isnull(pstr_package.description) or trim(pstr_package.description) = "" then
	log.log(this, "new_package()", "description required", 4)
	return -1
end if
if isnull(pstr_package.administer_unit) or trim(pstr_package.administer_unit) = "" then
	log.log(this, "new_package()", "administer_unit required", 4)
	return -1
end if
if isnull(pstr_package.dose_unit) or trim(pstr_package.dose_unit) = "" then
	log.log(this, "new_package()", "dose_unit required", 4)
	return -1
end if
if isnull(pstr_package.administer_per_dose) or pstr_package.administer_per_dose <= 0 then
	log.log(this, "new_package()", "administer_per_dose required", 4)
	return -1
end if
if isnull(pstr_package.dosage_form) or trim(pstr_package.dosage_form) = "" then
	log.log(this, "new_package()", "dosage_form required", 4)
	return -1
end if
if isnull(pstr_package.dose_amount) or pstr_package.dose_amount <= 0 then
	pstr_package.dose_amount = 1
end if

// then, generate a new package_id that doesn't exist yet

ls_package_id = left(pstr_package.description, 24)
for i = 1 to 999
	SELECT count(*)
	INTO :li_count
	FROM c_Package
	WHERE package_id = :ls_package_id;
	if not tf_check() then return -1
	if li_count = 0 then exit
	
	ls_i = string(i)
	ls_package_id = left(ls_package_id, 24 - len(ls_i)) + ls_i
next

if i >= 999 then
	log.log(this, "new_package()", "Unable to find unique package_id", 4)
	return -1
end if

INSERT INTO c_Package (
	package_id,
	administer_method,
	description,
	administer_unit,
	dose_unit,
	administer_per_dose,
	dosage_form,
	dose_amount)
VALUES (
	:ls_package_id,
	:pstr_package.administer_method,
	:pstr_package.description,
	:pstr_package.administer_unit,
	:pstr_package.dose_unit,
	:pstr_package.administer_per_dose,
	:pstr_package.dosage_form,
	:pstr_package.dose_amount);
if not tf_check() then return -1
	
pstr_package.package_id = ls_package_id

return 1

end function

public function string package_description (string ps_package_id);string ls_description
str_package_definition 	lstr_package_definition
integer li_sts

Setnull(ls_description)

// If we don't have a valid drug_id and package_id then return null
li_sts = drugdb.get_package_definition(ps_package_id, lstr_package_definition)
if li_sts <= 0 then return ls_description

ls_description = lstr_package_definition.description

Return ls_description

end function

public function string treatment_dispense_description (str_treatment_description pstr_treatment);/////////////////////////////////////////////////////////////////////////////////////////////////////
//	Return: String
//
// Modified By:Sumathi Chinnasamy									Modified On:09/17/01
//
// Description: generates the drug description by including special ins, refills and other dosage info
// 
////////////////////////////////////////////////////////////////////////////////////////////////////

String	ls_description
string ls_unit
string ls_dispense_text
string ls_asterisk
string ls_dispense_qs

u_unit						luo_unit

ls_description = ""

if rx_dispense_amount_asterisks then
	ls_asterisk = "*"
else
	ls_asterisk = ""
end if

If not isnull(pstr_treatment.dispense_unit) and pstr_treatment.dispense_amount > 0 and not isnull(pstr_treatment.dispense_amount) THEN
	if rx_number_to_text then // print text representation of numbers
		luo_unit = unit_list.find_unit(pstr_treatment.dispense_unit)
		If isvalid(luo_unit) and not isnull(luo_unit) then
			ls_unit = luo_unit.pretty_unit(pstr_treatment.dispense_amount)
			ls_dispense_text = common_thread.mm.number_to_text(pstr_treatment.dispense_amount)
			ls_description += "Dispense: " +ls_dispense_text + " (" + ls_asterisk + string(pstr_treatment.dispense_amount) + ls_asterisk + ") "+ls_unit
		End If
	else
		ls_description += "Dispense: " + ls_asterisk + f_pretty_amount_unit(pstr_treatment.dispense_amount, pstr_treatment.dispense_unit) + ls_asterisk
	end if
else
	// If we don't have a valid amount/unit, check for a "Dispense QS" property
	ls_dispense_qs = f_get_progress_value(current_patient.cpr_id, &
											"Treatment", &
											pstr_treatment.treatment_id, &
											"Property", &
											"Dispense QS")
	if f_string_to_boolean(ls_dispense_qs) then
		ls_description += "Dispense: QS"
	end if
end if

Return ls_description

end function

public function string treatment_dosing_description (str_treatment_description pstr_treatment);/////////////////////////////////////////////////////////////////////////////////////////////////////
//	Return: String
//
// Modified By:Sumathi Chinnasamy									Modified On:09/17/01
//
// Description: generates the drug description by including special ins, refills and other dosage info
// 
////////////////////////////////////////////////////////////////////////////////////////////////////

String	ls_description
String	ls_take_as_directed
String	ls_unit
string ls_dose_text
string ls_amount
integer li_sts
string ls_duration
string ls_null

u_unit						luo_unit
str_drug_definition 		lstr_drug_definition
str_drug_package        lstr_drug_package
str_package_definition 	lstr_package_definition

setnull(ls_null)
ls_description = ""

// If we don't have a valid drug_id and package_id then return null
li_sts = drugdb.get_drug_package(pstr_treatment.drug_id,pstr_treatment.package_id,&
								lstr_drug_definition,lstr_package_definition,lstr_drug_package)
if li_sts <= 0 then
	// No package, so assume not take as directed
	ls_take_as_directed = "N"
else
	// We have a package
	ls_take_as_directed = lstr_drug_package.take_as_directed
end if

If upper(ls_take_as_directed) = "Y" Then
	ls_description = "  Take As Directed"
Else
	// If the dose amount isn't positive then there's no dosing info
	if pstr_treatment.dose_amount <= 0 or isnull(pstr_treatment.dose_amount) then return ls_null
	
	// If the dose unit isn't valid then there's no dosing info
	luo_unit = unit_list.find_unit(pstr_treatment.dose_unit)
	if isnull(luo_unit) then return ls_null
		
	if rx_number_to_text then // print text representation of numbers
		If isvalid(luo_unit) and not isnull(luo_unit) then
			ls_amount = luo_unit.pretty_amount(pstr_treatment.dose_amount)
			ls_unit = luo_unit.pretty_unit(pstr_treatment.dose_amount)
			ls_dose_text = common_thread.mm.number_to_text(pstr_treatment.dose_amount)
			ls_description = ls_dose_text + " (" + ls_amount + ") "+ls_unit
		End If
	else
		ls_description = f_pretty_amount_unit(pstr_treatment.dose_amount, pstr_treatment.dose_unit)
	end if
End if

Return trim(ls_description)

end function

public function string treatment_refill_description (str_treatment_description pstr_treatment);String	ls_description

setnull(ls_description)

If not isnull(pstr_treatment.dispense_unit) and pstr_treatment.dispense_amount > 0 and not isnull(pstr_treatment.dispense_amount) THEN
	if not isnull(pstr_treatment.refills) then
		If pstr_treatment.refills = -1 Then
			ls_description = "Refills PRN"
		ELSEIF isnull(pstr_treatment.refills) or pstr_treatment.refills <= 0 THEN
			ls_description = "No Refills"
		ELSE
			ls_description = string(pstr_treatment.refills) + " Refill"
			IF pstr_treatment.refills > 1 THEN ls_description += "s"
		END IF
	end if
END IF

Return ls_description

end function

public function string treatment_admin_description (str_treatment_description pstr_treatment);/////////////////////////////////////////////////////////////////////////////////////////////////////
//	Return: String
//
// Modified By:Sumathi Chinnasamy									Modified On:09/17/01
//
// Description: generates the drug description by including special ins, refills and other dosage info
// 
////////////////////////////////////////////////////////////////////////////////////////////////////

String	ls_description
String	ls_take_as_directed
String	ls_unit
string ls_dose_text
string ls_amount
integer li_sts
string ls_administer_method
string ls_duration
string ls_administer_frequency_code
string ls_administer_frequency_description

u_unit						luo_unit
str_drug_definition 		lstr_drug_definition
str_drug_package        lstr_drug_package
str_package_definition 	lstr_package_definition

ls_description = ""

// If we don't have a valid drug_id and package_id then return null
li_sts = drugdb.get_drug_package(pstr_treatment.drug_id,pstr_treatment.package_id,&
								lstr_drug_definition,lstr_package_definition,lstr_drug_package)
if li_sts <= 0 then return ls_description

// We have a package
ls_take_as_directed = lstr_drug_package.take_as_directed
ls_administer_method = lstr_package_definition.administer_method

If upper(ls_take_as_directed) = "Y" Then
	// If the drug is "take as directed" then there is no admin component
	return ls_description
Else
	If len(ls_administer_method) > 0 then
		if len(ls_description) > 0 then ls_description += " "
		ls_description += ls_administer_method
	End if
	
	If len(pstr_treatment.administer_frequency) > 0 then
		ls_administer_frequency_code = pstr_treatment.administer_frequency
		ls_administer_frequency_description = administer_frequency_description(ls_administer_frequency_code)
		
		if len(ls_description) > 0 then ls_description += " "
		CHOOSE CASE lower(administer_frequency_display)
			CASE "code"
				ls_description += ls_administer_frequency_code
			CASE "description"
				ls_description += ls_administer_frequency_description
			CASE "code and description"
				ls_description += ls_administer_frequency_code + " (" + ls_administer_frequency_description + ")"
			CASE ELSE
				ls_description += ls_administer_frequency_code
		END CHOOSE
	End if
	
	setnull(ls_duration)
	If isnull(pstr_treatment.duration_prn) then
		If pstr_treatment.duration_amount > 0 and not isnull(pstr_treatment.duration_unit) then
			ls_duration = f_pretty_amount_unit(pstr_treatment.duration_amount, pstr_treatment.duration_unit)
		Elseif pstr_treatment.duration_amount = -1 then
			ls_duration = "Indefinite"
		End if
	Else
		ls_duration = "PRN " + string(pstr_treatment.duration_prn)
	End if
	
	If len(ls_duration) > 0 and pstr_treatment.duration_amount >= 0 then
		ls_description += " x " + ls_duration
	End if
End if

Return ls_description

end function

public function string treatment_drug_sig (str_treatment_description pstr_treatment);/////////////////////////////////////////////////////////////////////////////////////////////////////
//	Return: String
//
// Modified By:Sumathi Chinnasamy									Modified On:09/17/01
//
// Description: generates the drug description by including special ins, refills and other dosage info
// 
////////////////////////////////////////////////////////////////////////////////////////////////////

String	ls_description
String	ls_take_as_directed

String	ls_administer_method
String	ls_temp,ls_duration,ls_brand_necessary
String	ls_rx_number_to_text,ls_unit,ls_dose_text,ls_dispense_text
integer li_sts
Boolean	lb_rx_number_to_text

u_unit						luo_unit
str_drug_definition 		lstr_drug_definition
str_drug_package        lstr_drug_package
str_package_definition 	lstr_package_definition

Setnull(ls_description)

// If we don't have a drug_id then there's nothing we can do so just use the treatment description
if isnull(pstr_treatment.drug_id) then return pstr_treatment.treatment_description

li_sts = drugdb.get_drug_definition(pstr_treatment.drug_id,lstr_drug_definition)
if li_sts <= 0 then return pstr_treatment.treatment_description

ls_description = treatment_drug_description(pstr_treatment)
if isnull(ls_description) then
	log.log(this, "treatment_drug_sig()", "No drug description available (" + pstr_treatment.drug_id + ")", 4)
	return ls_description
end if

ls_temp = package_description(pstr_treatment.package_id)
if len(ls_temp) > 0 then
	ls_description += ", " + ls_temp + ":"
end if

ls_temp = treatment_dosing_description(pstr_treatment)
if len(ls_temp) > 0 then
	ls_description += " " + ls_temp
end if

ls_temp = treatment_admin_description(pstr_treatment)
if len(ls_temp) > 0 then
	ls_description += " " + ls_temp
end if

ls_temp = treatment_dispense_description(pstr_treatment)
if len(ls_temp) > 0 then
	ls_description += "~r~n" + ls_temp
end if

ls_temp = treatment_refill_description(pstr_treatment)
if len(ls_temp) > 0 then
	ls_description += "~r~n" + ls_temp
end if

IF pstr_treatment.brand_name_required = "Y" THEN
	ls_brand_necessary = datalist.get_preference("PREFERENCES","brand_necessary_phrase")
	If Isnull(ls_brand_necessary) Then 
		ls_description += "~r~nBrand Necessary"
	else
		ls_description += "~r~n"+ls_brand_necessary
	end if
END IF


Return ls_description

end function

public function string treatment_drug_description (str_treatment_description pstr_treatment);integer li_sts
str_drug_definition 		lstr_drug_definition
string ls_null
string ls_description

Setnull(ls_null)

li_sts = get_drug_definition(pstr_treatment.drug_id,lstr_drug_definition)
if li_sts <= 0 then return ls_null

if len(lstr_drug_definition.common_name) > 0 then
	ls_description = lstr_drug_definition.common_name
else
	ls_description = lstr_drug_definition.generic_name
end if


if include_generic_name then
	if len(lstr_drug_definition.generic_name) > 0 then
		if lower(lstr_drug_definition.generic_name) <> lower(ls_description) then
			ls_description += " (" + lstr_drug_definition.generic_name + ")"
		end if
	end if
end if

if len(ls_description) > 0 then
	return ls_description
else
	log.log(this, "treatment_drug_sig()", "Drug has no common name and no generic name (" + pstr_treatment.drug_id + ")", 4)
	return ls_null
end if


end function

public function string get_drug_property (string ps_drug_id, string ps_property);integer i
integer li_sts
str_drug_definition lstr_drug
string ls_null
string ls_value
u_unit luo_unit
string ls_duration

setnull(ls_null)

if isnull(ps_drug_id) then return ls_null

li_sts = get_drug_definition(ps_drug_id, lstr_drug)
if li_sts <= 0 then return ls_null

CHOOSE CASE lower(ps_property)
	CASE "drug_type"
		ls_value = lstr_drug.drug_type
	CASE "common_name"
		ls_value = lstr_drug.common_name
	CASE "generic_name"
		ls_value = lstr_drug.generic_name
	CASE "controlled_substance_flag"
		ls_value = lstr_drug.controlled_substance_flag
	CASE "default_duration_amount"
		ls_value = f_pretty_amount(lstr_drug.default_duration_amount, lstr_drug.default_duration_unit, luo_unit)
	CASE "default_duration_unit_id"
		luo_unit = unit_list.find_unit(lstr_drug.default_duration_unit)
		if not isnull(luo_unit) then
			ls_value = luo_unit.pretty_unit(lstr_drug.default_duration_amount)
		end if
	CASE "default_duration_unit_id"
		ls_value = lstr_drug.default_duration_unit
	CASE "default_duration_prn"
		ls_value = lstr_drug.default_duration_prn
	CASE "default_duration"
		setnull(ls_duration)
		If isnull(lstr_drug.default_duration_prn) then
			If lstr_drug.default_duration_amount > 0 and not isnull(lstr_drug.default_duration_unit) then
				ls_duration = f_pretty_amount_unit(lstr_drug.default_duration_amount, lstr_drug.default_duration_unit)
			Elseif lstr_drug.default_duration_amount = -1 then
				ls_duration = "Indefinite"
			End if
		Else
			ls_duration = "PRN " + string(lstr_drug.default_duration_prn)
		End if
	CASE "max_dose_per_day"
		ls_value = f_pretty_amount(lstr_drug.max_dose_per_day, lstr_drug.max_dose_unit, luo_unit)
	CASE "max_dose_unit"
		ls_value = lstr_drug.max_dose_unit
		luo_unit = unit_list.find_unit(lstr_drug.max_dose_unit)
		if not isnull(luo_unit) then
			ls_value = luo_unit.pretty_unit(lstr_drug.max_dose_per_day)
		end if
	CASE "max_dose_unit_id"
		ls_value = lstr_drug.max_dose_unit
	CASE "status"
		ls_value = lstr_drug.status
END CHOOSE


return ls_value



end function

public function string get_package_property (string ps_package_id, string ps_property);integer i
integer li_sts
str_package_definition lstr_package
string ls_null
string ls_value
u_unit luo_unit
string ls_duration

setnull(ls_null)

if isnull(ps_package_id) then return ls_null

li_sts = get_package_definition(ps_package_id, lstr_package)
if li_sts <= 0 then return ls_null

CHOOSE CASE lower(ps_property)
	CASE "administer_per_dose"
		ls_value = f_pretty_amount(lstr_package.administer_per_dose, lstr_package.administer_unit, luo_unit)
	CASE "administer_unit"
		luo_unit = unit_list.find_unit(lstr_package.administer_unit)
		if not isnull(luo_unit) then
			ls_value = luo_unit.pretty_unit(lstr_package.administer_per_dose)
		end if
	CASE "administer_unit_id"
		ls_value = lstr_package.administer_unit
	CASE "dose_amount"
		ls_value = f_pretty_amount(lstr_package.dose_amount, lstr_package.dose_unit, luo_unit)
		if isnull(ls_value) or ls_value = "0" then ls_value = "1"
	CASE "dose_unit"
		luo_unit = unit_list.find_unit(lstr_package.dose_unit)
		if not isnull(luo_unit) then
			ls_value = luo_unit.pretty_unit(lstr_package.dose_amount)
		end if
	CASE "dose_unit_id"
		ls_value = lstr_package.dose_unit
	CASE "description"
		ls_value = lstr_package.description
	CASE "administer_method"
		ls_value = lstr_package.administer_method
	CASE "method_description"
		ls_value = lstr_package.method_description
	CASE "dosage_form"
		ls_value = lstr_package.dosage_form
END CHOOSE


return ls_value



end function

public function string get_drugpackage_property (string ps_drug_id, string ps_package_id, string ps_property);integer i
integer li_sts
str_drug_definition lstr_drug
str_package_definition lstr_package
str_drug_package lstr_drug_package
string ls_null
string ls_value
u_unit luo_unit

setnull(ls_null)

if isnull(ps_package_id) or isnull(ps_drug_id) then return ls_null

li_sts = get_drug_package(ps_drug_id, ps_package_id, lstr_drug, lstr_package, lstr_drug_package)
if li_sts <= 0 then return ls_null


CHOOSE CASE lower(ps_property)
	CASE "sort_order"
		ls_value = string(lstr_drug_package.sort_order)
	CASE "prescription_flag"
		ls_value = lstr_drug_package.prescription_flag
	CASE "default_dispense_amount"
		ls_value = f_pretty_amount(lstr_drug_package.default_dispense_amount, lstr_drug_package.default_dispense_unit, luo_unit)
	CASE "default_dispense_unit"
		luo_unit = unit_list.find_unit(lstr_drug_package.default_dispense_unit)
		if not isnull(luo_unit) then
			ls_value = luo_unit.pretty_unit(lstr_drug_package.default_dispense_amount)
		end if
	CASE "default_dispense_unit_id"
		ls_value = lstr_drug_package.default_dispense_unit
	CASE "take_as_directed"
		ls_value = lstr_drug_package.take_as_directed
END CHOOSE



return ls_value


end function

public function string get_drugpackage_property (string ps_drugpackage_id, string ps_property);// If this form of the method is called then teh drug_id and the package_id are concatenated together with a vertical bar
// between them
string ls_drug_id
string ls_package_id
string ls_null

setnull(ls_null)

f_split_string(ps_drugpackage_id, "|", ls_drug_id, ls_package_id)
if ls_package_id = "" then
	// there wasn't two parts
	return ls_null
end if

return get_drugpackage_property(ls_drug_id, ls_package_id, ps_property)




end function

protected function integer xx_initialize ();

administer_frequency = CREATE u_ds_data
administer_frequency.set_dataobject("dw_c_administration_frequency")

administer_method = CREATE u_ds_data
administer_method.set_dataobject("dw_administer_method_list")

return 1

end function

public function string administration_frequency_property (string ps_administer_frequency, string ps_property);string ls_value
long ll_row
string ls_find
long ll_count

ll_count = administer_frequency.rowcount()
if ll_count = 0 or cache_expired() then
	ll_count = administer_frequency.retrieve()
end if

ls_find = "administer_frequency='" + ps_administer_frequency + "'"
ll_row = administer_frequency.find(ls_find, 1, ll_count)
if ll_row <= 0 then
	setnull(ls_value)
else
	ls_value = administer_frequency.get_field_value(ll_row, ps_property)
end if

return ls_value

end function

public function boolean cache_expired ();
if secondsafter(cache_timestamp, now()) > 600 then
	clear_cache()
	return true
else
	return false
end if

end function

public function string administration_method_property (string ps_administer_method, string ps_property);string ls_value
long ll_row
string ls_find
long ll_count

ll_count = administer_method.rowcount()
if ll_count = 0 or cache_expired() then
	ll_count = administer_method.retrieve()
end if

ls_find = "administer_method='" + ps_administer_method + "'"
ll_row = administer_method.find(ls_find, 1, ll_count)
if ll_row <= 0 then
	setnull(ls_value)
else
	ls_value = administer_method.get_field_value(ll_row, ps_property)
end if

return ls_value

end function

public subroutine clear_cache ();administer_frequency.reset()
administer_frequency.settransobject(sqlca)
administer_method.reset()
administer_method.settransobject(sqlca)
drug_count = 0
drug_package_count = 0
package_count = 0
	
cache_timestamp = now()

end subroutine

public function integer update_drug (str_drug_definition pstr_drug);long i


UPDATE c_Drug_Definition
SET 	drug_type = :pstr_drug.drug_type,
		controlled_substance_flag = :pstr_drug.controlled_substance_flag,
		default_duration_amount = :pstr_drug.default_duration_amount,
		default_duration_unit = :pstr_drug.default_duration_unit,
		default_duration_prn = :pstr_drug.default_duration_prn,
		max_dose_per_day = :pstr_drug.max_dose_per_day,
		max_dose_unit = :pstr_drug.max_dose_unit,
		common_name = :pstr_drug.common_name,
		patient_reference_material_id = :pstr_drug.patient_reference_material_id,
		provider_reference_material_id = :pstr_drug.provider_reference_material_id,
		dea_schedule = :pstr_drug.dea_schedule,
		dea_number = :pstr_drug.dea_number,
		dea_narcotic_status = :pstr_drug.dea_narcotic_status,
		reference_ndc_code = :pstr_drug.reference_ndc_code
WHERE drug_id = :pstr_drug.drug_id;
if not tf_check() then return -1

// Check to see if we've got this drug in the cache
for i = 1 to drug_count
	if pstr_drug.drug_id = drug_definition[i].drug_id then
		drug_definition[i] = pstr_drug
		return 1
	end if
next

return 1

end function

public function integer save_new_drug (ref str_drug_definition pstr_drug);string ls_specialty_id
real lr_max_dose_per_day
string ls_max_dose_unit
u_ds_data luo_data
long ll_count

if isnull(pstr_drug.common_name) or trim(pstr_drug.common_name) = "" then
	log.log(this, "save_new_drug()", "No common name", 4)
	return -1
end if

if isnull(pstr_drug.generic_name) or trim(pstr_drug.generic_name) = "" then
	setnull(pstr_drug.generic_name)
end if

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_sp_new_drug_result_set")

ll_count = luo_data.retrieve( pstr_drug.drug_type, & 
										pstr_drug.common_name, & 
										pstr_drug.generic_name, & 
										pstr_drug.controlled_substance_flag, & 
										pstr_drug.default_duration_amount, & 
										pstr_drug.default_duration_unit, & 
										pstr_drug.default_duration_prn, & 
										pstr_drug.max_dose_per_day, & 
										pstr_drug.max_dose_unit)
if ll_count <= 0 then
	log.log(this, "save_new_drug()", "Error saving new drug", 4)
	return -1
end if

pstr_drug.drug_id = luo_data.object.drug_id[1]

DESTROY u_ds_data

UPDATE c_Drug_Definition
SET status = :pstr_drug.status,
	patient_reference_material_id = :pstr_drug.patient_reference_material_id,
	provider_reference_material_id = :pstr_drug.provider_reference_material_id,
	dea_schedule = :pstr_drug.dea_schedule,
	dea_number = :pstr_drug.dea_number,
	dea_narcotic_status = :pstr_drug.dea_narcotic_status
WHERE drug_id = :pstr_drug.drug_id;
if not tf_check() then return -1

return 1

end function

public function string administer_frequency_description (string ps_administer_frequency_code);string ls_administer_frequency_description
long ll_rowcount
long ll_row
string ls_find

ll_rowcount = administer_frequency_cache.rowcount()
if ll_rowcount <= 0 then
	ll_rowcount = administer_frequency_cache.retrieve()
end if

ls_find = "administer_frequency='" + ps_administer_frequency_code + "'"
ll_row = administer_frequency_cache.find(ls_find, 1, ll_rowcount)
if ll_row > 0 then
	ls_administer_frequency_description = administer_frequency_cache.object.description[ll_row]
end if

if isnull(ls_administer_frequency_description) or trim(ls_administer_frequency_description) = "" then
	ls_administer_frequency_description = ps_administer_frequency_code
end if

return ls_administer_frequency_description

end function

on u_component_drug.create
call super::create
end on

on u_component_drug.destroy
call super::destroy
end on

event constructor;call super::constructor;
rx_number_to_text = datalist.get_preference_boolean("PREFERENCES", "rx_show_number_in_text", false)
rx_dispense_amount_asterisks = datalist.get_preference_boolean("PREFERENCES", "rx_dispense_amount_asterisks", false)

include_generic_name = datalist.get_preference_boolean("PREFERENCES", "rx_include_generic_name", true)

administer_frequency_cache = CREATE u_ds_data
administer_frequency_cache.set_dataobject("dw_administer_frequency")

administer_frequency_display = datalist.get_preference("PREFERENCES", "rx_show_administer_frequency", "code")

rx_allow_qs = datalist.get_preference_boolean("RX", "Allow QS Drug Dispense", false)

end event

