$PBExportHeader$u_configuration_node_installed_interface.sru
forward
global type u_configuration_node_installed_interface from u_configuration_node_base
end type
end forward

global type u_configuration_node_installed_interface from u_configuration_node_base
end type
global u_configuration_node_installed_interface u_configuration_node_installed_interface

forward prototypes
public function boolean has_children ()
public function str_configuration_nodes get_children ()
public subroutine refresh_label ()
public function integer activate ()
end prototypes

public function boolean has_children ();return true
end function

public function str_configuration_nodes get_children ();str_configuration_nodes lstr_nodes
u_ds_data luo_data
long ll_office_count
long i
string ls_receive_flag
string ls_send_flag
long ll_owner_id
long ll_interfaceserviceid
boolean lb_receiver_found
boolean lb_sender_found
string ls_comm_component_description
string ls_status
string ls_direction
long ll_count
long ll_service_sequence
string ls_description
string ls_schedule_description
string ls_user_full_name
string ls_interface_guid
string ls_filter

lstr_nodes.node_count = 0


ll_interfaceserviceid = long(node.key)

SELECT receive_flag, send_flag, owner_id, CAST(id AS varchar(40))
INTO :ls_receive_flag, :ls_send_flag, :ll_owner_id, :ls_interface_guid
FROM dbo.fn_practice_interfaces()
WHERE interfaceserviceid = :ll_interfaceserviceid;
if not tf_check() then return lstr_nodes


luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_practice_interface_transports")
ll_office_count = luo_data.retrieve(sqlca.customer_id, ll_interfaceserviceid)

lb_receiver_found = false
lb_sender_found = false
for i = 1 to ll_office_count
	if upper(string(luo_data.object.direction[i])) = "I" then
		lb_receiver_found = true
	end if
	if upper(string(luo_data.object.direction[i])) = "O" then
		lb_sender_found = true
	end if
next

if not lb_receiver_found and upper(ls_receive_flag) = "Y" and ll_owner_id <> sqlca.customer_id then
	ll_office_count = luo_data.insertrow(0)
	luo_data.object.transportsequence[ll_office_count] = 0
	luo_data.object.direction[ll_office_count] = "I"
	luo_data.object.commcomponent[ll_office_count] = 'Receiver_EpIE'
	luo_data.object.transportdescription[ll_office_count] = 'EpIE Receiver'
	luo_data.object.status[ll_office_count] = 'OK'
end if

if not lb_sender_found and upper(ls_send_flag) = "Y" and ll_owner_id <> sqlca.customer_id then
	ll_office_count = luo_data.insertrow(0)
	luo_data.object.transportsequence[ll_office_count] = 0
	luo_data.object.direction[ll_office_count] = "O"
	luo_data.object.commcomponent[ll_office_count] = 'Sender_EpIE'
	luo_data.object.transportdescription[ll_office_count] = 'EpIE Sender'
	luo_data.object.status[ll_office_count] = 'OK'
end if

for i = 1 to ll_office_count
	ls_comm_component_description = luo_data.object.comm_component_description[i]
	ls_status = luo_data.object.status[i]
	ls_direction = upper(string(luo_data.object.direction[i]))
	
	lstr_nodes.node_count += 1
	
	if len(ls_comm_component_description) > 0 then
		lstr_nodes.node[lstr_nodes.node_count].label = ls_comm_component_description + ": " + luo_data.object.transportdescription[i]
	else
		lstr_nodes.node[lstr_nodes.node_count].label = luo_data.object.transportdescription[i]
	end if
	if lower(ls_status) <> 'ok' then
		lstr_nodes.node[lstr_nodes.node_count].label += " (Disabled)"
	end if
	lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_interface_transport"
	lstr_nodes.node[lstr_nodes.node_count].key = string(luo_data.object.transportsequence[i])
	
	if ls_direction = "O" then
		lstr_nodes.node[lstr_nodes.node_count].button = "button_out_only.bmp"
	else
		lstr_nodes.node[lstr_nodes.node_count].button = "button_in_only.bmp"
	end if
