$PBExportHeader$u_component_service_send_billing.sru
forward
global type u_component_service_send_billing from u_component_service
end type
end forward

global type u_component_service_send_billing from u_component_service
end type
global u_component_service_send_billing u_component_service_send_billing

type variables
boolean bill_to_patient_domain
end variables

forward prototypes
public function integer xx_do_service ()
protected function integer xx_initialize ()
public function integer order_document (string ps_document_route)
end prototypes

public function integer xx_do_service ();/***************************************************************************************
*
* Description: Post the billing message to message queue for transport OUt to sent it
*
* Returns: -1 - Error in posting bill
*           2 - Cancelled (Cancelled the billing request)
*           1 - Success  (successfully queued the billing message)
*
*
* Created By: Sumathi Asokumar											Created:
*
*****************************************************************************************/
integer li_sts
string ls_office_name,ls_office_id
string ls_component_id,ls_bill_flag,ls_attending_provider
string ls_billable
boolean lb_send_billing_suspended
string ls_billing_system
long ll_count

u_component_billing luo_billing

setnull(ls_component_id)
// send bills to patient registered domain
if bill_to_patient_domain then
	SELECT billing_component_id,
			description,
			p.office_id
	INTO :ls_component_id,
			:ls_office_name,
			:ls_office_id
	FROM p_Patient p, c_Office o
	WHERE p.cpr_id =:current_patient.cpr_id
	AND p.office_id = o.office_id
	Using cprdb;
end if

If isnull(ls_component_id) then // send to encounter location
	SELECT billing_component_id,
		description,
		e.office_id
	INTO :ls_component_id,
		:ls_office_name,
		:ls_office_id
	FROM p_Patient_Encounter e, c_Office o
	WHERE e.cpr_id = :current_patient.cpr_id
	AND e.encounter_id = :encounter_id
	AND e.office_id = o.office_id
	USING cprdb;
	if not cprdb.check() then return -1
	if cprdb.sqlcode = 100 then
		mylog.log(this, "u_component_service_send_billing.xx_do_service:0052", "Encounter not found (" + current_patient.cpr_id + ", " + string(encounter_id) + ")", 4)
		return -1
	end if
end if

// Check whether the billing is enabled for that office
if isnull(ls_office_name) then ls_office_name = ""
if isnull(ls_office_id) then ls_office_id = ""
if isnull(ls_component_id) then
	mylog.log(this, "u_component_service_send_billing.xx_do_service:0061", "Billing not enabled for Encounter("+current_patient.cpr_id + ", " + string(encounter_id) + ") Office (" + ls_office_name + ", " + string(ls_office_id) + ")", 1)
	return 2
end if

SELECT bill_flag,
		attending_doctor
INTO :ls_bill_flag,
		:ls_attending_provider
FROM p_Patient_Encounter
WHERE cpr_id = :current_patient.cpr_id
AND encounter_id = :encounter_id
Using cprdb;
if not cprdb.check() then return -1
if cprdb.sqlcode = 100 then
	mylog.log(this, "u_component_service_send_billing.xx_do_service:0075", "Encounter not found (" + current_patient.cpr_id + ", " + string(encounter_id) + ")", 4)
	return -1
end if

If ls_bill_flag = 'N' Then
	mylog.log(this, "u_component_service_send_billing.xx_do_service:0080", "Encounter is not billable (" + current_patient.cpr_id + ", " + string(encounter_id) + ")", 1)
	Return 2 //  // Cancell the service
end if

lb_send_billing_suspended = f_string_to_boolean(current_patient.encounters.get_property_value(encounter_id, "send_billing_suspended"))
if lb_send_billing_suspended then
	// We're not supposed to send the billing data now but complete this service as though it completed OK
	return 1
end if

// Check whether the encounter provider is billable
//
ls_billable = sqlca.fn_check_encounter_owner_billable(current_patient.cpr_id,encounter_id)
if isnull(ls_billable) or len(ls_billable) = 0 then
	mylog.log(this, "u_component_service_send_billing.xx_do_service:0094", "Billing disabled for this encounter owner (" + ls_billable + ")", 1)
	Return 2 //  // Cancell the service
