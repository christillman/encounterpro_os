$PBExportHeader$u_component_service_get_refills.sru
forward
global type u_component_service_get_refills from u_component_service
end type
end forward

global type u_component_service_get_refills from u_component_service
end type
global u_component_service_get_refills u_component_service_get_refills

type variables
string refill_event_type
end variables

forward prototypes
public function integer xx_do_service ()
public function boolean check_completeness ()
end prototypes

public function integer xx_do_service ();long ll_return
str_popup_return        popup_return
//string ls_prescription_mode
string ls_treatment_mode
boolean lb_document_management_mode
string ls_temp
string ls_message
string ls_null

setnull(ls_null)

// Determine document management mode
get_attribute("Use Document Management", ls_temp)
if len(ls_temp) > 0 then
	lb_document_management_mode = f_string_to_boolean(ls_temp)
else
	lb_document_management_mode = datalist.get_preference_boolean("PREFERENCES", "Use Document Management", false)
end if

// The event type must be either "Order", "Request", or "Response"
// See if this is a medication or a refill request
get_attribute("Refill Event Type", refill_event_type)
if len(refill_event_type) > 0 then
	CHOOSE CASE lower(refill_event_type)
		CASE "order", "request", "response"
			refill_event_type = wordcap(refill_event_type)
			if refill_event_type = "Order" and (isnull(current_user.certified) OR upper(current_user.certified) <> "Y") then
				ls_message = "The Refill Event Type is ~"Order~" but only certififed prescribers may order refills and you are not certified.  Do you wish to ~"Request~" a refill instead?"
				openwithparm(w_pop_yes_no, ls_message)
				popup_return = message.powerobjectparm
				if popup_return.item <> "YES" then
					log.log(this, "xx_do_service()", "Error:  Refill Event Type  is ~"Order~" but user is not certified.", 3)
					return -1
				end if
				
				refill_event_type = "Request"
			end if
		CASE ELSE
			log.log(this, "xx_do_service()", "Warning:  invalid Refill Event Type (" + refill_event_type + ").  EncounterPRO will infer the event type from the context.", 3)
			setnull(refill_event_type)
	END CHOOSE
end if

if isnull(refill_event_type) then
	// The event type is not specified directly so infer it from the context
	if lower(treatment.treatment_type) = "refillmedication" then
		// If the service is run against a refillmedication treatment then assume that this is a response to a refill request
		refill_event_type = "Response"
	elseif lower(classname()) = "u_component_service_new_refill_request" then
		// For backwards compatibility, make the default event "Request" if the component is the old request service
		refill_event_type = "Request"
	elseif upper(current_user.certified) = "Y" then
		// if the user is a certified prescriber then assume they want to order a refill
		refill_event_type = "Order"
	else
		// If the user is not a certified prescriber then assume they want to request a refill
		refill_event_type = "Request"
	end if
end if

if not isnull(treatment.treatment_status) and not isnull(treatment.end_date) then
	ls_message = "This treatment was " + lower(treatment.treatment_status) + " on " + string(date(treatment.end_date))
	ls_message += " and only open treatments may be refilled.  Do you wish to reopen this treatment now?"
	openwithparm(w_pop_yes_no, ls_message)
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return 2  // cancel this service
	
	treatment.set_progress('Reopen', ls_null)
end if

CHOOSE CASE lower(refill_event_type)
	CASE "order"
		if not check_completeness() then return -1
		
		if lb_document_management_mode then
				Openwithparm(service_window, this, "w_svc_rx_refill_document")
				popup_return = message.powerobjectparm
		else
			Openwithparm(service_window, this, "w_svc_rx_refill")
			popup_return = message.powerobjectparm
		end if
	CASE "request"
		// We don't need to check the completeness if the non-certified staff is requesting a refill
		Openwithparm(service_window, this, "w_svc_new_refill_request")
		ll_return = message.doubleparm
		
		// The w_svc_new_refill_request screen returns a code rather than a popup_return.  Just return the code to the ancestor class.
		return ll_return
	CASE "response"
		if not check_completeness() then return -1
		
		Openwithparm(service_window, this, "w_svc_rx_refill_request")
		popup_return = message.powerobjectparm
