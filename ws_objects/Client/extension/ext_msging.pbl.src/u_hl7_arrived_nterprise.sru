$PBExportHeader$u_hl7_arrived_nterprise.sru
forward
global type u_hl7_arrived_nterprise from nonvisualobject
end type
end forward

global type u_hl7_arrived_nterprise from nonvisualobject
end type
global u_hl7_arrived_nterprise u_hl7_arrived_nterprise

forward prototypes
public function integer arrived (ref string bs_system, ref string is_billing_id, ref string is_cpr_id, ref string is_message_id, ref string is_msgtype, ref oleobject omsg, ref u_event_log mylog, ref u_sqlca cprdb, ref string is_msgevent, ref string is_last_message_id, ref string comments, string message_office_id, string billing_id_domain, string billing_id_prefix)
end prototypes

public function integer arrived (ref string bs_system, ref string is_billing_id, ref string is_cpr_id, ref string is_message_id, ref string is_msgtype, ref oleobject omsg, ref u_event_log mylog, ref u_sqlca cprdb, ref string is_msgevent, ref string is_last_message_id, ref string comments, string message_office_id, string billing_id_domain, string billing_id_prefix);string	ls_office
string	ls_message,ls_appointment_message,ls_provider_message
string	ls_encounter_type_description
integer li_sort_sequence,li_resource_sequence,ll_office_count
datetime	ldt_encounter_date_time
integer	li_encounter_billing_id
integer	li_sts
string	ls_billing_id,ls_temp
string 	ls_internal_id,ls_appointment_reason
string 	ls_external_id
string	ls_account_number
string	ls_chief_complaint
string	ls_comment2
string	ls_cprid
string	ls_encounter_type
string	ls_new_flag
string 	ls_appointment_type
string	ls_primary_provider
string	ls_status
string	ls_type_status
string	ls_attending_doctor,ls_attending_doctor_id
string	ls_attending_doctor_lastname,ls_attending_doctor_firstname
string 	ls_facility_namespaceid
string 	ls_patientclass
string 	ls_visitnumber_id
string 	ls_alternatevisitid_id
string 	ls_destination
string	ls_dest_system
string	ls_scheduledatetime
string	ls_scheduledate
string   ls_arrived 
string   ls_arrival_text
string   ls_scheduletime
string   ls_alternate_PID
string   ls_patient_provider
integer i
long ll_appgrp_count
string ls_resourceid,ls_resource
string ls_resourcetext

boolean  lb_noappt_type,lb_myfacility, lb_resource
lb_myfacility = false
long ll_count

string ls_thisdatetime
date ld_thisdate, ld_scheduledate
datetime ldt_datetimebefore, ldt_datetimeafter,ld_scheduledatetime, ldt_beginofdate
time lt_thistime, lt_minbefore, lt_minafter, lt_scheduletime, lt_begin_time

ls_thisdatetime = string(today(),"yyyy/mm/dd hh:mm:ss")
ld_thisdate = Date(left(ls_thisdatetime,10))
lt_thistime = Time(Mid(ls_thisdatetime,12))

//40 minutes before
lt_minbefore = RelativeTime(lt_thistime,-2400)
ldt_datetimebefore = Datetime(ld_thisdate,lt_minbefore)	
//20 minutes after
lt_minafter = RelativeTime(lt_thistime,1200)
ldt_datetimeafter = Datetime(ld_thisdate,lt_minafter)	
//begin of day
lt_begin_time = Time("00:00:00")
ldt_beginofdate = Datetime(ld_thisdate,lt_begin_time)	

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
setnull(ls_resource)

// if the message is already sent then reject this
ll_count = 0
SELECT count(*)  
INTO :ll_count 
FROM x_encounterpro_Arrived  
WHERE x_encounterpro_Arrived.message_id = :is_message_id using cprdb ;
IF NOT cprdb.check() THEN RETURN -1
If ll_count > 0 then 
	mylog.log(this, "u_hl7_arrived_nterprise.arrived.0084", "message referencing this Message ID (" + string(is_message_id) + ") already arrived", 3)
	return 1
End if	

setnull(ls_attending_doctor)

//	Populate variables with the omsg contents
//expecting SIUS12
ll_count = omsg.PatientIdentificationGroup.Count
if ll_count > 0 then
	ls_external_id = omsg.PatientIdentificationGroup.Item[0].PatientIdentification.ExternalPatientID.ID.valuestring
	ll_count = omsg.PatientIdentificationGroup.Item[0].PatientIdentification.InternalPatientID.Count
	if ll_count > 0 then
		ls_internal_id = omsg.PatientIdentificationGroup.Item[0].PatientIdentification.InternalPatientID.Item[0].ID.valuestring
	else
		mylog.log(this, "u_hl7_arrived_nterprise.arrived.0099", "id not provided, Message ID (" + string(is_message_id) + ")", 4)
		return -1
	end if	
