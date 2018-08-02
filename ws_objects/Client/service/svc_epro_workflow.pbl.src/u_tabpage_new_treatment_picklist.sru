$PBExportHeader$u_tabpage_new_treatment_picklist.sru
forward
global type u_tabpage_new_treatment_picklist from u_tabpage
end type
type cb_copy_from from commandbutton within u_tabpage_new_treatment_picklist
end type
type st_updating_contraindications from statictext within u_tabpage_new_treatment_picklist
end type
type cb_sort_list from commandbutton within u_tabpage_new_treatment_picklist
end type
type pb_help from u_pb_help_button within u_tabpage_new_treatment_picklist
end type
type st_group_title from statictext within u_tabpage_new_treatment_picklist
end type
type cb_group_clear_all from commandbutton within u_tabpage_new_treatment_picklist
end type
type cb_group_select_all from commandbutton within u_tabpage_new_treatment_picklist
end type
type dw_treatments from u_dw_pick_list within u_tabpage_new_treatment_picklist
end type
type cb_new_past from commandbutton within u_tabpage_new_treatment_picklist
end type
type cb_new_treatment from commandbutton within u_tabpage_new_treatment_picklist
end type
type cb_new_group from commandbutton within u_tabpage_new_treatment_picklist
end type
type st_treatment_mode_title from statictext within u_tabpage_new_treatment_picklist
end type
type pb_down from u_picture_button within u_tabpage_new_treatment_picklist
end type
type pb_up from u_picture_button within u_tabpage_new_treatment_picklist
end type
type st_page from statictext within u_tabpage_new_treatment_picklist
end type
end forward

global type u_tabpage_new_treatment_picklist from u_tabpage
integer width = 2834
integer height = 1488
cb_copy_from cb_copy_from
st_updating_contraindications st_updating_contraindications
cb_sort_list cb_sort_list
pb_help pb_help
st_group_title st_group_title
cb_group_clear_all cb_group_clear_all
cb_group_select_all cb_group_select_all
dw_treatments dw_treatments
cb_new_past cb_new_past
cb_new_treatment cb_new_treatment
cb_new_group cb_new_group
st_treatment_mode_title st_treatment_mode_title
pb_down pb_down
pb_up pb_up
st_page st_page
end type
global u_tabpage_new_treatment_picklist u_tabpage_new_treatment_picklist

type variables
string list_assessment_id
string list_user_id

boolean personal_list
boolean allow_editing

str_assessment_description assessment
long care_plan_id

//long treatment_count
str_contraindications treatment_contraindication[]

string base_filter = "(isnull( parent_definition_id ) or selected_flag=1)"

string mode = "NEW"

long selected_group_row

string single_treatment_list_id
string composite_treatment_list_id

date 			assessment_begin_date
date			assessment_end_date

integer new_treatment_count
str_assessment_treatment_definition new_treatments[]

long max_sort_sequence
long max_group_sort_sequence

string efficacy_display_service

u_tab_new_treatment treatment_master



end variables

forward prototypes
public function integer initialize ()
public function integer add_contraindications ()
public function integer display_treatments ()
public function long set_personal_list ()
public function long set_common_list ()
public function integer edit_treatment_def (long pl_row)
public function integer new_group ()
public subroutine set_group_row (long pl_group_row)
public function long next_sort_sequence ()
public function long next_group_sort_sequence ()
public subroutine group_menu (long pl_row)
public function integer new_treatment_item (boolean pb_auto_select_group)
public function long find_treatment_row (long pl_definition_id)
public function long get_treatment_definition_index (long pl_row)
public function integer order_treatment (long pl_row)
public function integer order_selected_treatments ()
public subroutine clear_group_row ()
public function long set_default_list ()
public function integer add_contraindications (long pl_row)
end prototypes

public function integer initialize ();long ll_count
integer li_sts
integer li_diagnosis_sequence
string ls_null

setnull(ls_null)
setnull(li_diagnosis_sequence)

treatment_master = parent_tab

// Get the assessment_id
list_assessment_id = parent_tab.service.get_attribute("assessment_id")
if isnull(list_assessment_id) then
	// If a specific assessment_id isn't requested then use the current context to determine the assessment_id
	if isnull(parent_tab.service.problem_id) then
		log.log(this, "u_tabpage_new_treatment_picklist.initialize.0016", "No assessment_id available", 4)
		return -1
	else
		li_sts = current_patient.assessments.assessment(assessment, parent_tab.service.problem_id, li_diagnosis_sequence)
		if li_sts <= 0 then return -1
		list_assessment_id = assessment.assessment_id
	end if
end if

single_treatment_list_id = parent_tab.service.get_attribute("single_treatment_list_id")
if isnull(single_treatment_list_id) then single_treatment_list_id = "SINGLE"

composite_treatment_list_id = parent_tab.service.get_attribute("composite_treatment_list_id")
if isnull(composite_treatment_list_id) then composite_treatment_list_id = "!COMPOSITE"

parent_tab.service.get_attribute("assessment_begin_date", assessment_begin_date)
if isnull(assessment_begin_date) then assessment_begin_date = date(assessment.begin_date)

parent_tab.service.get_attribute("assessment_end_date", assessment_end_date)
if isnull(assessment_end_date) then assessment_end_date = date(assessment.end_date)

efficacy_display_service = parent_tab.service.get_attribute("efficacy_display_service")
if isnull(efficacy_display_service) then efficacy_display_service = "Efficacy Display"



parent_tab.service.get_attribute("mode", mode)
if isnull(mode) then
	if isnull(current_patient.open_encounter) then
		mode = "PAST"
	else
		if upper(current_patient.open_encounter.encounter_status) = "CLOSED" &
		  Or Not isnull(assessment.end_date) then
			mode = "PAST"
		else
			mode = "NEW"
		end if
	end if
end if

care_plan_id = 0

this.event trigger resize_tabpage()

CHOOSE CASE lower(tag)
	CASE "personal"
		ll_count = set_personal_list()
		if ll_count < 0 then return -1
	CASE "common"
		ll_count = set_common_list()
		if ll_count < 0 then return -1
	CASE "default"
		ll_count = set_default_list()
		if ll_count < 0 then return -1
END CHOOSE

if mode = "PAST" then
	cb_new_past.text = "Record Past"
else
	mode = "NEW"
	cb_new_past.text = "Order New"
end if

personal_list = false
allow_editing = false
if list_user_id = current_user.user_id then
	personal_list = true
	allow_editing = true
elseif current_user.check_privilege("Common Treatment Lists") then
	allow_editing = true
else
	allow_editing = false
	cb_copy_from.visible = false
	cb_new_group.visible = false
end if

if ll_count = 0 then return 0

return 1


end function

public function integer add_contraindications ();u_xml_document luo_xml_document
integer li_sts
str_complete_context lstr_from_context
str_complete_context lstr_document_context
string ls_payload_type
str_contraindications lstr_contraindications
long i
string ls_find
long ll_treatment_count
long ll_row
long ll_index
str_attributes lstr_attributes
str_external_observation_attachment lstr_attachment
string ls_null

setnull(ls_null)

st_updating_contraindications.visible = true

lstr_contraindications = f_get_contraindications(current_patient.cpr_id, &
															ls_null, &
															ls_null, &
															ls_null, &
															list_user_id, &
															list_assessment_id, &
															care_plan_id, &
															lstr_attributes)

dw_treatments.setredraw(false)
dw_treatments.setfilter("")
dw_treatments.filter()

ll_treatment_count = dw_treatments.rowcount()

