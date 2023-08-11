$PBExportHeader$w_composite_observation_definition.srw
forward
global type w_composite_observation_definition from w_window_base
end type
type st_observation_type from statictext within w_composite_observation_definition
end type
type st_obs_type_title from statictext within w_composite_observation_definition
end type
type cb_save from commandbutton within w_composite_observation_definition
end type
type cb_common_lists from commandbutton within w_composite_observation_definition
end type
type cb_add_observation from commandbutton within w_composite_observation_definition
end type
type dw_observations from u_dw_pick_list within w_composite_observation_definition
end type
type st_in_context_flag from statictext within w_composite_observation_definition
end type
type pb_cancel from u_picture_button within w_composite_observation_definition
end type
type sle_description from singlelineedit within w_composite_observation_definition
end type
type st_description_title from statictext within w_composite_observation_definition
end type
type st_collection_procedure from statictext within w_composite_observation_definition
end type
type st_perform_procedure from statictext within w_composite_observation_definition
end type
type pb_done from u_picture_button within w_composite_observation_definition
end type
type cb_get_phrase from commandbutton within w_composite_observation_definition
end type
type st_title_collection_procedure from statictext within w_composite_observation_definition
end type
type st_title_perform_procedure from statictext within w_composite_observation_definition
end type
type st_title_obseervation from statictext within w_composite_observation_definition
end type
type st_title_in_context from statictext within w_composite_observation_definition
end type
type cb_treatment_types from commandbutton within w_composite_observation_definition
end type
type cb_coding_elements from commandbutton within w_composite_observation_definition
end type
type cb_image from commandbutton within w_composite_observation_definition
end type
type cb_results from commandbutton within w_composite_observation_definition
end type
type st_perform_location_domain_title from statictext within w_composite_observation_definition
end type
type st_perform_location_domain from statictext within w_composite_observation_definition
end type
type pb_up from u_picture_button within w_composite_observation_definition
end type
type pb_down from u_picture_button within w_composite_observation_definition
end type
type st_page from statictext within w_composite_observation_definition
end type
type st_1 from statictext within w_composite_observation_definition
end type
type st_display_style from statictext within w_composite_observation_definition
end type
type cb_legal_notice from commandbutton within w_composite_observation_definition
end type
type st_title from statictext within w_composite_observation_definition
end type
type st_status from statictext within w_composite_observation_definition
end type
type st_2 from statictext within w_composite_observation_definition
end type
type st_observation_id from statictext within w_composite_observation_definition
end type
end forward

global type w_composite_observation_definition from w_window_base
boolean titlebar = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_observation_type st_observation_type
st_obs_type_title st_obs_type_title
cb_save cb_save
cb_common_lists cb_common_lists
cb_add_observation cb_add_observation
dw_observations dw_observations
st_in_context_flag st_in_context_flag
pb_cancel pb_cancel
sle_description sle_description
st_description_title st_description_title
st_collection_procedure st_collection_procedure
st_perform_procedure st_perform_procedure
pb_done pb_done
cb_get_phrase cb_get_phrase
st_title_collection_procedure st_title_collection_procedure
st_title_perform_procedure st_title_perform_procedure
st_title_obseervation st_title_obseervation
st_title_in_context st_title_in_context
cb_treatment_types cb_treatment_types
cb_coding_elements cb_coding_elements
cb_image cb_image
cb_results cb_results
st_perform_location_domain_title st_perform_location_domain_title
st_perform_location_domain st_perform_location_domain
pb_up pb_up
pb_down pb_down
st_page st_page
st_1 st_1
st_display_style st_display_style
cb_legal_notice cb_legal_notice
st_title st_title
st_status st_status
st_2 st_2
st_observation_id st_observation_id
end type
global w_composite_observation_definition w_composite_observation_definition

type variables
string observation_id
string collection_procedure_id
string perform_procedure_id
string collection_location_domain = "NA"
string perform_location_domain
long material_id

string in_context_flag

boolean allow_editing
boolean changed

integer max_loop_depth = 10

string observation_type
string display_style

string legal_notice

string status

end variables

forward prototypes
public function boolean loop_check (string ps_parent_observation_id, string ps_new_observation_id)
public subroutine change_location_domain ()
public subroutine edit_location_domain ()
private subroutine new_location_domain ()
public function integer load_children ()
public function integer load_observation (string ps_observation_id)
public function integer save_changes ()
public subroutine new_observation ()
public subroutine observation_menu (long pl_row)
end prototypes

public function boolean loop_check (string ps_parent_observation_id, string ps_new_observation_id);integer li_loop

// DECLARE lsp_observation_loop_check PROCEDURE FOR dbo.sp_observation_loop_check  
//         @ps_parent_observation_id = :ps_parent_observation_id,   
//         @ps_new_observation_id = :ps_new_observation_id,   
//         @pi_loop = :li_loop OUT ;
//
sqlca.sp_observation_loop_check(ps_parent_observation_id, ps_new_observation_id, ref li_loop);
//EXECUTE lsp_observation_loop_check;
if not tf_check() then return true

//FETCH lsp_observation_loop_check INTO :li_loop;
//if not tf_check() then return true
//
//CLOSE lsp_observation_loop_check;
//
if li_loop = 0 then
	return false
else
	return true
end if


end function

public subroutine change_location_domain ();str_popup_return popup_return

open(w_pick_location_domain)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

perform_location_domain = popup_return.items[1]
st_perform_location_domain.text = popup_return.descriptions[1]

changed = true

