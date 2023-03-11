

-- Revised per 11_26_2020 dose_unit assignment ^L0 corrections_RevisedJan2022.xlsx

SELECT form_rxcui 
INTO #insulin
FROM c_Drug_Formulation f
JOIN c_Drug_Generic g ON g.generic_rxcui = f.ingr_rxcui
where g.generic_name like '%insulin%'
UNION
SELECT form_rxcui 
FROM c_Drug_Formulation f
JOIN c_Drug_Brand b ON b.brand_name_rxcui = f.ingr_rxcui
JOIn c_Drug_Generic g ON g.generic_rxcui = b.generic_rxcui
where g.generic_name like '%insulin%'
--(136 row(s) affected)

SELECT form_rxcui
INTO #oral_multi
FROM c_Drug_Formulation f
JOIN c_Drug_Generic g ON g.generic_rxcui = f.ingr_rxcui
where g.generic_name like '%/%'
and f.form_descr LIKE '%Oral s%'
UNION
SELECT form_rxcui
FROM c_Drug_Formulation f
JOIN c_Drug_Brand b ON b.brand_name_rxcui = f.ingr_rxcui
JOIn c_Drug_Generic g ON g.generic_rxcui = b.generic_rxcui
where g.generic_name like '%/%'
and f.form_descr LIKE '%Oral s%'
-- (659 row(s) affected)

SELECT form_rxcui
INTO #oral_single
FROM c_Drug_Formulation f
JOIN c_Drug_Generic g ON g.generic_rxcui = f.ingr_rxcui
where g.generic_name not like '%/%'
and f.form_descr LIKE '%Oral s%'
UNION
SELECT form_rxcui
FROM c_Drug_Formulation f
JOIN c_Drug_Brand b ON b.brand_name_rxcui = f.ingr_rxcui
JOIn c_Drug_Generic g ON g.generic_rxcui = b.generic_rxcui
where g.generic_name not like '%/%'
and f.form_descr LIKE '%Oral s%'
-- (948 row(s) affected)

-- Insulin specs
-- Insulin is always UNIT dose_unit

