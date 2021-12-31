
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

Print 'Drop Table [dbo].[c_Drug_Brand]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Drug_Brand]') AND [type]='U'))
DROP TABLE [dbo].[c_Drug_Brand]
GO
Print 'Create Table [dbo].[c_Drug_Brand]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[c_Drug_Brand] (
		[drug_id]        [varchar](24) NOT NULL,
		[brand_name]     [varchar](80) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Drug_Brand]
	ADD
	CONSTRAINT [PK_c_Drug_Brand_1__10]
	PRIMARY KEY
	CLUSTERED
	([drug_id], [brand_name])
	WITH FILLFACTOR=100
	ON [PRIMARY]
GO
GRANT DELETE
	ON [dbo].[c_Drug_Brand]
	TO [cprsystem]
GO
GRANT INSERT
	ON [dbo].[c_Drug_Brand]
	TO [cprsystem]
GO
GRANT REFERENCES
	ON [dbo].[c_Drug_Brand]
	TO [cprsystem]
GO
GRANT SELECT
	ON [dbo].[c_Drug_Brand]
	TO [cprsystem]
GO
GRANT UPDATE
	ON [dbo].[c_Drug_Brand]
	TO [cprsystem]
GO
ALTER TABLE [dbo].[c_Drug_Brand] SET (LOCK_ESCALATION = TABLE)
GO

CREATE UNIQUE INDEX uq_brand_name ON c_Drug_Brand (brand_name)
GO

