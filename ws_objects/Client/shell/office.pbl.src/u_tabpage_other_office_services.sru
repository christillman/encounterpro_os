$PBExportHeader$u_tabpage_other_office_services.sru
forward
global type u_tabpage_other_office_services from u_main_tabpage_base
end type
type dw_todo_list from u_dw_pick_list within u_tabpage_other_office_services
end type
end forward

global type u_tabpage_other_office_services from u_main_tabpage_base
integer width = 2450
integer height = 1572
long tabbackcolor = 12632256
event resized ( )
dw_todo_list dw_todo_list
end type
global u_tabpage_other_office_services u_tabpage_other_office_services

type variables
String compose_todo_service = "SENDTODO"
string cpr_id
string sort_direction = "A"
string sort_column = "dispatch_date"
string user_id
string todo_office_id

string service_filter
String active_service_flag

string base_text

long service_count
string services[]
long service_counts[]

date todo_item_date
boolean first_time = true

end variables

forward prototypes
public subroutine set_sort ()
public subroutine do_todo (long pl_row)
public subroutine refresh ()
public function integer initialize (string ps_key)
public subroutine resize_tabpage ()
public subroutine set_text (long pl_count)
public function integer initialize ()
public subroutine refresh_tabtext ()
end prototypes

event resized();resize_tabpage()

end event

public subroutine set_sort ();
end subroutine

public subroutine do_todo (long pl_row);u_component_service luo_service
string ls_user_id
string ls_cpr_id
string ls_service
long ll_patient_workplan_item_id
integer li_sts
string ls_status
string ls_user
u_user luo_user
str_popup_return popup_return

f_user_logon()
If isnull(current_user) Then Return

ls_user_id = dw_todo_list.object.user_id[pl_row]
ll_patient_workplan_item_id = dw_todo_list.object.patient_workplan_item_id[pl_row]
ls_service = dw_todo_list.object.service[pl_row]

if isnull(cpr_id) then
	ls_user_id = current_user.user_id
