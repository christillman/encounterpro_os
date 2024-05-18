$PBExportHeader$u_component_workplan_item.sru
forward
global type u_component_workplan_item from u_component_base_class
end type
end forward

shared variables




end variables

global type u_component_workplan_item from u_component_base_class
end type
global u_component_workplan_item u_component_workplan_item

type variables
public string service

public string description
public string button
public string icon
public string close_flag
public string signature_flag
public string owner_flag
public string encounter_flag
public string patient_flag
public string general_flag
public string treatment_flag
public string visible_flag


public long patient_workplan_item_id

public long document_id

// workplan_item attributes
public string cpr_id
public long patient_workplan_id
public long workplan_id
public long item_number
public integer step_number
public string item_type
public string in_office_flag
public string runtime_configured_flag
public string observation_tag
public string ordered_by
public string ordered_for
public string owned_by
public string folder
public string dispatch_method
public datetime dispatch_date
public datetime begin_date
public datetime end_date
public datetime escalation_date
public datetime expiration_date
public string step_flag
public string cancel_workplan_flag
public string auto_perform_flag
public string consolidate_flag
public integer priority
public integer retries
public string status
public string completed_by
public datetime created
public string created_by

// context attributes
public string context_object_type
public string context_description
public long encounter_id
public string workplan_type
public long treatment_id
public long problem_id
public long attachment_id
public long observation_sequence

public u_component_treatment treatment

public boolean manual_service
public integer max_retries = 5

boolean doing_service = false

u_component_service	   last_service
long last_display_encounter_id

boolean my_patient
boolean my_treatment
boolean inherited_patient
boolean service_window_enabled
string patient_domain_value

boolean do_autoperform = true

end variables

forward prototypes
public function integer set_progress (string ps_progress_type)
private function str_attributes get_workplan_item_attributes ()
public function integer save_wp_item_attributes ()
public subroutine reset_service (string ps_service)
public function integer add_workplan_item_attributes (str_attributes pstr_attributes)
public function integer add_workplan_item_attribute (string ps_attribute, string ps_value)
private function str_attributes get_service_attributes ()
public function integer doing_service ()
public subroutine set_service_buttons (ref commandbutton cb_finished, ref commandbutton cb_beback, ref commandbutton cb_dolater)
public function long order_service (string ps_cpr_id, long pl_encounter_id, string ps_ordered_for)
public function long order_service (string ps_cpr_id, long pl_encounter_id, string ps_ordered_for, long pl_attribute_count, string psa_attributes[], string psa_values[])
public function long order_service (string ps_cpr_id, long pl_encounter_id, string ps_ordered_for, string ps_description)
public function long order_service (string ps_ordered_for)
public function long order_service (string ps_cpr_id, long pl_encounter_id, string ps_ordered_for, str_attributes pstr_attributes)
public function long get_root_observation ()
public function integer not_doing_service ()
public function boolean is_encounter_open ()
public function long order_service (string ps_cpr_id, long pl_encounter_id, string ps_ordered_for, integer pi_step_number, string ps_description, str_attributes pstr_attributes)
public function string root_observation_id ()
public subroutine do_service_error ()
public subroutine display_properties ()
public function integer initialize (long pl_patient_workplan_item_id)
public function integer get_service_properties ()
private function integer get_root_observation_ids (ref string ps_parent_observation_id, ref string ps_child_observation_id)
public subroutine restore_service_state (integer pi_sts)
public subroutine save_service_state ()
public function string get_all_messages ()
public function integer forward_workplan_item (string ps_to_user_id, string ps_new_description, string ps_new_message)
public function integer show_dashboard ()
public function integer show_dashboard (string ps_context_object, long pl_object_key)
public subroutine set_attribute (string ps_attribute, string ps_value)
public function integer set_object_key ()
public function str_complete_context context ()
public function str_property_value get_property (string ps_edas_address)
public function string get_property_value (string ps_edas_address)
public function long order_service (string ps_cpr_id, long pl_encounter_id, string ps_ordered_for, integer pi_step_number, integer pi_priority, string ps_description, str_attributes pstr_attributes)
public function str_property_value edas_property (string ps_edas_address)
public function string edas_property_value (string ps_edas_address)
public function long new_attachment (string ps_context_object, long pl_object_key, string ps_progress_type, string ps_progress_key, str_external_observation_attachment pstr_attachment, string ps_folder)
public function long new_attachment (string ps_context_object, long pl_object_key, string ps_progress_type, string ps_progress_key, string ps_filepath, string ps_description, string ps_folder)
public function long new_attachment (string ps_progress_type, string ps_progress_key, string ps_filepath, string ps_description, string ps_folder)
end prototypes

public function integer set_progress (string ps_progress_type);datetime ldt_null

setnull(ldt_null)

if isnull(patient_workplan_item_id) then
	mylog.log(this, "u_component_workplan_item.set_progress:0006", "Null patient_workplan_item_id", 4)
	return -1
end if

sqlca.sp_set_workplan_item_progress(patient_workplan_item_id, &
												current_user.user_id, &
												ps_progress_type, &
												ldt_null, &
												current_scribe.user_id, &
												gnv_app.computer_id)

RETURN 1


end function

private function str_attributes get_workplan_item_attributes ();u_ds_data luo_data
integer li_count
str_attributes lstr_attributes

luo_data = CREATE u_ds_data

luo_data.set_dataobject("dw_patient_workplan_item_attributes_data", cprdb)
li_count = luo_data.retrieve(patient_workplan_item_id)

f_attribute_ds_to_str(luo_data, lstr_attributes)

DESTROY luo_data

return lstr_attributes



end function

public function integer save_wp_item_attributes ();u_ds_data luo_data
integer li_sts
str_attributes lstr_attributes
long i
string ls_attribute
string ls_value
string ls_cpr_id
long ll_patient_workplan_id

setnull(ls_cpr_id)
setnull(ll_patient_workplan_id)

// First get the attributes in the database
luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_p_Patient_WP_Item_Attribute", cprdb)

li_sts = luo_data.retrieve(patient_workplan_item_id)
if li_sts < 0 then
	DESTROY luo_data
	return -1
end if

// Then find any attributes in memory that aren't in the database and add them
lstr_attributes = get_attributes()

for i = 1 to lstr_attributes.attribute_count
	// first see if it's in the database
	ls_attribute = lstr_attributes.attribute[i].attribute
	ls_value = luo_data.get_attribute(ls_attribute)
	if isnull(ls_value) then
		// If we didn't find the attribute then add it
		ls_value = lstr_attributes.attribute[i].value
		sqlca.sp_add_workplan_item_attribute( &
				ls_cpr_id, &
				ll_patient_workplan_id, &
				patient_workplan_item_id, &
				ls_attribute, &
				ls_value, &
				current_scribe.user_id, &
				current_user.user_id)
		if not tf_check() then return -1
	else
		// If we found the attribute, make sure it's the same
		if not (ls_value = lstr_attributes.attribute[i].value) then
			// if it's not the same then add it
			ls_value = lstr_attributes.attribute[i].value
			sqlca.sp_add_workplan_item_attribute( &
					ls_cpr_id, &
					ll_patient_workplan_id, &
					patient_workplan_item_id, &
					ls_attribute, &
					ls_value, &
					current_scribe.user_id, &
					current_user.user_id)
			if not tf_check() then return -1
		end if
	end if
