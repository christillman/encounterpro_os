

BULK INSERT [c_Drug_Brand]
FROM '\\localhost\attachments\c_Drug_Brand.txt'
-- 4390

BULK INSERT [c_Drug_Brand_Ingredient]
FROM '\\localhost\attachments\c_Drug_Brand_Ingredient.txt'
-- 7261

BULK INSERT [c_Drug_Generic]
FROM '\\localhost\attachments\c_Drug_Generic.txt'
-- 8108

BULK INSERT [c_Drug_Generic_Ingredient]
FROM '\\localhost\attachments\c_Drug_Generic_Ingredient.txt'
-- 10616

-- Standardize generic equivalents for brand names
UPDATE c_Drug_Definition
SET generic_name = CASE WHEN LEN(g.generic_name) <= 500 THEN g.generic_name ELSE left(g.generic_name,497) + '...' END
FROM c_Drug_Definition dd
JOIN c_Drug_Brand b ON b.brand_name = dd.common_name
JOIN c_Drug_Generic g ON g.generic_rxcui = b.generic_rxcui
WHERE dd.status = 'OK'
-- 774

-- Standardize generic names
UPDATE c_Drug_Definition
SET generic_name = CASE WHEN LEN(g.generic_name) <= 500 THEN g.generic_name ELSE left(g.generic_name,497) + '...' END
FROM c_Drug_Definition dd
JOIN c_Drug_Generic g ON g.generic_name = dd.generic_name
WHERE dd.status = 'OK'
-- 1406

INSERT INTO c_Drug_Definition (drug_id, common_name, generic_name)
SELECT 'RXNB' + brand_name_rxcui, brand_name, 
	CASE WHEN LEN(generic_name) <= 500 THEN generic_name ELSE left(generic_name,497) + '...' END
FROM c_Drug_Brand b
JOIN c_Drug_Generic g ON g.generic_rxcui = b.generic_rxcui
WHERE b.drug_id = 'RXNB' + brand_name_rxcui
AND NOT EXISTS (SELECT 1 FROM c_Drug_Definition d WHERE d.drug_id = 'RXNB' + b.brand_name_rxcui)
-- 3662

INSERT INTO c_Drug_Definition (drug_id, common_name, generic_name)
SELECT 'RXNG' + generic_rxcui, 
	CASE WHEN LEN(generic_name) <= 80 THEN generic_name ELSE left(generic_name,77) + '...' END , 
	CASE WHEN LEN(generic_name) <= 500 THEN generic_name ELSE left(generic_name,497) + '...' END
FROM c_Drug_Generic
WHERE drug_id = 'RXNG' + generic_rxcui
AND NOT EXISTS (SELECT 1 FROM c_Drug_Definition d WHERE d.drug_id = 'RXNG' + c_Drug_Generic.generic_rxcui)
-- 7883

UPDATE d
set dea_schedule = Substring(b.dea_class,2,4) 
from c_Drug_Definition d
join c_Drug_Brand b on b.drug_id = d.drug_id
where d.dea_schedule != Substring(b.dea_class,2,4) 
-- 176

UPDATE d
set dea_schedule = Substring(g.dea_class,2,4) 
from c_Drug_Definition d
join c_Drug_Generic g on g.drug_id = d.drug_id
where d.dea_schedule != Substring(g.dea_class,2,4) 
-- 44

UPDATE c_Drug_Definition
SET controlled_substance_flag = 'Y'
WHERE dea_schedule in ('II','III')
AND controlled_substance_flag != 'Y'
-- 12
GO
