IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[c_Allergen_Drug]') AND type in (N'U'))
DROP TABLE [c_Allergen_Drug]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [c_Allergen_Drug](
	[generic_rxcui] [varchar](10) NULL,
	[generic_name] [varchar](80) NULL,
	[drug_class_rxcui] [varchar](10) NULL,
	[drug_id] [varchar](24) NULL
) ON [PRIMARY]
GO
GRANT DELETE ON [dbo].[c_Allergen_Drug] TO [cprsystem]
GO
GRANT INSERT ON [dbo].[c_Allergen_Drug] TO [cprsystem]
GO
GRANT REFERENCES ON [dbo].[c_Allergen_Drug] TO [cprsystem]
GO
GRANT SELECT ON [dbo].[c_Allergen_Drug] TO [cprsystem]
GO
GRANT UPDATE ON [dbo].[c_Allergen_Drug] TO [cprsystem]
GO
