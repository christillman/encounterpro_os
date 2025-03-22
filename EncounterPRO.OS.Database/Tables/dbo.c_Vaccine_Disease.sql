
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Table [dbo].[c_Vaccine_Disease]
Print 'Drop Table [dbo].[c_Vaccine_Disease]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Vaccine_Disease]') AND [type]='U'))
DROP TABLE [dbo].[c_Vaccine_Disease]
GO
-- Create Table [dbo].[c_Vaccine_Disease]
Print 'Create Table [dbo].[c_Vaccine_Disease]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[c_Vaccine_Disease] (
		[disease_id]     [int] NOT NULL,
		[vaccine_id]     [varchar](24) NOT NULL,
		[units]          [real] NULL,
	[last_updated] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Vaccine_Disease]
	ADD
	CONSTRAINT [PK_c_Vaccine_Disease_1__14]
	PRIMARY KEY
	CLUSTERED
	([vaccine_id], [disease_id])
	WITH FILLFACTOR=100
	ON [PRIMARY]
GO
GRANT DELETE ON [dbo].[c_Vaccine_Disease] TO [cprsystem]
GO
GRANT INSERT ON [dbo].[c_Vaccine_Disease] TO [cprsystem]
GO
GRANT REFERENCES ON [dbo].[c_Vaccine_Disease] TO [cprsystem]
GO
GRANT SELECT ON [dbo].[c_Vaccine_Disease] TO [cprsystem]
GO
GRANT UPDATE ON [dbo].[c_Vaccine_Disease] TO [cprsystem]
GO
ALTER TABLE [dbo].[c_Vaccine_Disease] SET (LOCK_ESCALATION = TABLE)
GO

