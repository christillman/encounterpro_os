-- Add Generics

-- We want to list all SCDs in c_Drug_Formulation.
-- But we want to prefer PSNs to the RXNORM normalized forms

-- GPCK will go in c_Drug_Pack similarly
-- Selection lists will include all formulations with a selected drug,
-- and all packs which include those formulations

-- Tall man updates will take place later

DELETE FROM c_Drug_Formulation WHERE form_tty NOT LIKE '%B%'

-- Intermediate table for SCDC
SELECT c.rxcui as rxcui_scdc, 
	c1.rxcui as rxcui_scd, 
	'SCDC' AS TTY, 
	rtrim(CASE WHEN LEN(c.[str]) <= 1000 THEN c.[str] ELSE left(c.[str],997) + '...' END) as str_min
INTO #SCDC
FROM interfaces..rxnconso c
JOIN interfaces..rxnrel r ON r.RXCUI2 = c.RXCUI
JOIN interfaces..rxnconso c1 ON c1.rxcui = r.rxcui1
WHERE c.TTY = 'SCDC'
AND c.SAB = 'RXNORM'
AND r.rela = 'constitutes'
AND c1.TTY = 'SCD'
AND c1.SAB = 'RXNORM'
-- (18022 row(s) affected)

INSERT INTO c_Drug_Formulation (
	form_rxcui, 
	form_tty, 
	form_descr,
	ingr_rxcui,
	ingr_tty
	)
SELECT c1.rxcui, 
	c1.tty + '_' + c3.tty, 
	c3.[str],
	c.rxcui,
	'MIN' AS TTY
FROM interfaces..rxnconso c
JOIN interfaces..rxnrel r ON r.RXCUI2 = c.RXCUI
JOIN interfaces..rxnconso c1 ON c1.rxcui = r.rxcui1
JOIN interfaces..rxnconso c3 
	ON c3.rxcui = c1.rxcui and c3.tty = 'PSN'
WHERE c.TTY = 'MIN'
AND c.SAB = 'RXNORM'
AND r.rela = 'ingredients_of'
AND c1.TTY = 'SCD'
AND c1.SAB = 'RXNORM' 
AND c3.SAB = 'RXNORM' 
AND NOT EXISTS (SELECT 1 FROM c_Drug_Formulation f
	WHERE f.form_rxcui = c1.rxcui)
-- 2699

INSERT INTO c_Drug_Formulation (
	form_rxcui, 
	form_tty, 
	form_descr,
	ingr_rxcui,
	ingr_tty
	)
SELECT c1.rxcui, 
	c1.tty, 
	rtrim(CASE WHEN LEN(c1.[str]) <= 1000 THEN c1.[str] ELSE left(c1.[str],997) + '...' END) as str_scd,
	c.rxcui,
	'MIN' AS TTY
FROM interfaces..rxnconso c
JOIN interfaces..rxnrel r ON r.RXCUI2 = c.RXCUI
JOIN interfaces..rxnconso c1 ON c1.rxcui = r.rxcui1
WHERE c.TTY = 'MIN'
AND c.SAB = 'RXNORM'
AND r.rela = 'ingredients_of'
AND c1.TTY = 'SCD'
AND c1.SAB = 'RXNORM'
AND NOT EXISTS (SELECT 1 FROM c_Drug_Formulation f
	WHERE f.form_rxcui = c1.rxcui)
-- 184

-- single-ingredient SCDs
INSERT INTO c_Drug_Formulation (
	form_rxcui, 
	form_tty, 
	form_descr,
	ingr_rxcui,
	ingr_tty
	)
SELECT 
	#SCDC.rxcui_scd, 
	'SCD_PSN', 
	c3.[str],
	c.rxcui, 
	'IN' AS TTY
