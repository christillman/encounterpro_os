$PBExportHeader$u_component_send_report_lcr.sru
forward
global type u_component_send_report_lcr from u_component_send_report
end type
end forward

global type u_component_send_report_lcr from u_component_send_report
end type
global u_component_send_report_lcr u_component_send_report_lcr

type variables

end variables

forward prototypes
public function integer xx_sendreport ()
protected function integer xx_initialize ()
end prototypes

public function integer xx_sendreport ();integer		li_sts
String		ls_cpr_id
String		ls_report_text
String		ls_line_break = "~013"
String		ls_message_type
String		ls_record
String		ls_sending_facility,ls_sending_app
String		ls_observation_id,ls_internal_id
String		ls_external_id,ls_first_name,ls_last_name,ls_middle_name
String		ls_encounter_datetime,ls_cont_pointer
long			ll_encounter_id,ll_lines
datetime		ldt_encounter_datetime
boolean		lb_loop = false
long ll_pos,ll_linecount,ll_cont_pointer,ll_prev_pointer,ll_line,ll_pos1
string ls_report_line,ls_text,ls_temp,ls_temp1
string ls_prev_pointer,ls_reverse,ls_cont

u_component_messageserver luo_messageserver

ls_cpr_id = current_service.cpr_id
if isnull(ls_cpr_id) then
	log.log(this,"u_component_send_report_lcr.xx_sendreport:0022","no cpr id",4)
	Return -1
end if

//get the external patient id
SELECT billing_id,
		first_name,
		last_name,
		middle_name
Into :ls_external_id,
		:ls_first_name,
		:ls_last_name,
		:ls_middle_name
FROM p_Patient
Where cpr_id = :ls_cpr_id;
If Not tf_check() Then Return -1

ll_encounter_id = current_service.encounter_id
if isnull(ls_cpr_id) then
	log.log(this,"u_component_send_report_lcr.xx_sendreport:0041","no appointment id",4)
	Return -1
end if

SELECT encounter_date
Into :ldt_encounter_datetime
FROM p_Patient_Encounter
WHERE cpr_id = :ls_cpr_id
AND encounter_id = :ll_encounter_id;
if not tf_check() then return -1

if isnull(ls_external_id) or len(ls_external_id) = 0 then
	log.log(this,"u_component_send_report_lcr.xx_sendreport:0053","NO billing id:LCR Report for appointment ("+ls_cpr_id+","+string(ll_encounter_id)+") failed ",4)
	return -1	
end if

if isnull(ls_first_name) then ls_first_name = ""
if isnull(ls_last_name) then ls_last_name = ""
if isnull(ls_middle_name) then ls_middle_name = ""

ls_observation_id = get_attribute("observation_id")
if isnull(ls_observation_id) then
	ls_observation_id = "ETNOTE"
end if
ls_sending_facility = get_attribute("sending_facility")
if isnull(ls_sending_facility) then
	ls_sending_facility = "UNKNOWN"
end if
ls_sending_app = get_attribute("sending_application")
if isnull(ls_sending_app) then
	ls_sending_app = "EPRO"
end if


if isnull(display_script_id) or display_script_id = 0 then
	display_script_id = 11 // default encounter report script id
end if
rte.display_script(display_script_id)

ls_report_text = rte.get_text()
if isnull(ls_report_text) or len(ls_report_text) = 0 then
	log.log(this,"u_component_send_report_lcr.xx_sendreport:0082","ERROR: LCR Report for appointment ("+ls_cpr_id+","+string(ll_encounter_id)+") failed",4)
	Return -1
else
	log.log(this,"u_component_send_report_lcr.xx_sendreport:0085","LCR Report for appointment ("+ls_cpr_id+","+string(ll_encounter_id)+") "+ls_report_text,1)
end if

SELECT internal_id
INTO :ls_internal_id
FROM x_Encounterpro_Arrived
WHERE cpr_id = :ls_cpr_id
AND encounter_id = :ll_encounter_id;
if not tf_check() then return -1

if isnull(ls_internal_id) then ls_internal_id = ""

ls_encounter_datetime = string(ldt_encounter_datetime,"yyyymmddhhmm")

ls_record = message_type + ls_line_break 
ls_record += ls_sending_app + ls_line_break 
ls_record += ls_sending_facility + ls_line_break 
ls_record += ls_observation_id + ls_line_break
ls_record += ls_external_id + ls_line_break
ls_record += ls_internal_id + ls_line_break
ls_record += ls_first_name + ls_line_break
ls_record += ls_last_name + ls_line_break
ls_record += ls_middle_name + ls_line_break
ls_record += ls_encounter_datetime + ls_line_break

