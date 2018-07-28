HA$PBExportHeader$u_mail_session.sru
forward
global type u_mail_session from mailsession
end type
end forward

global type u_mail_session from mailsession
end type
global u_mail_session u_mail_session

type variables

string service = "MESSAGE"

u_sqlca cprdb
u_event_log mylog

end variables

forward prototypes
public function integer get_messages ()
public function integer send_user_messages (string ps_user_id)
public function integer shutdown ()
public function integer initialize (u_sqlca luo_cprdb, u_event_log luo_log)
public function integer send_message (long pl_message_id, string ps_from_user_id, string ps_to_user_id, string ps_subject, string ps_message)
public function integer get_user (string ps_message, ref u_user puo_from_user, ref u_user puo_to_user)
public function integer post_message (u_user puo_from_user, u_user puo_to_user, mailmessage puo_message)
end prototypes

public function integer get_messages ();long i
long ll_count
MailReturnCode lm_sts
integer li_sts
u_user luo_from_user
u_user luo_to_user

mailmessage luo_message

lm_sts = mailGetMessages()
if lm_sts <> mailReturnSuccess! then
	mylog.log(this, "get_messages()", "Error downloading mail messages (" + string(lm_sts) + ")", 4)
	return -1
end if

ll_count = UpperBound(MessageID)

for i = 1 to ll_count
	lm_sts = mailReadMessage(MessageID[i], luo_message, mailEntireMessage!, FALSE)
	if lm_sts <> mailReturnSuccess! then
		mylog.log(this, "get_messages()", "Error getting mail message (" + string(lm_sts) + ")", 4)
		return -1
	end if
	
	// Make sure the conversationId is a valid Epro user_id
	li_sts = get_user(luo_message.notetext, luo_from_user, luo_to_user)
	if not isnull(luo_to_user) then
		li_sts = post_message(luo_from_user, luo_to_user, luo_message)
		if li_sts <= 0 then
			mylog.log(this, "get_messages()", "Error posting mail message (" + luo_message.subject + ")", 4)
			return -1
		end if
		
		lm_sts = mailDeleteMessage(MessageID[i])
		if lm_sts <> mailReturnSuccess! then
			mylog.log(this, "get_messages()", "Error deleting mail message (" + luo_message.subject + ", " + string(lm_sts) + ")", 4)
			return -1
		end if
	end if
next


return ll_count


end function

public function integer send_user_messages (string ps_user_id);u_ds_data luo_data
integer li_sts
long ll_count
long i
long ll_todo_item_id
string ls_subject
string ls_from_user_id
string ls_message
datetime ldt_now
string ls_status

ldt_now = datetime(today(), now())


luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_message_inbox_list", cprdb)

ll_count = luo_data.retrieve(ps_user_id)

for i = 1 to ll_count
	ll_todo_item_id = luo_data.object.todo_item_id[i]
	ls_subject = luo_data.object.todo_item[i]
	ls_from_user_id = luo_data.object.ordered_by[i]
	ls_message = luo_data.object.message[i]
	
	li_sts = send_message(ll_todo_item_id, ls_from_user_id, ps_user_id, ls_subject, ls_message)
	if li_sts > 0 then
		ls_status = "SENT"
		UPDATE u_Todo_List
		SET end_date_time = :ldt_now,
			 status = :ls_status
		WHERE user_id = :ps_user_id
		AND todo_item_id = :ll_todo_item_id
		USING cprdb;
		if not cprdb.check() then return -1
	end if
next

DESTROY luo_data

return ll_count


end function

public function integer shutdown ();maillogoff()

return 1

end function

public function integer initialize (u_sqlca luo_cprdb, u_event_log luo_log);mailreturncode lm_sts
string ls_mailuser
string ls_mailpassword

cprdb = luo_cprdb
mylog = luo_log

ls_mailuser = datalist.get_preference("PREFERENCES", "mail_userid", "jmjtech")
ls_mailpassword = datalist.get_preference("PREFERENCES", "mail_password", "")

lm_sts = maillogon(ls_mailuser,ls_mailpassword,mailNewSessionWithDownLoad!)
if lm_sts <> mailReturnSuccess! then
	mylog.log(this, "get_messages()", "Error starting mail session (" + string(lm_sts) + ")", 4)
	return -1
end if

return 1


end function

public function integer send_message (long pl_message_id, string ps_from_user_id, string ps_to_user_id, string ps_subject, string ps_message);mailReturnCode lm_sts
mailMessage luo_message
string ls_message

ls_message = "<<#" + string(pl_message_id) + "#"
ls_message += " " + string(datetime(today(), now()), "[shortdate] [time]") + "]"
ls_message +=  " " + user_list.user_full_name(ps_from_user_id) + " @ " + office_description + " Wrote:>>"
if not isnull(ps_message) then ls_message += "~r~n" + ps_message

