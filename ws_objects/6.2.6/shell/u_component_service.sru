HA$PBExportHeader$u_component_service.sru
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

DECLARE lsp_get_next_auto_perform_service PROCEDURE FOR dbo.sp_Get_Next_Auto_Perform_Service  
         @pl_patient_workplan_item_id = :patient_workplan_item_id,   
         @ps_user_id = :current_user.user_id,   
         @pl_next_patient_workplan_item_id = :ll_next_patient_workplan_item_id OUT
USING cprdb;

setnull(ldt_progress_date_time)


// Turn off the mouse pointer
setnull(ll_hCursor)
ll_hCursor = SetCursor(ll_hCursor)

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
	mylog.log(this, "do_service()", "User not authorized to perform service (" + service + ")", 4)
	if cpr_mode = "CLIENT" then
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
		log.log(this, "do_service()", "Previous cpr_id different from current cpr_id (" + current_patient.cpr_id + ", " + cpr_id + ")", 3)
		li_sts = f_set_patient(cpr_id)
		my_patient = true
	else
		// The current_patient exists but is the wrong patient.  Log a warning.
		log.log(this, "do_service()", "Error changing cpr_id (" + current_patient.cpr_id + ", " + cpr_id + ")", 4)
		restore_service_state(-1)
		return -1
	End if
	If li_sts <= 0 Then
		mylog.log(this, "do_service()", "unable to set patient (" + cpr_id + ")", 4)
		restore_service_state(-1)
		Return -1
	End If
	
	// We have a patient, so see if the user is authorized to see this patient
	if not f_strings_equal(current_user.user_id, current_patient.primary_provider_id) &
	  and not f_strings_equal(current_user.user_id, current_patient.primary_provider_id) then
	  // If the user is not the primary or secondary provider, then check the access control list
		if not user_list.check_access(current_user.user_id, current_patient.access_control_list) then
			mylog.log(this, "do_service()", "User not authorized to see this patient", 4)
			if cpr_mode = "CLIENT" then
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
		mylog.log(this, "do_service()", "unable to set current encounter (" + cpr_id + ", " + string(encounter_id) + ")", 4)
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
			mylog.log(this, "do_service()", "Error getting treatment object (" + string(treatment_id) + ")", 4)
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

if cpr_mode = "CLIENT" then
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
			if cpr_mode = "CLIENT" then
				// If the room has changed and we're in client mode, then Select/Set the next room
				ls_next_room_id = current_patient.open_encounter.room_menu()
				If Not isnull(ls_next_room_id) Then
					li_sts2 = current_patient.open_encounter.change_room(ls_next_room_id)
					If li_sts2 < 0 Then
						mylog.log(This, "do_service()", "Error changeing room (" + ls_next_room_id + ")", 4)
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
																		computer_id)
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
				computer_id)
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
	if do_autoperform and cpr_mode = "CLIENT" and li_sts > 0 and (not manual_service or (visible_flag = "N")) then
		EXECUTE lsp_get_next_auto_perform_service;
		if not cprdb.check() then
			restore_service_state(-1)
			return -1
		end if
		
		FETCH lsp_get_next_auto_perform_service INTO :ll_next_patient_workplan_item_id;
		if not cprdb.check() then
			restore_service_state(-1)
			return -1
		end if
		
		CLOSE lsp_get_next_auto_perform_service;
		
		if not isnull(ll_next_patient_workplan_item_id) then
			service_list.do_service(ll_next_patient_workplan_item_id)
		end if
	end if
	
	// If this was the initial service for this user then check for auto-perform
	// services and then clean up
	if isnull(last_service) then
		// Clear the office status cache so it reflects this service closure immediately
		if cpr_mode = "CLIENT" then datalist.clear_cache("office_status")
		
		if my_patient then f_clear_patient()
	
		// Tell the user object that the service is completed
		if cpr_mode = "CLIENT" then current_user.complete_service()
		
		// Reclaim orphan objects
		//garbagecollect()
	End If
CATCH (throwable lo_error)
	ls_error = "Error doing service"
	if not isnull(lo_error.text) then
		ls_error += " (" + lo_error.text + ")"
	end if
	log.log(this, "do_service()", ls_error, 4)
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
		mylog.log(this, "xx_do_service()", "Unable to establish ADO Connection", 4)
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
		log.log(this, "xx_do_service()", "Invalid class returned from service window (" + service + ", " + ls_window_class + ")", 4)
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

on u_component_service.create
call super::create
end on

on u_component_service.destroy
call super::destroy
end on

