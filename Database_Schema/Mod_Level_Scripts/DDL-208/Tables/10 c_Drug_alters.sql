

if not exists (select * from sys.columns where object_id = object_id('c_Drug_Package') and
	 name = 'form_rxcui')
	ALTER TABLE c_Drug_Package
		ADD form_rxcui varchar(20) null

if not exists (select * from sys.columns where object_id = object_id('p_Treatment_Item') and
	 name = 'form_rxcui')
	ALTER TABLE p_Treatment_Item
		ADD form_rxcui varchar(20) null
		
if not exists (select * from sys.columns where object_id = object_id('c_Drug_Formulation') and
	 name = 'RXN_available_strength')
	ALTER TABLE c_Drug_Formulation 
	ADD dosage_form varchar(40),
		dose_amount real, 
		dose_unit varchar(20),
		RXN_available_strength varchar(500) 

ALTER TABLE [dbo].[c_Drug_Brand] ALTER COLUMN [brand_name] VARCHAR(200)
ALTER TABLE [dbo].[c_Drug_Brand] ALTER COLUMN [brand_name_rxcui] VARCHAR(20)
ALTER TABLE [dbo].[c_Drug_Brand] ALTER COLUMN [generic_rxcui] VARCHAR(20)

ALTER TABLE [dbo].[c_Drug_Formulation] ALTER COLUMN [form_rxcui] VARCHAR(20) NOT NULL
ALTER TABLE [dbo].[c_Drug_Formulation] ALTER COLUMN [ingr_rxcui] VARCHAR(20)

ALTER TABLE [dbo].[c_Drug_Package] ALTER COLUMN [form_rxcui] VARCHAR(20) 
ALTER TABLE [dbo].[c_Drug_Pack] ALTER COLUMN [rxcui] VARCHAR(20) NOT NULL

ALTER TABLE [dbo].[c_Package] ALTER COLUMN [description] VARCHAR(600) 
ALTER TABLE [dbo].[c_Package] ALTER COLUMN [dose_unit] VARCHAR(20) 
ALTER TABLE [dbo].[c_Package] ALTER COLUMN [administer_unit] VARCHAR(20) 

ALTER TABLE 