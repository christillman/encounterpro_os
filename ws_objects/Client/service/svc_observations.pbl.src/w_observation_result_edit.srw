$PBExportHeader$w_observation_result_edit.srw
forward
global type w_observation_result_edit from w_window_base
end type
type pb_done from u_picture_button within w_observation_result_edit
end type
type st_title from statictext within w_observation_result_edit
end type
type dw_results from u_dw_pick_list within w_observation_result_edit
end type
type cb_new_result from commandbutton within w_observation_result_edit
end type
type cb_move from commandbutton within w_observation_result_edit
end type
type cb_delete from commandbutton within w_observation_result_edit
end type
type cb_alpha from commandbutton within w_observation_result_edit
end type
type cb_edit from commandbutton within w_observation_result_edit
end type
type cb_result_set from commandbutton within w_observation_result_edit
end type
type pb_1 from u_pb_help_button within w_observation_result_edit
end type
type st_page from statictext within w_observation_result_edit
end type
type pb_up from u_picture_button within w_observation_result_edit
end type
type pb_down from u_picture_button within w_observation_result_edit
end type
end forward

global type w_observation_result_edit from w_window_base
boolean titlebar = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
pb_done pb_done
st_title st_title
dw_results dw_results
cb_new_result cb_new_result
cb_move cb_move
cb_delete cb_delete
cb_alpha cb_alpha
cb_edit cb_edit
cb_result_set cb_result_set
pb_1 pb_1
st_page st_page
pb_up pb_up
pb_down pb_down
end type
global w_observation_result_edit w_observation_result_edit

type variables
string observation_id
string result_type

end variables

forward prototypes
public subroutine location_menu (long pl_row)
public function integer modify_result_set ()
public function integer delete_result_set ()
public function integer new_result_set ()
public function integer display_results ()
public function integer add_result_set (long pl_result_set)
public function integer edit_result (long pl_row)
public subroutine alphabetize ()
end prototypes

public subroutine location_menu (long pl_row);str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons
string ls_user_id
integer li_update_flag
string ls_cpt_code
decimal ldc_charge

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit Procedure Details"
	popup.button_titles[popup.button_count] = "Edit Procedure"
	buttons[popup.button_count] = "EDIT"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button05.bmp"
	popup.button_helps[popup.button_count] = "Change Procedure"
	popup.button_titles[popup.button_count] = "Change Procedure"
	buttons[popup.button_count] = "CHANGE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonx5.bmp"
	popup.button_helps[popup.button_count] = "Not Applicable"
	popup.button_titles[popup.button_count] = "N/A"
	buttons[popup.button_count] = "NA"
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
	CASE "CHANGE"
	CASE "NA"
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return

end subroutine

public function integer modify_result_set ();str_popup popup
str_popup_return popup_return
long ll_result_set_id
string ls_temp

popup.dataobject = "dw_result_set_pick_list"
popup.datacolumn = 1
popup.displaycolumn = 2

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count = 0 then return 0

ll_result_set_id = long(popup_return.items[1])

ls_temp = 'Are you sure you wish to modify the result set "' + popup_return.descriptions[1] + '"?'
openwithparm(w_pop_yes_no, ls_temp)
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return 0

tf_begin_transaction(this, "modify_result_set()")

// First, delete the existing result set items
DELETE FROM c_Observation_Result_Set_Item
WHERE result_set_id = :ll_result_set_id;
if not tf_check() then return -1

// Now add all the results from this observation to the result set
INSERT INTO c_Observation_Result_Set_Item (
	result_set_id,
	result_sequence,
	result_type,
	result_unit,
	result,
	result_amount_flag,
	severity,
	abnormal_flag,
	sort_sequence)
SELECT
	:ll_result_set_id,
	result_sequence,
	result_type,
	result_unit,
	result,
	result_amount_flag,
	severity,
	abnormal_flag,
	sort_sequence
FROM c_Observation_Result
WHERE observation_id = :observation_id
AND status = 'OK';
if not tf_check() then return -1

tf_commit_transaction()

return 1

end function

public function integer delete_result_set ();str_popup popup
str_popup_return popup_return
long ll_result_set_id
string ls_temp

popup.dataobject = "dw_result_set_pick_list"
popup.datacolumn = 1
popup.displaycolumn = 2

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count = 0 then return 0

ll_result_set_id = long(popup_return.items[1])

ls_temp = 'Are you sure you wish to delete the result set "' + popup_return.descriptions[1] + '"?'
openwithparm(w_pop_yes_no, ls_temp)
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return 0

tf_begin_transaction(this, "modify_result_set()")

// First, delete the existing result set items
DELETE FROM c_Observation_Result_Set_Item
WHERE result_set_id = :ll_result_set_id;
if not tf_check() then return -1

