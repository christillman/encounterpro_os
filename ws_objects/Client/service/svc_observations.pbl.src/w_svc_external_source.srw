$PBExportHeader$w_svc_external_source.srw
forward
global type w_svc_external_source from w_window_base
end type
end forward

global type w_svc_external_source from w_window_base
boolean visible = false
integer width = 2853
integer height = 1584
string title = "External Source Service"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
end type
global w_svc_external_source w_svc_external_source

type variables
u_component_service service

u_component_observation external_source


end variables

forward prototypes
private function integer pick_external_source (ref string ps_external_source, ref boolean pb_wia)
public function long order_workplan (str_attachment pstr_attachment, long pl_workplan_id, string ps_owned_by)
public subroutine do_source ()
public subroutine post_to_encounter (ref str_attachment_context pstr_attachment_context)
public function string get_external_source ()
public function string populate_external_source_attributes (ref str_attributes pstr_attributes, string ps_attachment_original_context_object)
public function str_attachment_context populate_original_attachment_context ()
public function str_attachment build_new_attachment (readonly str_external_observation_attachment pstr_attachment, string ps_progress_key)
public subroutine post_to_folder (ref str_attachment_context pstr_attachment_context, str_external_observation_attachment pstr_attachment, str_attachment pstr_new_attachment)
public function integer interpret_context (ref str_attachment_context pstr_attachment_context, ref str_attributes pstr_document_attributes, ref str_attachment pstr_new_attachment)
public function integer external_source_not_found (string ps_external_source)
end prototypes

private function integer pick_external_source (ref string ps_external_source, ref boolean pb_wia);long i
str_popup popup
str_popup_return popup_return
string buttons[]
string ls_external_source_type
str_external_sources lstr_sources

// If no external_source_type is specified then display all available
ls_external_source_type = service.get_attribute("external_source_type")
lstr_sources = common_thread.get_external_sources(ls_external_source_type)

// If we have no button at this point then there isn't an appropriate device on this computer
if lstr_sources.external_source_count <= 0 then
	openwithparm(w_pop_message, "This computer does not have any devices of the appropriate type.")
	setnull(ps_external_source)
	return 0
end if

popup.data_row_count = lstr_sources.external_source_count
for i = 1 to lstr_sources.external_source_count
	popup.items[i] = lstr_sources.external_source[i].description
next

popup.title = "External Source"
popup.auto_singleton = true
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then
	setnull(ps_external_source)
	return 1
end if

ps_external_source = lstr_sources.external_source[popup_return.item_indexes[1]].external_source
pb_wia = lstr_sources.external_source[popup_return.item_indexes[1]].wia_source

return 1


end function

public function long order_workplan (str_attachment pstr_attachment, long pl_workplan_id, string ps_owned_by);long ll_patient_workplan_id
string ls_in_office_flag
string ls_mode
long ll_parent_patient_workplan_item_id
string ls_dispatch_flag = "Y"

setnull(ls_in_office_flag)
setnull(ls_mode)
setnull(ll_parent_patient_workplan_item_id)


sqlca.sp_order_workplan( &
		current_patient.cpr_id, &
		pl_workplan_id, &
		service.encounter_id, &
		pstr_attachment.problem_id, &
		pstr_attachment.treatment_id, &
		pstr_attachment.observation_sequence, &
		pstr_attachment.attachment_id, &
		pstr_attachment.attachment_tag, &
		current_user.user_id, &
		ps_owned_by, &
		ls_in_office_flag, &
		ls_mode, &
		ll_parent_patient_workplan_item_id, &
		current_scribe.user_id, &
		ls_dispatch_flag, &
		ll_patient_workplan_id)
if not tf_check() then return -1

return ll_patient_workplan_id



end function

public subroutine do_source ();str_popup popup
str_popup_return popup_return
string ls_external_source
integer li_sts
integer idx_obs, idx_att
long ll_patient_workplan_id
string ls_component_id
str_attributes lstr_attributes
str_external_observation_attachment lstr_attachment
str_attachment lstr_new_attachment
long ll_attachment_id
string ls_progress_type
string ls_progress_key
long ll_patient_workplan_item_id
long ll_send_to_addressee

