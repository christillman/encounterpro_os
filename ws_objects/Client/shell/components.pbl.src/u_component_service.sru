$PBExportHeader$u_component_service.sru
forward
global type u_component_service from u_component_workplan_item
end type
end forward

global type u_component_service from u_component_workplan_item
end type
global u_component_service u_component_service

forward prototypes
public function integer do_service (long pl_patient_workplan_item_id)
public function u_component_treatment get_treatment_context ()
public function integer do_service (string ps_cpr_id, long pl_patient_workplan_id, string ps_service, string ps_ordered_by, string ps_ordered_for, string ps_created_by)
public function boolean xx_any_params (string ps_param_mode)
public function integer xx_configure_service (string ps_param_mode, ref str_attributes pstr_attributes)
public function integer xx_do_service ()
public function boolean any_params (string ps_param_mode)
public function integer configure_service (string ps_param_mode, ref str_attributes pstr_attributes)
public subroutine component_service_list ()
end prototypes

public function integer do_service (long pl_patient_workplan_item_id);/////////////////////////////////////////////////////////////////////////////////////////////////
//
//	Return: Integer:  <0 = Error, 0 = Nothing Happened, >0 = Success
//
//	Description: finds the requested service from p_Patient_WP_Item and starts
//              the service.
//
// Created By:Sumathi Chinnasamy														Created On:04/07/2000
/////////////////////////////////////////////////////////////////////////////////////////////////
Integer						li_count
integer						li_sts
String						ls_treatment_type,ls_component_id
str_attributes lstr_attributes
string ls_status
string ls_next_room_id
string ls_wp_cpr_id
long ll_wp_encounter_id
long ll_next_patient_workplan_item_id
integer li_sts2
String	ls_progress_type
datetime ldt_progress_date_time
long ll_temp
ulong ll_hCursor
ulong ll_whandle
string ls_owner_role
str_popup popup
integer li_choice
string ls_error
u_component_service luo_service
boolean lb_show_alerts
u_component_alert luo_alert
//
//DECLARE lsp_get_next_auto_perform_service PROCEDURE FOR dbo.sp_Get_Next_Auto_Perform_Service  
//         @pl_patient_workplan_item_id = :patient_workplan_item_id,   
//         @ps_user_id = :current_user.user_id,   
//         @pl_next_patient_workplan_item_id = :ll_next_patient_workplan_item_id OUT
//USING cprdb;

setnull(ldt_progress_date_time)

SetPointer(HourGlass!)

// Initialize the my_patient and my_treatment booleans
my_patient = false
my_treatment = false

// Save the previous service state so we can restore it when this service exits
save_service_state()

// Initialize this service object from the workplan item in the database
li_sts = initialize(pl_patient_workplan_item_id)
if li_sts <= 0 then
	restore_service_state(-1)
	Return -1
end if

if user_list.is_role(owned_by) then
	ls_owner_role = owned_by
else
	setnull(ls_owner_role)
end if

// See if this user is authorized to execute this service
if not user_list.is_user_authorized(current_user.user_id, service, context_object) then
	set_progress("Access Denied")
	mylog.log(this, "u_component_service.do_service:0066", "User not authorized to perform service (" + service + ")", 4)
	if gnv_app.cpr_mode = "CLIENT" then
		openwithparm(w_pop_message, "You are not authorized to perform the " + description + " service.")
	end if
	restore_service_state(-1)
	return -1
end if


// If this service is owned by !Exception, then first ask the user what they want to do with it
if lower(owned_by) = "!exception" then
	openwithparm(w_service_exception, this, f_active_window())
	li_sts = message.doubleparm
	if li_sts < 0 then
		restore_service_state(-1)
		return -1
	elseif li_sts = 0 then
		restore_service_state(0)
		return 0
	end if
end if

// Log that the user clicked this service
li_sts = set_progress("Clicked")
if li_sts < 0 then
	restore_service_state(-1)
	Return -1
end if


