$PBExportHeader$w_server_setup.srw
forward
global type w_server_setup from w_window_base
end type
type dw_integrations from u_dw_pick_list within w_server_setup
end type
type cb_integration from commandbutton within w_server_setup
end type
type cb_mapping from commandbutton within w_server_setup
end type
type st_1 from statictext within w_server_setup
end type
type st_3 from statictext within w_server_setup
end type
type pb_1 from u_picture_button within w_server_setup
end type
type st_pm from statictext within w_server_setup
end type
type cb_new from commandbutton within w_server_setup
end type
end forward

global type w_server_setup from w_window_base
string title = "Practice Management Configuration"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
dw_integrations dw_integrations
cb_integration cb_integration
cb_mapping cb_mapping
st_1 st_1
st_3 st_3
pb_1 pb_1
st_pm st_pm
cb_new cb_new
end type
global w_server_setup w_server_setup

type variables
string integration_component
string default_billing_system
boolean updatemode
string scheduler_component,billing_component
string trin_component,trout_component
string scheduler_guid,billing_guid
end variables

forward prototypes
public subroutine pm_menu (long pl_row)
public subroutine refresh (string ps_arg)
public subroutine pm_new_appointment ()
public subroutine pm_resource_menu (long pl_row)
public subroutine pm_new_resource ()
public subroutine pm_get_scheduler_attributes ()
public subroutine pm_get_billing_attributes ()
end prototypes

public subroutine pm_menu (long pl_row);str_popup popup
str_popup_return popup_return
string ls_buttons[]
integer ll_button_pressed
window lw_pop_buttons
string ls_appointment_type,ls_temp
long ll_row

//popup.button_count = popup.button_count + 1
//popup.button_icons[popup.button_count] = "button17.bmp"
//popup.button_helps[popup.button_count] = "New"
//popup.button_titles[popup.button_count] = "New"
//ls_buttons[popup.button_count] = "NEW"

popup.button_count = popup.button_count + 1
popup.button_icons[popup.button_count] = "button17.bmp"
popup.button_helps[popup.button_count] = "Edit"
popup.button_titles[popup.button_count] = "Edit"
ls_buttons[popup.button_count] = "EDIT"

popup.button_count = popup.button_count + 1
popup.button_icons[popup.button_count] = "button13.bmp"
popup.button_helps[popup.button_count] = "Delete"
popup.button_titles[popup.button_count] = "Delete"
ls_buttons[popup.button_count] = "DELETE"

popup.button_count = popup.button_count + 1
popup.button_icons[popup.button_count] = "button11.bmp"
popup.button_helps[popup.button_count] = "Cancel"
popup.button_titles[popup.button_count] = "Cancel"
ls_buttons[popup.button_count] = "CANCEL"

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	ll_button_pressed = message.doubleparm
	if ll_button_pressed < 1 or ll_button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	ll_button_pressed = 1
else
	return
end if

