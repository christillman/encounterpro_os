HA$PBExportHeader$u_component_route_printer.sru
forward
global type u_component_route_printer from u_component_route
end type
end forward

global type u_component_route_printer from u_component_route
end type
global u_component_route_printer u_component_route_printer

type variables
u_file_action file_action

end variables

forward prototypes
protected function integer xx_send_document (u_component_wp_item_document puo_document)
protected function integer xx_pick_address (u_component_wp_item_document puo_document, string ps_new_ordered_for, string ps_new_dispatch_method, ref string ps_address_attribute, ref string ps_address_value)
end prototypes

protected function integer xx_send_document (u_component_wp_item_document puo_document);string ls_printer
boolean lb_cover_letter
integer li_wait
string ls_temp
integer li_sts
str_external_observation_attachment lstr_document

li_sts = puo_document.get_document(lstr_document)
if li_sts <= 0 then
	log.log(this, "xx_send_document()", "Error getting document (" + string(puo_document.patient_workplan_item_id) + ")", 4)
	return -1
end if

li_wait = f_please_wait_open()

ls_printer = puo_document.get_attribute("Printer")
if len(ls_printer) > 0 then
	common_thread.set_printer(ls_printer)
end if
	
// If the "cover_page" attribute isn't present then the default behavior is to print a cover_page if there is a "subject" or "message" attribute
lb_cover_letter = false
ls_temp = puo_document.get_attribute("cover_page")
if isnull(ls_temp) then
	if len(puo_document.get_attribute("subject")) > 0 then
		lb_cover_letter = true
	elseif len(puo_document.get_attribute("message")) > 0 then
		lb_cover_letter = true
	end if
else
	lb_cover_letter = f_string_to_boolean(ls_temp)
end if

if lb_cover_letter then
	f_print_cover_page(puo_document)
end if

// We need to use the attachment component to perform the printing because it may have proprietary logic specific to the document type
li_sts = file_action.print_file(lstr_document, ls_printer)
if li_sts <= 0 then
	log.log(this, "xx_send_document()", "Error printing document" + string(puo_document.patient_workplan_item_id) + ")", 4)
	f_please_wait_close(li_wait)
	return -1
end if

// Set the printer back to the default
if len(ls_printer) > 0 then
	common_thread.set_default_printer()
end if

f_please_wait_close(li_wait)

return 1

end function

protected function integer xx_pick_address (u_component_wp_item_document puo_document, string ps_new_ordered_for, string ps_new_dispatch_method, ref string ps_address_attribute, ref string ps_address_value);str_popup popup
str_popup_return popup_return
string ls_actor_class
string ls_communication_type
string ls_send_from
str_actor_communication lstr_actor_communication
integer li_sts
string ls_via_address
string ls_room_id
string ls_report_id
long ll_response

ls_actor_class = user_list.user_property(ps_new_ordered_for, "actor_class")
setnull(ls_via_address)

// Get information about this route
SELECT send_from
INTO :ls_send_from
FROM dbo.fn_document_route_information(:ps_new_dispatch_method);
if not tf_check() then return -1
if sqlca.sqlnrows <> 1 then
	log.log(this, "document_send()", "Invalid document_route (" + ps_new_dispatch_method + ")", 4)
	return -1
end if

ls_communication_type = "Printer"

// If this is a report and the report has a default printer, see if the user wants to use the default printer for this report
if lower(puo_document.document_subtype()) = "report" then
	// First get the default printer for this report
	if isnull(puo_document.cpr_id) or isnull(puo_document.encounter_id) then
		setnull(ls_room_id)
	else
		// If we have both a patient context and an encounter context, then see where the patient is now
		SELECT patient_location
		INTO :ls_room_id
		FROM p_Patient_Encounter
		WHERE cpr_id = :puo_document.cpr_id
		AND encounter_id = :puo_document.encounter_id;
		if not tf_check() then return -1
	end if
	
	ls_report_id = puo_document.get_attribute("report_id")
	ls_via_address = f_get_default_printer(ls_report_id, office_id, computer_id, ls_room_id)
	
	if len(ls_via_address) > 0 and lower(ls_send_from) = "client" then
		// If we're sending from the client, then see if the report's default printer is available from the client before
		// we offer it as a choice to the user
		if not common_thread.is_printer_available_on_client(ls_via_address) then
			// Printer isn't available
			setnull(ls_via_address)
		end if
	end if
	
	if len(ls_via_address) > 0 then
		popup.data_row_count = 2
		popup.items[1] = "Use Configured Printer"
		popup.items[2] = "Select Printer"
		popup.title = "The associated report is configured to use the ~"" + ls_via_address + "~" printer.  Do you wish to..."
		openwithparm(w_pop_choices_2, popup)
		ll_response = message.doubleparm
		if ll_response = 2 then setnull(ls_via_address)
	end if
end if


// If we still don't have a printer then make the user pick one
if isnull(ls_via_address) then
	if lower(ls_send_from) = "client" then
		ls_via_address = common_thread.select_printer_client()
	else
		ls_via_address = common_thread.select_printer_server()
	end if
end if

// If we still don't have a printer then just return nothing
if isnull(ls_via_address) then return 0

ps_address_attribute = "Printer"
ps_address_value = ls_via_address

return 1

end function

on u_component_route_printer.create
call super::create
end on

on u_component_route_printer.destroy
call super::destroy
end on

