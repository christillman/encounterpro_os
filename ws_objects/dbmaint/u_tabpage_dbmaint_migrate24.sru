HA$PBExportHeader$u_tabpage_dbmaint_migrate24.sru
forward
global type u_tabpage_dbmaint_migrate24 from u_tabpage
end type
type st_1 from statictext within u_tabpage_dbmaint_migrate24
end type
type st_script_version from statictext within u_tabpage_dbmaint_migrate24
end type
type cb_refresh_scripts from commandbutton within u_tabpage_dbmaint_migrate24
end type
type st_3 from statictext within u_tabpage_dbmaint_migrate24
end type
type st_migrate_patient from statictext within u_tabpage_dbmaint_migrate24
end type
type st_migrate_pre from statictext within u_tabpage_dbmaint_migrate24
end type
type sle_version_2_database from singlelineedit within u_tabpage_dbmaint_migrate24
end type
type st_version_2_database_title from statictext within u_tabpage_dbmaint_migrate24
end type
type cb_migrate from commandbutton within u_tabpage_dbmaint_migrate24
end type
type st_title from statictext within u_tabpage_dbmaint_migrate24
end type
type dw_scripts from u_dw_pick_list within u_tabpage_dbmaint_migrate24
end type
type cb_execute_from from commandbutton within u_tabpage_dbmaint_migrate24
end type
type st_2 from statictext within u_tabpage_dbmaint_migrate24
end type
end forward

global type u_tabpage_dbmaint_migrate24 from u_tabpage
integer width = 2898
string text = "Updates"
st_1 st_1
st_script_version st_script_version
cb_refresh_scripts cb_refresh_scripts
st_3 st_3
st_migrate_patient st_migrate_patient
st_migrate_pre st_migrate_pre
sle_version_2_database sle_version_2_database
st_version_2_database_title st_version_2_database_title
cb_migrate cb_migrate
st_title st_title
dw_scripts dw_scripts
cb_execute_from cb_execute_from
st_2 st_2
end type
global u_tabpage_dbmaint_migrate24 u_tabpage_dbmaint_migrate24

type variables

integer migrate_which

boolean first_time = true

string migrate_id[2] = { "{7EDD292F-7F1B-4AA6-8E81-27D81169566E}", &
								"{F284F90E-BEC4-437A-94BE-DBFFFD4C8494}" }

string script_type[2] = { "Migration24 Prep", &
									"Migration24" }



end variables

forward prototypes
public subroutine refresh ()
public function integer display_scripts (string ps_script_type)
public function integer run_scripts (string ps_start_from_script_name)
end prototypes

public subroutine refresh ();string ls_db

dw_scripts.settransobject(sqlca)

SELECT dbo.fn_get_preference("SYSTEM", "version2db", NULL, NULL)
INTO :ls_db
FROM c_1_Record;
if not tf_check() then return

if len(ls_db) > 0 and sle_version_2_database.text = "" then
	sle_version_2_database.text = ls_db
end if

if first_time then
	first_time = false
	if len(sle_version_2_database.text) > 0 then
		st_migrate_pre.event trigger clicked()
	else
		st_migrate_patient.event trigger clicked()
	end if
end if


end subroutine

public function integer display_scripts (string ps_script_type);u_ds_data luo_data
long ll_count
long ll_null
long i
long ll_script_id
string ls_script_name
long ll_row
long ll_migration_mod_level
string ls_system_id

setnull(ll_null)

dw_scripts.setredraw(false)
dw_scripts.reset()

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_jmj_latest_scripts")
ll_count = luo_data.retrieve(ps_script_type, sqlca.db_script_major_release, sqlca.db_script_database_version, ll_null)
if ll_count <= 0 then return -1

for i = 1 to ll_count
	ll_script_id = luo_data.object.script_id[i]
	ls_script_name = luo_data.object.script_name[i]
	
	ll_row = dw_scripts.insertrow(0)
	dw_scripts.object.script_id[ll_row] = ll_script_id
	dw_scripts.object.script_name[ll_row] = ls_script_name
next

dw_scripts.sort()
dw_scripts.setredraw(true)

DESTROY luo_data

// Get the system_id
SELECT system_id
INTO :ls_system_id
FROM c_Database_Script_Type
WHERE script_type = :ps_script_type;
if not tf_check() or sqlca.sqlcode = 100 then
	st_script_version.text = ""
else
	ll_migration_mod_level = sqlca.fn_latest_system_version(ls_system_id, sqlca.db_script_major_release, sqlca.db_script_database_version, ll_null)
	st_script_version.text = "Migration Scripts Version "
	st_script_version.text += string(sqlca.db_script_major_release) + "." + sqlca.db_script_database_version + "."
	st_script_version.text += string(ll_migration_mod_level)
end if

return 1

end function

