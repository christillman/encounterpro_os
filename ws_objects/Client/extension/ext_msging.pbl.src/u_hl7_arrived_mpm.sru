$PBExportHeader$u_hl7_arrived_mpm.sru
forward
global type u_hl7_arrived_mpm from nonvisualobject
end type
end forward

global type u_hl7_arrived_mpm from nonvisualobject
end type
global u_hl7_arrived_mpm u_hl7_arrived_mpm

forward prototypes
public function integer arrived (ref string bs_system, ref string is_billing_id, ref string is_cpr_id, ref string is_message_id, ref string is_msgtype, ref oleobject omsg, ref u_event_log mylog, ref u_sqlca cprdb, ref string is_msgevent, ref string is_last_message_id, ref string comments, string message_office_id, string billing_id_domain, string billing_id_prefix)
end prototypes

public function integer arrived (ref string bs_system, ref string is_billing_id, ref string is_cpr_id, ref string is_message_id, ref string is_msgtype, ref oleobject omsg, ref u_event_log mylog, ref u_sqlca cprdb, ref string is_msgevent, ref string is_last_message_id, ref string comments, string message_office_id, string billing_id_domain, string billing_id_prefix);/************************************************************************************
*
* Description:
*
* Returns : message rejected if
*             patient account not found or disabled
*             check in date is invalid,
*             facility code not mapped (for multi-office),
*             
*
*
*
************************************************************************************/
boolean	lb_myfacility = false
integer	ll_office_count
string	ls_office
string	ls_message,ls_appointment_message,ls_provider_message
string	ls_default_encounter_type, ls_default_new_flag = 'N'
string	ls_resource_encounter_type,ls_resource_new_flag,ls_resource
string	ls_attending_doctor,ls_attending_doctor_id
string	ls_attending_doctor_firstname,ls_attending_doctor_lastname
string	ls_billing_id,ls_internal_id,ls_external_id
string	ls_account_number,ls_chief_complaint,ls_comment2
string	ls_cprid,ls_encounter_type,ls_new_flag,ls_appointment_type,ls_appointment_text
string	ls_status,ls_type_status,ls_appointment_reason
string 	ls_facility_namespaceid,ls_patientclass
string 	ls_visitnumber_id,ls_alternatevisitid_id
string 	ls_destination,ls_dest_system
string	ls_scheduledatetime,ls_scheduledate
string   ls_arrived ,ls_arrival_text
string   ls_scheduletime,ls_alternate_PID
string   ls_patient_provider,ls_temp,ls_primary_provider
string 	ls_resourceid,ls_resourcetext
string 	ls_thisdatetime,ls_encounter_type_description
string	ls_allow_past_encounter
integer	li_encounter_billing_id
integer	li_sts
integer 	i,li_sort_sequence,li_resource_sequence
boolean  lb_resource = false
long 		ll_count
long		ll_appgrp_count
date 		ld_thisdate, ld_scheduledate
datetime	ldt_encounter_date_time
datetime ld_scheduledatetime
time 		lt_thistime,lt_scheduletime

ls_thisdatetime = string(today(),"yyyy/mm/dd hh:mm:ss")
ld_thisdate = Date(left(ls_thisdatetime,10))
lt_thistime = Time(Mid(ls_thisdatetime,12))

setnull(ls_patientclass)
setnull(ls_visitnumber_id)
setnull(ls_alternatevisitid_id)
setnull(ls_internal_id)
setnull(ls_external_id)
setnull(ls_account_number)
setnull(ls_alternate_PID)
setnull(ls_appointment_type)
setnull(ls_comment2)
setnull(ls_patient_provider)
setnull(ls_attending_doctor_id)

// if the message is already sent then reject this
ll_count = 0
SELECT count(*)  
INTO :ll_count 
FROM x_encounterpro_Arrived  
WHERE x_encounterpro_Arrived.message_id = :is_message_id using cprdb ;
IF NOT cprdb.check() THEN RETURN -1
If ll_count > 0 then 
	mylog.log(this, "u_hl7_arrived_mpm.arrived:0071", "message referencing this Message ID (" + string(is_message_id) + ") already arrived", 3)
	return 1
