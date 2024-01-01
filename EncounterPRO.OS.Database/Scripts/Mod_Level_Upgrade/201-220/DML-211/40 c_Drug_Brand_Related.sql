
-- Remove brand records for Kenya_Drugs where generic was entered in SBD_Version
DELETE b -- select *
FROM Kenya_Drugs k
JOIN c_Drug_Brand_Related br1 on br1.source_id = k.Retention_No
JOIN c_Drug_Brand b ON b.brand_name_rxcui = br1.brand_name_rxcui
WHERE k.SBD_Version IS NULL
-- (3 row(s) affected)

-- Remove c_Drug_Brand_Related records for Kenya_Drugs where generic was entered in SBD_Version
-- or brand name not found in retention list
DELETE br1 -- select *
FROM Kenya_Drugs k
JOIN c_Drug_Brand_Related br1 on br1.source_id = k.Retention_No
WHERE k.SBD_Version IS NULL
-- (8 row(s) affected)

DELETE FROM c_Drug_Brand
WHERE brand_name_rxcui = 'KEBINL00011'

INSERT INTO c_Drug_Brand (drug_id, brand_name_rxcui, brand_name, generic_rxcui, is_single_ingredient) 
VALUES ('KEBINL00011', 'KEBINL00011', 'Dixarit', '2599', 1)

INSERT INTO [c_Drug_Brand_Related] (
	[country_code],
	[source_id],
	[source_brand_form_descr],
	[brand_name_rxcui],
	[is_single_ingredient])
SELECT 'ke', Retention_No, SBD_Version, 
	CASE WHEN SBD_Version LIKE 'Candid-V6%' THEN 'KEBI6487'
		WHEN SBD_Version LIKE 'Esose%' THEN 'KEBI5571'
		WHEN SBD_Version LIKE 'Glucovance%' THEN '284743'
		WHEN SBD_Version LIKE 'Ventolin Rotacaps%' THEN 'KEBI4558'	
	ELSE 'KEBI' + Retention_No END, 
	CASE WHEN SCD_PSN_Version like '% / %' THEN 0 ELSE 1 END 
FROM Kenya_Drugs k
WHERE k.SBD_Version IS NOT NULL
AND NOT EXISTS (select 1 
	FROM c_Drug_Brand_Related br
	WHERE br.source_brand_form_descr = k.SBD_Version
	)
