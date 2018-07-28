$PBExportHeader$u_component_service_new_progress_note.sru
forward
global type u_component_service_new_progress_note from u_component_service
end type
end forward

global type u_component_service_new_progress_note from u_component_service
end type
global u_component_service_new_progress_note u_component_service_new_progress_note

type variables

private string progress_pick_dw
private string key_pick_dw
private string progress_type_pick_code

private string progress_type

private boolean progress_key_required
private boolean progress_key_enumerated

private str_encounter_description encounter
private str_assessment_description assessment

private string top_20_specific
private string top_20_generic

end variables

forward prototypes
private function integer set_progress_type ()
public function integer xx_do_service ()
end prototypes

private function integer set_progress_type ();string ls_progress_key_required_flag
string ls_progress_key_enumerated_flag
integer li_sts

progress_type = get_attribute("progress_type")
if isnull(progress_type) then
	log.log(this, "set_progress_type()", "no progress_type", 4)
	return -1
end if

CHOOSE CASE lower(context_object)
	CASE "patient"
		progress_pick_dw = "dw_patient_progress_type_pick"
		key_pick_dw = "dw_patient_progress_key_pick"
		progress_type_pick_code = "PATIENT"
//		description = current_patient.name()
		top_20_specific = "PRGPT|" + progress_type
		top_20_generic = "PRGPT"
		
		// Set the progress_key flags
		progress_key_required = false
		progress_key_enumerated = false
	CASE "encounter"
		if isnull(encounter_id) then
			log.log(this, "open", "Null encounter_id", 4)
			return -1
		end if
		li_sts = current_patient.encounters.encounter(encounter, encounter_id)
		if li_sts <= 0 then
			log.log(this, "open", "Error getting assessment object (" + string(problem_id) + ")", 4)
			return -1
		end if
		progress_pick_dw = "dw_encounter_progress_type_pick"
		key_pick_dw = "dw_encounter_progress_key_pick"
		progress_type_pick_code = encounter.encounter_type
//		description = encounter.description
		top_20_specific = "PRGEN|" + progress_type + "|" + encounter.encounter_type
		top_20_generic = "PRGEN"
		
		// Set the progress_key flags
		SELECT progress_key_required_flag,
				progress_key_enumerated_flag
		INTO :ls_progress_key_required_flag,
				:ls_progress_key_enumerated_flag
		FROM c_Encounter_Type_Progress_Type
		WHERE encounter_type = :encounter.encounter_type
		AND progress_type = :progress_type;
		if not tf_check() then return -1
		if sqlca.sqlcode = 100 then
			progress_key_required = false
			progress_key_enumerated = false
		else
			progress_key_required = f_string_to_boolean(ls_progress_key_required_flag)
			progress_key_enumerated = f_string_to_boolean(ls_progress_key_enumerated_flag)
		end if
	CASE "assessment"
		if isnull(problem_id) then
			log.log(this, "open", "Null problem_id", 4)
			return -1
		end if
		li_sts = current_patient.assessments.assessment(assessment, problem_id)
		if li_sts <= 0 then
			log.log(this, "open", "Error getting assessment object (" + string(problem_id) + ")", 4)
			return -1
		end if
		progress_pick_dw = "dw_assessment_progress_type_pick"
		key_pick_dw = "dw_assessment_progress_key_pick"
		progress_type_pick_code = assessment.assessment_type
//		description = assessment.assessment
		top_20_generic = "PRGAS|" + progress_type + "|" + assessment.assessment_type
		top_20_specific = top_20_generic + "|" + assessment.assessment_id
		
		// Set the progress_key flags
		SELECT progress_key_required_flag,
				progress_key_enumerated_flag
		INTO :ls_progress_key_required_flag,
				:ls_progress_key_enumerated_flag
		FROM c_Assessment_Type_Progress_Type
		WHERE assessment_type = :assessment.assessment_type
		AND progress_type = :progress_type;
		if not tf_check() then return -1
		if sqlca.sqlcode = 100 then
			progress_key_required = false
			progress_key_enumerated = false
		else
			progress_key_required = f_string_to_boolean(ls_progress_key_required_flag)
			progress_key_enumerated = f_string_to_boolean(ls_progress_key_enumerated_flag)
		end if
	CASE "treatment"
		if isnull(treatment) then
			log.log(this, "open", "treatment progress must have treatment object", 4)
			return -1
		end if
		progress_pick_dw = "dw_treatment_progress_type_pick"
		key_pick_dw = "dw_treatment_progress_key_pick"
		progress_type_pick_code = treatment.treatment_type
