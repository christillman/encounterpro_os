$PBExportHeader$u_tabpage_history_parents_patient.sru
forward
global type u_tabpage_history_parents_patient from u_tabpage_history_parents
end type
type dw_parents from u_dw_pick_list within u_tabpage_history_parents_patient
end type
end forward

global type u_tabpage_history_parents_patient from u_tabpage_history_parents
integer width = 1225
integer height = 1332
dw_parents dw_parents
end type
global u_tabpage_history_parents_patient u_tabpage_history_parents_patient

type variables
u_ds_observation_results results
string observation_id
string format

end variables

forward prototypes
public function integer load_observations ()
public function integer initialize ()
public subroutine refresh ()
public subroutine history_clicked ()
public subroutine edit_history (long pl_row, string ps_service, u_component_treatment puo_treatment)
public subroutine set_reviewed (long pl_row, u_component_treatment puo_treatment, string ps_progress_note)
public subroutine refresh_display (long pl_key)
end prototypes

public function integer load_observations ();string ls_find
long ll_root
long ll_row
long ll_parent_history_sequence
long ll_history_sequence
string ls_observation_id
string ls_description
long ll_parent_row
long ll_result_count
long ll_last_nonempty_row
long ll_last_row_on_page
string ls_abnormal_flag
integer li_sort_sequence
string ls_edit_service

dw_parents.reset()
ll_last_nonempty_row = 0

ll_result_count = results.retrieve(current_patient.cpr_id, observation_id)
if ll_result_count < 0 then return -1

if ll_result_count = 0 then return 0

ls_find = "lower(record_type)='root'"
ll_root = results.find(ls_find, 1, ll_result_count)
if ll_root <= 0 then
	log.log(this, "u_tabpage_history_parents_patient.load_observations.0027", "root result not found", 4)
	return -1
end if

// First add the "Root" observation
ls_observation_id = results.object.observation_id[ll_root]
ll_parent_row = dw_parents.insertrow(0)
dw_parents.object.observation_id[ll_parent_row] = ls_observation_id
dw_parents.object.root_history_sequence[ll_parent_row] = results.object.history_sequence[ll_root]
dw_parents.object.description[ll_parent_row] = "<All " + datalist.observation_description(ls_observation_id) + ">"
dw_parents.object.history_sequence[ll_parent_row] = results.object.history_sequence[ll_root]
dw_parents.object.sort_sequence[ll_parent_row] = results.object.sort_sequence[ll_root]
dw_parents.object.edit_service[ll_parent_row] = results.object.edit_service[ll_root]

ls_abnormal_flag = results.abnormal_flag(ll_root)
dw_parents.object.abnormal_flag[ll_parent_row] = ls_abnormal_flag
if not isnull(ls_abnormal_flag) then
	dw_parents.object.in_use_flag[ll_parent_row] = 1
end if


ll_parent_history_sequence = results.object.history_sequence[ll_root]
ls_find = "parent_history_sequence=" + string(ll_parent_history_sequence)
ls_find += " and lower(record_type)='observation'"
ll_row = results.find(ls_find, 1, ll_result_count)
DO WHILE ll_row > 0 and ll_row <= ll_result_count
	ls_observation_id = results.object.observation_id[ll_row]
	ls_description = results.object.observation_description[ll_row]
	ll_history_sequence = results.object.history_sequence[ll_row]
	li_sort_sequence = results.object.sort_sequence[ll_row]
	ls_edit_service = results.object.edit_service[ll_row]

	ll_parent_row = dw_parents.insertrow(0)
	dw_parents.object.observation_id[ll_parent_row] = ls_observation_id
	dw_parents.object.root_history_sequence[ll_parent_row] = ll_history_sequence
	dw_parents.object.description[ll_parent_row] = ls_description
	dw_parents.object.history_sequence[ll_parent_row] = ll_history_sequence
	dw_parents.object.sort_sequence[ll_parent_row] = li_sort_sequence
	dw_parents.object.edit_service[ll_parent_row] = ls_edit_service
	
	ls_abnormal_flag = results.abnormal_flag(ll_row)
	dw_parents.object.abnormal_flag[ll_parent_row] = ls_abnormal_flag
	if not isnull(ls_abnormal_flag) then
		dw_parents.object.in_use_flag[ll_parent_row] = 1
	end if

	ll_row = results.find(ls_find, ll_row + 1, ll_result_count + 1)
LOOP

dw_parents.sort()

//dw_parents.last_page = 0
//dw_parents.set_page(1, pb_up,pb_down,st_page)

return 1

end function

