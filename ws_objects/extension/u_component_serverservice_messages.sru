HA$PBExportHeader$u_component_serverservice_messages.sru
forward
global type u_component_serverservice_messages from u_component_base_class
end type
type str_message_component from structure within u_component_serverservice_messages
end type
end forward

type str_message_component from structure
	string		message_type
	u_component_message_handler		handler
end type

global type u_component_serverservice_messages from u_component_base_class
end type
global u_component_serverservice_messages u_component_serverservice_messages

type variables
//private str_message_component message_types[]
//private integer message_type_count = 0

end variables

forward prototypes
private function u_component_message_handler get_handler (string ps_message_type)
public function integer timer_ding ()
public function integer xx_shutdown ()
protected function integer xx_initialize ()
end prototypes

private function u_component_message_handler get_handler (string ps_message_type);integer i
string ls_handler_component_id
u_component_message_handler luo_handler

setnull(luo_handler)
/*
for i = 1 to message_type_count
	if message_types[i].message_type = ps_message_type then return message_types[i].handler
next
*/
SELECT handler_component_id
INTO :ls_handler_component_id
FROM c_Message_Definition
WHERE message_type = :ps_message_type
USING cprdb;
if not cprdb.check() then return luo_handler
if cprdb.sqlcode = 100 then
	log.log(this, "send_file()", "Message Definition record not found (" + ps_message_type + ")", 4)
	return luo_handler
end if

if isnull(ls_handler_component_id) then
	log.log(this, "send_file()", "Null message handler component for message type (" + ps_message_type + ")", 4)
	return luo_handler
end if

luo_handler = my_component_manager.get_component(ls_handler_component_id)
if isnull(luo_handler) then
	log.log(this, "send_file()", "Error getting message handler component (" + ls_handler_component_id + ")", 4)
	return luo_handler
end if
/*
message_type_count += 1
message_types[message_type_count].message_type = ps_message_type
message_types[message_type_count].handler = luo_handler
*/
return luo_handler

end function

public function integer timer_ding ();integer li_sts
long ll_message_id
string ls_message_type
long ll_subscription_id
long ll_count
integer li_retry_seconds
integer li_retry_limit
datetime ldt_retry
u_ds_data luo_data
u_component_message_handler luo_message_handler

luo_data = CREATE u_ds_data

get_attribute("retry_limit", li_retry_limit)
if isnull(li_retry_limit) then li_retry_limit = 10

get_attribute("retry_seconds", li_retry_seconds)
if isnull(li_retry_seconds) then li_retry_seconds = 300

ldt_retry = datetime(today(), relativetime(now(), -li_retry_seconds))

cprdb.begin_transaction(this, "timer_ding()")
luo_data.set_dataobject("dw_messages_to_handle", cprdb)
ll_count = luo_data.retrieve(ldt_retry, li_retry_limit)
cprdb.commit_transaction()

if ll_count > 0 then
	ll_message_id = luo_data.object.message_id[1]
	ls_message_type = luo_data.object.message_type[1]
	ll_subscription_id = luo_data.object.subscription_id[1]

	mylog.log(this, "timer_ding()", "Retrying message #" + string(ll_message_id), 1)

	luo_message_handler = get_handler(ls_message_type)
	if isnull(luo_message_handler) then
		log.log(this, "timer_ding()", "Error getting message handler component (" + ls_message_type + ")", 4)
		return -1
	end if
	
	li_sts = luo_message_handler.handle_message(ll_message_id)
	if li_sts <= 0 then
		log.log(this, "timer_ding()", "Error handling message (" + string(ll_message_id) + ")", 4)
		return -1
	end if
	
end if

DESTROY luo_data

// If there were more to process, then tell the timer to ding again immediately
if ll_count > 1 then return 2

return 1

end function

public function integer xx_shutdown ();integer i
/*
for i = 1 to message_type_count
	my_component_manager.destroy_component(message_types[i].handler)
next

message_type_count = 0
*/
return 1

end function

protected function integer xx_initialize ();set_timer()
return 1
end function

on u_component_serverservice_messages.create
call super::create
end on

on u_component_serverservice_messages.destroy
call super::destroy
end on