print 'Insulin default'
UPDATE vw_dose_unit SET dose_unit = 'UNIT'
-- select * from vw_dose_unit
where form_rxcui IN (SELECT form_rxcui FROM #insulin)
AND (dose_unit IS NULL OR dose_unit != 'UNIT')

UPDATE vw_dose_unit SET dosage_form = 'Pen Injector'
-- select * from vw_dose_unit
where form_rxcui IN (SELECT form_rxcui FROM #insulin)
AND (ISNULL(generic_form_descr, form_descr) LIKE '%pen injector%' 
	OR ISNULL(generic_form_descr, form_descr) LIKE '%kwikpen%' 
	OR ISNULL(generic_form_descr, form_descr) LIKE '%prefilled pen%' 
	OR ISNULL(generic_form_descr, form_descr) LIKE '%penfill%')
and (dosage_form IS NULL OR dosage_form != 'Pen Injector')
-- (8 row(s) affected)

UPDATE vw_dose_unit SET dose_unit = 'UNIT', dosage_form = 'Cartridge'
-- select * from vw_dose_unit
where form_rxcui IN (SELECT form_rxcui FROM #insulin)
AND ISNULL(generic_form_descr, form_descr) LIKE '%inhalation powder%'
and (dosage_form IS NULL OR dosage_form != 'Cartridge')
-- (6 row(s) affected)

UPDATE vw_dose_unit SET dose_unit = 'UNIT', dosage_form = 'Cartridge'
-- select * from vw_dose_unit
where form_rxcui IN (SELECT form_rxcui FROM #insulin)
AND ISNULL(generic_form_descr, form_descr) NOT LIKE '%inhalation powder%'
and ISNULL(generic_form_descr, form_descr) like '%cartridge%'
and (dosage_form IS NULL OR dosage_form != 'Cartridge')
-- (22 row(s) affected)

UPDATE vw_dose_unit SET default_dispense_unit = 'UNIT'
-- select * from vw_dose_unit
where form_rxcui IN (SELECT form_rxcui FROM #insulin)
AND ISNULL(generic_form_descr, form_descr) LIKE '%inhalation powder%'
and (default_dispense_unit IS NULL OR default_dispense_unit != 'UNIT')
-- (6 row(s) affected)

UPDATE vw_dose_unit SET default_dispense_unit = 'Cartridge'
-- select * from vw_dose_unit
where form_rxcui IN (SELECT form_rxcui FROM #insulin)
AND ISNULL(generic_form_descr, form_descr) NOT LIKE '%inhalation powder%'
and ISNULL(generic_form_descr, form_descr) like '%cartridge%'
and (default_dispense_unit IS NULL OR default_dispense_unit != 'UNIT')
-- (22 row(s) affected)

UPDATE vw_dose_unit SET dosage_form = 'Injectable Soln'
-- select * from vw_dose_unit
where  form_rxcui IN (SELECT form_rxcui FROM #insulin)
and ISNULL(generic_form_descr, form_descr) LIKE '%Injectable solution%'
and (dosage_form IS NULL OR dosage_form != 'Injectable Soln')
-- 0

UPDATE vw_dose_unit SET dosage_form = 'Injectable Susp'
-- select * from vw_dose_unit
where  form_rxcui IN (SELECT form_rxcui FROM #insulin)
and ISNULL(generic_form_descr, form_descr) LIKE '%Injectable suspension%'
and (dosage_form IS NULL OR dosage_form != 'Injectable Susp')
-- 0

print 'Oral default'
-- The default for Oral Solution, Oral Syrup, or Oral Suspension, 
-- both single and multiple ingredients, is dose_unit = 'ML'
-- This covers ~ 20 rows of Ciru's spread sheet
UPDATE v  
SET dose_unit = 'ML'
FROM vw_dose_unit v
where (generic_form_descr LIKE '%oral sol%' 
			OR form_descr LIKE '%oral sol%' 
			OR generic_form_descr LIKE '%oral syr%' 
			OR form_descr LIKE '%oral syr%' 
			OR generic_form_descr LIKE '%oral sus%' 
			OR form_descr LIKE '%oral sus%' )
and ISNULL(generic_form_descr, form_descr) NOT LIKE '%granules%'
and ISNULL(generic_form_descr, form_descr) NOT LIKE '%drop%'
and dose_unit IS NULL
-- (161 row(s) affected)

-- The default administer_method for anything Oral is PO
UPDATE pm 
SET administer_method = 'PO'
-- select * 
FROM [c_Package_Administration_Method] pm
JOIN vw_dose_unit u ON u.package_id = pm.package_id
where ISNULL(generic_form_descr, form_descr) LIKE '%oral %'
AND administer_method IS NULL
-- (5 row(s) affected)

print 'Drops Or'
UPDATE vw_dose_unit  SET dose_unit = 'DROP', dosage_form = 'Drops Or'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%oral drop%'
and (dose_unit IS NULL OR dose_unit != 'DROP')
-- (6 row(s) affected)

UPDATE vw_dose_unit  SET dose_unit = 'DROP', dosage_form = 'Oral Solution'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%oral solution%'
and ISNULL(generic_form_descr, form_descr) LIKE '%DROPS%'
and ISNULL(generic_form_descr, form_descr) NOT LIKE '%lozenge%'
and (dose_unit IS NULL OR dose_unit != 'DROP')
-- 0

UPDATE vw_dose_unit  SET dose_unit = 'DROP', dosage_form = 'MucousMemSoln'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%mouth paint%'
and (dose_unit IS NULL OR dose_unit != 'DROP')
-- 0

UPDATE vw_dose_unit  SET dose_unit = 'PACKE', dosage_form = 'Pwdr Oral Soln'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%oral Solution%'
and ISNULL(generic_form_descr, form_descr) LIKE '%powder%'
and ISNULL(generic_form_descr, form_descr) LIKE '%MG%'
and ISNULL(generic_form_descr, form_descr) NOT LIKE '%ML%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_multi)
and (dose_unit IS NULL OR dose_unit != 'PACKE')
-- (16 row(s) affected)

UPDATE vw_dose_unit SET dose_unit = 'ML', dosage_form = 'Pwdr Oral Soln'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) like '%powder for oral Solution%'
and ISNULL(generic_form_descr, form_descr) like '%ml%'
and ISNULL(generic_form_descr, form_descr) NOT LIKE '%/%'  
and (dose_unit IS NULL OR dose_unit != 'ML')
-- 0

print 'A'
UPDATE vw_dose_unit  SET dose_unit = 'GRAM', dosage_form = 'Pwdr Oral Soln'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%oral Solution%'
and ISNULL(generic_form_descr, form_descr) LIKE '%powder%'
and ISNULL(generic_form_descr, form_descr) LIKE '%GM%'
and ISNULL(generic_form_descr, form_descr) NOT LIKE '%MG%'
and ISNULL(generic_form_descr, form_descr) NOT LIKE '%MEQ%'
and ISNULL(generic_form_descr, form_descr) NOT LIKE '%ML%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single)
and (dose_unit IS NULL OR dose_unit != 'GRAM')
-- (23 row(s) affected)

Print 'MEQ'
UPDATE vw_dose_unit  SET dose_unit = 'MEQ', dosage_form = 'Pwdr Oral Soln'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%Oral Solution%'
and ISNULL(generic_form_descr, form_descr) LIKE '%MEQ%'
and ISNULL(generic_form_descr, form_descr) LIKE '%powder%'
and ISNULL(generic_form_descr, form_descr) NOT LIKE '%ML%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single)
and (dose_unit IS NULL OR dose_unit != 'MEQ')
-- (4 row(s) affected)

UPDATE vw_dose_unit  SET default_dispense_unit = 'MEQ'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%Oral Solution%'
and ISNULL(generic_form_descr, form_descr) LIKE '%MEQ%'
and ISNULL(generic_form_descr, form_descr) LIKE '%powder%'
and ISNULL(generic_form_descr, form_descr) NOT LIKE '%ML%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single)
and (default_dispense_unit IS NULL OR default_dispense_unit != 'MEQ')


UPDATE vw_dose_unit  SET dose_unit = 'MG', dosage_form = 'Pwdr Oral Soln'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%Oral Solution%'
and ISNULL(generic_form_descr, form_descr) LIKE '%MG%'
and ISNULL(generic_form_descr, form_descr) LIKE '%powder%'
and ISNULL(generic_form_descr, form_descr) NOT LIKE '%ML%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single)
and (dose_unit IS NULL OR dose_unit != 'MG')
-- (9 row(s) affected)

-- This needs to trump other Pwdr Oral Soln, leave to last (KEB4377/KEG4377)
UPDATE p SET dose_unit = 'PACKE', dosage_form = 'Pwdr Oral Soln'
-- select *
from c_Drug_Formulation f
join c_Drug_Package dp ON dp.form_rxcui = f.form_rxcui
join c_Package p on p.package_id = dp.package_id
JOIN c_Drug_Brand b ON b.brand_name_rxcui = f.ingr_rxcui
JOIn c_Drug_Generic g ON g.generic_rxcui = b.generic_rxcui
where g.generic_name like '%citric acid%'
and g.generic_name like '%sodium bicarbonate%'
and form_descr LIKE '%powder%'
and (dose_unit IS NULL OR dose_unit != 'PACKE')
-- ISNULL(generic_form_descr, form_descr) NOT LIKE '%tablet%'
-- Eno Lemon 55.76 % / 43.14 % Powder for Oral Solution

print 'PACKE'
UPDATE vw_dose_unit  SET dose_unit = 'PACKE', dosage_form = 'Granules'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%oral solution%'
and ISNULL(generic_form_descr, form_descr) LIKE '%GRANULES%'
and ISNULL(generic_form_descr, form_descr) LIKE '%IU%'
and ISNULL(generic_form_descr, form_descr) NOT LIKE '%MG%'
and ISNULL(generic_form_descr, form_descr) NOT LIKE '%GM%'
and ISNULL(generic_form_descr, form_descr) NOT LIKE '%MCG%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single)
and (dose_unit IS NULL OR dose_unit != 'PACKE')
-- 0

print '2'
UPDATE vw_dose_unit  SET dose_unit = 'PACKE', dosage_form = 'Granules'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%GRANULES% oral solution%'
and ISNULL(generic_form_descr, form_descr) LIKE '%MG%'
and ISNULL(generic_form_descr, form_descr) LIKE '%GM%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_multi)
and (dose_unit IS NULL OR dose_unit != 'PACKE')
-- 0

UPDATE vw_dose_unit  SET dose_unit = 'MG', dosage_form = 'Granules'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%GRANULES% oral solution%'
and ISNULL(generic_form_descr, form_descr) LIKE '%MG%'
and ISNULL(generic_form_descr, form_descr) NOT LIKE '%GM%'
and (dose_unit IS NULL OR dose_unit != 'MG')
-- 0

UPDATE vw_dose_unit  SET dose_unit = 'WAFER', dosage_form = 'Oral Wafer'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%oral wafer%'
and (dose_unit IS NULL OR dose_unit != 'WAFER')
-- (2 row(s) affected)

UPDATE vw_dose_unit  SET default_dispense_unit = 'WAFER'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%oral wafer%'
and (default_dispense_unit IS NULL OR default_dispense_unit != 'WAFER')
-- (1 row(s) affected)
-- (16 row(s) affected)

print 'B'
UPDATE vw_dose_unit  SET dose_unit = 'GRAM', dosage_form = 'Granules'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%oral solution%'
and ISNULL(generic_form_descr, form_descr) LIKE '%GRANULES%'
and ISNULL(generic_form_descr, form_descr) LIKE '%GM%'
and ISNULL(generic_form_descr, form_descr) NOT LIKE '%MG%'
and ISNULL(generic_form_descr, form_descr) NOT LIKE '%GM%'
and ISNULL(generic_form_descr, form_descr) NOT LIKE '%MCG%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single)
and (dose_unit IS NULL OR dose_unit != 'GRAM')
-- 0

UPDATE vw_dose_unit  SET dose_unit = 'TSP', dosage_form = 'Granules'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%oral solution%'
and ISNULL(generic_form_descr, form_descr) LIKE '%GRANULES%'
and ISNULL(generic_form_descr, form_descr) LIKE '%GM%'
and (ISNULL(generic_form_descr, form_descr) NOT LIKE '%MG%'
	OR ISNULL(generic_form_descr, form_descr) LIKE '%000 MG%')
and (dose_unit IS NULL OR dose_unit != 'TSP')
-- (4 row(s) affected)

UPDATE vw_dose_unit  SET default_dispense_unit = 'TSP'
where ISNULL(generic_form_descr, form_descr) LIKE '%oral solution%'
and ISNULL(generic_form_descr, form_descr) LIKE '%GRANULES%'
and ISNULL(generic_form_descr, form_descr) LIKE '%GM%'
and (ISNULL(generic_form_descr, form_descr) NOT LIKE '%MG%'
	OR ISNULL(generic_form_descr, form_descr) LIKE '%000 MG%')
and (default_dispense_unit IS NULL OR default_dispense_unit != 'TSP')
-- (4 row(s) affected)

print 'Pwdrr Oral Susp'
UPDATE vw_dose_unit  SET dose_unit = 'MG', dosage_form = 'Pwdrr Oral Susp'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%oral suspension%'
and ISNULL(generic_form_descr, form_descr) LIKE '%powder%'
and ISNULL(generic_form_descr, form_descr) NOT LIKE '%ML%'
and ISNULL(generic_form_descr, form_descr) LIKE '%MG%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_multi)
and (dose_unit IS NULL OR dose_unit != 'MG')
-- (10 row(s) affected)

UPDATE vw_dose_unit  SET default_dispense_unit = 'MG'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%oral suspension%'
and ISNULL(generic_form_descr, form_descr) LIKE '%powder%'
and ISNULL(generic_form_descr, form_descr) NOT LIKE '%ML%'
and ISNULL(generic_form_descr, form_descr) LIKE '%MG%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_multi)
and (default_dispense_unit IS NULL OR default_dispense_unit != 'MG')
-- (10 row(s) affected)

UPDATE vw_dose_unit  SET dose_unit = 'MG', dosage_form = 'Pwdrr Oral Susp'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%DRY suspension%'
and ISNULL(generic_form_descr, form_descr) LIKE '%MG%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single)
and (dose_unit IS NULL OR dose_unit != 'MG')

UPDATE vw_dose_unit  SET default_dispense_unit = 'MG'
where ISNULL(generic_form_descr, form_descr) LIKE '%DRY suspension%'
and ISNULL(generic_form_descr, form_descr) LIKE '%MG%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single)
and (default_dispense_unit IS NULL OR default_dispense_unit != 'MG')
-- 0

UPDATE vw_dose_unit  SET dose_unit = 'ML', dosage_form = 'Pwdrr Oral Susp'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%oral suspension%'
and ISNULL(generic_form_descr, form_descr) LIKE '%powder%'
and ISNULL(generic_form_descr, form_descr) LIKE '%GM%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_multi)
and (dose_unit IS NULL OR dose_unit != 'ML')
-- 0

UPDATE vw_dose_unit  SET dose_unit = 'PACKE', dosage_form = 'GranuleOralSusp'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%granules for oral suspension%'
and ISNULL(generic_form_descr, form_descr) NOT LIKE '%ML%'
and (dose_unit IS NULL OR dose_unit != 'PACKE')
-- (4 row(s) affected)

print 'C'
UPDATE vw_dose_unit  SET default_dispense_unit = 'PACKE'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%granules for oral suspension%'
and ISNULL(generic_form_descr, form_descr) NOT LIKE '%ML%'
and (default_dispense_unit IS NULL OR default_dispense_unit != 'PACKE')
-- (1 row(s) affected)
-- (12 row(s) affected)

UPDATE vw_dose_unit  SET dose_unit = 'ML', dosage_form = 'GranuleOralSusp'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%granules for oral suspension%'
and ISNULL(generic_form_descr, form_descr) LIKE '%ML%'
and (dose_unit IS NULL OR dose_unit != 'ML')
-- (10 row(s) affected)

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%granules for oral suspension%'
and ISNULL(generic_form_descr, form_descr) LIKE '%ML%'
and (default_dispense_unit IS NULL OR default_dispense_unit != 'ML')
-- (10 row(s) affected)

print 'D'
UPDATE vw_dose_unit  SET dose_unit = 'UNIT', dosage_form = 'Oral Suspension'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%oral suspension%'
and ISNULL(generic_form_descr, form_descr) LIKE '%UN%T%'
and ISNULL(generic_form_descr, form_descr) NOT LIKE '%powder%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single)
and (dose_unit IS NULL OR dose_unit != 'UNIT')
-- (6 row(s) affected)

print 'oral suspension-ML'
UPDATE vw_dose_unit  SET dose_unit = 'ML', dosage_form = 'Oral Suspension'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) like '%oral suspension%' 
and ISNULL(generic_form_descr, form_descr) like '%ML%' 
and ISNULL(generic_form_descr, form_descr) like '%MG%' 
and form_descr not like '%powder%' 
and ISNULL(generic_form_descr, form_descr) not like '%granules%' 
and ISNULL(generic_form_descr, form_descr) not like '%tablet%' 
and ISNULL(generic_form_descr, form_descr) not like '%UNT%' 
and ISNULL(generic_form_descr, form_descr) not like '%GM%' 
and ISNULL(generic_form_descr, form_descr) not like '%UNIT%' 
and ISNULL(generic_form_descr, form_descr) not like '%IU%' 
and form_rxcui IN (SELECT form_rxcui FROM #oral_single)
and (dose_unit IS NULL OR dose_unit != 'ML')
-- 0

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) like '%oral suspension%' 
and ISNULL(generic_form_descr, form_descr) like '%ML%' 
and ISNULL(generic_form_descr, form_descr) like '%MG%' 
and form_descr not like '%powder%' 
and ISNULL(generic_form_descr, form_descr) not like '%granules%' 
and ISNULL(generic_form_descr, form_descr) not like '%tablet%' 
and ISNULL(generic_form_descr, form_descr) not like '%UNT%' 
and ISNULL(generic_form_descr, form_descr) not like '%GM%' 
and ISNULL(generic_form_descr, form_descr) not like '%UNIT%' 
and ISNULL(generic_form_descr, form_descr) not like '%IU%' 
and form_rxcui IN (SELECT form_rxcui FROM #oral_single)
and (default_dispense_unit IS NULL OR default_dispense_unit != 'ML')
-- (9 row(s) affected)

UPDATE vw_dose_unit  SET dose_unit = 'ML', dosage_form = 'Oral Suspension'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) like '%oral suspension%' 
and ISNULL(generic_form_descr, form_descr) not like '%ML%' 
and ISNULL(generic_form_descr, form_descr) not like '%MG%' 
and ISNULL(generic_form_descr, form_descr) not like '%powder%' 
and ISNULL(generic_form_descr, form_descr) not like '%granules%' 
and ISNULL(generic_form_descr, form_descr) not like '%tablet%' 
and ISNULL(generic_form_descr, form_descr) not like '%UNT%' 
and ISNULL(generic_form_descr, form_descr) not like '%GM%' 
and ISNULL(generic_form_descr, form_descr) not like '%UNIT%' 
and ISNULL(generic_form_descr, form_descr) not like '%IU%' 
and form_rxcui IN (SELECT form_rxcui FROM #oral_single)
and (dose_unit IS NULL OR dose_unit != 'ML')
-- 0

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) like '%oral suspension%' 
and ISNULL(generic_form_descr, form_descr) not like '%ML%' 
and ISNULL(generic_form_descr, form_descr) not like '%MG%' 
and ISNULL(generic_form_descr, form_descr) not like '%powder%' 
and ISNULL(generic_form_descr, form_descr) not like '%granules%' 
and ISNULL(generic_form_descr, form_descr) not like '%tablet%' 
and ISNULL(generic_form_descr, form_descr) not like '%UNT%' 
and ISNULL(generic_form_descr, form_descr) not like '%GM%' 
and ISNULL(generic_form_descr, form_descr) not like '%UNIT%' 
and ISNULL(generic_form_descr, form_descr) not like '%IU%' 
and form_rxcui IN (SELECT form_rxcui FROM #oral_single)
and (default_dispense_unit IS NULL OR default_dispense_unit != 'ML')
-- (4 row(s) affected)

print 'E'
UPDATE vw_dose_unit  SET dose_unit = 'CAP', dosage_form = 'Cap'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) like '%oral capsule%' 
and ISNULL(generic_form_descr, form_descr) NOT LIKE '%Release%'
and (dose_unit IS NULL OR dose_unit != 'CAP')
-- (5 row(s) affected)

UPDATE vw_dose_unit  SET default_dispense_unit = 'CAP'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) like '%oral capsule%' 
and (default_dispense_unit IS NULL OR default_dispense_unit != 'CAP')
-- (243 row(s) affected)

UPDATE vw_dose_unit  SET dose_unit = 'APPLY', dosage_form = 'Oral Gel'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) like '%oral gel%' 
and (dose_unit IS NULL OR dose_unit != 'APPLY')
-- 0

UPDATE vw_dose_unit  SET default_dispense_unit = 'APPLY'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) like '%oral gel%'
and (default_dispense_unit IS NULL OR default_dispense_unit != 'APPLY')
-- (8 row(s) affected)

UPDATE pm 
SET administer_method = 'ASDIR'
-- select * 
FROM [c_Package_Administration_Method] pm
JOIN vw_dose_unit u ON u.package_id = pm.package_id
where ISNULL(generic_form_descr, form_descr) like '%oral gel%' 
and (administer_method IS NULL OR administer_method != 'ASDIR')
-- (88 row(s) affected)

UPDATE vw_dose_unit  SET dose_unit = 'ML', dosage_form = 'Oral Suspension'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) like '%oral vaccine%' 
and (dose_unit IS NULL OR dose_unit != 'ML')
-- (2 row(s) affected)

print 'F'
UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) like '%oral vaccine%' 
and (default_dispense_unit IS NULL OR default_dispense_unit != 'ML')
-- (6 row(s) affected)

UPDATE vw_dose_unit  SET dose_unit = 'TAB', dosage_form = 'TabletOralSusp'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%tablet% oral suspension%'
and (dose_unit IS NULL OR dose_unit != 'TAB')
-- (30 row(s) affected)

UPDATE vw_dose_unit  SET dose_unit = 'TAB', dosage_form = 'DisOral Tab'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%orodispersible%'
and (dose_unit IS NULL OR dose_unit != 'TAB')
-- 0

UPDATE vw_dose_unit  SET dose_unit = 'TAB', dosage_form = 'DisOral Tab'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%disintegrating%'
and ISNULL(generic_form_descr, form_descr) LIKE '%oral%'
and ISNULL(generic_form_descr, form_descr) LIKE '%tablet%'
and (dose_unit IS NULL OR dose_unit != 'TAB')
-- 0

UPDATE vw_dose_unit  SET dose_unit = 'STRIP', dosage_form = 'Oral Strip'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) NOT LIKE '%disintegrating%'
and ISNULL(generic_form_descr, form_descr) LIKE '%oral%' 
and ISNULL(generic_form_descr, form_descr) LIKE '%strip%'
and (dose_unit IS NULL OR dose_unit != 'STRIP')
-- (1 row(s) affected)

