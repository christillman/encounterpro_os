﻿$PBExportHeader$w_svc_drug_treatment_edit.srw
forward
global type w_svc_drug_treatment_edit from w_window_base
end type
type cb_done from commandbutton within w_svc_drug_treatment_edit
end type
type cb_cancel from commandbutton within w_svc_drug_treatment_edit
end type
type cb_continue from commandbutton within w_svc_drug_treatment_edit
end type
type st_prn from statictext within w_svc_drug_treatment_edit
end type
type st_refills from statictext within w_svc_drug_treatment_edit
end type
type dw_instructions from datawindow within w_svc_drug_treatment_edit
end type
type st_package from statictext within w_svc_drug_treatment_edit
end type
type st_mult_display from statictext within w_svc_drug_treatment_edit
end type
type st_take_as_directed from statictext within w_svc_drug_treatment_edit
end type
type st_max_dose from statictext within w_svc_drug_treatment_edit
end type
type pb_whole from picturebutton within w_svc_drug_treatment_edit
end type
type uo_drug_administration from u_drug_administration within w_svc_drug_treatment_edit
end type
type uo_drug_package from u_drug_package within w_svc_drug_treatment_edit
end type
type st_4 from statictext within w_svc_drug_treatment_edit
end type
type uo_administer_frequency from u_administer_frequency within w_svc_drug_treatment_edit
end type
type uo_duration from u_duration_amount within w_svc_drug_treatment_edit
end type
type st_dosebase from statictext within w_svc_drug_treatment_edit
end type
type st_3 from statictext within w_svc_drug_treatment_edit
end type
type st_2 from statictext within w_svc_drug_treatment_edit
end type
type st_1 from statictext within w_svc_drug_treatment_edit
end type
type uo_dispense_office from u_dispense_amount within w_svc_drug_treatment_edit
end type
type uo_dose from u_dose_amount within w_svc_drug_treatment_edit
end type
type uo_dispense from u_dispense_amount within w_svc_drug_treatment_edit
end type
type st_method_description from statictext within w_svc_drug_treatment_edit
end type
type gb_1 from groupbox within w_svc_drug_treatment_edit
end type
type st_drug from statictext within w_svc_drug_treatment_edit
end type
type st_brand_name_required_title from statictext within w_svc_drug_treatment_edit
end type
type st_brand_name_required from statictext within w_svc_drug_treatment_edit
end type
type st_frequency_title from statictext within w_svc_drug_treatment_edit
end type
type st_duration_title from statictext within w_svc_drug_treatment_edit
end type
type st_dose from statictext within w_svc_drug_treatment_edit
end type
end forward

global type w_svc_drug_treatment_edit from w_window_base
integer height = 1840
windowtype windowtype = response!
string button_type = "COMMAND"
integer max_buttons = 2
event post_open pbm_custom01
cb_done cb_done
cb_cancel cb_cancel
cb_continue cb_continue
st_prn st_prn
st_refills st_refills
dw_instructions dw_instructions
st_package st_package
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
st_method_description st_method_description
gb_1 gb_1
st_drug st_drug
st_brand_name_required_title st_brand_name_required_title
st_brand_name_required st_brand_name_required
st_frequency_title st_frequency_title
st_duration_title st_duration_title
st_dose st_dose
end type
global w_svc_drug_treatment_edit w_svc_drug_treatment_edit

type variables
/* real data types */
real default_duration_amount
real max_dose_per_day

/* string data types */
string       drug_id
string       default_duration_unit
string       default_duration_prn
string       pharmacist_instructions
string       patient_instructions
string		 prev_patient_instructions,prev_pharmacist_instructions
string		brand_name_required

/* integer datatypes */
integer     refills = 0
integer     package_list_index = 0
integer     drug_admin_index = 0
integer     last_package_list_index = 0

/* long data types */
long         problem_id
long         treatment_id
long         treatment_sequence

/* boolean data types */
boolean    package_selected
boolean    dispense_selected
boolean	  display_only=false
boolean   prev_dispense_qs

/* reference to unit object */
u_unit      max_dose_unit

/* reference to treatment component */
u_component_treatment      treat_medication
u_component_service							service
end variables

forward prototypes
public function integer display_instructions ()
public subroutine edit_instruction (string ps_progress_key)
public function integer set_drug ()
public subroutine set_default_instruction ()
public function integer load_default_drug_instructions (string ps_drug_id, string ps_package_id, integer pi_administration_sequence)
public function integer save_changes ()
public subroutine recalcdose ()
public subroutine load_medication ()
public function string get_patient_weight ()
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

