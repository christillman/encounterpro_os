IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[c_Drug_Package_Archive]') AND type in (N'U'))
DROP TABLE [c_Drug_Package_Archive]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [c_Drug_Package_Archive](
	[drug_id] [varchar](24) NOT NULL,
	[package_id] [varchar](24) NOT NULL,
	[sort_order] [smallint] NULL,
	[prescription_flag] [varchar](1) NULL,
	[default_dispense_amount] [real] NULL,
	[default_dispense_unit] [varchar](12) NULL,
	[take_as_directed] [char](1) NULL,
	[hcpcs_procedure_id] [varchar](24) NULL
) ON [PRIMARY]
GO
