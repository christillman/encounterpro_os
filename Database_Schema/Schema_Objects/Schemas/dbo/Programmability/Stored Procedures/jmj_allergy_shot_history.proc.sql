CREATE PROCEDURE jmj_allergy_shot_history (
	@ps_cpr_id varchar(12),
	@pl_treatment_id int
)

AS

DECLARE @shothistory TABLE (
	treatment_id int NOT NULL,
	treatment_begin_date datetime NOT NULL,
	dose_amount real,
	dose_unit varchar(24),
	description varchar(255) NULL,
	completed_by varchar(24) NULL,
	user_short_name varchar(20) NULL ,
	comments varchar(255) NULL,
	vial_description varchar(80) NULL,
	shot_description varchar(80) NULL,
	reaction varchar(255) NULL,
	location_description varchar(80) NULL,
	vial_type varchar(24) NULL,
	vial_type_description varchar(80) NULL,
	location varchar(24) NULL,
	encounter_id int NULL)

-- Get the injections
INSERT INTO @shothistory (
	treatment_id ,
	treatment_begin_date ,
	dose_amount ,
	dose_unit ,
	completed_by ,
	user_short_name ,
	vial_description ,
	shot_description ,
	reaction ,
	comments,
	location_description,
	vial_type,
	vial_type_description,
	location,
	encounter_id )
SELECT shot.treatment_id ,
	shot.begin_date ,
	shot.dose_amount ,
	shot.dose_unit ,
	shot.completed_by ,
	u.user_short_name ,
	vial.treatment_description ,
	shot.treatment_description ,
	reaction=dbo.fn_patient_object_property(@ps_cpr_id, 'Treatment', shot.treatment_id, 'Reaction'),
	comments=dbo.fn_patient_object_property(@ps_cpr_id, 'Treatment', shot.treatment_id, 'Comment'),
	l.description,
	vial.vial_type,
	vial_type_description=dbo.fn_vial_type_description(vial.vial_type),
	l.location,
	shot.open_encounter_id
FROM p_Treatment_Item root
	INNER JOIN p_Treatment_Item vial
	ON root.cpr_id = vial.cpr_id
	AND root.treatment_id = vial.parent_treatment_id
	AND vial.treatment_type = 'AllergyVialInstance'
	INNER JOIN p_Treatment_Item shot
	ON vial.cpr_id = shot.cpr_id
	AND vial.treatment_id = shot.parent_treatment_id
	AND shot.treatment_type = 'AllergyInjection'
	LEFT OUTER JOIN c_User u
	ON shot.completed_by = u.user_id
	LEFT OUTER JOIN c_Location l
	ON shot.location = l.location
WHERE root.cpr_id = @ps_cpr_id
AND root.treatment_id = @pl_treatment_id
AND shot.treatment_status = 'Closed'

SELECT 	treatment_id ,
	treatment_begin_date ,
	dose_amount ,
	dose_unit ,
	completed_by ,
	user_short_name ,
	vial_description ,
	shot_description ,
	CASE reaction WHEN 'No Reaction' THEN NULL ELSE reaction END ,
	comments ,
	description ,
	location_description,
	vial_type,
	vial_type_description,
	location,
	CAST(0 AS int) as shot_number,
	CAST(0 AS int) as selected_flag,
	encounter_id
FROM @shothistory