public function integer initialize ();string ls_dataobject
integer li_sts
long ll_row
string ls_find

dw_parents.width = width
dw_parents.height = height

observation_id = service.root_observation_id()
if isnull(observation_id) then
	return -1
end if

format = service.get_attribute("format")
if isnull(format) then format = "fontsize=10,left,margin=0/2200/0"

ls_dataobject = service.get_attribute("dataobject")
if isnull(ls_dataobject) then ls_dataobject = "dw_sp_obstree_patient"

results = CREATE u_ds_observation_results
results.set_dataobject(ls_dataobject, service.cprdb)

return 1

end function

public subroutine refresh ();long ll_root_history_sequence
long ll_row
string ls_find
integer li_sts
string ls_observation_id

dw_parents.width = width
dw_parents.height = height

dw_parents.setredraw(false)

dw_parents.object.description.width = width - 112

ll_row = dw_parents.get_selected_row()
if ll_row > 0 then
	// Save which root we're editing
	ls_observation_id = dw_parents.object.observation_id[ll_row]
else
	setnull(ls_observation_id)
end if

li_sts = load_observations()
if li_sts <= 0 then return

if isnull(ls_observation_id) then
	if dw_parents.rowcount() > 0 then
		ll_row = 1
	else
		ll_row = 0
	end if
else
	ls_find = "observation_id='" + ls_observation_id + "'"
	ll_row = dw_parents.find(ls_find, 1, dw_parents.rowcount())
end if

if ll_row > 0 then
	ll_root_history_sequence = dw_parents.object.root_history_sequence[ll_row]
	dw_parents.object.selected_flag[ll_row] = 1
else
	ll_root_history_sequence = 0
end if

dw_parents.setredraw(true)


refresh_display(ll_root_history_sequence)

end subroutine

public subroutine history_clicked ();string ls_find
str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons
string ls_null
long ll_null
long ll_row
long ll_treatment_id
string ls_edit_service
string ls_comment_service
string ls_observation_id
u_component_treatment luo_treatment
string ls_status
long ll_root_history_sequence
string ls_progress
boolean lb_my_treatment
string ls_reviewed_progress_note

setnull(ls_null)
setnull(ll_null)

ll_row = dw_parents.get_selected_row()
if ll_row <= 0 then return

ls_edit_service = dw_parents.object.edit_service[ll_row]
if isnull(ls_edit_service) then ls_edit_service = tab_parents.default_edit_service
if isnull(ls_edit_service) then ls_edit_service = "EDIT_TREATMENT_RESULTS"

ls_comment_service = tab_parents.default_comment_service
if isnull(ls_comment_service) then ls_comment_service = "FREEHISTORY"

// Save which root we're editing
ll_root_history_sequence = dw_parents.object.root_history_sequence[ll_row]


//if true then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button17.bmp"
//	popup.button_helps[popup.button_count] = "Mark history as reviewed"
//	popup.button_titles[popup.button_count] = "Reviewed"
//	buttons[popup.button_count] = "REVIEWED"
//end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Log all items as reviewed without making changes"
	popup.button_titles[popup.button_count] = "R'vwd No Changes"
	buttons[popup.button_count] = "REVIEWED"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Log all items as reviewed and record some changes"
	popup.button_titles[popup.button_count] = "R'vwd w/ Changes"
	buttons[popup.button_count] = "EDIT"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Enter new results"
	popup.button_titles[popup.button_count] = "New Results"
	buttons[popup.button_count] = "EDIT"
end if

