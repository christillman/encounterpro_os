$PBExportHeader$w_drug_treatment.srw
forward
global type w_drug_treatment from w_window_base
end type
type cb_done from commandbutton within w_drug_treatment
end type
type cb_cancel from commandbutton within w_drug_treatment
end type
type cb_continue from commandbutton within w_drug_treatment
end type
type st_prn from statictext within w_drug_treatment
end type
type st_refills from statictext within w_drug_treatment
end type
type dw_instructions from datawindow within w_drug_treatment
end type
type st_package from statictext within w_drug_treatment
end type
type st_dose from statictext within w_drug_treatment
end type
type st_mult_display from statictext within w_drug_treatment
end type
type st_take_as_directed from statictext within w_drug_treatment
end type
type st_max_dose from statictext within w_drug_treatment
end type
type pb_whole from picturebutton within w_drug_treatment
end type
type uo_drug_administration from u_drug_administration within w_drug_treatment
end type
type uo_drug_package from u_drug_package within w_drug_treatment
end type
type st_4 from statictext within w_drug_treatment
end type
type uo_administer_frequency from u_administer_frequency within w_drug_treatment
end type
type uo_duration from u_duration_amount within w_drug_treatment
end type
type st_dosebase from statictext within w_drug_treatment
end type
type st_3 from statictext within w_drug_treatment
end type
type st_2 from statictext within w_drug_treatment
end type
type st_1 from statictext within w_drug_treatment
end type
type uo_dispense_office from u_dispense_amount within w_drug_treatment
end type
type uo_dose from u_dose_amount within w_drug_treatment
end type
type uo_dispense from u_dispense_amount within w_drug_treatment
end type
type gb_1 from groupbox within w_drug_treatment
end type
type st_drug from statictext within w_drug_treatment
end type
type st_brand_name_required_title from statictext within w_drug_treatment
end type
type st_brand_name_required from statictext within w_drug_treatment
end type
type st_frequency_title from statictext within w_drug_treatment
end type
type st_duration_title from statictext within w_drug_treatment
end type
type st_route from statictext within w_drug_treatment
end type
type shl_drug from statichyperlink within w_drug_treatment
end type
type st_link from statictext within w_drug_treatment
end type
type uo_route from u_administer_method within w_drug_treatment
end type
end forward

global type w_drug_treatment from w_window_base
integer height = 1840
windowtype windowtype = response!
string button_type = "COMMAND"
integer max_buttons = 2
cb_done cb_done
cb_cancel cb_cancel
cb_continue cb_continue
st_prn st_prn
st_refills st_refills
dw_instructions dw_instructions
st_package st_package
st_dose st_dose
st_mult_display st_mult_display
st_take_as_directed st_take_as_directed
st_max_dose st_max_dose
pb_whole pb_whole
uo_drug_administration uo_drug_administration
uo_drug_package uo_drug_package
st_4 st_4
uo_administer_frequency uo_administer_frequency
uo_duration uo_duration
st_dosebase st_dosebase
st_3 st_3
st_2 st_2
st_1 st_1
uo_dispense_office uo_dispense_office
uo_dose uo_dose
uo_dispense uo_dispense
gb_1 gb_1
st_drug st_drug
st_brand_name_required_title st_brand_name_required_title
st_brand_name_required st_brand_name_required
st_frequency_title st_frequency_title
st_duration_title st_duration_title
st_route st_route
shl_drug shl_drug
st_link st_link
uo_route uo_route
end type
global w_drug_treatment w_drug_treatment

type variables

// Passed in properties
string drug_id
string form_rxcui
string package_id
string pharmacist_instructions
string patient_instructions
string brand_name_required
real dispense_amount
real office_dispense_amount
string dispense_unit
real dose_amount
string dose_unit
long administration_sequence
string administer_frequency
real duration_amount
string duration_unit
string duration_prn
integer refills

// Calculated properties
real default_duration_amount
string default_duration_unit
string default_duration_prn
real max_dose_per_day
u_unit max_dose_unit
integer package_list_index = 0
integer drug_admin_index = 0
integer last_package_list_index = 0
boolean    package_selected
boolean    dispense_selected
string		 prev_patient_instructions,prev_pharmacist_instructions
boolean prev_dispense_qs

/* reference to treatment component */
u_component_treatment      treat_medication
u_component_service							service
end variables

forward prototypes
public subroutine recalcdose ()
public function integer select_best_package (string ps_dosage_form)
public subroutine recalcdose_old ()
public function integer load_default_drug_instructions (string ps_drug_id, string ps_package_id, integer pi_administration_sequence)
public function integer display_instructions ()
public subroutine set_default_instruction ()
public subroutine edit_instruction (string ps_progress_key)
public function integer set_drug ()
public subroutine load_medication ()
public function integer save_changes ()
public function integer load_defaults ()
public function string get_patient_weight ()
public subroutine check_max_dose ()
end prototypes

public subroutine recalcdose ();integer i, j
real lr_dose_amount
string ls_mult_display

if not uo_dose.visible then return

ls_mult_display = ""

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
										ls_mult_display, &
										lr_dose_amount)
	uo_dose.set_amount(lr_dose_amount, uo_drug_package.dose_unit[package_list_index])
elseif package_list_index > 0 then
	i = package_list_index
	if isnull(uo_dose.amount) or uo_dose.amount <= 0 then
		uo_dose.set_amount(0, uo_drug_package.dose_unit[i])
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

if not dispense_selected then
	i = uo_administer_frequency.current_frequency
	if i > 0 then
		uo_dispense.calc_amount(uo_dose.amount, &
										uo_dose.unit, &
										uo_administer_frequency.frequencies[i].frequency, &
										uo_duration.amount, &
										uo_duration.unit &
										)
	end if
end if

if isnull(ls_mult_display) or trim(ls_mult_display) = "" then
	st_mult_display.text = get_patient_weight()
else
	st_mult_display.text = ls_mult_display
end if


end subroutine

public function integer select_best_package (string ps_dosage_form);integer i, j, li_best_package, li_first, li_last
real lr_best_amount, lr_dose_amount
string ls_mult_display

setnull(ls_mult_display)
setnull(lr_best_amount)
li_best_package = 0

// CDT: Override admin selection below for formulation selection
// Find package matching the selected formulation
for i = 1 to uo_drug_package.package_count
	if lower(uo_drug_package.form_rxcui[i]) <> lower(form_rxcui) then continue
	li_best_package = i
	exit
next

if li_best_package > 0 then return li_best_package


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
										ls_mult_display, &
										lr_dose_amount)
	if isnull(lr_best_amount) then
		lr_best_amount = lr_dose_amount
		li_best_package = i
	elseif abs(lr_dose_amount - 1) < abs(lr_best_amount - 1) then
		lr_best_amount = lr_dose_amount
		li_best_package = i
	end if
next

if isnull(ls_mult_display) or trim(ls_mult_display) = "" then
	st_mult_display.text = get_patient_weight()
else
	st_mult_display.text = ls_mult_display
end if

return li_best_package


end function

public subroutine recalcdose_old ();integer i, j, li_best_package, li_first, li_last
real lr_best_amount, lr_dose_amount
string ls_dosage_form

setnull(lr_best_amount)
li_best_package = 0

