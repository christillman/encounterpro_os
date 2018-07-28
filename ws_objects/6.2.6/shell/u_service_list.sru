HA$PBExportHeader$u_service_list.sru
forward
global type u_service_list from nonvisualobject
end type
end forward

global type u_service_list from nonvisualobject
end type
global u_service_list u_service_list

type variables
string jmj_system_user = "#JMJ"


end variables

forward prototypes
public function u_component_service get_service_component (long pl_patient_workplan_item_id)
public function integer do_service (string ps_cpr_id, long pl_encounter_id, string ps_service, u_component_treatment puo_treatment)
public function integer do_service (string ps_service)
public function integer do_service (string ps_cpr_id, long pl_encounter_id, string ps_service)
public function integer do_service (string ps_service, str_attributes pstr_attributes)
public function u_component_service get_service_component (string ps_service)
public function integer do_service (long pl_patient_workplan_item_id)
public function integer order_service (string ps_cpr_id, long pl_encounter_id, string ps_service, string ps_ordered_for, string ps_description)
public function integer order_service_at_checkout (string ps_cpr_id, long pl_encounter_id, string ps_service, string ps_description, str_attributes pstr_attributes)
public function integer do_service (long pl_patient_workplan_item_id, u_component_treatment puo_treatment)
public function integer do_service (string ps_cpr_id, long pl_encounter_id, string ps_service, str_attributes pstr_attributes)
public function integer order_service (string ps_cpr_id, long pl_encounter_id, string ps_service, string ps_ordered_for, string ps_description, integer pi_step_number, str_attributes pstr_attributes)
public function integer do_service (string ps_cpr_id, long pl_encounter_id, string ps_service, u_component_treatment puo_treatment, str_attributes pstr_attributes)
public function integer do_service (str_service_info pstr_service)
public function integer display_service_properties (long pl_patient_workplan_item_id)
end prototypes

public function u_component_service get_service_component (long pl_patient_workplan_item_id);u_component_service luo_service
string ls_service


setnull(luo_service)

if isnull(pl_patient_workplan_item_id) then return luo_service

SELECT ordered_service
INTO :ls_service
FROM p_Patient_WP_item
WHERE patient_workplan_item_id = :pl_patient_workplan_item_id;
if not tf_check() then return luo_service
if sqlca.sqlcode = 100 then
	log.log(this, "do_service()", "Invalid patient_workplan_item_id (" + string(pl_patient_workplan_item_id) + ")", 4)
	return luo_service
end if
if isnull(ls_service) then
	log.log(this, "do_service()", "Workplan item has null service (" + string(pl_patient_workplan_item_id) + ")", 4)
	return luo_service
end if

return get_service_component(ls_service)


end function

public function integer do_service (string ps_cpr_id, long pl_encounter_id, string ps_service, u_component_treatment puo_treatment);str_attributes lstr_attributes

return do_service(ps_cpr_id, pl_encounter_id, ps_service, puo_treatment, lstr_attributes)

end function

public function integer do_service (string ps_service);str_attributes lstr_attributes
string ls_cpr_id
long ll_encounter_id

if isnull(current_patient) then
	setnull(ls_cpr_id)
	setnull(ll_encounter_id)
else
	ls_cpr_id = current_patient.cpr_id
	if isnull(current_display_encounter) then
		setnull(ll_encounter_id)
	else
		ll_encounter_id = current_display_encounter.encounter_id
	end if
end if

return do_service(ls_cpr_id, ll_encounter_id, ps_service, lstr_attributes)

end function

public function integer do_service (string ps_cpr_id, long pl_encounter_id, string ps_service);str_attributes lstr_attributes
u_component_treatment luo_treatment

setnull(luo_treatment)

return do_service(ps_cpr_id, pl_encounter_id, ps_service, luo_treatment, lstr_attributes)

end function

public function integer do_service (string ps_service, str_attributes pstr_attributes);string ls_cpr_id
long ll_encounter_id
string ls_context_object
string ls_temp

