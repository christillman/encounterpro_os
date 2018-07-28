HA$PBExportHeader$u_dw_progress_display.sru
forward
global type u_dw_progress_display from u_dw_pick_list
end type
end forward

global type u_dw_progress_display from u_dw_pick_list
integer width = 2651
integer height = 1064
string dataobject = "dw_progress_display"
end type
global u_dw_progress_display u_dw_progress_display

type variables
u_component_service service

string progress_object
string progress_type

boolean progress_key_required
boolean progress_key_enumerated

str_encounter_description encounter
str_assessment_description assessment

string progress_pick_dw
string key_pick_dw
string progress_type_pick_code

string sort = "D"

long max_length

string top_20_specific
string top_20_generic

string description

str_attributes state_attributes
string new_attachment_service = "EXTERNAL_SOURCE"

string new_progress_note_service = "NEW_PROGRESS_NOTE"

end variables

forward prototypes
public subroutine sort_notes ()
public subroutine note_menu (long pl_row)
public function integer delete_progress_note (long pl_row)
public subroutine set_top_20_codes ()
public function integer set_progress_type (string ps_progress_type)
public function integer initialize (u_component_service puo_service, string ps_progress_object)
public function integer new_attachment ()
public function integer edit_progress_note (long pl_row)
public function integer get_notes ()
public function integer new_progress_note ()
public function integer set_progress (string ps_progress_type, string ps_progress_key, string ps_progress, datetime pdt_progress_date_time, long pl_risk_level)
public function string trim_progress_key_old (string ps_progress_key)
public function string new_progress_key_old (string ps_progress_key)
end prototypes

public subroutine sort_notes ();string ls_sort

if sort = "A" then
	ls_sort = "progress_date_time A"
else
	ls_sort = "progress_date_time D"
end if

setsort(ls_sort)
sort()

end subroutine

public subroutine note_menu (long pl_row);str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed
window lw_pop_buttons
long ll_actual_length
long ll_attachment_id

ll_actual_length = object.actual_length[pl_row]
ll_attachment_id = object.attachment_id[pl_row]

if isnull(ll_attachment_id) then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit Progress Note"
	popup.button_titles[popup.button_count] = "Edit"
	buttons[popup.button_count] = "EDIT"
end if

if not isnull(ll_attachment_id) then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button21.bmp"
	popup.button_helps[popup.button_count] = "Display Attachment"
	popup.button_titles[popup.button_count] = "Display Attachment"
	buttons[popup.button_count] = "ATTACHMENT"
end if

if ll_actual_length > max_length then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Display Entire Progress Note"
	popup.button_titles[popup.button_count] = "Display All"
	buttons[popup.button_count] = "DISPLAY"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Delete Progress Note"
	popup.button_titles[popup.button_count] = "Delete"
	buttons[popup.button_count] = "DELETE"
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
	button_pressed = message.doubleparm
	if button_pressed < 1 or button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	button_pressed = 1
else
	return
end if

CHOOSE CASE buttons[button_pressed]
	CASE "EDIT"
		edit_progress_note(pl_row)
	CASE "ATTACHMENT"
		f_display_attachment(ll_attachment_id)
		get_notes()
	CASE "DISPLAY"
		popup.data_row_count = 1
		popup.title = "Assessment Progress Note"
		popup.items[1] = object.progress_all[pl_row]
		openwithparm(w_display_large_string, popup)
	CASE "DELETE"
		openwithparm(w_pop_yes_no, "Are you sure you wish to delete this progress note?")
		popup_return = message.powerobjectparm
		if popup_return.item = "YES" then
			delete_progress_note(pl_row)
		end if
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return


end subroutine

public function integer delete_progress_note (long pl_row);str_popup popup
str_popup_return popup_return
string ls_progress
string ls_progress_type
string ls_progress_key
long ll_risk_level
datetime ldt_progress_date_time

ldt_progress_date_time = object.progress_date_time[pl_row]
ls_progress_type = object.progress_type[pl_row]
ls_progress_key = object.progress_key[pl_row]
ll_risk_level = object.risk_level[pl_row]

