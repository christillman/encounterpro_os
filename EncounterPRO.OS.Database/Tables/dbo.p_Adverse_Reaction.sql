IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[p_Adverse_Reaction]') AND type in (N'U'))
DROP TABLE [p_Adverse_Reaction]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [p_Adverse_Reaction](
	[patient_id] [varchar](24) NOT NULL,
	[substance] [varchar](40) NOT NULL,
	[manifestation] [varchar](40) NULL,
	[severity] [varchar](24) NULL,
	[exposure_type] [varchar](24) NULL,
	[observation_method] [varchar](24) NULL
) ON [PRIMARY]
GO
GRANT DELETE ON [dbo].[p_Adverse_Reaction] TO [cprsystem]
GO
GRANT INSERT ON [dbo].[p_Adverse_Reaction] TO [cprsystem]
GO
GRANT REFERENCES ON [dbo].[p_Adverse_Reaction] TO [cprsystem]
GO
GRANT SELECT ON [dbo].[p_Adverse_Reaction] TO [cprsystem]
GO
GRANT UPDATE ON [dbo].[p_Adverse_Reaction] TO [cprsystem]
GO