print 'G'

UPDATE vw_dose_unit  SET dose_unit = 'APPLY', dosage_form = 'Topical Cream'
-- select * from vw_dose_unit
where (ISNULL(generic_form_descr, form_descr) LIKE '%skin cream%'
 or ISNULL(generic_form_descr, form_descr) LIKE '%topical cream%'
 or ISNULL(generic_form_descr, form_descr) LIKE '%topical gel%')
and (dose_unit IS NULL OR dose_unit != 'APPLY')
-- 0

UPDATE vw_dose_unit  SET dose_unit = 'UNIT', dosage_form = 'Pen Injector'
-- select * from vw_dose_unit
where (ISNULL(generic_form_descr, form_descr) LIKE '% pen injector%'
or ISNULL(generic_form_descr, form_descr) LIKE '%prefilled pen%')
and form_rxcui NOT IN (SELECT form_rxcui FROM #insulin)
and ISNULL(generic_form_descr, form_descr) LIKE '%UNT%'
and (dose_unit IS NULL OR dose_unit != 'UNIT')
-- 0

UPDATE vw_dose_unit  SET dose_unit = 'MG', dosage_form = 'Pen Injector'
-- select * from vw_dose_unit
where (ISNULL(generic_form_descr, form_descr) LIKE '% pen injector%'
or ISNULL(generic_form_descr, form_descr) LIKE '%prefilled pen%')
and form_rxcui NOT IN (SELECT form_rxcui FROM #insulin)
and ISNULL(generic_form_descr, form_descr) LIKE '%MG%'
and (dose_unit IS NULL OR dose_unit != 'MG')
-- 0

UPDATE vw_dose_unit  SET dose_unit = 'MCG', dosage_form = 'Pen Injector'
-- select * from vw_dose_unit
where (ISNULL(generic_form_descr, form_descr) LIKE '% pen injector%'
or ISNULL(generic_form_descr, form_descr) LIKE '%prefilled pen%')
and form_rxcui NOT IN (SELECT form_rxcui FROM #insulin)
and ISNULL(generic_form_descr, form_descr) LIKE '%MCG%'
and (dose_unit IS NULL OR dose_unit != 'MCG')
-- 0

UPDATE vw_dose_unit  SET dose_unit = 'Stick', dosage_form = 'CUTANEOUSSTICK'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%CUTANEOUS STICK%'
and (dose_unit IS NULL OR dose_unit != 'Stick')
-- (2 row(s) affected)

print 'H'
UPDATE vw_dose_unit  SET default_dispense_unit = 'Stick'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%CUTANEOUS STICK%'
and (default_dispense_unit IS NULL OR default_dispense_unit != 'Stick')
-- (2 row(s) affected)

UPDATE pm 
SET administer_method = 'ASDIR'
-- select * 
FROM [c_Package_Administration_Method] pm
JOIN vw_dose_unit u ON u.package_id = pm.package_id
where ISNULL(generic_form_descr, form_descr) LIKE '%CUTANEOUS STICK%'
and (administer_method IS NULL OR administer_method != 'ASDIR')
-- (2 row(s) affected)

UPDATE vw_dose_unit  SET dose_unit = 'APPLYEYE', dosage_form = 'Ophthalmic Oint'
-- select * from vw_dose_unit
where (ISNULL(generic_form_descr, form_descr) LIKE '%ophthalmic ointment%'
	OR form_descr LIKE '%eye ointment%')
and (dose_unit IS NULL OR dose_unit != 'APPLYEYE')
-- 0

UPDATE vw_dose_unit  SET dose_unit = 'APPLYEYE', dosage_form = 'Ophthalmic Oint'
-- select * from vw_dose_unit
where (ISNULL(generic_form_descr, form_descr) LIKE '%ophthalmic gel%')
and (dose_unit IS NULL OR dose_unit != 'APPLYEYE')
-- 0

print 'I'
UPDATE vw_dose_unit  SET dose_unit = 'DROPEYE', dosage_form = 'Ophthalmic Soln'
-- select * from vw_dose_unit
where (ISNULL(generic_form_descr, form_descr) LIKE '%eye drop%'
	or ISNULL(generic_form_descr, form_descr) LIKE '%ophthalmic solution%')
and (ISNULL(generic_form_descr, form_descr) NOT LIKE '%suspension%'
	or ISNULL(generic_form_descr, form_descr) LIKE '%solution%')
and (dose_unit IS NULL OR dose_unit != 'DROPEYE' OR dosage_form != 'Ophthalmic Soln')
--(47 row(s) affected)

UPDATE vw_dose_unit  SET dose_unit = 'DROPEYE', dosage_form = 'Ophthalmic Susp'
-- select * from vw_dose_unit
where (ISNULL(generic_form_descr, form_descr) LIKE '%eye drop%'
	or ISNULL(generic_form_descr, form_descr) LIKE '%ophthalmic suspension%')
and ISNULL(generic_form_descr, form_descr) LIKE '%suspension%'
and (dose_unit IS NULL OR dose_unit != 'DROPEYE' OR dosage_form != 'Ophthalmic Susp')
-- (7 row(s) affected)

UPDATE vw_dose_unit SET default_dispense_unit = 'ML'
-- select * from vw_dose_unit
WHERE dose_unit = 'DROPEYE'
and (default_dispense_unit IS NULL OR default_dispense_unit != 'ML')
-- (468 row(s) affected)

UPDATE vw_dose_unit  SET dose_unit = 'DROPEAR', dosage_form = 'Otic Solution'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%otic solution%'
and (dose_unit IS NULL OR dose_unit != 'DROPEAR')
-- (2 row(s) affected)

UPDATE vw_dose_unit  SET dose_unit = 'DROPEAR', dosage_form = 'Otic Suspension'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%otic suspension%'
and (dose_unit IS NULL OR dose_unit != 'DROPEAR')
-- 0

UPDATE vw_dose_unit  SET dose_unit = 'DROPEAR', dosage_form = 'Otic Solution'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%otic drop%'	
and (dose_unit IS NULL OR dose_unit != 'DROPEAR')
-- 0

print 'J'
UPDATE vw_dose_unit  SET dose_unit = 'DROPEAR', dosage_form = 'Otic Suspension'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%otic drops suspension%'
and (dose_unit IS NULL OR dose_unit != 'DROPEAR')
-- 0

UPDATE vw_dose_unit  SET dose_unit = 'DROPEAR', dosage_form = 'Otic Lotion'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%otic lotion%'	
and (dose_unit IS NULL OR dose_unit != 'DROPEAR')
-- 0

UPDATE vw_dose_unit  SET dose_unit = 'DROPEAR', dosage_form = 'Otic Solution'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%ear drops solution%'	
and (dose_unit IS NULL OR dose_unit != 'DROPEAR')
-- 0


UPDATE vw_dose_unit  SET dose_unit = 'SPRAYNOSTRIL', dosage_form = 'MeterNasalSpray'
-- select * from vw_dose_unit
where (ISNULL(generic_form_descr, form_descr) LIKE '%metered nose spray%'
	OR ISNULL(generic_form_descr, form_descr) LIKE '%metered dose nasal spray%')
and (dose_unit IS NULL OR dose_unit != 'SPRAYNOSTRIL')
-- 0


print 'K'
UPDATE vw_dose_unit  SET dose_unit = 'SPRAYNOSTRIL', dosage_form = 'Nasal Spray'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%nasal spray%'
and ISNULL(generic_form_descr, form_descr) NOT LIKE '%metered%'
and (dose_unit IS NULL OR dose_unit != 'SPRAYNOSTRIL')
-- 0


UPDATE vw_dose_unit  SET dose_unit = 'ML', dosage_form = 'Inhalant Soln'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%nebuliser solution%'
and (dose_unit IS NULL OR dose_unit != 'ML')
-- 0

UPDATE vw_dose_unit  SET dose_unit = 'VIAL', dosage_form = 'Inhalant Soln'
-- select * from vw_dose_unit
where (ISNULL(generic_form_descr, form_descr) LIKE '%inhalation solution%')
and ISNULL(generic_form_descr, form_descr) NOT LIKE '%nicotine%'
and (dose_unit IS NULL OR dose_unit != 'VIAL')
-- (38 row(s) affected)

UPDATE vw_dose_unit  SET dose_unit = 'VIAL', dosage_form = 'InhalationSusp'
-- select * from vw_dose_unit
where (ISNULL(generic_form_descr, form_descr) LIKE '%inhalation suspension%')
and ISNULL(generic_form_descr, form_descr) NOT LIKE '%nicotine%'
and (dose_unit IS NULL OR dose_unit != 'VIAL')

UPDATE vw_dose_unit  SET default_dispense_unit = 'VIAL'
-- select * from vw_dose_unit
where (ISNULL(generic_form_descr, form_descr) LIKE '%inhalation solution%'
	OR ISNULL(generic_form_descr, form_descr) LIKE '%inhalation suspension%')
and ISNULL(generic_form_descr, form_descr) NOT LIKE '%nicotine%'
and (default_dispense_unit IS NULL OR default_dispense_unit != 'VIAL')
-- (8 row(s) affected)

UPDATE pm 
SET administer_method = 'NEBULIZER'
-- select * 
FROM [c_Package_Administration_Method] pm
JOIN vw_dose_unit u ON u.package_id = pm.package_id
where (ISNULL(generic_form_descr, form_descr) LIKE '%inhalation solution%'
	OR ISNULL(generic_form_descr, form_descr) LIKE '%inhalation suspension%')
and ISNULL(generic_form_descr, form_descr) NOT LIKE '%nicotine%'
AND (administer_method IS NULL OR administer_method != 'NEBULIZER')
-- (8 row(s) affected)

print 'L'
UPDATE vw_dose_unit  SET dose_unit = 'CAP', dosage_form = 'Inhalant Powder'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%inhala% powder%'
and form_rxcui NOT IN (SELECT form_rxcui FROM #insulin)
AND (dose_unit IS NULL OR dose_unit != 'CAP')
-- (16 row(s) affected)

print 'M'
UPDATE pm 
SET administer_method = 'INHALE'
-- select * 
FROM [c_Package_Administration_Method] pm
JOIN vw_dose_unit u ON u.package_id = pm.package_id
where ISNULL(generic_form_descr, form_descr) LIKE '%inhala% powder%'
and form_rxcui NOT IN (SELECT form_rxcui FROM #insulin)
AND (administer_method IS NULL OR administer_method != 'INHALE')
-- (3 row(s) affected)

UPDATE vw_dose_unit  SET default_dispense_unit = 'CAP'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%inhala% powder%'
and form_rxcui NOT IN (SELECT form_rxcui FROM #insulin)
and (default_dispense_unit IS NULL OR default_dispense_unit != 'CAP')
-- (3 row(s) affected)

UPDATE vw_dose_unit  SET dose_unit = 'DROPNOSTRIL', dosage_form = 'Nasal Solution'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%nasal drop%'
and (dose_unit IS NULL OR dose_unit != 'DROPNOSTRIL')
-- 0

UPDATE vw_dose_unit  SET dose_unit = 'DROPNOSTRIL', dosage_form = 'Nasal Solution'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%nasal solution%'
and (dose_unit IS NULL OR dose_unit != 'DROPNOSTRIL')
-- 0

UPDATE vw_dose_unit  SET dose_unit = 'ML', dosage_form = 'Injectable Soln'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%solution for infusion%'
and (dose_unit IS NULL OR dose_unit != 'ML')
-- 0

print 'N'
UPDATE vw_dose_unit  SET dose_unit = 'SUPP', dosage_form = 'Rectal Suppos'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%rectal capsule%'
and (dose_unit IS NULL OR dose_unit != 'SUPP')
-- 0

UPDATE vw_dose_unit  SET dose_unit = 'APPLY', dosage_form = 'Rectal Ointment'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%rectal ointment%'
and (dose_unit IS NULL OR dose_unit != 'APPLY')
-- 0

UPDATE vw_dose_unit  SET dose_unit = 'APPLY', dosage_form = 'Topical Lotion'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%scalp lotion%'
and (dose_unit IS NULL OR dose_unit != 'APPLY')
-- 0

UPDATE vw_dose_unit  SET dose_unit = 'INSERT', dosage_form = 'VaginalInsert'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%vaginal%'
and ISNULL(generic_form_descr, form_descr) NOT LIKE '%implant%'
and (ISNULL(generic_form_descr, form_descr) LIKE '%tablet%'
or ISNULL(generic_form_descr, form_descr) LIKE '%capsule%'
or ISNULL(generic_form_descr, form_descr) LIKE '%ovule%'
or ISNULL(generic_form_descr, form_descr) LIKE '%suppository%'
or ISNULL(generic_form_descr, form_descr) LIKE '%pessary%'
or ISNULL(generic_form_descr, form_descr) LIKE '%insert%')
and (dose_unit IS NULL OR dose_unit != 'INSERT')
-- 0

print 'P'
UPDATE vw_dose_unit  SET dose_unit = 'ML', dosage_form = 'Injectable Foam'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%Injectable foam%'
and (dose_unit IS NULL OR dose_unit != 'ML')
-- 0

UPDATE vw_dose_unit  SET dose_unit = 'PATCH', dosage_form = 'Transdermal System'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%Transdermal Patch%'
and (dose_unit IS NULL OR dose_unit != 'PATCH')
-- (7 row(s) affected)

UPDATE pm 
SET administer_method = 'ON SKIN'
-- select * 
FROM [c_Package_Administration_Method] pm
JOIN vw_dose_unit u ON u.package_id = pm.package_id
where ISNULL(generic_form_descr, form_descr) LIKE '%Transdermal Patch%'
AND (administer_method IS NULL OR administer_method != 'ON SKIN')
-- (7 row(s) affected)

UPDATE vw_dose_unit  SET dose_unit = 'TSP', dosage_form = 'Mouthwash'
-- select * from vw_dose_unit
where (generic_form_descr LIKE '%Oral Rinse%' OR form_descr LIKE '%Oral Rinse%')
and (dose_unit IS NULL OR dose_unit != 'TSP')
-- 0

print 'Q'

UPDATE pm 
SET administer_method = 'SWISHSPIT'
-- select * 
FROM [c_Package_Administration_Method] pm
JOIN vw_dose_unit u ON u.package_id = pm.package_id
where (generic_form_descr LIKE '%Oral Rinse%' OR form_descr LIKE '%Oral Rinse%')
AND (administer_method IS NULL OR administer_method != 'SWISHSPIT')
-- 0

UPDATE vw_dose_unit  SET dose_unit = 'TAB', dosage_form = 'Oral Tab Sensor'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%Oral Tablet with Sensor%'
and (dose_unit IS NULL OR dose_unit != 'TAB')
-- (12 row(s) affected)

UPDATE vw_dose_unit  SET dose_unit = 'PUFF', dosage_form = 'Metered Inhaler'
-- select * from vw_dose_unit
where (ISNULL(generic_form_descr, form_descr) LIKE '%metered %inhal%' 
	OR ISNULL(generic_form_descr, form_descr) LIKE '%HFA Inhaler%')
and (dose_unit IS NULL OR dose_unit != 'PUFF')
-- (36 row(s) affected)

UPDATE vw_dose_unit SET default_dispense_unit = 'PUFF'
-- select * from vw_dose_unit
where (ISNULL(generic_form_descr, form_descr) LIKE '%metered %inhal%' 
	OR ISNULL(generic_form_descr, form_descr) LIKE '%HFA Inhaler%')
AND (default_dispense_unit IS NULL OR default_dispense_unit != 'PUFF')
-- (144 row(s) affected)

UPDATE pm 
SET administer_method = 'INHALE'
-- select * 
FROM [c_Package_Administration_Method] pm
JOIN vw_dose_unit u ON u.package_id = pm.package_id
where (ISNULL(generic_form_descr, form_descr) LIKE '%metered dose inhaler%' 
	OR ISNULL(generic_form_descr, form_descr) LIKE '%HFA Inhaler%')
AND (administer_method IS NULL OR administer_method != 'INHALE')
-- (36 row(s) affected)

print 'R'
UPDATE vw_dose_unit  SET dose_unit = 'INHALATION', dosage_form = 'DryPwdrInhaler'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%dry powder inhaler%'
and (dose_unit IS NULL OR dose_unit != 'INHALATION')
-- (13 row(s) affected)

print 'R'
UPDATE vw_dose_unit  SET default_dispense_unit = 'INHALATION'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%dry powder inhaler%'
and (default_dispense_unit IS NULL OR default_dispense_unit != 'INHALATION')
-- (18 row(s) affected)

UPDATE pm 
SET administer_method = 'INHALE'
-- select * 
FROM [c_Package_Administration_Method] pm
JOIN vw_dose_unit u ON u.package_id = pm.package_id
where ISNULL(generic_form_descr, form_descr) LIKE '%dry powder inhaler%'
AND (administer_method IS NULL OR administer_method != 'INHALE')
-- (8 row(s) affected)

UPDATE vw_dose_unit  SET dose_unit = 'TAB', dosage_form = 'Tab'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%oral tablet%'
and ISNULL(generic_form_descr, form_descr) NOT LIKE '%dispersible%'
and ISNULL(generic_form_descr, form_descr) NOT LIKE '%disintegrating%'
and ISNULL(generic_form_descr, form_descr) NOT LIKE '%sensor%'
and ISNULL(generic_form_descr, form_descr) NOT LIKE '%suspension%'
and ISNULL(generic_form_descr, form_descr) NOT LIKE '%release%'
and ISNULL(generic_form_descr, form_descr) NOT LIKE '%chewable%'
and ISNULL(generic_form_descr, form_descr) NOT LIKE '%effervescent%'
and (dose_unit IS NULL OR dose_unit != 'TAB')
-- (6 row(s) affected)

UPDATE vw_dose_unit  SET dose_unit = 'DROP', dosage_form = 'Drops Or'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%oral drops%'
AND (dose_unit IS NULL OR dose_unit != 'DROP')
-- 0

UPDATE vw_dose_unit  SET default_dispense_unit = 'DROP'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%oral drops%'
AND (default_dispense_unit IS NULL OR default_dispense_unit != 'DROP')
-- (7 row(s) affected)

print 'S'
UPDATE vw_dose_unit  SET dose_unit = 'PACKE', dosage_form = 'Oral Granules'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%oral granule%'
AND (dose_unit IS NULL OR dose_unit != 'PACKE')
-- (3 row(s) affected)

UPDATE vw_dose_unit  SET default_dispense_unit = 'PACKE'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) LIKE '%oral granule%'
AND (default_dispense_unit IS NULL OR default_dispense_unit != 'PACKE')
-- (40 row(s) affected)

print 'thrombin' 
UPDATE vw_dose_unit  SET dose_unit = 'SPRAY', dosage_form = 'Topical Spray'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) like '%topical spray%'
and generic_form_descr like '%thrombin%' 
AND (dose_unit IS NULL OR dose_unit != 'SPRAY')
-- (1 row(s) affected)

UPDATE vw_dose_unit  SET default_dispense_unit = 'SPRAY'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) like '%topical spray%'
and generic_form_descr like '%thrombin%' 
AND (default_dispense_unit IS NULL OR default_dispense_unit != 'SPRAY')
-- (1 row(s) affected)

UPDATE vw_dose_unit  SET dose_unit = 'PIECE', dosage_form = 'Chewing Gum'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) like '%chewing gum%'
AND (dose_unit IS NULL OR dose_unit != 'PIECE')
-- (10 row(s) affected)

UPDATE vw_dose_unit  SET default_dispense_unit = 'PIECE'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) like '%chewing gum%'
AND (default_dispense_unit IS NULL OR default_dispense_unit != 'PIECE')
-- (10 row(s) affected)


UPDATE pm 
SET administer_method = 'CHEWASDIR'
-- select * 
FROM [c_Package_Administration_Method] pm
JOIN vw_dose_unit u ON u.package_id = pm.package_id
where ISNULL(generic_form_descr, form_descr) like '%chewing gum%'
AND (administer_method IS NULL OR administer_method != 'CHEWASDIR')
-- (10 row(s) affected)

UPDATE vw_dose_unit  SET dose_unit = 'ML', dosage_form = 'Irrigation Soln'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) like '%irrigation%'
and ISNULL(generic_form_descr, form_descr) not like '%ophthalmic%'
AND (dose_unit IS NULL OR dose_unit != 'ML')
-- (1 row(s) affected)

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) like '%irrigation%'
and ISNULL(generic_form_descr, form_descr) not like '%ophthalmic%'
AND (default_dispense_unit IS NULL OR default_dispense_unit != 'ML')
-- (30 row(s) affected)