if drug_admin_index > 0 and package_list_index > 0 then
	if package_selected then
		li_first = package_list_index
		li_last = package_list_index
	else
		li_first = 1
		li_last = uo_drug_package.package_count
	end if
	j = drug_admin_index
	ls_dosage_form = uo_drug_package.dosage_form[package_list_index]
	for i = li_first to li_last
		if uo_drug_package.dosage_form[i] <> ls_dosage_form then continue
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
		elseif uo_dose.amount >= 1 and lr_best_amount >= 1 then
			if lr_dose_amount < lr_best_amount then
				lr_best_amount = lr_dose_amount
				li_best_package = i
			end if
		elseif lr_dose_amount < 1 and lr_best_amount >= 1 then
			if lr_dose_amount >= 0.5 and lr_best_amount > 1.5 then
				lr_best_amount = lr_dose_amount
				li_best_package = i
			end if
		elseif lr_dose_amount >= 1 and lr_best_amount < 1 then
			if lr_dose_amount <= 1.5 or (lr_best_amount < .5 and lr_dose_amount <= 2) then
				lr_best_amount = lr_dose_amount
				li_best_package = i
			end if
		elseif lr_dose_amount < 1 and lr_best_amount < 1 then
			if lr_dose_amount > lr_best_amount then
				lr_best_amount = lr_dose_amount
				li_best_package = i
			end if
		end if
	next
	package_list_index = li_best_package
	uo_drug_package.selectitem(li_best_package)
	uo_dose.set_amount(lr_best_amount, uo_drug_package.dose_unit[li_best_package])
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

if not dispense_selected then
	i = uo_administer_frequency.current_frequency
	if i > 0 then
		uo_dispense.calc_amount(uo_dose.amount, &
										uo_dose.unit, &
										uo_administer_frequency.frequencies[i].frequency, &
										uo_duration.amount, &
										uo_duration.unit &
										)
	end if
end if


end subroutine

public function integer load_default_drug_instructions (string ps_drug_id, string ps_package_id, integer pi_administration_sequence);string ls_instruction_for, ls_instruction
string ls_pharmacist, ls_patient
boolean lb_loop

 DECLARE lc_inst_drug CURSOR FOR  
  SELECT c_Drug_Instruction.instruction_for,   
         c_Drug_Instruction.instruction  
    FROM c_Drug_Instruction (NOLOCK)
   WHERE c_Drug_Instruction.drug_id = :ps_drug_id
	AND	c_Drug_Instruction.package_id is null
	AND	c_Drug_Instruction.administration_sequence is null
	AND	c_Drug_Instruction.default_flag = 'Y';

 DECLARE lc_inst_pkg CURSOR FOR  
  SELECT c_Drug_Instruction.instruction_for,   
         c_Drug_Instruction.instruction  
    FROM c_Drug_Instruction (NOLOCK)
   WHERE c_Drug_Instruction.drug_id = :ps_drug_id
	AND	c_Drug_Instruction.package_id = :ps_package_id
	AND	c_Drug_Instruction.administration_sequence is null
	AND	c_Drug_Instruction.default_flag = 'Y';

 DECLARE lc_inst_admin CURSOR FOR  
  SELECT c_Drug_Instruction.instruction_for,   
         c_Drug_Instruction.instruction  
    FROM c_Drug_Instruction (NOLOCK)
   WHERE c_Drug_Instruction.drug_id = :ps_drug_id
	AND	c_Drug_Instruction.administration_sequence = :pi_administration_sequence
	AND	c_Drug_Instruction.package_id is null
	AND	c_Drug_Instruction.default_flag = 'Y';


tf_begin_transaction(this, "retrieve_default()")

setnull(ls_pharmacist)
setnull(ls_patient)

// Drug-based instructions
OPEN lc_inst_drug;
if not tf_check() then return -1

lb_loop = true

DO
	FETCH	lc_inst_drug INTO
		:ls_instruction_for,
		:ls_instruction;
	if not tf_check() then return -1

	if sqlca.sqlcode = 0 and sqlca.sqlnrows > 0 then
		if ls_instruction_for = "D" then
			if isnull(ls_pharmacist) then
				ls_pharmacist = ls_instruction
			else
				ls_pharmacist += "~n" + ls_instruction
			end if
		else
			if isnull(ls_patient) then
				ls_patient = ls_instruction
			else
				ls_patient += "~n" + ls_instruction
			end if
		end if
	else
		lb_loop = false
	end if
LOOP WHILE lb_loop

CLOSE lc_inst_drug;


// Package-based instructions
OPEN lc_inst_pkg;
if not tf_check() then return -1

lb_loop = true

DO
	FETCH	lc_inst_pkg INTO
		:ls_instruction_for,
		:ls_instruction;
	if not tf_check() then return -1

	if sqlca.sqlcode = 0 and sqlca.sqlnrows > 0 then
		if ls_instruction_for = "D" then
			if isnull(ls_pharmacist) then
				ls_pharmacist = ls_instruction
			else
				ls_pharmacist += "~n" + ls_instruction
			end if
		else
			if isnull(ls_patient) then
				ls_patient = ls_instruction
			else
				ls_patient += "~n" + ls_instruction
			end if
		end if
	else
		lb_loop = false
	end if
LOOP WHILE lb_loop

CLOSE lc_inst_pkg;


// Drug Administration-based instructions
OPEN lc_inst_admin;
if not tf_check() then return -1

lb_loop = true

DO
	FETCH	lc_inst_admin INTO
		:ls_instruction_for,
		:ls_instruction;
	if not tf_check() then return -1

	if sqlca.sqlcode = 0 and sqlca.sqlnrows > 0 then
		if ls_instruction_for = "D" then
			if isnull(ls_pharmacist) then
				ls_pharmacist = ls_instruction
			else
				ls_pharmacist += "~n" + ls_instruction
			end if
		else
			if isnull(ls_patient) then
				ls_patient = ls_instruction
			else
				ls_patient += "~n" + ls_instruction
			end if
		end if
	else
		lb_loop = false
	end if
LOOP WHILE lb_loop

CLOSE lc_inst_admin;

tf_commit()

pharmacist_instructions = ls_pharmacist
patient_instructions = ls_patient

return 1

end function

public function integer display_instructions ();string ls_temp

ls_temp = ""

if not isnull(pharmacist_instructions) and trim(pharmacist_instructions) <> "" then
	ls_temp = "Pharmacist: " + trim(pharmacist_instructions)
end if

if not isnull(patient_instructions) and trim(patient_instructions) <> "" then
	if ls_temp = "" then
		ls_temp = "Patient: " + trim(patient_instructions)
	else
		ls_temp += "~nPatient: " + trim(patient_instructions)
	end if
end if
// Check whether to override the previous instructions
dw_instructions.reset()
If Len(ls_temp) > 0 Then
//	dw_instructions.reset()
	dw_instructions.insertrow(0)
	dw_instructions.setitem(1, "instruction", ls_temp)
Else
//	patient_instructions = treat_medication.patient_instructions
//	pharmacist_instructions = treat_medication.pharmacist_instructions
End If
Return 1

end function

public subroutine set_default_instruction ();str_popup popup
str_popup_return popup_return
string ls_instruction_for
string ls_instruction_id
string ls_package_id
integer li_administration_sequence
string ls_instruction
integer i
string ls_temp
string lsa_which[]
string ls_setclear,ls_null

Setnull(ls_null)

popup.data_row_count = 4
popup.items[1] = "Clear Default Patient Instruction"
popup.items[2] = "Set Default Patient Instruction"
popup.items[3] = "Clear Default Pharmacist Instruction"
popup.items[4] = "Set Default Pharmacist Instruction"
	
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

Choose Case popup_return.item_indexes[1]
	Case 1
		ls_instruction_for = "P"
		ls_instruction = ls_null
		ls_setclear = "Clear"
	Case 2
		ls_instruction_for = "P"
		ls_instruction = patient_instructions
		ls_setclear = "Set"
	Case 3
		ls_instruction_for = "D"
		ls_instruction = ls_null
		ls_setclear = "Clear"
	Case 4
		ls_instruction_for = "D"
		ls_instruction = pharmacist_instructions
		ls_setclear = "Set"
End Choose

popup.data_row_count = 1
popup.items[1] = ls_setclear + " Default for Drug"
lsa_which[1] = "DRUG"

if package_list_index > 0 then
	popup.data_row_count += 1
	lsa_which[popup.data_row_count] = "PACKAGE"
	popup.items[popup.data_row_count] = ls_setclear + " Default for Drug/Package"
end if

