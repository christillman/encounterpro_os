$PBExportHeader$u_dw_property_list.sru
forward
global type u_dw_property_list from u_dw_pick_list
end type
end forward

global type u_dw_property_list from u_dw_pick_list
integer width = 2487
string dataobject = "dw_pick_top20_property"
boolean border = false
event list_loaded ( string ps_description )
end type
global u_dw_property_list u_dw_property_list

type variables
// Search Criteria
string context_object
string status = "OK"
string description
string property_name
string property_type
string property_category
string top_20_user_id

// Behavior States
string mode = "EDIT"
boolean allow_editing

// Other states
string current_search = "TOP20"
// Values = TOP20, report

string top_20_code = "property"

string search_description

// Temp variable to hold the record currently being worked on
long top_20_sequence

window myparentwindow

//string script_type = "RTF"

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
public function integer delete_report (long pl_row)
public function integer search_category ()
public function integer retrieve_list (string ps_description, string ps_function_name, string ps_property_type, string ps_property_category)
public function integer search_property_name (string ps_property_name)
public function integer search_property_name ()
public subroutine item_menu (long pl_row)
public function integer configure_property (string ps_report_id)
end prototypes

public function string pick_top_20_code ();string ls_top_20_code


ls_top_20_code = top_20_code + "|" + context_object

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

dataobject = "dw_pick_top20_property"
settransobject(sqlca)

ll_count = retrieve(ps_top_20_user_id, pick_top_20_code(), status)

last_page = 0
set_page(1, ls_temp)

this.event POST list_loaded(search_description)

return ll_count

end function

public function integer search ();integer li_sts
string ls_null

setnull(ls_null)


CHOOSE CASE current_search
	CASE "TOP20"
		li_sts = retrieve_short_list(top_20_user_id)
	CASE "report"
		li_sts = retrieve_list(description, property_name, property_type, property_category)
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

public function integer search_description (string ps_description);integer li_sts

setnull(description)
setnull(property_name)
setnull(property_type)
setnull(property_category)

if isnull(ps_description) or ps_description = "" then
	description = "%"
	search_description = "<All>"
else
	description = "%" + ps_description + "%"
	search_description = 'Contains "' + ps_description + '"'
end if

current_search = "DESCRIPTION"

li_sts = retrieve_list(description, property_name, property_type, property_category)
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

public function integer search_description ();long ll_count
str_popup_return popup_return
integer li_sts

setnull(description)
setnull(property_name)
setnull(property_type)
setnull(property_category)

open(w_pop_get_string_abc, myparentwindow)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

description = popup_return.items[1]
search_description = popup_return.descriptions[1]
	
current_search = "DESCRIPTION"

li_sts = retrieve_list(description, property_name, property_type, property_category)
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

if user_list.is_user_service(current_user.user_id, "CONFIG_PROPERTY") then
	allow_editing = true
else
	allow_editing = false
end if

settransobject(sqlca)

// A bug in PowerBuilder is causing the parent window of the w_pop_time_interval popup
// to sometimes be incorrect, which causes encounterpro to freeze when the popup closes.
// This sections attempts to identify the current active window and uses it as the
// parent of the popup
li_iterations = 0
lo_object = this
DO WHILE isvalid(lo_object) and li_iterations < 20
	if left(lo_object.classname(), 2) = "w_" then
		myparentwindow = lo_object
		exit
	end if
	li_iterations += 1
	lo_object = lo_object.getparent()
LOOP

return 1

end function

public function integer delete_report (long pl_row);long ll_report_id


ll_report_id = object.report_id[pl_row]

UPDATE c_report
SET status = 'NA'
WHERE report_id = :ll_report_id;
if not tf_check() then return -1

return 1

end function

public function integer search_category ();str_popup popup
str_popup_return popup_return
string ls_null
integer li_sts

setnull(ls_null)
setnull(description)
setnull(property_name)
setnull(property_type)
setnull(property_category)

popup.dataobject = "dw_property_category_pick"
popup.datacolumn = 2
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = context_object
openwithparm(w_pop_pick, popup, myparentwindow)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

