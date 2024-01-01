IF  EXISTS (SELECT * FROM sys.objects 
where object_id = OBJECT_ID(N'vw_dose_unit') AND type in (N'V'))
DROP VIEW vw_dose_unit
GO
CREATE VIEW vw_dose_unit AS
SELECT p.dose_unit, dp.default_dispense_unit, p.dosage_form, pm.administer_method, f.form_rxcui, f.form_descr
from c_Drug_Formulation f
join c_Drug_Package dp ON dp.form_rxcui = f.form_rxcui
join c_Package p on p.package_id = dp.package_id
join c_Package_Administration_Method pm on dp.package_id = pm.package_id
-- where f.valid_in NOT IN ('Suppress','TPN Suppress','Retired')

GO

SELECT form_rxcui 
INTO #insulin_null
FROM c_Drug_Formulation f
JOIN c_Drug_Generic g ON g.generic_rxcui = f.ingr_rxcui
where g.generic_name like '%insulin%'
UNION
SELECT form_rxcui 
FROM c_Drug_Formulation f
JOIN c_Drug_Brand b ON b.brand_name_rxcui = f.ingr_rxcui
JOIn c_Drug_Generic g ON g.generic_rxcui = b.generic_rxcui
where g.generic_name like '%insulin%'
--(131 row(s) affected)

SELECT form_rxcui
INTO #oral_multi_null
FROM c_Drug_Formulation f
JOIN c_Drug_Generic g ON g.generic_rxcui = f.ingr_rxcui
where g.generic_name like '%/%'
and f.form_descr like '%Oral s%'
UNION
SELECT form_rxcui
FROM c_Drug_Formulation f
JOIN c_Drug_Brand b ON b.brand_name_rxcui = f.ingr_rxcui
JOIn c_Drug_Generic g ON g.generic_rxcui = b.generic_rxcui
where g.generic_name like '%/%'
and f.form_descr like '%Oral s%'
-- (659 row(s) affected)

SELECT form_rxcui
INTO #oral_single_null
FROM c_Drug_Formulation f
JOIN c_Drug_Generic g ON g.generic_rxcui = f.ingr_rxcui
where g.generic_name not like '%/%'
and f.form_descr like '%Oral s%'
UNION
SELECT form_rxcui
FROM c_Drug_Formulation f
JOIN c_Drug_Brand b ON b.brand_name_rxcui = f.ingr_rxcui
JOIn c_Drug_Generic g ON g.generic_rxcui = b.generic_rxcui
where g.generic_name not like '%/%'
and f.form_descr like '%Oral s%'
-- (948 row(s) affected)

-- Scripted from 01_29_2020 KenyaRetentionDrugsUpdate.xlsx (2021)
-- with reference to 08_14_2020_Injectables Present and Not Present in KE_Formulary.xlsx

