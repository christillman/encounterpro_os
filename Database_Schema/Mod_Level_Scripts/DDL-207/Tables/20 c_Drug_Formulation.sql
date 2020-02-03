

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'c_Drug_Formulation') AND type in (N'U'))
DROP TABLE c_Drug_Formulation
GO

CREATE TABLE c_Drug_Formulation(
	form_rxcui varchar(10) NOT NULL,
	form_tty [varchar](20) NULL,
	form_descr [varchar](1000) NULL,
	ingr_rxcui varchar(10) NOT NULL,
	ingr_tty [varchar](20) NULL,
	valid_in [varchar](100) NULL,
 CONSTRAINT [PK_Drug_Formulation] PRIMARY KEY CLUSTERED 
(
	form_rxcui ASC
)
)
GO

GRANT DELETE, INSERT, SELECT, UPDATE ON c_Drug_Formulation TO [cprsystem] AS [dbo]
GO
