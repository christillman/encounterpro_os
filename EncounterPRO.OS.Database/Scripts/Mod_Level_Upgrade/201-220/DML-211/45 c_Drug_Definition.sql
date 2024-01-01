
-- HumaLOG needs straightening out
DELETE FROM c_Drug_Definition WHERE drug_id in ('HumaLOGMix7525','KEBI1213')
DELETE FROM c_Drug_Brand WHERE brand_name LIKE 'HumaLOG Mix-%'
UPDATE c_Drug_Brand SET brand_name = 'HumaLOG' where drug_id = 'HumaLOG'
UPDATE c_Drug_Brand SET brand_name_rxcui = '261542' where drug_id = 'KEBI9230'
UPDATE c_Drug_Formulation SET ingr_rxcui = '261542' where ingr_rxcui IN ('KEBI1213', 'KEBI9230')

-- Sync c_Drug_Definition.common_name with c_Drug_Brand.brand_name
-- (many of these were "(" not handled)
UPDATE d
SET common_name = b.brand_name
 -- select d.common_name, b.brand_name
FROM c_Drug_Definition d
JOIN c_Drug_Brand b ON d.drug_id=b.drug_id
WHERE b.brand_name != d.common_name

-- Kenya drugs marked OBSOLETE in legacy
UPDATE d
SET drug_type = 'Single Drug', status = 'OK'
-- select * 
FROM c_Drug_definition d
WHERE drug_type = 'OBSOLETE' OR status = 'OBS'
-- (9 row(s) affected)

-- Corrected sp_add_missing_drug_defn_pkg_adm_method
-- to use drug_id, not rxcui; be sure none are left
SELECT b.drug_id
FROM c_Drug_Brand b
WHERE EXISTS (SELECT 1 FROM c_Drug_Definition d2 where d2.drug_id = b.brand_name_rxcui)
AND b.brand_name_rxcui != b.drug_id

SELECT g.drug_id
FROM c_Drug_Generic g
WHERE EXISTS (SELECT 1 FROM c_Drug_Definition d2 where d2.drug_id = g.generic_rxcui)
AND g.generic_rxcui != g.drug_id