End if	

//	Get the Patient Internal and External ID
if is_msgtype = "SIU" then
	ll_count = omsg.PatientIdentificationGroup.Count
	if ll_count > 0 then
		ls_external_id = omsg.PatientIdentificationGroup.Item[0].PatientIdentification.ExternalPatientID.ID.valuestring
		ll_count = omsg.PatientIdentificationGroup.Item[0].PatientIdentification.InternalPatientID.Count
		if ll_count > 0 then
			ls_internal_id = omsg.PatientIdentificationGroup.Item[0].PatientIdentification.InternalPatientID.Item[0].ID.valuestring
		end if	
	else
		mylog.log(this, "u_hl7_arrived_mpm.arrived:0085", "PID Segment not provided, Message ID (" + string(is_message_id) + ")", 4)
		return -1
	end if	
Else	
	ll_count = omsg.PatientIdentification.InternalPatientID.Count
	if ll_count > 0 then
		ls_internal_id = omsg.PatientIdentification.InternalPatientID.Item[0].ID.valuestring
	end if
	ls_external_id = omsg.PatientIdentification.ExternalPatientID.ID.valuestring
	ll_count = omsg.PatientIdentification.AlternatePatientID.Count
	if ll_count > 0 then
		ls_alternate_PID = omsg.PatientIdentification.AlternatePatientID.Item[0].ID.valuestring
	end if
	ls_account_number = omsg.PatientIdentification.PatientAccountNumber.ID.valuestring
End if
// Get the billing id for the patient	
If isnull(is_billing_id) then
	if isnull(ls_external_id) or ls_external_id = "" then
		if isnull(ls_internal_id) or ls_internal_id = "" then
			if isnull(ls_alternate_PID) or ls_alternate_PID = "" then
				mylog.log(this, "u_hl7_arrived_mpm.arrived:0105", "Patient External ID not provided, Message ID (" + string(is_message_id) + ")", 4)
				return -1
			else
				ls_billing_id = ls_alternate_PID
			end if	
		else
			ls_billing_id = ls_internal_id
		end if	
	else
		ls_billing_id = ls_external_id
	end if
Else
	ls_billing_id = is_billing_id
End if	

