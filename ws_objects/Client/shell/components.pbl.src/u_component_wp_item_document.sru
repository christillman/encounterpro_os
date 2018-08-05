$PBExportHeader$u_component_wp_item_document.sru
forward
global type u_component_wp_item_document from u_component_workplan_item
end type
end forward

global type u_component_wp_item_document from u_component_workplan_item
end type
global u_component_wp_item_document u_component_wp_item_document

type variables
boolean viewing_document = false

boolean document_created
boolean failed_mappings

end variables

forward prototypes
public function integer document_view ()
public function integer document_create ()
public function integer document_cancel ()
public function integer document_confirm_receipt ()
public function integer document_send ()
public function integer run_report (string ps_report_id, ref str_external_observation_attachment pstr_document_file)
public function integer document_sign ()
public function string document_subtype ()
public function integer document_edit ()
public function integer document_set_recipient (string ps_ordered_for)
public function integer document_configure ()
public function integer document_send (boolean pb_send_from_here)
private function integer document_send_set_ready ()
private function integer document_send_now ()
private function integer document_send_now_old ()
public function integer document_pick_address ()
public function integer document_pick_recipient ()
public function integer document_set_recipient (string ps_ordered_for, string ps_dispatch_method, string ps_address_attribute, string ps_address_value)
public function integer document_pick_dispatch_method ()
private function string pick_dispatch_method (string ps_new_ordered_for)
private function integer route_component (string ps_dispatch_method, ref u_component_route puo_route)
public subroutine show_routes (string ps_ordered_for, string ps_message)
public subroutine show_routes (string ps_message)
public subroutine document_error (string ps_operation)
public function integer get_document (ref str_external_observation_attachment pstr_document)
public function integer document_reset ()
public subroutine edit_mappings ()
public function integer get_document (ref str_document_file pstr_document)
public subroutine document_display_properties ()
public function integer initialize (long pl_patient_workplan_item_id)
public function string document_mapping_status ()
protected subroutine set_document_status ()
public function string document_interface_name ()
public function integer document_view (boolean pb_allow_create)
public function integer clear_attachment ()
end prototypes

public function integer document_view ();return document_view(true)

end function

public function integer document_create ();integer li_sts
string ls_progress_type
string ls_progress_key
long ll_attachment_id
string ls_report_id
str_external_observation_attachment lstr_document_file
long ll_material_id
string ls_document_type
string ls_folder

// Clear mapping records.  Creating document will regenerate current mapping records
DELETE m
FROM x_Document_Mapping m
WHERE patient_workplan_item_id = :patient_workplan_item_id;
if not tf_check() then return -1

document_created = false

ls_report_id = get_attribute("report_id")
if isnull(ls_report_id) then
	get_attribute("material_id", ll_material_id)
	if isnull(ll_material_id) then
		log.log(this, "u_component_wp_item_document.document_create:0023", "No report_id", 4)
		document_error("Create")
		return -1
	end if
	ls_document_type = "Material"
else
	ls_document_type = "Report"
end if

CHOOSE CASE lower(ls_document_type)
	CASE "report"
		li_sts = run_report(ls_report_id, lstr_document_file)
		if li_sts < 0 then
			log.log(this, "u_component_wp_item_document.document_create:0036", "Error running report (" + ls_report_id + ")", 4)
			document_error("Create")
			return -1
		end if
		if isnull(lstr_document_file.attachment) or len(lstr_document_file.attachment) <= 0 then
			log.log(this, "u_component_wp_item_document.document_create:0041", "Document ran successfully but returned no data (" + ls_report_id + ")", 3)
			return 0
		end if
		
		ls_progress_type = get_attribute("progress_type")
		if isnull(ls_progress_type) then ls_progress_type = "Attachment"
		
		ls_progress_key = get_attribute("progress_key")
		if isnull(ls_progress_key) then ls_progress_key = "Document"
		
		ls_folder = get_attribute("folder")
		
		// We have the document, now persist it by creating an attachment
		ll_attachment_id = f_new_attachment_2(cpr_id, &
														context_object, &
														object_key, &
														ls_progress_type, &
														ls_progress_key, &
														lstr_document_file.extension, &
														lstr_document_file.attachment_type, &
														lstr_document_file.attachment_comment_title, &
														lstr_document_file.filename, &
														lstr_document_file.attachment, &
														ls_folder &
														)
		if ll_attachment_id < 0 then
			log.log(this, "u_component_wp_item_document.document_create:0067", "Error creating new attachment", 4)
			document_error("Create")
			return -1
		end if
		
		add_attribute( "attachment_id", string(ll_attachment_id))
		attachment_id = ll_attachment_id
		
		li_sts = set_progress("Document Created")
		if li_sts < 0 then
			log.log(this, "u_component_wp_item_document.document_create:0077", "Error setting 'created' progress", 4)
			document_error("Create")
			return -1
		end if
		
		save_wp_item_attributes()
	CASE "material"
END CHOOSE

set_document_status()

return 1


end function

public function integer document_cancel ();integer li_sts

li_sts = set_progress("Cancelled")
if li_sts < 0 then
	log.log(this, "u_component_wp_item_document.document_cancel:0005", "Error setting 'cancelled' progress", 4)
	return -1
end if

return 1

end function

public function integer document_confirm_receipt ();integer li_sts

li_sts = set_progress("Success")
if li_sts < 0 then
	log.log(this, "u_component_wp_item_document.document_confirm_receipt:0005", "Error setting 'Success' progress", 4)
	return -1
end if

return 1

end function

public function integer document_send ();boolean lb_send_from_here
string ls_send_from
string ls_preferred_server

// See if there is a server to send this from
ls_preferred_server = datalist.get_preference("SERVERCONFIG	", "Preferred Server")
if isnull(ls_preferred_server) then
	// If there is no server for this installation, then all documents must be printed locally
	return document_send(true)
end if
	
// See if the document has send_from instructions
ls_send_from = get_attribute("send_from")
if isnull(ls_send_from) then
	// If the send_from attribute is not explicetely set for this document then get the default value from the route
	SELECT send_from
	INTO :ls_send_from
	FROM dbo.fn_document_route_information(:dispatch_method);
	if not tf_check() then return -1
	if sqlca.sqlnrows <> 1 then
		log.log(this, "u_component_wp_item_document.document_send:0021", "Invalid dispatch_method (" + dispatch_method + ")", 4)
		return -1
	end if
end if

if cpr_mode = "CLIENT" THEN
	// See if the preference is set to send everything from the client
	lb_send_from_here = datalist.get_preference_boolean("SYSTEM", "Document Send All From Client", false)
	if not lb_send_from_here then
		// The preference is not set so look at the send_from attribute
		if lower(ls_send_from) = "client" then
			lb_send_from_here = true
		end if
	end if
