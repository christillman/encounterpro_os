-- Would prevent constraint being created
delete from c_Drug_Generic
where generic_rxcui = 'UGGI6489'
and generic_name = 'bromhexin / uaifenesi / erbutaline'


ALTER TABLE c_Drug_Generic
ALTER COLUMN generic_rxcui varchar(30) NOT NULL

ALTER TABLE c_Drug_Generic
ALTER COLUMN generic_name varchar(2000) NOT NULL

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'pk_Drug_Generic') AND type = 'K')
ALTER TABLE c_Drug_Generic
ADD CONSTRAINT pk_Drug_Generic PRIMARY KEY  (generic_rxcui)

ALTER TABLE c_Drug_Brand
ALTER COLUMN brand_name_rxcui varchar(30) NOT NULL

ALTER TABLE c_Drug_Brand
ALTER COLUMN brand_name varchar(200) NOT NULL

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'pk_Drug_Brand') AND type = 'K')
ALTER TABLE c_Drug_Brand
ADD CONSTRAINT pk_Drug_Brand PRIMARY KEY  (brand_name_rxcui)

-- Next release; must be generic or brand, but not both
/*

select * from c_Drug_Formulation f -- WHERE ingr_rxcui = 'UGBI7199' 
left join c_Drug_Generic g ON g.generic_rxcui = f.ingr_rxcui
left join c_Drug_Brand b ON b.brand_name_rxcui = f.ingr_rxcui
WHERE b.brand_name_rxcui IS NULL AND g.generic_rxcui IS NULL

select * from c_Drug_Formulation f
left join c_Drug_Generic g ON g.generic_rxcui = f.ingr_rxcui
left join c_Drug_Brand b ON b.brand_name_rxcui = f.ingr_rxcui
WHERE b.brand_name_rxcui IS NOT NULL AND g.generic_rxcui IS NOT NULL
*/