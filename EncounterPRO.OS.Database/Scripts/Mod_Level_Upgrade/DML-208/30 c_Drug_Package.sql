
-- Removing all non-RXNORM, non-Kenya drugs

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

-- Remove all packages where drug_id has been archived
INSERT INTO [c_Drug_Package_Archive] (
	[drug_id]
      ,[package_id]
      ,[sort_order]
      ,[prescription_flag]
      ,[default_dispense_amount]
      ,[default_dispense_unit]
      ,[take_as_directed]
      ,[hcpcs_procedure_id]
	  )
SELECT [drug_id]
      ,[package_id]
      ,[sort_order]
      ,[prescription_flag]
      ,[default_dispense_amount]
      ,[default_dispense_unit]
      ,[take_as_directed]
      ,[hcpcs_procedure_id]
FROM [dbo].[c_Drug_Package] dp
WHERE NOT EXISTS (SELECT 1 
		FROM [c_Drug_Package_Archive] a 
		WHERE a.drug_id = dp.drug_id
		AND a.package_id = dp.package_id)
	AND EXISTS (SELECT drug_id 
		FROM c_Drug_Definition_Archive a WHERE a.drug_id = dp.drug_id)
-- (2168 row(s) affected)

DELETE dp -- select count(*)
FROM [dbo].[c_Drug_Package] dp
WHERE EXISTS (SELECT 1 
		FROM [c_Drug_Package_Archive] a 
		WHERE a.drug_id = dp.drug_id
		AND a.package_id = dp.package_id)
-- (2168 row(s) affected)

-- Remove all existing packages; they were generic to be shared
-- between drugs, we now want a one-to-one relationship between
-- c_Drug_Package and c_Package
INSERT INTO [c_Package_Archive] (
	[package_id]
      ,[administer_method]
      ,[description]
      ,[administer_unit]
      ,[dose_unit]
      ,[administer_per_dose]
      ,[dosage_form]
      ,[dose_amount]
      ,[status]
	  )
SELECT [package_id]
      ,[administer_method]
      ,[description]
      ,[administer_unit]
      ,[dose_unit]
      ,[administer_per_dose]
      ,[dosage_form]
      ,[dose_amount]
      ,[status]
FROM [dbo].[c_Package] p
WHERE NOT EXISTS (SELECT 1 
		FROM [c_Package_Archive] a WHERE a.package_id = p.package_id)
-- (1745 row(s) affected)

DELETE p
FROM [dbo].[c_Package] p
WHERE EXISTS (SELECT 1 
		FROM [c_Package_Archive] a WHERE a.package_id = p.package_id)
-- (1745 row(s) affected)

-- Before the global package add, update RXCUIs for those
-- with EncounterPro drug_ids and existing package records

-- Use existing package information for 
-- existing EncounterPro drug_ids
UPDATE dp 
SET [package_id] = 'PK' + f.[form_rxcui],
	[form_rxcui] = f.[form_rxcui],
	-- This is to mark these records so they are not deleted in re-entrant executions
	[hcpcs_procedure_id] = dp.[package_id]
FROM c_Drug_Formulation f
JOIN c_Drug_Generic g ON g.generic_rxcui = f.ingr_rxcui
JOIN c_Drug_Package dp ON dp.drug_id = g.drug_id
JOIN c_Package_Archive pa ON pa.package_id = dp.package_id
WHERE f.dosage_form = 
		CASE WHEN pa.dosage_form = '*Caps' THEN 'Cap' 
			WHEN pa.dosage_form = '*Tabs' THEN 'Tab' 
			WHEN pa.dosage_form = 'Caplets*' THEN 'Caplets' 
			ELSE pa.dosage_form END
AND f.dose_amount = pa.administer_per_dose
AND f.dose_unit = pa.administer_unit
-- Exclude duplicates for buffered and ultra-microsize variations
AND dp.package_id NOT IN ('DEMOATABXB325','DEMOATABXB500','DEMOATAB125x1','DEMOATAB250x1')
-- (426 row(s) affected)

