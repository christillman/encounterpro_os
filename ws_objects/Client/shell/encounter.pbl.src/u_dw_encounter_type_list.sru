$PBExportHeader$u_dw_encounter_type_list.sru
forward
global type u_dw_encounter_type_list from u_dw_pick_list
end type
end forward

global type u_dw_encounter_type_list from u_dw_pick_list
integer width = 1883
string dataobject = "dw_pick_top20_encounter_type"
boolean border = false
event encounter_types_loaded ( string ps_description )
end type
global u_dw_encounter_type_list u_dw_encounter_type_list

type variables
// Search Criteria
string specialty_id
string status = "OK"
string description
string indirect_flag
string top_20_user_id
string prefix = "encounter_type"
// Behavior States
string mode = "EDIT"
boolean allow_editing

// Other states
string current_search = "TOP20"
// Values = TOP20, CATEGORY, ICD, DESCRIPTION

string top_20_code

string search_description

// Temp variable to hold the record currently being worked on
long top_20_sequence

end variables

forward prototypes
public function integer search_top_20 ()
public function integer delete_encounter_type (long pl_row)
public function integer search ()
public function integer search_description ()
public function integer search_description (string ps_description)
public function integer search_top_20 (boolean pb_personal_list)
public function integer remove_top_20 (long pl_row)
public function integer retrieve_short_list (string ps_top_20_user_id)
public function integer move_row (long pl_row)
public function integer sort_rows ()
public function integer set_encounter_type_specialty (long pl_row, string ps_flag)
public subroutine encounter_type_menu (long pl_row)
public function integer retrieve_encounter_types (string ps_description)
public function integer initialize (string ps_indirect_flag)
public function integer initialize (string ps_indirect_flag, string ps_top_20_code)
end prototypes

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

public function integer delete_encounter_type (long pl_row);string ls_encounter_type

ls_encounter_type = object.encounter_type[pl_row]

UPDATE c_Encounter_Type
SET status = 'NA'
WHERE encounter_type = :ls_encounter_type;
if not tf_check() then return -1

deleterow(pl_row)

return 1

end function

public function integer search ();integer li_sts
string ls_null

setnull(ls_null)


CHOOSE CASE current_search
	CASE "TOP20"
		li_sts = retrieve_short_list(top_20_user_id)
	CASE "DESCRIPTION"
		li_sts = retrieve_encounter_types(description)
END CHOOSE


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

li_sts = retrieve_encounter_types(description)
if li_sts < 0 then return -1

return li_sts


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

li_sts = retrieve_encounter_types(description)
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
	openwithparm(w_pop_yes_no, "Your personal list is empty.  Do you wish to start with a copy of the common list?")
	popup_return = message.powerobjectparm
	if popup_return.item = "YES" then
		f_copy_top_20_common_list(current_user.user_id, current_user.specialty_id, top_20_code)
		li_sts = retrieve_short_list(top_20_user_id)
		if li_sts < 0 then return -1
	end if
end if


return li_sts


end function

public function integer remove_top_20 (long pl_row);integer li_sts

if current_search <> "TOP20" then return 0

deleterow(pl_row)
li_sts = update()

return li_sts

end function

public function integer retrieve_short_list (string ps_top_20_user_id);string ls_temp
long ll_count

dataobject = "dw_pick_top20_encounter_type"
settransobject(sqlca)

ll_count = retrieve(ps_top_20_user_id, top_20_code)

last_page = 0
set_page(1, ls_temp)

this.event POST encounter_types_loaded(search_description)

return ll_count

end function

public function integer move_row (long pl_row);str_popup popup
string ls_user_id
long i
string ls_encounter_type
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

openwithparm(w_pick_list_sort, popup)

li_sts = update()

if ll_row <= 0 then
	clear_selected()
end if

return 1

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

public function integer set_encounter_type_specialty (long pl_row, string ps_flag);string ls_encounter_type

// DECLARE lsp_set_encounter_type_specialty PROCEDURE FOR dbo.sp_set_encounter_type_specialty  
//         @ps_encounter_type = :ls_encounter_type,   
//         @ps_specialty_id = :current_user.specialty_id,   
//         @ps_flag = :ps_flag  ;


if pl_row <= 0 or isnull(pl_row) then return 0
if isnull(current_user.specialty_id) then return 0

ls_encounter_type = object.encounter_type[pl_row]
SQLCA.sp_set_encounter_type_specialty   ( &
         ls_encounter_type,    &
         current_user.specialty_id,    &
         ps_flag  );
//EXECUTE lsp_set_encounter_type_specialty;
if not tf_check() then return -1

return 1


end function

public subroutine encounter_type_menu (long pl_row);str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons
string ls_user_id
integer li_update_flag
string ls_encounter_type
string ls_temp
string ls_description
string ls_null
long ll_null

setnull(ls_null)
setnull(ll_null)

ls_encounter_type = object.encounter_type[pl_row]

