﻿$PBExportHeader$u_component_schedule_medman.sru
forward
global type u_component_schedule_medman from u_component_schedule
end type
end forward

global type u_component_schedule_medman from u_component_schedule
end type
global u_component_schedule_medman u_component_schedule_medman

type variables
integer ii_encounter_billing_id
long FacilityId
string arrived_success
string arrived_error
string arrived_pending
string billing_system_group
string is_facilities[]
long il_facilities[]
string is_offices[]
integer  ii_office_count
string is_billing_id
long  il_message_id
end variables

forward prototypes
protected function integer xx_set_checked_in (long pl_checked_in_id, string ps_cpr_id, long pl_encounter_id, string ps_status)
protected function integer xx_initialize ()
protected function integer xx_get_next_checked_in (ref long pl_checked_in_id, ref string ps_cpr_id, ref string ps_encounter_type, ref string ps_new_flag, ref datetime ps_encounter_date, ref string ps_chief_complaint, ref string ps_attending_doctor, ref string ps_office)
end prototypes

protected function integer xx_set_checked_in (long pl_checked_in_id, string ps_cpr_id, long pl_encounter_id, string ps_status);/*
Function Name:	xx_set_checked_in for u_component_schedule_medman
Date Begun:		December 2, 1998
Programmer:		George E. Snead
Purpose:			Assign a value of "ARRIVED" or "ERROR" to records
					in x_MedMan_Arrived based on previous processing
Expects:			pl_checked_in_id		long		value
					ps_cpr_id				string	value
					pl_encounter_id		long		value
					ps_status				string	value	
Returns:			Integer
					1 if the update to x_MedMan_Arrived was successful
					-1 if it failed
Access:			Protected
History:			None
Notes:
*/

string 	ls_status
string	ls_billing_id

if ps_status = "OK" then
	ls_status = "ARRIVED"
else
	ls_status = "ERROR"
end if

UPDATE x_medman_Arrived
SET encounter_id = :pl_encounter_id,
	 status = :ls_status
WHERE message_id = :il_message_id
AND billing_id = :is_billing_id
USING cprdb;
if not cprdb.check() then return -1

RETURN 1
end function

protected function integer xx_initialize ();string ls_temp, ls_temp2
get_attribute("FacilityId", ls_temp)
if isnull(ls_temp) or ls_temp = "" then
	mylog.log(this, "u_component_schedule_medman.xx_initialize:0004", "ERROR: No Schedule Facility ID Specified.", 4)
	return -1
end if

get_attribute("arrived_success", arrived_success)
get_attribute("arrived_error", arrived_error)
get_attribute("arrived_pending", arrived_pending)

if isnull(arrived_success) then arrived_success = "Checked In"
if isnull(arrived_error) then arrived_error = "Not Checked In"
if isnull(arrived_pending) then arrived_pending = "pending"

string ls_facility
ls_facility = ""
string ls_office
int li_count = 0
int thisnull
boolean lb_loop

long ll_pos
ll_pos = Pos(ls_temp,",")
ii_office_count = 1
do while ll_pos > 0
	ls_temp2 = trim(left(ls_temp, ll_pos - 1))
	is_facilities[ii_office_count] = ls_temp2
		ii_office_count ++
	ls_temp = mid(ls_temp,ll_pos + 1)
	ll_pos = Pos(ls_temp,",")
loop

is_facilities[ii_office_count] = ls_temp


if isnull(is_facilities[1]) or is_facilities[1] = ""  then
	mylog.log(this, "u_component_schedule_medman.xx_initialize:0038", "ERROR: Schedule Facility ID not found.", 4)
	ii_office_count = 0
	return -1
end if	

for li_count = 1 to ii_office_count
	is_offices[li_count] = ""
next

DECLARE lc_facilitycursor CURSOR FOR  
  		SELECT c_Office.office_id,
		  		 c_Office.billing_id 
    	FROM c_Office using cprdb ;
Open lc_facilitycursor;
if not cprdb.check() then return -1
lb_loop = true