else
	mylog.log(this, "u_hl7_arrived_nterprise.arrived.0084", "PID Segment not provided, Message ID (" + string(is_message_id) + ")", 4)
	return -1
end if	
	
if isnull(is_billing_id) then
	if isnull(ls_external_id) or ls_external_id = "" then
		if isnull(ls_internal_id) or ls_internal_id = "" then
			if isnull(ls_alternate_PID) or ls_alternate_PID = "" then
				mylog.log(this, "u_hl7_arrived_nterprise.arrived.0084", "Patient External ID not provided, Message ID (" + string(is_message_id) + ")", 4)
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
else
	ls_billing_id = is_billing_id
end if	

if is_msgtype = "SIU" then
	ls_visitnumber_id = omsg.scheduleactivityinformation.PlacerAppointmentID.EntityIdentifier.valuestring
//	Populate the appointment type which need to be written to x_encounter_Arrived
		ls_arrived = omsg.scheduleactivityinformation.FillerStatusCode.Identifier.valuestring
		if upper(ls_arrived) <> 'ARRIVED' then 
			mylog.log(this, "u_hl7_arrived_nterprise.arrived.0099", "SIU not arrived (" + ls_arrived  + ")", 2)
			return 1
		end if	
		ls_arrival_text =  omsg.scheduleactivityinformation.FillerStatusCode.Text.valuestring
		if Pos(ls_arrival_text,'Cancel') > 0 then return 1

		ls_appointment_type = omsg.scheduleactivityinformation.AppointmentType.Identifier.valuestring
		ls_chief_complaint = omsg.scheduleactivityinformation.AppointmentType.Text.valuestring

		if isnull(ls_chief_complaint) or ls_chief_complaint = '' then
			ls_chief_complaint = omsg.ScheduleActivityInformation.EventReason.Identifier.valuestring
		end if
		

	if not isnull(omsg.scheduleactivityinformation.AppointmentTimingQuantity) then
		ll_count = omsg.scheduleactivityinformation.AppointmentTimingQuantity.Count
		if ll_count > 0 then
			ls_scheduledatetime = omsg.scheduleactivityinformation.AppointmentTimingQuantity.Item[0].StartDateTime.valuestring
		end if
	end if
	if not isnull(omsg.AppointmentInformationGroup) then
		ll_appgrp_count = omsg.AppointmentInformationGroup.Count
		If ll_appgrp_count > 0  then
			//PersonalResource
			ll_count = omsg.AppointmentInformationGroup.Item[0].AppointmentInformationPersonnelResource.Count
			If ll_count > 0 then
					ls_attending_doctor_id = omsg.AppointmentInformationGroup.Item[0].AppointmentInformationPersonnelResource.Item[0].AppointmentInformationPersonnelResource.PersonnelResourceID.IDNumber.valuestring
					ls_attending_doctor_firstname = omsg.AppointmentInformationGroup.Item[0].AppointmentInformationPersonnelResource.Item[0].AppointmentInformationPersonnelResource.PersonnelResourceID.Familyname.valuestring
					ls_attending_doctor_lastname = omsg.AppointmentInformationGroup.Item[0].AppointmentInformationPersonnelResource.Item[0].AppointmentInformationPersonnelResource.PersonnelResourceID.Givenname.valuestring
			End if
			//Location Resource
			ll_count = omsg.AppointmentInformationGroup.Item[0].AppointmentInformationLocationResource.Count
			If ll_count > 0 then
				ls_facility_namespaceid = omsg.AppointmentInformationGroup.Item[0].AppointmentInformationLocationResource.Item[0].AppointmentInformationLocationResource.LocationResourceID.PointOfCare.valuestring
			End if	

			// General Resource (Where resource schedule info is there)
			ll_count = omsg.AppointmentInformationGroup.Item[0].AppointmentInformationGeneralResource.Count
			If ll_count > 0 then
				ls_resourceid = omsg.AppointmentInformationGroup.Item[0].AppointmentInformationGeneralResource.Item[0].AppointmentInformationGeneralResource.ResourceID.Identifier.valuestring
				ls_resourcetext = omsg.AppointmentInformationGroup.Item[0].AppointmentInformationGeneralResource.Item[0].AppointmentInformationGeneralResource.ResourceID.Text.valuestring
			End if	
		End if
	End if	
end if
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
	mylog.log(this, "u_hl7_arrived_nterprise.arrived.0203", ls_message , 4)
	GOTO error
end if	

if billing_id_domain <> "JMJBILLINGID" then
	ls_office = message_office_id
end if

