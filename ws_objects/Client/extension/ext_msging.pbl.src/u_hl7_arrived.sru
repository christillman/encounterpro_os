$PBExportHeader$u_hl7_arrived.sru
forward
global type u_hl7_arrived from nonvisualobject
end type
end forward

global type u_hl7_arrived from nonvisualobject
end type
global u_hl7_arrived u_hl7_arrived

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
boolean	lb_myfacility=false
datetime	ldt_encounter_date_time
integer	li_encounter_billing_id
integer	li_sts
string	ls_office,ls_checkin,ls_pref
string	ls_epro_doctorid,ls_epro_billing_id
string	ls_message,ls_appointment_message,ls_provider_message
string	ls_billing_id,ls_default_encounter_type
string 	ls_internal_id,ls_appointment_reason
string 	ls_external_id
string	ls_account_number
string	ls_chief_complaint
string	ls_cprid
string	ls_encounter_type,ls_encounter_type_description
string	ls_new_flag
string 	ls_appointment_type_code,ls_appointment_type_text
string	ls_primary_provider_id
string	ls_status
string	ls_type_status
string	ls_attending_doctor_id,ls_attending_doctor
string	ls_attending_doctor_lastname,ls_attending_doctor_firstname
string	ls_temp
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
string	ls_resource
string 	ls_primary_provider,ls_attending_resource
string	ls_resource_new_flag
string	ls_resource_encounter_type
string	ls_allow_past_encounter
integer i,li_sort_sequence,li_resource_sequence

boolean  lb_noappt_type, lb_resource
long ll_count,ll_office_count

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
Setnull(ls_attending_resource)
Setnull(ls_attending_doctor)
setnull(ls_visitnumber_id)
setnull(ls_alternatevisitid_id)
setnull(ls_internal_id)
setnull(ls_external_id)
setnull(ls_account_number)
setnull(ls_alternate_PID)
setnull(ls_patient_provider)
setnull(ls_resource_encounter_type)

ldt_encounter_date_time = datetime(today(),now())

// set a default appointment type
if not isnull(default_encounter_type) Then
	ls_default_encounter_type = default_encounter_type
else
	ls_default_encounter_type = "SICK"
end if

//Has this message already been sent?
ll_count = 0
SELECT count(*)  
  INTO :ll_count 
FROM x_encounterpro_Arrived  
WHERE x_encounterpro_Arrived.message_id = :is_message_id using cprdb ;
IF NOT cprdb.check() THEN RETURN -1
If ll_count > 0 then 
	mylog.log(this, "u_hl7_arrived.arrived:0107", "message referencing this Message ID (" + string(is_message_id) + ") already arrived", 3)
	Return 1
End If	

