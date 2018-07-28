$PBExportHeader$w_pick_new_treatment.srw
forward
global type w_pick_new_treatment from w_window_base
end type
type cb_cancel from commandbutton within w_pick_new_treatment
end type
type cb_done from commandbutton within w_pick_new_treatment
end type
type cb_be_back from commandbutton within w_pick_new_treatment
end type
type st_page from statictext within w_pick_new_treatment
end type
type pb_up from u_picture_button within w_pick_new_treatment
end type
type pb_down from u_picture_button within w_pick_new_treatment
end type
type cb_sort from commandbutton within w_pick_new_treatment
end type
type st_1 from statictext within w_pick_new_treatment
end type
type cb_composite from commandbutton within w_pick_new_treatment
end type
type cb_new_treatment from commandbutton within w_pick_new_treatment
end type
type cb_new_past from commandbutton within w_pick_new_treatment
end type
type cb_which_list from commandbutton within w_pick_new_treatment
end type
type dw_therapies from u_dw_pick_list within w_pick_new_treatment
end type
type st_assessment from statictext within w_pick_new_treatment
end type
end forward

global type w_pick_new_treatment from w_window_base
boolean controlmenu = false
windowtype windowtype = response!
string button_type = "COMMAND"
integer max_buttons = 2
cb_cancel cb_cancel
cb_done cb_done
cb_be_back cb_be_back
st_page st_page
pb_up pb_up
pb_down pb_down
cb_sort cb_sort
st_1 st_1
cb_composite cb_composite
cb_new_treatment cb_new_treatment
cb_new_past cb_new_past
cb_which_list cb_which_list
dw_therapies dw_therapies
st_assessment st_assessment
end type
global w_pick_new_treatment w_pick_new_treatment

type variables
String 		common_list_id,list_user_id
Integer 		default_update_flag
Integer 		update_flag
Boolean 		personal_list
String 		mode
date 			assessment_begin_date
date			assessment_end_date
Datastore	dw_child_treatments

u_ds_data treatment_attributes
u_ds_data efficacy
u_ds_data formulary

u_component_service service
str_assessment_description assessment

// arrary of treatment attributes
str_item_definition         treatment_attr[]

string single_treatment_list_id
string composite_treatment_list_id

end variables

forward prototypes
public function integer new_followup ()
public function integer get_past_info (long pl_row)
public function integer get_followup_wp (string ps_wp_type)
public subroutine delete_therapy (long pl_row)
public function integer find_attribute_index (long pl_row)
public subroutine new_treatment_item (long pl_row)
public subroutine clear_all_selected ()
public subroutine set_default_list ()
public subroutine set_user_list ()
public subroutine therapy_item_menu_old (long pl_row)
public function integer edit_treatment_def (long pl_row)
public function integer set_treatment_attribute (long pl_row, string ps_attribute, string ps_value)
public function long save_assessment_treatment (long pl_row)
public subroutine display_treatments ()
public function str_attributes get_treatment_attributes (long pl_row)
end prototypes

public function integer new_followup ();return 1

end function

public function integer get_past_info (long pl_row);string ls_treatment_description
string ls_treatment_type
datetime ldt_begin_date
datetime ldt_end_date
long ll_open_encounter_id
integer li_sts

ls_treatment_type = dw_therapies.object.treatment_type[pl_row]
ls_treatment_description = dw_therapies.object.treatment_description[pl_row]
ldt_begin_date = datetime(assessment_begin_date, time(""))
ldt_end_date = datetime(assessment_end_date, time(""))
ll_open_encounter_id = current_patient.open_encounter_id

li_sts = f_get_treatment_dates(ls_treatment_type, ls_treatment_description, ll_open_encounter_id, ldt_begin_date, ldt_end_date)

dw_therapies.object.open_encounter_id[pl_row] = ll_open_encounter_id
dw_therapies.object.onset[pl_row] = ldt_begin_date
dw_therapies.object.duration[pl_row] = ldt_end_date

return 1

end function

public function integer get_followup_wp (string ps_wp_type);long	ll_workplan_id

DECLARE lsp_get_followup_workplan PROCEDURE FOR dbo.sp_get_followup_workplan
	@ps_workplan_type = :ps_wp_type,
	@pl_followup_workplan_id = :ll_workplan_id OUT;

// Show this button only if there's a followup workplan
	EXECUTE lsp_get_followup_workplan;
	If not tf_check() then 
		CLOSE lsp_get_followup_workplan;
		Return -1
	End If
	FETCH lsp_get_followup_workplan INTO :ll_workplan_id;
	If not tf_check() then 
		CLOSE lsp_get_followup_workplan;
		Return -1
	End If
	CLOSE lsp_get_followup_workplan;
Return ll_workplan_id
end function

public subroutine delete_therapy (long pl_row);//////////////////////////////////////////////////////////////////////////////////////
//
// Description:Delete the current record in u_assessment_treat_definition and 
//             u_assessment_treat_def_attrib tables.
//
// Created By:Mark														Creation dt: 
//
// Modified By:Sumathi Chinnasamy									Creation dt: 03/20/2000
/////////////////////////////////////////////////////////////////////////////////////

long ll_rows,ll_definition_id
long i

// Mark the record for deletion
ll_definition_id = dw_therapies.object.definition_id[pl_row]

// go thru all child treatments for this record and delete all of them
ll_rows = dw_therapies.filteredcount()
FOR i = ll_rows TO 1 Step -1
	IF ll_definition_id = dw_therapies.object.parent_definition_id.filter[i] THEN &
		dw_therapies.object.update_flag.filter[i] = -1
NEXT

dw_therapies.Deleterow(pl_row)
dw_therapies.filter()
end subroutine

public function integer find_attribute_index (long pl_row);String		ls_treatment_type,ls_treatment_desc
Integer		i

// Is treatment selected from pre-defined(old) list ..
If dw_therapies.object.update_flag[pl_row] = 0 Then
	return 0
Else
	ls_treatment_type = dw_therapies.object.treatment_type[pl_row]
	ls_treatment_desc = dw_therapies.object.treatment_description[pl_row]
	For i = 1 To upperbound(treatment_attr)
		If (treatment_attr[i].treatment_type = ls_treatment_type) And &
			(treatment_attr[i].item_description = ls_treatment_desc) Then
			return i
		End If
	Next
End If

Return 0

end function

public subroutine new_treatment_item (long pl_row);////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description:Instantiate treatment component to order a treatment
//
// Created By:Mark																		Creation dt: 
//
// Modified By:Sumathi Chinnasamy													Modified dt: 03/20/2000
//
// Store the treatments into assessment tables(predefined list) only when update flag is set to '2'
// Also, when the added treatments are followup items they all go into workplan tables instead 
// p_treatment_item.
//
// update flag (1 - delete, 2 - update, 0 - predefined )
///////////////////////////////////////////////////////////////////////////////////////////////////

String   					ls_attributes[], ls_values[]
String   					ls_cpr_id,ls_user_id,ls_child_flag
String   					ls_treatment_type,ls_treatment_desc,ls_in_office_flag
String						ls_find
Long    						ll_problem_id,ll_open_encounter_id
Long							ll_rowcount,ll_definition_id,ll_followup_workplan_id
Long							ll_find
Boolean  					lb_past_treatment = False
Integer						li_return,li_attribute_count
Datetime 					ldt_begin_date,ldt_end_date
str_attributes lstr_attributes
u_ds_data luo_children
u_ds_data luo_child_attributes
long i
long ll_child_count
long ll_attrib_count
long ll_child_definition_id
long ll_treatment_id
integer li_sts
string ls_temp

