$PBExportHeader$w_display_script_edit.srw
forward
global type w_display_script_edit from w_window_base
end type
type st_context_object_title from statictext within w_display_script_edit
end type
type cb_ok from commandbutton within w_display_script_edit
end type
type cb_cancel from commandbutton within w_display_script_edit
end type
type dw_display_commands from u_dw_pick_list within w_display_script_edit
end type
type pb_down from u_picture_button within w_display_script_edit
end type
type pb_up from u_picture_button within w_display_script_edit
end type
type st_page from statictext within w_display_script_edit
end type
type st_commands_title from statictext within w_display_script_edit
end type
type st_context_object from statictext within w_display_script_edit
end type
type st_3 from statictext within w_display_script_edit
end type
type st_display_script from statictext within w_display_script_edit
end type
type dw_command_attributes from u_dw_pick_list within w_display_script_edit
end type
type st_command_attributes_title from statictext within w_display_script_edit
end type
type cb_insert_command from commandbutton within w_display_script_edit
end type
type cb_delete from commandbutton within w_display_script_edit
end type
type cb_move from commandbutton within w_display_script_edit
end type
type cb_append_command from commandbutton within w_display_script_edit
end type
type cb_status from commandbutton within w_display_script_edit
end type
end forward

global type w_display_script_edit from w_window_base
string title = "EncounterPRO Display Script Create/Edit"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_context_object_title st_context_object_title
cb_ok cb_ok
cb_cancel cb_cancel
dw_display_commands dw_display_commands
pb_down pb_down
pb_up pb_up
st_page st_page
st_commands_title st_commands_title
st_context_object st_context_object
st_3 st_3
st_display_script st_display_script
dw_command_attributes dw_command_attributes
st_command_attributes_title st_command_attributes_title
cb_insert_command cb_insert_command
cb_delete cb_delete
cb_move cb_move
cb_append_command cb_append_command
cb_status cb_status
end type
global w_display_script_edit w_display_script_edit

type variables
long display_script_id

boolean updated = false

string script_type
string parent_config_object_id

end variables

forward prototypes
public function integer show_commands ()
public function integer new_command (long pl_row)
public function integer configure_command (long pl_row)
public function integer show_attributes (long pl_row)
end prototypes

public function integer show_commands ();long ll_count
long ll_display_command_id
long ll_row

ll_row = dw_display_commands.get_selected_row()

dw_display_commands.settransobject(sqlca)

ll_count = dw_display_commands.retrieve(display_script_id)
if ll_count <= 0 then return ll_count

if ll_count = 0 then
	dw_command_attributes.visible = false
	st_command_attributes_title.visible = false
	dw_display_commands.set_page(1, pb_up, pb_down, st_page)
	return 0
end if

if ll_row <= 0 then ll_row = 1
if ll_row > ll_count then ll_row = ll_count

dw_display_commands.set_page_to_row(ll_row, pb_up, pb_down, st_page)
dw_display_commands.object.selected_flag[ll_row] = 1
dw_display_commands.event post selected(ll_row)

return 1



end function

public function integer new_command (long pl_row);str_script_command_context lstr_context
str_popup popup
str_popup_return popup_return
str_c_display_command_definition lstr_command
long ll_row
long ll_rowcount
long i
integer li_sts
long ll_display_command_id
string ls_command_id
str_attributes lstr_attributes
u_ds_data luo_data

if updated then
	openwithparm(w_pop_yes_no, "Inserting a new command requires that previous modifications to this display script be saved immediatley.  Do you wish to continue?")
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return 0
end if

updated = false

li_sts = dw_display_commands.update()
if li_sts <= 0 then
	openwithparm(w_pop_message, "Command update failed")
	return -1
end if

lstr_context.context_object = st_context_object.text
lstr_context.script_type = script_type
openwithparm(w_display_command_pick, lstr_context)
lstr_command = message.powerobjectparm
if isnull(lstr_command.display_command) then return 0