// Check to see if the current patient context already match
// the patient  context for this service
If not isnull(cpr_id) Then
	If isnull(current_patient) Then
		li_sts = f_set_patient(cpr_id)
		my_patient = true
	elseif current_patient.cpr_id = cpr_id then
		// The current_patient is already the correct patient
		li_sts = 1
	elseif not inherited_patient then
		// The current_patient exists but is the wrong patient.  Log a warning.
		log.log(this, "u_component_service.do_service:0107", "Previous cpr_id different from current cpr_id (" + current_patient.cpr_id + ", " + cpr_id + ")", 3)
		li_sts = f_set_patient(cpr_id)
		my_patient = true
	else
		// The current_patient exists but is the wrong patient.  Log a warning.
		log.log(this, "u_component_service.do_service:0112", "Error changing cpr_id (" + current_patient.cpr_id + ", " + cpr_id + ")", 4)
		restore_service_state(-1)
		return -1
	End if
	If li_sts <= 0 Then
		mylog.log(this, "u_component_service.do_service:0117", "unable to set patient (" + cpr_id + ")", 4)
		restore_service_state(-1)
		Return -1
	End If
	
	// We have a patient, so see if the user is authorized to see this patient
	if not f_strings_equal(current_user.user_id, current_patient.primary_provider_id) &
	  and not f_strings_equal(current_user.user_id, current_patient.primary_provider_id) then
	  // If the user is not the primary or secondary provider, then check the access control list
		if not user_list.check_access(current_user.user_id, current_patient.access_control_list) then
			mylog.log(this, "u_component_service.do_service:0127", "User not authorized to see this patient", 4)
			if gnv_app.cpr_mode = "CLIENT" then
				openwithparm(w_pop_message, "You are not authorized to perform any services for this patient.")
			end if
			restore_service_state(-1)
			return -1
		end if
	end if
End if


// Set the encounter context
if not isnull(encounter_id) then
	li_sts = f_set_current_encounter(encounter_id)
	If li_sts <= 0 Then
		mylog.log(this, "u_component_service.do_service:0142", "unable to set current appointment (" + cpr_id + ", " + string(encounter_id) + ")", 4)
		restore_service_state(-1)
		Return -1
	End If
end if


// Set up the treatment object is necessary
if isnull(treatment_id) then
	Setnull(treatment)
else
	// If the treatment object already exists, make sure it's for the right treatment
	if not isnull(treatment) then
		if treatment.treatment_id <> treatment_id then setnull(treatment)
	end if
	
	if isnull(treatment) then
		// before we instantiate another treatment object, see if the previous
		// service has already instantiated it
		if not isnull(last_service) then
			if not isnull(last_service.treatment) then
				if last_service.treatment.treatment_id = treatment_id then
					treatment = last_service.treatment
				end if
			end if
		end if
	end if
		
	// If we still don't have a treatment object then instantiate one
	if isnull(treatment) then
		my_treatment = true
		li_sts = current_patient.treatments.treatment(treatment, treatment_id)
		if li_sts <= 0 then
			mylog.log(this, "u_component_service.do_service:0175", "Error getting treatment object (" + string(treatment_id) + ")", 4)
			restore_service_state(-1)
			Return -1
		End If
	end if

	// Make sure the treatment_id is in the attributes
	add_attribute("treatment_id", string(treatment_id))
end if


// Then, if the runtime parameters haven't already been added, get them
if runtime_configured_flag = "N" then
	li_sts = configure_service("Runtime", lstr_attributes)
	if li_sts < 0 then
		restore_service_state(-1)
		return -1
	end if
	runtime_configured_flag = "Y"
end if

// Lock the service and check if user can do service
li_sts = doing_service()
// Since "0" represents a user choice to cancel or not take over the service/encounter, a "0" return
// should be treated as an error for manual services.  This will cause the manual service to be cancelled.
if li_sts < 0 or (li_sts = 0 and manual_service) then
	restore_service_state(-1)
	return -1
elseif li_sts = 0 then
	restore_service_state(0)
	return 0
end if

// Now that we're cleared to perform the service, log a "started" record
li_sts = set_progress("STARTED")
if li_sts < 0 then
	restore_service_state(-1)
	Return -1
end if

if gnv_app.cpr_mode = "CLIENT" then
	get_attribute("show_alerts", lb_show_alerts)
	if lb_show_alerts and not isnull(current_patient) then
		luo_alert = component_manager.get_component(common_thread.chart_alert_component())
		If Isvalid(luo_alert) Then
			li_sts = luo_alert.alert(current_patient.cpr_id, current_patient.open_encounter_id, "ALERT")
			component_manager.destroy_component(luo_alert)
		End If
	end if
end if

