$PBExportHeader$w_scheduled_service_edit.srw
forward
global type w_scheduled_service_edit from w_window_base
end type
type cb_ok from commandbutton within w_scheduled_service_edit
end type
type st_parent_object_title from statictext within w_scheduled_service_edit
end type
type st_service_title from statictext within w_scheduled_service_edit
end type
type st_last_service_date_title from statictext within w_scheduled_service_edit
end type
type st_last_service_status_title from statictext within w_scheduled_service_edit
end type
type st_status_title from statictext within w_scheduled_service_edit
end type
type cb_configure_service from commandbutton within w_scheduled_service_edit
end type
type rb_interval from radiobutton within w_scheduled_service_edit
end type
type rb_daily from radiobutton within w_scheduled_service_edit
end type
type em_time from editmask within w_scheduled_service_edit
end type
type st_time_amount_title from statictext within w_scheduled_service_edit
end type
type st_time_unit_title from statictext within w_scheduled_service_edit
end type
type st_time_amount from statictext within w_scheduled_service_edit
end type
type st_time_unit from statictext within w_scheduled_service_edit
end type
type st_last_successful_date_title from statictext within w_scheduled_service_edit
end type
type st_parent_object_type_title from statictext within w_scheduled_service_edit
end type
type st_service_description from statictext within w_scheduled_service_edit
end type
type st_status_ok from statictext within w_scheduled_service_edit
end type
type st_parent_object_type from statictext within w_scheduled_service_edit
end type
type st_parent_object_description from statictext within w_scheduled_service_edit
end type
type st_last_service_date from statictext within w_scheduled_service_edit
end type
type st_last_service_status from statictext within w_scheduled_service_edit
end type
type st_last_successful_date from statictext within w_scheduled_service_edit
end type
type st_status_na from statictext within w_scheduled_service_edit
end type
type st_description_title from statictext within w_scheduled_service_edit
end type
type st_description from statictext within w_scheduled_service_edit
end type
type cb_task_history from commandbutton within w_scheduled_service_edit
end type
type st_user_id_title from statictext within w_scheduled_service_edit
end type
type gb_schedule from groupbox within w_scheduled_service_edit
end type
type st_user_full_name from statictext within w_scheduled_service_edit
end type
type st_1 from statictext within w_scheduled_service_edit
end type
type st_running_status_title from statictext within w_scheduled_service_edit
end type
type st_running_status from statictext within w_scheduled_service_edit
end type
type cb_refresh from commandbutton within w_scheduled_service_edit
end type
type cb_run_now from commandbutton within w_scheduled_service_edit
end type
type cb_cancel_service from commandbutton within w_scheduled_service_edit
end type
end forward

global type w_scheduled_service_edit from w_window_base
integer width = 2898
integer height = 1808
string title = "Scheduled Task Properties"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean auto_resize_window = false
boolean auto_resize_objects = false
boolean nested_user_object_resize = false
cb_ok cb_ok
st_parent_object_title st_parent_object_title
st_service_title st_service_title
st_last_service_date_title st_last_service_date_title
st_last_service_status_title st_last_service_status_title
st_status_title st_status_title
cb_configure_service cb_configure_service
rb_interval rb_interval
rb_daily rb_daily
em_time em_time
st_time_amount_title st_time_amount_title
st_time_unit_title st_time_unit_title
st_time_amount st_time_amount
st_time_unit st_time_unit
st_last_successful_date_title st_last_successful_date_title
st_parent_object_type_title st_parent_object_type_title
st_service_description st_service_description
st_status_ok st_status_ok
st_parent_object_type st_parent_object_type
st_parent_object_description st_parent_object_description
st_last_service_date st_last_service_date
st_last_service_status st_last_service_status
st_last_successful_date st_last_successful_date
st_status_na st_status_na
st_description_title st_description_title
st_description st_description
cb_task_history cb_task_history
st_user_id_title st_user_id_title
gb_schedule gb_schedule
st_user_full_name st_user_full_name
st_1 st_1
st_running_status_title st_running_status_title
st_running_status st_running_status
cb_refresh cb_refresh
cb_run_now cb_run_now
cb_cancel_service cb_cancel_service
end type
global w_scheduled_service_edit w_scheduled_service_edit

