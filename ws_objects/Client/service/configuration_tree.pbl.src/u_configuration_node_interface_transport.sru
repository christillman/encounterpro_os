$PBExportHeader$u_configuration_node_interface_transport.sru
forward
global type u_configuration_node_interface_transport from u_configuration_node_base
end type
end forward

global type u_configuration_node_interface_transport from u_configuration_node_base
end type
global u_configuration_node_interface_transport u_configuration_node_interface_transport

forward prototypes
public function boolean has_children ()
public function integer activate ()
end prototypes

public function boolean has_children ();return false
end function

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
long ll_transport_owner_id
string ls_purpose
string ls_document_route
string ls_document_route_suffix
boolean lb_virtual_transport
string ls_direction
long ll_interfaceserviceid
long ll_transportsequence

Setnull(ls_null)
Setnull(ll_null)

ll_transportsequence = long(node.key)
ll_interfaceserviceid = long(parent_configuration_node.node.key)

lb_virtual_transport = false // a virtual transport is a conection to or from EpIE that is not represented by an actual transport record

SELECT ownerid, status, purpose, document_route_suffix, direction
INTO :ll_transport_owner_id, :ls_status,  :ls_purpose, :ls_document_route_suffix, :ls_direction
FROM c_Component_Interface_Route
WHERE subscriber_owner_id = :sqlca.customer_id
AND interfaceserviceid = :ll_interfaceserviceid
AND transportsequence = :ll_transportsequence;
if not tf_check() then return 1
if sqlca.sqlnrows = 0 then
	lb_virtual_transport = true
end if

SELECT document_route
INTO :ls_document_route
FROM c_Component_Interface
WHERE subscriber_owner_id = :sqlca.customer_id
AND interfaceserviceid = :ll_interfaceserviceid;
if not tf_check() then return 1

if len(ls_document_route_suffix) > 0 and len(ls_document_route) > 0 then
	ls_document_route += "." + ls_document_route_suffix
end if

if not lb_virtual_transport then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_wrench.bmp"
	popup.button_helps[popup.button_count] = "Configure Interface"
	popup.button_titles[popup.button_count] = "Configure Interface"
	lsa_buttons[popup.button_count] = "CONFIGURE"
end if

if not lb_virtual_transport then
	if upper(ls_status) = "OK" then
		popup.button_count = popup.button_count + 1
		popup.button_icons[popup.button_count] = "button_traffic_light_red.bmp"
		popup.button_helps[popup.button_count] = "Disable Transport"
		popup.button_titles[popup.button_count] = "Disable Transport"
		lsa_buttons[popup.button_count] = "DISABLE"
	else
		popup.button_count = popup.button_count + 1
		popup.button_icons[popup.button_count] = "button_traffic_light_green.bmp"
		popup.button_helps[popup.button_count] = "Enable Transport"
		popup.button_titles[popup.button_count] = "Enable Transport"
		lsa_buttons[popup.button_count] = "ENABLE"
	end if
end if

if upper(ls_direction) = "O" and ll_transport_owner_id = sqlca.customer_id then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_document_recipient.bmp"
	popup.button_helps[popup.button_count] = "Set Actors"
	popup.button_titles[popup.button_count] = "Set Actors"
	lsa_buttons[popup.button_count] = "ACTORS"
end if

if ll_transport_owner_id = sqlca.customer_id and not lb_virtual_transport then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Delete Transport"
	popup.button_titles[popup.button_count] = "Delete Transport"
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
	CASE "ACTORS"
		li_sts = f_configure_interface_transport_actors(ll_interfaceserviceid, ll_transportsequence)
	CASE "CONFIGURE"
		if ll_transport_owner_id = sqlca.customer_id then
			li_sts = f_configure_local_interface_transport(ll_interfaceserviceid, ll_transportsequence)
			if li_sts > 0 then
				return 2
			end if
		else
			li_sts = f_configure_epie_transport(ll_interfaceserviceid, ll_transportsequence)
			if li_sts > 0 then
				return 2
			end if
		end if
	CASE "DISABLE"
		UPDATE c_Component_Interface_Route
		SET status = 'NA'
		WHERE subscriber_owner_id = :sqlca.customer_id
		AND interfaceserviceid = :ll_interfaceserviceid
		AND transportsequence = :ll_transportsequence;
		if not tf_check() then return 1
		
		return 2
	CASE "ENABLE"
		UPDATE c_Component_Interface_Route
		SET status = 'OK'
		WHERE subscriber_owner_id = :sqlca.customer_id
		AND interfaceserviceid = :ll_interfaceserviceid
		AND transportsequence = :ll_transportsequence;
		if not tf_check() then return 1
		
		return 2
	CASE "DELETE"
		openwithparm(w_pop_yes_no, "Are you sure you want to delete this transport?")
		popup_return = message.powerobjectparm
		if popup_return.item = "YES" then
			DELETE c_Component_Interface_Route_Property
			WHERE subscriber_owner_id = :sqlca.customer_id
			AND interfaceserviceid = :ll_interfaceserviceid
			AND transportsequence = :ll_transportsequence;
			if not tf_check() then return 1
			
			DELETE c_Component_Interface_Route
			WHERE subscriber_owner_id = :sqlca.customer_id
			AND interfaceserviceid = :ll_interfaceserviceid
			AND transportsequence = :ll_transportsequence;
			if not tf_check() then return 1

			if len(ls_document_route) > 0 then
				DELETE c_Document_Route
				WHERE document_route = :ls_document_route;
				if not tf_check() then return 1
			end if
			
			return 3
		end if
	CASE "CANCEL"
		return 1
	CASE ELSE
END CHOOSE

Return 1


end function

on u_configuration_node_interface_transport.create
call super::create
end on

on u_configuration_node_interface_transport.destroy
call super::destroy
end on

