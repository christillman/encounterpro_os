$PBExportHeader$u_main_tab.sru
forward
global type u_main_tab from tab
end type
type tabpage_waiting from u_waiting_room_status_tab within u_main_tab
end type
type tabpage_waiting from u_waiting_room_status_tab within u_main_tab
end type
type tabpage_checkout from u_checked_out within u_main_tab
end type
type tabpage_checkout from u_checked_out within u_main_tab
end type
type tabpage_charts from u_patient_select within u_main_tab
end type
type tabpage_charts from u_patient_select within u_main_tab
end type
type tabpage_hm from u_tabpage_shell_hm within u_main_tab
end type
type tabpage_hm from u_tabpage_shell_hm within u_main_tab
end type
type tabpage_other_office_services from u_tabpage_other_office_services within u_main_tab
end type
type tabpage_other_office_services from u_tabpage_other_office_services within u_main_tab
end type
type tabpage_messages from u_tabpage_messages within u_main_tab
end type
type tabpage_messages from u_tabpage_messages within u_main_tab
end type
type tabpage_tasks from u_tabpage_shell_todo_lists within u_main_tab
end type
type tabpage_tasks from u_tabpage_shell_todo_lists within u_main_tab
end type
type tabpage_incoming_documents from u_tabpage_shell_incoming_documents within u_main_tab
end type
type tabpage_incoming_documents from u_tabpage_shell_incoming_documents within u_main_tab
end type
type tabpage_documents from u_tabpage_shell_documents within u_main_tab
end type
type tabpage_documents from u_tabpage_shell_documents within u_main_tab
end type
type tabpage_utility from u_tabpage_shell_configure within u_main_tab
end type
type tabpage_utility from u_tabpage_shell_configure within u_main_tab
end type
type tabpage_config from u_tabpage_shell_configure within u_main_tab
end type
type tabpage_config from u_tabpage_shell_configure within u_main_tab
end type
type str_groups from structure within u_main_tab
end type
end forward

type str_groups from structure
	long		group_id
	string		description
	string		persistence_flag
	u_office_status_tab		tab_page
end type

global type u_main_tab from tab
string tag = "CHARTS"
integer width = 2903
integer height = 1736
integer taborder = 1
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean boldselectedtext = true
boolean perpendiculartext = true
tabposition tabposition = tabsonright!
integer selectedtab = 1
tabpage_waiting tabpage_waiting
tabpage_checkout tabpage_checkout
tabpage_charts tabpage_charts
tabpage_hm tabpage_hm
tabpage_other_office_services tabpage_other_office_services
tabpage_messages tabpage_messages
tabpage_tasks tabpage_tasks
tabpage_incoming_documents tabpage_incoming_documents
tabpage_documents tabpage_documents
tabpage_utility tabpage_utility
tabpage_config tabpage_config
event resized ( )
end type
global u_main_tab u_main_tab

type variables
boolean first_one = true

u_main_tabpage_base pages[]
integer page_count = 0

private str_groups groups[]
integer group_count

//u_office_status_tab other_office

string patient_service

boolean patient_tabs_visible = true


end variables

forward prototypes
public function integer open_page (ref userobject puo_object, integer pi_index)
public function integer open_page (ref userobject puo_object, integer pi_index, string ps_label, string ps_tag)
public function integer find_tab (string ps_tag)
public subroutine close_page (integer pi_index)
public subroutine logoff ()
public subroutine set_tab (string ps_tag)
public subroutine logonoff_refresh ()
public subroutine set_tab_room (u_room puo_room)
public subroutine set_tab (long pl_group_id)
public subroutine check_logon ()
public subroutine initialize ()
public subroutine refresh ()
public function integer resize (integer w, integer h)
public subroutine hotkey (keycode pe_key, unsignedlong pul_flags)
public subroutine set_tab_visibility ()
end prototypes

event resized();long i

for i = 1 to page_count
	pages[i].postevent("resized")
next


end event

public function integer open_page (ref userobject puo_object, integer pi_index);integer i
integer li_sts

li_sts = opentab(puo_object, pi_index)
if li_sts <= 0 then return li_sts

if pi_index = 0 or pi_index > page_count then
	pages[page_count + 1] = puo_object
else
	for i = page_count + 1 to pi_index + 1 step -1
		pages[i] = pages[i - 1]
	next
	pages[pi_index] = puo_object
end if

page_count += 1

puo_object.tabbackcolor = color_object

return 1

end function

public function integer open_page (ref userobject puo_object, integer pi_index, string ps_label, string ps_tag);integer i
integer li_sts

