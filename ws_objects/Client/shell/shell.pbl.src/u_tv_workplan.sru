$PBExportHeader$u_tv_workplan.sru
forward
global type u_tv_workplan from treeview
end type
type str_severity from structure within u_tv_workplan
end type
end forward

type str_severity from structure
	integer		severity
	string		description
	string		bitmap
	integer		index
end type

global type u_tv_workplan from treeview
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
string picturename[] = {"PasteStatement!","Step!","icon_svc.bmp","icon_trt.bmp","icon_wp.bmp"}
long picturemaskcolor = 536870912
long statepicturemaskcolor = 536870912
end type
global u_tv_workplan u_tv_workplan

type variables
boolean allow_editing

long dragging_handle

u_ds_data c_observation_tree

str_c_workplan workplan

end variables

forward prototypes
public subroutine redisplay_parent (long pl_handle)
public subroutine redisplay_item (long pl_handle)
public function integer display_workplan (long pl_workplan_id, boolean pb_allow_editing)
public subroutine workplan_menu (long pl_handle)
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

public function integer display_workplan (long pl_workplan_id, boolean pb_allow_editing);treeviewitem ltvi_node
long ll_handle

if isnull(pl_workplan_id) then
	log.log(this, "u_tv_workplan.display_workplan.0005", "Null workplan_id", 4)
	return -1
end if

workplan = datalist.get_workplan(pl_workplan_id)
if isnull(workplan.workplan_id) then
	log.log(this, "u_tv_workplan.display_workplan.0005", "workplan not found (" + string(pl_workplan_id) + ")", 4)
	return -1
end if

allow_editing = pb_allow_editing

// Delete existing treeview items
DO
	ll_handle = finditem(RootTreeItem!, 0)
	if ll_handle > 0 then deleteitem(ll_handle)
LOOP WHILE ll_handle > 0


ltvi_node.data = "WORKPLAN|" + string(workplan.workplan_id)
ltvi_node.label = workplan.description
ltvi_node.children = true
ltvi_node.PictureIndex = 1
ltvi_node.SelectedPictureIndex = 1
ll_handle = insertitemlast(0, ltvi_node)

expanditem(ll_handle)

selectitem(ll_handle)

return 1

end function

public subroutine workplan_menu (long pl_handle);str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons
string ls_user_id
integer li_update_flag
string ls_observation_id
string ls_temp
string ls_description
string ls_composite_flag
string ls_location
integer li_result_sequence
integer li_result_sequence_2
string ls_branch_description
integer li_followon_severity
string ls_followon_observation_id
long ll_branch_id
string ls_observation_tag
string ls_dragged_observation_id
long ll_dragged_branch_id
string ls_dragged_description
str_observation_tree_branch lstr_branch


if allow_editing then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit Workplan"
	popup.button_titles[popup.button_count] = "Edit Workplan"
	buttons[popup.button_count] = "EDIT"
end if

