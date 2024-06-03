$PBExportHeader$w_display_script_config.srw
forward
global type w_display_script_config from w_window_base
end type
type tv_display_script from u_tv_display_script within w_display_script_config
end type
type cb_finished from commandbutton within w_display_script_config
end type
type cb_edit from commandbutton within w_display_script_config
end type
type cb_revert from commandbutton within w_display_script_config
end type
type st_title from statictext within w_display_script_config
end type
type cb_cancel from commandbutton within w_display_script_config
end type
type cb_run from commandbutton within w_display_script_config
end type
type cb_debug from commandbutton within w_display_script_config
end type
type st_edit_status from statictext within w_display_script_config
end type
type cb_stop_debugging from commandbutton within w_display_script_config
end type
type cb_next from commandbutton within w_display_script_config
end type
type str_display_script_reference from structure within w_display_script_config
end type
end forward

global type w_display_script_config from w_window_base
integer width = 3063
integer height = 2036
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean auto_resize_objects = false
tv_display_script tv_display_script
cb_finished cb_finished
cb_edit cb_edit
cb_revert cb_revert
st_title st_title
cb_cancel cb_cancel
cb_run cb_run
cb_debug cb_debug
st_edit_status st_edit_status
cb_stop_debugging cb_stop_debugging
cb_next cb_next
end type
global w_display_script_config w_display_script_config

type variables
string id
boolean caller_allow_editing
boolean allow_editing


str_config_object_info parent_config_object

long root_display_script_id
long root_display_script_owner_id
string root_display_script_guid
string root_display_script_type

str_c_display_script_command_stack command_stack

u_rich_text_edit rtf_display
boolean debugging
long last_command_index


end variables

forward prototypes
public function integer refresh ()
end prototypes

public function integer refresh ();integer li_sts
long ll_rows
long ll_active
long i
string ls_status
long ll_display_script_id
long ll_root_handle
boolean lb_local_found
long ll_owner_id
string ls_edit_status
long ll_count

cb_revert.visible = false

SELECT id, owner_id, script_type + ' Script', display_script
INTO :root_display_script_guid,
		:root_display_script_owner_id,
		:root_display_script_type,
		:st_title.text
FROM c_Display_Script
WHERE display_script_id = :root_display_script_id;
if not tf_check() then return -1

if isnull(parent_config_object.config_object_id) then
	if root_display_script_owner_id = sqlca.customer_id then
		ls_edit_status = "This " + lower(root_display_script_type) + " is editable."
		allow_editing = true
		cb_edit.visible = false
		
		SELECT count(*)
		INTO :ll_count
		FROM c_Display_Script
		WHERE id = :root_display_script_guid
		AND owner_id = 0
		AND display_script_id <> :root_display_script_id;
		if not tf_check() then
			cb_revert.visible = false
		else
			if ll_count > 0 then
				cb_revert.visible = true
				ls_edit_status += "  Click ~"Revert~" to revert back to the original JMJ version."
			else
				cb_revert.visible = false
			end if
		end if
	else
		ls_edit_status = "This " + lower(root_display_script_type) + " is not owned by your organization.  Click ~"Edit~" to create a local copy and edit."
		allow_editing = false
		cb_edit.visible = true
	end if
else
	// Get a fresh copy of the config object
	li_sts = f_get_config_object_info(parent_config_object.config_object_id, parent_config_object)
	if li_sts <= 0 then return -1
	
	if lower(parent_config_object.installed_version_status) = "checkedout" then
		if lower(parent_config_object.checked_out_by) = lower(current_user.user_id) then
			ls_edit_status = "This " + lower(parent_config_object.config_object_type) + " is checked out by you and is editable."
			allow_editing = true
			cb_edit.visible = false
		else
			ls_edit_status = "This " + lower(parent_config_object.config_object_type) + " is checked out by " + user_list.user_full_name(parent_config_object.checked_out_by) + ".  "
			ls_edit_status += "Click ~"Edit~" to take over and edit."
			allow_editing = false
			cb_edit.visible = true
		end if
	else
		if parent_config_object.owner_id = sqlca.customer_id then
			ls_edit_status = "This " + lower(parent_config_object.config_object_type) + " is not checked out.  Click ~"Edit~" to check out and edit."
			allow_editing = false
			cb_edit.visible = true
		else
			ls_edit_status = "This " + lower(parent_config_object.config_object_type) + " is not owned by your organization and is not editable.  Create a copy and edit the copy."
			allow_editing = false
			cb_edit.visible = false
		end if
	end if
end if

st_edit_status.text = ls_edit_status

if tv_display_script.changes_made then
	cb_run.text = "Save and Run"
	cb_debug.text = "Save and Debug"