// Then, delete the existing result set
DELETE FROM c_Observation_Result_Set
WHERE result_set_id = :ll_result_set_id;
if not tf_check() then return -1

tf_commit_transaction()

return 1

end function

public function integer new_result_set ();u_ds_data luo_result_sets
str_popup popup
str_popup_return popup_return
long ll_row
string ls_find
integer li_sts
long ll_result_set_id

// Initialize result set datastore
luo_result_sets = CREATE u_ds_data
luo_result_sets.set_dataobject("dw_result_set_pick_list")
luo_result_sets.retrieve()

// Ask the user for the name of the new result set
popup.title = "Enter the name of the new result set:"
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

// Make sure it doesn't already exist
ls_find = "description='" + popup_return.items[1] + "'"
ll_row = luo_result_sets.find(ls_find, 1, luo_result_sets.rowcount())
if ll_row > 0 then
	openwithparm(w_pop_message, "There is already a result set with that name")
	return 0
end if

// Add the new result set
ll_row = luo_result_sets.insertrow(0)
luo_result_sets.object.description[ll_row] = popup_return.items[1]

li_sts = luo_result_sets.update()
if li_sts <= 0 then
	log.log(this, "w_observation_result_edit.new_result_set:0034", "Error creating new result set", 4)
	return -1
end if

ll_result_set_id = luo_result_sets.object.result_set_id[ll_row]


// Now add all the results from this observation to the new result set
INSERT INTO c_Observation_Result_Set_Item (
	result_set_id,
	result_sequence,
	result_type,
	result_unit,
	result,
	result_amount_flag,
	severity,
	abnormal_flag,
	sort_sequence)
SELECT
	:ll_result_set_id,
	result_sequence,
	result_type,
	result_unit,
	result,
	result_amount_flag,
	severity,
	abnormal_flag,
	sort_sequence
FROM c_Observation_Result
WHERE observation_id = :observation_id
AND status = 'OK';
if not tf_check() then return -1
	

return 1

end function

public function integer display_results ();integer li_sts

li_sts = dw_results.retrieve(observation_id, result_type)
if li_sts < 0 then return -1

if dw_results.rowcount() = 0 then
	cb_result_set.text = "Add Result Set"
else
	cb_result_set.text = "Set Result Set"
end if

cb_delete.enabled = false
cb_edit.enabled = false
cb_move.enabled = false
// Up/down buttons

dw_results.last_page = 0
dw_results.set_page(1, pb_up, pb_down, st_page)

Return 1

end function

public function integer add_result_set (long pl_result_set);u_ds_data luo_observation_results
u_ds_data luo_result_set_items
long ll_result_count
long ll_result_set_item_count
long i
integer li_sts
integer li_result_sequence
long ll_row
string ls_result_type

// Initialize data stores
luo_observation_results = CREATE u_ds_data
luo_result_set_items = CREATE u_ds_data

luo_observation_results.set_dataobject("dw_observation_results")
luo_result_set_items.set_dataobject("dw_result_set_items")

// get the existing results for this observation and the results for this result set
ll_result_count = luo_observation_results.retrieve(observation_id)
ll_result_set_item_count = luo_result_set_items.retrieve(pl_result_set)

// Find the highest result sequence that already exists
if ll_result_count > 0 then
	luo_observation_results.setsort("result_sequence a")
	luo_observation_results.sort()
	li_result_sequence = luo_observation_results.object.result_sequence[ll_result_count]
else
	li_result_sequence = 0
end if

// Now add the new result set items
for i = 1 to ll_result_set_item_count
	ls_result_type = luo_result_set_items.object.result_type[i]
	if ls_result_type = result_type then
		ll_row = luo_observation_results.insertrow(0)
		luo_observation_results.object.observation_id[ll_row] = observation_id
		luo_observation_results.object.result_sequence[ll_row] = li_result_sequence + i
		luo_observation_results.object.result_type[ll_row] = luo_result_set_items.object.result_type[i]
		luo_observation_results.object.result_unit[ll_row] = luo_result_set_items.object.result_unit[i]
		luo_observation_results.object.result[ll_row] = luo_result_set_items.object.result[i]
		luo_observation_results.object.result_amount_flag[ll_row] = luo_result_set_items.object.result_amount_flag[i]
		luo_observation_results.object.severity[ll_row] = luo_result_set_items.object.severity[i]
		luo_observation_results.object.abnormal_flag[ll_row] = luo_result_set_items.object.abnormal_flag[i]
		luo_observation_results.object.sort_sequence[ll_row] = luo_result_set_items.object.sort_sequence[i]
		luo_observation_results.object.status[ll_row] = "OK"
	end if
next

