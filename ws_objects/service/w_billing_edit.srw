HA$PBExportHeader$w_billing_edit.srw
forward
global type w_billing_edit from w_window_base
end type
type dw_billing from u_dw_pick_list within w_billing_edit
end type
type st_mod from statictext within w_billing_edit
end type
type st_notes from statictext within w_billing_edit
end type
type st_note_title from statictext within w_billing_edit
end type
type st_courtesy_code from statictext within w_billing_edit
end type
type st_hold_title from statictext within w_billing_edit
end type
type st_billing_hold from statictext within w_billing_edit
end type
type cb_new_visit_charge from commandbutton within w_billing_edit
end type
type cb_new_visit_charge_2 from commandbutton within w_billing_edit
end type
type st_billing_title from statictext within w_billing_edit
end type
type st_billing_encounter from statictext within w_billing_edit
end type
type cb_finished from commandbutton within w_billing_edit
end type
type cb_be_back from commandbutton within w_billing_edit
end type
type st_encounter_type from statictext within w_billing_edit
end type
type st_enc_type_title from statictext within w_billing_edit
end type
type st_code_check_status from statictext within w_billing_edit
end type
type st_code_check_status_title from statictext within w_billing_edit
end type
type cb_coding from commandbutton within w_billing_edit
end type
type st_display_only from statictext within w_billing_edit
end type
end forward

global type w_billing_edit from w_window_base
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
string button_type = "COMMAND"
dw_billing dw_billing
st_mod st_mod
st_notes st_notes
st_note_title st_note_title
st_courtesy_code st_courtesy_code
st_hold_title st_hold_title
st_billing_hold st_billing_hold
cb_new_visit_charge cb_new_visit_charge
cb_new_visit_charge_2 cb_new_visit_charge_2
st_billing_title st_billing_title
st_billing_encounter st_billing_encounter
cb_finished cb_finished
cb_be_back cb_be_back
st_encounter_type st_encounter_type
st_enc_type_title st_enc_type_title
st_code_check_status st_code_check_status
st_code_check_status_title st_code_check_status_title
cb_coding cb_coding
st_display_only st_display_only
end type
global w_billing_edit w_billing_edit

type variables

u_component_service service
u_str_encounter encounter
boolean is_billed,some_assessments

string code_check_review_service
string code_check_perform_service

boolean display_only

string coding_service

end variables

forward prototypes
public subroutine edit_charges (long pl_row)
public subroutine change_procedure (long pl_row)
public subroutine attach_to_assessments (long pl_row)
public subroutine new_visit_charge ()
public subroutine new_secondary_visit_charge ()
public subroutine dont_bill (long pl_row)
public subroutine delete_charge (long pl_row)
public subroutine test_perform (long pl_row)
public subroutine test_collect (long pl_row)
public subroutine load_billing ()
public subroutine item_menu (long pl_row)
public subroutine change_level (long pl_row)
public function integer refresh ()
public subroutine change_units (long pl_row)
public subroutine edit_modifier (long pl_row)
public subroutine refresh_coding ()
public subroutine load_billing_old ()
public function integer move_assessment (long pl_row, string ps_direction)
end prototypes

public subroutine edit_charges (long pl_row);str_popup popup
str_popup_return popup_return
long ll_encounter_charge_id
decimal ldc_charge
string ls_procedure_id


ll_encounter_charge_id = dw_billing.object.encounter_charge_id[pl_row]

popup.data_row_count = 4
popup.items[1] = encounter.parent_patient.cpr_id
popup.items[2] = string(encounter.encounter_id)
popup.items[3] = string(ll_encounter_charge_id)
popup.items[4] = string(dw_billing.object.charge[pl_row])
popup.title = dw_billing.object.description[pl_row]
popup.multiselect = true

openwithparm(w_charge_edit, popup)
popup_return = message.powerobjectparm

if popup_return.item_count <> 2 then return

ldc_charge = dec(popup_return.items[1])

UPDATE p_Encounter_Charge
SET	charge = :ldc_charge 
WHERE	cpr_id = :encounter.parent_patient.cpr_id
AND encounter_id = :encounter.encounter_id
AND	encounter_charge_id = :ll_encounter_charge_id;
if not tf_check() then return

dw_billing.object.charge[pl_row] = ldc_charge

ls_procedure_id = dw_billing.object.procedure_id[pl_row]

if popup_return.items[2] = "TRUE" then
	UPDATE c_Procedure
	SET	charge = :ldc_charge
	WHERE procedure_id = :ls_procedure_id;
	if not tf_check() then return
end if


end subroutine

public subroutine change_procedure (long pl_row);str_popup popup
string ls_cpt_code
decimal ldc_charge
integer li_sts
string ls_procedure_type
string ls_procedure_id
string ls_description
string ls_category_id
string ls_category_description
long ll_encounter_charge_id
str_picked_procedures lstr_procedures

ls_procedure_type = dw_billing.object.procedure_type[pl_row]

popup.data_row_count = 1
popup.items[1] = ls_procedure_type
popup.multiselect = false
openwithparm(w_pick_procedures, popup)
lstr_procedures = message.powerobjectparm

if lstr_procedures.procedure_count < 1 then return

ls_procedure_id = lstr_procedures.procedures[1].procedure_id

if upper(ls_procedure_type) = "PRIMARY" then
	current_patient.set_encounter_property(encounter.encounter_id, "Visit Code", ls_procedure_id)
else
	li_sts = tf_get_procedure_detail(ls_procedure_id, ls_description, ls_cpt_code, ls_category_id, ls_category_description, ldc_charge)
	if li_sts <= 0 then return
	
	ll_encounter_charge_id = dw_billing.object.encounter_charge_id[pl_row]
	
	UPDATE p_Encounter_Charge
	SET	procedure_id = :ls_procedure_id,
			charge = :ldc_charge 
	WHERE	cpr_id = :encounter.parent_patient.cpr_id
	AND encounter_id = :encounter.encounter_id
	AND	encounter_charge_id = :ll_encounter_charge_id;
	if not tf_check() then return