TRY
	// Set the current service to this
	current_service = this
	
	If Not Isnull(current_patient) Then
		If Isvalid(current_patient.open_encounter) Then
			if gnv_app.cpr_mode = "CLIENT" then
				// If the room has changed and we're in client mode, then Select/Set the next room
				ls_next_room_id = current_patient.open_encounter.room_menu()
				If Not isnull(ls_next_room_id) Then
					li_sts2 = current_patient.open_encounter.change_room(ls_next_room_id)
					If li_sts2 < 0 Then
						mylog.log(This, "u_component_service.do_service:0238", "Error changeing room (" + ls_next_room_id + ")", 4)
					End If
				End If
			end if
		End If
	End If
	
	li_sts = xx_do_service()
	
	// return status:
	// <0 = Error
	// 0 = Service was not completed (no change is status)
	// 1 = Service was completed
	// 2 = Service was cancelled
	// 3 = User has requested to put service on to-do list
	// 4 = User has requested to revert service to original owner
	
	if li_sts < 0 then
		do_service_error()
	else
		If li_sts = 0 Then
			if manual_service then
				// I'll be back for a manual service is the same as cancelling
				ls_status = "CANCELLED"
			else
				ls_status = "CONTINUED"
				// If the user said "I'll Be BacK" and they took this service from a role,
				// then ask them if they want to send it back to the role
				if not isnull(ls_owner_role) then
					popup.title = "This service was owned by the '" + user_list.role_name(ls_owner_role) + "' role.  Do you wish to:"
					popup.data_row_count = 2
					popup.items[1] = "Leave this service for the role"
					popup.items[2] = "Keep ownership of this service"
					openwithparm(w_pop_choices_2, popup, f_active_window())
					li_choice = message.doubleparm
					if li_choice = 1 Then
						sqlca.sp_set_workplan_item_progress(patient_workplan_item_id, &
																		ls_owner_role, &
																		"Change Owner", &
																		ldt_progress_date_time, &
																		current_scribe.user_id, &
																		gnv_app.computer_id)
						if not tf_check() then
							restore_service_state(-1)
							return -1
						end if
					End If
				end if
			end if
		Elseif li_sts = 1 Then
			ls_status = "COMPLETED"
		Elseif li_sts = 2 Then
			ls_status = "CANCELLED"
		Elseif li_sts = 3 Then
			if step_flag <> "Y" and cancel_workplan_flag <> "Y" then
				ls_status = "DOLATER"
			else
				ls_status = "CONTINUED"
			end if
		Elseif li_sts = 4 Then
			ls_status = "Revert To Original Owner"
		else
			ls_status = "CONTINUED"
		End If
		
		cprdb.sp_set_workplan_item_progress( &
				pl_patient_workplan_item_id, &
				current_user.user_id, &
				ls_status, &
				ldt_progress_date_time, &
				current_scribe.user_id, &
				gnv_app.computer_id)
		if not cprdb.check() then
			restore_service_state(-1)
			return -1
		end if
		
		// If there's a current patient then reload the patient data
		if not isnull(current_patient) then current_patient.reload()
		
		// If there's valid treatment component then refresh the treatment status
		If Isvalid(treatment) and Not Isnull(treatment) Then
			treatment.refresh()
		End If
	End If
	
	// Clear lock on service
	not_doing_service()
	
	// If we created the treatment object then destroy it
	if not isnull(treatment) then
		if my_treatment then
			component_manager.destroy_component(treatment)
			setnull(treatment)
		else
			li_sts2 = current_patient.treatments.treatment_update_if_modified(treatment)
			if li_sts2 = 1 then
				// update all the instantiated services
				luo_service = last_service
				DO WHILE not isnull(luo_service)
					li_sts2 = current_patient.treatments.treatment_update_if_modified(luo_service.treatment)
					luo_service = luo_service.last_service
				LOOP
					
			end if
		end if
	end if

	// if we completed or cancelled this service then check for next auto-perform service
	if do_autoperform and gnv_app.cpr_mode = "CLIENT" and li_sts > 0 and (not manual_service or (visible_flag = "N")) then
		
	cprdb.sp_Get_Next_Auto_Perform_Service (patient_workplan_item_id,current_user.user_id,ref ll_next_patient_workplan_item_id);
			
	//	EXECUTE lsp_get_next_auto_perform_service;
		if not cprdb.check() then
			restore_service_state(-1)
			return -1
		end if
		
