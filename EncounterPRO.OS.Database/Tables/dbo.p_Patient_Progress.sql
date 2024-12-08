
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Table [dbo].[p_Patient_Progress]
Print 'Drop Table [dbo].[p_Patient_Progress]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[p_Patient_Progress]') AND [type]='U'))
DROP TABLE [dbo].[p_Patient_Progress]
GO
-- Create Table [dbo].[p_Patient_Progress]
Print 'Create Table [dbo].[p_Patient_Progress]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[p_Patient_Progress] (
		[cpr_id]                        [varchar](12) NOT NULL,
		[patient_progress_sequence]     [int] IDENTITY(1, 1) NOT NULL,
		[encounter_id]                  [int] NULL,
		[user_id]                       [varchar](24) NOT NULL,
		[progress_date_time]            [datetime] NOT NULL,
		[progress_type]                 [varchar](24) NOT NULL,
		[progress_key]                  [varchar](40) NULL,
		[progress_value]                [varchar](40) NULL,
		[progress]                      [nvarchar](max) NULL,
		[attachment_id]                 [int] NULL,
		[patient_workplan_item_id]      [int] NULL,
		[risk_level]                    [int] NULL,
		[current_flag]                  [char](1) NOT NULL,
		[created]                       [datetime] NULL,
		[created_by]                    [varchar](24) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_Patient_Progress]
	ADD
	CONSTRAINT [PK_p_Patient_Progress_1__11]
	PRIMARY KEY
	CLUSTERED
	([cpr_id], [patient_progress_sequence])
	WITH FILLFACTOR=70
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_Patient_Progress]
	ADD
	CONSTRAINT [DF__p_Patient__creat__38652BE2]
	DEFAULT (dbo.get_client_datetime()) FOR [created]
GO
ALTER TABLE [dbo].[p_Patient_Progress]
	ADD
	CONSTRAINT [DF__p_Patient__progr__377107A9]
	DEFAULT (dbo.get_client_datetime()) FOR [progress_date_time]
GO
ALTER TABLE [dbo].[p_Patient_Progress]
	ADD
	CONSTRAINT [DF__p_Patient_progress_curflg]
	DEFAULT ('Y') FOR [current_flag]
GO
CREATE NONCLUSTERED INDEX [idx_pprg_current_flag]
	ON [dbo].[p_Patient_Progress] ([cpr_id], [current_flag], [progress_type], [progress_key])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [PRIMARY]
GO


CREATE NONCLUSTERED INDEX [idx_pprg_cpr_current_flag]
	ON [dbo].[p_Patient_Progress] ([cpr_id], [current_flag])
	INCLUDE ([attachment_id])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [idx_pprg_encounter_id]
	ON [dbo].[p_Patient_Progress] ([cpr_id], [encounter_id])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [idx_pprg_progress_key]
	ON [dbo].[p_Patient_Progress] ([cpr_id], [progress_type], [progress_key])
	INCLUDE ([progress_date_time])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [PRIMARY]
GO

GRANT DELETE ON [dbo].[p_Patient_Progress] TO [cprsystem]
GO
GRANT INSERT ON [dbo].[p_Patient_Progress] TO [cprsystem]
GO
GRANT REFERENCES ON [dbo].[p_Patient_Progress] TO [cprsystem]
GO
GRANT SELECT ON [dbo].[p_Patient_Progress] TO [cprsystem]
GO
GRANT UPDATE ON [dbo].[p_Patient_Progress] TO [cprsystem]
GO
ALTER TABLE [dbo].[p_Patient_Progress] SET (LOCK_ESCALATION = TABLE)
GO

