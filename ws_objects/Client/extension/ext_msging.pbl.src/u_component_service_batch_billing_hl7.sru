$PBExportHeader$u_component_service_batch_billing_hl7.sru
forward
global type u_component_service_batch_billing_hl7 from u_component_service
end type
end forward

global type u_component_service_batch_billing_hl7 from u_component_service
end type
global u_component_service_batch_billing_hl7 u_component_service_batch_billing_hl7

type variables
string message_type
string sending_application,sending_facility
string receving_application,receving_facility
string processing_id,version_no
string recv_app_path
string corporate_id
string department_code
string group_number
string division_number,hospital_number
string bom,eom
string billing_area_code,billing_location
string encounter_owner
string hold_outgoing
long   il_msg_count,il_msh_count
long	 il_unit,il_procedure_count
string TextEncoding
end variables

forward prototypes
protected function integer xx_initialize ()
public function integer xx_do_service ()
public function string get_shands_hl7 (long pl_message_id, string ps_message)
end prototypes

protected function integer xx_initialize ();get_attribute("message_type",message_type)
if isnull(message_type) then message_type = "ENCOUNTERPRO_CHECKOUT"

get_attribute("receiving_app_path", recv_app_path)
if isnull(recv_app_path) or recv_app_path = '' then
	mylog.log(this, "xx_initialize", "recev app path is not specified", 4)
	return -1
end if	

get_attribute("sending_application", sending_application)
get_attribute("receving_application", receving_application)
get_attribute("sending_facility",sending_facility)
get_attribute("receving_facility", receving_facility)
get_attribute("bom", bom)
get_attribute("eom", eom)
get_attribute("processing_id",processing_id)
if isnull(processing_id) then processing_id = "P"
get_attribute("version",version_no)
if isnull(version_no) then version_no = "2.2"
get_attribute("corporate_id",corporate_id)
if isnull(corporate_id) then corporate_id=""
get_attribute("department_code",department_code)
if isnull(department_code) then department_code=""
get_attribute("group_number",group_number)
if isnull(group_number) then group_number = ""
get_attribute("division_number",division_number)
get_attribute("hospital_number",hospital_number)
get_attribute("billing_area_code",billing_area_code)
if isnull(billing_area_code) then billing_area_code=""
get_attribute("billing_location",billing_location)
if isnull(billing_location) then billing_location = ""
get_attribute("hold_outgoing",hold_outgoing)

get_attribute("TextEncoding", TextEncoding)

return 1

end function

public function integer xx_do_service ();string			ls_text
string			ls_path,ls_filename
string			ls_hl7
string			ls_batch_message,ls_batch_header,ls_batch_trailer,ls_batch
string			ls_segment_break = "~h0D"
string			ls_date
string			ls_msg_count
string			ls_message,ls_line_break = '~013'
string			ls_msg_type
string			ls_cpr_id
string			ls_null,ls_service,ls_status
long				ll_count,ll_encounter_id,ll_completed
long				ll_patient_workplan_item_id
long				ll_message_id,ll_pos
long				ll_msg_count,ll_batch_total
integer			li_rtn,i,li_sts,li_retry_delay_seconds
datetime			ldt_not_started_since,ldt_begin_date
blob				lblb_message,lblb_bill,lblb_text
u_ds_data		luo_data


// loop thru all the #BILL jobs
ldt_not_started_since = datetime(today(), relativetime(now(), -li_retry_delay_seconds))

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_todo_list", cprdb)

ll_count = luo_data.retrieve(current_user.user_id, ls_null, "%")

ll_completed = 0

ll_count = luo_data.rowcount()

