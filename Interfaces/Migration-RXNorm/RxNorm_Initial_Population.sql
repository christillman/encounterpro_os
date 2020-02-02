-- Start with SCDs and SBDs
-- Populate c_Drug_Formulation, c_Drug_Pack, and c_Drug_Pack_Formulation tables 
-- (scripts GenericFormulations and BrandFormulations)
-- Then derive c_Drug_Generic, c_Drug_Brand and c_Drug_Generic_Ingredient tables from those
-- The assumption is that the 4000 or so generic ingredients in RXNORM
-- which don't relate to any SCD are not prescribable.
/*
select left(form_tty,3), ingr_tty, count(distinct ingr_rxcui) 
from [c_Drug_Formulation]
group by left(form_tty,3), ingr_tty
*/
-- 2442 unique generic IN rxcuis
-- 1167 MIN rxcuis
-- 4390 unique BN rxcuis

DELETE FROM c_Drug_Generic
DELETE FROM c_Drug_Generic_Ingredient

-- All generic formulation ingredients (related to SCDs)
INSERT INTO c_Drug_Generic (generic_name, 
				generic_rxcui, 
				is_single_ingredient, 
				mesh_definition,
				scope_note,
				mesh_source)
SELECT [str], c.RXCUI, 
	CASE WHEN c.TTY = 'IN' THEN 1 ELSE 0 END, 
	(SELECT min(sd.ATV) FROM interfaces..rxnsat_full sd
		WHERE sd.RXCUI = c.RXCUI AND sd.ATN = 'MESH_DEFINITION'),
	(SELECT min(sn.ATV) FROM interfaces..rxnsat_full sn
		WHERE sn.RXCUI = c.RXCUI AND sn.ATN = 'SOS'),
	(SELECT min(ss.ATV) FROM interfaces..rxnsat_full ss
		WHERE ss.RXCUI = c.RXCUI AND ss.ATN = 'SRC')
FROM interfaces..rxnconso c
WHERE c.RXCUI IN (SELECT ingr_rxcui 
				FROM [c_Drug_Formulation] 
				WHERE form_tty LIKE 'SCD%')
AND c.SAB = 'RXNORM'
AND c.tty IN ('IN','MIN')
AND c.SUPPRESS = 'N'
-- 3609


-- c_Drug_Generic_Ingredient lists the separate ingredients for MINs
INSERT INTO c_Drug_Generic_Ingredient (
	generic_rxcui,
	generic_rxcui_ingredient,
	ingredient_name)
SELECT c1.rxcui, 
	c.rxcui,
	c.[str] 
FROM interfaces..rxnconso c
JOIN interfaces..rxnrel r ON r.RXCUI2 = c.RXCUI
JOIN interfaces..rxnconso c1 ON c1.rxcui = r.rxcui1
WHERE c1.RXCUI IN (SELECT ingr_rxcui 
				FROM [c_Drug_Formulation] 
				WHERE ingr_tty = 'MIN' 
				AND form_tty LIKE 'SCD%')
AND c.TTY = 'IN'
AND c.SAB = 'RXNORM'
AND r.rela = 'part_of'
AND c1.TTY = 'MIN'
AND c1.SAB = 'RXNORM' 
-- (3604 row(s) affected)


DELETE FROM c_Drug_Brand

-- All brand formulation ingredients (related to SBDs)
INSERT INTO c_Drug_Brand (
				brand_name, 
				brand_name_rxcui, 
				is_single_ingredient,
				scope_note,
				mesh_source)
SELECT c1.[str], c1.RXCUI, 
	0, 
	(SELECT min(sn.ATV) FROM interfaces..rxnsat_full sn
		WHERE sn.RXCUI = c1.RXCUI AND sn.ATN = 'SOS'),
	(SELECT min(ss.ATV) FROM interfaces..rxnsat_full ss
		WHERE ss.RXCUI = c1.RXCUI AND ss.ATN = 'SRC') 
FROM interfaces..rxnconso c
JOIN interfaces..rxnrel r ON r.RXCUI2 = c.RXCUI
JOIN interfaces..rxnconso c1 ON c1.rxcui = r.rxcui1
WHERE c.RXCUI IN (SELECT form_rxcui 
				FROM [c_Drug_Formulation]
				WHERE form_tty LIKE 'SBD%')
AND c.SAB = 'RXNORM'
AND c.tty = 'SBD'
AND c.SUPPRESS = 'N'
AND r.rela = 'has_ingredient'
AND c1.TTY = 'BN'
AND c1.SAB = 'RXNORM' 
GROUP BY c1.[str], c1.RXCUI
-- 4390

-- All 8085 SBDs have a related SCD generic equivalent
-- There are 12649 SCDs, 4600 or so which have no branded equivalent.
SELECT r.RXCUI2 as rxcui_sbd, r.RXCUI1 as rxcui_scd
INTO #brand_forms
FROM interfaces..rxnconso c
JOIN interfaces..rxnrel r ON r.RXCUI2 = c.RXCUI
JOIN interfaces..rxnconso c1 ON c1.rxcui = r.rxcui1
WHERE c.TTY IN ('SBD')
AND c.SAB = 'RXNORM'
AND c1.TTY IN ('SCD')
AND c1.SAB = 'RXNORM'
AND r.rela = 'tradename_of'
AND c.SUPPRESS = 'N'
AND c1.SUPPRESS = 'N'