// To delete a progress note, just set it to null
setnull(ls_progress)

set_progress(ls_progress_type, ls_progress_key, ls_progress, ldt_progress_date_time, ll_risk_level)

get_notes()

return 1

end function

public subroutine set_top_20_codes ();

CHOOSE CASE lower(progress_object)
	CASE "patient"
		top_20_specific = "PRGPT|" + progress_type
		top_20_generic = "PRGPT"
	CASE "encounter"
		top_20_specific = "PRGEN|" + progress_type + "|" + encounter.encounter_type
		top_20_generic = "PRGEN"
	CASE "assessment"
		top_20_generic = "PRGAS|" + progress_type + "|" + assessment.assessment_type
		top_20_specific = top_20_generic + "|" + assessment.assessment_id
	CASE "treatment"
		top_20_generic = "PRGTR|" + progress_type + "|" + service.treatment.treatment_type
		top_20_specific = top_20_generic
		if not isnull(service.treatment.specialty_id) and trim(service.treatment.specialty_id) <> "" then top_20_specific += "|" + service.treatment.specialty_id
		if not isnull(service.treatment.drug_id) and trim(service.treatment.drug_id) <> "" then top_20_specific += "|" + service.treatment.drug_id
		if not isnull(service.treatment.procedure_id) and trim(service.treatment.procedure_id) <> "" then top_20_specific += "|" + service.treatment.procedure_id
END CHOOSE


if len(top_20_specific) > 64 then top_20_specific = left(top_20_specific, 64)


end subroutine

public function integer set_progress_type (string ps_progress_type);integer li_sts
string ls_progress_key_required_flag
string ls_progress_key_enumerated_flag

progress_type = ps_progress_type

state_attributes.attribute_count = 0
f_attribute_add_attribute(state_attributes, "progress_type", progress_type)
f_attribute_add_attribute(state_attributes, "context_object", lower(progress_object))


CHOOSE CASE lower(progress_object)
	CASE "patient"
	CASE "encounter"
		f_attribute_add_attribute(state_attributes, "encounter_id", string(encounter.encounter_id))
		
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
		f_attribute_add_attribute(state_attributes, "problem_id", string(assessment.problem_id))
		
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
		f_attribute_add_attribute(state_attributes, "treatment_id", string(service.treatment.treatment_id))
		
		SELECT progress_key_required_flag,
				progress_key_enumerated_flag
		INTO :ls_progress_key_required_flag,
				:ls_progress_key_enumerated_flag
		FROM c_Treatment_Type_Progress_Type
		WHERE treatment_type = :service.treatment.treatment_type
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
		log.log(this, "open", "invalid progress_object (" + progress_object + ")", 4)
		return -1
END CHOOSE

set_top_20_codes()

get_notes()

return 1



end function

public function integer initialize (u_component_service puo_service, string ps_progress_object);integer li_sts

service = puo_service
progress_object = ps_progress_object

service.get_attribute("progress_note_max_length", max_length)
if isnull(max_length) then max_length = 1000

new_attachment_service = service.get_attribute("attachment_service")
if isnull(new_attachment_service) then new_attachment_service = "EXTERNAL_SOURCE"

