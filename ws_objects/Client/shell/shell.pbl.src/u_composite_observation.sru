$PBExportHeader$u_composite_observation.sru
forward
global type u_composite_observation from treeview
end type
type str_severity from structure within u_composite_observation
end type
end forward

type str_severity from structure
	integer		severity
	string		description
	string		bitmap
	integer		index
end type

global type u_composite_observation from treeview
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
string picturename[] = {"Cascade!","Custom081!","Custom035!"}
long picturemaskcolor = 536870912
long statepicturemaskcolor = 536870912
end type
global u_composite_observation u_composite_observation

type variables
string root_observation_id
boolean allow_editing

long dragging_handle

u_ds_data c_observation_tree

end variables

forward prototypes
public function integer update_observation (long pl_handle, string ps_observation_id, long pl_branch_id, string ps_description)
public function integer convert_handle (long pl_handle, ref string ps_observation_id, ref long pl_branch_id, ref string ps_description)
public subroutine redisplay_parent (long pl_handle)
public subroutine observation_menu (long pl_handle)
public subroutine redisplay_item (long pl_handle)
public function integer display_root (string ps_observation_id, boolean pb_allow_editing)
public function str_observation_stack get_observation_stack (long pl_handle)
public function boolean loop_check (string ps_parent_observation_id, string ps_new_observation_id)
public function integer add_branch (long pl_from_handle, long pl_to_handle, string ps_where)
public subroutine drop_menu (long pl_handle)
end prototypes

public function integer update_observation (long pl_handle, string ps_observation_id, long pl_branch_id, string ps_description);long ll_child_handle
treeviewitem ltvi_item
integer li_sts
string ls_data
boolean lb_expanded
string ls_composite_flag
string ls_followon_observation_id

ls_composite_flag = datalist.observation_composite_flag(ps_observation_id)
if not isnull(pl_branch_id) then
	SELECT followon_observation_id
	INTO :ls_followon_observation_id
	FROM c_Observation_Tree
	WHERE branch_id = :pl_branch_id;
	if not tf_check() then return -1
	if sqlca.sqlcode = 100 then
		log.log(this, "u_composite_observation.update_observation:0017", "branch not found (" + string(pl_branch_id) + ")", 4)
		return -1
	end if
end if

setredraw(false)

li_sts = getitem(pl_handle, ltvi_item)
if li_sts <= 0 then return -1

lb_expanded = ltvi_item.expanded

// Remove the children
ll_child_handle = finditem(ChildTreeItem!, pl_handle)
DO
	deleteitem(ll_child_handle)
	ll_child_handle = finditem(ChildTreeItem!, pl_handle)
LOOP WHILE ll_child_handle > 0

// Update the item properties
ls_data = ps_observation_id + "|||" + string(pl_branch_id)
ltvi_item.data = ls_data
ltvi_item.label = ps_description
ltvi_item.expanded = false
ltvi_item.expandedonce = false
if ls_composite_flag = "Y" then
	ltvi_item.children = true
	ltvi_item.PictureIndex = 1
	ltvi_item.SelectedPictureIndex = 1
elseif not isnull(ls_followon_observation_id) then
	ltvi_item.children = true
	ltvi_item.PictureIndex = 3
	ltvi_item.SelectedPictureIndex = 3
else
	ltvi_item.children = false
	ltvi_item.PictureIndex = 2
	ltvi_item.SelectedPictureIndex = 2
end if
setitem(pl_handle, ltvi_item)

// Re-expand item if it was already expanded
if lb_expanded then expanditem(pl_handle)

setredraw(true)

return 1


end function

public function integer convert_handle (long pl_handle, ref string ps_observation_id, ref long pl_branch_id, ref string ps_description);string ls_temp
integer li_sts
treeviewitem ltvi_item

li_sts = getitem(pl_handle, ltvi_item)
if li_sts <= 0 then
	log.log(this, "u_composite_observation.convert_handle:0007", "Error getting treeview item (" + string(pl_handle) + ")", 4)
	return -1
end if

f_split_string(string(ltvi_item.data), "|||", ps_observation_id, ls_temp)