-- We want to record the generic equivalent ingredients related
-- to each BN so we can search for generics and brands together.
-- Generic ingredients come in 3 flavors: IN, PIN, and 
-- MIN (which in turn decomposes into IN / PINs)
-- Usually we want to work at the MIN/IN level, searching for 
-- specific drug combinations.

-- c_Drug_Definition should have rows for all MINs and INs, 
-- with associated "common_name" for the brand name equivalents.
-- (In addition, it also contains non-RXNORM drugs). It does
-- not include dose forms, strengths, or multi-drug packs.

UPDATE b
SET generic_rxcui = g.generic_rxcui
FROM #brand_forms c
JOIN c_Drug_Formulation_Ingredient fig ON fig.form_rxcui = c.rxcui_scd
JOIN c_Drug_Generic g ON g.generic_rxcui = fig.ingr_rxcui
JOIN c_Drug_Formulation_Ingredient fib ON fib.form_rxcui = c.rxcui_sbd
JOIN c_Drug_Brand b ON b.brand_name_rxcui = fib.ingr_rxcui
-- (4390 row(s) affected)

UPDATE b
SET dea_class = a2.ATV
from interfaces.dbo.RXNCONSO c3
join interfaces.dbo.RXNSAT a2 ON a2.RXCUI = c3.RXCUI
join interfaces.dbo.RXNREL r2 ON r2.RXCUI2 = c3.RXCUI
join interfaces.dbo.RXNCONSO c2 ON r2.RXCUI1 = c2.RXCUI
join c_Drug_Brand b on b.brand_name_rxcui = c2.rxcui
where a2.SAB = 'MTHSPL' and a2.ATN = 'DCSA' 
and c3.SAB = 'RXNORM' and c3.TTY IN ('SBD')
and r2.SAB = 'RXNORM' 
and c2.SAB = 'RXNORM'
and c2.TTY IN ('BN') 
-- 182

UPDATE g
SET dea_class = a2.ATV
from interfaces.dbo.RXNCONSO c3
join interfaces.dbo.RXNSAT a2 ON a2.RXCUI = c3.RXCUI
join interfaces.dbo.RXNREL r2 ON r2.RXCUI2 = c3.RXCUI
join interfaces.dbo.RXNCONSO c2 ON r2.RXCUI1 = c2.RXCUI
join c_Drug_Generic g on g.generic_rxcui = c2.rxcui
where a2.SAB = 'MTHSPL' and a2.ATN = 'DCSA' 
and c3.SAB = 'RXNORM' and c3.TTY IN ('SCD')
and r2.SAB = 'RXNORM' 
and c2.SAB = 'RXNORM'
and c2.TTY IN ('MIN') 
-- 44

-- Results
/*
SELECT f.tty, f.descr, fi.form_rxcui, ingr_rxcui, ingr_tty, ingr_descr
FROM c_Drug_Formulation f 
LEFT JOIN c_Drug_Formulation_Ingredient fi ON fi.form_rxcui = f.rxcui
WHERE fi.form_rxcui is not null
UNION ALL
SELECT f.tty, f.descr, fi.pack_rxcui, form_rxcui, form_tty, form_descr
FROM c_Drug_Pack f 
LEFT JOIN c_Drug_Pack_Formulation fi ON fi.form_rxcui = f.rxcui
WHERE fi.form_rxcui is not null
ORDER BY form_rxcui, ingr_tty, ingr_rxcui
-- 20734
*/
/*
cd C:\attachments
SET PATH_TO_BCP="C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\bcp.exe"
SET MSSQLSERVER=DESKTOP-GU15HUD\ENCOUNTERPRO

%PATH_TO_BCP% c_Drug_Brand out c_Drug_Brand.txt -S %MSSQLSERVER% -d EncounterPro_OS -T -c
%PATH_TO_BCP% c_Drug_Generic out c_Drug_Generic.txt -S %MSSQLSERVER% -d EncounterPro_OS -T -c
%PATH_TO_BCP% c_Drug_Generic_Ingredient out c_Drug_Generic_Ingredient.txt -S %MSSQLSERVER% -d EncounterPro_OS -T -c
%PATH_TO_BCP% c_Drug_Formulation out c_Drug_Formulation.txt -S %MSSQLSERVER% -d EncounterPro_OS -T -c
%PATH_TO_BCP% c_Drug_Pack out c_Drug_Pack.txt -S %MSSQLSERVER% -d EncounterPro_OS -T -c
%PATH_TO_BCP% c_Drug_Pack_Formulation out c_Drug_Pack_Formulation.txt -S %MSSQLSERVER% -d EncounterPro_OS -T -c

*/
