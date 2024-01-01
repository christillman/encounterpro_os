

SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
GO

-- Would prevent constraint being created
delete from c_Drug_Generic
where generic_rxcui = 'UGGI6489'
and generic_name = 'bromhexin / uaifenesi / erbutaline'

-- Would prevent uq_generic_drug_id being created
UPDATE c_Drug_Generic SET drug_id = 'RXNG' + generic_rxcui
WHERE generic_rxcui IN ('10869','898404')

GO
-- Need to drop column and constraint before setting generic_name not null
if exists (select * from sys.columns where object_id = object_id('c_Drug_Generic') and
	 name = 'uq_name_checksum')
	BEGIN
	ALTER TABLE c_Drug_Generic DROP CONSTRAINT IF EXISTS uq_generic_name 
	ALTER TABLE c_Drug_Generic DROP COLUMN uq_name_checksum
	END

ALTER TABLE c_Drug_Generic
ALTER COLUMN generic_rxcui varchar(30) NOT NULL

ALTER TABLE c_Drug_Generic
ALTER COLUMN generic_name varchar(2000) NOT NULL

GO
ALTER TABLE c_Drug_Generic ADD uq_name_checksum AS (CHECKSUM(generic_name)
	) PERSISTED,	
	CONSTRAINT uq_generic_name UNIQUE (uq_name_checksum)
GO

if exists (SELECT * FROM dbo.sysobjects WHERE xtype = 'PK' and parent_obj = object_id('c_Drug_Generic')
AND name = 'PK_c_Drug_Generic')
ALTER TABLE c_Drug_Generic DROP CONSTRAINT IF EXISTS PK_c_Drug_Generic 
	
if exists (SELECT * FROM dbo.sysobjects WHERE xtype = 'PK' and parent_obj = object_id('c_Drug_Generic')
AND name = 'pk_Drug_Generic')
ALTER TABLE c_Drug_Generic DROP CONSTRAINT IF EXISTS pk_Drug_Generic 
	
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE xtype = 'PK' and parent_obj = object_id('c_Drug_Generic'))
ALTER TABLE c_Drug_Generic ADD CONSTRAINT PK_c_Drug_Generic PRIMARY KEY  (generic_rxcui)

DROP INDEX IF EXISTS c_Drug_Generic.uq_generic_drug_id
CREATE UNIQUE INDEX uq_generic_drug_id ON c_Drug_Generic (drug_id)
GO

DROP INDEX IF EXISTS c_Drug_Brand.uq_brand_name
GO
ALTER TABLE c_Drug_Brand
ALTER COLUMN brand_name_rxcui varchar(30) NOT NULL

delete from c_Drug_Brand where brand_name is null

ALTER TABLE c_Drug_Brand
ALTER COLUMN brand_name varchar(200) NOT NULL
GO

if exists (SELECT * FROM dbo.sysobjects WHERE xtype = 'PK' and parent_obj = object_id('c_Drug_Brand')
	AND name = 'PK_c_Drug_Brand')
	ALTER TABLE c_Drug_Brand DROP CONSTRAINT IF EXISTS PK_c_Drug_Brand 
	
if exists (SELECT * FROM dbo.sysobjects WHERE xtype = 'PK' and parent_obj = object_id('c_Drug_Brand')
	AND name = 'pk_Drug_Brand')
	ALTER TABLE c_Drug_Brand DROP CONSTRAINT IF EXISTS pk_Drug_Brand 
	
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE xtype = 'PK' and parent_obj = object_id('c_Drug_Brand'))
	ALTER TABLE c_Drug_Brand ADD CONSTRAINT PK_c_Drug_Brand PRIMARY KEY  (brand_name_rxcui)

DROP INDEX IF EXISTS c_Drug_Brand.uq_brand_drug_id
CREATE UNIQUE INDEX uq_brand_drug_id ON c_Drug_Brand (drug_id)

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