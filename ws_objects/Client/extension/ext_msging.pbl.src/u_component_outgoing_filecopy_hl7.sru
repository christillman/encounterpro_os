$PBExportHeader$u_component_outgoing_filecopy_hl7.sru
forward
global type u_component_outgoing_filecopy_hl7 from u_component_outgoing
end type
type str_lab_data from structure within u_component_outgoing_filecopy_hl7
end type
type str_guarantor from structure within u_component_outgoing_filecopy_hl7
end type
type str_insurance from structure within u_component_outgoing_filecopy_hl7
end type
type str_patient from structure within u_component_outgoing_filecopy_hl7
end type
end forward

type str_lab_data from structure
	string		test_id
	string		test_desc
	string		specimen_id
	string		specimen_desc
	string		uom
	string		value
	string		location
	string		collectdate
	string		coding_id
	string		specimen_source
	string		specimen_requirement
	string		specimen_container
	string		medical_discipline
	integer		multi_count
	string		multi_tests[]
	string		multi_desc[]
	integer		diagnosis_count
	string		diagnosis[]
end type

type str_guarantor from structure
	string		grelationship
	string		ggiven
	string		gfamily
	string		gmiddle
	string		gaddr1
	string		gcity
	string		gstate
	string		gzip
end type

type str_insurance from structure
	string		iplantype
	string		ipolicy
	string		igroupnumber
	string		igroupname
	string		iworkmens_comp
	string		irelationship
	string		igiven
	string		ifamily
	string		imiddle
	string		iname
	string		iaddr1
	string		iaddr2
	string		icity
	string		istate
	string		izip
end type

type str_patient from structure
	string		external_id
	string		lab_bill_code
	string		encounter_date
	string		provider_id
	string		visitnumber_id
	string		alternatevisit_id
	string		pfamily
	string		pgiven
	string		pmiddle
	string		psuffix
	string		pprefix
	string		pbirthdate
	string		pphone
	string		psex
	string		prace
	string		dfamily
	string		dlicense
end type

global type u_component_outgoing_filecopy_hl7 from u_component_outgoing
end type
global u_component_outgoing_filecopy_hl7 u_component_outgoing_filecopy_hl7

type prototypes
Subroutine Sleep (ulong christimer) library "KERNEL32.DLL"
end prototypes

type variables
string dcom_app
string dcom_app_dest
string dcom_app_address
long dcom_app_port, il_count, il_tot_count
unsignedlong ack_wait_time
string recv_app,send_app
string send_facility,recv_facility
string billing_batch
string billing_transtype
string idx_pos
string bs_system
string dcom_source, tcp_source
string is_address
string show_cpt_icd_description
unsignedlong  ul_sleeper
integer is_msg_count, is_msg_sent
boolean ib_dcom_activ, ib_supervisorbill
boolean ib_writetofile
boolean ib_sync,ib_hold_outgoing
integer il_retry_limit
string recv_app_path,patient_identifier
string hold_outgoing
oleobject oAHC, oMsgMan
string TextEncoding
end variables

forward prototypes
protected function integer xx_shutdown ()
protected function integer xx_send_file (string ps_file, string ps_address)
public function integer xx_initialize ()
public function integer ahc_connect ()
public function integer chrg (string ps_message)
public function integer chrg_mpm (string ps_message)
public function integer timer_ding ()
public function integer ahc_disconnect ()
public function integer chrg_mckesson (string ps_message)
end prototypes

protected function integer xx_shutdown ();ahc_disconnect()
Return 1
end function

protected function integer xx_send_file (string ps_file, string ps_address);integer 				li_rtn
INTEGER 	i,li_count
STRING	msg_transport_type, msg_type, msg_count
STRING	ls_record, ls_line_break='~013', ls_return
STRING 	flatwire,ls_interval
BLOB		lblb_message
LONG		ll_pos,ll_message_id,ll_tries
datetime ldt_msg_datetime,ldt_datetime,ldt_retry_time
date ld_date
time lt_time

if ib_sync then // if synchronized
	select count(*) into :li_count
	from o_message_log
	where status = 'ACK_WAIT'
	using cprdb;
	if not cprdb.check() then return -1
	if li_count > 0 then
		SELECT min(message_id)
		INTO :ll_message_id
		FROM o_Message_Log
		WHERE status = 'ACK_WAIT'
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

ls_line_break = "~013"

garbagecollect()
mylog.log(this, "u_component_outgoing_filecopy_hl7.xx_send_file.0070", ps_address, 1)

if ps_address = "!dummy.dcom" then
	msg_transport_type = "D"
else
	msg_transport_type = "T"
	is_address = ps_address
end if	

// Read the file into a local blob
SELECTBLOB message
INTO :lblb_message
FROM o_Message_Log
WHERE message_id = :message_id
USING cprdb;
if not cprdb.check() then return -1
if cprdb.sqlcode = 100 then
	mylog.log(this, "u_component_outgoing_filecopy_hl7.xx_send_file.0087", "Message log record not found when getting message(" + string(message_id) + ")", 4)
	return -1
end if

flatwire = f_blob_to_string(lblb_message)
mylog.log(this, "u_component_outgoing_filecopy_hl7.xx_send_file.0070", "billing message string1: "+flatwire, 1)	
ll_pos = POS(flatwire,ls_line_break)
if isnull(ll_pos) or ll_pos = 0 then
	mylog.log(this, "u_component_outgoing_filecopy_hl7.xx_send_file.0070", "message type not found ", 4)	
	return -1
end if

msg_type = Mid(flatwire,1,ll_pos - 1)
flatwire = Mid(flatwire,ll_pos + 1)
ll_pos = POS(flatwire,ls_line_break)
if isnull(ll_pos) or ll_pos = 0 then
	mylog.log(this, "u_component_outgoing_filecopy_hl7.xx_send_file.0070", "message count not found ", 4)	
	return -1
end if

msg_count = Mid(flatwire,1,ll_pos - 1)
if not IsNumber(msg_count) then
	mylog.log(this, "u_component_outgoing_filecopy_hl7.xx_send_file.0070", "message count not numeric ", 4)	
	return -1
end if
is_msg_count = integer(msg_count)
if is_msg_count < 1 then return -1
flatwire = Mid(flatwire,ll_pos + 1)
mylog.log(this, "u_component_outgoing_filecopy_hl7.xx_send_file.0070", "billing message string2: "+flatwire, 1)	
if (msg_type = "HL7DFTP03") OR (msg_type = "HL7ORMO01") then
	mylog.log(this, "u_component_outgoing_filecopy_hl7.xx_send_file.0070", "message count "+string(is_msg_count), 1)	
	if left(flatwire,1) = "~013" then	flatwire = Mid(flatwire,ll_pos + 1) // ugly fix..somehow extra linebreak is included for few cases
	mylog.log(this, "u_component_outgoing_filecopy_hl7.xx_send_file.0070", "billing message string3: "+flatwire, 1)	
else
	mylog.log(this, "u_component_outgoing_filecopy_hl7.xx_send_file.0070", "message type not known " + msg_type, 4)	
	return -1
end if	

i = 1
if msg_type = "HL7DFTP03" then
	CHOOSE CASE bs_system
		CASE 'MILLBROOK'
			li_rtn = chrg_mpm(flatwire)
		CASE 'MCKESSON','PRACTICEPOINT'
			li_rtn = chrg_mckesson(flatwire)
		CASE ELSE
			li_rtn = chrg(flatwire)
	END CHOOSE 	
end if
GarbageCollectSetTimeLimit(0)
GarbageCollect()

return li_rtn
end function

public function integer xx_initialize ();integer li_rtn
string ls_retry_limit
string ls_supervisorbill
string ls_port
string ls_sleeper
string ls_ack_time
string ls_sync,ls_hold_outgoing


setnull(dcom_app)
setnull(ls_supervisorbill)
ib_dcom_activ = False
ib_supervisorbill = False
ib_hold_outgoing = false

get_attribute("patient_identifier",patient_identifier)
if isnull(patient_identifier) or len(patient_identifier) = 0 then
patient_identifier="MR"
end if	

get_attribute("dcom_source",dcom_source)
if isnull(dcom_source) then
	mylog.log(this, "u_component_outgoing_filecopy_hl7.xx_initialize.0023", "no object source.", 4)
	return -1
end if	

dcom_app = dcom_source

get_attribute("dcom_app_dest", dcom_app_dest)
if isnull(dcom_app_dest) or dcom_app_dest = '' then
	mylog.log(this, "u_component_outgoing_filecopy_hl7.xx_initialize.0023", "no object destination.", 4)
	return -1
end if	

get_attribute("ack_wait_time", ls_ack_time)
if isnumber(ls_ack_time) then
	ack_wait_time = long(ls_ack_time)
else
	setnull(ack_wait_time)
end if	


get_attribute("dcom_app_port", ls_port)
if IsNumber(ls_port) then dcom_app_port = long(ls_port)

get_attribute("dcom_app_address", dcom_app_address)
if dcom_app_port > 0 Then
	if isnull(dcom_app_address) then
		mylog.log(this, "u_component_outgoing_filecopy_hl7.xx_initialize.0023", "no destination computer address.", 4)
		return -1
	end if	
End If
get_attribute("bill_to_supervisor",ls_supervisorbill)

if upper(ls_supervisorbill) = 'YES' then
	ib_supervisorbill = True
end if	

get_attribute("billing_system",bs_system)

get_attribute("sending_app",send_app)
if isnull(send_app) then send_app="ENCOUNTERPRO"

get_attribute("sending_facility",send_facility)
if isnull(send_facility) then send_facility = ""

get_attribute("receiving_app",recv_app)
if isnull(recv_app) then recv_app=""

get_attribute("receiving_facility",recv_facility)
if isnull(recv_facility) then recv_facility = ""

get_attribute("billing_batch",billing_batch)
if isnull(billing_batch) then
	billing_batch = ''
end if

get_attribute("idx_pos",idx_pos)
if isnull(idx_pos) then
//	idx_pos = billing_facility
end if	

get_attribute("billing_transtype",billing_transtype)
if isnull(billing_transtype) then
	billing_transtype = 'CG'
end if	

get_attribute("sleeper",ls_sleeper)
if isnull(ls_sleeper) then
	ul_sleeper = 0
else
	ul_sleeper = long(ls_sleeper)
end if	

get_attribute("sync_flag",ls_sync)
ib_sync = false
if isnull(ls_sync) or ls_sync = '' then ib_sync = false
if left(upper(ls_sync),1) = 'T' then ib_sync = true
if left(upper(ls_sync),1) = 'Y' then ib_sync = true

get_attribute("hold_outgoing",ls_hold_outgoing)
if isnull(ls_hold_outgoing) or ls_hold_outgoing = '' then ib_hold_outgoing = false
if left(upper(ls_hold_outgoing),1) = 'T' then ib_hold_outgoing = true
if left(upper(ls_hold_outgoing),1) = 'Y' then ib_hold_outgoing = true

get_attribute("retry_limit",ls_retry_limit)
if isnull(ls_retry_limit) or not isnumber(ls_retry_limit) then 
	il_retry_limit = 1
else
	il_retry_limit = integer(ls_retry_limit)
end if

if not ib_hold_outgoing then
	mylog.log(this,"u_component_outgoing_filecopy_hl7.xx_initialize.0114","saving copy of the bill is disabled. To enable this set Attribute = 'hold_outgoing' Value = 'YES' FOR Component = 'trn_out_filecopy_hl7'",3)
end if

get_attribute("show_cpt_icd_description",show_cpt_icd_description)
if isnull(show_cpt_icd_description) then show_cpt_icd_description = "N"

if left(show_cpt_icd_description,1)="Y" or left(show_cpt_icd_description,1)="T" then show_cpt_icd_description = "Y"
if left(show_cpt_icd_description,1)="N" or left(show_cpt_icd_description,1)="F" then show_cpt_icd_description = "N"

