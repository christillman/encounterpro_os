
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Table [dbo].[c_Database_Column]
Print 'Drop Table [dbo].[c_Database_Column]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Database_Column]') AND [type]='U'))
DROP TABLE [dbo].[c_Database_Column]
GO
-- Create Table [dbo].[c_Database_Column]
Print 'Create Table [dbo].[c_Database_Column]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[c_Database_Column] (
		[tablename]                   [varchar](64) NOT NULL,
		[columnname]                  [varchar](64) NOT NULL,
		[column_sequence]             [int] NOT NULL,
		[column_datatype]             [varchar](32) NOT NULL,
		[column_length]               [int] NOT NULL,
		[column_identity]             [bit] NOT NULL,
		[column_nullable]             [bit] NOT NULL,
		[column_definition]           [varchar](64) NOT NULL,
		[default_constraint]          [bit] NOT NULL,
		[default_constraint_name]     [varchar](64) NULL,
		[default_constraint_text]     [varchar](64) NULL,
		[modification_level]          [int] NOT NULL,
		[last_updated]                [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Database_Column]
	ADD
	CONSTRAINT [PK_c_Database_Column]
	PRIMARY KEY
	CLUSTERED
	([tablename], [columnname])
	WITH FILLFACTOR=70
	ON [PRIMARY]
GO
GRANT SELECT ON [dbo].[c_Database_Column] TO [cprsystem]
GO
ALTER TABLE [dbo].[c_Database_Column] SET (LOCK_ESCALATION = TABLE)
GO