end subroutine

public subroutine edit_location_domain ();str_popup popup

popup.data_row_count = 1
popup.items[1] = perform_location_domain
openwithparm(w_location_domain_edit, popup)

datalist.clear_cache("locations")

end subroutine

private subroutine new_location_domain ();str_popup popup
str_popup_return popup_return
long ll_next_key
integer li_sts
string ls_location_domain

// DECLARE lsp_new_location_domain PROCEDURE FOR dbo.sp_new_location_domain  
//         @ps_location_domain = :ls_location_domain OUT,   
//         @ps_description = :popup_return.item  ;
//
popup.item = "Enter New Location Domain:"
openwithparm(w_pop_get_string, popup)
popup_return = message.powerobjectparm
if isnull(popup_return.item) or popup_return.item = "" then return

sqlca.sp_new_location_domain(ref ls_location_domain, popup_return.item);
//EXECUTE lsp_new_location_domain;
if not tf_check() then return

//FETCH lsp_new_location_domain INTO :ls_location_domain;
//if not tf_check() then return
//
//CLOSE lsp_new_location_domain;

changed = true

perform_location_domain = ls_location_domain

edit_location_domain()

end subroutine

public function integer load_children ();dw_observations.retrieve(observation_id)

dw_observations.set_page(1, pb_up, pb_down, st_page)

return 1

end function

public function integer load_observation (string ps_observation_id);integer li_sts
string ls_description
string ls_collection_procedure_id
string ls_perform_procedure_id
string ls_perform_location_domain
string ls_collection_location_domain
string ls_type_description
string ls_cat_description
string ls_procedure_description
decimal ldc_charge
string ls_cpt_code
string ls_category_id
string ls_exclusive_flag
string ls_in_context_flag

SELECT description,
		collection_procedure_id,
		perform_procedure_id,
		perform_location_domain,
		in_context_flag,
		observation_type,
		display_style,
		material_id,
		legal_notice,
		status
INTO	:ls_description,
		:ls_collection_procedure_id,
		:ls_perform_procedure_id,
		:perform_location_domain,
		:in_context_flag,
		:observation_type,
		:display_style,
		:material_id,
		:legal_notice,
		:status
FROM c_Observation
WHERE observation_id = :ps_observation_id;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then
	setnull(observation_id)
	return 0
end if

st_observation_id.text = ps_observation_id
observation_id = ps_observation_id
sle_description.text = ls_description
st_display_style.text = display_style

if not isnull(ls_collection_procedure_id) then
	li_sts = tf_get_procedure_detail(ls_collection_procedure_id, &
												ls_procedure_description, &
												ls_cpt_code, &
												ls_category_id, &
												ls_cat_description, &
												ldc_charge)
	if li_sts < 0 then return li_sts
	if li_sts = 0 then
		log.log(this, "w_composite_observation_definition.load_observation:0058", "Invalid collection procedure id (" + ps_observation_id + &
														", " + ls_collection_procedure_id + ")", 4)
		setnull(collection_procedure_id)
		st_collection_procedure.text = "N/A"
	else
		collection_procedure_id = ls_collection_procedure_id
		st_collection_procedure.text = ls_procedure_description + " (" + ls_cpt_code + ")"
	end if
else
	setnull(collection_procedure_id)
	st_collection_procedure.text = "N/A"
end if

if not isnull(ls_perform_procedure_id) then
	li_sts = tf_get_procedure_detail(ls_perform_procedure_id, &
												ls_procedure_description, &
												ls_cpt_code, &
												ls_category_id, &
												ls_cat_description, &
												ldc_charge)
	if li_sts < 0 then return li_sts
	if li_sts = 0 then
		log.log(this, "w_composite_observation_definition.load_observation:0080", "Invalid perform procedure id (" + ps_observation_id + &
														", " + ls_perform_procedure_id + ")", 4)
		setnull(perform_procedure_id)
		st_perform_procedure.text = "N/A"
	else
		perform_procedure_id = ls_perform_procedure_id
		st_perform_procedure.text = ls_procedure_description + " (" + ls_cpt_code + ")"
	end if
else
	setnull(perform_procedure_id)
	st_perform_procedure.text = "N/A"
end if

if status = "OK" then
	st_status.text = "Active"
else
	st_status.text = "Inactive"
end if

if in_context_flag = "Y" then
	st_in_context_flag.text = "Yes"
else
	st_in_context_flag.text = "No"
end if

if perform_location_domain = "NA" then
	st_perform_location_domain.text = "N/A"
else
	SELECT description
	INTO :ls_description
	FROM c_Location_Domain
	WHERE location_domain = :perform_location_domain;
	if not tf_check() then return -1
	
	st_perform_location_domain.text = ls_description
end if

st_observation_type.text = observation_type

if isnull(material_id) then
	cb_image.weight = 400
else
	cb_image.weight = 700
end if

if len(legal_notice) > 0 then
	cb_legal_notice.weight = 700
else
	cb_legal_notice.weight = 400
end if

changed = false

li_sts = load_children()
if li_sts < 0 then return -1

if allow_editing then
	sle_description.enabled = true
	st_collection_procedure.enabled = true
	st_perform_procedure.enabled = true
	st_in_context_flag.enabled = true
	cb_add_observation.enabled = true
	cb_treatment_types.enabled = true
	cb_common_lists.enabled = true
	cb_save.visible = true
	st_perform_location_domain.enabled = true
