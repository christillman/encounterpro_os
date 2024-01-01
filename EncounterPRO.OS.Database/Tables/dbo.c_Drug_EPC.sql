IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[c_Drug_EPC]') AND type in (N'U'))
DROP TABLE [c_Drug_EPC]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [c_Drug_EPC](
	[drug_id] [varchar](24) NULL,
	[epc_category] [varchar](100) NULL
) ON [PRIMARY]
GO