ls_cpr_id = current_patient.cpr_id
ls_user_id = current_user.user_id

ls_treatment_type = dw_therapies.object.treatment_type[pl_row]
ls_treatment_desc = dw_therapies.object.treatment_description[pl_row]
ll_definition_id	= dw_therapies.object.definition_id[pl_row]

ll_open_encounter_id = dw_therapies.object.open_encounter_id[pl_row]
if isnull(ll_open_encounter_id) then
	ll_open_encounter_id = current_patient.open_encounter_id
	If Isnull(ll_open_encounter_id) Then
		log.log(This, "new_treatment_item()", "No open encounter", 4)
		Return
	End if
end if

ll_problem_id = assessment.problem_id
ll_rowcount = dw_therapies.rowcount()

// Get the begin date
Choose Case mode
	Case "NEW"
		if upper(current_patient.open_encounter.encounter_status) = "OPEN" &
			and date(current_patient.open_encounter.encounter_date) = today() &
			and time(current_patient.open_encounter.encounter_date) < now() then
				ldt_begin_date = datetime(today(), now())
		else
			// Add one second to the encounter date to make sure that the treatment starts after the encounter
			ldt_begin_date = f_datetime_add_seconds(current_patient.open_encounter.encounter_date, 1)
		end if
	Case "PAST"
		ldt_begin_date = dw_therapies.object.onset[pl_row]
		If isnull(ldt_begin_date) Then
			ldt_begin_date = datetime(assessment_begin_date, time(""))
		End If
		lb_past_treatment = true
End Choose

// Get the end date and the in_office_flag
ls_in_office_flag = datalist.treatment_type_in_office_flag(ls_treatment_type)
ldt_end_date = dw_therapies.object.duration[pl_row]

// If there isn't an end date, and it's a past assessment, and the treatment
//is an office treatment,then set the end_date to be the begin_date.
If isnull(ldt_end_date) And mode = "PAST" And ls_in_office_flag = "Y" Then
	ldt_end_date = ldt_begin_date
End if

// If there still isn't an end date, and the assessment is closed, 
//then set the end date to the assessment end date
If isnull(ldt_end_date) And Not isnull(assessment.end_date) Then
	ldt_end_date = assessment.end_date
End if

// child_flag is set to 'F' or 'R' for followup/referral items; If so dont order them
ls_child_flag = dw_therapies.object.child_flag[pl_row]
If Len(ls_child_flag) = 0 Or Isnull(ls_child_flag) Then
	lstr_attributes = get_treatment_attributes(pl_row)
	
	// See if we have an attribute for the treatment description
	ls_temp = f_attribute_find_attribute(lstr_attributes, "treatment_description")
	if len(ls_temp) > 0 then ls_treatment_desc = ls_temp
	
	// If followup workplan is overriden by this window(thru followup workplan button)
	ll_followup_workplan_id = dw_therapies.object.followup_workplan_id[pl_row]
	If Not Isnull(ll_followup_workplan_id) Or ll_followup_workplan_id > 0 Then
		f_attribute_add_attribute(lstr_attributes, "followup_workplan_id", String(ll_followup_workplan_id))
	End If
	
	if not isnull(ldt_begin_date) then f_attribute_add_attribute(lstr_attributes, "begin_date", string(ldt_begin_date))
	if not isnull(ldt_end_date) then f_attribute_add_attribute(lstr_attributes, "end_date", string(ldt_end_date))
	
	// now order the treatment
	ll_treatment_id = current_patient.treatments.order_treatment(ls_cpr_id, &
																					ll_open_encounter_id, &
																					ls_treatment_type, &
																					ls_treatment_desc, &
																					ll_problem_id, &
																					lb_past_treatment, &
																					ls_user_id, &
																					0, &
																					lstr_attributes, &
																					false)
	if ll_treatment_id <= 0 then
		li_return = -1
	else
		li_return = 1
	end if
	// check whether the current treatment needs to be updated for future reference
	If dw_therapies.object.update_flag[pl_row] = 2 Then
		ll_definition_id = save_assessment_treatment(pl_row)
	End If
	If li_return > 0 and ll_definition_id > 0 Then
		luo_children = CREATE u_ds_data
		luo_child_attributes = CREATE u_ds_data
		luo_children.set_dataobject("dw_child_treatment_defs")
		luo_child_attributes.set_dataobject("dw_u_assessment_treat_def_attrib")
		ll_child_count = luo_children.retrieve(ll_definition_id)
		for i = 1 to ll_child_count
			ll_child_definition_id = luo_children.object.definition_id[i]
			ll_attrib_count = luo_child_attributes.retrieve(ll_child_definition_id)
			lstr_attributes.attribute_count = 0
			f_attribute_ds_to_str(luo_child_attributes, lstr_attributes)
			ls_treatment_type = luo_children.object.treatment_type[i]
			ls_treatment_desc = luo_children.object.treatment_description[i]
			li_sts = current_patient.treatments.add_followup_treatment_item(ll_treatment_id, &
																								ls_treatment_type, &
																								ls_treatment_desc, &
																								lstr_attributes)
		next
		DESTROY luo_children
		DESTROY luo_child_attributes
	End If
	
	// See if there are any auto-perform services for the new treatment
	current_patient.treatments.do_autoperform_services(ll_treatment_id)
End If

// Yield control so that any autoperform services associated with the new treatment can be performed
yield()
//component_manager.destroy_component(luo_treatment)
Return

end subroutine

public subroutine clear_all_selected ();long i

dw_therapies.setredraw(false)

for i = 1 to dw_therapies.rowcount()
	dw_therapies.object.selected_flag[i] = 0
next

for i = 1 to dw_therapies.filteredcount()
	dw_therapies.object.selected_flag.filter[i] = 0
next

dw_therapies.setredraw(true)

end subroutine

public subroutine set_default_list ();// common list for the specialty
list_user_id = common_list_id

display_treatments()

personal_list = False
if user_list.is_user_privileged( current_user.user_id, "Common Treatment Lists") then
	update_flag = default_update_flag
else
	update_flag = 1
end if

cb_which_list.text = "Common List"

end subroutine

public subroutine set_user_list ();// load assessment treatments for current user
list_user_id = current_user.user_id

display_treatments()

personal_list = True
update_flag = default_update_flag
cb_which_list.text = "Personal List"


end subroutine

public subroutine therapy_item_menu_old (long pl_row);string 					buttons[],ls_treatment_type,ls_treatment_desc
String					ls_treatment_mode,ls_wp_type
String					ls_attributes[],ls_values[]
character 				lc_followup_flag
integer 					button_pressed, li_sts, li_service_count
integer 					li_update_flag,i,li_count
long						ll_definition_id,ll_workplan_id,ll_row

str_popup 				popup, popup_followup
str_popup_return	 	popup_return
window	 				lw_pop_buttons
str_item_definition	lstr_treatments[]

