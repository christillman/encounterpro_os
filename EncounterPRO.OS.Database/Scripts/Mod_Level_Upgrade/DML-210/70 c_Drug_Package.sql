-- Updates as a result of other script changes
UPDATE dp
SET drug_id = b.drug_id 
-- select dp.drug_id, b.drug_id
from c_Drug_Package dp
JOIN c_Drug_Formulation f ON f.form_rxcui = dp.form_rxcui
JOIN c_Drug_Brand b ON b.brand_name_rxcui = f.ingr_rxcui
where dp.drug_id != b.drug_id
and not exists (select 1
	from c_Drug_Package dp2
	where dp2.drug_id = dp.drug_id
	and dp2.package_id = dp.package_id)
-- (219 row(s) affected)

UPDATE dp
SET drug_id = g.drug_id 
-- select dp.drug_id, g.drug_id 
from c_Drug_Package dp
JOIN c_Drug_Formulation f ON f.form_rxcui = dp.form_rxcui
JOIN c_Drug_Generic g ON g.generic_rxcui = f.ingr_rxcui
where dp.drug_id != g.drug_id
and not exists (select 1
	from c_Drug_Package dp2
	where dp2.drug_id = dp.drug_id
	and dp2.package_id = dp.package_id)
-- (163 row(s) affected)

/*
select '''' + g.generic_name + ''','
from c_Drug_Package dp
JOIN c_Drug_Formulation f ON f.form_rxcui = dp.form_rxcui
JOIN c_Drug_Generic g ON g.generic_rxcui = f.ingr_rxcui
where not exists (select 1 from c_Drug_Definition d where d.drug_id = dp.drug_id)
*/

-- Remove packages related to KE formulations which were removed in favor of RXNORM ones
SELECT form_rxcui
INTO #remove_brand_forms
FROM c_Drug_Package p
WHERE form_rxcui like 'KE%'
and not exists (select 1 from c_Drug_Formulation f where f.form_rxcui = p.form_rxcui)
SELECT package_id
INTO #remove_brand_pkgs
FROM c_Drug_Package
WHERE form_rxcui IN (SELECT form_rxcui FROM #remove_brand_forms)
DELETE FROM c_Package_Administration_Method
WHERE package_id IN (SELECT package_id FROM #remove_brand_pkgs)
DELETE FROM c_Package
WHERE package_id IN (SELECT package_id FROM #remove_brand_pkgs)
DELETE FROM c_Drug_Package
WHERE package_id IN (SELECT package_id FROM #remove_brand_pkgs)
DELETE FROM c_Drug_Formulation
WHERE form_rxcui IN (SELECT form_rxcui FROM #remove_brand_forms)

SELECT form_rxcui
INTO #bad_drug_id
FROM c_Drug_Package dp
WHERE form_rxcui like 'KE%'
and not exists (select 1 from c_Drug_Definition d where d.drug_id = dp.drug_id)
and not exists (select 1 from c_Drug_Generic g where g.drug_id = dp.drug_id)
and not exists (select 1 from c_Drug_Brand b where b.drug_id = dp.drug_id)
SELECT package_id
INTO #remove_drugid_pkgs
FROM c_Drug_Package
WHERE form_rxcui IN (SELECT form_rxcui FROM #bad_drug_id)
DELETE FROM c_Package_Administration_Method
WHERE package_id IN (SELECT package_id FROM #remove_drugid_pkgs)
DELETE FROM c_Package
WHERE package_id IN (SELECT package_id FROM #remove_drugid_pkgs)
DELETE FROM c_Drug_Package
WHERE package_id IN (SELECT package_id FROM #remove_drugid_pkgs)
DELETE FROM c_Drug_Formulation
WHERE form_rxcui IN (SELECT form_rxcui FROM #bad_drug_id)

-- Consistency checks, should all return no rows
/*
select * from c_Drug_Package
where package_id != 'PK' + form_rxcui
select * from c_Drug_Package dp
where not exists (select 1 from c_Drug_Definition d where d.drug_id = dp.drug_id)
select * from c_Drug_Package dp
where not exists (select 1 from c_Drug_Formulation f where f.form_rxcui = dp.form_rxcui)
select * from c_Drug_Brand b
where not exists (select 1 from c_Drug_Definition d where d.drug_id = b.drug_id)
select * from c_Drug_Generic g
where not exists (select 1 from c_Drug_Definition d where d.drug_id = g.drug_id)
select * from c_Drug_Brand b
where not exists (select 1 from c_Drug_Generic g where g.generic_rxcui = b.generic_rxcui)
select ingr_rxcui, form_rxcui, dbo.fn_ingredients(f.form_descr)  
from c_Drug_Formulation f
where not exists (select 1 from c_Drug_Generic g where g.generic_rxcui = f.ingr_rxcui)
and not exists (select 1 from c_Drug_Brand b where b.brand_name_rxcui = f.ingr_rxcui)
*/