for i = 1 to lstr_contraindications.contraindication_count
	ls_find = "definition_id=" + string(lstr_contraindications.contraindication[i].treatmentdefinitionid)
	ll_row = dw_treatments.find(ls_find, 1, ll_treatment_count)
	if ll_row > 0 then
		ll_index = dw_treatments.object.contraindication_index[ll_row]
		treatment_contraindication[ll_index].contraindication_count += 1
		
		// Add the contraindication
		treatment_contraindication[ll_index].contraindication[treatment_contraindication[ll_index].contraindication_count] = lstr_contraindications.contraindication[i]
		CHOOSE CASE treatment_contraindication[ll_index].contraindication_count
			CASE 1
				dw_treatments.object.contraindication_icon_1[ll_row] = lstr_contraindications.contraindication[i].icon
			CASE 2
				dw_treatments.object.contraindication_icon_2[ll_row] = lstr_contraindications.contraindication[i].icon
			CASE 3
				dw_treatments.object.contraindication_icon_3[ll_row] = lstr_contraindications.contraindication[i].icon
			CASE 4
				dw_treatments.object.contraindication_icon_4[ll_row] = lstr_contraindications.contraindication[i].icon
			CASE 5
				dw_treatments.object.contraindication_icon_5[ll_row] = lstr_contraindications.contraindication[i].icon
		END CHOOSE
	end if
next

dw_treatments.setfilter(base_filter)
dw_treatments.filter()
dw_treatments.setredraw(true)

st_updating_contraindications.visible = false
return 0


end function

public function integer display_treatments ();long ll_count
long i
long ll_index
integer li_sts
dw_treatments.setredraw(false)

dw_treatments.settransobject(sqlca)
dw_treatments.setfilter("")

ll_count = dw_treatments.retrieve(current_patient.cpr_id, list_assessment_id, list_user_id, care_plan_id)
if ll_count < 0 then return -1

// Initialize empty contraindication holders
for i = 1 to ll_count
	ll_index = dw_treatments.object.contraindication_index[i]
	treatment_contraindication[ll_index].treatment_type = dw_treatments.object.treatment_type[i]
	treatment_contraindication[ll_index].treatment_key = dw_treatments.object.treatment_key[i]
	treatment_contraindication[ll_index].treatment_description = dw_treatments.object.treatment_description[i]
	treatment_contraindication[ll_index].assessment_id = list_assessment_id
	treatment_contraindication[ll_index].user_id = list_user_id
	treatment_contraindication[ll_index].cpr_id = current_patient.cpr_id
	treatment_contraindication[ll_index].contraindication_count = 0
next

//if ll_count > 0 then
//	// Call the contraindications system
//	li_sts = add_contraindications()
//end if

dw_treatments.setfilter(base_filter)
dw_treatments.filter()
ll_count = dw_treatments.rowcount()

if ll_count > 0 then
	max_sort_sequence = dw_treatments.object.treatment_sort_sequence[ll_count]
else
	max_sort_sequence = 0
end if

	
dw_treatments.setredraw(true)

dw_treatments.set_page(1, pb_up, pb_down, st_page)

clear_group_row()

if ll_count > 0 then
	// Call the contraindications system
	li_sts = add_contraindications()
end if

return ll_count

end function

public function long set_personal_list ();long ll_count

list_assessment_id = assessment.assessment_id
list_user_id = current_user.user_id

ll_count = display_treatments()

return ll_count


end function

public function long set_common_list ();long ll_count

list_assessment_id = assessment.assessment_id
list_user_id = current_user.common_list_id()

ll_count = display_treatments()

return ll_count


end function

public function integer edit_treatment_def (long pl_row);long ll_count
string lsa_attributes[]
string lsa_values[]
str_popup_return popup_return
integer li_idx
string ls_treatment_mode
string ls_treatment_type
string ls_followup_flag
w_window_base lw_window
long ll_index
long ll_definition_id
integer li_sts
long ll_sort_parent_sort_sequence
long ll_sort_parent_definition_id
long ll_parent_row
long ll_original_parent_definition_id

ll_definition_id = dw_treatments.object.definition_id[pl_row]

ll_index = get_treatment_definition_index(pl_row)
if ll_index <= 0 then return -1

ls_followup_flag = datalist.treatment_type_followup_flag(new_treatments[ll_index].treatment_type)

if isnull(new_treatments[ll_index].definition_id) and not isnull(ls_followup_flag) and upper(ls_followup_flag) <> "N" then
	f_save_assessment_treatment_def(new_treatments[ll_index])
end if

// Save the original parent_definition_id so we know if it changed
ll_original_parent_definition_id = new_treatments[ll_index].parent_definition_id

openwithparm(lw_window, new_treatments[ll_index], "w_assessment_treatment_edit")
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

new_treatments[ll_index] = popup_return.returnobject

if popup_return.items[1] = "DELETE" then
	DELETE u_Assessment_Treat_Definition
	WHERE definition_id = :ll_definition_id;
	if not tf_check() then return -1
	dw_treatments.deleterow(pl_row)
elseif popup_return.items[1] = "OK" then
	// If the user requested to update the treatment list, do it now
	if new_treatments[ll_index].update_flag = 1 or not isnull(new_treatments[ll_index].definition_id) then
		li_sts = f_save_assessment_treatment_def(new_treatments[ll_index])
		if li_sts <= 0 then return -1
	end if
		
	dw_treatments.object.definition_id[pl_row] = new_treatments[ll_index].definition_id
	dw_treatments.object.parent_definition_id[pl_row] = new_treatments[ll_index].parent_definition_id
	
	// If the parent changed then reset the sort columns
	setnull(ll_sort_parent_sort_sequence)
	setnull(ll_sort_parent_definition_id)
	if isnull(new_treatments[ll_index].parent_definition_id) and not isnull(ll_original_parent_definition_id) then
		// Item was in a group but now isn't
		ll_sort_parent_sort_sequence = new_treatments[ll_index].sort_sequence
		ll_sort_parent_definition_id = new_treatments[ll_index].definition_id
	elseif not isnull(new_treatments[ll_index].parent_definition_id) and isnull(ll_original_parent_definition_id) then
		// Item was not in a group but now is
		ll_parent_row = find_treatment_row(new_treatments[ll_index].parent_definition_id)
		if ll_parent_row > 0 then
			ll_sort_parent_sort_sequence = dw_treatments.object.treatment_sort_sequence[ll_parent_row]
			ll_sort_parent_definition_id = new_treatments[ll_index].parent_definition_id
		end if
	elseif new_treatments[ll_index].parent_definition_id <> ll_original_parent_definition_id then
		// Item was in a group but is now in a different group
		ll_parent_row = find_treatment_row(new_treatments[ll_index].parent_definition_id)
		if ll_parent_row > 0 then
			ll_sort_parent_sort_sequence = dw_treatments.object.treatment_sort_sequence[ll_parent_row]
			ll_sort_parent_definition_id = new_treatments[ll_index].parent_definition_id
		end if
	end if
	if not isnull(ll_sort_parent_sort_sequence) then
		dw_treatments.object.sort_parent_sort_sequence[pl_row]= ll_sort_parent_sort_sequence
		dw_treatments.object.sort_parent_definition_id[pl_row]= ll_sort_parent_definition_id
	end if

	// Update the description
	if len(new_treatments[ll_index].treatment_description) > 255 then
		dw_treatments.object.treatment_description[pl_row] = left(new_treatments[ll_index].treatment_description, 252) + "..."
	else
		dw_treatments.object.treatment_description[pl_row] = new_treatments[ll_index].treatment_description
	end if
	
	dw_treatments.setredraw(false)
	dw_treatments.sort()
	dw_treatments.filter()
	dw_treatments.setredraw(true)
end if

return 1

end function

public function integer new_group ();str_assessment_treatment_definition lstr_group
long ll_null
string ls_null
string ls_description
str_popup popup
str_popup_return popup_return
integer li_sts
string ls_treatment_type
long ll_row
string ls_find

setnull(ll_null)
setnull(ls_null)

ls_treatment_type = "!COMPOSITE"

ls_description = f_popup_prompt_string_init("Enter name for new group", "", "TreatmentListGroupName")
if isnull(ls_description) or trim(ls_description) = "" then return 0

// See if group already exists for this treatment list
ls_find = "treatment_description='" + ls_description + "'"
ls_find += " and isnull(parent_definition_id)"
ls_find += " and treatment_type='" + ls_treatment_type + "'"
ll_row = dw_treatments.find(ls_find, 1, dw_treatments.rowcount())
if ll_row > 0 then
	openwithparm(w_pop_message, "That group name already exists for this treatment list")
	return 0