if drug_admin_index > 0 then
	popup.data_row_count += 1
	lsa_which[popup.data_row_count] = "ADMIN"
	popup.items[popup.data_row_count] = ls_setclear + " Default for Drug/Administration"
end if

if isnull(ls_instruction) then
	popup.data_row_count += 1
	lsa_which[popup.data_row_count] = "ALL"
	popup.items[popup.data_row_count] = "Clear Default for ALL"
end if

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

setnull(ls_instruction_id)
setnull(ls_package_id)
setnull(li_administration_sequence)

CHOOSE CASE lsa_which[popup_return.item_indexes[1]]
	CASE "DRUG"
		DELETE FROM c_Drug_Instruction
		WHERE drug_id = :drug_id
		AND default_flag = 'Y'
		AND instruction_for = :ls_instruction_for
		AND package_id IS NULL
		AND administration_sequence IS NULL;
		if not tf_check() then return
	CASE "PACKAGE"
		ls_package_id = uo_drug_package.package_id[package_list_index]
		DELETE FROM c_Drug_Instruction
		WHERE drug_id = :drug_id
		AND default_flag = 'Y'
		AND instruction_for = :ls_instruction_for
		AND package_id = :ls_package_id
		AND administration_sequence IS NULL;
		if not tf_check() then return
	CASE "ADMIN"
		li_administration_sequence = uo_drug_administration.administration_sequence[drug_admin_index]
		DELETE FROM c_Drug_Instruction
		WHERE drug_id = :drug_id
		AND default_flag = 'Y'
		AND instruction_for = :ls_instruction_for
		AND package_id IS NULL
		AND administration_sequence = :li_administration_sequence;
		if not tf_check() then return
	CASE "ALL"
		DELETE FROM c_Drug_Instruction
		WHERE drug_id = :drug_id
		AND default_flag = 'Y'
		AND instruction_for = :ls_instruction_for;
		if not tf_check() then return
END CHOOSE

if not isnull(ls_instruction) then
	i = 1
	DO
		ls_instruction_id = drug_id + string(i)
		SELECT instruction_id
		INTO :ls_temp
		FROM c_Drug_Instruction
		WHERE instruction_id = :ls_instruction_id;
		if not tf_check() then return
		if sqlca.sqlcode = 100 then EXIT
		i += 1
		if i > 100 then return
	LOOP WHILE true
	
	INSERT INTO c_Drug_Instruction (
		instruction_id,
		drug_id,
		package_id,
		administration_sequence,
		default_flag,
		instruction,
		instruction_for)
	VALUES (
		:ls_instruction_id,
		:drug_id,
		:ls_package_id,
		:li_administration_sequence,
		'Y',
		:ls_instruction,
		:ls_instruction_for);
	if not tf_check() then return
end if
end subroutine

public subroutine edit_instruction (string ps_progress_key);str_popup popup
str_popup_return popup_return
string ls_ins
long ll_row

popup.data_row_count = 3
popup.items[1] = ps_progress_key + "_" + treat_medication.treatment_type + "_" + treat_medication.drug_id
popup.items[2] = ps_progress_key + "_" + treat_medication.treatment_type
if ps_progress_key = "Patient Instructions" then
	popup.title = "Patient Instructions For "
	popup.items[3] = patient_instructions
else
	popup.title = "Pharmacist Instructions For "
	popup.items[3] = pharmacist_instructions
end if
popup.title += treat_medication.treatment_description

openwithparm(w_progress_note_edit, popup)
popup_return = message.powerobjectparm
If popup_return.item_count = 2 then
	If trim(popup_return.items[1]) = "" then
		setnull(ls_ins)
	else
		ls_ins = popup_return.items[1]
	end if
ElseIf popup_return.item_count = 0 then
	Setnull(ls_ins)
Else
	Return
End If
if ps_progress_key = "Patient Instructions" then
	patient_instructions = ls_ins
else
	pharmacist_instructions = ls_ins
end if
display_instructions()

end subroutine

public function integer set_drug ();integer li_count, i, j, li_sts
string ls_null, ls_unit
string ls_dea_number_required, ls_generic_name

setnull(ls_null)

log.log(this, "w_drug_treatment.set_drug:0007", drug_id, 1)

// Get the name and default duration
li_sts = tf_get_drug(drug_id, &
							st_drug.text, &
							ls_generic_name, &
							default_duration_amount, &
							default_duration_unit, &
							default_duration_prn, &
							max_dose_per_day, &
							ls_unit, &
							ls_dea_number_required)
if li_sts <= 0 then
	if li_sts = 0 then 
		log.log(this, "w_drug_treatment.set_drug:0021","Invalid Drug ID (" + drug_id + ")", 4)
	else
		log.log(this, "w_drug_treatment.set_drug:0023","Database connection failed searching for " + drug_id, 4)
	end if
	return li_sts
end if

shl_drug.text = st_drug.text
// DailyMed link
shl_drug.url = "https://dailymed.nlm.nih.gov/dailymed/search.cfm?query=" + st_drug.text
// RXNORM link
// "https://mor.nlm.nih.gov/RxNav/search?searchBy=String&searchTerm=" + st_drug.text

max_dose_unit = unit_list.find_unit(ls_unit)
st_max_dose.text = ""
if not isnull(max_dose_unit) then
	// Ciru says we should review max doses at some point in the future. For now, don't display
	// st_max_dose.text = "Max Dose = " + f_pretty_amount_unit(max_dose_per_day, max_dose_unit.unit_id) + " / Day"
end if

// Get the package list for this drug
li_count = uo_drug_package.retrieve(drug_id)
if li_count <= 0 then
	messagebox("w_drug_treatment.set_drug:0044","This drug (" +drug_id  + ") has no packages defined, or the packages have no dose_unit.")
	return -1
end if

// for now, retrieve the formulation which was specified
// This means another formulation can't be chosen with uo_drug_package
package_list_index = uo_drug_package.selectformulation(form_rxcui)
if package_list_index <= 0 then
	messagebox("w_drug_treatment.set_drug:0052","This formulation (" +form_rxcui + ") has no packages defined, or the packages have no dose_unit.")
	return -1
end if


// Get the admin list for this drug
// CDT 8/4/2020, Avoid messing with administrations for now
// li_count = uo_drug_administration.retrieve(drug_id, "ALL")

Return 1
end function

public subroutine load_medication ();integer li_count, i, j, li_sts
string ls_null
str_progress lstr_progress
string ls_is_qs
string ls_dispense_unit
real lr_null

setnull(ls_null)
setnull(lr_null)

package_list_index = uo_drug_package.selectpackage(treat_medication.package_id)
package_selected = NOT (package_list_index = 0)
If package_selected Then
	// package ID exists, then set it.
	// these 2 lines came from w_svc_drug_treatment_edit and w_drug_admin_edit 22/7/2023
	uo_dose.set_amount(lr_null, uo_drug_package.dose_unit[package_list_index])
	uo_drug_package.event trigger newpackage()
End if

package_list_index = select_best_package(treat_medication.dosage_form)
package_selected = NOT (package_list_index = 0)
If package_selected Then
	uo_drug_package.selectitem(package_list_index)
End If

// have the user pick a package, if form_rxcui not yet populated
IF IsNull(form_rxcui) OR form_rxcui = "" THEN
	uo_drug_package.event post clicked()
END IF

// Set the route list
uo_route.set_package(treat_medication.package_id)

// Determine the dispense amount/unit
ls_dispense_unit = treat_medication.dispense_unit
if isnull(ls_dispense_unit) then
	if package_list_index > 0 then
		ls_dispense_unit = uo_drug_package.default_dispense_unit[package_list_index]
	end if
end if

If Isnull(treat_medication.dispense_amount) Then
	ls_is_qs = f_get_progress_value(current_patient.cpr_id, &
												"Treatment", &
												treat_medication.treatment_id, &
												"Property", &
												"Dispense QS")
	uo_dispense.is_qs = f_string_to_boolean(ls_is_qs)
	dispense_selected = False