END CHOOSE


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



end function

public function boolean check_completeness ();integer li_sts
string ls_admin_instructions
string ls_dosing_instructions
str_treatment_description lstr_treatment
boolean lb_complete
string ls_message
str_popup_return popup_return
u_component_treatment luo_treatment

// If the current treatment context is "RefillMedication" then call the edit service for the parent treatment
if lower(treatment.treatment_type) = "refillmedication" then
	if isnull(treatment.parent_treatment_id) then
		log.log(this, "check_completeness()", "refillmedication treatment must have a parent treatment", 4)
		return false
	end if
	li_sts = current_patient.treatments.treatment(luo_treatment, treatment.parent_treatment_id)
	if li_sts <= 0 then
		log.log(this, "check_completeness()", "Error getting parent treatment (" + cpr_id + ", " + string(treatment.parent_treatment_id) + ")", 4)
		return false
	end if
else
	luo_treatment = treatment
end if


DO WHILE true
	lb_complete = true
	ls_message = ""
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Make sure that this treatment has the required fields
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	if isnull(luo_treatment.drug_id) then
		if len(ls_message) > 0 then ls_message += "  "
		ls_message += "Medication has no Drug selected."
		lb_complete = false
	end if
	
	if isnull(luo_treatment.package_id) then
		if len(ls_message) > 0 then ls_message += "  "
		ls_message += "Medication has no Package selected."
		lb_complete = false
	end if
	
	if isnull(luo_treatment.dispense_amount) or isnull(luo_treatment.dispense_unit) or luo_treatment.dispense_amount <= 0 then
		if len(ls_message) > 0 then ls_message += "  "
		ls_message += "Medication has no Dispense information."
		lb_complete = false
	end if
	
	lstr_treatment = luo_treatment.treatment_description()
	
	// if the admin progress note is missing then automatically generate it
	ls_admin_instructions = f_get_progress_value(cpr_id, "Treatment", treatment_id, "Instructions", "Admin Instructions")
	if isnull(ls_admin_instructions) or trim(ls_admin_instructions) = "" then
		ls_admin_instructions = drugdb.treatment_admin_description(lstr_treatment)
		li_sts = current_patient.treatments.set_treatment_progress(treatment_id, "Instructions", "Admin Instructions", ls_admin_instructions)
		if li_sts < 0 then 
			if len(ls_message) > 0 then ls_message += "  "
			ls_message += "Medication has no Admin Instructions."
			lb_complete = false
		end if
	end if	
	
	// if the dosing progress note is missing then automatically generate it
	ls_dosing_instructions = f_get_progress_value(cpr_id, "Treatment", treatment_id, "Instructions", "Dosing Instructions")
	if isnull(ls_dosing_instructions) or trim(ls_dosing_instructions) = "" then
		ls_dosing_instructions = drugdb.treatment_dosing_description(lstr_treatment)
		li_sts = current_patient.treatments.set_treatment_progress(treatment_id, "Instructions", "Dosing Instructions", ls_dosing_instructions)
		if li_sts < 0 then 
			if len(ls_message) > 0 then ls_message += "  "
			ls_message += "Medication has no Dosing Instructions."
			lb_complete = false
		end if
	end if	
	
	if lb_complete then exit
	
	openwithparm(w_pop_message, ls_message)
	
	ls_message = "The medication is not complete and needs to be edited before it can be refilled.  Do you wish to edit the medication now?"
	openwithparm(w_pop_yes_no, ls_message)
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then exit
	
	str_service_info lstr_service
	
	lstr_service.context = context()
	lstr_service.context.treatment_id = luo_treatment.treatment_id
	
	get_attribute("edit_service", lstr_service.service)
	if isnull(lstr_service.service) then lstr_service.service = "EDIT_MEDICATION"
	
	service_list.do_service(lstr_service)
LOOP

return lb_complete


end function

on u_component_service_get_refills.create
call super::create
end on

on u_component_service_get_refills.destroy
call super::destroy
end on