else
	sle_description.enabled = false
	st_collection_procedure.enabled = false
	st_perform_procedure.enabled = false
	st_in_context_flag.enabled = false
	cb_add_observation.enabled = false
	cb_treatment_types.enabled = false
	cb_common_lists.enabled = false
	cb_save.visible = false
	st_perform_location_domain.enabled = false
end if

sle_description.setfocus()

return 1

end function

public function integer save_changes ();string ls_composite_flag
integer li_sts
long i
long ll_rowcount
string ls_collection_location_domain = "NA"
string ls_exclusive_flag = "N"
string ls_location_pick_flag = "N"
string ls_location_bill_flag = "N"
string ls_default_view
string ls_parent_obseravation_id

setnull(ls_default_view)

//CWW, BEGIN
u_ds_data luo_sp_new_observation
integer li_spdw_count
// DECLARE lsp_new_observation PROCEDURE FOR dbo.sp_new_observation  
//         @ps_observation_id = :observation_id OUT,   
//         @ps_collection_procedure_id = :collection_procedure_id,   
//         @ps_perform_procedure_id = :perform_procedure_id,   
//         @ps_perform_location_domain = :perform_location_domain,   
//         @ps_description = :sle_description.text,   
//         @ps_composite_flag = :ls_composite_flag,   
//         @ps_in_context_flag = :in_context_flag,
//			@ps_observation_type = :observation_type,
//			@ps_display_style = :display_style;
//CWW, END			

datalist.clear_cache("observations")

if isnull(display_style) or trim(display_style) = "" then
	setnull(display_style)
end if

ls_composite_flag = "Y"

if sle_description.text = "" or isnull(sle_description.text) then
	openwithparm(w_pop_message, "You must enter a description")
	return 0
end if

// First update the c_Observation table
if isnull(observation_id) then
	//CWW, BEGIN
//	EXECUTE lsp_new_observation;
//	if not tf_check() then return -1
//	FETCH lsp_new_observation INTO :observation_id;
//	if not tf_check() then return -1
//	CLOSE lsp_new_observation;
	
	luo_sp_new_observation = CREATE u_ds_data
	luo_sp_new_observation.set_dataobject("dw_sp_new_observation")
	li_spdw_count = luo_sp_new_observation.retrieve(collection_location_domain, &
																	perform_location_domain, &
																	collection_procedure_id, &
																	perform_procedure_id, &
																	sle_description.text, &
																	ls_composite_flag, &
																	"N", &
																	in_context_flag, & 
																	"N", &
																	"N", &
																	observation_type, &
																	"R", &
																	display_style)
	if li_spdw_count <= 0 then
		setnull(observation_id)
	else
		observation_id = luo_sp_new_observation.object.observation_id[1]
		st_observation_id.text = observation_id
	end if

	destroy luo_sp_new_observation	
	//CWW, END
	
	ll_rowcount = dw_observations.rowcount()
	for i = 1 to ll_rowcount
		dw_observations.object.parent_observation_id[i] = observation_id
	next
	
	if len(legal_notice) > 0 then
		UPDATE c_Observation
		SET legal_notice = :legal_notice
		WHERE observation_id = :observation_id;
		if not tf_check() then return -1
	end if
else
	sqlca.sp_update_observation( &
			observation_id, &
			ls_collection_location_domain, &
			perform_location_domain, &
			collection_procedure_id, &
			perform_procedure_id, &
			sle_description.text, &
			ls_composite_flag, &
			ls_exclusive_flag, &
			in_context_flag, &
			ls_location_pick_flag, &
			ls_location_bill_flag, &
			observation_type, &
			ls_default_view, &
			display_style, &
			status)

	if not tf_check() then return -1
end if

// Now update the c_Observation_Tree table
// sp_update_observation sets last_updated on c_Observation_Tree, so need to re-retrieve
// (Noticed bug in Ciru's o_log)
load_children()

// First, set the parent observation_id for any rows where it is missing
for i = 1 to dw_observations.rowcount()
	ls_parent_obseravation_id = dw_observations.object.parent_observation_id[i]
	if isnull(ls_parent_obseravation_id) then dw_observations.object.parent_observation_id[i] = observation_id
next

// Then save to the database
li_sts = dw_observations.update()
if li_sts < 0 then return -1

changed = false
cb_treatment_types.enabled = true
cb_common_lists.enabled = true

return 1
end function

public subroutine new_observation ();setnull(observation_id)
sle_description.text = ""

setnull(collection_procedure_id)
st_collection_procedure.text = "N/A"
setnull(perform_procedure_id)
st_perform_procedure.text = "N/A"

perform_location_domain = "NA"
st_perform_location_domain.text = "N/A"

in_context_flag = "N"
st_in_context_flag.text = "No"

st_observation_id.text = "<New Observation>"

if isnull(observation_type) then st_observation_type.postevent("clicked")

sle_description.setfocus()

changed = false

cb_treatment_types.enabled = false
cb_common_lists.enabled = false

display_style = "OBO|RRR|CBN"
st_display_style.text = display_style

status = "OK"

end subroutine

public subroutine observation_menu (long pl_row);str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons
string ls_user_id
integer li_update_flag
string ls_Observation_id
string ls_temp
string ls_composite_flag
string ls_description
string ls_child_description
string ls_null
str_observation_tree_branch lstr_branch

setnull(ls_null)

ls_composite_flag = dw_observations.object.composite_flag[pl_row]

