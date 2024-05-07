$PBExportHeader$w_menu_selection.srw
forward
global type w_menu_selection from w_window_base
end type
type dw_menus from u_dw_pick_list within w_menu_selection
end type
type cb_finished from commandbutton within w_menu_selection
end type
type st_title from statictext within w_menu_selection
end type
type st_menu_context_title from statictext within w_menu_selection
end type
type cb_move from commandbutton within w_menu_selection
end type
type cb_delete from commandbutton within w_menu_selection
end type
type cb_insert from commandbutton within w_menu_selection
end type
type st_menu_context from statictext within w_menu_selection
end type
type st_office_title from statictext within w_menu_selection
end type
type st_office from statictext within w_menu_selection
end type
type cb_edit from commandbutton within w_menu_selection
end type
type st_menu_key_title from statictext within w_menu_selection
end type
type st_menu_key_description from statictext within w_menu_selection
end type
end forward

global type w_menu_selection from w_window_base
integer width = 3401
integer height = 2092
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
dw_menus dw_menus
cb_finished cb_finished
st_title st_title
st_menu_context_title st_menu_context_title
cb_move cb_move
cb_delete cb_delete
cb_insert cb_insert
st_menu_context st_menu_context
st_office_title st_office_title
st_office st_office
cb_edit cb_edit
st_menu_key_title st_menu_key_title
st_menu_key_description st_menu_key_description
end type
global w_menu_selection w_menu_selection

type variables

str_menu_context menu_context
string filter_office_id

string menu_key_domain

end variables

forward prototypes
public function integer save_changes ()
public function integer refresh ()
public function string menu_key_description (string ps_menu_key)
public function string pick_menu_key (string ps_menu_key)
public function string pick_assessment_type ()
public function string pick_encounter_status ()
public function string pick_encounter_type ()
public function string pick_room_type ()
public function string pick_treatment_type ()
public function string pick_context_object ()
public function string pick_function_key ()
end prototypes

public function integer save_changes ();//long i
//long ll_report_printer_sequence
//string ls_office_id
//long ll_computer_id
//string ls_room_id
//long ll_sort_sequence
//string ls_printer
//
//for i = 1 to dw_printers.rowcount()
//	ll_report_printer_sequence = dw_printers.object.report_printer_sequence[i]
//	ls_office_id = dw_printers.object.office_id[i]
//	ll_computer_id = dw_printers.object.computer_id[i]
//	ls_room_id = dw_printers.object.room_id[i]
//	ll_sort_sequence = dw_printers.object.sort_sequence[i]
//	ls_printer = dw_printers.object.printer[i]
//	
//	UPDATE o_Report_Printer
//	SET office_id = :ls_office_id,
//		computer_id = :ll_computer_id,
//		room_id = :ls_room_id,
//		printer = :ls_printer,
//		sort_sequence = :ll_sort_sequence
//	WHERE report_id = :report_id
//	AND report_printer_sequence = :ll_report_printer_sequence;
//	if not tf_check() then return -1
//next

return 1

end function

public function integer refresh ();long ll_rows
string ls_filter
long ll_count
long i
string ls_menu_key
string ls_menu_key_description

ll_rows = dw_menus.retrieve(menu_context.menu_context)
if ll_rows < 0 then return -1

if isnull(filter_office_id) then
	ls_filter = "isnull(office_id)"
else
	ls_filter = "office_id='" + filter_office_id + "'"
end if

dw_menus.setfilter(ls_filter)
dw_menus.filter()

ll_count = dw_menus.rowcount()

for i = 1 to ll_count
	ls_menu_key = dw_menus.object.menu_key[i]
	ls_menu_key_description = menu_key_description(ls_menu_key)
	if len(ls_menu_key_description) > 0 then
		dw_menus.object.menu_key_description[i] = ls_menu_key_description
	else
		dw_menus.object.menu_key_description[i] = "<Any>"
	end if
next


return 1

end function

public function string menu_key_description (string ps_menu_key);string ls_menu_key_description