CHOOSE CASE lower(progress_object)
	CASE "patient"
		progress_pick_dw = "dw_patient_progress_type_pick"
		key_pick_dw = "dw_patient_progress_key_pick"
		progress_type_pick_code = "PATIENT"
		description = current_patient.name()
	CASE "encounter"
		if isnull(service.encounter_id) then
			log.log(this, "open", "Null encounter_id", 4)
			return -1
		end if
		li_sts = current_patient.encounters.encounter(encounter, service.encounter_id)
		if li_sts <= 0 then
			log.log(this, "open", "Error getting assessment object (" + string(service.problem_id) + ")", 4)
			return -1
		end if
		progress_pick_dw = "dw_encounter_progress_type_pick"
		key_pick_dw = "dw_encounter_progress_key_pick"
		progress_type_pick_code = encounter.encounter_type
		description = encounter.description
	CASE "assessment"
		if isnull(service.problem_id) then
			log.log(this, "open", "Null problem_id", 4)
			return -1
		end if
		li_sts = current_patient.assessments.assessment(assessment, service.problem_id)
		if li_sts <= 0 then
			log.log(this, "open", "Error getting assessment object (" + string(service.problem_id) + ")", 4)
			return -1
		end if
		progress_pick_dw = "dw_assessment_progress_type_pick"
		key_pick_dw = "dw_assessment_progress_key_pick"
		progress_type_pick_code = assessment.assessment_type
		description = assessment.assessment
	CASE "treatment"
		if isnull(service.treatment) then
			log.log(this, "open", "treatment progress must have treatment object", 4)
			return -1
		end if
		progress_pick_dw = "dw_treatment_progress_type_pick"
		key_pick_dw = "dw_treatment_progress_key_pick"
		progress_type_pick_code = service.treatment.treatment_type
		description = service.treatment.treatment_description
	CASE ELSE
		log.log(this, "open", "invalid progress_object (" + progress_object + ")", 4)
		return -1
END CHOOSE

return 1



end function

public function integer new_attachment ();integer li_sts

li_sts = service_list.do_service(service.cpr_id, service.encounter_id, new_attachment_service, state_attributes)
if li_sts < 0 then return -1

get_notes()

return 1
//str_popup popup
//str_popup_return popup_return
//string ls_progress
//long ll_risk_level
//string ls_progress_key
//long ll_row
//string ls_find
//str_attributes lstr_attributes
//string ls_msg
//integer li_sts
//
//
//if progress_key_enumerated then
//	popup.dataobject = key_pick_dw
//	popup.datacolumn = 3
//	popup.displaycolumn = 3
//	popup.argument_count = 2
//	popup.argument[1] = progress_type_pick_code
//	popup.argument[2] = progress_type
//	if not progress_key_required then
//		popup.add_blank_row = true
//		popup.blank_text = "<None>"
//	end if
//	popup.auto_singleton = true
//	openwithparm(w_pop_pick, popup)
//	popup_return = message.powerobjectparm
//	if popup_return.item_count <> 1 then return 0
//	
//	ls_progress_key = popup_return.items[1]
//else
//	popup.title = "Please select a title for this attachment"
//	popup.argument_count = 1
//	popup.argument[1] = "PRG|" + progress_type + "|" + progress_object + "|" + progress_type_pick_code
//	
//	openwithparm(w_pop_prompt_string, popup)
//	popup_return = message.powerobjectparm
//	if popup_return.item_count <> 1 then return 0
//	
//	ls_progress_key = popup_return.items[1]
//end if
//
//if trim(ls_progress_key) = "" then setnull(ls_progress_key)
//
//if isnull(ls_progress_key) and progress_key_required then
//	openwithparm(w_pop_message, "A title is required for this attachment")
//	return 0
//end if
//
//// Make sure this progress_key is unique
//ls_progress_key = new_progress_key(ls_progress_key)
//
//// Acquire the new attachment
//lstr_attributes = state_attributes
//
//lstr_attributes.attribute_count += 1
//lstr_attributes.attribute[lstr_attributes.attribute_count].attribute = "progress_type"
//lstr_attributes.attribute[lstr_attributes.attribute_count].value = progress_type
//
//lstr_attributes.attribute_count += 1
//lstr_attributes.attribute[lstr_attributes.attribute_count].attribute = "comment_title"
//lstr_attributes.attribute[lstr_attributes.attribute_count].value = ls_progress_key
//
//li_sts = service_list.do_service(current_patient.cpr_id, service.encounter_id, attachment_service, service.treatment, lstr_attributes)
//
//get_notes()
//
//return 1
//
end function

public function integer edit_progress_note (long pl_row);str_popup popup
str_popup_return popup_return
string ls_progress
long ll_risk_level
string ls_progress_type
string ls_progress_key
datetime ldt_progress_date_time

