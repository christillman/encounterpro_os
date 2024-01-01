
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Drug_Generic]') AND [type]='U'))
	DROP TABLE [dbo].[c_Drug_Generic]
GO
CREATE TABLE c_Drug_Generic (
	generic_name varchar(2000),
	generic_rxcui varchar(10),
	is_single_ingredient bit NOT NULL,
	drug_id varchar(24),
	mesh_definition varchar(800),
	mesh_source varchar(100),
	scope_note varchar(400),
	dea_class varchar(10)
	)

GRANT DELETE, INSERT, SELECT, UPDATE ON c_Drug_Generic TO [cprsystem] AS [dbo]
GO

IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Drug_Generic_Ingredient]') AND [type]='U'))
	DROP TABLE [dbo].[c_Drug_Generic_Ingredient]
GO

CREATE TABLE c_Drug_Generic_Ingredient (
	generic_rxcui varchar(10) not null,
	generic_rxcui_ingredient varchar(10) not null,
	ingredient_name varchar(200)
	)

GRANT DELETE, INSERT, SELECT, UPDATE ON c_Drug_Generic_Ingredient TO [cprsystem] AS [dbo]
GO


IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Drug_Brand]') AND [type]='U'))
	DROP TABLE [dbo].[c_Drug_Brand]
GO
CREATE TABLE c_Drug_Brand (
	brand_name varchar(100),
	brand_name_rxcui varchar(10),
	generic_rxcui varchar(10),
	is_single_ingredient bit NOT NULL,
	drug_id varchar(24),
	mesh_source varchar(100),
	scope_note varchar(400),
	dea_class varchar(10)
	)

GRANT DELETE, INSERT, SELECT, UPDATE ON c_Drug_Brand TO [cprsystem] AS [dbo]
GO

IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Drug_Brand_Ingredient]') AND [type]='U'))
	DROP TABLE [dbo].[c_Drug_Brand_Ingredient]
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'vw_Drug_Brand_Ingredient') AND [type]='V'))
	DROP VIEW [dbo].[vw_Drug_Brand_Ingredient]
GO
CREATE VIEW vw_Drug_Brand_Ingredient 
AS 
SELECT b.drug_id, 
	b.brand_name_rxcui,
	b.generic_rxcui,
	b.brand_name,
	g.generic_name
FROM c_Drug_Brand b
JOIN c_Drug_Generic g ON g.generic_rxcui = b.generic_rxcui
