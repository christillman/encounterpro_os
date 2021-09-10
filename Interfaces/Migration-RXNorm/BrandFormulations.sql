-- Add Brand names

-- We want to list all SBDs in c_Drug_Formulation.
-- But we want to prefer PSNs to the RXNORM normalized forms

-- BPCK will go in c_Drug_Pack similarly
-- Selection lists will include all formulations with a selected drug,
-- and all packs which include those formulations

-- Tall man updates will take place later
SELECT * INTO Form_Brand
FROM c_Drug_Formulation 
WHERE form_tty IN ('SBD','SBD_PSN')

DELETE FROM c_Drug_Formulation WHERE form_tty IN ('SBD','SBD_PSN')
-- (8084 rows affected)

-- All 8085 SBDs have a related SCD generic equivalent
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
-- (7608 rows affected)

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
-- (15966 row(s) affected)

INSERT INTO c_Drug_Formulation (
	form_rxcui, 
	form_tty, 
	form_descr,
	ingr_rxcui,
	ingr_tty,
	valid_in,
	generic_form_rxcui
	)
SELECT c1.rxcui, 
	c1.tty + '_' + c3.tty, 
	CASE WHEN LEN(c3.[str]) <= 1000 THEN c3.[str] ELSE left(c3.[str],997) + '...' END,
	c.rxcui,
	'BN' AS TTY,
	'us;',
	bf.rxcui_scd
FROM interfaces..rxnconso c
JOIN interfaces..rxnrel r ON r.RXCUI2 = c.RXCUI
JOIN interfaces..rxnconso c1 ON c1.rxcui = r.RXCUI1
JOIN interfaces..rxnconso c3 
	ON c3.rxcui = c1.rxcui and c3.tty = 'PSN'
JOIN #brand_forms bf ON bf.rxcui_sbd = c1.rxcui
WHERE c.TTY = 'BN'
AND c.SAB = 'RXNORM'
AND r.rela = 'ingredient_of'
AND c1.TTY = 'SBD'
AND c1.SAB = 'RXNORM' 
AND c3.SAB = 'RXNORM' 
AND NOT EXISTS (SELECT 1 FROM c_Drug_Formulation f
	WHERE f.form_rxcui = c1.rxcui)
-- 7555

-- non-PSN SBDs
INSERT INTO c_Drug_Formulation (
	form_rxcui, 
	form_tty, 
	form_descr,
	ingr_rxcui,
	ingr_tty,
	valid_in,
	generic_form_rxcui
	)
SELECT c1.rxcui, 
	c1.tty, 
	CASE WHEN LEN(c1.[str]) <= 1000 THEN c1.[str] ELSE left(c1.[str],997) + '...' END,
	c.rxcui,
	'BN' AS TTY,
	'us;',
	bf.rxcui_scd
FROM interfaces..rxnconso c
JOIN interfaces..rxnrel r ON r.RXCUI2 = c.RXCUI
JOIN interfaces..rxnconso c1 ON c1.rxcui = r.RXCUI1
JOIN #brand_forms bf ON bf.rxcui_sbd = c1.rxcui
WHERE c.TTY = 'BN'
AND c.SAB = 'RXNORM'
AND r.rela = 'ingredient_of'
AND c1.TTY = 'SBD'
AND c1.SAB = 'RXNORM' 
AND NOT EXISTS (SELECT 1 FROM c_Drug_Formulation f
	WHERE f.form_rxcui = c1.rxcui)
-- (53 row(s) affected)

UPDATE f 
SET valid_in = saved.valid_in
-- select distinct f.valid_in, saved.valid_in
FROM c_Drug_Formulation f
JOIN Form_Brand saved ON saved.form_rxcui = f.form_rxcui
WHERE f.valid_in != saved.valid_in
-- (466 rows affected)

-- Re-insert obsolete ones which were used for Kenya
INSERT INTO c_Drug_Formulation (
	form_rxcui, 
	form_tty, 
	form_descr,
	ingr_rxcui,
	ingr_tty,
	valid_in,
	generic_form_rxcui
	)
SELECT saved.* 
FROM Form_Brand saved
LEFT JOIN c_Drug_Formulation f ON saved.form_rxcui = f.form_rxcui
WHERE f.form_rxcui IS NULL
AND saved.valid_in like '%ke;%'
-- 10

select count(*) from c_Drug_Brand where valid_in = 'us;'

INSERT INTO c_Drug_Brand (
		brand_name, 
		brand_name_rxcui, 
		generic_rxcui, 
		is_single_ingredient,
		scope_note,
		mesh_source,
		drug_id
      ,[valid_in])
SELECT c1.[str], c1.RXCUI, fg.ingr_rxcui,
	0, 
	(SELECT min(sn.ATV) FROM interfaces..rxnsat_full sn
		WHERE sn.RXCUI = c1.RXCUI AND sn.ATN = 'SOS'),
	(SELECT min(ss.ATV) FROM interfaces..rxnsat_full ss
		WHERE ss.RXCUI = c1.RXCUI AND ss.ATN = 'SRC'),
	'RXNB' + c1.RXCUI
	,'us;'
