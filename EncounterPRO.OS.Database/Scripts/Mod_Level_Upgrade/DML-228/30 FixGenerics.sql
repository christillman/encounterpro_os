
-- Remove old flu vaccines
DELETE d
-- select *
from c_Drug_Definition d
join c_Drug_Brand b on b.drug_id = d.drug_id
left join c_Drug_Generic g on g.generic_rxcui = b.generic_rxcui
where g.drug_id is null
and d.drug_id like 'RXNB%'

DELETE b
-- select *
from c_Drug_Brand b
left join c_Drug_Generic g on g.generic_rxcui = b.generic_rxcui
where g.drug_id is null
and b.drug_id like 'RXNB%'

-- SEDIPROCT SUPOSITORY HYDROCORTISON E+ CINCHOCAINE+ ESCULOSIDE+ FRAMYCETIN
DELETE FROM c_Drug_Generic WHERE generic_rxcui = 'UGGI2136'
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient, drug_id, valid_in)
VALUES ('hydrocortisone / cinchocaine / esculin / framycetin', 'UGGI2136', 0, 'UGGI2136', 'ug')

UPDATE c_Drug_Generic
SET generic_name = 'lansoprazole / cLARITHROMYcin / tinidazole'
WHERE drug_id = 'UGGI0850'

UPDATE c_Drug_Generic
SET generic_name = 'hydrocortisone / cinchocaine'
WHERE drug_id = 'UGGI1503'

-- Was truncated in import
UPDATE g
SET generic_name = 'boswellia serrata resin extract / cyperus rotundus tub extract / hyoscyamus niger sd extract / oil of ricinus communis extract / oroxylum indicum rt extract / strychnos nux-vomica sd extract / suvarna paan / vitex negundo lf extract / zingiber officinale rz extract'
-- select len(generic_name)
FROM c_Drug_Generic g
WHERE generic_rxcui = 'KEGI1977'

UPDATE f
SET form_descr = 'boswellia serrata resin extract 100 mG / cyperus rotundus tub extract 100 mG / hyoscyamus niger sd extract 20 mG / oil of ricinus communis extract 3 mG / oroxylum indicum rt extract 223.8 mG / purified strychnos nux-vomica sd extract 25 mG / suvarna paan 0.05 mG / vitex negundo lf extract 500 mG / zingiber officinale rz extract 50 mG Oral Tablet'
-- select len(form_descr)
FROM c_Drug_Formulation f
WHERE form_rxcui = 'KEG1977'

-- duplicate
DELETE FROM c_Drug_Generic 
WHERE generic_rxcui = 'UGGI9415'

UPDATE g
SET generic_name = 'bisOPROLOl fumarate / amLODIPine besilate'
FROM c_Drug_Generic g
WHERE generic_rxcui = 'UGGI9411'

UPDATE f
SET source_generic_form_descr = 'bisOPROLOl fumarate 5 MG / amLODIPine besilate 5 MG',
	active_ingredients = 'bisOPROLOl fumarate / amLODIPine besilate'
FROM c_Drug_Source_Formulation f
WHERE country_code = 'ug' and source_id = '9411'
UPDATE f
SET source_generic_form_descr = 'bisOPROLOl fumarate 10 MG / amLODIPine besilate 10 MG',
	active_ingredients = 'bisOPROLOl fumarate / amLODIPine besilate',
	generic_rxcui = 'UGGI9411'
FROM c_Drug_Source_Formulation f
WHERE country_code = 'ug' and source_id = '9415'
UPDATE f
SET form_descr = 'bisOPROLOl fumarate 5 MG / amLODIPine besilate 5 MG Oral Tablet'
-- select form_descr
FROM c_Drug_Formulation f
WHERE form_rxcui = 'UGG9411'

UPDATE f
SET form_descr = 'bisOPROLOl fumarate 10 MG / amLODIPine besilate 10 MG Oral Tablet',
	ingr_rxcui = 'UGGI9411'
FROM c_Drug_Formulation f
WHERE form_rxcui = 'UGG9415'

UPDATE f
SET form_descr = 'bisOPROLOl fumarate 10 MG / amLODIPine besilate 5 MG Oral Tablet',
	ingr_rxcui = 'UGGI9411'
