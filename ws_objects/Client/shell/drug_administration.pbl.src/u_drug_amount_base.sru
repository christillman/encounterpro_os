$PBExportHeader$u_drug_amount_base.sru
forward
global type u_drug_amount_base from statictext
end type
end forward

global type u_drug_amount_base from statictext
integer width = 613
integer height = 68
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
global u_drug_amount_base u_drug_amount_base

type variables
real amount
string unit
boolean WasModified
boolean zero_warning = false
end variables

forward prototypes
public subroutine set_amount (real pr_amount, string ps_unit)
public subroutine pretty_text ()
public subroutine round_amount (string ps_round_to)
public subroutine check_max_dose (long pl_frequency, real pr_administer_per_dose, string ps_admin_unit_id, real pr_max_dose_per_day, u_unit puo_max_dose_unit)
end prototypes

public subroutine set_amount (real pr_amount, string ps_unit);amount = pr_amount
unit = ps_unit
pretty_text()
end subroutine

public subroutine pretty_text ();text = f_pretty_amount_unit(amount, unit)

// Interpret the string back into the amount
amount = real(f_string_fraction_to_decimal(text))

textcolor = color_black
if amount <= 0 and zero_warning then
	backcolor = color_light_yellow
else
	backcolor = color_light_grey
end if


end subroutine

public subroutine round_amount (string ps_round_to);CHOOSE CASE ps_round_to
	CASE "WHOLE"
		amount = round(amount, 0)
		pretty_text()
	CASE "HALF"
		amount *= 2
		amount = round(amount, 0)
		amount /= 2
		pretty_text()
	CASE "QUARTER"
		amount *= 4
		amount = round(amount, 0)
		amount /= 4
		pretty_text()
END CHOOSE
end subroutine

public subroutine check_max_dose (long pl_frequency, real pr_administer_per_dose, string ps_admin_unit_id, real pr_max_dose_per_day, u_unit puo_max_dose_unit);real lr_dose_per_day
real lr_admin_per_day
string ls_temp
real lr_max_dose_per_day

if not isnull(puo_max_dose_unit) and isvalid(puo_max_dose_unit) then
	// Calculate the prescribed dose per day
	lr_dose_per_day = amount * pl_frequency
	
	// Convert the dose amount to admin amount
	lr_admin_per_day = lr_dose_per_day * pr_administer_per_dose
	
	// Get the max dose per day in the same unit of the package admin
	ls_temp = puo_max_dose_unit.convert(ps_admin_unit_id, string(pr_max_dose_per_day))
	if isnumber(ls_temp) then
		lr_max_dose_per_day = real(ls_temp)
		if lr_admin_per_day > lr_max_dose_per_day then
			openwithparm(w_pop_message, "This dose exceeds the specified maximum dose per day")
			backcolor = color_light_yellow
		end if
	end if
end if

end subroutine

on clicked;//str_drug_amount drug
//
//drug.amount = amount
//drug.unit = unit
//openwithparm(***popup window***, drug)
//if not isnull(message.powerobjectparm) then
//	custom = TRUE
//	drug = message.powerobjectparm
//	amount = drug.amount
//	unit = drug.unit
//	this.text = pretty_text(amount, unit)
//end if
//

WasModified = False
end on

on u_drug_amount_base.create
end on

on u_drug_amount_base.destroy
end on