if isnull(ls_temp) or trim(ls_temp) = "" then
	setnull(pl_branch_id)
else
	pl_branch_id = long(ls_temp)
end if

ps_description = ltvi_item.label

return 1

end function

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

public subroutine observation_menu (long pl_handle);str_popup popup
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

li_sts = convert_handle(pl_handle, ls_observation_id, ll_branch_id, ls_description)
if li_sts <= 0 then return

ls_composite_flag = datalist.observation_composite_flag(ls_observation_id)

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

if not isnull(ll_branch_id) then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit Constituent Observation Attributes"
	popup.button_titles[popup.button_count] = "Attributes"
	buttons[popup.button_count] = "ATTRIBUTES"
end if

if allow_editing then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button18.bmp"
	popup.button_helps[popup.button_count] = "Copy observation into another branch"
	popup.button_titles[popup.button_count] = "Copy"
	buttons[popup.button_count] = "COPY"
end if

if dragging_handle > 0 then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button18.bmp"
	popup.button_helps[popup.button_count] = "Paste observation into this branch"
	popup.button_titles[popup.button_count] = "Paste Above"
	buttons[popup.button_count] = "PASTEABOVE"
end if

if dragging_handle > 0 then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button18.bmp"
	popup.button_helps[popup.button_count] = "Paste observation into this branch"
	popup.button_titles[popup.button_count] = "Paste Below"
	buttons[popup.button_count] = "PASTEBELOW"
end if

if dragging_handle > 0 and ls_composite_flag = "Y" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button18.bmp"
	popup.button_helps[popup.button_count] = "Paste observation into this composite observation"
	popup.button_titles[popup.button_count] = "Paste Into"
	buttons[popup.button_count] = "PASTEINTO"
end if

if allow_editing then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Remove Observation From Parent Composite Observation"
	popup.button_titles[popup.button_count] = "Remove Observation"
	buttons[popup.button_count] = "REMOVE"
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
		popup.items[1] = ls_observation_id
		popup.items[2] = f_boolean_to_string(allow_editing)
		
		if ls_composite_flag = "Y" then
			openwithparm(w_composite_observation_definition, popup)
		else
			openwithparm(w_observation_definition, popup)
		end if
		
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		update_observation(pl_handle, popup_return.items[1], ll_branch_id, popup_return.descriptions[1])
	CASE "ATTRIBUTES"
		lstr_branch = datalist.observation_tree_branch(ll_branch_id)
		if isnull(lstr_branch.branch_id) then return
		openwithparm(w_observation_tree_attributes, lstr_branch)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		if popup_return.items[1] <> "OK" then return
		lstr_branch = popup_return.returnobject
		
		// Update the database
		li_sts = datalist.observation_tree_branch_update(lstr_branch)
		if li_sts <= 0 then
			log.log(this, "u_composite_observation.observation_menu:0139", "Error saving branch changes", 4)
			return
		end if

		// Update the description on the screen
		update_observation(pl_handle, ls_observation_id, ll_branch_id, lstr_branch.description)
	CASE "COPY"
		dragging_handle = pl_handle
	CASE "PASTEABOVE"
		add_branch(dragging_handle, pl_handle, "ABOVE")
	CASE "PASTEBELOW"
		add_branch(dragging_handle, pl_handle, "BELOW")
	CASE "PASTEINTO"
		add_branch(dragging_handle, pl_handle, "INTO")
	CASE "REMOVE"
		ls_temp = "Remove " + ls_description + "?"
		openwithparm(w_pop_ok, ls_temp)
		if message.doubleparm = 1 then
			DELETE c_Observation_Tree
			WHERE branch_id = :ll_branch_id;
			if not tf_check() then return
			deleteitem(pl_handle)
		end if
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return

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

public function integer display_root (string ps_observation_id, boolean pb_allow_editing);treeviewitem ltvi_node
string ls_description
long ll_handle

root_observation_id = ps_observation_id
allow_editing = pb_allow_editing

// Delete existing treeview items
DO
	ll_handle = finditem(RootTreeItem!, 0)
	if ll_handle > 0 then deleteitem(ll_handle)