If is_msgtype = "SIU" then
	/***************
	* PID Segment
	****************/
	if upper(bs_system) = 'GENIUS' then
		ls_arrived = omsg.scheduleactivityinformation.FillerStatusCode.Identifier.valuestring
		if upper(ls_arrived) <> 'STARTED' then 
			mylog.log(this, "u_hl7_arrived.arrived:0118", "SIU not arrived (" + ls_arrived  + ")", 2)
			return 1
		end if
	end if	

	ll_count = omsg.PatientIdentificationGroup.Count
	if ll_count > 0 then
		ls_external_id = omsg.PatientIdentificationGroup.Item[0].PatientIdentification.ExternalPatientID.ID.valuestring
		ll_count = omsg.PatientIdentificationGroup.Item[0].PatientIdentification.InternalPatientID.Count
		if ll_count > 0 then
			ls_internal_id = omsg.PatientIdentificationGroup.Item[0].PatientIdentification.InternalPatientID.Item[0].ID.valuestring
		end if	
	else
		mylog.log(this, "u_hl7_arrived.arrived:0131", "PID Segment not provided, Message ID (" + string(is_message_id) + ")", 4)
		Return -1
	end if	
	/*******************
	* PV1 Segment
	********************/
	setnull(ls_visitnumber_id)
	setnull(ls_alternatevisitid_id)
	ls_visitnumber_id = omsg.PatientIdentificationGroup.Item[0].PatientVisit.VisitNumber.ID.valuestring
	ls_alternatevisitid_id = omsg.PatientIdentificationGroup.Item[0].PatientVisit.AlternateVisitID.ID.valuestring
	ls_facility_namespaceid = omsg.PatientIdentificationGroup.Item[0].PatientVisit.AssignedPatientLocation.Facility.NamespaceID.valuestring
	if isnull(ls_facility_namespaceid) or len(ls_facility_namespaceid) = 0 then
		ls_facility_namespaceid = omsg.PatientIdentificationGroup.Item[0].PatientVisit.AssignedPatientLocation.PointofCare.valuestring
	end if
		
	if upper(bs_system) = 'MEDIC' then
		ls_facility_namespaceid = omsg.PatientIdentificationGroup.Item[0].PatientVisit.PriorPatientLocation.PointOfCare.valuestring
	end if

	ll_count = omsg.PatientIdentificationGroup.Item[0].PatientVisit.AttendingDoctor.Count
	If ll_count > 0 then
		ls_attending_doctor_id = omsg.PatientIdentificationGroup.Item[0].PatientVisit.AttendingDoctor.Item[0].IDNumber.valuestring
		ls_attending_doctor_firstname = omsg.PatientIdentificationGroup.Item[0].PatientVisit.AttendingDoctor.Item[0].Familyname.valuestring
		ls_attending_doctor_lastname = omsg.PatientIdentificationGroup.Item[0].PatientVisit.AttendingDoctor.Item[0].Givenname.valuestring
	End if
	ls_appointment_type_text = omsg.PatientIdentificationGroup.Item[0].patientvisitadditionalinformation.AdmitReason.Text.valuestring
	ls_appointment_type_code = omsg.PatientIdentificationGroup.Item[0].patientvisitadditionalinformation.AdmitReason.Identifier.valuestring
	/***************
	* SCH Segment
	****************/
	ls_chief_complaint = omsg.ScheduleActivityInformation.EventReason.Identifier.valuestring
	if upper(bs_system) = 'PRACTICE POINT' then
		ls_appointment_type_code = ls_chief_complaint
	end if
	if upper(bs_system) = 'INTEGRY' then

		if upper(ls_chief_complaint) <> 'CHECK-IN' AND upper(ls_chief_complaint) <> 'ARRIVED' AND upper(ls_chief_complaint) <> 'CI' then 
			mylog.log(this, "u_hl7_arrived.arrived:0168", "SIU not arrived (" + ls_chief_complaint  + ")", 2)
			return 1
		end if
		ls_chief_complaint = omsg.ScheduleActivityInformation.AppointmentReason.Identifier.valuestring

	end if	

	if upper(bs_system) = 'MEDIC' then
		ls_chief_complaint = omsg.ScheduleActivityInformation.AppointmentReason.Identifier.valuestring
		ls_visitnumber_id = omsg.scheduleactivityinformation.FillerAppointmentID.EntityIdentifier.valuestring
	end if    
	
	if isnull(ls_appointment_type_code) or len(ls_appointment_type_code) = 0 then
		ls_appointment_type_code = omsg.scheduleactivityinformation.AppointmentType.Identifier.valuestring
	end if
	if isnull(ls_appointment_type_text) or len(ls_appointment_type_text) = 0 then
		ls_appointment_type_text = omsg.ScheduleActivityInformation.AppointmentType.Text.valuestring
	end if
	if not isnull(omsg.scheduleactivityinformation.AppointmentTimingQuantity) then
		ll_count = omsg.scheduleactivityinformation.AppointmentTimingQuantity.Count
		if ll_count > 0 then
			ls_scheduledatetime = omsg.scheduleactivityinformation.AppointmentTimingQuantity.Item[0].StartDateTime.valuestring
		end if
	end if
	if isnull(ls_scheduledatetime) or len(ls_scheduledatetime) = 0 Then
		ls_scheduledatetime = omsg.PatientIdentificationGroup.Item[0].PatientVisit.Admitdatetime.valuestring
	end if
	/******************
	* Appointment Info Group
	*******************/
	if not isnull(omsg.AppointmentInformationGroup) then
		ll_count = omsg.AppointmentInformationGroup.Count
		if ll_count > 0  then
			ll_count = omsg.AppointmentInformationGroup.Item[0].AppointmentInformationPersonnelResource.Count
			if ll_count > 0 then
				ls_resource = omsg.AppointmentInformationGroup.Item[0].AppointmentInformationPersonnelResource.Item[0].AppointmentInformationPersonnelResource.PersonnelResourceID.IDNumber.valuestring
				if upper(bs_system) = 'INTEGRY' then
					ls_attending_doctor_id = ls_resource
					ls_attending_doctor_lastname = omsg.AppointmentInformationGroup.Item[0].AppointmentInformationPersonnelResource.Item[0].AppointmentInformationPersonnelResource.PersonnelResourceID.FamilyName.valuestring
					ls_attending_doctor_firstname = omsg.AppointmentInformationGroup.Item[0].AppointmentInformationPersonnelResource.Item[0].AppointmentInformationPersonnelResource.PersonnelResourceID.GivenName.valuestring

				end if
			end if
			//Location Resource
			ll_count = omsg.AppointmentInformationGroup.Item[0].AppointmentInformationLocationResource.Count
			If ll_count > 0 then
				ls_facility_namespaceid = omsg.AppointmentInformationGroup.Item[0].AppointmentInformationLocationResource.Item[0].AppointmentInformationLocationResource.LocationResourceID.PointOfCare.valuestring
			End if	
		end if
	end if	
