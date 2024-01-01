
DELETE FROM [Kenya_Drugs]

-- Includes 2373 Kenya drugs from 09_18_2020 KenyaRetentionDrugsUpdate (cleaned)

BULK INSERT [Kenya_Drugs]
FROM '\\localhost\attachments\Kenya_Drugs.txt'
-- 

delete from c_Drug_Formulation where form_rxcui like 'KE%' or form_rxcui like 'Riv%'  
-- (2695 row(s) affected)
delete from c_Drug_Brand where brand_name_rxcui like 'KE%'
-- (1276 row(s) affected)
delete from c_Drug_Generic where generic_rxcui like 'KE%'
-- (146 row(s) affected)
delete from c_Drug_Pack where rxcui like 'KE%'
-- (44 row(s) affected)
delete from c_Drug_Addition

/* These go into Packs (contain { } */
-- Brand
INSERT INTO c_Drug_Pack (rxcui, descr, tty)
SELECT -- Handle cases where one retention number covers two drugs
	'KEB' + Retention_No,
	SBD_Version, 
	'BPCK_KE'
FROM Kenya_Drugs
WHERE SCD_PSN_Version LIKE '%{%'
OR SCD_PSN_Version LIKE '%GPCK%'
-- (25 row(s) affected)

-- Generic
INSERT INTO c_Drug_Pack (rxcui, descr, tty)
SELECT 
	'KEG' + Retention_No,
	SCD_PSN_Version, 
	'GPCK_KE'
FROM Kenya_Drugs
WHERE SCD_PSN_Version LIKE '%{%'
-- (23 row(s) affected)

-- Handle cases where one retention number covers two drug packs
INSERT INTO c_Drug_Pack (rxcui, descr, tty) VALUES ('KEG4558-GPCK-100','{ 100 (Salbutamol 200 MCG Inhalation Powder) } Pack','GPCK_KE') 	
INSERT INTO c_Drug_Pack (rxcui, descr, tty) VALUES ('KEG4558-GPCK-128','{ 128 (Salbutamol 200 MCG Inhalation Powder) } Pack','GPCK_KE')

UPDATE c_Drug_Pack
SET valid_in = 'ke;' 
WHERE rxcui like 'KE%'
-- (50 row(s) affected)

-- Now Brand formulations

-- Check for any more duplicate retention numbers 
/*
SELECT Retention_No FROM Kenya_Drugs 
WHERE Retention_No NOT IN ('00nobrandfound')
GROUP BY Retention_No HAVING COUNT(*) > 1
*/
INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty, valid_in) 
SELECT 'KEB' + Retention_No,
	SBD_Version,
	'SBD_KE', 'ke;' 
