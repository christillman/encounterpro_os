$PBExportHeader$u_dw_observation_list.sru
forward
global type u_dw_observation_list from u_dw_pick_list
end type
end forward

global type u_dw_observation_list from u_dw_pick_list
integer width = 1883
string dataobject = "dw_sp_observation_search"
boolean border = false
event observations_loaded ( string ps_description )
event observation_selected ( string ps_observation_id,  string ps_observation_description )
end type
global u_dw_observation_list u_dw_observation_list

type variables
// Search Criteria
string treatment_type
string original_treatment_type
string specialty_id
string status = "OK"
string composite_flag
// Search States
string collect_cpt_code
string perform_cpt_code
string description
string observation_category_id
string top_20_user_id
string all_or_common = "Specialty"

// Behavior States
string mode = "EDIT"
boolean allow_editing

string current_search = "TOP20"
// Values = TOP20, CATEGORY, PROCEDURE, DESCRIPTION

string top_20_code

string search_description
string top_20_prefix = "TEST"

// Temp variable to hold the record currently being worked on
string observation_id



end variables

forward prototypes
public function integer delete_observation (long pl_row)
public function integer search_description (string ps_description)
public function integer search_description ()
public function integer search_procedure ()
public function integer search_top_20 ()
public function integer search ()
public function integer search_category ()
public function integer move_row (long pl_row)
public function integer remove_top_20 (long pl_row)
public function string pick_top_20_code ()
public function integer retrieve_observations (string ps_top_20_user_id, string ps_observation_category_id, string ps_collect_cpt_code, string ps_perform_cpt_code, string ps_description)
public function integer sort_rows ()
public function integer search_top_20 (boolean pb_personal_list)
public subroutine toggle_all_or_common ()
public function integer initialize (string ps_treatment_type)
public subroutine observation_menu (long pl_row)
public subroutine toggle_status ()
end prototypes

public function integer delete_observation (long pl_row);string ls_observation_id

 DECLARE lsp_delete_observation_definition PROCEDURE FOR dbo.sp_delete_observation_definition  
         @ps_observation_id = :ls_observation_id  ;


ls_observation_id = object.observation_id[pl_row]

EXECUTE lsp_delete_observation_definition;
if not tf_check() then return -1

return 1

end function

public function integer search_description (string ps_description);string ls_null
integer li_sts

setnull(ls_null)

if isnull(ps_description) or ps_description = "" then
	description = "%"
	search_description = "<All>"
else
	description = "%" + ps_description + "%"
	search_description = 'Contains "' + ps_description + '"'
end if

current_search = "DESCRIPTION"

li_sts = retrieve_observations(ls_null, ls_null, ls_null, ls_null, description)
if li_sts < 0 then return -1

return li_sts


end function

public function integer search_description ();string ls_null
long ll_count
str_popup_return popup_return
integer li_sts

setnull(ls_null)

open(w_pop_get_string_abc)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

description = popup_return.items[1]
search_description = popup_return.descriptions[1]

current_search = "DESCRIPTION"

li_sts = retrieve_observations(ls_null, ls_null, ls_null, ls_null, description)
if li_sts < 0 then return -1

return li_sts


end function

public function integer search_procedure ();str_popup_return popup_return
string ls_null
integer li_sts

setnull(ls_null)

open(w_pop_prompt_observation_cpt_code)
popup_return = message.powerobjectparm
if popup_return.item_count <> 2 then return 0

if popup_return.items[2] = "P" then
	setnull(collect_cpt_code)
	perform_cpt_code = popup_return.items[1]
	search_description = "Perform CPT = '" + perform_cpt_code + "'"
else
	setnull(perform_cpt_code)
	collect_cpt_code = popup_return.items[1]
	search_description = "Collect CPT = '" + collect_cpt_code + "'"
end if

current_search = "PROCEDURE"

li_sts = retrieve_observations(ls_null, ls_null, collect_cpt_code, perform_cpt_code, ls_null)
if li_sts < 0 then return -1

return li_sts


end function

public function integer search_top_20 ();str_popup popup
str_popup_return popup_return
string ls_null
integer li_sts

setnull(ls_null)

current_search = "TOP20"