next

DESTROY luo_data

if li_sts < 0 then return -1

return 1

end function

public subroutine reset_service (string ps_service);service = ps_service

description = datalist.service(service, "description")
button = datalist.service(service, "button")
icon = datalist.service(service, "icon")
close_flag = datalist.service(service, "close_flag")
signature_flag = datalist.service(service, "signature_flag")
owner_flag = datalist.service(service, "owner_flag")
encounter_flag = datalist.service(service, "encounter_flag")
patient_flag = datalist.service(service, "patient_flag")
general_flag = datalist.service(service, "general_flag")
treatment_flag = datalist.service(service, "treatment_flag")
visible_flag = datalist.service(service, "visible_flag")
id = datalist.service(service, "id")

setnull(cpr_id)
setnull(encounter_id)
setnull(attachment_id)
setnull(problem_id)
setnull(patient_workplan_id)
setnull(patient_workplan_item_id)
setnull(workplan_id)
setnull(item_number)
setnull(step_number)
setnull(item_type)
setnull(in_office_flag)
setnull(workplan_type)
setnull(treatment_id)
setnull(context_object)

end subroutine

public function integer add_workplan_item_attributes (str_attributes pstr_attributes);long i
integer li_sts
string ls_cpr_id
long ll_patient_workplan_id

setnull(ls_cpr_id)
setnull(ll_patient_workplan_id)

add_attributes(pstr_attributes)

for i = 1 to pstr_attributes.attribute_count
	cprdb.sp_add_workplan_item_attribute( &
			ls_cpr_id, &
			ll_patient_workplan_id, &
			patient_workplan_item_id, &
			pstr_attributes.attribute[i].attribute, &
			pstr_attributes.attribute[i].value, &
			current_scribe.user_id, &
			current_user.user_id)
	if not cprdb.check() then return -1
next

li_sts = get_service_properties()
If li_sts <= 0 Then Return -1

return 1

end function

public function integer add_workplan_item_attribute (string ps_attribute, string ps_value);str_attributes lstr_attributes

lstr_attributes.attribute_count = 1
lstr_attributes.attribute[1].attribute = ps_attribute
lstr_attributes.attribute[1].value = ps_value

return add_workplan_item_attributes(lstr_attributes)

end function

private function str_attributes get_service_attributes ();long i
long ll_count
u_ds_data luo_data
str_attributes lstr_attributes

luo_data = CREATE u_ds_data

luo_data.set_dataobject("dw_sp_get_service_attributes", cprdb)
ll_count = luo_data.retrieve(service, current_user.user_id)

f_attribute_ds_to_str(luo_data, lstr_attributes)

DESTROY luo_data

return lstr_attributes

end function

public function integer doing_service ();///////////////////////////////////////////////////////////////////////////////////
//
//	Function: doing_service
//
// Arguments: 
//
//	RETURN: Integer
//
//	Description: When the current user clicked on particular service
//              record the status into o_users to let others know
//              some one is working on this service.
//
// Created On:																Created On:
//
// Modified By:Sumathi Chinnasamy									Modified On:08/25/99
//////////////////////////////////////////////////////////////////////////////////
string		ls_user_full_name
u_user luo_user
str_popup_return popup_return
integer li_sts
string ls_locked_by_user_id
long ll_locked_by_computer_id
string ls_other_computer
string ls_message
boolean lb_already_locked
string ls_attending_doctor
string ls_encounter_status
boolean lb_is_owner

// See if the service is already locked
// start a transaction to hold locks
tf_begin_transaction(this, "doing_service()")

// see if there's a record already for this service
SELECT user_id, computer_id
INTO :ls_locked_by_user_id, :ll_locked_by_computer_id
FROM o_User_Service_Lock (UPDLOCK)
WHERE patient_workplan_item_id = :patient_workplan_item_id;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then
	// There wasn't a lock record so create one
	INSERT INTO o_User_Service_Lock (
		patient_workplan_item_id,
		user_id,
		computer_id)
	VALUES (
		:patient_workplan_item_id,
		:current_scribe.user_id,
		:gnv_app.computer_id );
	if not tf_check() then return -1
	lb_already_locked = false
elseif ls_locked_by_user_id = current_scribe.user_id and ll_locked_by_computer_id = gnv_app.computer_id then
	// If the same user/computer already holds the lock then we're OK
	lb_already_locked = false
else
	lb_already_locked = true
end if

tf_commit_transaction()

if lb_already_locked then
	// Someone else is already performing this service
	ls_other_computer = f_computer_description(ll_locked_by_computer_id)
	ls_message = "This service is already being performed by "
	ls_message += user_list.user_full_name(ls_locked_by_user_id)
	ls_message += " at " + ls_other_computer
	if gnv_app.cpr_mode = "CLIENT" then
		openwithparm(w_pop_message, ls_message)
	else
		log.log(this, "u_component_workplan_item.doing_service:0070", ls_message, 4)
	end if
	return 0
end if

// Perform some checks if we're in client mode
if gnv_app.cpr_mode = "CLIENT" then
	// If this service is ordered for someone else, then warn the user
	if user_list.is_user(owned_by) then
		If upper(owned_by) <> upper(current_user.user_id) Then
			Openwithparm(w_pop_yes_no, "Do you wish to take ownership of this service from " + &
													user_list.user_full_name(owned_by))
			popup_return = Message.Powerobjectparm
			If popup_return.item = "NO" Then
				not_doing_service()
				return 0
			End If
		end if
	ElseIf user_list.is_role(owned_by) then
		// If the service is owned by a role, check to see of the current user is in that role
		if not user_list.is_user_role(current_user.user_id, owned_by) then
			ls_message = "This service was ordered for the '" + &
							user_list.role_name(owned_by) + "' role.  " + &
							"Do you wish to take ownership of this service?"
			Openwithparm(w_pop_yes_no, ls_message)
			popup_return = Message.Powerobjectparm
			If popup_return.item = "NO" Then
				not_doing_service()
				return 0
			end if
		End If
	End If
	
	
	// If the owner flag is set then make sure the user owns the encounter
	if owner_flag = "Y" and not isnull(encounter_id) then
		ls_message = "In order to perform this service you will need to take over the appointment."
		lb_is_owner = false
		// Find the provider for this encounter
		ls_attending_doctor = current_patient.encounters.attending_doctor(encounter_id)
		ls_encounter_status = upper(current_patient.encounters.encounter_status(encounter_id))
		luo_user = user_list.find_user(ls_attending_doctor)
		if isnull(luo_user) then
			// If there isn't an attending doctor yet, then automatically take over the encounter
			current_patient.encounters.modify_encounter(encounter_id, "attending_doctor", current_user.user_id)
			lb_is_owner = true
		elseif upper(current_user.user_id) = upper(luo_user.user_id) then
			// If we're already the owner then OK
			lb_is_owner = true
		elseif user_list.is_role(luo_user.user_id) then
			// If the attending doctor is a role, then see if the current user is in that role
			if user_list.is_user_role(current_user.user_id, luo_user.user_id) then
				// If the user is in the role, then automatically take over the encounter
				current_patient.encounters.modify_encounter(encounter_id, "attending_doctor", current_user.user_id)
				lb_is_owner = true
			else
				ls_message += "  This appointment is supposed to be owned by someone in the '"
				ls_message += user_list.role_description(luo_user.user_id) + "' role."
			end if
		else
			ls_message += "  This appointment is already owned by "
			ls_message += luo_user.user_full_name + "."
		end if
	
		if not lb_is_owner then
			// See if this user may take over an encounter aleady owned by luo_user
			if user_list.user_may_take_over_encounter(current_user.user_id, luo_user.user_id) then
				// Otherwise, prompt the user before taking over the encounter
				ls_message += "  Are you sure you wish to take over this appointment?"
				openwithparm(w_pop_yes_no, ls_message)
				popup_return = message.powerobjectparm
				if popup_return.item = "YES" then
					current_patient.encounters.modify_encounter(encounter_id, "attending_doctor", current_user.user_id)
				else
					not_doing_service()
					return 0
				end if
			else
				ls_message += "  You are not authorized to take over this appointment."
				openwithparm(w_pop_message, ls_message)
				not_doing_service()
				return 0
			end if
		end if
	end if