property_category = popup_return.items[1]
search_description = popup_return.descriptions[1]

current_search = "CATEGORY"

li_sts = retrieve_list(description, property_name, property_type, property_category)
if li_sts < 0 then return -1

return li_sts


end function

public function integer retrieve_list (string ps_description, string ps_function_name, string ps_property_type, string ps_property_category);string ls_temp
long ll_count

dataobject = "dw_jmj_property_search"
settransobject(sqlca)

ll_count = retrieve( &
						context_object, &
						ps_description, &
						ps_function_name, &
						ps_property_type, &
						ps_property_category, &
						status)

last_page = 0
set_page(1, ls_temp)

this.event POST list_loaded(search_description)

return ll_count

end function

public function integer search_property_name (string ps_property_name);integer li_sts

setnull(description)
setnull(property_name)
setnull(property_type)
setnull(property_category)

if isnull(ps_property_name) or ps_property_name = "" then
	property_name = "%"
	search_description = "<All>"
else
	property_name = "%" + ps_property_name + "%"
	search_description = 'Contains "' + ps_property_name + '"'
end if

current_search = "PROPERTY NAME"

li_sts = retrieve_list(description, property_name, property_type, property_category)
if li_sts < 0 then return -1

return li_sts


end function

public function integer search_property_name ();long ll_count
str_popup_return popup_return
integer li_sts

setnull(description)
setnull(property_name)
setnull(property_type)
setnull(property_category)

open(w_pop_get_string_abc, myparentwindow)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

property_name = popup_return.items[1]
search_description = popup_return.descriptions[1]
	
current_search = "PROPERTY NAME"

li_sts = retrieve_list(description, property_name, property_type, property_category)
if li_sts < 0 then return -1

return li_sts


end function

public subroutine item_menu (long pl_row);String		buttons[]
String 		ls_drug_id,ls_temp
String 		ls_description
string		ls_null
String		ls_top_20_code
Integer		button_pressed, li_sts, li_service_count
long		ll_property_id
long ll_null
string ls_status

window 				lw_pop_buttons
//w_property_edit lw_edit_window
w_window_base lw_edit_window
str_popup 			popup
str_popup_return 	popup_return
//w_property_display		lw_property_display
w_window_base		lw_property_display

Setnull(ls_null)
Setnull(ll_null)

ll_property_id = object.property_id[pl_row]
ls_description = object.description[pl_row]

SELECT status
INTO :ls_status
FROM c_Property
WHERE property_id = :ll_property_id;
if not tf_check() then return
if sqlca.sqlcode = 100 then
	log.log(this, "u_dw_property_list.item_menu.0031", "Property not found (" + string(ll_property_id) + ")", 4)
	openwithparm(w_pop_message, "Property not found")
	return
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
//	popup.button_helps[popup.button_count] = "Edit property"
//	popup.button_titles[popup.button_count] = "Edit"
//	buttons[popup.button_count] = "EDIT"
//else
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button17.bmp"
//	popup.button_helps[popup.button_count] = "Review property"
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
//
//if allow_editing then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button17.bmp"
//	popup.button_helps[popup.button_count] = "Configure property"
//	popup.button_titles[popup.button_count] = "Configure"
//	buttons[popup.button_count] = "CONFIGURE"
//end if
//
//if not lb_local_only then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button17.bmp"
//	popup.button_helps[popup.button_count] = "Display/Edit property"
//	popup.button_titles[popup.button_count] = "Display"
//	if allow_editing then popup.button_titles[popup.button_count] += "/Edit"
//	buttons[popup.button_count] = "DISPLAY"
//end if

if allow_editing then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonclone.bmp"
	popup.button_helps[popup.button_count] = "Copy property"
	popup.button_titles[popup.button_count] = "Copy"
	buttons[popup.button_count] = "COPY"
end if

if allow_editing then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonexport.bmp"
	popup.button_helps[popup.button_count] = "Export property"
	popup.button_titles[popup.button_count] = "Export"
	buttons[popup.button_count] = "EXPORT"
end if

