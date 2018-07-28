$PBExportHeader$u_component_service_report.sru
forward
global type u_component_service_report from u_component_service
end type
end forward

global type u_component_service_report from u_component_service
end type
global u_component_service_report u_component_service_report

type variables
boolean report_configured = false

string server_user_id

str_attributes report_runtime_attributes

end variables

forward prototypes
public function boolean xx_any_params (string ps_param_mode)
public function string pick_report_type ()
public function string pick_report (string ps_report_type)
public function integer xx_configure_service (string ps_param_mode, ref str_attributes pstr_attributes)
protected function integer xx_initialize ()
public function integer xx_do_service ()
public function integer configure_report (u_component_report puo_report, str_attributes pstr_attributes)
public function string pick_route (string ps_document_purpose, string ps_ordered_for)
public function string pick_recipient (string ps_document_purpose)
private function long order_document ()
end prototypes

public function boolean xx_any_params (string ps_param_mode);integer li_count
string ls_report_id

ls_report_id = get_attribute("report_id")

if isnull(ls_report_id) then return false

CHOOSE CASE lower(ps_param_mode)
	CASE "config"
		return false
	CASE "order"
		return false
	CASE "runtime"
		SELECT count(*)
		INTO :li_count
		FROM c_Component_Param
		WHERE id = :ls_report_id
		AND param_mode = :ps_param_mode
		USING cprdb;
		if not cprdb.check() then return false
		
		if li_count > 0 then return true
END CHOOSE


return false


end function

public function string pick_report_type ();str_popup popup
str_popup_return popup_return
string ls_null
u_ds_data luo_data
long ll_count
long i
string ls_report_type

setnull(ls_null)

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_report_type_list", cprdb)
ll_count = luo_data.retrieve()

for i = 1 to ll_count
	ls_report_type = luo_data.object.report_type[i]
	CHOOSE CASE lower(ls_report_type)
		CASE "patient"
			if isnull(cpr_id) then continue
		CASE "encounter"
			if isnull(encounter_id) then continue
		CASE "assessment"
			if isnull(problem_id) then continue
		CASE "treatment"
			if isnull(treatment_id) then continue
	END CHOOSE
	
	popup.data_row_count += 1
	popup.items[popup.data_row_count] = ls_report_type
next

popup.auto_singleton = true
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return ls_null

return popup_return.items[1]

end function

public function string pick_report (string ps_report_type);str_popup popup
str_popup_return popup_return
string ls_null
string ls_report_id

setnull(ls_null)

popup.dataobject = "dw_sp_report_list"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = ps_report_type
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return ls_null

ls_report_id = popup_return.items[1]


return ls_report_id

end function

public function integer xx_configure_service (string ps_param_mode, ref str_attributes pstr_attributes);integer li_sts
str_params lstr_params
string ls_report_id
string ls_description


ls_report_id = get_attribute("report_id")

if isnull(ls_report_id) then return 0

CHOOSE CASE lower(ps_param_mode)
	CASE "config"
	CASE "order"
		SELECT description
		INTO :ls_description
		FROM c_Report_Definition
		WHERE report_id = :ls_report_id
		USING cprdb;
		if not cprdb.check() then return -1
		if cprdb.sqlcode = 100 then
			mylog.log(this, "xx_configure_service()", "Invalid report id (" + ls_report_id + ")", 4)
			return -1
		end if
		
		description = ls_description
	CASE "runtime"
		li_sts = f_get_params(ls_report_id, "Runtime", pstr_attributes)
		if li_sts < 0 then return -1
		report_runtime_attributes = pstr_attributes
		report_configured = true
END CHOOSE


return li_sts

end function

protected function integer xx_initialize ();server_user_id = get_attribute("server_user_id")
if isnull(server_user_id) then server_user_id = "#JMJ"

return 1

end function