UPDATE dp 
SET [package_id] = 'PK' + f.[form_rxcui],
	[form_rxcui] = f.[form_rxcui],
	-- This is to mark these records so they are not deleted in re-entrant executions
	[hcpcs_procedure_id] = dp.[package_id]
FROM c_Drug_Formulation f
JOIN c_Drug_Brand b ON b.brand_name_rxcui = f.ingr_rxcui
JOIN c_Drug_Package dp ON dp.drug_id = b.drug_id
JOIN c_Package_Archive pa ON pa.package_id = dp.package_id
WHERE f.dosage_form = 
		CASE WHEN pa.dosage_form = '*Caps' THEN 'Cap' 
			WHEN pa.dosage_form = '*Tabs' THEN 'Tab' 
			WHEN pa.dosage_form = 'Caplets*' THEN 'Caplets' 
			ELSE pa.dosage_form END
AND f.dose_amount = pa.administer_per_dose
AND f.dose_unit = pa.administer_unit
-- Exclude duplicates for ODT, XR, XL
AND dp.package_id NOT IN ('DEMOATABXODT4','DEMOATABXODT8','XR Tabs 500 mg','XL Tabs 500 mg',
	'DEMOATABXXR200','ODT Tabs 10 mg','ODT Tabs 15 mg')
-- (725 row(s) affected)


-- Remove packages which haven't been matched above
INSERT INTO [c_Drug_Package_Archive] (
	[drug_id]
      ,[package_id]
      ,[sort_order]
      ,[prescription_flag]
      ,[default_dispense_amount]
      ,[default_dispense_unit]
      ,[take_as_directed]
      ,[hcpcs_procedure_id]
	  )
SELECT [drug_id]
      ,[package_id]
      ,[sort_order]
      ,[prescription_flag]
      ,[default_dispense_amount]
      ,[default_dispense_unit]
      ,[take_as_directed]
      ,[hcpcs_procedure_id]
FROM [dbo].[c_Drug_Package] dp
WHERE NOT EXISTS (SELECT 1 
		FROM [c_Drug_Package_Archive] a 
		WHERE a.drug_id = dp.drug_id
		AND a.package_id = dp.package_id)
	AND form_rxcui is null
-- (2041 row(s) affected)

DELETE dp 
FROM [dbo].[c_Drug_Package] dp
WHERE EXISTS (SELECT 1 
		FROM [c_Drug_Package_Archive] a 
		WHERE a.drug_id = dp.drug_id
		AND a.package_id = dp.package_id)


-- This would pick up no records the first time, but would 
-- delete the records being inserted next for re-entrancy.
DELETE FROM c_Drug_Package
WHERE [hcpcs_procedure_id] IS NULL

-- Add packages corresponding to formulations 
-- (one package per formulation, description includes drug)
INSERT INTO c_Drug_Package
(
		[drug_id]
      ,[package_id]
      ,[sort_order]
      ,[prescription_flag]
      ,[default_dispense_amount]
      ,[default_dispense_unit]
      ,[take_as_directed]
      ,[hcpcs_procedure_id]
      ,[form_rxcui]
	  )
SELECT b.drug_id
      ,'PK' + [form_rxcui] AS [package_id]
      ,NULL AS [sort_order]
      ,'Y' AS [prescription_flag]
      ,NULL AS [default_dispense_amount]
      ,df.[default_dose_unit] AS [default_dispense_unit]
      ,NULL AS [take_as_directed]
      ,NULL AS [hcpcs_procedure_id]
      ,[form_rxcui]
FROM c_Drug_Formulation f
JOIN c_Dosage_Form df ON df.dosage_form = f.dosage_form
JOIN c_Drug_Brand b ON b.brand_name_rxcui = f.ingr_rxcui
WHERE NOT EXISTS (SELECT 1 
		FROM [c_Drug_Package] a 
		WHERE a.drug_id = b.drug_id
		AND a.[form_rxcui] = f.[form_rxcui])

