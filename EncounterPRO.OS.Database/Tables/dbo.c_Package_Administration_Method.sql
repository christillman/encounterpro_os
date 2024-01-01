IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[c_Package_Administration_Method]') AND type in (N'U'))
DROP TABLE [c_Package_Administration_Method]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [c_Package_Administration_Method](
	[package_id] [varchar](24) NOT NULL,
	[administer_method] [varchar](30) NULL
) ON [PRIMARY]
GO