end if


lstr_group.definition_id = ll_null
lstr_group.assessment_id = list_assessment_id
lstr_group.treatment_type = ls_treatment_type
lstr_group.treatment_description = ls_description
lstr_group.workplan_id = ll_null
lstr_group.followup_workplan_id = ll_null
lstr_group.user_id = list_user_id
lstr_group.sort_sequence = next_sort_sequence()
lstr_group.instructions = ls_null
lstr_group.parent_definition_id = ll_null
lstr_group.child_flag = ls_null
lstr_group.update_flag = ll_null
lstr_group.common_list = not personal_list

li_sts = f_save_assessment_treatment_def(lstr_group)
if li_sts <= 0 then return li_sts


// Insert the row in the datawindow
ll_row = dw_treatments.insertrow(0)
dw_treatments.object.definition_id[ll_row]            = lstr_group.definition_id
dw_treatments.object.treatment_type[ll_row]				= ls_treatment_type
dw_treatments.object.treatment_description[ll_row] 	= ls_description
dw_treatments.object.sort_parent_sort_sequence[ll_row]= lstr_group.sort_sequence
dw_treatments.object.sort_parent_definition_id[ll_row]= lstr_group.definition_id
dw_treatments.object.selected_flag[ll_row]            = 1
dw_treatments.object.icon[ll_row]                     = datalist.treatment_type_icon(ls_treatment_type)
dw_treatments.object.treatment_type_sort_sequence[ll_row] = datalist.treatment_type_sort_sequence(ls_treatment_type)

dw_treatments.Scrolltorow(ll_row)

set_group_row(ll_row)

Return 1

end function

public subroutine set_group_row (long pl_group_row);string ls_find
long ll_row
long ll_count
string ls_filter
long ll_definition_id

selected_group_row = pl_group_row
st_group_title.visible = true
cb_group_clear_all.visible = true
cb_group_select_all.visible = true

ll_definition_id = dw_treatments.object.definition_id[pl_group_row]

// Turn off any other composites
ll_count = dw_treatments.rowcount()
ls_find = "treatment_type='!COMPOSITE' and selected_flag=1"
ll_row = dw_treatments.find(ls_find, 1, ll_count)
DO WHILE ll_row > 0 and ll_row <= ll_count
	if ll_row <> pl_group_row then dw_treatments.object.selected_flag[ll_row] = 0

	ll_row = dw_treatments.find(ls_find, ll_row + 1, ll_count + 1)
LOOP



ls_filter = base_filter
ls_filter += " or parent_definition_id=" + string(ll_definition_id)

dw_treatments.setfilter(ls_filter)
dw_treatments.filter()
dw_treatments.recalc_page(pb_up, pb_down, st_page)

		
// Now find the max sort sequence in the group
ll_count = dw_treatments.rowcount()
ls_find = "parent_definition_id=" + string(ll_definition_id)
ll_row = dw_treatments.find(ls_find, ll_count, 1)
if ll_row > 0 then
	max_group_sort_sequence = dw_treatments.object.treatment_sort_sequence[ll_row]
else
	max_group_sort_sequence = 1
end if


end subroutine

public function long next_sort_sequence ();
max_sort_sequence += 1

return max_sort_sequence

end function

public function long next_group_sort_sequence ();
max_group_sort_sequence += 1

return max_group_sort_sequence

end function

public subroutine group_menu (long pl_row);w_pop_buttons lw_pop_buttons
string buttons[]
integer button_pressed
long ll_definition_id
str_popup popup
str_popup_return popup_return
string ls_new_name
string ls_treatment_description
string ls_message
string ls_find
long ll_row
boolean lb_something_selected
boolean lb_something_not_selected
long ll_rowcount

ll_rowcount = dw_treatments.rowcount()
ll_definition_id = dw_treatments.object.definition_id[pl_row]
ls_treatment_description = dw_treatments.object.treatment_description[pl_row]

ls_find = "parent_definition_id=" + string(ll_definition_id)
ls_find += " and selected_flag=1"
ll_row = dw_treatments.find(ls_find, 1, ll_rowcount)
if ll_row > 0 then
	lb_something_selected = true
else
	lb_something_selected = false
end if

ls_find = "parent_definition_id=" + string(ll_definition_id)
ls_find += " and selected_flag=0"
ll_row = dw_treatments.find(ls_find, 1, ll_rowcount)
if ll_row > 0 then
	lb_something_not_selected = true
else
	lb_something_not_selected = false
end if

if lb_something_not_selected then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_select_all.bmp"
	popup.button_helps[popup.button_count] = "Select all treatments in this group"
	popup.button_titles[popup.button_count] = "Select All"
	buttons[popup.button_count] = "SELECTALL"
end if

if lb_something_selected then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_select_none.bmp"
	popup.button_helps[popup.button_count] = "Unselect all treatments in this group"
	popup.button_titles[popup.button_count] = "Select None"
	buttons[popup.button_count] = "SELECTNONE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_treatment_note.bmp"
	popup.button_helps[popup.button_count] = "New Treatment(s) in Group"
	popup.button_titles[popup.button_count] = "New Treatment"
	buttons[popup.button_count] = "TREATMENT"
End If

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_edit.bmp"
	popup.button_helps[popup.button_count] = "Rename Group"
	popup.button_titles[popup.button_count] = "Rename Group"
	buttons[popup.button_count] = "RENAME"
End If

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Delete Group"
	popup.button_titles[popup.button_count] = "Delete Group"
	buttons[popup.button_count] = "DELETE"
End If

If True Then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	buttons[popup.button_count] = "CANCEL"
End If

popup.button_titles_used = True

If popup.button_count > 1 Then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	button_pressed = message.doubleparm
	If button_pressed < 1 Or button_pressed > popup.button_count Then Return
ElseIf popup.button_count = 1 Then
	button_pressed = 1
Else
	Return
End If

CHOOSE CASE buttons[button_pressed]
	CASE "SELECTALL"
		ls_find = "parent_definition_id=" + string(ll_definition_id)
		ls_find += " and selected_flag=0"
		ll_row = dw_treatments.find(ls_find, 1, ll_rowcount)
		DO WHILE ll_row > 0 AND ll_row <= ll_rowcount
			dw_treatments.object.selected_flag[ll_row] = 1
			ll_row = dw_treatments.find(ls_find, ll_row + 1, ll_rowcount + 1)
		LOOP
	CASE "SELECTNONE"
		ls_find = "parent_definition_id=" + string(ll_definition_id)
		ls_find += " and selected_flag=1"
		ll_row = dw_treatments.find(ls_find, 1, ll_rowcount)
		DO WHILE ll_row > 0 AND ll_row <= ll_rowcount
			dw_treatments.object.selected_flag[ll_row] = 0
			ll_row = dw_treatments.find(ls_find, ll_row + 1, ll_rowcount + 1)
		LOOP
	CASE "TREATMENT"
		new_treatment_item(true)
	CASE "RENAME"
		ls_new_name = f_popup_prompt_string_init("Enter new name for group", ls_treatment_description, "TreatmentListGroupName")
		ls_new_name = left(ls_new_name, 255)
		if len(ls_new_name) > 0 then
			UPDATE u_Assessment_Treat_Definition
			SET treatment_description = :ls_new_name
			WHERE definition_id = :ll_definition_id;
			if not tf_check() then return
			
			dw_treatments.object.treatment_description[pl_row] = ls_new_name
		end if
	CASE "DELETE"
		// See if there are any treatments in the group
		ls_find = "parent_definition_id=" + string(ll_definition_id)
		ll_row = dw_treatments.find(ls_find, 1, dw_treatments.rowcount())
		if ll_row > 0 then
			ls_message = "Deleting this group will also delete the treatments in the group.  "
		else
			ls_message = ""
		end if
		
		ls_message += "A you sure you want to delete the group ~"" + ls_treatment_description + "~""
		
		if f_popup_yes_no(ls_message) then
			DELETE u_Assessment_Treat_Definition
			WHERE parent_definition_id = :ll_definition_id;
			if not tf_check() then return
			
			DELETE u_Assessment_Treat_Definition
			WHERE definition_id = :ll_definition_id;
			if not tf_check() then return
			dw_treatments.deleterow(pl_row)
		end if
	CASE "CANCEL"
		Return
	CASE ELSE