FROM Kenya_Drugs
WHERE SCD_PSN_Version NOT LIKE '%{%'
AND SCD_PSN_Version NOT LIKE '%GPCK%'
AND Retention_No NOT IN ('NO RXCUI', '00nobrandfound', 'No Retention No', 'Not in Retention List')
-- Exclude if brand name identical to generic
AND SBD_Version != SCD_PSN_Version 
-- Exclude where they would duplicate RXNORM ones
AND SBD_Version NOT IN (select form_descr from c_Drug_Formulation)
AND 'KEB' + Retention_No NOT IN (select form_rxcui from c_Drug_Formulation)
-- Exclude these which are substantially similar to RXNORM ones
AND SBD_Version NOT IN (
'Depo-MEDrol 40 MG/ML Injection', -- Depo-Medrol 40 MG in 1 ML Injection
'Depo-Provera 150 MG/ML Injection', -- Depo-Provera 150 MG in 1 ML Injection
'GlucoPHAGE XR 500 MG Extended Release Oral Tablet', -- Glucophage XR 500 MG 24HR Extended Release Oral Tablet
'GlucoPHAGE XR 750 MG Extended Release Oral Tablet', -- Glucophage XR 750 MG 24HR Extended Release Oral Tablet
'GlucoVANCE 2.5 MG / 500 MG MG Oral Tablet', -- glucovance 2.5 MG / 500 MG Oral Tablet
'GlucoVANCE 5 MG / 500 MG MG Oral Tablet', -- glucovance 5 MG / 500 MG Oral Tablet
'Isoptin SR 240 MG Sustained Release Oral Tablet', -- Isoptin SR 240 MG Extended Release Oral Tablet
'Mircera 120 MCG in 0.3 ML Solution for Injection in Pre-Filled Syringe', -- MIRCERA 120 MCG in 0.3 ML Prefilled Syringe
'Mircera 75 MCG in 0.3 ML Solution for Injection in Pre-Filled Syringe', -- MIRCERA 75 MCG in 0.3 ML Prefilled Syringe
'Mirena 52 MG Intrauterine Delivery System', -- Mirena 52 MG Intrauterine System
'Symbicort 160/4.5 Turbuhaler, 120 Doses', -- Symbicort 160/4.5 MCG/INHAL Metered Dose Inhaler, 120 Actuations
'Symbicort 160/4.5 Turbuhaler, 60 Doses', -- Symbicort 160/4.5 MCG/INHAL Metered Dose Inhaler, 60 Actuations
'Symbicort 80/4.5 Turbuhaler, 60 Doses', -- Symbicort 80/4.5 MCG/INHAL Metered Dose Inhaler, 60 Actuations
'Tegretol 100 MG in 5 ML Oral Syrup', -- TEGretol 100 MG in 5 mL Oral Suspension
'Zestril 10 MG Oral Tablet', -- Zestril 10 MG Oral Tablet, Once-Daily
'Zestril 20 MG Oral Tablet', -- Zestril 20 MG Oral Tablet, Once-Daily
'Zithromax 200 MG in 5 ML', -- Zithromax 200 MG in 5 mL Oral Suspension
'Zofran 2 MG/ML Injection', -- Zofran 2 MG/ML Injectable Solution
'Zyrtec 5 MG in 5 ML Syrup' -- ZyrTEC 5 MG in 5 mL Oral Solution
)
-- (2079 row(s) affected)

INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty, valid_in) 
SELECT MIN('KEG' + Retention_No),
	SCD_PSN_Version,
	'SCD_KE', 'ke;' 
FROM Kenya_Drugs
-- All the ones for which we got brands
WHERE ('KEB' + Retention_No IN (SELECT form_rxcui FROM c_Drug_Formulation)
	-- and those we had no brands for
	OR Retention_No IN ('NO RXCUI', '00nobrandfound')
	-- and those we avoided because they were generic names
	OR SBD_Version = SCD_PSN_Version 
	)
-- Exclude where they would duplicate RXNORM ones
AND SCD_PSN_Version NOT IN (select form_descr from c_Drug_Formulation)
AND NOT (left(Corresponding_RXCUI,4) IN ('SCD-','PSN-')
	AND substring(Corresponding_RXCUI,5,8) IN (select form_rxcui FROM c_Drug_Formulation)) 
AND 'KEG' + Retention_No NOT IN (select form_rxcui from c_Drug_Formulation)
GROUP BY SCD_PSN_Version
-- (118 row(s) affected)
 
-- These turn out to have " in " at the end of the brand name, get them first
SELECT MIN(REPLACE(form_rxcui,'KEB','KEBI')) AS brand_name_rxcui,
	left(form_descr,PATINDEX('% in [0-9]%', form_descr) - 1) AS brand_name,
	MIN(REPLACE(form_rxcui,'KEB','KEGI')) AS generic_rxcui,
	1 AS is_single_ingredient
INTO #Drug_Brand
FROM c_Drug_Formulation
WHERE PATINDEX('% in [0-9]%', form_descr) > 0
AND PATINDEX('% [0-9]%', form_descr) > 0
AND PATINDEX('% [0-9]%', form_descr) - PATINDEX('% in [0-9]%', form_descr) = 3
AND form_rxcui LIKE 'KEB%'
GROUP BY left(form_descr,PATINDEX('% in [0-9]%', form_descr) - 1)

UNION

-- PATINDEX errors unless satisfied
SELECT MIN(REPLACE(form_rxcui,'KEB','KEBI')),
	left(form_descr,PATINDEX('% [0-9]%', form_descr) - 1),
	MIN(REPLACE(form_rxcui,'KEB','KEGI')),
	1 -- select *
FROM c_Drug_Formulation 
WHERE form_rxcui LIKE 'KEB%' 
AND PATINDEX('% in [0-9]%', form_descr) = 0 
	and PATINDEX('% [0-9]%', form_descr) > 0