li_update_flag = dw_therapies.object.update_flag[pl_row]
ls_treatment_type = dw_therapies.object.treatment_type[pl_row]
ls_treatment_desc = dw_therapies.object.treatment_description[pl_row]
lc_followup_flag = datalist.treatment_type_followup_flag(ls_treatment_type)

If (list_user_id = current_user.user_id Or current_user.check_privilege("Common Treatment Lists")) Then
	If lc_followup_flag = "F" then
		ls_treatment_mode = "Followup" ; ls_wp_type = "Followup"
		popup.button_count = popup.button_count + 1
		popup.button_icons[popup.button_count] = "b_new06.bmp"
		popup.button_helps[popup.button_count] = "Add Followup Items"
		popup.button_titles[popup.button_count] = "Followup Treatments"
		buttons[popup.button_count] = "FollowupItem"
		
		ll_workplan_id = get_followup_wp(ls_wp_type)
		If ll_workplan_id > 0 then
			popup.button_count = popup.button_count + 1
			popup.button_icons[popup.button_count] = "b_new06.bmp"
			popup.button_helps[popup.button_count] = "Add Followup Workplan"
			popup.button_titles[popup.button_count] = "Followup Workplan"
			buttons[popup.button_count] = "FollowupWorkplan"
		End If
	Elseif lc_followup_flag = "R" then
		ls_treatment_mode = "Referral"; ls_wp_type = "Referral"
		popup.button_count = popup.button_count + 1
		popup.button_icons[popup.button_count] = "b_new06.bmp"
		popup.button_helps[popup.button_count] = "Add Referral Items"
		popup.button_titles[popup.button_count] = "Referral Treatments"
		buttons[popup.button_count] = "ReferralItem"
		
		ll_workplan_id = get_followup_wp(ls_wp_type)
		If ll_workplan_id > 0 then
			popup.button_count = popup.button_count + 1
			popup.button_icons[popup.button_count] = "b_new06.bmp"
			popup.button_helps[popup.button_count] = "Add Referral Workplan"
			popup.button_titles[popup.button_count] = "Referral Workplan"
			buttons[popup.button_count] = "ReferralWorkplan"
		End If
	End If
	If li_update_flag = 1 Then
		popup.button_count = popup.button_count + 1
		popup.button_icons[popup.button_count] = "b_new06.bmp"
		popup.button_helps[popup.button_count] = "Update List"
		popup.button_titles[popup.button_count] = "Update List"
		buttons[popup.button_count] = "UPDATE"
	Elseif li_update_flag = 2 Then
		popup.button_count = popup.button_count + 1
		popup.button_icons[popup.button_count] = "button06.bmp"
		popup.button_helps[popup.button_count] = "Don't Update List"
		popup.button_titles[popup.button_count] = "Don't Update"
		buttons[popup.button_count] = "NOUPDATE"
	End If
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Delete Item"
	popup.button_titles[popup.button_count] = "Delete Item"
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
	CASE "UPDATE"
		dw_therapies.setitem(pl_row, "update_flag", 2)
	CASE "NOUPDATE"
		dw_therapies.setitem(pl_row, "update_flag", 1)
	CASE "DELETE"
		delete_therapy(pl_row)
	CASE "FollowupItem", "ReferralItem"
		ll_definition_id = dw_therapies.object.definition_id[pl_row]
		// If not already saved then save it
		If Isnull(ll_definition_id) or ll_definition_id = 0 Then
			For i = 1 To upperbound(treatment_attr)
				If (treatment_attr[i].treatment_type = ls_treatment_type) And &
					(treatment_attr[i].item_description = ls_treatment_desc) Then
					ls_attributes = treatment_attr[i].attribute
					ls_values = treatment_attr[i].value
					Exit
				End If
			Next
//			ll_definition_id = save_assessment_treatment(pl_row,ls_attributes,ls_values)
		End If	
		If ll_definition_id > 0 Then 
			popup_followup.objectparm2 = dw_therapies
			popup_followup.data_row_count = 3
			popup_followup.item = assessment.assessment_id
			popup_followup.items[1] = list_user_id
			popup_followup.items[2] = String(ll_definition_id)
			popup_followup.items[3] = ls_treatment_mode
			popup_followup.title = ls_treatment_desc
			Openwithparm(w_add_followup_treatments,popup_followup)
			// Get the array of treatment structure
			popup = Message.powerobjectparm
			lstr_treatments = popup.anyparm
			li_sts = Upperbound(lstr_treatments)
			// Append in instance array
			li_count = Upperbound(treatment_attr)
			For i = 1 to li_sts
				li_count++
				treatment_attr[li_count] = lstr_treatments[i]
			Next
		End If
	CASE "FollowupWorkplan","ReferralWorkplan"
		// Show all the followup workplans
		popup.dataobject = "dw_followup_workplan_list"
		popup.datacolumn = 1
		popup.displaycolumn = 2
		popup.argument_count = 1
		popup.argument[1] = ls_wp_type
		
		Openwithparm(w_pop_pick, popup)
		popup_return = Message.powerobjectparm
		If popup_return.item_count <> 1 Then Return
		ll_workplan_id = Long(popup_return.items[1])

//		ll_definition_id = dw_therapies.object.definition_id[pl_row]
//		// If not already saved then get its attributes
//		If Isnull(ll_definition_id) or ll_definition_id = 0 Then
//			For i = 1 To upperbound(treatment_attr)
//				If (treatment_attr[i].treatment_type = ls_treatment_type) And &
//					(treatment_attr[i].item_description = ls_treatment_desc) Then
//					ls_attributes = treatment_attr[i].attribute
//					ls_values = treatment_attr[i].value
//					Exit
//				End If
//			Next
//		End If	
		dw_therapies.object.followup_workplan_id[pl_row] = ll_workplan_id
//		ll_definition_id = save_assessment_treatment(pl_row,ls_attributes,ls_values)
	CASE "CANCEL"
		Return
	CASE ELSE
END CHOOSE

Return
end subroutine

public function integer edit_treatment_def (long pl_row);str_assessment_treatment_definition lstr_treatment_def
str_assessment_treatment_definition lstr_return_treatment_def
long ll_count
string lsa_attributes[]
string lsa_values[]
str_popup_return popup_return
integer li_idx
string ls_treatment_mode
string ls_treatment_type
string ls_followup_flag
w_window_base lw_window

// If this is a followup treatment then save it
ls_treatment_type = dw_therapies.object.treatment_type[pl_row]
ls_followup_flag = datalist.treatment_type_followup_flag(ls_treatment_type)
if not isnull(ls_followup_flag) and upper(ls_followup_flag) <> "N" then
	save_assessment_treatment(pl_row)
end if

// Set the treatment definition fields
lstr_treatment_def.definition_id = dw_therapies.object.definition_id[pl_row]
lstr_treatment_def.assessment_id = dw_therapies.object.assessment_id[pl_row]
lstr_treatment_def.treatment_type = dw_therapies.object.treatment_type[pl_row]
lstr_treatment_def.treatment_description = dw_therapies.object.treatment_description[pl_row]
lstr_treatment_def.followup_workplan_id = dw_therapies.object.followup_workplan_id[pl_row]
lstr_treatment_def.user_id = dw_therapies.object.user_id[pl_row]
lstr_treatment_def.sort_sequence = dw_therapies.object.sort_sequence[pl_row]
lstr_treatment_def.instructions = dw_therapies.object.instructions[pl_row]
lstr_treatment_def.parent_definition_id = dw_therapies.object.parent_definition_id[pl_row]
lstr_treatment_def.child_flag = dw_therapies.object.child_flag[pl_row]