type variables
long service_sequence

end variables

forward prototypes
public function integer refresh ()
public subroutine change_service ()
public function integer configure_service ()
end prototypes

public function integer refresh ();string ls_user_id
string ls_service
string ls_schedule_type
string ls_schedule_interval
datetime ldt_last_service_date
string ls_last_service_status
datetime ldt_created
string ls_created_by
string ls_status
datetime ldt_last_successful_date
string ls_amount
string ls_unit

SELECT user_id
	,service
	,schedule_type
	,schedule_interval
	,last_service_date
	,last_service_status
	,created
	,created_by
	,status
	,last_successful_date
	,description
	,parent_object_type
	,parent_object_description
	,running_status
INTO :ls_user_id
	,:ls_service
	,:ls_schedule_type
	,:ls_schedule_interval
	,:ldt_last_service_date
	,:ls_last_service_status
	,:ldt_created
	,:ls_created_by
	,:ls_status
	,:ldt_last_successful_date
	,:st_description.text
	,:st_parent_object_type.text
	,:st_parent_object_description.text
	,:st_running_status.text
FROM dbo.fn_scheduled_services()
WHERE service_sequence = :service_sequence;
if not tf_check() then return -1
if sqlca.sqlnrows = 0 then
	log.log(this, "w_scheduled_service_edit.refresh:0046", "Scheduled Service Not Found (" + string(service_sequence) + ")", 4)
	return -1
end if

st_service_description.text = datalist.service_description(ls_service)

st_user_full_name.text = user_list.user_full_name(ls_user_id)

if isnull(st_parent_object_type.text) or st_parent_object_type.text = "" then
	st_parent_object_type.text = "N/A"
end if

if isnull(st_parent_object_description.text) or st_parent_object_description.text = "" then
	st_parent_object_description.text = "N/A"
end if

if isnull(ldt_last_service_date) then
	st_last_service_date.text = "N/A"
	st_last_service_status.text = "N/A"
	st_last_successful_date.text = "N/A"
else
	st_last_service_date.text = string(ldt_last_service_date, "[shortdate]")
	st_last_service_status.text = wordcap(ls_last_service_status)
	if isnull(ldt_last_successful_date) then
		st_last_successful_date.text = "N/A"
	else
		st_last_successful_date.text = string(ldt_last_successful_date)
	end if
end if

