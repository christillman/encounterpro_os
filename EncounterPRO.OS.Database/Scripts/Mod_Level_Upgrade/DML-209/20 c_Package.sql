/*
update p
set dose_unit = 'MCG'
-- select p.* 
from c_drug_formulation f
join c_Drug_Package dp ON dp.form_rxcui =f.form_rxcui
join c_Package p on p.package_id = dp.package_id
where -- p.dose_unit = 'ML' and administer_unit like '%MG/ML%'
-- and description like '% MCG%'
f.form_rxcui in (
'1799704',
'1799724'
)
*/

-- Just address those in non-suppressed drugs with entry in 
-- dose_unit Correction column
update c_Package
set dose_unit = 'GRAMS'
where package_id in (
'PK1799704',
'PK1799724'
)

update c_Package
set dose_unit = 'ML'
where package_id in (
'PK311700',
'PK311702'
)