// Set the attributes
lstr_treatment_def.attributes = get_treatment_attributes(pl_row)

// Set the "extra" fields
lstr_treatment_def.update_flag = dw_therapies.object.update_flag[pl_row]
if list_user_id = current_user.common_list_id() then
	lstr_treatment_def.common_list = true
else
	lstr_treatment_def.common_list = false
end if


openwithparm(lw_window, lstr_treatment_def, "w_assessment_treatment_edit")
popup_return = message.powerobjectparm
lstr_return_treatment_def = popup_return.returnobject
if popup_return.item_count <> 1 then return 0

if popup_return.items[1] = "DELETE" then
	delete_therapy(pl_row)
elseif popup_return.items[1] = "OK" then
	dw_therapies.object.update_flag[pl_row] = lstr_return_treatment_def.update_flag
//	f_save_assessment_treatment_def(lstr_return_treatment_def)
	dw_therapies.object.followup_workplan_id[pl_row] = lstr_return_treatment_def.followup_workplan_id

	// Update the description
	dw_therapies.object.treatment_description[pl_row] = lstr_return_treatment_def.treatment_description
	
	// If this is a new treatment_def then we must also update the attributes array
	if isnull(lstr_treatment_def.definition_id) then
		li_idx = find_attribute_index(pl_row)
		if li_idx > 0 then
			treatment_attr[li_idx].item_description = lstr_return_treatment_def.treatment_description
		end if
	end if

	// Set the treatment_mode
	ls_treatment_mode = f_attribute_find_attribute(lstr_return_treatment_def.attributes, "treatment_mode")
	set_treatment_attribute(pl_row, "treatment_mode", ls_treatment_mode)
end if

return 1

end function

public function integer set_treatment_attribute (long pl_row, string ps_attribute, string ps_value);Long			ll_rows
long ll_count
integer j
long ll_rowcount
string ls_find
long ll_row
boolean lb_found
long ll_definition_id
integer i
integer k

ll_definition_id = dw_therapies.object.definition_id[pl_row]

// Is treatment selected from pre-defined(old) list ..
If ll_definition_id > 0 Then
	ll_rowcount = treatment_attributes.rowcount()
	ll_count = 0
	ls_find = "definition_id=" + string(dw_therapies.object.definition_id[pl_row])
	ls_find += " and attribute='" + ps_attribute + "'"
	ll_row = treatment_attributes.find(ls_find, 1, ll_rowcount)
	if ll_row <= 0 then
		if not isnull(ps_value) then
			// If we didn't find the attribute then add it
			ll_row = treatment_attributes.insertrow(0)
			treatment_attributes.object.definition_id[ll_row] = ll_definition_id
			treatment_attributes.object.attribute[ll_row] = ps_attribute
			treatment_attributes.object.value[ll_row] = ps_value
		end if
	else
		if isnull(ps_value) then
			// If we found the attribute but we're changing it to null then delete it
			treatment_attributes.deleterow(ll_row)
		else
			// Otherwise set the new value
			treatment_attributes.object.value[ll_row] = ps_value
		end if
	end if
Else
	// Search the new treatment attribute arrays for the desired treatment
	i = find_attribute_index(pl_row)
	if i > 0 then
		// We found the attribute structure, so search the attributes for the one we're setting
		lb_found = false
		for j = treatment_attr[i].attribute_count to 1 step -1
			if treatment_attr[i].attribute[j] = ps_attribute then
				if isnull(ps_value) then
					// We found it but we're setting it to null so remove it
					for k = j to treatment_attr[i].attribute_count - 1
						treatment_attr[i].attribute[k] = treatment_attr[i].attribute[k + 1]
						treatment_attr[i].value[k] = treatment_attr[i].value[k + 1]
					next
					treatment_attr[i].attribute_count -= 1
				else
					// We found it so set the value
					lb_found = true
					treatment_attr[i].value[j] = ps_value
				end if
			end if
		next
		// If we didn't find the attribute and the value is not null then add it
		if not lb_found and not isnull(ps_value) then
			treatment_attr[i].attribute_count += 1
			treatment_attr[i].attribute[treatment_attr[i].attribute_count] = ps_attribute
			treatment_attr[i].value[treatment_attr[i].attribute_count] = ps_value
		end if
	end if
End If

Return ll_count

end function

public function long save_assessment_treatment (long pl_row);//////////////////////////////////////////////////////////////////////////////////////
//
// Description:Save the treatment and its attributes into u_Assessment_treat_definition
//             and u_Assessment_treat_def_attrib tables.
//
// Created By:Mark														Creation dt: 
//
// Modified By:Sumathi Chinnasamy									Creation dt: 03/20/2000
/////////////////////////////////////////////////////////////////////////////////////

String			ls_assessment_id,ls_treatment_type,ls_treatment_desc
String			ls_user_id,ls_instructions
Char				lc_child_flag
Integer			li_sort_seq, li_count
Long				ll_row
Long				ll_definition_id,ll_parent_definition_id
Long				ll_followup_workplan_id
str_attributes lstr_attributes

DECLARE lsp_insert_assessment_treat_def PROCEDURE FOR dbo.sp_insert_assessment_treat_def
			@ps_assessment = :ls_assessment_id,
			@ps_treatment_type = :ls_treatment_type,
			@ps_treatment_desc = :ls_treatment_desc,
			@ps_user_id = :ls_user_id,
			@pi_sort_sequence  = :li_sort_seq,
			@ps_instructions = :ls_instructions,
			@pl_parent_definition_id = :ll_parent_definition_id,
			@pc_child_flag = :lc_child_flag,
			@pl_followup_workplan_id = :ll_followup_workplan_id,
			@pl_definition_id = :ll_definition_id OUT;

Setnull(lc_child_flag)

// See if the definition has already been saved
ll_definition_id = dw_therapies.object.definition_id[pl_row]
if ll_definition_id > 0 then return ll_definition_id

ls_assessment_id 	      = dw_therapies.object.assessment_id[pl_row]
ls_treatment_type       = dw_therapies.object.treatment_type[pl_row]
ls_treatment_desc       = dw_therapies.object.treatment_description[pl_row]
li_sort_seq             = dw_therapies.object.sort_sequence[pl_row]
ls_user_id              = dw_therapies.object.user_id[pl_row]
ls_instructions         = dw_therapies.object.instructions[pl_row]
ll_parent_definition_id = dw_therapies.object.parent_definition_id[pl_row]
lc_child_flag				= dw_therapies.object.child_flag[pl_row]
ll_followup_workplan_id = dw_therapies.object.followup_workplan_id[pl_row]
ll_definition_id 			= dw_therapies.object.definition_id[pl_row]

// Save treatments
Execute lsp_insert_assessment_treat_def;
If Not tf_check() Then
	Close lsp_insert_assessment_treat_def;
	Return -1
End If

Fetch lsp_insert_assessment_treat_def  Into :ll_definition_id;
If Not tf_check() Then
	Close lsp_insert_assessment_treat_def;
	Return -1
End If
Close lsp_insert_assessment_treat_def;