if not isnull(ls_comment_service) then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Enter Comments"
	popup.button_titles[popup.button_count] = "Enter Comments"
	buttons[popup.button_count] = "COMMENTS"
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
	CASE "REVIEWED", "EDIT", "COMMENTS"

		// Get a treatment object
		ls_observation_id = dw_parents.object.observation_id[ll_row]
		lb_my_treatment = tab_parents.get_treatment(ls_observation_id, luo_treatment)
		if isnull(luo_treatment) then return
		
		
	
		if buttons[button_pressed] = "EDIT" then
			ls_reviewed_progress_note = service.get_attribute("reviewed_edit_progress_note")
			if isnull(ls_reviewed_progress_note) then ls_reviewed_progress_note = "Reviewed, With Changes"
		elseif buttons[button_pressed] = "COMMENTS" then
			ls_reviewed_progress_note = service.get_attribute("reviewed_comments_progress_note")
			if isnull(ls_reviewed_progress_note) then ls_reviewed_progress_note = "Reviewed, With Comments"
		else
			ls_reviewed_progress_note = service.get_attribute("reviewed_progress_note")
			if isnull(ls_reviewed_progress_note) then ls_reviewed_progress_note = "Reviewed, No Changes"
		end if
		
		// Copy the results
		set_reviewed(ll_row, luo_treatment, ls_reviewed_progress_note)
		
		// Edit the results
		if buttons[button_pressed] = "EDIT" then
			edit_history(ll_row, ls_edit_service, luo_treatment)
		end if
		
		// Edit the comments
		if buttons[button_pressed] = "COMMENTS" then
			edit_history(ll_row, ls_comment_service, luo_treatment)
		end if
		
		// if the treatment was created solely for this click, then let's close it (or cancel it if there were no results entered)
		if lb_my_treatment then
			if luo_treatment.any_results() or buttons[button_pressed] = "REVIEWED" then
				ls_status = "Closed"
				setnull(ls_progress)
			else
				ls_status = "Cancelled"
				ls_progress = "No Results"
			end if
			
			if isnull(luo_treatment.treatment_status) then 
				luo_treatment.add_progress(ls_status, ls_progress)
			else
				if ls_status = "Cancelled" and lower(luo_treatment.treatment_status) <> "cancelled" then
					luo_treatment.add_progress(ls_status, ls_progress)
				end if
			end if
		end if

//		// Now reload the datawindow and select the root we edited
//		dw_parents.setredraw(false)
//		load_observations()
//		ls_find = "root_history_sequence=" + string(ll_root_history_sequence)
//		ll_row = dw_parents.find(ls_find, 1, dw_parents.rowcount())
//		if ll_row > 0 then pick_row(ll_row)
//		dw_parents.setredraw(true)

	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

refresh()

return

end subroutine

public subroutine edit_history (long pl_row, string ps_service, u_component_treatment puo_treatment);str_attributes lstr_attributes
string ls_observation_id
integer li_sts
string ls_find
string ls_status


ls_observation_id = dw_parents.object.observation_id[pl_row]

f_attribute_add_attribute(lstr_attributes, "observation_id", ls_observation_id)
f_attribute_add_attribute(lstr_attributes, "display_context", "patient")

li_sts = service_list.do_service(current_patient.cpr_id, current_patient.open_encounter_id, ps_service, puo_treatment, lstr_attributes)

return

end subroutine

public subroutine set_reviewed (long pl_row, u_component_treatment puo_treatment, string ps_progress_note);str_attributes lstr_attributes
integer li_sts
long ll_root_history_sequence
string ls_find
string ls_status
long ll_parent_observation_sequence
integer li_child_ordinal
string ls_observation_tag
long ll_row
string ls_reviewed_progress_type
string ls_reviewed_progress_key

// Save which root we're editing
ll_root_history_sequence = dw_parents.object.root_history_sequence[pl_row]

setnull(ll_parent_observation_sequence)
li_child_ordinal = 1
setnull(ls_observation_tag)

ls_find = "history_sequence=" + string(ll_root_history_sequence)
ll_row = results.find(ls_find, 1, results.rowcount())
if ll_row > 0 then
	results.copy_results(ll_row, &
								tab_parents.abnormal_flag, &
								puo_treatment, &
								ll_parent_observation_sequence, &
								li_child_ordinal, &
								ls_observation_tag)
	
	ls_reviewed_progress_type = service.get_attribute("reviewed_progress_type")
	if isnull(ls_reviewed_progress_type) then ls_reviewed_progress_type = "Reviewed"
	
	ls_reviewed_progress_key = service.get_attribute("reviewed_progress_key")
	if isnull(ls_reviewed_progress_key) then ls_reviewed_progress_key = "Reviewed"

	puo_treatment.set_progress_key(ls_reviewed_progress_type, ls_reviewed_progress_key, ps_progress_note)

end if

return

end subroutine

public subroutine refresh_display (long pl_key);str_pretty_results lstr_results

lstr_results = results.get_pretty_results("PERFORM", tab_parents.abnormal_flag , pl_key)

tab_parents.refresh_display(lstr_results)


end subroutine

on u_tabpage_history_parents_patient.create
int iCurrent
call super::create
this.dw_parents=create dw_parents
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_parents
end on

on u_tabpage_history_parents_patient.destroy
call super::destroy
destroy(this.dw_parents)
end on

type dw_parents from u_dw_pick_list within u_tabpage_history_parents_patient
integer width = 1170
integer height = 1300
integer taborder = 10
string dataobject = "dw_parent_observation_list"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;long ll_root_history_sequence

ll_root_history_sequence = object.root_history_sequence[selected_row]

refresh_display(ll_root_history_sequence)

end event