CHOOSE CASE lower(ls_schedule_type)
	CASE "daily"
		rb_daily.checked = true
		em_time.enabled = true
		em_time.text = ls_schedule_interval
		st_time_amount.enabled = false
		st_time_unit.enabled = false
		st_time_amount_title.textcolor = rgb(128, 128, 128)
		st_time_unit_title.textcolor = rgb(128, 128, 128)
		st_time_amount.textcolor = rgb(128, 128, 128)
		st_time_unit.textcolor = rgb(128, 128, 128)
	CASE "interval"
		rb_interval.checked = true
		em_time.enabled = false
		st_time_amount.enabled = true
		st_time_unit.enabled = true
		st_time_amount_title.textcolor = color_text_normal
		st_time_unit_title.textcolor = color_text_normal
		st_time_amount.textcolor = color_text_normal
		st_time_unit.textcolor = color_text_normal
		
		f_split_string(ls_schedule_interval, " ", ls_amount, ls_unit)
		if ls_amount = "" or ls_unit = "" then
			// invalid interval so fix immediately
			ls_status = "NA"
			UPDATE o_Service_Schedule
			SET status = :ls_status
			WHERE service_sequence = :service_sequence;
			if not tf_check() then return -1
			
			st_time_amount.text = ""
			st_time_unit.text = ""
		else
			st_time_amount.text = trim(ls_amount)
			st_time_unit.text = wordcap(trim(ls_unit))
			if long(st_time_amount.text) <> 1 and right(st_time_unit.text, 1) <> "s" then
				st_time_unit.text += "s"
			end if
		end if
	CASE "constant"
		rb_interval.checked = true
		em_time.enabled = false
		st_time_amount.enabled = true
		st_time_unit.enabled = true
		st_time_amount_title.textcolor = color_text_normal
		st_time_unit_title.textcolor = color_text_normal
		st_time_amount.textcolor = color_text_normal
		st_time_unit.textcolor = color_text_normal
		
		st_time_amount.text = "5"
		st_time_unit.text = "Seconds"
	CASE ELSE
		// Invalid schedule type so fix it immediatley
		ls_status = "NA"
		ls_schedule_type = "Daily"
		ls_schedule_interval = "00:00"
		UPDATE o_Service_Schedule
		SET status = :ls_status,
				schedule_type = :ls_schedule_type,
				schedule_interval = :ls_schedule_interval
		WHERE service_sequence = :service_sequence;
		if not tf_check() then return -1
		rb_daily.checked = true
		em_time.enabled = true
		em_time.text = ls_schedule_interval
		st_time_amount.enabled = false
		st_time_unit.enabled = false
		st_time_amount_title.textcolor = rgb(128, 128, 128)
		st_time_unit_title.textcolor = rgb(128, 128, 128)
		st_time_amount.textcolor = rgb(128, 128, 128)
		st_time_unit.textcolor = rgb(128, 128, 128)
END CHOOSE

if upper(ls_status) = "OK" then
	st_status_ok.backcolor = color_object_selected
	st_status_na.backcolor = color_object
else
	st_status_ok.backcolor = color_object
	st_status_na.backcolor = color_object_selected
end if

if user_list.is_user_privileged(current_scribe.user_id, "Edit System Config") then
	if lower(st_running_status.text) = "not running" then
		cb_run_now.visible = true
		cb_cancel_service.visible = false
	else
		cb_run_now.visible = false
		cb_cancel_service.visible = true
	end if
else
	cb_run_now.visible = false
	cb_cancel_service.visible = false
end if

return 1


end function

public subroutine change_service ();integer li_sts
string ls_context_object
str_popup			popup
str_popup_return popup_return
string ls_service
string ls_new_service
string ls_new_service_description

SELECT service
INTO :ls_service
FROM o_Service_Schedule
WHERE service_sequence = :service_sequence;
if not tf_check() then return

ls_context_object = "General"

popup.title = "Select Task to Schedule"
popup.dataobject = "dw_sp_compatible_services"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = ls_context_object
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_new_service = popup_return.items[1]
ls_new_service_description = popup_return.descriptions[1]

if isnull(ls_service) or upper(ls_new_service) <> upper(ls_service) then
	openwithparm(w_pop_yes_no, "Are you sure you want to change the scheduled task to " + ls_new_service_description + "?")
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return
	
	UPDATE o_Service_Schedule
	SET service = :ls_new_service,
		description = :ls_new_service_description
	WHERE service_sequence = :service_sequence;
	if not tf_check() then return
	
	DELETE FROM o_Service_Schedule_Attribute
	WHERE service_sequence = :service_sequence;
	if not tf_check() then return
	
	openwithparm(w_pop_yes_no, "Do you wish to configure the new task now?")
	popup_return = message.powerobjectparm
	if popup_return.item = "YES" then
		cb_configure_service.event trigger clicked()
	end if
end if


refresh()

end subroutine

public function integer configure_service ();str_attributes lstr_attributes
integer li_sts
u_ds_data luo_data
integer li_count
integer i
integer li_attribute_sequence
string ls_temp
string ls_id
str_attributes lstr_state_attributes
string ls_param_mode
string ls_service
//string ls_specialty_id
string ls_context_object
string ls_user_id
string ls_parent_object_id
long ll_service_sequence

