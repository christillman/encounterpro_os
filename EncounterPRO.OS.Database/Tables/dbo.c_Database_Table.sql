
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Table [dbo].[c_Database_Table]
Print 'Drop Table [dbo].[c_Database_Table]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Database_Table]') AND [type]='U'))
DROP TABLE [dbo].[c_Database_Table]
GO
-- Create Table [dbo].[c_Database_Table]
Print 'Create Table [dbo].[c_Database_Table]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[c_Database_Table] (
		[tablename]                   [varchar](64) NOT NULL,
		[major_release]               [int] NOT NULL,
		[database_version]            [varchar](4) NOT NULL,
		[index_script]                [nvarchar](max) NULL,
		[last_update]                 [datetime] NOT NULL,
		[id]                          [uniqueidentifier] NOT NULL,
		[sync_algorithm]              [varchar](24) NOT NULL,
		[parent_tablename]            [varchar](64) NULL,
		[create_script]               [nvarchar](max) NULL,
		[trigger_script]              [nvarchar](max) NULL,
		[modification_level]          [int] NULL,
		[sync_modification_level]     [int] NULL,
		[permission_script]           [varchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Database_Table]
	ADD
	CONSTRAINT [PK_c_Database_Table_1]
	PRIMARY KEY
	CLUSTERED
	([tablename])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Database_Table]
	ADD
	CONSTRAINT [DF__c_Databas__sync___226FC1D5]
	DEFAULT ('None') FOR [sync_algorithm]
GO
ALTER TABLE [dbo].[c_Database_Table]
	ADD
	CONSTRAINT [DF_c_Database_Table_id]
	DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[c_Database_Table]
	ADD
	CONSTRAINT [DF_c_Database_Table_lastupd]
	DEFAULT (dbo.get_client_datetime()) FOR [last_update]
GO
GRANT DELETE ON [dbo].[c_Database_Table] TO [cprsystem]
GO
GRANT INSERT ON [dbo].[c_Database_Table] TO [cprsystem]
GO
GRANT REFERENCES ON [dbo].[c_Database_Table] TO [cprsystem]
GO
GRANT SELECT ON [dbo].[c_Database_Table] TO [cprsystem]
GO
GRANT UPDATE ON [dbo].[c_Database_Table] TO [cprsystem]
GO
ALTER TABLE [dbo].[c_Database_Table] SET (LOCK_ESCALATION = TABLE)
GO