else
	// if we're on the server and the attribute says send from the client then return an error
	if lower(ls_send_from) = "client" then
		log.log(this, "u_component_wp_item_document.document_send:0038", "Unable to send this document because it must be sent from a client (" + string(patient_workplan_item_id) + ")", 4)
		return -1
	else
		lb_send_from_here = true
	end if
end if

return document_send(lb_send_from_here)


end function

public function integer run_report (string ps_report_id, ref str_external_observation_attachment pstr_document_file);String					buttons[]
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
string ls_report_type
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
string ls_null
u_user luo_reader
boolean lb_loop
string ls_this_document_format
string ls_required_document_format
long ll_max_attribute_sequence
string ls_linked_report_attribute
string ls_linked_report_id

setnull(ls_cpr_id)
setnull(ll_patient_workplan_id)
setnull(ls_from_user_id)
setnull(ls_description)
setnull(ls_service)
setnull(ls_null)

if isnull(ps_report_id) then
	log.log(this, "u_component_wp_item_document.run_report:0044", "Null report_id", 4)
	return -1
end if

// Get the document format
SELECT document_format
INTO :ls_this_document_format
FROM c_Report_Definition
WHERE report_id = :ps_report_id;
If Not tf_check() Then Return -1
if sqlca.sqlnrows = 0 then
	log.log(this, "u_component_wp_item_document.run_report:0055", "report_id not found (" + ps_report_id + ")", 4)
	return -1
end if

// If the dispatch_method is not supplied then see if there is a valid one for this report format/recipient
if isnull(dispatch_method) then
	SELECT TOP 1 r.document_route
	INTO :dispatch_method
	FROM c_Actor_Class_Route r
		INNER JOIN c_User u
		ON u.actor_class = r.actor_class
	WHERE u.user_id = :ordered_for
	AND document_format = :ls_this_document_format;
	if not tf_check() then return -1
	if sqlca.sqlnrows = 0 then
		log.log(this, "u_component_wp_item_document.run_report:0070", "No dispatch_method is supplied and this recipients actor_class does not imply one", 4)
		return -1
	end if
	
	sqlca.sp_add_workplan_item_attribute( cpr_id, &
														patient_workplan_id, &
														patient_workplan_item_id, &
														"dispatch_method", &
														dispatch_method, &
														current_scribe.user_id, &
														current_user.user_id)
	
	UPDATE p_Patient_WP_Item
	SET dispatch_method = :dispatch_method
	WHERE patient_workplan_item_id = :patient_workplan_item_id;
	if not tf_check() then return -1
end if


SELECT document_format
INTO :ls_required_document_format
FROM c_Document_Route
WHERE document_route = :dispatch_method;
if not tf_check() then return -1
if sqlca.sqlnrows = 0 then
	log.log(this, "u_component_wp_item_document.run_report:0095", "dispatch_method not valid (" + dispatch_method + ")", 4)
	return -1
end if

if lower(ls_this_document_format) <> lower(ls_required_document_format) and not viewing_document then
	// The required document format doesn't match the document format of the passed in report
	// We can resolve this if the passed in report has a link to a report of the correct format
	ls_linked_report_attribute = ls_required_document_format + "_report_id"
	
	SELECT max(attribute_sequence)
	INTO :ll_max_attribute_sequence
	FROM c_Report_Attribute
	WHERE report_id = :ps_report_id
	AND attribute = :ls_linked_report_attribute;
	if not tf_check() then return -1
	
	if isnull(ll_max_attribute_sequence) then
		log.log(this, "u_component_wp_item_document.run_report:0112", "A " + ls_required_document_format + " readable document is required", 4)
		return -1
	end if
	
	SELECT value
	INTO :ls_linked_report_id
	FROM c_Report_Attribute
	WHERE report_id = :ps_report_id
	AND attribute = :ls_linked_report_attribute
	AND attribute_sequence = :ll_max_attribute_sequence;
	if not tf_check() then return -1
	
	ps_report_id = ls_linked_report_id
end if


// Now run the appropriate report

// Get the component_id and the SQL query
SELECT component_id, sql
INTO :ls_component_id, :ls_sql
FROM c_Report_Definition
WHERE report_id = :ps_report_id;
If Not tf_check() Then Return -1

If cpr_mode = "CLIENT" and not f_string_to_boolean(runtime_configured_flag) Then
	li_sts = f_get_params(ps_report_id, "Runtime", lstr_attributes)
	if li_sts < 0 then return 0

	add_attributes(lstr_attributes)
	
	runtime_configured_flag = "Y"
	UPDATE p_Patient_WP_Item
	SET runtime_configured_flag = 'Y'
	WHERE patient_workplan_item_id = :patient_workplan_item_id;
	if not tf_check() then return -1
end if

// If we have a SQL script then perform any required substitutions and add it to the attributes.
if not isnull(ls_sql) then
	ls_sql = f_string_substitute_attributes(ls_sql, get_attributes())
	add_attribute("SQLQUERY", ls_sql)
end if

ls_destination = "FILE"

// If any component defined for selected report then
If Isnull(ls_component_id) Then
	mylog.log(this, "u_component_wp_item_document.run_report:0160", "Null component_id (" + ps_report_id + ")", 4)
	Return -1
Else
	luo_report = component_manager.get_component(ls_component_id)
	If Isnull(luo_report) Then
		mylog.log(This, "u_component_wp_item_document.run_report:0165", "Error getting report component (" + &
					ls_component_id + ")", 4)
		Return -1
	End If
End If

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

// Get the attributes for this service
lstr_attributes = get_attributes()
mylog.log(this, "u_component_wp_item_document.run_report:0190","processing report ("+ps_report_id+") on mode "+cpr_mode,1)

if len(cpr_id) > 0 then
	f_attribute_add_attribute(lstr_attributes, "cpr_id", cpr_id)
end if

// If we found an office, then pass it in to the report component
if not isnull(ls_report_office_id) then
	f_attribute_add_attribute(lstr_attributes, "office_id", ls_report_office_id)
end if

// If we found a printer, then pass it in to the report component
if not isnull(ls_printer) then
	f_attribute_add_attribute(lstr_attributes, "printer", ls_printer)
end if

f_attribute_add_attribute(lstr_attributes, "DESTINATION", ls_destination)

// Inform the report and all of it's called object of which workplan item is triggering this document creation
f_attribute_add_attribute(lstr_attributes, "document_patient_workplan_item_id", string(patient_workplan_item_id))

// Add some properties of the document to the report attributes
f_attribute_add_attribute(lstr_attributes, "Document ordered_for", ordered_for)

luo_report.printreport(ps_report_id, lstr_attributes)
if luo_report.printreport_status > 0 then
	if len(luo_report.document_file.attachment) > 0 then
		pstr_document_file = luo_report.document_file
		li_sts = 1
	else
		log.log(this, "u_component_wp_item_document.run_report:0220", "The report/datafile returned success but no report document is found + (" + ps_report_id + ")", 4)
		li_sts = -1
	end if
