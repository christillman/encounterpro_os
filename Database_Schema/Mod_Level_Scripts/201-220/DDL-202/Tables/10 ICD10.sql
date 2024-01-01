

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

IF EXISTS (SELECT 1 FROM sys.tables WHERE type = 'U' AND name = 'icd10cm_codes_2018')
	BEGIN DROP TABLE icd10cm_codes_2018 END
GO

CREATE TABLE icd10cm_codes_2018 (
	code varchar(10) NOT NULL,
	descr varchar(255) NOT NULL
)
GO

IF EXISTS (SELECT 1 FROM sys.tables WHERE type = 'U' AND name = 'icd9_gem')
	BEGIN DROP TABLE icd9_gem END
GO

CREATE TABLE icd9_gem (
	icd9_code varchar(10) NOT NULL,
	icd10_code varchar(10) NOT NULL,
	flags varchar(5)
)
GO


GRANT SELECT ON [dbo].[icd10cm_codes_2018] TO CPRSYSTEM

IF NOT EXISTS (SELECT 1 FROM sys.columns c join sys.tables t on t.object_id = c.object_id 
	WHERE t.name = 'c_ICD_Updates' and c.name = 'icd10_code') 
	 BEGIN ALTER TABLE c_ICD_Updates add icd10_code varchar(10) END
IF NOT EXISTS (SELECT 1 FROM sys.columns c join sys.tables t on t.object_id = c.object_id 
	WHERE t.name = 'c_ICD_Code' and c.name = 'icd10_code') 
	 BEGIN ALTER TABLE c_ICD_Code add icd10_code varchar(10) END
IF NOT EXISTS (SELECT 1 FROM sys.columns c join sys.tables t on t.object_id = c.object_id 
	WHERE t.name = 'c_ICD_Properties' and c.name = 'icd10_code')
	 BEGIN ALTER TABLE c_ICD_Properties add icd10_code varchar(10) END
IF NOT EXISTS (SELECT 1 FROM sys.columns c join sys.tables t on t.object_id = c.object_id 
	WHERE t.name = 'c_Authority_Formulary' and c.name = 'icd10_code')
	 BEGIN ALTER TABLE c_Authority_Formulary add icd10_code varchar(10) END
IF NOT EXISTS (SELECT 1 FROM sys.columns c join sys.tables t on t.object_id = c.object_id 
	WHERE t.name = 'c_Assessment_Definition' and c.name = 'icd10_code')
	 BEGIN 	
		ALTER TABLE c_Assessment_Definition add icd10_code varchar(10) 
		ALTER TABLE [c_Assessment_Definition] DROP CONSTRAINT [DF__c_Assessment_def_acuteness]
		ALTER TABLE c_Assessment_Definition alter column acuteness varchar(24) 
	 END
IF NOT EXISTS (SELECT 1 FROM sys.columns c join sys.tables t on t.object_id = c.object_id 
	WHERE t.name = 'p_Encounter_Assessment' and c.name = 'icd10_code')
	 BEGIN ALTER TABLE p_Encounter_Assessment add icd10_code varchar(10) END
IF NOT EXISTS (SELECT 1 FROM sys.columns c join sys.tables t on t.object_id = c.object_id 
	WHERE t.name = 'c_Assessment_Coding' and c.name = 'icd10_code')
	 BEGIN ALTER TABLE c_Assessment_Coding add icd10_code varchar(10) END
IF NOT EXISTS (SELECT 1 FROM sys.columns c join sys.tables t on t.object_id = c.object_id 
	WHERE t.name = 'c_Maintenance_Assessment' and c.name = 'icd10_code')
	 BEGIN ALTER TABLE c_Maintenance_Assessment add icd10_code varchar(10) END
	 
IF NOT EXISTS (SELECT 1 FROM sys.columns c join sys.tables t on t.object_id = c.object_id 
	WHERE t.name = 'c_Assessment_Category' and c.name = 'icd10_start')
	 BEGIN ALTER TABLE c_Assessment_Category ADD icd10_start varchar(3), icd10_end  varchar(3) END
GO

ALTER TABLE c_Assessment_Definition ALTER COLUMN long_description varchar(500)
GO
