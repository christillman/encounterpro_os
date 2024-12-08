IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[c_Allergen]') AND type in (N'U'))
DROP TABLE [c_Allergen]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [c_Allergen](
	[substance] [varchar](80) NULL,
	[substance_type] [varchar](24) NULL,
	[related_drug_id] [varchar](24) NULL,
	[related_generic_rxcui] [varchar](10) NULL,
	[old_assessment_id] [varchar](24) NULL
) ON [PRIMARY]
GO
GRANT DELETE ON [dbo].[c_Allergen] TO [cprsystem]
GO
GRANT INSERT ON [dbo].[c_Allergen] TO [cprsystem]
GO
GRANT REFERENCES ON [dbo].[c_Allergen] TO [cprsystem]
GO
GRANT SELECT ON [dbo].[c_Allergen] TO [cprsystem]
GO
GRANT UPDATE ON [dbo].[c_Allergen] TO [cprsystem]
GO
