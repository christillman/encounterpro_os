ALTER TABLE [Kenya_Drugs] DROP CONSTRAINT [DF__Kenya_Dru__date___5AF9A17B]
GO
ALTER TABLE [Kenya_Drugs] DROP CONSTRAINT [DF__Kenya_Dru__gener__5A057D42]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Kenya_Drugs]') AND type in (N'U'))
DROP TABLE [Kenya_Drugs]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Kenya_Drugs](
	[Retention_No] [varchar](21) NOT NULL,
	[SBD_Version] [varchar](300) NULL,
	[SCD_PSN_Version] [varchar](300) NULL,
	[Corresponding_RXCUI] [varchar](20) NULL,
	[Notes] [varchar](500) NULL,
	[dose_unit_Injections] [varchar](10) NULL,
	[Ingredient] [varchar](1300) NULL,
	[generic_only] [bit] NOT NULL,
	[date_added] [date] NULL
) ON [PRIMARY]
GO
ALTER TABLE [Kenya_Drugs] ADD  DEFAULT ((0)) FOR [generic_only]
GO
ALTER TABLE [Kenya_Drugs] ADD  DEFAULT (getdate()) FOR [date_added]
GO