Elseif is_msgtype = 'ADT' then
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
	if isnull(omsg.patientvisit) then
		mylog.log(this, "u_hl7_arrived.arrived:0230", "Pativent Visit Segment not provided, Message ID (" + string(is_message_id) + ")", 4)
		return -1
	end if
	
	ll_count = omsg.PatientVisit.FinancialClass.Count
	if ll_count > 0 then
		ls_patientclass = omsg.PatientVisit.FinancialClass.Item[0].FinancialClass.valuestring
	end if
	setnull(ls_visitnumber_id)
	setnull(ls_alternatevisitid_id)
	ls_visitnumber_id = omsg.PatientVisit.VisitNumber.ID.valuestring
	ls_alternatevisitid_id = omsg.PatientVisit.AlternateVisitID.ID.valuestring
	ls_scheduledatetime = omsg.PatientVisit.Admitdatetime.valuestring
	if not isnull(omsg.patientvisitadditionalinfo) then
		if isnull(ls_scheduledatetime) or len(ls_scheduledatetime) = 0 then
			ls_scheduledatetime = omsg.patientvisitadditionalinfo.ExpectedAdmitDateTime.valuestring
		end if
		ls_chief_complaint = omsg.patientvisitadditionalinfo.VisitDescription.valuestring
		ls_appointment_type_text = omsg.patientvisitadditionalinfo.AdmitReason.Text.valuestring
		ls_appointment_type_code = omsg.patientvisitadditionalinfo.AdmitReason.Identifier.valuestring
		if len(ls_appointment_type_code) = 0 and len(ls_appointment_type_text) = 0 then
			ls_appointment_type_text = omsg.patientvisit.HospitalService.valuestring
		end if
	end if
	ls_facility_namespaceid = omsg.PatientVisit.AssignedPatientLocation.Facility.NamespaceID.valuestring
	if isnull(ls_facility_namespaceid) or len(ls_facility_namespaceid) = 0 then
		ls_facility_namespaceid = omsg.PatientVisit.AssignedPatientLocation.PointofCare.valuestring
	end if

	if upper(bs_system) = 'MEDIC' then
		ls_facility_namespaceid = omsg.PatientIdentificationGroup.Item[0].PatientVisit.PriorPatientLocation.PointOfCare.valuestring
	end if

	ll_count = omsg.PatientVisit.AttendingDoctor.Count
	if ll_count > 0 then
		ls_attending_doctor_id = omsg.PatientVisit.AttendingDoctor.Item[0].IDNumber.valuestring
		ls_attending_doctor_firstname = omsg.PatientVisit.AttendingDoctor.Item[0].familyname.valuestring
		ls_attending_doctor_lastname = omsg.PatientVisit.AttendingDoctor.Item[0].givenname.valuestring
	end if
	/* Temporary fix for Verysys (bradfordscott) attending physician is coming in visitnumber YYMMDDdoctorTIMEPacct##  Position 7-12 is doctor */
	if upper(bs_system) = 'VERSYS' then
		if isnull(ls_attending_doctor_id) or len(ls_attending_doctor_id) = 0 then
			ls_attending_doctor_id = mid(ls_visitnumber_id,7,5)
		end if
	end if
else
	mylog.log(this, "u_hl7_arrived.arrived:0276", "Invalid message type (" + is_msgtype + ")", 4)
	Return 1
end if
	
