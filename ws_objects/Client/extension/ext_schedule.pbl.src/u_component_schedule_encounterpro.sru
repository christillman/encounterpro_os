$PBExportHeader$u_component_schedule_encounterpro.sru
forward
global type u_component_schedule_encounterpro from u_component_schedule
end type
end forward

global type u_component_schedule_encounterpro from u_component_schedule
end type
global u_component_schedule_encounterpro u_component_schedule_encounterpro

type variables
string arrived_success
string arrived_error
string arrived_pending
string billing_system_group
string is_message_id



end variables

forward prototypes
public function integer xx_initialize ()
protected function integer xx_set_checked_in (long pl_checked_in_id, string ps_cpr_id, long pl_encounter_id, string ps_status)
protected function integer xx_get_next_checked_in (ref long pl_checked_in_id, ref string ps_cpr_id, ref string ps_encounter_type, ref string ps_new_flag, ref datetime ps_encounter_date, ref string ps_chief_complaint, ref string ps_attending_doctor, ref string ps_office)
end prototypes

public function integer xx_initialize ();get_attribute("arrived_success", arrived_success)
get_attribute("arrived_error", arrived_error)
get_attribute("arrived_pending", arrived_pending)

if isnull(arrived_error) then arrived_error = "ERROR"
if isnull(arrived_success) then arrived_success = "OK"


set_timer() 
return 1


end function

protected function integer xx_set_checked_in (long pl_checked_in_id, string ps_cpr_id, long pl_encounter_id, string ps_status);string ls_status

if ps_status = "OK" then
	ls_status = arrived_success
else
	ls_status = arrived_error
end if

UPDATE x_encounterpro_Arrived
SET encounter_id = :pl_encounter_id,
	 status = :ls_status
WHERE message_id = :is_message_id
USING cprdb;

if not cprdb.check() then return -1
return 1

end function

protected function integer xx_get_next_checked_in (ref long pl_checked_in_id, ref string ps_cpr_id, ref string ps_encounter_type, ref string ps_new_flag, ref datetime ps_encounter_date, ref string ps_chief_complaint, ref string ps_attending_doctor, ref string ps_office);/*
Function Name:	xx_get_next_checked_in for u_component_schedule_encounterpro

Purpose:			Retrieves records from the x_encounterpro_Arrived table which
					provides information to create new open encounters
Expects:			Referenced values from u_component_schedule_encounterpro.timer_ding
Returns:			Integer
Access:			Protected
History:			None
Notes:
"Checked in" entries are in "x_encounterpro_Arrived" with a
status of "SCHEDULED"
When a valid x_encounterpro_Arrived record is found, move the values into 
variables for further processing and ease of use.
*/
//	Declare local variables

boolean	lb_loop
datetime	ldt_encounter_date_time
datetime	ldt_appointment_date_time
integer	li_array_empty_ctr
long		ll_encounter_billing_id
integer	li_encounter_number
string	ls_allow_past_encounter
string	ls_message_id
integer	li_arrived_cnt
integer	ls_sts

long 		ll_mult_rows,ll_encounter_id
string	ls_billing_id
string	ls_chief_complaint
string	ls_encounter_type
string	ls_primary_provider_id
string	ls_stg
string 	ls_patient_id
string	ls_cprid
string	ls_status
string	ls_facility
string	ls_office
string   ls_new_flag
string   ls_appointment_date,ls_open_encounter_type,ls_open_encounter_date
string   ls_encounter_date
string   ls_this_date
string   ls_thisdatetime
datetime ldt_encounter_Datetime,ldt_open_encounter_date
date		ld_thisdate
time		lt_thistime
datetime	ldt_default_appointment

ls_this_date = string(Today(),"yyyy/mm/dd")
ls_thisdatetime = string(today(),"yyyy/mm/dd hh:mm:ss")
ld_thisdate = Date(left(ls_thisdatetime,10))
lt_thistime = Time(Mid(ls_thisdatetime,12))
ldt_default_appointment = Datetime(ld_thisdate,lt_thistime)	

//	make sure always the least one is processed first 
// based on encounter datetime
ll_encounter_billing_id = 0
SELECT 	MIN(encounter_date_time)
INTO		:ldt_encounter_date_time
FROM		x_encounterpro_Arrived
WHERE		status = 'SCHEDULED'
USING		cprdb;
IF NOT cprdb.check() THEN RETURN -1
If isnull(ldt_encounter_date_time) Then Return 0

SELECT MIN(message_id) // this is unique key on this table
INTO :is_message_id
FROM x_encounterpro_arrived
WHERE status='SCHEDULED'
and encounter_date_time = :ldt_encounter_date_time
Using cprdb;
If not tf_check() then return -1
If isnull(is_message_id) Or len(trim(is_message_id)) = 0 Then Return 0
mylog.log(this, "u_component_schedule_encounterpro.xx_get_next_checked_in:0075","Processing Message ID (" + is_message_id + ", " + string(ldt_encounter_date_time,"yyyy/mm/dd hh:mm:ss") + ")",2)

SELECT billing_id,
		encounter_billing_id,
		message_id,
		encounter_type,
		primary_provider_id,
		chief_complaint,
		cpr_id,
		encounter_date_time,
		status,
		facility_namespaceid,
		office_id,
		new_flag,
		appointment_time