FROM interfaces..rxnconso c
JOIN interfaces..rxnrel r ON r.RXCUI2 = c.RXCUI
JOIN interfaces..rxnconso c1 ON c1.rxcui = r.rxcui1
JOIN #brand_forms bf ON bf.rxcui_sbd = c.rxcui
-- Must already have generics in place!!
JOIN [c_Drug_Formulation] fg ON fg.form_rxcui = bf.rxcui_scd
WHERE c.RXCUI IN (SELECT form_rxcui 
				FROM [c_Drug_Formulation]
				WHERE form_tty LIKE 'SBD%')
AND c.SAB = 'RXNORM'
AND c.tty = 'SBD'
AND c.SUPPRESS = 'N'
AND r.rela = 'has_ingredient'
AND c1.TTY = 'BN'
AND c1.SAB = 'RXNORM' 
AND NOT EXISTS (SELECT 1 FROM c_Drug_Brand b
	WHERE b.brand_name_rxcui = c1.RXCUI)
GROUP BY c1.[str], c1.RXCUI, fg.ingr_rxcui

UPDATE b
SET generic_rxcui = fg.ingr_rxcui
from c_Drug_Brand b 
join [c_Drug_Formulation] fb ON fb.ingr_rxcui = b.brand_name_rxcui
-- Must already have generics in place!!
JOIN [c_Drug_Formulation] fg ON fg.form_rxcui = fb.generic_form_rxcui
WHERE b.generic_rxcui IS NULL
-- (445 row(s) affected)

/*
select * from c_Drug_Brand_Related r
where source_brand_form_descr not like 'No Brand%'
and source_brand_form_descr not like '%{%'
and not exists( select 1 from c_Drug_Formulation f
	join c_Drug_Brand b on b.brand_name_rxcui = f.ingr_rxcui
	where r.brand_name_rxcui = b.brand_name_rxcui)
*/

DELETE FROM c_Drug_Pack WHERE tty IN ('BPCK','BPCK_PSN')
-- (498 rows affected)

DELETE FROM c_Drug_Pack_Formulation WHERE form_tty IN ('BPCK_SCD','BPCK_PSN')
-- (943 rows affected)

-- BPCK
INSERT INTO c_Drug_Pack (rxcui, tty, descr)
SELECT c1.rxcui, c1.tty + '_' + c3.tty, c3.[str]
FROM interfaces..rxnconso c1
JOIN interfaces..rxnconso c3 
	ON c3.rxcui = c1.rxcui and c3.tty = 'PSN'
WHERE c1.tty = 'BPCK'
AND NOT EXISTS (SELECT 1 FROM c_Drug_Pack f
	WHERE f.rxcui = c1.rxcui)
-- 498

INSERT INTO c_Drug_Pack (rxcui, tty, descr)
SELECT c1.rxcui, c1.tty + '_SBD', c1.[str]
FROM interfaces..rxnconso c1
where c1.tty = 'BPCK'
AND NOT EXISTS (SELECT 1 FROM c_Drug_Pack f
	WHERE f.rxcui = c1.rxcui)
-- 0

-- BPCK Formulations
INSERT INTO c_Drug_Pack_Formulation (
	form_rxcui,
	pack_rxcui,
	form_tty,
	form_descr
	)
SELECT c.rxcui as rxcui_bpck, 
	c1.rxcui as rxcui_bpck, 
	'BPCK_PSN' AS TTY, 
	rtrim(c.[str]) as str_bpck
FROM interfaces..rxnconso c
JOIN interfaces..rxnrel r ON r.RXCUI2 = c.RXCUI
JOIN interfaces..rxnconso c1 ON c1.rxcui = r.rxcui1
WHERE c.TTY = 'PSN'
AND c.SAB = 'RXNORM'
AND r.rela = 'contained_in'
AND c1.TTY = 'BPCK'
AND c1.SAB = 'RXNORM'
AND NOT EXISTS (SELECT 1 FROM c_Drug_Pack_Formulation f
	WHERE f.pack_rxcui = c1.rxcui)
order by c.rxcui, 
	c1.rxcui,  
	rtrim(c.[str])
-- (943 row(s) affected)

INSERT INTO c_Drug_Pack_Formulation (
	form_rxcui,
	pack_rxcui,
	form_tty,
	form_descr
	)
SELECT c.rxcui as rxcui_sbd, 
	c1.rxcui as rxcui_bpck, 
	'BPCK_SBD' AS TTY, 
	rtrim(c.[str]) as str_bpck
FROM interfaces..rxnconso c
JOIN interfaces..rxnrel r ON r.RXCUI2 = c.RXCUI
JOIN interfaces..rxnconso c1 ON c1.rxcui = r.rxcui1
WHERE c.TTY = 'SBD'
AND c.SAB = 'RXNORM'
AND r.rela = 'contained_in'
AND c1.TTY = 'BPCK'
AND c1.SAB = 'RXNORM'
AND NOT EXISTS (SELECT 1 FROM c_Drug_Pack_Formulation f
	WHERE f.pack_rxcui = c1.rxcui)
order by c.rxcui, 
	c1.rxcui,  
	rtrim(c.[str])
-- 0