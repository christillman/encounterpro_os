CREATE FUNCTION fn_all_patients_bmi ()

RETURNS @patient_bmi TABLE (
	cpr_id varchar(12) NOT NULL,
	date_of_birth datetime NULL,
	sex char(1) NULL,
	result_day datetime NOT NULL,
	weight_kg decimal(18,6) NULL,
	height_cm decimal(18,6) NULL,
	bmi decimal(18,6) NULL,
	bmi_percentile decimal(18,6) NULL)
AS

BEGIN


DECLARE @wgt_results TABLE (
	cpr_id varchar(12) NOT NULL,
	result_value varchar(40) NULL,
	result_unit varchar(12) NULL,
	result_day datetime NOT NULL)

INSERT INTO @wgt_results (
	cpr_id,
	result_value ,
	result_unit,
	result_day )
SELECT 	cpr_id,
	result_value ,
	result_unit,
	result_day
FROM dbo.fn_all_patients_results_by_day('WGT', -1)

DECLARE @hgt_results TABLE (
	cpr_id varchar(12) NOT NULL,
	result_value varchar(40) NULL,
	result_unit varchar(12) NULL,
	result_day datetime NOT NULL)

INSERT INTO @hgt_results (
	cpr_id,
	result_value ,
	result_unit,
	result_day )
SELECT 	cpr_id,
	result_value ,
	result_unit,
	result_day
FROM dbo.fn_all_patients_results_by_day('HGT', -1)


-- Remove invalid weights
DELETE t
FROM @wgt_results t
WHERE result_unit NOT IN ('LB', 'KG')
OR ISNUMERIC(result_value) <> 1
OR result_value LIKE '%,%'

-- Remove invalid heights
DELETE t
FROM @hgt_results t
WHERE result_unit NOT IN ('CM', 'INCH', 'FEET')
OR ISNUMERIC(result_value) <> 1
OR result_value LIKE '%,%'

INSERT INTO @patient_bmi (
	cpr_id ,
	result_day ,
	weight_kg ,
	height_cm )
SELECT t1.cpr_id,
	t1.result_day,
	CASE t1.result_unit WHEN 'KG' THEN CAST(t1.result_value AS decimal(18,6))
						WHEN 'LB' THEN CAST(t1.result_value AS decimal(18,6)) / 2.205
						ELSE NULL END,
	CASE t2.result_unit WHEN 'CM' THEN CAST(t2.result_value AS decimal(18,6))
						WHEN 'INCH' THEN CAST(t2.result_value AS decimal(18,6)) / 0.3937
						WHEN 'FEET' THEN CAST(t2.result_value AS decimal(18,6)) / 0.0328
						ELSE NULL END
FROM @wgt_results t1
	INNER JOIN @hgt_results t2
	ON t1.cpr_id = t2.cpr_id
	AND t1.result_day = t2.result_day

-- Remove zero or negative height
DELETE x
FROM @patient_bmi x
WHERE weight_kg IS NULL
OR height_cm IS NULL
OR height_cm <= 0

-- Calculate BMI
UPDATE x
SET bmi = 10000 * (weight_kg / height_cm / height_cm),
	date_of_birth = p.date_of_birth,
	sex = p.sex
FROM @patient_bmi x
	INNER JOIN p_Patient p WITH (NOLOCK)
	ON x.cpr_id = p.cpr_id

-- Remove any records that still don't have a BMI that is not absurd
DELETE x
FROM @patient_bmi x
WHERE bmi IS NULL
OR bmi < 5
OR bmi > 100

-- Calculate the BMI percential
UPDATE x
SET bmi_percentile = dbo.fn_cdc_growth_bmi ('Standard',
											x.date_of_birth,
											x.result_day,
											x.sex,
											x.weight_kg,
											'KG',
											x.height_cm,
											'CM')
FROM @patient_bmi x

RETURN

END