ll_row = dw_display_commands.insertrow(pl_row)
if ll_row <= 0 then return -1

dw_display_commands.object.display_script_id[ll_row] = display_script_id
dw_display_commands.object.context_object[ll_row] = lstr_command.context_object
dw_display_commands.object.display_command[ll_row] = lstr_command.display_command
dw_display_commands.object.sort_sequence[ll_row] = ll_row
dw_display_commands.object.status[ll_row] = "OK"

ll_rowcount = dw_display_commands.rowcount()
for i = 1 to ll_rowcount
	dw_display_commands.object.sort_sequence[i] = i
next

li_sts = dw_display_commands.update()
if li_sts <= 0 then
	openwithparm(w_pop_message, "Command update failed")
	return -1
end if

ll_display_command_id = dw_display_commands.object.display_command_id[ll_row]
if isnull(ll_display_command_id) or ll_display_command_id <= 0 then
	log.log(this, "w_display_script_edit.new_command:0056", "Invalid command id", 4)
	return -1
end if

// Configure the new row
show_attributes(ll_row)
li_sts = configure_command(ll_row)
if li_sts < 0 then
	log.log(this, "w_display_script_edit.new_command:0064", "Configure_command failed", 4)
	return -1
end if

// Now scroll to the new row and select it
dw_display_commands.clear_selected()
dw_display_commands.object.selected_flag[ll_row] = 1
dw_display_commands.recalc_page(pb_up, pb_down, st_page)
dw_display_commands.scroll_to_row(ll_row)
dw_display_commands.event post selected(ll_row)

return 1

end function

public function integer configure_command (long pl_row);integer li_sts
long ll_display_command_id
string ls_command_id
str_attributes lstr_attributes
u_ds_data luo_data
string ls_context_object
string ls_display_command
string lsa_words[]
integer li_count
long i
str_attributes lstr_state_attributes

ll_display_command_id = dw_display_commands.object.display_command_id[pl_row]
if isnull(ll_display_command_id) or ll_display_command_id <= 0 then
	log.log(this, "w_display_script_edit.configure_command:0015", "Invalid command id", 4)
	return -1
end if

ls_context_object = dw_display_commands.object.context_object[pl_row]
if isnull(ls_context_object) then
	log.log(this, "w_display_script_edit.configure_command:0021", "null context object", 4)
	return -1
end if

ls_display_command = dw_display_commands.object.display_command[pl_row]
if isnull(ls_display_command) then
	log.log(this, "w_display_script_edit.configure_command:0027", "Null display_command", 4)
	return -1
end if

SELECT CAST(id as varchar(36))
INTO :ls_command_id
FROM c_display_command_definition
WHERE context_object = :ls_context_object
AND display_command = :ls_display_command
AND script_type = :script_type;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then
	log.log(this, "w_display_script_edit.configure_command:0039", "command not found (" + ls_context_object + ", " + ls_display_command + ")", 4)
	return -1
end if


lstr_attributes.attribute_count = 0

// See if the command matches a context object
li_count = f_parse_string(lower(ls_display_command), " ", lsa_words)
if li_count > 0 then
	if left(lsa_words[li_count], 7) = "patient" then
		f_attribute_add_attribute(lstr_attributes, "context_object", "Patient")
	elseif left(lsa_words[li_count], 9) = "encounter" then
		f_attribute_add_attribute(lstr_attributes, "context_object", "Encounter")
	elseif left(lsa_words[li_count], 10) = "assessment" then
		f_attribute_add_attribute(lstr_attributes, "context_object", "Assessment")
	elseif left(lsa_words[li_count], 9) = "treatment" then
		f_attribute_add_attribute(lstr_attributes, "context_object", "Treatment")
	elseif left(lsa_words[li_count], 11) = "observation" then
		f_attribute_add_attribute(lstr_attributes, "context_object", "Observation")
	elseif left(lsa_words[li_count], 10) = "attachment" then
		f_attribute_add_attribute(lstr_attributes, "context_object", "Attachment")
	else
		// If the command wasn't a context object, then pass in the commands' context object
		f_attribute_add_attribute(lstr_attributes, "context_object", ls_context_object)
	end if