setnull(ll_encounter_id)

ls_cpr_id = f_attribute_find_attribute(pstr_attributes, "cpr_id")
if isnull(ls_cpr_id) and not isnull(current_patient) then
	ls_cpr_id = current_patient.cpr_id
end if

if not isnull(ls_cpr_id) then
	// We found a patient_context.  See if there is an encounter context
	ls_temp = f_attribute_find_attribute(pstr_attributes, "encounter_id")
	if isnull(ls_temp) then
		ls_context_object = f_attribute_find_attribute(pstr_attributes, "context_object")
		if lower(ls_context_object) = "encounter" then
			ls_temp = f_attribute_find_attribute(pstr_attributes, "object_key")
			if isnumber(ls_temp) then
				ll_encounter_id = long(ls_temp)
			end if
		end if
	elseif isnumber(ls_temp) then
		ll_encounter_id = long(ls_temp)
	end if
	
	// If we still don't have an encounter context and there is a current display encounter, then assume the current display
	// encounter is our encounter context
	if isnull(ll_encounter_id) and not isnull(current_display_encounter) then
		ll_encounter_id = current_display_encounter.encounter_id
	end if
end if

return do_service(ls_cpr_id, ll_encounter_id, ps_service, pstr_attributes)

end function

public function u_component_service get_service_component (string ps_service);u_component_service luo_service
string ls_component_id

setnull(luo_service)

ls_component_id = datalist.service_component_id(ps_service)
if isnull(ls_component_id) then
	log.log(this, "get_service_component()", "Null component_id (" + ps_service + ")", 4)
	return luo_service
end if

luo_service = component_manager.get_component(ls_component_id)
if isnull(luo_service) then
	log.log(this, "get_service_component()", "Error getting service component (" + ps_service + ")", 4)
	return luo_service
end if

luo_service.reset_service(ps_service)

return luo_service

end function

public function integer do_service (long pl_patient_workplan_item_id);u_component_treatment luo_treatment

setnull(luo_treatment)

return do_service(pl_patient_workplan_item_id, luo_treatment)

end function

public function integer order_service (string ps_cpr_id, long pl_encounter_id, string ps_service, string ps_ordered_for, string ps_description);integer li_step_number
str_attributes lstr_attributes

setnull(li_step_number)
lstr_attributes.attribute_count = 0

return order_service(ps_cpr_id, pl_encounter_id, ps_service, ps_ordered_for, ps_description, li_step_number, lstr_attributes)


end function

public function integer order_service_at_checkout (string ps_cpr_id, long pl_encounter_id, string ps_service, string ps_description, str_attributes pstr_attributes);integer li_step_number
str_attributes lstr_attributes

li_step_number = 999 // service will be performed at the end of encounter.

return order_service(ps_cpr_id, pl_encounter_id, ps_service, jmj_system_user, ps_description, li_step_number, pstr_attributes)


end function

public function integer do_service (long pl_patient_workplan_item_id, u_component_treatment puo_treatment);integer li_sts
string ls_service
u_component_service luo_service

luo_service = get_service_component(pl_patient_workplan_item_id)
if isnull(luo_service) then
	log.log(this, "do_service()", "Error getting service component (" + ls_service + ")", 4)
	return -1
end if

if not isvalid(puo_treatment) then setnull(puo_treatment)

luo_service.treatment = puo_treatment

luo_service.manual_service = false

li_sts = luo_service.do_service(pl_patient_workplan_item_id)
if pl_patient_workplan_item_id <= 0 then
	log.log(this, "do_service()", "Error doing service (" + ls_service + ")", 4)
	component_manager.destroy_component(luo_service)
	return -1
end if

component_manager.destroy_component(luo_service)

return li_sts

end function

public function integer do_service (string ps_cpr_id, long pl_encounter_id, string ps_service, str_attributes pstr_attributes);u_component_treatment luo_treatment
setnull(luo_treatment)