str_external_source lstr_external_source
str_attachment_context lstr_attachment_context_iter
str_attachment_context lstr_attachment_context_original
str_attributes lstr_document_attributes
w_post_attachment lw_window

u_ds_attachments lds_attachments

string ls_xml_action
str_complete_context lstr_my_context
str_complete_context lstr_document_context
boolean lb_epie_sent

// Determine the context for these attachments
lstr_attachment_context_original = populate_original_attachment_context()

// If we have a wia_device_id then we don't need an external_source
ls_external_source = service.get_attribute("external_source")
if isnull(ls_external_source) then
	ls_external_source = get_external_source()
	choose case ls_external_source
		case "Error"
			closewithreturn(this, -1)
			return
		case "None"
			closewithreturn(this, 0)
			return
		case "OK"
			closewithreturn(this, 1)
			return
	end choose
end if

lstr_attributes = service.get_attributes()

f_attribute_add_attribute(lstr_attributes, "external_source", ls_external_source)

// Before we instantiate this external source, make sure it's on this computer
li_sts = common_thread.get_external_source(ls_external_source, lstr_external_source)
if li_sts <= 0 then
	li_sts = external_source_not_found(ls_external_source)
	if li_sts <= 0 then
		closewithreturn(this, li_sts)
		return
	end if
end if

ls_component_id = lstr_external_source.component_id
ls_progress_key = populate_external_source_attributes(lstr_attributes, lstr_attachment_context_original.context_object)

external_source = component_manager.get_component(ls_component_id, lstr_attributes)
if isnull(external_source) then
	log.log(this, "w_svc_external_source.do_source:0061", "error getting component (" + ls_component_id + ")", 4)
	closewithreturn(this, -1)
	return
end if

li_sts = external_source.do_source()
if li_sts <= 0 then
	closewithreturn(this, li_sts)
	return
end if

// Allow screens to refresh that might have been covered up by the external source
yield()

