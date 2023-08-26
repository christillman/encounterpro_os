IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[p_patient_list_item]') AND type in (N'U'))
DROP TABLE [p_patient_list_item]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [p_patient_list_item](
	[cpr_id] [varchar](24) NOT NULL,
	[list_id] [varchar](24) NOT NULL,
	[list_item] [varchar](24) NOT NULL,
	[list_item_patient_data] [varchar](80) NULL
) ON [PRIMARY]
GO
