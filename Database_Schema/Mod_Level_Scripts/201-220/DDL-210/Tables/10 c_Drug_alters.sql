

if not exists (select * from sys.columns where object_id = object_id('Kenya_Drugs') and
	 name = 'generic_only')
	ALTER TABLE Kenya_Drugs 
	ADD generic_only bit NOT NULL default 0 

if not exists (select * from sys.columns where object_id = object_id('Kenya_Drugs') and
	 name = 'date_added')
	ALTER TABLE Kenya_Drugs 
	ADD date_added date NULL default getdate()
	
if not exists (select * from sys.columns where object_id = object_id('c_Drug_Brand') and
	 name = 'valid_in')
	ALTER TABLE c_Drug_Brand 
	ADD valid_in varchar(100) NULL 

if not exists (select * from sys.columns where object_id = object_id('c_Drug_Generic') and
	 name = 'valid_in')
	ALTER TABLE c_Drug_Generic 
	ADD valid_in varchar(100) NULL
	
/* hold off on this, not sure if might be overspecifying (already check ingredient and formulation)
if not exists (select * from sys.columns where object_id = object_id('c_Drug_Definition') and
	 name = 'valid_in')
	ALTER TABLE c_Drug_Definition 
	ADD valid_in varchar(100) NULL
*/

ALTER TABLE c_Package_Administration_Method 
	ALTER COLUMN administer_method varchar(30) NULL	

-- Standardise rxcui columns to 20 chars, eliminate unused ones
ALTER TABLE c_Drug_Package ALTER COLUMN form_rxcui varchar(20)
if exists (select * from sys.columns where object_id = object_id('c_Drug_Package') and
	 name = 'generic_rxcui')
	ALTER TABLE c_Drug_Package DROP COLUMN generic_rxcui
if exists (select * from sys.columns where object_id = object_id('c_Drug_Package') and
	 name = 'rxcui')
	ALTER TABLE c_Drug_Package DROP COLUMN rxcui
if exists (select * from sys.columns where object_id = object_id('c_Drug_Formulation') and
	 name = 'RXN_available_strength')
	ALTER TABLE c_Drug_Formulation DROP COLUMN RXN_available_strength

ALTER TABLE [dbo].[c_Drug_Pack_Formulation] DROP CONSTRAINT [PK_Drug_Pack_Formulation]
GO

ALTER TABLE c_Drug_Pack_Formulation ALTER COLUMN form_rxcui varchar(20) NOT NULL
ALTER TABLE c_Drug_Pack_Formulation ALTER COLUMN pack_rxcui varchar(20) NOT NULL
GO
ALTER TABLE [dbo].[c_Drug_Pack_Formulation] ADD  CONSTRAINT [PK_Drug_Pack_Formulation] PRIMARY KEY CLUSTERED 
(
	[pack_rxcui] ASC,
	[form_rxcui] ASC
)
	
ALTER TABLE c_Drug_Administration ALTER COLUMN form_rxcui varchar(20)
ALTER TABLE c_Dosage_Form ALTER COLUMN rxcui varchar(20)

if exists (select * from sys.columns where object_id = object_id('c_Package') and
	 name = 'rxcui')
	ALTER TABLE c_Package DROP COLUMN rxcui