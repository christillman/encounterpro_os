
delete from c_Drug_Definition where drug_id LIKE 'KEBI%' OR drug_id LIKE 'KEGI%'
-- (1601 row(s) affected)

-- Find Kenya drugs which match existing EncounterPro drug_ids
INSERT INTO c_Drug_Definition
(	[drug_id]
 ,[drug_type]
 ,[common_name]
 ,[generic_name]
 ,[controlled_substance_flag]
 ,[default_duration_amount]
 ,[default_duration_unit]
 ,[default_duration_prn]
 ,[max_dose_per_day]
 ,[max_dose_unit]
 ,[status]
 ,[last_updated]
 ,[owner_id]
 ,[patient_reference_material_id]
 ,[provider_reference_material_id]
 ,[dea_schedule]
 ,[dea_number]
 ,[dea_narcotic_status]
 ,[procedure_id]
 ,[reference_ndc_code]
 ,[fda_generic_available]
 ,[available_strengths]
 ,[is_generic]
)
SELECT d2.[drug_id]
 ,[drug_type]
 ,[common_name]
 ,[generic_name]
 ,[controlled_substance_flag]
 ,[default_duration_amount]
 ,[default_duration_unit]
 ,[default_duration_prn]
 ,[max_dose_per_day]
 ,[max_dose_unit]
 ,[status]
 ,[last_updated]
 ,[owner_id]
 ,[patient_reference_material_id]
 ,[provider_reference_material_id]
 ,[dea_schedule]
 ,[dea_number]
 ,[dea_narcotic_status]
 ,[procedure_id]
 ,[reference_ndc_code]
 ,[fda_generic_available]
 ,[available_strengths]
 ,[is_generic] -- select *
FROM c_Drug_Brand b
JOIN c_Drug_Definition_archive d2 ON d2.common_name = b.brand_name
WHERE b.drug_id is null
-- 4 rows

DELETE d2 
FROM c_Drug_Brand b
JOIN c_Drug_Definition_archive d2 ON d2.common_name = b.brand_name
WHERE b.drug_id is null
-- 7 rows

UPDATE b
SET drug_id = d2.drug_id
FROM c_Drug_Brand b
JOIN c_Drug_Definition d2 ON d2.common_name = b.brand_name
WHERE b.drug_id is null
-- (21 row(s) affected)

-- Find Kenya drugs which match existing EncounterPro drug_ids
INSERT INTO c_Drug_Definition
(	[drug_id]
 ,[drug_type]
 ,[common_name]
 ,[generic_name]
 ,[controlled_substance_flag]
 ,[default_duration_amount]
 ,[default_duration_unit]
 ,[default_duration_prn]
 ,[max_dose_per_day]
 ,[max_dose_unit]
 ,[status]
 ,[last_updated]
 ,[owner_id]
 ,[patient_reference_material_id]
 ,[provider_reference_material_id]
 ,[dea_schedule]
 ,[dea_number]
 ,[dea_narcotic_status]
 ,[procedure_id]
 ,[reference_ndc_code]
 ,[fda_generic_available]
 ,[available_strengths]
 ,[is_generic]
)
SELECT d2.[drug_id]
 ,[drug_type]
 ,[common_name]
 ,d2.[generic_name]
 ,[controlled_substance_flag]
 ,[default_duration_amount]
 ,[default_duration_unit]
 ,[default_duration_prn]
 ,[max_dose_per_day]
 ,[max_dose_unit]
 ,[status]
 ,[last_updated]
 ,[owner_id]
 ,[patient_reference_material_id]
 ,[provider_reference_material_id]
 ,[dea_schedule]
 ,[dea_number]
 ,[dea_narcotic_status]
 ,[procedure_id]
 ,[reference_ndc_code]
 ,[fda_generic_available]
 ,[available_strengths]
 ,[is_generic] -- select *
FROM c_Drug_Generic g
JOIN c_Drug_Definition_archive d2 ON d2.common_name = g.generic_name
WHERE d2.drug_id IN ('Cloxacillin','DivalproexSodium')
-- 2 rows

DELETE d2 
FROM c_Drug_Generic g
JOIN c_Drug_Definition_archive d2 ON d2.common_name = g.generic_name
WHERE d2.drug_id IN ('Cloxacillin','DivalproexSodium')
-- 2 rows

DELETE d2 
FROM c_Drug_Generic g
JOIN c_Drug_Definition_archive d2 ON d2.common_name = g.generic_name
WHERE g.drug_id is null
-- 0 rows