end if // End of client mode checks


// Now, save the attributes and start the workplan item
li_sts = save_wp_item_attributes()
if li_sts < 0 then
	not_doing_service()
	return -1
end if

// Refresh the workplan item properties since things might have changed now
li_sts = get_service_properties()
If li_sts <= 0 Then
	not_doing_service()
	return -1
end if

// If the w_main window is valid, then tell it we're in a service so it won't
// keep refreshing itself
IF IsValid(main_window) THEN main_window.doing_service()

doing_service = true

RETURN 1


end function

public subroutine set_service_buttons (ref commandbutton cb_finished, ref commandbutton cb_beback, ref commandbutton cb_dolater);
if isnull(end_date) then
	if in_office_flag = "Y" then
		if step_flag = "N" and cancel_workplan_flag = "N" then
			cb_dolater.visible = true
		else
			cb_dolater.visible = false
		end if
	else
		cb_dolater.visible = false
	end if
	
	if manual_service then
		cb_beback.visible = false
	else
		cb_beback.visible = true
	end if
else
	cb_beback.visible = false
	cb_dolater.visible = false
end if


end subroutine

public function long order_service (string ps_cpr_id, long pl_encounter_id, string ps_ordered_for);long ll_attribute_count
string lsa_attributes[]
string lsa_values[]

ll_attribute_count = 0

return order_service(ps_cpr_id, pl_encounter_id, ps_ordered_for, ll_attribute_count, lsa_attributes, lsa_values)

end function

public function long order_service (string ps_cpr_id, long pl_encounter_id, string ps_ordered_for, long pl_attribute_count, string psa_attributes[], string psa_values[]);str_attributes lstr_attributes
long i

lstr_attributes.attribute_count = pl_attribute_count
for i = 1 to pl_attribute_count
	lstr_attributes.attribute[i].attribute = psa_attributes[i]
	lstr_attributes.attribute[i].value = psa_values[i]
next

return order_service(ps_cpr_id, pl_encounter_id, ps_ordered_for, lstr_attributes)

end function

public function long order_service (string ps_cpr_id, long pl_encounter_id, string ps_ordered_for, string ps_description);integer li_step_number
str_attributes lstr_attributes

setnull(li_step_number)
lstr_attributes.attribute_count = 0

return order_service(ps_cpr_id, pl_encounter_id, ps_ordered_for, li_step_number, ps_description, lstr_attributes)

end function

public function long order_service (string ps_ordered_for);long ll_attribute_count
string lsa_attributes[]
string lsa_values[]
string ls_cpr_id
long ll_encounter_id

setnull(ls_cpr_id)
setnull(ll_encounter_id)

ll_attribute_count = 0

return order_service(ls_cpr_id, ll_encounter_id, ps_ordered_for, ll_attribute_count, lsa_attributes, lsa_values)

end function

public function long order_service (string ps_cpr_id, long pl_encounter_id, string ps_ordered_for, str_attributes pstr_attributes);integer li_step_number
string ls_description
long ll_patient_workplan_item_id

setnull(li_step_number)
setnull(ls_description)

ll_patient_workplan_item_id = order_service(ps_cpr_id, pl_encounter_id, ps_ordered_for, li_step_number, ls_description, pstr_attributes)

return ll_patient_workplan_item_id

end function

public function long get_root_observation ();string ls_root_observation_id
long ll_root_observation_sequence
string ls_service
long ll_null
string ls_parent_observation_id
integer li_sts
long ll_parent_observation_sequence
string ls_null

setnull(ls_null)
setnull(ll_null)
setnull(ll_root_observation_sequence)

get_attribute("observation_sequence", ll_root_observation_sequence)
get_attribute("observation_id", ls_root_observation_id)

// If there is an observation_sequence specified in the attributes, then that's our root
if not isnull(treatment) and not isnull(ll_root_observation_sequence) then
	// If an observation_sequence is specified in the attributes, then make sure it exists.
	ls_root_observation_id = treatment.get_observation_id(ll_root_observation_sequence)
	if isnull(ls_root_observation_id) then
		log.log(this, "u_component_workplan_item.get_root_observation:0022", "An observation_sequence was specified but can't be found (" + string(ll_root_observation_sequence) + ")", 4)
		return ll_null
	end if
	
	// If we found the specified observation_sequence, and either the caller didn't specify an
	// observation_id or they did and it matches the record specified by observation_sequence,
	// then use the passed in observation_sequence
	if isnull(ls_root_observation_id) or ls_root_observation_id = ls_root_observation_id then
		return ll_root_observation_sequence
	end if
end if

// If an observation_id was not specified by the caller, then figure out what it should be
if isnull(ls_root_observation_id) then
	li_sts = get_root_observation_ids(ls_parent_observation_id, ls_root_observation_id)
else
	setnull(ls_parent_observation_id)
	li_sts = 1
end if
if isnull(ls_root_observation_id) or li_sts <= 0 then
	log.log(this, "u_component_workplan_item.get_root_observation:0042", "Unable to determine root observation_id", 4)
	return ll_null
end if

// Find/Generate an observation sequence, but first copy the service to a local variable
// because we don't want our instance variable changed under any circumstances
if isnull(treatment) then
	// If we don't have a treatment object, then this must be a patient observation.
	ll_root_observation_sequence = current_patient.add_observation(ls_root_observation_id)