// Save the attributes
lstr_attributes = get_treatment_attributes(pl_row)
For li_count = 1 To lstr_attributes.attribute_count
		ll_row = treatment_attributes.insertrow(0)
		treatment_attributes.object.definition_id[ll_row] = ll_definition_id
		treatment_attributes.object.attribute[ll_row] = lstr_attributes.attribute[li_count].attribute
		if len(lstr_attributes.attribute[li_count].value) > 255 then
			treatment_attributes.object.long_value[ll_row] = lstr_attributes.attribute[li_count].value
		else
			treatment_attributes.object.value[ll_row] = lstr_attributes.attribute[li_count].value
		end if
Next

If treatment_attributes.update() <= 0 Then Return -1
// Set the definition id
dw_therapies.object.definition_id[pl_row] = ll_definition_id
dw_therapies.object.update_flag[pl_row] = 0
dw_therapies.SetItemStatus (pl_row, 0, Primary!, DataModified! )
dw_therapies.SetItemStatus (pl_row, 0, Primary!, NotModified! )
Return ll_definition_id

end function

public subroutine display_treatments ();// load treatments for specific user
long		i
string ls_treatment_type
long ll_row
string ls_find
u_ds_data luo_data
long ll_attrib_rows
long ll_definition_id
string ls_treatment_key
string lsa_attributes[]
string lsa_values[]
integer li_attribute_count
long ll_rows

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_assessment_treat_attrib_cache")
ll_attrib_rows = luo_data.retrieve(assessment.assessment_id)

// Refresh the attributes datastore
ll_rows = treatment_attributes.retrieve(assessment.assessment_id)

dw_therapies.Retrieve(list_user_id, assessment.assessment_id)
dw_therapies.Setfilter("isnull(parent_definition_id)")
dw_therapies.Filter()

For i = 1 To dw_therapies.rowcount()
	ll_definition_id = dw_therapies.object.definition_id[i]
	ls_treatment_type = dw_therapies.object.treatment_type[i]
	If ls_treatment_type = "!COMPOSITE" Then
		dw_therapies.object.icon[i] = "iconcomposite.bmp"
	else
		li_attribute_count = 0
		ls_find = "definition_id=" + string(ll_definition_id)
		ll_row = luo_data.find(ls_find, 1, ll_attrib_rows)
		DO WHILE ll_row > 0 and ll_row <= ll_attrib_rows
			li_attribute_count += 1
			lsa_attributes[li_attribute_count] = luo_data.object.attribute[ll_row]
			lsa_values[li_attribute_count] = luo_data.object.value[ll_row]
			ll_row = luo_data.find(ls_find, ll_row + 1, ll_attrib_rows + 1)
		LOOP
		
		ls_treatment_key = f_get_treatment_key(ls_treatment_type, li_attribute_count, lsa_attributes, lsa_values)
		
		dw_therapies.object.treatment_key[i] = ls_treatment_key
				
		if not isnull(ls_treatment_key) then
			ls_find = "treatment_type='" + ls_treatment_type + "'"
			ls_find += " and treatment_key='" + ls_treatment_key + "'"
			ll_row = efficacy.find(ls_find, 1, efficacy.rowcount())
			if ll_row > 0 then
				dw_therapies.object.rating[i] = efficacy.object.rating[ll_row]
			end if

			ll_row = formulary.find(ls_find, 1, formulary.rowcount())
			if ll_row > 0 then
				dw_therapies.object.formulary_icon[i] = formulary.object.icon[ll_row]
			end if
		end if
	End if
Next

DESTROY luo_data

dw_therapies.last_page = 0
dw_therapies.set_page(1, pb_up, pb_down, st_page)

If (list_user_id = current_user.user_id or current_user.check_privilege("Common Treatment Lists")) Then
	cb_sort.visible = True
	cb_composite.visible = True
Else
	cb_sort.visible = False
	cb_composite.visible = False
End if


end subroutine

public function str_attributes get_treatment_attributes (long pl_row);String		ls_treatment_type,ls_treatment_desc
Long			ll_rows
Integer		i
long ll_rowcount
string ls_find
long ll_row
str_attributes lstr_attributes
string ls_attribute
string ls_value

ls_treatment_type = dw_therapies.object.treatment_type[pl_row]
ls_treatment_desc = dw_therapies.object.treatment_description[pl_row]
// Is treatment selected from pre-defined(old) list ..
If dw_therapies.object.update_flag[pl_row] = 0 Then
	ll_rowcount = treatment_attributes.rowcount()
	ls_find = "definition_id=" + string(dw_therapies.object.definition_id[pl_row])
	ll_row = treatment_attributes.find(ls_find, 1, ll_rowcount)
	DO WHILE ll_row > 0 and ll_row <= ll_rowcount
		ls_attribute = treatment_attributes.object.attribute[ll_row]
		ls_value = treatment_attributes.object.att_value[ll_row]
		
		f_attribute_add_attribute(lstr_attributes, ls_attribute, ls_value)

		ll_row = treatment_attributes.find(ls_find, ll_row + 1, ll_rowcount + 1)
	Loop
Else
	For i = 1 To upperbound(treatment_attr)
		If (treatment_attr[i].treatment_type = ls_treatment_type) And &
			(treatment_attr[i].item_description = ls_treatment_desc) Then
			lstr_attributes = f_attribute_arrays_to_str(treatment_attr[i].attribute_count, &
																		treatment_attr[i].attribute, &
																		treatment_attr[i].value )
			Exit
		End If
	Next
End If

Return lstr_attributes

end function

event open;call super::open;////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description:Loads the users/default treatments list 
//
// Created By:Mark																		Creation dt: 
//
// Modified By:Sumathi Chinnasamy													Modified On: 04/26/2000
////////////////////////////////////////////////////////////////////////////////////////////////////

String					ls_null, ls_in_office_flag, ls_temp
Boolean					lb_in_office
Long						i, ll_rows
// user defined
str_popup				popup
str_popup_return	popup_return
integer li_sts
long ll_menu_id

Setnull(ls_null)
popup_return.item_count = 0

service = message.powerobjectparm

title = current_patient.id_line()

if isnull(service.problem_id) then
	log.log(this, "open", "Null problem_id", 4)
	closewithreturn(this, popup_return)
	return
end if

li_sts = current_patient.assessments.assessment(assessment, service.problem_id)
if li_sts <= 0 then
	log.log(this, "open", "Error getting assessment object (" + string(service.problem_id) + ")", 4)
	closewithreturn(this, popup_return)
	return
end if

st_assessment.text = f_assessment_description(assessment)
if len(st_assessment.text) > 70 then st_assessment.textsize = -12

// Don't offer the "I'll Be Back" option for manual services
if service.manual_service then
	cb_be_back.visible = false
	max_buttons = 3
end if

single_treatment_list_id = service.get_attribute("single_treatment_list_id")
if isnull(single_treatment_list_id) then single_treatment_list_id = "SINGLE"

composite_treatment_list_id = service.get_attribute("composite_treatment_list_id")
if isnull(composite_treatment_list_id) then composite_treatment_list_id = "!COMPOSITE"

ll_menu_id = long(service.get_attribute("menu_id"))
paint_menu(ll_menu_id)

