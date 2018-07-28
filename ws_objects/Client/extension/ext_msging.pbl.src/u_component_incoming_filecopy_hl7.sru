$PBExportHeader$u_component_incoming_filecopy_hl7.sru
forward
global type u_component_incoming_filecopy_hl7 from u_component_incoming
end type
end forward

global type u_component_incoming_filecopy_hl7 from u_component_incoming
end type
global u_component_incoming_filecopy_hl7 u_component_incoming_filecopy_hl7

type variables
string	comments
string 	is_message_id, is_FromApp, is_ToApp
string 	is_last_message_id
string 	is_cpr_id, is_billing_id
string 	is_islandcoast_rule
string 	is_msgtype
string 	is_msgevent
string 	is_idx_eom
string 	lab_system
string 	is_msg_transport
boolean 	is_time_to_reset
boolean 	ib_store_log
integer 	ii_msg_count
long 		nack_wait_time
long 		dcom_app_port
string 	dcom_app, dcom_ack_app,dcom_app_address,ack_fileaddress,ack_appl
string 	hold_incoming
string	billing_id_domain,billing_id_prefix
oleobject oAHC, oMsgMan,oEnv


end variables

forward prototypes
public function integer labresults ()
protected function integer xx_initialize ()
public function integer timer_ding ()
public function integer ahc_connect ()
public function integer message_parser ()
public function integer arrived (oleobject omsg)
public function integer insurance (oleobject omsg)
public function integer send_acks (oleobject omsg, integer pi_ack_status)
protected function integer xx_shutdown ()
public function integer get_billing_acks (oleobject ack)
public function integer patient_adt (oleobject omsg)
public function integer patient_siu (oleobject omsg)
public function string get_consultant_id (string ps_description)
end prototypes

public function integer labresults ();//string ls_cpr_id
//string ls_external_id, ls_external_id_prev
//string ls_specimen_id, ls_specimen_id_prev
//string ls_lab_id
//string ls_action_code
//string ls_observation, ls_parent_observation[], ls_c_observation
//string ls_order_result_status
//string ls_result_observation
//string ls_result_coding_system
//string ls_result_observation_desc
//string ls_result_value
//string ls_result_uom
//string ls_result_range
//string ls_result_abnormal_ind
//string ls_result_abnormal_nature
//string ls_result_obs_datetime
//string ls_result_observer
//
//string lc_result_unit   
//string lc_result
//string lc_result_amount_flag  
//string lc_severity
//string lc_abnormal_flag 
//string lc_sort_sequence  
//string lc_status 
//string lc_result_ref_range  
//
//int li_null[], li_rtn, i, j ,k, li_obs_seq, li_obs_result_seq 
//li_rtn = 1
//
//long ll_encounter_id, ll_treatment_id
//
//datetime ldt_result_datetime
//datetime ldt_now
//
//setnull(ls_external_id)
//
//long ll_count, ll_count_abn, ll_count_abf, ll_count_result
//ls_lab_id = omsg.MessageHeader.SendingFacility.value
//
//ll_count = omsg.CommonOrderGrp.Item[0].Count
//if ll_count = 0 then
//	mylog.log(this, "labresults()", "no results found ..Aborting, Message ID (" + string(is_message_id) + "," + ls_external_id + ")", 4)
//	return -1
//end if
//j = integer(ll_count)
//
//for i = 1 to j
//
//	ls_external_id = omsg.RepGrpORU1.Item[i].PatientIdentification.ExternalPatientID.ID.valuestring
//
//	if isnull(ls_external_id) or ls_external_id = "" then
//		mylog.log(this, "labresults()", "id not provided ..Aborting, Message ID (" + string(is_message_id) + ")", 4)
//		return -1
//	end if
//
//	mylog.log(this, "labresults()", "The patient id=" + ls_external_id, 1)
//	if not ls_external_id = ls_external_id_prev then  
//		SELECT cpr_id
//		INTO :ls_cpr_id
//		FROM p_Patient
//		WHERE cpr_id = :ls_external_id
//		USING cprdb;
//		if not cprdb.check() then 	return -1
//		if cprdb.sqlcode = 100 then
//			mylog.log(this, "labresults()", "cpr id not found ..Aborting, Message ID (" + string(is_message_id) + "," + ls_external_id + ")", 4)
//			return -1
//		end if
//		ls_external_id_prev = ls_external_id
//		setnull(ls_specimen_id_prev)
//	end if	
//
//	ls_specimen_id = omsg.RepGrpORU1.Item[i].CommonOrder.PlacerOrderNumber.NameSpaceID.valuestring
//	if isnull(ls_specimen_id) or ls_specimen_id = "" then
//		mylog.log(this, "labresults()", "specimen id not provided ..Aborting, Message ID (" + string(is_message_id) + ")", 4)
//		return -1
//	end if
//		
//	ls_observation = omsg.RepGrpORU1.Item[i].ObservationOrder.UniversalServiceID.Text
//	ls_order_result_status = omsg.RepGrpORU1.Item[i].ObservationOrder.ResultStatus
//	ls_action_code = omsg.RepGrpORU1.Item[i].ObservationOrder.SpecimenActionCode
//	
//	ls_result_observation = omsg.RepGrpORU1.Item[i].ResultObservation.ObservationIdentifier.Identifier.valuestring
//	ls_result_observation_desc = omsg.RepGrpORU1.Item[i].ResultObservation.ObservationIdentifier.Name.valuestring
//	ls_result_coding_system = omsg.RepGrpORU1.Item[i].ResultObservation.ObservationIdentifier.NameOfCodingSystem.valuestring
//	ll_count_result = omsg.RepGrpORU1.Item[i].ResultObservation.ObservationValue.Item[0].Count
//	
//	if ll_count_result > 0 then
//		ls_result_value = omsg.RepGrpORU1.Item[i].ResultObservation.ObservationValue.Item[1].valuestring
//	else
//		ls_result_value = 'None'
//	end if	
//	
//	ls_result_uom = omsg.RepGrpORU1.Item[i].ResultObservation.Units.Name.valuestring
//	ls_result_range = omsg.RepGrpORU1.Item[i].ResultObservation.ReferencesRange.valuestring
//	ls_result_obs_datetime = omsg.RepGrpORU1.Item[i].ResultObservation.DateTimeOfTheObservation.valuestring
//	ldt_result_datetime = datetime(ls_result_obs_datetime)
//	
//	ls_result_observer = omsg.RepGrpORU1.Item[i].ResultObservation.ResponsibleObserver.FamilyName.valuestring
//	
//	ll_count_abf = omsg.RepGrpORU1.Item[i].ResultObservation.AbnormalFlags.Tiem[0].Count
//	setnull(ls_result_abnormal_ind)
//	for k = 1 to ll_count_abf
//		ls_result_abnormal_ind += omsg.RepGrpORU1.Item[i].ResultObservation.AbnormalFlags.Item[k].valuestring
//	next
//	
//	ll_count_abn = omsg.RepGrpORU1.Item[i].ResultObservation.NatureOfAbnormalTest.Item[0].Count
//	setnull(ls_result_abnormal_nature)
//	for k = 1 to ll_count_abn
//		ls_result_abnormal_nature += omsg.RepGrpORU1.Item[i].ResultObservation.NatureOfAbnormalTest.Item[k].valuestring
//	next
//	
////'G' = Generated Order from Performing Laboratory  (Reflex Testing)
//	if ls_action_code = "G" then	
//		ls_parent_observation[i] = omsg.RepGrpORU1.Item[i].ObservationOrder.Parent.ParentsFillerOrderNumber.valuestring
//	else
//		ls_parent_observation[i] = ls_observation
//		if not ls_specimen_id = ls_specimen_id_prev then
//			ls_specimen_id_prev = ls_specimen_id
//			SELECT p_Observation.encounter_id,
//					 p_Observation.treatment_id,
//					 p_Observation.observation_sequence
//			INTO :ll_encounter_id
//			    ,:ll_treatment_id
//				 ,:li_obs_seq
//			FROM p_Treatment_Item,
//     			  p_Observation
//			WHERE p_Treatment_Item.cpr_id = :ls_cpr_id
//			AND p_Treatment_Item.send_out_flag = 'Y'  
//			AND p_Treatment_Item.treatment_type = 'TEST' 
//			AND p_Treatment_Item.treatment_status = 'COLLECTED' 
//			AND p_Observation.cpr_id = p_Treatment_Item.cpr_id
//			AND p_Observation.treatment_id = p_Treatment_Item.treatment_id
//			AND p_Observation.Observation_id = :ls_observation
//			AND p_Observation.specimen_id = :ls_specimen_id
//			AND p_Observation.lab_id = :ls_lab_id
//			AND p_Observation.collection_treatment_id IS NULL
//			AND p_Observation.collection_observation_sequence IS NULL
//			using cprdb ;
//			if not cprdb.check() then 	return -1
//			if cprdb.sqlcode = 100 then
//				mylog.log(this, "labresults()", "no lab order found ..Aborting, Message ID (" + string(is_message_id) + "," + ls_external_id + "," + ls_specimen_id+ ")", 4)
//				return -1
//			end if 
//		end if
//		
//		ls_c_observation = ls_parent_observation[i]
//		SELECT c_Observation_Result.result_unit,   
//         c_Observation_Result.result,   
//         c_Observation_Result.result_amount_flag,   
//         c_Observation_Result.severity,   
//         c_Observation_Result.abnormal_flag,   
//         c_Observation_Result.sort_sequence,   
//         c_Observation_Result.status,   
//         c_Observation_Result.result_ref_range  
//    	INTO :lc_result_unit,   
//      	  :lc_result,   
//           :lc_result_amount_flag,   
//           :lc_severity,   
//           :lc_abnormal_flag,   
//           :lc_sort_sequence,   
//           :lc_status,   
//           :lc_result_ref_range  
//    	FROM c_Observation_Result  
//   	WHERE ( c_Observation_Result.observation_id = :ls_c_observation ) AND  
//         ( c_Observation_Result.result_sequence = :i ) AND  
//         ( c_Observation_Result.result_type = "PERFORM" ) using cprdb  ;
//		if not cprdb.check() then 	return -1
//		if cprdb.sqlcode = 100 then
//			INSERT INTO c_Observation_Result
//				VALUES(:ls_c_observation
//		       ,:i
//				 ,'PERFORM'
//				 ,:ls_result_uom
//				 ,:ls_result_observation_desc
//				 ,'Y'
//				 ,0
//				 ,:ls_result_abnormal_ind
//				 ,:i
//				 ,'OK'
//				 ,:ls_result_range)
//				 using cprdb ;
//			if not cprdb.check() then 	return -1
//		else
//			UPDATE c_Observation_Result
//			Set c_Observation_Result.result_unit = :ls_result_uom
//			   ,c_Observation_Result.result = :ls_result_observation_desc
//				,c_Observation_Result.abnormal_flag = :ls_result_abnormal_ind
//				,c_Observation_Result.result_ref_range = :ls_result_range
//			using cprdb ;
//			if not cprdb.check() then 	return -1	
//		end if
//	end if
////add the result to p_observation_result
//	  SELECT max(p_Objective_Result.result_sequence )  
//    INTO :li_obs_result_seq  
//    FROM p_Objective_Result  
//   WHERE ( p_Objective_Result.cpr_id = :ls_cpr_id ) AND  
//         ( p_Objective_Result.treatment_id = :ll_treatment_id) AND  
//         ( p_Objective_Result.observation_id = :ls_observation ) AND
//			( p_Objective_Result.encounter_id = :ll_encounter_id ) using cprdb  ;
//	if not cprdb.check() then 	return -1
//	if cprdb.sqlcode = 100 then 
//		li_obs_result_seq = 1
//	else
//		li_obs_result_seq++
//	end if
//	ldt_now = datetime(today(),now())
//	INSERT INTO p_Observation_Result
//				VALUES(:ls_cpr_id
//                  ,:ll_treatment_id 
//						,:li_obs_seq
//						,'NA'
//						,:ls_result_observation
//						,:li_obs_result_seq
//						,:ll_encounter_id
//						,:ldt_result_datetime
//						,null
//						,:ls_result_value
//						,:ls_result_observer
//						,:ldt_now
//						,:ls_lab_id
//						,:ls_result_abnormal_nature
//						,:ls_result_abnormal_ind
//						,:ls_result_uom)
//	using cprdb;
//	if not cprdb.check() then 	return -1
//NEXT
//
RETURN 1