//		description = treatment.treatment_description
		top_20_generic = "PRGTR|" + progress_type + "|" + treatment.treatment_type
		top_20_specific = top_20_generic
		if not isnull(treatment.specialty_id) and trim(treatment.specialty_id) <> "" then top_20_specific += "|" + treatment.specialty_id
		if not isnull(treatment.drug_id) and trim(treatment.drug_id) <> "" then top_20_specific += "|" + treatment.drug_id
		if not isnull(treatment.procedure_id) and trim(treatment.procedure_id) <> "" then top_20_specific += "|" + treatment.procedure_id
		
		// Set the progress_key flags
		SELECT progress_key_required_flag,
				progress_key_enumerated_flag
		INTO :ls_progress_key_required_flag,
				:ls_progress_key_enumerated_flag
		FROM c_Treatment_Type_Progress_Type
		WHERE treatment_type = :treatment.treatment_type
		AND progress_type = :progress_type;
		if not tf_check() then return -1
		if sqlca.sqlcode = 100 then
			progress_key_required = false
			progress_key_enumerated = false
		else
			progress_key_required = f_string_to_boolean(ls_progress_key_required_flag)
			progress_key_enumerated = f_string_to_boolean(ls_progress_key_enumerated_flag)
		end if
	CASE ELSE
		log.log(this, "set_progress_type()", "invalid context_object (" + context_object + ")", 4)
		return -1
END CHOOSE

if len(top_20_specific) > 64 then top_20_specific = left(top_20_specific, 64)



return 1



end function

public function integer xx_do_service ();str_popup popup
str_popup_return popup_return
string ls_progress
long ll_risk_level
string ls_progress_key
long ll_row
string ls_find
string ls_suffix
integer li_sts


li_sts = set_progress_type()
if li_sts <= 0 then
	log.log(this, "open", "Error setting progress object", 4)
	return -1
end if

// If we get passed in a progress_key, then use it
ls_progress_key = get_attribute("progress_key")

// Otherwise, prompt the user for the progress_key
if isnull(ls_progress_key) then
	DO WHILE true
		if progress_key_enumerated then
			popup.title = "Select a " + progress_type + " title for " + context_description
			popup.data_row_count = 0
			popup.dataobject = key_pick_dw
			popup.datacolumn = 3
			popup.displaycolumn = 3
			popup.argument_count = 2
			popup.argument[1] = progress_type_pick_code
			popup.argument[2] = progress_type
			if not progress_key_required then
				popup.add_blank_row = true
				popup.blank_text = "<None>"
			end if
			popup.auto_singleton = true
			openwithparm(w_pop_pick, popup)
			popup_return = message.powerobjectparm
			if popup_return.item_count = 1 then
				ls_progress_key = popup_return.items[1]
			end if
		else
			popup.title = "Please select a title for this new " + progress_type
			popup.argument_count = 1
			popup.argument[1] = "PRG|" + progress_type + "|" + context_object + "|" + progress_type_pick_code
			
			openwithparm(w_pop_prompt_string, popup)
			popup_return = message.powerobjectparm
			if popup_return.item_count = 1 then
				ls_progress_key = popup_return.items[1]
			end if
		end if
		
		if trim(ls_progress_key) = "" then setnull(ls_progress_key)
		
		// Exit loop if we have a progress_key or we don't need one
		if not isnull(ls_progress_key) or not progress_key_required then exit
		
		// If we get here then we need to ask the user if they want to cancel the new progress note
		popup.title = "A " + progress_type + " title is required.  Do you wish to:"
		popup.data_row_count = 2
		popup.items[1] = "Enter a " + progress_type + " Title"
		popup.items[2] = "Cancel"
		openwithparm(w_pop_choices_2, popup)
		li_sts = message.doubleparm
		if li_sts = 2 then return 2
	
	LOOP
end if

if isnull(ls_progress_key) then
	ls_suffix = ""
else
	ls_suffix = ls_progress_key
end if

// If we get passed in a progress, then use it
ls_progress = get_attribute("progress_note")
get_attribute("risk_level", ll_risk_level)

if isnull(ls_progress) then
	// Prepare the popup structure for the progress note edit screen
	popup.data_row_count = 3
	popup.items[1] = top_20_specific + "|" + ls_suffix
	popup.items[2] = top_20_generic + "|" + ls_suffix
	popup.items[3] = ""
	popup.title = progress_type + " for " + context_description
	
	// Edit/Create the progress note
	openwithparm(service_window, popup, "w_progress_note_edit")
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 2 then return 2
	
	if isnull(popup_return.items[1]) or trim(popup_return.items[1]) = "" then return 2
	
	ls_progress = popup_return.items[1]
	ll_risk_level = long(popup_return.items[2])
end if

// Set the progress_note
CHOOSE CASE lower(context_object)
	CASE "patient"
		li_sts = current_patient.set_progress(progress_type, ls_progress_key, ls_progress, ll_risk_level)
	CASE "encounter"
		li_sts = current_patient.encounters.set_encounter_progress(encounter.encounter_id, progress_type, ls_progress_key, ls_progress, ll_risk_level)
	CASE "assessment"
		li_sts = current_patient.assessments.set_progress(assessment.problem_id, progress_type, ls_progress_key, ls_progress, ll_risk_level)
	CASE "treatment"
		li_sts = current_patient.treatments.set_treatment_progress(treatment.treatment_id, progress_type, ls_progress_key, ls_progress, ll_risk_level)
END CHOOSE

return 1

end function

on u_component_service_new_progress_note.create
call super::create
end on

on u_component_service_new_progress_note.destroy
call super::destroy
end on