top_20_user_id = current_user.user_id
search_description = "Personal List"

li_sts = retrieve_observations(top_20_user_id, ls_null, ls_null, ls_null, ls_null)
if li_sts < 0 then return -1
if li_sts = 0 then
	top_20_user_id = current_user.common_list_id()
	search_description = "Common List"
	li_sts = retrieve_observations(top_20_user_id, ls_null, ls_null, ls_null, ls_null)
	if li_sts < 0 then return -1
end if

return li_sts

end function

public function integer search ();integer li_sts
string ls_null

setnull(ls_null)


CHOOSE CASE current_search
	CASE "TOP20"
		if isnull(top_20_user_id) then
			search_top_20()
		else
			li_sts = retrieve_observations(top_20_user_id, ls_null, ls_null, ls_null, ls_null)
		end if
	CASE "CATEGORY"
		li_sts = retrieve_observations(ls_null, observation_category_id, ls_null, ls_null, ls_null)
	CASE "PROCEDURE"
		li_sts = retrieve_observations(ls_null, ls_null, collect_cpt_code, perform_cpt_code, ls_null)
	CASE "DESCRIPTION"
		li_sts = retrieve_observations(ls_null, ls_null, ls_null, ls_null, description)
END CHOOSE


return li_sts

end function

public function integer search_category ();str_popup popup
str_popup_return popup_return
string ls_null
integer li_sts

setnull(ls_null)

popup.dataobject = "dw_observation_category_list"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.argument_count = 2
popup.argument[1] = treatment_type
popup.argument[2] = specialty_id
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

observation_category_id = popup_return.items[1]
search_description = popup_return.descriptions[1]

current_search = "CATEGORY"

li_sts = retrieve_observations(ls_null, observation_category_id, ls_null, ls_null, ls_null)
if li_sts < 0 then return -1

return li_sts


end function

public function integer move_row (long pl_row);str_popup popup
string ls_user_id
string ls_top_20_code
long ll_top_20_sequence
integer li_sort_sequence
long i
string ls_observation_id
string ls_description
string ls_null
long ll_null
long ll_row
integer li_sts

setnull(ls_null)
setnull(ll_null)

if pl_row <= 0 then return 0

if current_search <> "TOP20" then return 0

ll_row = get_selected_row()
if ll_row <= 0 then
	object.selected_flag[pl_row] = 1
end if

popup.objectparm = this

Openwithparm(w_pick_list_sort, popup)

// Then add them back in the new order
for i = 1 to rowcount()
	ll_top_20_sequence = object.top_20_sequence[i]
	li_sort_sequence = object.sort_sequence[i]
	
	// Update the sort_sequence in the database
	UPDATE u_top_20
	SET sort_sequence = :li_sort_sequence
	WHERE user_id = :top_20_user_id
	AND top_20_code = :top_20_code
	AND top_20_sequence = :ll_top_20_sequence;
	if not tf_check() then return -1
next

resetupdate()

if ll_row <= 0 then
	clear_selected()
end if

return 1

end function

public function integer remove_top_20 (long pl_row);long ll_top_20_sequence
string ls_user_id

if current_search <> "TOP20" then return 0

ll_top_20_sequence = object.top_20_sequence[pl_row]

if search_description = "Personal List" then
	ls_user_id = current_user.user_id
else
	ls_user_id = current_user.specialty_id
end if

DELETE FROM u_top_20
WHERE user_id = :ls_user_id
AND top_20_code = :top_20_code
AND top_20_sequence = :ll_top_20_sequence;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then return 0

return 1

end function

public function string pick_top_20_code ();string ls_treatment_type
str_popup popup
str_popup_return popup_return

if (original_treatment_type = treatment_type) or (isnull(original_treatment_type) and isnull(treatment_type)) then
	ls_treatment_type = treatment_type
elseif isnull(treatment_type) and not isnull(original_treatment_type) then
	ls_treatment_type = original_treatment_type
elseif isnull(original_treatment_type) and not isnull(treatment_type) then
	ls_treatment_type = treatment_type