GROUP BY left(form_descr,PATINDEX('% [0-9]%', form_descr) - 1)

UNION

-- these have ' in ' but in a different place
SELECT MIN(REPLACE(form_rxcui,'KEB','KEBI')),
	left(form_descr,PATINDEX('% [0-9]%', form_descr) - 1),
	MIN(REPLACE(form_rxcui,'KEB','KEGI')),
	1 -- select *
FROM c_Drug_Formulation
WHERE form_rxcui LIKE 'KEB%'
AND PATINDEX('% in [0-9]%', form_descr) > 0 
	and PATINDEX('% [0-9]%', form_descr) > 0
	AND PATINDEX('% [0-9]%', form_descr) - PATINDEX('% in [0-9]%', form_descr) != 3
GROUP BY left(form_descr,PATINDEX('% [0-9]%', form_descr) - 1)

UNION

-- charindex errors unless satisfied
SELECT MIN(REPLACE(form_rxcui,'KEB','KEBI')),
	left(form_descr,charindex(' ', form_descr) - 1),
	MIN(REPLACE(form_rxcui,'KEB','KEGI')),
	1
FROM c_Drug_Formulation
WHERE form_rxcui LIKE 'KEB%' 
AND PATINDEX('% in [0-9]%', form_descr) = 0 
	and PATINDEX('% [0-9]%', form_descr) = 0 
	and charindex(' ', form_descr) > 0
GROUP BY left(form_descr,charindex(' ', form_descr) - 1)
ORDER BY 2
-- (1623 row(s) affected)

UPDATE #Drug_Brand 
SET brand_name = REPLACE(REPLACE(REPLACE(
	brand_name, 
	' Metered Dose Inhaler,',''),
	' Effervescent Granules',''),
	' Oral Suspension','')
WHERE brand_name LIKE '% Metered Dose Inhaler,%'
	OR brand_name LIKE '% Effervescent Granules%'
	OR brand_name LIKE '% Oral Suspension%'

-- Remove duplicates caused by same brand with and without suffixes e.g. CiproBay HC + Ciprobay 750 MG
INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, generic_rxcui, is_single_ingredient) 
SELECT MIN(brand_name_rxcui),
	brand_name,
	MIN(generic_rxcui),
	is_single_ingredient
FROM #Drug_Brand
WHERE brand_name NOT IN (SELECT brand_name FROM c_Drug_Brand)
GROUP BY brand_name, is_single_ingredient
-- (1496 row(s) affected)

UPDATE b
SET generic_rxcui = g.generic_rxcui -- select g.generic_rxcui, b.generic_rxcui 
FROM c_Drug_Brand b
JOIN Kenya_Drugs k ON k.Retention_No = substring(b.brand_name_rxcui,5,20)
	AND b.brand_name_rxcui LIKE 'KEBI%'
JOIN c_Drug_Formulation f ON f.form_rxcui = substring(k.Corresponding_RXCUI,5,20)
JOIN c_Drug_Generic g ON g.generic_rxcui = f.ingr_rxcui

UPDATE f
SET ingr_rxcui = b.brand_name_rxcui, 
	ingr_tty = 'BN' + CASE WHEN left(b.brand_name_rxcui,2) = 'KE' THEN '_KE' ELSE '' END
-- SELECT b.brand_name, b.brand_name_rxcui, f.form_descr, 'BN' + CASE WHEN left(b.brand_name_rxcui,2) = 'KE' THEN '_KE' ELSE '' END
FROM c_Drug_Brand b
JOIN c_Drug_Formulation f ON f.form_descr like brand_name + '%'
WHERE f.form_rxcui like 'KEB%'
AND f.ingr_rxcui IS NULL
AND NOT EXISTS (SELECT 1 FROM c_Drug_Brand b2
	JOIN c_Drug_Formulation f2 ON f2.form_descr like b2.brand_name + '%'
	WHERE f2.form_rxcui = f.form_rxcui 
	AND len(b2.brand_name) > len(b.brand_name)
	)
-- ORDER BY b.brand_name, b.brand_name_rxcui, f.form_descr
-- (2079 row(s) affected)

-- Match existing generics
UPDATE f
SET ingr_rxcui = g.generic_rxcui, 
	ingr_tty = 'IN' 