public function integer run_scripts (string ps_start_from_script_name);long ll_script_id
long ll_count
long i
str_attributes lstr_attributes
integer li_sts
integer li_please_wait_index
str_popup_return popup_return
str_popup popup
long ll_choice
string ls_message
boolean lb_keep_patient_data
string ls_script_name
datetime ldt_now
string ls_script
string ls_completion_status
long ll_from_row

if isnull(sle_version_2_database.text) or trim(sle_version_2_database.text) = "" then
	openwithparm(w_pop_message, "You must specify the Version 2 Database")
	return 0
end if

if migrate_which = 1 then
	lb_keep_patient_data = false
	openwithparm(w_pop_yes_no, "Are you sure you want to migrate the office configuration data from the specified version 2 database?")
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return 0
else
	openwithparm(w_pop_yes_no, "Are you sure you want to migrate the patient data from the specified version 2 database?")
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return 0
	
	
	popup.data_row_count = 2
	popup.items[1] = "Keep existing patient data"
	popup.items[2] = "Delete patient data"
	popup.title = "EncounterPRO can keep the existing patient data and attempt to re-migrate any missing data, "
	popup.title += "or EncounterPRO can delete the existing patient data and remigrate all data from version 2"
	openwithparm(w_pop_choices_2, popup)
	ll_choice = message.doubleparm

	ls_message = "You have elected to "
	if ll_choice = 1 then
		lb_keep_patient_data = true
		ls_message += "keep the existing patient data"
	else
		lb_keep_patient_data = false
		ls_message += "delete the existing patient data"
	end if
	ls_message += ".  Are you sure?"
	
	openwithparm(w_pop_yes_no, ls_message)
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return 0
end if

//datalist.update_preference("SYSTEM", "Global", "Global", "version2db", sle_version_2_database.text)
sqlca.sp_set_preference("SYSTEM", "Global", "Global", "version2db", sle_version_2_database.text)
if not tf_check() then return -1

f_attribute_add_attribute(lstr_attributes, "default_specialty", "$PEDS")

li_sts = f_get_params(migrate_id[migrate_which], "Runtime", lstr_attributes)
if li_sts < 0 then return 0

//////////////////////////////////////////////////////////
// First make sure the c_Database_Scripts table is current
//////////////////////////////////////////////////////////

li_sts = sqlca.bootstrap_database_scripts()
if li_sts <= 0 then
	log.log(this, "run_scripts()", "Error updating database scripts", 4)
	return -1
end if

// Redisplay database scripts
li_sts = display_scripts(script_type[migrate_which])
if li_sts <= 0 then
	log.log(this, "run_scripts()", "Error displaying latest scripts", 4)
	return -1
end if


f_attribute_add_attribute(lstr_attributes, "version2db", sle_version_2_database.text)

f_please_wait_progress_bar(li_please_wait_index, 0, ll_count)

li_please_wait_index = f_please_wait_open()

ll_count = dw_scripts.rowcount()

// If we're running from a particular script, find it
ll_from_row = 1
if not isnull(ps_start_from_script_name) then
	for i = 1 to ll_count
		ls_script_name  = dw_scripts.object.script_name[i]
		if lower(ls_script_name) = lower(ps_start_from_script_name) then
			ll_from_row = i
			exit
		end if
	next
end if

for i = ll_from_row to ll_count
	ll_script_id = dw_scripts.object.script_id[i]
	ls_script_name  = dw_scripts.object.script_name[i]
	ldt_now = datetime(today(), now())
	
	if lb_keep_patient_data then
		if pos(lower(ls_script_name), "patient setup") > 0 then
			ls_completion_status = "Skipped"

			dw_scripts.object.status[i] = ls_completion_status

			INSERT INTO c_Database_Script_Log (
				script_id,
				executed_date_time,
				executed_from_computer_id,
				completion_status)
			VALUES (
				:ll_script_id,
				:ldt_now,
				:computer_id,
				:ls_completion_status);
			if not tf_check() then return -1
			continue
		end if
	end if
	
	dw_scripts.object.status[i] = "Running"
	
	li_sts = sqlca.execute_script( ll_script_id, lstr_attributes)
	
	if li_sts <= 0 then
		dw_scripts.object.status[i] = "Error"
		f_please_wait_close(li_please_wait_index)
		return -1
	else
		dw_scripts.object.status[i] = "OK"
	end if
	f_please_wait_progress_bar(li_please_wait_index, i, ll_count)
	
	// Yield to let screens refresh
	yield()
next

f_please_wait_close(li_please_wait_index)


return 1

end function

