$PBExportHeader$u_dw_patient_materials_list.sru
forward
global type u_dw_patient_materials_list from u_dw_pick_list
end type
end forward

global type u_dw_patient_materials_list from u_dw_pick_list
integer width = 1883
string dataobject = "dw_pick_top20_patient_material"
boolean border = false
event materials_loaded ( string ps_description )
end type
global u_dw_patient_materials_list u_dw_patient_materials_list

type variables
// Search Criteria
string specialty_id
string status = "OK"
string description
string material_category_id
string top_20_user_id

// Behavior States
string mode = "EDIT"
boolean allow_editing

// Other states
string current_search = "TOP20"
// Values = TOP20, CATEGORY, DESCRIPTION(GENERIC),DESCRIPTION(COMMON)

string top_20_code

string search_description

// Temp variable to hold the record currently being worked on
long top_20_sequence

end variables

forward prototypes
public function integer delete_material (long pl_row)
public function string pick_top_20_code ()
public function integer remove_top_20 (long pl_row)
public function integer retrieve_materials (string ps_material_category_id, string ps_description)
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
public subroutine material_menu (long pl_row)
public function integer display_material (long pl_row)
public subroutine update_category (long pl_row)
end prototypes

public function integer delete_material (long pl_row);long ll_material_id

 DECLARE lsp_delete_patient_material PROCEDURE FOR dbo.sp_delete_patient_material
         @pl_material_id = :ll_material_id  ;


ll_material_id = object.material_id[pl_row]

EXECUTE lsp_delete_patient_material;
If Not tf_check() Then Return -1

Return 1

end function

public function string pick_top_20_code ();return top_20_code
end function

public function integer remove_top_20 (long pl_row);integer li_sts

if current_search <> "TOP20" then return 0

deleterow(pl_row)
li_sts = update()

return li_sts

end function

public function integer retrieve_materials (string ps_material_category_id, string ps_description);string ls_temp
long ll_count

dataobject = "dw_sp_material_search"
settransobject(sqlca)

ll_count = retrieve( &
						ps_material_category_id, &
						ps_description, &
						specialty_id, &
						status )

last_page = 0
set_page(1, ls_temp)

this.event POST materials_loaded(search_description)

return ll_count

end function

public function integer search ();integer li_sts
string ls_null

setnull(ls_null)


CHOOSE CASE current_search
	CASE "TOP20"
		li_sts = retrieve_short_list(top_20_user_id)
	CASE "CATEGORY"
		li_sts = retrieve_materials(material_category_id, ls_null)
	CASE "DESCRIPTION"
		li_sts = retrieve_materials(ls_null, description)
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

li_sts = retrieve_materials(ls_null, description)
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

li_sts = retrieve_materials(ls_null, description)
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

popup.dataobject = "dw_material_category_list"
popup.datacolumn = 1
popup.displaycolumn = 2
//popup.argument_count = 1
//popup.argument[1] = current_user.specialty_id
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0 

material_category_id = string(popup_return.items[1])
search_description = popup_return.descriptions[1]

current_search = "CATEGORY"

li_sts = retrieve_materials(material_category_id, ls_null)
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

dataobject = "dw_pick_top20_patient_material"
settransobject(sqlca)

ll_count = retrieve(ps_top_20_user_id, top_20_code)

last_page = 0
set_page(1, ls_temp)

this.event POST materials_loaded(search_description)

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

public function integer initialize (string ps_treatment_type);
//if isnull(ps_treatment_type) then
//	top_20_code = "MEDICATION"
//else
	top_20_code = ps_treatment_type
//end if

if user_list.is_user_service(current_user.user_id, "CONFIG_PATIENT_MTRL") then
	allow_editing = true
else
	allow_editing = false
end if

settransobject(sqlca)

return 1

end function

public subroutine material_menu (long pl_row);String		buttons[]
String 		ls_material_id,ls_temp
String 		ls_description,ls_null
String		ls_top_20_code
Integer		button_pressed, li_sts, li_service_count
Long			ll_null
long ll_material_id

