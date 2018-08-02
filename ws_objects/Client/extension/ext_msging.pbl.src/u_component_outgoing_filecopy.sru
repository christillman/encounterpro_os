$PBExportHeader$u_component_outgoing_filecopy.sru
forward
global type u_component_outgoing_filecopy from u_component_outgoing
end type
end forward

global type u_component_outgoing_filecopy from u_component_outgoing
end type
global u_component_outgoing_filecopy u_component_outgoing_filecopy

type variables
string hold_bills_address
boolean hold_outgoing = false
end variables

forward prototypes
protected function integer xx_send_file (string ps_filename, string ps_address)
protected function integer xx_initialize ()
public function integer timer_ding ()
end prototypes

protected function integer xx_send_file (string ps_filename, string ps_address);integer li_sts,li_rtn
long ll_next_counter
string ls_temp,ls_copy_to,ls_filename
long ll_pos
blob lblb_message

SELECTBLOB message
INTO :lblb_message
FROM o_Message_Log
WHERE message_id = :message_id
USING cprdb;
if not cprdb.check() then return -1
if cprdb.sqlcode = 100 then
	mylog.log(this, "u_component_outgoing_filecopy.xx_send_file.0014", "Message log record not found when getting message(" + string(message_id) + ")", 4)
	return -1
end if

// to assure more uniqueness, Construct the filename using a component counter
ll_next_counter = next_component_counter("file_number")
if ll_next_counter > 0 then
	ps_address = reverse(ps_address)
	ll_pos = pos(ps_address,".")
	If ll_pos > 0 then
		ls_filename = mid(ps_address,1,ll_pos) + string(ll_next_counter) + mid(ps_address,ll_pos+1)
		ps_address = reverse(ls_filename)
	End If
end if
mylog.log(this,"u_component_outgoing_filecopy.xx_send_file.0028","write to "+ps_address,1)

li_sts = mylog.file_write(lblb_message, ps_address)
// Save a copy of the file
If len(hold_bills_address) > 0 and hold_outgoing Then
	If mylog.of_directoryexists(hold_bills_address) Then
		if ll_next_counter > 0 then
			ls_temp = string(ll_next_counter)+".txt"
			ls_copy_to = hold_bills_address + ls_temp
			li_rtn = mylog.file_copy(ps_filename,ls_copy_to)
			if li_rtn < 1 Then
				mylog.log(this, "u_component_outgoing_filecopy.xx_send_file.0039", "Saving a copy of outgoing file ("+ps_filename+") failed.", 3)
			End If
		else
			mylog.log(this, "u_component_outgoing_filecopy.xx_send_file.0042", "Error getting next file number", 4)
		end if
	Else
		mylog.log(this, "u_component_outgoing_filecopy.xx_send_file.0039", "Saving a copy of outgoing file failed. Directory ("+hold_bills_address+") not found.", 3)
	End If
End If

return li_sts
end function

protected function integer xx_initialize ();string ls_hold_bills
get_attribute("hold_bills", ls_hold_bills)
ls_hold_bills = Left(upper(ls_hold_bills),1)
If ls_hold_bills = 'Y' OR ls_hold_bills = 'T' Then 
	hold_outgoing = true
else
	hold_outgoing = false
end if
if not hold_outgoing then
	log.log(this,"u_component_outgoing_filecopy.xx_initialize.0010","Saving outgoing message not enabled; To enable set Attribute = 'hold_bills' Value = 'Y' FOR Component = 'trn_out_filecopy'.",3)
	hold_outgoing = false
End If

get_attribute("hold_bills_directory", hold_bills_address)
If len(hold_bills_address) = 0 Then 
	log.log(this,"u_component_outgoing_filecopy.xx_initialize.0010","WARNING: Saving outgoing message not enabled; To enable set Attribute = 'hold_outgoing_directory' Value = '<enter valid dir>' FOR Component = 'trn_out_filecopy'.",3)
	Setnull(hold_bills_address)
Else
	if right(hold_bills_address,1) <> "\" Then hold_bills_address += "\"
	log.log(this,"u_component_outgoing_filecopy.xx_initialize.0010","save outgoing at "+hold_bills_address,1)
End If


set_timer() 
Return 1
end function

public function integer timer_ding ();//long 			ll_message_id
//integer		i,li_rtn,li_sts
//string 		ls_message_type
//long 			ll_subscription_id,ll_count
//u_ds_data	luo_data
//
//luo_data = CREATE u_ds_data
//luo_data.set_dataobject("dw_messages_to_send", cprdb)
//ll_count = luo_data.retrieve()
//
//If ll_count > 0 Then
//	For i = 1 to ll_count
//		mylog.log(this,"timer_ding()","sending charges begin ",1)
//
//		ll_message_id = luo_data.object.message_id[i]
//		ls_message_type = luo_data.object.message_type[i]
//		ll_subscription_id = luo_data.object.subscription_id[i]
//
//		mylog.log(this, "u_component_outgoing_filecopy.xx_send_file.0039", "Retrying message #" + string(ll_message_id), 1)
//		
//		li_sts = send_file(ll_message_id)
//		IF li_sts <= 0 THEN
//			log.log(this, "timer_ding()", "Error sending (" + string(ll_message_id) + ")", 4)
//		END IF
//	NEXT
//	li_rtn = 2
//Else
//	li_rtn = 1
//End If
//DESTROY luo_data
//
Return 1

end function

on u_component_outgoing_filecopy.create
call super::create
end on

on u_component_outgoing_filecopy.destroy
call super::destroy
end on