public function integer xx_do_service ();String 					ls_report_id
string reader_user_id
String					buttons[]
String 					ls_component_id
String 					ls_destination
String 					ls_get_params
Long						ll_encounter_id,ll_patient_workplan_id
Integer 					li_sts,i,button_pressed
Integer 					li_attribute_count
Boolean					lb_display, lb_print,lb_show_toolbar = false
Boolean					lb_encounter_exists
window					lw_pop_buttons
u_component_report 	luo_report
str_params				lstr_params
str_popup				popup
str_popup_return 		popup_return
str_attributes 			lstr_attributes
str_pick_users lstr_pick_users
u_component_wp_item_document luo_document
//string ls_report_type
string ls_printer
string ls_report_office_id
string ls_attribute
string ls_value
string ls_cpr_id
string ls_from_user_id
string ls_description
string ls_service
string ls_sql
long ll_computer_id
string ls_room_id
string ls_null
long ll_report_computer_id
boolean lb_loop
w_window_base lw_window
str_pick_config_object lstr_pick_config_object
string ls_Manage_Document
str_external_observation_attachment lstr_attachment
string ls_progress_type
string ls_progress_key
long ll_attachment_id
long ll_patient_workplan_item_id
boolean lb_document_management_mode
u_user luo_reader

setnull(ls_cpr_id)
setnull(ll_patient_workplan_id)
setnull(ls_from_user_id)
setnull(ls_description)
setnull(ls_service)
setnull(ls_null)

ls_report_id = get_attribute("report_id")
setnull(reader_user_id)
lb_document_management_mode = datalist.get_preference_boolean("PREFERENCES", "Use Document Management", false)

If isnull(ls_report_id) then 
	if cpr_mode = "CLIENT" Then
		// What kind of config object?
		lstr_pick_config_object.config_object_type = get_attribute("config_object_type")
		if isnull(lstr_pick_config_object.config_object_type) then
			// Default to "Report"
			lstr_pick_config_object.config_object_type = "Report"
		end if
		
		lstr_pick_config_object.context_object = context_object
		openwithparm(lw_window, lstr_pick_config_object, "w_pick_config_object")
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return 1
		
		ls_report_id = popup_return.items[1]
		if isnull(ls_report_id) then
			// User elected not to select a specific report
			return 1
		end if

		// Add the report_id to the service attributes
		add_workplan_item_attribute("report_id", ls_report_id)
	else
		log.log(this, "xx_do_service()", "No report_id", 4)
		Return -1
	end if
End if

// If we're going to order the document instead of run the report, call the order_document() method
get_attribute("Manage Document", ls_Manage_Document)
ls_Manage_Document = wordcap(ls_Manage_Document)
if ls_Manage_Document = "Order Document" then
	ll_patient_workplan_item_id = order_document()
	if ll_patient_workplan_item_id <= 0 then return -1
	return 1
end if

// Get the component_id and the SQL query
SELECT component_id, sql
INTO :ls_component_id, :ls_sql
FROM c_Report_Definition
WHERE report_id = :ls_report_id;
If Not tf_check() Then Return -1

if not report_configured then
	li_sts = f_get_params(ls_report_id, "Runtime", report_runtime_attributes)
	if li_sts < 0 then
		// If the user pressed "cancel" or an error occured...
		
		// If this is a manual service then just cancel it
		if manual_service then return 2
		
		// If this is a workflow service then ask the user if they want to cancel
		popup.title = "Do you wish to:"
		popup.data_row_count = 2
		popup.items[1] = "Cancel This Report"
		popup.items[2] = "Do This Report Later"
		openwithparm(w_pop_choices_2, popup)
		li_sts = message.doubleparm
		if li_sts = 1 then
			return 2
		else
			return 0
		end if
	end if
	add_attributes(report_runtime_attributes)
	
	// If we have a SQL script then perform any required substitutions and add it to the attributes.
	if not isnull(ls_sql) then
		ls_sql = f_string_substitute_attributes(ls_sql, get_attributes())
		add_attribute("SQLQUERY", ls_sql)
	end if
	report_configured = true