CHOOSE CASE upper(menu_key_domain)
	CASE "ASSESSMENT TYPE"
		ls_menu_key_description = datalist.assessment_type_description(ps_menu_key)
	CASE "ENCOUNTER STATUS"
		ls_menu_key_description = wordcap(ps_menu_key)
	CASE "ENCOUNTER TYPE"
		ls_menu_key_description = datalist.encounter_type_description(ps_menu_key)
	CASE "ROOM TYPE/ROOM"
		if left(ps_menu_key, 1) = "$" then
			ls_menu_key_description = ps_menu_key
		else
			ls_menu_key_description = room_list.room_name(ps_menu_key)
		end if
	CASE "TREATMENT TYPE"
		ls_menu_key_description = datalist.treatment_type_description(ps_menu_key)
	CASE ELSE
		ls_menu_key_description = ps_menu_key
END CHOOSE

return ls_menu_key_description


end function

public function string pick_menu_key (string ps_menu_key);string ls_new_menu_key


CHOOSE CASE upper(menu_key_domain)
	CASE "ASSESSMENT TYPE"
		ls_new_menu_key = pick_assessment_type()
	CASE "CONTEXT OBJECT"
		ls_new_menu_key = pick_context_object()
	CASE "ENCOUNTER STATUS"
		ls_new_menu_key = pick_encounter_status()
	CASE "ENCOUNTER TYPE"
		ls_new_menu_key = pick_encounter_type()
	CASE "FUNCTION KEY"
		ls_new_menu_key = pick_function_key()
	CASE "ROOM TYPE/ROOM"
		ls_new_menu_key = pick_room_type()
	CASE "TREATMENT TYPE"
		ls_new_menu_key = pick_treatment_type()
	CASE ELSE
		setnull(ls_new_menu_key)
END CHOOSE

return ls_new_menu_key


end function

public function string pick_assessment_type ();str_popup popup
str_popup_return popup_return
string ls_null

setnull(ls_null)

popup.dataobject = "dw_assessment_type_list"
popup.datacolumn = 1
popup.displaycolumn = 2
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return ls_null

return popup_return.items[1]

end function

public function string pick_encounter_status ();str_popup popup
str_popup_return popup_return
string ls_null

setnull(ls_null)

popup.data_row_count = 3
popup.items[1] = "Open"
popup.items[2] = "Closed"
popup.items[3] = "Canceled"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return ls_null

return popup_return.items[1]

end function

public function string pick_encounter_type ();str_popup popup
string ls_encounter_type

popup.data_row_count = 2
popup.items[1] = "PICK"
popup.items[2] = "D"

openwithparm(w_pick_encounter_type, popup)
ls_encounter_type = message.stringparm

return ls_encounter_type

end function

public function string pick_room_type ();str_popup popup
str_popup_return popup_return
string ls_null

setnull(ls_null)

popup.dataobject = "dw_c_room_type"
popup.datacolumn = 1
popup.displaycolumn = 2
if len(filter_office_id) > 0 then
	popup.add_blank_row = true
	popup.blank_text = "<Specific Room>"
else
	popup.add_blank_row = false
end if
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return ls_null

if len(popup_return.items[1]) > 0 then
	return popup_return.items[1]
end if

// User selected "<Specific Room>"
popup.dataobject = "dw_room_list_office"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.add_blank_row = false
popup.argument_count = 1
popup.argument[1] = filter_office_id
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return ls_null

return popup_return.items[1]

end function

public function string pick_treatment_type ();str_popup popup
str_popup_return popup_return
string ls_null

setnull(ls_null)

popup.dataobject = "dw_treatment_type_config_pick_list"
popup.datacolumn = 2
popup.displaycolumn = 4
popup.argument_count = 1
popup.argument[1] = "OK"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return ls_null

return popup_return.items[1]

end function

public function string pick_context_object ();str_popup popup
str_popup_return popup_return
string ls_null

setnull(ls_null)

popup.title = "Select Context Object"
popup.dataobject = "dw_domain_notranslate_list"
popup.datacolumn = 2
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = "CONTEXT_OBJECT"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return ls_null


return popup_return.items[1]

end function

public function string pick_function_key ();str_popup popup
str_popup_return popup_return
string ls_null

setnull(ls_null)

popup.title = "Select Function Key"
popup.data_row_count = 4
popup.items[1] = "F10"
popup.items[2] = "Shift F10"
popup.items[3] = "F11"
popup.items[4] = "Shift F11"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return ls_null