li_sts = open_page(puo_object, pi_index)
if li_sts <= 0 then return li_sts

puo_object.text = ps_label
puo_object.tag = ps_tag

return 1

end function

public function integer find_tab (string ps_tag);integer i

for i = 1 to page_count
	if pages[i].tag = ps_tag then return i
next

return 0

end function

public subroutine close_page (integer pi_index);integer i

closetab(pages[pi_index])
for i = pi_index to page_count - 1
	pages[i] = pages[i + 1]
next

page_count -= 1




end subroutine

public subroutine logoff ();

if isnull(current_user) then
	check_logon()
	return
end if

current_user.logoff(false)

f_logon()

end subroutine

public subroutine set_tab (string ps_tag);integer i

for i = 1 to page_count
	if pages[i].tag = ps_tag then
		selecttab(i)
		return
	end if
next


end subroutine

public subroutine logonoff_refresh ();integer li_index
integer i
u_dummy_tab luo_tab

check_logon()

for i = 1 to page_count
	if i = selectedtab then
		CHOOSE CASE pages[i].tag
			CASE "WAITING"
				tabpage_waiting.uo_waiting_rooms.refresh()
			CASE "CHECKOUT"
			CASE "CHARTS"
			CASE "CHECKIN"
			CASE "MESSAGES"
//				tabpage_messages.initialize()
//				tabpage_messages.refresh()
			CASE "CONFIG"
			CASE ELSE
				pages[i].postevent("refresh")
		END CHOOSE
	else
		CHOOSE CASE pages[i].tag
			CASE "WAITING"
			CASE "CHECKOUT"
			CASE "CHARTS"
			CASE "CHECKIN"
			CASE "MESSAGES"
//				tabpage_messages.initialize()
//				tabpage_messages.refresh()
			CASE "CONFIG"
			CASE ELSE
		END CHOOSE
	end if
next

end subroutine

public subroutine set_tab_room (u_room puo_room);integer i
u_room_status_tab luo_room_tab

for i = 1 to page_count
	if pages[i].tag = "ROOM" then
		luo_room_tab = pages[i]
		luo_room_tab.initialize(puo_room.room_id, puo_room.room_name)
		luo_room_tab.visible = true
		selecttab(i)
		return
	end if
next

end subroutine

public subroutine set_tab (long pl_group_id);integer i
u_office_status_tab luo_office

for i = 1 to page_count
	if pages[i].classname() = "u_office_status_tab" then
		luo_office = pages[i]
		if luo_office.group_id = pl_group_id or pl_group_id <= 0 then
			selecttab(i)
			return
		end if
	end if
next


end subroutine

public subroutine check_logon ();integer li_index, li_sts
u_dummy_tab luo_tab

if not isnull(current_scribe) then
	li_sts = current_scribe.check_logon()
	if li_sts = 0 then
		f_set_screen()
		return
	end if
end if

li_index = find_tab("LOGOFF")
if li_index = 0 and not isnull(current_scribe) then
	open_page(luo_tab, 0, "Logoff", "LOGOFF")
elseif li_index > 0 and isnull(current_scribe) then
	close_page(li_index)
end if

w_main.refresh_main()

end subroutine

public subroutine initialize ();integer i
integer j
integer li_sts
integer li_count
u_room_status_tab luo_room_tab
boolean lb_loop
boolean lb_default_group_found
string ls_temp
u_ds_data luo_data
long ll_group_count

luo_data = CREATE u_ds_data

// First initialize the existing pages
page_count = upperbound(control)
for i = 1 to page_count
	pages[i] = control[i]
	pages[i].backcolor = color_background
next

// Close any office tabs
for i = page_count to 1 step -1
	if pages[i].tag = "LOCALOFFICE" or pages[i].tag = "ROOM" then
		closetab(pages[i])
		for j = i to page_count - 1
			pages[j] = pages[j + 1]
		next
		page_count -= 1
	end if
next

// Next, load the group list
lb_loop = true
group_count = 0

luo_data.set_dataobject("dw_o_groups_for_office")
ll_group_count = luo_data.retrieve(gnv_app.office_id)
if ll_group_count < 0 then return

for i = 1 to ll_group_count
	group_count += 1
	groups[group_count].group_id = luo_data.object.group_id[i]
	groups[group_count].description = luo_data.object.description[i]
	groups[group_count].persistence_flag = luo_data.object.persistence_flag[i]
next