get_attribute("recv_app_path", recv_app_path)
if isnull(recv_app_path) and (bs_system = "PRACTICEPOINT" or bs_system='MCKESSON') Then
	mylog.log(this, "u_component_outgoing_filecopy_hl7.xx_initialize.0023", "missing component attribute <recv_app_path>; this holds valid path name to write the charge message", 4)
	return -1
end if

get_attribute("TextEncoding", TextEncoding)

//if (bs_system <> "PRACTICEPOINT") then

	li_rtn = ahc_connect()
	If li_rtn < 0 then return -1

//end if

set_timer()
return 1
end function

public function integer ahc_connect ();INTEGER li_sts
Boolean lb_listen

// Don't do this if we've done it before
if ib_dcom_activ then return 1

lb_listen = FALSE
mylog.log(this, "u_component_outgoing_filecopy_hl7.ahc_connect.0008", "ahc_connect() - Begin", 1)

mylog.log(this, "u_component_outgoing_filecopy_hl7.ahc_connect.0008", "connecting to AHCMessager.", 1)
oAHC = CREATE oleobject
li_sts = oAHC.connecttonewobject("AHC.Messenger")
if li_sts <> 0 then
	mylog.log(this, "u_component_outgoing_filecopy_hl7.ahc_connect.0014", "ERROR: connection to AHC Messenger object failed.", 4)
	DESTROY oAHC
	setnull(oAHC)
	return -1
end if
mylog.log(this, "u_component_outgoing_filecopy_hl7.ahc_connect.0008", "connection to AHCMessager success", 1)

// Connect to AHC Messanger and returns AHC Message Manager
mylog.log(this, "u_component_outgoing_filecopy_hl7.ahc_connect.0008", "connection to IHCMessageManager object.", 1)
omsgman = oAHC.Connect(dcom_source)
If isnull(omsgman) Then
	mylog.log(this, "u_component_outgoing_filecopy_hl7.ahc_connect.0008", "ERROR: connection to IHCMessageManager object failed.", 4)
	DESTROY oMsgMan
	oAHC.Disconnect()
	DESTROY oAHC
	setnull(oMsgMan)
	Setnull(oAHC)
	return -1
end if
mylog.log(this, "u_component_outgoing_filecopy_hl7.ahc_connect.0008", "connection to IHCMessageManager object successful.", 1)

ib_dcom_activ = true
il_count = 0
mylog.log(this, "u_component_outgoing_filecopy_hl7.ahc_connect.0008", "ahc_connect() - Successful", 1)


return 1
end function

public function integer chrg (string ps_message);/*******************************************************************************
*
* Description: HL7 P03 - Constructed for all Practice management except Millbrook
*
* Returns : 
*
*
*
*
*************************************************************************************/
INTEGER	 i,j,k,m,n,li_pos
INTEGER	 li_sts, li_rtn
INTEGER	 li_diagnosis_count, li_count
BOOLEAN	 lb_same_id = False, lb_retry
ANY		 la_err
LONG		 ll_pos, ll_tab_pos, ll_tabnext_pos, ll_len, ll_tries
LONG		 ll_message_id, ll_message_size, ll_subscription_id
DATETIME  ldt_datetime, ldt_scheduledatetime,ldt_encounter_datetime
DATE		 ld_thisdate
TIME		 lt_stop_time,lt_thistime
STRING	 ls_doctor_id
STRING	 ls_icd
STRING	 ls_message_ctrl_id, ls_vertical_tab='~v', ls_line_break = '~013'
STRING	 ls_facility, ls_temp,ls_fields[]
STRING	 ls_thisdatetime,ls_billable_provider
STRING	 ls_cpt_assembly,ls_cpt_assemblies
STRING 	 ls_internal_id,ls_external_id
STRING	 ls_attending_provider_id,ls_provider
STRING 	 ls_visitnumber_id,ls_alternatevisitid_id
STRING	 ls_encounter_type,ls_destination, ls_amount
String 	 diagnosiscodeidentifier[],procedurecodeidentifier,ls_cpt_code,diagnosisdescription[]
STRING	 ls_encounter_date
STRING	 ls_given,ls_family, ls_middle, ls_degree, ls_prefix, ls_suffix 
STRING 	 ls_dgiven,ls_dfamily, ls_dmiddle, ls_ddegree, ls_dprefix, ls_dsuffix, ls_dUPIN 
STRING 	 ls_sdgiven,ls_sdfamily, ls_sdmiddle, ls_sddegree, ls_sdprefix, ls_sdsuffix, ls_sdUPIN 
STRING 	 ls_mycomposite,ls_modifier,ls_count
string 	 ls_message_type, ls_status, ls_sendfile, ls_message_compression_type
STRING 	 ls_id,ls_proc_description
STRING	 ls_supervisor,ls_provider_check,ls_message_viewer
STRING	 ls_scheduledatetime,ls_supervisor_code,ls_unit
STRING	 ls_uuid,ls_cpr_id,ls_supervising_doctor
LONG	    ll_encounter_id
OLEOBJECT omsgtype, OEnv, HL7DFTP03
string old_str
string new_str
int start_pos

// create the message type
omsgtype = CREATE oleobject
li_sts = omsgtype.connecttonewobject("AHC.MessageType")
IF li_sts <> 0 THEN
	mylog.log(this, "u_component_outgoing_filecopy_hl7.chrg.0052", "ERROR: connection to AHC messagetype object failed.", 4)
	DESTROY omsgtype
	setnull(omsgtype)
	RETURN -1
END IF
// fill out the message type with the HL7DFTP03 relevant information
omsgtype.MessageTypeCode = "DFT"
omsgtype.EventCode = "P03"
omsgtype.Version = "HL7 2.3" 	// MUST be like this!

// create the enevelope object
oEnv = CREATE oleobject
oEnv = omsgman.CreateMessage(omsgtype)
IF isnull(oenv) THEN
	mylog.log(this, "u_component_outgoing_filecopy_hl7.chrg.0052", "error in creating message envelope object ", 4)	
	RETURN -1
END IF
//Declare a message object of the type created in the previous step 
HL7DFTP03 = CREATE oleobject
//get a handle to the message content.
HL7DFTP03 = oEnv.Content
IF isnull(hl7dftp03) THEN
	mylog.log(this, "u_component_outgoing_filecopy_hl7.chrg.0052", "error in getting message type object from message envelope ", 4)	
	RETURN -1
END IF

ll_len = Len(ps_message)
ll_tab_pos = POS(ps_message,ls_vertical_tab)
IF ll_tab_pos > 0 THEN 
	ls_cpt_assemblies = Mid(ps_message, ll_tab_pos + 1)
	ll_len = ll_tab_pos - 1
END IF
IF ll_len = 0  OR ps_message = "" THEN
	mylog.log(this, "u_component_outgoing_filecopy_hl7.chrg.0052","MessageId: "+string(message_id)+":No charge message",3)
	return f_posting_failed(message_id,"NO CHARGE")
END IF

// Parse through the string and populate array
// which contains facily,attending doctor info AND 
// first CPT & associated ICD10's.
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
	mylog.log(this, "u_component_outgoing_filecopy_hl7.chrg.0052", "MessageId: "+string(message_id)+":Invalid Billing message count, message( "+string(ll_len)+"," + ls_temp + "), Posting failed", 4)	
	return f_posting_failed(message_id,"BAD LEN")
End If
ls_thisdatetime = string(today(),"yyyy/mm/dd hh:mm:ss")
ld_thisdate = Date(left(ls_thisdatetime,10))
lt_thistime = Time(Mid(ls_thisdatetime,12))
ldt_datetime = Datetime(ld_thisdate,lt_thistime)

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
if isnull(ldt_encounter_datetime) then 
	mylog.log(this, "u_component_outgoing_filecopy_hl7.chrg.0052", "MessageId: "+string(message_id)+":No Encounter Date, Billing message( " + ls_temp + "), Posting failed", 4)	
	return f_posting_failed(message_id,"NO ENCDATE")
end if
procedurecodeidentifier = ls_fields[22] // procedure code
ls_modifier = ls_fields[23] // modifier
ls_unit = ls_fields[24]  //unit
if ls_unit = "" then ls_unit = "1"
ls_proc_description = ls_fields[25]
if isnull(ls_proc_description) then ls_proc_description = ""
li_diagnosis_count = integer(ls_fields[26]) // no. of diagnosis attached to procedure
li_count = li_diagnosis_count
for i = 1 to li_diagnosis_count
	ls_icd = ls_fields[26+i]
	li_pos = POS(ls_icd,"~t")
	diagnosiscodeidentifier[i] = mid(ls_icd,1,li_pos - 1)
	diagnosisdescription[i] = mid(ls_icd,li_pos + 1)
next	

IF isnull(procedurecodeidentifier) or procedurecodeidentifier = "" then 
	mylog.log(this, "u_component_outgoing_filecopy_hl7.chrg.0052", "MessageId: "+string(message_id)+":No Procedure, Billing message( " + ls_temp + "), Posting failed", 4)	
	return f_posting_failed(message_id,"NO PROCEDURE")
END IF


// Medic does not like '/' in ls_visitnumber_id
i = Pos(ls_visitnumber_id, "/") 
if i > 0 then
	ls_visitnumber_id = left(ls_visitnumber_id, i - 1) + mid (ls_visitnumber_id, i + 1)
end if

li_rtn = 1
IF Isnull(ls_facility) then ls_facility = ""
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
	SetNull(ls_provider)
else
	//hack for medic ... for attending doc seperate out from field ??? Y?? - By Sumathi
	ll_pos = POS(ls_attending_provider_id,',')
	if ll_pos > 0 then
		ls_provider = left(ls_attending_provider_id,ll_pos - 1) + mid(ls_attending_provider_id,ll_pos + 1)
	else
		ls_provider = ls_attending_provider_id
	end if	
end if	
ls_destination = dcom_app

if ll_pos = 0 then
SELECT 	
			user_id,
			first_name,
			middle_name,
			last_name,
			degree,
			name_prefix,
			name_suffix,
			UPIN
INTO  	
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
	mylog.log(this, "u_component_outgoing_filecopy_hl7.chrg.0052", "MessageId: "+string(message_id)+":Billing failed.Invalid Provider " + ls_provider, 4)	
	return f_posting_failed(message_id,"NO PROVIDER")
end if	
	
ls_supervisor=""

// get the supervisor information from encounter record not in c_user as it might change every day
select cpr_id,encounter_id
into :ls_cpr_id,:ll_encounter_id
from o_message_log
where message_id=:message_id
Using cprdb;

if cprdb.check() and cprdb.sqlcode <> 100 then

	SELECT supervising_doctor
	into :ls_supervising_doctor
	FROM p_Patient_Encounter
	Where cpr_id=:ls_cpr_id
	and encounter_id=:ll_encounter_id
	using cprdb;
	
	if not isnull(ls_supervising_doctor) and len(ls_supervising_doctor) > 0 then
		ls_supervisor = ls_supervising_doctor

	else
		ls_supervisor = ""
	end if
end if

if isnull(ls_supervisor) or ls_supervisor = "" or ls_supervisor = ls_provider_check then
		lb_same_id = true
else
	SELECT 	first_name,
				middle_name,
				last_name,
				degree,
				name_prefix,
				name_suffix,
				UPIN,
				billing_id
	into
				:ls_sdgiven,
				:ls_sdmiddle,
				:ls_sdfamily,
				:ls_sddegree,
				:ls_sdprefix,
				:ls_sdsuffix,
				:ls_sdUPIN,
				:ls_supervisor_code
	FROM c_User
	WHERE user_id = :ls_supervisor
	USING cprdb;
	If not cprdb.check() or cprdb.sqlcode = 100 or isnull(ls_supervisor_code) then 
		mylog.log(this, "u_component_outgoing_filecopy_hl7.chrg.0052", "MessageId: "+string(message_id)+"Invalid supervisor user id " + ls_provider+". Assuming the attending doc ("+ls_provider+" is billable", 4)	
		lb_same_id = true
	End if
