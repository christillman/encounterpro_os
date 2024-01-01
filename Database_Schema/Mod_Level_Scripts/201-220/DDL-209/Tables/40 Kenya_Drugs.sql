


IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[Kenya_Drugs]') AND [type]='U'))
	DROP TABLE [dbo].[Kenya_Drugs]
GO

SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

SET ANSI_PADDING ON

CREATE TABLE [dbo].[Kenya_Drugs](
	[Retention_No] [varchar](21) NOT NULL,
	[SBD_Version] [varchar](300) NULL,
	[SCD_PSN_Version] [varchar](300) NULL,
	[Corresponding_RXCUI] [varchar](20) NULL,
	[Notes] [varchar](500) NULL,
	[dose_unit_Injections] [varchar](10) NULL,
	[Ingredient] [varchar](200) NULL
) 

GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[Kenya_Drugs] TO CPRSYSTEM


GO