SELECT service,
		user_id,
		CAST(parent_object_id AS varchar(40))
INTO :ls_service,
		:ls_user_id,
		:ls_parent_object_id
FROM dbo.fn_scheduled_services()
WHERE service_sequence = :service_sequence;
if not tf_check() then return -1

ls_context_object = "General"

ls_param_mode = "Order"

if isnull(ls_service) then
	log.log(this, "w_scheduled_service_edit.configure_service:0033", "Null Service", 4)
	return -1
end if

SELECT CAST(id AS varchar(38))
INTO :ls_id
FROM o_Service
WHERE service = :ls_service;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then
	log.log(this, "w_scheduled_service_edit.configure_service:0043", "Service not found (" + ls_service + ")", 4)
	return -1
end if

if li_sts = 0 and not config_mode and not f_any_params(ls_id, ls_param_mode) then
	openwithparm(w_pop_message, "This service has no ~"" + ls_param_mode + "~" parameters")
	return 0
end if

// Get the existing attributes
luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_service_schedule_attributes")
li_count = luo_data.retrieve(service_sequence)

if li_count < 0 then
	log.log(this, "w_scheduled_service_edit.configure_service:0058", "Error getting attributes", 4)
	return -1
end if

f_attribute_ds_to_str(luo_data, lstr_attributes)

// Add the config object to the state attributes
f_attribute_add_attribute(lstr_state_attributes, "context_object", ls_context_object)
f_attribute_add_attribute(lstr_state_attributes, "parent_config_object_id", ls_parent_object_id)

li_sts = f_get_params_with_state(ls_id, ls_param_mode, lstr_attributes, lstr_state_attributes)
if li_sts < 0 then return -1

// Transfer the attributes back into the datawindow
f_attribute_str_to_ds_with_removal(lstr_attributes, luo_data)

// Make sure each row has the correct specialty_id
for i = 1 to luo_data.rowcount()
	ll_service_sequence = luo_data.object.service_sequence[i]
	if isnull(ll_service_sequence) then
		luo_data.object.service_sequence[i] = service_sequence
		luo_data.object.user_id[i] = ls_user_id
	end if
next

li_sts = luo_data.update()
if li_sts < 0 then return -1

DESTROY luo_data			

return 1


end function