next


///////////////////////////////////////////////////////////////////////////////////////////////////////////
// Now add the scheduled services for this interface
///////////////////////////////////////////////////////////////////////////////////////////////////////////
if left(ls_interface_guid, 1) <> "{" then
	ls_interface_guid = "{" + ls_interface_guid
end if
if right(ls_interface_guid, 1) <> "}" then
	ls_interface_guid += "}"
end if
luo_data.set_dataobject("dw_fn_scheduled_services")
ls_filter = "lower(parent_object_id)='" + lower(ls_interface_guid) + "'"
luo_data.setfilter(ls_filter)
ll_count = luo_data.retrieve()

for i = 1 to ll_count
	ll_service_sequence = luo_data.object.service_sequence[i]
	ls_description = luo_data.object.description[i]
	ls_schedule_description = luo_data.object.schedule_description[i]
	ls_user_full_name = luo_data.object.user_full_name[i]
	ls_status = luo_data.object.status[i]
	lstr_nodes.node_count += 1
	lstr_nodes.node[lstr_nodes.node_count].label = ls_description + ", " + ls_schedule_description + " for " + ls_user_full_name
	if upper(ls_status) <> "OK" then
			lstr_nodes.node[lstr_nodes.node_count].label += " (Disabled)"
	end if
	lstr_nodes.node[lstr_nodes.node_count].class = "u_configuration_node_system_schedule"
	lstr_nodes.node[lstr_nodes.node_count].key = string(ll_service_sequence)
	lstr_nodes.node[lstr_nodes.node_count].button = "button_clock.bmp"
next

DESTROY luo_data

return lstr_nodes

DESTROY luo_data


return lstr_nodes

end function

public subroutine refresh_label ();string ls_description
long ll_interfaceserviceid

setnull(ls_description)

ll_interfaceserviceid = long(node.key)

SELECT interfacedescription
INTO :ls_description
FROM dbo.fn_practice_interfaces()
WHERE interfaceserviceid = :ll_interfaceserviceid;
if not tf_check() then return
if sqlca.sqlnrows < 1 then return

node.label = ls_description


end subroutine

public function integer activate ();String		lsa_buttons[]
String 		ls_drug_id
String 		ls_description,ls_null
String		ls_top_20_code
Integer		li_sts, li_service_count
Long			ll_null
string ls_property
string ls_literal
str_property_value lstr_property_value
w_document_element_properties lw_document_element_properties
long ll_button_pressed
str_document_element_context lstr_document_element_context
window 				lw_pop_buttons
str_popup 			popup
str_popup 			popup2
str_popup_return 	popup_return
string ls_status
str_service_info lstr_service
long ll_transportsequence
long ll_interface_owner_id
string ls_document_route
long ll_interfaceserviceid
long ll_service_sequence
string ls_interface_guid
w_window_base lw_window

Setnull(ls_null)
Setnull(ll_null)

ll_interfaceserviceid = long(node.key)

SELECT owner_id, status, document_route, CAST(id AS varchar(40))
INTO :ll_interface_owner_id, :ls_status,  :ls_document_route, :ls_interface_guid
FROM c_Component_Interface
WHERE subscriber_owner_id = :sqlca.customer_id
AND interfaceserviceid = :ll_interfaceserviceid;
if not tf_check() then return 1

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_mapping.bmp"
	popup.button_helps[popup.button_count] = "View/Edit Interface Mappings"
	popup.button_titles[popup.button_count] = "Mappings"
	lsa_buttons[popup.button_count] = "MAPPINGS"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_wrench.bmp"
	popup.button_helps[popup.button_count] = "Configure Interface"
	popup.button_titles[popup.button_count] = "Configure Interface"
	lsa_buttons[popup.button_count] = "CONFIGURE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_traffic_light_red.bmp"
	popup.button_helps[popup.button_count] = "Disable All Transports"
	popup.button_titles[popup.button_count] = "Disable All Transports"
	lsa_buttons[popup.button_count] = "DISABLE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_traffic_light_green.bmp"
	popup.button_helps[popup.button_count] = "Enable All Transports"
	popup.button_titles[popup.button_count] = "Enable All Transports"
	lsa_buttons[popup.button_count] = "ENABLE"