for i = 1 to ll_count
	ls_service = luo_data.object.service[i]
	ll_patient_workplan_item_id = luo_data.object.patient_workplan_item_id[i]

	// Skip any item which was started too recently, except for the "Wait" service, which should always be attempted
	ldt_begin_date = luo_data.object.begin_date[i]
	if ldt_begin_date > ldt_not_started_since then 
		log.log(this,"do_todo_services()","Started recently!! so skipping workplan item id ("+string(ll_patient_workplan_item_id)+")",1)
		continue
	end if
	
	// Since the completion of previous items in the queue might
	// have affected this item, make sure this item is still pending
	SELECT status
	INTO :ls_status
	FROM p_Patient_WP_Item
	WHERE patient_workplan_item_id = :ll_patient_workplan_item_id
	USING cprdb;
	if not cprdb.check() then
		DESTROY luo_data
		return -1
	end if
	
	if upper(ls_status) = "DISPATCHED" or upper(ls_status) = "STARTED" then
		li_sts = service_list.do_service(ll_patient_workplan_item_id)
		if li_sts > 0 then
			ll_completed += 1
		end if
	end if
next

// the charge messages queued up as batch_mode = 'Y' only for shands
// system. the following code is specific to shands billing export file.
luo_data = CREATE u_ds_data

luo_data.set_dataobject("dw_send_batch", cprdb)
ll_count = luo_data.retrieve(message_type)
if luo_data.rowcount() = 0 then return 1 // no records

il_msh_count = 0
il_unit = 0

FOR i = 1 to ll_count
	ll_message_id = luo_data.object.message_id[i]
	
	SELECTBLOB message
	INTO :lblb_message
	FROM o_Message_Log
	WHERE message_id = :ll_message_id
	USING cprdb;
	
	SELECT cpr_id,
		encounter_id
		INTO :ls_cpr_id,
			:ll_encounter_id
	FROM o_message_log
	where message_id = :ll_message_id
	USING cprdb;
	
	SELECT attending_doctor
	INTO :encounter_owner
	FROM p_Patient_Encounter
	WHERE cpr_id = :ls_cpr_id
	AND encounter_id = :ll_encounter_id
	USING cprdb;
	
	IF not tf_check() then
	end if
	ls_message = f_blob_to_string(lblb_message)
	mylog.log(this, "xx_do_service", "billing message string1: "+ls_message, 1)	
	ll_pos = POS(ls_message,ls_line_break)
	if isnull(ll_pos) or ll_pos = 0 then
		mylog.log(this, "xx_do_service", "message type not found ", 4)	
		return -1
	end if

	ls_msg_type = Mid(ls_message,1,ll_pos - 1)
	ls_message = Mid(ls_message,ll_pos + 1)
	ll_pos = POS(ls_message,ls_line_break)
	if isnull(ll_pos) or ll_pos = 0 then
		mylog.log(this, "xx_do_service", "message count not found ", 4)	
		return -1
	end if

	ls_msg_count = Mid(ls_message,1,ll_pos - 1)
	if not isnumber(ls_msg_count) then
		mylog.log(this, "xx_do_service", "message count not numeric", 3)	
		return -1
	end if
	il_msg_count = integer(ls_msg_count)
	if il_msg_count < 1 then return -1

	ls_message = Mid(ls_message,ll_pos + 1)
	mylog.log(this, "xx_do_service", "billing message string2: "+ls_message, 1)	
	if (ls_msg_type = "HL7DFTP03") Then
		mylog.log(this, "xx_do_service", "message count "+string(ll_msg_count), 1)	
		// ugly fix..somehow extra linebreak is included for few cases
		if left(ls_message,1) = "~013"  then	ls_message = Mid(ls_message,ll_pos + 1)
		mylog.log(this, "xx_do_service", "billing message string3: "+ls_message , 1)	
	else
		mylog.log(this, "xx_do_service", "message type not known " + ls_msg_type, 4)	
		return -1
	end if
	ls_hl7 = get_shands_hl7(ll_message_id,ls_message)
	if not isnull(ls_hl7) and len(ls_HL7) > 0 then
		ls_batch += ls_hl7
		il_msh_count++
	end if
NEXT
if isnull(ls_batch) or len(ls_batch) = 0 then 
	mylog.log(this, "xx_do_service", "Billing Failed:batch is null or empty", 4)	
	return -1 // error 
end if

/********************
* BHS (Batch Header)
*********************/
// add batch header
ls_batch_header = "BHS|^~~\&||"
if not isnull(sending_facility) then
	ls_batch_header += sending_facility
end if
ls_batch_header += "|||"
ls_batch_header += string(today(),"yyyymmdd")+"|"

