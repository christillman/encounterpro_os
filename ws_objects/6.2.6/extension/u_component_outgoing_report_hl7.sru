HA$PBExportHeader$u_component_outgoing_report_hl7.sru
forward
global type u_component_outgoing_report_hl7 from u_component_outgoing
end type
end forward

global type u_component_outgoing_report_hl7 from u_component_outgoing
end type
global u_component_outgoing_report_hl7 u_component_outgoing_report_hl7

type variables
String	source_app,destination_app
String	sending_app,obx_id
String	send_text,msg_type
string 	recv_app_path
boolean  ib_sync
int		il_retry_limit
string TextEncoding

oleobject oAHC, oMsgMan

end variables

forward prototypes
public function integer ahc_connect ()
public function integer ahc_disconnect ()
protected function integer xx_initialize ()
protected function integer xx_shutdown ()
protected function integer xx_send_file (string ps_filename, string ps_address)
public function integer sendreport (string ps_text)
public function integer timer_ding ()
public function integer lcr_report (string ps_text)
end prototypes

public function integer ahc_connect ();INTEGER li_sts

mylog.log(this, "ahc_connect()", "ahc_connect() - Begin", 1)

mylog.log(this, "ahc_connect()", "connecting to AHCMessager.", 1)
oAHC = CREATE oleobject
li_sts = oAHC.connecttonewobject("AHC.Messenger")
if li_sts <> 0 then
	mylog.log(this, "ahc_connect", "ERROR: connection to AHC Messenger object failed.", 4)
	DESTROY oAHC
	setnull(oAHC)
	return -1
end if
mylog.log(this, "ahc_connect()", "connection to AHCMessager success", 1)

// Connect to AHC Messanger and returns AHC Message Manager
mylog.log(this, "ahc_connect()", "connection to IHCMessageManager object.", 1)
omsgman = oAHC.Connect(source_app)
If isnull(omsgman) Then
	mylog.log(this, "ahc_connect()", "ERROR: connection to IHCMessageManager object failed.", 4)
	DESTROY oMsgMan
	oAHC.Disconnect()
	DESTROY oAHC
	setnull(oMsgMan)
	Setnull(oAHC)
	return -1
end if
mylog.log(this, "ahc_connect()", "connection to IHCMessageManager object successful.", 1)

mylog.log(this, "ahc_connect()", "ahc_connect() - Successful", 1)

return 1
end function

public function integer ahc_disconnect ();if not isnull(oAHC) and isvalid(oAHC) Then
	mylog.log(this,"xx_shutdown","disconnecting from AHC Interface",1)
	TRY
		oAHC.Disconnect()
	CATCH (throwable lt_error)
		log.log(this, "chrg_mpm()", "Error disconnecting AHC Messanger:  " + lt_error.text, 4)
	FINALLY
		oahc.disconnectobject()
		Destroy oAHC
		Setnull(oAHC)
	END TRY
	mylog.log(this,"xx_shutdown","disconnected from AHC Interface",1)
End If

if not isnull(omsgman) and isvalid(omsgman) Then
	omsgman.disconnectobject()
	Destroy omsgMan
	Setnull(omsgMan)
end if

Return 1

end function

protected function integer xx_initialize ();integer	li_rtn
string   ls_sync,ls_retry_limit

get_attribute("source_application",source_app)
if isnull(source_app) then
	mylog.log(this, "xx_initialize", "no object source.", 4)
	return -1
end if	

get_attribute("destination_application", destination_app)
if isnull(destination_app) or destination_app = '' then
	mylog.log(this, "xx_initialize", "no object destination.", 4)
	return -1
end if	

get_attribute("receiving_app_path", recv_app_path)
if isnull(recv_app_path) or recv_app_path = '' then
	mylog.log(this, "xx_initialize", "recev app path is not specified", 4)
	return -1
end if	

get_attribute("sync_flag",ls_sync)
ib_sync = false
if isnull(ls_sync) or ls_sync = '' then ib_sync = false
if left(upper(ls_sync),1) = 'T' then ib_sync = true
if left(upper(ls_sync),1) = 'Y' then ib_sync = true

get_attribute("retry_limit",ls_retry_limit)
if isnull(ls_retry_limit) or not isnumber(ls_retry_limit) then 
	il_retry_limit = 1
else
	il_retry_limit = integer(ls_retry_limit)