INTO	:ls_billing_id,
		:ll_encounter_billing_id,
		:ls_message_id,
		:ls_encounter_type,
		:ls_primary_provider_id,
		:ls_chief_complaint,
		:ls_cprid,
		:ldt_encounter_date_time,
		:ls_status,
		:ls_facility,
		:ls_office,
		:ls_new_flag,
		:ldt_appointment_date_time
FROM	x_encounterpro_Arrived
WHERE	status = 'SCHEDULED' AND
		encounter_date_time = :ldt_encounter_date_time AND
		message_id = :is_message_id
USING	cprdb;
IF NOT cprdb.check() THEN RETURN -1

if len(trim(ls_cprid)) = 0 OR isnull(ls_cprid) Then
	mylog.log(this, "u_component_schedule_encounterpro.xx_get_next_checked_in:0111","Cpr id is NULL",2)
	Return 0	
End If
IF cprdb.sqlcode = 0 THEN
	if isnull(ldt_appointment_date_time) then
		ldt_appointment_date_time = ldt_default_appointment
	end if	
	ls_appointment_date = string(ldt_appointment_date_time,"yyyy/mm/dd")
	ls_encounter_date = string(ldt_encounter_date_time,"yyyy/mm/dd")
	
	// if the past encounter is allowed then dont reject them. (added this for 'Womens place' as per Jeff Request)
	ls_allow_past_encounter = datalist.get_preference("PREFERENCES", "ALLOW_PAST_ENCOUNTERS")
	if isnull(ls_allow_past_encounter) or len(ls_allow_past_encounter) = 0 then ls_allow_past_encounter = 'N'
	if left(upper(ls_allow_past_encounter),1) = "F" or left(upper(ls_allow_past_encounter),1) = 'N' Then

//		ps_encounter_date = string(Today(),"mm/dd/yyyy")
		if ls_appointment_date = ls_this_date then
			ps_encounter_date = datetime(today(),now()) //ldt_encounter_date_time
		else
			update x_encounterpro_arrived
			set status = 'OUTOFDATE'
			WHERE		status = 'SCHEDULED' AND
			message_id = :is_message_id
			USING 	cprdb;
			IF NOT cprdb.check() THEN RETURN -1
			mylog.log(this, "u_component_schedule_encounterpro.xx_get_next_checked_in:0136","Encounter Billing ID, Message ID (" + ls_billing_id + ", " + ls_message_id + ") is out of date",2)
			Return 1
		ENd If	
	else
		ps_encounter_date = ldt_encounter_date_time
	end if
	
	// Check if there's an open encounter for this patient 
	SELECT max(encounter_id)
	INTO :ll_encounter_id
	FROM p_patient_encounter
	WHERE cpr_id = :ls_cprid
	AND encounter_status = 'OPEN';

	if not isnull(ll_encounter_id) then
		select encounter_date,
				 encounter_type
		into :ldt_open_encounter_date,
			  :ls_open_encounter_type
		from p_patient_encounter
		where cpr_id = :ls_cprid
		and encounter_id = :ll_encounter_id;
	
		ls_open_encounter_date = string(ldt_open_encounter_date,"yyyy/mm/dd hh:mm:ss")
		If (left(ls_open_encounter_date,10) = ls_this_date) and (ls_open_encounter_type = ls_encounter_type) then // encounter created for the same day
			Update x_encounterpro_arrived
			Set status = 'DUPLICATE'
			WHERE	status = 'SCHEDULED' AND
			message_id = :is_message_id
			and billing_id = :ls_billing_id
			USING 	cprdb;
			IF NOT cprdb.check() THEN RETURN -1
			mylog.log(this, "u_component_schedule_encounterpro.xx_get_next_checked_in:0168","There's already an open encounter("+string(ll_encounter_id)+" for this Billing ID, Message ID (" + ls_billing_id + ", " + is_message_id + ")",3)
			Return 1
		End If
	End If
			
	//	The local variables now contain data ready to process into an encounter
	pl_checked_in_id = ll_encounter_billing_id
	ps_cpr_id = ls_cprid
	ps_encounter_type = ls_encounter_type
	ps_new_flag = ls_new_flag
	ps_chief_complaint = ls_chief_complaint
	ps_attending_doctor = ls_primary_provider_id
	ps_office = ls_office
	ls_status = "OPEN"
ELSE
	RETURN -1
END IF	

// A valid row has now been processed from x_encounterpro_Arrived
mylog.log(this, "u_component_schedule_encounterpro.xx_get_next_checked_in:0187","Encounter Message has been processed, Billing ID, Message ID (" + ls_billing_id + ", " + ls_message_id + ")",2)

UPDATE x_encounterpro_Arrived
SET  status = 'OK'
WHERE message_id = :is_message_id
USING cprdb;
if not cprdb.check() then return -1

// Now return to timer_ding with 1, run this again, and check for additional
// records ready to be processed into an encounter
RETURN 1
end function

on u_component_schedule_encounterpro.create
call super::create
end on

on u_component_schedule_encounterpro.destroy
call super::destroy
end on

