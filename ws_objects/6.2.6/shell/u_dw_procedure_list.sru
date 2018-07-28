HA$PBExportHeader$u_dw_procedure_list.sru
forward
global type u_dw_procedure_list from u_dw_pick_list
end type
end forward

global type u_dw_procedure_list from u_dw_pick_list
integer width = 1883
string dataobject = "dw_pick_top20_procedure"
boolean border = false
event procedures_loaded ( string ps_description )
end type
global u_dw_procedure_list u_dw_procedure_list

type variables
// Search Criteria
string procedure_type
string original_procedure_type
string specialty_id
string status = "OK"
string cpt_code
string description
string procedure_category_id
string top_20_user_id

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
public function integer retrieve_procedures (string ps_procedure_category_id, string ps_description, string ps_icd_code)
public function integer search_description ()
public function integer delete_procedure (long pl_row)
public function integer remove_top_20 (long pl_row)
public function string pick_top_20_code ()
public function integer search_top_20 ()
public function integer search_top_20 (boolean pb_personal_list)
public function integer search_description (string ps_description)
public function integer search_cpt ()
public function integer search ()
public function integer retrieve_short_list (string ps_top_20_user_id)
public function integer search_category ()
public function integer move_row (long pl_row)
public function integer sort_rows ()
public function integer initialize (string ps_procedure_type)
public subroutine procedure_menu (long pl_row)
end prototypes

public function integer retrieve_procedures (string ps_procedure_category_id, string ps_description, string ps_icd_code);string ls_temp
long ll_count

dataobject = "dw_sp_procedure_search"
settransobject(sqlca)

ll_count = retrieve( &
						procedure_type, &
						ps_procedure_category_id, &
						ps_description, &
						ps_icd_code, &
						specialty_id, &
						status )

last_page = 0
set_page(1, ls_temp)

this.event POST procedures_loaded(search_description)

return ll_count

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

li_sts = retrieve_procedures(ls_null, description, ls_null)
if li_sts < 0 then return -1

return li_sts


end function

public function integer delete_procedure (long pl_row);string ls_procedure_id

 DECLARE lsp_delete_procedure_definition PROCEDURE FOR dbo.sp_delete_procedure_definition  
         @ps_procedure_id = :ls_procedure_id  ;


ls_procedure_id = object.procedure_id[pl_row]

EXECUTE lsp_delete_procedure_definition;
if not tf_check() then return -1

return 1

end function

public function integer remove_top_20 (long pl_row);integer li_sts

if current_search <> "TOP20" then return 0

deleterow(pl_row)
li_sts = update()

return li_sts

end function

public function string pick_top_20_code ();string ls_procedure_type
str_popup popup
str_popup_return popup_return

if (original_procedure_type = procedure_type) or (isnull(original_procedure_type) and isnull(procedure_type)) then
	ls_procedure_type = procedure_type
elseif isnull(procedure_type) and not isnull(original_procedure_type) then
	ls_procedure_type = original_procedure_type
elseif isnull(original_procedure_type) and not isnull(procedure_type) then
	ls_procedure_type = procedure_type
