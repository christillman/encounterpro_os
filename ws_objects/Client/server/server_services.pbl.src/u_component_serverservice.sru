$PBExportHeader$u_component_serverservice.sru
forward
global type u_component_serverservice from u_component_base_class
end type
end forward

global type u_component_serverservice from u_component_base_class
end type
global u_component_serverservice u_component_serverservice

type variables
boolean 	batch_mode
datetime batch_processing_time
string   batch_filter
string   batch_billing_service
end variables

forward prototypes
protected function integer xx_initialize ()
public function integer timer_ding ()
private function integer do_todo_services ()
private function integer do_scheduled_services ()
end prototypes

protected function integer xx_initialize ();integer i,ll_count
string ls_time,ls_temp
string ls_batch[]

// get the services in batch process
batch_billing_service = get_attribute("batch_billing_service")
ls_temp = get_attribute("services_in_batch_mode")
ll_count = f_parse_string(ls_temp,",",ls_batch)
if ll_count <= 0 then
	batch_mode = false
else 
	batch_mode = true
	if upperbound(ls_batch) > 0 then
		batch_filter = "NOT(service = '"+ls_batch[1]+"'"
		For i = 2 to ll_count
			batch_filter += " OR service <> '"+ls_batch[i]+"'"
		Next
		batch_filter += ")"
	else
		batch_mode = false
	end if
end if

// get the batch processing time
ls_time = get_attribute("batch_start_time")
if istime(ls_time) then 
	batch_processing_time = datetime(today(),time(ls_time))
else
	setnull(batch_processing_time)
	batch_mode = false
end if

if batch_mode then
	if time(ls_time) > now() then
		log.log(this, "u_component_serverservice.xx_initialize:0035", "billing is running in batch mode and will start sending only @ "+string(batch_processing_time), 3)
	end if
end if

set_timer()

Return 1

end function

public function integer timer_ding ();integer li_sts1
integer li_sts2


li_sts1 = do_todo_services()
if li_sts1 < 0 then
	log.log(this, "u_component_serverservice.timer_ding:0007", "Error calling do_todo_services()", 4)
end if

li_sts2 = do_scheduled_services()
if li_sts2 < 0 then
	log.log(this, "u_component_serverservice.timer_ding:0012", "Error calling do_todo_services()", 4)
end if

if li_sts1 = 2 then return 2

return 1

end function

private function integer do_todo_services ();string ls_date
integer li_return
string ls_status,ls_logon,ls_null
long ll_count
long ll_completed
long i
u_ds_data luo_data
integer li_sts
long ll_patient_workplan_item_id
integer li_retry_delay_seconds
datetime ldt_not_started_since
datetime ldt_begin_date,ldt_now
boolean lb_batch_ready
string ls_service

ldt_now = datetime(today(),now())
setnull(ls_null)
get_attribute("retry_delay_seconds", li_retry_delay_seconds)
if isnull(li_retry_delay_seconds) then li_retry_delay_seconds = 60

ldt_not_started_since = datetime(today(), relativetime(now(), -li_retry_delay_seconds))

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_todo_list", cprdb)

if isnull(luo_data) or not isvalid(luo_data) then
	log.log(this,"u_component_serverservice.do_todo_services:0027","datastore is null ",3)
	Return 1
end if
if isnull(current_user) or not isvalid(current_user) then
	if server_service_id <= 0 or isnull(server_service_id) then
		log.log(this,"u_component_serverservice.do_todo_services:0032","current user can't be set ",3)
		Return 1
	end if
	SELECT system_user_id
	INTO :ls_logon
	FROM o_server_component
	WHERE service_id = :server_service_id;
	if not tf_check() then return -1
	current_user = user_list.find_user(ls_logon)
end if
if isnull(current_user) or not isvalid(current_user) then
	log.log(this,"u_component_serverservice.do_todo_services:0043","current user object invalid ",3)
	return 1
end if
ll_count = luo_data.retrieve(current_user.user_id, ls_null, "%")

ll_completed = 0

// check if batch mode is enabled
if batch_mode then
	// if the batch processing time is not met
	// then exclude the batch services from processing
	if ldt_now < batch_processing_time then 
		li_return = luo_data.setfilter(batch_filter)
		li_return = luo_data.filter()
		lb_batch_ready = false
	else
		// make sure the batch is not already processed
		f_get_global_preference("last_batch_billing_date",ls_date)
		// dont order the batch service if it's already processed
		If date(ls_date) >= date(today()) then
			mylog.log(this, "u_component_serverservice.do_todo_services:0063", "Billing batch is already sent "+ls_date, 1)	
			lb_batch_ready = false
		else
			lb_batch_ready = true
		end if
	end if
end if

ll_count = luo_data.rowcount()