else
	popup.data_row_count = 2
	popup.items[1] = "Add to " + datalist.treatment_type_description(original_treatment_type) + " Short List"
	popup.items[2] = "Add to " + datalist.treatment_type_description(treatment_type) + " Short List"
	openwithparm(w_pop_pick, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then
		setnull(ls_treatment_type)
	else
		if popup_return.item_indexes[1] = 1 then
			ls_treatment_type = original_treatment_type
		else
			ls_treatment_type = treatment_type
		end if
	end if
end if
If isnull(treatment_type) Then return top_20_prefix
	
return top_20_prefix + "_" + ls_treatment_type

end function

public function integer retrieve_observations (string ps_top_20_user_id, string ps_observation_category_id, string ps_collect_cpt_code, string ps_perform_cpt_code, string ps_description);string ls_procedure_id
string ls_in_context_flag
string ls_temp
long ll_count
string ls_specialty_id

if all_or_common = "All" then
	setnull(ls_specialty_id)
else
	ls_specialty_id = specialty_id
end if

setnull(ls_procedure_id)
setnull(ls_in_context_flag)

ll_count = retrieve( &
						treatment_type, &
						ps_observation_category_id, &
						ps_top_20_user_id, &
						ps_description, &
						ps_collect_cpt_code, &
						ps_perform_cpt_code, &
						ls_in_context_flag, &
						ls_specialty_id, &
						composite_flag, &
						status, &
						top_20_code)

last_page = 0
set_page(1, ls_temp)

this.event POST observations_loaded(search_description)

return ll_count

end function

public function integer sort_rows ();integer li_sts
integer i
long ll_top_20_sequence

if current_search <> "TOP20" then return 0

clear_selected()

setsort("description a")
sort()

for i = 1 to rowcount()
	ll_top_20_sequence = object.top_20_sequence[i]
	
	// Update the sort_sequence in the database
	UPDATE u_top_20
	SET sort_sequence = :i
	WHERE user_id = :top_20_user_id
	AND top_20_code = :top_20_code
	AND top_20_sequence = :ll_top_20_sequence;
	if not tf_check() then return -1
next

setsort("sort_sequence a, description a, observation_id a")

return 1

end function

public function integer search_top_20 (boolean pb_personal_list);str_popup popup
str_popup_return popup_return
string ls_null
integer li_sts

setnull(ls_null)

if pb_personal_list then
	top_20_user_id = current_user.user_id
	search_description = "Personal List"
else
	top_20_user_id = current_user.common_list_id()
	search_description = "Common List"
end if

current_search = "TOP20"

li_sts = retrieve_observations(top_20_user_id, ls_null, ls_null, ls_null, ls_null)
if li_sts < 0 then return -1

if li_sts = 0 and pb_personal_list then
	openwithparm(w_pop_yes_no, "Your personal list is empty.  Do you wish to start with a copy of the common list?")
	popup_return = message.powerobjectparm
	if popup_return.item = "YES" then
		f_copy_top_20_common_list(current_user.user_id, current_user.specialty_id, top_20_code)
		li_sts = retrieve_observations(top_20_user_id, ls_null, ls_null, ls_null, ls_null)
		if li_sts < 0 then return -1
	end if
end if

return li_sts


end function

public subroutine toggle_all_or_common ();if all_or_common = "All" then
	all_or_common = "Specialty"
else
	all_or_common = "All"
end if

search()

end subroutine

public function integer initialize (string ps_treatment_type);
treatment_type = ps_treatment_type

if original_treatment_type = "!!!" or mode = "EDIT" then original_treatment_type = treatment_type

if isnull(treatment_type) then
	top_20_code = top_20_prefix
else
	top_20_code = top_20_prefix + "_" + treatment_type
end if

if user_list.is_user_service(current_user.user_id, "CONFIG_OBSERVATIONS") then
	allow_editing = true
else
	allow_editing = false
end if

composite_flag = datalist.treatment_type_composite_flag(treatment_type)

settransobject(sqlca)

return 1

end function

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
string ls_null
long ll_null
string ls_top_20_code
str_observation_stack lstr_observation_stack
string ls_new_observation_id

w_composite_observation_definition lw_composite_observation_definition
w_observation_definition lw_observation_definition
w_observation_tree_display lw_observation_tree_display
w_observation_tree_navigate lw_observation_tree_navigate

setnull(ls_null)
setnull(ll_null)

ls_composite_flag = object.composite_flag[pl_row]

if current_search <> "TOP20" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Add Assessment to personal Short List List"
	popup.button_titles[popup.button_count] = "Personal Short List"
	buttons[popup.button_count] = "TOP20PERSONAL"
end if

if current_search <> "TOP20" and current_user.check_privilege("Edit Common Short Lists") then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Add Assessment to common Short List List"
	popup.button_titles[popup.button_count] = "Common Short List"
	buttons[popup.button_count] = "TOP20COMMON"
end if

if current_search = "TOP20" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Remove item from Short List"
	popup.button_titles[popup.button_count] = "Remove Short List"
	buttons[popup.button_count] = "REMOVE"
end if

if current_search = "TOP20" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonmove.bmp"
	popup.button_helps[popup.button_count] = "Move record up or down"
	popup.button_titles[popup.button_count] = "Move"
	buttons[popup.button_count] = "MOVE"
end if

if current_search = "TOP20" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonx3.bmp"
	popup.button_helps[popup.button_count] = "Sort Items Aphabetically"
	popup.button_titles[popup.button_count] = "Sort"
	buttons[popup.button_count] = "SORT"
end if

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

if ls_composite_flag = "Y" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_tree.bmp"
	popup.button_helps[popup.button_count] = "Display Composite Observation Tree"
	popup.button_titles[popup.button_count] = "Display Tree"
	buttons[popup.button_count] = "TREE"
end if

if ls_composite_flag = "Y" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_tree.bmp"
	popup.button_helps[popup.button_count] = "Select Child From Composite Observation Tree"
	popup.button_titles[popup.button_count] = "Select Child"
	buttons[popup.button_count] = "CHILD"
end if

if allow_editing then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonduplicate.bmp"
	popup.button_helps[popup.button_count] = "Duplicate Observation"
	popup.button_titles[popup.button_count] = "Duplicate Observation"
	buttons[popup.button_count] = "DUP"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonProperties.bmp"
	popup.button_helps[popup.button_count] = "Display all parent observations of this observation"
	popup.button_titles[popup.button_count] = "Display Parents"
	buttons[popup.button_count] = "PARENTS"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonProperties.bmp"
	popup.button_helps[popup.button_count] = "Display all categories of this observation"
	popup.button_titles[popup.button_count] = "Display Categories"
	buttons[popup.button_count] = "CATEGORIES"
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
	CASE "TOP20PERSONAL"
		ls_top_20_code = pick_top_20_code()
		if not isnull(ls_top_20_code) then
			ls_description = object.description[pl_row]
			ls_observation_id = object.observation_id[pl_row]
			li_sts = tf_add_personal_top_20(ls_top_20_code, ls_description, ls_observation_id, ls_null, ll_null)
		end if
	CASE "TOP20COMMON"
		ls_top_20_code = pick_top_20_code()
		if not isnull(ls_top_20_code) then
			ls_description = object.description[pl_row]
			ls_observation_id = object.observation_id[pl_row]
			li_sts = tf_add_common_top_20(ls_top_20_code, ls_description, ls_observation_id, ls_null, ll_null)
		end if
	CASE "REMOVE"
		li_sts = remove_top_20(pl_row)
		if li_sts > 0 then
			deleterow(pl_row)
			recalc_page(ls_temp)
		end if
	CASE "MOVE"
		li_sts = move_row(pl_row)
	CASE "SORT"
		// Clear the temp variable so the row isn't re-selected
		setnull(observation_id)
		li_sts = sort_rows()
		search()
	CASE "EDIT"
		popup.data_row_count = 2
		popup.items[1] = object.observation_id[pl_row]
		popup.items[2] = f_boolean_to_string(allow_editing)
		
		if ls_composite_flag = "Y" then
			openwithparm(lw_composite_observation_definition, popup)
		else
			openwithparm(lw_observation_definition, popup)
		end if
		
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		setitem(pl_row, "Observation_id", popup_return.items[1])
		setitem(pl_row, "description", popup_return.descriptions[1])
	CASE "TREE"
		popup.data_row_count = 2
		popup.items[1] = object.observation_id[pl_row]
		popup.items[2] = f_boolean_to_string(allow_editing)
		openwithparm(lw_observation_tree_display, popup)
	CASE "CHILD"
		popup.data_row_count = 2
		popup.items[1] = object.observation_id[pl_row]
		popup.items[2] = f_boolean_to_string(allow_editing)
		openwithparm(lw_observation_tree_navigate, popup)
		lstr_observation_stack = message.powerobjectparm
		this.event POST observation_selected( &
										lstr_observation_stack.observation_id[lstr_observation_stack.depth], &
										lstr_observation_stack.description[lstr_observation_stack.depth] )
	CASE "DUP"
		popup.data_row_count = 0
		popup.item = object.description[pl_row]
		popup.title = "Enter description for duplicated observation"
		popup.displaycolumn = 80
		openwithparm(w_pop_prompt_string, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		
		ls_observation_id = object.observation_id[pl_row]
		sqlca.sp_duplicate_observation(ls_observation_id, popup_return.items[1], current_user.user_id, ls_new_observation_id)
		if not tf_check() then return
		if len(ls_new_observation_id) > 0 then
			openwithparm(w_pop_yes_no, "Duplicate observation successfully created.  Do you wish to edit the duplicate now?")
			popup_return = message.powerobjectparm
			if popup_return.item = "YES" then
				popup.data_row_count = 2
				popup.items[1] = ls_new_observation_id
				popup.items[2] = f_boolean_to_string(allow_editing)
				
				if ls_composite_flag = "Y" then
					openwithparm(lw_composite_observation_definition, popup)
				else
					openwithparm(lw_observation_definition, popup)
				end if
			end if
		end if
	CASE "DELETE"
		ls_temp = "Delete " + object.description[pl_row] + "?"
		openwithparm(w_pop_ok, ls_temp)
		if message.doubleparm = 1 then
			li_sts = delete_observation(pl_row)
			if li_sts > 0 then deleterow(pl_row)
			recalc_page(ls_temp)
		end if
	CASE "PARENTS"
		popup.dataobject = "dw_parent_observation_display_list"
		popup.argument_count = 1
		popup.argument[1] = object.observation_id[pl_row]
		popup.datacolumn = 1
		popup.displaycolumn = 3
		openwithparm(w_pop_pick, popup)
	CASE "CATEGORIES"
		popup.dataobject = "dw_observation_categories_in_list"
		popup.argument_count = 1
		popup.argument[1] = object.observation_id[pl_row]
		popup.datacolumn = 1
		popup.displaycolumn = 6
		openwithparm(w_pop_pick, popup)
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return

end subroutine

public subroutine toggle_status ();if status = "OK" then
	status = "NA"
else
	status = "OK"
end if

search()

end subroutine

on u_dw_observation_list.create
call super::create
end on

on u_dw_observation_list.destroy
call super::destroy
end on

event selected(long selected_row);call super::selected;string ls_observation_id
string ls_description

ls_observation_id = object.observation_id[selected_row]
ls_description = object.description[selected_row]

this.event TRIGGER observation_selected(ls_observation_id, ls_description)

clear_selected()

end event

event computed_clicked(long clicked_row);call super::computed_clicked;integer li_selected_flag
string ls_observation_id
long ll_row

setnull(observation_id)

if allow_editing then
	ls_observation_id = object.observation_id[clicked_row]
	li_selected_flag = object.selected_flag[clicked_row]
	
	object.selected_flag[clicked_row] = 1
	observation_menu(clicked_row)
	
	clear_selected()
	
	// If we're in PICK mode and there was already a row selected, then find it again and select it
	if li_selected_flag > 0 and mode = "PICK" and not isnull(observation_id) then
		ll_row = find("observation_id='" + ls_observation_id + "'", 1, rowcount())
		if ll_row > 0 then object.selected_flag[ll_row] = li_selected_flag
	end if
end if


end event

event constructor;original_treatment_type = "!!!"
setnull(treatment_type)
setnull(specialty_id)
setnull(top_20_user_id)

end event

event retrieveend;call super::retrieveend;object.description.width = width - 233

end event