return do_service(ps_cpr_id, pl_encounter_id, ps_service, luo_treatment, pstr_attributes)

end function

public function integer order_service (string ps_cpr_id, long pl_encounter_id, string ps_service, string ps_ordered_for, string ps_description, integer pi_step_number, str_attributes pstr_attributes);long 							ll_patient_workplan_item_id
u_component_service 		luo_service
u_component_treatment	luo_treatment

setnull(luo_treatment)
luo_service = get_service_component(ps_service)
if isnull(luo_service) then
	log.log(this, "order_service()", "Error getting service component (" + ps_service + ")", 4)
	return -1
end if

if not isnull(current_service) then
	luo_service.treatment = current_service.treatment
else
	luo_service.treatment = luo_treatment
end if

ll_patient_workplan_item_id = luo_service.order_service(ps_cpr_id, pl_encounter_id, ps_ordered_for, pi_step_number, ps_description, pstr_attributes)
if ll_patient_workplan_item_id <= 0 then
	log.log(this, "order_service()", "Error ordering service (" + ps_service + ")", 4)
	return -1
end if

component_manager.destroy_component(luo_service)
Return 1

end function

public function integer do_service (string ps_cpr_id, long pl_encounter_id, string ps_service, u_component_treatment puo_treatment, str_attributes pstr_attributes);integer li_sts
long ll_patient_workplan_item_id
u_component_service luo_service
string ls_owner_flag
string ls_context_object

luo_service = get_service_component(ps_service)
if isnull(luo_service) then
	log.log(this, "do_service()", "Error getting service component (" + ps_service + ")", 4)
	return -1
end if

if not isvalid(puo_treatment) then setnull(puo_treatment)

ls_context_object = f_attribute_find_attribute(pstr_attributes, "context_object")
if isnull(ls_context_object) or lower(ls_context_object) = "treatment" then
	luo_service.treatment = puo_treatment
end if

ll_patient_workplan_item_id = luo_service.order_service(ps_cpr_id, pl_encounter_id, current_user.user_id, pstr_attributes)
if ll_patient_workplan_item_id <= 0 then
	log.log(this, "do_service()", "Error ordering service (" + ps_service + ")", 4)
	return -1
end if

luo_service.manual_service = true

li_sts = luo_service.do_service(ll_patient_workplan_item_id)
if ll_patient_workplan_item_id <= 0 then
	log.log(this, "do_service()", "Error doing service (" + ps_service + ")", 4)
	component_manager.destroy_component(luo_service)
	return -1
end if

component_manager.destroy_component(luo_service)

return li_sts

end function

public function integer do_service (str_service_info pstr_service);long ll_patient_workplan_item_id
str_attributes lstr_attributes

if pstr_service.service = "SERVICE" then
	ll_patient_workplan_item_id = long(f_attribute_find_attribute(pstr_service.attributes, "patient_workplan_item_id"))
	if not isnull(ll_patient_workplan_item_id) then
		return do_service(ll_patient_workplan_item_id)
	else
		return 0
	end if
else
	// the passed in attributes should override the context attributes
	lstr_attributes = f_context_to_attributes(pstr_service.context)
	f_attribute_add_attributes(lstr_attributes, pstr_service.attributes)
	return do_service(pstr_service.service, lstr_attributes)
end if


end function

public function integer display_service_properties (long pl_patient_workplan_item_id);integer li_sts
string ls_service
u_component_workplan_item luo_wp_item

//luo_service = get_service_component(pl_patient_workplan_item_id)
//if isnull(luo_service) then
//	log.log(this, "do_service()", "Error getting service component (" + ls_service + ")", 4)
//	return -1
//end if

luo_wp_item = CREATE u_component_workplan_item

li_sts = luo_wp_item.initialize(pl_patient_workplan_item_id)
if li_sts <= 0 then return -1

luo_wp_item.display_properties()

DESTROY luo_wp_item

return 1

end function

on u_service_list.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_service_list.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

