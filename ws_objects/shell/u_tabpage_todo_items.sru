HA$PBExportHeader$u_tabpage_todo_items.sru
forward
global type u_tabpage_todo_items from u_tabpage
end type
type st_date from statictext within u_tabpage_todo_items
end type
type st_date_title from statictext within u_tabpage_todo_items
end type
type cb_refresh from commandbutton within u_tabpage_todo_items
end type
type st_completed from statictext within u_tabpage_todo_items
end type
type st_pending from statictext within u_tabpage_todo_items
end type
type st_show_title from statictext within u_tabpage_todo_items
end type
type st_sort_by_title from statictext within u_tabpage_todo_items
end type
type pb_pick_date from u_picture_button within u_tabpage_todo_items
end type
type cb_prev_day from commandbutton within u_tabpage_todo_items
end type
type cb_next_day from commandbutton within u_tabpage_todo_items
end type
type cb_today from commandbutton within u_tabpage_todo_items
end type
type cb_service_filter_all from commandbutton within u_tabpage_todo_items
end type
type st_service from statictext within u_tabpage_todo_items
end type
type st_service_title from statictext within u_tabpage_todo_items
end type
type dw_todo_list from u_dw_pick_list within u_tabpage_todo_items
end type
type st_sort_time from statictext within u_tabpage_todo_items
end type
type st_sort_name from statictext within u_tabpage_todo_items
end type
type st_sort_direction from statictext within u_tabpage_todo_items
end type
type cb_new_todo_item from commandbutton within u_tabpage_todo_items
end type
end forward

global type u_tabpage_todo_items from u_tabpage
integer width = 2414
integer height = 1548
long tabbackcolor = 12632256
st_date st_date
st_date_title st_date_title
cb_refresh cb_refresh
st_completed st_completed
st_pending st_pending
st_show_title st_show_title
st_sort_by_title st_sort_by_title
pb_pick_date pb_pick_date
cb_prev_day cb_prev_day
cb_next_day cb_next_day
cb_today cb_today
cb_service_filter_all cb_service_filter_all
st_service st_service
st_service_title st_service_title
dw_todo_list dw_todo_list
st_sort_time st_sort_time
st_sort_name st_sort_name
st_sort_direction st_sort_direction
cb_new_todo_item cb_new_todo_item
end type
global u_tabpage_todo_items u_tabpage_todo_items

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

u_tabpage_todo_lists parent_tabpage

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
end prototypes

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
	log.log(this, "do_todo()", "Service is null for todo item (" + string(ll_patient_workplan_item_id) + ")", 4)
	return
end if

luo_service = service_list.get_service_component(ls_service)
if isnull(luo_service) then
	log.log(this, "do_todo()", "Service not found (" + ls_service + ")", 4)
	return
end if

li_sts = luo_service.do_service(ll_patient_workplan_item_id)

datalist.clear_cache("office_status")

refresh()

end subroutine

public subroutine refresh ();integer li_current_page
long ll_rows
long i, j
string ls_service
boolean lb_found
datetime ldt_begin_date
datetime ldt_end_date
long ll_count

if isnull(current_user) then return

dw_todo_list.setredraw(false)

li_current_page = dw_todo_list.current_page
if isnull(li_current_page) or li_current_page <= 0 then li_current_page = 1

dw_todo_list.settransobject(sqlca)
dw_todo_list.setsort(sort_column + " " + sort_direction)
dw_todo_list.setfilter("")
if active_service_flag = "Y" then
	setnull(ldt_begin_date)
	setnull(ldt_end_date)
else
	ldt_begin_date = datetime(todo_item_date, time("00:00"))
	ldt_end_date = datetime(relativedate(todo_item_date, 1), time("00:00"))
end if
ll_rows = dw_todo_list.retrieve(user_id, todo_office_id, active_service_flag, ldt_begin_date, ldt_end_date)

// Now get a list of the services found and their counts
service_count = 0
for i = 1 to ll_rows
	ls_service = dw_todo_list.object.service[i]
	lb_found = false
	for j = 1 to service_count
		if ls_service = services[j] then
			service_counts[j] += 1
			lb_found = true
			exit
		end if
	next
	if not lb_found then
		service_count += 1
		services[service_count] = ls_service
		service_counts[service_count] = 1
	end if
next

if not isnull(service_filter) then
	dw_todo_list.setfilter("service='" + service_filter + "'")
	dw_todo_list.filter()
	ll_rows = dw_todo_list.rowcount()
end if

parent_tabpage.refresh_tab_counts()

set_text(ll_rows)

// Resize if necessary
if first_time then
	first_time = false
	resize_tabpage()
end if

// Set the controls
st_date.text = string(todo_item_date)
if sort_direction = "A" then
	st_sort_direction.text = "Ascending"
else
	st_sort_direction.text = "Descending"
end if
if active_service_flag = "Y" then
	st_pending.backcolor = color_object_selected
	st_completed.backcolor = color_object
	st_date_title.visible = false
	st_date.visible = false
	cb_next_day.visible = false
	cb_prev_day.visible = false
	cb_today.visible = false
	pb_pick_date.visible = false