if isnull(is_billing_id) then
	if isnull(ls_external_id) or ls_external_id = "" then
		if isnull(ls_internal_id) or ls_internal_id = "" then
			if isnull(ls_alternate_PID) or ls_alternate_PID = "" then
				mylog.log(this, "u_hl7_arrived.arrived:0284", "Patient External ID not provided, Message ID (" + string(is_message_id) + ")", 4)
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

//	Validate the appointment date
ls_destination = omsg.MessageHeader.SendingApplication.NameSpaceID.valuestring
if not isnull(ls_scheduledatetime) then
	ls_scheduledate = left(ls_scheduledatetime,4) + '/' + mid(ls_scheduledatetime,5,2) + '/' + mid(ls_scheduledatetime,7,2)
	ld_scheduledate = Date(ls_scheduledate)
	ls_scheduletime = mid(ls_scheduledatetime,9,2) + ':' + mid(ls_scheduledatetime,11,2)
	lt_scheduletime = Time(ls_scheduletime) 
	ld_scheduledatetime = DateTime(ld_scheduledate,lt_scheduletime)
	// if the past encounter is allowed then dont reject them. (added this as per Jeff Request)
	ls_allow_past_encounter = datalist.get_preference("PREFERENCES", "ALLOW_PAST_ENCOUNTERS")
	if isnull(ls_allow_past_encounter) or len(ls_allow_past_encounter) = 0 then ls_allow_past_encounter = 'N'
	if ld_scheduledate <> ld_thisdate then
		if left(upper(ls_allow_past_encounter),1) = "F" or left(upper(ls_allow_past_encounter),1) = 'N' Then
			ls_message = "Check in date ( "+ls_scheduledate+") is invalid"
			mylog.log(this, "u_hl7_arrived.arrived:0313", ls_message , 4)
			GOTO error
		else
			if ld_scheduledate > ld_thisdate then
				ls_message = "Check in date ( "+ls_scheduledate+") is invalid"
				mylog.log(this, "u_hl7_arrived.arrived:0318", ls_message , 4)
				GOTO error
			end if
			mylog.log(this, "u_hl7_arrived.arrived:0321", "formatted date(" + ls_scheduledate + ") not today. but allowing the encounter to be created", 3)
			ldt_encounter_date_time = datetime(ld_scheduledate,now())
		end if
	end if
else
//	ls_message = "check in date is empty"
//	GOTO error
end if

if upper(bs_system) = 'COMPANION' Then
	if upper(ls_chief_complaint) <> 'CK' then // notification of check in by Companion
		ls_message = "Companion PM Should show 'CK' in Pv1.6 to treat this as check in event"
		mylog.log(this, "u_hl7_arrived.arrived:0333", "not a check in event", 1)
		GOTO Error
	end if
	ls_chief_complaint = trim(ls_appointment_type_text)
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
	mylog.log(this, "u_hl7_arrived.arrived:0366", ls_message , 4)
	GOTO error
end if	

if billing_id_domain <> "JMJBILLINGID" then
	ls_office = message_office_id
end if

// Find Attending doctor from PV1 Segment
if not isnull(ls_attending_doctor_id) and len(ls_attending_doctor_id) > 0 Then

	// Translate Provider
	ls_epro_doctorid = sqlca.fn_lookup_user(message_office_id,ls_attending_doctor_id)
	if isnull(ls_epro_doctorid) or len(ls_epro_doctorid)=0 then ls_epro_doctorid = ls_attending_doctor_id

	SELECT user_id
	INTO :ls_attending_doctor
	FROM c_User
	Where billing_id = :ls_epro_doctorid
	and user_status = 'OK'
	Using Sqlca;
	If sqlca.sqlcode = 100 then // no match
		SELECT distinct user_id
		INTO :ls_attending_doctor
		FROM b_resource
		WHERE resource = :ls_epro_doctorid
		Using sqlca;
		if sqlca.sqlcode = 100 then
			ls_provider_message = "Attending doctor code ( " + ls_attending_doctor_lastname+","+ls_attending_doctor_firstname+" = "+ls_epro_doctorid+") not mapped"
			mylog.log(this, "u_hl7_arrived.arrived:0395", ls_provider_message , 3)
			Setnull(ls_attending_doctor)
		end if
	End if
end if
ls_appointment_type_code= trim(ls_appointment_type_code)
ls_appointment_type_text = trim(ls_appointment_type_text)