print 'U'
UPDATE pm 
SET administer_method = 'ASDIR'
-- select * 
FROM [c_Package_Administration_Method] pm
JOIN vw_dose_unit u ON u.package_id = pm.package_id
where ISNULL(generic_form_descr, form_descr) like '%irrigation%'
and ISNULL(generic_form_descr, form_descr) not like '%ophthalmic%'
AND (administer_method IS NULL OR administer_method != 'ASDIR')
-- (4 row(s) affected)

UPDATE vw_dose_unit  SET dose_unit = 'ML', dosage_form = 'Ophthalmic Irri'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) like '%ophthalmic irrigation%'
AND (dose_unit IS NULL OR dose_unit != 'ML')
-- 0

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) like '%ophthalmic irrigation%'
AND (default_dispense_unit IS NULL OR default_dispense_unit != 'ML')
-- (8 row(s) affected)

UPDATE pm 
SET administer_method = 'AFFECTED EYE'
-- select * 
FROM [c_Package_Administration_Method] pm
JOIN vw_dose_unit u ON u.package_id = pm.package_id
where ISNULL(generic_form_descr, form_descr) like '%ophthalmic irrigation%'
AND (administer_method IS NULL OR administer_method != 'AFFECTED EYE')
-- 0

print 'V'
UPDATE vw_dose_unit  SET dose_unit = 'APPLY', dosage_form = 'Topical Soln'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) like '%topical solution%'
and ISNULL(generic_form_descr, form_descr) not like '%mucous membrane%'
and form_descr not like '%drysol%' 
and form_descr not like '%hypercare%'
and form_descr not like '%xerac%'
and form_descr not like '%hemox%'
and form_descr not like '%lumicain%'
and form_descr not like '%axiron%'
and ISNULL(generic_form_descr, form_descr) not like '%testosterone%'
AND (dose_unit IS NULL OR dose_unit != 'APPLY')
-- (11 row(s) affected)