INSERT INTO c_Drug_Package
(
		[drug_id]
      ,[package_id]
      ,[sort_order]
      ,[prescription_flag]
      ,[default_dispense_amount]
      ,[default_dispense_unit]
      ,[take_as_directed]
      ,[hcpcs_procedure_id]
      ,[form_rxcui]
	  )
SELECT g.drug_id
      ,'PK' + [form_rxcui] AS [package_id]
      ,NULL AS [sort_order]
      ,'Y' AS [prescription_flag]
      ,NULL AS [default_dispense_amount]
      ,df.[default_dose_unit] AS [default_dispense_unit]
      ,NULL AS [take_as_directed]
      ,NULL AS [hcpcs_procedure_id]
      ,[form_rxcui]
FROM c_Drug_Formulation f
JOIN c_Dosage_Form df ON df.dosage_form = f.dosage_form
JOIN c_Drug_Generic g ON g.generic_rxcui = f.ingr_rxcui
WHERE NOT EXISTS (SELECT 1 
		FROM [c_Drug_Package] a 
		WHERE a.drug_id = g.drug_id
		AND a.[form_rxcui] = f.[form_rxcui])

-- for re-entrancy; should have been archived above
DELETE p 
FROM [dbo].[c_Package] p

INSERT INTO c_Package
(
		[package_id]
      ,[administer_method]
      ,[description]
      ,[administer_unit]
      ,[dose_unit]
      ,[administer_per_dose]
      ,[dosage_form]
      ,[dose_amount]
      ,[status]
	  )
SELECT dp.[package_id]
      ,df.[default_administer_method] AS [administer_method]
      ,f.form_descr AS [description]
      ,f.[dose_unit] AS [administer_unit]
      ,df.[default_dose_unit] AS [dose_unit]
      ,f.[dose_amount] AS [administer_per_dose]
      ,f.[dosage_form]
      ,NULL
      ,'OK'
FROM c_Drug_Formulation f
JOIN c_Dosage_Form df ON df.dosage_form = f.dosage_form
JOIN c_Drug_Brand b ON b.brand_name_rxcui = f.ingr_rxcui
JOIN c_Drug_Package dp ON dp.drug_id = b.drug_id
	AND dp.form_rxcui = f.form_rxcui
-- 8085

INSERT INTO c_Package
(
		[package_id]
      ,[administer_method]
      ,[description]
      ,[administer_unit]
      ,[dose_unit]
      ,[administer_per_dose]
      ,[dosage_form]
      ,[dose_amount]
      ,[status]
	  )
SELECT dp.[package_id]
      ,df.[default_administer_method] AS [administer_method]
      ,f.form_descr AS [description]
      ,f.[dose_unit] AS [administer_unit]
      ,df.[default_dose_unit] AS [dose_unit]
      ,f.[dose_amount] AS [administer_per_dose]
      ,f.[dosage_form]
      ,CASE WHEN df.[default_dose_unit] IN ('MG', 'ML', 'MG/ML') 
		THEN NULL ELSE 1 END
      ,'OK' 
FROM c_Drug_Formulation f
JOIN c_Dosage_Form df ON df.dosage_form = f.dosage_form
JOIN c_Drug_Generic g ON g.generic_rxcui = f.ingr_rxcui
JOIN c_Drug_Package dp ON dp.drug_id = g.drug_id
	AND dp.form_rxcui = f.form_rxcui
-- 12649

-- Note some packages are missing for Kenya drugs because of NULL dosage_form columns

-- Eliminate drugs from user lists which have been archived
DELETE u
FROM u_top_20 u
JOIN c_Drug_Definition_Archive d on d.drug_id = u.item_id
WHERE top_20_code like '%med%'