// Make sure we have at least one group
if group_count <= 0 then
	log.log(this, "u_main_tab.initialize:0049", "No Groups Found", 5)
	return
end if

lb_default_group_found = false

// Now create a tab page for each room group and initialize it
for i = 1 to group_count
	// Check to see if the default group id is one of the groups displayed
	if groups[i].group_id = default_group_id then lb_default_group_found = true
	
	li_sts = open_page(groups[i].tab_page, i, groups[i].description, "LOCALOFFICE")
	if li_sts <= 0 then
		log.log(this, "u_main_tab.initialize:0062", "Unable to open page", 5)
		return
	end if
	groups[i].tab_page.initialize(groups[i].group_id, groups[i].description, groups[i].description)
next

// Set the default group id
if not lb_default_group_found then default_group_id = groups[1].group_id


//// Now create a tab page for other offices and initialize it
//SELECT count(*)
//INTO :li_count
//FROM c_Office
//WHERE status = 'OK'
//AND server IS NOT NULL
//AND office_id <> :gnv_app.office_id;
//if not tf_check() then return
//
//if li_count >= 1 then
//	li_sts = open_page(other_office, group_count + 1, "Other Offices", "OTHEROFFICE")
//	if li_sts <= 0 then
//		log.log(this, "u_main_tab.initialize:0083", "Unable to open 'Other Offices' page", 5)
//		return
//	end if
//	other_office.initialize()
//end if

// Next, open the generic room tab and make it invisible
open_page(luo_room_tab, 1, "", "ROOM")
//luo_room_tab.visible = false

patient_tabs_visible = datalist.get_preference_boolean( "SECURITY", "Show Patient Tabs If No Clinical Access" , true)

patient_service = datalist.get_preference("PREFERENCES", "patient_data_service")
if isnull(patient_service) then patient_service = "PATIENT_DATA"

ls_temp = datalist.get_preference("PREFERENCES", "show_waiting_room", "True")
if f_string_to_boolean(ls_temp) then
	tabpage_waiting.initialize()
else
	tabpage_waiting.visible = false
end if

tabpage_checkout.initialize()
tabpage_charts.initialize()
tabpage_hm.initialize()
tabpage_incoming_documents.initialize()
tabpage_documents.initialize()
tabpage_messages.initialize()
tabpage_tasks.initialize()
tabpage_other_office_services.initialize()
tabpage_config.initialize()
tabpage_utility.initialize()

visible = true



end subroutine

public subroutine refresh ();integer li_index
integer i
u_dummy_tab luo_tab
time lt_start_loading
time lt_done_loading
decimal ld_loadtime
string ls_user_id

lt_start_loading = now()

check_logon()

set_tab_visibility()

if backcolor <> color_background then
	backcolor = color_background
end if



for i = 1 to page_count
	if i = selectedtab then
		CHOOSE CASE pages[i].tag
			CASE "INCOMING"
				tabpage_incoming_documents.refresh()
			CASE "DOCUMENTS"
				tabpage_documents.refresh()
			CASE "HM"
				tabpage_hm.refresh()
			CASE "WAITING"
				tabpage_waiting.refresh()
			CASE "CHECKOUT"
				tabpage_checkout.refresh()
			CASE "CHARTS"
				tabpage_charts.refresh()
			CASE "CHECKIN"
			CASE "MESSAGES"
				tabpage_messages.refresh()
			CASE "TASKS"
				tabpage_tasks.refresh()
			CASE "UTILITY"
				tabpage_utility.refresh()
			CASE "CONFIG"
				tabpage_config.refresh()
			CASE "OtherOffices"
				tabpage_other_office_services.refresh()
			CASE ELSE
				pages[i].triggerevent("refresh")
		END CHOOSE
	else
		CHOOSE CASE pages[i].tag
			CASE "INCOMING"
				tabpage_incoming_documents.refresh_tab()
			CASE "DOCUMENTS"
				tabpage_documents.refresh_tab()
			CASE "WAITING"
				tabpage_waiting.refresh_tab()
			CASE "CHECKOUT"
				tabpage_checkout.refresh_tab()
			CASE "CHARTS"
			CASE "CHECKIN"
			CASE "MESSAGES"
				tabpage_messages.refresh_tab()
			CASE "TASKS"
				tabpage_tasks.refresh_tabtext()
			CASE "CONFIG"
			CASE "OtherOffices"
				tabpage_other_office_services.refresh_tabtext()
			CASE ELSE
				pages[i].triggerevent("refresh_tab")
		END CHOOSE
	end if
next

