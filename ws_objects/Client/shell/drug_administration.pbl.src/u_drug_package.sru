﻿$PBExportHeader$u_drug_package.sru
forward
global type u_drug_package from statictext
end type
end forward

global type u_drug_package from statictext
integer width = 882
integer height = 132
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
boolean disabledlook = true
event newpackage ( )
end type
global u_drug_package u_drug_package

type variables
integer package_count
string package_id[]
string package_description[]
string pkg_administer_unit[]
real dose_amount[]
string dose_unit[]
real administer_per_dose[]
string prescription_flag[]
real default_dispense_amount[]
string default_dispense_unit[]
string display_mask[]
string take_as_directed[]
string dosage_form[]
string form_rxcui[]


end variables

forward prototypes
public subroutine selectitem (integer pi_item_number)
public function integer selectdosageform (string ps_dosage_form)
public function integer retrieve (string ps_drug_id)
public function integer selectpackage (string ps_package_id)
public function integer selectformulation (string ps_form_rxcui)
end prototypes

public subroutine selectitem (integer pi_item_number);if pi_item_number > 0 and pi_item_number <= package_count then
	text = package_description[pi_item_number]
else
	text = ""
end if

end subroutine

public function integer selectdosageform (string ps_dosage_form);integer i

if ps_dosage_form = "" then
	selectitem(0)
	return 0
end if

for i = 1 to package_count
	if dosage_form[i] = ps_dosage_form then
		selectitem(i)
		return i
	end if
next

return 0

end function

public function integer retrieve (string ps_drug_id);integer i, li_sts, li_sort_order
u_ds_data luo_data

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_drug_package_data")
package_count = luo_data.retrieve(ps_drug_id)

for i = 1 to package_count
	package_id[i] = luo_data.object.package_id[i]
	prescription_flag[i] = luo_data.object.prescription_flag[i]
	default_dispense_amount[i] = luo_data.object.default_dispense_amount[i]
	default_dispense_unit[i] = luo_data.object.default_dispense_unit[i]
	take_as_directed[i] = luo_data.object.take_as_directed[i]
	package_description[i] = luo_data.object.package_description[i]
	pkg_administer_unit[i] = luo_data.object.administer_unit[i]
	dose_amount[i] = luo_data.object.dose_amount[i]
	dose_unit[i] = luo_data.object.dose_unit[i]
	administer_per_dose[i] = luo_data.object.administer_per_dose[i]
	display_mask[i] = luo_data.object.display_mask[i]
	dosage_form[i] = luo_data.object.dosage_form[i]
	form_rxcui[i] = luo_data.object.form_rxcui[i]
next

DESTROY luo_data

return package_count


end function

public function integer selectpackage (string ps_package_id);integer i

if isnull(ps_package_id) or trim(ps_package_id) = "" then
	selectitem(0)
	return 0
end if

for i = 1 to package_count
	if package_id[i] = ps_package_id then
		selectitem(i)
		return i
	end if
next

log.log(this, "u_drug_package.selectpackage:0043", "Package Not Found (" + ps_package_id + ")", 3)
return 0

//
//// If we didn't find the specified package, then add it
//// administer_method no longer part of package
//SELECT c_Package.description,
//		c_Package.administer_unit,
//		c_Package.dose_amount,
//		c_Package.dose_unit,
//		c_Package.administer_per_dose,
//		c_Unit.display_mask,
//		c_Package.dosage_form,
//		c_Drug_Package.form_rxcui
//INTO		:package_description[package_count + 1],
//			:pkg_administer_unit[package_count + 1],
//			:dose_amount[package_count + 1],
//			:dose_unit[package_count + 1],
//			:administer_per_dose[package_count + 1],
//			:display_mask[package_count + 1],
//			:dosage_form[package_count + 1],
//			:form_rxcui[package_count + 1]
// FROM c_Package
// 	JOIN c_Drug_Package ON c_Drug_Package.Package_id = c_Package.Package_id
//	INNER JOIN c_Unit
//	ON c_Package.dose_unit = c_Unit.unit_id
//WHERE c_Package.package_id = :ps_package_id;
//if not tf_check() then return -1
//if sqlca.sqlcode = 100 then
//	log.log(this, "u_drug_package.selectpackage:0043", "Package Not Found (" + ps_package_id + ")", 3)
//	return 0
//end if
//
//package_count += 1
//
//package_id[package_count] = ps_package_id
//prescription_flag[package_count] = "Y"
//default_dispense_amount[package_count] = 1
//default_dispense_unit[package_count] = dose_unit[package_count]
//take_as_directed[package_count] = "N"
//if isnull(dose_amount[package_count]) then dose_amount[package_count] = 1
//
//selectitem(package_count)
//return package_count
//
end function

public function integer selectformulation (string ps_form_rxcui);integer i

if isnull(ps_form_rxcui) or trim(ps_form_rxcui) = "" then
	selectitem(0)
	return 0
end if

for i = 1 to package_count
	// will need to fix this if we get real packages (where there will be more than one per formulation)
	if form_rxcui[i] = ps_form_rxcui then
		selectitem(i)
		return i
	end if
next
end function

on u_drug_package.create
end on

on u_drug_package.destroy
end on

