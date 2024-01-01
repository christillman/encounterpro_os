
-- Update category names

  UPDATE [c_Assessment_Category] 
  SET description = 'Pregnancy/Childbirth/Puerperium'
  WHERE assessment_category_id = 'OB'
  UPDATE [c_Assessment_Category] 
  SET description = 'Neonatal/Newborn'
  WHERE assessment_category_id = 'OBP'

-- Add RPERI assessments wherever we have OBP and no matching RPERI

  INSERT INTO c_Assessment_Definition
  (	[assessment_id]
      ,[assessment_type]
      ,[assessment_category_id]
      ,[description]
      ,[long_description]
      ,[icd_9_code]
      ,[risk_level]
      ,[status]
      ,[auto_close]
      ,[auto_close_interval_amount]
      ,[auto_close_interval_unit]
      ,[owner_id]
      ,[last_updated]
      ,[original_icd_9_code]
      ,[acuteness]
      ,[icd10_code]
      ,[source]
      ,[icd10_who_code]
	  )
  SELECT [assessment_id] + '_RP'
      ,'SICK'
      ,'RPERI'
      ,[description]
      ,[long_description]
      ,[icd_9_code]
      ,[risk_level]
      ,[status]
      ,[auto_close]
      ,[auto_close_interval_amount]
      ,[auto_close_interval_unit]
      ,[owner_id]
      ,[last_updated]
      ,[original_icd_9_code]
      ,[acuteness]
      ,[icd10_code]
      ,[source]
      ,[icd10_who_code] 
 FROM c_Assessment_Definition d
  WHERE d.assessment_category_id = 'OBP'
  AND NOT EXISTS (SELECT 1 
	FROM c_Assessment_Definition d2
	WHERE d2.assessment_category_id = 'RPERI'
	AND COALESCE(d2.icd10_code,d2.icd10_who_code) = COALESCE(d.icd10_code,d.icd10_who_code)
	AND d2.description = d.description)
	AND [assessment_id] NOT LIKE '%_OBP'
AND NOT EXISTS (SELECT 1 
	FROM c_Assessment_Definition d3
	WHERE d3.assessment_id = d.[assessment_id] + '_RP' )

-- Add OBP assessments wherever we have RPERI and no matching OBP

  INSERT INTO c_Assessment_Definition
  (	[assessment_id]
      ,[assessment_type]
      ,[assessment_category_id]
      ,[description]
      ,[long_description]
      ,[icd_9_code]
      ,[risk_level]
      ,[status]
      ,[auto_close]
      ,[auto_close_interval_amount]
      ,[auto_close_interval_unit]
      ,[owner_id]
      ,[last_updated]
      ,[original_icd_9_code]
      ,[acuteness]
      ,[icd10_code]
      ,[source]
      ,[icd10_who_code]
	  )
  SELECT d.[assessment_id] + '_OBP'
      ,'OB'
      ,'OBP'
      ,[description]
      ,[long_description]
      ,[icd_9_code]
      ,[risk_level]
      ,[status]
      ,[auto_close]
      ,[auto_close_interval_amount]
      ,[auto_close_interval_unit]
      ,[owner_id]
      ,[last_updated]
      ,[original_icd_9_code]
      ,[acuteness]
      ,[icd10_code]
      ,[source]
      ,[icd10_who_code] 
 FROM c_Assessment_Definition d
  WHERE d.assessment_category_id = 'RPERI'
  AND NOT EXISTS (SELECT 1 
	FROM c_Assessment_Definition d2
	WHERE d2.assessment_category_id = 'OBP'
	AND COALESCE(d2.icd10_code,d2.icd10_who_code) = COALESCE(d.icd10_code,d.icd10_who_code)
	AND d2.description = d.description)
	AND [assessment_id] NOT LIKE '%_RP'
AND NOT EXISTS (SELECT 1 
	FROM c_Assessment_Definition d3
	WHERE d3.assessment_id = d.[assessment_id] + '_OBP' )


-- Reset OB and OBP to OB assessment_type not SICK

  UPDATE c_Assessment_Definition
  SET assessment_type = 'OB'
  where assessment_category_id = 'OBP'
  and assessment_type = 'SICK'

-- Reset RPERI to SICK assessment_type not OB

  UPDATE c_Assessment_Definition
  SET assessment_type = 'SICK'
  where assessment_category_id = 'RPERI'
  and assessment_type = 'OB'
  
  