service.get_attribute("mode", mode)
if isnull(mode) then
	if isnull(current_patient.open_encounter) then
		mode = "PAST"
	else
		if current_patient.open_encounter.encounter_status = "CLOSED" &
		  Or Not isnull(assessment.end_date) then
			mode = "PAST"
		else
			mode = "NEW"
		end if
	end if
end if

service.get_attribute("assessment_begin_date", assessment_begin_date)
if isnull(assessment_begin_date) then assessment_begin_date = date(assessment.begin_date)

service.get_attribute("assessment_end_date", assessment_end_date)
if isnull(assessment_end_date) then assessment_end_date = date(assessment.end_date)

efficacy = CREATE u_ds_data
efficacy.set_dataobject("dw_r_assessment_treatment_efficacy")
ll_rows = efficacy.retrieve(assessment.assessment_id)

// Either specialty or common list
common_list_id = current_user.common_list_id()
formulary = CREATE u_ds_data
formulary.set_dataobject("dw_sp_assessment_treatment_formulary")
ll_rows = formulary.retrieve(current_patient.cpr_id, assessment.assessment_id)

// this dw is used to hold all the treatments attr of trts list
treatment_attributes = CREATE u_ds_data
treatment_attributes.set_dataobject("dw_treatment_attribs_by_assessment")

// If the user came in as past history, or the assessment is closed, then only
// allow history treatments
If mode = "PAST" Then
	cb_new_past.text = "History"
	cb_new_past.enabled = False
Else
	cb_new_past.text = "New"
	cb_new_past.enabled = True
End if

dw_therapies.Settransobject(SQLCA)
set_user_list()
If dw_therapies.rowcount() = 0 Then
	set_default_list()
End if

If f_string_to_boolean(datalist.get_preference("PREFERENCES", "update_treatment_list")) Then
	default_update_flag = 2
Else
	default_update_flag = 1
End if

f_attribute_add_attribute(state_attributes, "problem_id", string(service.problem_id))

end event

on w_pick_new_treatment.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.cb_done=create cb_done
this.cb_be_back=create cb_be_back
this.st_page=create st_page
this.pb_up=create pb_up
this.pb_down=create pb_down
this.cb_sort=create cb_sort
this.st_1=create st_1
this.cb_composite=create cb_composite
this.cb_new_treatment=create cb_new_treatment
this.cb_new_past=create cb_new_past
this.cb_which_list=create cb_which_list
this.dw_therapies=create dw_therapies
this.st_assessment=create st_assessment
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.cb_done
this.Control[iCurrent+3]=this.cb_be_back
this.Control[iCurrent+4]=this.st_page
this.Control[iCurrent+5]=this.pb_up
this.Control[iCurrent+6]=this.pb_down
this.Control[iCurrent+7]=this.cb_sort
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.cb_composite
this.Control[iCurrent+10]=this.cb_new_treatment
this.Control[iCurrent+11]=this.cb_new_past
this.Control[iCurrent+12]=this.cb_which_list
this.Control[iCurrent+13]=this.dw_therapies
this.Control[iCurrent+14]=this.st_assessment
end on

on w_pick_new_treatment.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.cb_done)
destroy(this.cb_be_back)
destroy(this.st_page)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.cb_sort)
destroy(this.st_1)
destroy(this.cb_composite)
destroy(this.cb_new_treatment)
destroy(this.cb_new_past)
destroy(this.cb_which_list)
destroy(this.dw_therapies)
destroy(this.st_assessment)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_pick_new_treatment
boolean visible = true
integer x = 2647
integer y = 124
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_pick_new_treatment
end type

type cb_cancel from commandbutton within w_pick_new_treatment
integer x = 1961
integer y = 1604
integer width = 443
integer height = 108
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 1
popup_return.items[1] = "CANCEL"
closewithreturn(parent, popup_return)


end event

type cb_done from commandbutton within w_pick_new_treatment
integer x = 2427
integer y = 1604
integer width = 443
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
end type

event clicked;//////////////////////////////////////////////////////////////////////////////////////////////
//
// Description:Load only selected treatments into p_treatment_item and update
// 				u_assessment_treat_definition when update_flag is set.
//             
//					update_flag = 2 (add in trts list)
//             update_flag = 1 (new trt not selected for ordering but update in trt list)
//             update_flag = 0 (trt selected from predefined trts list)
//             update_flag = -1 (child trts marked for delete)
//
// Created By:Mark														Creation dt: 
//
// Modified By:Sumathi Chinnasamy									Creation dt: 03/10/2000
//////////////////////////////////////////////////////////////////////////////////////////////

Long			ll_rowcount, ll_find, ll_count
String		ls_find,ls_treatment_type
long i, j
integer li_index
long ll_definition_id
long ll_row
str_popup_return popup_return

dw_therapies.Setredraw(False)
// First put all the treatments in the primary buffer
dw_therapies.Setfilter("")
dw_therapies.Filter()

// Then create treatments for all the items selected
// child items of referral & followup are set with child_flag = 'F' or 'R'
ls_find = "selected_flag=1 and update_flag>=0"
ll_rowcount = dw_therapies.rowcount()
ll_find = dw_therapies.find(ls_find, 1, ll_rowcount)

// Issue # 5343 Changes loop conditions to try and prevent duplicate treatments
DO WHILE ll_find > 0 and ll_find <= ll_rowcount
	If dw_therapies.object.treatment_type[ll_find] <> "!COMPOSITE" Then
		new_treatment_item(ll_find)
	End If
	ll_find = dw_therapies.find(ls_find, ll_find + 1, ll_rowcount + 1)
LOOP

// delete the temporary and deleted ones
FOR ll_count = ll_rowcount to 1 Step -1
	If dw_therapies.object.update_flag[ll_count] = 1 Then
		dw_therapies.deleterow(ll_count)
	ElseIf dw_therapies.object.update_flag[ll_count] < 0 Then
		dw_therapies.deleterow(ll_count)
	ElseIf dw_therapies.object.update_flag[ll_count] = 2 Then 
		// new trt not selected for ordering, but for update in trt list
		// find it's treatment attr array index to update in attr table
		dw_therapies.object.update_flag[ll_count] = find_attribute_index(ll_count)
	End If
NEXT

dw_therapies.Update()
//dw_therapies.Setredraw(True)

// Now save the attributes
for i = 1 to dw_therapies.rowcount()
	li_index = dw_therapies.object.update_flag[i]
	if li_index <= 0 or isnull(li_index) then continue
	ll_definition_id = dw_therapies.object.definition_id[i]
	for j = 1 to treatment_attr[li_index].attribute_count
		ll_row = treatment_attributes.insertrow(0)
		treatment_attributes.object.definition_id[ll_row] = ll_definition_id
		treatment_attributes.object.attribute[ll_row] = treatment_attr[li_index].attribute[j]
		if len(treatment_attr[li_index].value[j]) > 255 then
			treatment_attributes.object.long_value[ll_row] = treatment_attr[li_index].value[j]
		else
			treatment_attributes.object.value[ll_row] = treatment_attr[li_index].value[j]
		end if
	next
next
treatment_attributes.update()

popup_return.item_count = 1
popup_return.items[1] = "OK"
Closewithreturn(parent, popup_return)


end event

type cb_be_back from commandbutton within w_pick_new_treatment
integer x = 1495
integer y = 1604
integer width = 443
integer height = 108
integer taborder = 50
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