UPDATE vw_dose_unit  SET default_dispense_unit = 'APPLY'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) like '%topical solution%'
and ISNULL(generic_form_descr, form_descr) not like '%mucous membrane%'
and form_descr not like '%drysol%' 
and form_descr not like '%hypercare%'
and form_descr not like '%xerac%'
and form_descr not like '%hemox%'
and form_descr not like '%lumicain%'
and form_descr not like '%axiron%'
and ISNULL(generic_form_descr, form_descr) not like '%testosterone%'
AND (default_dispense_unit IS NULL OR default_dispense_unit != 'APPLY')
-- (20 row(s) affected)

UPDATE pm 
SET administer_method = 'APPLY'
-- select * 
FROM [c_Package_Administration_Method] pm
JOIN vw_dose_unit u ON u.package_id = pm.package_id
where ISNULL(generic_form_descr, form_descr) like '%topical solution%'
and ISNULL(generic_form_descr, form_descr) not like '%mucous membrane%'
and form_descr not like '%drysol%' 
and form_descr not like '%hypercare%'
and form_descr not like '%xerac%'
and form_descr not like '%hemox%'
and form_descr not like '%lumicain%'
and form_descr not like '%axiron%'
and ISNULL(generic_form_descr, form_descr) not like '%testosterone%'
AND (administer_method IS NULL OR administer_method != 'APPLY')
-- (7 row(s) affected)