li_sts = luo_observation_results.update()
if li_sts < 0 then
	log.log(this, "w_observation_result_edit.add_result_set:0051", "Error adding new result set items", 4)
	return -1
end if

display_results()

return 1

end function

public function integer edit_result (long pl_row);str_popup popup
str_popup_return popup_return
integer li_result_sequence

li_result_sequence = dw_results.object.result_sequence[pl_row]

popup.data_row_count = 3
popup.items[1] = observation_id
popup.items[2] = result_type
popup.items[3] = string(li_result_sequence)
popup.title = st_title.text

openwithparm(w_observation_result_definition, popup)
popup_return = message.powerobjectparm
if popup_return.item_count = 0 then return 0

return 1

end function

public subroutine alphabetize ();long ll_rowcount
integer i

dw_results.clear_selected()

dw_results.setsort("result A")
dw_results.sort()

ll_rowcount = dw_results.rowcount()

for i = 1 to ll_rowcount
	dw_results.setitem(i, "sort_sequence", i)
next

dw_results.setsort("sort_sequence A")

dw_results.update()

end subroutine

on w_observation_result_edit.create
int iCurrent
call super::create
this.pb_done=create pb_done
this.st_title=create st_title
this.dw_results=create dw_results
this.cb_new_result=create cb_new_result
this.cb_move=create cb_move
this.cb_delete=create cb_delete
this.cb_alpha=create cb_alpha
this.cb_edit=create cb_edit
this.cb_result_set=create cb_result_set
this.pb_1=create pb_1
this.st_page=create st_page
this.pb_up=create pb_up
this.pb_down=create pb_down
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_done
this.Control[iCurrent+2]=this.st_title
this.Control[iCurrent+3]=this.dw_results
this.Control[iCurrent+4]=this.cb_new_result
this.Control[iCurrent+5]=this.cb_move
this.Control[iCurrent+6]=this.cb_delete
this.Control[iCurrent+7]=this.cb_alpha
this.Control[iCurrent+8]=this.cb_edit
this.Control[iCurrent+9]=this.cb_result_set
this.Control[iCurrent+10]=this.pb_1
this.Control[iCurrent+11]=this.st_page
this.Control[iCurrent+12]=this.pb_up
this.Control[iCurrent+13]=this.pb_down
end on

on w_observation_result_edit.destroy
call super::destroy
destroy(this.pb_done)
destroy(this.st_title)
destroy(this.dw_results)
destroy(this.cb_new_result)
destroy(this.cb_move)
destroy(this.cb_delete)
destroy(this.cb_alpha)
destroy(this.cb_edit)
destroy(this.cb_result_set)
destroy(this.pb_1)
destroy(this.st_page)
destroy(this.pb_up)
destroy(this.pb_down)
end on

event open;call super::open;str_popup popup
long i
integer li_sort_sequence
integer li_sts

popup = message.powerobjectparm

if popup.data_row_count = 2 then
	observation_id = popup.items[1]
	result_type = popup.items[2]
else
	observation_id = popup.item
	result_type = "PERFORM"
end if

st_title.text = popup.title + " (" + result_type + ")"

dw_results.settransobject(sqlca)

display_results()


end event

