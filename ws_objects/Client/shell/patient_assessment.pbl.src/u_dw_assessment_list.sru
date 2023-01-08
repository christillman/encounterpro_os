$PBExportHeader$u_dw_assessment_list.sru
forward
global type u_dw_assessment_list from u_dw_pick_list
end type
end forward

global type u_dw_assessment_list from u_dw_pick_list
integer width = 1883
string dataobject = "dw_pick_top_20_assessment"
boolean border = false
event assessments_loaded ( string ps_description )
end type
global u_dw_assessment_list u_dw_assessment_list

type variables
// Search Criteria
string assessment_type
string original_assessment_type
string specialty_id
string status = "OK"
string icd_code
string description
string assessment_category_id
string top_20_user_id
string prefix = "ASSESSMENT"
// Behavior States
string mode = "EDIT"
boolean allow_editing

// Other states
string current_search = "TOP20"
// Values = TOP20, CATEGORY, ICD, ICD_LIST, DESCRIPTION

string top_20_code

string search_description

// Temp variable to hold the record currently being worked on
long top_20_sequence

end variables

forward prototypes
public function integer search_top_20 ()
public function integer delete_assessment (long pl_row)
public function integer search ()
public function integer search_category ()
public function integer retrieve_assessments (string ps_assessment_category_id, string ps_description, string ps_icd_code)
public function integer search_description ()
public function integer search_description (string ps_description)
public function integer search_icd ()
public function integer search_top_20 (boolean pb_personal_list)
public function integer remove_top_20 (long pl_row)
public function integer retrieve_short_list (string ps_top_20_user_id)
public function integer initialize (string ps_assessment_type, string ps_top_20_code)
public function integer initialize (string ps_assessment_type)
public function integer move_row (long pl_row)
public function integer sort_rows ()
public function string pick_top_20_code ()
public function integer set_assessment_specialty (long pl_row, string ps_flag)
public subroutine assessment_menu (long pl_row)
public function integer search_icd_list ()
end prototypes

public function integer search_top_20 ();
integer li_sts

top_20_user_id = current_user.user_id
search_description = "Personal List"
current_search = "TOP20"

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

public function integer delete_assessment (long pl_row);string ls_assessment_id

// DECLARE lsp_delete_assessment_definition PROCEDURE FOR dbo.sp_delete_assessment_definition  
//         @ps_assessment_id = :ls_assessment_id  ;
//

ls_assessment_id = object.assessment_id[pl_row]
sqlca.sp_delete_assessment_definition(ls_assessment_id);
//EXECUTE lsp_delete_assessment_definition;
if not tf_check() then return -1

return 1

end function

public function integer search ();integer li_sts
string ls_null

setnull(ls_null)

CHOOSE CASE current_search
	CASE "TOP20"
		li_sts = retrieve_short_list(top_20_user_id)
	CASE "CATEGORY"
		li_sts = retrieve_assessments(assessment_category_id, ls_null, ls_null)
	CASE "ICD"
		li_sts = retrieve_assessments(ls_null, ls_null, icd_code)
	CASE "DESCRIPTION"
		li_sts = retrieve_assessments(ls_null, description, ls_null)
	CASE "ICD_LIST"
		li_sts = retrieve_assessments(ls_null, ls_null, icd_code)
END CHOOSE


return li_sts

end function

public function integer search_category ();str_popup popup
str_popup_return popup_return
string ls_null
integer li_sts

setnull(ls_null)

popup.dataobject = "dw_assessment_category_list"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.argument_count = 2
popup.argument[1] = current_user.specialty_id
popup.argument[2] = assessment_type
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

assessment_category_id = popup_return.items[1]
search_description = popup_return.descriptions[1]

current_search = "CATEGORY"

li_sts = retrieve_assessments(assessment_category_id, ls_null, ls_null)
if li_sts < 0 then return -1

return li_sts


end function

public function integer retrieve_assessments (string ps_assessment_category_id, string ps_description, string ps_icd_code);string ls_temp, ls_null
long ll_count

setnull(ls_null)

dataobject = "dw_sp_assessment_search"
settransobject(sqlca)

IF current_search = "ICD" OR current_search = "ICD_LIST" THEN

	ll_count = retrieve( &
						assessment_type, &
						ps_assessment_category_id, &
						ps_description, &
						ps_icd_code, &
						ls_null, &
						status )
						