UPDATE vw_dose_unit  SET dose_unit = 'APPLY'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) like '%aluminum chloride %Topical Solution%'
AND dosage_form = 'Topical Soln'
AND (dose_unit IS NULL OR dose_unit != 'APPLY')
-- (4 row(s) affected)

UPDATE vw_dose_unit  SET default_dispense_unit = 'APPLY'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) like '%aluminum chloride %Topical Solution%'
AND dosage_form = 'Topical Soln'
AND (default_dispense_unit IS NULL OR default_dispense_unit != 'APPLY')
-- (4 row(s) affected)

UPDATE pm 
SET administer_method = 'TO ARMPITS'
-- select * 
FROM [c_Package_Administration_Method] pm
JOIN vw_dose_unit u ON u.package_id = pm.package_id
where ISNULL(generic_form_descr, form_descr) like '%aluminum chloride %Topical Solution%'
AND dosage_form = 'Topical Soln'
AND (administer_method IS NULL OR administer_method != 'TO ARMPITS')
-- (7 row(s) affected)

print 'W'
UPDATE vw_dose_unit  SET dose_unit = 'APPLY', dosage_form = 'Topical Soln'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) like '%topical solution%'
and (form_descr like '%AXIRON%' or ISNULL(generic_form_descr, form_descr) like '%Testosterone%')
AND (dose_unit IS NULL OR dose_unit != 'APPLY')
-- (2 row(s) affected)

