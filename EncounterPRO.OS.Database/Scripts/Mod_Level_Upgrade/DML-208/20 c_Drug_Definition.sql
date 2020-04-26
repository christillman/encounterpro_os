

UPDATE dd
SET is_generic = 0 
FROM c_Drug_Definition dd
JOIN c_Drug_Brand b ON b.drug_id = dd.drug_id
AND is_generic = 1
WHERE dd.status = 'OK'
-- 

UPDATE c_Drug_Definition
SET is_generic = 0
WHERE status = 'OK'
AND drug_id not like 'RXN%'
AND left(common_name,6) != left(generic_name,6)
AND is_generic = 1
-- 120

-- excluded in above criteria incorrectly
UPDATE c_Drug_Definition
SET is_generic = 0 
WHERE drug_id in ('fentaNYL Oralet', 'Guaifed-PD')
AND is_generic = 1


-- Remove non-RXNORM, non-Kenya drugs

INSERT INTO c_Drug_Definition_Archive (
	   [drug_id]
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
SELECT [drug_id]
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
  FROM [dbo].[c_Drug_Definition] d
  WHERE 
	NOT EXISTS (SELECT drug_id 
		FROM c_Drug_Generic g WHERE g.drug_id = d.drug_id)
	AND NOT EXISTS (SELECT drug_id 
		FROM c_Drug_Brand b WHERE b.drug_id = d.drug_id)
	AND NOT EXISTS (SELECT drug_id 
		FROM c_Drug_Definition_Archive a WHERE a.drug_id = d.drug_id)
	-- preserve the legacy allergens and vaccines
	AND drug_type NOT IN ('Allergen', 'Vaccine')
	-- Preserve the legacy non-drug drugs
	AND drug_id NOT IN ('AEROCHAMBER', 'AEROWMASK', 'Cervicalcollar', 'Cervicalpillow', 'CervicalTraction', 
'CockupWristSplint', 'ColdMedicineOTC)', 'Collumsplint', 'ConstrictingRing', 
'Crutch,single,aluminum', 'Crutches', 'Facialmoisturicream', 'Glucosemeter', 
'Glucoseteststrips', 'Glycolicpads', 'Heelpads', 'Insulinsyringes', 'Intrauterine', 
'Lancets', 'TennisElbowBand', 'NormalSaline', 'OrthoDiaphragm', 'Oxygen,home', 
'Peakflowmeter', 'TestDrug', 'Sleeve,elbow', 'Sleeve,knee', 'Sling', 
'Unclassifiedbiologics', 'UnlistedCurrentMed', 'UnlistedDrug,Handwrit', 
'WartRemover', 'Wheelchair1', 'Wristsplint')
-- (1166 row(s) affected)

DELETE d  
FROM [dbo].[c_Drug_Definition] d
  WHERE 
	NOT EXISTS (SELECT drug_id 
		FROM EncounterPro_OS.dbo.c_Drug_Generic g WHERE g.drug_id = d.drug_id)
	AND NOT EXISTS (SELECT drug_id 
		FROM EncounterPro_OS.dbo.c_Drug_Brand b WHERE b.drug_id = d.drug_id)
	AND EXISTS (SELECT drug_id 
		FROM c_Drug_Definition_Archive a WHERE a.drug_id = d.drug_id)
-- (1166 row(s) affected)
