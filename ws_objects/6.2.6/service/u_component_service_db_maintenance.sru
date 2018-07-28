HA$PBExportHeader$u_component_service_db_maintenance.sru
forward
global type u_component_service_db_maintenance from u_component_service
end type
end forward

global type u_component_service_db_maintenance from u_component_service
end type
global u_component_service_db_maintenance u_component_service_db_maintenance

type variables

end variables

forward prototypes
public function integer xx_do_service ()
private function integer sync_database_scripts ()
private function integer sync_content ()
private function integer run_hotfixes ()
private function integer run_maintenance_frequent ()
private function integer run_maintenance_infrequent ()
end prototypes

public function integer xx_do_service ();boolean lb_sync_database_scripts
boolean lb_sync_content
boolean lb_run_hotfixes
boolean lb_maintenance_frequent
boolean lb_maintenance_infrequent
integer li_sts

mydb = CREATE u_sqlca
mydb.connect_approle = false
li_sts = mydb.dbconnect("EproDBMaintenance")
if li_sts <= 0 then
	log.log(this, "xx_do_service()", "Error Connecting to Database", 4)
	return -1
end if


// Make Sure we're a DBO
if not mydb.is_dbo then
	log.log(this, "xx_do_service()", "This user is not connected as a DBO (" + logon_id + ")", 4)
	mydb.dbdisconnect()
	return -1
end if	

// Decide which maintenance actions to run
get_attribute("Sync Database Scripts", lb_sync_database_scripts, true)
get_attribute("Sync Content", lb_sync_content, false)
get_attribute("Run New Hotfixes", lb_run_hotfixes, false)
get_attribute("Daily Maintenance", lb_maintenance_frequent, false)
get_attribute("Weekly Maintenance", lb_maintenance_infrequent, false)

if lb_sync_database_scripts then
	li_sts = sync_database_scripts()
	if li_sts <= 0 then
		log.log(this, "xx_do_service()", "Error syncing database scripts", 4)
		// Abort if the db scripts sync fails
		mydb.dbdisconnect()
		return -1
	end if
end if

if lb_sync_content then
	li_sts = sync_content()
	if li_sts <= 0 then
		log.log(this, "xx_do_service()", "Error syncing content", 4)
	end if
end if

if lb_run_hotfixes then
	li_sts = run_hotfixes()
	if li_sts <= 0 then
		log.log(this, "xx_do_service()", "Error running hotfixes", 4)
	end if
end if

if lb_maintenance_frequent then
	li_sts = run_maintenance_frequent()
	if li_sts <= 0 then
		log.log(this, "xx_do_service()", "Error running hotfixes", 4)
	end if
end if

if lb_maintenance_infrequent then
	li_sts = run_maintenance_infrequent()
	if li_sts <= 0 then
		log.log(this, "xx_do_service()", "Error running hotfixes", 4)
	end if
end if

mydb.dbdisconnect()

return 1

end function

private function integer sync_database_scripts ();integer li_sts

li_sts = mydb.bootstrap_database_scripts()
if li_sts <= 0 then
	log.log(this, "set_available_versions()", "Error updating database scripts", 4)
	return -1
end if

return 1

end function

private function integer sync_content ();integer li_sts

mydb.jmjsys_daily_sync()
if not mydb.check() then
	log.log(this, "sync_content()", "Error syncing content", 4)
	return -1
end if

return 1

end function

private function integer run_hotfixes ();integer li_sts

li_sts = mydb.run_hotfixes(true)
if li_sts <= 0 then
	log.log(this, "set_available_versions()", "Error running hotfixes", 4)
	return -1
end if

return 1

end function

private function integer run_maintenance_frequent ();integer li_sts
integer li_encounter_started_days
integer li_encounter_not_started_days

get_attribute("encounter_started_days", li_encounter_started_days)
if isnull(li_encounter_started_days) then
	li_encounter_started_days = 0
end if

get_attribute("encounter_not_started_days", li_encounter_not_started_days)
if isnull(li_encounter_not_started_days) then
	li_encounter_not_started_days = 1
end if

mydb.sp_maintenance_frequent(li_encounter_started_days, li_encounter_not_started_days, current_user.user_id, current_scribe.user_id)
if not mydb.check() then
	log.log(this, "sync_content()", "Error running sp_maintenance_frequent", 4)
	return -1
end if

return 1

end function

private function integer run_maintenance_infrequent ();integer li_sts

mydb.sp_maintenance_infrequent()
if not mydb.check() then
	log.log(this, "sync_content()", "Error running sp_maintenance_frequent", 4)
	return -1
end if

return 1

end function

on u_component_service_db_maintenance.create
call super::create
end on

on u_component_service_db_maintenance.destroy
call super::destroy
end on

