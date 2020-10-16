-- Unitss
update c_Unit set description = 'Unit' where description = 'Units'

-- Update Puff in default_dispense_unit
update dp
set  default_dispense_unit = 'Inhaler'
from c_drug_package dp
join c_drug_formulation f on f.form_rxcui = replace(package_id,'PK','')
where default_dispense_unit ='puff'
and f.form_descr like '%Inhaler%'