end if

ls_destination = get_attribute("destination")
If isnull(ls_destination) then lb_show_toolbar = true

// If any component defined for selected report then
If Isnull(ls_component_id) Then
	log.log(this, "xx_do_service()", "Null component_id (" + ls_report_id + ")", 4)
	Return -1
Else
	luo_report = component_manager.get_component(ls_component_id)
	If Isnull(luo_report) Then
		log.log(This, "print()", "Error getting report component (" + &
					ls_component_id + ")", 4)
		Return -1
	End If
End If

// Set the report_id property
luo_report.report_id = ls_report_id

ls_report_office_id = get_attribute("office_id")
if isnull(ls_report_office_id) then
	// If there is no office_id specified in the attributes, then look it up.
	// If this service is associated with an encounter, then add the office of the encounter
	// so the report knows which records to get from o_Report_Attributes
	if not isnull(encounter_id) and not isnull(current_patient) then
		SELECT office_id
		INTO :ls_report_office_id
		FROM p_Patient_Encounter
		WHERE cpr_id = :current_patient.cpr_id
		AND encounter_id = :encounter_id
		USING cprdb;
		if not tf_check() then return -1
		if cprdb.sqlcode = 100 then setnull(ls_report_office_id)
	end if
end if

// See if a printer is already specified
ls_printer = get_attribute("printer")

// Check the context object for a specific printer
if isnull(ls_printer) and not isnull(current_patient) then
	ls_printer = f_get_progress_value(current_patient.cpr_id, &
													context_object, &
													object_key, &
													"Property", &
													"printer")
end if

// Determine the report computer_id
get_attribute("computer_id", ll_report_computer_id)
if isnull(ll_report_computer_id) then
	ll_report_computer_id = computer_id
end if

// If we still don't have a printer, look up the default printer for this report
if isnull(ls_printer) then
	if isnull(current_patient) or isnull(encounter_id) then
		setnull(ls_room_id)
	else
		// If we have both a patient context and an encounter context, then see where the patient is now
		ls_room_id = current_patient.encounters.get_property_value(encounter_id, "patient_location")
	end if
	ls_printer = f_get_default_printer(ls_report_id, ls_report_office_id, ll_report_computer_id, ls_room_id)
end if

// Get the attributes for this service
lstr_attributes = get_attributes()
log.log(this, "xx_do_service()","processing report ("+ls_report_id+") on mode "+cpr_mode,1)

