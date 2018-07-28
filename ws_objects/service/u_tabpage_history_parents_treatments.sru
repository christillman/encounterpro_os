HA$PBExportHeader$u_tabpage_history_parents_treatments.sru
forward
global type u_tabpage_history_parents_treatments from u_tabpage_history_parents
end type
type dw_parents from u_dw_pick_list within u_tabpage_history_parents_treatments
end type
end forward

global type u_tabpage_history_parents_treatments from u_tabpage_history_parents
integer width = 1225
integer height = 1332
dw_parents dw_parents
end type
global u_tabpage_history_parents_treatments u_tabpage_history_parents_treatments

type variables
string observation_id
string observation_type
string treatment_type
long encounter_id


end variables

forward prototypes
public function integer initialize ()
public subroutine refresh ()
public subroutine history_clicked ()
public function integer load_treatments ()
public subroutine refresh_display (long pl_key)
end prototypes

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

setnull(encounter_id)
setnull(treatment_type)
observation_type = service.get_attribute("observation_type")
if isnull(observation_type) then
	treatment_type = service.get_attribute("treatment_type")
	if isnull(treatment_type) then
		if not isnull(current_service) then encounter_id = current_service.encounter_id
	end if
end if

if isnull(observation_type) and isnull(treatment_type) and isnull(encounter_id) then
	return 0
end if

return 1

end function

public subroutine refresh ();long ll_row
long ll_treatment_id
integer li_sts
string ls_find

dw_parents.width = width
dw_parents.height = height
dw_parents.object.t_background.width = width - 112

ll_row = dw_parents.get_selected_row()
if ll_row > 0 then
	ll_treatment_id = dw_parents.object.treatment_id[ll_row]
else
	setnull(ll_treatment_id)
end if

li_sts = load_treatments()
if li_sts <= 0 then return

if isnull(ll_treatment_id) then
	ll_row = 1
	ll_treatment_id = dw_parents.object.treatment_id[ll_row]
else
	ls_find = "treatment_id=" + string(ll_treatment_id)
	ll_row = dw_parents.find(ls_find, 1, dw_parents.rowcount())
end if

if ll_row > 0 then
	dw_parents.object.selected_flag[ll_row] = 1
	refresh_display(ll_treatment_id)
end if


end subroutine

public subroutine history_clicked ();str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons
string ls_user_id
integer li_update_flag
string ls_temp
string ls_description
string ls_null
long ll_null
str_attributes lstr_attributes
long ll_row
long ll_treatment_id
string ls_find
string ls_edit_service
string ls_comment_service
u_component_treatment luo_treatment
str_treatment_observation lstra_observations[]
long ll_root_idx
long ll_count
long i

ls_edit_service = tab_parents.default_edit_service
if isnull(ls_edit_service) then ls_edit_service = "EDIT_TREATMENT_RESULTS"

ls_comment_service = tab_parents.default_comment_service
if isnull(ls_comment_service) then ls_comment_service = "FREEHISTORY"

ll_row = dw_parents.get_selected_row()
if ll_row <= 0 then return

ll_treatment_id = dw_parents.object.treatment_id[ll_row]

setnull(ls_null)
setnull(ll_null)


if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Mark history as reviewed"
	popup.button_titles[popup.button_count] = "Reviewed"
	buttons[popup.button_count] = "REVIEWED"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit history"
	popup.button_titles[popup.button_count] = "Edit"
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
	CASE "REVIEWED"
		current_patient.treatments.set_treatment_progress(ll_treatment_id, "REVIEWED")
		dw_parents.object.reviewed_flag[ll_row] = 1
	CASE "EDIT"
		f_attribute_add_attribute(lstr_attributes, "treatment_id", string(ll_treatment_id))
		current_patient.treatments.treatment(luo_treatment,ll_treatment_id)
		service_list.do_service(current_patient.cpr_id, current_patient.open_encounter_id, ls_edit_service, luo_treatment,lstr_attributes)
		
		refresh_display(ll_treatment_id)
	CASE "COMMENTS"
		li_sts = current_patient.treatments.treatment(luo_treatment,ll_treatment_id)
		if li_sts <= 0 then
			log.log(this, "history_clicked()", "Error getting treatment object", 4)
			return
		end if

		// Add the treatment_id to the attributes
		f_attribute_add_attribute(lstr_attributes, "treatment_id", string(ll_treatment_id))
		
		// Then get a list of the roots
		ls_find = "isnull(parent_observation_sequence)"
		ll_count = luo_treatment.find_observations(ls_find, lstra_observations)

		// If we have any roots already then we want this comment to be tied to one of them
		if ll_count > 0 then
			if ll_count = 1 then
				// If there's only one root the use it
				ll_root_idx = 1
			else
				// If there's more than one root ask the user which one they want
				popup.data_row_count = ll_count
				for i = 1 to ll_count
					popup.items[i] = lstra_observations[i].observation_description
				next
				popup.title = "Which observation is this comment about?"
				openwithparm(w_pop_pick, popup)
				popup_return = message.powerobjectparm
				if popup_return.item_count <> 1 then return
				ll_root_idx = popup_return.item_indexes[1]
			end if
			// Add the observation_sequence
			f_attribute_add_attribute(lstr_attributes, "observation_sequence", string(lstra_observations[ll_root_idx].observation_sequence))
		end if
		
		service_list.do_service(current_patient.cpr_id, current_patient.open_encounter_id, ls_comment_service, luo_treatment,lstr_attributes)
		
		refresh_display(ll_treatment_id)
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return

