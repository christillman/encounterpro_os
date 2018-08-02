$PBExportHeader$u_component_serverservice_outgoing.sru
forward
global type u_component_serverservice_outgoing from u_component_base_class
end type
type str_subscription_component from structure within u_component_serverservice_outgoing
end type
end forward

type str_subscription_component from structure
	long		subscription_id
	u_component_outgoing		outgoing_transport
end type

global type u_component_serverservice_outgoing from u_component_base_class
end type
global u_component_serverservice_outgoing u_component_serverservice_outgoing

type variables
private str_subscription_component subscription_components[]
private integer subscription_component_count = 0

end variables

forward prototypes
public function u_component_outgoing get_transport (long pl_subscription_id)
public function integer xx_shutdown ()
protected function integer xx_initialize ()
public function integer timer_ding ()
end prototypes

public function u_component_outgoing get_transport (long pl_subscription_id);integer i
string ls_transport_component_id
u_component_outgoing luo_outgoing

setnull(luo_outgoing)

for i = 1 to subscription_component_count
	if subscription_components[i].subscription_id = pl_subscription_id then return subscription_components[i].outgoing_transport
next

SELECT transport_component_id
INTO :ls_transport_component_id
FROM o_Message_Subscription
WHERE subscription_id = :pl_subscription_id
USING cprdb;
if not cprdb.check() then return luo_outgoing
if cprdb.sqlcode = 100 then
	log.log(this, "u_component_serverservice_outgoing.get_transport.0018", "Message subscription record not found (" + string(pl_subscription_id) + ")", 4)
	return luo_outgoing
end if

if isnull(ls_transport_component_id) then
	log.log(this, "u_component_serverservice_outgoing.get_transport.0018", "Null transport component for subscription (" + string(pl_subscription_id) + ")", 4)
	return luo_outgoing
end if

luo_outgoing = my_component_manager.get_component(ls_transport_component_id)
if isnull(luo_outgoing) then
	log.log(this, "u_component_serverservice_outgoing.get_transport.0018", "Error getting transport component (" + ls_transport_component_id + ")", 4)
	return luo_outgoing
end if

subscription_component_count += 1
subscription_components[subscription_component_count].subscription_id = pl_subscription_id
subscription_components[subscription_component_count].outgoing_transport = luo_outgoing

Return luo_outgoing

end function

public function integer xx_shutdown ();integer i

for i = 1 to subscription_component_count
	my_component_manager.destroy_component(subscription_components[i].outgoing_transport)
next

subscription_component_count = 0
GarbageCollectSetTimeLimit(0)
GarbageCollect()

return 1

end function

protected function integer xx_initialize ();set_timer()

Return 1
end function

public function integer timer_ding ();integer	li_sts,li_rtn
long		ll_count,ll_message_id,ll_subscription_id
String	ls_message_type

u_ds_data					luo_data
u_component_outgoing		luo_transport

luo_data = CREATE u_ds_data

luo_data.set_dataobject("dw_messages_to_send", cprdb)
ll_count = luo_data.retrieve()

If ll_count > 0 Then
		log.log(this,"u_component_serverservice_outgoing.timer_ding.0014","sending charges begin ",1)

		ll_message_id = luo_data.object.message_id[1]
		ls_message_type = luo_data.object.message_type[1]
		ll_subscription_id = luo_data.object.subscription_id[1]

		log.log(this, "u_component_serverservice_outgoing.timer_ding.0020", "Retrying message #" + string(ll_message_id), 1)
		
		luo_transport = get_transport(ll_subscription_id)
		if isnull(luo_transport) then
			log.log(this, "u_component_serverservice_outgoing.timer_ding.0020", "Error getting transport component (" + string(ll_subscription_id) + ")", 4)
			return -1
		end if
	
		li_sts = luo_transport.send_file(ll_message_id)
		if li_sts <= 0 then
			log.log(this, "u_component_serverservice_outgoing.timer_ding.0020", "Error sending (" + string(ll_message_id) + ")", 4)
			return -1
		end if
		 // if synchronized (wait for ACK before sending next msg)
		if li_sts = 2 then
			li_rtn = 1 // ding with interval
		else
			if ll_count > 1 Then li_rtn = 2 Else li_rtn = 1
		end if
Else
		li_rtn = 1 // Timer to Ding with interval
End If

DESTROY luo_data
GarbageCollectSetTimeLimit(0)
GarbageCollect()

Return li_rtn
end function

on u_component_serverservice_outgoing.create
call super::create
end on

on u_component_serverservice_outgoing.destroy
call super::destroy
end on