else
	cb_run.text = "Run"
	cb_debug.text = "Debug"
end if

if isvalid(rtf_display) and not isnull(rtf_display) then
	cb_run.visible = allow_editing
	cb_debug.visible = allow_editing
else
	cb_run.visible = false
	cb_debug.visible = false
end if

debugging = false
cb_stop_debugging.visible = false
cb_next.visible = false
If IsValid(rtf_display) Then
	rtf_display.clear_breakpoint()
End If

tv_display_script.display_display_script(root_display_script_id, parent_config_object, command_stack, allow_editing)

return 1

end function

on w_display_script_config.create
int iCurrent
call super::create
this.tv_display_script=create tv_display_script
this.cb_finished=create cb_finished
this.cb_edit=create cb_edit
this.cb_revert=create cb_revert
this.st_title=create st_title
this.cb_cancel=create cb_cancel
this.cb_run=create cb_run
this.cb_debug=create cb_debug
this.st_edit_status=create st_edit_status
this.cb_stop_debugging=create cb_stop_debugging
this.cb_next=create cb_next
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tv_display_script
this.Control[iCurrent+2]=this.cb_finished
this.Control[iCurrent+3]=this.cb_edit
this.Control[iCurrent+4]=this.cb_revert
this.Control[iCurrent+5]=this.st_title
this.Control[iCurrent+6]=this.cb_cancel
this.Control[iCurrent+7]=this.cb_run
this.Control[iCurrent+8]=this.cb_debug
this.Control[iCurrent+9]=this.st_edit_status
this.Control[iCurrent+10]=this.cb_stop_debugging
this.Control[iCurrent+11]=this.cb_next
end on

on w_display_script_config.destroy
call super::destroy
destroy(this.tv_display_script)
destroy(this.cb_finished)
destroy(this.cb_edit)
destroy(this.cb_revert)
destroy(this.st_title)
destroy(this.cb_cancel)
destroy(this.cb_run)
destroy(this.cb_debug)
destroy(this.st_edit_status)
destroy(this.cb_stop_debugging)
destroy(this.cb_next)
end on

event open;call super::open;str_popup popup
integer li_sts
string ls_edit_status
string ls_parent_config_object_id

popup = message.powerobjectparm

if popup.data_row_count < 3 then
	log.log(this, "w_display_script_config:open", "Invalid Parameters", 4)
	close(this)
	return
end if

root_display_script_id = long(popup.items[1])
caller_allow_editing = f_string_to_boolean(popup.items[2])
ls_parent_config_object_id = popup.items[3]

if isvalid(popup.objectparm) and not isnull(popup.objectparm) then
	command_stack = popup.objectparm
end if

if isvalid(popup.objectparm1) and not isnull(popup.objectparm1) then
	rtf_display = popup.objectparm1
end if

// If there's no parent then they can't edit
if isnull(ls_parent_config_object_id) then
	setnull(parent_config_object.config_object_id)
else
	li_sts = f_get_config_object_info(ls_parent_config_object_id, parent_config_object)
	if li_sts <= 0 then
		log.log(this, "w_display_script_config:open", "Error getting config object info (" + ls_parent_config_object_id + ")" , 4)
		close(this)
		return
	end if
end if


tv_display_script.width = width - 41
tv_display_script.height = height - 416

st_title.width = width

cb_finished.x = tv_display_script.x + tv_display_script.width - cb_finished.width
cb_finished.y = height - cb_finished.height - 112

cb_cancel.y = height - cb_cancel.height - 112

cb_edit.x = tv_display_script.x + tv_display_script.width - cb_edit.width
cb_revert.x = cb_edit.x

cb_run.x = (width / 2) - cb_run.width - 50
cb_run.y = cb_finished.y

cb_debug.x = (width / 2) + 50
cb_debug.y = cb_finished.y

cb_next.x = cb_run.x
cb_next.y = cb_run.y

cb_stop_debugging.x = cb_debug.x
cb_stop_debugging.y = cb_debug.y

st_edit_status.y = tv_display_script.y + tv_display_script.height + 12

li_sts = refresh()
if li_sts <= 0 then close(this)


end event