on u_tabpage_dbmaint_migrate24.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_script_version=create st_script_version
this.cb_refresh_scripts=create cb_refresh_scripts
this.st_3=create st_3
this.st_migrate_patient=create st_migrate_patient
this.st_migrate_pre=create st_migrate_pre
this.sle_version_2_database=create sle_version_2_database
this.st_version_2_database_title=create st_version_2_database_title
this.cb_migrate=create cb_migrate
this.st_title=create st_title
this.dw_scripts=create dw_scripts
this.cb_execute_from=create cb_execute_from
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_script_version
this.Control[iCurrent+3]=this.cb_refresh_scripts
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_migrate_patient
this.Control[iCurrent+6]=this.st_migrate_pre
this.Control[iCurrent+7]=this.sle_version_2_database
this.Control[iCurrent+8]=this.st_version_2_database_title
this.Control[iCurrent+9]=this.cb_migrate
this.Control[iCurrent+10]=this.st_title
this.Control[iCurrent+11]=this.dw_scripts
this.Control[iCurrent+12]=this.cb_execute_from
this.Control[iCurrent+13]=this.st_2
end on

on u_tabpage_dbmaint_migrate24.destroy
call super::destroy
destroy(this.st_1)
destroy(this.st_script_version)
destroy(this.cb_refresh_scripts)
destroy(this.st_3)
destroy(this.st_migrate_patient)
destroy(this.st_migrate_pre)
destroy(this.sle_version_2_database)
destroy(this.st_version_2_database_title)
destroy(this.cb_migrate)
destroy(this.st_title)
destroy(this.dw_scripts)
destroy(this.cb_execute_from)
destroy(this.st_2)
end on

type st_1 from statictext within u_tabpage_dbmaint_migrate24
integer x = 2208
integer y = 960
integer width = 151
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "or"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_script_version from statictext within u_tabpage_dbmaint_migrate24
integer x = 110
integer y = 384
integer width = 1554
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_refresh_scripts from commandbutton within u_tabpage_dbmaint_migrate24
integer x = 635
integer y = 1376
integer width = 503
integer height = 88
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Refresh Scripts"
end type

event clicked;integer li_sts

li_sts = sqlca.bootstrap_database_scripts()
if li_sts <= 0 then
	log.log(this, "set_available_versions()", "Error updating database scripts", 4)
	return -1
end if


li_sts = display_scripts(script_type[migrate_which])
if li_sts <= 0 then
	log.log(this, "run_scripts()", "Error displaying latest scripts", 4)
	return -1
end if

end event

type st_3 from statictext within u_tabpage_dbmaint_migrate24
integer x = 571
integer y = 164
integer width = 590
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 33538240
string text = "Migration Mode"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_migrate_patient from statictext within u_tabpage_dbmaint_migrate24
integer x = 923
integer y = 260
integer width = 571
integer height = 112
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Patient Data"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_migrate_pre.backcolor = color_object

migrate_which = 2

display_scripts(script_type[migrate_which])

end event

type st_migrate_pre from statictext within u_tabpage_dbmaint_migrate24
integer x = 274
integer y = 260
integer width = 571
integer height = 112
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Prep"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_migrate_patient.backcolor = color_object

migrate_which = 1


display_scripts(script_type[migrate_which])

end event

type sle_version_2_database from singlelineedit within u_tabpage_dbmaint_migrate24
integer x = 1783
integer y = 448
integer width = 997
integer height = 92
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_version_2_database_title from statictext within u_tabpage_dbmaint_migrate24
integer x = 1989
integer y = 380
integer width = 590
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Version 2 Database"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_migrate from commandbutton within u_tabpage_dbmaint_migrate24
integer x = 2021
integer y = 844
integer width = 521
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Execute"
end type

event clicked;string ls_script_name

setnull(ls_script_name)

run_scripts(ls_script_name)

end event

type st_title from statictext within u_tabpage_dbmaint_migrate24
integer x = 178
integer y = 20
integer width = 2533
integer height = 112
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Version 2 to Version 4 Migration"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_scripts from u_dw_pick_list within u_tabpage_dbmaint_migrate24
integer x = 110
integer y = 452
integer width = 1554
integer height = 900
integer taborder = 30
string dataobject = "dw_migrate_scripts"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event selected;call super::selected;
cb_execute_from.visible = true

end event

event unselected;call super::unselected;
cb_execute_from.visible = false


end event

type cb_execute_from from commandbutton within u_tabpage_dbmaint_migrate24
boolean visible = false
integer x = 1824
integer y = 1032
integer width = 919
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Execute From Selected Script"
end type

event clicked;long ll_row
string ls_script_name

ll_row = dw_scripts.get_selected_row()
if ll_row > 0 then
	ls_script_name = dw_scripts.object.script_name[ll_row]
	run_scripts(ls_script_name)
end if


end event

type st_2 from statictext within u_tabpage_dbmaint_migrate24
integer x = 1824
integer y = 1056
integer width = 919
integer height = 88
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Select Script to Execute From"
alignment alignment = center!
boolean focusrectangle = false
end type