elseif luo_report.printreport_status = 0 then
	// See if we're supposed to automatically cancel this document if no document is returned
	boolean lb_auto_cancel_when_no_document
	get_attribute("auto_cancel_when_no_document", lb_auto_cancel_when_no_document)
	if lb_auto_cancel_when_no_document then
		document_cancel()
		li_sts = 0
	else
		log.log(this, "u_component_wp_item_document.run_report:0231", "The report/datafile returned no documents + (" + ps_report_id + ")", 4)
		li_sts = -1
	end if
else
	log.log(this, "u_component_wp_item_document.run_report:0235", "The report/datafile returned an error + (" + ps_report_id + ")", 4)
	li_sts = -1
end if

component_manager.destroy_component(luo_report)

if li_sts < 0 then return -1

Return li_sts

end function

public function integer document_sign ();integer li_sts

li_sts = set_progress("Signed")
if li_sts < 0 then
	log.log(this, "u_component_wp_item_document.document_sign:0005", "Error setting 'signed' progress", 4)
	return -1
end if

return 1

end function

public function string document_subtype ();long ll_material_id
string ls_report_id
string ls_null

setnull(ls_null)

// If we already have an attachment_id then this document is treated as a report subtype
if attachment_id > 0 then return "Report"

// If we didn't have an attachment_id then see if we have a report_id
ls_report_id = get_attribute("report_id")
if isnull(ls_report_id) then
	// If we have no report_id then see if we have a material_id
	get_attribute("material_id", ll_material_id)
	if isnull(ll_material_id) then
		log.log(this, "u_component_wp_item_document.document_subtype:0016", "No report_id or material_id", 4)
		return ls_null
	end if
	return "Material"
else
	return "Report"
end if


end function

public function integer document_edit ();long ll_pos
string ls_purpose
integer li_sts
string ls_before_status
string ls_after_status
long ll_new_object_key
string ls_old_description
string ls_new_description
string ls_new_document_description

CHOOSE CASE lower(context_object)
	CASE "treatment"
		SELECT COALESCE(treatment_status, 'OPEN'), treatment_description
		INTO :ls_before_status, :ls_old_description
		FROM p_Treatment_Item
		WHERE cpr_id = :cpr_id
		AND treatment_id = :object_key;
		if not tf_check() then return -1
END CHOOSE

li_sts = show_dashboard()
if li_sts <= 0 then return li_sts

// If we already had a document then clear it so it will be regenerated
if document_created then
	clear_attachment()
end if

ls_purpose = get_attribute("purpose")

CHOOSE CASE lower(context_object)
	CASE "treatment"
		SELECT COALESCE(treatment_status, 'OPEN')
		INTO :ls_after_status
		FROM p_Treatment_Item
		WHERE cpr_id = :cpr_id
		AND treatment_id = :object_key;
		if not tf_check() then return -1
		
		if lower(ls_before_status) <> "modified" and lower(ls_after_status) = "modified" then
			// The treatment was modified during the edit.  Change the context of this document to reflect the new treatment
			SELECT max(treatment_id)
			INTO :ll_new_object_key
			FROM p_Treatment_Item
			WHERE cpr_id = :cpr_id
			AND original_treatment_id = :object_key;
			if not tf_check() then return -1
			
			if ll_new_object_key > 0 then
				// We have a new treatment_id
				
				// First, update this document
				set_attribute("treatment_id", string(ll_new_object_key))
			end if
		end if
			
		// Then, update the name of this document
		SELECT treatment_description
		INTO :ls_new_description
		FROM p_Treatment_Item
		WHERE cpr_id = :cpr_id
		AND treatment_id = :treatment_id;
		if not tf_check() then return -1
		
		if ls_old_description <> ls_new_description then
			if len(ls_purpose) > 0 then
				ls_new_document_description = ls_purpose + " for " + ls_new_description
				set_attribute("description", ls_new_document_description)
			end if
		end if
END CHOOSE

return 1

end function

public function integer document_set_recipient (string ps_ordered_for);
if isnull(ps_ordered_for) or ps_ordered_for = "" then return 0

if lower(ps_ordered_for) = lower(ordered_for) then
	return 1
end if

UPDATE p_Patient_WP_Item
SET ordered_for = :ps_ordered_for
WHERE patient_workplan_item_id = :patient_workplan_item_id;
if not tf_check() then return -1

ordered_for = ps_ordered_for

return 1


end function

public function integer document_configure ();w_window_base lw_window

openwithparm(lw_window, this, "w_report_configure_and_test")

return 1

end function

public function integer document_send (boolean pb_send_from_here);string ls_create_from
integer li_sts

ls_create_from = get_attribute("create_from")

if lower(status) = "error" then
	set_progress("Resend")
	clear_attachment()
end if

// If we're on the client and we need to create the document from the client and the document is not created then create it now
if cpr_mode = "CLIENT" and not document_created and lower(ls_create_from) = "client" then
	li_sts = document_create()
end if

if pb_send_from_here then
	// Send right now
	return document_send_now()
else
	// Send from the server
	return document_send_set_ready()
end if

return 0

end function

private function integer document_send_set_ready ();integer li_sts

li_sts = set_progress("Ready")
if li_sts < 0 then
	log.log(this, "u_component_wp_item_document.document_send_set_ready:0005", "Error setting 'Ready' progress (" + string(patient_workplan_item_id) + ")", 4)
	return -1
end if

return 1

end function

private function integer document_send_now ();integer li_sts
string ls_report_id
string ls_default_dispatch_method
string ls_purpose
string ls_default_ordered_for
string ls_default_address_attribute
string ls_default_address_value
u_component_route luo_sender


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Make sure we have enough recipient information by filling in any missing info with defaults
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Get attributes needed to determine default recipient/route
get_attribute("report_id", ls_report_id)
get_attribute("purpose", ls_purpose)

// Make sure we have a recipient (ordered_for) and a route (dispatch_method)
if isnull(ordered_for) or isnull(dispatch_method) or trim(dispatch_method) = "" then
	SELECT ordered_for,
			document_route,
			address_attribute,
			address_value
	INTO :ls_default_ordered_for,
			:ls_default_dispatch_method,
			:ls_default_address_attribute,
			:ls_default_address_value
	FROM dbo.fn_document_default_recipient(:cpr_id ,
											:encounter_id ,
											:context_object ,
											:object_key ,
											:ls_report_id ,
											:ls_purpose ,
											:ordered_by ,
											:ordered_for ,
											:dispatch_method);
	if not tf_check() then
		document_error("Send")
		return -1
	end if
	
	document_set_recipient(ls_default_ordered_for, ls_default_dispatch_method, ls_default_address_attribute, ls_default_address_value)
end if


////////////////////////////////////////////////////
// Get the route sender component
////////////////////////////////////////////////////

li_sts = route_component(dispatch_method, luo_sender)
if li_sts <= 0 then
	log.log(this, "u_component_wp_item_document.document_send_now:0053", "Error sending document: Unable to get sender component (" + string(patient_workplan_item_id) + ")", 4)
	document_error("Send")
	return -1