end if

refresh()



end subroutine

public subroutine attach_to_assessments (long pl_row);str_popup popup
str_popup_return popup_return

popup.title = dw_billing.object.description[pl_row]
popup.items[1] = encounter.parent_patient.cpr_id
popup.items[2] = string(encounter.encounter_id)
popup.items[3] = string(dw_billing.object.encounter_charge_id[pl_row])
popup.data_row_count = 3

openwithparm(w_pick_proc_assessments, popup)
popup_return = message.powerobjectparm

if popup_return.item = "CHANGED" then
	load_billing()
end if




end subroutine

public subroutine new_visit_charge ();str_popup popup
str_popup_return popup_return
integer li_sts
string ls_procedure_id
long ll_problem_id
long ll_treatment_id
string ls_created_by


popup.dataobject = "dw_encounter_all_procs"
popup.displaycolumn = 2
popup.datacolumn = 1
popup.argument_count = 2
popup.argument[1] = encounter.encounter_type
popup.argument[2] = encounter.new_flag

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_procedure_id = popup_return.items[1]
setnull(ll_problem_id)
setnull(ll_treatment_id)
ls_created_by = current_scribe.user_id

sqlca.sp_add_encounter_charge(current_patient.cpr_id, &
						encounter.encounter_id, &
						ls_procedure_id, &
						ll_treatment_id, &
						current_scribe.user_id, &
						"N")
if not tf_check() then return

load_billing()

end subroutine

public subroutine new_secondary_visit_charge ();str_popup popup
str_popup_return popup_return
integer li_sts
string ls_procedure_id
long ll_problem_id
long ll_treatment_id
string ls_created_by


popup.dataobject = "dw_secondary_proc_list"
popup.displaycolumn = 2
popup.datacolumn = 1
popup.argument_count = 2
popup.argument[1] = encounter.encounter_type
popup.argument[2] = encounter.new_flag

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_procedure_id = popup_return.items[1]
setnull(ll_problem_id)
setnull(ll_treatment_id)
ls_created_by = current_scribe.user_id

sqlca.sp_add_encounter_charge(current_patient.cpr_id, &
						encounter.encounter_id, &
						ls_procedure_id, &
						ll_treatment_id, &
						current_scribe.user_id, &
						"N")
if not tf_check() then return

load_billing()

end subroutine

public subroutine dont_bill (long pl_row);long ll_encounter_charge_id
integer li_treatment_sequence
string ls_bill_flag

 DECLARE lsp_set_charge_billing PROCEDURE FOR dbo.sp_set_charge_billing  
         @ps_cpr_id = :encounter.parent_patient.cpr_id,   
         @pl_encounter_id = :encounter.encounter_id,   
         @pl_encounter_charge_id = :ll_encounter_charge_id,   
         @ps_bill_flag = :ls_bill_flag,
			@ps_created_by = :current_scribe.user_id;

ls_bill_flag = "N"
ll_encounter_charge_id = dw_billing.object.encounter_charge_id[pl_row]

EXECUTE lsp_set_charge_billing;
if not tf_check() then return

load_billing()


end subroutine

public subroutine delete_charge (long pl_row);str_popup_return popup_return
long ll_encounter_charge_id
string ls_description

ls_description = dw_billing.object.description[pl_row]