If cpr_mode = "CLIENT" Then
	If lb_show_toolbar Then
		DO
			lb_loop = false
			
			// check whether the report can be printed/displayed local
			lb_display = luo_report.xx_displayable()
			lb_print = luo_report.xx_printable()
		
			If lb_display Then
				popup.button_count = popup.button_count + 1
				popup.button_icons[popup.button_count] = "button34.bmp"
				popup.button_helps[popup.button_count] = "Display report on screen"
				popup.button_titles[popup.button_count] = "Preview Report"
				buttons[popup.button_count] = "SCREEN"
			End If
		
			If lb_print Then
				popup.button_count = popup.button_count + 1
				popup.button_icons[popup.button_count] = "button33.bmp"
				popup.button_helps[popup.button_count] = "Send report to default local printer"
				popup.button_titles[popup.button_count] = "Default Printer"
				buttons[popup.button_count] = "PRINTER"
			End If
		
			If lb_print Then
				popup.button_count = popup.button_count + 1
				popup.button_icons[popup.button_count] = "button33.bmp"
				popup.button_helps[popup.button_count] = "Send report to selected printer"
				popup.button_titles[popup.button_count] = "Select Printer"
				buttons[popup.button_count] = "PRINTERSELECT"
			End If
		
			If true Then
				popup.button_count = popup.button_count + 1
				popup.button_icons[popup.button_count] = "button35.bmp"
				popup.button_helps[popup.button_count] = "Queue report to server"
				popup.button_titles[popup.button_count] = "Print from server"
				buttons[popup.button_count] = "SERVER"
			End If
		
			If lb_document_management_mode Then
				popup.button_count = popup.button_count + 1
				popup.button_icons[popup.button_count] = "button10.bmp"
				popup.button_helps[popup.button_count] = "Select Recipient of Report"
				popup.button_titles[popup.button_count] = "Select Recipient"
				buttons[popup.button_count] = "RECIPIENT"
			else
				popup.button_count = popup.button_count + 1
				popup.button_icons[popup.button_count] = "button10.bmp"
				popup.button_helps[popup.button_count] = "Select Reader of Report"
				popup.button_titles[popup.button_count] = "Select Reader"
				buttons[popup.button_count] = "READER"
			End If
		
			If user_list.is_user_privileged(current_scribe.user_id, "Configuration Mode") Then
				popup.button_count = popup.button_count + 1
				popup.button_icons[popup.button_count] = "button_wrench.bmp"
				popup.button_helps[popup.button_count] = "Configure Report"
				popup.button_titles[popup.button_count] = "Configure Report"
				buttons[popup.button_count] = "CONFIG"
			End If
		
			if manual_service then
				popup.button_count = popup.button_count + 1
				popup.button_icons[popup.button_count] = "button11.bmp"
				popup.button_helps[popup.button_count] = "Cancel"
				popup.button_titles[popup.button_count] = "Cancel"
				buttons[popup.button_count] = "CANCEL"
			else
				popup.button_count = popup.button_count + 1
				popup.button_icons[popup.button_count] = "button13.bmp"
				popup.button_helps[popup.button_count] = "Cancel This Report"
				popup.button_titles[popup.button_count] = "Cancel Report"
				buttons[popup.button_count] = "CANCELSERVICE"

				popup.button_count = popup.button_count + 1
				popup.button_icons[popup.button_count] = "button11.bmp"
				popup.button_helps[popup.button_count] = "Leave and come back later to run this report"
				popup.button_titles[popup.button_count] = "I'll Be Back"
				buttons[popup.button_count] = "BEBACK"
			End If
		
			popup.button_titles_used = true
		
			If popup.button_count > 1 Then
				openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
				button_pressed = message.doubleparm
				If button_pressed < 1 Or button_pressed > popup.button_count Then return 1
			ElseIf popup.button_count = 1 Then
				button_pressed = 1
			Else
				Return 1
			End if
			
			// Trap it and loop again if user clicked "Select Recipient"
			if buttons[button_pressed] = "RECIPIENT" then
				lstr_pick_users.allow_special_users = true
				lstr_pick_users.actor_class = "Consultant"
				lstr_pick_users.cpr_id = cpr_id
				
				li_sts = user_list.pick_users(lstr_pick_users)
				if li_sts > 0 then
					reader_user_id = lstr_pick_users.selected_users.user[1].user_id
					f_attribute_add_attribute(lstr_attributes, "reader_user_id", reader_user_id)
				else
					lb_loop = true
				end if
			end if
			
			// Trap it and loop again if user clicked "Select Reader"
			if buttons[button_pressed] = "READER" then
				lb_loop = true
				popup.button_count = 0
				
				luo_reader = user_list.pick_user(true, false, true)
				if not isnull(luo_reader) then
					f_attribute_add_attribute(lstr_attributes, "reader_user_id", luo_reader.user_id)
				end if
			end if

			// Trap it and loop again if user clicked "Configure"
			if buttons[button_pressed] = "CONFIG" then
				lb_loop = true
				popup.button_count = 0
				
				li_sts = configure_report(luo_report,lstr_attributes)
			end if
		LOOP WHILE lb_loop
	
		CHOOSE CASE buttons[button_pressed]
			CASE "SCREEN"
				ls_destination = "SCREEN"
			CASE "PRINTER"
				ls_destination = "PRINTER"
			CASE "PRINTERSELECT"
				ls_printer = common_thread.select_printer()
				// If the user didn't select a printer then don't do anything
				if isnull(ls_printer) then return 1
				ls_destination = "PRINTER"
				// add the selected printer to the report attributes
				f_attribute_add_attribute(lstr_attributes, "printer", ls_printer)
			CASE "SERVER"
				// First add the local office_id so that the server knows which printer to use
				ls_attribute = "office_id"
				ls_value = office_id
				sqlca.sp_add_workplan_item_attribute( &
						ls_cpr_id, &
						ll_patient_workplan_id, &
						patient_workplan_item_id, &
						ls_attribute, &
						ls_value, &
						current_scribe.user_id, &
						current_user.user_id)
				If not tf_check() then return -1
			
				// Then add the local computer_id so that the server knows which printer to use
				ls_attribute = "computer_id"
				ls_value = string(computer_id)
				sqlca.sp_add_workplan_item_attribute( &
						ls_cpr_id, &
						ll_patient_workplan_id, &
						patient_workplan_item_id, &
						ls_attribute, &
						ls_value, &
						current_scribe.user_id, &
						current_user.user_id)
				If not tf_check() then return -1
			
				// Forward service to EncounterPRO system user
				sqlca.sp_forward_todo_service( &
						patient_workplan_item_id, &
						ls_from_user_id, &
						server_user_id, &
						ls_description, &
						ls_service, &
						current_scribe.user_id, &
						ls_null)
				If not tf_check() then return -1
			
				// return success so this service is completed
				return 1
			CASE "RECIPIENT"
				// If the user selected a recipient, then order this report as a documernt and send it to the specified recipient
				add_attribute("ordered_for", reader_user_id)
				ll_patient_workplan_item_id = order_document()
				if ll_patient_workplan_item_id <= 0 then return -1
				luo_document = CREATE u_component_wp_item_document
				
				li_sts = luo_document.initialize(ll_patient_workplan_item_id)
				openwithparm(w_svc_documents, luo_document)
				
				return 1
			CASE "BEBACK"
				return 0
			CASE "CANCEL"
				return 1
			CASE "CANCELSERVICE"
				return 2
			CASE ELSE
				return 0
		END CHOOSE
	End If
