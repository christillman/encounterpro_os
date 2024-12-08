
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Table [dbo].[c_Assessment_Category]
Print 'Drop Table [dbo].[c_Assessment_Category]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Assessment_Category]') AND [type]='U'))
DROP TABLE [dbo].[c_Assessment_Category]
GO
-- Create Table [dbo].[c_Assessment_Category]
Print 'Create Table [dbo].[c_Assessment_Category]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[c_Assessment_Category] (
		[assessment_type]            [varchar](24) NOT NULL,
		[assessment_category_id]     [varchar](24) NOT NULL,
		[description]                [varchar](80) NULL,
	[sort_order] [smallint] NULL,
	[icd10_start] [varchar](3) NULL,
	[icd10_end] [varchar](3) NULL,
	[is_default] [char](1) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Assessment_Category]
	ADD
	CONSTRAINT [PK_c_Assessment_Category]
	PRIMARY KEY
	CLUSTERED
	([assessment_type], [assessment_category_id])
	WITH FILLFACTOR=100
	ON [PRIMARY]
GO
GRANT DELETE ON [dbo].[c_Assessment_Category] TO [cprsystem]
GO
GRANT INSERT ON [dbo].[c_Assessment_Category] TO [cprsystem]
GO
GRANT REFERENCES ON [dbo].[c_Assessment_Category] TO [cprsystem]
GO
GRANT SELECT ON [dbo].[c_Assessment_Category] TO [cprsystem]
GO
GRANT UPDATE ON [dbo].[c_Assessment_Category] TO [cprsystem]
GO
ALTER TABLE [dbo].[c_Assessment_Category] SET (LOCK_ESCALATION = TABLE)
GO