END CHOOSE

Return
end subroutine

public function integer new_treatment_item (boolean pb_auto_select_group);string ls_treatment_type
string ls_description
long ll_rowcount
long ll_row
integer li_sts
datetime ldt_begin_date
datetime ldt_end_date
string ls_treatment_description
long ll_open_encounter_id
long ll_attribute_count
long i, j
long ll_null
long ll_sort_parent_sort_sequence
long ll_sort_parent_definition_id
long ll_parent_definition_id
string ls_parent_description
long ll_insertrow_at
long ll_treatment_sort_sequence
// User defined types
u_component_treatment	luo_treatment
str_assessment_treatment_definition lstr_new_treatment
long ll_index
string ls_treatment_key_property

Setnull(ll_null)

ll_rowcount = dw_treatments.rowcount()

ll_insertrow_at = 0
ll_sort_parent_sort_sequence = ll_null
ll_sort_parent_definition_id = ll_null
ll_parent_definition_id = ll_null

if selected_group_row > 0 then
	if pb_auto_select_group then
		ll_parent_definition_id = dw_treatments.object.definition_id[selected_group_row]
	else
		ls_parent_description = dw_treatments.object.treatment_description[selected_group_row]
		if f_popup_yes_no("Do you want to add the new treatment(s) to the selected group ~"" + ls_parent_description + "~"?") then
			ll_parent_definition_id = dw_treatments.object.definition_id[selected_group_row]
		end if
	end if
	
	if ll_parent_definition_id > 0 then
		ll_sort_parent_definition_id = ll_parent_definition_id
		ll_sort_parent_sort_sequence = dw_treatments.object.treatment_sort_sequence[selected_group_row]
		
		ll_insertrow_at = dw_treatments.find("parent_definition_id<>" + string(ll_parent_definition_id), selected_group_row + 1, ll_rowcount)
		if ll_insertrow_at = 0 and selected_group_row < ll_rowcount then ll_insertrow_at = selected_group_row + 1
	else
		setnull(ll_parent_definition_id)
	end if
else
	setnull(ll_parent_definition_id)
end if


ls_treatment_type = f_get_treatments_list(single_treatment_list_id)

if mode = "PAST" then
	ls_treatment_description = datalist.treatment_type_description(ls_treatment_type)
	ldt_begin_date = datetime(assessment_begin_date, time(""))
	ldt_end_date = datetime(assessment_end_date, time(""))
	ll_open_encounter_id = current_patient.open_encounter_id
	
	li_sts = f_get_treatment_dates(ls_treatment_type, ls_treatment_description, ll_open_encounter_id, ldt_begin_date, ldt_end_date)
else
	setnull(ll_open_encounter_id)
	setnull(ldt_begin_date)
	setnull(ldt_end_date)
end if

If Not Isnull(ls_treatment_type) Then
	luo_treatment = f_get_treatment_component(ls_treatment_type)
	If Not Isnull(luo_treatment) Then 
		luo_treatment.define_treatment(assessment)
		
		for i = 1 to luo_treatment.treatment_count
			ls_description = luo_treatment.treatment_definition[i].item_description
			if len(ls_description) > 255 then ls_description = left(ls_description, 252) + "..."

			if isnull(ll_parent_definition_id) then
				ll_treatment_sort_sequence = next_sort_sequence()
			else
				ll_treatment_sort_sequence = next_group_sort_sequence()
			end if

			// Create the treatment definition structure
			lstr_new_treatment = f_empty_assessment_treatment_definition()
			lstr_new_treatment.assessment_id = list_assessment_id
			lstr_new_treatment.problem_id = assessment.problem_id
			lstr_new_treatment.treatment_type = luo_treatment.treatment_definition[i].treatment_type
			lstr_new_treatment.treatment_description = luo_treatment.treatment_definition[i].item_description
			lstr_new_treatment.user_id = list_user_id
			lstr_new_treatment.sort_sequence = ll_treatment_sort_sequence
			lstr_new_treatment.parent_definition_id = ll_parent_definition_id
			lstr_new_treatment.update_flag = 0
			lstr_new_treatment.common_list = not personal_list
			lstr_new_treatment.open_encounter_id = ll_open_encounter_id
			lstr_new_treatment.begin_date = ldt_begin_date
			lstr_new_treatment.end_date = ldt_end_date
			lstr_new_treatment.attributes = f_attribute_arrays_to_str(luo_treatment.treatment_definition[i].attribute_count, &
																												luo_treatment.treatment_definition[i].attribute, &
																												luo_treatment.treatment_definition[i].value)
			// Get the treatment mode that may have been passed in through the attributes
			lstr_new_treatment.treatment_mode = f_attribute_find_attribute(lstr_new_treatment.attributes, "treatment_mode")

			// Create the row in the datawindow			
			ll_row = dw_treatments.Insertrow(ll_insertrow_at)

			
			// If we're in a group then go ahead and save automatically
			if ll_parent_definition_id > 0 then
				li_sts = f_save_assessment_treatment_def(lstr_new_treatment)
			end if

			// Add to the list of new treatments
			new_treatment_count += 1
			new_treatments[new_treatment_count] = lstr_new_treatment
			
			// store the new structure index
			dw_treatments.object.new_treatment_index[ll_row]      = new_treatment_count // index of new treatment definition structure
			
			
			// Set the date fields in the datawindow
			dw_treatments.object.definition_id[ll_row]            = lstr_new_treatment.definition_id
			dw_treatments.object.treatment_type[ll_row]				= lstr_new_treatment.treatment_type
			dw_treatments.object.treatment_description[ll_row] 	= ls_description
			dw_treatments.object.treatment_mode[ll_row] 				= lstr_new_treatment.treatment_mode
			dw_treatments.object.parent_definition_id[ll_row]     = lstr_new_treatment.parent_definition_id
			dw_treatments.object.sort_parent_sort_sequence[ll_row]= ll_sort_parent_sort_sequence
			dw_treatments.object.sort_parent_definition_id[ll_row]= ll_sort_parent_definition_id
			dw_treatments.object.selected_flag[ll_row]            = 1
			dw_treatments.object.icon[ll_row]                     = datalist.treatment_type_icon(ls_treatment_type)
			dw_treatments.object.treatment_type_sort_sequence[ll_row]= datalist.treatment_type_sort_sequence(ls_treatment_type)
			dw_treatments.object.treatment_sort_sequence[ll_row]	= ll_treatment_sort_sequence

			// Calculate and set the treatment_key
			ls_treatment_key_property = sqlca.fn_treatment_type_treatment_key(lstr_new_treatment.treatment_type)
			for j = 1 to lstr_new_treatment.attributes.attribute_count
				if lower(lstr_new_treatment.attributes.attribute[j].attribute) = lower(ls_treatment_key_property) then
					dw_treatments.object.treatment_key[ll_row] = left(lstr_new_treatment.attributes.attribute[j].value, 64)
				end if
			next

			// Initialize the contraindication structure
			ll_index = upperbound(treatment_contraindication) + 1
			dw_treatments.object.contraindication_index[ll_row]	= ll_index
			treatment_contraindication[ll_index].treatment_type = dw_treatments.object.treatment_type[ll_row]
			treatment_contraindication[ll_index].treatment_key = dw_treatments.object.treatment_key[ll_row]
			treatment_contraindication[ll_index].treatment_description = dw_treatments.object.treatment_description[ll_row]
			treatment_contraindication[ll_index].assessment_id = list_assessment_id
			treatment_contraindication[ll_index].user_id = list_user_id
			treatment_contraindication[ll_index].cpr_id = current_patient.cpr_id
			treatment_contraindication[ll_index].contraindication_count = 0

			// Add the contraindication visual cues
			add_contraindications(ll_row)

		next
	End If
