
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'c_Drug_Brand_Related') AND [type]='U'))
	DROP TABLE [dbo].[c_Drug_Brand_Related]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[c_Drug_Brand_Related](
	[country_code] [varchar](2) NOT NULL,
	[source_id] [varchar](30) NOT NULL,
	[source_brand_form_descr] [varchar](300) NULL,
	[brand_name_rxcui] [varchar](20) NULL,
	[is_single_ingredient] [bit] NOT NULL
) 
GO


ALTER TABLE [dbo].[c_Drug_Brand_Related] ADD  CONSTRAINT pk_Drug_Brand_Related PRIMARY KEY CLUSTERED 
(
	[country_code] ASC,
	[source_id] ASC
)

GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[c_Drug_Brand_Related] TO CPRSYSTEM


IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'c_Drug_Generic_Related') AND [type]='U'))
	DROP TABLE [dbo].[c_Drug_Generic_Related]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[c_Drug_Generic_Related](
	[country_code] [varchar](2) NOT NULL,
	[source_id] [varchar](30) NOT NULL,
	[source_generic_form_descr] [varchar](300) NULL,
	[active_ingredients] [varchar](200) NULL,
	[generic_rxcui] [varchar](20) NULL,
	[is_single_ingredient] [bit] NOT NULL
) 
GO


ALTER TABLE [dbo].[c_Drug_Generic_Related] ADD  CONSTRAINT pk_Drug_Generic_Related PRIMARY KEY CLUSTERED 
(
	[country_code] ASC,
	[source_id] ASC
)

GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[c_Drug_Generic_Related] TO CPRSYSTEM

