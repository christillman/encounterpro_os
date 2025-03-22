$PBExportHeader$u_dw_display_script_list.sru
forward
global type u_dw_display_script_list from u_dw_pick_list
end type
end forward

global type u_dw_display_script_list from u_dw_pick_list
integer width = 1883
string dataobject = "dw_pick_top20_display_script"
boolean border = false
event display_scripts_loaded ( string ps_description )
end type
global u_dw_display_script_list u_dw_display_script_list

type variables
// Search Criteria
string context_object
string status = "OK"
string display_script
string top_20_user_id

// Behavior States
string mode = "EDIT"
boolean allow_editing

// Other states
string current_search = "TOP20"
// Values = TOP20, DISPLAY_SCRIPT

string top_20_code = "DISPLAY_SCRIPT"

string search_description

// Temp variable to hold the record currently being worked on
long top_20_sequence

window myparentwindow

string script_type = "RTF"

string parent_config_object_id
boolean show_all = false

end variables

forward prototypes
public function string pick_top_20_code ()
public function integer remove_top_20 (long pl_row)
public function integer retrieve_short_list (string ps_top_20_user_id)
public function integer search ()
public function integer search_top_20 ()
public function integer search_description (string ps_description)
public function integer sort_rows ()
public function integer search_description ()
public function integer search_top_20 (boolean pb_personal_list)
public function integer move_row (long pl_row)
public function integer initialize (string ps_top_20_code)
public function integer delete_display_script (long pl_row)
public subroutine display_script_menu (long pl_row)
public function integer retrieve_display_scripts (string ps_description)
end prototypes

public function string pick_top_20_code ();string ls_top_20_code


ls_top_20_code = top_20_code + "|" + context_object

if upper(script_type) <> "RTF" then
	ls_top_20_code += "|" + script_type
end if

if not isnull(parent_config_object_id) and not show_all then
	ls_top_20_code += "|" + right(parent_config_object_id, 63 - len(ls_top_20_code) )
end if

ls_top_20_code = left(ls_top_20_code, 64)

return ls_top_20_code

end function

public function integer remove_top_20 (long pl_row);integer li_sts

if current_search <> "TOP20" then return 0

deleterow(pl_row)
li_sts = update()

return li_sts

end function

public function integer retrieve_short_list (string ps_top_20_user_id);string ls_temp
long ll_count

dataobject = "dw_pick_top20_display_script"
settransobject(sqlca)

ll_count = retrieve(ps_top_20_user_id, pick_top_20_code())

last_page = 0
set_page(1, ls_temp)

this.event POST display_scripts_loaded(search_description)

return ll_count

end function

public function integer search ();integer li_sts
string ls_null

setnull(ls_null)


CHOOSE CASE current_search
	CASE "TOP20"
		li_sts = retrieve_short_list(top_20_user_id)
	CASE "DISPLAY_SCRIPT"
		li_sts = retrieve_display_scripts(display_script)
END CHOOSE


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

li_sts = retrieve_short_list(top_20_user_id)
if li_sts < 0 then return -1
if li_sts = 0 then
	top_20_user_id = current_user.common_list_id()
	search_description = "Common List"
	li_sts = retrieve_short_list(top_20_user_id)
	if li_sts < 0 then return -1
end if

return li_sts

end function

public function integer search_description (string ps_description);string ls_null
integer li_sts

setnull(ls_null)

if isnull(ps_description) or ps_description = "" then
	display_script = "%"
	search_description = "<All>"
else
	display_script = "%" + ps_description + "%"
	search_description = 'Contains "' + ps_description + '"'
end if

current_search = "DISPLAY_SCRIPT"

li_sts = retrieve_display_scripts(display_script)
if li_sts < 0 then return -1

return li_sts


end function

public function integer sort_rows ();integer li_sts
integer i

if current_search <> "TOP20" then return 0

clear_selected()

setsort("description a")
sort()

for i = 1 to rowcount()
	object.sort_sequence[i] = i
next

li_sts = update()

setsort("sort_sequence a")

return 1

end function

public function integer search_description ();string ls_null
long ll_count
str_popup_return popup_return
integer li_sts

setnull(ls_null)

open(w_pop_get_string_abc, myparentwindow)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

display_script = popup_return.items[1]
search_description = popup_return.descriptions[1]
	
current_search = "DISPLAY_SCRIPT"

li_sts = retrieve_display_scripts(display_script)
if li_sts < 0 then return -1

return li_sts


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