type pb_epro_help from w_window_base`pb_epro_help within w_display_script_config
integer x = 2994
integer y = 8
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_display_script_config
integer x = 32
integer y = 1832
end type

type tv_display_script from u_tv_display_script within w_display_script_config
integer x = 14
integer y = 136
integer width = 3013
integer height = 1640
integer taborder = 20
long backcolor = 12632256
end type

event changes_made;call super::changes_made;cb_cancel.visible = true
cb_run.text = "Save and Run"
cb_debug.text = "Save and Debug"

end event

event command_selected;call super::command_selected;long ll_command_index

ll_command_index = rtf_display.select_next_command(0, pstr_command)

// If the desired command hasn't been painted yet and we're in debug mode, then automatically run to that command
if debugging and ll_command_index = 0 and upper(pstr_command.status) = "OK" then
	last_command_index = ll_command_index
	rtf_display.set_breakpoint(pstr_command)
	rtf_display.display_script_reentry()
end if

end event

type cb_finished from commandbutton within w_display_script_config
integer x = 2409
integer y = 1828
integer width = 613
integer height = 112
integer taborder = 20
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

if allow_editing and tv_display_script.changes_made then
	li_sts = tv_display_script.save_changes()
	if li_sts <= 0 then
		openwithparm(w_pop_message, "An error occured.  Changes have not been saved.")
		return
	end if
end if

close(parent)

end event

type cb_edit from commandbutton within w_display_script_config
integer x = 2661
integer y = 24
integer width = 361
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Edit"
end type

event clicked;str_popup_return popup_return
string ls_message
integer li_sts
long ll_display_script_id
str_popup popup
long ll_choice
long ll_new_display_script_id
string ls_null

setnull(ls_null)

if not isnull(parent_config_object.config_object_id) and lower(parent_config_object.config_object_type) <> "rtf script" and  parent_config_object.owner_id <> sqlca.customer_id then
	openwithparm(w_pop_message, "You may not edit this " + lower(parent_config_object.config_object_type))
	this.visible = false
	return
end if


if isnull(parent_config_object.config_object_id) then
	// Independent rtf script
	if root_display_script_owner_id = sqlca.customer_id then
		// Already a local copy
		allow_editing = true 
		this.visible = false
		return
	else
		openwithparm(w_pop_yes_no, "Are you sure you want to create a local copy of this " + lower(root_display_script_type) + "?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return
		
		SELECT max(display_script_id)
		INTO :ll_display_script_id
		FROM c_Display_Script
		WHERE id = :root_display_script_guid
		AND owner_id = :sqlca.customer_id;
		if not tf_check() then return
		
		if isnull(ll_display_script_id) then
			ll_new_display_script_id = sqlca.sp_local_copy_display_script(root_display_script_id, root_display_script_guid, ls_null, ls_null)
			if not tf_check() then
				ls_message = "An error has occured creating a local copy of this " + lower(root_display_script_type)
				ls_message += ".  You are not able to edit it at this time."
				openwithparm(w_pop_message, ls_message)
				return
			end if
			
			root_display_script_id = ll_new_display_script_id
		else
			popup.title = "A local copy of this " + lower(root_display_script_type) + " already exists.  Do you wish to:"
			popup.data_row_count = 3
			popup.items[1] = "Create a fresh copy of the JMJ script"
			popup.items[2] = "Activate the existing local copy"
			popup.items[3] = "Cancel"
			openwithparm(w_pop_choices_3, popup)
			ll_choice = message.doubleparm
			if ll_choice = 1 then
				sqlca.begin_transaction( this, "Activate Local Copy Display Script")
				
				// Don't delete the existing local copies, just assign them new guids
				UPDATE c_Display_Script
				SET id = newid()
				WHERE id = :root_display_script_guid
				AND owner_id = :sqlca.customer_id;
				if not tf_check() then return
								
				ll_new_display_script_id = sqlca.sp_local_copy_display_script(root_display_script_id, root_display_script_guid, ls_null, ls_null)
				if not tf_check() then
					ls_message = "An error has occured creating a local copy of this " + lower(root_display_script_type)
					ls_message += ".  You are not able to edit it at this time."
					openwithparm(w_pop_message, ls_message)
					return
				end if

				sqlca.commit_transaction( )

				root_display_script_id = ll_new_display_script_id
			elseif ll_choice = 2 then
				sqlca.begin_transaction( this, "Activate Local Copy Display Script")
				
				UPDATE c_Display_Script
				SET status = 'NA'
				WHERE id = :root_display_script_guid
				AND display_script_id <> :ll_display_script_id;
				if not tf_check() then return
				
				UPDATE c_Display_Script
				SET status = 'OK'
				WHERE id = :root_display_script_guid
				AND display_script_id = :ll_display_script_id;
				if not tf_check() then return
				
				sqlca.commit_transaction( )
				
				root_display_script_id = ll_display_script_id
			else
				return
			end if
		end if
	end if
else
	// Versionable parent config object
	if lower(parent_config_object.installed_version_status) = "checkedout" and lower(parent_config_object.checked_out_by) = lower(current_user.user_id) then
		// Already checked out by the current user
		allow_editing = true 
		this.visible = false
	else
		openwithparm(w_pop_yes_no, "Are you sure you want to check out and edit this " + lower(parent_config_object.config_object_type) + "?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return
		li_sts = f_check_out_config_object(parent_config_object)
		if li_sts <= 0 then
			ls_message = "An error has occured checking out this " + lower(parent_config_object.config_object_type)
			ls_message += ".  You are not able to edit it at this time."
			openwithparm(w_pop_message, ls_message)
			return
		end if
		
		allow_editing = true 
		this.visible = false
	end if
end if

refresh()

end event

type cb_revert from commandbutton within w_display_script_config
boolean visible = false
integer x = 2661
integer y = 24
integer width = 361
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Revert"
end type

event clicked;str_popup_return popup_return
string ls_message
integer li_sts
long ll_display_script_id

// This button can only be used when the display script is not part of a parent config object

if not isnull(parent_config_object.config_object_id) then return

openwithparm(w_pop_yes_no, "Are you sure you want to revert this " + lower(root_display_script_type) + " back to the original JMJ version?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

SELECT max(display_script_id)
INTO :ll_display_script_id
FROM c_Display_Script
WHERE id = :root_display_script_guid
AND owner_id = 0;
if not tf_check() then return

if isnull(ll_display_script_id) then
	openwithparm(w_pop_message, "Original JMJ Version Not Found")
	return
end if

sqlca.begin_transaction( this, "Revert display script")

UPDATE c_Display_Script
SET status = 'NA'
WHERE id = :root_display_script_guid
AND display_script_id <> :ll_display_script_id;
if not tf_check() then return

UPDATE c_Display_Script
SET status = 'OK'
WHERE id = :root_display_script_guid
AND display_script_id = :ll_display_script_id;
if not tf_check() then return

sqlca.commit_transaction( )

refresh()

end event

type st_title from statictext within w_display_script_config
integer width = 3058
integer height = 112
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_display_script_config
boolean visible = false
integer x = 18
integer y = 1852
integer width = 402
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;str_popup_return popup_return

openwithparm(w_pop_yes_no, "Are you sure you want to exit WITHOUT saving your changes?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

close(parent)

end event

type cb_run from commandbutton within w_display_script_config
integer x = 805
integer y = 1828
integer width = 613
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Save and Run"
end type

event clicked;integer li_sts

if allow_editing and tv_display_script.changes_made then
	li_sts = tv_display_script.save_changes()
	if li_sts <= 0 then
		openwithparm(w_pop_message, "An error occured.  Changes have not been saved.")
		return
	end if
end if

cb_run.text = "Run"
cb_debug.text = "Debug"

rtf_display.redisplay()


end event

type cb_debug from commandbutton within w_display_script_config
integer x = 1477
integer y = 1828
integer width = 613
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Save and Debug"
end type

event clicked;integer li_sts
str_c_display_script_command lstr_command

if allow_editing and tv_display_script.changes_made then
	li_sts = tv_display_script.save_changes()
	if li_sts <= 0 then
		openwithparm(w_pop_message, "An error occured.  Changes have not been saved.")
		return
	end if
end if

cb_run.text = "Run"
cb_debug.text = "Debug"

li_sts = tv_display_script.selected_command(lstr_command)
if li_sts <= 0 then
	li_sts = tv_display_script.first_command(lstr_command)
	if li_sts <= 0 then
		openwithparm(w_pop_message, "No commands found")
	end if
end if

rtf_display.set_breakpoint(lstr_command)
cb_debug.visible = false
cb_run.visible = false
cb_stop_debugging.visible = true
cb_next.visible = true
debugging = true
last_command_index = 0

rtf_display.redisplay()

// If the rtf control did actually break, then highlight the command that it broke on
if rtf_display.breakpoint(lstr_command) then
	tv_display_script.select_command(lstr_command)
end if



end event

type st_edit_status from statictext within w_display_script_config
integer x = 14
integer y = 1788
integer width = 2528
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33536444
boolean focusrectangle = false
end type

type cb_stop_debugging from commandbutton within w_display_script_config
integer x = 1477
integer y = 1828
integer width = 613
integer height = 112
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Stop Debugging"
end type

event clicked;integer li_sts

if allow_editing and tv_display_script.changes_made then
	li_sts = tv_display_script.save_changes()
	if li_sts <= 0 then
		openwithparm(w_pop_message, "An error occured.  Changes have not been saved.")
		return
	end if
end if


rtf_display.clear_breakpoint()
cb_debug.visible = true
cb_run.visible = true
cb_stop_debugging.visible = false
cb_next.visible = false
debugging = false
last_command_index = 0

rtf_display.redisplay()



end event

type cb_next from commandbutton within w_display_script_config
integer x = 805
integer y = 1828
integer width = 613
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Next"
end type

event clicked;tv_display_script.select_next()

end event