//		FETCH lsp_get_next_auto_perform_service INTO :ll_next_patient_workplan_item_id;
//		if not cprdb.check() then
//			restore_service_state(-1)
//			return -1
//		end if
//		
//		CLOSE lsp_get_next_auto_perform_service;
		
		if not isnull(ll_next_patient_workplan_item_id) then
			service_list.do_service(ll_next_patient_workplan_item_id)
		end if
	end if
	
	// If this was the initial service for this user then check for auto-perform
	// services and then clean up
	if isnull(last_service) then
		// Clear the office status cache so it reflects this service closure immediately
		if gnv_app.cpr_mode = "CLIENT" then datalist.clear_cache("office_status")
		
		if my_patient then f_clear_patient()
	
		// Tell the user object that the service is completed
		if gnv_app.cpr_mode = "CLIENT" then current_user.complete_service()
		
		// Reclaim orphan objects
		//garbagecollect()
	End If
CATCH (throwable lo_error)
	ls_error = "Error doing service"
	if not isnull(lo_error.text) then
		ls_error += " (" + lo_error.text + ")"
	end if
	log.log(this, "u_component_service.do_service:0386", ls_error, 4)
	li_sts = -1
FINALLY
	// Restore the previous service state
	restore_service_state(li_sts)
END TRY


Return li_sts

end function

public function u_component_treatment get_treatment_context ();u_component_service luo_service

luo_service = this

DO WHILE true
	if not isnull(luo_service.treatment) then return luo_service.treatment
	
	luo_service = luo_service.last_service
	if not isvalid(luo_service) or isnull(luo_service) then exit
LOOP

return treatment

end function

public function integer do_service (string ps_cpr_id, long pl_patient_workplan_id, string ps_service, string ps_ordered_by, string ps_ordered_for, string ps_created_by);long ll_patient_workplan_item_id
long ll_encounter_id
string ls_in_office_flag
string ls_auto_perform_flag
string ls_observation_tag
string ls_description
integer li_step_number

setnull(ll_encounter_id)
setnull(ls_in_office_flag)
setnull(ls_auto_perform_flag)
setnull(ls_observation_tag)
setnull(ls_description)
setnull(li_step_number)
	
// Order service	
cprdb.sp_order_service_workplan_item( &
		ps_cpr_id, &
		ll_encounter_id, &
		pl_patient_workplan_id, &
		ps_service, &
		ls_in_office_flag, &
		ls_auto_perform_flag, &
		ls_observation_tag, &
		ls_description, &
		ps_ordered_by, &
		ps_ordered_for, &
		li_step_number, &
		ps_created_by, &
		ll_patient_workplan_item_id)
if not cprdb.check() then return -1

// perform service
manual_service = true
return do_service(ll_patient_workplan_item_id)

end function

public function boolean xx_any_params (string ps_param_mode);string lsa_attributes[]
string lsa_values[]
integer li_count

If ole_class then
	li_count = get_attributes(lsa_attributes, lsa_values)
	return ole.any_params(patient_workplan_item_id, li_count, lsa_attributes, lsa_values)
Else
	// If not overridden by descendent class, then assume no params
	Return false
end if

end function

public function integer xx_configure_service (string ps_param_mode, ref str_attributes pstr_attributes);string lsa_attributes[]
string lsa_values[]
integer li_count
long i
long ll_count
integer li_sts
string ls_description
string ls_attribute
string ls_value
string ls_find
long ll_row

If ole_class then
	// If ole class
	li_count = get_attributes(lsa_attributes, lsa_values)
	li_sts = ole.configure_service(service, ps_param_mode, li_count, lsa_attributes, lsa_values)
	if li_sts <= 0 then return li_sts
	
	ls_description = ole.description
	if not isnull(ls_description) and trim(ls_description) <> "" then
		description = trim(ls_description)
	end if
	
	ll_count = ole.attribute_count
	for i = 1 to ll_count
		ls_attribute = ole.attribute[i]
		ls_value = ole.value[i]
		f_attribute_add_attribute(pstr_attributes, ls_attribute, ls_value)
	next
end if

return 1


end function

public function integer xx_do_service ();// Date Begun: ??/??/??
// Programmer: Mark Copenhaver (MC)
//
// Purpose: 
// Expects: 
//
// Returns: integer 									
// Limits:	
// History:

string lsa_attributes[]
string lsa_values[]
integer li_count
str_popup_return        popup_return
str_popup					popup
string ls_window_class
integer li_sts

