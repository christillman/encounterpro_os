
INSERT INTO c_Drug_Brand_Ingredient (brand_name_rxcui, generic_rxcui_ingredient)
SELECT r.RXCUI2 , r.RXCUI1
FROM interfaces..rxnconso c
JOIN interfaces..rxnrel r ON r.RXCUI2 = c.RXCUI
JOIN interfaces..rxnconso c1 ON c1.rxcui = r.rxcui1
WHERE c.tty = 'BN' AND c.SAB = 'RXNORM'
AND c1.SAB = 'RXNORM'
AND r.rela = 'tradename_of'
AND c1.TTY = 'TMSY' -- Prefer Tall Man synonym if available
AND c1.RXAUI != '10271063' -- Avoid duplicate Cyclosporine A synonym for Cyclosporine
-- 473

INSERT INTO c_Drug_Brand_Ingredient (brand_name_rxcui, generic_rxcui_ingredient)
SELECT c.RXCUI, c1.RXCUI
FROM interfaces..rxnconso c
JOIN interfaces..rxnrel r ON r.RXCUI2 = c.RXCUI
JOIN interfaces..rxnconso c1 ON c1.RXCUI = r.RXCUI1
WHERE r.rela = 'tradename_of'
AND c.tty = 'BN' AND c.SAB = 'RXNORM'
AND c1.SAB = 'RXNORM'
AND c1.TTY = 'IN' 
AND NOT EXISTS (SELECT 1 FROM c_Drug_Brand_Ingredient b2 WHERE b2.brand_name_rxcui = r.RXCUI2)
-- 6541

INSERT INTO c_Drug_Brand (brand_name, brand_name_rxcui, is_single_ingredient)
SELECT c.[str], c.RXCUI, 1
FROM interfaces..rxnconso c
WHERE c.RXCUI IN (SELECT brand_name_rxcui 
				FROM c_Drug_Brand_Ingredient
				GROUP BY brand_name_rxcui
				HAVING COUNT(*) = 1)
AND c.tty = 'BN' AND c.SAB = 'RXNORM'
ORDER BY c.[str]
-- 3319

-- Generic equivalents of brand name drug ingredients
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient)
SELECT [str], RXCUI, 1
FROM interfaces..rxnconso c
WHERE RXCUI IN (SELECT generic_rxcui_ingredient FROM c_Drug_Brand_Ingredient)
AND c.tty = 'TMSY'
AND c.RXAUI != '10271063' -- Avoid duplicate Cyclosporine A synonym for Cyclosporine
-- 98

INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient)
SELECT [str], RXCUI, 1
FROM interfaces..rxnconso c
WHERE RXCUI IN (SELECT generic_rxcui_ingredient FROM c_Drug_Brand_Ingredient)
AND c.tty = 'IN'
AND NOT EXISTS (SELECT 1 FROM c_Drug_Generic g2 WHERE g2.generic_rxcui = RXCUI)
-- 1630

-- Assume these can all be prescribed as single drugs
INSERT INTO c_Drug_Generic_Ingredient (generic_rxcui, generic_rxcui_ingredient)  
SELECT generic_rxcui, generic_rxcui
FROM c_Drug_Generic g
WHERE NOT EXISTS (SELECT 1 FROM c_Drug_Generic_Ingredient g2 
		WHERE g2.generic_rxcui = g.generic_rxcui)
-- 1728

-- Multiple ingredient brand drugs
INSERT INTO c_Drug_Brand (brand_name, brand_name_rxcui)
SELECT c.[str], c.RXCUI
FROM interfaces..rxnconso c
WHERE c.RXCUI IN (SELECT brand_name_rxcui 
				FROM c_Drug_Brand_Ingredient
				GROUP BY brand_name_rxcui
				HAVING COUNT(*) > 1)
AND c.tty = 'BN' AND c.SAB = 'RXNORM'
ORDER BY c.[str]
-- 1071

INSERT INTO c_Drug_Generic_Ingredient (generic_rxcui, generic_rxcui_ingredient) 
SELECT c1.RXCUI, c.RXCUI
FROM interfaces..rxnconso c
JOIN interfaces..rxnrel r ON r.RXCUI2 = c.RXCUI
JOIN interfaces..rxnconso c1 ON c1.RXCUI = r.RXCUI1
WHERE r.rela = 'part_of'
AND c.SAB = 'RXNORM'
AND c1.SAB = 'RXNORM'
AND c1.TTY = 'MIN' -- Multiple ingredient generics
and c.TTY IN ('IN','PIN')
AND NOT EXISTS (SELECT 1 FROM c_Drug_Generic_Ingredient g2 WHERE g2.generic_rxcui = r.RXCUI1)
-- 3677

INSERT INTO c_Drug_Generic (generic_name, generic_rxcui)
SELECT c.[str], c.RXCUI
FROM interfaces..rxnconso c
WHERE c.RXCUI IN (SELECT generic_rxcui FROM c_Drug_Generic_Ingredient)
AND c.TTY = 'TMSY'
AND NOT EXISTS (SELECT 1 FROM c_Drug_Generic g2 WHERE g2.generic_rxcui = c.RXCUI)
-- 118

INSERT INTO c_Drug_Generic (generic_name, generic_rxcui)
SELECT c.[str], c.RXCUI
FROM interfaces..rxnconso c
WHERE c.RXCUI IN (SELECT generic_rxcui FROM c_Drug_Generic_Ingredient)
AND c.TTY = 'MIN'
AND NOT EXISTS (SELECT 1 FROM c_Drug_Generic g2 WHERE g2.generic_rxcui = c.RXCUI)
and LEN(c.[str]) <= 500 -- 2 don't fit
-- 1047