else
	if ls_user_id <> current_user.user_id then
		luo_user = user_list.find_user(ls_user_id)
		if isnull(luo_user) then
			ls_user = ls_user_id
		else
			ls_user = luo_user.user_full_name
		end if
		openwithparm(w_pop_yes_no, "This To Do Item was ordered for " + ls_user + ".  Do you wish to perform it instead?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return
	end if
end if

if isnull(ls_service) then
	log.log(this, "u_tabpage_other_office_services.do_todo:0036", "Service is null for todo item (" + string(ll_patient_workplan_item_id) + ")", 4)
	return
end if

luo_service = service_list.get_service_component(ls_service)
if isnull(luo_service) then
	log.log(this, "u_tabpage_other_office_services.do_todo:0042", "Service not found (" + ls_service + ")", 4)
	return
end if

li_sts = luo_service.do_service(ll_patient_workplan_item_id)

datalist.clear_cache("office_status")

refresh()

end subroutine

public subroutine refresh ();str_wp_item_list lstr_services
long i
long ll_row
long ll_lastrowonpage
long ll_rowcount
long ll_patient_workplan_item_id
string ls_find
string ls_office_id

if isnull(current_user) then
	if visible then visible = false
	return
end if


lstr_services = datalist.office_other_office_my_services(current_user.user_id)
if lstr_services.wp_item_count > 0 then
	dw_todo_list.setredraw(false)
	dw_todo_list.reset()

	ll_lastrowonpage = long(dw_todo_list.describe("DataWindow.LastRowOnPage"))
	if ll_lastrowonpage > 0 then
		ll_patient_workplan_item_id = dw_todo_list.object.patient_workplan_item_id[ll_lastrowonpage]
	else
		ll_patient_workplan_item_id = 0
	end if
	
	// Loop through the active services and put in a row for each one
	for i = 1 to lstr_services.wp_item_count
		ll_row = dw_todo_list.insertrow(0)
		dw_todo_list.object.user_id[ll_row] = current_user.user_id
		dw_todo_list.object.patient_workplan_item_id[ll_row] = lstr_services.wp_item[i].patient_workplan_item_id
		dw_todo_list.object.service[ll_row] = lstr_services.wp_item[i].ordered_service
		dw_todo_list.object.service_description[ll_row] = lstr_services.wp_item[i].description
//		dw_todo_list.object.service_icon[ll_row] = lstr_services.wp_item[i].service_icon
//		dw_todo_list.object.visible_flag[ll_row] = lstr_services.wp_item[i].visible_flag
//		dw_todo_list.object.in_office_flag[ll_row] = lstr_services.wp_item[i].in_office_flag
		dw_todo_list.object.ordered_by[ll_row] = lstr_services.wp_item[i].ordered_by
		dw_todo_list.object.description[ll_row] = lstr_services.wp_item[i].description
		dw_todo_list.object.dispatch_date[ll_row] = lstr_services.wp_item[i].dispatch_date
		dw_todo_list.object.begin_date[ll_row] = lstr_services.wp_item[i].begin_date
//		dw_todo_list.object.end_date[ll_row] = lstr_services.wp_item[i].end_date
		dw_todo_list.object.status[ll_row] = lstr_services.wp_item[i].status
//		dw_todo_list.object.retries[ll_row] = lstr_services.wp_item[i].retries
		dw_todo_list.object.escalation_date[ll_row] = lstr_services.wp_item[i].escalation_date
		dw_todo_list.object.expiration_date[ll_row] = lstr_services.wp_item[i].expiration_date
		dw_todo_list.object.user_short_name[ll_row] = current_user.user_short_name
		dw_todo_list.object.color[ll_row] = current_user.color
		dw_todo_list.object.dispatch_minutes[ll_row] = f_datetime_diff_seconds(lstr_services.wp_item[i].dispatch_date, datetime(today(), now())) / 60
//		dw_todo_list.object.selected_flag[ll_row] = lstr_services.wp_item[i].selected_flag
		dw_todo_list.object.patient_name[ll_row] = lstr_services.wp_item[i].encounter.patient_name
		if len(lstr_services.wp_item[i].room_id) > 0 then
			dw_todo_list.object.room_name[ll_row] = room_list.room_name(lstr_services.wp_item[i].room_id)
		else
			dw_todo_list.object.room_name[ll_row] = room_list.room_name(lstr_services.wp_item[i].encounter.patient_location)
		end if
		if len(lstr_services.wp_item[i].office_id) > 0 then
			ls_office_id = lstr_services.wp_item[i].office_id
		else
			ls_office_id = lstr_services.wp_item[i].encounter.office_id
		end if
		dw_todo_list.object.office_nickname[ll_row] = datalist.office_field(ls_office_id, "office_nickname")
	next
	
	dw_todo_list.sort()
	
	if ll_patient_workplan_item_id > 0 then
		ll_rowcount = dw_todo_list.rowcount()
		ll_lastrowonpage = long(dw_todo_list.describe("DataWindow.LastRowOnPage"))
		ls_find = "patient_workplan_item_id=" + string(ll_patient_workplan_item_id)
		ll_row = dw_todo_list.find(ls_find, 1, ll_rowcount)
		if ll_row > ll_lastrowonpage then
			dw_todo_list.scroll_to_row(ll_row)
		end if
	end if
	dw_todo_list.setredraw(true)
	
	set_text(lstr_services.wp_item_count)

	if not visible then visible = true
else
	if visible then visible = false
end if

if not visible then main_tab.function POST selecttab(1)


end subroutine

public function integer initialize (string ps_key);//integer li_temp
//string ls_temp
//
//setnull(cpr_id)
//
//user_id = ps_key
//
//if trim(todo_office_id) = "" then
//	setnull(todo_office_id)
//end if
//
//if isnull(user_id) or trim(user_id) = "" then
//	user_id = current_user.user_id
//end if
//
//base_text = text
//
//// Default is to show all pending items
//active_service_flag = 'Y'
//
//// See if the service filter is a valid service
//ls_temp = datalist.service_description(service_filter)
//if isnull(ls_temp) then
//	setnull(service_filter)
//	st_service.text = "<All Types>"
//	cb_service_filter_all.visible = false
//else
//	st_service.text = ls_temp
//	cb_service_filter_all.visible = true
//end if
//
//sort_column = "dispatch_date"
//sort_direction = "A"
//todo_item_date = today()
//
//service_count = 0
//
return 1

end function

public subroutine resize_tabpage ();long ll_background_width
long ll_rowcount
long ll_lastrowonpage
long ll_delta

dw_todo_list.width = width - 100
dw_todo_list.height = height

// See if we need to leave room for the scroll bar
ll_rowcount = dw_todo_list.rowcount()
ll_lastrowonpage = long(dw_todo_list.describe("DataWindow.LastRowOnPage"))
if ll_rowcount <= ll_lastrowonpage and dw_todo_list.current_page = 1 then
	ll_background_width = dw_todo_list.width - 20
else
	ll_background_width = dw_todo_list.width - 110
end if

ll_delta = (ll_background_width - 1989)

dw_todo_list.modify("t_background.width='" + string(ll_background_width) + "'")
dw_todo_list.modify("patient_name.width='" + string(ll_background_width - 585) + "'")
dw_todo_list.modify("compute_minutes.x='" + string(ll_background_width - 128) + "'")
dw_todo_list.modify("description.width='" + string(1499 + (ll_delta/2)) + "'")
dw_todo_list.modify("compute_where.x='" + string(1531 + (ll_delta/2)) + "'")
dw_todo_list.modify("compute_where.width='" +  string(389 + (ll_delta/2)) + "'")
dw_todo_list.modify("retries.x='" + string(ll_background_width - 59) + "'")


end subroutine

public subroutine set_text (long pl_count);if pl_count <= 0 then
	text = base_text
	tabtextcolor = color_text_normal
else
	text = base_text + " (" + string(pl_count) + ")"
	tabtextcolor = color_text_error
end if


end subroutine

public function integer initialize ();string ls_office_id
str_c_office lstra_offices[]
long ll_office_count
string ls_base_text

ls_base_text = ""
ll_office_count = datalist.get_offices(lstra_offices)
if ll_office_count = 2 then
	if lstra_offices[1].office_id = office_id then
		ls_base_text = lstra_offices[2].office_nickname
	else
		ls_base_text = lstra_offices[1].office_nickname
	end if
end if

if len(ls_base_text) > 0 then
	base_text = ls_base_text
else
	base_text = "Other Offices"
end if

resize_tabpage()



return 1

end function

public subroutine refresh_tabtext ();str_wp_item_list lstr_services
long i
integer li_max_priority
string ls_priority_bitmap

if isnull(current_user) then
	if visible then visible = false
else
	lstr_services = datalist.office_other_office_my_services(current_user.user_id)
	if lstr_services.wp_item_count > 0 then
		if not visible then visible = true
		set_text(lstr_services.wp_item_count)
	else
		if visible then visible = false
	end if
end if

// Scan the services for the highest priority
li_max_priority = 0
for i = 1 to lstr_services.wp_item_count
	if lstr_services.wp_item[i].priority > li_max_priority then li_max_priority = lstr_services.wp_item[i].priority
next

common_thread.set_max_priority(li_max_priority)

ls_priority_bitmap = datalist.priority_bitmap(li_max_priority)
if len(ls_priority_bitmap) > 0 then
	if picturename <> ls_priority_bitmap then picturename = ls_priority_bitmap
else
	// Clear out the picture if we couldn't find one
	if picturename <> "" then picturename = ""
end if


end subroutine

on u_tabpage_other_office_services.create
int iCurrent
call super::create
this.dw_todo_list=create dw_todo_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_todo_list
end on

on u_tabpage_other_office_services.destroy
call super::destroy
destroy(this.dw_todo_list)
end on

event constructor;setnull(cpr_id)

end event

type dw_todo_list from u_dw_pick_list within u_tabpage_other_office_services
event post_click ( long clicked_row )
integer width = 2117
integer height = 1396
integer taborder = 10
string dataobject = "dw_other_offices_services_list"
boolean vscrollbar = true
boolean border = false
boolean select_computed = false
end type

event selected;call super::selected;string ls_user_id
long ll_todo_item_id
str_popup popup

// If we register a click on the todo item screen, we can be certain that
// there isn't any user or service context, so clear it.
f_clear_context()

f_user_logon()
if isnull(current_user) then return

do_todo(selected_row)

clear_selected()


end event

event computed_clicked;call super::computed_clicked;long ll_patient_workplan_item_id
string ls_active_service_flag
string ls_owned_by

ll_patient_workplan_item_id = object.patient_workplan_item_id[clicked_row]

f_display_service_menu(ll_patient_workplan_item_id)

// See if we should delete the record
SELECT active_service_flag, owned_by
INTO :ls_active_service_flag, :ls_owned_by
FROM p_Patient_WP_Item
WHERE patient_workplan_item_id = :ll_patient_workplan_item_id;
if not tf_check() then return

if ls_active_service_flag <> active_service_flag or ls_owned_by <> user_id then
	deleterow(clicked_row)
	datalist.clear_cache("office_status")
end if

end event

