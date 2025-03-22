
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Table [dbo].[c_Equivalence]
Print 'Drop Table [dbo].[c_Equivalence]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Equivalence]') AND [type]='U'))
DROP TABLE [dbo].[c_Equivalence]
GO
-- Create Table [dbo].[c_Equivalence]
Print 'Create Table [dbo].[c_Equivalence]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[c_Equivalence] (
		[object_id]                [uniqueidentifier] NOT NULL,
		[equivalence_group_id]     [int] NULL,
		[created]                  [datetime] NULL,
		[created_by]               [varchar](24) NULL,
		[id]                       [uniqueidentifier] NOT NULL,
		[primary_flag]             [char](1) NOT NULL,
		[object_type]              [varchar](24) NOT NULL,
		[object_key]               [varchar](64) NOT NULL,
		[description]              [varchar](250) NOT NULL,
		[owner_id]                 [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Equivalence]
	ADD
	CONSTRAINT [PK_c_Equivalence_1__11]
	PRIMARY KEY
	NONCLUSTERED
	([object_id])
	WITH FILLFACTOR=70
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Equivalence]
	ADD
	CONSTRAINT [DF__c_Equiv_creat_33]
	DEFAULT (dbo.get_client_datetime()) FOR [created]
GO
ALTER TABLE [dbo].[c_Equivalence]
	ADD
	CONSTRAINT [DF__c_Equiv_id_33]
	DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[c_Equivalence]
	ADD
	CONSTRAINT [DF__c_Equiv_owner_id]
	DEFAULT ((-1)) FOR [owner_id]
GO
ALTER TABLE [dbo].[c_Equivalence]
	ADD
	CONSTRAINT [DF__c_Equiv_primary_flag]
	DEFAULT ('N') FOR [primary_flag]
GO
CREATE UNIQUE CLUSTERED INDEX [idx_c_equivalence_cluster]
	ON [dbo].[c_Equivalence] ([object_type], [object_key])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_equivalence_group_id]
	ON [dbo].[c_Equivalence] ([equivalence_group_id], [object_id])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
GRANT DELETE ON [dbo].[c_Equivalence] TO [cprsystem]
GO
GRANT INSERT ON [dbo].[c_Equivalence] TO [cprsystem]
GO
GRANT SELECT ON [dbo].[c_Equivalence] TO [cprsystem]
GO
GRANT UPDATE ON [dbo].[c_Equivalence] TO [cprsystem]
GO
ALTER TABLE [dbo].[c_Equivalence] SET (LOCK_ESCALATION = TABLE)
GO