End If

Return 1

end function

public function long find_treatment_row (long pl_definition_id);string ls_find
long ll_row

ls_find = "definition_id=" + string(pl_definition_id)
ll_row = dw_treatments.find(ls_find, 1, dw_treatments.rowcount())
if ll_row > 0 then
	return ll_row
else
	setnull(ll_row)
	return ll_row
end if

end function

public function long get_treatment_definition_index (long pl_row);long ll_index
long ll_definition_id
integer li_sts
str_assessment_treatment_definition lstr_treatment

ll_definition_id = dw_treatments.object.definition_id[pl_row]
ll_index = dw_treatments.object.new_treatment_index[pl_row]


if ll_index > 0 then
	return ll_index
else
	if ll_definition_id > 0 then
		li_sts = f_get_assessment_treatment_def(ll_definition_id, lstr_treatment)
		if li_sts <= 0 then return -1
		
		lstr_treatment.problem_id = assessment.problem_id
		
		new_treatment_count += 1
		new_treatments[new_treatment_count] = lstr_treatment
		dw_treatments.object.new_treatment_index[pl_row] = new_treatment_count
		return new_treatment_count
	else
		log.log(this, "u_tabpage_new_treatment_picklist.get_treatment_definition_index.0024", "Treatment with null definition_id must have new treatment structure", 4)
		return -1
	end if
end if


end function

public function integer order_treatment (long pl_row);long ll_index
u_ds_data luo_children
u_ds_data luo_child_attributes
long ll_treatment_id
long ll_child_count
long ll_child_definition_id
long ll_attrib_count
str_attributes lstr_attributes
string ls_treatment_type
string ls_treatment_description
string ls_warning
string lsa_warning[]
integer li_warning_count
long i
integer li_sts
long ll_contraindication_index
string ls_message
boolean 	lb_past_treatment
string ls_response
str_contraindications lstr_contraindications

if isnull(pl_row) or pl_row <= 0 then return 0

ll_contraindication_index = dw_treatments.object.contraindication_index[pl_row]
if ll_contraindication_index > 0 then
	lstr_contraindications = treatment_contraindication[ll_contraindication_index]
	if lstr_contraindications.contraindication_count > 0 then
		lstr_contraindications.show_choice = true
		openwithparm(w_contraindication_display, lstr_contraindications)
		ls_response = message.stringparm
		if ls_response = "CANCEL" then
			return 0
		end if
	end if
end if
//	for i = 1 to treatment_contraindication[ll_contraindication_index].contraindication_count
//		ls_warning = treatment_contraindication[ll_contraindication_index].contraindication[i].warning
//		if len(ls_warning) > 0 then
//			li_warning_count += 1
//			lsa_warning[li_warning_count] = ls_warning
//			ls_message = ls_warning + "~n~nAre you sure you wish to order "
//			ls_message += dw_treatments.object.treatment_description[pl_row]
//			ls_message += "?"
//			if not f_popup_yes_no(ls_message) then return 0
//		end if
//	next
//end if

if mode = "PAST" then
	lb_past_treatment = true
else
	lb_past_treatment = false
end if

ll_index = get_treatment_definition_index(pl_row)

ll_treatment_id = current_patient.treatments.order_treatment(new_treatments[ll_index], lb_past_treatment)
if ll_treatment_id <= 0 then return -1

// Add contraindication warnings
for i = 1 to li_warning_count
	current_patient.treatments.set_treatment_progress(ll_treatment_id, &
																	"Contraindication Warning", &
																	string(i), &
																	lsa_warning[i])
next

// Add the child treatment items
If new_treatments[ll_index].definition_id > 0 Then
	luo_children = CREATE u_ds_data
	luo_child_attributes = CREATE u_ds_data
	luo_children.set_dataobject("dw_child_treatment_defs")
	luo_child_attributes.set_dataobject("dw_u_assessment_treat_def_attrib")
	ll_child_count = luo_children.retrieve(new_treatments[ll_index].definition_id)
	for i = 1 to ll_child_count
		ll_child_definition_id = luo_children.object.definition_id[i]
		ll_attrib_count = luo_child_attributes.retrieve(ll_child_definition_id)
		lstr_attributes.attribute_count = 0
		f_attribute_ds_to_str(luo_child_attributes, lstr_attributes)
		ls_treatment_type = luo_children.object.treatment_type[i]
		ls_treatment_description = luo_children.object.treatment_description[i]
		li_sts = current_patient.treatments.add_followup_treatment_item(ll_treatment_id, &
																							ls_treatment_type, &
																							ls_treatment_description, &
																							lstr_attributes)
	next
	DESTROY luo_children
	DESTROY luo_child_attributes
End If

// See if there are any auto-perform services for the new treatment
current_patient.treatments.do_autoperform_services(ll_treatment_id)

// give queued up events a chance to complete now
yield()

return 1



end function

public function integer order_selected_treatments ();long ll_row
string ls_find
long ll_rowcount
integer li_sts

ll_rowcount = dw_treatments.rowcount()
ls_find = "selected_flag=1 and treatment_type <> '!COMPOSITE'"
ll_row = dw_treatments.find(ls_find, 1, ll_rowcount)
DO WHILE ll_row > 0 and ll_row <= ll_rowcount
	li_sts = order_treatment(ll_row)
	
	// Turn off selection after it's ordered
	dw_treatments.object.selected_flag[ll_row] = 0
	
	ll_row = dw_treatments.find(ls_find, ll_row + 1, ll_rowcount + 1)
LOOP

clear_group_row()



return 1


end function

public subroutine clear_group_row ();dw_treatments.setfilter(base_filter)
string ls_find
long ll_row
long ll_count

st_group_title.visible = false
cb_group_clear_all.visible = false
cb_group_select_all.visible = false
setnull(selected_group_row)

// Turn off all composites
ll_count = dw_treatments.rowcount()
ls_find = "treatment_type='!COMPOSITE' and selected_flag=1"
ll_row = dw_treatments.find(ls_find, 1, ll_count)
DO WHILE ll_row > 0 and ll_row <= ll_count
	dw_treatments.object.selected_flag[ll_row] = 0

	ll_row = dw_treatments.find(ls_find, ll_row + 1, ll_count + 1)
LOOP

dw_treatments.setfilter(base_filter)
dw_treatments.filter()
dw_treatments.recalc_page(pb_up, pb_down, st_page)

end subroutine

public function long set_default_list ();long ll_count

list_assessment_id = "!Default"
list_user_id = current_user.common_list_id()

ll_count = display_treatments()

return ll_count


end function

public function integer add_contraindications (long pl_row);boolean lb_found
u_xml_document luo_xml_document
integer li_sts
str_complete_context lstr_from_context
str_complete_context lstr_document_context
string ls_payload_type
str_contraindications lstr_contraindications
long i, j
long ll_index
str_attributes lstr_attributes
str_external_observation_attachment lstr_attachment
string ls_null
string ls_treatment_type
string ls_treatment_key
string ls_treatment_description

setnull(ls_null)

st_updating_contraindications.visible = true

ls_treatment_type = dw_treatments.object.treatment_type[pl_row]
ls_treatment_key =  dw_treatments.object.treatment_key[pl_row]
ls_treatment_description =  dw_treatments.object.treatment_description[pl_row]

lstr_contraindications = f_get_contraindications(current_patient.cpr_id, &
															ls_treatment_type, &
															ls_treatment_key, &
															ls_treatment_description, &
															list_user_id, &
															list_assessment_id, &
															care_plan_id, &
															lstr_attributes)

ll_index = dw_treatments.object.contraindication_index[pl_row]