LOOP WHILE ll_handle > 0


ls_description = datalist.observation_description(root_observation_id)
ltvi_node.data = root_observation_id
ltvi_node.label = ls_description
ltvi_node.children = true
ltvi_node.PictureIndex = 1
ltvi_node.SelectedPictureIndex = 1
ll_handle = insertitemlast(0, ltvi_node)

expanditem(ll_handle)

selectitem(ll_handle)

return 1

end function

public function str_observation_stack get_observation_stack (long pl_handle);str_observation_stack lstr_stack
string ls_observation_id
long ll_branch_id
string ls_description
long i

lstr_stack.root_observation_id = root_observation_id
lstr_stack.depth = 0

convert_handle(pl_handle, ls_observation_id, ll_branch_id, ls_description)
DO WHILE ls_observation_id <> root_observation_id
	lstr_stack.depth += 1
	for i = lstr_stack.depth to 2 step -1
		lstr_stack.observation_id[i] = lstr_stack.observation_id[i - 1]
		lstr_stack.branch_id[i] = lstr_stack.branch_id[i - 1]
		lstr_stack.description[i] = lstr_stack.description[i - 1]
		lstr_stack.child_ordinal[i] = lstr_stack.child_ordinal[i - 1]
	next
	lstr_stack.observation_id[1] = ls_observation_id
	lstr_stack.branch_id[1] = ll_branch_id
	lstr_stack.description[1] = ls_description
	lstr_stack.child_ordinal[1] = datalist.observation_branch_child_ordinal(ll_branch_id)
	
	pl_handle = finditem(ParentTreeItem!, pl_handle)
	if pl_handle <= 0 then exit
	convert_handle(pl_handle, ls_observation_id, ll_branch_id, ls_description)
LOOP

return lstr_stack

end function

public function boolean loop_check (string ps_parent_observation_id, string ps_new_observation_id);integer li_loop

 DECLARE lsp_observation_loop_check PROCEDURE FOR dbo.sp_observation_loop_check  
         @ps_parent_observation_id = :ps_parent_observation_id,   
         @ps_new_observation_id = :ps_new_observation_id,   
         @pi_loop = :li_loop OUT ;


EXECUTE lsp_observation_loop_check;
if not tf_check() then return true

FETCH lsp_observation_loop_check INTO :li_loop;
if not tf_check() then return true

CLOSE lsp_observation_loop_check;

if li_loop = 0 then
	return false
else
	return true
end if


end function

public function integer add_branch (long pl_from_handle, long pl_to_handle, string ps_where);long i, j
long ll_count
integer li_sts
string ls_from_observation_id
long ll_from_branch_id
string ls_from_description
string ls_to_observation_id
long ll_to_branch_id
string ls_to_description
integer li_sort_sequence
long ll_row
string ls_parent_observation_id
string ls_child_observation_id
long ll_age_range_id
string ls_sex
string ls_edit_service
string ls_location
integer li_result_sequence
integer li_result_sequence_2
string ls_description
integer li_followon_severity
string ls_followon_observation_id
long ll_branch_id
treeviewitem ltvi_to_item
treeviewitem ltvi_new_item
string ls_data
string ls_composite_flag
long ll_new_branch_id
long ll_new_handle
long ll_parent_handle

li_sts = convert_handle(pl_from_handle, ls_from_observation_id, ll_from_branch_id, ls_from_description)
li_sts = convert_handle(pl_to_handle, ls_to_observation_id, ll_to_branch_id, ls_to_description)

if upper(ps_where) = "INTO" then
	SELECT child_observation_id
	INTO :ls_parent_observation_id
	FROM c_Observation_Tree
	WHERE branch_id = :ll_to_branch_id;
	if not tf_check() then return -1
else
	SELECT parent_observation_id
	INTO :ls_parent_observation_id
	FROM c_Observation_Tree
	WHERE branch_id = :ll_to_branch_id;
	if not tf_check() then return -1
end if