if isnull(ls_mult_display) or trim(ls_mult_display) = "" then
	st_mult_display.text = get_patient_weight()
else
	st_mult_display.text = ls_mult_display
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

log.log(this, "w_svc_drug_treatment_edit.set_drug:0007", drug_id, 1)

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
	if li_sts = 0 then log.log(this, "w_svc_drug_treatment_edit.set_drug:0020","Invalid Drug ID (" + drug_id + ")", 4)
	return li_sts
end if

max_dose_unit = unit_list.find_unit(ls_unit)
if not isnull(max_dose_unit) then
	st_max_dose.text = "Max Dose = " + f_pretty_amount_unit(max_dose_per_day, max_dose_unit.unit_id) + " / Day"
else
	st_max_dose.text = ""
end if

// Get the package list for this drug
li_count = uo_drug_package.retrieve(drug_id)
if li_count <= 0 then
	messagebox("w_svc_drug_treatment_edit-set_drug()","This drug (" + st_drug.text + ") has no packages defined.")
	return -1
end if

// Get the admin list for this drug

// Hide Dose Based on widgets (#11)
// CDT 2023-07-17
// li_count = uo_drug_administration.retrieve(drug_id, "ALL")

display_only = false

Return 1
end function

public subroutine load_medication ();integer li_count, i, j, li_sts
string ls_null
str_progress lstr_progress
real lr_null
string ls_is_qs
string ls_dispense_unit

setnull(lr_null)
setnull(ls_null)
// If the package ID exists, then set it.
// Otherwise use the dosage form if it exists.
// Otherwise use the first package.
package_list_index = uo_drug_package.selectpackage(treat_medication.package_id)
If package_list_index = 0 Then
	package_selected = False
Else
	package_selected = True
	uo_dose.set_amount(lr_null, uo_drug_package.dose_unit[package_list_index])
	uo_drug_package.event trigger newpackage()
End if

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

		// Ciru says do not set dispense amount ahead of dose being selected
//uo_dispense.set_amount(treat_medication.dispense_amount, ls_dispense_unit)
//uo_dispense_office.set_amount(treat_medication.office_dispense_amount, ls_dispense_unit)

// Save the initial dispense_qs setting so we know if it changes
prev_dispense_qs = uo_dispense.is_qs

// If there is no dose amount, then set the drug administration to the one specified
// in the medication object.
If isnull(treat_medication.dose_amount) then
	drug_admin_index = uo_drug_administration.selectadminsequence(&
											treat_medication.administration_sequence)
Else
	// If there is a dose amount then load it.
	uo_dose.set_amount(treat_medication.dose_amount, &
									treat_medication.dose_unit)
	drug_admin_index = uo_drug_administration.selectadminsequence(&
											treat_medication.administration_sequence)
End if

// Load all the other stuff
If Not isnull(treat_medication.administer_frequency) Then &
	uo_administer_frequency.set_frequency(treat_medication.administer_frequency)

uo_duration.set_amount(	treat_medication.duration_amount, &
								treat_medication.duration_unit, &
								treat_medication.duration_prn )

// By Sumathi Chinnasamy On 12/08/99
// Set refill text 
refills = treat_medication.refills
if isnull(refills) or refills = 0 then
	st_refills.text = "No Refills"
	st_refills.backcolor = color_object_selected
elseif refills < 0 then
	st_prn.backcolor = color_object_selected
else
	st_refills.text = String(treat_medication.refills)+" Refills"
	st_refills.backcolor = color_object_selected
end if

//---
brand_name_required = treat_medication.brand_name_required
if upper(brand_name_required) = "Y" then
	st_brand_name_required.text = "Yes"
else
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


end subroutine


public function integer save_changes ();String	ls_description
Integer	li_sts
str_attributes lstr_attributes
string ls_null
long ll_old_treatment_id
str_treatment_description lstr_treatment
string ls_admin_instructions
string ls_dosing_instructions

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

lstr_attributes.attribute_count += 1
lstr_attributes.attribute[lstr_attributes.attribute_count].attribute = "administer_frequency"
lstr_attributes.attribute[lstr_attributes.attribute_count].value = uo_administer_frequency.administer_frequency

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

// If the updated flad is true then something changed and we have to update the treatment
ll_old_treatment_id = treat_medication.treatment_id
lstr_treatment = treat_medication.treatment_description()
if treat_medication.updated then
	treat_medication.treatment_description =  drugdb.treatment_drug_sig(lstr_treatment)
	li_sts = current_patient.treatments.update_treatment(treat_medication)
	if li_sts < 0 then return -1
