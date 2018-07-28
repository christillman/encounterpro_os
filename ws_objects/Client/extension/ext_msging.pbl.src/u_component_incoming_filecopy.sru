$PBExportHeader$u_component_incoming_filecopy.sru
forward
global type u_component_incoming_filecopy from u_component_incoming
end type
end forward

global type u_component_incoming_filecopy from u_component_incoming
end type
global u_component_incoming_filecopy u_component_incoming_filecopy

type variables
string interface_type
string hold_incoming_address
boolean hold_incoming = false
string filename,extension
end variables

forward prototypes
public function integer xx_get_next_message (string ps_address, ref string ps_file)
protected function integer xx_initialize ()
public function integer timer_ding ()
end prototypes

public function integer xx_get_next_message (string ps_address, ref string ps_file);string ls_file

ls_file = mylog.get_first_file(ps_address)
if isnull(ls_file) then 
	mylog.log(this, "xx_get_next_message()", "no incoming messages", 1)
	return 0
else
	mylog.log(this, "xx_get_next_message()", "file " + ls_file, 1)
end if	

ps_file = ls_file


Return 1

end function

protected function integer xx_initialize ();string ls_hold_incoming

get_attribute("hold_incoming", ls_hold_incoming)
ls_hold_incoming = Left(upper(ls_hold_incoming),1)
If ls_hold_incoming = 'Y' OR ls_hold_incoming = 'T' Then 
	hold_incoming = true
else
	hold_incoming = false
end if
if not hold_incoming then
	log.log(this,"xx_initialize()","Saving incoming message not enabled; To enable set Attribute = 'hold_incoming' Value = 'Y' FOR Component = 'trn_in_filecopy'.",3)
	hold_incoming = false
End If

get_attribute("hold_incoming_directory", hold_incoming_address)
If len(hold_incoming_address) = 0 Then 
	log.log(this,"xx_initialize()","WARNING: Saving incoming message not enabled; To enable set Attribute = 'hold_incoming_directory' Value = '<enter valid dir>' FOR Component = 'trn_in_filecopy'.",3)
	Setnull(hold_incoming_address)
Else
	if right(hold_incoming_address,1) <> "\" Then hold_incoming_address += "\"
	log.log(this,"xx_initialize()","save incoming at "+hold_incoming_address,1)
End If

get_attribute("interface_type",interface_type)
if interface_type = '' then setnull(interface_type)

Return 1 
end function

public function integer timer_ding ();/***********************************************************
*
* Description: All non-hl7 systems using traditional file
* transfer mode between systems.
*
* Return : 2 - to start the timer immediate
*          1 - to start the timer after it's interval
*          -1 - Error
*          
************************************************************/

long 		ll_message_id,ll_rtn,ll_next_counter
string	ls_file,ls_file_like,ls_extension,ls_filename
string	ls_date,ls_copy_to,ls_temp
string 	ls_drive, ls_directory
integer	li_sts

f_parse_filepath(address, ls_drive, ls_directory, ls_file_like, ls_extension)
mylog.log(this, "timer_ding()", "input path " + ls_drive + " " + ls_directory, 1)

li_sts = xx_get_next_message(address, ls_file)
if li_sts < 0 then
	mylog.log(this, "timer_ding()", "Error getting message", 4)
	return -1
elseif li_sts = 0 then
	return 1 //no waiting message
end if

if isnull(ls_file) then
	mylog.log(this, "timer_ding()", "Null file name", 4)
	return -1
end if
ls_filename = ls_file
ls_file = ls_drive + ls_directory + "\" + ls_file
mylog.log(this, "timer_ding()", "file name " + ls_file, 1)

if not fileexists(ls_file) then
	mylog.log(this, "timer_ding()", "File does not exists (" + ls_file + ")", 4)
	return -1
end if

// Save a copy of the file
If len(hold_incoming_address) > 0 and hold_incoming Then
	If mylog.of_directoryexists(hold_incoming_address) Then
		// Construct the filename using a component counter
		ll_next_counter = next_component_counter("file_number")
		if ll_next_counter > 0 then
			ls_temp = "copy_" +string(ll_next_counter)+"_"+ls_filename
			ls_copy_to = hold_incoming_address + ls_temp
			ll_rtn = mylog.file_copy(ls_file,ls_copy_to)
			if ll_rtn < 1 Then
				mylog.log(this, "timer_ding()", "Saving a copy of incoming file ("+ls_file+") failed.", 3)
			End If
		else
			mylog.log(this, "xx_post_other()", "Error getting next file number", 4)
		end if
	Else
		mylog.log(this, "timer_ding()", "Saving a copy of incoming file failed. Directory ("+hold_incoming_address+") not found.", 3)
	End If
End If

ll_message_id = log_message(ls_file)
if ll_message_id <= 0 then
	mylog.log(this, "timer_ding()", "Error logging incoming message (" + ls_file + ")", 4)
	return -1
end if

li_sts = xx_set_message_received(ls_file)
if li_sts <= 0 then return -1

mylog.log(this, "timer_ding()", "File Received (" + ls_file + ")", 2)

// If we processed a message successfully, then tell the timer to ding again immediately
Return 2
end function

on u_component_incoming_filecopy.create
call super::create
end on

on u_component_incoming_filecopy.destroy
call super::destroy
end on

