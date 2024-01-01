
-- 11_16_2020 KenyaRetentionDrugsDeletions.csv
exec sp_remove_epro_drug 0, 'ke', '2245'
exec sp_remove_epro_drug 0, 'ke', '6915'

-- Remove duplicates RetentionListDuplicates.xlsx
exec sp_remove_epro_drug 0, 'ke', '5282A'
exec sp_remove_epro_drug 0, 'ke', '1796'
exec sp_remove_epro_drug 0, 'ke', '7754B'
exec sp_remove_epro_drug 0, 'ke', '4526' -- reinserted as Lorata later

-- Mark these as generic-only to prevent re-insertion as brands named for generics
UPDATE Kenya_Drugs
SET generic_only = 1, Notes = SBD_Version
-- select * 
FROM Kenya_Drugs 
WHERE (SBD_Version LIKE 'No corresponding%'
	OR SBD_Version LIKE 'NO KNOWN%'
	OR SBD_Version LIKE 'no Oral%'
	OR SBD_Version LIKE 'No available%'
	OR SBD_Version LIKE 'No Brand%'
OR Retention_no IN ('00nobrandfound','10671','4726','3205','1796','2821',
	'10938','10949','2925','4760','1537','10147','3920','3544','10943','5631',
	'7647','7469','6742','4693','6316','7001','6340','12435','7991')
OR SBD_Version = SCD_PSN_Version)
-- (102 row(s) affected)

UPDATE Kenya_Drugs
SET SBD_Version = NULL
WHERE generic_only = 1

-- Assign ids in Kenya_Drugs where missing

UPDATE Kenya_Drugs SET Retention_No = dbo.fn_next_country_id('ke') WHERE [SCD_PSN_Version] = 'leuprolide acetate 11.25 MG in 1 ML (1 month) Prefilled Syringe'
UPDATE Kenya_Drugs SET Retention_No = dbo.fn_next_country_id('ke') WHERE [SCD_PSN_Version] = 'leuprolide acetate 3.75 MG in 1 ML (1 month) Prefilled Syringe'
UPDATE Kenya_Drugs SET Retention_No = dbo.fn_next_country_id('ke') WHERE [SCD_PSN_Version] = 'cloNIDine HCl 0.15 MG Oral Tablet'
UPDATE Kenya_Drugs SET Retention_No = dbo.fn_next_country_id('ke') WHERE [SCD_PSN_Version] = 'cloNIDine HCl 0.1 MG Oral Tablet'
UPDATE Kenya_Drugs SET Retention_No = dbo.fn_next_country_id('ke') WHERE [SCD_PSN_Version] = 'cloNIDine HCl 0.2 MG Oral Tablet'
UPDATE Kenya_Drugs SET Retention_No = dbo.fn_next_country_id('ke') WHERE [SCD_PSN_Version] = 'cloNIDine HCl 0.3 MG Oral Tablet'
UPDATE Kenya_Drugs SET Retention_No = dbo.fn_next_country_id('ke') WHERE [SCD_PSN_Version] = 'heparin sodium 1000 UNITS in 1 ML Injection'
UPDATE Kenya_Drugs SET Retention_No = dbo.fn_next_country_id('ke') WHERE [SCD_PSN_Version] = 'warfarin sodium 1 MG Oral Tablet'
UPDATE Kenya_Drugs SET Retention_No = dbo.fn_next_country_id('ke') WHERE [SCD_PSN_Version] = 'warfarin sodium 3 MG Oral Tablet'
UPDATE Kenya_Drugs SET Retention_No = dbo.fn_next_country_id('ke') WHERE [SCD_PSN_Version] = 'warfarin sodium 2 MG Oral Tablet'
UPDATE Kenya_Drugs SET Retention_No = dbo.fn_next_country_id('ke') WHERE [SCD_PSN_Version] = 'cloNIDine HCl 0.025 MG Oral Tablet'
UPDATE Kenya_Drugs SET Retention_No = dbo.fn_next_country_id('ke') WHERE [SCD_PSN_Version] = 'valsartan 160 MG / hydroCHLOROthiazide 25 MG Oral Tablet'
UPDATE Kenya_Drugs SET Retention_No = dbo.fn_next_country_id('ke') WHERE [SCD_PSN_Version] = 'valsartan 320 MG / hydroCHLOROthiazide 12.5 MG Oral Tablet'

 -- Standardise ingredient list
update Kenya_Drugs
set ingredient = LTRIM(RTRIM(REPLACE(ingredient,'/',' / ')))
WHERE ingredient like '%/%' 
AND ingredient not like '% / %'
-- (200 row(s) affected)

update Kenya_Drugs
SET ingredient = 
	case when ingredient is not null THEN LTRIM(RTRIM(REPLACE(ingredient,'  ',' ')))
		when scd_psn_version like '%{%' THEN NULL
		when scd_psn_version like '20 ML %' OR scd_psn_version like '30 ML %' 
			THEN dbo.fn_ingredients(substring(scd_psn_version,7,100))
		when scd_psn_version like '300 ML %' 
			THEN dbo.fn_ingredients(substring(scd_psn_version,8,100))
		when scd_psn_version like '%(equi%)%' THEN
			dbo.fn_ingredients(
			substring(scd_psn_version,1,charindex('(equi',scd_psn_version) - 1)
			+ substring(scd_psn_version,charindex(')',scd_psn_version) + 1, 300)
			)
		else dbo.fn_ingredients(scd_psn_version) end
FROM Kenya_Drugs
-- (2368 row(s) affected)

UPDATE Kenya_Drugs
SET Ingredient = 'sodium valproate / valproic acid'
WHERE Retention_No = '5442'

UPDATE k 
SET Notes = 'Obsolete',
	Corresponding_RXCUI = substring(Corresponding_RXCUI,10,20)
-- select * 
FROM Kenya_Drugs k
WHERE Corresponding_RXCUI like 'Obsolete %'
OR Corresponding_RXCUI like 'Obsolete-%'
-- (18 row(s) affected)