else
	// If we have a treatment object then get/add the root through the treatment context
	if not isnull(ls_parent_observation_id) then
		setnull(ls_service)
		ll_parent_observation_sequence = treatment.add_root_observation(ls_parent_observation_id, ls_null, ls_service)
		ll_root_observation_sequence = treatment.add_observation( ll_parent_observation_sequence, &
																					ls_root_observation_id, &
																					1, &
																					observation_tag, &
																					true)
	else
		ls_service = service
		ll_root_observation_sequence = treatment.add_root_observation(ls_root_observation_id, observation_tag, ls_service)
	end if
end if

return ll_root_observation_sequence

end function

public function integer not_doing_service ();///////////////////////////////////////////////////////////////////////////////////
//
//	Function: not_doing_service
//
// Arguments: 
//
//	RETURN: Integer
//
//	Description: When the current user finishes a service, the lock on the service
//					 needs to be released.
//
// Created On:																Created On:
//
// Modified By:Sumathi Chinnasamy									Modified On:08/25/99
//////////////////////////////////////////////////////////////////////////////////
integer		li_count
integer li_sts

DELETE FROM o_User_Service_Lock
WHERE patient_workplan_item_id = :patient_workplan_item_id
USING cprdb;
if not cprdb.check() then return -1


IF IsValid(main_window) THEN main_window.not_doing_service()

// Save the attributes again in case any were added by the descendent class
li_sts = save_wp_item_attributes()
if li_sts < 0 then return -1

doing_service = false

RETURN 1

end function

public function boolean is_encounter_open ();string ls_encounter_status

if isnull(encounter_id) or isnull(current_patient) then return false

ls_encounter_status = current_patient.encounters.encounter_status(encounter_id)
if upper(ls_encounter_status) = "OPEN" then return true

return false

end function

public function long order_service (string ps_cpr_id, long pl_encounter_id, string ps_ordered_for, integer pi_step_number, string ps_description, str_attributes pstr_attributes);integer li_priority

setnull(li_priority)

return order_service(ps_cpr_id, &
							pl_encounter_id, &
							ps_ordered_for, &
							pi_step_number, &
							li_priority, &
							ps_description, &
							pstr_attributes)




end function

public function string root_observation_id ();string ls_parent_observation_id
string ls_child_observation_id
string ls_null
integer li_sts

setnull(ls_null)

li_sts = get_root_observation_ids(ls_parent_observation_id, ls_child_observation_id)
if li_sts <= 0 then return ls_null

return ls_child_observation_id

end function

public subroutine do_service_error ();string ls_manual_service_flag

if manual_service then
	ls_manual_service_flag = "Y"
else
	ls_manual_service_flag = "N"
end if

sqlca.jmj_set_service_error(patient_workplan_item_id, &
									current_user.user_id, &
									current_scribe.user_id, &
									ls_manual_service_flag, &
									gnv_app.computer_id)



end subroutine

public subroutine display_properties ();w_service_properties lw_window

openwithparm(lw_window, this, "w_service_properties", f_active_window())


end subroutine

public function integer initialize (long pl_patient_workplan_item_id);/////////////////////////////////////////////////////////////////////////////////////////////////
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
long ll_last_display_encounter_id
string ls_status
string ls_next_room_id
string ls_wp_cpr_id
long ll_wp_encounter_id
integer li_sts2
String	ls_progress_type
datetime ldt_progress_date_time
long ll_temp
long ll_treatment_id
long ll_problem_id
long ll_attachment_id

setnull(ldt_progress_date_time)
setnull(document_id)

patient_workplan_item_id = pl_patient_workplan_item_id

add_attribute("patient_workplan_item_id", string(pl_patient_workplan_item_id))

if lower(this.classname()) = "u_component_wp_item_document" then
	document_id = patient_workplan_item_id
	if not isnull(current_service) then
		current_service.document_id = patient_workplan_item_id
	end if
end if

if isnull(cprdb) or not isvalid(cprdb) then cprdb = sqlca
if isnull(mylog) or not isvalid(mylog) then mylog = log

li_sts = get_service_properties()
If li_sts <= 0 Then
	Return -1
end if


// Now get some information about the workplan
SELECT workplan_type,
		 cpr_id,
		 encounter_id,
		 treatment_id,
		 problem_id,
		 attachment_id,
		 observation_sequence
INTO   :workplan_type,
		 :ls_wp_cpr_id,
		 :ll_wp_encounter_id,
		 :ll_treatment_id,
		 :ll_problem_id,
		 :ll_attachment_id,
		 :observation_sequence
FROM p_Patient_WP
WHERE patient_workplan_id = :patient_workplan_id
USING cprdb;
If not cprdb.check() Then
	Return -1
end if

// First, did we find a workplan
If cprdb.sqlcode = 100 Then
	mylog.log(this, "u_component_workplan_item.initialize:0074", "Workplan record not found (" + &
							string(patient_workplan_id) + ")", 4)
	Return -1
End If

// If the cpr_id is null then use the parent workplan's cpr_id
if isnull(cpr_id) then cpr_id = ls_wp_cpr_id

// Get the permanent attributes associated with this service
lstr_attributes = get_service_attributes()
add_attributes(lstr_attributes)

// Get the attributes associated with this workplan item
lstr_attributes = get_workplan_item_attributes()
add_attributes(lstr_attributes)

// See if any values from the patient workplan need to be overridden by specified attributes
get_attribute("encounter_id", ll_temp)
if isnull(ll_temp) then
	if not isnull(encounter_id) then add_attribute("encounter_id", string(encounter_id))
else
	encounter_id = ll_temp
end if

// See if a treatment_id is assigned already
if isnull(treatment_id) then
	get_attribute("treatment_id", ll_temp)
	if isnull(ll_temp) then
		// If no treatment_id is assigned, see if we have a treatment object
		if isnull(treatment) then
			// If there's a treatment object, then use it
			treatment_id = ll_treatment_id
		else
			// If there was no treatment object, but the workplan had a treatment_id
			// then use the workplan treatment_id
			treatment_id = treatment.treatment_id
		end if
		// Record the treatment_id used
		if not isnull(treatment_id) then add_attribute("treatment_id", string(treatment_id))
	else
		treatment_id = ll_temp
	end if
end if

// See if a problem_id is assigned already
if isnull(problem_id) then
	get_attribute("problem_id", ll_temp)
	if isnull(ll_temp) then
		// If no problem_id is assigned yet, then use the problem_id from the workplan
		problem_id = ll_problem_id
		// Log the problem_id used
		if not isnull(problem_id) then add_attribute("problem_id", string(problem_id))
	else
		problem_id = ll_temp
	end if
end if

// See if a attachment_id is assigned already
if isnull(attachment_id) then
	get_attribute("attachment_id", ll_temp)
	if isnull(ll_temp) then
		// If no attachment_id is assigned yet, then use the attachment_id from the workplan
		attachment_id = ll_attachment_id
		// Log the attachment_id used
		if not isnull(attachment_id) then add_attribute("attachment_id", string(attachment_id))
	else
		attachment_id = ll_temp
	end if