else
	popup.data_row_count = 2
	popup.items[1] = "Add to " + datalist.procedure_type_description(original_procedure_type) + " Short List"
	popup.items[2] = "Add to " + datalist.procedure_type_description(procedure_type) + " Short List"
	openwithparm(w_pop_pick, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then
		setnull(ls_procedure_type)
	else
		if popup_return.item_indexes[1] = 1 then
			ls_procedure_type = original_procedure_type
		else
			ls_procedure_type = procedure_type
		end if
	end if
end if

return "PROCEDURE_" + ls_procedure_type

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

li_sts = retrieve_procedures(ls_null, description, ls_null)
if li_sts < 0 then return -1

return li_sts


end function

public function integer search_cpt ();str_popup_return popup_return
string ls_null
integer li_sts

setnull(ls_null)

open(w_pop_prompt_procedure_cpt_code)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

cpt_code = popup_return.items[1]
search_description = popup_return.descriptions[1]

current_search = "CPT"

li_sts = retrieve_procedures(ls_null, ls_null, cpt_code)
if li_sts < 0 then return -1

return li_sts


end function

public function integer search ();integer li_sts
string ls_null

setnull(ls_null)


CHOOSE CASE current_search
	CASE "TOP20"
		li_sts = retrieve_short_list(top_20_user_id)
	CASE "CATEGORY"
		li_sts = retrieve_procedures(procedure_category_id, ls_null, ls_null)
	CASE "CPT"
		li_sts = retrieve_procedures(ls_null, ls_null, cpt_code)
	CASE "DESCRIPTION"
		li_sts = retrieve_procedures(ls_null, description, ls_null)
END CHOOSE


return li_sts

end function

public function integer retrieve_short_list (string ps_top_20_user_id);string ls_temp
long ll_count

dataobject = "dw_pick_top20_procedure"
settransobject(sqlca)

ll_count = retrieve(ps_top_20_user_id, top_20_code)

last_page = 0
set_page(1, ls_temp)

this.event POST procedures_loaded(search_description)

return ll_count

end function

public function integer search_category ();str_popup popup
str_popup_return popup_return
string ls_null
integer li_sts

setnull(ls_null)

popup.dataobject = "dw_specialty_procedure_category"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.argument_count = 2
popup.argument[1] = current_user.specialty_id
popup.argument[2] = procedure_type
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

procedure_category_id = popup_return.items[1]
search_description = popup_return.descriptions[1]

current_search = "CATEGORY"

li_sts = retrieve_procedures(procedure_category_id, ls_null, ls_null)
if li_sts < 0 then return -1

return li_sts


end function

public function integer move_row (long pl_row);str_popup popup
string ls_user_id
long i
string ls_procedure_id
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

public function integer initialize (string ps_procedure_type);
procedure_type = ps_procedure_type

if original_procedure_type = "!!!" or mode = "EDIT" then original_procedure_type = procedure_type

if isnull(procedure_type) then
	top_20_code = "PROCEDURE"
else
	top_20_code = "PROCEDURE_" + procedure_type
end if

if user_list.is_user_service(current_user.user_id, "CONFIG_PROCEDURES") then
	allow_editing = true
else
	allow_editing = false
end if

settransobject(sqlca)

return 1

end function

public subroutine procedure_menu (long pl_row);str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons
string ls_user_id
integer li_update_flag
string ls_procedure_id
string ls_temp
string ls_description
string ls_null
long ll_null
string ls_top_20_code

setnull(ls_null)
setnull(ll_null)

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
	popup.button_helps[popup.button_count] = "Edit Procedure"
	popup.button_titles[popup.button_count] = "Edit Procedure"
	buttons[popup.button_count] = "EDIT"
else
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Display Procedure"
	popup.button_titles[popup.button_count] = "Display Procedure"
	buttons[popup.button_count] = "EDIT"
end if

if allow_editing then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Delete Procedure"
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

CHOOSE CASE buttons[button_pressed]
	CASE "TOP20PERSONAL"
		ls_top_20_code = pick_top_20_code()
		if not isnull(ls_top_20_code) then
			ls_description = object.description[pl_row]
			ls_procedure_id = object.procedure_id[pl_row]
			li_sts = tf_add_personal_top_20(ls_top_20_code, ls_description, ls_procedure_id, ls_null, ll_null)
		end if
	CASE "TOP20COMMON"
		ls_top_20_code = pick_top_20_code()
		if not isnull(ls_top_20_code) then
			ls_description = object.description[pl_row]
			ls_procedure_id = object.procedure_id[pl_row]
			li_sts = tf_add_common_top_20(ls_top_20_code, ls_description, ls_procedure_id, ls_null, ll_null)
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
		popup.data_row_count = 2
		popup.items[1] = procedure_type
		popup.items[2] = object.procedure_id[pl_row]
		openwithparm(w_procedure_definition, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 4 then return
		
		object.procedure_id[pl_row] = popup_return.item
		object.description[pl_row] = popup_return.items[4]
		object.cpt_code[pl_row] = popup_return.items[1]
	CASE "DELETE"
		ls_temp = "Delete " + object.description[pl_row] + "?"
		openwithparm(w_pop_ok, ls_temp)
		if message.doubleparm = 1 then
			li_sts = delete_procedure(pl_row)
			if li_sts > 0 then deleterow(pl_row)
			recalc_page(ls_temp)
		end if
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return

end subroutine

on u_dw_procedure_list.create
call super::create
end on

on u_dw_procedure_list.destroy
call super::destroy
end on

event computed_clicked(long clicked_row);integer li_selected_flag
long ll_row

setnull(top_20_sequence)

if allow_editing then
	if current_search = "TOP20" then
		top_20_sequence = object.top_20_sequence[clicked_row]
	end if
	
	li_selected_flag = object.selected_flag[clicked_row]
	
	object.selected_flag[clicked_row] = 1
	procedure_menu(clicked_row)
	
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

event constructor;original_procedure_type = "!!!"
end event

event retrieveend;call super::retrieveend;object.description.width = width - 260
end event