common_thread.priority_alert()

lt_done_loading = now()
ld_loadtime = f_time_seconds_after(lt_start_loading, lt_done_loading)
common_thread.log_perflog("Office Refresh Time", ld_loadtime, true)

end subroutine

public function integer resize (integer w, integer h);long i

width = w
height = h

this.event TRIGGER resized()

return 1

end function

public subroutine hotkey (keycode pe_key, unsignedlong pul_flags);integer li_index
integer i
u_dummy_tab luo_tab

for i = 1 to page_count
	if i = selectedtab then
		CHOOSE CASE pages[i].tag
			CASE "WAITING"
			CASE "CHECKOUT"
			CASE "CHARTS"
				tabpage_charts.hotkey(pe_key, pul_flags)
			CASE "CHECKIN"
			CASE "MESSAGES"
			CASE "TODO"
			CASE "CONFIG"
			CASE ELSE
		END CHOOSE
	else
		CHOOSE CASE pages[i].tag
			CASE "WAITING"
			CASE "CHECKOUT"
			CASE "CHARTS"
			CASE "CHECKIN"
			CASE "MESSAGES"
			CASE "TODO"
			CASE "CONFIG"
			CASE ELSE
		END CHOOSE
	end if
next


end subroutine

public subroutine set_tab_visibility ();integer i
u_office_status_tab luo_office
string ls_classname
boolean lb_visible

if isnull(current_user) then
	lb_visible = patient_tabs_visible
else
	if current_user.clinical_access_flag then
		lb_visible = true
	else
		lb_visible = patient_tabs_visible
	end if
end if

for i = 1 to page_count
	ls_classname = lower(pages[i].classname())
	CHOOSE CASE ls_classname
		CASE "u_office_status_tab", "tabpage_charts", "tabpage_checkout", "tabpage_waiting"
			pages[i].visible = lb_visible
		CASE "tabpage_incoming_documents"
			if isnull(current_user) then
				pages[i].visible = false
			else
				pages[i].visible = current_user.show_documents
			end if
		CASE "tabpage_documents"
			if isnull(current_user) then
				pages[i].visible = false
			else
				pages[i].visible = current_user.show_documents
			end if
		CASE "tabpage_hm"
			if isnull(current_user) then
				pages[i].visible = common_thread.show_hm
			else
				pages[i].visible = current_user.show_hm
			end if
	END CHOOSE
next


end subroutine

on u_main_tab.create
this.tabpage_waiting=create tabpage_waiting
this.tabpage_checkout=create tabpage_checkout
this.tabpage_charts=create tabpage_charts
this.tabpage_hm=create tabpage_hm
this.tabpage_other_office_services=create tabpage_other_office_services
this.tabpage_messages=create tabpage_messages
this.tabpage_tasks=create tabpage_tasks
this.tabpage_incoming_documents=create tabpage_incoming_documents
this.tabpage_documents=create tabpage_documents
this.tabpage_utility=create tabpage_utility
this.tabpage_config=create tabpage_config
this.Control[]={this.tabpage_waiting,&
this.tabpage_checkout,&
this.tabpage_charts,&
this.tabpage_hm,&
this.tabpage_other_office_services,&
this.tabpage_messages,&
this.tabpage_tasks,&
this.tabpage_incoming_documents,&
this.tabpage_documents,&
this.tabpage_utility,&
this.tabpage_config}
end on

on u_main_tab.destroy
destroy(this.tabpage_waiting)
destroy(this.tabpage_checkout)
destroy(this.tabpage_charts)
destroy(this.tabpage_hm)
destroy(this.tabpage_other_office_services)
destroy(this.tabpage_messages)
destroy(this.tabpage_tasks)
destroy(this.tabpage_incoming_documents)
destroy(this.tabpage_documents)
destroy(this.tabpage_utility)
destroy(this.tabpage_config)
end on

event selectionchanging;u_tabpage_shell_configure luo_config_tab

if not visible then return 1

// If we register a click on the main tab, we can be certain that
// there isn't any user or service context, so clear it.
f_clear_context()

if isnull(current_user) then return 1

if newindex = 1 then
	if first_one then
		first_one = false
//		return 1
	end if
else
	pages[1].visible = false
end if

if oldindex > 0 then
	CHOOSE CASE pages[oldindex].tag
		CASE "CHARTS"
		CASE "CHECKIN"
		CASE "MESSAGES"
		CASE "CONFIG"
		CASE "LOCALOFFICE"
	END CHOOSE
end if