//	Populate the remaining fields which need to be written to x_encounter_Arrived
ls_destination = omsg.MessageHeader.SendingApplication.NameSpaceID.valuestring
if not isnull(ls_scheduledatetime) then
	ls_scheduledate = left(ls_scheduledatetime,4) + '/' + mid(ls_scheduledatetime,5,2) + '/' + mid(ls_scheduledatetime,7,2)
	ld_scheduledate = Date(Left(ls_scheduledate,10))
	if ld_scheduledate <> ld_thisdate then
		ls_message = "Check in date ( "+ls_scheduledate+") is invalid"
		mylog.log(this, "u_hl7_arrived_nterprise.arrived.0084", ls_message , 4)
		GOTO error
	end if
end if

ls_scheduletime = mid(ls_scheduledatetime,9,2) + ':' + mid(ls_scheduledatetime,11,2)
lt_scheduletime = Time(ls_scheduletime) 
ld_scheduledatetime = DateTime(ld_scheduledate,lt_scheduletime)

if ls_attending_doctor_id = '' or isnull(ls_attending_doctor_id) then 
	if not isnull(omsg.PatientIdentificationGroup.Item[0].patientvisit) then
		ll_count = omsg.PatientIdentificationGroup.Item[0].PatientVisit.AttendingDoctor.Count
		if ll_count > 0 then
			ls_attending_doctor_id = omsg.PatientIdentificationGroup.Item[0].PatientVisit.AttendingDoctor.Item[0].IDNumber.valuestring
			ls_attending_doctor_firstname = omsg.PatientIdentificationGroup.Item[0].PatientVisit.AttendingDoctor.Item[0].Familyname.valuestring
			ls_attending_doctor_lastname = omsg.PatientIdentificationGroup.Item[0].PatientVisit.AttendingDoctor.Item[0].Givenname.valuestring
		end if
	end if	
end if	
// Find Attending doctor from AIG Segment
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
		mylog.log(this, "u_hl7_arrived_nterprise.arrived.0203", ls_provider_message , 3)
		Setnull(ls_attending_doctor)
	End if
end if

lb_noappt_type = false
// Check for the valid resource segment
// if the resource is available then schedule for the resource
setnull(ls_encounter_type)
setnull(ls_new_flag)
ls_appointment_reason = ls_appointment_type
If not isnull(ls_resourceid) AND trim(ls_resourceid) <> "" then
	mylog.log(this, "u_hl7_arrived_nterprise.arrived.0203", "Resource Id (" + ls_resourcetext +")" , 2)
	mylog.log(this, "u_hl7_arrived_nterprise.arrived.0203", "Appointment Type (" + ls_appointment_type +")" , 2)
// min of Sort Sequence
	SELECT min(sort_sequence)
	INTO :li_sort_sequence
	FROM b_Resource
	WHERE resource = :ls_resourceid
	AND ((appointment_type = :ls_appointment_type) OR (appointment_type is null))
	USING cprdb;
	If not cprdb.check() then Return -1
	if li_sort_sequence > 0 Then
		// min of resource	
		SELECT min(resource_sequence)
		INTO :li_resource_sequence
		FROM b_Resource
		WHERE sort_sequence = :li_sort_sequence
		using cprdb;
		If not cprdb.check() then Return -1
	End If
	If li_resource_sequence > 0 Then
	// get the encounter type for a resource	
		SELECT encounter_type,
				 new_flag,
				 user_id
		INTO :ls_encounter_type,
			  :ls_new_flag,
			  :ls_resource
		FROM b_Resource
		WHERE resource_sequence = :li_resource_sequence
		USING cprdb;
		If not cprdb.check() then Return -1
		If cprdb.sqlcode = 100 Then
			mylog.log(this, "u_hl7_arrived_nterprise.arrived.0203", "Resource not mapped (" + ls_resourcetext + ")", 3)
		Else
			lb_resource = true
		End if
	End If
	if not lb_resource then
		mylog.log(this, "u_hl7_arrived_nterprise.arrived.0203", "Resource not mapped (" + ls_resourcetext + ")", 3)
	end if
Elseif isnull(ls_attending_doctor) Then // may be in resource table and AIG may not be filled in all the time with ntierprise
	SELECT distinct user_id
	INTO :ls_attending_doctor
	FROM b_Resource
	Where resource = :ls_attending_doctor_id
	Using Sqlca;
	If sqlca.sqlcode = 100 then // no match
		ls_temp = "Message Id ("+is_message_id+" ) attending doctor( " + ls_attending_doctor_lastname+","+ls_attending_doctor_firstname+" - id is "+ls_attending_doctor_id+") not mapped in resource either"
		mylog.log(this, "u_hl7_arrived_nterprise.arrived.0203", ls_temp , 3)
		Setnull(ls_attending_doctor)
	End if
End If

