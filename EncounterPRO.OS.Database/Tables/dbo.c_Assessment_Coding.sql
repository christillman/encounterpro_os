
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Table [dbo].[c_Assessment_Coding]
Print 'Drop Table [dbo].[c_Assessment_Coding]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Assessment_Coding]') AND [type]='U'))
DROP TABLE [dbo].[c_Assessment_Coding]
GO
-- Create Table [dbo].[c_Assessment_Coding]
Print 'Create Table [dbo].[c_Assessment_Coding]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[c_Assessment_Coding] (
		[assessment_id]     [varchar](24) NOT NULL,
		[authority_id]      [varchar](24) NOT NULL,
		[icd_9_code] 		[varchar](12) NULL,
		[icd10_code]        [varchar](12) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Assessment_Coding]
	ADD
	CONSTRAINT [PK_c_Assessment_Coding_1]
	PRIMARY KEY
	CLUSTERED
	([assessment_id], [authority_id])
	WITH FILLFACTOR=100
	ON [PRIMARY]
GO
GRANT DELETE ON [dbo].[c_Assessment_Coding] TO [cprsystem]
GO
GRANT INSERT ON [dbo].[c_Assessment_Coding] TO [cprsystem]
GO
GRANT REFERENCES ON [dbo].[c_Assessment_Coding] TO [cprsystem]
GO
GRANT SELECT ON [dbo].[c_Assessment_Coding] TO [cprsystem]
GO
GRANT UPDATE ON [dbo].[c_Assessment_Coding] TO [cprsystem]
GO
ALTER TABLE [dbo].[c_Assessment_Coding] SET (LOCK_ESCALATION = TABLE)
GO

