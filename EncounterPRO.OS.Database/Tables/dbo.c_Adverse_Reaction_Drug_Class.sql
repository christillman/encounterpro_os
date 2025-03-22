IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[c_Adverse_Reaction_Drug_Class]') AND type in (N'U'))
DROP TABLE [c_Adverse_Reaction_Drug_Class]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [c_Adverse_Reaction_Drug_Class](
	[rxcui] [varchar](10) NULL,
	[name] [varchar](80) NULL
) ON [PRIMARY]
GO
GRANT DELETE ON [dbo].[c_Adverse_Reaction_Drug_Class] TO [cprsystem]
GO
GRANT INSERT ON [dbo].[c_Adverse_Reaction_Drug_Class] TO [cprsystem]
GO
GRANT REFERENCES ON [dbo].[c_Adverse_Reaction_Drug_Class] TO [cprsystem]
GO
GRANT SELECT ON [dbo].[c_Adverse_Reaction_Drug_Class] TO [cprsystem]
GO
GRANT UPDATE ON [dbo].[c_Adverse_Reaction_Drug_Class] TO [cprsystem]
GO
