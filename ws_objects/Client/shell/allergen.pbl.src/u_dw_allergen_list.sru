$PBExportHeader$u_dw_allergen_list.sru
forward
global type u_dw_allergen_list from u_dw_pick_list
end type
end forward

global type u_dw_allergen_list from u_dw_pick_list
integer width = 1883
string dataobject = "dw_pick_top20_drug"
boolean border = false
event drugs_loaded ( string ps_description )
end type
global u_dw_allergen_list u_dw_allergen_list

type variables
// Search Criteria
string specialty_id
string status = "OK"
string description,generic_name
string drug_category_id
string top_20_user_id

// Behavior States
string mode = "EDIT"
boolean allow_editing

// Other states
string current_search = "TOP20"
// Values = TOP20, CATEGORY, DESCRIPTION(GENERIC),DESCRIPTION(COMMON)

string drug_type

string top_20_code

string search_description

// Temp variable to hold the record currently being worked on
long top_20_sequence

window myparentwindow

string tests_treatment_type = "Allergy Test"

string specialty_mode = "Specialty"  // "Specialty" or "All"


end variables

forward prototypes
public function integer delete_drug (long pl_row)
public function string pick_top_20_code ()
public function integer remove_top_20 (long pl_row)
public function integer retrieve_drugs (string ps_drug_category_id, string ps_description, string ps_generic_name)
public function integer retrieve_short_list (string ps_top_20_user_id)
public function integer search ()
public function integer search_top_20 ()
public function integer search_description (string ps_description)
public function integer sort_rows ()
public function integer search_category ()
public function integer search_description ()
public function integer search_generic ()
public function integer search_top_20 (boolean pb_personal_list)
public function integer move_row (long pl_row)
public subroutine drug_menu (long pl_row)
public function integer retrieve_tests ()
public function integer search_tests ()
public function integer initialize (string ps_top_20_code, string ps_drug_type, string ps_tests_treatment_type)
public subroutine toggle_specialty_mode ()
end prototypes

public function integer delete_drug (long pl_row);string ls_drug_id

// DECLARE lsp_delete_drug_definition PROCEDURE FOR dbo.sp_delete_drug_definition  
//         @ps_drug_id = :ls_drug_id  ;


ls_drug_id = object.drug_id[pl_row]
sqlca.sp_delete_drug_definition(ls_drug_id)  ;
//EXECUTE lsp_delete_drug_definition;
if not tf_check() then return -1

return 1

end function

public function string pick_top_20_code ();
string ls_top_20_code


// If we specified a drug_type the make the short list drug_type-specific
if left(drug_type, 1) = "%" then
	ls_top_20_code = top_20_code
else
	ls_top_20_code = top_20_code + "|" + drug_type
end if

return ls_top_20_code


end function

public function integer remove_top_20 (long pl_row);integer li_sts

if current_search <> "TOP20" then return 0

deleterow(pl_row)
li_sts = update()

return li_sts

end function

public function integer retrieve_drugs (string ps_drug_category_id, string ps_description, string ps_generic_name);string ls_temp
long ll_count
string ls_specialty_id

dataobject = "dw_sp_drug_search"
settransobject(sqlca)

if lower(specialty_mode) = "specialty" then
	ls_specialty_id = specialty_id
else
	setnull(ls_specialty_id)
end if

ll_count = retrieve( &
						ps_drug_category_id, &
						ps_description, &
						ps_generic_name, &
						ls_specialty_id, &
						status, &
						drug_type)

last_page = 0
set_page(1, ls_temp)

this.event POST drugs_loaded(search_description)

return ll_count

end function

public function integer retrieve_short_list (string ps_top_20_user_id);string ls_temp
long ll_count
string ls_top_20_code


dataobject = "dw_pick_top20_drug"
settransobject(sqlca)

ls_top_20_code = pick_top_20_code()

ll_count = retrieve(ps_top_20_user_id, ls_top_20_code)

last_page = 0
set_page(1, ls_temp)

this.event POST drugs_loaded(search_description)

return ll_count

end function

public function integer search ();integer li_sts
string ls_null

setnull(ls_null)


CHOOSE CASE current_search
	CASE "TESTS"
		li_sts = retrieve_tests()
	CASE "TOP20"
		li_sts = retrieve_short_list(top_20_user_id)
	CASE "CATEGORY"
		li_sts = retrieve_drugs(drug_category_id, ls_null, ls_null)
	CASE "GENERIC" // search by drug generic name
		li_sts = retrieve_drugs(ls_null, ls_null, generic_name)
	CASE "DESCRIPTION"
		li_sts = retrieve_drugs(ls_null, description, ls_null)
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
	description = "%"
	search_description = "<All>"