end if

get_attribute("TextEncoding", TextEncoding)

mylog.log(this,"timer_ding()","connect AHC messagemanager ",1)
li_rtn = ahc_connect()
If li_rtn < 0 then return -1

set_timer()
GarbageCollectSetTimeLimit(0)
GarbageCollect()

Return 1
end function

protected function integer xx_shutdown ();ahc_disconnect()
GarbageCollectSetTimeLimit(0)
GarbageCollect()

Return 1
end function

protected function integer xx_send_file (string ps_filename, string ps_address);integer		li_sts,li_count
long			ll_pos
blob			lblb_message
String		ls_line_break = "~013"
string		ls_interval
long			ll_message_id,ll_tries
datetime		ldt_msg_datetime,ldt_retry_time,ldt_datetime
date			ld_date
time			lt_time

garbagecollect()

if ib_sync then // if synchronized
	select count(*) into :li_count
	from o_message_log
	where status = 'LCR_ACK'
	using cprdb;
	if not cprdb.check() then return -1
	if li_count > 0 then
		SELECT min(message_id)
		INTO :ll_message_id
		FROM o_Message_Log
		WHERE status = 'LCR_ACK'
		using cprdb;
		
		if ll_message_id > 0 and not isnull(ll_message_id) then
			SELECT message_date_time,tries
			INTO :ldt_msg_datetime,
					:ll_tries
			FROM o_Message_Log
			WHERE message_id = :ll_message_id
			using cprdb;
			
			if isnull(ll_tries) then ll_tries = 0
			if il_retry_limit <= ll_tries then // reaches retry limit
				UPDATE o_message_log
				set status = 'ERROR'
				where message_id = :ll_message_id
				using cprdb;
				
				return 1
			end if

			get_attribute("retry_interval",ls_interval)
			get_attribute("retry_interval",ls_interval)
			if isnull(ls_interval) then ls_interval = "120" // 2 minutes
			if Isnumber(ls_interval) then
				ldt_datetime = datetime(today(),now())
				ld_date = date(ldt_msg_datetime)
				lt_time = time(ldt_msg_datetime)
				ldt_retry_time = datetime(ld_date,RelativeTime(lt_time,integer(ls_interval)))
				if ldt_datetime > ldt_retry_time then 
					ll_tries = ll_tries + 1
					Update o_Message_log
					set tries = :ll_tries,
						status = 'STREAMED'
					Where message_id = :ll_message_id
					using cprdb;
					
					Return 1
				else
					return 2
				end if
			end if
		end if
	end if
end if
// Read the file into a local blob
//li_sts = mylog.file_read(ps_filename, lblb_message)
//if li_sts <= 0 then return -1

// Read the file into a local blob
SELECTBLOB message
INTO :lblb_message
FROM o_Message_Log
WHERE message_id = :message_id
USING cprdb;
if not cprdb.check() then return -1
if cprdb.sqlcode = 100 then
	mylog.log(this, "xx_send_file()", "Message log record not found when getting message(" + string(message_id) + ")", 4)
	return -1
end if

send_text = f_blob_to_string(lblb_message)
mylog.log(this, "xx_send_file", "Message Text: "+send_text, 1)	

lcr_report(send_text)

GarbageCollectSetTimeLimit(0)
GarbageCollect()

return 1
end function

public function integer sendreport (string ps_text);String		ls_message,ls_uid
String		ls_report_line
String		ls_line_break = "~013"
String		ls_message_type
String		ls_record
String		ls_sending_facility,ls_sending_app
String		ls_observation_id
String		ls_external_id,ls_first_name,ls_last_name,ls_middle_name
String		ls_internal_id
String		ls_billing_id
String		ls_firstname,ls_lastname,ls_middlename
String		ls_encounter_datetime,ls_report_text
String		ls_cont_pointer,ls_prev_pointer
String		ls_fields[]
integer		li_sts,k,i
long			ll_pos
string		ls_message_uid

OLEOBJECT omsgtype, OEnv, HL7ORU

// create the message type
omsgtype = create oleobject
li_sts = omsgtype.connecttonewobject("AHC.MessageType")
if li_sts <> 0 then
	mylog.log(this, "chrg_mpm()", "ERROR: connection to AHC messagetype object failed.", 4)
	DESTROY omsgtype
	setnull(omsgtype)
	return -1
