
-- All generic ingredients
-- Assume these can all be prescribed as single drugs
INSERT INTO c_Drug_Generic (generic_name, 
				generic_rxcui, 
				is_single_ingredient, 
				mesh_definition,
				scope_note,
				mesh_source)
SELECT [str], c.RXCUI, 'Y', 
	(SELECT min(sd.ATV) FROM interfaces..rxnsat_full sd
		WHERE sd.RXCUI = c.RXCUI AND sd.ATN = 'MESH_DEFINITION'),
	(SELECT min(sn.ATV) FROM interfaces..rxnsat_full sn
		WHERE sn.RXCUI = c.RXCUI AND sn.ATN = 'SOS'),
	(SELECT min(ss.ATV) FROM interfaces..rxnsat_full ss
		WHERE ss.RXCUI = c.RXCUI AND ss.ATN = 'SRC')
FROM interfaces..rxnconso_FULL c
WHERE c.tty IN ('IN', 'PIN')
AND c.SAB = 'RXNORM'
AND c.SUPPRESS = 'N'
AND c.RXCUI IN ('2592' -- Clofazimine
)
-- 6939

INSERT INTO c_Drug_Generic_Ingredient (generic_rxcui, generic_rxcui_ingredient)  
SELECT generic_rxcui, generic_rxcui
FROM c_Drug_Generic g
WHERE generic_rxcui IN ('2592' -- Clofazimine
)
-- 6939

-- All generic multiple ingredient drugs
INSERT INTO c_Drug_Generic (generic_name, 
				generic_rxcui, 
				is_single_ingredient, 
				mesh_definition,
				scope_note,
				mesh_source)
SELECT CASE WHEN LEN([str]) <= 900 THEN [str] ELSE LEFT([str],897) + '...' END, 
	c.RXCUI, 'N', 
	(SELECT min(sd.ATV) FROM interfaces..rxnsat_full sd
		WHERE sd.RXCUI = c.RXCUI AND sd.ATN = 'MESH_DEFINITION'),
	(SELECT min(sn.ATV) FROM interfaces..rxnsat_full sn
		WHERE sn.RXCUI = c.RXCUI AND sn.ATN = 'SOS'),
	(SELECT min(ss.ATV) FROM interfaces..rxnsat_full ss
		WHERE ss.RXCUI = c.RXCUI AND ss.ATN = 'SRC')
FROM interfaces..rxnconso_FULL c
WHERE c.tty IN ('MIN')
AND c.SAB = 'RXNORM'
AND c.SUPPRESS = 'N'
AND c.RXCUI IN ('' -- 
)
-- 1167

-- All brand name ingredients
INSERT INTO c_Drug_Brand_Ingredient (brand_name_rxcui, generic_rxcui_ingredient)
SELECT r.RXCUI2, r.RXCUI1
FROM interfaces..rxnconso_FULL c
JOIN interfaces..rxnrel r ON r.RXCUI2 = c.RXCUI
JOIN interfaces..rxnconso_FULL c1 ON c1.rxcui = r.rxcui1
WHERE c.tty = 'BN' 
AND c.SAB = 'RXNORM'
AND c1.TTY IN ('IN', 'PIN')
AND c1.SAB = 'RXNORM'
AND r.rela = 'tradename_of'
AND c.SUPPRESS = 'N'
AND c1.SUPPRESS = 'N'
AND c.RXCUI IN ('' -- 
)
-- 7261

INSERT INTO c_Drug_Brand (brand_name,
				brand_name_rxcui, 
				is_single_ingredient, 
				scope_note,
				mesh_source)
SELECT c.[str], c.RXCUI, 'Y', 
	(SELECT min(sn.ATV) FROM interfaces..rxnsat_full sn
		WHERE sn.RXCUI = c.RXCUI AND sn.ATN = 'SOS'),
	(SELECT min(ss.ATV) FROM interfaces..rxnsat_full ss
		WHERE ss.RXCUI = c.RXCUI AND ss.ATN = 'SRC')
FROM interfaces..rxnconso_FULL c
WHERE c.RXCUI IN (SELECT brand_name_rxcui 
				FROM c_Drug_Brand_Ingredient
				GROUP BY brand_name_rxcui
				HAVING COUNT(*) = 1)