ELSE
	
	ll_count = retrieve( &
						assessment_type, &
						ps_assessment_category_id, &
						ps_description, &
						ps_icd_code, &
						specialty_id, &
						status )
END IF
					
last_page = 0
set_page(1, ls_temp)

this.event POST assessments_loaded(search_description)

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

li_sts = retrieve_assessments(ls_null, description, ls_null)
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

li_sts = retrieve_assessments(ls_null, description, ls_null)
if li_sts < 0 then return -1

return li_sts


end function

public function integer search_icd ();str_popup_return popup_return
string ls_null
integer li_sts

setnull(ls_null)

open(w_pop_prompt_assessment_icd_code)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

icd_code = popup_return.items[1]
search_description = popup_return.descriptions[1]

current_search = "ICD"

li_sts = retrieve_assessments(ls_null, ls_null, icd_code)
if li_sts < 0 then return -1

return li_sts


end function

public function integer search_top_20 (boolean pb_personal_list);str_popup popup
str_popup_return popup_return
string ls_null
integer li_sts

setnull(ls_null)

current_search = "TOP20"
if pb_personal_list then
	top_20_user_id = current_user.user_id
	search_description = "Personal List"
else
	top_20_user_id = current_user.common_list_id()
	search_description = "Common List"
end if

li_sts = retrieve_short_list(top_20_user_id)
if li_sts < 0 then return -1

if li_sts = 0 and pb_personal_list then
	openwithparm(w_pop_yes_no, "Your personal list is empty.  Do you wish to start with a copy of the common list (Recommended: No)?")
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

if left(current_search,5) <> "TOP20" then return 0

deleterow(pl_row)
li_sts = update()

return li_sts

end function

public function integer retrieve_short_list (string ps_top_20_user_id);string ls_temp
long ll_count

dataobject = "dw_pick_top_20_assessment"
settransobject(sqlca)

ll_count = retrieve(ps_top_20_user_id, top_20_code)

last_page = 0
set_page(1, ls_temp)

this.event POST assessments_loaded(search_description)

return ll_count

end function

public function integer initialize (string ps_assessment_type, string ps_top_20_code);
assessment_type = ps_assessment_type
if isnull(assessment_type) then assessment_type = "SICK"

if original_assessment_type = "!!!" or mode = "EDIT" then original_assessment_type = assessment_type

if isnull(ps_top_20_code) or trim(ps_top_20_code) = "" then
	prefix = "ASSESSMENT"
else
	prefix = ps_top_20_code
end if

top_20_code = prefix + "_" + assessment_type


if user_list.is_user_service(current_user.user_id, "CONFIG_ASSESSMENTS") then
	allow_editing = true
else
	allow_editing = false
end if

settransobject(sqlca)

return 1

end function

public function integer initialize (string ps_assessment_type);return initialize(ps_assessment_type, "")


end function

public function integer move_row (long pl_row);str_popup popup
string ls_user_id
long i
string ls_assessment_id
string ls_description
string ls_null
long ll_null
long ll_row
integer li_sts

setnull(ls_null)
setnull(ll_null)

if pl_row <= 0 then return 0

if left(current_search,5) <> "TOP20" then return 0

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

if left(current_search,5) <> "TOP20" then return 0

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

public function string pick_top_20_code ();string ls_assessment_type
str_popup popup
str_popup_return popup_return

if (original_assessment_type = assessment_type) or (isnull(original_assessment_type) and isnull(assessment_type)) then
	ls_assessment_type = assessment_type
elseif isnull(assessment_type) and not isnull(original_assessment_type) then
	ls_assessment_type = original_assessment_type
elseif isnull(original_assessment_type) and not isnull(assessment_type) then
	ls_assessment_type = assessment_type