ldt_progress_date_time = object.progress_date_time[pl_row]
ls_progress_type = object.progress_type[pl_row]
ls_progress_key = object.progress_key[pl_row]

popup.data_row_count = 3
popup.items[1] = top_20_specific
popup.items[2] = top_20_generic
popup.items[3] = object.progress_all[pl_row]
popup.title = description

// Edit/Create the progress note
openwithparm(w_progress_note_edit, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 2 then return 0

if isnull(popup_return.items[1]) or trim(popup_return.items[1]) = "" then return 0

ls_progress = popup_return.items[1]
ll_risk_level = long(popup_return.items[2])

set_progress(ls_progress_type, ls_progress_key, ls_progress, ldt_progress_date_time, ll_risk_level)

get_notes()

return 1

end function

public function integer get_notes ();long ll_count
integer li_sts
long ll_row
long i
str_progress_list lstr_progress
u_user luo_user
string ls_progress_key
long ll_object_key
string ls_progress

setnull(ls_progress_key)

reset()


lstr_progress = f_get_progress(current_patient.cpr_id, progress_object, service.object_key, progress_type, ls_progress_key)

for i = 1 to lstr_progress.progress_count
	luo_user = user_list.find_user(lstr_progress.progress[i].user_id)
	if isnull(luo_user) then continue
	
	ll_row = insertrow(0)
	object.progress_date_time[ll_row] = lstr_progress.progress[i].progress_date_time
	object.progress_type[ll_row] = lstr_progress.progress[i].progress_type
	object.progress_key[ll_row] = lstr_progress.progress[i].progress_key_description
//	object.suffix[ll_row] = trim_progress_key(lstr_progress.progress[i].progress_key)
	object.risk_level[ll_row] = lstr_progress.progress[i].risk_level
	object.user_id[ll_row] = luo_user.user_id
	object.user_short_name[ll_row] = luo_user.user_short_name
	object.user_full_name[ll_row] = luo_user.user_full_name
	object.color[ll_row] = luo_user.color
	object.attachment_id[ll_row] = lstr_progress.progress[i].attachment_id
	object.attachment_description[ll_row] = current_patient.attachments.attachment_extension_description(lstr_progress.progress[i].attachment_id)
	object.actual_length[ll_row] = len(lstr_progress.progress[i].progress)
	ls_progress = left(lstr_progress.progress[i].progress, max_length)
	if len(lstr_progress.progress[i].progress) > max_length then ls_progress += " <More>"
	object.progress[ll_row] = ls_progress
	object.progress_all[ll_row] = lstr_progress.progress[i].progress
next

sort_notes()

return 1


end function

public function integer new_progress_note ();integer li_sts

li_sts = service_list.do_service(service.cpr_id, service.encounter_id, new_progress_note_service, state_attributes)
if li_sts < 0 then return -1

get_notes()

return 1
//str_popup popup
//str_popup_return popup_return
//string ls_progress
//long ll_risk_level
//string ls_progress_key
//long ll_row
//string ls_find
//string ls_suffix
//
//if progress_key_enumerated then
//	popup.dataobject = key_pick_dw
//	popup.datacolumn = 3
//	popup.displaycolumn = 3
//	popup.argument_count = 2
//	popup.argument[1] = progress_type_pick_code
//	popup.argument[2] = progress_type
//	if not progress_key_required then
//		popup.add_blank_row = true
//		popup.blank_text = "<None>"
//	end if
//	popup.auto_singleton = true
//	openwithparm(w_pop_pick, popup)
//	popup_return = message.powerobjectparm
//	if popup_return.item_count <> 1 then return 0
//	
//	ls_progress_key = popup_return.items[1]
//else
//	popup.title = "Please select a title for this new progress note"
//	popup.argument_count = 1
//	popup.argument[1] = "PRG|" + progress_type + "|" + progress_object + "|" + progress_type_pick_code
//	
//	openwithparm(w_pop_prompt_string, popup)
//	popup_return = message.powerobjectparm
//	if popup_return.item_count <> 1 then return 0
//	
//	ls_progress_key = popup_return.items[1]
//end if
//
//if trim(ls_progress_key) = "" then setnull(ls_progress_key)
//
//if isnull(ls_progress_key) and progress_key_required then
//	openwithparm(w_pop_message, "A title is required for this progress note")
//	return 0
//end if
//
//if isnull(ls_progress_key) then
//	ls_suffix = ""
//else
//	ls_suffix = ls_progress_key
//end if
//
//// Make sure this progress_key is unique
//ls_progress_key = new_progress_key(ls_progress_key)
//
//// Prepare the popup structure for the progress note edit screen
//popup.data_row_count = 3
//popup.items[1] = top_20_specific + "|" + ls_suffix
//popup.items[2] = top_20_generic + "|" + ls_suffix
//popup.items[3] = ""
//popup.title = description
//
//// Edit/Create the progress note
//openwithparm(w_progress_note_edit, popup)
//popup_return = message.powerobjectparm
//if popup_return.item_count <> 2 then return 0
//
//if isnull(popup_return.items[1]) or trim(popup_return.items[1]) = "" then return 0
//
//ls_progress = popup_return.items[1]
//ll_risk_level = long(popup_return.items[2])
//
//set_progress(ls_progress_key, ls_progress, ll_risk_level)
//
//get_notes()
//
//return 1
//
end function

public function integer set_progress (string ps_progress_type, string ps_progress_key, string ps_progress, datetime pdt_progress_date_time, long pl_risk_level);integer li_sts
string ls_severity
long ll_attachment_id
integer li_diagnosis_sequence
u_attachment_list luo_attachment_list

setnull(ls_severity)
setnull(ll_attachment_id)
setnull(li_diagnosis_sequence)
setnull(luo_attachment_list)




CHOOSE CASE lower(progress_object)
	CASE "patient"
		li_sts = current_patient.set_progress(ps_progress_type, ps_progress_key, pdt_progress_date_time, ps_progress, pl_risk_level)
	CASE "encounter"
		li_sts = current_patient.encounters.set_encounter_progress(encounter.encounter_id, &
																						ps_progress_type, &
																						ps_progress_key, &
																						ps_progress, &
																						pl_risk_level, &
																						pdt_progress_date_time, &
																						luo_attachment_list)
	CASE "assessment"
		li_sts = current_patient.assessments.set_progress(assessment.problem_id, &
																			pdt_progress_date_time, &
																			li_diagnosis_sequence, &
																			ps_progress_type, &
																			ps_progress_key, &
																			ps_progress, &
																			ls_severity, &
																			ll_attachment_id, &
																			pl_risk_level)
	CASE "treatment"
		li_sts = current_patient.treatments.set_treatment_progress(service.treatment.treatment_id, &
																					ps_progress_type, &
																					ps_progress_key, &
																					ps_progress, &
																					pdt_progress_date_time, &
																					pl_risk_level)
END CHOOSE
		
return li_sts

end function

public function string trim_progress_key_old (string ps_progress_key);// This method trims the numeric extension added to a progress key to make it unique.
long ll_pos
string ls_find
integer i
string ls_trimmed_key


for i = 1 to 10
	ls_find = " (" + string(i) + ")"
	ll_pos = pos(ps_progress_key, ls_find)
	if ll_pos > 0 then
		ls_trimmed_key = left(ps_progress_key, ll_pos - 1)
		return ls_trimmed_key
	end if
next

return ps_progress_key



end function

public function string new_progress_key_old (string ps_progress_key);long ll_row
string ls_find
long i
string ls_suffix

i = 1
ls_suffix = ""

DO WHILE true
	if i > 1 then ls_suffix = " (" + string(i) + ")"
	
	ls_find = "progress_key='" + ps_progress_key + ls_suffix + "'"
	ll_row = find(ls_find, 1, rowcount())
	if ll_row <= 0 then exit
	i += 1
LOOP

return ps_progress_key + ls_suffix

end function

on u_dw_progress_display.create
end on

on u_dw_progress_display.destroy
end on

event selected(long selected_row);call super::selected;note_menu(selected_row)
clear_selected()

end event