window 				lw_pop_buttons
str_popup 			popup
str_popup_return 	popup_return

Setnull(ls_null)
Setnull(ll_null)

ll_material_id = object.material_id[pl_row]

if current_search <> "TOP20" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Add material to personal Short List List"
	popup.button_titles[popup.button_count] = "Personal Short List"
	buttons[popup.button_count] = "TOP20PERSONAL"
end if

if current_search <> "TOP20" and current_user.check_privilege("Edit Common Short Lists") then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Add material to common Short List List"
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
	popup.button_helps[popup.button_count] = "Display material"
	popup.button_titles[popup.button_count] = "Display"
	buttons[popup.button_count] = "DISPLAY"
end if

if allow_editing then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Modify Title"
	popup.button_titles[popup.button_count] = "Modify Title"
	buttons[popup.button_count] = "TITLE"
end if

if allow_editing then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Modify Category"
	popup.button_titles[popup.button_count] = "Modify Category"
	buttons[popup.button_count] = "CATEGORY"
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
			ls_material_id = String(object.material_id[pl_row])
			li_sts = tf_add_personal_top_20(ls_top_20_code, ls_description, ls_material_id, ls_null, ll_null)
		end if
	CASE "TOP20COMMON"
		ls_top_20_code = pick_top_20_code()
		if not isnull(ls_top_20_code) then
			ls_description = object.description[pl_row]
			ls_material_id = String(object.material_id[pl_row])
			li_sts = tf_add_common_top_20(ls_top_20_code, ls_description, ls_material_id, ls_null, ll_null)
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
	CASE "TITLE"
		popup.title = "Enter the new title for this material"
		openwithparm(w_pop_prompt_string, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		
		UPDATE c_Patient_Material
		SET title = :popup_return.items[1]
		WHERE material_id = :ll_material_id;
		if not tf_check() then return
		
		object.description[pl_row] = popup_return.items[1]
		
	CASE "CATEGORY"
		update_category(pl_row)
	CASE "DISPLAY"
		display_material(pl_row)
//	CASE "EDIT"
//		popup.item = string(object.material_id[pl_row])
//		Openwithparm(w_review_patient_material, popup)
//		popup_return = message.powerobjectparm
//		If popup_return.item_count <> 1 then Return
//
//		object.material_id[pl_row] = long(popup_return.item)
//		object.description[pl_row] = popup_return.items[1]
	CASE "DELETE"
		ls_temp = "Delete " + object.description[pl_row] + "?"
		openwithparm(w_pop_ok, ls_temp)
		if message.doubleparm = 1 then
			li_sts = delete_material(pl_row)
			if li_sts > 0 then deleterow(pl_row)
			recalc_page(ls_temp)
		end if
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

Return

end subroutine

public function integer display_material (long pl_row);long ll_material_id
integer li_sts

if isnull(pl_row) then return 0
if pl_row <= 0 then return 0

ll_material_id = object.material_id[pl_row]
if isnull(ll_material_id) then return 0

li_sts = f_display_patient_material(ll_material_id)
if li_sts <= 0 then
	log.log(this, "display_material()", "Error displaying material (" + string(ll_material_id) + ")", 4)
	return -1
end if

end function

public subroutine update_category (long pl_row);
str_popup			popup
str_popup_return	popup_return
long ll_material_category_id
long ll_material_id

popup.dataobject = "dw_material_category_list"
popup.datacolumn = 1
popup.displaycolumn = 2

Openwithparm(w_pop_pick, popup)
popup_return = Message.powerobjectparm
If popup_return.item_count <> 1 Then Return

ll_material_category_id = Long(popup_return.items[1])

ll_material_id = object.material_id[pl_row]

UPDATE c_Patient_Material
SET category = :ll_material_category_id
WHERE material_id = :ll_material_id;
if not tf_check() then return

end subroutine

on u_dw_patient_materials_list.create
call super::create
end on

on u_dw_patient_materials_list.destroy
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
	material_menu(clicked_row)
	
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