end if

get_attribute("observation_sequence", ll_temp)
if isnull(ll_temp) then
	if not isnull(observation_sequence) then add_attribute("observation_sequence", string(observation_sequence))
else
	observation_sequence = ll_temp
end if

// If the service encounter_id is still null then use the workplan encounter_id
if isnull(encounter_id) then encounter_id = ll_wp_encounter_id


// Set the context_object and check for consistency
context_object = get_attribute("context_object")
if isnull(context_object) then
	// If no specific context_object was specified, then assume one based on the keys provided
	if not isnull(attachment_id) then
		context_object = "attachment"
	elseif not isnull(observation_sequence) then
		context_object = "observation"
	elseif not isnull(treatment_id) then
		context_object = "treatment"
	elseif not isnull(problem_id) then
		context_object = "assessment"
	elseif not isnull(encounter_id) then
		context_object = "encounter"
	elseif not isnull(cpr_id) then
		context_object = "patient"
	else
		context_object = "general"
	end if
end if

// If we don't have a cpr_id by this point and we're not in a "general" context,
// then attempt to inherit the context from the previous service, if it exists
if isnull(cpr_id) and lower(context_object) <> "general" and inherited_patient then
	cpr_id = last_service.cpr_id
end if

li_sts = set_object_key()
if li_sts < 0 then return -1

context_object_type = sqlca.fn_context_object_type(context_object, cpr_id, object_key)
context_description = sqlca.fn_patient_object_description(cpr_id, context_object, object_key)

// Set the owner flag
if (upper(owner_flag) = "Y") or f_string_to_boolean(get_attribute("owner_flag")) then
	owner_flag = "Y"
end if

Return 1

end function

public function integer get_service_properties ();
if isnull(patient_workplan_item_id) then
	mylog.log(this, "u_component_workplan_item.get_service_properties:0003", "Null patient_workplan_item_id", 4)
	return -1
end if

SELECT cpr_id,
		 encounter_id,
		 patient_workplan_id,
		 workplan_id,
		 item_number,
		 step_number,
		 item_type,
		 COALESCE(in_office_flag, 'N'),
		 ordered_service,
		 COALESCE(runtime_configured_flag, 'N'),
		 observation_tag,
		 ordered_by,
		 ordered_for,
		 owned_by,
		 folder,
		 dispatch_method,
		 dispatch_date,
		 begin_date,
		 end_date,
		 escalation_date,
		 expiration_date,
		 COALESCE(owner_flag, 'N'),
		 COALESCE(step_flag, 'N'),
		 COALESCE(cancel_workplan_flag, 'N'),
		 retries,
		 description,
		 status,
		 completed_by,
		 created,
		 created_by,
		 auto_perform_flag,
		 consolidate_flag,
		 priority,
		 CAST(id AS varchar(40)),
		 treatment_id,
		 problem_id,
		 attachment_id
INTO   :cpr_id,
		 :encounter_id,
		 :patient_workplan_id,
		 :workplan_id,
		 :item_number,
		 :step_number,
		 :item_type,
		 :in_office_flag,
		 :service,
		 :runtime_configured_flag,
		 :observation_tag,
		 :ordered_by,
		 :ordered_for,
		 :owned_by,
		 :folder,
		 :dispatch_method,
		 :dispatch_date,
		 :begin_date,
		 :end_date,
		 :escalation_date,
		 :expiration_date,
		 :owner_flag,
		 :step_flag,
		 :cancel_workplan_flag,
		 :retries,
		 :description,
		 :status,
		 :completed_by,
		 :created,
		 :created_by,
		 :auto_perform_flag,
		 :consolidate_flag,
		 :priority,
		 :id,
		 :treatment_id,
		 :problem_id,
		 :attachment_id
FROM p_Patient_WP_Item
WHERE patient_workplan_item_id = :patient_workplan_item_id
USING cprdb;
If not cprdb.check() Then Return -1

// Check to make sure everything looks right
// First, did we find a workplan item
if cprdb.sqlcode = 100 then
	mylog.log(this, "u_component_workplan_item.get_service_properties:0089", "Workplan Item Record not found (" + string(patient_workplan_item_id) + ")", 4)
	return -1
end if

//// Next, is the item a service
//If lower(item_type) <> "service" or isnull(item_type) Then
//	mylog.log(this, "u_component_workplan_item.get_service_properties:0095", "Workplan item not a service (" + &
//							string(patient_workplan_item_id) + ")", 4)
//	Return -1
//End If
//
//// Next, do we have a service identifer
//If isnull(service) Then
//	mylog.log(this, "u_component_workplan_item.get_service_properties:0102", "Null ordered_service (" +&
//							string(patient_workplan_item_id) + ")", 4)
//	Return -1
//End If

return 1

end function

private function integer get_root_observation_ids (ref string ps_parent_observation_id, ref string ps_child_observation_id);string ls_observation_id
string ls_null
str_observation_tree_branch lstr_branch
long ll_observation_sequence
str_popup popup
w_window_base lw_pick
str_picked_observations lstr_observations

setnull(ls_null)
setnull(ps_parent_observation_id)
setnull(ps_child_observation_id)

get_attribute("observation_id", ls_observation_id)
get_attribute("observation_sequence", ll_observation_sequence)

// If there is an observation_id specified in the attributes, then that's our root
if not isnull(ls_observation_id) then
	ps_child_observation_id = ls_observation_id
	return 1
end if

// If we have a treatment object, then check to see if an observation_sequence
// is specified in the attributes.  If so, then that's our root
if not isnull(treatment) then
	if not isnull(ll_observation_sequence) then
		ls_observation_id = treatment.get_observation_id(ll_observation_sequence)
		if not isnull(ls_observation_id) then
			ps_child_observation_id = ls_observation_id
			return 1
		end if
	end if
end if

// If an observation_id wasn't specified, then we can't have a root observation unless we have a treatment...
if isnull(treatment) then return 0

// If no specific root was specified in the attributes, then we need to look at the treatment
// object, but we can't do that unless the treatment has an observation_id
if isnull(treatment.observation_id) then
	// If the treatment has no observation_id and we're in CLIENT mode, then let the user
	// pick an observation
	if gnv_app.cpr_mode = "CLIENT" then		
		popup.data_row_count = 2
		popup.title = "Select Observation for '" + treatment.treatment_description + "'"
		popup.multiselect = false
		popup.items[1] = treatment.treatment_type
		popup.items[2] = current_user.specialty_id
		openwithparm(lw_pick, popup, "w_pick_observations", f_active_window())
		lstr_observations = message.powerobjectparm
		if lstr_observations.observation_count = 1 then
			treatment.observation_id = lstr_observations.observation_id[1]
		end if
	end if
	
	// If we still don't have an observation_id then return null
	if isnull(treatment.observation_id) then
		log.log(this, "u_component_workplan_item.get_root_observation_ids:0057", "No treatment-root observation found", 4)
		return 0
	else
		treatment.set_progress_key('Modify', 'observation_id', treatment.observation_id)
	end if
