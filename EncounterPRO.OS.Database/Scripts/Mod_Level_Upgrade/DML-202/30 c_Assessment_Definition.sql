
-- Prerequisite: bulk_inserts for icd10cm_codes_2018 and icd9_gem
-- 				update assessment_category icd_start and icd_end

-- apparently test data
DELETE FROM c_Assessment_Definition
WHERE assessment_id IN ('981^087.9^0')

-- Clean up internal linefeeds
UPDATE c_Assessment_Definition
SET description = REPLACE(description, char(13) + char(10), '')
where description like '%' + char(13) + char(10) +  '%'

UPDATE c_Assessment_Definition
SET long_description = REPLACE(long_description, char(13) + char(10), '')
where long_description like '%' + char(13) + char(10) +  '%'


SELECT cd.assessment_id, 
	(select max(c.code) 
		from icd10cm_codes_2018 c
		join icd9_gem g on g.icd10_code = c.code
		where replace(ISNULL(cd.original_icd_9_code, cd.icd_9_code),'.','') = g.icd9_code
	) AS icd10_code
INTO #Assessment_Map
FROM c_Assessment_Definition cd
WHERE cd.icd10_code IS NULL

DELETE FROM #Assessment_Map
WHERE icd10_code IS NULL

UPDATE d
SET icd10_code = m.icd10_code
FROM c_Assessment_Definition d
JOIN #Assessment_Map m ON m.assessment_id = d.assessment_id

UPDATE  c_Assessment_Definition 
SET icd10_code = 'Z01419'
WHERE assessment_id = 'DEMO1206' 

INSERT INTO c_Assessment_Definition 
(
	[assessment_id]    -- use "ICD-" + icd10_code
	,[icd10_code]
    ,[assessment_type]  -- SICK or ALLERGY
    ,[assessment_category_id]  --  assign according to first 3 ICD10 characters
    ,[description]    -- truncated ICD10 description
    ,[long_description]  -- ICD10 description
	,[risk_level]
	,[acuteness]  -- defaults to Acute
)
SELECT 'ICD-' + code, 
	code, 
	CASE WHEN code like 'O%' or code like 'P%' THEN 'OB'
		WHEN descr like '%allergy%' THEN 'ALLERGY' 
		WHEN descr like '%Family History%' THEN 'FAMILY'
		WHEN descr like '%History%' THEN 'PROBLEM'
		ELSE 'SICK' END,
	(SELECT max(assessment_category_id) 
		FROM c_Assessment_Category ac
		WHERE icd.code BETWEEN ac.icd10_start AND ac.icd10_end + 'ZZZ'),
	CASE WHEN len(descr) <= 80 THEN replace(descr,'"','') ELSE substring(replace(descr,'"',''),1,77) + '...' END,
	replace(descr,'"',''),
	2,
	''
FROM icd10cm_codes_2018 icd
WHERE NOT EXISTS (SELECT 1 FROM c_Assessment_Definition m WHERE m.icd10_code = icd.code)
ORDER BY code
-- 64241
GO

update c_Assessment_Definition set risk_level = 0 
where long_description like '%counseling%'
and (risk_level IS NULL OR risk_level = 2)
update c_Assessment_Definition set risk_level = 4 
where long_description like '%high risk%' 
and (risk_level IS NULL OR risk_level = 2)
update c_Assessment_Definition set risk_level = 4 
where long_description like '%hiv% disease complicating%'
and (risk_level IS NULL OR risk_level = 2)
update c_Assessment_Definition set risk_level = 3 
where icd10_code = 'Z6851'
and (risk_level IS NULL OR risk_level = 2)
update c_Assessment_Definition set risk_level = 1 
where icd10_code = 'Z6852'
and (risk_level IS NULL OR risk_level = 2)
update c_Assessment_Definition set risk_level = 3 
where icd10_code = 'Z6854'
and (risk_level IS NULL OR risk_level = 2)
update c_Assessment_Definition set risk_level = 1 
where icd10_code = 'P599'
and (risk_level IS NULL OR risk_level = 2)
update c_Assessment_Definition set risk_level = 3 
where icd10_code = 'R6813'
and (risk_level IS NULL OR risk_level = 2)

update c_Assessment_Definition set acuteness = 'Chronic' 
WHERE  acuteness = ''
AND (long_description like '%ossif%' 
	or long_description like '%calcif%' 
	or long_description like '%degenerat%' 
	or long_description like '%atroph%' 
	or long_description like '%dystroph%' 
	or long_description like '%disorder%' 
	or long_description like '%syndrome%' 
	or long_description like '%phobia%' 
	or long_description like '%congenital%' 
	or long_description like '%chronic%' )
-- 3088
	
update c_Assessment_Definition set acuteness = 'Chronic' 
where icd10_code = 'Z730'

update c_Assessment_Definition set acuteness = 'Acute'
where acuteness = ''
and (long_description like '%burn%' 
	or long_description like '%wound%' 
	or long_description like '%crisis%' 
	or long_description like '%contusion%' 
	or long_description like '%laceration%' 
	or long_description like '%fracture%' 
	or long_description like '%rupture%' 
	or long_description like '%poison%' 
	or long_description like '%fever%' 
	or long_description like '%hemorrhag%' 
	or long_description like '%injury%' 
	or long_description like '%shock%' 
	or long_description like '%acute%'
	)
-- 30503

UPDATE d
SET long_description = i.descr
FROM c_Assessment_Definition d
JOIN icd10cm_codes_2018 i on i.code = d.icd10_code
where long_description = description
and assessment_id not like 'ICD%'
and d.long_description != i.descr

UPDATE d
SET long_description = i.descr
FROM c_Assessment_Definition d
JOIN icd10cm_codes_2018 i on i.code = d.icd10_code
where long_description IS NULL
and assessment_id not like 'ICD%'

GO
/*
select 	[assessment_id]    -- use "ICD_" + icd10_code
	,[icd10_code]
    ,[assessment_type]  -- SICK or ALLERGY
    ,[assessment_category_id]  --  assign according to first 3 ICD10 characters
    ,[description]    -- truncated ICD10 description
    ,[long_description]  -- ICD10 description
	,risk_level
	,acuteness
 from c_Assessment_Definition
 order by assessment_id
 */
 