end if
// fill out the message type with the HL7ORU relevant information
omsgtype.MessageTypeCode = "ORU"
omsgtype.EventCode = ""
omsgtype.Version = "HL7 2.3" 	// MUST be like this!

// create the enevelope object
oEnv = create oleobject
oEnv = omsgman.CreateMessage(omsgtype)
if isnull(oenv) then
	mylog.log(this, "chrg_mpm()", "Error in getting message evnvelope object", 4)	
	return -1
end if

//Declare a message object of the type created in the previous step 
HL7ORU = create oleobject
//get a handle to the message content.
HL7ORU = oEnv.Content
if isnull(hl7oru) then
	mylog.log(this, "chrg_mpm()", "Error in getting message type object from message envelope", 4)	
	return -1
end if

/* extract the individual fields in the message */
k = 1
do while len(ps_text) > 0
	ll_pos = POS(ps_text,ls_line_break)
	if ll_pos > 0 Then
		ls_fields[k] = mid(ps_text,1,ll_pos - 1)
	end if	
	ps_text = Mid(ps_text,ll_pos + 1)
	If ps_text = "" then exit
	k++
loop

If upperbound(ls_fields) < 13 Then
	log.log(this,"sendreport","Send Failed:message id ("+string(message_id)+") message count is invalid ",3)
	
	Update o_message_log
	set status = 'BAD LEN'
	Where message_id = :message_id;
	return -1
End If

SELECT convert(varchar(38),id)
INTO :ls_message_uid
FROM o_Message_Log
WHERE message_id = :message_id;

ls_message_type = ls_fields[1]
ls_sending_app = ls_fields[2]
ls_sending_facility = ls_fields[3]
ls_observation_id = ls_fields[4]
ls_billing_id = ls_fields[5]
ls_internal_id = ls_fields[6]
ls_first_name = ls_fields[7]
ls_last_name = ls_fields[8]
ls_middle_name = ls_fields[9]
ls_encounter_datetime = ls_fields[10]
ls_report_text = ls_fields[11]
ls_prev_pointer = ls_fields[12]
ls_cont_pointer = ls_fields[13]


/* Message Header */
HL7ORU.MessageHeader.ProcessingID.ProcessingID.value = "P"
HL7ORU.MessageHeader.MessageControlID.value = ls_message_uid
HL7ORU.MessageHeader.SendingApplication.NameSpaceID.value = ls_sending_app
HL7ORU.MessageHeader.SendingFacility.NameSpaceID.value = ls_sending_facility
if ls_prev_pointer <> "" then
	HL7ORU.MessageHeader.ContinuationPointer.value = ls_prev_pointer
end if
HL7ORU.MessageHeader.ApplicationAcknowledgmentType.value = "AL"

/* Patient Identification */
HL7ORU.RepGrpORU1.Add(1)
HL7ORU.RepGrpORU1.Item[0].PatientIdentification.PatientIdentification.SetID.valuestring = "1"
//HL7ORU.RepGrpORU1.Item[0].PatientIdentification.PatientIdentification.ExternalPatientID.ID.valuestring = ls_billing_id
HL7ORU.RepGrpORU1.Item[0].PatientIdentification.PatientIdentification.InternalPatientID.Add(1)
HL7ORU.RepGrpORU1.Item[0].PatientIdentification.PatientIdentification.InternalPatientID.Item[0].ID.valuestring = ls_billing_id

HL7ORU.RepGrpORU1.Item[0].PatientIdentification.PatientIdentification.PatientName.Add(1)
HL7ORU.RepGrpORU1.Item[0].PatientIdentification.PatientIdentification.PatientName[0].FamilyName.valuestring = ls_last_name
HL7ORU.RepGrpORU1.Item[0].PatientIdentification.PatientIdentification.PatientName[0].GivenName.valuestring = ls_first_name
HL7ORU.RepGrpORU1.Item[0].PatientIdentification.PatientIdentification.PatientName[0].MiddleName.valuestring = ls_middle_name

