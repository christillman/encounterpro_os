$PBExportHeader$u_component_serverservice_incoming.sru
forward
global type u_component_serverservice_incoming from u_component_base_class
end type
end forward

global type u_component_serverservice_incoming from u_component_base_class
end type
global u_component_serverservice_incoming u_component_serverservice_incoming

type variables
u_component_incoming subscriptions[]
integer subscription_count

end variables

forward prototypes
public function integer xx_initialize ()
public function integer xx_shutdown ()
end prototypes

public function integer xx_initialize ();u_ds_data luo_data
integer li_count
long i
string ls_transport_component_id
long ll_subscription_id
integer li_sts
u_component_incoming luo_transport

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_message_subscription_data")
li_count = luo_data.retrieve("%", "I")

if li_count < 0 then
	mylog.log(this, "xx_initialize()", "Error getting subscribers", 4)
	return -1
elseif li_count = 0 then
	mylog.log(this, "xx_initialize()", "No incoming subscribers", 2)
end if

subscription_count = 0

for i = 1 to li_count
	ls_transport_component_id = luo_data.object.transport_component_id[i]
	ll_subscription_id = luo_data.object.subscription_id[i]
	
	if isnull(ls_transport_component_id) then
		mylog.log(this, "xx_initialize()", "Null transport_component_id", 4)
		continue
	end if

	luo_transport = my_component_manager.get_component(ls_transport_component_id)
	if isnull(luo_transport) then
		mylog.log(this, "xx_initialize()", "Unable to get component (" + ls_transport_component_id + ")", 4)
		continue
	end if
	
	subscription_count += 1
	subscriptions[subscription_count] = luo_transport
	
	li_sts = luo_transport.start_receiving(ll_subscription_id)
	if li_sts <= 0 then
		mylog.log(this, "xx_initialize()", "Error starting receiving (" + ls_transport_component_id + ")", 4)
		continue
	end if
next

DESTROY luo_data

return 1

end function

public function integer xx_shutdown ();integer i

for i = 1 to subscription_count
	subscriptions[i].stop_receiving()
	my_component_manager.destroy_component(subscriptions[i])
next

subscription_count = 0

return 1

end function

on u_component_serverservice_incoming.create
TriggerEvent( this, "constructor" )
end on

on u_component_serverservice_incoming.destroy
TriggerEvent( this, "destructor" )
end on