UPDATE g
SET drug_id = d2.drug_id --select *
FROM c_Drug_Generic g
JOIN c_Drug_Definition d2 ON d2.generic_name = g.generic_name
WHERE g.drug_id is null

/*
select *
FROM c_Drug_Generic g
--JOIN c_Drug_Definition d2 ON d2.generic_name = g.generic_name
WHERE g.drug_id is null
order by generic_rxcui
*/

UPDATE g
SET drug_id = generic_rxcui -- select *
FROM c_Drug_Generic g
JOIN c_Drug_Definition d2 ON d2.common_name = g.generic_name
WHERE g.drug_id IS NULL

UPDATE c_Drug_Generic
SET drug_id = generic_rxcui
WHERE drug_id is null
-- (37 row(s) affected)

DELETE d  -- select *
FROM c_Drug_Definition d
WHERE (drug_id LIKE 'KEBI%' and not exists( select 1 from c_Drug_Brand b
				where b.drug_id = d.drug_id))
	or (drug_id LIKE 'KEGI%' 
	and not exists( select 1 from c_Drug_Generic g
				where g.drug_id = d.drug_id))

-- Create drug_definition records for Kenya drugs
INSERT INTO c_Drug_Definition (drug_id, common_name, generic_name)
SELECT generic_rxcui, 
	CASE WHEN LEN(g.generic_name) <= 80 THEN g.generic_name ELSE left(g.generic_name,77) + '...' END, 
	CASE WHEN LEN(g.generic_name) <= 500 THEN g.generic_name ELSE left(g.generic_name,497) + '...' END
FROM c_Drug_Generic g
WHERE drug_id NOT IN (SELECT drug_id FROM c_Drug_Definition)
-- (38 row(s) affected)

-- Remove duplicates of Kenya drugs from first attempt

/* -- Be careful, this can return records because of truncation (common_name only 80 chars)
select * from c_Drug_Definition where common_name in (
select common_name from c_Drug_Definition group by common_name having count(*) > 1
)
order by common_name
*/

-- Remove legacy duplicate
delete from c_Drug_Definition where drug_id = 'Maple,Red1'

/*
select d.drug_id, generic_name, b.*, x.* from c_Drug_Definition d
join Kenya_Drugs x 
	on x.[Retention_No] = replace(d.drug_id,'KEGI','')
left outer join c_Drug_Brand b on b.brand_name_rxcui = replace(d.drug_id,'KEGI','KEBI')
where d.drug_id LIKE 'KEGI%' 
	and not exists( select 1 from c_Drug_Generic g
				where g.drug_id = d.drug_id)
order by d.drug_id 
*/

-- Eliminate KE drugs which will be replaced with new brand name strategy
DELETE d FROM c_Drug_Definition d
JOIN c_Drug_Brand b ON b.brand_name_rxcui = d.drug_id
AND b.drug_id IS NULL

INSERT INTO c_Drug_Definition (drug_id, common_name, generic_name)
SELECT brand_name_rxcui, brand_name, generic_name
FROM c_Drug_Brand b
LEFT JOIN c_Drug_Generic g ON g.generic_rxcui = b.generic_rxcui
WHERE NOT EXISTS (SELECT 1 FROM c_Drug_Definition d2
	WHERE d2.common_name = b.brand_name)
-- (1494 row(s) affected)

UPDATE c_Drug_Brand
SET drug_id = brand_name_rxcui
FROM c_Drug_Definition d
JOIN c_Drug_Brand b ON b.brand_name_rxcui = d.drug_id
AND b.drug_id IS NULL
-- (1475 row(s) affected)

-- Update common_name per KEDrugsBrandNameReview.xslx

update c_Drug_Definition set common_name = 'Medisart 300H' where drug_id = 'KEBI12494'
update c_Drug_Definition set common_name = 'Vastor 20-EZ' where drug_id = 'KEBI5811'

update c_Drug_Brand set brand_name = 'Medisart 300H' where brand_name_rxcui = 'KEBI12494'
update c_Drug_Brand set brand_name = 'Vastor 20-EZ' where brand_name_rxcui = 'KEBI5811'


UPDATE d 
SET generic_name = g.generic_name
FROM c_Drug_Brand b
JOIN c_Drug_Generic g ON g.generic_rxcui = b.generic_rxcui
JOIN c_Drug_Definition d ON d.drug_id = b.drug_id
WHERE g.generic_name != d.generic_name