$PBExportHeader$u_dose_amount.sru
forward
global type u_dose_amount from u_drug_amount_base
end type
end forward

global type u_dose_amount from u_drug_amount_base
end type
global u_dose_amount u_dose_amount

type variables
real weight_kg
end variables

forward prototypes
public function integer convert_dose_amount (string ps_from_pkg_administer_unit, real pr_from_administer_per_dose, string ps_from_dose_unit, string ps_to_pkg_administer_unit, real pr_to_administer_per_dose, real pr_to_package_dose_amount, string ps_to_dose_unit)
public function integer calc_dose_amount (real pr_administer_amount, string ps_administer_unit, string ps_pkg_administer_unit, string ps_mult_by_what, string ps_calc_per, integer pi_daily_frequency, real pr_administer_per_dose, real pr_package_dose_amount, string ps_dose_unit, real pr_max_dose_per_day, u_unit puo_max_dose_unit, ref string ps_mult_display, ref real pr_dose_amount)
public function integer get_mult_factor (string ps_mult_by_what, ref real pr_multiplier, ref string ps_mult_display)
end prototypes

public function integer convert_dose_amount (string ps_from_pkg_administer_unit, real pr_from_administer_per_dose, string ps_from_dose_unit, string ps_to_pkg_administer_unit, real pr_to_administer_per_dose, real pr_to_package_dose_amount, string ps_to_dose_unit);real lr_old_amount, lr_new_amount
integer li_sts

if isnull(pr_to_package_dose_amount) or pr_to_package_dose_amount <= 0 then pr_to_package_dose_amount = 1

// First, convert the current dose to the old dose_unit (in case the
// user has changed it)
li_sts = f_unit_convert(amount, &
								unit, &
								ps_from_dose_unit, &
								lr_old_amount)
if li_sts <= 0 then return li_sts

// Next, convert the old dose unit back into the old administer unit
lr_old_amount = lr_old_amount * pr_from_administer_per_dose

// Next, convert the old administer unit into the new administer unit
li_sts = f_unit_convert(lr_old_amount, &
								ps_from_pkg_administer_unit, &
								ps_to_pkg_administer_unit, &
								lr_new_amount)
if li_sts <= 0 then return li_sts

// Finally, convert the new administer unit into the new dose unit
lr_new_amount = lr_new_amount / pr_to_administer_per_dose
lr_new_amount /= pr_to_package_dose_amount

set_amount(lr_new_amount, ps_to_dose_unit)
return 1
end function

public function integer calc_dose_amount (real pr_administer_amount, string ps_administer_unit, string ps_pkg_administer_unit, string ps_mult_by_what, string ps_calc_per, integer pi_daily_frequency, real pr_administer_per_dose, real pr_package_dose_amount, string ps_dose_unit, real pr_max_dose_per_day, u_unit puo_max_dose_unit, ref string ps_mult_display, ref real pr_dose_amount);real lr_converted_amount, lr_multiplier, lr_administer_total, lr_administer_max
integer li_sts

if isnull(pr_package_dose_amount) or pr_package_dose_amount <= 0 then pr_package_dose_amount = 1
// protect against divide by zero
if isnull(pr_administer_per_dose) or pr_administer_per_dose <= 0 then pr_administer_per_dose = 1

// First, calculate how much of the drug is to be administered per day
li_sts = f_unit_convert(pr_administer_amount, &
								ps_administer_unit, &
								ps_pkg_administer_unit, &
								lr_converted_amount)
if li_sts <= 0 then return li_sts

li_sts = get_mult_factor(ps_mult_by_what, &
								 lr_multiplier, &
								 ps_mult_display)
if li_sts <= 0 then return li_sts

lr_administer_total = (lr_multiplier * lr_converted_amount)


// Then check to make sure that this does not exceed the max dose (if a max dose is provided)

if pr_max_dose_per_day > 0 and not isnull(puo_max_dose_unit) then
	li_sts = f_unit_convert(pr_max_dose_per_day, &
									puo_max_dose_unit.unit_id, &
									ps_pkg_administer_unit, &
									lr_administer_max)

	if li_sts > 0 and lr_administer_total > lr_administer_max then
		lr_administer_total = lr_administer_max
	end if
end if

// Finally, divide by the frequency (if calc_per = 'DAY') and convert to the dose unit

if ps_calc_per = "DAY" and pi_daily_frequency > 0 then
	lr_administer_total /= pi_daily_frequency
end if

pr_dose_amount = lr_administer_total / pr_administer_per_dose
pr_dose_amount *= pr_package_dose_amount

return 1
end function

public function integer get_mult_factor (string ps_mult_by_what, ref real pr_multiplier, ref string ps_mult_display);integer li_sts
real lr_multiplier
string ls_result_value
string ls_result_unit, ls_display_date
datetime ldt_result_date_time
string ls_observation_id
string ls_location
integer li_result_sequence
long ll_observation_sequence
string ls_result
string ls_result_amount_flag
real lr_result_amount

