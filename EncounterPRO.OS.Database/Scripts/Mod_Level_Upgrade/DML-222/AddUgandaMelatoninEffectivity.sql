


select form_rxcui, ingr_rxcui, form_descr, valid_in
from c_Drug_Formulation
where form_descr like '%melatonin%'

UPDATE c_Drug_Pack
SET valid_in = valid_in + 'ug;'
WHERE valid_in NOT like '%ug;%'
AND rxcui IN ( ... )

UPDATE c_Drug_Formulation
SET valid_in = valid_in + 'ug;'
WHERE valid_in NOT like '%ug;%'
AND form_rxcui IN ( ... )

UPDATE c_Drug_Generic
SET valid_in = valid_in + 'ug;'
WHERE valid_in NOT like '%ug;%'
AND generic_rxcui IN ( ... )

UPDATE c_Drug_Brand
SET valid_in = valid_in + 'ug;'
WHERE valid_in NOT like '%ug;%'
AND brand_name_rxcui IN ( ... )