-- SELECT  f.form_rxcui, g.generic_name, f.form_descr, charindex(' / ',f.form_descr )
FROM c_Drug_Generic g
JOIN c_Drug_Formulation f ON f.form_descr like g.generic_name + ' %'
AND charindex(' / ',f.form_descr) = 0
WHERE f.form_rxcui like 'KEG%'
AND f.ingr_rxcui IS NULL
-- ORDER BY f.form_descr
-- (62 row(s) affected)


-- These turn out to have " in " at the end of the brand name, get them first
-- INSERT INTO c_Drug_Generic (generic_rxcui, generic_name, generic_rxcui, is_single_ingredient) 
SELECT MIN(REPLACE(form_rxcui,'KEG','KEGI')) AS generic_rxcui,
	left(form_descr,PATINDEX('% in [0-9]%', form_descr) - 1) AS generic_name,
	1 AS is_single_ingredient
INTO #Drug_Generic
FROM c_Drug_Formulation
WHERE form_rxcui LIKE 'KEG%'
AND PATINDEX('% in [0-9]%', form_descr) > 0
AND PATINDEX('% [0-9]%', form_descr) > 0
AND PATINDEX('% [0-9]%', form_descr) - PATINDEX('% in [0-9]%', form_descr) = 3
GROUP BY left(form_descr,PATINDEX('% in [0-9]%', form_descr) - 1)

UNION

-- PATINDEX errors unless satisfied
SELECT MIN(REPLACE(form_rxcui,'KEG','KEGI')),
	left(form_descr,PATINDEX('% [0-9]%', form_descr) - 1),
	1 -- select *
FROM c_Drug_Formulation 
WHERE form_rxcui LIKE 'KEG%' 
AND ingr_rxcui IS NULL
AND charindex(' / ',form_descr) = 0
AND PATINDEX('% in [0-9]%', form_descr) = 0 
	and PATINDEX('% [0-9]%', form_descr) > 0
GROUP BY left(form_descr,PATINDEX('% [0-9]%', form_descr) - 1)

UNION

-- these have ' in ' but in a different place
SELECT MIN(REPLACE(form_rxcui,'KEG','KEGI')),
	left(form_descr,PATINDEX('% [0-9]%', form_descr) - 1),
	1 -- select *
FROM c_Drug_Formulation
WHERE form_rxcui LIKE 'KEG%'
AND ingr_rxcui IS NULL
AND charindex(' / ',form_descr) = 0
AND PATINDEX('% in [0-9]%', form_descr) > 0 
	and PATINDEX('% [0-9]%', form_descr) > 0
	AND PATINDEX('% [0-9]%', form_descr) - PATINDEX('% in [0-9]%', form_descr) != 3
GROUP BY left(form_descr,PATINDEX('% [0-9]%', form_descr) - 1)

UNION

-- charindex errors unless satisfied
SELECT MIN(REPLACE(form_rxcui,'KEG','KEGI')),
	left(form_descr,charindex(' ', form_descr) - 1),
	1
FROM c_Drug_Formulation
WHERE form_rxcui LIKE 'KEG%' 
AND ingr_rxcui IS NULL
AND charindex(' / ',form_descr) = 0
AND PATINDEX('% in [0-9]%', form_descr) = 0 
	and PATINDEX('% [0-9]%', form_descr) = 0 
	and charindex(' ', form_descr) > 0
GROUP BY left(form_descr,charindex(' ', form_descr) - 1)
ORDER BY 2

-- insert remaining 'IN' 
-- Remove duplicates caused by same generic with and without suffixes 
INSERT INTO c_Drug_Generic (generic_rxcui, generic_name, is_single_ingredient) 
SELECT MIN(generic_rxcui),
	generic_name,
	is_single_ingredient
FROM #Drug_Generic
WHERE generic_name NOT IN (SELECT generic_name FROM c_Drug_Generic)
GROUP BY generic_name, is_single_ingredient
-- (28 row(s) affected)

UPDATE f
SET ingr_rxcui = g.generic_rxcui, 
	ingr_tty = 'IN' + '_KE'