// Validate Appointment Type
If ((isnull(ls_appointment_type_code) or len(ls_appointment_type_code) = 0) AND &
	(isnull(ls_appointment_type_text) or len(ls_appointment_type_text) = 0)) Then
	setnull(ls_encounter_type)
	setnull(ls_new_flag)
	setnull(ls_appointment_reason)
	ls_appointment_message = "appointment type code & text is empty" 
	mylog.log(this, "u_hl7_arrived.arrived:0410",ls_appointment_message, 3)
Else	
	mylog.log(this, "u_hl7_arrived.arrived:0412", "Appointment Type Code(" + ls_appointment_type_code +")" , 1)
	mylog.log(this, "u_hl7_arrived.arrived:0413", "Appointment Type Text(" + ls_appointment_type_text +")" , 1)

	ls_appointment_reason = left(ls_appointment_type_code,50)
	// Check with Appointment type code
	SELECT encounter_type,
			 new_flag
	INTO :ls_encounter_type,
		  :ls_new_flag
	FROM b_Appointment_Type
	WHERE upper(appointment_type) = upper(:ls_appointment_type_code)
	and billing_domain = :billing_id_domain
	USING cprdb;
	if not cprdb.check() then return -1
	if cprdb.sqlcode = 100 then
		ls_appointment_reason = left(ls_appointment_type_text,50)
		// Check again with Appointment type description
		SELECT encounter_type,
			 new_flag
		INTO :ls_encounter_type,
		  :ls_new_flag
		FROM b_Appointment_Type
		WHERE upper(appointment_type) = upper(:ls_appointment_type_text)
		and billing_domain = :billing_id_domain
		USING cprdb;
		
		if cprdb.sqlcode = 100 then
			setnull(ls_encounter_type)
			setnull(ls_new_flag)
			ls_appointment_message = "Appointment type code/text ("+ls_appointment_type_code+","+ls_appointment_type_text+") not mapped"
			mylog.log(this, "u_hl7_arrived.arrived:0442",ls_appointment_message, 3)
		end if
	end if
end if

// Check for Resource Appointment
If not isnull(ls_resource) and len(ls_resource) > 0 Then
	mylog.log(this, "u_hl7_arrived.arrived:0449", "Resource Code(" + ls_resource +")" , 2)
	lb_resource = false
	// min of Sort Sequence
	SELECT min(resource_sequence)
	INTO :li_resource_sequence
	FROM b_Resource
	WHERE resource = :ls_resource
	AND ((appointment_type = :ls_appointment_type_code) OR (appointment_type is null))
	USING cprdb;
	If not cprdb.check() then Return -1
	If li_resource_sequence > 0 Then
		// get the encounter type for a resource	
		SELECT encounter_type,
			 new_flag,
			 user_id
		INTO :ls_resource_encounter_type,
			  :ls_resource_new_flag,
			  :ls_attending_resource
		FROM b_Resource
		WHERE resource_sequence = :li_resource_sequence
		USING cprdb;
		If not cprdb.check() then Return -1
		If cprdb.sqlcode = 100 Then
			lb_resource = false
		Else
			lb_resource = true
		End if
	End If
	if not lb_resource then
		mylog.log(this, "u_hl7_arrived.arrived:0478", "Resource not mapped ( " + ls_resource+ ")", 3)
		setnull(ls_attending_resource)
		setnull(ls_resource_encounter_type)
		setnull(ls_resource_new_flag)
	end if
End If

// If appointment_type didn't provide encounter_type, then use default
if isnull(ls_encounter_type) then 
	if isnull(ls_resource_encounter_type) or len(ls_resource_encounter_type) = 0 then
		ls_encounter_type = ls_default_encounter_type
	else
		ls_encounter_type = ls_resource_encounter_type
	end if
end if
if isnull(ls_new_flag) then 
	if isnull(ls_resource_new_flag) then
		ls_new_flag = "N"
	else
		ls_new_flag = ls_resource_new_flag
	end if
end if

if isnull(ls_encounter_type) or len(ls_encounter_type) = 0 then ls_encounter_type = ls_default_encounter_type

// Patient Lookup
if isnull(is_cpr_id) then	
	ls_cprid = sqlca.fn_lookup_patient(billing_id_domain,ls_billing_id)
	if ls_cprid = "" then setnull(ls_cprid)

	if not isnull(ls_cprid) then
		SELECT primary_provider_id
			INTO :ls_primary_provider
		FROM p_Patient
		WHERE cpr_id = :ls_cprid
		and patient_status = 'ACTIVE'
		USING cprdb;
		IF NOT cprdb.check() THEN RETURN -1
		IF cprdb.sqlcode = 100 THEN
			ls_message = "Patient account is disabled or not found (" + ls_cprid + ", " + is_message_id + ")"
			mylog.log(this, "u_hl7_arrived.arrived:0518",ls_message, 4)
			GOTO error
		END IF
	end if
