IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[c_Drug_Pack_Formulation]') AND type in (N'U'))
DROP TABLE [c_Drug_Pack_Formulation]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [c_Drug_Pack_Formulation](
	[form_rxcui] [varchar](20) NOT NULL,
	[pack_rxcui] [varchar](20) NOT NULL,
	[form_tty] [varchar](20) NULL,
	[form_descr] [varchar](1000) NULL,
 CONSTRAINT [PK_Drug_Pack_Formulation] PRIMARY KEY CLUSTERED 
(
	[pack_rxcui] ASC,
	[form_rxcui] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