on w_scheduled_service_edit.create
int iCurrent
call super::create
this.cb_ok=create cb_ok
this.st_parent_object_title=create st_parent_object_title
this.st_service_title=create st_service_title
this.st_last_service_date_title=create st_last_service_date_title
this.st_last_service_status_title=create st_last_service_status_title
this.st_status_title=create st_status_title
this.cb_configure_service=create cb_configure_service
this.rb_interval=create rb_interval
this.rb_daily=create rb_daily
this.em_time=create em_time
this.st_time_amount_title=create st_time_amount_title
this.st_time_unit_title=create st_time_unit_title
this.st_time_amount=create st_time_amount
this.st_time_unit=create st_time_unit
this.st_last_successful_date_title=create st_last_successful_date_title
this.st_parent_object_type_title=create st_parent_object_type_title
this.st_service_description=create st_service_description
this.st_status_ok=create st_status_ok
this.st_parent_object_type=create st_parent_object_type
this.st_parent_object_description=create st_parent_object_description
this.st_last_service_date=create st_last_service_date
this.st_last_service_status=create st_last_service_status
this.st_last_successful_date=create st_last_successful_date
this.st_status_na=create st_status_na
this.st_description_title=create st_description_title
this.st_description=create st_description
this.cb_task_history=create cb_task_history
this.st_user_id_title=create st_user_id_title
this.gb_schedule=create gb_schedule
this.st_user_full_name=create st_user_full_name
this.st_1=create st_1
this.st_running_status_title=create st_running_status_title
this.st_running_status=create st_running_status
this.cb_refresh=create cb_refresh
this.cb_run_now=create cb_run_now
this.cb_cancel_service=create cb_cancel_service
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ok
this.Control[iCurrent+2]=this.st_parent_object_title
this.Control[iCurrent+3]=this.st_service_title
this.Control[iCurrent+4]=this.st_last_service_date_title
this.Control[iCurrent+5]=this.st_last_service_status_title
this.Control[iCurrent+6]=this.st_status_title
this.Control[iCurrent+7]=this.cb_configure_service
this.Control[iCurrent+8]=this.rb_interval
this.Control[iCurrent+9]=this.rb_daily
this.Control[iCurrent+10]=this.em_time
this.Control[iCurrent+11]=this.st_time_amount_title
this.Control[iCurrent+12]=this.st_time_unit_title
this.Control[iCurrent+13]=this.st_time_amount
this.Control[iCurrent+14]=this.st_time_unit
this.Control[iCurrent+15]=this.st_last_successful_date_title
this.Control[iCurrent+16]=this.st_parent_object_type_title
this.Control[iCurrent+17]=this.st_service_description
this.Control[iCurrent+18]=this.st_status_ok
this.Control[iCurrent+19]=this.st_parent_object_type
this.Control[iCurrent+20]=this.st_parent_object_description
this.Control[iCurrent+21]=this.st_last_service_date
this.Control[iCurrent+22]=this.st_last_service_status
this.Control[iCurrent+23]=this.st_last_successful_date
this.Control[iCurrent+24]=this.st_status_na
this.Control[iCurrent+25]=this.st_description_title
this.Control[iCurrent+26]=this.st_description
this.Control[iCurrent+27]=this.cb_task_history
this.Control[iCurrent+28]=this.st_user_id_title
this.Control[iCurrent+29]=this.gb_schedule
this.Control[iCurrent+30]=this.st_user_full_name
this.Control[iCurrent+31]=this.st_1
this.Control[iCurrent+32]=this.st_running_status_title
this.Control[iCurrent+33]=this.st_running_status
this.Control[iCurrent+34]=this.cb_refresh
this.Control[iCurrent+35]=this.cb_run_now
this.Control[iCurrent+36]=this.cb_cancel_service
end on

on w_scheduled_service_edit.destroy
call super::destroy
destroy(this.cb_ok)
destroy(this.st_parent_object_title)
destroy(this.st_service_title)
destroy(this.st_last_service_date_title)
destroy(this.st_last_service_status_title)
destroy(this.st_status_title)
destroy(this.cb_configure_service)
destroy(this.rb_interval)
destroy(this.rb_daily)
destroy(this.em_time)
destroy(this.st_time_amount_title)
destroy(this.st_time_unit_title)
destroy(this.st_time_amount)
destroy(this.st_time_unit)
destroy(this.st_last_successful_date_title)
destroy(this.st_parent_object_type_title)
destroy(this.st_service_description)
destroy(this.st_status_ok)
destroy(this.st_parent_object_type)
destroy(this.st_parent_object_description)
destroy(this.st_last_service_date)
destroy(this.st_last_service_status)
destroy(this.st_last_successful_date)
destroy(this.st_status_na)
destroy(this.st_description_title)
destroy(this.st_description)
destroy(this.cb_task_history)
destroy(this.st_user_id_title)
destroy(this.gb_schedule)
destroy(this.st_user_full_name)
destroy(this.st_1)
destroy(this.st_running_status_title)
destroy(this.st_running_status)
destroy(this.cb_refresh)
destroy(this.cb_run_now)
destroy(this.cb_cancel_service)
end on

event open;call super::open;

service_sequence = message.doubleparm
if isnull(service_sequence) or service_sequence <= 0 then
	log.log(this, "w_scheduled_service_edit:open", "Invalid service_sequence", 4)
	close(this)
	return
end if