end if
END IF	

// Translate a provider id
ls_doctor_id = sqlca.fn_lookup_user_billingid(ls_facility,ls_provider)
if isnull(ls_doctor_id) or ls_doctor_id = "" then ls_doctor_id = ls_provider
if isnull(ls_doctor_id) then ls_doctor_id = ""
ls_provider = ls_doctor_id

// Translate a supervisor provider id
ls_doctor_id = sqlca.fn_lookup_user_billingid(ls_facility,ls_supervisor_code)
if isnull(ls_doctor_id) or ls_doctor_id = "" then ls_doctor_id = ls_supervisor_code
if isnull(ls_doctor_id) then ls_doctor_id = ""
ls_supervisor_code = ls_doctor_id

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
	
/**********
* Message Header
***********/
SELECT convert(varchar(38),id),
		tries
INTO :ls_message_ctrl_id,
		:ll_tries
FROM o_message_log
WHERE message_id = :message_id;
if not tf_check() then return -1

HL7DFTP03.MessageHeader.ProcessingID.ProcessingID.value = "P" //P = production
HL7DFTP03.MessageHeader.MessageControlID.value = ls_message_ctrl_id
If upper(bs_system)='NTERPRISE' then
	HL7DFTP03.MessageHeader.ReceivingFacility.NameSpaceID.value = ls_facility
	HL7DFTP03.MessageHeader.SendingFacility.NameSpaceID.value = ls_facility
else
	HL7DFTP03.MessageHeader.ReceivingFacility.NameSpaceID.value = recv_facility
	HL7DFTP03.MessageHeader.SendingFacility.NameSpaceID.value = send_facility
end if
HL7DFTP03.MessageHeader.SendingApplication.NameSpaceID.value = send_app
HL7DFTP03.MessageHeader.ReceivingApplication.NameSpaceID.value = recv_app
HL7DFTP03.MessageHeader.DateTimeOfMessage.value = ldt_datetime
HL7DFTP03.MessageHeader.MessageType.MessageType.value = "DFT"
HL7DFTP03.MessageHeader.MessageType.TriggerEvent.value = "P03"

/**********
* Acknowledgment
***********/
//AL=always and NE=never
HL7DFTP03.MessageHeader.ApplicationAcknowledgmentType.value = "AL"
HL7DFTP03.MessageHeader.AcceptAcknowledgmentType.value = "AL"

/**********
* EventType Segment
***********/
HL7DFTP03.EventType.EventTypeCode.value = "P03"
HL7DFTP03.EventType.RecordedDateTime.value = ldt_datetime

/**********
* Patient Identification Segment (PID)
***********/
HL7DFTP03.PatientIdentification.SetID.value = "1"
if not isnull(ls_internal_id) then
	la_err = HL7DFTP03.PatientIdentification.InternalPatientID.Add(1)
	HL7DFTP03.PatientIdentification.InternalPatientID.Item[0].ID.value = ls_internal_id
end if	
if upper(bs_system) = 'INTEGRY' then
	la_err = HL7DFTP03.PatientIdentification.InternalPatientID.Add(1)
	HL7DFTP03.PatientIdentification.InternalPatientID.Item[0].ID.value = ls_external_id

end if
if not isnull(ls_external_id) then
	HL7DFTP03.PatientIdentification.ExternalPatientID.ID.value = ls_external_id
end if
la_err = HL7DFTP03.PatientIdentification.PatientName.Add(1)
if not isnull(ls_family) then
	HL7DFTP03.PatientIdentification.PatientName.Item[0].FamilyName.value = ls_family
end if	
if not isnull(ls_given) then
	HL7DFTP03.PatientIdentification.PatientName.Item[0].GivenName.value = ls_given
end if
if not isnull(ls_middle) then
	HL7DFTP03.PatientIdentification.PatientName.Item[0].MiddleName.value = ls_middle
end if
if not isnull(ls_suffix) then
	HL7DFTP03.PatientIdentification.PatientName.Item[0].Suffix.value = ls_suffix
end if
if not isnull(ls_prefix) then
	HL7DFTP03.PatientIdentification.PatientName.Item[0].Prefix.value = ls_prefix
end if
if not isnull(ls_degree) then
	HL7DFTP03.PatientIdentification.PatientName.Item[0].Degree.value = ls_degree
end if
/**********
* Patient Visit Segment (PV1)
***********/
HL7DFTP03.PatientVisit.SetID.value = "1"
HL7DFTP03.PatientVisit.PatientClass.value = "O"
HL7DFTP03.PatientVisit.AssignedPatientLocation.PointofCare.value = "O"
HL7DFTP03.PatientVisit.AssignedPatientLocation.Facility.NamespaceID.value = ls_facility
HL7DFTP03.PatientVisit.AdmitDateTime.value = ldt_encounter_datetime
la_err = HL7DFTP03.PatientVisit.AttendingDoctor.Add(1)
If lb_same_id Then // If the provider dont have supervisor then he's the billable
	if not isnull(ls_provider) then
		HL7DFTP03.PatientVisit.Attendingdoctor.Item[0].IDNumber.value = ls_provider
	end if	
	if not isnull(ls_dfamily) then
		HL7DFTP03.PatientVisit.Attendingdoctor.Item[0].FamilyName.value = ls_dfamily
	end if
	if not isnull(ls_dgiven) then
		HL7DFTP03.PatientVisit.Attendingdoctor.Item[0].GivenName.value = ls_dgiven
	end if
	if not isnull(ls_dmiddle) then
		HL7DFTP03.PatientVisit.Attendingdoctor.Item[0].MiddleName.value = ls_dmiddle
	end if
	if not isnull(ls_dsuffix) then
		HL7DFTP03.PatientVisit.Attendingdoctor.Item[0].Suffix.value = ls_dsuffix
	end if
	if not isnull(ls_dprefix) then
		HL7DFTP03.PatientVisit.Attendingdoctor.Item[0].Prefix.value = ls_dprefix
	end if
	if not isnull(ls_ddegree) then
		HL7DFTP03.PatientVisit.Attendingdoctor.Item[0].Degree.value = ls_ddegree
	end if
Else
	if not isnull(ls_supervisor_code) then
		// If billing system is Medic then combine the supervisorcode plus original provider code
		if upper(bs_system) = 'MEDIC' then
			if isnumber(ls_provider) then // remove the leading zeros
				ls_provider = string(integer(ls_provider))
			end if
			if isnumber(ls_supervisor_code) then
				ls_supervisor_code = string(integer(ls_supervisor_code))
			end if
			
			ls_billable_provider = ls_provider + ls_supervisor_code
			if isnull(ls_billable_provider) then ls_billable_provider = ls_supervisor_code
			mylog.log(this, "u_component_outgoing_filecopy_hl7.chrg.0052", "MessageId: "+string(message_id)+"Billable Provider(PASupervisor): " + ls_billable_provider, 2)	
			HL7DFTP03.PatientVisit.Attendingdoctor.Item[0].IDNumber.value = ls_billable_provider
		else
			HL7DFTP03.PatientVisit.Attendingdoctor.Item[0].IDNumber.value = ls_supervisor_code
			mylog.log(this, "u_component_outgoing_filecopy_hl7.chrg.0052", "MessageId: "+string(message_id)+"Billable Provider: " + ls_supervisor_code, 2)	
		end if
	end if	
	if not isnull(ls_sdfamily) then
		HL7DFTP03.PatientVisit.Attendingdoctor.Item[0].FamilyName.value = ls_sdfamily
	end if
	if not isnull(ls_sdgiven) then
		HL7DFTP03.PatientVisit.Attendingdoctor.Item[0].GivenName.value = ls_sdgiven
	end if
	if not isnull(ls_sdmiddle) then
		HL7DFTP03.PatientVisit.Attendingdoctor.Item[0].MiddleName.value = ls_sdmiddle
	end if
	if not isnull(ls_sdsuffix) then
		HL7DFTP03.PatientVisit.Attendingdoctor.Item[0].Suffix.value = ls_sdsuffix
	end if
	if not isnull(ls_sdprefix) then
		HL7DFTP03.PatientVisit.Attendingdoctor.Item[0].Prefix.value = ls_sdprefix
	end if
	if not isnull(ls_sddegree) then
		HL7DFTP03.PatientVisit.Attendingdoctor.Item[0].Degree.value = ls_sddegree
	end if
End If
mylog.log(this, "u_component_outgoing_filecopy_hl7.chrg.0052", "encounterpro visitnumber. " + ls_visitnumber_id , 2)
If not isnull(ls_visitnumber_id) Then
	HL7DFTP03.PatientVisit.VisitNumber.ID.value = ls_visitnumber_id
End If
If not isnull(ls_alternatevisitid_id) Then
	HL7DFTP03.PatientVisit.AlternateVisitID.ID.value = ls_alternatevisitid_id
End If
/**********
* Financial Transaction Segment (FT1)
***********/

la_err = HL7DFTP03.FinancialTransactionGroup.Add(is_msg_count)

HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.SetID.value = "1"
HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.TransactionID.value = "1"

if billing_batch <> '' then
	HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.TransactionBatchID = billing_batch
end if	
HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.TransactionDate.value = ldt_encounter_datetime
HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.TransactionPostingDate.value = ldt_datetime
HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.TransactionType.value = billing_transtype
HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.TransactionQuantity.value = ls_unit
if upper(bs_system) = 'INTEGRY' then
	HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.TransactionCode.Identifier.value = procedurecodeidentifier
end if
HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.AssignedPatientLocation.Facility.NamespaceID.value = ls_facility
HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.AssignedPatientLocation.PointOfCare.value = ls_facility
HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.ProcedureCode.Identifier.value = procedurecodeidentifier
if show_cpt_icd_description = "Y" then
	HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.ProcedureCode.Text.value = ls_proc_description
end if
if lb_same_id then
	if not isnull(ls_provider) then
		HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.OrderedByCode.IDNumber.value = ls_provider
	end if
	if not isnull(ls_dfamily) then
		HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.OrderedByCode.FamilyName.value = ls_dfamily
	end if
	if not isnull(ls_dgiven) then
		HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.OrderedByCode.GivenName.value = ls_dgiven
	end if
	if not isnull(ls_dsuffix) then
		HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.OrderedByCode.Suffix.value = ls_dsuffix
	end if
	if not isnull(ls_dUPIN) then
		HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.OrderedByCode.AssigningAuthority.UniversalID.value = ls_dUPIN
		HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.OrderedByCode.AssigningAuthority.UniversalIDType.value = "UPIN"
	end if
else
	if not isnull(ls_supervisor_code) then
		HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.OrderedByCode.IDNumber.value = ls_supervisor_code
	end if
	if not isnull(ls_sdfamily) then
		HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.OrderedByCode.FamilyName.value = ls_sdfamily
	end if
	if not isnull(ls_sdgiven) then
		HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.OrderedByCode.GivenName.value = ls_sdgiven
	end if
	if not isnull(ls_sdsuffix) then
		HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.OrderedByCode.Suffix.value = ls_sdsuffix
	end if
	if not isnull(ls_sdUPIN) then
		HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.OrderedByCode.AssigningAuthority.UniversalID.value = ls_sdUPIN
		HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.OrderedByCode.AssigningAuthority.UniversalIDType.value = "UPIN"
	end if
end if		
j = 0
IF li_diagnosis_count > 0 THEN
	la_err = HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.DiagnosisCode.Add(li_diagnosis_count)
	if show_cpt_icd_description = "Y" then
		For i = 1 to li_diagnosis_count
			HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.DiagnosisCode.Item[j].Identifier.value = diagnosiscodeidentifier[i]
			HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.DiagnosisCode.Item[j].Text.value = diagnosisdescription[i]
			j++
		Next
	else
		For i = 1 to li_diagnosis_count
			HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.DiagnosisCode.Item[j].Identifier.value = diagnosiscodeidentifier[i]
			j++
		Next
	end if