/* Observation Request Segment (OBR)*/
HL7ORU.RepGrpORU1.Item[0].ORCGroup.Add(1)
HL7ORU.RepGrpORU1.Item[0].ORCGroup.Item[0].ObservationsReportID.SetID.valuestring = "1"
HL7ORU.RepGrpORU1.Item[0].ORCGroup.Item[0].ObservationsReportID.UniversalServiceID.Identifier.valuestring = ls_observation_id
HL7ORU.RepGrpORU1.Item[0].ORCGroup.Item[0].ObservationsReportID.UniversalServiceID.Text.valuestring = "Encounter Notes"
HL7ORU.RepGrpORU1.Item[0].ORCGroup.Item[0].ObservationsReportID.ObservationDateTime.valuestring = ls_encounter_datetime

i=0
long ll_pos1
ll_pos = pos(ls_report_text,"~n")
Do While ll_pos > 0
	ls_report_line = mid(ls_report_text,1,ll_pos - 1)
	// custom fix for Shands
	if len(ls_report_line) = 0 Then 
		ls_report_line = "\r\n"
	else
		ls_report_line = ls_report_line + char(32) + char(126)
	end if
	ll_pos1 = pos(ls_report_line,"~t")
	if ll_pos1 > 0 then ls_report_line = mid(ls_report_line,1,ll_pos1 - 1) + space(8) + mid(ls_report_line,ll_pos1 + 1)
	// end of custom fix for shands
	i++
	k = i - 1
	/* Observation Results Segment (OBX)*/
	HL7ORU.RepGrpORU1.Item[0].ORCGroup.Item[0].ObservationResultsGroup.Add(i)
	HL7ORU.RepGrpORU1.Item[0].ORCGroup.Item[0].ObservationResultsGroup.Item[k].ObservationResult.SetID.valuestring = i
	HL7ORU.RepGrpORU1.Item[0].ORCGroup.Item[0].ObservationResultsGroup.Item[k].ObservationResult.ValueType.valuestring = "TX"
	HL7ORU.RepGrpORU1.Item[0].ORCGroup.Item[0].ObservationResultsGroup.Item[k].ObservationResult.ObservationIdentifier.Identifier.valuestring = ls_observation_id
	HL7ORU.RepGrpORU1.Item[0].ORCGroup.Item[0].ObservationResultsGroup.Item[k].ObservationResult.ObservationIdentifier.Text.valuestring = "Encounter Notes"
	HL7ORU.RepGrpORU1.Item[0].ORCGroup.Item[0].ObservationResultsGroup.Item[k].ObservationResult.ObservationValue.Add(1)
	HL7ORU.RepGrpORU1.Item[0].ORCGroup.Item[0].ObservationResultsGroup.Item[k].ObservationResult.ObservationValue[0].ValueString = ls_report_line
	HL7ORU.RepGrpORU1.Item[0].ORCGroup.Item[0].ObservationResultsGroup.Item[k].ObservationResult.ObservResultStatus.ValueString = "F"
	
	ls_report_text = mid(ls_report_text,ll_pos + 1)
	ll_pos = pos(ls_report_text,"~n")
Loop
if ls_cont_pointer <> "" then
	HL7ORU.ContinuationPointer.ContinuationPointer.valuestring = ls_cont_pointer
end if

Update o_message_log
set status = 'LCR_SENDING'
Where message_id = :message_id;

ls_uid = omsgman.SendMessage(oEnv,destination_app)
omsgman.donewithmessage(oenv)

hl7oru.disconnectobject()
destroy hl7oru
omsgtype.disconnectobject()
destroy omsgtype
oenv.disconnectobject()
destroy oenv

If len(ls_uid) > 0 Then
	Update o_message_log
	set status = 'LCR_SENT'
	Where message_id = :message_id;
End If
GarbageCollectSetTimeLimit(0)
GarbageCollect()

Return 1
end function

public function integer timer_ding ();string 		ls_ack_message_id,ls_ack_type
String		ls_error1,ls_error2,ls_error
String		ls_cpr_id
Long			ll_encounter_id
integer 		j
long 			count,ll_message_id,ll_pending
integer		li_sts,i,li_rtn
string 		ls_message_type
long 			ll_subscription_id,ll_count
oleobject 	coll  //HCMessageEnvelopeCollection
oleobject 	ack // ack object
oleobject 	omsg // message envelope
u_ds_data	luo_data

