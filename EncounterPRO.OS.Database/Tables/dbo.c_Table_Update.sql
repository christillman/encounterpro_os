
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Table [dbo].[c_Table_Update]
Print 'Drop Table [dbo].[c_Table_Update]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Table_Update]') AND [type]='U'))
DROP TABLE [dbo].[c_Table_Update]
GO
-- Create Table [dbo].[c_Table_Update]
Print 'Create Table [dbo].[c_Table_Update]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[c_Table_Update] (
		[table_name]       [varchar](64) NOT NULL,
		[last_updated]     [datetime] NOT NULL,
		[updated_by]       [varchar](100) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Table_Update]
	ADD
	CONSTRAINT [PK_c_Table_Update]
	PRIMARY KEY
	CLUSTERED
	([table_name])
	WITH FILLFACTOR=100
	ON [PRIMARY]
GO
GRANT DELETE ON [dbo].[c_Table_Update] TO [cprsystem]
GO
GRANT INSERT ON [dbo].[c_Table_Update] TO [cprsystem]
GO
GRANT REFERENCES ON [dbo].[c_Table_Update] TO [cprsystem]
GO
GRANT SELECT ON [dbo].[c_Table_Update] TO [cprsystem]
GO
GRANT UPDATE ON [dbo].[c_Table_Update] TO [cprsystem]
GO
ALTER TABLE [dbo].[c_Table_Update] SET (LOCK_ESCALATION = TABLE)
GO