End If	
if not isnull(ls_provider) then
	HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.PerformedByCode.IDNumber.value = ls_provider
end if
if not isnull(ls_dfamily) then
	HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.PerformedByCode.FamilyName.value = ls_dfamily
end if
if not isnull(ls_dgiven) then
	HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.PerformedByCode.GivenName.value = ls_dgiven
end if

if not isnull(ls_modifier) then
	la_err = HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.ProcedureCodeModifier.Add(1)
	HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.ProcedureCodeModifier.Item[0].Identifier.value = ls_modifier
	if upper(bs_system) = 'INTEGRY' then
		// replace comma's with ~ because integry looks for modifiers seperated by ~ (~ for repeating segment in HL7)
		old_str = ","
		new_str = "~~"
		start_pos = 1
		// Find the first occurrence of old_str.
		start_pos = Pos(ls_modifier, old_str, start_pos)				// Only enter the loop if you find old_str.
		DO WHILE start_pos > 0
		    // Replace old_str with new_str.
		    ls_modifier = Replace(ls_modifier, start_pos,Len(old_str), new_str)
		    // Find the next occurrence of old_str.
		    start_pos = Pos(ls_modifier, old_str,start_pos+Len(new_str))
		LOOP
		
		HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.TransactionDescriptionAlt.value = ls_modifier
	end if
end if

if is_msg_count > 1 then
	for i = 1 to 11
		setnull(ls_fields[i])
	next	
	for m = 2 to is_msg_count
		for i = 1 to 11
			setnull(ls_fields[i])
		next	
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
		HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.TransactionID.value = ls_count
		HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.SetID.value = ls_count
		if billing_batch <> '' then
			HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.TransactionBatchID = billing_batch
		end if	
		HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.TransactionDate.value = ldt_encounter_datetime
		HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.TransactionPostingDate.value = ldt_datetime
		HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.TransactionType.value = billing_transtype
		HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.AssignedPatientLocation.Facility.NamespaceID.value = ls_facility
		HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.AssignedPatientLocation.PointOfCare.value = ls_facility
		HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.ProcedureCode.Identifier.value = procedurecodeidentifier
		if upper(bs_system) = 'INTEGRY' then
		        HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.TransactionCode.Identifier.value = procedurecodeidentifier
		end if

		if show_cpt_icd_description = "Y" then
			HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.ProcedureCode.Text.value = ls_proc_description
		end if
		HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.TransactionQuantity.value = ls_unit
		j = 0
		IF li_diagnosis_count > 0 THEN
			la_err = HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.DiagnosisCode.Add(li_diagnosis_count)
			if show_cpt_icd_description = "Y" then
				For i = 1 to li_diagnosis_count
					HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.DiagnosisCode.Item[j].Identifier.value = diagnosiscodeidentifier[i]
					HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.DiagnosisCode.Item[j].Text.value = diagnosisdescription[i]
					j++
				Next
			else
				For i = 1 to li_diagnosis_count
					HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.DiagnosisCode.Item[j].Identifier.value = diagnosiscodeidentifier[i]
					j++
				Next
			end if
		End If	
		if not isnull(ls_provider) then
			HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.PerformedByCode.IDNumber.value = ls_provider
		end if
		if not isnull(ls_dfamily) then
			HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.PerformedByCode.FamilyName.value = ls_dfamily
		end if
		if not isnull(ls_dgiven) then
			HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.PerformedByCode.GivenName.value = ls_dgiven
		end if
		if not isnull(ls_dsuffix) then
			HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.PerformedByCode.Suffix.value = ls_dsuffix
		end if
		if not isnull(ls_modifier) then
			la_err = HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.ProcedureCodeModifier.Add(1)
			HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.ProcedureCodeModifier.Item[0].Identifier.value = ls_modifier
			if upper(bs_system) = 'INTEGRY' then
				// replace comma's with ~ because integry looks for modifiers seperated by ~ (~ means repeating segment in HL7)
				old_str = ","
				new_str = "~~"
				start_pos = 1
				// Find the first occurrence of old_str.
				start_pos = Pos(ls_modifier, old_str, start_pos)				// Only enter the loop if you find old_str.
				DO WHILE start_pos > 0
				    // Replace old_str with new_str.
				    ls_modifier = Replace(ls_modifier, start_pos,Len(old_str), new_str)
				    // Find the next occurrence of old_str.
				    start_pos = Pos(ls_modifier, old_str,start_pos+Len(new_str))
				LOOP
				HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.TransactionDescriptionAlt.value = ls_modifier
			end if

		end if
		if lb_same_id then
			if not isnull(ls_provider) then
				HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.OrderedByCode.IDNumber.value = ls_provider
			end if
			if not isnull(ls_dfamily) then
				HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.OrderedByCode.FamilyName.value = ls_dfamily
			end if
			if not isnull(ls_dgiven) then
				HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.OrderedByCode.GivenName.value = ls_dgiven
			end if
			if not isnull(ls_dsuffix) then
				HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.OrderedByCode.Suffix.value = ls_dsuffix
			end if
			if not isnull(ls_dUPIN) then
				HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.OrderedByCode.AssigningAuthority.UniversalID.value = ls_dUPIN
				HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.OrderedByCode.AssigningAuthority.UniversalIDType.value = "UPIN"
			end if
		else
			if not isnull(ls_supervisor_code) then
				HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.OrderedByCode.IDNumber.value = ls_supervisor_code
			end if
			if not isnull(ls_sdfamily) then
				HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.OrderedByCode.FamilyName.value = ls_sdfamily
			end if
			if not isnull(ls_sdgiven) then
				HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.OrderedByCode.GivenName.value = ls_sdgiven
			end if
			if not isnull(ls_sdsuffix) then
				HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.OrderedByCode.Suffix.value = ls_sdsuffix
			end if
			if not isnull(ls_sdUPIN) then
				HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.OrderedByCode.AssigningAuthority.UniversalID.value = ls_sdUPIN
				HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.OrderedByCode.AssigningAuthority.UniversalIDType.value = "UPIN"
			end if
		end if	
		ls_cpt_assemblies = Mid(ls_cpt_assemblies,ll_tabnext_pos + 1)
	NEXT
END IF

// Sending to destination
li_rtn = 1
SetNull(ls_uuid)

if isnull(dcom_app_dest) or len(dcom_app_dest) = 0 then
	dcom_app_dest = 'PMSERVER'
end if
ls_uuid = omsgman.sendmessage(oEnv,dcom_app_dest)
IF IsNull(ls_uuid) then
	mylog.log(this,"u_component_outgoing_filecopy_hl7.chrg.0733","error with send to destination " + dcom_app_dest,4)
	li_rtn = -1
ELSE
	mylog.log(this,"u_component_outgoing_filecopy_hl7.chrg.0733","message " + string(message_id) + "sent to " + dcom_app_dest,1)
END IF

// save copy of the bill??
if ib_hold_outgoing then 
	ls_uuid = omsgman.sendmessage(oEnv,"EPROHOLDMESSAGES")
	IF IsNull(ls_uuid) then
		mylog.log(this,"u_component_outgoing_filecopy_hl7.chrg.0733","error with send to destination EPROHOLDMESSAGES" ,4)
		li_rtn = -1
	ELSE
		mylog.log(this,"u_component_outgoing_filecopy_hl7.chrg.0733","message " + string(message_id) + "sent to EPROHOLDMESSAGES" ,1)
	END IF
end if
omsgman.donewithmessage(oEnv)

if isnull(ll_tries) then ll_tries = 0 else ll_tries = ll_tries + 1

UPDATE o_Message_Log
SET status = 'ACK_WAIT',
tries = :ll_tries
WHERE message_id = :message_id
USING cprdb;
if not cprdb.check() then return -1

// disconnect the ole objects and do a garbagecollect
oenv.disconnectobject()
Destroy oEnv
omsgtype.disconnectobject()
Destroy oMsgType
hl7dftp03.disconnectobject()
Destroy HL7DFTP03
setnull(oEnv)
setnull(HL7DFTP03)
setnull(omsgtype)

GarbageCollectSetTimeLimit(0)
GarbageCollect()

mylog.log(this,"u_component_outgoing_filecopy_hl7.chrg.0733","message sent to destinations, returning",1)
Return li_rtn
end function

public function integer chrg_mpm (string ps_message);/*******************************************************************************
*
* Description: HL7 P03 - Constructed for all Practice management except Millbrook
*
* Returns : 
*
*
*
*
*************************************************************************************/
INTEGER	 i,j,k,m,n,li_pos
INTEGER	 li_sts, li_rtn
INTEGER	 li_diagnosis_count, li_count
BOOLEAN	 lb_same_id = False, lb_retry
ANY		 la_err
LONG		 ll_pos, ll_tab_pos, ll_tabnext_pos, ll_len, ll_tries
LONG		 ll_message_ctrl_id, ll_message_size, ll_subscription_id
DATETIME  ldt_now, ldt_stopper
DATETIME  ldt_datetime, ldt_scheduledatetime,ldt_encounter_datetime
DATE		 ld_thisdate
TIME		 lt_stop_time,lt_thistime
STRING	 ls_message_ctrl_id, ls_vertical_tab='~v', ls_line_break = '~013'
STRING	 ls_facility, ls_temp,ls_fields[]
STRING	 ls_thisdatetime,ls_icd
STRING	 ls_cpt_assembly,ls_cpt_assemblies
STRING 	 ls_internal_id,ls_external_id
STRING	 ls_attending_provider_id,ls_provider
STRING 	 ls_visitnumber_id,ls_alternatevisitid_id
STRING	 ls_encounter_type,ls_destination, ls_amount
String 	 diagnosiscodeidentifier[],procedurecodeidentifier,ls_cpt_code,diagnosisdescription[]
STRING	 ls_encounter_date
STRING	 ls_given,ls_family, ls_middle, ls_degree, ls_prefix, ls_suffix 
STRING 	 ls_dgiven,ls_dfamily, ls_dmiddle, ls_ddegree, ls_dprefix, ls_dsuffix, ls_dUPIN 
STRING 	 ls_sdgiven,ls_sdfamily, ls_sdmiddle, ls_sddegree, ls_sdprefix, ls_sdsuffix, ls_sdUPIN 
STRING 	 ls_mycomposite,ls_modifier,ls_count
STRING 	 ls_message_type, ls_status, ls_sendfile, ls_message_compression_type
STRING 	 ls_id,ls_proc_description
STRING	 ls_supervisor,ls_provider_check,ls_message_viewer
STRING	 ls_scheduledatetime,ls_unit
STRING	 ls_uuid
STRING	 ls_supervisor_id,ls_supervising_doctor,ls_cpr_id
LONG	    ll_encounter_id
OLEOBJECT omsgtype, OEnv, HL7DFTP03

// create the message type
omsgtype = create oleobject
li_sts = omsgtype.connecttonewobject("AHC.MessageType")
if li_sts <> 0 then
	mylog.log(this, "u_component_outgoing_filecopy_hl7.chrg_mpm.0049", "ERROR: connection to AHC messagetype object failed.", 4)
	DESTROY omsgtype
	setnull(omsgtype)
	return -1
end if
// fill out the message type with the HL7DFTP03 relevant information
omsgtype.MessageTypeCode = "DFT"
omsgtype.EventCode = "P03"
omsgtype.Version = "HL7 2.3" 	// MUST be like this!

// create the enevelope object
oEnv = create oleobject
oEnv = omsgman.CreateMessage(omsgtype)
if isnull(oenv) then
	mylog.log(this, "u_component_outgoing_filecopy_hl7.chrg_mpm.0049", "Error in getting message evnvelope object", 4)	
	return -1
end if

