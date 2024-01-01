

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Datawindow_Mapping]') AND [type]='U'))
DROP TABLE [dbo].[c_Datawindow_Mapping]
GO

CREATE TABLE [dbo].[c_Datawindow_Mapping](
	[config_object_id] [uniqueidentifier] NOT NULL,
	[control_name] [varchar](80) NOT NULL,
	[hotspot_name] [varchar](40) NULL,
	[status] [varchar](12) NOT NULL,
	[created] [datetime] NOT NULL,
	[created_by] [varchar](24) NOT NULL,
	[id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_c_Datawindow_Mapping] PRIMARY KEY CLUSTERED 
(
	[config_object_id] ASC,
	[control_name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 70) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO



ALTER TABLE [dbo].[c_Datawindow_Mapping] ADD  CONSTRAINT [DF_c_Datawindow_Mapping_created]  DEFAULT (getdate()) FOR [created]
GO

ALTER TABLE [dbo].[c_Datawindow_Mapping] ADD  CONSTRAINT [DF_c_Datawindow_Mapping_status]  DEFAULT ('OK') FOR [status]
GO

ALTER TABLE [dbo].[c_Datawindow_Mapping] ADD  CONSTRAINT [DF_c_Datawindow_Mapping_id]  DEFAULT (newid()) FOR [id]
GO

GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[c_Datawindow_Mapping] TO CPRSYSTEM
GO
