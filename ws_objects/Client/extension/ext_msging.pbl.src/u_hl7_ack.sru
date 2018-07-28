$PBExportHeader$u_hl7_ack.sru
forward
global type u_hl7_ack from nonvisualobject
end type
end forward

global type u_hl7_ack from nonvisualobject
end type
global u_hl7_ack u_hl7_ack

type variables
//oleobject oAHC_ack
//oleobject ackMsgMan

end variables

forward prototypes
public function integer app_ack_destroy ()
public function integer app_ack (ref u_sqlca cprdb, ref u_event_log mylog, ref string app_ack, ref string app_file_address)
public function integer ack (ref oleobject po_env, ref u_event_log mylog, ref u_sqlca cprdb, ref oleobject omsg, ref oleobject msgman, string ack_appl, string is_fromapp, string is_toapp, string is_message_id, string bs_system, string is_idx_eom, string dcom_ack_app, string ack_fileaddress, integer pi_ack_type, ref oleobject ackmsgman, boolean pb_store, long dcom_app_port)
end prototypes

public function integer app_ack_destroy ();//if not isnull(oAHC_ack) then
//	oAHC_ack.Disconnect()
//end if	
//destroy ackMsgMan
//setnull(ackMsgMan)
//
//destroy oAHC_ack
//setnull(oAHC_ack)
//
return 1
end function

public function integer app_ack (ref u_sqlca cprdb, ref u_event_log mylog, ref string app_ack, ref string app_file_address);////AHCMessage
//integer li_sts
//
//oAHC_ack = CREATE oleobject
//li_sts = oAHC_ack.connecttonewobject("AHC.Messenger")
//if li_sts <> 0 then
//	mylog.log(this, "dcom_app_ack", "ERROR: connection to AHC Messenger object failed.", 4)
//	DESTROY oAHC_ack
//	setnull(oAHC_Ack)
//	return -1
//end if	
//mylog.log(this, "dcom_app_ack", "connection to AHC Messenger object.", 2)
////IHCMessageManager
////create the manager object for acknowledgements
////Call the Connect method on the object and supply the registered application name 
//ackMsgMan = CREATE oleobject
//ackMsgMan = oAHC_ack.Connect(app_ack)
////ackMsgMan = common_thread.mm.ahcConnect(oAHC,ls_obj_destination)
//if isnull(ackMsgMan) then
//	mylog.log(this, "dcom_app_ack", "ERROR: connection to IHCMessageManager object failed.", 4)
//	return -1
//end if
//mylog.log(this, "dcom_app_ack", "connection to IHCMessageManager object.", 2)

return 1

end function

public function integer ack (ref oleobject po_env, ref u_event_log mylog, ref u_sqlca cprdb, ref oleobject omsg, ref oleobject msgman, string ack_appl, string is_fromapp, string is_toapp, string is_message_id, string bs_system, string is_idx_eom, string dcom_ack_app, string ack_fileaddress, integer pi_ack_type, ref oleobject ackmsgman, boolean pb_store, long dcom_app_port);//Acknowledgement transaction
if isnull(dcom_ack_app)  then return 1
integer li_sts
string ls_sts
string ls_uuid
string ack_filename
string ack_msh
string ack_msa
string ack_message
string ack_datetime
string ack_controlid
string ack_request
string ack_code
string ls_status
string ls_message_type
datetime ldt_now, ldt_ack
UnsignedLong lul_ackptr, lul_envptr
any la_any
boolean lb_ackfile
integer li_FileNum

ack_code = 'AA'
ls_status = 'RECEIVED-ACK'
if pi_ack_type < 1 then 
	ack_code = 'AR'
	ls_status = 'RECEIVED-NACK'
end if	

if (isnull(ack_fileaddress) or  ack_fileaddress = '') then
	lb_ackfile = false
else
	lb_ackfile = true
end if

ldt_now = datetime(today(), now())

// create the message type
oleobject omsgtype
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
oleobject AckMsg
AckMsg = create oleobject

AckMsg = ackmsgman.CreateResponseMessage(po_env,oMsgtype)

li_sts = AckMsg.GetAutomationNativePointer (lul_envptr)
if li_sts < 0 then
	mylog.log(this, "ack()", "error native pointer to message object ", 4)	
	return -1
end if

// create a message object
oleobject HL7MsgACK
HL7MsgACK = create oleobject