if refresh() < 0 then
	log.log(this, "w_scheduled_service_edit:open", "Error refreshing screen", 4)
	close(this)
	return
end if

center_popup()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_scheduled_service_edit
integer x = 2830
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_scheduled_service_edit
integer x = 9
integer y = 1676
end type

type cb_ok from commandbutton within w_scheduled_service_edit
integer x = 2395
integer y = 1572
integer width = 402
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;close(parent)

end event

type st_parent_object_title from statictext within w_scheduled_service_edit
integer x = 101
integer y = 556
integer width = 590
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Parent Object"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_service_title from statictext within w_scheduled_service_edit
integer x = 425
integer y = 108
integer width = 265
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Task"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_last_service_date_title from statictext within w_scheduled_service_edit
integer x = 1271
integer y = 884
integer width = 837
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Last Performed"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_last_service_status_title from statictext within w_scheduled_service_edit
integer x = 1271
integer y = 1012
integer width = 837
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Last Completion Status"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_status_title from statictext within w_scheduled_service_edit
integer x = 1746
integer y = 408
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Task Enabled"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_configure_service from commandbutton within w_scheduled_service_edit
integer x = 2162
integer y = 244
integer width = 489
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Configure Task"
end type

event clicked;configure_service()

end event

type rb_interval from radiobutton within w_scheduled_service_edit
integer x = 210
integer y = 1068
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Interval"
end type

event clicked;string ls_schedule_interval

if trim(st_time_amount.text) = "" or isnull(st_time_amount.text) then
	st_time_amount.text = "1"
end if

if trim(st_time_unit.text) = "" or isnull(st_time_unit.text) then
	st_time_unit.text = "Day"
end if

ls_schedule_interval = st_time_unit.text
if right(lower(ls_schedule_interval), 1) = "s" then
	ls_schedule_interval = left(ls_schedule_interval, len(ls_schedule_interval) - 1)
end if

ls_schedule_interval = st_time_amount.text + " " + ls_schedule_interval

UPDATE o_Service_Schedule
SET schedule_type = 'Interval',
	schedule_interval = :ls_schedule_interval
WHERE service_sequence = :service_sequence;
if not tf_check() then return -1

refresh()

end event

type rb_daily from radiobutton within w_scheduled_service_edit
integer x = 210
integer y = 960
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Daily"
end type

event clicked;if trim(em_time.text) = "" or isnull(em_time.text) then
	em_time.text = "00:00"
end if

UPDATE o_Service_Schedule
SET schedule_type = 'Daily',
	schedule_interval = :em_time.text
WHERE service_sequence = :service_sequence;
if not tf_check() then return -1

refresh()

end event

type em_time from editmask within w_scheduled_service_edit
integer x = 672
integer y = 956
integer width = 288
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "00:00"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = timemask!
string mask = "hh:mm"
end type

event modified;if trim(em_time.text) = "" or isnull(em_time.text) then
	em_time.text = "00:00"
end if

UPDATE o_Service_Schedule
SET schedule_type = 'Daily',
	schedule_interval = :em_time.text
WHERE service_sequence = :service_sequence;
if not tf_check() then return -1

refresh()

end event

type st_time_amount_title from statictext within w_scheduled_service_edit
integer x = 215
integer y = 1196
integer width = 393
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Time Amount"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_time_unit_title from statictext within w_scheduled_service_edit
integer x = 293
integer y = 1328
integer width = 315
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Time Unit"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_time_amount from statictext within w_scheduled_service_edit
integer x = 635
integer y = 1184
integer width = 334
integer height = 100
boolean bringtotop = true
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
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string ls_schedule_interval
str_popup popup
str_popup_return popup_return
string ls_unit
long ll_amount

if trim(st_time_unit.text) = "" or isnull(st_time_unit.text) then
	ls_unit = "Day"
else
	ls_unit = st_time_unit.text
	if right(lower(ls_unit), 1) = "s" then
		ls_unit = left(ls_unit, len(ls_unit) - 1)
	end if
