IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[c_Adverse_Reaction_Drug]') AND type in (N'U'))
DROP TABLE [c_Adverse_Reaction_Drug]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [c_Adverse_Reaction_Drug](
	[generic_rxcui] [varchar](10) NULL,
	[generic_name] [varchar](80) NULL,
	[drug_class_rxcui] [varchar](10) NULL,
	[drug_id] [varchar](24) NULL
) ON [PRIMARY]
GO