//batch security & batch name
ls_batch_header += "||CHG|SURGERY|"

/********************
* BTS (Batch Trailer
*********************/
ll_batch_total = il_msh_count + 2 // bhs,bts
if isnull(ll_batch_total)  then ll_batch_total = 0
if isnull(il_unit) then il_unit = 0
if isnull(il_msg_count) then il_msh_count = 0
ls_batch_trailer = "BTS|"+string(il_msh_count)+"||"+string(ll_batch_total)+"^"+string(il_unit)

/********************
* Batch Message
*********************/

// Beginning of Message
if not isnull(bom) then ls_batch_message = bom

ls_batch_message += ls_batch_header+ls_segment_break+ls_batch+ls_batch_trailer

// End of Message
if not isnull(eom) then ls_batch_message += eom

if isnull(ls_batch_message) or len(ls_batch_message) = 0 then 
	mylog.log(this, "xx_do_service", "Billing Failed:batch message is null or empty", 4)	
	return -1 // error 
end if

lblb_bill = f_string_to_blob(ls_batch_message, TextEncoding)

// write to a file
ls_path = recv_app_path
if right(recv_app_path, 1) <> "\" then ls_path += "\"

ls_filename = ls_path + "SU" + string(today(),"mmddyy") + ".HL7"

if fileexists(ls_filename) then
	mylog.log(this, "lcr_report()", "Error getting next file number", 4)
	return -1
end if

if mylog.file_write(lblb_bill,ls_filename) < 0 then
	mylog.log(this, "lcr_report()", "Error writing the report into a file", 4)
end if

// Write another text file as below
ls_text = "Burn Clinic Charge File Created on: "+string(today(),"mmddyy")+ls_line_break
ls_text +="Total Transactions included in the file: "+string(il_procedure_count)

ls_filename = ls_path + "SU" + string(today(),"mmddyy") + ".TXT"
if fileexists(ls_filename) then
	mylog.log(this, "lcr_report()", "Error getting next file number", 4)
	return -1
end if
lblb_text = f_string_to_blob(ls_text, TextEncoding)
if mylog.file_write(lblb_text,ls_filename) < 0 then
	mylog.log(this, "lcr_report()", "Error writing the report into a file", 4)
end if

// save a copy of the message
if not isnull(hold_outgoing) then
	ls_path = hold_outgoing
	if right(hold_outgoing, 1) <> "\" then ls_path += "\"

	ls_filename = ls_path + "SU" + string(today(),"mmddyy") + ".TXT"

	if fileexists(ls_filename) then
		mylog.log(this, "lcr_report()", "Error getting next file number", 4)
		return -1
	end if

	if mylog.file_write(lblb_bill,ls_filename) < 0 then
		mylog.log(this, "lcr_report()", "Error writing the report into a file", 4)
	end if

	ls_filename = ls_path + "SU" + string(today(),"mmddyy") + ".TXT"
	if fileexists(ls_filename) then
		mylog.log(this, "lcr_report()", "Error getting next file number", 4)
		return -1
	end if
	if mylog.file_write(lblb_text,ls_filename) < 0 then
		mylog.log(this, "lcr_report()", "Error writing the report into a file", 4)
	end if

end if

GarbageCollectSetTimeLimit(0)
GarbageCollect()

Return 1
end function

