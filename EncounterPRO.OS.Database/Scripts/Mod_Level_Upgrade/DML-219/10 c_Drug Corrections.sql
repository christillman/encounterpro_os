/*
select distinct f.form_rxcui, f.form_descr, b.brand_name 
from c_drug_formulation f
join c_drug_brand b on b.brand_name_rxcui = f.ingr_rxcui
where form_descr not like b.brand_name + '%'
and form_descr not like '"' + b.brand_name + '%'
order by b.brand_name
*/

UPDATE c_Drug_Brand SET brand_name = 'Axaban-Denk' 
-- select * from c_Drug_Brand
WHERE brand_name = 'Apixaban-Denk'

UPDATE c_Drug_Brand SET brand_name = 'Rescula' 
-- select * from c_Drug_Brand
WHERE brand_name = 'Eescula'

UPDATE c_Drug_Brand SET brand_name = 'Flucan' 
-- select * from c_Drug_Brand
WHERE brand_name = 'Flucanir'

UPDATE c_Drug_Brand SET brand_name = 'Benzapene 1' 
-- select * from c_Drug_Brand
WHERE brand_name = 'Benzapene[1]'

UPDATE c_Drug_Formulation SET form_descr = 'Decomit Inhaler ???' 
-- select * from c_Drug_Formulation
WHERE form_rxcui = 'KEB2347'

UPDATE c_Drug_Formulation SET form_descr = 'Loxamox 250 MG in 50 ML Injection ???' 
-- select * from c_Drug_Formulation
WHERE form_rxcui = 'UGB9129'

UPDATE c_Drug_Formulation SET form_descr = 'Retaine MGD 0.5 % / 0.5 % Ophthalmic Solution' 
-- select * from c_Drug_Formulation
WHERE form_rxcui = '1236282'