FROM c_Drug_Formulation f
WHERE form_rxcui = 'UGG9413'

UPDATE f
SET form_descr = 'bisOPROLOl fumarate 5 MG / amLODIPine besilate 10 MG Oral Tablet',
	ingr_rxcui = 'UGGI9411'
FROM c_Drug_Formulation f
WHERE form_rxcui = 'UGG9416'

-- duplicate
DELETE FROM c_Drug_Definition 
WHERE drug_id = 'UGGI9415'

UPDATE d
SET generic_name = 'bisOPROLOl fumarate / amLODIPine besilate',
	common_name = 'bisOPROLOl fumarate / amLODIPine besilate'
FROM c_Drug_Definition d
WHERE drug_id = 'UGGI9411'

UPDATE g
SET generic_name = 'betamethasone dipropionate / betamethasone sodium phosphate'
FROM c_Drug_Generic g
WHERE generic_rxcui = 'UGGI5256'

UPDATE c_Drug_Definition 
SET generic_name = 'betamethasone dipropionate / betamethasone sodium phosphate'
WHERE drug_id in ('UGBI5256','UGGI5256')

UPDATE f
SET active_ingredients = 'betamethasone dipropionate / betamethasone sodium phosphate'
FROM c_Drug_Source_Formulation f
WHERE country_code = 'ug' and source_id = '5256'

UPDATE g
SET generic_name = 'Lombardy poplar pollen extract / white poplar pollen extract'
FROM c_Drug_Generic g
WHERE generic_rxcui = '1007321'

UPDATE c_Drug_Definition 
SET generic_name = 'Lombardy poplar pollen extract / white poplar pollen extract',
	common_name = 'Lombardy poplar pollen extract / white poplar pollen extract'
WHERE drug_id = 'RXNG1007321'

UPDATE c_Drug_Definition 
SET generic_name = 'hydrocortisone / cinchocaine / esculin / framycetin'
WHERE drug_id = 'UGBI2136'

DELETE FROM c_Drug_Definition 
WHERE drug_id IN ('UGGI2136','UGGI6424','UGGI6489','UGGI0850','UGGB0850')
INSERT INTO c_Drug_Definition (drug_id, drug_type, common_name, generic_name, status)
VALUES 
('UGGI2136', 'Single Drug', 'hydrocortisone / cinchocaine / esculin / framycetin', 'hydrocortisone / cinchocaine / esculin / framycetin', 'OK'),
('UGGI6424', 'Single Drug', 'ambroxol HCL / levosalbutamol / guaifenesin', 'ambroxol HCL / levosalbutamol / guaifenesin', 'OK'),
('UGGI6489', 'Single Drug', 'bromhexine / guaifenesin / terbutaline', 'bromhexine / guaifenesin / terbutaline', 'OK'),
('UGGI0850', 'Single Drug', 'lansoprazole / cLARITHROMYcin / tinidazole', 'lansoprazole / cLARITHROMYcin / tinidazole', 'OK'),
('UGGB0850', 'Single Drug', 'LCT', 'lansoprazole / cLARITHROMYcin / tinidazole', 'OK')


UPDATE c_Drug_Source_Formulation 
SET active_ingredients = 'hydrocortisone / cinchocaine',
source_generic_form_descr = 'hydrocortisone 0.5% / cinchocaine 0.5% Cream'
WHERE country_code = 'ug' and source_id = '1503'

UPDATE c_Drug_Formulation
SET form_descr = 'hydrocortisone 0.5% / cinchocaine 0.5% Cream'
WHERE form_rxcui = 'UGG1503'

UPDATE c_Drug_Definition 
SET generic_name = 'hydrocortisone / cinchocaine'
WHERE drug_id IN ('UGBI1503', 'UGGI1503')

UPDATE c_Drug_Definition 
SET common_name = 'hydrocortisone / cinchocaine'
WHERE drug_id IN ('UGGI1503')

UPDATE c_Drug_Source_Formulation 
SET active_ingredients = 'hydrocortisone / cinchocaine / esculin / framycetin',
source_generic_form_descr = 'hydrocortisone 5 MG / cinchocaine 5 MG / esculoside 10 MG / framycetin 10 MG Suppository'
WHERE country_code = 'ug' and source_id = '2136'