public function string get_shands_hl7 (long pl_message_id, string ps_message);/*******************************************************************************
*
* Description: HL7 P03 - Constructed for Shands as per their specs
*
* Returns : 
*
********************************************************************************/
STRING	ls_icd
STRING	ls_encounter_owner
STRING	ls_proc_description
STRING	ls_hl7
STRING   ls_msg_control_id
STRING	ls_zft
STRING	ls_msh,ls_evn,ls_pid,ls_pv1,ls_ft
STRING	ls_tab='~t', ls_line_break = '~013',ls_segment_break = "~h0D"
STRING	ls_null,ls_error
STRING	ls_cpt_assemblies
STRING   ls_fields[]
STRING	ls_facility
STRING	ls_destination
STRING 	ls_internal_id
STRING 	ls_external_id
STRING 	ls_encounter_date
STRING 	ls_attending_provider_id
STRING	ls_provider
STRING 	ls_visitnumber_id
STRING 	ls_alternatevisitid_id
STRING 	ls_family
STRING 	ls_given
STRING 	ls_middle
STRING 	ls_suffix
STRING 	ls_prefix
STRING 	ls_degree
STRING 	ls_dfamily
STRING 	ls_dgiven
STRING 	ls_dmiddle
STRING 	ls_dsuffix
STRING 	ls_dprefix
STRING 	ls_ddegree
STRING 	ls_sdfamily
STRING 	ls_sdgiven
STRING 	ls_sdmiddle
STRING 	ls_sdsuffix
STRING 	ls_sdprefix
STRING 	ls_sddegree
STRING   ls_dupin,ls_sdupin
STRING   ls_supervisor,ls_supervisor_code
STRING   ls_provider_check
STRING	ls_scheduledatetime
STRING	ls_temp
STRING	diagnosiscodeidentifier[],diagnosisdescription[]
STRING	procedurecodeidentifier,ls_modifier,ls_unit
STRING   ls_message_ctrl_id
STRING   ls_datetime,ls_vertical_tab='~v'
STRING   ls_version
STRING   ls_processing_id,ls_sending_app
STRING	ls_count,ls_cpt_assembly
DATETIME ldt_datetime,ldt_encounter_datetime,ldt_scheduledatetime
DATE		ld_thisdate
TIME		lt_thistime
LONG		ll_len,ll_pos
LONG		ll_tab_pos,ll_tabnext_pos
LONG		ll_tries
INTEGER  i,j,k,m,n,li_pos
INTEGER	li_diagnosis_count,li_count
BOOLEAN	lb_same_id

setnull(ls_null)
ldt_datetime = Datetime(today(),now())
ls_datetime = string(ldt_datetime,"yyyymmdd hh:mm:ss")

ll_len = Len(ps_message)
ll_tab_pos = POS(ps_message,ls_vertical_tab)
IF ll_tab_pos > 0 THEN 
	ls_cpt_assemblies = Mid(ps_message, ll_tab_pos + 1)
	ll_len = ll_tab_pos - 1
END IF
IF ll_len = 0  OR ps_message = "" THEN
	mylog.log(this, "chrg()","MessageId: "+string(pl_message_id)+":No charge message",3)
	ls_error = "NO CHARGE"
	GOTO Error
END IF

// Parse through the string and populate array
// which contains facily,attending doctor info AND 
// first CPT & associated ICD9's.
ps_message = left(ps_message,ll_len)		
ls_temp = ps_message
j = 1;k = 1
FOR i = 1 to ll_len
	ll_pos = POS(ps_message,ls_line_break)
	if ll_pos < 2 then
		setnull(ls_fields[k])
	else	
		ls_fields[k] = mid(ps_message,1,ll_pos - 1)
	end if	
	j = ll_pos + 1
	ps_message = Mid(ps_message,j)
	if ps_message = "" then exit
	k++
NEXT

ll_len = upperbound(ls_fields)
If ll_len < 27 then
	mylog.log(this, "get_shands_hl7()", "MessageId: "+string(pl_message_id)+":Invalid Billing message count, message( "+string(ll_len)+"," + ls_temp + "), Posting failed", 4)	
	ls_error = "BAD LEN"
	GOTO Error
End If

ls_facility = ls_fields[1]
ls_destination = ls_fields[2]
ls_internal_id = ls_fields[3]
ls_external_id = ls_fields[4]
ls_encounter_date = ls_fields[5]
ls_attending_provider_id = ls_fields[6]
ls_visitnumber_id = ls_fields[7]
ls_alternatevisitid_id = ls_fields[8]
ls_family = ls_fields[9]
ls_given = ls_fields[10]
ls_middle = ls_fields[11]
ls_suffix = ls_fields[12]
ls_prefix = ls_fields[13]
ls_degree = ls_fields[14]
ls_dfamily = ls_fields[15]
ls_dgiven = ls_fields[16]
ls_dmiddle = ls_fields[17]
ls_dsuffix = ls_fields[18]
ls_dprefix = ls_fields[19]
ls_ddegree = ls_fields[20]

