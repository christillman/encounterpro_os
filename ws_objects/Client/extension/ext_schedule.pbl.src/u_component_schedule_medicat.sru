$PBExportHeader$u_component_schedule_medicat.sru
forward
global type u_component_schedule_medicat from u_component_schedule
end type
end forward

global type u_component_schedule_medicat from u_component_schedule
end type
global u_component_schedule_medicat u_component_schedule_medicat

type variables
string billing_system_group
string arrived_success
string arrived_error
string arrived_pending
string is_ClinicCodes[]
string is_offices[]
integer  ii_office_count


end variables

forward prototypes
public function integer update_patient (long pl_checked_in_id, ref string ps_cpr_id)
protected function integer xx_set_checked_in (long pl_checked_in_id, string ps_cpr_id, long pl_encounter_id, string ps_status)
public function long start_ticket (string ps_cpr_id, long pl_encounter_id)
public function integer xx_initialize ()
protected function integer xx_get_next_checked_in (ref long pl_checked_in_id, ref string ps_cpr_id, ref string ps_encounter_type, ref string ps_new_flag, ref datetime ps_encounter_date, ref string ps_chief_complaint, ref string ps_attending_doctor, ref string ps_office)
public function integer update_insurance (string ps_cpr_id, long pl_patientid)
end prototypes

public function integer update_patient (long pl_checked_in_id, ref string ps_cpr_id);string ls_race
datetime ldt_date_of_birth
string ls_sex
string ls_phone_number
string ls_primary_language
string ls_marital_status
string ls_billing_id
long ll_null
string ls_first_name
string ls_last_name
string ls_degree
string ls_name_prefix
string ls_middle_name
string ls_name_suffix
string ls_primary_provider_id
string ls_secondary_provider_id
string ls_ssn 
integer li_priority
long ll_PatientId
long ll_MaritalStatusMId
long ll_RaceMId
string ls_ProviderCode
integer li_sts
string ls_cpr_id

ls_cpr_id = ps_cpr_id
setnull(ll_null)

SELECT PatientId
INTO :ll_PatientId
FROM Appointment
WHERE Id = :pl_checked_in_id
USING Mydb;
if not mydb.check() then return -1
if mydb.sqlcode = 100 then return -2

SELECT birthdate,
		 sex,
		 firstname,
		 middleinitial,
		 lastname,
		 homephone,
		 ProviderCode
INTO	:ldt_date_of_birth,   &
		:ls_sex,   &
		:ls_first_name,   &
		:ls_middle_name,   &
		:ls_last_name,   &
		:ls_phone_number, &
		:ls_ProviderCode
FROM Patient
WHERE id = :ll_PatientId
USING Mydb;
if not mydb.check() then return -1
if mydb.sqlcode = 100 then return -3

setnull(ls_marital_status)
setnull(ls_race)
setnull(ls_name_prefix)
setnull(ls_name_suffix)
setnull(ls_degree)
setnull(ls_ssn)

ls_billing_id = string(ll_PatientId)

// Look up provider
if not isnull(ls_ProviderCode) then
	SELECT provider_id
	INTO :ls_primary_provider_id
	FROM c_Provider
	WHERE billing_id = :ls_ProviderCode
	USING cprdb;
	if not cprdb.check() then return -1
	if cprdb.sqlcode = 100 then
		setnull(ls_primary_provider_id)
	end if
end if

if isnull(ls_cpr_id) then
	li_sts = f_create_new_patient( &
									ls_cpr_id,   &
									ls_race,   &
									date(ldt_date_of_birth),   &
									ls_sex,   &
									ls_phone_number, &
									ls_primary_language,   &
									ls_marital_status,   &
									ls_billing_id,   &
									ll_null,   &
									ls_first_name,   &
									ls_last_name,   &
									ls_degree,   &
									ls_name_prefix,   &
									ls_middle_name,   &
									ls_name_suffix,   &
									ls_primary_provider_id, &
									ls_secondary_provider_id, &
									li_priority, &
									ls_ssn)
	if li_sts <= 0 then return -4
else
	UPDATE p_Patient
	SET	name_prefix = :ls_name_prefix,
		first_name = :ls_first_name,
		middle_name = :ls_middle_name,
		last_name = :ls_last_name,
		name_suffix = :ls_name_suffix,
		phone_number = :ls_phone_number,
		date_of_birth = :ldt_date_of_birth,
		sex = :ls_sex,
		primary_provider_id = :ls_primary_provider_id,
		billing_id = :ls_billing_id,
		marital_status = :ls_marital_status,
		race = :ls_race
	WHERE cpr_id = :ls_cpr_id
	USING cprdb;
	if not cprdb.check() then return -1
	if cprdb.sqlcode = 100 then return -5