if allow_editing then
	if ls_status = "OK" then
		popup.button_count = popup.button_count + 1
		popup.button_icons[popup.button_count] = "button13.bmp"
		popup.button_helps[popup.button_count] = "Make Inactive"
		popup.button_titles[popup.button_count] = "Make Inactive"
		buttons[popup.button_count] = "INACTIVE"
	else
		popup.button_count = popup.button_count + 1
		popup.button_icons[popup.button_count] = "button13.bmp"
		popup.button_helps[popup.button_count] = "Make Active"
		popup.button_titles[popup.button_count] = "Make Active"
		buttons[popup.button_count] = "ACTIVE"
	end if
end if

if allow_editing then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Configure Printers for this property"
	popup.button_titles[popup.button_count] = "Set Printers"
	buttons[popup.button_count] = "PRINTERS"
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
			ll_property_id = object.property_id[pl_row]
			li_sts = tf_add_personal_top_20(ls_top_20_code, ls_description, string(ll_property_id), ls_null, ll_null)
		end if
	CASE "TOP20COMMON"
		ls_top_20_code = pick_top_20_code()
		if not isnull(ls_top_20_code) then
			ll_property_id = object.property_id[pl_row]
			li_sts = tf_add_common_top_20(ls_top_20_code, ls_description, string(ll_property_id), ls_null, ll_null)
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
//	CASE "EDIT"
//		openwithparm(lw_edit_window, ll_property_id, "w_property_edit", myparentwindow)
//	CASE "DISPLAY"
//		SELECT CAST(id AS varchar(38))
//		INTO :popup.items[1]
//		FROM c_property
//		WHERE property_id = :ll_property_id;
//		if not tf_check() then return
//		popup.items[2] = f_boolean_to_string(allow_editing)
//		popup.data_row_count = 2
//		openwithparm(lw_property_display, popup, "w_property_display", myparentwindow)
//	CASE "CONFIGURE"
//		configure_property(ll_property_id)
//	CASE "COPY"
//		openwithparm(w_pop_yes_no, "This will create a new property which is a copy of the ~"" + ls_description + "~" property.  Are you sure you wish to do this?")
//		popup_return = message.powerobjectparm
//		if popup_return.item <> "YES" then return
//		
//		ls_new_property_id = f_copy_property(ll_property_id)
//		if len(ls_new_property_id) > 0 then
//			configure_property(ls_new_property_id)
//		end if
//	CASE "EXPORT"
//		export_property(ll_property_id)
	CASE "INACTIVE"
		openwithparm(w_pop_yes_no, "Are you sure you want to make this property inactive?")
		popup_return = message.powerobjectparm
		if popup_return.item = "YES" then
			UPDATE c_property_Definition
			SET status = 'NA'
			WHERE property_id =:ll_property_id;
			if not tf_check() then return
		end if
		openwithparm(w_pop_yes_no, "Do you want to remove this property from all short-lists?")
		popup_return = message.powerobjectparm
		if popup_return.item = "YES" then
			DELETE FROM u_top_20
			WHERE top_20_code LIKE 'property%'
			AND item_id = :ll_property_id;
			if not tf_check() then return
		end if
	CASE "ACTIVE"
		openwithparm(w_pop_yes_no, "Are you sure you want to make this property active?")
		popup_return = message.powerobjectparm
		if popup_return.item = "YES" then
			UPDATE c_property_Definition
			SET status = 'OK'
			WHERE property_id =:ll_property_id;
			if not tf_check() then return
		end if
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

Return

end subroutine

public function integer configure_property (string ps_report_id);
return 1

end function

on u_dw_property_list.create
call super::create
end on

on u_dw_property_list.destroy
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
	item_menu(clicked_row)
	
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

if mode = "EDIT" and allow_editing then
	if current_search = "TOP20" then
		top_20_sequence = object.top_20_sequence[row]
	end if
	
	li_selected_flag = object.selected_flag[row]
	
	object.selected_flag[row] = 1
	item_menu(row)
	
	clear_selected()
end if


end event

event retrieveend;call super::retrieveend;object.t_background.width = width - 251
end event