// Message type is 'SIU S12' then get attending doc,appointment info
If is_msgtype = "SIU" then

	/* SCHEDULE Activity Information */
	ls_visitnumber_id = omsg.scheduleactivityinformation.PlacerAppointmentID.EntityIdentifier.valuestring
	// Check whether it's Arrival message ??
	ls_arrived = omsg.scheduleactivityinformation.FillerStatusCode.Identifier.valuestring
	if upper(ls_arrived) <> 'ARRIVED' then 
		mylog.log(this, "u_hl7_arrived_mpm.arrived:0128", "SIU not arrived (" + ls_arrived  + ")", 3)
		return 1
	end if	
	ls_arrival_text =  omsg.scheduleactivityinformation.FillerStatusCode.Text.valuestring
	if Pos(ls_arrival_text,'Cancel') > 0 then return 1
	// Get the appointment type
	ls_appointment_type = omsg.scheduleactivityinformation.AppointmentType.Identifier.valuestring
	ls_appointment_text = omsg.scheduleactivityinformation.AppointmentType.Text.valuestring
	ls_chief_complaint=ls_appointment_text
	// get the chief complaint
	if isnull(ls_chief_complaint) or ls_chief_complaint = '' then
		ls_chief_complaint = omsg.ScheduleActivityInformation.EventReason.Identifier.valuestring
	end if
	if not isnull(omsg.scheduleactivityinformation.AppointmentTimingQuantity) then
		ll_count = omsg.scheduleactivityinformation.AppointmentTimingQuantity.Count
		if ll_count > 0 then
			ls_scheduledatetime = omsg.scheduleactivityinformation.AppointmentTimingQuantity.Item[0].StartDateTime.valuestring
		end if
	end if
	
	/*PID Segment*/
	// Getting Facility and Attending Doctor
	if not isnull(omsg.PatientIdentificationGroup) then
		ll_count = omsg.PatientIdentificationGroup.Count
		if ll_count > 0 then
			ls_facility_namespaceid = omsg.PatientIdentificationGroup.Item[0].PatientVisit.AssignedPatientLocation.Facility.NamespaceID.valuestring
			ll_count = omsg.PatientIdentificationGroup.Item[0].PatientVisit.AttendingDoctor.Count
			if ll_count > 0 then
				ls_attending_doctor_id = omsg.PatientIdentificationGroup.Item[0].PatientVisit.AttendingDoctor.Item[0].IDNumber.valuestring
				ls_attending_doctor_firstname = omsg.PatientIdentificationGroup.Item[0].PatientVisit.AttendingDoctor.Item[0].Familyname.valuestring
				ls_attending_doctor_lastname = omsg.PatientIdentificationGroup.Item[0].PatientVisit.AttendingDoctor.Item[0].Givenname.valuestring
			end if
		end if	
	end if	
	
	/* Appointment Information Group */
	If not isnull(omsg.AppointmentInformationGroup) then
		ll_appgrp_count = omsg.AppointmentInformationGroup.Count
		If ll_appgrp_count > 0  then
			//PersonalResource
			ll_count = omsg.AppointmentInformationGroup.Item[0].AppointmentInformationPersonnelResource.Count
			If ll_count > 0 then
				If ls_attending_doctor_id = '' or isnull(ls_attending_doctor_id) then
					ls_attending_doctor_id = omsg.AppointmentInformationGroup.Item[0].AppointmentInformationPersonnelResource.Item[0].AppointmentInformationPersonnelResource.PersonnelResourceID.IDNumber.valuestring
					ls_attending_doctor_firstname = omsg.AppointmentInformationGroup.Item[0].AppointmentInformationPersonnelResource.Item[0].AppointmentInformationPersonnelResource.PersonnelResourceID.Familyname.valuestring
					ls_attending_doctor_lastname = omsg.AppointmentInformationGroup.Item[0].AppointmentInformationPersonnelResource.Item[0].AppointmentInformationPersonnelResource.PersonnelResourceID.Givenname.valuestring
				End if
			End if
			//Location Resource
			ll_count = omsg.AppointmentInformationGroup.Item[0].AppointmentInformationLocationResource.Count
			If ll_count > 0 then
				ll_count = omsg.AppointmentInformationGroup.Item[0].AppointmentInformationLocationResource.Item[0].NotesAndComments.count
				If ll_count > 0 then
					ls_comment2 = omsg.AppointmentInformationGroup.Item[0].AppointmentInformationLocationResource.Item[0].NotesAndComments.Item[0].Comment.valuestring
					ls_chief_complaint = ls_chief_complaint + ' ' + ls_comment2
				End if
			End if	
			// General Resource (Where resource schedule info is there)
			ll_count = omsg.AppointmentInformationGroup.Item[0].AppointmentInformationGeneralResource.Count
			If ll_count > 0 then
				ls_resourceid = omsg.AppointmentInformationGroup.Item[0].AppointmentInformationGeneralResource.Item[0].AppointmentInformationGeneralResource.ResourceID.Identifier.valuestring
				ls_resourcetext = omsg.AppointmentInformationGroup.Item[0].AppointmentInformationGeneralResource.Item[0].AppointmentInformationGeneralResource.ResourceID.Text.valuestring
			End if	
		End if
	End if	
	If not isnull(ls_scheduledatetime)  or ls_scheduledatetime = '' then
		ls_scheduledate = left(ls_scheduledatetime,4) + '/' + mid(ls_scheduledatetime,5,2) + '/' + mid(ls_scheduledatetime,7,2)
		ld_scheduledate = Date(ls_scheduledate)
		ls_scheduletime = mid(ls_scheduledatetime,9,2) + ':' + mid(ls_scheduledatetime,11,2)
		lt_scheduletime = Time(ls_scheduletime) 
		ld_scheduledatetime = DateTime(ld_scheduledate,lt_scheduletime)
	End if		