type st_page from statictext within w_pick_new_treatment
integer x = 2139
integer y = 104
integer width = 338
integer height = 64
integer textsize = -10
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

type pb_up from u_picture_button within w_pick_new_treatment
integer x = 1993
integer y = 100
integer width = 137
integer height = 116
integer taborder = 80
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;string ls_temp
integer li_page

li_page = dw_therapies.current_page

dw_therapies.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from u_picture_button within w_pick_new_treatment
integer x = 1993
integer y = 228
integer width = 137
integer height = 116
integer taborder = 100
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;string ls_temp
integer li_page
integer li_last_page

li_page = dw_therapies.current_page
li_last_page = dw_therapies.last_page

dw_therapies.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type cb_sort from commandbutton within w_pick_new_treatment
integer x = 2565
integer y = 1464
integer width = 238
integer height = 92
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Sort..."
end type

event clicked;str_popup popup


clear_all_selected()

popup.title = st_assessment.text
popup.objectparm = dw_therapies

openwithparm(w_sort_treatment_list, popup)

clear_all_selected()

end event

type st_1 from statictext within w_pick_new_treatment
integer x = 2185
integer y = 752
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

type cb_composite from commandbutton within w_pick_new_treatment
integer x = 2034
integer y = 568
integer width = 786
integer height = 108
integer taborder = 90
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Composite Treatment"
end type

event clicked;////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description: Order 'COMPOSITE' treatments
//
//
//
// Created By:Sumathi Chinnasamy													Created On: 05/08/2000
////////////////////////////////////////////////////////////////////////////////////////////////////

String				ls_description, ls_treatment_type
String 				ls_instructions,ls_icon
Long					ll_treatment_sequence,ll_null,ll_row
// user defined
str_popup			popup
str_popup_return	popup_return
datetime ldt_begin_date
datetime ldt_end_date
long ll_open_encounter_id
integer li_sts

Setnull(ll_null)

ls_treatment_type = "!COMPOSITE"

popup.title = "Enter composite treatment description"
popup.displaycolumn = 255
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if len(popup_return.items[1]) > 255 then
	openwithparm(w_pop_message, "The description for an item in a treatment list cannot exceed 255 characters.  The description has been truncated.")
	popup_return.items[1] = left(popup_return.items[1], 255)
end if

ls_description = popup_return.items[1]
ls_icon = "iconcomposite.bmp"

if mode = "PAST" then
	ldt_begin_date = datetime(assessment_begin_date, time(""))
	ldt_end_date = datetime(assessment_end_date, time(""))
	ll_open_encounter_id = current_patient.open_encounter_id
	
	li_sts = f_get_treatment_dates(ls_treatment_type, ls_description, ll_open_encounter_id, ldt_begin_date, ldt_end_date)
else
	setnull(ll_open_encounter_id)
	setnull(ldt_begin_date)
	setnull(ldt_end_date)
end if

ll_row = dw_therapies.Insertrow(0)
dw_therapies.object.user_id[ll_row]                   = list_user_id
dw_therapies.object.assessment_id[ll_row]			    	= assessment.assessment_id
dw_therapies.object.treatment_type[ll_row]				= ls_treatment_type
dw_therapies.object.treatment_description[ll_row] 		= ls_description
dw_therapies.object.parent_definition_id[ll_row]      = ll_null
dw_therapies.object.sort_sequence[ll_row] 				= ll_row 
dw_therapies.object.selected_flag[ll_row]             = 1
dw_therapies.object.update_flag[ll_row]               = 0
dw_therapies.object.icon[ll_row]                      = ls_icon	
dw_therapies.object.instructions[ll_row]              = ls_instructions

dw_therapies.object.open_encounter_id[ll_row] = ll_open_encounter_id
dw_therapies.object.onset[ll_row] = ldt_begin_date
dw_therapies.object.duration[ll_row] = ldt_end_date

dw_therapies.Scrolltorow(ll_row)

ll_treatment_sequence = save_assessment_treatment(ll_row)

dw_therapies.last_page = 0
dw_therapies.set_page(1, st_page.text)
if dw_therapies.last_page < 2 then
	pb_up.visible = false
	pb_down.visible = false
else
	pb_up.visible = true
	pb_down.visible = true
	pb_up.enabled = true
	pb_down.enabled = true
end if
dw_therapies.set_page(dw_therapies.last_page, st_page.text)

dw_therapies.EVENT TRIGGER Selected(ll_row)


end event

type cb_new_treatment from commandbutton within w_pick_new_treatment
integer x = 2034
integer y = 416
integer width = 786
integer height = 108
integer taborder = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Treatment"
end type

event clicked;call super::clicked;////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description: Load selected treatments from different treatment types into datawindow.
//
//
// Created By:Sumathi Chinnasamy													Created On: 03/10/2000
////////////////////////////////////////////////////////////////////////////////////////////////////

String	ls_treatment_type,ls_icon,ls_description
Integer	li_return,li_tr_count = 1,li_attr_count
Integer  li_max,li_null,li_array_count
Long     ll_row,ll_find,ll_rowcount
integer li_sort_sequence
string ls_treatment_key
integer li_sts
string ls_find
datetime ldt_begin_date
datetime ldt_end_date
string ls_treatment_description
long ll_open_encounter_id
long ll_attribute_count
long i
boolean lb_found

Setnull(li_null)
// User defined types
u_component_treatment	luo_treatment
str_item_definition     lstr_treatments

ll_rowcount = dw_therapies.rowcount()
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
		li_array_count = Upperbound(treatment_attr)
		li_max = Upperbound(luo_treatment.treatment_definition)
		If li_max <= 0 Then GOTO destroyobj
		// Loop thru all selected treatments and insert them into datawindow
		Do While li_tr_count <= li_max
			ls_description = luo_treatment.treatment_definition[li_tr_count].item_description
			if len(ls_description) > 255 then