ls_scheduledatetime = ls_fields[21]
if ls_scheduledatetime = '' then
	ldt_scheduledatetime = ldt_datetime
else	
	ld_thisdate = Date(left(ls_scheduledatetime,10))
	lt_thistime = Time(Mid(ls_scheduledatetime,12))
	ldt_scheduledatetime = Datetime(ld_thisdate,lt_thistime)
end if	
ldt_encounter_datetime = Datetime(Date(left(ls_encounter_date,10)),Time(Mid(ls_encounter_date,12)))

procedurecodeidentifier = ls_fields[22] // procedure code
ls_modifier = ls_fields[23] // modifier
ls_unit = ls_fields[24]  //unit
if ls_unit = "" then ls_unit = "1"
ls_proc_description = ls_fields[25]
if isnull(ls_proc_description) then ls_proc_description = ""
// no. of diagnosis attached to procedure
li_diagnosis_count = integer(ls_fields[26]) 
li_count = li_diagnosis_count
for i = 1 to li_diagnosis_count
	ls_icd = ls_fields[26+i]
	li_pos = POS(ls_icd,"~t")
	diagnosiscodeidentifier[i] = mid(ls_icd,1,li_pos - 1)
	diagnosisdescription[i] = mid(ls_icd,li_pos + 1)
next	

IF isnull(procedurecodeidentifier) or procedurecodeidentifier = "" then 
	mylog.log(this, "get_shands_hl7()", "MessageId: "+string(pl_message_id)+":No Procedure, Billing message( " + ls_temp + "), Posting failed", 4)	
	ls_error = "NO PROCEDURE"
	GOTO Error
END IF

IF Isnull(ls_facility) OR ls_facility = "" then 
	mylog.log(this, "get_shands_hl7()", "No facility, assuming default " + ps_message, 3)
	SELECT value into :ls_facility
	FROM c_component_attribute
	WHERE component_id = 'ENCOUNTERPRO_BILL'
	AND attribute = 'FacilityId'
	USING cprdb;
	if not cprdb.check() then return ls_null
	if isnull(ls_facility) or ls_facility = "" then 
		mylog.log(this, "get_shands_hl7()", "MessageId: "+string(pl_message_id)+":NO Default facility,Billing message( " + ls_temp + "), Posting failed", 4)	
		ls_error = "NO FACILITY"
		GOTO Error
	end if	
END IF	

if len(ls_alternatevisitid_id) = 0 then setnull(ls_alternatevisitid_id)
if len(ls_visitnumber_id) = 0 then setnull(ls_visitnumber_id)
if ls_internal_id = "" then SetNull(ls_internal_id)
if ls_external_id = "" then SetNull(ls_external_id)
if ls_family = "" then SetNull(ls_family)
if ls_given = "" then SetNull(ls_given)
if ls_middle = "" then SetNull(ls_middle)
if ls_suffix = "" then SetNull(ls_suffix)
if ls_prefix = "" then SetNull(ls_prefix)
if ls_degree = "" then SetNull(ls_degree)

if ls_attending_provider_id = "" then 
	SetNull(ls_attending_provider_id)
	Setnull(ls_provider)
Else
	ls_provider = ls_attending_provider_id
end if	

SELECT 	supervisor_user_id,
				user_id,
				first_name,
				middle_name,
				last_name,
				degree,
				name_prefix,
				name_suffix,
				UPIN
	INTO  	:ls_supervisor,
				:ls_provider_check,
				:ls_dgiven,
				:ls_dmiddle,
				:ls_dfamily,
				:ls_ddegree,
				:ls_dprefix,
				:ls_dsuffix,
				:ls_dUPIN
	FROM c_User
	WHERE billing_id = :ls_provider
	USING cprdb;
	if not cprdb.check() OR cprdb.sqlcode = 100 then
		mylog.log(this, "get_shands_hl7()", "MessageId: "+string(pl_message_id)+":Billing failed.Invalid Provider " + ls_provider, 4)	
		ls_error = "NO PROVIDER"
		GOTO Error
	end if

