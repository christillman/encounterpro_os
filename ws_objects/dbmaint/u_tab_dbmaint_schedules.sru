HA$PBExportHeader$u_tab_dbmaint_schedules.sru
forward
global type u_tab_dbmaint_schedules from u_tab_manager
end type
end forward

global type u_tab_dbmaint_schedules from u_tab_manager
boolean createondemand = false
end type
global u_tab_dbmaint_schedules u_tab_dbmaint_schedules

type variables
string maintenance_service = "Database Maintenance"

end variables

forward prototypes
public subroutine new_schedule ()
public subroutine delete_schedule ()
public function integer initialize ()
end prototypes

public subroutine new_schedule ();long ll_service_sequence
u_tabpage_dbmaint_schedule luo_tabpage

ll_service_sequence = sqlca.jmj_new_maintenance_schedule("#MAINTENANCE", "Database Maintenance", "Daily", "03:00", current_scribe.user_id)
if not tf_check() then return

if ll_service_sequence <= 0 then
	log.log(this, "new_schedule()", "Error creating new schedule", 4)
	return
end if

// Open new tabpage
luo_tabpage = open_page("u_tabpage_dbmaint_schedule", false)
if not isnull(luo_tabpage) then
	luo_tabpage.service_sequence = ll_service_sequence
	luo_tabpage.initialize()
end if

return

end subroutine

public subroutine delete_schedule ();long ll_service_sequence
u_tabpage_dbmaint_schedule luo_tabpage
str_popup_return popup_return

openwithparm(w_pop_yes_no, "Are you sure you want to delete this scheduled maintenance?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

// delete the currently displayed schedule
if this.selectedtab > 0 then
	luo_tabpage = pages[this.selectedtab]
	ll_service_sequence = luo_tabpage.service_sequence
	
	DELETE
	FROM o_Service_Schedule_Attribute
	WHERE service_sequence = :ll_service_sequence;
	if not tf_check() then return
	
	DELETE
	FROM o_Service_Schedule
	WHERE service_sequence = :ll_service_sequence;
	if not tf_check() then return
	
	initialize()
end if


return


end subroutine

public function integer initialize ();long ll_count
u_ds_data luo_data
long i
long ll_service_sequence
u_tabpage_dbmaint_schedule luo_tabpage

close_pages()

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_maintenance_schedule")
ll_count = luo_data.retrieve(maintenance_service)

for i = 1 to ll_count
	ll_service_sequence = luo_data.object.service_sequence[i]
	
	// Open new tabpage
	luo_tabpage = open_page("u_tabpage_dbmaint_schedule", false)
	if not isnull(luo_tabpage) then
		luo_tabpage.service_sequence = ll_service_sequence
		luo_tabpage.initialize()
	end if
next

DESTROY luo_data

selecttab(1)

return 1

end function

