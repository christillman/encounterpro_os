CREATE FUNCTION dbo.fn_config_image_vaccine_schedule (
	)
RETURNS xml

AS
BEGIN

DECLARE @lx_xml xml

DECLARE @Age_Ranges TABLE (
	age_range_id int NOT NULL,
	age_range_category varchar(24) NOT NULL,
	description varchar(40) NULL,
	age_from int NULL,
	age_from_unit varchar(24) NULL,
	age_to int NULL,
	age_to_unit varchar(24) NULL
	)

INSERT INTO @Age_Ranges (
	age_range_id ,
	age_range_category ,
	description ,
	age_from ,
	age_from_unit ,
	age_to ,
	age_to_unit )
SELECT a.age_range_id ,
	a.age_range_category ,
	a.description ,
	a.age_from ,
	a.age_from_unit ,
	a.age_to ,
	a.age_to_unit
FROM c_Age_Range a
	INNER JOIN c_Disease_Group d
	ON a.age_range_id = d.age_range

INSERT INTO @Age_Ranges (
	age_range_id ,
	age_range_category ,
	description ,
	age_from ,
	age_from_unit ,
	age_to ,
	age_to_unit )
SELECT a.age_range_id ,
	a.age_range_category ,
	a.description ,
	a.age_from ,
	a.age_from_unit ,
	a.age_to ,
	a.age_to_unit
FROM c_Age_Range a
	INNER JOIN c_Immunization_Dose_Schedule d
	ON a.age_range_id = d.patient_age_range_id
WHERE NOT EXISTS (
	SELECT 1
	FROM @Age_Ranges x
	WHERE x.age_range_id = a.age_range_id)

INSERT INTO @Age_Ranges (
	age_range_id ,
	age_range_category ,
	description ,
	age_from ,
	age_from_unit ,
	age_to ,
	age_to_unit )
SELECT a.age_range_id ,
	a.age_range_category ,
	a.description ,
	a.age_from ,
	a.age_from_unit ,
	a.age_to ,
	a.age_to_unit
FROM c_Age_Range a
	INNER JOIN c_Immunization_Dose_Schedule d
	ON a.age_range_id = d.first_dose_age_range_id
WHERE NOT EXISTS (
	SELECT 1
	FROM @Age_Ranges x
	WHERE x.age_range_id = a.age_range_id)

INSERT INTO @Age_Ranges (
	age_range_id ,
	age_range_category ,
	description ,
	age_from ,
	age_from_unit ,
	age_to ,
	age_to_unit )
SELECT a.age_range_id ,
	a.age_range_category ,
	a.description ,
	a.age_from ,
	a.age_from_unit ,
	a.age_to ,
	a.age_to_unit
FROM c_Age_Range a
	INNER JOIN c_Immunization_Dose_Schedule d
	ON a.age_range_id = d.last_dose_age_range_id
WHERE NOT EXISTS (
	SELECT 1
	FROM @Age_Ranges x
	WHERE x.age_range_id = a.age_range_id)
	

SET @lx_xml = CONVERT(xml, '<VaccineSchedule>
' + (SELECT disease_group
		  ,description
		  ,sort_sequence
		  ,status
		  ,age_range
		  ,sex
		  ,id
		  ,last_updated
		  ,owner_id
	FROM c_Disease_Group
	FOR XML RAW ('DiseaseGroup'))
+ '
' + (SELECT disease_group
		  ,disease_id
		  ,sort_sequence
		  ,id
		  ,last_updated
		  ,owner_id
	FROM c_Disease_Group_Item
	FOR XML RAW ('DiseaseGroupItem'))
+ '
' + (SELECT disease_id
		  ,dose_schedule_sequence
		  ,dose_number
		  ,patient_age_range_id
		  ,first_dose_age_range_id
		  ,last_dose_age_range_id
		  ,last_dose_interval_amount
		  ,last_dose_interval_unit_id
		  ,sort_sequence
		  ,dose_text
	FROM c_Immunization_Dose_Schedule
	FOR XML RAW ('DoseSchedule'))
+ '
' + (SELECT age_range_id
			,age_range_category
			,description
			,age_from
			,age_from_unit
			,age_to
			,age_to_unit
	FROM @age_ranges
	FOR XML RAW ('AgeRange'))
+ '
</VaccineSchedule>')


RETURN @lx_xml

END


