IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[c_EPC]') AND type in (N'U'))
DROP TABLE [c_EPC]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [c_EPC](
	[generic_name] [varchar](250) NULL,
	[epc_category] [varchar](100) NULL
) ON [PRIMARY]
GO
