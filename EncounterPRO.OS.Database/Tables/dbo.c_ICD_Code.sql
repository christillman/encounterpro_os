
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Table [dbo].[c_ICD_Code]
Print 'Drop Table [dbo].[c_ICD_Code]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_ICD_Code]') AND [type]='U'))
DROP TABLE [dbo].[c_ICD_Code]
GO
-- Create Table [dbo].[c_ICD_Code]
Print 'Create Table [dbo].[c_ICD_Code]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[c_ICD_Code] (
	[icd_9_code] [varchar](12) NOT NULL,
		[description]                             [varchar](80) NOT NULL,
		[long_description]                        [nvarchar](max) NULL,
		[must_code_child_flag]                    [char](1) NULL,
		[nonspecific_code_flag]                   [char](1) NULL,
		[unspecified_code_flag]                   [char](1) NULL,
		[manifestation_code_flag]                 [char](1) NULL,
		[primary_diagnosis_only_flag]             [char](1) NULL,
		[secondary_diagnosis_only_flag]           [char](1) NULL,
		[medicare_secondary_payer_alert_flag]     [char](1) NULL,
		[revision_flag]                           [char](1) NULL,
		[icd10_code]                              [varchar](12) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_ICD_Code] SET (LOCK_ESCALATION = TABLE)
GO

