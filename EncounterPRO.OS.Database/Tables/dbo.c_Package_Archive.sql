IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[c_Package_Archive]') AND type in (N'U'))
DROP TABLE [c_Package_Archive]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [c_Package_Archive](
	[package_id] [varchar](24) NOT NULL,
	[administer_method] [varchar](12) NULL,
	[description] [varchar](80) NULL,
	[administer_unit] [varchar](12) NULL,
	[dose_unit] [varchar](12) NULL,
	[administer_per_dose] [real] NULL,
	[dosage_form] [varchar](24) NULL,
	[dose_amount] [real] NULL,
	[status] [varchar](12) NOT NULL
) ON [PRIMARY]
GO