end function

protected function integer xx_initialize ();String 			ls_temp, ls_temp2, ls_store
String 			ls_dcom_app_port
String 			ls_nack_time
String 			ls_facilitycode, ls_office
Boolean 			lb_loop
Long 				ll_pos
Integer 			li_rtn, li_count = 0, thisnull


get_attribute("idx_eom",is_idx_eom)
if is_idx_eom = '' then setnull(is_idx_eom)

get_attribute("islandcoast_rule", is_islandcoast_rule)
if isnull(is_islandcoast_rule) or is_islandcoast_rule = '' or is_islandcoast_rule = 'N' then
	is_islandcoast_rule = 'N'
else
	is_islandcoast_rule = 'Y'
end if	

get_attribute("lab_system", lab_system)
get_attribute("store_msg",ls_store) 
ib_Store_log = false
if left(upper(ls_store),1) = 'T'  or left (upper(ls_Store),1) = 'Y' then 
	ib_store_log = true
end if	

get_attribute("hold_incoming_app", hold_incoming)
If len(hold_incoming) = 0 Then 
	log.log(this,"xx_initialize()","WARNING: Saving incoming message not enabled; To enable set Attribute = 'hold_incoming_app', Value='EPROHOLDIN' FOR Component = 'trn_in_filecopy_hl7'.",3)
	Setnull(hold_incoming)
End If

get_attribute("ack_fileaddress", ack_fileaddress)

get_attribute("nack_wait_time", ls_nack_time)
if isnumber(ls_nack_time) then
	nack_wait_time = long(ls_nack_time)
else
	setnull(nack_wait_time)
end if

get_attribute("ack_appl", ack_appl)
get_attribute("dcom_app_port", ls_dcom_app_port)
if isnumber(ls_dcom_app_port) then
	dcom_app_port = long(ls_dcom_app_port)
	if isnull(ack_appl) then
		mylog.log(this, "xx_initialize", "no object destination.", 4)
		return -1
	end if
else
	setnull(dcom_app_port)
end if	

setnull(dcom_app)
log.log(this, "send_file()", "getting app", 2)
get_attribute("dcom_app", dcom_app)
if isnull(dcom_app) or dcom_app = '' then
	mylog.log(this, "xx_initialize", "no object source.", 4)
	return -1
end if

get_attribute("dcom_app_ack",dcom_ack_app)
if isnull(dcom_ack_app) or dcom_ack_app = '' then
	mylog.log(this, "xx_initialize", "no object source acknowledgement.", 4)
	return -1
end if

get_attribute("billing_system",bs_system)
if bs_system = '' then setnull(bs_system)
bs_system = upper(bs_system)
if isnull(bs_system) then
	get_attribute("bs_system",bs_system)
	if bs_system = '' then setnull(bs_system)
	bs_system = upper(bs_system)
end if

// for 2 PMS Database into 1 EPRO db the following attributes needs
// to be set
get_attribute("billing_id_domain",billing_id_domain)
if isnull(billing_id_domain) then billing_id_domain = "JMJBILLINGID"

get_attribute("billing_id_prefix",billing_id_prefix)
if isnull(billing_id_prefix) then
	if billing_id_domain <> "JMJBILLINGID" then
		log.log(this,"xx_initialize","Billing ID Prefix is required for multi billing system domains",4)
		return -1
	end if
end if

// Connect to AHC Interface
li_rtn = ahc_connect()
if li_rtn <= 0 Then 
	mylog.log(this, "xx_initialize", "Unable to connect to AHC Interface.", 4)
	return -1
end if
log.log(this, "start_receiving()", "dcom_app (" + dcom_app + ")", 2)

Return 1

end function

public function integer timer_ding ();string 		ls_ack_message_id,ls_ack_type
String		ls_error1,ls_error2,ls_error
String		ls_cpr_id
Long			ll_encounter_id
integer 		i,j
long 			count,ll_message_id,ll_pending
oleobject 	coll  //HCMessageEnvelopeCollection

// check for messages
ll_pending = omsgMan.NumMessagesPending()
If ll_pending > 0 Then
	mylog.log(this, "timer_ding()", "message received (" + string(ll_pending) + ")", 2)
	For i = 1 to ll_pending
	   coll = omsgMan.PollForMessage(1, count)
		count = Coll.Count
   	// get messages
		If count = 0 Then Return 1 // no messages
		FOR j = 0 to count - 1
   			oEnv = coll.Item(j)
				message_parser()
				omsgMan.donewithmessage(oEnv)
				oenv.disconnectobject()
				Destroy(oEnv)
				Setnull(oEnv)
		Next
		For j = 0 to (integer(coll.count)) - 1
			coll.Remove (j)
		Next 
		coll.disconnectobject()
		destroy(Coll)
		setnull(coll)
	Next
	mylog.log(this, "timer_ding()", "messages processed (" + string(ll_pending) + ")", 2)
	Return 2
Else
	mylog.log(this, "timer_ding()", "No incoming messages to process ..", 1)
End If

Return 1
end function

public function integer ahc_connect ();INTEGER li_sts
Boolean lb_listen

lb_listen = FALSE
mylog.log(this, "ahc_connect()", "ahc_connect() - Begin", 1)

mylog.log(this, "ahc_connect()", "connecting to AHCMessager.", 1)
oAHC = CREATE oleobject
li_sts = oAHC.connecttonewobject("AHC.Messenger")
if li_sts <> 0 then
	mylog.log(this, "ahc_connect", "ERROR: connection to AHC Messenger object failed.", 4)
	oahc.disconnectobject()
	DESTROY oAHC
	setnull(oAHC)
	return -1
end if
mylog.log(this, "ahc_connect()", "connection to AHCMessager success", 1)

// Connect to AHC Messanger and returns AHC Message Manager
mylog.log(this, "ahc_connect()", "connection to IHCMessageManager object.", 1)

omsgman = oAHC.Connect(dcom_app)
If isnull(omsgman) Then
	mylog.log(this, "ahc_connect()", "ERROR: connection to IHCMessageManager object failed.", 4)
	oAHC.Disconnect()
	oahc.disconnectobject()
	DESTROY oAHC
	omsgman.disconnectobject()
	DESTROY oMsgMan
	setnull(oMsgMan)
	Setnull(oAHC)
	return -1
end if
mylog.log(this, "ahc_connect()", "connection to IHCMessageManager object successful.", 1)

return 1
end function

public function integer message_parser ();String 	ls_msgtype,ls_msgevent,ls_msgtypeobj
Integer	li_sts
Oleobject oMsg, lenv

If not isnull(hold_incoming) Then // copy to a hold folder for jmj reference
	// Clone the message
	try
		lenv = oMsgman.CloneMessage(oEnv)
		oMsgman.Sendmessage(lenv,hold_incoming)
		oMsgman.donewithmessage(lenv)
	catch (throwable lo_error)
		mylog.log(this,"message_parser()",lo_error.text,3)
	finally
		destroy lenv
		setnull(lenv)
	end try
End If
oMsg = oEnv.Content
If isnull(oMsg) then
	mylog.log(this, "message_parser()", "message object is null)", 4)
	Return -1
End If

ls_msgtype =oEnv.Type.MessageTypeCode
ls_msgevent = oEnv.Type.EventCode
ls_msgtypeobj = "HL7msg" + ls_msgtype + ls_msgevent
is_msgtype = ls_msgtype
is_msgevent = ls_msgevent

//	these are read only properties of the envelope header
is_message_id = oEnv.Header.MessageInstanceID
if is_message_id = '' or isnull(is_message_id) then
	is_message_id = oMsg.MessageHeader.DateTimeofMessage.valuestring
end if

is_FromApp = oEnv.Header.SendingApplicationID
is_ToApp = oEnv.Header.ReceivingApplicationID

mylog.log(this, "message_parser()", "message object " + ls_msgtypeobj + " From " + is_FromApp, 2)	
setnull(is_cpr_id)
setnull(is_billing_id)