end if

f_attribute_dw_to_str(dw_command_attributes, lstr_attributes)

// Add the config object to the state attributes
f_attribute_add_attribute(lstr_state_attributes, "context_object", ls_context_object)
f_attribute_add_attribute(lstr_state_attributes, "parent_config_object_id", parent_config_object_id)

li_sts = f_get_params_with_state(ls_command_id, "Config", lstr_attributes, lstr_state_attributes)
if li_sts < 0 then
	return 0
end if

// Get the existing attributes
luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_c_display_script_cmd_attribute_edit")
li_sts = luo_data.retrieve(display_script_id, ll_display_command_id)

// Add/replace the new attributes, removing any attributes no longer referenced
f_attribute_str_to_ds_with_removal(lstr_attributes, luo_data)

// For any new records, add the key values
for i = 1 to luo_data.rowcount()
	if isnull(long(luo_data.object.display_script_id[i])) then
		luo_data.object.display_script_id[i] = display_script_id
		luo_data.object.display_command_id[i] = ll_display_command_id
	end if
next

// Update the attributes
li_sts = luo_data.update()
DESTROY luo_data
if li_sts < 0 then
	log.log(this, "w_display_script_edit.configure_command:0098", "Error updating command attributes", 4)
	return -1
end if

return 1

end function

public function integer show_attributes (long pl_row);long ll_display_command_id
string ls_status
integer li_sts

ll_display_command_id = dw_display_commands.object.display_command_id[pl_row]

dw_command_attributes.settransobject(sqlca)
li_sts = dw_command_attributes.retrieve(display_script_id, ll_display_command_id)
	
return li_sts


end function

on w_display_script_edit.create
int iCurrent
call super::create
this.st_context_object_title=create st_context_object_title
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.dw_display_commands=create dw_display_commands
this.pb_down=create pb_down
this.pb_up=create pb_up
this.st_page=create st_page
this.st_commands_title=create st_commands_title
this.st_context_object=create st_context_object
this.st_3=create st_3
this.st_display_script=create st_display_script
this.dw_command_attributes=create dw_command_attributes
this.st_command_attributes_title=create st_command_attributes_title
this.cb_insert_command=create cb_insert_command
this.cb_delete=create cb_delete
this.cb_move=create cb_move
this.cb_append_command=create cb_append_command
this.cb_status=create cb_status
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_context_object_title
this.Control[iCurrent+2]=this.cb_ok
this.Control[iCurrent+3]=this.cb_cancel
this.Control[iCurrent+4]=this.dw_display_commands
this.Control[iCurrent+5]=this.pb_down
this.Control[iCurrent+6]=this.pb_up
this.Control[iCurrent+7]=this.st_page
this.Control[iCurrent+8]=this.st_commands_title
this.Control[iCurrent+9]=this.st_context_object
this.Control[iCurrent+10]=this.st_3
this.Control[iCurrent+11]=this.st_display_script
this.Control[iCurrent+12]=this.dw_command_attributes
this.Control[iCurrent+13]=this.st_command_attributes_title
this.Control[iCurrent+14]=this.cb_insert_command
this.Control[iCurrent+15]=this.cb_delete
this.Control[iCurrent+16]=this.cb_move
this.Control[iCurrent+17]=this.cb_append_command
this.Control[iCurrent+18]=this.cb_status
end on

on w_display_script_edit.destroy
call super::destroy
destroy(this.st_context_object_title)
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.dw_display_commands)
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.st_page)
destroy(this.st_commands_title)
destroy(this.st_context_object)
destroy(this.st_3)
destroy(this.st_display_script)
destroy(this.dw_command_attributes)
destroy(this.st_command_attributes_title)
destroy(this.cb_insert_command)
destroy(this.cb_delete)
destroy(this.cb_move)
destroy(this.cb_append_command)
destroy(this.cb_status)
end on