end if

// Now, if we don't have an observation_tag, then the treatment observation is our root
if isnull(observation_tag) then
	ps_child_observation_id = treatment.observation_id
	return 1
end if

// Finally, since we have a treatment observation and a tag, then find the tagged child of the
// treatment observation.
lstr_branch = datalist.observation_tagged_child(treatment.observation_id, observation_tag)

// If we have a tag but no tagged child, then we have no root
if isnull(lstr_branch.child_observation_id) then return 0

// If we found a tagged child, then that's our root
ps_parent_observation_id = lstr_branch.parent_observation_id
ps_child_observation_id = lstr_branch.child_observation_id
return 1





end function

public subroutine restore_service_state (integer pi_sts);integer li_sts

// If we created the treatment object then destroy it
if my_treatment then
	component_manager.destroy_component(treatment)
	setnull(treatment)
end if

// If we created the patient then destroy it
if my_patient and not inherited_patient then f_clear_patient()

current_service = last_service
if isnull(current_service) then
	if isvalid(main_window) and not isnull(main_window) then
		main_window.visible = true
	end if
else
	// If the previous service has a window and the window was enabled prior to this service,
	// then make sure it's still enabled.
	if not isnull(current_service) and isvalid(current_service) and current_service.service_window_enabled then
		if not isnull(current_service.service_window) and isvalid(current_service.service_window) then
			current_service.service_window.enable_window()
			current_service.service_window.show()
		end if
	end if
	
	// Set the display encounter back
	if isnull(last_display_encounter_id) then
		f_clear_current_encounter()
	elseif last_display_encounter_id > 0 and (isnull(encounter_id) or last_display_encounter_id <> encounter_id) then
		li_sts = f_set_current_encounter(last_display_encounter_id)
	end if
end if

if pi_sts < 0 then
	do_service_error()
end if


end subroutine

public subroutine save_service_state ();unsignedlong ll_whandle

// Save the previous service object
if not isvalid(current_service) then setnull(current_service)
last_service = current_service
if isnull(last_service) then
	inherited_patient = false
else
	if isnull(last_service.cpr_id) then
		inherited_patient = false
	else
		inherited_patient = true
	end if
	
	// See if the previous service has a window.  If so then see if it has the focus
	last_service.service_window_enabled = false
	if not isnull(last_service) and isvalid(last_service) then
		if not isnull(last_service.service_window) and isvalid(last_service.service_window) then
			if last_service.service_window.visible then
				ll_whandle = handle(last_service.service_window)
				if IsWindowEnabled(ll_whandle) then last_service.service_window_enabled = true
			end if
		end if
	end if
end if

// Save the previous display_encounter_id
last_display_encounter_id = f_current_display_encounter_id()



end subroutine

public function string get_all_messages ();string ls_all_messages
string ls_message
string ls_user_tag
datetime ldt_created
string ls_created_by
long i
u_ds_data luo_data
long ll_count

luo_data = CREATE u_ds_data

ls_all_messages = ""
luo_data.set_dataobject("dw_p_patient_wp_item_attribute")
luo_data.setfilter("attribute='message'")
ll_count = luo_data.retrieve(patient_workplan_item_id)
for i = 1 to ll_count
	ls_message = luo_data.object.value[i]
	if len(ls_message) > 0 then
		ldt_created = luo_data.object.created[i]
		ls_created_by = luo_data.object.created_by[i]
		ls_user_tag = user_list.user_full_name(ls_created_by)
		if isnull(ls_user_tag) or trim(ls_user_tag) = "" then
			ls_user_tag = "<Unknown>"
		end if
		ls_user_tag = string(ldt_created, "[shortdate] [shorttime]") + " " + ls_user_tag
		
		ls_message = "<<" + ls_user_tag + " Wrote:>>~r~n" + ls_message
		if len(ls_all_messages) > 0 then
			ls_message += "~r~n~r~n"
		end if
		ls_all_messages = ls_message + ls_all_messages
	end if
next

DESTROY luo_data

return ls_all_messages


end function

public function integer forward_workplan_item (string ps_to_user_id, string ps_new_description, string ps_new_message);string ls_null

setnull(ls_null)

// Forward the todo service to the specified user with the new message attached
sqlca.jmj_forward_task( &
		patient_workplan_item_id, &
		ps_to_user_id, &
		ps_new_description, &
		ps_new_message, &
		current_scribe.user_id, &
		current_user.user_id)
if not tf_check() then Return -1

// The stored procedure will have updated the "message_subject", "task_message" and "forwarded_to_user_id" attributes, so update them
// in the local cache so they don't get updated again when the service completes
if len(ps_new_description) > 0 then
	add_attribute("message_subject", ps_new_description)
end if
if len(ps_new_message) > 0 then
	add_attribute("task_message", ps_new_message)
end if
if len(ps_to_user_id) > 0 then
	add_attribute("forwarded_to_user_id", ps_to_user_id)
end if

// If there is a disposition, then clear it out
if len(get_attribute( "disposition")) > 0 then
	add_attribute("disposition", ls_null)
	sqlca.sp_add_workplan_item_attribute(cpr_id, patient_workplan_id, patient_workplan_item_id, "disposition", ls_null, current_scribe.user_id, current_user.user_id)
	if not tf_check() then return -1
end if

return 1

end function

public function integer show_dashboard ();return show_dashboard(context_object, object_key)

end function

public function integer show_dashboard (string ps_context_object, long pl_object_key);str_attributes lstr_attributes

lstr_attributes = get_attributes()

return f_context_object_dashboard(cpr_id, ps_context_object, pl_object_key, lstr_attributes)

end function

public subroutine set_attribute (string ps_attribute, string ps_value);string ls_cpr_id
long ll_patient_workplan_id
string ls_current_value

setnull(ls_cpr_id)
setnull(ll_patient_workplan_id)

// See if the value has changed
get_attribute(ps_attribute, ls_current_value)
if not f_string_modified(ls_current_value, ps_value) then return

// First add the attribute to the local store
add_attribute(ps_attribute, ps_value)

// Then save the attribute to the database
sqlca.sp_add_workplan_item_attribute( &
		ls_cpr_id, &
		ll_patient_workplan_id, &
		patient_workplan_item_id, &
		ps_attribute, &
		ps_value, &
		current_scribe.user_id, &
		current_user.user_id)
if not tf_check() then return

// Reload the properties
get_service_properties()

set_object_key()

end subroutine

public function integer set_object_key ();long ll_object_key