UPDATE c_Drug_Source_Formulation 
SET active_ingredients = 'lansoprazole / cLARITHROMYcin / tinidazole'
WHERE country_code = 'ug' and source_id = '0850'

UPDATE c_Drug_Source_Formulation 
SET source_generic_form_descr = 'aspirin / caffeine / paracetamol Tablets'
WHERE country_code = 'ug' and source_id = '2391'

UPDATE c_Drug_Formulation
SET form_descr = 'aspirin 300 mG / paracetamol 250 mG / caffeine 30 mG Oral Tablet'
WHERE form_rxcui = 'UGG2391'

DROP TABLE IF EXISTS #to_update
SELECT generic_rxcui, generic_name, replace(replace(replace(replace(
	generic_name,
	' (USP)',''),
	', USP',''),
	' (usp)',''),
	', usp','') AS revised
INTO #to_update
FROM c_Drug_Generic g
WHERE (generic_name like '% (usp)%' or generic_name like '%, usp%')

DROP TABLE IF EXISTS #collision
SELECT u.generic_rxcui as to_remove, g.drug_id, g2.generic_rxcui
INTO #collision
FROM #to_update u
JOIN c_Drug_Generic g ON g.generic_rxcui = u.generic_rxcui
JOIN c_Drug_Generic g2 ON g2.generic_name = u.revised

UPDATE f
SET ingr_rxcui = c.generic_rxcui,
	 form_descr = replace(replace(replace(replace(
	form_descr,
	' (USP)',''),
	', USP',''),
	' (usp)',''),
	', usp','')
-- select ingr_rxcui, c.generic_rxcui, valid_in
FROM c_Drug_Formulation f
JOIN #collision c ON f.ingr_rxcui = c.to_remove
UPDATE f
SET generic_rxcui = c.generic_rxcui
-- select f.generic_rxcui, c.generic_rxcui
FROM c_Drug_Source_Formulation f
JOIN #collision c ON f.generic_rxcui = c.to_remove
UPDATE d
SET status = 'NA'
-- select d.*
FROM c_Drug_Definition d
JOIN #collision c ON d.drug_id = c.drug_id

DELETE g
FROM c_Drug_Generic g
JOIN #collision c ON g.generic_rxcui = c.to_remove

DELETE u
FROM #to_update u
JOIN #collision c ON u.generic_rxcui = c.generic_rxcui

UPDATE g
SET generic_name = replace(replace(replace(replace(
	generic_name,
	' (USP)',''),
	', USP',''),
	' (usp)',''),
	', usp','')
-- select generic_name, replace(replace(replace(replace(generic_name,' (USP)',''),', USP',''),' (usp)',''),', usp','')
FROM c_Drug_Generic g
WHERE (generic_name like '% (usp)%' or generic_name like '%, usp%')

DROP TABLE IF EXISTS #to_update2
SELECT generic_rxcui, generic_name, replace(generic_name, ' HCL','') AS revised
INTO #to_update2
FROM c_Drug_Generic g
WHERE generic_name like '% HCL%'

DROP TABLE IF EXISTS #collision2
SELECT u.generic_rxcui as to_remove, g.drug_id, g2.generic_rxcui
INTO #collision2
FROM #to_update2 u
JOIN c_Drug_Generic g ON g.generic_rxcui = u.generic_rxcui
JOIN c_Drug_Generic g2 ON g2.generic_name = u.revised

UPDATE f
SET ingr_rxcui = c.generic_rxcui,
	 form_descr = replace(form_descr, ' HCL','')
-- select ingr_rxcui, c.generic_rxcui, form_descr, valid_in
FROM c_Drug_Formulation f
JOIN #collision2 c ON f.ingr_rxcui = c.to_remove
UPDATE f
SET generic_rxcui = c.generic_rxcui
-- select f.generic_rxcui, c.generic_rxcui
FROM c_Drug_Source_Formulation f
JOIN #collision2 c ON f.generic_rxcui = c.to_remove
UPDATE d
SET status = 'NA'
-- select d.*
FROM c_Drug_Definition d 
JOIN #collision2 c ON d.drug_id = c.drug_id

DELETE g
FROM c_Drug_Generic g
JOIN #collision2 c ON g.generic_rxcui = c.to_remove

