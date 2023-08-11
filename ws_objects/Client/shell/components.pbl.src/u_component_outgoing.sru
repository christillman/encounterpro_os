$PBExportHeader$u_component_outgoing.sru
forward
global type u_component_outgoing from u_component_base_class
end type
end forward

global type u_component_outgoing from u_component_base_class
end type
global u_component_outgoing u_component_outgoing

type prototypes
Function boolean DeleteFileA(ref string filename)  library "KERNEL32.DLL" alias for "DeleteFileA;Ansi"
end prototypes

type variables
long message_id
long subscription_id
string message_type
string address
string log_compression_type
string message_compression_type
string sendfilename
string sendfileext

string file_prefix

end variables

forward prototypes
public function integer send_file (long pl_message_id)
private subroutine fix_address ()
private function integer message_status (string ps_status)
protected function integer xx_send_file (string ps_filename, string ps_address)
protected function integer base_initialize ()
public function integer start_sending (long pl_subscription_id)
end prototypes

public function integer send_file (long pl_message_id);/**********************************************************************************
*
* description:
*
* Returns: -1 - Billing Failed
*           2 - Wait for acknowledgement for the bill before senting another bill
*           1 - Success
*
*
***********************************************************************************/
Long 				ll_next_counter
Long				ll_encounter_id
unsignedlong 	killer
integer 			li_sts, li_tries, li_retry_limit
String 			ls_path, ls_sendfile
String			ls_cpr_id
String 			ls_killer,ls_status
Blob 				lblb_message
Boolean 			lb_success
datetime 		ldt_datetime
datetime 		mes_datetime
datetime 		mes_stopper
time 				lt_stop_time, mes_time
date				mes_date, this_date

message_id = pl_message_id
IF isnull(message_id) or message_id <= 0  THEN
	mylog.log(this, "u_component_outgoing.send_file:0028", "Invalid Message Id (" + string(message_id) + ")", 4)
	return -1
END IF
// Get the log record from o_message_log
SELECT subscription_id, 
		message_type,
		message_date_time,
		cpr_id,
		encounter_id,
		tries,
		status
INTO	:subscription_id,
		:message_type,
		:mes_datetime,
		:ls_cpr_id,
		:ll_encounter_id,
		:li_tries,
		:ls_status
FROM o_message_log
WHERE message_id = :message_id
USING cprdb;
IF NOT cprdb.check() then return -1
if cprdb.sqlcode = 100 then
	mylog.log(this, "u_component_outgoing.send_file:0051", "Message log record not found (" + string(message_id) + ")", 4)
	return -1
end if
if isnull(subscription_id) then
	mylog.log(this, "u_component_outgoing.send_file:0055", "Null Subscription Id", 4)
	return -1
end if
// get the outgoing message address info
SELECT address, compression_type
INTO :address, :message_compression_type
FROM o_Message_Subscription
WHERE subscription_id = :subscription_id
AND message_type = :message_type
USING cprdb;
if not cprdb.check() then return -1
if cprdb.sqlcode = 100 then
	mylog.log(this, "u_component_outgoing.send_file:0067", "Subscription record not found (" + string(subscription_id) + ")", 4)
	return -1
end if
// Check whether the billing is posted within given interval
// if it is overdue then dont send the bill
get_attribute("time_to_kill",ls_killer)
IF Isnumber(ls_killer) THEN
	killer = long(ls_killer)
	ldt_datetime = datetime(today(),now())
	mes_date = date(mes_datetime)
	mes_time = time(mes_datetime)
	IF daysafter(mes_date,today()) = 0 THEN
		lt_stop_time = RelativeTime(mes_time,killer)
		mes_stopper = datetime(mes_date,lt_stop_time)
		IF mes_stopper < ldt_datetime THEN
			mylog.log(this, "u_component_outgoing.send_file:0082", "Message Id (" + string(message_id) + ")" + "datetime too old " + string(mes_datetime), 4)
			Return f_posting_failed(message_id,"NEVERSENT")
		END IF
	END IF
	IF daysafter(mes_date,today()) > 1 THEN
		mylog.log(this, "u_component_outgoing.send_file:0087", "Message Id (" + string(message_id) + ")" + "datetime too old " + string(mes_datetime), 4)
		Return f_posting_failed(message_id,"NEVERSENT")
	END IF
	lt_stop_time = RelativeTime(now(),killer)
	IF mes_time > lt_stop_time THEN
		mylog.log(this, "u_component_outgoing.send_file:0092", "Message Id (" + string(message_id) + ")" + "datetime too old " + string(mes_datetime), 4)
		Return f_posting_failed(message_id,"NEVERSENT")
	END IF
END IF

mylog.log(this, "u_component_outgoing.send_file:0097", "Sending Message (" + string(pl_message_id) + ")", 1)


