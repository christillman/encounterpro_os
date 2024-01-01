
alter table c_drug_definition
alter column common_name varchar(80)
alter table c_drug_definition
alter column generic_name varchar(500) -- for display name (compounds will need to be handled)

IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Drug_Brand]') AND [type]='U'))
	DROP TABLE [dbo].[c_Drug_Brand]
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Drug_Brand_Ingredient]') AND [type]='U'))
	DROP TABLE [dbo].[c_Drug_Brand_Ingredient]
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Drug_Generic]') AND [type]='U'))
	DROP TABLE [dbo].[c_Drug_Generic]
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Drug_Generic_Ingredient]') AND [type]='U'))
	DROP TABLE [dbo].[c_Drug_Generic_Ingredient]
GO

CREATE TABLE c_Drug_Brand (
	brand_name varchar(100),
	brand_name_rxcui varchar(10),
	generic_rxcui varchar(10),
	is_single_ingredient char(1) NOT NULL,
	mesh_source varchar(100),
	scope_note varchar(400),
	drug_id varchar(24),
	dea_class varchar(10)
	)

GRANT DELETE, INSERT, SELECT, UPDATE ON c_Drug_Brand TO [cprsystem] AS [dbo]
GO

CREATE TABLE c_Drug_Brand_Ingredient (
	brand_name_rxcui varchar(10) not null,
	generic_rxcui_ingredient varchar(10) not null
	)

GRANT DELETE, INSERT, SELECT, UPDATE ON c_Drug_Brand_Ingredient TO [cprsystem] AS [dbo]
GO

CREATE TABLE c_Drug_Generic (
	generic_name varchar(900),
	generic_rxcui varchar(10),
	is_single_ingredient char(1) NOT NULL,
	mesh_definition varchar(800),
	mesh_source varchar(100),
	scope_note varchar(400),
	drug_id varchar(24),
	dea_class varchar(10)
	)

GRANT DELETE, INSERT, SELECT, UPDATE ON c_Drug_Generic TO [cprsystem] AS [dbo]
GO

CREATE TABLE c_Drug_Generic_Ingredient (
	generic_rxcui varchar(10) not null,
	generic_rxcui_ingredient varchar(10) not null
	)

GRANT DELETE, INSERT, SELECT, UPDATE ON c_Drug_Generic_Ingredient TO [cprsystem] AS [dbo]
GO