return popup_return.items[1]

end function

on w_menu_selection.create
int iCurrent
call super::create
this.dw_menus=create dw_menus
this.cb_finished=create cb_finished
this.st_title=create st_title
this.st_menu_context_title=create st_menu_context_title
this.cb_move=create cb_move
this.cb_delete=create cb_delete
this.cb_insert=create cb_insert
this.st_menu_context=create st_menu_context
this.st_office_title=create st_office_title
this.st_office=create st_office
this.cb_edit=create cb_edit
this.st_menu_key_title=create st_menu_key_title
this.st_menu_key_description=create st_menu_key_description
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_menus
this.Control[iCurrent+2]=this.cb_finished
this.Control[iCurrent+3]=this.st_title
this.Control[iCurrent+4]=this.st_menu_context_title
this.Control[iCurrent+5]=this.cb_move
this.Control[iCurrent+6]=this.cb_delete
this.Control[iCurrent+7]=this.cb_insert
this.Control[iCurrent+8]=this.st_menu_context
this.Control[iCurrent+9]=this.st_office_title
this.Control[iCurrent+10]=this.st_office
this.Control[iCurrent+11]=this.cb_edit
this.Control[iCurrent+12]=this.st_menu_key_title
this.Control[iCurrent+13]=this.st_menu_key_description
end on

on w_menu_selection.destroy
call super::destroy
destroy(this.dw_menus)
destroy(this.cb_finished)
destroy(this.st_title)
destroy(this.st_menu_context_title)
destroy(this.cb_move)
destroy(this.cb_delete)
destroy(this.cb_insert)
destroy(this.st_menu_context)
destroy(this.st_office_title)
destroy(this.st_office)
destroy(this.cb_edit)
destroy(this.st_menu_key_title)
destroy(this.st_menu_key_description)
end on

event open;call super::open;long ll_office_width
long ll_x
string ls_temp

menu_context = message.powerobjectparm
setnull(filter_office_id)

SELECT domain_item_description, domain_item_bitmap
INTO :st_menu_context.text, :menu_key_domain
FROM c_Domain
WHERE domain_id = 'Menu Context'
AND domain_item = :menu_context.menu_context;
if not tf_check() then
	close(this)
	return
end if
if sqlca.sqlcode = 100 then
	st_menu_context.text = menu_context.menu_context
	setnull(menu_key_domain)
end if

// Calculate the x-position of the menu_key_description column
ll_x = 942
if dw_menus.width > 3369 then
	ll_x += (dw_menus.width - 3369) / 2
end if
dw_menus.object.menu_key_description.x = ll_x

if isnull(menu_key_domain) then
	dw_menus.modify("menu_key_description.visible=0")
	st_menu_key_description.visible = false
	st_menu_key_title.visible = false
else
	dw_menus.modify("t_menu_key.text='" + menu_key_domain + "'")
	
	ls_temp = menu_key_description(menu_context.menu_key)
	if len(ls_temp) > 0 then
		st_menu_key_description.text = ls_temp
	end if
	ls_temp = menu_key_description(menu_context.menu_key2)
	if len(ls_temp) > 0 then
		if len(st_menu_key_description.text) > 0 then
			st_menu_key_description.text += ", " + ls_temp
		else
			st_menu_key_description.text = ls_temp
		end if
	end if
	
	st_menu_key_title.text = menu_key_domain
end if


dw_menus.settransobject(sqlca)

refresh()



end event

