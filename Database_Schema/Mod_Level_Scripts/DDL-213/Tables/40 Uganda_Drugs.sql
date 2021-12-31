if exists (select * from sys.tables where object_id = object_id('Uganda_Drugs') )
	DROP TABLE [Uganda_Drugs]
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Uganda_Drugs](
	[NDA_MAL_HDP] [varchar](21) NOT NULL,
	[SBD_Version] [varchar](300) NULL,
	[brand_form_RXCUI] [varchar](20) NULL,
	[SCD_PSN_Version] [varchar](300) NULL,
	[generic_form_RXCUI] [varchar](20) NULL,
	[Ingredient] [varchar](1300) NULL,
	[generic_ingr_RXCUI] [varchar](20) NULL,
	[brand_name] [varchar](300) NULL,
	[notes] [varchar](600) NULL,
	[date_added] [date] NULL DEFAULT (getdate())
) 