Else
	uo_dispense.is_qs = false
	dispense_selected = True
End if

uo_dispense.set_amount(treat_medication.dispense_amount, ls_dispense_unit)
uo_dispense_office.set_amount(treat_medication.office_dispense_amount, ls_dispense_unit)

// Save the initial dispense_qs setting so we know if it changes
prev_dispense_qs = uo_dispense.is_qs

uo_drug_package.triggerevent("newpackage")

// If there is no dose amount, then set the drug administration to the one specified
// in the medication object.
If isnull(treat_medication.dose_amount) then
	drug_admin_index = uo_drug_administration.selectadminsequence(&
											treat_medication.administration_sequence)
	uo_drug_administration.triggerevent("newadmin")
	// CDT 30/3/2020
	// Ciru wants the dose blank to start with, to make the clinician enter it.
	uo_dose.set_amount(0, treat_medication.dose_unit)
Else
	// If there is a dose amount then load it.
	uo_dose.set_amount(treat_medication.dose_amount, treat_medication.dose_unit)
	drug_admin_index = uo_drug_administration.selectadminsequence(&
											treat_medication.administration_sequence)
End if

// Load all the other stuff
If Not isnull(treat_medication.administer_frequency) Then &
	uo_administer_frequency.set_frequency(treat_medication.administer_frequency)

If Not isnull(treat_medication.route) Then &
	uo_route.set_method(treat_medication.route)

uo_duration.set_amount(	treat_medication.duration_amount, &
								treat_medication.duration_unit, &
								treat_medication.duration_prn )

// By Sumathi Chinnasamy On 12/08/99
// Set refill text 
If Isnull(treat_medication.refills) Then treat_medication.refills = 0
refills = treat_medication.refills
CHOOSE CASE treat_medication.refills
	CASE 0
		st_refills.text = "No Refills"
		st_refills.backcolor = color_object_selected
	CASE -1
		st_prn.backcolor = color_object_selected
	CASE ELSE
		st_refills.text = String(treat_medication.refills)+" Refills"
		st_refills.backcolor = color_object_selected
END CHOOSE

if treat_medication.brand_name_required = "Y" then
	brand_name_required = "Y"
	st_brand_name_required.text = "Yes"
else
	brand_name_required = "N"
	st_brand_name_required.text = "No"
end if

//uo_procedure.set_value(medication.procedure_id)

// Load the special instructions
pharmacist_instructions = f_get_progress_value(current_patient.cpr_id, &
																"Treatment", &
																treat_medication.treatment_id, &
																"Instructions", &
																"Pharmacist Instructions")


patient_instructions = f_get_progress_value(current_patient.cpr_id, &
																"Treatment", &
																treat_medication.treatment_id, &
																"Instructions", &
																"Patient Instructions")

display_instructions()

// this is used to compare whether progress needs to be updated
prev_patient_instructions = patient_instructions
prev_pharmacist_instructions = pharmacist_instructions

recalcdose()
end subroutine

public function integer save_changes ();String	ls_description
Integer	li_sts
str_attributes lstr_attributes
string ls_null
long ll_old_treatment_id
str_treatment_description lstr_treatment
string ls_dosing_directions
string ls_admin_directions

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
lstr_attributes.attribute[lstr_attributes.attribute_count].attribute = "form_rxcui"
lstr_attributes.attribute[lstr_attributes.attribute_count].value = form_rxcui

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

lstr_attributes.attribute_count += 1
lstr_attributes.attribute[lstr_attributes.attribute_count].attribute = "administer_frequency"
lstr_attributes.attribute[lstr_attributes.attribute_count].value = uo_administer_frequency.administer_frequency

lstr_attributes.attribute_count += 1
lstr_attributes.attribute[lstr_attributes.attribute_count].attribute = "route"
lstr_attributes.attribute[lstr_attributes.attribute_count].value = uo_route.method

lstr_attributes.attribute_count += 1
lstr_attributes.attribute[lstr_attributes.attribute_count].attribute = "dispense_amount"
if uo_dispense.amount <= 0 or isnull(uo_dispense.unit) then
	lstr_attributes.attribute[lstr_attributes.attribute_count].value = ls_null
else
	lstr_attributes.attribute[lstr_attributes.attribute_count].value = String(uo_dispense.amount)
end if

lstr_attributes.attribute_count += 1
lstr_attributes.attribute[lstr_attributes.attribute_count].attribute = "office_dispense_amount"
if uo_dispense_office.amount <= 0 or isnull(uo_dispense.unit) then
	lstr_attributes.attribute[lstr_attributes.attribute_count].value = ls_null
else
	lstr_attributes.attribute[lstr_attributes.attribute_count].value = String(uo_dispense_office.amount)
end if

lstr_attributes.attribute_count += 1
lstr_attributes.attribute[lstr_attributes.attribute_count].attribute = "dispense_unit"
lstr_attributes.attribute[lstr_attributes.attribute_count].value = uo_dispense.unit

// Update Dispense QS property if it changed
If prev_dispense_qs <> uo_dispense.is_qs then
	lstr_attributes.attribute_count += 1
	lstr_attributes.attribute[lstr_attributes.attribute_count].attribute = "Dispense QS"
	lstr_attributes.attribute[lstr_attributes.attribute_count].value = f_boolean_to_string(uo_dispense.is_qs)
End If

lstr_attributes.attribute_count += 1
lstr_attributes.attribute[lstr_attributes.attribute_count].attribute = "duration_amount"
lstr_attributes.attribute[lstr_attributes.attribute_count].value = String(uo_duration.amount)

lstr_attributes.attribute_count += 1
lstr_attributes.attribute[lstr_attributes.attribute_count].attribute = "duration_unit"
lstr_attributes.attribute[lstr_attributes.attribute_count].value = uo_duration.unit

lstr_attributes.attribute_count += 1
lstr_attributes.attribute[lstr_attributes.attribute_count].attribute = "duration_prn"
lstr_attributes.attribute[lstr_attributes.attribute_count].value = uo_duration.prn

lstr_attributes.attribute_count += 1
lstr_attributes.attribute[lstr_attributes.attribute_count].attribute = "brand_name_required"
lstr_attributes.attribute[lstr_attributes.attribute_count].value = brand_name_required

lstr_attributes.attribute_count += 1
lstr_attributes.attribute[lstr_attributes.attribute_count].attribute = "refills"
lstr_attributes.attribute[lstr_attributes.attribute_count].value = String(refills)


// First map the attributes to data columns
treat_medication.updated = false
treat_medication.map_attr_to_data_columns(lstr_attributes)

// If the updated flag is true then something changed and we have to update the treatment
ll_old_treatment_id = treat_medication.treatment_id
if treat_medication.updated then
	lstr_treatment = treat_medication.treatment_description()

	treat_medication.treatment_description =  drugdb.treatment_drug_sig(lstr_treatment)
	li_sts = current_patient.treatments.update_treatment(treat_medication)
	if li_sts < 0 then return -1
	
	// Update the "Directions" properties
	ls_dosing_directions = drugdb.treatment_dosing_description(lstr_treatment)
	li_sts = current_patient.treatments.set_treatment_progress(treat_medication.treatment_id, "Instructions", "Dosing Instructions", ls_dosing_directions)
	if li_sts < 0 then return -1

	ls_admin_directions = drugdb.treatment_admin_description(lstr_treatment)
	li_sts = current_patient.treatments.set_treatment_progress(treat_medication.treatment_id, "Instructions", "Admin Instructions", ls_admin_directions)
	if li_sts < 0 then return -1
end if



If trim(pharmacist_instructions) = "" Then setnull(pharmacist_instructions)
If trim(patient_instructions) = "" Then setnull(patient_instructions)