-- SELECT  f.form_rxcui, g.generic_name, f.form_descr, charindex(' / ',f.form_descr )
FROM c_Drug_Generic g
JOIN c_Drug_Formulation f ON f.form_descr like g.generic_name + ' %'
AND charindex(' / ',f.form_descr) = 0
WHERE f.form_rxcui like 'KEG%'
AND f.ingr_rxcui IS NULL
-- ORDER BY f.form_descr
-- (38 row(s) affected)

/*
select * from c_Drug_Formulation WHERE form_RXCUI IN ('KEG11135','KEG11751','KEG11752','KEG11748','KEG11744'
,'KEG9598','KEG9591','KEG13712','KEG15791','KEG10752','KEG13094'
,'KEG2566','KEG1165','KEG10329','KEG1293','KEG1505','KEG1358',
	'KEG397','KEG12060','KEG15615','KEG11125','','KEG3551',
	'KEG8592','KEG2042','KEG2044','KEG7758B','KEG7758A','KEG7759','KEG7750','KEG475','KEG4898',
	'KEG5581','KEG16708','KEG515Eye','KEG15702Eye','KEG515','KEG6931','KEG11847',
	'KEG1260','KEG12698','KEG15203','KEG5759','KEG3504','KEG3506','KEG3501','KEG2315','KEG2318','KEG2286',
	'KEG1211','KEG1213','KEG7950','KEG10891')


select * from c_Drug_Formulation where ingr_rxcui is null
KEG1093
KEG11358
KEG13777
KEG1500
KEG2067
KEG2815
KEG4094A
KEG4285
KEG4945
KEG5392
KEG5858
*/

-- Multiple drug combinations matching those in c_Drug_Generic
/* UPDATE c_Drug_Formulation SET ingr_rxcui = '729455' WHERE form_RXCUI = 'KEG11135'
UPDATE c_Drug_Formulation SET ingr_rxcui = '1033889' 
WHERE form_RXCUI IN ('KEG11751','KEG11752','KEG11748','KEG11744')
UPDATE c_Drug_Formulation SET ingr_rxcui = '19711' 
WHERE form_RXCUI IN ('KEG9598','KEG9591','KEG13712','KEG15791','KEG10752','KEG13094')
UPDATE c_Drug_Formulation SET ingr_rxcui = '282448' 
WHERE form_RXCUI IN ('KEG2566','KEG1165','KEG10329','KEG1293','KEG1505','KEG1358',
	'KEG397','KEG12060','KEG15615','KEG11125','')
UPDATE c_Drug_Formulation SET ingr_rxcui = '214250' WHERE form_RXCUI = 'KEG3551' */
UPDATE c_Drug_Formulation SET ingr_rxcui = '389132'
WHERE form_RXCUI IN (/*'KEG8592','KEG2042','KEG2044',*/'KEG7758B','KEG7758A','KEG7759','KEG7750')
/* UPDATE c_Drug_Formulation SET ingr_rxcui = '608343' WHERE form_RXCUI IN ('KEG475','KEG4898')
UPDATE c_Drug_Formulation SET ingr_rxcui = '1007835' WHERE form_RXCUI = 'KEG5581'
UPDATE c_Drug_Formulation SET ingr_rxcui = '1545149' WHERE form_RXCUI = 'KEG16708'
UPDATE c_Drug_Formulation SET ingr_rxcui = '465397' 
WHERE form_RXCUI IN ('KEG515Eye','KEG15702Eye','KEG515')
UPDATE c_Drug_Formulation SET ingr_rxcui = '687144' WHERE form_RXCUI = 'KEG6931'
UPDATE c_Drug_Formulation SET ingr_rxcui = '214502' WHERE form_RXCUI = 'KEG11847'
UPDATE c_Drug_Formulation SET ingr_rxcui = '1009064' WHERE form_RXCUI = 'KEG1260'
UPDATE c_Drug_Formulation SET ingr_rxcui = '1430990' WHERE form_RXCUI = 'KEG12698'
UPDATE c_Drug_Formulation SET ingr_rxcui = '1001472' WHERE form_RXCUI = 'KEG15203'
UPDATE c_Drug_Formulation SET ingr_rxcui = '214536' WHERE form_RXCUI = 'KEG5759'
UPDATE c_Drug_Formulation SET ingr_rxcui = '284635' 
WHERE form_RXCUI IN ('KEG3504','KEG3506','KEG3501','KEG2315','KEG2318','KEG2286')
UPDATE c_Drug_Formulation SET ingr_rxcui = '816726' 
WHERE form_RXCUI IN ('KEG1211','KEG1213') */
UPDATE c_Drug_Formulation SET ingr_rxcui = '214671' 
WHERE form_RXCUI IN ('KEG7950') --,'KEG10891')
UPDATE c_Drug_Formulation SET ingr_rxcui = '214346' WHERE form_RXCUI = 'KEG11358'
UPDATE c_Drug_Formulation SET ingr_rxcui = '466482' WHERE form_RXCUI = 'KEG2067'