end if

////////////////////////////////////////////////////
// Send the document
////////////////////////////////////////////////////

li_sts = luo_sender.send_document(this)
if li_sts < 0 then
	log.log(this, "u_component_wp_item_document.document_send_now:0064", "Error sending document: sender component returned error (" + string(patient_workplan_item_id) + ")", 4)
	document_error("Send")
	return -1
elseif li_sts > 0 then
	////////////////////////////////////////////////////
	// Log the document as "Sent"
	////////////////////////////////////////////////////
	
	li_sts = set_progress("Sent")
	if li_sts < 0 then
		log.log(this, "u_component_wp_item_document.document_send_now:0074", "Error setting 'sent' progress", 4)
		document_error("Send")
		return -1
	end if
end if

DESTROY luo_sender

return 1

end function

private function integer document_send_now_old ();//string ls_temp
//long ll_attachment_id
//boolean lb_auto_create
//boolean lb_recreate_on_send
//integer li_sts
//str_external_observation_attachment lstr_attachment
//string ls_document_type
//long ll_addressee
//long ll_material_id
//string ls_item_subtype
//str_patient_material lstr_material
//string ls_printer
//integer li_wait
//str_attributes lstr_attributes
//string ls_report_id
//string ls_dispatch_method
//string ls_purpose
//string ls_ordered_for
//string ls_address_attribute
//string ls_address_value
//long ll_transportsequence
//string ls_sender_component_id
//u_ds_data luo_data
//long ll_attribute_count
//long ll_attachment_location_id
//string ls_send_to_directory
//str_attachment_location lstr_attachment_location
//string ls_save_path
//string ls_filename_prefix
//boolean lb_cover_letter
//
//// Either we have an attachment_id or a material_id to send
//get_attribute("report_id", ls_report_id)
//get_attribute("material_id", ll_material_id)
//get_attribute("purpose", ls_purpose)
//
//ls_item_subtype = document_subtype( )
//
//CHOOSE CASE lower(ls_item_subtype)
//	CASE "report"
//		get_attribute("attachment_id", ll_attachment_id)
//		get_attribute("recreate_on_send", lb_recreate_on_send, true)
//
//		if upper(status) <> "READY" then
//			if isnull(ll_attachment_id) or ll_attachment_id <= 0 or lb_recreate_on_send then
//				get_attribute("auto_create", lb_auto_create, true)
//				if lb_auto_create or lb_recreate_on_send then
//					li_sts = document_create()
//					if li_sts <= 0 then return li_sts
//					get_attribute("attachment_id", ll_attachment_id)
//					if isnull(ll_attachment_id) then
//						log.log(this, "u_component_wp_item_document.document_send_now_old:0052", "Document created but not found", 4)
//						return -1
//					end if
//				else
//					log.log(this, "u_component_wp_item_document.document_send_now_old:0056", "Document not found", 4)
//					return -1
//				end if
//			end if
//		elseif isnull(ll_attachment_id) then
//			log.log(this, "u_component_wp_item_document.document_send_now_old:0061", "Status is 'Ready' but document not found (" + string(patient_workplan_item_id) + ")", 4)
//			return -1
//		end if
//		
//		SELECT ordered_for,
//				document_route,
//				address_attribute,
//				address_value
//		INTO :ls_ordered_for,
//				:ls_dispatch_method,
//				:ls_address_attribute,
//				:ls_address_value
//		FROM dbo.fn_document_default_recipient(:cpr_id ,
//												:encounter_id ,
//												:context_object ,
//												:object_key ,
//												:ls_report_id ,
//												:ls_purpose ,
//												:ordered_by ,
//												:ordered_for ,
//												:dispatch_method);
//		if not tf_check() then return -1
//		
//		if isnull(ordered_for) then
//			setnull(dispatch_method)
//			document_set_recipient(ls_ordered_for)
//		end if
//
//		// Make sure we have a route (dispatch_method)
//		if isnull(dispatch_method) or trim(dispatch_method) = "" then
//			document_set_route(ls_dispatch_method, ls_address_attribute, ls_address_value)
//		end if
//
//		// Get information about this route
//		SELECT send_via_addressee, document_type, transportsequence, sender_component_id
//		INTO :ll_addressee, :ls_document_type, :ll_transportsequence, :ls_sender_component_id
//		FROM dbo.fn_document_route_information(:dispatch_method);
//		if not tf_check() then return -1
//		if sqlca.sqlnrows <> 1 then
//			log.log(this, "u_component_wp_item_document.document_send_now_old:0100", "Invalid dispatch_method (" + dispatch_method + ")", 4)
//			return -1
//		end if
//		
//		CHOOSE CASE lower(ls_sender_component_id)
//			CASE "sender_printer"
//				ls_printer = get_attribute("Printer")
//				if len(ls_printer) > 0 then
//					f_attribute_add_attribute(lstr_attributes, "Printer", ls_printer)
//				else
//					f_attribute_add_attribute(lstr_attributes, "use_default_printer", "True")
//				end if
//				
//				li_wait = f_please_wait_open()
//				
//				// If the "cover_page" attribute isn't present then the default behavior is to print a cover_page if there is a "subject" or "message" attribute
//				lb_cover_letter = false
//				ls_temp = get_attribute("cover_page")
//				if isnull(ls_temp) then
//					if len(get_attribute("subject")) > 0 then
//						lb_cover_letter = true
//					elseif len(get_attribute("message")) > 0 then
//						lb_cover_letter = true
//					end if
//				else
//					lb_cover_letter = f_string_to_boolean(ls_temp)
//				end if
//				
//				if lb_cover_letter then
//					f_print_cover_page(this)
//				end if
//				
//				li_sts = f_print_attachment_with_attributes(ll_attachment_id, lstr_attributes)
//				if li_sts <= 0 then
//					log.log(this, "u_component_wp_item_document.document_send_now_old:0134", "Error printing attachment", 4)
//					f_please_wait_close(li_wait)
//					return -1
//				end if
//				
//				f_please_wait_close(li_wait)
//			CASE "filesender"
//				if isnull(ll_addressee) then
//					log.log(this, "u_component_wp_item_document.document_send_now_old:0142", dispatch_method + " dispatch_method does not have a valid send-to-addressee", 4)
//					return -1
//				end if
//
//				li_sts = f_get_attachment(ll_attachment_id, lstr_attachment)
//				if li_sts <= 0 then
//					log.log(this, "u_component_wp_item_document.document_send_now_old:0148", "Error getting attacment file", 4)
//					return -1
//				end if
//				
//				luo_data = CREATE u_ds_data
//				luo_data.set_dataobject("dw_practice_interface_transport_properties")
//				ll_attribute_count = luo_data.retrieve(sqlca.customer_id, ll_addressee, ll_transportsequence)
//				f_attribute_ds_to_str(luo_data, lstr_attributes)
//				DESTROY luo_data
//				
//				ls_temp = f_attribute_find_attribute(lstr_attributes, "attachment_location_id")
//				if isnull(ls_temp) then
//					log.log(this, "u_component_wp_item_document.document_send_now_old:0160", dispatch_method + " dispatch_method is not properly configured - missing attachment_location_id", 4)
//					return -1
//				end if
//				ll_attachment_location_id = long(ls_temp)
//				ls_send_to_directory = f_attribute_find_attribute(lstr_attributes, "send_to_directory")
//				if isnull(ls_send_to_directory) then
//					log.log(this, "u_component_wp_item_document.document_send_now_old:0166", dispatch_method + " dispatch_method is not properly configured - missing directory", 4)
//					return -1
//				end if
//				
//				lstr_attachment_location = datalist.get_attachment_location(ll_attachment_location_id)
//				if isnull(lstr_attachment_location.attachment_location_id) then
//					log.log(this, "u_component_wp_item_document.document_send_now_old:0172", dispatch_method + " dispatch_method is not properly configured - invalid attachment location", 4)
//					return -1
//				end if
//				
//				ls_save_path = "\\" + lstr_attachment_location.attachment_server + "\" + lstr_attachment_location.attachment_share
//				
//				ls_send_to_directory = f_string_substitute(ls_send_to_directory, "/", "\")
//				
//				if left(ls_send_to_directory, 1) = "\" then
//					ls_save_path += ls_send_to_directory
//				else
//					ls_save_path += "\" + ls_send_to_directory
//				end if
//				
//				if right(ls_save_path, 1) <> "\" then ls_save_path += "\"
//				
//				// Determine the filename
//				ls_filename_prefix = f_attribute_find_attribute(lstr_attributes, "filename_prefix")
//				if len(ls_filename_prefix) > 0 then
//					ls_save_path += ls_filename_prefix + "_"
//				end if
//				
//				ls_save_path += right("000000000000" + string(patient_workplan_item_id), 12)
//				ls_save_path += "." + lstr_attachment.extension
//				
//				li_sts = log.file_write(lstr_attachment.attachment, ls_save_path)
//				if li_sts < 0 then
//					log.log(this, "u_component_wp_item_document.document_send_now_old:0199", dispatch_method + "Error saving document (" + ls_save_path + ")", 4)
//					return -1
//				end if
//
//			CASE "sender_epie"
//				// Verify that this customer is licensed to use the selected route
//				if lower(dispatch_method) = "email" then
//					log.log(this, "u_component_wp_item_document.document_send_now_old:0206", "This installation is not licensed to send documents via eMail", 4)
//					if cpr_mode = "CLIENT" then
//						openwithparm(w_pop_message, "This installation is not licensed to send documents via eMail")
//					end if
//					return -1
//				end if
//
//				if lower(dispatch_method) = "fax" then
//					log.log(this, "u_component_wp_item_document.document_send_now_old:0214", "This installation is not licensed to send documents via Fax", 4)
//					if cpr_mode = "CLIENT" then
//						openwithparm(w_pop_message, "This installation is not licensed to send documents via Fax")
//					end if
//					return -1
//				end if
//
//				if isnull(ll_addressee) then
//					log.log(this, "u_component_wp_item_document.document_send_now_old:0222", dispatch_method + " dispatch_method does not have a valid send-to-addressee", 4)
//					return -1
//				end if
//
//				if isnull(ls_document_type) then
//					log.log(this, "u_component_wp_item_document.document_send_now_old:0227", dispatch_method + " dispatch_method does not have a valid document type", 4)
//					return -1
//				end if
//				
//				li_sts = f_get_attachment(ll_attachment_id, lstr_attachment)
//				if li_sts <= 0 then
//					log.log(this, "u_component_wp_item_document.document_send_now_old:0233", "Error getting attacment file", 4)
//					return -1
//				end if
//				
//				if f_file_is_text(lstr_attachment.extension) then
//					li_sts = f_send_document(ls_document_type, ll_addressee, "XML", string(lstr_attachment.attachment), id, ordered_by, ordered_for)
//				else
//					li_sts = f_send_document_blob(ls_document_type, ll_addressee, lstr_attachment.attachment, id, ordered_by, ordered_for)
//				end if
//				if li_sts <= 0 then return -1
//		END CHOOSE
//	CASE "material"
//		// Get information about this route
//		SELECT send_via_addressee, document_type, transportsequence, sender_component_id
//		INTO :ll_addressee, :ls_document_type, :ll_transportsequence, :ls_sender_component_id
//		FROM dbo.fn_document_route_information(:dispatch_method);
//		if not tf_check() then return -1
//		if sqlca.sqlnrows <> 1 then
//			log.log(this, "u_component_wp_item_document.document_send_now_old:0251", "Invalid dispatch_method (" + dispatch_method + ")", 4)
//			return -1
//		end if
//		
//		CHOOSE CASE lower(ls_sender_component_id)
//			CASE "sender_printer"
//				ls_printer = get_attribute("Printer")
//				
//				li_wait = f_please_wait_open()
//				
//				if len(ls_printer) > 0 then
//					common_thread.set_printer(ls_printer)
//				end if
//				li_sts = f_open_patient_material(ll_material_id, "print", false)
//				if li_sts <= 0 then
//					log.log(this, "u_component_wp_item_document.document_send_now_old:0266", "Error printing patient material", 4)
//					f_please_wait_close(li_wait)
//					return -1
//				end if
//				if len(ls_printer) > 0 then
//					common_thread.set_default_printer()
//				end if
//				
//				f_please_wait_close(li_wait)
//			CASE "sender_file"
//				if isnull(ll_addressee) then
//					log.log(this, "u_component_wp_item_document.document_send_now_old:0277", dispatch_method + " dispatch_method does not have a valid send-to-addressee", 4)
//					return -1
//				end if
//
//				lstr_material = f_get_patient_material(ll_material_id, true)
//				if isnull(lstr_material.material_id) then
//					log.log(this, "u_component_wp_item_document.document_send_now_old:0283", "Error getting material file", 4)
//					return -1
//				end if
//				
//				luo_data = CREATE u_ds_data
//				luo_data.set_dataobject("dw_practice_interface_transport_properties")
//				ll_attribute_count = luo_data.retrieve(sqlca.customer_id, ll_addressee, ll_transportsequence)
//				f_attribute_ds_to_str(luo_data, lstr_attributes)
//				DESTROY luo_data
//				
//				ls_temp = f_attribute_find_attribute(lstr_attributes, "attachment_location_id")
//				if isnull(ls_temp) then
//					log.log(this, "u_component_wp_item_document.document_send_now_old:0295", dispatch_method + " dispatch_method is not properly configured - missing attachment_location_id", 4)
//					return -1
//				end if
//
//				ll_attachment_location_id = long(ls_temp)
//				ls_send_to_directory = f_attribute_find_attribute(lstr_attributes, "send_to_directory")
//				if isnull(ls_send_to_directory) then
//					log.log(this, "u_component_wp_item_document.document_send_now_old:0302", dispatch_method + " dispatch_method is not properly configured - missing directory", 4)
//					return -1
//				end if
//				
//				lstr_attachment_location = datalist.get_attachment_location(ll_attachment_location_id)
//				if isnull(lstr_attachment_location.attachment_location_id) then
//					log.log(this, "u_component_wp_item_document.document_send_now_old:0308", dispatch_method + " dispatch_method is not properly configured - invalid attachment location", 4)
//					return -1
//				end if
//				
//				ls_save_path = "\\" + lstr_attachment_location.attachment_server + "\" + lstr_attachment_location.attachment_share
//				
//				ls_send_to_directory = f_string_substitute(ls_send_to_directory, "/", "\")
//				
//				if left(ls_send_to_directory, 1) = "\" then
//					ls_save_path += ls_send_to_directory
//				else
//					ls_save_path += "\" + ls_send_to_directory
//				end if
//				
//				if right(ls_save_path, 1) <> "\" then ls_save_path += "\"
//				
//				// Determine the filename
//				ls_filename_prefix = f_attribute_find_attribute(lstr_attributes, "filename_prefix")
//				if len(ls_filename_prefix) > 0 then
//					ls_save_path += ls_filename_prefix + "_"
//				end if
//				
//				ls_save_path += right("000000000000" + string(patient_workplan_item_id), 12)
//				ls_save_path += "." + lstr_material.extension
//				
//				li_sts = log.file_write(lstr_material.material_object, ls_save_path)
//				if li_sts < 0 then
//					log.log(this, "u_component_wp_item_document.document_send_now_old:0335", dispatch_method + "Error saving document (" + ls_save_path + ")", 4)
//					return -1
//				end if
//
//			CASE "sender_epie"
//				// Verify that this customer is licensed to use the selected route
//				if lower(dispatch_method) = "email" then
//					log.log(this, "u_component_wp_item_document.document_send_now_old:0342", "This installation is not licensed to send documents via eMail", 4)
//					if cpr_mode = "CLIENT" then
//						openwithparm(w_pop_message, "This installation is not licensed to send documents via eMail")
//					end if
//					return -1
//				end if
//
//				if lower(dispatch_method) = "fax" then
//					log.log(this, "u_component_wp_item_document.document_send_now_old:0350", "This installation is not licensed to send documents via Fax", 4)
//					if cpr_mode = "CLIENT" then
//						openwithparm(w_pop_message, "This installation is not licensed to send documents via Fax")
//					end if
//					return -1
//				end if
//
//				// Send the document
//				lstr_material = f_get_patient_material(ll_material_id, true)
//				if isnull(lstr_material.material_id) then
//					log.log(this, "u_component_wp_item_document.document_send_now_old:0360", "Error getting material file", 4)
//					return -1
//				end if
//				
//				if isnull(ll_addressee) then
//					log.log(this, "u_component_wp_item_document.document_send_now_old:0365", dispatch_method + " dispatch_method does not have a valid send-to-addressee", 4)
//					return -1
//				end if
//
//				if isnull(ls_document_type) then
//					log.log(this, "u_component_wp_item_document.document_send_now_old:0370", dispatch_method + " dispatch_method does not have a valid document type", 4)
//					return -1
//				end if
//				
//				if f_file_is_text(lstr_material.extension) then
//					li_sts = f_send_document(ls_document_type, ll_addressee, "XML", string(lstr_material.material_object), id, ordered_by, ordered_for)
//				else
//					li_sts = f_send_document_blob(ls_document_type, ll_addressee, lstr_material.material_object, id, ordered_by, ordered_for)
//				end if
//				if li_sts <= 0 then return -1
//		END CHOOSE
//END CHOOSE
//
//li_sts = set_progress("Sent")
//if li_sts < 0 then
//	log.log(this, "u_component_wp_item_document.document_send_now_old:0385", "Error setting 'sent' progress", 4)
//	return -1
//end if
//
return 1
//
end function