end if

// Check to see if we need to update the dosing instructions or admin instructions
ls_admin_instructions = f_get_progress_value(current_patient.cpr_id, "Treatment", treatment_id, "Instructions", "Admin Instructions")
if trim(ls_admin_instructions) = "" then setnull(ls_admin_instructions)
ls_dosing_instructions = f_get_progress_value(current_patient.cpr_id, "Treatment", treatment_id, "Instructions", "Dosing Instructions")
if trim(ls_dosing_instructions) = "" then setnull(ls_dosing_instructions)

if treat_medication.updated OR (isnull(ls_admin_instructions) or isnull(ls_dosing_instructions)) then
	// Update the "Directions" properties
	ls_dosing_instructions = drugdb.treatment_dosing_description(lstr_treatment)
	li_sts = current_patient.treatments.set_treatment_progress(treat_medication.treatment_id, "Instructions", "Dosing Instructions", ls_dosing_instructions)
	if li_sts < 0 then return -1

	ls_admin_instructions = drugdb.treatment_admin_description(lstr_treatment)
	li_sts = current_patient.treatments.set_treatment_progress(treat_medication.treatment_id, "Instructions", "Admin Instructions", ls_admin_instructions)
	if li_sts < 0 then return -1
end if

If trim(pharmacist_instructions) = "" Then setnull(pharmacist_instructions)
If trim(patient_instructions) = "" Then setnull(patient_instructions)

// Set the pharmacist instructions if it's modified
If prev_pharmacist_instructions <> pharmacist_instructions &
	OR (isnull(prev_pharmacist_instructions) And Not isnull(pharmacist_instructions)) &
	OR (isnull(pharmacist_instructions) And Not isnull(prev_pharmacist_instructions)) &
	OR (ll_old_treatment_id <> treat_medication.treatment_id AND len(pharmacist_instructions) > 0) Then
	li_sts = current_patient.treatments.set_treatment_progress(treat_medication.treatment_id, "Instructions", "Pharmacist Instructions", pharmacist_instructions)
End If

// Update patient instructions if it's modified
If prev_patient_instructions <> patient_instructions &
	OR (isnull(prev_patient_instructions) And Not isnull(patient_instructions)) &
	 OR (isnull(patient_instructions) And Not isnull(prev_patient_instructions)) &
	OR (ll_old_treatment_id <> treat_medication.treatment_id AND len(patient_instructions) > 0) Then
	li_sts = current_patient.treatments.set_treatment_progress(treat_medication.treatment_id, "Instructions", "Patient Instructions", patient_instructions)
End If


return 1




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
//CWW,END


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
boolean lb_auto_dose

Setnull(ls_null)
drug_id 		  = treat_medication.drug_id
if isnull(drug_id) then
	log.log(this, "w_svc_drug_treatment_edit:post", "Null drug_id", 4)
	treat_medication.treatment_definition[1].attribute_count = -1
	Close(This)
	Return
End if

li_sts = set_drug()

If li_sts <= 0 Then
	treat_medication.treatment_definition[1].attribute_count = -1
	Close(This)
	Return
End if

load_medication()

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

// Don't allow editing of modified treatments
if lower(treat_medication.treatment_status) = "modified" then
	treat_medication.treatment_definition[1].attribute_count = -1
	Close(This)
	Return
end if

if service.manual_service then
	cb_continue.visible = false
	max_buttons = 3
end if

ll_menu_id = long(service.get_attribute("menu_id"))
paint_menu(ll_menu_id)

uo_dispense.allow_qs = datalist.get_preference_boolean("RX", "Allow QS Drug Dispense", false)

// Hide Dose Based on widgets (#11)
// CDT 2023-07-17
st_dosebase.Visible = False
uo_drug_administration.Visible = False
st_mult_display.Visible = False

postevent("post_open")

end event

