$PBExportHeader$u_component_service_wait.sru
forward
global type u_component_service_wait from u_component_service
end type
end forward

global type u_component_service_wait from u_component_service
end type
global u_component_service_wait u_component_service_wait

forward prototypes
public function integer xx_do_service ()
public function boolean check_wait_for ()
public function boolean check_wait_until ()
public function boolean check_progress ()
end prototypes

public function integer xx_do_service ();string ls_event_type
str_popup_return popup_return

ls_event_type = get_attribute("event_type")
if isnull(ls_event_type) then ls_event_type = "Wait For"

CHOOSE CASE upper(ls_event_type)
	CASE "WAIT FOR"
		// Interpret the key as a delta time
		if check_wait_for() then return 1
	CASE "WAIT UNTIL"
		// Interpret the key as a time of day
		if check_wait_for() then return 1
	CASE "PROGRESS"
		if check_progress() then return 1
	CASE ELSE
		// If we don't recognize the event type then log an error and cancel the wait service
		log.log(this, "u_component_service_wait.xx_do_service:0018", "Unrecognized event type (" + ls_event_type + ")", 3)
		return 2
END CHOOSE


// If we get here then the WAIT condition has not been satisfied.  If this is client mode then
// display the user window for this service
if gnv_app.cpr_mode = "CLIENT" then
	Openwithparm(service_window, this, "w_svc_wait", f_active_window())
	if lower(classname(message.powerobjectparm)) = "str_popup_return" then
		popup_return = message.powerobjectparm
	else
		log.log(this, "u_component_service_wait.xx_do_service:0030", "Invalid class returned from service window (" + service + ", " + "w_svc_wait" + ")", 4)
		return -1
	end if
	
	if popup_return.item_count <> 1 then return 0
	
	if (popup_return.items[1] = "COMPLETE") or (popup_return.items[1] = "OK") then
		return 1
	elseif popup_return.items[1] = "CANCEL" then
		return 2
	elseif popup_return.items[1] = "DOLATER" then
		return 3
	elseif popup_return.items[1] = "REVERT" then
		return 4
	elseif popup_return.items[1] = "ERROR" then
		return -1
	else
		return 0
	end if
end if

return 0


end function

public function boolean check_wait_for ();string ls_wait_interval
long ll_seconds
datetime ldt_wait_for_date

ls_wait_interval = get_attribute("wait_interval")
if isnull(ls_wait_interval) then
	if not isnull(treatment) then
		if not isnull(treatment.duration_amount) and not isnull(treatment.duration_unit) then
			ls_wait_interval = string(long(treatment.duration_amount)) + " " + treatment.duration_unit
		end if
	end if
end if

// If we still don't have an interval, then default to one minute
if isnull(ls_wait_interval) then ls_wait_interval = "1 Minute"

ldt_wait_for_date = f_add_datetime_interval(dispatch_date, ls_wait_interval, true)

if ldt_wait_for_date <= datetime(today(), now()) then
	return true
else
	return false
end if

end function

public function boolean check_wait_until ();string ls_wait_interval
long ll_seconds
time lt_wait_until_time
datetime ldt_wait_for_date

ls_wait_interval = get_attribute("wait_until_time")
if isnull(ls_wait_interval) then ls_wait_interval = "00:00"

lt_wait_until_time = time(ls_wait_interval)

if lt_wait_until_time <= now() then
	return true
else
	return false
end if

end function

public function boolean check_progress ();string ls_progress_type
string ls_progress_key
string ls_value

ls_progress_type = get_attribute("wait_progress_type")
if isnull(ls_progress_type) then ls_progress_type = "Event"

ls_progress_key = get_attribute("wait_progress_key")
if isnull(ls_progress_key) then ls_progress_key = "Results Posted"

ls_value = sqlca.fn_patient_object_progress_value(cpr_id, context_object, ls_progress_type, object_key, ls_progress_key)

if len(ls_value) > 0 then
	return true
else
	return false
end if


end function

on u_component_service_wait.create
call super::create
end on

on u_component_service_wait.destroy
call super::destroy
end on