// Populate the mailMessage structure
luo_message.Subject = ps_subject
luo_message.NoteText = ls_message
luo_message.Recipient[1].name = user_list.user_full_name(ps_to_user_id)
luo_message.Recipient[1].address = "SMTP:" + user_list.user_email_address(ps_to_user_id)
luo_message.Recipient[1].RecipientType = mailTo!

// Send the mail
lm_sts = mailSend(luo_message)

if lm_sts <> mailReturnSuccess! THEN
	mylog.log(this, "send_message()", "Error sending message", 4)
	return -1
end if


return 1



end function

public function integer get_user (string ps_message, ref u_user puo_from_user, ref u_user puo_to_user);long ll_pos1
long ll_pos2
string ls_temp
string ls_from_user_id
string ls_to_user_id
long ll_todo_item_id

setnull(puo_from_user)
setnull(puo_to_user)

if isnull(ps_message) then return 0

ll_pos1 = pos(ps_message, "<<!")
if ll_pos1 > 0 then
	ll_pos1 += 3
	ll_pos2 = pos(ps_message, "!", ll_pos1)
	if ll_pos2 > 0 then
		ls_temp = mid(ps_message, ll_pos1, ll_pos2 - ll_pos1)
		f_split_string(ls_temp, ",", ls_from_user_id, ls_to_user_id)

		puo_from_user = user_list.find_user(ls_from_user_id)
		puo_to_user = user_list.find_user(ls_to_user_id)
	end if
end if

if isnull(puo_to_user) then
	ll_pos1 = pos(ps_message, "<<#")
	if ll_pos1 > 0 then
		ll_pos1 += 3
		ll_pos2 = pos(ps_message, "#", ll_pos1)
		if ll_pos2 > 0 then
			ls_temp = mid(ps_message, ll_pos1, ll_pos2 - ll_pos1)
			ll_todo_item_id = long(ls_temp)
			
			SELECT user_id, ordered_by
			INTO :ls_from_user_id, :ls_to_user_id
			FROM u_Todo_List
			WHERE todo_item_id = :ll_todo_item_id
			USING cprdb;
			if not cprdb.check() then return -1
			
			puo_from_user = user_list.find_user(ls_from_user_id)
			puo_to_user = user_list.find_user(ls_to_user_id)
		end if
	end if
end if


return 1


end function

public function integer post_message (u_user puo_from_user, u_user puo_to_user, mailmessage puo_message);long ll_todo_item_id
string ls_attribute
string ls_value
string ls_subject
string ls_to_user_id
string ls_from_user_id
MailReturnCode lm_sts

 DECLARE lsp_todo_service PROCEDURE FOR sp_todo_service  
         @ps_user_id = :ls_to_user_id,   
         @ps_service = :service,   
         @ps_description = :ls_subject,   
         @ps_ordered_by = :ls_from_user_id,   
         @pl_todo_item_id = :ll_todo_item_id OUT
 USING cprdb;

 DECLARE lsp_todo_service_set_attribute PROCEDURE FOR sp_todo_service_set_attribute
         @ps_user_id = :ls_to_user_id,   
         @pl_todo_item_id = :ll_todo_item_id,
         @ps_attribute = :ls_attribute,
         @ps_value = :ls_value
 USING cprdb;

 DECLARE lsp_todo_service_set_ready PROCEDURE FOR sp_todo_service_set_ready
         @ps_user_id = :ls_to_user_id,   
         @pl_todo_item_id = :ll_todo_item_id
 USING cprdb;


ls_from_user_id = puo_from_user.user_id
ls_to_user_id = puo_to_user.user_id
ls_subject = puo_message.subject


EXECUTE lsp_todo_service;
if not cprdb.check() then return -1

FETCH lsp_todo_service INTO :ll_todo_item_id;
if not cprdb.check() then return -1

CLOSE lsp_todo_service;

if trim(puo_message.notetext) <> "" then
	ls_attribute = "MESSAGE"
	ls_value = puo_message.notetext
	EXECUTE lsp_todo_service_set_attribute;
	if not cprdb.check() then return -1
end if

//if not isnull(cpr_id) then
//	ls_attribute = "CPR_ID"
//	ls_value = cpr_id
//	EXECUTE lsp_todo_service_set_attribute;
//	if not tf_check() then return -1

//end if
//
//if not isnull(encounter_id) then
//	ls_attribute = "ENCOUNTER_ID"
//	ls_value = string(encounter_id)
//	EXECUTE lsp_todo_service_set_attribute;
//	if not tf_check() then return -1
//end if

EXECUTE lsp_todo_service_set_ready;
if not cprdb.check() then return -1


return 1

end function

on u_mail_session.create
call mailsession::create
TriggerEvent( this, "constructor" )
end on

on u_mail_session.destroy
call mailsession::destroy
TriggerEvent( this, "destructor" )
end on

