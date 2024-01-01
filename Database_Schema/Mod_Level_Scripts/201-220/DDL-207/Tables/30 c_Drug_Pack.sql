-- RXNORM Packs are combinations of drugs packaged together for prescription as a unit
-- as opposed to formulations = combinations of ingredients in one drug 
-- Example, contraceptive where 7 of the 28 pills in the pack are placebo

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'c_Drug_Pack') AND type in (N'U'))
DROP TABLE c_Drug_Pack
GO

CREATE TABLE c_Drug_Pack(
	rxcui varchar(10) NOT NULL,
	tty [varchar](20) NULL,
	descr [varchar](1000) NULL,
	valid_in [varchar](100) NULL,
 CONSTRAINT [PK_Drug_Pack] PRIMARY KEY CLUSTERED 
(
	rxcui ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

GRANT DELETE, INSERT, SELECT, UPDATE ON c_Drug_Pack TO [cprsystem] AS [dbo]
GO