IF not isnull(encounter_owner) then
	SELECT 	billing_id
		INTO 	:ls_encounter_owner
	FROM c_User
	WHERE user_id = :encounter_owner
	USING cprdb;
	
END IF
	
if ls_dfamily = "" then SetNull(ls_dfamily)
if ls_dgiven = "" then SetNull(ls_dgiven)
if ls_dmiddle = "" then SetNull(ls_dmiddle)
if ls_dsuffix = "" then SetNull(ls_dsuffix)
if ls_dprefix = "" then SetNull(ls_dprefix)
if ls_ddegree = "" then SetNull(ls_ddegree)
if ls_dUPIN = "" then SetNull(ls_dUPIN)

if ls_sdfamily = "" then SetNull(ls_sdfamily)
if ls_sdgiven = "" then SetNull(ls_sdgiven)
if ls_sdmiddle = "" then SetNull(ls_sdmiddle)
if ls_sdsuffix = "" then SetNull(ls_sdsuffix)
if ls_sdprefix = "" then SetNull(ls_sdprefix)
if ls_sddegree = "" then SetNull(ls_sddegree)
if ls_sdUPIN = "" then SetNull(ls_sdUPIN)
	
SELECT convert(varchar(38),id),
		tries
INTO :ls_message_ctrl_id,
		:ll_tries
FROM o_message_log
WHERE message_id = :pl_message_id;
if not tf_check() then return ls_null

/**********
* MessageHeader Segment
***********/

ls_msh = "MSH|^~~\&|"
if not isnull(sending_application) then
	ls_msh += sending_application
end if
ls_msh += "|"
if not isnull(sending_facility) then
	ls_msh += sending_facility // sending facility
end if
ls_msh += "|"
ls_msh += "|" // receving app
ls_msh += "|" // receving facility
ls_msh += ls_datetime+"|" // message date time
ls_msh += "|" // security
ls_msh += "DFT^P03"+"|" // message type
ls_msh += ls_msg_control_id+"|" //message control id
ls_msh += processing_id+"|" //"P" Production or "T" Testing
ls_msh += version_no+"|"

mylog.log(this, "get_shands_hl7()", "message header "+ls_msh, 1)	

/**********
* EventType Segment
***********/
ls_evn = "EVN|P03|"+string(today(),"yyyymmdd")+"|"

mylog.log(this, "get_shands_hl7()", "event header "+ls_evn, 1)	
/**********
* Patient Identification Segment (PID)
***********/
ls_pid = "PID|0001|"

// External Patient Identifier (MRN)
if not isnull(ls_external_id) then
//	ls_pid += ls_external_id
end if
ls_pid += "|"

// Internal Patient Identifier (MRN no.)
if not isnull(ls_external_id) then
	ls_pid += ls_external_id
end if	
ls_pid += "|"


// Alternate Patient ID - "UFL^[corporate id]
ls_pid += "UFL"
ls_pid += "|" 

// Patient Name
if not isnull(ls_family) then
	ls_pid +=  ls_family
else
	ls_pv1 += "^"
end if	
if not isnull(ls_given) then
	ls_pid += "^"+ls_given
else
	ls_pid += "^"
end if
if not isnull(ls_middle) then
	ls_pid += "^"+ls_middle
end if
ls_pid += "|"

mylog.log(this, "get_shands_hl7()", "patient identification header "+ls_pid, 1)	

/**********
* Patient Visit Segment (PV1)
***********/
ls_pv1 = "PV1|0001|"
ls_pv1 += "|"
ls_pv1 += "|" //assigned patient location
ls_pv1 += "|" // admission type
ls_pv1 += "|" // preadmit type
ls_pv1 += "|" // prior location

//attending doctor
ls_pv1 += "|"
ls_pv1 += "|||||||||||"
mylog.log(this, "get_shands_hl7()", "encounterpro visitnumber. " + ls_visitnumber_id , 2)
If not isnull(ls_visitnumber_id) Then
	ls_pv1 += ls_visitnumber_id + "|"
else
	ls_pv1 += "|"
End If
ls_pv1 += "||||||||||||||||||||||||"
// admit date time
ls_pv1 += string(ldt_encounter_datetime,"yyyymmdd")+"|"