type pb_epro_help from w_window_base`pb_epro_help within w_observation_result_edit
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_observation_result_edit
end type

type pb_done from u_picture_button within w_observation_result_edit
integer x = 2569
integer y = 1556
integer width = 256
integer height = 224
integer taborder = 90
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;close(parent)


end event

type st_title from statictext within w_observation_result_edit
integer width = 2917
integer height = 156
boolean bringtotop = true
integer textsize = -20
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_results from u_dw_pick_list within w_observation_result_edit
integer x = 73
integer y = 196
integer width = 1271
integer height = 1580
integer taborder = 70
string dataobject = "dw_result_edit_list"
boolean border = false
boolean livescroll = false
end type

event unselected;call super::unselected;cb_delete.enabled = false
cb_move.enabled = false
cb_edit.enabled = false

end event

event selected;
cb_delete.enabled = true
cb_edit.enabled = true
cb_move.enabled = true


end event

type cb_new_result from commandbutton within w_observation_result_edit
integer x = 1879
integer y = 432
integer width = 471
integer height = 108
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Result"
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.data_row_count = 2
popup.items[1] = observation_id
popup.items[2] = result_type
popup.title = st_title.text

openwithparm(w_observation_result_definition, popup)
popup_return = message.powerobjectparm
if popup_return.item_count = 0 then return

display_results()

dw_results.setitem(dw_results.rowcount(), "selected_flag", 1)

cb_delete.enabled = true
cb_edit.enabled = true
cb_move.enabled = true


end event

type cb_move from commandbutton within w_observation_result_edit
integer x = 1879
integer y = 1132
integer width = 471
integer height = 108
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Move"
end type

event clicked;str_popup popup
long ll_row
integer li_sts
long ll_rowcount
long i

ll_row = dw_results.get_selected_row()
if ll_row <= 0 then return 0

ll_rowcount = dw_results.rowcount()
for i = 1 to ll_rowcount
	dw_results.object.sort_sequence[ll_row] = i
next

popup.objectparm = dw_results

openwithparm(w_pick_list_sort, popup)

li_sts = dw_results.update()
if li_sts <= 0 then
	openwithparm(w_pop_message, "Sort update failed")
	return
end if

return


end event

type cb_delete from commandbutton within w_observation_result_edit
event clicked pbm_bnclicked
integer x = 1879
integer y = 872
integer width = 471
integer height = 108
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete"
end type

event clicked;integer li_result_sequence
string ls_result
long ll_row

// DECLARE lsp_set_result_na PROCEDURE FOR dbo.sp_set_result_na  
//         @ps_observation_id = :observation_id,   
//         @pi_result_sequence = :li_result_sequence  ;
//
//
ll_row = dw_results.get_selected_row()
if ll_row <= 0 then return

li_result_sequence = dw_results.object.result_sequence[ll_row]
ls_result = dw_results.object.result[ll_row]

openwithparm(w_pop_ok, "Delete " + ls_result + "?")
if message.doubleparm <> 1 then return 0

sqlca.sp_set_result_na(observation_id, li_result_sequence);
//EXECUTE lsp_set_result_na;
if not tf_check() then return

display_results()


end event

type cb_alpha from commandbutton within w_observation_result_edit
event clicked pbm_bnclicked
integer x = 1879
integer y = 1536
integer width = 471
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Sort"
end type

event clicked;alphabetize()
end event

type cb_edit from commandbutton within w_observation_result_edit
integer x = 1879
integer y = 652
integer width = 471
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Edit"
end type

event clicked;long ll_row
integer li_sts

ll_row = dw_results.get_selected_row()
if ll_row <= 0 then return

li_sts = edit_result(ll_row)
if li_sts <= 0 then return





end event

type cb_result_set from commandbutton within w_observation_result_edit
integer x = 1879
integer y = 212
integer width = 759
integer height = 108
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add Result Set"
end type

event clicked;str_popup popup
str_popup_return popup_return
integer li_sts
long ll_result_set

if dw_results.rowcount() = 0 then
	// Since there are no results, the user must want to add an existing result set
	popup.dataobject = "dw_result_set_pick_list"
	popup.datacolumn = 1
	popup.displaycolumn = 2
	
	openwithparm(w_pop_pick, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count = 0 then return

	ll_result_set = long(popup_return.items[1])
	
	if ll_result_set > 0 then
		li_sts = add_result_set(ll_result_set)
		if li_sts <= 0 then
			log.log(this, "w_observation_result_edit.cb_result_set.clicked:0021", "Error adding result set (" + string(ll_result_set) + ")", 4)
			return
		end if
		display_results()
	end if
else
	// Since there are results, the user must want to update an existing result set or
	// create a new result set.  First find out which the user wants:
	popup.data_row_count = 3
	popup.items[1] = "Create a new result set from these results"
	popup.items[2] = "Modify an existing result set to these results"
	popup.items[3] = "Delete an existing result set"
	popup.title = "Do you wish to:"
	popup.dataobject = "dw_pick_generic_wide"
	openwithparm(w_pop_pick, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return
	
	// Find out which the user selected
	CHOOSE CASE popup_return.item_indexes[1]
		CASE 1
			// Create a new result set
			li_sts = new_result_set()
		CASE 2
			// Modify an existing result set
			li_sts = modify_result_set()
		CASE 3
			// Delete a result set
			li_sts = delete_result_set()
		CASE ELSE
	END CHOOSE
	
end if



end event

type pb_1 from u_pb_help_button within w_observation_result_edit
integer x = 2569
integer y = 1328
integer width = 256
integer height = 128
integer taborder = 20
boolean bringtotop = true
end type

type st_page from statictext within w_observation_result_edit
integer x = 1422
integer y = 188
integer width = 256
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Page 99/99"
boolean focusrectangle = false
end type

type pb_up from u_picture_button within w_observation_result_edit
boolean visible = false
integer x = 1573
integer y = 284
integer width = 146
integer height = 124
integer taborder = 11
boolean bringtotop = true
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_results.current_page

dw_results.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from u_picture_button within w_observation_result_edit
boolean visible = false
integer x = 1394
integer y = 284
integer width = 137
integer height = 116
integer taborder = 21
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_results.current_page
li_last_page = dw_results.last_page

dw_results.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true
end event