li_sts = retrieve_short_list(top_20_user_id)
if li_sts < 0 then return -1

if li_sts = 0 and pb_personal_list then
	openwithparm(w_pop_yes_no, "Your personal list is empty.  Do you wish to start with a copy of the common list?", myparentwindow)
	popup_return = message.powerobjectparm
	if popup_return.item = "YES" then
		f_copy_top_20_common_list(current_user.user_id, current_user.specialty_id, top_20_code)
		li_sts = retrieve_short_list(top_20_user_id)
		if li_sts < 0 then return -1
	end if
end if


return li_sts


end function

public function integer move_row (long pl_row);str_popup popup
string ls_user_id
long i
string ls_drug_id
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

openwithparm(w_pick_list_sort, popup, myparentwindow)

li_sts = update()

if ll_row <= 0 then
	clear_selected()
end if

return 1
end function

public function integer initialize (string ps_top_20_code);powerobject lo_object
integer li_iterations

top_20_code = ps_top_20_code

if parent_config_object_id = "" then setnull(parent_config_object_id)

if user_list.is_user_service(current_user.user_id, "CONFIG_DISPLAY_SCRIPT") then
	allow_editing = true
else
	allow_editing = false
end if

settransobject(sqlca)
myparentwindow = f_getparentwindow(this)

return 1

end function

public function integer delete_display_script (long pl_row);long ll_display_script_id


ll_display_script_id = object.display_script_id[pl_row]

UPDATE c_Display_Script
SET status = 'NA'
WHERE display_script_id = :ll_display_script_id;
if not tf_check() then return -1

return 1

end function

public subroutine display_script_menu (long pl_row);String		buttons[]
String 		ls_drug_id,ls_temp
String 		ls_description,ls_null
String		ls_top_20_code
Integer		button_pressed, li_sts, li_service_count
Long			ll_display_script_id

window 				lw_pop_buttons
w_display_script_edit lw_edit_window
str_popup 			popup
str_popup_return 	popup_return
w_window_base		lw_window

integer li_count
boolean lb_local_only
string ls_id
long ll_new_display_script_id

Setnull(ls_null)

ll_display_script_id = object.display_script_id[pl_row]

// See if there's a version of this display_script not owned locally
SELECT count(*)
INTO :li_count
FROM c_display_script w1
	INNER JOIN c_display_script w2
	ON w1.id = w2.id
WHERE w1.display_script_id = :ll_display_script_id
AND w2.owner_id <> :sqlca.customer_id;
if not tf_check() then return

if li_count > 0 then
	lb_local_only = false
else
	lb_local_only = true
end if

if current_search <> "TOP20" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Add drug to personal Short List List"
	popup.button_titles[popup.button_count] = "Personal Short List"
	buttons[popup.button_count] = "TOP20PERSONAL"
end if

if current_search <> "TOP20" and current_user.check_privilege("Edit Common Short Lists") then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Add drug to common Short List List"
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

//if allow_editing then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button17.bmp"
//	popup.button_helps[popup.button_count] = "Edit Display Script"
//	popup.button_titles[popup.button_count] = "Edit"
//	buttons[popup.button_count] = "EDIT"
//else
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button17.bmp"
//	popup.button_helps[popup.button_count] = "Review Display Script"
//	popup.button_titles[popup.button_count] = "Review"
//	buttons[popup.button_count] = "EDIT"
//end if
//
//if allow_editing then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button13.bmp"
//	popup.button_helps[popup.button_count] = "Delete Procedure"
//	popup.button_titles[popup.button_count] = "Delete"
//	buttons[popup.button_count] = "DELETE"
//end if

if allow_editing and lb_local_only then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit Display Script"
	popup.button_titles[popup.button_count] = "Edit"
	buttons[popup.button_count] = "EDIT"
end if

if not lb_local_only then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Display/Edit Display Script"
	popup.button_titles[popup.button_count] = "Display"
	if allow_editing then popup.button_titles[popup.button_count] += "/Edit"
	buttons[popup.button_count] = "DISPLAY"
end if

if allow_editing then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Copy Display Script"
	popup.button_titles[popup.button_count] = "Copy"
	buttons[popup.button_count] = "COPY"
end if