//Get handle to the message in the enevelope
//check if acknowledgement requested
HL7MsgACK = AckMsg.Content
ack_request = HL7MsgACK.MessageAcknowledgment.AcknowledgmentCode.Value
ack_controlid = oMsg.MessageHeader.MessageControlID.Value
ack_datetime = HL7MsgACK.MessageHeader.DatetimeOfMessage.valuestring
if isdate(ack_datetime) then
	ldt_ack = datetime(ack_datetime)
else
	ldt_ack = datetime(today(),now())
end if

ls_message_type = bs_system + "_" + "ACK"

if bs_system = 'IDX' or bs_system = 'MEDIC' then 
	ack_msh = 'MSH|^~\&|' + ack_appl + '||'  + is_FromApp + '||' + ack_datetime + '||ACK^|' + is_message_id + '|P|2.3||||||||'
	ack_msa = 'MSA|' + ack_code + '|' + ack_controlid + '||||'
	ack_message = ack_msh + '' + ack_msa + ''
	if is_idx_eom = 'Y' then ack_message += 'EOM'
	if lb_ackfile then
			ack_filename = 'ack_' + ack_datetime + '.txt'
			li_FileNum = FileOpen(ack_fileaddress + '\' + ack_filename,StreamMode!, Write!, LockWrite!, Replace!)
			FileWrite(li_FileNum, ack_message)
			FileClose(li_FileNum)
			goto finish
	else
		if isnull(dcom_app_port) then
			mylog.log(this, "ack()", "error no port specified for ack ", 4)	
			return -1
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
		goto finish
	end if	
end if	

li_sts = HL7MsgACK.GetAutomationNativePointer (lul_ackptr)
if li_sts < 0 then
	mylog.log(this, "ack()", "error native pointer to message object ", 4)	
	return -1
end if

// fill out the ACK with relevant information
//Sending Application
HL7MsgACK.MessageHeader.SendingApplication.NameSpaceID.value = is_ToApp

//Destination Application
HL7MsgACK.MessageHeader.ReceivingApplication.NameSpaceID.value = is_FromApp
HL7MsgACK.MessageHeader.MessageControlID.value = is_message_id
HL7MsgACK.MessageAcknowledgment.AcknowledgmentCode.Value = "AA"
if pi_ack_type < 1 then
	HL7MsgACK.MessageAcknowledgment.AcknowledgmentCode.Value = "AR"
end if	
HL7MsgACK.MessageAcknowledgment.ControlID.Value = ack_controlid

// send message to destination
mylog.log(this, "ack()", "sendmessage to" + is_FromApp + " from " + ack_appl, 1)	
//determine if to file or to app
if lb_ackfile then
		ack_datetime = HL7MsgACK.MessageHeader.DatetimeOfMessage.valuestring
		ack_msh = 'MSH|^~\&|' + ack_appl + '||'  + is_FromApp + '||' + ack_datetime + '||ACK^|' + is_message_id + '|P|2.3||||||||'
		ack_msa = 'MSA|' + ack_code + '|' + ack_controlid + '||||'
		ack_message = ack_msh + '' + ack_msa + ''
		if is_idx_eom = 'Y' then ack_message += 'EOM'
		ack_filename = 'ack_' + ack_datetime + '.txt'
		li_FileNum = FileOpen(ack_fileaddress + '\' + ack_filename,StreamMode!, Write!, LockWrite!, Replace!)
		FileWrite(li_FileNum, ack_message)
		FileClose(li_FileNum)
	else
		SetNull(ls_uuid)
		ls_uuid = ackmsgman.SendMessage(AckMsg,dcom_ack_app)
		if IsNull(ls_uuid) then
			mylog.log(this,"send_ack()","error with send to AHCMessenger object",4)
		end if
end if

if pb_store then
	INSERT INTO o_Message_Log (
		subscription_id,
		message_type,
		message_date_time,
		direction,
		status,
		message_ack_datetime)
	VALUES (
		2,
		:ls_message_type,
		:ldt_ack,
		'I',
		:ls_status,
		:ldt_now
		) using cprdb;
	if not cprdb.check() then return -1
end if	

Finish:
ackmsgman.DoneWithMessage(AckMsg)
li_sts = AckMsg.ReleaseAutomationNativePointer (lul_envptr)
li_sts = HL7MsgACK.ReleaseAutomationNativePointer (lul_ackptr)
destroy AckMsg
setnull(AckMsg)
destroy HL7MsgACK
setnull(HL7MsgACK)
DESTROY omsgtype
setnull(omsgtype)
return 1

end function

on u_hl7_ack.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_hl7_ack.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

