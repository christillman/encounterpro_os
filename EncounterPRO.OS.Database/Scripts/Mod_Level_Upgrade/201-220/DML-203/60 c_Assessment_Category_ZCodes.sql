
-- After the big mapping exercise, re-normalize the categories and types.
UPDATE c_Assessment_Category 
SET icd10_start = 'Z00', icd10_end = 'Z13'
WHERE assessment_category_id = 'YWELL'

UPDATE c_Assessment_Category 
SET icd10_start = 'Z14', icd10_end = 'Z22'
WHERE assessment_category_id = 'YMM'

UPDATE c_Assessment_Category 
SET icd10_start = 'Z23', icd10_end = 'Z28'
WHERE assessment_category_id = 'VACCINES'

UPDATE c_Assessment_Category 
SET icd10_start = 'Z29', icd10_end = 'Z3A'
WHERE assessment_category_id = 'YM'

UPDATE c_Assessment_Category 
SET icd10_start = 'Z40', icd10_end = 'Z53'
WHERE assessment_category_id = 'YMMM'

IF NOT EXISTS (SELECT 1 FROM [c_Assessment_Category] WHERE [assessment_category_id] = 'SOCIAL')
	INSERT INTO [c_Assessment_Category]
           ([assessment_type]
           ,[assessment_category_id]
           ,[description]
           ,[sort_order]
           ,[icd10_start]
           ,[icd10_end])
     VALUES ('PROBLEM', 'SOCIAL', 'Social Circumstances', 14, 'Z55', 'Z66')

UPDATE c_Assessment_Category 
SET icd10_start = 'Z67', icd10_end = 'Z68', description = 'Blood Type / BMI'
WHERE assessment_category_id = 'ZZMISC'

IF NOT EXISTS (SELECT 1 FROM [c_Assessment_Category] WHERE [assessment_category_id] = 'COUNSEL')
	INSERT INTO [c_Assessment_Category]
           ([assessment_type]
           ,[assessment_category_id]
           ,[description]
           ,[sort_order]
           ,[icd10_start]
           ,[icd10_end])
     VALUES ('PROBLEM', 'COUNSEL', 'Counseling', 14, 'Z69', 'Z71')

UPDATE c_Assessment_Category 
SET icd10_start = 'Z72', icd10_end = 'Z75'
WHERE assessment_category_id = 'PROBLEM'

UPDATE c_Assessment_Category 
SET icd10_start = 'Z76', icd10_end = 'Z76', assessment_type = 'PROBLEM'
WHERE assessment_category_id = 'YOTHER'

IF NOT EXISTS (SELECT 1 FROM [c_Assessment_Category] WHERE [assessment_category_id] = 'HAZ')
	INSERT INTO [c_Assessment_Category]
           ([assessment_type]
           ,[assessment_category_id]
           ,[description]
           ,[sort_order]
           ,[icd10_start]
           ,[icd10_end])
     VALUES ('PROBLEM', 'HAZ', 'Hazardous Exposure', 14, 'Z77', 'Z79')

UPDATE c_Assessment_Category 
SET icd10_start = 'Z80', icd10_end = 'Z84'
WHERE assessment_category_id = 'FAMILY'

IF NOT EXISTS (SELECT 1 FROM [c_Assessment_Category] WHERE [assessment_category_id] = 'DIS-HIST')
	INSERT INTO [c_Assessment_Category]
           ([assessment_type]
           ,[assessment_category_id]
           ,[description]
           ,[sort_order]
           ,[icd10_start]
           ,[icd10_end])
     VALUES ('PROBLEM', 'DIS-HIST', 'Personal Disease History', 14, 'Z85', 'Z87')

UPDATE c_Assessment_Category 
SET icd10_start = 'Z88', icd10_end = 'Z88'
WHERE assessment_category_id = 'DA'

IF NOT EXISTS (SELECT 1 FROM [c_Assessment_Category] WHERE [assessment_category_id] = 'ACQ')
INSERT INTO [c_Assessment_Category]
           ([assessment_type]
           ,[assessment_category_id]
           ,[description]
           ,[sort_order]
           ,[icd10_start]
           ,[icd10_end])
     VALUES ('PROBLEM', 'ACQ', 'Acquired Status', 14, 'Z89', 'Z90')

IF NOT EXISTS (SELECT 1 FROM [c_Assessment_Category] WHERE [assessment_category_id] = 'MED-HIST')
INSERT INTO [c_Assessment_Category]
           ([assessment_type]
           ,[assessment_category_id]
           ,[description]
           ,[sort_order]
           ,[icd10_start]
           ,[icd10_end])
     VALUES ('PROBLEM', 'MED-HIST', 'Medical History', 14, 'Z91', 'Z91')

UPDATE c_Assessment_Category 
SET icd10_start = 'Z92', icd10_end = 'Z92'
WHERE assessment_category_id = 'SURGERY'

UPDATE c_Assessment_Category 
SET icd10_start = 'Z93', icd10_end = 'Z99', 
	description = 'Personal History', 
	assessment_type = 'PROBLEM'
WHERE assessment_category_id = 'YHISTORY'

UPDATE c_Assessment_Category
SET assessment_category_id = 'TELEPHONE'
WHERE assessment_type = 'TELEPHONE'

-- These are only used in the old ICD 9 update scheme
DELETE FROM c_Assessment_Category
WHERE assessment_type IN ('WELL', 'SICK', 'VACCINE', 'PT', 'OB', 'ALLERGY')
AND assessment_category_id = 'AANEW'

-- Use PGASTRO
UPDATE c_Assessment_Category
SET icd10_end = 'K14'
WHERE  assessment_category_id = 'PGASTRA'
UPDATE c_Assessment_Category
SET icd10_start = 'K20', icd10_end = 'K95'
WHERE  assessment_category_id = 'PGASTRO'

UPDATE c_Assessment_Category
SET icd10_start = 'R00', icd10_end = 'R99', is_default = 'Y'
WHERE assessment_category_id = 'SIGNSYMP'

-- Set new is_default column, may be used later if we have duplicate icd10 ranges (e.g. RPERI)
UPDATE c_Assessment_Category 
SET is_default = CASE WHEN icd10_start IS NOT NULL THEN 'Y' ELSE 'N' END

-- Change to use SIGNSYMP for defaults
UPDATE c_Assessment_Category 
SET is_default = 'N'
WHERE assessment_category_id IN ('ZZZ')

-- Add overlapping icd ranges
UPDATE c_Assessment_Category
SET icd10_start = 'P00', icd10_end = 'P96', is_default = 'N'
WHERE assessment_category_id = 'RPERI'

UPDATE c_Assessment_Category
SET icd10_start = 'N40', icd10_end = 'N53', is_default = 'N'
WHERE assessment_category_id = 'PGUU'

UPDATE c_Assessment_Category
SET icd10_start = 'N60', icd10_end = 'N98', is_default = 'N'
WHERE assessment_category_id = 'PGYN'