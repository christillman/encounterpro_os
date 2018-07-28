HA$PBExportHeader$u_tabpage_dbmaint_schedule.sru
forward
global type u_tabpage_dbmaint_schedule from u_tabpage
end type
type st_maintenance_user from statictext within u_tabpage_dbmaint_schedule
end type
type st_maintenance_user_title from statictext within u_tabpage_dbmaint_schedule
end type
type cb_cancel_changes from commandbutton within u_tabpage_dbmaint_schedule
end type
type st_2 from statictext within u_tabpage_dbmaint_schedule
end type
type cb_save_changes from commandbutton within u_tabpage_dbmaint_schedule
end type
type cbx_maintenance_frequent from checkbox within u_tabpage_dbmaint_schedule
end type
type cbx_run_hotfixes from checkbox within u_tabpage_dbmaint_schedule
end type
type cbx_sync_content from checkbox within u_tabpage_dbmaint_schedule
end type
type cbx_sync_db_scripts from checkbox within u_tabpage_dbmaint_schedule
end type
type st_1 from statictext within u_tabpage_dbmaint_schedule
end type
type em_maintenance_time from editmask within u_tabpage_dbmaint_schedule
end type
type st_maintenance_disabled from statictext within u_tabpage_dbmaint_schedule
end type
type st_maintenance_enabled from statictext within u_tabpage_dbmaint_schedule
end type
type st_maintenance_active_title from statictext within u_tabpage_dbmaint_schedule
end type
type st_title from statictext within u_tabpage_dbmaint_schedule
end type
end forward

global type u_tabpage_dbmaint_schedule from u_tabpage
integer width = 2898
string text = "Updates"
st_maintenance_user st_maintenance_user
st_maintenance_user_title st_maintenance_user_title
cb_cancel_changes cb_cancel_changes
st_2 st_2
cb_save_changes cb_save_changes
cbx_maintenance_frequent cbx_maintenance_frequent
cbx_run_hotfixes cbx_run_hotfixes
cbx_sync_content cbx_sync_content
cbx_sync_db_scripts cbx_sync_db_scripts
st_1 st_1
em_maintenance_time em_maintenance_time
st_maintenance_disabled st_maintenance_disabled
st_maintenance_enabled st_maintenance_enabled
st_maintenance_active_title st_maintenance_active_title
st_title st_title
end type
global u_tabpage_dbmaint_schedule u_tabpage_dbmaint_schedule

type variables
long service_sequence
boolean changes_made

string service
string schedule_type

string status


end variables

forward prototypes
public subroutine refresh ()
public function integer initialize ()
public function integer save_changes ()
end prototypes

public subroutine refresh ();

if status = "OK" then
	st_maintenance_enabled.backcolor = color_object_selected
	st_maintenance_disabled.backcolor = color_object
else
	st_maintenance_enabled.backcolor = color_object
	st_maintenance_disabled.backcolor = color_object_selected
end if

if changes_made then
	cb_cancel_changes.visible = true
	cb_save_changes.visible = true
else
	cb_cancel_changes.visible = false
	cb_save_changes.visible = false
end if


end subroutine

public function integer initialize ();long ll_count
u_ds_data luo_data
long i
string ls_attribute
string ls_value

SELECT user_id,
	service,
	schedule_type,
	schedule_interval,
	status
INTO :st_maintenance_user.text,
	:service,
	:schedule_type,
	:em_maintenance_time.text,
	:status
FROM o_Service_Schedule
WHERE service_sequence = :service_sequence;
if not tf_check() then return -1
if sqlca.sqlnrows <> 1 then
	log.log(this, "initialize()", "Invalid service_sequence (" + string(service_sequence) + ")", 4)
	return -1
end if

text = em_maintenance_time.text

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_service_schedule_attributes")
ll_count = luo_data.retrieve(service_sequence)
if ll_count < 0 then return -1

