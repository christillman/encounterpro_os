-- Add Brand names

-- We want to list all SBDs in c_Drug_Formulation.
-- But we want to prefer PSNs to the RXNORM normalized forms

-- BPCK will go in c_Drug_Pack similarly
-- Selection lists will include all formulations with a selected drug,
-- and all packs which include those formulations

-- Tall man updates will take place later
DELETE FROM c_Drug_Formulation where form_tty LIKE '%B%'

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
	CASE WHEN LEN(c3.[str]) <= 1000 THEN c3.[str] ELSE left(c3.[str],997) + '...' END,
	c.rxcui,
	'BN' AS TTY
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
-- 8002

-- non-PSN SBDs
INSERT INTO c_Drug_Formulation (
	form_rxcui, 
	form_tty, 
	form_descr,
	ingr_rxcui,
	ingr_tty
	)
SELECT c1.rxcui, 
	c1.tty, 
	CASE WHEN LEN(c1.[str]) <= 1000 THEN c1.[str] ELSE left(c1.[str],997) + '...' END,
	c.rxcui,
	'BN' AS TTY
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
-- (83 row(s) affected)


-- BPCK
INSERT INTO c_Drug_Pack (rxcui, tty, descr)
SELECT c1.rxcui, c1.tty + '_' + c3.tty, c3.[str]
FROM interfaces..rxnconso c1
JOIN interfaces..rxnconso c3 
	ON c3.rxcui = c1.rxcui and c3.tty = 'PSN'
WHERE c1.tty = 'BPCK'
AND NOT EXISTS (SELECT 1 FROM c_Drug_Pack f
	WHERE f.rxcui = c1.rxcui)
-- 415

INSERT INTO c_Drug_Pack (rxcui, tty, descr)
SELECT c1.rxcui, c1.tty, c1.[str]
FROM interfaces..rxnconso c1
where c1.tty = 'BPCK'
AND NOT EXISTS (SELECT 1 FROM c_Drug_Pack f
	WHERE f.rxcui = c1.rxcui)
-- 4

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
-- (842 row(s) affected)

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
-- 1