UPDATE vw_dose_unit SET dose_unit = 'UNIT',	dosage_form = 'Pen Injector'
where form_rxcui IN (SELECT form_rxcui FROM #insulin_null)
AND (form_descr like '%pen injector%' OR form_descr like '%prefilled pen%')
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'UNIT', dosage_form = 'Cartridge'
where form_rxcui IN (SELECT form_rxcui FROM #insulin_null)
AND form_descr like '%inhalation powder%'
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'UNIT', dosage_form = 'Cartridge'
where form_rxcui IN (SELECT form_rxcui FROM #insulin_null)
AND form_descr not like '%inhalation powder%'
and form_descr  like '%cartridge%'
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'UNIT', dosage_form = 'Injectable Soln'
where  form_rxcui IN (SELECT form_rxcui FROM #insulin_null)
and form_descr like '%Injectable solution%'	
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'UNIT', dosage_form = 'Injectable Susp'
where  form_rxcui IN (SELECT form_rxcui FROM #insulin_null)
and form_descr like '%Injectable suspension%'
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'UNIT', dosage_form = 'Injectable Susp'
where form_rxcui IN (SELECT form_rxcui FROM #insulin_null)
and form_descr  like '%suspension for injection%'
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'UNIT', dosage_form = 'Injectable Soln'
where form_rxcui IN (SELECT form_rxcui FROM #insulin_null)
and form_descr  like '%solution for injection%'
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'ML', dosage_form = 'Oral Solution'
where form_descr like '%oral solution%'
and form_descr not like '%MG%'
and form_descr not like '%ML%'
and form_descr not like '%powder%'
and form_descr not like '%granules%'
and form_descr not like '%drops%'
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'MG', dosage_form = 'Oral Solution'
where form_descr like '%oral solution%'
and form_descr like '%MG%'
and form_descr not like '%ML%'
and form_descr not like '%powder%'
and form_descr not like '%granules%'
and form_descr not like '%drops%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single_null)
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'ML', dosage_form = 'Oral Solution'
where form_descr like '%oral solution%'
and form_descr like '%MG%'
and form_descr not like '%ML%'
and form_descr not like '%powder%'
and form_descr not like '%granules%'
and form_descr not like '%drops%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_multi_null)
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'ML', dosage_form = 'Oral Solution'
where form_descr like '%oral solution%'
and form_descr like '%MG%'
and form_descr like '%ML%'
and form_descr not like '%powder%'
and form_descr not like '%granules%'
and form_descr not like '%drop%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single_null)
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'ML', dosage_form = 'Oral Solution'
where form_descr like '%Oral Solution%'
and form_descr like '%MG%'
and form_descr like '%ML%'
and form_descr not like '%powder%'
and form_descr not like '%granules%'
and form_descr not like '%drop%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_multi_null)
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'ML', dosage_form = 'Oral Solution'
where form_descr like '%oral Solution%'
and form_descr like '%UNT%'
and form_descr not like '%MCG%'
and form_descr like '%ML%'
and form_descr not like '%powder%'
and form_descr not like '%granules%'
and form_descr not like '%drop%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single_null)
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'ML', dosage_form = 'Oral Solution'
where form_descr like '%oral Solution%'
and form_descr like '%UNT%'
and form_descr like '%MCG%'
and form_descr like '%ML%'
and form_descr not like '%powder%'
and form_descr not like '%granules%'
and form_descr not like '%drop%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single_null)
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'ML', dosage_form = 'Oral Solution'
where form_descr like '%oral Solution%'
and form_descr like '%UNT%'
and form_descr like '%ML%'
and form_descr not like '%MG%'
and form_descr not like '%powder%'
and form_descr not like '%granules%'
and form_descr not like '%drop%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_multi_null)
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'ML', dosage_form = 'Oral Solution'
where form_descr like '%oral Solution%'
and form_descr like '%MCG%'
and form_descr like '%ML%'
and form_descr not like '%powder%'
and form_descr not like '%granules%'
and form_descr not like '%drop%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single_null)
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'ML', dosage_form = 'Oral Solution'
where form_descr like '%oral Solution%'
and form_descr like '%GM%'
and form_descr like '%ML%'
and form_descr not like '%powder%'
and form_descr not like '%granules%'
and form_descr not like '%drop%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single_null)
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'ML', dosage_form = 'Oral Solution'
where form_descr like '%oral Solution%'
and form_descr like '%MEQ%'
and form_descr like '%ML%'
and form_descr not like '%powder%'
and form_descr not like '%granules%'
and form_descr not like '%drop%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single_null)
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'ML', dosage_form = 'Oral Solution'
where form_descr like '%oral Solution%'
and form_descr like '%ML%'
and form_descr not like '%powder%'
and form_descr not like '%granules%'
and form_descr not like '%drop%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_multi_null)
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'MG', dosage_form = 'Pwdr Oral Soln'
where form_descr like '%Oral Solution%'
and form_descr like '%MG%'
and form_descr like '%powder%'
and form_descr not like '%ML%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single_null)
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'MEQ', dosage_form = 'Pwdr Oral Soln'
where form_descr like '%Oral Solution%'
and form_descr like '%MEQ%'
and form_descr like '%powder%'
and form_descr not like '%ML%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single_null)
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'GRAM', dosage_form = 'Pwdr Oral Soln'
where form_descr like '%oral Solution%'
and form_descr like '%powder%'
and form_descr like '%GM%'
and form_descr not like '%MG%'
and form_descr not like '%MEQ%'
and form_descr not like '%ML%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single_null)
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'ML', dosage_form = 'Pwdr Oral Soln'
where form_descr like '%oral Solution%'
and form_descr like '%powder%'
and form_descr like '%ML%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single_null)
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'ML', dosage_form = 'Pwdr Oral Soln'
where form_descr like '%oral Solution%'
and form_descr like '%powder%'
and form_descr like '%MG%'
and form_descr like '%ML%'
and form_descr not like '%GM%'
and form_descr not like '%MCG%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_multi_null)
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'PACKE', dosage_form = 'Pwdr Oral Soln'
where form_descr like '%oral Solution%'
and form_descr like '%powder%'
and form_descr like '%MG%'
and form_descr not like '%GM%'
and form_descr not like '%MCG%'
and form_descr not like '%ML%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_multi_null)
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'PACKE', dosage_form = 'Pwdr Oral Soln'
where form_descr like '%oral Solution%'
and form_descr like '%powder%'
and form_descr like '%MG%'
and form_descr like '%MCG%'
and form_descr not like '%ML%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_multi_null)
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'PACKE', dosage_form = 'Pwdr Oral Soln'
where form_descr like '%oral Solution%'
and form_descr like '%powder%'
and form_descr like '%GM%'
and form_descr like '%MG%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_multi_null)
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'LITER', dosage_form = 'Pwdr Oral Soln'
where form_descr like '%oral Solution%'
and form_descr like '%powder%'
and form_descr like '%GM%'
and form_descr not like '%MG%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_multi_null)
and dose_unit is null

UPDATE p SET dose_unit = 'PACKE', dosage_form = 'Pwdr Oral Soln'
-- select *
from c_Drug_Formulation f
join c_Drug_Package dp ON dp.form_rxcui = f.form_rxcui
join c_Package p on p.package_id = dp.package_id
JOIN c_Drug_Brand b ON b.brand_name_rxcui = f.ingr_rxcui
JOIn c_Drug_Generic g ON g.generic_rxcui = b.generic_rxcui
where g.generic_name like '%citric acid%'
and g.generic_name like '%sodium bicarbonate%'
and form_descr like '%powder%'
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'PACKE', dosage_form = 'Granules'
where form_descr like '%oral solution%'
and form_descr like '%GRANULES%'
and form_descr like '%IU%'
and form_descr not like '%MG%'
and form_descr not like '%GM%'
and form_descr not like '%MCG%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single_null)
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'GRAM', dosage_form = 'Granules'
where form_descr like '%oral solution%'
and form_descr like '%GRANULES%'
and form_descr like '%GM%'
and form_descr not like '%MG%'
and form_descr not like '%GM%'
and form_descr not like '%MCG%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single_null)
and dose_unit is null
-- 0

UPDATE vw_dose_unit  SET dose_unit = 'MG', dosage_form = 'Granules'
where form_descr like '%oral solution%'
and form_descr like '%GRANULES%'
and form_descr like '%MG%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_multi_null)
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'TSP', dosage_form = 'Granules'
where form_descr like '%oral solution%'
and form_descr like '%GRANULES%'
and form_descr like '%GM%'
and form_descr not like '%MG%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_multi_null)
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'PACKE', dosage_form = 'Granules'
where form_descr like '%oral solution%'
and form_descr like '%GRANULES%'
and form_descr like '%MG%'
and form_descr like '%GM%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_multi_null)
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'DROP', dosage_form = 'Oral Solution'
where form_descr like '%oral solution%'
and form_descr like '%DROPS%'
and form_descr NOT like '%lozenge%'
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'ML', dosage_form = 'Oral Suspension'
where form_descr like '%oral suspension%'
and form_descr not like '%powder%'
and form_descr not like '%mg%'
and form_descr not like '%GM%'
and form_descr not like '%UNT%'
and form_descr not like '%UNITS%'
and form_descr not like '%IU%'
and form_descr not like '%[%]%'
and form_descr like '%ML%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single_null)
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'ML', dosage_form = 'Oral Suspension'
where form_descr like '%oral suspension%'
and form_descr like '%MG%'
and form_descr not like '%powder%'
and form_descr not like '%GRANULES%'
and form_descr not like '%TABLET%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single_null)
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'ML', dosage_form = 'Oral Suspension'
where form_descr like '%oral suspension%'
and form_descr like '%GM%'
and form_descr not like '%powder%'
and form_descr not like '%GRANULES%'
and form_descr not like '%TABLET%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single_null)
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'ML', dosage_form = 'Oral Suspension'
where form_descr like '%oral suspension%'
and form_descr like '%UNITS%'
and form_descr not like '%powder%'
and form_descr not like '%GRANULES%'
and form_descr not like '%TABLET%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single_null)
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'UNIT', dosage_form = 'Oral Suspension'
where form_descr like '%oral suspension%'
and form_descr like '%UNT%'
and form_descr not like '%powder%'
and form_descr not like '%GRANULES%'
and form_descr not like '%TABLET%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single_null)
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'ML', dosage_form = 'Oral Suspension'
where form_descr like '%oral suspension%'
and  form_descr like '%ML%'
and form_descr not like '%powder%'
and form_descr not like '%GRANULES%'
and form_descr not like '%TABLET%'
and form_descr not like '%UNT%'
and form_descr not like '%MG%'
and form_descr not like '%GM%'
and form_descr not like '%UNIT%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single_null)
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'ML', dosage_form = 'Pwdrr Oral Susp'
where form_descr like '%oral suspension%'
and form_descr not like '%powder%'
and form_descr not like '%GRANULES%'
and form_descr not like '%TABLET%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_multi_null)
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'ML', dosage_form = 'Pwdrr Oral Susp'
where form_descr like '%oral suspension%'
and form_descr like '%powder%'
and form_descr not like '%granules%'
and form_descr not like '%tablet%'
and form_descr  like '%ML%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_multi_null)
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'MG', dosage_form = 'Pwdrr Oral Susp'
where form_descr like '%oral suspension%'
and form_descr like '%powder%'
and form_descr not like '%granules%'
and form_descr not like '%tablet%'
and form_descr  not like '%ML%'
and form_descr like '%MG%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_multi_null)
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'TAB', dosage_form = 'TabletOralSusp'
where form_descr like '%tablet oral suspension%'
-- 0

UPDATE vw_dose_unit  SET dose_unit = 'MG', dosage_form = 'Pwdrr Oral Susp'
where form_descr like '%DRY suspension%'
and form_descr like '%MG%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single_null)
-- 0

UPDATE vw_dose_unit  SET dose_unit = 'ML', dosage_form = 'Pwdrr Oral Susp'
where form_descr like '%DRY suspension%'
and form_descr like '%MG%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_multi_null)
-- 0

UPDATE vw_dose_unit  SET dose_unit = 'ML', dosage_form = 'Oral Solution'
where form_descr like '%oral syrup%'
and form_descr not like '%oral solution%'
and form_descr like '%MG%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single_null)
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'ML', dosage_form = 'Oral Solution'
where form_descr like '%ORAL Syrup%'
and form_descr not like '%oral solution%'
and form_descr like '%mg%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_multi_null)
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'ML', dosage_form = 'Oral Solution'
where form_descr like '%ORAL Syrup%'
and form_descr not like '%oral solution%'
and form_descr not like '%mg%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single_null)
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'ML', dosage_form = 'Oral Solution'
where form_descr like '%oral syrup%'
and form_descr not like '%oral solution%'
and form_descr like '%[%]%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single_null)
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'TAB', dosage_form = 'DisOral Tab'
where form_descr like '%orodispersible%'
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'TAB', dosage_form = 'DisOral Tab'
where form_descr like '%disintegrating%'
and form_descr like '%oral%'
and form_descr like '%tablet%'
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'STRIP', dosage_form = 'STRIP'
where form_descr like '%oral%' 
and form_descr like '%strip%'
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'FILM', dosage_form = 'FILM'
where form_descr like '%disintegrating%'
and form_descr like '%oral%'
and form_descr like '%strip%'
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'APPLY', dosage_form = 'Topical Cream'
where (form_descr like '%skin cream%'
 or form_descr like '%topical cream%')
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'UNIT', dosage_form = 'Pen Injector'
where (form_descr like '% pen injector%'
or form_descr like '%prefilled pen%')
and form_rxcui NOT IN (SELECT form_rxcui FROM #insulin_null)
and form_descr like '%UNT%'
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'MG', dosage_form = 'Pen Injector'
where (form_descr like '% pen injector%'
or form_descr like '%prefilled pen%')
and form_rxcui NOT IN (SELECT form_rxcui FROM #insulin_null)
and form_descr like '%MG%'
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'MCG', dosage_form = 'Pen Injector'
where (form_descr like '% pen injector%'
or form_descr like '%prefilled pen%')
and form_rxcui NOT IN (SELECT form_rxcui FROM #insulin_null)
and form_descr like '%MCG%'
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'DROP', dosage_form = 'MucousMemSoln'
where form_descr like '%mouth paint%'
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'DROPEYE', dosage_form = 'Ophthalmic Soln'
where form_descr like '%eye drop solution%'
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'DROPEYE', dosage_form = 'Ophthalmic Susp'
where form_descr like '%eye drop suspension%'
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'DROPEYE', dosage_form = 'Ophthalmic Soln'
where form_descr like '%eye drops%'	
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'APPLYEYE', dosage_form = 'Ophthalmic Oint'
where form_descr like '%eye ointment%'
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'APPLYEYE', dosage_form = 'Ophthalmic Oint'
where form_descr like '%ophthalmic ointment%'
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'DROPEAR', dosage_form = 'Otic Solution'
where form_descr like '%otic solution%'
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'DROPEAR', dosage_form = 'Otic Suspension'
where form_descr like '%otic suspension%'
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'DROPEAR', dosage_form = 'Otic Solution'
where form_descr like '%otic drop%'	
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'DROPEAR', dosage_form = 'Otic Suspension'
where form_descr like '%otic drops suspension%'
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'DROPEAR', dosage_form = 'Otic Lotion'
where form_descr like '%otic lotion%'	
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'DROPEAR', dosage_form = 'Otic Solution'
where form_descr like '%ear drops solution%'	
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'PUFF', dosage_form = 'Metered Inhaler'
where form_descr like '%HFA Inhaler%'
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'SPRAYNOSTRIL', dosage_form = 'MeterNasalSpray'
where form_descr like '%metered nose spray%'
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'SPRAYNOSTRIL', dosage_form = 'MeterNasalSpray'
where form_descr like '%metered dose nasal spray%'
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'ML', dosage_form = 'Inhalant Soln'
where form_descr like '%nebuliser solution%'
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'UNIT', dosage_form = 'Inhalant Powder'
where form_descr like '%inhalation powder%'
and form_descr like '%UNT%'
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'MCG', dosage_form = 'Inhalant Powder'
where form_descr like '%inhalation powder%'
and form_descr like '%MCG%'
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'MG', dosage_form = 'Inhalant Powder'
where form_descr like '%inhalation powder%'
and form_descr like '%MG%'
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'DROPNOSTRIL', dosage_form = 'Nasal Solution'
where form_descr like '%nasal drop%'
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'DROPNOSTRIL', dosage_form = 'Nasal Solution'
where form_descr like '%nasal solution%'
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'SPRAYNOSTRIL', dosage_form = 'Nasal Spray'
where form_descr like '%nasal spray%'
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'ML', dosage_form = 'Injectable Soln'
where form_descr like '%solution for infusion%'
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'SUPP', dosage_form = 'Rectal Suppos'
where form_descr like '%rectal capsule%'
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'APPLY', dosage_form = 'Rectal Ointment'
where form_descr like '%rectal ointment%'
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'APPLY', dosage_form = 'Topical Lotion'
where form_descr like '%scalp lotion%'
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'INSERT', dosage_form = 'VaginalInsert'
where form_descr like '%vaginal%'
and form_descr not like '%implant%'
and (form_descr like '%tablet%'
or form_descr  like '%capsule%'
or form_descr  like '%ovule%'
or form_descr  like '%suppository%'
or form_descr  like '%pessary%'
or form_descr  like '%insert%')
and dose_unit is null

UPDATE vw_dose_unit  SET dose_unit = 'ML', dosage_form = 'Injectable Foam'
where form_descr like '%Injectable foam%'
and dose_unit is null
