
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Table [dbo].[u_Top_20]
Print 'Drop Table [dbo].[u_Top_20]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[u_Top_20]') AND [type]='U'))
DROP TABLE [dbo].[u_Top_20]
GO
-- Create Table [dbo].[u_Top_20]
Print 'Create Table [dbo].[u_Top_20]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[u_Top_20] (
		[user_id]             [varchar](24) NOT NULL,
		[top_20_code]         [varchar](64) NOT NULL,
		[top_20_sequence]     [int] IDENTITY(1, 1) NOT NULL,
		[item_text]           [varchar](512) NULL,
		[item_id]             [varchar](64) NULL,
		[item_id2]            [varchar](24) NULL,
		[item_id3]            [int] NULL,
		[sort_sequence]       [int] NULL,
		[hits]                [int] NULL,
		[last_hit]            [datetime] NULL,
		[risk_level]          [int] NULL,
		[created]             [datetime] NULL,
		[item_text_long]      [nvarchar](max) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[u_Top_20]
	ADD
	CONSTRAINT [PK_u_Top_20_40_01]
	PRIMARY KEY
	CLUSTERED
	([user_id], [top_20_code], [top_20_sequence])
	WITH FILLFACTOR=80
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[u_Top_20]
	ADD
	CONSTRAINT [DF__u_Top_20__create__40]
	DEFAULT (dbo.get_client_datetime()) FOR [created]
GO
ALTER TABLE [dbo].[u_Top_20]
	ADD
	CONSTRAINT [DF__u_Top_20__hits__18027DF1]
	DEFAULT ((0)) FOR [hits]
GO
ALTER TABLE [dbo].[u_Top_20]
	ADD
	CONSTRAINT [DF__u_Top_20__last_h__18F6A22A]
	DEFAULT (dbo.get_client_datetime()) FOR [last_hit]
GO
CREATE NONCLUSTERED INDEX [idx_top_20_sequence]
	ON [dbo].[u_Top_20] ([top_20_sequence])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_top_20_item_id]
	ON [dbo].[u_Top_20] ([item_id])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
GRANT DELETE ON [dbo].[u_Top_20] TO [cprsystem]
GO
GRANT INSERT ON [dbo].[u_Top_20] TO [cprsystem]
GO
GRANT REFERENCES ON [dbo].[u_Top_20] TO [cprsystem]
GO
GRANT SELECT ON [dbo].[u_Top_20] TO [cprsystem]
GO
GRANT UPDATE ON [dbo].[u_Top_20] TO [cprsystem]
GO
ALTER TABLE [dbo].[u_Top_20] SET (LOCK_ESCALATION = TABLE)
GO

