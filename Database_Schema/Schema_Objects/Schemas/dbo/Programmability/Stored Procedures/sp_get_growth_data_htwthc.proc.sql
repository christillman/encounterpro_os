CREATE Procedure sp_get_growth_data_htwthc (
	@ps_cpr_id varchar(12),
	@pdt_birth_date datetime,
	@pd_age_start int,
	@pd_age_end int,
	@ps_visit varchar(10))
AS 


DECLARE @growth_data TABLE (
	cpr_id varchar(12) NULL,
	encounter_id int NULL,
	encounter_status varchar(8) NULL,
	result_date_time datetime NOT NULL,
	observation_id varchar(24) NOT NULL,
	result_value varchar(40) NOT NULL,
	result_unit varchar(12) NOT NULL,
	actual_observation_id varchar(24) NOT NULL)
	
INSERT INTO @growth_data (
	cpr_id,
	encounter_id,
	result_date_time,
	observation_id ,
	result_value ,
	result_unit ,
	actual_observation_id )
SELECT 	@ps_cpr_id,
	encounter_id,
	result_date_time,
	'HGT' ,
	result_value ,
	result_unit ,
	observation_id
FROM dbo.fn_patient_results(@ps_cpr_id, 'HGT', -1)
WHERE location = 'NA'
AND result_value IS NOT NULL
AND result_unit IS NOT NULL
AND ISNUMERIC(result_value) = 1

INSERT INTO @growth_data (
	cpr_id,
	encounter_id,
	result_date_time,
	observation_id ,
	result_value ,
	result_unit ,
	actual_observation_id )
SELECT @ps_cpr_id,
	encounter_id,
	result_date_time,
	'WGT' ,
	result_value ,
	result_unit ,
	observation_id
FROM dbo.fn_patient_results(@ps_cpr_id, 'WGT', -1)
WHERE location = 'NA'
AND result_value IS NOT NULL
AND result_unit IS NOT NULL
AND ISNUMERIC(result_value) = 1

INSERT INTO @growth_data (
	cpr_id,
	encounter_id,
	result_date_time,
	observation_id ,
	result_value ,
	result_unit ,
	actual_observation_id )
SELECT 	@ps_cpr_id,
	encounter_id,
	result_date_time,
	'HC' ,
	result_value ,
	result_unit ,
	observation_id
FROM dbo.fn_patient_results(@ps_cpr_id, 'HC', -1)
WHERE location = 'NA'
AND result_value IS NOT NULL
AND result_unit IS NOT NULL
AND ISNUMERIC(result_value) = 1

UPDATE x
SET encounter_status = e.encounter_status
FROM @growth_data x
	INNER JOIN p_Patient_Encounter e
	ON x.cpr_id = e.cpr_id
	AND x.encounter_id = e.encounter_id

IF @pd_age_end is NULL
	BEGIN
		INSERT INTO @growth_data (
			encounter_id,
			result_date_time,
			observation_id ,
			result_value ,
			result_unit ,
			actual_observation_id )
		SELECT 	encounter_id,
			result_date_time,
			'BPSIT-SYS' ,
			result_value ,
			result_unit ,
			observation_id
		FROM dbo.fn_patient_results(@ps_cpr_id, 'BPSIT', -1)
		WHERE location = 'NA'
		AND result_value IS NOT NULL
		AND result_unit IS NOT NULL
		AND ISNUMERIC(result_value) = 1

		INSERT INTO @growth_data (
			encounter_id,
			result_date_time,
			observation_id ,
			result_value ,
			result_unit ,
			actual_observation_id )
		SELECT 	encounter_id,
			result_date_time,
			'BPSIT-DIA' ,
			result_value ,
			result_unit ,
			observation_id
		FROM dbo.fn_patient_results(@ps_cpr_id, 'BPSIT', -2)
		WHERE location = 'NA'
		AND result_value IS NOT NULL
		AND result_unit IS NOT NULL
		AND ISNUMERIC(result_value) = 1

		SELECT a.result_date_time,
			Datediff(day,@pdt_birth_date,a.result_date_time) as Age,
			a.observation_id ,
			a.result_value ,
			a.result_unit ,
			a.actual_observation_id
		FROM @growth_data a
		WHERE CAST(result_value as decimal) <> 0
		Order by result_date_time desc
	END
ELSE IF @ps_visit = 'ALL'
	SELECT result_date_time,
		Datediff(day,@pdt_birth_date,result_date_time) as Age,
		observation_id as observation_id,
		result_value as result_value,
		result_unit as result_unit,
		actual_observation_id
	FROM @growth_data
	WHERE DATEDIFF(day, @pdt_birth_date,result_date_time) >= @pd_age_start
	AND DATEDIFF(day, @pdt_birth_date,result_date_time) <= @pd_age_end
	AND CAST(result_value as decimal) <> 0
	Order by result_date_time asc
ELSE
	SELECT a.result_date_time,
		Datediff(day,@pdt_birth_date,a.result_date_time) as Age,
		a.observation_id ,
		a.result_value ,
		a.result_unit ,
		a.actual_observation_id
	FROM @growth_data a
	WHERE DATEDIFF(day, @pdt_birth_date,result_date_time) >= @pd_age_start
	AND DATEDIFF(day, @pdt_birth_date,result_date_time) <= @pd_age_end
	AND CAST(result_value as decimal) <> 0
	AND (EXISTS (
				SELECT  * 
				FROM p_assessment b
				WHERE b.cpr_id = @ps_cpr_id
				AND a.encounter_id = b.open_encounter_id
				AND b.assessment_type = 'WELL' 
				)
		OR a.encounter_status = 'OPEN')
	Order by result_date_time asc

