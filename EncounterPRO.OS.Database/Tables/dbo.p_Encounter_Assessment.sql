
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Table [dbo].[p_Encounter_Assessment]
Print 'Drop Table [dbo].[p_Encounter_Assessment]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[p_Encounter_Assessment]') AND [type]='U'))
DROP TABLE [dbo].[p_Encounter_Assessment]
GO
-- Create Table [dbo].[p_Encounter_Assessment]
Print 'Create Table [dbo].[p_Encounter_Assessment]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[p_Encounter_Assessment] (
		[cpr_id]                    [varchar](12) NOT NULL,
		[encounter_id]              [int] NOT NULL,
		[problem_id]                [int] NOT NULL,
		[assessment_sequence]       [smallint] NULL,
		[assessment_billing_id]     [int] NULL,
		[assessment_id]             [varchar](24) NULL,
		[bill_flag]                 [char](1) NOT NULL,
		[created]                   [datetime] NULL,
		[created_by]                [varchar](24) NULL,
		[id]                        [uniqueidentifier] NOT NULL,
	[icd_9_code] [varchar](12) NULL,
		[posted]                    [char](1) NOT NULL,
		[exclusive_link]            [char](1) NOT NULL,
		[icd10_code]                [varchar](12) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_Encounter_Assessment]
	ADD
	CONSTRAINT [PK_p_Encounter_Assessment1__12]
	PRIMARY KEY
	CLUSTERED
	([cpr_id], [encounter_id], [problem_id])
	WITH FILLFACTOR=80
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_Encounter_Assessment]
	ADD
	CONSTRAINT [DF__p_Encounter___id__23A93AC7]
	DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[p_Encounter_Assessment]
	ADD
	CONSTRAINT [DF__p_Encounter___posted__23]
	DEFAULT ('N') FOR [posted]
GO
ALTER TABLE [dbo].[p_Encounter_Assessment]
	ADD
	CONSTRAINT [DF_p_Enc_assmnt_bill_flag_21]
	DEFAULT ('Y') FOR [bill_flag]
GO
ALTER TABLE [dbo].[p_Encounter_Assessment]
	ADD
	CONSTRAINT [DF_p_enc_assmnt_created_21]
	DEFAULT (dbo.get_client_datetime()) FOR [created]
GO
ALTER TABLE [dbo].[p_Encounter_Assessment]
	ADD
	CONSTRAINT [DF_p_Encounter_assm_exclusive_link]
	DEFAULT ('N') FOR [exclusive_link]
GO
GRANT DELETE ON [dbo].[p_Encounter_Assessment] TO [cprsystem]
GO
GRANT INSERT ON [dbo].[p_Encounter_Assessment] TO [cprsystem]
GO
GRANT REFERENCES ON [dbo].[p_Encounter_Assessment] TO [cprsystem]
GO
GRANT SELECT ON [dbo].[p_Encounter_Assessment] TO [cprsystem]
GO
GRANT UPDATE ON [dbo].[p_Encounter_Assessment] TO [cprsystem]
GO
ALTER TABLE [dbo].[p_Encounter_Assessment] SET (LOCK_ESCALATION = TABLE)
GO