on w_svc_drug_treatment_edit.create
int iCurrent
call super::create
this.cb_done=create cb_done
this.cb_cancel=create cb_cancel
this.cb_continue=create cb_continue
this.st_prn=create st_prn
this.st_refills=create st_refills
this.dw_instructions=create dw_instructions
this.st_package=create st_package
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
this.st_method_description=create st_method_description
this.gb_1=create gb_1
this.st_drug=create st_drug
this.st_brand_name_required_title=create st_brand_name_required_title
this.st_brand_name_required=create st_brand_name_required
this.st_frequency_title=create st_frequency_title
this.st_duration_title=create st_duration_title
this.st_dose=create st_dose
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_done
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.cb_continue
this.Control[iCurrent+4]=this.st_prn
this.Control[iCurrent+5]=this.st_refills
this.Control[iCurrent+6]=this.dw_instructions
this.Control[iCurrent+7]=this.st_package
this.Control[iCurrent+8]=this.st_mult_display
this.Control[iCurrent+9]=this.st_take_as_directed
this.Control[iCurrent+10]=this.st_max_dose
this.Control[iCurrent+11]=this.pb_whole
this.Control[iCurrent+12]=this.uo_drug_administration
this.Control[iCurrent+13]=this.uo_drug_package
this.Control[iCurrent+14]=this.st_4
this.Control[iCurrent+15]=this.uo_administer_frequency
this.Control[iCurrent+16]=this.uo_duration
this.Control[iCurrent+17]=this.st_dosebase
this.Control[iCurrent+18]=this.st_3
this.Control[iCurrent+19]=this.st_2
this.Control[iCurrent+20]=this.st_1
this.Control[iCurrent+21]=this.uo_dispense_office
this.Control[iCurrent+22]=this.uo_dose
this.Control[iCurrent+23]=this.uo_dispense
this.Control[iCurrent+24]=this.st_method_description
this.Control[iCurrent+25]=this.gb_1
this.Control[iCurrent+26]=this.st_drug
this.Control[iCurrent+27]=this.st_brand_name_required_title
this.Control[iCurrent+28]=this.st_brand_name_required
this.Control[iCurrent+29]=this.st_frequency_title
this.Control[iCurrent+30]=this.st_duration_title
this.Control[iCurrent+31]=this.st_dose
end on

on w_svc_drug_treatment_edit.destroy
call super::destroy
destroy(this.cb_done)
destroy(this.cb_cancel)
destroy(this.cb_continue)
destroy(this.st_prn)
destroy(this.st_refills)
destroy(this.dw_instructions)
destroy(this.st_package)
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
destroy(this.st_method_description)
destroy(this.gb_1)
destroy(this.st_drug)
destroy(this.st_brand_name_required_title)
destroy(this.st_brand_name_required)
destroy(this.st_frequency_title)
destroy(this.st_duration_title)
destroy(this.st_dose)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_svc_drug_treatment_edit
integer x = 2821
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_drug_treatment_edit
end type

type cb_done from commandbutton within w_svc_drug_treatment_edit
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

event clicked;integer li_sts

li_sts = save_changes()
if li_sts <= 0 then return

Closewithreturn(parent, "OK")

end event

type cb_cancel from commandbutton within w_svc_drug_treatment_edit
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

openwithparm(w_pop_yes_no, "Are you sure you wish to discard your changes?")
popup_return = message.powerobjectparm
if popup_return.item = "YES" then
	Closewithreturn(parent, "CANCEL")
end if



end event

type cb_continue from commandbutton within w_svc_drug_treatment_edit
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

type st_prn from statictext within w_svc_drug_treatment_edit
integer x = 2258
integer y = 1120
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

type st_refills from statictext within w_svc_drug_treatment_edit
integer x = 1783
integer y = 1120
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
If Isnull(refills) or refills = 0 Then
	refills = 0
	Text = "No Refills" 
Else
	Text = String(refills) + " Refills"
end if

Backcolor			 = color_object_selected
st_prn.backcolor	 = color_object

end event

type dw_instructions from datawindow within w_svc_drug_treatment_edit
integer x = 69
integer y = 1188
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
if not display_only then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button10.bmp"
	popup.button_helps[popup.button_count] = "Enter Patient Instructions"
	popup.button_titles[popup.button_count] = "Patient Instructions"
	buttons[popup.button_count] = "PATIENTINSTRUCTION"
end if

if not display_only then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button10.bmp"
	popup.button_helps[popup.button_count] = "Enter Pharmacist Instructions"
	popup.button_titles[popup.button_count] = "Pharmacist Instructions"
	buttons[popup.button_count] = "PHARMACISTINSTRUCTION"
end if

if not display_only then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button10.bmp"
	popup.button_helps[popup.button_count] = "Set current instruction as default instruction"
	popup.button_titles[popup.button_count] = "Set as Default"
	buttons[popup.button_count] = "SETDEFAULT"
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

