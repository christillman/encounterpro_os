
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Table [dbo].[p_Observation]
Print 'Drop Table [dbo].[p_Observation]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[p_Observation]') AND [type]='U'))
DROP TABLE [dbo].[p_Observation]
GO
-- Create Table [dbo].[p_Observation]
Print 'Create Table [dbo].[p_Observation]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[p_Observation] (
		[cpr_id]                          [varchar](12) NOT NULL,
		[observation_sequence]            [int] IDENTITY(1, 1) NOT NULL,
		[observation_id]                  [varchar](24) NOT NULL,
		[description]                     [varchar](80) NOT NULL,
		[problem_id]                      [int] NULL,
		[treatment_id]                    [int] NULL,
		[encounter_id]                    [int] NULL,
		[attachment_id]                   [int] NULL,
		[result_expected_date]            [datetime] NULL,
		[observation_tag]                 [varchar](12) NULL,
		[abnormal_flag]                   [char](1) NULL,
		[severity]                        [smallint] NULL,
		[composite_flag]                  [char](1) NULL,
		[parent_observation_sequence]     [int] NULL,
		[stage]                           [int] NULL,
		[stage_description]               [varchar](32) NULL,
		[observed_by]                     [varchar](24) NULL,
		[service]                         [varchar](24) NULL,
		[branch_sort_sequence]            [smallint] NULL,
		[created]                         [datetime] NULL,
		[created_by]                      [varchar](24) NULL,
		[id]                              [uniqueidentifier] NOT NULL,
		[original_branch_id]              [int] NULL,
		[event_id]                        [varchar](40) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_Observation]
	ADD
	CONSTRAINT [PK_p_Observation_1__12]
	PRIMARY KEY
	CLUSTERED
	([cpr_id], [observation_sequence])
	WITH FILLFACTOR=80
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_Observation]
	ADD
	CONSTRAINT [DF__p_Observatio__id__4CE05A84]
	DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[p_Observation]
	ADD
	CONSTRAINT [DF_p_Obs40_composite_21]
	DEFAULT ('N') FOR [composite_flag]
GO
ALTER TABLE [dbo].[p_Observation]
	ADD
	CONSTRAINT [DF_p_Obs40_res_exp_21]
	DEFAULT (dbo.get_client_datetime()) FOR [result_expected_date]
GO
ALTER TABLE [dbo].[p_Observation]
	ADD
	CONSTRAINT [DF_p_Observation_created_21]
	DEFAULT (dbo.get_client_datetime()) FOR [created]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_obs_sequence]
	ON [dbo].[p_Observation] ([observation_sequence])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_obs_treatment]
	ON [dbo].[p_Observation] ([cpr_id], [treatment_id], [observation_sequence])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 80) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [idx_observation_cpr]
ON [dbo].[p_Observation] ([cpr_id],[observation_id])
INCLUDE ([description],[treatment_id],[result_expected_date],[parent_observation_sequence],[service])

CREATE NONCLUSTERED INDEX [idx_observation_cpr_parent]
ON [dbo].[p_Observation] ([cpr_id], [parent_observation_sequence])
INCLUDE ([observation_id], [description], [service])

GRANT DELETE
	ON [dbo].[p_Observation]
	TO [cprsystem]
GO
GRANT INSERT
	ON [dbo].[p_Observation]
	TO [cprsystem]
GO
GRANT REFERENCES
	ON [dbo].[p_Observation]
	TO [cprsystem]
GO
GRANT SELECT
	ON [dbo].[p_Observation]
	TO [cprsystem]
GO
GRANT UPDATE
	ON [dbo].[p_Observation]
	TO [cprsystem]
GO
ALTER TABLE [dbo].[p_Observation] SET (LOCK_ESCALATION = TABLE)
GO

