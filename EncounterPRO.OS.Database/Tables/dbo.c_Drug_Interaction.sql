IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[c_Drug_Interaction]') AND type in (N'U'))
DROP TABLE [c_Drug_Interaction]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [c_Drug_Interaction](
	[interaction_name] [varchar](80) NULL,
	[object_drug_class] [varchar](40) NULL,
	[precipitant_drug_class] [varchar](40) NULL,
	[alert_level] [varchar](24) NULL,
	[interaction_type] [varchar](40) NULL,
	[interaction_severity] [varchar](40) NULL,
	[interaction_probability] [varchar](40) NULL,
	[interaction_symptoms] [varchar](500) NULL,
	[evidence_provider_material_id] [int] NULL,
	[risk_factor_provider_material_id] [int] NULL,
	[mitigating_factor_provider_material_id] [int] NULL
) ON [PRIMARY]
GO
GRANT DELETE ON [dbo].[c_Drug_Interaction] TO [cprsystem]
GO
GRANT INSERT ON [dbo].[c_Drug_Interaction] TO [cprsystem]
GO
GRANT REFERENCES ON [dbo].[c_Drug_Interaction] TO [cprsystem]
GO
GRANT SELECT ON [dbo].[c_Drug_Interaction] TO [cprsystem]
GO
GRANT UPDATE ON [dbo].[c_Drug_Interaction] TO [cprsystem]
GO
