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
INTO #insulin2
FROM c_Drug_Formulation f
JOIN c_Drug_Generic g ON g.generic_rxcui = f.ingr_rxcui
where g.generic_name like '%insulin%'
UNION
SELECT form_rxcui 
FROM c_Drug_Formulation f
JOIN c_Drug_Brand b ON b.brand_name_rxcui = f.ingr_rxcui
JOIn c_Drug_Generic g ON g.generic_rxcui = b.generic_rxcui
where g.generic_name like '%insulin%'
--(134 row(s) affected)

SELECT form_rxcui
INTO #oral_multi2
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
-- (670 row(s) affected)

SELECT form_rxcui
INTO #oral_single2
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
-- (950 row(s) affected)

UPDATE vw_dose_unit SET default_dispense_unit = 'PEN'
where form_rxcui IN (SELECT form_rxcui FROM #insulin2)
AND (form_descr like '%pen injector%' OR form_descr like '%prefilled pen%')

UPDATE vw_dose_unit  SET default_dispense_unit = 'Cartridge'
where form_rxcui IN (SELECT form_rxcui FROM #insulin2)
AND form_descr like '%inhalation powder%'

UPDATE vw_dose_unit  SET default_dispense_unit = 'Cartridge'
where form_rxcui IN (SELECT form_rxcui FROM #insulin2)
AND form_descr not like '%inhalation powder%'
and form_descr  like '%cartridge%'

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
where  form_rxcui IN (SELECT form_rxcui FROM #insulin2)
and form_descr like '%Injectable solution%'	

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
where  form_rxcui IN (SELECT form_rxcui FROM #insulin2)
and form_descr like '%Injectable suspension%'

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
where form_rxcui IN (SELECT form_rxcui FROM #insulin2)
and form_descr  like '%suspension for injection%'

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
where form_rxcui IN (SELECT form_rxcui FROM #insulin2)
and form_descr  like '%solution for injection%'

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
where form_descr like '%oral solution%'
and form_descr not like '%MG%'
and form_descr not like '%ML%'
and form_descr not like '%powder%'
and form_descr not like '%granules%'
and form_descr not like '%drops%'

UPDATE vw_dose_unit  SET default_dispense_unit = 'MG'
where form_descr like '%oral solution%'
and form_descr like '%MG%'
and form_descr not like '%ML%'
and form_descr not like '%powder%'
and form_descr not like '%granules%'
and form_descr not like '%drops%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single2)

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
where form_descr like '%oral solution%'
and form_descr like '%MG%'
and form_descr not like '%ML%'
and form_descr not like '%powder%'
and form_descr not like '%granules%'
and form_descr not like '%drops%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_multi2)

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
where form_descr like '%oral solution%'
and form_descr like '%MG%'
and form_descr like '%ML%'
and form_descr not like '%powder%'
and form_descr not like '%granules%'
and form_descr not like '%drop%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single2)

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
where form_descr like '%Oral Solution%'
and form_descr like '%MG%'
and form_descr like '%ML%'
and form_descr not like '%powder%'
and form_descr not like '%granules%'
and form_descr not like '%drop%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_multi2)

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
where form_descr like '%oral Solution%'
and form_descr like '%UNT%'
and form_descr not like '%MCG%'
and form_descr like '%ML%'
and form_descr not like '%powder%'
and form_descr not like '%granules%'
and form_descr not like '%drop%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single2)

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
where form_descr like '%oral Solution%'
and form_descr like '%UNT%'
and form_descr like '%MCG%'
and form_descr like '%ML%'
and form_descr not like '%powder%'
and form_descr not like '%granules%'
and form_descr not like '%drop%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single2)

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
where form_descr like '%oral Solution%'
and form_descr like '%UNT%'
and form_descr like '%ML%'
and form_descr not like '%MG%'
and form_descr not like '%powder%'
and form_descr not like '%granules%'
and form_descr not like '%drop%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_multi2)

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
where form_descr like '%oral Solution%'
and form_descr like '%MCG%'
and form_descr like '%ML%'
and form_descr not like '%powder%'
and form_descr not like '%granules%'
and form_descr not like '%drop%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single2)

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
where form_descr like '%oral Solution%'
and form_descr like '%GM%'
and form_descr like '%ML%'
and form_descr not like '%powder%'
and form_descr not like '%granules%'
and form_descr not like '%drop%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single2)

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
where form_descr like '%oral Solution%'
and form_descr like '%MEQ%'
and form_descr like '%ML%'
and form_descr not like '%powder%'
and form_descr not like '%granules%'
and form_descr not like '%drop%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single2)

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
where form_descr like '%oral Solution%'
and form_descr like '%ML%'
and form_descr not like '%powder%'
and form_descr not like '%granules%'
and form_descr not like '%drop%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_multi2)

UPDATE vw_dose_unit  SET default_dispense_unit = 'MG'
where form_descr like '%Oral Solution%'
and form_descr like '%MG%'
and form_descr like '%powder%'
and form_descr not like '%ML%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single2)

UPDATE vw_dose_unit  SET default_dispense_unit = 'MEQ'
where form_descr like '%Oral Solution%'
and form_descr like '%MEQ%'
and form_descr like '%powder%'
and form_descr not like '%ML%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single2)

UPDATE vw_dose_unit  SET default_dispense_unit = 'GM'
where form_descr like '%oral Solution%'
and form_descr like '%powder%'
and form_descr like '%GM%'
and form_descr not like '%MG%'
and form_descr not like '%MEQ%'
and form_descr not like '%ML%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single2)

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
where form_descr like '%oral Solution%'
and form_descr like '%powder%'
and form_descr like '%ML%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single2)

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
where form_descr like '%oral Solution%'
and form_descr like '%powder%'
and form_descr like '%MG%'
and form_descr like '%ML%'
and form_descr not like '%GM%'
and form_descr not like '%MCG%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_multi2)

UPDATE vw_dose_unit  SET default_dispense_unit = 'PACKE'
where form_descr like '%oral Solution%'
and form_descr like '%powder%'
and form_descr like '%MG%'
and form_descr not like '%GM%'
and form_descr not like '%MCG%'
and form_descr not like '%ML%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_multi2)

UPDATE vw_dose_unit  SET default_dispense_unit = 'PACKE'
where form_descr like '%oral Solution%'
and form_descr like '%powder%'
and form_descr like '%MG%'
and form_descr like '%MCG%'
and form_descr not like '%ML%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_multi2)

UPDATE vw_dose_unit  SET default_dispense_unit = 'PACKE'
where form_descr like '%oral Solution%'
and form_descr like '%powder%'
and form_descr like '%GM%'
and form_descr like '%MG%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_multi2)

UPDATE vw_dose_unit  SET default_dispense_unit = 'LITER'
where form_descr like '%oral Solution%'
and form_descr like '%powder%'
and form_descr like '%GM%'
and form_descr not like '%MG%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_multi2)

UPDATE dp SET default_dispense_unit = 'PACKE'
-- select *
from c_Drug_Formulation f
join c_Drug_Package dp ON dp.form_rxcui = f.form_rxcui
join c_Package p on p.package_id = dp.package_id
JOIN c_Drug_Brand b ON b.brand_name_rxcui = f.ingr_rxcui
JOIn c_Drug_Generic g ON g.generic_rxcui = b.generic_rxcui
where g.generic_name like '%citric acid%'
and g.generic_name like '%sodium bicarbonate%'
and form_descr like '%powder%'

UPDATE vw_dose_unit  SET default_dispense_unit = 'PACKE'
where form_descr like '%oral solution%'
and form_descr like '%GRANULES%'
and form_descr like '%IU%'
and form_descr not like '%MG%'
and form_descr not like '%GM%'
and form_descr not like '%MCG%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single2)

UPDATE vw_dose_unit  SET default_dispense_unit = 'GM'
where form_descr like '%oral solution%'
and form_descr like '%GRANULES%'
and form_descr like '%GM%'
and form_descr not like '%MG%'
and form_descr not like '%GM%'
and form_descr not like '%MCG%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single2)

UPDATE vw_dose_unit  SET default_dispense_unit = 'MG'
where form_descr like '%oral solution%'
and form_descr like '%GRANULES%'
and form_descr like '%MG%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_multi2)

UPDATE vw_dose_unit  SET default_dispense_unit = 'GM'
where form_descr like '%oral solution%'
and form_descr like '%GRANULES%'
and form_descr like '%GM%'
and form_descr not like '%MG%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_multi2)

UPDATE vw_dose_unit  SET default_dispense_unit = 'PACKE'
where form_descr like '%oral solution%'
and form_descr like '%GRANULES%'
and form_descr like '%MG%'
and form_descr like '%GM%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_multi2)

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
where form_descr like '%oral solution%'
and form_descr like '%DROPS%'
and form_descr NOT like '%lozenge%'

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
where form_descr like '%oral suspension%'
and form_descr not like '%powder%'
and form_descr not like '%mg%'
and form_descr not like '%GM%'
and form_descr not like '%UNT%'
and form_descr not like '%UNITS%'
and form_descr not like '%IU%'
and form_descr not like '%[%]%'
and form_descr like '%ML%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single2)

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
where form_descr like '%oral suspension%'
and form_descr like '%MG%'
and form_descr not like '%powder%'
and form_descr not like '%GRANULES%'
and form_descr not like '%TABLET%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single2)

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
where form_descr like '%oral suspension%'
and form_descr like '%GM%'
and form_descr not like '%powder%'
and form_descr not like '%GRANULES%'
and form_descr not like '%TABLET%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single2)

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
where form_descr like '%oral suspension%'
and form_descr like '%UNITS%'
and form_descr not like '%powder%'
and form_descr not like '%GRANULES%'
and form_descr not like '%TABLET%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single2)

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
where form_descr like '%oral suspension%'
and form_descr like '%UNT%'
and form_descr not like '%powder%'
and form_descr not like '%GRANULES%'
and form_descr not like '%TABLET%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single2)

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
where form_descr like '%oral suspension%'
and  form_descr like '%ML%'
and form_descr not like '%powder%'
and form_descr not like '%GRANULES%'
and form_descr not like '%TABLET%'
and form_descr not like '%UNT%'
and form_descr not like '%MG%'
and form_descr not like '%GM%'
and form_descr not like '%UNIT%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single2)

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
where form_descr like '%oral suspension%'
and form_descr not like '%powder%'
and form_descr not like '%GRANULES%'
and form_descr not like '%TABLET%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_multi2)

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
where form_descr like '%oral suspension%'
and form_descr like '%powder%'
and form_descr not like '%granules%'
and form_descr not like '%tablet%'
and form_descr  like '%ML%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_multi2)

UPDATE vw_dose_unit  SET default_dispense_unit = 'MG'
where form_descr like '%oral suspension%'
and form_descr like '%powder%'
and form_descr not like '%granules%'
and form_descr not like '%tablet%'
and form_descr  not like '%ML%'
and form_descr like '%MG%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_multi2)

UPDATE vw_dose_unit  SET default_dispense_unit = 'TABL'
where form_descr like '%tablet oral suspension%'

UPDATE vw_dose_unit  SET default_dispense_unit = 'MG'
where form_descr like '%DRY suspension%'
and form_descr like '%MG%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single2)

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
where form_descr like '%DRY suspension%'
and form_descr like '%MG%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_multi2)

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
where form_descr like '%oral syrup%'
and form_descr not like '%oral solution%'
and form_descr like '%MG%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single2)

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
where form_descr like '%ORAL Syrup%'
and form_descr not like '%oral solution%'
and form_descr like '%mg%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_multi2)

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
where form_descr like '%ORAL Syrup%'
and form_descr not like '%oral solution%'
and form_descr not like '%mg%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single2)

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
where form_descr like '%oral syrup%'
and form_descr not like '%oral solution%'
and form_descr like '%[%]%'
and form_rxcui IN (SELECT form_rxcui FROM #oral_single2)

UPDATE vw_dose_unit  SET default_dispense_unit = 'TAB'
where form_descr like '%orodispersible%'

UPDATE vw_dose_unit  SET default_dispense_unit = 'TAB'
where form_descr like '%disintegrating%'
and form_descr like '%oral%'
and form_descr like '%tablet%'

UPDATE vw_dose_unit  SET default_dispense_unit = 'STRIP'
where form_descr like '%oral%' 
and form_descr like '%strip%'

UPDATE vw_dose_unit  SET default_dispense_unit = 'FILM'
where form_descr like '%disintegrating%'
and form_descr like '%oral%'
and form_descr like '%strip%'

UPDATE vw_dose_unit  SET default_dispense_unit = 'MG'
where (form_descr like '%skin cream%'
 or form_descr like '%topical cream%')

UPDATE vw_dose_unit  SET default_dispense_unit = 'PEN'
where (form_descr like '% pen injector%'
or form_descr like '%prefilled pen%')
and form_rxcui NOT IN (SELECT form_rxcui FROM #insulin2)
and form_descr like '%UNT%'

UPDATE vw_dose_unit  SET default_dispense_unit = 'PEN'
where (form_descr like '% pen injector%'
or form_descr like '%prefilled pen%')
and form_rxcui NOT IN (SELECT form_rxcui FROM #insulin2)
and form_descr like '%MG%'

UPDATE vw_dose_unit  SET default_dispense_unit = 'PEN'
where (form_descr like '% pen injector%'
or form_descr like '%prefilled pen%')
and form_rxcui NOT IN (SELECT form_rxcui FROM #insulin2)
and form_descr like '%MCG%'

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
where form_descr like '%mouth paint%'

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
where form_descr like '%eye drop solution%'

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
where form_descr like '%eye drop suspension%'

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
where form_descr like '%eye drops%'	

UPDATE vw_dose_unit  SET default_dispense_unit = 'MG'
where form_descr like '%eye ointment%'

UPDATE vw_dose_unit  SET default_dispense_unit = 'MG'
where form_descr like '%ophthalmic ointment%'

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
where form_descr like '%otic solution%'

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
where form_descr like '%otic suspension%'

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
where form_descr like '%otic drop%'	

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
where form_descr like '%otic drops suspension%'

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
where form_descr like '%otic lotion%'	

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
where form_descr like '%ear drops solution%'	

UPDATE vw_dose_unit  SET default_dispense_unit = 'Inhaler'
where form_descr like '%HFA Inhaler%'

UPDATE vw_dose_unit  SET default_dispense_unit = 'Bottle'
where form_descr like '%metered nose spray%'

UPDATE vw_dose_unit  SET default_dispense_unit = 'Bottle'
where form_descr like '%metered dose nasal spray%'

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
where form_descr like '%nebuliser solution%'

UPDATE vw_dose_unit  SET default_dispense_unit = 'CAP'
where form_descr like '%inhalation powder%'
and form_descr like '%UNT%'

UPDATE vw_dose_unit  SET default_dispense_unit = 'CAP'
where form_descr like '%inhalation powder%'
and form_descr like '%MCG%'

UPDATE vw_dose_unit  SET default_dispense_unit = 'CAP'
where form_descr like '%inhalation powder%'
and form_descr like '%MG%'

UPDATE vw_dose_unit  SET default_dispense_unit = 'Bottle'
where form_descr like '%nasal drop%'

UPDATE vw_dose_unit  SET default_dispense_unit = 'Bottle'
where form_descr like '%nasal solution%'
and dose_unit is null

UPDATE vw_dose_unit  SET default_dispense_unit = 'Bottle'
where form_descr like '%nasal spray%'
and dose_unit is null

UPDATE vw_dose_unit  SET default_dispense_unit = 'ML'
where form_descr like '%solution for infusion%'

UPDATE vw_dose_unit  SET default_dispense_unit = 'SUPP'
where form_descr like '%rectal capsule%'

UPDATE vw_dose_unit  SET default_dispense_unit = 'TUBE'
where form_descr like '%rectal ointment%'

UPDATE vw_dose_unit  SET default_dispense_unit = 'APPLY'
where form_descr like '%scalp lotion%'

UPDATE vw_dose_unit  SET default_dispense_unit = 'INSERT'
where form_descr like '%vaginal%'
and form_descr not like '%implant%'
and (form_descr like '%tablet%'
or form_descr  like '%capsule%'
or form_descr  like '%ovule%'
or form_descr  like '%suppository%'
or form_descr  like '%pessary%'
or form_descr  like '%insert%')

UPDATE vw_dose_unit  SET default_dispense_unit = 'CANNISTER'
where form_descr like '%Injectable foam%'