if ls_composite_flag <> "Y" or isnull(ls_composite_flag) then
	if allow_editing then
		popup.button_count = popup.button_count + 1
		popup.button_icons[popup.button_count] = "button17.bmp"
		popup.button_helps[popup.button_count] = "Edit Observation"
		popup.button_titles[popup.button_count] = "Edit Observation"
		buttons[popup.button_count] = "EDIT"
	else
		popup.button_count = popup.button_count + 1
		popup.button_icons[popup.button_count] = "button17.bmp"
		popup.button_helps[popup.button_count] = "Display Observation"
		popup.button_titles[popup.button_count] = "Display Observation"
		buttons[popup.button_count] = "EDIT"
	end if
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit Constituent Observation Attributes"
	popup.button_titles[popup.button_count] = "Attributes"
	buttons[popup.button_count] = "ATTRIBUTES"
end if

if allow_editing then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Remove Observation"
	popup.button_titles[popup.button_count] = "Remove Observation"
	buttons[popup.button_count] = "REMOVE"
end if

if allow_editing then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonmove.bmp"
	popup.button_helps[popup.button_count] = "Move observation up or down in list"
	popup.button_titles[popup.button_count] = "Move"
	buttons[popup.button_count] = "MOVE"
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
		popup.data_row_count = 2
		popup.items[1] = dw_observations.object.child_observation_id[pl_row]
		popup.items[2] = f_boolean_to_string(allow_editing)
		
		openwithparm(w_observation_definition, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		
		dw_observations.object.child_observation_id[pl_row] = popup_return.items[1]
		dw_observations.object.child_observation_description[pl_row] = popup_return.descriptions[1]
	CASE "ATTRIBUTES"
		lstr_branch.branch_id = dw_observations.object.branch_id[pl_row]
		lstr_branch.parent_observation_id = observation_id
		lstr_branch.child_observation_id = dw_observations.object.child_observation_id[pl_row]
		lstr_branch.description = dw_observations.object.description[pl_row]
		lstr_branch.observation_tag = dw_observations.object.observation_tag[pl_row]
		lstr_branch.edit_service = dw_observations.object.edit_service[pl_row]
		lstr_branch.location = dw_observations.object.location[pl_row]
		lstr_branch.result_sequence = dw_observations.object.result_sequence[pl_row]
		lstr_branch.result_sequence_2 = dw_observations.object.result_sequence_2[pl_row]
		lstr_branch.followon_severity = dw_observations.object.followon_severity[pl_row]
		lstr_branch.followon_observation_id = dw_observations.object.followon_observation_id[pl_row]
		lstr_branch.on_results_entered = dw_observations.object.on_results_entered[pl_row]
		lstr_branch.unit_preference = dw_observations.object.unit_preference[pl_row]
		
		openwithparm(w_observation_tree_attributes, lstr_branch)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		if popup_return.items[1] <> "OK" then return
		
		lstr_branch = popup_return.returnobject
		
		// See if we should update the branch description
		ls_child_description = datalist.observation_description(lstr_branch.child_observation_id)
		if trim(ls_child_description) = trim(lstr_branch.description) then
			dw_observations.object.description[pl_row] = ls_null
		else
			dw_observations.object.description[pl_row] = lstr_branch.description
		end if
		dw_observations.object.observation_tag[pl_row] = lstr_branch.observation_tag
		dw_observations.object.edit_service[pl_row] = lstr_branch.edit_service
		dw_observations.object.location[pl_row] = lstr_branch.location
		dw_observations.object.result_sequence[pl_row] = lstr_branch.result_sequence
		dw_observations.object.result_sequence_2[pl_row] = lstr_branch.result_sequence_2
		dw_observations.object.followon_severity[pl_row] = lstr_branch.followon_severity
		dw_observations.object.followon_observation_id[pl_row] = lstr_branch.followon_observation_id
		dw_observations.object.on_results_entered[pl_row] = lstr_branch.on_results_entered
		dw_observations.object.unit_preference[pl_row] = lstr_branch.unit_preference
	CASE "REMOVE"
		ls_description = dw_observations.object.description[pl_row]
		if isnull(ls_description) then ls_description = dw_observations.object.child_observation_description[pl_row]
		ls_temp = "Remove " + ls_description + "?"
		openwithparm(w_pop_ok, ls_temp)
		if message.doubleparm = 1 then
			dw_observations.deleterow(pl_row)
			dw_observations.recalc_page(pb_up, pb_down, st_page)
		end if
	CASE "MOVE"
		popup.objectparm = dw_observations
		openwithparm(w_pick_list_sort, popup)
		dw_observations.set_buttons(pb_up, pb_down, st_page)
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return

end subroutine

event open;call super::open;str_popup popup
integer li_sts

popup = message.powerobjectparm

dw_observations.settransobject(sqlca)

max_loop_depth = datalist.get_preference_int("PREFERENCES", "max_observation_depth", 10)

setnull(legal_notice)

if popup.data_row_count = 2 then
	// Edit existing observation
	observation_id = popup.items[1]
	allow_editing = f_string_to_boolean(popup.items[2])
	li_sts = load_observation(observation_id)
elseif popup.data_row_count = 0 then
	// New observation
	allow_editing = true
	new_observation()
else
	log.log(this, "w_composite_observation_definition:open", "Invalid Parameters", 4)
	close(this)
	return
end if


end event

on w_composite_observation_definition.create
int iCurrent
call super::create
this.st_observation_type=create st_observation_type
this.st_obs_type_title=create st_obs_type_title
this.cb_save=create cb_save
this.cb_common_lists=create cb_common_lists
this.cb_add_observation=create cb_add_observation
this.dw_observations=create dw_observations
this.st_in_context_flag=create st_in_context_flag
this.pb_cancel=create pb_cancel
this.sle_description=create sle_description
this.st_description_title=create st_description_title
this.st_collection_procedure=create st_collection_procedure
this.st_perform_procedure=create st_perform_procedure
this.pb_done=create pb_done
this.cb_get_phrase=create cb_get_phrase
this.st_title_collection_procedure=create st_title_collection_procedure
this.st_title_perform_procedure=create st_title_perform_procedure
this.st_title_obseervation=create st_title_obseervation
this.st_title_in_context=create st_title_in_context
this.cb_treatment_types=create cb_treatment_types
this.cb_coding_elements=create cb_coding_elements
this.cb_image=create cb_image
this.cb_results=create cb_results
this.st_perform_location_domain_title=create st_perform_location_domain_title
this.st_perform_location_domain=create st_perform_location_domain
this.pb_up=create pb_up
this.pb_down=create pb_down
this.st_page=create st_page
this.st_1=create st_1
this.st_display_style=create st_display_style
this.cb_legal_notice=create cb_legal_notice
this.st_title=create st_title
this.st_status=create st_status
this.st_2=create st_2
this.st_observation_id=create st_observation_id
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_observation_type
this.Control[iCurrent+2]=this.st_obs_type_title
this.Control[iCurrent+3]=this.cb_save
this.Control[iCurrent+4]=this.cb_common_lists
this.Control[iCurrent+5]=this.cb_add_observation
this.Control[iCurrent+6]=this.dw_observations
this.Control[iCurrent+7]=this.st_in_context_flag
this.Control[iCurrent+8]=this.pb_cancel
this.Control[iCurrent+9]=this.sle_description
this.Control[iCurrent+10]=this.st_description_title
this.Control[iCurrent+11]=this.st_collection_procedure
this.Control[iCurrent+12]=this.st_perform_procedure
this.Control[iCurrent+13]=this.pb_done
this.Control[iCurrent+14]=this.cb_get_phrase
this.Control[iCurrent+15]=this.st_title_collection_procedure
this.Control[iCurrent+16]=this.st_title_perform_procedure
this.Control[iCurrent+17]=this.st_title_obseervation
this.Control[iCurrent+18]=this.st_title_in_context
this.Control[iCurrent+19]=this.cb_treatment_types
this.Control[iCurrent+20]=this.cb_coding_elements
this.Control[iCurrent+21]=this.cb_image
this.Control[iCurrent+22]=this.cb_results
this.Control[iCurrent+23]=this.st_perform_location_domain_title
this.Control[iCurrent+24]=this.st_perform_location_domain
this.Control[iCurrent+25]=this.pb_up
this.Control[iCurrent+26]=this.pb_down
this.Control[iCurrent+27]=this.st_page
this.Control[iCurrent+28]=this.st_1
this.Control[iCurrent+29]=this.st_display_style
this.Control[iCurrent+30]=this.cb_legal_notice
this.Control[iCurrent+31]=this.st_title
this.Control[iCurrent+32]=this.st_status
this.Control[iCurrent+33]=this.st_2
this.Control[iCurrent+34]=this.st_observation_id
end on

on w_composite_observation_definition.destroy
call super::destroy
destroy(this.st_observation_type)
destroy(this.st_obs_type_title)
destroy(this.cb_save)
destroy(this.cb_common_lists)
destroy(this.cb_add_observation)
destroy(this.dw_observations)
destroy(this.st_in_context_flag)
destroy(this.pb_cancel)
destroy(this.sle_description)
destroy(this.st_description_title)
destroy(this.st_collection_procedure)
destroy(this.st_perform_procedure)
destroy(this.pb_done)
destroy(this.cb_get_phrase)
destroy(this.st_title_collection_procedure)
destroy(this.st_title_perform_procedure)
destroy(this.st_title_obseervation)
destroy(this.st_title_in_context)
destroy(this.cb_treatment_types)
destroy(this.cb_coding_elements)
destroy(this.cb_image)
destroy(this.cb_results)
destroy(this.st_perform_location_domain_title)
destroy(this.st_perform_location_domain)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.st_page)
destroy(this.st_1)
destroy(this.st_display_style)
destroy(this.cb_legal_notice)
destroy(this.st_title)
destroy(this.st_status)
destroy(this.st_2)
destroy(this.st_observation_id)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_composite_observation_definition
boolean visible = true
integer x = 2670
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_composite_observation_definition
end type