else
	ls_destination = "PRINTER"
End If // cpr_mode = "CLIENT"

// If we found an office, then pass it in to the report component
if not isnull(ls_report_office_id) then
	f_attribute_add_attribute(lstr_attributes, "office_id", ls_report_office_id)
end if

// If we found a printer, then pass it in to the report component
if not isnull(ls_printer) then
	f_attribute_add_attribute(lstr_attributes, "printer", ls_printer)
end if

f_attribute_add_attribute(lstr_attributes, "DESTINATION", ls_destination)

li_sts = luo_report.printreport(ls_report_id, lstr_attributes)
if li_sts > 0 then
	if ls_Manage_Document = "Attach Document" then
		if len(luo_report.document_file.attachment) > 0 then
			lstr_attachment = luo_report.document_file

			ls_progress_type = get_attribute("progress_type")
			if isnull(ls_progress_type) then ls_progress_type = "Attachment"
			
			ls_progress_key = get_attribute("progress_key")
			if isnull(ls_progress_key) then ls_progress_key = "Document"
			
			// We have the document, now persist it by creating an attachment
			ll_attachment_id = f_new_attachment(context_object, &
															object_key, &
															ls_progress_type, &
															ls_progress_key, &
															lstr_attachment.extension, &
															lstr_attachment.attachment_type, &
															lstr_attachment.attachment_comment_title, &
															lstr_attachment.filename, &
															lstr_attachment.attachment &
															)
			if ll_attachment_id < 0 then
				log.log(this, "xx_do_service()", "Error creating new attachment", 4)
				return -1
			end if
		else
			log.log(this, "xx_do_service()", "Report completed successfully but did not produce a document.  Make sure this report component (" &
			 + luo_report.component_id + ") is capable of producing a document.  No document will be attached.", 3)
		end if
	end if
