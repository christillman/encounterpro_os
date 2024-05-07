
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Table [dbo].[c_Display_Script]
Print 'Drop Table [dbo].[c_Display_Script]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Display_Script]') AND [type]='U'))
DROP TABLE [dbo].[c_Display_Script]
GO
-- Create Table [dbo].[c_Display_Script]
Print 'Create Table [dbo].[c_Display_Script]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[c_Display_Script] (
		[display_script_id]           [int] IDENTITY(1, 1) NOT NULL,
		[context_object]              [varchar](24) NOT NULL,
		[display_script]              [varchar](40) NOT NULL,
		[description]                 [varchar](128) NULL,
		[example]                     [text] NULL,
		[status]                      [char](8) NOT NULL,
		[last_updated]                [datetime] NULL,
		[updated_by]                  [varchar](24) NULL,
		[id]                          [uniqueidentifier] NOT NULL,
		[owner_id]                    [int] NOT NULL,
		[script_type]                 [varchar](24) NOT NULL,
		[parent_config_object_id]     [uniqueidentifier] NULL,
		[original_id]                 [uniqueidentifier] NULL,
		[default_root_element]        [varchar](64) NULL,
		[xml_script_id]               AS ([display_script_id])
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Display_Script]
	ADD
	CONSTRAINT [PK_c_Display_Script]
	PRIMARY KEY
	CLUSTERED
	([display_script_id])
	WITH FILLFACTOR=90
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Display_Script]
	ADD
	CONSTRAINT [DF__c_Display__owner__4C85F732]
	DEFAULT ((-1)) FOR [owner_id]
GO
ALTER TABLE [dbo].[c_Display_Script]
	ADD
	CONSTRAINT [DF__c_Display_script_type]
	DEFAULT ('RTF') FOR [script_type]
GO
ALTER TABLE [dbo].[c_Display_Script]
	ADD
	CONSTRAINT [DF_c_Display_Script_id]
	DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[c_Display_Script]
	ADD
	CONSTRAINT [DF_c_Display_Script_last_upd]
	DEFAULT (dbo.get_client_datetime()) FOR [last_updated]
GO
ALTER TABLE [dbo].[c_Display_Script]
	ADD
	CONSTRAINT [DF_c_Display_Script_status]
	DEFAULT ('OK') FOR [status]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_c_Display_Script_id]
	ON [dbo].[c_Display_Script] ([id], [owner_id])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 90) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [idx_c_Display_Script_Type]
	ON [dbo].[c_Display_Script] ([script_type])
	INCLUDE ([description], [status], [id], [owner_id], [context_object], [display_script])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
GRANT DELETE
	ON [dbo].[c_Display_Script]
	TO [cprsystem]
GO
GRANT INSERT
	ON [dbo].[c_Display_Script]
	TO [cprsystem]
GO
GRANT REFERENCES
	ON [dbo].[c_Display_Script]
	TO [cprsystem]
GO
GRANT SELECT
	ON [dbo].[c_Display_Script]
	TO [cprsystem]
GO
GRANT UPDATE
	ON [dbo].[c_Display_Script]
	TO [cprsystem]
GO
ALTER TABLE [dbo].[c_Display_Script] SET (LOCK_ESCALATION = TABLE)
GO

