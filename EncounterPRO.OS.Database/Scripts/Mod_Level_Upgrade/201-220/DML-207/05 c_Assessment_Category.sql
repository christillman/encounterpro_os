
-- Correct icd ranges, some assessments are missing their category (old 'Z') after the last update.

UPDATE [c_Assessment_Category] 
SET icd10_start = 'V00' 
WHERE icd10_start = 'V01'

UPDATE [c_Assessment_Category] 
SET icd10_start = 'W00' 
WHERE icd10_start = 'W01'

UPDATE [c_Assessment_Category] 
SET icd10_end = 'Y38' 
WHERE icd10_end = 'Y36'

UPDATE [c_Assessment_Category] 
SET icd10_end = 'Y99' 
WHERE icd10_end = 'Y98'

-- Add Rxx categorization from Ciru
DELETE FROM c_Assessment_Category 
WHERE assessment_category_id IN ('ZZZ','ABNFIND','ABNTUMARK','UNKMORTAL')

UPDATE [c_Assessment_Category] 
SET icd10_end = 'R69' 
WHERE assessment_category_id = 'SIGNSYMP'


INSERT INTO [c_Assessment_Category]
           ([assessment_type]
           ,[assessment_category_id]
           ,[description]
           ,[sort_order]
           ,[icd10_start]
           ,[icd10_end]
           ,[is_default])
     VALUES
           ('SICK'	
           ,'ABNFIND'
           ,'Abnormal findings'
           ,29
           ,'R70'
           ,'R94'
           ,'Y'
		   )

INSERT INTO [c_Assessment_Category]
           ([assessment_type]
           ,[assessment_category_id]
           ,[description]
           ,[sort_order]
           ,[icd10_start]
           ,[icd10_end]
           ,[is_default])
     VALUES
           ('SICK'
           ,'ABNTUMARK'
           ,'Abnormal tumor markers'
           ,30
           ,'R97'
           ,'R97'
           ,'Y'
		   )

INSERT INTO [c_Assessment_Category]
           ([assessment_type]
           ,[assessment_category_id]
           ,[description]
           ,[sort_order]
           ,[icd10_start]
           ,[icd10_end]
           ,[is_default])
     VALUES
           ('SICK'
           ,'UNKMORTAL'
           ,'Unknown cause of mortality'
           ,31
           ,'R98'
           ,'R99'
           ,'Y'
		   )

UPDATE d
SET d.assessment_category_id = c.assessment_category_id,
	d.assessment_type = c.assessment_type,
	last_updated = getdate()
FROM c_Assessment_Definition d 
JOIN c_Assessment_Category c on d.icd10_code BETWEEN c.icd10_start AND c.icd10_end + 'z'
WHERE d.assessment_category_id = 'Z'

-- (533 row(s) affected)