// Set the pharmacist instructions if it's modified
If prev_pharmacist_instructions <> pharmacist_instructions &
	OR (isnull(prev_pharmacist_instructions) And Not isnull(pharmacist_instructions)) &
	OR (isnull(pharmacist_instructions) And Not isnull(prev_pharmacist_instructions)) &
	OR ll_old_treatment_id <> treat_medication.treatment_id Then
	li_sts = current_patient.treatments.set_treatment_progress(treat_medication.treatment_id, "Instructions", "Pharmacist Instructions", pharmacist_instructions)
End If

// Update patient instructions if it's modified
If prev_patient_instructions <> patient_instructions &
	OR (isnull(prev_patient_instructions) And Not isnull(patient_instructions)) &
	 OR (isnull(patient_instructions) And Not isnull(prev_patient_instructions)) &
	OR ll_old_treatment_id <> treat_medication.treatment_id Then
	li_sts = current_patient.treatments.set_treatment_progress(treat_medication.treatment_id, "Instructions", "Patient Instructions", patient_instructions)
End If

return 1




end function

public function integer load_defaults ();///////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description: 
//
// Created By:Mark																				Creation dt: 
//
// Modified By:Sumathi Chinnasamy															Modified On:03/14/2000
///////////////////////////////////////////////////////////////////////////////////////////////////////

Integer i, li_sts
string ls_instruction
string ls_instruction_for
string ls_package_id, ls_dispense_unit
integer li_admin_sequence

brand_name_required = "N"
st_brand_name_required.text = "No"

package_selected    = False
dispense_selected   = false
package_list_index  = 0
drug_admin_index    = 0

If uo_drug_package.package_count > 0 Then
	// CDT 31/3/2020
	// If we have already selected a formulation (package)
	// then cut to the chase
	If Not IsNull(form_rxcui) AND form_rxcui <> "" Then
		package_list_index = uo_drug_package.selectformulation(form_rxcui)
		
	Else	
		If Isnull(treat_medication.administration_sequence) Then
			If Not Isnull(treat_medication.dosage_form) Then
				// Set the package from the dosage form and pick a compatible administration
				package_list_index = uo_drug_package.selectdosageform(treat_medication.dosage_form)
				If package_list_index > 0 Then
					drug_admin_index = uo_drug_administration.select_first_compatible(&
													uo_drug_package.pkg_administer_unit[package_list_index])
				End if
			Else
				// No dosage form supplied, so look for the first
				// package which has a compatible administration
				For i = 1 To uo_drug_package.package_count
					drug_admin_index = uo_drug_administration.select_first_compatible(&
																			uo_drug_package.pkg_administer_unit[i])
					If drug_admin_index > 0 Then
						package_list_index = uo_drug_package.selectpackage(uo_drug_package.package_id[i])
						Exit
					End if
				Next
				// If there are no packages with compatible administrations, just pick the first
				If package_list_index <= 0 Then
					package_list_index = uo_drug_package.selectpackage(uo_drug_package.package_id[1])
				End if
			End if
		Else
			drug_admin_index = uo_drug_administration.selectadminsequence(&
														treat_medication.administration_sequence)
			package_list_index = select_best_package(treat_medication.dosage_form)
			uo_drug_package.selectitem(package_list_index)
		End if
	End If
End If

If package_list_index = 0 Then
	uo_drug_package.selectpackage("")
End if

If drug_admin_index = 0 Then
	// CDT 7/4/2020
	// Disabling this for now, we are selecting a formulation without an administration
	// uo_drug_administration.selectadminsequence(0)
End if

// Ciru says don't set duration when window is opening
// uo_duration.set_amount(	default_duration_amount, &
//								default_duration_unit, &
//								default_duration_prn)
//								
// Determine the dispense amount/unit
ls_dispense_unit = treat_medication.dispense_unit
if isnull(ls_dispense_unit) then
	if package_list_index > 0 then
		// Ciru says don't set total dispense when window is opening
		// ls_dispense_unit = uo_drug_package.default_dispense_unit[package_list_index]
	end if
end if

// CDT 7/4/2020
// Disabling this for now, we are selecting a formulation without an administration
// uo_drug_administration.triggerevent("newadmin")
uo_drug_package.triggerevent("newpackage")

recalcdose()

// Set refills text
If Isnull(treat_medication.refills) Then treat_medication.refills = 0
refills = treat_medication.refills
Choose Case refills
	Case 0
		st_refills.text = "No Refills"
		st_refills.backcolor = color_object_selected
	Case -1
		st_prn.backcolor = color_object_selected
	Case Else
		st_refills.text = String(refills)+" Refills"
		st_refills.backcolor = color_object_selected
End Choose
//---

// Load the default instructions
setnull(prev_patient_instructions)
setnull(prev_pharmacist_instructions)
setnull(patient_instructions)
setnull(pharmacist_instructions)

if package_list_index > 0 then
	ls_package_id = uo_drug_package.package_id[package_list_index]
else
	setnull(ls_package_id)
end if
if drug_admin_index > 0 Then
	li_admin_sequence = uo_drug_administration.administration_sequence[drug_admin_index]
else
	setnull(li_admin_sequence)
end if
load_default_drug_instructions(drug_id, ls_package_id, li_admin_sequence)

uo_route.set_package(ls_package_id)

display_instructions()


Return 1
end function

public function string get_patient_weight ();u_unit luo_unit
integer li_sts
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
string ls_weight

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
//CWW, END


// This hard-coded observation_id/result_sequence must be changed to soft-coded
ls_observation_id = "WGT"
li_result_sequence = -1
ls_location = "NA"
ls_weight = ""

//CWW, BEGIN
//EXECUTE lsp_get_last_result;
//if not tf_check() then return ls_weight
//FETCH lsp_get_last_result INTO :ls_location,
//										:li_result_sequence, 
//										:ll_observation_sequence,
//										:ls_result,
//										:ls_result_amount_flag,
//										:ldt_result_date_time,
//										:ls_result_value,
//										:ls_result_unit;
//if not tf_check() then return ls_weight
//CLOSE lsp_get_last_result;

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
if isnull(li_result_sequence) then return ls_weight

luo_unit = unit_list.find_unit(ls_result_unit)
if isnull(luo_unit) then return ls_weight

ls_weight = luo_unit.pretty_amount_unit(lr_result_amount)

if date(ldt_result_date_time) = today() then
	ls_display_date = "Today"
else
	ls_display_date = string(date(ldt_result_date_time)) + " - " + f_pretty_age(date(ldt_result_date_time), today()) + " Ago"
end if

ls_weight = ls_weight + "  " + ls_display_date

return ls_weight

end function

public subroutine check_max_dose ();integer i, j
long ll_frequency
real lr_dose_per_day
real lr_admin_per_day
string ls_temp
real lr_max_dose_per_day

// Ciru says we should review max doses at some point in the future. For now, don't display
RETURN

i = uo_administer_frequency.current_frequency
if i > 0 then
	ll_frequency = uo_administer_frequency.frequencies[i].frequency
else
	ll_frequency = 1
end if

j = package_list_index
if not isnull(max_dose_unit) and j > 0 then
	// Calculate the prescribed dose per day
	lr_dose_per_day = uo_dose.amount * ll_frequency
	
	// Convert the dose amount to admin amount
	lr_admin_per_day = lr_dose_per_day * uo_drug_package.administer_per_dose[j]
	
	// Get the max dose per day in the same unit of the package admin
	ls_temp = max_dose_unit.convert(uo_drug_package.pkg_administer_unit[j], string(max_dose_per_day))
	if isnumber(ls_temp) then
		lr_max_dose_per_day = real(ls_temp)
		if lr_admin_per_day > lr_max_dose_per_day then
			openwithparm(w_pop_message, "This dose exceeds the specified maximum dose per day")
		end if
	end if
end if

end subroutine

event post_open;///////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description: 
//
// Created By:Mark																				Creation dt: 
//
// Modified By:Sumathi Chinnasamy															Modified On:03/14/2000
///////////////////////////////////////////////////////////////////////////////////////////////////////