SELECT child_observation_id,
		age_range_id,
		sex,
		edit_service,
		location,
		result_sequence,
		result_sequence_2,
		description,
		followon_severity,
		followon_observation_id
INTO  :ls_child_observation_id,
		:ll_age_range_id,
		:ls_sex,
		:ls_edit_service,
		:ls_location,
		:li_result_sequence,
		:li_result_sequence_2,
		:ls_description,
		:li_followon_severity,
		:ls_followon_observation_id
FROM c_Observation_Tree
WHERE branch_id = :ll_from_branch_id;
if not tf_check() then return -1

c_Observation_Tree.set_dataobject("dw_c_observation_tree")
ll_count = c_Observation_Tree.retrieve(ls_parent_observation_id)
if ll_count < 0 then return -1

// see if there are any null sort_sequence values
for i = 1 to ll_count
	li_sort_sequence = c_Observation_Tree.object.sort_sequence[i]
	if isnull(li_sort_sequence) then
		// If we find any null sort_sequence, then renumber all the rows
		for j = 1 to ll_count
			c_Observation_Tree.object.sort_sequence[j] = j
		next
		exit
	end if
next

// Set the sort_sequence to one higher than the highest in case we don't find
// the to_branch_id
li_sort_sequence = integer(c_Observation_Tree.object.sort_sequence[ll_count]) + 1

for i = 1 to ll_count
	ll_branch_id = c_Observation_Tree.object.branch_id[i]
	if ll_to_branch_id = ll_branch_id then
		li_sort_sequence = c_Observation_Tree.object.sort_sequence[i]
		if upper(ps_where) = "ABOVE" then
			for j = i to ll_count
				c_Observation_Tree.object.sort_sequence[j] = integer(c_Observation_Tree.object.sort_sequence[j]) + 1
			next
		else
			li_sort_sequence += 1
			for j = i + 1 to ll_count
				c_Observation_Tree.object.sort_sequence[j] = integer(c_Observation_Tree.object.sort_sequence[j]) + 1
			next
		end if
		exit
	end if
next

// Check for a loop
ls_composite_flag = datalist.observation_composite_flag(ls_child_observation_id)
if ls_composite_flag = "Y" then
	if loop_check(ls_parent_observation_id, ls_child_observation_id) then
		openwithparm(w_pop_message, "Adding the observation '" + ls_from_description + "' into the observation '" + ls_to_description + "' would create a loop and is not allowed.")
		return 0
	end if
end if


ll_row = c_Observation_Tree.insertrow(0)
c_Observation_Tree.object.parent_observation_id[ll_row] = ls_parent_observation_id
c_Observation_Tree.object.child_observation_id[ll_row] = ls_child_observation_id
c_Observation_Tree.object.age_range_id[ll_row] = ll_age_range_id
c_Observation_Tree.object.sex[ll_row] = ls_sex
c_Observation_Tree.object.edit_service[ll_row] = ls_edit_service
c_Observation_Tree.object.location[ll_row] = ls_location
c_Observation_Tree.object.result_sequence[ll_row] = li_result_sequence
c_Observation_Tree.object.result_sequence_2[ll_row] = li_result_sequence_2
c_Observation_Tree.object.description[ll_row] = ls_description
c_Observation_Tree.object.followon_severity[ll_row] = li_followon_severity
c_Observation_Tree.object.followon_observation_id[ll_row] = ls_followon_observation_id
c_Observation_Tree.object.sort_sequence[ll_row] = li_sort_sequence

li_sts = c_Observation_Tree.update()
if li_sts < 0 then return -1

ll_new_branch_id = c_Observation_Tree.object.branch_id[ll_row]
// Now display the new item

ls_data = ls_from_observation_id + "|||" + string(ll_new_branch_id)
ls_composite_flag = datalist.observation_composite_flag(ls_from_observation_id)

ltvi_new_item.data = ls_data
ltvi_new_item.label = ls_from_description
if ls_composite_flag = "Y" then
	ltvi_new_item.children = true
	ltvi_new_item.PictureIndex = 1
	ltvi_new_item.SelectedPictureIndex = 1