for i = 1 to ll_count
	ls_attribute = luo_data.object.attribute[i]
	ls_value = luo_data.object.value[i]
	
	CHOOSE CASE lower(ls_attribute)
		CASE "sync database scripts"
			cbx_sync_db_scripts.checked = f_string_to_boolean(ls_value)
		CASE "sync content"
			cbx_sync_content.checked = f_string_to_boolean(ls_value)
		CASE "run new hotfixes"
			cbx_run_hotfixes.checked = f_string_to_boolean(ls_value)
		CASE "daily maintenance"
			cbx_maintenance_frequent.checked = f_string_to_boolean(ls_value)
	END CHOOSE
next

changes_made = false

end function

public function integer save_changes ();
UPDATE o_Service_Schedule
SET user_id = :st_maintenance_user.text,
	schedule_interval = :em_maintenance_time.text,
	status = :status
WHERE service_sequence = :service_sequence;
if not tf_check() then return -1
if sqlca.sqlnrows <> 1 then
	log.log(this, "save_changes()", "Invalid service_sequence (" + string(service_sequence) + ")", 4)
	return -1
end if

text = em_maintenance_time.text

// Update the service attributes

sqlca.jmj_set_maintenance_service_attribute(service_sequence, "Sync Database Scripts", f_boolean_to_string(cbx_sync_db_scripts.checked))
if not tf_check() then return -1

sqlca.jmj_set_maintenance_service_attribute(service_sequence, "Sync Content", f_boolean_to_string(cbx_sync_content.checked))
if not tf_check() then return -1

sqlca.jmj_set_maintenance_service_attribute(service_sequence, "Run New Hotfixes", f_boolean_to_string(cbx_run_hotfixes.checked))
if not tf_check() then return -1

sqlca.jmj_set_maintenance_service_attribute(service_sequence, "Daily Maintenance", f_boolean_to_string(cbx_maintenance_frequent.checked))
if not tf_check() then return -1


changes_made = false

return 1


end function

on u_tabpage_dbmaint_schedule.create
int iCurrent
call super::create
this.st_maintenance_user=create st_maintenance_user
this.st_maintenance_user_title=create st_maintenance_user_title
this.cb_cancel_changes=create cb_cancel_changes
this.st_2=create st_2
this.cb_save_changes=create cb_save_changes
this.cbx_maintenance_frequent=create cbx_maintenance_frequent
this.cbx_run_hotfixes=create cbx_run_hotfixes
this.cbx_sync_content=create cbx_sync_content
this.cbx_sync_db_scripts=create cbx_sync_db_scripts
this.st_1=create st_1
this.em_maintenance_time=create em_maintenance_time
this.st_maintenance_disabled=create st_maintenance_disabled
this.st_maintenance_enabled=create st_maintenance_enabled
this.st_maintenance_active_title=create st_maintenance_active_title
this.st_title=create st_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_maintenance_user
this.Control[iCurrent+2]=this.st_maintenance_user_title
this.Control[iCurrent+3]=this.cb_cancel_changes
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.cb_save_changes
this.Control[iCurrent+6]=this.cbx_maintenance_frequent
this.Control[iCurrent+7]=this.cbx_run_hotfixes
this.Control[iCurrent+8]=this.cbx_sync_content
this.Control[iCurrent+9]=this.cbx_sync_db_scripts
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.em_maintenance_time
this.Control[iCurrent+12]=this.st_maintenance_disabled
this.Control[iCurrent+13]=this.st_maintenance_enabled
this.Control[iCurrent+14]=this.st_maintenance_active_title
this.Control[iCurrent+15]=this.st_title
end on

on u_tabpage_dbmaint_schedule.destroy
call super::destroy
destroy(this.st_maintenance_user)
destroy(this.st_maintenance_user_title)
destroy(this.cb_cancel_changes)
destroy(this.st_2)
destroy(this.cb_save_changes)
destroy(this.cbx_maintenance_frequent)
destroy(this.cbx_run_hotfixes)
destroy(this.cbx_sync_content)
destroy(this.cbx_sync_db_scripts)
destroy(this.st_1)
destroy(this.em_maintenance_time)
destroy(this.st_maintenance_disabled)
destroy(this.st_maintenance_enabled)
destroy(this.st_maintenance_active_title)
destroy(this.st_title)
end on

