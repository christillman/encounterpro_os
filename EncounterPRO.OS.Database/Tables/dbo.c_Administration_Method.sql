
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Table [dbo].[c_Administration_Method]
Print 'Drop Table [dbo].[c_Administration_Method]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Administration_Method]') AND [type]='U'))
DROP TABLE [dbo].[c_Administration_Method]
GO
-- Create Table [dbo].[c_Administration_Method]
Print 'Create Table [dbo].[c_Administration_Method]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[c_Administration_Method] (
		[administer_method]     [varchar](30) NOT NULL,
		[description]           [varchar](80) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Administration_Method]
	ADD
	CONSTRAINT [PK_c_Administration_Metho1__10]
	PRIMARY KEY
	CLUSTERED
	([administer_method])
	WITH FILLFACTOR=100
	ON [PRIMARY]
GO
GRANT DELETE ON [dbo].[c_Administration_Method] TO [cprsystem]
GO
GRANT INSERT ON [dbo].[c_Administration_Method] TO [cprsystem]
GO
GRANT REFERENCES ON [dbo].[c_Administration_Method] TO [cprsystem]
GO
GRANT SELECT ON [dbo].[c_Administration_Method] TO [cprsystem]
GO
GRANT UPDATE ON [dbo].[c_Administration_Method] TO [cprsystem]
GO
ALTER TABLE [dbo].[c_Administration_Method] SET (LOCK_ESCALATION = TABLE)
GO