else
	st_pending.backcolor = color_object
	st_completed.backcolor = color_object_selected
	st_date_title.visible = true
	st_date.visible = true
	cb_next_day.visible = true
	cb_prev_day.visible = true
	cb_today.visible = true
	pb_pick_date.visible = true
end if
if sort_column = "dispatch_date" then
	st_sort_name.backcolor = color_object
	st_sort_time.backcolor = color_object_selected
else
	st_sort_name.backcolor = color_object_selected
	st_sort_time.backcolor = color_object
end if



dw_todo_list.setredraw(true)

end subroutine

public function integer initialize (string ps_key);integer li_temp
string ls_temp

setnull(cpr_id)

user_id = ps_key

if trim(todo_office_id) = "" then
	setnull(todo_office_id)
end if

if isnull(user_id) or trim(user_id) = "" then
	user_id = current_user.user_id
end if

base_text = text

// Default is to show all pending items
active_service_flag = 'Y'

// See if the service filter is a valid service
ls_temp = datalist.service_description(service_filter)
if isnull(ls_temp) then
	setnull(service_filter)
	st_service.text = "<All Types>"
	cb_service_filter_all.visible = false
else
	st_service.text = ls_temp
	cb_service_filter_all.visible = true
end if

sort_column = "dispatch_date"
sort_direction = "A"
todo_item_date = today()

service_count = 0

dw_todo_list.reset()

return 1

end function

public subroutine resize_tabpage ();long ll_background_width
long ll_rowcount
long ll_lastrowonpage
real lr_x_factor
real lr_y_factor

lr_x_factor = width / 2414
lr_y_factor = height / 1548

f_resize_objects(control, lr_x_factor, lr_y_factor, false, true)

// See if we need to leave room for the scroll bar
ll_rowcount = dw_todo_list.rowcount()
ll_lastrowonpage = long(dw_todo_list.describe("DataWindow.LastRowOnPage"))
if ll_rowcount <= ll_lastrowonpage and dw_todo_list.current_page = 1 then
	ll_background_width = dw_todo_list.width - 20
else
	ll_background_width = dw_todo_list.width - 110
end if
dw_todo_list.modify("t_background.width='" + string(ll_background_width) + "'")
dw_todo_list.modify("patient_name.width='" + string(ll_background_width - 585) + "'")
dw_todo_list.modify("compute_minutes.x='" + string(ll_background_width - 128) + "'")
dw_todo_list.modify("description.width='" + string(ll_background_width - 462) + "'")
dw_todo_list.modify("compute_where.x='" + string(ll_background_width - 452) + "'")
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

on u_tabpage_todo_items.create
int iCurrent
call super::create
this.st_date=create st_date
this.st_date_title=create st_date_title
this.cb_refresh=create cb_refresh
this.st_completed=create st_completed
this.st_pending=create st_pending
this.st_show_title=create st_show_title
this.st_sort_by_title=create st_sort_by_title
this.pb_pick_date=create pb_pick_date
this.cb_prev_day=create cb_prev_day
this.cb_next_day=create cb_next_day
this.cb_today=create cb_today
this.cb_service_filter_all=create cb_service_filter_all
this.st_service=create st_service
this.st_service_title=create st_service_title
this.dw_todo_list=create dw_todo_list
this.st_sort_time=create st_sort_time
this.st_sort_name=create st_sort_name
this.st_sort_direction=create st_sort_direction
this.cb_new_todo_item=create cb_new_todo_item
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_date
this.Control[iCurrent+2]=this.st_date_title
this.Control[iCurrent+3]=this.cb_refresh
this.Control[iCurrent+4]=this.st_completed
this.Control[iCurrent+5]=this.st_pending
this.Control[iCurrent+6]=this.st_show_title
this.Control[iCurrent+7]=this.st_sort_by_title
this.Control[iCurrent+8]=this.pb_pick_date
this.Control[iCurrent+9]=this.cb_prev_day
this.Control[iCurrent+10]=this.cb_next_day
this.Control[iCurrent+11]=this.cb_today
this.Control[iCurrent+12]=this.cb_service_filter_all
this.Control[iCurrent+13]=this.st_service
this.Control[iCurrent+14]=this.st_service_title
this.Control[iCurrent+15]=this.dw_todo_list
this.Control[iCurrent+16]=this.st_sort_time
this.Control[iCurrent+17]=this.st_sort_name
this.Control[iCurrent+18]=this.st_sort_direction
this.Control[iCurrent+19]=this.cb_new_todo_item
end on

on u_tabpage_todo_items.destroy
call super::destroy
destroy(this.st_date)
destroy(this.st_date_title)
destroy(this.cb_refresh)
destroy(this.st_completed)
destroy(this.st_pending)
destroy(this.st_show_title)
destroy(this.st_sort_by_title)
destroy(this.pb_pick_date)
destroy(this.cb_prev_day)
destroy(this.cb_next_day)
destroy(this.cb_today)
destroy(this.cb_service_filter_all)
destroy(this.st_service)
destroy(this.st_service_title)
destroy(this.dw_todo_list)
destroy(this.st_sort_time)
destroy(this.st_sort_name)
destroy(this.st_sort_direction)
destroy(this.cb_new_todo_item)
end on

