HA$PBExportHeader$u_drug_administration.sru
forward
global type u_drug_administration from statictext
end type
end forward

global type u_drug_administration from statictext
integer width = 1166
integer height = 132
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
event newadmin pbm_custom01
end type
global u_drug_administration u_drug_administration

type variables
integer administration_sequence[]
string administer_frequency[]
string administer_unit[]
real administer_amount[]
string mult_by_what[]
string calc_per[]
string frequency_description[]
integer daily_frequency[]
string admin_description[]
string administration[]
integer admin_count


end variables

forward prototypes
public function integer select_first_compatible (string ps_pkg_administer_unit)
public subroutine selectitem (integer pi_index)
public function integer selectadminsequence (integer pi_administration_sequence)
public function integer selectifcompatible (integer pi_item_number, string ps_pkg_administer_unit)
public function integer retrieve (string ps_drug_id, string ps_which_frequency)
end prototypes

public function integer select_first_compatible (string ps_pkg_administer_unit);real lr_temp
integer i

for i = 1 to admin_count
	if f_unit_convert(1, administer_unit[i], ps_pkg_administer_unit, lr_temp) > 0 then
		selectitem(i)
		return i
	end if
next 

return 0

end function

public subroutine selectitem (integer pi_index);if pi_index > 0 and pi_index <= admin_count then
	text = administration[pi_index]
else
	text = ""
end if
end subroutine

public function integer selectadminsequence (integer pi_administration_sequence);integer i

if pi_administration_sequence = 0 then
	selectitem(0)
	return 0
end if

for i = 1 to admin_count
	if administration_sequence[i] = pi_administration_sequence then
		selectitem(i)
		return i
	end if
next

return 0
end function

public function integer selectifcompatible (integer pi_item_number, string ps_pkg_administer_unit);real lr_temp

if f_unit_convert(1, administer_unit[pi_item_number], ps_pkg_administer_unit, lr_temp) > 0 then
	selectitem(pi_item_number)
	return 1
else
	return -1
end if
end function

public function integer retrieve (string ps_drug_id, string ps_which_frequency);integer i, li_sts
string ls_item, ls_administer_frequency, ls_pretty_fraction
real lr_converted_amount
real lr_dose_amount

 DECLARE lc_drug_administration CURSOR FOR  
  SELECT c_Drug_Administration.administration_sequence,   
         c_Drug_Administration.administer_frequency,   
         c_Drug_Administration.administer_unit,   
         c_Drug_Administration.administer_amount,   
         c_Drug_Administration.mult_by_what,   
         c_Drug_Administration.calc_per,   
         c_Administration_Frequency.description,   
         c_Administration_Frequency.frequency,
			c_Drug_Administration.description
    FROM c_Drug_Administration
		LEFT OUTER JOIN c_Administration_Frequency
		ON  c_Drug_Administration.administer_frequency = c_Administration_Frequency.administer_frequency
	WHERE c_Drug_Administration.drug_id = :ps_drug_id
	AND c_Drug_Administration.administer_frequency like :ls_administer_frequency
	ORDER BY c_Drug_Administration.administration_sequence;

if ps_which_frequency = "ALL" then
	ls_administer_frequency = "%"
else
	ls_administer_frequency = ps_which_frequency
end if

tf_begin_transaction(this, "retrieve(" + ps_drug_id + "," + ps_which_frequency + ")")
open lc_drug_administration;
if not tf_check() then return -1


admin_count = 0
i = 0
li_sts = 1

DO WHILE true
	i = i + 1
   FETCH lc_drug_administration   
    INTO :administration_sequence[i],   
         :administer_frequency[i],   
         :administer_unit[i],   
         :administer_amount[i],   
         :mult_by_what[i],   
         :calc_per[i],   
         :frequency_description[i],
			:daily_frequency[i],
			:admin_description[i];
	if not tf_check() then return -1

	if sqlca.sqlcode = 0 and sqlca.sqlnrows > 0 then
		admin_count = i
	else
		exit
	end if

LOOP

close lc_drug_administration;

tf_commit()

for i = 1 to admin_count
	ls_item = f_pretty_amount_unit(administer_amount[i], administer_unit[i])

	if not (isnull(mult_by_what[i]) or mult_by_what[i] = "") then 
		ls_item = ls_item + "/" + mult_by_what[i] + "/" + calc_per[i]
	end if

	ls_item = ls_item + "  " + administer_frequency[i]
	if not isnull(admin_description[i]) then
		ls_item = ls_item + "~n" + admin_description[i]
	end if

	administration[i] = ls_item
next

if admin_count = 0 then li_sts = 0

return li_sts
end function

on u_drug_administration.create
end on

on u_drug_administration.destroy
end on