//Declare a message object of the type created in the previous step 
HL7DFTP03 = create oleobject
//get a handle to the message content.
HL7DFTP03 = oEnv.Content
if isnull(hl7dftp03) then
	mylog.log(this, "u_component_outgoing_filecopy_hl7.chrg_mpm.0049", "Error in getting message type object from message envelope", 4)	
	return -1
end if

ll_len = Len(ps_message)
ll_tab_pos = POS(ps_message,ls_vertical_tab)
IF ll_tab_pos > 0 THEN 
	ls_cpt_assemblies = Mid(ps_message, ll_tab_pos + 1)
	ll_len = ll_tab_pos - 1
END IF
IF ll_len = 0  OR ps_message = "" THEN
	mylog.log(this, "u_component_outgoing_filecopy_hl7.chrg_mpm.0049","MessageId: "+string(message_id)+":No charge message",3)
	return f_posting_failed(message_id,"NO CHARGE")
END IF

// Parse through the string and populate array
// which contains facily,attending doctor info AND 
// first CPT & associated ICD10's.
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
	mylog.log(this, "u_component_outgoing_filecopy_hl7.chrg.0052", "MessageId: "+string(message_id)+":Invalid Billing message count, message( "+string(ll_len)+"," + ls_temp + "), Posting failed", 4)	
	return f_posting_failed(message_id,"BAD LEN")
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
if isnull(ldt_encounter_datetime) then 
	mylog.log(this, "u_component_outgoing_filecopy_hl7.chrg.0052", "MessageId: "+string(message_id)+":No Encounter Date, Billing message( " + ls_temp + "), Posting failed", 4)	
	return f_posting_failed(message_id,"NO ENCDATE")
end if

mylog.log(this, "u_component_outgoing_filecopy_hl7.chrg_mpm.0049", "facility id" + ls_facility, 1)	

procedurecodeidentifier = ls_fields[22] // procedure code
ls_modifier = ls_fields[23] // modifier
ls_unit = ls_fields[24]  //unit
if ls_unit = "" then ls_unit = "1"
ls_proc_description = ls_fields[25]
li_diagnosis_count = integer(ls_fields[26]) // no. of diagnosis attached to procedure
li_count = li_diagnosis_count
for i = 1 to li_diagnosis_count
	ls_icd = ls_fields[26+i]
	li_pos = POS(ls_icd,"~t")
	diagnosiscodeidentifier[i] = mid(ls_icd,1,li_pos - 1)
	diagnosisdescription[i] = mid(ls_icd,li_pos + 1)
next	

for i = li_diagnosis_count to 1 step -1
	if diagnosiscodeidentifier[i] = "" or isnull(diagnosiscodeidentifier[i]) then 
		li_diagnosis_count --
	end if	
next	

if isnull(procedurecodeidentifier) or procedurecodeidentifier = "" then 
	mylog.log(this, "u_component_outgoing_filecopy_hl7.chrg_mpm.0049", "MessageId: "+string(message_id)+":No Procedure, Billing message( " + ls_temp + "), Posting failed", 4)	
	return f_posting_failed(message_id,"NO PROCEDURE")
end if	

if isnull(ls_facility) then ls_facility = ""

if len(ls_alternatevisitid_id) = 0 then setnull(ls_alternatevisitid_id)
if len(ls_visitnumber_id) = 0 then setnull(ls_visitnumber_id)

ls_thisdatetime = string(today(),"yyyy/mm/dd hh:mm:ss")
ld_thisdate = Date(left(ls_thisdatetime,10))
lt_thistime = Time(Mid(ls_thisdatetime,12))
ldt_datetime = Datetime(ld_thisdate,lt_thistime)

li_rtn = 1

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
	SetNull(ls_provider)
else
	//hack for medic ... for attending doc seperate out from field
	ll_pos = POS(ls_attending_provider_id,',')
	if ll_pos > 0 then
		ls_provider = left(ls_attending_provider_id,ll_pos - 1) + mid(ls_attending_provider_id,ll_pos + 1)
	else
		ls_provider = ls_attending_provider_id
	end if	
end if	

ls_destination = dcom_app

SELECT 	
			user_id,
			first_name,
			middle_name,
			last_name,
			degree,
			name_prefix,
			name_suffix,
			UPIN
INTO  	
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
	mylog.log(this, "u_component_outgoing_filecopy_hl7.chrg.0052", "MessageId: "+string(message_id)+":Billing failed.Invalid Provider " + ls_provider, 4)	
	return f_posting_failed(message_id,"NO PROVIDER")
end if	
	
ls_supervisor=""

// get the supervisor information from encounter record not in c_user as it might change every day
select cpr_id,encounter_id
into :ls_cpr_id,:ll_encounter_id
from o_message_log
where message_id=:message_id
Using cprdb;

if cprdb.check() and cprdb.sqlcode <> 100 then

	SELECT supervising_doctor
	into :ls_supervising_doctor
	FROM p_Patient_Encounter
	Where cpr_id=:ls_cpr_id
	and encounter_id=:ll_encounter_id
	using cprdb;
	
	if not isnull(ls_supervising_doctor) and len(ls_supervising_doctor) > 0 then
		ls_supervisor = ls_supervising_doctor

	else
		ls_supervisor = ""
	end if
end if

if isnull(ls_supervisor) or ls_supervisor = "" or ls_supervisor = ls_provider_check then
		lb_same_id = true
else
	SELECT 	first_name,
				middle_name,
				last_name,
				degree,
				name_prefix,
				name_suffix,
				UPIN,
				billing_id
	into
				:ls_sdgiven,
				:ls_sdmiddle,
				:ls_sdfamily,
				:ls_sddegree,
				:ls_sdprefix,
				:ls_sdsuffix,
				:ls_sdUPIN,
				:ls_supervisor_id
	FROM c_User
	WHERE user_id = :ls_supervisor
	USING cprdb;
	If not cprdb.check() or cprdb.sqlcode = 100 or isnull(ls_supervisor_id) then 
		mylog.log(this, "u_component_outgoing_filecopy_hl7.chrg.0052", "MessageId: "+string(message_id)+"Invalid supervisor user id " + ls_provider+". Assuming the attending doc ("+ls_provider+" is billable", 4)	
		lb_same_id = true
	End if
end if

if isnull(ldt_encounter_datetime) then ldt_encounter_datetime = ldt_datetime
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
	
mylog.log(this, "u_component_outgoing_filecopy_hl7.chrg_mpm.0049", "message construct:facility id" + ls_facility, 1)	

//rest of header
//P = production
SELECT convert(varchar(38),id),
		tries
INTO :ls_message_ctrl_id,
		:ll_tries
FROM o_message_log
WHERE message_id = :message_id;
if not tf_check() then return -1

HL7DFTP03.MessageHeader.ProcessingID.ProcessingID.value = "P"
HL7DFTP03.MessageHeader.MessageControlID.value = ls_message_ctrl_id
HL7DFTP03.MessageHeader.SendingApplication.NameSpaceID.value = send_app
HL7DFTP03.MessageHeader.ReceivingApplication.NameSpaceID.value = recv_app
HL7DFTP03.MessageHeader.ReceivingFacility.NameSpaceID.value = recv_facility
HL7DFTP03.MessageHeader.ApplicationAcknowledgmentType.value = "AL" //AL=always and NE=never


HL7DFTP03.EventType.RecordedDateTime.value = ldt_datetime

//Patient Identification Segment
HL7DFTP03.PatientIdentification.SetID.value = "1"

if not isnull(ls_internal_id) then
	la_err = HL7DFTP03.PatientIdentification.InternalPatientID.Add(1)
	HL7DFTP03.PatientIdentification.InternalPatientID.Item[0].ID.value = ls_internal_id
end if	

if not isnull(ls_external_id) then
	HL7DFTP03.PatientIdentification.ExternalPatientID.ID.value = ls_external_id
end if

la_err = HL7DFTP03.PatientIdentification.PatientName.Add(1)
if not isnull(ls_family) then
	HL7DFTP03.PatientIdentification.PatientName.Item[0].FamilyName.value = ls_family
end if	
if not isnull(ls_given) then
	HL7DFTP03.PatientIdentification.PatientName.Item[0].GivenName.value = ls_given
end if
if not isnull(ls_middle) then
	HL7DFTP03.PatientIdentification.PatientName.Item[0].MiddleName.value = ls_middle
end if
if not isnull(ls_suffix) then
	HL7DFTP03.PatientIdentification.PatientName.Item[0].Suffix.value = ls_suffix
end if
if not isnull(ls_prefix) then
	HL7DFTP03.PatientIdentification.PatientName.Item[0].Prefix.value = ls_prefix
end if
if not isnull(ls_degree) then
	HL7DFTP03.PatientIdentification.PatientName.Item[0].Degree.value = ls_degree
end if

//Patient Visit Segment
HL7DFTP03.PatientVisit.SetID.value = "1"
HL7DFTP03.PatientVisit.PatientClass.value = "O"
HL7DFTP03.PatientVisit.AssignedPatientLocation.PointofCare.value = "O"
HL7DFTP03.PatientVisit.AssignedPatientLocation.Facility.NamespaceID.value = ls_facility
HL7DFTP03.PatientVisit.AdmitDateTime.value = ldt_encounter_datetime
la_err = HL7DFTP03.PatientVisit.AttendingDoctor.Add(1)
if (lb_same_id) then
	if not isnull(ls_provider) then
		HL7DFTP03.PatientVisit.Attendingdoctor.Item[0].IDNumber.value = ls_provider
	end if	
	if not isnull(ls_dfamily) then
		HL7DFTP03.PatientVisit.Attendingdoctor.Item[0].FamilyName.value = ls_dfamily
	end if
	if not isnull(ls_dgiven) then
		HL7DFTP03.PatientVisit.Attendingdoctor.Item[0].GivenName.value = ls_dgiven
	end if
	if not isnull(ls_dmiddle) then
		HL7DFTP03.PatientVisit.Attendingdoctor.Item[0].MiddleName.value = ls_dmiddle
	end if
	if not isnull(ls_dsuffix) then
		HL7DFTP03.PatientVisit.Attendingdoctor.Item[0].Suffix.value = ls_dsuffix
	end if
	if not isnull(ls_dprefix) then
		HL7DFTP03.PatientVisit.Attendingdoctor.Item[0].Prefix.value = ls_dprefix
	end if
	if not isnull(ls_ddegree) then
		HL7DFTP03.PatientVisit.Attendingdoctor.Item[0].Degree.value = ls_ddegree
	end if
else
	if not isnull(ls_supervisor_id) then
		HL7DFTP03.PatientVisit.Attendingdoctor.Item[0].IDNumber.value = ls_supervisor_id
	end if	
	if not isnull(ls_sdfamily) then
		HL7DFTP03.PatientVisit.Attendingdoctor.Item[0].FamilyName.value = ls_sdfamily
	end if
	if not isnull(ls_sdgiven) then
		HL7DFTP03.PatientVisit.Attendingdoctor.Item[0].GivenName.value = ls_sdgiven
	end if
	if not isnull(ls_sdmiddle) then
		HL7DFTP03.PatientVisit.Attendingdoctor.Item[0].MiddleName.value = ls_sdmiddle
	end if
	if not isnull(ls_sdsuffix) then
		HL7DFTP03.PatientVisit.Attendingdoctor.Item[0].Suffix.value = ls_sdsuffix
	end if
	if not isnull(ls_sdprefix) then
		HL7DFTP03.PatientVisit.Attendingdoctor.Item[0].Prefix.value = ls_sdprefix
	end if
	if not isnull(ls_sddegree) then
		HL7DFTP03.PatientVisit.Attendingdoctor.Item[0].Degree.value = ls_sddegree
	end if
end if