event constructor;setnull(cpr_id)

end event

type st_date from statictext within u_tabpage_todo_items
integer x = 1902
integer y = 760
integer width = 498
integer height = 96
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "12/12/2002"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_date_title from statictext within u_tabpage_todo_items
integer x = 1902
integer y = 688
integer width = 494
integer height = 68
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Show Date"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_refresh from commandbutton within u_tabpage_todo_items
integer x = 1984
integer y = 1436
integer width = 329
integer height = 104
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Refresh"
end type

event clicked;refresh()

end event

type st_completed from statictext within u_tabpage_todo_items
integer x = 2130
integer y = 136
integer width = 270
integer height = 88
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Completed"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_pending.backcolor = color_object

active_service_flag = 'N'

refresh()


end event

type st_pending from statictext within u_tabpage_todo_items
integer x = 1902
integer y = 136
integer width = 215
integer height = 88
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Pending"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_completed.backcolor = color_object

active_service_flag = 'Y'

refresh()


end event

type st_show_title from statictext within u_tabpage_todo_items
integer x = 1970
integer y = 64
integer width = 343
integer height = 68
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Show"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_sort_by_title from statictext within u_tabpage_todo_items
integer x = 1970
integer y = 312
integer width = 343
integer height = 68
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Sort By"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_pick_date from u_picture_button within u_tabpage_todo_items
integer x = 1902
integer y = 864
integer taborder = 20
boolean originalsize = false
string picturename = "button14.bmp"
string disabledname = "b_push14.bmp"
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.title = "Select Encounter Date"
popup.data_row_count = 1
popup.items[1] = string(todo_item_date, date_format_string)

openwithparm(w_pick_date, popup)
popup_return = message.powerobjectparm

if not isnull(popup_return.item) then
	todo_item_date = date(popup_return.item)
	refresh()
end if

end event

type cb_prev_day from commandbutton within u_tabpage_todo_items
integer x = 2153
integer y = 864
integer width = 119
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "<"
end type

event clicked;todo_item_date = relativedate(todo_item_date, -1)
refresh()

end event

type cb_next_day from commandbutton within u_tabpage_todo_items
integer x = 2281
integer y = 864
integer width = 119
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ">"
end type

event clicked;todo_item_date = relativedate(todo_item_date, 1)
refresh()

end event

type cb_today from commandbutton within u_tabpage_todo_items
integer x = 2171
integer y = 984
integer width = 219
integer height = 96
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Today"
end type

event clicked;todo_item_date = today()
refresh()

end event

type cb_service_filter_all from commandbutton within u_tabpage_todo_items
integer x = 1088
integer y = 1468
integer width = 206
integer height = 72
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "<All>"
end type

event clicked;setnull(service_filter)
st_service.text = "<All Types>"
visible = false

refresh()

end event

type st_service from statictext within u_tabpage_todo_items
event tab_selected ( )
integer x = 206
integer y = 1432
integer width = 878
integer height = 108
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "<All Types >"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
long i

if service_count <= 0 then
	openwithparm(w_pop_message, "There are no services to filter")
	return
end if

for i = 1 to service_count
	popup.items[i] = datalist.service_description(services[i]) + " (" + string(service_counts[i]) + ")"
next
popup.data_row_count = service_count

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

i = popup_return.item_indexes[1]
service_filter = services[i]
text = datalist.service_description(service_filter)
cb_service_filter_all.visible = true
dw_todo_list.current_page = 1

Refresh()


end event

type st_service_title from statictext within u_tabpage_todo_items
integer x = 18
integer y = 1452
integer width = 169
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Type:"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_todo_list from u_dw_pick_list within u_tabpage_todo_items
event post_click ( long clicked_row )
integer x = 9
integer y = 8
integer width = 1824
integer height = 1404
integer taborder = 10
string dataobject = "dw_sp_get_todo_list_30_v2"
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
	parent_tabpage.refresh_tab_counts()
end if

end event

type st_sort_time from statictext within u_tabpage_todo_items
integer x = 1938
integer y = 388
integer width = 201
integer height = 88
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Age"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;
sort_column = "dispatch_date"
if active_service_flag = "Y" then
	sort_direction = "A"
else
	sort_direction = "D"
end if

refresh()


end event

type st_sort_name from statictext within u_tabpage_todo_items
integer x = 2149
integer y = 388
integer width = 201
integer height = 88
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Name"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;
sort_column = "patient_name"
sort_direction = "A"

refresh()


end event

type st_sort_direction from statictext within u_tabpage_todo_items
integer x = 1961
integer y = 488
integer width = 357
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Descending"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if sort_direction = "A" then
	sort_direction = "D"
else
	sort_direction = "A"
end if

refresh()

end event

type cb_new_todo_item from commandbutton within u_tabpage_todo_items
integer x = 1984
integer y = 1208
integer width = 329
integer height = 104
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Item"
end type

event clicked;integer li_sts

li_sts = service_list.do_service(compose_todo_service)
if li_sts <= 0 then return

refresh()

end event