UPDATE f
SET ingr_tty = 'MIN' -- select *
FROM c_Drug_Formulation f
JOIN c_Drug_Generic g on g.generic_rxcui = f.ingr_rxcui
WHERE ingr_tty IS NULL
AND form_descr like '% / %'
AND f.ingr_rxcui NOT LIKE 'KEG%'

UPDATE b
SET generic_rxcui = g.generic_rxcui -- select k.SCD_PSN_Version, dbo.fn_ingredients(k.SCD_PSN_Version)
FROM c_Drug_Brand b
JOIN Kenya_Drugs k ON k.Retention_No = substring(b.brand_name_rxcui,5,20)
JOIN c_Drug_Generic g ON g.generic_name = dbo.fn_ingredients(k.SCD_PSN_Version)
WHERE brand_name_rxcui like 'KEB%'
AND NOT EXISTS (SELECT 1 FROM c_Drug_Generic g1
	WHERE g1.generic_rxcui = b.generic_rxcui)
-- (172 row(s) affected)

SELECT f.form_rxcui, g.generic_rxcui, CASE WHEN charindex(' / ',f.form_descr) > 0 THEN 'MIN' ELSE 'IN' END AS ingr_tty
INTO #to_update
FROM c_Drug_Formulation f 
JOIN c_Drug_Generic g ON g.generic_name = dbo.fn_ingredients(f.form_descr)
AND f.ingr_rxcui != g.generic_rxcui

UPDATE f
SET ingr_rxcui = u.generic_rxcui, 
	ingr_tty = u.ingr_tty
FROM c_Drug_Formulation f 
JOIN #to_update u ON u.form_rxcui = f.form_rxcui
-- (69 row(s) affected)

SELECT 'KEGI'+MIN(k.Retention_No) AS generic_rxcui, 
	dbo.fn_ingredients(k.SCD_PSN_Version) AS generic_name
INTO #new_generics
FROM c_Drug_Brand b
JOIN Kenya_Drugs k ON k.Retention_No = substring(b.brand_name_rxcui,5,20)
WHERE brand_name_rxcui like 'KEB%'
AND NOT EXISTS (SELECT 1 FROM c_Drug_Generic g1
	WHERE g1.generic_rxcui = b.generic_rxcui)
AND NOT EXISTS (SELECT 1 FROM c_Drug_Generic g2
	WHERE g2.generic_name = dbo.fn_ingredients(k.SCD_PSN_Version))
GROUP BY dbo.fn_ingredients(k.SCD_PSN_Version)
ORDER BY 1

-- function can't extract ingredients when the name starts with a digit
DELETE FROM #new_generics WHERE generic_name like '2%' or generic_name like '3%'
-- function doesn't handle "(equivalent to" very well
DELETE FROM #new_generics WHERE generic_name like '%(equi%'

INSERT INTO c_Drug_Generic (generic_rxcui, generic_name, [is_single_ingredient], drug_id)
SELECT generic_rxcui, 
	generic_name, 
	CASE WHEN charindex(' / ',generic_name) > 0 THEN 0 ELSE 1 END, 
	generic_rxcui
FROM #new_generics