type st_package from statictext within w_svc_drug_treatment_edit
integer x = 1833
integer y = 500
integer width = 576
integer height = 68
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Package"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_mult_display from statictext within w_svc_drug_treatment_edit
integer x = 1600
integer y = 412
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

type st_take_as_directed from statictext within w_svc_drug_treatment_edit
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

type st_max_dose from statictext within w_svc_drug_treatment_edit
integer x = 215
integer y = 408
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

type pb_whole from picturebutton within w_svc_drug_treatment_edit
integer x = 64
integer y = 256
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

type uo_drug_administration from u_drug_administration within w_svc_drug_treatment_edit
integer x = 1600
integer y = 260
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

type uo_drug_package from u_drug_package within w_svc_drug_treatment_edit
integer x = 1605
integer y = 576
integer width = 1070
integer height = 140
boolean enabled = true
end type

event newpackage;call super::newpackage;string ls_package_id
integer li_admin_sequence
integer li_sts

if package_list_index > 0 then
//	li_sts = current_user.check_drug(drug_id, uo_drug_package.package_id[package_list_index])
//	if li_sts <= 0 then
//		openwithparm(w_pop_message, "You are not authorized to write a prescription for this drug/package")
//	end if
	
	// administer_method no longer part of package 
	// st_method_description.text = method_description[package_list_index]
	
	uo_dispense.set_drug_package(drug_id, uo_drug_package.package_id[package_list_index])
	uo_dispense_office.set_drug_package(drug_id, uo_drug_package.package_id[package_list_index])

	if take_as_directed[package_list_index] = "Y" then
		uo_dose.visible = false
		st_take_as_directed.visible = true
		st_method_description.visible = false
		uo_administer_frequency.visible = false
		uo_duration.visible = false
		pb_whole.visible = false
		st_dosebase.visible = false
		uo_drug_administration.visible = false
	else
		uo_dose.visible = true
		st_take_as_directed.visible = false
		st_method_description.visible = true
		uo_administer_frequency.visible = true
		uo_duration.visible = true
		pb_whole.visible = true
		// Hide Dose Based on widgets (#11)
		// CDT 2023-07-17
		st_dosebase.visible = false
		uo_drug_administration.visible = false
	end if
end if

end event

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

if  drug_admin_index > 0 AND package_list_index > 0 then
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

type st_4 from statictext within w_svc_drug_treatment_edit
integer x = 416
integer y = 1112
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

type uo_administer_frequency from u_administer_frequency within w_svc_drug_treatment_edit
integer x = 215
integer y = 720
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

type uo_duration from u_duration_amount within w_svc_drug_treatment_edit
integer x = 215
integer y = 936
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

type st_dosebase from statictext within w_svc_drug_treatment_edit
integer x = 1842
integer y = 192
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

type st_3 from statictext within w_svc_drug_treatment_edit
integer x = 1627
integer y = 924
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

type st_2 from statictext within w_svc_drug_treatment_edit
integer x = 1614
integer y = 820
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

type st_1 from statictext within w_svc_drug_treatment_edit
integer x = 1609
integer y = 764
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

type uo_dispense_office from u_dispense_amount within w_svc_drug_treatment_edit
integer x = 1925
integer y = 904
integer width = 645
integer height = 120
integer textsize = -12
integer weight = 700
end type

type uo_dose from u_dose_amount within w_svc_drug_treatment_edit
integer x = 215
integer y = 260
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

type uo_dispense from u_dispense_amount within w_svc_drug_treatment_edit
integer x = 1925
integer y = 764
integer width = 645
integer height = 116
integer textsize = -12
integer weight = 700
end type

event clicked;call super::clicked;if wasmodified then dispense_selected = true

end event

type st_method_description from statictext within w_svc_drug_treatment_edit
integer x = 215
integer y = 484
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

type gb_1 from groupbox within w_svc_drug_treatment_edit
integer x = 1737
integer y = 1060
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

type st_drug from statictext within w_svc_drug_treatment_edit
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

type st_brand_name_required_title from statictext within w_svc_drug_treatment_edit
integer x = 1719
integer y = 1400
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

type st_brand_name_required from statictext within w_svc_drug_treatment_edit
integer x = 2427
integer y = 1384
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

type st_frequency_title from statictext within w_svc_drug_treatment_edit
integer x = 462
integer y = 648
integer width = 576
integer height = 68
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

type st_duration_title from statictext within w_svc_drug_treatment_edit
integer x = 462
integer y = 872
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

type st_dose from statictext within w_svc_drug_treatment_edit
integer x = 439
integer y = 192
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

