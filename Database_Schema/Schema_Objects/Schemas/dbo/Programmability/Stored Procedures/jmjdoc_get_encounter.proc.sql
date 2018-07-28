CREATE PROCEDURE jmjdoc_get_encounter (
	@ps_cpr_id varchar(24),
	@pl_encounter_id int = NULL
)

AS

IF @pl_encounter_id is NULL OR @pl_encounter_id = 0
BEGIN
SELECT e.cpr_id as cprid,   
         e.encounter_id as encounterid,   
         e.encounter_date as encounterdate,
         COALESCE(e.encounter_description, t.description) as description,
         e.encounter_type as encountertype, 
         e.attending_doctor as attendingdoctor_actorid,
         attenuser.user_full_name as attendingdoctor_actorname,
	 attenuser.first_name as attendingdoctor_actorfirstname,
	 attenuser.last_name as attendingdoctor_actorlastname,
         e.referring_doctor as referringdoctor_actorid,
         refuser.user_full_name as referringdoctor_actorname,
	 refuser.first_name as referringdoctor_actorfirstname,
	 refuser.last_name as referringdoctor_actorlastname,
         e.supervising_doctor as supervisingdoctor_actorid,
         superuser.user_full_name as supervisingdoctor_actorname,
	 superuser.first_name as supervisingdoctor_actorfirstname,
	 superuser.last_name as supervisingdoctor_actorlastname,
	 e.new_flag as newpatientflag,
         e.office_id as encounterlocation,
	o.description as enlocationname, 
	o.address1 as enlocationaddr1,
	o.address2 as enlocationaddr2,
	o.city as enlocationcity,
	o.state as enlocationstate,
	o.zip as enlocationzip,
	o.phone as enlocationphone,
	 e.workers_comp_flag as workerscompflag,
	 e.indirect_flag as encountermode,
	 e.appointment_time as appointmenttime,
	 e.est_appointment_length as estappointmentlength,
	 e.encounter_status as encounterstatus,
	 e.discharge_date as dischargedate,
	 e.admit_reason as admitreason
FROM	p_Patient_Encounter e
	LEFT OUTER JOIN c_Encounter_Type t
	ON e.encounter_type = t.encounter_type
	LEFT OUTER JOIN c_User attenuser
	ON e.attending_doctor = attenuser.user_id
	LEFT OUTER JOIN c_User superuser
	ON e.attending_doctor = superuser.user_id
	LEFT OUTER JOIN c_User refuser
	ON e.attending_doctor = refuser.user_id
	LEFT OUTER JOIN c_Office o
	ON e.office_id = o.office_id
WHERE e.cpr_id = @ps_cpr_id
END

IF @pl_encounter_id > 0
BEGIN
SELECT e.cpr_id as cprid,   
         e.encounter_id as encounterid,   
         e.encounter_date as encounterdate,
         COALESCE(e.encounter_description, t.description) as description,
         e.encounter_type as encountertype, 
         e.attending_doctor as attendingdoctor_actorid,
         attenuser.user_full_name as attendingdoctor_actorname,
	 attenuser.first_name as attendingdoctor_actorfirstname,
	 attenuser.last_name as attendingdoctor_actorlastname,
         e.referring_doctor as referringdoctor_actorid,
         refuser.user_full_name as referringdoctor_actorname,
	 refuser.first_name as referringdoctor_actorfirstname,
	 refuser.last_name as referringdoctor_actorlastname,
         e.supervising_doctor as supervisingdoctor_actorid,
         superuser.user_full_name as supervisingdoctor_actorname,
	 superuser.first_name as supervisingdoctor_actorfirstname,
	 superuser.last_name as supervisingdoctor_actorlastname,
	 e.new_flag as newpatientflag,
         e.office_id as encounterlocation,
	o.description as enlocationname, 
	o.address1 as enlocationaddr1,
	o.address2 as enlocationaddr2,
	o.city as enlocationcity,
	o.state as enlocationstate,
	o.zip as enlocationzip,
	o.phone as enlocationphone,
	 e.workers_comp_flag as workerscompflag,
	 e.indirect_flag as encountermode,
	 e.appointment_time as appointmenttime,
	 e.est_appointment_length as estappointmentlength,
	 e.encounter_status as encounterstatus,
	 e.discharge_date as dischargedate,
	 e.admit_reason as admitreason
FROM	p_Patient_Encounter e
	LEFT OUTER JOIN c_Encounter_Type t
	ON e.encounter_type = t.encounter_type
	LEFT OUTER JOIN c_User attenuser
	ON e.attending_doctor = attenuser.user_id
	LEFT OUTER JOIN c_User superuser
	ON e.supervising_doctor = superuser.user_id
	LEFT OUTER JOIN c_User refuser
	ON e.referring_doctor = refuser.user_id
	LEFT OUTER JOIN c_Office o
	ON e.office_id = o.office_id
WHERE e.cpr_id = @ps_cpr_id
AND e.encounter_id = @pl_encounter_id
END