//CWW, BEGIN
u_ds_data luo_sp_get_last_result
integer li_spdw_count
// DECLARE lsp_get_last_result PROCEDURE FOR sp_get_last_result  
//         @ps_cpr_id = :current_patient.cpr_id,   
//         @ps_observation_id = :ls_observation_id,   
//         @ps_location = :ls_location OUT,   
//         @pi_result_sequence = :li_result_sequence OUT,   
//         @pl_observation_sequence = :ll_observation_sequence OUT,   
//         @ps_result = :ls_result OUT,   
//         @ps_result_amount_flag = :ls_result_amount_flag OUT,   
//         @pdt_result_date_time = :ldt_result_date_time OUT,   
//         @ps_result_value = :ls_result_value OUT,   
//         @ps_result_unit = :ls_result_unit OUT ;
			
//CWW,END


setnull(ps_mult_display)

// This hard-coded observation_id/result_sequence must be changed to soft-coded
ls_observation_id = "WGT"
li_result_sequence = -1
ls_location = "NA"

CHOOSE CASE ps_mult_by_what
	CASE "KG"
		//CWW, BEGIN
//		EXECUTE lsp_get_last_result;
//		if not tf_check() then return -1
//		FETCH lsp_get_last_result INTO :ls_location,
//												:li_result_sequence, 
//												:ll_observation_sequence,
//												:ls_result,
//												:ls_result_amount_flag,
//												:ldt_result_date_time,
//												:ls_result_value,
//												:ls_result_unit;
//		if not tf_check() then return -1
//		CLOSE lsp_get_last_result;
		
		luo_sp_get_last_result = CREATE u_ds_data
		luo_sp_get_last_result.set_dataobject("dw_sp_get_last_result")
		li_spdw_count = luo_sp_get_last_result.retrieve(current_patient.cpr_id, ls_observation_id)
		if li_spdw_count <= 0 then
			setnull(ls_location)
			setnull(li_result_sequence)
			setnull(ll_observation_sequence)
			setnull(ls_result)
			setnull(ls_result_amount_flag)
			setnull(ldt_result_date_time)
			setnull(ls_result_value)
			setnull(ls_result_unit)
		else
			ls_location = luo_sp_get_last_result.object.location[1]
			li_result_sequence = luo_sp_get_last_result.object.result_sequence[1]
			ll_observation_sequence = luo_sp_get_last_result.object.observation_sequence[1]
			ls_result = luo_sp_get_last_result.object.result[1]
			ls_result_amount_flag = luo_sp_get_last_result.object.result_amount_flag[1]
			ldt_result_date_time = luo_sp_get_last_result.object.result_date_time[1]
			ls_result_value = luo_sp_get_last_result.object.result_value[1]
			ls_result_unit = luo_sp_get_last_result.object.result_unit[1]
		end if
		destroy luo_sp_get_last_result
		//CWW, END
		
		lr_result_amount = real(ls_result_value)
		
		// If the result_sequence is null then no result was found
		if isnull(li_result_sequence) then
			if isnull(weight_kg) or (weight_kg = 0) then
				open(w_pop_weight)
				lr_multiplier = message.doubleparm
				if lr_multiplier < 0 then
					messagebox("get_mult_factor","No weight available")
				else
					weight_kg = lr_multiplier
					ps_mult_display = f_pretty_amount_unit(lr_multiplier, ps_mult_by_what) + " Estimate"
				end if
			else
				lr_multiplier = weight_kg
				ps_mult_display = f_pretty_amount_unit(lr_multiplier, ps_mult_by_what) + " Estimate"
			end if
		else
			li_sts = f_unit_convert(lr_result_amount, ls_result_unit, "KG", lr_multiplier)
			if li_sts <= 0 then return li_sts
			ls_display_date = string(ldt_result_date_time, date_format_string)
			if ls_display_date = string(today(), date_format_string) then
				ls_display_date = "Today"
			else
				ls_display_date += " - " + f_pretty_age(date(ldt_result_date_time), today()) + " Ago"
			end if
			ps_mult_display = f_pretty_amount_unit(lr_multiplier, ps_mult_by_what) + "  " + ls_display_date
		end if
	CASE ELSE
		lr_multiplier = 1
END CHOOSE


if lr_multiplier = 0 then
	return 0
else
	pr_multiplier = lr_multiplier
	return 1
end if
end function

event clicked;call super::clicked;//str_drug_amount drug
//
//if isnull(unit) or unit = "" then
//	openwithparm(w_pop_message, "Please select a package")
//	return
//end if
//
//drug.amount = amount
//drug.unit = unit
//openwithparm(w_pop_dose, drug)
//if message.doubleparm >= 0 then
//	set_amount(message.doubleparm, drug.unit)
//	WasModified = True
//end if
//

str_popup popup
str_popup_return popup_return
u_unit luo_unit
string ls_unit

if isnull(unit) or unit = "" then
	openwithparm(w_pop_message, "Please select a package")
	return
end if

popup.realitem = amount
popup.objectparm = unit_list.find_unit(unit)
popup.item = "EDITUNIT"
openwithparm(w_number, popup)
popup_return = message.powerobjectparm

if popup_return.item = "OK" then
	luo_unit = popup_return.returnobject
	if isnull(luo_unit) then
		ls_unit = unit
	else
		ls_unit = luo_unit.unit_id
	end if
	set_amount(popup_return.realitem, ls_unit)
	wasmodified = true
end if

end event

on u_dose_amount.create
call super::create
end on

on u_dose_amount.destroy
call super::destroy
end on