Choose Case ls_msgtype
	Case "ADT"
		Choose Case ls_msgevent
			Case "A01"
				li_sts = patient_adt(omsg)
				if li_sts = 1 Then li_sts = insurance(omsg)
				if li_sts = 1 Then li_sts = arrived(omsg)
			Case  "A04"
				li_sts = patient_adt(omsg)
				if li_sts = 1 then li_sts = insurance(omsg)
			Case "A08" // Update Person Information					
				li_sts = patient_adt(omsg)
				if li_sts = 1 then li_sts = insurance(omsg)
			Case "A28", "A31" //	A28 - Add Person Information,	A31 - Update Person Information 
				li_sts = patient_adt(omsg)
				if li_sts = 1 then li_sts = insurance(omsg)
			Case "A38" //	A38 - Appointment Canceled
			Case Else
				mylog.log(this, "message_parser()", "Cannot handle type message " + ls_msgtypeobj + "Message ID (" + is_message_id + ")", 4)	
		End Choose
	Case "ORU"
		Choose Case ls_msgevent
			Case 	"O02"	
				li_sts = labresults()
			Case Else
				mylog.log(this, "xx_handle_message()", "Cannot handle type message " + ls_msgtypeobj + "Message ID (" + is_message_id + ")", 4)	
		End Choose
	Case "SIU" 
		Choose Case ls_msgevent
			Case "S12"  
				li_sts = patient_siu(omsg)
				if li_sts = 1 Then li_sts = arrived(omsg)
			Case "S14"
				li_sts = patient_siu(omsg)
				if li_sts = 1 Then li_sts = arrived(omsg)
			Case Else
				mylog.log(this, "message_parser()", "Cannot handle type message " + ls_msgtypeobj + "Message ID (" + is_message_id + ")", 4)	
				li_sts = 1
		End Choose
	Case "ACK"
		li_sts = get_billing_acks(omsg)
	Case Else
		mylog.log(this, "message_parser()", "Cannot handle type message " + ls_msgtypeobj + "Message ID (" + is_message_id + ")", 4)	
End Choose

If Not ls_msgtype = 'ACK' then
	li_sts = send_acks(omsg,li_sts)
End if

DESTROY oMsg
Setnull(oMsg)
Return li_sts
end function

public function integer arrived (oleobject omsg);integer li_sts

choose case bs_system
	case 'MILLBROOK'
		u_hl7_arrived_mpm luo_hl7_arrived_mpm
		luo_hl7_arrived_mpm = CREATE u_hl7_arrived_mpm
		li_sts = luo_hl7_arrived_mpm.arrived(bs_system,is_billing_id,is_cpr_id,is_message_id,is_msgtype,omsg,mylog,cprdb,is_msgevent,is_last_message_id,comments,message_office_id,billing_id_domain,billing_id_prefix)
		destroy luo_hl7_arrived_mpm
		setnull(luo_hl7_arrived_mpm)
	case 'NTERPRISE'
		u_hl7_arrived_nterprise luo_hl7_arrived_nterprise
		luo_hl7_arrived_nterprise = CREATE u_hl7_arrived_nterprise
		li_sts = luo_hl7_arrived_nterprise.arrived(bs_system,is_billing_id,is_cpr_id,is_message_id,is_msgtype,omsg,mylog,cprdb,is_msgevent,is_last_message_id,comments,message_office_id,billing_id_domain,billing_id_prefix)
		destroy luo_hl7_arrived_nterprise
		setnull(luo_hl7_arrived_nterprise)	
	case else	// Generic
		u_hl7_arrived luo_hl7_arrived
		luo_hl7_arrived = CREATE u_hl7_arrived
		li_sts = luo_hl7_arrived.arrived(bs_system,is_billing_id,is_cpr_id,is_message_id,is_msgtype,omsg,mylog,cprdb,is_msgevent,is_last_message_id,comments,message_office_id,billing_id_domain,billing_id_prefix)
		destroy luo_hl7_arrived
		setnull(luo_hl7_arrived)
end choose

return li_sts
end function

public function integer insurance (oleobject omsg);u_hl7_insurance luo_hl7_insurance
integer li_sts

luo_hl7_insurance = CREATE u_hl7_insurance
li_sts = luo_hl7_insurance.insurance(is_cpr_id,is_islandcoast_rule,omsg,cprdb)
destroy luo_hl7_insurance
setnull(luo_hl7_insurance)

return li_sts



end function

public function integer send_acks (oleobject omsg, integer pi_ack_status);//////////////////////////////////////////////////////////////////////////////////////////////
//
//
// Description: Check if the acknowledgement is requested and if so then use AHC to send acks
//              for all except IDX & MEDIC. Chris Socket program is used to send acks for these
//              two practices.
//
// Return: 1 - Success
//        -1 - Failure
//
//
// Created By: Sumathi Chinnasamy											Created:4/3/03
//
//////////////////////////////////////////////////////////////////////////////////////////////
String		ls_ack,ls_ack2
String		ls_ack_controlid, ls_message_type
String		ls_status = 'RECEIVED'
String		ack_code,ack_msh,ack_msa,ack_message
String 		ack_datetime
String		ack_filename,ls_uuid
Integer		li_sts,li_filenum
Boolean		no_ack
Boolean 		lb_ackfile
Datetime 	ldt_now
Long			ll_count
oleobject 	omsgtype
oleobject 	AckMsg
oleobject 	HL7MsgACK

ls_ack = oMsg.MessageHeader.ApplicationAcknowledgmentType.valuestring
ls_ack2 = oMsg.MessageHeader.AcceptAcknowledgmentType.valuestring
ls_ack_controlid = oMsg.MessageHeader.MessageControlID.valuestring
no_ack = FALSE
ldt_now = datetime(today(),now())
ack_datetime = string(ldt_now)

if isnull(ls_ack) or ls_ack = '' then 
	if isnull(ls_ack2) or ls_ack2 = '' then no_ack = true
end if	

if ls_ack = 'NE' then no_ack = true
//if ls_ack2 = 'NE' then no_ack = true
if bs_system='INTEGRY' then
	no_ack = false
end if
IF no_ack THEN // if no acknowledgement is requested then return
	ls_status = 'RECEIVED'
	IF len(ls_ack_controlid) < 21 THEN
		CHOOSE CASE bs_system
			Case 'IDX'
				ls_message_type = 'IDX_'
			case 'NTERPRISE'
				ls_message_type = 'NTR_'
			case 'MILLBROOK'
				ls_message_type = 'MPM_'
			case 'MEDIC'
				ls_message_type = 'MED_'
			case 'HORIZON'
				ls_message_type = 'HZN_'
			case else
				ls_message_type = 'UNK_'
		end choose
		ls_message_type += ls_ack_controlid
	Else
		ls_message_type = left(ls_ack_controlid,24)
	End if
	Select count(*) into :ll_count
	from o_Message_log
	where message_type = :ls_message_type
	using cprdb;
	If Not cprdb.check() Then Return -1
	If ll_count > 0 then
		ls_status = 'RECEIVED-DUP' // message already received
	End If	
	INSERT INTO o_Message_Log (
			subscription_id,
			message_type,
			message_date_time,
			direction,
			cpr_id,
			status,
			message_ack_datetime,
			comments)
	VALUES (
			:subscription_id,
			:ls_message_type,
			:ldt_now,
			'I',
			:is_billing_id,
			:ls_status,
			:ldt_now,
			:comments
			) using cprdb;
	if not cprdb.check() then return -1
	Return 1
End If

IF (isnull(ack_fileaddress) or  ack_fileaddress = '') then
	lb_ackfile = false
Else
	lb_ackfile = true
End If

