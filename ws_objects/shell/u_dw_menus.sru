HA$PBExportHeader$u_dw_menus.sru
forward
global type u_dw_menus from u_dw_pick_list
end type
end forward

global type u_dw_menus from u_dw_pick_list
integer width = 1883
string dataobject = "dw_pick_top20_menus"
boolean vscrollbar = true
boolean border = false
event menu_loaded ( string ps_description )
end type
global u_dw_menus u_dw_menus

type variables
// Search Criteria
string specialty_id
string status = "OK"
string description
string menu_category
string top_20_user_id

private string context_object

// Behavior States
string mode = "EDIT"
boolean allow_editing

// Other states
string current_search = "TOP20"
// Values = TOP20, CATEGORY, DESCRIPTION(GENERIC),DESCRIPTION(COMMON)

string top_20_code = "MENU"

string search_description
// Temp variable to hold the record currently being worked on
long top_20_sequence

end variables

forward prototypes
public function integer remove_top_20 (long pl_row)
public function integer search ()
public function integer search_description ()
public function integer search_description (string ps_description)
public function integer search_top_20 ()
public function integer search_category ()
public function integer search_top_20 (boolean pb_personal_list)
public function integer retrieve_short_list (string ps_top_20_user_id)
public function integer move_row (long pl_row)
public function integer sort_rows ()
public function integer initialize (string ps_treatment_type)
public function integer retrieve_menus (string ps_menu_category_id, string ps_description)
public subroutine menu (long pl_row)
public subroutine set_context_object (string ps_context_object)
end prototypes

public function integer remove_top_20 (long pl_row);integer li_sts

if current_search <> "TOP20" then return 0

deleterow(pl_row)
li_sts = update()

return li_sts

end function

public function integer search ();integer li_sts
string ls_null

setnull(ls_null)


CHOOSE CASE current_search
	CASE "TOP20"
		li_sts = retrieve_short_list(top_20_user_id)
	CASE "CATEGORY"
		li_sts = retrieve_menus(menu_category, ls_null)
	CASE "DESCRIPTION"
		li_sts = retrieve_menus(ls_null, description)
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

li_sts = retrieve_menus(ls_null, description)
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

li_sts = retrieve_menus(ls_null, description)
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

public function integer search_category ();str_popup popup
str_popup_return popup_return
string ls_null
integer li_sts

setnull(ls_null)

// get the service type
popup.dataobject = "dw_domain_notranslate_list"
popup.datacolumn = 2
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = "Menu Category"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

menu_category = string(popup_return.items[1])
search_description = popup_return.descriptions[1]

current_search = "CATEGORY"

li_sts = retrieve_menus(menu_category, ls_null)
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

public function integer retrieve_short_list (string ps_top_20_user_id);string ls_temp
long ll_count

dataobject = "dw_pick_top20_menus"
settransobject(sqlca)

ll_count = retrieve(ps_top_20_user_id, top_20_code)

last_page = 0
set_page(1, ls_temp)

this.event POST menu_loaded(search_description)

return ll_count

end function

public function integer move_row (long pl_row);str_popup popup
string ls_user_id
long i
string ls_material_id
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

public function integer initialize (string ps_treatment_type);string ls_null

setnull(ls_null)

set_context_object(ls_null)

if user_list.is_user_service(current_user.user_id, "CONFIG_MENUS") then
	allow_editing = true
else
	allow_editing = false
end if

settransobject(sqlca)

return 1

end function

public function integer retrieve_menus (string ps_menu_category_id, string ps_description);string ls_temp
long ll_count

dataobject = "dw_sp_menu_search"
settransobject(sqlca)

ll_count = retrieve( &
						ps_menu_category_id, &
						ps_description, &
						context_object, &
						specialty_id, &
						status )

last_page = 0
set_page(1, ls_temp)

this.event POST menu_loaded(search_description)

return ll_count

end function

public subroutine menu (long pl_row);String		buttons[]
String 		ls_menu_id,ls_temp
String 		ls_description,ls_null
Integer		button_pressed, li_sts, li_service_count
Long			ll_null
long ll_menu_id
integer li_count
boolean lb_local_only
string ls_id
long ll_new_menu_id

window 				lw_pop_buttons
w_menu_edit			lw_menu_edit
w_menu_display		lw_menu_display
str_menu				lstr_menu
str_popup 			popup
str_popup_return 	popup_return