end if

if isnumber(st_time_amount.text) then
	ll_amount = long(st_time_amount.text)
else
	setnull(ll_amount)
end if

popup.objectparm = unit_list.find_unit(ls_unit)
popup.realitem = real(ll_amount)
openwithparm(w_number, popup)
popup_return = message.powerobjectparm
if popup_return.item <> "OK" then return

ll_amount = long(popup_return.realitem)
if ll_amount > 0 then
	ls_schedule_interval = string(ll_amount) + " " + ls_unit
	
	UPDATE o_Service_Schedule
	SET schedule_type = 'Interval',
		schedule_interval = :ls_schedule_interval
	WHERE service_sequence = :service_sequence;
	if not tf_check() then return -1
	
	refresh()
end if

end event

type st_time_unit from statictext within w_scheduled_service_edit
integer x = 635
integer y = 1316
integer width = 334
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Minutes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string ls_schedule_interval
str_popup popup
str_popup_return popup_return
string ls_unit
long ll_amount

popup.title = "Select Interal Unit"
popup.data_row_count = 4
popup.items[1] = "Seconds"
popup.items[2] = "Minutes"
popup.items[3] = "Hours"
popup.items[4] = "Days"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_unit = popup_return.items[1]
ls_unit = left(ls_unit, len(ls_unit) - 1)  // we put an "s" on every choice so assume it's there and strip it off

if isnumber(st_time_amount.text) then
	ll_amount = long(st_time_amount.text)
else
	ll_amount = 1
end if

ls_schedule_interval = string(ll_amount) + " " + ls_unit

UPDATE o_Service_Schedule
SET schedule_type = 'Interval',
	schedule_interval = :ls_schedule_interval
WHERE service_sequence = :service_sequence;
if not tf_check() then return -1

refresh()

end event

type st_last_successful_date_title from statictext within w_scheduled_service_edit
integer x = 1271
integer y = 1144
integer width = 837
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Last Successfully Performed"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_parent_object_type_title from statictext within w_scheduled_service_edit
integer x = 101
integer y = 408
integer width = 590
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Parent Object Type"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_service_description from statictext within w_scheduled_service_edit
integer x = 731
integer y = 96
integer width = 1920
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "none"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;change_service()

end event

type st_status_ok from statictext within w_scheduled_service_edit
integer x = 2176
integer y = 392
integer width = 215
integer height = 100
boolean bringtotop = true
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