integer					li_sts
String					ls_null
/* user defined */
u_attachment_list		luo_attachment_list


Setnull(ls_null)
drug_id = treat_medication.drug_id
if isnull(drug_id) then
	log.log(this, "w_drug_treatment.post_open:0019", "Null drug_id", 4)
	treat_medication.treatment_definition[1].attribute_count = -1
	Close(This)
	Return
End if

// CDT 31/3/2020
// Require a formulation has been selected
form_rxcui = treat_medication.form_rxcui
if isnull(form_rxcui) OR form_rxcui = "" then
	log.log(this, "w_drug_treatment.post_open:0031", "Null form_rxcui", 4)
	treat_medication.treatment_definition[1].attribute_count = -1
	Close(This)
	Return
End if

li_sts = set_drug()
if  li_sts <= 0 then
	log.log(this, "w_drug_treatment.post_open:0037", "set_drug failed", 4)
	treat_medication.treatment_definition[1].attribute_count = -1
	Close(This)
	Return
End if

// package_list_index = uo_drug_package.selectformulation(treat_medication.form_rxcui)

If Isnull(treat_medication.dose_amount) Then
	load_defaults()
Else
	load_medication()
End if

cb_done.setfocus()

end event

event open;call super::open;///////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description: get a reference of treament component
//
// Created By:Mark																				Creation dt: 
//
// Modified By:Sumathi Chinnasamy															Modified On:03/14/2000
///////////////////////////////////////////////////////////////////////////////////////////////////////
long ll_menu_id

service = Message.Powerobjectparm
treat_medication = service.treatment
title = current_patient.id_line()
if service.manual_service then
	cb_continue.visible = false
	max_buttons = 3
end if

// Hide Dose Based on widgets for this release, will add back in later when administrations are available
// CDT 2020-03-29
st_dosebase.Visible = False
uo_drug_administration.Visible = False
st_mult_display.Visible = False

ll_menu_id = long(service.get_attribute("menu_id"))
paint_menu(ll_menu_id)

uo_dispense.allow_qs = datalist.get_preference_boolean("RX", "Allow QS Drug Dispense", false)

postevent("post_open")

end event

on w_drug_treatment.create
int iCurrent
call super::create
this.cb_done=create cb_done
this.cb_cancel=create cb_cancel
this.cb_continue=create cb_continue
this.st_prn=create st_prn
this.st_refills=create st_refills
this.dw_instructions=create dw_instructions
this.st_package=create st_package
this.st_dose=create st_dose
this.st_mult_display=create st_mult_display
this.st_take_as_directed=create st_take_as_directed
this.st_max_dose=create st_max_dose
this.pb_whole=create pb_whole
this.uo_drug_administration=create uo_drug_administration
this.uo_drug_package=create uo_drug_package
this.st_4=create st_4
this.uo_administer_frequency=create uo_administer_frequency
this.uo_duration=create uo_duration
this.st_dosebase=create st_dosebase
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.uo_dispense_office=create uo_dispense_office
this.uo_dose=create uo_dose
this.uo_dispense=create uo_dispense
this.gb_1=create gb_1
this.st_drug=create st_drug
this.st_brand_name_required_title=create st_brand_name_required_title
this.st_brand_name_required=create st_brand_name_required
this.st_frequency_title=create st_frequency_title
this.st_duration_title=create st_duration_title
this.st_route=create st_route
this.shl_drug=create shl_drug
this.st_link=create st_link
this.uo_route=create uo_route
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_done
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.cb_continue
this.Control[iCurrent+4]=this.st_prn
this.Control[iCurrent+5]=this.st_refills
this.Control[iCurrent+6]=this.dw_instructions
this.Control[iCurrent+7]=this.st_package
this.Control[iCurrent+8]=this.st_dose
this.Control[iCurrent+9]=this.st_mult_display
this.Control[iCurrent+10]=this.st_take_as_directed
this.Control[iCurrent+11]=this.st_max_dose
this.Control[iCurrent+12]=this.pb_whole
this.Control[iCurrent+13]=this.uo_drug_administration
this.Control[iCurrent+14]=this.uo_drug_package
this.Control[iCurrent+15]=this.st_4
this.Control[iCurrent+16]=this.uo_administer_frequency
this.Control[iCurrent+17]=this.uo_duration
this.Control[iCurrent+18]=this.st_dosebase
this.Control[iCurrent+19]=this.st_3
this.Control[iCurrent+20]=this.st_2
this.Control[iCurrent+21]=this.st_1
this.Control[iCurrent+22]=this.uo_dispense_office
this.Control[iCurrent+23]=this.uo_dose
this.Control[iCurrent+24]=this.uo_dispense
this.Control[iCurrent+25]=this.gb_1
this.Control[iCurrent+26]=this.st_drug
this.Control[iCurrent+27]=this.st_brand_name_required_title
this.Control[iCurrent+28]=this.st_brand_name_required
this.Control[iCurrent+29]=this.st_frequency_title
this.Control[iCurrent+30]=this.st_duration_title
this.Control[iCurrent+31]=this.st_route
this.Control[iCurrent+32]=this.shl_drug
this.Control[iCurrent+33]=this.st_link
this.Control[iCurrent+34]=this.uo_route
end on

on w_drug_treatment.destroy
call super::destroy
destroy(this.cb_done)
destroy(this.cb_cancel)
destroy(this.cb_continue)
destroy(this.st_prn)
destroy(this.st_refills)
destroy(this.dw_instructions)
destroy(this.st_package)
destroy(this.st_dose)
destroy(this.st_mult_display)
destroy(this.st_take_as_directed)
destroy(this.st_max_dose)
destroy(this.pb_whole)
destroy(this.uo_drug_administration)
destroy(this.uo_drug_package)
destroy(this.st_4)
destroy(this.uo_administer_frequency)
destroy(this.uo_duration)
destroy(this.st_dosebase)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.uo_dispense_office)
destroy(this.uo_dose)
destroy(this.uo_dispense)
destroy(this.gb_1)
destroy(this.st_drug)
destroy(this.st_brand_name_required_title)
destroy(this.st_brand_name_required)
destroy(this.st_frequency_title)
destroy(this.st_duration_title)
destroy(this.st_route)
destroy(this.shl_drug)
destroy(this.st_link)
destroy(this.uo_route)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_drug_treatment
integer x = 2821
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_drug_treatment
end type

type cb_done from commandbutton within w_drug_treatment
integer x = 2455
integer y = 1620
integer width = 407
integer height = 108
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
end type

event clicked;String	ls_description
Integer	li_sts

treat_medication.treatment_definition[1].attribute_count = -1

If package_list_index <= 0 Then
	Openwithparm(w_pop_message, "You must select a package")
	uo_drug_package.backcolor = color_light_yellow
	Return
else
	uo_drug_package.backcolor = color_light_grey
End if

If isnull(uo_dose.amount) or uo_dose.amount = 0 or isnull(uo_dose.unit) Then
	openwithparm(w_pop_message, "You must specify a dose")
	uo_dose.backcolor = color_light_yellow
	Return
else
	uo_dose.backcolor = color_light_grey
End if

If Isnull(uo_administer_frequency.administer_frequency) And &
	(IsNull(uo_drug_package.take_as_directed[package_list_index]) Or &
	uo_drug_package.take_as_directed[package_list_index] = "N") Then
	openwithparm(w_pop_message, "You must specify an administer frequency")
	uo_administer_frequency.backcolor = color_light_yellow
	Return
else
	uo_administer_frequency.backcolor = color_light_grey
End if

If (Isnull(uo_duration.amount) or uo_duration.amount = 0) And &
	(IsNull(uo_drug_package.take_as_directed[package_list_index]) Or &
	uo_drug_package.take_as_directed[package_list_index] = "N") Then
	openwithparm(w_pop_message, "You must specify a duration")
	uo_duration.backcolor = color_light_yellow
	Return
else
	uo_duration.backcolor = color_light_grey