// Update object_key if needed
CHOOSE CASE lower(context_object)
	CASE "general"
		setnull(object_key)
	CASE "patient"
		if isnull(cpr_id) then
			log.log(this, "u_component_workplan_item.set_object_key:0009", "patient context but no cpr_id", 4)
			return -1
		end if
		setnull(object_key)
	CASE "encounter"
		if isnull(cpr_id) then
			log.log(this, "u_component_workplan_item.set_object_key:0015", "appointment context but no cpr_id", 4)
			return -1
		end if
		if isnull(encounter_id) then
			get_attribute("object_key", ll_object_key)
			if isnull(ll_object_key) then
				log.log(this, "u_component_workplan_item.set_object_key:0021", "appointment context but no encounter_id", 4)
				return -1
			else
				encounter_id = ll_object_key
			end if
		end if
		object_key = encounter_id
	CASE "assessment"
		if isnull(cpr_id) then
			log.log(this, "u_component_workplan_item.set_object_key:0030", "assessment context but no cpr_id", 4)
			return -1
		end if
		if isnull(problem_id) then
			get_attribute("object_key", ll_object_key)
			if isnull(ll_object_key) then
				log.log(this, "u_component_workplan_item.set_object_key:0036", "assessment context but no problem_id", 4)
				return -1
			else
				problem_id = ll_object_key
			end if
		end if
		object_key = problem_id
	CASE "treatment"
		if isnull(cpr_id) then
			log.log(this, "u_component_workplan_item.set_object_key:0045", "treatment context but no cpr_id", 4)
			return -1
		end if
		if isnull(treatment_id) then
			get_attribute("object_key", ll_object_key)
			if isnull(ll_object_key) then
				log.log(this, "u_component_workplan_item.set_object_key:0051", "treatment context but no treatment object", 4)
				return -1
			else
				treatment_id = ll_object_key
			end if
		end if
		object_key = treatment_id
	CASE "observation"
		if isnull(cpr_id) then
			log.log(this, "u_component_workplan_item.set_object_key:0060", "observation context but no cpr_id", 4)
			return -1
		end if
		if isnull(observation_sequence) then
			get_attribute("object_key", ll_object_key)
			if isnull(ll_object_key) then
				log.log(this, "u_component_workplan_item.set_object_key:0066", "observation context but no observation_sequence", 4)
				return -1
			else
				observation_sequence = ll_object_key
			end if
		end if
		object_key = observation_sequence
	CASE "attachment"
		if isnull(cpr_id) then
			log.log(this, "u_component_workplan_item.set_object_key:0075", "attachment context but no cpr_id", 4)
			return -1
		end if
		if isnull(attachment_id) then
			get_attribute("object_key", ll_object_key)
			if isnull(ll_object_key) then
				log.log(this, "u_component_workplan_item.set_object_key:0081", "attachment context but no attachment_id", 4)
				return -1
			else
				attachment_id = ll_object_key
			end if
		end if
		object_key = attachment_id
END CHOOSE

return 1

end function

public function str_complete_context context ();str_complete_context lstr_context

lstr_context = f_empty_context()

lstr_context.customer_id = sqlca.customer_id
lstr_context.office_id = gnv_app.office_id
lstr_context.user_id = current_user.user_id
lstr_context.scribe_user_id = current_scribe.user_id


lstr_context.cpr_id = cpr_id
lstr_context.context_object = context_object
lstr_context.encounter_id = encounter_id
lstr_context.problem_id = problem_id
lstr_context.treatment_id = treatment_id
lstr_context.observation_sequence = observation_sequence
lstr_context.attachment_id = attachment_id

lstr_context.service_id = patient_workplan_item_id
lstr_context.document_id = document_id

return lstr_context





end function

public function str_property_value get_property (string ps_edas_address);return f_edas_interpret_address(ps_edas_address, context(), get_attributes())

end function

public function string get_property_value (string ps_edas_address);str_property_value lstr_property_value

lstr_property_value = f_edas_interpret_address(ps_edas_address, context(), get_attributes())

return lstr_property_value.value

end function

public function long order_service (string ps_cpr_id, long pl_encounter_id, string ps_ordered_for, integer pi_step_number, integer pi_priority, string ps_description, str_attributes pstr_attributes);Long 		ll_patient_workplan_id
Long		ll_treatment_id
Long		i
String	ls_in_office_flag
string ls_observation_tag
integer li_sts
string ls_owned_by
string ls_auto_perform_flag
string ls_context_object

setnull(ls_owned_by)
setnull(ls_auto_perform_flag)
SetNull(ls_in_office_flag)
SetNull(ls_observation_tag)
SetNull(ll_patient_workplan_id)

if trim(ps_description) = "" then setnull(ps_description)

ls_context_object = f_attribute_find_attribute(pstr_attributes, "context_object")

if isnull(ps_cpr_id) then
	ps_cpr_id = f_attribute_find_attribute(pstr_attributes, "cpr_id")
end if

if isnull(pl_encounter_id) then
	pl_encounter_id = long(f_attribute_find_attribute(pstr_attributes, "encounter_id"))
end if

if lower(ls_context_object) = "treatment" or isnull(ls_context_object) then
	ll_treatment_id = long(f_attribute_find_attribute(pstr_attributes, "treatment_id"))
	if isnull(ll_treatment_id) then
		if not isnull(treatment) then
			ll_treatment_id = treatment.treatment_id
		end if
	elseif not isnull(treatment) then
		if ll_treatment_id <> treatment.treatment_id then
			// Wrong treatment in the treatment object
			setnull(treatment)
		end if
	end if
else
	setnull(treatment)
	setnull(ll_treatment_id)
end if

If isnull(ll_treatment_id) Then
	// If there's a current service, then order this service on the same workplan
	if isnull(current_service) then
		If isnull(ps_cpr_id) Or isnull(pl_encounter_id) Then
			ll_patient_workplan_id = 0
		Else
			// Get the workplan from the encounter
			SELECT p_Patient_Encounter.patient_workplan_id
			INTO :ll_patient_workplan_id
			FROM p_Patient_Encounter
				INNER JOIN p_Patient_WP
				ON p_Patient_Encounter.patient_workplan_id = p_Patient_WP.patient_workplan_id
			WHERE p_Patient_Encounter.cpr_id = :ps_cpr_id
			AND p_Patient_Encounter.encounter_id = :pl_encounter_id
			AND p_Patient_WP.status = 'Current'
			USING cprdb;
			If Not cprdb.check() Then Return -1
		End If
	elseif lower(current_service.context_object) = lower(ls_context_object) then
		ll_patient_workplan_id = current_service.patient_workplan_id
	else
		If isnull(ps_cpr_id) Or isnull(pl_encounter_id) Then
			ll_patient_workplan_id = 0
		Else
			// Get the workplan from the encounter
			SELECT p_Patient_Encounter.patient_workplan_id
			INTO :ll_patient_workplan_id
			FROM p_Patient_Encounter
				INNER JOIN p_Patient_WP
				ON p_Patient_Encounter.patient_workplan_id = p_Patient_WP.patient_workplan_id
			WHERE p_Patient_Encounter.cpr_id = :ps_cpr_id
			AND p_Patient_Encounter.encounter_id = :pl_encounter_id
			AND p_Patient_WP.status = 'Current'
			USING cprdb;
			If Not cprdb.check() Then Return -1
		End If
	end if
