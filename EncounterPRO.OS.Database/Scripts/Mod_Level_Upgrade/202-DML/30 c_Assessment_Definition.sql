
-- Prerequisite: bulk_inserts for icd10cm_codes_2018 and icd9_gem
-- 				update assessment_category icd_start and icd_end

SELECT cd.assessment_id, 
	(select max(c.code) 
		from icd10cm_codes_2018 c
		join icd9_gem g on g.icd10_code = c.code
		where replace(ISNULL(cd.original_icd_9_code, cd.icd_9_code),'.','') = g.icd9_code
	) AS icd10_code
INTO #Assessment_Map
FROM c_Assessment_Definition cd

UPDATE d
SET icd10_code = m.icd10_code
FROM c_Assessment_Definition d
JOIN #Assessment_Map m ON m.assessment_id = d.assessment_id
WHERE m.icd10_code IS NOT NULL

INSERT INTO c_Assessment_Definition 
(
	[assessment_id]    -- use "ICD_" + icd10_code
	,[icd10_code]
    ,[assessment_type]  -- SICK or ALLERGY
    ,[assessment_category_id]  --  assign according to first 3 ICD10 characters
    ,[description]    -- truncated ICD10 description
    ,[long_description]  -- ICD10 description
    ,[status]   -- OK
    ,[id]   -- generated unique identifier
    ,[owner_id]  -- same owner_id as the current assessments, 0
    ,[last_updated]  -- date of conversion
)
SELECT 'ICD_' + code, 
	code, 
	CASE WHEN descr like '%allergy%' THEN 'ALLERGY' ELSE 'SICK' END,
	(SELECT max(assessment_category_id) 
		FROM c_Assessment_Category ac
		WHERE icd.code BETWEEN ac.icd10_start AND ac.icd10_end),
	CASE WHEN len(descr) <= 80 THEN replace(descr,'"','') ELSE substring(replace(descr,'"',''),1,77) + '...' END,
	replace(descr,'"',''),
	'OK',
	newid(),
	0,
	getdate()
FROM icd10cm_codes_2018 icd
WHERE NOT EXISTS (SELECT 1 FROM #Assessment_Map m WHERE m.icd10_code = icd.code)
ORDER BY code
-- 64241
GO

update c_Assessment_Definition set risk_level = 0 
where lower(long_description) like '%counseling%'
and (risk_level IS NULL OR risk_level = 2)
update c_Assessment_Definition set risk_level = 4 
where lower(long_description) like '%high risk%' 
and (risk_level IS NULL OR risk_level = 2)
update c_Assessment_Definition set risk_level = 4 
where lower(long_description) like '%hiv% disease complicating%'
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
WHERE lower(long_description) like '%ossif%' 
	or lower(long_description) like '%calcif%' 
	or lower(long_description) like '%degenerat%' 
	or lower(long_description) like '%atroph%' 
	or lower(long_description) like '%dystroph%' 
	or lower(long_description) like '%disorder%' 
	or lower(long_description) like '%syndrome%' 
	or lower(long_description) like '%phobia%' 
	or lower(long_description) like '%congenital%' 
	or lower(long_description) like '%chronic%'
AND acuteness IS NULL
-- 2207
	
update c_Assessment_Definition set acuteness = 'Chronic' 
where icd10_code = 'Z730'

update c_Assessment_Definition set acuteness = 'Acute'
where long_description not like '%chronic%' 
and (lower(long_description) like '%burn%' 
	or lower(long_description) like '%wound%' 
	or lower(long_description) like '%crisis%' 
	or lower(long_description) like '%contusion%' 
	or lower(long_description) like '%laceration%' 
	or lower(long_description) like '%fracture%' 
	or lower(long_description) like '%rupture%' 
	or lower(long_description) like '%poison%' 
	or lower(long_description) like '%fever%' 
	or lower(long_description) like '%hemorrhag%' 
	or lower(long_description) like '%injury%' 
	or lower(long_description) like '%shock%' 
	or lower(long_description) like '%acute%'
	)
-- 30571

UPDATE  c_Assessment_Definition 
SET icd10_code = 'Z01419'
WHERE assessment_id = 'DEMO1206' 

update c_Assessment_Definition 
set assessment_type = 'PROBLEM', auto_close = 'Y' 
where long_description like '%History%'

update c_Assessment_Definition set assessment_type = 'FAMILY' 
where long_description like '%Family History%'

update c_Assessment_Definition set assessment_type = 'OB' 
where icd10_code like 'O%' or icd10_code like 'P%' 

UPDATE d
SET long_description = i.descr
FROM c_Assessment_Definition d
JOIN icd10cm_codes_2018 i on i.code = d.icd10_code
where (long_description = description OR long_description IS NULL)
and assessment_id not like 'ICD%'

GO
/*
select 	[assessment_id]    -- use "ICD_" + icd10_code
	,[icd10_code]
    ,[assessment_type]  -- SICK or ALLERGY
    ,[assessment_category_id]  --  assign according to first 3 ICD10 characters
    ,[description]    -- truncated ICD10 description
    ,[long_description]  -- ICD10 description
 from c_Assessment_Definition
 order by assessment_id
 */