If ole_class then
	li_sts = common_thread.get_adodb(adodb)
	if li_sts <= 0 then
		mylog.log(this, "u_component_service.xx_do_service:0022", "Unable to establish ADO Connection", 4)
		return -1
	end if
	
	li_count = get_attributes(lsa_attributes, lsa_values)
	return ole.do_service(adodb, patient_workplan_item_id, li_count, lsa_attributes, lsa_values)
Else
	ls_window_class = get_attribute("window_class")
	
	// If no window class is configured, then just return success
	if isnull(ls_window_class) then return 1
	
	Openwithparm(service_window, this, ls_window_class, f_active_window())
	if lower(classname(message.powerobjectparm)) = "str_popup_return" then
		popup_return = message.powerobjectparm
	else
		log.log(this, "u_component_service.xx_do_service:0038", "Invalid class returned from service window (" + service + ", " + ls_window_class + ")", 4)
		return -1
	end if
	
	if popup_return.item_count <> 1 then return 0
	
	if (popup_return.items[1] = "COMPLETE") or (popup_return.items[1] = "OK") then
		return 1
	elseif popup_return.items[1] = "CANCEL" then
		return 2
	elseif popup_return.items[1] = "DOLATER" then
		return 3
	elseif popup_return.items[1] = "REVERT" then
		return 4
	elseif popup_return.items[1] = "ERROR" then
		return -1
	else
		return 0
	end if
end if

end function

public function boolean any_params (string ps_param_mode);integer li_count

// See if there are any parameters of the specified mode
SELECT count(*)
INTO :li_count
FROM c_Component_Param
WHERE id = :id
AND param_mode = :ps_param_mode
USING cprdb;
if not cprdb.check() then return false

if li_count > 0 then return true

return xx_any_params(ps_param_mode)


end function

public function integer configure_service (string ps_param_mode, ref str_attributes pstr_attributes);integer li_sts
integer li_sts2

li_sts = f_get_params(id, ps_param_mode, pstr_attributes)
if li_sts < 0 then return li_sts

// Update the attributes with the ones just selected
add_attributes(pstr_attributes)

li_sts2 = xx_configure_service(ps_param_mode, pstr_attributes)
if li_sts2 < 0 then return li_sts

// Again, update the attributes with the ones just selected
add_attributes(pstr_attributes)

// If we have a patient_workplan_item_id, then log the config action
if not isnull(patient_workplan_item_id) then
	set_progress(ps_param_mode + "_Configured")
end if

// If no params were collected, then return 0
if li_sts = 0 and li_sts2 = 0 then return 0

return 1

end function

public subroutine component_service_list ();
// The purpose here is to reference objects which may not otherwise
// be referenced literally for cross reference purposes. 

// These objects are in c_Component_Registry.component_class

string ls_class