if isnull(ls_visitnumber_id) then ls_temp = ""
mylog.log(this, "u_component_outgoing_filecopy_hl7.chrg_mpm.0415", "encounterpro visitnumber. " + ls_alternatevisitid_id + " millbrook alternatevisitid. " + ls_temp, 2)
if not isnull(ls_alternatevisitid_id) then
	HL7DFTP03.PatientVisit.VisitNumber.ID.value = ls_alternatevisitid_id
end if

if not isnull(ls_visitnumber_id) then
	HL7DFTP03.PatientVisit.AlternateVisitID.ID.value = ls_visitnumber_id
end if	

//Financial Transaction Segment
la_err = HL7DFTP03.FinancialTransactionGroup.Add(is_msg_count)

HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.TransactionID.value = "1"

if billing_batch <> '' then
	HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.TransactionBatchID = billing_batch
end if	
HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.TransactionDate.value = ldt_encounter_datetime
HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.TransactionType.value = "CG"
HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.TransactionQuantity.value = ls_unit
HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.AssignedPatientLocation.Facility.NamespaceID.value = ls_facility
HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.ProcedureCode.Identifier.value = procedurecodeidentifier
if show_cpt_icd_description = "Y" then
	HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.ProcedureCode.Text.value = ls_proc_description
end if
if lb_same_id then
	if not isnull(ls_provider) then
		HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.OrderedByCode.IDNumber.value = ls_provider
	end if
	if not isnull(ls_dfamily) then
		HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.OrderedByCode.FamilyName.value = ls_dfamily
	end if
	if not isnull(ls_dgiven) then
		HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.OrderedByCode.GivenName.value = ls_dgiven
	end if
	if not isnull(ls_dsuffix) then
		HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.OrderedByCode.Suffix.value = ls_dsuffix
	end if
	if not isnull(ls_dUPIN) then
		HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.OrderedByCode.AssigningAuthority.UniversalID.value = ls_dUPIN
		HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.OrderedByCode.AssigningAuthority.UniversalIDType.value = "UPIN"
	end if
else
	if not isnull(ls_supervisor_id) then
		HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.OrderedByCode.IDNumber.value = ls_supervisor_id
	end if
	if not isnull(ls_sdfamily) then
		HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.OrderedByCode.FamilyName.value = ls_sdfamily
	end if
	if not isnull(ls_sdgiven) then
		HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.OrderedByCode.GivenName.value = ls_sdgiven
	end if
	if not isnull(ls_sdsuffix) then
		HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.OrderedByCode.Suffix.value = ls_sdsuffix
	end if
	if not isnull(ls_sdUPIN) then
		HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.OrderedByCode.AssigningAuthority.UniversalID.value = ls_sdUPIN
		HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.OrderedByCode.AssigningAuthority.UniversalIDType.value = "UPIN"
	end if
end if		
j = 0
IF li_diagnosis_count > 0 THEN
	la_err = HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.DiagnosisCode.Add(li_diagnosis_count)
	if show_cpt_icd_description="Y" then
		For i = 1 to li_diagnosis_count
			HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.DiagnosisCode.Item[j].Identifier.value = diagnosiscodeidentifier[i]
			HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.DiagnosisCode.Item[j].Text.value = diagnosisdescription[i]
			j++
		Next
	else
		For i = 1 to li_diagnosis_count
			HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.DiagnosisCode.Item[j].Identifier.value = diagnosiscodeidentifier[i]
			j++
		Next
	end if
End If	
if not isnull(ls_provider) then
	HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.PerformedByCode.IDNumber.value = ls_provider
end if
if not isnull(ls_dfamily) then
	HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.PerformedByCode.FamilyName.value = ls_dfamily
end if
if not isnull(ls_dgiven) then
	HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.PerformedByCode.GivenName.value = ls_dgiven
end if

if not isnull(ls_modifier) then
	la_err = HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.ProcedureCodeModifier.Add(1)
	HL7DFTP03.FinancialTransactionGroup.Item[0].FinancialTransaction.ProcedureCodeModifier.Item[0].Identifier.value = ls_modifier
end if

if is_msg_count > 1 then
	for i = 1 to 11
		setnull(ls_fields[i])
	next	
	for m = 2 to is_msg_count
		for i = 1 to 11
			setnull(ls_fields[i])
		next	
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
		if upperbound(ls_fields) < 4 then continue
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

		for i = li_diagnosis_count to 1 step -1
			if diagnosiscodeidentifier[i] = "" or isnull(diagnosiscodeidentifier[i]) then 
				li_diagnosis_count --
			end if	
		next	
		
		n = m - 1
		ls_count = string(m)
		HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.TransactionID.value = ls_count
		if billing_batch <> '' then
			HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.TransactionBatchID = billing_batch
		end if	
		HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.TransactionDate.value = ldt_encounter_datetime
		HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.TransactionType.value = billing_transtype
		HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.AssignedPatientLocation.Facility.NamespaceID.value = ls_facility
		HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.ProcedureCode.Identifier.value = procedurecodeidentifier
		if show_cpt_icd_description="Y" then
			HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.ProcedureCode.Text.value = ls_proc_description
		end if
		HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.TransactionQuantity.value = ls_unit
		j = 0
		IF li_diagnosis_count > 0 THEN
			la_err = HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.DiagnosisCode.Add(li_diagnosis_count)
			if show_cpt_icd_description="Y" then
				For i = 1 to li_diagnosis_count
					HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.DiagnosisCode.Item[j].Identifier.value = diagnosiscodeidentifier[i]
					HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.DiagnosisCode.Item[j].Text.value = diagnosisdescription[i]
					j++
				Next
			else
				For i = 1 to li_diagnosis_count
					HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.DiagnosisCode.Item[j].Identifier.value = diagnosiscodeidentifier[i]
					j++
				Next
			end if
		End If	
		if not isnull(ls_provider) then
			HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.PerformedByCode.IDNumber.value = ls_provider
		end if
		if not isnull(ls_dfamily) then
			HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.PerformedByCode.FamilyName.value = ls_dfamily
		end if
		if not isnull(ls_dgiven) then
			HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.PerformedByCode.GivenName.value = ls_dgiven
		end if
		if not isnull(ls_dsuffix) then
			HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.PerformedByCode.Suffix.value = ls_dsuffix
		end if
		if not isnull(ls_modifier) then
			la_err = HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.ProcedureCodeModifier.Add(1)
			HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.ProcedureCodeModifier.Item[0].Identifier.value = ls_modifier
		end if
		if lb_same_id then
			if not isnull(ls_provider) then
				HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.OrderedByCode.IDNumber.value = ls_provider
			end if
			if not isnull(ls_dfamily) then
				HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.OrderedByCode.FamilyName.value = ls_dfamily
			end if
			if not isnull(ls_dgiven) then
				HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.OrderedByCode.GivenName.value = ls_dgiven
			end if
			if not isnull(ls_dsuffix) then
				HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.OrderedByCode.Suffix.value = ls_dsuffix
			end if
			if not isnull(ls_dUPIN) then
				HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.OrderedByCode.AssigningAuthority.UniversalID.value = ls_dUPIN
				HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.OrderedByCode.AssigningAuthority.UniversalIDType.value = "UPIN"
			end if
		else
			if not isnull(ls_supervisor_id) then
				HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.OrderedByCode.IDNumber.value = ls_supervisor_id
			end if
			if not isnull(ls_sdfamily) then
				HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.OrderedByCode.FamilyName.value = ls_sdfamily
			end if
			if not isnull(ls_sdgiven) then
				HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.OrderedByCode.GivenName.value = ls_sdgiven
			end if
			if not isnull(ls_sdsuffix) then
				HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.OrderedByCode.Suffix.value = ls_sdsuffix
			end if
			if not isnull(ls_sdUPIN) then
				HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.OrderedByCode.AssigningAuthority.UniversalID.value = ls_sdUPIN
				HL7DFTP03.FinancialTransactionGroup.Item[n].FinancialTransaction.OrderedByCode.AssigningAuthority.UniversalIDType.value = "UPIN"
			end if
		end if	
		ls_cpt_assemblies = Mid(ls_cpt_assemblies,ll_tabnext_pos + 1)
	NEXT
END IF

// send message to destination
li_rtn = 1
SetNull(ls_uuid)

if isnull(dcom_app_dest) or len(dcom_app_dest) = 0 then
	dcom_app_dest = 'PMSERVER'
end if
ls_uuid = omsgman.sendmessage(oEnv,dcom_app_dest)
if IsNull(ls_uuid) then
	mylog.log(this,"u_component_outgoing_filecopy_hl7.chrg_mpm.0644","error with send to destination " + dcom_app_dest,4)
	li_rtn = -1
else
	mylog.log(this,"u_component_outgoing_filecopy_hl7.chrg_mpm.0644","message " + string(message_id) + "sent to " + dcom_app_dest,1)
end if

// save copy of the bill??
if ib_hold_outgoing then 
	ls_uuid = omsgman.sendmessage(oEnv,"EPROHOLDMESSAGES")
	IF IsNull(ls_uuid) then
		mylog.log(this,"u_component_outgoing_filecopy_hl7.chrg_mpm.0654","error with send to destination EPROHOLDMESSAGES" ,4)
		li_rtn = -1
	ELSE
		mylog.log(this,"u_component_outgoing_filecopy_hl7.chrg_mpm.0654","message " + string(message_id) + "sent to EPROHOLDMESSAGES" ,1)
	END IF
end if

omsgman.donewithmessage(oEnv)

if isnull(ll_tries) then ll_tries = 0 else ll_tries = ll_tries + 1

UPDATE o_Message_Log
	SET status = 'ACK_WAIT',
	tries = :ll_tries
WHERE message_id = :message_id;
if not cprdb.check() then return -1

// disconnect all the objects and call a garbagecollect to release memory
oenv.disconnectobject()
destroy oEnv
hl7dftp03.disconnectobject()
destroy HL7DFTP03
omsgtype.disconnectobject()
DESTROY omsgtype
setnull(oEnv)
setnull(HL7DFTP03)
setnull(omsgtype)

mylog.log(this,"u_component_outgoing_filecopy_hl7.chrg_mpm.0654","message sent to destinations,returning", 1)
GarbageCollectSetTimeLimit(0)
GarbageCollect()

RETURN li_rtn
end function

