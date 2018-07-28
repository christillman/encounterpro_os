﻿CREATE FUNCTION fn_patient_care_team_list (
	@ps_cpr_id varchar(24) )

RETURNS @care_team TABLE (
	user_id varchar(24) NOT NULL,
	user_short_name varchar(12) NULL,
	user_full_name varchar(64) NULL,
	color int NULL,
	icon varchar(128) NULL,
	user_status varchar(24) NULL,
	type varchar(32) NULL,
	user_key varchar(24) NULL,
	email_address varchar(128) NULL,
	specialty_id varchar(24) NULL,
	specialty_description varchar(80) NULL,
	preferred_provider int NOT NULL DEFAULT (0),
	pretty_address varchar(80) NULL ,
	actor_class varchar(24) NULL ,
	primary_actor bit NOT NULL DEFAULT (0))

AS
BEGIN
DECLARE @ls_authority_id varchar(24)

DECLARE @encounters TABLE (
	cpr_id varchar(12) NOT NULL,
	encounter_id int NOT NULL,
	attending_doctor varchar(24) NOT NULL)

DECLARE @staff TABLE (
	user_id varchar(24) NOT NULL)

DECLARE @progress TABLE (
	user_id varchar(24) NOT NULL,
	specialty_id varchar(24) NOT NULL,
	in_care_team bit NOT NULL,
	primary_actor bit NOT NULL
	)

-- Insert the primary provider
INSERT INTO @care_team (
	user_id ,
	user_short_name ,
	user_full_name ,
	color ,
	icon ,
	user_status ,
	type ,
	user_key ,
	email_address ,
	actor_class)
SELECT u.user_id,
		u.user_short_name ,
		u.user_full_name ,
		u.color ,
		'button_provider.bmp' ,
		u.status ,
		'Primary Provider' ,
		NULL ,
		u.email_address  ,
		u.actor_class
FROM p_Patient p
	INNER JOIN c_User u
	ON p.primary_provider_id = u.user_id
WHERE p.cpr_id = @ps_cpr_id
AND NOT EXISTS (
	SELECT 1
	FROM @care_team x
	WHERE x.user_id = u.user_id)

-- Insert the secondary provider
INSERT INTO @care_team (
	user_id ,
	user_short_name ,
	user_full_name ,
	color ,
	icon ,
	user_status ,
	type ,
	user_key ,
	email_address ,
	actor_class )
SELECT u.user_id,
		u.user_short_name ,
		u.user_full_name ,
		u.color ,
		'button_provider.bmp' ,
		u.status  ,
		'Secondary Provider' ,
		NULL ,
		u.email_address ,
		u.actor_class
FROM p_Patient p
	INNER JOIN c_User u
	ON p.secondary_provider_id = u.user_id
WHERE p.cpr_id = @ps_cpr_id
AND NOT EXISTS (
	SELECT 1
	FROM @care_team x
	WHERE x.user_id = u.user_id)


INSERT INTO @encounters (
	cpr_id ,
	encounter_id ,
	attending_doctor )
SELECT e.cpr_id ,
	e.encounter_id ,
	e.attending_doctor
FROM p_Patient_Encounter e
WHERE e.cpr_id = @ps_cpr_id
AND e.encounter_status = 'OPEN'
AND e.attending_doctor IS NOT NULL

--Insert anyone who has worked on these encounters
INSERT INTO @staff (
	user_id)
SELECT DISTINCT owned_by as user_id
FROM p_Patient_WP_Item i
	INNER JOIN @encounters e
	ON i.cpr_id = e.cpr_id
	AND i.encounter_id = e.encounter_id
WHERE i.owned_by <> e.attending_doctor

-- Insert the owners of the open encounters
INSERT INTO @care_team (
	user_id ,
	user_short_name ,
	user_full_name ,
	color ,
	icon ,
	user_status ,
	type ,
	user_key ,
	email_address ,
	actor_class)
SELECT DISTINCT u.user_id,
		u.user_short_name ,
		u.user_full_name ,
		u.color ,
		'button_provider.bmp' ,
		u.status  ,
		'Encounter Owner' ,
		NULL ,
		u.email_address ,
		u.actor_class
FROM @encounters e
	INNER JOIN c_User u
	ON e.attending_doctor = u.user_id
AND NOT EXISTS (
	SELECT 1
	FROM @care_team x
	WHERE x.user_id = u.user_id)

-- Insert the staff for the open-encounter owners
INSERT INTO @care_team (
	user_id ,
	user_short_name ,
	user_full_name ,
	color ,
	icon ,
	user_status ,
	type ,
	user_key ,
	email_address ,
	actor_class )
SELECT DISTINCT u.user_id,
		u.user_short_name ,
		u.user_full_name ,
		u.color ,
		'button_provider.bmp' ,
		u.status  ,
		'Provider' ,
		NULL ,
		u.email_address ,
		u.actor_class
FROM c_User u
	INNER JOIN @staff s
	ON u.user_id = s.user_id
WHERE NOT EXISTS (
	SELECT 1
	FROM @care_team x
	WHERE x.user_id = u.user_id)

-- Insert the rest of the care team
INSERT INTO @care_team (
	user_id ,
	user_short_name ,
	user_full_name ,
	color ,
	icon ,
	user_status ,
	type ,
	user_key ,
	email_address ,
	actor_class )