End if

if not uo_dispense.allow_qs then
	if isnull(uo_dispense.amount) or isnull(uo_dispense.unit) or uo_dispense.amount <= 0 then
		openwithparm(w_pop_message, "You must specify dispense information")
		uo_dispense.backcolor = color_light_yellow
		Return
	else
		uo_dispense.backcolor = color_light_grey
	end if
end if

li_sts = current_user.check_drug(drug_id, uo_drug_package.package_id[package_list_index])
If li_sts < 0 Then
	log.log(This, "w_drug_treatment.cb_done.clicked:0031", "Error checking drug authorization (" + &
					drug_id + ", " + uo_drug_package.package_id[package_list_index] + ")", 3)
Elseif li_sts = 0 Then
	openwithparm(w_pop_message, "You are not authorized to write a prescription for this drug/package")
	close(parent)
	return
End if

li_sts = save_changes()
if li_sts <= 0 then return

Closewithreturn(parent, "OK")

end event

type cb_cancel from commandbutton within w_drug_treatment
integer x = 1984
integer y = 1620
integer width = 384
integer height = 108
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
end type

event clicked;str_popup_return popup_return

openwithparm(w_pop_yes_no, "Are you sure you wish to cancel this drug?")
popup_return = message.powerobjectparm
if popup_return.item = "YES" then
	Closewithreturn(parent, "CANCEL")
end if



end event

type cb_continue from commandbutton within w_drug_treatment
integer x = 1509
integer y = 1620
integer width = 384
integer height = 108
integer taborder = 70
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I~'ll Be Back"
end type

event clicked;str_popup popup
str_popup_return popup_return
integer li_sts

popup.data_row_count = 2
popup.items[1] = "Save Changes"
popup.items[2] = "Discard Changes"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return
if popup_return.item_indexes[1] = 1 then
	li_sts = save_changes()
	if li_sts <= 0 then return
end if

Closewithreturn(parent, "BEBACK")

end event

type st_prn from statictext within w_drug_treatment
integer x = 2199
integer y = 1304
integer width = 439
integer height = 128
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
string text = "PRN"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;refills = -1
Backcolor			 = color_object_selected
st_refills.backcolor	 = color_object
end event

type st_refills from statictext within w_drug_treatment
integer x = 1723
integer y = 1304
integer width = 439
integer height = 128
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
string text = "No Refills"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;// By Sumathi Chinnasamy On 12/08/1999
// To allow the user to key-in the no. of refills

str_popup 			popup
str_popup_return	popup_return

popup.realitem = refills
Openwithparm(w_number,popup)

popup_return = Message.powerobjectparm

If popup_return.item = "CANCEL" Then Return

refills				 = popup_return.realitem
If Isnull(refills) Then refills = 0

If refills = 0 Then This.Text = "No Refills" Else &
						This.Text = String(refills)+ " Refills"
This.Backcolor			 = color_object_selected
st_prn.backcolor	 = color_object
end event

type dw_instructions from datawindow within w_drug_treatment
integer x = 91
integer y = 1036
integer width = 1381
integer height = 380
integer taborder = 50
string dataobject = "dw_display_instruction"
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
popup.button_count = popup.button_count + 1
popup.button_icons[popup.button_count] = "button10.bmp"
popup.button_helps[popup.button_count] = "Enter Patient Instructions"
popup.button_titles[popup.button_count] = "Patient Instructions"
buttons[popup.button_count] = "PATIENTINSTRUCTION"


popup.button_count = popup.button_count + 1
popup.button_icons[popup.button_count] = "button10.bmp"
popup.button_helps[popup.button_count] = "Enter Pharmacist Instructions"
popup.button_titles[popup.button_count] = "Pharmacist Instructions"
buttons[popup.button_count] = "PHARMACISTINSTRUCTION"

popup.button_count = popup.button_count + 1
popup.button_icons[popup.button_count] = "button10.bmp"
popup.button_helps[popup.button_count] = "Set current instruction as default instruction"
popup.button_titles[popup.button_count] = "Set as Default"
buttons[popup.button_count] = "SETDEFAULT"

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
	CASE "PATIENTINSTRUCTION"
		edit_instruction("Patient Instructions")
	CASE "PHARMACISTINSTRUCTION"
		edit_instruction("Pharmacist Instructions")
	CASE "SETDEFAULT"
		set_default_instruction()
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE
end event

type st_package from statictext within w_drug_treatment
integer x = 1166
integer y = 212
integer width = 576
integer height = 68
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Drug Formulation"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_dose from statictext within w_drug_treatment
integer x = 448
integer y = 440
integer width = 576
integer height = 60
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Dose"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_mult_display from statictext within w_drug_treatment
integer x = 270
integer y = 1600
integer width = 1070
integer height = 60
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type st_take_as_directed from statictext within w_drug_treatment
boolean visible = false
integer x = 215
integer y = 180
integer width = 1070
integer height = 140
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
string text = "Take As Directed"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_max_dose from statictext within w_drug_treatment
integer x = 233
integer y = 656
integer width = 1070
integer height = 72
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_whole from picturebutton within w_drug_treatment
integer x = 73
integer y = 504
integer width = 128
integer height = 140
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = symbol!
fontpitch fontpitch = variable!
string facename = "Wingdings"
string text = "l"
vtextalign vtextalign = vcenter!
end type

event clicked;integer i
real lr_dose_amount
long ll_frequency

lr_dose_amount = uo_dose.amount

uo_dose.round_amount("WHOLE")

if lr_dose_amount <> uo_dose.amount then 
	uo_drug_administration.selectitem(0)
	drug_admin_index = 0
	st_mult_display.text = get_patient_weight()

	i = uo_administer_frequency.current_frequency
	if i > 0 then
		ll_frequency = uo_administer_frequency.frequencies[i].frequency
		uo_dispense.calc_amount(uo_dose.amount, &
										uo_dose.unit, &
										uo_administer_frequency.frequencies[i].frequency, &
										uo_duration.amount, &
										uo_duration.unit &
										)
	else
		ll_frequency = 1
	end if

	if package_list_index > 0 then
		uo_dose.check_max_dose(ll_frequency,  &
										uo_drug_package.administer_per_dose[package_list_index], &
										uo_drug_package.pkg_administer_unit[package_list_index], &
										max_dose_per_day, &
										max_dose_unit )
	end if
end if
end event

type uo_drug_administration from u_drug_administration within w_drug_treatment
integer x = 233
integer y = 1484
integer width = 1070
integer height = 140
boolean enabled = true
end type

event newadmin;string ls_package_id

if drug_admin_index > 0 then
	uo_administer_frequency.set_frequency(administer_frequency[drug_admin_index])
	if package_list_index > 0 then
		ls_package_id = uo_drug_package.package_id[package_list_index]
	else
		setnull(ls_package_id)
	end if
	load_default_drug_instructions(drug_id, ls_package_id, administration_sequence[drug_admin_index])
	display_instructions()
//	uo_special_instructions.retrieve_default(drug_id, ls_package_id, administration_sequence[drug_admin_index])
else
	uo_administer_frequency.set_frequency("")
end if


end event

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

type uo_drug_package from u_drug_package within w_drug_treatment
integer x = 320
integer y = 284
integer width = 2267
integer height = 140
boolean enabled = true
end type

event newpackage;call super::newpackage;string ls_package_id
integer li_admin_sequence
integer li_sts

if package_list_index > 0 then
	li_sts = current_user.check_drug(drug_id, uo_drug_package.package_id[package_list_index])
	if li_sts <= 0 then
		openwithparm(w_pop_message, "You are not authorized to write a prescription for this drug/package")
	end if
	
	// administer_method no longer part of package 
	// uo_route.set_method(method_description[package_list_index])
	
	uo_dispense.set_drug_package(drug_id, uo_drug_package.package_id[package_list_index])
	uo_dispense_office.set_drug_package(drug_id, uo_drug_package.package_id[package_list_index])
	
	if not dispense_selected then
		// Ciru says do not set dispense amount ahead of dose being selected