END IF

if is_msgtype = "ADT" then
	if isnull(omsg.patientvisit) then
		mylog.log(this, "u_hl7_arrived_mpm.arrived:0204", "Pativent Visit Segment not provided, Message ID (" + string(is_message_id) + ")", 4)
		return 1
	end if
	
	ll_count = omsg.PatientVisit.FinancialClass.Count
	if ll_count > 0 then
		ls_patientclass = omsg.PatientVisit.FinancialClass.Item[0].FinancialClass.valuestring
	end if
	ls_appointment_type = omsg.patientvisit.HospitalService.valuestring
	setnull(ls_visitnumber_id)
	setnull(ls_alternatevisitid_id)
	ls_visitnumber_id = omsg.PatientVisit.AlternateVisitID.ID.valuestring
	if not isnull(omsg.patientvisitadditionalinfo) then
		ls_scheduledatetime = omsg.patientvisitadditionalinfo.ExpectedAdmitDateTime.valuestring
		if not isnull(ls_scheduledatetime) then
			ls_scheduledate = left(ls_scheduledatetime,4) + '/' + mid(ls_scheduledatetime,5,2) + '/' + mid(ls_scheduledatetime,7,2)
			ld_scheduledate = Date(ls_scheduledate)
			ls_scheduletime = mid(ls_scheduledatetime,9,2) + ':' + mid(ls_scheduledatetime,11,2)
			lt_scheduletime = Time(ls_scheduletime) 
			ld_scheduledatetime = DateTime(ld_scheduledate,lt_scheduletime)
		else
			return 1
		end if
		ls_chief_complaint = omsg.patientvisitadditionalinfo.VisitDescription.valuestring
		if isnull(ls_appointment_type) or ls_appointment_type = '' then
			ls_appointment_type = omsg.patientvisitadditionalinfo.AdmitReason.Text.valuestring
		end if 
	end if
	ls_facility_namespaceid = omsg.PatientVisit.AssignedPatientLocation.Facility.NamespaceID.valuestring

	ll_count = omsg.PatientVisit.AttendingDoctor.Count
	if ll_count > 0 then
		ls_attending_doctor_id = omsg.PatientVisit.AttendingDoctor.Item[0].IDNumber.valuestring
		ls_attending_doctor_firstname = omsg.PatientVisit.AttendingDoctor.Item[0].Familyname.valuestring
		ls_attending_doctor_lastname = omsg.PatientVisit.AttendingDoctor.Item[0].Givenname.valuestring
	end if
End if	

// Validate Facility
// If Only one facility  then by default assume the facility if null facility is sent
if ls_facility_namespaceid = '' or isnull(ls_facility_namespaceid) then 
	SELECT count(*)
	INTO :ll_office_count
	FROM c_Office
	using sqlca;

	if ll_office_count = 1 or isnull(ll_office_count) then
		SELECT office_id
		INTO :ls_office
		from c_office
		using sqlca;
	else
		lb_myfacility = false
	End if	
else
		SELECT min(office_id)
		INTO :ls_office
		from c_office
		where billing_id = :ls_facility_namespaceid
		using sqlca;
end if
if len(ls_office) = 0 or isnull(ls_office) then lb_myfacility = false else lb_myfacility = true

if not lb_myfacility then 
	ls_message = "Facility Code (" + ls_facility_namespaceid + ") " + "not mapped"
	mylog.log(this, "u_hl7_arrived_mpm.arrived:0269", ls_message , 4)
	GOTO error
end if	

if billing_id_domain <> "JMJBILLINGID" then
	ls_office = message_office_id
end if

