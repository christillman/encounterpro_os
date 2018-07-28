HA$PBExportHeader$u_tabpage_dbmaint_updates.sru
forward
global type u_tabpage_dbmaint_updates from u_tabpage
end type
type st_release_title from statictext within u_tabpage_dbmaint_updates
end type
type st_release from statictext within u_tabpage_dbmaint_updates
end type
type pb_1 from u_pb_help_button within u_tabpage_dbmaint_updates
end type
type st_16 from statictext within u_tabpage_dbmaint_updates
end type
type st_15 from statictext within u_tabpage_dbmaint_updates
end type
type st_9 from statictext within u_tabpage_dbmaint_updates
end type
type cb_check_now from commandbutton within u_tabpage_dbmaint_updates
end type
type st_last_scripts_update from statictext within u_tabpage_dbmaint_updates
end type
type st_st_last_scripts_update_title from statictext within u_tabpage_dbmaint_updates
end type
type st_script_title from statictext within u_tabpage_dbmaint_updates
end type
type dw_systems from u_dw_pick_list within u_tabpage_dbmaint_updates
end type
end forward

global type u_tabpage_dbmaint_updates from u_tabpage
string text = "Updates"
st_release_title st_release_title
st_release st_release
pb_1 pb_1
st_16 st_16
st_15 st_15
st_9 st_9
cb_check_now cb_check_now
st_last_scripts_update st_last_scripts_update
st_st_last_scripts_update_title st_st_last_scripts_update_title
st_script_title st_script_title
dw_systems dw_systems
end type
global u_tabpage_dbmaint_updates u_tabpage_dbmaint_updates

type variables

u_ds_data dependancies


end variables

forward prototypes
public subroutine refresh ()
public function integer update_database (long pl_row)
public function integer update_clientmodule (long pl_row)
public function integer set_available_versions ()
public function integer update_content (long pl_row)
public function string clientmodule_current_version (string ps_system_id)
public function string download_url (string ps_system_id, string ps_version)
public function integer redo_database (long pl_row)
end prototypes

public subroutine refresh ();string ls_epro_setup
datetime ldt_last_scripts_update
long ll_deprows
long ll_row
string ls_find
long ll_min_level
long ll_db_available_mod_level
integer li_count
string ls_system_id
string ls_system_type
string ls_profile_file_current
string ls_profile_file_available
long ll_sysrows
long i
string ls_available_version
string ls_available_major_release
string ls_available_database_version
string ls_available_build
string ls_current_version

dw_systems.settransobject(sqlca)


st_release.text = string(major_release) + "." + database_version

SELECT	last_scripts_update
INTO :ldt_last_scripts_update
FROM c_Database_Status;
if not tf_check() then return

st_last_scripts_update.text = string(ldt_last_scripts_update)

ls_epro_setup = f_default_attachment_path() + "\Install\"

// Get the dependancies
dependancies.set_dataobject("dw_c_database_modification_dependancy")
ll_deprows = dependancies.retrieve()

// Get the system records
ll_sysrows = dw_systems.retrieve()

for i = 1 to ll_sysrows
	ls_system_id = dw_systems.object.system_id[i]
	ls_system_type = dw_systems.object.system_type[i]
	ls_current_version = dw_systems.object.current_version[i]
	ls_available_version = dw_systems.object.available_version[i]
	f_parse_version(ls_available_version, ls_available_major_release, ls_available_database_version, ls_available_build)
	
	// The database available version comes from the scripts table
	if lower(ls_system_id) = "database" then
		dw_systems.object.current_version[i] = st_release.text + "." + string(sqlca.modification_level)
		ll_db_available_mod_level = long(ls_available_build)
		if ll_db_available_mod_level > sqlca.modification_level then
			dw_systems.object.upgrade_enabled[i] = 1
		else
			dw_systems.object.upgrade_enabled[i] = 0
		end if
	else
		// Set the current_version
		if lower(ls_system_type) = "clientmodule" then
			ls_current_version = clientmodule_current_version(ls_system_id)
			dw_systems.object.current_version[i] = ls_current_version
		end if
		
		// Display the min db mod level
		ls_find = "lower(system_id)='" + lower(ls_system_id) + "'"
		ls_find += " and major_release=" + ls_available_major_release
		ls_find += " and database_version='" + ls_available_database_version + "'"
		ls_find += " and version='" + ls_available_build + "'"
		ll_row = dependancies.find(ls_find, 1, ll_deprows)
		if ll_row > 0 then
			ll_min_level = dependancies.object.min_database_modification_level[ll_row]
			dw_systems.object.db_version_required[i] = string(ll_min_level)
			if ll_min_level <= sqlca.modification_level and ls_available_version <> ls_current_version then
				dw_systems.object.upgrade_enabled[i] = 1
			else
				dw_systems.object.upgrade_enabled[i] = 0
			end if
		else
			dw_systems.object.db_version_required[i] = "Unknown"
			dw_systems.object.upgrade_enabled[i] = 0
		end if
	end if