//discharge date time
mylog.log(this, "get_shands_hl7()", "patient visit " + ls_pv1, 1)

/**********
* Financial Transaction Segment (FT1)
***********/
ls_ft = "FT1|0001|"
ls_ft += "1|" // transaction id
ls_ft += "|" // transaction batch id
ls_ft += string(ldt_encounter_datetime,"yyyymmdd")+"|" // transaction date
ls_ft += string(ldt_datetime,"yyyymmdd")+"|" //posting date
ls_ft += "1|" // 1- charge 2-credit
ls_ft += procedurecodeidentifier+"|"
il_procedure_count++
ls_ft += "||" // procedure description and alternate description
if isnull(ls_unit) then ls_unit = "1"
ls_ft += ls_unit+"|" // transaction quantity
il_unit++
ls_ft += "||"
ls_ft += billing_area_code+"|" //department code [IDX billing area]
ls_ft += "||"
ls_ft += billing_location+"|" // billing location [IDX Billing location]
ls_ft += "||"
// diagnosis code
IF li_diagnosis_count > 0 THEN
	ls_ft += diagnosiscodeidentifier[1]
	For i = 2 to li_diagnosis_count
		ls_ft += "^"+diagnosiscodeidentifier[i]
	Next
	ls_ft += "|"
Else
	mylog.log(this, "get_shands_hl7()", "no diagnosis attached to cpt "+procedurecodeidentifier + ls_pv1, 3)
	ls_ft += "|"
End If	

// ordered by
if not isnull(ls_provider) then
	ls_ft += ls_provider
end if
ls_ft += "|"
// performed by
ls_ft += "|"
ls_ft += ls_segment_break

/*********************
* ZFT - Addl Charge Information
**********************/
ls_zft = "ZFT|0001|"
ls_zft += group_number+"|"
// procedurecode modifier
if not isnull(ls_modifier) then
	ls_zft += ls_modifier
end if
ls_zft += "|"
// division number
if not isnull(division_number) then
	ls_zft += division_number
end if
ls_zft += "|"
// hospital number
if not isnull(hospital_number) then
	ls_zft += hospital_number
end if
ls_zft += "||||||||||||"

// secondary provider
// if encounter owner and supervising doctor then
// send the encounter owner in ZFT
if not isnull(ls_encounter_owner) and ls_encounter_owner <> ls_provider then
	ls_zft += ls_encounter_owner
else
	ls_zft += "222"
end if

ls_zft += "|"
ls_zft += ls_segment_break

ls_ft += ls_zft
mylog.log(this, "get_shands_hl7()", "FT1/ZFT(1) " + ls_ft, 1)