end if

if ll_interface_owner_id = sqlca.customer_id then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "interface_in_out.bmp"
	popup.button_helps[popup.button_count] = "New Transport"
	popup.button_titles[popup.button_count] = "New Transport"
	lsa_buttons[popup.button_count] = "NEWTRANSPORT"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_clock.bmp"
	popup.button_helps[popup.button_count] = "Create a New Scheduled Task"
	popup.button_titles[popup.button_count] = "New Task"
	lsa_buttons[popup.button_count] = "NEWSCHEDULEDTASK"
end if

if ll_interface_owner_id = sqlca.customer_id then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Delete Interface"
	popup.button_titles[popup.button_count] = "Delete Interface"
	lsa_buttons[popup.button_count] = "DELETE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	lsa_buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	ll_button_pressed = message.doubleparm
	if ll_button_pressed < 1 or ll_button_pressed > popup.button_count then return 1
elseif popup.button_count = 1 then
	ll_button_pressed = 1
else
	return 1
end if

CHOOSE CASE lsa_buttons[ll_button_pressed]
	CASE "MAPPINGS"
		lstr_service.service = "Code Mappings"
		f_attribute_add_attribute(lstr_service.attributes, "interfaceserviceid", string(ll_interfaceserviceid))
		
		li_sts = service_list.do_service(lstr_service)
		if li_sts < 0 then
			openwithparm(w_pop_message, "An error occured ordering tasks")
			return 1
		end if
	CASE "CONFIGURE"
		li_sts = f_configure_interface(ll_interfaceserviceid)
		return 2
	CASE "DISABLE"
		UPDATE c_Component_Interface_Route
		SET status = 'NA'
		WHERE subscriber_owner_id = :sqlca.customer_id
		AND interfaceserviceid = :ll_interfaceserviceid;
		if not tf_check() then return 1
		
		return 2
	CASE "ENABLE"
		UPDATE c_Component_Interface_Route
		SET status = 'OK'
		WHERE subscriber_owner_id = :sqlca.customer_id
		AND interfaceserviceid = :ll_interfaceserviceid;
		if not tf_check() then return 1
		
		return 2
	CASE "NEWTRANSPORT"
		setnull(ll_transportsequence)
		li_sts = f_configure_local_interface_transport(ll_interfaceserviceid, ll_transportsequence)
		if li_sts > 0 then
			return 2
		end if
	CASE "NEWSCHEDULEDTASK"
		ll_service_sequence = f_new_scheduled_service(ls_interface_guid)
		if ll_service_sequence <= 0 then return 1
		
		openwithparm(lw_window, ll_service_sequence, "w_scheduled_service_edit")
		
		return 2
	CASE "DELETE"
		if ll_interface_owner_id = sqlca.customer_id then
			openwithparm(w_pop_yes_no, "Are you sure you want to delete this interface?")
			popup_return = message.powerobjectparm
			if popup_return.item = "YES" then
				sqlca.config_delete_interface(ll_interfaceserviceid)
				if not tf_check() then return 1
				
				return 3
			end if
		else
			openwithparm(w_pop_message, "Only locally defined interfaces may be deleted")
			return 1
		end if
	CASE "CANCEL"
		return 1
	CASE ELSE
END CHOOSE

Return 1

end function

on u_configuration_node_installed_interface.create
call super::create
end on

on u_configuration_node_installed_interface.destroy
call super::destroy
end on