AND c.tty = 'BN' AND c.SAB = 'RXNORM'
AND c.RXCUI IN ('' -- 
)
ORDER BY c.[str]
-- 3104

-- Multiple ingredient brand drugs
INSERT INTO c_Drug_Brand (brand_name,
				brand_name_rxcui, 
				is_single_ingredient, 
				scope_note,
				mesh_source)
SELECT c.[str], c.RXCUI, 'N', 
	(SELECT min(sn.ATV) FROM interfaces..rxnsat_full sn
		WHERE sn.RXCUI = c.RXCUI AND sn.ATN = 'SOS'),
	(SELECT min(ss.ATV) FROM interfaces..rxnsat_full ss
		WHERE ss.RXCUI = c.RXCUI AND ss.ATN = 'SRC')
FROM interfaces..rxnconso_FULL c
WHERE c.RXCUI IN (SELECT brand_name_rxcui 
				FROM c_Drug_Brand_Ingredient
				GROUP BY brand_name_rxcui
				HAVING COUNT(*) > 1)
AND c.tty = 'BN' AND c.SAB = 'RXNORM'
AND c.RXCUI IN ('' -- 
)
ORDER BY c.[str]
-- 1286

INSERT INTO c_Drug_Generic_Ingredient (generic_rxcui, generic_rxcui_ingredient) 
SELECT c1.RXCUI, c.RXCUI
FROM interfaces..rxnconso_FULL c
JOIN interfaces..rxnrel r ON r.RXCUI2 = c.RXCUI
JOIN interfaces..rxnconso_FULL c1 ON c1.RXCUI = r.RXCUI1
WHERE r.rela = 'part_of'
AND c.SAB = 'RXNORM'
AND c1.SAB = 'RXNORM'
AND c1.TTY = 'MIN' -- Multiple ingredient generics
and c.TTY IN ('IN','PIN')
AND c.SUPPRESS = 'N'
AND c.RXCUI IN ('2592' -- Clofazimine
)
-- 3677

-- Single ingredient brand names generic equivalent
UPDATE b
	SET generic_rxcui = bi.generic_rxcui_ingredient
	FROM c_Drug_Brand b
	JOIN c_Drug_Brand_Ingredient bi ON b.brand_name_rxcui = bi.brand_name_rxcui
	WHERE is_single_ingredient = 'Y'
-- 3104

-- Fill in the 2 that don't fit in 900 chars so won't match in build_generic_equivalents
UPDATE c_Drug_Brand SET generic_rxcui = '1008785' WHERE brand_name_rxcui = '287523'
UPDATE c_Drug_Brand SET generic_rxcui = '1008803' WHERE brand_name_rxcui = '901641'

EXEC build_generic_equivalents

-- Not listed as MIN multiple-ingredient generic equivalent in RXNORM
-- Maybe having to do with relating to both IN and PIN?
-- 84815	Adderall
-- 1927611	Mydayis

-- Update to Tall Man synonym where available
UPDATE g
SET generic_name = [STR]
FROM c_Drug_Generic g
JOIN interfaces..rxnconso_FULL c ON c.RXCUI = g.generic_rxcui AND c.TTY = 'TMSY'
WHERE generic_rxcui IN ('2592' -- Clofazimine
)
-- 322

UPDATE b
SET brand_name = [STR] 
FROM c_Drug_Brand b
JOIN interfaces..rxnconso_FULL c ON c.RXCUI = b.brand_name_rxcui AND c.TTY = 'TMSY'
-- 38

UPDATE b
SET dea_class = a2.ATV
from interfaces.dbo.RXNCONSO_FULL c3
join interfaces.dbo.RXNSAT a2 ON a2.RXCUI = c3.RXCUI
join interfaces.dbo.RXNREL r2 ON r2.RXCUI2 = c3.RXCUI
join interfaces.dbo.RXNCONSO_FULL c2 ON r2.RXCUI1 = c2.RXCUI
join c_Drug_Brand b on b.brand_name_rxcui = c2.rxcui
where a2.SAB = 'MTHSPL' and a2.ATN = 'DCSA' 
and c3.SAB = 'RXNORM' and c3.TTY IN ('SBD')
and r2.SAB = 'RXNORM' 
and c2.SAB = 'RXNORM'
and c2.TTY IN ('BN') 
-- 182