event open;call super::open;integer li_sts

display_script_id = message.doubleparm

if isnull(display_script_id) then
	log.log(this, "w_display_script_edit:open", "null display script", 4)
	close(this)
	return
end if


SELECT context_object,
		description,
		script_type,
		CAST(parent_config_object_id AS varchar(38))
INTO :st_context_object.text,
	:st_display_script.text,
	:script_type,
	:parent_config_object_id
FROM c_Display_Script
WHERE display_script_id = :display_script_id;
if not tf_check() then
	log.log(this, "w_display_script_edit:open", "error getting display script (" + string(display_script_id) + ")", 4)
	close(this)
	return
end if
if sqlca.sqlcode = 100 then
	log.log(this, "w_display_script_edit:open", "display script not found (" + string(display_script_id) + ")", 4)
	close(this)
	return
end if


li_sts = show_commands()
if li_sts < 0 then
	log.log(this, "w_display_script_edit:open", "error showing display script commands (" + string(display_script_id) + ")", 4)
	close(this)
	return
end if




end event

type pb_epro_help from w_window_base`pb_epro_help within w_display_script_edit
boolean visible = true
integer x = 2615
integer y = 1464
boolean originalsize = false
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_display_script_edit
end type

type st_context_object_title from statictext within w_display_script_edit
integer x = 5
integer y = 20
integer width = 462
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Context Object:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_ok from commandbutton within w_display_script_edit
integer x = 2441
integer y = 1580
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
string text = "OK"
boolean default = true
end type

event clicked;integer li_sts


li_sts = dw_display_commands.update()
if li_sts <= 0 then
	openwithparm(w_pop_message, "Command update failed")
	return
end if

datalist.clear_cache("display_scripts")

close(parent)

end event

type cb_cancel from commandbutton within w_display_script_edit
integer x = 2011
integer y = 1580
integer width = 402
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;str_popup_return popup_return

if updated then
	openwithparm(w_pop_yes_no, "Are you sure you wish to exit without saving your changes?")
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return
end if

datalist.clear_cache("display_scripts")

close(parent)

return


end event

type dw_display_commands from u_dw_pick_list within w_display_script_edit
integer x = 55
integer y = 196
integer width = 1385
integer height = 1528
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_display_script_commands"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;string ls_status
integer li_sts

li_sts = show_attributes(selected_row)

dw_command_attributes.visible = true
st_command_attributes_title.visible = true

cb_cancel.enabled = true
cb_delete.enabled = true
cb_insert_command.enabled = true

ls_status = dw_display_commands.object.status[selected_row]
if upper(ls_status) = "OK" then
	cb_status.text = "Disable Command"
else
	cb_status.text = "Enable Command"
end if

end event

event unselected;call super::unselected;dw_command_attributes.visible = false
st_command_attributes_title.visible = false

cb_cancel.enabled = false
cb_delete.enabled = false
cb_insert_command.enabled = false

end event

type pb_down from u_picture_button within w_display_script_edit
integer x = 1454
integer y = 328
integer width = 137
integer height = 116
integer taborder = 30
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_display_commands.current_page
li_last_page = dw_display_commands.last_page

dw_display_commands.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true


end event

type pb_up from u_picture_button within w_display_script_edit
integer x = 1454
integer y = 204
integer width = 137
integer height = 116
integer taborder = 20
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_display_commands.current_page

dw_display_commands.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type st_page from statictext within w_display_script_edit
integer x = 1458
integer y = 460
integer width = 146
integer height = 124
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Page 99/99"
boolean focusrectangle = false
end type

type st_commands_title from statictext within w_display_script_edit
integer x = 55
integer y = 132
integer width = 1312
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Commands"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_context_object from statictext within w_display_script_edit
integer x = 480
integer y = 12
integer width = 443
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
string text = "Observation"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_3 from statictext within w_display_script_edit
integer x = 960
integer y = 20
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Script Name:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_display_script from statictext within w_display_script_edit
integer x = 1381
integer y = 12
integer width = 1463
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
string text = "Default Encounter Display"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type dw_command_attributes from u_dw_pick_list within w_display_script_edit
integer x = 1705
integer y = 192
integer width = 1029
integer height = 592
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_display_script_cmd_att_small"
borderstyle borderstyle = styleraised!
end type

event clicked;call super::clicked;integer li_sts
long ll_row

ll_row = dw_display_commands.get_selected_row()

if ll_row > 0 then
	li_sts = configure_command(ll_row)
	if li_sts < 0 then
		log.log(this, "w_display_script_edit.dw_command_attributes.clicked:0009", "Configure_command failed", 4)
		return -1
	end if
	dw_display_commands.event post selected(ll_row)
end if



end event

type st_command_attributes_title from statictext within w_display_script_edit
integer x = 1705
integer y = 128
integer width = 1029
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Command Attributes"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_insert_command from commandbutton within w_display_script_edit
integer x = 1509
integer y = 1248
integer width = 782
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Insert New Command"
end type

event clicked;long ll_row

ll_row = dw_display_commands.get_selected_row()
if ll_row < 0 then ll_row = 0

new_command(ll_row)


end event

type cb_delete from commandbutton within w_display_script_edit
integer x = 2254
integer y = 996
integer width = 590
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Delete Command"
end type

event clicked;str_popup_return popup_return
long ll_row
long ll_rowcount

ll_row = dw_display_commands.get_selected_row()
if ll_row <= 0 then return

openwithparm(w_pop_yes_no, "Are you sure you wish to delete this display command?")
popup_return = message.powerobjectparm
if popup_return.item = "YES" then
	dw_display_commands.deleterow(ll_row)
	dw_display_commands.recalc_page(pb_up, pb_down, st_page)
	
	ll_rowcount = dw_display_commands.rowcount()
	if ll_rowcount >= ll_row then
		dw_display_commands.object.selected_flag[ll_row] = 1
		dw_display_commands.event post selected(ll_row)
	elseif ll_rowcount > 0 then
		dw_display_commands.object.selected_flag[ll_rowcount] = 1
		dw_display_commands.event post selected(ll_rowcount)
	else
		dw_command_attributes.visible = false
		st_command_attributes_title.visible = false
		
		cb_cancel.enabled = false
		cb_delete.enabled = false
		cb_insert_command.enabled = false
	end if
	
	updated = true
end if


end event

type cb_move from commandbutton within w_display_script_edit
integer x = 1509
integer y = 848
integer width = 590
integer height = 112
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Move Up/Down"
end type

event clicked;str_popup popup
long ll_row
integer li_sts
long ll_rowcount
long i

ll_row = dw_display_commands.get_selected_row()
if ll_row <= 0 then return 0

ll_rowcount = dw_display_commands.rowcount()
for i = 1 to ll_rowcount
	dw_display_commands.object.sort_sequence[ll_row] = i
next

popup.objectparm = dw_display_commands

openwithparm(w_pick_list_sort, popup)

li_sts = dw_display_commands.update()
if li_sts <= 0 then
	openwithparm(w_pop_message, "Command update failed")
	return
end if

updated = true

return


end event

type cb_append_command from commandbutton within w_display_script_edit
integer x = 1509
integer y = 1412
integer width = 782
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Append New Command"
end type

event clicked;new_command(0)

end event

type cb_status from commandbutton within w_display_script_edit
integer x = 2254
integer y = 848
integer width = 590
integer height = 112
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Disable Command"
end type

event clicked;long ll_row
string ls_status
integer li_sts

ll_row = dw_display_commands.get_selected_row()
if ll_row <= 0 then return

ls_status = dw_display_commands.object.status[ll_row]
if upper(ls_status) = "OK" then
	dw_display_commands.object.status[ll_row] = "NA"
	text = "Enable Command"
else
	dw_display_commands.object.status[ll_row] = "OK"
	text = "Disable Command"
end if

updated = true

end event