ls_destination = omsg.MessageHeader.SendingApplication.NameSpaceID.valuestring
// Check for valid appointment date
ldt_encounter_date_time = datetime(today(),now())
if not isnull(ls_scheduledatetime) then
	ls_scheduledate = left(ls_scheduledatetime,4) + '/' + mid(ls_scheduledatetime,5,2) + '/' + mid(ls_scheduledatetime,7,2)
	ld_scheduledate = Date(ls_scheduledate)
	// if the past encounter is allowed then dont reject them. (added this as per Jeff Request)
	ls_allow_past_encounter = datalist.get_preference("PREFERENCES", "ALLOW_PAST_ENCOUNTERS")
	if isnull(ls_allow_past_encounter) or len(ls_allow_past_encounter) = 0 then ls_allow_past_encounter = 'N'
	if ld_scheduledate <> ld_thisdate then
		if left(upper(ls_allow_past_encounter),1) = "F" or left(upper(ls_allow_past_encounter),1) = 'N' Then
			ls_message = "Check in date ( "+ls_scheduledate+") is invalid"
			mylog.log(this, "u_hl7_arrived_mpm.arrived:0289", ls_message , 4)
			GOTO error
		else
			mylog.log(this, "u_hl7_arrived_mpm.arrived:0292", "formatted date(" + ls_scheduledate + ") not today. but allowing the appointment to be created", 3)
			ldt_encounter_date_time = datetime(ld_scheduledate,now())
		end if
	end if
else
	ls_message = "check in date is empty"
	GOTO error
end if
// Find Attending doctor from PV1 Segment
Setnull(ls_attending_doctor)
if not isnull(ls_attending_doctor_id) and len(ls_attending_doctor_id) > 0 Then
	SELECT user_id
	INTO :ls_attending_doctor
	FROM c_USer
	Where billing_id = :ls_attending_doctor_id
	and user_status = 'OK'
	Using Sqlca;
	If sqlca.sqlcode = 100 then // no match
		ls_provider_message = "Attending doctor code ( " + ls_attending_doctor_lastname+","+ls_attending_doctor_firstname+" = "+ls_attending_doctor_id+") not mapped"
		mylog.log(this, "u_hl7_arrived_mpm.arrived:0311", ls_provider_message , 3)
		Setnull(ls_attending_doctor)
	End if
end if

// set a default appointment type
if not isnull(default_encounter_type) Then
	ls_default_encounter_type = default_encounter_type
else
	ls_default_encounter_type = "SICK"
end if
// Appointment Type Matching ..
setnull(ls_encounter_type)
setnull(ls_new_flag)
If isnull(ls_appointment_type) or len(ls_appointment_type) = 0 then
	ls_appointment_message = "appointment type code & text is empty" 
	setnull(ls_appointment_reason)
Else	
	if len(ls_appointment_text) > 0 Then ls_appointment_reason = ls_appointment_text else &
		ls_appointment_reason = ls_appointment_type
	SELECT encounter_type,
		 new_flag
	INTO :ls_encounter_type,
		  :ls_new_flag
	FROM b_Appointment_Type
	WHERE upper(appointment_type) = upper(:ls_appointment_type)
	and billing_domain = :billing_id_domain
	USING cprdb;
	If Not cprdb.check() Then Return -1
	If cprdb.sqlcode = 100 then
		SELECT encounter_type,
			 new_flag
		INTO :ls_encounter_type,
			  :ls_new_flag
		FROM b_Appointment_Type
		WHERE upper(appointment_text) = upper(:ls_appointment_text)
		and billing_domain = :billing_id_domain
		USING cprdb;
		If Not cprdb.check() Then Return -1
		If cprdb.sqlcode = 100 then
			ls_appointment_message = "Appointment Type or text("+ls_appointment_type+") not mapped, adding .."
			mylog.log(this, "u_hl7_arrived_mpm.arrived:0352", "appointment type ("+ls_appointment_type+") is not mapped; Now Adding ..",3)
			Setnull(ls_encounter_type)
			Setnull(ls_new_flag)
			INSERT INTO b_Appointment_Type
			(
			appointment_type,
			encounter_type,
			new_flag
			)
			VALUES
			(
			:ls_appointment_type,
			:ls_appointment_text,
			"N"
			)
			Using Sqlca;
		End if
	End If
	if isnull(ls_encounter_type) or len(ls_encounter_type) = 0 Then 
		setnull(ls_encounter_type)
		setnull(ls_new_flag)
	else
		mylog.log(this, "u_hl7_arrived_mpm.arrived:0374", "Appointment Type, Appointment type (" + ls_appointment_type +", "+ls_encounter_type+" )" , 2)
	end if