FROM interfaces..rxnconso c
JOIN interfaces..rxnrel r ON r.RXCUI2 = c.RXCUI
JOIN interfaces..rxnconso c1 ON c1.rxcui = r.rxcui1
JOIN #SCDC ON #SCDC.rxcui_scdc = c1.rxcui
JOIN interfaces..rxnconso c3 ON c3.rxcui = #SCDC.rxcui_scd
WHERE c.TTY = 'IN'
AND c.SAB = 'RXNORM'
AND r.rela = 'ingredient_of'
AND c1.TTY = 'SCDC'
AND c1.SAB = 'RXNORM' 
AND c3.TTY = 'PSN'
AND c3.SAB = 'RXNORM' 
-- INs duplicate MINs, so avoid any for the same form_rxcui
AND NOT EXISTS (SELECT 1 FROM c_Drug_Formulation f
	WHERE f.form_rxcui = #SCDC.rxcui_scd)
	/*
order by c.rxcui, 
	#SCDC.rxcui_scd
	*/
-- (9564 row(s) affected)

INSERT INTO c_Drug_Formulation (
	form_rxcui, 
	form_tty, 
	form_descr,
	ingr_rxcui,
	ingr_tty
	)
SELECT 
	#SCDC.rxcui_scd, 
	'SCD', 
	c3.[str],
	c.rxcui, 
	'IN' AS TTY
FROM interfaces..rxnconso c
JOIN interfaces..rxnrel r ON r.RXCUI2 = c.RXCUI
JOIN interfaces..rxnconso c1 ON c1.rxcui = r.rxcui1
JOIN #SCDC ON #SCDC.rxcui_scdc = c1.rxcui
JOIN interfaces..rxnconso c3 ON c3.rxcui = #SCDC.rxcui_scd
WHERE c.TTY = 'IN'
AND c.SAB = 'RXNORM'
AND r.rela = 'ingredient_of'
AND c1.TTY = 'SCDC'
AND c1.SAB = 'RXNORM' 
AND c3.TTY = 'SCD'
AND c3.SAB = 'RXNORM' 
-- INs duplicate MINs, so avoid any for the same form_rxcui
AND NOT EXISTS (SELECT 1 FROM c_Drug_Formulation f
	WHERE f.form_rxcui = #SCDC.rxcui_scd)
-- (202 row(s) affected)

/*
-- These are in RXNCONSO as ingredients, but their single-ingredient
-- SCDs are missing from RXNCONSO ... they are in RXNCONSO_FULL (CVF='')

select distinct c.rxcui,c.[STR] 
FROM interfaces..rxnconso_full c
JOIN interfaces..rxnrel_full r ON r.RXCUI2 = c.RXCUI
JOIN interfaces..rxnconso_full c1 ON c1.rxcui = r.rxcui1
WHERE NOT EXISTS (SELECT 1 FROM c_Drug_Formulation f
	WHERE f.form_rxcui = #SCDC.rxcui_scd)
AND c.TTY = 'IN'
AND c.SAB = 'RXNORM'
AND r.rela = 'ingredient_of'
AND c1.TTY = 'SCDC'
AND c1.SAB = 'RXNORM' 
AND c1.SUPPRESS ='N'
AND c.RXCUI IN (
'228656',
'153971',
'18516',
'203220',
'142429',
'35255',
'2714',
'3538',
'42634',
'48933',
'267257',
'266856',
'71722',
'23663',
'82012',
'4056',
'24351',
'142436',
'10207',
'5033',
'203212',
'28004',
'287734',
'30236',
'34372',
'8985',
'35220',
'9069',
'9075',
'10180',
'835827',
'11118')
order by c.rxcui

--these are in _full (pick up?)
10180	Sulfamethoxazole
10207	Sulfisoxazole
18516	attapulgite
228656	Amprenavir
2714	Collagen
35255	Cisapride
5033	Guanabenz
*/


DELETE FROM c_Drug_Pack

-- GPCK
INSERT INTO c_Drug_Pack (rxcui, tty, descr)
SELECT c1.rxcui, c1.tty + '_' + c3.tty, c3.[str]
FROM interfaces..rxnconso c1
JOIN interfaces..rxnconso c3 
	ON c3.rxcui = c1.rxcui and c3.tty = 'PSN'
where c1.tty = 'GPCK'
-- 270

INSERT INTO c_Drug_Pack (rxcui, tty, descr)
SELECT c1.rxcui, c1.tty, c1.[str]
FROM interfaces..rxnconso c1
where c1.tty = 'GPCK'
AND NOT EXISTS (SELECT 1 FROM c_Drug_Pack f
	WHERE f.rxcui = c1.rxcui)
-- 21

DELETE FROM c_Drug_Pack_Formulation

-- GPCK Formulations
INSERT INTO c_Drug_Pack_Formulation (
	form_rxcui,
	pack_rxcui,
	form_tty,
	form_descr
	)
SELECT c.rxcui as rxcui_scd, 
	c1.rxcui as rxcui_gpck, 
	'GPCK_PSN' AS TTY, 
	rtrim(c.[str]) as str_scd
FROM interfaces..rxnconso c
JOIN interfaces..rxnrel r ON r.RXCUI2 = c.RXCUI
JOIN interfaces..rxnconso c1 ON c1.rxcui = r.rxcui1
WHERE c.TTY = 'PSN'
AND c.SAB = 'RXNORM'
AND r.rela = 'contained_in'
AND c1.TTY = 'GPCK'
AND c1.SAB = 'RXNORM'
order by c.rxcui, 
	c1.rxcui,  
	rtrim(c.[str])
-- (541 row(s) affected)

INSERT INTO c_Drug_Pack_Formulation (
	form_rxcui,
	pack_rxcui,
	form_tty,
	form_descr
	)
SELECT c.rxcui as rxcui_scd, 
	c1.rxcui as rxcui_gpck, 
	'GPCK_SCD' AS TTY, 
	rtrim(c.[str]) as str_scd
FROM interfaces..rxnconso c
JOIN interfaces..rxnrel r ON r.RXCUI2 = c.RXCUI
JOIN interfaces..rxnconso c1 ON c1.rxcui = r.rxcui1
WHERE c.TTY = 'SCD'
AND c.SAB = 'RXNORM'
AND r.rela = 'contained_in'
AND c1.TTY = 'GPCK'
AND c1.SAB = 'RXNORM'
AND NOT EXISTS (SELECT 1 FROM c_Drug_Pack_Formulation f
	WHERE f.pack_rxcui = c1.rxcui)
order by c.rxcui, 
	c1.rxcui,  
	rtrim(c.[str])
-- 2

-- Export to text files
-- See DDL-207/20 c_Drug_RXNORM

/*
SET PATH_TO_BCP="C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\bcp.exe"
SET MSSQLSERVER=DESKTOP-GU15HUD\ENCOUNTERPRO

%PATH_TO_BCP% c_Drug_Formulation out c_Drug_Formulation.txt -S %MSSQLSERVER% -d EncounterPro_OS -T -c
%PATH_TO_BCP% c_Drug_Pack out c_Drug_Pack.txt -S %MSSQLSERVER% -d EncounterPro_OS -T -c
%PATH_TO_BCP% c_Drug_Pack_Formulation out c_Drug_Pack_Formulation.txt -S %MSSQLSERVER% -d EncounterPro_OS -T -c

*/

-- See DML-207/20 c_Drug_Formulation Generic