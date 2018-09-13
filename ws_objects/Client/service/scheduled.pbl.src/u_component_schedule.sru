$PBExportHeader$u_component_schedule.sru
forward
global type u_component_schedule from u_component_base_class
end type
end forward

global type u_component_schedule from u_component_base_class
end type
global u_component_schedule u_component_schedule

type variables

end variables

forward prototypes
protected function integer xx_set_checked_in (long pl_checked_in_id, string ps_cpr_id, long pl_encounter_id, string ps_status)
public function integer check_race (string ps_race, string ps_race_description, integer pi_sort_sequence)
protected function integer xx_get_next_checked_in (ref long pl_checked_in_id, ref string ps_cpr_id, ref string ps_encounter_type, ref string ps_new_flag, ref datetime ps_encounter_date, ref string ps_chief_complaint, ref string ps_attending_doctor, ref string ps_office)
public function integer timer_ding ()
end prototypes

protected function integer xx_set_checked_in (long pl_checked_in_id, string ps_cpr_id, long pl_encounter_id, string ps_status);if ole_class then
	return ole.set_checked_in(pl_checked_in_id, &
										ps_cpr_id, &
										pl_encounter_id, &
										ps_status)
else
	return 100
end if

end function

public function integer check_race (string ps_race, string ps_race_description, integer pi_sort_sequence);integer li_count
integer li_domain_sequence
string ls_description

// Check to see if race already exists
SELECT domain_item_description
INTO :ls_description
FROM c_Domain
WHERE domain_id = 'RACE'
AND domain_item = :ps_race
USING cprdb;
if not cprdb.check() then return -1

if cprdb.sqlcode = 100 then
	// If the race doesn't exist we need to add it.  First check
	// to see if the sort_sequence exists as a domain_sequence
	SELECT count(*)
	INTO :li_count
	FROM c_Domain
	WHERE domain_id = 'RACE'
	AND domain_sequence = :pi_sort_sequence
	USING cprdb;
	if not cprdb.check() then return -1
	
	// If the sort_sequence exists as a domain_sequence, then assign the
	// new domain_sequence by using the max domain_sequence + 1
	if li_count > 0 then
		SELECT max(domain_sequence) + 1
		INTO :li_domain_sequence
		FROM c_Domain
		WHERE domain_id = 'RACE'
		USING cprdb;
		if not cprdb.check() then return -1
		
		// Just to be sure, check for null
		if isnull(li_domain_sequence) then li_domain_sequence = 1
	else
		// If the sort_sequence didn't exist as a domain_sequence, then
		// use the sort_sequence in an attempt to preserve the order
		// from the foreign system
		li_domain_sequence = pi_sort_sequence
	end if
	
	// Then insert the new race record
	INSERT INTO c_Domain (
		domain_id,
		domain_sequence,
		domain_item,
		domain_item_description)
	VALUES (
		'RACE',
		:li_domain_sequence,
		:ps_race,
		:ps_race_description)
	USING cprdb;
	if not cprdb.check() then return -1
else
	// If the description has changed then update it
	if ls_description <> ps_race_description then
		UPDATE c_Domain
		SET domain_item_description = :ps_race_description
		WHERE domain_id = 'RACE'
		AND domain_item = :ps_race
		USING cprdb;
		if not cprdb.check() then return -1
	end if
end if

			
return 1




end function

protected function integer xx_get_next_checked_in (ref long pl_checked_in_id, ref string ps_cpr_id, ref string ps_encounter_type, ref string ps_new_flag, ref datetime ps_encounter_date, ref string ps_chief_complaint, ref string ps_attending_doctor, ref string ps_office);if ole_class then
	return ole.object.get_next_checked_in(pl_checked_in_id, &
													  ps_cpr_id, &
													  ps_encounter_type, &
													  ps_new_flag, &
													  ps_encounter_date, &
													  ps_chief_complaint, &
													  ps_attending_doctor)
else
	return 100
end if

end function

public function integer timer_ding ();integer 	li_sts
integer 	li_found_one
long 		ll_checked_in_id
long 		ll_new_encounter_id
string 	ls_cpr_id
string 	ls_encounter_type
string 	ls_new_flag
string 	ls_encounter_date
string 	ls_chief_complaint
string 	ls_attending_doctor
datetime ldt_now1
datetime ldt_now2
datetime ldt_then
datetime ldt_appointment_datetime
long 		ll_encounter_id
long 		ll_facility
string 	ls_status
string 	ls_office
string 	ls_pref
string 	ls_then
string 	ls_temp
string 	ls_date
string 	ls_time
string 	ls_logon

// Check Whether current_user is valid
if isnull(current_user) or not isvalid(current_user) then
	if server_service_id <= 0 or isnull(server_service_id) then
		log.log(this,"u_component_schedule.timer_ding:0029","current user can't be set ",3)
		Return 1
	end if
	SELECT system_user_id
	INTO :ls_logon
	FROM o_server_component
	WHERE service_id = :server_service_id;
	if not tf_check() then return -1
	current_user = user_list.find_user(ls_logon)
end if
if isnull(current_user) or not isvalid(current_user) then
	log.log(this,"u_component_schedule.timer_ding:0040","current user object invalid ",3)
	return 1
end if

li_sts = 1
ls_office = office_id
li_found_one = xx_get_next_checked_in(	ll_checked_in_id, &
													ls_cpr_id, &
													ls_encounter_type, &
													ls_new_flag, &
													ldt_appointment_datetime, &
													ls_chief_complaint, &
													ls_attending_doctor, &
													ls_office)
if li_found_one > 0 then

	if isnull(ls_new_flag) then ls_new_flag = "N"
	
	// If the attending_doctor is null, then we don't actually check in the patient.
	if isnull(ls_attending_doctor) then
		li_sts = 0
	else
		// Make sure that the encounter_type is valid
		if isnull(ls_encounter_type) then
			ls_encounter_type = get_attribute("default_encounter_type")
		end if
		
		if (not datalist.encounter_type_is_valid(ls_encounter_type)) or isnull(ls_encounter_type) then
			ls_encounter_type = "SICK"
		end if
		current_patient  = CREATE u_patient
		li_sts = current_patient.load(ls_cpr_id) 
		if li_sts >= 0 then
			ll_new_encounter_id = current_patient.new_encounter( ls_office, &
															ls_encounter_type, &
															ldt_appointment_datetime, &
															ls_new_flag, &
															ls_chief_complaint, &
															ls_attending_doctor, &
															system_user_id, &
															true)															
		end if
	end if
	if ll_new_encounter_id > 0 then
		ls_status = "OK"
		ll_encounter_id = ll_new_encounter_id
	elseif li_sts = 0 then
		setnull(ll_encounter_id)
		ls_status = "NA"
	else
		setnull(ll_encounter_id)
		ls_status = "ERROR"
	end if

	xx_set_checked_in(ll_checked_in_id, ls_cpr_id, ll_encounter_id, ls_status)
	
	// return 2 so timer_ding() will be called again immediately
	return 2
end if
	
return 1

end function

on u_component_schedule.create
call super::create
end on

on u_component_schedule.destroy
call super::destroy
end on