UPDATE g
SET dea_class = a2.ATV
from interfaces.dbo.RXNCONSO_FULL c3
join interfaces.dbo.RXNSAT a2 ON a2.RXCUI = c3.RXCUI
join interfaces.dbo.RXNREL r2 ON r2.RXCUI2 = c3.RXCUI
join interfaces.dbo.RXNCONSO_FULL c2 ON r2.RXCUI1 = c2.RXCUI
join c_Drug_Generic g on g.generic_rxcui = c2.rxcui
where a2.SAB = 'MTHSPL' and a2.ATN = 'DCSA' 
and c3.SAB = 'RXNORM' and c3.TTY IN ('SCD')
and r2.SAB = 'RXNORM' 
and c2.SAB = 'RXNORM'
and c2.TTY IN ('MIN') 
-- 44

-- UPDATE c_Drug_Brand set drug_id = NULL where drug_id is not null
-- UPDATE c_Drug_Generic set drug_id = NULL where drug_id is not null

-- Now, relate these to the existing drug structure

-- Eliminate obsoleted brands per RXNORM
UPDATE d
SET d.drug_type = 'OBSOLETE', status = 'OBS'
FROM interfaces..rxnconso_FULL c
JOIN c_Drug_Definition d on d.common_name = c.[STR] 
WHERE c.tty = 'BN'
AND c.SAB = 'RXNORM'
AND c.SUPPRESS = 'O'
-- 453

-- Update existing generic_name to match where brand name matches (capture TMSY)
UPDATE c_Drug_Definition
SET generic_name = CASE WHEN LEN(g.generic_name) <= 500 THEN g.generic_name ELSE left(g.generic_name,497) + '...' END
FROM c_Drug_Definition dd
JOIN c_Drug_Brand b ON b.brand_name = dd.common_name
JOIN c_Drug_Generic g ON g.generic_rxcui = b.generic_rxcui
WHERE dd.status = 'OK'
-- 728

-- Update existing generic_name to match where generic name matches (capture TMSY)
UPDATE c_Drug_Definition
SET generic_name = CASE WHEN LEN(g.generic_name) <= 500 THEN g.generic_name ELSE left(g.generic_name,497) + '...' END
FROM c_Drug_Definition dd
JOIN c_Drug_Generic g ON g.generic_name = dd.generic_name
WHERE dd.status = 'OK'
-- 1126

-- Exact generic_name matches to existing table
UPDATE b 
SET drug_id = dd.drug_id
FROM c_Drug_Definition dd
JOIN c_Drug_Brand b ON b.brand_name = dd.common_name
JOIN c_Drug_Generic g ON g.generic_rxcui = b.generic_rxcui
WHERE b.drug_id is null
AND dd.status = 'OK'
AND dd.generic_name = g.generic_name
-- 728

UPDATE g
SET drug_id = dd.drug_id
FROM c_Drug_Definition dd
JOIN c_Drug_Generic g ON g.generic_name = dd.generic_name
WHERE g.drug_id IS NULL
AND dd.common_name = dd.generic_name
AND dd.status = 'OK'
-- 225

UPDATE c_Drug_Generic 
SET drug_id = 'RXNG' + generic_rxcui
WHERE drug_id IS NULL
-- 7883

UPDATE c_Drug_Brand
SET drug_id = 'RXNB' + brand_name_rxcui
WHERE drug_id IS NULL
-- 3662

/*
SET PATH_TO_BCP="C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\bcp.exe"
SET MSSQLSERVER=DESKTOP-GU15HUD\ENCOUNTERPRO

%PATH_TO_BCP% c_Drug_Brand out c_Drug_Brand.txt -S %MSSQLSERVER% -d EncounterPro_OS -T -c
%PATH_TO_BCP% c_Drug_Brand_Ingredient out c_Drug_Brand_Ingredient.txt -S %MSSQLSERVER% -d EncounterPro_OS -T -c
%PATH_TO_BCP% c_Drug_Generic out c_Drug_Generic.txt -S %MSSQLSERVER% -d EncounterPro_OS -T -c
%PATH_TO_BCP% c_Drug_Generic_Ingredient out c_Drug_Generic_Ingredient.txt -S %MSSQLSERVER% -d EncounterPro_OS -T -c

*/


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


