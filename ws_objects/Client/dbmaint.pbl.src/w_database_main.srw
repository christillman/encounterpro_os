$PBExportHeader$w_database_main.srw
forward
global type w_database_main from w_window_base
end type
type tab_main from u_tab_database_maintenance within w_database_main
end type
type tab_main from u_tab_database_maintenance within w_database_main
end type
end forward

global type w_database_main from w_window_base
integer width = 3237
string title = "EncounterPRO Database Maintenance"
tab_main tab_main
end type
global w_database_main w_database_main

type variables

end variables

forward prototypes
public function integer initialize ()
public function integer refresh ()
end prototypes

public function integer initialize ();string ls_temp
long ll_sts
string ls_message
u_ds_data luo_script_types
u_tabpage_dbmaint_scripts luo_tabpage
u_tabpage_dbmaint_custom_utility luo_utility_tab
long ll_count
long i
string ls_script_type
string ls_maintenance_mode
integer li_count
integer li_sts
boolean lb_db_valid

color_service_ordered = COLOR_LIGHT_YELLOW
COLOR_BACKGROUND = COLOR_EPRO_BLUE
color_text_normal = COLOR_BLACK
color_text_warning = COLOR_LIGHT_YELLOW
color_text_error = COLOR_RED
color_object = COLOR_LIGHT_GREY
color_object_selected = COLOR_DARK_GREY


////logon_id = "sa"
////
////ll_sts = f_initialize_common("EproDBMaint")
////if ll_sts < 0 then
////	log.log(this, "post_open", "Error initializing common", 5)
////	return -1
////end if
//
//if not sqlca.is_dbo then
//	ls_message = "You are not logged in as a DBO in the EncounterPRO database."
//	ls_message += "  Only a DBO may use the Database Maintenance utilities."
//	openwithparm(w_pop_message, ls_message)
//	return -1
//end if
//
//ll_sts = f_initialize_objects()
//if ll_sts < 0 then
//	log.log(this, "post_open", "Error initializing objects", 5)
//	// Don't return an error here because it might be related to not being
//	// upgraded to the latest mod level
//end if


config_mode = true
lb_db_valid = false

SELECT count(*)
INTO :li_count
FROM sysobjects
WHERE type = 'U'
AND name = 'c_Database_Script';
if not tf_check() then return -1

if li_count > 0 then
		lb_db_valid = true
//	// Initialize the objects we skipped during f_initialize_common
//	datalist = CREATE u_list_data
//	component_manager = CREATE u_component_manager
//	component_manager.initialize()
//	
//	// Assume we have system object
//	// Initialize the system objects
//	li_sts = f_initialize_objects()
//	if li_sts > 0 then
//		lb_db_valid = true
//		// Get the preferences
//		f_get_preferences()
//	end if
end if

ll_sts = tab_main.initialize()
if ll_sts < 0 then
	log.log(this, "post_open", "Error initializing tab", 5)
	return -1
end if

if lb_db_valid then	
	luo_script_types = CREATE u_ds_data
	luo_script_types.set_dataobject("dw_c_Database_Script_Type")
	ll_count = luo_script_types.retrieve()
	for i = 1 to ll_count
		ls_script_type = luo_script_types.object.script_type[i]
		ls_maintenance_mode = luo_script_types.object.maintenance_mode[i]
		
		CHOOSE CASE lower(ls_maintenance_mode)
			CASE "userpick"
				luo_tabpage = tab_main.open_page("u_tabpage_dbmaint_scripts", false)
				if isnull(luo_tabpage) then
					openwithparm(w_pop_message, "Error opening scripts tab")
					continue
				end if
				luo_tabpage.initialize(ls_script_type)
		END CHOOSE
	next
	DESTROY luo_script_types

	luo_utility_tab = tab_main.open_page("u_tabpage_dbmaint_custom_utility", false)
	if isnull(luo_tabpage) then
		openwithparm(w_pop_message, "Error opening utility tab")
	else
		luo_utility_tab.text = "Tools"
	end if
else
	tab_main.tabpage_updates.visible = false
	tab_main.tabpage_script_log.visible = false
	tab_main.tabpage_migrate.visible = false
end if



refresh()

return 1

end function

public function integer refresh ();
title = "Epro DB Utility - " + sqlca.servername + "." + sqlca.database
title += " version " + string(sqlca.db_script_major_release)
title += "." + sqlca.db_script_database_version
title += "." + string(sqlca.modification_level)
title += "  (" + sqlca.actual_database_mode
if sqlca.beta_flag then title += " - Beta"
title += ")  "

return 1


end function

on w_database_main.create
int iCurrent
call super::create
this.tab_main=create tab_main
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_main
end on

on w_database_main.destroy
call super::destroy
destroy(this.tab_main)
end on

event open;call super::open;integer li_sts
string ls_database

main_window = this

tab_main.width = width
tab_main.height = height

ls_database = common_thread.default_database
if isnull(ls_database) then ls_database = "<Default>"

title = "EncounterPRO Database Maintenance - " + ls_database

li_sts = initialize()
if li_sts < 0 then
	log.log(this, "post_open", "Error initializing Database Maintenance Window", 5)
	close(this)
	return
end if

end event

event close;call super::close;
HALT CLOSE


end event

type pb_epro_help from w_window_base`pb_epro_help within w_database_main
boolean visible = true
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_database_main
end type

type tab_main from u_tab_database_maintenance within w_database_main
integer width = 2885
integer height = 1356
integer taborder = 20
boolean bringtotop = true
end type