End If

// Check for the valid resource segment
// if the resource is available then schedule for the resource
Setnull(ls_resource_encounter_type)
Setnull(ls_resource_new_flag)
Setnull(ls_resource)

If not isnull(ls_resourcetext) AND trim(ls_resourcetext) <> "" then
	mylog.log(this, "u_hl7_arrived_mpm.arrived:0385", "Resource Id and text (" + ls_resourceid + ", "+ ls_resourcetext +")" , 2)
	mylog.log(this, "u_hl7_arrived_mpm.arrived:0386", "Appointment Type (" + ls_appointment_type +")" , 2)

	IF not isnull(ls_resourceid) and len(ls_resourceid) > 0 Then
		// Check on c_User
		SELECT user_id
		INTO :ls_resource
		FROM c_User
		WHERE billing_id = :ls_resourceId
		and user_status = 'OK'
		USING cprdb;
	END IF

	// If no match for a given resource then we assume it's non-user(MPM02) resource
	If isnull(ls_resource) OR len(ls_resource) = 0 Then
	// min of Sort Sequence
		SELECT min(resource_sequence)
		INTO :li_resource_sequence
		FROM b_Resource
		WHERE (resource = :ls_resourcetext or resource = :ls_resourceid)
		AND ((appointment_type = :ls_appointment_type) OR (appointment_type is null))
		USING cprdb;
		If not cprdb.check() then Return -1
		If li_resource_sequence > 0 Then
		// get the encounter type for a resource	
			SELECT encounter_type,
				 new_flag,
				 user_id
			INTO :ls_resource_encounter_type,
				  :ls_resource_new_flag,
				  :ls_resource
			FROM b_Resource
			WHERE resource_sequence = :li_resource_sequence
			USING cprdb;
			If not cprdb.check() then Return -1
			If cprdb.sqlcode = 100 Then
				mylog.log(this, "u_hl7_arrived_mpm.arrived:0421", "Resource not mapped ( " + ls_resourceid + "," + ls_resourcetext + ")", 3)
			Else
				lb_resource = true
			End if
		End If
	Else
		lb_resource = true
	End If
	if not lb_resource then
		mylog.log(this, "u_hl7_arrived_mpm.arrived:0430", "Resource not mapped ( " + ls_resourceid + "," + ls_resourcetext + ")", 3)
	end if
End If
//	billing_id value
if isnull(is_cpr_id) then	
	SELECT 	cpr_id,
			primary_provider_id
	INTO	:ls_cprid,
	      :ls_primary_provider
	FROM		p_Patient
	WHERE		p_Patient.billing_id = :ls_billing_id
	and patient_status = 'ACTIVE'
	USING		cprdb;
	IF NOT cprdb.check() THEN RETURN -1
	IF cprdb.sqlcode = 100 THEN
		ls_message = "Patient account is disabled or not found (" + ls_billing_id + ", " + is_message_id + ")"
		mylog.log(this, "u_hl7_arrived_mpm.arrived:0446", ls_message, 4)
		GOTO error
	end if
Else
	ls_cprid = is_cpr_id
	SELECT primary_provider_id
	INTO :ls_primary_provider
	FROM p_Patient
	WHERE		p_Patient.cpr_id = :ls_cprid
	and patient_status = 'ACTIVE'
	USING		cprdb;
	IF NOT cprdb.check() THEN RETURN -1
	IF cprdb.sqlcode = 100 THEN
		ls_message = "Patient account is disabled or not found (" + ls_cprid + ", " + is_message_id + ")"
		mylog.log(this, "u_hl7_arrived_mpm.arrived:0460", ls_message, 4)
		GOTO error
	END IF
End if

