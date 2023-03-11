
/*
select distinct 
	u.dosage_form, 
	dbo.fn_std_dosage_form (form_descr, generic_form_descr) as [Revised dosage_form], 
	u.dose_unit,
	dbo.fn_std_dose_unit (dbo.fn_std_dosage_form (form_descr, generic_form_descr), form_descr, generic_form_descr) as [Revised dose_unit], 
	u.form_rxcui, u.form_descr, u.generic_form_descr
  from vw_dose_unit u
where u.dose_unit != dbo.fn_std_dose_unit (dbo.fn_std_dosage_form (form_descr, generic_form_descr), form_descr, generic_form_descr)


UPDATE u
SET dose_unit = dbo.fn_std_dose_unit (dbo.fn_std_dosage_form (form_descr, generic_form_descr), form_descr, generic_form_descr)
FROM vw_dose_unit u
WHERE u.dose_unit IS NULL
OR u.dose_unit != fn_std_dose_unit (dbo.fn_std_dosage_form (form_descr, generic_form_descr), form_descr, generic_form_descr)
*/


DELETE dp -- select *
FROM c_Drug_package dp
WHERE NOT EXISTS (SELECT 1
	FROM c_Drug_Definition b
	WHERE b.drug_id = dp.drug_id)
	
DELETE dp
-- select dp.drug_id, dp.package_id , f.ingr_rxcui, b.brand_name_rxcui
from c_Drug_Package dp 
left join c_Drug_Brand b on b.drug_id = dp.drug_id
join c_Drug_Formulation f on f.form_rxcui = dp.form_rxcui
where (b.brand_name_rxcui != f.ingr_rxcui OR b.brand_name_rxcui IS NULL)
and exists (select 1 from  c_Drug_Package dp2 
join c_Drug_Brand b2 on b2.drug_id = dp2.drug_id
join c_Drug_Formulation f2 on f2.form_rxcui = dp2.form_rxcui
where dp2.package_id =  dp.package_id
and dp2.drug_id != dp.drug_id
)

/*
select distinct u.default_dispense_unit,
	dbo.fn_std_default_dispense_unit (dbo.fn_std_dosage_form (form_descr, generic_form_descr), dbo.fn_std_dose_unit (dbo.fn_std_dosage_form (form_descr, generic_form_descr), form_descr, generic_form_descr)) as [Revised default_dispense_unit], 
	u.form_rxcui, u.form_descr, u.generic_form_descr
from vw_dose_unit u
where u.default_dispense_unit IS NULL 
	OR u.default_dispense_unit != dbo.fn_std_default_dispense_unit (dbo.fn_std_dosage_form (form_descr, generic_form_descr), dbo.fn_std_dose_unit (dbo.fn_std_dosage_form (form_descr, generic_form_descr), form_descr, generic_form_descr))
*/

UPDATE u
SET default_dispense_unit = dbo.fn_std_default_dispense_unit (dbo.fn_std_dosage_form (form_descr, generic_form_descr), dbo.fn_std_dose_unit (dbo.fn_std_dosage_form (form_descr, generic_form_descr), form_descr, generic_form_descr))
FROM vw_dose_unit u
WHERE u.default_dispense_unit IS NULL 
	OR u.default_dispense_unit != dbo.fn_std_default_dispense_unit (dbo.fn_std_dosage_form (form_descr, generic_form_descr), dbo.fn_std_dose_unit (dbo.fn_std_dosage_form (form_descr, generic_form_descr), form_descr, generic_form_descr))

/*
select distinct 
	u.dosage_form, 
	dbo.fn_std_dosage_form (form_descr, generic_form_descr) as new_dosage_form, 
	u.dose_unit,
	dbo.fn_std_dose_unit (dbo.fn_std_dosage_form (form_descr, generic_form_descr), form_descr, generic_form_descr) as [Revised dose_unit], 
	u.default_dispense_unit,
	dbo.fn_std_default_dispense_unit (dbo.fn_std_dosage_form (form_descr, generic_form_descr), dbo.fn_std_dose_unit (dbo.fn_std_dosage_form (form_descr, generic_form_descr), form_descr, generic_form_descr)) as [Revised default_dispense_unit], 
	u.form_rxcui, u.form_descr, u.generic_form_descr
from vw_dose_unit u
where u.dosage_form IS NULL
	OR dbo.fn_std_dosage_form (form_descr, generic_form_descr) != u.dosage_form
*/

UPDATE u
SET dosage_form = dbo.fn_std_dosage_form (form_descr, generic_form_descr)
FROM vw_dose_unit u
WHERE u.dosage_form IS NULL
	OR dbo.fn_std_dosage_form (form_descr, generic_form_descr) != u.dosage_form

