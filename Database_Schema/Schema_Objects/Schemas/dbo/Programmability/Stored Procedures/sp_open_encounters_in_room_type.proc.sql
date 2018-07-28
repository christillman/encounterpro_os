CREATE    PROCEDURE sp_open_encounters_in_room_type
	@ps_office_id varchar(4),
	@ps_room_type varchar(24) = NULL
AS

DECLARE @open_encounters TABLE (
	cpr_id varchar(12) NOT NULL ,
	encounter_id int NOT NULL ,
	encounter_type varchar(24) NULL,
	encounter_date datetime NULL,
	encounter_description varchar(80) NULL,
	patient_workplan_id int NULL,
	patient_location varchar(12) NOT NULL,
	attending_doctor varchar(24) NULL,
	dispatch_date datetime NULL,
	alert_count int  NULL,
	room_name varchar(24) NULL,
	room_sequence smallint NULL,
	color INT NULL,
	date_of_birth datetime NULL,
	sex VARCHAR (1),
	patient_name VARCHAR (80) NOT NULL,
	patient_age varchar(12) NULL
)

SET @ps_room_type = COALESCE(@ps_room_type, '%')
SET @ps_office_id = COALESCE(@ps_office_id, '%')

INSERT INTO @open_encounters 
(
	cpr_id ,
	encounter_id ,
	encounter_type ,
	encounter_date ,
	encounter_description ,
	patient_workplan_id ,
	patient_location ,
	attending_doctor,
	dispatch_date,
	alert_count,
	room_name,
	room_sequence,
	color,
	date_of_birth,
	sex,
	patient_name,
	patient_age
)
SELECT 	e.cpr_id ,
	e.encounter_id ,
	e.encounter_type ,
	e.encounter_date ,
	e.encounter_description ,
	e.patient_workplan_id ,
	e.patient_location ,
	e.attending_doctor,
	NULL,
	NULL,
	r.room_name,
	r.room_sequence,
	u.color,
	p.date_of_birth,
	p.sex,
	ISNULL(p.last_name, '') + ', ' + ISNULL(p.first_name, '') + ' ' + ISNULL(p.middle_name, '') AS patient_name,
	dbo.fn_pretty_age(p.date_of_birth, getdate())
FROM p_Patient_Encounter e WITH (NOLOCK)
INNER JOIN o_Rooms r WITH (NOLOCK)
ON e.patient_location = r.room_id
INNER JOIN p_Patient p WITH (NOLOCK)
ON e.cpr_id = p.cpr_id
LEFT OUTER JOIN c_User u WITH (NOLOCK)
ON e.attending_doctor = u.user_id
WHERE e.encounter_status = 'OPEN'
AND e.office_id LIKE @ps_office_id
AND r.room_type LIKE @ps_room_type


UPDATE e
SET dispatch_date = (	SELECT min(wi.dispatch_date)
			FROM p_Patient_WP_Item wi WITH (NOLOCK)
			WHERE 
				wi.cpr_id = e.cpr_id
			AND	wi.encounter_id = e.encounter_id
			AND	wi.active_service_flag = 'Y'
		    )
FROM @open_encounters e
INNER JOIN p_Patient_WP_Item ca WITH (NOLOCK)
ON 	    e.cpr_id =ca.cpr_id
AND		ca.encounter_id = e.encounter_id
WHERE
	ca.active_service_flag = 'Y'


UPDATE e
SET alert_count = (	SELECT
				 count(a.cpr_id)
			FROM p_Chart_Alert a WITH (NOLOCK)
			WHERE
				a.alert_status IS NULL
			AND	e.cpr_id = a.cpr_id
		  )
FROM @open_encounters e
INNER JOIN p_chart_alert ca WITH (NOLOCK)
ON e.cpr_id =ca.cpr_id
WHERE
	ca.alert_status IS NULL

SELECT
	e.cpr_id ,
	e.encounter_id ,
	e.encounter_type ,
	e.encounter_date ,
	e.encounter_description ,
	e.patient_workplan_id ,
	e.patient_location ,
	e.attending_doctor ,
	e.patient_name,
	e.date_of_birth,
	e.sex,
	DATEDIFF(minute, e.dispatch_date, getdate()) as minutes,
	e.room_name,
	e.room_sequence,
	e.color,
	e.alert_count,
	e.patient_age
FROM @open_encounters e