message_compression_type = "NONE"
//ls_path = get_attribute("temp_directory")
//if isnull(ls_path) or len(ls_path) = 0 then
//	ls_path = temp_path
//end if
//if not mylog.of_directoryexists(ls_path) Then // check directory exists
//	if mylog.of_createdirectory(ls_path) <= 0 then // create new directory
//		mylog.log(this, "u_component_outgoing.send_file:0107", "unable to create temp folder "+ls_path, 4)
//		return -1
//	end if
//end if
//if right(ls_path, 1) <> "\" then ls_path += "\"
//
//// Construct the filename using a component counter
//ll_next_counter = next_component_counter("file_number")
//if ll_next_counter > 0 then
//	sendfilename = file_prefix + string(ll_next_counter)
//else
//	mylog.log(this, "u_component_outgoing.send_file:0118", "Error getting next file number", 4)
//	return -1
//end if
//
//ls_sendfile = ls_path + sendfilename + ".txt"
//
//// Write blob out to message file
//li_sts = mylog.file_write(lblb_message, ls_sendfile)
//if li_sts <= 0 then
//	log.log(this, "u_component_outgoing.send_file:0127", "Error writing message to temp file (" + ls_sendfile + ")", 4)
//	return -1
//end if

fix_address()

if address = "!dummy.dcom" then
	mylog.log(this, "u_component_outgoing.send_file:0134", "calling xx_send_file", 1)
	li_sts = xx_send_file(ls_sendfile,address)
	mylog.log(this, "u_component_outgoing.send_file:0136", "return from xx_send_file "+string(li_sts), 1)
	if li_sts = 2 then 
		mylog.log(this, "u_component_outgoing.send_file:0138", "return from xx_send_file,ACK WAIT - Synchronized "+string(li_sts), 1)
//		f_posting_failed(pl_message_id,"ACK_WAIT-Sync")
		return li_sts // ACK WAIT - Synchronized
	end if
	if li_sts = -1 then
		f_posting_failed(pl_message_id,"SENDERROR")
	else
		mylog.log(this, "u_component_outgoing.send_file:0145", "Sent Message (" + string(pl_message_id) + ")", 2)
	end if
	mylog.log(this, "u_component_outgoing.send_file:0147", "deleting file "+ls_sendfile, 1)
	if fileexists(ls_sendfile) then
		FileDelete(ls_sendfile)
	end if
	mylog.log(this, "u_component_outgoing.send_file:0151", "return from send_file "+string(li_sts), 1)
	return li_sts
end if

li_sts = xx_send_file(ls_sendfile, address)
if li_sts <= 0 then
	f_posting_failed(pl_message_id,"SENDERROR")
	return li_sts
end if

message_status("SENT")

mylog.log(this, "u_component_outgoing.send_file:0163", "Successfully Sent Message (" + string(pl_message_id) + ")", 2)

Return 1

end function

private subroutine fix_address ();string ls_temp

ls_temp = string(message_id)
address = f_string_substitute(address, "%MESSAGE_ID%", ls_temp)

address = f_string_substitute(address, "%MESSAGE_TYPE%", message_type)

ls_temp = string(subscription_id)
address = f_string_substitute(address, "%SUBSCRIPTION_ID%", ls_temp)

ls_temp = string(today(), "yymmdd")
address = f_string_substitute(address, "%DATE%", ls_temp)

ls_temp = string(now(), "hhmmss")
address = f_string_substitute(address, "%TIME%", ls_temp)

ls_temp = string(today(), "yymmdd") + string(now(), "hhmmss")
address = f_string_substitute(address, "%DATETIME%", ls_temp)

address = f_string_substitute(address, "%FILENAME%", sendfilename)

address = f_string_substitute(address, "%FILEEXT%", sendfileext)


end subroutine

private function integer message_status (string ps_status);string ls_cpr_id
long 	 ll_encounter_id
//
// Posting of billing message failed
//
SELECT cpr_id,
		 encounter_id
INTO :ls_cpr_id,
	:ll_encounter_id
FROM o_Message_Log
WHERE message_id = :message_id;
if not tf_check() then return -1

UPDATE o_Message_Log
SET status = :ps_status
WHERE message_id = :message_id;
if not tf_check() then return -1

if not isnull(ls_cpr_id) and not isnull(ll_encounter_id) then
	If ps_status = 'SENT' Then
		UPDATE p_Patient_Encounter
		SET billing_posted = 'Y'
		WHERE cpr_id = :ls_cpr_id
		AND encounter_id = :ll_encounter_id;
	Else
		UPDATE p_Patient_Encounter
		SET billing_posted = 'E'
		WHERE cpr_id = :ls_cpr_id
		AND encounter_id = :ll_encounter_id;
	End If
end if
if not tf_check() then return -1

Return 1
end function

protected function integer xx_send_file (string ps_filename, string ps_address);if ole_class then
	return ole.send_file(ps_filename, ps_address)
else
	return 100
end if


end function

protected function integer base_initialize ();log_compression_type = "NONE"

file_prefix = trim(get_attribute("file_prefix"))
if isnull(file_prefix) then file_prefix = ""

return 1

end function

public function integer start_sending (long pl_subscription_id);subscription_id = pl_subscription_id
set_timer()

return 1
end function

on u_component_outgoing.create
call super::create
end on

on u_component_outgoing.destroy
call super::destroy
end on

