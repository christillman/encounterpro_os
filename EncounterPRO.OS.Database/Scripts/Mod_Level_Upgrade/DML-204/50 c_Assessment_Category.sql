
DELETE FROM c_Assessment_Definition d
WHERE assessment_category_id = 'PROBLEM' 
and exists (select 1 
		from c_Assessment_Definition d2 
		where d2.description = d.description
		and d2.icd10_code = d.icd10_code
		and d2.assessment_category_id = 'Z')

DELETE FROM c_Assessment_Definition d
WHERE assessment_category_id = 'RPERI' 
and exists (select 1 
		from c_Assessment_Definition d2 
		where d2.description = d.description
		and d2.icd10_code = d.icd10_code
		and d2.assessment_category_id = 'OBP')

UPDATE c_Assessment_Definition
SET assessment_category_id = 'OBP'
WHERE assessment_category_id = 'RPERI' 

DELETE FROM c_Specialty_Assessment_Category 
WHERE assessment_category_id IN ('RPERI')

DELETE FROM c_Assessment_Category
WHERE assessment_category_id IN ('RPERI')

-- Unused
DELETE FROM c_assessment_type
WHERE assessment_type = 'PT'

DELETE FROM c_Assessment_Definition WHERE assessment_id = 'DEMO10305'

UPDATE c_Assessment_Definition SET assessment_id = 'DEMO10305'
WHERE assessment_id = '0^11954'

DELETE FROM c_Common_Assessment WHERE assessment_id = '0^11954'

UPDATE c_Assessment_Definition 
SET description = replace(description,'small pox','Smallpox')
WHERE description like 'small pox%'

-- cleanup
DELETE FROM c_Assessment_Definition WHERE assessment_id = '0^11772'

DELETE from c_Assessment_Definition
where icd_9_code = 'copy'