openwithparm(w_pop_yes_no, "Are you sure you want to enable this scheduled task?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return 1

UPDATE o_Service_Schedule
SET status = 'OK'
WHERE service_sequence = :service_sequence;
if not tf_check() then return -1

refresh()

end event

type st_parent_object_type from statictext within w_scheduled_service_edit
integer x = 731
integer y = 392
integer width = 832
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "none"
boolean border = true
boolean focusrectangle = false
end type

type st_parent_object_description from statictext within w_scheduled_service_edit
integer x = 731
integer y = 540
integer width = 1920
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "none"
boolean border = true
boolean focusrectangle = false
end type

type st_last_service_date from statictext within w_scheduled_service_edit
integer x = 2149
integer y = 864
integer width = 649
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "99/99/9999 99:99:99"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_last_service_status from statictext within w_scheduled_service_edit
integer x = 2149
integer y = 996
integer width = 649
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "none"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_last_successful_date from statictext within w_scheduled_service_edit
integer x = 2149
integer y = 1128
integer width = 649
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "none"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_status_na from statictext within w_scheduled_service_edit
integer x = 2437
integer y = 392
integer width = 215
integer height = 100
boolean bringtotop = true
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

openwithparm(w_pop_yes_no, "Are you sure you want to disable this scheduled task?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return 1

UPDATE o_Service_Schedule
SET status = 'NA'
WHERE service_sequence = :service_sequence;
if not tf_check() then return -1

refresh()

end event

type st_description_title from statictext within w_scheduled_service_edit
integer x = 101
integer y = 704
integer width = 590
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Description"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_description from statictext within w_scheduled_service_edit
integer x = 731
integer y = 688
integer width = 1920
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "none"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.title = "Enter description of this scheduled task"
popup.displaycolumn = 80
popup.item = text
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return


UPDATE o_Service_Schedule
SET description = :popup_return.items[1]
WHERE service_sequence = :service_sequence;
if not tf_check() then return -1

refresh()


end event

type cb_task_history from commandbutton within w_scheduled_service_edit
integer x = 2149
integer y = 1392
integer width = 649
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Task History"
end type

event clicked;w_window_base lw_window

openwithparm(w_window_base, service_sequence, "w_scheduled_service_history")


end event

type st_user_id_title from statictext within w_scheduled_service_edit
integer x = 27
integer y = 260
integer width = 663
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Order for User"
alignment alignment = right!
boolean focusrectangle = false
end type

type gb_schedule from groupbox within w_scheduled_service_edit
integer x = 142
integer y = 852
integer width = 914
integer height = 644
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Schedule"
end type

type st_user_full_name from statictext within w_scheduled_service_edit
integer x = 731
integer y = 244
integer width = 1371
integer height = 100
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_pick_users lstr_pick_users
integer li_sts
string ls_user_id

lstr_pick_users.hide_users = false
lstr_pick_users.allow_roles = true
lstr_pick_users.allow_system_users = true
lstr_pick_users.pick_screen_title = "Select User, Role or System User to Perform Task"

li_sts = user_list.pick_users(lstr_pick_users)
if lstr_pick_users.selected_users.user_count < 1 then return

ls_user_id = lstr_pick_users.selected_users.user[1].user_id

UPDATE o_Service_Schedule
SET user_id = :ls_user_id
WHERE service_sequence = :service_sequence;
if not tf_check() then return -1

refresh()


end event

type st_1 from statictext within w_scheduled_service_edit
integer x = 613
integer y = 1044
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "24-hour format"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_running_status_title from statictext within w_scheduled_service_edit
integer x = 1271
integer y = 1276
integer width = 837
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Current Running Status"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_running_status from statictext within w_scheduled_service_edit
integer x = 2149
integer y = 1260
integer width = 649
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Not Running"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type cb_refresh from commandbutton within w_scheduled_service_edit
integer x = 64
integer y = 1572
integer width = 402
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Refresh"
end type

event clicked;refresh()

end event

type cb_run_now from commandbutton within w_scheduled_service_edit
integer x = 1307
integer y = 1580
integer width = 402
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Run Now"
end type

event clicked;str_popup_return popup_return

openwithparm(w_pop_yes_no, "Are you sure you want to run this scheduled task now?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

sqlca.jmj_run_scheduled_service(service_sequence, current_user.user_id, current_scribe.user_id)
if not tf_check() then return -1

refresh()



end event

type cb_cancel_service from commandbutton within w_scheduled_service_edit
integer x = 1170
integer y = 1580
integer width = 681
integer height = 112
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel Running Task"
end type

event clicked;str_popup_return popup_return
long ll_patient_workplan_item_id
datetime ldt_null

openwithparm(w_pop_yes_no, "Are you sure you want to cancel this running task now?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

SELECT running_patient_workplan_item_id
INTO :ll_patient_workplan_item_id
FROM dbo.fn_scheduled_services()
WHERE service_sequence = :service_sequence;
if not tf_check() then return -1

if isnull(ll_patient_workplan_item_id) then
	openwithparm(w_pop_message, "This scheduled task is no longer running")
else
	sqlca.sp_set_workplan_item_progress(ll_patient_workplan_item_id, current_user.user_id, "Cancelled", ldt_null, current_scribe.user_id, gnv_app.computer_id)
	if not tf_check() then return -1
end if


refresh()



end event

