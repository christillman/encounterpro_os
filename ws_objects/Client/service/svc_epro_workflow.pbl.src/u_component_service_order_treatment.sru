$PBExportHeader$u_component_service_order_treatment.sru
forward
global type u_component_service_order_treatment from u_component_service
end type
end forward

global type u_component_service_order_treatment from u_component_service
end type
global u_component_service_order_treatment u_component_service_order_treatment

forward prototypes
public function integer xx_do_service ()
public function integer order_from_treatment_type (string ps_treatment_type, long pl_problem_id)
public function integer order_from_maintenance_rule (long pl_maintenance_rule_id)
public function integer order_from_pick_new_treatments ()
public function integer order_from_attributes (string ps_treatment_type, long pl_problem_id)
end prototypes

public function integer xx_do_service ();///////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description: Closes current open encounter
//
// Returns: 1 - Complete the Service 
//          2 - Cancel the Service
//          0 - No operation[Continue]
//
// Created By:Sumathi Chinnasamy										Creation dt: 11/30/2000
//
// Modified By:															Modified On:
///////////////////////////////////////////////////////////////////////////////////////////////////////

u_component_treatment luo_treatment
integer li_sts
long i
string ls_treatment_type
long ll_null
datetime ldt_null
long ll_problem_id
str_attributes lstr_attributes
long ll_treatment_id
long ll_maintenance_rule_id
string ls_action

setnull(ll_null)
setnull(ldt_null)

// Use the passed in problem_id if there is one.  Otherwise use the assessment context.
get_attribute("problem_id", ll_problem_id)
if isnull(ll_problem_id) then ll_problem_id = problem_id

get_attribute("treatment_type", ls_treatment_type)
get_attribute("maintenance_rule_id", ll_maintenance_rule_id)
get_attribute("action", ls_action)



if isnull(ls_action) then
	if not isnull(ll_maintenance_rule_id) then
		ls_action = "maintenance_rule"
	elseif isnull(ls_treatment_type) then
		if isnull(ll_problem_id) then
			log.log(this, "u_component_service_order_treatment.xx_do_service:0044", "No action specified and no assessment and no treatment_type", 4)
			return 2
		else
			ls_action = "pick"
		end if
	else
		ls_action = "treatment_type"
	end if
end if

CHOOSE CASE lower(ls_action)
	CASE "treatment"
		if isnull(ls_treatment_type) then
			log.log(this, "u_component_service_order_treatment.xx_do_service:0057", "No treatment_type", 4)
			return 2
		end if
		li_sts = order_from_attributes(ls_treatment_type, ll_problem_id)
		return li_sts
	CASE "treatment_type"
		if isnull(ls_treatment_type) then
			log.log(this, "u_component_service_order_treatment.xx_do_service:0064", "No treatment_type", 4)
			return 2
		end if
		li_sts = order_from_treatment_type(ls_treatment_type, ll_problem_id)
		return li_sts
	CASE "pick"
		if isnull(ll_problem_id) then
			log.log(this, "u_component_service_order_treatment.xx_do_service:0071", "No problem_id", 4)
			return 2
		end if
		li_sts = order_from_pick_new_treatments()
		return li_sts
	CASE "maintenance_rule"
		if isnull(ll_maintenance_rule_id) then
			log.log(this, "u_component_service_order_treatment.xx_do_service:0078", "No maintenance_rule_id", 4)
			return 2
		end if
		li_sts = order_from_maintenance_rule(ll_maintenance_rule_id)
		return li_sts
	CASE ELSE
		log.log(this, "u_component_service_order_treatment.xx_do_service:0084", "invalid action (" + ls_action + ")", 4)
		return 2
END CHOOSE

return 1


end function

public function integer order_from_treatment_type (string ps_treatment_type, long pl_problem_id);///////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description: Closes current open encounter
//
// Returns: 1 - Complete the Service 
//          2 - Cancel the Service
//          0 - No operation[Continue]
//
// Created By:Sumathi Chinnasamy										Creation dt: 11/30/2000
//
// Modified By:															Modified On:
///////////////////////////////////////////////////////////////////////////////////////////////////////

u_component_treatment luo_treatment
integer li_sts
long i
long ll_null
datetime ldt_null
str_attributes lstr_attributes
long ll_treatment_id
long ll_maintenance_rule_id
boolean lb_past_treatment

setnull(ll_null)
setnull(ldt_null)

get_attribute("past_treatment", lb_past_treatment)

// We have a treatment_type, so create the appropriate treatment component
luo_treatment = f_get_treatment_component(ps_treatment_type)
if isnull(luo_treatment) then
	log.log(this, "u_component_service_order_treatment.order_from_treatment_type:0032", "Unable to get treatment object (" + ps_treatment_type + ")", 4)
	return -1
end if

li_sts = luo_treatment.define_treatment(this)
if li_sts <= 0 then
	component_manager.destroy_component(luo_treatment)
	return 2
end if