end if

component_manager.destroy_component(luo_report)

if li_sts < 0 then return -1

boolean lb_suppress_beback
get_attribute("Suppress Be back Popup", lb_suppress_beback)
if cpr_mode = "CLIENT" and not manual_service and not lb_suppress_beback Then
	// Now ask the user if they're done
	popup.data_row_count = 2
	popup.items[1] = "I'll Be Back"
	popup.items[2] = "I'm Finished"
	openwithparm(w_pop_pick, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then
		return 0
	else
		if popup_return.item_indexes[1] = 1 then
			return 0
		else
			return 1
		end if
	end if
end if

Return 1

end function

public function integer configure_report (u_component_report puo_report, str_attributes pstr_attributes);str_popup popup
w_report_configure_and_test lw_window


f_attribute_add_attribute(pstr_attributes, "DESTINATION", "SCREEN")

// Get the report attributes from the tables
puo_report.get_report_attributes(office_id)

popup.objectparm1 = puo_report
popup.objectparm2 = pstr_attributes

openwithparm(lw_window, popup, "w_report_configure_and_test")

return 1

end function

public function string pick_route (string ps_document_purpose, string ps_ordered_for);str_popup popup
str_popup_return popup_return
string ls_document_route

setnull(ls_document_route)

popup.dataobject = "dw_document_valid_routes_pick"
popup.datacolumn = 1
popup.displaycolumn = 1
popup.auto_singleton = false
popup.add_blank_row = true
popup.blank_text = "<Show All Routes>"
popup.blank_at_bottom = true
popup.argument_count = 5
popup.argument[1] = current_user.user_id
popup.argument[2] = ps_ordered_for
popup.argument[3] = ps_document_purpose
popup.argument[4] = cpr_id
popup.argument[5] = get_attribute("report_id")
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count = 1 then
	if popup_return.items[1] = "" then
		// There were no choices so show the routes
		popup.data_row_count = 5
		popup.title = "All Routes"
		popup.add_blank_row = false
		popup.items[1] = current_user.user_id
		popup.items[2] = ps_ordered_for
		popup.items[3] = ps_document_purpose
		popup.items[4] = cpr_id
		popup.items[5] = get_attribute("report_id")
		openwithparm(w_pop_document_routes, popup)
	else
		ls_document_route = popup_return.items[1]
	end if
end if

if popup_return.choices_count <= 0 then
	// There were no choices so show the routes
	popup.data_row_count = 5
	popup.title = "No valid Routes"
	popup.items[1] = current_user.user_id
	popup.items[2] = ps_ordered_for
	popup.items[3] = ps_document_purpose
	popup.items[4] = cpr_id
	popup.items[5] = get_attribute("report_id")
	openwithparm(w_pop_document_routes, popup)
end if

return ls_document_route



end function

public function string pick_recipient (string ps_document_purpose);string ls_new_ordered_for
string ls_new_dispatch_method
string ls_address_attribute
string ls_address_value
u_component_route luo_sender
integer li_sts
str_pick_users lstr_pick_users
str_popup popup
str_popup_return popup_return
string ls_actor_class
string ls_document_subtype



setnull(ls_new_ordered_for)
setnull(ls_new_dispatch_method)

ls_document_subtype = "Report"

///////////////////////////////////////////////////////////////////
// Pick new ordered_for
///////////////////////////////////////////////////////////////////

// If there's no purpose, then pick a purpose
if isnull(ps_document_purpose) then
	popup.argument_count = 1
	popup.argument[1] = context_object
	popup.dataobject = "dw_c_document_purpose_pick_list"
	popup.datacolumn = 1
	popup.displaycolumn = 2
	popup.title = "Select Document Purpose"
	openwithparm(w_pop_pick, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return ls_new_ordered_for
	
	ps_document_purpose = popup_return.items[1]

	set_attribute("purpose", ps_document_purpose)
end if

// Pick the actor class
popup.dataobject = "dw_actor_class_for_purpose"
popup.datacolumn = 1
popup.displaycolumn = 1
popup.auto_singleton = true
popup.argument_count = 1
popup.argument[1] = ps_document_purpose
popup.title = "Select Recipient Class"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then
	// If there were any choices then the user clicked "Cancel"
	if popup_return.choices_count > 0 then return ls_new_ordered_for
	
	// If there were no choices, then have the user pick between user and patient
	popup.dataobject = ""
	popup.datacolumn = 0
	popup.displaycolumn = 0
	popup.auto_singleton = false
	popup.argument_count = 0
	popup.title = "Select Recipient Class"
	popup.data_row_count = 2
	popup.items[1] = "User"
	popup.items[2] = "Patient"
	openwithparm(w_pop_pick, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return ls_new_ordered_for
end if
ls_actor_class = popup_return.items[1]

// Pick the specific recipient
if lower(ls_actor_class)  = "patient" then
	ls_new_ordered_for = "#PATIENT"
else
	lstr_pick_users.cpr_id = cpr_id
	if lower(ls_actor_class) <> "user" then
		lstr_pick_users.hide_users = true
		lstr_pick_users.actor_class = ls_actor_class
	end if
	lstr_pick_users.pick_screen_title = "Select " + wordcap(ls_actor_class)
	li_sts = user_list.pick_users(lstr_pick_users)
	if li_sts <= 0 then return ls_new_ordered_for
	
	ls_new_ordered_for = lstr_pick_users.selected_users.user[1].user_id
end if

return ls_new_ordered_for


end function

private function long order_document ();string ls_temp
long i
long ll_patient_workplan_item_id
string ls_report_id
string ls_dispatch_method
string ls_ordered_for
long ll_patient_workplan_id
string ls_description
string ls_report_description
string ls_purpose
boolean lb_create_now
boolean lb_send_now
string ls_create_from
string ls_send_from
integer li_sts
u_ds_data luo_data
long ll_count
string ls_ordered_by
string ls_default_dispatch_method
boolean lb_found
string ls_folder
string ls_document_format
boolean lb_suppress
long ll_interfaceserviceid
string ls_document_type
string ls_auto_cancel_when_no_document
str_attributes lstr_attributes

get_attribute("report_id", ls_report_id)
if isnull(ls_report_id) then
	log.log(this, "xx_do_serfvice()", "No report_id", 4)
	return -1
end if

SELECT description, document_format
INTO :ls_report_description, :ls_document_format
FROM c_Report_Definition
WHERE report_id = :ls_report_id;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then
	log.log(this, "xx_do_serfvice()", "report_id not found (" + ls_report_id + ")", 4)
	return -1
end if

ls_ordered_by = current_user.user_id
if left(ls_ordered_by, 1) = "#" then
	// if the current user is a special user, then use who ordered the report service
	ls_ordered_by = this.ordered_by
end if

get_attribute("ordered_for", ls_ordered_for)
get_attribute("folder", ls_folder)
get_attribute("dispatch_method", ls_dispatch_method)
get_attribute("document_description", ls_description)
get_attribute("create_now", lb_create_now)
get_attribute("send_now", lb_send_now)
get_attribute("create_from", ls_create_from)
get_attribute("send_from", ls_send_from)
get_attribute("purpose", ls_purpose)
get_attribute("interfaceserviceid", ll_interfaceserviceid)
get_attribute("document_type", ls_document_type)
get_attribute("auto_cancel_when_no_document", ls_auto_cancel_when_no_document)



if isnull(ls_purpose) then
	if lower(ls_document_format) = "machine" then
		ls_purpose = context_object + " Data"
	else
		ls_purpose = context_object + " Report"
	end if
end if

ll_patient_workplan_id = 0


if cpr_mode = "CLIENT" and lb_send_now then
	// If the caller wants to send the document now, make sure we have a recipient
	if isnull(ls_ordered_for) then
		ls_ordered_for = pick_recipient(ls_purpose)
	end if

	if not isnull(ls_ordered_for) and isnull(ls_dispatch_method) then
		ls_dispatch_method = pick_route(ls_purpose, ls_ordered_for)
	end if
end if

// If the caller didn't specify a description the use the name of the report
if isnull(ls_description) then
	CHOOSE CASE lower(context_object)
		CASE "general"
			if len(ls_purpose) > 0 then
				ls_description = "%purpose%"
			else
				ls_description = "%report_description%"
			end if
		CASE "patient"
			if len(ls_purpose) > 0 then
				ls_description = "%purpose%"
			else
				ls_description = "%report_description%"
			end if
		CASE "encounter"
			if len(ls_purpose) > 0 then
				ls_description = "%purpose% for %encounter encounter_description%"
			else
				ls_description = "%report_description% for %encounter encounter_description%"
			end if
		CASE "assessment"
			if len(ls_purpose) > 0 then
				ls_description = "%purpose% for %assessment assessment%"
			else
				ls_description = "%report_description% for %assessment assessment%"
			end if
		CASE "treatment"
			if len(ls_purpose) > 0 then
				ls_description = "%purpose% for %treatment treatment_description%"
			else
				ls_description = "%report_description% for %treatment treatment_description%"
			end if
		CASE ELSE
			if len(ls_purpose) > 0 then
				ls_description = "%purpose%"
			else
				ls_description = "%report_description%"
			end if
	END CHOOSE
end if

ls_description = f_string_substitute(ls_description, "%purpose%", ls_purpose)
ls_description = f_string_substitute(ls_description, "%report_description%", ls_report_description)
ls_description = f_attribute_value_substitute_string(ls_description, f_get_complete_context(), get_attributes())

if report_configured then
	lstr_attributes = report_runtime_attributes
end if

if len(ls_document_type) > 0 then
	f_attribute_add_attribute(lstr_attributes, "document_type", ls_document_type)
end if

if len(ls_folder) > 0 then
	f_attribute_add_attribute(lstr_attributes, "folder", ls_folder)
end if

if ll_interfaceserviceid >= 0 then
	f_attribute_add_attribute(lstr_attributes, "interfaceserviceid", string(ll_interfaceserviceid))
end if

// Pass through the auto-cancel flag
if len(ls_auto_cancel_when_no_document) > 0 then
	f_attribute_add_attribute(lstr_attributes, "auto_cancel_when_no_document", ls_auto_cancel_when_no_document)
end if
	

ll_patient_workplan_item_id = f_order_document( cpr_id, &
									encounter_id, &
									context_object, &
									object_key, &
									ls_report_id, &
									ls_dispatch_method, &
									ls_ordered_for, &
									current_user.user_id, &
									ls_description, &
									ls_purpose, &
									lb_create_now, &
									lb_send_now, &
									ls_create_from, &
									ls_send_from, &
									report_configured, &
									lstr_attributes)
if ll_patient_workplan_item_id <= 0 then
	openwithparm(w_pop_message, "Error Ordering Document")
	return -1
end if

get_attribute("Suppress Order Success Message", ls_temp)
if isnull(ls_temp) then
	lb_suppress = datalist.get_preference_boolean("WORKFLOW", "Suppress Document Order Success Message", false)
else
	lb_suppress = f_string_to_boolean(ls_temp)
end if

if not lb_suppress then
	openwithparm(w_pop_message, "Successfully Ordered Document ~"" + ls_description + "~"")
end if


return ll_patient_workplan_item_id

end function

on u_component_service_report.create
call super::create
end on

on u_component_service_report.destroy
call super::destroy
end on