for i = 1 to lstr_contraindications.contraindication_count
	// Make sure it's for this treatment
	if lower(lstr_contraindications.contraindication[i].treatmenttype) = lower(ls_treatment_type) &
	  and lower(lstr_contraindications.contraindication[i].treatmentkey) = lower(ls_treatment_key) then
	  
		// Make sure we haven't already added this contraindication
		lb_found = false
		for j = 1 to treatment_contraindication[ll_index].contraindication_count
			if lower(lstr_contraindications.contraindication[i].treatmenttype) = lower(treatment_contraindication[ll_index].contraindication[j].treatmenttype) &
			  and lower(lstr_contraindications.contraindication[i].treatmentkey) = lower(treatment_contraindication[ll_index].contraindication[j].treatmentkey) &
			  and lower(lstr_contraindications.contraindication[i].shortdescription) = lower(treatment_contraindication[ll_index].contraindication[j].shortdescription) then
				lb_found = true
				exit
			end if
		next
		
		if not lb_found then
			treatment_contraindication[ll_index].contraindication_count += 1
			
			// The contraindication is for this treatment and we haven't added yet, so add the contraindication
			treatment_contraindication[ll_index].contraindication[treatment_contraindication[ll_index].contraindication_count] = lstr_contraindications.contraindication[i]
			CHOOSE CASE treatment_contraindication[ll_index].contraindication_count
				CASE 1
					dw_treatments.object.contraindication_icon_1[pl_row] = lstr_contraindications.contraindication[i].icon
				CASE 2
					dw_treatments.object.contraindication_icon_2[pl_row] = lstr_contraindications.contraindication[i].icon
				CASE 3
					dw_treatments.object.contraindication_icon_3[pl_row] = lstr_contraindications.contraindication[i].icon
				CASE 4
					dw_treatments.object.contraindication_icon_4[pl_row] = lstr_contraindications.contraindication[i].icon
				CASE 5
					dw_treatments.object.contraindication_icon_5[pl_row] = lstr_contraindications.contraindication[i].icon
			END CHOOSE
		end if
	end if
next

st_updating_contraindications.visible = false
return 0


end function

on u_tabpage_new_treatment_picklist.create
int iCurrent
call super::create
this.cb_copy_from=create cb_copy_from
this.st_updating_contraindications=create st_updating_contraindications
this.cb_sort_list=create cb_sort_list
this.pb_help=create pb_help
this.st_group_title=create st_group_title
this.cb_group_clear_all=create cb_group_clear_all
this.cb_group_select_all=create cb_group_select_all
this.dw_treatments=create dw_treatments
this.cb_new_past=create cb_new_past
this.cb_new_treatment=create cb_new_treatment
this.cb_new_group=create cb_new_group
this.st_treatment_mode_title=create st_treatment_mode_title
this.pb_down=create pb_down
this.pb_up=create pb_up
this.st_page=create st_page
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_copy_from
this.Control[iCurrent+2]=this.st_updating_contraindications
this.Control[iCurrent+3]=this.cb_sort_list
this.Control[iCurrent+4]=this.pb_help
this.Control[iCurrent+5]=this.st_group_title
this.Control[iCurrent+6]=this.cb_group_clear_all
this.Control[iCurrent+7]=this.cb_group_select_all
this.Control[iCurrent+8]=this.dw_treatments
this.Control[iCurrent+9]=this.cb_new_past
this.Control[iCurrent+10]=this.cb_new_treatment
this.Control[iCurrent+11]=this.cb_new_group
this.Control[iCurrent+12]=this.st_treatment_mode_title
this.Control[iCurrent+13]=this.pb_down
this.Control[iCurrent+14]=this.pb_up
this.Control[iCurrent+15]=this.st_page
end on

on u_tabpage_new_treatment_picklist.destroy
call super::destroy
destroy(this.cb_copy_from)
destroy(this.st_updating_contraindications)
destroy(this.cb_sort_list)
destroy(this.pb_help)
destroy(this.st_group_title)
destroy(this.cb_group_clear_all)
destroy(this.cb_group_select_all)
destroy(this.dw_treatments)
destroy(this.cb_new_past)
destroy(this.cb_new_treatment)
destroy(this.cb_new_group)
destroy(this.st_treatment_mode_title)
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.st_page)
end on

event resize_tabpage;call super::resize_tabpage;
pb_help.x = width - pb_help.width - 20

cb_new_treatment.x = width - cb_new_treatment.width - 20
cb_new_group.x = cb_new_treatment.x
pb_up.x = cb_new_treatment.x
pb_down.x = cb_new_treatment.x
st_page.x = cb_new_treatment.x
st_treatment_mode_title.x = cb_new_treatment.x

cb_sort_list.x = cb_new_treatment.x
cb_sort_list.y = height - cb_sort_list.height - 20

cb_copy_from.x = cb_new_treatment.x
cb_copy_from.y = cb_sort_list.y - cb_copy_from.height - 100

cb_new_past.x = cb_new_treatment.x + (cb_new_treatment.width - cb_new_past.width) / 2

st_group_title.x = cb_new_treatment.x
cb_group_select_all.x = cb_new_treatment.x + (cb_new_treatment.width - cb_group_select_all.width) / 2
cb_group_clear_all.x = cb_new_treatment.x + (cb_new_treatment.width - cb_group_clear_all.width) / 2

dw_treatments.width = cb_new_treatment.x - 20
dw_treatments.height = height
dw_treatments.object.efficacy_rating.x = dw_treatments.width - 672

st_updating_contraindications.x = (dw_treatments.width - st_updating_contraindications.width) / 2
st_updating_contraindications.y = height - st_updating_contraindications.height
end event

type cb_copy_from from commandbutton within u_tabpage_new_treatment_picklist
integer x = 2331
integer y = 1256
integer width = 489
integer height = 76
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Copy From ..."
end type

event clicked;str_popup popup
str_popup_return popup_return
string ls_from_assessment_id
string ls_from_user_id 
string ls_action
integer li_choice
w_window_base lw_pick
str_picked_assessments lstr_assessments
str_treatment_lists lstr_treatment_lists
long lla_popup_list_index[]
long ll_list_index
long i

// Get the list of treatment lists
lstr_treatment_lists = treatment_master.get_treatment_lists( )
popup.data_row_count = 0

// Display all the treatment lists except the one currently displayed
for i = 1 to lstr_treatment_lists.treatment_list_count
	if lstr_treatment_lists.treatment_list[i].list_assessment_id <> parent.list_assessment_id &
	  OR lstr_treatment_lists.treatment_list[i].list_user_id <> parent.list_user_id then
		popup.data_row_count += 1
		popup.items[popup.data_row_count] = lstr_treatment_lists.treatment_list[i].description
		lla_popup_list_index[popup.data_row_count] = i
	end if
next

// Add the Other Assessment Common List
popup.data_row_count += 1
popup.items[popup.data_row_count] = "Other Assessment Common List"
lla_popup_list_index[popup.data_row_count] = -1

// Add the Other Assessment Personal List
popup.data_row_count += 1
popup.items[popup.data_row_count] = "Other Assessment Personal List"
lla_popup_list_index[popup.data_row_count] = -2

// Prompt the user to pick which list to copy from
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ll_list_index = lla_popup_list_index[popup_return.item_indexes[1]]
if isnull(ll_list_index) or ll_list_index = 0 then return

if ll_list_index < 0 then
	// The user selected one of the "Other Assessment..." lists, so prompt the user to pick an assessment
	popup.data_row_count = 2
	popup.items[1] = "SICK"
	setnull(popup.items[2])
	openwithparm(lw_pick, popup, "w_pick_assessments")
	lstr_assessments = message.powerobjectparm
	if lstr_assessments.assessment_count < 1 then return
	ls_from_assessment_id = lstr_assessments.assessments[1].assessment_id
	
	if ll_list_index = -2 then
		ls_from_user_id = current_user.user_id
	else
		ls_from_user_id = current_user.common_list_id()
	end if
else
	// The user selected one of the tab lists, so get the key from it
	ls_from_assessment_id = lstr_treatment_lists.treatment_list[ll_list_index].list_assessment_id
	ls_from_user_id = lstr_treatment_lists.treatment_list[ll_list_index].list_user_id