IF il_msg_count > 1 THEN
	FOR i = 1 TO 11
		setnull(ls_fields[i])
	NEXT	
	FOR m = 2 TO il_msg_count
		FOR i = 1 TO 11
			setnull(ls_fields[i])
		NEXT
		if ls_cpt_assemblies = '' then exit
		ll_tabnext_pos = POS(ls_cpt_assemblies,ls_vertical_tab)
		ll_len = ll_tabnext_pos - 1
		ls_cpt_assembly = left(ls_cpt_assemblies,ll_len)
		k = 1
		for i = 1 to ll_len
			ll_pos = POS(ls_cpt_assembly,ls_line_break)
			if ll_pos > 1 then ls_fields[k] = mid(ls_cpt_assembly,1,ll_pos - 1)
			j = ll_pos + 1
			ls_cpt_assembly = mid(ls_cpt_assembly,j)
			if ls_cpt_assembly = "" then exit
			k++
		next	
		procedurecodeidentifier = ls_fields[1]
		if isnull(procedurecodeidentifier) or procedurecodeidentifier = "" then continue
		ls_modifier = ls_fields[2] // modifier
		ls_unit = ls_fields[3]  //unit
		if ls_unit = "" then ls_unit = "1"
		ls_proc_description = ls_fields[4]
		if isnull(ls_proc_description) then ls_proc_description = ""
		li_diagnosis_count = integer(ls_fields[5]) // no. of diagnosis attached to procedure
		li_count = li_diagnosis_count
		for i = 1 to li_diagnosis_count
			ls_icd = ls_fields[5+i]
			li_pos = POS(ls_icd,"~t")
			diagnosiscodeidentifier[i] = mid(ls_icd,1,li_pos - 1)
			diagnosisdescription[i] = mid(ls_icd,li_pos + 1)
		next	
		for i = li_count to 1 step -1
			if diagnosiscodeidentifier[i] = "" or isnull(diagnosiscodeidentifier[i]) then 
				li_diagnosis_count --
			end if	
		next
		n = m - 1
		ls_count = string(m)
		ls_ft += "FT1|0001|"
		ls_ft += "1|" // transaction id
		ls_ft += "|" // transaction batch id
		ls_ft += string(ldt_encounter_datetime,"yyyymmdd")+"|" // transaction date
		ls_ft += string(ldt_datetime,"yyyymmdd")+"|" //posting date
		ls_ft += "1|" // 1- charge 2-credit
		ls_ft += procedurecodeidentifier+"|"
		il_procedure_count++
		ls_ft += "||" // procedure description and alternate description
		if isnull(ls_unit) then ls_unit = "1"
		ls_ft += ls_unit+"|" // transaction quantity
		il_unit++
		ls_ft += "||"
		ls_ft += billing_area_code+"|" //department code[IDX billing area]
		ls_ft += "||"
		ls_ft += billing_location+"|" // billing location [IDX Billing location]
		ls_ft += "||"
		// diagnosis code
		IF li_diagnosis_count > 0 THEN
			ls_ft += diagnosiscodeidentifier[1]
			For i = 2 to li_diagnosis_count
				ls_ft += "^"+diagnosiscodeidentifier[i]
			Next
			ls_ft += "|"
		Else
			mylog.log(this, "get_shands_hl7()", "no diagnosis attached to cpt "+procedurecodeidentifier + ls_pv1, 3)
			ls_ft += "|"
		End If	

		// ordered by
		if not isnull(ls_provider) then
			ls_ft += ls_provider
		end if
		ls_ft += "|"
		// performed by
		ls_ft += "|"
		ls_ft += ls_segment_break
	
		/*********************
		* ZFT - Addl Charge Information
		**********************/
		ls_zft = "ZFT|0001|"
		ls_zft += group_number+"|"
		// procedurecode modifier
		if not isnull(ls_modifier) then
			ls_zft += ls_modifier
		end if
		ls_zft += "|"
		// division number
		if not isnull(division_number) then
			ls_zft += division_number
		end if
		ls_zft += "|"
		// hospital number
		if not isnull(hospital_number) then
			ls_zft += hospital_number
		end if
		ls_zft += "||||||||||||"
		// secondary provider
		// if encounter owner and supervising doctor then
		// send the encounter owner in ZFT
		if not isnull(ls_encounter_owner) and ls_encounter_owner <> ls_provider then
			ls_zft += ls_encounter_owner
		else
			ls_zft += "222"
		end if

		ls_zft += "|"
		ls_zft += ls_segment_break
		
		ls_ft += ls_zft
		mylog.log(this, "get_shands_hl7()", "FT1/ZFT("+ls_count+") " + ls_ft, 1)
		ls_cpt_assemblies = Mid(ls_cpt_assemblies,ll_tabnext_pos + 1)
	NEXT
END IF

// now put together all
ls_hl7 = ls_msh+ls_segment_break+ls_evn+ls_segment_break+ls_pid+ls_segment_break+ls_pv1+ls_segment_break+ls_ft
mylog.log(this, "get_shands_hl7()", "Charge message ("+string(pl_message_id)+") " + ls_hl7, 1)

UPDATE o_Message_Log
SET status = 'ACK_WAIT',
tries = :ll_tries
WHERE message_id = :pl_message_id
USING cprdb;
if not cprdb.check() then return ls_null


GarbageCollectSetTimeLimit(0)
GarbageCollect()

Return ls_hl7
error:
f_posting_failed(pl_message_id,ls_error)
Return ls_null
end function

on u_component_service_batch_billing_hl7.create
call super::create
end on

on u_component_service_batch_billing_hl7.destroy
call super::destroy
end on

