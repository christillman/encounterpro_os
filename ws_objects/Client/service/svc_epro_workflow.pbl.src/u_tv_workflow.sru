$PBExportHeader$u_tv_workflow.sru
forward
global type u_tv_workflow from treeview
end type
type str_severity from structure within u_tv_workflow
end type
end forward

type str_severity from structure
	integer		severity
	string		description
	string		bitmap
	integer		index
end type

global type u_tv_workflow from treeview
integer width = 1106
integer height = 876
integer taborder = 10
string dragicon = "AppIcon!"
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
boolean hideselection = false
string picturename[] = {"MEDICAL.ICO","Step!","icon_svc.bmp","icon_trt.bmp","icon_wp.bmp"}
long picturemaskcolor = 536870912
long statepicturemaskcolor = 536870912
end type
global u_tv_workflow u_tv_workflow

type variables
boolean allow_editing

long dragging_handle

u_ds_data wpdata


end variables

forward prototypes
public subroutine redisplay_parent (long pl_handle)
public subroutine redisplay_item (long pl_handle)
public function integer display_workflow (string ps_context_object, string ps_cpr_id, long pl_object_key)
public subroutine menu (long pl_handle)
end prototypes

public subroutine redisplay_parent (long pl_handle);long ll_parent_handle
treeviewitem ltvi_item
integer li_sts

ll_parent_handle = finditem(ParentTreeItem!, pl_handle)
if ll_parent_handle < 0 then return


li_sts = getitem(ll_parent_handle, ltvi_item)
if li_sts < 0 then return

setredraw(false)
collapseitem(ll_parent_handle)
ltvi_item.expandedonce = false
expanditem(ll_parent_handle)
setredraw(true)

end subroutine

public subroutine redisplay_item (long pl_handle);treeviewitem ltvi_item
integer li_sts

li_sts = getitem(pl_handle, ltvi_item)
if li_sts < 0 then return

if ltvi_item.expanded then
	setredraw(false)
	collapseitem(pl_handle)
	ltvi_item.expandedonce = false
	expanditem(pl_handle)
	setredraw(true)
end if


end subroutine

public function integer display_workflow (string ps_context_object, string ps_cpr_id, long pl_object_key);treeviewitem ltvi_node
long ll_handle
string ls_data

if isnull(ps_context_object) then
	log.log(this, "u_tv_workflow.display_workflow.0006", "Null context_object", 4)
	return -1
end if

// Delete existing treeview items
DO
	ll_handle = finditem(RootTreeItem!, 0)
	if ll_handle > 0 then deleteitem(ll_handle)
LOOP WHILE ll_handle > 0


ls_data = ps_context_object + "|" + ps_cpr_id
if not isnull(pl_object_key) then
	ls_data += "|" + string(pl_object_key)
end if
ltvi_node.data = ls_data
ltvi_node.label = sqlca.fn_patient_object_description(ps_cpr_id, ps_context_object, pl_object_key)
ltvi_node.children = true
ltvi_node.PictureIndex = 1
ltvi_node.SelectedPictureIndex = 1
ll_handle = insertitemlast(0, ltvi_node)

expanditem(ll_handle)

selectitem(ll_handle)

return 1

end function