elseif not isnull(ls_followon_observation_id) then
	ltvi_new_item.children = true
	ltvi_new_item.PictureIndex = 3
	ltvi_new_item.SelectedPictureIndex = 3
else
	ltvi_new_item.children = false
	ltvi_new_item.PictureIndex = 2
	ltvi_new_item.SelectedPictureIndex = 2
end if

ll_parent_handle = finditem(ParentTreeItem!, pl_to_handle)

CHOOSE CASE upper(ps_where)
	CASE "ABOVE"
		pl_to_handle = finditem(PreviousTreeItem!, pl_to_handle)
		if pl_to_handle < 0 then
			ll_new_handle = insertitemfirst(ll_parent_handle, ltvi_new_item)
		else
			ll_new_handle = insertitem(ll_parent_handle, pl_to_handle, ltvi_new_item)
		end if
	CASE "BELOW"
		ll_new_handle = insertitem(ll_parent_handle, pl_to_handle, ltvi_new_item)
	CASE "INTO"
		// Only insert the new item if the target has already been expanded
		li_sts = getitem(pl_to_handle, ltvi_to_item)
		if li_sts < 0 then return -1
		if ltvi_to_item.expandedonce then
			ll_new_handle = insertitemlast(pl_to_handle, ltvi_new_item)
		end if
END CHOOSE


return 1





end function

public subroutine drop_menu (long pl_handle);str_popup popup
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
str_observation_tree_branch lstr_branch

li_sts = convert_handle(pl_handle, ls_observation_id, ll_branch_id, ls_description)
if li_sts <= 0 then return

ls_composite_flag = datalist.observation_composite_flag(ls_observation_id)

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

if not isnull(ll_branch_id) then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit Constituent Observation Attributes"
	popup.button_titles[popup.button_count] = "Attributes"
	buttons[popup.button_count] = "ATTRIBUTES"
end if

if allow_editing then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Remove Observation From Parent Composite Observation"
	popup.button_titles[popup.button_count] = "Remove Observation"
	buttons[popup.button_count] = "REMOVE"
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
		popup.items[1] = ls_observation_id
		popup.items[2] = f_boolean_to_string(allow_editing)
		
		if ls_composite_flag = "Y" then
			openwithparm(w_composite_observation_definition, popup)
		else
			openwithparm(w_observation_definition, popup)
		end if
		
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		update_observation(pl_handle, popup_return.items[1], ll_branch_id, popup_return.descriptions[1])
	CASE "ATTRIBUTES"
		lstr_branch = datalist.observation_tree_branch(ll_branch_id)
		if isnull(lstr_branch.branch_id) then return
		openwithparm(w_observation_tree_attributes, lstr_branch)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		if popup_return.items[1] <> "OK" then return
		lstr_branch = popup_return.returnobject
		
		// Update the database
		li_sts = datalist.observation_tree_branch_update(lstr_branch)
		if li_sts <= 0 then
			log.log(this, "u_composite_observation.drop_menu:0104", "Error saving branch changes", 4)
			return
		end if

		// Update the description on the screen
		update_observation(pl_handle, ls_observation_id, ll_branch_id, lstr_branch.description)
	CASE "REMOVE"
		ls_temp = "Remove " + ls_description + "?"
		openwithparm(w_pop_ok, ls_temp)
		if message.doubleparm = 1 then
			DELETE c_Observation_Tree
			WHERE branch_id = :ll_branch_id;
			if not tf_check() then return
			deleteitem(pl_handle)
		end if
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return

end subroutine

on u_composite_observation.create
end on

on u_composite_observation.destroy
end on

event itempopulate;treeviewitem ltvi_parent_item
treeviewitem ltvi_new_item
integer li_sts
long i
string ls_parent_observation_id
string ls_observation_id
string ls_description
string ls_composite_flag
long ll_rows
long ll_new_handle
long ll_branch_id
string ls_data
string ls_temp
string ls_followon_observation_id
long ll_parent_branch_id
integer li_followon_severity

li_sts = getitem(handle, ltvi_parent_item)
if li_sts <= 0 then
	log.log(this, "u_composite_observation:item", "Error getting new treeview item (" + string(handle) + ")", 4)
	return 1