-- Substitute for those being archived that we can figure out
UPDATE c_Drug_Instruction SET drug_id = 'Adalat' WHERE drug_id = 'AdalatCC'
UPDATE c_Drug_Instruction SET drug_id = 'RXNG135095' WHERE drug_id = 'Aspirinw/Codeine'
UPDATE c_Drug_Instruction SET drug_id = 'Calan' WHERE drug_id = 'CalanSR'
UPDATE c_Drug_Instruction SET drug_id = 'ClaritinD12Hour' WHERE drug_id = 'ClaritinD24'
UPDATE c_Drug_Instruction SET drug_id = 'RXNG2582' WHERE drug_id = 'Clindamycin'
UPDATE c_Drug_Instruction SET drug_id = 'RXNB831221' WHERE drug_id = 'DilacorXR'
UPDATE c_Drug_Instruction SET drug_id = 'RXNB202677' WHERE drug_id = 'DilatrateSR'
UPDATE c_Drug_Instruction SET drug_id = 'RXNB544837' WHERE drug_id = 'Doxy'
UPDATE c_Drug_Instruction SET drug_id = 'RXNB1490016' WHERE drug_id = 'DuraVent'
UPDATE c_Drug_Instruction SET drug_id = 'RXNB1490016' WHERE drug_id = 'DuraVentDA'
UPDATE c_Drug_Instruction SET drug_id = 'Effexor' WHERE drug_id = 'EffexorXR'
UPDATE c_Drug_Instruction SET drug_id = 'RXNB1190809' WHERE drug_id = 'Entex'
UPDATE c_Drug_Instruction SET drug_id = 'RXNB1190809' WHERE drug_id = 'EntexLA'
UPDATE c_Drug_Instruction SET drug_id = 'RXNB217717' WHERE drug_id = 'ImodiumAD'
UPDATE c_Drug_Instruction SET drug_id = 'RXNB358859' WHERE drug_id = 'Monistat'
UPDATE c_Drug_Instruction SET drug_id = 'RXNB93367' WHERE drug_id = 'Mycelex'
UPDATE c_Drug_Instruction SET drug_id = 'Nasalcrom1' WHERE drug_id = 'NasalcromAAllergy'
UPDATE c_Drug_Instruction SET drug_id = 'Nasalcrom1' WHERE drug_id = 'NasalcromCAAllergy'
UPDATE c_Drug_Instruction SET drug_id = 'RXNG4917' WHERE drug_id = 'Nytroglycerine'
UPDATE c_Drug_Instruction SET drug_id = 'Procardia' WHERE drug_id = 'ProcardiaXL'
UPDATE c_Drug_Instruction SET drug_id = 'RXNG9068' WHERE drug_id = 'quiNIDinegluconate'
UPDATE c_Drug_Instruction SET drug_id = 'RXNG9068' WHERE drug_id = 'quiNIDinesulfate'
UPDATE c_Drug_Instruction SET drug_id = 'RXNG83395' WHERE drug_id = 'Saquinavir'
UPDATE c_Drug_Instruction SET drug_id = 'RXNG83395' WHERE drug_id = 'SaquinavirH'
UPDATE c_Drug_Instruction SET drug_id = 'Vicodin' WHERE drug_id = 'VicodinTuss'
UPDATE c_Drug_Instruction SET drug_id = 'RXNB202398' WHERE drug_id = 'Xylocaine'

DELETE u 
FROM c_Drug_Instruction u
JOIN c_Drug_Definition_Archive d on d.drug_id = u.drug_id
where d.drug_type = 'OBSOLETE'

-- Remove orphan package references (these were generic kinds of references, no longer useful)
-- Note, we are keeping the instructions just removing the package reference
UPDATE u 
SET u.package_id = NULL
FROM c_Drug_Instruction u
JOIN c_Drug_Package_Archive d on d.package_id = u.package_id
-- (11 row(s) affected)

UPDATE u 
SET u.package_id = NULL
FROM c_Drug_Instruction u
JOIN c_Package_Archive d on d.package_id = u.package_id
--(3 row(s) affected)

-- Assessing u_Assessment_Treat_Def_Attrib, found that all package_id attributes have NULL values.
-- Just eliminate all the NULLs for all attributes.
DELETE FROM u_Assessment_Treat_Def_Attrib
WHERE value is null and long_value is null
-- (13434 row(s) affected)