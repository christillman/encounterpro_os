
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Table [dbo].[c_ICD_Updates]
Print 'Drop Table [dbo].[c_ICD_Updates]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_ICD_Updates]') AND [type]='U'))
DROP TABLE [dbo].[c_ICD_Updates]
GO
-- Create Table [dbo].[c_ICD_Updates]
Print 'Create Table [dbo].[c_ICD_Updates]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[c_ICD_Updates] (
	[icd_9_code] [varchar](50) NULL,
		[icd_sequence]               [int] IDENTITY(600, 1) NOT NULL,
		[operation]                  [varchar](50) NOT NULL,
		[new_description]            [varchar](80) NULL,
		[long_description]           [nvarchar](max) NULL,
		[from_description]           [varchar](80) NULL,
		[assessment_type]            [varchar](12) NULL,
		[assessment_category_id]     [varchar](12) NULL,
		[from_icd9]                  [varchar](50) NULL,
		[update_year]                [int] NULL,
		[comment]                    [varchar](80) NULL,
		[assessment_id]              [varchar](24) NULL,
		[icd10_code]                 [varchar](50) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_ICD_Updates]
	ADD
	CONSTRAINT [PK_c_ICD_Updates_128]
	PRIMARY KEY
	CLUSTERED
	([icd_sequence])
	WITH FILLFACTOR=90
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_ICD_Updates]
	ADD
	CONSTRAINT [DF_c_ICD_Updates_operation]
	DEFAULT ('New') FOR [operation]
GO
GRANT SELECT ON [dbo].[c_ICD_Updates] TO [cprsystem]
GO
ALTER TABLE [dbo].[c_ICD_Updates] SET (LOCK_ESCALATION = TABLE)
GO