UPDATE vw_dose_unit  SET default_dispense_unit = 'APPLY'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) like '%topical solution%'
and (form_descr like '%AXIRON%' or ISNULL(generic_form_descr, form_descr) like '%Testosterone%')
AND (default_dispense_unit IS NULL OR default_dispense_unit != 'APPLY')
-- 0

UPDATE pm 
SET administer_method = 'TO ARMPITS'
-- select * 
FROM [c_Package_Administration_Method] pm
JOIN vw_dose_unit u ON u.package_id = pm.package_id
where ISNULL(generic_form_descr, form_descr) like '%topical solution%'
and (form_descr like '%AXIRON%' or ISNULL(generic_form_descr, form_descr) like '%Testosterone%')
AND (administer_method IS NULL OR administer_method != 'TO ARMPITS')
-- 0

UPDATE vw_dose_unit  SET dose_unit = 'APPLY', dosage_form = 'Topical Soln'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) like '%topical solution%'
and (form_descr like '%drysol%' 
or form_descr like '%hypercare%'
or form_descr like '%xerac%') 
and ISNULL(generic_form_descr, form_descr) not like '%mucous membrane%'
AND (dose_unit IS NULL OR dose_unit != 'APPLY')
-- 0

UPDATE vw_dose_unit  SET default_dispense_unit = 'APPLY'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) like '%topical solution%'
and (form_descr like '%drysol%' 
or form_descr like '%hypercare%'
or form_descr like '%xerac%') 
and ISNULL(generic_form_descr, form_descr) not like '%mucous membrane%'
AND (default_dispense_unit IS NULL OR default_dispense_unit != 'APPLY')
-- 0