CHOOSE CASE ls_buttons[ll_button_pressed]
	CASE "EDIT"
		popup.data_row_count = 5
		popup.items[1] = "EDIT"
		popup.items[2] = dw_integrations.object.appointment_type[pl_row]
		popup.items[3] = dw_integrations.object.encounter_type[pl_row]
		if (dw_integrations.object.new_flag[pl_row] = 'N') then
			popup.items[4] = "No"
		Elseif (dw_integrations.object.new_flag[pl_row] = 'Y') then
			popup.items[4] = "Yes"
		End If
		popup.items[5] = dw_integrations.object.appointment_text[pl_row]
		Openwithparm(w_map_appointment_type, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 3 then return
		dw_integrations.setitem(pl_row, "appointment_type", popup_return.items[1])
		dw_integrations.setitem(pl_row, "encounter_type", popup_return.items[2])
		dw_integrations.setitem(pl_row, "new_flag", popup_return.items[3])
	CASE "DELETE"
		ls_temp = "Are you sure you wish to delete this record ?"
		openwithparm(w_pop_yes_no, ls_temp)
		popup_return = message.powerobjectparm
		if popup_return.item = "YES" then
			ls_appointment_type = dw_integrations.object.appointment_type[pl_row]
			DELETE b_appointment_type
			WHERE appointment_type = :ls_appointment_type
			Using Sqlca;
			if not tf_check() then return
			dw_integrations.deleterow(pl_row)
		end if
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return


end subroutine

public subroutine refresh (string ps_arg);// update the current changes
if updatemode then
	dw_integrations.update()
end if
dw_integrations.setredraw(false)
cb_new.visible = false
cb_new.text = "New"
updatemode = false
Choose Case ps_arg
	Case "Facility"
		dw_integrations.dataobject = "dw_pm_office"
		dw_integrations.settransobject(sqlca)
		dw_integrations.retrieve()
		updatemode = true
	Case "Provider"
		dw_integrations.dataobject = "dw_pm_users"
		dw_integrations.settransobject(sqlca)
		dw_integrations.retrieve()
		updatemode = true
	Case "MessagePath"
		dw_integrations.dataobject = "dw_pm_message_path"
		dw_integrations.settransobject(sqlca)
		dw_integrations.retrieve()
		updatemode = true
	Case "Appointments"
		dw_integrations.dataobject = "dw_pm_appointment_types"
		dw_integrations.settransobject(sqlca)
		dw_integrations.retrieve()
		cb_new.visible = true
	Case "Resource"
		dw_integrations.dataobject = "dw_pm_resources"
		dw_integrations.settransobject(sqlca)
		dw_integrations.retrieve()
		cb_new.visible = true
	Case "Attributes"
		dw_integrations.dataobject = "dw_sp_get_pm_attributes"
		dw_integrations.settransobject(sqlca)
		dw_integrations.retrieve(default_billing_system)
		cb_new.visible = true
		cb_new.text = "..."
End Choose

dw_integrations.setredraw(true)
dw_integrations.visible = true

end subroutine

public subroutine pm_new_appointment ();str_popup popup
str_popup_return popup_return
long ll_row

popup.data_row_count = 5
popup.items[1] = "NEW" 
popup.items[2] = "" // appointment_type
popup.items[3] = "" // encounter type
popup.items[4] = "No" //new flag
popup.items[5] = ""
Openwithparm(w_map_appointment_type,popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 3 then return
ll_row = dw_integrations.insertrow(0)
dw_integrations.setitem(ll_row, "appointment_type", popup_return.items[1])
dw_integrations.setitem(ll_row, "encounter_type", popup_return.items[2])
dw_integrations.setitem(ll_row, "new_flag", popup_return.items[3])

end subroutine

public subroutine pm_resource_menu (long pl_row);str_popup popup
str_popup_return popup_return
string ls_buttons[]
integer ll_button_pressed
window lw_pop_buttons
string ls_appointment_type,ls_resource_type,ls_temp
long ll_resource_sequence,ll_row

//popup.button_count = popup.button_count + 1
//popup.button_icons[popup.button_count] = "button17.bmp"
//popup.button_helps[popup.button_count] = "New"
//popup.button_titles[popup.button_count] = "New"
//ls_buttons[popup.button_count] = "NEW"

popup.button_count = popup.button_count + 1
popup.button_icons[popup.button_count] = "button17.bmp"
popup.button_helps[popup.button_count] = "Edit"
popup.button_titles[popup.button_count] = "Edit"
ls_buttons[popup.button_count] = "EDIT"

popup.button_count = popup.button_count + 1
popup.button_icons[popup.button_count] = "button13.bmp"
popup.button_helps[popup.button_count] = "Delete"
popup.button_titles[popup.button_count] = "Delete"
ls_buttons[popup.button_count] = "DELETE"

popup.button_count = popup.button_count + 1
popup.button_icons[popup.button_count] = "button11.bmp"
popup.button_helps[popup.button_count] = "Cancel"
popup.button_titles[popup.button_count] = "Cancel"
ls_buttons[popup.button_count] = "CANCEL"

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	ll_button_pressed = message.doubleparm
	if ll_button_pressed < 1 or ll_button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	ll_button_pressed = 1
else
	return
end if

CHOOSE CASE ls_buttons[ll_button_pressed]
	CASE "NEW"
	CASE "EDIT"
		popup.data_row_count = 9
		popup.items[1] = "EDIT"
		popup.items[2] = string(dw_integrations.object.resource_sequence[pl_row])
		popup.items[3] = dw_integrations.object.appointment_type[pl_row]
		popup.items[4] = dw_integrations.object.resource[pl_row]
		popup.items[5] = dw_integrations.object.encounter_type[pl_row]
		popup.items[6] = dw_integrations.object.user_id[pl_row]
		if (dw_integrations.object.new_flag[pl_row] = 'N') then
			popup.items[7] = "No"
		Else
			popup.items[7] = "Yes"
		End If
		popup.items[8] = string(dw_integrations.object.sort_sequence[pl_row])
		popup.items[9] = 	dw_integrations.object.resource_text[pl_row]
		Openwithparm(w_map_resource, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 7 then return
		dw_integrations.setitem(pl_row, "appointment_type", popup_return.items[1])
		dw_integrations.setitem(pl_row, "resource", popup_return.items[2])
		dw_integrations.setitem(pl_row, "encounter_type", popup_return.items[3])
		dw_integrations.setitem(pl_row, "user_id", popup_return.items[4])
		dw_integrations.setitem(pl_row, "new_flag", popup_return.items[5])
		dw_integrations.setitem(pl_row, "resource_sequence", long(popup_return.items[6]))
		dw_integrations.setitem(pl_row,"sort_sequence",long(popup_return.items[7]))
	CASE "DELETE"
		ls_temp = "Are you sure you wish to delete this record ?"
		openwithparm(w_pop_yes_no, ls_temp)
		popup_return = message.powerobjectparm
		if popup_return.item = "YES" then
			ll_resource_sequence = dw_integrations.object.resource_sequence[pl_row]
			DELETE b_resource
			WHERE resource_sequence = :ll_resource_sequence
			Using Sqlca;
			if not tf_check() then return
			dw_integrations.deleterow(pl_row)
		end if
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return


end subroutine

public subroutine pm_new_resource ();str_popup popup
str_popup_return popup_return
long ll_row
string ls_null

Setnull(ls_null)
popup.data_row_count = 9
popup.items[1] = "NEW" 
popup.items[2] = "" //resource sequence
popup.items[3] = "" // appointment_type
popup.items[4] = "" //resource
popup.items[5] = "" // encounter type
popup.items[6] = "" // user id
popup.items[7] = "No" //new flag
popup.items[8] = ls_null
popup.items[9] = ""
Openwithparm(w_map_resource,popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 7 then return
ll_row = dw_integrations.insertrow(0)
dw_integrations.setitem(ll_row, "appointment_type", popup_return.items[1])
dw_integrations.setitem(ll_row, "resource", popup_return.items[2])
dw_integrations.setitem(ll_row, "encounter_type", popup_return.items[3])
dw_integrations.setitem(ll_row, "user_id", popup_return.items[4])
dw_integrations.setitem(ll_row, "new_flag", popup_return.items[5])
dw_integrations.setitem(ll_row, "resource_sequence", long(popup_return.items[6]))
dw_integrations.setitem(ll_row,"sort_sequence",long(popup_return.items[7]))
end subroutine

public subroutine pm_get_scheduler_attributes ();integer li_sts,i
str_attributes	lstr_attributes

u_ds_data	luo_data

lstr_attributes.attribute_count = 0
dw_integrations.setredraw(false)
dw_integrations.setfilter("component_id='"+scheduler_component+"'")
dw_integrations.filter()
f_attribute_dw_to_str(dw_integrations, lstr_attributes)

li_sts = f_get_params(scheduler_guid, "Config", lstr_attributes)
if li_sts < 0 then
	return
end if

// Get the existing attributes
luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_get_pm_attributes")
li_sts = luo_data.retrieve(scheduler_component)

// Add/replace the new attributes, removing any attributes no longer referenced
f_attribute_str_to_ds(lstr_attributes, luo_data)

// For any new records, add the key values
FOR i = 1 TO luo_data.rowcount()
	IF isnull(luo_data.object.component_id[i]) then
		luo_data.object.component_id[i] = billing_component
	END IF
NEXT

// Update the attributes
li_sts = luo_data.update()
DESTROY luo_data
if li_sts < 0 then
	log.log(this, "w_server_setup.pm_get_scheduler_attributes.0036", "Error updating command attributes", 4)
	return
end if

dw_integrations.setfilter("")
dw_integrations.filter()
dw_integrations.setredraw(true)
end subroutine

public subroutine pm_get_billing_attributes ();integer li_sts,i
str_attributes	lstr_attributes

u_ds_data	luo_data

lstr_attributes.attribute_count = 0
dw_integrations.setredraw(false)
dw_integrations.setfilter("component_id='"+billing_component+"'")
dw_integrations.filter()
f_attribute_dw_to_str(dw_integrations, lstr_attributes)

li_sts = f_get_params(billing_guid, "Config", lstr_attributes)
if li_sts < 0 then
	return
end if

// Get the existing attributes
luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_get_pm_attributes")
li_sts = luo_data.retrieve(billing_component)

// Add/replace the new attributes, removing any attributes no longer referenced
f_attribute_str_to_ds(lstr_attributes, luo_data)

// For any new records, add the key values
FOR i = 1 TO luo_data.rowcount()
	IF isnull(luo_data.object.component_id[i]) then
		luo_data.object.component_id[i] = billing_component
	END IF
NEXT

// Update the attributes
li_sts = luo_data.update()
DESTROY luo_data
if li_sts < 0 then
	log.log(this, "w_server_setup.pm_get_scheduler_attributes.0036", "Error updating command attributes", 4)
	return
end if

dw_integrations.setfilter("")
dw_integrations.filter()
dw_integrations.setredraw(true)
end subroutine

on w_server_setup.create
int iCurrent
call super::create
this.dw_integrations=create dw_integrations
this.cb_integration=create cb_integration
this.cb_mapping=create cb_mapping
this.st_1=create st_1
this.st_3=create st_3
this.pb_1=create pb_1
this.st_pm=create st_pm
this.cb_new=create cb_new
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_integrations
this.Control[iCurrent+2]=this.cb_integration
this.Control[iCurrent+3]=this.cb_mapping
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.pb_1
this.Control[iCurrent+7]=this.st_pm
this.Control[iCurrent+8]=this.cb_new
end on

on w_server_setup.destroy
call super::destroy
destroy(this.dw_integrations)
destroy(this.cb_integration)
destroy(this.cb_mapping)
destroy(this.st_1)
destroy(this.st_3)
destroy(this.pb_1)
destroy(this.st_pm)
destroy(this.cb_new)
end on

event open;call super::open;default_billing_system = datalist.get_preference("PREFERENCES","default_billing_system")
if isnull(default_billing_system) then
	cb_integration.text = "<NULL>"
	st_pm.visible = true
Else
	cb_mapping.visible = true
	st_3.visible = true
	SELECT name,
		schedule_id,
		billing_id,
		message_in,
		message_out
	INTO :cb_integration.text, 
		:scheduler_component,
		:billing_component,
		:trin_component,
		:trout_component
	FROM x_Integrations
	WHERE billing_system = :default_billing_system
	Using sqlca;
	If not tf_check() then
		Close(this)
		Return -1
	End If
	Postevent("post_open")
End If
end event

event post_open;call super::post_open;// GUID for scheduler
SELECT convert(varchar(38),id)
INTO :scheduler_guid
FROM dbo.fn_components()
WHERE component_id = :scheduler_component
Using sqlca;
if not tf_check() then
	Close(this)
	Return
end if
SELECT convert(varchar(38),id)
INTO :billing_guid
FROM dbo.fn_components()
WHERE component_id = :billing_component
Using sqlca;
if not tf_check() then
	Close(this)
	Return
end if

// GUID for billing
refresh("Facility")
cb_mapping.text = "Facility"

end event

type pb_epro_help from w_window_base`pb_epro_help within w_server_setup
boolean visible = true
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_server_setup
end type

type dw_integrations from u_dw_pick_list within w_server_setup
boolean visible = false
integer y = 192
integer width = 2907
integer height = 1248
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_pm_office"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = false
end type

event post_click;call super::post_click;if cb_mapping.text = "Appointments" then
	pm_menu(clicked_row)
elseif cb_mapping.text = "Resource" then
	pm_resource_menu(clicked_row)
end if
end event

event itemerror;call super::itemerror;return 2
end event

type cb_integration from commandbutton within w_server_setup
integer x = 658
integer y = 32
integer width = 1390
integer height = 128
integer taborder = 21
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
end type

event clicked;string    ls_message,ls_desc,ls_default_billing_system
str_popup popup
str_popup_return popup_return

DECLARE lsp_setup_integration PROCEDURE FOR dbo.sp_setup_practicemanagement
@ps_billing_system = :default_billing_system,
@ps_office_id = :office_id
USING SQLCA; 

popup.dataobject = "dw_pick_integration"
popup.datacolumn = 1
popup.displaycolumn = 2
Openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
If popup_return.item_count <> 1 Then Return
If isnull(default_billing_system) OR (popup_return.items[1] <> default_billing_system) Then
	ls_default_billing_system = popup_return.items[1]
	ls_desc = popup_return.descriptions[1]
	ls_message = "Do you want to set this "+Upper(popup_return.descriptions[1])+" as your default practice management system?"
	OpenWithParm(w_pop_yes_no, ls_message)
	popup_return = message.powerobjectparm
	If popup_return.item <> "YES" then Return

	default_billing_system = ls_default_billing_system
	cb_integration.text = ls_desc
	cb_mapping.visible = true
	st_3.visible = true
	EXECUTE lsp_setup_integration;
	Refresh(cb_mapping.text)

End If
end event

type cb_mapping from commandbutton within w_server_setup
boolean visible = false
integer x = 695
integer y = 1472
integer width = 1390
integer height = 128
integer taborder = 31
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "<None>"
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.data_row_count = 6
popup.items[1] = "Facility"
popup.items[2] = "Provider"
popup.items[3] = "MessagePath"
popup.items[4] = "Appointments"
popup.items[5] = "Resource"
popup.items[6] = "Attributes"

Openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
If popup_return.item_count <> 1 Then Return
text = popup_return.items[1]
refresh(popup_return.items[1])
end event

type st_1 from statictext within w_server_setup
integer x = 37
integer y = 64
integer width = 622
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Practice Managment"
boolean focusrectangle = false
end type

type st_3 from statictext within w_server_setup
boolean visible = false
integer x = 366
integer y = 1504
integer width = 293
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Mapping"
alignment alignment = right!
boolean focusrectangle = false
end type

type pb_1 from u_picture_button within w_server_setup
integer x = 2523
integer y = 1472
integer taborder = 11
boolean bringtotop = true
string picturename = "button26.bmp"
string disabledname = "button26.bmp"
end type

event clicked;call super::clicked;if updatemode then
	dw_integrations.update()
end if

Close(Parent)
end event

type st_pm from statictext within w_server_setup
boolean visible = false
integer x = 1024
integer y = 640
integer width = 914
integer height = 352
boolean bringtotop = true
integer textsize = -16
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Practice Management Not Setup"
alignment alignment = center!
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type cb_new from commandbutton within w_server_setup
boolean visible = false
integer x = 2121
integer y = 1472
integer width = 293
integer height = 128
integer taborder = 41
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New"
end type

event clicked;str_popup			popup
str_popup_return	popup_return

If cb_mapping.text = "Appointments" then
	pm_new_appointment()
Elseif cb_mapping.text = "Resource" then
	pm_new_resource()
Elseif cb_mapping.text = "Attributes" then
	popup.data_row_count = 2
	popup.items[1] = "Scheduler"
	popup.items[2] = "Billing"
	Openwithparm(w_pop_pick, popup)
	popup_return = message.powerobjectparm
	If popup_return.item_count <> 1 Then Return
	if popup_return.items[1] = "Scheduler" then
		pm_get_scheduler_attributes()
	elseif popup_return.items[1] = "Billing" then
		pm_get_billing_attributes()
	end if
	refresh("Attributes")
End if
end event

