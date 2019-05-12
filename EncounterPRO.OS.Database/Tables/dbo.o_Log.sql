
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Table [dbo].[o_Log]
Print 'Drop Table [dbo].[o_Log]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[o_Log]') AND [type]='U'))
DROP TABLE [dbo].[o_Log]
GO
-- Create Table [dbo].[o_Log]
Print 'Create Table [dbo].[o_Log]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[o_Log] (
		[log_id]                       [int] IDENTITY(1, 1) NOT NULL,
		[severity]                     [varchar](12) NULL,
		[log_date_time]                [datetime] NULL,
		[caller]                       [varchar](40) NULL,
		[script]                       [varchar](40) NULL,
		[message]                      [varchar](1000) NULL,
		[computer_id]                  [int] NULL,
		[computername]                 [varchar](40) NULL,
		[windows_logon_id]             [varchar](40) NULL,
		[cpr_id]                       [varchar](12) NULL,
		[encounter_id]                 [int] NULL,
		[treatment_id]                 [int] NULL,
		[patient_workplan_item_id]     [varchar](12) NULL,
		[service]                      [varchar](24) NULL,
		[user_id]                      [varchar](24) NULL,
		[scribe_user_id]               [varchar](24) NULL,
		[program]                      [varchar](32) NULL,
		[cleared]                      [datetime] NULL,
		[cleared_by]                   [varchar](12) NULL,
		[os_version]                   [varchar](64) NULL,
		[epro_version]                 [varchar](64) NULL,
		[sql_version]                  [varchar](256) NULL,
		[exception_object]             [binary](1) NULL,
		[id]                           [uniqueidentifier] NOT NULL,
		[caused_by_id]                 [uniqueidentifier] NULL,
		[spid]                         [int] NULL,
		[log_data]                     [text] NULL,
		[component_id]                 [varchar](24) NULL,
		[compile_name]                 [nvarchar](128) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[o_Log]
	ADD
	CONSTRAINT [PK_o_log_21]
	PRIMARY KEY
	CLUSTERED
	([log_id])
	WITH FILLFACTOR=100
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[o_Log]
	ADD
	CONSTRAINT [DF__o_Log__id__6FD627B4]
	DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[o_Log]
	ADD
	CONSTRAINT [DF__o_Log_spid_127]
	DEFAULT (@@spid) FOR [spid]
GO
ALTER TABLE [dbo].[o_Log]
	ADD
	CONSTRAINT [DF_o_log_log_date_time_21]
	DEFAULT (getdate()) FOR [log_date_time]
GO
CREATE NONCLUSTERED INDEX [idx_cpr_encouner]
	ON [dbo].[o_Log] ([cpr_id], [encounter_id])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
GRANT DELETE
	ON [dbo].[o_Log]
	TO [cprsystem]
GO
GRANT INSERT
	ON [dbo].[o_Log]
	TO [cprsystem]
GO
GRANT INSERT
	ON [dbo].[o_Log]
	TO [public]
GO
GRANT REFERENCES
	ON [dbo].[o_Log]
	TO [cprsystem]
GO
GRANT SELECT
	ON [dbo].[o_Log]
	TO [cprsystem]
GO
GRANT SELECT
	ON [dbo].[o_Log]
	TO [public]
GO
GRANT UPDATE
	ON [dbo].[o_Log]
	TO [cprsystem]
GO
ALTER TABLE [dbo].[o_Log] SET (LOCK_ESCALATION = TABLE)
GO

