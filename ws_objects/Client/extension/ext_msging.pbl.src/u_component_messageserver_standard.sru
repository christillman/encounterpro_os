$PBExportHeader$u_component_messageserver_standard.sru
forward
global type u_component_messageserver_standard from u_component_messageserver
end type
type str_message_component from structure within u_component_messageserver_standard
end type
type str_subscription_component from structure within u_component_messageserver_standard
end type
end forward

type str_message_component from structure
	string		message_type
	u_component_message_handler		handler
end type

type str_subscription_component from structure
	long		subscription_id
	u_component_outgoing		outgoing_transport
end type

global type u_component_messageserver_standard from u_component_messageserver
end type
global u_component_messageserver_standard u_component_messageserver_standard

type variables
private str_message_component message_types[]
private integer message_type_count = 0

private str_subscription_component subscription_components[]
private integer subscription_component_count = 0

boolean message_handler = false
boolean outgoing_transport = false


end variables

forward prototypes
protected function integer xx_send_to_subscribers (string ps_message_type, string ps_filename)
private function long queue_file (string ps_message_type, long pl_subscription_id, string ps_file)
private function long log_message (string ps_message_type, long pl_subscription_id, string ps_file)
end prototypes

protected function integer xx_send_to_subscribers (string ps_message_type, string ps_filename);long ll_message_id
string ls_message_type
integer li_sts
u_ds_data luo_data
integer li_count
long ll_subscription_id
string ls_stream_id
string ls_streamer_component_id
long i
string ls_status

if isnull(batch_mode) or len(batch_mode) = 0 then batch_mode = "N"
luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_message_subscription_data")
li_count = luo_data.retrieve(ps_message_type, "O")
if li_count < 0 then
	mylog.log(this, "u_component_messageserver_standard.xx_send_to_subscribers:0017", "Error getting subscribers", 4)
	return -1
elseif li_count = 0 then
	mylog.log(this, "u_component_messageserver_standard.xx_send_to_subscribers:0020", "No subscribers for message type.  Message will not be sent (" + ps_message_type + ")", 2)
	return -1
end if

for i = 1 to li_count
	ll_subscription_id = luo_data.object.subscription_id[i]
	ls_message_type = luo_data.object.message_type[i]
	ls_stream_id = luo_data.object.stream_id[i]
	
	if isnull(ll_subscription_id) then
		mylog.log(this, "u_component_messageserver_standard.xx_send_to_subscribers:0030", "Null subscription_id.  Message will not be sent(" + ps_message_type + ")", 4)
		continue
	end if
	
	ll_message_id = queue_file(ls_message_type, ll_subscription_id, ps_filename)

	if ll_message_id <= 0 then
		mylog.log(this, "u_component_messageserver_standard.xx_send_to_subscribers:0037", "Error queuing file (" + string(ll_subscription_id) + ")", 4)
		continue
	end if
	
	if not isnull(ls_stream_id) then
		SELECT streamer_component_id
		INTO :ls_streamer_component_id
		FROM c_Message_Stream
		WHERE message_type = :ls_message_type
		AND stream_id = :ls_stream_id
		USING cprdb;
		if not cprdb.check() then
			mylog.log(this, "u_component_messageserver_standard.xx_send_to_subscribers:0049", "Error checking streamer", 4)
			continue
		end if
		if cprdb.sqlcode = 100 then
			mylog.log(this, "u_component_messageserver_standard.xx_send_to_subscribers:0053", "Streamer not attached to message type (" + ls_stream_id + ", " + ls_message_type + ")", 4)
			continue
		end if
	ELSE

		UPDATE o_Message_Log
		SET status = 'STREAMED',
			cpr_id = :cpr_id,
			encounter_id = :encounter_id,
			batch_mode = :batch_mode
		WHERE message_id = :ll_message_id
		USING cprdb;
		if not cprdb.check() then
			mylog.log(this, "u_component_messageserver_standard.xx_send_to_subscribers:0066", "Error updating message status to 'STREAMED'", 4)
			continue
		end if
		if cprdb.sqlcode = 100 then
			mylog.log(this, "u_component_messageserver_standard.xx_send_to_subscribers:0070", "Message log record not found (" + string(ll_message_id) + ")", 4)
			continue
		end if
		
	end if
next

DESTROY luo_data

return 1

end function

private function long queue_file (string ps_message_type, long pl_subscription_id, string ps_file);integer li_sts
string ls_left
string ls_extension
blob lblb_message
string ls_drive
string ls_directory
string ls_filename
string ls_sendfile
long ll_message_id

if isnull(pl_subscription_id) then
	mylog.log(this, "u_component_messageserver_standard.queue_file:0012", "Null Subscription Id", 4)
	return -1
end if

if pl_subscription_id <= 0 then
	mylog.log(this, "u_component_messageserver_standard.queue_file:0017", "Invalid Subscription Id (" + string(pl_subscription_id) + ")", 4)
	return -1
end if
ls_sendfile = ps_file
ll_message_id = log_message(ps_message_type, pl_subscription_id, ls_sendfile)
If ll_message_id <= 0 then
	mylog.log(this, "u_component_messageserver_standard.queue_file:0023", "Error logging message", 4)
	filedelete(ls_sendfile)
	return -1
End if	

// If we successfully logged the message, then we can delete it
filedelete(ls_sendfile)

return ll_message_id

end function

private function long log_message (string ps_message_type, long pl_subscription_id, string ps_file);long ll_message_id
long ll_message_size
string ls_status
blob lblb_message
integer li_sts
string ls_direction

// DECLARE lsp_log_message PROCEDURE FOR .sp_log_message  
//         @pl_subscription_id = :pl_subscription_id,   
//         @ps_message_type = :ps_message_type,   
//         @pl_message_size = :ll_message_size,   
//         @ps_status = :ls_status,
//			@ps_direction = :ls_direction,
//         @pl_message_id = :ll_message_id OUT
//USING cprdb;

ls_direction = "O"
ll_message_size = filelength(ps_file)
ls_status = "NEW"

// Read the file into a local blob
li_sts = mylog.file_read(ps_file, lblb_message)
if li_sts <= 0 then return -1

// First create the log record and get the message_id
cprdb.sp_log_message   ( &
         pl_subscription_id,    &
         ps_message_type,    &
         ll_message_size,    &
         ls_status, &
			ls_direction, &
         ref ll_message_id );
//EXECUTE lsp_log_message;
if not cprdb.check() then return -1

//FETCH lsp_log_message INTO :ll_message_id;
//if not cprdb.check() then return -1
//
//CLOSE lsp_log_message;

// Then save the message file in the log record
UPDATEBLOB o_Message_Log
SET message = :lblb_message
WHERE message_id = :ll_message_id
USING cprdb;
if not cprdb.check() then return -1

return ll_message_id
end function

on u_component_messageserver_standard.create
call super::create
end on

on u_component_messageserver_standard.destroy
call super::destroy
end on

