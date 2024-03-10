
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET NUMERIC_ROUNDABORT OFF
SET QUOTED_IDENTIFIER ON

/*
select form_rxcui, ingr_rxcui, form_descr, valid_in
into #to_update
from c_Drug_Formulation
where form_descr like '%melatonin%'
-- (48 rows affected)

select distinct p.* from #to_update u 
join c_Drug_Brand p on p.brand_name_rxcui = u.ingr_rxcui
where  form_rxcui IN ( 199648, 199425, 283433,1291286, 199639, 199163, 199647, 252732 )
*/

/*
UPDATE c_Drug_Pack
SET valid_in = valid_in + 'ug;'
WHERE valid_in NOT like '%ug;%'
AND rxcui IN ( ... )
*/

UPDATE c_Drug_Formulation
SET valid_in = valid_in + 'ug;'
WHERE valid_in NOT like '%ug;%'
AND  form_rxcui IN ( '199648', '199425', '283433', '1291286', '199639', '199163', '199647', '252732' )

UPDATE c_Drug_Generic
SET valid_in = valid_in + 'ug;'
WHERE valid_in NOT like '%ug;%'
AND generic_rxcui IN ( '6711' )

/*
UPDATE c_Drug_Brand
SET valid_in = valid_in + 'ug;'
WHERE valid_in NOT like '%ug;%'
AND brand_name_rxcui IN ( ... )
*/