for i = 1 to luo_treatment.treatment_count
	lstr_attributes = f_attribute_arrays_to_str(luo_treatment.treatment_definition[i].attribute_count, &
													luo_treatment.treatment_definition[i].attribute, &
													luo_treatment.treatment_definition[i].value )
	
	ll_treatment_id = current_patient.treatments.order_treatment( &
													cpr_id, &
													encounter_id, &
													ps_treatment_type, &
													luo_treatment.treatment_definition[i].item_description, &
													pl_problem_id, &
													lb_past_treatment, &
													current_user.user_id, &
													ll_null, &
													lstr_attributes)
	if ll_treatment_id <= 0 then exit
next

if ll_treatment_id < 0 then return 2

return 1


end function

public function integer order_from_maintenance_rule (long pl_maintenance_rule_id);integer li_sts
string ls_treatment_type
u_ds_data luo_data
str_maintenance_rule lstr_maintenance_rule
long ll_problem_id
long ll_count
long i
str_popup popup
str_popup_return popup_return
string ls_procedure_id
long ll_null
datetime ldt_null
str_attributes lstr_attributes
long ll_treatment_id
string ls_description

setnull(ll_null)
setnull(ldt_null)

lstr_maintenance_rule = datalist.get_maintenance_rule(pl_maintenance_rule_id)
if isnull(lstr_maintenance_rule.maintenance_rule_id) then
	log.log(this, "u_component_service_order_treatment.order_from_maintenance_rule:0022", "Error getting maintenance rule structure", 4)
	return -1
end if

// See if we have an open assessment associated with this maintenance rule
setnull(ll_problem_id)
if lstr_maintenance_rule.assessment_flag = "Y" then
	luo_data = CREATE u_ds_data
	luo_data.set_dataobject("dw_maintenance_open_assessment_list")
	li_sts = luo_data.retrieve(current_patient.cpr_id, lstr_maintenance_rule.maintenance_rule_id)
	if li_sts < 0 then
		log.log(this, "u_component_service_order_treatment.order_from_maintenance_rule:0033", "Error getting open assessments", 4)
		return -1
	end if
	
	if li_sts > 0 then
		ll_problem_id = luo_data.object.problem_id[1]
	end if

	DESTROY luo_data
end if

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_pick_maintenance_rule_treatment")
ll_count = luo_data.retrieve(pl_maintenance_rule_id)

if ll_count <= 0 then
	setnull(ls_treatment_type)
	setnull(ls_procedure_id)
elseif ll_count = 1 then
	ls_treatment_type = luo_data.object.treatment_type[1]
	ls_procedure_id = luo_data.object.procedure_id[1]
else
	for i = 1 to ll_count
		popup.items[i] = luo_data.object.description[i]
	next
	popup.data_row_count = ll_count
	
	openwithparm(w_pop_pick, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return 2
	
	ls_treatment_type = luo_data.object.treatment_type[popup_return.item_indexes[1]]
	ls_procedure_id = luo_data.object.procedure_id[popup_return.item_indexes[1]]
end if

DESTROY luo_data

if not isnull(ls_treatment_type) and not isnull(ls_procedure_id) then
	lstr_attributes = get_attributes()
	
	f_attribute_add_attribute(lstr_attributes, "procedure_id", ls_procedure_id)
	
	setnull(ls_description)
	ll_treatment_id = current_patient.treatments.order_treatment( &
													cpr_id, &
													encounter_id, &
													ls_treatment_type, &
													ls_description, &
													ll_problem_id, &
													false, &
													current_user.user_id, &
													ll_null, &
													lstr_attributes)
	
	if ll_treatment_id < 0 then return 2
end if

return 1

end function

public function integer order_from_pick_new_treatments ();w_window_base lw_window
str_popup_return popup_return

//Openwithparm(lw_window, this, "w_pick_new_treatment")
Openwithparm(lw_window, this, "w_svc_treatment_list")
popup_return = message.powerobjectparm

if popup_return.item_count <> 1 then return 0

if (popup_return.items[1] = "COMPLETE") or (popup_return.items[1] = "OK") then
	return 1
elseif popup_return.items[1] = "CANCEL" then
	return 2
else
	return 0
end if

end function

public function integer order_from_attributes (string ps_treatment_type, long pl_problem_id);///////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description: Closes current open encounter
//
// Returns: 1 - Complete the Service 
//          2 - Cancel the Service
//          0 - No operation[Continue]
//
// Created By:Sumathi Chinnasamy										Creation dt: 11/30/2000
//
// Modified By:															Modified On:
///////////////////////////////////////////////////////////////////////////////////////////////////////

long ll_null
datetime ldt_null
str_attributes lstr_attributes
long ll_treatment_id
string ls_description
boolean lb_past_treatment

setnull(ll_null)
setnull(ldt_null)

lstr_attributes = get_attributes()

get_attribute("past_treatment", lb_past_treatment)

setnull(ls_description)
ll_treatment_id = current_patient.treatments.order_treatment( &
												cpr_id, &
												encounter_id, &
												ps_treatment_type, &
												ls_description, &
												pl_problem_id, &
												lb_past_treatment, &
												current_user.user_id, &
												ll_null, &
												lstr_attributes)

if ll_treatment_id < 0 then return 2


return 1


end function

on u_component_service_order_treatment.create
call super::create
end on

on u_component_service_order_treatment.destroy
call super::destroy
end on