type st_observation_type from statictext within w_composite_observation_definition
integer x = 2217
integer y = 156
integer width = 622
integer height = 104
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

popup.dataobject = "dw_observation_type_pick_list"
popup.datacolumn = 1
popup.displaycolumn = 1
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then
	// If the observation_type is null, then this is a new observation.
	// In that case, if the user cancels the observation_type selection,
	// then they've also cancelled the new observation
	if isnull(observation_type) then
		popup_return.item_count = 0
		closewithreturn(parent, popup_return)
	end if
	return
end if

observation_type = popup_return.items[1]
text = observation_type

changed = true

end event

type st_obs_type_title from statictext within w_composite_observation_definition
integer x = 1833
integer y = 176
integer width = 366
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Obs Type:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_save from commandbutton within w_composite_observation_definition
integer x = 1989
integer y = 1612
integer width = 288
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Save"
end type

event clicked;integer li_sts

if allow_editing then
	li_sts = save_changes()
	if li_sts <= 0 then return
end if

end event

type cb_common_lists from commandbutton within w_composite_observation_definition
integer x = 2391
integer y = 1288
integer width = 485
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Specialty List"
end type

event clicked;str_popup popup

popup.title = sle_description.text
popup.items[1] = observation_id
popup.data_row_count = 1

openwithparm(w_observation_common_lists, popup)