public subroutine menu (long pl_handle);//str_popup popup
//str_popup_return popup_return
//string buttons[]
//integer button_pressed, li_sts, li_service_count
//window lw_pop_buttons
//string ls_user_id
//integer li_update_flag
//string ls_observation_id
//string ls_temp
//string ls_description
//string ls_composite_flag
//string ls_location
//integer li_result_sequence
//integer li_result_sequence_2
//string ls_branch_description
//integer li_followon_severity
//string ls_followon_observation_id
//long ll_branch_id
//string ls_observation_tag
//string ls_dragged_observation_id
//long ll_dragged_branch_id
//string ls_dragged_description
//str_observation_tree_branch lstr_branch
//
//li_sts = convert_handle(pl_handle, ls_observation_id, ll_branch_id, ls_description)
//if li_sts <= 0 then return
//
//ls_composite_flag = datalist.observation_composite_flag(ls_observation_id)
//
//if allow_editing then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button17.bmp"
//	popup.button_helps[popup.button_count] = "Edit Observation"
//	popup.button_titles[popup.button_count] = "Edit Observation"
//	buttons[popup.button_count] = "EDIT"
//else
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button17.bmp"
//	popup.button_helps[popup.button_count] = "Display Observation"
//	popup.button_titles[popup.button_count] = "Display Observation"
//	buttons[popup.button_count] = "EDIT"
//end if
//
//if not isnull(ll_branch_id) then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button17.bmp"
//	popup.button_helps[popup.button_count] = "Edit Constituent Observation Attributes"
//	popup.button_titles[popup.button_count] = "Attributes"
//	buttons[popup.button_count] = "ATTRIBUTES"
//end if
//
//if allow_editing then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button18.bmp"
//	popup.button_helps[popup.button_count] = "Copy observation into another branch"
//	popup.button_titles[popup.button_count] = "Copy"
//	buttons[popup.button_count] = "COPY"
//end if
//
//if dragging_handle > 0 then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button18.bmp"
//	popup.button_helps[popup.button_count] = "Paste observation into this branch"
//	popup.button_titles[popup.button_count] = "Paste Above"
//	buttons[popup.button_count] = "PASTEABOVE"
//end if
//
//if dragging_handle > 0 then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button18.bmp"
//	popup.button_helps[popup.button_count] = "Paste observation into this branch"
//	popup.button_titles[popup.button_count] = "Paste Below"
//	buttons[popup.button_count] = "PASTEBELOW"
//end if
//
//if dragging_handle > 0 and ls_composite_flag = "Y" then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button18.bmp"
//	popup.button_helps[popup.button_count] = "Paste observation into this composite observation"
//	popup.button_titles[popup.button_count] = "Paste Into"
//	buttons[popup.button_count] = "PASTEINTO"
//end if
//
//if allow_editing then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button13.bmp"
//	popup.button_helps[popup.button_count] = "Remove Observation From Parent Composite Observation"
//	popup.button_titles[popup.button_count] = "Remove Observation"
//	buttons[popup.button_count] = "REMOVE"
//end if
//
//if true then
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
//CHOOSE CASE buttons[button_pressed]
//	CASE "EDIT"
//		popup.data_row_count = 2
//		popup.items[1] = ls_observation_id
//		popup.items[2] = f_boolean_to_string(allow_editing)
//		
//		if ls_composite_flag = "Y" then
//			openwithparm(w_composite_observation_definition, popup)
//		else
//			openwithparm(w_observation_definition, popup)
//		end if
//		
//		popup_return = message.powerobjectparm
//		if popup_return.item_count <> 1 then return
//		update_observation(pl_handle, popup_return.items[1], ll_branch_id, popup_return.descriptions[1])
//	CASE "ATTRIBUTES"
//		lstr_branch = datalist.observation_tree_branch(ll_branch_id)
//		if isnull(lstr_branch.branch_id) then return
//		openwithparm(w_observation_tree_attributes, lstr_branch)
//		popup_return = message.powerobjectparm
//		if popup_return.item_count <> 1 then return
//		if popup_return.items[1] <> "OK" then return
//		lstr_branch = popup_return.returnobject
//		
//		// Update the database
//		li_sts = datalist.observation_tree_branch_update(lstr_branch)
//		if li_sts <= 0 then
//			log.log(this, "clicked", "Error saving branch changes", 4)
//			return
//		end if
//
//		// Update the description on the screen
//		update_observation(pl_handle, ls_observation_id, ll_branch_id, lstr_branch.description)
//	CASE "COPY"
//		dragging_handle = pl_handle
//	CASE "PASTEABOVE"
//		add_branch(dragging_handle, pl_handle, "ABOVE")
//	CASE "PASTEBELOW"
//		add_branch(dragging_handle, pl_handle, "BELOW")
//	CASE "PASTEINTO"
//		add_branch(dragging_handle, pl_handle, "INTO")
//	CASE "REMOVE"
//		ls_temp = "Remove " + ls_description + "?"
//		openwithparm(w_pop_ok, ls_temp)
//		if message.doubleparm = 1 then
//			DELETE c_Observation_Tree
//			WHERE branch_id = :ll_branch_id;
//			if not tf_check() then return
//			deleteitem(pl_handle)
//		end if
//	CASE "CANCEL"
//		return
//	CASE ELSE
//END CHOOSE
//
//return
//
end subroutine

on u_tv_workflow.create
end on

on u_tv_workflow.destroy
end on

event itempopulate;treeviewitem ltvi_parent_item
treeviewitem ltvi_new_item
integer li_sts
long i
string ls_description
long ll_rows
long ll_new_handle
string ls_data
string ls_id
string ls_node_type
long ll_id
string ls_temp
string ls_temp2
long ll_step_delay
string ls_step_delay_unit
string ls_delay_from_flag
u_unit luo_unit
string ls_item_type
string ls_cpr_id
long ll_patient_workplan_item_id
long ll_row_started
long ll_row_completed
long ll_last_row
string ls_find_started
string ls_find_completed
datetime ldt_item_started
datetime ldt_item_completed
long ll_session_id
datetime ldt_encounter_date

li_sts = getitem(handle, ltvi_parent_item)
if li_sts <= 0 then
	log.log(this, "u_tv_workflow.itempopulate.0033", "Error getting new treeview item (" + string(handle) + ")", 4)
	return 1
end if

f_split_string(string(ltvi_parent_item.data), "|", ls_node_type, ls_temp)
if isnull(ls_node_type) or trim(ls_node_type) = "" then
	log.log(this, "u_tv_workflow.itempopulate.0033", "No node_type", 4)
	return 1
end if

f_split_string(ls_temp, "|", ls_cpr_id, ls_id)

if isnull(ls_id) or trim(ls_id) = "" then
	setnull(ll_id)
else
	ll_id = long(ls_id)
end if