if popup.button_count > 0 then
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
		popup.items[1] = string(workplan.workplan_id)
		popup.data_row_count = 1
		openwithparm(w_Workplan_definition, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return

		display_workplan(workplan.workplan_id, allow_editing)
END CHOOSE

return

end subroutine

on u_tv_workplan.create
end on

on u_tv_workplan.destroy
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
u_ds_data luo_data
string ls_temp
string ls_temp2
long ll_step_delay
string ls_step_delay_unit
string ls_delay_from_flag
u_unit luo_unit
string ls_item_type

li_sts = getitem(handle, ltvi_parent_item)
if li_sts <= 0 then
	log.log(this, "u_tv_workplan.itempopulate.0023", "Error getting new treeview item (" + string(handle) + ")", 4)
	return 1
end if

f_split_string(string(ltvi_parent_item.data), "|", ls_node_type, ls_id)
if isnull(ls_node_type) or trim(ls_node_type) = "" then
	log.log(this, "u_tv_workplan.itempopulate.0023", "No node_type", 4)
	return 1
end if

if isnull(ls_id) or trim(ls_id) = "" then
	setnull(ll_id)
else
	ll_id = long(ls_id)
end if

luo_data = CREATE u_ds_data

CHOOSE CASE upper(ls_node_type)
	CASE "WORKPLAN"
		// If this is a workplan then show the steps
		luo_data.set_dataobject("dw_workplan_step_list")
		ll_rows = luo_data.retrieve(workplan.workplan_id)
		for i = 1 to ll_rows
			ls_description = "Step "
			ls_description += string(integer(luo_data.object.step_number[i]))
			ls_description += ": " + luo_data.object.description[i]
			
//			ls_temp = luo_data.object.in_office_flag[i]
//			if upper(ls_temp) = "Y" then
//				ls_description += " (In Office)"
//			else
//				ls_description += " (Out of Office)"
//			end if
			
			ls_temp = luo_data.object.room_type[i]
			if len(ls_temp) > 0 then
				ls_description += " " + ls_temp
			end if

			ll_step_delay = luo_data.object.step_delay[i]
			ls_step_delay_unit = luo_data.object.step_delay_unit[i]
			ls_delay_from_flag = luo_data.object.delay_from_flag[i]
			
			ls_temp = ""
			luo_unit = unit_list.find_unit(ls_step_delay_unit)
			if not isnull(luo_unit) then
				ls_temp = luo_unit.pretty_amount_unit(real(ll_step_delay))
				if not isnull(ls_delay_from_flag) then
					ls_temp += " " + ls_delay_from_flag
				end if
			end if
			if len(ls_temp) > 0 then
				ls_description += ", Delay " + ls_temp
			end if

			ltvi_new_item.data = "STEP|" + string(integer(luo_data.object.step_number[i]))
			ltvi_new_item.label = ls_description
			ltvi_new_item.children = true
			ltvi_new_item.PictureIndex = 2
			ltvi_new_item.SelectedPictureIndex = 2
			ll_new_handle = insertitemlast(handle, ltvi_new_item)
		next
	CASE "STEP"
		// If this is a step then show the items
		luo_data.set_dataobject("dw_workplan_item_list")
		ll_rows = luo_data.retrieve(workplan.workplan_id, ll_id)
		for i = 1 to ll_rows
			ls_item_type = luo_data.object.item_type[i]
			ls_description = ""
			
			ls_temp = luo_data.object.description[i]
			if lower(ls_item_type) = "service" then
				ls_temp2 = luo_data.object.service_description[i]
				ltvi_new_item.PictureIndex = 3
			elseif lower(ls_item_type) = "treatment" then
				ls_temp2 = luo_data.object.treatment_type_description[i]
				ltvi_new_item.PictureIndex = 4
			else
				ls_temp2 = ls_temp
				ltvi_new_item.PictureIndex = 5
			end if
			if ls_temp = ls_temp2 then
				ls_description += " " + ls_temp
			else
				ls_description += " " + ls_temp + " (" + ls_temp2 + ")"
			end if
			
			ls_temp = luo_data.object.in_office_flag[i]
			if upper(ls_temp) = "Y" then
				ls_description += ", In Office"
			else
				ls_description += ", Out of Office"
			end if
			
			ls_temp = luo_data.object.user_short_name[i]
			if isnull(ls_temp) then ls_temp = luo_data.object.role_name[i]
			if len(ls_temp) > 0 then
				ls_description += ", Ordered For " + ls_temp
			end if

			ltvi_new_item.data = "ITEM|" + string(long(luo_data.object.item_number[i]))
			ltvi_new_item.label = ls_description
			ltvi_new_item.children = true
			ltvi_new_item.SelectedPictureIndex = ltvi_new_item.PictureIndex
			ll_new_handle = insertitemlast(handle, ltvi_new_item)
		next
	CASE "ITEM"
		// If this is an item then show the properties
		
END CHOOSE

DESTROY luo_data

return 0

end event

event doubleclicked;if allow_editing then workplan_menu(handle)

end event

event rightclicked;if allow_editing then workplan_menu(handle)

end event