for i = 1 to ll_count
	ls_service = luo_data.object.service[i]
	ll_patient_workplan_item_id = luo_data.object.patient_workplan_item_id[i]

	// Skip any item which was started too recently, except for the "Wait" service, which should always be attempted
	ldt_begin_date = luo_data.object.begin_date[i]
	if ldt_begin_date > ldt_not_started_since then 
		log.log(this,"u_component_serverservice.do_todo_services:0080","Started recently!! so skipping workplan item id ("+string(ll_patient_workplan_item_id)+")",1)
		continue
	end if
	
	// Since the completion of previous items in the queue might
	// have affected this item, make sure this item is still pending
	SELECT status
	INTO :ls_status
	FROM p_Patient_WP_Item
	WHERE patient_workplan_item_id = :ll_patient_workplan_item_id
	USING cprdb;
	if not cprdb.check() then
		DESTROY luo_data
		return -1
	end if
	
	if upper(ls_status) = "DISPATCHED" or upper(ls_status) = "STARTED" then
		li_sts = service_list.do_service(ll_patient_workplan_item_id)
		if li_sts > 0 then
			ll_completed += 1
		end if
	end if
next

DESTROY luo_data

// if the batch is ready then sent it
// currently used to prepare a batch file for bills
If batch_mode and lb_batch_ready then
	f_get_global_preference("last_batch_billing_date",ls_date)
	// dont order the batch billing service if it's already processed
	If date(ls_date) >= date(today()) then
		mylog.log(this, "u_component_serverservice.do_todo_services:0112", "Billing batch is already sent "+ls_date, 1)	
	Else
		if not isnull(batch_billing_service) then
			li_sts = service_list.do_service(batch_billing_service)
			if li_sts = 1 Then // batch sent successfully 
				f_set_global_preference("PREFERENCES","last_batch_billing_date",string(today(),"mm/dd/yyyy"))
			end if
		end if
	End If
End If

// If we completed at least one service, it might have spawned another service,
// so check again immediately.
if ll_completed > 0 then
	return 2
else
	return 1
end if
end function

private function integer do_scheduled_services ();string ls_status,ls_logon
long ll_count
long i
u_ds_data luo_services
u_ds_data luo_service_attributes
integer li_sts
long ll_service_sequence
str_attributes lstr_attributes
string ls_service
long ll_attribute_count

luo_services = CREATE u_ds_data
luo_services.set_dataobject("dw_sp_scheduled_services", cprdb)
luo_service_attributes = CREATE u_ds_data
luo_service_attributes.set_dataobject("dw_o_Service_Schedule_Attribute", cprdb)

if isnull(current_user) or not isvalid(current_user) then
	if server_service_id <= 0 or isnull(server_service_id) then
		log.log(this,"u_component_serverservice.do_scheduled_services:0019","current user can't be set ",3)
		Return 1
	end if
	SELECT system_user_id
	INTO :ls_logon
	FROM o_server_component
	WHERE service_id = :server_service_id;
	if not tf_check() then return -1
	current_user = user_list.find_user(ls_logon)
end if

if isnull(current_user) or not isvalid(current_user) then
	log.log(this,"u_component_serverservice.do_scheduled_services:0031","current user object invalid ",3)
	return 1
end if

ll_count = luo_services.retrieve(current_user.user_id, gnv_app.office_id)
if ll_count < 0 then
	log.log(this,"u_component_serverservice.do_scheduled_services:0037","error getting scheduled services",3)
	return -1
end if

for i = 1 to ll_count
	ls_service = luo_services.object.service[i]
	ll_service_sequence = luo_services.object.service_sequence[i]
	
	// Get the attributes
	ll_attribute_count = luo_service_attributes.retrieve(current_user.user_id, ll_service_sequence)
	if ll_attribute_count < 0 then
		log.log(this,"u_component_serverservice.do_scheduled_services:0048","error getting service attributes (" + current_user.user_id + ", " + string(ll_service_sequence) + ")",4)
		return -1
	end if
	lstr_attributes.attribute_count = 0
	f_attribute_ds_to_str(luo_service_attributes, lstr_attributes)

	// Execute the service
	li_sts = service_list.do_service(ls_service, lstr_attributes)
	if li_sts < 0 then
		ls_status = "ERROR"
	else
		ls_status = "COMPLETED"
	end if
	UPDATE o_Service_Schedule
	SET last_service_date = getdate(),
		last_service_status = :ls_status
	WHERE user_id = :current_user.user_id
	AND service_sequence = :ll_service_sequence;
	if not cprdb.check() then return -1
next

DESTROY luo_services
DESTROY luo_service_attributes

return 1

end function

on u_component_serverservice.create
call super::create
end on

on u_component_serverservice.destroy
call super::destroy
end on