public function integer document_pick_address ();u_component_route luo_sender
integer li_sts
string ls_address_attribute
string ls_address_value

// Get the route sender component
li_sts = route_component(dispatch_method, luo_sender)
if li_sts <= 0 then
	log.log(this, "u_component_wp_item_document.document_pick_address:0009", "Error sending document: Unable to get sender component (" + string(patient_workplan_item_id) + ")", 4)
	return -1
end if

// Prompt the user for the address
li_sts = luo_sender.pick_address(this, ordered_for, dispatch_method, ls_address_attribute, ls_address_value)
if li_sts <= 0 then return li_sts


// Set the new address
li_sts = document_set_recipient(ordered_for, dispatch_method, ls_address_attribute, ls_address_value)
return li_sts


end function

public function integer document_pick_recipient ();string ls_new_ordered_for
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
string ls_purpose



setnull(ls_new_ordered_for)
setnull(ls_new_dispatch_method)

ls_document_subtype = document_subtype()
ls_purpose = get_attribute("purpose")

///////////////////////////////////////////////////////////////////
// Pick new ordered_for
///////////////////////////////////////////////////////////////////

// If there's no purpose, then pick a purpose
if isnull(ls_purpose) then
	popup.argument_count = 1
	popup.argument[1] = context_object
	popup.dataobject = "dw_c_document_purpose_pick_list"
	popup.datacolumn = 1
	popup.displaycolumn = 2
	popup.title = "Select Document Purpose"
	openwithparm(w_pop_pick, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return 0
	
	ls_purpose = popup_return.items[1]

	set_attribute("purpose", ls_purpose)
end if

// Pick the actor class
popup.dataobject = "dw_actor_class_for_purpose"
popup.datacolumn = 1
popup.displaycolumn = 1
popup.auto_singleton = true
popup.argument_count = 1
popup.argument[1] = ls_purpose
popup.title = "Select Recipient Class"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then
	// If there were any choices then the user clicked "Cancel"
	if popup_return.choices_count > 0 then return 0
	
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
	if popup_return.item_count <> 1 then return 0
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
	if li_sts <= 0 then return 0
	
	ls_new_ordered_for = lstr_pick_users.selected_users.user[1].user_id
end if

if isnull(ls_new_ordered_for) then
	return 0
end if



/////////////////////////////////////////////////////////////////////
// Pick a new dispatch_method
/////////////////////////////////////////////////////////////////////

ls_new_dispatch_method = pick_dispatch_method(ls_new_ordered_for)
if isnull(ls_new_dispatch_method) then return 0



/////////////////////////////////////////////////////////////////////
// Pick the address
/////////////////////////////////////////////////////////////////////

li_sts = route_component(ls_new_dispatch_method, luo_sender)
if li_sts <= 0 then
	log.log(this, "u_component_wp_item_document.document_pick_recipient:0110", "Error sending document: Unable to get sender component (" + string(patient_workplan_item_id) + ")", 4)
	return -1
end if

// Prompt the user for the address
li_sts = luo_sender.pick_address(this, ls_new_ordered_for, ls_new_dispatch_method, ls_address_attribute, ls_address_value)
if li_sts <= 0 then return li_sts



/////////////////////////////////////////////////////////////////////
// Finally, set the new recipient, dispatch_method, address
/////////////////////////////////////////////////////////////////////

li_sts = document_set_recipient(ls_new_ordered_for, ls_new_dispatch_method, ls_address_attribute, ls_address_value)
return li_sts

return 1

end function

public function integer document_set_recipient (string ps_ordered_for, string ps_dispatch_method, string ps_address_attribute, string ps_address_value);integer li_sts

if isnull(ps_ordered_for) or ps_ordered_for = "" then return 0

li_sts = sqlca.jmj_document_set_recipient(patient_workplan_item_id, ps_ordered_for, ps_dispatch_method, ps_address_attribute, ps_address_value, current_user.user_id, current_scribe.user_id)
if not tf_check() then return -1

initialize(patient_workplan_item_id)

return 1


end function

public function integer document_pick_dispatch_method ();string ls_new_dispatch_method
string ls_address_attribute
string ls_address_value
u_component_route luo_sender
integer li_sts

// Pick a new dispatch_method
ls_new_dispatch_method = pick_dispatch_method(ordered_for)
if isnull(ls_new_dispatch_method) then return 0


// Get the route sender component
li_sts = route_component(ls_new_dispatch_method, luo_sender)
if li_sts <= 0 then
	log.log(this, "u_component_wp_item_document.document_pick_dispatch_method:0015", "Error sending document: Unable to get sender component (" + string(patient_workplan_item_id) + ")", 4)
	return -1
end if

// Prompt the user for the address
li_sts = luo_sender.pick_address(this, ordered_for, ls_new_dispatch_method, ls_address_attribute, ls_address_value)
if li_sts <= 0 then return li_sts

// Set the new address
li_sts = document_set_recipient(ordered_for, ls_new_dispatch_method, ls_address_attribute, ls_address_value)
return li_sts

return 1

end function

private function string pick_dispatch_method (string ps_new_ordered_for);str_document_send lstr_document_send
u_ds_data luo_data
long ll_count
string ls_null
long i
str_document_send_error_status lstr_document_send_error_status
str_popup popup
str_popup_return popup_return
string ls_report_id
string ls_communication_type
string ls_message
string ls_purpose
string ls_new_dispatch_method
string ls_address_attribute
string ls_address_value
u_component_route luo_sender
integer li_sts

setnull(ls_null)
setnull(ls_new_dispatch_method)

ls_report_id = get_attribute("report_id")
ls_purpose = get_attribute("purpose")

popup.dataobject = "dw_document_valid_routes_pick"
popup.datacolumn = 1
popup.displaycolumn = 1
popup.auto_singleton = true
popup.argument_count = 5
popup.argument[1] = ordered_by
popup.argument[2] = ps_new_ordered_for
popup.argument[3] = ls_purpose
popup.argument[4] = cpr_id
popup.argument[5] = ls_report_id
popup.add_blank_row = true
popup.blank_at_bottom = true
popup.blank_text = "<Show Routes>"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then
	if popup_return.choices_count = 0 then
		// If there were no choices then show the routes and their reasons for not being available
		show_routes(ps_new_ordered_for, "No valid Routes")
	end if
	return ls_null
end if

if popup_return.items[1] = "" then
	show_routes(ps_new_ordered_for, "Routes")
	return ls_null
end if

ls_new_dispatch_method = popup_return.items[1]

// See if there are any errors with sending this document to this recipient via this route
lstr_document_send.patient_workplan_item_id = patient_workplan_item_id
lstr_document_send.ordered_for = ordered_for
lstr_document_send.document_route = ls_new_dispatch_method
lstr_document_send.document_description = description
openwithparm(w_display_route_errors, lstr_document_send)
lstr_document_send_error_status = message.powerobjectparm
if lstr_document_send_error_status.error_count > 0 &
  and lstr_document_send_error_status.max_severity > 1 &
  and not lstr_document_send_error_status.send_anyways then
	return ls_null
end if

return ls_new_dispatch_method


end function

private function integer route_component (string ps_dispatch_method, ref u_component_route puo_route);string ls_component_id
string ls_document_route

if isnull(ps_dispatch_method) then
	log.log(this, "u_component_wp_item_document.route_component:0005", "No dispatch_method has been set for this document (" + string(patient_workplan_item_id) + ")", 4)
	return -1
end if

SELECT sender_component_id
INTO :ls_component_id
FROM dbo.fn_document_route_information(:ps_dispatch_method);
if not tf_check() then return -1
if sqlca.sqlnrows <> 1 then
	log.log(this, "u_component_wp_item_document.route_component:0014", "Route not found for this document (" + string(patient_workplan_item_id) + ", " + ps_dispatch_method + ")", 4)
	return -1
end if

puo_route = component_manager.get_component(ls_component_id)
if isnull(puo_route) then
	log.log(this, "u_component_wp_item_document.route_component:0020", "Error getting route component (" +  string(patient_workplan_item_id) + ", " + ls_component_id + ")", 4)
	return -1
end if


return 1


end function

public subroutine show_routes (string ps_ordered_for, string ps_message);str_popup popup


popup.data_row_count = 5
popup.title = ps_message
popup.items[1] = ordered_by
popup.items[2] = ps_ordered_for
popup.items[3] = get_attribute("purpose")
popup.items[4] = cpr_id
popup.items[5] = get_attribute("report_id")
openwithparm(w_pop_document_routes, popup)



end subroutine

public subroutine show_routes (string ps_message);show_routes(ordered_for, ps_message)

end subroutine

public subroutine document_error (string ps_operation);
sqlca.jmj_set_document_error(patient_workplan_item_id, &
									ps_operation, &
									current_user.user_id, &
									computer_id)
if not tf_check() then return


end subroutine

public function integer get_document (ref str_external_observation_attachment pstr_document);integer li_sts
long ll_material_id
str_patient_material lstr_material
str_c_attachment_extension lstr_extension
boolean lb_force_send

CHOOSE CASE lower(document_subtype())
	CASE "material"
		get_attribute("material_id", ll_material_id)
		lstr_material = f_get_patient_material(ll_material_id, true)
		if isnull(lstr_material.material_id) then return -1

		lstr_extension = datalist.extension(lstr_material.extension)
		
		pstr_document.attachment_type = lstr_extension.default_attachment_type
		pstr_document.filename = lstr_material.filename
		pstr_document.extension = lstr_material.extension
		pstr_document.attachment = lstr_material.material_object
		pstr_document.attachment_comment_title = lstr_material.title
		setnull(pstr_document.attachment_comment)
		setnull(pstr_document.box_id)
		setnull(pstr_document.item_id)
		setnull(pstr_document.xml_document)
		setnull(pstr_document.attachment_render_file)
		setnull(pstr_document.attachment_render_file_type)
		setnull(pstr_document.attached_by_user_id)
		setnull(pstr_document.message_id)
	CASE "report"
		// If the mappings previously failed then always regenerate
		if not document_created or failed_mappings then
			li_sts = document_create()
			if li_sts <= 0 then return li_sts
			if not document_created then
				log.log(this, "u_component_wp_item_document.get_document:0034", "Document created but not found", 4)
				return -1
			end if
			
			// If the mappings have still failed then fail the get_document unless the force_send flag is true
			if failed_mappings then
				get_attribute("force_send", lb_force_send)
				if not lb_force_send then
					log.log(this, "u_component_wp_item_document.get_document:0042", "Document mapping failed.  Document will not be sent (" + string(patient_workplan_item_id) + ")", 4)
					document_error("Mapping")
					return -1
				end if
			end if
		end if

		
		
		li_sts = f_get_attachment(attachment_id, pstr_document)
		if li_sts <= 0 then
			log.log(this, "u_component_wp_item_document.get_document:0053", "Error getting attacment file", 4)
			return -1
		end if
	CASE ELSE
END CHOOSE


return 1

end function

public function integer document_reset ();integer li_sts
string ls_null
long ll_interfaceserviceid

setnull(ls_null)

li_sts = set_progress("Reset")
if li_sts < 0 then
	log.log(this, "u_component_wp_item_document.document_reset:0009", "Error resetting document", 4)
	return -1
end if

clear_attachment()

ll_interfaceserviceid = sqlca.fn_document_interfaceserviceid(patient_workplan_item_id)
if not tf_check() then return -1

DELETE dbo.c_component_interface_object_log
WHERE interfaceserviceid = :ll_interfaceserviceid
AND document_patient_workplan_item_id = :patient_workplan_item_id;
if not tf_check() then return -1


return 1

end function

public subroutine edit_mappings ();str_service_info lstr_service
long ll_owner_id
integer li_sts


lstr_service.service = "Code Mappings"
f_attribute_add_attribute(lstr_service.attributes, "document_patient_workplan_item_id", string(patient_workplan_item_id))

li_sts = service_list.do_service(lstr_service)

end subroutine

public function integer get_document (ref str_document_file pstr_document);integer li_sts
str_external_observation_attachment lstr_document

// First get the document attachment
li_sts = get_document(lstr_document)
if li_sts <= 0 then return li_sts

// The attachment may not have a filename, but the str_document_file structure needs a filename
if len(lstr_document.filename) > 0 then
	pstr_document.filename = lstr_document.filename
else
	// Create a filename
	if len(lstr_document.attachment_comment) > 0 then
		pstr_document.filename = f_string_to_filename(left(lstr_document.attachment_comment, 50))
	else
		pstr_document.filename = f_string_to_filename(left(description, 50))
	end if
	pstr_document.filename +=  + "_" + string(patient_workplan_item_id)
end if
pstr_document.filetype = lstr_document.extension
if len(lstr_document.attachment_comment) > 0 then
	pstr_document.filedescription = lstr_document.attachment_comment
else
	pstr_document.filedescription = pstr_document.filename
end if
setnull(pstr_document.modifieddate)
pstr_document.filedata = lstr_document.attachment


return 1

end function

public subroutine document_display_properties ();w_window_base lw_window

openwithparm(lw_window, patient_workplan_item_id, "w_document_properties")


end subroutine

public function integer initialize (long pl_patient_workplan_item_id);integer li_sts

li_sts = SUPER::Initialize(pl_patient_workplan_item_id)

set_document_status()

return li_sts


end function

public function string document_mapping_status ();string ls_status
string ls_null

setnull(ls_null)

ls_status = sqlca.fn_document_mapping_status(patient_workplan_item_id)
if not tf_check() then return ls_null

if lower(ls_status) = "failed" then
	failed_mappings = true
else
	failed_mappings = false
end if

return ls_status


end function

protected subroutine set_document_status ();string ls_status
string ls_null

setnull(ls_null)

ls_status = document_mapping_status()

if isnull(ls_status) or lower(ls_status) = "failed" then
	failed_mappings = true
else
	failed_mappings = false
end if

if attachment_id > 0 then
	document_created = true
else
	document_created = false
end if


return

end subroutine

public function string document_interface_name ();long ll_interfaceserviceid
string ls_interface_name

ll_interfaceserviceid = sqlca.fn_document_interfaceserviceid(patient_workplan_item_id)
if not tf_check() then setnull(ll_interfaceserviceid)

if ll_interfaceserviceid > 0 then
	SELECT description
	INTO :ls_interface_name
	FROM c_Component_Interface
	WHERE interfaceserviceid = :ll_interfaceserviceid;
	if not tf_check() then setnull(ls_interface_name)
end if

if len(ls_interface_name) > 0 then return ls_interface_name

ls_interface_name = dispatch_method
if len(ls_interface_name) > 0 then return ls_interface_name

ls_interface_name = ""

return ls_interface_name

end function

public function integer document_view (boolean pb_allow_create);long ll_attachment_id
boolean lb_auto_create
integer li_sts
string ls_interfacename
str_popup_return popup_return


// If the mappings previously failed then always regenerate
if not document_created or failed_mappings then
	if pb_allow_create then
		// Set a flag to suppress some format checks.  We want to be able to view a document even if it's the wrong format
		viewing_document = true
		li_sts = document_create()
		viewing_document = false
		if li_sts <= 0 then return li_sts
		if not document_created then
			log.log(this, "u_component_wp_item_document.document_view:0017", "Document created but not found", 4)
			return -1
		end if
		
		// If the mappings have still failed then fail the get_document unless the force_send flag is true
		if failed_mappings then
			ls_interfacename = document_interface_name()
			openwithparm(w_pop_yes_no, "This document contains EncounterPRO data elements have not been mapped to required " + ls_interfacename + " fields.  Do you wish to map these elements now?")
			popup_return = message.powerobjectparm
			if popup_return.item = "YES" then
				edit_mappings()
				return 0
			end if
		end if
	elseif not document_created then
		openwithparm(w_pop_message, "This document has not been created yet")
		return 0
	end if
end if

li_sts = f_display_attachment(attachment_id)
if li_sts < 0 then return -1

return 1

end function

public function integer clear_attachment ();string ls_null

setnull(ls_null)

set_attribute("attachment_id", ls_null)

setnull(attachment_id)

document_created = false

UPDATE p_Patient_WP_Item
SET attachment_id = NULL
WHERE patient_workplan_item_id = :patient_workplan_item_id;
if not tf_check() then return -1

return 1

end function

on u_component_wp_item_document.create
call super::create
end on

on u_component_wp_item_document.destroy
call super::destroy
end on