end event

type cb_add_observation from commandbutton within w_composite_observation_definition
integer x = 585
integer y = 1680
integer width = 530
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add Observation"
end type

event clicked;str_popup popup
str_picked_observations lstr_observations
string ls_observation_id
string ls_description
long ll_row
string ls_composite_flag
long i
string ls_treatment_type
w_pick_observations lw_pick

popup.data_row_count = 2
popup.title = "Select Constituents for '" + sle_description.text + "'"

SELECT min(treatment_type)
INTO :ls_treatment_type
FROM c_Observation_Treatment_Type
WHERE observation_id = :observation_id;
if not tf_check() then return

popup.multiselect = true
popup.items[1] = ls_treatment_type
popup.items[2] = current_user.specialty_id
openwithparm(lw_pick, popup, "w_pick_observations")
lstr_observations = message.powerobjectparm
if lstr_observations.observation_count < 1 then return

for i = 1 to lstr_observations.observation_count
	ls_observation_id = lstr_observations.observation_id[i]
	ls_description = lstr_observations.description[i]
	ls_composite_flag = datalist.observation_composite_flag(ls_observation_id)
	if isnull(ls_description) or isnull(ls_observation_id) then continue
	
	if ls_composite_flag = "Y" then
		if loop_check(observation_id, ls_observation_id) then
			openwithparm(w_pop_message, "Adding the observation '" + ls_description + "' would create a loop and is not allowed.")
			continue
		end if
	end if
	
	ll_row = dw_observations.insertrow(0)
	dw_observations.object.parent_observation_id[ll_row] = observation_id
	dw_observations.object.child_observation_id[ll_row] = ls_observation_id
	dw_observations.object.child_observation_description[ll_row] = ls_description
	dw_observations.object.composite_flag[ll_row] = ls_composite_flag
	dw_observations.object.sort_sequence[ll_row] = ll_row
next

dw_observations.recalc_page(pb_up, pb_down, st_page)


end event

type dw_observations from u_dw_pick_list within w_composite_observation_definition
integer x = 32
integer y = 476
integer width = 1833
integer height = 1196
integer taborder = 20
string dataobject = "dw_observation_tree_edit_list"
boolean border = false
end type

event selected;observation_menu(selected_row)
clear_selected()

end event

type st_in_context_flag from statictext within w_composite_observation_definition
integer x = 2217
integer y = 388
integer width = 169
integer height = 104
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

event clicked;if in_context_flag = "Y" then
	in_context_flag = "N"
	text = "No"
else
	in_context_flag = "Y"
	text = "Yes"
end if

changed = true

end event

type pb_cancel from u_picture_button within w_composite_observation_definition
integer x = 2322
integer y = 1560
integer taborder = 0
boolean bringtotop = true
boolean cancel = true
boolean originalsize = false
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

setnull(popup_return.item)
popup_return.item_count = 0
closewithreturn(parent, popup_return)


end event

type sle_description from singlelineedit within w_composite_observation_definition
integer x = 37
integer y = 236
integer width = 1769
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;changed = true

end event

type st_description_title from statictext within w_composite_observation_definition
integer x = 46
integer y = 152
integer width = 398
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Description:"
boolean focusrectangle = false
end type

type st_collection_procedure from statictext within w_composite_observation_definition
event clicked pbm_bnclicked
integer x = 1888
integer y = 576
integer width = 946
integer height = 124
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
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons
string ls_user_id
string ls_description
integer li_update_flag
string ls_cpt_code
decimal ldc_charge
str_picked_procedures lstr_procedures