SELECT DISTINCT u.user_id,
		u.user_short_name ,
		u.user_full_name ,
		u.color ,
		'button_provider.bmp' ,
		u.status  ,
		CASE u.actor_class WHEN 'User' THEN 'Provider' ELSE u.actor_class END ,
		NULL ,
		u.email_address  ,
		u.actor_class
FROM c_User u
	INNER JOIN p_Patient_Progress p
	ON u.user_id = p.progress_key
WHERE p.cpr_id = @ps_cpr_id
AND p.progress_type = 'Care Team'
AND p.current_flag = 'Y'
AND LEFT(p.progress_value, 1) IN ('T', 'Y', 'P')
AND NOT EXISTS (
	SELECT 1
	FROM @care_team x
	WHERE x.user_id = u.user_id)


-- Insert the patient
INSERT INTO @care_team (
	user_id ,
	user_short_name ,
	user_full_name ,
	color ,
	icon ,
	user_status ,
	type ,
	user_key ,
	email_address ,
	actor_class )
SELECT u.user_id,
		CAST(p.first_name AS varchar(12)) ,
		dbo.fn_patient_full_name(p.cpr_id) ,
		u.color ,
		'button_patient.bmp' ,
		p.patient_status ,
		'Patient' ,
		p.cpr_id ,
		p.email_address ,
		u.actor_class
FROM p_Patient p
	CROSS JOIN c_User u
WHERE cpr_id = @ps_cpr_id
AND u.user_id = '#Patient'
AND NOT EXISTS (
	SELECT 1
	FROM @care_team x
	WHERE x.user_id = u.user_id)

-- Insert the relatives
INSERT INTO @care_team (
	user_id ,
	user_short_name ,
	user_full_name ,
	color ,
	icon ,
	user_status ,
	type ,
	user_key ,
	email_address ,
	actor_class )
SELECT u.user_id,
		CAST(p.first_name AS varchar(12)) ,
		dbo.fn_patient_full_name(p.cpr_id) ,
		u.color ,
		'button_relation.bmp' ,
		u.status  ,
		r.relationship ,
		p.cpr_id ,
		p.email_address ,
		u.actor_class
FROM p_Patient_Relation r
	INNER JOIN p_Patient p
	ON r.relation_cpr_id = p.cpr_id
	CROSS JOIN c_User u
WHERE r.cpr_id = @ps_cpr_id
AND u.user_id = '#Relation'
AND NOT EXISTS (
	SELECT 1
	FROM @care_team x
	WHERE x.user_id = u.user_id)

UPDATE x
SET specialty_id = CASE u.user_status WHEN 'Actor' THEN u.specialty_id 
									ELSE NULL END
FROM @care_team x
	INNER JOIN c_user u
	ON x.user_id = u.user_id

UPDATE x
SET specialty_description = s.description
FROM @care_team x
	INNER JOIN c_Specialty s
	ON x.specialty_id = s.specialty_id	

SELECT @ls_authority_id = authority_id
FROM p_Patient_Authority
WHERE cpr_id = @ps_cpr_id
AND authority_type = 'PAYOR'
AND authority_sequence = 1
AND status = 'OK'

UPDATE x
SET preferred_provider = 1
FROM @care_team x
	INNER JOIN c_Preferred_provider pp
	ON x.user_id = pp.consultant_id
WHERE pp.authority_id = @ls_authority_id

-- First get the primary address
UPDATE x
SET pretty_address = dbo.fn_pretty_address(a.address_line_1, a.address_line_2, a.city, a.state, a.zip, a.country)
FROM @care_team x
	INNER JOIN c_User u
	ON u.user_id = x.user_id
	INNER JOIN c_Actor_Address a
	ON a.actor_id = u.actor_id
WHERE a.description = 'Address'
AND a.status = 'OK'
AND x.pretty_address IS NULL

-- The get any address
UPDATE x
SET pretty_address = dbo.fn_pretty_address(a.address_line_1, a.address_line_2, a.city, a.state, a.zip, a.country)
FROM @care_team x
	INNER JOIN c_User u
	ON u.user_id = x.user_id
	INNER JOIN c_Actor_Address a
	ON a.actor_id = u.actor_id
WHERE a.status = 'OK'
AND x.pretty_address IS NULL

INSERT INTO @progress (
	user_id ,
	specialty_id ,
	in_care_team ,
	primary_actor)
SELECT x.user_id,
		COALESCE(u.specialty_id, '!NULL'),
		CASE WHEN LEFT(p.progress_value, 1) IN ('T', 'Y', 'P') THEN 1 ELSE 0 END,
		CASE WHEN LEFT(p.progress_value, 1) = 'P' THEN 1 ELSE 0 END
FROM @care_team x
	INNER JOIN p_Patient_Progress p
	ON x.user_id = p.progress_key
	INNER JOIN c_User u
	ON x.user_id = u.user_id
WHERE p.cpr_id = @ps_cpr_id
AND p.progress_type = 'Care Team'
AND p.current_flag = 'Y'

UPDATE u
SET primary_actor = 1
FROM @care_team u
	INNER JOIN @progress p
	ON u.user_id = p.user_id
WHERE p.primary_actor = 1

DELETE u
FROM @care_team u
	INNER JOIN @progress p
	ON u.user_id = p.user_id
WHERE p.in_care_team = 0

DELETE u
FROM @care_team u
WHERE u.actor_class IN ('Special', 'System')

RETURN
END