if li_sts = 0 then
	// We didn't get anything from the external source
	if service.manual_service then
		// If this is a manual service then just cancel it
		closewithreturn(this, 2)
		return
	elseif gnv_app.cpr_mode = "CLIENT" then
		// If this is not a manual service then ask the user if they want to
		// try again later
		popup.data_row_count = 2
		popup.items[1] = "I'll Be Back"
		popup.items[2] = "I'm Finished"
		openwithparm(w_pop_pick, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then
			closewithreturn(this, 0)
			return
		else
			if popup_return.item_indexes[1] = 1 then
				closewithreturn(this, 0)
				return
			else
				closewithreturn(this, 1)
				return
			end if
		end if
	else
		// If we're not in client mode then just return success
		closewithreturn(this, 1)
		return
	end if
end if

// If there isn't a current patient, then we need to create an attachment
// object to handle the attachments
if isnull(current_patient) then
	lds_attachments = CREATE u_ds_attachments
	lds_attachments.settransobject(sqlca)
else
	lds_attachments = current_patient.attachments
end if

lstr_attachment_context_iter.apply_to_all = false
lb_epie_sent = false

// Now post the attachments
for idx_obs = 1 to external_source.observation_count
	for idx_att = 1 to external_source.observations[idx_obs].attachment_list.attachment_count
		// Get a local copy to make the coding easier
		lstr_attachment = external_source.observations[idx_obs].attachment_list.attachments[idx_att]
	
		// Reset the structure for this iteration
		lstr_attachment_context_iter = lstr_attachment_context_original
		
		// Decide if we're going to send this attachment or process it
		ll_send_to_addressee = lstr_attachment.epiehandler.toaddresseeid
		if isnull(ll_send_to_addressee) or ll_send_to_addressee = 0 then ll_send_to_addressee = long(service.get_attribute("send_to_addressee"))
		
		if ll_send_to_addressee > 0 then
			// Send the attachment
			li_sts = external_source.send_attachment(lstr_attachment, ll_send_to_addressee)
			if li_sts <= 0 then
				log.log(this, "w_svc_external_source.do_source:0137", "Error sending attachment", 4)
				closewithreturn(this, -1)
				return
			end if
			
			// set a flag so that we will process the common epiehandler commands after all the documents are successfully sent
			lb_epie_sent = true
			
		else
			// Process the attachment by either intrepreting it or attaching it
			lstr_new_attachment = build_new_attachment(lstr_attachment, ls_progress_key)
			lstr_new_attachment.interfaceserviceid = long(service.get_attribute("interfaceserviceid"))
			
			lstr_document_attributes.attribute_count = 0
			
			// Decide if we're going apply the data
			if isvalid(lstr_attachment.xml_document) and not isnull(lstr_attachment.xml_document) then
				lstr_my_context = f_get_complete_context()
				// Valid xml_action values are as follows:
				//		process					Process the xml and post as an attachment
				//		attach only				Only post it as an attachment, do not process it.
				ls_xml_action = external_source.get_attribute("xml_action")
				if isnull(ls_xml_action) then ls_xml_action = "attach only"
				if lower(left(ls_xml_action, 7)) = "process" then
					li_sts = lstr_attachment.xml_document.interpret(lstr_my_context, lstr_document_context)
					if li_sts > 0 then
						lstr_document_attributes = f_context_to_attributes(lstr_document_context)
					end if
				end if
			else
				// If this isn't an xml document, then get any available context from the filename
				li_sts = f_interpret_filename(lstr_attachment.filename, service.get_attribute("filename_pattern"), lstr_document_attributes)
			end if
			
			// Interpret the context for this attachment
			li_sts = interpret_context(lstr_attachment_context_iter, lstr_document_attributes, lstr_new_attachment)
			if li_sts = -1 then
				closewithreturn(this, -1)
				return
			end if
			
			// If the user clicked "Apply to all" last time, then just use the same attachment context
			if not lstr_attachment_context_iter.apply_to_all then
				post_to_encounter(lstr_attachment_context_iter)
				if lstr_attachment_context_iter.user_cancelled then
					closewithreturn(this, -1)
					return
				end if
				
				// Set the individual field based on the object key
				if not isnull(lstr_attachment_context_iter.object_key) then
					CHOOSE CASE lower(lstr_attachment_context_iter.context_object)
						CASE "encounter"
							lstr_new_attachment.encounter_id = lstr_attachment_context_iter.object_key
						CASE "assessment"
							lstr_new_attachment.problem_id = lstr_attachment_context_iter.object_key
						CASE "treatment"
							lstr_new_attachment.treatment_id = lstr_attachment_context_iter.object_key
					END CHOOSE
				end if
				
				post_to_folder(lstr_attachment_context_iter, lstr_attachment, lstr_new_attachment)
				if lstr_attachment_context_iter.user_cancelled then
					closewithreturn(this, -1)
					return
				end if
				
				// See if the user cancelled
				if lstr_attachment_context_iter.user_cancelled then
					if idx_att < external_source.observations[idx_obs].attachment_list.attachment_count then
						// Ask the user if they want to keep processing attachments
						openwithparm(w_pop_yes_no, "There are more attachments in this set.  Do you wish to continue processing them?")
						popup_return = message.powerobjectparm
						if popup_return.item = "YES" then
							continue
						else
							exit
						end if
					else
						exit
					end if
				end if
			end if
			
			// If we got an attachment context then use it
			if not isnull(lstr_attachment_context_iter.folder) then
				lstr_new_attachment.attachment_folder = lstr_attachment_context_iter.folder
				// Ciru prefers that the context description override the file name tag
				//if len(lstr_new_attachment.attachment_tag) = 0 or isnull(lstr_new_attachment.attachment_tag) then
					lstr_new_attachment.attachment_tag = lstr_attachment_context_iter.description
				//end if
			end if
						
			// The same encounter_id is also used to store the p_Attachment record (in addition to
			// the appropriate progress record), so go ahead and
			// include it even if the context isn't for an encounter
			if isnull(lstr_new_attachment.encounter_id) then lstr_new_attachment.encounter_id = service.encounter_id
			// set a global so we can retrieve it after the service finishes. 
			// restore_service_state pops the current_display_encounter off the stack
			posted_encounter_id = lstr_new_attachment.encounter_id
			
			// Now create the attachment			
			ls_progress_type = service.get_attribute("progress_type")
			if trim(ls_progress_type) = "" then setnull(ls_progress_type)
			ll_attachment_id = lds_attachments.new_attachment(lstr_new_attachment, lstr_attachment.attachment, lstr_attachment_context_iter.context_object, ls_progress_type, ls_progress_key)
			if ll_attachment_id > 0 then
				// Tell the external source that we've successfully processed this item
				external_source.set_processed( external_source.observations[idx_obs].external_item_id, 1)
				
				// Then order the workplan.  First see if the folder context included a workplan
				if lstr_attachment_context_iter.workplan_id > 0 then
					ll_patient_workplan_id = order_workplan(lstr_new_attachment, lstr_attachment_context_iter.workplan_id, lstr_attachment_context_iter.user_id)
					ll_patient_workplan_item_id = sqlca.sp_get_workplan_auto_perform_service(ll_patient_workplan_id, current_user.user_id)
					if ll_patient_workplan_item_id > 0 then
						service_list.do_service(ll_patient_workplan_item_id)
					end if
				end if
			else
				log.log(this, "w_svc_external_source.do_source:0239", "Error creating attachment", 4)
				// Tell the external source that we failed to process this item
				external_source.set_processed( external_source.observations[idx_obs].external_item_id, -1)
			end if
			
		end if // send or process
	next
next

if lb_epie_sent then
	// All attachments were sent successfully so now process the epiehandler instructions
	li_sts = external_source.process_epiehandler(external_source.epiehandler_common, f_current_context())
	if li_sts < 0 then
		log.log(this, "w_svc_external_source.do_source:0252", "Error processing EpIEHandler instructions", 4)
		closewithreturn(this, -1)
		return
	end if
end if

if isnull(current_patient) then
	DESTROY lds_attachments
end if

component_manager.destroy_component(external_source)

closewithreturn(this, 1)
return



end subroutine

public subroutine post_to_encounter (ref str_attachment_context pstr_attachment_context);

pstr_attachment_context.posting_file = true
pstr_attachment_context.context_object = 'Encounter'
openwithparm(w_post_attachment_to_object, pstr_attachment_context)
pstr_attachment_context = message.powerobjectparm

end subroutine

public function string get_external_source ();string ls_external_source
boolean lb_wia
integer li_sts
str_popup popup
str_popup_return popup_return

if gnv_app.cpr_mode = "SERVER" then
	// If we're in server mode then an external source must be specified
	log.log(this, "w_svc_external_source.get_external_source:0009", "Null external source", 4)
	return "Error"
else
	li_sts = pick_external_source(ls_external_source, lb_wia)
	if li_sts < 0 then
		return "Error"
	elseif li_sts = 0 then
		// If 0 was returned then there isn't an appropriate external source on this computer
//		if current_user.check_privilege("Super User") then
//			openwithparm(w_pop_yes_no, "This computer does not have the appropriate input device.  Do you wish to configure the input devices?")
//			popup_return = message.powerobjectparm
//			if popup_return.item = "YES" then
//				service_list.do_service("CONFIG_SOURCES")
//			end if
//		else
//			openwithparm(w_pop_message, "This computer does not have the appropriate input device")
//		end if

		if service.manual_service then
			return "OK"
		else
			popup.data_row_count = 2
			popup.items[1] = "Perform this service later"
			popup.items[2] = "Cancel this service"
			openwithparm(w_pop_pick, popup)
			popup_return = message.powerobjectparm
			if popup_return.item_count <> 1 then
				return "None"
			else
				if popup_return.item_indexes[1] = 1 then
					return "None"
				else
					return "OK"
				end if
			end if
		end if
	elseif isnull(ls_external_source) then
		// if null was returned then the user pressed "Cancel"
		if service.manual_service then
			return "OK"
		else
			popup.data_row_count = 2
			popup.items[1] = "I'll Be Back"
			popup.items[2] = "I'm Finished"
			openwithparm(w_pop_pick, popup)
			popup_return = message.powerobjectparm
			if popup_return.item_count <> 1 then
				return "None"
			else
				if popup_return.item_indexes[1] = 1 then
					return "None"
				else
					return "OK"
				end if
			end if
		end if
	end if
end if

return ls_external_source

end function

public function string populate_external_source_attributes (ref str_attributes pstr_attributes, string ps_attachment_original_context_object);string ls_original_comment_title
string ls_address, ls_delete_file, ls_move_to
long ll_box_id

f_attribute_add_attribute(pstr_attributes, "comment_title_top_20_code", ps_attachment_original_context_object)

// See if the progress_key/attachment_tag/comment_title is predefined
ls_original_comment_title = service.get_attribute("progress_key")
if isnull(ls_original_comment_title) then ls_original_comment_title = service.get_attribute("attachment_tag")
if isnull(ls_original_comment_title) then ls_original_comment_title = service.get_attribute("comment_title")
if not isnull(ls_original_comment_title) then
	f_attribute_add_attribute(pstr_attributes, "comment_title", ls_original_comment_title)
end if

// See if a box_id is provided
service.get_attribute("box_id", ll_box_id)
if not isnull(ll_box_id) then
	f_attribute_add_attribute(pstr_attributes, "box_id", string(ll_box_id))
end if

// Pass in the address attribute if provided
ls_address = service.get_attribute("address")
if not isnull(ls_address) then
	f_attribute_add_attribute(pstr_attributes, "address", ls_address)
end if

// Pass in the delete_file flag
ls_delete_file = service.get_attribute("delete_file")
if not isnull(ls_delete_file) then
	f_attribute_add_attribute(pstr_attributes, "delete_file", ls_delete_file)
end if

// Pass in the move_to attribute if provided
ls_move_to = service.get_attribute("move_to")
if not isnull(ls_move_to) then
	f_attribute_add_attribute(pstr_attributes, "move_to", ls_move_to)
end if

// Set the progress_key to the original comment_title
RETURN ls_original_comment_title

end function

public function str_attachment_context populate_original_attachment_context ();
str_attachment_context lstr_attachment_context_original

// Determine the context for these attachments
lstr_attachment_context_original.context_object = service.get_attribute("attachment_context_object")
if isnull(lstr_attachment_context_original.context_object) then
	// If we didn't have a context object passed in then get the context from the service
	lstr_attachment_context_original.context_object = service.context_object
	lstr_attachment_context_original.context_object_type = service.context_object_type
	CHOOSE CASE lower(lstr_attachment_context_original.context_object)
		CASE "encounter"
			lstr_attachment_context_original.object_key = service.encounter_id
		CASE "assessment"
			lstr_attachment_context_original.object_key = service.problem_id
		CASE "treatment"
			lstr_attachment_context_original.object_key = service.treatment_id
		CASE ELSE
			setnull(lstr_attachment_context_original.object_key)
	END CHOOSE
else
	// If we were passed in the context_object, see if we were also passed in the object key
	service.get_attribute("attachment_object_key", lstr_attachment_context_original.object_key)
	if isnull(lstr_attachment_context_original.object_key) then
		setnull(lstr_attachment_context_original.context_object_type)
	else
		// We were passed in the object_key, so determine the object type
		lstr_attachment_context_original.context_object_type = sqlca.fn_context_object_type(lstr_attachment_context_original.context_object, &
																											current_patient.cpr_id, &
																											lstr_attachment_context_original.object_key)
	end if
end if

RETURN lstr_attachment_context_original
end function

public function str_attachment build_new_attachment (readonly str_external_observation_attachment pstr_attachment, string ps_progress_key);str_attachment lstr_new_attachment

// Set the service context into the attachment structure
lstr_new_attachment.cpr_id = service.get_attribute("cpr_id")
if isnull(lstr_new_attachment.cpr_id) and not isnull(current_patient) then
	lstr_new_attachment.cpr_id = current_patient.cpr_id
end if

lstr_new_attachment.encounter_id = service.encounter_id
lstr_new_attachment.problem_id = service.problem_id
lstr_new_attachment.treatment_id = service.treatment_id
lstr_new_attachment.observation_sequence = service.observation_sequence
setnull(lstr_new_attachment.attachment_id)
lstr_new_attachment.extension = pstr_attachment.extension
lstr_new_attachment.storage_flag = service.get_attribute("storage_flag")
lstr_new_attachment.attachment_type = pstr_attachment.attachment_type
// If there's a specific comment_title for this attachment then use it.  Otherwise use the progress_key
if len(pstr_attachment.attachment_comment_title) > 0 then
	lstr_new_attachment.attachment_tag = pstr_attachment.attachment_comment_title
else
	lstr_new_attachment.attachment_tag = ps_progress_key
end if
lstr_new_attachment.attachment_file = lstr_new_attachment.attachment_tag + "_" + string(today(), "yymmdd")
lstr_new_attachment.attachment_folder = service.get_attribute("attachment_folder")
if not isnull(pstr_attachment.attachment_comment) and (trim(pstr_attachment.attachment_comment) <> "") then
	lstr_new_attachment.attachment_text = trim(pstr_attachment.attachment_comment)
else
	setnull(lstr_new_attachment.attachment_text)
end if

RETURN lstr_new_attachment

end function

public subroutine post_to_folder (ref str_attachment_context pstr_attachment_context, str_external_observation_attachment pstr_attachment, str_attachment pstr_new_attachment);

str_folder_selection_info lstr_folder_select
long ll_interfaceserviceid

service.get_attribute("interfaceserviceid", ll_interfaceserviceid)

if isnull(ll_interfaceserviceid) or ll_interfaceserviceid <= 0 then
	// Only prompt for a folder and subsequent context if there is no interface service
	// Open the folder selection window with information about this attachment
	if isnull(pstr_new_attachment.cpr_id) then
		lstr_folder_select.attachment_folder = service.get_attribute("posting_list")
	else
		lstr_folder_select.attachment_folder = pstr_new_attachment.attachment_folder
	end if
	lstr_folder_select.filepath = f_temp_file(pstr_attachment.extension)
	log.file_write(pstr_attachment.attachment, lstr_folder_select.filepath)
	lstr_folder_select.cpr_id = pstr_new_attachment.cpr_id
	lstr_folder_select.context_object = 'Patient' // hard coded because otherwise we get no folders
	lstr_folder_select.context_object_type = pstr_attachment_context.context_object_type
	lstr_folder_select.object_key = pstr_attachment_context.object_key
	lstr_folder_select.attachment_type = pstr_attachment.attachment_type
	lstr_folder_select.extension = pstr_attachment.extension
	lstr_folder_select.description = pstr_new_attachment.attachment_tag
//	if idx_att < external_source.observations[idx_obs].attachment_list.attachment_count then
		lstr_folder_select.apply_to_all_flag = "N"
//	else
//		// Hide the "Apply to all" options
//		lstr_folder_select.apply_to_all_flag = "X"
//	end if
	// Hide the "Remove" options
	lstr_folder_select.remove_flag = "X"

	// Ask the user what folder they want and get the attachment context returned
	Openwithparm(w_post_attachment, lstr_folder_select)
	pstr_attachment_context = message.powerobjectparm
end if
end subroutine

public function integer interpret_context (ref str_attachment_context pstr_attachment_context, ref str_attributes pstr_document_attributes, ref str_attachment pstr_new_attachment);string ls_temp, ls_temp2

if pstr_document_attributes.attribute_count > 0 then
	ls_temp = f_attribute_find_attribute(pstr_document_attributes, "cpr_id")
	if not isnull(ls_temp) then
		pstr_new_attachment.cpr_id = trim(ls_temp)
		pstr_attachment_context.context_object = "Patient"
		setnull(pstr_attachment_context.context_object_type)
		setnull(pstr_attachment_context.object_key)
	end if
	ls_temp = trim(f_attribute_find_attribute(pstr_document_attributes, "billing_id"))
	if len(ls_temp) > 0 then
		SELECT cpr_id
		INTO :ls_temp2
		FROM p_Patient
		WHERE billing_id = :ls_temp;
		if not tf_check() then
			return -1
		end if
		if sqlca.sqlcode <> 100 then
			pstr_new_attachment.cpr_id = ls_temp2
			pstr_attachment_context.context_object = "Patient"
			setnull(pstr_attachment_context.context_object_type)
			setnull(pstr_attachment_context.object_key)
		end if
	end if
	ls_temp = f_attribute_find_attribute(pstr_document_attributes, "encounter_id")
	if not isnull(ls_temp) then
		pstr_new_attachment.encounter_id = long(ls_temp)
		SELECT encounter_type
		INTO :pstr_attachment_context.context_object_type
		FROM p_Patient_Encounter
		WHERE cpr_id = :pstr_new_attachment.cpr_id
		AND encounter_id = :pstr_new_attachment.encounter_id;
		if not tf_check() then
			return -1
		end if
		if sqlca.sqlcode = 100 then
			setnull(pstr_new_attachment.encounter_id)
			setnull(pstr_attachment_context.context_object_type)
			setnull(pstr_attachment_context.object_key)
		else
			pstr_attachment_context.context_object = "Encounter"
			pstr_attachment_context.object_key = pstr_new_attachment.encounter_id
		end if
	end if
	ls_temp = f_attribute_find_attribute(pstr_document_attributes, "problem_id")
	if not isnull(ls_temp) then
		pstr_new_attachment.problem_id = long(ls_temp)
		SELECT assessment_type
		INTO :pstr_attachment_context.context_object_type
		FROM p_Assessment
		WHERE cpr_id = :pstr_new_attachment.cpr_id
		AND problem_id = :pstr_new_attachment.problem_id
		AND current_flag = 'Y';
		if not tf_check() then
			return -1
		end if
		if sqlca.sqlcode = 100 then
			setnull(pstr_new_attachment.problem_id)
			setnull(pstr_attachment_context.context_object_type)
			setnull(pstr_attachment_context.object_key)
		else
			pstr_attachment_context.context_object = "Assessment"
			pstr_attachment_context.object_key = pstr_new_attachment.problem_id
		end if
	end if
	ls_temp = f_attribute_find_attribute(pstr_document_attributes, "treatment_id")
	if not isnull(ls_temp) then
		pstr_new_attachment.treatment_id = long(ls_temp)
		SELECT treatment_type
		INTO :pstr_attachment_context.context_object_type
		FROM p_Treatment_Item
		WHERE cpr_id = :pstr_new_attachment.cpr_id
		AND treatment_id = :pstr_new_attachment.treatment_id;
		if not tf_check() then
			return -1
		end if
		if sqlca.sqlcode = 100 then
			setnull(pstr_new_attachment.treatment_id)
			setnull(pstr_attachment_context.context_object_type)
			setnull(pstr_attachment_context.object_key)
		else
			pstr_attachment_context.context_object = "Treatment"
			pstr_attachment_context.object_key = pstr_new_attachment.treatment_id
		end if
	end if
	ls_temp = f_attribute_find_attribute(pstr_document_attributes, "observation_sequence")
	if not isnull(ls_temp) then
		pstr_new_attachment.observation_sequence = long(ls_temp)
		pstr_attachment_context.context_object = "Observation"
		setnull(pstr_attachment_context.context_object_type)
		pstr_attachment_context.object_key = pstr_new_attachment.observation_sequence
	end if
	ls_temp = f_attribute_find_attribute(pstr_document_attributes, "attachment_type")
	if not isnull(ls_temp) then
		pstr_new_attachment.attachment_type = trim(ls_temp)
	end if
	
	ls_temp = f_attribute_find_attribute(pstr_document_attributes, "folder")
	if not isnull(ls_temp) then
		pstr_new_attachment.attachment_folder = trim(ls_temp)
	end if
end if

RETURN 1

end function

public function integer external_source_not_found (string ps_external_source);string ls_message
str_popup popup
str_popup_return popup_return

ls_message = 'The specified external source ('
ls_message += ps_external_source
ls_message += ') does not exist on this computer.'
if gnv_app.cpr_mode = "SERVER" then
	// If we're in server mode then just return an error
	log.log(this, "w_svc_external_source.external_source_not_found:0010", ls_message, 4)
	return -1
else
	openwithparm(w_pop_message, ls_message)
	
	if service.manual_service then
		return -1
	else
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
			end if
		end if
	end if
end if

return 1
end function

on w_svc_external_source.create
call super::create
end on

on w_svc_external_source.destroy
call super::destroy
end on

event open;call super::open;service = message.powerobjectparm

this.function POST do_source()



end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_external_source
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_external_source
end type