end if


// If the billing system is configured to go through EpIE, then send the billing document
ls_billing_system = datalist.get_preference( "PREFERENCES", "default_billing_system")
if not isnull(ls_billing_system) then
	SELECT count(*)
	INTO :ll_count
	FROM c_Document_Route
	WHERE document_route = :ls_billing_system;
	if not tf_check() then return -1
else
	ll_count = 0
end if


if ll_count > 0 then
	// EpIE Billing System
	li_sts = order_document(ls_billing_system)
	if li_sts < 0 then
		Update p_patient_encounter
		Set billing_posted = 'E'
		WHERE cpr_id = :current_patient.cpr_id
		and encounter_id = :encounter_id;
		if not tf_check() then return -1
	
		Return 2
	Else
		Update p_patient_encounter
		Set billing_posted = 'Y'
		WHERE cpr_id = :current_patient.cpr_id
		and encounter_id = :encounter_id;
		if not tf_check() then return -1
	
		Return 1
	End if
else
	// Local Billing Component
	luo_billing = component_manager.get_component(ls_component_id)
	if isnull(luo_billing) then
		mylog.log(this, "u_component_service_send_billing.xx_do_service:0136", "Error getting billing component (" + ls_component_id + ")", 4)
		return -1
	end if
	
	li_sts = luo_billing.post_encounter(current_patient.cpr_id, encounter_id)
	if li_sts < 0 then
		Update p_patient_encounter
		Set billing_posted = 'E'
		WHERE cpr_id = :current_patient.cpr_id
		and encounter_id = :encounter_id;
		if not tf_check() then return -1
	
		Return 2
	Else
		Update p_patient_encounter
		Set billing_posted = 'Q'
		WHERE cpr_id = :current_patient.cpr_id
		and encounter_id = :encounter_id;
		if not tf_check() then return -1
	
		Return 1
	End if
end if



end function

protected function integer xx_initialize ();string ls_bill_to_patient_domain

get_attribute("bill_to_patient_domain",ls_bill_to_patient_domain)
if isnull(ls_bill_to_patient_domain) then bill_to_patient_domain = false

if upper(left(ls_bill_to_patient_domain,1)) = "Y" or &
	upper(left(ls_bill_to_patient_domain,1)) = "T" Then
	bill_to_patient_domain = true
end if

return 1
end function

public function integer order_document (string ps_document_route);integer li_sts
string ls_document_type
str_encounter_description lstr_encounter
string ls_report_id
string ls_ordered_for
string ls_description
string ls_purpose
string ls_billing_id
long ll_patient_workplan_item_id
str_attributes lstr_attributes

li_sts = current_patient.encounters.encounter(lstr_encounter, encounter_id)
if li_sts < 0 then return -1

ls_report_id = get_attribute("billing_data_report_id")
if isnull(ls_report_id) then
	ls_report_id = "{2D75D801-25FB-444D-99AB-71554AC4C4D0}"
end if


ls_ordered_for = get_attribute("billing_data_report_ordered_for")
if isnull(ls_ordered_for) then ls_ordered_for = "!AdminBill"

ls_billing_id = current_patient.billing_id
if isnull(ls_billing_id) then
	ls_billing_id = "[" + current_patient.cpr_id + "]"
end if

ls_description = "Encounter Billing Data for " + ls_billing_id + " on " + string(date(lstr_encounter.encounter_date))

ll_patient_workplan_item_id = f_order_document( cpr_id, &
									encounter_id, &
									"Encounter", &
									encounter_id, &
									ls_report_id, &
									ps_document_route, &
									ls_ordered_for, &
									lstr_encounter.attending_doctor, &
									ls_description, &
									"Billing Data", &
									false, &
									true, &
									"Server", &
									"Server", &
									false, &
									lstr_attributes)
if ll_patient_workplan_item_id <= 0 then return -1

return 1

end function

on u_component_service_send_billing.create
call super::create
end on

on u_component_service_send_billing.destroy
call super::destroy
end on

