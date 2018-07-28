$PBExportHeader$u_component_route.sru
forward
global type u_component_route from u_component_base_class
end type
end forward

global type u_component_route from u_component_base_class
end type
global u_component_route u_component_route

forward prototypes
public function integer send_document (u_component_wp_item_document puo_document)
protected function integer xx_send_document (u_component_wp_item_document puo_document)
protected function integer xx_pick_address (u_component_wp_item_document puo_document, string ps_new_ordered_for, string ps_new_dispatch_method, ref string ps_address_attribute, ref string ps_address_value)
public function integer pick_address (u_component_wp_item_document puo_document, string ps_new_ordered_for, string ps_new_dispatch_method, ref string ps_address_attribute, ref string ps_address_value)
end prototypes

public function integer send_document (u_component_wp_item_document puo_document);

return xx_send_document(puo_document)



end function

protected function integer xx_send_document (u_component_wp_item_document puo_document);

return 1

end function

protected function integer xx_pick_address (u_component_wp_item_document puo_document, string ps_new_ordered_for, string ps_new_dispatch_method, ref string ps_address_attribute, ref string ps_address_value);long ll_count
str_popup popup
str_popup_return popup_return
string ls_actor_class
string ls_communication_type
string ls_send_from
str_actor_communication lstr_actor_communication
integer li_sts
string ls_via_address
u_ds_data luo_data


luo_data = CREATE u_ds_data
luo_data.set_dataobject( "dw_fn_document_recipient_info")
ll_count = luo_data.retrieve(ps_new_ordered_for, puo_document.cpr_id, puo_document.encounter_id)
if ll_count <= 0 then
	log.log(this, "xx_pick_address()", "Error getting document recipient info (" + ps_new_ordered_for + ")", 4)
	return -1
end if

ls_actor_class = luo_data.object.actor_class[1]

setnull(ls_via_address)

// Get information about this route
SELECT communication_type, send_from
INTO :ls_communication_type, :ls_send_from
FROM dbo.fn_document_route_information(:ps_new_dispatch_method);
if not tf_check() then return -1
if sqlca.sqlnrows <> 1 then
	log.log(this, "xx_pick_address()", "Invalid document_route (" + ps_new_dispatch_method + ")", 4)
	return -1
end if

// if there is not communication type and we're using the default pick_address method, then an address is not required
if isnull(ls_communication_type) then
	setnull(ps_address_attribute)
	setnull(ps_address_value)
	return 1
end if

// The patient communication addresses are stored differently from the actor communication addresses, so
// present the list to the user based on the actor class
if lower(ls_actor_class) = "patient" then
	// If the actor is a patient then offer choices from the patient Communication entries in p_Patient_Progress
	popup.dataobject = "dw_patient_progress_pick"
	popup.data_row_count = 0
	popup.title = "Select " + wordcap(ls_communication_type)
	popup.datacolumn = 12
	popup.displaycolumn = 12
	popup.argument_count = 2
	popup.argument[1] = puo_document.cpr_id
	popup.argument[2] = "Communication " + ls_communication_type
	popup.auto_singleton = true
	openwithparm(w_pop_pick, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count = 1 then
		ls_via_address = popup_return.items[1]
	else
		if popup_return.choices_count = 0 then
			// There weren't any choices
			openwithparm(w_pop_message, "This patient does not have any " + ls_communication_type + " addresses.")
		end if
		return 0
	end if
else
	// If the actor is not a patient then offer choices from the c_actor_communication table
	li_sts = f_pick_actor_communication(ps_new_ordered_for, ls_communication_type, lstr_actor_communication)
	if li_sts <= 0 then return li_sts
	
	ls_via_address = lstr_actor_communication.communication_value
end if

if isnull(ls_via_address) then
	return 0
end if

ps_address_attribute = ls_communication_type
ps_address_value = ls_via_address

return 1

end function

public function integer pick_address (u_component_wp_item_document puo_document, string ps_new_ordered_for, string ps_new_dispatch_method, ref string ps_address_attribute, ref string ps_address_value);

return xx_pick_address(puo_document, ps_new_ordered_for, ps_new_dispatch_method, ps_address_attribute, ps_address_value)

return 1


end function

on u_component_route.create
call super::create
end on

on u_component_route.destroy
call super::destroy
end on