end if

f_split_string(string(ltvi_parent_item.data), "|||", ls_parent_observation_id, ls_temp)
if isnull(ls_temp) or trim(ls_temp) = "" then
	setnull(ll_parent_branch_id)
else
	ll_parent_branch_id = long(ls_temp)
end if

ls_composite_flag = datalist.observation_composite_flag(ls_parent_observation_id)
if ls_composite_flag = "Y" then
	c_Observation_Tree.set_dataobject("dw_observation_tree_edit_list")
	ll_rows = c_observation_tree.retrieve(ls_parent_observation_id)
elseif not isnull(ll_parent_branch_id) then
	// If the parent composite flag isn't "Y" then we can assume that the
	// child will be a followon observation
	SELECT followon_observation_id
	INTO :ls_followon_observation_id
	FROM c_Observation_Tree
	WHERE branch_id = :ll_parent_branch_id;
	if not tf_check() then return 1
	if sqlca.sqlcode = 100 then
		log.log(this, "u_composite_observation:item", "branch not found (" + string(ll_parent_branch_id) + ")", 4)
		return 1
	end if
	if isnull(ls_followon_observation_id) then
		log.log(this, "u_composite_observation:item", "No followon observation for branch (" + string(ll_parent_branch_id) + ")", 3)
		return 1
	end if
	
	ls_description = datalist.observation_description(ls_followon_observation_id)
	if isnull(ls_description) then
		log.log(this, "u_composite_observation:item", "Followon observation not found (" + string(ll_parent_branch_id) + ", " + ls_followon_observation_id + ")", 3)
		return 1
	end if

	ls_composite_flag = datalist.observation_composite_flag(ls_followon_observation_id)
	
	ltvi_new_item.data = ls_followon_observation_id
	ltvi_new_item.label = ls_description
	if ls_composite_flag = "Y" then
		ltvi_new_item.children = true
		ltvi_new_item.PictureIndex = 1
		ltvi_new_item.SelectedPictureIndex = 1
	else
		ltvi_new_item.children = false
		ltvi_new_item.PictureIndex = 2
		ltvi_new_item.SelectedPictureIndex = 2
	end if
	ll_new_handle = insertitemlast(handle, ltvi_new_item)
	return 0
else
	log.log(this, "u_composite_observation:item", "Not a composite observation and no branch_id", 3)
	return 1
end if

for i = 1 to ll_rows
	ls_observation_id = c_observation_tree.object.child_observation_id[i]
	ls_description = c_observation_tree.object.compute_description[i]
	ls_composite_flag = c_observation_tree.object.composite_flag[i]
	li_followon_severity = c_observation_tree.object.followon_severity[i]
	ls_followon_observation_id = c_observation_tree.object.followon_observation_id[i]
	ll_branch_id = c_observation_tree.object.branch_id[i]
	ls_data = ls_observation_id + "|||" + string(ll_branch_id)
	
	ltvi_new_item.data = ls_data
	ltvi_new_item.label = ls_description
	if ls_composite_flag = "Y" then
		ltvi_new_item.children = true
		ltvi_new_item.PictureIndex = 1
		ltvi_new_item.SelectedPictureIndex = 1
	elseif not isnull(ls_followon_observation_id) then
		ltvi_new_item.children = true
		ltvi_new_item.PictureIndex = 3
		ltvi_new_item.SelectedPictureIndex = 3
	else
		ltvi_new_item.children = false
		ltvi_new_item.PictureIndex = 2
		ltvi_new_item.SelectedPictureIndex = 2
	end if
	ll_new_handle = insertitemlast(handle, ltvi_new_item)
next

return 0

end event

event selectionchanged;if oldhandle <> 0 then
	if allow_editing then observation_menu(newhandle)
end if

end event

event doubleclicked;if allow_editing then observation_menu(handle)

end event

event rightclicked;if allow_editing then observation_menu(handle)

end event

event constructor;c_Observation_Tree = CREATE u_ds_data


end event

event destructor;DESTROY c_Observation_Tree

end event