else
	ls_cprid = is_cpr_id
	If Isnull(ls_primary_provider_id) then
		SELECT primary_provider_id
		INTO :ls_primary_provider
		FROM p_Patient
		WHERE		p_Patient.cpr_id = :ls_cprid
		and patient_status = 'ACTIVE'
		USING		cprdb;
		IF NOT cprdb.check() THEN RETURN -1
		IF cprdb.sqlcode = 100 THEN
			ls_message = "Patient account is disabled or not found (" + ls_cprid + ", " + is_message_id + ")"
			mylog.log(this, "u_hl7_arrived.arrived:0534",ls_message, 4)
			GOTO error
		END IF
	END IF	
END IF

// Find Patient Provider
// 1. Check PV1 is valid user
// 2. Check Resource user
// 3. Default !PHYSICIAN
if isnull(ls_attending_resource) then // Resource
	if isnull(ls_attending_doctor) then // go for attending doctor / PCP
		setnull(ls_patient_provider)
	Else
		ls_patient_provider = ls_attending_doctor
	end if
else
	ls_patient_provider = ls_attending_resource
end if
if isnull(ls_patient_provider) or len(ls_patient_provider) = 0 then
	ls_patient_provider = '!PHYSICIAN' // default provider
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

if isnull(billing_id_prefix) then
	ls_epro_billing_id = ls_billing_id
else
	ls_epro_billing_id = billing_id_prefix + ls_billing_id
end if

//check if this is a new message for the already checked patient
SELECT count(*)  
    INTO :ll_count 
    FROM x_encounterpro_Arrived  
   WHERE x_encounterpro_Arrived.billing_id = :ls_epro_billing_id AND
			x_encounterpro_Arrived.cpr_id = :ls_cprid AND
			x_encounterpro_Arrived.facility_namespaceid = :ls_facility_namespaceid AND
			x_encounterpro_Arrived.primary_provider_id = :ls_primary_provider_id AND
			x_encounterpro_Arrived.encounter_date_time between :ldt_beginofdate and :ldt_encounter_date_time
  	using cprdb ;
	IF NOT cprdb.check() THEN RETURN -1
If ll_count > 0 then 
	mylog.log(this, "u_hl7_arrived.arrived:0586", "Patient already arrived this day within the hour" + ls_cprid + " ..Aborting Encounter Creation, Message ID (" + ls_billing_id + ", " + is_message_id + ")", 2)
	return 1	
end if

ls_encounter_type_description = datalist.encounter_type_description(ls_encounter_type)

// Chief Complaint
if isnull(ls_chief_complaint) or ls_chief_complaint = "" or len(ls_chief_complaint) = 0 then
	ls_pref = datalist.get_preference("PREFERENCES", "default_chief_complaint")
	if isnull(ls_pref) or ls_pref = "" or upper(lefT(ls_pref,1)) = "T" or upper(lefT(ls_pref,1)) = "Y" then
		if len(ls_encounter_type_description) > 0 and not isnull(ls_encounter_type_description) then
			ls_chief_complaint = ls_encounter_type_description
		end if
	else
		ls_chief_complaint = ls_appointment_type_text
	end if
	if isnull(ls_chief_complaint) or ls_chief_complaint = "" or len(ls_chief_complaint) = 0 then
			ls_chief_complaint = ls_encounter_type_description
	end if		
end if

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
					:ls_epro_billing_id,
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
		) using cprdb ;
IF NOT cprdb.check() THEN 
	ls_message = "Unable write a record to x_encounterpro_Arrived...Aborting Encounter Creation for Billing ID, Message ID (" + ls_billing_id + ", " + is_message_id + ")"
	mylog.log(this, "u_hl7_arrived.arrived:0652", ls_message, 4)
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
ls_message += "~r~n"+"Processed:"+"~r~nAssigned Provider: "+ls_patient_provider+"~r~nAppointment Type: "	+ls_encounter_type_description

// for now we are reporting this error for rejected messages and not sending rejection in acks
error:
is_billing_id = ls_epro_billing_id
comments = ls_message
Return 1
end function

on u_hl7_arrived.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_hl7_arrived.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