DO
	Fetch lc_facilitycursor into 
			:ls_office,
			:ls_facility:thisnull;
	if not cprdb.check() then return -1

	if cprdb.sqlcode = 0 then
		If not Isnull(thisnull) then
			for li_count = 1 to ii_office_count
				if is_facilities[li_count] = ls_facility then
					is_offices[li_count] = ls_office
					mylog.log(this, "u_component_schedule_medman.xx_initialize:0066", "office=" + ls_office + ", facility=" + ls_facility,2)
					exit
				end if	
			next
		end if
	else
		lb_loop = false
	end if	
LOOP	While lb_loop	
			
Close lc_facilitycursor;
set_timer()
return 1

end function

protected function integer xx_get_next_checked_in (ref long pl_checked_in_id, ref string ps_cpr_id, ref string ps_encounter_type, ref string ps_new_flag, ref datetime ps_encounter_date, ref string ps_chief_complaint, ref string ps_attending_doctor, ref string ps_office);/*
Function Name:	xx_get_next_checked_in 
Purpose:			Retrieves records from the x_medman_Arrived table which
					provides information to create new open encounters
Expects:			Referenced values from u_component_schedule_medman.timer_ding
Returns:			Integer
Access:			Protected
History:			None
Notes:
"Checked in" entries are in "x_medman_Arrived" with a
status of "SCHEDULED"
When a valid x_medman_Arrived record is found, move the values into 
variables for further processing and ease of use.
*/
//	Declare local variables

long ll_encounter_id
string ls_open_encounter_date,ls_open_encounter_type
boolean	lb_loop
datetime	ldt_encounter_date_time,ldt_open_encounter_date
integer	li_array_empty_ctr
integer	li_filenum	
long		ll_encounter_billing_id
integer	li_encounter_number
long	ll_message_id
integer	li_arrived_cnt
integer	ls_sts,i

long 		ll_mult_rows
string	ls_billing_id
string	ls_chief_complaint
string	ls_comment2
string	ls_data_filepath
string	ls_encounter_type
string	ls_filename
string	ls_filepath
string	ls_primary_provider_id
string	ls_stg
string	ls_array[]
string 	ls_patient_id
string	ls_cprid
string	ls_status
string	ls_array_empty
string	ldt_arrive_Datetime
string 	ls_facility
string   ls_this_date
string   ls_new_flag
string   ls_appointment_date
string   ls_encounter_date
string   ls_thisdatetime
date	ld_thisdate
time	lt_thistime
datetime	ldt_default_appointment
datetime ldt_appointment_date_time

ls_this_date = string(Today(),"yyyy/mm/dd")
ls_thisdatetime = string(today(),"yyyy/mm/dd hh:mm:ss")
ld_thisdate = Date(left(ls_thisdatetime,10))
lt_thistime = Time(Mid(ls_thisdatetime,12))
ldt_default_appointment = Datetime(ld_thisdate,lt_thistime)	

//set default office
ps_office = gnv_app.office_id
ll_encounter_billing_id = 0

SELECT MIN(message_id) // this is unique key on this table
INTO :il_message_id
FROM x_medman_arrived
WHERE status='SCHEDULED'
Using cprdb;
If not tf_check() then return -1
If isnull(il_message_id) Or il_message_id = 0 Then Return 0

SELECT MIN(billing_id) // this is unique key on this table
INTO :is_billing_id
FROM x_medman_arrived
WHERE status='SCHEDULED'
and message_id = :il_message_id
Using cprdb;
If not tf_check() then return -1

If isnull(is_billing_id) Or len(trim(is_billing_id)) = 0 Then
	mylog.log(this, "u_component_schedule_medman.xx_get_next_checked_in:0083","no records for a given message id "+string(il_message_id),3)
	Return 0
end if

SELECT billing_id,
		encounter_billing_id,
		message_id,
		encounter_type,
		primary_provider_id,
		chief_complaint,
		cpr_id,
		encounter_date_time,
		status,
		facilityid,
		new_flag,
		appointment_time