end if

if dw_treatments.rowcount() > 0 then
	popup.data_row_count = 2
	popup.title = "This treatment list already has items.  Do you wish to:"
	popup.items[1] = "Remove these items before copying"
	popup.items[2] = "Append the other list to this list"
	openwithparm(w_pop_choices_2, popup)
	li_choice = message.doubleparm
	if li_choice = 1 then
		ls_action = "Replace"
	else
		ls_action = "Append"
	end if
else
	ls_action = "Replace"
end if

sqlca.jmj_copy_assessment_treatment_list( ls_from_assessment_id, &
														ls_from_user_id, &
														list_assessment_id, &
														list_user_id, &
														ls_action)
if not tf_check() then return

display_treatments()

end event

type st_updating_contraindications from statictext within u_tabpage_new_treatment_picklist
boolean visible = false
integer x = 704
integer y = 1412
integer width = 946
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 31385327
string text = "... Updating Contraindications ..."
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_sort_list from commandbutton within u_tabpage_new_treatment_picklist
integer x = 2331
integer y = 1392
integer width = 338
integer height = 76
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Sort List"
end type

event clicked;str_popup popup
str_popup_return popup_return
long ll_null
long ll_parent_definition_id
long ll_row
string ls_find

ls_find = "selected_flag=1 and treatment_type<>'!COMPOSITE'"
ll_row = dw_treatments.find(ls_find, 1, dw_treatments.rowcount())
if ll_row > 0 then
	if not f_popup_yes_no("You have treatments selected.  Sorting the treatment list will un-select all treatments.  Do you wish to continue?") then
		return
	end if
end if


