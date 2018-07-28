

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Datawindow]') AND [type]='U'))
DROP TABLE [dbo].[c_Datawindow]
GO

CREATE TABLE [dbo].[c_Datawindow](
	[config_object_id] [uniqueidentifier] NOT NULL,
	[context_object] [varchar](24) NOT NULL,
	[datawindow_name] [varchar](80) NOT NULL,
	[description] [varchar](255) NULL,
	[library_component_id] [uniqueidentifier] NULL,
	[dataobject] [varchar](80) NULL,
	[datawindow_syntax] [varchar](MAX) NULL,
	[controller_config_object_id] [uniqueidentifier] NULL,
	[status] [varchar](12) NOT NULL,
	[created] [datetime] NOT NULL,
	[created_by] [varchar](24) NOT NULL,
	[id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_c_Datawindow] PRIMARY KEY CLUSTERED 
(
	[config_object_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 70) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO



ALTER TABLE [dbo].[c_Datawindow] ADD  CONSTRAINT [DF_c_Datawindow_created]  DEFAULT (getdate()) FOR [created]
GO

ALTER TABLE [dbo].[c_Datawindow] ADD  CONSTRAINT [DF_c_Datawindow_status]  DEFAULT ('OK') FOR [status]
GO

ALTER TABLE [dbo].[c_Datawindow] ADD  CONSTRAINT [DF_c_Datawindow_id]  DEFAULT (newid()) FOR [id]
GO

GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[c_Datawindow] TO CPRSYSTEM
GO