public function integer timer_ding ();string 		ls_ack_message_id,ls_ack_type, ls_ack_message_id2
String		ls_error1,ls_error2,ls_error
String		ls_cpr_id
Long			ll_encounter_id
integer 		j,ll_len
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
	mylog.log(this, "u_component_outgoing_filecopy_hl7.timer_ding.0018", "Acknowledge messages received (" + string(ll_pending) + ")", 2)
	For i = 1 to ll_pending
	   coll = omsgMan.PollForMessage(1, count)
		ll_count = Coll.Count
   	// get messages
		mylog.log(this, "u_component_outgoing_filecopy_hl7.timer_ding.0018", "Polling Count (" + string(count) + ")", 1)
		If ll_count = 0 Then // no messages
			coll.disconnectobject()
			destroy coll
			Continue
		End If
		FOR j = 0 to ll_count - 1
			ls_message_type = coll.Item(j).Type.MessageTypeCode
			mylog.log(this, "u_component_outgoing_filecopy_hl7.timer_ding.0018", "Collection Count (" + string(j) + ") message type ( "+ls_message_type+")", 1)
			If upper(trim(ls_message_type)) = "ACK" Then
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
				ls_ack_message_id2 = ls_ack_message_id
				ls_ack_message_id=ls_ack_message_id+"%"
				SELECT cpr_id,	encounter_id
				INTO :ls_cpr_id,:ll_encounter_id
				FROM o_Message_Log
				WHERE id like :ls_ack_message_id
				Using cprdb;
				
				if not tf_check() then
					continue
				end if
				If cprdb.sqlcode = 100 Then
					SELECT cpr_id,	encounter_id
					INTO :ls_cpr_id,:ll_encounter_id
					FROM o_Message_Log
					WHERE message_id = :ls_ack_message_id2
					Using cprdb;

					mylog.log(this, "u_component_outgoing_filecopy_hl7.timer_ding.0018", "No records found for message ID (" + ls_ack_message_id2 + ")", 3)
					continue
				End If
				mylog.log(this, "u_component_outgoing_filecopy_hl7.timer_ding.0018", "Ack message ( "+ls_ack_type + " ) for message id (" + ls_ack_message_id + ")", 1)
				
				If ls_ack_type = "AA" or ls_ack_type = "AL" or ls_ack_type = 'CA' then // bill Accepted
					Update o_message_log
					Set status = 'SENT'
					WHERE (id like :ls_ack_message_id OR message_id = :ls_ack_message_id2)
					AND message_type = 'ENCOUNTERPRO_CHECKOUT'
					Using cprdb;
					If NOT cprdb.check() THEN RETURN -1		
					
					mylog.log(this, "u_component_outgoing_filecopy_hl7.timer_ding.0018", "Acknowledge received for message ID (" + ls_ack_message_id + ")", 2)
				Elseif ls_ack_type = "AE" then
					Update o_message_log
					Set status = 'ACK_REJECT',
					comments = :ls_error
					Where (id like :ls_ack_message_id OR message_id = :ls_ack_message_id2)
					And   message_type = 'ENCOUNTERPRO_CHECKOUT'
					Using cprdb;
					If Not cprdb.check() THEN Return -1		
					
					mylog.log(this, "u_component_outgoing_filecopy_hl7.timer_ding.0018", "Ack Reject received for message ID (" + ls_ack_message_id + "), Error: "+ls_error, 4)	

				Else
					Update o_message_log
					Set status = 'ACK_NACK'
					Where (id like :ls_ack_message_id OR message_id = :ls_ack_message_id2)
					AND message_type = 'ENCOUNTERPRO_CHECKOUT'
					AND status = 'ACK_WAIT'
					using cprdb;
					if not cprdb.check() then return -1		
					
					mylog.log(this, "u_component_outgoing_filecopy_hl7.timer_ding.0018", "NonAcknowledge received for message ID (" + ls_ack_message_id + ")" , 2)	
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

public function integer ahc_disconnect ();if not isnull(oAHC) and isvalid(oAHC) Then
	mylog.log(this,"u_component_outgoing_filecopy_hl7.ahc_disconnect.0002","disconnecting from AHC Interface",1)
	TRY
		oAHC.Disconnect()
	CATCH (throwable lt_error)
		log.log(this, "u_component_outgoing_filecopy_hl7.ahc_disconnect.0006", "Error disconnecting AHC Messanger:  " + lt_error.text, 4)
	FINALLY
		oahc.disconnectobject()
		Destroy oAHC
		Setnull(oAHC)
	END TRY
	mylog.log(this,"u_component_outgoing_filecopy_hl7.ahc_disconnect.0002","disconnected from AHC Interface",1)
End If

if not isnull(omsgman) and isvalid(omsgman) Then
	omsgman.disconnectobject()
	Destroy omsgMan
	Setnull(omsgMan)
end if

Return 1

end function

public function integer chrg_mckesson (string ps_message);/*******************************************************************************
*
* Description: HL7 P03 - Constructed for Mckesson Practice management 
*
* Returns : 
*
*
*
*
*************************************************************************************/
INTEGER	 i,j,k,m,n,li_pos
INTEGER	 li_sts, li_rtn
INTEGER	 li_diagnosis_count, li_count
BOOLEAN	 lb_same_id = False, lb_retry
ANY		 la_err
LONG		 ll_pos, ll_tab_pos, ll_tabnext_pos, ll_len, ll_tries
LONG		 ll_message_id, ll_message_size, ll_subscription_id
DATETIME  ldt_datetime, ldt_scheduledatetime
DATE		 ld_thisdate,ldt_encounter_date
TIME		 lt_stop_time,lt_thistime
STRING	 ls_doctor_id
STRING	 ls_icd
STRING	 ls_message_ctrl_id, ls_vertical_tab='~v', ls_line_break = '~013'
STRING	 ls_facility, ls_temp,ls_fields[]
STRING	 ls_thisdatetime,ls_billable_provider
STRING	 ls_cpt_assembly,ls_cpt_assemblies
STRING 	 ls_internal_id,ls_external_id
STRING	 ls_attending_provider_id,ls_provider
STRING 	 ls_visitnumber_id,ls_alternatevisitid_id
STRING	 ls_encounter_type,ls_destination, ls_amount
String 	 diagnosiscodeidentifier[],procedurecodeidentifier,ls_cpt_code,diagnosisdescription[]
STRING	 ls_encounter_date
STRING	 ls_given,ls_family, ls_middle, ls_degree, ls_prefix, ls_suffix 
STRING 	 ls_dgiven,ls_dfamily, ls_dmiddle, ls_ddegree, ls_dprefix, ls_dsuffix, ls_dUPIN 
STRING 	 ls_sdgiven,ls_sdfamily, ls_sdmiddle, ls_sddegree, ls_sdprefix, ls_sdsuffix, ls_sdUPIN 
STRING 	 ls_mycomposite,ls_modifier,ls_count
string 	 ls_message_type, ls_status, ls_sendfile, ls_message_compression_type
STRING 	 ls_id,ls_proc_description
STRING	 ls_supervisor,ls_provider_check,ls_message_viewer
STRING	 ls_scheduledatetime,ls_supervisor_code,ls_unit
STRING	 ls_diagnosis,ls_ft,ls_supervising_doctor
STRING	 ls_msh,ls_evn,ls_pid,ls_pv1,ls_ft1
string	 ls_0D = "~h0D", ls_msg,ls_path,ls_filename
STRING	 ls_cpr_id
LONG		 ll_encounter_id
BLOB		 lblb_bill

ll_len = Len(ps_message)
ll_tab_pos = POS(ps_message,ls_vertical_tab)
IF ll_tab_pos > 0 THEN 
	ls_cpt_assemblies = Mid(ps_message, ll_tab_pos + 1)
	ll_len = ll_tab_pos - 1
END IF
IF ll_len = 0  OR ps_message = "" THEN
	mylog.log(this, "u_component_outgoing_filecopy_hl7.chrg.0052","MessageId: "+string(message_id)+":No charge message",3)
	return f_posting_failed(message_id,"NO CHARGE")
END IF

// Parse through the string and populate array
// which contains facily,attending doctor info AND 
// first CPT & associated ICD10's.
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
	mylog.log(this, "u_component_outgoing_filecopy_hl7.chrg.0052", "MessageId: "+string(message_id)+":Invalid Billing message count, message( "+string(ll_len)+"," + ls_temp + "), Posting failed", 4)	
	return f_posting_failed(message_id,"BAD LEN")
End If
ls_thisdatetime = string(today(),"yyyy/mm/dd hh:mm:ss")
ld_thisdate = Date(left(ls_thisdatetime,10))
lt_thistime = Time(Mid(ls_thisdatetime,12))
ldt_datetime = Datetime(ld_thisdate,lt_thistime)

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
ldt_encounter_date = Date(left(ls_encounter_date,10))
if isnull(ldt_encounter_date) then 
	mylog.log(this, "u_component_outgoing_filecopy_hl7.chrg.0052", "MessageId: "+string(message_id)+":No Encounter Date, Billing message( " + ls_temp + "), Posting failed", 4)	
	return f_posting_failed(message_id,"NO ENCDATE")
end if

procedurecodeidentifier = ls_fields[22] // procedure code
ls_modifier = ls_fields[23] // modifier
ls_unit = ls_fields[24]  //unit
if ls_unit = "" then ls_unit = "1"
ls_proc_description = ls_fields[25]
if isnull(ls_proc_description) then ls_proc_description = ""
li_diagnosis_count = integer(ls_fields[26]) // no. of diagnosis attached to procedure
li_count = li_diagnosis_count
for i = 1 to li_diagnosis_count
	ls_icd = ls_fields[26+i]
	li_pos = POS(ls_icd,"~t")
	diagnosiscodeidentifier[i] = mid(ls_icd,1,li_pos - 1)
	diagnosisdescription[i] = mid(ls_icd,li_pos + 1)
next	

IF isnull(procedurecodeidentifier) or procedurecodeidentifier = "" then 
	mylog.log(this, "u_component_outgoing_filecopy_hl7.chrg.0052", "MessageId: "+string(message_id)+":No Procedure, Billing message( " + ls_temp + "), Posting failed", 4)	
	return f_posting_failed(message_id,"NO PROCEDURE")
END IF

If ls_attending_provider_id = "" then 
	SetNull(ls_attending_provider_id)
	SetNull(ls_provider)
Else
	ls_provider = ls_attending_provider_id
end if	

SELECT 	
			user_id,
			first_name,
			middle_name,
			last_name,
			degree,
			name_prefix,
			name_suffix,
			UPIN
INTO  	
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
	mylog.log(this, "u_component_outgoing_filecopy_hl7.chrg.0052", "MessageId: "+string(message_id)+":Billing failed.Invalid Provider " + ls_provider, 4)	
	return f_posting_failed(message_id,"NO PROVIDER")
end if	
	
ls_supervisor=""

// get the supervisor information from encounter record not in c_user as it might change every day
select cpr_id,encounter_id
into :ls_cpr_id,:ll_encounter_id
from o_message_log
where message_id=:message_id
Using cprdb;

if cprdb.check() and cprdb.sqlcode <> 100 then

	SELECT supervising_doctor
	into :ls_supervising_doctor
	FROM p_Patient_Encounter
	Where cpr_id=:ls_cpr_id
	and encounter_id=:ll_encounter_id
	using cprdb;
	
	if not isnull(ls_supervising_doctor) and len(ls_supervising_doctor) > 0 then
		ls_supervisor = ls_supervising_doctor

	else
		ls_supervisor = ""
	end if
end if

if isnull(ls_supervisor) or ls_supervisor = "" or ls_supervisor = ls_provider_check then
		lb_same_id = true
else
	SELECT 	first_name,
				middle_name,
				last_name,
				degree,
				name_prefix,
				name_suffix,
				UPIN,
				billing_id
	into
				:ls_sdgiven,
				:ls_sdmiddle,
				:ls_sdfamily,
				:ls_sddegree,
				:ls_sdprefix,
				:ls_sdsuffix,
				:ls_sdUPIN,
				:ls_supervisor_code
	FROM c_User
	WHERE user_id = :ls_supervisor
	USING cprdb;
	If not cprdb.check() or cprdb.sqlcode = 100 or isnull(ls_supervisor_code) then 
		mylog.log(this, "u_component_outgoing_filecopy_hl7.chrg.0052", "MessageId: "+string(message_id)+"Invalid supervisor user id " + ls_provider+". Assuming the attending doc ("+ls_provider+" is billable", 4)	
		lb_same_id = true
	End if
end if

// Translate a provider id
ls_doctor_id = sqlca.fn_lookup_user_billingid(ls_facility,ls_provider)
if isnull(ls_doctor_id) or ls_doctor_id = "" then ls_doctor_id = ls_provider
if isnull(ls_doctor_id) then ls_doctor_id = ""
ls_provider = ls_doctor_id

// Translate a supervisor provider id
ls_doctor_id = sqlca.fn_lookup_user_billingid(ls_facility,ls_supervisor_code)
if isnull(ls_doctor_id) or ls_doctor_id = "" then ls_doctor_id = ls_supervisor_code
if isnull(ls_doctor_id) then ls_doctor_id = ""
ls_supervisor_code = ls_doctor_id

/**********
* Message Header
***********/

// Check for Null's
if isnull(send_app) then send_app = ""
if isnull(send_facility) then send_facility = ""
if isnull(recv_app) then recv_app = ""
if isnull(recv_facility) then recv_facility = ""

ls_msh = "MSH|^~~\&|"+send_app+"|"+send_facility+"|"+recv_app+"|"+recv_facility+"|"+string(ldt_datetime,"yyyymmdd")+"||"
ls_msh += "DFT^P03|"+string(message_id)+"|P|2.3|||AL|AL"

