-- c_Drug_Addition to track drugs added besides RXNORM ones.
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'c_Drug_Addition') AND type in (N'U'))
	DROP TABLE [dbo].[c_Drug_Addition]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[c_Drug_Addition](
	[country] [varchar](10) NULL,
	[country_drug_id] [varchar](24) NULL,
	[rxcui] [varchar](20) NULL
) ON [PRIMARY]

GO
GRANT DELETE, INSERT, SELECT, UPDATE ON c_Drug_Addition TO [cprsystem] AS [dbo]
GO