if not isnull(collection_procedure_id) then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit Procedure Details"
	popup.button_titles[popup.button_count] = "Edit Procedure"
	buttons[popup.button_count] = "EDIT"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button05.bmp"
	popup.button_helps[popup.button_count] = "Change Procedure"
	popup.button_titles[popup.button_count] = "Change Procedure"
	buttons[popup.button_count] = "CHANGE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonx5.bmp"
	popup.button_helps[popup.button_count] = "Not Applicable"
	popup.button_titles[popup.button_count] = "N/A"
	buttons[popup.button_count] = "NA"
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
		popup.data_row_count = 2
		popup.items[1] = "TESTCOLLECT"
		popup.items[2] = collection_procedure_id
		openwithparm(w_procedure_definition, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 4 then return
		collection_procedure_id = popup_return.item
		text = popup_return.items[4] + " (" + popup_return.items[1] + ")"
	CASE "CHANGE"
		popup.data_row_count = 1
		popup.items[1] = "TESTCOLLECT"
		popup.multiselect = false
		openwithparm(w_pick_procedures, popup)
		lstr_procedures = message.powerobjectparm

		if lstr_procedures.procedure_count < 1 then return

		li_sts = tf_get_procedure_charge(lstr_procedures.procedures[1].procedure_id, ls_cpt_code, ldc_charge)
		if li_sts <= 0 then return
		collection_procedure_id = lstr_procedures.procedures[1].procedure_id
		text = lstr_procedures.procedures[1].description + " (" + ls_cpt_code + ")"
		changed = true
	CASE "NA"
		setnull(collection_procedure_id)
		text = "N/A"
		changed = true
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return

end event

type st_perform_procedure from statictext within w_composite_observation_definition
event clicked pbm_bnclicked
integer x = 1888
integer y = 780
integer width = 946
integer height = 124
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
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons
string ls_user_id
string ls_cpt_code
decimal ldc_charge
integer li_update_flag
str_picked_procedures lstr_procedures

if not isnull(perform_procedure_id) then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit Procedure Details"
	popup.button_titles[popup.button_count] = "Edit Procedure"
	buttons[popup.button_count] = "EDIT"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button05.bmp"
	popup.button_helps[popup.button_count] = "Change Procedure"
	popup.button_titles[popup.button_count] = "Change Procedure"
	buttons[popup.button_count] = "CHANGE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonx5.bmp"
	popup.button_helps[popup.button_count] = "Not Applicable"
	popup.button_titles[popup.button_count] = "N/A"
	buttons[popup.button_count] = "NA"
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
		popup.data_row_count = 2
		popup.items[1] = "TESTPERFORM"
		popup.items[2] = perform_procedure_id
		openwithparm(w_procedure_definition, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 4 then return
		perform_procedure_id = popup_return.item
		text = popup_return.items[4] + " (" + popup_return.items[1] + ")"
	CASE "CHANGE"
		popup.data_row_count = 1
		popup.items[1] = "TESTPERFORM"
		popup.multiselect = false
		openwithparm(w_pick_procedures, popup)
		lstr_procedures = message.powerobjectparm

		if lstr_procedures.procedure_count < 1 then return

		li_sts = tf_get_procedure_charge(lstr_procedures.procedures[1].procedure_id, ls_cpt_code, ldc_charge)
		if li_sts <= 0 then return
		perform_procedure_id = lstr_procedures.procedures[1].procedure_id
		text = lstr_procedures.procedures[1].description + " (" + ls_cpt_code + ")"
		changed = true
	CASE "NA"
		setnull(perform_procedure_id)
		text = "N/A"
		changed = true
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return

end event

type pb_done from u_picture_button within w_composite_observation_definition
event clicked pbm_bnclicked
integer x = 2629
integer y = 1560
integer taborder = 40
boolean default = true
boolean originalsize = false
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return
integer li_sts

if allow_editing then
	li_sts = save_changes()
	if li_sts <= 0 then return
	
	popup_return.item_count = 1
	popup_return.items[1] = observation_id
	popup_return.descriptions[1] = sle_description.text
else
	popup_return.item_count = 0
end if

closewithreturn(parent, popup_return)

end event

type cb_get_phrase from commandbutton within w_composite_observation_definition
boolean visible = false
integer x = 1664
integer y = 148
integer width = 146
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ". . ."
end type

event clicked;u_component_nomenclature luo_nomenclature
string ls_phrase

//luo_nomenclature = component_manager.get_component("NOMENCLATURE","PHRASE")
setnull(luo_nomenclature)
if isnull(luo_nomenclature) then
	openwithparm(w_pop_message, "A nomenclature component has not been installed")
	return
end if

ls_phrase = luo_nomenclature.get_phrase("")
if not (isnull(ls_phrase) or trim(ls_phrase) = "") then
	sle_description.text = ls_phrase
end if

component_manager.destroy_component(luo_nomenclature)


end event

type st_title_collection_procedure from statictext within w_composite_observation_definition
integer x = 1888
integer y = 512
integer width = 946
integer height = 76
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Collection Procedure"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_title_perform_procedure from statictext within w_composite_observation_definition
integer x = 1888
integer y = 716
integer width = 946
integer height = 76
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Perform Procedure"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_title_obseervation from statictext within w_composite_observation_definition
integer x = 421
integer y = 412
integer width = 859
integer height = 76
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 7191717
boolean enabled = false
string text = "Constituent Observations"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_title_in_context from statictext within w_composite_observation_definition
integer x = 1856
integer y = 404
integer width = 343
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Context Rqd:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_treatment_types from commandbutton within w_composite_observation_definition
integer x = 1888
integer y = 1288
integer width = 485
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Treatment Types"
end type

event clicked;str_popup popup

popup.items[1] = observation_id
popup.data_row_count = 1

openwithparm(w_observation_treatment_types, popup)

end event

type cb_coding_elements from commandbutton within w_composite_observation_definition
integer x = 1888
integer y = 1420
integer width = 485
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Coding Elements"
end type

event clicked;str_popup popup

popup.title = sle_description.text
popup.items[1] = observation_id
popup.data_row_count = 1

openwithparm(w_observation_coding_elements, popup)

end event

type cb_image from commandbutton within w_composite_observation_definition
integer x = 2391
integer y = 1156
integer width = 485
integer height = 112
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Image"
end type

event clicked;//////////////////////////////////////////////////////////////////////////////////////
//
// Description: popup the material categories
//
// Created By:Sumathi Chinnasamy										Creation dt: 02/02/2000
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////

str_popup			popup
str_popup_return	popup_return
long ll_material_category_id
integer li_choice
integer li_sts
long ll_material_id

if isnull(observation_id) then return

if isnull(material_id) then
	li_choice = 3
else
	popup.title = "Select One:"
	popup.data_row_count = 3
	popup.items[1] = "Display Image"
	popup.items[2] = "Remove Image"
	popup.items[3] = "Change Image"
	openwithparm(w_pop_pick, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return
	
	li_choice = popup_return.item_indexes[1]
end if


CHOOSE CASE li_choice
	CASE 1
		li_sts = f_display_patient_material(material_id)
	CASE 2
		UPDATE c_Observation
		SET material_id = NULL
		WHERE observation_id = :observation_id;
		if not tf_check() then return
		
		weight = 400
		return
	CASE 3
		open(w_pick_patient_material)
		ll_material_id = message.doubleparm
		if ll_material_id > 0 then
			material_id = ll_material_id
			
			UPDATE c_Observation
			SET material_id = :material_id
			WHERE observation_id = :observation_id;
			if not tf_check() then return
			
			weight = 700
		end if
END CHOOSE



end event

type cb_results from commandbutton within w_composite_observation_definition
integer x = 1888
integer y = 1156
integer width = 485
integer height = 112
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Results"
end type

event clicked;//////////////////////////////////////////////////////////////////////////////////////
//
// Description: popup the material categories
//
// Created By:Sumathi Chinnasamy										Creation dt: 02/02/2000
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////

str_popup			popup
str_popup_return	popup_return
string ls_result_type

if isnull(observation_id) then return

popup.dataobject = "dw_composite_result_types"
popup.datacolumn = 1
popup.displaycolumn = 1

Openwithparm(w_pop_pick, popup)
popup_return = Message.powerobjectparm
If popup_return.item_count <> 1 Then Return


ls_result_type = popup_return.items[1]

popup.dataobject = ""
popup.datacolumn = 0
popup.displaycolumn = 0
popup.data_row_count = 2
popup.items[1] = observation_id
popup.items[2] = ls_result_type
popup.title = sle_description.text

openwithparm(w_observation_result_edit, popup)

end event

type st_perform_location_domain_title from statictext within w_composite_observation_definition
integer x = 1888
integer y = 932
integer width = 946
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Location Domain"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_perform_location_domain from statictext within w_composite_observation_definition
integer x = 1888
integer y = 996
integer width = 946
integer height = 124
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
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons
string ls_user_id
string ls_assessment_id
integer li_update_flag


if not isnull(perform_location_domain) and perform_location_domain <> "NA" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit Locations in this Domain"
	popup.button_titles[popup.button_count] = "Edit Domain"
	buttons[popup.button_count] = "EDIT"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Change Location Domain"
	popup.button_titles[popup.button_count] = "Change Domain"
	buttons[popup.button_count] = "CHANGE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonx5.bmp"
	popup.button_helps[popup.button_count] = "Not Applicable"
	popup.button_titles[popup.button_count] = "Not Applicable"
	buttons[popup.button_count] = "NA"
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
		edit_location_domain()
	CASE "CHANGE"
		change_location_domain()
	CASE "NEW"
		new_location_domain()
	CASE "NA"
		perform_location_domain = "NA"
		text = "N/A"
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return

end event

type pb_up from u_picture_button within w_composite_observation_definition
integer x = 1344
integer y = 1680
integer width = 137
integer height = 116
integer taborder = 30
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_observations.current_page

dw_observations.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from u_picture_button within w_composite_observation_definition
integer x = 1499
integer y = 1680
integer width = 137
integer height = 116
integer taborder = 20
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;integer li_page
integer li_last_page

li_page = dw_observations.current_page
li_last_page = dw_observations.last_page

dw_observations.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type st_page from statictext within w_composite_observation_definition
integer x = 1641
integer y = 1680
integer width = 274
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Page 99/99"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_composite_observation_definition
integer x = 1833
integer y = 288
integer width = 366
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Display Style:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_display_style from statictext within w_composite_observation_definition
integer x = 2217
integer y = 272
integer width = 622
integer height = 104
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

popup.title = "Enter Display Style"
popup.item = display_style
popup.argument_count = 1
popup.argument[1] = "observation_display_style"
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

text = popup_return.items[1]
display_style = text



end event

type cb_legal_notice from commandbutton within w_composite_observation_definition
integer x = 2391
integer y = 1420
integer width = 485
integer height = 112
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Legal Notice"
end type

event clicked;str_popup popup
str_popup_return popup_return
string ls_new_legal_notice

popup.title = "Legal Notice for " + sle_description.text
popup.item = legal_notice

openwithparm(w_pop_prompt_string_multiline, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if len(trim(popup_return.items[1])) > 0 then
	ls_new_legal_notice = popup_return.items[1]
	weight = 700
else
	setnull(ls_new_legal_notice)
	weight = 400
end if

if f_string_modified(legal_notice, ls_new_legal_notice) then
	legal_notice = ls_new_legal_notice
	if not isnull(observation_id) then
		UPDATE c_Observation
		SET legal_notice = :legal_notice
		WHERE observation_id = :observation_id;
		if not tf_check() then return -1
	end if
end if

end event

type st_title from statictext within w_composite_observation_definition
integer width = 2926
integer height = 144
integer textsize = -24
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Composite Observation Definition"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_status from statictext within w_composite_observation_definition
integer x = 2587
integer y = 388
integer width = 251
integer height = 104
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Inactive"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if status = "OK" then
	status = "NA"
	text = "Inactive"
else
	status = "OK"
	text = "Active"
end if

changed = true

end event

type st_2 from statictext within w_composite_observation_definition
integer x = 2391
integer y = 404
integer width = 183
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Status:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_observation_id from statictext within w_composite_observation_definition
integer x = 46
integer y = 340
integer width = 919
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "!DEVINFANT12_90"
boolean focusrectangle = false
end type

event clicked;clipboard(text)

end event

