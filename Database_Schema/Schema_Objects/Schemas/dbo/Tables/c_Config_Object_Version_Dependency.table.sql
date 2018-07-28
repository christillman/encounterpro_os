

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Config_Object_Version_Dependency]') AND [type]='U'))
DROP TABLE [dbo].[c_Config_Object_Version_Dependency]
GO

CREATE TABLE [dbo].[c_Config_Object_Version_Dependency](
	[config_object_id] [uniqueidentifier] NOT NULL,
	[version] [int] NOT NULL,
	[dependency_id] [int] IDENTITY(1, 1) NOT NULL,
	[component_id] [varchar](24) NOT NULL,
	[component_version] [int] NOT NULL,
	[or_later] [bit] NOT NULL,
	[component_description] [varchar](80) NOT NULL,
	[created] [datetime] NOT NULL,
	[created_by] [varchar](24) NOT NULL,
	[status] [varchar](12) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

