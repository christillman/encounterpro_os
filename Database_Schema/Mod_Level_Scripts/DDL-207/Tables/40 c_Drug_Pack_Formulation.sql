IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'c_Drug_Pack_Formulation') AND type in (N'U'))
DROP TABLE c_Drug_Pack_Formulation
GO

CREATE TABLE c_Drug_Pack_Formulation(
	form_rxcui varchar(10) NOT NULL,
	pack_rxcui varchar(10) NOT NULL,
	form_tty [varchar](20) NULL,
	form_descr [varchar](1000) NULL,
 CONSTRAINT [PK_Drug_Pack_Formulation] PRIMARY KEY CLUSTERED 
(
	pack_rxcui ASC, form_rxcui ASC
)
) ON [PRIMARY]
GO

GRANT DELETE, INSERT, SELECT, UPDATE ON c_Drug_Pack_Formulation TO [cprsystem] AS [dbo]
GO
