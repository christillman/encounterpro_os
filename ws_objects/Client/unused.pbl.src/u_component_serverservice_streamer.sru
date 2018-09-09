$PBExportHeader$u_component_serverservice_streamer.sru
forward
global type u_component_serverservice_streamer from u_component_base_class
end type
end forward

type str_streamer from structure
	string		component_id
	u_component_message_stream		streamer
end type

global type u_component_serverservice_streamer from u_component_base_class
end type
global u_component_serverservice_streamer u_component_serverservice_streamer

type variables
private str_streamer streamers[]
private integer streamer_count = 0

end variables

forward prototypes
public function integer timer_ding ()
public function integer xx_shutdown ()
public function u_component_message_stream get_streamer (string ps_message_type, string ps_stream_id)
end prototypes

public function integer timer_ding ();integer li_sts
long ll_message_id
string ls_message_type
long ll_subscription_id
long ll_count
integer li_retry_seconds
integer li_retry_limit
datetime ldt_retry
string ls_stream_id
u_component_message_stream luo_streamer
u_ds_data luo_data

luo_data = CREATE u_ds_data

get_attribute("retry_limit", li_retry_limit)
if isnull(li_retry_limit) then li_retry_limit = 10

get_attribute("retry_seconds", li_retry_seconds)
if isnull(li_retry_seconds) then li_retry_seconds = 300

ldt_retry = datetime(today(), relativetime(now(), -li_retry_seconds))

cprdb.begin_transaction(this, "timer_ding()")
luo_data.set_dataobject("dw_messages_to_stream", cprdb)
ll_count = luo_data.retrieve(ldt_retry, li_retry_limit)
cprdb.commit_transaction()

if ll_count > 0 then
	ll_message_id = luo_data.object.message_id[1]
	ls_message_type = luo_data.object.message_type[1]
	ls_stream_id = luo_data.object.stream_id[1]

	mylog.log(this, "u_component_serverservice_streamer.timer_ding:0033", "Retrying message #" + string(ll_message_id), 1)

	luo_streamer = get_streamer(ls_message_type, ls_stream_id)
	if isnull(luo_streamer) then
		log.log(this, "u_component_serverservice_streamer.timer_ding:0037", "Error getting transport component (" + string(ll_subscription_id) + ")", 4)
		return -1
	end if
	
	li_sts = luo_streamer.stream_message(ll_message_id)
	if li_sts <= 0 then
		log.log(this, "u_component_serverservice_streamer.timer_ding:0043", "Error sending (" + string(ll_message_id) + ")", 4)
		return -1
	end if
end if

DESTROY luo_data

// If there were more to process, then tell the timer to ding again immediately
if ll_count > 1 then return 2

return 1

end function

public function integer xx_shutdown ();integer i

for i = 1 to streamer_count
	my_component_manager.destroy_component(streamers[i].streamer)
next

streamer_count = 0

return 1

end function

public function u_component_message_stream get_streamer (string ps_message_type, string ps_stream_id);integer i
string ls_component_id
u_component_message_stream luo_streamer

setnull(luo_streamer)

SELECT streamer_component_id
INTO :ls_component_id
FROM c_Message_Stream
WHERE message_type = :ps_message_type
AND stream_id = :ps_stream_id
USING cprdb;
if not cprdb.check() then return luo_streamer
if cprdb.sqlcode = 100 then
	log.log(this, "u_component_serverservice_streamer.get_streamer:0015", "Message Stream record not found (" + ps_message_type + ", " + ps_stream_id + ")", 4)
	return luo_streamer
end if

if isnull(ls_component_id) then
	log.log(this, "u_component_serverservice_streamer.get_streamer:0020", "Null streamer component for message_stream (" + ps_message_type + ", " + ps_stream_id + ")", 4)
	return luo_streamer
end if

// See if we already have it instantiated
for i = 1 to streamer_count
	if streamers[i].component_id = ls_component_id then return streamers[i].streamer
next

// If not, then create a new one
luo_streamer = my_component_manager.get_component(ls_component_id)
if isnull(luo_streamer) then
	log.log(this, "u_component_serverservice_streamer.get_streamer:0032", "Error getting streamer component (" + ls_component_id + ")", 4)
	return luo_streamer
end if

streamer_count += 1
streamers[streamer_count].component_id = ls_component_id
streamers[streamer_count].streamer = luo_streamer

return luo_streamer

end function

on u_component_serverservice_streamer.create
TriggerEvent( this, "constructor" )
end on

on u_component_serverservice_streamer.destroy
TriggerEvent( this, "destructor" )
end on

