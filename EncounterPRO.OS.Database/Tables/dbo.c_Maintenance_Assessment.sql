
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Table [dbo].[c_Maintenance_Assessment]
Print 'Drop Table [dbo].[c_Maintenance_Assessment]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Maintenance_Assessment]') AND [type]='U'))
DROP TABLE [dbo].[c_Maintenance_Assessment]
GO
-- Create Table [dbo].[c_Maintenance_Assessment]
Print 'Create Table [dbo].[c_Maintenance_Assessment]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[c_Maintenance_Assessment] (
		[maintenance_rule_id]         [int] NOT NULL,
		[assessment_id]               [varchar](24) NOT NULL,
		[assessment_current_flag]     [char](1) NULL,
		[primary_flag]                [char](1) NULL,
	[icd_9_code] [varchar](12) NULL,
		[icd10_code]                  [varchar](12) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Maintenance_Assessment]
	ADD
	CONSTRAINT [PK_c_Maintenance_Assmnt_01]
	PRIMARY KEY
	CLUSTERED
	([maintenance_rule_id], [assessment_id])
	WITH FILLFACTOR=100
	ON [PRIMARY]
GO
GRANT DELETE ON [dbo].[c_Maintenance_Assessment] TO [cprsystem]
GO
GRANT INSERT ON [dbo].[c_Maintenance_Assessment] TO [cprsystem]
GO
GRANT REFERENCES ON [dbo].[c_Maintenance_Assessment] TO [cprsystem]
GO
GRANT SELECT ON [dbo].[c_Maintenance_Assessment] TO [cprsystem]
GO
GRANT UPDATE ON [dbo].[c_Maintenance_Assessment] TO [cprsystem]
GO
ALTER TABLE [dbo].[c_Maintenance_Assessment] SET (LOCK_ESCALATION = TABLE)
GO

