

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

IF EXISTS (SELECT 1 FROM sys.tables WHERE type = 'U' AND name = 'icd10_rwanda')
	BEGIN DROP TABLE icd10_rwanda END
GO

CREATE TABLE icd10_rwanda (
	code varchar(10) NOT NULL,
	descr varchar(255) NOT NULL
)
GO

GRANT SELECT ON [dbo].[icd10_rwanda] TO CPRSYSTEM


IF EXISTS (SELECT 1 FROM sys.tables WHERE type = 'U' AND name = 'icd10_who')
	BEGIN DROP TABLE icd10_who END
GO

CREATE TABLE icd10_who (
	code varchar(10) NOT NULL,
	descr varchar(255) NOT NULL,
	active varchar(1)
)
GO

GRANT SELECT ON [dbo].[icd10_who] TO CPRSYSTEM