If isnull(ls_encounter_type) and isnull(ls_new_flag) Then // Not a resource Visit
	if isnull(ls_appointment_type) or ls_appointment_type = "" then
		ls_appointment_message = "appointment type code & text is empty"
		mylog.log(this, "u_hl7_arrived_nterprise.arrived.0084",ls_appointment_message, 3)
	else	
		SELECT encounter_type,
			 new_flag
		INTO :ls_encounter_type,
			  :ls_new_flag
		FROM b_Appointment_Type
		WHERE appointment_type = :ls_appointment_type
		and billing_domain=:billing_id_domain
		USING cprdb;
		If Not cprdb.check() Then Return -1
		If cprdb.sqlcode = 100 then
			ls_appointment_message = "Appointment Type or text("+ls_appointment_type+") not mapped"
			mylog.log(this, "u_hl7_arrived_nterprise.arrived.0084",ls_appointment_message, 3)
			Setnull(ls_encounter_type)
			Setnull(ls_new_flag)
		Else
			mylog.log(this, "u_hl7_arrived_nterprise.arrived.0203", "appointment type ("+ls_appointment_type+")",2)
		End If
	end if
End If
// If appointment_type didn't provide encounter_type, then use default
if isnull(ls_encounter_type) then 
	if not isnull(default_encounter_type) Then
		ls_encounter_type = default_encounter_type
	else
		ls_encounter_type = "SICK"
	end if
end if
if isnull(ls_new_flag) then ls_new_flag = "N"

ls_encounter_type_description = datalist.encounter_type_description(ls_encounter_type)

// Chief Complaint
if isnull(ls_chief_complaint) or ls_chief_complaint = "" or len(ls_chief_complaint) = 0 then
	if len(ls_encounter_type_description) > 0 and not isnull(ls_encounter_type_description) then
		ls_chief_complaint = ls_encounter_type_description
	end if
end if

if isnumber(ls_billing_id) then
	li_encounter_billing_id = integer(ls_billing_id)
else	
	li_encounter_billing_id = 0
end if	
	
IF isnull(is_cpr_id) THEN
	SELECT cpr_id,
			primary_provider_id
	INTO :ls_cprid,
	     :ls_primary_provider
	FROM	p_Patient
	WHERE	p_Patient.billing_id = :ls_billing_id
	and patient_status = 'ACTIVE'
	USING	cprdb;
	IF NOT cprdb.check() THEN RETURN -1
	IF cprdb.sqlcode = 100 THEN
		ls_message = "Patient account is disabled or not found (" + ls_billing_id + ", " + is_message_id + ")"
		mylog.log(this, "u_hl7_arrived_nterprise.arrived.0084", ls_message, 4)
		GOTO error
	end if
ELSE
	ls_cprid = is_cpr_id
	SELECT primary_provider_id
	INTO :ls_primary_provider
	FROM p_Patient
	WHERE	p_Patient.cpr_id = :ls_cprid
	and patient_status = 'ACTIVE'
	USING	cprdb;
	IF NOT cprdb.check() THEN RETURN -1
	IF cprdb.sqlcode = 100 THEN
			ls_message = "Patient account is disabled or not found (" + ls_cprid + ", " + is_message_id + ")"
			mylog.log(this, "u_hl7_arrived_nterprise.arrived.0084",ls_message, 4)
			GOTO error
	END IF
END IF
// Find Patient Provider
// 1. Check AIG or PV1 is valid user
// 2. Check Resource user
// 3. Default !PHYSICIAN
if isnull(ls_resource) then 
	if isnull(ls_attending_doctor) then 
		setnull(ls_patient_provider)
	Else
		ls_patient_provider = ls_attending_doctor
	end if
else
	ls_patient_provider = ls_resource
end if
if isnull(ls_patient_provider) or len(ls_patient_provider) = 0 then
	ls_patient_provider = '!PHYSICIAN' // default provider
end if	
		
ldt_encounter_date_time = datetime(today(),now())
ls_status = 'SCHEDULED'

INSERT INTO	x_encounterpro_Arrived (
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
	mylog.log(this, "u_hl7_arrived_nterprise.arrived.0084", ls_message, 4)
	GOTO error
END IF
is_last_message_id = is_message_id
is_cpr_id = ls_cprid

ls_message = "Warnings:"
if not isnull(ls_appointment_message) or len(ls_appointment_message) > 0 Then
	ls_message += "~r~n"+ls_appointment_message
end if
if not isnull(ls_provider_message) or len(ls_provider_message) > 0 then
	ls_message += "~r~n"+ls_provider_message
end if
ls_message += "~r~n"+"Processed:"+"~r~nAssigned Provider: "+ls_patient_provider+"~r~nEncounter Type: "	+ls_encounter_type_description

// for now we are reporting this error for rejected messages and not sending rejection in acks
error:
is_billing_id = ls_billing_id
comments = ls_message
Return 1
end function

on u_hl7_arrived_nterprise.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_hl7_arrived_nterprise.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