else
	description = "%" + ps_description + "%"
	search_description = 'Contains "' + ps_description + '"'
end if

current_search = "DESCRIPTION"

li_sts = retrieve_drugs(ls_null, description, ls_null)
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

public function integer search_category ();str_popup popup
str_popup_return popup_return
string ls_null
integer li_sts

setnull(ls_null)

popup.dataobject = "dw_specialty_drug_category"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = current_user.specialty_id
openwithparm(w_pop_pick, popup, myparentwindow)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

drug_category_id = popup_return.items[1]
search_description = popup_return.descriptions[1]

current_search = "CATEGORY"

li_sts = retrieve_drugs(drug_category_id, ls_null, ls_null)
if li_sts < 0 then return -1

return li_sts


end function

public function integer search_description ();string ls_null
long ll_count
str_popup_return popup_return
integer li_sts

setnull(ls_null)

open(w_pop_get_string_abc, myparentwindow)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

description = popup_return.items[1]
search_description = popup_return.descriptions[1]
	
current_search = "DESCRIPTION"

li_sts = retrieve_drugs(ls_null, description, ls_null)
if li_sts < 0 then return -1

return li_sts


end function

public function integer search_generic ();string ls_null
long ll_count
str_popup_return popup_return
integer li_sts

setnull(ls_null)

open(w_pop_get_string_abc, myparentwindow)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

generic_name = popup_return.items[1]
search_description = popup_return.descriptions[1]
	
current_search = "GENERIC"

li_sts = retrieve_drugs(ls_null, ls_null, generic_name)
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
		f_copy_top_20_common_list(current_user.user_id, current_user.specialty_id, pick_top_20_code())
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

public subroutine drug_menu (long pl_row);String		buttons[]
String 		ls_drug_id,ls_temp
String 		ls_description,ls_null
String		ls_top_20_code
Integer		button_pressed, li_sts, li_service_count
Long			ll_null
str_drug_definition lstr_drug
w_config_drug lw_config_drug

window 				lw_pop_buttons
str_popup 			popup
str_popup_return 	popup_return

Setnull(ls_null)
Setnull(ll_null)

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

if current_search = "TESTS" then
//		popup.button_count = popup.button_count + 1
//		popup.button_icons[popup.button_count] = "button17.bmp"
//		popup.button_helps[popup.button_count] = "Review or edit mappings from test result to allergens"
//		popup.button_titles[popup.button_count] = "Map Allergens"
//		buttons[popup.button_count] = "MAP"
else
	if allow_editing then
		popup.button_count = popup.button_count + 1
		popup.button_icons[popup.button_count] = "button17.bmp"
		popup.button_helps[popup.button_count] = "Edit Drug"
		popup.button_titles[popup.button_count] = "Edit Allergen"
		buttons[popup.button_count] = "EDIT"
	else
		popup.button_count = popup.button_count + 1
		popup.button_icons[popup.button_count] = "button17.bmp"
		popup.button_helps[popup.button_count] = "Display Drug"
		popup.button_titles[popup.button_count] = "Display"
		buttons[popup.button_count] = "EDIT"
	end if
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
			ls_description = object.description[pl_row]
			ls_drug_id = object.drug_id[pl_row]
			li_sts = tf_add_personal_top_20(ls_top_20_code, ls_description, ls_drug_id, ls_null, ll_null)
		end if
	CASE "TOP20COMMON"
		ls_top_20_code = pick_top_20_code()
		if not isnull(ls_top_20_code) then
			ls_description = object.description[pl_row]
			ls_drug_id = object.drug_id[pl_row]
			li_sts = tf_add_common_top_20(ls_top_20_code, ls_description, ls_drug_id, ls_null, ll_null)
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
	CASE "MAP"
		
	CASE "EDIT"
		lstr_drug.drug_id = object.drug_id[pl_row]
		openwithparm(lw_config_drug, lstr_drug.drug_id, "w_config_drug", myparentwindow)
		popup_return = message.powerobjectparm
		If popup_return.item_count <> 1 then Return

		object.drug_id[pl_row] = popup_return.item
		If current_search <> "TOP20" Then
			object.description[pl_row] = popup_return.items[1]
		Else
			object.common_name[pl_row] = popup_return.items[1]
		End If
	CASE "DELETE"
		ls_temp = "Delete " + object.description[pl_row] + "?"
		openwithparm(w_pop_ok, ls_temp, myparentwindow)
		if message.doubleparm = 1 then
			li_sts = delete_drug(pl_row)
			if li_sts > 0 then deleterow(pl_row)
			recalc_page(ls_temp)
		end if
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