if current_search <> "TOP20" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Add Procedure to personal Short List List"
	popup.button_titles[popup.button_count] = "Personal Short List"
	buttons[popup.button_count] = "TOP20PERSONAL"
end if

if current_search <> "TOP20" and current_user.check_privilege("Edit Common Short Lists") then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Add Procedure to common Short List List"
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
	popup.button_helps[popup.button_count] = "Edit Appointment Type"
	popup.button_titles[popup.button_count] = "Edit Appointment Type"
	buttons[popup.button_count] = "EDIT"
else
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Display Appointment Type"
	popup.button_titles[popup.button_count] = "Display Appointment Type"
	buttons[popup.button_count] = "EDIT"
end if

if allow_editing then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Delete Appointment Type"
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
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	button_pressed = message.doubleparm
	if button_pressed < 1 or button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	button_pressed = 1
else
	return
end if

ls_description = object.description[pl_row]

CHOOSE CASE buttons[button_pressed]
	CASE "TOP20PERSONAL"
		ls_encounter_type = object.encounter_type[pl_row]
		li_sts = tf_add_personal_top_20(top_20_code, ls_description, ls_encounter_type, ls_null, ll_null)
	CASE "TOP20COMMON"
		ls_encounter_type = object.encounter_type[pl_row]
		li_sts = tf_add_common_top_20(top_20_code, ls_description, ls_encounter_type, ls_null, ll_null)
	CASE "REMOVE"
		li_sts = remove_top_20(pl_row)
		if li_sts > 0 then
			recalc_page(ls_temp)
		end if
	CASE "MOVE"
		li_sts = move_row(pl_row)
		recalc_page(ls_temp)
	CASE "SORT"
		// Clear the temp variable so the row isn't re-selected
		setnull(top_20_sequence)
		li_sts = sort_rows()
		search()
	CASE "EDIT"
		popup.items[1] = ls_encounter_type
		popup.data_row_count = 1
		openwithparm(w_Encounter_Type_definition, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		object.description[pl_row] = popup_return.descriptions[1]
	CASE "DELETE"
		ls_temp = "Are you sure you wish to delete the appointment type '" + ls_description + "'?"
		openwithparm(w_pop_yes_no, ls_temp)
		popup_return = message.powerobjectparm
		if popup_return.item = "YES" then
			li_sts = delete_encounter_type(pl_row)
			if li_sts > 0 then deleterow(pl_row)
			recalc_page(ls_temp)
		end if
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return

end subroutine

public function integer retrieve_encounter_types (string ps_description);string ls_temp
long ll_count

dataobject = "dw_sp_encounter_type_search"
settransobject(sqlca)

ll_count = retrieve( &
						indirect_flag, &
						ps_description, &
						status )

last_page = 0
set_page(1, ls_temp)

this.event POST encounter_types_loaded(search_description)

return ll_count

end function

public function integer initialize (string ps_indirect_flag);return initialize(ps_indirect_flag, "")


end function

public function integer initialize (string ps_indirect_flag, string ps_top_20_code);
CHOOSE CASE upper(ps_indirect_flag)
	CASE "I"
		indirect_flag = "I"
	CASE "N"
		indirect_flag = "N"
	CASE ELSE
		indirect_flag = "D"
END CHOOSE

if isnull(ps_top_20_code) or trim(ps_top_20_code) = "" then
	top_20_code = "encounter_type_" + indirect_flag
else
	top_20_code = ps_top_20_code
end if


if user_list.is_user_service(current_user.user_id, "CONFIG_ENCOUNTER_TYPES") then
	allow_editing = true
else
	allow_editing = false
end if

settransobject(sqlca)

return 1

end function

on u_dw_encounter_type_list.create
call super::create
end on

on u_dw_encounter_type_list.destroy
call super::destroy
end on

event computed_clicked;integer li_selected_flag
long ll_row

setnull(top_20_sequence)

if allow_editing and mode = "PICK" then
	if current_search = "TOP20" then
		top_20_sequence = object.top_20_sequence[clicked_row]
	end if
	
	li_selected_flag = object.selected_flag[clicked_row]
	
	object.selected_flag[clicked_row] = 1
	encounter_type_menu(clicked_row)
	
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

if allow_editing and mode = "EDIT" then
	if current_search = "TOP20" then
		top_20_sequence = object.top_20_sequence[row]
	end if
	
	li_selected_flag = object.selected_flag[row]
	
	object.selected_flag[row] = 1
	encounter_type_menu(row)
	
	clear_selected()
	
	if li_selected_flag > 0 and mode = "PICK" then
		if current_search = "TOP20" then
			if isnull(top_20_sequence) then
				ll_row = 0
			else
				ll_row = find("top_20_sequence=" + string(top_20_sequence), 1, rowcount())
			end if
		else
			ll_row = row
		end if
		
		if ll_row > 0 then object.selected_flag[ll_row] = li_selected_flag
	else
		clear_selected()
	end if
end if


end event

event retrieveend;call super::retrieveend;object.description.width = width - 260

end event