/**********
* Event Header
***********/
ls_evn = "EVN|P03|"+string(ldt_datetime,"yyyymmdd")

/**********
* Patient Identification Segment (PID)
***********/
// Check for Null's
if isnull(ls_internal_id) then ls_internal_id = ""
if isnull(ls_family) then ls_family = ""
if isnull(ls_given) then ls_given = ""
if isnull(ls_middle) then ls_middle=""
if isnull(ls_suffix) then ls_suffix=""
if isnull(ls_prefix) then ls_prefix=""
if isnull(ls_degree) then ls_degree=""

ls_pid = "PID|1||"+ls_external_id+'^^^^'+patient_identifier+'||'+ls_family+'^'+ls_given+'^'+ls_middle+'^'+ls_suffix+'^'+ls_prefix+'^'+ls_degree

/**********
* Patient Visit Segment (PV1)
***********/

ls_pv1 = "PV1|1|O|O^^^"+ls_facility+"||||"

if lb_same_id then
	if isnull(ls_provider) then ls_provider=""
	if isnull(ls_dfamily) then ls_dfamily = ""
	if isnull(ls_dgiven) then ls_dgiven = ""
	if isnull(ls_dmiddle) then ls_dmiddle=""
	if isnull(ls_dsuffix) then ls_dsuffix=""
	if isnull(ls_dprefix) then ls_dprefix=""
	if isnull(ls_ddegree) then ls_ddegree=""
	
	ls_pv1 += ls_provider+"^"+ls_dfamily+"^"+ls_dgiven+"^"+ls_dmiddle+"^"+ls_dsuffix+"^"+ls_dprefix+"^"+ls_ddegree
	
	mylog.log(this, "u_component_outgoing_filecopy_hl7.chrg.0052", "MessageId: "+string(message_id)+"Billable Provider: " + ls_provider, 2)	
else
	if isnull(ls_supervisor_code) then ls_supervisor_code=""
	if isnull(ls_sdfamily) then ls_sdfamily = ""
	if isnull(ls_sdgiven) then ls_sdgiven = ""
	if isnull(ls_sdmiddle) then ls_sdmiddle=""
	if isnull(ls_sdsuffix) then ls_sdsuffix=""
	if isnull(ls_sdprefix) then ls_sdprefix=""
	if isnull(ls_sddegree) then ls_sddegree=""

	ls_pv1 += ls_supervisor_code+"^"+ls_sdfamily+"^"+ls_sdgiven+"^"+ls_sdmiddle+"^"+ls_sdsuffix+"^"+ls_sdprefix+"^"+ls_sddegree
	mylog.log(this, "u_component_outgoing_filecopy_hl7.chrg.0052", "MessageId: "+string(message_id)+"Billable Provider: " + ls_supervisor_code, 2)	
End If
mylog.log(this, "u_component_outgoing_filecopy_hl7.chrg.0052", "encounterpro visitnumber. " + ls_visitnumber_id , 2)

if isnull(ls_visitnumber_id) then ls_visitnumber_id=""
ls_pv1 += "||||||||||||"+ls_visitnumber_id+"|||||||||||||||||||||||||"+string(ldt_encounter_date,"yyyymmdd")

/**********
* Financial Transaction Segment (FT1)
***********/
// Check for nulls
if isnull(billing_batch) then billing_batch=""
if isnull(billing_transtype) then billing_transtype=""

ls_ft1 = "FT1|1|1|"+billing_batch+"|"+string(ldt_encounter_date,"yyyymmdd")+"|"+string(ldt_datetime,"yyyymmdd")+"|"
ls_ft1 += billing_transtype+"||||"+ls_unit+"||||||"+ls_facility+"^^^"+ls_facility+"|||"

// diagnosis linked to the primary visit
j = 0
IF li_diagnosis_count > 0 THEN
	if show_cpt_icd_description = "Y" then
		ls_diagnosis = diagnosiscodeidentifier[1] + "^"+diagnosisdescription[1]
		For i = 2 to li_diagnosis_count
			ls_diagnosis += "~~"+diagnosiscodeidentifier[i] + "^"+diagnosisdescription[i]
			j++
		Next
	else
		ls_diagnosis = diagnosiscodeidentifier[1]
		For i = 2 to li_diagnosis_count
			ls_diagnosis += "~~"+diagnosiscodeidentifier[i]
			j++
		Next
	end if
End If	

// diagnosis
if not isnull(ls_diagnosis) then
	ls_ft1 += ls_diagnosis+"|"
else
	ls_ft1 += "|"
end if

// performed by code
if lb_same_id then
	ls_ft1 += ls_provider+"^"+ls_dfamily+"^"+ls_dgiven+"^"+ls_dmiddle+"^"+ls_dsuffix+"^"+ls_dprefix+"^"+ls_ddegree+"|"
else
	// concatenate the supervisor with the provider..
	if not isnull(ls_supervisor_code) then
		ls_ft1 += ls_provider+ls_supervisor_code+"^"+ls_dfamily+"^"+ls_dgiven+"^"+ls_dmiddle+"^"+ls_dsuffix+"^"+ls_dprefix+"^"+ls_ddegree+"|"
	end if
end if

//ordered by code
if lb_same_id then
	ls_ft1 += ls_provider+"^"+ls_dfamily+"^"+ls_dgiven+"^"+ls_dmiddle+"^"+ls_dsuffix+"^"+ls_dprefix+"^"+ls_ddegree+"|"
else
	ls_ft1 += ls_supervisor_code+"^"+ls_sdfamily+"^"+ls_sdgiven+"^"+ls_sdmiddle+"^"+ls_sdsuffix+"^"+ls_sdprefix+"^"+ls_sddegree+"|"
end if

if show_cpt_icd_description = "N" then
	ls_ft1 += "|||"+procedurecodeidentifier+"|"
else
	ls_ft1 += "|||"+procedurecodeidentifier+"^"+ls_proc_description+"|"
end if

// modifier
if isnull(ls_modifier) then ls_modifier = ""
ls_ft1 += ls_modifier

// Construct the charge message
ls_msg = ls_msh+ls_0D+ls_evn+ls_0D+ls_pid+ls_0D+ls_pv1+ls_0D+ls_ft1+ls_0D

// Construct 2 or more Ft segments if there are more cpt codes found.
if is_msg_count > 1 then
	for i = 1 to 11
		setnull(ls_fields[i])
	next	
	for m = 2 to is_msg_count
		for i = 1 to 11
			setnull(ls_fields[i])
		next	
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

		ls_ft = "FT1|"+ls_count+"|"+ls_count+"|"+billing_batch+"|"+string(ldt_encounter_date,"yyyymmdd")+"|"+string(ldt_datetime,"yyyymmdd")+"|"
		ls_ft += billing_transtype+"||||"+ls_unit+"||||||"+ls_facility+"^^^"+ls_facility+"|||"

		// diagnosis linked to the primary visit
		j = 0
		ls_diagnosis = ""
		IF li_diagnosis_count > 0 THEN
			if show_cpt_icd_description = "Y" then
				ls_diagnosis = diagnosiscodeidentifier[1] + "^"+diagnosisdescription[1]
				For i = 2 to li_diagnosis_count
					ls_diagnosis += "~~"+diagnosiscodeidentifier[i] + "^"+diagnosisdescription[i]
					j++
				Next
			else
				ls_diagnosis = diagnosiscodeidentifier[1]
				For i = 2 to li_diagnosis_count
					ls_diagnosis += "~~"+diagnosiscodeidentifier[i]
					j++
				Next
			end if
		End If	

		// diagnosis
		if not isnull(ls_diagnosis) then
			ls_ft += ls_diagnosis+"|"
		else
			ls_ft += "|"
		end if

		// performed by code
		if lb_same_id then
			ls_ft += ls_provider+"^"+ls_dfamily+"^"+ls_dgiven+"^"+ls_dmiddle+"^"+ls_dsuffix+"^"+ls_dprefix+"^"+ls_ddegree+"|"
		else
			// concatenate the supervisor with the provider..
			if not isnull(ls_supervisor_code) then
				ls_ft += ls_provider+ls_supervisor_code+"^"+ls_dfamily+"^"+ls_dgiven+"^"+ls_dmiddle+"^"+ls_dsuffix+"^"+ls_dprefix+"^"+ls_ddegree+"|"
			end if
		end if

		//ordered by code
		if lb_same_id then
			ls_ft += ls_provider+"^"+ls_dfamily+"^"+ls_dgiven+"^"+ls_dmiddle+"^"+ls_dsuffix+"^"+ls_dprefix+"^"+ls_ddegree+"|"
		else
			ls_ft += ls_supervisor_code+"^"+ls_sdfamily+"^"+ls_sdgiven+"^"+ls_sdmiddle+"^"+ls_sdsuffix+"^"+ls_sdprefix+"^"+ls_sddegree+"|"
		end if

		if show_cpt_icd_description = "N" then
			ls_ft += "|||"+procedurecodeidentifier+"|"
		else
			ls_ft += "|||"+procedurecodeidentifier+"^"+ls_proc_description+"|"
		end if

		// modifier
		if isnull(ls_modifier) then ls_modifier = ""
		ls_ft += ls_modifier

		ls_msg += ls_ft + ls_0D
		ls_cpt_assemblies = Mid(ls_cpt_assemblies,ll_tabnext_pos + 1)
	NEXT
END IF

if isnull(ls_msg) or len(ls_msg) = 0 then 
	mylog.log(this, "u_component_outgoing_filecopy_hl7.chrg_mckesson.0482", "Billing Failed:charge message is null or empty", 4)	
	return -1 // error 
end if

lblb_bill = f_string_to_blob(ls_msg, TextEncoding)

// write to a file
// to assure more uniqueness, Construct the filename using a component counter
ls_path = recv_app_path
if right(recv_app_path, 1) <> "\" then ls_path += "\"

ls_filename = ls_path + string(message_id) + string(today(),"yyyymmdd") + string(now(),"hhmmss") + ".txt"

if fileexists(ls_filename) then
	mylog.log(this, "u_component_outgoing_filecopy_hl7.chrg_mckesson.0496", "Error getting next file number "+ls_filename, 4)
	return -1
end if

if mylog.file_write(lblb_bill,ls_filename) < 0 then
	mylog.log(this, "u_component_outgoing_filecopy_hl7.chrg_mckesson.0496", "Error writing the report into a file", 4)
	return -1
end if

// save a copy of the message
if not isnull(hold_outgoing) then
	ls_path = hold_outgoing
	if right(hold_outgoing, 1) <> "\" then ls_path += "\"

	ls_filename = ls_path + string(message_id) + string(today(),"yyyymmdd") + string(now(),"hhmmss") + ".txt"

	if fileexists(ls_filename) then
		mylog.log(this, "u_component_outgoing_filecopy_hl7.chrg_mckesson.0496", "Error getting next file number", 4)
		return -1
	end if

	if mylog.file_write(lblb_bill,ls_filename) < 0 then
		mylog.log(this, "u_component_outgoing_filecopy_hl7.chrg_mckesson.0496", "Error writing the report into a file", 4)
	end if
end if

SELECT convert(varchar(38),id),
		tries
INTO :ls_message_ctrl_id,
		:ll_tries
FROM o_message_log
WHERE message_id = :message_id;
if not tf_check() then return -1

if isnull(ll_tries) then ll_tries = 0 else ll_tries = ll_tries + 1

UPDATE o_Message_Log
SET status = 'ACK_WAIT',
tries = :ll_tries
WHERE message_id = :message_id
USING cprdb;
if not cprdb.check() then return -1

Return li_rtn
end function

on u_component_outgoing_filecopy_hl7.create
call super::create
end on

on u_component_outgoing_filecopy_hl7.destroy
call super::destroy
end on