CHOOSE CASE upper(ls_node_type)
	CASE "PATIENT"
		
		wpdata.set_dataobject("dw_sp_get_encounter_list")
		ll_rows = wpdata.retrieve(ls_cpr_id, "%", "%", "%")
		for i = 1 to ll_rows
			ll_id = wpdata.object.encounter_id[i]
			ldt_encounter_date = wpdata.object.encounter_date[i]
			
			ls_description = string(date(ldt_encounter_date), "[shortdate]")
			ls_description += " " + wpdata.object.encounter_description[i]
			
			ls_data = "ENCOUNTER|" + ls_cpr_id + "|" + string(ll_id)
			
			ltvi_new_item.data = ls_data
			ltvi_new_item.label = ls_description
			ltvi_new_item.children = true
			ltvi_new_item.PictureIndex = 1
			ltvi_new_item.SelectedPictureIndex = 1
			ll_new_handle = insertitemlast(handle, ltvi_new_item)
		next
	CASE "ENCOUNTER"
		// If this is a workplan then show the steps
		wpdata.set_dataobject("dw_jmj_encounter_audit")
		ll_rows = wpdata.retrieve(ls_cpr_id, ll_id, "Y")
		ll_row_started = 1
		ll_last_row = 0
		ls_find_started = "lower(event_type)='workflow' and lower(action)='started'"
		ll_row_started = wpdata.find(ls_find_started, ll_last_row + 1, ll_rows + 1)
		
		DO WHILE ll_row_started > 0 and ll_row_started <= ll_rows
			// Find a service started row
			if ll_row_started > 0 and ll_row_started <= ll_rows then
				ll_session_id = wpdata.object.session_id[ll_row_started]
				ll_patient_workplan_item_id = wpdata.object.patient_workplan_item_id[ll_row_started]
				ls_description = wpdata.object.item[ll_row_started]
				if isnull(ls_description) then
					ls_description = "Workplan Item # " + string(ll_patient_workplan_item_id)
				end if
				
				ldt_item_started = wpdata.object.event_date_time[ll_row_started]
				ls_description += " (" + string(time(ldt_item_started), "hh:mm:ss")
				
				ls_find_completed = "lower(event_type)='workflow'"
				ls_find_completed += "and lower(action)='completed'"
				ls_find_completed += " and patient_workplan_item_id=" + string(ll_patient_workplan_item_id)
				ls_find_completed += " and session_id="+ string(ll_session_id)
				
				// Now find the corresponding service-completed row
				ll_row_completed = wpdata.find(ls_find_completed, ll_row_started + 1, ll_rows + 1)
				if ll_row_completed > 0 and ll_row_completed <= ll_rows then
					// We found the service completed row, so complete the description
					ldt_item_completed = wpdata.object.event_date_time[ll_row_started]
					ls_description += " - " + string(time(ldt_item_completed), "hh:mm:ss") + ")"
					ll_last_row = ll_row_completed
				else
					// We didn't find the service completed row
					ls_description += ")"
					ll_last_row = ll_row_started
				end if
			else
				exit
			end if
			
			ls_data = "WPITEM|" + ls_cpr_id + "|" + string(ll_patient_workplan_item_id)
			
			ltvi_new_item.data = ls_data
			ltvi_new_item.label = ls_description
			ltvi_new_item.children = true
			ltvi_new_item.PictureIndex = 1
			ltvi_new_item.SelectedPictureIndex = 1
			ll_new_handle = insertitemlast(handle, ltvi_new_item)
			
			ll_row_started = wpdata.find(ls_find_started, ll_last_row + 1, ll_rows + 1)
		LOOP
		
//		for i = 1 to ll_rows
//			ls_description = "Step "
//			ls_description += string(integer(luo_data.object.step_number[i]))
//			ls_description += ": " + luo_data.object.description[i]
//			
////			ls_temp = luo_data.object.in_office_flag[i]
////			if upper(ls_temp) = "Y" then
////				ls_description += " (In Office)"
////			else
////				ls_description += " (Out of Office)"
////			end if
//			
//			ls_temp = luo_data.object.room_type[i]
//			if len(ls_temp) > 0 then
//				ls_description += " " + ls_temp
//			end if
//
//			ll_step_delay = luo_data.object.step_delay[i]
//			ls_step_delay_unit = luo_data.object.step_delay_unit[i]
//			ls_delay_from_flag = luo_data.object.delay_from_flag[i]
//			
//			ls_temp = ""
//			luo_unit = unit_list.find_unit(ls_step_delay_unit)
//			if not isnull(luo_unit) then
//				ls_temp = luo_unit.pretty_amount_unit(real(ll_step_delay))
//				if not isnull(ls_delay_from_flag) then
//					ls_temp += " " + ls_delay_from_flag
//				end if
//			end if
//			if len(ls_temp) > 0 then
//				ls_description += ", Delay " + ls_temp
//			end if
//		next
	CASE "ASSESSMENT"
	CASE "TREATMENT"
	CASE "WORKPLAN"
	CASE "WORKPLANITEM"
END CHOOSE

return 0

end event

event doubleclicked;if allow_editing then menu(handle)

end event

event rightclicked;if allow_editing then menu(handle)

end event

event constructor;wpdata = CREATE u_ds_data

end event

