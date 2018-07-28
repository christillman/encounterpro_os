HA$PBExportHeader$u_dispense_amount.sru
forward
global type u_dispense_amount from u_drug_amount_base
end type
end forward

global type u_dispense_amount from u_drug_amount_base
end type
global u_dispense_amount u_dispense_amount

type variables
string drug_id
string package_id

str_drug_definition drug_definition
str_package_definition package_definition
str_drug_package drug_package

boolean allow_qs
boolean is_qs

end variables

forward prototypes
public subroutine calc_amount (real pr_dose_amount, string ps_dose_unit, real pr_frequency, real pr_duration_amount, string ps_duration_unit)
public subroutine set_drug_package (string ps_drug_id, string ps_package_id)
public subroutine set_amount (real pr_amount, string ps_unit)
end prototypes

public subroutine calc_amount (real pr_dose_amount, string ps_dose_unit, real pr_frequency, real pr_duration_amount, string ps_duration_unit);integer li_sts
real lr_days
real lr_doses
real lr_dispense_amount


if pr_duration_amount > 0 then
	li_sts = f_unit_convert(pr_duration_amount, ps_duration_unit, "DAY", lr_days)
	if li_sts <= 0 then return

	lr_doses = pr_dose_amount * lr_days * pr_frequency

	li_sts = f_unit_convert(lr_doses, ps_dose_unit, unit, lr_dispense_amount)
	if li_sts <= 0 then return

	set_amount(lr_dispense_amount, unit)
end if

end subroutine

public subroutine set_drug_package (string ps_drug_id, string ps_package_id);real lr_amount
string ls_unit
integer li_sts

drug_id = ps_drug_id
package_id = ps_package_id

li_sts = drugdb.get_drug_package(drug_id, package_id, drug_definition, package_definition, drug_package)
if li_sts <= 0 then return

unit = package_definition.dose_unit

return

end subroutine

public subroutine set_amount (real pr_amount, string ps_unit);amount = pr_amount
unit = ps_unit

if isnull(amount) and is_qs  then
	text = "QS"
else
	pretty_text()
end if


end subroutine

event clicked;call super::clicked;//str_drug_amount drug
//
//drug.amount = amount
//drug.unit = unit
//openwithparm(w_pop_dispense, drug)
//drug = message.powerobjectparm
//if drug.amount >= 0 then
//	set_amount(drug.amount, drug.unit)
//	WasModified = True
//end if

str_popup popup
str_popup_return popup_return
u_unit luo_unit
real lr_amount
string ls_unit
str_drug_package_dispense_list lstr_dispense_list
integer li_sts
integer i
long ll_dispense_selected
long ll_QS_item_index
long ll_Other_Amount_item_index
boolean lb_is_qs

lb_is_qs = false

if isnull(package_id) or package_id = "" then
	openwithparm(w_pop_message, "Please select a package")
	return
end if

li_sts = drugdb.get_dispense_list(drug_id, package_id, lstr_dispense_list)
if li_sts < 0 then return

for i = 1 to lstr_dispense_list.dispense_count
	popup.items[i] = lstr_dispense_list.dispense[i].description
next

if lstr_dispense_list.dispense_count > 0 then
	popup.auto_singleton = true
	popup.data_row_count = lstr_dispense_list.dispense_count
	
	if allow_qs then
		popup.data_row_count += 1
		popup.items[popup.data_row_count] = "QS"
		ll_QS_item_index = popup.data_row_count
	end if

	popup.data_row_count += 1
	popup.items[popup.data_row_count] = "<Other Amount>"
	ll_Other_Amount_item_index = popup.data_row_count

	openwithparm(w_pop_pick, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return
	if popup_return.item_indexes[1] <= 0 then return
	
	ll_dispense_selected = popup_return.item_indexes[1]
else
	ll_dispense_selected = 1
end if

if ll_dispense_selected <= lstr_dispense_list.dispense_count then
	// User selected a specific dispense record
	lr_amount = lstr_dispense_list.dispense[popup_return.item_indexes[1]].dispense_amount
	ls_unit = lstr_dispense_list.dispense[popup_return.item_indexes[1]].dispense_unit
elseif ll_dispense_selected = ll_QS_item_index then
	setnull(lr_amount)
	lb_is_qs = true
else
	// User selected <Other Amount>, or there were no dispense choices
	popup.realitem = amount
	popup.objectparm = unit_list.find_unit(unit)
	popup.item = "EDITUNIT"
	for i = 1 to lstr_dispense_list.dispense_count
		popup.items[i] = lstr_dispense_list.dispense[i].dispense_unit
	next
	popup.data_row_count = f_remove_duplicates(lstr_dispense_list.dispense_count, popup.items)
	
	openwithparm(w_number, popup)
	popup_return = message.powerobjectparm
	
	if popup_return.item = "OK" then
		lr_amount = popup_return.realitem
		luo_unit = popup_return.returnobject
		if isnull(luo_unit) then
			ls_unit = unit
		else
			ls_unit = luo_unit.unit_id
		end if
	else
		return
	end if
end if

is_qs = lb_is_qs
set_amount(lr_amount, ls_unit)
wasmodified = true


end event

on u_dispense_amount.create
call super::create
end on

on u_dispense_amount.destroy
call super::destroy
end on

