CREATE FUNCTION dbo.fn_treatment_bmi (
	@ps_cpr_id varchar(12),
	@pl_treatment_id int
	)
RETURNS @treatment_bmi TABLE (
	result_day datetime NOT NULL,
	weight_kg decimal(9,3) NULL,
	height_cm decimal(9,3) NULL,
	bmi decimal(9,3) NULL)
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
		@ld_height_cm decimal(9,3)


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
WHERE treatment_id = @pl_treatment_id

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
WHERE treatment_id = @pl_treatment_id

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

INSERT INTO @treatment_bmi (
	result_day ,
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

UPDATE @treatment_bmi
SET bmi = 10000 * (weight_kg / height_cm / height_cm)
WHERE height_cm > 0

RETURN

END

