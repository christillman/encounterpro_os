
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

CREATE TABLE [dbo].[c_Drug_Brand](
	[brand_name] [varchar](200) NULL,
	[brand_name_rxcui] [varchar](30) NOT NULL,
	[generic_rxcui] [varchar](20) NULL,
	[is_single_ingredient] [bit] NOT NULL,
	[drug_id] [varchar](24) NULL,
	[mesh_source] [varchar](100) NULL,
	[scope_note] [varchar](400) NULL,
	[dea_class] [varchar](10) NULL,
	[valid_in] [varchar](100) NULL,
 CONSTRAINT [pk_Drug_Brand] PRIMARY KEY CLUSTERED 
(
	[brand_name_rxcui] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
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
CREATE UNIQUE INDEX uq_brand_drug_id ON c_Drug_Brand (drug_id)
GO

