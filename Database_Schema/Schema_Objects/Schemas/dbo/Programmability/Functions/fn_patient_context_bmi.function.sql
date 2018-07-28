CREATE FUNCTION fn_patient_context_bmi (
	@ps_cpr_id varchar(12),
	@ps_context_object varchar(24),
	@pl_object_key int
	)
RETURNS @patient_bmi TABLE (
	bmi_date datetime NOT NULL,
	weight_kg decimal(9,3) NULL,
	height_cm decimal(9,3) NULL,
	bmi decimal(9,3) NULL,
	percentile decimal(6,3) NULL
	)
AS

BEGIN

DECLARE @ld_bmi decimal(9,3),
		@ls_weight varchar(40),
		@ls_weight_unit varchar(24),
		@ld_weight decimal(9,3),
		@ld_weight_kg decimal(9,3),
		@ls_height varchar(40),
		@ls_height_unit varchar(24),
		@ld_height decimal(9,3),
		@ld_height_cm decimal(9,3),
		@ls_growth_class varchar(24),
		@ldt_date_of_birth datetime,
		@ls_sex char(1)

DECLARE @wgt_data TABLE (
	location_result_sequence int NOT NULL,
	result_day datetime NOT NULL,
	weight_result varchar(40),
	weight_unit varchar(24))


DECLARE @hgt_data TABLE (
	location_result_sequence int NOT NULL,
	result_day datetime NOT NULL,
	height_result varchar(40),
	height_unit varchar(24))

IF @ps_context_object IS NULL
	BEGIN
	SET @ps_context_object = 'Patient'
	SET @pl_object_key = NULL
	END

INSERT INTO @wgt_data (
	location_result_sequence,
	result_day,
	weight_result,
	weight_unit)
SELECT location_result_sequence,
	dbo.fn_date_truncate(result_date_time, 'DAY'),
	result_value, 
	result_unit
FROM dbo.fn_patient_results(@ps_cpr_id, 'WGT', -1)
WHERE @ps_context_object = 'Patient'
OR (@ps_context_object = 'Encounter' AND encounter_id = @pl_object_key)
OR (@ps_context_object = 'Treatment' AND treatment_id = @pl_object_key)


INSERT INTO @hgt_data (
	location_result_sequence,
	result_day,
	height_result,
	height_unit)
SELECT location_result_sequence,
	dbo.fn_date_truncate(result_date_time, 'DAY'),
	result_value, 
	result_unit
FROM dbo.fn_patient_results(@ps_cpr_id, 'HGT', -1)
WHERE @ps_context_object = 'Patient'
OR (@ps_context_object = 'Encounter' AND encounter_id = @pl_object_key)
OR (@ps_context_object = 'Treatment' AND treatment_id = @pl_object_key)

-- Remove duplicate weights for same day
DELETE t
FROM @wgt_data t
	INNER JOIN (SELECT result_day, max(location_result_sequence) as max_location_result_sequence
				FROM @wgt_data
				GROUP BY result_day) x
	ON t.result_day = x.result_day
WHERE t.location_result_sequence < x.max_location_result_sequence


-- Remove duplicate heights for same day
DELETE t
FROM @hgt_data t
	INNER JOIN (SELECT result_day, max(location_result_sequence) as max_location_result_sequence
				FROM @hgt_data
				GROUP BY result_day) x
	ON t.result_day = x.result_day
WHERE t.location_result_sequence < x.max_location_result_sequence


-- Remove invalid weights
DELETE t
FROM @wgt_data t
WHERE weight_unit NOT IN ('LB', 'KG')
OR ISNUMERIC(weight_result) <> 1

-- Remove invalid heights
DELETE t
FROM @hgt_data t
WHERE height_unit NOT IN ('CM', 'INCH', 'FEET')
OR ISNUMERIC(height_result) <> 1

INSERT INTO @patient_bmi (
	bmi_date ,
	weight_kg ,
	height_cm )
SELECT t1.result_day,
	CASE t1.weight_unit WHEN 'KG' THEN CAST(t1.weight_result AS decimal(9,3))
						WHEN 'LB' THEN CAST(t1.weight_result AS decimal(9,3)) / 2.205
						ELSE NULL END,
	CASE t2.height_unit WHEN 'CM' THEN CAST(t2.height_result AS decimal(9,3))
						WHEN 'INCH' THEN CAST(t2.height_result AS decimal(9,3)) / 0.3937
						WHEN 'FEET' THEN CAST(t2.height_result AS decimal(9,3)) / 0.0328
						ELSE NULL END
FROM @wgt_data t1
	INNER JOIN @hgt_data t2
	ON t1.result_day = t2.result_day

SET @ls_growth_class = 'BMIAgeChild'

SELECT @ldt_date_of_birth = date_of_birth,
		@ls_sex = sex
FROM p_Patient
WHERE cpr_id = @ps_cpr_id

UPDATE @patient_bmi
SET bmi = 10000 * (weight_kg / height_cm / height_cm),
	percentile = dbo.fn_cdc_growth_bmi (@ls_growth_class,
										@ldt_date_of_birth,
										bmi_date,
										@ls_sex,
										weight_kg,
										'KG',
										height_cm,
										'CM'
										) * 100

WHERE height_cm > 0

RETURN

END

