
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Table [dbo].[c_Vaccine]
Print 'Drop Table [dbo].[c_Vaccine]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Vaccine]') AND [type]='U'))
DROP TABLE [dbo].[c_Vaccine]
GO
-- Create Table [dbo].[c_Vaccine]
Print 'Create Table [dbo].[c_Vaccine]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[c_Vaccine] (
		[vaccine_id]        [varchar](24) NOT NULL,
		[drug_id]      [varchar](24) NOT NULL,
		[description]       [varchar](200) NULL,
		[status]            [varchar](12) NULL,
		[sort_sequence]     [smallint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Vaccine]
	ADD
	CONSTRAINT [PK_c_Vaccine_1__10]
	PRIMARY KEY
	CLUSTERED
	([vaccine_id])
	WITH FILLFACTOR=100
	ON [PRIMARY]
GO
GRANT DELETE ON [dbo].[c_Vaccine] TO [cprsystem]
GO
GRANT INSERT ON [dbo].[c_Vaccine] TO [cprsystem]
GO
GRANT REFERENCES ON [dbo].[c_Vaccine] TO [cprsystem]
GO
GRANT SELECT ON [dbo].[c_Vaccine] TO [cprsystem]
GO
GRANT UPDATE ON [dbo].[c_Vaccine] TO [cprsystem]
GO
ALTER TABLE [dbo].[c_Vaccine] SET (LOCK_ESCALATION = TABLE)
GO