else
	popup.data_row_count = 2
	popup.items[1] = "Add to " + datalist.assessment_type_description(original_assessment_type) + " Short List"
	popup.items[2] = "Add to " + datalist.assessment_type_description(assessment_type) + " Short List"
	openwithparm(w_pop_pick, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then
		setnull(ls_assessment_type)
	else
		if popup_return.item_indexes[1] = 1 then
			ls_assessment_type = original_assessment_type
		else
			ls_assessment_type = assessment_type
		end if
	end if
end if

return prefix + "_" + ls_assessment_type

end function

public function integer set_assessment_specialty (long pl_row, string ps_flag);string ls_assessment_id

// DECLARE lsp_set_assessment_specialty PROCEDURE FOR dbo.sp_set_assessment_specialty  
//         @ps_assessment_id = :ls_assessment_id,   
//         @ps_specialty_id = :current_user.specialty_id,   
//         @ps_flag = :ps_flag  ;


if pl_row <= 0 or isnull(pl_row) then return 0
if isnull(current_user.specialty_id) then return 0

ls_assessment_id = object.assessment_id[pl_row]
SQLCA.sp_set_assessment_specialty   ( &
         ls_assessment_id,    &
         current_user.specialty_id,    &
         ps_flag  );
//EXECUTE lsp_set_assessment_specialty;
if not tf_check() then return -1

return 1


end function

public subroutine assessment_menu (long pl_row);str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons
string ls_user_id
integer li_update_flag
string ls_Assessment_id
string ls_temp
string ls_description
string ls_null
long ll_null
string ls_top_20_code
string ls_action

setnull(ls_null)
setnull(ll_null)


popup.data_row_count = 5
popup.items[1] = object.Assessment_id[pl_row]
popup.items[2] = current_search
popup.items[3] = f_boolean_to_string(allow_editing)
popup.items[4] = mode
popup.items[5] = specialty_id
openwithparm(w_assessment_menu, popup)

ls_action = message.stringparm

CHOOSE CASE ls_action
	CASE "TOP20PERSONAL"
		ls_top_20_code = pick_top_20_code()
		if not isnull(ls_top_20_code) then
			ls_description = object.description[pl_row]
			ls_Assessment_id = object.Assessment_id[pl_row]
			li_sts = tf_add_personal_top_20(ls_top_20_code, ls_description, ls_Assessment_id, ls_null, ll_null)
		end if
	CASE "TOP20COMMON"
		ls_top_20_code = pick_top_20_code()
		if not isnull(ls_top_20_code) then
			ls_description = object.description[pl_row]
			ls_Assessment_id = object.Assessment_id[pl_row]
			li_sts = tf_add_common_top_20(ls_top_20_code, ls_description, ls_Assessment_id, ls_null, ll_null)
		end if
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
		ls_assessment_id = object.assessment_id[pl_row]
		
		openwithparm(w_Assessment_definition, ls_assessment_id)
		
		// get the updated description and icd code
		object.description[pl_row] = datalist.assessment_description(ls_assessment_id)
		object.icd10_code[pl_row] = datalist.assessment_icd10_code(ls_assessment_id)
	CASE "DELETE"
		ls_temp = "Delete " + object.description[pl_row] + "?"
		openwithparm(w_pop_ok, ls_temp)
		if message.doubleparm = 1 then
			li_sts = delete_assessment(pl_row)
			if li_sts > 0 then deleterow(pl_row)
			recalc_page(ls_temp)
		end if
	CASE "CANCEL"
		return
	CASE "SELECT"
		this.event POST selected(pl_row)
	CASE "ADDSPECIALTY"
		set_assessment_specialty(pl_row, "Y")
	CASE "REMOVESPECIALTY"
		set_assessment_specialty(pl_row, "N")
	CASE ELSE
END CHOOSE

return

end subroutine

public function integer search_icd_list ();str_popup_return popup_return
string ls_null
integer li_sts

setnull(ls_null)

current_search = "ICD_LIST"

//open(w_pop_assessment_icd_list)
//popup_return = message.powerobjectparm
//if popup_return.item_count <> 1 then return 0
//
//icd_code = popup_return.items[1]
//search_description = popup_return.descriptions[1]
//
//li_sts = retrieve_assessments(ls_null, ls_null, icd_code)
//if li_sts < 0 then return -1
//

if isnull(specialty_id) then
	search_description = "browsed assessments"
else
	search_description = "browsed specialty assessments"
end if
	
li_sts = retrieve_assessments(ls_null, ls_null, icd_code)
if li_sts < 0 then return -1

return li_sts


end function

on u_dw_assessment_list.create
call super::create
end on

on u_dw_assessment_list.destroy
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
	assessment_menu(clicked_row)
	
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

event constructor;original_assessment_type = "!!!"
end event

event retrieveend;call super::retrieveend;
object.description.width = width - 260

end event

