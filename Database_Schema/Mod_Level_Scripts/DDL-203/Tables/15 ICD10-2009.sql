

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

IF EXISTS (SELECT 1 FROM sys.tables WHERE type = 'U' AND name = 'icd10cm_codes_2019')
	BEGIN DROP TABLE icd10cm_codes_2019 END
GO

CREATE TABLE icd10cm_codes_2019 (
	code varchar(10) NOT NULL,
	descr varchar(255) NOT NULL
)
GO

IF EXISTS (SELECT 1 FROM sys.tables WHERE type = 'U' AND name = 'icd10cm_codes')
	BEGIN DROP TABLE icd10cm_codes END
GO

CREATE TABLE icd10cm_codes (
	code varchar(10) NOT NULL,
	descr varchar(255) NOT NULL
)
GO

GRANT SELECT ON [dbo].[icd10cm_codes_2019] TO CPRSYSTEM

GRANT SELECT ON [dbo].[icd10cm_codes] TO CPRSYSTEM

