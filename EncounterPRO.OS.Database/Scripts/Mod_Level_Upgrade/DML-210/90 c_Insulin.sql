Print 'Drop View vw_insulin'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'vw_insulin') AND [type]='V'))
DROP VIEW vw_insulin
Print 'Create View vw_insulin'
GO
CREATE VIEW vw_insulin AS
select a.form_rxcui, a.form_tty, a.form_descr, a.ingr_rxcui, a.valid_in,
	f.generic_rxcui, f.generic_name, 
	c.default_dispense_unit, c.default_dispense_amount,
	d.administer_method, 
	e.dosage_form, e.dose_unit, e.administer_unit
from c_Drug_Formulation A 
join c_Drug_Brand B on a.ingr_rxcui = b.brand_name_rxcui 
join c_Drug_Generic F on b.generic_rxcui = f.generic_rxcui
join c_Drug_Package C on a.form_rxcui = c.form_rxcui
join c_Package_Administration_Method D on c.package_id = d.package_id
join c_Package E on c.package_id = e.package_id
go

-- 1. Insulin Inhalation Powder Cartridges

UPDATE vw_insulin 
SET default_dispense_unit = 'CARTRIDGE'
where generic_name like '%insulin%'
and form_descr like '%powder%'

UPDATE vw_insulin 
SET administer_method = 'INHALE'
where generic_name like '%insulin%'
and form_descr like '%powder%'

UPDATE vw_insulin 
SET dosage_form = 'Inhalation Powder',
	dose_unit = 'UNIT'
where generic_name like '%insulin%'
and form_descr like '%powder%'

-- 2. Insulin Pen Injectors

UPDATE vw_insulin 
SET default_dispense_unit = 'PEN'
where generic_name like '%insulin%'
and (form_descr like '%pen injector%' or form_descr like '%prefilled pen%')

UPDATE vw_insulin 
SET administer_method = 'Subcut ONLY'
where generic_name like '%insulin%'
and (form_descr like '%pen injector%' or form_descr like '%prefilled pen%')

UPDATE vw_insulin 
SET dosage_form = 'Pen Injector',
	dose_unit = 'UNIT'
where generic_name like '%insulin%'
and (form_descr like '%pen injector%' or form_descr like '%prefilled pen%')

-- 3. Insulin Injectable Solutions

UPDATE vw_insulin 
SET default_dispense_unit = 'ML'
where generic_name like '%insulin%'
and form_descr like '%injectable solution%'

UPDATE vw_insulin 
SET administer_method = 'Subcut ONLY'
where generic_name like '%insulin%'
and form_descr like '%injectable solution%'

UPDATE vw_insulin 
SET dosage_form = 'Injectable Solution',
	dose_unit = 'UNIT'
where generic_name like '%insulin%'
and form_descr like '%injectable solution%'

-- 4. Insulin Injectable Suspensions

UPDATE vw_insulin 
SET default_dispense_unit = 'ML'
where generic_name like '%insulin%'
and form_descr like '%injectable suspension%'

UPDATE vw_insulin 
SET administer_method = 'Subcut ONLY'
where generic_name like '%insulin%'
and form_descr like '%injectable suspension%'

UPDATE vw_insulin 
SET dosage_form = 'Injectable Suspension',
	dose_unit = 'UNIT'
where generic_name like '%insulin%'
and form_descr like '%injectable suspension%'

-- 5. Insulin Cartridges

UPDATE vw_insulin 
SET default_dispense_unit = 'CARTRIDGE'
where generic_name like '%insulin%'
and form_descr like '%cartridge%'

UPDATE vw_insulin 
SET administer_method = 'SUBCUTANEOUS'
where generic_name like '%insulin%'
and form_descr like '%cartridge%'

UPDATE vw_insulin 
SET dosage_form = 'Cartridge',
	dose_unit = 'UNIT'
where generic_name like '%insulin%'
and form_descr like '%cartridge%'