openwithparm(w_pop_yes_no, "Are you sure you wish to delete the charge for " + ls_description +"?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

ll_encounter_charge_id = dw_billing.object.encounter_charge_id[pl_row]

DELETE p_Encounter_Charge
WHERE cpr_id = :encounter.parent_patient.cpr_id
AND encounter_id = :encounter.encounter_id
AND encounter_charge_id = :ll_encounter_charge_id;
if not tf_check() then return

load_billing()


end subroutine

public subroutine test_perform (long pl_row);str_popup popup
str_popup_return popup_return
integer li_sts
string ls_perform_procedure_id
string ls_collection_procedure_id
long ll_treatment_id
integer li_pos
string ls_cpt_code
decimal ldc_charge
string ls_description
long ll_encounter_charge_id

ll_treatment_id = dw_billing.object.treatment_id[pl_row]
ls_description = dw_billing.object.description[pl_row]
ll_encounter_charge_id = dw_billing.object.encounter_charge_id[pl_row]

li_sts = tf_get_test_procedures(encounter.parent_patient.cpr_id, &
										  ll_treatment_id, &
										  ls_perform_procedure_id, &
										  ls_collection_procedure_id)
if li_sts <= 0 then return

if isnull(ls_perform_procedure_id) then
	openwithparm(w_pop_message, "This test does not have a perform code")
	return
end if

li_sts = tf_get_procedure_charge(ls_perform_procedure_id, ls_cpt_code, ldc_charge)
if li_sts <= 0 then return

li_pos = pos(ls_description, " (Send Out)")
if li_pos > 0 then ls_description = left(ls_description, li_pos - 1)

UPDATE p_Encounter_Charge
SET procedure_id = :ls_perform_procedure_id,
	 charge = :ldc_charge,
	 procedure_type = 'TESTPERFORM'
WHERE cpr_id = :encounter.parent_patient.cpr_id
AND encounter_id = :encounter.encounter_id
AND encounter_charge_id = :ll_encounter_charge_id;
if not tf_check() then return

dw_billing.object.procedure_id[pl_row] = ls_perform_procedure_id
dw_billing.object.description[pl_row] = ls_description
dw_billing.object.charge[pl_row] = ldc_charge
dw_billing.object.procedure_type[pl_row] = "TESTPERFORM"



end subroutine

public subroutine test_collect (long pl_row);str_popup popup
str_popup_return popup_return
integer li_sts
string ls_perform_procedure_id
string ls_collection_procedure_id
long ll_treatment_id
integer li_pos
string ls_cpt_code
decimal ldc_charge
string ls_description
long ll_encounter_charge_id

ll_treatment_id = dw_billing.object.treatment_id[pl_row]
ls_description = dw_billing.object.description[pl_row]
ll_encounter_charge_id = dw_billing.object.encounter_charge_id[pl_row]

li_sts = tf_get_test_procedures(encounter.parent_patient.cpr_id, &
										  ll_treatment_id, &
										  ls_perform_procedure_id, &
										  ls_collection_procedure_id)
if li_sts <= 0 then return

if isnull(ls_collection_procedure_id) then
	openwithparm(w_pop_message, "This test does not have a collection code")
	return
end if

li_sts = tf_get_procedure_charge(ls_perform_procedure_id, ls_cpt_code, ldc_charge)
if li_sts <= 0 then return

li_pos = pos(ls_description, " (Send Out)")
if li_pos = 0 then ls_description += " (Send Out)"

UPDATE p_Encounter_Charge
SET procedure_id = :ls_collection_procedure_id,
	 charge = :ldc_charge,
	 procedure_type = 'TESTCOLLECT'
WHERE cpr_id = :encounter.parent_patient.cpr_id
AND encounter_id = :encounter.encounter_id
AND encounter_charge_id = :ll_encounter_charge_id;
if not tf_check() then return

dw_billing.object.procedure_id[pl_row] = ls_collection_procedure_id
dw_billing.object.description[pl_row] = ls_description
dw_billing.object.charge[pl_row] = ldc_charge
dw_billing.object.procedure_type[pl_row] = "TESTCOLLECT"



end subroutine

public subroutine load_billing ();integer li_null
long ll_null
long ll_count

setnull(ll_null)
setnull(li_null)

ll_count = dw_billing.retrieve(current_patient.cpr_id, encounter.encounter_id)

end subroutine

public subroutine item_menu (long pl_row);integer li_sts
str_encounter_charge lstr_encounter_charge

lstr_encounter_charge.cpr_id = current_patient.cpr_id
lstr_encounter_charge.encounter_id = encounter.encounter_id
lstr_encounter_charge.encounter_charge_id = dw_billing.object.encounter_charge_id[pl_row]
lstr_encounter_charge.problem_id = dw_billing.object.problem_id[pl_row]

if isnull(lstr_encounter_charge.encounter_charge_id) then
	dw_billing.clear_selected()
	return
end if

SELECT c. procedure_type,
	c.procedure_id ,
	c.charge ,
	c.bill_flag ,
	c.cpt_code ,
	c.units ,
	c.modifier ,
	c.other_modifiers ,
	p.description ,
	c.last_updated,
	c.last_updated_by,
	c.posted
INTO :lstr_encounter_charge.procedure_type,
	:lstr_encounter_charge.procedure_id ,
	:lstr_encounter_charge.charge,
	:lstr_encounter_charge.charge_bill_flag ,
	:lstr_encounter_charge.cpt_code ,
	:lstr_encounter_charge.units ,
	:lstr_encounter_charge.modifier ,
	:lstr_encounter_charge.other_modifiers ,
	:lstr_encounter_charge.description ,
	:lstr_encounter_charge.last_updated ,
	:lstr_encounter_charge.last_updated_by ,
	:lstr_encounter_charge.posted 
FROM p_Encounter_Charge c
	INNER JOIN c_Procedure p
	ON c.procedure_id = p.procedure_id
WHERE c.cpr_id = :lstr_encounter_charge.cpr_id
AND c.encounter_id = :lstr_encounter_charge.encounter_id
AND c.encounter_charge_id = :lstr_encounter_charge.encounter_charge_id;
if not tf_check() then return

if f_string_to_boolean(lstr_encounter_charge.posted) then
	openwithparm(w_pop_message, "This charge has already been posted to the billing system and cannot be edited")
	return
end if

openwithparm(w_encounter_charge_edit, lstr_encounter_charge)

refresh()

return


//str_popup popup
//str_popup_return popup_return
//string buttons[]
//integer button_pressed, li_sts, li_service_count
//window lw_pop_buttons
//string ls_procedure_type
//long ll_encounter_charge_id
//long ll_problem_id
//
//ls_procedure_type = dw_billing.object.procedure_type[pl_row]
//ll_encounter_charge_id = dw_billing.object.encounter_charge_id[pl_row]
//ll_problem_id = dw_billing.object.problem_id[pl_row]
//
//if ls_procedure_type = "PRIMARY" or ls_procedure_type = "SECONDARY" then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button05.bmp"
//	popup.button_helps[popup.button_count] = "Change Encounter Procedure"
//	popup.button_titles[popup.button_count] = "Change"
//	buttons[popup.button_count] = "CHANGE"
//end if
//
//if ls_procedure_type = "PRIMARY" then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button05.bmp"
//	popup.button_helps[popup.button_count] = "Change Encounter Procedure Level"
//	popup.button_titles[popup.button_count] = "Change Level"
//	buttons[popup.button_count] = "LEVEL"
//end if
//
//if ls_procedure_type = "PRIMARY" or ls_procedure_type = "SECONDARY" then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button13.bmp"
//	popup.button_helps[popup.button_count] = "Delete Encounter Procedure"
//	popup.button_titles[popup.button_count] = "Delete"
//	buttons[popup.button_count] = "DELETE"
//end if
//
//if ls_procedure_type = "TESTCOLLECT" then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button05.bmp"
//	popup.button_helps[popup.button_count] = "Bill For Perform Procedure"
//	popup.button_titles[popup.button_count] = "Perform Code"
//	buttons[popup.button_count] = "TESTPERFORM"
//end if
//
//if ls_procedure_type = "TESTPERFORM" then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button05.bmp"
//	popup.button_helps[popup.button_count] = "Bill For Collect Procedure"
//	popup.button_titles[popup.button_count] = "Collect Code"
//	buttons[popup.button_count] = "TESTCOLLECT"
//end if
//
//if not isnull(ll_encounter_charge_id) and ls_procedure_type <> "ENCOUNTER" and not isnull(ll_problem_id) then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "buttonxm.bmp"
//	popup.button_helps[popup.button_count] = "Don't bill this item"
//	popup.button_titles[popup.button_count] = "Don't Bill"
//	buttons[popup.button_count] = "DONTBILL"
//end if
//
//if not isnull(ll_encounter_charge_id) then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button17.bmp"
//	popup.button_helps[popup.button_count] = "Edit Charge Modifier"
//	popup.button_titles[popup.button_count] = "Modifier"
//	buttons[popup.button_count] = "MODIFIER"
//end if
//
//if not isnull(ll_encounter_charge_id) then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button17.bmp"
//	popup.button_helps[popup.button_count] = "Edit Encounter Charge"
//	popup.button_titles[popup.button_count] = "Edit Charge"
//	buttons[popup.button_count] = "EDIT"
//end if
//
//if not isnull(ll_encounter_charge_id) then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button17.bmp"
//	popup.button_helps[popup.button_count] = "Change number of units to bill"
//	popup.button_titles[popup.button_count] = "Change Units"
//	buttons[popup.button_count] = "UNITS"
//end if
//
//if not isnull(ll_encounter_charge_id) then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button21.bmp"
//	popup.button_helps[popup.button_count] = "Attach This Item to Another Diagnosis"
//	popup.button_titles[popup.button_count] = "Attach to Diagnosis"
//	buttons[popup.button_count] = "ATTACH"
//end if
//
//if popup.button_count > 1 then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button11.bmp"
//	popup.button_helps[popup.button_count] = "Cancel"
//	popup.button_titles[popup.button_count] = "Cancel"
//	buttons[popup.button_count] = "CANCEL"
//end if
//
//popup.button_titles_used = true
//
//if popup.button_count > 1 then
//	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
//	button_pressed = message.doubleparm
//	if button_pressed < 1 or button_pressed > popup.button_count then return
//elseif popup.button_count = 1 then
//	button_pressed = 1
//else
//	return
//end if
//
//dw_billing.setitem(pl_row, "selected_flag", 0)
//
//CHOOSE CASE buttons[button_pressed]
//	CASE "CHANGE"
//		change_procedure(pl_row)
//	CASE "LEVEL"
//		change_level(pl_row)
//	CASE "DELETE"
//		delete_charge(pl_row)
//	CASE "TESTPERFORM"
//		test_perform(pl_row)
//	CASE "TESTCOLLECT"
//		test_collect(pl_row)
//	CASE "DONTBILL"
//		dont_bill(pl_row)
//	CASE "UNITS"
//		change_units(pl_row)
//	CASE "EDIT"
//		edit_charges(pl_row)
//	CASE "MODIFIER"
//		edit_modifier(pl_row)
//	CASE "ATTACH"
//		attach_to_assessments(pl_row)
//	CASE "CANCEL"
//		return
//	CASE ELSE
//END CHOOSE
//
//return
//
//
end subroutine

public subroutine change_level (long pl_row);str_popup popup
str_popup_return popup_return
string ls_cpt_code
decimal ldc_charge
integer li_sts
string ls_procedure_id
string ls_description
string ls_category_id
string ls_category_description
long ll_encounter_charge_id
string ls_visit_code_group

ls_visit_code_group = datalist.encounter_type_visit_code_group(encounter.encounter_type)

popup.dataobject = "dw_em_visit_code_item"
popup.displaycolumn = 5
popup.datacolumn = 4
popup.argument_count = 1
popup.argument[1] = ls_visit_code_group

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_procedure_id = popup_return.items[1]

current_patient.set_encounter_property(encounter.encounter_id, "Visit Code", ls_procedure_id)

refresh()

end subroutine

public function integer refresh ();string ls_code_check_status
integer li_sts
string ls_display_only

if isvalid(encounter) and not isnull(encounter) then
	current_patient.encounters.refresh_encounter(encounter)
else
	li_sts = current_patient.encounters.encounter(encounter, service.encounter_id)
	if li_sts <= 0 then
		log.log(this, "open", "Error getting encounter (" + string(service.encounter_id) + ")", 4)
		return -1
	end if
end if


load_billing()

st_notes.text = encounter.billing_note

if encounter.bill_flag = "Y" then
	is_billed = true
	st_billing_encounter.backcolor = color_object_selected
	st_billing_encounter.text = "Yes"
else
	is_billed = false
	st_billing_encounter.backcolor = color_object
	st_billing_encounter.text = "No"
end if

if encounter.billing_hold_flag = "Y" then
	st_billing_hold.text = "Yes"
	st_billing_hold.backcolor = color_object_selected
else
	st_billing_hold.text = "No"
	st_billing_hold.backcolor = color_object
end if

li_sts = tf_get_domain_item("COURTESY_CODE", encounter.courtesy_code, st_courtesy_code.text)
if li_sts <= 0 then
	st_courtesy_code.text = ""
end if

st_encounter_type.text = datalist.encounter_type_description(encounter.encounter_type)
	
// Display the Code Check status
ls_code_check_status = current_patient.encounters.get_property_value(current_display_encounter.encounter_id, "Code Check Status")
if isnull(ls_code_check_status) then
	st_code_check_status.text = "Not Performed"
else
	st_code_check_status.text = wordcap(ls_code_check_status)
	if lower(ls_code_check_status) = "failed" then
		st_code_check_status.textcolor = color_text_error
	elseif lower(ls_code_check_status) = "warning" then
		st_code_check_status.textcolor = color_text_warning
	else
		st_code_check_status.textcolor = color_text_normal
	end if
end if

refresh_coding()

// Decide whether or not we're in display-only mode
if encounter.billing_posted then
	ls_display_only = "Display Only (Billing has already been posted)"
elseif current_user.user_id = encounter.attending_doctor &
	or current_user.user_id = user_list.supervisor_user_id(encounter.attending_doctor) &
	or current_user.user_id = encounter.supervising_doctor &
	or current_user.check_privilege("Encounter Coding")    then
	setnull(ls_display_only)
else
	ls_display_only = "Display Only (You are not the encounter owner)"
end if

if isnull(ls_display_only) then
	st_display_only.visible = false
	dw_billing.y = st_display_only.y
	dw_billing.height += st_display_only.height
	display_only = false
else
	st_display_only.visible = true
	st_display_only.text = ls_display_only
	display_only = true
	cb_new_visit_charge.visible = false
	cb_new_visit_charge_2.visible = false
	st_courtesy_code.enabled = false
	st_notes.enabled = false
	st_billing_encounter.enabled = false
	st_billing_hold.enabled = false
	st_code_check_status.enabled = false
end if

return 1



end function

public subroutine change_units (long pl_row);str_popup popup
str_popup_return popup_return
long ll_encounter_charge_id
real lr_units
string ls_cpt_code

ll_encounter_charge_id = dw_billing.object.encounter_charge_id[pl_row]
lr_units = dw_billing.object.units[pl_row]

popup.argument_count = 1
popup.argument[1] = "BILLINGUNITS"
popup.title = "Enter Number of Units to Bill"
popup.realitem = lr_units

openwithparm(w_number, popup)
popup_return = message.powerobjectparm
if upper(popup_return.item) = "CANCEL" then return
if popup_return.realitem < 1 or isnull(popup_return.realitem) then return
if popup_return.realitem = lr_units then return

UPDATE p_Encounter_Charge
SET	units = :popup_return.realitem 
WHERE	cpr_id = :encounter.parent_patient.cpr_id
AND encounter_id = :encounter.encounter_id
AND	encounter_charge_id = :ll_encounter_charge_id;
if not tf_check() then return

dw_billing.object.units[pl_row] = popup_return.realitem


end subroutine

public subroutine edit_modifier (long pl_row);str_popup popup
str_popup_return popup_return
long ll_encounter_charge_id
decimal ldc_charge
string ls_procedure_id


ll_encounter_charge_id = dw_billing.object.encounter_charge_id[pl_row]

popup.data_row_count = 4
popup.items[1] = encounter.parent_patient.cpr_id
popup.items[2] = string(encounter.encounter_id)
popup.items[3] = string(ll_encounter_charge_id)
popup.items[4] = string(dw_billing.object.charge[pl_row])
popup.title = dw_billing.object.description[pl_row]
popup.multiselect = true

openwithparm(w_charge_edit, popup)
popup_return = message.powerobjectparm

if popup_return.item_count <> 2 then return

ldc_charge = dec(popup_return.items[1])

UPDATE p_Encounter_Charge
SET	charge = :ldc_charge 
WHERE	cpr_id = :encounter.parent_patient.cpr_id
AND encounter_id = :encounter.encounter_id
AND	encounter_charge_id = :ll_encounter_charge_id;
if not tf_check() then return

dw_billing.object.charge[pl_row] = ldc_charge

ls_procedure_id = dw_billing.object.procedure_id[pl_row]

if popup_return.items[2] = "TRUE" then
	UPDATE c_Procedure
	SET	charge = :ldc_charge
	WHERE procedure_id = :ls_procedure_id;
	if not tf_check() then return
end if


end subroutine

public subroutine refresh_coding ();integer li_encounter_level

if isnull(current_display_encounter) then
	cb_coding.visible = false
	return
end if

cb_coding.visible = true

li_encounter_level = f_current_visit_level(current_patient.cpr_id, current_display_encounter.encounter_id)

if isnull(li_encounter_level) then
	cb_coding.text = "0"
else
	cb_coding.text = string(li_encounter_level)
end if


end subroutine

public subroutine load_billing_old ();str_encounter_assessment lstr_assessments[]
integer li_assessment_count
integer i, j
integer li_null
long ll_sort_sequence
long ll_row
long ll_null
long ll_count
boolean lb_billed
string ls_name
string ls_bill_flag

setnull(ll_null)
setnull(li_null)

encounter.get_billing(lstr_assessments, li_assessment_count)

dw_billing.setredraw(false)

dw_billing.reset()

if li_assessment_count = 0 then
	some_assessments = false
	cb_new_visit_charge.enabled = false
	ll_row = dw_billing.insertrow(0)
	dw_billing.setitem(ll_row, "description", "No Billed Items")
else
	some_assessments = true
	cb_new_visit_charge.enabled = true
	for i = 1 to li_assessment_count
		lb_billed = false
		for j = 1 to lstr_assessments[i].charge_count
			ls_bill_flag = lstr_assessments[i].bill_flag
			if ls_bill_flag = "Y" then ls_bill_flag = lstr_assessments[i].charge[j].assessment_charge_bill_flag
			if ls_bill_flag = "Y" then ls_bill_flag = lstr_assessments[i].charge[j].charge_bill_flag
			if ls_bill_flag <> "Y" then continue
			lb_billed = true
			ll_row = dw_billing.insertrow(0)
			dw_billing.setitem(ll_row, "assessment_description", lstr_assessments[i].description)
			dw_billing.setitem(ll_row, "icd_9_code", lstr_assessments[i].icd_9_code)
			dw_billing.setitem(ll_row, "description", lstr_assessments[i].charge[j].description)
			dw_billing.setitem(ll_row, "units", lstr_assessments[i].charge[j].units)
			dw_billing.setitem(ll_row, "cpt_code", lstr_assessments[i].charge[j].cpt_code)
			dw_billing.setitem(ll_row, "modifier", lstr_assessments[i].charge[j].modifier)
			dw_billing.setitem(ll_row, "other_modifiers", lstr_assessments[i].charge[j].other_modifiers)
			dw_billing.setitem(ll_row, "charge", lstr_assessments[i].charge[j].charge)
			dw_billing.setitem(ll_row, "last_updated", lstr_assessments[i].charge[j].last_updated)
			dw_billing.setitem(ll_row, "last_updated_by", lstr_assessments[i].charge[j].last_updated_by)
			if not isnull(lstr_assessments[i].charge[j].last_updated_by) then
				ls_name = user_list.user_full_name(lstr_assessments[i].charge[j].last_updated_by)
				dw_billing.setitem(ll_row, "last_updated_name", ls_name)
			end if
			dw_billing.setitem(ll_row, "posted", lstr_assessments[i].charge[j].posted)
			dw_billing.setitem(ll_row, "cpr_id", encounter.parent_patient.cpr_id)
			dw_billing.setitem(ll_row, "problem_id", lstr_assessments[i].problem_id)
			dw_billing.setitem(ll_row, "procedure_type", lstr_assessments[i].charge[j].procedure_type)
			dw_billing.setitem(ll_row, "procedure_id", lstr_assessments[i].charge[j].procedure_id)
			dw_billing.setitem(ll_row, "treatment_id", lstr_assessments[i].charge[j].treatment_id)
			dw_billing.setitem(ll_row, "encounter_charge_id", lstr_assessments[i].charge[j].encounter_charge_id)
			ll_sort_sequence = (lstr_assessments[i].charge[j].encounter_charge_id * 100) + i // Sort the assessments consistently within the charge
			if lstr_assessments[i].charge[j].procedure_type = "PRIMARY" then
				ll_sort_sequence = lstr_assessments[i].assessment_sequence
				if isnull(ll_sort_sequence) then ll_sort_sequence = i
				ll_sort_sequence -= 900000001
			end if
			if lstr_assessments[i].charge[j].procedure_type = "SECONDARY" then
				ll_sort_sequence = lstr_assessments[i].assessment_sequence
				if isnull(ll_sort_sequence) then ll_sort_sequence = i
				ll_sort_sequence -= 900000000
			end if
			dw_billing.setitem(ll_row, "sort_sequence", ll_sort_sequence)
			dw_billing.setitem(ll_row, "assessment_bill_flag", lstr_assessments[i].bill_flag)
			dw_billing.setitem(ll_row, "treatment_bill_flag", lstr_assessments[i].charge[j].charge_bill_flag)
			dw_billing.setitemstatus(ll_row, 0, primary!, datamodified!)
			dw_billing.setitemstatus(ll_row, 0, primary!, notmodified!)
		next
		if not lb_billed then
			ll_row = dw_billing.insertrow(0)
			dw_billing.setitem(ll_row, "assessment_description", lstr_assessments[i].description)
			dw_billing.setitem(ll_row, "icd_9_code", lstr_assessments[i].icd_9_code)
			dw_billing.setitem(ll_row, "description", "Diagnoses With No Billed Items")
			dw_billing.setitem(ll_row, "cpr_id", encounter.parent_patient.cpr_id)
			dw_billing.setitem(ll_row, "problem_id", lstr_assessments[i].problem_id)
			dw_billing.setitem(ll_row, "assessment_bill_flag", lstr_assessments[i].bill_flag)
			dw_billing.setitem(ll_row, "treatment_bill_flag", "Y")
			dw_billing.setitem(ll_row, "encounter_charge_id", ll_null)
			dw_billing.setitem(ll_row, "sort_sequence", 1000000000)
		end if
	next
end if

temp_datastore.dataobject = "dw_charges_not_billed"
temp_datastore.settransobject(sqlca)
temp_datastore.retrieve(encounter.parent_patient.cpr_id, encounter.encounter_id)
ll_count = temp_datastore.rowcount()

for i = 1 to ll_count
	ll_row = dw_billing.insertrow(0)
	dw_billing.object.assessment_description[ll_row] = "Not Billed"
	dw_billing.object.description[ll_row] = temp_datastore.object.description[i]
	dw_billing.object.cpr_id[ll_row] = encounter.parent_patient.cpr_id
	dw_billing.object.treatment_bill_flag[ll_row] = "N"
	dw_billing.object.problem_id[ll_row] = ll_null
	dw_billing.object.treatment_id[ll_row] = temp_datastore.object.treatment_id[i]
	dw_billing.object.encounter_charge_id[ll_row] = temp_datastore.object.encounter_charge_id[i]
	dw_billing.object.procedure_type[ll_row] = temp_datastore.object.procedure_type[i]
	dw_billing.object.sort_sequence[ll_row] = 900000000
next

dw_billing.sort()
dw_billing.groupcalc()
dw_billing.setredraw(true)


end subroutine

public function integer move_assessment (long pl_row, string ps_direction);long ll_encounter_charge_id
long ll_problem_id

ll_encounter_charge_id = dw_billing.object.encounter_charge_id[pl_row]
ll_problem_id = dw_billing.object.problem_id[pl_row]


sqlca.jmj_encounter_charge_move(current_patient.cpr_id, &
						encounter.encounter_id, &
						ll_encounter_charge_id, &
						ll_problem_id, &
						ps_direction)
if not tf_check() then return -1

refresh()


end function

on w_billing_edit.create
int iCurrent
call super::create
this.dw_billing=create dw_billing
this.st_mod=create st_mod
this.st_notes=create st_notes
this.st_note_title=create st_note_title
this.st_courtesy_code=create st_courtesy_code
this.st_hold_title=create st_hold_title
this.st_billing_hold=create st_billing_hold
this.cb_new_visit_charge=create cb_new_visit_charge
this.cb_new_visit_charge_2=create cb_new_visit_charge_2
this.st_billing_title=create st_billing_title
this.st_billing_encounter=create st_billing_encounter
this.cb_finished=create cb_finished
this.cb_be_back=create cb_be_back
this.st_encounter_type=create st_encounter_type
this.st_enc_type_title=create st_enc_type_title
this.st_code_check_status=create st_code_check_status
this.st_code_check_status_title=create st_code_check_status_title
this.cb_coding=create cb_coding
this.st_display_only=create st_display_only
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_billing
this.Control[iCurrent+2]=this.st_mod
this.Control[iCurrent+3]=this.st_notes
this.Control[iCurrent+4]=this.st_note_title
this.Control[iCurrent+5]=this.st_courtesy_code
this.Control[iCurrent+6]=this.st_hold_title
this.Control[iCurrent+7]=this.st_billing_hold
this.Control[iCurrent+8]=this.cb_new_visit_charge
this.Control[iCurrent+9]=this.cb_new_visit_charge_2
this.Control[iCurrent+10]=this.st_billing_title
this.Control[iCurrent+11]=this.st_billing_encounter
this.Control[iCurrent+12]=this.cb_finished
this.Control[iCurrent+13]=this.cb_be_back
this.Control[iCurrent+14]=this.st_encounter_type
this.Control[iCurrent+15]=this.st_enc_type_title
this.Control[iCurrent+16]=this.st_code_check_status
this.Control[iCurrent+17]=this.st_code_check_status_title
this.Control[iCurrent+18]=this.cb_coding
this.Control[iCurrent+19]=this.st_display_only
end on

on w_billing_edit.destroy
call super::destroy
destroy(this.dw_billing)
destroy(this.st_mod)
destroy(this.st_notes)
destroy(this.st_note_title)
destroy(this.st_courtesy_code)
destroy(this.st_hold_title)
destroy(this.st_billing_hold)
destroy(this.cb_new_visit_charge)
destroy(this.cb_new_visit_charge_2)
destroy(this.st_billing_title)
destroy(this.st_billing_encounter)
destroy(this.cb_finished)
destroy(this.cb_be_back)
destroy(this.st_encounter_type)
destroy(this.st_enc_type_title)
destroy(this.st_code_check_status)
destroy(this.st_code_check_status_title)
destroy(this.cb_coding)
destroy(this.st_display_only)
end on

event open;call super::open;str_popup_return popup_return
integer li_sts
long ll_menu_id

popup_return.item_count = 1
popup_return.items[1] = "ERROR"

service = message.powerobjectparm

if isnull(service.encounter_id) then
	log.log(this, "open", "Null Encounter_id", 4)
	closewithreturn(this, popup_return)
	return
end if

// Don't offer the "I'll Be Back" option for manual services
if service.manual_service then
	cb_be_back.visible = false
	max_buttons = 4
end if

ll_menu_id = long(service.get_attribute("menu_id"))
paint_menu(ll_menu_id)

code_check_perform_service = service.get_attribute("code_check_perform_service")
if isnull(code_check_perform_service) then code_check_perform_service = "Code Check Perform"

code_check_review_service = service.get_attribute("code_check_review_service")
if isnull(code_check_review_service) then code_check_review_service = "Code Check Review"

if not f_is_module_licensed("Code Checker") then
	st_code_check_status.visible = false
	st_code_check_status_title.visible = false
end if

coding_service = service.get_attribute("coding_service")
if isnull(coding_service) then coding_service = "EMCODING"

dw_billing.settransobject(sqlca)

li_sts = refresh()
if li_sts < 0 then
	log.log(this, "open", "Error displaying encounter billing", 4)
	closewithreturn(this, popup_return)
	return
end if

end event

type pb_epro_help from w_window_base`pb_epro_help within w_billing_edit
integer x = 2857
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_billing_edit
integer x = 23
integer y = 1540
end type

type dw_billing from u_dw_pick_list within w_billing_edit
integer y = 76
integer width = 1806
integer height = 1452
integer taborder = 10
string dataobject = "dw_jmj_encounter_charges"
boolean vscrollbar = true
boolean border = false
boolean livescroll = false
end type

event post_click;call super::post_click;string ls_pointer

if lastrow <= 0 then return

if display_only then return

CHOOSE CASE lower(lastcolumnname)
	CASE "p_up"
		move_assessment(clicked_row, "UP")
	CASE "p_down"
		move_assessment(clicked_row, "DOWN")
	CASE ELSE
		ls_pointer = getobjectatpointer()
		if encounter.encounter_status = "OPEN" then
			if lastheader or ls_pointer = "" Then
				item_menu(lastrow)
			end if
		else
			setitem(lastrow, "selected_flag", 0)
		end if
END CHOOSE

end event

event constructor;call super::constructor;active_header = true

end event

type st_mod from statictext within w_billing_edit
integer x = 1915
integer y = 596
integer width = 475
integer height = 68
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Billing Courtesy"
boolean focusrectangle = false
end type

type st_notes from statictext within w_billing_edit
integer x = 1920
integer y = 900
integer width = 928
integer height = 332
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.title = "Select Billing Notes"
popup.data_row_count = 2
popup.items[1] = "BillingNotes"
popup.items[2] = ""
openwithparm(w_pick_top_20_multiline, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

text = popup_return.items[1]

current_patient.encounters.modify_encounter(encounter.encounter_id, "billing_note", popup_return.items[1])
current_patient.encounters.refresh_encounter(encounter)



end event

type st_note_title from statictext within w_billing_edit
integer x = 1920
integer y = 824
integer width = 247
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Notes"
boolean focusrectangle = false
end type

type st_courtesy_code from statictext within w_billing_edit
integer x = 1915
integer y = 672
integer width = 928
integer height = 128
boolean bringtotop = true
integer textsize = -10
integer weight = 700
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

popup.dataobject = "dw_domain_pick_list"
popup.datacolumn = 2
popup.displaycolumn = 3
popup.argument_count = 1
popup.argument[1] = "COURTESY_CODE"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count = 0 then return

text = popup_return.descriptions[1]

current_patient.encounters.modify_encounter(encounter.encounter_id, "courtesy_code", popup_return.items[1])
current_patient.encounters.refresh_encounter(encounter)

end event

type st_hold_title from statictext within w_billing_edit
integer x = 2423
integer y = 1272
integer width = 192
integer height = 136
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Billing Hold:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_billing_hold from statictext within w_billing_edit
integer x = 2638
integer y = 1292
integer width = 233
integer height = 96
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "No"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if encounter.billing_hold_flag = "Y" then
	text = "No"
	st_billing_hold.backcolor = color_object
	current_patient.encounters.modify_encounter(encounter.encounter_id, "billing_hold_flag", "N")
else
	text = "Yes"
	st_billing_hold.backcolor = color_object_selected
	current_patient.encounters.modify_encounter(encounter.encounter_id, "billing_hold_flag", "Y")
end if

current_patient.encounters.refresh_encounter(encounter)

end event

type cb_new_visit_charge from commandbutton within w_billing_edit
integer x = 1920
integer y = 304
integer width = 928
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Primary Visit Charge"
end type

event clicked;new_visit_charge()

end event

type cb_new_visit_charge_2 from commandbutton within w_billing_edit
event clicked pbm_bnclicked
integer x = 1920
integer y = 460
integer width = 928
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Secondary Visit Charge"
end type

event clicked;new_secondary_visit_charge()

end event

type st_billing_title from statictext within w_billing_edit
integer x = 1838
integer y = 1272
integer width = 306
integer height = 136
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Bill this Encounter:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_billing_encounter from statictext within w_billing_edit
integer x = 2162
integer y = 1292
integer width = 233
integer height = 96
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "No"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if is_billed then
	text = "No"
	is_billed = false
	st_billing_encounter.backcolor = color_object
	current_patient.encounters.modify_encounter(encounter.encounter_id, "bill_flag", "N")
else
	text = "Yes"
	is_billed = true
	st_billing_encounter.backcolor = color_object_selected
	current_patient.encounters.modify_encounter(encounter.encounter_id, "bill_flag", "Y")
end if

current_patient.encounters.refresh_encounter(encounter)


end event

type cb_finished from commandbutton within w_billing_edit
integer x = 2427
integer y = 1600
integer width = 443
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)
end event

type cb_be_back from commandbutton within w_billing_edit
integer x = 1961
integer y = 1600
integer width = 443
integer height = 108
integer taborder = 40
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

popup_return.item_count = 0
closewithreturn(parent, popup_return)
end event

type st_encounter_type from statictext within w_billing_edit
integer x = 1838
integer y = 120
integer width = 1056
integer height = 120
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type st_enc_type_title from statictext within w_billing_edit
integer x = 2053
integer y = 20
integer width = 645
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "E && M Coding Level:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_code_check_status from statictext within w_billing_edit
integer x = 2162
integer y = 1436
integer width = 690
integer height = 96
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Not Performed"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
string ls_code_check_status
str_attributes lstr_attributes
integer li_idx

ls_code_check_status = current_patient.encounters.get_property_value(current_display_encounter.encounter_id, "Code Check Status")
if isnull(ls_code_check_status) then
	openwithparm(w_pop_yes_no, "The Code Check service has not yet been performed on this encounter.  Do you with to perform the Code Check service now?")
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return

	li_idx = f_please_wait_open()
	
	service_list.do_service(current_patient.cpr_id, &
									current_service.encounter_id, &
									code_check_perform_service, &
									lstr_attributes)
	
	f_please_wait_close(li_idx)
end if

service_list.do_service(current_patient.cpr_id, &
								current_service.encounter_id, &
								code_check_review_service, &
								lstr_attributes)

end event

type st_code_check_status_title from statictext within w_billing_edit
integer x = 1957
integer y = 1416
integer width = 187
integer height = 136
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Code Check Status:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_coding from commandbutton within w_billing_edit
integer x = 2715
integer y = 12
integer width = 133
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "1"
end type

event clicked;str_attributes lstr_attributes
integer li_new_level
str_popup_return popup_return

if isnull(current_display_encounter) then return

service_list.do_service(coding_service)

li_new_level = f_current_visit_level(service.cpr_id, service.encounter_id)

if isnull(li_new_level) then return

if string(li_new_level) <> text then
	text = string(li_new_level)
	openwithparm(w_pop_yes_no, "The visit level has changed.  Do you wish to regenerate the visit code?")
	popup_return = message.powerobjectparm
	if popup_return.item = "YES" then
		// Regenerate the visit level
		encounter.set_billing_procedure(true)
	end if
end if



refresh()

end event

type st_display_only from statictext within w_billing_edit
integer width = 1755
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Display Only (Billing has already been posted)"
alignment alignment = center!
boolean focusrectangle = false
end type

