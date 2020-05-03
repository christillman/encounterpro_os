-- Add COVID-19

IF NOT EXISTS (SELECT 1 FROM icd10cm_codes WHERE code = 'U071')
	INSERT INTO icd10cm_codes (code, descr)
	VALUES ('U071', 'COVID-19')


INSERT INTO c_Assessment_Definition (
	assessment_id,
	source,
	assessment_type,
	icd10_code,
	assessment_category_id,
	description,
	long_description,
	risk_level,
	owner_id,
	status )
SELECT
	'ICD-U071',
	'MainT', 
	'SICK',
	'U071',
	'AINFECT',
	'COVID-19',
	NULL,
	2, -- default risk level
	981, -- default owner
	'OK' -- default status
-- re-entrancy
WHERE NOT EXISTS (SELECT 1 FROM c_Assessment_Definition a WHERE a.icd10_code = 'ICD-U071')
