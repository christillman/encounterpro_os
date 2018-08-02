$PBExportHeader$w_epie_gateway.srw
forward
global type w_epie_gateway from window
end type
end forward

global type w_epie_gateway from window
boolean visible = false
integer width = 2057
integer height = 1376
boolean titlebar = true
string title = "EpIE Gateway"
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
end type
global w_epie_gateway w_epie_gateway

type variables
long timer_interval
long server_service_id


time DailyMaintenanceTime
datetime last_DailyMaintenance
end variables

forward prototypes
public function integer do_epiedownload ()
public function integer do_dailymaintenance ()
end prototypes

public function integer do_epiedownload ();str_service_info lstr_service
integer li_sts

lstr_service.service = "EXTERNAL_SOURCE"
f_attribute_add_attribute(lstr_service.attributes, "external_source", "EpIE")
f_attribute_add_attribute(lstr_service.attributes, "xml_action", "process or attach")


li_sts = service_list.do_service(lstr_service)

return li_sts

end function

public function integer do_dailymaintenance ();


return 1

end function

on w_epie_gateway.create
end on

on w_epie_gateway.destroy
end on

event timer;integer li_sts
date ld_1
time lt_1
string ls_error

TRY
	// turn off the timer
	timer(0)
	
	// log this iteration
	if not isnull(server_service_id) then
		UPDATE o_Server_Component
		SET last_run = getdate(),
			last_spid = :sqlca.spid
		WHERE service_id = :server_service_id;
		if not sqlca.check() then return
	end if
	
	// perform the necessary stuff
	
	// See if we need to do some housekeeping
	if now() > DailyMaintenanceTime and date(last_dailymaintenance) < today() then
		li_sts = do_dailymaintenance()
		if li_sts <= 0 then
			log.log(this, "w_epie_gateway.timer.0025", "Error doing daily maintenance", 4)
		end if
	end if
	
	// Get the EpIE data
	li_sts = do_epiedownload()
	if li_sts <= 0 then
		log.log(this, "w_epie_gateway.timer.0025", "Error doing epie download", 4)
	end if
CATCH (throwable lo_error)
	ls_error = "Error in timer_ding function"
	if not isnull(lo_error.text) then
		ls_error += " (" + lo_error.text + ")"
	end if
	log.log(this, "w_epie_gateway.timer.0025", ls_error, 4)
	li_sts = -1
FINALLY
	// If timer_ding() returns the special value 2, then don't restart the time
	// but instead post another timer event immediately
	if li_sts = 2 then
		THIS.event POST timer()
	else
		timer(timer_interval)
	end if
	
END TRY


end event

event open;string ls_dailymaintenancetime

if message.doubleparm > 0 then
	server_service_id = message.doubleparm
else
	setnull(server_service_id)
end if

ls_dailymaintenancetime = datalist.get_preference("EpIE", "EpIE DailyMaintenance Time")
if istime(ls_dailymaintenancetime) then
	dailymaintenancetime = time(ls_dailymaintenancetime)
else
	dailymaintenancetime = time("02:00")
end if

timer_interval = datalist.get_preference_int("EpIE", "EpIE Download Polling Interval", 10)

timer(timer_interval)

end event