CHOOSE CASE pages[newindex].tag
	CASE "INCOMING", "DOCUMENTS", "HM", "CHARTS", "MESSAGES", "UTILITY", "REPORTS"
		f_user_logon()
		if isnull(current_user) then return 1
	CASE "TASKS"
		f_user_logon()
		if isnull(current_user) then return 1
		if isnull(tabpage_tasks.user_id) or current_user.user_id <> tabpage_tasks.user_id then
			tabpage_tasks.initialize_user(current_user.user_id)
		end if
	CASE "TODO"
		f_user_logon()
		if isnull(current_user) then return 1
		open(w_todo_main)
		return 1
	CASE "CONFIG"
		f_user_logon()
		if isnull(current_user) then return 1
		
		luo_config_tab = pages[newindex]
		luo_config_tab.reselect_menu()
	CASE "LOGOFF"
		logoff()
		return 1
END CHOOSE

return 0

end event

event selectionchanged;
// Put code here to re-initialize a tab each time it is selected
CHOOSE CASE pages[newindex].tag
	CASE "WAITING"
	CASE "CHECKOUT"
	CASE "CHARTS"
		tabpage_charts.clear()
	CASE "MESSAGES"
	CASE "UTILITY"
	CASE "CONFIG"
END CHOOSE

// Refresh all tabs
refresh()

// Double check to make sure that if we're not showing a room tab then the "viewed_room" global should be null
if pages[newindex].tag <> "ROOM" then setnull(viewed_room)


end event

type tabpage_waiting from u_waiting_room_status_tab within u_main_tab
string tag = "WAITING"
integer x = 18
integer y = 16
integer width = 2391
string text = "Waiting"
long tabbackcolor = 12632256
end type

type tabpage_checkout from u_checked_out within u_main_tab
string tag = "CHECKOUT"
integer x = 18
integer y = 16
integer width = 2391
string text = "Check-Out"
long tabbackcolor = 12632256
end type

type tabpage_charts from u_patient_select within u_main_tab
string tag = "CHARTS"
integer x = 18
integer y = 16
integer width = 2391
integer height = 1704
string text = "Charts"
long tabbackcolor = 12632256
end type

event select_patient;call super::select_patient;integer li_sts
long ll_encounter_id

setnull(ll_encounter_id)

cpr_id = ps_cpr_id

f_user_logon()
if isnull(current_user) then return

li_sts = service_list.do_service(cpr_id, ll_encounter_id, patient_service) 

return


end event

event new_patient;call super::new_patient;this.event trigger select_patient(ps_cpr_id)

end event

type tabpage_hm from u_tabpage_shell_hm within u_main_tab
string tag = "HM"
integer x = 18
integer y = 16
integer width = 2391
integer height = 1704
string text = "Patient Health"
long tabbackcolor = 12632256
end type

type tabpage_other_office_services from u_tabpage_other_office_services within u_main_tab
string tag = "OtherOffices"
integer x = 18
integer y = 16
integer width = 2391
integer height = 1704
string text = "Other Offices"
end type

type tabpage_messages from u_tabpage_messages within u_main_tab
string tag = "MESSAGES"
integer x = 18
integer y = 16
integer width = 2391
integer height = 1704
string text = "Messages"
long tabbackcolor = 12632256
end type

type tabpage_tasks from u_tabpage_shell_todo_lists within u_main_tab
string tag = "TASKS"
integer x = 18
integer y = 16
integer width = 2391
integer height = 1704
string text = "Tasks"
long tabbackcolor = 12632256
end type

type tabpage_incoming_documents from u_tabpage_shell_incoming_documents within u_main_tab
string tag = "INCOMING"
integer x = 18
integer y = 16
integer width = 2391
integer height = 1704
string text = "Inbox"
long tabbackcolor = 12632256
end type

type tabpage_documents from u_tabpage_shell_documents within u_main_tab
string tag = "DOCUMENTS"
integer x = 18
integer y = 16
integer width = 2391
integer height = 1704
string text = "Outgoing Files"
long tabbackcolor = 12632256
end type

type tabpage_utility from u_tabpage_shell_configure within u_main_tab
string tag = "UTILITY"
integer x = 18
integer y = 16
integer width = 2391
integer height = 1704
string text = "Utilities"
long tabbackcolor = 12632256
end type

type tabpage_config from u_tabpage_shell_configure within u_main_tab
string tag = "CONFIG"
integer x = 18
integer y = 16
integer width = 2391
integer height = 1704
string text = "Configuration"
long tabbackcolor = 12632256
end type