ls_class = u_component_alert_standard.classname()
ls_class = u_component_attachment_activex.classname()
ls_class = u_component_attachment_audio.classname()
ls_class = u_component_attachment_brentwood.classname()
ls_class = u_component_attachment_browser.classname()
ls_class = u_component_attachment_dotnet.classname()
ls_class = u_component_attachment_ecg_wlca.classname()
ls_class = u_component_attachment_generic.classname()
ls_class = u_component_attachment_image.classname()
ls_class = u_component_attachment_isf.classname()
ls_class = u_component_attachment_link.classname()
ls_class = u_component_attachment_psreport.classname()
ls_class = u_component_attachment_signature_cic.classname()
ls_class = u_component_attachment_signature_easyink.classname()
ls_class = u_component_attachment_signature_penop.classname()
ls_class = u_component_attachment_xml.classname()
ls_class = u_component_billing_encounterpro.classname()
ls_class = u_component_billing_foxmeadows.classname()
ls_class = u_component_billing_lytec.classname()
//ls_class = u_component_billing_medicat.classname()
ls_class = u_component_billing_medman.classname()
//ls_class = u_component_billing_paradigm.classname()
//ls_class = u_component_billing_paradigm3.classname()
//ls_class = u_component_billing_raintree.classname()
// u_component_chartpage
ls_class = u_component_coding_medicaid.classname()
ls_class = u_component_coding_standard.classname()
ls_class = u_component_document_datawindow.classname()
ls_class = u_component_document_dotnet.classname()
ls_class = u_component_document_growth_chart.classname()
ls_class = u_component_document_link.classname()
ls_class = u_component_document_receiver_epie.classname()
ls_class = u_component_document_rtf.classname()
ls_class = u_component_document_template.classname()
ls_class = u_component_document_xml.classname()
ls_class = u_component_drug.classname()
//ls_class = u_component_e_prescribing.classname()
//ls_class = u_component_event_message.classname()
//ls_class = u_component_event_server.classname()
ls_class = u_component_incoming_filecopy.classname()
ls_class = u_component_incoming_filecopy_hl7.classname()
ls_class = u_component_message_creator.classname()
//ls_class = u_component_message_creator_labs.classname()
ls_class = u_component_message_handler.classname()
ls_class = u_component_message_handler_foxy.classname()
//ls_class = u_component_message_handler_hl7.classname()
ls_class = u_component_message_handler_lytec.classname()
ls_class = u_component_message_handler_medisys.classname()
ls_class = u_component_message_handler_medman.classname()
ls_class = u_component_message_handler_raintree.classname()
ls_class = u_component_messageserver_standard.classname()
ls_class = u_component_nomenclature_medcin.classname()
ls_class = u_component_observation_brentwood_ecg.classname()
//ls_class = u_component_observation_brentwood_spirometer.classname()
ls_class = u_component_observation_cic_signature.classname()
ls_class = u_component_observation_com_document.classname()
ls_class = u_component_observation_easyink_sig.classname()
ls_class = u_component_observation_jmj_attachments.classname()
ls_class = u_component_observation_jmj_camera.classname()
ls_class = u_component_observation_jmj_com.classname()
ls_class = u_component_observation_jmj_dictation.classname()
ls_class = u_component_observation_jmj_file.classname()
ls_class = u_component_observation_jmj_scanner.classname()
ls_class = u_component_observation_jmj_sonymavica.classname()
ls_class = u_component_observation_pbink_sig.classname()
ls_class = u_component_observation_penop_signature.classname()
ls_class = u_component_observation_wia.classname()
ls_class = u_component_observation_wlca_at10.classname()
ls_class = u_component_observation_wlca_spotcheck.classname()
ls_class = u_component_observation_wlca_suresight.classname()
ls_class = u_component_outgoing_filecopy.classname()
ls_class = u_component_outgoing_filecopy_hl7.classname()
ls_class = u_component_outgoing_report_hl7.classname()
ls_class = u_component_property_script.classname()
ls_class = u_component_report_all_encounters.classname()
ls_class = u_component_report_asst_histories.classname()
ls_class = u_component_report_billing_sheet.classname()
ls_class = u_component_report_document_component.classname()
//ls_class = u_component_report_encounter.classname()
ls_class = u_component_report_external_source.classname()
ls_class = u_component_report_immunization.classname()
//ls_class = u_component_report_letter_to_referrer.classname()
ls_class = u_component_report_patient_observations.classname()
//ls_class = u_component_report_patient_summary.classname()
ls_class = u_component_report_prescription.classname()
//ls_class = u_component_report_prescription2.classname()
//ls_class = u_component_report_referral_prescription.classname()
ls_class = u_component_report_rtf.classname()
//ls_class = u_component_report_xml.classname()
ls_class = u_component_reportserver.classname()
ls_class = u_component_route_epie.classname()
ls_class = u_component_route_fax.classname()
ls_class = u_component_route_file.classname()
ls_class = u_component_route_printer.classname()
ls_class = u_component_route_web_upload.classname()
ls_class = u_component_schedule_encounterpro.classname()
ls_class = u_component_schedule_foxmeadows.classname()
ls_class = u_component_schedule_medicat.classname()
ls_class = u_component_schedule_medman.classname()
//ls_class = u_component_schedule_paradigm.classname()
//ls_class = u_component_schedule_paradigm3.classname()
//ls_class = u_component_schedule_raintree.classname()
ls_class = u_component_security_jmj_secure.classname()
ls_class = u_component_send_report_lcr.classname()
ls_class = u_component_serverservice.classname()
//ls_class = u_component_serverservice_autoimport.classname()
//ls_class = u_component_serverservice_email.classname()
ls_class = u_component_serverservice_incoming.classname()
ls_class = u_component_serverservice_messages.classname()
ls_class = u_component_serverservice_outgoing.classname()
ls_class = u_component_service.classname()
ls_class = u_component_service_add_charge.classname()
ls_class = u_component_service_alert.classname()
ls_class = u_component_service_approve.classname()
ls_class = u_component_service_attachment.classname()
ls_class = u_component_service_batch_billing_hl7.classname()
ls_class = u_component_service_billing_edit.classname()
ls_class = u_component_service_browser.classname()
ls_class = u_component_service_cfg_display_script.classname()
ls_class = u_component_service_change_room.classname()
ls_class = u_component_service_chart.classname()
ls_class = u_component_service_close_assessment.classname()
ls_class = u_component_service_close_treatment.classname()
ls_class = u_component_service_config_doc_purpose.classname()
ls_class = u_component_service_config_observations.classname()
ls_class = u_component_service_config_security.classname()
ls_class = u_component_service_configuration.classname()
//ls_class = u_component_service_create_document.classname()
ls_class = u_component_service_db_maintenance.classname()
ls_class = u_component_service_dispatch_followup.classname()
ls_class = u_component_service_dotnet.classname()
ls_class = u_component_service_edit_trt_results.classname()
//ls_class = u_component_service_epro_todo.classname()
ls_class = u_component_service_execute_sql.classname()
ls_class = u_component_service_exit.classname()
ls_class = u_component_service_export_config.classname()
ls_class = u_component_service_external_source.classname()
ls_class = u_component_service_freeform_history.classname()
ls_class = u_component_service_get_medication.classname()
ls_class = u_component_service_get_officemed.classname()
ls_class = u_component_service_get_refills.classname()
ls_class = u_component_service_history.classname()
ls_class = u_component_service_history_display.classname()
ls_class = u_component_service_history_yesno.classname()
// u_component_service_immunization now hopefully unused, replaced procedure selection with vaccine selection
// ls_class = u_component_service_immunization.classname()
ls_class = u_component_service_material.classname()
ls_class = u_component_service_medication.classname()
ls_class = u_component_service_menu.classname()
ls_class = u_component_service_new_progress_note.classname()
ls_class = u_component_service_new_refill_request.classname()
ls_class = u_component_service_obs_attachment.classname()
ls_class = u_component_service_observation_comment.classname()
ls_class = u_component_service_observation_grid.classname()
ls_class = u_component_service_order_assessment.classname()
//ls_class = u_component_service_order_document.classname()
ls_class = u_component_service_order_treatment.classname()
ls_class = u_component_service_order_workplan.classname()
ls_class = u_component_service_past_encounter.classname()
ls_class = u_component_service_patient_checkin.classname()
ls_class = u_component_service_patient_data.classname()
ls_class = u_component_service_patient_msg.classname()
ls_class = u_component_service_patient_workplan.classname()
ls_class = u_component_service_physical.classname()
ls_class = u_component_service_portrait.classname()
//ls_class = u_component_service_post_attachment.classname()
ls_class = u_component_service_procedure.classname()
ls_class = u_component_service_rediagnose.classname()
ls_class = u_component_service_refill_request.classname()
ls_class = u_component_service_reorder_followup.classname()
ls_class = u_component_service_report.classname()
ls_class = u_component_service_review_activity.classname()
ls_class = u_component_service_review_followup.classname()
ls_class = u_component_service_review_referral.classname()
ls_class = u_component_service_send_billing.classname()
//ls_class = u_component_service_transcription.classname()
ls_class = u_component_service_treatment_review.classname()
ls_class = u_component_service_utility.classname()
ls_class = u_component_service_vaccine_signature.classname()
ls_class = u_component_service_vitals.classname()
ls_class = u_component_service_wait.classname()
ls_class = u_component_treatment.classname()
ls_class = u_component_treatment_activity.classname()
ls_class = u_component_treatment_followup.classname()
ls_class = u_component_treatment_immunization.classname()
ls_class = u_component_treatment_material.classname()
ls_class = u_component_treatment_medication.classname()
ls_class = u_component_treatment_officemed.classname()
ls_class = u_component_treatment_procedure.classname()
ls_class = u_component_treatment_referral.classname()
ls_class = u_component_treatment_test.classname()
ls_class = u_component_xml_handler_ccr.classname()
ls_class = u_component_xml_handler_contraindication.classname()
ls_class = u_component_xml_handler_jmj.classname()
ls_class = u_component_xml_handler_jmjmessagestatus.classname()
ls_class = u_component_xml_handler_script.classname()


end subroutine

on u_component_service.create
call super::create
end on

on u_component_service.destroy
call super::destroy
end on

