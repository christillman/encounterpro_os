
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Table [dbo].[c_ICD_Properties]
Print 'Drop Table [dbo].[c_ICD_Properties]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_ICD_Properties]') AND [type]='U'))
DROP TABLE [dbo].[c_ICD_Properties]
GO
-- Create Table [dbo].[c_ICD_Properties]
Print 'Create Table [dbo].[c_ICD_Properties]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[c_ICD_Properties] (
	[icd_9_code] [varchar](12) NOT NULL,
		[icd_property_sequence]        [int] IDENTITY(1, 1) NOT NULL,
		[icd_property_type]            [varchar](24) NOT NULL,
		[icd_property_heading]         [varchar](80) NULL,
		[description]                  [varchar](80) NOT NULL,
		[long_description]             [nvarchar](max) NULL,
		[referenced_icd_from_code]     [varchar](12) NOT NULL,
		[referenced_icd_to_code]       [varchar](12) NOT NULL,
		[icd10_code]                   [varchar](12) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_ICD_Properties] SET (LOCK_ESCALATION = TABLE)
GO