INSERT INTO c_Drug_Generic (generic_name, generic_rxcui)
SELECT LEFT(c.[str],497) + '...', c.RXCUI
FROM interfaces..rxnconso c
WHERE c.RXCUI IN (SELECT generic_rxcui FROM c_Drug_Generic_Ingredient)
AND c.TTY = 'MIN'
AND NOT EXISTS (SELECT 1 FROM c_Drug_Generic g2 WHERE g2.generic_rxcui = c.RXCUI)
and LEN(c.[str]) > 500 -- 2 don't fit

-- Single ingredient brand names generic equivalent
UPDATE c_Drug_Brand
	SET generic_rxcui = bi.generic_rxcui_ingredient
	FROM c_Drug_Brand 
	JOIN c_Drug_Brand_Ingredient bi ON c_Drug_Brand.brand_name_rxcui = bi.brand_name_rxcui
	WHERE is_single_ingredient = 1
-- 3319

-- Fill in the 2 that don't fit in 500 chars
UPDATE c_Drug_Brand SET generic_rxcui = 1008785 WHERE brand_name_rxcui = 287523
UPDATE c_Drug_Brand SET generic_rxcui = 1008803 WHERE brand_name_rxcui = 901641

EXEC build_generic_equivalents

-- Not listed as MIN multiple-ingredient generic equivalent in RXNORM
-- Maybe having to do with relating to both IN and PIN?
-- SELECT brand_name_rxcui, brand_name FROM c_Drug_Brand where generic_rxcui is null
-- 84815	Adderall
-- 1927611	Mydayis

INSERT INTO c_Drug_Generic (generic_rxcui, generic_name) 
SELECT 'G' + brand_name_rxcui, 'Amphetamine / Dextroamphetamine'
FROM c_Drug_Brand
WHERE brand_name_rxcui = '84815' AND generic_rxcui is null
AND NOT EXISTS (SELECT 1 FROM c_Drug_Generic
					WHERE generic_rxcui = 'G' + brand_name_rxcui)
-- 1

UPDATE c_Drug_Brand
SET generic_rxcui = 'G' + brand_name_rxcui
WHERE brand_name_rxcui = '84815' AND generic_rxcui is null
-- 1

-- same ingredients
UPDATE c_Drug_Brand
SET generic_rxcui = 'G84815' 
WHERE brand_name_rxcui = '1927611' AND generic_rxcui is null
-- 1

UPDATE c_Drug_Brand set drug_id = NULL where drug_id is not null
-- 4390
UPDATE c_Drug_Generic set drug_id = NULL where drug_id is not null
-- 2898

-- Now, relate these to the existing drug structure

-- Update existing generic_name to match where brand name matches
UPDATE c_Drug_Definition
SET generic_name = g.generic_name
FROM c_Drug_Definition dd
JOIN c_Drug_Brand b ON b.brand_name = dd.common_name
JOIN c_Drug_Generic g ON g.generic_rxcui = b.generic_rxcui
WHERE dd.generic_name != g.generic_name
-- 83

-- Exact generic_name matches to existing table
UPDATE c_Drug_Brand 
SET drug_id = dd.drug_id
FROM c_Drug_Definition dd
JOIN c_Drug_Brand b ON b.brand_name = dd.common_name
JOIN c_Drug_Generic g ON g.generic_rxcui = b.generic_rxcui
WHERE b.drug_id is null
AND dd.generic_name = g.generic_name
-- 766

UPDATE g
SET drug_id = b.drug_id
FROM c_Drug_Brand b
JOIN c_Drug_Generic g ON g.generic_rxcui = b.generic_rxcui
WHERE g.drug_id is null AND b.drug_id IS NOT NULL
-- 604


UPDATE g
SET drug_id = dd.drug_id
FROM c_Drug_Definition dd
JOIN c_Drug_Generic g ON g.generic_name = dd.generic_name
WHERE NOT EXISTS (SELECT 1 FROM c_Drug_Generic g WHERE g.drug_id = dd.drug_id)
AND dd.common_name = dd.generic_name
-- 167

INSERT INTO c_Drug_Definition (drug_id, common_name, generic_name)
SELECT 'RXNG' + generic_rxcui, left(generic_name,77) + '...' , generic_name
FROM c_Drug_Generic
WHERE drug_id IS NULL
AND NOT EXISTS (SELECT 1 FROM c_Drug_Definition d WHERE d.drug_id = 'RXNG' + c_Drug_Generic.generic_rxcui)
-- 2254

UPDATE c_Drug_Generic 
SET drug_id = 'RXNG' + generic_rxcui
WHERE drug_id IS NULL
-- 2254

INSERT INTO c_Drug_Definition (drug_id, common_name, generic_name)
SELECT 'RXNB' + brand_name_rxcui, brand_name, generic_name
FROM c_Drug_Brand b
JOIN c_Drug_Generic g ON g.generic_rxcui = b.generic_rxcui
WHERE b.drug_id IS NULL
AND NOT EXISTS (SELECT 1 FROM c_Drug_Definition d WHERE d.drug_id = 'RXNB' + b.brand_name_rxcui)
-- 3624

UPDATE c_Drug_Brand
SET drug_id = 'RXNB' + brand_name_rxcui
WHERE drug_id IS NULL
-- 3624
