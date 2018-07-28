CREATE PROCEDURE jmj_patient_immunization_status (
	@ps_cpr_id varchar(12),
	@pdt_current_date datetime = NULL)

AS

IF @pdt_current_date IS NULL
	SET @pdt_current_date = getdate()


DECLARE @schedule TABLE (
	disease_group varchar(24) NOT NULL,
	disease_id int NOT NULL,
	description varchar(80) NOT NULL,
	disease_group_sort_sequence int NOT NULL,
	disease_sort_sequence int NOT NULL,
	dose_number int NULL,
	dose_date datetime NULL,
	dose_status varchar(24) NOT NULL,
	dose_text varchar(255) NULL)

DECLARE @groups TABLE (
	disease_group varchar(24) NOT NULL,
	disease_id int NOT NULL,
	next_dose_number int NULL,
	last_dose_number int NULL)


INSERT INTO @schedule (
	disease_group ,
	disease_id ,
	description ,
	disease_group_sort_sequence ,
	disease_sort_sequence ,
	dose_number ,
	dose_date ,
	dose_status ,
	dose_text )
SELECT disease_group ,
	disease_id ,
	description ,
	disease_group_sort_sequence ,
	disease_sort_sequence ,
	dose_number ,
	dose_date ,
	dose_status ,
	dose_text
FROM dbo.fn_patient_immunization_schedule(@ps_cpr_id, @pdt_current_date)

INSERT INTO @groups (
	disease_group ,
	disease_id ,
	next_dose_number,
	last_dose_number )
SELECT DISTINCT disease_group ,
	disease_id ,
	1,
	0
FROM @schedule

UPDATE g
SET next_dose_number = x.dose_number
FROM @groups g
	INNER JOIN (SELECT disease_group ,
					disease_id ,
					min(dose_number) as dose_number
				FROM @schedule
				WHERE dose_status IN ('Give Now', 'Projected', 'Ineligible')
				GROUP BY disease_group, disease_id) x
	ON g.disease_group = x.disease_group
	AND g.disease_id = x.disease_id

UPDATE g
SET last_dose_number = x.dose_number
FROM @groups g
	INNER JOIN (SELECT disease_group ,
					disease_id ,
					max(dose_number) as dose_number
				FROM @schedule
				WHERE dose_status = 'Given'
				GROUP BY disease_group, disease_id) x
	ON g.disease_group = x.disease_group
	AND g.disease_id = x.disease_id

SELECT s.disease_group ,
	s.disease_id ,
	s.description ,
	s.disease_group_sort_sequence ,
	s.disease_sort_sequence ,
	s.dose_number ,
	s.dose_date ,
	s.dose_status ,
	s.dose_text
FROM @groups g
	INNER JOIN @schedule s
	ON g.disease_group = s.disease_group
	AND g.disease_id = s.disease_id
	AND g.next_dose_number = s.dose_number
WHERE s.dose_status IN ('Give Now', 'Projected', 'Ineligible')
AND g.next_dose_number > g.last_dose_number
UNION
SELECT s.disease_group ,
	s.disease_id ,
	s.description ,
	s.disease_group_sort_sequence ,
	s.disease_sort_sequence ,
	s.dose_number + 1,
	CAST(NULL as datetime),
	'Completed' ,
	CAST(NULL as varchar(255))
FROM @groups g
	INNER JOIN @schedule s
	ON g.disease_group = s.disease_group
	AND g.disease_id = s.disease_id
	AND g.last_dose_number = s.dose_number
WHERE s.dose_status NOT IN ('Give Now', 'Projected', 'Ineligible')
AND g.next_dose_number <= g.last_dose_number
UNION
SELECT s.disease_group ,
	s.disease_id ,
	s.description ,
	s.disease_group_sort_sequence ,
	s.disease_sort_sequence ,
	s.dose_number ,
	s.dose_date ,
	s.dose_status ,
	s.dose_text
FROM @schedule s
WHERE s.dose_status = 'Ineligible'
UNION
SELECT d.disease_group ,
	0 ,
	d.disease_group ,
	d.sort_sequence ,
	0 ,
	CAST(NULL as int),
	CAST(NULL as datetime),
	'Ineligible' ,
	CAST(NULL as varchar(255))
FROM c_Disease_Group d
WHERE NOT EXISTS (
	SELECT 1
	FROM @schedule s
	WHERE d.disease_group = s.disease_group)