//				openwithparm(w_pop_message, "The description for an item in a treatment list cannot exceed 255 characters.  The description has been truncated.")
				ll_attribute_count = luo_treatment.treatment_definition[li_tr_count].attribute_count
				lb_found = false
				for i = 1 to ll_attribute_count
					if lower(luo_treatment.treatment_definition[li_tr_count].attribute[ll_attribute_count]) = "treatment_description" then
						luo_treatment.treatment_definition[li_tr_count].value[ll_attribute_count] = ls_description
					end if
				next
				if not lb_found then
					ll_attribute_count += 1
					luo_treatment.treatment_definition[li_tr_count].attribute[ll_attribute_count] = "treatment_description"
					luo_treatment.treatment_definition[li_tr_count].value[ll_attribute_count] = ls_description
					luo_treatment.treatment_definition[li_tr_count].attribute_count = ll_attribute_count
				end if
				
				ls_description = left(ls_description, 252) + "..."
			end if
			
			ls_icon = datalist.treatment_type_icon(ls_treatment_type)

			ll_row = dw_therapies.Insertrow(0)
			if ll_row <= 1 then
				setnull(li_sort_sequence)
			else
				li_sort_sequence = dw_therapies.object.sort_sequence[ll_row - 1]
				if not isnull(li_sort_sequence) then li_sort_sequence += 1
			end if
			
			dw_therapies.object.user_id[ll_row]                   = list_user_id
			dw_therapies.object.assessment_id[ll_row]			    	= assessment.assessment_id
			dw_therapies.object.treatment_type[ll_row]				= ls_treatment_type
			dw_therapies.object.treatment_description[ll_row] 		= ls_description
			dw_therapies.object.parent_definition_id[ll_row]      = li_null//used for child treatments
			dw_therapies.object.sort_sequence[ll_row] 				= li_sort_sequence 
			dw_therapies.object.selected_flag[ll_row]             = 1
			dw_therapies.object.update_flag[ll_row]               = update_flag
			dw_therapies.object.icon[ll_row]                      = ls_icon
			dw_therapies.object.type_sort_sequence[ll_row]			= datalist.treatment_type_sort_sequence(ls_treatment_type)
			dw_therapies.object.open_encounter_id[ll_row] = ll_open_encounter_id
			dw_therapies.object.onset[ll_row] = ldt_begin_date
			dw_therapies.object.duration[ll_row] = ldt_end_date
			li_array_count++
			treatment_attr[li_array_count] = luo_treatment.treatment_definition[li_tr_count]
			li_tr_count++
			
			ls_treatment_key = f_get_treatment_key(ls_treatment_type, &
																	  treatment_attr[li_array_count].attribute_count, &
																	  treatment_attr[li_array_count].attribute, &
																	  treatment_attr[li_array_count].value)
			
			dw_therapies.object.treatment_key[ll_row] = ls_treatment_key
			
			if not isnull(ls_treatment_key) then
				ls_find = "treatment_type='" + ls_treatment_type + "'"
				ls_find += " and treatment_key='" + ls_treatment_key + "'"
				ll_find = efficacy.find(ls_find, 1, efficacy.rowcount())
				if ll_find > 0 then
					dw_therapies.object.rating[ll_row] = efficacy.object.rating[ll_find]
				end if
				
				ll_find = formulary.find(ls_find, 1, formulary.rowcount())
				if ll_find > 0 then
					dw_therapies.object.formulary_icon[ll_row] = formulary.object.icon[ll_find]
				end if
			end if
		Loop
	End If
End If
destroyobj:
// Destroy the component
component_manager.destroy_component(luo_treatment)
// If rows have been added, then scroll to the end
If ll_rowcount < dw_therapies.rowcount() then
	dw_therapies.last_page = 0
	dw_therapies.set_page(1, st_page.text)
	If dw_therapies.last_page < 2 Then
		pb_up.visible = false
		pb_down.visible = false
	Else
		pb_up.visible = true
		pb_down.visible = true
		pb_up.enabled = true
		pb_down.enabled = true
	End If
	dw_therapies.set_page(dw_therapies.last_page, st_page.text)
End if

Return
end event

type cb_new_past from commandbutton within w_pick_new_treatment
integer x = 2185
integer y = 836
integer width = 485
integer height = 108
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "History"
end type

event clicked;clear_all_selected()

if mode = "PAST" then
	mode = "NEW"
	text = "New"
else
	mode = "PAST"
	text = "History"
end if


end event

type cb_which_list from commandbutton within w_pick_new_treatment
integer x = 2016
integer y = 1464
integer width = 498
integer height = 92
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Personal List"
end type

event clicked;str_popup_return popup_return

 DECLARE lsp_init_user_therapies PROCEDURE FOR dbo.sp_init_user_therapies  
         @ps_user_id = :current_user.user_id,   
         @ps_assessment_id = :assessment.assessment_id,
			@ps_common_list_id = :common_list_id;

if personal_list then
	set_default_list()
else
	set_user_list()
	if dw_therapies.rowcount() = 0 then
		openwithparm(w_pop_yes_no, "Your personal list is empty.  Do you wish to start with the defaults?")
		popup_return = message.powerobjectparm
		if popup_return.item = "YES" then
			EXECUTE lsp_init_user_therapies;
			if not tf_check() then return
			set_user_list()
		end if
	end if
end if

end event

type dw_therapies from u_dw_pick_list within w_pick_new_treatment
integer x = 14
integer y = 96
integer width = 1970
integer height = 1468
integer taborder = 70
string dataobject = "dw_assessment_treatments"
boolean border = false
end type

on constructor;call u_dw_pick_list::constructor;multiselect = true
end on

event selected;Integer					li_sts,li_count,i
Long						ll_treatment_sequence
// User Defined
str_popup				popup
str_item_definition 	lstr_treatments[]

If mode = "PAST" Then
	li_sts = get_past_info(selected_row)
	If li_sts <= 0 Then
		This.object.selected_flag[selected_row] = 0
		Return
	End If
End If
// if computed button is clicked then show options to delete
// composite treatment
if lasttype = 'compute' then
	return
end if
If dw_therapies.object.treatment_type[selected_row] = "!COMPOSITE" Then
	ll_treatment_sequence = object.definition_id[selected_row]

	popup.objectparm = assessment
	popup.objectparm1 = dw_therapies
	popup.objectparm2 = efficacy
	popup.objectparm3 = formulary
	popup.data_row_count = 3
	popup.items[1] = list_user_id
	popup.items[2] = String(ll_treatment_sequence)
	popup.items[3] = composite_treatment_list_id
	popup.title = object.treatment_description[selected_row]

	Openwithparm(w_pick_composite_treatments, popup)
	// Get the array of treatment structure
	popup = Message.powerobjectparm
	lstr_treatments = popup.anyparm
	li_sts = Upperbound(lstr_treatments)
	// Append in instance array
	li_count = Upperbound(treatment_attr)
	For i = 1 to li_sts
		li_count++
		treatment_attr[li_count] = lstr_treatments[i]
	Next
End If
end event

event unselected;call super::unselected;long ll_treatment_sequence
long ll_rows
long i
Integer					li_sts,li_count
// User Defined
str_popup				popup
str_item_definition 	lstr_treatments[]

// If the user unselected a composite treatment, then unselect all
// of its constituent treatments
if object.treatment_type[unselected_row] = "!COMPOSITE" then
	// For composites, turn back on the selected flag because we're managing
	// the selected flag from inside the popup window
	object.selected_flag[unselected_row] = 1
	ll_treatment_sequence = object.definition_id[unselected_row]

	popup.objectparm = assessment
	popup.objectparm1 = dw_therapies
	popup.objectparm2 = efficacy
	popup.objectparm3 = formulary
	popup.data_row_count = 3
	popup.items[1] = list_user_id
	popup.items[2] = String(ll_treatment_sequence)
	popup.items[3] = composite_treatment_list_id
	popup.title = object.treatment_description[unselected_row]

	Openwithparm(w_pick_composite_treatments, popup)
	// Get the array of treatment structure
	popup = Message.powerobjectparm
	lstr_treatments = popup.anyparm
	li_sts = Upperbound(lstr_treatments)
	// Append in instance array
	li_count = Upperbound(treatment_attr)
	For i = 1 to li_sts
		li_count++
		treatment_attr[li_count] = lstr_treatments[i]
	Next
end if	

end event

event computed_clicked;integer li_sts

if not lastselected then object.selected_flag[clicked_row] = 1

li_sts = edit_treatment_def(clicked_row)

if lastselected then object.selected_flag[clicked_row] = 0

end event

type st_assessment from statictext within w_pick_new_treatment
integer width = 2930
integer height = 96
integer textsize = -14
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