Else
	// If this is a treatment service, then first see if the current service is for the same treatment
	if not isnull(current_service) then
		if lower(current_service.context_object) = "treatment" and current_service.treatment_id = ll_treatment_id then
			// If the current service is for the same treatment, then use the same workplan
			ll_patient_workplan_id = current_service.patient_workplan_id
		end if
	end if

	// If the current service was not for the same treatment, then find the first workplan for the desired
	// treatment and use it.
	if isnull(ll_patient_workplan_id) then
		SELECT min(patient_workplan_id)
		INTO :ll_patient_workplan_id
		FROM p_Patient_WP
		WHERE cpr_id = :ps_cpr_id
		AND treatment_id = :ll_treatment_id
		AND workplan_type = 'Treatment'
//		AND status NOT IN('COMPLETED','CANCELLED') // msc 9/20/02 order new service under existing wp even if it's closed
		USING cprdb;
		If Not cprdb.check() Then Return -1
		If cprdb.sqlcode = 100 Then
			mylog.log(this, "u_component_workplan_item.order_service:0105", "Treatment Workplan record not found (" + string(treatment.treatment_id) + ")", 4)
			Return -1
		End if
	end if
End if

ls_in_office_flag = f_attribute_find_attribute(pstr_attributes, "in_office_flag")

if isnull(ls_in_office_flag) then
	if isnull(current_service) Then
		// If we don't have a current service, then decide if we're working with an open encounter
		if isnull(pl_encounter_id) then
			ls_in_office_flag = "N"
		elseif isnull(current_patient) then
			ls_in_office_flag = "N"
		else
			if current_patient.encounters.is_encounter_open(pl_encounter_id) then
				ls_in_office_flag = "Y"
			else
				ls_in_office_flag = "N"
			end if
		end if
	else
		// If we have a current service the copy the in_office_flag from it
		ls_in_office_flag = current_service.in_office_flag
	end if
End If

if isnull(ll_patient_workplan_id) then
	If Isnull(ll_treatment_id) Then
		// If this is not a treatment service, then just use the default workplan
		ll_patient_workplan_id = 0
	else
		// Create a workplan record if it's treatment manual services with no workplans
		sqlca.sp_order_service_workplan( &
				ps_cpr_id, &
				pl_encounter_id, &
				ll_treatment_id, &
				ls_in_office_flag, &
				current_user.user_id, &
				ls_owned_by, &
				current_scribe.user_id, &
				ll_patient_workplan_id)
		If Not tf_check() Then Return -1
	end if
End If

// Order the service
patient_workplan_item_id = cprdb.sp_order_workplan_item(ps_cpr_id, &
																				pl_encounter_id, &
																				ll_patient_workplan_id, &
																				service, &
																				ls_in_office_flag, &
																				ls_auto_perform_flag, &
																				ls_observation_tag, &
																				ps_description, &
																				current_user.user_id, &
																				ps_ordered_for, &
																				pi_step_number, &
																				pi_priority, &
																				current_scribe.user_id)
if not tf_check() then return -1

// Add the attributes
li_sts = add_workplan_item_attributes(pstr_attributes)
if li_sts < 0 then return li_sts

return patient_workplan_item_id


end function

public function str_property_value edas_property (string ps_edas_address);return f_edas_interpret_address(ps_edas_address, context(), get_attributes())


end function

public function string edas_property_value (string ps_edas_address);str_property_value lstr_property_value

lstr_property_value = edas_property(ps_edas_address)

return lstr_property_value.value



end function

public function long new_attachment (string ps_context_object, long pl_object_key, string ps_progress_type, string ps_progress_key, str_external_observation_attachment pstr_attachment, string ps_folder);long ll_attachment_id


// We have the document, now persist it by creating an attachment
ll_attachment_id = f_new_attachment_2(cpr_id, &
												ps_context_object, &
												pl_object_key, &
												ps_progress_type, &
												ps_progress_key, &
												pstr_attachment.extension, &
												pstr_attachment.attachment_type, &
												pstr_attachment.attachment_comment_title, &
												pstr_attachment.filename, &
												pstr_attachment.attachment, &
												ps_folder &
												)
if ll_attachment_id < 0 then
	log.log(this, "u_component_workplan_item.new_attachment:0018", "Error creating new attachment", 4)
	return -1
end if

add_attribute( "attachment_id", string(ll_attachment_id))
attachment_id = ll_attachment_id


return ll_attachment_id

end function

public function long new_attachment (string ps_context_object, long pl_object_key, string ps_progress_type, string ps_progress_key, string ps_filepath, string ps_description, string ps_folder);integer li_sts
str_external_observation_attachment lstr_attachment
str_filepath lstr_filepath

if isnull(ps_filepath) then
	log.log(this, "u_component_workplan_item.new_attachment:0006", "Null filepath", 4)
	return -1
end if

if not fileexists(ps_filepath) then
	log.log(this, "u_component_workplan_item.new_attachment:0011", "File does not exist (" + ps_filepath + ")", 4)
	return -1
end if

li_sts = log.file_read(ps_filepath, lstr_attachment.attachment)
if li_sts <= 0 then return -1

lstr_filepath = f_parse_filepath2(ps_filepath)

lstr_attachment.attachment_type = datalist.extension_default_attachment_type(lstr_filepath.extension)
If isnull(lstr_attachment.attachment_type) Or Len(lstr_attachment.attachment_type) = 0 Then
	lstr_attachment.attachment_type = "FILE"
End If

lstr_attachment.filename = lstr_filepath.filename
lstr_attachment.extension = lstr_filepath.extension
lstr_attachment.attachment_comment_title = ps_description
setnull(lstr_attachment.attachment_comment)
setnull(lstr_attachment.box_id)
setnull(lstr_attachment.item_id)
//lstr_attachment.xml_document
setnull(lstr_attachment.attachment_render_file)
setnull(lstr_attachment.attachment_render_file_type)
lstr_attachment.attached_by_user_id = current_scribe.user_id
//lstr_attachment.captured_signature
//lstr_attachment.epiehandler
lstr_attachment.owner_id = sqlca.customer_id
setnull(lstr_attachment.interfaceserviceid)
setnull(lstr_attachment.transportsequence)
setnull(lstr_attachment.message_id)


return new_attachment(ps_context_object, &
								pl_object_key, &
								ps_progress_type, &
								ps_progress_key, &
								lstr_attachment, &
								ps_folder)


end function

public function long new_attachment (string ps_progress_type, string ps_progress_key, string ps_filepath, string ps_description, string ps_folder);

return new_attachment(context_object, &
								object_key, &
								ps_progress_type, &
								ps_progress_key, &
								ps_filepath, &
								ps_description, &
								ps_folder)


end function

on u_component_workplan_item.create
call super::create
end on

on u_component_workplan_item.destroy
call super::destroy
end on

event constructor;call super::constructor;setnull(last_service)
setnull(treatment)
setnull(encounter_id)
setnull(problem_id)
setnull(treatment_id)
setnull(attachment_id)
setnull(observation_sequence)
manual_service = false

end event

