
if exists (select * from sys.tables where object_id = object_id('c_Drug_Source_Formulation') )
	DROP TABLE c_Drug_Source_Formulation
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE c_Drug_Source_Formulation (
	[country_code] [varchar](2) NOT NULL,
	[source_id] [varchar](30) NOT NULL,
	[is_single_ingredient] [bit] NOT NULL default 1,
	[is_pack] [bit] NOT NULL default 0,
	[active_ingredients] [varchar](200) NULL,
	[source_generic_form_descr] [varchar](300) NULL,
	[generic_form_rxcui] [varchar](30) NULL,
	[generic_rxcui] [varchar](30) NULL,
	[source_brand_form_descr] [varchar](300) NULL,
	[brand_form_rxcui] [varchar](30) NULL,
	[brand_name_rxcui] [varchar](30) NULL,
 CONSTRAINT [pk_Drug_Source_Formulation] PRIMARY KEY CLUSTERED 
(
	[country_code] ASC,
	[source_id] ASC
)
)
GO