IF bs_system = 'IDX' or bs_system = 'MEDIC' or bs_system='PRACTICEPOINT' then // use socket messanger to send ack's
	
	ack_msh = 'MSH|^~\&|' + ack_appl + '||'  + is_FromApp + '||' + ack_datetime + '||ACK^|' + is_message_id + '|P|2.3||||||||'
	ack_msa = 'MSA|' + ack_code + '|' + ls_ack_controlid + '||||'
	ack_message = ack_msh + '' + ack_msa + ''
	if is_idx_eom = 'Y' then ack_message += 'EOM'
	if lb_ackfile then
			ack_filename = 'ack_' + ack_datetime + '.txt'
			li_FileNum = FileOpen(ack_fileaddress + '\' + ack_filename,StreamMode!, Write!, LockWrite!, Replace!)
			FileWrite(li_FileNum, ack_message)
			FileClose(li_FileNum)
	else
		if isnull(dcom_app_port) then
			mylog.log(this, "ack()", "error no port specified for ack(trn_in_filecopy_hl7 attribute =dcom_app_port) ", 3)	
			return 1
		end if	
		oleobject jsocket
		string socket_return
		jsocket  = create oleobject
		li_sts = jsocket.connecttonewobject("jsocket.sender")
		if li_sts <> 0 then
			DESTROY jsocket
			setnull(jsocket)
			mylog.log(this, "ack()", "ERROR: connection to jsocket object failed.", 4)
			return -1
		end if
		socket_return = jsocket.SendString(ack_appl,dcom_app_port,ack_message)
		if socket_return = 'Success' then
			mylog.log(this,"ack()","message sent to jsocket " + ack_appl,1)
		else
			mylog.log(this,"ack()","error with send to jsocket " + socket_return,4)
			li_sts = -1
		end if
		DESTROY jsocket
		setnull(jsocket)
	end if	
	Return 1
End if	
// using AHC to send acks
If isnull(dcom_ack_app) or dcom_ack_app = 'N' then
	mylog.log(this,"ack","No acknowledgement destination (attribute = dcom_ack_app)",3)
	Return 1
End If
// Check whether it's accpet acknowledge or reject
if pi_ack_status < 1 then 
	ack_code = 'AR'
	ls_status = 'RECEIVED-NAC'
else
	ack_code = 'AA'
	ls_status = 'RECEIVED-ACK'
end if
if bs_system = 'INTEGRY' then
	ack_code = 'AA'
	ls_status = 'RECEIVED-ACK'
end if
// create the message type
oMsgtype = create oleobject
li_sts = oMsgtype.connecttonewobject("AHC.MessageType")
if li_sts <> 0 then
	mylog.log(this, "ack()", "ERROR: connection to AHC messagetype object failed.", 4)
	DESTROY oMsgtype
	setnull(oMsgtype)
	return -1
end if
// fill out the message type with the HL7ACK relevant information
omsgtype.MessageTypeCode = "ACK"
omsgtype.EventCode = ""
omsgtype.Version = "HL7 2.3" 	// MUST be like this!

//Create the message enevelope
AckMsg = create oleobject
AckMsg = omsgman.CreateResponseMessage(oEnv,oMsgtype)

// create a message object
HL7MsgACK = create oleobject
HL7MsgACK = AckMsg.Content
If len(ls_ack_controlid) < 21 then
		choose case bs_system
			case 'IDX'
				ls_message_type = 'IDX_'
			case 'NTERPRISE'
				ls_message_type = 'NTR_'
			case 'MILLBROOK'
				ls_message_type = 'MPM_'
			case 'MEDIC'
				ls_message_type = 'MED_'
			case 'HORIZON'
				ls_message_type = 'HZN_'
			Case else
				ls_message_type = 'UNK_'
		end choose
	ls_message_type += ls_ack_controlid
Else
	ls_message_type = 'ENCOUNTERPRO_CHECKIN'
End If
INSERT INTO o_Message_Log (
	subscription_id,
	message_type,
	message_date_time,
	direction,
	cpr_id,
	status,
	message_ack_datetime,
	comments)
VALUES (
	:subscription_id,
	:ls_message_type,
	:ldt_now,
	'I',
	:is_billing_id,
	:ls_status,
	:ldt_now,
	:comments
) using cprdb;
if not cprdb.check() then return -1

//Sending Application
HL7MsgACK.MessageHeader.SendingApplication.NameSpaceID.value = is_ToApp
//Destination Application
HL7MsgACK.MessageHeader.ReceivingApplication.NameSpaceID.value = is_FromApp
HL7MsgACK.MessageHeader.MessageControlID.value = is_message_id
HL7MsgACK.MessageAcknowledgment.AcknowledgmentCode.Value = ack_code
HL7MsgACK.MessageAcknowledgment.ControlID.Value = ls_ack_controlid

// send message to destination using AHC
mylog.log(this, "ack()", "sendmessage to " + is_FromApp + " from " + dcom_ack_app, 1)	
ls_uuid = omsgman.SendMessage(ackmsg,dcom_ack_app)
if IsNull(ls_uuid) then
	mylog.log(this,"send_ack()","error with send to AHCMessenger object",4)
end if

omsgman.DoneWithMessage(AckMsg)
destroy AckMsg
setnull(AckMsg)
destroy HL7MsgACK
setnull(HL7MsgACK)
DESTROY omsgtype
setnull(omsgtype)
Return 1

end function

protected function integer xx_shutdown ();if not isnull(oAHC) Then
	mylog.log(this,"xx_shutdown","disconnecting from AHC Interface",1)
	oAHC.Disconnect()
	mylog.log(this,"xx_shutdown","disconnected from AHC Interface",1)
End If
Destroy oAHC
Destroy omsgMan
Setnull(oAHC)
Setnull(omsgMan)

Return 1
end function

public function integer get_billing_acks (oleobject ack);String 		ls_error,ls_error1,ls_error2
String 		ls_ack_type,ls_ack_message_id
String		ls_cpr_id
Long	 		ll_encounter_id

ls_ack_type = ack.MessageAcknowledgment.AcknowledgmentCode.valuestring
ls_ack_message_id = ack.MessageAcknowledgment.ControlID.valuestring
ls_error1 = ack.MessageAcknowledgment.TextMessage.valuestring
ls_error2 = ack.MessageAcknowledgment.ErrorCondition.Text.valuestring
				
if not isnull(ls_error1) and len(ls_error1) > 0 then
	ls_error = ls_error1
end if
if not isnull(ls_error2) and len(ls_error2) > 0 then
	if len(ls_error) > 0 Then
		ls_error += ls_error2
	else
		ls_error = ls_error2
	end if
end if

ls_ack_message_id = ls_ack_message_id+"%"
SELECT cpr_id,	encounter_id
INTO :ls_cpr_id,:ll_encounter_id
FROM o_Message_Log
WHERE id like :ls_ack_message_id
Using cprdb;
If cprdb.sqlcode = 100 Then
	mylog.log(this, "timer_ding()", "No records found for message ID (" + ls_ack_message_id + ")", 2)
	Return 1
End If
					
If ls_ack_type = "AA" or ls_ack_type = "AL" or ls_ack_type = 'CA' then // bill Accepted
	Update o_message_log
	Set status = 'SENT'
	WHERE id like :ls_ack_message_id
	AND message_type = 'ENCOUNTERPRO_CHECKOUT'
	Using cprdb;
	If NOT cprdb.check() THEN RETURN -1		

	mylog.log(this, "timer_ding()", "Acknowledge received for message ID (" + ls_ack_message_id + ")", 2)
Elseif ls_ack_type = "AE" then
	Update o_message_log
	Set status = 'ACK_REJECT',
	comments = :ls_error
	Where id like :ls_ack_message_id
	And   message_type = 'ENCOUNTERPRO_CHECKOUT'
	Using cprdb;
	If Not cprdb.check() THEN Return -1		
	
	mylog.log(this, "timer_ding()", "Ack Reject received for message ID (" + ls_ack_message_id + "), Error: "+ls_error, 4)	
Else
	Update o_message_log
	Set status = 'ACK_NACK'
	Where id like :ls_ack_message_id
	AND message_type = 'ENCOUNTERPRO_CHECKOUT'
	AND status = 'ACK_WAIT'
	using cprdb;
	if not cprdb.check() then return -1		

	mylog.log(this, "timer_ding()", "NonAcknowledge received for message ID (" + ls_ack_message_id + ")" , 2)	
End if	
Destroy ack
Setnull(ack)

Return 1
end function

public function integer patient_adt (oleobject omsg);/****************************************************************************
*
*  Description: Message Type (ADT^A04 ADT^A08) Create / Update Demographics
*
*
*
*******************************************************************************/
date		ld_birthdate		
datetime ldt_date_of_birth, old_date_of_birth,ldt_null
string	ls_epro_doctorid,ls_epro_billing_id
string	ls_patient_status,ls_ref_name
string	ls_patient_name,ls_temp
string 	ls_first_name, old_first_name
string 	ls_last_name, old_last_name
string 	ls_degree, old_degree
string 	ls_name_prefix, old_name_prefix
string 	ls_middle_name, old_middle_name
string 	ls_name_suffix, old_name_suffix
string 	ls_race, old_race
string 	ls_sex, old_sex
string	 ls_phone_number, old_phone_number
string	 ls_bizphone_number, old_bizphone_number
string 	ls_primary_language, old_primary_language
string 	ls_marital_status, old_marital_status
string 	ls_billing_id, old_billing_id, ls_fix_billing_id
string	 ls_primary_provider_id, old_primary_provider_id
string 	ls_secondary_provider_id, old_secondary_provider_id 
string 	ls_error
string 	fix_date
string	 ls_account_number
string	 ls_ssn, ls_old_ssn
string	 ls_alternate_PID
string 	ls_DoctorId
string 	ls_cpr_id
string 	ls_birthdate
string 	ls_principal_provider,ls_principal_provider_firstname,ls_principal_provider_lastname
string 	ls_pcp,ls_pcp_firstname,ls_pcp_lastname
string 	ls_patient_id
string 	ls_internal_id
string 	ls_external_id
string 	ls_facility_namespaceid
string 	ls_office,ls_facility
string 	ls_addr1, ls_city, ls_state, ls_zip, ls_country,ls_addr2
string 	old_addr1, old_city, old_state, old_zip, old_country
string 	ls_religion,old_religion
string 	ls_ethnic,old_ethnic
string 	ls_referring_provider_id,old_referring_id
string	ls_referring_provider_lastname, ls_referring_provider_firstname
string	ls_consultant_id,ls_name
string	ls_gfname,ls_glname,ls_gmname,ls_gnumber
string	ls_gaddr1,ls_gcity,ls_gstate,ls_gzip
string	ls_gphone,ls_gbphone,ls_grelation,ls_pm_gid,ls_gssn
int 		li_null[],i,j
integer 	li_sts, li_rtn
integer 	li_priority
long 		ll_DoctorId,ll_len,ll_pos
long 		ll_facility
long 		ll_null
boolean 	lb_new_patient, lb_loop

li_rtn = 1
setnull(ls_internal_id)
setnull(ls_external_id)
setnull(ls_account_number)
setnull(ldt_null)
setnull(ll_null)

long ll_count

/* PID - Patient Identification Segment */
ls_account_number = omsg.PatientIdentification.PatientAccountNumber.ID.valuestring
ls_ssn = omsg.PatientIdentification.PatientSSN.valuestring
ll_count = omsg.PatientIdentification.InternalPatientID.Count
if ll_count > 0 then
	ls_internal_id = omsg.PatientIdentification.InternalPatientID.Item[0].ID.valuestring
end if
ls_external_id = omsg.PatientIdentification.ExternalPatientID.ID.valuestring
ll_count = omsg.PatientIdentification.AlternatePatientID.Count
if ll_count > 0 then
	ls_alternate_PID = omsg.PatientIdentification.AlternatePatientID.Item[0].ID.valuestring
end if
// Patient Name and details
ll_count = omsg.PatientIdentification.PatientName.Count
if ll_count > 0 then
	ls_name_prefix = omsg.PatientIdentification.PatientName.Item(0).Prefix.valuestring
	ls_name_suffix = omsg.PatientIdentification.PatientName.Item(0).Suffix.valuestring
	ls_first_name 	= omsg.PatientIdentification.PatientName.Item(0).GivenName.valuestring
	ls_last_name 	= omsg.PatientIdentification.PatientName.Item(0).FamilyName.valuestring
	ls_middle_name	= omsg.PatientIdentification.PatientName.Item(0).MiddleName.valuestring
else
	log.log(this, "patient_adt()", "Message id "+is_message_id+ " did not have valid PID-PatientName, message rejected ", 4)
	return -1
end if
if not isnull(ls_last_name) and len(ls_last_name) > 0 then
	ls_patient_name = ls_last_name
end if
if not isnull(ls_first_name) and len(ls_first_name) > 0 then
	if len(ls_patient_name) > 0 Then
		ls_patient_name = ls_last_name + ","+ls_first_name
	else
		ls_patient_name = ls_first_name
	end if
end if
if isnull(ls_patient_name) or len(ls_patient_name) = 0 Then
	log.log(this, "patient_adt()", "Message id "+is_message_id+ " did not have valid PID-PatientName, message rejected ", 4)
	return -1
end if
// Gettting Billing Id
if isnull(ls_external_id) or ls_external_id = "" then
	if isnull(ls_internal_id) or ls_internal_id = "" then
		if isnull(ls_alternate_PID) or ls_alternate_PID = "" then
			mylog.log(this, "patient_adt()", "External Patient Id(Billing Id) not provided for ( "+ls_last_name+","+ls_first_name+ " Message (" + string(is_message_id) + ") rejected", 4)
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
IF upper(bs_system) = 'HORIZON' then ls_billing_id = ls_external_id
		
if isnull(ls_billing_id) then
	setnull(ls_cpr_id)
	mylog.log(this, "patient_adt()", "External Patient Id(Billing Id) not provided for ( "+ls_last_name+","+ls_first_name+ " Message (" + string(is_message_id) + ") rejected", 4)
	return -1
end if
// Patient Address Details
ll_count = omsg.PatientIdentification.PatientAddress.Count
if ll_count > 0 then
	ls_addr1 		= omsg.PatientIdentification.PatientAddress.Item(0).StreetAddress.valuestring
	ls_addr2			= omsg.PatientIdentification.PatientAddress.Item(0).OtherDesignation.valuestring
	ls_city 			= omsg.PatientIdentification.PatientAddress.Item(0).City.valuestring
	ls_state 		= omsg.PatientIdentification.PatientAddress.Item(0).StateOrProvince.valuestring
	ls_zip 			= omsg.PatientIdentification.PatientAddress.Item(0).ZipOrPostalCode.valuestring
	ls_country 		= omsg.PatientIdentification.PatientAddress.Item(0).Country.valuestring
end if	

ls_sex			= omsg.PatientIdentification.Sex.valuestring
ls_birthdate	= omsg.PatientIdentification.DOB.valuestring
ls_marital_status = omsg.PatientIdentification.MaritalStatus.valuestring
ls_race			= omsg.PatientIdentification.Race.valuestring
ls_religion 	= omsg.PatientIdentification.Religion.valuestring
ls_ethnic		= omsg.PatientIdentification.EthnicGroup.valuestring

ll_count = omsg.PatientIdentification.HomePhone.Count
if ll_count > 0 then
	ls_phone_number = omsg.PatientIdentification.HomePhone.Item(0).TelephoneNumber.valuestring
end if

ll_count = omsg.PatientIdentification.BusinessPhone.Count
if ll_count > 0 then
	ls_bizphone_number = omsg.PatientIdentification.BusinessPhone.Item(0).TelephoneNumber.valuestring
end if

ls_primary_language = omsg.PatientIdentification.PrimaryLanguage.Text.Valuestring

if asc(ls_primary_language) < 64 or asc(ls_primary_language) > 92 then
	ls_primary_language = ""
end if

if (ls_birthdate = "0" or isnull(ls_birthdate) or ls_birthdate = "") then
	ls_error = ls_birthdate
	log.log(this, "patient_adt()", "Patient "+ls_patient_name+" didnt have valid birthdate (" + ls_error  + ")", 3)
	setnull(ldt_date_of_birth)
	setnull(ld_birthdate)
else	
	fix_date = left(ls_birthdate,4) + ' ' + mid(ls_birthdate,5,2) + ' ' + mid(ls_birthdate,7,2)
	if isdate(fix_date) then
		ld_birthdate = date(fix_date)
		ldt_date_of_birth = datetime(ld_birthdate)
	else
		ls_error = ls_birthdate
		log.log(this, "patient_adt()", "Patient "+ls_patient_name+" didnt have valid birthdate (" + ls_error  + ")", 3)
		setnull(ld_birthdate)
	end if
end if

if len(ls_ssn) > 9 then
	ll_pos = POS(ls_ssn,'-')
	if ll_pos > 0 then
		ls_ssn = left(ls_ssn,ll_pos - 1) + mid(ls_ssn,ll_pos + 1)
		ll_pos = POS(ls_ssn,'-')
		if ll_pos > 0 then
			ls_ssn = left(ls_ssn,ll_pos - 1) + mid(ls_ssn,ll_pos + 1)
		end if
	end if
end if	
if ls_ssn = '000000000' then setnull(ls_ssn)

setnull(ls_secondary_provider_id)
setnull(li_priority)

setnull(ls_primary_provider_id)
setnull(ls_principal_provider)
/* PV1 Patient Visit */
if not isnull(omsg.patientvisit) then
	ls_facility_namespaceid = omsg.patientvisit.AssignedPatientLocation.Facility.NamespaceID.valuestring
	ll_count = omsg.PatientVisit.AttendingDoctor.Count
	if ll_count > 0 then
		ls_principal_provider = omsg.PatientVisit.AttendingDoctor.Item[0].IDNumber.valuestring
		ls_principal_provider_firstname = omsg.PatientVisit.AttendingDoctor.Item[0].Familyname.valuestring
		ls_principal_provider_lastname = omsg.PatientVisit.AttendingDoctor.Item[0].Givenname.valuestring
	end if
	ll_count = omsg.PatientVisit.ReferringDoctor.Count
	if ll_count > 0 then
		ls_referring_provider_id = omsg.PatientVisit.ReferringDoctor.Item[0].IDNumber.valuestring
		ls_referring_provider_lastname = omsg.PatientVisit.ReferringDoctor.Item[0].FamilyName.valuestring
		ls_referring_provider_firstname = omsg.PatientVisit.ReferringDoctor.Item[0].GivenName.valuestring
	end if
end if	
ll_count = omsg.additionaldemographics.patientprimarycareprovidernameandidnumber.count
If ll_count > 0 then
	ls_pcp = omsg.additionaldemographics.patientprimarycareprovidernameandidnumber[0].idnumber.valuestring
	ls_pcp_lastname = omsg.additionaldemographics.patientprimarycareprovidernameandidnumber[0].familyname.valuestring
	ls_pcp_firstname = omsg.additionaldemographics.patientprimarycareprovidernameandidnumber[0].givenname.valuestring
End If
// Patient Guarantor Detail
ll_count = omsg.Guarantor.Count
if ll_count > 0 then
	ll_count = omsg.Guarantor[0].guarantornumber.count
	if ll_count > 0 then
		mylog.log(this, "arrived()", "Guarantor number is not provided and so ignore this..", 1)
	else
	//	ls_gnumber = omsg.guarantor[0].guarantornumber[0].id.valuestring
		ll_count = omsg.Guarantor[0].guarantorname.count
		if ll_count = 0 then
			mylog.log(this, "arrived()", "Guarantor name is not provided and so ignore this..", 1)
		else
			ls_glname = omsg.guarantor[0].guarantorname[0].familyname.valuestring
			ls_gfname = omsg.guarantor[0].guarantorname[0].givenname.valuestring
			ls_gmname = omsg.guarantor[0].guarantorname[0].middlename.valuestring
	
			ll_count = omsg.Guarantor[0].guarantoraddress.count
			if ll_count > 0 then
				ls_gaddr1 = omsg.guarantor[0].guarantoraddress[0].streetaddress.valuestring
				ls_gcity = omsg.guarantor[0].guarantoraddress[0].city.valuestring
				ls_gstate = omsg.guarantor[0].guarantoraddress[0].stateorprovince.valuestring
				ls_gzip = omsg.guarantor[0].guarantoraddress[0].ziporpostalcode.valuestring
			end if
			ll_count = omsg.Guarantor[0].guarantorphnumhome.count
			if ll_count > 0 then
				ls_gphone = omsg.Guarantor[0].guarantorphnumhome[0].telephonenumber.valuestring
			end if
			ll_count = omsg.Guarantor[0].guarantorphnumbusiness.count
			if ll_count > 0 then
				ls_gbphone = omsg.Guarantor[0].guarantorphnumbusiness[0].telephonenumber.valuestring
			end if
			ls_grelation = omsg.Guarantor[0].guarantorrelationship.valuestring
			ls_gssn = omsg.Guarantor[0].guarantorssn.valuestring
		end if
	end if
end if

// Get the principal provider for the patient
setnull(ls_primary_provider_id)
if not isnull(ls_principal_provider) and len(ls_principal_provider) > 0 then
	
	// Translate Provider
	ls_epro_doctorid = sqlca.fn_lookup_user(message_office_id,ls_principal_provider)
	if isnull(ls_epro_doctorid) or len(ls_epro_doctorid)=0 then ls_epro_doctorid = ls_principal_provider

	SELECT user_id
	INTO :ls_primary_provider_id
	FROM c_User
	WHERE billing_id = :ls_epro_doctorid
	AND user_status = 'OK'
	USING cprdb;
	if not cprdb.check() then return -1
	if isnull(ls_primary_provider_id) then 
		ls_temp = "Primary Provider ( "+ls_principal_provider_lastname+","+ls_principal_provider_firstname+"="+ls_principal_provider+" ) is not mapped in epro"
		log.log(this, "patient()",ls_temp, 3)
	end if		
elseif not isnull(ls_pcp) and len(ls_pcp) > 0 then

	// Translate Provider
	ls_epro_doctorid = sqlca.fn_lookup_user(message_office_id,ls_pcp)
	if isnull(ls_epro_doctorid) or len(ls_epro_doctorid)=0 then ls_epro_doctorid = ls_pcp

	SELECT user_id
	INTO :ls_primary_provider_id
	FROM c_User
	WHERE billing_id = :ls_epro_doctorid
	AND user_status = 'OK'
	USING cprdb;
	if not cprdb.check() then return -1
	if isnull(ls_primary_provider_id) then 
		ls_temp = "Primary Care Provider ( "+ls_pcp_lastname+","+ls_pcp_firstname+"="+ls_pcp+" ) is not mapped in epro"
		log.log(this, "patient()",ls_temp, 3)
	end if		
	
end if

// get referring doctor
Select description
into :ls_ref_name
from c_Consultant 
where consultant_id = :ls_referring_provider_id
USING cprdb;

if not cprdb.check() then return -1

ls_name = ls_referring_provider_firstname+','+ls_referring_provider_lastname
if isnull(ls_ref_name) or len(ls_ref_name) = 0 then // no referring provider then add it
	ls_consultant_id = ls_referring_provider_id
	insert into c_consultant
	(
	consultant_id,
	description,
	first_name,
	last_name,
	specialty_id
	)
	values(:ls_consultant_id,:ls_name,:ls_referring_provider_firstname,:ls_referring_provider_lastname,'$')
	using sqlca;
	
	ls_referring_provider_id = ls_consultant_id
else
	update c_consultant
	set description = :ls_name,
	first_name = :ls_referring_provider_firstname,
	last_name = :ls_referring_provider_lastname
	where consultant_id = :ls_referring_provider_id
	using sqlca;
end if

// Patient Lookup
ls_cpr_id = sqlca.fn_lookup_patient(billing_id_domain,ls_billing_id)
if ls_cpr_id = "" then setnull(ls_cpr_id)

if not isnull(ls_cpr_id) then
	SELECT patient_status
		INTO :ls_patient_status
	FROM p_Patient
	WHERE cpr_id = :ls_cpr_id
	USING cprdb;
	if not cprdb.check() then return -1
	
	if upper(ls_patient_status) <> 'ACTIVE' then
		comments = "Error:Patient account#  "+ls_billing_id+" is "+ls_patient_status
		return -1
	end if
end if

mylog.log(this, "patient_adt()", "patient info=" + ls_billing_id + " " + ls_last_name + "," + ls_first_name, 1)
ls_sex = upper(left(ls_sex,1))
ls_marital_status = upper(left(ls_marital_status,1))
ls_race = left(ls_race,24)
ls_name_prefix = left(ls_name_prefix,12)
ls_first_name = left(ls_first_name,20)
ls_middle_name = left(ls_middle_name,20)
ls_last_name= left(ls_last_name,40)
ls_name_suffix = left(ls_name_suffix,12)
ls_primary_provider_id = left(ls_primary_provider_id,24)
ls_primary_language = left(ls_primary_language,12)
ls_phone_number = left(ls_phone_number,32)
ls_ssn = left(ls_ssn,24)
ls_addr1 = left(ls_addr1,40)
ls_addr2 = left(ls_addr2,40)
ls_city = left(ls_city,40)
ls_state = left(ls_state,2)
ls_zip = left(ls_zip,10)
ls_country = left(ls_country,2)
ls_bizphone_number = left(ls_bizphone_number,16)
ls_religion = left(ls_religion,12)
ls_referring_provider_id = left(ls_referring_provider_id,24)

if isnull(billing_id_prefix) then
	ls_epro_billing_id = ls_billing_id
else
	ls_epro_billing_id = billing_id_prefix + ls_billing_id
end if

IF isnull(ls_cpr_id) THEN

	li_sts = f_create_new_patient( &
									ls_cpr_id,   &
									ls_race,   &
									date(ldt_date_of_birth),   &
									ls_sex,   &
									ls_phone_number, &
									ls_primary_language,   &
									ls_marital_status,   &
									ls_epro_billing_id,   &
									ll_null,   &
									ls_first_name,   &
									ls_last_name,   &
									ls_degree,   &
									ls_name_prefix,   &
									ls_middle_name,   &
									ls_name_suffix,   &
									ls_primary_provider_id, &
									ls_secondary_provider_id, &
									li_priority, &
									ls_ssn)
	if li_sts <= 0 then 
		mylog.log(this, "patient_adt()","create failed",4)
		li_rtn = -4
		Return li_rtn
	end if
	lb_new_patient = true
	// add patient progress
	sqlca.sp_Set_Patient_Progress(ls_cpr_id,ll_null,ll_null,"ID",billing_id_domain,ls_billing_id, ldt_null,ll_null,ll_null,current_user.user_id,current_user.user_id)	
end if

SELECT p_Patient.race,   
       p_Patient.date_of_birth,   
       p_Patient.sex,   
       p_Patient.primary_language,   
       p_Patient.marital_status,   
       p_Patient.billing_id,   
       p_Patient.first_name,   
       p_Patient.last_name,   
       p_Patient.degree,   
       p_Patient.name_prefix,   
       p_Patient.middle_name,   
       p_Patient.name_suffix,   
       p_Patient.primary_provider_id,   
       p_Patient.secondary_provider_id,   
       p_Patient.phone_number,   
		p_patient.ssn,
		p_patient.address_line_1,
		p_patient.address_line_2,
		p_patient.state,
		p_patient.zip,
		p_patient.secondary_phone_number,
		p_patient.religion,
		p_patient.referring_provider_id
INTO :old_race:li_null[1],   
     :old_date_of_birth:li_null[2],   
     :old_sex:li_null[3],   
     :old_primary_language:li_null[4], 
		:old_marital_Status:li_null[5],
      :old_billing_Id:li_null[6],   
      :old_first_name:li_null[7],   
      :old_last_name:li_null[8],   
      :old_degree:li_null[9],   
      :old_name_prefix:li_null[10],   
      :old_middle_name:li_null[11],   
      :old_name_suffix:li_null[12],   
      :old_primary_provider_id:li_null[13],   
      :old_secondary_provider_id:li_null[14],   
      :old_phone_number:li_null[15],   
      :ls_old_ssn:li_null[17],
		:old_addr1:li_null[18],
		:old_city:li_null[19],
		:old_state:li_null[20],
		:old_zip:li_null[21],
		:old_bizphone_number:li_null[22],
		:old_religion:li_null[23],
		:old_referring_id:li_null[25]
FROM p_Patient  
WHERE p_Patient.cpr_id = :ls_cpr_id 
and patient_status = 'ACTIVE'
using cprdb  ;

// don't override these fields even if the PM sends blank
if isnull(ls_referring_provider_id) or len(ls_referring_provider_id)=0 then ls_referring_provider_id = old_referring_id
if isnull(ls_sex) or len(ls_sex)=0 then ls_sex = old_sex
if isnull(ls_race) or len(ls_race)=0 then ls_race = old_race
if isnull(ls_marital_status) or len(ls_marital_status)=0 then ls_marital_status = old_marital_status
if isnull(ls_phone_number) or len(ls_phone_number)=0 then ls_phone_number = old_phone_number
if ls_old_ssn = '000000000' then setnull(ls_old_ssn)
if isnull(ls_ssn) or len(ls_ssn)=0 then ls_ssn = ls_old_ssn

//
if isnull(ldt_date_of_birth) then ldt_Date_of_birth = old_date_of_birth
if isnull(ls_primary_language) then ls_primary_language = old_primary_language
if isnull(ls_name_prefix) then ls_name_prefix = old_name_prefix
if isnull(ls_first_name) then ls_first_name = old_first_name
if isnull(ls_last_name) then ls_last_name = old_last_name
if isnull(ls_name_suffix) then ls_name_suffix = old_name_suffix
if isnull(ls_primary_provider_id) or len(ls_primary_provider_id) = 0 then ls_primary_provider_id = old_primary_provider_id

UPDATE p_Patient
SET	name_prefix = 	:ls_name_prefix,
		first_name = :ls_first_name,
		last_name = :ls_last_name,
		date_of_birth = :ldt_date_of_birth,
		middle_name = 	:ls_middle_name,
		name_suffix = 	:ls_name_suffix,
		sex = 			:ls_sex,
		marital_status = :ls_marital_status,
		race = :ls_race,
		primary_language = :ls_primary_language,
		phone_number = :ls_phone_number,
		ssn = :ls_ssn,
		address_line_1 = :ls_addr1,
		address_line_2 = :ls_addr2,
		city = :ls_city,
		state = :ls_state,
		zip = :ls_zip,
		country = :ls_country,
		secondary_phone_number = :ls_bizphone_number,
		religion = :ls_religion,
		referring_provider_id = :ls_referring_provider_id
WHERE cpr_id = :ls_cpr_id
and patient_status = 'ACTIVE'
USING cprdb;

If not cprdb.check() then 
	mylog.log(this, "patient_adt()","update failed " + string(cprdb.sqlcode) + " " + cprdb.sqlerrtext,4)
	return -1
End If

is_cpr_id = ls_cpr_id
is_billing_id = ls_billing_id
If lb_new_patient OR is_msgevent <> 'A01' then // if it's not a check in message then update the pcp
	
	// for multi domain offices just use the message office id as patient registered
	// as well check in location. for multi-domains we assume they have got one to one
	// relations
	if billing_id_domain <> "JMJBILLINGID" then
		ls_office = message_office_id
	else		
		SELECT min(office_id)
		INTO :ls_office
		FROM c_Office
		WHERE billing_id = :ls_facility_namespaceid
		Using Sqlca;
	end if
	UPDATE p_patient
	Set primary_provider_id = :ls_primary_provider_id,
		office_id = :ls_office
	Where cpr_id = :ls_cpr_id
	and patient_status = 'ACTIVE'
	Using sqlca;
End if

if not isnull(ls_gnumber) and len(ls_gnumber) > 0 then
	// Update Guarantor Info.
	Select min(pm_guarantor_id)
		Into :ls_pm_gid
	From p_patient_guarantor
	Where cpr_id = :ls_cpr_id
		and pm_guarantor_id = :ls_gnumber
	using sqlca;
	if isnull(ls_pm_gid) then // no guarantor then create
		insert into p_patient_guarantor
		(
		cpr_id,
		pm_guarantor_id,
		guarantor_last_name,
		guarantor_first_name,
		guarantor_middle_name,
		guarantor_phone_number,
		guarantor_phone_number_alt,
		guarantor_relationship,
		guarantor_ssn,
		guarantor_address_line_1,
		guarantor_city,
		guarantor_state,
		guarantor_zip
		)
		values
		(
		:ls_cpr_id,
		:ls_gnumber,
		:ls_gfname,
		:ls_glname,
		:ls_gmname,
		:ls_gphone,
		:ls_gbphone,
		:ls_grelation,
		:ls_gssn,
		:ls_gaddr1,
		:ls_gcity,
		:ls_gstate,
		:ls_gzip
		)
		using sqlca;
	else
	end if
end if
// Update Referring Provider Info
Return 1
end function

public function integer patient_siu (oleobject omsg);date	ld_birthdate		
datetime ldt_date_of_birth, old_date_of_birth,ldt_null
string ls_epro_doctorid,ls_epro_billing_id
string ls_patient_status
string ls_race, old_race
string ls_sex, old_sex
string ls_phone_number, old_phone_number
string ls_bizphone_number, old_bizphone_number
string ls_primary_language, old_primary_language
string ls_marital_status, old_marital_status,old_addr2
string ls_billing_id, old_billing_id, ls_fix_billing_id
string ls_first_name, old_first_name
string ls_last_name, old_last_name,ls_temp,ls_patient_name
string ls_degree, old_degree
string ls_name_prefix, old_name_prefix
string ls_middle_name, old_middle_name
string ls_name_suffix, old_name_suffix
string ls_primary_provider_id, old_primary_provider_id
string ls_secondary_provider_id, old_secondary_provider_id,ls_country 
string ls_error
string fix_date
string ls_account_number
string ls_ssn, ls_old_ssn
string ls_alternate_PID
string ls_DoctorId
string ls_cpr_id
string ls_birthdate
string ls_attending_doctor,ls_attending_doctor_firstname,ls_attending_doctor_lastname
string ls_patient_id
string ls_internal_id
string ls_external_id
string ls_facility_namespaceid
string ls_office,ls_facility
string ls_addr1, ls_city, ls_state, ls_zip, ls_countr,ls_addr2
string old_addr1, old_city, old_state, old_zip, old_country
string ls_religion,old_religion
string ls_ethnic,old_ethnic
string ls_referring, ls_referring_id, old_referring_id
int li_null[],i,j
integer li_sts, li_rtn
integer li_priority
long ll_DoctorId,ll_len,ll_pos
long ll_patient_id, old_patient_id, ll_facility
long ll_null
boolean lb_new_patient, lb_loop

li_rtn = 1
setnull(ls_internal_id)
setnull(ls_external_id)
setnull(ls_account_number)
setnull(ldt_null)
setnull(ls_ssn)
setnull(ll_null)
long ll_count

//check for facility	
ll_count = omsg.AppointmentInformationGroup.Count
if ll_count = 2 then
	ll_count = omsg.AppointmentInformationGroup.Item[1].AppointmentInformationLocationResource.Count
	if ll_count > 0 then
		ls_facility_namespaceid = omsg.AppointmentInformationGroup.Item[1].AppointmentInformationLocationResource.Item[0].AppointmentInformationLocationResource.LocationResourceID.PointOfCare.valuestring
	end if
end if
setnull(ls_external_id)
setnull(ls_alternate_PID)
ll_count = omsg.PatientIdentificationGroup.Count
if ll_count > 0 then
	ls_account_number = omsg.PatientIdentificationGroup.Item[0].PatientIdentification.PatientAccountNumber.ID.valuestring
	ls_ssn = omsg.PatientIdentificationGroup.Item[0].PatientIdentification.PatientSSN.valuestring
	ls_external_id = omsg.PatientIdentificationGroup.Item[0].PatientIdentification.ExternalPatientID.ID.valuestring
	ll_count = omsg.PatientIdentificationGroup.Item[0].PatientIdentification.InternalPatientID.Count
	if ll_count > 0 then
		ls_internal_id = omsg.PatientIdentificationGroup.Item[0].PatientIdentification.InternalPatientID.Item[0].ID.valuestring
	else
		mylog.log(this, "patient_siu()", "patient internal id not provided, Message ID (" + string(is_message_id) + ")", 3)
		li_rtn = -1
	end if	
else
	mylog.log(this, "patient_siu()", "PatientIdentification Segment not filled in.. Can't process this message id (" + string(is_message_id) + ")", 4)
	return -1
end if	


if isnull(ls_external_id) or ls_external_id = "" then
	if isnull(ls_internal_id) or ls_internal_id = "" then
		if isnull(ls_alternate_PID) or ls_alternate_PID = "" then
			mylog.log(this, "patient_siu()", "id not provided, Message ID (" + string(is_message_id) + ")", 4)
			setnull(ls_billing_id)
		else
			ls_billing_id = ls_alternate_PID
		end if	
	else
		ls_billing_id = ls_internal_id
	end if	
else
	ls_billing_id = ls_external_id
end if
if isnull(ls_billing_id) then
	setnull(ls_cpr_id)
	mylog.log(this, "patient_siu()","null billing_id",4)
	return -1
end if

ll_count = omsg.PatientIdentificationGroup.Item[0].PatientIdentification.PatientName.Count
if ll_count > 0 then
	ls_name_prefix = omsg.PatientIdentificationGroup.Item[0].PatientIdentification.PatientName.Item(0).Prefix.valuestring
	ls_name_suffix = omsg.PatientIdentificationGroup.Item[0].PatientIdentification.PatientName.Item(0).Suffix.valuestring
	ls_first_name 	= omsg.PatientIdentificationGroup.Item[0].PatientIdentification.PatientName.Item(0).GivenName.valuestring
	ls_last_name 	= omsg.PatientIdentificationGroup.Item[0].PatientIdentification.PatientName.Item(0).FamilyName.valuestring
	ls_middle_name	= omsg.PatientIdentificationGroup.Item[0].PatientIdentification.PatientName.Item(0).MiddleName.valuestring
else
	log.log(this, "patient_siu()", "No PID PatientName " + string(ll_count), 3)
	Return -1
end if

ls_sex			= omsg.PatientIdentificationGroup.Item[0].PatientIdentification.Sex.valuestring
ls_birthdate	= omsg.PatientIdentificationGroup.Item[0].PatientIdentification.DOB.valuestring
ls_marital_status = omsg.PatientIdentificationGroup.Item[0].PatientIdentification.MaritalStatus.valuestring
ls_race			= omsg.PatientIdentificationGroup.Item[0].PatientIdentification.Race.valuestring

ll_count = omsg.PatientIdentificationGroup.Item[0].PatientIdentification.HomePhone.Count
if ll_count > 0 then
	ls_phone_number = omsg.PatientIdentificationGroup.Item[0].PatientIdentification.HomePhone.Item(0).TelephoneNumber.valuestring
end if

// Patient Address Details
ll_count = omsg.PatientIdentificationGroup.Item[0].PatientIdentification.PatientAddress.Count
if ll_count > 0 then
	ls_addr1 		= omsg.PatientIdentificationGroup.Item[0].PatientIdentification.PatientAddress.Item(0).StreetAddress.valuestring
	ls_addr2			= omsg.PatientIdentificationGroup.Item[0].PatientIdentification.PatientAddress.Item(0).OtherDesignation.valuestring
	ls_city 			= omsg.PatientIdentificationGroup.Item[0].PatientIdentification.PatientAddress.Item(0).City.valuestring
	ls_state 		= omsg.PatientIdentificationGroup.Item[0].PatientIdentification.PatientAddress.Item(0).StateOrProvince.valuestring
	ls_zip 			= omsg.PatientIdentificationGroup.Item[0].PatientIdentification.PatientAddress.Item(0).ZipOrPostalCode.valuestring
	ls_country 		= omsg.PatientIdentificationGroup.Item[0].PatientIdentification.PatientAddress.Item(0).Country.valuestring
end if	

if (ls_birthdate = "0" or isnull(ls_birthdate) or ls_birthdate = "") then
	ls_error = ls_birthdate
	log.log(this, "patient_siu()", "birthdate error=" + ls_error  + ")", 3)
	setnull(ldt_date_of_birth)
	setnull(ld_birthdate)
else	
	fix_date = left(ls_birthdate,4) + ' ' + mid(ls_birthdate,5,2) + ' ' + mid(ls_birthdate,7,2)
	if isdate(fix_date) then
		ld_birthdate = date(fix_date)
		ldt_date_of_birth = datetime(ld_birthdate)
	else
		ls_error = ls_birthdate
		mylog.log(this, "patient_siu()", "birthdate error=" + ls_error + ")", 3)
		setnull(ld_birthdate)
	end if
end if

if len(ls_ssn) > 9 then
	ll_pos = POS(ls_ssn,'-')
	if ll_pos > 0 then
		ls_ssn = left(ls_ssn,ll_pos - 1) + mid(ls_ssn,ll_pos + 1)
		ll_pos = POS(ls_ssn,'-')
		if ll_pos > 0 then
			ls_ssn = left(ls_ssn,ll_pos - 1) + mid(ls_ssn,ll_pos + 1)
		end if
	end if
end if	
if ls_ssn = '000000000' then setnull(ls_ssn)
If IsNumber(ls_ssn) then
	ll_patient_id	= Long(ls_ssn)
elseIf IsNumber(ls_account_number) then
	ll_patient_id	= Long(ls_account_number)
elseIf IsNumber(ls_billing_id) then
	ll_patient_id	= Long(ls_billing_id)
else
	setnull(ll_patient_id)
end if

setnull(ls_degree)
setnull(ls_secondary_provider_id)
setnull(li_priority)

setnull(ll_doctorid)
setnull(ls_doctorid)
setnull(ls_primary_provider_id)
setnull(ls_attending_doctor)

if not isnull(omsg.PatientIdentificationGroup.Item[0].patientvisit) then
	ll_count = omsg.PatientIdentificationGroup.Item[0].PatientVisit.AttendingDoctor.Count
	if ll_count > 0 then
		ls_attending_doctor = omsg.PatientIdentificationGroup.Item[0].PatientVisit.AttendingDoctor.Item[0].IDNumber.valuestring
		ls_attending_doctor_firstname = omsg.PatientIdentificationGroup.Item[0].PatientVisit.AttendingDoctor.Item[0].Familyname.valuestring
		ls_attending_doctor_lastname = omsg.PatientIdentificationGroup.Item[0].PatientVisit.AttendingDoctor.Item[0].Givenname.valuestring
	end if
end if	

// get the primary provider for the patient
if not isnull(ls_attending_doctor) and len(ls_attending_doctor) > 0 then

	// Translate Provider
	ls_epro_doctorid = sqlca.fn_lookup_user(message_office_id,ls_attending_doctor)
	if isnull(ls_epro_doctorid) or len(ls_epro_doctorid)=0 then ls_epro_doctorid = ls_attending_doctor

	SELECT user_id
	INTO :ls_primary_provider_id
	FROM c_User
	WHERE billing_id = :ls_epro_doctorid
	AND user_status = 'OK'
	USING cprdb;
	if not cprdb.check() then return -1
	if isnull(ls_primary_provider_id) or len(ls_primary_provider_id) = 0 then 
		ls_temp = "Attending doctor code ( "+ls_attending_doctor_lastname+","+ls_attending_doctor_firstname+"="+ls_attending_doctor+" ) is not mapped in epro"
		log.log(this, "patient()",ls_temp, 3)
	end if
	
end if

// Patient Lookup
ls_cpr_id = sqlca.fn_lookup_patient(billing_id_domain,ls_billing_id)
if ls_cpr_id = "" then setnull(ls_cpr_id)

if not isnull(ls_cpr_id) then
	SELECT patient_status
		INTO :ls_patient_status
	FROM p_Patient
	WHERE cpr_id = :ls_cpr_id
	USING cprdb;
	if not cprdb.check() then return -1
	
	if upper(ls_patient_status) <> 'ACTIVE' then
		comments = "Error:Patient account#  "+ls_billing_id+" is "+ls_patient_status
		return -1
	end if
end if


mylog.log(this, "patient_siu()", "patient info=" + ls_billing_id + " " + ls_last_name + "," + ls_first_name, 2)

ls_sex = upper(left(ls_sex,1))
ls_marital_status = upper(left(ls_marital_status,1))
ls_race = left(ls_race,24)
ls_name_prefix = left(ls_name_prefix,12)
ls_first_name = left(ls_first_name,20)
ls_middle_name = left(ls_middle_name,20)
ls_last_name= left(ls_last_name,40)
ls_name_suffix = left(ls_name_suffix,12)
ls_primary_provider_id = left(ls_primary_provider_id,24)
ls_primary_language = left(ls_primary_language,12)
ls_phone_number = left(ls_phone_number,32)
ls_ssn = left(ls_ssn,24)
ls_addr1 = left(ls_addr1,40)
ls_addr2 = left(ls_addr2,40)
ls_city = left(ls_city,40)
ls_state = left(ls_state,2)
ls_zip = left(ls_zip,10)
ls_country = left(ls_country,2)
ls_bizphone_number = left(ls_bizphone_number,16)
ls_religion = left(ls_religion,12)
ls_referring_id = left(ls_referring_id,24)

if isnull(billing_id_prefix) then
	ls_epro_billing_id = ls_billing_id
else
	ls_epro_billing_id = billing_id_prefix + ls_billing_id
end if

if isnull(ls_cpr_id) then
	li_sts = f_create_new_patient( &
									ls_cpr_id,   &
									ls_race,   &
									date(ldt_date_of_birth),   &
									ls_sex,   &
									ls_phone_number, &
									ls_primary_language,   &
									ls_marital_status,   &
									ls_epro_billing_id,   &
									ll_null,   &
									ls_first_name,   &
									ls_last_name,   &
									ls_degree,   &
									ls_name_prefix,   &
									ls_middle_name,   &
									ls_name_suffix,   &
									ls_primary_provider_id, &
									ls_secondary_provider_id, &
									li_priority, &
									ls_ssn)
	if li_sts <= 0 then 
		mylog.log(this, "patient_siu()","create failed",4)
		li_rtn = -4
	else
		lb_new_patient = true
		// add patient progress
		sqlca.sp_Set_Patient_Progress(ls_cpr_id,ll_null,ll_null,"ID",billing_id_domain,ls_billing_id, ldt_null,ll_null,ll_null,current_user.user_id,current_user.user_id)	
	end if	
end if

SELECT p_Patient.race,   
       p_Patient.date_of_birth,   
       p_Patient.sex,   
       p_Patient.primary_language,   
       p_Patient.marital_status,   
       p_Patient.billing_id,   
       p_Patient.first_name,   
       p_Patient.last_name,   
       p_Patient.degree,   
       p_Patient.name_prefix,   
       p_Patient.middle_name,   
       p_Patient.name_suffix,   
       p_Patient.primary_provider_id,   
       p_Patient.secondary_provider_id,   
       p_Patient.phone_number,   
       p_Patient.patient_id,
		p_patient.ssn,
		p_patient.address_line_1,
		p_patient.address_line_2,
		p_patient.city,
		p_patient.state,
		p_patient.zip,
		p_patient.secondary_phone_number,
		p_patient.religion,
		p_patient.referring_provider_id
INTO :old_race,   
     :old_date_of_birth,   
     :old_sex,   
     :old_primary_language, 
		:old_marital_Status,
      :old_billing_Id,   
      :old_first_name,   
      :old_last_name,   
      :old_degree,   
      :old_name_prefix,   
      :old_middle_name,   
      :old_name_suffix,   
      :old_primary_provider_id,   
      :old_secondary_provider_id,   
      :old_phone_number,   
      :old_patient_id,
      :ls_old_ssn,
		:old_addr1,
		:old_addr2,
		:old_city,
		:old_state,
		:old_zip,
		:old_bizphone_number,
		:old_religion,
		:old_referring_id
FROM p_Patient  
WHERE p_Patient.cpr_id = :ls_cpr_id
and patient_status = 'ACTIVE'
using cprdb  ;

// don't override these fields even if the PM sends blank
if isnull(ls_referring_id) or len(ls_referring_id)=0 then ls_referring_id = old_referring_id
if isnull(ls_sex) or len(ls_sex)=0 then ls_sex = old_sex
if isnull(ls_race) or len(ls_race)=0 then ls_race = old_race
if isnull(ls_marital_status) or len(ls_marital_status)=0 then ls_marital_status = old_marital_status
if isnull(ls_phone_number) or len(ls_phone_number)=0 then ls_phone_number = old_phone_number
if ls_old_ssn = '000000000' then setnull(ls_old_ssn)
if isnull(ls_ssn) or len(ls_ssn)=0 then ls_ssn = ls_old_ssn

//
if isnull(ls_primary_provider_id) then ls_primary_provider_id = old_primary_provider_id
if isnull(ldt_date_of_birth) then ldt_Date_of_birth = old_date_of_birth
if isnull(ls_primary_language) then ls_primary_language = old_primary_language
if isnull(ls_name_prefix) then ls_name_prefix = old_name_prefix
if isnull(ls_first_name) then ls_first_name = old_first_name
if isnull(ls_last_name) then ls_last_name = old_last_name
if isnull(ls_name_suffix) then ls_name_suffix = old_name_suffix
if isnull(ls_primary_provider_id) or len(ls_primary_provider_id) = 0 then ls_primary_provider_id = old_primary_provider_id
if isnull(ll_patient_id) then ll_patient_id = old_patient_id
if isnull(ls_city) or len(ls_city)=0 then ls_city = old_city
if isnull(ls_addr1) or len(ls_addr1)=0 then ls_addr1 = old_addr1
if isnull(ls_addr2) or len(ls_addr2)=0 then ls_addr2 = old_addr2
if isnull(ls_state) or len(ls_state)=0 then ls_state=old_state
if isnull(ls_zip) or len(ls_zip)=0 then ls_zip = old_zip
if isnull(ls_bizphone_number) or len(ls_bizphone_number)=0  then ls_bizphone_number=old_bizphone_number

UPDATE p_Patient
SET	name_prefix = 	:ls_name_prefix,
		first_name = :ls_first_name,
		last_name = :ls_last_name,
		date_of_birth = :ldt_date_of_birth,
		middle_name = 	:ls_middle_name,
		name_suffix = 	:ls_name_suffix,
		sex = 			:ls_sex,
		marital_status = :ls_marital_status,
		race = :ls_race,
		primary_language = :ls_primary_language,
		phone_number = :ls_phone_number,
		patient_id =   :ll_patient_id,
		ssn = :ls_ssn,
		address_line_1 = :ls_addr1,
		address_line_2 = :ls_addr2,
		city = :ls_city,
		state = :ls_state,
		zip = :ls_zip,
		country = :ls_country,
		secondary_phone_number = :ls_bizphone_number,
		religion = :ls_religion
WHERE cpr_id = :ls_cpr_id
and patient_status = 'ACTIVE'
USING cprdb;
If not cprdb.check() then 
	mylog.log(this, "patient_adt()","update failed " + string(cprdb.sqlcode) + " " + cprdb.sqlerrtext,4)
	return -1
End If

is_cpr_id = ls_cpr_id
is_billing_id = ls_billing_id
if lb_new_patient then
	if billing_id_domain <> "JMJBILLINGID" then
		ls_office = message_office_id
	else
		SELECT min(office_id)
		INTO :ls_office
		FROM c_Office
		WHERE billing_id = :ls_facility_namespaceid
		Using Sqlca;
	end if
	
	UPDATE p_patient
		Set primary_provider_id = :ls_primary_provider_id,
			office_id = :ls_office
	Where cpr_id = :ls_cpr_id
	and patient_status = 'ACTIVE'
	Using sqlca;
end if

Return 1
end function

public function string get_consultant_id (string ps_description);String ls_consultant_id,ls_description
String ls_find,ls_temp,ls_char
Integer i
Long   ll_row
long ll_count
string ls_null

setnull(ls_null)

ls_description = ps_description

ls_consultant_id = upper(trim(ls_description))
if len(ls_consultant_id) > 24 then ls_consultant_id = left(ls_consultant_id, 24)
for i = 1 to len(ls_consultant_id)
	ls_char = mid(ls_consultant_id, i, 1)
	if ls_char < "A" or ls_char > "Z" then ls_consultant_id = replace(ls_consultant_id, i, 1, "_")
next

for i = 1 to 100
	SELECT count(*)
	INTO :ll_count
	FROM c_Consultant
	WHERE consultant_id = :ls_consultant_id;
	if not tf_check() then return ls_null
	if ll_count = 0 then return ls_consultant_id
	
	ls_temp = string(i)
	ls_consultant_id = left(ls_consultant_id, len(ls_consultant_id) - len(ls_temp)) + ls_temp
next

Return ls_null
end function

on u_component_incoming_filecopy_hl7.create
call super::create
end on

on u_component_incoming_filecopy_hl7.destroy
call super::destroy
end on