print 'X'
UPDATE pm 
SET administer_method = 'TO ARMPITS'
-- select * 
FROM [c_Package_Administration_Method] pm
JOIN vw_dose_unit u ON u.package_id = pm.package_id
where ISNULL(generic_form_descr, form_descr) like '%topical solution%'
and (form_descr like '%drysol%' 
or form_descr like '%hypercare%'
or form_descr like '%xerac%') 
and ISNULL(generic_form_descr, form_descr) not like '%mucous membrane%'
AND (administer_method IS NULL OR administer_method != 'TO ARMPITS')
-- 0

UPDATE vw_dose_unit  SET dose_unit = 'APPLY', dosage_form = 'Topical Soln'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) like '%topical solution%'
and (form_descr like '%hemox A%' 
or form_descr like '%lumicain%')
and ISNULL(generic_form_descr, form_descr) not like '%mucous membrane%'
AND (dose_unit IS NULL OR dose_unit != 'APPLY')
-- 0

UPDATE vw_dose_unit  SET default_dispense_unit = 'APPLY'
-- select * from vw_dose_unit
where ISNULL(generic_form_descr, form_descr) like '%topical solution%'
and (form_descr like '%hemox A%' 
or form_descr like '%lumicain%')
and ISNULL(generic_form_descr, form_descr) not like '%mucous membrane%'
AND (default_dispense_unit IS NULL OR default_dispense_unit != 'APPLY')
-- 0

print 'Y'
UPDATE pm 
SET administer_method = 'ASDIR'
-- select * 
FROM [c_Package_Administration_Method] pm
JOIN vw_dose_unit u ON u.package_id = pm.package_id
where ISNULL(generic_form_descr, form_descr) like '%topical solution%'
and (form_descr like '%hemox A%' 
or form_descr like '%lumicain%')
and ISNULL(generic_form_descr, form_descr) not like '%mucous membrane%'
AND (administer_method IS NULL OR administer_method != 'ASDIR')
-- (2 row(s) affected)

-- administer_method = '-' to allow clinician to accept proper eye/ear/nostril at runtime
UPDATE pm 
SET administer_method = '-'
-- select * 
FROM [c_Package_Administration_Method] pm
JOIN vw_dose_unit u ON u.package_id = pm.package_id
WHERE dose_unit IN ('APPLYEYE', 'APPLYEAR', 'DROPEAR', 'DROPEYE', 'DROPNOSTRIL', 
	'INSERTEYE', 'ACTUATNOSTRIL', 'SPRAYNOSTRIL')
AND (administer_method IS NULL OR administer_method != '-')
-- (1029 row(s) affected)


-- Fill in missing values

UPDATE v 
SET default_dispense_unit = 'PATCH'
FROM vw_dose_unit v
WHERE default_dispense_unit is null AND ISNULL(generic_form_descr, form_descr) LIKE '%transderm%'

UPDATE v 
SET dose_unit = 'PATCH', dosage_form = 'Patch'
-- select * 
FROM vw_dose_unit v
WHERE dosage_form is null AND ISNULL(generic_form_descr, form_descr) LIKE '%transderm%'

UPDATE vw_dose_unit SET default_dispense_unit = 'NOSEPIECE'
WHERE form_descr like '%Nasal Powder'

UPDATE v 
SET default_dispense_unit = 'PEN'
FROM vw_dose_unit v
WHERE default_dispense_unit is null AND dosage_form = 'Pen Injector'

UPDATE v 
SET default_dispense_unit = 'LITER'
FROM vw_dose_unit v
WHERE default_dispense_unit is null AND dosage_form = 'Enema'

UPDATE vw_dose_unit
SET default_dispense_unit = dose_unit
WHERE default_dispense_unit is null
AND dose_unit IN ('APPLICATOR','APPLY','CAP',
'CM','DEVI','IMPL','GRAM','INHALATION',
'INSERT','LOZG','ML','PACKE','PATCH',
'PUFF','SPRAY','STRIP','SUPP','TAB','TBL','TSP')

UPDATE vw_dose_unit
SET default_dispense_unit = 'ML'
WHERE default_dispense_unit is null
AND dose_unit = 'DROPEAR'

UPDATE vw_dose_unit
SET default_dispense_unit = 'Bottle'
WHERE default_dispense_unit is null
AND dose_unit = 'DROPNOSTRIL'

UPDATE vw_dose_unit
SET default_dispense_unit = 'SPRAY'
WHERE default_dispense_unit is null
AND dose_unit = 'SPRAYNOSTRIL'

UPDATE vw_dose_unit
SET default_dispense_unit = 'GRAM'
WHERE default_dispense_unit = 'GM'

UPDATE pm 
SET administer_method = 'PR'
-- select * 
FROM [c_Package_Administration_Method] pm
JOIN vw_dose_unit u ON u.package_id = pm.package_id
WHERE dosage_form = 'Rectal Suppos'
AND administer_method IS NULL

UPDATE pm 
SET administer_method = 'ON SKIN'
-- select * 
FROM [c_Package_Administration_Method] pm
JOIN vw_dose_unit u ON u.package_id = pm.package_id
WHERE dosage_form = 'Patch'
AND administer_method IS NULL

EXEC sp_add_missing_drug_defn_pkg_adm_method