Return

end subroutine

public function integer retrieve_tests ();string ls_temp
long ll_count
string ls_top_20_code
datetime ldt_from_date
long i
string ls_result
string ls_result_value
string ls_result_unit
string ls_result_amount_flag
string ls_print_result_flag
string ls_print_result_separator
string ls_abnormal_flag
string ls_unit_preference
string ls_display_mask
string ls_pretty_result
string ls_observation_description
string ls_location
string ls_location_description

search_description = "Positive Test Results"

dataobject = "dw_sp_abnormal_results"
settransobject(sqlca)

ll_count = retrieve(current_patient.cpr_id, tests_treatment_type, ldt_from_date)

for i = 1 to ll_count
	ls_result = object.result[i]
	ls_location = object.location[i]
	ls_location_description = object.location_description[i]
	ls_result_value = object.result_value[i]
	ls_result_unit = object.result_unit[i]
	ls_result_amount_flag = object.result_amount_flag[i]
	ls_print_result_flag = object.print_result_flag[i]
	ls_print_result_separator = object.print_result_separator[i]
	ls_abnormal_flag = object.abnormal_flag[i]
	ls_unit_preference = object.unit_preference[i]
	ls_display_mask = object.display_mask[i]
	
	ls_observation_description = object.observation_description[i]
	
	ls_pretty_result = f_pretty_result( ls_result, &
											ls_location, &
											ls_location_description, &
											ls_result_value, &
											ls_result_unit, &
											ls_result_amount_flag, &
											ls_print_result_flag, &
											ls_print_result_separator, &
											ls_abnormal_flag, &
											ls_unit_preference, &
											ls_display_mask, &
											false, &
											true, &
											true )
	
	if len(ls_pretty_result) > 0 then
		ls_observation_description += ":  " + ls_pretty_result
	end if
	
	object.description[i] = ls_observation_description
next

last_page = 0
set_page(1, ls_temp)

this.event POST drugs_loaded(search_description)

return ll_count

end function

public function integer search_tests ();integer li_sts

current_search = "TESTS"

li_sts = retrieve_tests()
if li_sts < 0 then return -1

return li_sts


end function

public function integer initialize (string ps_top_20_code, string ps_drug_type, string ps_tests_treatment_type);powerobject lo_object
integer li_iterations


top_20_code = ps_top_20_code

tests_treatment_type = ps_tests_treatment_type

specialty_mode = datalist.get_preference("PREFERENCES", "Default Specialty Search Mode")
if lower(specialty_mode) = "all" then
	specialty_mode = "All"
else
	specialty_mode = "Specialty"
end if

if len(ps_drug_type) > 0 then
	drug_type = ps_drug_type
else
	drug_type = "Allergen"
end if


if user_list.is_user_service(current_user.user_id, "CONFIG_DRUGS") then
	allow_editing = true
else
	allow_editing = false
end if

settransobject(sqlca)
myparentwindow = f_getparentwindow(this)
//
//// A bug in PowerBuilder is causing the parent window of the w_pop_time_interval popup
//// to sometimes be incorrect, which causes encounterpro to freeze when the popup closes.
//// This sections attempts to identify the current active window and uses it as the
//// parent of the popup
//li_iterations = 0
//lo_object = this
//DO WHILE isvalid(lo_object) and li_iterations < 20
//	if left(lo_object.classname(), 2) = "w_" then
//		myparentwindow = lo_object
//		exit
//	end if
//	li_iterations += 1
//	lo_object = lo_object.getparent()
//LOOP

return 1

end function

public subroutine toggle_specialty_mode ();if lower(specialty_mode) = "specialty" then
	specialty_mode = "All"
else
	specialty_mode = "Specialty"
end if

search()

end subroutine

on u_dw_allergen_list.create
call super::create
end on

on u_dw_allergen_list.destroy
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
	drug_menu(clicked_row)
	
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

event retrieveend;call super::retrieveend;object.description.width = width - 260

end event