Setnull(ls_null)
Setnull(ll_null)

ll_menu_id = object.menu_id[pl_row]

// See if there's a version of this menu not owned locally
SELECT count(*)
INTO :li_count
FROM c_menu w1
	INNER JOIN c_menu w2
	ON w1.id = w2.id
WHERE w1.menu_id = :ll_menu_id
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
	popup.button_helps[popup.button_count] = "Add menu to personal Short List List"
	popup.button_titles[popup.button_count] = "Personal Short List"
	buttons[popup.button_count] = "TOP20PERSONAL"
end if

if current_search <> "TOP20" and current_user.check_privilege("Edit Common Short Lists") then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Add menu to common Short List List"
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
//	popup.button_helps[popup.button_count] = "Edit menu"
//	popup.button_titles[popup.button_count] = "Edit"
//	buttons[popup.button_count] = "EDIT"
//else
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button17.bmp"
//	popup.button_helps[popup.button_count] = "Display menu"
//	popup.button_titles[popup.button_count] = "Display"
//	buttons[popup.button_count] = "EDIT"
//end if
	
if allow_editing and lb_local_only then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit Menu"
	popup.button_titles[popup.button_count] = "Edit"
	buttons[popup.button_count] = "EDIT"
end if

if not lb_local_only then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Display/Edit Menu"
	popup.button_titles[popup.button_count] = "Display"
	if allow_editing then popup.button_titles[popup.button_count] += "/Edit"
	buttons[popup.button_count] = "DISPLAY"
end if

if allow_editing then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Copy Menu"
	popup.button_titles[popup.button_count] = "Copy"
	buttons[popup.button_count] = "COPY"
end if

if allow_editing and lb_local_only then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Delete Menu"
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
		ls_description = object.description[pl_row]
		ls_menu_id = String(object.menu_id[pl_row])
		li_sts = tf_add_personal_top_20(top_20_code, ls_description, ls_menu_id, ls_null, ll_null)
	CASE "TOP20COMMON"
		ls_description = object.description[pl_row]
		ls_menu_id = String(object.menu_id[pl_row])
		li_sts = tf_add_common_top_20(top_20_code, ls_description, ls_menu_id, ls_null, ll_null)
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
		Openwithparm(lw_menu_edit, ll_menu_id, "w_menu_edit")
	CASE "DISPLAY"
		SELECT CAST(id AS varchar(38))
		INTO :popup.items[1]
		FROM c_menu
		WHERE menu_id = :ll_menu_id;
		if not tf_check() then return
		popup.items[2] = f_boolean_to_string(allow_editing)
		popup.data_row_count = 2
		openwithparm(lw_menu_display, popup, "w_menu_display")
	CASE "DELETE"
		UPDATE c_menu
		SET status = 'NA'
		WHERE menu_id =:ll_menu_id;
		if not tf_check() then return
		deleterow(pl_row)
	CASE "COPY"
		ls_description = f_popup_prompt_string("Please enter a description for the new menu")
		if len(ls_description) > 0 then
			ll_new_menu_id = sqlca.sp_local_copy_menu(ll_menu_id, ls_null, ls_description)
			if not tf_check() then return
			if ll_new_menu_id <= 0 then return

			// Edit the new menu
			Openwithparm(lw_menu_edit, ll_new_menu_id, "w_menu_edit")
			return
		end if
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

Return

end subroutine

public subroutine set_context_object (string ps_context_object);context_object = ps_context_object

if isnull(context_object) then
	top_20_code = "MENU|All"
else
	top_20_code = "MENU|" + context_object
end if

end subroutine

on u_dw_menus.create
call super::create
end on

on u_dw_menus.destroy
call super::destroy
end on

event computed_clicked;integer li_selected_flag
long ll_row

setnull(top_20_sequence)

if allow_editing then
	if current_search = "TOP20" then
		top_20_sequence = object.top_20_sequence[clicked_row]
	end if
	
	li_selected_flag = object.selected_flag[clicked_row]
	
	object.selected_flag[clicked_row] = 1
	menu(clicked_row)
	
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

event selected;call super::selected;if mode = "EDIT" and not lastcomputed then
	menu(selected_row)
	clear_selected()
end if

end event

event retrieveend;call super::retrieveend;object.description.width = width - 260

end event