next

// Save the changes
dw_systems.update()

w_database_main.refresh()


end subroutine

public function integer update_database (long pl_row);string ls_system_id
string ls_system_type
string ls_available_version
integer li_sts
long ll_target_mod_level
string ls_available_major_release
string ls_available_database_version
string ls_available_build
str_popup popup
str_popup_return popup_return
long i
integer li_idx
long ll_last_mod_level

// First make sure we have the latest scripts
li_sts = set_available_versions()

// Then upgrade the database
ls_system_id = dw_systems.object.system_id[pl_row]
ls_system_type = dw_systems.object.system_type[pl_row]
ls_available_version = dw_systems.object.available_version[pl_row]
f_parse_version(ls_available_version, ls_available_major_release, ls_available_database_version, ls_available_build)

ll_target_mod_level = long(ls_available_build)

if ll_target_mod_level - sqlca.modification_level > 1 then
	openwithparm(w_pop_yes_no, "Do you wish to upgrade the database all the way to mod level " + string(ll_target_mod_level) + "?")
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then
		popup.data_row_count = ll_target_mod_level - sqlca.modification_level
		for i = 1 to popup.data_row_count
			popup.items[i] = string(sqlca.modification_level + i)
		next
		popup.title = "Select target mod level"
		openwithparm(w_pop_pick, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return 0
		ll_target_mod_level = sqlca.modification_level + popup_return.item_indexes[1]
	end if
end if

openwithparm(w_pop_yes_no, "Are you sure you wish to upgrade the database to mod level " + string(ll_target_mod_level) + "?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return 0

// First, run the new hotfixes for the current mod level

li_sts = sqlca.run_hotfixes(true)
if li_sts < 0 then
	openwithparm(w_pop_message, "Executing hotfixes failed")
	return -1
end if

DO WHILE sqlca.modification_level < ll_target_mod_level
	ll_last_mod_level = sqlca.modification_level
	li_sts = sqlca.upgrade_database(sqlca.modification_level + 1)
	if ll_last_mod_level = sqlca.modification_level then
		return -1
	end if
LOOP

// Finally, perform a daily sync
li_idx = f_please_wait_open()
sqlca.jmjsys_daily_sync()
if not tf_check() then
	openwithparm(w_pop_message, "The Mod Level Upgrade Succeeded but the automatic Sync Data Failed.")
end if

f_please_wait_close(li_idx)

return 1

end function

public function integer update_clientmodule (long pl_row);string ls_system_id
string ls_system_type
string ls_available_version
string ls_download_url
string ls_installdir
integer li_sts
string ls_user
string ls_pwd

ls_system_id = dw_systems.object.system_id[pl_row]
ls_system_type = dw_systems.object.system_type[pl_row]
ls_available_version = dw_systems.object.available_version[pl_row]

ls_download_url = download_url(ls_system_id, ls_available_version)

ls_installdir = f_default_attachment_path() + "\Install\"
ls_installdir += ls_system_id

//ls_user = datalist.get_preference_d("SYSTEM", "upgrade_ftp_user")
SELECT dbo.fn_get_preference("SYSTEM", "upgrade_ftp_user", NULL, NULL)
INTO :ls_user
FROM c_1_Record;
if not tf_check() then return -1
if isnull(ls_user) then
	log.log(this, "update_clientmodule()", "Error getting user", 4)
	return -1
end if

//ls_pwd = datalist.get_preference_d("SYSTEM", "upgrade_ftp_pwd")
SELECT dbo.fn_get_preference("SYSTEM", "upgrade_ftp_pwd", NULL, NULL)
INTO :ls_pwd
FROM c_1_Record;
if not tf_check() then return -1
if isnull(ls_pwd) then
	log.log(this, "update_clientmodule()", "Error getting pwd", 4)
	return -1
end if

li_sts = common_thread.eprolibnet4.CopyFTPToUNC(ls_download_url, &
																ls_user, &
																ls_pwd, &
																ls_installdir, &
																true)
if li_sts <= 0 then
	log.log(this, "update_clientmodule()", "Error downloading upgrade files from EncounterPRO FTP Site", 4)
	return -1
end if

log.log(this, "update_clientmodule()", "Upgrade Files successfully downloaded", 2)
return 1

end function

public function integer set_available_versions ();long ll_rowcount
long i
string ls_system_id
string ls_system_type
string ls_available_version
integer li_sts
str_popup_return popup_return
blob lbl_script
string ls_script_name = "Sync c_Database_Script"
string ls_script
integer li_please_wait_index

li_please_wait_index = f_please_wait_open()

//////////////////////////////////////////////////////////
// First make sure the c_Database_Scripts table is current
//////////////////////////////////////////////////////////

li_sts = sqlca.bootstrap_database_scripts()
if li_sts <= 0 then
	log.log(this, "set_available_versions()", "Error updating database scripts", 4)
	f_please_wait_close(li_please_wait_index)
	return -1
end if

// Refresh the table
refresh()


//////////////////////////////////////////////////////
// Then refresh each system_id
//////////////////////////////////////////////////////

ll_rowcount = dw_systems.rowcount()

for i = 1 to ll_rowcount
	ls_system_id = dw_systems.object.system_id[i]
	ls_system_type = dw_systems.object.system_type[i]
	
	ls_available_version = sqlca.available_version(ls_system_id)
	
	if len(ls_available_version) > 0 then
		dw_systems.object.available_version[i] = ls_available_version
	else
		dw_systems.object.available_version[i] = "Unknown"
	end if
next

li_sts = dw_systems.update()
if li_sts < 0 then
	f_please_wait_close(li_please_wait_index)
	return -1
end if

UPDATE c_Database_Status
SET last_scripts_update = getdate();
if not tf_check() then
	f_please_wait_close(li_please_wait_index)
	return -1
end if

f_please_wait_close(li_please_wait_index)

return 1

end function

public function integer update_content (long pl_row);string ls_system_id
integer li_sts

ls_system_id = dw_systems.object.system_id[pl_row]

li_sts = sqlca.upgrade_content(ls_system_id)


return li_sts


end function

public function string clientmodule_current_version (string ps_system_id);string ls_current_version
string ls_ini_file
integer li_sts
string ls_user_enc
string ls_pwd_enc
string ls_user
string ls_pwd
string ls_unknown

ls_unknown = "Unknown"

ls_ini_file = f_default_attachment_path() + "\Install\"
ls_ini_file += ps_system_id + "\Setup.ini"

if not fileexists(ls_ini_file) then return ls_unknown

ls_current_version = profilestring(ls_ini_file, "Startup", "ProductVersion", "")

if len(ls_current_version) > 0 then
//	if left(ls_current_version, len(st_release.text) + 1) = st_release.text + "." then
//		ls_current_version = mid(ls_current_version, len(st_release.text) + 2)
//	end if
	return ls_current_version
else
	log.log(this, "clientmodule_current_version()", "Unable to determine current version from ini file", 4)
	return ls_unknown
end if


end function

public function string download_url (string ps_system_id, string ps_version);string ls_download_url
string ls_major_release
string ls_database_version
string ls_build
string ls_null

setnull(ls_null)

f_parse_version(ps_version, ls_major_release, ls_database_version, ls_build)

//ls_download_url = datalist.get_preference("SYSTEM", "upgrade_ftp_site")
SELECT dbo.fn_get_preference("SYSTEM", "upgrade_ftp_site", NULL, NULL)
INTO :ls_download_url
FROM c_1_Record;
if not tf_check() then return ls_null
if isnull(ls_download_url) then ls_download_url = "ftp://ftp.jmjtech.com/EP_Upgrades"
if right(ls_download_url, 1) <> "/" then ls_download_url += "/"

if sqlca.is_dbmode("Testing") then
	ls_download_url += "Testing/"
else
	ls_download_url += "Production/"
end if

ls_download_url += ls_major_release + "." + ls_database_version + "/" + ps_system_id

ls_download_url += "/" + ls_build

return ls_download_url

end function

public function integer redo_database (long pl_row);integer li_sts
str_popup popup
str_popup_return popup_return

// First make sure we have the latest scripts
li_sts = set_available_versions()

// The redo the latest upgrade scripts
li_sts = sqlca.upgrade_database(sqlca.modification_level)

return li_sts


end function

on u_tabpage_dbmaint_updates.create
int iCurrent
call super::create
this.st_release_title=create st_release_title
this.st_release=create st_release
this.pb_1=create pb_1
this.st_16=create st_16
this.st_15=create st_15
this.st_9=create st_9
this.cb_check_now=create cb_check_now
this.st_last_scripts_update=create st_last_scripts_update
this.st_st_last_scripts_update_title=create st_st_last_scripts_update_title
this.st_script_title=create st_script_title
this.dw_systems=create dw_systems
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_release_title
this.Control[iCurrent+2]=this.st_release
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.st_16
this.Control[iCurrent+5]=this.st_15
this.Control[iCurrent+6]=this.st_9
this.Control[iCurrent+7]=this.cb_check_now
this.Control[iCurrent+8]=this.st_last_scripts_update
this.Control[iCurrent+9]=this.st_st_last_scripts_update_title
this.Control[iCurrent+10]=this.st_script_title
this.Control[iCurrent+11]=this.dw_systems
end on

on u_tabpage_dbmaint_updates.destroy
call super::destroy
destroy(this.st_release_title)
destroy(this.st_release)
destroy(this.pb_1)
destroy(this.st_16)
destroy(this.st_15)
destroy(this.st_9)
destroy(this.cb_check_now)
destroy(this.st_last_scripts_update)
destroy(this.st_st_last_scripts_update_title)
destroy(this.st_script_title)
destroy(this.dw_systems)
end on

event constructor;call super::constructor;dependancies = CREATE u_ds_data

end event

type st_release_title from statictext within u_tabpage_dbmaint_updates
integer x = 672
integer y = 136
integer width = 475
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Major Release:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_release from statictext within u_tabpage_dbmaint_updates
integer x = 1166
integer y = 132
integer width = 352
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "4.05"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type pb_1 from u_pb_help_button within u_tabpage_dbmaint_updates
integer x = 2313
integer y = 16
integer width = 247
integer height = 120
integer taborder = 50
end type

type st_16 from statictext within u_tabpage_dbmaint_updates
integer x = 1239
integer y = 232
integer width = 375
integer height = 136
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Available Upgrade"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_15 from statictext within u_tabpage_dbmaint_updates
integer x = 805
integer y = 232
integer width = 338
integer height = 136
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Current Version"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_9 from statictext within u_tabpage_dbmaint_updates
integer x = 1705
integer y = 168
integer width = 357
integer height = 200
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "DB Version Required for Upgrade"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_check_now from commandbutton within u_tabpage_dbmaint_updates
integer x = 1582
integer y = 1400
integer width = 375
integer height = 96
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Check Now"
end type

event clicked;str_popup_return popup_return
integer li_sts
string ls_message

openwithparm(w_pop_yes_no, "Are you sure you want to update the upgrade availability information?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return 0

li_sts = set_available_versions()

if li_sts <= 0 then
	ls_message = "An error occured while checking for upgrades"
	log.log(this, "buttonclicked", ls_message, 4)
	openwithparm(w_pop_message, ls_message)
end if

refresh()


end event

type st_last_scripts_update from statictext within u_tabpage_dbmaint_updates
integer x = 882
integer y = 1416
integer width = 658
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_st_last_scripts_update_title from statictext within u_tabpage_dbmaint_updates
integer x = 101
integer y = 1420
integer width = 763
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Availability Last Checked:"
boolean focusrectangle = false
end type

type st_script_title from statictext within u_tabpage_dbmaint_updates
integer width = 2569
integer height = 112
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "EncounterPRO Upgrade Manager"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_systems from u_dw_pick_list within u_tabpage_dbmaint_updates
integer x = 41
integer y = 364
integer width = 2487
integer height = 1008
integer taborder = 20
string dataobject = "dw_c_database_system"
boolean vscrollbar = true
boolean border = false
end type

event buttonclicked;call super::buttonclicked;string ls_system_type
string ls_system_id
integer li_sts
string ls_message
str_popup_return popup_return

ls_system_type = object.system_type[row]
ls_system_id = object.system_id[row]
li_sts = 0

if isnull(ls_system_type) then
	log.log(this, "buttonclicked", "Null system type", 4)
	return
end if

if isnull(ls_system_id) then
	log.log(this, "buttonclicked", "Null system id", 4)
	return
end if

CHOOSE CASE lower(dwo.name)
	CASE "b_upgrade"
		// Extra protection against people updating the master
		if lower(right(sqlca.database, 6)) = "master" then
			if not f_is_administrator() then
				openwithparm(w_pop_message, "You are not the administrator of this database")
				return
			end if
		end if
		openwithparm(w_pop_yes_no, "Are you sure you want to upgrade the " + lower(ls_system_id) + " system?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return 0
		CHOOSE CASE lower(ls_system_type)
			CASE "content"
				if lower(sqlca.database) = "epro_40_master" then
					openwithparm(w_pop_message, "This database is the source for this system, and as such cannot be upgraded.")
					return
				end if
				li_sts = update_content(row)
			CASE "database"
				if lower(ls_system_id) = "database" then
					li_sts = update_database(row)
				end if
			CASE "clientmodule"
				li_sts = update_clientmodule(row)
			CASE ELSE
				log.log(this, "buttonclicked", "Invalid system type (" + ls_system_type + ")", 4)
				return
		END CHOOSE
	CASE "b_retry"
		// Extra protection against people updating the master
		if lower(right(sqlca.database, 6)) = "master" then
			if not f_is_administrator() then
				openwithparm(w_pop_message, "You are not the administrator of this database")
				return
			end if
		end if
		openwithparm(w_pop_yes_no, "The " + lower(ls_system_id) + " system is already up to date.  Are you sure you want to redo the latest upgrade?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return 0
		CHOOSE CASE lower(ls_system_type)
			CASE "content"
				if lower(sqlca.database) = "epro_40_master" then
					openwithparm(w_pop_message, "This database is the source for this system, and as such cannot be upgraded.")
					return
				end if
				li_sts = update_content(row)
			CASE "database"
				if lower(ls_system_id) = "database" then
					li_sts = redo_database(row)
				end if
			CASE "clientmodule"
				li_sts = update_clientmodule(row)
			CASE ELSE
				log.log(this, "buttonclicked", "Invalid system type (" + ls_system_type + ")", 4)
				return
		END CHOOSE
END CHOOSE


if li_sts < 0 then
	ls_message = "Error updating system (" + ls_system_id + ")"
	log.log(this, "buttonclicked", ls_message, 4)
	openwithparm(w_pop_message, ls_message)
elseif li_sts = 0 then
	ls_message = "Nothing to update for system (" + ls_system_id + ")"
	log.log(this, "buttonclicked", ls_message, 3)
	openwithparm(w_pop_message, ls_message)
else
	ls_message = "Updating system (" + ls_system_id + ") was successful"
	log.log(this, "buttonclicked", ls_message, 2)
	openwithparm(w_pop_message, ls_message)
end if

refresh()


end event