//		uo_dispense.set_amount(default_dispense_amount[package_list_index], &
//										default_dispense_unit[package_list_index])
//		uo_dispense_office.set_amount(0, default_dispense_unit[package_list_index])
	end if
	
//	
//	if take_as_directed[package_list_index] = "Y" then
//		uo_dose.visible = false
//		st_take_as_directed.visible = true
//		uo_route.visible = false
//		uo_administer_frequency.visible = false
//		uo_duration.visible = false
//		pb_whole.visible = false
//		st_dosebase.visible = false
//		uo_drug_administration.visible = false
//	else
//		uo_dose.visible = true
//		st_take_as_directed.visible = false
//		uo_route.visible = true
//		uo_administer_frequency.visible = true
//		uo_duration.visible = true
//		pb_whole.visible = true
//		// We are suppressing drug_administration activity for the time being
//		// CDT 2020-03-29
//		// st_dosebase.visible = true
//		// uo_drug_administration.visible = true
//	end if
	ls_package_id = uo_drug_package.package_id[package_list_index]
	uo_route.set_package(ls_package_id)
	
	if drug_admin_index > 0 Then
		li_admin_sequence = uo_drug_administration.administration_sequence[drug_admin_index]
	else
		setnull(li_admin_sequence)
	end if
	load_default_drug_instructions(drug_id, ls_package_id, li_admin_sequence)
	display_instructions()
end if

end event

event clicked;call super::clicked;window w
integer i
real lr_temp
string ls_ingr_rxcui, ls_form_description, ls_drug_id
str_popup popup
str_popup_return popup_return

last_package_list_index = package_list_index
//
//popup.items = package_description
//popup.data_row_count = package_count
//openwithparm(w_pop_pick, popup)
//popup_return = message.powerobjectparm
//if popup_return.item_index <= 0 then return
//package_list_index = popup_return.item_index

// Replace above popup with new 2-column formulation window
ls_drug_id = drug_id
ls_form_description = f_choose_formulation(treat_medication)
IF ls_form_description = "Nothing selected" THEN
	RETURN
END IF

// This is inherited from u_drug_package, which has a form_rxcui array.
// We want to assign to the window instance variable.
parent.form_rxcui = treat_medication.form_rxcui
drug_id =  treat_medication.drug_id
this.text = ls_form_description

set_drug()

// set_drug must execute before this can be done.
package_list_index = uo_drug_package.selectformulation(treat_medication.form_rxcui)

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

type st_4 from statictext within w_drug_treatment
integer x = 439
integer y = 960
integer width = 631
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Special Instructions"
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_administer_frequency from u_administer_frequency within w_drug_treatment
integer x = 251
integer y = 800
integer width = 1070
integer height = 140
end type

event clicked;call super::clicked;integer i
long ll_frequency

i = uo_administer_frequency.current_frequency
if i > 0 then
	ll_frequency = uo_administer_frequency.frequencies[i].frequency
	uo_dispense.calc_amount(uo_dose.amount, &
									uo_dose.unit, &
									uo_administer_frequency.frequencies[i].frequency, &
									uo_duration.amount, &
									uo_duration.unit &
									)
else
	ll_frequency = 1
end if

if package_list_index > 0 then
	uo_dose.check_max_dose(ll_frequency,  &
									uo_drug_package.administer_per_dose[package_list_index], &
									uo_drug_package.pkg_administer_unit[package_list_index], &
									max_dose_per_day, &
									max_dose_unit )
end if

end event

type uo_duration from u_duration_amount within w_drug_treatment
integer x = 1595
integer y = 784
integer width = 1070
integer height = 140
end type

on clicked;call u_duration_amount::clicked;integer i

i = uo_administer_frequency.current_frequency
if i > 0 then
	uo_dispense.calc_amount(uo_dose.amount, &
									uo_dose.unit, &
									uo_administer_frequency.frequencies[i].frequency, &
									uo_duration.amount, &
									uo_duration.unit &
									)
end if


end on

type st_dosebase from statictext within w_drug_treatment
integer x = 73
integer y = 1448
integer width = 576
integer height = 60
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Dose Based On"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_3 from statictext within w_drug_treatment
integer x = 1696
integer y = 1108
integer width = 274
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "In Office:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_drug_treatment
integer x = 1682
integer y = 1004
integer width = 293
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Dispense:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_drug_treatment
integer x = 1678
integer y = 948
integer width = 247
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Total"
boolean focusrectangle = false
end type

type uo_dispense_office from u_dispense_amount within w_drug_treatment
integer x = 1993
integer y = 1088
integer width = 645
integer height = 120
integer textsize = -12
integer weight = 700
end type

type uo_dose from u_dose_amount within w_drug_treatment
integer x = 242
integer y = 516
integer width = 1070
integer height = 140
integer textsize = -12
integer weight = 700
end type

event clicked;call super::clicked;integer i, j
long ll_frequency
real lr_dose_per_day
real lr_admin_per_day
string ls_temp
real lr_max_dose_per_day

if WasModified then 
	uo_drug_administration.selectitem(0)
	drug_admin_index = 0
	st_mult_display.text = get_patient_weight()

	i = uo_administer_frequency.current_frequency
	if i > 0 then
		ll_frequency = uo_administer_frequency.frequencies[i].frequency
		uo_dispense.calc_amount(uo_dose.amount, &
										uo_dose.unit, &
										ll_frequency, &
										uo_duration.amount, &
										uo_duration.unit &
										)
	else
		ll_frequency = 1
	end if
	
	if package_list_index > 0 then
		check_max_dose(ll_frequency,  &
								uo_drug_package.administer_per_dose[package_list_index], &
								uo_drug_package.pkg_administer_unit[package_list_index], &
								max_dose_per_day, &
								max_dose_unit )
	end if
end if

end event

on constructor;call u_dose_amount::constructor;zero_warning = true
end on

type uo_dispense from u_dispense_amount within w_drug_treatment
integer x = 1993
integer y = 948
integer width = 645
integer height = 116
integer textsize = -12
integer weight = 700
end type

event clicked;call super::clicked;if wasmodified then dispense_selected = true

end event

type gb_1 from groupbox within w_drug_treatment
integer x = 1678
integer y = 1244
integer width = 978
integer height = 200
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Refills"
end type

type st_drug from statictext within w_drug_treatment
integer width = 2903
integer height = 144
integer textsize = -22
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 7191717
boolean enabled = false
alignment alignment = center!
long bordercolor = 8421504
boolean focusrectangle = false
end type

type st_brand_name_required_title from statictext within w_drug_treatment
integer x = 1701
integer y = 1496
integer width = 686
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
string text = "Brand Name Required:"
boolean focusrectangle = false
end type

type st_brand_name_required from statictext within w_drug_treatment
integer x = 2409
integer y = 1480
integer width = 210
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Yes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;
if brand_name_required = "Y" then
	brand_name_required = "N"
	text = "No"
else
	brand_name_required = "Y"
	text = "Yes"
end if

end event

type st_frequency_title from statictext within w_drug_treatment
integer x = 462
integer y = 720
integer width = 576
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Frequency"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_duration_title from statictext within w_drug_treatment
integer x = 1842
integer y = 720
integer width = 576
integer height = 68
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Duration"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_route from statictext within w_drug_treatment
integer x = 1806
integer y = 444
integer width = 695
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Route of Administration"
alignment alignment = center!
boolean focusrectangle = false
end type

type shl_drug from statichyperlink within w_drug_treatment
integer x = 2080
integer y = 156
integer width = 791
integer height = 92
boolean bringtotop = true
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

type st_link from statictext within w_drug_treatment
integer x = 1847
integer y = 164
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

type uo_route from u_administer_method within w_drug_treatment
integer x = 1595
integer y = 516
integer width = 1070
integer height = 140
boolean bringtotop = true
end type

