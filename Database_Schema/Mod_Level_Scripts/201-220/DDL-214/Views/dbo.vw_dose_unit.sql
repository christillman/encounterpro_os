
IF  EXISTS (SELECT * FROM sys.objects 
where object_id = OBJECT_ID(N'vw_dose_unit') AND type in (N'V'))
DROP VIEW vw_dose_unit
GO
CREATE VIEW vw_dose_unit AS
SELECT p.package_id, p.dose_unit, dp.default_dispense_unit, p.dosage_form, 
	f.form_rxcui, f.form_descr, fg.form_descr as generic_form_descr
from c_Drug_Formulation f
left join c_Drug_Formulation fg ON fg.form_rxcui = f.generic_form_rxcui
join c_Drug_Package dp ON dp.form_rxcui = f.form_rxcui
join c_Package p on p.package_id = dp.package_id
-- where f.valid_in NOT IN ('Suppress','TPN Suppress','Retired')

GO
