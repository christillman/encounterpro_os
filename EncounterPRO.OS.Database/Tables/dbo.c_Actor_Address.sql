
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Table [dbo].[c_Actor_Address]
Print 'Drop Table [dbo].[c_Actor_Address]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Actor_Address]') AND [type]='U'))
DROP TABLE [dbo].[c_Actor_Address]
GO
-- Create Table [dbo].[c_Actor_Address]
Print 'Create Table [dbo].[c_Actor_Address]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[c_Actor_Address] (
		[actor_id]             [int] NOT NULL,
		[address_sequence]     [int] IDENTITY(1, 1) NOT NULL,
		[description]          [varchar](40) NULL,
		[address_line_1]       [varchar](40) NULL,
		[address_line_2]       [varchar](40) NULL,
		[city]                 [varchar](40) NULL,
		[state]                [varchar](2) NULL,
		[zip]                  [varchar](12) NULL,
		[country]              [varchar](40) NULL,
		[status]               [varchar](12) NOT NULL,
		[created]              [datetime] NOT NULL,
		[created_by]           [varchar](24) NULL,
		[id]                   [uniqueidentifier] NOT NULL,
		[c_actor_id]           [uniqueidentifier] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Actor_Address]
	ADD
	CONSTRAINT [PK_c_Actor_Address_40]
	PRIMARY KEY
	CLUSTERED
	([actor_id], [address_sequence])
	WITH FILLFACTOR=80
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Actor_Address]
	ADD
	CONSTRAINT [DF_c_Actor_Address_created]
	DEFAULT (dbo.get_client_datetime()) FOR [created]
GO
ALTER TABLE [dbo].[c_Actor_Address]
	ADD
	CONSTRAINT [DF_c_Actor_Address_id]
	DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[c_Actor_Address]
	ADD
	CONSTRAINT [DF_c_Actor_Address_status]
	DEFAULT ('OK') FOR [status]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_address_sequence]
	ON [dbo].[c_Actor_Address] ([address_sequence])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
GRANT DELETE ON [dbo].[c_Actor_Address] TO [cprsystem]
GO
GRANT INSERT ON [dbo].[c_Actor_Address] TO [cprsystem]
GO
GRANT SELECT ON [dbo].[c_Actor_Address] TO [cprsystem]
GO
GRANT UPDATE ON [dbo].[c_Actor_Address] TO [cprsystem]
GO
ALTER TABLE [dbo].[c_Actor_Address] SET (LOCK_ESCALATION = TABLE)
GO

