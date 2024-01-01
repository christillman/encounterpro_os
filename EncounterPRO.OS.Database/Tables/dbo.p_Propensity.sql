IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[p_Propensity]') AND type in (N'U'))
DROP TABLE [p_Propensity]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [p_Propensity](
	[patient_id] [varchar](24) NOT NULL,
	[propensity] [varchar](40) NOT NULL,
	[propensity_type] [varchar](24) NOT NULL,
	[substance] [varchar](40) NULL,
	[substance_type] [varchar](24) NULL,
	[certainty] [varchar](24) NULL,
	[criticality] [varchar](24) NULL,
	[status] [varchar](10) NULL
) ON [PRIMARY]
GO
