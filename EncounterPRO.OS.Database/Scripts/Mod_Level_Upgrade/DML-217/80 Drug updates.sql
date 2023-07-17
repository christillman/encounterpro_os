
delete from c_Drug_Generic
where generic_rxcui = 'UGGI6489'
and generic_name = 'bromhexin / uaifenesi / erbutaline'

update c_Drug_Formulation 
set ingr_rxcui = 'UGBI0593' 
where form_rxcui = 'UGB0593'

UPDATE c_Drug_Formulation
SET ingr_rxcui = 'UGBI3456' 
WHERE ingr_rxcui = 'UGBI7199' 


DELETE FROM c_Drug_Brand
WHERE brand_name_rxcui = 'KEBI4726' -- replaced by KEBI15339
DELETE FROM c_Drug_Definition
WHERE drug_id = 'KEBI3205' -- replaced by KEGI15339
DELETE FROM c_Drug_Generic 
where drug_id = 'KEGI3205' -- replaced by KEGI15339

-- Sync c_Drug tables
insert into c_Drug_Definition( [drug_id]
      ,[drug_type]
      ,[common_name]
      ,[generic_name]
      ,[status]
      ,[owner_id]
      ,[dea_schedule]
      ,[is_generic]
	  )
SELECT g.[drug_id], 'Single Drug', g.generic_name, 'OK', '981', 'NA', 0 
from c_Drug_Generic g 
left join c_drug_definition d on d.drug_id = g.drug_id
where d.drug_id is null
and g.drug_id not in ('KEGI8288', 'UGGI0850')


insert into c_Drug_Definition( [drug_id]
      ,[drug_type]
      ,[common_name]
      ,[generic_name]
      ,[status]
      ,[owner_id]
      ,[dea_schedule]
      ,[is_generic]
	  )
SELECT b.[drug_id], 'Single Drug', brand_name, g.generic_name, 'OK', '981', 'NA', 0 
from c_Drug_Brand b
join c_Drug_Generic g on g.generic_rxcui = b.generic_rxcui
left join c_drug_definition d on d.drug_id = b.drug_id
where d.drug_id is null
and b.drug_id not in ('KEBI8288', 'UGBI6790', 'UGBI0850')