end subroutine

public function integer load_treatments ();long ll_treatment_id
long ll_treatment_progress_sequence
integer li_sts
long ll_rows
long i
long ll_firstrow
string ls_find
str_treatment_description lstra_treatments[]
integer li_count
long ll_row
string ls_description
string ls_observed_by
string ls_reviewed

//CWW, BEGIN
u_ds_data luo_sp_get_treatment_observed_by
integer li_spdw_count
// DECLARE lsp_get_treatment_observed_by PROCEDURE FOR sp_get_treatment_observed_by  
//         @ps_cpr_id = :current_patient.cpr_id,   
//         @pl_treatment_id = :lstra_treatments[i].treatment_id,   
//         @pl_encounter_id = :service.encounter_id,   
//         @ps_user_id = :current_user.user_id,   
//         @ps_last_observed_by = :ls_observed_by OUT,   
//         @ps_reviewed = :ls_reviewed OUT ;
//CWW, END

if dw_parents.rowcount() > 0 then
	ll_firstrow = long(string(dw_parents.object.datawindow.firstrowonpage))
end if

dw_parents.reset()

if isnull(encounter_id) then return 0

ls_find = "observation_id='" + observation_id + "'"

li_count = current_patient.treatments.get_treatments(ls_find, lstra_treatments)
if li_count <= 0 then return li_count

for i = 1 to li_count
	ls_description = string(lstra_treatments[i].begin_date, date_format_string)
	
	//CWW, BEGIN
	//EXECUTE lsp_get_treatment_observed_by;
	//if not tf_check() then return -1
	//FETCH lsp_get_treatment_observed_by INTO :ls_observed_by, :ls_reviewed;
	//if not tf_check() then return -1
	//CLOSE lsp_get_treatment_observed_by;
	luo_sp_get_treatment_observed_by = CREATE u_ds_data
	luo_sp_get_treatment_observed_by.set_dataobject("dw_sp_get_treatment_observed_by")
	li_spdw_count = luo_sp_get_treatment_observed_by.retrieve(current_patient.cpr_id, lstra_treatments[i].treatment_id, &
																					service.encounter_id,current_user.user_id )
	if li_spdw_count <= 0 then
		setnull(ls_observed_by)
		setnull(ls_reviewed)
	else
		ls_observed_by = luo_sp_get_treatment_observed_by.object.last_observed_by[1]
		ls_reviewed = luo_sp_get_treatment_observed_by.object.reviewed[1]
	end if
	destroy luo_sp_get_treatment_observed_by
	//CWW, END

	
	if not isnull(ls_observed_by) then
		ls_description += " " + user_list.user_full_name(ls_observed_by)
	end if
	
	ll_row = dw_parents.insertrow(0)
	dw_parents.object.who_and_when[ll_row] = ls_description
	dw_parents.object.description[ll_row] = lstra_treatments[i].treatment_description
	dw_parents.object.treatment_id[ll_row] = lstra_treatments[i].treatment_id
	dw_parents.object.begin_date[ll_row] = lstra_treatments[i].begin_date
	if ls_reviewed = "Y" then
		dw_parents.object.reviewed_flag[i] = 1
	end if
next

dw_parents.sort()

if ll_firstrow > 0 then
	dw_parents.scrolltorow(ll_firstrow)
end if

return 1


end function

public subroutine refresh_display (long pl_key);long ll_count
str_treatment_description lstr_treatment
integer li_sts
u_ds_observation_results luo_results
str_pretty_results lstr_results

luo_results = CREATE u_ds_observation_results
luo_results.set_dataobject("dw_sp_obstree_treatment")
ll_count = luo_results.retrieve(current_patient.cpr_id, pl_key)

lstr_results = luo_results.get_pretty_results("PERFORM", tab_parents.abnormal_flag , 0)

tab_parents.refresh_display(lstr_results)

DESTROY luo_results

return 

end subroutine

on u_tabpage_history_parents_treatments.create
int iCurrent
call super::create
this.dw_parents=create dw_parents
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_parents
end on

on u_tabpage_history_parents_treatments.destroy
call super::destroy
destroy(this.dw_parents)
end on

type dw_parents from u_dw_pick_list within u_tabpage_history_parents_treatments
integer width = 1170
integer height = 1300
integer taborder = 10
string dataobject = "dw_history_parents_treatments"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;long ll_treatment_id

ll_treatment_id = object.treatment_id[selected_row]

refresh_display(ll_treatment_id)

end event