// check for acknowledgement messages
ll_pending = omsgMan.NumMessagesPending()
If ll_pending > 0 Then
	mylog.log(this, "timer_ding()", "Acknowledge messages received (" + string(ll_pending) + ")", 2)
	For i = 1 to ll_pending
	   coll = omsgMan.PollForMessage(1, count)
		count = Coll.Count
   	// get messages
		mylog.log(this, "timer_ding()", "Polling Count (" + string(count) + ")", 1)
		If count = 0 Then // no messages
			coll.disconnectobject()
			destroy coll
			Continue
		End If
		FOR j = 0 to count - 1
			ls_message_type = coll.Item(j).Type.MessageTypeCode
			mylog.log(this, "timer_ding()", "Collection Count (" + string(j) + ") message type ( "+ls_message_type+")", 1)
			If coll.Item(j).Type.MessageTypeCode = "ACK" Then
   			omsg = coll.Item(j)
				ack = omsg.Content
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
				
				SELECT cpr_id,	encounter_id
				INTO :ls_cpr_id,:ll_encounter_id
				FROM o_Message_Log
				WHERE id = :ls_ack_message_id
				Using cprdb;
				If cprdb.sqlcode = 100 Then
					mylog.log(this, "timer_ding()", "No records found for message ID (" + ls_ack_message_id + ")", 3)
					continue
				End If
					
				If ls_ack_type = "AA" or ls_ack_type = "AL" or ls_ack_type = 'CA' then // bill Accepted
					Update o_message_log
					Set status = 'LCR_SENT'
					WHERE id = :ls_ack_message_id
					Using cprdb;
					If not cprdb.check() THEN RETURN -1
					mylog.log(this, "timer_ding()", "Acknowledge received for message ID (" + ls_ack_message_id + ")", 2)
				Elseif ls_ack_type = "AE" then
					Update o_message_log
					Set status = 'LCR_ACKREJ',
					comments = :ls_error
					Where id = :ls_ack_message_id
					Using cprdb;
					If Not cprdb.check() THEN Return -1		
					mylog.log(this, "timer_ding()", "Ack Reject received for message ID (" + ls_ack_message_id + "), Error: "+ls_error, 4)	
				Else
					Update o_message_log
					Set status = 'LCR_NACK'
					Where id = :ls_ack_message_id
					AND status = 'LCR_ACK'
					using cprdb;
					if not cprdb.check() then return -1		
					mylog.log(this, "timer_ding()", "NonAcknowledge received for message ID (" + ls_ack_message_id + ")" , 2)	
				End if	
				omsgMan.donewithmessage(omsg)
				omsg.disconnectobject()
				destroy(omsg)
				setnull(omsg)
				ack.disconnectobject()
				Destroy ack
				Setnull(ack)
			End If
		Next
		For j = 0 to (integer(coll.count)) - 1
			coll.Remove (j)
		Next 
		coll.disconnectobject()
		destroy(Coll)
		setnull(coll)
	Next
End If

GarbageCollectSetTimeLimit(0)
GarbageCollect()
Return 1

end function

public function integer lcr_report (string ps_text);String		ls_eom = "##%%?##"
String		ls_message,ls_uid
String		ls_report_line
String		ls_line_break = "~013"
String		ls_message_type
String		ls_record
String		ls_sending_facility,ls_sending_app
String		ls_observation_id
String		ls_external_id,ls_first_name,ls_last_name,ls_middle_name
String		ls_internal_id
String		ls_billing_id
String		ls_firstname,ls_lastname,ls_middlename
String		ls_encounter_datetime,ls_report_text
String		ls_cont_pointer,ls_prev_pointer
String		ls_fields[]
integer		li_sts,k,i
long			ll_pos,ll_next_counter
string		ls_message_uid
string		ls_hl7_header,ls_pid,ls_obr,ls_obx,ls_dsc,ls_hl7
integer		li_rtn
string		ls_path,ls_filename
boolean		lb_listen
blob			lblob_report

/* extract the individual fields in the message */
k = 1
do while len(ps_text) > 0
	ll_pos = POS(ps_text,ls_line_break)
	if ll_pos > 0 Then
		ls_fields[k] = mid(ps_text,1,ll_pos - 1)
	end if	
	ps_text = Mid(ps_text,ll_pos + 1)
	If ps_text = "" then exit
	k++
loop

If upperbound(ls_fields) < 13 Then
	log.log(this,"sendreport","Send Failed:message id ("+string(message_id)+") message count is invalid ",3)
	
	Update o_message_log
	set status = 'BAD LEN'
	Where message_id = :message_id;
	return -1
End If

