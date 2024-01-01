IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[c_Drug_Interaction_Class]') AND type in (N'U'))
DROP TABLE [c_Drug_Interaction_Class]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [c_Drug_Interaction_Class](
	[drug_class] [varchar](40) NULL,
	[drug_id] [varchar](24) NULL,
	[generic_rxcui] [varchar](10) NULL,
	[generic_drug_name] [varchar](500) NULL,
	[qualifier] [varchar](80) NULL
) ON [PRIMARY]
GO