if selected_group_row > 0 then
	popup.data_row_count = 2
	popup.items[1] = "Sort Main List"
	popup.items[2] = "Sort Selected Group"
	openwithparm(w_pop_pick, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return
	
	if popup_return.item_indexes[1] = 1 then
		setnull(ll_parent_definition_id)
	else
		ll_parent_definition_id = dw_treatments.object.definition_id[selected_group_row]
	end if
else
	setnull(ll_parent_definition_id)
end if

popup.argument_count = 4
popup.argument[1] = list_assessment_id
popup.argument[2] = list_user_id
popup.argument[3] = string(care_plan_id)
popup.argument[4] = string(ll_parent_definition_id)

openwithparm(w_treatment_list_change_sort_order, popup)

display_treatments()

end event

type pb_help from u_pb_help_button within u_tabpage_new_treatment_picklist
integer x = 2592
integer y = 12
integer width = 256
integer height = 128
integer taborder = 20
end type

type st_group_title from statictext within u_tabpage_new_treatment_picklist
boolean visible = false
integer x = 2331
integer y = 916
integer width = 489
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Selected Group"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_group_clear_all from commandbutton within u_tabpage_new_treatment_picklist
boolean visible = false
integer x = 2391
integer y = 1100
integer width = 366
integer height = 88
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear All"
end type

event clicked;long ll_definition_id
long ll_row
string ls_find
long ll_count

if selected_group_row <= 0 then return

ll_count = dw_treatments.rowcount()

ll_definition_id = dw_treatments.object.definition_id[selected_group_row]

// Turn off any other composites
ls_find = "parent_definition_id=" + string(ll_definition_id)
ll_row = dw_treatments.find(ls_find, 1, ll_count)
DO WHILE ll_row > 0 and ll_row <= ll_count
	dw_treatments.object.selected_flag[ll_row] = 0

	ll_row = dw_treatments.find(ls_find, ll_row + 1, ll_count + 1)
LOOP

end event

type cb_group_select_all from commandbutton within u_tabpage_new_treatment_picklist
boolean visible = false
integer x = 2391
integer y = 996
integer width = 366
integer height = 88
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select All"
end type

event clicked;long ll_definition_id
long ll_row
string ls_find
long ll_count

if selected_group_row <= 0 then return

ll_count = dw_treatments.rowcount()

ll_definition_id = dw_treatments.object.definition_id[selected_group_row]

// Turn off any other composites
ls_find = "parent_definition_id=" + string(ll_definition_id)
ll_row = dw_treatments.find(ls_find, 1, ll_count)
DO WHILE ll_row > 0 and ll_row <= ll_count
	dw_treatments.object.selected_flag[ll_row] = 1

	ll_row = dw_treatments.find(ls_find, ll_row + 1, ll_count + 1)
LOOP

end event

type dw_treatments from u_dw_pick_list within u_tabpage_new_treatment_picklist
integer width = 2322
integer height = 1468
integer taborder = 10
string dataobject = "dw_jmj_treatment_list"
boolean vscrollbar = true
boolean border = false
boolean select_computed = false
end type

on constructor;call u_dw_pick_list::constructor;multiselect = true
end on

event unselected;call super::unselected;string ls_treatment_type
string ls_followup_flag
long ll_definition_id
long ll_count
long ll_filtered_count
long i
string ls_filter
long ll_index

ls_treatment_type = dw_treatments.object.treatment_type[unselected_row]
ls_followup_flag = dw_treatments.object.followup_flag[unselected_row]
ll_definition_id = dw_treatments.object.definition_id[unselected_row]

ll_count = dw_treatments.rowcount()
ll_count = dw_treatments.filteredcount()

CHOOSE CASE lower(lastcolumnname)
	CASE "efficacy_rating", "contra_1", "contra_2", "contra_3", "contra_4", "contra_5", "t_info_background"
		object.selected_flag[unselected_row] = 1
		ll_index = dw_treatments.object.contraindication_index[unselected_row]
		if treatment_contraindication[ll_index].contraindication_count = 0 then return
		
//		openwithparm(w_contraindication_display, treatment_contraindication[selected_row])

	CASE ELSE
		if ls_treatment_type = "!COMPOSITE" Then
			clear_group_row()
		end if
END CHOOSE

dw_treatments.filter()
dw_treatments.recalc_page(pb_up, pb_down, st_page)

//long ll_treatment_sequence
//long ll_rows
//long i
//Integer					li_sts,li_count
//// User Defined
//str_popup				popup
//str_item_definition 	lstr_treatments[]
//
//// If the user unselected a composite treatment, then unselect all
//// of its constituent treatments
//if object.treatment_type[unselected_row] = "!COMPOSITE" then
//	// For composites, turn back on the selected flag because we're managing
//	// the selected flag from inside the popup window
//	object.selected_flag[unselected_row] = 1
//	ll_treatment_sequence = object.definition_id[unselected_row]
//
//	popup.objectparm = assessment
//	popup.objectparm1 = dw_therapies
//	popup.objectparm2 = efficacy
//	popup.objectparm3 = formulary
//	popup.data_row_count = 3
//	popup.items[1] = list_user_id
//	popup.items[2] = String(ll_treatment_sequence)
//	popup.items[3] = composite_treatment_list_id
//	popup.title = object.treatment_description[unselected_row]
//
//	Openwithparm(w_pick_composite_treatments, popup)
//	// Get the array of treatment structure
//	popup = Message.powerobjectparm
//	lstr_treatments = popup.anyparm
//	li_sts = Upperbound(lstr_treatments)
//	// Append in instance array
//	li_count = Upperbound(treatment_attr)
//	For i = 1 to li_sts
//		li_count++
//		treatment_attr[li_count] = lstr_treatments[i]
//	Next
//end if	
//
end event

event selected;long ll_row
string ls_treatment_type
string ls_followup_flag
long ll_definition_id
long ll_count
long ll_filtered_count
long i
string ls_filter
string ls_find
long ll_index
string ls_treatment_description
datetime ldt_begin_date
datetime ldt_end_date
long ll_open_encounter_id
integer li_sts
str_service_info lstr_service

ls_treatment_type = dw_treatments.object.treatment_type[selected_row]
ls_followup_flag = dw_treatments.object.followup_flag[selected_row]
ll_definition_id = dw_treatments.object.definition_id[selected_row]

ll_count = dw_treatments.rowcount()
ll_count = dw_treatments.filteredcount()

CHOOSE CASE lower(lastcolumnname)
	CASE "efficacy_rating"
		f_attribute_add_attribute(lstr_service.attributes, "treatment_definition_id", string(ll_definition_id))
		lstr_service.service = efficacy_display_service
		service_list.do_service(lstr_service)
	CASE "contra_1", "contra_2", "contra_3", "contra_4", "contra_5", "t_info_background"
		object.selected_flag[selected_row] = 0
		ll_index = dw_treatments.object.contraindication_index[selected_row]
		if treatment_contraindication[ll_index].contraindication_count = 0 then return
		
		openwithparm(w_contraindication_display, treatment_contraindication[selected_row])

	CASE ELSE
		if ls_treatment_type = "!COMPOSITE" Then
			set_group_row(selected_row)
		else
			if mode = "PAST" then
				ls_treatment_type = dw_treatments.object.treatment_type[selected_row]
				ls_treatment_description = dw_treatments.object.treatment_description[selected_row]
				ldt_begin_date = datetime(assessment_begin_date, time(""))
				ldt_end_date = datetime(assessment_end_date, time(""))
				ll_open_encounter_id = current_patient.open_encounter_id
				
				li_sts = f_get_treatment_dates(ls_treatment_type, ls_treatment_description, ll_open_encounter_id, ldt_begin_date, ldt_end_date)
				
				ll_index = get_treatment_definition_index(selected_row)
				if ll_index <= 0 then return
				
				new_treatments[ll_index].open_encounter_id = ll_open_encounter_id
				new_treatments[ll_index].begin_date = ldt_begin_date
				new_treatments[ll_index].end_date = ldt_end_date
			end if
		end if
END CHOOSE


//Integer					li_sts,li_count,i
//Long						ll_treatment_sequence
//// User Defined
//str_popup				popup
//str_item_definition 	lstr_treatments[]
//
//If mode = "PAST" Then
//	li_sts = get_past_info(selected_row)
//	If li_sts <= 0 Then
//		This.object.selected_flag[selected_row] = 0
//		Return
//	End If
//End If
//// if computed button is clicked then show options to delete
//// composite treatment
//if lasttype = 'compute' then
//	return
//end if
//If dw_therapies.object.treatment_type[selected_row] = "!COMPOSITE" Then
//	ll_treatment_sequence = object.definition_id[selected_row]
//
//	popup.objectparm = assessment
//	popup.objectparm1 = dw_therapies
//	popup.objectparm2 = efficacy
//	popup.objectparm3 = formulary
//	popup.data_row_count = 3
//	popup.items[1] = list_user_id
//	popup.items[2] = String(ll_treatment_sequence)
//	popup.items[3] = composite_treatment_list_id
//	popup.title = object.treatment_description[selected_row]
//
//	Openwithparm(w_pick_composite_treatments, popup)
//	// Get the array of treatment structure
//	popup = Message.powerobjectparm
//	lstr_treatments = popup.anyparm
//	li_sts = Upperbound(lstr_treatments)
//	// Append in instance array
//	li_count = Upperbound(treatment_attr)
//	For i = 1 to li_sts
//		li_count++
//		treatment_attr[li_count] = lstr_treatments[i]
//	Next
//End If
end event

event computed_clicked;integer li_sts
string ls_treatment_type
string ls_treatment_key
long ll_index
str_service_info lstr_service
long ll_definition_id

ll_definition_id = dw_treatments.object.definition_id[clicked_row]
ls_treatment_type = dw_treatments.object.treatment_type[clicked_row]
ls_treatment_key = dw_treatments.object.treatment_key[clicked_row]

CHOOSE CASE lower(lastcolumnname)
	CASE "efficacy_rating"
		f_attribute_add_attribute(lstr_service.attributes, "treatment_definition_id", string(ll_definition_id))
		f_attribute_add_attribute(lstr_service.attributes, "assessment_id", list_assessment_id)
		f_attribute_add_attribute(lstr_service.attributes, "treatment_type", ls_treatment_type)
		f_attribute_add_attribute(lstr_service.attributes, "treatment_key", ls_treatment_key)
		lstr_service.service = efficacy_display_service
		service_list.do_service(lstr_service)
	CASE "contra_1", "contra_2", "contra_3", "contra_4", "contra_5", "t_info_background"
		object.selected_flag[clicked_row] = 0
		ll_index = object.contraindication_index[clicked_row]
		if treatment_contraindication[ll_index].contraindication_count = 0 then return
		
		openwithparm(w_contraindication_display, treatment_contraindication[ll_index])
	CASE ELSE
		ls_treatment_type = object.treatment_type[clicked_row]
		if upper(ls_treatment_type) = "!COMPOSITE" then
			if allow_editing then
				object.selected_flag[clicked_row] = 1
				set_group_row(clicked_row)
				group_menu(clicked_row)
			end if
		else
			li_sts = edit_treatment_def(clicked_row)
		end if
END CHOOSE



end event

type cb_new_past from commandbutton within u_tabpage_new_treatment_picklist
integer x = 2377
integer y = 408
integer width = 398
integer height = 88
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Order New"
end type

event clicked;dw_treatments.clear_selected()

if mode = "PAST" then
	mode = "NEW"
	text = "Order New"
else
	mode = "PAST"
	text = "Record Past"
end if


end event

type cb_new_treatment from commandbutton within u_tabpage_new_treatment_picklist
integer x = 2331
integer y = 568
integer width = 489
integer height = 108
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Treatment"
end type

event clicked;integer li_sts

li_sts = new_treatment_item(false)

//destroyobj:
//// Destroy the component
//component_manager.destroy_component(luo_treatment)
//// If rows have been added, then scroll to the end
//If ll_rowcount < dw_therapies.rowcount() then
//	dw_therapies.last_page = 0
//	dw_therapies.set_page(1, st_page.text)
//	If dw_therapies.last_page < 2 Then
//		pb_up.visible = false
//		pb_down.visible = false
//	Else
//		pb_up.visible = true
//		pb_down.visible = true
//		pb_up.enabled = true
//		pb_down.enabled = true
//	End If
//	dw_therapies.set_page(dw_therapies.last_page, st_page.text)
//End if

Return
end event

type cb_new_group from commandbutton within u_tabpage_new_treatment_picklist
integer x = 2331
integer y = 768
integer width = 489
integer height = 108
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Group"
end type

event clicked;integer li_sts

li_sts = new_group()

//destroyobj:
//// Destroy the component
//component_manager.destroy_component(luo_treatment)
//// If rows have been added, then scroll to the end
//If ll_rowcount < dw_therapies.rowcount() then
//	dw_therapies.last_page = 0
//	dw_therapies.set_page(1, st_page.text)
//	If dw_therapies.last_page < 2 Then
//		pb_up.visible = false
//		pb_down.visible = false
//	Else
//		pb_up.visible = true
//		pb_down.visible = true
//		pb_up.enabled = true
//		pb_down.enabled = true
//	End If
//	dw_therapies.set_page(dw_therapies.last_page, st_page.text)
//End if

Return
end event

type st_treatment_mode_title from statictext within u_tabpage_new_treatment_picklist
integer x = 2331
integer y = 328
integer width = 489
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Treatment Mode"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_down from u_picture_button within u_tabpage_new_treatment_picklist
integer x = 2345
integer y = 136
integer width = 137
integer height = 116
integer taborder = 20
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;string ls_temp
integer li_page
integer li_last_page

li_page = dw_treatments.current_page
li_last_page = dw_treatments.last_page

dw_treatments.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type pb_up from u_picture_button within u_tabpage_new_treatment_picklist
integer x = 2345
integer y = 8
integer width = 137
integer height = 116
integer taborder = 10
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;string ls_temp
integer li_page

li_page = dw_treatments.current_page

dw_treatments.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type st_page from statictext within u_tabpage_new_treatment_picklist
boolean visible = false
integer x = 2345
integer y = 252
integer width = 288
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Page 99/99"
boolean focusrectangle = false
end type

