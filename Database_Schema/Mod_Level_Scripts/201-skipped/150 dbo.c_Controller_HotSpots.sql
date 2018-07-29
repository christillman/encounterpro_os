

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Controller_HotSpots]') AND [type]='U'))
DROP TABLE [dbo].[c_Controller_HotSpots]
GO

CREATE TABLE [dbo].[c_Controller_HotSpots](
	[config_object_id] [uniqueidentifier] NOT NULL,
	[hotspot_id] [int] IDENTITY(1, 1) NOT NULL,
	[context_object] [varchar](24) NOT NULL,
	[hotspot_name] [varchar](40) NOT NULL,
	[description] [varchar](255) NULL,
	[menu_config_object_id] [uniqueidentifier] NULL,
	[status] [varchar](12) NOT NULL,
	[created] [datetime] NOT NULL,
	[created_by] [varchar](24) NOT NULL,
	[id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_c_Controller] PRIMARY KEY CLUSTERED 
(
	[config_object_id] ASC,
	[hotspot_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 70) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO



ALTER TABLE [dbo].[c_Controller_HotSpots] ADD  CONSTRAINT [DF_c_Config_Object_HotSpots_created]  DEFAULT (getdate()) FOR [created]
GO

ALTER TABLE [dbo].[c_Controller_HotSpots] ADD  CONSTRAINT [DF_c_Config_Object_HotSpots_status]  DEFAULT ('OK') FOR [status]
GO

ALTER TABLE [dbo].[c_Controller_HotSpots] ADD  CONSTRAINT [DF_c_Config_Object_HotSpots_id]  DEFAULT (newid()) FOR [id]
GO

GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[c_Controller_HotSpots] TO CPRSYSTEM
GO
