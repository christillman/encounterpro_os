if exists (select * from sys.tables where object_id = object_id('Uganda_Drugs') )
	DROP TABLE [Uganda_Drugs]
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Uganda_Drugs](
	[NDA_MAL_HDP] [varchar](20) NOT NULL,
	[ug_NAME OF DRUG] varchar(500) NULL,
	[ug_GENERIC_NAME OF DRUG] varchar(500) NOT NULL,
	[ug_STRENGTH OF DRUG] varchar(500) NOT NULL,
	[SBD_Version] [varchar](400) NULL,
	[brand_form_RXCUI] [varchar](30) NULL,
	[SCD_PSN_Version] [varchar](1000) NULL,
	[generic_form_RXCUI] [varchar](30) NULL,
	[generic_name] [varchar](500) NULL,
	[generic_ingr_RXCUI] [varchar](30) NULL,
	[brand_name] [varchar](200) NULL,
	[brand_name_RXCUI] [varchar](30) NULL,
	[notes] [varchar](600) NULL,
	[date_added] [date] NOT NULL DEFAULT (getdate()),
	reviewed tinyint NOT NULL default 0
) 