// Find Patient Provider
// 1. Check PV1 is valid user
// 2. Check Resource user
// 3. Default !PHYSICIAN
if isnull(ls_resource) then // PV1.Attending doctor is empty or not mapped
	if isnull(ls_attending_doctor) then // go for PCP
		ls_patient_provider = ls_primary_provider
	Else
		ls_patient_provider = ls_attending_doctor
	end if
else
	ls_patient_provider = ls_resource
end if
if isnull(ls_patient_provider) or len(ls_patient_provider) = 0 then
	ls_patient_provider = '!PHYSICIAN' // default provider
end if	
// Encounter Type
if isnull(ls_encounter_type) then
	if isnull(ls_resource_encounter_type) or len(ls_resource_encounter_type) = 0 then
		ls_encounter_type = ls_default_encounter_type
	else
		ls_encounter_type = ls_resource_encounter_type
	end if
end if
ls_encounter_type_description = datalist.encounter_type_description(ls_encounter_type)

// Chief Complaint
if isnull(ls_chief_complaint) or ls_chief_complaint = "" or len(ls_chief_complaint) = 0 then
	ls_chief_complaint = ls_appointment_type
	if len(ls_encounter_type_description) > 0 and not isnull(ls_encounter_type_description) then
		ls_chief_complaint = ls_encounter_type_description
	end if
end if

if isnumber(ls_billing_id) then
	li_encounter_billing_id = integer(ls_billing_id)
else	
	li_encounter_billing_id = 0
end if	

ls_status = 'SCHEDULED'
if is_msgtype = 'ADT' then
	if is_msgevent = 'A34' then ls_status = 'CANCELED'
end if	

//	Write a new "ARRIVED" record to the "x_encounterpro_Arrived" table
//	It will be processed by the Scheduler
INSERT INTO 	x_encounterpro_Arrived (
					billing_id,
					encounter_billing_id,
					message_id,
					appointment_reason,
					encounter_type,
					primary_provider_id,
					chief_complaint,
					cpr_id,
					encounter_date_time,
					status,
					patient_class,
					facility_namespaceid,
					office_id,
					visitnumber_id,
					alternatevisitid_id,
					internal_id,
					external_id,
					destination,
					new_flag,
					appointment_time)
VALUES (
					:ls_billing_id,
					:li_encounter_billing_id,
					:is_message_id,
					:ls_appointment_reason,
					:ls_encounter_type,
					:ls_patient_provider,
					:ls_chief_complaint,
					:ls_cprid,
					:ldt_encounter_date_time,
					:ls_status,
					:ls_patientclass,
					:ls_facility_namespaceid,
					:ls_office,
					:ls_visitnumber_id,
					:ls_alternatevisitid_id,
					:ls_internal_id,
					:ls_external_id,
					:ls_destination,
					:ls_new_flag,
					:ld_scheduledatetime
) Using cprdb ;
IF NOT cprdb.check() THEN 
	ls_message = "Unable write a record to x_encounterpro_Arrived...Aborting Encounter Creation for Billing ID, Message ID (" + ls_billing_id + ", " + is_message_id + ")"
	mylog.log(this, "u_hl7_arrived_mpm.arrived:0557", ls_message, 4)
	GOTO error
END IF
is_last_message_id = is_message_id
is_cpr_id = ls_cprid

mylog.log(this, "u_hl7_arrived_mpm.arrived:0563", "Appointment arrived for ("+ls_cprid+")", 1)

ls_message = "Warnings:"
if not isnull(ls_appointment_message) or len(ls_appointment_message) > 0 Then
	ls_message += "~r~n"+ls_appointment_message
end if
if not isnull(ls_provider_message) or len(ls_provider_message) > 0 then
	ls_message += "~r~n"+ls_provider_message
end if
ls_message += "~r~n"+"Processed:"+"~r~nAssigned Provider: "+ls_patient_provider+"~r~nAppointment Type: "	+ls_encounter_type_description

// for now we are reporting this error for rejected messages and not sending rejection in acks

error:
is_billing_id = ls_billing_id
comments = ls_message
Return 1
end function

on u_hl7_arrived_mpm.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_hl7_arrived_mpm.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