if allow_editing and lb_local_only then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Delete Display Script"
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
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons", myparentwindow)
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
			ll_display_script_id = object.display_script_id[pl_row]
			li_sts = tf_add_personal_top_20(ls_top_20_code, ls_null, ls_null, ls_null, ll_display_script_id)
		end if
	CASE "TOP20COMMON"
		ls_top_20_code = pick_top_20_code()
		if not isnull(ls_top_20_code) then
			ll_display_script_id = object.display_script_id[pl_row]
			li_sts = tf_add_common_top_20(ls_top_20_code, ls_null, ls_null, ls_null, ll_display_script_id)
		end if
	CASE "REMOVE"
		li_sts = remove_top_20(pl_row)
		if li_sts > 0 then
			recalc_page(ls_temp)
		end if
	CASE "MOVE"
		li_sts = move_row(pl_row)
	CASE "SORT"
		// Clear the temp variable so the row isn't re-selected
		setnull(top_20_sequence)
		li_sts = sort_rows()
		search()
	CASE "EDIT"
		openwithparm(lw_edit_window, ll_display_script_id, "w_display_script_edit", myparentwindow)
	CASE "DISPLAY"
		popup.items[1] = string(ll_display_script_id)
		popup.items[2] = f_boolean_to_string(allow_editing)
		popup.items[3] = parent_config_object_id
		popup.data_row_count = 3
		openwithparm(lw_window, popup, "w_display_script_config", myparentwindow)
	CASE "DELETE"
		UPDATE c_display_script
		SET status = 'NA'
		WHERE display_script_id =:ll_display_script_id;
		if not tf_check() then return
		deleterow(pl_row)
	CASE "COPY"
		ls_description = f_popup_prompt_string("Please enter a description for the new display script")
		if len(ls_description) > 0 then
			ll_new_display_script_id = sqlca.sp_local_copy_display_script(ll_display_script_id, ls_null, ls_description, parent_config_object_id)
			if not tf_check() then return
			if ll_new_display_script_id <= 0 then return

			// Edit the new display_script
			openwithparm(lw_edit_window, ll_new_display_script_id, "w_display_script_edit", myparentwindow)
			return
		end if
//	CASE "DELETE"
//		ls_temp = "Delete " + object.description[pl_row] + "?"
//		openwithparm(w_pop_ok, ls_temp, myparentwindow)
//		if message.doubleparm = 1 then
//			li_sts = delete_display_script(pl_row)
//			if li_sts > 0 then deleterow(pl_row)
//			recalc_page(ls_temp)
//		end if
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

Return

end subroutine

public function integer retrieve_display_scripts (string ps_description);string ls_temp
long ll_count
string ls_parent_config_object_id

dataobject = "dw_sp_display_script_search"
settransobject(sqlca)

if show_all then
	setnull(ls_parent_config_object_id)
else
	ls_parent_config_object_id = parent_config_object_id
end if

ll_count = retrieve( &
						context_object, &
						ps_description, &
						status, &
						script_type, &
						ls_parent_config_object_id)

last_page = 0
set_page(1, ls_temp)

this.event POST display_scripts_loaded(search_description)

return ll_count

end function

on u_dw_display_script_list.create
call super::create
end on

on u_dw_display_script_list.destroy
call super::destroy
end on

event computed_clicked;integer li_selected_flag
long ll_row

setnull(top_20_sequence)

if mode = "PICK" then
	if current_search = "TOP20" then
		top_20_sequence = object.top_20_sequence[clicked_row]
	end if
	
	li_selected_flag = object.selected_flag[clicked_row]
	
	object.selected_flag[clicked_row] = 1
	display_script_menu(clicked_row)
	
	clear_selected()
	
	if li_selected_flag > 0 and mode = "PICK" then
		if current_search = "TOP20" then
			if isnull(top_20_sequence) then
				ll_row = 0
			else
				ll_row = find("top_20_sequence=" + string(top_20_sequence), 1, rowcount())
			end if
		else
			ll_row = clicked_row
		end if
		
		if ll_row > 0 then object.selected_flag[ll_row] = li_selected_flag
	else
		clear_selected()
	end if
end if


end event

event clicked;call super::clicked;integer li_selected_flag
long ll_row

setnull(top_20_sequence)
ll_row = row
if ll_row <= 0 then return

if mode = "EDIT" and allow_editing then
	if current_search = "TOP20" then
		top_20_sequence = object.top_20_sequence[ll_row]
	end if
	
	li_selected_flag = object.selected_flag[ll_row]
	
	object.selected_flag[ll_row] = 1
	display_script_menu(ll_row)
	
	clear_selected()
end if


end event

event retrieveend;call super::retrieveend;object.description.width = width - 251
end event