type pb_epro_help from w_window_base`pb_epro_help within w_menu_selection
integer x = 3333
integer y = 32
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_menu_selection
end type

type dw_menus from u_dw_pick_list within w_menu_selection
integer y = 556
integer width = 3374
integer height = 1240
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_o_menu_selection_edit"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;cb_delete.enabled = true
cb_move.enabled = true
cb_edit.enabled = true

end event

event unselected;call super::unselected;cb_delete.enabled = false
cb_move.enabled = false
cb_edit.enabled = false

end event

type cb_finished from commandbutton within w_menu_selection
integer x = 2921
integer y = 1880
integer width = 443
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
end type

event clicked;integer li_sts

li_sts = save_changes()
if li_sts <= 0 then
	openwithparm(w_pop_message, "Error saving changes")
	return
end if

close(parent)


end event

type st_title from statictext within w_menu_selection
integer width = 3406
integer height = 120
boolean bringtotop = true
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Menu Selection"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_menu_context_title from statictext within w_menu_selection
integer x = 311
integer y = 136
integer width = 613
integer height = 72
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Menu Context"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_move from commandbutton within w_menu_selection
integer x = 1806
integer y = 1824
integer width = 402
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Move"
end type

event clicked;str_popup popup
long ll_row
integer li_sts
long ll_rowcount
long i

ll_row = dw_menus.get_selected_row()
if ll_row <= 0 then return 0

ll_rowcount = dw_menus.rowcount()
for i = 1 to ll_rowcount
	dw_menus.object.sort_sequence[ll_row] = i
next

popup.objectparm = dw_menus

openwithparm(w_pick_list_sort, popup)

dw_menus.update()

return


end event

type cb_delete from commandbutton within w_menu_selection
integer x = 1143
integer y = 1824
integer width = 402
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Delete"
end type

event clicked;str_popup_return popup_return
long ll_row
long ll_rowcount
long ll_room_menu_selection_id

ll_row = dw_menus.get_selected_row()
if ll_row <= 0 then return

openwithparm(w_pop_yes_no, "Are you sure you wish to delete this menu selection rule?")
popup_return = message.powerobjectparm
if popup_return.item = "YES" then
	ll_room_menu_selection_id = dw_menus.object.room_menu_selection_id[ll_row]
	DELETE o_menu_selection
	WHERE menu_context = :menu_context.menu_context
	AND room_menu_selection_id = :ll_room_menu_selection_id;
	if not tf_check() then return
	
	dw_menus.deleterow(ll_row)
end if


end event

type cb_insert from commandbutton within w_menu_selection
integer x = 480
integer y = 1824
integer width = 402
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Insert"
end type

event clicked;long ll_row
long ll_sort_sequence
long ll_new_menu_id
w_window_base lw_window
str_popup_return popup_return

openwithparm(lw_window, menu_context.context_object, "w_pick_menu")
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ll_new_menu_id = long(popup_return.items[1])

SELECT max(sort_sequence)
INTO :ll_sort_sequence
FROM dbo.o_menu_selection 
WHERE ISNULL(office_id , '!NUL') = ISNULL(:filter_office_id, '!NUL')
AND menu_context = :menu_context.menu_context
AND menu_key = :menu_context.menu_key;
if not tf_check() then return

if isnull(ll_sort_sequence) then
	ll_sort_sequence = 1
else
	ll_sort_sequence += 1
end if

INSERT INTO dbo.o_menu_selection (
	office_id
	,menu_context
	,menu_key
	,user_id
	,menu_id
	,sort_sequence
	,owner_id
	,last_updated
	,id
	,status)
VALUES (
	:filter_office_id,
	:menu_context.menu_context,
	:menu_context.menu_key,
	NULL,
	:ll_new_menu_id,
	:ll_sort_sequence,
	:sqlca.customer_id,
	dbo.get_client_datetime(),
	newid(),
	'OK');
if not tf_check() then return

refresh()

end event

type st_menu_context from statictext within w_menu_selection
integer x = 946
integer y = 136
integer width = 1632
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "none"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_office_title from statictext within w_menu_selection
integer x = 777
integer y = 392
integer width = 466
integer height = 72
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Office"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_office from statictext within w_menu_selection
integer x = 1257
integer y = 380
integer width = 1006
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "<Any>"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
u_user luo_user

popup.dataobject = "dw_office_pick"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.add_blank_row = true
popup.blank_text = "<Any>"

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	text = "<Any>"
	setnull(filter_office_id)
else
	filter_office_id = popup_return.items[1]
	text = popup_return.descriptions[1]
end if

refresh()


end event

type cb_edit from commandbutton within w_menu_selection
integer x = 2469
integer y = 1824
integer width = 402
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Edit"
end type

event clicked;str_popup popup
str_popup_return popup_return
long ll_row
integer li_sts
long ll_rowcount
long i
string ls_user_id
string ls_menu_key
long ll_menu_id
string lsa_action[]
long ll_room_menu_selection_id
w_window_base lw_window
string ls_new_menu_key
long ll_new_menu_id
str_menu lstr_menu

ll_row = dw_menus.get_selected_row()
if ll_row <= 0 then return 0

ll_room_menu_selection_id = dw_menus.object.room_menu_selection_id[ll_row]
ls_user_id = dw_menus.object.user_id[ll_row]
ls_menu_key = dw_menus.object.menu_key[ll_row]
ll_menu_id = dw_menus.object.menu_id[ll_row]

popup.data_row_count = 0

if len(ls_user_id) > 0 then
	popup.data_row_count += 1
	popup.items[popup.data_row_count] = "Clear User/Specialty"
	lsa_action[popup.data_row_count] = "Clear User"
end if

popup.data_row_count += 1
popup.items[popup.data_row_count] = "Change User/Specialty"
lsa_action[popup.data_row_count] = "Change User"

if len(menu_key_domain) > 0 then
	if len(ls_menu_key) > 0 then
		popup.data_row_count += 1
		popup.items[popup.data_row_count] = "Clear " + menu_key_domain
		lsa_action[popup.data_row_count] = "Clear Key"
	end if
	
	popup.data_row_count += 1
	popup.items[popup.data_row_count] = "Change " + menu_key_domain
	lsa_action[popup.data_row_count] = "Change Key"
end if

if ll_menu_id > 0 then
	popup.data_row_count += 1
	popup.items[popup.data_row_count] = "Edit Menu"
	lsa_action[popup.data_row_count] = "Edit Menu"
end if

popup.data_row_count += 1
popup.items[popup.data_row_count] = "Change Menu"
lsa_action[popup.data_row_count] = "Change Menu"

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

CHOOSE CASE lsa_action[popup_return.item_indexes[1]]
	CASE "Clear User"
		if f_popup_yes_no("Are you sure you want to clear the user/specialty for this menu selection rule?") then
			UPDATE o_Menu_Selection
			SET user_id = NULL
			WHERE room_menu_selection_id = :ll_room_menu_selection_id;
			if not tf_check() then return
		end if
	CASE "Change User"
		ls_user_id = f_pick_specialty_user()
		if isnull(ls_user_id) then return
		
		UPDATE o_Menu_Selection
		SET user_id = :ls_user_id
		WHERE room_menu_selection_id = :ll_room_menu_selection_id;
		if not tf_check() then return
	CASE "Clear Key"
		if f_popup_yes_no("Are you sure you want to clear the " + menu_key_domain + " for this menu selection rule?") then
			UPDATE o_Menu_Selection
			SET menu_key = NULL
			WHERE room_menu_selection_id = :ll_room_menu_selection_id;
			if not tf_check() then return
		end if
	CASE "Change Key"
		ls_new_menu_key = pick_menu_key(ls_menu_key)
		if len(ls_new_menu_key) > 0 then
			UPDATE o_Menu_Selection
			SET menu_key = :ls_new_menu_key
			WHERE room_menu_selection_id = :ll_room_menu_selection_id;
			if not tf_check() then return
		end if
	CASE "Edit Menu"
		SELECT CAST(id AS varchar(38))
		INTO :popup.items[1]
		FROM c_menu
		WHERE menu_id = :ll_menu_id;
		if not tf_check() then return
		
		popup.items[2] = f_boolean_to_string(true)
		popup.data_row_count = 2
		openwithparm(lw_window, popup, "w_menu_display")
	CASE "Change Menu"
		openwithparm(lw_window, menu_context.context_object, "w_pick_menu")
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		
		ll_new_menu_id = long(popup_return.items[1])
		
		UPDATE o_Menu_Selection
		SET menu_id = :ll_new_menu_id
		WHERE menu_id = :ll_menu_id;
		if not tf_check() then return
END CHOOSE

refresh()

return


end event

type st_menu_key_title from statictext within w_menu_selection
integer y = 260
integer width = 809
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Menu Key"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_menu_key_description from statictext within w_menu_selection
integer x = 832
integer y = 256
integer width = 1856
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "<Any>"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

