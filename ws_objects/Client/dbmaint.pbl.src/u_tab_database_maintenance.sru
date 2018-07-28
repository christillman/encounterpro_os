$PBExportHeader$u_tab_database_maintenance.sru
forward
global type u_tab_database_maintenance from u_tab_manager
end type
type tabpage_general from u_tabpage_dbmaint_general within u_tab_database_maintenance
end type
type tabpage_general from u_tabpage_dbmaint_general within u_tab_database_maintenance
end type
type tabpage_schedules from u_tabpage_dbmaint_daily_schedules within u_tab_database_maintenance
end type
type tabpage_schedules from u_tabpage_dbmaint_daily_schedules within u_tab_database_maintenance
end type
type tabpage_updates from u_tabpage_dbmaint_updates within u_tab_database_maintenance
end type
type tabpage_updates from u_tabpage_dbmaint_updates within u_tab_database_maintenance
end type
type tabpage_script_log from u_tabpage_dbmaint_script_log within u_tab_database_maintenance
end type
type tabpage_script_log from u_tabpage_dbmaint_script_log within u_tab_database_maintenance
end type
type tabpage_maintenance_log from u_tabpage_dbmaint_maintenance_log within u_tab_database_maintenance
end type
type tabpage_maintenance_log from u_tabpage_dbmaint_maintenance_log within u_tab_database_maintenance
end type
type tabpage_migrate from u_tabpage_dbmaint_migrate24 within u_tab_database_maintenance
end type
type tabpage_migrate from u_tabpage_dbmaint_migrate24 within u_tab_database_maintenance
end type
end forward

global type u_tab_database_maintenance from u_tab_manager
integer width = 2834
integer height = 1268
long backcolor = 33538240
boolean raggedright = false
boolean boldselectedtext = true
boolean createondemand = false
tabpage_general tabpage_general
tabpage_schedules tabpage_schedules
tabpage_updates tabpage_updates
tabpage_script_log tabpage_script_log
tabpage_maintenance_log tabpage_maintenance_log
tabpage_migrate tabpage_migrate
end type
global u_tab_database_maintenance u_tab_database_maintenance

on u_tab_database_maintenance.create
this.tabpage_general=create tabpage_general
this.tabpage_schedules=create tabpage_schedules
this.tabpage_updates=create tabpage_updates
this.tabpage_script_log=create tabpage_script_log
this.tabpage_maintenance_log=create tabpage_maintenance_log
this.tabpage_migrate=create tabpage_migrate
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabpage_general
this.Control[iCurrent+2]=this.tabpage_schedules
this.Control[iCurrent+3]=this.tabpage_updates
this.Control[iCurrent+4]=this.tabpage_script_log
this.Control[iCurrent+5]=this.tabpage_maintenance_log
this.Control[iCurrent+6]=this.tabpage_migrate
end on

on u_tab_database_maintenance.destroy
call super::destroy
destroy(this.tabpage_general)
destroy(this.tabpage_schedules)
destroy(this.tabpage_updates)
destroy(this.tabpage_script_log)
destroy(this.tabpage_maintenance_log)
destroy(this.tabpage_migrate)
end on

type tabpage_general from u_tabpage_dbmaint_general within u_tab_database_maintenance
integer x = 18
integer y = 112
integer width = 2798
integer height = 1140
end type

type tabpage_schedules from u_tabpage_dbmaint_daily_schedules within u_tab_database_maintenance
integer x = 18
integer y = 112
integer width = 2798
integer height = 1140
string text = "Schedules"
end type

type tabpage_updates from u_tabpage_dbmaint_updates within u_tab_database_maintenance
integer x = 18
integer y = 112
integer width = 2798
integer height = 1140
end type

type tabpage_script_log from u_tabpage_dbmaint_script_log within u_tab_database_maintenance
integer x = 18
integer y = 112
integer width = 2798
integer height = 1140
string text = "Script Log"
end type

type tabpage_maintenance_log from u_tabpage_dbmaint_maintenance_log within u_tab_database_maintenance
integer x = 18
integer y = 112
integer width = 2798
integer height = 1140
string text = "Maint Log"
end type

type tabpage_migrate from u_tabpage_dbmaint_migrate24 within u_tab_database_maintenance
integer x = 18
integer y = 112
integer width = 2798
integer height = 1140
string text = "Migrate"
end type