SELECT convert(varchar(38),id)
INTO :ls_message_uid
FROM o_Message_Log
WHERE message_id = :message_id;

ls_message_type = ls_fields[1]
ls_sending_app = ls_fields[2]
ls_sending_facility = ls_fields[3]
ls_observation_id = ls_fields[4]
ls_billing_id = ls_fields[5]
ls_internal_id = ls_fields[6]
ls_first_name = ls_fields[7]
ls_last_name = ls_fields[8]
ls_middle_name = ls_fields[9]
ls_encounter_datetime = ls_fields[10]
ls_report_text = ls_fields[11]
ls_prev_pointer = ls_fields[12]
ls_cont_pointer = ls_fields[13]


/* Message Header */
ls_hl7_header = "MSH|^~~\&|EPRO|UF|LCR||"+string(datetime(today(),now()),"yyyymmdd hh:mm")+"||ORU^|"
ls_hl7_header += ls_message_uid+"|P|2.3||"
if ls_prev_pointer <> "" then
	ls_hl7_header += ls_prev_pointer+"||AL"+"~h0D"
else
	ls_hl7_header += "||AL"+"~h0D"
end if

/* Patient Identification */
ls_pid = "PID|1||"+ls_billing_id+"||"+ls_last_name+"^"+ls_first_name+"~h0D"

/* Observation Request Segment (OBR)*/
ls_obr = "OBR|1|||ETNOTE^Encounter Notes|||"+ls_encounter_datetime+"~h0D"

/* Observation Results Segment (OBX)*/
i=0
long ll_pos1
ll_pos = pos(ls_report_text,"~n")
Do While ll_pos > 0
	ls_report_line = mid(ls_report_text,1,ll_pos - 1)
	// custom fix for Shands
	if len(ls_report_line) = 0 Then 
		ls_report_line = char(32)+char(126)
	else
		ls_report_line = ls_report_line + char(32)+char(126)
	end if
	ll_pos1 = pos(ls_report_line,"~t")
	if ll_pos1 > 0 then ls_report_line = mid(ls_report_line,1,ll_pos1 - 1) + space(8) + mid(ls_report_line,ll_pos1 + 1)

	ll_pos1 = pos(ls_report_line,"&")
	if ll_pos1 > 0 then ls_report_line = mid(ls_report_line,1,ll_pos1 - 1) + " and " + mid(ls_report_line,ll_pos1 + 1)

	// end of custom fix for shands
	i++
	ls_obx +="OBX|"+string(i)+"|TX|ETNOTE^Encounter Notes||"+ls_report_line+"||||||F"+"~h0D"

	ls_report_text = mid(ls_report_text,ll_pos + 1)
	ll_pos = pos(ls_report_text,"~n")
Loop
if ls_cont_pointer <> "" then
	ls_dsc = "DSC|"+string(ls_cont_pointer)+"~h0D"
end if

if len(ls_dsc) > 0 then
	ls_hl7 = ls_hl7_header + ls_pid + ls_obr + ls_obx + ls_dsc +  ls_eom
else
	ls_hl7 = ls_hl7_header + ls_pid + ls_obr + ls_obx + ls_eom
end if
mylog.log(this, "lcr_report()",ls_hl7, 1)
lblob_report = f_string_to_blob(ls_hl7, TextEncoding)

Update o_message_log
set status = 'LCR_SENDING'
Where message_id = :message_id;

// write to a file
// to assure more uniqueness, Construct the filename using a component counter
ls_path = recv_app_path
if right(recv_app_path, 1) <> "\" then ls_path += "\"

ls_filename = ls_path + string(message_id) + string(today(),"yyyymmdd") + string(now(),"hhmmss") + ".txt"


if fileexists(ls_filename) then
	mylog.log(this, "lcr_report()", "Error getting next file number", 4)
	return -1
end if

if mylog.file_write(lblob_report,ls_filename) < 0 then
	mylog.log(this, "lcr_report()", "Error writing the report into a file", 4)
	Update o_message_log
	set status = 'LCR_FAILED'
	Where message_id = :message_id;
	return 1
end if

Update o_message_log
set status = 'LCR_ACK'
Where message_id = :message_id;

GarbageCollectSetTimeLimit(0)
GarbageCollect()

Return 1
end function

on u_component_outgoing_report_hl7.create
call super::create
end on

on u_component_outgoing_report_hl7.destroy
call super::destroy
end on