type st_maintenance_user from statictext within u_tabpage_dbmaint_schedule
integer x = 494
integer y = 340
integer width = 576
integer height = 92
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "#JMJ"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_system_user_pick_list"
popup.datacolumn = 1
popup.displaycolumn = 1
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

text = popup_return.items[1]

changes_made = true

refresh()

end event

type st_maintenance_user_title from statictext within u_tabpage_dbmaint_schedule
integer x = 46
integer y = 348
integer width = 416
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "System User:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_cancel_changes from commandbutton within u_tabpage_dbmaint_schedule
integer x = 41
integer y = 1152
integer width = 567
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel Changes"
end type

event clicked;initialize()
refresh()


end event

type st_2 from statictext within u_tabpage_dbmaint_schedule
integer x = 2382
integer y = 352
integer width = 462
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "(24 Hour Format)"
boolean focusrectangle = false
end type

type cb_save_changes from commandbutton within u_tabpage_dbmaint_schedule
integer x = 2181
integer y = 1152
integer width = 567
integer height = 108
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Save Changes"
end type

event clicked;save_changes()
refresh()

end event

type cbx_maintenance_frequent from checkbox within u_tabpage_dbmaint_schedule
integer x = 777
integer y = 1020
integer width = 1719
integer height = 96
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Daily Maintenance (sp_maintenance_frequent)"
end type

event clicked;changes_made = true

refresh()

end event

type cbx_run_hotfixes from checkbox within u_tabpage_dbmaint_schedule
integer x = 777
integer y = 856
integer width = 1367
integer height = 96
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Run New Hotfixes"
end type

event clicked;changes_made = true

refresh()

end event

type cbx_sync_content from checkbox within u_tabpage_dbmaint_schedule
integer x = 777
integer y = 692
integer width = 1367
integer height = 96
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Sync Content"
end type

event clicked;changes_made = true

refresh()

end event

type cbx_sync_db_scripts from checkbox within u_tabpage_dbmaint_schedule
integer x = 777
integer y = 528
integer width = 1367
integer height = 96
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Sync Database Scripts (Check Now)"
end type

event clicked;changes_made = true

refresh()

end event

type st_1 from statictext within u_tabpage_dbmaint_schedule
integer x = 1157
integer y = 348
integer width = 773
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Daily Maintenance Time:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_maintenance_time from editmask within u_tabpage_dbmaint_schedule
event clicked pbm_lbndblclk
integer x = 1961
integer y = 340
integer width = 398
integer height = 92
integer taborder = 10
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "03:00"
alignment alignment = center!
maskdatatype maskdatatype = timemask!
string mask = "hh:mm"
end type

event clicked;changes_made = true

refresh()

end event

event modified;changes_made = true

refresh()

end event

type st_maintenance_disabled from statictext within u_tabpage_dbmaint_schedule
integer x = 1646
integer y = 148
integer width = 215
integer height = 96
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "No"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup_return popup_return

status = "NA"
changes_made = true

refresh()


end event

type st_maintenance_enabled from statictext within u_tabpage_dbmaint_schedule
integer x = 1390
integer y = 148
integer width = 215
integer height = 96
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Yes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup_return popup_return

status = "OK"
changes_made = true

refresh()


end event

type st_maintenance_active_title from statictext within u_tabpage_dbmaint_schedule
integer x = 558
integer y = 160
integer width = 809
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Enable Daily Maintenance:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_title from statictext within u_tabpage_dbmaint_schedule
integer width = 2898
integer height = 88
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Database Scheduled Maintenance"
alignment alignment = center!
boolean focusrectangle = false
end type