/*
select * from c_Drug_Formulation WHERE form_rxcui IN ( 'KEG1235', 'KEG297','KEG5916','KEG1241', 'KEG282PF')
-- 5 insulin formulations not covered by above rules
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI1217' WHERE form_rxcui = 'KEG1235'
UPDATE c_Drug_Formulation SET ingr_rxcui = '139825' WHERE form_rxcui = 'KEG297'
UPDATE c_Drug_Formulation SET ingr_rxcui = '274783' WHERE form_rxcui = 'KEG5916'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI281' WHERE form_rxcui = 'KEG1241'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI281' WHERE form_rxcui = 'KEG282PF'
*/
/*
SELECT count(*) FROM c_Drug_Formulation d
WHERE 
	NOT EXISTS (SELECT drug_id 
		FROM c_Drug_Generic g WHERE g.generic_rxcui = d.ingr_rxcui)
	AND NOT EXISTS (SELECT drug_id 
		FROM c_Drug_Brand b WHERE b.brand_name_rxcui = d.ingr_rxcui)
*/
/*
-- Leave these alone, 428 generics not in Kenya formulations as generics
DELETE g 
FROM c_Drug_Generic g
WHERE NOT EXISTS (SELECT ingr_rxcui 
	FROM c_Drug_Formulation f 
	WHERE g.generic_rxcui = f.ingr_rxcui)
AND EXISTS (SELECT 1 
	FROM c_Drug_Generic g1 
	WHERE g1.generic_name = g.generic_name
)
*/
/*
SELECT count(*) FROM c_Drug_Brand g
WHERE NOT EXISTS (SELECT ingr_rxcui 
	FROM c_Drug_Formulation f 
	WHERE g.brand_name_rxcui = f.ingr_rxcui)
AND EXISTS (SELECT 1 
	FROM c_Drug_Brand g1 
	WHERE g1.brand_name = g.brand_name
	AND left(g1.brand_name_rxcui,2) != 'KE')
*/

-- Will need to retrieve these separately (RXNORM full set)
/*
select b.brand_name, b.brand_name_rxcui, f.form_descr, c2.[STR], c2.rxcui as generic_rxcui_min
FROM c_Drug_Brand b
JOIN c_Drug_Addition a ON a.country_drug_id = replace(b.brand_name_rxcui, 'KEBI', 'KE')
JOIN c_Drug_Formulation f ON f.ingr_rxcui = b.brand_name_rxcui
JOIN [DESKTOP-GU15HUD\ENCOUNTERPRO].interfaces.dbo.rxnrel_full r ON r.rxcui2 = substring(RTRIM(LTRIM(a.rxcui)),5,20)
JOIN [DESKTOP-GU15HUD\ENCOUNTERPRO].interfaces.dbo.rxnconso_full c2 ON c2.rxcui = r.rxcui1
WHERE generic_rxcui IS NULL
AND RTRIM(LTRIM(a.rxcui)) LIKE 'SCD-%'
AND brand_name_rxcui like 'KE%'
AND c2.TTY = 'MIN'

brand_name	brand_name_rxcui	form_descr	STR	generic_rxcui_min
Fanlar	KEBI1093	Fanlar 500 MG / 25 MG Oral Tablet	Pyrimethamine / Sulfadoxine	203218
Lacoma-T	KEBI13777	Lacoma - T Eye Drops	latanoprost / Timolol	388053
Deep Relief	KEBI1500	Deep Relief Anti-Inflammatory Topical Gel	Ibuprofen / LEVOMENTHOL	687386
Malacide	KEBI2253	Malacide 500 MG / 25 MG Oral Tablet	Pyrimethamine / Sulfadoxine	203218
Malodar	KEBI2253R	Malodar 500 MG / 25 MG Oral Tablet	Pyrimethamine / Sulfadoxine	203218
Methomine	KEBI3390	Methomine - S 500 MG / 25 MG Oral Tablet	Pyrimethamine / Sulfadoxine	203218
Nilol	KEBI5858	Nilol 20 MG / 50 MG Oral Tablet	Atenolol / Nifedipine	392475
select * from c_Drug_Generic where generic_rxcui in ('203218','388053','687386','392475')
*/

-- Generics haven't been duplicated
/*
SELECT generic_name, MIN(generic_rxcui) as chosen_generic_rxcui
FROM c_Drug_Generic g
WHERE drug_id IS NULL
AND EXISTS (SELECT 1 FROM c_Drug_Generic g1
		WHERE g1.generic_name = g.generic_name
		AND g1.generic_rxcui != g.generic_rxcui)
GROUP BY generic_name
*/

-- DELETE FROM c_Drug_Generic WHERE generic_rxcui IN ('KEGI11358','KEGI2067')