DELETE u
FROM #to_update u
JOIN #collision2 c ON u.generic_rxcui = c.generic_rxcui

UPDATE c_Drug_Generic
SET generic_name = replace(generic_name, ' HCL','')
where generic_name like '% HCL%'

UPDATE c_Drug_Generic
SET generic_name = replace(generic_name, 'B 12','B12')
where generic_name like '%B 12%'

-- kit represented as single drug
DELETE FROM c_Drug_Definition
WHERE drug_id = 'UGGI4801'
DELETE FROM c_Drug_Generic
WHERE drug_id = 'UGGI4801'
DELETE FROM c_Drug_Brand
WHERE drug_id = 'UGBI4801'
DELETE FROM c_Drug_Formulation
WHERE form_rxcui = 'UGG4801'

UPDATE c_Drug_Source_Formulation 
SET source_generic_form_descr = '{ 1 (fluconazole 150 MG Oral Tablet) / 1 (azITHROMYCIN 1 GM Oral Tablet) / 2 (secnidazole 1 GM Oral Tablet) } Kit',
	active_ingredients = 'azITHROMYCIN / fluconazole / secnidazole',
	generic_rxcui = 'KEGI8288',
	brand_name_rxcui = 'KEB9429',
	generic_form_rxcui = 'KEG9429',
	is_pack = 1,
	is_single_ingredient = 0
WHERE country_code = 'ug' and source_id = '4801'

UPDATE c_Drug_Source_Formulation 
SET active_ingredients = 'azITHROMYCIN / fluconazole / secnidazole',
	generic_rxcui = 'KEGI8288'
WHERE country_code = 'ke' and source_id in ('9429','10821','11635','8977','8288')

UPDATE c_Drug_Generic SET generic_name = 'azITHROMYCIN / fluconazole / secnidazole' 
WHERE generic_rxcui = 'KEGI8288'

DELETE FROM c_Drug_Pack WHERE pack_rxcui = 'KEG8288'
INSERT INTO c_Drug_Pack (pack_rxcui, pack_tty, pack_descr, valid_in)
VALUES ('KEG8288','GPCK_KE','{ 1 (fluconazole 150 MG Oral Tablet) / 1 (azITHROMYCIN 1 GM Oral Tablet) / 2 (secnidazole 1 GM Oral Tablet) } Kit','ke;ug;')

-- Undo incorrect TallMan application
UPDATE g 
SET generic_name = replace(generic_name, 'pseudoePHEDrine', 'pseudoephedrine')
FROM c_Drug_Generic g
where generic_name like '%pseudoePHEDrine%'
-- (64 rows affected)

UPDATE f 
SET form_descr = replace(form_descr, 'pseudoePHEDrine', 'pseudoephedrine')
FROM c_Drug_Formulation f
where form_descr like '%pseudoePHEDrine%'
-- (191 rows affected)

UPDATE d 
SET generic_name = replace(generic_name, 'pseudoePHEDrine', 'pseudoephedrine'),
	common_name = replace(common_name, 'pseudoePHEDrine', 'pseudoephedrine')
	-- select *
FROM c_Drug_Definition d
where generic_name like '%pseudoePHEDrine%'
-- (163 rows affected)

-- duplicate generics with incorrect drug_id = generic_rxcui
DELETE d
-- select d.drug_id, g2.generic_rxcui, g2.drug_id, d2.common_name, d2.generic_name
from c_Drug_Definition d
left join c_Drug_Generic g on d.drug_id = g.drug_id
left join c_Drug_Brand b on d.drug_id = b.drug_id
left join c_Vaccine v on d.drug_id = v.drug_id
join c_Drug_Generic g2 on d.generic_name = g2.generic_name
join c_Drug_Definition d2 on d2.drug_id = g2.drug_id
where g.drug_id is null and b.drug_id is null  and v.drug_id is null
and d.common_name = d.generic_name
and d.common_name = d2.common_name
-- (97 rows affected)

UPDATE c_Drug_Generic 
SET is_single_ingredient = 0
WHERE is_single_ingredient = 1 
AND generic_name like '%/%'

UPDATE c_Drug_Generic 
SET is_single_ingredient = 1
WHERE is_single_ingredient = 0 
AND generic_name NOT like '%/%'