INTO	:ls_billing_id,
		:ll_encounter_billing_id,
		:il_message_id,
		:ls_encounter_type,
		:ls_primary_provider_id,
		:ls_chief_complaint,
		:ls_cprid,
		:ldt_encounter_date_time,
		:ls_status,
		:ls_facility,
		:ls_new_flag,
		:ldt_appointment_date_time
FROM	x_medman_Arrived
WHERE	status = 'SCHEDULED'
		AND message_id = :il_message_id
		AND billing_id = :is_billing_id
USING	cprdb;
IF NOT cprdb.check() THEN RETURN -1
mylog.log(this, "u_component_schedule_medman.xx_get_next_checked_in:0117","Processing Message ID,billing id (" + string(il_message_id) + ", " + is_billing_id +")",2)

if isnull(ldt_appointment_date_time) then
	ldt_appointment_date_time = ldt_default_appointment
end if
ls_appointment_date = string(ldt_appointment_date_time,"yyyy/mm/dd")
ls_encounter_date = string(ldt_encounter_date_time,"yyyy/mm/dd")
if (ls_appointment_date = ls_this_date) and (ls_encounter_date = ls_this_date) then
	ls_encounter_date = string(ldt_encounter_date_time,"yyyy/mm/dd")
	ps_encounter_date = ldt_encounter_date_time
else
	Update x_medman_arrived
	Set status = 'OUTOFDATE'
	WHERE	status = 'SCHEDULED' AND
	message_id = :il_message_id
	and billing_id = :is_billing_id
	USING 	cprdb;
	IF NOT cprdb.check() THEN RETURN -1
	mylog.log(this, "u_component_schedule_medman.xx_get_next_checked_in:0135","Appointment Billing ID, Message ID (" + is_billing_id + ", " + string(il_message_id) + ") is out of date",2)
	Return 1
End if	

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
		Update x_medman_arrived
		Set status = 'DUPLICATE'
		WHERE	status = 'SCHEDULED' AND
		message_id = :il_message_id
		and billing_id = :is_billing_id
		USING 	cprdb;
		IF NOT cprdb.check() THEN RETURN -1
		mylog.log(this, "u_component_schedule_medman.xx_get_next_checked_in:0164","There's already an open encounter("+string(ll_encounter_id)+" for this Billing ID, Message ID (" + ls_billing_id + ", " + string(il_message_id) + ")",3)
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
ls_status = "OPEN"
// A valid row has now been processed from x_medman_Arrived
if isnull(ls_comment2) or ls_comment2 = '' then 
	ps_new_flag = ls_new_flag
else	
	SELECT 	 new_flag
	INTO 	:ps_new_flag
	FROM b_Appointment_Type
	WHERE appointment_type = :ls_comment2
	USING cprdb;
	if not cprdb.check() then return -1
end if	
mylog.log(this, "u_component_schedule_medman.xx_get_next_checked_in:0187","Appointment Message has been processed, Billing ID (" + ls_billing_id + ")",1)
If ii_office_count = 1 then
	ps_office = is_offices[1]
	return 1
end if

if isnull(ls_facility) or ls_facility = "" then return 1

//for multi site facilities	
lb_loop = true
integer li_count
li_count = 1
Do
	if ls_facility = is_facilities[li_count] then
		if not IsNull(is_offices[li_count]) and not is_offices[li_count] = "" then
			ps_office = is_offices[li_count]
			lb_loop = false
			Return 1
		end if	
	end if	
	li_count++
	if li_count > ii_office_count then lb_loop = false
LOOP	While lb_loop

mylog.log(this, "u_component_schedule_medman.xx_get_next_checked_in:0211", "Error with matching facility to office using default office, Billing ID, facility (" + ls_billing_id + ", " + ls_facility + ")",2)

// Now return to timer_ding with 1, run this again, and check for additional
// records ready to be processed into an encounter

RETURN 1

end function

on u_component_schedule_medman.create
call super::create
end on

on u_component_schedule_medman.destroy
call super::destroy
end on