end if

li_sts = update_insurance(ls_cpr_id, ll_PatientId)
ps_cpr_id = ls_cpr_id

return 1

end function

protected function integer xx_set_checked_in (long pl_checked_in_id, string ps_cpr_id, long pl_encounter_id, string ps_status);string ls_status, ls_comment
long ll_ticketid

Select Comment into :ls_comment
	from Appointment
	WHERE ID = :pl_checked_in_id
	USING mydb;
if not mydb.check() then return -1

if isnull(ls_comment) or ls_comment = "" then
	ls_comment = '(epro-checked-in)'
else
	ls_comment += ' (epro-checked-in)'
end if	

if ps_status = "OK" then
	UPDATE Appointment
	SET comment = :ls_comment
	WHERE ID = :pl_checked_in_id
	USING mydb;
	if not mydb.check() then return -1
else
	// If we had a problem then un-checkin the patient
	UPDATE Appointment
	SET Checkedin = 0
	WHERE ID = :pl_checked_in_id
	USING mydb;
	if not mydb.check() then return -1
end if

INSERT INTO x_medicat_arrived (
	appointmentID,
	cpr_id,
	encounter_id,
	status)
VALUES (
	:pl_checked_in_id,
	:ps_cpr_id,
	:pl_encounter_id,
	:ps_status)
USING cprdb;
if not cprdb.check() then return -1

return 1

end function

public function long start_ticket (string ps_cpr_id, long pl_encounter_id);long ll_PatientID
long ll_TicketPatientID
datetime ldt_DateOfservice
long ll_TicketID
string ls_facility
string ls_office
int li_count = 1
boolean lb_loop
lb_loop = true

SELECT patient_id
INTO :ll_PatientID
FROM p_Patient
WHERE cpr_id = :ps_cpr_id using cprdb;
if not cprdb.check() then return -1
if sqlca.sqlcode = 100 then return 0

SELECT encounter_date,
		encounter_billing_id
INTO :ldt_DateOfservice,
		:ll_TicketID
FROM p_Patient_Encounter
WHERE cpr_id = :ps_cpr_id
AND encounter_id = :pl_encounter_id using cprdb;
if not cprdb.check() then return -1
if sqlca.sqlcode = 100 then return 0

if not isnull(ll_TicketID) then
	SELECT PatientID
	INTO :ll_TicketPatientID
	FROM Ticket
	WHERE ID = :ll_TicketID
	USING mydb;
	if not mydb.check() then return -1
	if sqlca.sqlcode = 100 then
		setnull(ll_TicketID)
	elseif ll_TicketPatientID <> ll_PatientID then
		setnull(ll_TicketID)
	end if
end if

if isnull(ll_TicketID) then
	Do
	ls_facility = is_ClinicCodes[li_count]
	ls_office = is_offices[li_count]
	DECLARE lsp_epStartTicket PROCEDURE FOR dbo.epStartTicket
  		@PatientID = :ll_PatientID,
  		@ClinicCode = :ls_facility,
  		@DateOfservice = :ldt_DateOfservice
	USING mydb;
	
	EXECUTE lsp_epStartTicket;
	if not mydb.check() then return -1
	
	FETCH lsp_epStartTicket INTO :ll_TicketID;
	if not mydb.check() then return -1
	
	if mydb.sqlcode <> 0 then
		li_count++
		if li_count > ii_office_count then
			lb_loop = false
		end if
	else
		lb_loop = false
	end if
	
	CLOSE lsp_epStartTicket;
	
	LOOP	While lb_loop	
	
	UPDATE p_Patient_Encounter
	SET encounter_billing_id = :ll_TicketID
	WHERE cpr_id = :ps_cpr_id
	AND encounter_id = :pl_encounter_id using cprdb;
	if not cprdb.check() then return -1
end if

return ll_TicketID


end function

public function integer xx_initialize ();string ls_temp, ls_temp2
get_attribute("ClinicCode", ls_temp)
if isnull(ls_temp) or ls_temp = "" then
	mylog.log(this, "xx_initialize()", "ERROR: No Schedule Clinic Code Specified.", 4)
	return -1
end if

get_attribute("arrived_success", arrived_success)
get_attribute("arrived_error", arrived_error)

if isnull(arrived_success) then arrived_success = "Checked In"
if isnull(arrived_error) then arrived_error = "Not Checked In"

string ls_facilitycode