/*
Need to do some custom coding to restrict line length and no of lines per message for Shands
if any split needs to be done they all will be handled here.

Message Type
Sending Facility
Observation Identifier
Patient Billing Id
Patient Internal_Id
Patient First Name
Patient Last Name
Patient Middle Name
Encounter Date
Result Text
Continuation Pointer (if the no of lines more than 150)
*/

ll_pos = pos(ls_report_text,"~n")
do while ll_pos > 0
	ls_report_line = mid(ls_report_text,1,ll_pos - 1)
	// if each line exceeds 73 characters then split them into individual lines
	do while len(ls_report_line) >= 0
		if len(ls_report_line) <= 73 then 
			ls_text += ls_report_line + "~n"
			ll_linecount++
			exit
		end if
		// making sure lines are wrapped with words
		if mid(ls_report_line,74,1) <> " " then
			ls_reverse = reverse(left(ls_report_line,73))
			ll_pos1 = pos(ls_reverse," ")
			if ll_pos1 > 0 Then
				ls_cont = reverse(mid(ls_reverse,1,ll_pos1 - 1))
				ls_text += reverse(mid(ls_reverse,ll_pos1)) + "~n"
				ls_report_line = ls_cont + mid(ls_report_line,74)
			else
				ls_text += left(ls_report_line,73) + "~n"
				ls_report_line = mid(ls_report_line,74)
			end if
		else
			ls_text += left(ls_report_line,73) + "~n"
			ls_report_line = mid(ls_report_line,74)
		end if
		ll_linecount++
	loop
	ls_report_text = mid(ls_report_text,ll_pos + 1)
	ll_pos = pos(ls_report_text,"~n")
loop

ll_prev_pointer = 0
ll_cont_pointer = 0

// check the no. of lines in a report
If ll_linecount > 150 Then
	ll_pos = pos(ls_text,"~n")
	Do while ll_pos > 0
		ll_line = 0
		ls_temp = ""
		Do while ll_pos > 0 and ll_line < 150
			ls_temp += mid(ls_text,1,ll_pos)
			ll_line++
			ls_text = mid(ls_text,ll_pos + 1)
			ll_pos = pos(ls_text,"~n")
		Loop

		ll_prev_pointer = ll_cont_pointer
		If ll_line >= 150 then
			ll_cont_pointer++
			lb_loop = true
		Else
			ll_cont_pointer = 0
			lb_loop = false
		End If
		if ll_prev_pointer = 0 then ls_prev_pointer = "" else ls_prev_pointer = string(ll_prev_pointer)
		if ll_cont_pointer = 0 then ls_cont_pointer = "" else ls_cont_pointer = string(ll_cont_pointer)
		ls_temp1 = ls_record + ls_temp + ls_line_break
		ls_temp1 = ls_temp1 + ls_prev_pointer + ls_line_break
		ls_temp1 = ls_temp1 + ls_cont_pointer + ls_line_break
	
		If len(ls_record) > 0 Then
			log.log(this,"u_component_send_report_lcr.xx_sendreport:0190","Logging LCR report for appointment ("+ls_cpr_id+","+string(ll_encounter_id)+") "+ls_record,1)
			li_sts = log_message(ls_temp1)
		End If

		If li_sts <= 0 Then
			log.log(this,"u_component_send_report_lcr.xx_sendreport:0195","Error logging report for appointment ("+ls_cpr_id+","+string(ll_encounter_id)+") ",4)
			Return -1
		End If
			
		if not lb_loop then exit
	Loop
Else
	ls_prev_pointer = ""
	ls_cont_pointer = ""
	ls_record += ls_text + ls_line_break
	ls_record += ls_prev_pointer + ls_line_break
	ls_record += ls_cont_pointer + ls_line_break

	If len(ls_record) > 0 Then
		log.log(this,"u_component_send_report_lcr.xx_sendreport:0209","Logging LCR report for appointment ("+ls_cpr_id+","+string(ll_encounter_id)+") "+ls_record,1)
		li_sts = log_message(ls_record)
	End If

	if li_sts <= 0 then
		log.log(this,"u_component_send_report_lcr.xx_sendreport:0214","Error logging report for appointment ("+ls_cpr_id+","+string(ll_encounter_id)+") ",4)
		return -1
	end if
End If

Return 1
end function

protected function integer xx_initialize ();if isnull(message_type) or len(message_type) = 0 then message_type = 'REPORTHL7_LCR'

Return 1
end function

on u_component_send_report_lcr.create
call super::create
end on

on u_component_send_report_lcr.destroy
call super::destroy
end on

