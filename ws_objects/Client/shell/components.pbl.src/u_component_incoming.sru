$PBExportHeader$u_component_incoming.sru
forward
global type u_component_incoming from u_component_base_class
end type
end forward

global type u_component_incoming from u_component_base_class
end type
global u_component_incoming u_component_incoming

type variables
long subscription_id
string message_type
string address
string bs_system
string message_office_id
end variables

forward prototypes
public function integer stop_receiving ()
public function integer start_receiving (long pl_subscription_id)
private subroutine fix_address ()
protected function integer xx_set_message_received (string ps_file)
protected function integer xx_get_next_message (string ps_address, ref string ps_file)
protected function long log_message (string ps_file)
end prototypes

public function integer stop_receiving ();stop_timer()
return 1
end function

public function integer start_receiving (long pl_subscription_id);subscription_id = pl_subscription_id

if isnull(pl_subscription_id) then
	log.log(this, "send_file()", "Null Subscription ID", 4)
	return -1
end if

SELECT message_type, address,office_id
INTO :message_type, :address,:message_office_id
FROM o_Message_Subscription
WHERE subscription_id = :subscription_id
USING cprdb;
if not cprdb.check() then return -1
if cprdb.sqlcode = 100 then
	log.log(this, "start_receiving()", "Subscription record not found (" + string(subscription_id) + ")", 4)
	return -1
end if

fix_address()

if isnull(message_type) then
	log.log(this, "start_receiving()", "Null Message Type", 4)
	return -1
end if

set_timer()

Return 1


end function

private subroutine fix_address ();string ls_temp

address = f_string_substitute(address, "%MESSAGE_TYPE%", message_type)

ls_temp = string(subscription_id)
address = f_string_substitute(address, "%SUBSCRIPTION_ID%", ls_temp)

ls_temp = string(today(), "yymmdd")
address = f_string_substitute(address, "%DATE%", ls_temp)

ls_temp = string(now(), "hhmmss")
address = f_string_substitute(address, "%TIME%", ls_temp)

ls_temp = string(today(), "yymmdd") + string(now(), "hhmmss")
address = f_string_substitute(address, "%DATETIME%", ls_temp)


end subroutine

protected function integer xx_set_message_received (string ps_file);if ole_class then
	return ole.set_message_received(ps_file)
else
	return 100
end if


end function

protected function integer xx_get_next_message (string ps_address, ref string ps_file);if ole_class then
	return ole.get_next_message(ps_address, ref ps_file)
else
	return 100
end if


end function

protected function long log_message (string ps_file);long ll_message_id
long ll_message_size
string ls_status
string ls_log_compression_type
string ls_message_compression_type
blob 		lblb_message
integer li_sts
string ls_direction
string ls_message_file

 DECLARE lsp_log_message PROCEDURE FOR dbo.sp_log_message  
         @pl_subscription_id = :subscription_id,   
         @ps_message_type = :message_type,   
         @pl_message_size = :ll_message_size,   
         @ps_status = :ls_status,
			@ps_direction = :ls_direction,
         @pl_message_id = :ll_message_id OUT
USING cprdb;

ls_direction = "I"
ll_message_size = filelength(ps_file)
ls_status = "NOTREADY"
ls_message_compression_type  = "NONE"
ls_message_file = ps_file

// Read the file into a local blob
li_sts = mylog.file_read(ls_message_file, lblb_message)
if li_sts <= 0 then return -1

IF Fileexists(ls_message_file) THEN
	if not Filedelete(ls_message_file) then
		mylog.log(this, "log_message()",ps_file + ": File Delete Failed", 3)
		Return -1
	END IF
END IF
// First create the log record and get the message_id
EXECUTE lsp_log_message;
if not cprdb.check() then return -1

FETCH lsp_log_message INTO :ll_message_id;
if not cprdb.check() then return -1

CLOSE lsp_log_message;

// Then save the message file in the log record
UPDATEBLOB o_Message_Log
SET message = :lblb_message
WHERE message_id = :ll_message_id
USING cprdb;
if not cprdb.check() then return -1
mylog.log(this, "log_message()",ps_file + ": read into blob", 1)

UPDATE o_Message_Log
SET status = 'READY'
WHERE message_id = :ll_message_id
USING cprdb;
if not cprdb.check() then return -1
mylog.log(this, "log_message()",ps_file + ": read into blob and updated to o_message_log for "+string(ll_message_id), 1)

return ll_message_id
end function

on u_component_incoming.create
call super::create
end on

on u_component_incoming.destroy
call super::destroy
end on