string ls_office
int li_count = 0
int thisnull
boolean lb_loop

long ll_pos
ll_pos = Pos(ls_temp,",")
ii_office_count = 1
do while ll_pos > 0
	ls_temp2 = trim(left(ls_temp, ll_pos - 1))
		is_ClinicCodes[ii_office_count] = ls_temp2
		ii_office_count ++
	ls_temp = mid(ls_temp,ll_pos + 1)
	ll_pos = Pos(ls_temp,",")
loop

is_ClinicCodes[ii_office_count] = ls_temp

if isnull(is_ClinicCodes[1]) or is_ClinicCodes[1] = "" then
	mylog.log(this, "xx_initialize()", "ERROR: Schedule Clinic Code not entered.", 4)
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
			:ls_facilitycode:thisnull;
	if not cprdb.check() then return -1

	if cprdb.sqlcode = 0 then
		If not Isnull(thisnull) then
			for li_count = 1 to ii_office_count
				if is_ClinicCodes[li_count] = ls_facilitycode then
					is_offices[li_count] = ls_office
					mylog.log(this, "xx_initialize()", "office=" + ls_office + ", facility=" + ls_facilitycode,2)
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

return db_connect()

end function

protected function integer xx_get_next_checked_in (ref long pl_checked_in_id, ref string ps_cpr_id, ref string ps_encounter_type, ref string ps_new_flag, ref datetime ps_encounter_date, ref string ps_chief_complaint, ref string ps_attending_doctor, ref string ps_office);integer li_sts
long ll_PatientId
string ls_billing_id
string ls_ProviderCode
datetime ldt_AppointmentDate
string ls_ReasonCode
string ls_status
string ls_resource
long ll_count
datetime ldt_three_years_ago
string ls_cpr_id
long ll_null
boolean lb_loop, lb_fetch
long ll_encounter_id
string ls_facility
string ls_office
int li_count = 1
lb_loop = true

Do
	ls_facility = is_ClinicCodes[li_count]
	ls_office = is_offices[li_count]
	
 	DECLARE lsp_epGetNextCheckedIn PROCEDURE FOR dbo.epGetNextCheckedIn
         @ClinicCode = :ls_facility
	USING mydb;

	setnull(ll_null)
	setnull(ps_new_flag)
	ldt_three_years_ago = datetime(relativedate(today(), -1095))

	EXECUTE lsp_epGetNextCheckedIn;
	if not mydb.check() then return -1
	lb_fetch = true
	DO 
	FETCH	lsp_epGetNextCheckedIn INTO
		:pl_checked_in_id,
		:ldt_AppointmentDate,
		:ll_PatientId,
		:ls_ProviderCode,
		:ls_ReasonCode;
	if not mydb.check() then return -1
		
	if mydb.sqlcode <> 0 then
		lb_fetch = false
		li_sts = 0
		li_count++
		if li_count > ii_office_count then
			lb_loop = false
		end if
	else
		SELECT encounter_id
		INTO :ll_encounter_id
		FROM x_medicat_arrived
		WHERE appointmentid = :pl_checked_in_id
		And status in ('NA', 'ERROR')
		USING cprdb;
		if not cprdb.check() then return -1
		if not cprdb.sqlcode = 0 then 
			li_sts = 1
			lb_fetch = false
			lb_loop = false
		end if	
	end if
	LOOP While lb_fetch
	CLOSE lsp_epGetNextCheckedIn;
LOOP While lb_loop	

if li_sts = 0 then return li_sts

if li_sts > 0 then
	mylog.log(this, "xx_get_next_checked_in()", "Retrieval " + string(pl_checked_in_id), 1)
	// Check to see if the patient has already been checked in
	SELECT encounter_id, status
	INTO :ll_encounter_id, :ls_status
	FROM x_medicat_arrived
	WHERE appointmentid = :pl_checked_in_id
	USING cprdb;
	if not cprdb.check() then return -1
		
	if cprdb.sqlcode = 0 then
		// If the appointment already exists in the x_medicat_arrived table, then we
		// shouldn't be here.  
		// there must be license problem ... has it been cleared up? we will try again to checkin 
		// Now don't check in this patient
		return 0
	end if
end if

if li_sts = 0 then return li_sts
if not ls_office = "" then
	ps_office = ls_office
end if	

//ps_encounter_date = string(ldt_AppointmentDate, "[shortdate]")
ps_encounter_Date = ldt_AppointmentDate
setnull(ps_chief_complaint)
pl_checked_in_id = pl_checked_in_id

ls_billing_id = string(ll_PatientId)

SELECT name
INTO :ps_chief_complaint
FROM AppointmentReason
WHERE ClinicCode = :ls_facility
AND Code = :ls_ReasonCode
USING mydb;
if not mydb.check() then return -1
if mydb.sqlcode = 100 then setnull(ps_chief_complaint)

if isnull(ls_ProviderCode) then
	setnull(ps_attending_doctor)
else
	SELECT user_id
	INTO :ps_attending_doctor
	FROM c_user
	WHERE billing_id = :ls_ProviderCode
	USING cprdb;
	if not cprdb.check() then return -1
	if cprdb.sqlcode = 100 then
		setnull(ps_attending_doctor)
	end if
end if

SELECT cpr_id
INTO :ps_cpr_id
FROM p_Patient
WHERE billing_id = :ls_billing_id
USING cprdb;
if not cprdb.check() then return -1
if cprdb.sqlcode = 100 then
	setnull(ps_cpr_id)
end if

SELECT encounter_type,
		 new_flag
INTO :ps_encounter_type,
		:ps_new_flag
FROM b_Appointment_Type
WHERE appointment_type = :ls_ReasonCode
USING cprdb;
if not cprdb.check() then return -1
if cprdb.sqlcode = 100 then
	setnull(ps_encounter_type)
	setnull(ps_new_flag)
end if

// If appointment_type didn't provide new_flag, then figure it out
if isnull(ps_new_flag) then
	SELECT count(*)
	INTO :ll_count
	FROM Ticket
	WHERE PatientId = :ll_PatientId
	AND TicketDate > :ldt_three_years_ago
	USING mydb;
	if not mydb.check() then return -1
	
	if ll_count > 0 then
		ps_new_flag = "N"
	else
		ps_new_flag = "Y"
	end if
end if
if isnull(ps_new_flag) then ps_new_flag = "N"
// If we still don't have an encounter_type, then use the default
if isnull(ps_encounter_type) then
	ps_encounter_type = get_attribute("default_encounter_type")
end if

// If we still don't have an attending_doctor, then set the default role
if isnull(ps_attending_doctor) then
	SELECT default_role
	INTO :ps_attending_doctor
	FROM c_Encounter_Type
	WHERE encounter_type = :ps_encounter_type
	USING cprdb;
	if not cprdb.check() then return -1
	if cprdb.sqlcode = 100 then setnull(ps_attending_doctor)
end if

li_sts = update_patient(pl_checked_in_id, ps_cpr_id)
if li_sts <= 0 then return -1

return 1

end function

public function integer update_insurance (string ps_cpr_id, long pl_patientid);u_ds_data luo_data
integer li_count
integer i
string ls_code
string ls_insurance_id
string ls_name
long ll_id
string ls_insurance_type
string ls_allocation

setnull(ls_allocation)

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_medicat_insurance", mydb)
li_count = luo_data.retrieve(pl_patientid)
if li_count < 0 then return -1

DELETE p_Patient_Authority
WHERE cpr_id = :ps_cpr_id
USING cprdb;
if not cprdb.check() then return -1

if li_count = 0 then 
	DESTROY luo_data
	return 1
end if	

for i = 1 to li_count
	ls_insurance_id = luo_data.object.code[i]
	ls_name = luo_data.object.name[i]
	ll_id = luo_data.object.id[i]
	ls_insurance_type = luo_data.object.insurancetype[i]
	
	SELECT authority_id
	INTO :ls_code
	FROM c_Authority 
	WHERE authority_id = :ls_insurance_id
	USING cprdb;
	if not cprdb.check() then return -1
	if cprdb.sqlcode = 100 then
		INSERT INTO c_Authority (
			authority_id,
			authority_type,
			authority_category,
			name,
			coding_component_id,
			status		)
		VALUES (
			:ls_insurance_id,
			'PAYOR',
			:ls_insurance_type,
			:ls_name,
			null,
			'OK')
	USING cprdb;			
		if not cprdb.check() then continue
	end if
		
	INSERT INTO p_Patient_Authority  
         ( cpr_id,  
			  authority_type,	
           authority_sequence,   
           authority_id,   
           notes,   
           created,   
           created_by,   
           modified_by)
  VALUES ( :ps_cpr_id,
  				'PAYOR',
           :i,
           :ls_insurance_id,   
           null,   
           getdate(),
           :system_user_id,
			  :system_user_id)		
	using cprdb;
	if not cprdb.check() then continue
next

DESTROY luo_data

return 1

end function

on u_component_schedule_medicat.create
call super::create
end on

on u_component_schedule_medicat.destroy
call super::destroy
end on

